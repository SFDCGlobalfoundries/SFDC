/*Author: Nino Bustillos
    Description: The purpose of this test utility class is to load/create generic records for test class execution.
    History:
        Nbustillos  10122013    - code creation. 
        Thomas Lai  29042014    - Added LoadVaribles methods for ROS related test class. 
        Prosenjit   05262015    - Code added for CPQ data automation related test classes. 
        Swati       1023033     - Added this method LoadCaseEnvVariable to cover the test class for targetprocessnode value in Case and Bug referring CustomSettings
 */
@isTest(SeeAllData = false)
public class DataUtilTest {
    
    
    public static void loadEnvironmentVariables() {
        // load data into custom setting using static resources. 
        // Need to make sure that static resources are created with the same name in the target org.
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'TestEnvironmentVariablesData');
        List<SObject> lstErrorCodes = Test.loadData(Error_Codes__c.sObjectType,'TestErrorCodesData');
        List<SObject> lstCSDeviceStage = Test.loadData(CS_Device_Stage__c.sObjectType,'TestCSDeviceStageData');
        List<SObject> lstCSManualDevice = Test.loadData(CS_Manual_Device__c.sObjectType,'TestCSManualDeviceData');
        List<SObject> lstCSRiskStart = Test.loadData(CS_Risk_Start__c.sObjectType,'TestCSRiskStartData');
        List<SObject> lstCRMDID = Test.loadData(CRMDID__c.sObjectType,'TestCRMDIDData');
        List<SObject> lstNDABatchSize = Test.loadData(NDABatchSize__c.sObjectType,'TestNDABatchSizeData');
        List<SObject> lstNDAVariable = Test.loadData(NDA_Variable__c.sObjectType,'TestNDAVariableData');  
        List<SObject> lstAccountTeamVariable = Test.loadData(Account_Team_Roles__c.sObjectType,'TestAccountTeamVariableData');  
        List<SObject> lstAcctCustomerNo = test.loadData(Customer_Number__c.sObjectType,'TestCustomerNumber');
        List<SObject> lstAcctCustomerNo1 = test.loadData(CustomerNumber__c.sObjectType,'TestCustomerNumber1');
        List<Sobject> lstPTProfileMp = test.loadData(PT_Profile_Mapping__c.sObjectType,'TestPTProfileMappingData');
        
        List<SObject> lstBx041 = Test.loadData(BX041__c.sObjectType, 'TestCSBX041Data');
        List<SObject> lstBx041IP = Test.loadData(BX041IP__c.sObjectType, 'TestCSBX041IPData');
        List<SObject> lstBx041PIValidation = Test.loadData(BX041ValidatePorcessInfo__c.sObjectType, 'TestCSBX041ValidatePorcessInfoData');     
        List<SObject> lstBPMFieldMapping = Test.loadData(BPM_Field_Mapping__c.sObjectType,'TestBPMFieldMappingData');
        Test.loadData(Account_Region_Head_Mapping__c.sObjectType,'TestAcctRegionHeadMappingData');//Thomas 14/02/2014
 
        List<SObject> lstROSColumnDefinitionData      = Test.loadData(ROS_Column_Definition__c.sObjectType,'TestROSColumnDefinitionData');
        List<SObject> lstROSErrorMessagesData         = Test.loadData(ROS_Error_Messages__c.sObjectType,'TestROSErrorMessagesData');
        List<SObject> lstROSExportColumnsData         = Test.loadData(ROS_EXPORT_COLUMNS__c.sObjectType,'TestROSExportColumnsData');
        List<SObject> lstROSQueryData                 = Test.loadData(ROS_QUERY_DATA__c.sObjectType,'TestROSQueryData');
        List<SObject> lstROSVendorNameData            = Test.loadData(ROS_Vendor_Name__c.sObjectType,'TestROSVendorNameData');
        List<SObject> lstROROSCustomDataMgmtPLValsData= Test.loadData(ROS_CUSTOM_DATA_MGMT_PLVALS__c.sObjectType,'TestROSCustomDataMgmtPLValsData');
        List<SObject> lstROSTriggersBypassData        = Test.loadData(ROS_Triggers_Bypass__c.sObjectType,'TestROSTriggersBypassData');       
        
        //Configurator data: 
        List<SObject> lstCPQSettings = Test.loadData(CPQ_Settings__c.sObjectType,'TestCPQSettingsData');
        List<SObject> lstCPQAttributeSettings = Test.loadData(CPQ_Attribute_Settings__c.sObjectType,'TestCPQAttributeSettingsData');
        List<SObject> lstPCMAdministrationSettings = Test.loadData(PCM_Administration__c.sObjectType,'TestPCMAdministration');      
        
