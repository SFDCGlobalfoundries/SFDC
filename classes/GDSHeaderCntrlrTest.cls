/*
    Author: Ariz Solito
    Description: Apex test class for the GDSHeader component
    History: 
        Asolito     20102014    - Code creation.
*/

@isTest
private class GDSHeaderCntrlrTest {
	@testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void testClass(){
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463        		
        /*Apttus_Proposal__Proposal__c rec = [SELECT id 
                                              FROM Apttus_Proposal__Proposal__c
                                              WHERE mask_set__c <> null
                                              LIMIT 1];*/
        Id accId = DeviceUtilTest.createAccount();
         
         Apttus_Proposal__Proposal__c rec = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='Test Config', Apttus_Proposal__Account__c = accId, Multi_Source_Tapeout_Approval_Stage__c  = 'Draft', mask_set_long__c = 'RS BV XP');
         insert rec;
         
        /*for(Apttus_Proposal__Proposal__c recLst : [SELECT id FROM Apttus_Proposal__Proposal__c]){
            if(recLst.mask_set_long__c <> null && recLst.mask_set_long__c.length() > 0)
                rec = recLst;
            break;
        }*/ 
                                               
        GDS__c gds = new GDS__c(
            Quote_Proposal__c = rec.id,
            status__c = 'Draft'
        ); 
        insert gds;
        
        test.startTest();
                
        PageReference pageRef = Page.GDSUpload;                 
        pageRef.getParameters().put('id',rec.id);
        Test.setCurrentPageReference(pageRef);
        
        GDSHeaderCntrlr ctrl = new GDSHeaderCntrlr();  
        
        //call back method
        ctrl.back();
        
        //call back to GDS method
        ctrl.backToGDS();
        
        //call back to translate method
        ctrl.backtoTranslate();
        
        //get product revision     
        String testVar = ctrl.productRevision;
        
        //get product name
        testVar = ctrl.productName;
        
        //get file name
        testVar = ctrl.fileName;
        
        //get top cell name
        testVar = ctrl.topCellName;
        
        //get gds row count
        testVar = ctrl.GDSRowCount;
        
        //get status
        testVar = ctrl.status;
        
        //get GDS upload step
        testVar = ctrl.GDSUploadStep;
        
        //get GDS translate step
        testVar = ctrl.GDSTranslateStep;
        
        //get GDS approve step
        testVar = ctrl.GDSApproveStep;
        String translatedRowCount = ctrl.translatedRowCount;
        
        test.stopTest();  
        
        
                                                                          
    }
    
}