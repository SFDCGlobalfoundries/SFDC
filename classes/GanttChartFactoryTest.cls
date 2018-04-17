@isTest
public class GanttChartFactoryTest{

    static testMethod void doTestApexObjectFactory(){
        test.startTest();

        GanttChartFactory.newInstance('SFDCPortfolioGanttProjectProvider');
        GanttChartFactory.newInstance('SFDCProjectGanttProjectProvider');
        GanttChartFactory.newInstance('SFDCProjectStageGanttProjectProvider');
        GanttChartFactory.newInstance('xyz');

        test.stopTest();

    }
}