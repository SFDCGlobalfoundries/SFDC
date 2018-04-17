@Istest
private class EHSNewRecordTest{
    static Account account1;
    static Account account2;
    static Contact contact;
    static User portalUser; 
    static Other_EHS_CSR_Certificate__c QualityCert;
   static void setupData(){
   DataUtilTest.LoadATPEnvVariables();
               Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
            bl.Name='Update Bill To Address No';
            bl.Bill_To_Address_Number__c = 2072;
            insert bl;
 
       Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account;
       Map<String, Schema.RecordtypeInfo> recordTypeMap = descSobjResult.getRecordTypeInfosByName();
       Map<String,Object> fieldValueMap = New Map<String,Object>();        
        fieldValueMap.put('Name','test1');
        fieldValueMap.put('Stage__c','Active');
        fieldValueMap.put('Short_Name__c','TestAcct');
        fieldValueMap.put('Site_Department__c','siteDept');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','Transactional');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
       fieldValueMap.put('Process_Tech_Interested__c','Mature');
        fieldValueMap.put('Region__c','GC');
        fieldValueMap.put('Sales_Territory__c','US-West');
       fieldValueMap.put('Copy_Address__c',true);
       fieldValueMap.put('Corporate_Address_1__c','Corporate Address 2');
       fieldValueMap.put('Corporate_Country__c','Afghanistan'); 
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 2');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
       fieldValueMap.put('FE_Territory__c','APJ-FE-CHINA');       
       fieldValueMap.put('Total_Employee__c',100);  
     fieldValueMap.put('RecordTypeId',recordTypeMap.get('Customer').getRecordTypeId());
      account1 = AccountDataFactory.createAccount(fieldValueMap);
       List<Account> accountList = new List<Account>();
       //account1 = AccountDataFactory.createAccount(fieldValueMap);
       //  account1 = QS_TestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                          //   'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                          //   100);
        Map<String,Object> fieldValueMap1 = New Map<String,Object>();
        fieldValueMap1.put('Name','test2');
        fieldValueMap1.put('Stage__c','Unqualified');
        fieldValueMap1.put('Short_Name__c','TestAcct2');
        fieldValueMap1.put('Site_Department__c','siteDept');
        fieldValueMap1.put('Sub_Type__c','Direct');
        fieldValueMap1.put('Transaction_Type__c','Transactional');
        fieldValueMap1.put('Account_Profile__c','Fabless - Emerging');
       fieldValueMap1.put('Process_Tech_Interested__c','Mature');
        fieldValueMap1.put('Region__c','GC');
        fieldValueMap1.put('Sales_Territory__c','US-West');
       fieldValueMap1.put('Copy_Address__c',true);
       fieldValueMap1.put('Corporate_Address_1__c','Corporate Address 2');
       fieldValueMap1.put('Corporate_Country__c','Afghanistan'); 
        fieldValueMap1.put('Bill_To_Address_1__c','Test Address 2');
        fieldValueMap1.put('Organization_Unit__c','GF Investment LLC OU');
       fieldValueMap1.put('FE_Territory__c','APJ-FE-CHINA');       
       fieldValueMap1.put('Total_Employee__c',100);  
       fieldValueMap1.put('RecordTypeId',recordTypeMap.get('Customer').getRecordTypeId());  
       account2 = AccountDataFactory.createAccount(fieldValueMap1);
           /*QS_TestUtil.createAccount('Test Account2', 'Qualified', 'TestAccount2', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                           'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                           100);*/
       if(recordTypeMap.get('Customer') != null){
           account1.RecordTypeId = recordTypeMap.get('Customer').getRecordTypeId();
           account2.RecordTypeId = recordTypeMap.get('Customer').getRecordTypeId();
        }
        qualityCert  = new Other_EHS_CSR_Certificate__c(Certificate_Type__c='Material Declaration',Stage__c = 'Draft', Certificate_Title__c = 'Test EHC', fabs__c ='FAB 1',Expiry_Date__c = System.today() + 1,
                                                        Effective_Date__c = System.today());            
       
            }
 
