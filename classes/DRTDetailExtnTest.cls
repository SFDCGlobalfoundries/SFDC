/*
    Author: Cognizant
    Description: Apex test class for DRTDetailExtn class
    History: 
    Cognizant      05/05/2014    - Apex code created
*/
@istest(SeeAllData=false)
public class DRTDetailExtnTest{
    
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
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
  */    
    public static testMethod void controllerConstructor(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList2(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt = drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdcls=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnology();
        
        test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id, opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        system.assertEquals(testController.isBreadcrumbActive, true);
        system.assertEquals(testController.fromPage, 'testURL');
       
        drt.Type__c='frame';
        update drt;
        
        DRTDetailExtn testController2 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        test.stopTest();
    }
    
    /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    fetchDRTDetails()
  */
    @isTest
    public static void fetchDRTDetailsTest(){
        
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        test.startTest();
        
        DRTDetailExtn  testController1 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        system.assertEquals(testController1.savedStatus,'Draft');
        
        drt.Status__c = 'Inactive';
        update drt;
        
        //assert start
        DRT__c selectedDrt = [select id,Status__c from DRT__c where id = :drt.Id];
        system.assertEquals(selectedDrt.Status__c,'Inactive');//current status
        system.assertNotEquals(selectedDrt.Status__c, 'Draft');//previous status
        //assert end
        
        DRTDetailExtn  testController2 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        drt.Status__c = 'Cancel';
        update drt;
        
        //assert start
        selectedDrt = [select id,Status__c from DRT__c where id = :drt.Id];
        system.assertEquals(selectedDrt.Status__c,'Cancel');//current status
        system.assertNotEquals(selectedDrt.Status__c, 'Inactive');//previous status
        //assert end
        
        DRTDetailExtn  testController3 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        drt.Status__c = 'Deleted';
        update drt;
        
        //assert start
        selectedDrt = [select id,Status__c from DRT__c where id = :drt.Id];
        system.assertEquals(selectedDrt.Status__c,'Deleted');//current status
        system.assertNotEquals(selectedDrt.Status__c, 'Cancel');//previous status
        //assert end
        
        DRTDetailExtn  testController4 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        drt.Status__c = 'Closed';
        update drt;
        
        //assert start
        selectedDrt = [select id,Status__c from DRT__c where id = :drt.Id];
        system.assertEquals(selectedDrt.Status__c,'Closed');//current status
        system.assertNotEquals(selectedDrt.Status__c, 'Deleted');//previous status
        //assert end
        
        DRTDetailExtn  testController5 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        test.stopTest();
    }
    
   /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    redirectToRevise()
  */
    
    @isTest
    public static void redirectToReviseTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
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
        
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        PageReference p = testController.redirectToRevise();
        system.assert(p == null);
        
        /*ptrf.Status__c='Cancel';
        update ptrf;
        
        PageReference p1 = testController.redirectToRevise();
        system.assertEquals('/apex/VFDRTRevise?id='+drt.Id+'&urlFromPage=testURL',p1.getUrl());
        
        testController.isBreadcrumbActive=false;
        PageReference p2 = testController.redirectToRevise();
        system.assertEquals('/apex/VFDRTRevise?id='+drt.Id+'&urlFromPage=testURL',p2.getUrl());
        
        drt.Status__c = 'Deleted';
        update drt;
        
        DRTDetailExtn  testController2 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p3 = testController2.redirectToRevise();
        system.assertEquals('/apex/VFDRTRevise?id='+drt.Id+'&urlFromPage=testURL',p3.getUrl());*/
        
        test.stopTest();
    }
    
    
    @isTest
    public static void redirectToReviseTest2(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
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
        
        //PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        PTRF__c ptrf = new PTRF__c();
        ptrf.Name = 'PTRF1';
        ptrf.Device__c = testDevice.id;
        ptrf.Device_Id__c = testDevice.id;
        //p.Transaction_Type__c = 'LIFECYCLE';
        ptrf.Transaction_Date__c = date.today();
        ptrf.Order_Type__c = 'TEST';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Mask_Set_Title__c = mstList[0].id;
        ptrf.MaskSetTitle__c=mstList[0].id;
        ptrf.Status__c='Cancel';
        ptrf.Prime_DRT__c = 'Prime';
        ptrf.Frame_DRT__c = 'Frame';
        ptrf.Recticle_Type__c='Multi Node Reticle (MNR)';
        insert ptrf;
        
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        PageReference p1 = testController.redirectToRevise();
        system.assertEquals('/apex/VFDRTRevise?id='+drt.Id+'&urlFromPage=testURL',p1.getUrl());
        
        testController.isBreadcrumbActive=false;
        PageReference p2 = testController.redirectToRevise();
        system.assertEquals('/apex/VFDRTRevise?id='+drt.Id+'&urlFromPage=testURL',p2.getUrl());
        
        test.stopTest();
    }
    
    @isTest
    public static void redirectToReviseTest3(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        //List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        //DRT__c drt=drtList[0];
        
        DRT__c drt = new DRT__C(Name='MYMST_PRIME_DRT_001.001', Customer_Name__c=acc.id,
                              Status__c='Deleted',
                              Type__c='PRIME',
                              Tech_Geo__c = '0.02UM',
                              Mask_Set_Title__c = mstList[0].Id);
        insert drt;                      
        
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
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTDetailExtn  testController2 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p3 = testController2.redirectToRevise();
        
        test.stopTest();
    }
    /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    redirectToUpdate()
  */
    
    @isTest
    public static void redirectToUpdateTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        test.startTest();
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p = testController.redirectToUpdate();
        system.assertEquals('/apex/VFDRTUpdate?id='+drt.Id+'&urlFromPage=testURL',p.getUrl());
        
