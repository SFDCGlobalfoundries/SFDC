/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_ReticleDatawareHouseBatchHelper
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.
                                            
**/

@isTest(SEEALLDATA = false)
private class ROS_ReticleDatawareHouseBatchHelper_Test {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                 List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
        
    
    static void createROSQueryDataSettings() {
        List<SObject> lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType,'TestROSQueryUCData');
    }
    
    static void createHCMEmplyee(){
        List<HCM_Employee__c> lstHCMEmployee = new List<HCM_Employee__c >();
        
        HCM_Employee__c hcmEmp= new HCM_Employee__c();
        hcmEmp.Login_ID__c = 'testHCM';
        hcmEmp.Last_Name__c = 'TestCSRUser';
        hcmEmp.First_Name__c = 'Test';
        hcmEmp.Department_Name__c =  'IT';
        hcmEmp.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmp.Job_Title__c = 'TestTitle';
        hcmEmp.Phone_Number__c =  '999999999';
        hcmEmp.Employee_ID__c = '123456';
        lstHCMEmployee.add(hcmEmp);
        
        HCM_Employee__c hcmEmp2= new HCM_Employee__c();
        hcmEmp2.Login_ID__c = 'testHCM2';
        hcmEmp2.Last_Name__c = 'TestUser';
        hcmEmp2.First_Name__c = 'Test';
        hcmEmp2.Department_Name__c =  'IT';
        hcmEmp2.Email_Address__c = 'testAdminUser@test.com';
        hcmEmp2.Job_Title__c = 'TestTitle';
        hcmEmp2.Phone_Number__c =  '999999998';
        hcmEmp2.Employee_ID__c = '222222';
        lstHCMEmployee.add(hcmEmp2);
        
        HCM_Employee__c hcmEmp3= new HCM_Employee__c();
        hcmEmp3.Login_ID__c = 'testHCM3';
        hcmEmp3.Last_Name__c = 'TestSolutionUser';
        hcmEmp3.First_Name__c = 'Test';
        hcmEmp3.Department_Name__c =  'IT';
        hcmEmp3.Email_Address__c = 'testSolutionUser@test.com';
        hcmEmp3.Job_Title__c = 'TestTitle';
        hcmEmp3.Phone_Number__c =  '999999997';
        hcmEmp3.Employee_ID__c = '111111';
        lstHCMEmployee.add(hcmEmp3);
        
        insert lstHCMEmployee;
    }
    
    static void createCRMDIDSettings(){
        List<CRMDID__c> lstCRMDID = new List<CRMDID__c>();
        lstCRMDID.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignCRMDID('CRMDID_No',15908));
        insert lstCRMDID;
    }
    
    static CRMDID__c assignCRMDID(String name,Decimal crmdid){
        CRMDID__c crddidRec = new CRMDID__c();
        crddidRec.name = name;
        crddidRec.CRMDID_No__c = crmdid;
        return crddidRec;
    }
    
    
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    static User createAdminUser(){
        
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        //User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true and Fab_Assigned__c != null limit 1];
        User usr1 = new User();           
        usr1.Alias= 'testAdm';
        usr1.Email= 'testAdmin@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testAdminUser@test.com';  
        usr1.Fab_Assigned__c = 'FAB 1';
        usr1.IsActive = true;
        usr1.FederationIdentifier = '222222';
        insert(usr1);
        return usr1;
    }
    
   
    static User createCSRUser(){
        //User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
        //HCM_Employee__c  hcmEmployee = ROS_ReticleDatawareHouseBatchHelper_Test.createHCMEmplyee();
        Profile systemCSRProfile = [select id from Profile where name = 'GF CSR'];
        User usr1 = new User();           
        usr1.Alias= 'testCSR';
        usr1.Email= 'tesCSR@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.LastName = 'TestCSRUser';
        usr1.FirstName = 'Test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemCSRProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testCSRnUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.IsActive = true;
        usr1.FederationIdentifier = '123456';
        insert(usr1);
        return usr1;
    }
    
    static user CraeteSolutionteam(){
        //User usr1 = [select id,name,email from User where Profile.name = 'System Administrator' and IsActive=true and Id in (SELECT UserOrGroupId FROM GroupMember where Group.Name = 'WWMS ROS Team') limit 1];
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testSol';
        usr1.Email= 'testSolutionUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestSolutionUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testSolutionUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.FederationIdentifier = '111111';
        usr1.IsActive = true;
        insert(usr1);
        return usr1;        
    }

    // Creation of an Group and GroupMember
    static Group createGroup(){        
        Group retcileOwner = new Group();
        retcileOwner.Name = 'WWMS ROS Team';
        retcileOwner.DeveloperName = 'WWMS_ROS_Team';
        INSERT retcileOwner;
        return retcileOwner;
    }
    
    //Creation of Group Member
    static GroupMember createGroupMember(String groupId,String userId){
        GroupMember gm= new GroupMember();
        gm.GroupId= groupId;
        gm.UserOrGroupId = userId;
        insert gm;     
        return gm;   
    }
            
    // Creation of an Account
    static Account createAccount(){
         Account acc = getAccount('MYTEST ACCOUNT1');
        return acc;
    }
    
    // Creation of an Account
    static Id createAccount1(){
         Account acc = getAccount('MYTEST ACCOUNT2');
        return acc.Id;
    }
    
    static Id createShippingAddress(String AccountId){
        Shipping_Address__c shipAddress=new Shipping_Address__c(Account__c=AccountId,Address1__c='test',Address2__c='Test',Shipping_Country__c='Country',Shipping_State__c='State',zip_code__c='11111');
        insert shipAddress;
        return shipAddress.Id;
    }
    
    static id createFab(){
        FAB__c FB = new FAB__c(Name='FAB 3');
        insert FB;
        return FB.id;   
    }
    
    static User createFabUser(string FABId,String UserId){
            Fab_User__c FUser = new Fab_User__c(Fab__c =Fabid,user__c=userid,Is_ROS_User__c=true);
            insert FUser;
            User u=[Select Id,name from User where id=:Fuser.User__c];
            return u;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(String AccountId,String UserId,string Role){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = UserId,Sequence_No__c='1',
                                                              Account_Role_ID__c='test',Account__c=AccountId ,Account_Access__c='Read/Write',
                                                              Opportunity_Access__c='Read/Write',Team_Role__c=Role,
                                                              fab_assignment__c = 'FAB 3');
       
        insert atp;
        return atp;
    }
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
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
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = '34E21SA-75AZ';
        dev.Stage__c = 'Solutioning';
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
        insert dev;
        return dev; 
    }
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }   
    static Id createReticleDatawareHouse(Integer DayInactive,String RetcileId) {
      
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
        
        DW.Customer_ID__c= 'CIRRUS';
        DW.CustomerDevice_ID__c = '1313AA-U01';
        DW.FAB__c = 'FAB 3';
        DW.GlobalFoundries_DeviceID__c = '1313AA-U01';
        DW.InactiveDay__c = DayInactive;
        DW.Region_Name__c = 'US';
        DW.Reticle_Status__c = '';
        DW.Reticle_Type__c = 'BINARY';   
        DW.Name = RetcileId;
        insert DW;
        return DW.Id;
    }  
    static Id createReticleCycle() {
        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }
    static Id createReticleDevice(String RetcileId){
        Reticle_Device__c RD = new Reticle_Device__c(Reticle__c =RetcileId,CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011');
        insert RD;
        return RD.Id;
    }  
    static Id createReticleFab(String RetcileId,String fabId){
        Fab_Reticle__c RD = new Fab_Reticle__c(Reticle__c =RetcileId,fab__C=fabId);
        insert RD;
        return RD.Id;
    }
    
    static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }
    
    static Reticle__c createReticle1(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = 'Test';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }    
    /*
     static testmethod void testMethod_createActiveReticles(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        insert lstEnv;
        ROS_ReticleDatawareHouseBatchHelper_Test.createROSQueryDataSettings();
        
        ROS_ReticleDatawareHouseBatchHelper_Test.createHCMEmplyee();
        
        String Cycle = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleCycle();
        User CSRuser = ROS_ReticleDatawareHouseBatchHelper_Test.createCSRUser();
        String fab = ROS_ReticleDatawareHouseBatchHelper_Test.createFab();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawareHouseBatchHelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawareHouseBatchHelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawareHouseBatchHelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Account A = ROS_ReticleDatawareHouseBatchHelper_Test.createAccount();
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawareHouseBatchHelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleFab(RT.Id, fab);
            
            Reticle_Datawarehouse__c DW3 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
            Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
            DW.Customer_ID__c= 'amd';
            DW.CustomerDevice_ID__c = '1313AA-U01';
            DW.FAB__c = 'FAB 3';
            DW.GlobalFoundries_DeviceID__c = '1313AA-U01';
            DW.InactiveDay__c = 100;
            DW.Region_Name__c = 'US';
            DW.Reticle_Status__c = '';
            DW.Reticle_Type__c = 'BINARY';   
            DW.Name = '1313AA-U01';
            insert DW;
            List<Reticle_Datawarehouse__c> listDw = new List<Reticle_Datawarehouse__c>();
            listDw.add(DW);
            ROS_ReticleDatawareHouseBatchHelper.createActiveReticles(listDw);
        Test.stopTest();
    }
    
    static testMethod void method_ValidateDatawareHouseReticles() {
        Test.startTest();
            loadCustomSettings();
            List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
            lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
            lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
            insert lstEnv;
            ROS_ReticleDatawareHouseBatchHelper_Test.createROSQueryDataSettings();
            
            ROS_ReticleDatawareHouseBatchHelper_Test.createHCMEmplyee();
            String acctId = ROS_ReticleDatawareHouseBatchHelper_Test.createAccount1();
            
            String Cycle = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleCycle();
            User CSRuser = ROS_ReticleDatawareHouseBatchHelper_Test.createCSRUser();
            String fab = ROS_ReticleDatawareHouseBatchHelper_Test.createFab();
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser) {
                Group groupGSM = ROS_ReticleDatawareHouseBatchHelper_Test.createGroup();        
                User SolutionUser = ROS_ReticleDatawareHouseBatchHelper_Test.CraeteSolutionteam();
                GroupMember gm = ROS_ReticleDatawareHouseBatchHelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
            }        
            Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Test.stopTest(); 
            
            Reticle__c RT = ROS_ReticleDatawareHouseBatchHelper_Test.createReticle(acctId, Cycle, 500, CSRuser.id);
            
            String Devid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleFab(RT.Id, fab);
            String oppId = ROS_ReticleDatawareHouseBatchHelper_Test.createOpp(acctId);
            String oppProgId = ROS_ReticleDatawareHouseBatchHelper_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ROS_ReticleDatawareHouseBatchHelper_Test.createOppProgTmMem(oppProgId, CSRuser.Id);  
            Device__c dev = ROS_ReticleDatawareHouseBatchHelper_Test.createDevice(acctId,oppId,oppProgId);

       
            List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
            Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 456,Job_Id__c ='1111111');
            lDwNew.add(DW);
            insert lDwNew;            

            
            Reticle_Datawarehouse__c RT1 = new Reticle_Datawarehouse__c(Name = 'Test',CustomerDevice_ID__c='34E21SA-75AZ',GlobalFoundries_DeviceID__c='34E21SA-75AZ',InactiveDay__c = 200,Job_Id__c ='1111111');
            insert RT1;                   

            
            List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Reticle__c' and isActive=true and developername='Default' limit 1]; 
            ROS_ReticleDatawareHouseBatchHelper.ValidateDatawareHouseReticles(lDwNew,rtypes[0].Id,Cycle); 
        
    }
    
    static testmethod void testMethod_updateInvalidReason(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        insert lstEnv;
        ROS_ReticleDatawareHouseBatchHelper_Test.createROSQueryDataSettings();
        
        ROS_ReticleDatawareHouseBatchHelper_Test.createHCMEmplyee();
        
        String Cycle = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleCycle();
        User CSRuser = ROS_ReticleDatawareHouseBatchHelper_Test.createCSRUser();
        String fab = ROS_ReticleDatawareHouseBatchHelper_Test.createFab();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawareHouseBatchHelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawareHouseBatchHelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawareHouseBatchHelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];

        
        Test.startTest();
            Account A = ROS_ReticleDatawareHouseBatchHelper_Test.createAccount();
            String acctId = ROS_ReticleDatawareHouseBatchHelper_Test.createAccount1();

            List<Reticle__c> lstReticle = new List<Reticle__c >();
            Reticle__c RT = ROS_ReticleDatawareHouseBatchHelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleFab(RT.Id, fab);
            
            lstReticle.add(RT);
        
            List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
            Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111',Customer_id__c='broadcom');
            Reticle_Datawarehouse__c DW2 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');

            insert DW;
            insert DW2;
            lDwNew.add(DW);
            lDwNew.add(DW2);

            ROS_ReticleDataWarehouseBatchHelper.updateInvalidReason(lstReticle,lDwNew,'1111111');
        Test.stopTest();
    }
    
    static testMethod void methodROS_SharingRecordswithCSRs() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ReticleDatawareHouseBatchHelper_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        insert lstEnv;
        ROS_ReticleDatawareHouseBatchHelper_Test.createROSQueryDataSettings();
        
        ROS_ReticleDatawareHouseBatchHelper_Test.createHCMEmplyee();
        
        String Cycle = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleCycle();
        User CSRuser = ROS_ReticleDatawareHouseBatchHelper_Test.createCSRUser();
        String fab = ROS_ReticleDatawareHouseBatchHelper_Test.createFab();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawareHouseBatchHelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawareHouseBatchHelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawareHouseBatchHelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Account A = ROS_ReticleDatawareHouseBatchHelper_Test.createAccount();
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawareHouseBatchHelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawareHouseBatchHelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Account_Team_Proxy__c atpRec = createAccountTeamProxy(A.Id,CSRUser.Id,'Customer Service Rep');
            List<Account_Team_Proxy__c> lstAtp = new List<Account_Team_Proxy__c >();
            lstAtp.add(atpRec );
            ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(RT.Id,lstATP);
        Test.stopTest();
    }
    */
    
    static Reticle__c createReticle(String name, Id accountId, String rosCycle, Integer dayInactive, Id ownerId,
                                     Boolean solTeamConfirm, String reticleType, String region, String workflowStatus){
        return new Reticle__c(Name = name, Account__c  = accountId, ROS_Cycle__c = rosCycle, Day_Inactive__c = dayInactive,
                              OwnerId = Ownerid,  Solution_Team_Confirm__c   = solTeamConfirm,Reticle_Type__c = reticleType,
                              Region__c = region, Reticle_workflow_Status__c = workflowStatus);                            
    }
    
    static testMethod void testMethod_createActiveReticles() {
        
        Account account = createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        List<Reticle__c> reticleList = new List<Reticle__c>();
        
        for(Integer i=1; i < 3; i++){
            Reticle__c reticle = createReticle('A1100'+i,account.Id, cycle, 500+i, userInfo.getUserId(), true, 'Binary', 
                                               'US', 'Pending to Notify Customer');
            reticleList.add(reticle);
        }
        insert reticleList;
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        for(Reticle__c reticle:reticleList){
            Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011',Is_Temporary__c = false);
            reticleDeviceList.add(reticleDevice);
            fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        }
        insert reticleDeviceList;
        insert fabReticleList;
        
        Test.startTest();
            List<Reticle_Datawarehouse__c> listDw = new List<Reticle_Datawarehouse__c>();
            
            for(integer i=2;i<4;i++){
                Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
                DW.Customer_ID__c= 'amd';
                DW.CustomerDevice_ID__c = '1313AA-U01'+i;
                DW.FAB__c = 'FAB 3';
                DW.GlobalFoundries_DeviceID__c = '1313AA-U011'+i;
                DW.InactiveDay__c = 502;
                DW.Region_Name__c = 'US';
                DW.Reticle_Status__c = '';
                DW.Reticle_Type__c = 'BINARY';   
                DW.Name = 'A1100'+i;
                listDw.add(DW);
            }
            insert listDw;            
            ROS_ReticleDatawareHouseBatchHelper.createActiveReticles(listDw);        
        Test.stopTest();
    }
    
    static testMethod void method_ValidateDatawareHouseReticles() {
        
        Account account = createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        List<Reticle__c> reticleList = new List<Reticle__c>();
        
        for(Integer i=1; i < 3; i++){
            Reticle__c reticle = createReticle('A1100'+i,account.Id, cycle, 500+i, userInfo.getUserId(), true, 'Binary', 
                                               'US', 'Pending to Notify Customer');
            reticleList.add(reticle);
        }
        insert reticleList;
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        for(Reticle__c reticle:reticleList){
            Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011',Is_Temporary__c = false);
            reticleDeviceList.add(reticleDevice);
            fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        }
        insert reticleDeviceList;
        insert fabReticleList;
        
        Test.startTest();
            
            List<Reticle_Datawarehouse__c> listDw = new List<Reticle_Datawarehouse__c>();
            for(integer i=0;i<5;i++){
                Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
                DW.Customer_ID__c= 'amd';
                DW.CustomerDevice_ID__c = '1313AA-U01'+i;
                DW.FAB__c = 'FAB 3';
                DW.GlobalFoundries_DeviceID__c = '1313AA-U011'+i;
                DW.InactiveDay__c = 502;
                DW.Region_Name__c = 'US';
                DW.Reticle_Status__c = '';
                DW.Reticle_Type__c = 'BINARY';   
                DW.Name = 'A1100'+i;
                listDw.add(DW);
            }
            insert listDw;
            List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Reticle__c' and isActive=true and developername='Default' limit 1]; 
            ROS_ReticleDatawareHouseBatchHelper.ValidateDatawareHouseReticles(listDw,rtypes[0].Id,Cycle); 
        
        Test.stopTest();
    }
    
    static testMethod void testMethod_updateInvalidReason() {
        
        Account account = createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        List<Reticle__c> reticleList = new List<Reticle__c>();
        
        for(Integer i=1; i < 2; i++){
            Reticle__c reticle = createReticle('A1100'+i,account.Id, cycle, 500+i, userInfo.getUserId(), true, 'Binary', 
                                               'US', 'Pending to Notify Customer');
            reticleList.add(reticle);
        }
        insert reticleList;
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        for(Reticle__c reticle:reticleList){
            Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011',Is_Temporary__c = false);
            reticleDeviceList.add(reticleDevice);
            fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        }
        insert reticleDeviceList;
        insert fabReticleList;
        
        Test.startTest();            
            List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
            Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'A11001',InactiveDay__c = 350,Job_Id__c ='1111111',Customer_id__c='broadcom');
            Reticle_Datawarehouse__c DW2 = new Reticle_Datawarehouse__c(Name = 'A11001',InactiveDay__c = 350,Job_Id__c ='1111111');
            insert DW;
            insert DW2;
            lDwNew.add(DW);
            lDwNew.add(DW2);
            ROS_ReticleDataWarehouseBatchHelper.updateInvalidReason(reticleList,lDwNew,'1111111');
        Test.stopTest();
    }
    
    static testMethod void methodROS_SharingRecordswithCSRs() {
        Account account = createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        List<Reticle__c> reticleList = new List<Reticle__c>();
        
        for(Integer i=1; i < 2; i++){
            Reticle__c reticle = createReticle('A1100'+i,account.Id, cycle, 500+i, userInfo.getUserId(), true, 'Binary', 
                                               'US', 'Pending to Notify Customer');
            reticleList.add(reticle);
        }
        insert reticleList;
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        for(Reticle__c reticle:reticleList){
            Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011',Is_Temporary__c = false);
            reticleDeviceList.add(reticleDevice);
            fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        }
        insert reticleDeviceList;
        insert fabReticleList;
        
        Test.startTest();   
            Reticle__c RT = reticleList[0];         
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            //RT.Fabstr__c = 'FAB 3';
            update RT;
            
            User userRec = [select id from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
            Account_Team_Proxy__c atpRec = createAccountTeamProxy(account.Id,userRec.Id,'Customer Service Rep');
            
            List<Account_Team_Proxy__c> lstAtp = new List<Account_Team_Proxy__c >();
            lstAtp.add(atpRec );
            ROS_ReticleDatawareHouseBatchHelper.shareReticleAtp(RT.Id,lstATP);
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
    
}