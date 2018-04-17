/*
    Author: Ariz Solito
    Description: Apex class for VCID Conversion Batch Process
    History: 
    Asolito      07/04/2013    - Apex code created 
 
    To Run:
            VCIDConversionBatch job = new VCIDConversionBatch();
            Id processId = Database.executeBatch(job,10);
    
    To Check Status:
            AsyncApexJob j = [select ApexClassId, CompletedDate, CreatedById, CreatedDate, 
                                Id, JobItemsProcessed, JobType, MethodName, NumberOfErrors, Status, 
                                TotalJobItems from AsyncApexJob where Id =:processId];
    
    Info about this Class:
            ApexClass ac = [select ApiVersion, Body, BodyCrc, CreatedById, CreatedDate, Id, 
                                IsValid, LastModifiedById, LastModifiedDate, LengthWithoutComments, Name, 
                                NamespacePrefix, Status, SystemModstamp from ApexClass where Id = :j.ApexClassId];
*/
global class VCIDConversionBatch implements Database.Batchable<SObject> {
    private static String QUERY_CONSTANT = 'SELECT id,CRM_DID__c,processID__c,technology__c,library__c,vendor__c, '+
                                          '        customer__c,converted_ip_vcid_component__c,deviceId__c '+
                                          '   FROM IP_VCID_Sub_Component__c '+
                                          '   WHERE converted_ip_vcid_component__c = null ';                                            
    private String query;
    
    public class ApexBatchJobException extends Exception {}
    
    public VCIDConversionBatch() {
        this(QUERY_CONSTANT);
    }
    
    public VCIDConversionBatch(String queryString) {
        query = queryString;
        //Check if the job is running already
        ApexClass ac = [select Name from ApexClass where Name = 'VCIDConversionBatch'];
        List<AsyncApexJob> aajs = [select Status from AsyncApexJob where ApexClassId = :ac.Id and 
                                    JobType = 'batchApex' and Status in ('Queued', 'Processing')];
        if (!aajs.isEmpty()) {
            throw new ApexBatchJobException(aajs.size() + ' VCIDConversionBatch job(s) already running or processing.');
        }
    }
    
    //Method required by the framework to start the job execution.
    global Database.QueryLocator start(Database.BatchableContext ctx) {
        Database.QueryLocator qLocator = null;
        try {
            qLocator = Database.getQueryLocator(query);
        } catch (Exception e) {
            System.debug(e);
            throw e;
        } 
        return qLocator;
    }
    
    //Method required by the framework to process the records returned by the query locator created in the start method.
    global void execute(Database.BatchableContext ctx, List<SObject> sobjects) {                            
        List<IP_VCID_Sub_Component__c> recs = (List<IP_VCID_Sub_Component__c>) sobjects;
        if(recs <> null){
            if(recs.size() > 0){
                //set the flag to true so that the conversion won't run again
                VCIDComponentConversion.hasConversionRun = true;
                
                VCIDComponentConversion.convertToVCIDComponent(recs);                       
            }
        }
                                            
    }
    
    //Method required and invoked by the framework when a batch job is done.
    global void finish(Database.BatchableContext ctx) {     
    }        
}