/**********************************************************************************************************************************************
Class:         CPQMetadataMethodHandler
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha (PS)
Created Date:  04-23-2015
Reason:        This class handles product attribute value metadata insert
					- Process Technology
					- Metal Options
					- Supported I/O Voltages
					- Supported Core Voltages 
           
Change Log:     
                   
**********************************************************************************************************************************************/
public with sharing class CPQMetadataMethodHandler
{	
	/****************************************************************************************************************
	 Method:  	attributeUpdatePicklist 
	 Author:  	Prosenjit Saha
	 Created Date: 04-23-2015
	****************************************************************************************************************/
	public static void attributeUpdatePicklist(	String PTName
												, List<String> MetalStacks
												, List<String> CoreVoltageList
												, List<String> IOVoltageList)
	{
		
	    //create service instance. 
	    MetadataService.MetadataPort service = createService();     	    
		/**** Start: Process Tech Section ****/
	    // Read Custom Field
	    MetadataService.CustomField customFieldPT = (MetadataService.CustomField) service.readMetadata('CustomField', 
													new String[] { 'Apttus_Config2__ProductAttributeValue__c.APTPS_ProcessTechnology__c' }).getRecords()[0];	    
		
		//get existing Process technology picklist values. 
		Schema.DescribeFieldResult xProcessTech = Apttus_Config2__ProductAttributeValue__c.APTPS_ProcessTechnology__c.getDescribe();
		//existing Picklist values retrieved in this set. 
		Set<String> xPTPicklistValues = new Set<String>();
		List<Schema.PicklistEntry> plePT = xProcessTech.getPicklistValues();
		for(Schema.PicklistEntry f : plePT){
			xPTPicklistValues.add(f.getLabel()); 
			system.debug('[Debug: xPTValue]'+ f.getLabel() );
		}
		
		//PT to be added. 
		List<String> PTnumberList = new List<String>();
		PTnumberList.add(PTName);
		
		//preparing new pricklist value to insert. 
		if(!xPTPicklistValues.contains(PTName)){
			// Add pick list values
		    metadataservice.PicklistValue PTValue = new metadataservice.PicklistValue();
		    PTValue.fullName= PTName;
		    PTValue.default_x= false;
			customFieldPT.picklist.picklistValues.add(PTValue);
			system.debug('[Debug: PTValue]'+ PTValue );
		}
		
		/**** end: Process Tech Section ****/
		
		
		/**** Start: Metal Option Section ****/
		// Read Custom Field 		
	    MetadataService.CustomField customFieldMetal = (MetadataService.CustomField) service.readMetadata('CustomField', 
				new String[] { 'Apttus_Config2__ProductAttributeValue__c.APTPS_Metal_Options__c' }).getRecords()[0];
		
		//get existing metal option picklist values. 
		Schema.DescribeFieldResult xMetalOptions = Apttus_Config2__ProductAttributeValue__c.APTPS_Metal_Options__c.getDescribe();
		//existing Metal option Picklist values retrieved in this set.  
		Set<String> xMetalPicklistValues = new Set<String>();
		List<Schema.PicklistEntry> pleMO = xMetalOptions.getPicklistValues();		
		for(Schema.PicklistEntry f : pleMO){
			xMetalPicklistValues.add(f.getLabel()); 
			system.debug('[debug: metal option values]:'+f.getLabel());
		}
		
		//preparing new pricklist value to insert.
		for(String PickValue : MetalStacks){
			if(!xMetalPicklistValues.contains(PickValue)){
				metadataservice.PicklistValue metalstackvalue = new metadataservice.PicklistValue();
				metalstackvalue.fullName= PickValue;
				metalstackvalue.default_x= false;
				metalstackvalue.controllingFieldValues = PTnumberList;
				customFieldMetal.picklist.picklistValues.add(metalstackvalue);
				system.debug('[Debug: MetalstackValue]'+ metalstackvalue );
			}
		}
		/**** End: Metal Option Section ****/
		
		/**** Start: Core voltage Section ****/
		// Read Custom Field 		
	    MetadataService.CustomField customFieldCore = (MetadataService.CustomField) service.readMetadata('CustomField', 
				new String[] { 'Apttus_Config2__ProductAttributeValue__c.core_voltagae__c' }).getRecords()[0];
		
		//get existing metal option picklist values. 
		Schema.DescribeFieldResult xCoreVoltage = Apttus_Config2__ProductAttributeValue__c.core_voltagae__c.getDescribe();
		//existing Metal option Picklist values retrieved in this set.  
		Set<String> xCorePicklistValues = new Set<String>();
		List<Schema.PicklistEntry> pleCore = xCoreVoltage.getPicklistValues();		
		for(Schema.PicklistEntry f : pleCore){
			xCorePicklistValues.add(f.getLabel()); 
		}
		
		//preparing new pricklist value to insert.
		for(String PickValue : CoreVoltageList){
			String PickValueMod = PickValue.trim().replace('"','');
			system.debug('[debug: values send CORE-->]'+PickValueMod);
			if(!xCorePicklistValues.contains(PickValueMod)){
				system.debug('[debug: add new values CORE-->]'+PickValueMod);
				metadataservice.PicklistValue CoreValue = new metadataservice.PicklistValue();
				CoreValue.fullName= PickValueMod;
				CoreValue.default_x= false;
				CoreValue.controllingFieldValues = PTnumberList;
				customFieldCore.picklist.picklistValues.add(CoreValue);
				system.debug('[Debug: CoreValue]'+ CoreValue );
			}
		}
		/**** End: Core Voltage Section ****/
		
		/**** Start: IO voltage Section ****/
		// Read Custom Field 		
	    MetadataService.CustomField customFieldIO = (MetadataService.CustomField) service.readMetadata('CustomField', 
				new String[] { 'Apttus_Config2__ProductAttributeValue__c.IO_Voltage__c' }).getRecords()[0];
		
		//get existing metal option picklist values. 
		Schema.DescribeFieldResult xIOVoltages = Apttus_Config2__ProductAttributeValue__c.IO_Voltage__c.getDescribe();
		//existing Metal option Picklist values retrieved in this set.  
		Set<String> xIOVoltagePicklistValues = new Set<String>();
		List<Schema.PicklistEntry> pleIO = xIOVoltages.getPicklistValues();		
		for(Schema.PicklistEntry f : pleIO){
			xIOVoltagePicklistValues.add(f.getLabel()); 
		}
		
		//preparing new pricklist value to insert.
		for(String PickValue : IOVoltageList){
			String PickValueMod = PickValue.trim().replace('"','');
			system.debug('[debug: values send IO-->]'+PickValueMod);
			if(!xIOVoltagePicklistValues.contains(PickValueMod)){
				system.debug('[debug: add new values IO-->]'+PickValueMod);
				metadataservice.PicklistValue IOvalue = new metadataservice.PicklistValue();
				IOvalue.fullName= PickValueMod;
				IOvalue.default_x= false;
				IOvalue.controllingFieldValues = PTnumberList;
				customFieldIO.picklist.picklistValues.add(IOvalue);
				system.debug('[Debug: IOvalue]'+ IOvalue );
			}
		}
		/**** End: IO Voltage Section ****/
		
		
		
		// Update Custom Field
		handleSaveResults(
			service.updateMetadata(
				new MetadataService.Metadata[] { customFieldPT })[0]);			
		
		handleSaveResults(
			service.updateMetadata(
				new MetadataService.Metadata[] { customFieldMetal })[0]);
		handleSaveResults(
			service.updateMetadata(
				new MetadataService.Metadata[] { customFieldCore })[0]);		
		handleSaveResults(
			service.updateMetadata(
				new MetadataService.Metadata[] { customFieldIO })[0]); 
		
	
		
	}
	/****************************************************************************************************************/

	public class MetadataServiceExamplesException extends Exception { }

	public static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}

	/**
	 * Example helper method to interpret a SaveResult, throws an exception if errors are found
	 **/
	public static void handleSaveResults(MetadataService.SaveResult saveResult)
	{
		// Nothing to see?
		if(saveResult==null || saveResult.success)
			return;
		// Construct error message and throw an exception
		if(saveResult.errors!=null) 
		{
			List<String> messages = new List<String>();
			messages.add(
				(saveResult.errors.size()==1 ? 'Error ' : 'Errors ') + 
					'occured processing component ' + saveResult.fullName + '.');
			for(MetadataService.Error error : saveResult.errors)
				messages.add(
					error.message + ' (' + error.statusCode + ').' + 
					( error.fields!=null && error.fields.size()>0 ? 
						' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
			if(messages.size()>0 && !Test.isRunningTest() )
				throw new MetadataServiceExamplesException(String.join(messages, ' '));
		}
		if(!saveResult.success  && !Test.isRunningTest()  )
			throw new MetadataServiceExamplesException('Request failed with no specified error.');
	}	

}