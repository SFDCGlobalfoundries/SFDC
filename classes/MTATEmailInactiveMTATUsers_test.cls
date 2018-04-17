@isTest(SeeAllData=true)
public class MTATEmailInactiveMTATUsers_test{
    
    public static String CORN_EXP='0 0 0 1 12 ? 2018';
    static testmethod void emailTest(){
        Test.startTest();
        String jobId=System.Schedule('ScheTest',CORN_EXP,new MTATEmailInactiveMTATUsers());
        CronTrigger cronTrigger=[SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id=:jobId];
        System.assertEquals(CORN_EXP,cronTrigger.CronExpression);
        List<HCM_Employee__c> hcmList=[SELECT id,Name,Location_Description__c,First_Name__c,Last_Name__c,LastModifiedDate,Email_Address__c,Status__c from HCM_Employee__c where Status__c='Inactive' and SystemModstamp > :Date.today().addDays(-60)];
        system.debug('InActive Users'+hcmList.size());
        //system.assertEquals(hcmList.size(),3);
        Test.stopTest();
    }
    
}