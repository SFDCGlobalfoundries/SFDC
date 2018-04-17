@isTest(SeeAllData=false)
public class DWC_Attachment_WebserviceCallTest {
    
    static testMethod void designWaiverAttachMethod(){
        Test.setMock(WebServiceMock.class, new testWebServiceMockImpl());
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
		
        Queryptsrattachments.QueryPTSRAttachmentService_pt ptsrObj = new Queryptsrattachments.QueryPTSRAttachmentService_pt();
        List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> lstdwcAttachments = new list<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType>();
        Queryptsrattachments.GetPTSRAttachmentResponseDetailsType obj = new Queryptsrattachments.GetPTSRAttachmentResponseDetailsType();
        obj.PTSRNumber = 'PTSR-XXXX-000';
        obj.FileID = '10000001';
         obj.PTSRID = '1000008001';
         obj.Reference = 'Reference';
         obj.FileName = 'Test FileName';
         obj.ContentType = 'Attachment';
         obj.AttachTo = 'Test Collaborator';
         obj.FileSize = '2';
         obj.CreatedDate = '2015-09-09T16:56:33.75-07:00';
         obj.CreatedBy = 'test User';
         obj.ModifedDate = '2015-09-09T16:56:33.75-07:00';
         obj.ModifiedBy = 'test User';
        lstdwcAttachments.add(obj);
		List<String> str = new List<String>();
		str.add('20150909');
		str.add('165633.750700');        
        String ptsrNo = lstdwcAttachments[0].PTSRNumber;
        String src = '2015-09-09T16:56:33.75-07:00';
        DWC_Attachment_WebserviceCall.PTSRRequestElements ptsrreqElem = new DWC_Attachment_WebserviceCall.PTSRRequestElements();
        DWC_Attachment_WebserviceCall.PTSRResponseElements ptsrrespElem = new DWC_Attachment_WebserviceCall.PTSRResponseElements('10000091','PTSR-XXXX-000',waiverColl.Id,'Test DWC','Open','Test Error Message','Test@gfoundries.com');
              
        Test.startTest();        
            DWC_Attachment_WebserviceCall designWaiverAtt = new DWC_Attachment_WebserviceCall ();
            DWC_Attachment_WebserviceCall.createWaiverCollaboratorAttachment(ptsrreqElem);
            DWC_Attachment_WebserviceCall.constructDate(src);
            DWC_Attachment_WebserviceCall.setDWCAttachmentDetails(lstdwcAttachments,waiverColl.Id);
        Test.stopTest();
            System.assertEquals(lstdwcAttachments, lstdwcAttachments);
    }
}