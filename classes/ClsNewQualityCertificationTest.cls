@isTest(seeAllData=false)
private class ClsNewQualityCertificationTest{

    static Account account1;
    static Account account2;
    static Contact contact;
    static User portalUser;
    
    @testSetup static void testdata() {
        DataUtilTest.LoadATPEnvVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('stage__c', 'Unqualified');        
            //fieldValueMap.put('short_name__c', 'Testsn'+i);        
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
    
            fieldValueMapList.add(fieldValueMap);
        }
        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl; 
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    static void setupData(){
        DataUtilTest.LoadATPEnvVariables();       
        Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account; 
        Map<String, Schema.RecordtypeInfo> recordTypeMap = descSobjResult.getRecordTypeInfosByName();// = Schema.SObjectType.Account.getRecordTypeInfosByName();
        
        List<Account> accountList = new List<Account>();
        account1 = QS_TestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
        account2 = QS_TestUtil.createAccount('Test Account2', 'Qualified', 'TestAccount2', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                             
        
        
    }  
   
    
    
    // following test methods for QCNEWRecord.cls 
      
    //Test method for validiating quality certificate record
    static testMethod void testSaving1(){
        Test.startTest();
        ApexPages.standardController stdContrl= new ApexPages.standardController(new Quality_Certificate__c());
        QCNewRecord qcNewRecord = new QCNewRecord (stdContrl);
        qcNewRecord.saving();
        Test.stopTest();
    }
      
     
    //Test method for Positive test case 
    static testMethod void testSaving2(){
        //setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            qcNewRecord.resetAccount();
            qcNewRecord.getPopulateCustomerSelectOption();
            qcNewRecord.getPopulateCustomerSelectOptionBlack();
            qcNewRecord.leftselected.add(account1.Id);
            qcNewRecord.leftselectedBlack.add(account2.Id);
            qcNewRecord.selectclick();
            qcNewRecord.selectclickBlack();
            qcNewRecord.saving();
        Test.stopTest();
    }
    
    //Test method for Positive test case 
    static testMethod void testSaveNew(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
            qcNewRecord.resetAccount();
            qcNewRecord.getPopulateCustomerSelectOption();
            qcNewRecord.getPopulateCustomerSelectOptionBlack();
            qcNewRecord.leftselected.add(account1.Id);
            qcNewRecord.leftselectedBlack.add(account2.Id);
            qcNewRecord.selectclick();
            qcNewRecord.selectclickBlack();
            qcNewRecord.SaveNew();
        Test.stopTest();
    }
    
    //Test select option scenarios
    static testMethod void testSelectOption1(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        
        Test.startTest();
        qcNewRecord.getPopulateCustomerSelectOption();
        qcNewRecord.getPopulateCustomerSelectOptionBlack();
        qcNewRecord.leftselected.add(account1.Id);
        qcNewRecord.leftselected.add(account2.Id);
        qcNewRecord.selectclick();
        qcNewRecord.leftvalues.add(account1.Id);
        qcNewRecord.leftvalues.add(account2.Id);
        qcNewRecord.selectallclick();
        qcNewRecord.leftselectedBlack.add(account1.Id);
        qcNewRecord.leftselectedBlack.add(account2.Id);
        qcNewRecord.selectclickBlack();
        qcNewRecord.leftvaluesBlack.add(account1.Id);
        qcNewRecord.leftvaluesBlack.add(account2.Id);
        qcNewRecord.selectallblackclick();
        Test.stopTest();
    }
    
    //Test unselect option scenarios
    static testMethod void testSelectOption2(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        
        Test.startTest();
        
        qcNewRecord.getPopulateCustomerUnSelectOption();
        qcNewRecord.getPopulateCustomerUnSelectOptionBlack();
        qcNewRecord.rightselected.add(account2.Id);
        qcNewRecord.unselectclick();
        qcNewRecord.rightvalues.add(account1.Id);
        qcNewRecord.rightvalues.add(account2.Id);
        qcNewRecord.unselectallclick();
        qcNewRecord.rightselectedBlack.add(account2.Id);
        qcNewRecord.unselectclickBlack();
        qcNewRecord.rightvaluesBlack.add(account1.Id);
        qcNewRecord.rightvaluesBlack.add(account2.Id);
        qcNewRecord.unselectallblackclick();
        Test.stopTest();
    }
    
    //Test Create Folder method postive test case
    static testMethod void testCreateFolder1(){
        Environment_Variable__c env = new Environment_Variable__c(Name = 'Quality Endpoint URl', Value__c = 'Test Create Folder Service');
        insert env;
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        insert qcNewRecord.QualityCert;
        Test.startTest();
        qcNewRecord.operation = 'savenew';
        qcNewRecord.iserror = false;
        qcNewRecord.Createfolder(); 
        Test.StopTest();
    }

    //Test Create Folder method validate test case
    static testMethod void testCreateFolder2(){
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        insert qcNewRecord.QualityCert;
        Test.startTest();
        qcNewRecord.iserror = true;
        qcNewRecord.ErrorMessage = 'Error';
        qcNewRecord.Createfolder();
        Test.StopTest();
    }
    
    //test delete Quaility Certificate operation
    static testMethod void testDeleteQualityCertificate(){
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.OpenTextId__c = '12345';
        insert qcNewRecord.QualityCert;
        Test.startTest();
        delete qcNewRecord.QualityCert;
        Test.StopTest();
    }
    
    //test method for validating delete operation:-'Customers cannot be deleted once the Reports are Approved'
    static testMethod void validateDeleteOperation1(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        QC_Access_List__c qcAssociatedCustomer = QS_TestUtil.createQCAssociatedCustomer(account1.Id, qualityCertifcate.Id);
        insert qcAssociatedCustomer;
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        insert uploadQC;
        qualityCertifcate.Stage__c = 'Approved';
        update qualityCertifcate;
        Test.startTest();
        try{
            delete qcAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Customers cannot be deleted once the Reports are Approved'));                  
        }
        Test.stopTest();
    }
    
    //test method for validating delete operation:- Document cannot be deleted once the Quality Certificate is approved
    static testMethod void validateDeleteOperation2(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        QC_Access_List__c qcAssociatedCustomer = QS_TestUtil.createQCAssociatedCustomer(account1.Id, qualityCertifcate.Id);
        insert qcAssociatedCustomer;
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        insert uploadQC;
        qualityCertifcate.Stage__c = 'Approved';
        update qualityCertifcate;
        Test.startTest();
        try{
            delete uploadQC;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Document cannot be deleted once the Quality Certificate is approved'));                  
        }
        Test.stopTest();
    }
    
    //test method for validating update operation:-'Customers cannot be edited once the Reports are Approved'
    static testMethod void validateUpdateOperation(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        QC_Access_List__c qcAssociatedCustomer = QS_TestUtil.createQCAssociatedCustomer(account1.Id, qualityCertifcate.Id);
        insert qcAssociatedCustomer;
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        insert uploadQC;
        qualityCertifcate.Stage__c = 'Approved';
        update qualityCertifcate;
        Test.startTest();
        try{
            qcAssociatedCustomer.Status__c = 'Success';
            update qcAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Customers cannot be edited once the Reports are Approved'));                  
        }
        Test.stopTest();
    }
    
    static testMethod void testSharetoQAandPIDetail(){
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.OpenTextId__c = '12345';
        insert qcNewRecord.QualityCert;
        Map<Id,Set<ID>> userGrpMap = new Map<Id,Set<ID>>();
        userGrpMap.put(qcNewRecord.QualityCert.Id, new set<ID>{UserInfo.getUserId(),UserInfo.getUserId()});
        Test.startTest();
        qcNewRecord.shareToQAandPIDetail(userGrpMap);
        Test.stopTest();

    }
    
    // following test methods for ClsQualityCertificationOnFV.cls 
    static testMethod void testSearch(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' and p.name = 'Customer Portal Admin' LIMIT 1];
        if(profiles != null && !profiles.isEmpty()){
            portalUser = QS_TestUtil.createPortalUser('test', 'test1@test1.com', 'test1 Contact', 'Test1 Contact', profiles[0].Id, contact.Id, 'test1@test1.com');
            Profile pp = [Select Id from Profile where Name='System Administrator']; 
            User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
            system.runas(ur){
                insert portalUser;
            }
        }
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        QC_Access_List__c qcAssociatedCustomer = QS_TestUtil.createQCAssociatedCustomer(account1.Id, qualityCertifcate.Id);
        insert qcAssociatedCustomer;
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        insert uploadQC;
        System.runAs(portalUser){
            Test.StartTest();
                Id [] fixedSearchResults= new Id[1];
                fixedSearchResults[0] = qualityCertifcate.Id;
                Test.setFixedSearchResults(fixedSearchResults);
                ClsQualityCertificationOnFV clsQualityCertificationOnFV = new ClsQualityCertificationOnFV();
                clsQualityCertificationOnFV.search();
                List<QC_Access_List__c> lstQCAccess = new List<QC_Access_List__c>();
                lstQCAccess = clsQualityCertificationOnFV.getQcAccessData();
                
                clsQualityCertificationOnFV.certificateGroup = 'ISO';
                clsQualityCertificationOnFV.getlstCertTypeOptions();
                clsQualityCertificationOnFV.certificateGroup = 'Others';
                clsQualityCertificationOnFV.getlstCertTypeOptions();
                
                clsQualityCertificationOnFV.getDisableNext();
                clsQualityCertificationOnFV.getDisablePrevious();
                clsQualityCertificationOnFV.getTotalPageCount();
                clsQualityCertificationOnFV.goToPreviousPage();
                clsQualityCertificationOnFV.goToNextPage();
                clsQualityCertificationOnFV.goToLastPage();
                clsQualityCertificationOnFV.goToPageN(1);
                clsQualityCertificationOnFV.getDisplayRecordStart();
                clsQualityCertificationOnFV.getDisplayRecordEnd();
            Test.StopTest();
        }
    }
    
    static testMethod void testOnClickRedirect(){
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        Test.startTest();
            ClsQualityCertificationOnFV clsQualityCertificationOnFV = new ClsQualityCertificationOnFV();
            clsQualityCertificationOnFV.onClickRedirect();
        Test.stopTest();
    }
    
    static testMethod void testOnLoadIframeAction(){
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        Apexpages.currentPage().getParameters().put('Id',qualityCertifcate.Id);
        Test.startTest();
            ClsQualityCertificationOnFV clsQualityCertificationOnFV = new ClsQualityCertificationOnFV();
            clsQualityCertificationOnFV.onLoadIframeAction();
        Test.stopTest();
    }
    
    
    //following test methods for QualityCertificationUploadFile.cls 
    
    static testMethod void testSave(){
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        Test.startTest();
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        ApexPages.StandardController  stdctrl = new ApexPages.StandardController(uploadQC);
        QualityCertificationUploadFile qcUploadFile = new QualityCertificationUploadFile(stdctrl);
        qcUploadFile.save();
        Test.stopTest();
    }
    
    static testMethod void testDocancel(){
        Quality_Certificate__c qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Approved', 'Test QC', 'FAB 1', System.today() + 5);
        qualityCertifcate.OpenTextId__c = '12345';
        insert qualityCertifcate;
        Test.startTest();
        UploadQC__c uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        ApexPages.StandardController  stdctrl = new ApexPages.StandardController(uploadQC);
        QualityCertificationUploadFile qcUploadFile = new QualityCertificationUploadFile(stdctrl);
        qcUploadFile.methodRender();
        qcUploadFile.doCancel();
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
      
    static testMethod void testSaving3(){
        //setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
        Environment_Variable__c EV=new Environment_Variable__c();
            EV.Name='ROS_GEForm_certificate_enable';
            EV.Value__c='true';
            Insert EV;
            Environment_Variable__c EV_2=new Environment_Variable__c();
            EV_2.Name='SELF_SIGNED_CERTIFICATE';
            EV_2.Value__c='null';
            Insert EV_2;
            qcNewRecord.category='Qual Customer';
            qcNewRecord.category1='Qual Customer';
            qcNewRecord.custidBlack.add(account1.Id);
            qcNewRecord.resetAccount();
            qcNewRecord.getPopulateCustomerSelectOption();
            qcNewRecord.getPopulateCustomerSelectOptionBlack();
            qcNewRecord.leftselected.add(account1.Id);
            qcNewRecord.leftselectedBlack.add(account2.Id);
            qcNewRecord.selectclick();
            qcNewRecord.selectclickBlack();
            qcNewRecord.saving();
        Test.stopTest();
    }
    
    static testMethod void testSaving4(){
        //setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        QCNewRecord qcNewRecord = new QCNewRecord();
        qcNewRecord.QualityCert = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        qcNewRecord.QualityCert.Effective_Date__c = System.today() + 1;
        Test.startTest();
        Environment_Variable__c EV=new Environment_Variable__c();
            EV.Name='ROS_GEForm_certificate_enable';
            EV.Value__c='true';
            Insert EV;
            Environment_Variable__c EV_2=new Environment_Variable__c();
            EV_2.Name='SELF_SIGNED_CERTIFICATE';
            EV_2.Value__c='null';
            Insert EV_2;
            qcNewRecord.category='Auth Customer';
            qcNewRecord.category1='Auth Customer';
            qcNewRecord.custid.add(account1.Id);
            qcNewRecord.custidblack.add(account2.Id);
            qcNewRecord.rightvalues.add(account2.Id);
            qcNewRecord.rightvalues.add(account1.Id);
            qcNewRecord.custMap.put(account1.Id,account1.Id);
            qcNewRecord.custMap.put(account2.Id,account2.Id);
            qcNewRecord.resetAccount();
            qcNewRecord.getPopulateCustomerSelectOption();
             qcNewRecord.getPopulateCustomerUnSelectOption();
            qcNewRecord.getPopulateCustomerSelectOptionBlack();
            qcNewRecord.leftselected.add(account1.Id);
            qcNewRecord.leftselectedBlack.add(account2.Id);
            qcNewRecord.selectclick();
            qcNewRecord.selectclickBlack();
            qcNewRecord.saving();
        Test.stopTest();
    }
    
    
    
}