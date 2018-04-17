/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a DeviceTriggerHandler class.
 *             
 * History:
 * <Vijay>     01272015 - class created
 * <Vijay>     05262015 - added the logic to add the Process Id in Assigned Process object if it is assigned at the time device creation for Non DE - IP Internal
                          Device.   
 * 
 */
public with sharing class DeviceTriggerHandler {
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;
    public static Set<Id> deviceRecTypeIdSet = null;
    public static Set<Id> internalDeviceRecTypeIdSet = null;
        
     /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */    
    public DeviceTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
      
    /**
     * This method is triggered on after insert event and execute the actual business logic
     *
     * @param   updatedDevices       list of updated Device records
     * @param   updatedDeviceMap map of updated Device records
     */ 
    public void OnAfterInsert(Device__c[] updatedDevices, Map<ID, Device__c>  updatedDeviceMap){
        InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
        List<Device__c> internalDeviceList = new List<Device__c>();
        List<Assigned_Process__c> assignedProcessList = new List<Assigned_Process__c>();
        for(Device__c internalDevice : updatedDevices){
            if(isInternalDevice(internalDevice.RecordTypeId)){
                internalDeviceList.add(internalDevice);
                if(internalDevice.Assigned_Process_ID__c != null && internalDevice.Account_Sub_Type__c != 'DE - IP'){
                    assignedProcessList.add(new Assigned_Process__c(Device__c = internalDevice.Id, Process__c = internalDevice.Assigned_Process_ID__c, 
                                            Primary_Process__c = true));
                }
            }
            
        }
        try{
            if(!internalDeviceList.isEmpty()){
                System.debug('-------------'+internalDeviceList);
                internalDeviceSharingHandler.shareInternalDevice(internalDeviceList);
            }
        
            if(!assignedProcessList.isEmpty()){
                System.debug('-------------'+assignedProcessList);
                insert assignedProcessList;
            }
        }catch(Exception e){
            System.debug(LoggingLevel.Error, e.getMessage());
        }
    }
    
    /**
     * This method accepts the device recordtype and checks the Device type whether it is internal device or not
     *
     * @param   recordTypeId    Device record type Id
     */ 
    public static boolean isInternalDevice(Id recordTypeId){
        System.debug('--In isInternalDevice-----------'+recordTypeId);
        if(internalDeviceRecTypeIdSet == null){
            internalDeviceRecTypeIdSet = getRecordTypeId('Device__c', new List<String>{'Internal_Device','Internal_Device_Read_Only'});
        }
        if(internalDeviceRecTypeIdSet != null && internalDeviceRecTypeIdSet.contains(recordTypeId)){
            System.debug('--Device RecordType is InternalDevice-----------');
            return true;
        }
        return false;
    }
    
    /**
     * This method accepts the object type and recordtype developer name and returns the record type Ids
     *
     * @param   sObjType                        Object type
     * @param   recordTypeDeveloperNameList     list of recordtype developer names
     */ 
    public static Set<Id> getRecordTypeId(String sObjType, List<String> recordTypeDeveloperNameList){
        Set<Id> recordTypeIdSet = null;
        if(String.isNotBlank(sObjType) && (recordTypeDeveloperNameList != null && !recordTypeDeveloperNameList.isEmpty())) {
            List<RecordType> recordTypeList = [Select id from RecordType where sObjectType =: sObjType and developerName =: recordTypeDeveloperNameList];
            
            System.debug('-----'+recordTypeList);
            if(!recordTypeList.isEmpty()){
                recordTypeIdSet = new Set<Id>();
                for(RecordType recType: recordTypeList){
                    recordTypeIdSet.add(recType.Id);
                }
            }
        }
        return recordTypeIdSet;
    }
   
    /**
    * This method accepts List Of Device__c
    *
    * @param   deviceList            list of Device__c 
    */ 
    public static void updateBUPL(List<Device__c> deviceList){
        
        Set<Id> oppIdSet = new Set<Id>();
            
        for(Device__c deviceObj : deviceList){
            if(deviceObj.Opportunity2__c != null 
              && (deviceObj.Product_Line__c == null || deviceObj.Business_Unit__c == null) ){
                
                oppIdSet.add(deviceObj.Opportunity2__c);
            }
        }
        
        List<Opportunity> opportunityList = [SELECT Id, Product_Line__c, Business_Unit__c FROM Opportunity WHERE Id IN : oppIdSet AND (Product_Line__c != null OR Business_Unit__c != null)];
        
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
        
        for(Opportunity oppObj : opportunityList){
            opportunityMap.put(oppObj.Id, oppObj);
        }
        
        for(Device__c deviceObj : deviceList){
            if(deviceObj.Product_Line__c == null
               && opportunityMap.get(deviceObj.Opportunity2__c) != null
               && opportunityMap.get(deviceObj.Opportunity2__c).Product_Line__c != null){
                
                deviceObj.Product_Line__c = opportunityMap.get(deviceObj.Opportunity2__c).Product_Line__c;
            }
            
            if(deviceObj.Business_Unit__c == null
               && opportunityMap.get(deviceObj.Opportunity2__c) != null
               && opportunityMap.get(deviceObj.Opportunity2__c).Business_Unit__c != null){
                
                deviceObj.Business_Unit__c = opportunityMap.get(deviceObj.Opportunity2__c).Business_Unit__c;
            }
        }
    }
}