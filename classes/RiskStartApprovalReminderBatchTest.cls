/***************************************************************************************************************************
Class:         RiskStartApprovalReminderBatchTest 
----------------------------------------------------------------------------------------------------------------------------
Author:        Pradosh Samal
Description:   This is the test class for RiskStartApprovalReminderBatch.
History:
    Created Date:  07/14/2017 -  Created

***************************************************************************************************************************/

@isTest(SeeAllData=false)
public class RiskStartApprovalReminderBatchTest {
    
    static List<Account_Team_Proxy__c> lAccountTeam {private get; private set;}
    static List<User> lUser {private get; private set;}
    static Account account {private get; private set;}
    
    @testSetup static void testData(){
        
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                   
        fieldValueMap.put('site_department__c', 'test dept');                                           
        fieldValueMap.put('region__c', 'EUR');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Risk_Start_System__c createRiskStartSystem(String fab) {
        
        Risk_Start_System__c riskStartSystem = new Risk_Start_System__c();
        riskStartSystem.Customer_Name__c = account.Id;
        riskStartSystem.Recommended_Device__c = 'TESTDEVICE';
        riskStartSystem.Recommended_Quantity__c = 100;
        riskStartSystem.Status__c = 'Draft';
        riskStartSystem.FAB__c = fab;
        riskStartSystem.PX_WIP_FG1__c = 1;
        
        return riskStartSystem;
    }
    
    static testMethod void testRun1(){     
        
        Test.startTest();
        
        account = getAccount('MYTEST ACCOUNT1');
        
        Risk_Start_System__c riskStartSystem = RiskStartApprovalReminderBatchTest.createRiskStartSystem('Fab 8');
        
        riskStartSystem.Qtr_0__c = 1;
        riskStartSystem.Qtr_0_PO_Coverage__c = 1;
        riskStartSystem.Business_Unit__c = 'RF Business Unit';
        riskStartSystem.Reason_for_Request__c = 'Fab/SCM requested for linear loading';
        riskStartSystem.Cum_Revenue__c = 100;
        riskStartSystem.Is_PX_Requested_Device_Qualified__c = 'Fab - Yes';
        riskStartSystem.PX_Request_Revenue__c = 100;
        
        insert riskStartSystem;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for quality validation');
        req.setObjectId(riskStartSystem.Id);
        //req.setSubmitterId(UserInfo.getUserId());
        //req.setSkipEntryCriteria(true);
        //req.setProcessDefinitionNameOrId('RMA_Quality_Validation');
        Approval.ProcessResult result = Approval.process(req);
        
        riskStartSystem = new Risk_Start_System__c(Id = riskStartSystem.Id);
        riskStartSystem.Reminder_Date__c = System.now().addDays(-15);
        update riskStartSystem;
        
        RiskStartApprovalReminderBatch batchapex = new RiskStartApprovalReminderBatch();
        ID batchprocessid = Database.executeBatch(batchapex);
        
        batchapex = new RiskStartApprovalReminderBatch();
        batchprocessid = Database.executeBatch(batchapex);
        
        batchapex = new RiskStartApprovalReminderBatch();
        batchprocessid = Database.executeBatch(batchapex);
        
        RiskStartApprovalReminderBatch obj = new RiskStartApprovalReminderBatch();      
        String sch = '0 0 23 * * ?';
        System.schedule('Test check', sch, obj);
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName){
        
        Account acc1= [SELECT Id, Name FROM Account Where Name =: AccountName];
        return acc1;
    }  
}