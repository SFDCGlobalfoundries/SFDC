/*
  Author: Anirban Roy
  Description: Trigger on Opportunity_Program_Team_Member__c object .
  History:
    ARoy        02192013    - code creation.
    Nbustillos  02252013    - Remove duplicate check code and suggested to move checking on the VF page.
    Nbustillos  03122013    - Moved code logic of creating sharing records to OppyTeamManager class.
                              Removed unused variables.insertDeviceShare
    ARoy        03142013    - Added custom exception messages.     
    Asolito     09132013    - Added deleted record functionality                         
    Asolito     12172013    - added skip trigger check
    ARoy        12182013    - added deleted records functionality from before delete to after delete 
    TLai        13042014    - Added before insert before update event. copied field update logic from workflow 'Oppty Program Team Member - Outbound Message - To AIA'
    Poulami     12062017    - Removed package sharing related code
*/

trigger OppProgTeamMember on Opportunity_Program_Team_Member__c (after delete, after insert, after update, before insert, before update) {
    //Asolito 12172013
    //skip trigger check
    if(!IntegrationUserUtil.isSkipTrigger()){
        if(trigger.isAfter){
            // Insert the records in Opportunity_Program__Share,Device__Share,
            // Customer_Requirement__Share(Option share),Package_Data__Share
            if(trigger.isInsert){
    
                try{
                    set <Id> setActiveUserIDs = new set <Id>();
                    set <Id> setOppProgIDs = new set <Id>();
                    set<Id> setUserId = new set<Id>();
                    
                    for(Opportunity_Program_Team_Member__c optm: trigger.new){
                        setUserId.add(optm.User__c);
                    }
                    
                    //making sure that only Active Users are inserted/updated
                    for (user u:[select id from user where IsActive = TRUE and id =:setUserId]){
                        setActiveUserIDs.add(u.id);
                    }
                    
                    // Start of section for insertion of opportunity program share records 
        
                    setOppProgIDs = OpptyTeamManager.insertOpptyProgramShare(trigger.newMap, setActiveUserIDs);
                    
                    // End of the section for Device Share records insertion 
            
                    // Start of section for insertion of the Device share records 
                    OpptyTeamManager.insertDeviceShare(setOppProgIDs, trigger.newMap, setActiveUserIDs);
                    // End of the section for Device Share records insertion
                     
                   // Start of section for insertion of the Option share records(Added to check Option sharing) 
                    OptionShareHelper.insertOptionShare(setOppProgIDs, trigger.newMap, setActiveUserIDs);
                    // End of the section for Option Share records insertion
                    
                  // Start of section for insertion of the ASICS Specifications share records(Added to check ASICS Specifications sharing) 
                    ASICSSpecificationsTriggerHelper.insertasicShare(setOppProgIDs, trigger.newMap, setActiveUserIDs);
                    // End of the section for ASICS Specifications Share records insertion  
                    
                  }catch(Exception e){
                       Trigger.new[0].addError((Error_Codes__c.getInstance('OPPTY_PROG_TM_INS_ERROR')).Message__c);
                  }
                    
    
            }
            
            // Update the records in Opportunity_Program__Share,Device__Share
            // Customer_Requirement__Share(Option share),Package_Data__Share
            if(trigger.isUpdate){
                try{
                    //Variable declaration     
                    set <Id> setActiveUserIDs = new set <Id>();
                    set<Id> setUserId = new set<Id>();
                    set<Opportunity_Program_Team_Member__c> sOPTM4OpptyPrgShare = new set<Opportunity_Program_Team_Member__c>();
                    set<Opportunity_Program_Team_Member__c> sOPTM4DevShare = new set<Opportunity_Program_Team_Member__c>();
                    
                    for(Opportunity_Program_Team_Member__c optm: trigger.new){
                        setUserId.add(optm.User__c);
                    }
                    
                    //making sure that only Active Users are inserted/updated
                    for (user u:[select id from user where IsActive = TRUE and id =:setUserId]){
                        setActiveUserIDs.add(u.id);
                    }
                    
                    for(Opportunity_Program_Team_Member__c optm: trigger.new){
                        //only process the records that are not flagged for delete and are not core members
                        if(!optm.Flag_for_Delete__c && setActiveUserIDs.contains(optm.User__c) ) {
                            if(Trigger.oldMap.get(optm.id).Opportunity_Program_Access__c != optm.Opportunity_Program_Access__c){
                                sOPTM4OpptyPrgShare.add(optm);
                            }
                            
                            if(Trigger.oldMap.get(optm.id).Device_Access__c != optm.Device_Access__c){
                                sOPTM4DevShare.add(optm);
                            }
                            
                        }
                    }
                    //Tlai 13042014 - added condition to call OpptyTeamManager
                    if(sOPTM4OpptyPrgShare.size() > 0){
                        // call method to update opportunity program share records 
                        OpptyTeamManager.updateOpptyProgramShare(sOPTM4OpptyPrgShare);
                    }
                    if(sOPTM4DevShare.size() > 0){
                        // call method to update device share records 
                        OpptyTeamManager.updateDeviceShare(sOPTM4DevShare); 
                        
                        // call method to update option share records(Added to check Option sharing) 
                        OptionShareHelper.updateOptionShare(sOPTM4DevShare); 
                        
                        // call method to update ASICS Specifications share records(Added to check ASICS Specifications sharing) 
                        ASICSSpecificationsTriggerHelper.updateasickShare(sOPTM4DevShare);
                        
                    }
                    
                    
                }catch(Exception e){
                    Trigger.new[0].addError((Error_Codes__c.getInstance('OPPTY_PROG_TM_UPDT_ERROR')).Message__c);
                } 
                
            }
            
            //Delete the sharing record in Opportunity_Program__Share,Device__Share
            //Customer_Requirement__Share(Option share),Package_Data__Share
            if(trigger.isDelete){
                try{
                    //Variable declaration
                    set <Id> setOppProgIDs = new set <Id>();
                    set <Id> setUserIDs = new set <Id>();
                    
                    for(Opportunity_Program_Team_Member__c optm: trigger.old){
                        setOppProgIDs.add(optm.Opportunity_Program__c);
                        setUserIDs.add(optm.User__c);
                    }
                    
                    // Start of section for deletion of opportunity program share records 
                     OpptyTeamManager.deleteOpptyProgramShare(setOppProgIDs,setUserIDs);
                    // End of section for deletion of opportunity program share records 
                     
                    // Start of section for deletion of device share records
                    OpptyTeamManager.deleteDeviceShare(setOppProgIDs,setUserIDs);
                    // End of section for deletion of device share records
                    
                    // Start of section for deletion of option share records(Added to check Option sharing)
                    OptionShareHelper.deleteOptionShare(setOppProgIDs,setUserIDs);
                    // End of section for deletion of option share records
                
                    // Start of section for deletion of ASICS Specifications share records(Added to check ASICS Specifications sharing)
                    ASICSSpecificationsTriggerHelper.deleteasicShare(setOppProgIDs,setUserIDs);
                    // End of section for deletion of ASICS Specifications share records
                    
                    //Added ASOLITO 09132013 - insert deleted oppty program team member record to Deleted Record object
                    DeletedRecordsManager.insertRecords(Trigger.old, EnvironmentVariable.get('OPPTY_PROG_TM_ENTITY'));
                    
                 }catch(Exception e){
                     Trigger.old[0].addError((Error_Codes__c.getInstance('OPPTY_PROG_TM_DEL_ERROR')).Message__c);
                 } 
                 
                 //Added ASOLITO 09132013 - insert deleted oppty program team member record to Deleted Record object
                 /*if(trigger.isBefore){
                     system.debug('Inside the isBefore check');
                     DeletedRecordsManager.insertRecords(Trigger.old, EnvironmentVariable.get('OPPTY_PROG_TM_ENTITY'));
                 }*/
            }   
        }
        //TLai  13042014    - Copied field update logic from workflow 'Oppty Program Team Member - Outbound Message - To AIA'
        if(trigger.isbefore){
            Boolean isIntegrationUser = false;
            IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
            if(setting != null && setting.Is_Integration_User__c){
                isIntegrationUser = true;
            }
            for(Opportunity_Program_Team_Member__c optm : trigger.new){
                if(!isIntegrationUser){
                    optm.Martinistore_Sync_Status__c = 'Sent';
                }
            }
        }
    }
}