/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for RMA_AccessClass
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    01/25/2016           Test class created.       
**/

@isTest(SEEALLDATA = false)
private class RMA_AccessClass_Test {
    
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc);
    }
    
    static testmethod void testMethod1(){
        Test.startTest();
        RMA__c rmaRec = [select id from RMA__c limit 1];
        Account acc = [select id from Account limit 1];
        
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesAgere(1,acc);
        
        User usr1 = [select id from User where Id != :UserInfo.getUserId() and Profile.Name = 'System Administrator' and isActive = TRUE limit 1];
        
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Compensation_Type__c = 'Credit';
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
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Status__c = 'Draft';
            rmaRec.OwnerId = userInfo.getUserId();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            
            RMA_AccessClass accObj = new RMA_AccessClass(sc);
            accObj.checkStorePersonnel();
            accObj.checkReturnToGF();
            accObj.checkScrap();
            accObj.CheckStageBeforeRejection(rmaRec.Id);
            accObj.QueryRMAaccessOrGroups('Fab','RMA_Fab_1',rmaRec.Id);
            
            rmaRec.Status__c = 'Submitted';
            update rmaRec;
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec);
            RMA_AccessClass accObj2 = new RMA_AccessClass(sc2);
            
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_to_Return__c = 'testLot1-123456;';
            update rmaRec;
            ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec);
            RMA_AccessClass accObj3 = new RMA_AccessClass(sc3);
            
            rmaRec.Disposition_of_Wafers__c = 'Return to GF and to Scrap at Customer Site';
            update rmaRec;
            ApexPages.StandardController sc4 = new ApexPages.StandardController(rmaRec);
            RMA_AccessClass accObj4 = new RMA_AccessClass(sc4);
            
            rmaRec.Workflow_Stage__c = 'Rejected RMA';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            ApexPages.StandardController sc5 = new ApexPages.StandardController(rmaRec1);
            RMA_AccessClass accObj5 = new RMA_AccessClass(sc5);
            accObj5.CheckTabVisibility(rmaRec1.Grand_Total_Price__c);
            accObj5.CheckStageBeforeRejection(rmaRec1.Id);
            
            rmaRec1.Workflow_Stage__c = 'Pending for Finance Approval - Verifier';
            update rmaRec;
            system.assertEquals(rmaRec1.Workflow_Stage__c,'Pending for Finance Approval - Verifier');
            List<RMA__c> rmalist1 = database.query(query);
            RMA__c rmaRec2 = rmaList1[0];
            
            ApexPages.StandardController sc6 = new ApexPages.StandardController(rmaRec2);
            RMA_AccessClass accObj6 = new RMA_AccessClass(sc6);
            accObj6.CheckTabVisibility(rmaRec2.Grand_Total_Price__c);
            
        Test.stopTest();
    }
    
    static testmethod void testMethod2(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        User usr1 = [select id from User where Id != :UserInfo.getUserId() and Profile.Name = 'System Administrator' and isActive = TRUE limit 1];
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
        
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Compensation_Type__c = 'Credit';
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
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Status__c = 'Draft';
            rmaRec.OwnerId = userInfo.getUserId();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            
            RMA_AccessClass accObj = new RMA_AccessClass(sc);
            accObj.checkStorePersonnel();
            accObj.checkReturnToGF();
            accObj.checkScrap();
            accObj.CheckStageBeforeRejection(rmaRec.Id);
            accObj.QueryRMAaccessOrGroups('Fab','RMA_Fab_1',rmaRec.Id);
            
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_FAB_VAL;
            update rmaRec;
            //system.assertEquals(rmaRec.Workflow_Stage__c,'RMA Raised');
            
            ApexPages.StandardController sc5 = new ApexPages.StandardController(rmaRec);
            rmaRec.Status__c = RMA_Constants.REJECTED_STATUS;
            update rmaRec;
            ApexPages.StandardController sc6 = new ApexPages.StandardController(rmaRec);
            
        
            test.StopTest();
    }
    
    static testmethod void testMethod3(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        User usr1 = [select id from User where Id != :UserInfo.getUserId() and Profile.Name = 'System Administrator' and isActive = TRUE limit 1];
        Account acc = [select id from Account limit 1];
        
        List<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'System Administrator'
                            and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 2];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = ulist[0].id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c limit 1';
        
        system.runAs(ulist[0]){
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Compensation_Type__c = 'Credit';
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
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1;';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.OwnerId = [select Id from User where isActive=true and Profile.Name = 'System Administrator' and Id <>: userInfo.getUserId() limit 1].Id;
            update rmaRec;

            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            RMA_AccessClass accObj = new RMA_AccessClass(sc);
            
            rmaRec1.Status__c = 'Submitted';
            rmaRec1.Workflow_Stage__c = RMA_Constants.PEN_FAB_VAL;
            update rmaRec1;
            
            system.assertEquals(rmaRec1.Status__c,'Submitted');
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec2);
            RMA_AccessClass accObj2 = new RMA_AccessClass(sc2);
            
            rmaRec2.Workflow_Stage__c = RMA_Constants.PEN_TNK_VAL;
            update rmaRec2;

            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec3);
            RMA_AccessClass accObj3 = new RMA_AccessClass(sc3);

            rmaRec3.Workflow_Stage__c = RMA_Constants.PEN_NONFAB_VAL;
            update rmaRec3;

            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            ApexPages.StandardController sc4 = new ApexPages.StandardController(rmaRec4);
            RMA_AccessClass accObj4 = new RMA_AccessClass(sc4);
            
            rmaRec4.Workflow_Stage__c = RMA_Constants.PEN_REC_WAF;
            update rmaRec4;

            rmalist = database.query(query);
            RMA__c rmaRec5 = rmaList[0];
            
            ApexPages.StandardController sc5 = new ApexPages.StandardController(rmaRec5);
        
        Test.stopTest();
        }
    }
   
   static testMethod void testMethod4() {
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select Id from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
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
            rmaRec.Status__c = RMA_Constants.DRAFT_STATUS;
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            system.assertEquals(rmaRec.Lot_Device_To_Return__c,'testLot1-123456;');  
            obj.sumbitForApproval();
            
            rmaList = new List<RMA__c>();
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Rejecting RMA. This triggers RMA_Audit_log object to insert a record and reset RMA queue in queue out values.
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request.');
            req.setAction('Reject');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
                                             
           Test.stopTest();
    }
    
    static testMethod void testMethod5() {
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select Id from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
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
            rmaRec.Status__c = RMA_Constants.DRAFT_STATUS;
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
        
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec1);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            update rmaRec;
            obj.sumbitForApproval();
            
            //checking stage of the rma record before rejection        
            RMA_AccessClass AC = new RMA_AccessClass(sc);
            AC.CheckStageBeforeRejection(rmaRec.Id);
            AC.CheckStageBeforeVoid(rmaRec.Id);
            
            rmaList = new List<RMA__c>();
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            
        
            //Rejecting RMA. This triggers RMA_Audit_log object to insert a record and reset RMA queue in queue out values.
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request.');
            req.setAction('Reject');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            rmaList = new List<RMA__c>();
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(rmaRec3);
            PageReference pageRef1 = Page.RMA_view;
            pageRef1.getParameters().put('id', String.valueOf(rmaRec3.Id));
            Test.setCurrentPage(pageRef1);
            RMA_Edit_Extension obj1 = new RMA_Edit_Extension(sc1);
            Test.setCurrentPage(pageRef1);
            obj1.RMARecord.Reason_to_Void__c = 'Test Voided';
            obj1.voidRMA();
            
            system.assertEquals(obj1.RMARecord.Reason_to_Void__c,'Test Voided');                                                
            rmaList = new List<RMA__c>();
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec4);
            PageReference pageRef2 = Page.RMA_view;
            pageRef2.getParameters().put('id', String.valueOf(rmaRec4.Id));
            Test.setCurrentPage(pageRef2);
            
           Test.stopTest();
    }
    
    static testMethod void testMethod6() {
        Account acc = [Select id from account limit 1][0];
        RMA__c rmaRec = [select Id from RMA__c limit 1][0];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            //updating RMA with mandatory fields
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Assign_To__c = 'Fab';
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_due_to_Field_reliability_Failure__c = true;
            rmaRec.Lot_Device_FRF__c = 'testLot1';
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = RMA_Constants.DRAFT_STATUS;
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
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
            
            List<RMA__c> rmalist2 = database.query(query);
            rmaRec1 = rmaList2[0];
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(rmaRec1);
            RMA_AccessClass rmaAcc = new RMA_AccessClass(sc2);
            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request.');
            req.setAction('Reject');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult result = Approval.process(req);
            
            List<RMA__c> rmalist3 = database.query(query);
            rmaRec1 = rmaList3[0];
            
            rmaRec.Reason_to_Void__c = 'test reason';
            update rmaRec1;
            system.assertEquals(rmaRec.Reason_to_Void__c,'test reason');
            obj.RMARecord.Reason_to_Void__c = 'test reason';
            obj.voidRMA();
            List<RMA__c> rmalist4 = database.query(query);
            rmaRec1 = rmaList4[0];
            
            ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaRec1);
            RMA_AccessClass rmaAcc2 = new RMA_AccessClass(sc3);
            rmaAcc2.CheckStageBeforeVoid(rmaRec1.Id);
        Test.stopTest();
    }
    
    static testMethod void testMethod7(){
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc);
        
        
            List<RMA_Return_Invoice__c> rmiList =  RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_Return_Invoice__c rmi = new RMA_Return_Invoice__c ( id = rmiList[0].id);
            
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
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
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
            Test.startTest();
            obj2.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where Fab__c in (\'FAB 9\',\'FAB 10\')';
            List<RMA__c> rmalist1 = database.query(query);
            
            rmalist1[0].Disposition_by_Quality__c = 'PFA - Fab 10';
            rmalist1[0].Lot_Comments__c = 'test';
            rmalist1[0].Status__c = 'Submitted';
            rmalist1[0].Workflow_Stage__c = RMA_Constants.PEN_CQ_VAL;
            update rmalist1[0];
            
            List<RMA__c> rmalist2 = database.query(query);
            ApexPages.StandardController sc3 = new ApexPages.StandardController(rmaList2[0]);
            
            RMA_AccessClass rmaAcc2 = new RMA_AccessClass(sc3);
            
            //Approving the RMA
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request.');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaList2[0].Id));
            Approval.ProcessResult result =  Approval.process(req);
            
            List<RMA__c> rmalist3 = database.query(query);
            ApexPages.StandardController sc4 = new ApexPages.StandardController(rmaList3[0]);
            RMA_AccessClass rmaAcc3 = new RMA_AccessClass(sc4);
            
            List<user> ulist2 = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'GF Consultants' and id != :UserInfo.getUserId() limit 2];
            if(!ulist2.isEmpty()){
                System.runAs(ulist2[0]){
                    RMA_AccessClass.hasAdminPriv();
                }    
            }
            
            List<user> ulist3 = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'GF Developer' and id != :UserInfo.getUserId() limit 2];
            if(!ulist3.isEmpty()){
                System.runAs(ulist3[0]){
                    RMA_AccessClass.hasAdminPriv();
                }    
            }
            
            List<user> ulist4 = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'GF Integration' and id != :UserInfo.getUserId() limit 2];
            if(!ulist4.isEmpty()){
                System.runAs(ulist4[0]){
                    RMA_AccessClass.hasAdminPriv();
                }    
            }
            
            List<user> ulist5 = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'GF System Admin' and id != :UserInfo.getUserId() limit 2];
            if(!ulist5.isEmpty()){
                System.runAs(ulist5[0]){
                    RMA_AccessClass.hasAdminPriv();
                }    
            }
            
            List<user> ulist6 = [select id from user where isactive = true and profile.UserType = 'Standard' 
                            and profile.Name = 'GF CSR' and id != :UserInfo.getUserId() limit 2];
            if(!ulist6.isEmpty()){
                System.runAs(ulist6[0]){
                    RMA_AccessClass.hasAdminPriv();
                }    
            }
            system.assertNotEquals(ulist6[0].Id,UserInfo.getUserId());
        Test.stopTest();
    }
    
}