/*
Author: Meenakshmi Goswami
Company: Cognizant Technology Solutions
Description: This is a test class written for the class PTRFDetailExtn
History: 
<Initials>     ddmmyyyy     - <Brief description of change>
*/

@istest(SeeAllData=false)
public class PTRFDetailExtnTest
{
/* public static List<MRS_Layer_Association__c> layerSummary;
public static Account  objAccount;
public static Mask_Set_Title__c  objMST;
public static PTRF__c objPTRF;
public static PTRF__c objPTRF2;
public static PTRF__c objPTRF4;
public static PTRF__c objPTRF5; 
    
public static Mask_Layer__c objLayer;
public static Mask_Layer__c objLayer2;
public static User sysAdminUser ;
public static User userSU  ;
public static User IntegrationUser ;
public static MRS_Layer_Chip_Association__c  MRSLCAObj3 ;
public static DRT__c objDRT; */
/**************************************************************/

/* public static MRS_Chip_Details__c MRSChipDetailsMRSLayer;
public static MRS__c MRSObjectMRSLayer;
public static Account objAccountMRSLayer;
public static Account objAccountMRSLayer2;
public static Mask_Set_Title__c objMSTMRSLayer;
public static ID IDOpportunityMRSLayer;
public static ID IDOpportunityMRSLayerProgram;
public static Process_Technology__c objProcessTechnologyMRSLayer;
public static Device__c objDeviceMRSLayer;
public static List<PTRF__c> listPTRFMRSLayer;
public static PTRF__c objPTRFMRSLayer;
public static PTRF__c objPTRFMRSLayer2;
public static Mask_Layer__c objLayerMRSLayer;
public static Mask_Layer__c objLayerMRSLayer2;
public static Chip_Detail__c objChipMRSLayer1;
public static Chip_Detail__c objChipMRSLayer11;
public static Chip_Detail__c objChipMRSLayer2;
public static Chip_Detail__c objChipMRSLayer21;
public static Chip_Detail__c objChipMRSLayer3;
public static Chip_Detail__c objChipMRSLayer31;
public static MRS_Layer_Summary_Refresh_Interval__c refreshIntervalMRSLayer;
public static environment_Variable__c envMRSLayer;
public static MRS_Layer_Association__c MRSLAObjMRSLayer1;
public static MRS_Layer_Association__c MRSLAObjMRSLayer2;
public static MRS_Layer_Chip_Association__c MRSLCAObjMRSLayer1;
public static MRS_Layer_Chip_Association__c MRSLCAObjMRSLayer2;
public static User sysAdminUserMRSLayer;{sysAdminUserMRSLayer = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);}
public static User userSAMRSLayer;
public static User userSUMRSLayer;
public static User userSUMRSLayerGShuttleMRSLayer;
public static User userSUMRSLayerFEMRSLayer; */

/**
    This method is for creating test data : account
    @method name: TestAccountInsertMRSLayer
    @parameter:   None
    @return :     None
**/       
    public static void TestAccountInsertMRSLayer(){
            SwiftDataUtilityTest.customSystemData();
            User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
            System.runAs(thisUser) {
                Account objAccountMRSLayer = SwiftDataUtilityTest.createTestAccountForDRT();
                Account objAccount = objAccountMRSLayer ;
                System.assertNotEquals(objAccountMRSLayer,null);
                    objAccountMRSLayer.stage__c = 'Qualified';
                    update objAccountMRSLayer;
                //createStandardFEUserMRSLayer(objAccountMRSLayer);
            }
                
    }


/**
    This is the wrapper method is for creating test data
    @method name: CreateDataMRSLayer
    @parameter:   None
    @return :     None
**/ 
    public static void CreateDataMRSLayer(){
                 createPermissionConfigValuesMRSLayer();
                 Account objAccountMRSLayer = [Select Id, Name from Account where Name='Test Account 009'];
                 Customer_Layer_Summary_Permission__c CLSP = createCustomerPermissionMRSLayer(objAccountMRSLayer);
                 System.assertNotEquals(CLSP.Id,null);
                 
                 Mask_Set_Title__c objMSTMRSLayer=createMSTMRSLayer('MPW1001');             
                 System.assertNotEquals(objMSTMRSLayer.Id,null);

                 List<PTRF__c> listPTRFMRSLayer = new List<PTRF__c>();
                 
                 PTRF__c objPTRFMRSLayer= createPTRFMRSLayer('PTRF 000 1001',objMSTMRSLayer,'Device1'); 
                 System.assertNotEquals(objPTRFMRSLayer.Id,null);
                  
                 PTRF__c objPTRFMRSLayer2= createPTRFMRSLayer('PTRF 000 1002',objMSTMRSLayer,'Device1');           
                 System.assertNotEquals(objPTRFMRSLayer2.Id,null);
                 
                 Mask_Layer__c objLayerMRSLayer= createMaskLayerMRSLayer(objPTRFMRSLayer,objMSTMRSLayer,'MLN001','AZ','01'); 
                 System.assertNotEquals(objLayerMRSLayer.Id,null);
                             
                 Mask_Layer__c objLayerMRSLayer2= createMaskLayerMRSLayer(objPTRFMRSLayer2,objMSTMRSLayer,'MLN002','BZ','02');
                 System.assertNotEquals(objLayerMRSLayer2.Id,null);
                 
                 MRS__c MRSObjectMRSLayer = createMRSMRSLayer(objPTRFMRSLayer,objMSTMRSLayer);
                 System.assertNotEquals(MRSObjectMRSLayer.Id,null);
                 
                 MRS_Chip_Details__c MRSChipDetailsMRSLayer = createMRSChipDetailMRSLayer(String.valueOf(objMSTMRSLayer.Name),String.valueOf(MRSObjectMRSLayer.Id));
                 System.assertNotEquals(MRSChipDetailsMRSLayer.Id,null);
                                  
                 MRS_Layer_Association__c MRSLAObjMRSLayer1 = createMRSDataMRSLayer(String.valueOf(objLayerMRSLayer.Name), String.valueOf(objLayerMRSLayer.Mask_Layer_Rev__c), String.valueOf(objMSTMRSLayer.Name), String.valueOf(MRSObjectMRSLayer.Id));
                 System.assertNotEquals(MRSLAObjMRSLayer1.Id,null);
                 
                 MRS_Layer_Association__c MRSLAObjMRSLayer2 = createMRSDataMRSLayer(String.valueOf(objLayerMRSLayer2.Name), String.valueOf(objLayerMRSLayer2.Mask_Layer_Rev__c), String.valueOf(objMSTMRSLayer.Name), String.valueOf(MRSObjectMRSLayer.Id));
                 System.assertNotEquals(MRSLAObjMRSLayer2.Id,null);
                                  
                 MRS_Layer_Summary_Refresh_Interval__c refreshIntervalMRSLayer= new MRS_Layer_Summary_Refresh_Interval__c();
                 refreshIntervalMRSLayer.Page_Refresh_Frequency__c = 50;
                 refreshIntervalMRSLayer.Name ='LayerSummaryInterval'; 
                 insert refreshIntervalMRSLayer; 
    
     }
     

/**
    This method creates test data : MRS Permission Config (Custom Settings)
    @method name: createPermissionConfigValuesMRSLayer
    @parameter:   None
    @return :     None
**/  
  
