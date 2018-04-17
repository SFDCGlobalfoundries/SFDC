/*
Type Name: clsUpdateDocProvisioningHandler Apex Class
Author: Cognizant
Created Date: 30-August-2013
Reason:
Change History:
Updated by Navneet :- Code formatting and updated conditions related New PDK design
Date :- 27 Dec 2014

* @ Author: Sunita
* @ Modified Date: 7/21/2015
* @ Reason: Case 38803 - account reprovisioning
* @ Author - Prajnith Karra
Date-: 15/5/2015
line 1290-1320 - Remove Blacklisted DPs from updating
*/
public without sharing class clsUpdateDocProvisioningHandler{
/*Modified By Cognizant for CR # 15680 starts*/
    @Future(callout=true)
    public static void delegateHandleDocProvisioningUpdateFuture(Map<Id,string> accNewValMap,Map<Id,string> accOldValMap){
        System.debug(LoggingLevel.Info,'Inside delegateHandleDocProvisioningUpdateFuture method ---');
        delegateHandleDocProvisioningUpdate(accNewValMap,accOldValMap);
    }
    public static void delegateHandleDocProvisioningUpdate(Map<Id,string> accNewValMap,Map<Id,string> accOldValMap){
//system.debug('krishanu----lstNewTriggerSet----'+lstNewTriggerSet) ; 
        system.debug('krishanu----accOldMap----'+accNewValMap);
        system.debug('krishanu----accOldMap----'+accOldValMap);
//system.debug('krishanu----lstOldTriggerSet----'+lstOldTriggerSet) ; 
        list<account> oldtrigger=new  list<account>();
        list<account> newtrigger=new  list<account>();
//Map<Id,Account> newTriggerMap=new Map<Id,Account>([select Id,Has_Valid_NDA__c,Valid_Tech_Geos__c,Tech_Geo_Granted__c from Account where Id IN : accOldValMap.keySet()]);
//list<account> oldtrigger=[select Id,Has_Valid_NDA__c,Valid_Tech_Geos__c,Tech_Geo_Granted__c from Account where id IN : lstOldTriggerSet];
        for(Id accId:accOldValMap.keySet()){
            List<string> fieldValList1=accOldValMap.get(accId).split('#');
            List<string> fieldValList2=accNewValMap.get(accId).split('#');
            Account accOldRec=new  Account();
            Account accNewRec=new  Account();
            accOldRec.Id=accId;
            accNewRec.Id=accId;
//accOldRec=newTriggerMap.get(accId );
            if(!fieldValList1.isEmpty()){
                accOldRec.Valid_Tech_Geos__c=(fieldValList1.get(0)!=null)?fieldValList1.get(0):'';
                accOldRec.Tech_Geo_Granted__c=(fieldValList1.get(1)!=null)?fieldValList1.get(1):'';
                accOldRec.Has_Valid_NDA__c=(fieldValList1.get(2)!=null&&fieldValList1.get(2).equalsIgnoreCase('true'))?true:false;
            }
            if(!fieldValList2.isEmpty()){
                accNewRec.Valid_Tech_Geos__c=(fieldValList2.get(0)!=null)?fieldValList2.get(0):'';
                accNewRec.Tech_Geo_Granted__c=(fieldValList2.get(1)!=null)?fieldValList2.get(1):'';
                accNewRec.Has_Valid_NDA__c=(fieldValList2.get(2)!=null&&fieldValList2.get(2).equalsIgnoreCase('true'))?true:false;
            }
            oldtrigger.add(accOldRec);
            newtrigger.add(accNewRec);
        }
        system.debug('krishanu----oldtriggerList----'+oldtrigger);
        clsUpdateAccDPProvisioningHandler.handleDocProvisioningUpdate(newtrigger,oldtrigger);
    }
    @Future(callout=true)
    public static void handleDocProvisioningUpdateASICFuture(Map<Id,string> accNewValMap,Map<Id,string> accOldValMap){
        handleDocProvisioningUpdateASIC(accNewValMap,accOldValMap);
    }
    public static void handleDocProvisioningUpdateASIC(Map<Id,string> accNewValMap,Map<Id,string> accOldValMap){
        list<account> oldtrigger=new  list<account>();
        list<account> newtrigger=new  list<account>();
        for(Id accId:accOldValMap.keySet()){
            string fieldValList1=accOldValMap.get(accId);
            string fieldValList2=accNewValMap.get(accId);
            Account accOldRec=new  Account();
            Account accNewRec=new  Account();
            accOldRec.Id=accId;
            accNewRec.Id=accId;
            if(!string.isEmpty(fieldValList1))accOldRec.Authorized_for_ASIC_business__c=fieldValList1;
            else accOldRec.Authorized_for_ASIC_business__c='';
            if(!string.isEmpty(fieldValList2))accNewRec.Authorized_for_ASIC_business__c=fieldValList2;
            else accNewRec.Authorized_for_ASIC_business__c='';
            oldtrigger.add(accOldRec);
            newtrigger.add(accNewRec);
        }
        clsUpdateAccDPProvisioningHandler.handleDocProvisioningUpdate(newtrigger,oldtrigger);
    }
}