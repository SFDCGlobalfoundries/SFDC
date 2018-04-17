public with sharing class MRSRetriggerRollup {
	
	private Set<Id> mrsSet {get;set;}
	private String jobId {get;set;}
	public Mask_Set_Title__c mstRecord {get;set;}
	private Integer batchSize {get;set;}
	public List<AsyncApexJob> submitjob {get;set;}
	public boolean isCompleted {get;set;}
	public boolean isFailed {get;set;}
	
	public MRSRetriggerRollup(ApexPages.StandardController stdController) {
		isCompleted = false;
		isFailed = false;
		jobId = '';
		batchSize = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_LAYERCHIP_BATCHSIZE').Value__c );
		submitjob = new List<AsyncApexJob>();
		mstRecord = [SELECT Id,Name FROM Mask_Set_Title__c WHERE Id=:ApexPages.currentPage().getParameters().get('id')];
		Map<Id, MRS__c> tempMrs = new Map<Id, MRS__c>([SELECT Id FROM MRS__c WHERE Mask_Set_Title__c = :mstRecord.Id]);
		mrsSet = tempMrs.keySet();
	}
	
	/**
	* This method re-trigger the layer status of MRS
	*/
	public pageReference calculateMRSLayerStatus() {
		// if current active batch is more than 4 => NONE invoke new batch
		BatchScheduleSetLayerChipStatus rollupBatch = new BatchScheduleSetLayerChipStatus( mrsSet );
		if(checkToRunJob()) {
    		jobId = Database.executeBatch(rollupBatch, batchSize);
    	} else {
    		jobId = '';
    	}
       	submitjob = [
       		SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors 
       		FROM AsyncApexJob
       		WHERE Id = :jobId
       	];
       	ApexPages.Message  myMsg = new ApexPages.Message( ApexPages.Severity.INFO,'Re-Trigger LAYER CHIPs status for MST : ' + mstRecord.Name + ' is in Progress' );
        ApexPages.addMessage(myMsg);
		return null;
	}
	
	/**
	* Real time polling status method.
	* This will check for the job progress.
	*/
	public boolean isNextJob = false; 
	public PageReference pollingStatus() {
		// if batch has not invoke from intial due to limit 5 active batch, re-invoke it again
        if(jobId == '') {
        	BatchScheduleSetLayerChipStatus rollupBatch = new BatchScheduleSetLayerChipStatus( mrsSet );
        	// if current active batch is more than 4 => NONE invoke new batch
        	if(checkToRunJob()) {
        		jobId = Database.executeBatch(rollupBatch, batchSize);
        	} else {
        		jobId = '';
        	}
        }
        submitjob = [
       		SELECT Id,Status,JobItemsProcessed,TotalJobItems,NumberOfErrors 
       		FROM AsyncApexJob
       		WHERE Id = :jobId
       	];
       	ApexPages.Message  myMsg = new ApexPages.Message( ApexPages.Severity.INFO,'Re-Trigger LAYER CHIPs status for MST : ' + mstRecord.Name + ' is in Progress' );
       	if(submitjob.size() > 0 ) {
       		if( 'Completed'.containsIgnoreCase(submitjob[0].Status) ) {
       			//continueLayerStatusCalculate();
       			isCompleted = true;
       			myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Re-Trigger LAYER CHIPs status for MST ' + mstRecord.Name + ' has been completed.');
       		} else if( 'Failed'.containsIgnoreCase(submitjob[0].Status) ) {
       			myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Re-Trigger LAYER CHIPs status for MST ' + mstRecord.Name + ' has been failed.');
       			isFailed = true;
       		}
       	}
       	ApexPages.addMessage(myMsg);
        return null;
    }
    
    /**
    * Check the condition to determine whether can submit new batch.
    */
    private boolean checkToRunJob() {
    	boolean result = true;
    	Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if( jobs > 4 ) {
        	result = false;    
        }
    	return result;
    }
	
	/**
	This method returns from the VF page to MRS standard page layout. 
	@method name: returnToMRS
	@parameter:   None.
	@return :     Pagereference.
	**/
	public PageReference returnToMST(){
	   PageReference page = new PageReference('/'+mstRecord.Id);
	   return page;
	}
	
	public PageReference continueLayerStatusCalculate(){
	   PageReference page = new PageReference('/apex/VFMRSRetriggerRollupLayer?id='+mstRecord.Id);
	   return page;
	}
}