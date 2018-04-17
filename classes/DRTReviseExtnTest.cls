/*
    Author: Cognizant
    Description: Apex test class for DRTReviseExtn class
    History: 
    Cognizant      05/05/2014    - Apex code created
*/ 
@istest
public class DRTReviseExtnTest {
    
    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }
    
     /*
   This test method tests the below functionality of the class DRTReviseExtn for PRIME DRT
    constructor 
    fetchChipNames()
    populateMSTOptions()
    populateMaskLayers()
    addMaskLayers()
    saveAsDraft()
    saveAsActivate()  
  */  
    public static testMethod void DRTReviseExtnTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.label.Swift_Host_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','Revise');
        
        // comment-out, refactor with testSetup method setup()
        //load the custom settings
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];
         
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTReviseExtn  testController = new DRTReviseExtn(new ApexPages.StandardController(drt));
        
        List<String> chipNameList = DRTReviseExtn.fetchChipNames(mstList[0].Id,ptrf.Tech_Geo__c);
        system.assertEquals(chip_Detail.Name,chipNameList.get(0));
        
        testController.selectedAccount=acc.id;
        testController.populateMSTOptions();
        
        testController.baseMST=mstList[0].Id;
        testController.populateMaskLayers();
        //system.assertEquals(1, testController.maskLayerList.size());
        //system.assertEquals('111',testController.maskLayerList.get(0).layerNo);
        
        DRTHandlerUtility.MaskLayerWrapper maskLayerWrap = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
        
        testController.selectedMaskLayerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{maskLayerWrap});
      
        DRTHandlerUtility.ChipWrapper cw = new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name);
      
        testController.mainTableChipListJSON = Json.serialize(new List<DRTHandlerUtility.ChipWrapper>{cw});
      
        testController.addMaskLayers();
        system.assertEquals(1,testController.lstSelectedMaskLayer.size());
        
        DRTReviseExtn.MainTableClass mtc=new DRTReviseExtn.MainTableClass(chip_Detail.Name,mstList[0].Id);
        List<DRTReviseExtn.MainTableClass> mtcList=new List<DRTReviseExtn.MainTableClass>();
        mtcList.add(mtc);
        String serializeMTC=Json.serialize(mtcList);
        testController.mainTableJSON = serializeMTC;
        
        DRTReviseExtn.MaskLayerHeaderClass mlh1=new DRTReviseExtn.MaskLayerHeaderClass('111','TT','002');
        DRTReviseExtn.MaskLayerHeaderClass mlh2=new DRTReviseExtn.MaskLayerHeaderClass('222','PP','001');
        List<DRTReviseExtn.MaskLayerHeaderClass> mlhList=new List<DRTReviseExtn.MaskLayerHeaderClass>();
        mlhList.add(mlh1);
        mlhList.add(mlh2);
        
        String serializeMLH=Json.serialize(mlhList);
        testController.maskLayerHeaderJSON = serializeMLH;
        
        DRTReviseExtn.MaskLayerContentClass mlc1=new DRTReviseExtn.MaskLayerContentClass('RR','RRC1');
        DRTReviseExtn.MaskLayerContentClass mlc2=new DRTReviseExtn.MaskLayerContentClass('MR','RRC2');
        List<DRTReviseExtn.MaskLayerContentClass> mlcList=new List<DRTReviseExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        mlcList.add(mlc2);
        
        List<List<DRTReviseExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTReviseExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
        testController.maskLayerContentJSON = serializeMLC;
        
        Pagereference p = testController.saveAsDraft();  
        if(p!=null){
            String drtId=p.getParameters().get('Id');
            DRT__c drtRevised =[select id,name,Status__c from DRT__c where id = :drtId];
            //The actual DRT has the name MYMST_PRIME_DRT_001.001, after revise the minor version should increase by 001            
            system.assertEquals('MYMST_PRIME_DRT_001.002', drtRevised.Name);
            system.assertEquals('Draft',drtRevised.Status__c);
        }
        
        Pagereference p1 = testController.saveAsActive();
        if(p1 != null){
            String drtId=p1.getParameters().get('Id');
            DRT__c drtRevised =[select id,name,Status__c from DRT__c where id = :drtId];
            //The actual DRT has the name MYMST_PRIME_DRT_001.001, after revise the minor version should increase by 001            
            system.assertEquals('MYMST_PRIME_DRT_001.003', drtRevised.Name);
            system.assertEquals('Active',drtRevised.Status__c);
        } 
        
        drt.Status__c = 'Closed';
        update drt;
        
        
        ptrf.Status__c='Closed';
        update ptrf;
        
        
        DRTReviseExtn  testController1 = new DRTReviseExtn(new ApexPages.StandardController(drt));    
        testController1.mstOptions=new List<SelectOption>();
        testController1.populateMSTOptions();     
        
        list<list<string>> chipLayerComboDataList = DRTReviseExtn.fetchChipLayerComboData(chip_Detail.Name,maskLayer.Mask_Layer_Number__c,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c);
        system.assertEquals(2,chipLayerComboDataList.size());
        
        DRTHandlerUtility.MaskLayerWrapper mlw = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
        String layerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{mlw});
        
        String serializeLayerDataList = DRTReviseExtn.fetchNewChipLayerData(chip_Detail.Name,layerJSON,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c,1);
        system.assertNotEquals(0,serializeLayerDataList.length()); 
        test.stopTest();
    }
    
      /*
   This test method tests the below functionality of the class DRTReviseExtn for PRIME DRT
    constructor 
    validateChipDeletion()
  */  
    @isTest
    public static void drtStatusAsActive(){
        ApexPages.currentPage().getHeaders().put('Host',system.label.Swift_Host_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','Revise');
        
        // comment-out, refactor with testSetup method setup()
        //load the custom settings
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList2(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        
        PTRF__c ptrf=new PTRF__c();
        ptrf.Name = 'PTRF1';
        ptrf.Device__c = testDevice.Id;
        ptrf.Customer__c=acc.Id;
        ptrf.Device_Id__c = testDevice.Id;
        //ptrf.Transaction_Type__c = 'LIFECYCLE';
        ptrf.Transaction_Date__c = date.today();
        ptrf.Order_Type__c = 'TEST';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Frame_Tapeout__c = true;
        ptrf.Frame_Mockup__c = true;
        ptrf.Mask_Set_Title__c = mstList[0].Id;
        ptrf.MaskSetTitle__c=mstList[0].Id;
        ptrf.Status__c='Perform Tapeout Options';
        ptrf.Prime_DRT__c = 'Prime';
        ptrf.Frame_DRT__c = 'Frame';        
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.Recticle_Type__c='Multi Node Reticle (MNR)';
        insert ptrf;

        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA(drt);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        DRTReviseExtn.ChipWrapper Revcw = new DRTReviseExtn.ChipWrapper('1',chip_Detail.Id,chip_Detail.Name,mstList[0].Id,mstList[0].name);
        DRTReviseExtn  testController = new DRTReviseExtn(new ApexPages.StandardController(drt));
        DRTHandlerUtility.ChipWrapper cw = new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name);
        testController.selectedChipsJSON = Json.serialize(new List<DRTHandlerUtility.ChipWrapper>{cw});
        testController.validateChipDeletion();
        system.assertEquals(testController.lstDRTErrorMessage.size(), 0);    
        test.stopTest();   
        
    }
    
       /*
   This test method tests the below functionality of the class DRTReviseExtn for FRAME DRT
    constructor 
    fetchChipNames()
    saveAsDraft()
    saveAsActivate()  
  */  
    
    public static testMethod void DRTReviseExtnTestDrtTypeFrame(){
        ApexPages.currentPage().getHeaders().put('Host',system.label.Swift_Host_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        // comment-out, refactor with testSetup method setup()
        //load the custom settings
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTListForFrame(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTReviseExtn  testController = new DRTReviseExtn(new ApexPages.StandardController(drt));
        testController.selectedDrtType='FRAME';
        
        List<String> chipNameList = DRTReviseExtn.fetchChipNames(mstList[0].Id,ptrf.Tech_Geo__c);
        system.assertEquals(chip_Detail.Name,chipNameList.get(0));
        
        DRTReviseExtn.MainTableClass mtc=new DRTReviseExtn.MainTableClass(chip_Detail.Name,mstList[0].Id);
        List<DRTReviseExtn.MainTableClass> mtcList=new List<DRTReviseExtn.MainTableClass>();
        mtcList.add(mtc);
        String serializeMTC=Json.serialize(mtcList);
        testController.mainTableJSON = serializeMTC;
        
        DRTReviseExtn.MaskLayerHeaderClass mlh1=new DRTReviseExtn.MaskLayerHeaderClass('MLN001','RMR1','RRC1');
        DRTReviseExtn.MaskLayerHeaderClass mlh2=new DRTReviseExtn.MaskLayerHeaderClass('MLN001','RMR2','RRC2');
        List<DRTReviseExtn.MaskLayerHeaderClass> mlhList=new List<DRTReviseExtn.MaskLayerHeaderClass>();
        mlhList.add(mlh1);
        mlhList.add(mlh2);
        
        String serializeMLH=Json.serialize(mlhList);
        testController.maskLayerHeaderJSON = serializeMLH;
        
        DRTReviseExtn.MaskLayerContentClass mlc1=new DRTReviseExtn.MaskLayerContentClass('RMR1','RRC1');
        DRTReviseExtn.MaskLayerContentClass mlc2=new DRTReviseExtn.MaskLayerContentClass('RMR2','RRC2');
        List<DRTReviseExtn.MaskLayerContentClass> mlcList=new List<DRTReviseExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        mlcList.add(mlc2);
        
        List<List<DRTReviseExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTReviseExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
        testController.maskLayerContentJSON = serializeMLC;
        
        DRTReviseExtn.FrameTableClass ftc =new DRTReviseExtn.FrameTableClass(mstList[0].Id,maskLayer.Mask_Layer_Number__c,fdaList[0].Retrofit_Mask_Rev__c,fdaList[0].Retrofit_ROM_Code__c,maskLayer.Mask_Layer_Number__c,maskLayer.ROM_Code__c);
        List<DRTReviseExtn.FrameTableClass> ftcList=new List<DRTReviseExtn.FrameTableClass>();
        ftcList.add(ftc);
        
        String serializeFTC=Json.serialize(ftcList);
        testController.frameTableJSON = serializeFTC;
        
        Pagereference p1 = testController.saveAsDraft();
        if(p1!=null){
            String drtId=p1.getParameters().get('Id');
            
            DRT__c drtRevised =[select id,name,Status__c from DRT__c where id = :drtId];
            system.assertEquals('MYMST_PRIME_DRT_035.002', drtRevised.Name);
            system.assertEquals('Draft',drtRevised.Status__c);
        }  
        
        Pagereference p2 = testController.saveAsActive();
        if(p2 != null){
            String drtId=p2.getParameters().get('Id');
            DRT__c drtRevised =[select id,name,Status__c from DRT__c where id = :drtId];
            //The actual DRT has the name MYMST_PRIME_DRT_001.002, after revise the minor version should increase by 001            
            system.assertEquals('MYMST_PRIME_DRT_035.003', drtRevised.Name);
            system.assertEquals('Active',drtRevised.Status__c);
        }
        Set<String> LayerSet = DRTReviseExtn.fetchLayerNos(mstList[0].Id,'test-tech-geometry');
        system.assertNotEquals(0,LayerSet.size());
        
        List<List<String>> maskRevROMCodeListOfList = DRTReviseExtn.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'test-tech-geometry');
        system.assertNotEquals(0,maskRevROMCodeListOfList.size());
        
        test.stopTest();
    }
}