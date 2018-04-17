/**
* Author: KOKA GOPI
* Project: Test Class for DeniedParty project to find unauthorized customers
* Description: Test Class for DeniedParty code coverage for Lead,Account,Device__c & Export_Control_Form__c Objects
**/
@isTest
Private Class DeniedPartlistTestClass{
    //Test data for Lead,Account,Device__c & Export_Control_Form__c Objects
    @testSetup
    static void allTheDataForThisTestClass() {
        
        DataUtilTest.loadEnvironmentVariables();
         
        Denied_Party_List__c dpl = New Denied_Party_List__c();
        dpl.COMPANY_NAME__c = 'NamePvt company';
        dpl.ADDRESS_LINE__c = 'address company';
        dpl.COUNTRY__c = 'India';
        insert dpl;
        
        DeniedPartListMetaDataHardCoded__c dplmd = New DeniedPartListMetaDataHardCoded__c();
        dplmd.Name = 'Percentage';
        dplmd.Address__c = 25;
        dplmd.Country__c = 25;
        dplmd.NamePercentage__c = 50;
        insert dplmd;
        
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
        fieldValueMap.put('Site_Department__c','Test Department1');
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
        
        
        String processgeopmetry='0.028UM' ;  
            
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'NamePvt company';
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
         
        Id opptyprogrmid = DeviceUtilTest.createOppProg(testAcct.Id,testOppty.id);
        Id maskSetID = DeviceUtilTest.createMaskSetTtitle();
        
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = testAcct.id;
        mstAcc.Mask_Set_Title__c = maskSetID;
        insert mstAcc;
        //If customer doesn't exist in device
        Test.StartTest();
        Device__c device=DeviceUtilTest.createCustomerMPWDevice4(testAcct.Id ,opptyprogrmid);  
        device.End_Customer__c = 'NamePvt company';
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Tapeout_Type__c ='GlobalShuttle MPW';
        DeniedPartyListHelperClass.multipleTimeFire = true;
        insert device;
         Test.StopTest();
       
    }
    //LeadTrigger "Denied Part" project code coverge Method
    static testmethod void leadDeniedPartlistTestMethod(){
        Test.StartTest();
            //If Customer Exists from Denied_Party_List__c
            Lead newLead = New Lead();
            newLead.FirstName = 'myFN';
            newLead.LastName = 'myLN';
            newLead.Company = 'NamePvt company';
            newLead.Corporate_Address_1__c = 'address company';
            newLead.Corporate_Country__c = 'India';
            insert newLead;
            
            //If doesn't Customer Exists from Denied_Party_List__c
            newLead.Company = 'testGK';
            update newLead;
            
        Test.StopTest();
    }
    //AccountTrigger "Denied Part" project code coverge Method
    static testmethod void accountDeniedPartlistTestMethod(){
        Test.startTest();
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
            fieldValueMap.put('Stage__c','Unqualified1');
            fieldValueMap.put('Site_Department__c','Test Department2');
            fieldValueMap.put('Sub_Type__c','Direct2');
            fieldValueMap.put('Transaction_Type__c','Transactiona');
            fieldValueMap.put('Region__c','APJ2');
            fieldValueMap.put('Bill_To_Address_1__c','Test Address 2');
            fieldValueMap.put('Corporate_Address_1__c','Corporate Address 2');
            fieldValueMap.put('Bill_To_City__c','Test City1');
            fieldValueMap.put('Corporate_City__c','Test City1');
            fieldValueMap.put('Bill_To_Country__c','Singapore1');
            fieldValueMap.put('Corporate_Country__c','Singapore1');
            fieldValueMap.put('RecordTypeId',rt.id);
            fieldValueMap.put('Short_Name__c','TestAcct');
            
            //Account testAcct = AccountDataFactory.createAccount(fieldValueMap);
        Test.stopTest();
    }
    
    //DeviceMaskSetTitleTrigger "Denied Part" project code coverge Method
    static testmethod void deviceDeniedPartlistTestMethod(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        Test.startTest();
            Account testAcct = [SELECT id FROM Account LIMIT 1];
            Opportunity testOppty = [SELECT id FROM Opportunity LIMIT  1];
            MPW_Train_Maintenance__c mtm = New MPW_Train_Maintenance__c();
            mtm.Name = 'MPW13';
            insert mtm;
            //If customer exist in denied part object
            DeniedPartyListHelperClass.multipleTimeFire = true;
            Device__c device = [SELECT  id,Unauthorized__c,Reticle_Type__c,End_Customer__c FROM Device__c LIMIT 1];
            system.debug(device.End_Customer__c+'<-->'+device.Unauthorized__c+'<--->'+device.Reticle_Type__c);
            device.End_Customer__c = 'I AM NOT UA';
            device.Reticle_Type__c = 'Single Layer Reticle (SLR)';
            device.MPW_Train_Number__c = mtm.id;
            device.RTR_Date_Current_Forecast__c = system.today()+5;
            update device;           
            
            DeniedPartyListHelperClass.multipleTimeFire = true;
            device.End_Customer__c = 'NamePvt company';
            update device;
            
            DeniedPartyListHelperClass.multipleTimeFire = true;
            device.Unauthorized__c = false;
            update device;
            
        Test.stopTest();
    }
    
    //ExpCntrlFormTrigger "Denied Part" project code coverge Method
    static testmethod void deviceExportControlPartlistTestMethod(){
        Test.startTest();
            Export_Control_Form__c ecf = New Export_Control_Form__c();
            ecf.End_User_Customer_Name__c = 'NamePvt company';
            insert ecf;
            ecf.End_User_Customer_Name__c = 'NamePvt company1';
            update ecf;
        Test.stopTest();
    }
}