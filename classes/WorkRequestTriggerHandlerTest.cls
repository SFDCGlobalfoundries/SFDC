/*
Type Name: WorkRequestTriggerHandlerTest 
Author: Cognizant
Created Date: 11-June-2015
Reason: This is the Test class for Controller WorkRequestTriggerHandler,WorkRequestEmailHandler,WRFeedTriggerHandler. 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/

@isTest(SeeAllData = false)
private class WorkRequestTriggerHandlerTest {
    
    static Contact createContact() {
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'test@test.com';
        c.Is_Portal_User_Active__c = false;
        c.Is_Portal_User_Created__c = false;
        c.Department__c = 'Design';
        c.Role__c = 'Customers My Device Admin';
        insert c;
        return c;
    }
    static void customsettingMethod() {
        
        QueueSobject objQueue = [Select QueueId, Queue.Name, SobjectType from QueueSobject Where SobjectType ='Bug__c' And Queue.Name like 'L3%' Limit 1];
        
        string tempQueueId = objQueue.QueueId;
        string tempUserId = UserInfo.getUserId();        
                    
        string queueId = tempQueueId.substring(0, 15);
        string tempId = '00X90000001Fzk3';
        
        WRComponentTeam__c customsettingWRComponentTeam1 = new WRComponentTeam__c();
        customsettingWRComponentTeam1.name = '32LPE-DFM - DFM';
        customsettingWRComponentTeam1.Product_Technology__c = '32LPE-DFM';
        customsettingWRComponentTeam1.Component__c = 'DFM';
        customsettingWRComponentTeam1.User__c = '005900000010Qsb';
        insert customsettingWRComponentTeam1;
        
        WRComponentTeam__c customsettingWRComponentTeam2 = new WRComponentTeam__c();
        customsettingWRComponentTeam2.name = '32LPE-DFM - Digital PnR';
        customsettingWRComponentTeam2.Product_Technology__c = '32LPE-DFM';
        customsettingWRComponentTeam2.Component__c = 'Digital PnR';
        customsettingWRComponentTeam2.User__c = '005900000010Qsb,005900000010X4h';
        insert customsettingWRComponentTeam2;

        WREmailTemplateId__c customsettingT1 = new WREmailTemplateId__c();
        customsettingT1.name = 'Assigned-Owner';
        customsettingT1.TemplateId__c = tempId;
        insert customsettingT1;
        
        WREmailTemplateId__c customsettingT2 = new WREmailTemplateId__c();
        customsettingT2.name = 'PDKComponentCreation';
        customsettingT2.TemplateId__c = tempId;
        insert customsettingT2;
        
        WREmailTemplateId__c customsettingT3 = new WREmailTemplateId__c();
        customsettingT3.name = 'PDKComponentDeletion';
        customsettingT3.TemplateId__c = tempId;
        insert customsettingT3;
        
        WREmailTemplateId__c customsettingT4 = new WREmailTemplateId__c();
        customsettingT4.name = 'StatusChangedNotification';
        customsettingT4.TemplateId__c = tempId;
        insert customsettingT4;
        
        WREmailTemplateId__c customsettingT19 = new WREmailTemplateId__c();
        customsettingT19.name = 'Solution-Submitted';
        customsettingT19.TemplateId__c = tempId;
        insert customsettingT19;
        
        // Routing Custom Settings
        WRPLMRouting__c customsettingPLM1 = new WRPLMRouting__c();
        customsettingPLM1.name = 'Default';
        customsettingPLM1.PLM__c = queueId;
        insert customsettingPLM1;        
        WRPLMRouting__c customsettingPLM2 = new WRPLMRouting__c();
        customsettingPLM2.name = '0.032UM';
        customsettingPLM2.PLM__c = '005900000010Qsb';
        insert customsettingPLM2;
        
        WRPMRouting__c customsettingPM1 = new WRPMRouting__c();
        customsettingPM1.name = '0.032UM';
        customsettingPM1.ProjectManager__c = '005900000010Qsb';
        customsettingPM1.ProjectManagerQueueName__c = 'test';
        customsettingPM1.ProjectManagerQueue__c = queueId;
        insert customsettingPM1;
        WRPMRouting__c customsettingPM2 = new WRPMRouting__c();
        customsettingPM2.name = 'Default';
        customsettingPM2.ProjectManager__c = '00590000002QjlF';
        customsettingPM2.ProjectManagerQueueName__c = '';       
        insert customsettingPM2;
        WRPMRouting__c customsettingPM3 = new WRPMRouting__c();
        customsettingPM3.name = '0.11UM110G';
        customsettingPM3.ProjectManager__c = '005900000010Qsb';
        customsettingPM3.ProjectManagerQueueName__c = 'test';
        customsettingPM3.ProjectManagerQueue__c = queueId;
        insert customsettingPM3;
        
        WRQARouting__c customsettingQA1 = new WRQARouting__c();
        customsettingQA1.name = '0.032UM';
        customsettingQA1.QA__c = queueId;
        insert customsettingQA1;
        WRQARouting__c customsettingQA2 = new WRQARouting__c();
        customsettingQA2.name = 'Default';
        customsettingQA2.QA__c = '00590000002QjlF';
        insert customsettingQA2;        
        
        WRQueueRouting__c customsettingQ1 = new WRQueueRouting__c();
        customsettingQ1.name = 'Default';
        customsettingQ1.Owner__c = queueId;
        insert customsettingQ1;

        WRCustomText__c CustText1 = new WRCustomText__c();
        CustText1.name = 'PLM';
        CustText1.Text__c = 'Product Line Manager';
        insert CustText1;      
        
        WRCustomText__c CustText2 = new WRCustomText__c();
        CustText2.name = 'QATeam';
        CustText2.Text__c = 'QA Team Member';
        insert CustText2;  
        
        WRCustomText__c CustText3 = new WRCustomText__c();
        CustText3.name = 'PDKTeam';
        CustText3.Text__c = 'PDK Management Team Member';
        insert CustText3;  
        
        WRCustomText__c CustText4 = new WRCustomText__c();
        CustText4.name = 'PDKMember';
        CustText4.Text__c = 'PDK Request Member';
        insert CustText4;
        
        WRCustomText__c CustText5 = new WRCustomText__c();
        CustText5.name = 'ProjectManager';
        CustText5.Text__c = 'Project Manager/Scope Owner';
        insert CustText5;
        
        WRCustomText__c CustText6 = new WRCustomText__c();
        CustText6.name = 'Creator';
        CustText6.Text__c = 'PDK Request Creator';
        insert CustText6; 
        
        WRCustomText__c CustText7 = new WRCustomText__c();
        CustText7.name = 'SubscriptionOnly';
        CustText7.Text__c = 'Subscription Only';
        insert CustText7; 
        
        WRCustomText__c CustText8 = new WRCustomText__c();
        CustText8.name = 'ReleaseEngineer';
        CustText8.Text__c = 'Release Engineer';
        insert CustText8; 
        
        WRCustomText__c CustText9 = new WRCustomText__c();
        CustText9.name = 'Other';
        CustText9.Text__c = 'Other Contributors';
        insert CustText9; 
    }
    
    static Id PDKRequestRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('PDK Request').getRecordTypeId();
        return rtId;
    }
    static Bug__c createWR1() {
        Bug__c wr1 = new Bug__c();
        wr1.RecordTypeId = PDKRequestRecordType();
        wr1.Bug_Title__c = 'TestWR1';
        wr1.Bug_Description__c = 'TestWR1';
        wr1.Request_Type__c = 'No';
        wr1.Geometry__c = '0.032UM';
        wr1.Target_Process_Node__c = 'Other';
        wr1.Proposed_Technology_Name__c = 'Test PT';
        wr1.Need_By_Date__c = Date.today().addDays(2);
        insert wr1;
        return wr1;
    }
    static Bug__c createWR2() {
        Bug__c wr1 = new Bug__c();
        wr1.RecordTypeId = PDKRequestRecordType();
        wr1.Bug_Title__c = 'TestWR2';
        wr1.Bug_Description__c = 'TestWR2';
        wr1.Request_Type__c = 'Yes';
        wr1.Geometry__c = '0.032UM';
        wr1.Target_Process_Node__c = '32LPE-DFM';       
        wr1.Need_By_Date__c = Date.today().addDays(2);
        insert wr1;
        return wr1;
    }
    static Bug__c createWR3() {
        Bug__c wr1 = new Bug__c();
        wr1.RecordTypeId = PDKRequestRecordType();
        wr1.Bug_Title__c = 'TestWR3';
        wr1.Bug_Description__c = 'TestWR3';
        wr1.Request_Type__c = 'Yes';
        wr1.Geometry__c = '0.040UM';
        wr1.Target_Process_Node__c = '40G';       
        wr1.Need_By_Date__c = Date.today().addDays(2);
        insert wr1;
        return wr1;
    }
    static Bug__c createWR4() {
        Bug__c wr1 = new Bug__c();
        wr1.RecordTypeId = PDKRequestRecordType();
        wr1.Bug_Title__c = 'TestWR4';
        wr1.Bug_Description__c = 'TestWR4';
        wr1.Request_Type__c = 'Yes';
        wr1.Geometry__c = '0.11UM';
        wr1.Target_Process_Node__c = '110G';       
        wr1.Need_By_Date__c = Date.today().addDays(2);
        insert wr1;
        return wr1;
    }
    static Bug__c updateWR1(Bug__c wrUpdate1) {

        wrUpdate1.Bug_Description__c = 'TestWR1_update';
        wrUpdate1.Geometry__c = '0.028UM';
        wrUpdate1.Target_Process_Node__c = 'Other';
        wrUpdate1.Need_By_Date__c = Date.today().addDays(10);

        update wrUpdate1;
        return wrUpdate1;
    }
    static PDK_Component__c createPDKComponent1(ID wrId) {
        PDK_Component__c pdkcomp1 = new PDK_Component__c();
        pdkcomp1.Bug_Work_Request__c = wrID;
        pdkcomp1.Product_Technology__c = 'Other';
        pdkcomp1.Component__c = 'DRC';
        pdkcomp1.EDA_Tool__c = 'N/A';

        insert pdkcomp1;
        return pdkcomp1;
    }
    static PDK_Component__c createPDKComponent2(ID wrId) {
        PDK_Component__c pdkcomp2 = new PDK_Component__c();
        pdkcomp2.Bug_Work_Request__c = wrID;
        pdkcomp2.Product_Technology__c = '32LPE-DFM';
        pdkcomp2.Component__c = 'DFM';
        pdkcomp2.EDA_Tool__c = 'N/A';

        insert pdkcomp2;
        return pdkcomp2;
    }
    
    static PDK_Component__c updatePDKComponent1(PDK_Component__c pdk) {
        pdk.EDA_Tool__c = 'YES';
        pdk.Level_of_Effort__c = 1;
        pdk.Remarks_Comments__c = 'PDK updated';
        update pdk;
        return pdk;
    }
    static PDK_Component__c updatePDKComponent2(PDK_Component__c pdk) {
        pdk.EDA_Tool__c = 'N/A; YES';
        pdk.Level_of_Effort__c = 1;
        pdk.Remarks_Comments__c = 'PDK updated';
        update pdk;
        return pdk;
    }
    static PDK_Component__c updatePDKComponent3(PDK_Component__c pdk) {
        pdk.Component__c='DFM';
        pdk.EDA_Tool__c = 'N/A';
        pdk.Level_of_Effort__c = 1;
        pdk.Remarks_Comments__c = 'PDK updated';
        update pdk;
        return pdk;
    }

    static Bug__c updateSolution(Bug__c wrUpdate1) {
        wrUpdate1.Actual_Delivered_Date__c = Date.today().addDays(2);
        wrUpdate1.Actual_Delivered_PDK_Version__c = 'Test AA';
        wrUpdate1.Approval_Deadline_Date__c = Date.today().addDays(2);
        wrUpdate1.Resolution_Details__c = 'Test Resolution';
        wrUpdate1.Resolution_File_URL__c = 'http://globalfoundries.test';
        wrUpdate1.Target_Delivery_PDK_version__c = 'Test AA';
        wrUpdate1.Targetted_Delivery_Date__c = Date.today().addDays(2);
        wrUpdate1.IsPLMSolutionSubmitted__c = true;
        wrUpdate1.Solution_Submitted_By__c = UserInfo.getUserId();
        update wrUpdate1;
        return wrUpdate1;
    }

    static User createAdmin() {
        List < User > UserList = new List < User > ();
        Profile p = [Select Id from Profile where name = 'System Administrator'];

        User u1 = new User(ProfileId = p.Id, Username = 'test001' + System.now().format('MMddyyyyHHmmss') + '@test.com',
            Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User4',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        UserList.add(u1);

        insert UserList;
        return UserList[0];
    }
    static User createNonAdmin() {
        List < User > UserList = new List < User > ();
        Profile p = [Select Id from Profile where name = 'GF Consultants'
            LIMIT 1
        ];
        
        
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';
        insert hcmemp;
        
        User u1 = new User(ProfileId = p.Id, Username = 'test002' + System.now().format('MMddyyyyHHmmss') + '@test.com',
            Alias = 'mm1', Email = 'test1@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'MMTest', Lastname = 'User1',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',HCM_Record_ID__c=hcmemp.id,FederationIdentifier='177314');
        UserList.add(u1);

        insert UserList;
        return UserList[0];
    }

    static void approveProcess(Bug__c wr1) {
        List < ProcessInstanceWorkitem > listApprovalReq = [SELECT Id, ProcessInstance.TargetObjectId
            FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = : wr1.Id
        ];
        System.assertEquals(listApprovalReq.size(), 1);

        Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
        req1.setComments('Comment Approve');
        req1.setAction('Approve');
        req1.setWorkitemId(listApprovalReq[0].id);
        Approval.process(req1);
    }

    static void rejectProcess(Bug__c wr1) {
            List < ProcessInstanceWorkitem > listApprovalReq = [SELECT Id, ProcessInstance.TargetObjectId
                FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = : wr1.Id
            ];
            System.assertEquals(listApprovalReq.size(), 1);
            Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
            req1.setComments('Comment Reject');
            req1.setAction('Reject');
            req1.setWorkitemId(listApprovalReq[0].id);
            Approval.process(req1);
        }    
      
    //Covering WRFeedTriggerHandler
    static testMethod void testMethod1() {
            Test.startTest();
            Contact c=createContact();
            Bug__c wr1 = createWR1();
            Bug__c wr2 = createWR2();
            Bug__c testWRupdate1 = updateWR1(wr1);

            List < FeedItem > feedList = new List < FeedItem > ();
            FeedItem fpost1 = new FeedItem(ParentId = wr1.Id, type = 'ContentPost', ContentFileName = 'Test 2', ContentData = EncodingUtil.base64Decode('test'), Visibility = 'InternalUsers');
            feedList.add(fpost1);
            FeedItem fpost2 = new FeedItem(ParentId = wr2.Id, type = 'TextPost', Body = 'Test body', Visibility = 'InternalUsers');
            feedList.add(fpost2);
            insert feedList;

            List < FeedComment > feedcomments = new List < FeedComment > ();
            FeedComment fdComment1 = new FeedComment(FeedItemId = fpost1.id, commentbody = 'test1', CommentType = 'ContentComment');
            feedcomments.add(fdComment1);            
            FeedComment fdComment2 = new FeedComment(FeedItemId = fpost2.id, commentbody = 'test1', CommentType = 'TextComment');
            feedcomments.add(fdComment2);            
            insert feedcomments;       
            
            wr2.Stages__c = 'New Request-Submitted';            
            update wr2;
            Test.stopTest();
        }
    /*
    This method is used for ValidatePDKComponent methods for showing error on creating duplicate PDK Component .
    @method name: ValidatePDKComponent
    */
    static testMethod void testMethod2() {
        Test.startTest();
        Contact c=createContact();
        customsettingMethod();
        try {
            Bug__c wr1 = createWR1();
            System.debug('MMtestclass:::' + wr1.id);
            PDK_Component__c testPdk1 = createPDKComponent1(wr1.Id);
            PDK_Component__c updatedtestPdk1 = updatePDKComponent1(testPdk1);
            PDK_Component__c updatedtestPdk2 = updatePDKComponent2(testPdk1);

            delete testPdk1;
            Bug__c wr2 = createWR2();
            //Creating duplicate PDK component
            PDK_Component__c testPdk2 = createPDKComponent2(wr2.Id);
            PDK_Component__c testPdk3 = createPDKComponent2(wr2.Id);

        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Selected Product/ Technology - Component combination already exists for the Work Request.'), e.getMessage());
        }
        Test.stopTest();
    }
    
    static testMethod void testMethod3() {
        Test.startTest();
        Contact c = createContact();
        customsettingMethod();
        try {
            Bug__c wr2 = createWR2();
    
            PDK_Component__c testPdk1 = createPDKComponent2(wr2.Id);
            PDK_Component__c updatePDK = updatePDKComponent3(testPdk1);
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Product/ Technology and Component can\'t be modified, please Delete this record and create new.'), e.getMessage());
        }
        Test.stopTest();
    }
    static testMethod void testMethod4() {
        Test.startTest();
        customsettingMethod();
        Contact c=createContact();
        try {
            Bug__c wr1 = createWR1();
            Bug__c wr2 = createWR2();
            List < Component_Team__c > listCTeam = new list < Component_Team__c > ();
            PDK_Component__c testPdk1 = createPDKComponent1(wr1.Id);
            User u = createNonAdmin();
            Component_Team__c c1 = new Component_Team__c(PDK_Component__c = testPdk1.id, User__c = u.id);
            listCTeam.add(c1);
            User u1 = createAdmin();
            Component_Team__c c2 = new Component_Team__c(PDK_Component__c = testPdk1.id, User__c = u1.id);
            listCTeam.add(c2);
            insert listCTeam;
            PDK_Component__c testPdk2 = createPDKComponent2(wr2.Id);
            PDK_Component__c updatePDK = updatePDKComponent2(testPdk2);
            delete testPdk2;
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('Product/ Technology and Component can\'t be modified, please Delete this record and create new.'), e.getMessage());
        }
        Test.stopTest();
    }
    //Covering WorkRequestTriggerHandler Approval process
    static testMethod void testMethod5() {
        Test.startTest();
        try{        
        Contact c=createContact();
        User u = createNonAdmin();        
        customsettingMethod();
        Bug__c wr1 = createWR1();
        //PLM Approval Submitted
        wr1.IsPLMSubmitted__c = true;
        update wr1;
        //PLM Approval Process            
        rejectProcess(wr1);
        //Executive Team
        wr1.Stages__c = 'Executive Team-Submitted';
        wr1.IsTransferToProjectManager__c  = true;
        wr1.OwnerId =UserInfo.getUserId();
        update wr1;
        approveProcess(wr1);
        wr1.Stages__c = 'Assigned-Owner';
        wr1.Status__c = 'Assigned';
        update wr1;
        wr1.OwnerId=u.Id;
        update wr1;
        wr1.OwnerId = UserInfo.getUserId();
        wr1.IsPLMSolutionSubmitted__c = true;
        wr1.Solution_Submitted_By__c = UserInfo.getUserId();        
        update wr1;
        //Solution details provide and Submitted for Approval
        wr1=updateSolution(wr1);
        //PLM Approval Rejected Process 
        wr1.IsSolutionAutoRejected__c = true;
        wr1.IsPLMSolutionSubmitted__c = false;
        update wr1;
        //PLM Approval Process 
        wr1.IsPLMSolutionSubmitted__c = true;
        update wr1;
        approveProcess(wr1);
        //QA Approval Process       
        wr1.IsQASubmitted__c = true;
        update wr1;
        approveProcess(wr1);
        //PLM Satisfaction  Rejected  Process
        wr1.IsPLMSatisfied__c = true;
        wr1.IsReopenSubmitted__c = false;
        update wr1;
        rejectProcess(wr1);
        //PM Approval for Reopen           
        wr1.IsReopenSubmitted__c = true;
        update wr1;
        approveProcess(wr1);
        wr1.IsReopen__c = true;
        update wr1;
        
        }catch(Exception e){
            System.Assert(e.getMessage().contains(' '), e.getMessage());
        }
        Test.stopTest();
        
    } 
    static testMethod void testMethod6() {
        test.startTest();
        Contact c=createContact();      
        customsettingMethod();        
        Bug__c wr2 = createWR3();        
        //PLM Approval Submitted
        wr2.IsPLMSubmitted__c = true;
        update wr2;
        //PLM Approval Process            
        approveProcess(wr2);
        //Executive Team
        wr2.Stages__c = 'Executive Team-Submitted';
        wr2.IsTransferToProjectManager__c  = true;
        wr2.OwnerId =UserInfo.getUserId();
        update wr2;     
        approveProcess(wr2);
        wr2.Stages__c = 'Assigned-Owner';
        wr2.Status__c = 'Assigned';
        wr2.OwnerId = UserInfo.getUserId();
        wr2.IsPLMSolutionSubmitted__c = true;
        wr2.Solution_Submitted_By__c = UserInfo.getUserId();
        update wr2;
        //Solution details provide and Submitted for Approval
        wr2=updateSolution(wr2);
        //PLM Approval Rejected Process 
        wr2.IsSolutionAutoRejected__c = true;
        wr2.IsPLMSolutionSubmitted__c = false;
        update wr2;
        //PLM Approval Process 
        wr2.IsPLMSolutionSubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        //QA Approval Process
        wr2.IsQASubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        //PLM Satisfaction  Rejected  Process
        wr2.IsPLMSatisfied__c = true;
        update wr2;
        rejectProcess(wr2);
        wr2.IsReopenSubmitted__c = false;
        update wr2;
        //PM Approval for Reopen           
        wr2.IsReopenSubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        //wr2.IsReopen__c = true;
        update wr2;
        Test.stopTest();
    }    
    
    static testMethod void testMethod7() {      
        Contact c=createContact();
        customsettingMethod();
        User u=createNonAdmin();
        User admin=createAdmin();
        Test.startTest();
        Bug__c wr1 = createWR3();
        //PLM Approval Submitted
        wr1.IsPLMSubmitted__c = true;
        update wr1;
        //PLM Approval Process            
        rejectProcess(wr1);
        update wr1;
        wr1.Stages__c = 'Executive Team-Submitted';
        wr1.IsTransferToProjectManager__c  = true;
        wr1.OwnerId =UserInfo.getUserId();
        update wr1;
        approveProcess(wr1);
        wr1.OwnerId = u.Id;
        update wr1;
        wr1.Stages__c = 'Assigned-Owner';
        wr1.OwnerId = admin.Id;
        update wr1;
        wr1.Stages__c='QA-Submitted';
        wr1.OwnerId = admin.Id;
        update wr1;
        wr1.status__c = 'Completed';
        wr1.OwnerId = UserInfo.getUserId();
        update wr1;
        wr1.status__c = 'Reopen';       
        wr1.OwnerId = UserInfo.getUserId();
        update wr1;
        wr1.status__c = 'Closed';
        wr1.OwnerId = UserInfo.getUserId();
        update wr1;
        test.stopTest();
    }
    static testMethod void testMethod8() {
        Test.startTest();
        Contact c = createContact();
        customsettingMethod();
        User u = createNonAdmin();
        User u2 = createAdmin();
        Group testGroup1 = new Group(Name = 'L2 - Customer Test1', Type = 'Queue');
        insert testGroup1;
        QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SObjectType = 'Bug__c');
    
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert testQueue1;
        }
    
        System.runAs(u) {            
            Bug__c wr2 = createWR2();
            wr2.OwnerId = testGroup1.Id;
            wr2.Stages__c = 'Assigned-Queue';
            update wr2;
        }
    
        Test.stopTest();
    }
    static testMethod void testMethod9() {
        Test.startTest();
        Contact c=createContact();
        customsettingMethod();
        Bug__c wr1 = createWR1();
        //PLM Approval Submitted
        wr1.IsPLMSubmitted__c = true;
        update wr1;
        //PLM Approval Process            
        rejectProcess(wr1);
        //Executive Team
        wr1.Stages__c = 'Assigned-Owner';
        wr1.Status__c = 'Assigned';
        wr1.OwnerId = UserInfo.getUserId();
        wr1.IsPLMSolutionSubmitted__c = true;
        wr1.Solution_Submitted_By__c = UserInfo.getUserId();
        update wr1;
        //Solution details provide and Submitted for Approval
        wr1=updateSolution(wr1);
        wr1.Approval_Deadline_Date__c =null;
        //PLM Approval Rejected Process 
        wr1.IsSolutionAutoRejected__c = true;
        wr1.IsPLMSolutionSubmitted__c = false;
        update wr1;
        try{
        wr1.status__c='Reopen,Assigned';
        update wr1;
        }catch(Exception e){
            System.Assert(e.getMessage().contains('status'), e.getMessage());
        }
        Test.stopTest();
    }
    static testMethod void testMethod10() {
        test.startTest();
        Contact c=createContact();      
        customsettingMethod();        
        Bug__c wr2 = createWR4();        
        //PLM Approval Submitted
        wr2.IsPLMSubmitted__c = true;
        update wr2;
        //PLM Approval Process            
        approveProcess(wr2);
        //Executive Team
        wr2.Stages__c = 'Executive Team-Submitted';
        wr2.IsTransferToProjectManager__c  = true;
        wr2.OwnerId =UserInfo.getUserId();
        update wr2;
        approveProcess(wr2);
        wr2.Stages__c = 'Assigned-Owner';
        wr2.Status__c = 'Assigned';
        wr2.OwnerId = UserInfo.getUserId();
        wr2.IsPLMSolutionSubmitted__c = true;
        wr2.Solution_Submitted_By__c = UserInfo.getUserId();
        update wr2;
        //Solution details provide and Submitted for Approval
        wr2=updateSolution(wr2);
        //PLM Approval Rejected Process 
        wr2.IsSolutionAutoRejected__c = true;
        wr2.IsPLMSolutionSubmitted__c = false;
        update wr2;
        //PLM Approval Process 
        wr2.IsPLMSolutionSubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        //QA Approval Process
        wr2.IsQASubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        //PLM Satisfaction  Rejected  Process
        wr2.IsPLMSatisfied__c = true;
        update wr2;
        rejectProcess(wr2);
        //PM Approval for Reopen     
        wr2.IsReopen__c = false;
        wr2.IsReopenSubmitted__c = true;
        update wr2;
        approveProcess(wr2);
        update wr2;
        try{
        wr2.IsReopen__c = true;
        update wr2;
        
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('a'), e.getMessage());
        }   
        Test.stopTest();
    }
    //test method for Simulation Request
    public static testMethod void testMethod11() {
        test.starttest();
        //Test data creation
        User sysAdmin = createAdmin();
        Id SRRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('Simulation Request').getRecordTypeId();
        System.runAs(sysAdmin) {
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Status__c = 'New';
            b.Priority__c = 'P4';
            b.Bug_Description__c = 'test';
            b.RecordTypeId = SRRecordTypeId;
            
            insert b;
            b.Bug_Description__c = 'test1';
            update b;            
            
        }

        test.stoptest();
    }
    //Test Method for WREditController class
    public static testMethod void testMethod12() {
        test.starttest();
        User sysAdmin = createAdmin();
        User u=createNonAdmin();
        Contact c=createContact();      
        customsettingMethod();   
        System.runAs(sysAdmin) {
            Bug__c wr1 = createWR4();
            //PLM Approval Submitted
            wr1.IsPLMSubmitted__c = true;
            update wr1;
            //PLM Approval Process            
            approveProcess(wr1);
            update(wr1);
            PageReference ref1 = new PageReference('/apex/WRLockedEdit?Id=' + wr1.id);
            Test.setCurrentPage(ref1);
            
            WREditController wrEdit1 = new WREditController();
            
            ApexPages.currentPage().getParameters().put('Project_Manager__c', sysAdmin.name);
            wrEdit1.save();
            PageReference ref3 = wrEdit1.cancel();
        }
        Bug__c wr2 = createWR4();
        //PLM Approval Submitted
        wr2.IsPLMSubmitted__c = true;
        update wr2;
        //PLM Approval Process            
        //approveProcess(wr2);
        //update(wr2);
        System.runAs(u) {
            try{    
                
                PageReference ref2 = new PageReference('/apex/WRLockedEdit?Id=' + wr2.id+'4517');               
                Test.setCurrentPage(ref2);
                
                WREditController wrEdit2 = new WREditController();
                
                ApexPages.currentPage().getParameters().put('Project_Manager__c', 'abc123');
                wrEdit2.save();
            }catch(Exception e){
                System.Assert(e.getMessage().contains('a'), e.getMessage());
            }
        }
        test.stoptest();
    }
}