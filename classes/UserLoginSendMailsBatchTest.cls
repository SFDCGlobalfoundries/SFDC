@isTest
public class UserLoginSendMailsBatchTest {
    @testSetup static void methodName() 
    {
        List<EmailTemplate> lstTemp = new List<EmailTemplate>();
        EmailTemplate tt = new EmailTemplate();
        tt.DeveloperName = 'PortalDeactivationToAMCSRFAE';
        tt.Name = 'PortalDeactivationToAMCSRFAE';
        tt.Body = 'testing body';
        tt.HtmlValue = 'test1';
        tt.Subject = 'test Subject';
        tt.TemplateType = 'text';
        tt.FolderId = UserInfo.getUserId();
        lstTemp.add(tt);
        EmailTemplate tt2 = new EmailTemplate();
        tt2.DeveloperName = 'PortalDeactivationToAMCSRFAE2';
        tt2.Name = 'PortalDeactivationToAMCSRFAE2';
        tt2.Body = 'testing body';
        tt2.HtmlValue = 'test1';
        tt2.Subject = 'test Subject';
        tt2.TemplateType = 'text';
        tt2.FolderId = UserInfo.getUserId();
        lstTemp.add(tt2);
        EmailTemplate tt3 = new EmailTemplate();
        tt3.DeveloperName = 'PortalDeactivationToAMCSRFAE3';
        tt3.Name = 'PortalDeactivationToAMCSRFAE3';
        tt3.Body = 'testing body';
        tt3.HtmlValue = 'test1';
        tt3.Subject = 'test Subject';
        tt3.TemplateType = 'text';
        tt3.FolderId = UserInfo.getUserId();
        lstTemp.add(tt3);
        EmailTemplate tt4 = new EmailTemplate();
        tt4.DeveloperName = 'PortalDeactivationToAMCSRFAE4';
        tt4.Name = 'PortalDeactivationToAMCSRFAE4';
        tt4.Body = 'testing body';
        tt4.HtmlValue = 'test1';
        tt4.Subject = 'test Subject';
        tt4.TemplateType = 'text';
        tt4.FolderId = UserInfo.getUserId();
        lstTemp.add(tt4);
        
        EmailTemplate t = new EmailTemplate();
        t.DeveloperName = 'User_Notification_For_Batch';
        t.Name = 'User Notification For Batch';
        t.Body = 'testing body';
        t.HtmlValue = 'test1';
        t.Subject = 'test Subject';
        t.TemplateType = 'text';
        t.FolderId = UserInfo.getUserId();
        lstTemp.add(t);
        EmailTemplate t1 = new EmailTemplate();
        t1.DeveloperName = 'User_Notification_2For_Batch';
        t1.Name = 'User Notification For Batch';
        t1.Body = 'testing body2';
        t1.Subject = 'test Subject2';
        t1.HtmlValue = 'test2';
        t1.TemplateType = 'text';
        t1.FolderId = UserInfo.getUserId();
        lstTemp.add(t1);
        EmailTemplate t2 = new EmailTemplate();
        t2.DeveloperName = 'User_Notification_3For_Batch';
        t2.Name = 'User Notification For Batch';
        t2.Body = 'testing body3';
        t2.Subject = 'test Subject3';
        t2.HtmlValue = 'test3';
        t2.TemplateType = 'text';
        t2.FolderId = UserInfo.getUserId();
        lstTemp.add(t2);
        EmailTemplate t3 = new EmailTemplate();
        t3.DeveloperName = 'User_Notification_4For_Batch';
        t3.Name = 'User Notification For Batch';
        t3.Body = 'testing body4';
        t3.Subject = 'test Subject4';
        t3.HtmlValue = 'test4';
        t3.TemplateType = 'text';
        t3.FolderId = UserInfo.getUserId();
        lstTemp.add(t3);
        insert lstTemp;
        
    }
    public static testMethod void UserActivateTest2(){
        
        List<Error_Codes__c> lstcodes = new List<Error_Codes__c>();
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        lstcodes.add(e);
        Error_Codes__c e1 = new Error_Codes__c();
        e1.Name = 'ACCT_TM_DUP_USER_ROLE_ERROR';
        e1.Message__c = 'Test';
        lstcodes.add(e1);
        Error_Codes__c e2 = new Error_Codes__c();
        e2.Name = 'ATP_INTEGRATION_SEQUENCE_ERROR';
        e2.Message__c = 'Test';
        lstcodes.add(e2);
        Error_Codes__c e3 = new Error_Codes__c();
        e3.Name = 'ATP_FLAG_FOR_DELETE_UPDATE_ERROR';
        e3.Message__c = 'Test';
        lstcodes.add(e3);
        Error_Codes__c e4 = new Error_Codes__c();
        e4.Name = 'ATP_FLAG_FOR_DELETE_CREATION_ERROR';
        e4.Message__c = 'Test';
        lstcodes.add(e4);
        insert lstcodes;
        List<Environment_Variable__c> lstenv = new List<Environment_Variable__c>();
        Environment_Variable__c l = new Environment_Variable__c();
        l.Name = 'DEVICE_STATUS_ACTIVE';
        l.Value__c = 'Test';
        lstenv.add(l);
        Environment_Variable__c l1 = new Environment_Variable__c();
        l1.Name = 'ACT_TM_PRXY_TM_RL_CE';
        l1.Value__c = 'Test';
        lstenv.add(l1);
        Environment_Variable__c l2 = new Environment_Variable__c();
        l2.Name = 'ACCT_TM_PRXY_TM_RL_FP';
        l2.Value__c = 'Test';
        lstenv.add(l2);
        Environment_Variable__c l3 = new Environment_Variable__c();
        l3.Name = 'ACCT_TM_PRXY_TM_RL_AM';
        l3.Value__c = 'Test';
        lstenv.add(l3);
        Environment_Variable__c l4 = new Environment_Variable__c();
        l4.Name = 'ACCT_TM_PRXY_TM_RL_TS';
        l4.Value__c = 'Test';
        lstenv.add(l4);
        Environment_Variable__c l5 = new Environment_Variable__c();
        l5.Name = 'ACCT_TM_PRXY_TM_RL_AE';
        l5.Value__c = 'Test';
        lstenv.add(l5);
        Environment_Variable__c l6 = new Environment_Variable__c();
        l6.Name = 'ACCT_TM_PRXY_TM_RL_CSR';
        l6.Value__c = 'Test';
        lstenv.add(l6);
        Environment_Variable__c l7 = new Environment_Variable__c();
        l7.Name = 'GF_INTEGRATION_PROFILE_ID';
        l7.Value__c = 'Test';
        lstenv.add(l7);
        Environment_Variable__c l0 = new Environment_Variable__c();
        l0.Name = 'ACCT_TM_PRXY_TM_RL_PCSR';
        l0.Value__c = 'Test';
        lstenv.add(l0);
        Environment_Variable__c l8 = new Environment_Variable__c();
        l8.Name = 'ACCT_TM_PRXY_TM_RL_PAM';
        l8.Value__c = 'Test';
        lstenv.add(l8);
        Environment_Variable__c l9 = new Environment_Variable__c();
        l9.Name = 'ACCT_TM_PRXY_TM_RL_AA';
        l9.Value__c = 'Test';
        lstenv.add(l9);
        Environment_Variable__c lv = new Environment_Variable__c();
        lv.Name = 'ACCT_TM_PRXY_TM_RL_PFTS';
        lv.Value__c = 'Test';
        lstenv.add(lv);
        Environment_Variable__c l11 = new Environment_Variable__c();
        l11.Name = 'ACCT_TM_PRXY_TM_RL_PFAE';
        l11.Value__c = 'Test';
        lstenv.add(l11);
        insert lstenv;

        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;
        
        List<UserPortalDeactivation__c> custSetList = new List<UserPortalDeactivation__c>();
        UserPortalDeactivation__c custSet1 = new UserPortalDeactivation__c();
        custSet1.Name = 'SendEmailNotification';
        custSet1.Months__c = 6;
        custSet1.Days__c = 0;
        custSetList.add(custSet1);
        UserPortalDeactivation__c custSet2 = new UserPortalDeactivation__c();
        custSet2.Name = 'SendEmailNotification2';
        custSet2.Months__c = 6;
        custSet2.Days__c = 0;
        custSetList.add(custSet2);
        UserPortalDeactivation__c custSet3 = new UserPortalDeactivation__c();
        custSet3.Name = 'SendEmailNotification3';
        custSet3.Months__c = 6;
        custSet3.Days__c = 0;
        custSetList.add(custSet3);
        UserPortalDeactivation__c custSet4 = new UserPortalDeactivation__c();
        custSet4.Name = 'SendEmailNotification4';
        custSet4.Months__c = 6;
        custSet4.Days__c = 0;
        custSetList.add(custSet4);
        insert custSetList;
        Map<String,Object> fieldValueMap = New Map<String,Object>();        
        fieldValueMap.put('name','TEST rec1205');
        fieldValueMap.put('Stage__c','Active');
        fieldValueMap.put('Short_Name__c','TESTrec12051');
        fieldValueMap.put('Site_Department__c','test dept1205');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','transactional');   
        fieldValueMap.put('Process_Tech_Interested__c',' MEM');
        fieldValueMap.put('Region__c','JK');        
        fieldValueMap.put('Copy_Address__c',true);
        fieldValueMap.put('Corporate_Address_1__c','50 water st');
        fieldValueMap.put('Corporate_Country__c','USA'); 
        fieldValueMap.put('Corporate_City__c','Bangalore');
        fieldValueMap.put('Corporate_State__c','AB');
        fieldValueMap.put('bill_to_location__c','yes');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap.put('End_Customer__c','people');       
        fieldValueMap.put('Total_Employee__c',100);  
        fieldValueMap.put('Revenue_Potential__c','High Potential'); 
        fieldValueMap.put('Target_Account__c','Yes');
        fieldValueMap.put('Unauthorized__c',false);      
        Account acc1 = AccountDataFactory.createAccount(fieldValueMap);
        Profile pp = [Select Id from Profile where Name='System Administrator'];
        User testUser = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = pp.Id, country='United States',IsActive =true,
                                 timezonesidkey='America/Los_Angeles', username='testercedev2@noemail.com');
        insert testUser;
        test.startTest();
        system.runAs(testUser){
            Account_Team_Proxy__c am = new Account_Team_Proxy__c();
            am.Account__c = acc1.Id;
            am.User__c = userInfo.getUserId();
            am.Team_Role__c = 'Primary Account Manager';
            am.Account_Access__c = 'Read Only';
            am.Opportunity_Access__c = 'Read Only';
            insert am;
        }
        test.stopTest();
        Contact con1 = new Contact(
            LastName = 'test1',
            FirstName = 'testing1',
            AccountId = acc1.Id,
            Email = 'test1@test.com',
            Department__c = 'Design'
        );
        insert con1;
        
