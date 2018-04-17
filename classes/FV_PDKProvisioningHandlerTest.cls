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
private class FV_PDKProvisioningHandlerTest {

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
        
   
   
    static testMethod void FV_PDKProvisioningHandlerTest() {
      
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
       
       List<Account> gettingAccLst= getAccounts(); // fetching test account data
       List<Account> testAccLst = new List<Account>();
       for(Account accLs:gettingAccLst)
       {
         Account acc= new Account();
         acc.id = accLs.id;
         acc.Short_Name__c = accLs.name;
         testAccLst.add(acc);
       }
       update testAccLst;
                
        listOfAcc1.add(testAccLst[0]);
        //insert listOfAcc1;
        List<Id> listOfAccIds = new List<Id>();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
       
   
        listOfAcc.add(testAccLst[1]);
        listOfAccIds.add(testAccLst[1].id);
       Test.startTest();
        ID pdk = FV_PDKTestDataTest.getPdk();
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
       
        Sub_PDK__c sPdk2 = FV_PDKTestDataTest.getSubPdk('PDK Test 2','Release To white list', pdk, 'Demo B1 T1');
        sPdk2.Time_Req_To_Create_Association_In_OT__c ='Test';
       // sPdk2.Ready_For_Provisioning__c = false;
       // sPdk2.PDK_Failure_Specs__c = null;
        update sPdk2;
        
        Sub_PDK__c sPdk3 = FV_PDKTestDataTest.getSubPdk('PDK Test 3','Release To white list', pdk, 'Demo B1 T2');
        sPdk3.OpenText_Error_Message__c='Error';
      //  sPdk3.Ready_For_Provisioning__c = false;
        update sPdk3;
        
        Sub_PDK__c sPdk4 = FV_PDKTestDataTest.getSubPdk('PDK Test 2','Release To white list', pdk, 'Demo B1 T3');
        sPdk4.Time_Req_To_Create_Association_In_OT__c='0';
        sPdk4.Ready_For_Provisioning__c = false;
        sPdk4.PDK_Failure_Specs__c = 'Testing 123';
        update sPdk4;
        
        Sub_PDK__c sPdk5 = FV_PDKTestDataTest.getSubPdk('PDK Test 2','Release To white list', pdk, 'Demo B1 T4');
        sPdk5.Time_Req_To_Create_Association_In_OT__c='0';
        sPdk5.Ready_For_Provisioning__c = true;
        //sPdk5.PDK_Failure_Specs__c = 'Testing 123';
        update sPdk5;
        
        PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(pdk);
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        listOfDSpec.add(dSpec3);
        insert listOfDSpec;
        //White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
        White_List__c wl = new White_List__c();
        wl.Account__c = testAccLst[1].id;
        //wl.Design_Spec__c = dSpec;
        wl.Sub_PDK__c = sPdk.Id;
        insert wl;
        
        White_List__c wl2 = new White_List__c();
        wl2.Account__c = testAccLst[1].id;
        wl2.Design_Spec__c = dSpec2.id;
        insert wl2;
        
        List<Sub_PDK_Spec__c> listOfSPdkSpecs = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c sps1 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[0].Id,'5555');
        Sub_PDK_Spec__c sps2 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[1].Id,'11');
        listOfSPdkSpecs.add(sps1);
        listOfSPdkSpecs.add(sps2);
        
        insert listOfSPdkSpecs;
        
        
            Package__c objPkg = FV_PDKTestDataTest.getPackage(testAccLst[1]);
            List<document_provisioning__c> dProLst = new List<document_provisioning__c>();
            document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[0].Id, testAccLst[1].id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
            document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, testAccLst[0].id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
            document_provisioning__c dp3 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, testAccLst[1].id,Id.valueOf(UserInfo.getUserId()),'Sent For Approval');
            document_provisioning__c dp4 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, testAccLst[1].id,Id.valueOf(UserInfo.getUserId()),'Rejected');
            document_provisioning__c dp5 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, listOfDSpec[1].Id, testAccLst[0].id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
           
            dProLst.add(dp1); 
            dProLst.add(dp2);
            dProLst.add(dp3);
            dProLst.add(dp4);
            dProLst.add(dp5);
           
            insert dProLst;
           
            ApexPages.currentPage().getParameters().put('Id',sPdk.id); 
            FV_PDKProvisioningHandler controller = new FV_PDKProvisioningHandler(new ApexPages.StandardController(sPdk));
           
           //For Covering If conditions
            FV_PDKProvisioningHandler controller1 = new FV_PDKProvisioningHandler(new ApexPages.StandardController(sPdk2));
            FV_PDKProvisioningHandler controller2 = new FV_PDKProvisioningHandler(new ApexPages.StandardController(sPdk3));
            FV_PDKProvisioningHandler controller3 = new FV_PDKProvisioningHandler(new ApexPages.StandardController(sPdk4));
            FV_PDKProvisioningHandler controller4 = new FV_PDKProvisioningHandler(new ApexPages.StandardController(sPdk5));
           
            FV_PDKProvisioningHandler.AccountWapper accWrapper = new FV_PDKProvisioningHandler.AccountWapper();
            
            accWrapper.selected = true;
            accWrapper.isAlreadyProvisioned=false;
            accWrapper.acct = testAccLst[1];
            List<FV_PDKProvisioningHandler.AccountWapper> sResult = new List<FV_PDKProvisioningHandler.AccountWapper>();
            sResult.add(accWrapper);
            controller.searchResult = sResult;
            controller.doProvision();
            PDK__c objPDK = new PDK__c();
            objPDK.Name = 'Test1';
            objPDK.OpenText_ID__c = 342111;
            objPDK.Description__c = 'TestDescription';
            objPDK.Old_Revision_ID__c = 34212; 
            objPDK.PDK_DocTitle__c = '';
            objPDK.Tech_Geometry__c ='0.25UM'; 
            objPDK.PDK_Lifecycle_Phase__c='Obsolete';
            insert objPDK;
            //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', objPDK1, 'Demo B1');
            controller.verifyValidTechGeometry('0.25UM');
            controller.showOrHideAddAccounts('Internal Use Only');
            controller.verifyNonObsoleteMasterPDK(objPDK.Id);
            controller.showOrHideAddAccounts('Specific Account Release');
            controller.verifyValidTechGeometry(null);
            controller.searchText=null;
            controller.searchAccount();
            
            
            controller.isAccSelected();
            controller.searchText='acc1';
            controller.searchAccount();
            controller.searchText='new';
            controller.searchAccount();
            controller.doProvision();
            controller.getAlreadyProvisionedAccounts();
            FV_PDKProvisioningHandler.updateDeProvisionedDp(listOfAcc,sPdk.Id);
            //listOfAcc=null;
            FV_PDKProvisioningHandler.updateDeProvisionedDp(listOfAcc1,sPdk.Id);
            Set<Id> setOfPdkIds = new Set<Id>();
            setOfPdkIds.add(sPdk.Id);
            FV_PDKProvisioningHandler.updateDeProvisionedDpforNDAactivate(listOfAcc1,setOfPdkIds);
            controller.back();
            
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