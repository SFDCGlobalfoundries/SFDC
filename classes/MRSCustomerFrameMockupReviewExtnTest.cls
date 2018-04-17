/*
Type Name: MRSCustomerFrameMockupReviewExtnTest
Author: Cognizant 
Created Date: 22-May-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/
@istest(SeeAllData=false)
public class MRSCustomerFrameMockupReviewExtnTest{
    public static Account acc;
    public static  void TestFrameMockupAccountInsert(){
                SwiftDataUtilityTest.customSystemData();
                acc = SwiftDataUtilityTest.createTestAccountForDRT();
                //System.assertNotEquals(acc,null);
                acc.stage__c = 'Qualified';
                update acc;
                
    }
    static{
        TestFrameMockupAccountInsert();
    }
    
/**
 @ method: TestFrameMockupDataRetreivalExtn
 @ param: null
 @ return: void
 @ description: This method will check CustomerFrameMockupReview
**/
    public static testMethod void GetFilterData(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c ='0.001');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c =maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Customer');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie mst = new Cookie('mst',objMST.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{mst});
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.renderedApproveData=true;
            msrCustomerFrameMockupReviewExtnObj.approveTableFlag = true;
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.customerOrFoundary, true);
            msrCustomerFrameMockupReviewExtnObj.getMST();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstmst, null);
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.getMaskLayer();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstMaskLayer, null);
            msrCustomerFrameMockupReviewExtnObj.getLayerStatus();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstLayerStatus,null);
            msrCustomerFrameMockupReviewExtnObj.getDeviceId();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstDeviceId,null);
            msrCustomerFrameMockupReviewExtnObj.getFrameStatus();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstFrameStatus,null); 
            msrCustomerFrameMockupReviewExtnObj.getMRSLayerChipSummary();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper,null);
        Test.stopTest();
            /** Test Eneded **/
        }
    }
    /**
     @ method: CustomerApprovalFunction
     @ param: null
     @ return: void
     @ description: This method will approve the Frame Mockup Approval
    **/
    public static testMethod void CustomerApprovalFunction(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c ='0.001');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c = maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Customer');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.customerOrFoundary = true;
            msrCustomerFrameMockupReviewExtnObj.getMRSLayerChipSummary();
            msrCustomerFrameMockupReviewExtnObj.approveOrDisapprove ='Approve';
            msrCustomerFrameMockupReviewExtnObj.checkAllFrameStatus();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.disapproveReason,false);
            msrCustomerFrameMockupReviewExtnObj.getApproveButtonEnabled();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag,false);
            msrCustomerFrameMockupReviewExtnObj.getTblData();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.layerChipSummarTbl,true);
           
            for(MRSCustomerFrameMockupReviewExtn.frameTableWrapper frameTableObj : msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper){
                frameTableObj.checkedValue = true;
            }
            msrCustomerFrameMockupReviewExtnObj.saveTheData();
            List<MRS_Layer_Chip_Association__c> lstMLCA=[select Customer_Frame_Mockup__c from MRS_Layer_Chip_Association__c where Id in: mrsLayerChipAssolst];
            //System.assertEquals(lstMLCA.get(0).Customer_Frame_Mockup__c ,'Approve');
        Test.stopTest();
            /** Test Eneded **/
        }
    }
    /**
     @ method: FoundryApprovalFunction
     @ param: null
     @ return: void
     @ description: This method will approve the Foundry Frame Mockup Approve
    **/
     public static testMethod void FoundryApprovalFunction(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c= '0.02');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c =maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Foundry');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.customerOrFoundary = false;
            msrCustomerFrameMockupReviewExtnObj.getMST();
            /** System asserts**/
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag , false);
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.getMRSLayerChipSummary();
            msrCustomerFrameMockupReviewExtnObj.approveOrDisapprove ='Approve';
            msrCustomerFrameMockupReviewExtnObj.checkAllFrameStatus();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.disapproveReason,false);
            msrCustomerFrameMockupReviewExtnObj.getApproveButtonEnabled();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag,false);
            msrCustomerFrameMockupReviewExtnObj.getTblData();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.layerChipSummarTbl,true);
            for(MRSCustomerFrameMockupReviewExtn.frameTableWrapper frameTableObj : msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper){
                frameTableObj.checkedValue = true;
            }
            msrCustomerFrameMockupReviewExtnObj.saveTheData();
            List<MRS_Layer_Chip_Association__c> lstMLCA=[select Foundry_Frame_Mockup__c from MRS_Layer_Chip_Association__c where Id in: mrsLayerChipAssolst];
            //System.assertEquals(lstMLCA.get(0).Foundry_Frame_Mockup__c ,'Approve');
            
        Test.stopTest();
            /** Test Eneded **/
        }
    }
     /**
     @ method: CustomerDisapprovalFunction
     @ param: null
     @ return: void
     @ description: This method will approve the disapprove frame mockup review
    **/
    public static testMethod void CustomerDisapprovalFunction(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c='0.02');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Customer');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.customerOrFoundary = true;
            msrCustomerFrameMockupReviewExtnObj.getMRSLayerChipSummary();
            msrCustomerFrameMockupReviewExtnObj.approveOrDisapprove ='Disapprove';
            msrCustomerFrameMockupReviewExtnObj.checkAllFrameStatus();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.disapproveReason,true);
            msrCustomerFrameMockupReviewExtnObj.getApproveButtonEnabled();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag,false);
            msrCustomerFrameMockupReviewExtnObj.getTblData();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.layerChipSummarTbl,true);
            
             msrCustomerFrameMockupReviewExtnObj.disApproveReasonTxt ='Disapprove';
            for(MRSCustomerFrameMockupReviewExtn.frameTableWrapper frameTableObj : msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper){
                frameTableObj.checkedValue = true;
            }
            msrCustomerFrameMockupReviewExtnObj.saveTheData();
            List<MRS_Layer_Chip_Association__c> lstMLCA=[select Customer_Frame_Mockup__c from MRS_Layer_Chip_Association__c where Id in: mrsLayerChipAssolst];
            //System.assertEquals(lstMLCA.get(0).Customer_Frame_Mockup__c,'Disapprove');
        Test.stopTest();
            /** Test Eneded **/
        }
    }
    /**
     @ method: CustomerDisapprovalFunction
     @ param: null
     @ return: void
     @ description: This method will  disapprove foundry frame mockup review
    **/
     public static testMethod void FoundryDisapprovalFunction(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c= '0.02');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c =maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Foundry');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.customerOrFoundary = false;
             msrCustomerFrameMockupReviewExtnObj.getMRSLayerChipSummary();
            msrCustomerFrameMockupReviewExtnObj.approveOrDisapprove ='Disapprove';
            msrCustomerFrameMockupReviewExtnObj.checkAllFrameStatus();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.disapproveReason,true);
            msrCustomerFrameMockupReviewExtnObj.getApproveButtonEnabled();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag,false);
            msrCustomerFrameMockupReviewExtnObj.getTblData();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.layerChipSummarTbl,true);
           
            msrCustomerFrameMockupReviewExtnObj.disApproveReasonTxt ='Disapprove';
            for(MRSCustomerFrameMockupReviewExtn.frameTableWrapper frameTableObj : msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper){
                frameTableObj.checkedValue = true;
            }
            msrCustomerFrameMockupReviewExtnObj.checkDisapprove();
            msrCustomerFrameMockupReviewExtnObj.saveTheData();
            List<MRS_Layer_Chip_Association__c> lstMLCA=[select Foundry_Frame_Mockup__c from MRS_Layer_Chip_Association__c where Id in: mrsLayerChipAssolst];
            //System.assertEquals(lstMLCA.get(0).Foundry_Frame_Mockup__c,'Disapprove');
        Test.stopTest();
            /** Test Eneded **/
        }
    }
     /**
     @ method: CustomerFunctions
     @ param: null
     @ return: void
     @ description: This method will  approve Customer Function
    **/
     public static testMethod void CustomerFunctions(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Frame_Mockup__c=true,Status__c='Perform Tapeout Options',Tech_Geo_Value__c ='0.02');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0,15);
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c =maskSetTitleId);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL+'VFMRSFrameMockupReview'));
            System.currentPageReference().getParameters().put('type', 'Customer');
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);
         Test.startTest();
            MRSCustomerFrameMockupReviewExtn msrCustomerFrameMockupReviewExtnObj = new MRSCustomerFrameMockupReviewExtn(new apexpages.StandardController(new MRS__c()));
            
            msrCustomerFrameMockupReviewExtnObj.selectedmst =objMST.Id;
            msrCustomerFrameMockupReviewExtnObj.customerOrFoundary = true;
            msrCustomerFrameMockupReviewExtnObj.checkDisapprove();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.approveTableFlag,false);
            msrCustomerFrameMockupReviewExtnObj.checkAllFrameStatus();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.disapproveReason,true);
            msrCustomerFrameMockupReviewExtnObj.getApproveButtonEnabled();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.performReviewFlag,false);
            msrCustomerFrameMockupReviewExtnObj.getTblData();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.layerChipSummarTbl,true);
            msrCustomerFrameMockupReviewExtnObj.discardDataFrom();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.approveTableFlag,true);
            msrCustomerFrameMockupReviewExtnObj.checkApproveBuuton();
            //System.assertEquals(msrCustomerFrameMockupReviewExtnObj.approveTableFlag,false);
           
            msrCustomerFrameMockupReviewExtnObj.exportToCSV();
            msrCustomerFrameMockupReviewExtnObj.resetLSPCookies();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper,null);
            msrCustomerFrameMockupReviewExtnObj.exportToPDF();
            //System.assertNotEquals(msrCustomerFrameMockupReviewExtnObj.lstframeTableWrapper,null);
        Test.stopTest();
            /** Test Eneded **/
        }
    }
    /**
     @ method: createLayerChipData
     @ param: null
     @ return: void
     @ description: This method will create MRS_Layer_Chip_Association object to insert
    **/
       public static MRS_Layer_Chip_Association__c createLayerChipData(MRS_Layer_Chip_Association__c obj){
        obj.Foundry_Frame_Mockup__c= 'Ready';
        obj.Customer_Frame_Mockup__c= 'Ready';
        obj.Foundry_Frame_Mockup_Date__c=  Datetime.now();
        obj.Customer_Frame_Mockup_Date__c=  Datetime.now();
        return obj;
        
    }
}