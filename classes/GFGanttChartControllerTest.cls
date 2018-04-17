/*
    Author: Win
    Created Date: Feb/22/2013 
    Description: Test class for GFGanttChartController
    Test cases: 
    1. 
*/

@isTest
public class GFGanttChartControllerTest{

    static testMethod void doTest1(){
        test.startTest();
        GFGanttChartController chart = new GFGanttChartController();
        chart.getProjectLabel();
        chart.getActivityLabel();
        chart.getGanttProjects();
        chart.setProjectLabel('Test Label');
        chart.setActivityLabel('Test Activity Label');
        chart.getProjectLabel();
        chart.getActivityLabel();
        chart.getGanttProjects();
        
        test.stopTest();
    }
    
    static testMethod void doTestWithChartId(){
        test.startTest();
        GFGanttChartController chart = new GFGanttChartController();
        chart.Id = '1234';
        chart.getGanttProjects();
        test.stopTest();
    }
}