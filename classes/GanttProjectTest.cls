/*
    Author: Win
    Created Date: Feb/22/2013 
    Description: Test class for GanttProject
    Test cases: 
    1. 
*/

@isTest
public class GanttProjectTest{

    static testMethod void doTest1(){
        test.startTest();
        GanttProject gp = new GanttProject();
        gp.name = 'baker';
        GanttActivity ga = new GanttActivity();
        GanttActivityTask gat = new GanttActivityTask();
        ga.addTask(gat);
        
        gp.addActivity(ga);
        gp.getActivities();
        gp.isEmpty();
        gp.removeEmptyActivities();
        
        List<GanttActivity> gaList = new List<GanttActivity>();
        GanttActivity ga1 = new GanttActivity();
        GanttActivityTask gat1 = new GanttActivityTask();
        ga1.addTask(gat1);
        gaList.add(ga1);
        gp.setActivities(gaList);
        
        GanttProject gp2 = new GanttProject();
        gp2.name = 'baker';
        GanttActivity ga2 = new GanttActivity();
        GanttActivityTask gat2 = new GanttActivityTask();
        ga2.addTask(gat2);
        gp2.addActivity(ga2);
        gp.compareTo(gp2);
        gp2.name = 'alpha';
        gp.compareTo(gp2);
        gp2.name = 'charlie';
        gp.compareTo(gp2);
        
        test.stopTest();

    }
}