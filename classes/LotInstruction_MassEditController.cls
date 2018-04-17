/**
* Author        :   Nikhil Jain
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality for Mass Update of Lot Instructions on Lot Request.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        NJain           03/09/2013          Created the Class
        NJain           14/10/2013          Added a field in Query for 'Expedite_Type_To_Meet_CRD_CSR__c'
        ZAmbat          10/13/2014          Updated code as per CASE 34882.
        ZAmbat          10/31/2014          Updated code as per CASE 35698.
        NJain           07/16/2015          Added the columns in Query for Lot Instruction.
**/

public class LotInstruction_MassEditController
{
     
     ApexPages.StandardSetController stdSetController;
     //declaring variables
     public String LotReqId{get;set;}
     public String lotReqName{get;set;}
     public String AccountName{get;set;}
     public string firstLotInstructionSelected {get;set;}
     public Boolean CanEdit{get;set;}
     public Boolean NoRecordsSelected{get;set;}
     public list<lotInstWrapper>linstWrapList {get;set;}
     public Lot_Instruction__c lotIn {get;set;}
     Public String ErrorMsg='';
     
     //constructor
     public LotInstruction_MassEditController(ApexPages.StandardSetController stdSetController) 
     {
        this.stdSetController = stdSetController;
        linstWrapList = new List<lotInstWrapper>();
        for(Lot_Instruction__c lisnt : getSelectedSorted()){
            If(lisnt.Submitted_Customer_Request_Date_CRD__c<System.Today()){
                if(ErrorMsg==''){
                    ErrorMsg='1.New CRD (CSR) cannot be less than today.';
                }
            }
            if(lisnt.New_CSD_P__c>lisnt.Current_CSD_ML_at_time_of_Submission__c){
                if(ErrorMsg!=''){
                ErrorMsg+=', 2.New CSD (P) should be earlier than the Current CSD at time of submission.';
                }else{
                    System.debug('_________'+ErrorMsg);
                    ErrorMsg='New CSD (P) should be earlier than the Current CSD at time of submission.';
                }
            }
            if(lisnt.Current_CSD_ML_at_time_of_Submission__c==null){
                if(ErrorMsg!=''){
                    ErrorMsg+=', 3.Current CSD(ML) at CSR Submission shuold not be empty';
                }else{
                    System.debug('_________'+ErrorMsg);
                    ErrorMsg='Current CSD(ML) at CSR Submission shuold not be empty';
                }
            }
            if(lisnt.Submitted_Customer_Request_Date_CRD__c>=lisnt.Current_CSD_ML_at_time_of_Submission__c){
                if(ErrorMsg!=''){
                    ErrorMsg+=', 4.New CRD (CSR) should always be less than Current CSD (ML).';
                }else{
                    System.debug('_________'+ErrorMsg);
                    ErrorMsg='New CRD (CSR) should always be less than Current CSD (ML).';
                }
            }
            if(lisnt.Account_LR__c <> lisnt.Manufacturing_Lot__r.Account_Name__r.name){
                if(ErrorMsg!=''){
                    ErrorMsg+=', 5.Lot Instraction account(customer) should be same as Lot ID Account(Customer).';
                }else{
                    System.debug('_________'+ErrorMsg);
                    ErrorMsg='Lot Instraction account(customer) should be same as Lot ID Account(Customer).';
                }
            }
           
            linstWrapList.add(new lotInstWrapper(lisnt,ErrorMsg));
            }
        lotIn = new Lot_Instruction__c ();
        //this.stdSetController.setSelected(getSelectedSorted());
        checkAccess();
     }
     
     //Not needed as OWD is Public Read/Write for Lot_Request and Manufacturing_Lot
     public void checkAccess()
     {
       /*
       List<Lot_Instruction__Share> oppShares = [select Id,Lot_Request__c,UserOrGroupId, AccessLevel,RowCause from Lot_Instruction__share where Lot_Request__c = :LotReqId and UserOrGroupId = :UserInfo.getUserId() ];
       String al = null;
       Boolean write = false;
       for(Lot_Instruction__Share lotReqShare:oppShares)
       {
           al = lotReqShare.AccessLevel;
           if((al == 'Edit')||(al == 'All'))
           {
             write = true;
             break;
           }
       }     
       CanEdit = write;
       */
       CanEdit = true;
     }
    
