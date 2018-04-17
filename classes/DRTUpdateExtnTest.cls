/*
    Author: Cognizant
    Description: Apex test class for DRTUpdateExtn class
    History: 
    Debasish      05/05/2014    - Apex code created
    Meenakshmi     14/05/2014    -Text code written within the present frmae of the class    
*/
@istest
public class DRTUpdateExtnTest
{
    
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
   This test method tests the below functionality of the class DRTCreateExtn for PRIME DRT
    constructor 
    populateMaskLayers()
    populateMSTOptions()
    populateMaskLayers()
    addMaskLayers()
    saveAsDraft()       
    saveAsActivate()  
  */   
    public static testMethod void TestDRTUpdateExtn()
    {
        // comment-out, refactor with testSetup method setup()
       // SwiftDataUtilityTest.customSystemData();
       Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
       system.assert(acc.Id != null);
           
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.id);
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
        system.assert(testDevice != null);
                
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
              
         PRIME_DRT_Chip_Association__c pdcaRecord=SwiftDataUtilityTest.createPrimeDrt(drt);
        
         Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
         List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        
          Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
          ApexPages.currentPage().getHeaders().put('Host',System.Label.SWIFT_Community_URL );
          ApexPages.currentPage().getParameters().put('id',drt.id);
          
         
          DRTUpdateExtn objDRTUpdateExtn = new DRTUpdateExtn(new apexpages.StandardController(drt)); 
          
          boolean isGFEmployee = objDRTUpdateExtn.isGFEmployee;
          boolean notSendEmail = objDRTUpdateExtn.notSendEmail;
        
          system.assert(maskLayer != null);
        
          objDRTUpdateExtn.objDRTDetail=drt;
          
          objDRTUpdateExtn.populateMaskLayers();
          system.assertNotEquals(objDRTUpdateExtn.maskLayerList,null); // as maskLayerList gets populated in the previous function       
           
          Set<string> StringSet=DRTUpdateExtn.fetchLayerNos(mstList[0].Id,'test-tech-geometry');
          system.assertNotEquals(StringSet,null); // as maskLayerList gets populated in the previous function       
          
