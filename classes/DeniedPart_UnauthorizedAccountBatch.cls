/**
* Author: KOKA GOPI
* Project: DeniedPart_UnauthorizedAccountBatch  Scedulable and Batch class used to find "unauthorized" records from Account Object using "DeniedPartCustomerAvoiding" helper class
* Description: Test Class for DeniedParty code coverage for Account Object
**/
global class DeniedPart_UnauthorizedAccountBatch implements Database.Batchable<SObject>,Schedulable {
    Global String ExecutionType;
    Global DeniedPart_UnauthorizedAccountBatch(String TypeofExecution){
        ExecutionType = TypeofExecution;
    }
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        String allTodayUnauthoRecords = 'SELECT id,Name,Corporate_Address_1__c,Bill_To_Address_1__c,Corporate_Country__c,Account_Manager__c,Primary_CSR__c,Primary_FAE__c FROM Account';
        if(ExecutionType == 'all'){
            allTodayUnauthoRecords += ' WHERE Unauthorized_Modified_Date__c=null AND Unauthorized__c=false';
        }
        return Database.getQueryLocator(allTodayUnauthoRecords);
    }
    
    global void execute(Database.BatchableContext bcMain, List<Account> lstBatchRecords) {
        if(lstBatchRecords.size()>0){
            List<ID> csrIDs = New List<ID>();
            if(lstBatchRecords[0].Account_Manager__c!=null){
                csrIDs.add(lstBatchRecords[0].Account_Manager__c);
            }
            if(lstBatchRecords[0].Primary_CSR__c!=null){
                csrIDs.add(lstBatchRecords[0].Primary_CSR__c);
            }
            if(lstBatchRecords[0].Primary_FAE__c!=null){
                csrIDs.add(lstBatchRecords[0].Primary_FAE__c);
            }
             DeniedPartCustomerAvoiding.validatedResponse validateVar = DeniedPartCustomerAvoiding.validateCustomer(lstBatchRecords[0].Name,
                                                                                                                    lstBatchRecords[0].Corporate_Address_1__c,
                                                                                                                    lstBatchRecords[0].Bill_To_Address_1__c,
                                                                                                                    lstBatchRecords[0].Corporate_Country__c,
                                                                                                                    lstBatchRecords[0].id,
                                                                                                                   csrIDs);
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
            DeniedPart_UnauthorizedAccountBatch uab = New DeniedPart_UnauthorizedAccountBatch('all');
            DataBase.ExecuteBatch(uab,1);
        } else {
           //schedule this same schedulable class again in 30 mins
           DeniedPart_UnauthorizedAccountBatch uab = New DeniedPart_UnauthorizedAccountBatch('all');
           Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,uab);
        }
    }
}