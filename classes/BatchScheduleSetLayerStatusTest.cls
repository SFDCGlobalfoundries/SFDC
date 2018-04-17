/*
Type Name: BatchScheduleSetLayerStatusTest
Author: Cognizant 
Created Date: 4-Feb-2015
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
public class BatchScheduleSetLayerStatusTest{

    public static List<MRS_Layer_Association__c> layerSummary;
    public static Account  objAccount;
    public static Mask_Set_Title__c  objMST;
    public static PTRF__c objPTRF;
    public static PTRF__c objPTRF2;
    public static User sysAdminUser ;
    public static User userSU  ;
    public static User userSUFE ;
    public static MRS_Layer_Chip_Association__c MRSLCAObj3 ;

    public static void TestAccountInsert(){
        SwiftDataUtilityTest.customSystemData();
        objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(objAccount,null);
        objAccount.stage__c = 'Qualified';
        update objAccount;
    }
    
    static{
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        TestAccountInsert();
        objMST=SwiftDataUtilityTest.createMST('MST1001');
        insert objMST;
        objPTRF= createPTRF('PTRF 000 1001',objMST,null); 
        Mask_Layer__c objLayer= createMaskLayer(objPTRF,objMST,'MLN001','AZ','01'); 
        MRS__c MRSObject = createMRS();
        System.assertNotEquals(MRSObject.Id,null);
        MRS_Chip_Details__c   MRSChipDetails = createMRSChipDetail(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
        System.assertNotEquals(MRSChipDetails.Id,null);
        MRS_Layer_Association__c   MRSLAObj1 = createMRSData(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        System.assertNotEquals(MRSLAObj1.Id,null);
        MRS_Layer_Chip_Association__c    MRSLCAObj1 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
        System.assertNotEquals(MRSLCAObj1.Id,null);
        MRSLAObj1.Customer_Frame_Mockup__c = 'Not Ready';
        update MRSLAObj1;
    }
    
    
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
        MRSObj.GlobalShuttle_MEBES_Jobview__c = 'Released';
        MRSObj.Hold_Warning__c = '';
        MRSObj.Layer_Name__c = LayerName;
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
        MRSObj.Tech_Geo__c = '0.028UM';
        insert MRSObj;
        System.assertnotEquals(null,MRSObj);
        return MRSObj;
    }
    
    
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
        obj.Tech_Geo__c = '0.028UM';
        obj.PTRF_Or_DRT__c= 'PTRF';
        insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
    public static MRS_Chip_Details__c createMRSChipDetail(String MaskSetTitleName,String MRSId){
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'TestChip';
        insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
    
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
        insert maskLayer;
        System.assertnotEquals(null,maskLayer );
        return maskLayer;
    }
    
    
    private static PTRF__c createPTRF(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
        PTRF__c ptrf = new PTRF__c();
        ptrf.Status__c = 'Active';
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
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.customer_jobview__c= 'Gating mask release';
        ptrf.foundry_Jobview__c= 'Gating mask release';
        ptrf.Customer__c=objAccount.id;
        insert ptrf;
        System.assertnotEquals(null,ptrf);
        return ptrf;
    } 
    
    
    public static MRS__c createMRS(){
        MRS__c obj = new MRS__c();
        obj.Associated_PTRF__c = objPTRF.Id;
        obj.Mask_Set_Title__c = objMST.Id;
        obj.MRS_Package_Sync__c = false;
        insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }

    static testMethod void TestSchedule(){
        System.runAs(sysAdminUser){
            Test.startTest();
            BatchScheduleSetLayerStatus   objBatch = new BatchScheduleSetLayerStatus();
            objBatch.bodyLayerNames='This is test data';
            ID batchprocessid = Database.executeBatch(objBatch );
            Test.stopTest();
        }
    }
    
    static testMethod void TestSchedule1(){
        System.runAs(sysAdminUser){
            Test.startTest();
            mrs__c mrs = [select id,Associated_PTRF__c,Mask_Set_Title__c,MRS_Package_Sync__c from mrs__c limit 1];
            BatchScheduleSetLayerStatus   objBatch = new BatchScheduleSetLayerStatus(new set<Id>{mrs.id} );
            objBatch.bodyLayerNames='This is test data';
            ID batchprocessid = Database.executeBatch(objBatch );
            Test.stopTest();
        }
    }
    


}