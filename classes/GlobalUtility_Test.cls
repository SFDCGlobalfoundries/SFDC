@istest(seealldata=false)
public class GlobalUtility_Test{

@istest
private static void testMethod1(){
        System_Log_Setting__c sl=new System_Log_Setting__c();
        sl.Debug__c=true;
        sl.Error__c=true;
        sl.Info__c=true;
        sl.Warning__c=true;
        sl.Log_Purge_Days__c=30;
        insert sl;
     	//Try block for testing exception
        try{integer i=1/0;}catch(Exception e){
            GlobalUtility.logMessage('Debug', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage', 'payLoad','RMA',e, 2300);
            GlobalUtility.logMessage('Error', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage', 'payLoad','RMA',e, 2300);
            GlobalUtility.logMessage('Warning', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage', 'payLoad','RMA',e, 2300);
            GlobalUtility.logMessage('Info', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage', 'payLoad','RMA',e, 2300);
        }
        
    	//Scheduler test
    	string CRON_EXP = '0 0 0 3 9 ? 2022';
        CronTrigger ct;
        
      	String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, new GlobalAppLogPurgeScheduler());
      	ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
         FROM CronTrigger WHERE id = :jobId];
      	System.assertEquals(CRON_EXP,
         ct.CronExpression);
    	//Batch test
    	GlobalAppLogPurgeBatch bc=new GlobalAppLogPurgeBatch();
          Database.executeBatch(bc,50);
    }
}