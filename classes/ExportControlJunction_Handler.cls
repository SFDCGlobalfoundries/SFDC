/*************************************************************************************************************************************************************
@ Class:          ExportControlJunction_Handler
@ Version:        1.0
@ Author:         Devendra
@ Purpose:        This Handler class is handling the events of ExportControlJunction Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 20.09.2017 / Devendra / created
**************************************************************************************************************************************************************/
public class ExportControlJunction_Handler extends TriggerHandler{
    public ExportControlJunction_Helper helper { get; set; } 
    
    public ExportControlJunction_Handler(){
        helper = new ExportControlJunction_Helper();
    }
    
   
   public override void afterUpdate(){
        
        helper.handleafterUpdate();
    }
    
    
}