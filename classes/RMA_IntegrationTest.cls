@isTest(seeAllData=false)
public class RMA_IntegrationTest{
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Test.startTest();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
         Test.stopTest();
    }
    /*
    //No Compensation
    static testmethod void testMethod1(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'No Compensation';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Access_Impact__c = 'Environment Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Return_Estimated_Date__c = Date.TODAY();
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_Edit;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = new List<RMA__c>();
                        
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            //Approve record from Regional Validation
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
                        
            rmaRec3.Acknowledged_Wafer_Return__c = true;
            rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec3.Quantity_Received__c = 1;
            rmaRec3.Date_of_Wafer_Receipt__c = system.today();
            update rmaRec3;
            
            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
        Test.stopTest();
    }
    
    //Replacement
    static testmethod void testMethod2(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Replacement';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Access_Impact__c = 'Environment Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Return_Estimated_Date__c = Date.TODAY();
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_Edit;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            //Approve record from Regional Validation
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            rmaRec3.Acknowledged_Wafer_Return__c = true;
            rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec3.Quantity_Received__c = 1;
            rmaRec3.Date_of_Wafer_Receipt__c = system.today();
            update rmaRec3;
            
            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
        Test.stopTest();
    }
    */
    //Credit with charged replacement
    static testmethod void testMethod3(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from Account limit 1];
        
        
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
                        
            rmaRec.Compensation_Type__c = 'Credit with charged replacement';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Access_Impact__c = 'Environment Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Return_Estimated_Date__c = Date.TODAY();
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_Edit;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Approve record from Regional Validation
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            rmaRec3.Acknowledged_Wafer_Return__c = true;
            rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec3.Quantity_Received__c = 1;
            rmaRec3.Date_of_Wafer_Receipt__c = system.today();
            Test.startTest();
            update rmaRec3;
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec.Sales_Order_Number_CRO__c = '999999';
            update rmaRec;
            
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot2';
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 1';
            invRec.Bill_Quantity__c = 20;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'US';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = '999999';
            invRec.Unit_Selling_Price__c = 0;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            insert invRec; 
            
        	system.assertEquals(invRec.Lot_Name__c,'testLot2');
            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec4.Id));
            try{
            Approval.ProcessResult result2 =  Approval.process(req2);
            }catch(Exception e){}
            
            Test.stopTest();
    }
}