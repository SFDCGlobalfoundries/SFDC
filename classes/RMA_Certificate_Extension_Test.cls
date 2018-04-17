/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for RMA_Certificate_Extension
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        SNAIR          08/05/2016           Test class created.       
**/

@isTest(SEEALLDATA = false)
private class RMA_Certificate_Extension_Test {
    
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
    }

    static testMethod void myUnitTest1() {
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
         
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
        rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.OwnerId = userInfo.getUserId();
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        PageReference pageRef = Page.RMA_Scrap_Certificate_PDF;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef.getParameters().put('type','scrap');
        Test.setCurrentPage(pageRef);
        
        RMA_Certificate_Extension obj = new RMA_Certificate_Extension(sc);
        Test.setCurrentPage(pageRef);
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.OwnerId = userInfo.getUserId();
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        PageReference pageRef = Page.RMA_CustomerPorforma_PDF;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef.getParameters().put('type','proforma');
        Test.setCurrentPage(pageRef);
        
        RMA_Certificate_Extension obj = new RMA_Certificate_Extension(sc);
        Test.setCurrentPage(pageRef);
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        test.startTest();
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Fab__c = 'FAB 9';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.OwnerId = userInfo.getUserId();
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        PageReference pageRef = Page.RMA_CustomerPorforma_PDF;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef.getParameters().put('type','proforma');
        Test.setCurrentPage(pageRef);
        
        RMA_Certificate_Extension obj = new RMA_Certificate_Extension(sc);
        Test.setCurrentPage(pageRef);
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest4() {
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];        
        
        test.startTest();       
        RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Return_Location__c = 'APLC';
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Fab__c = 'FAB 9';
        rmaRec.ReasonCode__c = 'R81';
        rmaRec.Alternative_Customer__c = acc.Id;
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Receiver_Address__c = 'testaddress';
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        PageReference pageRef = Page.RMA_CustomerPorforma_PDF;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        pageRef.getParameters().put('type','proforma');
        Test.setCurrentPage(pageRef);
        
        RMA_Certificate_Extension obj = new RMA_Certificate_Extension(sc);
        Test.setCurrentPage(pageRef);
        
        test.stopTest();
    }
}