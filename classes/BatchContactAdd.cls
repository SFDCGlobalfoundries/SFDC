/*
Author: Cognizant Technology Solutions
Company: 
Description: Batch class used for Addding PTRF sharing for Customer Contact
History:
    Cognizant     23122014     - Initial Version
*/
global class BatchContactAdd implements Database.Batchable<sObject>{
	global String query;
    public DateTime lastBatchRun;
    public DateTime currentTime = DateTime.now();
    public String startTime;
    public String endTime;

    global Database.QueryLocator start(Database.BatchableContext BC){ 
       
       List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'};      
       query = 'SELECT Id,Device__c,Customer__c FROM PTRF__c WHERE Status__c IN :ptrfStatus';
       
       return Database.getQueryLocator(query);
           
    }
    global void execute(Database.BatchableContext BC,List<PTRF__c> ptrfList){
    	
    	if(Swift_Public_Group_Notification__c.getInstance('CustomerContactAdd').Last_Notified__c != null){
             lastBatchRun = Swift_Public_Group_Notification__c.getInstance('CustomerContactAdd').Last_Notified__c;
	    }
	    else {
	         Swift_Public_Group_Notification__c tempEnv= [SELECT Last_Notified__c FROM Swift_Public_Group_Notification__c WHERE Name = 'CustomerContactAdd'];
	         tempEnv.Last_Notified__c = DateTime.now(); 
	         update tempEnv;
	         lastBatchRun = DateTime.now(); 
	    }
    	
        List<PTRF__c> ptrfListWithContact = new List<PTRF__c>();
        
        List<Id> accountId = new List<Id>();
        
        Map<Id,List<Id>> ptrfUserMap = new Map<Id,List<Id>>();
        
        List<User> contactUserList = new List<User>();
        Map<Id,List<Id>> contactUserMap = new Map<Id,List<Id>>();
        
        PTRF__Share ptrfShareObj;
        List<PTRF__Share> ptrfShareList = new List<PTRF__Share>();
        
        for(PTRF__c ptrfObj : ptrfList){
            if(ptrfObj.Customer__c != null) {
                ptrfListWithContact.add(ptrfObj);
                accountId.add(ptrfObj.Customer__c);
            }
        }
        
        //PTRF WITH ACCOUNT
        if(ptrfListWithContact != null && ptrfListWithContact.size() > 0){
            //Querying User
            contactUserList = [SELECT Id,AccountId,CreatedDate FROM User WHERE AccountId IN :accountId AND IsActive=true AND CreatedDate < :currentTime AND CreatedDate > :lastBatchRun ];
            
            for(User userObj : contactUserList){
                if(contactUserMap.get(userObj.AccountId) == null){
                    contactUserMap.put(userObj.AccountId,new List<Id>());
                }
                contactUserMap.get(userObj.AccountId).add(userObj.Id);
            }
            //Makin ptrf and user map
            for(PTRF__c ptrfObj : ptrfListWithContact){
                if(contactUserMap.containsKey(ptrfObj.Customer__c)){
                    ptrfUserMap.put(ptrfObj.Id,contactUserMap.get(ptrfObj.Customer__c));
                }
            }
        }
        
        if(ptrfUserMap != null && ptrfUserMap.size() > 0){
            for(Id ptrfId : ptrfUserMap.keySet()){
                for(Id userId : ptrfUserMap.get(ptrfId)) { 
                    ptrfShareObj = new PTRF__Share();
                    ptrfShareObj.AccessLevel = 'Read';
                    ptrfShareObj.ParentId = ptrfId;
                    ptrfShareObj.UserOrGroupId = userId;
                    ptrfShareObj.RowCause=Schema.PTRF__Share.RowCause.Customer_Sharing__c;
                    ptrfShareList.add(ptrfShareObj);    
                }
            }
        }
        
        if(ptrfShareList != null && ptrfShareList.size() > 0){
            try{
            	Database.insert(ptrfShareList,false);
            }
            catch(Exception ex){
                
            }
        }
        
       
    }
    global void finish(Database.BatchableContext BC) {
        
        if(!Test.isRunningTest()){
            AsyncApexJob a = [SELECT Id,Status FROM AsyncApexJob WHERE Id =:BC.getJobId()];
            if(a.Status=='Completed')
            {
                 Swift_Public_Group_Notification__c tempEnv= [SELECT Last_Notified__c FROM Swift_Public_Group_Notification__c WHERE Name = 'CustomerContactAdd'];
                 tempEnv.Last_Notified__c = DateTime.now(); 
                 update tempEnv; 
            }
        }
    }
	

}