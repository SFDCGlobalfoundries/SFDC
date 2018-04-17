/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class MPWFAEApprovalReminderBatchTest {

    @testSetup static void setupData() {
        //createQueue();

        DataUtilTest.loadEnvironmentVariables();

        Map < String, Object > fieldValueMap = new Map < String, Object > ();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Bill_To_City__c', 'Test City');
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');
        fieldValueMap.put('Fab_9_10__c', 'No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    //@future
    private static void createQueue() {
        Group g1 = new Group(Name = 'MPW 28HPP PLM Approval Queue', type = 'Queue');
        insert g1;
        GroupMember gm = new GroupMember(UserOrGroupId=userinfo.getUserId(),GroupId = g1.Id);
        insert gm;
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'MPW_Reservation__c');
        insert q1;
    }
    private static string createMPWReservationAndSubmitForApproval() {
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        User usr1 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        
        system.runAs(usr1){
            createQueue();
        }
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User u2 = new User(Alias = 'test769', Email = 'test76579@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test76579@testorg.com');
        
        Contact c = new Contact();
        c.LastName = 'Last';
        c.FirstName = 'First';
        c.AccountId = accntObj.Id;
        c.User_Name__c = u2.UserName;
        c.email = 'kanishktest@test.com';
        insert c;

        Manufacturing_Lot__c objChild1 = new Manufacturing_Lot__c();
        objChild1.Name = generateRandomString(15);
        objChild1.Manufacturing_Lot_Id__c = generateRandomString(15);
        //objChild1.Parent_Lot_Id__c = objParent.Id;
        objChild1.Active_Flag__c = true;
        objChild1.Device_ID_MES__c = 'Device';
        objChild1.Current_Mask_Layer_Being_Processed__c = 2;
        objChild1.Total_Mask_Count__c = 5;
        insert objChild1;

        MPW_Train_Maintenance__c mpwmant = new MPW_Train_Maintenance__c();
        mpwmant.Name = 'mpwmant';
        mpwmant.Tapeout_Date_Customer__c = Date.today() - 1;
        insert mpwmant;

        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nm HPP';
        insert mpwConfig;

        Profile objProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User objUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = objProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser35@testorg.com');

        MPW_Reservation__c mpwRes = new MPW_Reservation__c();
        mpwRes.Name = 'Test Mpwres';
        mpwRes.Form_Status__c = 'Draft';
        mpwRes.Category__c = 'Customer';
        mpwRes.Process_Type__c = mpwConfig.id;
        mpwRes.Customer_Company_Name__c = accntObj.Id;
        mpwRes.MPW_Train_Name__c = mpwmant.Id;
        mpwRes.Step_1_Approver_1__c = Userinfo.getUserId();
        mpwRes.Step_1_Approver_2__c = objUser.id;
        insert mpwRes;



        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(mpwRes.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);

        System.assertEquals(reqResult.isSuccess(), true);

        return mpwRes.id;
    }

    public static String generateRandomString(Integer len) {
        final String chars = EncodingUtil.convertToHex(crypto.generateAesKey(128));
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx + 1);
        }
        return randStr;
    }

    private static Account getAccount(string AccountName) {
        Account acct = [SELECT Id, Name FROM Account Where Name = : AccountName];

        return acct;
    }

    private static testmethod void mpwFAEApprovalReminderBatchUnitTest() {
        createMPWReservationAndSubmitForApproval();

        Test.startTest();
        String jobId = Database.executebatch(new MPWFAEApprovalReminderBatch(), 200);

        List < String > lst = new List < String > ();

        for (Integer ii = 0; ii < 200; ii++) {
            lst.add('' + ii);
        }

        MPWFAEApprovalReminderUtil.makeSublist(lst, 100);

        System.assertNotEquals(jobId, null);

        Test.stopTest();

    }
    static User createUser1(){
        User usr1 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    static User createUser2(){
        User usr2 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF Global Admin') and IsActive=true limit 1];
        return usr2;
    }
    static User createUser3(){
        User usr3 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF FAE/FTS') and IsActive=true limit 1];
        return usr3;
    }
    static User createUser4(){
        User usr4 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF PIYE') and IsActive=true limit 1];
        return usr4;
    
    
    }
   
    
    
    
  
    
    // Creation of Account Team Proxy
    static void createAccountTeamProxy(Id acctId){
        List<User> usrList = [select    id
                              from      User
                              where     profileId in (select id from Profile where Name='GF FAE/FTS') and IsActive=true
                              limit 10
                             ];
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        for(User u : usrList){
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acctId,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer');
            atpList.add(atp);
        }
        insert atpList;
        
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
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Technical Support',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
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
        dev.Tapeout_Type__c = 'Retrofit';
        dev.Device_ID__c ='89898989';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = true ; 
        dev.Fab__c = 'Fab 3';
        dev.Process_Technology_2__c = createProcess('PT00test').id ; 
        
        insert dev;
        return dev; 
    }
    
    //Creation of Configuration
     //Creation of Configuration For Design Win
    static Apttus_Proposal__Proposal__c createConfigfordesignwin(Id accId, Id oppId) {
        
        Apttus_Proposal__Proposal__c config4designWin=new Apttus_Proposal__Proposal__c();
        config4designWin.Apttus_Proposal__Opportunity__c=oppId;
        config4designWin.Apttus_Proposal__Account__c=accId;
        config4designWin.Apttus_Proposal__Proposal_Name__c='TestConfig4designwin';
        config4designWin.Purpose_of_the_Configuration__c = 'For Design Win';
         config4designWin.Metal_Option_Not_Listed__c = true;
       
        /*Schema.DescribeFieldResult statusFieldDescription = Apttus_Proposal__Proposal__c.Purpose_of_the_Configuration__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){
            if(pickListEntry.getLabel() == 'For Design Win' ){
                system.debug('>>For Design Win');
                config4designWin.Purpose_of_the_Configuration__c = 'For Design Win';
            }
        }*/
        
        insert config4designWin;
        
       // system.debug('>>Purpose_of_the_Configuration__c = ' + config4designWin.Purpose_of_the_Configuration__c);
        
        return config4designWin;
    }
    static Apttus_Proposal__Proposal__c createConfig1() {
        // Create Configuration
        
        Apttus_Proposal__Proposal__c config1=new Apttus_Proposal__Proposal__c();
        
        config1.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config1.APTPS_Primary__c = True;
        config1.Metal_Option_Not_Listed__c = true;
        insert config1;
        
        return config1;
    }
    //Creation of Configuration with all data
    static Apttus_Proposal__Proposal__c createConfig3(Id accId,Id oppId, Id devId, Process_Technology__c pt) {
        
        Apttus_Proposal__Proposal__c config3=new Apttus_Proposal__Proposal__c();
        config3.Apttus_Proposal__Opportunity__c=oppId;
        config3.Apttus_Proposal__Account__c=accId;
        config3.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config3.Device__c=devId;
        config3.Process_Technology_Lookup__c = pt.Id;
        config3.APTPS_Primary__c = True;
        //Nikhil Bajaj
      //  Config3.SRAM__c = 'Yes';
          //  Config3.PTRF_Rotation__c = '90';
          //  Config3.SRAM_Gate_Orientation__c = 'Horizontal';
         //   Config3.ACLV_Gate_Orientation__c  = 'Horizontal';
         //   Config3.Approval_Check__c =true;
           // Config3.Device__r.Fab__c ='FAB 1';
         //   Config3.Approved_by_Packaging_Team__c =false;
         config3.Consolidated_IP_Status_Check__c = 'yes';
         config3.Purpose_of_the_Configuration__c ='Preliminary';
            
         Config3.Process_Technology__c = 'PT002421';
            Config3.SRAM__c = 'Yes';
            Config3.PTRF_Rotation__c = '90';
            Config3.SRAM_Gate_Orientation__c = 'Horizontal';
            Config3.ACLV_Gate_Orientation__c  = 'Horizontal';


            
           
            
            
            
        insert config3;
        
        return config3;
    }
    
    
     static Apttus_Proposal__Proposal__c createConfigTest(Id accId,Id oppId, Id devId, Process_Technology__c pt) {
     Apttus_Proposal__Proposal__c config3=new Apttus_Proposal__Proposal__c();
     config3.Process_Technology_Lookup__c = pt.Id;
       config3.Apttus_Proposal__Account__c=accId;  
      config3.Purpose_of_the_Configuration__c ='Preliminary';
      config3.IS_Manually_Configured__c =True;
     // config3.Process_Technology_Name__c =
      config3.Process_Technology_Name_1__c ='28nm Generic (G) Baseline (PT002167)';
      config3.Device__c=devId;
      config3.SRAM__c='Yes';
      config3.SRAM_Gate_Orientation__c ='Horizontal';
      config3.Gate_Orientation_PFET__c ='Horizontal';
      
      
      //config3.Poly_Orientation_Status_1__c
     // config3.Device__r.Tapeout_Type__c = 'Retrofit';
      config3.Justification_of_Retrofit__c ='test';
      //config3.Process_Technology_Geometry__c = '0.014UM';
      config3.Packaging_Disclaimer_Message__c='test';
     
        
        
        config3.Apttus_Proposal__Opportunity__c=oppId;
        
        config3.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config3.Device__c=devId;
        
        config3.APTPS_Primary__c = True;
     
         config3.Consolidated_IP_Status_Check__c = 'yes';
        
         
         Config3.Process_Technology__c = 'PT002421';
           // Config3.SRAM__c = 'Yes';
            Config3.PTRF_Rotation__c = '90';
            Config3.SRAM_Gate_Orientation__c = 'Horizontal';
            Config3.ACLV_Gate_Orientation__c  = 'Horizontal';


            
            
           
            
            
        insert config3;
        
        return config3;
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
    private static testMethod void testApprovalProcess2(){
        
        test.startTest();
        User user = createUser2();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        //String conId = CPQConfigurationapprovalControllerTest.createContact(acctId);
        String oppId = createOpp(acctId);
        String oppProgId = createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = createOppProgTmMem(oppProgId, user.Id);     
        Apttus_Proposal__Proposal__c testConfig1=createConfig1();
        
        Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig1);
        system.currentPageReference().getParameters().put('id', testConfig1.Id);
        CPQConfigurationapprovalController testApproval2=new CPQConfigurationapprovalController(stdController);
        testConfig1.Apttus_Proposal__Approval_Stage__c = 'Submitted Phase';
        update testConfig1;
        MPWFAEApprovalReminderBatch configFAERenew =  new MPWFAEApprovalReminderBatch();
        configFAERenew.whomToNotify  = 'FAE';
        configFAERenew.objectAPIName = 'Apttus_Proposal__Proposal__c';
        String jobId1 = Database.executebatch(configFAERenew, 200);
        
        MPWFAEApprovalReminderBatch configFAERenew1 =  new MPWFAEApprovalReminderBatch();
        configFAERenew1.whomToNotify  = 'PIYE';
        configFAERenew1.objectAPIName = 'Apttus_Proposal__Proposal__c';
        String jobId2 = Database.executebatch(configFAERenew1, 200);

        List < String > lst = new List < String > ();

        for (Integer ii = 0; ii < 200; ii++) {
            lst.add('' + ii);
        }

        MPWFAEApprovalReminderUtil.makeSublist(lst, 100);

        System.assertNotEquals(jobId1, null);
        System.assertNotEquals(jobId2, null);
        
        test.stopTest();
    } 
}