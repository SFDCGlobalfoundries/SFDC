/**
*   Author: Prosenjit Saha
*   Description: This is the test class for CPQMetadataMethodHandler

*   History:
*       PSaha          05152015     - code creation.
*     
**/
@istest(SeeAllData=false)
public class CPQMetadataMethodHandlerTest{

    private class WebServiceMockImpl implements WebServiceMock 
    {
        //Mock response
        public void doInvoke(
	    	Object stub, Object request, Map<String, Object> response,
		    String endpoint, String soapAction, String requestName,
		    String responseNS, String responseName, String responseType) {
		
			    // test for the type of the response, OP was just doing readMetaData()
			    if(request instanceof MetadataService.readMetadata_element){
			      	MetadataService.readMetadata_element requestReadMetadata_element  = (MetadataService.readMetadata_element) request;
			      // This allows you to generalize the mock response by type of metadata read
			      	if (requestReadMetadata_element.type_x == 'CustomField') { 
			        	MetadataService.readCustomFieldResponse_element mockRes   = new MetadataService.readCustomFieldResponse_element();
				        mockRes.result = new MetaDataService.ReadCustomFieldResult();
				        mockRes.result.records = createCustomFields();
				        response.put('response_x', mockRes);
			      	}
			    }
		   		else if (request instanceof MetadataService.updateMetadata_element) {
			    	MetadataService.updateMetadata_element requestUpdateMetadata_element  = (MetadataService.updateMetadata_element) request; 
		            MetadataService.updateMetadataResponse_element mockUpdateRes = new MetadataService.updateMetadataResponse_element();
		            mockUpdateRes.result = createSaveResult(); 
		            response.put('response_x',mockUpdateRes);
		            
		            MetadataService.updateMetadata_element requestUpdateMetadata_element_error  = (MetadataService.updateMetadata_element) request; 
		            MetadataService.updateMetadataResponse_element mockUpdateResError = new MetadataService.updateMetadataResponse_element();
		            mockUpdateResError.result = createSaveResultError(); 
		            response.put('response_x',mockUpdateResError);
			   	}
			   	
			   	
		   		return;
    	}
	    	private MetadataService.CustomField[] createCustomFields(){
			    MetadataService.CustomField [] CustomFields = new MetadataService.CustomField[]{};
			
			    MetadataService.CustomField fld1 = new MetadataService.CustomField();
			    fld1.fullName = 'Test Field1';
			    MetadataService.PicklistValue [] pickvalueList = new  MetadataService.PicklistValue []{};
			    metadataservice.PicklistValue pickVal1 = new metadataservice.PicklistValue();
			    pickVal1.fullName = 'Value1';
			    pickVal1.default_x= false;
			    metadataservice.PicklistValue pickVal2 = new metadataservice.PicklistValue();
			    pickVal2.fullName = 'Value2';
			    pickVal2.default_x= false;
			    pickvalueList.add(pickVal1);
			    pickvalueList.add(pickVal2);
			    MetadataService.Picklist newPicklist = new MetadataService.Picklist();
			    newPicklist.controllingField =  'TestFeild' ; 
			    newPicklist.picklistValues = pickvalueList ; 
			    fld1.picklist = newPicklist;
			    
			    CustomFields.add(fld1);
			    return CustomFields;
	    	}
	    	private MetadataService.SaveResult[] createSaveResult(){
			    MetadataService.SaveResult [] SaveResults = new MetadataService.SaveResult[]{};
			
			    MetadataService.SaveResult SRes1 = new MetadataService.SaveResult();
			    SRes1.fullName = 'Test Field1';
			    SRes1.success = true ; 
			    SaveResults.add(SRes1);			
			    return SaveResults;
	    	}
	    	
	    	private MetadataService.SaveResult[] createSaveResultError(){
			    MetadataService.SaveResult [] SaveResults = new MetadataService.SaveResult[]{};
						
			    MetadataService.SaveResult SRes = new MetadataService.SaveResult();
			    SRes.fullName = 'Test Field2';
			    SRes.success = false ;
			    String[] customfields = new String []{};
			    customfields.add('test field1');
			    customfields.add('test field2');
			    MetadataService.Error error1 =  new MetadataService.Error();
			    error1.message = 'Test Message';
			    error1.fields = new String []{};
			    error1.fields.addAll(customfields);
			    SRes.errors = new MetadataService.Error[]{ error1};
			    SaveResults.add(SRes);
			
			    return SaveResults;
	    	}

    }    
    
    /*
    * Method Name:     CPQMetadataHandlerTest
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method handle all the Metadata related test for CPQMetadataMethodHandlerclass
    */
    static testmethod void CPQMetadataHandlerTest (){
		// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
		String PTName = 'PT00xxxx'; 
        List<String> MetalStacks = new List<String>{'Test_Metal1', 'Test Metal2'};
        List<String> CoreVoltageList  = new List<String>{'99', '100'};
        List<String> IOVoltageList = new List<String>{'99', '100'};
    	CPQMetadataMethodHandler.attributeUpdatePicklist(PTName , MetalStacks, CoreVoltageList, IOVoltageList);
    }
}