    private static void createPermissionConfigValuesMRSLayer(){
     List<MRS_Fields_Permission_Config__c> TotalPermissionConfig = new List<MRS_Fields_Permission_Config__c>();
     MRS_Fields_Permission_Config__c GlobalShuttle = new MRS_Fields_Permission_Config__c();
     GlobalShuttle.Name = 'SWIFT_GlobalShuttle';
     GlobalShuttle.CustomerRemoteJobviewFrame__c = true;
     GlobalShuttle.CustomerRemoteJobviewPrime__c = true;
     GlobalShuttle.DRW__c = true;
     GlobalShuttle.FoundryRemoteJobviewFrame__c = true;
     GlobalShuttle.FoundryRemoteJobviewPrime__c = true;
     GlobalShuttle.FrameMockupCustomer__c = true;
     GlobalShuttle.FrameMockupFoundry__c = true;
     GlobalShuttle.GDSOUTReviewCustomer__c = true;
     GlobalShuttle.GDSOUTReviewFoundry__c = true;
     GlobalShuttle.MEBESJobviewCustomer__c = true;
     GlobalShuttle.MEBESJobviewFoundry__c = true;
     GlobalShuttle.MEBESJobviewGlobalShuttle__c = true;
     GlobalShuttle.MEBESJobviewMDP__c = true;
     GlobalShuttle.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     GlobalShuttle.MEBESJobviewTapeoutCenter__c = true;
     GlobalShuttle.MEBESJobviewTDTIMPW__c = true;
     GlobalShuttle.MEBESReceivedFrame__c = true;
     GlobalShuttle.MEBESReceivedPrime__c = true;
     GlobalShuttle.ORC__c = true;
     GlobalShuttle.SendDataFrame__c = true;
     GlobalShuttle.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(GlobalShuttle);
     
     MRS_Fields_Permission_Config__c MDP = new MRS_Fields_Permission_Config__c();
     MDP.Name = 'SWIFT_MDP';
     MDP.CustomerRemoteJobviewFrame__c = true;
     MDP.CustomerRemoteJobviewPrime__c = true;
     MDP.DRW__c = true;
     MDP.FoundryRemoteJobviewFrame__c = true;
     MDP.FoundryRemoteJobviewPrime__c = true;
     MDP.FrameMockupCustomer__c = true;
     MDP.FrameMockupFoundry__c = true;
     MDP.GDSOUTReviewCustomer__c = true;
     MDP.GDSOUTReviewFoundry__c = true;
     MDP.MEBESJobviewCustomer__c = true;
     MDP.MEBESJobviewFoundry__c = true;
     MDP.MEBESJobviewGlobalShuttle__c = true;
     MDP.MEBESJobviewMDP__c = true;
     MDP.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     MDP.MEBESJobviewTapeoutCenter__c = true;
     MDP.MEBESJobviewTDTIMPW__c = true;
     MDP.MEBESReceivedFrame__c = true;
     MDP.MEBESReceivedPrime__c = true;
     MDP.ORC__c = true;
     MDP.SendDataFrame__c = true;
     MDP.SendDataPrime__c = true;
          
     TotalPermissionConfig.add(MDP);  

     MRS_Fields_Permission_Config__c Admin = new MRS_Fields_Permission_Config__c();
     Admin.Name = 'SWIFT_Admin';
     Admin.CustomerRemoteJobviewFrame__c = true;
     Admin.CustomerRemoteJobviewPrime__c = true;
     Admin.DRW__c = true;
     Admin.FoundryRemoteJobviewFrame__c = true;
     Admin.FoundryRemoteJobviewPrime__c = true;
     Admin.FrameMockupCustomer__c = true;
     Admin.FrameMockupFoundry__c = true;
     Admin.GDSOUTReviewCustomer__c = true;
     Admin.GDSOUTReviewFoundry__c = true;
     Admin.MEBESJobviewCustomer__c = true;
     Admin.MEBESJobviewFoundry__c = true;
     Admin.MEBESJobviewGlobalShuttle__c = true;
     Admin.MEBESJobviewMDP__c = true;
     Admin.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     Admin.MEBESJobviewTapeoutCenter__c = true;
     Admin.MEBESJobviewTDTIMPW__c = true;
     Admin.MEBESReceivedFrame__c = true;
     Admin.MEBESReceivedPrime__c = true;
     Admin.ORC__c = true;
     Admin.SendDataFrame__c = true;
     Admin.SendDataPrime__c = true;
          
     TotalPermissionConfig.add(Admin);

     MRS_Fields_Permission_Config__c RMG = new MRS_Fields_Permission_Config__c();
     RMG.Name = 'Swift_RMG';
     RMG.CustomerRemoteJobviewFrame__c = true;
     RMG.CustomerRemoteJobviewPrime__c = true;
     RMG.DRW__c = true;
     RMG.FoundryRemoteJobviewFrame__c = true;
     RMG.FoundryRemoteJobviewPrime__c = true;
     RMG.FrameMockupCustomer__c = true;
     RMG.FrameMockupFoundry__c = true;
     RMG.GDSOUTReviewCustomer__c = true;
     RMG.GDSOUTReviewFoundry__c = true;
     RMG.MEBESJobviewCustomer__c = true;
     RMG.MEBESJobviewFoundry__c = true;
     RMG.MEBESJobviewGlobalShuttle__c = true;
     RMG.MEBESJobviewMDP__c = true;
     RMG.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     RMG.MEBESJobviewTapeoutCenter__c = true;
     RMG.MEBESJobviewTDTIMPW__c = true;
     RMG.MEBESReceivedFrame__c = true;
     RMG.MEBESReceivedPrime__c = true;
     RMG.ORC__c = true;
     RMG.SendDataFrame__c = true;
     RMG.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(RMG);

     MRS_Fields_Permission_Config__c Support = new MRS_Fields_Permission_Config__c();
     Support.Name = 'SWIFT_Support';
     Support.CustomerRemoteJobviewFrame__c = true;
     Support.CustomerRemoteJobviewPrime__c = true;
     Support.DRW__c = true;
     Support.FoundryRemoteJobviewFrame__c = true;
     Support.FoundryRemoteJobviewPrime__c = true;
     Support.FrameMockupCustomer__c = true;
     Support.FrameMockupFoundry__c = true;
     Support.GDSOUTReviewCustomer__c = true;
     Support.GDSOUTReviewFoundry__c = true;
     Support.MEBESJobviewCustomer__c = true;
     Support.MEBESJobviewFoundry__c = true;
     Support.MEBESJobviewGlobalShuttle__c = true;
     Support.MEBESJobviewMDP__c = true;
     Support.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     Support.MEBESJobviewTapeoutCenter__c = true;
     Support.MEBESJobviewTDTIMPW__c = true;
     Support.MEBESReceivedFrame__c = true;
     Support.MEBESReceivedPrime__c = true;
     Support.ORC__c = true;
     Support.SendDataFrame__c = true;
     Support.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(Support);

     MRS_Fields_Permission_Config__c TapeoutApplication = new MRS_Fields_Permission_Config__c();
     TapeoutApplication.Name = 'Swift_Tapeout_Application';
     TapeoutApplication.CustomerRemoteJobviewFrame__c = true;
     TapeoutApplication.CustomerRemoteJobviewPrime__c = true;
     TapeoutApplication.DRW__c = true;
     TapeoutApplication.FoundryRemoteJobviewFrame__c = true;
     TapeoutApplication.FoundryRemoteJobviewPrime__c = true;
     TapeoutApplication.FrameMockupCustomer__c = true;
     TapeoutApplication.FrameMockupFoundry__c = true;
     TapeoutApplication.GDSOUTReviewCustomer__c = true;
     TapeoutApplication.GDSOUTReviewFoundry__c = true;
     TapeoutApplication.MEBESJobviewCustomer__c = true;
     TapeoutApplication.MEBESJobviewFoundry__c = true;
     TapeoutApplication.MEBESJobviewGlobalShuttle__c = true;
     TapeoutApplication.MEBESJobviewMDP__c = true;
     TapeoutApplication.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutApplication.MEBESJobviewTapeoutCenter__c = true;
     TapeoutApplication.MEBESJobviewTDTIMPW__c = true;
     TapeoutApplication.MEBESReceivedFrame__c = true;
     TapeoutApplication.MEBESReceivedPrime__c = true;
     TapeoutApplication.ORC__c = true;
     TapeoutApplication.SendDataFrame__c = true;
     TapeoutApplication.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutApplication);

