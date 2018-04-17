/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a InternalDeviceSharingHandler class. It handles the Internal Device sharing with Account Team Proxy members.
 *             
 * History:
 * <Vijay>     02022015 - class created
 * <Vijay>     06042015	- Set the AllOrNone variable value to false in Device Sharing Database operation
 * 
 */
public without sharing class InternalDeviceSharingHandler {

	public static map<string,string> recordAccessMap = new map<string,string>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'};
	public static List<String> internalDeviceRecTypeList = new List<String>{'Internal_Device','Internal_Device_Read_Only'};
	
	/**
     * This method shares the devices whenever new member is added/updated in Account Team Proxy
     *
     * @param atpList list of account team proxy
     */ 
    public void shareInternalDevice(List<Account_Team_Proxy__c> atpList){
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Map<Id, List<Account_Team_Proxy__c>> atpMap = new Map<Id, List<Account_Team_Proxy__c>>(); 
        
        if(atpList != null && !atpList.isEmpty()){
            for(Account_Team_Proxy__c atp:atpList){
                if(atp.User__c != null){
                    userIdSet.add(atp.User__c);
                }
                if(atp.Account__c != null){
                    accountIdSet.add(atp.Account__c);
                }
            }
        }
        try{
            List<Device__Share> upsertDeviceShareList = new List<Device__Share>();
            Map<String, List<Device__Share>> deviceShareListMap = new Map<String, List<Device__Share>>();   
            Map<Id, Set<Id>> accountDeviceListMap = new Map<Id, Set<Id>>();
            
            List<Device__c> internalDeviceList = [SELECT    Id, Name, Account__c, 
                                                            (Select Id, ParentId, UserOrGroupId From Shares WHERE UserOrGroupId =: userIdSet
                                                                    AND RowCause =: Schema.Device__Share.RowCause.Account_Team_Proxy__c)
                                                  FROM      Device__c
                                                  WHERE     Account__c =: accountIdSet AND RecordType.DeveloperName IN : internalDeviceRecTypeList];
            if(!internalDeviceList.isEmpty()){                                    
                for(Device__c device:internalDeviceList){
                    if(!accountDeviceListMap.containsKey(device.Account__c)){
                        accountDeviceListMap.put(device.Account__c, new Set<Id>());
                    }
                    accountDeviceListMap.get(device.Account__c).add(device.Id);
                    for(Device__Share deviceShare:device.Shares){
                        String key = device.Account__c +''+ deviceShare.UserOrGroupId; 
                        if(!deviceShareListMap.containskey(key)){
                            deviceShareListMap.put(key, new List<Device__Share>());
                        }
                        deviceShareListMap.get(key).add(deviceShare);
                    }
                }
            }
            for(Account_Team_Proxy__c atp:atpList){
                String key = atp.Account__c +''+ atp.User__c;
                if(!deviceShareListMap.isEmpty()){
                    List<Device__Share> deviceShareList = deviceShareListMap.get(key);
                    for(Device__Share deviceShare:deviceShareList){
                        deviceShare.AccessLevel = recordAccessMap.get(atp.Account_Access__c);
                        accountDeviceListMap.get(atp.Account__c).remove(deviceShare.parentId);
                        upsertDeviceShareList.add(deviceShare);
                    }
                    if(accountDeviceListMap != null && !accountDeviceListMap.get(atp.Account__c).isEmpty()){
                        for(Id deviceId:accountDeviceListMap.get(atp.Account__c) ){
                            upsertDeviceShareList.add(prepareDeviceShare(deviceId,atp.User__c,recordAccessMap.get(atp.Account_Access__c), 
                                                                            Schema.Device__Share.RowCause.Account_Team_Proxy__c));
                        }
                    }
                }else{
                    if(accountDeviceListMap != null && !accountDeviceListMap.isEmpty()){
                        for(Id deviceId:accountDeviceListMap.get(atp.Account__c)){
                            upsertDeviceShareList.add(prepareDeviceShare(deviceId,atp.User__c,recordAccessMap.get(atp.Account_Access__c),
                                                                             Schema.Device__Share.RowCause.Account_Team_Proxy__c));
                        }
                    }
                }
            }
            if(!upsertDeviceShareList.isEmpty()){
                Database.upsert(upsertDeviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = InternalDeviceSharingHandler.class.getName();
            alw.sourceFunction ='shareInternalDevice()';
            alw.ApplicationName='Device Management';                   
            alw.referenceInfo = 'Device Management';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    /**
     * This method shares the devices whenever new member is added/updated in Account Team Proxy for Design Partner Account
     *
     * @param atpList list of account team proxy
     */ 
    public void shareDesignPartnerDevice(List<Account_Team_Proxy__c> atpList){
        if(atpList == null || atpList.isEmpty()){
            return;
        }
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Map<Id, List<Account_Team_Proxy__c>> atpMap = new Map<Id, List<Account_Team_Proxy__c>>(); 
        
        if(atpList != null && !atpList.isEmpty()){
            for(Account_Team_Proxy__c atp:atpList){
                if(atp.User__c != null){
                    userIdSet.add(atp.User__c);
                }
                if(atp.Account__c != null){
                    accountIdSet.add(atp.Account__c);
                }
            }
        }
        try{
            List<Device__Share> upsertDeviceShareList = new List<Device__Share>();
            Map<String, List<Device__Share>> deviceShareListMap = new Map<String, List<Device__Share>>();   
            Map<Id, Set<Id>> accountDeviceListMap = new Map<Id, Set<Id>>();
            
            List<Device__c> designPartDeviceList = [SELECT    Id, Name, Design_Partner__c, 
                                                            (Select Id, ParentId, UserOrGroupId From Shares WHERE UserOrGroupId =: userIdSet
                                                                    AND RowCause =: Schema.Device__Share.RowCause.Design_Partner_Sharing__c)
                                                  FROM      Device__c
                                                  WHERE     Design_Partner__c =: accountIdSet];          
            if(!designPartDeviceList.isEmpty()){                                    
                for(Device__c device:designPartDeviceList){
                    if(device.Design_Partner__c != null){
                        if(!accountDeviceListMap.containsKey(device.Design_Partner__c)){
                            accountDeviceListMap.put(device.Design_Partner__c, new Set<Id>());
                        }
                        accountDeviceListMap.get(device.Design_Partner__c).add(device.Id);
                        for(Device__Share deviceShare:device.Shares){
                            String key = device.Design_Partner__c +''+ deviceShare.UserOrGroupId; 
                            if(!deviceShareListMap.containskey(key)){
                                deviceShareListMap.put(key, new List<Device__Share>());
                            }
                            deviceShareListMap.get(key).add(deviceShare);
                        }
                    }
                }
            }
            for(Account_Team_Proxy__c atp:atpList){
                String key = atp.Account__c +''+ atp.User__c;
                if(!deviceShareListMap.isEmpty()){
                    List<Device__Share> deviceShareList = deviceShareListMap.get(key);
                    for(Device__Share deviceShare:deviceShareList){
                        deviceShare.AccessLevel = recordAccessMap.get(atp.Account_Access__c);
                        accountDeviceListMap.get(atp.Account__c).remove(deviceShare.parentId);
                        upsertDeviceShareList.add(deviceShare);
                    }
                    if(accountDeviceListMap != null && !accountDeviceListMap.get(atp.Account__c).isEmpty()){
                        for(Id deviceId:accountDeviceListMap.get(atp.Account__c) ){
                            upsertDeviceShareList.add(prepareDeviceShare(deviceId,atp.User__c,recordAccessMap.get(atp.Account_Access__c), 
                                                                            Schema.Device__Share.RowCause.Design_Partner_Sharing__c));
                        }
                    }
                }else{
                    if(accountDeviceListMap != null && !accountDeviceListMap.isEmpty()){
                        for(Id deviceId:accountDeviceListMap.get(atp.Account__c)){
                            upsertDeviceShareList.add(prepareDeviceShare(deviceId,atp.User__c,recordAccessMap.get(atp.Account_Access__c),
                                                                             Schema.Device__Share.RowCause.Design_Partner_Sharing__c));
                        }
                    }
                }
            }
            if(!upsertDeviceShareList.isEmpty()){
                Database.upsert(upsertDeviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = InternalDeviceSharingHandler.class.getName();
            alw.sourceFunction ='shareDesignPartnerDevice()';
            alw.ApplicationName='Device Management';                   
            alw.referenceInfo = 'Device Management';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    /**
     * This method shares the devices with the respective account team proxy members
     *
     * @param deviceList list of devices
     */ 
    public void shareInternalDevice(List<Device__c> deviceList){
        
        if(deviceList == null || deviceList.isEmpty()){
            return;
        }
        Map<Id, Set<Id>> accountDeviceListMap = new Map<Id, Set<Id>>();
        List<Device__Share> deviceShareList = new List<Device__Share>(); 
        for(Device__c device: deviceList){
            if(!accountDeviceListMap.containsKey(device.Account__c)){
                accountDeviceListMap.put(device.Account__c, new Set<Id>());
            }
            accountDeviceListMap.get(device.Account__c).add(device.Id);
        }
        for(Account_Team_Proxy__c atp:[SELECT Id, Account__c, User__c, Account_Access__c, User__r.IsActive FROM Account_Team_Proxy__c WHERE Account__c = : accountDeviceListMap.keySet()
                                            AND Flag_for_Delete__c = false AND User__r.IsActive = true ORDER BY Account__c]){
            for(Id deviceId: accountDeviceListMap.get(atp.Account__c)){
                deviceShareList.add(prepareDeviceShare(deviceId,atp.User__c,recordAccessMap.get(atp.Account_Access__c),Schema.Device__Share.RowCause.Account_Team_Proxy__c));
            }
        }
        try{
            if(!deviceShareList.isEmpty()){
                Database.insert(deviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }           
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = InternalDeviceSharingHandler.class.getName();
            alw.sourceFunction ='shareInternalDevice()';
            alw.ApplicationName='Device Management';                   
            alw.referenceInfo = 'Device Management';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }                                               
    }
    
    /**
     * This method revokes/removes device access when member is removed from Account Team Proxy
     *
     * @param atpList list of account team proxy
     */ 
    public void removeInternalDeviceAccess(List<Account_Team_Proxy__c> atpList){
        if(atpList == null || atpList.isEmpty()){
            return;
        }
        set<Id> accountIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        List<Device__Share> deleteDeviceShareList = new List<Device__Share>();
        for(Account_Team_Proxy__c atp:atpList){
            if(atp.Account__c != null){
                accountIdSet.add(atp.Account__c);
            }
            if(atp.User__c != null){
                userIdSet.add(atp.User__c);
            }
        }
        try{
            List<Device__Share> deviceShareList = getDeviceShareList(accountIdSet, userIdSet, Schema.Device__Share.RowCause.Account_Team_Proxy__c);
            Map<String, List<Device__Share>> deviceShareListMap = new Map<String, List<Device__Share>>();
            if(deviceShareList != null && !deviceShareList.isEmpty()){
                for(Device__Share deviceShare: deviceShareList){
                    String key = deviceShare.Parent.Account__c +''+ deviceShare.UserOrGroupId; 
                    if(!deviceShareListMap.containskey(key)){
                        deviceShareListMap.put(key, new List<Device__Share>());
                    }
                    deviceShareListMap.get(key).add(deviceShare);
                }
            }
            for(Account_Team_Proxy__c atp:atpList){
                String key = atp.Account__c +''+ atp.User__c;
                List<Device__Share> devShareList = deviceShareListMap.get(key);
                if(devShareList != null && !devShareList.isEmpty()){
                    deleteDeviceShareList.addAll(devShareList);
                }
            }
            if(!deleteDeviceShareList.isEmpty()){
                Database.delete(deleteDeviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = InternalDeviceSharingHandler.class.getName();
            alw.sourceFunction ='removeInternalDeviceAccess()';
            alw.ApplicationName='Device Management';                   
            alw.referenceInfo = 'Device Management';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
        
    }
    
    /**
     * This method revokes/removes device access when member is removed from Account Team Proxy
     *
     * @param atpList list of account team proxy
     */ 
    public void removeDesignPartnerDeviceAccess(List<Account_Team_Proxy__c> atpList){
        if(atpList == null || atpList.isEmpty()){
            return;
        }
        set<Id> accountIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        List<Device__Share> deleteDeviceShareList = new List<Device__Share>();
        for(Account_Team_Proxy__c atp:atpList){
            if(atp.Account__c != null){
                accountIdSet.add(atp.Account__c);
            }
            if(atp.User__c != null){
                userIdSet.add(atp.User__c);
            }
        }
        try{
            List<Device__Share> deviceShareList = getDPDeviceShareList(accountIdSet, userIdSet, Schema.Device__Share.RowCause.Design_Partner_Sharing__c);
            Map<String, List<Device__Share>> deviceShareListMap = new Map<String, List<Device__Share>>();
            if(deviceShareList != null && !deviceShareList.isEmpty()){
                for(Device__Share deviceShare: deviceShareList){
                    String key = deviceShare.Parent.Design_Partner__c +''+ deviceShare.UserOrGroupId;
                    if(!deviceShareListMap.containskey(key)){
                        deviceShareListMap.put(key, new List<Device__Share>());
                    }
                    deviceShareListMap.get(key).add(deviceShare);
                }
            }
            for(Account_Team_Proxy__c atp:atpList){
                String key = atp.Account__c +''+ atp.User__c;
                List<Device__Share> devShareList = deviceShareListMap.get(key);
                if(devShareList != null && !devShareList.isEmpty()){
                    deleteDeviceShareList.addAll(devShareList);
                }
            }
            if(!deleteDeviceShareList.isEmpty()){
                Database.delete(deleteDeviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = InternalDeviceSharingHandler.class.getName();
            alw.sourceFunction ='removeDesignPartnerDeviceAccess()';
            alw.ApplicationName='Device Management';                   
            alw.referenceInfo = 'Device Management';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    /**
     * This method accepts the parameters and set and return the instance of device share object
     *
     * @param deviceId    Id of device object
     * @param userId      Id of User object 
     * @param accessLevel can be read/edit
     * @param rowCause    
     */ 
    private Device__Share prepareDeviceShare(Id deviceId, Id userId, String accessLevel, String rowCause){
        Device__Share deviceShare = new Device__Share(ParentId = deviceId, UserOrGroupId = userId, AccessLevel = accessLevel, RowCause = rowCause);
        return deviceShare;
    }
    
    /**
     * This method accepts the query criteria parameters and returns the Device share object records
     *
     * @param accountIdSet    Account Id set
     * @param userIdSet       User Id set
     * @param rowCause
     */ 
    public List<Device__Share> getDeviceShareList(Set<Id> accountIdSet, Set<Id> userIdSet, String rowCause){
        List<Device__Share> deviceShareList = [SELECT   AccessLevel,Id, IsDeleted, LastModifiedById, LastModifiedDate,
                                                        ParentId, RowCause, UserOrGroupId , Parent.Account__c 
                                               FROM     Device__Share
                                               WHERE    ParentId in (SELECT Id FROM Device__c where Account__c = : accountIdSet)
                                                        AND UserOrGroupId =: userIdSet AND RowCause =: rowCause 
                                                        AND Parent.RecordType.DeveloperName IN : internalDeviceRecTypeList];
       return deviceShareList;                      
    }
    
    /**
     * This method accepts the query criteria parameters and returns the Device share object records for Design PArtner Account
     *
     * @param accountIdSet    Account Id set
     * @param userIdSet       User Id set
     * @param rowCause
     */ 
    public List<Device__Share> getDPDeviceShareList(Set<Id> accountIdSet, Set<Id> userIdSet, String rowCause){
        List<Device__Share> deviceShareList = [SELECT   AccessLevel,Id, IsDeleted, LastModifiedById, LastModifiedDate,
                                                        ParentId, RowCause, UserOrGroupId , Parent.Design_Partner__c 
                                               FROM     Device__Share
                                               WHERE    ParentId in (SELECT Id FROM Device__c where Design_Partner__c = : accountIdSet)
                                                        AND UserOrGroupId =: userIdSet AND RowCause =: rowCause];
       return deviceShareList;                      
    }
    
    public class applicationException extends Exception {}     
            
}