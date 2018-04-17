public class ROS_TRIGGER_HELPER_ReticleDatawarehouse {
    
    public static void beforeInsert(List<Reticle_Datawarehouse__c> lDwNew) {
        List<Reticle_Datawarehouse__c> lDwReticleNew = Trigger.new;
        Set<String> sReticleIds = new Set<String>();
    
        for (Reticle_Datawarehouse__c eachReticleDw :lDwNew) {
            sReticleIds.add(eachReticleDw.Name);
        }
    
        List<Reticle_Datawarehouse__c> lReticleDwExisting = [ SELECT Id
                                                                   , Name
                                                                   , CustomerDevice_ID__c
                                                                   , GlobalFoundries_DeviceID__c
                                                                   , FAB__c
                                                                   , Customer_ID__c
                                                                   , InactiveDay__c
                                                                   , Reticle_Status__c
                                                                   , Reticle_Type__c
                                                              FROM Reticle_Datawarehouse__c 
                                                              WHERE Name IN :sReticleIds
                                                                  AND IsActive__c = true
                                                                  AND InactiveDay__c < 366
                                                                  AND Job_Id__c != null ];
    
        for (Reticle_Datawarehouse__c reticleDwNew :lDwReticleNew) {
            for (Reticle_Datawarehouse__c reticleDwExisting :lReticleDwExisting) {
                if (reticleDwExisting.Name == reticleDwNew.Name) { 
                    if (reticleDwExisting.CustomerDevice_ID__c == reticleDwNew.CustomerDevice_ID__c) {
                        if (reticleDwExisting.GlobalFoundries_DeviceID__c == reticleDwNew.GlobalFoundries_DeviceID__c) {
                            if (reticleDwExisting.FAB__c == reticleDwNew.FAB__c) {
                                if (reticleDwExisting.Reticle_Status__c == reticleDwNew.Reticle_Status__c) {
                                    if (reticleDwExisting.Reticle_Type__c == reticleDwNew.Reticle_Type__c) {
                                        if (reticleDwNew.InactiveDay__c != 0) {
                                            reticleDwNew.Duplicate_Record__c = true;
                                            reticleDwNew.Invalid_Reason__c = ROS_Error_Messages__c.getInstance('ROS_DUPLICATE_DW_RECORD').value__c;
                                            // reticleDwNew.addError(ROS_Error_Messages__c.getInstance('ROS_DUPLICATE_DW_RECORD').value__c);
                                        }
                                    }
                                }
                            }
                        } else {
                            reticleDwNew.IsNewDevice__c = true;
                        }
                    } else {
                        reticleDwNew.IsNewDevice__c = true;
                    }
                }
            }
        }
    }
}