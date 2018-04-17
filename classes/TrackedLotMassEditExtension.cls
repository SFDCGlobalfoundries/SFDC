/**
* Author        :   Nikhil Jain
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality for Mass Update of Tracked Lot on Lot Tracker.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        NJain           20/12/2013          Created the Class
        NJain           24/01/2014          Added the column Planned_Fabout_Date__c in query.
        NJain           07/02/2014          Replaced 'Customer Device Id' with 'Device Id(MES)'
**/

public class TrackedLotMassEditExtension
{     
     ApexPages.StandardSetController stdSetController;
     //declaring variables
     public Boolean NoRecordsSelected{get;set;}
     public Tracked_Lot__c trackedLotRec;
     
     List<Tracked_Lot__c> qlist; 
     
     //constructor
     public TrackedLotMassEditExtension(ApexPages.StandardSetController stdSetController){
        this.stdSetController = stdSetController;
        this.stdSetController.setSelected(getSelectedSorted());
     }
     
     //constructor for TrackedLot_New page
     public TrackedLotMassEditExtension(ApexPages.StandardController controller){
         trackedLotRec = (Tracked_Lot__c)controller.getRecord();
     }
     
    //for querying the Lot Instructions associated to the Lot Request being worked on.
    public List<Tracked_Lot__c> getSelectedSorted(){
       
       List<Tracked_Lot__c> ulist = (List<Tracked_Lot__c>)stdSetController.getSelected();
       
       Id lotTrackerId = (Id)ApexPages.currentPage().getParameters().get('id');

       if (ulist!=null && !(ulist.isEmpty())){
                qlist = [SELECT Lot_Tracker__c,Manufacturing_Lot__r.Fab_Group__c, Type__c,Geometry__c, GDPW__c, Device__c, Name, 
                         Manufacturing_Lot__c, QTY_Description__c, Reticle_ETA__c, Current_CSD_ML__c, 
                         Manufacturing_Lot__r.Current_Stage_Being_Processed__c, Remaining_Mask_Count__c, 
                         Manufacturing_Lot__r.Total_Mask_Count__c, Remarks__c, Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c, 
                         Manufacturing_Lot__r.Planned_Fabout_Date__c,Lot_Tracker__r.Name,
                         Manufacturing_Lot__r.Device_ID_MES__c,Manufacturing_Lot__r.name,Tapeout_Date__c,
                         Manufacturing_Lot__r.Purchase_Order_Number__c,Current_Stage_ML__c
                         from Tracked_Lot__c where id in :ulist];
       }else{
                qlist = [select Lot_Tracker__c,Manufacturing_Lot__r.Fab_Group__c, Type__c,Geometry__c, GDPW__c, Device__c, Name, 
                         Manufacturing_Lot__c, QTY_Description__c, Reticle_ETA__c, Current_CSD_ML__c, 
                         Manufacturing_Lot__r.Current_Stage_Being_Processed__c, Remaining_Mask_Count__c, 
                         Manufacturing_Lot__r.Total_Mask_Count__c, Remarks__c, Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c, 
                         Manufacturing_Lot__r.Planned_Fabout_Date__c,Lot_Tracker__r.Name,
                         Manufacturing_Lot__r.Device_ID_MES__c,Manufacturing_Lot__r.name,Tapeout_Date__c,
                         Manufacturing_Lot__r.Purchase_Order_Number__c,Current_Stage_ML__c
                         from Tracked_Lot__c where Tracked_Lot__c.id =:lotTrackerId];
       }     
       NoRecordsSelected = (qList.size() == 0);

       List< LIWrapper> tlist = new List< LIWrapper>();
       List<Tracked_Lot__c> slist = new List<Tracked_Lot__c>();
       
       for(Tracked_Lot__c qr:qlist){
          tlist.add(new LIWrapper(qr));
       }              
       tlist.sort();
       for(LIWrapper qrw: tlist){
          slist.add(qrw.getTrackedLot());
       }     
       return slist;
    }
    
    //Tracked Lot Wrapper
    public class LIWrapper implements Comparable{
        Tracked_Lot__c qr = null;
        LIWrapper(Tracked_Lot__c qr){
            this.qr = qr;
        }
        
        public Tracked_Lot__c getTrackedLot(){
           return this.qr;
        }
        
        public Integer compareTo(Object compareTo){
           return -1;
        }
    }
    
    public pageReference saveForNewRecord(){
        try{
            insert trackedLotRec;    
        }catch(DMLException e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Record with same Lot already exists with the associated Lot Tracker.');
            ApexPages.addMessage(myMsg);
            return null;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Following Exception occured:'+e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        PageReference pageRef = new PageReference('/'+trackedLotRec.Lot_Tracker__c);
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
    public pageReference saveCustom(){
        try{
            update qlist;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Information has been updated. Please click on \'Return\'');
            ApexPages.addMessage(myMsg);
            return null;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Following Exception occured:'+e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    
    }
}