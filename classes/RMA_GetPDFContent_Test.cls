@isTest(SEEALLDATA = false)
private class RMA_GetPDFContent_Test {
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc);                                       
    }
    
    static testmethod void testMethod1(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        Test.startTest();//updating RMA with mandatory fields
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
         
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
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
            rmaRec.Lot_Device_To_Return__c = 'testLot1;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Business_Unit__c = 'ASIC';
            rmaRec.Product_Line__c = 'ASIC';
            rmaRec.Business_Category__c = 'ASIC';
            rmaRec.Warranty__c = 24;
            rmaRec.ReasonCode__c = 'R20';
            rmaRec.Return_Location__c = 'Burlington';
            rmaRec.Carrier_Vendor__c = 'CEVA';
            rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1;';
            rmaRec.Ship_from_Address__c = 'test address';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
        
        list<EmailTemplate> template  = [select id from EmailTemplate limit 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sendPDFEmail/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;

        RMA_GetPDFContent.sendEmail('manvendra.rathore@cognizant.com','manvendra.rathore@cognizant.com',rmaRec1.Id,template[0].id,'CustPerf');              
        Test.stopTest();
    }
    
    static testmethod void testMethod2(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        Test.startTest();//updating RMA with mandatory fields
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
         
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
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
            rmaRec.Lot_Device_To_Return__c = 'testLot1;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Business_Unit__c = 'ASIC';
            rmaRec.Product_Line__c = 'ASIC';
            rmaRec.Business_Category__c = 'ASIC';
            rmaRec.Warranty__c = 24;
            rmaRec.ReasonCode__c = 'R20';
            rmaRec.Return_Location__c = 'Burlington';
            rmaRec.Carrier_Vendor__c = 'CEVA';
            rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1;';
            rmaRec.Ship_from_Address__c = 'test address';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
        
        list<EmailTemplate> template  = [select id from EmailTemplate limit 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sendPDFEmail/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;

        RMA_GetPDFContent.sendEmail('manvendra.rathore@cognizant.com','manvendra.rathore@cognizant.com',rmaRec1.Id,template[0].id,'ReturnScrap'); 
    }

}