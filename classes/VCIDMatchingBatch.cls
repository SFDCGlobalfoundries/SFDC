/*
	Author: Ariz Solito
    Description: Apex class for VCID Matching Batch Process
    History: 
    Asolito      07/04/2013    - Apex code created 
    Asolito		 09/05/2013    - Modified matching batch job to handle Next Matching Process flag
 
    To Run:
			VCIDMatchingBatch job = new VCIDMatchingBatch();
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
global class VCIDMatchingBatch implements Database.Batchable<SObject> {
    private static String QUERY_CONSTANT = 'SELECT id,next_matching_process__c,status__c '+
                                           '   FROM IP_Declaration_Form__c '+
                                           '   WHERE status__c IN (\'Pending Reconciliation\', \'Pending Resubmission\')';
                                                                                                                     
    private String query;
    
    public class ApexBatchJobException extends Exception {}
    
    public VCIDMatchingBatch() {
        this(QUERY_CONSTANT);
    }
    
    public VCIDMatchingBatch(String queryString) {
        query = queryString;
        //Check if the job is running already
        ApexClass ac = [select Name from ApexClass where Name = 'VCIDMatchingBatch'];
        List<AsyncApexJob> aajs = [select Status from AsyncApexJob where ApexClassId = :ac.Id and 
        							JobType = 'batchApex' and Status in ('Queued', 'Processing')];
        if (!aajs.isEmpty()) {
        	throw new ApexBatchJobException(aajs.size() + ' VCIDMatchingBatch job(s) already running or processing.');
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
    	List<IP_Declaration_Form__c> recs = (List<IP_Declaration_Form__c>) sobjects;
    	List<String> recIds = new List<String>();
    	
    	for(IP_Declaration_Form__c r: recs){
    		recIds.add(r.id);    		
    	}
    	
		if(recIds.size() > 0){  
			//set the flag to true so that the matching won't run again
			IPDeclarationMatching.hasMatchingRun = true;  			
			
			IPDeclarationMatching.batchProcessMatching(recIds);
		}								  	    	
    }
    
    //Method required and invoked by the framework when a batch job is done.
    global void finish(Database.BatchableContext ctx) {    	
    }        
}