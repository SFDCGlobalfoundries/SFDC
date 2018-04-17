/*
	@Author :- Abhita Bansal
*/
@isTest
private class WaiverCollaboratorAutoEmailSchedulerTest {

    static testMethod void myAutoEmailSchMethod() {
        
        String sch = '20 30 8 10 2 ?';
        
        Test.startTest();
        
        WaiverCollaboratorAutoEmailScheduler m = new WaiverCollaboratorAutoEmailScheduler();
        String jobID = system.schedule('Email Job', sch, m);
        
        Test.stopTest();      
    }
}