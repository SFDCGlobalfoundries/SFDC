/**
* Author: KOKA GOPI
* Project: DeniedPart_UnauthorizedLeadBatch  Scedulable and Batch class used to find "unauthorized" records from Lead Object using "DeniedPartCustomerAvoiding" helper class
* Description: Test Class for DeniedParty code coverage for Lead Object
**/
global class DeniedPart_UnauthorizedLeadBatch implements Database.Batchable<SObject>,Schedulable {
    Global String ExecutionType;
    Global DeniedPart_UnauthorizedLeadBatch(String TypeofExecution){
        ExecutionType = TypeofExecution;
    }
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        String allTodayUnauthoRecords = 'SELECT id,Company,Corporate_Address_1__c,Corporate_Country__c FROM Lead';
        if(ExecutionType == 'all'){
            allTodayUnauthoRecords += ' WHERE Unauthorized_Modified_Date__c=null AND Unauthorized__c=false AND isconverted=false';
        }
        return Database.getQueryLocator(allTodayUnauthoRecords);
    }
    
    global void execute(Database.BatchableContext bcMain, List<Lead> lstBatchRecords) {
        if(lstBatchRecords.size()>0){
            DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(lstBatchRecords[0].Company,
                                                        lstBatchRecords[0].Corporate_Address_1__c,
                                                        null,
                                                        lstBatchRecords[0].Corporate_Country__c,
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
            DeniedPart_UnauthorizedLeadBatch ub = New DeniedPart_UnauthorizedLeadBatch('all');
            DataBase.ExecuteBatch(ub,1);
        } else {
           //schedule this same schedulable class again in 30 mins
           DeniedPart_UnauthorizedLeadBatch ub = New DeniedPart_UnauthorizedLeadBatch('all');
           Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,ub);
        }
    }
}