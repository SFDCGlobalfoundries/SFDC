/*
* @ Author :- Abhita Bansal
* @ Description :- 
* @ Date :-
* @ Change History :-  
    DATE            NAME            Comments
    6-Dec-2016      Inshu Misra     Added code for exception framework...#IM
    9-Dec-2016      Anil Kumar Reddy L  Added util method to create a Retrofit Device.
    21-Jun-2017     Inshu Misra     Added method for generating Public URL for the attachments...#IM
    28-Jun-2017		Abhita Bansal	Removed the System debugs
    13-July-2017	Inshu Misra		Added code for Export Control functionality for RIT Forms...#IM
	14-Jul-2017    Inshu Misra    Added the Defect Fix for History Issues
	17-Jul-2017 	Inshu Misra		Modified condition against ExportControl IMC issue
	17-Jul-2017     Anirban Roy     modified for EC Junction creation
	2-Aug-2017 		Inshu Misra		Modified condition against ExportControl RIT issue
	25-Aug-2017		Ravindra		Changed the document links to libraries
**/

public without sharing class UtilityCls {

    public static final string sysUnixTimeStamp = 'X'+string.valueof(datetime.now().getTime());
    public static final String WireBondPad = EnvironmentVariable.get('WireBondPad__c'); 
    public static final String LeftXCoordinate = EnvironmentVariable.get('LeftXCoordinate__c');
    public static final String LeftYCoordinate = EnvironmentVariable.get('LeftYCoordinate__c');
    public static final String RightXCoordinate = EnvironmentVariable.get('RightXCoordinate__c');
    public static final String RightYCoordinate = EnvironmentVariable.get('RightYCoordinate__c');
    public static final String DDRLeftXCoordinate = EnvironmentVariable.get('DDRLeftXCoordinate__c');
    public static final String DDRLeftYCoordinate = EnvironmentVariable.get('DDRLeftYCoordinate__c');
    public static final String DDRRightXCoordinate = EnvironmentVariable.get('DDRRightXCoordinate__c');
    public static final String DDRRightYCoordinate = EnvironmentVariable.get('DDRRightYCoordinate__c');
    private static final String FMS_DSXG_ERR= EnvironmentVariable.get('FMS_DSXG_ERR');    
    private static final String FMS_DSYG_ERR = EnvironmentVariable.get('FMS_DSYG_ERR');    
    private static final String FMS_TNTP_ERR = EnvironmentVariable.get('FMS_TNTP_ERR');
    private static final String FMS_NUBEL_ERR  = EnvironmentVariable.get('FMS_NUBEL_ERR');
    private static final String FMS_NUFELD_ERR  = EnvironmentVariable.get('FMS_NUFELD_ERR');
    private static final String FMS_WPPS_ERR   = EnvironmentVariable.get('FMS_WPPS_ERR');
    private static final String FMS_TNAD_ERR   = EnvironmentVariable.get('FMS_TNAD_ERR');
    private static final String FMS_VSG_ERR   = EnvironmentVariable.get('FMS_VSG_ERR');
    private static final String FMS_DCWX_ERR   = EnvironmentVariable.get('FMS_DCWX_ERR');
    private static final String FMS_DCWY_ERR    = EnvironmentVariable.get('FMS_DCWY_ERR');
    private static final String FMS_CFFN_ERR    = EnvironmentVariable.get('FMS_CFFN_ERR');
    private static final String FMS_NDPS_ERR    = EnvironmentVariable.get('FMS_NDPS_ERR');
    private static final String FMS_NPSS_ERR     = EnvironmentVariable.get('FMS_NPSS_ERR');
    private static final String FMS_MPTS_ERR      = EnvironmentVariable.get('FMS_MPTS_ERR');
    private static final String FMS_MPSS_ERR      = EnvironmentVariable.get('FMS_MPSS_ERR');
    private static final String FMS_MPP_ERR      = EnvironmentVariable.get('FMS_MPP_ERR');
    private static final String FMS_MPGS_ERR       = EnvironmentVariable.get('FMS_MPGS_ERR');
    private static final String FMS_MPU_ERR        = EnvironmentVariable.get('FMS_MPU_ERR');
    private static final String FMS_TQMD_ERR         = EnvironmentVariable.get('FMS_TQMD_ERR');
    
    public static final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 
    public static final String FMS_SAP_ACC_NO1 = EnvironmentVariable.get('FMS_SAP_ACC_NO1'); 
    public static final String FMS_SAP_ACC_NO2 = EnvironmentVariable.get('FMS_SAP_ACC_NO2'); 
    public static final String FMS_SAP_ACC_NO3 = EnvironmentVariable.get('FMS_SAP_ACC_NO3');
    public static final String FMS_SAP_ACC_NO4 = EnvironmentVariable.get('FMS_SAP_ACC_NO4'); 
    public static final String FMS_SAP_ACC_NO5 = EnvironmentVariable.get('FMS_SAP_ACC_NO5'); 
    public static final String FMS_SAP_ACC_NO6 = EnvironmentVariable.get('FMS_SAP_ACC_NO6');
    public static final String FMS_SAP_ACC_NO7 = EnvironmentVariable.get('FMS_SAP_ACC_NO7');
    public static final String FMS_SAP_ACC_NO8 = EnvironmentVariable.get('FMS_SAP_ACC_NO8');
    public static final String FMS_SAP_ACC_NO9 = EnvironmentVariable.get('FMS_SAP_ACC_NO9');
    public static final String FMS_SAP_ACC_NO10 = EnvironmentVariable.get('FMS_SAP_ACC_NO10');
    public static final String FMS_SAP_ACC_NO11 = EnvironmentVariable.get('FMS_SAP_ACC_NO11');
    public static final String FMS_SAP_ACC_NO13 = EnvironmentVariable.get('FMS_SAP_ACC_NO13');
    public static final String FMS_SAP_ACC_NO16 = EnvironmentVariable.get('FMS_SAP_ACC_NO16');
    public static final String FMS_SAP_ACC_NO17 = EnvironmentVariable.get('FMS_SAP_ACC_NO17');
    
    
    public static Boolean saveHistory = true;
    public static Boolean isStepPlan = false;
    public UtilityCls(){
        
    }
    
    /*
@MethodName: createContent
@Parameters: List<Form_Management_System__c> formObjNewList
@ReturnType: void
@Author: Inshu Misra
@CreatedDate: 21 Jun,2016
@Description: Added method for generating Public URL for the attachments...#IM
@Modifications-
*
*/
    public static void createContent(List<Form_Management_System__c> formObjNewList){
        Map<String, Form_Management_System__c> finalSet= new Map<String, Form_Management_System__c>();
        for(Form_Management_System__c fmsNew: formObjNewList){
            if(fmsNew.IsGeneratePublicURLForAttach__c){
                finalSet.put(fmsNew.AdvancedProcessFileAttachment__c, fmsNew);
                finalSet.put(fmsNew.FileAttachment__c, fmsNew);
            }
            if(fmsNew.IsGeneratePublicURLForECCNAttach__c){
                finalSet.put(fmsNew.ECCN_attachmentName__c, fmsNew);
            }
        }
        Set<Id> existingContV = new Set<Id>();
        for(ContentDistribution cd:[select ContentVersionId from ContentDistribution where ContentVersionId in:finalSet.keySet()]){
            existingContV.add(cd.ContentVersionId);
        }
        List<ContentDistribution> cdis = new List<ContentDistribution>();
        for(ContentVersion contVersionRec:[SELECT Id, ContentSize, Title, ContentDocumentId FROM ContentVersion where Id in:finalSet.keySet()]){
            if(!existingContV.contains(contVersionRec.Id)){
                cdis.add(new ContentDistribution(RelatedRecordId = finalSet.get(contVersionRec.Id).Id, 
                                                 ContentVersionId = contVersionRec.Id, 
                                                 Name = finalSet.get(contVersionRec.Id).Name+'-'+contVersionRec.Id,
                                                 PreferencesAllowOriginalDownload = true,
                                                 PreferencesNotifyOnVisit = false));
            }
        }
        if(cdis != null && !cdis.isEmpty()){
            upsert cdis;
        }
    }    
    // General method to get all the fields for the given Object
    public static string getAllFields(string objectName){
        String fieldnames = '';
        String sql='';
        sObject obj;
        try{
            Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe();
            Schema.Sobjecttype s = m.get(objectName);
            Schema.Describesobjectresult r = s.getDescribe(); 
            
            //get fields
            Map<String, Schema.Sobjectfield> fields = r.fields.getMap();
            for(string field: fields.keySet()){
                if(fieldnames == ''){
                    fieldnames = field;
                }
                else{
                    fieldnames += ',' + field; 
                }
            }
        }
        catch(Exception e){
            return null;
        }
        return fieldnames;
    }
    /*
@MethodName: saveExceptionLog
@Parameters: String source, String sourceFunction, String referenceId, String referenceInfo, String logMessage, String payload, String debugLevel, String logCode, String ApplicationName, Exception ex, Long timer
@ReturnType: void
@Author: Inshu Misra
@CreatedDate: 5 Dec,2016
@Description: method to log the exception in Application_Log__c object...#IM
@Modifications-
*
*/
    public static void saveExceptionLog (String source, String sourceFunction, String referenceId, String referenceInfo, String logMessage, String payload, String debugLevel, String logCode, String ApplicationName, Exception ex, Long timer){
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
        alw.source = source;
        alw.sourceFunction = sourceFunction;
        alw.ApplicationName=ApplicationName;                  
        alw.referenceInfo = referenceInfo;
        alw.logMessage = (logMessage != null && logMessage != '')?logMessage:'Error Message='+ex.getMessage()+' At Line Number='+ex.getLineNumber()+' Stack Trace='+ex.getStackTraceString();
        alw.debugLevel = debugLevel;
        alw.logCode = logCode;
        alw.ex=(ex != null)?ex.getCause():null;
        alw.referenceId = referenceId;
        alw.payload = payLoad;
        alw.timer = timer;
        
        GlobalUtility.logMessage(alw);
    }
    
     /*
     @MethodName: createRetrofitDevice
     @Parameters: Device deviceObj - Device object instance of Base device for which retrofit to be created.
                  String deviceIdName - Retrofit device Name / deviceId field value input from user,
                                        if null this will be autopopulated , postfixing number to device name.
     @ReturnType: Device__c
     @Author:Anil Kumar Reddy L
     @CreatedDate: 9 Dec,2016
     @Description: method to create a Retrofit device .
     @Modifications-
     *
     */
    public Static Device__c createRetrofitDevice(Device__c deviceObj, String deviceIdName){
        String filterby = (deviceObj.CRMDID__c).Substring(0,(deviceObj.CRMDID__c).length()-2);
        List<Device__c> deviceChildList = Database.query('SELECT ID,CRMDID__c FROM Device__c WHERE CRMDID__c LIKE  \'%'+filterby+'%\'  order by CRMDID__c');
        Set<Integer> retrofitNumSet = new Set<Integer>();
        for(Device__c devCrmid : deviceChildList){
            if(devCrmid.CRMDID__c!=null && devCrmid.CRMDID__c !=''){
                retrofitNumSet.add(Integer.valueOf((devCrmid.CRMDID__c).right(2)));
            }      
        }
        List<Integer> stringList = new List<Integer>();
        stringList.addAll(retrofitNumSet);
        stringList.sort();
        String nextNum = (stringList.size()==0 ? '01' : String.valueOf((stringList.get(stringList.size()-1))+01));
        Device__c  retrofitDevice = deviceObj.clone(false,true);
        if(deviceIdName == null || deviceIdName ==''){
            retrofitDevice.name = String.valueOf((deviceObj.name).split('\\.')[0])+'.'+(nextNum.length()==2?nextNum:('0'+nextNum)); 
        } else{
            retrofitDevice.name = deviceIdName;
        }
        retrofitDevice.CRMDID__c = String.valueOf((deviceObj.CRMDID__c).Substring(0,(deviceObj.CRMDID__c).length()-2))+(nextNum.length()==2?nextNum:('0'+nextNum));
        retrofitDevice.Fab__c= 'FAB 9';
        retrofitDevice.Device_Type__c = 'Retrofit';
        retrofitDevice.Tapeout_Type__c = 'Retrofit';
        retrofitDevice.Base_Device__c = deviceObj.id;
        if(deviceObj.Generate_Standard_Frame__c == null || deviceObj.Generate_Standard_Frame__c == ''){
            retrofitDevice.Generate_Standard_Frame__c = 'No';
        }
        if(deviceObj.Confidence_Level_Tapeout__c == null || deviceObj.Confidence_Level_Tapeout__c == ''){
            retrofitDevice.Confidence_Level_Tapeout__c = '100';
        }
        if(deviceObj.Stage__c == null || deviceObj.Stage__c == ''){
            retrofitDevice.Stage__c = 'Design In';
        }
        if(deviceObj.Status__c == null || deviceObj.Status__c == ''){
            retrofitDevice.Status__c = 'Active';
        }
        if(deviceObj.Enabled_via_previous_MPW_1__c == null || deviceObj.Enabled_via_previous_MPW_1__c == ''){
            retrofitDevice.Enabled_via_previous_MPW_1__c = 'No';
        }
        if(deviceObj.Automotive_Device__c == null || deviceObj.Automotive_Device__c == ''){
            retrofitDevice.Automotive_Device__c = 'No';
        }
        if(deviceObj.Original_Forecasted_Tapeout_Date__c == null){
            retrofitDevice.Original_Forecasted_Tapeout_Date__c = system.today();
        }
        if(deviceObj.Semiconductor_Device__c == null || deviceObj.Semiconductor_Device__c == ''){
            retrofitDevice.Semiconductor_Device__c = 'Analog - Others';
        }
        if(deviceObj.Reticle_Type__c == null || deviceObj.Reticle_Type__c == ''){
            retrofitDevice.Reticle_Type__c = 'Single Layer Reticle (SLR)';
        }        
        retrofitDevice.Secure_Device__c = 'No';
        return retrofitDevice;
    }

    /*
    @MethodName: isExportControlWaivedCustomer
    @Parameters: Form_Management_System__c fmsObj
    @ReturnType: Boolean
    @Author: Inshu Misra
    @CreatedDate: 6 July,2017
    @Description: method to determine if the Form Object Customer is waived off to create RIT even if Export Control stage is Submit and not approved...#IM
    @Modifications-
    *
    */
    public static Boolean isExportControlWaivedCustomer (Form_Management_System__c fmsObj){
        if(fmsObj != null && fmsObj.Customer_Name__c != null 
           && fmsObj.Customer_Name__r.SAP_Account_Number__c != null 
           && FMSRITExportControlWaiverAccounts__c.getAll().keySet().contains(fmsObj.Customer_Name__r.SAP_Account_Number__c)){
            return true;
        }
        return false;
    }
    
    /*
    @MethodName: createExportControlJunction
    @Parameters: Form_Management_System__c fmsObj
    @ReturnType: Device_Export_Control_Junction__c
    @Author: Anirban Roy
    @CreatedDate: 17 July,2017
    @Description: method to insert Export Control Junction and point it to right device.
    @Modifications-
    *
    */
    public static Device_Export_Control_Junction__c createExportControlJunction(String basedevId, String devId){        
        Boolean expConChk = false;
        String expConForm;
        for(Device_Export_Control_Junction__c devEC : [SELECT id,export_control_form__c, device__c
                                                       FROM  Device_Export_Control_Junction__c
                                                       WHERE device__c = :basedevId 
                                                       OR device__c = :devId]){
            if(devId == devEC.device__c){
                expConChk = true;
            }else{
                expConForm = devEC.export_control_form__c;    
            }    
        }
            
        if(expConForm!=null && expConForm!='' && !expConChk){
            Device_Export_Control_Junction__c rec = new Device_Export_Control_Junction__c(
                device__c = devId,
                export_control_form__c = expConForm
            );
            return rec;
        }
        return null;    
    }
    
    /*
    @MethodName: isRITAddendumAllowed
    @Parameters: Form_Management_System__c fmsObj
    @ReturnType: Boolean
    @Author: Inshu Misra
    @CreatedDate: 6 July,2017
    @Description: method to determine if the Form Object Customer is waived off to create RIT even if Export Control stage is Submit and not approved...#IM
    @Modifications-
	17-Jul-2017 	Inshu Misra				Modified condition against ExportControl IMC issue
    *
    */
    public static Boolean isRITAddendumAllowed (Form_Management_System__c fmsObj){
        if(fmsObj != null && fmsObj.Device__c != null 
           && ((fmsObj.Device__r.Export_Control_Status__c == EnvironmentVariable.get('FMS_Approved')) 
               || (isExportControlWaivedCustomer(fmsObj) && fmsObj.Device__r.Export_Control_Status__c == EnvironmentVariable.get('FMS_Submitted'))
              )){
                  return true;
              }
        return false;
    }
    
    /*
    @MethodName: changeHistory
    @Parameters: String fmsId
    @ReturnType: PageReference
    @Author: Inshu Misra
    @CreatedDate: 13 July,2017
    @Description: method to call custom built Form History report...#IM
    @Modifications-
    *
    */
    public static PageReference changeHistory(Form_Management_System__c fms) {
        PageReference histReport = Page.FMSFormHistoryReport;
        histReport.getParameters().put('id',fms.Id);
        if(UtilityCls.isStepPlan){
            histReport.getParameters().put('mainFormId',fms.Main_Form_Id__c);
        }
        return histReport;
    }  
    
    /*
    @MethodName: deleteFMSSubscription
    @Parameters: List<FMS_Search_Filter__c> Saved Search Ids
    @ReturnType: void
    @Author: Anirban Roy
    @CreatedDate: 07 September,2017
    @Description: method will delete the subscription records under Saved Search
    @Modifications-
    *
    */
    public static void deleteSubscription(List<FMS_Search_Filter__c> toBeDeletedList) {
        List<FMS_Subscription__c> subscriptionDeleteList = [SELECT Id FROM FMS_Subscription__c where Saved_Search_Id__c IN :toBeDeletedList];
        if(subscriptionDeleteList!=null && !subscriptionDeleteList.isEmpty()){
            delete subscriptionDeleteList;
        }
    }
    
    /*
    @MethodName: validateFieldsCheck
    @Parameters: Form_Management_System__c fms, String pageNo
    @ReturnType: Map<String fieldName, String errorMessages>
    @Author: Anirban Roy
    @CreatedDate: 12 October,2017
    @Description: method to validate the fields and send the error messages
    @Modifications-
    *
    */
    public static Map<String, String> validateFieldsCheck(Form_Management_System__c fms, String pageNo) {
        Map<String,String> errMessages = new Map<String,String>();
        System.debug(fms.form_type__c);
        if(fms.form_type__c == 'Main Product Definition Form'){
            if(pageNo == 'page3'){
                if(isDieSizeCheck(fms,'DieXSize__c')){
                    errMessages.put('DieXSize__c',FMS_DSXG_ERR);     
                }                
                if(isDieSizeCheck(fms,'DieYSize__c')){
                    errMessages.put('DieYSize__c',FMS_DSYG_ERR);     
                }
                List<String> coordinates = new List<String>();
                List<String> fieldNames = new List<String>();
                if(fms.NumOfDesigns__c != null) {
                    fieldNames.add('NumOfDesigns__c');
                }
                if(fms.NumOfBEOLDesigns__c != null) {
                    fieldNames.add('NumOfBEOLDesigns__c');
                }
                if(fms.NumC4Pads__c != null){
                    fieldNames.add('NumC4Pads__c');
                }
                if(fms.WireBondPad__c != null){
                    fieldNames.add('WireBondPad__c');
                }
                
                coordinates = checkMainRITFieldValue(fms, fieldNames);
                if(coordinates<>NULL && !coordinates.isEmpty()) {
                    for(String s : coordinates) {
                        if(s == 'NumOfDesigns__c'){
                            errMessages.put(s, FMS_TNTP_ERR);
                        }else if(s == 'NumOfBEOLDesigns__c'){
                            errMessages.put(s, FMS_NUBEL_ERR);
                        }                        
                    }
                }
                
                if(fms.NumOfFEOLDesigns__c != null && (!((String.valueOf(fms.NumOfFEOLDesigns__c)).isNumeric()) || fms.NumOfFEOLDesigns__c < 0)){
                    errMessages.put('NumOfFEOLDesigns__c', FMS_NUFELD_ERR);    
                }
                
                if(fms.WireBondPadPitch__c != null && ((String.valueOf(fms.WireBondPadPitch__c)).isNumeric() || !((String.valueOf(fms.WireBondPadPitch__c)).isNumeric())) && fms.WireBondPadPitch__c <= 0){
                    errMessages.put('WireBondPadPitch__c', FMS_WPPS_ERR);
                }                
                
                if(coordinates<>NULL && !coordinates.isEmpty()) {
                    for(String s : coordinates) {
                        if(s == 'NumC4Pads__c'){
                            errMessages.put(s, FMS_TNAD_ERR);
                        }else if(s == 'WireBondPad__c'){
                            errMessages.put(s, WireBondPad + ' : ' + FMS_VSG_ERR);
                        }                        
                    }
                }
                
                if(fms.VerticalX__c != null && ((String.valueOf(fms.VerticalX__c)).isNumeric() || !((String.valueOf(fms.VerticalX__c)).isNumeric())) && fms.VerticalX__c <= 0){
                    errMessages.put('VerticalX__c', FMS_DCWX_ERR);
                }
                
                if(fms.HorizontalY__c != null && ((String.valueOf(fms.HorizontalY__c)).isNumeric() || !((String.valueOf(fms.HorizontalY__c)).isNumeric())) && fms.HorizontalY__c <= 0){
                    errMessages.put('HorizontalY__c', FMS_DCWY_ERR);
                }
                
            }else if(pageNo == 'page5'){
                if(fms.CrossFlowIFPM__c != null && ((String.valueOf(fms.CrossFlowIFPM__c)).isNumeric() || !((String.valueOf(fms.CrossFlowIFPM__c)).isNumeric())) && fms.CrossFlowIFPM__c <= 0){
                    errMessages.put('CrossFlowIFPM__c', FMS_CFFN_ERR);
                }                
                if(fms.NoOfDiffPairs__c != null && (!((String.valueOf(fms.NoOfDiffPairs__c)).isNumeric()) || fms.NoOfDiffPairs__c <= 0)){
                    errMessages.put('NoOfDiffPairs__c', FMS_NDPS_ERR);
                }
                
                if(fms.NoOfPowerSupplies__c != null && (!((String.valueOf(fms.NoOfPowerSupplies__c)).isNumeric()) || fms.NoOfPowerSupplies__c < 0)) {
                    errMessages.put('NoOfPowerSupplies__c', FMS_NPSS_ERR);
                }
                if(fms.ModulePinsBallsTotal__c != null && (!((String.valueOf(fms.ModulePinsBallsTotal__c)).isNumeric()) || fms.ModulePinsBallsTotal__c < 0)) {
                    errMessages.put('ModulePinsBallsTotal__c',FMS_MPTS_ERR);
                }
                if(fms.ModulePinsBallsSignal__c != null && (!((String.valueOf(fms.ModulePinsBallsSignal__c)).isNumeric()) || fms.ModulePinsBallsSignal__c < 0)){
                    errMessages.put('ModulePinsBallsSignal__c',FMS_MPSS_ERR);
                }
                if(fms.ModulePinsBallsPower__c != null && (!((String.valueOf(fms.ModulePinsBallsPower__c)).isNumeric()) || fms.ModulePinsBallsPower__c < 0)){
                    errMessages.put('ModulePinsBallsPower__c',FMS_MPP_ERR);
                }
                if(fms.ModulePinsBallsGround__c != null && (!((String.valueOf(fms.ModulePinsBallsGround__c)).isNumeric()) || fms.ModulePinsBallsGround__c < 0)) {
                    errMessages.put('ModulePinsBallsGround__c',FMS_MPGS_ERR);
                }
                if(fms.ModulePinsBallsUnused__c != null && (!((String.valueOf(fms.ModulePinsBallsUnused__c)).isNumeric()) || fms.ModulePinsBallsUnused__c < 0)){
                    errMessages.put('ModulePinsBallsUnused__c',FMS_MPU_ERR);
                }
                if(fms.NumberModuleDecouplingCapacitors__c != null && (!((String.valueOf(fms.NumberModuleDecouplingCapacitors__c)).isNumeric()) || fms.NumberModuleDecouplingCapacitors__c < 0)){
                    errMessages.put('NumberModuleDecouplingCapacitors__c', FMS_TQMD_ERR);
                }                                   
            }
        }else if(fms.form_type__c == 'Incremental Mask Change (IMC)'){
        //String val = fms.IMCNumOfDesigns__c);
        System.debug(String.ValueOf(fms.IMCNumOfDesigns__c));
            if(fms.IMCNumOfDesigns__c != null && (!((String.valueOf(fms.IMCNumOfDesigns__c)).isNumeric()) || fms.IMCNumOfDesigns__c <= 0)){
                    errMessages.put('IMCNumOfDesigns__c', FMS_TNTP_ERR);
            }
            if(fms.IMCNumOfBEOLDesigns__c != null){
                if(!((String.valueOf(fms.IMCNumOfBEOLDesigns__c)).isNumeric()) || fms.IMCNumOfBEOLDesigns__c <= 0) {
                    errMessages.put('IMCNumOfBEOLDesigns__c',FMS_NUBEL_ERR);
                }
            }
            if(fms.IMCNumOfFEOLDesigns__c != null){
                if(!((String.valueOf(fms.IMCNumOfFEOLDesigns__c)).isNumeric()) || fms.IMCNumOfBEOLDesigns__c < 0) {
                    errMessages.put('IMCNumOfFEOLDesigns__c', FMS_NUFELD_ERR);
                }
            }
        }else if(fms.form_type__c == 'Design Data Submission (RIT)'){
            List<String> coordinates = new List<String>();
            List<String> fieldNames = new List<String>();
            Map<String, String> fieldLabelMap = new Map<String, String>();
            if(pageNo == 'page1'){
                if(fms.LeftXCoordinate__c != null) {
                    fieldNames.add('LeftXCoordinate__c');
                    fieldLabelMap.put('LeftXCoordinate__c', LeftXCoordinate);
                }
                if(fms.LeftYCoordinate__c != null) {
                    fieldNames.add('LeftYCoordinate__c');
                    fieldLabelMap.put('LeftYCoordinate__c', LeftYCoordinate);
                }
                if(fms.RightXCoordinate__c != null) {
                    fieldNames.add('RightXCoordinate__c');
                    fieldLabelMap.put('RightXCoordinate__c', RightXCoordinate);
                }
                if(fms.RightYCoordinate__c != null) {
                    fieldNames.add('RightYCoordinate__c');
                    fieldLabelMap.put('RightYCoordinate__c', RightYCoordinate);
                }
                coordinates = checkMainRITFieldValue(fms, fieldNames);
                if(coordinates<>NULL && !coordinates.isEmpty()) {
                    for(String s : coordinates) {
                        errMessages.put(s, fieldLabelMap.get(s) + ' : Coordinates should be an integer, 0 or greater.');
                    }
                }
            }
        }else if(fms.form_type__c == 'Design Data Return (DDR)'){
            List<String> coordinates = new List<String>();
            List<String> fieldNames = new List<String>();
            Map<String, String> fieldLabelMap = new Map<String, String>();
            if(fms.DDRLeftXCoordinate__c != null) {
                fieldNames.add('DDRLeftXCoordinate__c');
                fieldLabelMap.put('DDRLeftXCoordinate__c', DDRLeftXCoordinate);
            }
            if(fms.DDRLeftYCoordinate__c != null) {
                fieldNames.add('DDRLeftYCoordinate__c');
                fieldLabelMap.put('DDRLeftYCoordinate__c', DDRLeftYCoordinate);
            }
            if(fms.DDRRightXCoordinate__c != null) {
                fieldNames.add('DDRRightXCoordinate__c');
                fieldLabelMap.put('DDRRightXCoordinate__c', DDRRightXCoordinate);
            }
            if(fms.DDRRightYCoordinate__c != null) {
                fieldNames.add('DDRRightYCoordinate__c');
                fieldLabelMap.put('DDRRightYCoordinate__c', DDRRightYCoordinate);
            }
            coordinates = UtilityCls.checkDDRFieldValue(fms, fieldNames);
            System.debug(coordinates );
            if(coordinates<>NULL && !coordinates.isEmpty()) {
                for(String s : coordinates) {
                    errMessages.put(s, fieldLabelMap.get(s) + ' : Please enter value greater than 0 and max 5 digits long with no decimal digits.');
                }
            }   
        }
        return errMessages;
    } 
    
    // Validation method for Integer fields with greater than zero value
    private static List<String> checkMainRITFieldValue(Form_Management_System__c fmsObj, List<String> fieldNames) {
        List<String> coordinates = new List<String>();
        for(String s : fieldNames) {
            if(!((String.valueOf(fmsObj.get(s))).isNumeric()) || (Decimal)(fmsObj.get(s)) <= 0) {
                coordinates.add(s);
            }
        }
        return coordinates;
    }
    
    // Validation method for Integer fields with greater than zero value and will have digits less and equal to 5.
    private static List<String> checkDDRFieldValue(Form_Management_System__c fmsObj, List<String> fieldNames) {
        List<String> coordinates = new List<String>();
        for(String s : fieldNames) {
            if(!((String.valueOf(fmsObj.get(s))).isNumeric()) || (Decimal)(fmsObj.get(s)) < 0 || String.valueOf(fmsObj.get(s)).length() > 5) {
                coordinates.add(s);
            }
        }
        return coordinates;
    }
    
    // Validation for DieSize check in Main Form Page 3.
    private static Boolean isDieSizeCheck(Form_Management_System__c fms, String fieldName){
        Boolean dieSizeChk = false;
        if(fms.get(fieldName) != null && (Decimal)(fms.get(fieldName)) > 0 && (Decimal)(fms.get(fieldName)) < 100){
           String strDieSize = String.valueOf(fms.get(fieldName));
           if(strDieSize.indexOf('.')>-1){
               Integer decIndex = strDieSize.indexOf('.');
               Integer len = strDieSize.length();
               Integer diff = len-(decIndex+1);
               if(diff!=4 && diff!=5){
                   dieSizeChk = true;    
               }    
           }else{
               dieSizeChk = true;
           }         
        }else if(fms.get(fieldName) != null){
           dieSizeChk = true;                   
        }
        return dieSizeChk;
    }

    public static final String Design_MultiReticle = 'Multi-Design Reticle (>1 Topcell)';
    public static final String Design_ChipletDesign = 'Multi-Chiplet Design (one GDS, single Topcell)';
    public static final String Design_SingleChip = 'Single Chip (one GDS)';
    public static final String Draft = 'Draft';
    public static final String Submitted = 'Submitted';
    public static final String Frozen = 'Frozen';
    public static final String Thawed = 'Thawed';
    public static final String InactiveSubmitted = 'InactiveSubmitted';
    public static final String InactiveThawed = 'InactiveThawed';
    public static final String SubmittedForQuote = 'SubmittedForQuote';
    public static final String InactiveSubmittedForQuote = 'InactiveSubmittedForQuote';
    public static final String CopperPillar = 'Copper Pillar';
    public static final String C4flipchip = 'C4 flip chip';
    public static final String Wirebond = 'Wirebond';
    public static final String WLCSP_RDL = 'WLCSP-RDL';
    public static final String WLCSP_BoP = 'WLCSP-BoP';
    public static final String X32SOI = '32SOI';
    public static final String BiCMOS_5HPE_SiGe_5HPE = 'BiCMOS 5HPE (SiGe 5HPE)';
    public static final String BiCMOS_5PAe_1KW5PAe = 'BiCMOS 5PAe (1KW5PAe)';
    public static final String BiCMOS_5PAe_SiGe_5PAe = 'BiCMOS 5PAe (SiGe 5PAe)';
    public static final String BiCMOS_5PAX_1K5PAXE = 'BiCMOS 5PAX (1K5PAXE)';
    public static final String BiCMOS_5PAX_SiG5PAX = 'BiCMOS 5PAX (SiG5PAX)';
    public static final String BiCMOS_6WL_SiGe_6WL = 'BiCMOS 6WL (SiGe 6WL)';
    public static final String BiCMOS_7PA_SiGe_7PA = 'BiCMOS 7PA (SiGe 7PA)';
    public static final String BiCMOS_7WL_SiGe_7WL = 'BiCMOS 7WL (SiGe 7WL)';
    public static final String BiCMOS_8HP_SiGe_8HP = 'BiCMOS 8HP (SiGe 8HP)';
    public static final String BiCMOS_8WL_SiGe_8WL = 'BiCMOS 8WL (SiGe 8WL)';
    public static final String BiCMOS_8XP_SiGe_8XP = 'BiCMOS 8XP (SiGe 8XP)';
    public static final String BiCMOS_9HP_SiGe_9HP = 'BiCMOS 9HP (SiGe 9HP)';
    public static final String BiCMOS5PA4_HRS5PA4 = 'BiCMOS5PA4 (HRS5PA4)';
    public static final String BiMOS_P6 = 'BiMOS P6';
    public static final String BMSP6C9 = 'BMSP6C9';
    public static final String CMHV7SF = 'CMHV7SF';
    public static final String CSOI8SW= 'CSOI8SW';
    public static final String CMOS_10LP = 'CMOS 10LP';
    public static final String CMOS_10LPe = 'CMOS 10LPe';
    public static final String CMOS_10RFe = 'CMOS 10RFe';
    public static final String CMOS_10SF = 'CMOS 10SF';
    public static final String CMOS_6RF_CMRF6SF = 'CMOS 6RF (CMRF6SF)';
    public static final String CMOS_6SF = 'CMOS 6SF';
    public static final String CMOS_7RF_CMRF7SF = 'CMOS 7RF (CMRF7SF)';
    public static final String CMOS_7TG_CMRF7TG = 'CMOS 7TG (CMRF7TG)';
    public static final String CMOS_8RF_CMRF8SF = 'CMOS 8RF (CMRF8SF)';
    public static final String CMOS_9LP_CMOS_9RF = 'CMOS 9LP (CMOS 9RF)';
    public static final String CMOS_9RFe = 'CMOS 9RFe';
    public static final String CMOS_9SF = 'CMOS 9SF';
    public static final String CMS90WG_CMOS9WG = 'CMS90WG (CMOS9WG)';
    public static final String CNV8SFi = 'CNV8SFi';
    public static final String CSOI_7RF = 'CSOI 7RF';
    public static final String CSOI_7SW = 'CSOI 7SW';
    public static final String CSOI_7TF = 'CSOI 7TF';
    public static final String IPD5PAE = 'IPD5PAE';
    public static final String SOI12S0 = 'SOI12S0';
    public static final String CSOS_7RF= 'CSOS 7RF';
    public static final String SOI7SWT = 'SOI7SWT';
    public static final String CM7FRAM = 'CM7FRAM';
    public static final String I45RFSOI = '45RFSOI';
    
    
    public static final String No_21L2039 = 'No(21L2039)';
    public static final String Dicing = 'Dicing';
     //Ravindra - Changes Starts for displaying files from Libraries
    public static final String FMSLibraries = 'FMS Documents';//Added by Ravindra
    public static final String FMSMainFormReleaseRequirements = 'Release Requirements';
    public static final String FMSMainFormWaiverTemplate = 'Waiver Request Form';
    public static final String FMSMainFormECCNTemplate = 'ECCN Template';
    public static final String FMSReleaseAutomationTraining = 'ReleaseAutomationTraining';

   
    public static map<String,String> getContentList(){
        Map<String, String> docList= new Map<String, String>();
        String workspaceId;
      
        List<ContentWorkspace> cwList = [SELECT Id FROM ContentWorkspace WHERE Name =: FMSLibraries];
        if(!cwList.isEmpty()){
            workspaceId = cwList[0].id;    
        }
      
      
        String FMS_Main_Form_ECCN_Template = EnvironmentVariable.get('FMS_Main_Form_ECCN_Template') != NULL ? EnvironmentVariable.get('FMS_Main_Form_ECCN_Template') : 'MPW Export Information';
        String FMS_Main_Form_Waiver_Template = EnvironmentVariable.get('FMS_Main_Form_Waiver_Template') != NULL ? EnvironmentVariable.get('FMS_Main_Form_Waiver_Template') : 'GR Error Waiver Request Form and Instructions';
        String FMS_Release_Automation_Training_Template = EnvironmentVariable.get('FMS_Release_Automation_Training') != NULL ? EnvironmentVariable.get('FMS_Release_Automation_Training') : 'Design Data Submission Process_Fabs 9 & 10';
        for(ContentVersion c: [SELECT id,Title,ContentSize,FileExtension FROM ContentVersion WHERE ContentDocument.ParentId =:workspaceId  and IsLatest = TRUE]){
            if((FMS_Main_Form_ECCN_Template).equalsIgnoreCase(c.Title)){
                docList.put(FMSMainFormECCNTemplate, '/sfc/servlet.shepherd/version/download/'+c.Id);
            }
            else  if((FMS_Main_Form_Waiver_Template).equalsIgnoreCase(c.Title)){
                docList.put(FMSMainFormWaiverTemplate, '/sfc/servlet.shepherd/version/download/'+c.Id);
            }
            else  if((FMS_Release_Automation_Training_Template).equalsIgnoreCase(c.Title)){
                docList.put(FMSReleaseAutomationTraining, '/sfc/servlet.shepherd/version/download/'+c.Id);
            }
            else{
            docList.put(c.Title, '/sfc/servlet.shepherd/version/download/'+c.Id);
            }
        }

        return docList;
    }  
    //Ravindra - Changes Ends for displaying files from Libraries
    //
     //===============================(Start)Prod Issue# 164===================================
     
    private static final String FMS_IMC_FORM         = EnvironmentVariable.get('FMS_IMC_FORM');
    private static final String FMS_MAIN_FORM         = EnvironmentVariable.get('FMS_MAIN_FORM');
    
    
    public static Form_Management_System__c getParentDesignServiceData(Form_Management_System__c IMCFormObj){
        Map<String, Form_Management_System__c> fmsForms = new  Map<String, Form_Management_System__c>();
        Boolean dtlFound = False;
        String tempId;
        Form_Management_System__c tempParentFrm = new Form_Management_System__c();
        Form_Management_System__c parentServiceOpts = new Form_Management_System__c();
       
        Try{          
        for(Form_Management_System__c fmsForm:[SELECT id,Name,Main_Form_Id__c,Parent_Form_Id__c,OverrideParentOptions__c,DataCheckingOptions__c,StepPlanCustomRequirement1__c,StepPlanCustomRequirementInput1__c,ServiceOptions__c,
                                                       BacksideGrindThickness__c,OtherServiceFeatures__c,Deliverable__c,DesignSubmission__c,Form_Type__c,IMCInputMethod__c,Chipedgedesign__c
                                                       FROM Form_Management_System__c
                                                       WHERE (Main_Form_Id__c =: IMCFormObj.Main_Form_Id__c OR Id =:IMCFormObj.Main_Form_Id__c)
                                                       AND Parent_Form_Id__c !=: IMCFormObj.id
                                                       AND (Form_Type__c =: FMS_MAIN_FORM 
                                                            OR Form_Type__c =: FMS_IMC_FORM)
                                                ])  {
                                                    
                                                    fmsForms.put(fmsForm.id,fmsForm);
                                                    
                                                }
            
            IF(IMCFormObj.Parent_Form_Id__r.OverrideParentOptions__c == 'Yes'){
                 parentServiceOpts= fmsForms.get(IMCFormObj.Parent_Form_Id__c);
            }
            else{
                tempId = IMCFormObj.Parent_Form_Id__c;
                 while(!dtlFound){
                    tempParentFrm = fmsForms.get(tempId);
                 
                    
                    if(tempParentFrm.Form_Type__c == FMS_MAIN_FORM  || tempParentFrm.OverrideParentOptions__c=='Yes'){
                       parentServiceOpts= tempParentFrm;
                       dtlFound =True; 
                    }
                    else{
                      tempId =  tempParentFrm.Parent_Form_Id__c; 
                    }
                }
          }
        }
    catch(Exception e){
                UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }   
        return parentServiceOpts;
    }
//==================================(End)Prod Issue# 164===============================================
}