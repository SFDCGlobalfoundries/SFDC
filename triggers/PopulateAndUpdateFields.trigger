/***********************************************************************************************************************************
Trigger: PopulateAndUpdateFields
------------------------------------------------------------------------------------------------------------------------------------
Author: Joydev Mondol (Cognizant - 153480)
Created Date: 31/10/2013
Reason: Populates the Proposal fields on creation/updation
History:  01092015 ARoy - Populating Primary User field from Account Team Proxy Field Application Engineer
          01292015 ARoy - Modified the call to UpdatePricelist method of ProposalTriggerUtil class to before trigger.
          02182015 ARoy - Added recordtype readonly for enhanced approval process.
                        - Added new validation on approval.
          08072015 ARoy - Updating device with primary and approved configuration
          11052015 ASoli- Added codes for BPM integration
          11192015 ARoy - Record updated to read-only on record submission and added Approval Check 1 for approval process submission
          12012015 ASoli- Send Email to users when stage = Process Flow Accepted
          12152015 ARoy - Validations added for Configurator Approval Stages.
          01112016 ARoy - Populate Assigned Process ID in Device on Process Flow Accepted Stage.
                        - Code modified for Config PIYE Approver User population. 
          03022016 ARoy - Case #00052312 : Update device indifferent of approval status
          03032016 PSaha- Cloning configuration: save the source configuration number in the clonned config record.
          03032016 ARoy - Fixing the approval process status change after Packaging or PIYE approval 
                        - Assigned process Id is required only for Purpose of the Configuration as Final.
                        - Assigned process Id is not required for Purpose of the Configuration as Preliminary.
          04072016 PSaha- Skip Packaging Approval if there is no change in the packaging fields and Packaging team has already approved.
          Spring3  aAgar- Added code to stop sending multiple PID Creation emails to PIYE Fab users
                        - Added code to skip PID feneration email for Design Win case #00057087
          07132017 sShar- Sprint8 Case#00066876 BPMS Integration with Configurator
          12/07/17 Ravi Teja.B - Duplicates on Configuration Yield Case#00073895
          02/08/17 Ravi Teja.B - Assigned Process Id Validation for Process Accepeted Phase
          23-08-17 Nbajaj - CPQ Sprint-10- case -00069734 : Added logic to insert config pdf file in attachement and send email to config rec submitter.
           09-01-2018 Dilip Jha --Case 00084460 - Configuration should not be deleted 
************************************************************************************************************************************/
trigger PopulateAndUpdateFields on Apttus_Proposal__Proposal__c (After Insert, After Update,before Insert, before Update, before delete ) {
    /* 
    Change Log: Ravi Teja.B, Case#00059585 Date:27-03-2017
    Reason: Moved this code from belolw to this place as there is a problem executing this code only once. At the time of 
    customer submission of configuration there is an double update in which this Record type update is not happening due to only once exedcute logic*/
    /********************************** Record Type Update Block *****************************************/
    try{      
        if(trigger.isBefore && trigger.isUpdate){
            List<Id> recIds = new List<Id>();
            for(Apttus_Proposal__Proposal__c config: Trigger.New){
                if (Test.isRunningTest()) { 
                    config.IsTestRunning__c =true;
                }
                
                if((config.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(config.Id).Apttus_Proposal__Approval_Stage__c
                    && ((config.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase' && (UserInfo.getUserType() == 'CustomerSuccess' || UserInfo.getUserType() == 'PowerCustomerSuccess'))
                        || (config.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                            && UserInfo.getUserType() == 'Standard'
                            && (Trigger.oldmap.get(config.id).Apttus_Proposal__Approval_Stage__c == 'Submitted Phase'
                                ||Trigger.oldmap.get(config.id).Apttus_Proposal__Approval_Stage__c == 'Draft'
                                ||Trigger.oldmap.get(config.id).Apttus_Proposal__Approval_Stage__c == 'Rejected Phase' 
                                )
                            )
                        )
                    )
                    || (config.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase'
                    && Trigger.oldmap.get(config.id).Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase')
                ){                    
                    recIds.add(config.recordtypeId);                    
                }
            }
            Map<Id, String> oldRecTypeMap = new Map<Id, String>();
            Map<String, Id> newRecTypeMap = new Map<String, Id>();
            for(RecordType rt : [select id, developername, name from RecordType where id in :recIds 
                                or developername in ('Proposal_from_Teamroom_Read_Only', 'Proposal_from_Device_Read_Only', 'Multi_Source_Proposal_from_Teamroom_Read_Only', 
                                                    'Multi_Source_Proposal_from_Device_Read_Only')]){
                if(rt.developername=='Proposal_from_Teamroom_Read_Only' 
                  || rt.developername=='Proposal_from_Device_Read_Only'
                  || rt.developername=='Multi_Source_Proposal_from_Teamroom_Read_Only'
                  || rt.developername=='Multi_Source_Proposal_from_Device_Read_Only'){
                  newRecTypeMap.put(rt.developername,rt.Id);    
                }else{
                    oldRecTypeMap.put(rt.Id,rt.developername);
                }        
            }            
            for(Apttus_Proposal__Proposal__c config: Trigger.New){
                if(!newRecTypeMap.isEmpty() && !oldRecTypeMap.isEmpty()
                  && oldRecTypeMap.containsKey(config.recordtypeId)){
                  config.recordTypeId = newRecTypeMap.get(oldRecTypeMap.get(config.recordtypeId)+'_Read_Only')!=null?
                                              newRecTypeMap.get(oldRecTypeMap.get(config.recordtypeId)+'_Read_Only'):config.recordTypeId;
                }
            }
        }
    }
    catch(Exception ex){
        GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger Record Type Change Block', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
        throw ex;
    }
    /********************************** Record Type Update Block End *****************************************/
    
    if(NPCCopyConfigurationController.InsideNPCCopyConfig) {
      if(Trigger.isBefore && Trigger.isUpdate) {
        if(NPCCopyConfigurationController.PopulateFieldBeforeUpdate) {return;}
        NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
      }
      if(Trigger.isAfter && Trigger.isUpdate) {
        if(NPCCopyConfigurationController.PopulateFieldAfterUpdate) {return;}
        NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
      }
    }
    //PS 12302014
    try{
        Map<ID,List<Apttus_Proposal__Proposal__c>> MapTriggeredConfig2OtherConfig = new Map<ID,List<Apttus_Proposal__Proposal__c>>();
        if(trigger.isBefore){
            // Start : 02182015 ARoy - Added code for recordtype readonly and added validation on approval.
            // Modified : 11192015 ARoy - Recordtype updated to read-only on record submission.
            // Modified By Ravi Teja.B: Moved the RecordType read only block to top most just before the logic where the trigger is made execute only once
            if(trigger.isUpdate){
                Map<String,ConfigApprovalStages__c> apprlStage = ConfigApprovalStages__c.getall();
                ProposalTriggerUtil.checkRejectionComments(trigger.new,trigger.oldmap); //added to make rejection comments mandatory
                
                //Kanishk: Pupulate PIYE and CE approvers for Singapore Fabs
                 ConfiguratorApprovalSetting__c objConfiguratorApprovalSetting = ConfiguratorApprovalSetting__c.getOrgDefaults();
                list<Apttus_Proposal__Proposal__c> lst=new List<Apttus_Proposal__Proposal__c>();
                list<Apttus_Proposal__Proposal__c> lstCENOtify=new List<Apttus_Proposal__Proposal__c>();
                boolean isAssignFAE=false;
                for(Apttus_Proposal__Proposal__c config: Trigger.New){
                  if(config.Notify_To_CE__c==true  || config.AsignFAEApprover__c==true){//config.adderror('Value=:'+config.Notify_To_CE__c);
                   
                    lst.add(config);
                    if(config.AsignFAEApprover__c==true){
                        isAssignFAE=true;
                      }
                      if(config.Notify_To_CE__c){   
                         lstCENOtify.add(config);
                      }
                    
                     config.AsignFAEApprover__c=false;
                     config.Notify_To_CE__c=false;
                  }
                }
                 if(lst.size()>0){
                  ApproverValidatorUtil.setApproverDetail(lst,isAssignFAE); 
                 } 
                 if(lstCENOtify!=null && lstCENOtify.size()>0){
                    ApproverValidatorUtil.setEmailtoCEApprover(lstCENOtify); 
                 }
               //Kanishk: End  
                
                for(Apttus_Proposal__Proposal__c config: Trigger.New){
                    if(config.Apttus_Proposal__Approval_Stage__c == 'Process Flow Accepted'){
                        if(apprlStage.containsKey('Process Flow Accepted DW') && apprlStage.containsKey('Process Flow Accepted for Prelim')){
                            if(config.Purpose_of_the_Configuration__c == 'For Design Win'){
                                config.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted DW').Value__c;
                            }
                            else if(config.Purpose_of_the_Configuration__c == 'Preliminary'){
                                config.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted for Prelim').Value__c;
                            }
                        }
                    }
                    if( config.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase'
                        &&   config.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(config.id).Apttus_Proposal__Approval_Stage__c
                        &&   (config.device__c == NULL
                             || config.Fab_Name__c == NULL ) ){
                            config.addError('Please Populate Device or Device Fab to submit/approve Configuration');
                    }
                    //12152015 ARoy : Validation on IP Consolidated Status for Approval Stage as 'Configuration Design Phase'
                    //**********************************************************************************//
                    if( config.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase'
                        &&   config.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(config.id).Apttus_Proposal__Approval_Stage__c
                        &&   config.Consolidated_IP_Status_Check__c == 'No' ){
                            config.addError('The Consolidated IP Status should be approved before FAE approval/submission.');
                    }
                    //**********************************************************************************//                                        
    
                    /******************* Start: PS 04072016 **********************/
                    config.Is_Packaging_Information_Updated__c = FALSE; // set Packaging information updated to false
                    for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.Packaging_Field_Set.getFields()){
                        if(Trigger.NewMap.get(config.id).Approved_by_Packaging_Team__c 
                            && Trigger.NewMap.get(config.id).get(f.getFieldPath()) != Trigger.OldMap.get(config.id).get(f.getFieldPath())){
                            config.Is_Packaging_Information_Updated__c = TRUE ; 
                            break;  
                        }                       
                    }
                    /******************* End: PS 04072016 **********************/
                
                    
                }            
                //Start Harsha      
                Schema.DescribeSObjectResult d = Schema.SObjectType.Apttus_Proposal__Proposal__c;       
                Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();       
                Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();       
                system.debug('****rtMapByName'+rtMapByName);        
                for(Apttus_Proposal__Proposal__c config: Trigger.New){  
                    // Spring III - Moved from after insert to before update to make email triggered only once - Start
                        if(Config.apttus_proposal__approval_stage__c != null && !Config.apttus_proposal__approval_stage__c.contains('Process Flow Accepted')){// Modified By Ravi Teja.B 21072017
                            config.PID_Mail_sent__c=false;
                        } 
                        /*************************************************
                        Asolito 12012015 - Fire Email notification for PID creation when stage = process flow accepted
                        *************************************************/ 
                        if(Config.apttus_proposal__approval_stage__c <> trigger.oldMap.get(Config.id).apttus_proposal__approval_stage__c &&
                             Config.apttus_proposal__approval_stage__c != null && Config.apttus_proposal__approval_stage__c.contains('Process Flow Accepted') && config.PID_Mail_sent__c== false // Modified by Ravi Teja.B 21072017
                             && Config.Purpose_of_the_Configuration__c !='For Design Win'){ // case #00057087
                           //Case#00085239:Metal Stack is wrong--->Re: A configuration is ready for PID creation
                           // PIDGenerationEmail.sendEmail(Config);
                        }
                        if(Config.apttus_proposal__approval_stage__c != null && Config.apttus_proposal__approval_stage__c.contains('Process Flow Accepted')){ // Modified By Ravi Teja.B 21072017
                                 config.PID_Mail_sent__c=true;
                        }    
                    // Spring III - Moved from after insert to before update to make email triggered only once - End
                    
                    // Harsha: added config.Cloned_From__c !=null in condition      
                    if (rtMapById.get(config.recordTypeId).Name == 'MultiSource Proposal Device RO' && config.Cloned_From__c !=null){       
                        config.recordTypeId = rtMapByName.get('Multi Source Proposal from Device').RecordTypeId;        
                    } else if (rtMapById.get(config.recordTypeId).Name == 'MultiSource Proposal Teamroom RO' && config.Cloned_From__c !=null){      
                        config.recordTypeId = rtMapByName.get('Multi Source Proposal from Teamroom').RecordTypeId;      
                    } else if (rtMapById.get(config.recordTypeId).Name == 'Proposal from Device Read Only' && config.Cloned_From__c !=null){        
                        config.recordTypeId = rtMapByName.get('Proposal from Device').RecordTypeId;     
                    } else if (rtMapById.get(config.recordTypeId).Name == 'Proposal from Teamroom Read Only' && config.Cloned_From__c !=null ){     
                        config.recordTypeId = rtMapByName.get('Proposal from Teamroom').RecordTypeId;       
                    }       
                }       
                //End Harsha
            }
            // End : 02182015 ARoy
            
            if( trigger.isInsert || trigger.isUpdate){
                /*
                    Populates the Proposal Pricelist with a dummy pricelist if left blank
                */
                //01292015 ARoy : Modified the call to UpdatePricelist method of ProposalTriggerUtil class to before trigger.
                Boolean isRun = false;
                if(trigger.isInsert){
                    for(Apttus_Proposal__Proposal__c proposal : trigger.new){
                        if(proposal.Apttus_QPConfig__PriceListId__c == null){
                            isRun = true;
                        }
                    }
                }else if(trigger.isUpdate){
                    User usr1 = CPQConfigApprovalHandler.getHCMUser();
                    for(Apttus_Proposal__Proposal__c proposal : trigger.new){
                        //01112016 ARoy : Code modified for Config PIYE Approver User population.       
                        if(proposal.Apttus_Proposal__Approval_Stage__c != null && proposal.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') //Modified by Ravi Teja.B 21072017      
                            && proposal.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(proposal.id).Apttus_Proposal__Approval_Stage__c        
                            && trigger.oldMap.get(proposal.id).Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'){     
                            proposal.Config_PIYE_Approver__c = usr1.HCM_Login_Id__c;        
                        }
                        if(proposal.Apttus_Proposal__Account__c != trigger.oldMap.get(proposal.id).Apttus_Proposal__Account__c){
                            isRun = true;                       
                        }
                    }
                }
                if(isRun){
                    ProposalTriggerUtil.UpdatePricelist(trigger.new);
                }
                //==============End====================//
                
                system.debug('configuration new map++'+Trigger.new);
                boolean ConfigFlag = false; 
                List<Apttus_Proposal__Proposal__c> beforeUpdateConfiguration = new List<Apttus_Proposal__Proposal__c>();
                List<Apttus_Proposal__Proposal__c> beforeApprovedConfiguration = new List<Apttus_Proposal__Proposal__c>();
                for(Apttus_Proposal__Proposal__c Config: Trigger.New){
                    if( trigger.isInsert 
                        ||  trigger.isUpdate
                            && Config.Apttus_Proposal__Approval_Stage__c != null && Config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') // Modified By Ravi Teja.B 21072017
                            && Config.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(Config.id).Apttus_Proposal__Approval_Stage__c 
                        ||  trigger.isUpdate
                            && Config.device__c != NULL
                            && trigger.oldMap.get(Config.id).device__c != Config.device__c
                        ||  trigger.isUpdate
                            && Config.APTPS_Primary__c == true
                            && Config.APTPS_Primary__c != trigger.oldMap.get(Config.id).APTPS_Primary__c
                       ){
                        //START: ******03032016 PSaha ****//                    
                            if(trigger.isInsert && Config.Configurator_Lookup__c != null && Config.Configurator_Lookup__c != Config.Cloned_From__c){
                                Config.Cloned_From__c = Config.Configurator_Lookup__c ;
                                Config.APTPS_Primary__c = false;              
                            }                       
                        //END: ******03032016 PSaha ****//   
                        ConfigFlag = true;     
                        break;    
                    }
                    system.debug('config.Approval_Check__c ==>'+config.Approval_Check__c);
                    // 11192015 ARoy : Added Approval Check 1 for updating configurator status
                    //******************************************//
                    // 03032016 ARoy - Fixing the approval process status change after Packaging or PIYE approval
                    if(trigger.isUpdate && 
                        ((config.Approval_Check__c != trigger.oldMap.get(config.id).Approval_Check__c 
                        && config.Approval_Check__c) || 
                        (config.Approval_Check_1__c != trigger.oldMap.get(config.id).Approval_Check_1__c 
                        && config.Approval_Check_1__c)))  {                        
                        beforeUpdateConfiguration.add(config);
                        if(config.Approval_Check_1__c && config.device__c == NULL){
                             config.addError('Please populate Device value to approve this Configurator Plus');
                        }      
                    }
                      // 03032016 Kanishk - Not allow non PackagingUser or PIYEUser to approve configuration
                 if(config.Apttus_Proposal__Approval_Stage__c!='Draft' && ((trigger.isUpdate &&config.Approval_Check__c != trigger.oldMap.get(config.id).Approval_Check__c) 
                  || (config.Apttus_Proposal__Approval_Stage__c != trigger.oldMap.get(config.id).Apttus_Proposal__Approval_Stage__c
                      &&(
                       config.Apttus_Proposal__Approval_Stage__c=='Design Phase'
                      || config.Apttus_Proposal__Approval_Stage__c=='Process Flow Accepted'))))
                    {
                      beforeApprovedConfiguration.add(config);      
                   }      
                }
                if(beforeUpdateConfiguration.size()>0){
                    CPQConfigApprovalHandler.updateApprovalStatus(beforeUpdateConfiguration);
                }
                
                //Kanishk: Not allow non PackagingUser or PIYEUser to approve configuration
                if(beforeApprovedConfiguration.size()>0){
                    ApproverValidatorUtil.validateQueueMember(beforeApprovedConfiguration);
                }
                
                //12152015 ARoy : Validation on Assigned Process Id before Process Flow Accepted Approval stage
                //03032016 ARoy : Assigned process Id is required only for Purpose of the Configuration as Final. 
                //21072017 Ravi Teja: Added the 'Process Accepted Phase' condition to not allow PIYEs to approve without assigned PID for Final Config
                if(trigger.isBefore && trigger.isUpdate){
                    for(Apttus_Proposal__Proposal__c proposal : Trigger.New){
                    system.debug('proposal.Apttus_Proposal__Approval_Stage__c===>'+proposal.Apttus_Proposal__Approval_Stage__c);
                        if(proposal.Apttus_Proposal__Approval_Stage__c != null && (proposal.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase')
                            && proposal.Assigned_Process_ID__c == null && proposal.Purpose_of_the_Configuration__c == 'Final'){
                                proposal.addError('Assigned Process Id field should be populated for Approval Stage "Process Flow Accepted" or "Process Accepted Phase".');
                        }
                    }
                }
                //******************************************//
                if (ConfigFlag ) {
                    MapTriggeredConfig2OtherConfig = ProposalTriggerUtil.getConfigDeviceMap(Trigger.new
                                                                                        , Trigger.IsInsert
                                                                                        , Trigger.isUpdate);  
                }  else { return;}                                 
                for(Apttus_Proposal__Proposal__c proposal : Trigger.New){
                    proposal.APTPS_Primary__c = ( trigger.isInsert
                                                  && ConfigFlag
                                                  && MapTriggeredConfig2OtherConfig.get(proposal.id).size() == 0 
                                                  && proposal.device__c != NULL
                                                  && !proposal.APTPS_Primary__c
                                                  ) 
                                                  ||
                                                  ( trigger.isUpdate
                                                  && ConfigFlag
                                                  && MapTriggeredConfig2OtherConfig.get(proposal.id).size() == 1 
                                                  && proposal.device__c != NULL
                                                  && trigger.oldMap.get(proposal.id).device__c != proposal.device__c
                                                  && !proposal.APTPS_Primary__c 
                                                  )
                                                    ? TRUE 
                                                    : proposal.APTPS_Primary__c  ; 
                    if( proposal.device__c != NULL
                        && ProposalTriggerUtil.MapConfig2IsValidforApprove.containskey(proposal.id) 
                        && ProposalTriggerUtil.MapConfig2IsValidforApprove.get(proposal.id) == FALSE
                        && proposal.APTPS_Primary__c == TRUE){
                        proposal.addError('Please use some other device. There is a Process Flow Accepted and Primary configuration present for this device ');
                    }
                    if( trigger.isupdate 
                        && ProposalTriggerUtil.MapConfig2IsValidforApprove.containskey(proposal.id) 
                        && ProposalTriggerUtil.MapConfig2IsValidforApprove.get(proposal.id) == FALSE
                        && proposal.Apttus_Proposal__Approval_Stage__c != null && proposal.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted')){ // Modified By Ravi Teja.B 21072017
                        proposal.addError('Process flow of some other configuration under this device has already been accepted');
                    } 
                }                                                              
            }
        }
       else if(trigger.isAfter){ 
            //Generate Yield and Cost records
           if(Trigger.isUpdate){
                for(Apttus_Proposal__Proposal__c rec: trigger.new){ 
                    if(UtilsString.isNotBlank(rec.process_technology__c) && 
                       rec.apttus_proposal__account__c <> null &&
                       rec.device__c <> null &&
                       rec.apttus_proposal__opportunity__c <> null && 
                       rec.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != NULL && !GenerateYieldAndCost.hasRun && 
                       (rec.Deliverable_Part_Type__c != trigger.oldmap.get(rec.Id).Deliverable_Part_Type__c || // Added By Ravi Teja.B 13/07/2017
                        rec.Relgrade__c != trigger.oldmap.get(rec.Id).Relgrade__c || 
                        rec.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != trigger.oldmap.get(rec.Id).Actual_Tapeout_Date_FAB_9_and_FAB_10__c)){
                            GenerateYieldAndCost.hasRun = true;
                            GenerateYieldAndCost.generate(rec.id);                           
                    }
                }
            }
            //Skip on self-trigger       
            if(Trigger.isUpdate){
                /*Code added by Suvajit- To check and process the Config score on oppty */
                Map<Id,Apttus_Proposal__Proposal__c> oldmap=new Map<Id,Apttus_Proposal__Proposal__c>();  
                Map<Id,Apttus_Proposal__Proposal__c> newmap=new Map<Id,Apttus_Proposal__Proposal__c>();
                Id configId =null;
                String Stage=null;
                Boolean mailToExternalUser =null;
               CPQCS__c CS = CPQCS__c.getValues('checkexternaluser'); 
                for(Apttus_Proposal__Proposal__c rec: trigger.new){ 
                    /* Suvajit- Case # :00054317 CPU Time limit error fix */   
                    //Change of opportunity on Configuration
                    if(rec.Apttus_Proposal__Opportunity__c <> Trigger.oldMap.get(rec.id).Apttus_Proposal__Opportunity__c){
                       oldmap.put(rec.id,trigger.oldmap.get(rec.id));
                       newmap.put(rec.id,trigger.newmap.get(rec.id));
                    }
                    //Change of Device on Configuration 
                    if(rec.Device__c <> Trigger.oldMap.get(rec.id).Device__c){
                       oldmap.put(rec.id,trigger.oldmap.get(rec.id));
                       newmap.put(rec.id,trigger.newmap.get(rec.id));
                    }             
                    //Change of Stage on Configuration
                    if(rec.Apttus_Proposal__Approval_Stage__c != null && rec.Apttus_Proposal__Approval_Stage__c <> Trigger.oldMap.get(rec.id).Apttus_Proposal__Approval_Stage__c &&
                        (rec.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') || Trigger.oldMap.get(rec.id).Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))){ // Modified By Ravi Teja.B 21072017
                        oldmap.put(rec.id,trigger.oldmap.get(rec.id));
                        newmap.put(rec.id,trigger.newmap.get(rec.id));
                    }
                }
            
                if(oldmap.size()>0 && newmap.size()>0)
                    OpptyGeometryValidator.ConfigProcessor(oldmap,newmap);
                
                Boolean blSkip = true;
                List<Apttus_Proposal__Proposal__c> triggeredSubmitConfig = new List<Apttus_Proposal__Proposal__c> ();
                List<ID> triggeredConfigIds = new List<ID>();
                
                for(Apttus_Proposal__Proposal__c proposal : Trigger.NewMap.values()){
                    if(proposal.Device__c != Trigger.OldMap.get(proposal.Id).Device__c ||                       
                       proposal.Mask_Set_Long__c != Trigger.OldMap.get(proposal.Id).Mask_Set_Long__c ||
                       proposal.Apttus_Proposal__Opportunity__c != Trigger.OldMap.get(proposal.Id).Apttus_Proposal__Opportunity__c ||
                       (proposal.APTPS_Allowed_Geometries__c != Trigger.OldMap.get(proposal.Id).APTPS_Allowed_Geometries__c 
                        && proposal.Apttus_Proposal__Account__c != Trigger.OldMap.get(proposal.Id).Apttus_Proposal__Account__c ) ||
                       proposal.Apttus_Proposal__Account__c != Trigger.OldMap.get(proposal.Id).Apttus_Proposal__Account__c ||
                       proposal.Free_Devices__c != Trigger.OldMap.get(proposal.Id).Free_Devices__c ||
                       proposal.Free_Device_Names__c != Trigger.OldMap.get(proposal.Id).Free_Device_Names__c ||
                       proposal.Apttus_QPConfig__PriceListId__c != Trigger.OldMap.get(proposal.Id).Apttus_QPConfig__PriceListId__c ||
                       proposal.APTPS_Primary__c != Trigger.OldMap.get(proposal.Id).APTPS_Primary__c||
                       proposal.IPs__c != Trigger.OldMap.get(proposal.Id).IPs__c){
                        blSkip = false;
                        break;
                    }
                    // 11192015 ARoy : Added Approval Check 1 for updating configurator status
                    //******************************************//
                    if(proposal.Approval_Check__c 
                        && ( proposal.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                            || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase') 
                        && proposal.Apttus_Proposal__Approval_Stage__c != Trigger.OldMap.get(proposal.Id).Apttus_Proposal__Approval_Stage__c){
                        triggeredSubmitConfig.add(proposal);  
                        triggeredConfigIds.add(proposal.ID);          
                    }
                    if(proposal.Approval_Check_1__c){
                        triggeredSubmitConfig.add(proposal); 
                        triggeredConfigIds.add(proposal.ID);  
                    }
                    //******************************************// 
                    if(proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase'
                        && trigger.OldMap.get(proposal.Id).Apttus_Proposal__Approval_Stage__c == 'Submitted Phase' 
                        && proposal.Device__c == null){
                        proposal.addError('Device should be populated');
                    } 
                    /*-*********************--Nbajaj, CPQ-Sprint10,case-00069734 start--******************-*/
                    if(proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase'&&
                     trigger.OldMap.get(proposal.Id).Apttus_Proposal__Approval_Stage__c == 'Submitted Phase' 
                     && proposal.Device__c != null){
                        configId =proposal.id;
                        Stage = proposal.Apttus_Proposal__Approval_Stage__c;
                        
                    }                                                                  
                }
                 Id userId = UserInfo.getUserId();
               
                    if(!RecursionPrevent.isAlreadyModified()){
                       if(configId!=null && stage =='Configuration Design Phase'){
                           try{
                               
                               mailToExternalUser = CS.Is_submitted_by_External_User__c;
                               CPQTempCS__c TempCS = CPQTempCS__c.getValues('CPQTemplate');
                               String templateName = TempCS.FAE_Template_Name__c;  
                               CPQInsertAttachement.createAttachement(configId,userId,mailToExternalUser,templateName);
                               RecursionPrevent.setAlreadyModified();
                              }catch(Exception ex){
                                   GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger on Configurator Plus', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
                              
                              }
                       
                        }
                     }
                      /*************************case-00069734 end************************************/
                // 08072015 ARoy : Updating device with primary and approved configuration
                // 03022016 ARoy : Case #00052312 - Update device indifferent of approval status
                // 08242016 SShar: Case #00051818 - Allow configuration to update Device's Assigned Process ID only if
                //                  Device's Tapeout date is not in the past and stage is not Tapeout. Otherwise just create a new Assigned Process record under the device
                // 12272016 SShar : Case #00051818 Update : Allow device update if Device's Stage is 'Design In' (No need of Dates as Stage and Dates are updated simultaneously by PTRF)
                //**********************************************************************//
                //13072017 sShar : correcting the logic to make sure that only the Primary and Final configuration makes changes to the corresponding device
                Map<String,Apttus_Proposal__Proposal__c> devConfigMap = new Map<String,Apttus_Proposal__Proposal__c>();
                for(Apttus_Proposal__Proposal__c proposal : Trigger.NewMap.values()){
                   if(proposal.APTPS_Primary__c && proposal.Purpose_of_the_Configuration__c == 'Final' && proposal.Apttus_Proposal__Approval_Stage__c != trigger.OldMap.get(proposal.Id).Apttus_Proposal__Approval_Stage__c && proposal.Device__c != null){
                        devConfigMap.put(proposal.Device__c, proposal);
                    } 
                }                        
                if(!devConfigMap.isEmpty()){
                    List<Device__c> devList = new List<Device__c>();
                    List<Assigned_Process__c> newProcessesList = new List<Assigned_Process__c>();
                    for(Device__c dev : [select id, Stage__c from   Device__c where  id in :devConfigMap.keySet()]){
                        dev.configuration__c = devConfigMap.get(dev.id).name;
                        dev.Configuration_Status__c = devConfigMap.get(dev.id).Apttus_Proposal__Approval_Stage__c ; 
                        //07132017 sShar : [BPMS Integration] Populating requested CDRS fields on Final Configuration's Device
                        Map<String,CDRS_Config_Status_Mapping__c> customsttgMap = CDRS_Config_Status_Mapping__c.getAll();
                        if(customsttgMap != null && customsttgMap.containskey(devConfigMap.get(dev.id).Apttus_Proposal__Approval_Stage__c)){
                            dev.BX041_Status__c = customsttgMap.get(devConfigMap.get(dev.id).Apttus_Proposal__Approval_Stage__c).CDRS_Status__c;
                            dev.BX041_Submission_Date__c = System.today();
                        }
                        if(devConfigMap.get(dev.id).Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted')){ // Modified By Ravi Teja.B 21072017
                                newProcessesList.add(new Assigned_Process__c(Device__c = dev.Id, Process__c = devConfigMap.get(dev.id).Assigned_Process_ID__c));
                                // 12272016 SShar: Stage = Design In
                                if(dev.Stage__c == 'Design In')
                                    dev.Assigned_Process_ID__c = devConfigMap.get(dev.id).Assigned_Process_ID__c;
                            
                            //01112016 ARoy : Code modified for Config PIYE Approver User population.
                            if(devConfigMap.get(dev.id).Config_PIYE_Approver__c != null && devConfigMap.get(dev.id).Config_PIYE_Approver__c != '')
                                dev.CDRS_approval_User__c = devConfigMap.get(dev.id).Config_PIYE_Approver__c;
                        }
                        devList.add(dev);    
                    }                                                         
                    String errorMessage = '';
                    try{
                        Database.SaveResult[] srList = new List<Database.SaveResult>();
                        if(devList.size()>0)                     
                            srList.addAll(Database.update(devList, false));
                        
                        if(newProcessesList.size() > 0)
                            srList.addAll(Database.insert(newProcessesList, false));
                        
                        for(Database.SaveResult sr : srList){
                            if(!sr.isSuccess())
                                errorMessage += JSON.serializePretty(sr.getErrors(), true);
                        }
                        if(errorMessage != '')
                            GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger on Configurator Plus - DML on Device__c or Assigned_Process__c objects', 'Trigger', null, null, errorMessage, null,null,null, null);
                    }catch(Exception ex){
                        GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger on Configurator Plus', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
                    }
                }
                //**************************************************************************//
                if(triggeredSubmitConfig.size()>0){
                    system.debug('[Debug]: triggeredSubmitConfig --->'+triggeredSubmitConfig);
                    CPQConfigApprovalHandler.submitForApproval(triggeredConfigIds);
                }                       
                if(blSkip){
                    return;
                }
            }
            Map<Id, Apttus_Proposal__Proposal__c> triggeredProposalNewMap = new Map<Id, Apttus_Proposal__Proposal__c>();
            Map<Id, Apttus_Proposal__Proposal__c> triggeredProposalOldMap = new Map<Id, Apttus_Proposal__Proposal__c>();
            //These Maps holds the pair of Device & Propasal values. Used in class 'CPQIPDeclarationUtil'
            Map<Id, Apttus_Proposal__Proposal__c> ProposalNew= new Map<Id, Apttus_Proposal__Proposal__c>();
            Map<Id, Apttus_Proposal__Proposal__c> ProposalOld= new Map<Id, Apttus_Proposal__Proposal__c>();
            
            for(Apttus_Proposal__Proposal__c proposal : Trigger.NewMap.values()){
                if(Trigger.isInsert){
                    triggeredProposalNewMap.put(proposal.Id, proposal);
                } else if(Trigger.isUpdate){
                    triggeredProposalOldMap.put(proposal.Id, Trigger.OldMap.get(proposal.Id));
                    triggeredProposalNewMap.put(proposal.Id, proposal);
                    ProposalNew.put(proposal.device__c, proposal);
                    ProposalOld.put(proposal.device__c , Trigger.OldMap.get(proposal.Id));   
                }
            }
            Map<Id,String> MapOldandNewCPRec = new Map<Id,String>();
            for(Apttus_Proposal__Proposal__c Config: Trigger.New){
                // Start: Harsha: For Cloning Childs: Configurator plus response
                if(Trigger.isInsert && Config.Configurator_Lookup__c !=null){
                    MapOldandNewCPRec.put(Config.Configurator_Lookup__c,Config.Id);
                }
                // End : Harsha.
            }
            //Start : Harsh call the method to clone child records
            if (MapOldandNewCPRec.size()>0)
            {
            ProposalTriggerUtil.cloneConfigPlusResponse(MapOldandNewCPRec); 
            ProposalTriggerUtil.clonePCMRelatedObjects(MapOldandNewCPRec); //added by sunita for case 00074954
            }
            //End
            
            //IP Declaration: block
            if(ProposalNew.size() > 0 || ProposalOld.size() > 0){ 
                CPQIPDeclarationUtil IPDeclerationUtil = new CPQIPDeclarationUtil();
                 //Populates Configuration,Status,Revision field for the IpDeclarationForm when Proposal is Inserted/Updated.
                 IPDeclerationUtil.PopulateConfiguration(   ProposalNew
                                                            , ProposalOld
                                                            , Trigger.IsInsert
                                                            , Trigger.isUpdate); 
            }
            ProposalTriggerUtil proposalUtil = new ProposalTriggerUtil(triggeredProposalNewMap);                           
        
            /*** Start: PS 03/04/2016 ***/
                proposalUtil.UpdateISSRAMDevice(trigger.new);
            /*** Stop: PS 03/04/2016 ***/
      
            /*
            Populates the Allowed Geometries field in Proposal with the NDA Geometries of all the
            Account Team Proxies of the proposal Account
            */
            proposalUtil.UpdateAllowedGeometries(triggeredProposalNewMap, 
                                                     triggeredProposalOldMap,
                                                     Trigger.IsInsert,
                                                     Trigger.isUpdate);
            
            /*
            Populates the Free Devices fields comma separated with devices with Masks layers 
            already included while configuring the Proposal on other device selections.
            */
            proposalUtil.UpdateFreeDevices(triggeredProposalNewMap, 
                                                 triggeredProposalOldMap,
                                                 Trigger.IsInsert,
                                                 Trigger.isUpdate);        
    
            //01092015 ARoy : Populates the Proposal Primary User from primary FAE and FTS users from the Account Team Proxies       
            proposalUtil.UpdatePrimaryUser(triggeredProposalNewMap, 
                                                 triggeredProposalOldMap,
                                                 Trigger.IsInsert,
                                                 Trigger.isUpdate);        
                                                       
            /*
            Populates the Proposal Opportunity with the Devices Opportunity when created from Devices.
            Populates the Proposal Opportunity with a dummy Opportunity when created from Teamrooms.
            The dummy opportunity are created for the first time if not exists.
            */
            proposalUtil.UpdateOpportunity(triggeredProposalNewMap, 
                                             triggeredProposalOldMap,
                                             Trigger.IsInsert,
                                             Trigger.isUpdate);       
            
            /*
            Singulates the Primary field of the proposals for a device by 
            unchecking the same for other proposals in the same device.
            */
            proposalUtil.SingulatePrimary(triggeredProposalNewMap, 
                                                 triggeredProposalOldMap,
                                                 Trigger.IsInsert,
                                                 Trigger.isUpdate);
            //Update final set of updated proposals
            List<Apttus_Proposal__Proposal__c> lstUpdatedProposals = proposalUtil.mapUpdatedProposals.Values();
            if(lstUpdatedProposals.size() > 0){
                try {
                    update lstUpdatedProposals;
                } catch (Exception ex){
                    GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger on Configurator Plus', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
                }
            }
        }
    }catch(Exception ex){
        GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger on Configurator Plus', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
        throw ex;
    }
    
        /********************* Case 00084460 - Configuration should not be deleted changes done by Dilip jha starts******************************/
    try{ 
        if (Trigger.isDelete && Trigger.isBefore) {
            Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    
            for (Apttus_Proposal__Proposal__c configurator: Trigger.old) {
            
                if (!(IntegrationUserUtil.isSkipTrigger()) && // Integration User can delete in all condition
                    configurator.fms_proposal__c==null){  // Not FMS configuration
                    if(!ProfileName.Name.containsIgnoreCase('Admin'))                            
                    {
                        configurator.addError(EnvironmentVariable.get('CONFIG_DELETE_ERR'));
                        continue;
                    }
                }
            }
        }
    }
    catch(Exception ex){
        GlobalUtility.logMessage('Error', 'PopulateAndUpdateFields Trigger Record Type Change Block', 'Trigger', null, null, ex.getMessage(), null,null,ex, null);
        throw ex;
    }

/************************Case 00084460 - Configuration should not be deleted changes done by Dilip jha Ends*******************************/
}