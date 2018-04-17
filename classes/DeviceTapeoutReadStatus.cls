/*
  Author: Anirban Roy 
  Description: This is the class called by the DeviceUpdateTrigger for error handling.
  History:
    ARoy        06072013    - code creation. 
    ARoy        09162013    - added code to check for retrofit devices created on the NPC form with Tapeout_Required__c='No' 
                              and update Pre_PTRF_Validation_Status__c='Not Pre-PTRF Ready' so that it shouldn't be picked up
                              in SWIFT.
    ARoy        09192013    - added code for error message display when BX041 Status != 'Closed'.
    ARoy        09302013    - removed code for Export Control Form Junction object checking for Devices.
    ARoy        10012013    - changed the code to run the class multiple times only and put query results in Maps.
    ARoy        10082013    - Changed the check on IP Declaration Form to show error message.    
    TLai        18032014    - Added code for IP declaration validation for device with PT002929, PT002942, PT003157
                            - Restructured code of setting Pre_PTRF_Validation_Status__c  
    ZAmbat      08262014    - Updated code as per CASE 31802.
    ZAmbat      09032014    - Updated Tapeout status for Single Product Tapeout Type.
    Vijay       04112014    - Commented the 'Solutioning' device stage related tapeout validation as the 'Solutioning' stage value is removed from Device 
    Prashant    11032015    - Added condition for Waived like Approved Status.
    Vijay       02232014    - updated devErrorHandling method to support the Internal Device Tapeout readiness validations
    ARoy        09222015    - Added code for Configurator Plus validation in Process Flow Accepted stage.
    ARoy        12212015    - Added validation for internal device for Configurator Plus message.
    Devendra    19042016    - Added new field Generate standard frame. 
    Amrita Agarwala #00055586   - Added  code to change error message for 22nm/28nm/FAB1
    Ravi Teja.B 05032017    - Removed CDRS validation for FAB 8 Devices Case#00065083 
*/

public class DeviceTapeoutReadStatus {
    
    //public static boolean isDeviceTapeoutReadStatusRun = false;
    public static Map<Id,Process__c> processMap;
    public static Map<Id,New_Part_Creation_Form__c> npcMap;
    public static final string DE_IP_ACCOUNT_SUB_TYPE = 'DE - IP';
    //Added by ARoy : 09222015 for Configurator Plus validation
    //public static Map<Id, String> devPropErrorMap;
    
