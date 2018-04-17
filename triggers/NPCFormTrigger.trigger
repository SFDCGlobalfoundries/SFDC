/*
    Author: Zymark Ambat
    Description: This Trigger manages the auto creation of a Retrofit Device when the NPC Form status becomes 'In Execution'.
    History: 
        ZAmbat      06112013    - Code creation.
        Nbustillos  08142013    - Updated code to use Environment Variable for hardcoded values.
        ZAmbat      09242013    - Updated code - Change NPC Status 'Submitted' to 'Pending CE Approval'.
        ZAmbat      09302013    - Updated code - Requery fields that are being copied into new Retrofit Device.
        ZAmbat      10012013    - Updated code - Query max increment of CRMDID and created new instance of Device instead of cloning devices.
        Asolito     10012013    - added logic to set for approval records to approved when the status is set to Closed
        ZAmbat      10032013    - added handling for CRMDIDs not in CDIDXXXXXX.XX format.
        ZAmbat      10042013    - Updated code - Set NPC Form status to 'Closed' when Device Fab is 1 or 8 (TASK-299).
        ZAmbat      10252013    - updated code to populate Base_Device_Device_Id with the Base Device's CRMDID Base value.
        ZAmbat      11132013    - updated code to create Retrofit Device upon submission when Tapeout Required = 'Yes'.
        ZAmbat      11132013    - updated code to remove code voiding the previously created Retrofit Device.
        ZAmbat      11152013    - updated code to remove Retrofit Device validation and autopopulate fields that are required in Retrofit Device creation.
        ZAmbat      11212013    - updated code to copy Process Family Filter and Geometry Filter into the Retrofit device.
        ZAmbat      12052013    - Updated code to replace '-' or '-U' on the last part only (TASK-663).
        ARoy        01102014    - Updated code to populate Automotive Device from NPC Form.
        ARoy        01282014    - Updated the code to allow retrofit device creation for NPC Form Status = 'Pending Resubmission' (Case - 00005103)
        ZAmbat      01282014    - Updated code as per CASE 4515.
        ZAmbat      02042014    - Updated code as per CASE 5240 (Merge NPC Status 'Executed' and 'Closed' into 'Executed').
        ARoy        02172014    - Added the Skip Trigger code.
        ZAmbat      03052014    - Updated code as per CASE 4882.
        ZAmbat      04032014    - Updated code as per CASE 7400.
        Tlai        03042014    - Added code to clone CDRS as per Case 6114
        ZAmbat      04042014    - Updated code as per CASE 8489.
        ZAmbat      04162014    - Populate Device__c.NPC_Form_Originating_Device__c when creating a Retrofit Device.
        ZAmbat      05152014    - Updated code as per the BX041Clone.cloneBX041Method changes.
        ZAmbat      07092014    - Updated code as per CASE 27667.
        ZAmbat      08192014    - Updated code as per CASE 32408.
        DBiswal     01122015    - Updated code to for CDRS Cloning for all Reason for New Part.
        DBiswal     01202015    - Added code for new Reason for New Part field values.
        ZAmbat      02102015    - Updated code to clear Assigned PID  in CDRS if PIYE rejects the form.
        DBiswal     03062015    - Updated code for Reason for New Part new field value 'ShortLoop Flow'.
        Vijay       03022015    - updated code to support the Internal Device NPC Form functionality.
        SArora      07092015    - code modified for case # 43455, so that device stage become tapeout for change in pid and fab transfer
        Mseth       27082015    - updated Mask set Title Lookup from Base Device.
        jabee       20102016    - updated by addeding the  Generate_Standard_Frame__c in soql in line number 216
        jabee       06092017    - updated by Added line 733 to do Recursive check
    SNune    21102015  - Updated code to fix case 47700
        Pradosh     01302018    - Case#00084211. Copying Iot Application field in Device
*/

