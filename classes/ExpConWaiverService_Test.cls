/*
  Author: Anirban Roy
  Description: This is the test class for ExpConWaiverService class.
  History:
    ARoy        09232013    - code creation.
    ARoy        10162013    - modified code to remove SeeAllData=true.
    Vijay       12052014    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 'Design In' directly and added mandatory field End Application.                       
    Ashwini     04072015    - Refactoring test class.
    Vijay       04222015    - added test method for Internal Device functionality.
*/

@isTest(SeeAllData=false)
public class ExpConWaiverService_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Id createMaskSetTitle(){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name', 'MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        Mask_Set_Title__c mstRec = MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap);
        
        return mstRec.Id;
    }
    
    //Creation of User
    static User createUser1(string usrname){
        //User usr1 = [select id,name,email,userroleid from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];        
        Profile prof = [select id from Profile where Name='System Administrator'];
        UserRole usrRole = [select id from UserRole where Name = 'GTC - Global Trade Compliance'];
        User usr1 = new User();        
        usr1.Alias = usrname+'T2';
        //usr1.Email='test2001@test.com';
        usr1.Email=usrname+'@test.com'; 
        usr1.EmailEncodingKey='UTF-8'; 
        //usr1.LastName='Test2001';
        usr1.LastName=usrname+'Test20011';
        usr1.LanguageLocaleKey='en_US'; 
        usr1.LocaleSidKey='en_US';
        usr1.ProfileId = prof.Id;
        usr1.TimeZoneSidKey='America/Los_Angeles'; 
        //usr1.UserName='Test2001@test.com';
        usr1.UserName=usrname+'@test.com';
        usr1.UserRoleId = usrRole.Id;
        usr1.IsActive = true;
        //update usr1;
        return usr1;
    }
    
    //Creation of User
    static User createUser2(string usrname){
        Profile prof = [select id from Profile where Name='System Administrator'];
        User usr2 = new User();        
        //usr2.Alias = 'Test2000';
        usr2.Alias = usrname+'T3';
        usr2.Email=usrname+'@test.com';
        //usr2.Email='test2000@test.com'; 
        usr2.EmailEncodingKey='UTF-8'; 
        //usr2.LastName='Test2000';
         usr2.LastName=usrname+'Test2000';
        usr2.LanguageLocaleKey='en_US'; 
        usr2.LocaleSidKey='en_US';
        usr2.ProfileId = prof.Id;
        usr2.TimeZoneSidKey='America/Los_Angeles'; 
        //usr2.UserName='Test2000@test.com';
        usr2.UserName=usrname+'@test.com';
        usr2.IsActive = true;
        //insert usr2;
        return usr2;
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
        fieldValueMap.put('Name','Test Opportunity');  
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
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem1(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem2(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem3(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='DE - Customer Support',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Device__c createDevice(string name, string fab, string stage, string status, string confienceLevelTapeout, date orginalForecastedTPDate, string siebelDeviceId, string tapeoutType, Id accountId, string geometry, string processFamily){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name',name);
        fieldValueMap.put('Fab__c',fab);
        fieldValueMap.put('Stage__c',stage);
        fieldValueMap.put('Status__c',status);
        fieldValueMap.put('Confidence_Level_Tapeout__c',confienceLevelTapeout);
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',orginalForecastedTPDate);
        fieldValueMap.put('Siebel_Device_ID__c',siebelDeviceId);
        fieldValueMap.put('Tapeout_Type__c',tapeoutType);
        fieldValueMap.put('Account__c',accountId);
        fieldValueMap.put('Internal_Device_Geometry__c',geometry);
        fieldValueMap.put('Internal_Device_Process_Family__c',processFamily);
        fieldValueMap.put('Device_Mask_Set_Title__c','VMSTV');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];                                                                                
        if(!deviceRecTypeList.isEmpty()){  
            fieldValueMap.put('RecordTypeId',deviceRecTypeList[0].Id);      
        }
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.CRMDID__c = 'CDID9999999.00';
        dev.Name = 'TESTDEVICE1947';
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
        dev.BX041_Status__c = 'Closed';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Fab__c = 'FAB 2';
        insert dev;
        return dev; 
    }*/
    
   /* static Device__c createDevice1(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.CRMDID__c = 'CDID9999998.00';
        dev.Name = 'TESTDEVICE1948';
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
        dev.BX041_Status__c = 'Closed';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Export_Control_Waiver_Flag_Request__c = true;
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Fab__c = 'FAB 2';
        insert dev;
        return dev; 
    }
    */
    
    static testMethod void sendNotificationTest1() {                        
        
        List<User> usrList = new List<User>();
        User user1 = ExpConWaiverService_Test.createUser1('yy1');
        User user2 = ExpConWaiverService_Test.createUser2('yy2');
        usrList.add(user1);
        usrList.add(user2);
        insert usrList;
                
        system.runAs(user2){
            //DataUtilTest.loadEnvironmentVariables();        
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = ExpConWaiverService_Test.createContact(acctId);
            String oppId = ExpConWaiverService_Test.createOpp(acctId);
            String oppProgId = ExpConWaiverService_Test.createOppProg(acctId, oppId);
            
            Test.startTest();
            
            Opportunity_Program_Team_Member__c oppProgTM1 = ExpConWaiverService_Test.createOppProgTmMem1(oppProgId, user1.id);
            Opportunity_Program_Team_Member__c oppProgTM2 = ExpConWaiverService_Test.createOppProgTmMem2(oppProgId, user2.id);
            String MSTId = ExpConWaiverService_Test.createMaskSetTitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
                       
            String notificationMsg = ExpConWaiverService.sendNotification(dev.Id, user1.Email, 'System Administrator');
            //system.assertEquals(notificationMsg,'OK');
            
            Test.stopTest();
        }                
    }
    
    
    static testMethod void sendNotificationTest2() {               
        
        List<User> usrList = new List<User>();
        User user1 = ExpConWaiverService_Test.createUser1('yy3');
        User user2 = ExpConWaiverService_Test.createUser2('yy4');                
        usrList.add(user1);
        usrList.add(user2);
        insert usrList;
        
        system.runAs(user2){
                       
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = ExpConWaiverService_Test.createContact(acctId);
            String oppId = ExpConWaiverService_Test.createOpp(acctId);
            String oppProgId = ExpConWaiverService_Test.createOppProg(acctId, oppId);
            
            Test.startTest();
            
            Opportunity_Program_Team_Member__c oppProgTM1 = ExpConWaiverService_Test.createOppProgTmMem1(oppProgId, user1.id);
            Opportunity_Program_Team_Member__c oppProgTM2 = ExpConWaiverService_Test.createOppProgTmMem2(oppProgId, user2.id);
            String MSTId = ExpConWaiverService_Test.createMaskSetTitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
                                    
            String notificationMsg = ExpConWaiverService.sendNotification(dev.Id, user1.Email, 'Standard User');
            //system.assertEquals(notificationMsg, 'OK');
            
            Test.stopTest();
        }                
    }
    
    static testMethod void sendNotificationTest3() {              
        User user1 = ExpConWaiverService_Test.createUser1('yy5');                
        
        system.runAs(user1){
           
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = ExpConWaiverService_Test.createContact(acctId);
            String oppId = ExpConWaiverService_Test.createOpp(acctId);
            String oppProgId = ExpConWaiverService_Test.createOppProg(acctId, oppId);
            
            Test.startTest();
            
            Opportunity_Program_Team_Member__c oppProgTM1 = ExpConWaiverService_Test.createOppProgTmMem3(oppProgId, user1.id);
            String MSTId = ExpConWaiverService_Test.createMaskSetTitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            
            String notificationMsg = ExpConWaiverService.sendNotification(dev.Id, user1.Email, 'Standard User');
            system.assertEquals(notificationMsg, 'Not Authorized');
            
            Test.stopTest();                   
        }                
    }
    
    static testMethod void sendNotificationTest4() {        
        User user1 = ExpConWaiverService_Test.createUser1('yy7');
        
        system.runAs(user1){                    
           
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = ExpConWaiverService_Test.createContact(acctId);
            String oppId = ExpConWaiverService_Test.createOpp(acctId);
            String oppProgId = ExpConWaiverService_Test.createOppProg(acctId, oppId);
            
            Test.startTest();
            
            Opportunity_Program_Team_Member__c oppProgTM1 = ExpConWaiverService_Test.createOppProgTmMem2(oppProgId, user1.id);
            String MSTId = ExpConWaiverService_Test.createMaskSetTitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
            Device__c dev = DeviceUtilTest.createCustomerMPWDevice3(acctId,oppId,oppProgId);
            
            String notificationMsg = ExpConWaiverService.sendNotification(dev.Id, user1.Email, 'System Administrator');
            //system.assertEquals(notificationMsg, 'ExpConSet');
            
            Test.stopTest();       
        }        
    }
    
    //test method for Internal Device
    static testMethod void testSendNotification5(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        //insert account;
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id, Email From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 1];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<3; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
       
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Account Administrator',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        
        insert atpList;        
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        System.runAs(userList[0]){
            Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                    '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
            if(!deviceRecTypeList.isEmpty()){                       
                device.RecordTypeId = deviceRecTypeList[0].Id;
            }
            device.Device_Mask_Set_Title__c ='MSTTRT';
            Device.reticle_type__c ='Single Layer Reticle (SLR)';
            insert device;
            Test.startTest();
                ExpConWaiverService.sendNotification(device.Id, userList[0].Email, 'GF FAE/FTS');
            Test.stopTest();
        }
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}