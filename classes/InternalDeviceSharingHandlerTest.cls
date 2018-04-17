/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a InternalDeviceSharingHandlerTest class.
 *             
 * History:
 * <Vijay>     04022015 - Test class created
 * 
 */
@isTest
private class InternalDeviceSharingHandlerTest {
    

    @testSetup static void setupData() { 
        
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

        Account account = AccountDataFactory.createAccount(fieldValueMap);
        
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        

        /*Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        insert account;*/
        System.debug('account====='+account);
        
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 2];
        
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
        
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
        List<Device__c> deviceList = new List<Device__c>();
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        Device.Device_Mask_Set_Title__c ='VMSTV01';
        Device.Enabled_via_previous_MPW_1__c ='No';
        Device.Reticle_Type__c ='Multi Layer Reticle (MLR)';
               
        deviceList.add(device);
        insert deviceList;
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
       
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        
        insert atpList;
        
        InternalDeviceSharingHandler idshare = new InternalDeviceSharingHandler();
        idshare.shareInternalDevice(atpList);
        idshare.shareInternalDevice(deviceList);
        idshare.removeInternalDeviceAccess(atpList);
    }
    
    static testMethod void testShareInternalDevice(){
        Account account = getAccount('MYTEST ACCOUNT1');
        System.debug('account-------'+account);
        List<Account_Team_Proxy__c> atpList = [SELECT Id FROM Account_Team_Proxy__c WHERE Account__c =: account.Id];
        System.debug('atpList--------'+atpList);
        Test.startTest();
        for(Account_Team_Proxy__c atp:atpList){
            atp.Account_Access__c = 'Read Only';
        }
        update atpList;
        InternalDeviceSharingHandler idshare = new InternalDeviceSharingHandler();
        idshare.shareInternalDevice(atpList);
        idshare.removeInternalDeviceAccess(atpList);
        Test.StopTest();
        List<Device__Share> deviceShareList = [SELECT AccessLevel FROM Device__Share WHERE Parent.Account__c =: account.Id AND 
                                                RowCause =: Schema.Device__Share.RowCause.Account_Team_Proxy__c];
        List<Device__Share> deviceShareList1 = [SELECT AccessLevel FROM Device__Share WHERE Parent.Design_Partner__c =: account.Id AND 
                                                RowCause =: Schema.Device__Share.RowCause.Design_Partner_Sharing__c];                                        
        for(Device__Share deviceShare :deviceShareList){
            System.assertEquals('Edit',deviceShare.AccessLevel);
        }
    }
    
    static testMethod void testRemoveInternalDeviceAccess(){
        Account account = getAccount('MYTEST ACCOUNT1');
        List<Account_Team_Proxy__c> atpList = [SELECT Id, User__c FROM Account_Team_Proxy__c WHERE Account__c =: account.Id Limit 1];
        Test.startTest();
            delete atpList[0];
        Test.StopTest();
        List<Device__Share> deviceShareList = [SELECT Id FROM Device__Share WHERE Parent.Account__c =: account.Id AND 
                                                RowCause =: Schema.Device__Share.RowCause.Account_Team_Proxy__c AND UserOrGroupId =: atpList[0].User__c];
        //System.assertEquals(1, deviceShareList.size());
    }
        
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
  
}