trigger NPCFormTrigger on New_Part_Creation_Form__c (before insert, after insert, before update, after update) {
    // Added by Nbustillos, load environment variables.
    final string NPC_STATUS_IN_EXEC = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
    final string NPC_STATUS_SUBMITTED = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
    final string NPC_STATUS_VOID = EnvironmentVariable.get('NPC_STATUS_VOID');
    final string NPC_STATUS_EXEC = EnvironmentVariable.get('NPC_STATUS_EXEC');
    final string NPC_STATUS_NOT_EXEC = EnvironmentVariable.get('NPC_STATUS_NOT_EXEC');
    final string NPC_REASON_RETROFIT = EnvironmentVariable.get('NPC_REASON_RETROFIT');
    final string NPC_REASON_RETROFIT_ADD_ROM = EnvironmentVariable.get('NPC_REASON_RETROFIT_ADD_ROM');
    final string NPC_REASON_PROBE_NEW_CARD = EnvironmentVariable.get('NPC_REASON_PROBE_NEW_CARD');
    final string NPC_REASON_CHANGE_PID = EnvironmentVariable.get('NPC_REASON_CHANGE_PID');
    final string NPC_REASON_FAB_TRANSFER = EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER');
    final string NPC_REASON_STARTINGMATERIAL = EnvironmentVariable.get('NPC_REASON_STARTINGMATERIAL');    //DBiswal 01202015
    final string NPC_REASON_BACKGROUNDTHICKNESS = EnvironmentVariable.get('NPC_REASON_BACKGROUNDTHICKNESS');    //DBiswal 01202015
    final string NPC_REASON_SHORTLOOP_FLOW = EnvironmentVariable.get('NPC_REASON_SHORTLOOP_FLOW');    
    final string NPC_REASON_OTHERS = EnvironmentVariable.get('NPC_REASON_OTHERS');
    final string NPC_REQUIRE_TO_CREATE_YES = EnvironmentVariable.get('NPC_REQUIRE_TO_CREATE_YES');
    final string NPC_STATUS_CLOSED = EnvironmentVariable.get('NPC_STATUS_CLOSED');
    final string NPC_STATUS_PEND_SUBMISSION = EnvironmentVariable.get('NPC_STATUS_PEND_SUBMISSION');
    final string NPC_STATUS_PEND_RESUBMISSION = EnvironmentVariable.get('NPC_STATUS_PEND_RESUB');
    
    final string NPC_TAPEOUT_REQUIRED_YES = EnvironmentVariable.get('NPC_TAPEOUT_REQUIRED_YES');
    final string DEVICE_STAGE_DESIGNIN = EnvironmentVariable.get('DEVICE_STAGE_DESIGNIN');
    final string REQUIRED_ON_IN_DESIGN_STAGE = EnvironmentVariable.get('REQUIRED_ON_IN_DESIGN_STAGE');
    final string DEVICE_STAGE_TAPEOUT = EnvironmentVariable.get('DEVICE_STAGE_TAPEOUT');
    
    final string DEVICE_TYPE_RETROFIT = EnvironmentVariable.get('DEVICE_TYPE_RETROFIT');
    final string DEVICE_STATUS_ACTIVE = EnvironmentVariable.get('DEVICE_STATUS_ACTIVE');
    final string DEVICE_TAPEOUT_TYPE_RETROFIT = EnvironmentVariable.get('DEVICE_TAPEOUT_TYPE_RETROFIT');
    final string DEVICE_GSOP_TPLAN_NO = EnvironmentVariable.get('DEVICE_GSOP_TPLAN_NO');
    final string DEVICE_STAGE_VOID = EnvironmentVariable.get('DEVICE_STAGE_VOID'); 
    final string NPC_STATUS_PEND_PID_REASSIGN = EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN');
    
    if(!IntegrationUserUtil.isSkipTrigger()){  
        system.debug('SOQL Queries 1.1 =================> ' + Limits.getQueries());
        if (NPCFormTrigerStopper.isExecuted == false) {
            Set<Id> deviceIds = new Set<Id>();
            Set<Id> deleteNPCIds = new Set<Id>();
            Set<Id> npcCaseIds = new Set<Id>();
            Set<Id> npcIds1 = new Set<Id>();
            List<New_Part_Creation_Form__c> listNPC = new List<New_Part_Creation_Form__c>();  
            for (New_Part_Creation_Form__c npc : trigger.New) {
                if (trigger.isInsert) {
                    if (trigger.isBefore) {
                        // Set NPC Form Owner
                        npc.Owner__c = UserInfo.getUserId();
                        
                        // New Part Id to upper case
                        npc.New_Part_ID__c = npc.New_Part_ID__c.toUpperCase();     
                    } else if (trigger.isAfter) {
                        if (npc.NPC_Form_Status__c == NPC_STATUS_IN_EXEC) { 
                            listNPC.add(npc);
                            deviceIds.add(npc.Originating_Device__c);
                        }
                    }
                } else if (trigger.isUpdate) {
                    if (trigger.isBefore) {
                        // New Part Id to upper case
                        npc.New_Part_ID__c = npc.New_Part_ID__c.toUpperCase();
                    } else if (trigger.isAfter) {
                        System.debug('---npc.NPC_Form_Status__c----------'+npc.NPC_Form_Status__c);
                        System.debug('---trigger.oldMap.get(npc.Id).NPC_Form_Status__c----------'+trigger.oldMap.get(npc.Id).NPC_Form_Status__c);
                        // ZAmbat 11132013
                        /*if ((npc.NPC_Form_Status__c == NPC_STATUS_IN_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_SUBMITTED) 
                             && npc.New_Part_ID__c != npc.BASE_Device_ID__c
                             && npc.Device_Type__c != 'Add ROM Code'
                             && npc.Reason_for_New_Part__c == NPC_REASON_RETROFIT) {
                            listNPC.add(npc);
                            deviceIds.add(npc.BASE_Device_ID__c);*/
                        // ARoy 01282014 - Updated the code to allow retrofit device creation for NPC Form Status = 'Pending Resubmission' (Case - 00005103)
                        if (((((npc.NPC_Form_Status__c == NPC_STATUS_IN_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_SUBMITTED) 
                             || (npc.NPC_Form_Status__c == NPC_STATUS_IN_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_PEND_RESUBMISSION)
                             || (npc.NPC_Form_Status__c == NPC_STATUS_PEND_PID_REASSIGN && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_SUBMITTED))
                             && npc.Tapeout_Required__c != NPC_TAPEOUT_REQUIRED_YES)
                             || (((npc.NPC_Form_Status__c == NPC_STATUS_SUBMITTED && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_PEND_SUBMISSION) 
                             || (npc.NPC_Form_Status__c == NPC_STATUS_SUBMITTED && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_PEND_RESUBMISSION))
                             && npc.Tapeout_Required__c == NPC_TAPEOUT_REQUIRED_YES))
                             && npc.New_Part_ID__c != npc.BASE_Device_ID__c
                             && npc.Device_Type__c != 'Add ROM Code'
                             && (npc.Reason_for_New_Part__c == NPC_REASON_RETROFIT
                             || npc.Reason_for_New_Part__c == NPC_REASON_RETROFIT_ADD_ROM
                             || npc.Reason_for_New_Part__c == NPC_REASON_PROBE_NEW_CARD
                             || npc.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER  // ZAmbat 12022014   
                             || npc.Reason_for_New_Part__c == NPC_REASON_CHANGE_PID
                             || npc.Reason_for_New_Part__c == NPC_REASON_BACKGROUNDTHICKNESS    //DBiswal 01202015
                             || npc.Reason_for_New_Part__c == NPC_REASON_STARTINGMATERIAL    //DBiswal 01202015
                             || npc.Reason_for_New_Part__c == NPC_REASON_SHORTLOOP_FLOW
                             || (npc.Reason_for_New_Part__c == NPC_REASON_OTHERS && npc.Require_To_Create_The_New_Part__c == NPC_REQUIRE_TO_CREATE_YES))) {
                            listNPC.add(npc);
                            deviceIds.add(npc.Originating_Device__c);
                        // ZAmbat 11132013
                        /*} else if (npc.NPC_Form_Status__c == NPC_STATUS_NOT_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_IN_EXEC) {
                            deleteNPCIds.add(npc.Id);*/
                        } else if (npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CUSTOMERNAMECHANGE').Value__c && npc.NPC_Form_Status__c == NPC_STATUS_IN_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_SUBMITTED) {
                            npcCaseIds.add(npc.Id);
                        } else if ((npc.NPC_Form_Status__c == NPC_STATUS_PEND_RESUBMISSION && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_IN_EXEC)
                                    && (npc.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER || npc.Reason_for_New_Part__c == NPC_REASON_CHANGE_PID)) {
                            npcIds1.add(npc.Id);
                        }else if(npc.NPC_Form_Status__c == NPC_STATUS_EXEC && trigger.oldMap.get(npc.Id).NPC_Form_Status__c == NPC_STATUS_PEND_SUBMISSION){
                            //added by Vijay 03112015- added this block for Internal Device NPC Form. 
                            //NPC Forms will be auto approved and the Retrofit device will be created under the Internal Device.
                            listNPC.add(npc);
                            deviceIds.add(npc.Originating_Device__c);
                        }                 
                    }

                }
            }
            
            // ZAmbat 02102015
            if (npcIds1.size() > 0) {
                NPCFormCDRS.clearAssignedPID(npcIds1);
            }
            
            // Create Retrofit Device
            if (listNPC.size() > 0) {
                // Retrieve Device info
                // ZAmbat 09302013 - Requery fields for new Retrofit Device
                //IP_Declaration_Submitted_Date__c field added by Sunil Arora for case # 35700
                Map<Id, Device__c> mapDevice = new Map<Id, Device__c>([
                    SELECT  Id
                            , Name
                            , Device_ID__c
                            , CRMDID__c
                            , Opportunity2__c
                            , Account__c
                            , Stage__c
                            , Status__c
                            , Account_Short_Name__c
                            , Geometry__c
                            , Process_Family__c
                            , Assigned_Process_Id__c
                            , Process_Technology__c
                            , Process_IP_Technology__c
                            , Fab__c
                            , Tapeout_Type__c
                            , Reticle_Type__c
                            , Pre_PTRF_Validation_Status__c
                            , GSOP_Assignment_Tapeout_Plan__c
                            , Device_Mask_Set_Title__c
                            , Project_Name__c
                            , Device_Purpose__c
                            , Business_Unit__c
                            , Product_Line__c
                            , Special_Scribe_Width__c
                            , BX041_Status__c
                            , End_Application__c
                            , Iot_Application__c
                            , Opportunity2__r.Iot_Application__c
                            , Confidence_Level_Tapeout__c
                            , End_Customer__c
                            , Market_Segment__c
                            , Semiconductor_Device__c
                            , Export_Control_Waiver_Flag__c
                            , D1_National_Access_Allowed__c
                            , Device_Type__c
                            , Base_Device_Device_Id__c
                            , IP_Declaration_Status__c
                            , Export_Control_Status__c
                            , Requested_Process_Id__c
                            , Requested_Process_Name__c
                            , Secure_Device__c
                            , Secure_Device_Level__c
                            , Automotive_Device__c
                            , Automotive_Grade__c 
                            , BASE_Device__c
                            , Opportunity_Program__c
                            , Device_Sourcing__c
                            , Original_Forecasted_Tapeout_Date__c
                            , Current_Forecast_Tapeout_Date__c
                            , Opportunity2__r.Market_Segment__c
                            , Opportunity2__r.End_Application_for_Opty__c
                            , Opportunity2__r.Fab_Assignment_1__c
                            , Process_Family_Filter__c
                            , Geometry_Filter__c
                            , IP_Declaration_Submitted_Date__c
                            , Internal_Device_Geometry__c
                            , Internal_Device_Process_Family__c
                            , Mask_Set_Title_Lookup__c
                            , Generate_Standard_Frame__c
                            , RecordTypeId
                            , RecordType.DeveloperName
							, ECCN_Technology__c
                            , ECCN_Wafer__c
                            , ITAR_Flag__c
                            , Is_ITAR__c
                            , ECCN_Color__c
                    FROM    Device__c
                    WHERE   Id IN :deviceIds
                ]);
                
                // Clone Base Devices
                List<Device__c> listDevice = new List<Device__c>(); 
                Set<Id> npcIds = new Set<Id>();
                system.debug('listNPC size ==================> ' + listNPC.size());
                for (New_Part_Creation_Form__c npc : listNPC) {
                    // Set fields
                    // ZAmbat 12062013
                    string tempName = npc.New_Part_ID__c;
                    // Check if New Part Id has '-U' or '-'
                    if (npc.New_Part_ID__c.indexOf('-') > -1) {
                        List<string> listCharacters = Environment_Variable__c.getInstance('NPC_NEW_PART_ID_REPLACE_LIST').Value__c.split(';');
                        string lastPart = npc.New_Part_ID__c.substring(npc.New_Part_ID__c.lastIndexOf('-'));
                        
                        for (string s : listCharacters) {
                            system.debug('s ===================> ' + s);
                            lastPart = lastPart.toUpperCase().replace(s, '');
                        }
                        
                        if (lastPart.length() == 2) {
                            try {
                                Integer numberCheck = Integer.valueOf(lastPart);
                                tempName = npc.New_Part_ID__c.substring(0, npc.New_Part_ID__c.lastIndexOf('-')) + '.' + String.valueOf(numberCheck).leftPad(2).replace(' ', '0');
                                system.debug('tempName ======================> ' + tempName);
                            } catch (Exception e) {
                                tempName = npc.New_Part_ID__c;
                            }
                        }
                    }
                    
                    /*List<Device__c> listDevice1 = [
                        SELECT      Id
                        FROM        Device__c
                        WHERE       Name = :string.valueOf(npc.New_Part_ID__c).replace('-U', '.').replace('-', '.')
                                    AND NPC_Form__c = :npc.Id
                    ];*/
                    
                    List<Device__c> listDevice1 = [
                        SELECT      Id
                        FROM        Device__c
                        WHERE       Name = :tempName.toUpperCase()
                                    AND Device_Id__c = :(tempName + Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c).toUpperCase()
                    ];
                    system.debug('SOQL Queries 1.2 =================> ' + Limits.getQueries());
                    system.debug('listDevice1 size =================> ' + listDevice1.size());
                    if (listDevice1.size() <= 0) {
                        //Device__c tempDevice = mapDevice.get(npc.Originating_Device__c).clone(false, true);
                        // ZAmbat 12062013 - Removed
                        /*string tempName = string.valueOf(npc.New_Part_ID__c);
                        tempName = tempName.replace('-U', '.');
                        tempName = tempName.replace('-', '.');*/
                        
                        Device__c tempDevice = new Device__c(); 
                        
                        tempDevice.Name = tempName;  
                        tempDevice.Device_ID__c = tempName;
                        
                        // Set CRMDID
                        string tempCRMDID = mapDevice.get(npc.Originating_Device__c).CRMDID__c.substringBefore('.') + '%';
                        List<Device__c> listDev = [
                            SELECT      Id
                                        , CRMDID__c
                            FROM        Device__c
                            WHERE       CRMDID__c LIKE :tempCRMDID
                            ORDER BY    CRMDID__c DESC
                        ];
                        
                        if (listDev.size() > 0) {
                            // ZAmbat 10032013
                            // Check value
                            Pattern isNumbers = Pattern.Compile('^[0-9]+$');
                            Matcher numbersMatch = isNumbers.matcher(listDev[0].CRMDID__c.substringAfter('.'));
                            
                            if (numbersMatch.Matches()) {
                                tempDevice.CRMDID__c = listDev[0].CRMDID__c.substringBefore('.') + '.' + String.valueOf(Integer.valueOf(listDev[0].CRMDID__c.substringAfter('.')) + 1).leftPad(2).replace(' ', '0');    
                            } else {
                                tempDevice.CRMDID__c = listDev[0].CRMDID__c.substringBefore('.') + '.' + String.valueOf(1).leftPad(2).replace(' ', '0');
                            }
                        }
                        
                        if(mapDevice.get(npc.Originating_Device__c).Opportunity2__c != null){
                            tempDevice.Opportunity2__c = mapDevice.get(npc.Originating_Device__c).Opportunity2__c;
                        }
                        tempDevice.Account__c = mapDevice.get(npc.Originating_Device__c).Account__c;
                        
                        if (npc.Tapeout_Required__c == NPC_TAPEOUT_REQUIRED_YES) {
                            tempDevice.Stage__c = DEVICE_STAGE_DESIGNIN;
                            
                            // Validate required fields
                            // ZAmbat 11152013 - Removed
                            /*Error_Codes__c ec = Error_Codes__c.getInstance('REQUIRED_ON_IN_DESIGN_STAGE');
                            if (mapDevice.get(npc.Originating_Device__c).Confidence_Level_Tapeout__c == null) {
                                npc.addError(ec.Message__c);
                                return; 
                            } else if (mapDevice.get(npc.Originating_Device__c).Device_Sourcing__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            } else if (mapDevice.get(npc.Originating_Device__c).End_Application__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            } else if (mapDevice.get(npc.Originating_Device__c).Fab__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            } else if (mapDevice.get(npc.Originating_Device__c).GSOP_Assignment_Tapeout_Plan__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            } else if (mapDevice.get(npc.Originating_Device__c).Market_Segment__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            /} else if (tempDevice.Original_Forecasted_Tapeout_Date__c == null) {
                                npc.addError(ec.Message__c);
                                return;/
                            } else if (mapDevice.get(npc.Originating_Device__c).Semiconductor_Device__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            } else if (mapDevice.get(npc.Originating_Device__c).Tapeout_Type__c == null) {
                                npc.addError(ec.Message__c);
                                return;
                            }*/
                        } else {
                            if (npc.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER || npc.Reason_for_New_Part__c == NPC_REASON_CHANGE_PID) {  
                                //tempDevice.Stage__c = DEVICE_STAGE_DESIGNIN;
                                tempDevice.Stage__c = DEVICE_STAGE_TAPEOUT;//code modified by Sunil Arora for case # 43455
                            } else {
                                tempDevice.Stage__c = DEVICE_STAGE_TAPEOUT;
                            }
                        }
                        
                        tempDevice.Status__c = DEVICE_STATUS_ACTIVE;
                        
                        if (npc.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER || npc.Reason_for_New_Part__c == NPC_REASON_CHANGE_PID) {
                            tempDevice.Assigned_Process_Id__c = null;
                            tempDevice.Requested_Process_ID__c = null;
                        } else {
                            tempDevice.Assigned_Process_Id__c = mapDevice.get(npc.Originating_Device__c).Assigned_Process_Id__c;
                            tempDevice.Requested_Process_Id__c = mapDevice.get(npc.Originating_Device__c).Requested_Process_Id__c;
                        }
                        
                        // ZAmbat 11212013
                        tempDevice.Process_Family_Filter__c = mapDevice.get(npc.Originating_Device__c).Process_Family_Filter__c;
                        tempDevice.Geometry_Filter__c = mapDevice.get(npc.Originating_Device__c).Geometry_Filter__c;
                        
                        tempDevice.Process_IP_Technology__c = mapDevice.get(npc.Originating_Device__c).Process_IP_Technology__c;
                        //tempDevice.Fab__c = mapDevice.get(npc.Originating_Device__c).Fab__c;
                        tempDevice.Tapeout_Type__c = DEVICE_TAPEOUT_TYPE_RETROFIT;
                        if(npc.BASE_Device__r.CDRS_approval_User__c!='' || npc.BASE_Device__r.CDRS_approval_User__c!=null){//added jabee
                            tempDevice.CDRS_approval_User__c=npc.BASE_Device__r.CDRS_approval_User__c;
                        }
                        tempDevice.Reticle_Type__c = mapDevice.get(npc.Originating_Device__c).Reticle_Type__c;
                        tempDevice.Pre_PTRF_Validation_Status__c = mapDevice.get(npc.Originating_Device__c).Pre_PTRF_Validation_Status__c;
                        tempDevice.GSOP_Assignment_Tapeout_Plan__c = DEVICE_GSOP_TPLAN_NO;
                        
                        // ZAmbat 03052014 
                        //if (npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c && npc.Tapeout_Required__c != Environment_Variable__c.getInstance('NPC_TAPEOUT_REQUIRED_YES').Value__c) {
                        if ((npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c 
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c    //DBiswal 01202015    
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c       //DBiswal 01202015
                             || npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c
                             || (npc.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c && npc.Require_To_Create_The_New_Part__c == Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c)))
                             { // && npc.Tapeout_Required__c != Environment_Variable__c.getInstance('NPC_TAPEOUT_REQUIRED_YES').Value__c
                            //tempDevice.Device_Mask_Set_Title__c = mapDevice.get(npc.Originating_Device__c).Device_Mask_Set_Title__c;
                            // ZAmbat 01282014
                            tempDevice.Device_Mask_Set_Title__c = npc.Mask_Set_Title__c;
                            //added by Mseth 27082015
                            if(mapDevice.get(npc.Originating_Device__c).Mask_Set_Title_Lookup__c!= Null){
                                tempDevice.Mask_Set_Title_Lookup__c = mapDevice.get(npc.Originating_Device__c).Mask_Set_Title_Lookup__c;
                            }
                        }
                        
                        tempDevice.Project_Name__c = mapDevice.get(npc.Originating_Device__c).Project_Name__c;
                        tempDevice.Device_Purpose__c = mapDevice.get(npc.Originating_Device__c).Device_Purpose__c;
                        tempDevice.Special_Scribe_Width__c = mapDevice.get(npc.Originating_Device__c).Special_Scribe_Width__c;
                        tempDevice.BX041_Status__c = mapDevice.get(npc.Originating_Device__c).BX041_Status__c;
                        //tempDevice.End_Application__c = mapDevice.get(npc.Originating_Device__c).End_Application__c;
                        tempDevice.Confidence_Level_Tapeout__c = '100';
                        tempDevice.End_Customer__c = mapDevice.get(npc.Originating_Device__c).End_Customer__c;
                        //tempDevice.Market_Segment__c = mapDevice.get(npc.Originating_Device__c).Market_Segment__c;
                        //tempDevice.Semiconductor_Device__c = mapDevice.get(npc.Originating_Device__c).Semiconductor_Device__c;
                        tempDevice.Export_Control_Waiver_Flag__c = mapDevice.get(npc.Originating_Device__c).Export_Control_Waiver_Flag__c;
                        tempDevice.D1_National_Access_Allowed__c = mapDevice.get(npc.Originating_Device__c).D1_National_Access_Allowed__c;
                        tempDevice.Device_Type__c = DEVICE_TYPE_RETROFIT;
                        
                        tempDevice.Business_Unit__c = mapDevice.get(npc.Originating_Device__c).Business_Unit__c;
                        tempDevice.Product_Line__c = mapDevice.get(npc.Originating_Device__c).Product_Line__c;
                        
                        // ZAmbat 10252013
                        //tempDevice.Base_Device_Device_Id__c = mapDevice.get(npc.Originating_Device__c).Name;
                        tempDevice.Base_Device_Device_Id__c = mapDevice.get(npc.Originating_Device__c).CRMDID__c.substringBefore('.');
                        
                        tempDevice.IP_Declaration_Status__c = mapDevice.get(npc.Originating_Device__c).IP_Declaration_Status__c;
                        tempDevice.Export_Control_Status__c = mapDevice.get(npc.Originating_Device__c).Export_Control_Status__c;
                        //tempDevice.Requested_Process_Id__c = mapDevice.get(npc.Originating_Device__c).Requested_Process_Id__c;
                        tempDevice.Secure_Device__c = npc.Secure_Device__c;
                        tempDevice.Secure_Device_Level__c = mapDevice.get(npc.Originating_Device__c).Secure_Device_Level__c;
                        tempDevice.Automotive_Device__c  = npc.Automotive_Device__c ;
                        tempDevice.Automotive_Grade__c  = npc.Automotive_Grade__c;//Updated By Gopi
                        if (mapDevice.get(npc.Originating_Device__c).Device_Type__c == 'Base') {
                            tempDevice.Base_Device__c = npc.Originating_Device__c;    
                        } else {
                            tempDevice.Base_Device__c = npc.BASE_Device__c;
                        }
                        
                        if(mapDevice.get(npc.Originating_Device__c).Opportunity_Program__c != null){
                            tempDevice.Opportunity_Program__c = mapDevice.get(npc.Originating_Device__c).Opportunity_Program__c;
                        }
                        //tempDevice.Device_Sourcing__c = mapDevice.get(npc.Originating_Device__c).Device_Sourcing__c;
                        tempDevice.NPC_Form__c = npc.Id;
                        tempDevice.NPC_Form_Originating_Device__c = npc.Originating_Device__c;
                        
                        // ZAmbat 11152013
                        /*if (mapDevice.get(npc.Originating_Device__c).Original_Forecasted_Tapeout_Date__c != null) {
                            tempDevice.Original_Forecasted_Tapeout_Date__c = mapDevice.get(npc.Originating_Device__c).Original_Forecasted_Tapeout_Date__c;
                        } else {
                            tempDevice.Original_Forecasted_Tapeout_Date__c = date.today().addMonths(1);
                        }*/
                        
                        // ZAmbat 07092014
                        if (npc.Current_Forecast_Tapeout_Date__c != null) {
                            tempDevice.Original_Forecasted_Tapeout_Date__c = npc.Current_Forecast_Tapeout_Date__c;
                            tempDevice.Current_Forecast_Tapeout_Date__c = npc.Current_Forecast_Tapeout_Date__c;
                        } else {
                            tempDevice.Original_Forecasted_Tapeout_Date__c = mapDevice.get(npc.Originating_Device__c).Original_Forecasted_Tapeout_Date__c;
                            tempDevice.Current_Forecast_Tapeout_Date__c = mapDevice.get(npc.Originating_Device__c).Current_Forecast_Tapeout_Date__c;
                        }
                        
                        if (mapDevice.get(npc.Originating_Device__c).Device_Sourcing__c != null) {
                            tempDevice.Device_Sourcing__c = mapDevice.get(npc.Originating_Device__c).Device_Sourcing__c;
                        } else {
                            tempDevice.Device_Sourcing__c = 'NONE';
                        }
                        
                        if (mapDevice.get(npc.Originating_Device__c).Market_Segment__c != null) {
                            tempDevice.Market_Segment__c = mapDevice.get(npc.Originating_Device__c).Market_Segment__c;
                        } else {
                            tempDevice.Market_Segment__c = mapDevice.get(npc.Originating_Device__c).Opportunity2__r.Market_Segment__c;
                        }
                        
                        if (mapDevice.get(npc.Originating_Device__c).End_Application__c != null) {
                            tempDevice.End_Application__c = mapDevice.get(npc.Originating_Device__c).End_Application__c;
                        } else {
                            tempDevice.End_Application__c = mapDevice.get(npc.Originating_Device__c).Opportunity2__r.End_Application_for_Opty__c;
                        }
                        
                        if (mapDevice.get(npc.Originating_Device__c).Iot_Application__c != null) {
                            tempDevice.Iot_Application__c = mapDevice.get(npc.Originating_Device__c).Iot_Application__c;
                        } else {
                            tempDevice.Iot_Application__c = mapDevice.get(npc.Originating_Device__c).Opportunity2__r.Iot_Application__c;
                        }
                        
                        if (mapDevice.get(npc.Originating_Device__c).Semiconductor_Device__c != null) {
                            tempDevice.Semiconductor_Device__c = mapDevice.get(npc.Originating_Device__c).Semiconductor_Device__c;
                        } else {
                            tempDevice.Semiconductor_Device__c = 'Standard Logic';
                        }
                        
                        // ZAmbat 12022014
                        if (npc.Reason_for_New_Part__c == NPC_REASON_FAB_TRANSFER) {
                            tempDevice.Fab__c = npc.New_Fab__c;
                        } else {
                            if (mapDevice.get(npc.Originating_Device__c).Fab__c != null) {
                                tempDevice.Fab__c = mapDevice.get(npc.Originating_Device__c).Fab__c;  
                            } else {
                                tempDevice.Fab__c = mapDevice.get(npc.Originating_Device__c).Opportunity2__r.Fab_Assignment_1__c;
                            }
                        }
                        //IP_Declaration_Submitted_Date__c field added by Sunil Arora for case # 35700
                        if (mapDevice.get(npc.Originating_Device__c).IP_Declaration_Submitted_Date__c != null) {
                            tempDevice.IP_Declaration_Submitted_Date__c = mapDevice.get(npc.Originating_Device__c).IP_Declaration_Submitted_Date__c;                        
                        }
                        
                        // added by Vijay 03032015 - set new Device record type to NPC Originating Device record type
                        tempDevice.RecordTypeId = mapDevice.get(npc.Originating_Device__c).RecordTypeId;
                        
                        if( mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName != null && ( mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName == 'Internal_Device'
                                                             ||  mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName == 'Internal_Device_Read_Only')){
                            tempDevice.Internal_Device_Geometry__c =  mapDevice.get(npc.Originating_Device__c).Internal_Device_Geometry__c;
                            tempDevice.Internal_Device_Process_Family__c = mapDevice.get(npc.Originating_Device__c).Internal_Device_Process_Family__c;
                        }
            //changes made for copy configurator     
                        tempDevice.Configuration_Status__c = NULL;    
                        tempDevice.Configuration__c = NULL;
                        if(mapDevice.get(npc.Originating_Device__c).Generate_Standard_Frame__c !=null){
                            tempDevice.Generate_Standard_Frame__c = mapDevice.get(npc.Originating_Device__c).Generate_Standard_Frame__c;
                        }
                        if( mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName != null && ( mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName == 'Internal_Device'
                                                             ||  mapDevice.get(npc.Originating_Device__c).RecordType.DeveloperName == 'Internal_Device_Read_Only')){
                            if(mapDevice.get(npc.Originating_Device__c).ECCN_Technology__c !=null){
                                tempDevice.ECCN_Technology__c = mapDevice.get(npc.Originating_Device__c).ECCN_Technology__c;
                            }else{
                                tempDevice.ECCN_Technology__c = Environment_Variable__c.getInstance('DEVICE_ECCN_TECH_INTERNALDEV_DEFAULT').Value__c;
                            }
                            if(mapDevice.get(npc.Originating_Device__c).ECCN_Wafer__c !=null){
                                tempDevice.ECCN_Wafer__c = mapDevice.get(npc.Originating_Device__c).ECCN_Wafer__c;
                            }else{
                                tempDevice.ECCN_Wafer__c = Environment_Variable__c.getInstance('DEVICE_ECCN_WAFER_INTERNALDEV_DEFAULT').Value__c;
                            }
                            if(mapDevice.get(npc.Originating_Device__c).ITAR_Flag__c !=null){
                                tempDevice.ITAR_Flag__c = mapDevice.get(npc.Originating_Device__c).ITAR_Flag__c;
                            }else{
                                tempDevice.ITAR_Flag__c = Environment_Variable__c.getInstance('DEVICE_ITAR_FLAG_INTERNALDEV_DEFAULT').Value__c;
                            }
                            if(mapDevice.get(npc.Originating_Device__c).Is_ITAR__c !=null){
                                tempDevice.Is_ITAR__c = mapDevice.get(npc.Originating_Device__c).Is_ITAR__c;
                            }else{
                                tempDevice.Is_ITAR__c = Environment_Variable__c.getInstance('DEVICE_ITAR_CLASS_INTERNALDEV_DEFAULT').Value__c;
                            }
                            if(mapDevice.get(npc.Originating_Device__c).ECCN_Color__c !=null){
                                tempDevice.ECCN_Color__c = mapDevice.get(npc.Originating_Device__c).ECCN_Color__c;
                            }else{
                                tempDevice.ECCN_Color__c = Environment_Variable__c.getInstance('DEVICE_ECCN_COLOR_INTERNALDEV_DEFAULT').Value__c;
                            }
							if(mapDevice.get(npc.Originating_Device__c).D1_National_Access_Allowed__c !=null){
                                tempDevice.D1_National_Access_Allowed__c = mapDevice.get(npc.Originating_Device__c).D1_National_Access_Allowed__c;
                            }else{
                                tempDevice.D1_National_Access_Allowed__c = Environment_Variable__c.getInstance('DEVICE_D1_FLAG_INTERNALDEV_DEFAULT').Value__c;
                            }
                        }
                        tempDevice.Is_CDSCreated__c = false;
                        tempDevice.CDS_Number__c = NULL;
                        listDevice.add(tempDevice);
                        npcIds.add(npc.Id);
                    }
                }
                
                if (listDevice.size() > 0) {
                    insert listDevice;
                    system.debug('SOQL Queries 1 =================> ' + Limits.getQueries());
                    //Tlai 03042014 added code to clone cdrs
                    system.debug('listDevice ===================================> ' + listDevice);
                    //BX041Clone bx41 = new BX041Clone();
                    //bx41.cloneBX041Method(listDevice);
                    //DBiswal 01122015 - Uncommented to clone cdrs records                    
                    Set<Id> setDeviceIds = new Set<Id>();
                    for (Device__c d : listDevice) {
                        if(d.fab__c != 'FAB 1'){
                            setDeviceIds.add(d.Id);
                        }
                    }
                    if(setDeviceIds.size()>0){
                        BX041Clone.cloneBX041Method(setDeviceIds);
                    }
                    
                    //NPCCopyConfigurationController.prepareDataForClone(Trigger.New[0].Originating_Device__c,listDevice[0].Id,'NPC',Trigger.New[0].Reason_for_New_Part__c);
                    //Pagereference pg = new Pagereference('/apex/NPCCopyConfiguration?oldDeviceId='+Trigger.New[0].Originating_Device__c+'&newDeviceId='+listDevice[0].Id+'&mode=NPC&reasonForRetrofit='+Trigger.New[0].Reason_for_New_Part__c); 
                   // pg.getContent();
                    NPCCopyConfigurationController.getNPCPageContent(Trigger.New[0].Originating_Device__c,listDevice[0].Id,'NPC',Trigger.New[0].Reason_for_New_Part__c);
                    
                    
                    system.debug('SOQL Queries 2 =================> ' + Limits.getQueries());
                    // ZAmbat 10232013
                    Set<Id> devIds = new Set<Id>();
                    for (Device__c d : listDevice) {
                        devIds.add(d.Id);
                    }
                    
                    listDevice = new List<Device__c>();
                    listDevice = [
                        SELECT      Id
                                    , CRMDID__c
                                    , Device_Mask_Set_Title__c
                                    , Geometry__c
                                    , Status__c
                                    , NPC_Form__c
                                    , Fab__c
                                    , Device_Type__c
                        FROM        Device__c
                        WHERE       Id IN :devIds
                    ];
                               
                    // Update NPC Forms
                    Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>([
                        SELECT      Id
                                    , Name
                                    , CRM_DID__c
                                    , Mask_Set_Title__c
                                    , Geometry__c
                                    , Device_Status__c
                                    , NPC_Form_Status__c
                        FROM        New_Part_Creation_Form__c
                        WHERE       Id IN :trigger.New
                    ]);
                     
                    List<New_Part_Creation_Form__c> listUpdateNPC = new List<New_Part_Creation_Form__c>(); 
                    for (Device__c d : listDevice) {
                        New_Part_Creation_Form__c tempNPC = mapNPC.get(d.NPC_Form__c);
                        tempNPC.CRM_DID__c = d.CRMDID__c;
                        // ZAmbat 01282014 - Removed
                        //tempNPC.Mask_Set_Title__c = d.Device_Mask_Set_Title__c;
                        tempNPC.Geometry__c = d.Geometry__c;
                        tempNPC.Device_Status__c = d.Status__c;
                        
                        // ZAmbat 10042013
                        if ((d.Fab__c == 'FAB 1' || d.Fab__c == 'FAB 8') && (d.Device_Type__c == DEVICE_TYPE_RETROFIT)) {
                            //tempNPC.NPC_Form_Status__c = NPC_STATUS_CLOSED;
                            // ZAmbat 02042014
                            tempNPC.NPC_Form_Status__c = NPC_STATUS_EXEC;
                        }
                        
                        listUpdateNPC.add(tempNPC);
                    }
                    
                    NPCFormTrigerStopper.isExecuted = true;
                    update listUpdateNPC;
                }
            }
            
            // ZAmbat 11132013
            // Void previously created Retrofit Device
            /*if (deleteNPCIds.size() > 0) {
                List<Device__c> listDevice = [
                    SELECT      Id
                                , Status__c
                    FROM        Device__c
                    WHERE       NPC_Form__c IN :deleteNPCIds
                ];
                
                if (listDevice.size() > 0) {
                    for (Device__c d : listDevice) {
                        d.Status__c = DEVICE_STAGE_VOID;
                    }
                    
                    update listDevice;
                }
            }*/
            
            //Added later after creation of retrofit device
            if(trigger.isUpdate && trigger.isAfter){     
                List<String> NPCIDs = new List<String>();       
                for (New_Part_Creation_Form__c npc : trigger.New) {
                    NPCIDs.add(npc.id);
                }
                system.debug('SOQL Queries 3 =================> ' + Limits.getQueries());
                NPCFormApprovalSendEmail.sendEmail(NPCIDs,trigger.oldMap);
                system.debug('SOQL Queries 4 =================> ' + Limits.getQueries());
            }        
            
            //Added Asolito 10012013 - added logic to set for approval records to approved when the status is set to Closed
            //*******************************************************************
            /*if(trigger.isUpdate) {
                //fire the approval process
                if(trigger.isAfter){
                    List<String> NPCIDs = new List<String>();
                    
                    for(New_Part_Creation_Form__c n: trigger.new){
                        system.debug('New 1 ###########'+n.npc_form_status__c);
                        system.debug('New 2 ###########'+trigger.oldMap.get(n.id).npc_form_status__c);
                        if(n.npc_form_status__c == 'Closed' && trigger.oldMap.get(n.id).npc_form_status__c <> 'Closed'){
                            NPCIDs.add(n.id);
                        }
                    }   
                    
                    if(NPCIDs.size() > 0){
                        NPCFormUpdateStatus.setStatusToClose(NPCIDs);
                    }
                //dont change the value of the status if equal to Closed and its new value is Executed (fired by the approval process)                
                } else if(trigger.isBefore){
                    for(New_Part_Creation_Form__c n: trigger.new){
                        if(n.npc_form_status__c == 'Executed' && trigger.oldMap.get(n.id).npc_form_status__c == 'Closed'){
                            n.npc_form_status__c = 'Closed';
                        }
                    }
                }            
            }*/
            //*******************************************************************  
            
            // ZAmbat 04042014
            if (npcCaseIds.size() > 0) {
                List<New_Part_Creation_Form__c> listNPCCase = [
                    SELECT      Id
                                , Name
                                , Account__c
                                , Account__r.Name
                                , Case__c
                                , New_Customer_Name__c
                , ECN_Change_Date__c
                    FROM        New_Part_Creation_Form__c
                    WHERE       Id IN :npcCaseIds
                ];
                
                // Get 'Internal Case' Record Type
                RecordType rt = [
                    SELECT      Id
                    FROM        RecordType
                    WHERE       SObjectType = 'Case'
                                AND DeveloperName = 'Internal_Case'
                ];
                
                // Create a Case
                //List<Case> listCase = new List<Case>();
                Map<Id, Case> npcIdCaseMap = new Map<Id, Case>();
                for (New_Part_Creation_Form__c npc : listNPCCase) {
                    Case c = new Case();
                    c.RecordTypeId = rt.Id;
                    c.Region__c = 'AP';
                    c.Application__c = 'Salesforce';
                    c.Business_process__c = 'Other SFDC';
                    c.Severity__c = 'Normal';
                    c.Priority = 'Medium';
                    c.Status = 'New';
                    if(npc.ECN_Change_Date__c != null){
                        //c.Subject = 'Customer Name Change: ' + npc.Name + ' as on ' + npc.ECN_Change_Date__c;
                          c.Subject = 'Customer Name Change: ' + npc.Name + ' as on ' + npc.ECN_Change_Date__c.year() + '-' + npc.ECN_Change_Date__c.month() + '-' + npc.ECN_Change_Date__c.day();
                    }
                    else{
                        c.Subject = 'Customer Name Change: ' + npc.Name;
                    }
                    
                    c.Description = npc.Name + ' Customer Name Change from ' + npc.Account__r.Name + ' to ' + npc.New_Customer_Name__c + '. \n\n' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + npc.Id;
                    c.OwnerId = Environment_Variable__c.getInstance('NPC_CASE_OWNER').Value__c;
                    c.Case_Link_Internal__c = Environment_Variable__c.getInstance('SFDC_INSTANCE').Value__c + '/';
                    //listCase.add(c);
                    npcIdCaseMap.put(npc.Id, c);
                }
                
                //if (listCase.size() > 0) {
                if (npcIdCaseMap.values().size() > 0) {
                    //insert listCase;
                    insert npcIdCaseMap.values();
                    
                    /*
                    Map<string, Id> mapCase = new Map<string, Id>();
                    for (Case c : listCase) {
                        mapCase.put(c.Subject.replace('Customer Name Change: ', ''), c.Id);
                    }
                    */

                    // Update NPC
                    for (New_Part_Creation_Form__c npc : listNPCCase) {
                        /*
                        if (mapCase.containsKey(npc.Name)) {    
                            npc.Case__c = mapCase.get(npc.Name);
                        }
                        */
                        
                        if(npcIdCaseMap.containsKey(npc.Id)
                          && npcIdCaseMap.get(npc.Id).Id != null){
                            
                            npc.Case__c = npcIdCaseMap.get(npc.Id).Id;
                        }
                    }
                    
                    NPCFormTrigerStopper.isExecuted = true;
                    update listNPCCase;
                }
            }      
        }
    } 
    
    //SNune    21102015  - Updated code to fix case 47700
    /*if(trigger.isBefore && trigger.isUpdate){ 
      NPCFormTriggerHelper.checkPIYEAndRejectionComments(Trigger.newMap, Trigger.OldMap);
    }*/
    if(trigger.isBefore && trigger.isUpdate){ 
        if(MRSCheckRecursive.isFirstRun())
        {    
            Map<Id,New_Part_Creation_Form__c> NPCFNewMap=new Map<Id,New_Part_Creation_Form__c>();
            for(New_Part_Creation_Form__c NPCF : trigger.new){      
              if(NPCF.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')){
                NPCFNewMap.put(NPCF.Id,NPCF);
              }
            }
            if(!NPCFNewMap.isEmpty()){
              NPCFormTriggerHelper.checkPIYEAndRejectionComments(NPCFNewMap, Trigger.OldMap);
            }
        }
    }
    
}