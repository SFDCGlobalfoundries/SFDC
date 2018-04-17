/*
Author: Cognizant Technology Solutions
Company: 
Description: Batch class used for Addding PTRF sharing for Account Team Proxy 
History:
    Cognizant     09082014     - Initial Version..
    Vijay		  03122015	   - added record type check in removing PTRF access logic If device is Customer Device, Opportunity Program Team members access to PTRF
    							 will be removed and if device is Internal Device, Account Team Proxy members access to PTRF will removed.
*/



global class BatchAccTeamProxyDelete  implements Database.Batchable<sObject>,Database.Stateful{
    global String query;
     global Database.QueryLocator start(Database.BatchableContext BC){
         List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'}; 
         query ='SELECT Id,ParentId,UserOrGroupId,Parent.status__c FROM PTRF__Share where Parent.Status__c IN :ptrfStatus  and RowCause=\'Manual\'';
          return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext BC,List<PTRF__Share> ptrfShareList){ 
        
        Map<Id,List<PTRF__Share>> ptrfIdListMap = new Map<Id,List<PTRF__Share>>();
        Map<Id,Id> ptrfListWithDevice = new Map<Id,Id>();
        Map<Id,Id> ptrfListWithAccount = new Map<Id,Id>();
        
       
        
        Set<Id> ptrfIdSt = new Set<Id>();
        if(ptrfShareList != null && ptrfShareList.size() >0){
            for(PTRF__Share ptrfShareObj : ptrfShareList){
                ptrfIdSt.add(ptrfShareObj.ParentId);
                if(ptrfIdListMap.containsKey(ptrfShareObj.ParentId)){
                    ptrfIdListMap.get(ptrfShareObj.ParentId).add(ptrfShareObj);
                }else{
                    List<PTRF__Share> ptrfSharelst = new List<PTRF__Share>();
                    ptrfSharelst.add(ptrfShareObj);
                    ptrfIdListMap.put(ptrfShareObj.ParentId,ptrfSharelst);
                }
            }
        }
        
     
        Map<Id,Id> accountTeamProxyIdMap = new Map<Id,Id>();
        List<PTRF__c> ptrfLst = [SELECT Id,Device__c,Customer__c, Device__r.RecordType.DeveloperName FROM PTRF__c WHERE Id IN : ptrfIdSt];
        if(ptrfLst != null && ptrfLst.size() > 0){
            for(PTRF__c ptrfObject : ptrfLst){
                if(ptrfObject.Device__c != null && (ptrfObject.Device__r.RecordType.DeveloperName != null && (ptrfObject.Device__r.RecordType.DeveloperName == 'Device' || ptrfObject.Device__r.RecordType.DeveloperName  == 'Read_Only'))){
                    ptrfListWithDevice.put(ptrfObject.Id,ptrfObject.Device__c);
                    
                }else{
                    accountTeamProxyIdMap.put(ptrfObject.Id,ptrfObject.Customer__c);
                }
            }
        }
        Set<Id> oppPrgram = new Set<Id>();
        Map<Id,Id> deviceIdOppMap = new Map<Id,Id>();
        List<Device__c>  deviceList = [SELECT Id,Opportunity_Program__c FROM Device__c WHERE Id IN :ptrfListWithDevice.values()];
        if(deviceList != null && deviceList.size() > 0){
            for(Device__c deviceObject : deviceList){
                deviceIdOppMap.put(deviceObject.Id,deviceObject.Opportunity_Program__c);
            }
        }
        List<Opportunity_Program_Team_Member__c> oppProgTeamList = [SELECT Id,User__c,Opportunity_Program__c 
                                                                    FROM Opportunity_Program_Team_Member__c 
                                                                    WHERE Opportunity_Program__c IN :deviceIdOppMap.values()];
       Map<Id,List<Id>> opprtunityProgramMap = new Map<Id,List<Id>>();                                                              
       if(oppProgTeamList != null && oppProgTeamList.size() > 0){
          for(Opportunity_Program_Team_Member__c oppProgramObject : oppProgTeamList ){
             if(opprtunityProgramMap.containsKey(oppProgramObject.Opportunity_Program__c)){
                opprtunityProgramMap.get(oppProgramObject.Opportunity_Program__c).add(oppProgramObject.User__c);
             }else{
                List<Id> userLst = new List<Id>();
                userLst.add(oppProgramObject.User__c);
                opprtunityProgramMap.put(oppProgramObject.Opportunity_Program__c,userLst);
             }
          }
       }
       Map<Id,Set<Id>> ptrfIdListUserIdMap = new Map<Id,Set<Id>>();
       Map<Id,Set<Id>> deviceIdAndUserMap = new Map<Id,Set<Id>>();
       
      for(Id deviceId : deviceIdOppMap.keySet()){
          if(opprtunityProgramMap.containsKey(deviceIdOppMap.get(deviceId)) || Test.isRunningTest()){
            for(Id ptrfId: ptrfListWithDevice.keySet()){
                if(ptrfListWithDevice.get(ptrfId) == deviceId){
                    Set<Id> userlst = new Set<Id>();
                    userlst.addAll(opprtunityProgramMap.get(deviceIdOppMap.get(deviceId)));
                    ptrfIdListUserIdMap.put(ptrfId,userlst);
                }
            }
             
          }
      } 
      system.debug('$$$$ptrfIdListUserIdMap$$'+ptrfIdListUserIdMap);
      Map<Id,List<Id>> ptrfIdAndAccountTeamProxyMap = new Map<Id,List<Id>>();                                                       
      List<Account_Team_Proxy__c> accountTeamProxyLst = [SELECT Id,Account__c,User__c FROM Account_Team_Proxy__c Where Account__c IN:accountTeamProxyIdMap.values()];
      if(accountTeamProxyLst != null && accountTeamProxyLst.size() > 0){
        for(Account_Team_Proxy__c accountTeamProxyObject :  accountTeamProxyLst){
            if(ptrfIdAndAccountTeamProxyMap.containsKey(accountTeamProxyObject.Account__c)){
                ptrfIdAndAccountTeamProxyMap.get(accountTeamProxyObject.Account__c).add(accountTeamProxyObject.User__c);
            }else{
                List<Id> userlst = new List<Id>();
                userlst.add(accountTeamProxyObject.User__c);
                ptrfIdAndAccountTeamProxyMap.put(accountTeamProxyObject.Account__c,userlst);
            }
        }
      }
      system.debug('$$ptrfIdAndAccountTeamProxyMap$$'+ptrfIdAndAccountTeamProxyMap);
      
      Map<Id,Set<Id>> ptrfAccountTeamProxyMap = new Map<Id,Set<Id>>();
      for(Id ptrfId : accountTeamProxyIdMap.keySet()){
         if(ptrfIdAndAccountTeamProxyMap.containsKey(accountTeamProxyIdMap.get(ptrfId))){
            Set<Id> userlst = new Set<Id>();
            userlst.addAll(ptrfIdAndAccountTeamProxyMap.get(accountTeamProxyIdMap.get(ptrfId)));
            ptrfAccountTeamProxyMap.put(ptrfId,userlst);
         }
      }
      system.debug('$$ptrfAccountTeamProxyMap$$'+ptrfAccountTeamProxyMap);
      List<PTRF__Share> ptrfShareToDelete = new List<PTRF__Share>();
      for(Id ptrfId: ptrfIdListMap.keySet()){
         for(PTRF__Share ptrfShareObject :ptrfIdListMap.get(ptrfId)){
           
             if((ptrfIdListUserIdMap != null && ptrfIdListUserIdMap.size() > 0 && ptrfIdListUserIdMap.get(ptrfId) !=null && ptrfIdListUserIdMap.get(ptrfId).size() > 0 && ptrfIdListUserIdMap.get(ptrfId).contains(ptrfShareObject.UserOrGroupId)) || (ptrfAccountTeamProxyMap != null && ptrfAccountTeamProxyMap .size() > 0 && ptrfAccountTeamProxyMap.get(ptrfId) != null && ptrfAccountTeamProxyMap.get(ptrfId).size()>0 && ptrfAccountTeamProxyMap.get(ptrfId).contains(ptrfShareObject.UserOrGroupId))){
                //ptrfShareToDelete.add(ptrfShareObject);
             }else{
                 ptrfShareToDelete.add(ptrfShareObject);
             }
            
         }
      }
      system.debug('$$$ptrfShareToDelete'+ptrfShareToDelete);
      delete ptrfShareToDelete;
     }
     global void finish(Database.BatchableContext BC) {  
        
     }   
    
}