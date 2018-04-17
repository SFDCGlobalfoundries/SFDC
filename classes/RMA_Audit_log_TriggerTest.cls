/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a utility class for creating test data related to RMA.
 * History:
 *    SurendranadhNune 09022016  -   Created.
 *                            
 **/
@isTest(seeAllData=false)
private class RMA_Audit_log_TriggerTest {
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
    }
    
    static testMethod void testupdateRejectedRMA() {
       
       Test.startTest();
           RMA__c rmaRec = [select id from RMA__c limit 1]; 
           Account acc = [select id from Account limit 1];
           
           RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
           RMA_TestDataUtility.createInvoicesForFab9(1,acc);
                       
            //updating RMA with mandatory fields
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.customer_request_date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            obj2.sumbitForApproval();
            
            //Rejecting RMA. This triggers RMA_Audit_log object to insert a record and reset RMA queue in queue out values.
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request.');
            req.setAction('Reject');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            List<rma_audit_log__c> cycletimelogList = new List<rma_audit_log__c>([select id from rma_audit_log__c where recordtypeid=:RMA_utility.getRecordTypeId('rma_audit_log__c', RMA_Constants.CYCLE_TIME_LOG)]);
            system.assert(cycletimelogList.size() > 0);
       Test.stopTest();
    }
}