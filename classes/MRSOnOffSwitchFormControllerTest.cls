/*
SWGP-1109
Test class for MRSOnOffSwitchFormController
*/
@isTest 
private class MRSOnOffSwitchFormControllerTest {

    @testSetup 
    static void testSetupMethod() {
        init();
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        MRSOnOffSwitchFormController.SwitchMRS s = MRSOnOffSwitchFormController.getSettings().get(0);
        s.cValue = true;
        MRSOnOffSwitchFormController.saveSetting(json.serialize(s));
    }
    
    
    static void init() {
        
        list<Environment_Variable__c> lstEnv = new list<Environment_Variable__c>();
		
		Environment_Variable__c env = new Environment_Variable__c();
		
		env.name = 'SWIFT_SWITCH_SEND_PTRF_PACKAGE_WS';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_MRS_CREATION';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_CAD_WS';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_MANTIS_PLM_DRWR';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_ROLL_UP';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_PTRF_DESELECTION';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_PTRF_OLD_DESELECTION';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_JOBVIEWER_SYNCING';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		
		env = new Environment_Variable__c();
		env.name = 'SWIFT_SWITCH_PTRF_DRW';
		env.value__c = 'ON';
		lstEnv.add(env);
		
		
		insert lstEnv;
    }
}