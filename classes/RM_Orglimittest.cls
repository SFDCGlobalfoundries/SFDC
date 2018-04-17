/*  Author : Ashwini Dengi
    Description : This test class is for batch class Organizationlimit.
    Code Creation: 6/18/2015
    */

@IsTest
     
        public class RM_Orglimittest{
        public static testmethod void s1() {
        
        Test.startTest();
        system.schedule('orglimitcheck','0 0 * * * ?', new RM_schedulerfororglimit());
        Test.stopTest();
       
        }
        
    }