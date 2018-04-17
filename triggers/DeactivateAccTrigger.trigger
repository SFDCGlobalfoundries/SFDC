/*
Type Name: DeactivateAccTrigger 
Author: Cognizant
Created Date: 12-April-2013
Reason: This trigger is used for inactivation of the portal users related to inactive account. 
Change History: This trigger is being futher modified to accomodate NDA related changes on Account.
Author: 
Modified Date: 02-Sep-2013
Reason: 
……..
……..
*/
trigger DeactivateAccTrigger on Account (after update,before Insert)
{   
     //Tlai   31072014
    if(AcctRegHeadMappingTgrHandler.bypassAcctTrigger) return;
    
    if(Trigger.isAfter && Trigger.isUpdate){
    List<Id> totalaccountId=new List<Id>();
    List<Account> accountList=new List<Account>(); 
    Map<Id,String> mapAccOldValues = new Map<Id,String>() ; 
    Map<Id,String> mapAccNewValues = new Map<Id,String>() ;
    Map<ID,String> AsicAccountsNew = new Map<ID,String>() ; 
    Map<ID,String> AsicAccountsOld = new Map<ID,String>() ; 
        
    Set<Id> lstNewTriggerSet=new Set<Id>();
    Set<Id> lstOldTriggerSet=new Set<Id>();
    List<Id> accIdList=new List<Id>();
/*--------- fetching the list of inactive accounts and adding it to the list------------------------------------------------------------*/
    for (Integer iCount=0;iCount<trigger.new.size();iCount++)
    {
        if (trigger.new[iCount].Stage__c=='Inactive' && trigger.old[iCount].Stage__c!='Inactive')
        {
            accountList.add(trigger.new[iCount]);   
            accIdList.add(trigger.new[iCount].Id);
        }
    }
/*----fetching all the portal users related to the inactive accounts------------------------------------------------*/    
    if (accIdList.size()>0)
    {  
        //Calling the class usertriggerHandler for inactivating the contact for portal access
        Set<Id> inactiveUserId=new Set<Id>();
        for (User objUser:[SELECT Id FROM User where AccountId IN :accIdList])
        {
            inactiveUserId.add(objUser.Id);     
        }
/*calling the class  UserTriggerHandler------------*/      
        ClsUserTriggerHandler.updateContactPortalStatusProxy(inactiveUserId,'Update',true);
        
        //calling the class ClsAccTriggerHandler     
        ClsAccTriggerHandler.deactivateAccount(accIdList);
        
    }  
//adding the account ids in a list
       for(account accobj:trigger.new)
        {
         totalaccountId.add(accobj.Id);
        } 
        
        if(totalaccountId.size()>0)
        {
           system.debug('@@@@@@ enter trigger');
     // calling the method updateManager of the class ClsAccTriggerHandler   
            ClsAccTriggerHandler.updateManager(totalaccountId);
        }
// Calling Document Provisioning records update based on Valid Tech Geos, Tech Geo Granted or Has Valid NDA fields
list<account> lstNewTrigger=new list<account>();
list<account> lstOldTrigger=new list<account>();
for(account acc:Trigger.New){
    Map<String,String> mapMyInner = new Map<String,String>() ; 
        
    
    String oldVal = '' ; 
    String newVal = '' ;
    if(acc.Valid_Tech_Geos__c!= Trigger.oldmap.get(acc.id).Valid_Tech_Geos__c || acc.Tech_Geo_Granted__c!= Trigger.oldmap.get(acc.id).Tech_Geo_Granted__c || acc.Has_Valid_NDA__c!= Trigger.oldmap.get(acc.id).Has_Valid_NDA__c )
    {
        lstNewTrigger.add(acc);
        lstOldTrigger.add(Trigger.oldmap.get(acc.id)); 
        lstNewTriggerSet.add(acc.Id); 
        lstOldTriggerSet.add(Trigger.oldmap.get(acc.id).Id);  
        oldVal =  Trigger.oldmap.get(acc.id).Valid_Tech_Geos__c + '#' + Trigger.oldmap.get(acc.id).Tech_Geo_Granted__c + '#' + String.valueOf(Trigger.oldmap.get(acc.id).Has_Valid_NDA__c) ; 
        newval =  acc.Valid_Tech_Geos__c + '#' + acc.Tech_Geo_Granted__c + '#' + String.valueOf(acc.Has_Valid_NDA__c) ;
    
        mapAccOldValues.put(acc.id,oldVal ) ; 
        mapAccNewValues.put(acc.id,newVal ) ;
    }
    if(acc.Authorized_for_ASIC_business__c != Trigger.oldmap.get(acc.id).Authorized_for_ASIC_business__c )
    {
        AsicAccountsNew.put(acc.ID,acc.Authorized_for_ASIC_business__c);
        AsicAccountsOld.put(acc.ID,Trigger.oldmap.get(acc.id).Authorized_for_ASIC_business__c);        
    }    
    
} 

System.debug('Krishanu----mapAccOldValues---'+mapAccOldValues) ;  
if(!mapAccOldValues.isEmpty() && !mapAccNewValues.isEmpty()){
    if(System.isFuture() || System.isBatch()){
        System.debug(LoggingLevel.WARN,'Inside Future or Batch context ---');
       
        clsUpdateDocProvisioningHandler.delegateHandleDocProvisioningUpdate(mapAccNewValues,mapAccOldValues);
        clsUpdateDocProvisioningHandler.handleDocProvisioningUpdateASIC(mapAccNewValues,mapAccOldValues);
        ClsCpkReportProvisioningHandlerCallout.customerCpkProvisioningUpdateGeometry(mapAccNewValues,mapAccOldValues); 
    } 
    else{
        System.debug(LoggingLevel.WARN,'Inside synchronous context---');

        clsUpdateDocProvisioningHandler.delegateHandleDocProvisioningUpdateFuture(mapAccNewValues,mapAccOldValues); // New
        clsUpdateDocProvisioningHandler.handleDocProvisioningUpdateASICFuture(mapAccNewValues,mapAccOldValues);  
        ClsCpkReportProvisioningHandlerCallout.customerCpkProvisioningUpdateGeometryFuture(mapAccNewValues,mapAccOldValues); 
    }
}

if(!AsicAccountsOld.isEmpty() && !AsicAccountsNew.isEmpty()){
    //if(System.isFuture() || System.isBatch()){
        System.debug(LoggingLevel.WARN,'Inside Future or Batch context ---');       
      //  clsUpdateDocProvisioningHandler.handleDocProvisioningUpdateASIC(AsicAccountsNew,AsicAccountsOld);
        //ClsCpkReportProvisioningHandlerCallout.customerCpkProvisioningUpdateASIC(AsicAccountsNew,AsicAccountsOld);
    //} 
   // else{
        System.debug(LoggingLevel.WARN,'Inside synchronous context---');
        clsUpdateDocProvisioningHandler.handleDocProvisioningUpdateASICFuture(AsicAccountsNew,AsicAccountsOld);  
        ClsCpkReportProvisioningHandlerCallout.customerCpkProvisioningUpdateASICFuture(AsicAccountsNew,AsicAccountsOld);
    //}
}


}

//Default Tech Geo Granted during account insert && Default valid tech geos from parent account Agreements(NDA)
if(Trigger.isInsert && Trigger.isBefore){
set<id> ParentIds = new set<id>();
map<id,account> mapParentAcc=new map<id,account>();

//Get all Tech Geo values that need to be defaulted
List<DefaultTechnologyGeometries__c> dtg = DefaultTechnologyGeometries__c.getall().values();
for(account acc:Trigger.New){
    for(DefaultTechnologyGeometries__c tech :dtg){
        if(acc.Tech_Geo_Granted__c!=null && !acc.Tech_Geo_Granted__c.contains(tech.Name)){
            acc.Tech_Geo_Granted__c=acc.Tech_Geo_Granted__c+';'+tech.Name;    
        }
        else if(acc.Tech_Geo_Granted__c==null){
            acc.Tech_Geo_Granted__c=tech.Name;
        }
    }
    if(acc.parentid!=null){
        ParentIds.add(acc.parentid);
    }
    if(!ParentIds.isEmpty()){
        for(account acnt:[select id,Has_Valid_NDA__c,Valid_Tech_Geos__c from account where id in :ParentIds]){
            if(acnt.Has_Valid_NDA__c)
                mapParentAcc.put(acnt.id,acnt);
        }
    }
}
//Populate valid tech geometries and Has Valid NDA from parent account during child inserts
for(account acc:Trigger.New){
    if(mapParentAcc!=null && mapParentAcc.containskey(acc.parentid)){
        acc.Has_Valid_NDA__c = mapParentAcc.get(acc.parentid).Has_Valid_NDA__c;
        acc.Valid_Tech_Geos__c= mapParentAcc.get(acc.parentid).Valid_Tech_Geos__c;
    }
}
}
}