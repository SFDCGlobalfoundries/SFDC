/*
    Author: Ariz Solito
    Description: Apex test class for the GDSEmailTemplate component
    History: 
        Asolito     17112014    - Code creation.
*/

@isTest
private class GDSEmailTemplateCntrlrTest {
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
                                                     
        /*(for(Apttus_Proposal__Proposal__c recLst : [SELECT id FROM Apttus_Proposal__Proposal__c]){
            if(recLst.mask_set_long__c <> null && recLst.mask_set_long__c.length() > 0)
                rec = recLst;
            break;
        } */    
                                         
        GDS__c gds = new GDS__c(
            Quote_Proposal__c = rec.id,
            status__c = 'Draft'
        ); 
        insert gds;
        
        test.startTest();
                      
        
        GDSEmailTemplateCntrlr ctrl = new GDSEmailTemplateCntrlr();   
        Boolean showInternalURL = ctrl.showInternalURL;
        Boolean showExternalURL = ctrl.showExternalURL;
        
        //get rec id 
        String testVar = ctrl.recID;
        
        //get sfdc url
        testVar = ctrl.sfdcURL;
        
        //get portal url
        testVar = ctrl.portalURL;
              
        test.stopTest();                                                                    
    }
    
}