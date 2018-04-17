/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a test class for RMA_ReturnInvoiceTrigger
 * History:
 *    SurendranadhNune 12022016  -   Created.
 *                            
 **/
@isTest
private class RMA_ReturnInvoiceTriggerTest {

   @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
    
    static testmethod void testDeleteReturnInvoice(){
       Account acc = [Select id from account limit 1][0];
       RMA__c rmaRec = [Select id from rma__c limit 1][0]; 
        
       Test.startTest();
       RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
       RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1-123456;', rma__c = rmaRec.id);
       insert PrfParticular;
       
       rmaRec.Access_Impact__c = 'Safety Impact';
       rmaRec.Description_Return_Particulars__c = 'test';
       rmaRec.Description_of_Reason_s__c = 'test';
       rmaRec.RMA_Category__c = 'Technical/ Turnkey';
       rmaRec.Disposition_of_Wafers__c = 'Return to GF';
       rmaRec.Customer_Request_Date__c = System.TODAY()-1;
       rmaRec.Justification_Fab_Validation__c = 'test';
       rmaRec.Justification_PRF__c = 'test';
       rmaRec.Justification_CAR__c = 'test';
       rmaRec.Justification_FOC__c = 'test';
       rmaRec.Justification_Field_Reliability_Failure__c = 'test';
       rmaRec.Potential_Impact_Wafers__c = 20;
       rmaRec.Region_Head__c = UserInfo.getUserId();
       rmaRec.Sales_SVP__c = UserInfo.getUserId();
       rmaRec.Lot_Device_To_Return__c = rmaRec.Lot_Device_Design_Rule_Waiver__c = 
       rmaRec.Lot_Device_ET_Waiver__c = rmaRec.Lot_Device_FRF__c = rmaRec.Lot_Device_Requires_Scrap_Certificate__c =
       rmaRec.Lot_Device_Risk_Production__c = rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
       update rmaRec;
       
       //Submitting RMA for Approval
       ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
       PageReference pageRef = Page.RMA_view;
       pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
       Test.setCurrentPage(pageRef);
       RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
       Test.setCurrentPage(pageRef);
       obj2.sumbitForApproval();
       
       delete [select id from RMA_Return_Invoice__c];
       Test.stopTest();
    }
    
    static testmethod void testDeleteReturnInvoice2(){
       Account acc = [Select id from account limit 1][0];
       RMA__c rmaRec = [Select id from rma__c limit 1][0]; 
              
       Test.startTest();    
       RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
       RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
       insert PrfParticular; 
       RMA_Return_Invoice__c rmi = [SELECT Id from RMA_Return_Invoice__c WHERE RMA__c =: rmaRec.Id];
        
       rmaRec.Access_Impact__c = 'Safety Impact';
       rmaRec.Description_Return_Particulars__c = 'test';
       rmaRec.Description_of_Reason_s__c = 'test';
       rmaRec.RMA_Category__c = 'Technical/ Turnkey';
       rmaRec.Disposition_of_Wafers__c = 'Return to GF';
       rmaRec.Customer_Request_Date__c = System.TODAY()-1;
       rmaRec.Justification_Fab_Validation__c = 'test';
       rmaRec.Justification_PRF__c = 'test';
       rmaRec.Justification_CAR__c = 'test';
       rmaRec.Justification_FOC__c = 'test';
       rmaRec.Justification_Field_Reliability_Failure__c = 'test';
       rmaRec.Potential_Impact_Wafers__c = 20;
       rmaRec.Region_Head__c = UserInfo.getUserId();
       rmaRec.Sales_SVP__c = UserInfo.getUserId();
       rmaRec.Lot_Device_To_Return__c = rmaRec.Lot_Device_Design_Rule_Waiver__c = 
       rmaRec.Lot_Device_ET_Waiver__c = rmaRec.Lot_Device_FRF__c =
       rmaRec.Lot_Device_Risk_Production__c = rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
       update rmaRec;
        
       rmi.Lot_Number__c = 'TestLot1';
       update rmi;
       
       //Submitting RMA for Approval
       ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
       PageReference pageRef = Page.RMA_view;
       pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
       Test.setCurrentPage(pageRef);
       RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
       Test.setCurrentPage(pageRef);
       obj2.sumbitForApproval();
       
        delete [select id from RMA_Return_Invoice__c];
       Test.stopTest();
    }
    
