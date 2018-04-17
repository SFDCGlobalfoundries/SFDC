@isTest
public class CDSAttachmentUploadFormTEST {

    public static testMethod void getAttachments(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
        
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        //Map<String,List<Attachment>> attachListMap = new Map<String,List<Attachment>>();
        //Map<String,Attachment> attachMap = new Map<String,Attachment>();
        //attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        //attachListMap.put('SIGNAL_POWER_STARTSWITH',lstAttch);
        
        CDSAttachmentUploadForm obj = new CDSAttachmentUploadForm();
        //obj.attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        obj.getAttachments(testAcct.id);
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('CDS_HEADER_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
        public static testMethod void getAttachments2(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='SIGNAL_POWER_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Map<String,List<Attachment>> attachListMap = new Map<String,List<Attachment>>();
        Map<String,Attachment> attachMap = new Map<String,Attachment>();
        CDSAttachmentUploadForm obj1 = new CDSAttachmentUploadForm();
        obj1.getAttachments(testAcct.id);
        
        
        attach.Name='Xyz';
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        update attach;
        obj1.attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        //obj1.attachMap=attachmap;
        //system.debug('--attachMap--'+attachMap);
        //CDSAttachmentUploadForm obj = new CDSAttachmentUploadForm();
        
        //obj1.getAttachments(testAcct.id);
        obj1.saveAttachList();
    
    }
    
    public static testMethod void getAttachments3(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='MITI_TRAN_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('MITI_TRAN_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
        public static testMethod void getAttachments4(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='NOISE_SPECS_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
            
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('NOISE_SPECS_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments5(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='DRAM_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        attach.name='xyz';
        update attach;
        obj.attachMap.put('DRAM_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
        public static testMethod void getAttachments6(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='DRAM_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
        
    public static testMethod void getAttachments7(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='DevDel_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachmap.put('DevDel_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
        public static testMethod void getAttachments8(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Core_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Core_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
     public static testMethod void getAttachments9(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Image_Inf_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Image_Inf_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments10(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Pkg_Inf_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.name='xyz';
        update attach;
        obj.attachMap.put('Pkg_Inf_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
     public static testMethod void getAttachments11(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Card_Inf_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Card_Inf_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
         public static testMethod void getAttachments12(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Scan_Bits_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Scan_Bits_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments13(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments14(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
    
     public static testMethod void getAttachments15(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
    
         public static testMethod void getAttachments16(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Card_Inf_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments17(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Scan_Bits_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    }
    
    public static testMethod void getAttachments21(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Des_Test_STARTSWITH',attach);
        obj.saveAttachList();
    
    }

    public static testMethod void getAttachments20(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    } 
    
     public static testMethod void getAttachments19(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='ASIC_DESIGN_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('ASIC_DESIGN_STARTSWITH',attach);
        obj.saveAttachList();
    
    }               
    
     public static testMethod void getAttachments22(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Mfg_Test_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Mfg_Test_STARTSWITH',attach);
        obj.saveAttachList();
    
    }               
    
         public static testMethod void getAttachments23(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Arch_Info_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Arch_Info_STARTSWITH',attach);
        obj.saveAttachList();
    
    }  
    
             public static testMethod void getAttachments24(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Des_Strc_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Des_Strc_STARTSWITH',attach);
        obj.saveAttachList();
    
    } 
    
       public static testMethod void getAttachments25(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Net_Cust_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Net_Cust_STARTSWITH',attach);
        obj.saveAttachList();
    
    } 
    
     public static testMethod void getAttachments26(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Spl_Place_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Spl_Place_STARTSWITH',attach);
        obj.saveAttachList();
    
    } 
    
    public static testMethod void getAttachments27(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Spl_Wire_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Spl_Wire_STARTSWITH',attach);
        obj.saveAttachList();
    
    } 
        
            public static testMethod void getAttachments28a(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Clk_Info_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Clk_Info_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
        public static testMethod void getAttachments28b(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Clk_Char_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachMap.put('Clk_Char_STARTSWITH',attach);
        obj.saveAttachList();
    
    }
                public static testMethod void getAttachments29(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='Avst_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Map<String,attachment> attachMap = new  Map<String,attachment>();
        attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        
        attach.Name='xyz';
        update attach;
        obj.attachmap.put('Avst_STARTSWITH',attach);
        obj.saveAttachList();
    
    } 
    
            public static testMethod void getAttachments30(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
        Attachment attach = new Attachment();
        attach.Name='CDS_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=testAcct.Id;
        attach.IsPrivate=false;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Map<String,attachment> attachMap = new  Map<String,attachment>();
        attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    } 
      public static testMethod void saveAttachList(){
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        insert e;
    
      
        // Create Account
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        
       
        
           
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = testAcct.id;
        cd.CDS_Status__c = 'Draft';
       // cd.Device__c = Dev1.id;
        cd.Design_System__c = 'Cu-08';
        //cd.DIW_Option_Control_Number__c = opt1.id ;
        insert cd;
        CDSAttachmentUploadForm  obj = new CDSAttachmentUploadForm();
        
        Attachment attach1 = new Attachment();
        attach1.Name='CDS_STARTSWITH';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach1.body=bodyBlob;
       // attach.parentId=testAcct.Id;
        attach1.IsPrivate=false;
        attach1.ContentType = 'application/pdf';
        
        Attachment attach2 = new Attachment();
        attach2.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body1');
        attach2.body=bodyBlob1;
       // attach.parentId=testAcct.Id;
        attach2.IsPrivate=false;
        attach2.ContentType = 'application/pdf';
        //insert attach;
        
        Attachment attach3 = new Attachment();
        attach3.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body1');
        attach3.body=bodyBlob1;
       // attach.parentId=testAcct.Id;
        attach3.IsPrivate=false;
        attach3.ContentType = 'application/pdf';
        //insert attach;
        
                Attachment attach4 = new Attachment();
        attach4.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob12=Blob.valueOf('Unit Test Attachment Body1');
        attach4.body=bodyBlob1;
       // attach.parentId=testAcct.Id;
        attach4.IsPrivate=false;
        attach4.ContentType = 'application/pdf';
        //insert attach;
        
        
        Attachment attach5 =  new Attachment();
        attach5.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob15=Blob.valueOf('Unit Test Attachment Body1');
        attach5.body=bodyBlob1;
       // attach.parentId=testAcct.Id;
        attach5.IsPrivate=false;
        attach5.ContentType = 'application/pdf';
        //insert attach;
        
        Attachment attach6 =  new Attachment();
        attach6.Name='CDS_HEADER_STARTSWITH';
        Blob bodyBlob125=Blob.valueOf('Unit Test Attachment Body1');
        attach6.body=bodyBlob1;
       // attach.parentId=testAcct.Id;
        attach6.IsPrivate=false;
        attach6.ContentType = 'application/pdf';
        //insert attach;
        
                
        
        
        Map<String,attachment> attachMap = new  Map<String,attachment>();
        attachMap.put('SIGNAL_POWER_STARTSWITH',attach1);
        attachMap.put('MITI_TRAN_STARTSWITH',attach2);
        attachMap.put('NOISE_SPECS_STARTSWITH',attach3);
        attachMap.put('DRAM_STARTSWITH',attach4);
        attachMap.put('Core_STARTSWITH',attach5);        
        attachMap.put('CDS_HEADER_STARTSWITH',attach6);
                
        
         
        
        obj.ParentId = cd.id;
        obj.attachMap = attachMap;
       // obj.getAttachments(testAcct.id);
        obj.saveAttachList();
    
    } 
}