     MRS_Fields_Permission_Config__c TapeoutCentre = new MRS_Fields_Permission_Config__c();
     TapeoutCentre.Name = 'SWIFT_Tapeout_Centre';
     TapeoutCentre.CustomerRemoteJobviewFrame__c = true;
     TapeoutCentre.CustomerRemoteJobviewPrime__c = true;
     TapeoutCentre.DRW__c = true;
     TapeoutCentre.FoundryRemoteJobviewFrame__c = true;
     TapeoutCentre.FoundryRemoteJobviewPrime__c = true;
     TapeoutCentre.FrameMockupCustomer__c = true;
     TapeoutCentre.FrameMockupFoundry__c = true;
     TapeoutCentre.GDSOUTReviewCustomer__c = true;
     TapeoutCentre.GDSOUTReviewFoundry__c = true;
     TapeoutCentre.MEBESJobviewCustomer__c = true;
     TapeoutCentre.MEBESJobviewFoundry__c = true;
     TapeoutCentre.MEBESJobviewGlobalShuttle__c = true;
     TapeoutCentre.MEBESJobviewMDP__c = true;
     TapeoutCentre.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutCentre.MEBESJobviewTapeoutCenter__c = true;
     TapeoutCentre.MEBESJobviewTDTIMPW__c = true;
     TapeoutCentre.MEBESReceivedFrame__c = true;
     TapeoutCentre.MEBESReceivedPrime__c = true;
     TapeoutCentre.ORC__c = true;
     TapeoutCentre.SendDataFrame__c = true;
     TapeoutCentre.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutCentre);

     MRS_Fields_Permission_Config__c TapeoutOperations = new MRS_Fields_Permission_Config__c();
     TapeoutOperations.Name = 'SWIFT_Tapeout_Operations';
     TapeoutOperations.CustomerRemoteJobviewFrame__c = true;
     TapeoutOperations.CustomerRemoteJobviewPrime__c = true;
     TapeoutOperations.DRW__c = true;
     TapeoutOperations.FoundryRemoteJobviewFrame__c = true;
     TapeoutOperations.FoundryRemoteJobviewPrime__c = true;
     TapeoutOperations.FrameMockupCustomer__c = true;
     TapeoutOperations.FrameMockupFoundry__c = true;
     TapeoutOperations.GDSOUTReviewCustomer__c = true;
     TapeoutOperations.GDSOUTReviewFoundry__c = true;
     TapeoutOperations.MEBESJobviewCustomer__c = true;
     TapeoutOperations.MEBESJobviewFoundry__c = true;
     TapeoutOperations.MEBESJobviewGlobalShuttle__c = true;
     TapeoutOperations.MEBESJobviewMDP__c = true;
     TapeoutOperations.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutOperations.MEBESJobviewTapeoutCenter__c = true;
     TapeoutOperations.MEBESJobviewTDTIMPW__c = true;
     TapeoutOperations.MEBESReceivedFrame__c = true;
     TapeoutOperations.MEBESReceivedPrime__c = true;
     TapeoutOperations.ORC__c = true;
     TapeoutOperations.SendDataFrame__c = true;
     TapeoutOperations.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutOperations);

     MRS_Fields_Permission_Config__c TDTIMPW = new MRS_Fields_Permission_Config__c();
     TDTIMPW.Name = 'SWIFT_TDTI-MPW';
     TDTIMPW.CustomerRemoteJobviewFrame__c = true;
     TDTIMPW.CustomerRemoteJobviewPrime__c = true;
     TDTIMPW.DRW__c = true;
     TDTIMPW.FoundryRemoteJobviewFrame__c = true;
     TDTIMPW.FoundryRemoteJobviewPrime__c = true;
     TDTIMPW.FrameMockupCustomer__c = true;
     TDTIMPW.FrameMockupFoundry__c = true;
     TDTIMPW.GDSOUTReviewCustomer__c = true;
     TDTIMPW.GDSOUTReviewFoundry__c = true;
     TDTIMPW.MEBESJobviewCustomer__c = true;
     TDTIMPW.MEBESJobviewFoundry__c = true;
     TDTIMPW.MEBESJobviewGlobalShuttle__c = true;
     TDTIMPW.MEBESJobviewMDP__c = true;
     TDTIMPW.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TDTIMPW.MEBESJobviewTapeoutCenter__c = true;
     TDTIMPW.MEBESJobviewTDTIMPW__c = true;
     TDTIMPW.MEBESReceivedFrame__c = true;
     TDTIMPW.MEBESReceivedPrime__c = true;
     TDTIMPW.ORC__c = true;
     TDTIMPW.SendDataFrame__c = true;
     TDTIMPW.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TDTIMPW);
     
     insert TotalPermissionConfig;  
     System.assertNotEquals(TotalPermissionConfig.size(),0);
    }

/**
    This method creates test data : MRS Layer Chip Association
    @method name: createMRSLCADataMRSLayer
    @parameter:   
                1) MRS Chip Details Id
                2) PTRF Id
                3) Account Id
                4) MRS Layer Association Id
                5) Mask Set Title Name
    @return :   MRS Layer Chip Association Object
**/   
    public static MRS_Layer_Chip_Association__c createMRSLCADataMRSLayer(String MRSChipDetailsMRSLayerId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsMRSLayerId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;

        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }
    
/**
    This method creates test data : MRS Chip Details
    @method name: createMRSChipDetailMRSLayer
    @parameter:   
                1) Mask Set Title Name
                2) MRS Object Id
    @return :   MRS Chip Details Object
**/
    public static MRS_Chip_Details__c createMRSChipDetailMRSLayer(String MaskSetTitleName,String MRSId){
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'TestChip';
        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }
  
/**
    This method creates test data : MRS Layer Association
    @method name: createMRSDataMRSLayer
    @parameter:   
                1) Layer Name
                2) Mask Layer Revision
                3) Mask Set Title Name
                4) MRS Object Id
    @return :   MRS Layer Association Object
**/ 
    public static MRS_Layer_Association__c createMRSDataMRSLayer(String LayerName, String MaskLayerRev, String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Association__c MRSObj = new MRS_Layer_Association__c();
        MRSObj.Customer_Frame_Mockup_Date__c = System.now();
        MRSObj.Customer_Frame_Mockup__c = 'Not Ready';
        MRSObj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Customer_GDSOUT_Review_Date__c = System.now();
        MRSObj.Customer_GDSOUT_Review__c = 'In Progress';
        MRSObj.Customer_MEBES_Jobview_Date__c = System.now();  
        MRSObj.Customer_MEBES_Jobview__c = 'In Progress';
        MRSObj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        MRSObj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Disapprove_Reason_For_Frame_Mockup_Revie__c = 'Disaproved';
        MRSObj.DRW_Date__c = System.now();
        MRSObj.DRW__c = 'Not Ready';
        MRSObj.Error_Message_Oracle_DB__c = '';
        MRSObj.First_Sync_with_Oracle__c = false;
        MRSObj.Foundry_Frame_Mockup_Date__c = System.now();
        MRSObj.Foundry_Frame_Mockup__c = 'In Progress';
        MRSObj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        MRSObj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Foundry_GDSOUT_Review_Date__c = System.now();
        MRSObj.Foundry_GDSOUT_Review__c = 'In Progress';
        MRSObj.Foundry_MEBES_Jobview_Date__c = System.now();
        MRSObj.Foundry_MEBES_Jobview__c = 'Ready';
        MRSObj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Frame_MEBES_Received_Date__c = System.now();
        MRSObj.Frame_MEBES_Received__c = 'Not Done';
        MRSObj.Generated_Mask_Title__c = '';
        MRSObj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        MRSObj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Hold_Warning__c = '';
        MRSObj.Layer_Name__c = '';
        MRSObj.Layer_Status_Date__c = System.now();
        MRSObj.Layer_Status__c = 'In Progress';
        MRSObj.Mask_Layer_Rev__c = MaskLayerRev;
        MRSObj.MDP_MEBES_Jobview_Date__c = System.now();
        MRSObj.MDP_MEBES_Jobview__c = 'In Progress';
        MRSObj.MRS__c = MRSObjId;
        MRSObj.Name = LayerName;
        MRSObj.ORC_Date__c = System.now();
        MRSObj.ORC__c = 'Done';
        MRSObj.Prime_MEBES_Received_Date__c = System.now();
        MRSObj.Prime_MEBES_Received__c = 'Not Done';
        MRSObj.Reticle_Type__c = 'Multi Node Reticle (MNR)';
        MRSObj.ROM_Code__c = '123';
        MRSObj.Send_Frame_Data_Date__c = System.now();
        MRSObj.Send_Frame_Data__c = 'Not Done';
        MRSObj.Send_Prime_Data_Date__c = System.now();
        MRSObj.Send_Prime_Data__c = 'Not Done';
        MRSObj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Centre_MEBES_Jobview__c = 'In Progress';
        MRSObj.TDTI_MPW_MEBES_Jobview_Date__c = System.now();  
        MRSObj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tech_Geo__c = '0.018UM';
        MRSObj.Last_Sync_Request_Timestamp__c = System.now();
        MRSObj.LogicalOperation__c = 'TECN;Foundry Std'; 
        MRSObj.LogicalOperationType__c = 'TECN';
        MRSObj.Layer_Old_Status__c = 'In Progress';
        MRSObj.Synced_with_Oracle_DB__c = false;
        MRSObj.created_at_Oracle_DB__c = false;
        //insert MRSObj;
        //System.assertNotEquals(MRSObj.Id,null);
        return MRSObj;
    }
    
/**
    This method creates test data : MRS Object
    @method name: createMRSMRSLayer
    @parameter:   None
    @return :     MRS Object
**/
    public static MRS__c createMRSMRSLayer(PTRF__c objPTRFMRSLayer, Mask_Set_Title__c objMSTMRSLayer){
        MRS__c obj = new MRS__c();
        obj.Associated_PTRF__c = objPTRFMRSLayer.Id;
        obj.Mask_Set_Title__c = objMSTMRSLayer.Id;
        obj.MRS_Package_Sync__c = false;
        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }

/**
    This method creates test data : Mask Set Title
    @method name: createMSTMRSLayer
    @parameter:   Mask Set Title Name
    @return :     Mask Set Title Object
**/      
    private static Mask_Set_Title__c createMSTMRSLayer(string mstname){
        
        Mask_Set_Title__c MST= new Mask_Set_Title__c ();
        MST.Is_Available_For_Use__c = true;
        MST.Name =mstname; 
        MST.Status__c = 'Active';
       
        insert MST;
        System.assertNotEquals(MST.Id,null);
        return MST;
    }

/**
    This method creates test data : Mask Layer
    @method name: createMaskLayerMRSLayer
    @parameter:   
                1) PTRF Object
                2) Mask Set Title Object
                3) Layer Name
                4) ROM Code
                5) Layer Revision
    @return :     Mask Layer Object
**/     
    private static Mask_Layer__c createMaskLayerMRSLayer(PTRF__c ptrf,Mask_Set_Title__c  MSTObj,string Layername,string RomCode, string LayerRev ){
        
        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = Layername; 
        maskLayer.Mask_Layer_Number__c = Layername;
        maskLayer.Mask_Set_Title__c  =MSTObj.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = RomCode;
        maskLayer.Mask_Layer_Rev__c =LayerRev ; 
        maskLayer.LogicalOperation__c = 'TECN;Foundry Std'; 
        maskLayer.LogicalOperationType__c = 'TECN';
        maskLayer.Sort_Order__c = 1;
        insert maskLayer;
        System.assertNotEquals(maskLayer.Id,null);
        return maskLayer;
    }

