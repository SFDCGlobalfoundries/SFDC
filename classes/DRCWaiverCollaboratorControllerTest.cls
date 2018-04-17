/* 
@Author :- Suhas Bargi
*/

@isTest(SeeAllData=true)
private class DRCWaiverCollaboratorControllerTest {
    
    
    static testMethod void myDesignWaiverMethod() {  
        
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
                         and developername = 'GLOBALFOUNDRIES_Internal'
                        ];
        Account acc = new Account(
            name = 'TEST rec12',
            recordtypeid = rt.id,
            stage__c = 'Qualified',
            short_name__c = 'TESTrec12',
            sub_type__c = 'Direct',
            Approval_Request__c='Account Details Change',
            Fab_9_10__c='Yes',
            //Preferred_Invoice_Delivery_Option__c='Email PDF Copy',
            Invoice_Delivery_Email__c='test@gmail.com',
            site_department__c = 'test dept',
            transaction_type__c = 'Transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
            Bill_To_Address_1__c = '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c = 'Lee',
            Corporate_Country__c = 'Japan',
            Bill_To_Country__c = 'Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c = '',
            Target_Account__c = 'Yes',
            siebel_account_id__c = '1111'
        );
        
        insert acc;
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
            waiverColl.LastRuleSelected_Customer__c='16541;16541;16541';
        	waiverColl.IsSubmitted__c=true;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl.Id);
            list<Waiver_Rule_List__c>  waiverCollList = DesignCollaboratorTestData.getWaiverRuleList(waiverColl.Id); 
            
            Wavier_Collaborator__c waiverColl1 = DesignCollaboratorTestData.getWaiverCollaborator9(userSU.FederationIdentifier,userSU.FederationIdentifier,acc.Id); 
            waiverColl1.LastRuleSelected_Customer__c=userSU.FederationIdentifier+';'+userSU.FederationIdentifier;
            DesignCollaboratorTestData.getWaiverRuleListForiFDWCR(waiverColl1.Id);
            DesignCollaboratorTestData.getWaiverRuleListForiFDWEA(waiverColl1.Id);
            DesignCollaboratorTestData.getWaiverRuleListForFDCCWCR1(waiverColl1.Id);
            list<Waiver_Rule_List__c>  waiverCollList1 = DesignCollaboratorTestData.getWaiverRuleList(waiverColl1.Id); 
            
            Attachment   atc = DesignCollaboratorTestData.getAttachmentTestData(waiverCollList.get(1).Id) ;       
            ApexPages.StandardController stdController = new ApexPages.StandardController(waiverColl);        
            DRCWaiverCollaboratorController designWaiver = new DRCWaiverCollaboratorController(stdController);
            designWaiver.pageValue='2';
            designWaiver.searchValue ='Closed';
            designWaiver.hiddenUsrIds = userSU.Id;
            designWaiver.customerOptions = waiverCollList.get(1).Id+',GfAcceptsRisk;';
            DRCWaiverCollaboratorController.ruleListTableWrapper ruleLstTableWrap  = new DRCWaiverCollaboratorController.ruleListTableWrapper(true, waiverCollList.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
            Test.startTest();
            designWaiver.customerOptions = waiverCollList1.get(1).Id+',GfAcceptsRisk;';
            DRCWaiverCollaboratorController.ruleListTableWrapper ruleLstTableWrap1  = new DRCWaiverCollaboratorController.ruleListTableWrapper(true, waiverCollList1.get(0), 'ruleListTableWrapper test', 'ruleListTableWrapper test', 'Attachment test', 'Selected',false);
            List<DRCWaiverCollaboratorController.ruleListTableWrapper> ruleLstTableWrapList = new List<DRCWaiverCollaboratorController.ruleListTableWrapper>();
            ruleLstTableWrapList.add(ruleLstTableWrap);
            ruleLstTableWrapList.add(ruleLstTableWrap1); 
            designWaiver.ruleListWrapper = ruleLstTableWrapList;
            String strr=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList){
                strr+=ruleList.Id+';';
            }
            designWaiver.singleRecId=strr;
            
            pageReference pgRef = designWaiver.saveRules();
            ruleLstTableWrapList = designWaiver.getWaiverRuleRecords();
            
            map<String, List<Attachment>> attachmentMap = designWaiver.getWaiverRuleAttachmentTable();
            pgRef =designWaiver.releaseToCustomer();
            designWaiver.fetchAllRelatedUsers();
            designWaiver.setUpPiyeAndQAUsers();     
            designWaiver.searchRule();
            designWaiver.pageNumberChange();
            pageReference pgRefnew = designWaiver.backToList();  
            designWaiver.previous();
            designWaiver.next();
            designWaiver.first();
            designWaiver.last();   
            
            designWaiver.changeFinalStatus();
            
            List<SelectOption> selectionList = new  List<SelectOption>(designWaiver.getOptions());        
            
            List<List<DRCWaiverCollaboratorController.UserWrapperCls>> usrWrp = new List<List<DRCWaiverCollaboratorController.UserWrapperCls>>(designWaiver.getCustomerDetails());        
            
            List<DRCWaiverCollaboratorController.AMwrapperCls> amWrp = new List<DRCWaiverCollaboratorController.AMwrapperCls>(designWaiver.getAMDetails()); 
            
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(waiverColl1);        
            DRCWaiverCollaboratorController designWaiver1 = new DRCWaiverCollaboratorController(stdController1);
            String strr1=';';
            for(Waiver_Rule_List__c ruleList: waiverCollList1){
                strr1+=ruleList.Id+';'; 
            }
            designWaiver1.singleRecId=strr1;
            
            // pageReference pgRef1 = designWaiver1.saveRules();
            //ruleLstTableWrapList = designWaiver1.getWaiverRuleRecords();
            
            map<String, List<Attachment>> attachmentMap1 = designWaiver1.getWaiverRuleAttachmentTable();
            // pgRef1 =designWaiver1.releaseToCustomer();
            //designWaiver1.fetchAllRelatedUsers();
            designWaiver1.getAMDetails();
            designWaiver1.getCustomerDetails();
            designWaiver1.changeFinalStatus();
            designWaiver1.submitForApproval();
            Test.stopTest();
            
        }
    
    
    
    
    
    
}