        //added for VoC 
        List<SObject> lstVocScoreTrend = Test.loadData(VoCAreaTrend__c.sObjectType,'TestVocScoreTrend');
        
        //added by Naman : To Support MUltiple Bill To Address
        List<SObject> lstBillToNumberSettings = Test.loadData(Bill_To_Address_Number__c.sObjectType,'TestBillToNumber');
        //List<SObject> lstLeadQueues = Test.loadData(Led_Queues__c.sObjectType,'TestLeadValues');


    }
    public static void LoadHCMEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'HCM Emp AccountId', Value__c = null));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PFAE', Value__c = 'Primary Field Application Engineer'));
        database.insert(listSObj, false);
    }
    
    public static void LoadFabEnvVariables(){
        list<SObject> listSObj = new list<SObject>();
        listSObj.add(new ROS_Triggers_Bypass__c(Name = 'ROS_Fab_insertFabUsers_Trigger', UserName__c = ''));
        listSObj.add(new ROS_Triggers_Bypass__c(Name = 'ROS_FABUserTrigger', UserName__c = ''));
        
        database.insert(listSObj, false);
    }
    
     public static void LoadCaseEnvVariable(){
     list<SObject> listSObj = new list<SObject>();
     listSObj.add(new Environment_Variable__c(Name = 'SiPh 90WG', Value__c = 'SiPh 90WG'));
     listSObj.add(new Environment_Variable__c(Name = 'SIPH 9WG', Value__c = 'SIPH 9WG'));
     listSObj.add(new Environment_Variable__c(Name = 'P1 - High', Value__c = '-1'));
     listSObj.add(new Environment_Variable__c(Name = 'P2', Value__c = '-1'));
     listSObj.add(new Environment_Variable__c(Name = 'CaseTechEmailAddressName', Value__c = 'testing1'));
     listSObj.add(new Environment_Variable__c(Name = 'CaseLogisticsEmailAddressName', Value__c = 'testing2'));
     listSObj.add(new Environment_Variable__c(Name = 'CaseSfdcSupportRecordtypeId', Value__c = '01p90000006VbXp'));
     database.insert(listSObj, false);
     
     }
    
    public static void LoadATPEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TEAM_PROXY_ENTITY', Value__c = 'Account Team Proxy'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_PROGTEAM_DEFAULT_ACCESS', Value__c = ''));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_STATUS_ACTIVE', Value__c = 'Active'));
        listSObj.add(new Environment_Variable__c(Name = 'ACT_TM_PRXY_TM_RL_CE', Value__c = 'Customer Engineer'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_FP', Value__c = 'Fab Planner'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_AA', Value__c = 'Account Administrator'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_AM', Value__c = 'Account Manager'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PAM', Value__c = 'Primary Account Manager'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_TS', Value__c = 'Technical Support'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_AE', Value__c = 'Application Engineer'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_CSR', Value__c = 'Customer Service Rep'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PCSR', Value__c = 'Primary Customer Service Rep'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PFAE', Value__c = 'Primary Field Application Engineer'));
        listSObj.add(new Environment_Variable__c(Name = 'GF_INTEGRATION_PROFILE_ID', Value__c = '00e90000000HBU8AAO'));
        
        listSObj.add(new Error_Codes__c(Name = 'ACCT_TM_DUP_USER_ROLE_ERROR', Message__c = 'There are duplicate users or roles in the form. Please review the form and update assignment as necessary.'));
        listSObj.add(new Error_Codes__c(Name = 'ATP_INTEGRATION_SEQUENCE_ERROR', Message__c = 'Out of sequence integration update'));
        listSObj.add(new Error_Codes__c(Name = 'ATP_FLAG_FOR_DELETE_UPDATE_ERROR', Message__c = 'Deletion in progress, Flag for delete can not be uncheked'));
        listSObj.add(new Error_Codes__c(Name = 'ATP_FLAG_FOR_DELETE_CREATION_ERROR', Message__c = 'Flag for delete is not allowed while creating record'));
        listSObj.add(new Error_Codes__c(Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR', Message__c = 'Please ensure that a Backup Customer Service Rep or Primary Field Engineer is defined in Account Team'));
        
        database.insert(listSObj, false);
        
    }
    
    public static void LoadDeviceEnvVariable(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'BPM_isActive', Value__c = 'TRUE'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_TAPEOUT', Value__c = 'Tapeout'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_PROD', Value__c = 'Production'));
        listSObj.add(new Environment_Variable__c(Name = 'OPP_STG_NM_6', Value__c = '6. First Product TO'));
        listSObj.add(new Environment_Variable__c(Name = 'OPP_STG_NM_7', Value__c = '7. Revenue'));
        listSObj.add(new Environment_Variable__c(Name = 'OPP_STATUS', Value__c = 'In Production'));
        listSObj.add(new Environment_Variable__c(Name = 'TAPEOUT_TYPE_MPW', Value__c = 'GlobalShuttle MPW'));
        //listSObj.add(new Environment_Variable__c(Name = 'DEV_D1_NAT_ACCESS_VALIDATION_MSG', Value__c = ''));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_STAGE_TAPEOUT', Value__c = 'Tapeout'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_TYPE_RETROFIT', Value__c = 'Retrofit'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_DEFAULT_TYPE', Value__c = 'Base'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_DEFAULT_REVISION', Value__c = '0'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_DEFAULT_BX041_STATUS', Value__c = 'Pending Submission'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_DESIGN_IN', Value__c = 'Design In - Read Only'));

        listSObj.add(new Error_Codes__c(Name = 'DEV_D1_NAT_ACCESS_VALIDATION_MSG', Message__c = 'D1 National Access Allowed can only be modified when Export Control Waiver Flag is "Yes".'));
        listSObj.add(new Error_Codes__c(Name = 'DEVICE_RETROFIT_VALIDATION', Message__c = 'Modification of Retrofit Devices is not allowed.')); 
        listSObj.add(new Error_Codes__c(Name = 'BX041_STATUS_ERROR', Message__c = '- Assigned Pid Lifecycle (PLM) Status should be either in Prototype Ready, MPW Ready or Available.<br/>'));
        listSObj.add(new Error_Codes__c(Name = 'BX041_STATUS_ERROR_NOT_CLOSED', Message__c = '- BX-041 Status not yet ‘Closed’.<br/>'));
        listSObj.add(new Error_Codes__c(Name = 'ASSIGNED_PROCESS_ID_ERROR', Message__c = '- Assigned Process Id (PI/YE) should not be Pending EOL, EOL or null.<br/>'));    
        listSObj.add(new Error_Codes__c(Name = 'TAPEOUT_TYPE_REQUIRED', Message__c = '- Tapeout Type is required.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'MPW_TRAIN_NUM_REQUIRED', Message__c = '- MPW Train Number is required for \'GlobalShuttle MPW\' Tapeout Tape before the Device can be submitted.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'EXPORT_CONTROL_DECLARATION_REQUIRED', Message__c = '- Export Control Declaration has not been completed for this Device. Tapeout can proceed only under acknowledgement from the FE that the design file submitted by the custom only contains relevant data for the frame and NO GDS data for the prime die.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'D1_NATIONAL_ACCESS_REQUIRED', Message__c = '- Export Control has been waived, D1 National Access Allowed is required.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'SECURITY_DEVICE_REQUIRED', Message__c = '- Secure Device is required.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'AUTOMOTIVE_DEVICE_REQUIRED', Message__c = '- Automotive Device is required.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'DEVICE_STAGE_VALIDATION', Message__c = '- Device\'s Stage is in Solutioning, should you wish to proceed please change the Device\'s Stage to Design In.<br/>')); 
        listSObj.add(new Error_Codes__c(Name = 'DEVICE_IP_DECLARATION_VALIDATION', Message__c = '- Completed IP Declaration Online Form is an optional requirement except to PT002929, PT002942, PT003157.<br/>'));
        listSObj.add(new Error_Codes__c(Name = 'ERPDeviceSPMBOM-GroupName', Message__c = 'AccessForERPDeviceSPMBOM-VF'));
        listSObj.add(new Error_Codes__c(Name = 'ERPDeviceSPMBOM-PSADefault', Message__c = 'AAAAAAA'));
        listSObj.add(new Error_Codes__c(Name = 'ERPDeviceSPMBOM-PSADefault', Message__c = '0000000'));
        listSObj.add(new Error_Codes__c(Name = 'ERPDeviceSPMBOM-ReplaceVFAlert', Message__c = 'Replace Alert'));
        listSObj.add(new Error_Codes__c(Name = 'ERPDeviceSPMBOM-DefaultVFAlert', Message__c = 'Default Alert'));
        
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_DESIGN_IN', Value__c = 'Design In'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_EOL', Value__c = 'EOL'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_PRODUCTION', Value__c = 'Production'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_PROTOTYPE', Value__c = 'Prototype'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_RTR', Value__c = 'RTR'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_SOLUTIONING', Value__c = 'Solutioning'));
        listSObj.add(new CS_Device_Stage__c(Name = 'DEVICE_STAGE_TAPEOUT', Value__c = 'Tapeout'));
        
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_PV_YES', Value__c = 'Yes'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_PV_NO', Value__c = 'No'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_PRODUCTION', Value__c = 'Production'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_PROTO_RISK_PROD', Value__c = 'Proto_Risk Production'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_TAPEOUT', Value__c = 'Tapeout'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_RETROFIT', Value__c = 'Retrofit'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_RETROFIT_ERROR', Value__c = 'Publish Report cannot be "No" for 1. Device with Design In/Solutioning/Tapeout Status.AND 2. Device with Tapeout Type Retrofit.AND 3. Device with Confidence Level Tapeout >= 50.AND 4. Device with Forecast GDSII In Date is One year between Current Date'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_TEAM_ROOM_PUBLISH_ERROR', Value__c = 'Meeting Minutes already Publishd for Current Week.'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_TEAM_ROOM_PUBLISH_INFO', Value__c = 'Published to the Team Room.'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_DUPLICATE_DEVICE_ERROR', Value__c = 'Device with Device Id already Exists.'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MDEVICE_REPORT_FOLDER', Value__c = 'CE_Weekly_Reports'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_OWNER_USER_FID', Value__c = 'CRMBATCHUSR'));
        listSObj.add(new CS_Manual_Device__c(Name = 'MANUAL_DEVICE_ACCOUNT_ERROR', Value__c = 'Please Enter a Valid Account'));
        
        listSObj.add(new CRMDID__c(Name = 'CRMDID_No', CRMDID_No__c = 16283));
        database.insert(listSObj, false);
    } 
    
    public static void LoadOpptyEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'OPPTY_STAGE_VOID',Value__c = '10. Void'));
        listSObj.add(new Environment_Variable__c(Name = 'READONLY_NAME',Value__c = 'Read Only'));
        //listSObj.add(new Environment_Variable__c(Name = 'DEVICE_PROGTEAM_DEFAULT_ACCESS',Value__c = ''));
        //listSObj.add(new Environment_Variable__c(Name = 'DEVICE_STATUS_ACTIVE',Value__c = 'Active'));
        listSObj.add(new Environment_Variable__c(Name = 'OPPTY_PROG_API_NAME',Value__c = 'Opportunity_Program__c'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_API_NAME',Value__c = 'Device__c'));
        listSObj.add(new Environment_Variable__c(Name = 'DEVICE_GAP_API_NAME',Value__c = 'Device_Gap__c'));
        listSObj.add(new Environment_Variable__c(Name = 'EDA_REQ_API_NAME',Value__c = 'EDA_Requirement__c'));
        
        database.insert(listSObj, false);
    }   
    
    public static void LoadReticleDWEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new ROS_Error_Messages__c(Name = 'ROS_DUPLICATE_DW_RECORD',Value__c = 'Duplicate Record for Dataware House'));
        listSObj.add(new ROS_Error_Messages__c(Name = 'Notify customer',Value__c = 'Reticles notified to customer successfully'));
        listSObj.add(new ROS_Error_Messages__c(Name = 'Obselence_Error',Value__c = 'Select at least one Reticle'));
        listSObj.add(new ROS_Triggers_Bypass__c(Name='ROS_TriggerDatawareHouse',UserName__c='crmbatchusr@globalfoundries.com'));

        database.insert(listSObj, false);
    } 
    
    public static void LoadReticleDeviceEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new ROS_Triggers_Bypass__c (Name = 'ROS_PreventDuplicateDevicereticle', UserName__c = ''));

        database.insert(listSObj, false);
    } 
    
    // Description: This class method loads all the custom setting environment variables related to Opportunity Program Team Member object used in triggers.
    // Call this method on your test classes if you are during DML operation for the object.
    public static void LoadOPTMEnvVariables(){
        // Load Environment Variable
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name='OPPTY_PROG_TM_ENTITY',Value__c='Opportunity_Program_Team_Member__c'));
        
        // Load list of error codes
        listSObj.add(New Error_Codes__c(Name='OPPTY_PROG_TM_DEL_ERROR',Message__c='An error occurred while Opportunity Program Team Member Deletion.'));
        listSObj.add(New Error_Codes__c(Name='OPPTY_PROG_TM_UPDT_ERROR',Message__c='An error occurred while Opportunity Program Team Member Updation.'));
        Database.insert(listSObj,false);
    }
    // Description: This class method loads all the custom setting environment variables related to Reticle__c object used in triggers.
    // Call this method on your test classes if you are during DML operation for the object.
    public static void LoadReticleEnvVariables(){
        // Load ROS Trigger ByPass
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new ROS_Triggers_Bypass__c(Name='ROS_UpdateSharingOnReticle',UserName__c=''));
        
        // Load ROS Error Messages
        listSObj.add(New Error_Codes__c(Name='Obselence_Customer_Feedback',Message__c='Disposition cannot be done until it is sent for customer Feedback'));
        listSObj.add(New Error_Codes__c(Name='CSR_Error_Message',Message__c='CSR Team can only update Reticle Disposition,Reticle Workflow Status,Evidence Certificate,Debit Note Details,Shipping Address,ROS Cycle for Reticles'));
        Database.insert(listSObj,false);
    }
    // Description: This class method loads all the custom setting environment variables related to Fab_Reticle__c object used in triggers.
    // Call this method on your test classes if you are during DML operation for the object.
    public static  void LoadFabReticleEnvVariables(){
        // Load ROS Trigger ByPass
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new ROS_Triggers_Bypass__c(Name='ROS_Preventduplicatefabreticle',UserName__c=''));
        Database.insert(listSObj,false);
    }
    
    public static void loadROSVendorNames(){
        List<ROS_Vendor_Name__c> lstVendors = new List<ROS_Vendor_Name__c>();
        lstVendors.add(new ROS_Vendor_Name__c(name='FAB 1',Address__c = 'TestAddress1',Company_Name__c='TestCompany1'));
        lstVendors.add(new ROS_Vendor_Name__c(name='FAB 3E',Address__c = 'TestAddress2',Company_Name__c='TestCompany2'));
        lstVendors.add(new ROS_Vendor_Name__c(name='Other',Address__c = 'TestAddress3',Company_Name__c='TestCompany3'));
        Database.insert(lstVendors,false);
    }
    
    
    public static void loadVisitationSetting(){
        List<Visitation_Setting__c> lstVisitatioSetting = new List<Visitation_Setting__c>();
        lstVisitatioSetting.add(new Visitation_Setting__c(name='STAGE_OPTONS',value__c='0. Draft,1. Reservation requested,2. Confirmed,3. Pre-Visit preparation,4. Post-Visit,5. Closed - Cancelled,5. Closed - Completed,5. Closed - Rejected'));
        lstVisitatioSetting.add(new Visitation_Setting__c(name='VISITATION_DATA_LOAD_NUMBER',value__c=' 20'));
     
       Database.insert(lstVisitatioSetting,false);
    }
    
    
    /*
    public static void LoadAccountEnvVariables(){
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PFTS', Value__c = 'Primary Field Application Engineer'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_BCSR', Value__c = 'Backup Customer Service Rep'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_AM', Value__c = 'Account Manager'));
        listSObj.add(new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PAM', Value__c = 'Primary Account Manager'));
        listSObj.add(new Environment_Variable__c(Name = 'PROMOTE_TO_AUTHORIZED', Value__c = 'Promote to Authorized'));
        
        listSObj.add(new Error_Codes__c(Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR', Message__c = 'Please ensure that a Backup Customer Service Rep or Primary Field Engineer is defined in Account Team'));
        listSObj.add(new Error_Codes__c(Name = 'Bill_To_Address_Required', Message__c = 'Bill to Address 1, Bill to City and Bill to Country fields are required. Please enter a value on the fields OR tick Copy Corporate Address checkbox'));
        listSObj.add(new Error_Codes__c(Name = 'ACCOUNT_DOES_NOT_HAVE_CONTACT', Message__c = 'Account should have at least one contact before it can be Authorized.'));
        listSObj.add(new Customer_Number__c(Name = 'Update Customer No', Customer_No__c = 1));
        
        listSObj.add(new Error_Codes__c(Name = 'ACCT_TM_DUP_USER_ROLE_ERROR', Message__c = 'There are duplicate users or roles in the form. Please review the form and update assignment as necessary.'));
        
        database.insert(listSObj, false);
    }
     */
}