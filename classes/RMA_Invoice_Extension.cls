/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to insert/update the Line Item to the RMA request.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04-Oct-15      Created the Class
        Pradosh Samal  11-Oct-17      Changes for Case-00080412
**/
public with sharing class RMA_Invoice_Extension{
    
    String custName,fabName,rmaId,retInvIdToUpdate,sapAccNo;
    
    //External Variables
    public List<RMA_Return_Invoice__c> lstReturnInvoice{get;set;}
    public String waferIds{get;set;}
    public String invoiceNumber{get;set;}
    public String lotNumber{get;set;}
    public String RMAnumber{get;set;}
    public String adjustedPrice{get;set;}
    public String scrapLimit{get;set;}
    public String waferYield{get;set;}
    private String existingFormFactor{get;set;}
    public String existingFormFactorQty{get;set;}
    public String rmaBy{get;set;}
    public Integer size{get;set;} 
    public Integer noOfRecords{get; set;} 
    public String dieQuantity{get;set;}
    public string modQuantity{get;set;}
    public Boolean fetchDisable{get;set;}
    public Boolean displayInvDetail{get;set;}
    public SelectOption[] leftOptions {get;set;}
    public SelectOption[] rightOptions{get;set;}
    public InvoiceWrapper selectedInvWrap{get;set;}
    public string RItoDelete{get;set;}
    public boolean isFab9or10{get;set;}
    public string reasonCode{get;set;}
    private String invoiceSOQLLimit = '1000';
    
    //Internal Variables
    public List<InvoiceWrapper> lstInvoiceWrapperRecs = new List<InvoiceWrapper>();
    
    //Wrapper class for Invoice record selection
    public class InvoiceWrapper{
        public Invoice__c invoiceRec{get;set;}
        public boolean isChecked{get;set;}
        public boolean isIntercompany{get;set;}
        public InvoiceWrapper(Invoice__c inv,Boolean value, boolean isIC){
            invoiceRec = inv;
            isChecked  = value;
            isIntercompany = isIC;
        }
    }
    
    //Constructor
    public RMA_Invoice_Extension(ApexPages.StandardController controller){
        fabName  = Apexpages.currentpage().getparameters().get('fabName');
        custName = Apexpages.currentpage().getparameters().get('custName');
        sapAccNo = Apexpages.currentpage().getparameters().get('sapAccNo');
        rmaId    = Apexpages.currentpage().getparameters().get('RMA');
        rmaBy    = Apexpages.currentpage().getparameters().get('RMABy');
        fetchDisable = false;
        displayInvDetail = false;
        isFab9or10 = false;
        leftoptions = new List<SelectOption>();
        rightoptions= new List<SelectOption>();
        selFormFactor = '';
        isFab9or10 = RMA_Utility.checkFab9or10(fabName);
        reasonCode = '';
        
        List<RMA__c> rmaRec = [SELECT Name,ReasonCode__c FROM RMA__c WHERE Id=:rmaId limit 1];
        RMAnumber = !rmaRec.isEmpty()? rmaRec[0].Name:NULL;
        reasonCode = !rmaRec.isEmpty()? rmaRec[0].ReasonCode__c:NULL;
        
        lstReturnInvoice = queryReturnInvoice();
        
        Environment_Variable__c envVar = Environment_Variable__c.getInstance('RMA_INVOICE_SOQL_LIMIT');
        if(envVar != NULL){
            invoiceSOQLLimit = envVar.Value__c;
        } 
    }
    
    //Prepare setController to retrieve Invoice records
    public ApexPages.StandardSetController setCon{
        get{
            if(setCon == null){
                size = 10;
                
                String queryString = formInvoiceSOQL();
                
                queryString += ' ORDER BY Invoice_Number__c LIMIT ' + invoiceSOQLLimit;
                System.debug('queryString : ' + queryString);
                
                setCon = new ApexPages.StandardSetController(Database.Query(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();   
            }
            return setCon;
        }
        public set;
    }
    
    //Initialize setCon and return a list of records
    public List<InvoiceWrapper> getInvoiceWrapperRecords() {
        lstInvoiceWrapperRecs.clear();
        String wIds = '';
        if(!String.isEmpty(waferIds)){
            system.debug('@@@@@@@@@S@E@A@R@C@H@V@A@L@U@E@@@@@@@@@'+waferIds);
        }
        for(Invoice__c inv : (List<Invoice__c>) setCon.getRecords()){
       
            if(!String.isEmpty(wIds)){
               
                if(!String.isEmpty(inv.Wafer_Id__c) && inv.Wafer_Id__c.contains(wIds)){
                   
                    lstInvoiceWrapperRecs.add(new InvoiceWrapper(inv,false,inv.Intercompany__c));
                }
            }
            else{
                
                lstInvoiceWrapperRecs.add(new InvoiceWrapper(inv,false,inv.Intercompany__c));
                
            }
        }
        
        return lstInvoiceWrapperRecs;
    }
    
    //Method for searching the Invoice Records based on the Lot Number or Invoice Number
    public pageReference SearchInvoice(){
        fetchDisable = false;
        displayInvDetail = false;
        clearValues();
        lstInvoiceWrapperRecs.clear();
        
        String queryString = formInvoiceSOQL();
        
        if(invoiceNumber  != NULL && invoiceNumber != ''){
            
            queryString += ' AND Invoice_Number__c LIKE \'' + invoiceNumber + '%\'';
        }
        if(lotNumber != NULL && lotNumber != ''){
            
            queryString += ' AND Lot_Name__c LIKE \'' + lotNumber + '%\'';
        }
        if(waferIds!= NULL && waferIds!= ''){
             
            queryString += ' AND Wafer_Id__c INCLUDES (:waferIds)';
        }
        
        queryString += ' ORDER BY Invoice_Number__c LIMIT ' + invoiceSOQLLimit;
                    
        setCon = new ApexPages.StandardSetController(Database.Query(queryString));
        System.debug('queryString : '+ queryString);
        setCon.setPageSize(size);
        system.debug('*******A*S*M*P*L*A*****'+setCon);
        noOfRecords = setCon.getResultSize();
        return NULL;
    }
    
    //Method to fetch the details of the selected Invoice
    public pageReference FetchDetail(){
        boolean anySelected = false;
        leftoptions.clear();
        rightoptions.clear();
       
        for(InvoiceWrapper invWrap: lstInvoiceWrapperRecs){
            if(invWrap.isChecked){
                anySelected = true;
                selectedInvWrap = invWrap;
                break;
            }
        }
        
        if(!anySelected){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select atleast one Invoice'));
        }else{
            fetchDisable = true;
            displayInvDetail = true;
        }
        
        if(selectedInvWrap != NULL && selectedInvWrap.invoiceRec.Wafer_Id__c != NULL && selectedInvWrap.invoiceRec.Wafer_Id__c != ''){            
            for(String waferIdAvailable: selectedInvWrap.invoiceRec.Wafer_Id__c.split(';')){
                leftoptions.add(new SelectOption(waferIdAvailable,waferIdAvailable));
            }
        }
        return NULL;
    }
    
    //Method for Inserting Line Item
    public pageReference InsertReturnInvoice(){
        try{
            displayInvDetail = false;            
            if(rightOptions.isEmpty() && rmaBy != 'Module' && (rmaBy != 'Die' || selectedInvWrap.invoiceRec.Item_Type__c == 'SD')){
                displayInvDetail = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one wafer.'));
                return NULL;
            }
            if(rmaBy == 'Die' && dieQuantity == ''){
                displayInvDetail = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill in Die Quantity.'));
                return NULL;
            }else if(rmaBy == 'Module' && modQuantity == ''){
                displayInvDetail = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill in Module Quantity.'));
                return NULL;
            }
            RMA_Return_Invoice__c retInv = new RMA_Return_Invoice__c();
            retInv.RMA__c                 = rmaId;
            retInv.Invoice__c             = selectedInvWrap.invoiceRec.Id;
            retInv.Wafer_Die_Unit_Price__c= selectedInvWrap.invoiceRec.Unit_Selling_Price__c;
            retInv.Bill_Quantity__c       = selectedInvWrap.invoiceRec.Bill_Quantity__c;
            retInv.Device__c              = selectedInvWrap.invoiceRec.Part_Number__c;
            retInv.Cust_Part_Num__c       = selectedInvWrap.invoiceRec.Cust_Part_Num__c;
            retInv.Invoice_Date__c        = selectedInvWrap.invoiceRec.Invoice_Date__c;
            retInv.Invoice_Number__c      = selectedInvWrap.invoiceRec.Invoice_Number__c;
            retInv.Lot_Number__c          = selectedInvWrap.invoiceRec.Lot_Name__c;
            retInv.Process__c             = selectedInvWrap.invoiceRec.Process_Name__c;
            retInv.Purchase_Order_Number__c= selectedInvWrap.invoiceRec.Purchase_Order_Number__c;
            retInv.Die_Selling_Price__c   = selectedInvWrap.invoiceRec.Die_Selling_Price__c;
            retInv.RMA_By__c              = rmaBy;
            retInv.Fab_Group__c           = selectedInvWrap.invoiceRec.Fab_Group__c;
            retInv.Business_Unit__c       = selectedInvWrap.invoiceRec.Business_Unit__c;
            retInv.Product_Line__c        = selectedInvWrap.invoiceRec.Product_Line__c;
            if(dieQuantity != NULL && dieQuantity != ''){
                retInv.Die_Quantity__c = decimal.valueOf(dieQuantity);
            }
            if(modQuantity != NULL && modQuantity != ''){
                retInv.Module_Quantity__c = decimal.valueOf(modQuantity);
            }
            
            if(waferYield != NULL && waferYield != ''){
                retInv.Wafer_Yield__c = decimal.valueOf(waferYield);
            }
            //++ NJain-24Jun16-New fields to be captured for R81
            if(selFormFactor != NULL && selFormFactor != ''){
                retInv.Existing_Form_Factor__c = selFormFactor;
            }else{
                retInv.Existing_Form_Factor__c = '';
            }
            if(existingFormFactorQty != NULL && existingFormFactorQty != ''){
                retInv.Existing_Form_Factor_Quantity__c = decimal.valueOf(existingFormFactorQty);
            }else{
                retInv.Existing_Form_Factor_Quantity__c = NULL;
            }
            //--NJain-24Jun16-New fields to be captured for R81
            
            if(adjustedPrice != NULL && adjustedPrice != ''){
                retInv.Adjusted_Unit_Price__c = decimal.valueOf(adjustedPrice);
            }else{
                retInv.Adjusted_Unit_Price__c = NULL;
            }
            
            if(scrapLimit != NULL && scrapLimit != ''){
                retInv.Scrap_Limit__c         = decimal.valueOf(scrapLimit);
            }
            
            string selWafersCSR = '';
            for(SelectOption so: rightOptions){
                selWafersCSR += so.getValue() + '; ';
            }
            if(!RMA_Utility.checkFab9or10(selectedInvWrap.invoiceRec.Fab_Group__c)){
                retInv.Wafer_Id_CSR_Submission__c = selWafersCSR;
            }else{
                retInv.Wafer_Id_Fab_9_10_CSR_Submission__c = selWafersCSR;
            }
            
            if(RItoDelete != '' && RItoDelete != NULL){
                retInv.Id = RItoDelete;
                update retInv;
                RItoDelete = '';
            }else{
                insert retInv;
            }
            
            clearValues(); //Clear the form data after insertion of Return Invoice
            lstReturnInvoice.clear();
            lstReturnInvoice = queryReturnInvoice();
            
        }catch(Exception e){
            displayInvDetail = true;
            if(e.getMessage().containsIgnoreCase('duplicate_value')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                'Return Invoice already exists in the same RMA with selected Invoice/Lot Number. '+
                'Please edit the same to change the wafers.'));
            }else if(e.getMessage().containsIgnoreCase('has already been entered')){
                //do nothing- Error message will be thrown from the Trigger itself.
            }else if(e.getMessage().containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                //do nothing- Error message will be thrown from the Validation Rule itself.
            }else if(e.getMessage().containsIgnoreCase('INVALID')){ //throw standard field validation message
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Some Error Occurred.'));
            }
        }
        return NULL;
    }
    
    //cleaer the form data values
    public void clearValues(){
        rightOptions.clear();
        adjustedPrice = '';
        scrapLimit = '';
        waferYield = '';
        selFormFactor = NULL;
        dieQuantity= NULL;
        modQuantity= NULL;
        existingFormFactor = NULL;
        existingFormFactorQty = NULL;
    }
    
    // handle the deletion of Return Invoice
    public PageReference DeleteReturnInvoice() {
        database.delete(new RMA_Return_Invoice__c(id=RItoDelete));
        lstReturnInvoice = queryReturnInvoice();
        RItoDelete = '';
        return null;
    }
    
    // handle the editing of Return Invoice
    public PageReference EditReturnInvoice() {
        for(RMA_Return_Invoice__c retInvToEdit: [SELECT Id,RMA__c,Wafer_Die_Unit_Price__c,Wafer_Id_CSR_Submission__c, Fab_Group__c,
                                                     Adjusted_Unit_Price__c,Total_Price__c,Wafer_Quantity__c,RMA__r.Customer__c,
                                                     Bill_Quantity__c,Device__c,Invoice_Date__c,Invoice_Number__c,Cust_Part_Num__c,
                                                     Lot_Number__c,Process__c,Purchase_Order_Number__c,Scrap_Limit__c,Wafer_Yield__c,
                                                     Invoice__r.Wafer_Id__c,Invoice__r.Intercompany__c,Die_Quantity__c,GDPW__c,
                                                     Die_Selling_Price__c,CreatedById,RMA__r.Workflow_Stage__c,Invoice__r.Item_Type__c,
                                                     Wafer_Id_Fab_9_10_CSR_Submission__c,Invoice__r.Fab_Group__c,Module_Quantity__c,
                                                     Existing_Form_Factor_Quantity__c,Existing_Form_Factor__c,Business_Unit__c,Product_Line__c
                                                 FROM RMA_Return_Invoice__c 
                                                 WHERE Id = :RItoDelete limit 1]){
            Invoice__c inv = new Invoice__c();
            inv.Id                     = retInvToEdit.Invoice__c;
            inv.Unit_Selling_Price__c  = retInvToEdit.Wafer_Die_Unit_Price__c;
            inv.Part_Number__c         = retInvToEdit.Device__c;
            inv.Cust_Part_Num__c       = retInvToEdit.Cust_Part_Num__c;
            inv.Invoice_Date__c        = retInvToEdit.Invoice_Date__c;
            inv.Invoice_Number__c      = retInvToEdit.Invoice_Number__c;
            inv.Lot_Name__c            = retInvToEdit.Lot_Number__c;
            inv.Process_Name__c        = retInvToEdit.Process__c;
            inv.Purchase_Order_Number__c= retInvToEdit.Purchase_Order_Number__c;
            inv.Bill_Quantity__c       = retInvToEdit.Bill_Quantity__c;
            inv.Customer_Name__c       = retInvToEdit.RMA__r.Customer__c;
            inv.GDPW__c                = retInvToEdit.GDPW__c;
            inv.Die_Selling_Price__c   = retInvToEdit.Die_Selling_Price__c;
            inv.Item_Type__c           = retInvToEdit.Invoice__r.Item_Type__c;
            inv.Fab_Group__c           = retInvToEdit.Invoice__r.Fab_Group__c;
            inv.Business_Unit__c       = retInvToEdit.Business_Unit__c;
            inv.Product_Line__c        = retInvToEdit.Product_Line__c;
            clearValues();
            leftoptions.clear();
            
            adjustedPrice = String.valueOf(retInvToEdit.Adjusted_Unit_Price__c);
            scrapLimit = String.valueOf(retInvToEdit.Scrap_Limit__c);
            waferYield = String.valueOf(retInvToEdit.Wafer_Yield__c);
            dieQuantity= String.valueOf(retInvToEdit.Die_Quantity__c);
            modQuantity= String.valueOf(retInvToEdit.Module_Quantity__c);
            existingFormFactorQty = String.valueOf(retInvToEdit.Existing_Form_Factor_Quantity__c);
            selFormFactor = retInvToEdit.Existing_Form_Factor__c;
            
            if( rmaBy != 'Module' && (rmaBy != 'Die' || retInvToEdit.Invoice__r.Item_Type__c == 'SD') ){
                
                //Prepare the Left Options (Not Selected or remaining ones)
                Set<String> setAllOptions = new Set<String>();
                setAllOptions.addAll(retInvToEdit.Invoice__r.Wafer_Id__c.split(';'));
                
                //if(retInvToEdit.Fab_Group__c != 'FAB 9' && retInvToEdit.Fab_Group__c != 'FAB 10'){
                if(!RMA_Utility.checkFab9or10(retInvToEdit.Fab_Group__c)){
                    if(retInvToEdit.Wafer_Id_CSR_Submission__c != NULL){
                        //Prepare the Right Options (Selected already)
                        for(String waferIdSelected: retInvToEdit.Wafer_Id_CSR_Submission__c.split(';')){
                            rightOptions.add(new SelectOption(waferIdSelected,waferIdSelected));
                        }
                        //Prepare the Left Options (Not Selected or remaining ones)
                        setAllOptions.removeAll(retInvToEdit.Wafer_Id_CSR_Submission__c.split(';'));
                    }
                }else{
                    if(retInvToEdit.Wafer_Id_Fab_9_10_CSR_Submission__c != NULL){
                        //Prepare the Right Options (Selected already)
                        for(String waferIdSelected: retInvToEdit.Wafer_Id_Fab_9_10_CSR_Submission__c.split(';')){
                            rightOptions.add(new SelectOption(waferIdSelected,waferIdSelected));
                        }
                        //Prepare the Left Options (Not Selected or remaining ones)
                        for(String wfrId: retInvToEdit.Wafer_Id_Fab_9_10_CSR_Submission__c.split(';')){
                            setAllOptions.remove(wfrId.trim());
                        }
                    }
                }
                for(String waferIdAvailable: setAllOptions){
                    leftoptions.add(new SelectOption(waferIdAvailable,waferIdAvailable));
                }
            }
            selectedInvWrap = new InvoiceWrapper(inv,false,retInvToEdit.Invoice__r.Intercompany__c);
        }
        fetchDisable = true;
        displayInvDetail = true;
        
        return null;
    }
    
    public List<RMA_Return_Invoice__c> queryReturnInvoice(){
        return RMA_Utility.QueryLineItemsSystemMode(rmaId);
    }
    
    public PageReference ReturnToRMA(){
        return new PageReference('/apex/RMA_Edit?id='+rmaId);
    }
    
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
 
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    public string selFormFactor{get;set;}
    public List<SelectOption> getFormFactors(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = RMA_Return_Invoice__c.Existing_Form_Factor__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('','--None--'));
        for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    private String formInvoiceSOQL(){
        
        String queryFields =  'Id, Name, Bill_Quantity__c, Customer_Name__c, Customer_Number__c, Fab_Code__c, Fab_Group__c, GDPW__c, Cust_Part_Num__c, Intercompany_Customer_Name__c, Intercompany_Fab__c, Invoice_Date__c, Invoice_Number__c, Item_Type__c, Part_Number__c, Process_Name__c, Purchase_Order_Number__c, Sales_Order_Number__c, Business_Unit__c, Unit_Selling_Price__c, Wafer_Id__c, Intercompany__c, Lot_Name__c, Die_Selling_Price__c,Product_Line__c';
        
        String query = 'SELECT ' + queryFields + ' FROM Invoice__c WHERE Id != NULL';
        
        //Check for blank Customer Number or SAP Account Number
        if(custName != NULL && custName != '' && custName != 'null'){
            query += ' AND Customer_Name__r.Customer_Number__c = \''+ custName + '\'';
        }
        else{
            query += ' AND Customer_Name__r.SAP_Account_Number__c = \'' + sapAccNo + '\'';
        }
        
        query += ' AND Fab_Group__c = \''+ fabName +'\'';
        
        if(rmaBy != NULL && rmaBy != '  '){
            if(rmaBy == 'Wafer'){
                
                query += ' AND Item_Type__c NOT IN (\'TK\',\'SD\',\'MOD\',\'DEV\')';
            }
            else if(rmaBy == 'Die'){
                
                query += ' AND ( Item_Type__c IN (\'TK\',\'DEV\') OR Part_Number__c LIKE \'%*%\') ';
            }
            else if(rmaBy == 'Module'){
                
                query += ' AND ( Item_Type__c IN (\'MOD\') ) ';
            }
        }
        
        return query;
    }
}