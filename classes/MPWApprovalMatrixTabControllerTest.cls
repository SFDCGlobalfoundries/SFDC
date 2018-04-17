/*
    Author: Abhita Bansal
    Created Date: 21/08/2015 
    Description: Test class for MPWApprovalMatrixTabController
*/
@isTest
public class MPWApprovalMatrixTabControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
     public static testMethod void myApprovalMatrixTabMethod() {
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
    
        MPW_Approval_Matrix__c mpwAppMatrix = new MPW_Approval_Matrix__c();
        mpwAppMatrix.Category__c = 'FAB';
        mpwAppMatrix.Fab__c = 'Fab7';
        mpwAppMatrix.Geometry__c = '40nm';
        mpwAppMatrix.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwAppMatrix.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwAppMatrix.Step_1_Approver_3__c = userAppMatrix[2].Id;
        
        insert mpwAppMatrix;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWApprovalMatrixTabVF'));
        System.currentPageReference().getParameters().put('sortField','Geometry__c');
        
        MPWApprovalMatrixTabController appMatrixClass = new MPWApprovalMatrixTabController();
        appMatrixClass.addNew();
        appMatrixClass.sortRecords();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        appMatrixClass.getMPWApprovalMatrixRecords();
        
        Test.stopTest() ;  
    }
}