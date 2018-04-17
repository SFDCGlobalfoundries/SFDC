@isTest
private class QS_QualityCertificateTriggerHandlerTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    static Account account;
    static Contact contact;
    static User portalUser;
    static Quality_Certificate__c qualityCertifcate;
    static QC_Access_List__c qcAssociatedCustomer;
    static UploadQC__c uploadQC;
    
    static void setupData(){
        //DataUtilTest.loadEnvironmentVariables();
        /*Error_Codes__c errorCode = QS_TestUtil.createErrorCode('ACCT_TM_DUP_USER_ROLE_ERROR', 'There are duplicate users or roles in the form. Please review the form and update assignment as necessary.');
        insert errorCode;
        List<Environment_Variable__c> envList = new List<Environment_Variable__c> (); 
        envList.add(QS_TestUtil.createENVariable('ACCT_TM_PRXY_TM_RL_AM','Account Manager'));
        envList.add(QS_TestUtil.createENVariable('ACCT_TM_PRXY_TM_RL_TS','Technical Support'));
        envList.add(QS_TestUtil.createENVariable('ACCT_TM_PRXY_TM_RL_AE','Application Engineer'));
        envList.add(QS_TestUtil.createENVariable('ACCT_TM_PRXY_TM_RL_CSR','Customer Service Rep'));
        insert envList;*/
        Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account; 
        Map<String, Schema.RecordtypeInfo> recordTypeMap = descSobjResult.getRecordTypeInfosByName();// = Schema.SObjectType.Account.getRecordTypeInfosByName();
        
        /*account = QS_TestUtil.createAccount('Test Account', 'Qualified', 'TestAccount', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100); */
        Map<String,Object>  fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'TestAccount1');            
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
        fieldValueMap.put('Fab_9_10__c','no');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        AccountDataFactory.createAccount(fieldValueMap);
        Account acc= getAccount('TestAccount1');                                             
        
        
        System.debug('Account ---'+account);
        contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', acc.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        
        
        qualityCertifcate = QS_TestUtil.createQualityCertificate( 'ISO', 'Draft', 'Test QC', 'FAB 1', System.today() + 5);
        insert qualityCertifcate;
        
        qcAssociatedCustomer = QS_TestUtil.createQCAssociatedCustomer(acc.Id, qualityCertifcate.Id);
        insert qcAssociatedCustomer;
         
         
        uploadQC = QS_TestUtil.createUpdoadQC('Test.Doc', System.today() + 5, qualityCertifcate.Id);
        insert uploadQC;
        System.debug('uploadQC========='+uploadQC);
        
        
    }
    
    static testMethod void testOnAfterUpdate(){
       setUpdata();
       Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' LIMIT 1];
        if(profiles != null && !profiles.isEmpty()){
            portalUser = QS_TestUtil.createPortalUser('test', 'test1@test1.com', 'test1 Contact', 'Test1 Contact', profiles[0].Id, contact.Id, 'test1@test1.com');
            Profile pp = [Select Id from Profile where Name='System Administrator']; 
            User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
            system.runas(ur){
                insert portalUser;
            }
        }
        Test.startTest();
            QS_QualityCertificateTriggerHandler.isExecuted = false;
            qualityCertifcate.Stage__c = 'Approved';
            update qualityCertifcate;
        Test.stopTest();
        List<UploadQC__c> uploadQCList = [SELECT Id, Ready_To_Publish__c FROM UploadQC__c WHERE Id = :uploadQC.Id LIMIT 1];
        System.assertEquals(true, uploadQCList[0].Ready_To_Publish__c);
    }
    
    private static Account getAccount(string AccountName){
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];        
        return testAcct;
    }      

}