@istest(SeeAllData=false)
public class MRSCustomerGDSOUTReviewExtnTest{
    public static Account acc;
    /**
        @Method Name: TestFrameMockupAccountInsert
        @Return type: null
        @Parameters: null
        @Description: Inserts Account for test class.
    **/
      public static  void TestFrameMockupAccountInsert(){
                SwiftDataUtilityTest.customSystemData();
                acc = SwiftDataUtilityTest.createTestAccountForDRT();
                System.assertNotEquals(acc,null);
                    acc.stage__c = 'Qualified';
                    update acc;
                    
      }
      static{
        TestFrameMockupAccountInsert();
      }
      /**
        @Method Name: controllerConstructor
        @Return type: null
        @Parameters: null
        @Description: Test Method for controllers contructor
    **/
    public static testMethod void controllerConstructor(){ 
            User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
             
            
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options');
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
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='PD1');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            /** Test started  **/
       Test.startTest();
           Test.setCurrentPage(Page.VFMRSGDSOUTReview);
           ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
           ApexPages.currentPage().getParameters().put('type','Customer');
           Cookie account = new Cookie('account', acc.Id, null, -1, false);
           ApexPages.currentPage().setCookies(new Cookie[]{account});
           Cookie mst = new Cookie('mst', objMST.Id, null, -1, false);
           ApexPages.currentPage().setCookies(new Cookie[]{mst});
       
           MRSCustomerGDSOUTReviewExtn objMRSCustomerGDSOUTReviewExtn = new MRSCustomerGDSOUTReviewExtn(new apexpages.StandardController(new MRS__c()));
          /*----------------Wrapper Chip----------*/
           MRSCustomerGDSOUTReviewExtn.WrapperChip wrpChip = new MRSCustomerGDSOUTReviewExtn.WrapperChip('PD1'); 
           List<MRSCustomerGDSOUTReviewExtn.WrapperChip> lstMainTableData = new List<MRSCustomerGDSOUTReviewExtn.WrapperChip>();
           lstMainTableData.add(wrpChip);
           String MainTable=JSON.serialize(lstMainTableData);
           objMRSCustomerGDSOUTReviewExtn.mainTableJSON=MainTable;
         /*-------------------WrapperLayerPtrf -------------------*/
           MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf('1','RXAZ(123)','PTRF1','0.019UM'); 
          List<MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf>();
          lstsideHeader.add(wrpLayerPtrf);       
          String sideHeader=JSON.serialize(lstsideHeader);
          objMRSCustomerGDSOUTReviewExtn.sideHeaderJSON=sideHeader;
          /*--------------WrapperStatusCheck----------------*/
           MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck wrpStsCheck = new MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck('CHECKED','READY'); 
          List<MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck>();
          lstgridTbl.add(wrpStsCheck );
          String gridTbl=JSON.serialize(lstgridTbl);
          objMRSCustomerGDSOUTReviewExtn.gridTblJSON=gridTbl;  
         /*------------------------------------------------*/
          objMRSCustomerGDSOUTReviewExtn.selectedCustomerId=acc.Id;
          objMRSCustomerGDSOUTReviewExtn.selectedMSTId=objMST.Id;
          objMRSCustomerGDSOUTReviewExtn.isTableActive=true;
          objMRSCustomerGDSOUTReviewExtn.isPerformActive=true;
         
