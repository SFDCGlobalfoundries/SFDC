/**
 * Author: Cognizant Technology Solutions
 * Project: Return Material Authorization
 * Description: This class acts as a test class for the following apex classes:
 * History:
 *                            
 **/
@isTest(seeAllData=false)
public class RMA_Test{

    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
}