/**
    This method creates test data : PTRF
    @method name: createPTRFMRSLayer
    @parameter:   
                1) PTRF Name
                2) Mask Set Title Object
                3) Device Id
    @return :     PTRF Object
**/      
     private static PTRF__c createPTRFMRSLayer(string ptrfname,Mask_Set_Title__c  MSTObj,String DeviceId){
        
        PTRF__c ptrf = new PTRF__c();
        
        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c=MSTObj.id;
        ptrf.MaskSetTitle__c=MSTObj.id;
        ptrf.Device_Id__c=DeviceId;
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Device__c = null;
        ptrf.Recticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert ptrf;
        System.assertNotEquals(ptrf.Id,null);
        return ptrf;
    } 
   
/**
    This method creates test data : Account
    @method name: createTestAccountMRSLayer
    @parameter:   None
    @return :     None
**/     
     public static Account createTestAccountMRSLayer(){
          Account acc;
           
            acc = new Account(
            name = 'TEST rec',
            Account_Type__c='Customer',
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111'
        );
        insert acc;
        System.assertNotEquals(acc.Id,null);
        return acc;
    } 
    
/**
    This method creates test data : Opportunity
    @method name: createOpportunityMRSLayer
    @parameter:   AccountId
    @return :     None
**/     
     private static Id createOpportunityMRSLayer(Id testAcctId) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','MRSLayerSummary');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }

/**
    This method fetches the profile Id of with profile name = GF FAE/FTS
    @method name: FEUserProfileIdMRSLayer
    @parameter:   User object
    @return :     Id of the profile
**/ 
    public static Id FEUserProfileIdMRSLayer(User u){
        Profile FEUserProfile = new Profile();
        System.runAs(u){
            FEUserProfile = [SELECT Id FROM Profile WHERE Name='GF FAE/FTS'];
        }
        System.assertNotEquals(FEUserProfile.Id,null);
        return FEUserProfile.Id;
    }

/**
    This method fetches the profile Id of with profile name = GF Sales User
    @method name: StandardUserProfileIdMRSLayer
    @parameter:   User object
    @return :     Id of the profile
**/     
    public static Id StandardUserProfileIdMRSLayer(User u){
        Profile StandardUserProfile = new Profile();
        System.runAs(u){
            StandardUserProfile = [SELECT Id FROM Profile WHERE Name='GF Sales User'];
        }
        System.assertNotEquals(StandardUserProfile.Id,null);
        return StandardUserProfile.Id;
    }    

/**
    This method is for creating test data : User
    @method name: createsysAdminUserMRSLayer
    @parameter:   User object
    @return :     None
**/    
     public static void createsysAdminUserMRSLayer(User u){
            
            List<String> MRSPermName = new List<String>();
            List<MRS_Fields_Permission_Config__c> FPC = [SELECT Name FROM MRS_Fields_Permission_Config__c];
            for(MRS_Fields_Permission_Config__c obj : FPC){
                MRSPermName.add(String.valueOf(obj.Name));
            }
            List<Group> ListOfGroups = [select Id, DeveloperName, Name from Group where Name in:MRSPermName];
            
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                if(g.Name.equalsIgnoreCase('Swift GlobalShuttle')||g.Name.equalsIgnoreCase('Swift MDP')||g.Name.equalsIgnoreCase('SWIFT Support')||g.Name.equalsIgnoreCase('Swift Tapeout Application')||g.Name.equalsIgnoreCase('Swift Tapeout Operations')||g.Name.equalsIgnoreCase('Swift Tapeout Centre')||g.Name.equalsIgnoreCase('Swift TDTI-MPW')){
                //||g.Name.equalsIgnoreCase('Swift MDP')||g.Name.equalsIgnoreCase('SWIFT Support')||g.Name.equalsIgnoreCase('Swift Tapeout Application')||g.Name.equalsIgnoreCase('Swift Tapeout Operations')||g.Name.equalsIgnoreCase('Swift Tapeout Centre')||g.Name.equalsIgnoreCase('Swift TDTI-MPW'))
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
                }
            }
            insert GM;                    
            System.assertNotEquals(GM.size(),0);         
    }    

/**
    This method is for creating test data : Groups
    @method name: createGroupsMRSLayer
    @parameter:   None
    @return :     List of Group objects
**/     
    public static List<Group> createGroupsMRSLayer(){
        List<Group> groupList = new List<Group>();
        Group MDP = new Group();
        Group SwiftAdmin = new Group();
        Group SwiftGlobalShuttle = new Group();
        
        MDP.DeveloperName = 'Swift_MDP';
        MDP.DoesIncludeBosses = true;
        MDP.DoesSendEmailToMembers = false;
        MDP.Name = 'Swift MDP';
        MDP.Type = 'Regular';

        SwiftAdmin.DeveloperName = 'SWIFT_Admin';
        SwiftAdmin.DoesIncludeBosses = true;
        SwiftAdmin.DoesSendEmailToMembers = false;
        SwiftAdmin.Name = 'SWIFT Admin';
        SwiftAdmin.Type = 'Regular';
        
        SwiftGlobalShuttle.DeveloperName = 'Swift_GlobalShuttle';
        SwiftGlobalShuttle.DoesIncludeBosses = true;
        SwiftGlobalShuttle.DoesSendEmailToMembers = false;
        SwiftGlobalShuttle.Name = 'Swift GlobalShuttle';
        SwiftGlobalShuttle.Type = 'Regular';   
        
        groupList.add(MDP);     
        groupList.add(SwiftGlobalShuttle);
        
        insert groupList; 
        System.assertNotEquals(groupList.size(),0);
        return groupList;               
    }

/**
    This method is for creating test data : Customer Layer Summary Permission
    @method name: createCustomerPermissionMRSLayer
    @parameter:   None
    @return :     Object of Customer_Layer_Summary_Permission__c
**/     
   public static Customer_Layer_Summary_Permission__c createCustomerPermissionMRSLayer(Account objAccountMRSLayer){

       Customer_Layer_Summary_Permission__c customerPermission = new Customer_Layer_Summary_Permission__c();
       customerPermission.Customer__c = objAccountMRSLayer.Id;
       customerPermission.Customer_Remote_Jobview__c = true;
       //customerPermission.Customer_Short_Name__c = 'test';
       customerPermission.Frame_Mockup__c = true;
       customerPermission.GDSOUT_Review__c = true;
       customerPermission.MEBES_Jobview__c = true;
       insert customerPermission;
       System.assertNotEquals(customerPermission.Id,null);
       return customerPermission;
   }
/**
        This method is creating users for creating users for testing 
        @method name: createStandardFEUserMRSLayer
        @parameter:   Account object
        @return :     void
**/
  public static void createStandardFEUserMRSLayer(Account acc){
        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
        List<User> UList = new List<User>();
        User userSUMRSLayerFEMRSLayer = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');
        UList.add(userSUMRSLayerFEMRSLayer); 
        User userSUMRSLayer = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2');     
        UList.add(userSUMRSLayer); 
        User userSUMRSLayerGShuttleMRSLayer = new User(alias = 'testMRS4', email='testMRS4@test.com',
            emailencodingkey='UTF-8', lastname='testMRS4Last', firstname='testMRS4First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS4@test.com',communitynickname='testMRS4'); 
        UList.add(userSUMRSLayerGShuttleMRSLayer);
        insert UList;
        
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_MDP']; 
        Group groupGShuttle = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];//'Swift_GlobalShuttle']; 
        System.assertNotEquals(groupGS.Id,null);
        List<GroupMember> LGM = new List<GroupMember>();
        GroupMember groupMemberFE = new GroupMember();           
        groupMemberFE.GroupId = groupGS.Id;
        groupMemberFE.UserOrGroupId = userSUMRSLayerFEMRSLayer.Id;
        LGM.add(groupMemberFE);
        GroupMember groupMemberSU = new GroupMember();           
        groupMemberSU.GroupId = groupGS.Id;
        groupMemberSU.UserOrGroupId = userSUMRSLayer.Id;
        LGM.add(groupMemberSU); 
        GroupMember groupMemberShuttle = new GroupMember();           
        groupMemberShuttle.GroupId = groupGShuttle.Id;
        groupMemberShuttle.UserOrGroupId = userSUMRSLayerGShuttleMRSLayer.Id;   
        LGM.add(groupMemberShuttle);            
        insert LGM;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSUMRSLayerFEMRSLayer.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;  
  }
  
  /**
        This method is for testing the Triggers in MRS Layer Association object (MRS_Layer_Association_SWIFT_BUPD, MRS_Layer_Association_SWIFT_AUPD, MRS_Layer_Association_SWIFT_BINS) 
        @method name: TriggerTest0
        @parameter:   None
        @return :     void
**/  
  public static testmethod void TriggerTest0(){
      User sysAdminUserMRSLayer = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
      MRS_Layer_Association__c  MRSLAObjMRSLayer1 = [Select Id, name, MRS__c from MRS_Layer_Association__c where Name='MLN001' limit 1];
      System.runAs(sysAdminUserMRSLayer){
          Mask_Set_Title__c objMST2 = SwiftDataUtilityTest.createMST('MPW0001');
          Test.startTest();
          insert objMST2;
          PTRF__c objPTRF3 = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST2.Id);
          insert objPTRF3;
          MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=MRSLAObjMRSLayer1.MRS__c,Name='Chip001');
          insert objMRSCD1;
          
          MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=MRSLAObjMRSLayer1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF3.Id,Tech_Geo__c='0.019UM');           
          insert objMRSLCA1;
          
              //Test.setCurrentPage(Page.VFMRSLayerSummary);
              //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
              
              //MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
              
              MRSLAObjMRSLayer1.Layer_Status__c = 'Released';
              update MRSLAObjMRSLayer1;            
             
          Test.stopTest();
      }
  } 
