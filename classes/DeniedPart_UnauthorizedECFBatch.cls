/**
* Author: KOKA GOPI
* Project: DeniedPart_UnauthorizedECFBatch Scedulable and Batch class used to find "unauthorized" records from Export_Control_Form__c Object using "DeniedPartCustomerAvoiding" helper class
* Description: Test Class for DeniedParty code coverage for Export_Control_Form__c Object
**/
global class DeniedPart_UnauthorizedECFBatch implements Database.Batchable<SObject>,Schedulable {
    Global String ExecutionType;
    Global DeniedPart_UnauthorizedECFBatch(String TypeofExecution){
        ExecutionType = TypeofExecution;
    }
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        String allTodayUnauthoRecords = 'SELECT id,Name,End_User_Customer_Name__c FROM Export_Control_Form__c';
        if(ExecutionType == 'all'){
            allTodayUnauthoRecords += ' WHERE Unauthorized_Modified_Date__c=null AND Unauthorized__c=false';
        }
        return Database.getQueryLocator(allTodayUnauthoRecords);
    }
    
    global void execute(Database.BatchableContext bcMain, List<Export_Control_Form__c> lstBatchRecords) {
         if(lstBatchRecords.size()>0){
             DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(lstBatchRecords[0].End_User_Customer_Name__c,
                                                                                                                    null,
                                                                                                                    null,
                                                                                                                    null,
                                                                                                                    lstBatchRecords[0].id,
                                                                                                                    null);
             lstBatchRecords[0].Unauthorized__c            = validateVar.unauthorized;
             lstBatchRecords[0].Unauthorized_Percentage__c = validateVar.percentageCalculation;
             Update lstBatchRecords[0];
         }
    }
    
    global void finish(Database.BatchableContext bcMain) {
    }
    //Scedulable Batch Class
    global void execute(SchedulableContext scMain) {
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
            DeniedPart_UnauthorizedECFBatch ucb = New DeniedPart_UnauthorizedECFBatch('all');
            DataBase.ExecuteBatch(ucb,1);
        } else {
           //schedule this same schedulable class again in 30 mins
           DeniedPart_UnauthorizedECFBatch ucb = New DeniedPart_UnauthorizedECFBatch('all');
           Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,ucb);
        }
    }
}