        test.stopTest();
    }
    
    /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    redirectToCancel()
  */
    
    @isTest
    public static void redirectToCancelTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        test.startTest();
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p1 = testController.redirectToCancel();
        system.assertEquals('/apex/VFDRTDetail?id='+drt.Id+'&urlFromPage=testURL',p1.getUrl());
        
        //the Id of the DRT is set to null, so an exception will be thrown
        drt.id=null;
        PageReference p2 = testController.redirectToCancel();
        system.assertEquals(p2,null);
        
        test.stopTest();
    }
    
     /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    redirectToCopy()
  */
    
    @isTest
    public static void redirectToCopyTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
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
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, oppr.Id,opprProg.Id,pt.Id);
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        Chip_Detail__c chip_Detail=SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        List<Frame_DRT_Association__c> fdaList=SwiftDataUtilityTest.createFDA2(drt,mstList[0]);
        Mask_Layer__c maskLayer=SwiftDataUtilityTest.createMaskLayerDRT(ptrf);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        DRTDetailExtn testController = new DRTDetailExtn(new ApexPages.StandardController(drt));
        
        PageReference p = testController.redirectToCopy();
        system.assert(p == null);
       
        drt.Status__c = 'Active';
        drt.Type__c='FRAME';
        update drt;
        
        DRTDetailExtn  testController3 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p2 = testController3.redirectToCopy();
        system.assert(p2.getUrl().contains('/apex/VFDRTDetail?id='));
        test.stopTest();
    }
    
   /*
   This test method tests the below functionality of the class DRTDetailExtn
    constructor 
    redirectToDelete()
  */
    
    @isTest
    public static void redirectToDeleteTest(){
        ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
        ApexPages.currentPage().getParameters().put('urlFromPage','testURL');
        
        //load the custom settings
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        ApexPages.currentPage().getParameters().put('id',drt.Id);
        
        test.startTest();
        
        DRTDetailExtn  testController2 = new DRTDetailExtn(new ApexPages.StandardController(drt));
        PageReference p = testController2.redirectToDelete();
        system.assertEquals('/apex/VFDRTDetail?id='+drt.Id+'&urlFromPage=testURL',p.getUrl());
        
        test.stopTest();
    }
    
    /*
   This test method tests the below functionality of the Trigger PTRF_SWIFT_AUPD_Trigger
    PTRF creation
  */
     @isTest
    public static void PTRF_SWIFT_AUPD_TriggerTest(){
        // comment-out, refactor with testSetup method setup()
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
        PTRF__c ptrf=SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        
        ptrf.Status__c='Perform Tapeout Options';
        update ptrf;
        system.assertEquals(ptrf.Status__c,'Perform Tapeout Options');
        
        ptrf.Status__c='Cancel';
        update ptrf;
        system.assertEquals(ptrf.Status__c,'Cancel');        
        
        ptrf.Prime_TapeOut__c=false;
        ptrf.Frame_Tapeout__c=true;
        update ptrf;
        system.assertEquals(ptrf.Prime_TapeOut__c,false);
        system.assertEquals(ptrf.Frame_Tapeout__c,true);
        
        ptrf.DRC_DRW_Status__c='Cancelled DRC DRW';
        update ptrf;
        system.assertEquals(ptrf.DRC_DRW_Status__c,'Cancelled DRC DRW');
        
        test.stopTest();
        
    }
    
     /*
   This test method tests the below functionality of the Trigger PRIME_DRT_Chip_Layer_Summary_SWIFT_AUPD_trigger
    Checks whether a PRIME_DRT_Chip_Layer_Summary__c record has been synced with external System
  */
    
    @isTest
    public static void PRIME_DRT_Chip_Layer_Summary_SWIFT_AUPD_triggerTest(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList1(1,mstList[0],acc.Id);
        
        DRT__c drt=drtList[0];
        
        List<PRIME_DRT_Layer_Association__c> pdlaList=SwiftDataUtilityTest.createPDLA(drt.Id);
        
        List<PRIME_DRT_Chip_Association__c> pdcaList=SwiftDataUtilityTest.createPDCA(drt.Id,mstList[0].Id);
        
        List<PRIME_DRT_Chip_Layer_Summary__c> pdclsList=SwiftDataUtilityTest.createPDCLS(pdlaList,pdcaList);
        
        PRIME_DRT_Chip_Layer_Summary__c pdcls = pdclsList[0];
        pdcls.Synced_with_Oracle_DB__c=true;
        
        update pdcls;
        
        test.startTest();
        
        update pdcls;
        
        system.assertEquals(pdcls.Synced_with_Oracle_DB__c, true);
        
        test.stopTest();
    }
    
   /*
   This test method tests the below functionality of the Trigger DRT_PTRF_Association_SWIFT_AUPD_trigger
    Checks association between DRT and PTRF object records 
  */
    
    @isTest
    public static void DRT_PTRF_Association_SWIFT_AUPD_triggerTest(){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
        
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(2,mstList[0]);
        
        DRT__c drt=drtList[0];
        
        drt.Customer_Name__c=acc.Id;
        drt.Name='MYMST_PRIME_DRT1_035.001';
        
        update drt;
        
        DRT__c drt2=drtList[1];
        
        drt2.Customer_Name__c=acc.Id;
        drt2.Name='MYMST_PRIME_DRT2_035.001';
        
        update drt2;
        
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
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);
        
        ptrf.Status__c='Perform Tapeout Options';
        update ptrf;
        system.assertEquals(ptrf.Status__c,'Perform Tapeout Options');
        
        dpa.DRT__c=drt2.Id;
        update dpa;
        
        drt.Type__c='frame';
        update drt;
        system.assertEquals(drt.Type__c,'frame');
        
        dpa.DRT__c=drt.Id;
        update dpa;
        
        test.stopTest();
        
    }
}