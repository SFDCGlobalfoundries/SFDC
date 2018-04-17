/**
* @author       :   
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to prevent duplicate reticle devices for same reticle.               
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Onkar Kumar     12/27/2013          Created the Class
        Sameer Matale   2/26/2014           Modified to prevent duplicate device reticles
                                            based on Global Foundry Device Id and CRM Device Id
                                            for same Reticle Id.
        Vijay Mahajan	5/27/2014			Added Is Temporary check to update the GF Device Id and Customer Device Id field values of Reticle Object.
        									If Reticle Device is created from Active Batch under existing Inactive reticle, this Is Temporary flag is set to true.
**/

trigger ROS_PreventDuplicateDevicereticle on Reticle_Device__c (before insert,after delete,after insert,after update) {

 if((ROS_Triggers_Bypass__c.getInstance('ROS_PreventDuplicateDevicereticle').Username__c==null)||((UserInfo.getUserName()!=ROS_Triggers_Bypass__c.getInstance('ROS_PreventDuplicateDevicereticle').Username__c))){ 
     
            if(Trigger.isbefore && Trigger.IsInsert){
                Set<Id> SReticlesId=new Set<Id>();
                Set<Id> SDeviceId=new Set<Id>();
    
                for(Reticle_Device__c rd:Trigger.new){
                    SReticlesId.add(rd.Reticle__c);
                    SDeviceId.add(rd.Device__c);
                }
    
                Map<Id, Map<String, List<Reticle_Device__c>>> MReticleToExistingRD = new Map<Id, Map<String, List<Reticle_Device__c>>>();
                List<Reticle_Device__c > LExistingRD=[Select Id,Device__c,Reticle__c,Global_foundries_device_Id__c,CRM_Device_ID__c,GF_Device_Id__c from Reticle_Device__c where reticle__c in :SReticlesId];
                String GFIdCRMIdkey;

                for(Reticle_Device__c reticleDevice : LExistingRD) {
                    GFIdCRMIdkey = (reticleDevice.Global_foundries_device_Id__c != null ? reticleDevice.Global_foundries_device_Id__c : '') + (reticleDevice.CRM_Device_ID__c != null ? reticleDevice.CRM_Device_ID__c : '');

                    if(GFIdCRMIdkey != '' && GFIdCRMIdkey != null) {
                        if(!MReticleToExistingRD.isEmpty() && MReticleToExistingRD.containsKey(reticleDevice.Reticle__c)) {
                            if(MReticleToExistingRD.get(reticleDevice.Reticle__c) != null && !MReticleToExistingRD.get(reticleDevice.Reticle__c).isEmpty()) {
                                if(MReticleToExistingRD.get(reticleDevice.Reticle__c).containsKey(GFIdCRMIdkey)) {
                                    MReticleToExistingRD.get(reticleDevice.Reticle__c).get(GFIdCRMIdkey).add(reticleDevice);
                                }else {
                                    MReticleToExistingRD.get(reticleDevice.Reticle__c).put(GFIdCRMIdkey, new List<Reticle_Device__c>{reticleDevice});
                                }
                            }
                        }else {
                            MReticleToExistingRD.put(reticleDevice.Reticle__c, new Map<String, List<Reticle_Device__c>>{GFIdCRMIdkey => new List<Reticle_Device__c>{reticleDevice}});
                        }
                    }
                }

                for(Reticle_Device__c reticleDevice : Trigger.new) {
                    GFIdCRMIdkey = (reticleDevice.Global_foundries_device_Id__c != null ? reticleDevice.Global_foundries_device_Id__c : '') + (reticleDevice.CRM_Device_ID__c != null ? reticleDevice.CRM_Device_ID__c : '');
                    if(GFIdCRMIdkey != '' && GFIdCRMIdkey != null) {
                        if(!MReticleToExistingRD.isEmpty() && MReticleToExistingRD.containsKey(reticleDevice.Reticle__c) && MReticleToExistingRD.get(reticleDevice.Reticle__c) != null && !MReticleToExistingRD.get(reticleDevice.Reticle__c).isEmpty() && MReticleToExistingRD.get(reticleDevice.Reticle__c).containsKey(GFIdCRMIdkey)) {
                            reticleDevice.adderror('Device Reticle already exists.');
                        }
                    }
                }
            }
            
            
            
            if(trigger.isafter &&(Trigger.IsUpdate || Trigger.IsInsert)) {
                Set<Id> SRetIds=new Set<Id>();

                for(Reticle_Device__c rd : Trigger.new){
                    SRetIds.add(rd.Reticle__c);                    
                }

                List<Reticle__c> LUpdateRet=new List<Reticle__c>();        
                List<Reticle__c> LReticles=new List<Reticle__c>([Select Id,GlobalFoundries_Device_ID__c,Device_ID__c,(Select Id,Device__c,Reticle__c,Global_foundries_device_Id__c,CRM_Device_ID__c,GF_Device_Id__c, Is_Temporary__c from Reticle_Device__r) from reticle__c where id in :SRetIds]);

                for(Reticle__c TempRet : LReticles){
                    Set<String> SGfIds=new Set<String>();
                    Set<String> SDeviceIds=new Set<String>();
                    String TempGFId='';
                    String TempDeviceId='';

                    for(Reticle_Device__c TempRD : TempRet.Reticle_Device__r){
                    	if(!TempRD.Is_Temporary__c){
	                        SGfIds.add(TempRD.GF_Device_Id__c);
	                        SDeviceIds.add(TempRD.CRM_Device_ID__c);
                    	}                  
                    }

                    for(String DeviceId : SDeviceIds) {
                        if(DeviceId != '' && DeviceId != null) {
                            TempDeviceId = TempDeviceId + DeviceId + ',' + '\n';
                        }
                    }

                    for(String GfId : SGFIds) {
                        if(GfId != '' && GfId != null) {
                            TempGFId = TempGFId + GfId + ',' + '\n';
                        }
                    }

                    if(TempGFId != '' && TempGFId != null){ 
                        TempGFId = TempGFId.substring(0,TempGFId.length()-2);
                    }

                    if(TempDeviceId != '' && TempDeviceId != null){ 
                        TempDeviceId = TempDeviceId.substring(0,TempDeviceId.length()-2);
                    }

                    TempRet.GlobalFoundries_Device_ID__c = TempGFId;
                    TempRet.Device_ID__c = TempDeviceId; 
                    LUpdateRet.add(TempRet);           
                }
                update LUpdateRet;
            }

            if(trigger.isafter && (Trigger.IsDelete)) {
                Set<Id> SRetDelIds=new Set<Id>();

                for(Reticle_Device__c rd:Trigger.old){
                    SRetDelIds.add(rd.Reticle__c);                    
                }

                List<Reticle__c> LUpdateRet=new List<Reticle__c>();
                List<Reticle__c> LReticles=new List<Reticle__c>([Select Id,GlobalFoundries_Device_ID__c,Device_ID__c,(Select Id,Device__c,Reticle__c,Global_foundries_device_Id__c,CRM_Device_ID__c,GF_Device_Id__c from Reticle_Device__r) from reticle__c where id in :SRetDelIds]);

                for(Reticle__c TempRet : LReticles) {
                    Set<String> SGfIds=new Set<String>();
                    Set<String> SDeviceIds=new Set<String>();
                    String TempGFId='';
                    String TempDeviceId='';

                    for(Reticle_Device__c TempRD : TempRet.Reticle_Device__r) {
                        SGfIds.add(TempRD.GF_Device_Id__c);
                        SDeviceIds.add(TempRD.CRM_Device_ID__c);                 
                    }

                    for(String DeviceId : SDeviceIds) {
                        if(DeviceId != '' && DeviceId != null) {
                            TempDeviceId = TempDeviceId + DeviceId + ',' + '\n';
                        }
                    }

                    for(String GfId : SGFIds) {
                        if(GfId != '' && GfId != null) {
                            TempGFId = TempGFId + GfId + ',' + '\n';
                        }
                    }

                    if(TempGFId != '' && TempGFId != null) { 
                        TempGFId = TempGFId.substring(0,TempGFId.length()-2);
                    }

                    if(TempDeviceId != '' && TempDeviceId != null) { 
                        TempDeviceId = TempDeviceId.substring(0,TempDeviceId.length()-2);
                    }        

                    TempRet.GlobalFoundries_Device_ID__c=TempGFId;
                    TempRet.Device_ID__c=TempDeviceId; 
                    LUpdateRet.add(TempRet);           
                }
                update LUpdateRet;
            }
       }
}