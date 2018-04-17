@isTest
public class RMA_Field_Validation_HelperTest{
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
            
    static testmethod void testvalidateBeforeInsert(){
        Test.startTest();
            RMA__c rmaRec = new RMA__c();
            rmaRec.Fab__c = 'FAB 1';
            try{
                insert rmaRec;
            }catch(Exception e){
                system.assert(e.getmessage().contains('Following fields cannot be blank : '));
            }
        Test.stopTest();
    }
    
    static testmethod void testvalidateFields(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = [select id,name from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
            String rmaFields = util.getAllFields('RMA__c');   
            rmaRec = database.query('select '+rmaFields+' from RMA__c where id= \''+rmaRec.id + '\'');
            
            RMA_field_Validation_helper.validateBeforeRegValidation(new RMA__c[]{rmaRec});
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456';
        Test.stopTest();
    }
    
    static testmethod void testvalidateRMACategory(){
        RMA__c rmaRec = [select Id from RMA__c limit 1];
        Account acc = [select id from account limit 1];
        Test.startTest();      
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
                 
            UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
            String rmaFields = util.getAllFields('RMA__c');
            rmaRec = database.query('select '+rmaFields+' from RMA__c where id= \''+rmaRec.id + '\'');
            rmaRec.RMA_Category__c = 'FOC in lieu of RMA';
            RMA_field_Validation_helper.validateRMACategory(rmaRec);
            
            rmaRec.RMA_Category__c = 'Failure Analysis';
            RMA_field_Validation_helper.validateRMACategory(rmaRec);
        Test.stopTest();
    }
    
    static testmethod void testValidateFieldReliability(){
        RMA__c rmaRec = [select Id from RMA__c limit 1];
        Account acc = [select id from account limit 1];
        
        Test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA__c');   
        rmaRec = database.query('select '+rmaFields+' from RMA__c limit 1');
        
        rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
        RMA_field_Validation_helper.ValidateFieldReliability(rmaRec);
        
        rmaRec.RMA_due_to_Field_reliability_Failure__c = false;
        RMA_field_Validation_helper.ValidateFieldReliability(rmaRec);
        Test.stopTest();
    }
    
    static testmethod void testValidateFieldsBeforeApproval(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = [select Id from RMA__c limit 1];
        
        Test.startTest();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String rmaFields = util.getAllFields('RMA__c');
        rmaRec = database.query('select '+rmaFields+' from RMA__c where id= \''+rmaRec.id + '\'');
        
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        
        rmaRec.RMA_Category__c = 'Rework';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.RMA_Category__c = null;
        
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Disposition_of_Wafers__c = null;
        
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Disposition_of_Wafers__c = null;
        
        rmaRec.Disposition_of_Wafers__c = 'Return to GF and to Scrap at Customer Site';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Disposition_of_Wafers__c = null;
        
        rmaRec.Is_the_RMA_lot_s_related_to_PRF__c = true;
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Is_the_RMA_lot_s_related_to_PRF__c = false;
        
        rmaRec.Customer_CAR_Raised__c = true;
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Customer_CAR_Raised__c = false;
        
        rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.RMA_due_to_Field_reliability_Failure__c = false;
        
        rmaRec.RMA_related_to_Waiver_Issue__c = true;
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.RMA_related_to_Waiver_Issue__c = false;
        
        rmaRec.Risk_Production__c = true;
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Risk_Production__c = false;
        
        Test.stopTest();
    }
    
    static testmethod void testValidateFieldsBeforeApprovalForFab9(){
        Account acc = [select id from account limit 1];
        
        Test.startTest();
        RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        rmaRec.RMA_Category__c = 'Failure Analysis';
        rmaRec.ReasonCode__c = 'R81';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        
        rmaRec.RMA_Category__c = 'Rework';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.RMA_Category__c = null;
        
        rmaRec.RMA_Category__c = 'Rework';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        List<RMA__c> rmaList = new List<RMA__c>();
        rmaList.add(rmaRec);
        RMA_field_Validation_helper.validateOnCustomerQualityApproval(rmaList);
        rmaRec.Disposition_of_Wafers__c = null;
        
        rmaRec.RMA_Category__c = 'Rework';
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Disposition_of_Wafers__c = null;
        
        rmaRec.RMA_Category__c = 'Rework';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF and to Scrap at Customer Site';
        RMA_field_Validation_helper.validateFieldsBeforeApproval(rmaRec);
        rmaRec.Disposition_of_Wafers__c = null;
        
        Test.stopTest();
    }
    
    static testmethod void testWarrantyForFab9(){
        Account acc = [select id from account limit 1];
           
        Test.startTest();
        RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc);
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        rmaRec.Warranty__c = 24;
        RMA_Field_Validation_Helper.checkWarrantyForFab9or10(rmaRec);
        Test.stopTest();
    }
    
    static testmethod void testCheckAckn(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
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
            update rmaRec;
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            rmaRec.Acknowledged_Wafer_Return__c = True;
            RMA_field_Validation_helper.checkAckn(rmaRec);
            
            rmaRec.Date_of_Wafer_Receipt__c = System.Today();
            rmaRec.Quantity_Received__c = 1;
            rmaRec.Air_way_Bill_No__c = 'AirWayBillNo';
            update rmaRec;
            RMA_field_Validation_helper.checkAckn(rmaRec);
            
            rmaRec.Acknowledged_Wafer_Scrap__c = true;
            update rmaRec;
            RMA_field_Validation_helper.checkAckn(rmaRec);
            
            rmaRec.RMA_due_to_Field_reliability_Failure__c = True;
            RMA_field_Validation_helper.validateFieldReliability(rmaRec);
        Test.stopTest();
    }
        
    static testmethod void testFA_RMA(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from account limit 1];
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Failure Analysis';
            rmaRec.Compensation_type__c = 'No Compensation';
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            
            RMA_field_Validation_helper.validateRMACategory(rmaRec);
            RMA_field_Validation_helper.validateDispostion(rmaRec);
        Test.stopTest();
    }
    
    static testmethod void testValidateDispostionScrap(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from account limit 1];
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
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
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            update rmaRec;
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            RMA_field_Validation_helper.validateDispostion(rmaRec);
            
            rmaRec.Disposition_of_Wafers__c = 'Return to GF and to Scrap at Customer Site';
            
            update rmaRec;
            RMA_field_Validation_helper.validateDispostion(rmaRec);
            
        Test.stopTest();
    }
}