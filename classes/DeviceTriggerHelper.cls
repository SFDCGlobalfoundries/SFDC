/*
    Author: Ariz Solito
    Description: Apex helper class for device trigger
    History: 
    Asolito     09062013    - Apex coded created.
    Asolito     09302013    - Changed the checking from opportunity2__c to opportunirt_id__c field for filter
    Vijay 		01282015	- updated the business logic to support the Internal Device functionality
*/
    
public with sharing class DeviceTriggerHelper {
    
    //Method will populate Filter Lookup criteria fields Oppty.geometry filter and Oppty.process family filter
    //since formula fields dont work for filtered lookups
    public static void populateFilterLookupCriteria(List<Device__c> devices){
        List<String> opptyIDs = new List<String>();
        for(Device__c d: devices){
        	// if block for Customer Device
        	if(!DeviceTriggerHandler.isInternalDevice(d.RecordTypeId) && d.Opportunity_Program__c != null){
	            if(UtilsString.isNotBlank(d.opportunity_id__c)){              
	                opptyIDs.add(d.opportunity_id__c);
	            }
        	}else{
        		//else block for Internal Device
            	d.geometry_filter__c = d.Internal_Device_Geometry__c;
            	d.process_family_filter__c = d.Internal_Device_Process_Family__c;
            }           
        }    
        
        if(opptyIDs != null && !opptyIDs.isEmpty()){
	        Map<ID,Opportunity> opptyMap = new Map<ID,Opportunity>([SELECT process_geometry__c,process_family__c
	                                                                  FROM Opportunity
	                                                                  WHERE id IN :opptyIDs]);
	                                                                  
	        for(Device__c d: devices){
	            if(opptyMap.containsKey(d.opportunity_id__c)){
	                Opportunity temp = opptyMap.get(d.opportunity_id__c);         
	                d.geometry_filter__c = temp.process_geometry__c;
	                d.process_family_filter__c = temp.process_family__c;
	            } 
	        }  
        } 
    }
    //***Jabee***///Modified By Ravi Teja.B
     public static String CDRSapprovalUserPapulate(String NPCFormId,String DeviceID,String BaseDeviceID){
          string CDRSApprovalUser ='';
          list<BX_041__c> CDRSList=new list<BX_041__c>();
         if(NPCFormId!=null){ 
         String NPCFormDeviceID=[select id,Name,Originating_Device__c from New_Part_Creation_Form__c where Id=:NPCFormId limit 1].Originating_Device__c; 
         
             if(NPCFormDeviceID!=null){
                 CDRSList=[SELECT Id, Approver_1__r.HCM_Login_ID__c,
                                      Approver_2__r.HCM_Login_ID__c,
                                      Approver_3__r.HCM_Login_ID__c,
                                      Device__c
                                      FROM BX_041__c WHERE Device__c=:NPCFormDeviceID and BX_041_Status__c = 'Closed'];
             	if(CDRSList.size() == 0 && BaseDeviceID != null && BaseDeviceID != ''){
             		CDRSList=[SELECT Id,Approver_1__r.HCM_Login_ID__c,
                                         Approver_2__r.HCM_Login_ID__c,
                                         Approver_3__r.HCM_Login_ID__c,
                                         Device__c,Device__r.Base_Device__c
                                         FROM BX_041__c WHERE Device__r.Base_Device__c=:BaseDeviceID and BX_041_Status__c = 'Closed'];
             	}
             }
         }
         else if(DeviceID!=null){
               CDRSList=[SELECT Id,Approver_1__r.HCM_Login_ID__c,
                                         Approver_2__r.HCM_Login_ID__c,
                                         Approver_3__r.HCM_Login_ID__c,
                                         Device__c
                                         FROM BX_041__c WHERE Device__c=:DeviceID and BX_041_Status__c = 'Closed'];
         }
         
        for(BX_041__c CDRSDevice : CDRSList){
        
            if (CDRSDevice.Approver_1__r.HCM_Login_ID__c != Null) {
                CDRSApprovalUser = CDRSDevice.Approver_1__r.HCM_Login_ID__c ;
            }
             if (CDRSDevice.Approver_2__r.HCM_Login_ID__c != Null) {
                CDRSApprovalUser += ',' + CDRSDevice.Approver_2__r.HCM_Login_ID__c;
            }
            if (CDRSDevice.Approver_3__r.HCM_Login_ID__c != Null) {
                CDRSApprovalUser += ',' +CDRSDevice.Approver_3__r.HCM_Login_ID__c;
            }
        
        }
        
        return CDRSApprovalUser;
     }
}