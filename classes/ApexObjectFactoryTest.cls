/*
    Author: Yash Kumar
    Description: Test class for ApexObjectFactory
    Created Date:15022013 
*/

@isTest
public class ApexObjectFactoryTest{

    static testMethod void doTestApexObjectFactory(){
        test.startTest();
        ApexObjectFactory.newInstance('TeamRoomGFCalActivityProvider');
        ApexObjectFactory.newInstance('SFDCPortfolioGanttProjectProvider');
        ApexObjectFactory.newInstance('SFDCProjectGanttProjectProvider');
        ApexObjectFactory.newInstance('SFDCProjectStageGanttProjectProvider');
        ApexObjectFactory.newInstance('xyz');

        test.stopTest();

    }
}