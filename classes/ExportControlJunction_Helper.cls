/*************************************************************************************************************************************************************
@ Class:          ExportControlJunction_Helper
@ Version:        1.0
@ Author:         Devendra
@ Purpose:        This Handler class is handling the events of ExportControlJunction Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 20.09.2017 / Devendra / created
**************************************************************************************************************************************************************/
public class ExportControlJunction_Helper{
    
   public void handleafterUpdate(){
        set<string> recIdSet=new set<string>();
       Map<Id,Device_Export_Control_Junction__c> triggerNewMap = ((Map<Id,Device_Export_Control_Junction__c>)Trigger.newMap);
       Map<id,Device_Export_Control_Junction__c> juncList=new Map<id,Device_Export_Control_Junction__c>([select id,
                                                                                                         Status__c,
                                                                                                         Export_Control_Form__r.ITAR_Product__c,
                                                                                                         Export_Control_Form__r.ECCN_Technology__c,
                                                                                                         Export_Control_Form__r.ECCN_Wafer__c,
                                                                                                         Device__c,
                                                                                                         Device__r.ECCN_Wafer__c,
                                                                                                         Device__r.ECCN_Technology__c,
                                                                                                         Device__r.ITAR_Flag__c                                                                                                          
                                                                                                         from Device_Export_Control_Junction__c
                                                                                                         where id IN : triggerNewMap.keyset()
                                                                                                        ]);
       List<Device__c> deviceToUpdate=new List<Device__c>();
       for(Device_Export_Control_Junction__c junc:juncList.values()){
           if(junc.Status__c!=null && junc.Status__c.equalsIgnorecase('Approved')){
                Device__c d=new Device__c(id=junc.Device__c);
                d.ECCN_Wafer__c=junc.Export_Control_Form__r.ECCN_Wafer__c;
                d.ECCN_Technology__c=junc.Export_Control_Form__r.ECCN_Technology__c;
                d.ITAR_Flag__c=junc.Export_Control_Form__r.ITAR_Product__c;
                deviceToUpdate.add(d);
            }
        }
       //try{
        if(!deviceToUpdate.isempty())ExportControlJunction_Helper.UpdateECCNdata(JSON.serialize(deviceToUpdate));
       //}catch(Exception E){
           //GlobalUtility.logMessage('Error','ExportControlJunction_Helper','handleafterUpdate','','Exception while running method',String.valueof(e.getMessage()),'','DEV',e,0);
       //}
    }
    
     @future
    public static void UpdateECCNdata(string devJson){
        try{
        List<Device__c> devToUpdate =(List<Device__c>)(Json.deserialize(devJson,Device__c.class));
        if(!devToUpdate.isEmpty())update devToUpdate;
        }catch(Exception E){
           GlobalUtility.logMessage('Error','ExportControlJunction_Helper','handleafterUpdate','','Exception while running method',String.valueof(e.getMessage()),'','DEV',e,0);
        }
        
    }
    
    
}