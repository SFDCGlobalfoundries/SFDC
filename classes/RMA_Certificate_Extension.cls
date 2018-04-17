public without sharing class RMA_Certificate_Extension {

    public RMA__c RMARecord = new RMA__c();
    public List<String> lstAddress{get;set;}
    public String productNo{get;set;}
    public List<String> lstReturnAddress{get;set;}
    public List<RMA_Utility.LineItemWrapper> lstInvoicesReturnWrapper{get;set;}
    public List<RMA_Utility.LineItemWrapper> lstInvoicesScrapWrapper{get;set;}
    public decimal amountReturnInvoices{get;set;}
    public decimal amountScrapInvoices{get;set;}
    
    public RMA_Certificate_Extension(ApexPages.StandardController con){
        RMARecord = (RMA__c)con.getRecord();
        
        if(ApexPages.CurrentPage().getParameters().get('type') == 'scrap'){
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=ScrapCertificate_'+RMArecord.Name+'.pdf');
        }else if(ApexPages.CurrentPage().getParameters().get('type') == 'proforma'){
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=CustomerProforma_'+RMArecord.Name+'.pdf');
        }
        lstAddress = new List<String>();
        productNo = '';
        
        lstReturnAddress = new List<String>();
        if(RMARecord.Receiver_Address__c != NULL && RMARecord.Receiver_Address__c != ''){
            for(String addr: RMARecord.Receiver_Address__c.split('\n')){
                lstReturnAddress.add(addr);
            }
        }
        
        List<Account> lstAccount = new List<Account>();
        String accId = ''; 
        if(RMARecord.ReasonCode__c == 'R81'){
            accId = RMARecord.Alternative_Customer__c;
        }
        else{
            accId = RMARecord.Customer__c;
        } 
        
        lstAccount = [select Name,Bill_To_Address_1__c,Bill_To_Address_2__c,Bill_To_Address_3__c,Bill_To_Address_4__c,Bill_To_City__c,Bill_To_Country__c,
                        Bill_To_Postal_Zip_Code__c,Bill_To_State__c from Account where Id =: accId limit 1];
                        
        if(!lstAccount.isEmpty()){
            for(Account acc : lstAccount){
                for(Schema.FieldSetMember member : SObjectType.Account.FieldSets.BillToAddress.getFields()){
                    if(acc.get(member.getFieldPath()) != NULL){
                        lstAddress.add((String)acc.get(member.getFieldPath()));
                    }
                }   
            }
        }   
        
        //For separating lots belonging to Scrap and Return disposition respectively
        lstInvoicesReturnWrapper = new List<RMA_Utility.LineItemWrapper>();        
        lstInvoicesScrapWrapper  = new List<RMA_Utility.LineItemWrapper>();
        Set<String> setPartNumber = new Set<String>();
        amountReturnInvoices = 0;
        amountScrapInvoices = 0;
        
        List<RMA_Utility.LineItemWrapper> lstLineItemWrapper = new List<RMA_Utility.LineItemWrapper>();
        lstLineItemWrapper = RMA_Utility.prepareLineItemWrapper(RMARecord.Id);
        
        if(!lstLineItemWrapper.isEmpty()){
            for(RMA_Utility.LineItemWrapper invoiceWrap: lstLineItemWrapper){
                setPartNumber.add(invoiceWrap.invoice.Device__c);
                
                string lotInvoice = invoiceWrap.invoice.Lot_Number__c + '-' + invoiceWrap.invoice.Invoice_Number__c;
                if(invoiceWrap.invoice.RMA__r.Lot_Device_To_Return__c != NULL && 
                   invoiceWrap.invoice.RMA__r.Lot_Device_To_Return__c.contains(lotinvoice)){
                    lstInvoicesReturnWrapper.add(invoiceWrap);
                    amountReturnInvoices += invoiceWrap.ItemValue;
                }else if(invoiceWrap.invoice.RMA__r.Lot_Device_Requires_Scrap_Certificate__c != NULL && 
                         invoiceWrap.invoice.RMA__r.Lot_Device_Requires_Scrap_Certificate__c.contains(lotinvoice)){
                    lstInvoicesScrapWrapper.add(invoiceWrap);
                    amountScrapInvoices += invoiceWrap.ItemValue;
                }
            }
        }
        
        if(!setPartNumber.isEmpty()){
            for(String prt : setPartNumber){
                productNo += prt+',';   
            }
        }
        
        if(productNo != ''){
            productNo = productNo.removeEnd(',');
        }
        
    }

}