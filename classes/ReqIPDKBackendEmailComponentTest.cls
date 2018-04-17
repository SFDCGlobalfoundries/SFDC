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
private class ReqIPDKBackendEmailComponentTest {
	
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
    
    private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account limit 3];   
        
        return accList;
    }
    
    static testMethod void regionJustificationTest(){
        User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
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
            document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, dSpec1.Id, testAccLst[0].Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
            
            dp1.RecordTypeId = docProDesignIPDKSpecRtype;
            dp1.BE_Justification__c = 'Test Justification';
            dp1.BE_Region__c = 'US';
            dp1.BE_Requestor__c =runningUser.id;
            
			dp2.RecordTypeId = docProDesignIPDKSpecRtype;
            dp2.BE_Justification__c = 'Test Justification';
            dp2.BE_Region__c = 'US'; 
            dp2.BE_Requestor__c =runningUser.id;
            
            dProLst.add(dp1); 
            dProLst.add(dp2);
            
            insert dProLst;
            ApexPages.currentPage().getParameters().put('Id',dSpec1.id); 
            ReqIPDKBackendEmailComponent ipdkController = new ReqIPDKBackendEmailComponent();
            ipdkController.desSpId = dSpec1.id;
            String region =ipdkController.region;
            system.assertEquals('US', region);
            system.assertEquals('Test Justification', ipdkController.justification);
            
            
            //test IPDK_AACreationController
            IPDK_AACreationController aaController = new IPDK_AACreationController();
            aaController.accessipdkspecId = dSpec2.id;
			aaController.accessipdkId = docProDesignIPDKSpecRtype;
            aaController.accessipdkaccid  = testAccLst[1].Id; 
            system.assert(aaController.requestor !=null);
               
            Test.stopTest();    
            }
          
    }

}