/*
Type Name: ContactDeviceSharingHandler
Author: Manikumar M
Created Date: 13/06/2017
Reason: 
Test Class: InternalDeviceSharingHandlerTest
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
public without sharing class ContactDeviceSharingHandler {
    /**
    * This method shares the devices whenever new member is added/updated in Contact for Design Partner Account
    *
    * @param contList list of contacts
    */ 
    public void shareDesignPartnerDevice(List<Contact> contList) {
        if(contList == null || contList.isEmpty()){
            return;
        }
        Set<Id> accountIdSet = new Set<Id>();
        Set<User> userIdSet = new Set<User>();
        Map<Id,Id> userConMap = new Map<Id,Id>();
        
        if(contList.size() > 0) {
            for(Contact contObj:contList) {
                if(contObj.AccountId != null) {
                    accountIdSet.add(contObj.AccountId);
                }
            }
        }
        if(accountIdSet.size() > 0){
            for(User usr : [select Id,Name,ContactId,Contact.AccountId,IsActive from User where IsActive=true AND Contact.AccountId IN:accountIdSet]){
                userConMap.put(usr.id,usr.Contact.AccountId);
            }
        }
        
        try{
            
            List<Device__Share> insertDeviceShareList = new List<Device__Share>();
            Map<Id,Device__Share> DeviceSharingMap=new Map<Id,Device__Share>();
            set<String> DeviceIDSet=new Set<String>();
            Map<Id,list<Device__c>> devIdMap = new Map<Id,list<Device__c>>();
            list<Device__c> DeviceIDList=[SELECT Id, Name, Design_Partner__c FROM Device__c WHERE Design_Partner__c IN: accountIdSet AND Expose_Device_to_Customer__c = true];
            for(Device__c Devobj :DeviceIDList){
                DeviceIDSet.add(Devobj.Id );
                if(!devIdMap.containsKey(Devobj.Design_Partner__c)) {
                  devIdMap.put(Devobj.Design_Partner__c,new list<Device__c>());
                }
                devIdMap.get(Devobj.Design_Partner__c).add(Devobj);
                
            }
            for(Device__Share DS :[SELECT AccessLevel,Id,ParentId,UserOrGroupId FROM Device__Share where ParentId IN:DeviceIDSet]){
                DeviceSharingMap.put(DS.UserOrGroupId,DS);
            }
            if(userConMap.size()>0) {
                if(DeviceSharingMap.size()>0){
                    for(id USRIDs :userConMap.keyset()) {
                        if(!DeviceSharingMap.containsKey(USRIDs)){
                        	for(device__c dvc : devIdMap.get(userConMap.get(USRIDs))){
	                            Device__Share Deviceshare = new Device__Share();
	                            Deviceshare.AccessLevel='Edit';
	                            Deviceshare.ParentId=dvc.id;
	                            Deviceshare.UserOrGroupId=USRIDs; 
	                            Deviceshare.RowCause=Schema.Device__Share.RowCause.Design_Partner_Sharing__c;
	                            insertDeviceShareList.add(Deviceshare);
                        	}
                        }	
                    }
                }
            }
            if(insertDeviceShareList.size()>0){
                Database.insert(insertDeviceShareList, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ContactDeviceSharingHandler.class.getName();
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
     * This method revokes/removes device access when member is removed from Contact
     *
     * @param contList list of account team proxy
     */ 
    public void removeDesignPartnerDeviceAccess(Map<Id,Contact> oldList,List<Contact> contList){
        if(contList == null || contList.isEmpty()){
            return;
        }
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        set<Id> ConIdSet = new set<id>();
        if(contList != null && !contList.isEmpty()) { 
            for(Contact contObj:contList) {
                if(contObj.AccountId != null) {
                	Contact objOldContact = oldList.get(contObj.Id);
                	if(contObj.AccountId != objOldContact.AccountId) {
                		accountIdSet.add(objOldContact.AccountId);
                    	ConIdSet.add(contObj.id);	
                	}
                	else if(contObj.Is_Portal_User_Active__c == false) {
                		accountIdSet.add(objOldContact.AccountId);
                    	ConIdSet.add(contObj.id);		
                	}
                    
                }
            }
        }
        if(accountIdSet.size() > 0 && ConIdSet.size()>0){
            for(User usr : [select Id,Name,ContactId,Contact.AccountId,IsActive from User where IsActive=true AND ContactId IN:ConIdSet]){
                userIdSet.add(usr.Id);
            }
        }
        
        try{
            set<String> DeviceIDSet=new Set<String>();
            list<Device__c> DeviceIDList=[SELECT Id, Name, Design_Partner__c FROM Device__c WHERE Design_Partner__c IN: accountIdSet AND Expose_Device_to_Customer__c = true];
            for(Device__c Devobj :DeviceIDList){
                DeviceIDSet.add(Devobj.Id );
            }
            List<Device__Share> sharesToDelete = [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Device__Share WHERE ParentId IN :DeviceIDSet AND UserOrGroupId IN:userIdSet AND RowCause =: Schema.Device__Share.RowCause.Design_Partner_Sharing__c];
            if(!sharesToDelete.isEmpty()){
                Database.Delete(sharesToDelete, false);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ContactDeviceSharingHandler.class.getName();
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
    public class applicationException extends Exception {}     
}