    static void testDataForDuplicateRI(account acc, RMA__c rmaRec){
        
        RMA_DNCN__c dncn = new RMA_DNCN__c();
        dncn.Invoice_Number__c = '123456';
        dncn.Lot_Id__c = 'testLot1';
        dncn.Wafer_Id__c = '1;2;3;4;5';
        insert dncn;
        
        Invoice__c invRec = new Invoice__c();
        invRec.Lot_Name__c = 'testLot1';
        invRec.Fab_Code__c = 'FS1';
        invRec.Fab_Group__c = 'FAB 1';
        invRec.Bill_Quantity__c = 100;
        invRec.Customer_Name__c = acc.Id;
        invRec.GDPW__c = 1234;
        invRec.Invoice_Date__c = System.Today()-5;
        invRec.Invoice_Number__c = '123456';
        invRec.Item_Type__c = 'US';
        invRec.Part_Number__c = 'qwerty';
        invRec.Process_Name__c = 'testProcess';
        invRec.Purchase_Order_Number__c = 'PO12345';
        invRec.Sales_Order_Number__c = 'SO12345';
        invRec.Unit_Selling_Price__c = 100;
        invRec.Wafer_Id__c = '1;2;3;4;5';
        invRec.ExternalId__c = 'Duplicate-1';
        insert invRec;
        
        RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
        rmaRI.rma__c = rmaRec.id;
        rmaRI.invoice__c = invRec.id;
        rmaRI.Lot_Number__c = invRec.lot_name__c;
        rmaRI.Bill_Quantity__c = 20;
        rmaRI.Device__c = 'testDevice'; 
        rmaRI.Invoice_Number__c = '123456';
        rmaRI.Invoice_Date__c = System.Today()-5;
        rmaRI.Purchase_Order_Number__c = 'PO12345';
        rmaRI.Process__c = 'testProcess';
        rmaRI.Scrap_Limit__c = 29;
        rmaRI.Wafer_Die_Unit_Price__c = 50;
        rmaRI.Wafer_Id_CSR_Submission__c = '1;2;3;4;5';
        rmaRI.Wafer_Yield__c = 50;
        insert rmaRI;        
    }
    
    static testmethod void testCheckDuplicates(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
        
        
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            try{
                testDataForDuplicateRI(acc, rmaRec);
            }catch(Exception e){}
        Test.stopTest();
    }
    
