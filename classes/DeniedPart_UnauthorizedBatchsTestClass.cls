/**
* Author: KOKA GOPI
* Project: Test Class for DeniedParty Batch's for all below Classes
           1) DeniedPart_UnauthorizedAccountBatch
           2) DeniedPart_UnauthorizedDeviceBatch
           3) DeniedPart_UnauthorizedECFBatch
           4) DeniedPart_UnauthorizedLeadBatch
* Description: Test Class for DeniedParty Batch Class to find unauthorized customers using "DeniedPartCustomerAvoiding" Helper Class
**/

@isTest
Private Class DeniedPart_UnauthorizedBatchsTestClass{
    //below setup data for DeniedParty Batch's
     @testSetup
    static void allTheDataForThisTestClass() {
        DataUtilTest.loadEnvironmentVariables();
        //If Customer Exists from Denied_Party_List__c
        Lead newLead = New Lead();
        newLead.FirstName = 'myFN';
        newLead.LastName = 'myLN';
        newLead.Company = 'NamePvt company';
        newLead.Corporate_Address_1__c = 'address company';
        newLead.Corporate_Country__c = 'India';
        insert newLead;
        
        Error_Codes__c ecc = New Error_Codes__c();
        ecc.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        ecc.Message__c = 'Please ensure that a Backup Customer Service Rep and Primary Field Engineer is defined in Account Team';
        insert ecc;
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        //fieldValueMap variable used for for "AccountDataFactory"
        Map<String,Object> fieldValueMap = New Map<String,Object>();
        fieldValueMap.put('Name','NamePvt company');
        fieldValueMap.put('Stage__c','Unqualified');
        fieldValueMap.put('Site_Department__c','Test Department');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','Transactional');
        fieldValueMap.put('Region__c','APJ');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
        fieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Corporate_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','Singapore');
        fieldValueMap.put('Corporate_Country__c','Singapore');
        fieldValueMap.put('RecordTypeId',rt.id);
        fieldValueMap.put('Short_Name__c','TestAcct');
        
        Account testAcct = AccountDataFactory.createAccount(fieldValueMap);
      
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'company NamePvt Ltd';
        testOppty.AccountId = testAcct.id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.60UM'; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        
        
        Export_Control_Form__c ecf = New Export_Control_Form__c();
        ecf.End_User_Customer_Name__c = 'NamePvt company';
        insert ecf;
            
    }
     //below Method used to coverage leadBatch Job
     static testmethod void UnauthorizedLeadBatchTestMethod(){
          Test.startTest();
            //If Customer Exists from Denied_Party_List__c
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('LeadJob', CRON_EXP, new DeniedPart_UnauthorizedLeadBatch('all') );   
          Test.stopTest();
     }
     //below Method used to coverage AccountBatch Job
     static testmethod void UnauthorizedAccountBatchTestMethod(){
          Test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('LeadJob', CRON_EXP, new DeniedPart_UnauthorizedAccountBatch('all') );   
          Test.stopTest();
     }
     //below Method used to coverage DeviceBatch Job
     static testmethod void UnauthorizedDeviceBatchTestMethod(){
          Test.startTest();
            Account testAcct = [SELECT id FROM Account LIMIT 1];
            Opportunity testOppty = [SELECT id FROM Opportunity LIMIT  1];
            Id opptyprogrmid = DeviceUtilTest.createOppProg(testAcct.Id,testOppty.id);
            Id maskSetID = DeviceUtilTest.createMaskSetTtitle();
         
            MSTAccount__c mstAcc = new MSTAccount__c();
            mstAcc.Account__c = testAcct.id;
            mstAcc.Mask_Set_Title__c = maskSetID;
            insert mstAcc;
            //If customer doesn't exist in device
            Device__c device=DeviceUtilTest.createCustomerMPWDevice4(testAcct.Id ,opptyprogrmid);
            insert device;
            
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('LeadJob', CRON_EXP, new DeniedPart_UnauthorizedDeviceBatch('all') );   
          Test.stopTest();
     }
     //below Method used to coverage ECFBatch Job
     static testmethod void UnauthorizedECFBatchTestMethod(){
          Test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('LeadJob', CRON_EXP, new DeniedPart_UnauthorizedECFBatch('all') );   
          Test.stopTest();
     }
}