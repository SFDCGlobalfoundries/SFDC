/*************************************************************************************************************************************************************
@ Class:          Device_TriggerHelper_Version2
@ Version:        1.0
@ Author:         Anirban Roy 
@ Purpose:        This helper class is handling the events of Device Triggers when Opportunity and Opportunity Program is changed.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 21.05.2017 / Anirban Roy / Created the class.
**************************************************************************************************************************************************************/

public class Device_TriggerHelper_Version2{
    
    public static Boolean hasRun=false;
    public List<Device__c> triggerNew  { get; set; } //Map to store old record values of Device object
    public Map<Id,Device__c> triggerOldMap { get; set; } //Map to store New record values of Device object 
    
    public Device_TriggerHelper_Version2(){
        triggerNew = ((List<Device__c>)Trigger.new);
        triggerOldMap = ((Map<Id,Device__c>)Trigger.oldMap);
    }
    
    //Called from Device_TriggerHandler class on after update context
    public void runOnChangeOppInDevice(){
        if(Trigger.isUpdate && Trigger.isAfter && !hasRun){
            List<Id> devIds = new List<Id>();
            for(Device__c d : triggerNew){
                if(d.Opportunity__c!=triggerOldMap.get(d.id).Opportunity__c 
                    || d.Opportunity_Program__c!=triggerOldMap.get(d.id).Opportunity_Program__c){
                    devIds.add(d.id);   
                }
            }
            system.debug('test ==>'+devIds);
            if(devIds.size()>0){
                deviceUpate(devIds);
            }
            
            hasRun=true;
        }
    }
    
    // Operations to be handled by future call
    @future
    public static void deviceUpate(List<Id> deviceIds){
        Map<Id,Device__c> devNewMap = new Map<Id,Device__c>([select id,Opportunity__c,Opportunity_Program__c from Device__c where id in :deviceIds]);       
        Map<Id,List<Id>> oppDevMap = new Map<Id,List<Id>>();
        List<Form_Management_System__c> fmsList = new List<Form_Management_System__c>();
        List<Apttus_Proposal__Proposal__c> configList = new List<Apttus_Proposal__Proposal__c>();
        Set<Id> fmsIds = new Set<Id>();
        
        for(Form_Management_System__c f :[select    id
                                                    ,Opportunity__c
                                                    ,Opportunity_Program__c
                                                    ,device__c 
                                          from      Form_Management_System__c
                                          where     Device__c in :devNewMap.keySet()]){
            f.Opportunity__c = devNewMap.get(f.device__c).Opportunity__c;
            f.Opportunity_Program__c = devNewMap.get(f.device__c).Opportunity_Program__c;
            if(oppDevMap.containsKey(f.Opportunity_Program__c)){
                oppDevMap.get(f.Opportunity_Program__c).add(f.device__c);    
            }else{
                oppDevMap.put(f.Opportunity_Program__c,new List<Id>{f.device__c});
            }
            fmsList.add(f);
            fmsIds.add(f.id);    
        }
        if(fmsList.size()>0){
            update fmsList;
        }
        for(Apttus_Proposal__Proposal__c config : [select    id
                                                             , Apttus_Proposal__Opportunity__c
                                                             , Device__c
                                                             , FMS_Proposal__c
                                                   from      Apttus_Proposal__Proposal__c
                                                   where     FMS_Proposal__c in :fmsIds
                                                  ]){
            config.Apttus_Proposal__Opportunity__c = devNewMap.get(config.device__c).Opportunity__c;
            configList.add(config);            
        }
        if(configList.size()>0){
            update configList;
        }
        
        if(!oppDevMap.isEmpty()){
            List<Device__Share> shareDevices = new List<Device__Share>();
            for(Opportunity_Program_Team_Member__c optm : [select    id
                                                                     , Device_Access__c
                                                                     , User__c
                                                                     , Opportunity_Program__c
                                                           from      Opportunity_Program_Team_Member__c
                                                           where     Opportunity_Program__c in :oppDevMap.keySet()
                                                          ]){
                for(Id devId : oppDevMap.get(optm.Opportunity_Program__c)){
                    Device__Share rec = new Device__Share();
                    rec.AccessLevel = (optm.Device_Access__c=='Read Only')?'Read':'Edit';
                    rec.ParentId = devId;
                    rec.RowCause = Schema.Device__Share.RowCause.Opportunity_Program_Team__c;
                    rec.UserOrGroupId = optm.User__c;
                    shareDevices.add(rec); 
                }
            }
            if(shareDevices.size()>0){
                insert shareDevices;
            }
        }
    }    
    
}