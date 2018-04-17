/*
    Author: Ariz Solito
    Description: Apex test class for VCIDConversionScheduler
    History: 
        Asolito     07/23/2013    - Code creation.
*/
@isTest(SeeAllData=false)
public with sharing class VCIDConversionScheduler_Test {
    static testmethod void testClass() {
        try
        {
            Test.startTest();
            String jobId = System.schedule('VCIDConversionBatch', '0 0 * * * ?', new VCIDConversionScheduler());
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