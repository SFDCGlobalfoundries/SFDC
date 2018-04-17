//Ashwini     05142015    - Updated code for refactoring of test class.
 
@isTest
private class DocumentProvisioningTriggerTest{
    @testSetup static void testdata() {
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
        fieldValueMap.put('Has_Valid_NDA__c',true);
        fieldValueMap.put('Tech_Geo_Granted__c','0.1UM;0.11UM;0.13UM;');
        fieldValueMap.put('Valid_Tech_Geos__c','0.1UM;0.11UM;0.13UM;');

        AccountDataFactory.createAccount(fieldValueMap);

    }
    static testMethod void documentProvisioningBeforeTest() {
        //DataUtilTest.loadEnvironmentVariables();
        Account acc = getAccount('MYTEST ACCOUNT1');
        Contact con = getContact(acc);
        
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
        
        Id pdkId = getPdk();
        Package__c pkg = getPackage(acc);
        
        List<Design_Spec__c> lstOfDSpecs = new List<Design_Spec__c>();
        
        Design_Spec__c dSpec1 = getDesignSpec('Release To White List','DRC','Spec1',pdkId,1111,'0.1UM');
        lstOfDSpecs.add(dSpec1);
        Design_Spec__c dSpec2 = getDesignSpec('Specific Account Release','DRC1','Spec2',pdkId,2222,'0.1UM');
        lstOfDSpecs.add(dSpec2);
        Design_Spec__c dSpec3 = getDesignSpec('Specific Account Release with Spec owner Approval','White Papers','Spec3',pdkId,3333,'0.1UM');
        lstOfDSpecs.add(dSpec3);
        Design_Spec__c dSpec4 = getDesignSpec('Specific Account Release with Spec owner Approval','White Papers1','Spec4',pdkId,4444,null);  
        lstOfDSpecs.add(dSpec4);
        Design_Spec__c dSpec5 = getDesignSpec('Specific Account Release','DRC3','Spec5',pdkId,5555,'0.1UM');
        lstOfDSpecs.add(dSpec5);
        
        if (lstOfDSpecs<>Null && !lstOfDSpecs.isEmpty()){
            insert lstOfDSpecs;
        }
        
        
        //Sub_PDK__c subPdk = getSubPdk('pdk1','Specific Account Release',pdkId,'Bundle1');
        //Sub_PDK__c subPdk2 = getSubPdk('pdk2','Specific Account Release',pdkId,'Bundle2');
     
        
        List<document_provisioning__c> lstOfDocumentProvisioning = new List<document_provisioning__c>();
        List<document_provisioning__c> lstOfDpToUpdate = new List<document_provisioning__c>();
        
        //for (Design_Spec__c dSpecs : lstOfDSpecs){
        lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(pkg.Id,null,null,acc.Id,portalUser.Id,'Sent For Approval'));
      //  lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(null,subPdk.Id,null,acc.Id,portalUser.Id,'Provisioned'));
        lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(null,null,lstOfDSpecs[2].Id,acc.Id,portalUser.Id,'De-Provisioned'));
        lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(pkg.Id,null,lstOfDSpecs[3].Id,acc.Id,portalUser.Id,'Sent For Approval'));
       
        lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(null,null,lstOfDSpecs[4].Id,acc.Id,portalUser.Id,'Provisioned'));
       // lstOfDocumentProvisioning.add(getDocumentProvisioningRecords(null,subPdk2.Id,null,acc.Id,portalUser.Id,'De-Provisioned'));
        
        
        IPDK_License_Information__c ipdkObj=new IPDK_License_Information__c ();
        ipdkObj.Specification__c=lstOfDSpecs[4].Id;
        ipdkObj.Account__c=acc.id;
        insert ipdkObj;
        //}
         Test.startTest();
            if (lstOfDocumentProvisioning<>Null && !lstOfDocumentProvisioning.isEmpty()){
                insert lstOfDocumentProvisioning;
            }
            //DesignSpecTriggerHandler.isAfterExecuted = true;
            
            for (document_provisioning__c dProvisioning : lstOfDocumentProvisioning){
                document_provisioning__c dp = new document_provisioning__c();
                dp.Id = dProvisioning.Id;
                dp.status__c = 'Provisioned';
                //dp.design_package__c = pkg.Id;
                lstOfDpToUpdate.add(dp);
            } 
           
                DesignSpecTriggerHandler.isBeforeExecuted=false;
                
                if (lstOfDpToUpdate<>Null && !lstOfDpToUpdate.isEmpty()){
                    update lstOfDpToUpdate;
                }
                //DesignSpecTriggerHandler.isBeforeExecuted=true;
        Test.stopTest();         
    }
    
    static testMethod void documentProvisioningForPackageTest() {
        
    }
    
    public static void prepareTestData(){
        
    }
    
    public static Package__c getPackage(Account accntObj){
        
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';   
        objPck.Accounts_Provisioned_To__c = accntObj.Name;
        objPck.Tech_Geometry__c='0.11UM;0.13UM;';                                  
        insert objPck;
        
        return objPck;
    }
    
    // Prepare designSpec
    public static Design_Spec__c getDesignSpec(String rStatus,String sType,String name,Id pdkID,Integer otId,String techGeo){
        
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
        
        //insert objDesignSpec;
         
        return objDesignSpec;
    }
        
    // Prepare Contact
    public static Contact getContact(Account accID){
        
        Contact contact = new Contact(FirstName='Con1',
                                    LastName='Testcon1',
                                    AccountId=accID.Id,
                                    Email='con1@gf.com',
                                    Department__c='Design');
        insert contact;
        return contact;                         
    }
    
    //prepare  Master PDK
    public static Id getPdk(){
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = '';
        objPDK.Tech_Geometry__c ='0.11UM;0.13UM;'; 
        insert objPDK;
        
        return objPDK.id;
    }
    
    // Prepare SubPDK
  /*  public static Sub_PDK__c getSubPdk(String name, String rStatus,Id mPdkId,String bName){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = name;
        objSubPDK.Release_Status__c = rStatus;
        objSubPDK.PDK__c = mPdkId;
        objSubPDK.Bundle_Name__c = bName+system.Now();
        //objSubPDK.tech_geometry__c = objPDK.Tech_Geometry__c;                             
        insert objSubPDK;
        
        return objSubPDK;
    }*/
    
    // Prepare Document Provisioning Records
    private static document_provisioning__c getDocumentProvisioningRecords(Id pkgId,Id pdkId,Id designSpecId,Id AccId,Id userId,String status){
        
        document_provisioning__c dProvObj = new document_provisioning__c(sub_pdk__c = pdkId,
                                                                         status__c=status,
                                                                         Design_Spec__c=designSpecId,
                                                                         User__c =userId,
                                                                         NDA_Coverage__c=true,
                                                                         Tech_Geo_Granted_to_Account__c=true,
                                                                         design_package__c = pkgId);
        return dProvObj;   
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}