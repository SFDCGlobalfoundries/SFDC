@istest(SeeAllData=false)
public without sharing class MRSDataUtilityTest
{
    public static MRS__c createTestMRS(Id strMST){
                
        MRS__c mrs= new MRS__c(
            Mask_Set_Title__c= strMST
           
        );
            
        insert mrs; 
        return mrs;
    }  
     
    public static MRS_Layer_Association__c createTestMRSLayerAssociation(Id mrsId){
                
        MRS_Layer_Association__c mrs= new MRS_Layer_Association__c();
            mrs.MRS__c= mrsId;
            mrs.name='Layer1';
            mrs.Layer_Status__c='In Progress';
        insert mrs; 
        return mrs;
    } 
     public static MRS_Layer_Association__c createTestMRSLayerAssociationFrame(Id mrsId){
                
        MRS_Layer_Association__c mrs= new MRS_Layer_Association__c();
            mrs.MRS__c= mrsId;
            mrs.name='MLN001';
            mrs.Layer_Status__c='In Progress';
        insert mrs; 
        return mrs;
    } 
    public static MRS_Chip_Details__c createTestMRSChipDetails(Id mrsId){
                
        MRS_Chip_Details__c mrs= new MRS_Chip_Details__c();
          mrs.MRS__c= mrsId;
           mrs.name='Chip1';
    
        insert mrs; 
        return mrs;
    }   
    public static MRS_Layer_Chip_Association__c createTestMRSLayerChipAssociation(Id layerId,Id chipId, Id PTRFId){
                
        MRS_Layer_Chip_Association__c mrs= new MRS_Layer_Chip_Association__c();
            mrs.name='MLCA1';
            mrs.Layer__c=layerId;
            mrs.Chip__c=chipId;
            mrs.PTRF__c=PTRFId;
            mrs.Device_Id__c='Device1';
            mrs.Customer_GDSOUT_Review__c = 'N.A.';
            mrs.Foundry_GDSOUT_Review__c = 'N.A.';
            mrs.Foundry_GDSOUT_Review__c = 'Not Ready';
            mrs.Send_Frame_Data__c = 'Not Done'; 
            mrs.Send_Prime_Data_Date__c = DateTime.now();
            mrs.Send_Frame_Data_Date__c = DateTime.now(); 
            mrs.PTRF_Or_DRT__c='PTRF'; 
            mrs.Layer_Chip_Status__c='In Progress';
        
            
        insert mrs; 
        return mrs;
    }
     public static MRS_Layer_Chip_Association__c createTestMRSLayerChipAssociationFrame(Id layerId,Id chipId, Id PTRFId){
                
        MRS_Layer_Chip_Association__c mrs= new MRS_Layer_Chip_Association__c();
            mrs.name='MLCA1';
            mrs.Layer__c=layerId;
            mrs.Chip__c=chipId;
            mrs.PTRF__c=PTRFId;
            mrs.Device_Id__c='Device1';
            mrs.Customer_GDSOUT_Review__c = 'N.A.';
            mrs.Foundry_GDSOUT_Review__c = 'N.A.';
            mrs.Foundry_GDSOUT_Review__c = 'Not Ready';
            mrs.Send_Frame_Data__c = 'Not Done'; 
            mrs.Send_Prime_Data_Date__c = DateTime.now();
            mrs.Send_Frame_Data_Date__c = DateTime.now();  
        
            
        insert mrs; 
        return mrs;
    } 
    
    public static MRS_Fields_Permission_Config__c createTestMRSFieldsPermissionConfig()
    {
        MRS_Fields_Permission_Config__c  objMRSFieldsPermConfig = new MRS_Fields_Permission_Config__c();
        objMRSFieldsPermConfig.name= 'TestMRSPermconfig';   
        objMRSFieldsPermConfig.CustomerRemoteJobviewFrame__c = false;
        objMRSFieldsPermConfig.CustomerRemoteJobviewPrime__c= false;
        objMRSFieldsPermConfig.DRW__c= false;
        objMRSFieldsPermConfig.FoundryRemoteJobviewFrame__c= false;
        objMRSFieldsPermConfig.FoundryRemoteJobviewPrime__c= false;
        objMRSFieldsPermConfig.FrameMockupCustomer__c= false;
        objMRSFieldsPermConfig.FrameMockupFoundry__c= false;
        objMRSFieldsPermConfig.GDSOUTReviewCustomer__c= false;
        objMRSFieldsPermConfig.GDSOUTReviewFoundry__c= false;
        objMRSFieldsPermConfig.MEBESJobviewCustomer__c= false;
        objMRSFieldsPermConfig.MEBESJobviewFoundry__c= false;
        objMRSFieldsPermConfig.MEBESJobviewGlobalShuttle__c= false;
        objMRSFieldsPermConfig.MEBESJobviewMDP__c= false;
        objMRSFieldsPermConfig.MEBESJobviewTapeoutAPPLICATIONS__c= false;
        objMRSFieldsPermConfig.MEBESJobviewTapeoutCenter__c= false;
        objMRSFieldsPermConfig.MEBESJobviewTDTIMPW__c= false;
        objMRSFieldsPermConfig.MEBESReceivedFrame__c= false;
        objMRSFieldsPermConfig.MEBESReceivedPrime__c= false;
        objMRSFieldsPermConfig.ORC__c = false;
        objMRSFieldsPermConfig.SendDataFrame__c= false;
        objMRSFieldsPermConfig.SendDataPrime__c= false;
        
        insert objMRSFieldsPermConfig ;
        return objMRSFieldsPermConfig ;
        
    }
    
     public static MRS_Layer_Chip_Association__c  createTestMRSLayerChipHistory()
     {
         MRS_Layer_Chip_Association__c   objMLCA= new MRS_Layer_Chip_Association__c();
         objMLCA.Chip_Hold_Warning__c='';
         objMLCA.Customer_Frame_Mockup__c= '';
         objMLCA.Foundry_Frame_Mockup__c=''; 
         objMLCA.Layer_Chip_Status__c= '';
         objMLCA.Send_Prime_Data__c= '';
         objMLCA.Synced_with_Oracle_DB__c= true;
         objMLCA.Layer__c = 'a7rN000000001GsIAI';
         objMLCA.Chip__c = 'a7qN00000008OJNIA2';
         insert objMLCA;
         return objMLCA;  
            
     }
     
     public static MRS_Layer_Association__c  createTestMRSLayerHistory()
     {
         MRS_Layer_Association__c   objMLA= new MRS_Layer_Association__c();
         objMLA.Customer_GDSOUT_Review__c='';
         objMLA.Frame_MEBES_Received__c= '';
         objMLA.Frame_MEBES_Received_Date__c= datetime.now(); 
         objMLA.Hold_Warning__c= '';
         objMLA.Synced_with_Oracle_DB__c= true;
         objMLA.MRS__c= 'a7pN0000000CbJVIA0';
         insert objMLA;
         return objMLA;  
            
     }
     
    public static Mask_Set_Title__c createMST()
    {
        Mask_Set_Title__c  objMST = SwiftDataUtilityTest.createMST('TESTMST');
        insert objMST ;
        return objMST ;
    }
     
    public static User createUser()
    {
        User objUser = new User();
       
        objUser.Email = 'test@test.com'; 
        objUser.isactive = true;
       
        insert objUser ;
        return objUser ;
        
        
        
    } 
     
     
}