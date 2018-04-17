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
private class FV_PDKProvisioningRetriggerBatchClsTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                          
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Austria');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Austria');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Has_Valid_NDA__c',true);
        fieldValueMap.put('Tech_Geo_Granted__c','0.11UM;0.13UM;');
        fieldValueMap.put('Valid_Tech_Geos__c','0.11UM; 0.13UM;');

        AccountDataFactory.createAccount(fieldValueMap);    
    }
    
    static testMethod void pdkProvisioningTest() {
       
        // Create Account 
        Id accId = getAccount('MYTEST ACCOUNT1').id;
        Contact con = getContact(accId);
        
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser;
        
        System.runAs(admUser){
            portalUser = new User( ProfileId = profile1.Id,
                                    Username = 'portaluser@testorg.com',
                                    Alias = 'auser',
                                    Email='portaluser@testorg.com',
                                    EmailEncodingKey='UTF-8',
                                    Firstname='Bruce',
                                    Lastname='Wayne',
                                    LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US',
                                    TimeZoneSidKey='America/Chicago',
                                    ContactId=con.id,
                                    Portal_Login__c='abc12');
            insert portalUser;                                        
        }
       // Create sub pdk
        Id pdkId = getPdk();
        Id subPdkId = getSubPdk('pdk1','Specific Account Release',pdkId,'Bundle1');
        List<Design_Spec__c> listOfDesignSpec = new List<Design_Spec__c>();
        for(Integer i=0; i<200;i++){
            listOfDesignSpec.add(getDesignSpecs('Specific Account Release','DRC1','Spec'+i,pdkId,i,'0.11UM'));
        }
        listOfDesignSpec.add(getDesignSpecs('Specific Account Release','White Papers','Spec202',pdkId,202,'0.11UM'));
        listOfDesignSpec.add(getDesignSpecs('Specific Account Release','White Papers','Spec203',pdkId,203,null));
        
        if (listOfDesignSpec<>Null && !listOfDesignSpec.isEmpty()){
            insert listOfDesignSpec;
        }
        //Design_Spec__c dSpec2 = getDesignSpec('Specific Account Release','DRC1','Spec2',pdkId,2222,'0.11UM');
        
        // Create Document provisioning record
        List<document_provisioning__c> docProvisioningList = new List<document_provisioning__c>(); 
        /*for(Integer i = 0 ; i < 300; i++){
            docProvisioningList.add(getDocumentProvisioningRecords(subPdkId,null,portalUser.Id));
        }*/
        
        for (Design_Spec__c dSpecs : listOfDesignSpec){
            docProvisioningList.add(getDocumentProvisioningRecords(subPdkId,dSpecs.Id,portalUser.Id));
        }
        docProvisioningList.add(getDocumentProvisioningRecords(subPdkId,null,portalUser.Id));
        
        FV_PDKProvisioningRetriggerBatchCls dProvisioning = new FV_PDKProvisioningRetriggerBatchCls();
        
        Test.startTest();
            if (docProvisioningList<>Null && !docProvisioningList.isEmpty()){
                insert docProvisioningList;
            }
            Database.executeBatch(dProvisioning,500);
        Test.stopTest();    
    }
    
    private static Account getAccount(String AccountName){
        
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    private static Design_Spec__c getDesignSpecs(String rStatus,String sType,String name,Id pdkID,Integer otId,String techGeo){
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
              
        objDesignSpec.OpenText_ID__c =otId;
        objDesignSpec.Name =name+system.now();
        objDesignSpec.Document_Title__c = 'Test Title'+system.now();
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum'+system.now();       
        objDesignSpec.Revision__c = 'test rev'+system.now();
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c= 'intel;is';
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c =sType;// 'DRC';White Papers
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c =techGeo;
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = rStatus;
        objDesignSpec.pdk__c = pdkID;   
        
        return objDesignSpec;
    }
    
    private static Id getPdk(){
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'PDK Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = ''; 
        objPDK.Tech_Geometry__c='0.11UM';
        insert objPDK;
        return objPDK.id;
    } 
    
     // Prepare SubPDK
    public static Id getSubPdk(String name, String rStatus,Id mPdkId,String bName){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = name;
        objSubPDK.Release_Status__c = rStatus;
        objSubPDK.PDK__c = mPdkId;
        objSubPDK.Bundle_Name__c = bName+system.Now();
        //objSubPDK.tech_geometry__c = '0.11UM;0.13UM;';                             
        insert objSubPDK;
        
        return objSubPDK.Id;
    }
    
    private static document_provisioning__c getDocumentProvisioningRecords(Id pdkId,Id specId, Id userId){
        
        document_provisioning__c dProvObj = new document_provisioning__c(sub_pdk__c = pdkId,
                                                                         status__c='Provisioned',
                                                                         NDA_Coverage__c = false,
                                                                         Final_User_Access__c=false,
                                                                        Tech_Geo_Granted_to_Account__c=false,
                                                                        Design_Spec__c=specId,
                                                                        User__c = userId);
                                                                         
        return dProvObj;   
    }
    
    // Prepare Contact
    private static Contact getContact(Id accID){
        
        Contact contact = new Contact(FirstName='Con1',
                                    LastName='Testcon1',
                                    AccountId=accID,
                                    Email='con1@gf.com',
                                    Department__c='Design');
        insert contact;
        return contact;                         
    }
    
    
    
}