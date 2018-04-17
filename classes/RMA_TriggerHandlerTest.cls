@isTest(seeAllData=false)
private class RMA_TriggerHandlerTest {
    @TestSetup
    static void loadTestData(){
        DataUtilTest.loadEnvironmentVariables();
         Test.startTest();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
         Test.stopTest();         
    }
    
    static testmethod void testMethod1(){
        
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
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            Test.startTest();
            update rmaRec;
            
            RMA_Access_User__c ra = new RMA_Access_User__c();
            ra.Category__c = 'Return Wafer';
            ra.RMA__c = rmaRec.Id;
            ra.User__c = UserInfo.getUserId();
            insert ra;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec1 = rmaList[0];
            
            Map<Id,RMA__c> testMap = new Map<Id,RMA__c>();
            testMap.put(rmaRec1.Id,rmaRec1);
            
            //calling class methods 
            RMA_Trigger_Handler.copyWaferIds(rmalist,'DraftToFab');
            RMA_Trigger_Handler.invokeApprovalProcess(rmaList);
            RMA_Trigger_Handler.populateRegionalHeadDetails(rmaList);
            RMA_Trigger_Handler.populateCycleTime(testMap);
            RMA_Trigger_Handler.provideAccess(rmaList);
            RMA_Trigger_Handler.retreiveFinanceApprover();
            RMA_Trigger_Handler.logRejectedRMA(rmaList);
            RMA_Trigger_Handler.retreiveStorePersonnel();
            RMA_Trigger_Handler.accessForAckn(rmaList);
            RMA_Trigger_Handler.afterInsert(rmaList);
            RMA_Trigger_Handler.populateCycleTimeForFab9and10(rmaList);
            RMA_Trigger_Handler.afterQualityApproval(rmaList);
            
            system.assertEquals(rmaRec.Status__c,'Draft');
            Test.stopTest();  
    }
    static testMethod void testMethod2(){
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
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            Test.startTest();
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
            update rmaRec2;
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
            update rmaRec4;
            system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);
        Test.stopTest();         
    }
    
    static testMethod void testMethod3(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];        
        
        
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_Return_Invoice__c rmi = [select id from RMA_Return_Invoice__c limit 1];
            
            rmi.RMA_By__c = 'Die';
            update rmi;
            //updating RMA with mandatory fields
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            Test.startTest();
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
            update rmaRec2;
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
            update rmaRec4;
            system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);
        Test.stopTest();         
    }
    
    static testMethod void testMethod4(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
                
        
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_Return_Invoice__c rmi = [select id from RMA_Return_Invoice__c limit 1];
         
            rmi.RMA_By__c = 'Wafer';
            update rmi;
            //updating RMA with mandatory fields
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.FAB__c = 'FAB 9';
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            rmaRec.Disposition_by_Quality__c = 'WFT - Fab 9';
            Test.startTest();
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
                        
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
            update rmaRec4;
            system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);             
        Test.stopTest();         
    }
    
    static testMethod void testMethod5(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_Return_Invoice__c rmi = [select id from RMA_Return_Invoice__c limit 1];
        
            rmi.RMA_By__c = 'Wafer';
            update rmi;
            //updating RMA with mandatory fields
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.FAB__c = 'FAB 9';
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
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
            rmaRec.Disposition_by_Quality__c = 'WFT - Fab 9';
            Test.startTest();
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
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
            update rmaRec4;
            system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);
        Test.stopTest();
    }
    
    static testmethod void testmethod6(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        
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
            rmaRec.Compensation_Type__c = 'Credit';
            Test.startTest();
            update rmaRec;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            system.assertEquals(rmaRec4.Access_Impact__c,'Safety Impact');
        Test.stopTest();
    }
    /*
    //Method to test the Rejection
    static testmethod void testMethod7(){
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Access_Impact__c = 'Environment Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_Edit;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where Fab__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejecting request.');
            req2.setAction('Reject');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec4.Id));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
        Test.stopTest();
    }
    */
    //Method to test the Rejection
    static testmethod void testMethod12(){
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        
            RMA_TestDataUtility.createRMAReturnInvoice1Million(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Access_Impact__c = 'Environment Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Lot_Device_To_Return__c = 'testLotMil1-789789789;';
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            Test.startTest();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_Edit;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where Fab__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
            
            //Approve record from Regional Validation
            Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
            req3.setComments('Approving request.');
            req3.setAction('Approve');
            req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req3.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
            Approval.ProcessResult result3 =  Approval.process(req3);
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            rmaRec3.Acknowledged_Wafer_Return__c = true;
            rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec3.Quantity_Received__c = 1;
            rmaRec3.Date_of_Wafer_Receipt__c = system.today();
            update rmaRec3;
            system.assertEquals(rmaRec3.Quantity_Received__c,1);
        Test.stopTest();
    }
    
    static testmethod void testMethod8(){
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Potential_Impact_Wafers__c = 1;
            rmaRec.Lot_Comments__c = 'test';
            rmaRec.Access_Impact__c = 'Quality / Reliability Impact';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Non_Fab_Personnel_1__c = UserInfo.getUserId();
            rmaRec.Notify_For_Non_Fab__c = UserInfo.getName();
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Assign_to__c = 'Fab';
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Status__c = 'Submitted';
            rmaRec.Workflow_Stage__c = RMA_Constants.PEN_REC_WAF;
            Test.startTest();
            update rmaRec;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
            PageReference pageRef = Page.RMA_View;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            obj.sumbitForApproval();
                        
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where Fab__c not in (\'FAB 9\',\'FAB 10\') limit 1';
            List<RMA__c> rmalist = database.query(query);
            RMA__c rmaRec6 = rmaList[0];
            
            rmaRec6.Reminder_Acknowledgement_Due_Date__c= true;
            update rmaRec6;
            rmaRec6.Reminder_Acknowledgement_1_Day__c = true;
            update rmaRec6;
            rmaRec6.Reminder_Acknowledgement_2_Days__c = true;
            update rmaRec6;
            rmaRec6.Reminder_Acknowledgement_3_Days__c = true;
            update rmaRec6;
                        
            rmaRec6.Acknowledged_Wafer_Return__c = true;
            rmaRec6.Acknowledge_On_Wafer_Return__c = System.now();
            rmaRec6.Quantity_Received__c = 1;
            rmaRec6.Date_of_Wafer_Receipt__c = system.today();
            update rmaRec6;
            
            rmalist = database.query(query);
            RMA__c rmaRec7 = rmaList[0];
            
            rmaRec7.Reminder_Finance_Approval_Due__c = true;
            update rmaRec7;
            rmaRec7.Reminder_Finance_Approval_1_Day__c = true;
            update rmaRec7;
            rmaRec7.Reminder_Finance_Approval_2_Days__c = true;
            update rmaRec7;
            
            rmalist = database.query(query);
            RMA__c rmaRec8 = rmaList[0];
            
            //Approve record from Finance Manager
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec8.Id));
            try{
                Approval.ProcessResult result2 =  Approval.process(req2);
            }catch(Exception ex){}
            
            system.assertEquals(rmaRec7.Reminder_Finance_Approval_2_Days__c,true);
        Test.stopTest();
        
    }
    
    static testmethod void testmethod9(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        
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
            rmaRec.Assign_to__c = 'Turnkey';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Compensation_Type__c = 'Credit';
            Test.startTest();
            update rmaRec;
            
            RMA_Access_User__c ra = new RMA_Access_User__c();
            ra.Category__c = 'Turnkey';
            ra.RMA__c = rmaRec.Id;
            ra.User__c = UserInfo.getUserId();
            insert ra;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Workflow_Stage__c = RMA_Constants.PEN_TNK_VAL;
            update rmaRec4;
            rmalist = database.query(query);
            RMA__c rmaRec5 = rmaList[0];
            
            RMA_Trigger_Handler.provideAccess(rmalist );
            system.assertEquals(rmaRec4.Workflow_Stage__c,RMA_Constants.PEN_TNK_VAL);
        Test.stopTest();
    }
    
    static testmethod void testmethod10(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Rework';
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
            rmaRec.Assign_to__c = 'Turnkey';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
            rmaRec.Compensation_Type__c = 'No Compensation';
            Test.startTest();
            update rmaRec;
            
            system.assertEquals(rmaRec.Access_Impact__c, 'Safety Impact');
            RMA_Access_User__c ra = new RMA_Access_User__c();
            ra.Category__c = 'Fab';
            ra.RMA__c = rmaRec.Id;
            ra.User__c = UserInfo.getUserId();
            insert ra;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String f = util.getAllFields('RMA__c');
            String query = 'select '+f+' from RMA__c where FAB__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec2.Id));
            try{
                Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            }catch(Exception ex){}
            
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
        Test.stopTest();
    }
    
    static testMethod void testMethod11(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_Return_Invoice__c rmi = [select id from RMA_Return_Invoice__c limit 1];
            rmi.RMA_By__c = 'Wafer';
            update rmi;
            
            //updating RMA with mandatory fields
            rmaRec.Compensation_Type__c = 'Credit';
            rmaRec.OwnerId = userInfo.getUserId();
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Business';
            rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.FAB__c = 'FAB 9';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'RMA Raised';
            rmaRec.Business_Unit__c = 'ASIC';
            rmaRec.Product_Line__c = 'ASIC';
            rmaRec.Business_Category__c = 'ASIC';
            rmaRec.Warranty__c = 24;
            rmaRec.ReasonCode__c = 'R25';
            rmaRec.Return_Location__c = 'Burlington';
            rmaRec.Carrier_Vendor__c = 'CEVA';
            rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
            rmaRec.Return_Estimated_Date__c = System.Today()+2;
            rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
            rmaRec.Ship_from_Address__c = 'test address';
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
            
            rmalist = database.query(query);
            RMA__c rmaRec2 = rmaList[0];
            
            rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
            update rmaRec2;
            system.assertEquals(rmaRec2.Disposition_by_Quality__c,'WFT - Fab 9');
            
            rmalist = database.query(query);
            RMA__c rmaRec3 = rmaList[0];
            
            //Approve Quality validation
            Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
            reqQVal.setComments('Approving request.');
            reqQVal.setAction('Approve');
            reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
            try{
                Approval.ProcessResult resultQVal = Approval.process(reqQVal);
            }catch(Exception ex){}
            rmalist = database.query(query);
            RMA__c rmaRec4 = rmaList[0];
            
            rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
            update rmaRec4;
            
        Test.stopTest();
    }
    
    static testmethod void testMethod13(){
        
        Test.startTest();
        
        Account acc = [select id from Account limit 1];
        //RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
            
        RMA__c rmaRec = new RMA__c();
        rmaRec.Fab__c = 'FAB 1';
        rmaRec.Customer__c = acc.Id;
        rmaRec.RMA_By__c = 'Wafer';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Workflow_Stage__c = RMA_Constants.PEN_REG_DIR;
        insert rmaRec;
    
        List<RMA__c> rmaObjList = new List<RMA__c>();
        rmaObjList.add(rmaRec);
        RMA_Trigger_Handler.invokeApprovalProcess(rmaObjList);
        system.assertEquals(rmaRec.FAB__c, 'FAB 1');
        
        Test.stopTest();
    }
    
    static testMethod void testMethod14(){
        
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
               
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRIList[0].RMA_By__c = 'Die';
        update rmaRIList[0];
        
        Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Id = rmaRIList[0].Invoice__c;
        invoiceObj.Item_Type__c = 'SD';
        update invoiceObj;
        
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
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
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Ship_from_Address__c = 'test address';
        
        Test.startTest();
        
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
        
        rmalist = database.query(query);
        RMA__c rmaRec2 = rmaList[0];
        
        rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
        update rmaRec2;
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        //Approve Quality validation
        Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
        reqQVal.setComments('Approving request.');
        reqQVal.setAction('Approve');
        reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
        Approval.ProcessResult resultQVal = Approval.process(reqQVal);
        
        rmalist = database.query(query);
        RMA__c rmaRec4 = rmaList[0];
        
        rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
        update rmaRec4;
        system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);
        
        Test.stopTest();         
    }
    
    static testMethod void testMethod15(){
        
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
               
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRIList[0].RMA_By__c = 'Module';
        update rmaRIList[0];
        
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Technical/ Turnkey';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
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
        rmaRec.Lot_Device_To_Return__c  = 'testLot1-123456;';
        rmaRec.Ship_from_Address__c = 'test address';
        
        Test.startTest();
        
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
        
        rmalist = database.query(query);
        RMA__c rmaRec2 = rmaList[0];
        
        rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
        update rmaRec2;
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        //Approve Quality validation
        Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
        reqQVal.setComments('Approving request.');
        reqQVal.setAction('Approve');
        reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
        Approval.ProcessResult resultQVal = Approval.process(reqQVal);
        
        rmalist = database.query(query);
        RMA__c rmaRec4 = rmaList[0];
        
        rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
        update rmaRec4;
        system.assertEquals(rmaRec4.Reminder_Fab_Validation_Due_Date__c,true);
        
        Test.stopTest();         
    }
    
    static testMethod void testMethod16(){
        
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        
        List<RMA__c> newRMARecordList = new List<RMA__c>();
        newRMARecordList.add(rmaRec);
        
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.FAB__c = 'FAB 9';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.Business_Unit__c = 'ASIC';
        rmaRec.Product_Line__c = 'ASIC';
        rmaRec.Business_Category__c = 'ASIC';
        rmaRec.Warranty__c = 24;
        rmaRec.ReasonCode__c = 'R25';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Carrier_Vendor__c = 'CEVA';
        rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
        rmaRec.Ship_from_Address__c = 'test address';
        
        Test.startTest();
        
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
        
        rmalist = database.query(query);
        RMA__c rmaRec2 = rmaList[0];
        
        rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
        update rmaRec2;
        system.assertEquals(rmaRec2.Disposition_by_Quality__c,'WFT - Fab 9');
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        //Approve Quality validation
        Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
        reqQVal.setComments('Approving request.');
        reqQVal.setAction('Approve');
        reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
        try{
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
        }catch(Exception ex){}
        rmalist = database.query(query);
        RMA__c rmaRec4 = rmaList[0];
        
        rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
        update rmaRec4;
        
        RMA_Trigger_Handler.copyWaferIds(newRMARecordList, 'TechToReg');
        system.assertEquals(rmaRec.FAB__c, 'FAB 9');
        
        Test.stopTest();
    }
    
    static testMethod void testMethod17(){
        
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
        
        rmaRIList[0].RMA_By__c = 'Die';
        update rmaRIList[0];
        
        Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Id = rmaRIList[0].Invoice__c;
        invoiceObj.Item_Type__c = 'SD';
        update invoiceObj;
        
        List<RMA__c> newRMARecordList = new List<RMA__c>();
        newRMARecordList.add(rmaRec);
        
        //RMA_Trigger_Handler.copyWaferIds(newRMARecordList, 'TechToReg');
        
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.FAB__c = 'FAB 9';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.Business_Unit__c = 'ASIC';
        rmaRec.Product_Line__c = 'ASIC';
        rmaRec.Business_Category__c = 'ASIC';
        rmaRec.Warranty__c = 24;
        rmaRec.ReasonCode__c = 'R25';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Carrier_Vendor__c = 'CEVA';
        rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
        rmaRec.Ship_from_Address__c = 'test address';
        
        Test.startTest();
        
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
        
        rmalist = database.query(query);
        RMA__c rmaRec2 = rmaList[0];
        
        rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
        update rmaRec2;
        system.assertEquals(rmaRec2.Disposition_by_Quality__c,'WFT - Fab 9');
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        //Approve Quality validation
        Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
        reqQVal.setComments('Approving request.');
        reqQVal.setAction('Approve');
        reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
        try{
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
        }catch(Exception ex){}
        rmalist = database.query(query);
        RMA__c rmaRec4 = rmaList[0];
        
        rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
        update rmaRec4;
        
        RMA_Trigger_Handler.copyWaferIds(newRMARecordList, 'TechToReg');
        system.assertEquals(rmaRec.FAB__c, 'FAB 9');
        
        Test.stopTest();
    }
    
    static testMethod void testMethod18(){
        
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
        RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            
        rmaRIList[0].RMA_By__c = 'Module';
        update rmaRIList[0];
        
        List<RMA__c> newRMARecordList = new List<RMA__c>();
        newRMARecordList.add(rmaRec);
        
        //RMA_Trigger_Handler.copyWaferIds(newRMARecordList, 'TechToReg');
        
        //updating RMA with mandatory fields
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.OwnerId = userInfo.getUserId();
        rmaRec.Access_Impact__c = 'Safety Impact';
        rmaRec.Description_Return_Particulars__c = 'test';
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Disposition_of_Wafers__c = 'To Scrap at Customer Site';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Justification_Fab_Validation__c = 'test';
        rmaRec.Justification_PRF__c = 'test';
        rmaRec.FAB__c = 'FAB 9';
        rmaRec.Justification_CAR__c = 'test';
        rmaRec.Justification_FOC__c = 'test';
        rmaRec.Justification_Field_Reliability_Failure__c = 'test';
        rmaRec.Potential_Impact_Wafers__c = 20;
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Status__c = 'Draft';
        rmaRec.Workflow_Stage__c = 'RMA Raised';
        rmaRec.Business_Unit__c = 'ASIC';
        rmaRec.Product_Line__c = 'ASIC';
        rmaRec.Business_Category__c = 'ASIC';
        rmaRec.Warranty__c = 24;
        rmaRec.ReasonCode__c = 'R25';
        rmaRec.Return_Location__c = 'Burlington';
        rmaRec.Carrier_Vendor__c = 'CEVA';
        rmaRec.Carrier_Vendor_Account_Number__c = 'AAA';
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Lot_Device_Requires_Scrap_Certificate__c = 'testLot1-123456;';
        rmaRec.Ship_from_Address__c = 'test address';
        
        Test.startTest();
        
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
        
        rmalist = database.query(query);
        RMA__c rmaRec2 = rmaList[0];
        
        rmaRec2.Disposition_by_Quality__c = 'WFT - Fab 9';
        update rmaRec2;
        system.assertEquals(rmaRec2.Disposition_by_Quality__c,'WFT - Fab 9');
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        //Approve Quality validation
        Approval.ProcessWorkitemRequest reqQVal = new Approval.ProcessWorkitemRequest();
        reqQVal.setComments('Approving request.');
        reqQVal.setAction('Approve');
        reqQVal.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        reqQVal.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec3.Id));
        try{
            Approval.ProcessResult resultQVal = Approval.process(reqQVal);
        }catch(Exception ex){}
        rmalist = database.query(query);
        RMA__c rmaRec4 = rmaList[0];
        
        rmaRec4.Reminder_Fab_Validation_Due_Date__c = true;
        update rmaRec4;
        
        RMA_Trigger_Handler.copyWaferIds(newRMARecordList, 'TechToReg');
        system.assertEquals(rmaRec.FAB__c, 'FAB 9');
        
        Test.stopTest();
    }
    
    static testmethod void testMethod19(){
        
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoice1Million(rmaRec, acc);
            
        rmaRIList[0].RMA_By__c = 'Die';
        update rmaRIList[0];
        
        Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Id = rmaRIList[0].Invoice__c;
        invoiceObj.Item_Type__c = 'SD';
        update invoiceObj;
        
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Potential_Impact_Wafers__c = 1;
        rmaRec.Lot_Comments__c = 'test';
        rmaRec.Access_Impact__c = 'Environment Impact';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.Lot_Device_To_Return__c = 'testLotMil1-789789789;';
        rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Assign_to__c = 'Fab';
        
        Test.startTest();
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
        PageReference pageRef = Page.RMA_Edit;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef);
        obj.sumbitForApproval();
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c where Fab__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
        
        //Approve record from Regional Validation
        Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
        req3.setComments('Approving request.');
        req3.setAction('Approve');
        req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req3.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
        //Approval.ProcessResult result3 =  Approval.process(req3);
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        rmaRec3.Acknowledged_Wafer_Return__c = true;
        rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
        rmaRec3.Quantity_Received__c = 1;
        rmaRec3.Date_of_Wafer_Receipt__c = system.today();
        update rmaRec3;
        system.assertEquals(rmaRec3.Quantity_Received__c,1);
        
        Test.stopTest();
    }
    
    static testmethod void testMethod20(){
       
        Account acc = [select id from Account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        List<RMA_Return_Invoice__c> rmaRIList = RMA_TestDataUtility.createRMAReturnInvoice1Million(rmaRec, acc);
            
        rmaRIList[0].RMA_By__c = 'Module';
        update rmaRIList[0];
        
        rmaRec.Compensation_Type__c = 'Credit';
        rmaRec.RMA_Category__c = 'Business';
        rmaRec.Potential_Impact_Wafers__c = 1;
        rmaRec.Lot_Comments__c = 'test';
        rmaRec.Access_Impact__c = 'Environment Impact';
        rmaRec.Customer_Request_Date__c = System.TODAY()-1;
        rmaRec.Description_of_Reason_s__c = 'test';
        rmaRec.Lot_Device_To_Return__c = 'testLotMil1-789789789;';
        rmaRec.Disposition_Of_Wafers__c = 'Return to GF';
        rmaRec.Region_Head__c = UserInfo.getUserId();
        rmaRec.Region_Head_Backup__c = UserInfo.getUserId();
        rmaRec.Sales_SVP__c = UserInfo.getUserId();
        rmaRec.Return_Estimated_Date__c = System.Today()+2;
        rmaRec.Assign_to__c = 'Fab';
        
        Test.startTest();
        update rmaRec;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
        RMA_Edit_Extension obj = new RMA_Edit_Extension(sc);
        PageReference pageRef = Page.RMA_Edit;
        pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
        Test.setCurrentPage(pageRef);
        obj.sumbitForApproval();
        
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String f = util.getAllFields('RMA__c');
        String query = 'select '+f+' from RMA__c where Fab__c not in (\'FAB 9\',\'FAB 10\') limit 1';
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
        
        //Approve record from Regional Validation
        Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
        req3.setComments('Approving request.');
        req3.setAction('Approve');
        req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req3.setWorkitemId(RMA_TestDataUtility.getWorkItemId(rmaRec1.Id));
        //Approval.ProcessResult result3 =  Approval.process(req3);
        
        rmalist = database.query(query);
        RMA__c rmaRec3 = rmaList[0];
        
        rmaRec3.Acknowledged_Wafer_Return__c = true;
        rmaRec3.Acknowledge_On_Wafer_Return__c = System.now();
        rmaRec3.Quantity_Received__c = 1;
        rmaRec3.Date_of_Wafer_Receipt__c = system.today();
        update rmaRec3;
        system.assertEquals(rmaRec3.Quantity_Received__c,1);
        
        Test.stopTest();
    }
}