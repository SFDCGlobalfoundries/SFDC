/*
    Author: Anirban Roy
    Description: This is the test class for CPQMLGPlusTriggerHandler.
    History: 
        ARoy     05132015    - Code creation.
        PSaha	 05262015	 - Modified to increase test coverage
*/

@istest(SeeAllData=false)
public class CPQMLGPlusTriggerHandlerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest1(){
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);               
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment';
        String tempStr = 'Feature Group,Notes,IO Voltage(V),Core Voltage (V),Feature Description,Model Name,Additional Masks1,FEOL/BEOL \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),N/A,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;
        
        Test.stopTest();
    
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest2(){
        
        Product2 processTech4Com = createProduct('Test Process Technology 1', '180nm_PT003125', 'CC,DD,EE', '180nm_PT003126', 'PT003126');
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment.csv';
        String tempStr = 'Feature Group,Notes,IO Voltage(V),Core Voltage (V),Feature Description,Model Name,Additional Masks1,FEOL/BEOL \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),N/A,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;                
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;                
        
        Test.stopTest();
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest3(){
        
        Product2 processTech4Com = createProduct('Test Process Technology 2', '180nm_PT003125', 'CC,DD,EE', '180nm_PT003126', 'PT003126');
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment.csv';
        String tempStr = 'Feature Group,Notes,IO Voltage (V),Core Voltage (V),Feature Description,Model Name,Additional Masks1,FEOL/BEOL \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),Test,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;                
        
        MLG_Record__c mlgRec = new MLG_Record__c();
        mlgRec.Feature_Group__c = 'DNWELL';
        mlgRec.IO_Voltage_V__c = 'N/A';
        mlgRec.Core_Voltage_V__c = 'N/A'; 
        mlgRec.Feature_Description__c = 'N-well and p-well in substrate (dual well)'; 
        mlgRec.Model_Name__c = 'Test';
        mlgRec.Additional_Mask_s__c = 'RS';
        mlgRec.FEOL_BEOL__c = 'FEOL';
        mlgRec.CPQ_MLGPLUS__c = cpqmlgplus.Id;
        mlgRec.Version__c = '#1#';
        insert mlgRec;
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;
                        
        Test.stopTest();
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest4(){
        
        Product2 processTech4Com = createProduct('Test Process Technology 2', '180nm_PT003125', 'CC,DD,EE', '180nm_PT003126', 'PT003126');
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment.csv';
        String tempStr = 'Feature Group,Notes,IO Voltage(V),Core Voltage (V),Feature Description,Model Name,Additional Masks1,FEOL/BEOL \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),Test,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;                
        
        MLG_Record__c mlgRec = new MLG_Record__c();
        mlgRec.Feature_Group__c = 'DNWELL';
        mlgRec.IO_Voltage_V__c = 'N/A';
        mlgRec.Core_Voltage_V__c = 'N/A'; 
        mlgRec.Feature_Description__c = 'N-well and p-well in substrate (dual well)'; 
        mlgRec.Model_Name__c = 'Test';
        mlgRec.Additional_Mask_s__c = 'RS';
        mlgRec.FEOL_BEOL__c = 'FEOL';
        mlgRec.CPQ_MLGPLUS__c = cpqmlgplus.Id;
        mlgRec.Version__c = '#2#';
        insert mlgRec;
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;
                        
        Test.stopTest();
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest5(){
        
        Product2 processTech4Com = createProduct2('Test Process Technology 1', '180nm_PT003125', 'CC,DD,EE', '180nm_PT003126', 'PT003126');
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment.csv';
        String tempStr = 'Feature Group2,Notes2,IO2 Voltage(V),Core2 Voltage (V),Feature Description2,Model Name2,Additional Masks2,FEOL/BEOL2 \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),N/A,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;                
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;                
        
        Test.stopTest();
    }
    
    // Test method for CPQ MLGPLUS status updated to 'Ready to Load'
    static testMethod void CPQMLGPLUSStatusROLTest6(){
        
        Product2 processTech4Com = createProduct('Test Process Technology 1', '180nm_PT003125', 'CC,DD,EE', '180nm_PT003125', 'PT003125');
        Apttus_Config2__ProductAttributeGroup__c ProdAttGroup = createProdAttributeGroup();
        createProductAttributeGroupMember(ProdAttGroup.id, processTech4Com.id);
        CPQ_MLGPLUS__c cpqmlgplus = createMLGPLUS();
        MLG_Email__c mlgEmail = createMLGEmail(cpqmlgplus.id);
        
        Test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Test Attachment.csv';
        String tempStr = 'Feature Group2,Notes2,IO2 Voltage(V),Core2 Voltage (V),Feature Description2,Model Name2,Additional Masks2,FEOL/BEOL2 \n';
        tempStr += 'DNWELL,2,N/A,N/A, N-well and p-well in substrate (dual well),N/A,RS,FEOL';
        Blob bodyBlob=Blob.valueOf(tempStr);
        attach.body=bodyBlob;
        attach.parentId=mlgEmail.id;
        insert attach;                
        
        cpqmlgplus.Status__c = 'Ready to Load';
        update cpqmlgplus;                
        
        Test.stopTest();
    }
    
    static CPQ_MLGPLUS__c createMLGPLUS(){
        CPQ_MLGPLUS__c cpqMLGPLUS = new CPQ_MLGPLUS__c(Catalog_Type__c = 'First Source'
                                            , Geometry__c = '0.18UM'
                                            , Status__c = 'Unprocessed'
                                            , Parent_Product_External_ID__c = '180nm_PT003125'
                                            , Parent_Product_Name__c = '180nm_PT003125'
                                            , Process_Technology__c = 'PT003125');
        insert cpqmlgplus;
        return cpqmlgplus;    
    }

    static MLG_Email__c createMLGEmail(Id cpqMlgplusId){
        MLG_Email__c mlgEmail = new MLG_Email__c();
        mlgEmail.CPQ_MLGPLUS__c = cpqMlgplusId;
        mlgEmail.Version__c = '1';
        insert mlgEmail;  
        return mlgEmail;  
    }
    
     //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily, String PTNumber){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.18nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True,
                                     Apttus_Config2__ConfigurationType__c = 'Bundle',
                                     PT_Number__c = PTNumber,
                                     Catalog_Type__c = 'First Source');
        
        insert prod;
        return prod;
    }
    //Static method to create product test record
    static Product2 createProduct2(String szName, String szCode, String szMaskSet, String szProductFamily, String PTNumber){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.18nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True,
                                     Apttus_Config2__ConfigurationType__c = 'Bundle',
                                     PT_Number__c = PTNumber,
                                     Catalog_Type__c = 'Multi Source');
        
        insert prod;
        return prod;
    }
    
    //static method to create product attribute groups
    Static Apttus_Config2__ProductAttributeGroup__c createProdAttributeGroup (){
    	Apttus_Config2__ProductAttributeGroup__c prodAtt = new Apttus_Config2__ProductAttributeGroup__c(
    		Name 									= 'Packaging'
    		, Apttus_Config2__BusinessObject__c 	= 'Apttus_Config2__ProductAttributeValue__c'
    		, Product_Attribute_Group_External_Id__c= 'Test Packaging'
    	);
    	insert prodAtt;
    	return prodAtt;
    }
	
	Static void createProductAttributeGroupMember (String ProductgrpID, String ProductID){
		Apttus_Config2__ProductAttributeGroupMember__c prodAttgrpMem = new Apttus_Config2__ProductAttributeGroupMember__c(
			name = 'Test Group Member'
			, Apttus_Config2__AttributeGroupId__c = ProductgrpID
			, Attribute_GroupMember_External_ID__c = 'Test_Grp_Mem'+math.random()
			, Apttus_Config2__ProductId__c = ProductID
			, Apttus_Config2__Sequence__c = 1
		); 
		insert prodAttgrpMem ; 
	}

}