/**
        This method is for testing the Triggers in MRS Layer Association object (MRS_Layer_Association_SWIFT_BUPD, MRS_Layer_Association_SWIFT_AUPD, MRS_Layer_Association_SWIFT_BINS) 
        @method name: TriggerTest1
        @parameter:   None
        @return :     void
**/  
  public static testmethod void TriggerTest1(){
      User sysAdminUserMRSLayer = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
      MRS_Layer_Association__c  MRSLAObjMRSLayer1 = [Select Id, name,MRS__c from MRS_Layer_Association__c where Name='MLN001' limit 1];
      System.runAs(sysAdminUserMRSLayer){
          Mask_Set_Title__c objMST2 = SwiftDataUtilityTest.createMST('MPW0001');
          Test.startTest();
          insert objMST2;
          PTRF__c objPTRF3 = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST2.Id);
          insert objPTRF3;
          MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=MRSLAObjMRSLayer1.MRS__c,Name='Chip001');
          insert objMRSCD1;
          
          MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=MRSLAObjMRSLayer1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF3.Id,Tech_Geo__c='0.019UM');           
          insert objMRSLCA1;
          
              //Test.setCurrentPage(Page.VFMRSLayerSummary);
              //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
              
              //MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
              MRSLAObjMRSLayer1.Layer_Status__c = 'Hold';
              update MRSLAObjMRSLayer1;
              MRSLAObjMRSLayer1.Layer_Status__c = 'Released'; 
              update MRSLAObjMRSLayer1;
             
          Test.stopTest();
      }
  }     
/**
        This method is for testing the Triggers in MRS Layer Association object (MRS_Layer_Association_SWIFT_BUPD, MRS_Layer_Association_SWIFT_AUPD, MRS_Layer_Association_SWIFT_BINS) 
        @method name: TriggerTest2
        @parameter:   None
        @return :     void
**/
  public static testmethod void TriggerTest2(){
      User sysAdminUserMRSLayer = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
      MRS_Layer_Association__c  MRSLAObjMRSLayer1 = [Select Id, name from MRS_Layer_Association__c where Name='MLN001' limit 1];
      MRS_Layer_Association__c  MRSLAObjMRSLayer2 = [Select Id, name from MRS_Layer_Association__c where Name='MLN002' limit 1];
      System.runAs(sysAdminUserMRSLayer){
          Test.startTest();
              //Test.setCurrentPage(Page.VFMRSLayerSummary);
              //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
              
              //MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
              MRSLAObjMRSLayer2.Layer_Status__c = 'Pending Foundry Release';
              MRSLAObjMRSLayer2.Synced_with_Oracle_DB__c = true;
              MRSLAObjMRSLayer2.created_at_Oracle_DB__c = true;
              update MRSLAObjMRSLayer2;
              MRSLAObjMRSLayer1.Layer_Status__c = 'Shipped';
              update MRSLAObjMRSLayer1;              
          Test.stopTest();
      }
  } 
/**
        This method is for testing the Triggers in MRS Layer Association object (MRS_Layer_Association_SWIFT_BUPD, MRS_Layer_Association_SWIFT_AUPD, MRS_Layer_Association_SWIFT_BINS) 
        @method name: TriggerTest3
        @parameter:   None
        @return :     void
**/ 
  public static testmethod void TriggerTest3(){
      User sysAdminUserMRSLayer = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
      MRS_Layer_Association__c  MRSLAObjMRSLayer1 = [Select Id, name from MRS_Layer_Association__c where Name='MLN001' limit 1];
      System.runAs(sysAdminUserMRSLayer){
          Test.startTest();
              //Test.setCurrentPage(Page.VFMRSLayerSummary);
              //ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
              
              //MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
              MRSLAObjMRSLayer1.Layer_Status__c = 'Shipped';
              update MRSLAObjMRSLayer1;              
          Test.stopTest();
      }
  }
    


