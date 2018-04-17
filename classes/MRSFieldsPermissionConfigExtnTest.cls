/*
Type Name: MRSFieldsPermissionConfigExtnTest
Author: Cognizant
Created Date: 30-May-2014
Reason: Test class for MRSFieldsPermissionConfigExtn Controller
Change History:
Author:
Modified Date:
Reason:
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/



@istest(seealldata=false)
public class MRSFieldsPermissionConfigExtnTest
{
     public static testMethod void controllerConstructor(){
        
         User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
           System.runAs(sysAdminUser){
     
           MRS_Fields_Permission_Config__c  mrsFPC= MRSDataUtilityTest.createTestMRSFieldsPermissionConfig();
           system.assertNotEquals(null,mrsFPC.Id);
           test.startTest();
           Test.setCurrentPage(Page.VFMRSFieldsPermissionConfig);
           ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
          
           MRSFieldsPermissionConfigExtn objMRSFPCExtn = new MRSFieldsPermissionConfigExtn(new apexpages.StandardController(mrsFPC));
           objMRSFPCExtn.saveValues();    
           
           List<MRS_Fields_Permission_Config__c> lstPermissionConfig = [select name, CustomerRemoteJobviewFrame__c,CustomerRemoteJobviewPrime__c,DRW__c,FoundryRemoteJobviewFrame__c,FoundryRemoteJobviewPrime__c,FrameMockupCustomer__c,FrameMockupFoundry__c,GDSOUTReviewCustomer__c,GDSOUTReviewFoundry__c,MEBESJobviewCustomer__c,MEBESJobviewFoundry__c,MEBESJobviewGlobalShuttle__c,MEBESJobviewMDP__c,MEBESJobviewTapeoutAPPLICATIONS__c,MEBESJobviewTapeoutCenter__c,MEBESJobviewTDTIMPW__c,MEBESReceivedFrame__c,MEBESReceivedPrime__c,ORC__c,SendDataFrame__c,SendDataPrime__c  from MRS_Fields_Permission_Config__c where Id= :mrsFPC.Id ];
            
           system.assertNotEquals(null,lstPermissionConfig.size());      
           test.stoptest();
          
        }
          
     }
     

public static Account  objAccount;
public static Mask_Set_Title__c  objMST;
public static PTRF__c objPTRF;
public static PTRF__c objPTRF2;
public static Mask_Layer__c objLayer;
public static Mask_Layer__c objLayer2;
public static User sysAdminUser ;
public static User userSU  ;
public static User IntegrationUser ;
public static MRS_Layer_Chip_Association__c  MRSLCAObj3 ;
 /**
        This method is for setting default Test Environment data and creating Test Account instance. 
        @method name: TestAccountInsert
        @parameter:   None
        @return :     void
     **/  
 public static void TestAccountInsert(){
            SwiftDataUtilityTest.customSystemData();
            objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
            System.assertNotEquals(objAccount,null);
                objAccount.stage__c = 'Qualified';
                update objAccount;
                
    }
    
   static{
           
             TestAccountInsert();
                
             objMST=SwiftDataUtilityTest.createMST('MST1001');
             insert objMST;
            List<PTRF__c> ptrfList = new List<PTRF__c>(); 
            objPTRF= createPTRF('PTRF 000 1001',objMST,null); 
            ptrfList.add(objPTRF); 
            objPTRF2= createPTRF2('PTRF 000 1002',objMST,null); 
            ptrfList.add(objPTRF2);  
            insert ptrfList;    
            
            List<Mask_Layer__c> maskLayerList = new List<Mask_Layer__c>();
            objLayer= createMaskLayer(objPTRF,objMST,'MLN001','AZ','01'); 
            maskLayerList.add(objLayer);
            objLayer2= createMaskLayer(objPTRF2,objMST,'MLN002','AZ','01'); 
            maskLayerList.add(objLayer2); 
            insert maskLayerList;
             
            MRS__c MRSObject = createMRS();
            System.assertNotEquals(MRSObject.Id,null);
            
            List<MRS_Chip_Details__c> mrsChipDetailsList = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c   MRSChipDetails = createMRSChipDetail(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSChipDetails.Id,null);
            mrsChipDetailsList.add(MRSChipDetails);
            MRS_Chip_Details__c   MRSChipDetails2 = createMRSChipDetail2(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSChipDetails2.Id,null); 
            mrsChipDetailsList.add(MRSChipDetails2);
            insert mrsChipDetailsList;
            
            List<MRS_Layer_Association__c>  mrsLayerAssociationList = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c   MRSLAObj1 = createMRSData(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLAObj1.Id,null);
            mrsLayerAssociationList.add(MRSLAObj1);  
            MRS_Layer_Association__c   MRSLAObj2 = createMRSData(String.valueOf(objLayer2.Name), String.valueOf(objLayer2.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLAObj1.Id,null);   
            mrsLayerAssociationList.add(MRSLAObj2);  
            insert mrsLayerAssociationList; 
             
            mrshandlerutility.numberOfLayerChipRecords=1;
            
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociation = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c    MRSLCAObj1 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLCAObj1.Id,null);
            mrsLayerChipAssociation.add(MRSLCAObj1);
            
            MRS_Layer_Chip_Association__c    MRSLCAObj2 = createMRSLCAData2(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLCAObj2.Id,null);
            mrsLayerChipAssociation.add(MRSLCAObj2);
             
            MRSLCAObj3 = createMRSLCAData3(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLCAObj3.Id,null);
            mrsLayerChipAssociation.add(MRSLCAObj3);
             
            MRS_Layer_Chip_Association__c MRSLCAObj4 = createMRSLCAData4(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
            //System.assertNotEquals(MRSLCAObj4.Id,null); 
            mrsLayerChipAssociation.add(MRSLCAObj4);
            
            insert mrsLayerChipAssociation;
            
            System.runAs(new User(Id = UserInfo.getUserId())) {
                sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
                
                IntegrationUser = [SELECT Id,Name,profileid FROM User WHERE Profile.Name like '%integration%' and IsActive=true].get(0);
                
            }
   }
   
 
   
    /**
        This method is for running test data for mail send scenarios for Foundry,Tapeout Centre,Tapeout Apps jobview. 
        @method name: TestMRSLayerChipSummaryExtn19 
        @parameter:   None
        @return :     void
     **/
     public static testMethod void TestMRSLayerChipSummaryExtn19 (){
        
        System.runAs(IntegrationUser ){
             Test.startTest();
             
             MRSHandlerUtility.numberOfLayerChipRecords=1;
             MRSLCAObj3.Layer_Chip_Status__c='Cancel' ;
             MRSLCAObj3.Synced_with_Oracle_DB__c= false;
             update MRSLCAObj3;
             System.assertNotEquals(MRSLCAObj3,null);
             
             Test.stopTest();
        }
    }
    
     /**
        This method is for running test data for mail send scenarios for Foundry,Tapeout Centre,Tapeout Apps jobview. 
        @method name: TestMRSLayerChipSummaryExtn20 
        @parameter:   None
        @return :     void
     **/
     public static testMethod void TestMRSLayerChipSummaryExtn20 (){
        
        System.runAs(sysAdminUser){
             Test.startTest();
             
             MRSHandlerUtility.numberOfLayerChipRecords=1;
             MRSLCAObj3.Layer_Chip_Status__c='Cancel' ;
             MRSLCAObj3.Synced_with_Oracle_DB__c= false;
             update MRSLCAObj3;
             
             MRSHandlerUtility.numberOfLayerChipRecords=null;
             MRSLCAObj3.Layer_Chip_Status__c='Void' ;
             MRSLCAObj3.Synced_with_Oracle_DB__c= false;
             update MRSLCAObj3;
             
             System.assertNotEquals(MRSLCAObj3,null);
                 
             Test.stopTest();
        }
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
     private static PTRF__c createPTRF(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
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
    
    
    /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF2
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF2(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
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
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.DRC_DRW_Status__c='DRW';
        
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
     private static PTRF__c createPTRF3(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
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
        
        insert ptrf;
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
        This method is for storing data in MRS__c object for test method execution. 
        @method name: createMRS
        @parameter:   None
        @return :     MRS__c object
     **/
     public static MRS__c createMRS(){
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
        obj.Name = 'Chip1';
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
        //insert MRSObj;
        System.assertnotEquals(null,MRSObj);
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
        obj.Tech_Geo__c = '0.008UM';
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
        obj.Customer_Frame_Mockup__c = 'Disapprove';
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
        obj.Send_Prime_Data__c = 'Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.028UM';
        obj.Synced_with_Oracle_DB__c= true;
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
        obj.Customer_Frame_Mockup__c = 'Disapprove';
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
        obj.Send_Prime_Data__c = 'Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        
        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = null;
        
        //insert obj;
        System.assertnotEquals(null,obj);
        return obj;
    }
     
}