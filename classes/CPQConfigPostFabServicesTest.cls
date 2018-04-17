/*
Author: Karna Shiva
Company: GlobalFoundries
Description: This Class serves as the controller for the CPQConfigPostFabServices.
History: 
Karna      - Code creation.

*/ 
@isTest(SeeAllData=false)
private class CPQConfigPostFabServicesTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
        ConfiguratorApprovalSetting__c obj=new ConfiguratorApprovalSetting__c(Default_Approver__c=UserInfo.getUserId(),FAB_Name__c='FAB 2,FAB 3,FAB 3E,FAB 7,FAB 5,FAB 6',Maximum_Approver__c=15);
        insert obj;
     }
     
    //Creation of User
    static User createUser1(){
        User usr1 = [select Id
                     , AccountId
                     , profile.name
                     from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    // Creation of an Account
    static ID createAccount() {
        // Create Account
        Account testAcct = new Account(
            name = 'Test Account',
            stage__c = 'Unqualified',
            site_department__c = 'Test Department',
            sub_type__c = 'Direct',
            transaction_type__c = 'Transactional',
            region__c = 'US',
            bill_to_address_1__c = 'Test Address 1',
            corporate_address_1__c = 'Corporate Address 1',
            bill_to_city__c = 'Test City',
            corporate_city__c = 'Test City',
            bill_to_country__c = 'Singapore',
            corporate_country__c = 'Singapore',
            short_name__c = 'TA123'
        );

        Insert testAcct;       
        
        return testAcct.ID;
    }
// Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact();
        con.FirstName='Mr';
        con.LastName='Testcontact1';
        con.AccountId=acctId;
        con.Email='con1@gf.com';
        con.Department__c='Design';
        
        insert con;
        return con.Id;
    }
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name='Win Test Opportunity 12345_MM',AccountId=acctId,StageName='1. Discovery',Market_Segment__c='Automotive',
                                          Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                          Process_Geometry__c = '0.09UM',Process_Family__c = 'Generic / Nominal',
                                          Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21));
        
        insert opp;
        return opp.Id;
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345_MM',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    //Static method to create product test record
    static Process_Technology__c createProcess(String szName){
        //Create a proposal line item
        Process_Technology__c process = new Process_Technology__c(Name = szName  ); 
        insert process;
        return process;
    }
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        pt.Tech_Geometry__c ='0.014UM';
        insert pt;
        return pt;   
    }
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c(Name = 'TESTDEVICE1313',
                                      Stage__c = 'Design In',
                                      Status__c = 'Active',
                                      Account__c = accId,
                                      Opportunity2__c = oppId,
                                      Opportunity_Program__c = oppProgId,
                                      Market_Segment__c = 'Automotive',
                                      Semiconductor_Device__c = 'Analog Regulator',
                                      End_Application__c = 'Body',
                                      Device_Sourcing__c = '3rd Source',
                                      Tapeout_Type__c = 'Customer MPW',
                                      Siebel_Device_ID__c = '0987654321',
                                      IP_Gap__c = false,
                                      Requested_from_Configuration__c = true, 
                                      Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                                      Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                                      Confidence_Level_Tapeout__c = '100',
                                      IP_Declaration_User_Ids__c = userinfo.getuserid() ,
                                      Fab__c = 'Fab 3');
        insert dev;
        return dev;  
    }
    
    //Creation of Configuration
    static Apttus_Proposal__Proposal__c createConfig1(Id accId, Id OppId, Id devId) {
        // Create Configuration
        
        
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];        
            
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003');        
        insert processTech;
    
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', processTech.PT_Number__c);
        insert pid1;
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devID,                                                     
                                                     Apttus_Proposal__Opportunity__c = oppID,
                                                     Apttus_Proposal__Account__c = accID,                                                   
                                                     sram__c = 'Yes',
                                                     sram_gate_orientation__c = 'Horizontal',
                                                     aclv_gate_orientation__c = 'Horizontal',
                                                     gate_orientation_PFET__c = 'Horizontal',
                                                     ptrf_rotation__c = '90',
                                                     apttus_proposal__approval_stage__c = 'Submitted Phase',
                                                     process_technology__c = 'PT002562',
                                                     Assigned_Process_ID__c = pid1.Id);
        
        insert proposal;
        return proposal;
   
    }
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        //insert prod;
        return prod;
    }
    
    //Static method to create product test record
    static Process__c createProcess(String szName, String szMaskLayers, String szPIDNumber, String szProcessTech){
        //Create a proposal line item
        Process__c process = new Process__c(Name = szName,
                                            Mask_Layers__c = szMaskLayers,
                                            PID_Number__c = szPIDNumber,
                                            Process_Technology__c = szProcessTech);
        
        //insert process;
        return process;
    }
    //Creation of Config Post Fab Services
    static Config_Post_Fab_Services__c createConfigPostFab(Apttus_Proposal__Proposal__c config) {
        // Create Configuration
        
        Config_Post_Fab_Services__c configPstFab=new Config_Post_Fab_Services__c();
        
        configPstFab.Bonding__c ='3DI';
        configPstFab.BLM_Size_Type__c = '3DI';
        configPstFab.Solder_Type__c = '3DI';
        configPstFab.Minimum_C4_Pitch__c = '3DI';
        configPstFab.Solder__c = '3DI';
        configPstFab.Configuration__c = config.id;
        
        insert configPstFab;
        
        return configPstFab;
    }
    
    
    static testMethod void testConfigPostFab(){
        
        User user = CPQConfigPostFabServicesTest.createUser1();
        String acctId = CPQConfigPostFabServicesTest.createAccount();
        String conId = CPQConfigPostFabServicesTest.createContact(acctId);
        //CPQConfigPostFabServicesTest.createAccountTeamProxy(acctId);
        String oppId = CPQConfigPostFabServicesTest.createOpp(acctId);
        String oppProgId = CPQConfigPostFabServicesTest.createOppProg(acctId, oppId);
        
        test.startTest();   
        Device__c dev = createDevice(acctId, oppId, oppProgId);
        Apttus_Proposal__Proposal__c config = CPQConfigPostFabServicesTest.createConfig1(acctId,oppId,dev.id);
        Config_Post_Fab_Services__c configPostFab = CPQConfigPostFabServicesTest.createConfigPostFab(config);
        PageReference myVfPage = Page.CPQConfigPostFabServices;
        Test.setCurrentPageReference(myVfPage);  
        ApexPages.currentPage().getParameters().put('retId',config.Id);
        ApexPages.currentPage().getHeaders().put('Origin', '--c');

        CPQConfigPostFabServices  postFab = new CPQConfigPostFabServices();
        postFab.reviewSelection();
        postFab.backtoOption();
        postFab.backtoQuaterlyPage();
        test.stopTest();     
        
    }
}