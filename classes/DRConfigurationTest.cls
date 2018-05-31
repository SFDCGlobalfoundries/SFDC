@isTest
private class DRConfigurationTest{

    @testSetup public static void setupData(){
        Approval_Counter__c ac = new Approval_Counter__c();
        ac.Name = '1';
        insert ac;
    }
    
    static testMethod void testConfigureDR(){
        DRConfigurationController1 controller = new DRConfigurationController1();
        controller.picklistName = 'Change_Type__c';
        controller.rightselected = new list<string>();
        controller.leftselected = new list<string>();
        controller.selectPicklistField();
        controller.selectclick();
        controller.unselectclick();
        controller.getunSelectedValues();
        controller.getSelectedValues();
        controller.newAppName = 'Test App';
        controller.addNewApplication();
        controller.addRow();
        controller.addApplication();
        controller.saveApprovers();
        controller.createApprovalProcesses();
        controller.save();    
    }
}