    static testmethod void testCheckDuplicates2(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.RMA_By__c = 'Die';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            update rmaRec;
        
            RMA_Return_Invoice__c ri = [select id from RMA_Return_Invoice__c where RMA__c = :rmaRec.Id limit 1];
            ri.RMA_By__c = 'Die';
            ri.Die_Quantity__c  = 10;
            update ri;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){}
        Test.stopTest();
    }
    
    static testmethod void testCheckDuplicates4(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Fab__c = 'FAB 2';
            rmaRec.Reason_Code__c = 'R10';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            
            rmaRec.Workflow_Stage__c = 'Pending for Quality Validation';
            rmaRec.Status__c = 'Submitted';
            update rmaRec;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){}
        Test.stopTest();
    }
    
    static testmethod void testCheckDuplicates5(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.RMA_By__c = 'Die';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_NONFAB_VAL;
            update rmaRec;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){}
        Test.stopTest();
    }
    
    static testmethod void testCheckDuplicates6(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.RMA_By__c = 'Die';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_PRD_ENG;
            update rmaRec;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){}
        Test.stopTest();
    }
    static testmethod void testCheckDuplicates7(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.RMA_By__c = 'Die';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_NONFAB_VAL;
            rmaRec.Status__c = 'Submitted';
            update rmaRec;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){}
        Test.stopTest();
    }
    
    static testmethod void testCheckDuplicates8(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_PRF_CAR_Particulars__c PrfParticular = new RMA_PRF_CAR_Particulars__c(recordTypeid = RMA_Constants.PRFCAR_PRF, lot__c = 'testLot1;', rma__c = rmaRec.id);
            insert PrfParticular; 
            
            rmaRec.Compensation_Type__c = 'Credit';       
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Fab__c = 'FAB 2';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.RMA_By__c = 'Wafer';
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_FAB_VAL;
            rmaRec.Status__c = 'Rejected';
            
            update rmaRec;
            
            RMA_DNCN__c dncn = new RMA_DNCN__c();
            dncn.Name = 'testCNDN';
            dncn.Lot_Id__c = 'testLot1';
            dncn.Invoice_Number__c = '123456';
            dncn.Wafer_Id__c = '1;2;4;6;';
            dncn.ExternalId__c = 'testCNDN-123456-testLot1';
            dncn.Record_Source__c = 'DNCN';
            dncn.Request_Status__c = 'COMPLETE';
            insert dncn;
            
             //Submitting RMA for Approval
             ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
             PageReference pageRef = Page.RMA_view;
             pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
             Test.setCurrentPage(pageRef);
             RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
             Test.setCurrentPage(pageRef);
             obj2.sumbitForApproval();
             
             try{
                testDataForDuplicateRI(acc, rmaRec);
             }catch(Exception e){
                //system.assert(e.getmessage().contains('Wafer Id:(1, 2, 3, 4, 5) under Lot #:testLot1 has already been entered '));
             }
        Test.stopTest();
    }
    
    static testmethod void testMethod1(){
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select id from rma__c limit 1]; 
        Test.startTest();
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.RMA_By__c = 'Die';
            rmaRec.Compensation_Type__c = 'Credit';
            update rmaRec;
            
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot1';
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 1';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'TK';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Die_Selling_Price__c = 100;
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            insert invRec;
            
            RMA_Return_Invoice__c rmaRI = new RMA_Return_Invoice__c();
            rmaRI.rma__c = rmaRec.id;
            rmaRI.invoice__c = invRec.id;
            rmaRI.Lot_Number__c = invRec.lot_name__c;
            rmaRI.Bill_Quantity__c = 100;
            rmaRI.Device__c = 'testDevice'; 
            rmaRI.Invoice_Number__c = '123456';
            rmaRI.Invoice_Date__c = System.Today()-5;
            rmaRI.Purchase_Order_Number__c = 'PO12345';
            rmaRI.Process__c = 'testProcess';
            rmaRI.Scrap_Limit__c = 29;
            rmaRI.Wafer_Die_Unit_Price__c = 100;
            rmaRI.Wafer_Yield__c = 50;
            rmaRI.RMA_By__c = 'Die';
            rmaRI.Die_Quantity__c  = 10;
            insert rmaRI; 
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec1.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
                        
            RMA__c rmaRec2 = RMA_TestDataUtility.createRMA(1, acc); 
            rmaRec2.Access_Impact__c = 'Safety Impact';
            rmaRec2.Description_of_Reason_s__c = 'test';
            rmaRec2.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec2.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec2.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec2.Region_Head__c = UserInfo.getUserId();
            rmaRec2.Sales_SVP__c = UserInfo.getUserId();
            rmaRec2.Return_Estimated_Date__c = System.Today()+2;
            rmaRec2.Assign_to__c = 'Fab';
            rmaRec2.Workflow_Stage__c = 'RMA Raised';
            rmaRec2.RMA_By__c = 'Die';
            rmaRec2.Customer_Request_Date__c = System.TODAY()-1;
            update rmaRec2;
            
            RMA_Return_Invoice__c rmaRI2 = new RMA_Return_Invoice__c();
            rmaRI2.rma__c = rmaRec2.id;
            rmaRI2.invoice__c = invRec.id;
            rmaRI2.Lot_Number__c = invRec.lot_name__c;
            rmaRI2.Bill_Quantity__c = 20;
            rmaRI2.Device__c = 'testDevice'; 
            rmaRI2.Invoice_Number__c = '123456';
            rmaRI2.Invoice_Date__c = System.Today()-5;
            rmaRI2.Purchase_Order_Number__c = 'PO12345';
            rmaRI2.Process__c = 'testProcess';
            rmaRI2.Scrap_Limit__c = 29;
            rmaRI2.Wafer_Die_Unit_Price__c = 100;
            rmaRI2.Wafer_Yield__c = 50;
            rmaRI2.RMA_By__c = 'Die';
            rmaRI2.Die_Quantity__c  = 10;
            
            try{
                insert rmaRI2;
            }catch(Exception e){}
        Test.stopTest();
    }
}