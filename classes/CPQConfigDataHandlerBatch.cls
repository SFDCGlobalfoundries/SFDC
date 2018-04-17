/**********************************************************************************************************************************************
Class:         CPQConfigDataHandlerBatch
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha (PS)
Created Date:  04-23-2015
Reason:        This class submits CPQConfigurationDataHandler job in batch mode.  
           
Change Log:     
                   
**********************************************************************************************************************************************/
global class CPQConfigDataHandlerBatch implements Database.Batchable<sObject> {
	String query;
	String[] email;
	Id toUserId;
	Id fromUserId;
	
	global CPQConfigDataHandlerBatch(String q,String [] AdminEmails)
    {
       	query=q;
    	email=AdminEmails;
    }
	
	global Database.querylocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){		
		List<CPQ_MLGPLUS__c> cpqmlgList = new List<CPQ_MLGPLUS__c>();
		Map<String,String> CatNameToAttIDMap = new Map<String,String>();
		for(Apttus_Config2__ClassificationHierarchy__c cathierachy: [SELECT		ID
																				, name 
																				, Apttus_Config2__Label__c
																				, Apttus_Config2__AncestorId__c
																				, Apttus_Config2__AncestorId__r.Apttus_Config2__Label__c
																				, Apttus_Config2__PrimordialId__c
																				, Apttus_Config2__PrimordialId__r.Apttus_Config2__Label__c  
																				, Apttus_Config2__LargeIconId__c
																	 FROM		Apttus_Config2__ClassificationHierarchy__c
																	 WHERE		Apttus_Config2__AncestorId__r.Apttus_Config2__Label__c = 'Process Catalog'
																	 AND		Apttus_Config2__PrimordialId__r.Apttus_Config2__Label__c  = 'GLOBALFOUNDRIES Offering']){
																	 	
			CatNameToAttIDMap.PUT(cathierachy.Apttus_Config2__Label__c, cathierachy.Apttus_Config2__LargeIconId__c);
		}
   		for(sObject s : scope){
   			CPQ_MLGPLUS__c cpqmlg = (CPQ_MLGPLUS__c)s;
		   	Product2 ParentProd = new Product2();
		   	ParentProd = [select	id, 
								    ProductCode,
								    Product_External_ID__c,
								    IsActive,
								    Apttus_Config2__ConfigurationType__c,
								    APTPS_Core_Voltage__c,
								    Geometry__c,
								    Family,
								    Name,
								    FEOL__c ,
								    PT_Number__c,
								    BEOL__c , 
								    catalog_type__c
							 FROM   Product2
					   		 where  id = :cpqmlg.Bundle_Product__c];
	   		
			CPQConfigurationDataHandler cls = new CPQConfigurationDataHandler();
			List<string> PriceListNames = new List<String>();
			cls.processTechLoad(  ParentProd
								, PriceListNames
								, cpqmlg.Catalog_Type__c
								, cpqmlg
								, CatNameToAttIDMap);	
			cpqmlg.Status__c = 'Pending Maintenance Jobs' ; 
			cpqmlgList.add(cpqmlg);
			
   		}
   		if(cpqmlgList.Size()>0){
   			Update cpqmlgList; 
   		}
	}
	global void finish(Database.BatchableContext BC){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		 AsyncApexJob a = [SELECT 	Id
		 							, Status
		 							, NumberOfErrors
		 							, JobItemsProcessed
		 							, TotalJobItems
							      	, CreatedBy.Email
							      	, CreatedByID
						   FROM 	AsyncApexJob 
						   WHERE Id = :BC.getJobId()];
							      
		mail.setToAddresses(email);
		mail.saveAsActivity = false ;
		//mail.setTargetObjectId(UserInfo.getUserId() );
		mail.setTargetObjectID(a.CreatedByID);
		mail.setReplyTo('sfdc_support@globalfoundries.com');
		mail.setSenderDisplayName('Batch Processing');
		mail.setSubject('Configurator data Processing has completed');
		if(a.NumberOfErrors > 0 || a.TotalJobItems == 0){
			mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
		}
		else{
			mail.setPlainTextBody('Configurator data Processing has completed ' +a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.. Please run maintenance jobs');
		}
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}