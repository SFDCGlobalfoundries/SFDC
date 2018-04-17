/*
    Author: Navneet Rajput
    Description: Trigger Handles all after operation on GMPL_BX009. 
    History:
        NRajput     03182014    - code creation.
        ARoy        04012014    - added code to call the NPCFormApprovalSendEmail class for email.
        ARoy        04302014    - added code to update the BX009 Variant ID NO custom setting.
        ARoy        06112014    - code modified to add the skipped logic for Integration User for email notification.          
*/
 
trigger GMPL_AfterTrigger on GMPL_BX009__c (after delete, after insert, 
                                           after undelete,after update) { 

    GMPL_GMPLAfterOperationHandler handler = new GMPL_GMPLAfterOperationHandler(true); 
    
    // After Insert
    if (Trigger.isAfter && Trigger.isInsert){
        
        handler.OnAfterInsert(Trigger.new);
        
        // Give Permission for the Region Head and Region Head Backup
        //***************************************************************************//
        Map<Id,Set<Id>> gmplRegionHeadAndBackupMap = new Map<Id,Set<Id>>();
        List<String> variantList = new List<String>();
        
        for(GMPL_BX009__c gmpl : Trigger.new){
            Set<Id> regAndBackupHeadSet = new Set<Id>();
            if(gmpl.Region_Head__c != null){
                regAndBackupHeadSet.add(gmpl.Region_Head__c);
            }
            if(gmpl.Region_Head_Backup__c != null){
                regAndBackupHeadSet.add(gmpl.Region_Head_Backup__c);
            }
            if(regAndBackupHeadSet.size()>0){
                gmplRegionHeadAndBackupMap.put(gmpl.Id,regAndBackupHeadSet);
            }
            // Check the Variant field for 'To Be Assigned by PPM 0001'
            //************************************************************************//
            
            if(gmpl.Variant__c != null && gmpl.Variant__c.contains('To Be Assigned by PPM')){
                variantList.add(gmpl.Variant__c);
            }
            
            //************************************************************************//
        }
        
        // Update the BX009 Variant ID No field of custom setting
        //***************************************************************************//
        try{
            if(variantList.size()>0){
                Integer variantInt = 0;
                for(String var : variantList){
                    var = var.substring(22);
                    if(var != null){                    
                        if(variantInt < Integer.valueOf(var)){
                            variantInt = Integer.valueOf(var)+1;
                        }                    
                    }
                }
                if(variantInt != 0){
                    String tempVariant = EnvironmentVariable.get('BX009_VARIANT_ID_NO');
                    tempVariant = tempVariant.substring(22);
                    if(variantInt < Integer.valueOf(tempVariant)){
                        variantInt = Integer.valueOf(tempVariant)+1;
                    }
                    EnvironmentVariable.put('BX009_VARIANT_ID_NO','To Be Assigned by PPM '+String.valueOf(variantInt));
                }
                
            }
        }catch(Exception e){
            system.debug('Exception :: '+e.getMessage());
        }
        //***************************************************************************//
        
        
        if(gmplRegionHeadAndBackupMap.size()>0){
            GMPL_GMPLAfterOperationHandler.addtoGMPLShare(gmplRegionHeadAndBackupMap);
        }
        //***************************************************************************//
        
    } 
    // After Update 
    else if (Trigger.isAfter && Trigger.isUpdate){
        
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap,Trigger.oldMap);
        
        // Added for calling GMPL/BX009 Notification Service        
        if(!GMPLBX009NotificationEmail.hasRun && !IntegrationUserUtil.isSkipTrigger()){
            GMPLBX009NotificationEmail.sendMail(trigger.new,trigger.oldMap);
            GMPLBX009NotificationEmail.hasRun = true;
        }
        
        // Update Permission for the Region Head and Region Head Backup
        //***************************************************************************//
        //Removing the old permission
        Set<Id> gmplIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(GMPL_BX009__c gmpl : Trigger.old){
            if((gmpl.Region_Head__c != null && gmpl.Region_Head__c != trigger.newMap.get(gmpl.Id).Region_Head__c)
                || (gmpl.Region_Head_Backup__c != null && gmpl.Region_Head_Backup__c != trigger.newMap.get(gmpl.Id).Region_Head_Backup__c)){
                gmplIds.add(gmpl.Id);
            }
            if(gmpl.Region_Head__c != null && gmpl.Region_Head__c != trigger.newMap.get(gmpl.Id).Region_Head__c){
                userIds.add(gmpl.Region_Head__c);
            }
            if(gmpl.Region_Head_Backup__c != null && gmpl.Region_Head_Backup__c != trigger.newMap.get(gmpl.Id).Region_Head_Backup__c){
                userIds.add(gmpl.Region_Head_Backup__c);
            }
        }
        if(gmplIds.size()>0){
            GMPL_GMPLAfterOperationHandler.removeFromGMPLShare(gmplIds,userIds);
        }
        
        // Give New Permission for the Region Head and Region Head Backup
        Map<Id,Set<Id>> gmplRegionHeadAndBackupMap = new Map<Id,Set<Id>>();
        for(GMPL_BX009__c gmpl : Trigger.new){
            Set<Id> regAndBackupHeadSet = new Set<Id>();
            if(gmpl.Region_Head__c != null && gmpl.Region_Head__c != trigger.oldMap.get(gmpl.Id).Region_Head__c){
                regAndBackupHeadSet.add(gmpl.Region_Head__c);
            }
            if(gmpl.Region_Head_Backup__c != null && gmpl.Region_Head_Backup__c != trigger.oldMap.get(gmpl.Id).Region_Head_Backup__c){
                regAndBackupHeadSet.add(gmpl.Region_Head_Backup__c);
            }
            if(regAndBackupHeadSet.size()>0){
                gmplRegionHeadAndBackupMap.put(gmpl.Id,regAndBackupHeadSet);
            }
        }
        if(gmplRegionHeadAndBackupMap.size()>0){
            GMPL_GMPLAfterOperationHandler.addtoGMPLShare(gmplRegionHeadAndBackupMap);
        }
        
        //***************************************************************************//
        
    }    

}