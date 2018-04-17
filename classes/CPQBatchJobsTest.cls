/**
*   Author: Prosenjit Saha
*   Description: This is the test class for batchJobs class

*   History:
*       PSaha          05182015     - code creation.
*     
**/
@istest(SeeAllData=false)
public class CPQBatchJobsTest{
    /*
    * Method Name:     batchStatusTest
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the testing of BatchStatus class
    */
    static testmethod void batchStatusTest(){
        test.starttest();
            batchStatus testController = new batchStatus(); 
            testController.PageType= 'ConfigDataUpdate'; 
            testController.getError(); 
        test.stoptest();
    }
}