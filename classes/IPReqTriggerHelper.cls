/****************************************************************************
    Class Name: IPReqTriggerHelper
    Author: Ravi Teja.B    
    Description: IP Trigger Helper Class
    Created Date:26-02-2018 {DD-MM-YYYY}
******************************************************************************/
public class IPReqTriggerHelper {
    Public Map<Id,CMOS_BU_IP_Request__c> triggerOldMap;
    Public Map<Id,CMOS_BU_IP_Request__c> triggerNewMap;
    public IPReqTriggerHelper(){
        triggerOldMap = (Map<Id,CMOS_BU_IP_Request__c>) trigger.oldMap;
        triggerNewMap = (Map<Id,CMOS_BU_IP_Request__c>) trigger.newMap;
    }
	/*************************************************
    Method Name: RecordTypeAssignment
    Description: Assigning Record Type based on the IP
				 Type.
    Parameters : 
    Return Type: Void              
    **************************************************/
    public void RecordTypeAssignment(){
        //Id OtherRTId = Schema.SObjectType.CMOS_BU_IP_Request__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        for(CMOS_BU_IP_Request__c ip: (List<CMOS_BU_IP_Request__c>) trigger.new){
            if(ip.IPType__c != null){
                Schema.RecordTypeInfo RT = Schema.SObjectType.CMOS_BU_IP_Request__c.getRecordTypeInfosByName().get(ip.IPType__c.toUpperCase());
                if(RT != null)
                    ip.RecordTypeId = RT.getRecordTypeId();
            }
            else{
                if(ip.RecordTypeId != null){
                    ip.IPType__c = Schema.SObjectType.CMOS_BU_IP_Request__c.getRecordTypeInfosById().get(ip.RecordTypeId).getname();
                }
            } 
        }
    }
}