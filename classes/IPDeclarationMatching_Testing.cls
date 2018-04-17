/*VCIDOverride
    Author: Ariz Solito
    Description: Apex test class for IPDeclarationMatching
    History: 
        Asolito     07122013    - Code creation.
        Nbustillos  08122013    - Removed reference to IP_Component__c and change it to Name. 
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false  
        Sunil Arora 01092014    - Added Department__c='Design' into contact object. 
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.  
        Ashwini     03302015    - Refactoring test class.                                             
*/
@isTest(SeeAllData=false)
public with sharing class IPDeclarationMatching_Testing {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        Test.startTest();
        
        Account accountObj = AccountDataFactory.createAccount(fieldValueMap);                
        
    Map<String,Object> fieldValueMapOpp = new Map<String,Object>();
        fieldValueMapOpp.put('AccountId',accountObj.id);
        fieldValueMapOpp.put('Name','Test Opportunity');  
        fieldValueMapOpp.put('StageName','1. Discovery');
        fieldValueMapOpp.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMapOpp.put('Target_Process_Node__c','14XM');
        fieldValueMapOpp.put('Market_Segment__c','Automotive');  
        fieldValueMapOpp.put('Process_Platform__c','GF Baseline');
        fieldValueMapOpp.put('Fab_Split__c',100);          
        fieldValueMapOpp.put('Process_Geometry__c','0.014UM');  
        fieldValueMapOpp.put('Process_Family__c','Super Low Power');
        fieldValueMapOpp.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMapOpp.put('Fab_Assignment_1__c','FAB 1');
        
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMapOpp);
    
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=accountObj.id,
            Opportunity__c=opp.id
        );
        insert opProg;
        
        Test.stopTest();
    }

    //test method for the class     
    static testMethod void matching(){       
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
                      
       
       
        Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        Opportunity_Program__c opProg = [SELECT Id, Name, Opportunity__c FROM Opportunity_Program__c WHERE Name = 'Test OppProg' LIMIT 1];
        
        List<User> users = new List<User>();
        
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing117@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );       
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing227@test.com',
            communitynickname='ts2',
            FederationIdentifier='Test2013'
        );
        
        users.add(u1);
        users.add(u2);
        
        insert users;                        
         
        List<Opportunity_Program_Team_Member__c> members = new List<Opportunity_Program_Team_Member__c>();
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Account Manager',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );        
        
        Opportunity_Program_Team_Member__c optm2 = new Opportunity_Program_Team_Member__c(
            user__c = u2.id,
            team_role__c= 'Field Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );
        
        members.add(optm1);
        members.add(optm2);        
        
        insert members;
        
                    
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;        
         test.startTest();       
        
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.id,opProg.id);
            dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            dev.assigned_process_ID__c = pr.id ;
            dev.Enabled_via_previous_MPW_1__c = 'No';
            dev.Fab__c = 'Fab 3';
            dev.Confidence_Level_Tapeout__c = '100';
            dev.CRMDID__c = '1234567890';
 /*
            Name = 'TESTDEVICE1313',
            Stage__c = 'Tapeout',
            Status__c = 'Active',
            Account__c = acc.id,
            Opportunity2__c = opp.id,
            Opportunity_Program__c = opProg.id,
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
            Enabled_via_previous_MPW_1__c = 'No',
            Fab__c = 'Fab 3',
            Confidence_Level_Tapeout__c = '100',
            CRMDID__c = '1234567890' */    
        
        insert dev;                  
         
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
        
        //call matching process - mismatch no IP component
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
                                                          
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            device__c = dev.id,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;                                                                                                                                                        
         test.stopTest();
        List<IP_Declaration_Component__c> newComps = new List<IP_Declaration_Component__c>();
        IP_Declaration_Component__c decComp1 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 1',
            IP_type__c = 'IO',
            tech_type__c = '0.11',
            tech_geometry__c = '0.11',
            oic_ip_component__c = 'ARAGIO_130_IO_L'            
        );                 
       
        IP_Declaration_Component__c decComp2 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 2',
            IP_type__c = 'IO',
            tech_type__c = '0.28',
            tech_geometry__c = '0.28',
            oic_ip_component__c = 'ARAGIO_130_IO_X'
        ); 
        
        newComps.add(decComp1);
        newComps.add(decComp2);
        
        //matched result
        insert newComps;   
                                                                               
    }   
    
    static testMethod void batchMatching(){     

        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
                       
       
           
        Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        Opportunity_Program__c opProg = [SELECT Id, Name, Opportunity__c FROM Opportunity_Program__c WHERE Name = 'Test OppProg' LIMIT 1];
        
        List<User> users = new List<User>();
        
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing1244@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );       
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing2344@test.com',
            communitynickname='ts2',
            FederationIdentifier='Test2013'
        );
        
        users.add(u1);
        users.add(u2);
        
        insert users;                        
        
        List<Opportunity_Program_Team_Member__c> members = new List<Opportunity_Program_Team_Member__c>();
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Account Manager',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );        
        
        Opportunity_Program_Team_Member__c optm2 = new Opportunity_Program_Team_Member__c(
            user__c = u2.id,
            team_role__c= 'Field Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );
        
        members.add(optm1);
        members.add(optm2);        
        
        insert members;
        
                    
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;                        
        
        test.startTest(); 
        
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.id,opProg.id);
             dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            dev.assigned_process_ID__c = pr.id ;
            dev.Enabled_via_previous_MPW_1__c = 'No';
            dev.Fab__c = 'Fab 3';
            dev.Confidence_Level_Tapeout__c = '100';
            dev.CRMDID__c = '1234567890';
        
        /*new Device__c(
            Name = 'TESTDEVICE1313',
            Stage__c = 'Tapeout',
            Status__c = 'Active',
            Account__c = acc.id,
            Opportunity2__c = opp.id,
            Opportunity_Program__c = opProg.id,
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
            Enabled_via_previous_MPW_1__c = 'No',
            Fab__c = 'Fab 3',
            Confidence_Level_Tapeout__c = '100',
            CRMDID__c = '1234567890'     
        );*/
        insert dev;                  
        
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
        
        //call matching process - mismatch no IP component
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
                                                          
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            device__c = dev.id,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;        
        
        IPDeclarationMatching.batchProcessMatching(new List<String>{dec.id});  
        test.stopTest();                                                                                 
    } 
    
    static testMethod void IPOverride(){     
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        Opportunity_Program__c opProg = [SELECT Id, Name, Opportunity__c FROM Opportunity_Program__c WHERE Name = 'Test OppProg' LIMIT 1];
        
        List<User> users = new List<User>();
        
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing113@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );       
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing223@test.com',
            communitynickname='ts2',
            FederationIdentifier='Test2013'
        );
        
        users.add(u1);
        users.add(u2);
        
        insert users;                        
        
        List<Opportunity_Program_Team_Member__c> members = new List<Opportunity_Program_Team_Member__c>();
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Account Manager',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );        
        
        Opportunity_Program_Team_Member__c optm2 = new Opportunity_Program_Team_Member__c(
            user__c = u2.id,
            team_role__c= 'Field Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );
        
        members.add(optm1);
        members.add(optm2);        
        
        insert members;
        
                
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;                        
        
        
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.id,opProg.id);
             dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            dev.assigned_process_ID__c = pr.id ;
            dev.Enabled_via_previous_MPW_1__c = 'No';
            dev.Fab__c = 'Fab 3';
            dev.Confidence_Level_Tapeout__c = '100';
            dev.CRMDID__c = '1234567890';
