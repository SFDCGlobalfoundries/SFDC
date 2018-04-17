@isTest()
public class CDSExtension_TEST {

    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
    
    
 static testMethod void testCDSExtensionNew() 
 {
 
       // List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<IO_and_Switching_Information__c> iOList;
        iOList = new List<IO_and_Switching_Information__c>();
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
       custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
         List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        
        
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id);       
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        system.debug('--opt1 --'+opt1.id );
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Primary_Option__c',opt1.Id);
        
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
        
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Device__c = Dev1.id;
        cd.Design_System__c = 'Cu-08';
        cd.Color_ECCN__c = 'Green';
        cd.DIW_Opp_Control_Number__c = opp1.id ;
        insert cd;
        
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
        /*Prod
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G6F000003gLUe';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G6F000003gLUf';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G6F000003gLUa';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G6F000003gLUb';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        UAT
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00GN0000003syXm';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00GN0000003syXn';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00GN0000003syXi';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00GN0000003syXj';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        */
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G0l000000FQoI';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        Custom_Design__Share cshare = new Custom_Design__Share();
        cshare.UserOrGroupId = thisUser.id;
        cshare.ParentId = cd.id;
        cshare.AccessLevel = 'Read';
        //Insert cshare;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
       // atp.User__c = skipUser.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        
        insert cr;
   

        
        Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Customer_Requirement__c = opt1.id;
        
        insert de;
        
        Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',opt1.Id);
            //fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
        
        
        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
       Attachment attach = new Attachment();
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.IsPrivate=false;
       attach.ContentType = 'application/pdf';

      CDSAttachmentUploadForm obj = new CDSAttachmentUploadForm();
        
        obj.attachMap.put('CDS_HEADER_STARTSWITH',attach);
 
    Test.startTest();
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234');   
    PageReference pageRef = Page.CDSListForOpp; 
    Test.setCurrentPage(pageRef);  
    pageRef.getParameters().put('devId', Dev1.Id);
    pageRef.getParameters().put('optId', opt1.Id);
    
    
     
     
    ApexPages.StandardController sc = new ApexPages.StandardController(new Custom_Design__c() );
    CDSFormExtension cds = new CDSFormExtension(sc);
   
    cds.doSave();
    cds.AddCore();
    cds.AddIO(); 
    cds.AddDram();
    cds.AddComp();
    cds.controllerActionPageDramC();
    cds.AddCore();
    cds.exportToExcel();
   // cds.deletePage();
    
    //cds.ProvideAccess();
  
