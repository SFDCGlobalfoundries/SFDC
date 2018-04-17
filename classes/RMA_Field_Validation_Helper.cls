/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This class will help for field validation on RMA Record. 
                    This class will be used on RMA_Trigger trigger and RMA_Edit_Extensions class.
* History       :   
        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Shyam Nair      27-Nov-15     Created the Class
        Nikhil Jain     05-May-16     Included a 'RMA By' check in case 'Failure Analysis' is done for RMA with greater than 3 wafers.
**/
public with sharing class RMA_Field_Validation_Helper{
    
    //To validate fields before inserting RMA. Will be called in RMA_Trigger trigger.
    public static void validateBeforeInsert(List<RMA__c> newRMARecordList){
        for(RMA__c RMAReq: newRMARecordList){
            String errorFields = '';
            for(Schema.FieldSetMember members: SObjectType.RMA__c.FieldSets.RMA_Generic_Information.getFields()){
                if(RMAReq.get(members.getFieldPath()) == NULL){
                    errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+members.getLabel()+'<br/>';
                }
            }
            //For Fab 9 or Fab 10
            if(RMA_Utility.checkFab9or10(RMAReq.Fab__c)){
                for(Schema.FieldSetMember members: SObjectType.RMA__c.FieldSets.RMA_Generic_Information_For_Fab9_10.getFields()){
                    if(RMAReq.get(members.getFieldPath()) == NULL){
                        errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+members.getLabel()+'<br/>';
                    }
                }  
            }
            if(errorFields != ''){
                RMAReq.addError('Following fields cannot be blank : <br/>'+errorFields);
            }
        }
    }
    
    //to validate Disposition Of Wafers
    public static boolean validateDispostion(RMA__c RMArecord){
        boolean validateDisp = false;
        List<RMA_Return_Invoice__c> lstInvoice = [select Lot_Number__c, Invoice_Number__c, RMA__c from RMA_Return_Invoice__c where RMA__c =: RMArecord.Id];
        
        String LotNos = '';
        for(RMA_Return_Invoice__c invoice : lstInvoice){
            LotNos += invoice.Lot_Number__c + '-' + invoice.Invoice_Number__c + ';';
        }
        
        if(LotNos != ''){
            String unselectedLots = '';
            for(String lotNo : LotNos.split(';')){
                if(RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF') && !String.isEmpty(RMArecord.Lot_Device_To_Return__c)){
                    if(!RMArecord.Lot_Device_To_Return__c.contains(lotNo+';')){
                        unselectedLots += lotNo+';';
                    }
                }
                else if(RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('To Scrap at Customer Site') && !String.isEmpty(RMArecord.Lot_Device_Requires_Scrap_Certificate__c)){
                    if(!RMArecord.Lot_Device_Requires_Scrap_Certificate__c.contains(lotNo+';')){
                        unselectedLots += lotNo+';';
                    }
                }
                else if(RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF and to Scrap at Customer Site') && !String.isEmpty(RMArecord.Lot_Device_To_Return__c) && !String.isEmpty(RMArecord.Lot_Device_Requires_Scrap_Certificate__c)){
                    if(!RMArecord.Lot_Device_To_Return__c.contains(lotNo+';') && !RMArecord.Lot_Device_Requires_Scrap_Certificate__c.contains(lotNo+';')){
                        unselectedLots += lotNo+';';
                    }
                }
            }
            
            if(unselectedLots != ''){
                validateDisp = true;
                RMArecord.addError('Following Lots are not selected on Disposition of Wafers tab: '+unselectedLots);
            }
        }
        
        if(RMArecord.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF and to Scrap at Customer Site')){
            String lots = '';
            if(!String.isEmpty(RMArecord.Lot_Device_To_Return__c) && !String.isEmpty(RMArecord.Lot_Device_Requires_Scrap_Certificate__c)){
                for(String str1: RMArecord.Lot_Device_To_Return__c.split(';')){
                    for(String str2: RMArecord.Lot_Device_Requires_Scrap_Certificate__c.split(';')){
                        if(str1 == str2){
                            lots += str1+';';
                        }
                    }
                }   
            }
            if(lots != ''){
                    validateDisp = true;
                    RMArecord.addError('Following Lots cannot be selected for both Return to GF and Scrap to Customer Site: '+lots);
            }
        }
        
        return validateDisp;
    }
    
    //To check fields before sending record for approval. Will be called in RMA_Edit_Extensions class.
    public static boolean validateFieldsBeforeApproval(RMA__c RMARecord){
        boolean validateRMA = true;
        String errorFields = '';
        List<RMA_Return_Invoice__c> lstLineItems = new List<RMA_Return_Invoice__c>();
        lstLineItems = [SELECT Id,Adjusted_Unit_Price__c,Existing_Form_Factor__c,Existing_Form_Factor_Quantity__c
                             FROM RMA_Return_Invoice__c WHERE RMA__c =: RMARecord.Id];
        
        //For Return Lot Wafer Details Section
        if(lstLineItems != NULL && lstLineItems.size() == 0){
            validateRMA = false;
            RMArecord.addError('Please add atleast one RMA Invoice.');
        }
        for(Schema.FieldSetMember member: SObjectType.RMA__c.FieldSets.RMA_Return_Lot_Wafer_Die_details.getFields()){
            if(RMArecord.get(member.getFieldPath()) == NULL){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+member.getLabel()+'<br/>';
            }
        }
        if(RMA_Utility.checkFab9or10(RMARecord.Fab__c)){
            for(Schema.FieldSetMember member: SObjectType.RMA__c.FieldSets.RMA_Return_Lot_Wafer_Die_details_Fab9_10.getFields()){
                if(RMArecord.get(member.getFieldPath()) == NULL){
                    errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+member.getLabel()+'<br/>';
                }
            }
            if(!RMARecord.RMA_Category__c.equalsIgnoreCase('Failure Analysis')){
                if(RMARecord.Warranty__c != NULL && RMARecord.Warranty__c <= 0){
                    validateRMA = false;
                    RMArecord.addError('Warranty cannot be zero or have negative value.');  
                }
            }
            if(RMARecord.ReasonCode__c == 'R81'){
                if(RMARecord.Alternative_Customer__c == NULL){
                    validateRMA = false;
                    RMARecord.addError('Please select Alternative Customer.');
                }
                //Check if the Existing Form Factor Price field is filled for all the associated lots
                for(RMA_Return_Invoice__c li: lstLineItems){
                    if(li.Adjusted_Unit_Price__c == NULL || li.Adjusted_Unit_Price__c <= 0){
                        RMARecord.addError('Please provide Existing Form Factor Price for all the lots.');
                        validateRMA = false;
                        break;
                    }
                    if(li.Existing_Form_Factor__c == NULL || li.Existing_Form_Factor__c == ''){
                        RMARecord.addError('Please select Existing Form Factor for all the lots.');
                        validateRMA = false;
                        break;
                    }
                    if(li.Existing_Form_Factor_Quantity__c == NULL || li.Existing_Form_Factor_Quantity__c <= 0){
                        RMARecord.addError('Please provide Existing Form Factor Quantity for all the lots.');
                        validateRMA = false;
                        break;
                    }
                }
            }
        }
        
        //For Customer Return Particulars section
        if(RMArecord.RMA_Category__c != NULL && !RMArecord.RMA_Category__c.equalsIgnoreCase('Failure Analysis')){
            for(Schema.FieldSetMember member: SObjectType.RMA__c.FieldSets.RMA_Customer_Return_Particulars.getFields()){
                if(RMArecord.get(member.getFieldPath()) == NULL){
                    errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+member.getLabel()+'<br/>';
                }
            }
        }
        
        if(RMARecord.RMA_Category__c == 'Technical/ Turnkey' && RMARecord.Assign_To__c == NULL){
            errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Assign_To__c.getLabel()+'<br/>';
        }
        if(RMARecord.Disposition_of_Wafers__c == NULL){
            errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Disposition_of_Wafers__c.getLabel()+'<br/>';
        }
        else if(RMARecord.Disposition_of_Wafers__c == 'Return to GF'){
            if(RMA_Utility.checkFab9or10(RMARecord.Fab__c) && RMARecord.Return_Location__c ==  NULL){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Return_Location__c.getLabel()+'<br/>';
            }
            if(String.isEmpty(RMARecord.Lot_Device_To_Return__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_To_Return__c.getLabel()+'<br/>';    
            }
            if(RMARecord.Return_Estimated_Date__c == NULL){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Return_Estimated_Date__c.getLabel()+'<br/>';    
            }
        }
        else if(RMARecord.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && String.isEmpty(RMARecord.Lot_Device_Requires_Scrap_Certificate__c)){
            errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_Requires_Scrap_Certificate__c.getLabel()+'<br/>';
        }
        else if(RMARecord.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
            if(String.isEmpty(RMARecord.Lot_Device_To_Return__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_To_Return__c.getLabel()+'<br/>';
            }
            if(RMARecord.Return_Estimated_Date__c == NULL){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Return_Estimated_Date__c.getLabel()+'<br/>';    
            }
            if(String.isEmpty(RMARecord.Lot_Device_Requires_Scrap_Certificate__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_Requires_Scrap_Certificate__c.getLabel()+'<br/>';
            }
        } 
		
        if(RMARecord.Is_the_RMA_lot_s_related_to_PRF__c){
            if(RMArecord.PRF_Count__c == 0){
                validateRMA = false;
                RMArecord.addError('Please add atleast one PRF Detail.');
            }
            if(String.isEmpty(RMARecord.Justification_PRF__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Justification_PRF__c.getLabel()+'<br/>'; 
            }
        }
        if(RMARecord.Customer_CAR_Raised__c){
            if(RMArecord.CAR_Count__c == 0){
                validateRMA = false;
                RMArecord.addError('Please add atleast one CAR Detail.');
            }
            If(String.isEmpty(RMARecord.Justification_CAR__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Justification_CAR__c.getLabel()+'<br/>';
            }
        } 
        if(RMARecord.RMA_due_to_Field_reliability_Failure__c && String.isEmpty(RMARecord.Lot_Device_FRF__c)){
            errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_FRF__c.getLabel()+'<br/>';
        }
        if(RMARecord.RMA_related_to_Waiver_Issue__c){
            if(String.isEmpty(RMARecord.Lot_Device_Design_Rule_Waiver__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_Design_Rule_Waiver__c.getLabel()+'<br/>'; 
            }
            if(String.isEmpty(RMArecord.Lot_Device_ET_Waiver__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_ET_Waiver__c.getLabel()+'<br/>';
            }
        }
        if(RMARecord.Risk_Production__c && String.isEmpty(RMARecord.Lot_Device_Risk_Production__c)){
            errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Lot_Device_Risk_Production__c.getLabel()+'<br/>';
        }
        
        //validate carrier fields
        if(RMA_Utility.checkFab9or10(RMARecord.Fab__c) && RMARecord.Disposition_of_Wafers__c != NULL && (RMARecord.Disposition_of_Wafers__c == 'Return to GF'|| RMARecord.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site')){
            if(RMARecord.Carrier_Vendor__c == NULL){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Carrier_Vendor__c.getLabel()+'<br/>';
            }
            
            if(String.isEmpty(RMARecord.Carrier_Vendor_Account_Number__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Carrier_Vendor_Account_Number__c.getLabel()+'<br/>';
            }
            
            if(RMARecord.Carrier_Vendor__c == 'Others' && String.isEmpty(RMARecord.New_Carrier_Vendor__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.New_Carrier_Vendor__c.getLabel()+'<br/>';
            } 
            
            if(String.isEmpty(RMARecord.Ship_from_Address__c)){
                errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Ship_from_Address__c.getLabel()+'<br/>';
            }  
        }
        
        
        if(errorFields != ''){
            validateRMA = false;
            RMArecord.addError('Following fields cannot be blank : <br/>'+errorFields);
        }
        
        if(RMARecord.Disposition_of_Wafers__c != NULL && validateDispostion(RMArecord)){
            validateRMA = false;
        }
        
        return validateRMA;
    }
    
    //To validate fields before Regional Validation. Will be called in RMA_Trigger trigger.
    public static void validateBeforeRegValidation(List<RMA__c> newRMARecordList){
        for(RMA__c RMAReq: newRMARecordList){
            String errorFields = '';
            for(Schema.FieldSetMember member: SObjectType.RMA__c.FieldSets.RMA_Investigation_Results.getFields()){
                if(RMAReq.get(member.getFieldPath()) == NULL){
                    errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+member.getLabel()+'<br/>';
                }
            }
            if(errorFields != ''){
                String errorBody = '<br/><br/>Following fields cannot be blank :<br/>';
                errorBody += errorFields;
                errorBody += '<br/>';
                errorBody += 'Click ';
                errorBody += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+RMAReq.Id+'">here</a>';
                errorBody += ' to return to the RMA record.';
                                
                RMAReq.addError('<b><font color="red"'+errorBody+'</font></b>');
            }
        }
    }
    
    //validate fields on Customer Quality Approval
    public static void validateOnCustomerQualityApproval(List<RMA__c> newRMARecordList){
        for(RMA__c RMAReq : newRMARecordList){
            String errorFields = '';
            for(Schema.FieldSetMember member : SObjectType.RMA__c.FieldSets.RMA_Customer_Quality_Validation.getFields()){
                if(RMAReq.get(member.getFieldPath()) == NULL){
                    errorFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+member.getLabel()+'<br/>';
                }
            }
            if(errorFields != ''){
                String errorBody = '<br/><br/>Following fields cannot be blank :<br/>';
                errorBody += errorFields;
                errorBody += '<br/>';
                errorBody += 'Click ';
                errorBody += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+RMAReq.Id+'">here</a>';
                errorBody += ' to return to the RMA record.';
                                
                RMAReq.addError('<b><font color="red"'+errorBody+'</font></b>');
            }
        }
    }
    
    //To validate RMA Category selection.
    public static void validateRMACategory(RMA__c RMARecord){
        if(RMARecord.Total_Wafers__c == 0 && RMARecord.RMA_Category__c != NULL){
            RMARecord.RMA_Category__c = NULL;
            RMARecord.addError('Please select Lot/Die Details before selecting RMA Category.');
        }
        else{
            if(RMARecord.RMA_Category__c == 'Failure Analysis' && RMARecord.Total_Wafers__c > Decimal.valueOf(Label.RMA_Failure_Analysis_Wafer_Count) && RMARecord.RMA_By__c == 'Wafer'){
                RMARecord.RMA_Category__c = NULL;
                RMARecord.addError('You cannot select RMA Category "Failure Analysis" as the total Wafer Quantity is greater than 3.');
            }
        }
    }
    
    //to validate fields before acknowledgement
    public static boolean checkAckn(RMA__c RMArecord){
        boolean isError = false;
        String waferFields = '';
        String scrapFields = '';
        if(rmaRecord.Acknowledged_Wafer_Return__c){
            Decimal waferCount = 0;
            List<String> lotList = new List<String>();
            Set<String> setLotInvoice = new Set<String>();
            for(String lot : rmaRecord.Lot_Device_To_Return__c.split(';')){
                if(lot.contains('-')){
                    lotList.add(lot.split('-')[0]);
                }else{
                    lotList.add(lot);
                }
            }
            if(rmaRecord.Lot_Device_To_Return__c != NULL && rmaRecord.Lot_Device_To_Return__c != ''){
                setLotInvoice.addAll(rmaRecord.Lot_Device_To_Return__c.split(';'));
            }
            
            for(RMA_Return_Invoice__c invoice : [SELECT Wafer_Quantity__c,Lot_Number__c,Invoice_Number__c FROM RMA_Return_Invoice__c WHERE RMA__c =: rmaRecord.Id and Lot_Number__c IN: lotList]){
                if(!setLotInvoice.isEmpty() && setLotInvoice.contains(invoice.Lot_Number__c + '-' + invoice.Invoice_Number__c)){
                    waferCount += invoice.Wafer_Quantity__c;
                }
            }
            if(RMArecord.Quantity_Received__c == NULL){
                waferFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Quantity_Received__c.getLabel()+'<br/>';
            }
            if(RMArecord.Date_of_Wafer_Receipt__c == NULL){
                waferFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Date_of_Wafer_Receipt__c.getLabel()+'<br/>';
            }
            if(waferCount > 0 && RMArecord.Quantity_Received__c > waferCount){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Quantity received should not be greater than '+waferCount+' (total wafer count) of the selected Lot(s).'));
                rmaRecord.Quantity_Received__c = NULL;
                rmaRecord.Acknowledged_Wafer_Return__c = false;
                isError = true;
            }
        }
        if(RMArecord.Acknowledged_Wafer_Scrap__c){
            if(RMArecord.Certificate_No__c == NULL){
                scrapFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Certificate_No__c.getLabel()+'<br/>';
            }
            if(RMArecord.Certificate_Received_Date__c == NULL){
                scrapFields += '*&nbsp&nbsp&nbsp&nbsp&nbsp '+SObjectType.RMA__c.Fields.Certificate_Received_Date__c.getLabel()+'<br/>';
            }
            if(RMArecord.Attachment_Count_in_Disposition_Section__c == 0 ){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'There are no attachments found. Please upload the scrap certificate.'));
                rmaRecord.Acknowledged_Wafer_Scrap__c = false;
                isError = true;
            }
        }
        if(waferFields != '' || scrapFields != ''){
            String errorMsg = 'Following fields cannot be blank: <br/>';
            if(waferFields != ''){
                rmaRecord.Acknowledged_Wafer_Return__c = false;
                errorMsg += waferFields;
            }
            if(scrapFields != ''){
                rmaRecord.Acknowledged_Wafer_Scrap__c = false;
                errorMsg += scrapFields;
            }
            errorMsg += '<br/>Please fill in the required fields and acknowledge the RMA again.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,errorMsg));
            isError = true;
        }
        return isError;
    }
    
    //check warranty for fab 9 and 10
    public static boolean checkWarrantyForFab9or10(RMA__c rmaRecord){
        boolean hasError = false;
        Date customerRequestDate = RMArecord.customer_request_date__c.date(); 
        double warrantyPeriodForRMA = (Integer)RMArecord.Warranty__c * 30.4167;
        for(RMA_Return_Invoice__c retInv : [select Invoice_Date__c, Lot_number__c from RMA_Return_Invoice__c where RMA__c =: rmaRecord.Id]){
            Integer daysBetween = 0;
            if(retInv.Invoice_Date__c != null){
                daysBetween = retInv.Invoice_Date__c.daysBetween(customerRequestDate) + 1; // Added 1 to include today
            }
            if(daysBetween >= warrantyPeriodForRMA){
                hasError = true;
            }
        }
        if(hasError && (rmaRecord.ReasonCode__c == 'R50' || rmaRecord.ReasonCode__c == 'R80')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Kindly take note that as per GF RMA Policy the time limit for the return of parts ' +
                                                                 ' for Quality/ Yield issues is <b>'+(Integer)warrantyPeriodForRMA+' days</b> from the Invoice date.<br/>' +
                                                                 'Please remove line items which are outside warranty for <b>' + rmaRecord.ReasonCode__c + '</b>'));
            return true;
        }else if(hasError && String.isBlank(RMArecord.Justification_Field_Reliability_Failure__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Kindly take note that as per GF RMA Policy the time limit for the return of parts ' +
                                                                 ' for Quality/ Yield issues is <b>'+(Integer)warrantyPeriodForRMA+' days</b> from the Invoice date.<br><br>' +
                                                                 'Please provide value for <b>'+ Schema.SobjectType.RMA__c.fields.Justification_Field_Reliability_Failure__c.Label+'</b>.'));
            return true;                                                        
        }
        else{
            return false;
        }
    }
    
    
    
     /**
      * @author Surendranadh Nune
      * @Description : This method is used to perform validations on Field Reliability Failure of RMA(RMA_due_to_Field_reliability_Failure__c)
      */
    public static boolean validateFieldReliability(RMA__c rmaRecord){
        Boolean shouldHaveJustification = false;
        Integer warrantyPeriodForRMA = Integer.valueOf(Label.RMA_Warranty_Period);
        Boolean hasError = false;
        String lotsBeyondWarranty = '';
        if(!RMA_Utility.checkFab9or10(RMARecord.Fab__c)){
            if(RMArecord.RMA_due_to_Field_reliability_Failure__c){
                if(String.isBlank(RMArecord.Lot_Device_FRF__c)){
                    hasError = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Kindly take note that as per GF RMA Policy the time limit for the return of wafers/ packaged units with '+
                                                                                         '<b>Field Relibality failures</b> is <b>365 days</b> from the Invoice Date.\n\n Please <b>select the Lot affected by Field reliability issue.</b>'));
                }
            }else{
                List<Account> customers = [SELECT ID,Warranty_period_for_RMA__c FROM ACCOUNT WHERE ID=:RMArecord.customer__c];
                
                Date customerRequestDate = RMArecord.customer_request_date__c.date(); //as daysBetween is not inclusive
                if(customers != NULL && !customers.isEmpty()){
                    warrantyPeriodForRMA = customers[0].Warranty_period_for_RMA__c != null ? Integer.valueOf(customers[0].Warranty_period_for_RMA__c) : warrantyPeriodForRMA;
                }
                
                for(RMA_Return_invoice__c retInv :  [SELECT Invoice_Date__c, Lot_number__c,Invoice_Number__c FROM RMA_Return_Invoice__c WHERE RMA__c =: rmaRecord.Id]){
                    Integer daysBetween = 0;
                    if(retInv.Invoice_Date__c != null){
                        daysBetween = retInv.Invoice_Date__c.daysBetween(customerRequestDate) + 1; // Added 1 to include today
                    }
                    if(daysBetween >= warrantyPeriodForRMA){
                        lotsBeyondWarranty += retInv.Lot_number__c+ '-' + retInv.Invoice_Number__c + ', ';
                    }
                }
                lotsBeyondWarranty = lotsBeyondWarranty.removeEnd(', ');
                if(String.isNotBlank(lotsBeyondWarranty) && String.isBlank(RMArecord.Justification_Field_Reliability_Failure__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Kindly take note that as per GF RMA Policy the time limit for the return of wafers/ packaged units ' +
                                                                 ' for Quality/ Yield issues is <b>'+warrantyPeriodForRMA+' days</b> from the Invoice date.<br><br>' +
                                                                 'Invoice Date of below lots is beyond warranty period: <br>' +lotsBeyondWarranty+ '.<br><br>' +
                                                                 'Please provide value for <b>'+ Schema.SobjectType.RMA__c.fields.Justification_Field_Reliability_Failure__c.Label+'</b>.'));
                    hasError = true;                                                                 
                }
                
            }
        }
        return hasError;
    }
    
    //NJain - 12-Oct-16 - Validate the Warranty for Visibility of Jusitification field on RMA record.
    public static boolean validateJustificationWarranty(RMA__c RMArecord){
        Boolean hasError = false;
        Date customerRequestDate = RMArecord.customer_request_date__c.date(); //as daysBetween is not inclusive
        Double warrantyPeriodForRMA;
        
        if(!RMA_Utility.checkFab9or10(RMARecord.Fab__c)){
            warrantyPeriodForRMA = Integer.valueOf(Label.RMA_Warranty_Period);
            List<Account> customers = [SELECT ID,Warranty_period_for_RMA__c FROM ACCOUNT WHERE ID=:RMArecord.customer__c];
            if(customers != NULL && !customers.isEmpty()){
                warrantyPeriodForRMA = customers[0].Warranty_period_for_RMA__c != null ? Integer.valueOf(customers[0].Warranty_period_for_RMA__c) : warrantyPeriodForRMA;
            }
        }else{
            warrantyPeriodForRMA = (Integer)RMArecord.Warranty__c * 30.4167;
        }
        
        for(RMA_Return_invoice__c retInv :  [select Invoice_Date__c, Lot_number__c from RMA_Return_Invoice__c where RMA__c =: rmaRecord.Id] ){
            Integer daysBetween = 0;
            if(retInv.Invoice_Date__c != null){
                daysBetween = retInv.Invoice_Date__c.daysBetween(customerRequestDate) + 1; // Added 1 to include today
            }
            if(daysBetween >= warrantyPeriodForRMA){
                hasError = true;
                break;
            }
        }
        if(hasError && String.isBlank(RMArecord.Justification_Field_Reliability_Failure__c)){
            hasError = true;
        }
        return hasError;
    }
}