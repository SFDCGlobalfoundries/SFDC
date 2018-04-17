/*
Type Name: CVASurveyController_Test
Author: Vijay Vemuru
Created Date: 31st-Mar-2016
Reason: This Test class is used for CVA Survey.
Change History:
Author: 
Modified Date: 
*/
@isTest(seealldata=false)
private class CVASurveyController_test {
	
	@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', (Label.Visitation_Internal_Account_Name != null) ? Label.Visitation_Internal_Account_Name:'GLOBALFOUNDRIES INTERNAL');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void myUnitTest() {
        												
        
        Account acc = [SELECT id from Account LIMIT 1];
        
        Visitation_Record__c visit = new Visitation_Record__c();
        CVA_Survey__c survey       = new CVA_Survey__c ();
        visit.Account__c = acc.id;
        visit.Visit_Name__c = 'Test Visitation';
        visit.Visit_Type__c = 'Visit from Customer';
        visit.Visit_Location__c = 'Malta';
        visit.Visitation_Host__c   = userinfo.getuserid();
        visit.Purpose__c = 'QBR';
        visit.Top_level_Agenda__c   = 'xadsa';
        visit.End_Date__c           = system.today().adddays(2);
        visit.Start_Date__c         = system.today().addDays(1);
        visit.Customer_Status__c    = 'Logistics';
        visit.Fab__c                = 'Fab 9';
        survey.Resolution_Score__c  = 10;
        
        insert visit;
        
        apexpages.currentpage().getParameters().put('CVA',visit.id);
        apexpages.currentpage().getParameters().put('Survey_Score__c','2');
        apexpages.currentpage().getParameters().put('Record_Owner__c',userinfo.getuserid());
        CVASurveyController cva = new CVASurveyController();
        cva.getItems();
        cva.rateSurvey();
        cva.submitform();
                    
        Visitation_Record__c visit1 = new Visitation_Record__c();
        visit1.Account__c = acc.id;
        visit1.Visit_Name__c = 'Test Visitaion';
        visit1.Visit_Type__c = 'Visit from Customer';
        visit1.Visit_Location__c = 'Malta';
        visit1.Visitation_Host__c   = userinfo.getuserid();
        visit1.Purpose__c = 'QBR';
        visit1.Top_level_Agenda__c  = 'xadsa';
        visit1.End_Date__c          = system.today().adddays(2);
        visit1.Start_Date__c        = system.today().addDays(1);
        visit.Customer_Status__c    = 'Logistics';
        visit1.Fab__c                = 'Fab 9';

        insert visit1;
        
        apexpages.currentpage().getParameters().put('CVA',visit.id);
        apexpages.currentpage().getParameters().put('Survey_Score__c','2');
        apexpages.currentpage().getParameters().put('Record_Owner__c',userinfo.getuserid());
        CVASurveyController cva1 = new CVASurveyController();
        cva1.variableInitializationError(true);
    }
}