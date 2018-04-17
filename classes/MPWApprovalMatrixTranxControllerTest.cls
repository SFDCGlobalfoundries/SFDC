/*
    Author: Abhita Bansal
    Created Date: 21/08/2015 
    Description: Test class for MPWApprovalMatrixTranxController
*/
@isTest
public class MPWApprovalMatrixTranxControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myApprovalMatrixTranxMethod() {
       
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '40nm';
        mpwGeoMap.Geometry_ID__c = '0.040UM';
        
        insert mpwGeoMap;
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'FAB';
        mpwAppMatrix.Fab__c = 'Fab7';
        mpwAppMatrix.Geometry__c = '40nm';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwAppMatrix.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWApprovalMatrixTranxController appMatrixClass = new MPWApprovalMatrixTranxController(new ApexPages.Standardcontroller(new MPW_Approval_Matrix__c()));
        appMatrixClass.getFab();
        appMatrixClass.getGeometry();
        appMatrixClass.getCategory();
        appMatrixClass.getsubCategory();
        appMatrixClass.getEditCategory();
        appMatrixClass.getEditApprover1();
        appMatrixClass.getEditApprover2();
        appMatrixClass.getEditSubCategory();
        appMatrixClass.getEditFab();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditApprover3();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.save();
        
        Test.stopTest() ; 
    } 

    public static testMethod void myApprovalMatrixTranxMethod1() {
       
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '40nm';
        mpwGeoMap.Geometry_ID__c = '0.040UM';
        
        insert mpwGeoMap;
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'ASIC R&D';
        mpwAppMatrix.Sub_Category__c = 'FX-7';
        mpwAppMatrix.PA_Code__c = '701012';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        MPW_Keyword_Config__c mpwKeyConfig = new MPW_Keyword_Config__c();
        mpwKeyConfig.Sequence_No__c = 1;
        mpwKeyConfig.Type__c = 'ASIC_R&DSubCategory';
        mpwKeyConfig.Active__c = true;
        mpwKeyConfig.Value__c = 'FX-7';
        insert mpwKeyConfig;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwAppMatrix.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWApprovalMatrixTranxController appMatrixClass = new MPWApprovalMatrixTranxController(new ApexPages.Standardcontroller(new MPW_Approval_Matrix__c()));
        appMatrixClass.getFab();
        appMatrixClass.getGeometry();
        appMatrixClass.getCategory();
        appMatrixClass.getsubCategory();
        appMatrixClass.getEditCategory();
        appMatrixClass.getEditApprover1();
        appMatrixClass.getEditApprover2();
        appMatrixClass.getEditSubCategory();
        appMatrixClass.getEditFab();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditApprover3();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.save();
        
        Test.stopTest() ; 
    }
    
    public static testMethod void myApprovalMatrixTranxMethod2() {
       
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '40nm';
        mpwGeoMap.Geometry_ID__c = '0.040UM';
        
        insert mpwGeoMap;
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'RF_ASIC_A&D Protos';
        mpwAppMatrix.Sub_Category__c = 'RF';
        mpwAppMatrix.PA_Code__c = '101013';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        MPW_Keyword_Config__c mpwKeyConfig = new MPW_Keyword_Config__c();
        mpwKeyConfig.Sequence_No__c = 1;
        mpwKeyConfig.Type__c = 'RF_ASIC_A&D_ProtosSubCategory';
        mpwKeyConfig.Active__c = true;
        mpwKeyConfig.Value__c = 'RF';
        insert mpwKeyConfig;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwAppMatrix.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWApprovalMatrixTranxController appMatrixClass = new MPWApprovalMatrixTranxController(new ApexPages.Standardcontroller(new MPW_Approval_Matrix__c()));
        appMatrixClass.getFab();
        appMatrixClass.getGeometry();
        appMatrixClass.getCategory();
        appMatrixClass.getsubCategory();
        appMatrixClass.getEditCategory();
        appMatrixClass.getEditApprover1();
        appMatrixClass.getEditApprover2();
        appMatrixClass.getEditSubCategory();
        appMatrixClass.getEditFab();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditApprover3();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.save();
                
        Test.stopTest() ; 
    }
    
    public static testMethod void myApprovalMatrixTranxMethod3() {
       
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '40nm';
        mpwGeoMap.Geometry_ID__c = '0.040UM';
        
        insert mpwGeoMap;
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'IP';
        mpwAppMatrix.Sub_Category__c = 'Owned';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        MPW_Keyword_Config__c mpwKeyConfig = new MPW_Keyword_Config__c();
        mpwKeyConfig.Sequence_No__c = 1;
        mpwKeyConfig.Type__c = 'IPSubCategory';
        mpwKeyConfig.Active__c = true;
        mpwKeyConfig.Value__c = 'Owned';
        insert mpwKeyConfig;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwAppMatrix.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWApprovalMatrixTranxController appMatrixClass = new MPWApprovalMatrixTranxController(new ApexPages.Standardcontroller(new MPW_Approval_Matrix__c()));
        appMatrixClass.getFab();
        appMatrixClass.getGeometry();
        appMatrixClass.getCategory();
        appMatrixClass.getsubCategory();
        appMatrixClass.getEditCategory();
        appMatrixClass.getEditApprover1();
        appMatrixClass.getEditApprover2();
        appMatrixClass.getEditSubCategory();
        appMatrixClass.getEditFab();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditApprover3();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.save();
                
        Test.stopTest() ; 
    }
    
    public static testMethod void myApprovalMatrixTranxMethod4() {
       
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '40nm';
        mpwGeoMap.Geometry_ID__c = '0.040UM';
        
        insert mpwGeoMap;
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'DE';
        mpwAppMatrix.Sub_Category__c = 'DFM';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        MPW_Keyword_Config__c mpwKeyConfig = new MPW_Keyword_Config__c();
        mpwKeyConfig.Sequence_No__c = 1;
        mpwKeyConfig.Type__c = 'DESubCategory';
        mpwKeyConfig.Active__c = true;
        mpwKeyConfig.Value__c = 'DFM';
        insert mpwKeyConfig;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwAppMatrix.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWApprovalMatrixTranxController appMatrixClass = new MPWApprovalMatrixTranxController(new ApexPages.Standardcontroller(new MPW_Approval_Matrix__c()));
        appMatrixClass.getFab();
        appMatrixClass.getGeometry();
        appMatrixClass.getCategory();
        appMatrixClass.getsubCategory();
        appMatrixClass.getEditCategory();
        appMatrixClass.getEditApprover1();
        appMatrixClass.getEditApprover2();
        appMatrixClass.getEditSubCategory();
        appMatrixClass.getEditFab();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditApprover3();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.save();
                
        Test.stopTest() ; 
    }
}