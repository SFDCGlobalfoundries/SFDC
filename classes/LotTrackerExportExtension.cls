/**
* Author        :   Nikhil Jain
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality for exporting Tracked Lots on Lot Tracker in Excel.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        NJain           25/12/2013          Created the Class
        NJain           24/01/2014          Added the column Planned_Fabout_Date__c in query.
        NJain           07/02/2014          Replaced 'Customer Device Id' with 'Device Id(MES)'
**/
public class LotTrackerExportExtension{
    
    //page variables
    public List<Tracked_Lot__c> lstTrackedLots{get;set;}
    public Lot_Tracker__c lotTrackerRec{get;set;}
    public boolean noRecordsSelected{get;set;}
    
    //constructor for LotTracker Export page
    public LotTrackerExportExtension(ApexPages.StandardController controller){
        lotTrackerRec = (Lot_Tracker__c)controller.getRecord();
        lstTrackedLots = [SELECT Lot_Tracker__c,Manufacturing_Lot__r.Fab_Group__c, Type__c,Geometry__c, GDPW__c, Device__c, Name, 
                         Manufacturing_Lot__c, QTY_Description__c, Reticle_ETA__c, Current_CSD_ML__c, 
                         Manufacturing_Lot__r.Current_Stage_Being_Processed__c, Remaining_Mask_Count__c, 
                         Manufacturing_Lot__r.Total_Mask_Count__c, Remarks__c, Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c, 
                         Manufacturing_Lot__r.Planned_Fabout_Date__c,Lot_Tracker__r.Name,
                         Manufacturing_Lot__r.Device_ID_MES__c,Manufacturing_Lot__r.name,Tapeout_Date__c,
                         Manufacturing_Lot__r.Purchase_Order_Number__c,Current_Stage_ML__c
                         from Tracked_Lot__c where Lot_Tracker__c = :lotTrackerRec.id];
        
        system.debug('#########ID#########'+lotTrackerRec.id);
        
        if(lstTrackedLots.size() <1){
            noRecordsSelected = true;
        } 
                         
    }
}