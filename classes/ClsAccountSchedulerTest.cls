/*
 Type Name: ClsAccountSchedulerTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsAccountScheduler' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/



@isTest
private class ClsAccountSchedulerTest 
{
    
    /**
        This method helps to test the Account Scheudler Class.
        
        @method name: testClsAccountScheduler
       
     */
     
    static testmethod void testClsAccountScheduler()
    {
        Test.StartTest();
        ClsAccountScheduler sh1 = new ClsAccountScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Account', sch, sh1);
        Test.stopTest();        
    }
}