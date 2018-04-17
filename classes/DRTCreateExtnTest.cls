/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTCreate.
                This will also call the handler class DRTHandlerUtility which will contain
                all the business logic regarding the DRT Creation process. 
History:
    Cognizant     18032014     - Initial Version
    Cognizant     23032014     - Modified function saveFrameDRT change in save logic
    Cognizant     10052014     - Modified function populateChipDetails for null checking
*/

@istest(SeeAllData=false)
public class DRTCreateExtnTest 
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
    populateAccountOptions()
    populateMSTOptions()
    populateDrtTypeOptions()
    popuateTechGeoOptions()
    populateChipDetails()
    populateMaskLayers()
    addMaskLayers()
    saveAsActivate()  
  */  
  public static testMethod void TestDRTCreateExtn ()
  {
    Map<String,String> acctIdNameMap; 
    // comment-out, refactored with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
                  
    Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
      
    List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
    List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
    DRT__c drt=drtList[0];
    Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
    Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
    Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
    
    test.startTest();
    
    Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
    PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
    Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
    Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);   
       
  ApexPages.currentPage().getParameters().put('retURL',System.Label.Internal_URL ) ;
  ApexPages.currentPage().getHeaders().put('Host',System.Label.Internal_URL );
  
  DRTCreateExtn objDRTCreateExtn= new DRTCreateExtn (new apexpages.StandardController(new DRT__c()));
  objDRTCreateExtn.drtName=drt.name;
  objDRTCreateExtn.populateAccountOptions();
  objDRTCreateExtn.acctIdNameMap.put(acc.Id,acc.Name);
  objDRTCreateExtn.selectedAccount=acc.id;
  objDRTCreateExtn.populateMSTOptions();
  system.assertNotEquals(objDRTCreateExtn.addRowMSTString,null);  // as addRowMSTString gets populated in the previous function       
  objDRTCreateExtn.baseMST=mstList[0].Id;
  system.assertNotEquals(objDRTCreateExtn.baseMSTName,null);
  boolean isGFEmployee = objDRTCreateExtn.isGFEmployee;
  boolean notSendEmail = objDRTCreateExtn.notSendEmail;
  
  objDRTCreateExtn.populateDrtTypeOptions(); 
   system.assertEquals(objDRTCreateExtn.drtTypeOptions.size(),3);  // as drt type gets populated in the previous function       
  system.assertNotEquals(objDRTCreateExtn.drtTypeOptions,null);  // as drt type gets populated in the previous function       
  
  objDRTCreateExtn.selectedDrtType='PRIME';
  objDRTCreateExtn.popuateTechGeoOptions();
  
  objDRTCreateExtn.selectedTechGeo = '0.02UM (20nm)';
  objDRTCreateExtn.populateChipDetails(); // proceed     
       
  objDRTCreateExtn.description='description';
  objDRTCreateExtn.populateMaskLayers();
 
  DRTHandlerUtility.MaskLayerWrapper maskLayerWrap = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
                   
  objDRTCreateExtn.selectedMaskLayerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{maskLayerWrap});          
  DRTHandlerUtility.ChipWrapper cw = new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name);          
  objDRTCreateExtn.mainTableChipListJSON = Json.serialize(new List<DRTHandlerUtility.ChipWrapper>{cw});
  objDRTCreateExtn.addMaskLayers();
  List<String> lstChipName =DRTCreateExtn.fetchChipNames(mstList[0].Id,'0.02UM');  
                    
    DRTCreateExtn.MainTableClass mtc=new DRTCreateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,ptrf.Id);
    List<DRTCreateExtn.MainTableClass> mtcList=new List<DRTCreateExtn.MainTableClass>();
    mtcList.add(mtc);
    String serializeMTC=Json.serialize(mtcList); 
   
    objDRTCreateExtn.mainTableJSON = serializeMTC;
    
    DRTCreateExtn.MaskLayerHeaderClass mlh1=new DRTCreateExtn.MaskLayerHeaderClass('111','TT','002');
    
    List<DRTCreateExtn.MaskLayerHeaderClass> mlhList=new List<DRTCreateExtn.MaskLayerHeaderClass>();
    mlhList.add(mlh1);
           
    String serializeMLH=Json.serialize(mlhList);  
   
    objDRTCreateExtn.maskLayerHeaderJSON = serializeMLH;
    
    DRTCreateExtn.MaskLayerContentClass mlc1=new DRTCreateExtn.MaskLayerContentClass('RM','RRC1');
    
    List<DRTCreateExtn.MaskLayerContentClass> mlcList=new List<DRTCreateExtn.MaskLayerContentClass>();
    mlcList.add(mlc1);
    
    List<List<DRTCreateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTCreateExtn.MaskLayerContentClass>>();
    lstMaskLayerContentData.add(mlcList);
    
    String serializeMLC=Json.serialize(lstMaskLayerContentData);
    objDRTCreateExtn.maskLayerContentJSON = serializeMLC;
 
    DRTCreateExtn.fetchChipLayerComboData(chip_Detail.Name,maskLayer.Mask_Layer_Number__c,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c);
    
    DRTHandlerUtility.MaskLayerWrapper mlw = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
    String layerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{mlw});
    
    DRTCreateExtn.fetchNewChipLayerData(chip_Detail.Name,layerJSON,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c,1);
     
    Pagereference p1 = objDRTCreateExtn.saveAsActivate();
    if(p1 != null){
        String drtId=p1.getParameters().get('Id');
        DRT__c drtObj =[select id,name,Status__c from DRT__c where id = :drtId];
        system.assertEquals('MYMST0_PRIME_DRT_002.001', drtObj.Name);
        system.assertEquals('Active',drtObj.Status__c);
        } 
    
    test.stopTest();
  }
  
   /*
  This test method tests the below functionality of the class DRTCreateExtn PRIME DRT
    constructor 
    populateAccountOptions()
    populateMSTOptions()
    populateDrtTypeOptions()
    popuateTechGeoOptions()
    populateChipDetails()
    populateMaskLayers()
    addMaskLayers()
    saveAsDraft()  
  */
  public static testMethod void TestDRTCreateExtnSaveAsDraft ()
  {
    Map<String,String> acctIdNameMap; 
    // comment-out, refactor with testSetup method setup()
    // SwiftDataUtilityTest.customSystemData();
                  
    Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
    List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
    List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
    DRT__c drt=drtList[0];
    Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
    Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
    Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
    
    test.startTest();
    
    Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
    PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
    Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
    Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);   
       
  ApexPages.currentPage().getParameters().put('retURL',System.Label.Internal_URL ) ;
  ApexPages.currentPage().getHeaders().put('Host',System.Label.Internal_URL );
  
  DRTCreateExtn objDRTCreateExtn= new DRTCreateExtn (new apexpages.StandardController(new DRT__c()));
  objDRTCreateExtn.drtName=drt.name;
  objDRTCreateExtn.populateAccountOptions();
  objDRTCreateExtn.acctIdNameMap.put(acc.Id,acc.Name);
  objDRTCreateExtn.selectedAccount=acc.id;
  objDRTCreateExtn.populateMSTOptions();
  system.assertNotEquals(objDRTCreateExtn.addRowMSTString,null);  // as addRowMSTString gets populated in the previous function       
  objDRTCreateExtn.baseMST=mstList[0].Id;
  system.assertNotEquals(objDRTCreateExtn.baseMSTName,null);
  
  objDRTCreateExtn.populateDrtTypeOptions(); 
   system.assertEquals(objDRTCreateExtn.drtTypeOptions.size(),3);  // as drt type gets populated in the previous function       
  system.assertNotEquals(objDRTCreateExtn.drtTypeOptions,null);  // as drt type gets populated in the previous function       
  
  objDRTCreateExtn.selectedDrtType='PRIME';
  objDRTCreateExtn.popuateTechGeoOptions();
  
  objDRTCreateExtn.selectedTechGeo = '0.02UM (20nm)';
  objDRTCreateExtn.populateChipDetails(); // proceed     
       
  objDRTCreateExtn.description='description';
  objDRTCreateExtn.populateMaskLayers();
 
  DRTHandlerUtility.MaskLayerWrapper maskLayerWrap = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
                   
  objDRTCreateExtn.selectedMaskLayerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{maskLayerWrap});          
  DRTHandlerUtility.ChipWrapper cw = new DRTHandlerUtility.ChipWrapper(mstList[0].Id,chip_Detail.Name);          
  objDRTCreateExtn.mainTableChipListJSON = Json.serialize(new List<DRTHandlerUtility.ChipWrapper>{cw});
  objDRTCreateExtn.addMaskLayers();
  List<String> lstChipName =DRTCreateExtn.fetchChipNames(mstList[0].Id,'0.02UM');  
          
                    
    DRTCreateExtn.MainTableClass mtc=new DRTCreateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,ptrf.Id);
    List<DRTCreateExtn.MainTableClass> mtcList=new List<DRTCreateExtn.MainTableClass>();
    mtcList.add(mtc);
    String serializeMTC=Json.serialize(mtcList); 
   
    objDRTCreateExtn.mainTableJSON = serializeMTC;
    
    DRTCreateExtn.MaskLayerHeaderClass mlh1=new DRTCreateExtn.MaskLayerHeaderClass('111','TT','002');
    
    List<DRTCreateExtn.MaskLayerHeaderClass> mlhList=new List<DRTCreateExtn.MaskLayerHeaderClass>();
    mlhList.add(mlh1);
           
    String serializeMLH=Json.serialize(mlhList);  
   
    objDRTCreateExtn.maskLayerHeaderJSON = serializeMLH;
    
    DRTCreateExtn.MaskLayerContentClass mlc1=new DRTCreateExtn.MaskLayerContentClass('RM','RRC1');
    
    List<DRTCreateExtn.MaskLayerContentClass> mlcList=new List<DRTCreateExtn.MaskLayerContentClass>();
    mlcList.add(mlc1);
    
    List<List<DRTCreateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTCreateExtn.MaskLayerContentClass>>();
    lstMaskLayerContentData.add(mlcList);
    
    String serializeMLC=Json.serialize(lstMaskLayerContentData);
    objDRTCreateExtn.maskLayerContentJSON = serializeMLC;
 
    DRTCreateExtn.fetchChipLayerComboData(chip_Detail.Name,maskLayer.Mask_Layer_Number__c,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c);
    
    DRTHandlerUtility.MaskLayerWrapper mlw = new DRTHandlerUtility.MaskLayerWrapper(maskLayer.Mask_Layer_Number__c,maskLayer.Mask_Layer_Rev__c,maskLayer.ROM_Code__c);
    String layerJSON = Json.serialize(new List<DRTHandlerUtility.MaskLayerWrapper>{mlw});
    
    DRTCreateExtn.fetchNewChipLayerData(chip_Detail.Name,layerJSON,mstList[0].Id,mstList[0].Id,ptrf.Tech_Geo_Value__c,1);
     
    Pagereference p1 = objDRTCreateExtn.saveAsDraft();
    if(p1 != null){
        String drtId=p1.getParameters().get('Id');
        DRT__c drtObj =[select id,name,Status__c from DRT__c where id = :drtId];
        system.assertEquals('MYMST0_PRIME_DRT_002.001', drtObj.Name);
        system.assertEquals('Draft',drtObj.Status__c);
        } 
    
    test.stopTest();
  }
  
   /*
  This test method tests the below functionality of the class DRTCreateExtn FRAME DRT
    constructor 
    populateAccountOptions()
    populateMSTOptions()
    populateDrtTypeOptions()
    popuateTechGeoOptions()
    populateChipDetails()
    populateMaskLayers()
    addMaskLayers()
    saveAsActivate()  
  */
   public static testMethod void TestDRTCreateExtnForFrame ()
  {
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        DRT__c drt=drtList[0];  
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id); 
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);   
       
        ApexPages.currentPage().getParameters().put('retURL',System.Label.Internal_URL ) ;
        ApexPages.currentPage().getHeaders().put('Host',System.Label.Internal_URL );
        
        //Frame DRT 
        
       DRTCreateExtn objDRTCreateExtn= new DRTCreateExtn (new apexpages.StandardController(new DRT__c()));
       objDRTCreateExtn.drtName=drt.name;
       objDRTCreateExtn.populateAccountOptions();
       objDRTCreateExtn.acctIdNameMap.put(acc.Id,acc.Name);
       objDRTCreateExtn.selectedAccount=acc.id;
       objDRTCreateExtn.populateMSTOptions();
       system.assertNotEquals(objDRTCreateExtn.addRowMSTString,null);  
       objDRTCreateExtn.baseMST=mstList[0].Id;
       system.assertNotEquals(objDRTCreateExtn.baseMSTName,null);
       objDRTCreateExtn.populateDrtTypeOptions();
       system.assertEquals(objDRTCreateExtn.drtTypeOptions.size(),3);  // as drt type gets populated in the previous function       
       system.assertNotEquals(objDRTCreateExtn.drtTypeOptions,null);  // as drt type gets populated in the previous function       
               
       objDRTCreateExtn.selectedDrtType='FRAME';
       objDRTCreateExtn.popuateTechGeoOptions();          
      
       objDRTCreateExtn.selectedTechGeo = '0.02UM (20nm)';
       objDRTCreateExtn.populateChipDetails(); // proceed          
       objDRTCreateExtn.description='description';
       objDRTCreateExtn.populateMaskLayers();     
       DRTCreateExtn.FrameTableClass ftc = new DRTCreateExtn.FrameTableClass(mstList[0].Id,maskLayer.Mask_Layer_Number__c,'AA','22',maskLayer.Mask_Layer_Number__c,maskLayer.ROM_Code__c);
       List<DRTCreateExtn.FrameTableClass> ftcList=new List<DRTCreateExtn.FrameTableClass>();
       ftcList.add(ftc);
        
       String serializeFTC=Json.serialize(ftcList);
       objDRTCreateExtn.frameTableJSON = serializeFTC;
       DRTCreateExtn.fetchLayerNos(mstList[0].Id,'0.02UM');            
       DRTCreateExtn.fetchMaskRevROMCode(mstList[0].Id,'111','0.02UM');
       objDRTCreateExtn.populateMSTOptions();
       system.assertNotEquals(objDRTCreateExtn.addRowMSTString,null);  
       objDRTCreateExtn.populateDrtTypeOptions();          
       system.assertEquals(objDRTCreateExtn.drtTypeOptions.size(),3);  // as drt type gets populated in the previous function       
       system.assertNotEquals(objDRTCreateExtn.drtTypeOptions,null);  // as drt type gets populated in the previous function       
     
       objDRTCreateExtn.popuateTechGeoOptions();
      
       objDRTCreateExtn.populateChipDetails(); // proceed
       objDRTCreateExtn.description='description';
       objDRTCreateExtn.populateMaskLayers();     
       
       list<string> lstMaskLayerNo = new list<string>();
       lstMaskLayerNo.add((String.valueOf(maskLayer.Mask_Layer_Number__c)));
       DRTCreateExtn.fetchChipNames(mstList[0].Id,'0.02UM');
          
          
       DRTCreateExtn.MainTableClass mtc=new DRTCreateExtn.MainTableClass(chip_Detail.Name,mstList[0].Id,ptrf.Id);
       List<DRTCreateExtn.MainTableClass> mtcList=new List<DRTCreateExtn.MainTableClass>();
       mtcList.add(mtc);
       String serializeMTC=Json.serialize(mtcList);
       objDRTCreateExtn.mainTableJSON = serializeMTC;
       
       DRTCreateExtn.MaskLayerHeaderClass mlh1=new DRTCreateExtn.MaskLayerHeaderClass('111','TT','002');
       List<DRTCreateExtn.MaskLayerHeaderClass> mlhList=new List<DRTCreateExtn.MaskLayerHeaderClass>();
       mlhList.add(mlh1);
       
       String serializeMLH=Json.serialize(mlhList);
       objDRTCreateExtn.maskLayerHeaderJSON = serializeMLH;
       
       DRTCreateExtn.MaskLayerContentClass mlc1=new DRTCreateExtn.MaskLayerContentClass('RM','RRC1');
        List<DRTCreateExtn.MaskLayerContentClass> mlcList=new List<DRTCreateExtn.MaskLayerContentClass>();
        mlcList.add(mlc1);
        
        List<List<DRTCreateExtn.MaskLayerContentClass>> lstMaskLayerContentData= new List<List<DRTCreateExtn.MaskLayerContentClass>>();
        lstMaskLayerContentData.add(mlcList);
        
        String serializeMLC=Json.serialize(lstMaskLayerContentData);
        objDRTCreateExtn.maskLayerContentJSON = serializeMLC;
        objDRTCreateExtn.baseMST=mstList[0].Id;
        objDRTCreateExtn.baseMSTName=mstList[0].name;
        objDRTCreateExtn.selectedDrtType='FRAME';
        objDRTCreateExtn.saveAsActivate(); 
        objDRTCreateExtn.refreshPage();
        test.stopTest();
  }
}