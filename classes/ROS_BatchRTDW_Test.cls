/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_BatchRTDW
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.
**/

 
@isTest(SEEALLDATA = false)
private class ROS_BatchRTDW_Test {
    
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
    
        
    static ROS_Error_Messages__c assignErrorMessage(String name,String value){
        ROS_Error_Messages__c rosErr = new ROS_Error_Messages__c();
        rosErr.name = name;
        rosErr.value__c = value;
        return rosErr;
    }
    
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    static void createROSQueryDataSettings() {
        List<SObject> lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType,'TestROSQueryUCData');
    }
    
    static User createCSRUser(){
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
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testSol';
        usr1.Email= 'testSolutionUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test1';
        usr1.LastName = 'TestSolutionUser1';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testSolutionUser111@test.com'; 
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
         Account acc= getAccount('MYTEST ACCOUNT2');
        
        return acc;
    }
    
    // Creation of an Account
    static Id createAccount1(){
         Account acc= getAccount('MYTEST ACCOUNT1');
        
        return acc.Id;
    }
    
    static id createFab(){
        FAB__c FB = new FAB__c(Name='FAB 3');
        insert FB;
        return FB.id;   
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
    
    static testMethod void methodForBatch() {
        test.startTest();
            //DataUtilTest.loadEnvironmentVariables();
           // loadCustomSettings();
            //List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
            //lstEnv.add(ROS_BatchRTDW_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
           // lstEnv.add(ROS_BatchRTDW_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
           // insert lstEnv;
            ROS_BatchRTDW_Test.createROSQueryDataSettings();
            Account A = ROS_BatchRTDW_Test.createAccount();
            Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
            env.value__c=A.Id;
            update env;    
             
            ROS_BatchRTDW_Test.createHCMEmplyee();
            
            String Cycle = ROS_BatchRTDW_Test.createReticleCycle();
            User CSRuser = ROS_BatchRTDW_Test.createCSRUser();
            String fab = ROS_BatchRTDW_Test.createFab();
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser) {
                Group groupGSM = ROS_BatchRTDW_Test.createGroup();        
                User SolutionUser = ROS_BatchRTDW_Test.CraeteSolutionteam();
                GroupMember gm = ROS_BatchRTDW_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
            }        
            Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
            
        Test.StopTest();
        
        Reticle__c RT = ROS_BatchRTDW_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
        String Devid = ROS_BatchRTDW_Test.createReticleDevice(RT.Id);
        String Fabid = ROS_BatchRTDW_Test.createReticleFab(RT.Id, fab);
    
        String DW1 = ROS_BatchRTDW_Test.createReticleDatawareHouse(560,'1313AA-05AZ');
        String DW2 = ROS_BatchRTDW_Test.createReticleDatawareHouse(100,'6470G-M2CZQAF1');
        String DW3 = ROS_BatchRTDW_Test.createReticleDatawareHouse(600,'1313AA-05AZ');

        ROS_BatchRTDW DWB2 = new ROS_BatchRTDW();
        DWB2.isTestClass = true;

        ROS_BATCH_ActiveReticleDailyLoad DWB3 = new ROS_BATCH_ActiveReticleDailyLoad();
        DWB3.isTestClass = true;        

        ID batchprocessid = Database.executeBatch(DWB2);
        ID batchprocessid1 = Database.executeBatch(DWB3);
                
    }
    
    static void testMethod_NegativeBatch(){
        test.startTest();               
            FAB__c FB1 = new FAB__c(Name='FAB 3');
            insert FB1;
            Reticle_Datawarehouse__c DW2 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111', FAB__c = FB1.Name);
        
            Reticle__c RT                 = new Reticle__c();
            RT.Account__c                 = ROS_BatchRTDW_Test.createAccount1();
           
            RT.ROS_Cycle__c               = ROS_BatchRTDW_Test.createReticleCycle();
            RT.Day_Inactive__c            = 100;
            RT.Solution_Team_Confirm__c   = true;
            RT.Name                       = 'Test1';
            RT.Reticle_Type__c            = 'BINARY';
            RT.Region__c                  = 'US';
            RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
            RT.Invalid__c = true;
            RT.Job_Id__c = '123';
            insert RT;
        
            insert DW2 ;  
            FAB__c FB2 = new FAB__c(Name='FAB 2');
            insert FB2;
            ROS_BatchRTDW DWB2 = new ROS_BatchRTDW();
            DWB2.isTestClass = true;
            DWB2.JOBID = '123';
            ID batchprocessid = Database.executeBatch(DWB2);

        test.stopTest();
     }
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }     
}