@isTest(seealldata=false)
private class ClsNewPWCATest{

    static Account account1;
    static Account account2;
    static Account account3;
    static Contact contact;
    static User portalUser;
    
    
 @testSetup static void testdata() {
        //DataUtilTest.LoadATPEnvVariables();
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
     
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Short_Name__c','a1234'+i);
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        
        List<Map<String,Object>> fieldValueMapList1 = new List<Map<String,Object>>();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT3');            
            fieldValueMap.put('stage__c', 'abc');
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 3');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 3');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore'); 
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('Short_Name__c','b23424');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
            fieldValueMapList1.add(fieldValueMap);
            AccountDataFactory.createAccounts(fieldValueMapList1,1);
 }    
    
    //following testMethods for PWCA_PublicationCls
    
    //Test method for validiating PWCA Publication record
    static testMethod void testSavePwcaRecord1(){
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        Test.startTest();
        pwcaPublicationCls.SavePwcaRecord();
        Test.stopTest();
    }
    
    //Test method for Positive test case 
    static testMethod void testSavePwcaRecord2(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1234', System.today() + 5, 'AL','PFOS', '40nm', 'Al', 'EU', '6', '546', '1',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        pwcaPublicationCls.rightvalues.add(account1.Id);
        pwcaPublicationCls.custMap.put(account1.Id, account1.Name+'('+account1.Short_Name__c+')');
        Test.startTest();
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.SavePwcaRecord();
        Test.stopTest();
    }
    
    //Test method for savenew functionality
    static testMethod void testSaveNew(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1234', System.today() + 5, 'AL','PFOS', '40nm', 'Al', 'EU', '6', '546', '1',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        Test.startTest();
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.saveNew();
        Test.stopTest();
    }
    
    //Test method for cancel method
    static testMethod void cancel(){
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        Test.startTest();
        pwcaPublicationCls.cancle();
        Test.stopTest();
    }
    
   //Test method for Createfolder functionality positve test case
    static testMethod void testCreatefolder1(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        //Environment_Variable__c env = new Environment_Variable__c(Name = 'Quality Endpoint URl', Value__c = 'Test Create Folder Service');
       // insert env;
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'Quality Endpoint URl', Value__c = 'Test Create Folder Service'));
        //DataUtilTest.loadEnvironmentVariables();
        database.insert(listSObj, false);
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        insert pwcaPublicationCls.pwcaObj;
        Test.startTest();
        pwcaPublicationCls.isError = false;
        pwcaPublicationCls.Createfolder();
        Test.stopTest();
    }
    
    //Test method for Createfolder functionality negative test case
    static testMethod void testCreatefolder2(){
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        Test.startTest();
        pwcaPublicationCls.isError = true;
        pwcaPublicationCls.Createfolder();
        Test.stopTest();
    }
    
    //Test select option scenarios
    static testMethod void testSelectOption1(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS'; 
        insert pwcaPublicationCls.pwcaObj;
                                                                            
        Test.startTest();
        pwcaPublicationCls.category='Qual Customer';
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.getPopulateCustomerSelectOption();
        pwcaPublicationCls.leftselected.add(account1.Id);
        pwcaPublicationCls.leftselected.add(account2.Id);
        pwcaPublicationCls.selectclick();
        pwcaPublicationCls.leftvalues.add(account1.Id);
        pwcaPublicationCls.leftvalues.add(account2.Id);
        pwcaPublicationCls.selectallclick();
        pwcaPublicationCls.shareAssociatedCustomers(pwcaPublicationCls.pwcaObj.Id);
        Test.stopTest();
    }
    
    //Test unselect option scenarios
    static testMethod void testSelectOption2(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        Test.startTest();
        pwcaPublicationCls.rightvalues.clear();
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.rightvalues.add(account1.Id);
        pwcaPublicationCls.rightvalues.add(account2.Id);
        pwcaPublicationCls.custMap.put(account1.Id,account1.Name+'('+account1.Short_Name__c+')');
        pwcaPublicationCls.custMap.put(account2.Id,account2.Name+'('+account2.Short_Name__c+')');
        pwcaPublicationCls.getPopulateCustomerUnSelectOption();
        pwcaPublicationCls.rightselected.add(account2.Id);
        pwcaPublicationCls.unselectclick();
        pwcaPublicationCls.rightvalues.add(account1.Id);
        pwcaPublicationCls.rightvalues.add(account2.Id);
        pwcaPublicationCls.unselectallclick();
        Test.stopTest();
    }
    
    //Test select option scenarios
    static testMethod void testSelectOption3(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Preliminary', '4543', account1.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS'; 
        insert pwcaPublicationCls.pwcaObj;
                                                                             
        Test.startTest();
        pwcaPublicationCls.category='Auth Customer';
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.getPopulateCustomerSelectOption();
        pwcaPublicationCls.leftselected.add(account1.Id);
        pwcaPublicationCls.leftselected.add(account2.Id);
        pwcaPublicationCls.selectclick();
        pwcaPublicationCls.leftvalues.add(account1.Id);
        pwcaPublicationCls.leftvalues.add(account2.Id);
        pwcaPublicationCls.selectallclick();
        pwcaPublicationCls.shareAssociatedCustomers(pwcaPublicationCls.pwcaObj.Id);
        Test.stopTest();
    }   
    
    static testMethod void testSelectOption4(){
        account3 = getAccount('MYTEST ACCOUNT3');
        
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Preliminary', '4543', account3.Id);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS'; 
        insert pwcaPublicationCls.pwcaObj;   
        
        Test.startTest();
        pwcaPublicationCls.resetAccount();
        pwcaPublicationCls.category = 'Customer';
        pwcaPublicationCls.custMap.put(account3.Id,account3.Name+'('+account3.Short_Name__c+')');
        pwcaPublicationCls.getPopulateCustomerSelectOption();
        pwcaPublicationCls.leftselected.add(account3.Id);
        pwcaPublicationCls.selectclick();
        pwcaPublicationCls.leftvalues.add(account3.Id);
        pwcaPublicationCls.selectallclick();
        pwcaPublicationCls.shareAssociatedCustomers(pwcaPublicationCls.pwcaObj.Id);
        Test.stopTest();
    }
    
    //test method for delete operation
    static testMethod void testDelete(){
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6',                                                                
                                                                        '546', '2', 'B', 'Preliminary', '4543', null);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        insert pwcaPublicationCls.pwcaObj;
        
        Test.startTest();
        delete pwcaPublicationCls.pwcaObj;
        Test.stopTest();
    }
    
    //test method for delete operation of PWCA Attachment
    static testMethod void testDeletePWCAAttachment(){
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new PWCA_publication__c());
        PWCA_PublicationCls pwcaPublicationCls = new PWCA_PublicationCls(stdCntrl);
        pwcaPublicationCls.pwcaObj = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6',                                                                
                                                                        '546', '2', 'B', 'Preliminary', '4543', null);
        pwcaPublicationCls.pwcaObj.Report_Date__c = System.Today() + 5;
        pwcaPublicationCls.pwcaObj.TypeOfDocument__c = 'PFOS';
        insert pwcaPublicationCls.pwcaObj;
        
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublicationCls.pwcaObj.Id, 'Test.Doc');
        insert pwcaAttachment;
        
        Test.startTest();
        delete pwcaAttachment;
        Test.stopTest();
    }
    
        
    
    //test method for validating delete operation:-'Associated Customers cannot be deleted after PWCA is sent for approval/approved'
    static testMethod void validateDeleteOperation(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1234', System.today() + 5, 'AL','PFOS', '40nm', 'Al',                                                             
                                                                                'EU', '6', '546', '1','B', 'Preliminary', '4543', account1.Id);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        insert pwcaPublication;
        PWCAAssociated_Customers__c pwcaAssociatedCustomer = QS_TestUtil.createPWCAAssociatedCustomer(account1.Id, pwcaPublication.Id);
        insert pwcaAssociatedCustomer;
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublication.Id, 'Test.Doc');
        insert pwcaAttachment;
        pwcaPublication.Document_Status__c = 'Approved';
        update pwcaPublication;
        Test.startTest();
        try{
            delete pwcaAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Associated Customers cannot be deleted after PWCA is sent for approval/approved'));                  
        }
        Test.stopTest();
    }
    
    //test method for validating update operation:-'Associated Customers cannot be edited after PWCA is sent for approval/approved'
    static testMethod void validateUpdateOperation(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1234', System.today() + 5, 'AL','PFOS', '40nm', 'Al',                                                             
                                                                                'EU', '6', '546', '1','B', 'Preliminary', '4543', account1.Id);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        insert pwcaPublication;
        PWCAAssociated_Customers__c pwcaAssociatedCustomer = QS_TestUtil.createPWCAAssociatedCustomer(account1.Id, pwcaPublication.Id);
        insert pwcaAssociatedCustomer;
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublication.Id, 'Test.Doc');
        insert pwcaAttachment;
        pwcaPublication.Document_Status__c = 'Approved';
        update pwcaPublication;
        Test.startTest();
        try{
            pwcaAssociatedCustomer.Status__c = 'Success';
            update pwcaAssociatedCustomer;
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Associated Customers cannot be edited after PWCA is sent for approval/approved'));                  
        }
        Test.stopTest();
    }
    
    
    
    //following test method for ClsPWCARportOnFV.cls
    
    static testMethod void testSearch(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
               
        system.runAs(new User(id=UserInfo.getUserId())){

            contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@contact.com', 'Customers My Device Admin; Primary Account Admin', 
                                                'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
            insert contact;
            Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' LIMIT 1];
            if(profiles != null && !profiles.isEmpty()){
                portalUser = QS_TestUtil.createPortalUser('test', 'test1@test1.com', 'test1 Contact', 'Test1 Contact', profiles[0].Id, contact.Id, 'test1@test1.com');
                Test.StartTest();
                insert portalUser;
            }
        }
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1234', System.today() + 5, 'AL','PFOS', '40nm', 'Al',                                                             
                                                                            'EU', '6', '546', '1','B', 'Effective', '4543', account1.Id);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        pwcaPublication.OpenTextId__c = '12345';
        pwcaPublication.Ready_To_Publish__c = true;
        insert pwcaPublication;
        system.assertEquals(pwcaPublication.TypeOfDocument__c,'PFOS');
        PWCAAssociated_Customers__c pwcaAssociatedCustomer = QS_TestUtil.createPWCAAssociatedCustomer(account1.Id, pwcaPublication.Id);
        insert pwcaAssociatedCustomer;
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublication.Id, 'Test.Doc');
        insert pwcaAttachment;
        
        System.runAs(portalUser){
            
                ClsPWCARportOnFV clsPWCARportOnFV = new ClsPWCARportOnFV();
                clsPWCARportOnFV.search();
                
                List<PWCAAssociated_Customers__c> lstQCAccess = new List<PWCAAssociated_Customers__c>();
                lstQCAccess = clsPWCARportOnFV.getPWCAaccessData();
                clsPWCARportOnFV.getDisableNext();
                clsPWCARportOnFV.getDisablePrevious();
                clsPWCARportOnFV.getTotalPageCount();
                clsPWCARportOnFV.goToPreviousPage();
                clsPWCARportOnFV.goToNextPage();
                clsPWCARportOnFV.goToLastPage();
                clsPWCARportOnFV.goToPageN(1);
                clsPWCARportOnFV.getDisplayRecordStart();
                clsPWCARportOnFV.getDisplayRecordEnd();
                
            Test.StopTest();
        }
    }
        
    static testMethod void testOnClickRedirect(){
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Effective', '4543', null);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        pwcaPublication.OpenTextId__c = '12345';
        insert pwcaPublication;
        Test.startTest();
            ClsPWCARportOnFV clsPWCARportOnFV = new ClsPWCARportOnFV();
            clsPWCARportOnFV.onClickRedirect();
        Test.stopTest();
    }
    
    static testMethod void testOnLoadIframeAction(){
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Effective', '4543', null);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        pwcaPublication.OpenTextId__c = '12345';
        insert pwcaPublication;
        Apexpages.currentPage().getParameters().put('Id',pwcaPublication.Id);
        Test.startTest();
            ClsPWCARportOnFV clsPWCARportOnFV = new ClsPWCARportOnFV();
            clsPWCARportOnFV.onLoadIframeAction();
        Test.stopTest();
    }
    
    
    //following test method for PWCAReportUploadFile.cls
    
    static testMethod void testDoSave(){
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Approved', '4543', null);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        pwcaPublication.OpenTextId__c = '12345';
        insert pwcaPublication;
        Test.startTest();
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublication.Id, 'Test.Doc');
        ApexPages.StandardController  stdctrl = new ApexPages.StandardController(pwcaAttachment);
        PWCAReportUploadFile pwcaReportUploadFile = new PWCAReportUploadFile(stdctrl);
        pwcaReportUploadFile.doSave();
        Test.stopTest();
    }
    
    static testMethod void testDoCancel(){
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        
        PWCA_publication__c pwcaPublication = QS_TestUtil.createPWCAPublication( '1', System.today() + 5, 'AL','PFOS', '0.20um', 'Al', 'AP', '6', '546', '2',
                                                                        'B', 'Approved', '4543', null);
        pwcaPublication.TypeOfDocument__c = 'PFOS';
        pwcaPublication.OpenTextId__c = '12345';
        insert pwcaPublication;
        Test.startTest();
        PWCA_Attachments__c pwcaAttachment = QS_TestUtil.createPWCAAttachment(pwcaPublication.Id, 'Test.Doc');
        PWCAReportUploadFile pwcaReportUploadFileTemp = new PWCAReportUploadFile();
        ApexPages.StandardController  stdctrl = new ApexPages.StandardController(pwcaAttachment);
        PWCAReportUploadFile pwcaReportUploadFile = new PWCAReportUploadFile(stdctrl);
        pwcaReportUploadFile.doCancel();
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name, Short_Name__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}