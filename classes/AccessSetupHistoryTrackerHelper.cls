public class AccessSetupHistoryTrackerHelper {
    public void AccessSetupMethod(List<Portal_Tab_Access__c> lstPortal,Map<Id,Portal_Tab_Access__c> lstOldMap){
        final List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();
		final List<AccessSetupHistoryTracking__c> fieldChanges =  new List<AccessSetupHistoryTracking__c>();
        for (Portal_Tab_Access__c newAccount : lstPortal) {
    		final Portal_Tab_Access__c oldAccount = lstOldMap.get(newAccount.Id);
    		for (Schema.FieldSetMember fsm : trackedFields) {
                String fieldName  = fsm.getFieldPath();
                String fieldLabel = fsm.getLabel();
                if (newAccount.get(fieldName) == oldAccount.get(fieldName))
                   continue; 
                String oldValue = String.valueOf(oldAccount.get(fieldName));
                String newValue = String.valueOf(newAccount.get(fieldName));
                if (oldValue != null && oldValue.length()>255) 
                    oldValue = oldValue.substring(0,255);
                if (newValue != null && newValue.length()>255) 
                    newValue = newValue.substring(0,255); 
                final AccessSetupHistoryTracking__c accessSetupHistory = new AccessSetupHistoryTracking__c();
                accessSetupHistory.name         = fieldLabel;
                accessSetupHistory.apiName__c   = fieldName;
                accessSetupHistory.User__c      = newAccount.CreatedBy.Id;
                accessSetupHistory.ChangedBy__c = UserInfo.getName();
                accessSetupHistory.OldValue__c  = oldValue;
                accessSetupHistory.NewValue__c  = newValue;
                accessSetupHistory.Access_Setup__c=newAccount.Id;
                accessSetupHistory.LastModifiedDate__c=newAccount.LastModifiedDate;
                fieldChanges.add(accessSetupHistory);
            }
        }
        if (!fieldChanges.isEmpty()) {
            insert fieldChanges;
        }
    }
}