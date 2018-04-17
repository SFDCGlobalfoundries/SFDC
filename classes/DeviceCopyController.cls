/*
    Author: Zymark Ambat
    Description: This serves as the Controller for the Copy Device (Clone) functionality.
    History: 
        ZAmbat      02262013    - Code creation.
        NBustillos  03192013    - Updated field value assignment for Project Name field.
        ZAmbat      03312013    - Added Original Forecasted Tapeout Date field.
        ZAmbat      07022013    - Added logic for Device Revision.
        ZAmbat      09192013    - Added validation for Device Revision (IP Declaration Status should be Approved).
        Asolito     09262013    - Autopopulate Assigned Process Tech if coming from Copy Device
        ZAmbat      10022013    - Removed validation of IP Declaration status for Device Revision (TASK-353).
        Asolito     10032013    - Remove auto populate IP, D1 Access and export control status 
        ZAmbat      10032013    - updated code as per TASK-355.
        ZAmbat      10082013    - updated code as per TASK-408.
        ZAmbat      10212013    - updated code to copy export control status and ip declaration status only during device revision.
        ZAmbat      10252013    - updated code to populate Base_Device_Device_Id with the Base Device's CRMDID Base value. 
        Tlai        03042014    - added code to clone cdrs for device revise as per case 6114
        ZAmbat      05152014    - Updated code as per the BX041Clone.cloneBX041Method changes.
        ZAmbat      06092014    - Updated code to remove dependency from Siebel_Device_ID__c.
        Bakundi     07222014    - Updated code to copy the D1 National Access flag for copy or revise.
        Vijay       11262014    - Now Device will be created in "Design In" stage as we have removed "Solutioning" stage as per requirement.
        Vijay       01292015    - updated the business logic to support the Internal Device functionality. Added the recordtype check to verify whether device is Customer
                                  Device or internal Device.
        KOKAGOPI    04052016    - updated code for New Field Mapping while creating device(Automotive_Grade__c)
        Devendra    19042016    - Added new field Generate standard frame.
        Pradosh     01302018    - Case#00084211. Adding Iot Application field in VF
		Devendra    08022018    - Added new field Tapeout Process.
*/
public class DeviceCopyController {
    
    public String deviceId {get;set;}
    public String baseDeviceId {get;set;}
    public String deviceName {get;set;}
    public String opportunityName {get;set;}
    public String newCRMDID {get;set;}
    public String mode {get;set;}
    public Boolean isValidForCopy {get;set;}
    public Boolean isValidForRevision {get;set;}
    public Device__c device {get;set;}
    //added by Vijay 01292015 - added below internaldeviceRecTypeSet and isInternalDevice class variables
    public Set<String> internaldeviceRecTypeSet = new Set<String>{'Internal_Device','Internal_Device_Read_Only'};
    public Boolean isInternalDevice {get;set;}
    
    public DeviceCopyController() {
        // Init
        this.isValidForCopy = true;
        this.isValidForRevision = true;
        this.newCRMDID = Utility.generateNewCRMDID();
        this.device = new Device__c();
        this.isInternalDevice = false;
        
        // Get mode
        this.mode = ApexPages.CurrentPage().getParameters().get('mode');
        
        // Get Id
        this.deviceId = ApexPages.CurrentPage().getParameters().get('Id');
        if (this.deviceId != null && this.deviceId.trim() != '') {
            retrieveDeviceDetails();
        } else {
            this.deviceId = ApexPages.CurrentPage().getParameters().get('bId');
            if (this.deviceId != null && this.deviceId.trim() != '') {
                retrieveDeviceDetails();
            }
        }
    }

