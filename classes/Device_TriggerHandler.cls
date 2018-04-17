/*************************************************************************************************************************************************************
@ Class:          Device_TriggerHandler
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Device Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
@ Change history: 15.05.2017 / Pradosh Samal / Added updatGenerateStandardFrame method.
@ Change history: 12.09.2017 / Devendra / Added DeviceToERPDeviceDataFlow method.
**************************************************************************************************************************************************************/
public class Device_TriggerHandler extends TriggerHandler{
    public Device_TriggerHelper helper { get; set; } 
    public Device_TriggerHelper_Version1 helperV1{get;set;}
    public Device_TriggerHelper_Version2 helperV2{get;set;}
    /*************************************************************************************************************************************************************
    @ Constructor:    Device_TriggerHandler
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/   
    public Device_TriggerHandler(){
        helper = new Device_TriggerHelper();
        helperV1 = new Device_TriggerHelper_Version1();
        helperV2 = new Device_TriggerHelper_Version2();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/ 
    public override void afterInsert(){
        helper.creatDevicePSP();
        helper.deviceMaskSetTitlelookUp();
        helper.deviceSharingWithATM(); 
        if(trigger.isinsert && trigger.isafter)Device_TriggerHelper.deviceSharingAccess(json.serialize(trigger.new[0]));  
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterUpdate(){
        helperV2.runOnChangeOppInDevice();
        helper.creatDevicePSP();
        helper.deviceMaskSetTitlelookUp();
        helper.taskUpdateOnDevicechnge();
        helper.deviceForcastDateUpdt();
        helper.deviceUpdateAfter();
        helper.updateOpptyDWField();
        if(trigger.isupdate && trigger.isafter)Device_TriggerHelper.deviceSharingAccess(json.serialize(trigger.new[0]));
        //if(trigger.isupdate && trigger.isafter)Device_TriggerHelper.revokedeviceSharingAccess(json.serialize(trigger.new[0]),json.serialize(trigger.old[0]));
        helper.DeviceToERPDeviceDataFlow();//added by devendra
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
                      DevicePscPsautilcls - Class it will be used for PSCPSA project
    **********************************************************************************************************************************************************/   
    public override void beforeInsert(){
        if(!Test.isRunningTest()) helper.nameValidationForDevice();////added by devendra to validate device name
        helper.updateMaskSetTitle(); //added by devendra works only for Fab9/10/altis to autogenerate masksettitle        
        helper.deviceMaskSetTitleRec(); 
        
        helper.deviceForcastDateUpdt();
        helper.autopopulateDeviceFlds();
        helper.deviceChecklistBefore(); 
        helperV1.deviceupdatepscpsa(); 
        helper.updatGenerateStandardFrame();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
                      DevicePscPsautilcls - Class it will be used for PSCPSA project
    **********************************************************************************************************************************************************/ 
    public override void beforeUpdate(){
        if(!Test.isRunningTest()) helper.nameValidationForDevice();////added by devendra to validate device name
        helper.updateMaskSetTitle();//dnt allow the user to change        
        helper.deviceMaskSetTitleRec();
        helper.deviceForcastDateUpdt();
        helper.syncToBPM();
        helper.deviceUpdateBefore();
        helper.deviceOnholdDateUpdt();
        helper.deviceChecklistBefore();
        helperV1.deviceupdatepscpsa();
        helper.updatGenerateStandardFrame();
		helper.updateECCNColorInternalDev();
    }
}