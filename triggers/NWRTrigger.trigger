/*
    Author: Zymark Ambat
    Description: This Class serves as the trigger for the Non_Wafer_Revenue__c object.
    History: 
        ZAmbat      10162014    - Code creation.
*/

trigger NWRTrigger on Non_Wafer_Revenue__c (after insert, after update) {
    set<Id> deviceIds = new set<Id>();
    for (Non_Wafer_Revenue__c n : trigger.new) {
        if (trigger.isInsert
            || (trigger.isUpdate 
                && (n.Non_Wafer_Revenue_Type__c != trigger.oldMap.get(n.Id).Non_Wafer_Revenue_Type__c
                    || n.PO__c != trigger.oldMap.get(n.Id).PO__c
                    || n.Sub_Type__c != trigger.oldMap.get(n.Id).Sub_Type__c
                    || n.Device__c != trigger.oldMap.get(n.Id).Device__c))) {
            if (n.Device__c != null) {
                deviceIds.add(n.Device__c);
            } else {
                if (trigger.isUpdate) {
                    deviceIds.add(trigger.oldMap.get(n.Id).Device__c);
                }
            }
        }
    }
    
    if (deviceIds.size() > 0) {
        list<Device__c> listDevices = new list<Device__c>([
            SELECT      Id
                        , Reticle_PO_Status__c
                        , NWR_and_TO_Type_Matching__c
                        , Tapeout_Type__c
                        , (SELECT       Id
                                        , Non_Wafer_Revenue_Type__c
                                        , Sub_Type__c
                                        , PO__c
                           FROM         Non_Wafer_Revenues__r)
            FROM        Device__c
            WHERE       Id IN :deviceIds
        ]);
        
        list<Device__c> listUpdateDevices = new list<Device__c>(); 
        for (Device__c d : listDevices) {
            if (d.Non_Wafer_Revenues__r.size() > 0) {
                integer reticlePoStatusCondition1 = 0;
                integer reticlePoStatusCondition2 = 0;
                integer reticlePoStatusCondition3 = 0;
                integer reticlePoStatusCondition4 = 0;
                integer reticlePoStatusCondition5 = 0;
                integer nwrAndToTypeMatchingCondition1 = 0;
                integer nwrAndToTypeMatchingCondition2 = 0;
                integer nwrAndToTypeMatchingCondition3 = 0;
                integer nwrAndToTypeMatchingCondition4 = 0;
                integer nwrAndToTypeMatchingCondition5 = 0;
                integer nwrAndToTypeMatchingCondition6 = 0;
                integer nwrAndToTypeMatchingCondition7 = 0;
                integer nwrAndToTypeMatchingCondition8 = 0;
                integer nwrAndToTypeMatchingCondition9 = 0;
                integer nwrAndToTypeMatchingCondition10 = 0;
                integer nwrAndToTypeMatchingCondition11 = 0;
                integer nwrAndToTypeMatchingCondition12 = 0;
                integer nwrAndToTypeMatchingCondition13 = 0;
                integer nwrAndToTypeMatchingCondition14 = 0;
                integer nwrAndToTypeMatchingCondition15 = 0;
                for (Non_Wafer_Revenue__c n : d.Non_Wafer_Revenues__r) {
                    // Reticle PO Status
                    if (n.Non_Wafer_Revenue_Type__c == 'Reticle') {
                        if (n.PO__c != null) {  
                            reticlePoStatusCondition1++;
                        } else {
                            reticlePoStatusCondition2++;
                        }
                    } else if (n.Non_Wafer_Revenue_Type__c == 'MPW') {
                        if (n.PO__c != null) {  
                            reticlePoStatusCondition3++;
                        } else {
                            reticlePoStatusCondition4++;
                        }
                    } else {
                        reticlePoStatusCondition5++;
                    }
                    
                    // NWR and TO Type Matching
                    if (d.Tapeout_Type__c == 'Customer MPW') {
                        if (n.Sub_Type__c == 'First Tape-out') {        
                            nwrAndToTypeMatchingCondition1++;   
                        } else if (n.Sub_Type__c == 'MPW') {        
                            nwrAndToTypeMatchingCondition2++;
                        } else if (n.Sub_Type__c == 'Retrofit') {       
                            nwrAndToTypeMatchingCondition3++;
                        }
                    } else if (d.Tapeout_Type__c == 'GlobalShuttle MPW') {
                        if (n.Sub_Type__c == 'First Tape-out') {        
                            nwrAndToTypeMatchingCondition4++;   
                        } else if (n.Sub_Type__c == 'MPW') {        
                            nwrAndToTypeMatchingCondition5++;
                        } else if (n.Sub_Type__c == 'Retrofit') {       
                            nwrAndToTypeMatchingCondition6++;
                        }
                    } else if (d.Tapeout_Type__c == 'Retrofit') {
                        if (n.Sub_Type__c == 'First Tape-out') {        
                            nwrAndToTypeMatchingCondition7++;   
                        } else if (n.Sub_Type__c == 'MPW') {        
                            nwrAndToTypeMatchingCondition8++;
                        } else if (n.Sub_Type__c == 'Retrofit') {       
                            nwrAndToTypeMatchingCondition9++;
                        }
                    } else if (d.Tapeout_Type__c == 'Single Product') {
                        if (n.Sub_Type__c == 'First Tape-out') {        
                            nwrAndToTypeMatchingCondition10++;  
                        } else if (n.Sub_Type__c == 'MPW') {        
                            nwrAndToTypeMatchingCondition11++;
                        } else if (n.Sub_Type__c == 'Retrofit') {       
                            nwrAndToTypeMatchingCondition12++;
                        }
                    } else if (d.Tapeout_Type__c == 'Full Layer Retrofit') {
                        if (n.Sub_Type__c == 'First Tape-out') {        
                            nwrAndToTypeMatchingCondition13++;  
                        } else if (n.Sub_Type__c == 'MPW') {        
                            nwrAndToTypeMatchingCondition14++;
                        } else if (n.Sub_Type__c == 'Retrofit') {       
                            nwrAndToTypeMatchingCondition15++;
                        }
                    }
                }
                
                // Set Device's Reticle PO Status
                if (reticlePoStatusCondition1 > 0) {
                    d.Reticle_PO_Status__c = 'Reticle PO Issued';
                } else if (reticlePoStatusCondition2 > 0) {
                    d.Reticle_PO_Status__c = 'Reticle PO Is Forecasted';
                } else if (reticlePoStatusCondition3 > 0) {
                    d.Reticle_PO_Status__c = 'Customer MPW PO Issued';
                } else if (reticlePoStatusCondition4 > 0) {
                    d.Reticle_PO_Status__c = 'Customer MPW Is Forecasted';
                } else if (reticlePoStatusCondition5 > 0) {
                    d.Reticle_PO_Status__c = 'NWR Is Not Available';
                } 
                
                // Set Device's NWR and TO Type Matching
                if (nwrAndToTypeMatchingCondition1 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition2 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Match';
                } else if (nwrAndToTypeMatchingCondition3 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition4 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition5 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Match';
                } else if (nwrAndToTypeMatchingCondition6 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition7 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition8 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition9 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Match';
                } else if (nwrAndToTypeMatchingCondition10 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Match';
                } else if (nwrAndToTypeMatchingCondition11 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition12 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition13 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition14 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Does not Match';
                } else if (nwrAndToTypeMatchingCondition15 > 0) {
                    d.NWR_and_TO_Type_Matching__c = 'Match';
                }
            } else {
                d.Reticle_PO_Status__c = null;
                d.NWR_and_TO_Type_Matching__c = null;
            }
            
            listUpdateDevices.add(d);
        }
        
        if (listUpdateDevices.size() > 0) {
            update listUpdateDevices;
        }
    }
}