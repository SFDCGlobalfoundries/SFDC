/*
    Author: Nino Bustillos
    Description: Test class for ActiveUserAssociationToLoginCount
*/
@isTest(SeeAllData=false)
private class ActiveUserAssociationToLoginCountTest{
    static testmethod void doTest(){
        Test.startTest();
        
        // create login count record
        Login_count_last_7_days_for_analytics__c loginCountRecord = new Login_count_last_7_days_for_analytics__c(Week_Ending__c=system.today().adddays(-5),Last_Logins_count__c=200);
        insert loginCountRecord;
        
        // create active user record
        Active_Users_for_Analytics__c activeUserRecord = new Active_Users_for_Analytics__c(Week_Ending__c=system.today().adddays(-5),Number_of_Active_Users__c=100);
        insert activeUserRecord;
        
        String jobId = System.schedule('testActiveUserAssociation','0 0 15 * * ?',new ActiveUserAssociationToLoginCount());
        
        Test.stopTest();
    }
}