/*
  Author: Anirban Roy
  Description: This is the test class for the CPQTranslateMaskLayerController class.
  History:
    ARoy        10272014    - code creation.                           
*/

@isTest
public class CPQTranslateMaskLayerControllerTest {
    
 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
 }
    // Test for the translation and validation
    static testMethod void cpqTranslateAndValidateTest(){
        
        CPQ_Customer_Master_Acc_Shrt_Name_List__c mstList = new CPQ_Customer_Master_Acc_Shrt_Name_List__c();
        mstList.Name = 'maxlinear';
        mstList.GDS_Customer_Name__c = 'maxlinear';
        mstList.Master_Account_Short_Name__c = 'maxlinear';
        insert mstList;
        
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, Null, Null, Null, Null);                                                                                     
                
        //rec.Mask_Set__c = 'AB BC CD DE EF FG';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        rec.Mask_Set_Long__c = 'AB BC CD DE EF FG';
        //rec.Apttus_Proposal__Account__c = acctId;
        update rec;
        
        Id gdsId = createGDS(rec.Id);
        
        createGDSLayers(gdsId);
        
        Id grId = createGR();
        
        createGRLayers(grId);
        
        createGDSTranslationLayer(gdsId, grId, rec.Id);
        
        Test.startTest();
        
        PageReference pageRef = Page.CPQTranslateMaskLayerPage;                 
        pageRef.getParameters().put('id',rec.id);
        pageRef.getHeaders().put('Referer','referer');
        Test.setCurrentPageReference(pageRef);
        
        // Translation and Mapping functionality
        CPQTranslateMaskLayerController ctml = new CPQTranslateMaskLayerController();
        String translatedRowCount = ctml.translatedRowCount;
        String GDSRowCount = ctml.GDSRowCount;
        String productRevision = ctml.productRevision;
        String productName = ctml.productName;
        String status = ctml.status;
        String fileName = ctml.fileName;
        String topCellName = ctml.topCellName;
        String GDSUploadStep = ctml.GDSUploadStep;
        String GDSApproveStep = ctml.GDSApproveStep;
        
        // Save functionality 
        PageReference pg = ctml.validationAndSave();
        system.assert(pg==null);
        
        // Cancel functionality        
        pg = ctml.cancel();
        system.assert(pg.getUrl().contains(rec.id));
        
        // Retranslate functionality    
        pg = ctml.retranslate();
        system.assert(pg==null);
        
        // Approve functionality
        pg = ctml.approve();
        system.assert(pg==null);
        
        ctml.errorMap = new Map<Integer,Boolean>();
        pg = ctml.approve();
        
        // Reject functionality
        pg = ctml.reject();
        system.assert(pg.getUrl().contains(rec.id));
        
        // Generate Excel functionality
        pg = ctml.generateExcel();
        system.assert(pg.getUrl().contains('/apex/CPQTranslateMaskLayerExportPage?id='+rec.id));
        
        // Go to Upload page functionality
        pg = ctml.goToUploadGDSPage();
        system.assert(pg.getUrl().contains('/apex/GDSUPLOAD?id='+rec.id));
        
        // Sort Status field functionality
        pg = ctml.sortByStatus();
        system.assert(pg==null); 
        
        pg = ctml.previousPage();
        
        pg = ctml.nextPage();
        
        pg = ctml.updatePage();
        
        pg = ctml.back();
        
        pg = ctml.backtoGDS();
        
        pg = ctml.backtoTranslate();
        
        Test.stopTest();
        
    }
    
    // Creation of an Account
    static Id createAccount(){      
        Account acc;    
        try{
            acc = new Account(Name='MAXLINEAR Test Account',Site_Department__c='IT',Sub_Type__c='Indirect',
                                    Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                    Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                    Corporate_City__c='Test City',Corporate_Country__c='India',Account_Manager__c=UserInfo.getUserId(),
                                    Short_Name__c='maxlinear');
            
            insert acc;
        }catch(Exception e){
            acc = [select id from Account where Short_Name__c='maxlinear'];
        }
        return acc.Id;
    }    
    
    // Creation of GDS
    static Id createGDS(Id propId){
        GDS__c gds = new GDS__c();
        gds.Quote_Proposal__c = propId;
        gds.Status__c = 'Draft';
        gds.Master_Account_Short_Name__c = 'MAXLINEAR';
        insert gds;
        return gds.Id;
    }
    
    // Creation of GDS Layers
    static void createGDSLayers(Id gdsId){
        
        List<GDS_Layer__c> gdsLayerList = new List<GDS_Layer__c>();
        
        GDS_Layer__c gdsLayer = new GDS_Layer__c();
        gdsLayer.Name = 'VTLN';
        gdsLayer.Layer_Data_Type__c = 0;
        gdsLayer.Layer_Number__c = 7;
        gdsLayer.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer);
        
        GDS_Layer__c gdsLayer1 = new GDS_Layer__c();
        gdsLayer1.Name = '1234';
        gdsLayer1.Layer_Data_Type__c = 0;
        gdsLayer1.Layer_Number__c = 9;
        gdsLayer1.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer1);
        
        GDS_Layer__c gdsLayer2 = new GDS_Layer__c();
        gdsLayer2.Name = 'PO';
        gdsLayer2.Layer_Data_Type__c = 0;
        gdsLayer2.Layer_Number__c = 17;
        gdsLayer2.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer2);
        
        GDS_Layer__c gdsLayer3 = new GDS_Layer__c();
        gdsLayer3.Name = 'OD_25_33';
        gdsLayer3.Layer_Data_Type__c = 3;
        gdsLayer3.Layer_Number__c = 18;
        gdsLayer3.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer3);
        
        GDS_Layer__c gdsLayer4 = new GDS_Layer__c();
        gdsLayer4.Name = 'NW';
        gdsLayer4.Layer_Data_Type__c = 0;
        gdsLayer4.Layer_Number__c = 3;
        gdsLayer4.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer4);
        
        GDS_Layer__c gdsLayer5 = new GDS_Layer__c();
        gdsLayer5.Name = 'PM';
        gdsLayer5.Layer_Data_Type__c = 0;
        gdsLayer5.Layer_Number__c = 5;
        gdsLayer5.GDS__c = gdsId;
        gdsLayerList.add(gdsLayer5);
        
        insert gdsLayerList;
    }
    
    // Creation of GR
    static Id createGR(){
        GR_Masterlist__c grm = new GR_Masterlist__c();
        grm.Customer__c = 'maxlinear';
        grm.PT_Name__c = '28LPS';
        grm.PT_Number__c = 'PT003079';
        insert grm;
        return grm.Id;
    }
    
    // Creation of GR Layers
    static void createGRLayers(Id grmId){
        
        List<GR_Layer__c> grmLayerList = new List<GR_Layer__c>();
        
        GR_Layer__c gr = new GR_Layer__c();
        gr.Customer_Layer_Name__c = 'VTLN';
        gr.Customer_Layer_Data_Type__c = 0;
        gr.Customer_Layer_Number__c = 7;
        gr.GF_Layer_Name__c = 'VTLN_GF';
        gr.GF_Layer_Data_Type__c = 0;
        gr.GF_Layer_Number__c = 7;
        gr.GR_Masterlist__c = grmId;
        gr.Mask_Layer__c = 'AB';
        grmLayerList.add(gr);
        
        GR_Layer__c gr1 = new GR_Layer__c();
        gr1.Customer_Layer_Name__c = 'VTLN';
        gr1.Customer_Layer_Data_Type__c = 0;
        gr1.Customer_Layer_Number__c = 7;
        gr1.GF_Layer_Name__c = 'VTLN_GF';
        gr1.GF_Layer_Data_Type__c = 0;
        gr1.GF_Layer_Number__c = 7;
        gr1.GR_Masterlist__c = grmId;
        gr1.Mask_Layer__c = 'CX';
        grmLayerList.add(gr1);
        
        GR_Layer__c gr2 = new GR_Layer__c();
        gr2.Customer_Layer_Name__c = 'VTLN';
        gr2.Customer_Layer_Data_Type__c = 0;
        gr2.Customer_Layer_Number__c = 7;
        gr2.GF_Layer_Name__c = 'VTLN_GF';
        gr2.GF_Layer_Data_Type__c = 0;
        gr2.GF_Layer_Number__c = 7;
        gr2.GR_Masterlist__c = grmId;
        gr2.Mask_Layer__c = 'BV';
        gr2.Operation__c = 'boolean_com';
        grmLayerList.add(gr2);
        
        insert grmLayerList;
        
    }
    
    static void createGDSTranslationLayer(ID gds, ID grId, ID configId){
        List<GDS__c> gdsList = new List<GDS__c>();
        List<GDS_GR_Layer_Translation__c> gdsTransLayerList = new List<GDS_GR_Layer_Translation__c>();
        
        GDS__c gdsc = new GDS__c();
        gdsc.Quote_Proposal__c = configId;
        gdsc.Status__c = 'error';
        gdsc.Master_Account_Short_Name__c = 'MAXLINEAR';
        gdsList.add(gdsc);
        
        GDS__c gds1 = new GDS__c();
        gds1.Quote_Proposal__c = configId;
        gds1.Status__c = 'warn';
        gds1.Master_Account_Short_Name__c = 'MAXLINEAR';
        gdsList.add(gds1);        
        
        GDS_GR_Layer_Translation__c gdsTransLayer = new GDS_GR_Layer_Translation__c();
        gdsTransLayer.GDS__c = gds;
        gdsTransLayer.GR_Masterlist__c = grId;
        gdsTransLayer.Quote_Proposal__c = configId;
        gdsTransLayer.CPL_Mask_Layer__c = 'RS BV';
        gdsTransLayer.GDS_Layer_Data_Type__c = 15;
        gdsTransLayer.GDS_Layer_Name__c = 'Test Layer';
        gdsTransLayer.GDS_Layer_Number__c = 10;
        gdsTransLayerList.add(gdsTransLayer);
        
        GDS_GR_Layer_Translation__c gdsTransLayer1 = new GDS_GR_Layer_Translation__c();
        gdsTransLayer1.GDS__c = gds;
        gdsTransLayer1.GR_Masterlist__c = gdsList[0].id;
        gdsTransLayer1.Quote_Proposal__c = configId;
        gdsTransLayer1.CPL_Mask_Layer__c = 'RS BV';
        gdsTransLayer1.GDS_Layer_Data_Type__c = 15;
        gdsTransLayer1.GDS_Layer_Name__c = 'Test Layer';
        gdsTransLayer1.GDS_Layer_Number__c = 10;
        gdsTransLayerList.add(gdsTransLayer1);
        
        GDS_GR_Layer_Translation__c gdsTransLayer2 = new GDS_GR_Layer_Translation__c();
        gdsTransLayer2.GDS__c = gds;
        gdsTransLayer2.GR_Masterlist__c = gdsList[1].id;
        gdsTransLayer2.Quote_Proposal__c = configId;
        gdsTransLayer2.CPL_Mask_Layer__c = 'RS BV';
        gdsTransLayer2.GDS_Layer_Data_Type__c = 15;
        gdsTransLayer2.GDS_Layer_Name__c = 'Test Layer';
        gdsTransLayer2.GDS_Layer_Number__c = 10;
        gdsTransLayerList.add(gdsTransLayer2);
        
        insert gdsTransLayerList;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = '28LPS';
        pt.PT_Number__c = 'PT003079';
        insert pt;
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     /* Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     Process_Technology_Lookup__c = pt.Id);
        
        insert proposal;
        return proposal;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}