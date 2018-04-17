/*
    Company:        Cognizant Technology Solution
    Description:    This batch class will delete Active reticle dataware house records which have been processed successfully.
    History:

    CTS    18/03/2014    Class Creation
*/

global class ROS_BATCH_DeleteActiveRDWH implements Database.Batchable<sObject>, Database.Stateful {
    private String batchJobId;
    global Integer totalCount;        //total count of active RDWH processed
    global Integer totalSuccessCount; //total count of successfully processed RDWH

    public ROS_BATCH_DeleteActiveRDWH(String jobId, Integer totalCount) {
        this.batchJobId = jobId;
        this.totalCount = totalCount;
        this.totalSuccessCount = 0;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Reticle_Datawarehouse__c WHERE Job_Id__c = \'' + batchJobId + '\' AND IsActive__c = true AND Invalid_Reason__c = null');
    }

    global void execute(Database.BatchableContext BC, List<Reticle_Datawarehouse__c> listRDWH) {
        if(listRDWH != null && !listRDWH.isEmpty()) {
            totalSuccessCount = totalSuccessCount + listRDWH.size();

            Database.DeleteResult[] drList = Database.delete(listRDWH, false);

            // Iterate through each returned result
            for(Database.DeleteResult dr : drList) {
                if (!dr.isSuccess()) {
                    totalSuccessCount = totalSuccessCount - 1;
                    // Operation failed, so get all errors
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('RDWH fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        //Query the AsyncApexJob object to retrieve the current job's information
        AsyncApexJob a = [SELECT Id, CreatedBy.Email
                          FROM   AsyncApexJob
                          WHERE  Id = :BC.getJobId()];


        // Send an email to the Apex job's submitter notifying of 
        // job completion and count of successful, failed and total records.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Active Reticle Datawarehouse batch processing completed.');
        mail.setPlainTextBody('The Active Reticle Datawarehouse Batch has finished processing.' +
                              '\nTotal number of records processed: ' + totalCount +
                              '\nTotal number of successfully processed records: ' + totalSuccessCount +
                              '\nTotal number of invalid records: ' + (totalCount - totalSuccessCount) +
                              '\nApex Batch Job Id: ' + BC.getJobId());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}