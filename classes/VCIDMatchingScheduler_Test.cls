/*
    Author: Ariz Solito
    Description: Apex test class for VCIDMatchingScheduler
    History: 
        Asolito     07/23/2013    - Code creation.
*/
@isTest(SeeAllData=false)
public with sharing class VCIDMatchingScheduler_Test {
    static testmethod void testClass() {
        try
        {
            Test.startTest();
            String jobId = System.schedule('VCIDMatchingBatch123', '0 0 * * * ?', new VCIDMatchingScheduler());
            CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals('0 0 * * * ?', ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.debug('*************************** ' + ct.NextFireTime);     
            Test.stopTest();
        }
        catch(Exception ex)
        {
        } 
    }
}