/*
Author:      Prosenjit Saha(PS)
Description: This Class manages device integration between Salesforce and BPM systems
History:
    PS        11182013    - Code creation.
    PS        11202013    - Code Modification: Added new fields.
    TLai      24042014    - Added 3 fields  
    Baij      18072014    - Added 1 fields Assigned_Process_Name__c,  
    ZAmbat    08142014    - Updated code as per CASE 31775.
    DBiswal   04112014    - Updated code to get HCM_Login_ID__c for approvers on CDRS record.
*/

public class BPMDeviceIntegration{
    
    public static Device__c dev ; 
    @future(callout=true)
    public static void deviceBPMSFDCIntegrationMethod(ID devid, boolean IsTriggered){
        BPMService1.GF_Integration_SFDC_Service_SFDCDevice_Port syncService = new BPMService1.GF_Integration_SFDC_Service_SFDCDevice_Port();
        syncService.timeout_x = 120000;
        BPMService1.SFDC_Device device = new BPMService1.SFDC_Device();
        String exceptionmsg;
        //call mapDevice method to create mapping between salesforce data with the BPM webservice fields.
        if(devid != NULL){
            device = mapDevice( devid );
            String IntegrationResponse ;//response from the callout 
            if(devid != NULL){
                //if certificate requires: 
                String certificate = Environment_Variable__c.getInstance('BPM_SIGNED_CERTIFICATE').value__c;
                if(certificate != NULL && certificate != 'NO'){
                    syncService.clientCertName_x = certificate ;
                }
                try{
                    if (!Test.isRunningTest()) {
                        IntegrationResponse = syncService.SFDCDeviceIntegration(device); //calling web method.
                    }
                    else{
                        IntegrationResponse = BPMDeviceIntegrationTest.BPMServiceMockResponse();
                    }
                    System.Debug('Response from Web Service ---' + device); 
                }
                catch(exception e){
                    exceptionmsg = e.getMessage();
                    system.debug('Exception Message::'+e.getMessage());
                }
            }
            system.debug('Final status:::::'+IntegrationResponse );
            
            //update device (BPM Status field) with the current status:
            if(IntegrationResponse != NULL){
                updateDevice(IntegrationResponse, IsTriggered);
            }
            else{
                updateDevice(exceptionmsg, IsTriggered);    
            }
        }            
    }
    
