/**
* Author: Prosenjit Saha
* Description: This is the test class for RefFlowDataLoad

* History:
*     PSaha          07142014     - code creation.
*     
**/

@isTest(SeeAllData=true)
private class RefFlowDataLoadTest{
        
    /*
    * Method Name:     RefFlowDataLoadMethod
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method Tests RefFlowDataLoad class.
    */
    static testMethod void RefFlowDataLoadMethod(){
       
        test.startTest();
            RefFlowDataLoad temp = new RefFlowDataLoad();
            temp.configRefFlow();
        test.stopTest();
    
    }        
    
}