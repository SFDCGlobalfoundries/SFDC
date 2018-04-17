/*
    Company:        Cognizant Technology Solution
    Description:    Batch class to update the DNCN details on the RMA request.
    History:        1/12/2016    Created the class    
        NJain       11-May-16    Modified the Start method to query DNCN based on RMA pending for CN Issue
*/

public class RMA_BATCH_UpdateDNCN implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start (Database.BatchableContext batchableContext) {
        List<String> lstRMAnames = new List<String>();
        string str = '';
        for(RMA__c rmaRec: [SELECT Id,Name from RMA__c where Workflow_Stage__c = 'Pending for CN Issue' limit 5000]){
            lstRMAnames.add('\''+rmaRec.Name+'\'');
            str = str+'\''+rmaRec.Name+'\',';
        }
        if(str != ''){
        	str = str.substring(0,str.length()-1);
        }
        
        if(!Test.isRunningTest()){
            return Database.getQueryLocator('SELECT Id,Name,CN_DN_Number__c,Transaction_Date__c,Invoice_Number__c '+
                                            ' FROM RMA_DNCN__c '+
                                            ' WHERE Source__c = \'RMA\' AND Job_Id__c = NULL AND Name IN (' + str + ')' );
        }else{
            return Database.getQueryLocator('SELECT Id,Name,CN_DN_Number__c,Transaction_Date__c,Invoice_Number__c '+
                                         ' FROM RMA_DNCN__c '+
                                         ' WHERE Source__c = \'RMA\' AND Job_Id__c = NULL limit 1 ');
        }
    }
    
    public void execute(Database.BatchableContext batchableContext, List<RMA_DNCN__c> lstDNCN) {
        List<String> lstRMAnames = new List<String>();
        Map<String,RMA__c> mapRMAvsReq = new Map<String,RMA__c>();
        if (!lstDNCN.isEmpty()){
            lstRMAnames.clear();
            mapRMAvsReq.clear();
            
            //List of the RMA DNCN record names
            for(RMA_DNCN__c dncn: lstDNCN){
                lstRMAnames.add(dncn.Name);
            }
            
            //Map for storing the name against the record for RMA.
            for(RMA__c rmaRec: [SELECT Id,Name,CN_DN_Number__c,CN_DN_Date__c from RMA__c
                                    WHERE Name in :lstRMAnames and Is_Legacy__c = FALSE]){
                mapRMAvsReq.put(rmaRec.Name,rmaRec);
            }
            
            for(RMA_DNCN__c dncn: lstDNCN){
                if(mapRMAvsReq.get(dncn.Name) != NULL){
                    //Assign CNDN number on the RMA request
                    if(mapRMAvsReq.get(dncn.Name).CN_DN_Number__c == NULL){
                        mapRMAvsReq.get(dncn.Name).CN_DN_Number__c = dncn.CN_DN_Number__c+';';
                    }else{
                        mapRMAvsReq.get(dncn.Name).CN_DN_Number__c += dncn.CN_DN_Number__c+';';
                    }
                    mapRMAvsReq.get(dncn.Name).CN_DN_Date__c = dncn.Transaction_Date__c;
                    dncn.Job_Id__c = batchableContext.getJobId(); //Assign the Batch Job Id on the DNCN record being processed
                }
            }
            Database.Update(mapRMAvsReq.values()); //Update RMA records for saving CN/DN numbers.
            Database.Update(lstDNCN); //Update DNCN records which are processed successfully.
        }
    }
    
    public void finish (Database.BatchableContext batchableContext) {
        // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,  
                                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                            from AsyncApexJob where Id = :batchableContext.getJobId()];  
        
        // Email the Batch Job's submitter that the Job is finished.  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setSubject('DNCN Batch Job Status: ' + a.Status);  
        mail.setPlainTextBody('Hi,\n\nThe batch Apex job processed ' + a.TotalJobItems +  
                              ' batches with '+ a.NumberOfErrors + ' failures.' + '\n\nSalesforce Support');  
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
}