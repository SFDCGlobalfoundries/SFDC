/*
    Author: Zymark Ambat
    Description: This Class sets the Device's Current Forecast Tapeout Date based on the MPW Train selected.
    History: 
        ZAmbat      07312014    - Code creation.
        Vijay       01282015    - updated the business logic to support the Internal Device functionality
        Vijay       04142015    - added the validation for Device Id format When the MPW Train Number is populated with the Device Id Name should be start with MPW Train
                                    Number followed by Prime Die Name
*/ 

public class DeviceMPWForecastedTapeoutDate {
    public static void retrieveTapeoutDate(List<Device__c> listDevices) {
        Set<Id> mpwIds = new Set<Id>();
        Set<Id> opIds = new Set<Id>(); 
        for (Device__c d : listDevices) {
            if (d.MPW_Train_Number__c != null) {
                mpwIds.add(d.MPW_Train_Number__c);
                if(d.Opportunity_Program__c != null){
                    opIds.add(d.Opportunity_Program__c);
                }
            }
        }
        
        Map<Id, Id> mapAcctRecordType = new Map<Id, Id>();
        if(opIds != null && !opIds.isEmpty()){
            for (Opportunity_Program__c o : [SELECT     Id
                                                        , Account__r.RecordTypeId
                                             FROM       Opportunity_Program__c
                                             WHERE      Id IN :opIds]) {
                mapAcctRecordType.put(o.Id, o.Account__r.RecordTypeId);
            }
        }
        
        Map<Id, MPW_Train_Maintenance__c> mapMPW = null;
        if(mpwIds != null && !mpwIds.isEmpty()){
            mapMPW = new Map<Id, MPW_Train_Maintenance__c>([SELECT    Id
                                                                      , Name
                                                                      , Customer_Tapeout_Date__c
                                                                      , Other_Tapeout_Date__c
                                                            FROM      MPW_Train_Maintenance__c
                                                            WHERE     Id IN :mpwIds]);
        }
                               
        // Set Tapeout Date
        for (Device__c d : listDevices) {
            if (d.MPW_Train_Number__c != null && (mapMPW != null && !mapMPW.isEmpty())) {
                IntegrationUsers__c integrationUsr = IntegrationUsers__c.getValues(UserInfo.getUserId());
                Boolean isIntegrationUser = (integrationUsr != null && integrationUsr.Skip_Validation_Rule__c) ?true:false;
                String mpwTrainNumber = mapMPW.get(d.MPW_Train_Number__c).Name + '_';
                Boolean isValid = (d.Name.startsWith(mpwTrainNumber))? !d.Name.endsWith('_') : false;
                if(!Test.isRunningTest() && !isIntegrationUser && !isValid){
                    String msg = Error_Codes__c.getInstance('DEVICEID_FORMAT_FOR_GLOBALSHUTTLEMPW') != null ? Error_Codes__c.getInstance('DEVICEID_FORMAT_FOR_GLOBALSHUTTLEMPW').Message__c:
                                                        'Device intended for GLOBALSHUTTLE MPW tapeout shall name the Device ID start with MPW train number followed by Prime Die Name("MPWnnnn_PrimeDieName").';
                    d.Name.addError(msg);
                    continue;
                }
                //if block for Customer Device
                if(!DeviceTriggerHandler.isInternalDevice(d.RecordTypeId) && d.Opportunity_Program__c != null && (mapAcctRecordType != null && !mapAcctRecordType.isEmpty())){
                    if (mapAcctRecordType.get(d.Opportunity_Program__c) == Environment_Variable__c.getInstance('ACCT_RT_ID_CUSTOMER').Value__c
                        || mapAcctRecordType.get(d.Opportunity_Program__c) == Environment_Variable__c.getInstance('ACCT_RT_ID_EN_PARTNER').Value__c
                        || mapAcctRecordType.get(d.Opportunity_Program__c) == Environment_Variable__c.getInstance('ACCT_RT_ID_RESELLER').Value__c) {
                        d.Current_Forecast_Tapeout_Date__c = mapMPW.get(d.MPW_Train_Number__c).Customer_Tapeout_Date__c;
                    } else if (mapAcctRecordType.get(d.Opportunity_Program__c) == Environment_Variable__c.getInstance('ACCT_RT_ID_GF_INTERNAL').Value__c) {
                        d.Current_Forecast_Tapeout_Date__c = mapMPW.get(d.MPW_Train_Number__c).Other_Tapeout_Date__c;
                    }
                }else{
                    //else block for Internal Device
                    d.Current_Forecast_Tapeout_Date__c = mapMPW.get(d.MPW_Train_Number__c).Other_Tapeout_Date__c;
                    if(d.Original_Forecasted_Tapeout_Date__c == null){
                        d.Original_Forecasted_Tapeout_Date__c = d.Current_Forecast_Tapeout_Date__c; 
                    }
                }
            } 
        }
    }
}