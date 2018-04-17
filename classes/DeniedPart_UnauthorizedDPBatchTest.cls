/**
* Author: KOKA GOPI
* Project: Test Class for DeniedParty Batch Class
* Description: Test Class for DeniedParty Batch Class to find unauthorized customers
**/

@isTest
Private Class DeniedPart_UnauthorizedDPBatchTest{
     @testSetup
    static void allTheDataForThisTestClass() {
        DataUtilTest.loadEnvironmentVariables();
        
        DeniedPartListMetaDataHardCoded__c dplMD = New DeniedPartListMetaDataHardCoded__c();
        dplMD.Name= 'Percentage';
        dplMD.Address__c = 25;
        dplMD.Country__c = 25;
        dplMD.NamePercentage__c = 50;
        insert dplMD;
        
        
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
        
    }
    static testMethod void DeniedPartyListLeadCodeCoverage(){
        
        //fieldValueMap variable used for for "AccountDataFactory"
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];        
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
        //For device
        Id opptyprogrmid = DeviceUtilTest.createOppProg(testAcct.Id,testOppty.id);
        Id maskSetID = DeviceUtilTest.createMaskSetTtitle();
     
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = testAcct.Id;
        mstAcc.Mask_Set_Title__c = maskSetID;
        insert mstAcc;        
        //If customer doesn't exist in device
        Device__c device=DeviceUtilTest.createCustomerMPWDevice4(testAcct.Id ,opptyprogrmid);  
        device.End_Customer__c = 'NamePvt company';
        Test.StartTest();
        insert device;             
            
        Denied_Party_List__c dplLead = New Denied_Party_List__c();
        dplLead.COMPANY_NAME__c = 'NamePvt company';
        dplLead.ADDRESS_LINE__c = 'Test Address';
        dplLead.COUNTRY__c = 'India';
        insert dplLead;
            
         
            DeniedPart_UnauthorizedDeniedPartyBatch sh1 = new DeniedPart_UnauthorizedDeniedPartyBatch();      
            String sch = '0  00 1 3 * ?';
            system.schedule('updp', sch, sh1);
            
        Test.StopTest();
    }
}