          objMRSCustomerGDSOUTReviewExtn.fetchMRSLayerChipAssociationDetails();
          System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.mrsLayerChipList, null);
          objMRSCustomerGDSOUTReviewExtn.displayTable();
          System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.layerPtrfCheckbox, null); 
          objMRSCustomerGDSOUTReviewExtn.approvalData();
          System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.lstMainTableData, null); 
          objMRSCustomerGDSOUTReviewExtn.saveData();
          objMRSCustomerGDSOUTReviewExtn.fetchAfterApply();
          List<MRS_Layer_Chip_Association__c> lstMLCA=[select Customer_GDSOUT_Review__c from MRS_Layer_Chip_Association__c where id in : mrsLayerChipAssolst ];
          System.assertEquals(lstMLCA.get(0).Customer_GDSOUT_Review__c,'Approve');
          
       test.stopTest(); 
     }
    }
    
    /**
        @Method Name: FoundryGDSOutReviewTest
        @Return type: null
        @Parameters: null
        @Description: Method for FoundryGDSOutReviewTest
    **/
   @istest
    public static void FoundryGDSOutReviewTest(){ 
           User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
       System.runAs(sysAdminUser){   
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=sysAdminUser.Id);
            listPTRFJVI.add(objPTRFJVC);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='In Progress',Name='EX',Mask_Layer_Rev__c='AZ');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='PD1');
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='PD2');
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            /** Test started  **/
    Test.startTest();
         Test.setCurrentPage(Page.VFMRSGDSOUTReview);
         ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
         ApexPages.currentPage().getParameters().put('type','Foundry');
         Cookie account = new Cookie('account', acc.Id, null, -1, false);
         ApexPages.currentPage().setCookies(new Cookie[]{account});
         Cookie mst = new Cookie('mst', objMST .Id, null, -1, false);
         ApexPages.currentPage().setCookies(new Cookie[]{mst});
         MRSCustomerGDSOUTReviewExtn objMRSCustomerGDSOUTReviewExtn = new MRSCustomerGDSOUTReviewExtn(new apexpages.StandardController(new MRS__c()));
        //----------------Wrapper Chip----------
          MRSCustomerGDSOUTReviewExtn.WrapperChip wrpChip = new MRSCustomerGDSOUTReviewExtn.WrapperChip('PD1'); 
         List<MRSCustomerGDSOUTReviewExtn.WrapperChip> lstMainTableData = new List<MRSCustomerGDSOUTReviewExtn.WrapperChip>();
         lstMainTableData.add(wrpChip);
         String MainTable=JSON.serialize(lstMainTableData);
         objMRSCustomerGDSOUTReviewExtn.mainTableJSON=MainTable;
        //-------------------WrapperLayerPtrf -------------------
          MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf('1','RXAZ(123)','PTRF1','0.019UM'); 
         List<MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSCustomerGDSOUTReviewExtn.WrapperLayerPtrf>();
         lstsideHeader.add(wrpLayerPtrf);
         String sideHeader=JSON.serialize(lstsideHeader);
         objMRSCustomerGDSOUTReviewExtn.sideHeaderJSON=sideHeader;
         //--------------WrapperStatusCheck----------------
          MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck wrpStsCheck = new MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck('CHECKED','READY'); 
         List<MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSCustomerGDSOUTReviewExtn.WrapperStatusCheck>();
         lstgridTbl.add(wrpStsCheck );
         String gridTbl=JSON.serialize(lstgridTbl);
         objMRSCustomerGDSOUTReviewExtn.gridTblJSON=gridTbl;
        //------------------------------------------------
         objMRSCustomerGDSOUTReviewExtn.selectedCustomerId=acc.Id;
         objMRSCustomerGDSOUTReviewExtn.selectedMSTId=objMST .Id;
        
         objMRSCustomerGDSOUTReviewExtn.fetchMRSLayerChipAssociationDetails();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.mrsLayerChipList, null);
         objMRSCustomerGDSOUTReviewExtn.displayTable();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.layerPtrfCheckbox, null); 
         objMRSCustomerGDSOUTReviewExtn.approvalData();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.lstMainTableData, null); 
         objMRSCustomerGDSOUTReviewExtn.saveData();
         List<MRS_Layer_Chip_Association__c> lstMLCA=[select Foundry_GDSOUT_Review__c from MRS_Layer_Chip_Association__c where id in:mrsLayerChipAssolst ];
         System.assertEquals(lstMLCA.get(0).Foundry_GDSOUT_Review__c,'Approve'); 
         objMRSCustomerGDSOUTReviewExtn.discardSelection();
         System.assertEquals(objMRSCustomerGDSOUTReviewExtn.isSelectionTableTrue, true); 
         objMRSCustomerGDSOUTReviewExtn.performReview();
         System.assertEquals(objMRSCustomerGDSOUTReviewExtn.labelorDropdown, false); 
         objMRSCustomerGDSOUTReviewExtn.isTableActive=true; 
         
         PageReference p1 =  objMRSCustomerGDSOUTReviewExtn.exportToExcel();
         system.assertEquals(p1.getUrl(),'/apex/vfmrsgdsoutreviewtoexcel?type=Foundry');
         
         PageReference p2 =  objMRSCustomerGDSOUTReviewExtn.exportToCSV();
         system.assertEquals(p2.getUrl(),'/apex/vfmrsgdsoutreviewtocsv');  
         
          PageReference p3 =  objMRSCustomerGDSOUTReviewExtn.exportToPDF();
         system.assertEquals(p3.getUrl(),'/apex/vfmrsgdsoutreviewtopdf');  
       test.stopTest(); 
     }
    }
    
     /**
        @Method Name: getFilterData
        @Return type: null
        @Parameters: null
        @Description: Method for getFilterData
    **/
    @istest
    public static void getFilterData(){
          User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
       System.runAs(sysAdminUser){   
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options');
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
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='PD1');
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
            PTRF_JobViewer_Info__c ptrfJobViewInfo = SwiftDataUtilityTest.getPTRFJobViewInfo(objPTRF.Id,sysAdminUser.Id);
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
            //-------------------------------------------------------------------------------------------------------------
            /** Test started  **/
    Test.startTest();
         Test.setCurrentPage(Page.VFMRSGDSOUTReview);
         ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
         ApexPages.currentPage().getParameters().put('type','Foundry');
         Cookie account = new Cookie('account', acc.Id, null, -1, false);
         ApexPages.currentPage().setCookies(new Cookie[]{account});
         Cookie mst = new Cookie('mst', objMST.Id, null, -1, false);
         ApexPages.currentPage().setCookies(new Cookie[]{mst});
         MRSCustomerGDSOUTReviewExtn objMRSCustomerGDSOUTReviewExtn = new MRSCustomerGDSOUTReviewExtn(new apexpages.StandardController(new MRS__c()));
            
         objMRSCustomerGDSOUTReviewExtn.selectedCustomerId=acc.Id;
         objMRSCustomerGDSOUTReviewExtn.selectedMSTId=objMST.Id;
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForCustomer();
         //System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.customerListTodisplay, null); 
         objMRSCustomerGDSOUTReviewExtn.selectedCustomerId=acc.Id;
         objMRSCustomerGDSOUTReviewExtn.selectedMSTId=objMST.Id;
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForMaskSetTitle();
         //System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.maskSetTitleToDisplay, null); 
         objMRSCustomerGDSOUTReviewExtn.resetLSPCookies();
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForMaskLayer();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.maskLayerList, null); 
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForStatus();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.layerStatusList, null); 
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForChipName();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.chipNameList, null); 
         objMRSCustomerGDSOUTReviewExtn.fetchMRSForPtrf();
         System.assertNotEquals(objMRSCustomerGDSOUTReviewExtn.deviceIdList, null); 
 
       test.stopTest(); 
     }
    }
    /**
        @Method Name: createLayerChipData
        @Return type: MRS_Layer_Chip_Association__c
        @Parameters: MRS_Layer_Chip_Association__c obj
        @Description: Method creates MRS_Layer_Chip_Association data
    **/
    public static MRS_Layer_Chip_Association__c createLayerChipData(MRS_Layer_Chip_Association__c obj){
        obj.Foundry_GDSOUT_Review__c= 'Approve';
        obj.Customer_GDSOUT_Review__c= 'Approve';
        obj.Foundry_GDSOUT_Review_Date__c=  Datetime.now();
        obj.Customer_GDSOUT_Review_Date__c=  Datetime.now();
        obj.PTRF_Or_DRT__c='PTRF';
        return obj;
    }
   }