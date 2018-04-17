/*
Type Name: PackageTrigger
Author: Cognizant
Created Date: 30-June-2013
Reason: This trigger handles provisioning of Package for General Release as well as de-provisioning of Package for Draft status.
Change History:Case-4853
Author: Cognizant FV Team
Modified Date: 26-01-2014
Reason: Handling Provisioning/De-Provisioning for General release Packages
Change History:Case-5022
Author: Cognizant FV Team
Modified Date: 21-03-2014
Reason: Validation to check package edit based on child Specs Release status for Package with Release status as 'General Release'
……..
*/
trigger PackageTrigger on Package__c (before insert, before Update,After Update) { //Before update event added for Case#5022

    /******** Added By Cognizant for Case # 5022 starts *******/
    
    if(Trigger.isBefore && Trigger.isUpdate){
    
        Set<Id> specIdSet=new Set<Id>(); // Set to hold child spec Ids of a package
        Set<Id> pckIdSet=new Set<Id>();  // Set to hold General Release status package Ids
        
        
        for(Package__c pckObj : Trigger.New)
        {
            // Code to check 'General Release' status for Package & populate corresponding set of Package Ids
            
            if(Trigger.NewMap.get(pckObj.Id).Package_Release_Status__c!=Trigger.oldMap.get(pckObj.Id).Package_Release_Status__c && Trigger.NewMap.get(pckObj.Id).Package_Release_Status__c=='General Release')
            {                        System.Debug('Inside first if ---' );
    
               pckIdSet.add(pckObj.Id);
            }
        }
        
        // Validation code to block package release status as 'General Release' for 'Non General Release' status of child specs

        if(!pckIdSet.isEmpty())
        {
            //List of Package Spec corresponding to General Release packages and 'Non General Release' status of child specs
            
            List<Package_Spec__c> lstPckgSpec = new List<Package_Spec__c>([Select Id, Design_Spec__c, Package__c from Package_Spec__c where Package__c IN :pckIdSet AND Design_Spec__c!=null AND Design_Spec__r.Release_Status__c!='General Release']); 
            
            for(Package_Spec__c psObj:lstPckgSpec )
            {
                specIdSet.add(psObj.Design_Spec__c); //Collecting specs belonging to a package
            }
            Map<Id,Design_Spec__c> specMap=new Map<Id,Design_Spec__c>([select id,name,Release_status__c from Design_Spec__c where id in :specIdSet]); // Map of specs belonging to updated package
            SYstem.debug('Map val ---'+specMap);
            Map<Id,String> errMsgMap=new Map<Id,String>(); // Map to contain error msg to be displayed as per the package
            
            //Code to populate error Msg Map
            
            if(!lstPckgSpec.isEmpty())
            {
                for(Package_Spec__c psObj:lstPckgSpec )
                {   
                    if(!errMsgMap.containsKey(psObj.Package__c))
                    {
                        errMsgMap.put(psObj.Package__c,'- '+((specMap.containsKey(psObj.Design_Spec__c) && specMap.get(psObj.Design_Spec__c).name!=null)?specMap.get(psObj.Design_Spec__c).name:''));
                    }
                    else
                    {
                        errMsgMap.put(psObj.Package__c,errMsgMap.get(psObj.Package__c)+','+((specMap.containsKey(psObj.Design_Spec__c) && specMap.get(psObj.Design_Spec__c).name!=null)?specMap.get(psObj.Design_Spec__c).name:''));
 
                    }
                    System.debug('package id:'+psObj.Package__c+'condition check'+((specMap.containsKey(psObj.Design_Spec__c) && specMap.get(psObj.Design_Spec__c).name!=null))+'err Map val ---'+errMsgMap);

                }
                
                System.debug('err Map val ---'+errMsgMap);
                //Bulk Handling of packages for validation errors 
            
                for(Id pckObjId :pckIdSet)
                {
                    if(errMsgMap.containsKey(pckObjId))
                    {
                        Trigger.NewMap.get(pckObjId).addError(errMsgMap.get(pckObjId)+' '+Label.Gen_Rel_Pack_Vldtn_Err_Msg);
                    }  
                }
            
            }
            

        
        }
    }

/******** Added By Cognizant for Case # 5022 ends *******/
if(Trigger.isAfter){
    PackageTriggerHandler handler=new PackageTriggerHandler();
    // This method will handle de-provisioning for Draft packages.
    handler.deProvisionDraftPackage(trigger.new,trigger.old);
       //Case-4853 Start
    //This method handles de-provisioning for White List Specs for a General Release to Draft package.
    handler.deProvisionWLSpecsDraftPackage(trigger.new,trigger.old);
    //This method handles provisioning for Specs for a General Release package.
    //handler.provisionGeneralReleasePackageSpec(trigger.new,trigger.old);
    handler.provisionGeneralReleasePackageWhiteListSpec(trigger.new,trigger.old);
    //Case-4853 End
}
if(trigger.isBefore && trigger.isInsert){
    for(Package__c pck:trigger.new){
        pck.Sync_With_OpenText__c = false;
        pck.DateTime_Last_Synced_With_OpenText__c = null;
        pck.OpenText_Error_Message__c = null;
        pck.OpenText_Id__c = null;      
    }   
}

}