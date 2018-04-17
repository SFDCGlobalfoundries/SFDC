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
private Class FV_IPDKTriggerHelperTest{

   @testSetup static void testdata() {
   DataUtilTest.loadEnvironmentVariables();
      
      List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
                fieldValueMap.put('Name', 'TESTACC'+z);            
                fieldValueMap.put('stage__c', 'Unqualified');        
                fieldValueMap.put('sub_type__c', 'Direct');
                fieldValueMap.put('site_department__c', 'test dept');          
                fieldValueMap.put('transaction_type__c', 'transactional');                          
                fieldValueMap.put('region__c', 'APJ');        
                fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Corporate_City__c', 'Test City');                
                fieldValueMap.put('Corporate_Country__c', 'India');
                fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Bill_To_City__c', 'Test City');            
                fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
                fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMapsList.add(fieldValueMap);
        }
            
            AccountDataFactory.createAccounts(fieldValueMapsList,3);
       
     }


   static testMethod void FV_IPDKTriggerHelperTest(){
     User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         FederationIdentifier = '123456783',
         IsActive = true
	);
       
     insert u;
       
     User runningUser = [
                SELECT  Id
                FROM    User
                WHERE   Profile.Name = 'System Administrator'
                 AND IsActive = true
                 AND FederationIdentifier = '123456783'
                 LIMIT 1
            ];
            
        System.runAs(runningUser) {
            List<Account> testAccLst = new List<Account>();
            List<Account> gettingAccLst= getAccounts();
            for(Account accLs:gettingAccLst)
           	{
                 Account acc= new Account();
                 acc.id = accLs.id;
                 acc.Account_Present_In_OT__c= true;
                 acc.Short_Name__c = accLs.name;
                 testAccLst.add(acc);
            }
           update testAccLst;
            List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
            ID pdk = FV_PDKTestDataTest.getPdk();
            Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'Stepper Tooling Forms', 'Spec 1', pdk, 11111, '0.11UM');
            Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'IP Design Kit', 'Spec 2', pdk, 12121, '0.11UM');
            dSpec2.Is_Latest_Revision__c = false;
            listOfDSpec.add(dSpec1);
            listOfDSpec.add(dSpec2);
            insert listOfDSpec;
            
            IPDK_Constant__c ipConst1 = new IPDK_Constant__c(name='DoNotReplyEmail', value__c ='DoNotReplyEmail@gmail.com');
			insert ipConst1;
            
            //create custom setting data
            IPDK_BackEndRegionKit__c backEndObj = new IPDK_BackEndRegionKit__c(RegionName__c ='US',Federation_ID__c ='6207448', Name='US');
            insert backEndObj;
            //get DP record type id
            String docProDesignIPDKSpecRtype;
            if(Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type')<>NULL){
                docProDesignIPDKSpecRtype = Schema.SObjectType.Document_Provisioning__c.getRecordTypeInfosByName().get('IP DK Record Type').getRecordTypeId();
             }
            
            Test.startTest();
            List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[0].Id, testAccLst[1].Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
            document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[0].Id, testAccLst[0].Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
           
            dp1.RecordTypeId = docProDesignIPDKSpecRtype;
            dp1.BE_Justification__c = 'Test Justification';
            dp1.BE_Region__c = 'US';
            dp1.BE_Requestor__c =runningUser.id;
            dp1.Is_BE_Required__c = 'Yes';
            
			dp2.RecordTypeId = docProDesignIPDKSpecRtype;
            dp2.BE_Justification__c = 'Test Justification';
            dp2.BE_Region__c = 'US'; 
            dp2.BE_Requestor__c =runningUser.id;
            dp2.Is_BE_Required__c = 'Yes';
           
            dProLst.add(dp1); 
            dProLst.add(dp2);
            insert dProLst;
       
            List<IPDK_License_Information__c> lstipdk = new List<IPDK_License_Information__c>();
            IPDK_License_Information__c ipdk=new IPDK_License_Information__c();
            ipdk.account__c = testAccLst[0].Id;
   			ipdk.Specification__c = listOfDSpec[0].Id;
            lstipdk.add(ipdk);
            
            List<IPDK_License_Information__c> lstipdk1 = new List<IPDK_License_Information__c>();
            IPDK_License_Information__c ipdk1=new IPDK_License_Information__c();
            ipdk1.account__c = testAccLst[1].Id;
   			ipdk1.Specification__c = listOfDSpec[0].Id;
            lstipdk.add(ipdk1);
            
            insert lstipdk;
            List<IPDK_License_Information__c> lstIPLA=[Select id,
                                                         account__c,
                                                         Specification__c 
                                                         from IPDK_License_Information__c];
            
            FV_IPDKTriggerHelper.AATriggerEmailtoFAE(lstIPLA);
            checkRecursive.runOnceAgain();
            system.assert(!lstIPLA.isEmpty());
            
            test.stopTest();
        }
    }
   
    public static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account limit 3];   
        
        return accList;
    }
   

}