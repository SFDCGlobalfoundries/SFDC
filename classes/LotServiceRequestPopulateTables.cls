/*
    Author: Zymark Ambat
    Description: This Class populates the DPML_Table__c and Lot_Request_Price_Table__c fields in the Lot Service Request record.
    History: 
        ZAmbat      11032013    - Code creation.
*/

public class LotServiceRequestPopulateTables {
    //Commenting the class for Deletion from Production
    public LotServiceRequestPopulateTables(){
        integer i = 0;
    }
    
    /*
    public static void populateTimePriceTables(List<Lot_Request__c> listLotRequest) {
        map<string, Id> mapFCTT = new map<string, Id>();
        for (Fab_Cycle_Time_Table__c f : [SELECT    Id
                                                    , Fab__c
                                                    , Geometry__c
                                                    , Effective_Quarter__c
                                          FROM      Fab_Cycle_Time_Table__c
                                          WHERE     Active__c = true]) { 
            mapFCTT.put(f.Fab__c + f.Geometry__c + f.Effective_Quarter__c, f.Id);
        }
        
        map<string, Id> mapLRPT = new map<string, Id>();
        for (Lot_Request_Price_Table__c l : [SELECT     Id
                                                        , Fab__c
                                                        , Effective_Quarter__c
                                             FROM       Lot_Request_Price_Table__c
                                             WHERE      Active__c = true]) { 
            mapLRPT.put(l.Fab__c + l.Effective_Quarter__c, l.Id);
        }
        
        for (Lot_Request__c l : listLotRequest) {
            // Get current quarter
            string currentQuarter = '';
            if (l.Date_Customer_Submitted_Request__c.month() >= 1 && l.Date_Customer_Submitted_Request__c.month() <= 3) {
                currentQuarter = l.Date_Customer_Submitted_Request__c.year() + 'Q1';
            } else if (l.Date_Customer_Submitted_Request__c.month() >= 4 && l.Date_Customer_Submitted_Request__c.month() <= 6) {
                currentQuarter = l.Date_Customer_Submitted_Request__c.year() + 'Q2';
            } else if (l.Date_Customer_Submitted_Request__c.month() >= 7 && l.Date_Customer_Submitted_Request__c.month() <= 9) {
                currentQuarter = l.Date_Customer_Submitted_Request__c.year() + 'Q3';
            } else if (l.Date_Customer_Submitted_Request__c.month() >= 10 && l.Date_Customer_Submitted_Request__c.month() <= 12) {
                currentQuarter = l.Date_Customer_Submitted_Request__c.year() + 'Q4';
            }

            if (mapFCTT.containsKey(l.Fab__c + l.Geometry__c + currentQuarter)) {
                l.DPML_Table__c = mapFCTT.get(l.Fab__c + l.Geometry__c + currentQuarter);
            } else {
              l.DPML_Table__c = null;
            }
            
            if (mapLRPT.containsKey(l.Fab__c + currentQuarter)) {
                l.Lot_Request_Price_Table__c = mapLRPT.get(l.Fab__c + currentQuarter);
            } else {
              l.Lot_Request_Price_Table__c = null;
            }
        }
    }*/
}