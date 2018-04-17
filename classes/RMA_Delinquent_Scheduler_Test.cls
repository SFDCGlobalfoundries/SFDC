@isTest
global class RMA_Delinquent_Scheduler_Test{
    @TestSetup
    static void loadTestData()
    {
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc); 
    }
    
    public static testmethod void ScheduleTest(){
        RMA__c rmaRec = [select id from rma__c limit 1][0];
        Account acc = [select id from account limit 1];
        
        Test.StartTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            RMA_TestDataUtility.createInvoicesAgere(1,acc);
            
            rmaRec.Queue_in_Time_for_CSR_Submission__c = System.Now() - 20;
            update rmaRec;
            
            for(CronTrigger Ct: [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
                                FROM CronTrigger 
                                WHERE CronJobDetail.Name like '%RMA_Delinquent_Summary_Report_Scheduler%' 
                                  AND State<>'COMPLETE' 
                                  AND NextFireTime<>NULL]){
                try{
                    System.AbortJob(ct.Id);    
                }catch(Exception e){} 
            }
            
            RMA_Delinquent_Summary_Report_Scheduler obj=new RMA_Delinquent_Summary_Report_Scheduler();
            obj.execute(NULL);
        Test.StopTest();
        
    }
      
}