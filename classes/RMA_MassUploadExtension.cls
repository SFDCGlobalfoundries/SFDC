/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the extension class for RMA_MassUpload page.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    21-Oct-15      Created the Class
**/
public class RMA_MassUploadExtension{

    //variables for loading data from the file uploaded
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public string templateId{get;set;}
    
    //variables of the Wrapper to show for Line Items
    public List<RMARI> lstRMARIwrapper{get;set;}
    public string WaferToEdit{get;set;}
    public string LotInvToEdit{get;set;}
    public string InvNumToEdit{get;set;}
    public string adjustedPrice{get;set;}
    public string waferYield{get;set;}
    public string scrapLimit{get;set;}
    public string dieQuantity{get;set;}
    public string modQuantity{get;set;}
    public string formFactor{get;set;}
    public string formFactorQuantity{get;set;}
    public string itemType{get;set;}
    
    public Map<String,RMARI> mapRMARIwrapper{get;set;}
    @Testvisible
    RMA__c RMArecord = new RMA__c();
    List<String> lstLotInvoice;
    
    //Constructor
    public RMA_MassUploadExtension(ApexPages.StandardController controller){        
        RMArecord   = (RMA__c)controller.getRecord();
        csvFileLines    = new String[]{};
        lstLotInvoice   = new List<String>();
        lstRMARIwrapper = new List<RMARI>();
        mapRMARIwrapper = new Map<String,RMARI>();        
        leftOptions  = new List<SelectOption>();
        rightOptions = new List<SelectOption>();
        WaferToEdit  = '';
        LotInvToEdit = '';
        InvNumToEdit = '';
        showPopUp    = false;
        
        if(controller.getId() == NULL){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No RMA record found.'));
        }
        
        List<ContentDocument> contentDoc = [SELECT Id,Title,LatestPublishedVersionId
                                FROM ContentDocument where Title = 'RMA-CSV-Import-Format' limit 1];
        if(contentDoc != NULL && !contentDoc.isEmpty()){
            templateId = contentDoc[0].LatestPublishedVersionId;
        }
    }
    
    //Wrapper class for Line Items to be uploaded
    public class RMARI{
        public boolean isSelected{get;set;}
        public string WaferNotSelected{get;set;}
        public decimal UnitPrice{get;set;}
        public decimal AdjtPrice{get;set;}
        public RMA_Return_Invoice__c rmaInv{get;set;}
        public boolean isIntercompany{get;set;}
        public string itemType{get;set;}
        public RMARI(RMA_Return_Invoice__c  r, boolean isIC, string iType){
            rmaInv = r;
            UnitPrice = r.Wafer_Die_Unit_Price__c;
            AdjtPrice = r.Adjusted_Unit_Price__c;
            isSelected = true;
            WaferNotSelected = '';
            isIntercompany = isIC;
            itemType = iType;
        }
    }
    