    Test.stopTest();
 
 }
 }
 static testMethod void testCDSExtensioninitiateDIWOrange() 
 {
 
 List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
        custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
       
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');     
         insert u;
        Account account1 = new Account();
        account1.Name = 'Test Bnp Account1';
        account1.Short_Name__c = 'tEAccount1';
        account1.RecordTypeId = recordType.id;
        account1.Site_Department__c = 'Test';
        account1.Sub_Type__c = 'Test';
        account1.Transaction_Type__c = 'Test';
        account1.Region__c = 'US';
        account1.Corporate_Address_1__c = 'Test Address';
        account1.Corporate_City__c = 'Test City';
        account1.Corporate_Country__c = 'India';
        insert account1;
        
        /*Contact con = new Contact();
        con.Account = Account.Id;
        con.Name = 'Test';
        Insert con;*/
         
         Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        
        /*Opportunity opp1 = new Opportunity();
        opp1.accountId = account1.id;
        opp1.Name = 'Test Bnp Opp';
        opp1.StageName = '1. Discovery';
        opp1.CloseDate = System.today();
        opp1.Siebel_Opportunity_Id__c = '1-OPP-200000';
        opp1.Contract_Pricing__c = 'yes';
        insert opp1;   */
        Opportunity_Program_Team_Member__c opptm = new Opportunity_Program_Team_Member__c();
        opptm.Team_Role__c ='Primary Account Manager';
        opptm.Opportunity_Program__c  = oppprogram.id;
        opptm.User__c = u.id;
        Insert opptm;
        
       // set<ID> userListAccProxy = new set<ID>();
       // userListAccProxy.add(u.id);
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
             
    Group testGroup = new Group(Name='CDS Orange Zone Group', type='Queue');
    insert testGroup;

    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Custom_Design__c' );
    insert testQueue;
      
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c = '00G6F000003gLUe';
        cda.Orange__c = testGroup.Id;
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c =testQueue.Id;
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
         Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
         fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id);       
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
       
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Color_ECCN__c = 'Green';
        cd.DIW_Opp_Control_Number__c = opp1.id ;

        insert cd;
        
        
      
        List<DRAMs__c> DramList = new List<DRAMs__c>();
        
        for(Integer i=0;i<15;I++){
            DRAMs__c dram = new DRAMs__c();
            dram.Custom_Design_Specification__c = cd.id;
            dram.DRAM_Name__c = 'Name' +i;
            DramList.add(dram);
        }
        insert DramList;
        System.assertequals(DramList.size(),15);
        
        List<IO_and_Switching_Information__c> IOList = new List<IO_and_Switching_Information__c>();
        
        for(Integer i=0;i<15;I++){
            IO_and_Switching_Information__c io = new IO_and_Switching_Information__c();
            io.Custom_Design_Specification__c = cd.id;
            IOList.add(io);
        }
        
        insert IOList;
        
        List<CoresPLL__c> coreList = new List<CoresPLL__c>();
        
        for(Integer i=0;i<15;I++){
             CoresPLL__c cp = new CoresPLL__c();
             cp.Custom_Design_Specification__c = cd.id;
             coreList.add(cp);
        }
        
       
        insert coreList;
        
        List<Compilable__c> compList =new List<Compilable__c>();
        for(Integer i=0;i<15;I++){
             Compilable__c comp = new Compilable__c();
             comp.Custom_Design_Specification__c = cd.id;
             compList.add(comp);
        }
        
       
        insert compList;
        
        List<Development_Deliverable__c> devdList = new List<Development_Deliverable__c>();
        
        for(Integer i=0;i<15;I++){
             Development_Deliverable__c dd = new Development_Deliverable__c();
             dd.Custom_Design_Specification__c = cd.id;
             devdList.add(dd);
        }
        
        insert devdList;
        
        
        
        Third_Party_Design_Contact__c pd =new Third_Party_Design_Contact__c();
        pd.Custom_Design_Specification__c =cd.id;
        insert pd;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
        atp.User__c = u.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
        
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        //cr.Design__c = de.id;
        insert cr;
        
        Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Customer_Requirement__c = cr.id;

        insert de;
        

        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
        Attachment attach=new Attachment();

        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cd.Id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';
        insert attach;
        
        Map<String,attachment> attachMap = new  Map<String,attachment>();
        attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        
 
    Test.startTest();  
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234');   
    PageReference pageRef = Page.CDSPageFrame; 
    pageRef.getParameters().put('id', String.valueOf(cd.Id));
    pageRef.getParameters().put('DecId', String.valueOf(des.Id)); 
    Test.setCurrentPage(pageRef);   
    ApexPages.StandardController sc = new ApexPages.StandardController(cd);
    CDSFormExtension cds = new CDSFormExtension(sc);
     String st = cds.xlsHeader;
     st = 'test';
    cds.targetNAID = attach.id;
    //cds.userListAccProxy = new Set<Id>();
    //cds.userListAccProxy.add(u.id);
    cds.reQuote();
    cds.doSave();
    CDS.paginaterDram = new Paginate(dramList.size(), 10); //These lists hold the data 
                    cds.fullGenericListDram = new List<List<DRAMs__c>>(); 
                    cds.genericListDram = new List<DRAMs__c>(); //Break out the full list into a list of lists 
                    if(dramList.size() > 0){ 
                        List<DRAMs__c> tempCC = new List<DRAMs__c>(); Integer i = 0; 
                        for(DRAMs__c cc : dramList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == 10){ 
                            cds.fullGenericListDram.add(tempCC); 
                            tempCC = new List<DRAMs__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListDram.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListDram = cds.fullGenericListDram.get(cds.paginaterDram.index); 
                    }
       
    //CDS.fullGenericListDram.addall(DramList);
    cds.nextPageDram();
    cds.previousPageDram();
    cds.updatePageDram();
    cds.paginaterComp = new Paginate(compList.size(), 10); //These lists hold the data 
                    cds.fullGenericListComp = new List<List<Compilable__c>>(); 
                    cds.genericListComp = new List<Compilable__c>(); //Break out the full list into a list of lists 
                    if(compList.size() > 0){ 
                        List<Compilable__c> tempCC = new List<Compilable__c>(); 
                        Integer i = 0; 
                        for(Compilable__c cc : compList){ 
                            tempCC.add(cc); i++; if(i == 10){ 
                            cds.fullGenericListComp.add(tempCC); 
                            tempCC = new List<Compilable__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListComp.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListComp = cds.fullGenericListComp.get(cds.paginaterComp.index); 
                    }
    cds.nextPageComp();
    cds.previousPageComp();
    cds.updatePageComp();
     cds.paginaterIO = new Paginate(IOList.size(), 10); //These lists hold the data 
                    cds.fullGenericListIO = new List<List<IO_and_Switching_Information__c>>(); 
                    cds.genericListIO = new List<IO_and_Switching_Information__c>(); //Break out the full list into a list of lists 
                    if(IOList.size() > 0){ 
                        List<IO_and_Switching_Information__c> tempCC = new List<IO_and_Switching_Information__c>(); 
                        Integer i = 0; 
                        for(IO_and_Switching_Information__c cc : IOList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == 10){ 
                                cds.fullGenericListIO.add(tempCC); 
                                tempCC = new List<IO_and_Switching_Information__c>(); 
                                i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListIO.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListIO = cds.fullGenericListIO.get(cds.paginaterIO.index); 
                    }
    
    cds.nextPageIO();
    cds.previousPageIO();
    cds.updatePageIO();
    

    cds.paginaterDevd = new Paginate(devdList.size(), 10); //These lists hold the data 
        cds.fullGenericListDevd = new List<List<Development_Deliverable__c>>(); 
        cds.genericListDevd = new List<Development_Deliverable__c>(); //Break out the full list into a list of lists 
        if(devdList.size() > 0){ 
            List<Development_Deliverable__c> tempCC = new List<Development_Deliverable__c>(); 
            Integer i = 0; 
            for(Development_Deliverable__c cc : devdList){ 
                tempCC.add(cc); i++; if(i == 10){ 
                cds.fullGenericListDevd.add(tempCC); 
                tempCC = new List<Development_Deliverable__c>(); 
                i = 0; 
                } 
            } 
            if(!tempCC.isEmpty()){ 
                cds.fullGenericListDevd.add(tempCC); 
            } 
            //Gets the correct list of data to show on the page 
            cds.genericListDevd = cds.fullGenericListDevd.get(cds.paginaterDevd.index); 
        }
    cds.nextPageDevd();
    cds.previousPageDevd();
    cds.updatePageDevd();
    cds.paginaterCore = new Paginate(coreList.size(), 10); //These lists hold the data 
                    cds.fullGenericListCore = new List<List<CoresPLL__c>>(); 
                    cds.genericListCore = new List<CoresPLL__c>(); //Break out the full list into a list of lists 
                    if(coreList.size() > 0){ 
                        List<CoresPLL__c> tempCC = new List<CoresPLL__c>(); 
                        Integer i = 0; 
                        for(CoresPLL__c cc : coreList){ 
                            tempCC.add(cc); i++; if(i == 10){ 
                            cds.fullGenericListCore.add(tempCC); 
                            tempCC = new List<CoresPLL__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListCore.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListCore = cds.fullGenericListCore.get(cds.paginaterCore.index); 
                    }
    cds.nextPageCore();
    cds.previousPageCore();
    cds.updatePageCore();
    
   
    Test.setCurrentPageReference(new PageReference('Page.CDSPageAsPDF')); 
    System.currentPageReference().getParameters().put('id', cd.Id);
    cds.deletePage();
    cds.exportToExcel();
    
    cds.EditPage();
    cds.doCancel();
    cds.populateRelatedLists();
    cds.ProvideAccess();
    //system.debug('#$@@'+ userListAccProxy);
     
    Test.stopTest();
 }
 }
 static testMethod void testCDSExtensionNewRed() 
 {
 
       // List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<IO_and_Switching_Information__c> iOList;
        iOList = new List<IO_and_Switching_Information__c>();
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
       custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
         List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        
        
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id);       
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        system.debug('--opt1 --'+opt1.id );
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Primary_Option__c',opt1.Id);
        
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
        
         Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Device__c = Dev1.id;
        cd.Design_System__c = 'Cu-08';
        cd.Color_ECCN__c = 'Red';
        cd.DIW_Option_Control_Number__c = opt1.id ;
        insert cd;
        
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
        /*Prod
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G6F000003gLUe';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G6F000003gLUf';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G6F000003gLUa';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G6F000003gLUb';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        UAT
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00GN0000003syXm';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00GN0000003syXn';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00GN0000003syXi';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00GN0000003syXj';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        */
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G0l000000FQoI';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        Custom_Design__Share cshare = new Custom_Design__Share();
        cshare.UserOrGroupId = thisUser.id;
        cshare.ParentId = cd.id;
        cshare.AccessLevel = 'Read';
        //Insert cshare;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
       // atp.User__c = skipUser.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        
        insert cr;
   

        
        Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Customer_Requirement__c = opt1.id;
        
        insert de;
        
        Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',opt1.Id);
            //fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
        
        
        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
       Attachment attach = new Attachment();
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.IsPrivate=false;
       attach.ContentType = 'application/pdf';

      CDSAttachmentUploadForm obj = new CDSAttachmentUploadForm();
        
        obj.attachMap.put('CDS_HEADER_STARTSWITH',attach);
 
    Test.startTest();
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234');   
    PageReference pageRef = Page.CDSListForOpp; 
    Test.setCurrentPage(pageRef);  
    pageRef.getParameters().put('devId', Dev1.Id);
    pageRef.getParameters().put('optId', opt1.Id);
    
    
     
     
    ApexPages.StandardController sc = new ApexPages.StandardController(new Custom_Design__c() );
    CDSFormExtension cds = new CDSFormExtension(sc);
   
    cds.doSave();
    cds.AddCore();
    cds.AddIO(); 
    cds.AddDram();
    cds.AddComp();
    cds.controllerActionPageDramC();
    cds.AddCore();
    //cds.ProvideAccess();
  
    Test.stopTest();
 
 }
 }
 
 static testMethod void testCDSExtensionNewYellow() 
 {
 
       // List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<IO_and_Switching_Information__c> iOList;
        iOList = new List<IO_and_Switching_Information__c>();
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
       custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
         List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        
        
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id);       
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        system.debug('--opt1 --'+opt1.id );
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Primary_Option__c',opt1.Id);
        
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
        
         Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Device__c = Dev1.id;
        cd.Design_System__c = 'Cu-08';
        cd.Color_ECCN__c = 'Yellow';
        cd.DIW_Option_Control_Number__c = opt1.id ;
        insert cd;
        
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
        /*Prod
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G6F000003gLUe';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G6F000003gLUf';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G6F000003gLUa';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G6F000003gLUb';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        UAT
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00GN0000003syXm';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00GN0000003syXn';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00GN0000003syXi';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00GN0000003syXj';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        */
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G0l000000FQoI';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        Custom_Design__Share cshare = new Custom_Design__Share();
        cshare.UserOrGroupId = thisUser.id;
        cshare.ParentId = cd.id;
        cshare.AccessLevel = 'Read';
        //Insert cshare;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
       // atp.User__c = skipUser.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        
        insert cr;
   

        
        Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Customer_Requirement__c = opt1.id;
        
        insert de;
        
        Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',opt1.Id);
            //fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
        
        
        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
       Attachment attach = new Attachment();
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.IsPrivate=false;
       attach.ContentType = 'application/pdf';

      CDSAttachmentUploadForm obj = new CDSAttachmentUploadForm();
        
        obj.attachMap.put('CDS_HEADER_STARTSWITH',attach);
 
    Test.startTest();
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234');   
    PageReference pageRef = Page.CDSListForOpp; 
    Test.setCurrentPage(pageRef);  
    pageRef.getParameters().put('devId', Dev1.Id);
    pageRef.getParameters().put('optId', opt1.Id);
    
    
     
     
    ApexPages.StandardController sc = new ApexPages.StandardController(new Custom_Design__c() );
    CDSFormExtension cds = new CDSFormExtension(sc);
   
    cds.doSave();
    cds.AddCore();
    cds.AddIO(); 
    cds.AddDram();
    cds.AddComp();
    cds.controllerActionPageDramC();
    cds.AddCore();
    //cds.ProvideAccess();
  
    Test.stopTest();
 
 }
 }
 static testMethod void testCDSExtensionEdit(){
 
 // List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<IO_and_Switching_Information__c> iOList;
        iOList = new List<IO_and_Switching_Information__c>();
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
       custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
         List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        
         ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
      
        
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id); 
          // fieldValueOptionMap.put('Design__c',de.id);    
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        system.debug('--opt1 --'+opt1.id );
        
                  Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Number_of_Instances__c = '2';
       de.Customer_Requirement__c = opt1.id;
       
       insert de;
        
      
        
       // opt1.Design__c = de.id;
        //update opt1;
        
        
      
 
        
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Primary_Option__c',opt1.Id);
        fieldValueMap1.put('ECCN_Technology__c','3E003.b');
        fieldValueMap1.put('ECCN_Wafer__c','3E003.b');
        
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
   
        
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Device__c = Dev1.id;
        cd.Design_System__c = 'Cu-08';
        cd.Color_ECCN__c = 'Green';
        cd.DIW_Option_Control_Number__c = opt1.id ;
        insert cd;
        
        Set<ID> lstUser = new Set<ID>();
        
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');     
        insert u;
        lstUser.add(u.id);
        
        User u2 = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss1@test.com',communitynickname='tsst',FederationIdentifier='Test1');     
        insert u2;
        
        lstUser.add(u2.id);
        
        System.assertEquals(CDSSharing.ShareEdit(cd.Id,lstUser), true);
        
          Attachment attach = new Attachment();
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=cd.Id;
       attach.IsPrivate=false;
       attach.ContentType = 'application/pdf';
       insert attach;
     
        DRAMs__c dram = new DRAMs__c();
        dram.Custom_Design_Specification__c = cd.id;
        insert dram;
        
        IO_and_Switching_Information__c io = new IO_and_Switching_Information__c();
        io.Custom_Design_Specification__c = cd.id;
        insert io;
        
        CoresPLL__c cp = new CoresPLL__c();
        cp.Custom_Design_Specification__c = cd.id;
        insert cp;
        
        Development_Deliverable__c dd = new Development_Deliverable__c();
        dd.Custom_Design_Specification__c = cd.id;
        insert dd;
        
        Third_Party_Design_Contact__c pd =new Third_Party_Design_Contact__c();
        pd.Custom_Design_Specification__c =cd.id;
        insert pd;
        
     
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
      //  atp.User__c = skipUser.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        //cr.Design__c = de.id;
        
        insert cr;
   
                ASICS_Specification__c asp = new ASICS_Specification__c();
