/*
SWGP-1109
As a user, I want a switch that can turn on/off MRS creation, sync/connect to interfacing system (CAD, PTRF, MSSQL, Oracle, PLM, Mantis).

This is an apex controller for lightning comp MRSOnOffSwitchForm
*/
public with sharing class MRSOnOffSwitchFormController {
    
    @AuraEnabled
    public static List<SwitchMRS> getSettings() {
        
        //select custom setting for mrs switch here
        //SWIFT_SWITCH_SEND_PTRF_PACKAGE_WS
        //SWIFT_SWITCH_MRS_CREATION
        //SWIFT_SWITCH_CAD_WS
        //SWIFT_SWITCH_PTRF_DRW
        //SWIFT_SWITCH_MANTIS_PLM_DRWR
        //SWIFT_SWITCH_ROLL_UP
        List<Environment_Variable__c> lstSettings = [
            select id,name,value__c
			from Environment_Variable__c
            where name like 'SWIFT_SWITCH_%'
        ];
        
        map<String, Environment_Variable__c> mapSettings = new map<String, Environment_Variable__c>();
        List<SwitchMRS> settings = new List<SwitchMRS>();
        for(Environment_Variable__c e: lstSettings) {
            SwitchMRS temp = new SwitchMRS();
            temp.cName = e.Name;
            temp.cValue = e.value__c == 'ON' ? true : false;
            settings.add(temp);
            mapSettings.put(e.name, e);
        }
        
        return settings;
    }
    
    @AuraEnabled
    public static SwitchMRS saveSetting(String settingJson) {//SwitchMRS setting
        SwitchMRS setting = (SwitchMRS) json.deserialize(settingJson, SwitchMRS.class);
		Environment_Variable__c env = Environment_Variable__c.getInstance(setting.cName);
        env.value__c = setting.cValue == true ? 'ON' : 'OFF';
        upsert env;
        return setting;
    }
	
    public class SwitchMRS {
        @AuraEnabled
        public String cName {get;set;} 
        
        @AuraEnabled
        public Boolean cValue {get;set;} 
    }
}