    public PageReference retrieveDeviceDetails() {
        // Get current values
        //field IP_Declaration_Submitted_Date__c added by Sunil Arora for case # 35700
        Device__c tempDevice = [
            SELECT      Id
                        , Name
                        , Account__c
						, Design_Partner__c
                        , Opportunity_Program__c
                        , Opportunity_Program__r.Opportunity__r.Name
                        , Fab__c
                        , GSOP_Assignment_Tapeout_Plan__c
                        , Market_Segment__c
                        , Semiconductor_Device__c
                        , End_Application__c
                        , Iot_Application__c
                        , End_Customer__c
                        , Device_Sourcing__c
                        , Geometry__c
                        , CRMDID__c
                        , Device_ID__c
                        , Stage__c
                        , Status__c
                        , Project_Name__c
                        , Device_Type__c
                        , Device_Base_Id__c
                        , Revision__c
                        //, Siebel_Device_ID__c
                        , Opportunity2__c
                        , Opportunity2__r.StageName
                        , Confidence_Level_Tapeout__c
                        , Confidence_Level_Volume__c
                        //, Pre_PTRF_Validation_Status__c
                        , D1_National_Access_Allowed__c
                        , Device_Purpose__c
                        , Enabled_via_previous_MPW_1__c
                        , Previous_Enabling_Devices_MPW__c
                        , BX041_Status__c
                        , STF_Process_ID__c
                        //, PLM_Device_ID__c
                        , Tapeout_Type__c
                        //, Forecasted_Lot_Start_Date__c
                        //, MPW_Train_Number__c
                        , IP_Gap__c
                        , Packaging__c
                        , Test__c
                        , Original_Forecasted_Tapeout_Date__c
                        , Reticle_Type__c
                        , Special_Scribe_Width__c
                        , Export_Control_Waiver_Flag__c
                        , IP_Declaration_Status__c
                        , Export_Control_Status__c
                        , Requested_Process_ID__c
                        , Secure_Device__c
                        , Secure_Device_Level__c
                        , Automotive_Device__c
                        , Automotive_Grade__c
                        , Base_Device_Device_Id__c
                        , Base_Device__c
                        , Assigned_Process_ID__c
                        , Process_Technology_2__c
                        , IP_Declaration_Submitted_Date__c
                        , Internal_Device_Geometry__c
                        , Internal_Device_Process_Family__c
                        , RecordTypeId
                        , RecordType.DeveloperName
                        ,Generate_standard_Frame__c
						,Tapeout_Process__c
                        , Business_Unit__c
                        , Product_Line__c
                        , ECCN_Wafer__c
                        , ECCN_Technology__c
                        , ECCN_Color__c
                        , ITAR_Flag__c
                        , Is_ITAR__c
            FROM        Device__c
            WHERE       Id = :this.deviceId
        ];
        
        //added by Vijay 01292015 - added the device record type check
        if(internaldeviceRecTypeSet.contains(tempDevice.RecordType.DeveloperName)){
            isInternalDevice = true;
        }
        
        if (!isInternalDevice && (tempDevice.Opportunity2__c != null && tempDevice.Opportunity2__r.StageName == '10. Void')) {
            this.isValidForCopy = false;
            return null;
        }
        List<Device__c> listDevice = [SELECT      Id
                                                , CRMDID__c
                                      FROM        Device__c
                                      WHERE       CRMDID__c = :(tempDevice.CRMDID__c.substringBefore('.') + '.00')];
        
        // ZAmbat 07022013 - Added logic for Device Revision
        // Copy Device
        if (this.mode == null || this.mode.trim() == '') {              
            
            //Added Asolito 09262013 - Autopopulate Assigned Process Tech
            //********************************************************************
            this.device.process_technology_2__c = tempDevice.process_technology_2__c;
            //********************************************************************
            this.device.GSOP_Assignment_Tapeout_Plan__c = tempDevice.GSOP_Assignment_Tapeout_Plan__c;
            this.opportunityName = (tempDevice.Opportunity_Program__c != null) ? tempDevice.Opportunity_Program__r.Opportunity__r.Name:'';
            this.device.Device_Type__c = 'Base';
            this.device.Revision__c = '00';
            this.device.Copied_Device__c = tempDevice.id;
            this.device.Confidence_Level_Tapeout__c = tempDevice.Confidence_Level_Tapeout__c;
            this.device.Confidence_Level_Volume__c = tempDevice.Confidence_Level_Volume__c;
			//devendra 08022018
			this.device.Tapeout_Process__c = tempDevice.Tapeout_Process__c;
            //this.device.Device_Purpose__c = tempDevice.Device_Purpose__c;
            //devendra 19042016
            this.device.Generate_standard_Frame__c = tempDevice.Generate_standard_Frame__c;
            //this.device.Pre_PTRF_Validation_Status__c = tempDevice.Pre_PTRF_Validation_Status__c;
            //this.device.PLM_Device_ID__c = tempDevice.PLM_Device_ID__c;
            //this.device.Tapeout_Type__c = tempDevice.Tapeout_Type__c;
            //this.device.Forecasted_Lot_Start_Date__c = tempDevice.Forecasted_Lot_Start_Date__c;
            //this.device.MPW_Train_Number__c = tempDevice.MPW_Train_Number__c;
            this.device.Device_Sourcing__c = tempDevice.Device_Sourcing__c;
            this.device.Base_Device__c = null;
            this.device.BX041_Status__c = 'Pending Submission';
            
            if (listDevice.size() > 0) {
                //ZAmbat 10252013
                //this.device.Base_Device_Device_Id__c = listDevice[0].Name;
                this.device.Base_Device_Device_Id__c = listDevice[0].CRMDID__c.substringBefore('.');
            }
        } else if (this.mode != null && this.mode == Environment_Variable__c.getInstance('DEVICE_REVISION').Value__c) {
            // ZAmbat 09192013 - Added validation for Device Revision
            // ZAmbat 10022013 - Removed validation for IP Declaration Status
            /*if (tempDevice.IP_Declaration_Status__c != Environment_Variable__c.getInstance('IP_DECLARATION_STATUS_APPROVED').Value__c) {
                this.isValidForRevision = false;
                return null;
            }*/
            
            // Revise Device
            this.device.Name = 'REV' + tempDevice.Name;
            
            //this.device.Device_Id__c = 'REV' + tempDevice.Name;
            
            // Set CRMDID
            string tempCRMDID = tempDevice.CRMDID__c.substringBefore('.') + '%';
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
                    this.device.CRMDID__c = listDev[0].CRMDID__c.substringBefore('.') + '.' + String.valueOf(Integer.valueOf(listDev[0].CRMDID__c.substringAfter('.')) + 1).leftPad(2).replace(' ', '0');   
                } else {
                    this.device.CRMDID__c = listDev[0].CRMDID__c.substringBefore('.') + '.' + String.valueOf(1).leftPad(2).replace(' ', '0');
                }
            }
            
