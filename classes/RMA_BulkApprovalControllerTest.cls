@isTest(SeeAllData=false)  
public class RMA_BulkApprovalControllerTest {
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc);                                                 
    }
    /* 
    static testMethod void testMethod1(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            List<RMA_Return_Invoice__c> rmiList =  RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            //RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            //RMA_Return_Invoice__c rmi = new RMA_Return_Invoice__c ( id = rmiList[0].id);
            
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
            rmaRec.Customer_request_date__c = System.TODAY()-1;
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
            rmaRec.ReasonCode__c = 'R50';
            rmaRec.Return_Location__c = 'Burlington';
            rmaRec.Carrier_Vendor__c = 'CEVA';
            rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Ship_from_Address__c = 'test address';
            rmaRec.Receiver_Address__c = 'test';
            rmaRec.Assign_To__c = 'Fab';
            update rmaRec;
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c ';
            List<RMA__c> rmalist1 = database.query(query);
            
            rmalist1[0].Disposition_by_Quality__c = 'PFA - Fab 10';
            rmalist1[0].Workflow_Stage__c = RMA_Constants.PEN_CQ_VAL;
            update rmalist1[0];
            
            String query2 = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query2);
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(rmalist);
            PageReference pageRef2 = Page.RMA_BulkApproval;  
            Test.setCurrentPage(pageRef2);
            RMA_BulkApprovalController BA = new RMA_BulkApprovalController();
            
            for(RMA_BulkApprovalController.RMAwrapper wrap: BA.getRMAWrapperRecords()){
                wrap.isSelected = TRUE;                
            }
            
            BA.SaveAndApprove();
            BA.Next();
            BA.First();
            BA.Last();
            BA.Previous();
            BA.Cancel();
            BA.setCon.getHasPrevious();
            BA.setCon.getHasNext();
            BA.setCon.getPageNumber();
            boolean hasNext = BA.hasNext;
            boolean hasPrev = BA.hasPrevious;
            integer p = BA.pageNumber;
            integer i = BA.noOfRecords;
            
            PermissionSetAssignment ps = [SELECT id,AssigneeId,Assignee.Profile.Name from PermissionSetAssignment 
                                            WHERE   PermissionSet.Name = 'RMA_Application_Access' 
                                                and Assignee.Profile.Name = 'GF CSR'
                                                and Assignee.isActive = true limit 1];
            string userId = '';
            if(ps != NULL){
                userId = ps.AssigneeId;
            }else{
                userId = userInfo.getUserId();
            }
            User usr1= [select id from User where Id = :UserId limit 1];
            System.runAs(usr1){
                try{
                    BA.SaveAndApprove();
                }catch(Exception e){}
            }
        Test.stopTest();
    }
    
    static testMethod void testMethod2(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            List<RMA_Return_Invoice__c> rmiList =  RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            
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
            rmaRec.Customer_request_date__c = System.TODAY()-1;
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
            rmaRec.ReasonCode__c = 'R50';
            rmaRec.Return_Location__c = 'Burlington';
            rmaRec.Carrier_Vendor__c = 'CEVA';
            rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Ship_from_Address__c = 'test address';
            rmaRec.Receiver_Address__c = 'test';
            rmaRec.Assign_To__c = 'Fab';
            update rmaRec;
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc2);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c ';
            List<RMA__c> rmalist1 = database.query(query);
            
            String query2 = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query2);
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(rmalist);
            PageReference pageRef2 = Page.RMA_BulkApproval;  
            Test.setCurrentPage(pageRef2);
            RMA_BulkApprovalController BA = new RMA_BulkApprovalController();
            
            for(RMA_BulkApprovalController.RMAwrapper wrap: BA.getRMAWrapperRecords()){
                wrap.isSelected = FALSE;                
            }
            
            BA.SaveAndApprove();
        Test.stopTest();
    }
    */
    static testMethod void testMethod3(){
        RMA__c rmaRecNew = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(new List<RMA__c>());
            PageReference pageRef2 = Page.RMA_BulkApproval;
            RMA_BulkApprovalController obj = new RMA_BulkApprovalController();
            obj.getRMAWrapperRecords();
            obj.SaveAndApprove();
            List<RMA_BulkApprovalController.RMAwrapper> lstwrap = new List<RMA_BulkApprovalController.RMAwrapper>();
            lstwrap.add(new RMA_BulkApprovalController.RMAwrapper(true,new RMA__c()));
            
            obj.First();
            obj.Last();
            obj.Previous();
            obj.Next();
            obj.Cancel();
            boolean hasNext = obj.hasNext;
            boolean hasPrev = obj.hasPrevious;
            integer p = obj.pageNumber;
            integer i = obj.noOfRecords;
            
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRecNew, acc);
            //updating RMA with mandatory fields
            rmaRecNew.Access_Impact__c = 'Safety Impact';
            rmaRecNew.Description_Return_Particulars__c = 'test';
            rmaRecNew.Description_of_Reason_s__c = 'test';
            rmaRecNew.RMA_Category__c = 'Technical/ Turnkey';
            rmaRecNew.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
            rmaRecNew.Justification_Fab_Validation__c = 'test';
            rmaRecNew.Justification_PRF__c = 'test';
            rmaRecNew.Justification_CAR__c = 'test';
            rmaRecNew.Justification_FOC__c = 'test';
            rmaRecNew.Justification_Field_Reliability_Failure__c = 'test';
            rmaRecNew.Potential_Impact_Wafers__c = 20;
            rmaRecNew.Region_Head__c = UserInfo.getUserId();
            rmaRecNew.Sales_SVP__c = UserInfo.getUserId();
            rmaRecNew.Return_Estimated_Date__c = System.Today()+2;
            rmaRecNew.Assign_to__c = 'Fab';
            rmaRecNew.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
            rmaRecNew.Customer_Request_Date__c = System.TODAY()-1;
            update rmaRecNew;
            lstwrap.add(new RMA_BulkApprovalController.RMAwrapper(true,rmaRecNew));
            obj.lstRMAwrapper.addAll(lstwrap);
            obj.SaveAndApprove();
            rmaRecNew.Disposition_By_Quality__c = 'Scrap';
            obj.lstRMAwrapper.clear();
            obj.lstRMAwrapper.add(new RMA_BulkApprovalController.RMAwrapper(true,rmaRecNew));
            obj.SaveAndApprove();
            obj.dummyMethod();
        Test.stopTest();
    }
}