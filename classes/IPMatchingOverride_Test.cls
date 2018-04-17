/*
    Author: Ariz Solito
    Description: Apex test class for IPMatchingOverride
    History: 
        Asolito     07232013    - Code creation.
        Nbustillos  08122013    - Removed reference to IP_Component__c and change it to Name. 
        Sunil Arora 01092014    - Added Department__c='Design' into contact object.                       
*/
@isTest(SeeAllData=False)
public with sharing class IPMatchingOverride_Test {
    @testSetup static void testdata() {
        
        DataUtilTest.loadEnvironmentVariables();
        //string acctId = DeviceUtilTest.createAccount();
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'Test Account');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        String acctId = AccountDataFactory.createAccount(fieldValueMap).Id;
        
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        Test.startTest();
        Insert Device;
        Test.stopTest();
    }
    static testMethod void testClass(){ 
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];

        Test.startTest();
        
        /*RecordType recType = [select id from RecordType where Name='Customer' limit 1];     
        Account acc = new Account(
            Name='Test Account',
            RecordTypeId=recType.id,
            Site_Department__c='IT',
            Sub_Type__c='Indirect',
            Transaction_Type__c='Non-Transactional',
            Region__c='US',
            Bill_To_Address_1__c='Test Address',
            Bill_To_City__c='Test City',
            Bill_To_Country__c='India',
            Corporate_Address_1__c='Test Address',
            Corporate_City__c='Test City',
            Corporate_Country__c='India'
        );
        insert acc;
        
        Contact con = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = acc.id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c='Design'
        );
        insert con;                 
        
        Opportunity opp = new Opportunity(
            Name='Test Opportunity',
            AccountId=acc.id,
            StageName='1. Discovery',
            Market_Segment__c='Automotive',
            Target_Process_Node__c='14XM',
            Process_Platform__c='GF Baseline',
            Opportunity_Sourcing_Type__c='First Source',
            Fab_Split__c=100,
            CloseDate = date.newinstance(2012, 12, 21),
            Process_Geometry__c='0.014UM',
            Fab_Assignment_1__c = 'FAB 1',
            Process_Family__c = 'Super Low Power'
        );
        insert opp;
        
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=acc.id,
            Opportunity__c=opp.id
        );
        insert opProg;  */                                      
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;
        
       /* Device__c dev = new Device__c(
            Name = 'TESTDEVICE1313',
            Stage__c = 'Tapeout',
            Status__c = 'Active',
           // Account__c = acc.id,
            //Opportunity2__c = opp.id,
           // Opportunity_Program__c = opProg.id,
            Market_Segment__c = 'Automotive',
            Semiconductor_Device__c = 'Analog Regulator',
            End_Application__c = 'Body',
            Device_Sourcing__c = '3rd Source',
            Tapeout_Type__c = 'Customer MPW',
            Siebel_Device_ID__c = '0987654321',
            IP_Gap__c = false,
            Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
            Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
            Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
            Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
            assigned_process_ID__c = pr.id ,
            CRMDID__c = '1234567890',
            Confidence_Level_Tapeout__c = '10',
            Fab__c = 'FAB 1'   
        );
        insert dev; */                                                         
        
        IP_Component_From_ERP__c comERP = new IP_Component_From_ERP__c (
            Name = 'ARAGIO_110G_IO_L',
            oic_ip_component__c = 'ARAGIO_130_IO_L',
            vendor__c = 'ARAGIO',
            FV_vendor__c = 'Aragio',
            tech_geo__c = '110nm',
            tech_type__c = '110G',
            IP_type__c = 'IO',
            IP_type_desc__c = 'IO Library',
            FV_IP_type__c = 'IO Library' 
        ); 
        insert comERP;
        
        IP_Component_From_ERP__c comERP2 = new IP_Component_From_ERP__c (
            Name = 'ARAGIO_110G_IO_X',
            oic_ip_component__c = 'ARAGIO_130_IO_X',
            vendor__c = 'ARAGIO',
            FV_vendor__c = 'Aragio',
            tech_geo__c = '28nm',
            tech_type__c = '28G',
            IP_type__c = 'IO',
            IP_type_desc__c = 'IO Library',
            FV_IP_type__c = 'IO Library' 
        ); 
        insert comERP2;
        
                      
                                                             
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            device__c = dev.id,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;                             
        
        //test VCID override fail - no VCID components
        PageReference pageRef = Page.IPMatchingOverride;
        pageRef.getParameters().put('override','VCID');
        pageRef.getParameters().put('id',dec.id);
        Test.setCurrentPageReference(pageRef);
                
        IPMatchingOverride ctrl = new IPMatchingOverride();
        ctrl.init();
        
        //test IP override fail - no IP declaration components
        PageReference pageRef2 = Page.IPMatchingOverride;
        pageRef2.getParameters().put('override','IP');
        pageRef2.getParameters().put('id',dec.id);
        Test.setCurrentPageReference(pageRef2);
        
        ctrl = new IPMatchingOverride();
        ctrl.init();               
        
        //test VCID override success
         IP_VCID_Component__c vcid1 = new IP_VCID_Component__c(
            CRM_DID__c = '1234567890',
            process_ID__c = '12345',
            vendor__c = 'vendor 1',
            technology_geometry__c = '0.11',
            program__c = '0.11',
            library__c = 'IO',
            oic_ip_component__c = 'ARAGIO_130_IO_L'  
        ); 
        insert vcid1;
        
        IP_VCID_Component__c vcid2 = new IP_VCID_Component__c(
            CRM_DID__c = '1234567890',
            process_ID__c = '12345',
            vendor__c = 'vendor 2',
            technology_geometry__c = '0.28',
            program__c = '0.28',
            library__c = 'IO',
            oic_ip_component__c = 'ARAGIO_130_IO_X'  
        ); 
        insert vcid2;  
        
        PageReference pageRef3 = Page.IPMatchingOverride;
        pageRef3.getParameters().put('override','VCID');
        pageRef3.getParameters().put('id',dec.id);
        Test.setCurrentPageReference(pageRef3);
                
        ctrl = new IPMatchingOverride();
        ctrl.init();                         
        
        //test IP override success
        IP_Declaration_Component__c decComp1 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 1',
            IP_type__c = 'IO',
            tech_type__c = '0.11',
            tech_geometry__c = '0.11'
        ); 
        insert decComp1;
       
        IP_Declaration_Component__c decComp2 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 2',
            IP_type__c = 'IO',
            tech_type__c = '0.28',
            tech_geometry__c = '0.28'
        ); 
        insert decComp2; 
        
        PageReference pageRef4 = Page.IPMatchingOverride;
        pageRef4.getParameters().put('override','IP');
        pageRef4.getParameters().put('id',dec.id);
        Test.setCurrentPageReference(pageRef4);
        
        ctrl = new IPMatchingOverride();
        ctrl.init();
         Test.stopTest();  
    }
       
}