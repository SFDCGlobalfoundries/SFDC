/*
    Author: Nino Bustillos
    Description: This webservice allows insert/update of device information for Retrofitted/Revisioned devices from Siebel.
    History: 
        Nbustillos  02142013    - Code creation of skeleton service.
        Nbustillos  02212013    - Changed parameter type as we are already hitting the max limit of parameters (32).
        Nbustillos  02222013    - Updated parameter values.
        ZAmbat      02252013    - Updated newDevice and updateDevice methods.
        Nbustillos  03062013    - Remove some validations in newDevice method.
        Nbustillos  03152013    - Added new property dtForecastedLotStartDate in DeviceUpdateStruct class wrapper for updateDevice method.
        Asolito     06112013    - Added PLM integration method 
        ZAmbat      06192013    - Added PTRF integration method.
        Nbustillos  08282013    - Added additional parameter iNoOfPrimeDie on PTRFtStruct.
        Nbustillos  09122013    - Added logic to force send device update for integration via Send_for_Integration__c for PLM interface.
        Asolito     09132013    - Added validation to check if data coming from PLM has no Stage
        Nbustillos  11072013  - Updated logic for populateDeviceFields to update stage based on PLM value if device stage = 'Design In'   
        Vijay       22072914    - Updated device PTRF query criteria in PLMUpdate method and now Device Fab will not be updated in PLMUpdate method as per business requirement Swift Gen Phase 1
        Vijay       19082014    - Single Product and Customer MPW device should consider as a Tapeout when first 3 Mask Layer are shipped out
                                  External Retrofit Device should move to next stage when Proto Lot Start ID is populated 
                                  If there is no PTRF in Device and Proto Lot Start ID is null, Device Stage won't be updated.
        Vijay       03112015    - added TD Test Chip Tapeout Type check in populateDeviceFields method to support TD Test Chip Internal Device
*/
global class DeviceService {            
    
    /* commented by Baij on 20/06/2015
    webservice static DeviceService.PTRFReturnMessage upsertPTRFForDevice(DeviceService.PTRFtStruct objPTRFtStruct) {
        return PTRFService.upsertPTRF(objPTRFtStruct);
    }*/
    
    webservice static DeviceService.DeviceReturnMessage PLMUpdate(DevicePLMUpdateStruct rec){
        //rec values
        System.debug('<========== PLMDeviceUpdate ==========>');
        System.debug('sCRMDID ===============> ' + rec.sCRMDID);
        System.debug('sMaskSetTitle ===============> ' + rec.sMaskSetTitle);
        System.debug('sSTFProcessID ===============> ' + rec.sSTFProcessID);
        System.debug('sPLMDeviceID ===============> ' + rec.sPLMDeviceID);
        System.debug('sDeviceStage ===============> ' + rec.sDeviceStage);
        System.debug('sFab ===============> ' + rec.sFab);
        System.debug('dLifeCycleChangeDate ===============> ' + rec.dLifeCycleChangeDate);
        
        // Init
        DeviceService.DeviceReturnMessage retVal;
        Error_Codes__c errorCode;
        
        if(UtilsString.isNotBlank(rec.sDeviceStage)){                      
            
            List<Device__c> updateDevices = new List<Device__c>();
            if(UtilsString.isNotBlank(rec.sCRMDID)){
                for(Device__c d: [SELECT PLM_device_ID__c,stage__c,fab__c,STF_process_ID__c,prototype_date__c,RTR_date__c,production_date__c,
                                         EOL_date__c,actual_tapeout_date__c, Actual_Tapeout_Date_GMT__c, Tapeout_Type__c, Proto_Lot_Start_ID__c,
                                         (SELECT    Id,transaction_date__c 
                                          FROM      PTRF__r
                                          WHERE     (frame_tapeout__c = true OR Prime_Tapeout__c = true)
                                                    AND     (Status__c != 'Open' AND Status__c != 'Cancel') ORDER BY transaction_date__c DESC
                                                    LIMIT 1)
                                    FROM Device__c
                                    WHERE CRMDID__c = :rec.sCRMDID]){
                    system.debug('Device_PTRF:'+d);                                 
                    updateDevices.add(populateDeviceFields(d,rec,true));                                                                    
                }   
                                           
            } else {
                for(Device__c d: [SELECT PLM_device_ID__c,stage__c,fab__c,STF_process_ID__c,prototype_date__c,RTR_date__c,production_date__c,
                                         EOL_date__c,actual_tapeout_date__c, Actual_Tapeout_Date_GMT__c
                                    FROM Device__c
                                    WHERE device_mask_set_title__c = :rec.sMaskSetTitle
                                    AND stage__c <> 'Design In']){
                                        
                    updateDevices.add(populateDeviceFields(d,rec,false));                                       
                }   
            }
            
            //no device found
            if (updateDevices.size() <= 0) {
                errorCode = Error_Codes__c.getInstance('DEVICE_NOT_FOUND');
                retVal = new DeviceService.DeviceReturnMessage(rec.sCRMDID, rec.sMaskSetTitle , errorCode.Name, errorCode.Message__c);
                system.debug('retVal:'+retVal);
                return retVal;
            }
            
            try {
                update updateDevices;
                retVal = new DeviceService.DeviceReturnMessage(updateDevices[0].Id, updateDevices[0].PLM_Device_ID__c, null, null);
            } catch (Exception e) {
                retVal = new DeviceService.DeviceReturnMessage(rec.sCRMDID, rec.sPLMDeviceID , e.getTypeName(), e.getMessage());
                system.debug('Error =========> ' + e.getMessage());
            }
        //No device stage exception         
        } else {
            errorCode = Error_Codes__c.getInstance('DEVICE_STAGE_BLANK');
            retVal = new DeviceService.DeviceReturnMessage(rec.sCRMDID, rec.sMaskSetTitle , errorCode.Name, errorCode.Message__c);
            system.debug('retVal:'+retVal);
            return retVal;                  
        }
        system.debug('retVal:'+retVal);
        return retVal;
    }
    
    //Method will set the Device fields values based on callout data
    private static Device__c populateDeviceFields(Device__c d,DevicePLMUpdateStruct rec,Boolean hasCRMDID){
        //If Device has CRMDID
        if(hasCRMDID){
            System.debug('---------------In hasCRMDID Deivce Details--------------'+ d);
            System.debug('---------------In hasCRMDID PLMUpdate Details--------------'+ rec);
            if(d.stage__c == 'Design In'){
                List<PTRF__c> options = d.PTRF__r;
                System.debug('---------------In Design In --------------'+options);
                Boolean isExists = false;
                if(options != null && !options.isEmpty()){
                    if(d.Tapeout_Type__c == 'Single Product' || d.Tapeout_Type__c == 'Customer MPW' || d.Tapeout_Type__c == 'TD Test Chip'){
                        System.debug('---------------In Single Product/Customer MPW--------------');
                        List<Mask_Layer__c> maskLayerList = [SELECT Id, Mask_Layer_Number__c, Mask_Set_Title__r.Name, Mask_Layer_Rev__c, Sort_Order__c, ROM_Code__c
                                                             FROM   Mask_Layer__c
                                                             WHERE  PTRF__c =:options AND Mask_Set_Title__r.Name =:rec.sMaskSetTitle AND Sort_Order__c <= 3];
                        if(maskLayerList != null && !maskLayerList.isEmpty()){
                            System.debug('---------------In maskLayerList --------------'+maskLayerList);
                            for(Mask_Layer__c maskLayer:maskLayerList){
                                System.debug('--- maskLayer.Mask_Layer_Number__c---'+ maskLayer.Mask_Layer_Number__c);
                                System.debug('--- maskLayer.Mask_Layer_Rev__c---'+ maskLayer.Mask_Layer_Rev__c);
                                System.debug('--- maskLayer.ROM_Code__c---'+ maskLayer.ROM_Code__c);
                                System.debug('---  maskLayer.Mask_Set_Title__r.Name---'+  maskLayer.Mask_Set_Title__r.Name);
                                 List<MRS_Layer_Association__c> mrsLayerAssociationlist = [SELECT   Id FROM MRS_Layer_Association__c
                                                                                           WHERE    Layer_Status__c =: 'Shipped' 
                                                                                                    AND Name = : maskLayer.Mask_Layer_Number__c
                                                                                                    AND Mask_Layer_Rev__c =: maskLayer.Mask_Layer_Rev__c
                                                                                                    AND ROM_Code__c =: maskLayer.ROM_Code__c
                                                                                                    AND Mask_Set_Title_Name__c =: maskLayer.Mask_Set_Title__r.Name];
                                if(!mrsLayerAssociationlist.isEmpty()){
                                    System.debug('---------------In mrsLayerAssociationlist--------------'+mrsLayerAssociationlist);
                                    isExists = true;
                                    break;
                                }                                                 
                            }
                        }
                    }else{
                        System.debug('---------------Not In Single Product/Customer MPW----Else Part----------');
                        isExists = true;
                    }
                    if(isExists){
                        System.debug('---------------In isExists--------------');
                        d.stage__c = 'Tapeout';
                        for(PTRF__c o: options){
                            system.debug('>>>here');
                            if(UtilsString.isNotBlank(o.transaction_date__c)){system.debug('>>>here');
                                d.actual_tapeout_date__c = Datetime.newInstance(o.transaction_date__c.year(),
                                                                                o.transaction_date__c.month(),
                                                                                o.transaction_date__c.day()); 
                                d.Actual_Tapeout_Date_GMT__c = Date.newInstance(o.transaction_date__c.year(),
                                                                                o.transaction_date__c.month(),
                                                                                o.transaction_date__c.day());
                            }else{
                                d.actual_tapeout_date__c = date.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
                                d.Actual_Tapeout_Date_GMT__c = date.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
                            }
                        }
                        // Added by Nbustillos 11062013. As per requested Device should not skip a stage and its needed on the history
                        update d; 
                        
                        d.stage__c = rec.sDeviceStage;
                        
                        d.PLM_device_ID__c = rec.sPLMDeviceID;
                        //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
                        d.STF_Process_ID__c = rec.sSTFProcessID;
                        d.Send_for_Integration__c = true;
                    }else{
                        System.debug('---------------In Not exists---Else part-----------');
                        d.PLM_device_ID__c = rec.sPLMDeviceID;
                        //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
                        d.STF_Process_ID__c = rec.sSTFProcessID;
                        d.Send_for_Integration__c = true;
                    }
                }else{
                    if(d.Proto_Lot_Start_ID__c != null){
                        System.debug('---------------In Proto_Lot_Start_ID__c Not Null--------------');
                        d.stage__c = rec.sDeviceStage;
                        d.PLM_device_ID__c = rec.sPLMDeviceID;
                        //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
                        d.STF_Process_ID__c = rec.sSTFProcessID;
                        d.Send_for_Integration__c = true;
                    }else{
                        System.debug('---------------In Proto_Lot_Start_ID__c Null---Else part-----------');
                        d.PLM_device_ID__c = rec.sPLMDeviceID;
                        //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
                        d.STF_Process_ID__c = rec.sSTFProcessID;
                        d.Send_for_Integration__c = true;
                    }
                }
            } else {  
                System.debug('---------------In Not Design In--------------');
                d.stage__c = rec.sDeviceStage;
                d.PLM_device_ID__c = rec.sPLMDeviceID;
                //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
                d.STF_Process_ID__c = rec.sSTFProcessID;                    
            }                                   
        } else {
            System.debug('---------------In Not hasCRMDID Deivce Details--------------'+ d);
            System.debug('---------------In Not hasCRMDID PLMUpdate Details--------------'+ rec);
            d.stage__c = rec.sDeviceStage;
            //d.fab__c = rec.sFab; removed PLM update as per Business requirement along with Swift Gen Phase 1
            d.STF_Process_ID__c = rec.sSTFProcessID;            
        }               
                
        //set the stage date based on the device stage  
        if(rec.sDeviceStage == 'Prototype' && !UtilsString.isNotBlank(d.prototype_date__c)){
            System.debug('-------In PrototType Null---------');
            d.prototype_date__c = rec.dLifeCycleChangeDate;
        } else if(rec.sDeviceStage == 'RTR' && !UtilsString.isNotBlank(d.RTR_date__c)){
            d.RTR_date__c = rec.dLifeCycleChangeDate;
        } else if(rec.sDeviceStage == 'Production' && !UtilsString.isNotBlank(d.production_date__c)){
            d.production_date__c = rec.dLifeCycleChangeDate;
        }  else if(rec.sDeviceStage == 'EOL' && !UtilsString.isNotBlank(d.EOL_date__c)){
            d.EOL_date__c = rec.dLifeCycleChangeDate;
        }           
        
        return d;
    } 
    
    webservice static DeviceService.DeviceReturnMessage newDevice(DeviceInsertStruct objDeviceInsertMsg) {
        // objDeviceInsertMsg values
        System.debug('<========== newDevice ==========>');
        System.debug('sSiebelDeviceID ===============> ' + objDeviceInsertMsg.sSiebelDeviceID);
        System.debug('sCRMDID ===============> ' + objDeviceInsertMsg.sCRMDID);
        System.debug('sDeviceID ===============> ' + objDeviceInsertMsg.sDeviceID);
        System.debug('sSiebelAccountID ===============> ' + objDeviceInsertMsg.sSiebelAccountID);
        System.debug('sExportCntrlStatus ===============> ' + objDeviceInsertMsg.sExportCntrlStatus);
        System.debug('sIPDeclarationStatus ===============> ' + objDeviceInsertMsg.sIPDeclarationStatus);
        System.debug('sBX041Status ===============> ' + objDeviceInsertMsg.sBX041Status);
        System.debug('sSTFProcessID ===============> ' + objDeviceInsertMsg.sSTFProcessID);
        System.debug('sPLMDeviceID ===============> ' + objDeviceInsertMsg.sPLMDeviceID);
        System.debug('sSiebelOptyID ===============> ' + objDeviceInsertMsg.sSiebelOptyID);
        System.debug('sTapeoutType ===============> ' + objDeviceInsertMsg.sTapeoutType);
        System.debug('dtActualTapeoutDate ===============> ' + objDeviceInsertMsg.dtActualTapeoutDate);
        System.debug('sGSOPAssignmentTapeoutPlan ===============> ' + objDeviceInsertMsg.sGSOPAssignmentTapeoutPlan);
        System.debug('sFab ===============> ' + objDeviceInsertMsg.sFab);
        System.debug('sStage ===============> ' + objDeviceInsertMsg.sStage);
        System.debug('sStatus ===============> ' + objDeviceInsertMsg.sStatus);
        System.debug('sMarketSegment ===============> ' + objDeviceInsertMsg.sMarketSegment);
        System.debug('sEndApplication ===============> ' + objDeviceInsertMsg.sEndApplication);
        System.debug('sSemiConductorDevice ===============> ' + objDeviceInsertMsg.sSemiConductorDevice);
        System.debug('sEndCustomer ===============> ' + objDeviceInsertMsg.sEndCustomer);
        System.debug('sDeviceSourcing ===============> ' + objDeviceInsertMsg.sDeviceSourcing);
        System.debug('sDeviceDesc ===============> ' + objDeviceInsertMsg.sDeviceDesc);
        System.debug('dtOriginalTapeoutDate ===============> ' + objDeviceInsertMsg.dtOriginalTapeoutDate);
        System.debug('dtCurrentTapeoutDate ===============> ' + objDeviceInsertMsg.dtCurrentTapeoutDate);
        System.debug('sConfidenceLvlTapeout ===============> ' + objDeviceInsertMsg.sConfidenceLvlTapeout);
        System.debug('sConfidenceLvlVolume ===============> ' + objDeviceInsertMsg.sConfidenceLvlVolume);
        System.debug('sBaseCRMDID ===============> ' + objDeviceInsertMsg.sBaseCRMDID);
        System.debug('sPrePTRFValidationStatus ===============> ' + objDeviceInsertMsg.sPrePTRFValidationStatus);
        System.debug('sD1NatlAccessAllowed ===============> ' + objDeviceInsertMsg.sD1NatlAccessAllowed);
        System.debug('sDevicePurpose ===============> ' + objDeviceInsertMsg.sDevicePurpose);
        System.debug('dtForecastedLotStartDate ===============> ' + objDeviceInsertMsg.dtForecastedLotStartDate);
        System.debug('sDeviceType ===============> ' + objDeviceInsertMsg.sDeviceType);
        
        // Init
        DeviceService.DeviceReturnMessage retVal;
        Error_Codes__c errorCode;
        
        // Check for required fields
        // Device Id
        if (objDeviceInsertMsg.sDeviceID == NULL || objDeviceInsertMsg.sDeviceID.trim() == '') {
            errorCode = Error_Codes__c.getInstance('DEVICE_ID_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // Market Segment
        } /*else if (objDeviceInsertMsg.sMarketSegment == NULL || objDeviceInsertMsg.sMarketSegment.trim() == '') {
            errorCode = Error_Codes__c.getInstance('MARKET_SEGMENT_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // Semiconductor Device
        } else if (objDeviceInsertMsg.sSemiConductorDevice == NULL || objDeviceInsertMsg.sSemiConductorDevice.trim() == '') {
            errorCode = Error_Codes__c.getInstance('SEMICONDUCTOR_DEVICE_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // End Application
        } else if (objDeviceInsertMsg.sEndApplication == NULL || objDeviceInsertMsg.sEndApplication.trim() == '') {
            errorCode = Error_Codes__c.getInstance('END_APPLICATION_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // Device Sourcing
        } else if (objDeviceInsertMsg.sDeviceSourcing == NULL || objDeviceInsertMsg.sDeviceSourcing.trim() == '') {
            errorCode = Error_Codes__c.getInstance('DEVICE_SOURCING_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
            
        // CRMDID
        }*/ else if (objDeviceInsertMsg.sCRMDID == NULL || objDeviceInsertMsg.sCRMDID.trim() == '') {
            errorCode = Error_Codes__c.getInstance('CRMDID_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
            
        // Stage
        } else if (objDeviceInsertMsg.sStage == NULL || objDeviceInsertMsg.sStage.trim() == '') {
            errorCode = Error_Codes__c.getInstance('STAGE_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // Status
        } else if (objDeviceInsertMsg.sStatus == NULL || objDeviceInsertMsg.sStatus.trim() == '') {
            errorCode = Error_Codes__c.getInstance('STATUS_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        
        // Tapeout Type
        } /*else if (objDeviceInsertMsg.sTapeoutType == NULL || objDeviceInsertMsg.sTapeoutType.trim() == '') {
            errorCode = Error_Codes__c.getInstance('TAPEOUT_TYPE_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
            
        // Siebel Account Id
        } */else if (objDeviceInsertMsg.sSiebelAccountID == NULL || objDeviceInsertMsg.sSiebelAccountID.trim() == '') {
            errorCode = Error_Codes__c.getInstance('SIEBEL_ACCOUNT_ID_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
            
        // Siebel Opportunity Id
        } else if (objDeviceInsertMsg.sSiebelOptyID == NULL || objDeviceInsertMsg.sSiebelOptyID.trim() == '') {
            errorCode = Error_Codes__c.getInstance('SIEBEL_OPPORTUNITY_ID_IS_EMPTY');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        }
        
        // Account
        List<Account> tempAccount = [
            SELECT      Id
            FROM        Account
            WHERE       Siebel_Account_ID__c = :objDeviceInsertMsg.sSiebelAccountID
        ];
        
        if (tempAccount.size() <= 0) {
            errorCode = Error_Codes__c.getInstance('SIEBEL_ACCOUNT_ID_IS_INVALID');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        }
        
        // Opportunity Program
        List<Opportunity_Program__c> tempOpptyProgram = [
            SELECT      Id
            FROM        Opportunity_Program__c
            WHERE       Opportunity__r.Siebel_Opportunity_ID__c = :objDeviceInsertMsg.sSiebelOptyID
        ];
        
        if (tempOpptyProgram.size() <= 0) {
            errorCode = Error_Codes__c.getInstance('SIEBEL_OPPORTUNITY_ID_IS_INVALID');
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        }
        
        // Check and validate CRMDID format
        if (objDeviceInsertMsg.sCRMDID.left(4) == 'CDID') {
            if (objDeviceInsertMsg.sCRMDID.mid(4, 7).isNumeric()) {
                /*integer latestCRMDID = Integer.valueOf(CRMDID__c.getInstance('CRMDID_No').CRMDID_No__c);
                if (Integer.valueOf(objDeviceInsertMsg.sCRMDID.mid(4, 7)) < latestCRMDID) {
                    errorCode = Error_Codes__c.getInstance('CRMDID_IS_INVALID');
                    retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
                    
                    return retVal;
                }*/
            } else {
                errorCode = Error_Codes__c.getInstance('CRMDID_IS_INVALID');
                retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
                
                return retVal;
            }
        }
        
        // Save New Device
        Device__c device = new Device__c();
        device.Name = objDeviceInsertMsg.sDeviceID;
        device.Account__c = tempAccount[0].Id;
        device.Actual_Tapeout_Date__c = objDeviceInsertMsg.dtActualTapeoutDate;
        device.BX041_Status__c = objDeviceInsertMsg.sBX041Status;
        device.Confidence_Level_Tapeout__c = objDeviceInsertMsg.sConfidenceLvlTapeout;
        device.Confidence_Level_Volume__c = objDeviceInsertMsg.sConfidenceLvlVolume;
        device.CRMDID__c = objDeviceInsertMsg.sCRMDID;
        device.Current_Forecast_Tapeout_Date__c = objDeviceInsertMsg.dtCurrentTapeoutDate;
        device.D1_National_Access_Allowed__c = objDeviceInsertMsg.sD1NatlAccessAllowed;
        device.Device_Description__c = objDeviceInsertMsg.sDeviceDesc;
        device.Device_ID__c = objDeviceInsertMsg.sDeviceID;
        device.Device_Purpose__c = objDeviceInsertMsg.sDevicePurpose;
        device.Device_Sourcing__c = objDeviceInsertMsg.sDeviceSourcing;
        device.Device_Type__c = objDeviceInsertMsg.sDeviceType;
        device.End_Application__c = objDeviceInsertMsg.sEndApplication;
        device.End_Customer__c = objDeviceInsertMsg.sEndCustomer;
        device.Export_Control_Status__c = objDeviceInsertMsg.sExportCntrlStatus;
        device.Fab__c = objDeviceInsertMsg.sFab;
        device.Forecasted_Lot_Start_Date__c = objDeviceInsertMsg.dtForecastedLotStartDate;
        device.GSOP_Assignment_Tapeout_Plan__c = objDeviceInsertMsg.sGSOPAssignmentTapeoutPlan;
        device.IP_Declaration_Status__c = objDeviceInsertMsg.sIPDeclarationStatus;
        device.Market_Segment__c = objDeviceInsertMsg.sMarketSegment;
        device.Opportunity_Program__c = tempOpptyProgram[0].Id;
        device.Original_Forecasted_Tapeout_Date__c = objDeviceInsertMsg.dtOriginalTapeoutDate;
        device.PLM_Device_ID__c = objDeviceInsertMsg.sPLMDeviceID;
        device.Pre_PTRF_Validation_Status__c = objDeviceInsertMsg.sPrePTRFValidationStatus;
        device.Semiconductor_Device__c = objDeviceInsertMsg.sSemiConductorDevice;
        device.Siebel_Device_ID__c = objDeviceInsertMsg.sSiebelDeviceID;
        device.Stage__c = objDeviceInsertMsg.sStage;
        device.Status__c = objDeviceInsertMsg.sStatus;
        device.STF_Process_ID__c = objDeviceInsertMsg.sSTFProcessID;
        device.Tapeout_Type__c = objDeviceInsertMsg.sTapeoutType;
        
        if (objDeviceInsertMsg.sDeviceType == 'Base') {
            device.Revision__c = '00';
        } else if (objDeviceInsertMsg.sDeviceType == 'Revision' || objDeviceInsertMsg.sDeviceType == 'Retrofit') {
            // Get Base Device
            string baseDevice = '';
            if (objDeviceInsertMsg.sCRMDID.left(4) == 'CDID') {
                baseDevice = objDeviceInsertMsg.sCRMDID.left(11) + '.00';
            } else {
                baseDevice = objDeviceInsertMsg.sCRMDID.left(8) + '.00';
            }
            
            List<Device__c> tempDevice = [
                SELECT      Id
                FROM        Device__c
                WHERE       CRMDID__c = :baseDevice
            ];
            
            if (tempDevice.size() == 1) {
                device.Base_Device__c = tempDevice[0].Id;
            }
            
            // Revision
            device.Revision__c = objDeviceInsertMsg.sCRMDID.right(2);
        }
        
        Try {
            Insert device;
            retVal = new DeviceService.DeviceReturnMessage(device.Id, device.CRMDID__c, null, null);
        } Catch (Exception e) {
            retVal = new DeviceService.DeviceReturnMessage(objDeviceInsertMsg.sDeviceID, objDeviceInsertMsg.sCRMDID, e.getTypeName(), e.getMessage());
            system.debug('Error =========> ' + e.getMessage());
        }
        
        return retVal;
    }
        
    webservice static DeviceService.DeviceReturnMessage updateDevice(DeviceUpdateStruct objUpdateMsg) {
        // objUpdateMsg values
        System.debug('<========== updateDevice ==========>');
        System.debug('sSiebelDeviceID ===============> ' + objUpdateMsg.sSiebelDeviceID);
        System.debug('sCRMDID ===============> ' + objUpdateMsg.sCRMDID);
        System.debug('sDeviceID ===============> ' + objUpdateMsg.sDeviceID);
        System.debug('sExportCntrlStatus ===============> ' + objUpdateMsg.sExportCntrlStatus);
        System.debug('sIPDeclarationStatus ===============> ' + objUpdateMsg.sIPDeclarationStatus);
        System.debug('sBX041Status ===============> ' + objUpdateMsg.sBX041Status);
        System.debug('sSTFProcessID ===============> ' + objUpdateMsg.sSTFProcessID);
        System.debug('sPLMDeviceID ===============> ' + objUpdateMsg.sPLMDeviceID);
        System.debug('sPrePTRFValidationStatus ===============> ' + objUpdateMsg.sPrePTRFValidationStatus);
        System.debug('sD1NatlAccessAllowed ===============> ' + objUpdateMsg.sD1NatlAccessAllowed);
        System.debug('sTapeoutType ===============> ' + objUpdateMsg.sTapeoutType);
        System.debug('dtActualTapeoutDate ===============> ' + objUpdateMsg.dtActualTapeoutDate);
        System.debug('sStage ===============> ' + objUpdateMsg.sStage);
        System.debug('sStatus ===============> ' + objUpdateMsg.sStatus);
        System.debug('dPrototypeDate ===============> ' + objUpdateMsg.dPrototypeDate);
        System.debug('dRTRDate ===============> ' + objUpdateMsg.dRTRDate);
        System.debug('dProdDate ===============> ' + objUpdateMsg.dProdDate);
        System.debug('dEOLDate ===============> ' + objUpdateMsg.dEOLDate);
         System.debug('dtForecastedLotStartDate ===============> ' + objUpdateMsg.dtForecastedLotStartDate);
        // Init
        DeviceService.DeviceReturnMessage retVal;
        /*Error_Codes__c errorCode;
        
        // Validate CRMDID
        List<Device__c> tempDevice = [
            SELECT      Id
                        , Name
                        , Siebel_Device_ID__c
                        , CRMDID__c
                        , Device_ID__c
                        , Export_Control_Status__c
                        , IP_Declaration_Status__c
                        , BX041_Status__c
                        , STF_Process_ID__c
                        , PLM_Device_ID__c
                        , Pre_PTRF_Validation_Status__c
                        , D1_National_Access_Allowed__c
                        , Tapeout_Type__c
                        , Actual_Tapeout_Date__c
                        , Stage__c
                        , Status__c
                        , Prototype_Date__c
                        , RTR_Date__c
                        , Production_Date__c
                        , EOL_Date__c
                        , Forecasted_Lot_Start_Date__c
            FROM        Device__c
            WHERE       CRMDID__c = :objUpdateMsg.sCRMDID
        ];
        
        if (tempDevice.size() <= 0) {
            errorCode = Error_Codes__c.getInstance('CRMDID_IS_INVALID');
            retVal = new DeviceService.DeviceReturnMessage(objUpdateMsg.sDeviceID, objUpdateMsg.sCRMDID, errorCode.Name, errorCode.Message__c);
            
            return retVal;
        }
        
        // Update Device
        tempDevice[0].Name = objUpdateMsg.sDeviceID;
        tempDevice[0].Siebel_Device_ID__c = objUpdateMsg.sSiebelDeviceID;
        tempDevice[0].CRMDID__c = objUpdateMsg.sCRMDID;
        tempDevice[0].Device_ID__c = objUpdateMsg.sDeviceID;
        tempDevice[0].Export_Control_Status__c = objUpdateMsg.sExportCntrlStatus;
        tempDevice[0].IP_Declaration_Status__c = objUpdateMsg.sIPDeclarationStatus;
        tempDevice[0].BX041_Status__c = objUpdateMsg.sBX041Status;
        tempDevice[0].STF_Process_ID__c = objUpdateMsg.sSTFProcessID;
        tempDevice[0].PLM_Device_ID__c = objUpdateMsg.sPLMDeviceID;
        tempDevice[0].Pre_PTRF_Validation_Status__c = objUpdateMsg.sPrePTRFValidationStatus;
        tempDevice[0].D1_National_Access_Allowed__c = objUpdateMsg.sD1NatlAccessAllowed;
        tempDevice[0].Tapeout_Type__c = objUpdateMsg.sTapeoutType;
        tempDevice[0].Actual_Tapeout_Date__c = objUpdateMsg.dtActualTapeoutDate;
        tempDevice[0].Stage__c = objUpdateMsg.sStage;
        tempDevice[0].Status__c = objUpdateMsg.sStatus;
        tempDevice[0].Prototype_Date__c = objUpdateMsg.dPrototypeDate;
        tempDevice[0].RTR_Date__c = objUpdateMsg.dRTRDate;
        tempDevice[0].Production_Date__c = objUpdateMsg.dProdDate;
        tempDevice[0].EOL_Date__c = objUpdateMsg.dEOLDate;
        tempDevice[0].Forecasted_Lot_Start_Date__c = objUpdateMsg.dtForecastedLotStartDate;
        
        Try {
            Update tempDevice;
            retVal = new DeviceService.DeviceReturnMessage(tempDevice[0].Id, tempDevice[0].CRMDID__c, null, null);
        } Catch (Exception e) {
            retVal = new DeviceService.DeviceReturnMessage(objUpdateMsg.sDeviceID, objUpdateMsg.sCRMDID, e.getTypeName(), e.getMessage());
            system.debug('Error =========> ' + e.getMessage());
        }
        */
        return retVal;
    }
    
    /* PLM Device update struct */
    global class DevicePLMUpdateStruct {
        webservice String sCRMDID;
        webservice String sMaskSetTitle;
        webservice String sSTFProcessID;
        webservice String sPLMDeviceID;
        webservice String sDeviceStage;
        webservice String sFab;
        webservice Date dLifeCycleChangeDate;
    }
    
    
    /* return struct */
    global class DeviceReturnMessage {
        // device info
        webservice string deviceid;
        webservice string devicecrmdid;
        
        // error info
        webservice string errorcode;
        webservice string errormsg;
        
        public DeviceReturnMessage(string deviceid, string devicecrmdid, string errorcode, string errormsg){
            this.deviceid = deviceid;
            this.devicecrmdid = devicecrmdid;
            this.errorcode = errorcode;
            this.errormsg = errormsg;
        }
    }
    
    /* insert struct */
    global class DeviceInsertStruct {
        webservice string sSiebelDeviceID;
        webservice string sCRMDID;
        webservice string sDeviceID;
        webservice string sSiebelAccountID;
        webservice string sExportCntrlStatus;
        webservice string sIPDeclarationStatus;
        webservice string sBX041Status;
        webservice string sSTFProcessID;
        webservice string sPLMDeviceID;
        webservice string sSiebelOptyID;
        webservice string sTapeoutType;
        webservice datetime dtActualTapeoutDate;
        webservice string sGSOPAssignmentTapeoutPlan;
        webservice string sFab;
        webservice string sStage;
        webservice string sStatus;
        webservice string sMarketSegment;
        webservice string sEndApplication;
        webservice string sSemiConductorDevice;
        webservice string sEndCustomer;
        webservice string sDeviceSourcing;
        webservice string sDeviceDesc;
        webservice date dtOriginalTapeoutDate;
        webservice date dtCurrentTapeoutDate;
        webservice string sConfidenceLvlTapeout;
        webservice string sConfidenceLvlVolume;
        webservice string sBaseCRMDID;
        webservice string sPrePTRFValidationStatus;
        webservice string sD1NatlAccessAllowed;
        webservice string sDevicePurpose;
        webservice date dtForecastedLotStartDate;
        webservice string sDeviceType;
    }
    
    /* update struct */
    global class DeviceUpdateStruct {
        webservice string sSiebelDeviceID;
        webservice string sCRMDID;
        webservice string sDeviceID;
        webservice string sExportCntrlStatus;
        webservice string sIPDeclarationStatus;
        webservice string sBX041Status;
        webservice string sSTFProcessID;
        webservice string sPLMDeviceID;
        webservice string sPrePTRFValidationStatus;
        webservice string sD1NatlAccessAllowed;
        webservice string sTapeoutType; 
        webservice datetime dtActualTapeoutDate;
        webservice string sStage;
        webservice string sStatus;
        webservice date dPrototypeDate;
        webservice date dRTRDate;
        webservice date dProdDate;
        webservice date dEOLDate;
        webservice date dtForecastedLotStartDate;
    }
    
    // Class structure for Return Message   
    global class PTRFReturnMessage {
        webservice string crmdid;
        webservice string ptrfNumber;
        webservice string errorCode;
        webservice string errorMessage;
        
        global PTRFReturnMessage (string crmdid, string ptrfNumber, string errorCode, string errorMessage) {
            this.crmdid = crmdid;
            this.ptrfNumber = ptrfNumber;
            this.errorCode = errorCode;
            this.errorMessage = errorMessage;
        }
    }
    
    // Class structure for PTRF
    global class PTRFtStruct {
        webservice string sCRMDID;
        webservice string sBaseCRMDID;
        webservice string sPTRFNumber;
        webservice string sTransactionType;
        webservice string sDeviceId;
        webservice string sMaskSetTitle;
        webservice string sProcessId;
        webservice date dTransactionDate;
        webservice string sAccountShortName;
        webservice string sOrderType;
        webservice string sFrameTapeout;
        webservice string sPrimeTapeout;
        webservice string sDRCOnly;
        webservice string sPrimeGDSOUTReview;
        webservice string sFrameMockup;
        webservice string sHyperlinkToSwift;
        webservice integer iNoOfPrimeDie;    
    }
}