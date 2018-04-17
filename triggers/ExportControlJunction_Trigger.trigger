/*************************************************************************************************************************************************************
@ Class:          ExportControlJunction_Helper
@ Version:        1.0
@ Author:         Devendra
@ Purpose:        This Handler class is handling the events of ExportControlJunction Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 20.09.2017 / Devendra / created
**************************************************************************************************************************************************************/
trigger ExportControlJunction_Trigger on Device_Export_Control_Junction__c (after update) {
    new ExportControlJunction_Handler().run();                
}