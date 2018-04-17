/*
    Author: Win
    Description: Apex test class for IpDeclarationEditController
    History: 
        win         09192013    - Code creation. 
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04202015    - Updated code for refactoring of test class.
        NJain       05082015    - Refactoring the test class
*/
@isTest(seealldata=false)
public class IpDeclarationEditController_Test {
    
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
        Apttus_Proposal__Proposal__c prop = createProposal(acctId,Device.id,opptyId);
        Test.stopTest();
    }
    
    static Apttus_Proposal__Proposal__c createProposal(id acctId, id devId, id opptyId){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
                                                    Apttus_Proposal__Account__c = acctId,
                                                    Device__c = devId,
                                                    APTPS_Primary__c = true,
                                                    Apttus_Proposal__Opportunity__c = opptyId,
                                                    Apttus_Proposal__Approval_Stage__c = 'Submitted Phase');
                                                    
        insert proposal;
        return proposal;                                            
    }
    
    // Create new IP Declaration Form 
    static testMethod void createIpDecFormTest1(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
       /* String acctId = IpDeclarationEditController_Test.createAccount();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = IpDeclarationEditController_Test.createOppProgTmMem(oppProgId, user.Id);  
        Device__c dev = DeviceUtilTest.createDevice(); */
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];

        Test.startTest();
       
        
        IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm(dev.Id);
        IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
        IP_White_List__c ipWhiteList = IpDeclarationEditController_Test.createIPWhiteList(acctId.id, ipCompFromERP.Id);
        IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
        
        ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
        IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
        ipCon.init();
        
        ApexPages.currentPage().getParameters().put('type', 'list');
        
        PageReference pgr = ipCon.save();
        
        pgr = ipCon.reAssign();
        system.assert(pgr.getUrl().contains('/apex/IpDeclarationChangeOwner'));        
        
        boolean ipConFormat = ipCon.getQualcommFormat();
        system.assertEquals(ipConFormat,false);
        
        ipConFormat = ipCon.getDefaultFormat();
        system.assertEquals(ipConFormat,true);
        
        boolean flagPdf = ipCon.getPdfReady();
        system.assertEquals(flagPdf,false);
        
        String otherFlag = ipCon.getOther3rdPartyIP();
        system.assertEquals(otherFlag,'NA'); 
        
        List<SelectOption> opt = ipCon.getOnly5vOptions();
        system.assert(opt!=null);              
        
        Test.stopTest();
    }
    
    // Create new IP Declaration Form 
    static testMethod void createIpDecFormTest2(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
        /*String acctId = IpDeclarationEditController_Test.createAccount1();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);*/
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
       
        Test.startTest();
       
        
        IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm1(dev.Id);
        IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
        //IP_White_List__c ipWhiteList = IpDeclarationEditController_Test.createIPWhiteList(acctId.id, ipCompFromERP.Id);
        IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
        
        
        
        ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
        IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
        ipCon.init();
                
        //PageReference pgr = ipCon.submit();
        //system.assert(pgr.getUrl().contains('/apex/IPDeclarationEdit'));         
        
        boolean ipConFormat = ipCon.getQualcommFormat();
        //system.assertEquals(ipConFormat,true);
        
        ipConFormat = ipCon.getDefaultFormat();
        //system.assertEquals(ipConFormat,false);            
        
        Test.stopTest();
    }        
    
    static testMethod void createIpDecFormTest3(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
       /* String acctId = IpDeclarationEditController_Test.createAccount1();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = IpDeclarationEditController_Test.createOppProgTmMem(oppProgId, user.Id);
        Process_Technology__c pt = IpDeclarationEditController_Test.createPT();  
        Device__c dev = DeviceUtilTest.createDevice(); */
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        Test.startTest();
        
        IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm1(dev.Id);
        IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
        IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
        
        ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
        IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
        ipCon.init();
        
        PageReference pgr = ipCon.cancel();
        
        ApexPages.currentPage().getParameters().put('type', 'list');
        
        pgr = ipCon.cancel();
        system.assert(pgr.getUrl().contains('/apex/MyDevices'));
        
        boolean ipConFormat = ipCon.getQualcommFormat();
       // system.assertEquals(ipConFormat,true);
        
        ipConFormat = ipCon.getDefaultFormat();
       // system.assertEquals(ipConFormat,false);             
        
        Test.stopTest();
    }
    
    
    static testMethod void createIpDecFormTest4(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
        /*String acctId = IpDeclarationEditController_Test.createAccount1();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = IpDeclarationEditController_Test.createOppProgTmMem(oppProgId, user.Id);
        Process_Technology__c pt = IpDeclarationEditController_Test.createPT();  
        Device__c dev = DeviceUtilTest.createDevice(); */
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        Apttus_Proposal__Proposal__c prop = [select Id, name from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c = :acctId.Id];
        
        
            //Apttus_Proposal__Proposal__c prop = createProposal(acctId.id,dev.id,oppId.id);
            Test.startTest();
            createProposalLineItem(prop.id);
            createBaseIp('IP008888');
            IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm2(dev.Id,prop.id);
            IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
            IP_Component_From_ERP__c ipCompFromERP2 = IpDeclarationEditController_Test.createIPCompFromERP2();
            
            IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
            
            ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
            IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
            ipCon.init();
            ipCon.getOnly5vOptions();
            ipCon.refreshIPComp();     
            //ipCon.refreshIPComp(); 
            if(ipCon.ipComponentList != null)
            {  
                for(IpDeclarationEditController.xIPComponentFromERP xipcErp:ipCon.ipComponentList){ 
                    xipcErp.selected = true;
                }
                
                ApexPages.currentPage().getParameters().put('type', 'list');
                ipCon.save();
            }
            ipCon.cancel();
        Test.stopTest();
    }
    
    static testMethod void createIpDecFormTest5(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
       /* String acctId = IpDeclarationEditController_Test.createAccount1();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = IpDeclarationEditController_Test.createOppProgTmMem(oppProgId, user.Id);
        Process_Technology__c pt = IpDeclarationEditController_Test.createPT();  
        Device__c dev = DeviceUtilTest.createDevice(); */
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
       
        Apttus_Proposal__Proposal__c prop = [select Id, name from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c = :acctId.Id];
              
            //Apttus_Proposal__Proposal__c prop = createProposal(acctId.id,dev.id,oppId.id);
            Test.startTest();
            createProposalLineItem(prop.id);
            
            createBaseIp('IP008888');
            IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm3(dev.Id,prop.id);
            IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
            IP_Component_From_ERP__c ipCompFromERP2 = IpDeclarationEditController_Test.createIPCompFromERP2();
            
            IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
            
            ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
            IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
            ipCon.init();
            if(ipCon.ipComponentList != null)
            {   
                for(IpDeclarationEditController.xIPComponentFromERP xipcErp:ipCon.ipComponentList){ 
                    xipcErp.selected = true;
                }
                
                ApexPages.currentPage().getParameters().put('type', 'list');
                system.debug('TLAI- submit...');
                ipCon.submit();
            }
            system.debug('TLAI- submit...');           
        
        Test.stopTest();
    }
    
    static testMethod void createIpDecFormTest6(){
        // Data creation
        User user = IpDeclarationEditController_Test.createUser1();
        /*String acctId = IpDeclarationEditController_Test.createAccount1();
        String conId = IpDeclarationEditController_Test.createContact(acctId);
        String oppId = IpDeclarationEditController_Test.createOpp(acctId);
        String oppProgId = IpDeclarationEditController_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = IpDeclarationEditController_Test.createOppProgTmMem(oppProgId, user.Id);
        Process_Technology__c pt = IpDeclarationEditController_Test.createPT();  
        Device__c dev = DeviceUtilTest.createDevice(); */
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        Apttus_Proposal__Proposal__c prop = [select Id, name from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c = :acctId.Id];
        //Apttus_Proposal__Proposal__c prop = createProposal(acctId.id,dev.id,oppId.id);
        Test.startTest();
        createProposalLineItem(prop.id);
        createBaseIp('IP008888');
        IP_Declaration_Form__c ipDecForm = IpDeclarationEditController_Test.createIpDecForm4(dev.Id,prop.id);
        IP_Component_From_ERP__c ipCompFromERP = IpDeclarationEditController_Test.createIPCompFromERP();
        IP_Component_From_ERP__c ipCompFromERP2 = IpDeclarationEditController_Test.createIPCompFromERP2();
        
        IP_Declaration_Component__c ipDecComp = IpDeclarationEditController_Test.createIPDecComponent(ipCompFromERP.Id, ipDecForm.Id);
        
        ApexPages.currentPage().getParameters().put('Id', ipDecForm.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(ipDecForm);
        IpDeclarationEditController ipCon = new IpDeclarationEditController(controller);
        ipCon.init();
        
        ApexPages.currentPage().getParameters().put('type', 'list');
        system.debug('TLAI- Saving...');
        ipCon.cancel();
        system.debug('TLAI- Saving...');           
        
        Test.stopTest();
    }
    
     
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    
    // Creation of an Account
    static Id createAccount(){
        Account acc = new Account(Name='win Test Account 12345',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India',IP_Declaration_Template__c = 'IP_Declaration_Version_default');
        
        insert acc;
        return acc.Id;
    }
    
    // Creation of an Account
    static Id createAccount1(){
        Account acc = new Account(Name='Win Test Account 23456',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India',IP_Declaration_Template__c='IP_Decl_Cust01');
        
        insert acc;
        return acc.Id;
    }
    
    // Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact();
        con.FirstName='Mr';
        con.LastName='Testcon1';
        con.AccountId=acctId;
        con.Email='con1@gf.com';
        con.Department__c='Design';
                                  
        insert con;
        return con.Id;
    }
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Win Test Opportunity 12345');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
       
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    // Creation of Device
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'Fab 3';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
    
    // Creation of Device
    static Device__c createDevice1(Id accId, Id oppId, Id oppProgId,Id ptId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Process_Technology_2__c = ptId;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.IP_Technology__c = '28HPP';
        dev.Fab__c = 'Fab 3';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
    */
    static IP_Declaration_Form__c createIpDecForm(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Undeclared';
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    
    static IP_Declaration_Form__c createIpDecForm1(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Draft';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    
    static IP_Declaration_Form__c createIpDecForm2(Id testDeviceId, id configId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Draft';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        IpDecForm.Configuration__c = configId;
        IpDecForm.Is_Config_Used__c = true;
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    
    static IP_Declaration_Form__c createIpDecForm3(Id testDeviceId, id configId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Draft';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        IpDecForm.Configuration__c = configId;
        IpDecForm.Is_Config_Used__c = false;
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    
    static IP_Declaration_Form__c createIpDecForm4(Id testDeviceId, id configId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Pending Reconciliation';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        IpDecForm.Configuration__c = configId;
        IpDecForm.Is_Config_Used__c = true;
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    
    static IP_Declaration_Component__c createIPDecComponent(Id ipCompFromERPId, Id ipDecFormId){
        IP_Declaration_Component__c decComp1 = new IP_Declaration_Component__c(
            master_ip_component__c = ipCompFromERPId,
            ip_declaration_form__c = ipDecFormId,
            vendor__c = 'vendor 1',
            IP_type__c = 'IO',
            tech_type__c = '0.11',
            tech_geometry__c = '0.11',
            X5V_Only__c = 'Yes',
            Design_ID__c = 'Test'
        ); 
        insert decComp1;
        return decComp1;
    }
    
    static IP_Component_From_ERP__c createIPCompFromERP(){
        IP_Component_From_ERP__c comERP2 = new IP_Component_From_ERP__c (
            Name = 'ARAGIO_110G_IO_X',
            oic_ip_component__c = 'ARAGIO_130_IO_X',
            vendor__c = 'ARAGIO',
            FV_vendor__c = 'Aragio',
            tech_geo__c = '28nm',
            tech_type__c = '28LPE',
            IP_type__c = 'IO',
            IP_type_desc__c = 'IO Library',
            FV_IP_type__c = 'IO Library',
            Enabled_Flag__c = true 
        ); 
        insert comERP2;
        return comERP2;
    }
    
    static IP_Component_From_ERP__c createIPCompFromERP2(){
        IP_Component_From_ERP__c comERP2 = new IP_Component_From_ERP__c (
            Name = 'ARAGIO_110G_IO_X2',
            oic_ip_component__c = 'ARAGIO_130_IO_X2',
            vendor__c = 'ARAGIO',
            FV_vendor__c = 'Aragio',
            tech_geo__c = '28nm',
            tech_type__c = '28G',
            IP_type__c = 'IO',
            IP_type_desc__c = 'IO Library',
            FV_IP_type__c = 'IO Library',
            Enabled_Flag__c = true
            
        ); 
        insert comERP2;
        return comERP2;
    }
    
    static IP_White_List__c createIPWhiteList(Id acctId, Id ipCompFromERPId){
        IP_White_List__c ipWhiteList = new IP_White_List__c();
        ipWhiteList.Account__c = acctId;
        ipWhiteList.Reference_IP_Component_from_ERP__c = ipCompFromERPId;
            
        insert ipWhiteList;
        return ipWhiteList;
    }
    
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        insert pt;
        return pt;   
    }
    
    static void createProposalLineItem(id propId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001');
        Product2 ip = createIPProduct('IP008888');                                           
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = 1,
                                                         Apttus_QPConfig__ItemSequence__c = 1,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId);
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem2 = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = 1,
                                                         Apttus_QPConfig__ItemSequence__c = 2,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = ip.id);                                                 
                                                         
        //insert proposalLineItem;
        insert new list<Apttus_Proposal__Proposal_Line_Item__c>{proposalLineItem, proposalLineItem2};
    }
    
    static Product2 createProduct(String szName, String szCode){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = 'PTs',
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode,
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = 'AA,BB',
                                     Apttus_Config2__ConfigurationType__c = 'Bundle',
                                     IsActive = True);
        
        //insert prod;
        return prod;
    }
    
    static Product2 createIPProduct(string ip){
        Product2 prod = new Product2(Name = ip,
                                     Family = 'IPs',
                                     ProductCode = ip,
                                     Product_External_ID__c = ip,                                     
                                     Apttus_Config2__ConfigurationType__c = 'Option',
                                     Geometry__c = '0.028nm',
                                     IsActive = True);
        
        //insert prod;
        insert prod;
        return prod;
    }
    
    static void createBaseIp(String Ip){
        Base_IP__c baseIp = new Base_IP__c(Name = ip,IP_Number__c = ip, Technology__c = '28G', Tech_Type__c = '28G',Ip_Type__c = 'IO',Geometry__c = '0.028nm');
        insert baseIp;
    }
}