@isTest(SEEALLDATA = false)
private class RMA_GenericEmailNotifier_Test {
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccountForFab9();
         RMA__c rmaRec = RMA_TestDataUtility.createRMAForFab9(1, acc); 
    }
    
    static testmethod void testMethod1(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
         
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_EmailNotification__c email1 = RMA_TestDataUtility.createEmailNotification('SN002','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team',NULL,FALSE);
            RMA_EmailNotification__c email3 = RMA_TestDataUtility.createEmailNotification('SN003','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team;NU:Return Wafer',NULL,TRUE);
            RMA_EmailNotification__c email4 = RMA_TestDataUtility.createEmailNotification('SN119',NULL,NULL,'FI:Originator_Email__c;NU:Return Wafer',NULL,'FAB 9,FAB 10',
                                                    'Pending for Fab Validation','Pending for Fab Validation','RMA_Due_for_Validation',
                                                    'FI:Originator_Email__c;NU:Return Wafer',0,TRUE); 
            //updating RMA with mandatory fields
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
            
            
        Test.stopTest();            
        
    }
    
    static testmethod void testMethod2(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_EmailNotification__c email1 = RMA_TestDataUtility.createEmailNotification('SN002','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team',NULL,FALSE);
            RMA_EmailNotification__c email3 = RMA_TestDataUtility.createEmailNotification('SN003','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team;NU:Return Wafer',NULL,TRUE);
            RMA_EmailNotification__c email2 = RMA_TestDataUtility.createEmailNotification('SN118',NULL,NULL,'FI:Originator_Email__c;NU:Return Wafer',NULL,'FAB 9,FAB 10',
                                                    'Pending for Fab Validation','Pending for Fab Validation','RMA_Due_for_Validation',
                                                    'FI:Originator_Email__c;NU:Return Wafer',0,FALSE); 
            //updating RMA with mandatory fields
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
            
            
        Test.stopTest();            
        
    }
    
     static testmethod void testMethod3(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
    
        Test.startTest();
            Map<string,RMA__c> mapStageRemVsRMA=new Map<string,RMA__c>();
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_EmailNotification__c email1 = RMA_TestDataUtility.createEmailNotification('SN002','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team',1,False);
            RMA_EmailNotification__c email3 = RMA_TestDataUtility.createEmailNotification('SN003','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team;NU:Return Wafer',0,False);
            RMA_EmailNotification__c email2 = RMA_TestDataUtility.createEmailNotification('SN118',NULL,NULL,'FI:Originator_Email__c;NU:Return Wafer',NULL,'FAB 9,FAB 10',
                                                    'Pending for Fab Validation','Pending for Fab Validation','RMA_Due_for_Validation',
                                                    'FI:Originator_Email__c;NU:Return Wafer',3,True); 
            //updating RMA with mandatory fields
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
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'Pending for Fab Validation';//'RMA Raised';
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
            rmaRec.Reminder_Quality_Approval_Due_Date__c=true;
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
            rmaRec2.Reminder_Quality_Approval_3_Days__c=true;
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
            rmaRec4.Reminder_Quality_Approval_3_Days__c=true;
            update rmaRec4;
            
            
        Test.stopTest();            
        
    }
    
    static testmethod void testMethod4(){
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
    
        Test.startTest();
            Map<string,RMA__c> mapStageRemVsRMA=new Map<string,RMA__c>();
            RMA_TestDataUtility.createRMAReturnInvoiceForFab9(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesForFab9(1,acc);
            RMA_EmailNotification__c email1 = RMA_TestDataUtility.createEmailNotification('SN002','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team',1,True);
            RMA_EmailNotification__c email3 = RMA_TestDataUtility.createEmailNotification('SN003','Environment Impact,Quality / Reliability Impact,Safety Impact,N/A','ASIC',
                                                    'FI:Originator_Email__c;NU:Return Wafer',
                                                    'Return to GF,Return to GF and to Scrap at Customer Site,To Scrap at Customer Site,','FAB 9,FAB 10','RMA Raised',
                                                    'Pending for Quality Validation','RMA_Pending_for_Quality_Validation','RMA_ASIC_Quality_Team;NU:Return Wafer',0,True);
            RMA_EmailNotification__c email2 = RMA_TestDataUtility.createEmailNotification('SN118',NULL,NULL,'FI:Originator_Email__c;NU:Return Wafer',NULL,'FAB 9,FAB 10',
                                                    'Pending for Fab Validation','Pending for Fab Validation','RMA_Due_for_Validation',
                                                    'FI:Originator_Email__c;NU:Return Wafer',3,True); 
            //updating RMA with mandatory fields
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
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.Status__c = 'Draft';
            rmaRec.Workflow_Stage__c = 'Pending for Fab Validation';//'RMA Raised';
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
            rmaRec.Reminder_Quality_Approval_Due_Date__c=true;
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
            rmaRec2.Reminder_Quality_Approval_3_Days__c=true;
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
            rmaRec4.Reminder_Quality_Approval_3_Days__c=true;
            update rmaRec4;
            
            
        Test.stopTest();            
        
    }
    
    
}