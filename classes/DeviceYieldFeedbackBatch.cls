/*
    Author: Zymark Ambat
    Description: This is a batch class that updates Device - Yield Feedback taggings.
    History: 
        ZAmbat      12172014    - Code creation.
*/

global class DeviceYieldFeedbackBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string soql = 'SELECT     Id' +
                                 ', Account__c ' +
                                 ', Proto_Lot_Start_ID__c ' +
                                 ', (SELECT Id, Is_Auto_Tagged__c, Manufacturing_Lot__c, Manufacturing_Lot__r.Last_Ship_Date__c, Device__c, Manufacturing_Lot__r.Name FROM Yield_Feedback__r ORDER BY Manufacturing_Lot__r.Last_Ship_Date__c) ' + 
                      'FROM       Device__c ' + 
                      'WHERE      Proto_Lot_Start_ID__c != null ' +
                                 'AND Tapeout_Type__c != \'Retrofit\' ' +
                                 'AND Proto_Lot_Start_ID_Change_Date__c = TODAY';
        
        return Database.getQueryLocator(soql);
    }

    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        List<Device__c> listDevice = (List<Device__c>)scope; 
        Set<string> setLotNames = new Set<string>();
        set<string> setLotBaseNames = new set<string>();
        for (Device__c d : listDevice) {
            setLotNames.add(d.Proto_Lot_Start_ID__c);
            if (d.Proto_Lot_Start_ID__c.indexOf('.') >= 0) {
                setLotBaseNames.add(d.Proto_Lot_Start_ID__c.substring(0, d.Proto_Lot_Start_ID__c.indexOf('.')) + '%');
            } else {
                setLotBaseNames.add(d.Proto_Lot_Start_ID__c + '%');
            }
        }
        
        if (setLotNames.size() > 0) {
            // Create Map for Manufacturing Lot Name - Manufacturing Lot Id
            Map<Id, string> mapAll = new Map<Id, string>();
            Map<string, Manufacturing_Lot__c> mapLotNames = new Map<string, Manufacturing_Lot__c>();
            for (Manufacturing_Lot__c m : [SELECT    Id
                                                     , Name
                                                     , Last_Ship_Date__c
                                           FROM      Manufacturing_Lot__c
                                           WHERE     Name IN :setLotNames
                                           Order by Last_Ship_Date__c]) {
                mapLotNames.put(m.Name, m);
                mapAll.put(m.Id, m.Name);
            }
            
            // Create Map for Manufacturing Child Lots
            Map<string, List<Manufacturing_Lot__c>> mapChildLotNames = new Map<string, List<Manufacturing_Lot__c>>();
            for (Manufacturing_Lot__c m : [SELECT    Id
                                                     , Name
                                                     , Last_Ship_Date__c
                                           FROM      Manufacturing_Lot__c
                                           WHERE     Name LIKE :setLotBaseNames
                                                     AND Name NOT IN :setLotNames
                                                     AND (Lot_Type__c LIKE 'QD%' OR Lot_Type__c LIKE 'QF%')
                                                     AND Last_Ship_Date__c != null
                                           Order by Last_Ship_Date__c]) {
                string tempName = '';
                if (m.Name.indexOf('.') >= 0) {
                    tempName = m.Name.substring(0, m.Name.indexOf('.'));
                } else {
                    tempName = m.Name;
                }
                                       
                if (mapChildLotNames.containsKey(tempName)) {
                    List<Manufacturing_Lot__c> tempList = mapChildLotNames.get(tempName);
                    tempList.add(m);
                    mapChildLotNames.put(tempName, tempList);
                } else {
                    mapChildLotNames.put(tempName, new List<Manufacturing_Lot__c>{m});
                }
                mapAll.put(m.Id, m.Name);
            }
            
            List<Yield_Feedback__c> listYieldFeedback = new List<Yield_Feedback__c>();
            for (Device__c d : listDevice) {
                string tempName = '';
                if (d.Proto_Lot_Start_ID__c.indexOf('.') >= 0) {
                    tempName = d.Proto_Lot_Start_ID__c.substring(0, d.Proto_Lot_Start_ID__c.indexOf('.'));
                } else {
                    tempName = d.Proto_Lot_Start_ID__c;
                }
                    
                if (d.Yield_Feedback__r.size() > 0) {
                    Map<string, Yield_Feedback__c> mapExistingYF = new Map<string, Yield_Feedback__c>();
                    for (Yield_Feedback__c y : d.Yield_Feedback__r) {
                        mapExistingYF.put(y.Manufacturing_Lot__r.Name, y);
                    }
                    
                    Yield_Feedback__c temp = checkYieldFeedbackRecords(d.Account__c, d.Id, mapLotNames.get(d.Proto_Lot_Start_ID__c), mapChildLotNames.containsKey(tempName) ? mapChildLotNames.get(tempName) : new List<Manufacturing_Lot__c>());
                    if (!mapExistingYF.containsKey(mapAll.get(temp.Manufacturing_Lot__c))) {
                        boolean tagFound = false;
                        for (string key : mapExistingYF.keySet()) {
                            string tempKey = '';
                            if (key.indexOf('.') >= 0) {
                                tempKey = key.substring(0, key.indexOf('.'));
                            } else {
                                tempKey = key;
                            }
                            
                            if (tempName == tempKey) {
                                if (mapExistingYF.get(key).Is_Auto_Tagged__c) {
                                    if (mapExistingYF.get(key).Manufacturing_Lot__r.Last_Ship_Date__c == null) { 
                                        Yield_Feedback__c yf = mapExistingYF.get(key);
                                        yf.Manufacturing_Lot__c = temp.Manufacturing_Lot__c;
                                        listYieldFeedback.add(yf); 
                                    }
                                    tagFound = true;
                                    break;
                                }                
                            }
                        }
                        
                        if (!tagFound) {
                            listYieldFeedback.add(temp);
                        }
                    }
                } else {
                    if (mapLotNames.containsKey(d.Proto_Lot_Start_ID__c)) {
                        listYieldFeedback.add(checkYieldFeedbackRecords(d.Account__c, d.Id, mapLotNames.get(d.Proto_Lot_Start_ID__c), mapChildLotNames.containsKey(tempName) ? mapChildLotNames.get(tempName) : new List<Manufacturing_Lot__c>()));
                    }
                }
            }

            if (listYieldFeedback.size() > 0) {
                upsert listYieldFeedback;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {}
    
    private Yield_Feedback__c checkYieldFeedbackRecords(string accountId, string deviceId, Manufacturing_Lot__c ml, List<Manufacturing_Lot__c> listML) {
        string tagNote = null;
        string lotId = ml.Id;
        if (ml.Last_Ship_Date__c == null) {
            if (listML.size() > 0) {
                date oldestShipDate = null;
                for (Manufacturing_Lot__c m : listML) {
                    if (oldestShipDate == null) {
                        oldestShipDate = m.Last_Ship_Date__c;
                        lotId = m.Id;
                    } else {
                        if (m.Last_Ship_Date__c < oldestShipDate) {
                            oldestShipDate = m.Last_Ship_Date__c;
                            lotId = m.Id;
                        }
                    }
                }
                
                // Make note
                tagNote = 'Auto-Tagged this lot instead of ' + ml.Name;
            }
        }
        
        return createNewRecord(accountId, deviceId, lotId, tagNote);
    }
    
    private Yield_Feedback__c createNewRecord(string accountId, string deviceId, string lotId, string tagNote) {
        Yield_Feedback__c y = new Yield_Feedback__c();
        y.Account__c = accountId;
        y.Device__c = deviceId;
        y.Manufacturing_Lot__c = lotId;
        y.Is_Auto_Tagged__c = true;
        y.Auto_Tag_Note__c = tagNote;
        
        return y;
    }
}