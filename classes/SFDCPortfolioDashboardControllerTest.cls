/*
    Author: Win
    Created Date: Feb/20/2013 
    Description: Test class for SFDCPortfolioDashboardController
    Test cases: 
    1. Create 3 SFDC projects with different "Overall_Status" status for Red, Green, Yellow each. 
    and make sure the incremantal count for each statuses are correct.
*/

@isTest
public class SFDCPortfolioDashboardControllerTest{

    static testMethod void doTest1(){
        test.startTest();
        ApexPages.StandardSetController controller = null;
        SFDCPortfolioDashboardController SFDCPortDbCtrl = new SFDCPortfolioDashboardController(controller);
        test.stopTest();

    }

    static testMethod void doTest(){
        Integer greenLocal = 0;
        Integer redLocal = 0;
        Integer yellowLocal = 0;
        
        test.startTest();
        
        SFDCPortfolioDashboardController SFDCPortDbCtrl = new SFDCPortfolioDashboardController();
        
        if(SFDCPortDbCtrl.greenCount != null){
            greenLocal = SFDCPortDbCtrl.greenCount;
        }
        if(SFDCPortDbCtrl.redCount != null){
            redLocal = SFDCPortDbCtrl.redCount;
        }
        if(SFDCPortDbCtrl.yellowCount != null){
            yellowLocal = SFDCPortDbCtrl.yellowCount;
        }
        //System.debug('\n greenCount = ' + SFDCPortDbCtrl.greenCount);
        //System.debug('\n redCount= ' + SFDCPortDbCtrl.redCount);
        //System.debug('\n yellowCount= ' + SFDCPortDbCtrl.yellowCount);
        
        //Initialize test data
        SFDC_Project__c sfPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert sfPro;
        System.assert(sfPro != null);
        SFDC_Project__c sfPro2 = new SFDC_Project__c(Name='Yellow',Overall_Status__c='Yellow',Priority_Sequence__c=0);
        insert sfPro2;
        System.assert(sfPro2 != null);
        SFDC_Project__c sfPro3 = new SFDC_Project__c(Name='Green',Overall_Status__c='Green',Priority_Sequence__c=0);
        insert sfPro3;
        System.assert(sfPro3 != null);
        
        SFDCPortDbCtrl.getProjects();
        
        System.assertEquals(SFDCPortDbCtrl.greenCount, greenLocal + 1);
        System.assertEquals(SFDCPortDbCtrl.redCount, redLocal + 1);
        System.assertEquals(SFDCPortDbCtrl.yellowCount, yellowLocal + 1);
        
        //System.debug('\n greenCount = ' + SFDCPortDbCtrl.greenCount);
        //System.debug('\n redCount= ' + SFDCPortDbCtrl.redCount);
        //System.debug('\n yellowCount= ' + SFDCPortDbCtrl.yellowCount);
        
        test.stopTest();

    }
}