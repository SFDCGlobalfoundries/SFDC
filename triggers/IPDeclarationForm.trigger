/*
    Author: Ariz Solito
    Description: Apex trigger for IP declaration form matching
    History: 
    Asolito     07112013    - Apex coded created.
    Nbustillos  07182013    - Added logic to populate Submitted Date.
    Nbustillos  07272013    - Removes logic to populate Submitted Date. This is now done from Std Approval Process.
                            - Removes query to 'Read Only' record type.
    ZAmbat      08282013    - Added functionality to update Device of the IP Declaration Form's status
    Asolito     09102013    - Send email notifications based on status
    Asolito     10132013    - Added fix for task 433
    PSaha       01122015    - Added Configuration Link Logic triggered at Before Insert Event. 
*/
trigger IPDeclarationForm on IP_Declaration_Form__c (before update, before insert, after insert, after update) {
    if(trigger.isBefore){
        // PS: 01122015 IPDeclarationLinkConfiguration: IP declaration link handled here. 
        if(trigger.isInsert){
            Map<id,id> DeviceID2ConfigMap = new Map<id,id>();
            
            DeviceID2ConfigMap = CPQIPDeclarationUtil.IPDeclarationLinkConfiguration(   trigger.new
                                                                                        , true
                                                                                        , true);
            system.debug('[Debug: DeviceID2ConfigMap]' + DeviceID2ConfigMap);                                                                            
            for(IP_Declaration_Form__c Ipform: trigger.new){
                if( DeviceID2ConfigMap != NULL 
                    && DeviceID2ConfigMap.containsKey(Ipform.device__c)){
                    Ipform.configuration__c = DeviceID2ConfigMap.get(Ipform.device__c); 
                    Ipform.Is_Config_Used__c = CPQIPDeclarationUtil.MapIPIDvsReqfromConfig.get(Ipform.device__c);
                }
            }
        }
        for(IP_Declaration_Form__c oIPForm: trigger.new){
            
            // update record type to read only
            if(oIPForm.Reset_Record_Type__c){
                oIPForm.RecordTypeId = null;
                oIPForm.Reset_Record_Type__c = false;
            }
            
            // TODO: bring back record type to master if reopened or recalled (cancelled)
        }
    }else if(trigger.isAfter){
        List<String> recIDs = new List<String>();
        for(IP_Declaration_Form__c t: trigger.new){
            if(trigger.isInsert){
                recIDs.add(t.id);
            } else if(trigger.isUpdate){                
                if(t.status__c <> trigger.oldMap.get(t.id).status__c){
                    recIDs.add(t.id);
                }
            }
        }
        
        //Do Matching
        if(recIDs.size() > 0){
            if(!IPDeclarationMatching.hasMatchingRun){      
                IPDeclarationMatching.processMatching(recIds);      
            }
        }
    }
    
    // 08282013 ZAmbat - Added functionality to update Device of the IP Declaration Form's status
    if ((trigger.isAfter && trigger.isUpdate) || (trigger.isBefore && trigger.isInsert)) {
        Set<Id> deviceIds = new Set<Id>();
        Map<Id, IP_Declaration_Form__c> mapIDF = new Map<Id, IP_Declaration_Form__c>();             
        for (IP_Declaration_Form__c idf : trigger.New) {
            if (trigger.isAfter && trigger.isUpdate) {
                if ((idf.Status__c != trigger.oldMap.get(idf.Id).Status__c) || (idf.Form_Submitted_Date__c != trigger.oldMap.get(idf.Id).Form_Submitted_Date__c)) { 
                    deviceIds.add(idf.Device__c);
                    mapIDF.put(idf.Device__c, idf);
                }
                
            } else if (trigger.isBefore && trigger.isInsert) {
                deviceIds.add(idf.Device__c);
                mapIDF.put(idf.Device__c, idf);
            }
        }
        
        List<String> IPIDs = new List<String>(); 
        for (IP_Declaration_Form__c idf : trigger.New) {
            if (trigger.isAfter && trigger.isUpdate) {
                if(idf.Status__c <> trigger.oldMap.get(idf.Id).Status__c){
                    IPIDs.add(idf.id);    
                }
            }
        }
        
        if (IPIDs.size() > 0) {            
            //Added Asolito 09102013 - Send email notifications based on status
            //IPDeclarationFormSendEmail.sendEmail(IPIDs,trigger.oldMap);
        }
        
        system.debug('deviceIds ==================> ' + deviceIds.size());
        if (deviceIds.size() > 0) {
            List<Device__c> listDevice = [
                SELECT      Id
                            , IP_Declaration_Status__c
                            , IP_Declaration_Submitted_Date__c
                FROM        Device__c
                WHERE       Id IN :deviceIds
            ];
            
            if (listDevice.size() > 0) {
                for (Device__c d : listDevice) {
                    d.IP_Declaration_Status__c = mapIDF.get(d.Id).Status__c;
                    
                    if (trigger.isAfter && trigger.isUpdate) {
                        d.IP_Declaration_Submitted_Date__c = mapIDF.get(d.Id).Form_Submitted_Date__c;
                    }
                }
                
                update listDevice;
            }
        }
    }
}