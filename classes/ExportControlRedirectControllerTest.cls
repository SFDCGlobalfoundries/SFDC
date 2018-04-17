/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a ExportControlRedirectControllerTest class.
 *             
 * History:
 * <Vijay>     04022015 - Test class created
 * 
 */
@isTest
private class ExportControlRedirectControllerTest {

     @testSetup static void setupData() { 
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        DataUtilTest.loadEnvironmentVariables();

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        update account;
        System.debug('account====='+account);
        
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        Device.Device_Mask_Set_Title__c ='VMSTV';
        Device.Enabled_via_previous_MPW_1__c ='No';
        Device.Reticle_Type__c ='Multi Layer Reticle (MLR)';
        insert device;
    }
    
    //positive test method
    static testMethod void testRedirect1(){
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account1' Limit 1];
        Device__c device = [SELECT Id FROM Device__c WHERE Name = 'TestInternalDevice' Limit 1];
        ApexPages.currentPage().getParameters().put('accountid', account.Id);
        ApexPages.currentPage().getParameters().put('deviceid', device.Id);
        ExportControlRedirectController exportControlRedirectCntrl = new ExportControlRedirectController();
        Test.startTest();
            PageReference pageRef = exportControlRedirectCntrl.redirect();
        Test.stopTest();
        System.assertEquals(device.id, pageRef.getParameters().get('deviceid'));
    }
    
    //negative test method1
    static testMethod void testRedirect2(){
        ExportControlRedirectController exportControlRedirectCntrl = new ExportControlRedirectController();
        Test.startTest();
            PageReference pageRef = exportControlRedirectCntrl.redirect();
        Test.stopTest();
        System.assertEquals(null, null);
    }
    
    //negative test method2
    static testMethod void testRedirect3(){
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account1' Limit 1];
        Device__c device = [SELECT Id FROM Device__c WHERE Name = 'TestInternalDevice' Limit 1];
        ApexPages.currentPage().getParameters().put('deviceid', account.Id);
        ApexPages.currentPage().getParameters().put('accountid', device.Id);
        ExportControlRedirectController exportControlRedirectCntrl = new ExportControlRedirectController();
        Test.startTest();
            PageReference pageRef = exportControlRedirectCntrl.redirect();
        Test.stopTest();
        System.assertEquals(null, null);
    }
    
}