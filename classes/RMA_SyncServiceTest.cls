@isTest(seeAllData=false)
public class RMA_SyncServiceTest{
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
    
    //Method to test Approval of Business Category RMA
    static testmethod void testMethod1(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Credit';
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
            
            RMA_SyncService rmaSS = new RMA_SyncService();
            RMA_SyncService.SFRMASyncService_pt obj = new RMA_SyncService.SFRMASyncService_pt();
            List<RMA_SyncService.RMARecord> lstRMAWrap = new List<RMA_SyncService.RMARecord>();
            obj.process(lstRMAWrap);
			RMA_SyncService.RMAChild abc = new RMA_SyncService.RMAChild();
            RMA_SyncService.RMARecord abc2 = new RMA_SyncService.RMARecord();
        Test.stopTest();
    }
    
	/*
    static testmethod void testMethod2(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Credit';
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
        Test.stopTest();

            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            Approval.ProcessResult result2 =  Approval.process(req2);
    }
	*/
}