/*
    Author: Win
    Created Date: Feb/25/2013 
    Description: Test class for GFGanttController
    Test cases: 
    1. 
*/

@isTest
public class GFGanttControllerTest{

    static testMethod void doTest1(){
        test.startTest();
        GFGanttController controller = new GFGanttController();
        controller.getGanttProjects();
        
        test.stopTest();

    }
}