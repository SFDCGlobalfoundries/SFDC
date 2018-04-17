/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a DeviceTriggerHandlerTest class.
 *             
 * History:
 * <Vijay>     04012015 - Test class created
 * 
 */
@isTest
private class DeviceTriggerHandlerTest {
    
    static Account account;
    static List<User> userList;
    

    static void setupData(){
         
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        DataUtilTest.loadEnvironmentVariables();


         account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
        /*                                
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        insert account;
        */
        System.debug('account====='+account);
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 2];
        
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
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        
        insert atpList;
        
    }
    /* public static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = processGeometry; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
    }
    
    public static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }*/
    testMethod static void testOnAfterInsert(){
        //DataUtilTest.LoadDeviceEnvVariable();
        setupData();
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        System.debug('recordTypeList====='+recordTypeList);
        System.debug('account====='+account);
        Test.startTest();
        /*Device__c device = new Device__c(Name = 'TestInternalDevice', Fab__c = 'Fab 2', Stage__c = 'Design In', Status__c = 'Active', 
                                                Confidence_Level_Tapeout__c = '100',Original_Forecasted_Tapeout_Date__c = System.today(), 
                                                Siebel_Device_ID__c = '1234567890',Tapeout_Type__c = 'Customer MPW', Account__c = account.Id, 
                                                Internal_Device_Geometry__c = '0.028UM',Internal_Device_Process_Family__c = 'Super Low Power');
        
        */
        String processgeopmetry='0.028UM' ;  
        Id opptyid=DeviceUtilTest.createOpp(account.Id,processgeopmetry);
        Id opptyprogrmid = DeviceUtilTest.createOppProg(account.Id,opptyid);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(account.Id,MSTId);
        Device__c device=DeviceUtilTest.createCustomerMPWDevice4 (account.Id ,opptyprogrmid  );                                    
        if(!recordTypeList.isEmpty()){                      
            device.RecordTypeId = recordTypeList[0].Id;
        }
        insert device;
        Test.stopTest();
        List<Device__Share> deviceShareList = [SELECT Id FROM Device__Share WHERE ParentId = :Device.Id AND UserOrGroupId =: userList];
        System.debug('---------'+deviceShareList);
        //System.assert(!deviceShareList.isEmpty());
    }
    
    static testMethod void testRun1(){
        
        setupData();
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        Test.startTest();
        
        String processgeopmetry='0.028UM' ;  
        Id opptyid = DeviceUtilTest.createOpp(account.Id,processgeopmetry);
        
        Id opptyprogrmid = DeviceUtilTest.createOppProg(account.Id,opptyid);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(account.Id,MSTId);
        
        Device__c device = DeviceUtilTest.createCustomerMPWDevice4 (account.Id ,opptyprogrmid  );  
        device.Product_Line__c = null;
        device.Business_Unit__c = null;
        device.Opportunity2__c = opptyid;
        if(!recordTypeList.isEmpty()){                      
            device.RecordTypeId = recordTypeList[0].Id;
        }
        insert device;
        
        Opportunity oppObj = new Opportunity(Id = opptyid);
        oppObj.Product_Line__c = 'ASIC';
        oppObj.Business_Unit__c = 'RF';
        update oppObj;
        
        Test.stopTest();
    }
    
    static testMethod void testRun2(){
        
        setupData();
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        Test.startTest();
        
        String processgeopmetry='0.028UM' ;  
        Id opptyid = DeviceUtilTest.createOpp(account.Id,processgeopmetry);
        Opportunity oppObj = new Opportunity(Id = opptyid);
        oppObj.Product_Line__c = 'ASIC';
        oppObj.Business_Unit__c = 'RF';
        update oppObj;
        
        Id opptyprogrmid = DeviceUtilTest.createOppProg(account.Id,opptyid);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(account.Id,MSTId);
        
        Device__c device = DeviceUtilTest.createCustomerMPWDevice4 (account.Id ,opptyprogrmid  );  
        device.Product_Line__c = null;
        device.Business_Unit__c = null;
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
		device.Device_Purpose__c = 'Customer Test Chip';
        device.Project_Name__c = 'test';
        device.Opportunity2__c = opptyid;
        if(!recordTypeList.isEmpty()){                      
            device.RecordTypeId = recordTypeList[0].Id;
        }
        insert device;
        
        Test.stopTest();
    }
}