    //for querying the Lot Instructions associated to the Lot Request being worked on.
    public List<Lot_Instruction__c> getSelectedSorted()
    {
       List<Lot_Instruction__c> ulist = (List<Lot_Instruction__c>)stdSetController.getSelected();
       Id lotRequestId = (Id)ApexPages.currentPage().getParameters().get('id');
       List<Lot_Instruction__c> qlist;       

       if (ulist!=null && !(ulist.isEmpty())){
                qlist = [SELECT id, name,CreatedDate,Account__c,Lot_Request__r.Account__r.name,Lot_Request__r.Name, Manufacturing_Lot__r.name,Submitted_Customer_Request_Date_CRD__c,
                         Submitted_for_Review_CSR__c,ValidationSignals__c,Comments_CSR__c, New_CSD_P__c, Able_to_Support_Request_P__c,Expedite_Type_To_Meet_CRD_CSR__c,Lot_Request__r.Stage__c,
                         Comments_P__c,Lot_Request__c,Current_Customer_Request_Date_CRD_ML__c,Current_Schedule_Date_CSD_ML__c,Current_CSD_ML_at_time_of_Submission__c , New_CRD_DPML__c, Lead_Time_Adder_Days__c, New_CSD_DPML__c,
                         Lot_Type__c, Request_Type_LR__c, Purchase_Order_Number_ML__c,Customer_Device_Id_ML__c,Current_Wafer_Quantity_in_the_Lot_ML__c,Current_CSD_at_Planner_Submission_Stage__c,
                         Manufacturing_Lot__r.Geometry__c,Sales_Order_Number_ML__c,Manufacturing_Lot__r.Account_Name__r.Name,Lot_Instruction__c.Account_LR__c 
                         from Lot_Instruction__c where id in :ulist];
       }else{
                qlist = [SELECT id, name,CreatedDate,Account__c,Lot_Request__r.Account__r.name,Lot_Request__r.Name, Manufacturing_Lot__r.name,Submitted_Customer_Request_Date_CRD__c,
                         Submitted_for_Review_CSR__c,ValidationSignals__c,Comments_CSR__c,New_CSD_P__c, Able_to_Support_Request_P__c,Expedite_Type_To_Meet_CRD_CSR__c,Lot_Request__r.Stage__c,
                         Comments_P__c,Lot_Request__c,Current_Customer_Request_Date_CRD_ML__c,Current_Schedule_Date_CSD_ML__c,  Current_CSD_ML_at_time_of_Submission__c , New_CRD_DPML__c, Lead_Time_Adder_Days__c, New_CSD_DPML__c,
                         Lot_Type__c, Request_Type_LR__c, Purchase_Order_Number_ML__c,Customer_Device_Id_ML__c,Current_Wafer_Quantity_in_the_Lot_ML__c,Current_CSD_at_Planner_Submission_Stage__c,
                         Manufacturing_Lot__r.Geometry__c,Sales_Order_Number_ML__c,Manufacturing_Lot__r.Account_Name__r.Name,Lot_Instruction__c.Account_LR__c 
                         from Lot_Instruction__c where Lot_Instruction__c.id =:lotRequestId];
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
       
       if (tlist.size() > 0) {
            this.firstLotInstructionSelected = tlist[0].getLotInstruction().Id;
       }
       
       return slist;
    }
    
    public void updateLotInst(){
    
    list<Lot_Instruction__c> updateLotInsts = new list<Lot_Instruction__c> ();
    for(lotInstWrapper lw: linstWrapList){
      
      if(lw.selected==true){
          
      if(lotIn.Submitted_Customer_Request_Date_CRD__c != null){
        lw.lInst.Submitted_Customer_Request_Date_CRD__c = lotIn.Submitted_Customer_Request_Date_CRD__c ;  
      }
      
      if(lotIn.New_CSD_P__c != null){
      lw.lInst.New_CSD_P__c=lotIn.New_CSD_P__c ;
      }
      updateLotInsts.add(lw.lInst);
      lw.selected=false;
     
      }
    
    }
       
        update updateLotInsts;
        lotIn.Submitted_Customer_Request_Date_CRD__c=null;
        lotIn.New_CSD_P__c=null;
    
    }
    
    
     public void saveLotInst(){
    
    list<Lot_Instruction__c> updateLotInsts = new list<Lot_Instruction__c> ();
    for(lotInstWrapper lw: linstWrapList){
      
      if(lw.selected==true){
      
      updateLotInsts.add(lw.lInst);
      lw.selected=false;
      }
    
    }
       
        update updateLotInsts;
    
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
           /*LIWrapper otherWrapper = (LIWrapper)compareTo;       
           Lot_Instruction__c other = otherWrapper.getLotInstruction();*/
           return -1;
        }
        
    }
    
    public class lotInstWrapper{
        public Lot_Instruction__c  lInst{get;set;}
        public Boolean selected {get; set;}
        Public String ErrorMessages{Get;set;}
        
        public lotInstWrapper(Lot_Instruction__c li,String Errors ){
            System.debug('_______Errors________'+Errors);
            lInst =li;
            ErrorMessages=Errors;
            selected= false;
            
            
        }
 
    }
    
    
    
}