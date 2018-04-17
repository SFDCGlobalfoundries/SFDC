/*
    @Author :- SUHAS BARGI
*/
@isTest(SeeAllData=false) 
private class DRC_DesignWaiverCollaboratorServiceTest {  
  
    static testMethod void myDRCCollaboratorServiceMethod() {
        Test.setMock(WebServiceMock.class, new DRC_DesignWaiverCollaboratorMockImpl());
                recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
    
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        
        
           Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                                   emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                                   localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                                   timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
        }

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollabDRC(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
        waiverColl.Progressbar_staus__c = 'Review_Disposition';
        waiverColl.DFM_Service_MCDMAS__c = true;
        waiverColl.DFM_Service_DRCPLUS__c = true;
        waiverColl.CMP__c = true;
        update waiverColl;
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt endPt = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
        List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType> lstRuleInfo = new List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType>();
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
        ruleInfo.PTSRNumber = 'PTSR-XXXX-000';
        ruleInfo.DevideId = 'DEVICEID1234';
       /* ruleInfo.CustomerName = 'Customer 1';
        ruleInfo.MasksetTitle = 'Maskset';
        ruleInfo.CRMDID = '000928839'; 
        ruleInfo.ProcessID = '199985675';
        ruleInfo.Technology = 'Techno 1';
        ruleInfo.DesignRuleSpec = 'Test Design';
        ruleInfo.DRCTitle = 'DRC';
        ruleInfo.TopCell = 'Cell 1';
        ruleInfo.MetalStack = 'Metal 1';
        ruleInfo.DesignRuleAddSpec = 'Design Rule Spec 1';
        ruleInfo.DRCAddTitle = 'DRC ADD Title1';
        ruleInfo.ViolationCountLimit = '10';
        ruleInfo.MaskLayer = '1';
        ruleInfo.GroupEmailId = 'test@Test.com';
        ruleInfo.FileNameSize = '2';
        ruleInfo.DFMType = 'DFM1';
        ruleInfo.MemberList = 'List';
        ruleInfo.PrimeDieComments = 'Comments 2';*/
        lstRuleInfo.add(ruleInfo);
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element NMRulesList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element();
        lstRuleInfo[0].nm_rules = NMRulesList;
        system.debug('NMRulesList&&&&& :'+NMRulesList);
       // List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element> lstNmRuleList = new List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element>();
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element NmRuleList1 = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element();

        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[] NMRuleList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[]{};
        NmRuleList1.customer_comment = 'Comments';
        NmRuleList1.fab_comments = 'Fab Comments';
        NmRuleList1.id = '1212121';
        NmRuleList1.nm_rulename = 'Test_ruleName';
        NmRuleList1.status = 'Open';
        NMRuleList.add(NmRuleList1);
        system.debug('NMRuleList:'+NMRuleList);
        NMRulesList.nm_rule = NMRuleList;
        
   

        
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt obj=new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
        obj.GetMantisPTSRMetaData(123,'DRC');
        DRC_QueryRuleInfoFromMantisStub.ViolationReportType ruleVoilation = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
        
        Chip__c chipObj = new Chip__c();
        chipObj.Chip_Name__c = ruleInfo.DevideId;
        chipObj.Wavier_Collaborator__c = waiverColl.Id;
        chipObj.MantisId1__c=ruleInfo.MantisId;
        chipObj.MantisId2__c=ruleInfo.MantisId;
        chipObj.PrimeDieComments1__c=ruleInfo.PrimeDieComments;
        chipObj.PrimeDieComments2__c=ruleInfo.PrimeDieComments;
        chipObj.Mantis_DRCPLUS__c= true;
        chipObj.Mantis_MAS__c = true;
        chipObj.Mantis_MCD__c = true;
		chipObj.Mantis_CMP__c=true;        
        chipObj.PDK_DRC__c =true;
        insert chipObj;

        List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element> lstRequest_x = new List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element>();
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element request_x = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element();
        request_x.MantisId = Integer.valueOf(waiverColl.MantisId__c);
        request_x.Type_x = 'DRC';
        lstRequest_x.add(request_x);
    
        String imgBody = '<img src="/servlet/servlet.FileDownload?file=" alt=" " height="100" width="100" border="0"/>';
        String fName = 'FAB1';
        Integer mantisId = lstRequest_x[0].MantisId;
        Integer ruleId = 121221;
        String ptsrNo = waiverColl.PTSR_Number__c;
        Boolean isSynced = TRUE;
        String message = '';
        String rid='aE1N00000000064KAA';
        String ruleIDString = 'RuleID123';
        String reviewDisp = String.valueOf(waiverColl.Progressbar_staus__c);
        

        
        DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements snpShotElements = new DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements();
        
        DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements ruleElements = new DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements(); 

        Test.startTest();
        
        DRC_DesignWaiverCollaboratorService.getDrcRules(mantisId, ptsrNo,'','');
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);    
        DRC_DesignWaiverCollaboratorService.addAttachment(imgBody, fName, mantisId, ruleId,rid);
              