          DRTUpdateExtn.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'test-tech-geometry');
          
          objDRTUpdateExtn.selectedAccount=acc.id;
          objDRTUpdateExtn.populateMSTOptions();
           system.assertNotEquals(objDRTUpdateExtn.addRowMSTString,null);  // as addRowMSTString gets populated in the previous function
          objDRTUpdateExtn.baseMST=mstList[0].Id;
          objDRTUpdateExtn.populateMaskLayers();
          //system.assertEquals(objDRTUpdateExtn.maskLayerList.size(),1); // as drt type gets populated in the previous function  
          
          DRTHandlerUtility.MaskLayerWrapper maskLayerWrap = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);     
       
          objDRTUpdateExtn.selectedMaskLayerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{maskLayerWrap});
          
          DRTHandlerUtility.ChipWrapper cw = new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name);
          
          objDRTUpdateExtn.mainTableChipListJSON = Json.serialize(new List<DRTHandlerUtility.ChipWrapper>{cw});
          
          objDRTUpdateExtn.addMaskLayers();
          
          list<string> lstMaskLayerNo = new list<string>();
          lstMaskLayerNo.add((String.valueOf(maskLayer.Mask_Layer_Number__c)));
         
          DRTUpdateExtn.MainTableClass mtc=new DRTUpdateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,pdcaRecord.Id);
        List<DRTUpdateExtn.MainTableClass> mtcList=new List<DRTUpdateExtn.MainTableClass>();
        mtcList.add(mtc);
        String serializeMTC=Json.serialize(mtcList);
  
        objDRTUpdateExtn.mainTableJSON = serializeMTC;
        
        DRTUpdateExtn.MaskLayerHeaderClass mlh1=new DRTUpdateExtn.MaskLayerHeaderClass('111','TT','002',pdlaList[0].Id);
       
        List<DRTUpdateExtn.MaskLayerHeaderClass> mlhList=new List<DRTUpdateExtn.MaskLayerHeaderClass>();
        mlhList.add(mlh1);
        
       String serializeMLH=Json.serialize(mlhList);
        
        objDRTUpdateExtn.maskLayerHeaderJSON = serializeMLH;
        
        DRTUpdateExtn.MaskLayerContentClass mlc1=new DRTUpdateExtn.MaskLayerContentClass('RR','RRC1',pdcls[0].id);
        DRTUpdateExtn.MaskLayerContentClass mlc2=new DRTUpdateExtn.MaskLayerContentClass('MR','RRC2',pdcls[1].id);
        List<DRTUpdateExtn.MaskLayerContentClass> mlcList=new List<DRTUpdateExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        mlcList.add(mlc2);
        
        List<List<DRTUpdateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTUpdateExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
       
        objDRTUpdateExtn.maskLayerContentJSON=serializeMLC;
        
        Pagereference pageref=objDRTUpdateExtn.saveAsDraft();   
          //system.assertNotEquals(pageref,null);  // as drt update takes place      
        objDRTUpdateExtn.saveAsActive();
     
        DRTUpdateExtn.fetchChipLayerComboData(chip_Detail.Name,maskLayer.Mask_Layer_Number__c,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c);
        
        DRTHandlerUtility.MaskLayerWrapper mlw = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
        String layerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{mlw});
        
        DRTUpdateExtn.fetchNewChipLayerData(chip_Detail.Name,layerJSON,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c,1);    
         
          test.stopTest();
      //}
  }
  
   /*
   This test method tests the below functionality of the class DRTCreateExtn for FRAME DRT
    constructor 
    populateMaskLayers()
    fetchLayerNos()
    populateMSTOptions()
    populateMaskLayers()
    saveAsDraft()
    saveAsActive()
  */   
  public static testMethod void TestDRTUpdateExtnForFrame()
  {
        // comment-out, refactor with testSetup method setup()  
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
      
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTListForFrame(1,mstList[0],acc.id);
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
        PRIME_DRT_Chip_Association__c pdcaRecord=SwiftDataUtilityTest.createPrimeDrt(drt);

        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
       
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        ApexPages.currentPage().getHeaders().put('Host',System.Label.SWIFT_Community_URL );
          ApexPages.currentPage().getParameters().put('id',drt.id);
                   
          DRTUpdateExtn objDRTUpdateExtn = new DRTUpdateExtn(new apexpages.StandardController(drt)); 
          objDRTUpdateExtn.objDRTDetail=drt;
          
          objDRTUpdateExtn.populateMaskLayers();
           system.assertNotEquals(objDRTUpdateExtn.maskLayerList,null); // as maskLayerList gets populated in the previous function       
          
          Set<string> StringSet=DRTUpdateExtn.fetchLayerNos(mstList[0].Id,'test-tech-geometry');
          system.assertNotEquals(StringSet,null); // as maskLayerList gets populated in the previous function 
          DRTUpdateExtn.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'test-tech-geometry');
      
          objDRTUpdateExtn.selectedAccount=acc.id;
          objDRTUpdateExtn.populateMSTOptions();
          objDRTUpdateExtn.baseMST=mstList[0].Id;
          objDRTUpdateExtn.populateMaskLayers(); 
          system.assertEquals(objDRTUpdateExtn.maskLayerList.size(),1); // as drt type gets populated in the previous function  
         
          list<string> lstMaskLayerNo = new list<string>();
          lstMaskLayerNo.add((String.valueOf(maskLayer.Mask_Layer_Number__c)));
        
          DRTUpdateExtn.MainTableClass mtc=new DRTUpdateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,pdcaRecord.Id);
        List<DRTUpdateExtn.MainTableClass> mtcList=new List<DRTUpdateExtn.MainTableClass>();
        mtcList.add(mtc);
        String serializeMTC=Json.serialize(mtcList);
        
        objDRTUpdateExtn.mainTableJSON = serializeMTC;
        
        DRTUpdateExtn.MaskLayerHeaderClass mlh1=new DRTUpdateExtn.MaskLayerHeaderClass('111','TT','002',pdlaList[0].Id);
        List<DRTUpdateExtn.MaskLayerHeaderClass> mlhList=new List<DRTUpdateExtn.MaskLayerHeaderClass>();
        mlhList.add(mlh1);
        
        String serializeMLH=Json.serialize(mlhList);
        objDRTUpdateExtn.maskLayerHeaderJSON = serializeMLH;
        
        DRTUpdateExtn.MaskLayerContentClass mlc1=new DRTUpdateExtn.MaskLayerContentClass('RMR1','RRC1',pdcls[0].id);
        DRTUpdateExtn.MaskLayerContentClass mlc2=new DRTUpdateExtn.MaskLayerContentClass('RMR2','RRC2',pdcls[0].id);
        List<DRTUpdateExtn.MaskLayerContentClass> mlcList=new List<DRTUpdateExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        mlcList.add(mlc2);
        
        List<List<DRTUpdateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTUpdateExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
        objDRTUpdateExtn.maskLayerContentJSON=serializeMLC;
        
        DRTUpdateExtn.FrameTableClass ftc =new DRTUpdateExtn.FrameTableClass(mstList[0].Id,maskLayer.Mask_Layer_Number__c,fdaList[0].Retrofit_Mask_Rev__c,fdaList[0].Retrofit_ROM_Code__c,maskLayer.Mask_Layer_Number__c,maskLayer.ROM_Code__c);
        List<DRTUpdateExtn.FrameTableClass> ftcList=new List<DRTUpdateExtn.FrameTableClass>();
        ftcList.add(ftc);
        
        String serializeFTC=Json.serialize(ftcList);
         system.assert(serializeFTC != null);
        objDRTUpdateExtn.frameTableJSON = serializeFTC;
        
        objDRTUpdateExtn.saveAsDraft();   
        objDRTUpdateExtn.saveAsActive();
       
          test.stopTest();
      }
      
    /*
   This test method tests the below functionality of the class DRTCreateExtn for PRIME DRT
    constructor 
    populateMaskLayers()
    fetchLayerNos()
    populateMSTOptions()
    populateMaskLayers()
    saveAsDraft()
    saveAsActive() 
  */      
      
   public static testMethod void TestDRTUpdateExtnForPrime ()
  {
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
              Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList2(1,mstList[0],acc.id);
        DRT__c drt=drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
         List<PRIME_DRT_Layer_Association__c> pdlaList1=SwiftDataUtilityTest.createPDLA1(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        List<PRIME_DRT_Chip_Association__c> pdcaList1=SwiftDataUtilityTest.createPDCA1(drt.Id,mstList[0].Id);
         
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
         List<PRIME_DRT_Chip_Layer_Summary__c> pdcls1=SwiftDataUtilityTest.createPDCLS1(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id); 
        
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id); 
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        
         PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
        PRIME_DRT_Chip_Association__c pdcaRecord=SwiftDataUtilityTest.createPrimeDrt(drt);

        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
       
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
         ApexPages.currentPage().getHeaders().put('Host',System.Label.SWIFT_Community_URL );
          ApexPages.currentPage().getParameters().put('id',drt.id);
          
          DRTUpdateExtn objDRTUpdateExtn = new DRTUpdateExtn(new apexpages.StandardController(drt)); 
          objDRTUpdateExtn.objDRTDetail=drt;
          
          objDRTUpdateExtn.populateMaskLayers();
           
         Set<string> StringSet=DRTUpdateExtn.fetchLayerNos(mstList[0].Id,'test-tech-geometry');
          system.assertNotEquals(StringSet,null); // as maskLayerList gets populated in the previous function 
          DRTUpdateExtn.fetchMaskRevROMCode(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'test-tech-geometry');
         
         
          objDRTUpdateExtn.selectedAccount=acc.id;
          objDRTUpdateExtn.populateMSTOptions();
          objDRTUpdateExtn.baseMST=mstList[0].Id;
          objDRTUpdateExtn.populateMaskLayers();
           system.assertEquals(objDRTUpdateExtn.maskLayerList.size(),1); // as drt type gets populated in the previous function  
         
          list<string> lstMaskLayerNo = new list<string>();
          lstMaskLayerNo.add((String.valueOf(maskLayer.Mask_Layer_Number__c)));
              
          DRTUpdateExtn.MainTableClass mtc=new DRTUpdateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,pdcaRecord.Id);
        List<DRTUpdateExtn.MainTableClass> mtcList=new List<DRTUpdateExtn.MainTableClass>();
        mtcList.add(mtc);
        String serializeMTC=Json.serialize(mtcList);
        objDRTUpdateExtn.mainTableJSON = serializeMTC;
        
       
        DRTUpdateExtn.MaskLayerHeaderClass mlh1=new DRTUpdateExtn.MaskLayerHeaderClass('111','TT','002',pdlaList[0].Id);
      
        List<DRTUpdateExtn.MaskLayerHeaderClass> mlhList=new List<DRTUpdateExtn.MaskLayerHeaderClass>();
        mlhList.add(mlh1);
        
        String serializeMLH=Json.serialize(mlhList);
           
        objDRTUpdateExtn.maskLayerHeaderJSON = serializeMLH;
        
        
        DRTUpdateExtn.MaskLayerContentClass mlc1=new DRTUpdateExtn.MaskLayerContentClass('RMR1','RRC1',pdcls[0].id);
        DRTUpdateExtn.MaskLayerContentClass mlc2=new DRTUpdateExtn.MaskLayerContentClass('RMR2','RRC2',pdcls[0].id);
        List<DRTUpdateExtn.MaskLayerContentClass> mlcList=new List<DRTUpdateExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        mlcList.add(mlc2);
        
        List<List<DRTUpdateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTUpdateExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
        
        objDRTUpdateExtn.maskLayerContentJSON=serializeMLC;
        
        objDRTUpdateExtn.saveAsDraft();   
        objDRTUpdateExtn.saveAsActive();
     
          test.stopTest();
      //}
  }
  
  
  
    public static testMethod void testAddIn1() {
        
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.id);
        DRT__c drt=drtList[0];
        
        ApexPages.currentPage().getHeaders().put('Host',System.Label.SWIFT_Community_URL );
        ApexPages.currentPage().getParameters().put('id',drt.id);
        
        DRTUpdateExtn extn = new DRTUpdateExtn(new apexpages.StandardController(drt)); 
        
        try { PageReference pr = extn.validateChipDeletion(); } catch(Exception e) {}
        
        try {extn.sendMailOnActivation(null, ''); } catch(Exception e) {}
        
        try { extn.sendMailOnActivation(null, 'testDRT'); } catch(Exception e) {}
        
        extn.fromPage = '';
        extn.maskLayerJSON = '';
        extn.isSaveByUser = true;
        
        DRTUpdateExtn.MaskLayerRow mskr = new DRTUpdateExtn.MaskLayerRow(1, '123', '12', '21');
        mskr.isEdited_maskRev = true;
        mskr.isEdited_romCode = true;
        
    }
    
    public static testMethod void testAddIn2() {
        List<SObject> dummyList = new List<SObject>();
        dummyList.add(new Account());
        try { DRTUpdateExtn.insertUpdateDeleteData(dummyList, null, null); } catch(Exception e) {}
        try { DRTUpdateExtn.insertUpdateDeleteData(null, dummyList, null); } catch(Exception e) {}
        try { DRTUpdateExtn.insertUpdateDeleteData(null, null, dummyList); } catch(Exception e) {}
        try { DRTUpdateExtn.insertUpdateDeleteData(null, null, null); } catch(Exception e) {}
    }
    
    public static testMethod void testAddIn3() {
        
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.id);
        DRT__c drt=drtList[0];
        
        mask_set_title__c mstId = [select id from mask_set_title__c limit 1];
        try { DRTUpdateExtn.fetchChipNames(mstId.id,'0.020',drt.id); } catch(Exception e) {}       
        
    }
    
  
}