    // Generation of the Tapeout Readiness Validation Status and Error Messages 
    public static void devErrorHandling(List<Device__c> devList){
       
        // Error status variables
        Error_Codes__c bx041ErrorStatus = Error_Codes__c.getInstance('BX041_STATUS_ERROR');
        Error_Codes__c bx041ErrorStatusNotClosed = Error_Codes__c.getInstance('BX041_STATUS_ERROR_NOT_CLOSED');
        Error_Codes__c assignedProcessId = Error_Codes__c.getInstance('ASSIGNED_PROCESS_ID_ERROR');
        Error_Codes__c tapeoutTypeReq = Error_Codes__c.getInstance('TAPEOUT_TYPE_REQUIRED');
        Error_Codes__c mpwTrainMntReq = Error_Codes__c.getInstance('MPW_TRAIN_NUM_REQUIRED');
        Error_Codes__c expConDecReq = Error_Codes__c.getInstance('EXPORT_CONTROL_DECLARATION_REQUIRED');
        Error_Codes__c d1NationalAccReq = Error_Codes__c.getInstance('D1_NATIONAL_ACCESS_REQUIRED');
        Error_Codes__c secureDeviceReq = Error_Codes__c.getInstance('SECURITY_DEVICE_REQUIRED');
        Error_Codes__c automotiveDeviceReq = Error_Codes__c.getInstance('AUTOMOTIVE_DEVICE_REQUIRED');
        Error_Codes__c devStageValidation = Error_Codes__c.getInstance('DEVICE_STAGE_VALIDATION');
        Error_Codes__c ipDeclarationValidation = Error_Codes__c.getInstance('DEVICE_IP_DECLARATION_VALIDATION');// Added by Thomas 05032014
        Error_Codes__c assignedProcessIdRequired = Error_Codes__c.getInstance('ASSIGNED_PROCESS_ID_REQUIRED');//Added by Vijay 02122015
        Error_Codes__c d1NationalAccessRequired = Error_Codes__c.getInstance('D1_NATIONAL_ACCESS_ALLOWED');//Added by Vijay 02122015
        Error_Codes__c bx041StatusErrorNonDEIP = Error_Codes__c.getInstance('BX041_STATUS_ERROR_FOR_NONDEIP');//Added by Vijay 04142015
        Error_Codes__c MSTReq = Error_Codes__c.getInstance('MSTRequired');// Added by MS 08092015
        Error_Codes__c ReticleReq = Error_Codes__c.getInstance('ReticleTypeRequired');// Added by MS 08092015
        // Added by ARoy 09222015 for Configurator Plus validation
        Error_Codes__c configStageValidation = Error_Codes__c.getInstance('CONFIG_STAGE_VALIDATION');
        Error_Codes__c configStageValidationMsg = Error_Codes__c.getInstance('CONFIG_STAGE_VALIDATION_MSG'); // #00055586
        // Warning message and other environmental variables
        String ipDecWarn = EnvironmentVariable.get('IP_DECLARATION_WARNING');
        String errMsgBegin = EnvironmentVariable.get('ERROR_MSG_BEGIN');
        String warnMsgBegin = EnvironmentVariable.get('WARN_MSG_BEGIN');
        String tapeReadNotPrePTRFReady = EnvironmentVariable.get('TAPEOUT_READ_NOT_PRE_PTRF');
        String incompleteTapeRead = EnvironmentVariable.get('TAPEOUT_READ_INCOMPLETE');
        String incompleteTapeRead1 = EnvironmentVariable.get('TAPEOUT_READ_INCOMPLETE1');
        String tapeoutReadComplete = EnvironmentVariable.get('TAPEOUT_READ_COMPLETE');
        String bx041Status = EnvironmentVariable.get('BX041_STATUS_CLOSED');
        String tapeoutType = EnvironmentVariable.get('TAPEOUT_TYPE_MPW');
        String devStage = EnvironmentVariable.get('DEVICE_STAGE');
        String d1NoNatAccessAllowed = EnvironmentVariable.get('D1_NO_NATIONAL_ACCESS_ALLOWED');
        String ptNumberList = EnvironmentVariable.get('PT_NUMBER_LIST');// added by Thomas 05032014
        Set<Id> processIdSet = new Set<Id>();
        Set<Id> npcIdSet = new Set<Id>();
        Set<Id> setAcctIds = new Set<Id>();
        Map<Id, Account> mapAccountRT = new Map<Id, Account>();
        //Variable declaration for Configurator Plus validation
        Set<Id> deviceIdSet = new Set<Id>();
        
        // Method variables
        boolean errorFlag = false;
        boolean warningFlag = false;
        boolean exptCntrlFlag = false;      
        String errorMsg = '';
        String warningMsg = '';
        String preTag = '<u>';
        String postTag = '</u>';
       
        
        for(Device__c dev : devList){
           if(dev.Assigned_Process_ID__c != null){
               processIdSet.add(dev.Assigned_Process_ID__c);   
           }
           if(dev.NPC_Form__c != null){
               npcIdSet.add(dev.NPC_Form__c);       
           }
           deviceIdSet.add(dev.Id);
           
           // ZAmbat 08262014
           setAcctIds.add(dev.Account__c);
        }
        
        if(processIdSet.size()>0 && (processMap==null || processMap.isEmpty())){
           try{

             processMap 
               = new Map<Id,Process__c>([select
                       id,
                       Available_to_Sell__c 
                       from Process__c 
                       where Id in :processIdSet]);  
            }catch(exception e){throw e;}
                    
          
        }
        if(npcIdSet.size()>0 && (npcMap==null || npcMap.isEmpty())){
        
            npcMap = new Map<Id,New_Part_Creation_Form__c>([select
                            id,
                            Tapeout_Type__c
                            from New_Part_Creation_Form__c
                            where Id in :npcIdSet 
                            and Tapeout_Required__c = 'No'
                            and Tapeout_Type__c = 'Retrofit']);
            
          
        }
        
                            
        
        // ZAmbat 08262014
        if (setAcctIds.size() > 0) {
            for (Account a : [SELECT    Id
                                        , RecordTypeId
                                        , Sub_Type__c
                              FROM      Account
                              WHERE     Id IN :setAcctIds]) {
                mapAccountRT.put(a.Id, a);
            }
        }
        
        for(Device__c dev : devList){
            errorMsg = '';
            warningMsg = '';
            errorFlag = false;
            warningFlag = false;
            exptCntrlFlag = false;
            //added by Vijay 02232015
            Boolean isInternalDevice = DeviceTriggerHandler.isInternalDevice(dev.RecordTypeId);
            // Error message population for BX041 Status = 'Closed'
            if(((!isInternalDevice && dev.BX041_Status__c == bx041Status) || (isInternalDevice)) && dev.Assigned_Process_ID__c != null 
                && processMap!=null && !processMap.isEmpty() 
                && processMap.containsKey(dev.Assigned_Process_ID__c)){
                Process__c pr = processMap.get(dev.Assigned_Process_ID__c);
                //Added by Vijay 04142015 to support 'Registered/TBO' for non DE-IP Internal Device
                if(isInternalDevice && (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c != DE_IP_ACCOUNT_SUB_TYPE)){
                    if(pr.Available_to_Sell__c  != 'Registered/TBO' && pr.Available_to_Sell__c != 'Available' && pr.Available_to_Sell__c != 'Prototype Ready' 
                        && pr.Available_to_Sell__c != 'MPW Ready'){
                        errorFlag = true;
                        String msg = (bx041StatusErrorNonDEIP != null && String.isnotBlank(bx041StatusErrorNonDEIP.Message__c)) ? bx041StatusErrorNonDEIP.Message__c :'- Assigned Pid Lifecycle (PLM) Status should be either in Registered/TBO, Prototype Ready, MPW Ready or Available.<br/>';
                        errorMsg += preTag + String.valueof(System.now())+ postTag + msg;
                    }
                }else{
                    if(pr.Available_to_Sell__c != 'Available'
                        && pr.Available_to_Sell__c != 'Prototype Ready' && pr.Available_to_Sell__c != 'MPW Ready'){
                        errorFlag = true;
                        errorMsg += preTag + String.valueof(System.now())+ postTag + bx041ErrorStatus.Message__c;
                    }
                }
            }
          
           // Error message population for BX041 Status != 'Closed'
            if(dev.BX041_Status__c != bx041Status 
            && (!isInternalDevice || (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c == DE_IP_ACCOUNT_SUB_TYPE))
            && (dev.Configuration_Status__c == null || 
                (dev.Configuration_Status__c != null && dev.Configuration_Status__c.toUpperCase() != 'PROCESS FLOW ACCEPTED'))
                ){
                     errorFlag = true;
                // #00055586 Added by Amrita
                // Condition for FAB 8 is added by Ravi Teja.B on 05/03/2017 for Case#00065083
                if((dev.Geometry__c != '0.022UM') && (dev.Geometry__c != '0.028UM') && dev.Fab__c!= 'FAB 1' && dev.Fab__c != 'FAB 8') {                   
                    //errorMsg += preTag + String.valueof(System.now())+ postTag + bx041ErrorStatusNotClosed.Message__c;
                    errorMsg += preTag + String.valueof(System.now()) + postTag + configStageValidation.Message__c;
                }else{
                     errorMsg += preTag + String.valueof(System.now()) + postTag + configStageValidationMsg.Message__c;
                }
                
            }
           
            if(dev.Assigned_Process_ID__c != null && processMap!=null && !processMap.isEmpty() 
                && processMap.containsKey(dev.Assigned_Process_ID__c)){
                Process__c pr = processMap.get(dev.Assigned_Process_ID__c);
                if(pr.Available_to_Sell__c == null || pr.Available_to_Sell__c == ''
                    ||pr.Available_to_Sell__c == 'Pending EOL' || pr.Available_to_Sell__c == 'EOL'){                     
                     errorFlag = true;                
                     errorMsg += preTag + String.valueof(System.now())+ postTag + assignedProcessId.Message__c;   
                }
                            
            }
         
            if(dev.Tapeout_Type__c == null){
                errorFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + tapeoutTypeReq.Message__c;               
                
            }else if(dev.Tapeout_Type__c != null){
                if(dev.Tapeout_Type__c == tapeoutType && dev.MPW_Train_Number__c == null){
                    errorFlag = true;
                    errorMsg += preTag + String.valueof(System.now())+ postTag + mpwTrainMntReq.Message__c;                   
                }
            }
         
            boolean expConFormChk = false;            
            
            // Prashant 11032015
            if(dev.Export_Control_Waiver_Flag__c != 'Yes' && (dev.Export_Control_Status__c != 'Approved' && dev.Export_Control_Status__c != 'Waived') && (!isInternalDevice || (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c == DE_IP_ACCOUNT_SUB_TYPE))&& dev.Device_Type__c!='Retrofit'){
                //errorFlag = true;
                exptCntrlFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + expConDecReq.Message__c;
            }
            
        
            
            // Validation for the D1 National Access when Export Control has been waived
            if(dev.Device_Type__c!='Retrofit' && dev.Export_Control_Waiver_Flag__c == 'Yes' && dev.D1_National_Access_Allowed__c == null && (!isInternalDevice || (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c == DE_IP_ACCOUNT_SUB_TYPE))){
                //errorFlag = true;
                exptCntrlFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + d1NationalAccReq.Message__c;             
            }
       
            // Validation for the Security Device
            if(dev.Secure_Device__c == null){
                errorFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + secureDeviceReq.Message__c;
            }
       
            //Validation for the Automotive Device
            if(dev.Automotive_Device__c == null){
                errorFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + automotiveDeviceReq.Message__c;
            }
            //added by MS    
            if(dev.Device_Mask_Set_Title__c == null){    
                errorFlag = true;    
                errorMsg += preTag + String.valueof(System.now())+ postTag + MSTReq.Message__c;    
            }    
             //added by MS    
            if(dev.Reticle_Type__c == null){    
                errorFlag = true;    
                errorMsg += preTag + String.valueof(System.now())+ postTag + ReticleReq.Message__c;    
            }            
     
            //Validation for the Device Stage Solutioning
            //Commented by Vijay 04112014 - The 'Solutioning' stage value is removed from Device. So below tapeout validation related to 'Solutioning' is no longer valid.
            /*if(dev.Stage__c == devStage){
                errorFlag = true;
                errorMsg += preTag + String.valueof(System.now())+ postTag + devStageValidation.Message__c;
            }*/
   
            
            //Added by Vijay 02122015 - added Assigned Process Id and D1 National Access Allowed check for Internal Device except DE-IP Account's Internal Device
            if((isInternalDevice && (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c != DE_IP_ACCOUNT_SUB_TYPE)) && dev.Assigned_Process_ID__c == null){
                errorFlag = true;
                String msg = (assignedProcessIdRequired != null && String.isnotBlank(assignedProcessIdRequired.Message__c))? assignedProcessIdRequired.Message__c :'- Assigned Process Id is required.<br/>';
                errorMsg += preTag + String.valueof(System.now())+ postTag + msg;
            }
            
             if((isInternalDevice && (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c != DE_IP_ACCOUNT_SUB_TYPE)) && String.isBlank(dev.D1_National_Access_Allowed__c)){
                errorFlag = true;
                String msg = (d1NationalAccessRequired != null && String.isnotBlank(d1NationalAccessRequired.Message__c)) ? d1NationalAccessRequired.Message__c :'- D1 National access Allowed is required.<br/>';
                errorMsg += preTag + String.valueof(System.now())+ postTag + msg;
            }
            //added by devendra 19042016
            string singleProduct=(Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT')!=null)?Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c:'Single Product';
            if(dev.Tapeout_type__c.equalsIgnoreCase(singleProduct) && dev.Generate_Standard_Frame__c==null){
                errorFlag = true;
                String msg = '- Generate Standard Frame Value is required .<br/>';
                errorMsg += preTag + String.valueof(System.now())+ postTag + msg;
            }
            
            //Validation for the IP Declaration Form completion to generate a warning message
            // Updated Thomas Lai 05032014 - Task 442: Add validation for device with PT002929, PT002942, PT003157
           // Yash -->Adding Customer MPW and Globalshuttle MPW condition line no 199 
            boolean iPDclFlag = false;
            if(dev.IP_Declaration_Form_Count__c > 0 && (dev.Tapeout_Type__c != Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c
                                && dev.Tapeout_Type__c != Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_CUSTOMER_MPW').Value__c)) {
              //if(dev.IP_Declaration_Form_Count__c > 0){ 
                if(!String.isBlank(dev.Process_Technology_Number__c) && ptNumberList.contains(dev.Process_Technology_Number__c) ){
                    if(dev.IP_Declaration_Status__c == 'Undeclared' || String.isEmpty(dev.IP_Declaration_Status__c )){// For Specific PT if Ip declaratin status is not approved
                        errorMsg += preTag + String.valueof(System.now())+ postTag + ipDeclarationValidation.Message__c;
                        iPDclFlag = true;
                    }
                } /*else if(dev.IP_Declaration_Status__c != 'Pending Reconciliation') {
                    warningFlag = true;
                    warningMsg += preTag + String.valueof(System.now())+ postTag + ipDecWarn;
                }*/
            }
     
            // ZAmbat 08262014
            boolean ipDecFlagSP = false;
            if (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.Account__c).RecordTypeId == Environment_Variable__c.getInstance('ACCT_RT_ID_CUSTOMER').Value__c
                && dev.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c
                && dev.IP_Declaration_Submitted_Date__c == null) {
                errorMsg += preTag + String.valueof(System.now())+ postTag + Error_Codes__c.getInstance('DEVICE_VALIDATE_IP_DECLARATION').Message__c;
                //iPDclFlag = true;
                ipDecFlagSP = true; 
              
            } else {
                if (dev.IP_Declaration_Submitted_Date__c == null
                    && (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.Account__c).RecordTypeId != Environment_Variable__c.getInstance('ACCT_RT_ID_GF_INTERNAL').Value__c
                            && (dev.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c
                                || dev.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_CUSTOMER_MPW').Value__c))) {
                    warningFlag = true;
                    warningMsg += preTag + String.valueof(System.now())+ postTag + ipDecWarn;
                }
            }
            //Added by ARoy : 09222015 for Configurator Plus validation
            //Added by ARoy : 12212015 for Internal Device validation
            /*if(!devPropErrorMap.isEmpty() && devPropErrorMap.containsKey(dev.Id) && (!isInternalDevice || (!mapAccountRT.isEmpty() && mapAccountRT.get(dev.account__c).Sub_Type__c == DE_IP_ACCOUNT_SUB_TYPE))){
                errorFlag = true;
                errorMsg += preTag + String.valueof(System.now()) + postTag + devPropErrorMap.get(dev.Id);
            }*/ 
    
            dev.Tapeout_Readiness_Validation_Error__c = '';
         
            //if(errorFlag || exptCntrlFlag ||iPDclFlag){
          
            if (errorFlag || exptCntrlFlag || iPDclFlag || ipDecFlagSP) {
                dev.Tapeout_Readiness_Validation_Error__c = errMsgBegin + errorMsg;
              
            }
            
            if(warningFlag){
                if(errorFlag || exptCntrlFlag || iPDclFlag){
                    dev.Tapeout_Readiness_Validation_Error__c += warnMsgBegin + warningMsg;
                }else{
                    dev.Tapeout_Readiness_Validation_Error__c = warnMsgBegin + warningMsg;
                }
            }
           
            
            // ZAmbat 09032014
           
            
            if ( dev.Device_Type__c!='Retrofit' && (errorFlag || iPDclFlag ||(dev.NPC_Form__c != null && npcMap != null && !npcMap.isEmpty() && npcMap.containsKey(dev.NPC_Form__c)))) {
                dev.Pre_PTRF_Validation_Status__c = tapeReadNotPrePTRFReady; 
                            
            } else {
            
                if (dev.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c) {
                    // Prashant 11032015
                    if ((dev.Export_Control_Status__c == 'Approved' || dev.Export_Control_Status__c == 'Waived') && dev.IP_Declaration_Submitted_Date__c != null) {
                        dev.Tapeout_Readiness_Validation_Error__c = '';
                        dev.Pre_PTRF_Validation_Status__c = tapeoutReadComplete;
                        
                    } else if (((dev.Export_Control_Status__c != 'Approved' && dev.Export_Control_Status__c != 'Waived') && (dev.IP_Declaration_Status__c == 'Undeclared' || dev.IP_Declaration_Status__c == 'Draft')) 
                                || ((dev.Export_Control_Status__c == 'Approved' || dev.Export_Control_Status__c == 'Waived' ) && (dev.IP_Declaration_Status__c == 'Undeclared' || dev.IP_Declaration_Status__c == 'Draft'))
                                || ((dev.Export_Control_Status__c != 'Approved' && dev.Export_Control_Status__c != 'Waived') && dev.IP_Declaration_Submitted_Date__c != null)) {
                        dev.Pre_PTRF_Validation_Status__c = incompleteTapeRead;
                                                
                    }
                } else {
                
                
                    if (exptCntrlFlag) {
                        dev.Pre_PTRF_Validation_Status__c = incompleteTapeRead; //Incomplete, Frame PTRF Ready
                    } else if (warningFlag) {
                        dev.Pre_PTRF_Validation_Status__c = incompleteTapeRead1;//Incomplete but Pre-PTRF Ready
                    } else {
                        dev.Tapeout_Readiness_Validation_Error__c = '';
                        dev.Pre_PTRF_Validation_Status__c = tapeoutReadComplete;
                    }
                }
            }
          
          
          

        }
        //isDeviceTapeoutReadStatusRun = true;
    }
}