            //this.device.Project_Name__c = tempDevice.Project_Name__c;
            this.device.Device_Type__c = 'Revision';
            this.device.Secure_Device_Level__c = tempDevice.Secure_Device_Level__c;
            this.device.Assigned_Process_ID__c = tempDevice.Assigned_Process_ID__c;
            this.device.BX041_Status__c = tempDevice.BX041_Status__c;
            this.device.Export_Control_Waiver_Flag__c = tempDevice.Export_Control_Waiver_Flag__c;
            this.device.Export_Control_Status__c = tempDevice.Export_Control_Status__c;
            this.device.IP_Declaration_Status__c = tempDevice.IP_Declaration_Status__c;
            this.device.IP_Declaration_Status__c = tempDevice.IP_Declaration_Status__c;
            //devendra 19042016
            this.device.Generate_standard_Frame__c = tempDevice.Generate_standard_Frame__c;
            // Bakundi 07222014
            this.device.D1_National_Access_Allowed__c = tempDevice.D1_National_Access_Allowed__c;   
            
            this.device.ECCN_Wafer__c = tempDevice.ECCN_Wafer__c; 
            this.device.ECCN_Technology__c = tempDevice.ECCN_Technology__c; 
            this.device.ECCN_Color__c = tempDevice.ECCN_Color__c; 
            this.device.ITAR_Flag__c = tempDevice.ITAR_Flag__c; 
            this.device.Is_ITAR__c = tempDevice.Is_ITAR__c;
            