        PageReference ref = Page.Portal_Deactivation_pdf;
        Test.setCurrentPage(ref);
        ref.getParameters().put('Ids',con1.Id+';');
        Portal_Deactivation_pdf_Controller pdf = new Portal_Deactivation_pdf_Controller();
        
        
        Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
        User portalAccountOwner1 = new User(ProfileId = profile1.Id );            
        portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
        portalAccountOwner1.Alias = 'batman';
        portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
        portalAccountOwner1.EmailEncodingKey='UTF-8';
        portalAccountOwner1.Firstname='Bruce';
        portalAccountOwner1.Lastname='Wayne';
        portalAccountOwner1.LanguageLocaleKey='en_US';
        portalAccountOwner1.LocaleSidKey='en_US';
        portalAccountOwner1.TimeZoneSidKey='America/Chicago';
        portalAccountOwner1.ContactId = con1.Id;
        portalAccountOwner1.IsActive = true;
        //portalAccountOwner1.Contact.Deactivation_Notification_Date__c = system.today();
        system.runas(testUser){
            Database.insert(portalAccountOwner1);
        }
        UserLoginSendMailsBatch sh1 = new UserLoginSendMailsBatch();      
        String sch = '0 0 23 * * ?';
        Database.Executebatch(sh1);
        system.schedule('Test1', sch, sh1);
        
