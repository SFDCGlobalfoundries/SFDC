public class MDDPartHandler {

    @future
    public static void updatePartWithERPDevice(Map<Id,Id> partDeviceMap){
        List<Part__c> partUpdate = new List<Part__c>();
        for(Id pId: partDeviceMap.keySet()){
            Part__c prt = new Part__c(Id = pId);
            prt.ERP_Device__c = partDeviceMap.get(pId);
            partUpdate.add(prt);
        }
        if(partUpdate.size() > 0)
        	update partUpdate;
    }
}