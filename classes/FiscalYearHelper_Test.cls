/*
    Author: Zymark Ambat
    Description: This serves as the test class for the FiscalYearHelper Class.
    History: 
        ZAmbat      02272013    - Code creation.
        ARoy        09112013    - Removed the additional lines of codes not required after fiscal year conversion to follow Gregorian calendar.
*/
@isTest(SeeAllData=true)
public class FiscalYearHelper_Test {
    static testMethod void runTest() {
        test.startTest();
        
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2009, 12, 27));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2010, 3, 28));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2010, 6, 27));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2010, 9, 26));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2010, 12, 26));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2011, 4, 3));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2011, 7, 3));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2011, 10, 2));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 1, 1));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 4, 1));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 7, 1));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 9, 30));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 4, 1));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2012, 12, 30));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2013, 3, 31));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2013, 6, 30));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2013, 9, 29));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2013, 12, 29));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2014, 3, 30));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2014, 6, 29));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2014, 9, 28));
        FiscalYearHelper.getFiscalQuarter(Date.newInstance(2014, 12, 28));
        
        test.stopTest();
    }
}