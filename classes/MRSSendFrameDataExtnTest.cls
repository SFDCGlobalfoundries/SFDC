/*
Type Name: MRSSendFrameDataExtnTest
Author: Cognizant 
Created Date: 26-May-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/
@istest
public class MRSSendFrameDataExtnTest{
     public static Account acc;
     public static  void TestSendDataAccountInsert(){
            SwiftDataUtilityTest.customSystemData();
            acc = SwiftDataUtilityTest.createTestAccountForDRT();
            System.assertNotEquals(acc,null);
                acc.stage__c = 'Qualified';
                update acc;
                
     }
     static{
        TestSendDataAccountInsert();
     }
    public static testMethod void controllerConstructor(){
    User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){   
         Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Frame_Tapeout__c=true,Status__c='Perform Tapeout Options');
            insert objPTRF;
            
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
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;
            //------------------------------------------------------------------------------------------------------------
           
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = SwiftDataUtilityTest.getMRSLayerChipAsso(objPTRF.Id);  
       test.startTest();
          Test.setCurrentPage(Page.VFMRSSendFrameData);
          ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
          MRSSendFrameDataExtn objMRSSendFrameDataExtn = new MRSSendFrameDataExtn(new apexpages.StandardController(new MRS__c()));
          
         objMRSSendFrameDataExtn.getMaskSetTitle();
         System.assertEquals(objMRSSendFrameDataExtn.lstmst.size(),2);
         objMRSSendFrameDataExtn.selectedmst=objMST.Id;
         objMRSSendFrameDataExtn.selectedSendData='Ready';
         objMRSSendFrameDataExtn.selectedMaskLayer=objMRSLA1.name;
         objMRSSendFrameDataExtn.selectedLayerStatus=objMRSLA1.Layer_Status__c;
         objMRSSendFrameDataExtn.selectedDeviceId=objMRSLCA5.Device_Id__c;
         objMRSSendFrameDataExtn.selectedChipName=objMRSCD3.name;
         objMRSSendFrameDataExtn.selectedPTRFDRTNumber=objMRSLCA5.PTRF__c;
          
          objMRSSendFrameDataExtn.filterOnMst();
          System.assertEquals(objMRSSendFrameDataExtn.lstMaskLayer.size(),1);
          objMRSSendFrameDataExtn.showSearch() ;
          objMRSSendFrameDataExtn.initPagination();
          objMRSSendFrameDataExtn.populateDropdown();
          System.assertNotEquals(objMRSSendFrameDataExtn.mrslstLayerChip,null);
           objMRSSendFrameDataExtn.rowCount();
          objMRSSendFrameDataExtn.previous();
          objMRSSendFrameDataExtn.next();
          objMRSSendFrameDataExtn.retrieveRecord();
          objMRSSendFrameDataExtn.changePage();        
          objMRSSendFrameDataExtn.populateExcel();
          objMRSSendFrameDataExtn.exportToExcel();
          System.assertNotEquals(objMRSSendFrameDataExtn.mrslstLayerChip,null);
          
          objMRSSendFrameDataExtn.exportToCSV();
          System.assertNotEquals(objMRSSendFrameDataExtn.mrslstLayerChip,null);
          objMRSSendFrameDataExtn.clear();
          System.assertEquals(objMRSSendFrameDataExtn.selectedPTRFDRTNumber,'');
  
       test.stopTest(); 
     }
    }
     public static MRS_Layer_Chip_Association__c createLayerChipData(MRS_Layer_Chip_Association__c obj){
        obj.Send_Frame_Data__c= 'Not Done';      
        obj.Send_Frame_Data_Date__c=  Datetime.now();
        return obj;
    }
 }