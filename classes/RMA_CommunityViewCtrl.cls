public without sharing class RMA_CommunityViewCtrl {
    
    public List<RMARetInvWrapper> rmaRetWrapperList {get;set;}
    public RMAWrapper rmaWrapObj {get;set;}
    public String rmaId {get;set;}
    public boolean isFoundryView{get;set;}
    public boolean hasChangedUrl {get;set;}
    public RMA_CommunityViewCtrl(){
        rmaRetWrapperList = new List<RMARetInvWrapper>();
        rmaId = ApexPages.currentPage().getParameters().get('id');
        isFoundryView = userinfo.getUserType() != 'Standard';
        if(isFoundryView){
            getRMA();
            User userObj = [select accountId from user where id=:userInfo.getUserId()];
            hasChangedUrl = userObj.accountId != rmaWrapObj.CustomerId; 
            getRMAReturnInvoices();
        }
    }
     
    public void getRMA(){
         UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
         String rmaFields = util.getAllFields('RMA__c');  
         RMA__c rmaRec = database.query('select '+rmaFields+', Customer__r.name, Owner.name, createdby.name from RMA__c where id=:rmaId');
         rmaWrapObj = new RMAWrapper(rmaRec);
    }
    
    public void getRMAReturnInvoices(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaRetFields = util.getAllFields('RMA_Return_Invoice__c'); 
        for(RMA_Return_Invoice__c rmaRetInv : database.query('SELECT '+rmaRetFields+' FROM RMA_Return_Invoice__c WHERE RMA__c= :rmaId ORDER BY Name')){
            rmaRetWrapperList.add(new RMARetInvWrapper(rmaRetInv)); 
        }
    }
    
    public class RMAWrapper{
        public Id rmaId{get;set;}
        public string RMANumber{get;set;}
        public string RMAcategory {get;set;}
        public string Region{get;set;}
        public string stage {get;set;}
        public string Status{get;set;}
        public string OwnerName {get;set;}
        public string Product{get;set;}
        public string CreatedByName {get;set;}
        public Datetime CreatedDate {get;set;}
        public Datetime LastModifiedDate {get;set;}
        public String FabName{get;set;}
        public String CustomerName{get;set;}
        public String CustomerId{get;set;}
        public Datetime customerRequestedDate {get;set;}
        public String CN_DN_Number {get;set;}
        public Datetime CN_DN_Date {get;set;}
        public Datetime Approved_On_Regional_Recommendation{get;set;} 
        public Datetime approvedDate {get;set;}
        public Integer Total_Wafers_Final {get;set;}
        public Decimal Grand_Total_Final{get;set;}
        // sub-class initialization
        public RMAWrapper(RMA__c c){ 
            rmaId  = c.Id ;
            CustomerId = c.Customer__c;
            Approved_On_Regional_Recommendation = c.Approved_On_Regional_Recommendation__c;
            approvedDate = c.Closed_Date__c;
            Total_Wafers_Final = (Integer)c.Total_Wafers_Final__c;
            Grand_Total_Final = c.Grand_Total_Final__c;
            CN_DN_Number = c.CN_DN_Number__c;
            CN_DN_Date = c.CN_DN_Date__c;
            customerRequestedDate = c.customer_request_date__c;
            RMANumber = c.Name;
            CustomerName = c.Customer__r.Name;
            RMAcategory = c.RMA_Category__c;
            Region = c.Region__c;
            Stage = (c.Workflow_Stage__c == RMA_Constants.CLOSED_RMA || 
                     c.Workflow_Stage__c == RMA_Constants.PEN_SO_ISS || 
                     c.Workflow_Stage__c == RMA_Constants.PEN_CN_ISS) ? c.Workflow_Stage__c : 'Pending for Approval';
            OwnerName = c.Owner.Name;
            Product = c.Lot_Device_Risk_Production__c;
            CreatedByName = c.CreatedBy.Name;
            CreatedDate = c.CreatedDate;
            LastModifiedDate = c.LastModifiedDate;
            FabName = c.Fab__c;
            Status = c.Status__c;
        }
    }
    
    public class RMARetInvWrapper{
        public Decimal Adjusted_Unit_Price{get;set;}
        public Integer Bill_Quantity{get;set;}
        public String Customer_Id{get;set;}
        public String Device{get;set;}
        public Integer Die_Quantity{get;set;}
        public String Fab{get;set;}
        public String Fab_Code{get;set;}
        public Integer GDPW{get;set;}
        public String Intercompany_Customer_Name{get;set;}
        public String InvoiceId{get;set;}
        public String Invoice_Lot_Combination{get;set;}
        public String Invoice_Number{get;set;}
        public Date Invoice_Date{get;set;}
        public String Lot_Number{get;set;}
        public String Manufacturing_LotId{get;set;}
        public String Purchase_Order_Number{get;set;}
        public String Process{get;set;}
        public String RMAid{get;set;}
        public String RMA_Category{get;set;}
        public Date RMA_Finance_Approval_Date{get;set;}
        public String RMA_Number{get;set;}
        public Decimal Scrap_Limit{get;set;}
        public Decimal Total_Price{get;set;}
        public Decimal Total_Price_FAB_Validation{get;set;}
        public Decimal Total_Price_Final{get;set;}
        public Boolean Valid_Account{get;set;}
        public Boolean Valid_Fab{get;set;}
        public Decimal Wafer_Die_Unit_Price{get;set;}
        public String Wafer_Id_CSR_Submission{get;set;}
        public String Wafer_Id_Fab_In_Validated{get;set;}
        public String Wafer_Id_Fab_Validated{get;set;}
        public String Wafer_Id_Regional_Personnel_Not_Rec{get;set;}
        public String Wafer_Id_Regional_Personnel_Recommended{get;set;}
        public Integer Wafer_Quantity{get;set;}
        public Integer Total_Wfr_Qty_after_validation{get;set;}
        public Integer Final_RMA_Wfr_Qty_To_Issue_CN_SO{get;set;}
        public Decimal Wafer_Yield{get;set;}
        public Id rmaRetId{get;set;}
        
        public RMARetInvWrapper(RMA_Return_Invoice__c retInv){
            this.rmaRetId = retInv.id;
            this.Adjusted_Unit_Price = retInv.Adjusted_Unit_Price__c;
            this.Bill_Quantity = (Integer)retInv.Bill_Quantity__c;
            this.Customer_Id = retInv.Customer_Id__c;
            this.Device = retInv.Device__c;
            this.Die_Quantity = (Integer)retInv.Die_Quantity__c;
            this.Fab = retInv.Fab_Group__c;
            this.Fab_Code = retInv.Fab_Code__c;
            this.GDPW = (Integer)retInv.GDPW__c;
            this.Intercompany_Customer_Name = retInv.Intercompany_Customer_Name__c;
            this.InvoiceId = retInv.Invoice__c;
            this.Invoice_Lot_Combination = retInv.Invoice_Lot_Combination__c;
            this.Invoice_Number = retInv.Invoice_Number__c;
            this.Invoice_Date = retInv.Invoice_Date__c;
            this.Lot_Number = retInv.Lot_Number__c;
            this.Manufacturing_LotId = retInv.Manufacturing_Lot__c;
            this.Purchase_Order_Number = retInv.Purchase_Order_Number__c;
            this.Process = retInv.Process__c;
            this.RMAid = retInv.RMA__c; 
            this.RMA_Category = retInv.RMA_Category__c;
            this.RMA_Finance_Approval_Date = retInv.RMA_Finance_Approval_Date__c;
            this.RMA_Number = retInv.RMA_Number__c;
            this.Scrap_Limit = retInv.Scrap_Limit__c;
            this.Total_Price = retInv.Total_Price__c;
            this.Total_Price_FAB_Validation = retInv.Total_Price_FAB_Validation__c;
            this.Total_Price_Final = retInv.Total_Price_Final__c;
            this.Valid_Account = retInv.Valid_Account__c; 
            this.Valid_Fab = retInv.Valid_Fab__c;
            this.Wafer_Die_Unit_Price = retInv.Wafer_Die_Unit_Price__c;
            this.Wafer_Id_CSR_Submission = retInv.Wafer_Id_CSR_Submission__c;
            this.Wafer_Id_Fab_In_Validated = retInv.Wafer_Id_Fab_In_Validated__c;
            this.Wafer_Id_Fab_Validated = retInv.Wafer_Id_Fab_Validated__c;
            this.Wafer_Id_Regional_Personnel_Not_Rec = retInv.Wafer_Id_Regional_Personnel_Not_Rec__c;
            this.Wafer_Id_Regional_Personnel_Recommended = retInv.Wafer_Id_Regional_Personnel_Recommended__c;
            this.Wafer_Quantity = (Integer)retInv.Wafer_Quantity__c;
            this.Total_Wfr_Qty_after_validation = (Integer)retInv.Total_Wfr_Qty_after_validation__c;
            this.Final_RMA_Wfr_Qty_To_Issue_CN_SO = (Integer)retInv.Final_RMA_Wfr_Qty_To_Issue_CN_SO__c;
            this.Wafer_Yield = retInv.Wafer_Yield__c;
        }
    }
}