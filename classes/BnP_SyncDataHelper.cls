/*************************************************************************************************************************************************************
@ Class:          BnP_SyncDataHelper
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        Helper class which consist of logics used in Opportunity Trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/

public with sharing class BnP_SyncDataHelper{
    public static void beforeUpdateOppMethod(List<Opportunity> UpdatedOpptyList, Map<Id,Opportunity> OldOpptyMap){
        List<Opportunity> oppToUpdList = new List<Opportunity>();
        List<Customer_Requirement__c> parentOptObjList = new List<Customer_Requirement__c>();
        List<Id> listOptionIds = new List<Id>();        
        for(Opportunity opp : UpdatedOpptyList){
            if((opp.Design_Win_Review_Status__c == 'Won' && OldOpptyMap!=null && OldOpptyMap.get(opp.id)!=null &&
             OldOpptyMap.get(opp.id).Design_Win_Review_Status__c != 'Won' && opp.Date_Design_Win_Approved__c != null) || 
             (opp.Design_Win_Review_Status__c == 'Won' && OldOpptyMap!=null && OldOpptyMap.get(opp.id)!=null &&
             OldOpptyMap.get(opp.id).Date_Design_Win_Approved__c == null && opp.Date_Design_Win_Approved__c != null)){
                oppToUpdList.add(opp);
            }
        }
        if(!oppToUpdList.isEmpty()){
            for(Opportunity oppToUpd : oppToUpdList){
                listOptionIds.add(oppToUpd.Option__c);
            }
        }
        if(!listOptionIds.isEmpty()){
            parentOptObjList = [SELECT id, Deliverable_Type__c, Node__c, Technology__c, Fab__c FROM Customer_Requirement__c WHERE ID IN :listOptionIds];
        }
        
        if(!parentOptObjList.isEmpty()){
            for (Customer_Requirement__c option : parentOptObjList){
                for(Opportunity oppToUpd : oppToUpdList){
                    if(option.id == oppToUpd.Option__c)
                    {                    
                        oppToUpd.Deliverable_Type__c = option.Deliverable_Type__c;
                        oppToUpd.Process_Geometry__c = option.Node__c;
                        oppToUpd.Target_Process_Node__c = option.Technology__c;
                        oppToUpd.Fab_Assignment_1__c = option.Fab__c;
                    }
                }
            }
        }
    }
    public static void afterUpdateDevMethod(List<Opportunity> UpdatedOpptyList, Map<Id,Opportunity> OldOpptyMap)
    {
        List<Opportunity> oppToUpdList = new List<Opportunity>();
        List<Customer_Requirement__c> parentOptObjList = new List<Customer_Requirement__c>();
        List<Id> listOptionIds = new List<Id>();
        List<Id> listOpportunityIds = new List<Id>(); //Added by Arijit
        
        for(Opportunity opp : UpdatedOpptyList)
        {
            if((opp.Design_Win_Review_Status__c == 'Won' && OldOpptyMap!=null && OldOpptyMap.get(opp.id)!=null && 
            OldOpptyMap.get(opp.id).Design_Win_Review_Status__c != 'Won' && opp.Date_Design_Win_Approved__c != null) ||
            (opp.Design_Win_Review_Status__c == 'Won' && OldOpptyMap!=null && OldOpptyMap.get(opp.id)!=null && 
            OldOpptyMap.get(opp.id).Date_Design_Win_Approved__c == null && opp.Date_Design_Win_Approved__c != null))
            {
                oppToUpdList.add(opp);
                listOpportunityIds.add(opp.Id);  //Added by Arijit
            }
        }
        if(!oppToUpdList.isEmpty())
        {
            for(Opportunity oppToUpd : oppToUpdList)
            {
                listOptionIds.add(oppToUpd.Option__c);
            }
        }
        
        if(!listOptionIds.isEmpty()){
            parentOptObjList = [SELECT id, Device__c, Deliverable_Type__c, Node__c, Technology__c, Fab__c, Opportunity__c  FROM Customer_Requirement__c WHERE ID IN :listOptionIds];
        }
        
        List<Device__c> parentDevObjList = new List<Device__c>();
        List<Id> listDevIds = new List<Id>();
        List<Device__c> devObjToUpdList = new List<Device__c>();
        
        if(!parentOptObjList.isEmpty()){
            for (Customer_Requirement__c option : parentOptObjList)
            {
                for(Opportunity oppToUpd : oppToUpdList)
                {
                    if(option.id == oppToUpd.Option__c)
                    {
                        listDevIds.add(option.Device__c);
                    }
                }
            }
        }
        
        if(!listDevIds.isEmpty()){
            parentDevObjList = [SELECT id, Deliverable_Type__c, Internal_Device_Geometry__c, Target_Process_Node__c, Fab__c FROM Device__c WHERE ID IN :listDevIds];
        }
        
        if(!parentDevObjList.isEmpty()){
            for(Device__c devToUpd : parentDevObjList)
            {
                for (Customer_Requirement__c option : parentOptObjList)
                {
                    if(devToUpd.id == option.Device__c)
                    {                    
                        devToUpd.Deliverable_Type__c = option.Deliverable_Type__c;
                        devToUpd.Internal_Device_Geometry__c = option.Node__c;
                        //devToUpd.Target_Process_Node__c = option.Technology__c; //Blocked by Arijit (Now TPN on device will be a Formula Field and Data will be coming from Opportunity)
                        devToUpd.Fab__c = option.Fab__c;
                        devObjToUpdList.add(devToUpd);
                    }
                }
            }
        }
        if(!devObjToUpdList.isEmpty())
        {
            update devObjToUpdList;            
        }
        // Add inactive logic for option here : Added by Arijit
        if(!listOpportunityIds.isEmpty())
        {                       
            List<Customer_Requirement__c> lstoption = new List<Customer_Requirement__c>();
            parentOptObjList.clear();  
            parentOptObjList = [SELECT  id
                                        , Device__c
                                        , Deliverable_Type__c
                                        , Node__c
                                        , Technology__c
                                        , Fab__c
                                        , Opportunity__c  
                                FROM    Customer_Requirement__c 
                                WHERE   Opportunity__c IN :listOpportunityIds];  
            
            for(Opportunity tempopportunity : oppToUpdList)
            {
                for(Customer_Requirement__c tempOption : parentOptObjList)
                {
                    Customer_Requirement__c propoption = new Customer_Requirement__c();
                    
                    if(tempopportunity.Id == tempOption.Opportunity__c)
                    {                                   
                        if((tempopportunity.Process_Geometry__c != tempOption.Node__c) && (tempopportunity.Target_Process_Node__c != tempOption.Technology__c) &&  (tempopportunity.Deliverable_Type__c != tempOption.Deliverable_Type__c))
                        {                           
                            propoption.Id = tempOption.Id;
                            propoption.Option_Status__c = 'Inactive';
                            lstoption.add(propoption);
                        }                       
                    }                
                }
            }
            update lstoption;
            //End of Inactive Logic
        }
    }
}