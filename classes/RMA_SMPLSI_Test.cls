/**
 * Author: Cognizant Technology Solutions
 * Project: Return Material Authorization
 * Description: This class acts as a test class related to SMPLSI RMAs for the following apex classes:
     1. RMA_Trigger_Handler -- Method 4
 * History:
 *    NJain    17022016  -   Created.
 **/
@isTest(seeAllData=false)
public class RMA_SMPLSI_Test{
    @TestSetup
    static void loadTestData(){
        DataUtilTest.loadEnvironmentVariables();
        Test.startTest();
        Account acc = RMA_TestDataUtility.createAccountAgere();
        RMA__c rmaRec = RMA_TestDataUtility.createRMAAgere(1, acc); 
        Test.stopTest();
    }
    
    //Method to test the SMPLSI RMA
    static testmethod void testMethod4(){   
         
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = [select id,Customer__c from rma__c where IS_SMPLSI__c = true limit 1][0];
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Access_Impact__c = 'Quality / Reliability Impact';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Non_Fab_Personnel_1__c = UserInfo.getUserId();
            rmaRec.Notify_For_Non_Fab__c = UserInfo.getName();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLotAgere1-123456;';
            rmaRec.Lot_Comments__c = 'test comments';
            
            update rmaRec;
            
        
            RMA_TestDataUtility.createRMAReturnInvoiceAgere(rmaRec, acc);
            Test.startTest();              
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_View;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            rmaRec.recalculateFormulas();
            
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
                       
            //Approve record from Product Engg
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            try{
                Approval.ProcessResult result =  Approval.process(req);
            }catch(Exception ex){}
                        
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Acknowledged_Wafer_Return__c = true;
            rmaRec4.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec4.Quantity_Received__c = 1;
            rmaRec4.Date_of_Wafer_Receipt__c = system.today();
              
            update rmaRec4;                    
        	system.assertEquals(rmaRec4.Acknowledged_Wafer_Return__c,true);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec4.Id));
            try{
                Approval.ProcessResult result2 =  Approval.process(req2);
            }catch(Exception ex){}        
            Test.stopTest();
    }
    
    static testMethod void myTestMethod6(){
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = [select id,Customer__c from rma__c where IS_SMPLSI__c = true limit 1][0];
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Access_Impact__c = 'Quality / Reliability Impact';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Non_Fab_Personnel_1__c = UserInfo.getUserId();
            rmaRec.Notify_For_Non_Fab__c = UserInfo.getName();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLotAgere1-123456;';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Lot_Comments__c = 'test comments';
            
            update rmaRec;
            
        
            RMA_TestDataUtility.createRMAReturnInvoiceAgere(rmaRec, acc);
            test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_View;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            rmaRec.recalculateFormulas();
            
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
            try{
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            }catch(Exception ex){}
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            RMA_Trigger_Handler.provideAccess(rmalist);
            
            //Approve record from Product Engg
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            try{
                Approval.ProcessResult result =  Approval.process(req);
            }catch(Exception ex){}
            
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Acknowledged_Wafer_Return__c = true;
            rmaRec4.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec4.Quantity_Received__c = 1;
            rmaRec4.Date_of_Wafer_Receipt__c = system.today();
            update rmaRec4;
        	system.assertEquals(rmaRec4.Acknowledged_Wafer_Return__c,true);
            
            rmalist = database.query(query);
            
            RMA_Email_Notification_Helper.sendReminderEmail(rmaList,'Regional Reminder Due Date');
            test.stopTest();
            //RMA_Email_Notification_Helper.sendReminderEmail(rmaList,'Regional Reminder 1 Day');
            //RMA_Email_Notification_Helper.sendReminderEmail(rmaList,'Regional Reminder 2 Days');
    }
    
}