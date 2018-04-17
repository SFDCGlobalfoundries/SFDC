@isTest(SeeAllData=false)
private class DRCWaiverCollaboratorControllerTest1{
    
   
    static testMethod void myDesignWaiverMethod7() {
 
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
             
        Account acc = AccountDataFactory.createAccount(fieldValueMap);      
        
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
                     
            Wavier_Collaborator__c waiverColl1 = DesignCollaboratorTestData.getWaiverCollaborator4DRC(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id);   
            waiverColl1.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl1.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl1.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR(waiverColl1.Id);
            //list<Waiver_Rule_List__c>  waiverCollList1 = DesignCollaboratorTestData.getWaiverRuleList(waiverColl1.Id); 
			  
            Wavier_Collaborator__c waiverColl11 = DesignCollaboratorTestData.getWaiverCollaborator8(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id );
        	waiverColl11.Is_Sync_with_AIA__c = true;
        	waiverColl11.IsGfAcceptsRisk__c = true;
            waiverColl11.IsSubmitted__c = true;
        	update waiverColl11;
            waiverColl11.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl11.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl11.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl11.Id);
            list<Waiver_Rule_List__c>  waiverCollList11 = DesignCollaboratorTestData.getWaiverRuleList(waiverColl11.Id);
        	system.debug('waiverColllist Primedie:'+waiverCollList11);
        	
            Test.startTest();
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList11.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl11);        
            DWC_CollaboratorCtrl designWaiver = new DWC_CollaboratorCtrl (stdController);

        	System.debug('Primedieval:'+waiverCollList11[0].Prime_Die_Name__c);
            system.debug('DFM_Id'+waiverColl11.DFM_Transaction_Id__c);

            String collabId = String.valueOf(waiverColl11.Id);
            designWaiver.hiddenUsrIds = userSU.Id;
            designWaiver.approverejectcomments = 'Comments';
            designWaiver.wfRevertReason = 'Reason Comments';
        	designWaiver.drbGroup = 'Group Name';
        	designWaiver.PtsrLink = 'http://ptrlink.com';
            waiverColl11.Is_All_PI_PW__c=TRUE;
        
        	
           /* ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl11);        
            DWC_CollaboratorCtrl designWaiver1 = new DWC_CollaboratorCtrl (stdController1);*/
           /* String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList11){
                strr1+=ruleList.Id+';';
            }*/
           DWC_CollaboratorCtrl.saveRuleList(waiverCollList11,collabId);

            designWaiver.releaseToCustomer();
            designWaiver.cancelWorkflow();
            designWaiver.pdfDownload();
            designWaiver.fetchAllRelatedUsers();
            DWC_CollaboratorCtrl.backToMainPage();
            DWC_CollaboratorCtrl.checkMandatoryFields(waiverColl11);
            DWC_CollaboratorCtrl.submitRuleList(waiverCollList11,collabId);
            designWaiver.reload();
                              
            Test.stopTest();
        
        	System.AssertEquals(waiverColl11.Is_All_PI_PW__c = true,true);
        }  
}