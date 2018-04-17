/**
* Author        :   Yash
* Company       :   IBM India.
* Description   :   Functionality for Mass Read of Lot Instructions on Lot Request.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Ykumar          09/01/2014          Created the Class
        
**/

public class LotInstructionMassReadController
{
     
     ApexPages.StandardSetController stdSetController;
     //declaring variables
     public String LotReqId{get;set;}
     public String lotReqName{get;set;}
     public String AccountName{get;set;}
     public Boolean CanEdit{get;set;}
     public Boolean NoRecordsSelected{get;set;}
     
     //constructor
     public LotInstructionMassReadController(ApexPages.StandardSetController stdSetController) 
     {
        this.stdSetController = stdSetController;
        this.stdSetController.setSelected(getSelectedSorted());
        //checkAccess();
     }
     
     //Not needed as OWD is Public Read/Write for Lot_Request and Manufacturing_Lot
     public void checkAccess()
     {
       CanEdit = true;
     }
    
    //for querying the Lot Instructions associated to the Lot Request being worked on.
    public List<Lot_Instruction__c> getSelectedSorted()
    {
       List<Lot_Instruction__c> ulist = (List<Lot_Instruction__c>)stdSetController.getSelected(); //getRecord();
       Id lotRequestId = (Id)ApexPages.currentPage().getParameters().get('id');
       List<Lot_Instruction__c> qlist;       

       if (ulist!=null && !(ulist.isEmpty())){
                qlist = [SELECT id,Required_DPML__c,Customer_Required_DPML__c,Total_Mask_ML__c,Manufacturing_Lot__r.Total_Mask_Count__c,Lot_Request__r.New_Customer_Requested_Date_CRD_CSR__c,Manufacturing_Lot__r.Start_Lot_Quantity__c,Manufacturing_Lot__r.Customer_Device_Id__c,Lot_Request__r.Lot_Request_Type__c, Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c,name,CreatedDate,Lot_Request__r.Account__r.name,Lot_Request__r.Name, Manufacturing_Lot__r.name,Submitted_Customer_Request_Date_CRD__c,
                         Submitted_for_Review_CSR__c,Comments_CSR__c, New_CSD_P__c, Able_to_Support_Request_P__c,Expedite_Type_To_Meet_CRD_CSR__c,
                         Comments_P__c,Lot_Request__c,Current_Customer_Request_Date_CRD_ML__c, Current_Schedule_Date_CSD_ML__c,
                         Lot_Type__c, Request_Type_LR__c, Purchase_Order_Number_ML__c
                         from Lot_Instruction__c where Lot_Request__r.id =:lotRequestId]; //where id in :ulist
       }else{
                qlist = [SELECT id,Required_DPML__c,Customer_Required_DPML__c,Total_Mask_ML__c,Manufacturing_Lot__r.Total_Mask_Count__c,Lot_Request__r.New_Customer_Requested_Date_CRD_CSR__c,Manufacturing_Lot__r.Start_Lot_Quantity__c,Manufacturing_Lot__r.Customer_Device_Id__c,Lot_Request__r.Lot_Request_Type__c, name,Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c,CreatedDate,Lot_Request__r.Account__r.name,Lot_Request__r.Name, Manufacturing_Lot__r.name,Submitted_Customer_Request_Date_CRD__c,
                         Submitted_for_Review_CSR__c,Comments_CSR__c,New_CSD_P__c, Able_to_Support_Request_P__c,Expedite_Type_To_Meet_CRD_CSR__c,
                         Comments_P__c,Lot_Request__c,Current_Customer_Request_Date_CRD_ML__c, Current_Schedule_Date_CSD_ML__c,
                         Lot_Type__c, Request_Type_LR__c, Purchase_Order_Number_ML__c
                         from Lot_Instruction__c where Lot_Request__r.id =:lotRequestId]; //
       }     

       NoRecordsSelected = (qList.size() == 0);

       List< LIWrapper> tlist = new List< LIWrapper>();
       List<Lot_Instruction__c> slist = new List<Lot_Instruction__c>();
       
       for(Lot_Instruction__c qr:qlist){
          LotReqId = qr.Lot_Request__c;
          lotReqName = qr.Lot_Request__r.Name;
          AccountName = qr.Lot_Request__r.Account__r.Name;
          tlist.add(new LIWrapper(qr));
       }              
       tlist.sort();
       for(LIWrapper qrw: tlist){
          slist.add(qrw.getLotInstruction());
       }     
       return slist;
    }
    
    //Lot Instruction Wrapper
    public class LIWrapper implements Comparable{
        Lot_Instruction__c qr = null;
        LIWrapper(Lot_Instruction__c qr){
            this.qr = qr;
        }
        
        public Lot_Instruction__c getLotInstruction(){
           return this.qr;
        }
        
        public Integer compareTo(Object compareTo){
          
           return -1;
        }
        
    } 
    
}