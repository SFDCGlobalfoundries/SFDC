@isTest(seeAllData=False)
private class MRSGenerateExtnTest {

    static testMethod void myUnitTest() {
        
        SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();            
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
        insert objMST;
        PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release',Status__c='Active');
        insert objPTRF;
        system.assertEquals(objPTRF.Recticle_Type__c.toUpperCase(),'SINGLE LAYER RETICLE (SLR)');
        ApexPages.CurrentPage().getparameters().put('id',objPTRF.Id);
        MRSGenerateExtn controller = new MRSGenerateExtn(new ApexPages.Standardcontroller(objPTRF));
        controller.returnToPTRF();
        controller.generateMRSLayerChipAssociation();
        objPTRF.Status__c='Perform Tapeout Options';
        update objPTRF;
        controller.generateMRSLayerChipAssociation();        
    }
}