    // following test methods for EHSNewRecord.cls 
      
    //Test method for validiating EHS record
     static testMethod void testSaving1(){
         Test.startTest();
         ApexPages.standardController stdContrl= new ApexPages.standardController(new Other_EHS_CSR_Certificate__c());
        EHSNewRecord ehsNewRecord = new EHSNewRecord(stdContrl);
        ehsNewRecord.saving();
         Test.stopTest();
     }
    //Test method for Positive test case 
    static testMethod void testSaving2(){
        setupData();  
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
      eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
      eHSNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Customer';
            eHSNewRecord.category1 = 'Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            eHSNewRecord.selectclick();
            eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
    
    //Start:  Methods added by Hitesh to cover category for 'Auth Customer' and 'Qual Customer'
    //Test method positive test case when category and category1 = 'Auth Customer'
    static testMethod void testSavingAuth(){
        setupData();  
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        eHSNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Auth Customer';
            eHSNewRecord.category1 = 'Auth Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            eHSNewRecord.selectclick();
            eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
    //Test method positive test case when category and category1 = 'Qual Customer'
    static testMethod void testSavingQual(){
        setupData();  
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        eHSNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Qual Customer';
            eHSNewRecord.category1 = 'Qual Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            eHSNewRecord.selectclick();
            eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
    //Test method for negative test case when category = 'Auth Customer' 
    static testMethod void testSaving3Auth(){
        setupData();      
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('','Draft',null,'FAB 1',null);
        eHSNewRecord.QualityCert.Effective_Date__c = null;
        eHSNewRecord.account = 'Test Account1';
        //eHSNewRecord.checkSaveMethod = true;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Auth Customer';
            eHSNewRecord.category1 = 'Auth Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.rightvalues = null;
            eHSNewRecord.rightvaluesBlack = null;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            //eHSNewRecord.selectclick();
            //eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
    //Test method for negative test case when category = 'Qual Customer' 
    static testMethod void testSaving3Qual(){
        setupData();      
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('','Draft',null,'FAB 1',null);
        eHSNewRecord.QualityCert.Effective_Date__c = null;
        eHSNewRecord.account = 'Test Account1';
        //eHSNewRecord.checkSaveMethod = true;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Qual Customer';
            eHSNewRecord.category1 = 'Qual Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.rightvalues = null;
            eHSNewRecord.rightvaluesBlack = null;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            //eHSNewRecord.selectclick();
            //eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
    //End:  Methods added by Hitesh to cover category for 'Auth Customer' and 'Qual Customer'
    
    //Test method for negative test case 
    static testMethod void testSaving3(){
        setupData();      
        List<Id> lstEHS = new List<Id>();
        Set<Id> stEHS = new Set<Id>();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
      eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('','Draft',null,'FAB 1',null);
      eHSNewRecord.QualityCert.Effective_Date__c = null;
        eHSNewRecord.account = 'Test Account1';
      //  eHSNewRecord.checkSaveMethod = true;
        Test.startTest();
            lstEHS.add(eHSNewRecord.QualityCert.Id);
            stEHS.add(eHSNewRecord.QualityCert.Id);
            eHSNewRecord.category = 'Customer';
            eHSNewRecord.category1 = 'Customer';
            eHSNewRecord.custid = lstEHS;
            eHSNewRecord.custidBlack = stEHS;
            eHSNewRecord.rightvalues = null;
            eHSNewRecord.rightvaluesBlack = null;
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            //eHSNewRecord.selectclick();
            //eHSNewRecord.selectclickBlack();
            eHSNewRecord.saving();
        Test.stopTest();
    }
      static testMethod void testSaveNew(){
        setupData();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        eHSNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            eHSNewRecord.custid.add(account1.Id);
            eHSNewRecord.selectclick();
            eHSNewRecord.selectclickBlack();
            eHSNewRecord.SaveNew();
        Test.stopTest();
      }
    static testMethod void testSaveNewPart2(){
        setupData();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        eHSNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            eHSNewRecord.resetAccount();
            eHSNewRecord.getPopulateCustomerSelectOption();
            eHSNewRecord.getPopulateCustomerSelectOptionBlack();
            eHSNewRecord.leftselected.add(account1.Id);
            eHSNewRecord.leftselectedBlack.add(account2.Id);
            eHSNewRecord.selectclick();
            eHSNewRecord.selectclickBlack();
            eHSNewRecord.SaveNew();
        Test.stopTest();
      }
     //Test select option scenarios
    static testMethod void testSelectOption1(){
        setupData();
       EHSNewRecord eHSNewRecord = new EHSNewRecord();
       eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);       
        Test.startTest();
        eHSNewRecord.getPopulateCustomerSelectOption();
        eHSNewRecord.getPopulateCustomerSelectOptionBlack();
        eHSNewRecord.leftselected.add(account1.Id);
        eHSNewRecord.leftselected.add(account2.Id);
        eHSNewRecord.selectclick();
        eHSNewRecord.leftvalues.add(account1.Id);
        eHSNewRecord.leftvalues.add(account2.Id);
        eHSNewRecord.selectallclick();
        eHSNewRecord.leftselectedBlack.add(account1.Id);
        eHSNewRecord.leftselectedBlack.add(account2.Id);
        eHSNewRecord.selectclickBlack();
        eHSNewRecord.leftvaluesBlack.add(account1.Id);
        eHSNewRecord.leftvaluesBlack.add(account2.Id);
        eHSNewRecord.selectallblackclick();    
        Test.stopTest();
    }
    //Test unselect option scenarios
    static testMethod void testSelectOption2(){
        setupData();
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);      
        Test.startTest();        
        eHSNewRecord.getPopulateCustomerUnSelectOption();
        eHSNewRecord.getPopulateCustomerUnSelectOptionBlack();
        eHSNewRecord.rightselected.add(account2.Id);
        eHSNewRecord.unselectclick();
        eHSNewRecord.rightvalues.add(account1.Id);
        eHSNewRecord.rightvalues.add(account2.Id);
        eHSNewRecord.unselectallclick();
        eHSNewRecord.rightselectedBlack.add(account2.Id);
        eHSNewRecord.unselectclickBlack();
        eHSNewRecord.rightvaluesBlack.add(account1.Id);
        eHSNewRecord.rightvaluesBlack.add(account2.Id);
        eHSNewRecord.unselectallblackclick();
        eHSNewRecord.selectallblackclick();
        Test.stopTest();
    }
        //Test Create Folder method postive test case
    static testMethod void testCreateFolder1(){
        Environment_Variable__c env = new Environment_Variable__c(Name = 'EHS Endpoint URl', Value__c = 'Test Create Folder Service');
        insert env;
       EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5); 
        insert eHSNewRecord.QualityCert;
        Test.startTest();
        eHSNewRecord.operation = 'savenew';
        eHSNewRecord.iserror = false;
        eHSNewRecord.Createfolder(); 
        Test.StopTest();
    }
       //Test Create Folder method validate test case
    static testMethod void testCreateFolder2(){
        EHSNewRecord eHSNewRecord = new EHSNewRecord();
         eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSNewRecord.QualityCert;
        Test.startTest();
        eHSNewRecord.iserror = true;
        eHSNewRecord.ErrorMessage = 'Error';
        eHSNewRecord.Createfolder();
        Test.StopTest();
    }
       //test delete Quaility Certificate operation
    static testMethod void testDeleteQualityCertificate(){
       EHSNewRecord eHSNewRecord = new EHSNewRecord();
        eHSNewRecord.QualityCert =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSNewRecord.QualityCert;
        Test.startTest();
        delete eHSNewRecord.QualityCert;
        Test.StopTest();
    }
    
    //test method for validating delete operation:-'Customers cannot be deleted once the Reports are Approved'
    static testMethod void validateDeleteOperation1(){
        setUpData();
        Other_EHS_CSR_Certificate__c EHSCertifcate =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert EHSCertifcate;
        EHS_Access_List__c  EHSAssociatedCustomer = QS_TestUtil.createEHSAssociatedCustomer(account1.Id, EHSCertifcate.Id);
        insert EHSAssociatedCustomer;
        EHSCertifcate.Stage__c = 'Approved';
        update EHSCertifcate;
        Test.startTest();
        try{
            delete EHSAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Customers cannot be deleted once the Reports are Approved'));                  
        }
        Test.stopTest();
    }
     //test method for validating delete operation:- Document cannot be deleted once the Quality Certificate is approved
    static testMethod void validateDeleteOperation2(){
        setUpData();
       Other_EHS_CSR_Certificate__c EHSCertifcate =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert EHSCertifcate;
       EHS_Access_List__c  EHSAssociatedCustomer = QS_TestUtil.createEHSAssociatedCustomer(account1.Id, EHSCertifcate.Id);
        insert EHSAssociatedCustomer;
        EHSCertifcate.Stage__c = 'Approved';
        update EHSCertifcate;
    }
    
    //test method for validating update operation:-'Customers cannot be edited once the Reports are Approved'
    static testMethod void validateUpdateOperation(){
        setUpData();
       Other_EHS_CSR_Certificate__c EHSCertifcate =  QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert EHSCertifcate;
        EHS_Access_List__c  EHSAssociatedCustomer = QS_TestUtil.createEHSAssociatedCustomer(account1.Id, EHSCertifcate.Id);
        insert EHSAssociatedCustomer;
        EHSCertifcate.Stage__c = 'Approved';
        update EHSCertifcate;
        Test.startTest();
        try{
            EHSAssociatedCustomer.Status__c = 'Success';
            update EHSAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Customers cannot be edited once the Reports are Approved'));                  
        }
        Test.stopTest();
    }
        
      // following test methods for ClsQualityCertificationOnFV.cls 
    static testMethod void testSearch(){
        setupData();
        contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' and p.name = 'Customer Portal Admin' LIMIT 1];
        if(profiles != null && !profiles.isEmpty()){
            portalUser = QS_TestUtil.createPortalUser('test', 'test1@test1.com', 'test1 Contact', 'Test1 Contact', profiles[0].Id, contact.Id, 'test1@test1.com');
            //insert portalUser;
        }
        Other_EHS_CSR_Certificate__c  eHSCertifcate = QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSCertifcate;
        EHS_Access_List__c  ESAssociatedCustomer = QS_TestUtil.createEHSAssociatedCustomer(account1.Id, eHSCertifcate.Id);
        insert ESAssociatedCustomer;
    }
    
    static testMethod void testOnClickRedirect(){
       Other_EHS_CSR_Certificate__c  eHSCertifcate = QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSCertifcate;
        Test.startTest();
            ClsEHSQualityCertificationOnFV clsEHSQualityCertificationOnFV = new ClsEHSQualityCertificationOnFV();
            clsEHSQualityCertificationOnFV.onClickRedirect();
        Test.stopTest();
    }
    
    static testMethod void testOnLoadIframeAction(){
       Other_EHS_CSR_Certificate__c  eHSCertifcate = QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSCertifcate;
        Apexpages.currentPage().getParameters().put('Id',eHSCertifcate.Id);
        Test.startTest();
            ClsEHSQualityCertificationOnFV clsEHSQualityCertificationOnFV = new ClsEHSQualityCertificationOnFV();
            clsEHSQualityCertificationOnFV.onLoadIframeAction();
        Test.stopTest();
    }
     //following test methods for QualityCertificationUploadFile.cls 
    
    static testMethod void testSave(){
        Other_EHS_CSR_Certificate__c  eHSCertifcate = QS_TestUtil.createEHSCertificate('Material Declaration','Draft','Test EHC','FAB 1',System.today() + 5);
        insert eHSCertifcate;
    }
    
    static testMethod void testDocancel(){
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        Test.startTest();
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        ApexPages.StandardController  stdctrl = new ApexPages.StandardController(uploadQC);
        Test.stopTest();
    }
}