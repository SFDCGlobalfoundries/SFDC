@isTest(SeeAllData=false)
private class DWC_WaiverCollaboratorControllerTest {
    static testMethod void myDesignWaiverMethod(){
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
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id);  
            waiverColl.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        	waiverColl.IsSubmitted__c=true;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl.Id);
            list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
        	waiverCollList[0].Prime_Die_Name__c = 'Prime die1';
            waiverCollList[0].Rule_Type__c = '1';
            waiverCollList[0].Final_Stage__c='PWO';
            update waiverCollList;
            
        
            String collabId = String.valueOf(waiverColl.Id);
            
            Test.startTest();
            
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver = new DWC_WaiverCollaboratorController (stdController);

        	PageReference pageRef = Page.DWC_WaiverCollaboratorPDF; // Add your VF page Name here
 			pageRef.getParameters().put('primeDie', 'Prime die1');
  			Test.setCurrentPage(pageRef);
        
            PageReference pageRef1 = Page.DWC_WaiverCollaboratorPDF; // Add your VF page Name here
 			pageRef1.getParameters().put('ruleType', 'Mandatory');
  			Test.setCurrentPage(pageRef1);
                                        
            designWaiver.hiddenUsrIds = userSU.Id;
        	//waiverColl.PTSR_Status__c ='Approved';
        	waiverColl.Revert_Collaborator__c = true;
        	//waiverColl.Is_All_PI_PW__c=TRUE;
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver1 = new DWC_WaiverCollaboratorController (stdController1);
            String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList){
                strr1+=ruleList.Id+';';
            }
        	designWaiver.getTaskMessage4Internal(waiverColl);
        	designWaiver.getTaskMessage4Customer(waiverColl);
        	designWaiver.getWaiverCollaborator(waiverColl.Id);
        	designWaiver.getChipDetails(waiverColl.Id);
        	Test.stopTest();
        	System.assertEquals(waiverColl.Revert_Collaborator__c = true,true);
    }
        static testMethod void myDesignWaiverMethod01(){
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
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTemplate5(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id);  
            waiverColl.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        	waiverColl.IsSubmitted__c=true;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl.Id);
            list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
            waiverCollList[0].Prime_Die_Name__c = 'Prime die1';
            waiverCollList[0].Final_Stage__c='FD';
            waiverCollList[0].Rule_Type__c = '0';
            waiverCollList[0].Prime_Die_Comment__c= 'test:comment';
            
            update waiverCollList;
            Test.startTest();
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver = new DWC_WaiverCollaboratorController (stdController);
            
            PageReference pageRef = Page.DWC_WaiverCollaboratorPDF; // Add your VF page Name here
 			pageRef.getParameters().put('primeDie', 'Prime die1');
  			Test.setCurrentPage(pageRef);
        
            PageReference pageRef1 = Page.DWC_WaiverCollaboratorPDF; // Add your VF page Name here
 			pageRef1.getParameters().put('ruleType', 'Additional');
  			Test.setCurrentPage(pageRef1);        
        	String collabId = String.valueOf(waiverColl.Id);
            designWaiver.hiddenUsrIds = userSU.Id;
            
        	String progressBarStatus = waiverColl.Progressbar_staus__c;
            progressBarStatus ='Review_Disposition';
            String waiverStatus = waiverColl.Waiver_Status__c;
        	waiverStatus = 'Open';
        	waiverColl.PTSR_Status__c ='Approved';
        	waiverColl.Is_Sync_with_AIA__c = false;
        	waiverColl.Is_All_PI_PW__c=TRUE;
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver1 = new DWC_WaiverCollaboratorController (stdController1);
            String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList){
                strr1+=ruleList.Id+';';
            }
        	designWaiver.getTaskMessage4Internal(waiverColl);
        	designWaiver.getTaskMessage4Customer(waiverColl);
        	designWaiver.getWaiverCollaborator(waiverColl.Id);
        	designWaiver.getChipDetails(waiverColl.Id);
        	Test.stopTest();
        	System.assertEquals(waiverColl.Is_All_PI_PW__c = true,true);
    }
    static testMethod void myDesignWaiverMethod02(){
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
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTemplate5(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id);  
            waiverColl.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        	waiverColl.IsSubmitted__c=true;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl.Id);
            list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
            waiverCollList[0].Final_Stage__c='PW';
            update waiverCollList;
            Test.startTest();
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver = new DWC_WaiverCollaboratorController (stdController);
        	
        	String collabId = String.valueOf(waiverColl.Id);
            designWaiver.hiddenUsrIds = userSU.Id;
            
        	waiverColl.Progressbar_staus__c = 'Review_Disposition';
            String waiverStatus = waiverColl.Waiver_Status__c;
            waiverStatus = 'Open';
            waiverColl.PTSR_Status__c ='Approved';
            waiverColl.Is_Sync_with_AIA__c = false;
            waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
            waiverColl.Is_Submit_4_DFM_Apprval__c=true;
            waiverColl.DRCServiceoption__c='DRC Run Only';
            update waiverColl;
            //waiverColl.Is_All_PI_PW__c=TRUE;
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver1 = new DWC_WaiverCollaboratorController (stdController1);
            String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList){
                strr1+=ruleList.Id+';';
            }
        	designWaiver.getTaskMessage4Internal(waiverColl);
			designWaiver.getTaskMessage4Customer(waiverColl);
        	Test.stopTest();
        	System.assertEquals(waiverColl.Progressbar_staus__c = 'Review_Disposition','Review_Disposition');
    }
    static testMethod void myDesignWaiverMethod03(){
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
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDRCTemplate5(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id);  
            waiverColl.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
        	waiverColl.IsSubmitted__c=true;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl.Id);
            list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id);
            waiverCollList[0].Final_Stage__c = 'PWA';
            waiverCollList[0].Rule_Type__c = '1';
            waiverCollList[0].GF_Internal_Closing_Comment__c='test';
            waiverCollList[0].Prime_Die_Name__c='Prime Die';
            
            update waiverCollList;
            Waiver_Rule_List__c Wrule=new Waiver_Rule_List__c();
            Wrule.Prime_Die_Comment__c='test:test';
            Wrule.Waiver_Collaborator__c=waiverColl.Id;
            insert Wrule;
            Test.startTest();
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver = new DWC_WaiverCollaboratorController (stdController);
        
        	String collabId = String.valueOf(waiverColl.Id);
        	String pValue = 'All';
            designWaiver.hiddenUsrIds = userSU.Id;
            
        	waiverColl.Progressbar_staus__c = 'Pending For Foundry';
            String waiverStatus = waiverColl.Waiver_Status__c;
            waiverStatus = 'Open';
            waiverColl.PTSR_Status__c ='Freeze';
            waiverColl.Is_Sync_with_AIA__c = true;
            
            waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
            update waiverColl;
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl);        
            DWC_WaiverCollaboratorController designWaiver1 = new DWC_WaiverCollaboratorController (stdController1);
            String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList){
                strr1+=ruleList.Id+';';
            }
            designWaiver.getTaskMessage4Internal(waiverColl);
            designWaiver.getTaskMessage4Customer(waiverColl);
            DWC_WaiverCollaboratorController.wrapperForComments wrap = new DWC_WaiverCollaboratorController.wrapperForComments(Wrule);
            Test.stopTest();
            System.assertEquals(waiverColl.Progressbar_staus__c = 'Review_Disposition','Review_Disposition');
    }
}