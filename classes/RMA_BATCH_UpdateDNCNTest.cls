@isTest(SeeAllData= false)
private class RMA_BATCH_UpdateDNCNTest{

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        Account acc = RMA_TestDataUtility.createAccount();
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
        
        rmaRec.Assign_to__c = 'Fab';
        rmaRec.Disposition_of_Wafers__c = 'Return to GF';
        rmaRec.Lot_Device_To_Return__c  = 'testLot1;';
        update rmaRec;
        
        rmaRec = [select id,Name from rma__c limit 1][0];
        rmaRec.Name='RMA_Test';
        update rmaRec;
        
        RMA_DNCN__c rmadncn=new RMA_DNCN__c();
        rmadncn.CN_DN_Number__c='CNDNTest';
        rmadncn.Name='RMA_Test';
        rmadncn.Transaction_Date__c=System.Today();
        rmadncn.Invoice_Number__c ='INVTest';
        rmadncn.Job_Id__c= NULL;
        insert rmadncn;
    }
       
    public static testmethod void DNCNTestMethod(){
        RMA_BATCH_UpdateDNCN batch=new RMA_BATCH_UpdateDNCN();
        test.startTest();
            ID jobID=Database.executeBatch(batch);
        test.stopTest();
        
        Rma__c rmaRec = [select id,Name,CN_DN_Number__c from rma__c where Name='RMA_Test' limit 1][0];
        System.assertEquals('CNDNTest;',rmaRec.CN_DN_Number__c);
        RMA_DNCN__c dncnrec= [select id,Name,CN_DN_Number__c,Job_Id__c from RMA_DNCN__c where Name='RMA_Test' limit 1][0];
        System.assertEquals(dncnrec.Job_Id__c, jobID);
    }      
    
}