/*      new Device__c(
            Name = 'TESTDEVICE1313',
            Stage__c = 'Tapeout',
            Status__c = 'Active',
            Account__c = acc.id,
            Opportunity2__c = opp.id,
            Opportunity_Program__c = opProg.id,
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
            Enabled_via_previous_MPW_1__c = 'No',
            Fab__c = 'Fab 3',
            Confidence_Level_Tapeout__c = '100',
            CRMDID__c = '1234567890'     
        );*/
        test.startTest();
        insert dev;                  
        
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
        
        //call matching process - mismatch no IP component
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
                                                          
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            device__c = dev.id,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;  
        
        List<IP_Declaration_Component__c> newComps = new List<IP_Declaration_Component__c>();
        IP_Declaration_Component__c decComp1 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 1',
            IP_type__c = 'IO',
            tech_type__c = '0.11',
            tech_geometry__c = '0.11',
            oic_ip_component__c = 'ARAGIO_130_IO_A'            
        );                 
       
        IP_Declaration_Component__c decComp2 = new IP_Declaration_Component__c(
            master_ip_component__c = comERP.id,
            ip_declaration_form__c = dec.id,
            vendor__c = 'vendor 2',
            IP_type__c = 'IO',
            tech_type__c = '0.28',
            tech_geometry__c = '0.28',
            oic_ip_component__c = 'ARAGIO_130_IO_B'
        ); 
        
        newComps.add(decComp1);
        newComps.add(decComp2);
        
        insert newComps;                                                                                   

        //call matching override by IP
        IPDeclarationMatching.overrideIP(new List<String>{dec.id});
        test.stopTest();                                                           
    } 
    
    static testMethod void VCIDOverride(){      
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
           
        Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        Opportunity_Program__c opProg = [SELECT Id, Name, Opportunity__c FROM Opportunity_Program__c WHERE Name = 'Test OppProg' LIMIT 1];
        
        List<User> users = new List<User>();
        
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing114@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );       
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing224@test.com',
            communitynickname='ts2',
            FederationIdentifier='Test2013'
        );
        
        users.add(u1);
        users.add(u2);
        
        insert users;                        
        
        List<Opportunity_Program_Team_Member__c> members = new List<Opportunity_Program_Team_Member__c>();
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Account Manager',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );        
        
        Opportunity_Program_Team_Member__c optm2 = new Opportunity_Program_Team_Member__c(
            user__c = u2.id,
            team_role__c= 'Field Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
        );
        
        members.add(optm1);
        members.add(optm2);        
        
        insert members;
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;    
        
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
        
        //call matching process - mismatch no IP component
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
        
        
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.id,opProg.id);
            dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            dev.assigned_process_ID__c = pr.id ;
            dev.Enabled_via_previous_MPW_1__c = 'No';
            dev.Fab__c = 'Fab 3';
            dev.Confidence_Level_Tapeout__c = '100';
            dev.CRMDID__c = '1234567890';
        /*new Device__c(
            Name = 'TESTDEVICE1313',
            Stage__c = 'Tapeout',
            Status__c = 'Active',
            Account__c = acc.id,
            Opportunity2__c = opp.id,
            Opportunity_Program__c = opProg.id,
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
            Enabled_via_previous_MPW_1__c = 'No',
            Fab__c = 'Fab 3',
            Confidence_Level_Tapeout__c = '100',
            CRMDID__c = '1234567890'     
        );*/
        test.startTest();
        insert dev;                             
                                                                                 
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            device__c = dev.id,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;  
                                                                                           
        //call matching override by VCID
        IPDeclarationMatching.overrideVCID(new List<String>{dec.id});
        test.stopTest();                                              
    } 
    
    static testmethod void generateMail(){
         Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        Opportunity_Program__c opProg = [SELECT Id, Name, Opportunity__c FROM Opportunity_Program__c WHERE Name = 'Test OppProg' LIMIT 1];
        
       List<User> users = new List<User>();
        
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing115@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );       
        
        User u2 = new User(
            alias = 'ts2', 
            email='testing2@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast2', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing225@test.com',
            communitynickname='ts2',
            FederationIdentifier='Test2013'
        );
        
        users.add(u1);
        users.add(u2);
        
        insert users;   
        test.startTest();
        IPDeclarationMatching.IPDeclaration ipmatch = new IPDeclarationMatching.IPDeclaration(new IP_Declaration_Form__c());
        ipmatch.generateEmail(users);
        test.stopTest(); 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}