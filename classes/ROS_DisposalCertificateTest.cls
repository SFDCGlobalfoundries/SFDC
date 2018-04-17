/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for classes: ROS_DisposalCertificate,ROS_DisposalCertificateFormatExt,ROS_DisposalZipExportController
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Sep-2014         Test class created.
        DBiswal        03172016            Modified for PMDA.  
**/

 
@isTest
private class ROS_DisposalCertificateTest {
     @testSetup static void testdata() {
        
       
        
        Document d = new Document(FolderId = UserInfo.getUserId() ,Name='broadcom logo', Body = Blob.ValueOf('Hello World'));
        d.Body = Blob.valueOf('test');
    
        
        insert d;
    
    DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
   
    
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    // Creation of an Account
    static Account createAccount(){
                 Account testAcct= getAccount('testing901'); 
            return testAcct;
    }
    
    static id createFab(){
        FAB__c FB = new FAB__c(Name='FAB 3');
        insert FB;
        return FB.id;   
    }
    
    static Id createReticleCycle() {        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }
    
    static Reticle__c createReticle(String name, Id accountId, String rosCycle, Integer dayInactive, Id ownerId,
                                     Boolean solTeamConfirm, String reticleType, String region, String workflowStatus){
        return new Reticle__c(Name = name, Account__c  = accountId, ROS_Cycle__c = rosCycle, Day_Inactive__c = dayInactive,
                              OwnerId = Ownerid,  Solution_Team_Confirm__c   = solTeamConfirm,Reticle_Type__c = reticleType,
                              Region__c = region, Reticle_workflow_Status__c = workflowStatus);                            
    }
            
    public static testMethod void testMethod1(){
        
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_DisposalCertificateTest.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_DisposalCertificateTest.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_DisposalCertificateTest.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_DisposalCertificateTest.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        Account account = createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        
        Reticle__c reticle = createReticle('A1000',account.Id, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        reticleDeviceList.add(new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011'));
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        
        reticle.Reticle_workflow_status__c = 'Pending for Customer Feedback';
        reticle.Invalid__c  = false;
        reticle.Made_Valid_by_CSR_Team__c = true;
        
        
        Test.startTest();
        update reticle;
            ROS_DisposalCertificate dispObj = new ROS_DisposalCertificate();
            dispObj.reticleRec.Account__c   = account.Id;
            dispObj.reticleRec.ROS_Cycle__c = Cycle;
            system.debug('#######Account Id########'+account.Id);
            dispObj.Generate();
            
            ROS_DisposalZipExportController exportObj = new ROS_DisposalZipExportController();
            List<ROS_DisposalCertificate__c> lstDisposalCertificate = [select id from ROS_DisposalCertificate__c limit 5];
            
            PageReference cerExportPage = Page.ROSVF_DisposalZipExport;
            Test.setCurrentPageReference (cerExportPage);
            if(!lstDisposalCertificate.isEmpty()){
                ApexPages.currentPage().getParameters().put('disposalId',lstDisposalCertificate[0].Id);
            }
            exportObj.zipFileName = '';
            exportObj.zipContent = 'test';
            exportObj.uploadZip();
            
            exportObj.getAttachments();
            
            ROS_DisposalZipExportController.AttachmentWrapper obj = new ROS_DisposalZipExportController.AttachmentWrapper();
            
            Attachment att = new Attachment();
            att.ParentId = lstDisposalCertificate[0].Id;
            att.Name = 'testAttchment';
            att.Body = blob.valueOf('test');
            insert att;
            ROS_DisposalZipExportController.getAttachment(att.Id);
            
            dispObj.returnToReticleSearch();
            
            ROS_DisposalCertificateFormatExt formatObj = new ROS_DisposalCertificateFormatExt();
            formatObj.getprintView();
            exportObj.cancelReturn();
            exportObj.ReturnMethod();
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
    
}