        List<User> objectList = new List<User>(); 
        
    }
    public static testMethod void UserActivateTest(){
        
        List<Error_Codes__c> lstcodes = new List<Error_Codes__c>();
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        lstcodes.add(e);
        Error_Codes__c e1 = new Error_Codes__c();
        e1.Name = 'ACCT_TM_DUP_USER_ROLE_ERROR';
        e1.Message__c = 'Test';
        lstcodes.add(e1);
        Error_Codes__c e2 = new Error_Codes__c();
        e2.Name = 'ATP_INTEGRATION_SEQUENCE_ERROR';
        e2.Message__c = 'Test';
        lstcodes.add(e2);
        Error_Codes__c e3 = new Error_Codes__c();
        e3.Name = 'ATP_FLAG_FOR_DELETE_UPDATE_ERROR';
        e3.Message__c = 'Test';
        lstcodes.add(e3);
        Error_Codes__c e4 = new Error_Codes__c();
        e4.Name = 'ATP_FLAG_FOR_DELETE_CREATION_ERROR';
        e4.Message__c = 'Test';
        lstcodes.add(e4);
        insert lstcodes;
        List<Environment_Variable__c> lstenv = new List<Environment_Variable__c>();
        Environment_Variable__c l = new Environment_Variable__c();
        l.Name = 'DEVICE_STATUS_ACTIVE';
        l.Value__c = 'Test';
        lstenv.add(l);
        Environment_Variable__c l1 = new Environment_Variable__c();
        l1.Name = 'ACT_TM_PRXY_TM_RL_CE';
        l1.Value__c = 'Test';
        lstenv.add(l1);
        Environment_Variable__c l2 = new Environment_Variable__c();
        l2.Name = 'ACCT_TM_PRXY_TM_RL_FP';
        l2.Value__c = 'Test';
        lstenv.add(l2);
        Environment_Variable__c l3 = new Environment_Variable__c();
        l3.Name = 'ACCT_TM_PRXY_TM_RL_AM';
        l3.Value__c = 'Test';
        lstenv.add(l3);
        Environment_Variable__c l4 = new Environment_Variable__c();
        l4.Name = 'ACCT_TM_PRXY_TM_RL_TS';
        l4.Value__c = 'Test';
        lstenv.add(l4);
        Environment_Variable__c l5 = new Environment_Variable__c();
        l5.Name = 'ACCT_TM_PRXY_TM_RL_AE';
        l5.Value__c = 'Test';
        lstenv.add(l5);
        Environment_Variable__c l6 = new Environment_Variable__c();
        l6.Name = 'ACCT_TM_PRXY_TM_RL_CSR';
        l6.Value__c = 'Test';
        lstenv.add(l6);
        Environment_Variable__c l7 = new Environment_Variable__c();
        l7.Name = 'GF_INTEGRATION_PROFILE_ID';
        l7.Value__c = 'Test';
        lstenv.add(l7);
        Environment_Variable__c l0 = new Environment_Variable__c();
        l0.Name = 'ACCT_TM_PRXY_TM_RL_PCSR';
        l0.Value__c = 'Test';
        lstenv.add(l0);
        Environment_Variable__c l8 = new Environment_Variable__c();
        l8.Name = 'ACCT_TM_PRXY_TM_RL_PAM';
        l8.Value__c = 'Test';
        lstenv.add(l8);
        Environment_Variable__c l9 = new Environment_Variable__c();
        l9.Name = 'ACCT_TM_PRXY_TM_RL_AA';
        l9.Value__c = 'Test';
        lstenv.add(l9);
        Environment_Variable__c lv = new Environment_Variable__c();
        lv.Name = 'ACCT_TM_PRXY_TM_RL_PFTS';
        lv.Value__c = 'Test';
        lstenv.add(lv);
        Environment_Variable__c l11 = new Environment_Variable__c();
        l11.Name = 'ACCT_TM_PRXY_TM_RL_PFAE';
        l11.Value__c = 'Test';
        lstenv.add(l11);
        insert lstenv;

        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;
        
        List<UserPortalDeactivation__c> custSetList = new List<UserPortalDeactivation__c>();
        UserPortalDeactivation__c custSet1 = new UserPortalDeactivation__c();
        custSet1.Name = 'SendEmailNotification';
        custSet1.Months__c = 6;
        custSet1.Days__c = 0;
        custSetList.add(custSet1);
        UserPortalDeactivation__c custSet2 = new UserPortalDeactivation__c();
        custSet2.Name = 'SendEmailNotification2';
        custSet2.Months__c = 6;
        custSet2.Days__c = 0;
        custSetList.add(custSet2);
        UserPortalDeactivation__c custSet3 = new UserPortalDeactivation__c();
        custSet3.Name = 'SendEmailNotification3';
        custSet3.Months__c = 6;
        custSet3.Days__c = 0;
        custSetList.add(custSet3);
        UserPortalDeactivation__c custSet4 = new UserPortalDeactivation__c();
        custSet4.Name = 'SendEmailNotification4';
        custSet4.Months__c = 6;
        custSet4.Days__c = 0;
        custSetList.add(custSet4);
        insert custSetList;
        Map<String,Object> fieldValueMap = New Map<String,Object>();        
        fieldValueMap.put('name','TEST rec1205');
        fieldValueMap.put('Stage__c','Active');
        fieldValueMap.put('Short_Name__c','TESTrec12051');
        fieldValueMap.put('Site_Department__c','test dept1205');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','transactional');   
        fieldValueMap.put('Process_Tech_Interested__c',' MEM');
        fieldValueMap.put('Region__c','JK');        
        fieldValueMap.put('Copy_Address__c',true);
        fieldValueMap.put('Corporate_Address_1__c','50 water st');
        fieldValueMap.put('Corporate_Country__c','USA'); 
        fieldValueMap.put('Corporate_City__c','Bangalore');
        fieldValueMap.put('Corporate_State__c','AB');
        fieldValueMap.put('bill_to_location__c','yes');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap.put('End_Customer__c','people');       
        fieldValueMap.put('Total_Employee__c',100);  
        fieldValueMap.put('Revenue_Potential__c','High Potential'); 
        fieldValueMap.put('Target_Account__c','Yes');
        fieldValueMap.put('Unauthorized__c',false);      
        Account acc1 = AccountDataFactory.createAccount(fieldValueMap);
        Profile pp = [Select Id from Profile where Name='System Administrator'];
        User testUser = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = pp.Id, country='United States',IsActive =true,
                                 timezonesidkey='America/Los_Angeles', username='testercedev2@noemail.com');
        insert testUser;
        test.startTest();
        system.runAs(testUser){
            Account_Team_Proxy__c am = new Account_Team_Proxy__c();
            am.Account__c = acc1.Id;
            am.User__c = userInfo.getUserId();
            am.Team_Role__c = 'Primary Account Manager';
            am.Account_Access__c = 'Read Only';
            am.Opportunity_Access__c = 'Read Only';
            insert am;
        }
        test.stopTest();
        Contact con1 = new Contact(
            LastName = 'test1',
            FirstName = 'testing1',
            AccountId = acc1.Id,
            Email = 'test1@test.com',
            Department__c = 'Design'
        );
        insert con1;
        
        PageReference ref = Page.Portal_Deactivation_pdf;
        Test.setCurrentPage(ref);
        ref.getParameters().put('Ids',con1.Id+';');
        Portal_Deactivation_pdf_Controller pdf = new Portal_Deactivation_pdf_Controller();
        
        
        Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
        User portalAccountOwner1 = new User(ProfileId = profile1.Id );            
        portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
        portalAccountOwner1.Alias = 'batman';
        portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
        portalAccountOwner1.EmailEncodingKey='UTF-8';
        portalAccountOwner1.Firstname='Bruce';
        portalAccountOwner1.Lastname='Wayne';
        portalAccountOwner1.LanguageLocaleKey='en_US';
        portalAccountOwner1.LocaleSidKey='en_US';
        portalAccountOwner1.TimeZoneSidKey='America/Chicago';
        portalAccountOwner1.ContactId = con1.Id;
        portalAccountOwner1.IsActive = true;
        //portalAccountOwner1.Contact.Deactivation_Notification_Date__c = system.today();
        system.runas(testUser){
            Database.insert(portalAccountOwner1);
        }
        con1.Deactivation_Notification_Date__c = system.today();
        update con1;
        UserLoginSendMailsBatch sh1 = new UserLoginSendMailsBatch();      
        String sch = '0 0 23 * * ?';
        Database.Executebatch(sh1);
        system.schedule('Test1', sch, sh1);
        
        List<User> objectList = new List<User>(); 
        
    }
    public void UserActivateTest1(){
        Test.startTest();
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User testUser = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = pp.Id, country='United States',IsActive =true,
                                 timezonesidkey='America/Los_Angeles', username='testercedev2@noemail.com');
        insert testUser;
        System.runAs(testUser){
            Map<String,Object> fieldValueMap = New Map<String,Object>();        
            fieldValueMap.put('name','TEST rec1205');
            fieldValueMap.put('Stage__c','Active');
            fieldValueMap.put('Short_Name__c','TESTrec12051');
            fieldValueMap.put('Site_Department__c','test dept1205');
            fieldValueMap.put('Sub_Type__c','Direct');
            fieldValueMap.put('Transaction_Type__c','transactional');   
            fieldValueMap.put('Process_Tech_Interested__c',' MEM');
            fieldValueMap.put('Region__c','JK');        
            fieldValueMap.put('Copy_Address__c',true);
            fieldValueMap.put('Corporate_Address_1__c','50 water st');
            fieldValueMap.put('Corporate_Country__c','USA'); 
            fieldValueMap.put('Corporate_City__c','Bangalore');
            fieldValueMap.put('Corporate_State__c','AB');
            fieldValueMap.put('bill_to_location__c','yes');
            fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
            fieldValueMap.put('End_Customer__c','people');       
            fieldValueMap.put('Total_Employee__c',100);  
            fieldValueMap.put('Revenue_Potential__c','High Potential'); 
            fieldValueMap.put('Target_Account__c','Yes');
            fieldValueMap.put('Unauthorized__c',false);   
            Account acc1 = AccountDataFactory.createAccount(fieldValueMap);
            Account_Team_Proxy__c am = new Account_Team_Proxy__c();
            am.Account__c = acc1.Id;
            am.User__c = userInfo.getUserId();
            am.Team_Role__c = 'Primary Account Manager';
            insert am;
            Contact con1 = new Contact(
                LastName = 'test1',
                FirstName = 'testing1',
                AccountId = acc1.Id,
                Email = 'test1@test.com',
                Department__c = 'Design',
                Account_Manager__c = testUser.Id,
                Primary_CSR__c = testUser.Id,
                FAE__c = testUser.Id
            );
            insert con1;
            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id );            
            portalAccountOwner1.Username = System.now().millisecond() + 'test2@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email='bruce.wayne@wayneenterprises.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Bruce';
            portalAccountOwner1.Lastname='Wayne';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con1.Id;
            portalAccountOwner1.IsActive = true;
            //portalAccountOwner1.Contact.Deactivation_Notification_Date__c = system.today();
            system.runas(testUser){
                Database.insert(portalAccountOwner1);            
            }
            con1.Deactivation_Notification_Date__c = system.today();
            update con1;
            Portal_Deactivation_pdf_Controller pdf = new Portal_Deactivation_pdf_Controller();
            PageReference ref = Page.Portal_Deactivation_pdf;            
            test.setCurrentPage(ref);
            ApexPages.currentPage().getParameters().put('Ids',con1.Id);
            
            
        }
        UserLoginSendMailsBatch sh1 = new UserLoginSendMailsBatch();      
        String sch = '0 0 23 * * ?';
        Database.Executebatch(sh1);
        system.schedule('Test1', sch, sh1);        
        List<User> objectList = new List<User>(); 
        Test.stopTest();
    }
}