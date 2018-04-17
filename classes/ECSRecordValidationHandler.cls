public class ECSRecordValidationHandler {
	
	public static void handleBeforeInsert(List<Email_Config_Settings__c> newEmailConfigSettingList){
		List<Email_Config_Settings__c> oldECSlist = new List<Email_Config_Settings__c>();
		oldECSlist=fetchOldEmailConfigSettingList(newEmailConfigSettingList);
    	system.debug(LoggingLevel.ERROR,'#### oldECSlist size='+oldECSlist.size());
		EmailConfigSettingsUtility.recordTypePtrfValidationForInsert(newEmailConfigSettingList,oldECSlist);
	}
	
	public static void handleBeforeUpdate(List<Email_Config_Settings__c> newEmailConfigSettingList){
		List<Email_Config_Settings__c> oldECSlist = new List<Email_Config_Settings__c>();
    	oldECSlist=fetchOldEmailConfigSettingList(newEmailConfigSettingList);
    	system.debug(LoggingLevel.ERROR,'#### oldECSlist size='+oldECSlist.size());
		EmailConfigSettingsUtility.recordTypePtrfValidationforUpdate(newEmailConfigSettingList,oldECSlist);
	}
	
	private static List<Email_Config_Settings__c> fetchOldEmailConfigSettingList(List<Email_Config_Settings__c> newEmailConfigSettingList){
		List<Email_Config_Settings__c> ecslist = new List<Email_Config_Settings__c>();
		set<Id> setRecordtypeid = new set<Id>();
		set<String> setTemplateName = new Set<string>();
		for(Email_Config_Settings__c  ecsObj : newEmailConfigSettingList){
      		setRecordtypeid.add(ecsObj.RecordTypeId); 
      		setTemplateName.add(ecsObj.Email_Template_Name__c);
    	}
    	system.debug(LoggingLevel.ERROR,'#### setRecordtypeid='+setRecordtypeid+'\t setTemplateName='+setTemplateName);
    	if(null != setRecordtypeid && !setRecordtypeid.isEmpty()){
    		ecslist  = [SELECT RecordType.DeveloperName, Email_Template_Name__c ,Gating_Jobview__c,MPW_PTRF__c,Name,RecordTypeId,Tech_Geo_Value__c FROM Email_Config_Settings__c
                  		where  Email_Template_Name__c IN : setTemplateName AND RecordTypeId in : setRecordtypeid];
    	}
    	return ecslist;
	} 
}