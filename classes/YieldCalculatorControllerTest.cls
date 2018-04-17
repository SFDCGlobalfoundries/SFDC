/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for YieldCalculatorController.
    History: 
        ZAmbat      12242014    - Code creation.
*/

@isTest(SeeAllData=true)
public class YieldCalculatorControllerTest {
    static Id createProcess() {
        Process__c p = new Process__c();
        p.Name = 'TestProcess1';
        p.NVALUE__c = 1;
        
        insert p;
        return p.Id;
    }
    
    static testMethod void testYieldCalculatorController1() {
        string processId = YieldCalculatorControllerTest.createProcess();
        test.startTest();
            YieldCalculatorController y = new YieldCalculatorController();
            y.clearProcessId();
            y.clearAll();
            y.npcForm.Process_ID__c = processId;
            y.retrieveProcessDetails();
            y.waferSize = '200';
            y.defectDensity = 1;
            y.dieSizeX = 1;
            y.dieSizeY = 1;
            y.dieSizeArea = 1;
            y.sramDensity = '<15%';
            y.getXValue();
            y.sramDensity = '15-<30%';
            y.getXValue();
            y.sramDensity = '30-<50%';
            y.getXValue();
            y.sramDensity = '>50%';
            y.getXValue();
            y.getYValue();
            y.getWaferSizeOptions();
            y.getSramDensityOptions();
            y.getEstimatedYield();
            y.getGrossDiesPerWafer();
            y.getNetDiesPerWafer();
        test.stopTest();
    }
}