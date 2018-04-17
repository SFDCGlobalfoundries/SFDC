/*************************************************************************************************************************************************************
@ Class:          Device_TriggerHelper
@ Version:        1.0
@ Author:         KOKA GOPI (Gopi.Koka@globalfoundries.com)
@ Purpose:        Device_TriggerHelper_Version1 class used to avoid multiple execution in Device_TriggerHelper class.
                  Due to coverage issues implementing new Class.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 03.03.2017 / Gopi Koka / Created the class.
**************************************************************************************************************************************************************/
Public Class Device_TriggerHelper_Version1{
   public  Map<Id,Device__c>    triggerOldMap          { get; set; } //Map to store old record values of Device object
   public  Map<Id,Device__c>    triggerNewMap          { get; set; } //Map to store New record values of Device object 
   
   public Device_TriggerHelper_Version1(){
       triggerOldMap = ((Map<Id,Device__c>)Trigger.oldMap);
       triggerNewMap = ((Map<Id,Device__c>)Trigger.newMap);
   }
   
   public void deviceupdatepscpsa(){                   
        if(Trigger.isInsert || Trigger.isUpdate){               
            DevicePscPsautilcls Dpc= new DevicePscPsautilcls();
            Dpc.updatePsaPsc(triggerNewMap, triggerOldMap);                 
        }      
    } 
}