/*
Author: Cognizant Technology Solutions
Company: 
Description: Batch class used for Addding PTRF sharing for Account Team Proxy 
History:
    Cognizant     09082014     - Initial Version
    Vijay		  03122015	   - added record type check in PTRF sharing logic If device is Customer Device, it will be shared with opportunity Program team members and
    							 device is Internal Device, it will be shared with Account Team Proxy team members
*/



global class BatchAccTeamProxyAdd  implements Database.Batchable<sObject>{
    global String query;
    public DateTime lastBatchRun;
    public DateTime currentTime = DateTime.now();
    public String startTime;
    public String endTime;
   
    public DateTime refDate1;
    public DateTime refDate2;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
       
       List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'};      
       query = 'SELECT Id,Device__c,Customer__c, Device__r.RecordType.DeveloperName FROM PTRF__c WHERE Status__c IN :ptrfStatus';
       
       return Database.getQueryLocator(query);
           
    }
    
    global void execute(Database.BatchableContext BC,List<PTRF__c> ptrfList){
    	
    	if(Swift_Public_Group_Notification__c.getInstance('LastTimeStampAdd').Last_Notified__c != null){
             lastBatchRun = Swift_Public_Group_Notification__c.getInstance('LastTimeStampAdd').Last_Notified__c;
	    }
	    else {
	         Swift_Public_Group_Notification__c tempEnv= [SELECT Last_Notified__c FROM Swift_Public_Group_Notification__c WHERE Name = 'LastTimeStampAdd'];
	         tempEnv.Last_Notified__c = DateTime.now(); 
	         update tempEnv;
	         lastBatchRun = DateTime.now(); 
	    }
    	
        List<PTRF__c> ptrfListWithDevice = new List<PTRF__c>();
        List<PTRF__c> ptrfListWithAccount = new List<PTRF__c>();
        
        List<Id> deviceId = new List<Id>();
        List<Id> accountId = new List<Id>();
        
        List<Device__c> deviceList = new List<Device__c>();
        Map<Id,Id> deviceOppProgramMap = new Map<Id,Id>();
        
        List<Opportunity_Program_Team_Member__c> oppProgTeamList = new List<Opportunity_Program_Team_Member__c>();
        Map<Id,List<Id>> oppProgTeamUserMap = new Map<Id,List<Id>>();
        
        Map<Id,List<Id>> ptrfUserMap = new Map<Id,List<Id>>();
        
        List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
        Map<Id,List<Id>> accountAndTeamProxyMap = new Map<Id,List<Id>>();
        
        PTRF__Share ptrfShareObj;
        List<PTRF__Share> ptrfShareList = new List<PTRF__Share>();
        
        for(PTRF__c ptrfObj : ptrfList){
            if(ptrfObj.Device__c != null && (ptrfObj.Device__r.RecordType.DeveloperName != null && (ptrfObj.Device__r.RecordType.DeveloperName == 'Device' || ptrfObj.Device__r.RecordType.DeveloperName  == 'Read_Only'))){
                ptrfListWithDevice.add(ptrfObj);
                deviceId.add(ptrfObj.Device__c);
            }
            else if(ptrfObj.Customer__c != null) {
                ptrfListWithAccount.add(ptrfObj);
                accountId.add(ptrfObj.Customer__c);
            }
        }
        //PTRF WITH DEVICE 
        List<Id> oppProgIdList = new List<Id>();
        if(ptrfListWithDevice != null && ptrfListWithDevice.size() > 0){
            //Querying Device and making Device Id and Opportunity map
            deviceList = [SELECT Id,Opportunity_Program__c FROM Device__c WHERE Id IN :deviceId];
            for(Device__c deviceObj : deviceList){
                deviceOppProgramMap.put(deviceObj.Id,deviceObj.Opportunity_Program__c);
                oppProgIdList.add(deviceObj.Opportunity_Program__c);
            }
            System.debug('deviceList::'+deviceList);
            
            //Querying opportunity program team member and making opportunity program and user map
            
            String query = 'SELECT Id,User__c,CreatedDate,Opportunity_Program__c FROM Opportunity_Program_Team_Member__c WHERE Opportunity_Program__c IN :oppProgIdList AND CreatedDate < :currentTime AND CreatedDate > :lastBatchRun AND User__r.isActive=true';
            oppProgTeamList = Database.query(query);
            
            
            for(Opportunity_Program_Team_Member__c oppTeamObj : oppProgTeamList){
                if(oppProgTeamUserMap.get(oppTeamObj.Opportunity_Program__c) == null){
                    oppProgTeamUserMap.put(oppTeamObj.Opportunity_Program__c,new List<Id>());
                }
                oppProgTeamUserMap.get(oppTeamObj.Opportunity_Program__c).add(oppTeamObj.User__c);
            }
           
            //Makin ptrf and user map
            for(PTRF__c ptrfObj : ptrfListWithDevice){
                if(deviceOppProgramMap.containsKey(ptrfObj.Device__c)){
                    if(oppProgTeamUserMap.containsKey(deviceOppProgramMap.get(ptrfObj.Device__c))){
                        ptrfUserMap.put(ptrfObj.Id,oppProgTeamUserMap.get(deviceOppProgramMap.get(ptrfObj.Device__c)));
                    }
                }
            }
            
        }
        
        //PTRF WITH ACCOUNT
        if(ptrfListWithAccount != null && ptrfListWithAccount.size() > 0){
            //Querying Account Team Proxy
            accTeamProxyList = [SELECT Id,User__c,Account__c,CreatedDate FROM Account_Team_Proxy__c WHERE Account__c IN :accountId AND CreatedDate > :refDate2 AND CreatedDate < :refDate1 AND User__r.isActive=true ];
            
            for(Account_Team_Proxy__c accTeamProxyObj : accTeamProxyList){
                if(accountAndTeamProxyMap.get(accTeamProxyObj.Account__c) == null){
                    accountAndTeamProxyMap.put(accTeamProxyObj.Account__c,new List<Id>());
                }
                accountAndTeamProxyMap.get(accTeamProxyObj.Account__c).add(accTeamProxyObj.User__c);
            }
            //Makin ptrf and user map
            for(PTRF__c ptrfObj : ptrfListWithAccount){
                if(accountAndTeamProxyMap.containsKey(ptrfObj.Customer__c)){
                    ptrfUserMap.put(ptrfObj.Id,accountAndTeamProxyMap.get(ptrfObj.Customer__c));
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
                 Swift_Public_Group_Notification__c tempEnv= [SELECT Last_Notified__c FROM Swift_Public_Group_Notification__c WHERE Name = 'LastTimeStampAdd'];
                 tempEnv.Last_Notified__c = DateTime.now(); 
                 update tempEnv; 
            }
        }
        BatchAccTeamProxyDelete objbatchhistory  = new BatchAccTeamProxyDelete(); 
        database.executebatch(objbatchhistory,2000);
    }
}