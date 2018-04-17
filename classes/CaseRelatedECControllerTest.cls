/*
    Author: DBiswal
    Description: Apex test class for Class CaseRelatedECController.
    History: 
*/

@istest
public class CaseRelatedECControllerTest{

    public static testMethod void caseecTestMethod(){
        DataUtilTest.loadEnvironmentVariables();
        //DataUtilTest.LoadATPEnvVariables();
        CaseDataUtilTest.loadCustomSettingVariables();
        List<Case> caseList = new List<Case>();
        
        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;    
        Account acc = new Account(name = 'acctest14', Site_Department__c = 'Site13', Sub_Type__c = 'Direct',
                Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill43',
                Bill_To_City__c = 'city13', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '',
                Corporate_City__c = 'city13', Corporate_Country__c = 'Austria');
        insert acc;
        
        //Environment_Variable__c envvar = new Environment_Variable__c(Name='CXM_L3_L4_SpecialUser',Value__c=userinfo.getUserId());
        //insert envvar;
        
        Escalation_Complaint__c actmgmt = new Escalation_Complaint__c(Account__c=acc.id,Subject__c='test action345',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                      Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(1),
                                                                      Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_Level__c='L3 - Director/VP');
        insert actmgmt;
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        
        Case c = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                          Description = 'Test 331', Subject = 'Test 12', Category__c = 'Shipping',
                          Priority = 'Low', AccountId = acc.Id, Internal_or_external__c = false);
        caseList.add(c);
        
        Case c4 = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 554', Subject = 'Test 35', Category__c = 'Service',Escalation_Complaint__c = actmgmt.Id,
                           Priority = 'Low', AccountId = acc.Id, Internal_or_external__c = false);
        caseList.add(c4);
        
        insert caseList;
        
        Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.CaseRelatedEC')); 
            System.currentPageReference().getParameters().put('Id', actmgmt.Id);
            CaseRelatedECController caseEC = new CaseRelatedECController();
            caseEC.SearchName = 'est';
            caseEC.creator = '';
            caseEC.SearchCase();
            caseEC.add();
            caseEC.ClearAll();
            caseEC.closeEvent();
        Test.stopTest();
    }
    
}