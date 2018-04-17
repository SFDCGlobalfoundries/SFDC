/*
    Author: Anirban Roy
    Description: This is the test class for CPQReportBackupController.
    History: 
        ARoy     05062015    - Code creation.
*/

@istest(SeeAllData=false)
public class CPQReportBackupControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    // Test method for CPQ Reports
    static testMethod void CPQReportTest(){
        //testdata();
        CPQ_MLGPLUS__c cpqmlgplus = new CPQ_MLGPLUS__c(Catalog_Type__c = 'First Source', Geometry__c = '0.010UM', Status__c = 'Unprocessed');
        insert cpqmlgplus;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cpqmlgplus);
        CPQReportBackupController cpqReportBackup = new CPQReportBackupController(sc);
        
        PageReference pageRef = Page.CPQReportBackup;
        pageRef.getParameters().put('id', String.valueOf(cpqmlgplus.Id));
        Test.setCurrentPage(pageRef);
    }
}