        DRC_DesignWaiverCollaboratorService.setDrcRulesSnapshots(snpShotElements); 
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);
        DRC_DesignWaiverCollaboratorService.isSyncWithAIA(ruleIDString, isSynced, message);
        DRC_DesignWaiverCollaboratorService.updateDispositionValue(ptsrNo,reviewDisp);
        DRC_DesignWaiverCollaboratorService.isSyncWithMantis(waiverColl,ruleInfo);
        DRC_DesignWaiverCollaboratorService.setDRCHeaderInfo(ruleInfo);
        Test.stopTest();
        system.assertEquals(true,isSynced);
    
            
 }
 
 static testMethod void myDRCCollaboratorServiceMethod2() {
        Test.setMock(WebServiceMock.class, new DRC_DesignWaiverCollaboratorMockImpl());
                recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
    
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        
        
           Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                                   emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                                   localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                                   timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
        }

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator4DFM_1(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
        waiverColl.Progressbar_staus__c = 'Review_Disposition';
        update waiverColl;
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt endPt = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
        List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType> lstRuleInfo = new List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType>();
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
        ruleInfo.PTSRNumber = 'PTSR-XXXX-000';
        ruleInfo.DevideId = 'DEVICEID1234';
       /* ruleInfo.CustomerName = 'Customer 1';
        ruleInfo.MasksetTitle = 'Maskset';
        ruleInfo.CRMDID = '000928839'; 
        ruleInfo.ProcessID = '199985675';
        ruleInfo.Technology = 'Techno 1';
        ruleInfo.DesignRuleSpec = 'Test Design';
        ruleInfo.DRCTitle = 'DRC';
        ruleInfo.TopCell = 'Cell 1';
        ruleInfo.MetalStack = 'Metal 1';
        ruleInfo.DesignRuleAddSpec = 'Design Rule Spec 1';
        ruleInfo.DRCAddTitle = 'DRC ADD Title1';
        ruleInfo.ViolationCountLimit = '10';
        ruleInfo.MaskLayer = '1';
        ruleInfo.GroupEmailId = 'test@Test.com';
        ruleInfo.FileNameSize = '2';
        ruleInfo.DFMType = 'DFM1';
        ruleInfo.MemberList = 'List';
        ruleInfo.PrimeDieComments = 'Comments 2';*/
        lstRuleInfo.add(ruleInfo);
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element NMRulesList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element();
        lstRuleInfo[0].nm_rules = NMRulesList;
        system.debug('NMRulesList&&&&& :'+NMRulesList);
       // List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element> lstNmRuleList = new List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element>();
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element NmRuleList1 = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element();

        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[] NMRuleList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[]{};
        NmRuleList1.customer_comment = 'Comments';
        NmRuleList1.fab_comments = 'Fab Comments';
        NmRuleList1.id = '1212121';
        NmRuleList1.nm_rulename = 'Test_ruleName';
        NmRuleList1.status = 'Open';
        NMRuleList.add(NmRuleList1);
        system.debug('NMRuleList:'+NMRuleList);
        NMRulesList.nm_rule = NMRuleList;
        
   

        
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt obj=new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
        obj.GetMantisPTSRMetaData(123,'DRC');
        DRC_QueryRuleInfoFromMantisStub.ViolationReportType ruleVoilation = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
        
        Chip__c chipObj = new Chip__c();
        chipObj.Chip_Name__c = ruleInfo.DevideId;
        chipObj.Wavier_Collaborator__c = waiverColl.Id;
        chipObj.MantisId1__c=ruleInfo.MantisId;
        chipObj.MantisId2__c=ruleInfo.MantisId;
        chipObj.PrimeDieComments1__c=ruleInfo.PrimeDieComments;
        chipObj.PrimeDieComments2__c=ruleInfo.PrimeDieComments;
        chipObj.Mantis_DRCPLUS__c= true;
        chipObj.Mantis_MAS__c = true;
        chipObj.Mantis_MCD__c = true;
     	chipObj.Mantis_CMP__c=true;
        
        insert chipObj;

        List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element> lstRequest_x = new List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element>();
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element request_x = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element();
        request_x.MantisId = Integer.valueOf(waiverColl.MantisId__c);
        request_x.Type_x = 'DRC';
        lstRequest_x.add(request_x);
    
        String imgBody = '<img src="/servlet/servlet.FileDownload?file=" alt=" " height="100" width="100" border="0"/>';
        String fName = 'FAB1';
        Integer mantisId = lstRequest_x[0].MantisId;
        Integer ruleId = 121221;
        String ptsrNo = waiverColl.PTSR_Number__c;
        Boolean isSynced = TRUE;
        String message = '';
        String rid='aE1N00000000064KAA';
        String ruleIDString = 'RuleID123';
        String reviewDisp = String.valueOf(waiverColl.Progressbar_staus__c);
        

        
        DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements snpShotElements = new DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements();
        
        DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements ruleElements = new DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements(); 

        Test.startTest();
        
        DRC_DesignWaiverCollaboratorService.getDrcRules(mantisId, ptsrNo,'','');
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);    
        DRC_DesignWaiverCollaboratorService.addAttachment(imgBody, fName, mantisId, ruleId,rid);
              
        DRC_DesignWaiverCollaboratorService.setDrcRulesSnapshots(snpShotElements); 
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);
        DRC_DesignWaiverCollaboratorService.isSyncWithAIA(ruleIDString, isSynced, message);
        
        
        //DRC_DesignWaiverCollaboratorService.setDRCHeaderInfo(ruleInfo);
        Test.stopTest();
        DRC_DesignWaiverCollaboratorService.isSyncWithMantis(waiverColl,ruleInfo);
        DRC_DesignWaiverCollaboratorService.updateDispositionValue(ptsrNo,reviewDisp);
        system.assertEquals(true,isSynced);
    
            
 }
    
    static testMethod void myDRCCollaboratorServiceMethod1() { 
                        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PFAE');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
    
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
    
        Account account = AccountDataFactory.createAccount(fieldValueMap);
        
        
           Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
                             AND isActive = true
                            ].get(0);
        User userSU = new User();
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                                   emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                                   localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                                   timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            
            insert userSU;
            
        }

        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollabDRC(userSU.FederationIdentifier, userSU.FederationIdentifier, account.Id);
        //waiverColl.DFM_Service_MCDMAS__c = true;
        //waiverColl.DFM_Service_DRCPLUS__c = true;
         waiverColl.CMP__c = true;
        
        
        List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element> lstRequest_x = new List<DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element>();
        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element request_x = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataRequest_element();
        request_x.MantisId = Integer.valueOf(waiverColl.MantisId__c);
        request_x.Type_x = 'DRC';
        lstRequest_x.add(request_x);
    
        DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements snpShotElements = new DRC_DesignWaiverCollaboratorService.DRCSnapshotResponseElements();
        DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements ruleElements = new DRC_DesignWaiverCollaboratorService.DRCRuleResponseElements(); 
        
        Test.setMock(WebServiceMock.class, new DRC_DesignWaiverCollaboratorMockImpl());     
        DRC_QueryRuleInfoFromMantisStub.ViolationReportType ruleVoilation = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();


        DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt endPt = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
        List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType> lstRuleInfo = new List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType>();
        DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
        ruleInfo.PTSRNumber = 'PTSR-XXXX-000';
        ruleInfo.DevideId = 'DEVICEID1234';
        lstRuleInfo.add(ruleInfo);
       //list<Waiver_Rule_List__c> WaiverRulelist= [select id,RuleId__c,Revert_Rule__c from Waiver_Rule_List__c];
        Waiver_Rule_List__c WaiverRulelist = new Waiver_Rule_List__c();
        WaiverRulelist.Waiver_Collaborator__c=waiverColl.Id; 
        WaiverRulelist.RuleId__c =121221;
        WaiverRulelist.Revert_Rule__c = true;
        insert WaiverRulelist;
               
        Chip__c chipObj = new Chip__c();
        chipObj.Chip_Name__c = ruleInfo.DevideId;
        chipObj.Wavier_Collaborator__c = waiverColl.Id;
        //chipObj.MantisId1__c=ruleInfo.MantisId;
        chipObj.MantisId2__c=ruleInfo.MantisId;
        //chipObj.PrimeDieComments1__c=ruleInfo.PrimeDieComments;
        chipObj.PrimeDieComments2__c=ruleInfo.PrimeDieComments;
        chipObj.Mantis_MCD__c = true;
        chipObj.Mantis_DRCPLUS__c = true;
        chipObj.Mantis_MAS__c=true;
        chipObj.Mantis_CMP__c=true;
        insert chipObj;
        
        String imgBody = '<img src="/servlet/servlet.FileDownload?file=" alt=" " height="100" width="100" border="0"/>';
        String fName = 'FAB1';
        Integer mantisId = lstRequest_x[0].MantisId;
        //Integer ruleId = 121221;
        Integer ruleId = Integer.valueOf(WaiverRulelist.RuleId__c);
        String ptsrNo = waiverColl.PTSR_Number__c;
        Boolean isSynced = TRUE;
        String message = '';
        String rid='abc1234';
        String ruleIDString = 'RuleID123'; 
        
        Test.StartTest();
        DRC_DesignWaiverCollaboratorService.getDrcRules(mantisId, ptsrNo,'','');
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);    
        DRC_DesignWaiverCollaboratorService.addAttachment(imgBody, fName, mantisId, ruleId,rid);
        DRC_DesignWaiverCollaboratorService.setDrcRulesSnapshots(snpShotElements); 
        DRC_DesignWaiverCollaboratorService.setDesignRuleInfo(ruleElements);
        DRC_DesignWaiverCollaboratorService.isSyncWithAIA(ruleIDString, isSynced, message);
        update waiverColl;
        Test.stopTest();
        system.assertEquals(true,isSynced);
            
 }
 
}