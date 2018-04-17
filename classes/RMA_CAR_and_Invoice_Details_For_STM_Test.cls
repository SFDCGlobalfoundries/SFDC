@isTest(SeeAllData=false)
public with sharing class RMA_CAR_and_Invoice_Details_For_STM_Test {

    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc);
    }
    
    public static testMethod void myUniTest(){
        test.startTest();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA_Return_Invoice__c');   
        RMA__c rmaRec = [select id from RMA__c limit 1]; 
        Account acc = [select id from Account limit 1];
        RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
        
        RMA_Return_Invoice__c rmainvrec = database.query('select '+rmaFields+' from RMA_Return_Invoice__c limit 1');
        RMA__c rmaR = [select Id from RMA__c limit 1];
        
        RMA_PRF_CAR_Particulars__c car = new RMA_PRF_CAR_Particulars__c(
        Car__c = 'testcar',
        Lot__c = 'testLot1',
        RecordTypeId = RMA_Constants.PRFCAR_CAR,
        RMA__c = rmaR.Id
        );
        insert car;        
        
            RMA_CAR_and_Invoice_Details_For_STM controller = new RMA_CAR_and_Invoice_Details_For_STM();
            controller.getlstRMAReturnInvoice();
            controller.getlstRMACAR();
        test.stopTest();
    }
}