asp.Maximum_Heatsink_Shadow_Size_X_mm__c = '1234';
asp.Maximum_heatsink_shadow_size_Y_mm__c = '1234';
asp.Machine_life_K_power_on_hours_maximum__c = '1234';
asp.Machine_life_years_maximum__c = '1234';
asp.Machine_life_on_off_cycles_maximum__c = '1234';
asp.Card_Thickness_mm__c = '12';
asp.Power_Plane_Weight_oz_copper__c = '1234';
asp.Air_velocity_on_card_backside_minimum__c = '1234';
asp.Air_velocity_on_card_backside_nominal__c = '1234';
asp.Average_life_time_tempurature__c = '1234';
asp.Nominal_air_temperature_rise_machine__c = '1234';
asp.Max_air_tempe_rise_machine_to_module__c = '1234';
asp.Maximum_machine_ambent_air_temperature__c = '1234';
asp.Minimum_machine_ambient_air_temperature__c = '1234';
asp.Device__c = Dev1.Id; 
 
 insert asp; 
        

        
//        opt1.Design__c = de.Id;
        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
    Group testGroup = new Group(Name='CDS Green Zone Queue', type='Queue');
    insert testGroup;
    
        




    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Custom_Design__c' );
    insert testQueue;
  
      
 
    Test.startTest();    
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234'); 
    PageReference pageRef = Page.CDSListForOpp; 
    Test.setCurrentPage(pageRef);  
    pageRef.getParameters().put('id', cd.Id);
    pageRef.getParameters().put('devId', Dev1.Id);
    pageRef.getParameters().put('optId', opt1.Id);
    
    
     
     
    ApexPages.StandardController sc = new ApexPages.StandardController(cd);
    CDSFormExtension cds = new CDSFormExtension(sc);
    cds.targetNAID = attach.id;
   
    cds.deletedItemIndex = 0;  
   
    
    cds.reQuote();
    cds.doSave();
    cds.dis();
    cds.createDesignSystemMap();
    cds.createDependentPickList();
    cds.EditPage();
    cds.goToTechReview();
    cds.createClone();
    cds.initializeAttachmentFiles();
    cds.pdfSnapshot();
    cds.setEccnColor();
    cds.assignDesignToQueue();
    cds.doCancel();
    cds.changeStatus();
    cds.createClone();
    cds.initiateDIWFields();
    cds.updateECCN();
    //cds.initiateOptionFields(cd);
    cds.syncOption();
   // cds.AddCore();
    cds.deleteAttachments();
    cds.initiateOptionFields(cd);
  // 
    cds.AddIO(); 
    //cds.DeleteIO();   
   
   // cds.syncOption();
    cds.AddDram();
    cds.AddCore();
    cds.AddComp();
   cds.AddDevd();
    cds.AddPartyDesign(); 
    //cds.DeletePartyDesign(); 
    //cds.initiateOptionFields(cd);
      cds.DeleteDevd();
      cds.DeletePartyDesign();
      cds.DeleteCore();
      cds.DeleteDram();
      cds.DeleteComp();
      CDS.DeleteIO();
    Delete cd;
        
        System.assertEquals(CDSSharing.ShareEdit(cd.Id,lstUser), true);
        
     Test.stopTest();
 
 }
 
 
 
 }
  
     static testMethod void testCDSExtensionView() 
 {
 
  List<IO_and_Switching_Information__c> iOList;
        iOList = new List<IO_and_Switching_Information__c>();
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
       custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
         List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
     
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
      
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
       // fieldValueOptionMap.put('Device__c',dev1.id); 
          // fieldValueOptionMap.put('Design__c',de.id);    
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        system.debug('--opt1 --'+opt1.id );
        
                  Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Number_of_Instances__c = '2';
       de.Customer_Requirement__c = opt1.id;
       
       insert de;
        
      
        
        //opt1.Design__c = de.id;
       // update opt1;
        
        
      
 
        
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Primary_Option__c',opt1.Id);
        fieldValueMap1.put('ECCN_Technology__c','3E003.b');
        fieldValueMap1.put('ECCN_Wafer__c','3E003.b');
        
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
   
        
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Device__c = Dev1.id;
        cd.Lock__c = true;
        cd.Color_ECCN__c = 'Green';
        cd.Design_System__c = 'Cu-08';
        cd.DIW_Option_Control_Number__c = opt1.id ;
        insert cd;
        
          Attachment attach = new Attachment();
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=cd.Id;
       attach.IsPrivate=false;
       attach.ContentType = 'application/pdf';
       insert attach;
     
        DRAMs__c dram = new DRAMs__c();
        dram.Custom_Design_Specification__c = cd.id;
        insert dram;
        
        IO_and_Switching_Information__c io = new IO_and_Switching_Information__c();
        io.Custom_Design_Specification__c = cd.id;
        insert io;
        
        CoresPLL__c cp = new CoresPLL__c();
        cp.Custom_Design_Specification__c = cd.id;
        insert cp;
        
        Development_Deliverable__c dd = new Development_Deliverable__c();
        dd.Custom_Design_Specification__c = cd.id;
        insert dd;
        
        Third_Party_Design_Contact__c pd =new Third_Party_Design_Contact__c();
        pd.Custom_Design_Specification__c =cd.id;
        insert pd;
        
     
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
      //  atp.User__c = skipUser.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        //cr.Design__c = de.id;
        
        insert cr;
   
                ASICS_Specification__c asp = new ASICS_Specification__c();
asp.Maximum_Heatsink_Shadow_Size_X_mm__c = '1234';
asp.Maximum_heatsink_shadow_size_Y_mm__c = '1234';
asp.Machine_life_K_power_on_hours_maximum__c = '1234';
asp.Machine_life_years_maximum__c = '1234';
asp.Machine_life_on_off_cycles_maximum__c = '1234';
asp.Card_Thickness_mm__c = '12';
asp.Power_Plane_Weight_oz_copper__c = '1234';
asp.Air_velocity_on_card_backside_minimum__c = '1234';
asp.Air_velocity_on_card_backside_nominal__c = '1234';
asp.Average_life_time_tempurature__c = '1234';
asp.Nominal_air_temperature_rise_machine__c = '1234';
asp.Max_air_tempe_rise_machine_to_module__c = '1234';
asp.Maximum_machine_ambent_air_temperature__c = '1234';
asp.Minimum_machine_ambient_air_temperature__c = '1234';
asp.Device__c = Dev1.Id; 
 
 insert asp; 
        

        
//        opt1.Design__c = de.Id;
        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Opportunity__c = opp1.id;
        des.Technical_Requirement__c = opt1.id;
        insert des;
        
       Charge_Info__c crg = new Charge_Info__c();
       crg.Charge_Number__c = '123';
       crg.Option__c = opt1.id;
       crg.Charge_Type__c = 'Marketing Area Number';
       insert crg;
       
    Group testGroup = new Group(Name='CDS Green Zone Queue', type='Queue');
    insert testGroup;      
        
    QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Custom_Design__c' );
    insert testQueue;
       
 
    Test.startTest();    
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234'); 
    PageReference pageRef = Page.CDSListForOpp; 
    Test.setCurrentPage(pageRef);  
    pageRef.getParameters().put('id', cd.Id);
    pageRef.getParameters().put('devId', Dev1.Id);
    pageRef.getParameters().put('optId', opt1.Id);
    
    
     
     
    ApexPages.StandardController sc = new ApexPages.StandardController(cd);
    CDSFormExtension cds = new CDSFormExtension(sc);
    cds.targetNAID = attach.id;
  
      
    //cds.deletedItemIndex = 2;  
    
    cds.reQuote();
    cds.doSave();
    cds.dis();
    cds.createDesignSystemMap();
    cds.createDependentPickList();
    cds.EditPage();
    cds.goToTechReview();
    cds.createClone();
    cds.initializeAttachmentFiles();
    cds.pdfSnapshot();
    cds.setEccnColor();
    cds.assignDesignToQueue();
    cds.doCancel();
    cds.changeStatus();
    cds.createClone();
    cds.initiateDIWFields();
    cds.updateECCN();
    //cds.initiateOptionFields(cd);
    cds.syncOption();
   // cds.AddCore();
   // cds.DeleteDram();
   // cds.deleteAttachments();
   // cds.initiateOptionFields(cd);
  // 
    cds.AddIO(); 
    //cds.DeleteIO();   
   
   // cds.syncOption();
    cds.AddDram();
    cds.AddCore();
    cds.AddComp();
    cds.AddDevd();
    cds.AddPartyDesign(); 
   // cds.DeletePartyDesign(); 
    cds.deleteAttachments();
    //cds.initiateOptionFields(cd);
     Test.stopTest();
 }
 }
 static testMethod void testCDSExtensioninitiateDIW() 
 {
 
 List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
        custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
       
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');     
         insert u;
        Account account1 = new Account();
        account1.Name = 'Test Bnp Account1';
        account1.Short_Name__c = 'tEAccount1';
        account1.RecordTypeId = recordType.id;
        account1.Site_Department__c = 'Test';
        account1.Sub_Type__c = 'Test';
        account1.Transaction_Type__c = 'Test';
        account1.Region__c = 'US';
        account1.Corporate_Address_1__c = 'Test Address';
        account1.Corporate_City__c = 'Test City';
        account1.Corporate_Country__c = 'India';
        insert account1;
           
        Opportunity opp1 = new Opportunity();
        opp1.accountId = account1.id;
        opp1.Name = 'Test Bnp Opp';
        opp1.StageName = '1. Discovery';
        opp1.CloseDate = System.today();
        opp1.Siebel_Opportunity_Id__c = '1-OPP-200000';
        opp1.Contract_Pricing__c = 'yes';
        insert opp1;   
        
        
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
        
        /* UAT
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00GN0000003syXm';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00GN0000003syXn';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00GN0000003syXi';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00GN0000003syXj';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        */
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G0l000000FQoI';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        
        
       
        Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Color_ECCN__c = 'Green';
        insert cd;
        
        
      
        List<DRAMs__c> DramList = new List<DRAMs__c>();
        
        for(Integer i=0;i<15;I++){
            DRAMs__c dram = new DRAMs__c();
            dram.Custom_Design_Specification__c = cd.id;
            dram.DRAM_Name__c = 'Name' +i;
            DramList.add(dram);
        }
        insert DramList;
        System.assertequals(DramList.size(),15);
        
        List<IO_and_Switching_Information__c> IOList = new List<IO_and_Switching_Information__c>();
        
        for(Integer i=0;i<15;I++){
            IO_and_Switching_Information__c io = new IO_and_Switching_Information__c();
            io.Custom_Design_Specification__c = cd.id;
            IOList.add(io);
        }
        
        insert IOList;
        
        List<CoresPLL__c> coreList = new List<CoresPLL__c>();
        
        for(Integer i=0;i<15;I++){
             CoresPLL__c cp = new CoresPLL__c();
             cp.Custom_Design_Specification__c = cd.id;
             coreList.add(cp);
        }
        
       
        insert coreList;
        
        List<Compilable__c> compList =new List<Compilable__c>();
        for(Integer i=0;i<15;I++){
             Compilable__c comp = new Compilable__c();
             comp.Custom_Design_Specification__c = cd.id;
             compList.add(comp);
        }
        
       
        insert compList;
        
        List<Development_Deliverable__c> devdList = new List<Development_Deliverable__c>();
        
        for(Integer i=0;i<15;I++){
             Development_Deliverable__c dd = new Development_Deliverable__c();
             dd.Custom_Design_Specification__c = cd.id;
             devdList.add(dd);
        }
        
        insert devdList;
        
        
        
        Third_Party_Design_Contact__c pd =new Third_Party_Design_Contact__c();
        pd.Custom_Design_Specification__c =cd.id;
        insert pd;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Team_Role__c = 'Primary Account Manager';
        atp.Account__c = account1.id;
        atp.User__c = u.id; 
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Sequence_No__c='1';
        atp.Account_Role_ID__c='test1';
        insert atp;
        
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.Deliverable_Part_Number_DPN__c = '1234';
        cr.Reliability_grade_required__c = '123';
        //cr.Design__c = de.id;
        insert cr;
        
        Design__c de = new Design__c();
        de.Number_of_redundant_SRAM_bits_in_the_des__c = '1234';
        de.Utilization_The_number_of_total_gat__c = '1234';
        de.Image_Size_X_mm__c = '1234';
        de.Image_Size_Y_mm__c = '1234';
        de.Total_Levels_of_Metal__c = '1234';
        de.Levels_of_Metal_Used_For_Wiring__c = '1234';
        de.Package_total_lead_count__c = '1234';
        de.Total_number_of_latches_for_test__c = '1234';
        de.Total_number_of_scan_chains_for_test__c = '1234';
        de.Maximum_scan_chain_length_for_test_um__c = '1234';
        de.Customer_Requirement__c = cr.id;

        insert de;
        

        
        Decision__c des = new Decision__c();
        des.Account__c = account1.id;
        des.Technical_Requirement__c = cr.id;
        des.Opportunity__c = opp1.id;
        insert des;
        
        Attachment attach=new Attachment();

        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cd.Id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';
        insert attach;
        
        Map<String,attachment> attachMap = new  Map<String,attachment>();
        attachMap.put('SIGNAL_POWER_STARTSWITH',attach);
        
 
    Test.startTest();  
    system.assertEquals(de.Maximum_scan_chain_length_for_test_um__c,'1234');   
    PageReference pageRef = Page.CDSPageFrame; 
    pageRef.getParameters().put('id', String.valueOf(cd.Id));
    pageRef.getParameters().put('DecId', String.valueOf(des.Id)); 
    Test.setCurrentPage(pageRef);   
    ApexPages.StandardController sc = new ApexPages.StandardController(cd);
    CDSFormExtension cds = new CDSFormExtension(sc);
     String st = cds.xlsHeader;
     st = 'test';
    cds.targetNAID = attach.id;
   
    cds.reQuote();
    cds.doSave();
    CDS.paginaterDram = new Paginate(dramList.size(), 10); //These lists hold the data 
                    cds.fullGenericListDram = new List<List<DRAMs__c>>(); 
                    cds.genericListDram = new List<DRAMs__c>(); //Break out the full list into a list of lists 
                    if(dramList.size() > 0){ 
                        List<DRAMs__c> tempCC = new List<DRAMs__c>(); Integer i = 0; 
                        for(DRAMs__c cc : dramList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == 10){ 
                            cds.fullGenericListDram.add(tempCC); 
                            tempCC = new List<DRAMs__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListDram.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListDram = cds.fullGenericListDram.get(cds.paginaterDram.index); 
                    }
       
    //CDS.fullGenericListDram.addall(DramList);
    cds.nextPageDram();
    cds.previousPageDram();
    cds.updatePageDram();
    cds.paginaterComp = new Paginate(compList.size(), 10); //These lists hold the data 
                    cds.fullGenericListComp = new List<List<Compilable__c>>(); 
                    cds.genericListComp = new List<Compilable__c>(); //Break out the full list into a list of lists 
                    if(compList.size() > 0){ 
                        List<Compilable__c> tempCC = new List<Compilable__c>(); 
                        Integer i = 0; 
                        for(Compilable__c cc : compList){ 
                            tempCC.add(cc); i++; if(i == 10){ 
                            cds.fullGenericListComp.add(tempCC); 
                            tempCC = new List<Compilable__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListComp.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListComp = cds.fullGenericListComp.get(cds.paginaterComp.index); 
                    }
    cds.nextPageComp();
    cds.previousPageComp();
    cds.updatePageComp();
     cds.paginaterIO = new Paginate(IOList.size(), 10); //These lists hold the data 
                    cds.fullGenericListIO = new List<List<IO_and_Switching_Information__c>>(); 
                    cds.genericListIO = new List<IO_and_Switching_Information__c>(); //Break out the full list into a list of lists 
                    if(IOList.size() > 0){ 
                        List<IO_and_Switching_Information__c> tempCC = new List<IO_and_Switching_Information__c>(); 
                        Integer i = 0; 
                        for(IO_and_Switching_Information__c cc : IOList){ 
                            tempCC.add(cc); 
                            i++; 
                            if(i == 10){ 
                                cds.fullGenericListIO.add(tempCC); 
                                tempCC = new List<IO_and_Switching_Information__c>(); 
                                i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListIO.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListIO = cds.fullGenericListIO.get(cds.paginaterIO.index); 
                    }
    
    cds.nextPageIO();
    cds.previousPageIO();
    cds.updatePageIO();
    

    cds.paginaterDevd = new Paginate(devdList.size(), 10); //These lists hold the data 
        cds.fullGenericListDevd = new List<List<Development_Deliverable__c>>(); 
        cds.genericListDevd = new List<Development_Deliverable__c>(); //Break out the full list into a list of lists 
        if(devdList.size() > 0){ 
            List<Development_Deliverable__c> tempCC = new List<Development_Deliverable__c>(); 
            Integer i = 0; 
            for(Development_Deliverable__c cc : devdList){ 
                tempCC.add(cc); i++; if(i == 10){ 
                cds.fullGenericListDevd.add(tempCC); 
                tempCC = new List<Development_Deliverable__c>(); 
                i = 0; 
                } 
            } 
            if(!tempCC.isEmpty()){ 
                cds.fullGenericListDevd.add(tempCC); 
            } 
            //Gets the correct list of data to show on the page 
            cds.genericListDevd = cds.fullGenericListDevd.get(cds.paginaterDevd.index); 
        }
    cds.nextPageDevd();
    cds.previousPageDevd();
    cds.updatePageDevd();
    cds.paginaterCore = new Paginate(coreList.size(), 10); //These lists hold the data 
                    cds.fullGenericListCore = new List<List<CoresPLL__c>>(); 
                    cds.genericListCore = new List<CoresPLL__c>(); //Break out the full list into a list of lists 
                    if(coreList.size() > 0){ 
                        List<CoresPLL__c> tempCC = new List<CoresPLL__c>(); 
                        Integer i = 0; 
                        for(CoresPLL__c cc : coreList){ 
                            tempCC.add(cc); i++; if(i == 10){ 
                            cds.fullGenericListCore.add(tempCC); 
                            tempCC = new List<CoresPLL__c>(); 
                            i = 0; 
                            } 
                        } 
                        if(!tempCC.isEmpty()){ 
                            cds.fullGenericListCore.add(tempCC); 
                        } 
                        //Gets the correct list of data to show on the page 
                        cds.genericListCore = cds.fullGenericListCore.get(cds.paginaterCore.index); 
                    }
    cds.nextPageCore();
    cds.previousPageCore();
    cds.updatePageCore();
    
   
    Test.setCurrentPageReference(new PageReference('Page.CDSPageAsPDF')); 
    System.currentPageReference().getParameters().put('id', cd.Id);
    cds.deletePage();
    cds.exportToExcel();
    
    cds.EditPage();
    cds.doCancel();
    //cds.ProvideAccess();
     
    Test.stopTest();
 }
 }
 
 static testMethod void testCDSExtensioninitiateDIW12() 
 {
 
 List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        
        List<DRAMs__c> dmList;
        dmList = new List<DRAMs__c>();
        
        List<CoresPLL__c> cpList;
        cpList = new List<CoresPLL__c>();
        List<Compilable__c> cmpList;
        cmpList = new List<Compilable__c>();
        List<Development_Deliverable__c> ddList;
        ddList = new List<Development_Deliverable__c>();
        List<Third_Party_Design_Contact__c> pdList;
        pdList = new List<Third_Party_Design_Contact__c>();
        List<CDS_Color_zone__c> custSet;
        custSet = new List<CDS_Color_zone__c>();
        List<Clock_Characteristics__c> clockList;
        clockList = new List<Clock_Characteristics__c>();
        
       
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');     
         insert u;
        Account account1 = new Account();
        account1.Name = 'Test Bnp Account1';
        account1.Short_Name__c = 'tEAccount1';
        account1.RecordTypeId = recordType.id;
        account1.Site_Department__c = 'Test';
        account1.Sub_Type__c = 'Test';
        account1.Transaction_Type__c = 'Test';
        account1.Region__c = 'US';
        account1.Corporate_Address_1__c = 'Test Address';
        account1.Corporate_City__c = 'Test City';
        account1.Corporate_Country__c = 'India';
        insert account1;
           
        Opportunity opp1 = new Opportunity();
        opp1.accountId = account1.id;
        opp1.Name = 'Test Bnp Opp';
        opp1.StageName = '1. Discovery';
        opp1.CloseDate = System.today();
        opp1.Siebel_Opportunity_Id__c = '1-OPP-200000';
        opp1.Contract_Pricing__c = 'yes';
        insert opp1;   
        
        
        ItarCipherCloud__c cs = new ItarCipherCloud__c();
        cs.name= 'ViewPageMessage';
        cs.Message__c = '12345';
        Insert cs;
        
        ItarCipherCloud__c cs1 = new ItarCipherCloud__c();
        cs1.name='PDFExcelMessage';
        cs1.Message__c='12345';
        Insert cs1;
        ItarCipherCloud__c cs2 = new ItarCipherCloud__c();
        cs2.name='ViewPageMessageRed';
        cs2.Message__c='12345';
        Insert cs2;
        ItarCipherCloud__c cs3 = new ItarCipherCloud__c();
        cs3.name='ViewPageMessageRedCC';
        cs3.Message__c='12345';
        Insert cs3;
        
        /* UAT
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00GN0000003syXm';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00GN0000003syXn';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00GN0000003syXi';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00GN0000003syXj';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        */
        CDSAccess__c cda =  new CDSAccess__c();
        cda.name = 'IDs';
        cda.Red__c ='00G0l000000FQoI';
        cda.Orange__c ='00G6F000002qF0p';
        cda.Yellow__c ='00G0l000000FQoJ';
        cda.Green__c ='00G6F000002qF0o';
        Insert cda;
        
        CDSAccess__c cds1 =  new CDSAccess__c();
        cds1.name = 'Queue';
        cds1.Red__c ='00G0l000000FQoE';
        cds1.Orange__c ='00G6F000002qF0m';
        cds1.Yellow__c ='00G0l000000FQoF';
        cds1.Green__c ='00G6F000002qF0l';
        Insert cds1;
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
       
       Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
         
        
    Custom_Design__c cd = new Custom_Design__c();
        cd.Customer__c = account1.id;
        cd.CDS_Status__c = 'Draft';
        cd.Color_ECCN__c = 'Green';
        insert cd;
        
 
    Test.startTest();  
    PageReference pageRef = Page.CDSPageFrame; 
    pageRef.getParameters().put('id', String.valueOf(cd.Id));
    pageRef.getParameters().put('DevId', Dev1.id ); 
    ApexPages.StandardController sc = new ApexPages.StandardController(cd);
    CDSFormExtension cds = new CDSFormExtension(SC);
    Delete cd;
    cds.createClone();

    Test.stopTest();
 }
 }
    }