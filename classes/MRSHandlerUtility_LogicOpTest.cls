/*
    Author: Cognizant
    Description: Apex test class for MRSHandlerUtility_For_LogicalOperation
    History: 
    Saurav      22/05/2014    - Apex code created
    
*/
@istest(SeeAllData=false)
public class MRSHandlerUtility_LogicOpTest {
    public static Account accountObj;
    /**
        @Method Name: TestMRSHandlerUtilityAccountInsert
        @Return type: null
        @Parameters: null
        @Description: creates account for test class
    **/
    public static  void TestMRSHandlerUtilityAccountInsert(){
                SwiftDataUtilityTest.customSystemData();
                accountObj = SwiftDataUtilityTest.createTestAccountForDRT();
                
                System.assertNotEquals(accountObj,null);
                accountObj.stage__c = 'Qualified';
                update accountObj;
                
    }
    static{
        TestMRSHandlerUtilityAccountInsert();
    }
    
    
    /**
        @Method Name: updateLogicOpTest
        @Return type: null
        @Parameters: null
        @Description: 
    **/
    public static testMethod void updateLogicOpTest(){
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Test.startTest();
            
            Mask_Set_Title__c mstObj = SwiftDataUtilityTest.createMST('NEWMST');
            insert mstObj;
            
            PTRF__c PTRFobj = new PTRF__c();
            PTRFobj.Name = 'PTRF 1';
            PTRFobj.Order_Type__c = 'Test Order Type';
            PTRFobj.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj.MaskSetTitle__c = mstObj.Id;
            PTRFobj.tech_Geo_Value__c = '0.019UM';
            PTRFobj.Status__c = 'Perform Tapeout Options';
            insert PTRFobj;
            
            PTRF__c PTRFobj1 = new PTRF__c();
            PTRFobj1.Name = 'PTRF 2';
            PTRFobj1.Order_Type__c = 'Test Order Type';
            PTRFobj1.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj1.MaskSetTitle__c = mstObj.Id;
            PTRFobj1.tech_Geo_Value__c = '0.019UM';
            PTRFobj1.Status__c = 'Perform Tapeout Options';
            insert PTRFobj1;
            
            Mask_Layer__c mlObj = new Mask_Layer__c (Name = 'RX',Mask_Layer_Number__c = 'RX',Mask_Layer_Rev__c='AZ',Mask_Set_Title__c = mstObj.Id,
                                                    PTRF__c = PTRFobj.Id,Tapeout__c = True,LogicalOperationType__c='TECN',LogicalOperation__c='TECN-001',Rom_Code__c='123');
            insert mlObj;
            
            Mask_Layer__c mlObj1 = new Mask_Layer__c (Name = 'RX',Mask_Layer_Number__c = 'RX',Mask_Layer_Rev__c='AZ',Mask_Set_Title__c = mstObj.Id,
                                                    PTRF__c = PTRFobj1.Id,Tapeout__c = True,LogicalOperationType__c='TECN',LogicalOperation__c='TECN-002',Rom_Code__c='123');
            insert mlObj1;
            
            Mask_Layer__c mlObj2 = new Mask_Layer__c (Name = 'RX',Mask_Layer_Number__c = 'RY',Mask_Layer_Rev__c='AZ',Mask_Set_Title__c = mstObj.Id,
                                                    PTRF__c = PTRFobj.Id,Tapeout__c = True,LogicalOperationType__c='TECN',LogicalOperation__c='TECN-001');
            insert mlObj2;
            
            Mask_Layer__c mlObj3 = new Mask_Layer__c (Name = 'RX',Mask_Layer_Number__c = 'RY',Mask_Layer_Rev__c='AZ',Mask_Set_Title__c = mstObj.Id,
                                                    PTRF__c = PTRFobj1.Id,Tapeout__c = True,LogicalOperationType__c='TECN',LogicalOperation__c='TECN-002');
            insert mlObj3;            
            
            MRS__c mrs = new MRS__c(Mask_Set_Title__c = mstObj.Id);
            insert mrs;
            
            String sLayerUnique=mstObj.id + mlObj.Mask_Layer_Number__c + mlObj.Mask_Layer_Rev__c + mlObj.Rom_Code__c + PTRFobj1.tech_Geo_Value__c;
            
            MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name = 'RX',MRS__c = mrs.Id,Layer_Name__c = 'RX',Mask_Layer_Rev__c='AZ',
                                                                            Layer_Unique_Identifier__c=sLayerUnique,Tech_Geo__c='0.019UM',ROM_Code__c = '123');
            insert mrsLayer;
            
            sLayerUnique=mstObj.id + mlObj3.Mask_Layer_Number__c + mlObj3.Mask_Layer_Rev__c + PTRFobj1.tech_Geo_Value__c;
            
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name = 'RY',MRS__c = mrs.Id,Layer_Name__c = 'RY',Mask_Layer_Rev__c='AZ',
                                                                            Layer_Unique_Identifier__c=sLayerUnique,Tech_Geo__c='0.019UM');
            insert mrsLayer1;
            
            MRS_Chip_Details__c mrsCD=MRSDataUtilityTest.createTestMRSChipDetails(mrs.Id);
            List<MRS_Chip_Details__c> lstMCD = [select name from MRS_Chip_Details__c limit  1];
            
            MRS_Chip_Details__c mrsCD1=MRSDataUtilityTest.createTestMRSChipDetails(mrs.Id);
            List<MRS_Chip_Details__c> lstMCD1 = [select name from MRS_Chip_Details__c limit  1];
            
            MRS_Layer_Chip_Association__c objmlca = new MRS_Layer_Chip_Association__c();
            objmlca.Customer_Name__c = accountObj.Id;
            objmlca.PTRF__c = PTRFobj.Id;
            objmlca.Layer__c = mrsLayer.Id;
            objmlca.Chip__c = lstMCD.get(0).Id;
            
            insert objmlca;
            
            MRS_Layer_Chip_Association__c objmlca1 = new MRS_Layer_Chip_Association__c();
            objmlca1.Customer_Name__c = accountObj.Id;
            objmlca1.PTRF__c = PTRFobj1.Id;
            objmlca1.Layer__c = mrsLayer.Id;
            objmlca1.Chip__c = lstMCD1.get(0).Id;
            
            insert objmlca1;
            
            MRS_Layer_Chip_Association__c objmlca2 = new MRS_Layer_Chip_Association__c();
            objmlca2.Customer_Name__c = accountObj.Id;
            objmlca2.PTRF__c = PTRFobj.Id;
            objmlca2.Layer__c = mrsLayer1.Id;
            objmlca2.Chip__c = lstMCD.get(0).Id;
            
            insert objmlca2;
            
            MRS_Layer_Chip_Association__c objmlca3 = new MRS_Layer_Chip_Association__c();
            objmlca3.Customer_Name__c = accountObj.Id;
            objmlca3.PTRF__c = PTRFobj1.Id;
            objmlca3.Layer__c = mrsLayer.Id;
            objmlca3.Chip__c = lstMCD1.get(0).Id;
            
            insert objmlca3;            
            
            PTRFobj.Status__c = 'Cancel';
            update PTRFobj;
            
            Test.stopTest();
        }
    }
}