    //Method to Parse the uploaded file and prepare the line item as wrapper records.
    public PageReference importCSVFile(){
       lstLotInvoice.clear();
       map<String,List<String>> mapLotInvoiceDetails = new map<String,List<String>>();
       List<Invoice__c> lstLotWithDifAccountName = new List<Invoice__c>();
       //List<Invoice__c> lstLotWithDifFabName     = new List<Invoice__c>();
       List<Invoice__c> lstLotWithDifItemType    = new List<Invoice__c>();
       
       lstRMARIwrapper.clear();
       mapRMARIwrapper.clear();
       try{
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            for(Integer i=1;i<csvFileLines.size();i++){      
                
                String currentCSVline = csvFileLines[i];
                currentCSVline = csvFileLines[i].replaceAll(',,',',BLANK,').replace(',,',',BLANK,');                
                if(currentCSVline.endsWith(',')){
                    currentCSVline += 'BLANK';
                }
                
                List<String> csvRecordData = new List<String>();
                for(String str: currentCSVline.split(',')){
                    if(str != 'BLANK'){
                        csvRecordData.add(str);
                    }else{
                        csvRecordData.add('');
                    }
                }
                lstLotInvoice.add(csvRecordData[0].trim());
                mapLotInvoiceDetails.put(csvRecordData[0].trim(),csvRecordData);
            }
            
            Set<String> setUniqueLotInv = new Set<String>();
            setUniqueLotInv.addAll(lstLotInvoice);
            if(csvFileLines.size()>101){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can upload maximum of 100 lots at a time'));
                return NULL;
            }else if(lstLotInvoice.size() != setUniqueLotInv.size()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Sheet contains duplicate Lot Ids. Please correct and re-upload.'));
                return NULL;
            }else{            
                List<Invoice__c> lstMfgLot = [SELECT Id,Name,Bill_Quantity__c,Customer_Name__c,Customer_Number__c,Fab_Group__c,
                                                  GDPW__c,Intercompany_Customer_Name__c,Intercompany_Fab__c,Invoice_Date__c,Fab_Code__c,
                                                  Invoice_Number__c,Item_Type__c,Part_Number__c,Process_Name__c,Business_Unit__c,Product_Line__c,
                                                  Purchase_Order_Number__c,Sales_Order_Number__c,Unit_Selling_Price__c,Wafer_Id__c,
                                                  Customer_Name__r.Name ,Intercompany__c,Lot_Name__c,Die_Selling_Price__c,Cust_Part_Num__c
                                              FROM Invoice__c
                                              WHERE Lot_Name__c in: lstLotInvoice
                                              ORDER BY Lot_Name__c];
                
                //Method to check for inconsistent data
                for(Invoice__c invData : lstMfgLot){
                    // Check if the invoice belongs to different account
                    if(invData.Customer_Name__c != RMArecord.Customer__c){
                        lstLotWithDifAccountName.add(invData);
                    }
                    // Check if the invoice is added by Wafer or Die and then filter based on Item Type
                    if(RMArecord.RMA_By__c.equalsIgnoreCase('Die')){
                        if(invData.Item_Type__c != 'TK' && invData.Part_Number__c !=NULL && !invData.Part_Number__c.contains('*') && invData.Item_Type__c != 'DEV'){
                            lstLotWithDifItemType.add(invData);
                        }
                    }else if(RMArecord.RMA_By__c.equalsIgnoreCase('Wafer')){
                        if(invData.Item_Type__c == 'SD' || invData.Item_Type__c == 'TK' || invData.Item_Type__c == 'DEV' || invData.Item_Type__c == 'MOD'){
                            lstLotWithDifItemType.add(invData);
                        }
                    }else if(RMArecord.RMA_By__c.equalsIgnoreCase('Module')){
                        if(invData.Item_Type__c != 'MOD'){
                            lstLotWithDifItemType.add(invData);
                        }
                    }
                }
                //This will throw error message if the lots belonging to different Account exists in the file as of the RMA
                if(!lstLotWithDifAccountName.isEmpty()){
                    string errorMsg = '';
                    integer i=1;
                    for(Invoice__c mfgLot: lstLotWithDifAccountName){
                        errorMsg += string.valueOf(i) + '. '+ mfgLot.Lot_Name__c + ' -->' + 
                                    '<a href="/'+mfgLot.Customer_Name__c+'">'+ mfgLot.Customer_Name__r.Name+'</a>.<br/>';
                        i++;
                    }
                    errorMsg += 'Please remove these lots from the file and try again.';
                    ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,
                        'Following Lots belongs to the different Customer:<br/>'+errorMsg);
                    ApexPages.addMessage(errorMessage);
                    return NULL;
                }
                                
                //This will throw error message if the lots belonging to different Item type are inserted.
                if(!lstLotWithDifItemType.isEmpty()){
                    string errorMsg= 'Following Lot IDs are not correct for selected <i>RMA By</i> for the given RMA. Please upload only <i><b>'+ RMArecord.RMA_By__c + '</b></i> related Lot Ids.<br/>';
                    integer i=1;
                    for(Invoice__c mfgLot: lstLotWithDifItemType){
                        errorMsg += string.valueOf(i) + '. ' + mfgLot.Lot_Name__c + '<br/>';
                        i++;
                    }
                    errorMsg += 'Please remove these lots from the file and try again.';
                    ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,errorMsg);
                    ApexPages.addMessage(errorMessage);
                    return NULL;
                }
                
                //prepare the final data if no erroneous records
                for(Invoice__c invData : lstMfgLot){
                    RMA_Return_Invoice__c rmaInvoiceObj = new RMA_Return_Invoice__c();
                    rmaInvoiceObj.Lot_Number__c     = invData.Lot_Name__c;
                    rmaInvoiceObj.Bill_Quantity__c  = invData.Bill_Quantity__c;
                    rmaInvoiceObj.Device__c         = invData.Part_Number__c;
                    rmaInvoiceObj.Cust_Part_Num__c  = invData.Cust_Part_Num__c;
                    rmaInvoiceObj.Invoice_Number__c = invData.Invoice_Number__c;
                    rmaInvoiceObj.Invoice_Date__c   = invData.Invoice_Date__c;
                    rmaInvoiceObj.Process__c        = invData.Process_Name__c;
                    rmaInvoiceObj.Wafer_Die_Unit_Price__c    = invData.Unit_Selling_Price__c;
                    rmaInvoiceObj.Die_Selling_Price__c = invData.Die_Selling_Price__c;
                    rmaInvoiceObj.Purchase_Order_Number__c   = invData.Purchase_Order_Number__c;
                    
                    if(mapLotInvoiceDetails.get(invData.Lot_Name__c)[1] != NULL && 
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[1].trim() != ''){
                        rmaInvoiceObj.Adjusted_Unit_Price__c     = Decimal.valueOf(mapLotInvoiceDetails.get(invData.Lot_Name__c)[1].trim());
                    }
                    if(mapLotInvoiceDetails.get(invData.Lot_Name__c)[2].trim() != NULL &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[2].trim() != ''){
                        rmaInvoiceObj.Scrap_Limit__c             = Decimal.valueOf(mapLotInvoiceDetails.get(invData.Lot_Name__c)[2].trim());
                    }
                    if(mapLotInvoiceDetails.get(invData.Lot_Name__c)[3].trim() != NULL &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[3].trim() != ''){
                        rmaInvoiceObj.Wafer_Yield__c             = Decimal.valueOf(mapLotInvoiceDetails.get(invData.Lot_Name__c)[3].trim());
                    }
                    if(RMArecord.RMA_By__c.equalsIgnoreCase('Die') &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[4].trim() != NULL &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[4].trim() != ''){
                        rmaInvoiceObj.Die_Quantity__c            = Decimal.valueOf(mapLotInvoiceDetails.get(invData.Lot_Name__c)[4].trim());
                    }
                    if(RMArecord.RMA_By__c.equalsIgnoreCase('Module') &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[5].trim() != NULL &&
                       mapLotInvoiceDetails.get(invData.Lot_Name__c)[5].trim() != ''){
                        rmaInvoiceObj.Module_Quantity__c         = Decimal.valueOf(mapLotInvoiceDetails.get(invData.Lot_Name__c)[5].trim());
                    }
                    if( RMArecord.RMA_By__c.equalsIgnoreCase('Wafer') || invData.Item_Type__c == 'SD'){
                        if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                            rmaInvoiceObj.Wafer_Id_CSR_Submission__c = invData.Wafer_Id__c;
                        }else{
                            if(invData.Wafer_Id__c.substring(invData.Wafer_Id__c.length()-1,invData.Wafer_Id__c.length()) != ';'){
                                invData.Wafer_Id__c = invData.Wafer_Id__c + ';';
                            }
                            rmaInvoiceObj.Wafer_Id_Fab_9_10_CSR_Submission__c = invData.Wafer_Id__c.replaceAll(';','; ');
                        }
                    }
                    if(invData.Item_Type__c == 'SD' && (rmaInvoiceObj.Die_Quantity__c == NULL || rmaInvoiceObj.Die_Quantity__c ==0)){
                        rmaInvoiceObj.Die_Quantity__c = invData.Bill_Quantity__c;
                    }
                    if(invData.Item_Type__c == 'MOD' && (rmaInvoiceObj.Module_Quantity__c == NULL || rmaInvoiceObj.Module_Quantity__c ==0)){
                        rmaInvoiceObj.Module_Quantity__c = invData.Bill_Quantity__c;
                    }
                    
                    rmaInvoiceObj.Invoice__c = invData.Id;
                    rmaInvoiceObj.RMA_By__c  = RMArecord.RMA_By__c;
                    rmaInvoiceObj.Fab_Group__c = invData.Fab_Group__c;
                    rmaInvoiceObj.Business_Unit__c = invData.Business_Unit__c;
                    rmaInvoiceObj.Product_Line__c  = invData.Product_Line__c;
                    
                    RMARI rmaRIwrapper = new RMARI(rmaInvoiceObj,invData.Intercompany__c,invData.Item_Type__c);
                    lstRMARIwrapper.add(rmaRIwrapper);
                    mapRMARIwrapper.put(invData.Lot_Name__c + '-' + invData.Invoice_Number__c,rmaRIwrapper);
                }
            }
        }
        catch(Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data. Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
        return NULL;
    }
    
    
    //Populate Lot Numbers in respective fields for selection
    public SelectOption[] leftOptions{get;set;}
    public SelectOption[] rightOptions{get;set;}
    public boolean showPopUp{get;set;}
    
    //Method to make any change in Scrap Limit/ Wafer Yield/ DieQuantity/ModuleQuantity/formFactor/formFactorQuantity/Adjusted Price for any of the item uplaoded through CSV
    public PageReference EditLotInfo(){
        showPopUp = True;        
        if(WaferToEdit != NULL){
            for(String str: WaferToEdit.split(';')){
                rightOptions.add(new SelectOption(str,str));
            }
        }
        if(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit) != NULL){
            adjustedPrice = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Adjusted_Unit_Price__c);
            waferYield    = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Wafer_Yield__c);
            scrapLimit    = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Scrap_Limit__c);
            dieQuantity   = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Die_Quantity__c);
            modQuantity   = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Module_Quantity__c);
            itemType      = mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).itemType;
            formFactor    = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor__c);
            formFactorQuantity = string.valueOf(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor_Quantity__c);
        }        
        if(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).WaferNotSelected != NULL){
            for(String str: mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).WaferNotSelected.split(';')){
                if(str != NULL && str != ''){
                    leftOptions.add(new SelectOption(str,str));
                }
            }
        }        
        return null;
    }
    
    //Method to update the line item with the desired overridden information.
    public PageReference UpdateLineItems(){
        try{
            string selLots = '';
            string unselLots = '';
            if(RMArecord.RMA_By__c == 'Wafer' || itemType == 'SD'){
                if(!rightOptions.isEmpty()){
                    for(SelectOption so: rightOptions){
                        selLots += so.getValue() + ';';
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one wafer.'));
                    return NULL;
                }
            }
            if(
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(adjustedPrice)) || String.isEmpty(adjustedPrice)) &&
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(waferYield)) || String.isEmpty(waferYield)) &&
               (Pattern.matches('^[0-9]\\d*(\\.\\d+)?$',string.valueOf(scrapLimit)) || String.isEmpty(scrapLimit)) &&
               (RMArecord.ReasonCode__c == 'R81'? (Pattern.matches('^[1-9]\\d*(\\.\\d+)?$',string.valueOf(formFactorQuantity)) || String.isEmpty(formFactorQuantity)):True)
            ){
                for(SelectOption so: leftOptions){
                    unselLots += so.getValue() + ';';
                }
                if(mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit) != NULL){
                    
                    if(adjustedPrice != NULL && adjustedPrice != '' && decimal.valueOf(adjustedPrice) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Adjusted_Unit_Price__c = decimal.valueOf(adjustedPrice);
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).AdjtPrice                     = decimal.valueOf(adjustedPrice);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Adjusted_Unit_Price__c = NULL;
                    }
                    
                    if(waferYield != NULL && waferYield != '' && decimal.valueOf(waferYield) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Wafer_Yield__c = decimal.valueOf(waferYield);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Wafer_Yield__c = NULL;
                    }
                    
                    if(scrapLimit != NULL && scrapLimit != '' && decimal.valueOf(scrapLimit) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Scrap_Limit__c = decimal.valueOf(scrapLimit);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Scrap_Limit__c = NULL;
                    }

                    if(dieQuantity != NULL && dieQuantity != '' && decimal.valueOf(dieQuantity) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Die_Quantity__c = decimal.valueOf(dieQuantity);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Die_Quantity__c = NULL;
                    }
                    
                    if(modQuantity != NULL && modQuantity != '' && decimal.valueOf(modQuantity) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Module_Quantity__c = decimal.valueOf(modQuantity);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Module_Quantity__c = NULL;
                    }
                    
                    if(formFactorQuantity != NULL && formFactorQuantity != '' && decimal.valueOf(formFactorQuantity) != 0){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor_Quantity__c = decimal.valueOf(formFactorQuantity);
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor_Quantity__c = NULL;
                    }
                    
                    if(formFactor != NULL && formFactor != ''){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor__c = formFactor;
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Existing_Form_Factor__c = NULL;
                    }
                    
                    if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Wafer_Id_CSR_Submission__c = selLots;
                    }else{
                        mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).rmaInv.Wafer_Id_Fab_9_10_CSR_Submission__c = selLots;
                    }
                    mapRMARIwrapper.get(LotInvToEdit+'-'+InvNumToEdit).WaferNotSelected                  = unselLots;
                }
                showPopUp    = false;
                WaferToEdit  = '';
                LotInvToEdit = '';
                InvNumToEdit = '';
                adjustedPrice = NULL;
                waferYield = NULL;
                scrapLimit = NULL;
                dieQuantity= NULL;
                modQuantity= NULL;
                formFactor = NULL;
                formFactorQuantity= NULL;
                itemType = NULL;
                rightOptions.clear();
                leftOptions.clear();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid input. Please do not use any special character ($,%,&,*, etc.) in the input fields.'));
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return NULL;
    }
    
    //Hide the popup for Editing the Line Item
    public PageReference CancelPopup(){
        showPopUp    = false;
        WaferToEdit  = '';
        LotInvToEdit = '';
        InvNumToEdit = '';
        adjustedPrice = NULL;
        waferYield = NULL;
        scrapLimit = NULL;
        dieQuantity= NULL;
        modQuantity= NULL;
        formFactor = NULL;
        formFactorQuantity= NULL;
        itemType = NULL;
        rightOptions.clear();
        leftOptions.clear();
        return NULL;
    }
    
    //Method to associate the Line Items with the RMA request
    public PageReference InsertLineItems(){
        List<RMA_Return_Invoice__c> lstToInsert = new List<RMA_Return_Invoice__c>();
        for(String LotInvoice: mapRMARIwrapper.keySet()){
            if(mapRMARIwrapper.get(LotInvoice).isSelected){
                mapRMARIwrapper.get(LotInvoice).rmaInv.RMA__c = RMArecord.Id;
                lstToInsert.add(mapRMARIwrapper.get(LotInvoice).rmaInv);
            }
        }
        try{
            //This will throw error message if the lots belonging to different Fab are selected for Insertion
            if(!lstToInsert.isEmpty()){
                string errorMsg = '';
                integer i=0;
                for(RMA_Return_Invoice__c ri: lstToInsert){                    
                    if(ri.Fab_Group__c != RMArecord.Fab__c){
                        i++;
                        errorMsg += string.valueOf(i) + '. '+ ri.Lot_Number__c + ' --> ' + ri.Fab_Group__c +'<br/>';
                    }
                }
                if(i>0){                    
                    errorMsg += 'Please unselect these lots from the file and try again.';
                    ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,
                        'Following Lots belongs to the different Fab:<br/>'+errorMsg);
                    ApexPages.addMessage(errorMessage);
                    return NULL;
                }
            }
                
            database.insert(lstToInsert);
            return new PageReference('/apex/RMA_Edit?id='+RMArecord.Id);
        }catch(Exception e){
            if(e.getMessage().contains('DUPLICATE_VALUE')){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Line Item with same LotId already exists in this RMA.');
                ApexPages.addMessage(errorMessage);
            }
        }
        return NULL;
    }
    
    //This will redirect the user to the RMA request detail page
    public PageReference ReturnToRMA(){
        return new PageReference('/apex/RMA_Edit?id='+RMArecord.Id);
    }
    
}