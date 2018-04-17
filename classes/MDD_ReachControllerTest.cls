/* 
 Type Name: MDD_ReachControllerTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test class for MDD_ReachController controller
 
 */
@isTest
public class MDD_ReachControllerTest {
    public static testMethod void MDD_ReachTestMethod(){
        MDD_Static_Contents__c ms = new MDD_Static_Contents__c();
        ms.Name = '1';
        ms.Content__c = 'Test';
        insert ms;
        MDD_Reach_controller m = new MDD_Reach_controller();
        m.str = '';
        MDD_Reach_controller.getDomain();
    }
}