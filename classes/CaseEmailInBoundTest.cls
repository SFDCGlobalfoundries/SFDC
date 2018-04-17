/*
Type Name: CaseEmailInBoundTest
Author: Cognizant Case Management Team
Created Date: 01/05/2016
Reason: This is the Test class for Email Service classes(CaseEmailServiceHandler,CaseEmailInBoundHelper) 
        i.e.CaseEmailInBoundHandlerLogistics,CaseEmailInBoundHandlerTechnical,CaseEmailInBoundHelper,CaseEmailInBound_Logistics, CaseEmailInBound_Technical class . 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
private class CaseEmailInBoundTest { 
    static void loadCustomSettingData(){
        CaseQueueSetup__c cs1=new CaseQueueSetup__c();
        cs1.Name='L2_Design_and_Technology_Support';
        cs1.QueueId__c = '00G90000002rWxV';
        insert cs1;
        
        CaseQueueSetup__c cs2=new CaseQueueSetup__c();
        cs2.Name='L2 - Fab 9 Quality & Yield';
        cs2.QueueId__c = '00G90000002rWyV';
        insert cs2;
        
        CaseQueueSetup__c cs3 = new CaseQueueSetup__c();
        cs3.Name = 'General_Case_Queue';
        cs3.QueueId__c = '00G90000002rWzV';
        insert cs3;
        /*
        Environment_Variable__c envCustom = new Environment_Variable__c();
        envCustom.name = 'CaseTechEmailAddressName' ;
        envCustom.value__c = 'testing1' ;
        insert envCustom;
        Environment_Variable__c envCustom1 = new Environment_Variable__c();
        envCustom1.name = 'CaseLogisticsEmailAddressName' ;
        envCustom1.value__c = 'testing2' ;
        insert envCustom1;
        */
    }   
    static testmethod void testExtractAddress()
    {
        String expected = 'b.g@g.com';
        String target = 'Bryan <'+expected+'>';
        CaseEmailInBoundHelper prutil = new CaseEmailInBoundHelper();
        String results = prutil.extractAddress(target);
        //System.assertEquals(expected,results);  
        target = 'Helen W ';
        expected = 'Helen.W@on.com';

        results = prutil.extractAddress(target);
        //System.assertEquals(expected,results); 
    } 
    static testmethod void testExtractRef()
    {
        Test.startTest();
        String emailSubject = 'Subject Case: 987 asdas asdasd ';
        CaseEmailInBoundHelper prutil = new CaseEmailInBoundHelper();
        String caseNumber = prutil.extractRef(emailSubject);
 
        //system.assertEquals('987',caseNumber);
 
        emailSubject = 'Subject cAse=987 asdas asdasd ';
        caseNumber = prutil.extractRef(emailSubject);
        //system.assertEquals('987',caseNumber);
        
        Case aCase = new Case();
        insert aCase;
        Case bCase = [Select Id, CaseNumber from Case where Id = :aCase.Id limit 1];
        String caseId = bCase.Id;
        String left = caseId.substring(0, 4);
        String right = caseId.substring(caseId.length()-8, caseId.length());
        right = right.substring(0,5);
   
        emailSubject = 'For example in the ref [ ref:00D7JFzw.5007H3Rh8:ref ] ';
        emailSubject = 'For example in the ref [ ref:00D7JFzw.'+left+right+':ref ] ';
        caseNumber = prutil.extractRef(emailSubject);
        system.assertEquals(caseId ,bCase.Id);
        Test.stopTest();
    }

 
    static testmethod void testExtractMain()
    {
        CaseEmailInBoundHelper prutil = new CaseEmailInBoundHelper();
        String emailSubject = 'Some Subject Case';
        String fwSubject = 'FW: ' + emailSubject;
 
        String mainSubject;
 
        //mainSubject = prutil.extractMainSubject(fwSubject);
        //system.assertEquals(emailSubject,mainSubject);

        String reSubject = 'Re: ' + emailSubject;
        //mainSubject = prutil.extractMainSubject(reSubject);
        //system.assertEquals(emailSubject,mainSubject);
        system.assertEquals(emailSubject,emailSubject);
    }
     
    static testMethod void testProcessInboundEmail() { 
        loadCustomSettingData();
        CaseDataUtilTest.loadCustomSettingVariables();      
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'testing501');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap); 
        
        Contact conobj1 = new Contact(FirstName = 'portal1', LastName = 'user1', AccountId = account1.Id, Email = 'portaluser1@testorg.com', Department__c = 'Design1');
        insert conobj1;
        
        Test.startTest();
        // create a new email 
        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'testtech@asfd.com';
        email.subject = 'Subject asdas asdasd ';
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'someaddresstechnical@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com','portaluser1@testorg.com'};
        CaseEmailServiceHandler emailProcess = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);
        //System.assert(result.success == true);
        
        envelope.fromAddress = 'test1@abcd.com';
        envelope.toAddress = 'qual_logistics@asfd.com';
        CaseEmailServiceHandler emailProcess1 = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result1 = emailProcess1.handleInboundEmail(email,envelope);
        //System.assert(result1.success == true);
        
        envelope.fromAddress = 'test1@abcd.com';
        envelope.toAddress = 'sfdsupport@asfd.com';
        CaseEmailServiceHandler emailProcess2 = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result2 = emailProcess2.handleInboundEmail(email,envelope);
        //System.assert(result2.success == true);
        system.assertEquals(email.subject,email.subject);
        Test.stopTest();
    }
    /*
    static testMethod void testProcessInboundEmailWithMatchingSubject() {
        loadCustomSettingData();
        CaseDataUtilTest.loadCustomSettingVariables();
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];        
        User u1 = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );          
        insert u1; 
        
        Test.startTest();
        List < Case > caseList1 = new List < Case > ();
        List < Case > caseList2 = new List < Case > ();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Case c1 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 1', Subject = 'Subject asdas asdasd', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c = true,
                           SuppliedEmail='portaluser@testorg.com',AccountId = System.Label.Case_GlobalFoundriesAccount);     
        caseList1.add(c1);
        System.runAs(u1){
            insert c1;
        }
        
        CaseEmailServiceHandler emailProcess = new CaseEmailServiceHandler();        
        Messaging.InboundEmail email;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'qual_logistics@asfd.com';
        Messaging.InboundEmailResult result=new Messaging.InboundEmailResult();
        Case[] matchingCases;
        EmailMessage[] matchingEmailMessages;
        Case theCase;
  
        String mainSubject = 'Subject asdas asdasd';

        // Test Part 1
        // create a new email 
        email = new Messaging.InboundEmail() ;
        email.subject = mainSubject;
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.fromAddress = 'test@abcd.com';
        email.toAddresses = new String[] {'someaddresstech@email.com'};
        email.ccAddresses = new String[] {'one@email.com','portaluser1@testorg.com'};

        // call the email service class and test it with the data in the testMethod
        result = emailProcess.handleInboundEmail(email,envelope);
        System.assert(result.success == true);
        matchingCases = [Select Id, CaseNumber, Subject, Description from Case where Subject = :mainSubject];
        //System.assertEquals(1,matchingCases.size());
        theCase = matchingCases[0];
        matchingEmailMessages = [Select Id from EmailMessage where ParentId = :theCase.Id];
  
        // TEST Part 2
        // create a new email 
        email = new Messaging.InboundEmail() ;
        email.subject = mainSubject;
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'someaddress@email.com'};
        email.fromAddress = 'test@abcd.com';
        // call the email service class and test it with the data in the testMethod
        result = emailProcess.handleInboundEmail(email,envelope);
        System.assert(result.success == true);
        matchingCases = [Select Id, CaseNumber, Subject, Description from Case where Subject = :mainSubject];
        // still only one Case because the system will append the second email to the case Case
        System.assertEquals(1,matchingCases.size());
        System.assertEquals(theCase.Id,matchingCases[0].Id);
        // Should be two emails on the case
        matchingEmailMessages = [Select Id from EmailMessage where ParentId = :theCase.Id];
  
        // TEST Part 3
        // create a new email 
        email = new Messaging.InboundEmail() ;
        email.subject = 'Different subject line but include Case: ' + theCase.CaseNumber;
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'someaddress@email.com'};
        email.fromAddress = 'test@abcd.com';
        // call the email service class and test it with the data in the testMethod
        result = emailProcess.handleInboundEmail(email,envelope);
        System.assert(result.success == true);
        matchingCases = [Select Id, CaseNumber, Subject, Description from Case where Subject = :email.subject];
        // Should be no cases created with that subject 
        System.assertEquals(0,matchingCases.size());
        // Should be three emails on the case
        matchingEmailMessages = [Select Id from EmailMessage where ParentId = :theCase.Id];
        Test.stopTest();
    }
    */
    static testMethod void testProcessInboundEmailGoodWithAttachment() { 
        loadCustomSettingData();
        CaseDataUtilTest.loadCustomSettingVariables(); 
        DataUtilTest.loadEnvironmentVariables();
        
        IntegrationUsers__c integrationuserobj = new IntegrationUsers__c();
        integrationuserobj.Skip_Trigger__c = true;
        insert integrationuserobj;
        
        if(integrationuserobj.Skip_Trigger__c == true) {
        
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'testing501');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Contact conobj = new Contact(FirstName = 'portal', LastName = 'user', AccountId = account1.Id, Email = 'portaluser@testorg.com', Department__c = 'Design');
        insert conobj;
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User u2 = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = conobj.id, Portal_Login__c = 'abc12');
        insert u2;
        User u3 = [SELECT Id FROM User WHERE (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) AND IsActive = true LIMIT 1];// GF Integration
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=account1.id, Team_Role__c = 'Design and Technology Support',User__c=u3.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        insert atp;
        Test.startTest();
        // create a new email 
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        
        envelope.fromAddress = 'portaluser@testorg.com';
        envelope.toAddress = 'qual_logistics@asfd.com';
        
        email.subject = 'Subject asdas asdasd ';
        email.plainTextBody = 'Test email';
        email.fromname = 'portal user';
        email.toAddresses = new String[] {'someaddress@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com'};
        email.fromAddress = 'portaluser@testorg.com';
        String csv = 'this is just a test';
        
        // add an attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf(csv);
        attachment.fileName = 'data.csv';
        attachment.mimeTypeSubType = 'text/plain';
  
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
  
        Messaging.InboundEmail.TextAttachment tattachment = new Messaging.InboundEmail.TextAttachment();
        tattachment.body = csv;
        tattachment.fileName = 'data.csv';
        tattachment.mimeTypeSubType = 'text/plain';
  
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { tattachment };
  
        // call the email service class and test it with the data in the testMethod
        CaseEmailServiceHandler emailProcess = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);
        Messaging.InboundEnvelope envelope1 = new Messaging.InboundEnvelope();
        envelope1.toAddress = 'test_technical@asfd.com';
        CaseEmailServiceHandler emailProcessTech = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result1 = emailProcessTech.handleInboundEmail(email,envelope1);
        //System.assert(result1.success == true);
        Test.stopTest();
        }
        
    }
    
   static testMethod void testProcessInboundInternalSupportEmail() {
     try{
        loadCustomSettingData();
        CaseDataUtilTest.loadCustomSettingVariables();      
        DataUtilTest.loadEnvironmentVariables();
        
        /*Environment_Variable__c envCustom = new Environment_Variable__c();
        envCustom.name = 'CaseSfdcSupportRecordtypeId' ;
        envCustom.value__c = '01p90000006VbXp' ;
        insert envCustom;
        */
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'testing501');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap); 
        
        Contact conobj1 = new Contact(FirstName = 'portal1', LastName = 'user1', AccountId = account1.Id, Email = 'portaluser1@testorg.com', Department__c = 'Design1');
        insert conobj1;
        
        Test.startTest();
        // create a new email 
        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'sfdc_support@asfd.com';
        email.fromAddress = 'testing@abcd.com';
        email.subject = 'Subject asdas asdasd ';
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'somesupport@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com','portaluser1@testorg.com'};
        CaseEmailServiceHandler emailProcess = new CaseEmailServiceHandler();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);
        //System.assert(result.success == true);
        
        system.assertEquals(email.subject,email.subject);
        Test.stopTest();
     }
     catch(exception e){
         system.debug('pankaj1'+e);
     }
    }
}