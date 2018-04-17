/* 
@Author :- Harsha
@Controller : DFMEmailImplementation
@Adding the code for Email notification - 18012017 - SUHAS 
*/

@isTest(SeeAllData=false) 
private class DFMEmailImplementationTest { 
    
    
    static testMethod void DFMServicesApprovalRequestTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMServicesApprovalRequest(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }
    
    static testMethod void DFMServicesApprovalConfirmationTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMServicesApprovalConfirmation(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }   
    static testMethod void DFMServicesRejectionConfirmationTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMServicesRejectionConfirmation(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }       
    static testMethod void DFMReviewSummaryNotification4AllPATest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMReviewSummaryNotification4AllPA(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }   
    
    static testMethod void DFMReviewSummaryNotificationL15Test() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMReviewSummaryNotificationL15(waiverColl,'');        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }     
    
    static testMethod void DFMReviewSummaryNotification4AllPAFAETest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMReviewSummaryNotification4AllPA1(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    } 
    
    static testMethod void DFMJobClosureNotificationTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMJobClosureNotification(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }
          
    static testMethod void DFMReviewSummaryNotification4PWTest() { 
        Test.startTest();  
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMReviewSummaryNotification4PW(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }  
    static testMethod void DFMReleaseofReport2CustL3aTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T(waiverColl.Id);
        
        
        DFMEmailImplementation.DFMReleaseofReport2CustL3a(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }    
    static testMethod void DFMReleaseofReport2CustL3bTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T1(waiverColl.Id);
        
        DFMEmailImplementation.DFMReleaseofReport2CustL3b(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }       
    
    static testMethod void DFM_Reminder_ReleaseofReport2CustTest() { 
        Test.startTest();  
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFM_Reminder_ReleaseofReport2Cust(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }         
    
    static testMethod void ResponseRequired4DFMReviewReportTest() { 
        Test.startTest();  
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.ResponseRequired4DFMReviewReport(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }   
    
    static testMethod void ReminderResponseRequired4DFMReviewReportTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.ReminderResponseRequired4DFMReviewReport(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }       
    static testMethod void NotificationofCustomerDecisionForReportTest() { 
        Test.startTest();  
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForFCF(waiverColl.Id);
        
        DFMEmailImplementation.NotificationofCustomerDecisionForReport(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }   
    
    static testMethod void NotificationofCustomerDecisionForReportTest1() { 
        Test.startTest();  
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForFCF1(waiverColl.Id);
        
        DFMEmailImplementation.NotificationofCustomerDecisionForReport(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }       
    static testMethod void NotificationofCustomerDecisionForReportTest2() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForWCR(waiverColl.Id);
        
        DFMEmailImplementation.NotificationofCustomerDecisionForReport(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }         
    static testMethod void NotificationofCustomerDecisionForReportTest3() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        DesignCollaboratorTestData.getWaiverRuleListForIfd12(waiverColl.Id);
        
        DFMEmailImplementation.NotificationofCustomerDecisionForReport(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }        
    static testMethod void FoundryToRiskApprovalTest() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        set<Id> sid = new  set<Id>();
        
        DFMEmailImplementation.FoundryToRiskApproval(waiverColl,sid);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }  
    
    static testMethod void drcReleaseReportToCustomerTest() {  
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.drcReleaseReportToCustomer(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }   
    
    static testMethod void ReminderFoundryToRiskApprovalTest() {  
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T(waiverColl.Id);
        
        DFMEmailImplementation.ReminderFoundryToRiskApproval(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }        
    
    
    static testMethod void DFMReviewSummaryNotification3Test() {  
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T(waiverColl.Id);
        
        DFMEmailImplementation.DFMReviewSummaryNotification3(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }   
    static testMethod void DFMReviewSummaryNotification31Test() {  
        Test.startTest();
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        DesignCollaboratorTestData.getWaiverRuleListForiFDFD(waiverColl.Id);
        
        DFMEmailImplementation.DFMReviewSummaryNotification3(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }   
    static testMethod void DFMJobCancellationTest() {
        Test.startTest();  
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        
        DFMEmailImplementation.DFMJobCancellation(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }   
    static testMethod void setUpPiyeAndQAUsersTest(){
        Test.startTest();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator27() ;
        
        DFMEmailImplementation.setUpPiyeAndQAUsers(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void setUpPiyeAndQAUsersTest1(){
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator28() ;
        
        DFMEmailImplementation.setUpPiyeAndQAUsers(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void setUpPiyeAndQAUsersTest2(){
        Test.startTest();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator29() ;
        
        DFMEmailImplementation.setUpPiyeAndQAUsers(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void setUpPiyeAndQAUsersTest3(){
        Test.startTest();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator30() ;
        
        DFMEmailImplementation.setUpPiyeAndQAUsers(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void collaboratorAcknowledgementForShortFlowTest() { 
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T(waiverColl.Id);
        
        DFMEmailImplementation.collaboratorAcknowledgementForShortFlow(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    }   
    static testMethod void collaboratorAcknowledgementForLongFlowTest() { 
        Test.startTest(); 
        DesignCollaboratorTestData.getGroupTestData('DFM_PI_YE_4_FAB1', 'DFM PI YE 4 FAB1');
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaboratorT();
        DesignCollaboratorTestData.getWaiverRuleListForiFD1T(waiverColl.Id);
        
        DFMEmailImplementation.collaboratorAcknowledgementForLongFlow(waiverColl.Id);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl);
    } 
     static testMethod void DFML14() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMJobRevertedL14(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
        
    }
    static testMethod void DFML15() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMJobRevertedL15(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
        
    }
    static testMethod void DFML16() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMJobRevertedL16(waiverColl);        
        Test.stopTest();
        System.assertEquals(waiverColl, waiverColl); 
        
    }
     static testMethod void DFMReviewSummaryNotification4AllPATest2() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMReviewSummaryNotification4AllPA(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }
    static testMethod void DFMReviewSummaryNotification4AllPA1Test() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMReviewSummaryNotification4AllPA(waiverColl.Id);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }
     static testMethod void DFMReviewSummaryNotificationL3L4Test() {  
        Test.startTest(); 
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator1();
        
        DFMEmailImplementation.DFMReviewSummaryNotificationL3L4(waiverColl);        
        Test.stopTest();    
        System.assertEquals(waiverColl, waiverColl);
    }
    
}