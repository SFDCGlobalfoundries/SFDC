@isTest
public class MRSApprovalServiceTest3 {

     @testSetup static void testSetup() {
        DataUtilTest.loadEnvironmentVariables();
        MRSApprovalServiceTest.initTestData();
    }
    
    @isTest
    private static void testPerformApproval_MDP1(){
        //insert new Environment_Variable__c(Name='SWIFT_MRS_BYPASS_USER_VALIDATION', Value__c='ON');
        //MRSApprovalServiceTest.initTestData();
        
        Test.startTest();
        
        MRSApprovalService.MRSApprovalMsg msg = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.MDP_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_MDP(msg);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testApprovalService_exceptionCatch(){        
        Test.startTest();
        MRSGeneralService gen = new MRSGeneralService();
        
        MRSApprovalService.MRSApprovalMsg msg = new MRSApprovalService.MRSApprovalMsg();
        msg.layers = new List<MRSApprovalService.MRSLayerData>();
        msg.layers.add(new MRSApprovalService.MRSLayerData());
        msg.layers.add(new MRSApprovalService.MRSLayerData());
        
        try { gen.handleResponse(msg, new MRSGeneralService.Message(null, null, null)); } catch(Exception e) {}
        try { gen.handleResponse(msg, null, null, new MRSGeneralService.Message(null, null, null)); } catch(Exception e) {}
        Test.stopTest();
    }
        
    @isTest
    private static void testApprovalService_EMPTY_LAYERCHIP(){
        list<mrs_layer_chip_association__c> lstChips = [select id from mrs_layer_chip_association__c];
        delete lstChips;
        
        Test.startTest();
        MRSApprovalService.MRSApprovalMsg msg2 = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.CUSTOMER_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_Foundry_MEBES(msg2);
        Test.stopTest();
    }
    
    @isTest
    private static void testApprovalService_layerShippedReleased(){
        
        list<mrs_layer_association__c> lstLayers = [select id from mrs_layer_association__c limit 1];
        for(mrs_layer_association__c m: lstLayers) {
            m.layer_status__c = 'Shipped';    
        }
        update lstLayers;
        
        Test.startTest();
        MRSApprovalService.MRSApprovalMsg msg2 = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.CUSTOMER_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_Foundry_MEBES(msg2);
        Test.stopTest();
    }
    
    @isTest
    private static void testApprovalService_layerNotFound(){
        
        list<mrs_layer_association__c> lstLayers = [select id,Name from mrs_layer_association__c limit 1];
        lstLayers[0].Name = lstLayers.get(0).Name + 'X';
        update lstLayers;
        
        Test.startTest();
        MRSApprovalService.MRSApprovalMsg msg2 = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.CUSTOMER_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_Foundry_MEBES(msg2);
        Test.stopTest();
    }
    
    
    @isTest
    private static void testApprovalService_foundry(){
        Test.startTest();
        
        MRSApprovalService.MRSApprovalMsg msg2 = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.FOUNDRY_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_Foundry_MEBES(msg2);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testApprovalService_customer(){
        Test.startTest();
        
        MRSApprovalService.MRSApprovalMsg msg2 = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.CUSTOMER_MEBES_JOBVIEW);
        MRSApprovalService.performApproval_Foundry_MEBES(msg2);
        
        Test.stopTest();
    }
}