    /*******************************************************************************************************************************************************
    @Method Name:    mapDevice
    @Return Type:    BPMService.SFDC_Device: refer BPMService for type defination
    @parameter:      ID(Device ID)
    @Reason:         This method creates mapping between salesforce and BPM systems.
    ********************************************************************************************************************************************************/    
    public static BPMService1.SFDC_Device mapDevice(id DeviceID){
    
        /**********************************************************Query Section start***********************************************************************/
            sObject sobjDevice =    [SELECT    id,
                                               CRMDID__c,
                                               Tapeout_Type__c,
                                               Current_Forecast_Tapeout_Date__c,
                                               Process_ID_Technology__c,
                                               Opportunity_ID__c,
                                               Name,
                                               Geometry__c,
                                               Process_Technology__c,
                                               Opportunity__c,
                                               BX041_Status__c,
                                               Account__c,
                                               Forecasted_Lot_Start_Date__c,
                                               Fab__c,
                                               Process_Family__c,
                                               Device_Mask_Set_Title__c,
                                               LastActivityDate,
                                               Modifiedby_HCMLoginID__c,
                                               Confidence_Level_Tapeout__c,
                                               Confidence_Level_Volume__c,
                                               Starting_Material__c,
                                               Reticle_Type__c,
                                               Automotive_Device__c,
                                               Device_Sourcing__c,
                                               Special_Scribe_Width__c,
                                               BX041_Submission_Date__c,
                                               BX041_Form_Count__c,
                                               Account_Short_Name__c,
                                               Account__r.name,
                                               Assigned_Process_Name__c,// Baij 18072014
                                               Process_Technology_Number__c,
                                               Stage__c, // Tlai 24042014
                                               Status__c,// Tlai 24042014
                                               Pre_PTRF_Validation_Status__c // Tlai 24042014
                                     FROM      Device__c
                                     WHERE     id = :DeviceID for update];
               
               dev =    (Device__c) sobjDevice ;  
               sObject sobjBx041   =  new BX_041__c();
               if(dev.BX041_Form_Count__c > 0){
                   for(BX_041__c bx041 : [SELECT   id,
                                                   name,
                                                   device__c,
                                                   Backtrack_Request__c,
                                                   Die_Size_Y_mm__c,
                                                   Die_Size_X_mm__c,
                                                   Die_Size_mm2__c,
                                                   Design_Match_Vendor_EPET__c,
                                                   Need_IP_Merge_information__c,
                                                   Need_IP_information__c,
                                                   Porting_Design_External_IPs_require_rep__c,
                                                   GLOBALFOUNDRIES_Sponsored_IP_Used__c,
                                                   Design_Match_Vendor_DR_DM__c,
                                                   Overall_Gap_Status__c,
                                                   Other_Special_Requirements__c,
                                                   Intended_Rotation_in_PTRF__c,
                                                   Notch_Location__c,
                                                   Restricted_Gate_Poly_Orientation__c,
                                                   Poly_Orientation_Compliance__c ,
                                                   Special_Scribe_Width__c,
                                                   createdDate,
                                                   Approver_1__c,
                                                   Approver_2__c,
                                                   Approver_3__c,
                                                   Approval_Step__c
                                                   
                                         FROM      BX_041__c         
                                         WHERE     device__c =:DeviceID]){
                       sobjBx041  =    bx041 ; 
                   }
               }
    
    
        /*******************************************************Query Section end******************************************************/
        
        
        BPMService1.SFDC_Device tempDevice = new BPMService1.SFDC_Device();
        
        //creating data mapping here
        
        if( sobjDevice != NULL){
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CDID').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CDID = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CDID').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_TAPEOUT_TYPE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_TAPEOUT_TYPE = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_TAPEOUT_TYPE').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CURR_FC_TO_DATE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CURR_FC_TO_DATE = (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CURR_FC_TO_DATE').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_OPPORTUNITY_ID').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_OPPORTUNITY_ID = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_OPPORTUNITY_ID').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_DEVICE_ID').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_DEVICE_ID = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_DEVICE_ID').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_GEOMETRY  =                      (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_GEOMETRY').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_GEOMETRY').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_GEOMETRY = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_GEOMETRY').SFDC_Field_Value__c); 
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_TECHNOLOGY  =                    (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_TECHNOLOGY').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_TECHNOLOGY').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_TECHNOLOGY = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_TECHNOLOGY').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_CUSTOMER_SHORTNAME  =            (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CUSTOMER_SHORTNAME').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CUSTOMER_SHORTNAME').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CUSTOMER_SHORTNAME = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CUSTOMER_SHORTNAME').SFDC_Field_Value__c);
            }
            
            //tempDevice.DEV_CUSTOMER_NAME  =                 (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CUSTOMER_NAME').SFDC_Field_Value__c);
            if (dev.account__r.name != null) {
                tempDevice.DEV_CUSTOMER_NAME = dev.account__r.name;
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_OPPORTUNITY').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_OPPORTUNITY = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_OPPORTUNITY').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CDRS_STATUS').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CDRS_STATUS = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CDRS_STATUS').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_PROCESSFAMILY  =                 (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESSFAMILY').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESSFAMILY').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_PROCESSFAMILY = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESSFAMILY').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_FORECASTED_LOT_START_DATE  =     (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FORECASTED_LOT_START_DATE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FORECASTED_LOT_START_DATE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_FORECASTED_LOT_START_DATE = (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FORECASTED_LOT_START_DATE').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_FAB  =                           (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FAB').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FAB').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_FAB = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_FAB').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_MASK_SET_TITLE  =                (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_MASK_SET_TITLE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_MASK_SET_TITLE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_MASK_SET_TITLE = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_MASK_SET_TITLE').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_PROCESS_TECHNOLOGY  =            (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESS_TECHNOLOGY').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESS_TECHNOLOGY').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_PROCESS_TECHNOLOGY = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESS_TECHNOLOGY').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_LASTMODIFIEDDATE  =              (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_LASTMODIFIEDDATE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_LASTMODIFIEDDATE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_LASTMODIFIEDDATE = (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_LASTMODIFIEDDATE').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_MODIFIEDBY_HCMLOGINID').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_MODIFIEDBY_HCMLOGINID = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_MODIFIEDBY_HCMLOGINID').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_CONFIDENCE_LEVEL_TAPEOUT  =      (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_TAPEOUT').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_TAPEOUT').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CONFIDENCE_LEVEL_TAPEOUT = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_TAPEOUT').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_CONFIDENCE_LEVEL_VOLUME  =       (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_VOLUME').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_VOLUME').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_CONFIDENCE_LEVEL_VOLUME = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_CONFIDENCE_LEVEL_VOLUME').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_STARTING_MATERIAL  =             (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STARTING_MATERIAL').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STARTING_MATERIAL').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_STARTING_MATERIAL = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STARTING_MATERIAL').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_RETICLE_TYPE =                   (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_RETICLE_TYPE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_RETICLE_TYPE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_RETICLE_TYPE = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_RETICLE_TYPE').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_AUTOMOTIVE_DEVICE  =             (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_AUTOMOTIVE_DEVICE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_AUTOMOTIVE_DEVICE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_AUTOMOTIVE_DEVICE = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_AUTOMOTIVE_DEVICE').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_DEVICE_SOURCING  =               (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_DEVICE_SOURCING').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_DEVICE_SOURCING').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_DEVICE_SOURCING = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_DEVICE_SOURCING').SFDC_Field_Value__c);
            }
            
            //tempDevice.strEvent =                           string.valueof(integer.valueOf(sobjDevice.get(BPM_Field_Mapping__c.getInstance('strEvent').SFDC_Field_Value__c)));
            tempDevice.DEV_SFDC_LINK =                      (string)(BPM_Field_Mapping__c.getInstance('DEV_SFDC_LINK').SFDC_Field_Value__c+sobjDevice.id);
            
            // ZAmbat 08142014
            //tempDevice.Special_Scribe_Width =               (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c) != null) {
                tempDevice.Special_Scribe_Width = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.DEV_PT_Number =                      (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PT_Number').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PT_Number').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_PT_Number = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PT_Number').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.CDRS_SUBMISSION_DATE =               (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('CDRS_SUBMISSION_DATE').SFDC_Field_Value__c);
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('CDRS_SUBMISSION_DATE').SFDC_Field_Value__c) != null) {            
                tempDevice.CDRS_SUBMISSION_DATE = (DateTime)sobjDevice.get(BPM_Field_Mapping__c.getInstance('CDRS_SUBMISSION_DATE').SFDC_Field_Value__c);
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STAGE').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_STAGE = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STAGE').SFDC_Field_Value__c);//Added by Tlai 24042014 
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STATUS').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_STATUS = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_STATUS').SFDC_Field_Value__c);//Added by Tlai 24042014 
            }
            
            // ZAmbat 08142014
            //tempDevice.STF_INFO =                           (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('STF_INFO').SFDC_Field_Value__c);//Added by Tlai 24042014
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('STF_INFO').SFDC_Field_Value__c) != null) { 
                tempDevice.STF_INFO = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('STF_INFO').SFDC_Field_Value__c);//Added by Tlai 24042014
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESS_ID').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_PROCESS_ID = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_PROCESS_ID').SFDC_Field_Value__c);//Added by Tlai 17062014
            }
            
            if (sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_ACCOUNT').SFDC_Field_Value__c) != null) {
                tempDevice.DEV_ACCOUNT = (string)sobjDevice.get(BPM_Field_Mapping__c.getInstance('DEV_ACCOUNT').SFDC_Field_Value__c);//Added by Tlai 17062014
            }
        }
        IF(sobjBx041 != NULL){
            tempDevice.DEV_CDRS_SFDC_LINK_ID  =             (string)(BPM_Field_Mapping__c.getInstance('DEV_CDRS_SFDC_LINK_ID').SFDC_Field_Value__c+sobjBx041.id );
            
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Design_Match_Vendor_ET').SFDC_Field_Value__c) != null) {
                tempDevice.Design_Match_Vendor_ET = string.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Design_Match_Vendor_ET').SFDC_Field_Value__c));
            }
            
            // ZAmbat 08142014
            //tempDevice.Backtrack_Request  =                 (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Backtrack_Request').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Backtrack_Request').SFDC_Field_Value__c) != null) {
                tempDevice.Backtrack_Request = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Backtrack_Request').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Die_Size_Y_mm  =                     integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_Y_mm').SFDC_Field_Value__c));
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_Y_mm').SFDC_Field_Value__c) != null) {
                tempDevice.Die_Size_Y_mm = integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_Y_mm').SFDC_Field_Value__c));
            }
            
            // ZAmbat 08142014
            //tempDevice.Die_Size_X_mm  =                     integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_X_mm').SFDC_Field_Value__c));
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_X_mm').SFDC_Field_Value__c) != null) {
                tempDevice.Die_Size_X_mm = integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_X_mm').SFDC_Field_Value__c));
            }
            
            // ZAmbat 08142014
            //tempDevice.Die_Size_mm2  =                      integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_mm2').SFDC_Field_Value__c));
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_mm2').SFDC_Field_Value__c) != null) {
                tempDevice.Die_Size_mm2 = integer.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Die_Size_mm2').SFDC_Field_Value__c));
            }
            
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('External_IPs_require_replacement').SFDC_Field_Value__c) != null) {
                tempDevice.External_IPs_require_replacement = string.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('External_IPs_require_replacement').SFDC_Field_Value__c));
            }
            
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('GLOBALFOUNDRIES_Sponsored_IP_Used').SFDC_Field_Value__c) != null) {
                tempDevice.GLOBALFOUNDRIES_Sponsored_IP_Used = string.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('GLOBALFOUNDRIES_Sponsored_IP_Used').SFDC_Field_Value__c));
            }
            
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Design_Match_Vendor_DR_DM').SFDC_Field_Value__c) != null) {
                tempDevice.Design_Match_Vendor_DR_DM = string.valueOf(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Design_Match_Vendor_DR_DM').SFDC_Field_Value__c));
            }
            
            // ZAmbat 08142014
            //tempDevice.Other_Special_Requirements  =        (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Other_Special_Requirements').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Other_Special_Requirements').SFDC_Field_Value__c) != null) {
                tempDevice.Other_Special_Requirements = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Other_Special_Requirements').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Intended_Rotation_in_PTRF  =         (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Intended_Rotation_in_PTRF').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Intended_Rotation_in_PTRF').SFDC_Field_Value__c) != null) {
                tempDevice.Intended_Rotation_in_PTRF = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Intended_Rotation_in_PTRF').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Notch_Location  =                    (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Notch_Location').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Notch_Location').SFDC_Field_Value__c) != null) {
                tempDevice.Notch_Location = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Notch_Location').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Restricted_Gate_Poly_Orientation  =  (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Restricted_Gate_Poly_Orientation').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Restricted_Gate_Poly_Orientation').SFDC_Field_Value__c) != null) {
                tempDevice.Restricted_Gate_Poly_Orientation = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Restricted_Gate_Poly_Orientation').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Poly_Orientation_Compliance  =       (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Poly_Orientation_Compliance').SFDC_Field_Value__c);
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Poly_Orientation_Compliance').SFDC_Field_Value__c) != null) {
                tempDevice.Poly_Orientation_Compliance = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Poly_Orientation_Compliance').SFDC_Field_Value__c);
            }
            
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('CDRS_CREATED_DATE').SFDC_Field_Value__c) != null) {
                tempDevice.CDRS_CREATED_DATE = (DateTime)sobjBx041.get(BPM_Field_Mapping__c.getInstance('CDRS_CREATED_DATE').SFDC_Field_Value__c);
            }
            
            // ZAmbat 08142014
            //tempDevice.Special_Scribe_Width =               (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c);//Added by Tlai 17062014
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c) != null) {
                tempDevice.Special_Scribe_Width = (string)sobjBx041.get(BPM_Field_Mapping__c.getInstance('Special_Scribe_Width').SFDC_Field_Value__c);
            }
            
            //DBiswal 04112014 - For getting HCM_Login_ID__c for approvers on CDRS record.
            Set<Id> approverIds = new Set<Id>(); 
            if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approval_Step').SFDC_Field_Value__c) == 'Pending for PIYE' 
                || sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approval_Step').SFDC_Field_Value__c) == 'Approved') {
                if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_1').SFDC_Field_Value__c) != null) {
                    approverIds.add((ID)(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_1').SFDC_Field_Value__c)));
                }
                if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_2').SFDC_Field_Value__c) != null) {
                    approverIds.add((ID)(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_2').SFDC_Field_Value__c)));
                }
                if (sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_3').SFDC_Field_Value__c) != null) {
                    approverIds.add((ID)(sobjBx041.get(BPM_Field_Mapping__c.getInstance('Approver_3').SFDC_Field_Value__c)));
                }
                /*List<User> userinfo = [select HCM_Login_ID__c from User where id IN:approverIds];
                List<String> userlist = new List<String>();
                
                if(userinfo.size()>0){
                    for(User u:userinfo){
                        userlist.add(u.HCM_Login_ID__c);
                    }
                }
                if(userlist.size()>0)
                {
                    for(Integer i=0;i<userlist.size();i++)
                    {
                        if(tempDevice.CDRS_PIYE_EMPLOYEE_LIST == null)
                        {
                            tempDevice.CDRS_PIYE_EMPLOYEE_LIST = userlist[i];
                        }
                        else{
                            tempDevice.CDRS_PIYE_EMPLOYEE_LIST = tempDevice.CDRS_PIYE_EMPLOYEE_LIST + ';' + userlist[i];
                        }
                    }
                    
                }*/
            
                tempDevice.CDRS_PIYE_EMPLOYEE_LIST = new BPMService1.CDRS_PIYE_EMPLOYEE_LIST();
                tempDevice.CDRS_PIYE_EMPLOYEE_LIST.EMP = new List<string>();
                for (User u : [SELECT   HCM_Login_ID__c
                               FROM     User
                               WHERE    Id IN :approverIds]) {
                    if (u.HCM_Login_ID__c != null) {
                        tempDevice.CDRS_PIYE_EMPLOYEE_LIST.EMP.add(u.HCM_Login_ID__c);
                    } else {
                        tempDevice.CDRS_PIYE_EMPLOYEE_LIST.EMP.add('null');
                    }
                }
           }
           
        }
        
        return tempDevice;//return mapped data
    }
    
    /*******************************************************************************************************************************************************
    @Method Name:    updateDevice
    @Return Type:    void
    @parameter:      String: Response of the callout & device 
    @Reason:         This method updates integration status in the device level
    ********************************************************************************************************************************************************/    
    public static void updateDevice(String Response,  boolean IsTriggered){
        //if callout response is success
        if(Response == 'SUCCESS'){
            dev.BPM_status__c =  Response;
                           
        }
        
        //if not success
        else{
            dev.BPM_status__c =  Response;     
        }
        update dev;
    }
    
}