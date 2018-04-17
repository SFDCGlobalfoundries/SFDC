/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestRollUpEffortTrigger {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Scrum_Team__c scrum = New Scrum_Team__c();
        scrum.Name = 'Test';
        insert scrum;
        
        Sprint__c s = New Sprint__c();
        s.name = 'Test';
        s.Scrum_Team__c = scrum.Id;
        s.Start_Date__c = date.newInstance(2013,2,1) ;
        insert s;
        
        system.assertEquals(s.Total_Effort__c, null);
         
        User_Role__c ur = New User_Role__c();
        
        ur.name = 'DE';
        insert ur;
        
        Theme__c th = New Theme__c();
        th.name = 'Case';
        insert th;
        
        User_stories__c u = New User_Stories__c();
        u.As_A__c = ur.Id;
        u.I_need_to_Goal__c = 'test';
        u.Effort__c = 3;
        u.Theme__c = th.Id;
        u.Scrum_Team__c = scrum.id;
        insert u;
        
        Sprint__c TE = [select Total_Effort__c from Sprint__c where Id = :s.Id];
        system.assertEquals(TE.Total_Effort__C,0);
        
        u.Sprint__c = s.Id;
        update u;
        
        TE = [select Total_Effort__c from Sprint__c where Id = :s.Id];
        system.assertEquals(TE.Total_Effort__C,3);
        
        delete u;
        
        TE = [select Total_Effort__c from Sprint__c where Id = :s.Id];
        system.assertEquals(TE.Total_Effort__C,null);
        
        
    }
}