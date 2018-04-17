@isTest
global class RMA_Delinquent_Controller_Test{
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
    
    static testmethod void testMethod1(){
        RMA__c rmaRec = [select id,Workflow_Stage__c from rma__c limit 1][0];
        Account acc = [select id from account limit 1];
        
        Test.startTest();            
            RMA_Delinquent_Summary_Report_Controller obj = new RMA_Delinquent_Summary_Report_Controller();
            PageReference pageRef = Page.RMA_Delinquent_Summary_Report;
            Test.setCurrentPage(pageRef);
            
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);            
            obj.retreiveRMAWrapperList();
            
            RMA_Delinquent_Summary_Report_Controller obj2 = new RMA_Delinquent_Summary_Report_Controller();
            RMA__c rmaRec3 = [select id from RMA__c limit 1];
            rmaRec3.Workflow_Stage__c = RMA_Constants.PEN_CQ_VAL;
            rmaRec3.Queue_in_Time_for_CSR_Submission__c = System.Now() - 20;
            rmaRec3.Queue_out_Time_for_CSR_Submission__c = System.Now() - 4;
            rmaRec3.Queue_in_Time_for_CQ_Validation__c = System.Now() - 4;
            rmaRec3.Disposition_by_Quality__c = 'Scrap';
            update rmaRec3;
            obj2.retreiveRMAWrapperList();
            
            RMA_Delinquent_Summary_Report_Controller obj3 = new RMA_Delinquent_Summary_Report_Controller();
            
            RMA__c rmaRec2 = [select id from RMA__c limit 1];
            rmaRec2.RMA_Category__c = 'Business';
            rmaRec2.Potential_Impact_Wafers__c = 1;
            rmaRec2.Lot_Comments__c = 'test';
            rmaRec2.Access_Impact__c = 'Environment Impact';
            rmaRec2.Description_of_Reason_s__c = 'test';
            rmaRec2.Lot_Device_To_Return__c = 'testLot1-123456';
            rmaRec2.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec2.Region_Head__c = UserInfo.getUserId();
            rmaRec2.Sales_SVP__c = UserInfo.getUserId();
            rmaRec2.Acknowledged_Wafer_Return__c = true;
            rmaRec2.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec2.Quantity_Received__c = 1;
            rmaRec2.Cycle_Time_for_Regional_Approval__c = 1;
            rmaRec2.Queue_out_Time_for_CQ_Validation__c = System.Now() - 4;
            rmaRec2.Queue_in_Time_for_CQ_Validation__c = System.Now() - 4;
            rmaRec2.Queue_in_Time_for_Regional_Approval__c = System.Now() - 4;
            rmaRec2.Workflow_Stage__c = 'Pending for Regional Recommendation - Director';
            rmaRec2.Status__c = 'Submitted';
            update rmaRec2;
            rmaRec2.recalculateFormulas();
            
            obj3.retreiveRMAWrapperList();
            
            //Approve record
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            RMA_Delinquent_Summary_Report_Controller obj4 = new RMA_Delinquent_Summary_Report_Controller();
            obj4.retreiveRMAWrapperList();
            
            //Reject record
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejecting request.');
            req2.setAction('Reject');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
            RMA_Delinquent_Summary_Report_Controller obj5 = new RMA_Delinquent_Summary_Report_Controller();
            obj5.retreiveRMAWrapperList();
            
            obj.queryBuilder();
            obj.first();
            obj.last();
            obj.next();
            obj.previous();
            obj.refresh();
            obj.exportCsvFile();
            boolean hasNext = obj.hasNext;
            boolean hasPrev = obj.hasPrevious;
            integer p = obj.pageNumber;
            integer i = obj.noOfRecords;
        Test.stopTest();   
    }
        
}