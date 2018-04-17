/**********************************************************************************************************************************************
Trigger Name:  CPQMLGPlusTrigger
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha (PS)
Created Date:  03-23-2015
Reason:        This Trigger handles all CPQ MLGPLUS related activites.. 
                   1) Call bundleProductHandler method of CPQMLGPLUStriggerHandler class
Change Log:     
                   
**********************************************************************************************************************************************/
trigger CPQMLGPlusTrigger on CPQ_MLGPLUS__c (Before Update) {
    List<CPQ_MLGPLUS__c> TriggeredMLG = new List<CPQ_MLGPLUS__c>();
    List<Product2> NewBundleProduct = new List<Product2>();
    for(CPQ_MLGPLUS__c mlg : trigger.new){
        if(mlg.Status__c == 'Ready to Load'){
        	String AddError = mlg.Catalog_Type__c == NULL ? 'Catalog Type': mlg.Parent_Product_External_ID__c == NULL ? 'Parent Product External ID' : mlg.Parent_Product_Name__c == NULL ? 'Parent Product Name': mlg.Geometry__c  == NULL	? 'Geometry': '' ; 
			if(AddError != ''){
				mlg.adderror('Please enter '+AddError);
			}
			else{
            	TriggeredMLG.add(mlg);
			}
        }
    }
    if(TriggeredMLG.size() > 0){
        CPQMLGPLUStriggerHandler mlghandler = new CPQMLGPLUStriggerHandler();
        mlghandler.getLatestAttachment(TriggeredMLG);
        mlghandler.bundleProductHandler(TriggeredMLG);        
    }
}