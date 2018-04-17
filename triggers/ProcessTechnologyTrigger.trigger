/*
    Author: Zymark Ambat
    Description: This Trigger manages the autopopulation of IP_Technology__c field on Device based on Process Technology's IP_Geometry_Technology__c.
    History: 
        ZAmbat      07222013    - Code creation.
        ZAmbat      11262013    - Updated code due to Error "System.QueryException: Aggregate query has too many rows for direct assignment".
*/

trigger ProcessTechnologyTrigger on Process_Technology__c (after insert, after update) {
    // Get related Device records
    /*List<Device__c> listDevice = new List<Device__c>(); 
    for (Process_Technology__c pt : [SELECT     Id
                                                , IP_Geometry_Technology__c
                                                , (SELECT       Id
                                                                , IP_Technology__c
                                                   FROM         Devices__r)
                                     FROM       Process_Technology__c
                                     WHERE      Id IN :trigger.newMap.keySet()]) {
        if (pt.Devices__r.size() > 0) {
            for (Device__c d : pt.Devices__r) {
                // Check Device__c.IP_Technology__c value against Process_Technology__c.IP_Geometry_Technology__c value
                if (d.IP_Technology__c != pt.IP_Geometry_Technology__c) {
                    d.IP_Technology__c = pt.IP_Geometry_Technology__c;
                    listDevice.add(d);
                }
            }
        }
    }*/
    
    // ZAmbat 11262013
    Map<Id, string> ptMap = new Map<Id, string>();
    for (Process_Technology__c pt : trigger.new) { 
        ptMap.put(pt.Id, pt.IP_Geometry_Technology__c);
    }
    
    List<Device__c> listDevice = new List<Device__c>();
    for (Device__c d : [SELECT      Id
                                    , IP_Technology__c
                                    , Process_Technology_2__c
                        FROM        Device__c
                        WHERE       Process_Technology_2__c IN :ptMap.keySet()]) {
        // Check Device__c.IP_Technology__c value against Process_Technology__c.IP_Geometry_Technology__c value
        if (d.IP_Technology__c != ptMap.get(d.Process_Technology_2__c)) {
            d.IP_Technology__c = ptMap.get(d.Process_Technology_2__c);
            listDevice.add(d);
        }
    }
    
    // Update Device records
    if (listDevice.size() > 0) {
        Update listDevice;
    }
}