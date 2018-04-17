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
private class FV_SpecProvisioningHandlerTest {


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


    static testMethod void FV_SpecProvisioningHandlerTest() {
     
      User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
      System.runAs(runningUser) {
    
       List<Account> listOfAcc = new List<Account>();
       List<Account> listOfAcc1 = new List<Account>();
       
       List<Account> gettingAccLst= getAccounts();
      
       List<Account> testAccLst = new List<Account>();
       for(Account accLs:gettingAccLst)
       {
         Account acc= new Account();
         acc.id = accLs.id;
         acc.Account_Present_In_OT__c= true;
         acc.Short_Name__c = accLs.name;
         testAccLst.add(acc);
       }
       update testAccLst;
       
        system.debug('>>'+testAccLst);
        listOfAcc1.add(testAccLst[0]);

        List<Id> listOfAccIds = new List<Id>();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       
        
         
        listOfAcc.add(testAccLst[1]);
        listOfAccIds.add(testAccLst[1].Id);
       
        ID pdk = FV_PDKTestDataTest.getPdk();
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
        //PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(pdk);
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'Stepper Tooling Forms', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'IP Design Kit', 'Spec 2', pdk, 12121, '0.11UM');
        dSpec2.Is_Latest_Revision__c = false;
        //Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        //listOfDSpec.add(dSpec3);
        insert listOfDSpec;
        //White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
        White_List__c wl = new White_List__c();
        wl.Account__c = testAccLst[1].Id;
        wl.Design_Spec__c = dSpec2.id;
        //wl.Sub_PDK__c = sPdk.Id;
        insert wl;
          
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
            document_provisioning__c dp3 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[1].Id, testAccLst[1].Id,Id.valueOf(UserInfo.getUserId()),'Sent For Approval');
            document_provisioning__c dp4 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, dSpec1.Id, testAccLst[1].Id,Id.valueOf(UserInfo.getUserId()),'Rejected');
            document_provisioning__c dp5 = FV_PDKTestDataTest.getDocumentProvisioningRecords(null,null, listOfDSpec[1].Id, testAccLst[0].Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
            
            dp5.RecordTypeId = docProDesignIPDKSpecRtype;
           
            dProLst.add(dp1); 
            dProLst.add(dp2);
            dProLst.add(dp3);
            dProLst.add(dp4);
            dProLst.add(dp5);
           
            insert dProLst;
           
            ApexPages.currentPage().getParameters().put('Id',dSpec1.id); 
            FV_SpecProvisioningHandler.updateDeProvisionedDp(listOfAcc,dSpec1.Id);
            FV_SpecProvisioningHandler controller = new FV_SpecProvisioningHandler(new ApexPages.StandardController(dSpec1));
            FV_SpecProvisioningHandler controller1 = new FV_SpecProvisioningHandler(new ApexPages.StandardController(dSpec2));
            FV_SpecProvisioningHandler.AccountWapper accWrapper = new FV_SpecProvisioningHandler.AccountWapper();
            
            accWrapper.selected = true;
            accWrapper.isAlreadyProvisioned=false;
            accWrapper.acct = testAccLst[1];
            List<FV_SpecProvisioningHandler.AccountWapper> sResult = new List<FV_SpecProvisioningHandler.AccountWapper>();
            sResult.add(accWrapper);
            controller.searchResult = sResult;
            controller.doProvision();
            
            controller.verifyValidTechGeometry('0.25UM');
            controller.showOrHideAddAccounts('Internal Use Only');
            controller.showOrHideAddAccounts('Specific Account Release');
            controller.verifyValidTechGeometry(null);
            controller.searchString=null;
            controller.searchAccount();
            
            
            controller.isAccSelected();
            controller.searchString='acc1';
            controller.searchAccount();
            controller.searchString='new';
            controller.searchAccount();
          	
            //Setup data for email notifcation
            //public List<SelectOption> isbackendkitOptions{get;set;}

            controller.isbackendkitOptions = controller.isbackendlist;
            controller.region = 'US';
            controller.isbackendkit = 'None';
            controller.hideRegionJustification();
            controller.isbackendkit = 'Yes';
            List<SelectOption> regions = controller.allRegion;
            
            controller.doProvision();
            controller.sendEmailToRegionUsers(controller.mapRegHCMIds, dSpec2.id);
            //controller.getAlreadyProvisionedAccounts();
          //  FV_SpecProvisioningHandler.updateDeProvisionedDp(listOfAcc,dSpec1.Id);
            FV_SpecProvisioningHandler.updateDeProvisionedDp(listOfAcc1,dSpec2.Id);
            //controller.back();
           system.assert(controller.mapRegHCMIds !=null);
           system.assert(!regions.isEmpty());
       Test.stopTest();      
        }
    }
     private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account limit 3];   
        
        return accList;
    }
}