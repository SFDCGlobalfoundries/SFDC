/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Description: This batch class is used to share the collaborator records with newly added FAE's in 'Account Team Proxy'.
    History: Harsha:22/12/16
**/ 
global class BatchAccTeamProxyFaeShare  implements Database.Batchable<sObject>{
    global String query;
     Date currentTime = Date.Today();
   list<String> teamRoles=new list<String>{'Field Application Engineer','Primary Field Application Engineer'};
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
       query= 'SELECT Id,IsCustomerAcceptsRisk__c,Created_By_Shortname__c,Submitted_By_Shortname__c,Selected_AM__c,Selected_Customers__c,Waiver_Status__c,IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_releasedToCustomer__c,Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,Account__c,Approval_Field_Engineer__c,Created_Date__c,Customer_Full_Name__c,customer_Options__c,DFM_Service_DRCPLUS__c,DRC_Deck_Version__c,FAB__c,isAllPartyApproved__c,Prime_Die_Name__c,PTSR_Number__c,PTSR_Service_Type__c,PTSR_Status__c,Workflow_Status__c FROM Wavier_Collaborator__c ' ;      
       return Database.getQueryLocator(query);
           
    }
    
    global void execute(Database.BatchableContext BC,List<Wavier_Collaborator__c> WaiverList){
    List<Wavier_Collaborator__c> WaiverListWithAccount = new List<Wavier_Collaborator__c>();
        
       
        List<Id> accountId = new List<Id>();
        
        Map<Id,List<Id>> WaiverUserMap = new Map<Id,List<Id>>();
        
        List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
        Map<Id,List<Id>> accountAndTeamProxyMap = new Map<Id,List<Id>>();
        
        Wavier_Collaborator__Share WaiverShareObj;
        List<Wavier_Collaborator__Share> WaiverShareList = new List<Wavier_Collaborator__Share>();
        
        for(Wavier_Collaborator__c WaiverObj : WaiverList){
           { if(WaiverObj.Account__c != null){}
                WaiverListWithAccount.add(WaiverObj);
                accountId.add(WaiverObj.Account__c);
            }
            
        }
  
            
        
        
        //collaborator WITH ACCOUNT
        if(WaiverListWithAccount != null && WaiverListWithAccount.size() > 0){
            //Querying Account Team Proxy
		 accTeamProxyList = [SELECT Id,Team_Role__c,User__r.Name,User__c,Account__c 
                   FROM Account_Team_Proxy__c
                   WHERE((Team_Role__c IN ('Field Application Engineer','Primary Field Application Engineer')) OR (Team_Role__c IN ('Account Manager','Primary Account Manager') AND Is_FAE__c=true))
                   AND Account__c IN :accountId AND CreatedDate >= :currentTime AND User__r.isActive=true];
   
                system.debug('----------->'+accTeamProxyList);
            for(Account_Team_Proxy__c accTeamProxyObj : accTeamProxyList){
                if(accountAndTeamProxyMap.get(accTeamProxyObj.Account__c) == null){
                    accountAndTeamProxyMap.put(accTeamProxyObj.Account__c,new List<Id>());
                }
                accountAndTeamProxyMap.get(accTeamProxyObj.Account__c).add(accTeamProxyObj.User__c);
            }
            // collaborator with  user map
            for(Wavier_Collaborator__c WaiverObj : WaiverListWithAccount){
                if(accountAndTeamProxyMap.containsKey(WaiverObj.Account__c)){
                    WaiverUserMap.put(WaiverObj.Id,accountAndTeamProxyMap.get(WaiverObj.Account__c));
                }
            }
        }
        
        if(WaiverUserMap != null && WaiverUserMap.size() > 0){
            for(Id WaiverId : WaiverUserMap.keySet()){
                for(Id userId : WaiverUserMap.get(WaiverId)) { 
                    WaiverShareObj = new Wavier_Collaborator__Share();
                    WaiverShareObj.AccessLevel = 'Read';
                    WaiverShareObj.ParentId = WaiverId;
                    WaiverShareObj.UserOrGroupId = userId;
                    WaiverShareList.add(WaiverShareObj);    
                }
            }
        }
        
        if(WaiverShareList != null && WaiverShareList.size() > 0){
            try{
                Database.insert(WaiverShareList,false);
            }
            catch(Exception ex){
             GlobalUtility.logMessage('Debug', 'BatchAccTeamProxyFaeShare', 'Execute()', String.valueOf(WaiverShareList), 'accountteam proxy', 'exception occured', 'payLoad','Other SFDC',ex, 2300);   
            }
        }
              
    }
    global void finish(Database.BatchableContext BC) {
      
}
}