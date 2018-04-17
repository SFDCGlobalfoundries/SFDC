/*
	@Author :- Suhas Bargi
*/
@isTest(SeeAllData=true)
public class ApprovalRecallForRulesTest {

    static testMethod void myAutoEmailBatchMethod_Recall() { 
       
        Test.startTest(); 
        //DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        List<User> user = DesignCollaboratorTestData.getUserTestData();
        List<Account> accountList = [SELECT Account_Manager__c,Account_Name__c,Account_Profile__c,Account_Type__c,Id,Name,Owner_Profile__c FROM Account WHERE IsDeleted = false LIMIT 5];
        System.debug('accountList>>> '+accountList);
        Account account = new Account();
        account= accountList.get(0);
        
        Waiver_Rule_List__c waiverRuleList = DesignCollaboratorTestData.getWaiverRuleListForApproval(user[0].FederationIdentifier, user[1].FederationIdentifier, account.Id);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        User thisUserApp = [SELECT Id FROM User WHERE  isActive=true limit 1];
        List<Id> idsList = new List<Id>();
        Set<Id> PIYE_Users = new Set<Id>(); 
        PIYE_Users =  DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_PI_YE_4_FAB9').keySet():NULL;
        if(PIYE_Users<>null && PIYE_Users.size()>0){
        idsList.addAll(PIYE_Users);
        }
        System.runAs (thisUser) { 
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
            Approval.ProcessResult[] processResults = null;
            
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request by FAEs ');
            //req.setNextApproverIds(thisUserApp.Id);
            req.setObjectId(waiverRuleList.Id);
            
            requests.add(req);
            
            try {
                processResults = Approval.process(requests, true);
            } catch (System.DmlException e) {
                // log error in to common error logger object
                GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Class', e, system.now());
            }
            System.debug('processResults>>> '+processResults);
        }
        
        Database.BatchableContext bc;
        ApprovalRecallBatch waiver = new ApprovalRecallBatch();
        List<Waiver_Rule_List__c> waiverRuleListAdded = new  List<Waiver_Rule_List__c>();
        waiverRuleListAdded.add(waiverRuleList);
        waiver.execute(bc, waiverRuleListAdded);
        System.debug('processResults>>> ');
        Test.stopTest(); 
    }

    
    static testMethod void myAutoEmailBatchMethod1() {
         Test.startTest();  
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorDFMService();
        List<Waiver_Rule_List__c> waiverRuleList = DesignCollaboratorTestData.getWaiverRuleList1(waiverColl.Id);
        
        Database.BatchableContext bc;
        ApprovalRecallBatch waiver = new ApprovalRecallBatch();
       
        waiver.execute(bc, waiverRuleList);
        
        Test.stopTest();  
    }

    static testMethod void myAutoEmailSchMethod() {
        
        String sch = '0 0 09 * * ?';
        
        Test.startTest();
        
        ApprovalRecallForRules m = new ApprovalRecallForRules();
        String jobID = system.schedule('Email Job1', sch, m);
        
        Test.stopTest();      
    }
}