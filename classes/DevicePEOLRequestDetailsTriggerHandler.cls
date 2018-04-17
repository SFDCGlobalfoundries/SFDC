/**
*  Author: Sreedhar Karukonda
*  Description: DevicePEOLRequestDetailsTriggerHandler trigger handler of Device PEOL Request Details Trigger
* History:
*   Sreedhar Karukonda         15102015    - code creation.
**/

public with sharing class DevicePEOLRequestDetailsTriggerHandler {
    public static void handle(){
        if(Trigger.isInsert && Trigger.isBefore){
            checkAnyPendingPEOL((List<Device_PEOL_Request_Detail__c>)Trigger.new);
        }
        if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
            DevicePEOLRequestDetailsTriggerHandler.updateQueryId((List<Device_PEOL_Request_Detail__c>)Trigger.new);
            DevicePEOLRequestDetailsTriggerHandler.validate((List<Device_PEOL_Request_Detail__c>)Trigger.new);
        } else if(Trigger.isUpdate && Trigger.isAfter){
            DevicePEOLRequestDetailsTriggerHandler.updateStatusOnERPResponse((Map<Id, Device_PEOL_Request_Detail__c>)Trigger.newMap, (Map<Id, Device_PEOL_Request_Detail__c>)Trigger.oldMap);
        }
    }

    /*
    * update status on response from AIA/ERP
    */
    public static void updateStatusOnERPResponse(Map<Id, Device_PEOL_Request_Detail__c> newMap, Map<Id, Device_PEOL_Request_Detail__c> oldMap){
        Map<Id, Device_PEOL_Request__c> statusUpdatePEOLs = new Map<Id, Device_PEOL_Request__c>();
        // Collect all PEOL Requests
        Set<Id> pids = new Set<Id>();

        for(Id peolDetailId : newMap.keySet()){
            if(newMap.get(peolDetailId).ERP_Status_Message__c != oldMap.get(peolDetailId).ERP_Status_Message__c && (oldMap.get(peolDetailId).ERP_Status_Message__c == 'Waiting for ERP Response' || oldMap.get(peolDetailId).ERP_Status_Message__c == 'ERROR') ){
                pids.add(newMap.get(peolDetailId).Device_PEOL_Request__c);
                statusUpdatePEOLs.put(newMap.get(peolDetailId).Device_PEOL_Request__c, new Device_PEOL_Request__c(Id=newMap.get(peolDetailId).Device_PEOL_Request__c, Status__c = 'Completed') );
            }
        }

        if(!pids.isEmpty()){
            AggregateResult[] groupedResults = [SELECT Device_PEOL_Request__c, Count(Id) FROM Device_PEOL_Request_Detail__c where ERP_Status_Message__c != 'SUCCESS' and Device_PEOL_Request__c in : pids GROUP BY Device_PEOL_Request__c];
            for (AggregateResult ar : groupedResults)  {
                String peolId = (String)ar.get('Device_PEOL_Request__c');
                Integer notUnsuccessful = Integer.valueOf(ar.get('expr0'));
                if(notUnsuccessful > 0){
                    statusUpdatePEOLs.put(peolId, new Device_PEOL_Request__c(Id=peolId, Status__c = 'Failed'));
                }
            }

            if(!statusUpdatePEOLs.isEmpty()){
                update statusUpdatePEOLs.values();
            }
        }
    }

    /**
    * Updates query Id which is "ERP Device" Id and "Fab" with hyphen
    **/
    public static void updateQueryId(List<Device_PEOL_Request_Detail__c> newList){
        for(Device_PEOL_Request_Detail__c devicePEOLRequestDetail: newList){
            devicePEOLRequestDetail.Device_Fab_For_Query__c = devicePEOLRequestDetail.ERP_Device__c+'-'+devicePEOLRequestDetail.Fab__c;
        }
    }

    /*
    * Validate PEOL request
    */
    public static void validate(List<Device_PEOL_Request_Detail__c> newList){
        Integer PEOL_CAN_GO_UPTO = UtilsString.isNotBlank(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_CAN_GO_UPTO')) ?
                                            Integer.valueOf(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_CAN_GO_UPTO')) :30;

        for(Device_PEOL_Request_Detail__c devicePEOLRequestDetail: newList){
           if(devicePEOLRequestDetail.Last_Time_Ship_Date__c < devicePEOLRequestDetail.Last_Time_Buy_Date__c){
                devicePEOLRequestDetail.addError('Last Time Ship Date can not be greater than Last Time Buy Date');
           }
           if(devicePEOLRequestDetail.ERP_Status_Message__c == null){
                if( devicePEOLRequestDetail.Last_Time_Ship_Date__c < Datetime.now().addDays(-PEOL_CAN_GO_UPTO) ||
                    devicePEOLRequestDetail.Last_Time_Buy_Date__c < Datetime.now().addDays(-PEOL_CAN_GO_UPTO) ){
                    devicePEOLRequestDetail.addError('"Last Time Ship Date" and "Last Time Buy Date" should not go in to the past more than '+PEOL_CAN_GO_UPTO+' days.');
                }
           }
        }
    }

    /*
    * Check Pending PEOLs
    */
    private static void checkAnyPendingPEOL(List<Device_PEOL_Request_Detail__c> newList){
        //To check if there are any pending PEOL for the devices
        Set<String> deviceFabCombination = new Set<String>();
        // For checking Convert to Map
        Map<String, Device_PEOL_Request_Detail__c> requestsInsexedOnDeviceFab = new Map<String, Device_PEOL_Request_Detail__c>();

        for(Device_PEOL_Request_Detail__c devicePEOLRequestDetail: newList){
           deviceFabCombination.add(devicePEOLRequestDetail.Device_Fab_For_Query__c);
           requestsInsexedOnDeviceFab.put(devicePEOLRequestDetail.Device_Fab_For_Query__c,  devicePEOLRequestDetail);
        }

        List<Device_PEOL_Request_Detail__c> pendingDevicePEOLRequests = [select Id, Device_PEOL_Request__r.Status__c, Fab__c, Device_Fab_For_Query__c, ERP_Device__c, ERP_Device__r.Name from Device_PEOL_Request_Detail__c 
        where Device_PEOL_Request__r.Status__c != 'Failed'  and Device_Fab_For_Query__c in :deviceFabCombination];

        for(Device_PEOL_Request_Detail__c peolRequestDetail : pendingDevicePEOLRequests){
            Device_PEOL_Request_Detail__c hasPendingPeol = requestsInsexedOnDeviceFab.get(peolRequestDetail.Device_Fab_For_Query__c);
            hasPendingPeol.addError('THis device : ' + hasPendingPeol.ERP_Device__r.Name + ' for Fab : ' +  hasPendingPeol.Fab__c +' has PEOL Request already submitted and is in the stage : ' + hasPendingPeol.Device_PEOL_Request__r.Status__c);
        }
    }
}