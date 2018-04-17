/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- Foundry View 2.0
* @ Description     :- Test class of Design_Spec__c object and it handles all after operation on SpecificationAfterTrigger
                       class has solution for Case #00027678 (send email notifications to owners of pdk and pdk batch bundles once 
                       specification has been updated from General Release status to any other specification status.)
* @ Date            :- 9 July 2014
* @ Change History  :- 
**/

@isTest
private class FV_SpecAfterOperationHandlerTest {

    static testMethod void designSpecSendEmailTest() {
        
        DataUtilTest.loadEnvironmentVariables();
       
       	Test.startTest();
   			// Create design spec record
	        Design_Spec__c dSpec = FV_SpecAfterOperationHandlerTest.getDesignSpec('General Release');
	        // Create PDK
	        PDK__c pdk = FV_SpecAfterOperationHandlerTest.getPDK();
	        //Create sub Pdk
	        Sub_PDK__c subPdk = FV_SpecAfterOperationHandlerTest.getSubPdk(pdk.Id);
	        //Create Sub PDK SPec
	        Sub_PDK_Spec__c subPdkSpec = FV_SpecAfterOperationHandlerTest.getSubPdkSpec(dSpec.Id,subPdk.Id);  
	        // Update designSpec Status   	
        	dSpec.Release_Status__c='Release To White List';
        	update dSpec;
        	
        Test.stopTest();	
    }
    
    // Method returns SubPDKSpecs object
    public static Sub_PDK_Spec__c getSubPdkSpec(ID SpecID,ID subPdkId){
    	
    	Sub_PDK_Spec__c subPdkSpec = new Sub_PDK_Spec__c();
    	subPdkSpec.Design_Spec__c = SpecID;
    	//subPdkSpec.Document_Title__c='Test PDK General Relaese change';
    	//subPdkSpec.Master_PDK_Version__c='1.1';
    	subPdkSpec.Sub_PDK__c = subPdkId;
    	insert subPdkSpec; 
    	
    	return subPdkSpec;
    }
    
    // Method returns SubPdk
    public static sub_PDK__c getSubPdk(Id PdkId){
    	
    	sub_PDK__c objSubPDK = new sub_PDK__c();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = PdkId;
        objSubPDK.Release_Status__c = 'Release To White list';
        
        insert objSubPDK;
        
        return objSubPDK;
    } 
    
    //  Method returns pdk  
    public static PDK__c getPDK(){
    	
    	PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 123;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123;
        objPDK.PDK_Lifecycle_Phase__c = 'RELEASED';
    	
    	insert objPDK;
    	
    	return objPDK;
    }
    
    
    // Method returns Designspec object
    public static Design_Spec__c getDesignSpec(String Status){
    	
    	Design_Spec__c objDesignSpec = new Design_Spec__c();
        
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is';
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = Status;   
                                   
        insert objDesignSpec;
        
        return objDesignSpec;
    }
}