            if (listDevice.size() > 0) {
                //ZAmbat 10252013
                //this.device.Base_Device_Device_Id__c = listDevice[0].Name;
                this.device.Base_Device_Device_Id__c = listDevice[0].CRMDID__c.substringBefore('.');
                this.device.Base_Device__c = listDevice[0].Id;
            }
        }
        
        this.device.OwnerId = UserInfo.getUserId();
        this.device.Opportunity_Program__c = tempDevice.Opportunity_Program__c;
        this.device.Opportunity2__c = tempDevice.Opportunity2__c;
        this.device.Stage__c = 'Design In';
        this.device.Status__c = 'Active';
        this.device.Fab__c = tempDevice.Fab__c;
        this.device.Reticle_Type__c = tempDevice.Reticle_Type__c;
        this.device.Special_Scribe_Width__c = tempDevice.Special_Scribe_Width__c;
        this.device.End_Application__c = tempDevice.End_Application__c;
        this.device.Iot_Application__c = tempDevice.Iot_Application__c;
        this.device.End_Customer__c = tempDevice.End_Customer__c;
        this.device.Market_Segment__c = tempDevice.Market_Segment__c;
        this.device.Semiconductor_Device__c = tempDevice.Semiconductor_Device__c;           
        //this.device.D1_National_Access_Allowed__c = tempDevice.D1_National_Access_Allowed__c; // Formerly disabled in Copy Device
        //this.device.IP_Declaration_Status__c = tempDevice.IP_Declaration_Status__c;
        //this.device.Export_Control_Status__c = tempDevice.Export_Control_Status__c;
        this.device.Requested_Process_ID__c = tempDevice.Requested_Process_ID__c;
        this.device.STF_Process_ID__c = tempDevice.STF_Process_ID__c; // Formerly disabled in Copy Device
        this.device.Secure_Device__c = tempDevice.Secure_Device__c;
        this.device.Automotive_Device__c = tempDevice.Automotive_Device__c;
        this.device.Automotive_Grade__c = tempDevice.Automotive_Grade__c;
        //field IP_Declaration_Submitted_Date__c added by Sunil Arora for case # 35700
        this.device.IP_Declaration_Submitted_Date__c=tempDevice.IP_Declaration_Submitted_Date__c;
        this.device.Account__c = tempDevice.Account__c;
        this.device.Design_Partner__c = tempDevice.Design_Partner__c;
        this.device.Internal_Device_Geometry__c = tempDevice.Internal_Device_Geometry__c;
        this.device.Internal_Device_Process_Family__c = tempDevice.Internal_Device_Process_Family__c;
        this.device.RecordTypeId = tempDevice.RecordTypeId;
        
        this.device.Business_Unit__c = tempDevice.Business_Unit__c;
        this.device.Product_Line__c = tempDevice.Product_Line__c;
        
        this.device.Device_Purpose__c = tempDevice.Device_Purpose__c;
        this.device.Project_Name__c = tempDevice.Project_Name__c;
        this.device.Enabled_via_previous_MPW_1__c = tempDevice.Enabled_via_previous_MPW_1__c;
        this.device.Previous_Enabling_Devices_MPW__c = tempDevice.Previous_Enabling_Devices_MPW__c;
        return null;
    }
    
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + this.deviceId);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference save() {
        PageReference pageRef;
        Try {
            // Validate Device Id
            List<Device__c> tempListDevice = new List<Device__c>();
            if (this.mode != null && this.mode == Environment_Variable__c.getInstance('DEVICE_REVISION').Value__c) {
                tempListDevice = [
                    SELECT      Id
                    FROM        Device__c
                    WHERE       Name = :this.device.Name
                                AND Device_Id__c = :this.device.Name
                ];
            } else {
                tempListDevice = [
                    SELECT      Id
                    FROM        Device__c
                    WHERE       Name = :this.device.Name
                                AND Device_Id__c = :(this.device.Name + this.device.Tapeout_Type__c.replace(' ', '').toUpperCase())
                ];
            }
            
            if (tempListDevice.size() > 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_ID_ALREADY_EXIST').Message__c));
                return null;
            } else {
                //this.device.Project_Name__c = this.device.Project_Name__c + ' - ' + this.device.Name;
                if ((this.device.Project_Name__c == null || this.device.Project_Name__c.trim() == '') && (this.mode == null || this.mode.trim() == '')) {
                    this.device.Project_Name__c = this.opportunityName + this.device.Name;
                }
        //changes made for copy configurator
          this.device.Configuration_Status__c = NULL;    
                this.device.Configuration__c = NULL;
                this.device.Is_CDSCreated__c = false;
                this.device.CDS_Number__c = NULL;
                
                insert this.device;
                
                // Clone records
                // Tlai 03042014 added condition for device revise
        String callMode = null;
                if (String.isBlank(this.mode) || this.mode == Environment_Variable__c.getInstance('DEVICE_REVISION').Value__c) {
                    callMode = 'COPY';    
                    if(this.mode == Environment_Variable__c.getInstance('DEVICE_REVISION').Value__c) {    
            callMode = 'REVISE';    
                    }
          // Clone BX041 records
                    // Device Copy
                    /*List<Device__c> pListDevice = new List<Device__c>();
                    pListDevice.add(this.device);
                    
                    BX041Clone bx41 = new BX041Clone();
                    bx41.cloneBX041Method(pListDevice);*/
                    
                    // ZAmbat 05152014
                    Set<Id> setDeviceId = new Set<Id>();
                    setDeviceId.add(this.device.Id);
                    BX041Clone.cloneBX041Method(setDeviceId);
          //NPCCopyConfigurationController.prepareDataForClone(deviceId,device.Id,callMode,NULL);
          NPCCopyConfigurationController.getNPCPageContent(deviceId,device.Id,callMode,'NULL');
                }
                
                pageRef = new PageReference('/' + this.device.Id);
                pageRef.setRedirect(true);
            }
        } Catch (Exception e) {
            Error_Codes__c deviceIdValidation = Error_Codes__c.getInstance('DEVICE_ID_VALIDATION');
            Error_Codes__c processFamilyValidation = Error_Codes__c.getInstance('PROCESS_FAMILY_IS_EMPTY');
            Error_Codes__c geometryValidation = Error_Codes__c.getInstance('GEOMETRY_IS_EMPTY');
            if (e.getMessage().indexOf('DUPLICATE_VALUE') > -1) {
                Error_Codes__c ec = Error_Codes__c.getInstance('DEVICE_ID_ALREADY_EXIST');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ec.Message__c));
                system.debug('Error ===========> ' + e.getMessage());
            } else if (e.getMessage().indexOf(deviceIdValidation.Message__c) > -1) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, deviceIdValidation.Message__c));
                system.debug('Error ===========> ' + e.getMessage());
            } else if (e.getMessage().indexOf(processFamilyValidation.Message__c) > -1) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, processFamilyValidation.Message__c));
                system.debug('Error ===========> ' + e.getMessage());
            } else if (e.getMessage().indexOf(geometryValidation.Message__c) > -1) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, geometryValidation.Message__c));
                system.debug('Error ===========> ' + e.getMessage());
            } else {
                Error_Codes__c ec = Error_Codes__c.getInstance('SAVE_UNSUCCESSFUL1');
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ec.Message__c));
                system.debug('Error ===========> ' + e.getMessage());
            }
        }
        
        return pageRef;
    }
    
}