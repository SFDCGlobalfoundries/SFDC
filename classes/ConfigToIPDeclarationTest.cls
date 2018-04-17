/*
    Author: Monalisa Mohhapatra
    Description: This Class serves as the controller for the ConfigToIPDeclaration.
    History: 
        Monalisa      15122014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     04072015    - Refactoring test class.
    Devendra  10142015      - Updated to fix device validation error
*/ 
@isTest(SeeAllData=false)
private class ConfigToIPDeclarationTest{
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
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
        
        User user = ConfigToIPDeclarationTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = ConfigToIPDeclarationTest.createContact(acctId);
        String oppId = ConfigToIPDeclarationTest.createOpp(acctId);
        String oppProgId = ConfigToIPDeclarationTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ConfigToIPDeclarationTest.createOppProgTmMem(oppProgId, user.Id);                 
        test.startTest();
        Device__c dev = ConfigToIPDeclarationTest.createDevice(acctId,oppId,oppProgId); 
        test.stopTest();        
    }
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
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
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Win Test Opportunity 12345_MM');  
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
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345_MM',Account__c=acctId,Opportunity__c=oppId);
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
    //Creation of Configuration
    static Apttus_Proposal__Proposal__c createConfig1(Id accId,Id oppId, Id devId) {
        // Create Configuration
        
        Apttus_Proposal__Proposal__c config1=new Apttus_Proposal__Proposal__c();
        //config1.Name='Test-0001';
        config1.Apttus_Proposal__Opportunity__c=oppId;
        config1.Apttus_Proposal__Account__c=accId;
        config1.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config1.Device__c=devId;
        config1.APTPS_Primary__c = True;
        insert config1;
        
        return config1;
    }
    //Creation of Configuration without Device
    static Apttus_Proposal__Proposal__c createConfig2(Id accId,Id oppId) {
        // Create Configuration
        
        Apttus_Proposal__Proposal__c config2=new Apttus_Proposal__Proposal__c();
        
        config2.Apttus_Proposal__Account__c=accId;
        config2.Apttus_Proposal__Opportunity__c=oppId;
        config2.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config2.Device__c=null;
        config2.APTPS_Primary__c = False;
        insert config2;
        
        return config2;
    }
    
    //Static method to create product test record
    static Process_Technology__c createProcess(String szName){
        //Create a proposal line item
        Process_Technology__c process = new Process_Technology__c(Name = szName  ); 
        insert process;
        return process;
    }
    
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','Win-TEST-DEVICE-1947');
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Expose_Device_to_Customer__c',true);
        fieldValueMap.put('Process_Technology_2__c',createProcess('PT00test').id);
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    // Creation of Device
    static Device__c createDevice1(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TEST-DEVICE-1947');
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Expose_Device_to_Customer__c',true);
        fieldValueMap.put('Process_Technology_2__c',createProcess('PT00test').id);
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
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
        
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        insert pt;
        return pt;   
    }
    static void updateDevice(Device__c dev,Id ptId){
        dev.Stage__c = 'Design In';
        dev.Confidence_Level_Tapeout__c = '90';
        dev.Device_Sourcing__c = 'First Source';
        dev.Fab__c = 'FAB 8';
        dev.Expose_Device_to_Customer__c=true;
        dev.Process_Technology_2__c = ptId;
        update dev;
        //return dev;
    }
    
    static testMethod void testConfigToIpDeclaration2(){
        //DataUtilTest.loadEnvironmentVariables();

        User user = ConfigToIPDeclarationTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = [Select Id, name from Contact where Email = 'con1@gf.com'].Id;//ConfigToIPDeclarationTest.createContact(acctId);
        String oppId = [Select Id, Name from Opportunity where Name='Win Test Opportunity 12345_MM'].Id;//ConfigToIPDeclarationTest.createOpp(acctId);        
        String oppProgId = [Select Id, Name from Opportunity_Program__c where Name='Win Test OppProg 12345_MM'].Id;//ConfigToIPDeclarationTest.createOppProg(acctId, oppId);
        test.startTest();
        Opportunity_Program_Team_Member__c oppProgTM = ConfigToIPDeclarationTest.createOppProgTmMem(oppProgId, user.Id); 
        
        Device__c dev = [Select Id, Name from Device__c where Name = 'Win-TEST-DEVICE-1947'];//ConfigToIPDeclarationTest.createDevice(acctId,oppId,oppProgId);
        
         
        Apttus_Proposal__Proposal__c testConfig1=ConfigToIPDeclarationTest.createConfig1(acctId,oppId,dev.Id);
            IP_Declaration_Form__c testIp1=ConfigToIPDeclarationTest.createIpDecForm1(dev.Id);
            system.currentPageReference().getParameters().put('proposalId', testConfig1.Id);
            
            Apttus_Proposal__Proposal__c testConfig3 =ConfigToIPDeclarationTest.createConfig1(acctId,oppId,null);
            system.currentPageReference().getParameters().put('proposalId', testConfig3.Id);
            ConfigToIPDeclaration testConfigtoIP3=new ConfigToIPDeclaration();
            
            system.assertEquals(dev.Name, 'WIN-TEST-DEVICE-1947');
            test.stopTest();
        
    }
    
    
        static testMethod void testConfigToIpDeclaration4(){
        //DataUtilTest.loadEnvironmentVariables();

        User user = ConfigToIPDeclarationTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = [Select Id, name from Contact where Email = 'con1@gf.com'].Id;//ConfigToIPDeclarationTest.createContact(acctId);
        String oppId = [Select Id, Name from Opportunity where Name='Win Test Opportunity 12345_MM'].Id;//ConfigToIPDeclarationTest.createOpp(acctId);
        String oppProgId = [Select Id, Name from Opportunity_Program__c where Name='Win Test OppProg 12345_MM'].Id;//ConfigToIPDeclarationTest.createOppProg(acctId, oppId);
        
        //Opportunity_Program_Team_Member__c oppProgTM = ConfigToIPDeclarationTest.createOppProgTmMem(oppProgId, user.Id); 
        
        Device__c dev2 = [Select Id, Name from Device__c where Name = 'Win-TEST-DEVICE-1947'];//ConfigToIPDeclarationTest.createDevice(acctId,oppId,oppProgId);
        
        
        test.startTest();
            
            //Device__c dev2 = ConfigToIPDeclarationTest.createDevice1(acctId,oppId,oppProgId); 
            IP_Declaration_Form__c testIp2=ConfigToIPDeclarationTest.createIpDecForm1(dev2.Id);
            Apttus_Proposal__Proposal__c testConfig2 =ConfigToIPDeclarationTest.createConfig1(acctId,oppId,dev2.Id);
            system.currentPageReference().getParameters().put('proposalId', testConfig2.Id);
            ConfigToIPDeclaration testConfigtoIP2=new ConfigToIPDeclaration();
            
            Apttus_Proposal__Proposal__c testConfig3 =ConfigToIPDeclarationTest.createConfig1(acctId,oppId,null);
            system.currentPageReference().getParameters().put('proposalId', testConfig3.Id);
            ConfigToIPDeclaration testConfigtoIP3=new ConfigToIPDeclaration();
                       
            dev2.Expose_Device_to_Customer__c = false;
            update dev2;
            system.currentPageReference().getParameters().put('proposalId', testConfig2.Id);
            ConfigToIPDeclaration testConfigtoIP4=new ConfigToIPDeclaration();
            system.assertEquals(dev2.Expose_Device_to_Customer__c, false);
            test.stopTest();
    }
    
    
    static testMethod void testConfigToIpDeclaration3(){
        //DataUtilTest.loadEnvironmentVariables();

        User user = ConfigToIPDeclarationTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String conId = [Select Id, name from Contact where Email = 'con1@gf.com'].Id;//ConfigToIPDeclarationTest.createContact(acctId);
        String oppId = [Select Id, Name from Opportunity where Name='Win Test Opportunity 12345_MM'].Id;//ConfigToIPDeclarationTest.createOpp(acctId);
        String oppProgId = [Select Id, Name from Opportunity_Program__c where Name='Win Test OppProg 12345_MM'].Id;//ConfigToIPDeclarationTest.createOppProg(acctId, oppId);
        test.startTest();
        Opportunity_Program_Team_Member__c oppProgTM = ConfigToIPDeclarationTest.createOppProgTmMem(oppProgId, user.Id); 
        
        //Device__c dev = [Select Id, Name from Device__c where Name = 'Win-TEST-DEVICE-1947'].Id;//ConfigToIPDeclarationTest.createDevice(acctId,oppId,oppProgId);
        
        Apttus_Proposal__Proposal__c testConfig1=ConfigToIPDeclarationTest.createConfig2(acctId,oppId);
        //IP_Declaration_Form__c testIp1=ConfigToIPDeclarationTest.createIpDecForm1(testConfig1.device__c);
        
            
            system.currentPageReference().getParameters().put('proposalId', testConfig1.Id);
            ConfigToIPDeclaration testConfigtoIP1=new ConfigToIPDeclaration();
            testConfigtoIP1.cancel();      
            system.assertEquals(testConfig1.Id, testConfig1.Id);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}