/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This test class is for code coverage for ClsCpkAssociateCustomerView
  History:
  ASPattanaik 09112016 - Class Creation.
--------------------------------------------------------------*/
@isTest
public class ClsCpkAssociateCustomerViewTest {
    
    public static testmethod void myTestMethod(){
       Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        FAB__c fab = ClsNewCPKReportTest.createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null);
        cpkReport.Stage__c = 'Draft';
        insert cpkReport;
        Apexpages.currentPage().getParameters().put('Id', cpkReport.Id);
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(cpkReport);
        ClsCpkAssociateCustomerView clscpk = new ClsCpkAssociateCustomerView(stdCntrl); 
    }
}