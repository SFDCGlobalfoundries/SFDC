/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a ExportControlRedirectController class.
 *             
 * History:
 * <Vijay>     02092015 - class created
 * 
 */
public with sharing class ExportControlRedirectController {

	private String deviceId;
	private String accountId;
	ApexPages.StandardController controller;
	
	public ExportControlRedirectController(){
		this.controller = controller;         
        deviceId = ApexPages.currentPage().getParameters().get('deviceid');
        accountId = ApexPages.currentPage().getParameters().get('accountid');
	}
	
	public PageReference redirect(){
        if(String.IsNotBlank(deviceId) && String.IsNotBlank(accountId)){
	     	List<Device_Export_Control_Junction__c> devExpConJunc =  [SELECT	Id
			                                                          FROM		Device_Export_Control_Junction__c
			                                                          WHERE		Device__c = :deviceId limit 1];
	    	if(devExpConJunc.isEmpty()){
	    		createExportControlForm(deviceId, accountId, 'Undeclared');
	    	}
	    	PageReference pageRef = Page.ExportControlEdit;
	    	pageRef.getParameters().put('deviceid',deviceId);
	    	return pageRef;
        }
        return null;
	}
	
	private void createExportControlForm(Id deviceId, Id accountId, String status){
		try{
			 Export_Control_Form__c expcontrolForm = new Export_Control_Form__c(account__c = accountId, status__c = status);
			 insert expcontrolForm;
			 if(expcontrolForm.Id != null){
			 	Device_Export_Control_Junction__c deviceExpCntrlJunction = new Device_Export_Control_Junction__c(device__c = deviceId,
			  																				export_control_form__c = expcontrolForm.Id);
			  																				
	  			insert deviceExpCntrlJunction;																	
			 }
		}catch(Exception e){
			 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		  																				
	}
	
	
}