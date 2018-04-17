/*************************************************************************************************************************************************************
@ Trigger:        User_Trigger
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This trigger fires on User after creating or editing the Users in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
trigger User_Trigger on User (Before insert, Before update, after insert, after update) {
    if(!managerUpdater.executed){
        system.debug('----Test Trigger for User---');
        new User_TriggerHandler().run();          
    }    
}