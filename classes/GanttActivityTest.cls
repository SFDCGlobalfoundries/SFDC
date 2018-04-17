/*
    Author: Win
    Created Date: Feb/22/2013 
    Description: Test class for GanttActivity
    Test cases: 
    1. 
*/

@isTest
public class GanttActivityTest{

    static testMethod void doTest1(){
        test.startTest();
        GanttActivity ga = new GanttActivity();
        GanttActivityTask gat = new GanttActivityTask();
        ga.addTask(gat);
        ga.getTasks();
        ga.isEmpty();
        List<GanttActivityTask> gatList = new List<GanttActivityTask>();
        GanttActivityTask gat1 = new GanttActivityTask();
        GanttActivityTask gat2 = new GanttActivityTask();
        gatList.add(gat1);
        gatList.add(gat2);
        ga.setTasks(gatList);
        test.stopTest();

    }
}