/**
        This method is for setting default Test Environment data and creating Test Account instance. 
        @method name: TestAccountInsert
        @parameter:   None
        @return :     void
     **/  
 public static void TestAccountInsert(){
            SwiftDataUtilityTest.customSystemData();
            Account objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
            System.assertNotEquals(objAccount,null);
                objAccount.stage__c = 'Qualified';
                update objAccount;
                
    }
    
    @testSetup static void setupData(){
           DataUtilTest.loadEnvironmentVariables();
             //TestAccountInsert();
             //Account objAccount = [Select Id, name from Account where Name='Test Account 009'];
             Account objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
             Account objAccountMRSLayer = objAccount;
             //TestAccountInsertMRSLayer();
             //CreateDataMRSLayer();
             Mask_Set_Title__c objMST=createMST('MPW1001');
             DRT__c objDRT = new DRT__c(Name='TestDRT');
             insert objDRT;
             Test.startTest();
             List<PTRF__c> ptrfList = new List<PTRF__c>();
             PTRF__c objPTRF= createPTRF('PTRF 000 1001',objMST,null); 
             ptrfList.add(objPTRF);
             PTRF__c objPTRF2= createPTRF2('PTRF 000 1002',objMST,null); 
             ptrfList.add(objPTRF2);
             PTRF__c objPTRF4= createPTRF4('PTRF 000 1004',objMST,null);
             ptrfList.add(objPTRF4);
             insert ptrfList;
             
             //objPTRF5= createPTRF5('PTRF 000 1005',objMST,null);
             
             List<Mask_Layer__c> maskLayerList = new List<Mask_Layer__c>();
             Mask_Layer__c objLayer= createMaskLayer(objPTRF,objMST,'MLN001','AZ','01'); 
             maskLayerList.add(objLayer);
             Mask_Layer__c objLayer2= createMaskLayer(objPTRF2,objMST,'MLN002','AZ','01'); 
             maskLayerList.add(objLayer2);
             insert maskLayerList;
            
             
               MRS__c MRSObject = createMRS(objPTRF,objMST);
                 System.assertNotEquals(MRSObject.Id,null);
                 
                 List<MRS_Chip_Details__c> mrsChipDetailsList = new List<MRS_Chip_Details__c>();
                 MRS_Chip_Details__c MRSChipDetails = createMRSChipDetail(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSChipDetails.Id,null);
                 mrsChipDetailsList.add(MRSChipDetails);
              MRS_Chip_Details__c   MRSChipDetails2 = createMRSChipDetail2(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSChipDetails2.Id,null); 
                 mrsChipDetailsList.add(MRSChipDetails2);
                 insert mrsChipDetailsList;
                
                 List<MRS_Layer_Association__c> mrsLayerAssociationList = new List<MRS_Layer_Association__c>();                  
                 MRS_Layer_Association__c MRSLAObj1 = createMRSData(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLAObj1.Id,null);
                 mrsLayerAssociationList.add(MRSLAObj1);
                 
                MRS_Layer_Association__c MRSLAObj2 = createMRSData(String.valueOf(objLayer2.Name), String.valueOf(objLayer2.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLAObj2.Id,null);   
                mrsLayerAssociationList.add(MRSLAObj2);
                 

                  MRS_Layer_Association__c MRSLAObjMRSLayer1 = createMRSDataMRSLayer(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLAObjMRSLayer1.Id,null);
                 mrsLayerAssociationList.add(MRSLAObjMRSLayer1);
                 
                 MRS_Layer_Association__c MRSLAObjMRSLayer2 = createMRSDataMRSLayer(String.valueOf(objLayer2.Name), String.valueOf(objLayer2.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLAObjMRSLayer2.Id,null);  
                 mrsLayerAssociationList.add(MRSLAObjMRSLayer2);
                insert mrsLayerAssociationList;
             
              mrshandlerutility.numberOfLayerChipRecords=1;
             
             //Test.startTest();
                
                List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociation = new List<MRS_Layer_Chip_Association__c>();
                  MRS_Layer_Chip_Association__c MRSLCAObj1 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLCAObj1.Id,null);
                 mrsLayerChipAssociation.add(MRSLCAObj1);
              
                 MRS_Layer_Chip_Association__c MRSLCAObj2 = createMRSLCAData2(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 //System.assertNotEquals(MRSLCAObj2.Id,null);
                 mrsLayerChipAssociation.add(MRSLCAObj2);
                insert mrsLayerChipAssociation;
             
             /*
             MRSLCAObj3 = createMRSLCAData3(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 System.assertNotEquals(MRSLCAObj3.Id,null);
                 
             
             MRS_Layer_Chip_Association__c MRSLCAObj4 = createMRSLCAData4(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 System.assertNotEquals(MRSLCAObj4.Id,null); 
              */
              
                 
             
             MRS_Layer_Association__c layerSummary= [select name,Layer_Status__c,ID from MRS_Layer_Association__c limit 1];
             
             System.runAs(new User(Id = UserInfo.getUserId())) {
                 User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
                 //sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name like '%integration%' AND isActive = true].get(0);
                 Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName ='SWIFT_Admin']; 
                GroupMember groupMember = new GroupMember();           
                groupMember.GroupId = groupGS .Id;
                groupMember.UserOrGroupId = sysAdminUser .Id;
                insert groupMember;
                
                User IntegrationUser = [SELECT Id,Name,profileid FROM User WHERE Profile.Name like '%integration%'  and IsActive=true].get(0);
                
                list<User> listUser = new list<User>();       
                Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
                UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
                UserRole usrRole2=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];

            }
            Test.stopTest();
   }
   
   
   /**
        This method is for storing data in MRS_Layer_Chip_Status_Hierarchy__c object for test method execution. 
        @method name: createSettingsMain
        @parameter:   None
        @return :     void
     **/
     private static void createSettingsMain(){
        
        createSettings('Customer_Frame_Mockup__c','2','4','0','0','1','3','4','0','0');
        createSettings('Customer_Frame_Remote_Jobview_Setup__c','0','0','0','0','1','0','0','2','0');       
        createSettings('Customer_GDSOUT_Review__c','2','4','0','0','1','3','0','0','0');      
        createSettings('Customer_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('Customer_Prime_Remote_Jobview_Setup__c','0','0','0','0','1','0','0','2','0');      
        createSettings('DRW__c','2','0','0','3','1','0','0','4','0');      
        createSettings('Foundry_Frame_Mockup__c','2','4','0','0','1','3','4','0','0');      
        createSettings('Foundry_Frame_Remote_Jobview_Setup__c','0','0','0','0','1','0','0','2','0');      
        createSettings('Foundry_GDSOUT_Review__c','2','4','0','0','1','3','0','0','0');      
        createSettings('Foundry_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('Foundry_Prime_Remote_Jobview_Setup__c','0','0','0','0','1','0','0','2','0');      
        createSettings('Frame_MEBES_Received__c','0','0','2','0','1','0','0','3','0');      
        createSettings('GlobalShuttle_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('MDP_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('ORC__c','0','0','2','0','1','0','0','3','0');      
        createSettings('Prime_MEBES_Received__c','0','0','2','0','1','0','0','3','0');      
        createSettings('Send_Frame_Data__c','2','0','0','0','1','3','0','4','0');      
        createSettings('Send_Prime_Data__c','2','0','0','0','1','3','0','4','0');      
        createSettings('Tapeout_Applications_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('Tapeout_Centre_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');      
        createSettings('TDTI_MPW_MEBES_Jobview__c','2','0','0','0','1','3','0','0','4');            
       
        List<MRS_Layer_Chip_Status_Hierarchy__c> lstHierarchy = [select Name from MRS_Layer_Chip_Status_Hierarchy__c limit 1];
        System.assertnotEquals(0,lstHierarchy.size());
    }
    
    /**
        This method is for storing data in MRS_Layer_Chip_Status_Hierarchy__c object for test method execution. 
        @method name: createSettings
        @parameter:   1. Status name
                      2. Value for Approve  
                      3. Value for Disapprove
                      4. Value for Done
                      5. Value for InProgress
                      6. Value for NA
                      7. Value for NotDone
                      8. Value for NotReady
                      9. Value for Ready
                      10. Value for Released
        @return :     void
     **/
     private static void createSettings(string strname,string NotReady,string Approve,string NotDone,string InProgress,string NA,string Ready, string Disapprove,string Done,string Released){
        
        MRS_Layer_Chip_Status_Hierarchy__c  objStatus= new MRS_Layer_Chip_Status_Hierarchy__c ();
        objStatus.name= strname;
        objStatus.Approve__c= Approve;
        objStatus.Disapprove__c= Disapprove;
        objStatus.Done__c= Done;
        objStatus.InProgress__c= InProgress;
        objStatus.NA__c= NA;
        objStatus.Not_Done__c= NotDone;
        objStatus.Not_Ready__c= NotReady;
        objStatus.Ready__c= Ready;
        objStatus.Released__c= Released;
        
        insert objStatus;
        
        System.assertnotEquals(null,objStatus);
       
    }
    
    
     /**
        This method is for storing data in Chip_Detail__c object for test method execution. 
        @method name: createChipDetail
        @parameter:   1. PTRF object
                      2. Chip name  
        @return :     Chip_Detail__c object
     **/
     private static Chip_Detail__c createChipDetail(PTRF__c ptrf,string chipname){
        
        Chip_Detail__c  chipDetail= new Chip_Detail__c();
        chipDetail.PTRF__c= ptrf.Id;
        chipDetail.Name = chipname;
        
        insert chipDetail;
        System.assertnotEquals(null,chipDetail);
        
        return chipDetail;
    }
    
    /**
        This method is for storing data in Mask_Set_Title__c object for test method execution. 
        @method name: createMST
        @parameter:   1. MST name
        @return :     Mask_Set_Title__c object
     **/
    private static Mask_Set_Title__c createMST(string mstname){
        
        Mask_Set_Title__c MST= SwiftDataUtilityTest.createMST(mstname);
       
        insert MST;
        
        return MST;
    }
    
    /**
        This method is for storing data in Mask_Layer__c object for test method execution. 
        @method name: createMaskLayer
        @parameter:   1. PTRF object
                      2. Mask_Set_Title__c  object  
                      3. Layer Name
                      4. Rom Code
                      5. Layer Revision code
        @return :     Mask_Layer__c object
     **/
    private static Mask_Layer__c createMaskLayer(PTRF__c ptrf,Mask_Set_Title__c  objMST1,string Layername,string RomCode, string LayerRev ){
        
        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = Layername; 
        maskLayer.Mask_Set_Title__c  =objMST1.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = RomCode;
        maskLayer.Mask_Layer_Rev__c =LayerRev ; 
        maskLayer.LogicalOperation__c = 'Foundry Std'; 
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
        //insert maskLayer;
        System.assertnotEquals(null,maskLayer );
        
        return maskLayer;
    }
    
    /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice1){
        
        PTRF__c ptrf = new PTRF__c();
        
        
        //ptrf.Status__c = 'Active';
        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=objMST1.id;
        ptrf.Device_Id__c='Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c ='testPTRF01';
        ptrf.Frame_DRT__c = 'testPTRFFrame';
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = 'Send Frame Files to Maskshop';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        //ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        
        ptrf.Recticle_Type__c='Single Layer Reticle (SLR)';
        
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.DRC_DRW_Status__c='Completed'; // DRW
        
        ptrf.DRC_Rerun__c  = false;
        
        //insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    } 
    
    
    /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF2
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF2(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice1){
        
        PTRF__c ptrf = new PTRF__c();
        
        
        //ptrf.Status__c = 'Active';
        ptrf.Status__c = 'Perform Tapeout Options';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=objMST1.id;
        ptrf.Device_Id__c='Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = 'Frame Generation';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        //ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Recticle_Type__c='Single Layer Reticle (SLR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.DRC_DRW_Status__c='Completed';
        
        //insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    } 
    
    
     /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF3
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF3(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice1){
        
        PTRF__c ptrf = new PTRF__c();
        
        
        //ptrf.Status__c = 'Active';
        ptrf.Status__c = 'Perform Tapeout Options';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=objMST1.id;
        ptrf.Device_Id__c='Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = 'Completed';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.DRC_DRW_Status__c='DRW';
        
        //insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    } 

     private static PTRF__c createPTRF4(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice1){
        
        PTRF__c ptrf = new PTRF__c();
        
        
        //ptrf.Status__c = 'Active';
        ptrf.Status__c = 'Perform Tapeout Options';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=null;
        ptrf.Device_Id__c='Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = 'Completed';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.03UM';
        ptrf.DRC_DRW_Status__c='Completed';
        
        //insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    }
    
     /**
        This method is for storing data in Process_Technology__c object for test method execution. 
        @method name: createProcessTechnology
        @parameter:   None
        @return :     Process_Technology__c object
     **/
     private static Process_Technology__c createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        p.Tech_Geometry__c='0.02';
        insert p;
        System.assertnotEquals(null,p);
            
        return p;
    }
    
    /**
        This method is for storing data in Device object for test method execution. 
        @method name: createDevicePT
        @parameter:   1. Process Technology object
                      2. Opp Program Id  
        @return :     Device__c object
     **/
     private static Device__c createDevicePT(Process_Technology__c  processTechnology,ID testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICE999';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.IP_Technology__c = 'TECH1';
        device.Process_Technology_2__c = processTechnology.id;
        
        insert device;
        System.assertnotEquals(null,device);
        
        return device;
    }
    
    /**
        This method is for storing data in Opportunity_Program__c object for test method execution. 
        @method name: createOpportunityProgram
        @parameter:   1. Account id
                      2. Opp Program Id  
        @return :     Opportunity_Program__c Id
     **/
     private static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        System.assertnotEquals(null,testOpptyProgram);
        
        return testOpptyProgram.Id;
    }
    
    /**
        This method is for storing data in Account object for test method execution. 
        @method name: createTestAccount
        @parameter:   none
        @return :     Account object
     **/
     public static Account createTestAccount(){
          Account acc;
           
            acc = new Account(
            name = 'TEST rec',
            Account_Type__c='Customer',
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111'
        );
        insert acc;
        System.assertnotEquals(null,acc);
        return acc;
    } 
    
    /**
        This method is for storing data in Opportunity object for test method execution. 
        @method name: createOpportunity
        @parameter:   1. Account Id
        @return :     Oportunity Id
     **/
     private static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','MRSLayerSummary');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
     
    
    /**
        This method is for storing data in MRS__c object for test method execution. 
        @method name: createMRS
        @parameter:   None
        @return :     MRS__c object
     **/
     public static MRS__c createMRS(PTRF__c objPTRF,Mask_Set_Title__c objMST){
        MRS__c obj = new MRS__c();
        obj.Associated_PTRF__c = objPTRF.Id;
        obj.Mask_Set_Title__c = objMST.Id;
        obj.MRS_Package_Sync__c = false;
        insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    /**
        This method is for storing data in MRS_Chip_Details__c object for test method execution. 
        @method name: createMRSChipDetail
        @parameter:   1. MST name
                      2. MRS Id
        @return :     MRS_Chip_Details__c object
     **/
     public static MRS_Chip_Details__c createMRSChipDetail(String MaskSetTitleName,String MRSId){
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'Frame';
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
     /**
        This method is for storing data in MRS_Chip_Details__c object for test method execution. 
        @method name: createMRSChipDetail
        @parameter:   1. MST name
                      2. MRS Id
        @return :     MRS_Chip_Details__c object
     **/
     public static MRS_Chip_Details__c createMRSChipDetail2(String MaskSetTitleName,String MRSId){
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'Frame';
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    /**
        This method is for storing data in MRS_Layer_Association__c object for test method execution. 
        @method name: createMRSData
        @parameter:   1. Layer name
                      2. Mask Layer Rev
                      3. MST Name
                      4. MRS id
        @return :     MRS_Layer_Association__c object
     **/
     public static MRS_Layer_Association__c createMRSData(String LayerName, String MaskLayerRev, String MaskSetTitleName,String MRSObjId){

        MRS_Layer_Association__c MRSObj = new MRS_Layer_Association__c();
        MRSObj.Customer_Frame_Mockup_Date__c = System.now();
        MRSObj.Customer_Frame_Mockup__c = 'Not Ready';
        MRSObj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Customer_GDSOUT_Review_Date__c = System.now();
        MRSObj.Customer_GDSOUT_Review__c = 'In Progress';
        MRSObj.Customer_MEBES_Jobview_Date__c = System.now();  
        MRSObj.Customer_MEBES_Jobview__c = 'In Progress';
        MRSObj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        MRSObj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Disapprove_Reason_For_Frame_Mockup_Revie__c = 'Disaproved';
        MRSObj.DRW_Date__c = System.now();
        MRSObj.DRW__c = 'Not Ready';
        MRSObj.Error_Message_Oracle_DB__c = '';
        MRSObj.First_Sync_with_Oracle__c = false;
        MRSObj.Foundry_Frame_Mockup_Date__c = System.now();
        MRSObj.Foundry_Frame_Mockup__c = 'In Progress';
        MRSObj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        MRSObj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Foundry_GDSOUT_Review_Date__c = System.now();
        MRSObj.Foundry_GDSOUT_Review__c = 'In Progress';
        MRSObj.Foundry_MEBES_Jobview_Date__c = System.now();
        MRSObj.Foundry_MEBES_Jobview__c = 'Ready';
        MRSObj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Frame_MEBES_Received_Date__c = System.now();
        MRSObj.Frame_MEBES_Received__c = 'Not Done';
        MRSObj.Generated_Mask_Title__c = '';
        MRSObj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        MRSObj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Hold_Warning__c = '';
        MRSObj.Layer_Name__c = '';
        MRSObj.Layer_Status_Date__c = System.now();
        MRSObj.Layer_Status__c = 'In Progress';
        MRSObj.Mask_Layer_Rev__c = MaskLayerRev;
        MRSObj.MDP_MEBES_Jobview_Date__c = System.now();
        MRSObj.MDP_MEBES_Jobview__c = 'In Progress';
        MRSObj.MRS__c = MRSObjId;
        MRSObj.Name = LayerName;
        MRSObj.ORC_Date__c = System.now();
        MRSObj.ORC__c = 'Done';
        MRSObj.Prime_MEBES_Received_Date__c = System.now();
        MRSObj.Prime_MEBES_Received__c = 'Not Done';
        MRSObj.Reticle_Type__c = 'Multi Node Reticle (MNR)';
        MRSObj.ROM_Code__c = '123';
        MRSObj.Send_Frame_Data_Date__c = System.now();
        MRSObj.Send_Frame_Data__c = 'Not Done';
        MRSObj.Send_Prime_Data_Date__c = System.now();
        MRSObj.Send_Prime_Data__c = 'Not Done';
        MRSObj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Centre_MEBES_Jobview__c = 'In Progress';
        MRSObj.TDTI_MPW_MEBES_Jobview_Date__c = System.now();  
        MRSObj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tech_Geo__c = '0.018UM';
        MRSObj.Last_Sync_Request_Timestamp__c = System.now();
        MRSObj.LogicalOperation__c = 'TECN;Foundry Std'; 
        MRSObj.LogicalOperationType__c = 'TECN';
        MRSObj.Layer_Old_Status__c = 'In Progress';
        MRSObj.Synced_with_Oracle_DB__c = false;
        MRSObj.created_at_Oracle_DB__c = false;
        //insert MRSObj;
        //System.assertNotEquals(MRSObj.Id,null);
        return MRSObj;        
    }
    
     /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
     public static MRS_Layer_Chip_Association__c createMRSLCAData(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'Not Ready';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();  
        obj.Customer_MEBES_Jobview__c = 'Release';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        
        
        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'Not Ready';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';
        
        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        
        
        
        obj.Layer_Chip_Status__c = 'N.A.';
        
        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';
        
        
        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';
        
        
        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Not Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.028UM';
        obj.DRT__c = null;
        
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    
    
     /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData2
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
     public static MRS_Layer_Chip_Association__c createMRSLCAData2(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName2';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'N.A.';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();  
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        
        
        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';
        
        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        
        
        
        obj.Layer_Chip_Status__c = 'N.A.';
        
        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';
        
        
        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';
        
        
        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Not Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.008UM';
                obj.DRT__c = null;
                
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    
     /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData3
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
     public static MRS_Layer_Chip_Association__c createMRSLCAData3(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName2';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'N.A.';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();  
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        
        
        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'In Progress';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';
        
        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        
        
        
        obj.Layer_Chip_Status__c = 'N.A.';
        
        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';
        
        
        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';
        
        
        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.028UM';
        obj.Synced_with_Oracle_DB__c= true;
                obj.DRT__c = null;
                
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData3
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
     public static MRS_Layer_Chip_Association__c createMRSLCAData4(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName2';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'N.A.';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();  
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        
        
        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';
        
        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        
        
        
        obj.Layer_Chip_Status__c = 'N.A.';
        
        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';
        
        
        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';
        
        
        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = null;
        
                obj.DRT__c = null;
                
        //obj.Synced_with_Oracle_DB__c= true;
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
     
     

  public static testMethod void TestPTRFDetailExtn ()
  {         
          User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
          system.RunAs(sysAdminUser){
          test.startTest();
          PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
          Test.setCurrentPage(Page.VFPTRFDetail);
          ApexPages.currentPage().getParameters().put('ptrfURL',objPTRF.Id) ;
          ApexPages.currentPage().getHeaders().put('Host',System.Label.Internal_URL );
          
          PTRFDetailExtn objPTRFDetailExtn = new PTRFDetailExtn(new apexpages.StandardController(new PTRF__c()));
          Pagereference pgRef = objPTRFDetailExtn.redirectToPage();
          system.assertNotEquals(pgRef,null);
          system.assert(pgRef.getUrl().containsIgnorecase(objPTRF.Id));
      
          Test.setCurrentPage(Page.VFPTRFDetail);
          ApexPages.currentPage().getParameters().put('ptrfURL',objPTRF.Id) ;
          ApexPages.currentPage().getHeaders().put('Host',System.Label.Swift_Community_URL);
          
          objPTRFDetailExtn = new PTRFDetailExtn(new apexpages.StandardController(new PTRF__c()));
          pgRef = objPTRFDetailExtn.redirectToPage();
          system.assert(pgRef != null);
          system.assert(pgRef.getUrl().containsIgnorecase(objPTRF.Id));
      
          test.stopTest();
          }
  }
  
  public static testMethod void TestPTRFTrigger1 ()
  {
  
          
         test.startTest();
             
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             PTRF__c objPTRF2 = [Select Id, Name from PTRF__c where name='PTRF 000 1002'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.Status__c = 'Perform Tapeout Options';
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';
             
             
             objPTRF.Frame_Status__c = 'Completed';
             update objPTRF;

             objPTRF.DRC_Only__c = true;
             objPTRF.Prime_TapeOut__c = true;
             objPTRF.PTRF_DRC_Option__c = 'Foundry run and gating mask release';
             objPTRF.DRC_DRW_Status__c = 'Completed';
             objPTRF.DRW_Disposition__c = 'No violations';
             objPTRF.DRC_Rerun__c = true;
             
             update objPTRF;
             
             objPTRF.DRC_DRW_Status__c = 'Completed';
             
             objPTRF2.DRC_DRW_Status__c = 'DRW';
             
             objPTRF.Status__c = 'Cancel';
             objPTRF2.Status__c = 'Perform Tapeout Options';
             
             objPTRF.Prime_DRT__c = 'DRTPRIME01';
             objPTRF.Frame_DRT__c = 'DRTPRIME02';
             
             objPTRF2.Prime_DRT__c = 'DRTPRIME02';
             objPTRF2.Frame_DRT__c = 'DRTPRIME03';
             
             update objPTRF2;
             update objPTRF;
             
              objPTRF.Prime_DRT__c = '';
             objPTRF.Frame_DRT__c = '';
             
             objPTRF2.Prime_DRT__c = '';
             objPTRF2.Frame_DRT__c = '';
             
              update objPTRF2;
             update objPTRF;
             
             PTRF__c objPTRFForUpdate = [SELECT Id,DRC_DRW_Status__c FROM PTRF__c WHERE Id = :objPTRF.Id].get(0);
             objPTRFForUpdate.DRC_DRW_Status__c = 'Completed';
             objPTRFForUpdate.Status__c = 'Perform Tapeout Options';
             update objPTRFForUpdate;
      
          test.stopTest();

  }
  public static testMethod void TestPTRFTrigger2 ()
  {
  
          
         test.startTest();
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';
             objPTRF.Status__c=  'Closed';
             objPTRF.Frame_Status__c = 'Frame Generation';
             update objPTRF;
             
          test.stopTest();
         
         
  }  
  public static testMethod void TestPTRFTrigger3 ()
  {
  
          
         test.startTest();
             
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.Status__c = 'Perform Tapeout Options';
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';
             
             objPTRF.Frame_Status__c = 'Completed';
             update objPTRF;
             
             objPTRF.Status__c=  'Closed';
             objPTRF.Frame_Status__c = 'Frame Generation';
             update objPTRF;
          test.stopTest();
         
         
  }  

  public static testMethod void TestPTRFTrigger4 ()
  {
  
          
         test.startTest();
             
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.Status__c = 'Perform Tapeout Options';
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';

             
             objPTRF.Frame_Status__c = 'Completed';
             
             
             objPTRF.Status__c=  'Closed';
             objPTRF.Frame_Status__c = 'Frame Generation';

             objPTRF.DRC_Only__c = true;
             objPTRF.Prime_TapeOut__c = true;
             objPTRF.PTRF_DRC_Option__c = 'Foundry run and gating mask release';
             
             objPTRF.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.DRW_Disposition__c = 'No violations';
             
             objPTRF.DRC_Rerun__c = true;
             
             update objPTRF;
/*             
             objPTRF.DRC_DRW_Status__c = 'DRW';
             
             objPTRF2.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.Status__c = 'Cancel';
             objPTRF2.Status__c = 'Perform Tapeout Options';
             
             objPTRF.Prime_DRT__c = 'DRTPRIME01';
             objPTRF.Frame_DRT__c = 'DRTPRIME02';
             
             objPTRF2.Prime_DRT__c = 'DRTPRIME02';
             objPTRF2.Frame_DRT__c = 'DRTPRIME03';
             
             update objPTRF2;
             update objPTRF;
             
              objPTRF.Prime_DRT__c = '';
             objPTRF.Frame_DRT__c = '';
             
             objPTRF2.Prime_DRT__c = '';
             objPTRF2.Frame_DRT__c = '';
             
              update objPTRF2;
             update objPTRF;*/
                     
          test.stopTest();
         
         
  }  

  public static testMethod void TestPTRFTrigger5 ()
  {
  
          
         test.startTest();
             
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             PTRF__c objPTRF2 = [Select Id, Name from PTRF__c where name='PTRF 000 1002'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             DRT__c objDRT = [Select Id, Name from DRT__c where Name='TestDRT'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.Status__c = 'Perform Tapeout Options';
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';

             
             objPTRF.Frame_Status__c = 'Completed';
             
             
             objPTRF.Status__c=  'Closed';
             objPTRF.Frame_Status__c = 'Frame Generation';

             objPTRF.DRC_Only__c = true;
             objPTRF.Prime_TapeOut__c = true;
             objPTRF.PTRF_DRC_Option__c = 'Foundry run and gating mask release';
             
             objPTRF.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.DRW_Disposition__c = 'No violations';
             
             objPTRF.DRC_Rerun__c = true;
             
             
             
             objPTRF.DRC_DRW_Status__c = 'DRW';
             
             objPTRF2.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.Status__c = 'Cancel';
             objPTRF2.Status__c = 'Perform Tapeout Options';
             
             objPTRF.Prime_DRT__c = 'DRTPRIME01';
             objPTRF.Frame_DRT__c = 'DRTPRIME02';
             
             objPTRF2.Prime_DRT__c = objDRT.Name; //'DRTPRIME02';
             objPTRF2.Frame_DRT__c = objDRT.Name; //'DRTPRIME03';
             
             update objPTRF2;
             update objPTRF;

                     
          test.stopTest();
         
         
  }  

  public static testMethod void TestPTRFTrigger6 ()
  {
  
          
         test.startTest();
             
             PTRF__c objPTRF = [Select Id, Name from PTRF__c where name='PTRF 000 1001'];
             PTRF__c objPTRF2 = [Select Id, Name from PTRF__c where name='PTRF 000 1002'];
             PTRF__c objPTRF4 = [Select Id, Name from PTRF__c where name='PTRF 000 1004'];
             Mask_Set_Title__c objMST = [Select Id, Name from Mask_Set_Title__c where Name='MPW1001'];
             objPTRF.Prime_TapeOut__c = false;
             objPTRF.Frame_TapeOut__c = false;
             objPTRF.MaskSetTitle__c =  objMST.Id;
             objPTRF.Status__c = 'Perform Tapeout Options';
             objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';

             
             objPTRF.Frame_Status__c = 'Completed';
             
             
             objPTRF.Status__c=  'Closed';
             objPTRF.Frame_Status__c = 'Frame Generation';

             objPTRF.DRC_Only__c = true;
             objPTRF.Prime_TapeOut__c = true;
             objPTRF.PTRF_DRC_Option__c = 'Foundry run and gating mask release';
             
             objPTRF.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.DRW_Disposition__c = 'No violations';
             
             objPTRF.DRC_Rerun__c = true;
             
             
             
             objPTRF.DRC_DRW_Status__c = 'DRW';
             
             objPTRF2.DRC_DRW_Status__c = 'Completed';
             
             objPTRF4.DRC_DRW_Status__c = 'Completed';
             
             objPTRF.Status__c = 'Cancel';
             objPTRF2.Status__c = 'Perform Tapeout Options';
             
             objPTRF.Prime_DRT__c = 'DRTPRIME01';
             objPTRF.Frame_DRT__c = 'DRTPRIME02';
             
             objPTRF2.Prime_DRT__c = 'DRTPRIME02';
             objPTRF2.Frame_DRT__c = 'DRTPRIME03';
             

             
             objPTRF.Prime_DRT__c = '';
             objPTRF.Frame_DRT__c = '';
             
             objPTRF2.Prime_DRT__c = '';
             objPTRF2.Frame_DRT__c = '';
             
              update objPTRF2;
             update objPTRF;
                             update objPTRF4;
                                                  
          test.stopTest();
         
         
  } 
  
}