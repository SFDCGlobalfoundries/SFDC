/*  Author : Ashwini Dengi
    Description : This test class is used for Schedulejobs batch class.
    Code Creation: 7/24/2015
    */

@isTest(seeAllData = false)
                                
    private class TestSchedulejobs {
        static testmethod void test() {
           
            Test.startTest();
            system.schedule('test','0 0 12 ? * SAT *', new scheduleSchedulejobs());
            Test.stopTest();

    }

}