//Code modified by Sunil Arora on 12th July to update actual status in opportunity for case # 57379
public with sharing class DeviceGapUtilities
{
    // Method to update Parent Opportunity Status to Worst Issue Status based on Opportunity Issues related to the Opportunity
    public static void updateOpportunityStatus(List<Device_Gap__c> updateOpportunityIssueList, Boolean isDelete)
    {
        Set<Id> opportunityToUpdateSet = new Set<Id>();
        // Use List to set order of Issue Severity
        Map <String, Integer> issueSeverityMap = new Map<String, Integer>{'B -' => 0, 'G -' => 1, 'Y -' => 2, 'R1 -' => 3, 'R2 -' => 4, 'R3 -' => 5};
        Map<Id, Integer> opportunityIssuesNumberMap = new Map<Id, Integer>();
        Map<Id, Opportunity> opportunityToUpdateMap;
        
        String opportunityIssueStatus, opportunityStatus;
                        
        // Get all the list of opportunities from the trigger
        for (Device_Gap__c oc: updateOpportunityIssueList)
        {
            opportunityToUpdateSet.add(oc.Opportunity__c);
        }
        
        // Run the query to fetch all the opportunity information
        if (!opportunityToUpdateSet.isEmpty())
        {
            opportunityToUpdateMap = new Map<Id, Opportunity>([select Id, Demand_Factor__c, Worst_Issue_Status__c, Probability, Worst_Issue_Status_P__c, Prob_P__c from Opportunity where id in :opportunityToUpdateSet]);
        }
 
        // Run count for Opportunity Issues tied to Opportunity       
        for (AggregateResult ar : [Select Count(Id) numRecs, Opportunity__c oppId From Device_Gap__c Where Opportunity__c In :opportunityToUpdateSet Group By Opportunity__c])      
        {
            Id oppId = (Id) ar.get('oppId');
            opportunityIssuesNumberMap.put(oppId, (Integer) ar.get('numRecs'));
        }
        
        // If this was triggered by Delete Trigger select remaining instead and recalculate Opportunity Status
        if (isDelete)
        {   
            // Reset all the opportunity status
            for (Opportunity o: opportunityToUpdateMap.Values())
            {
                o.Worst_Issue_Status__c =  null;
                o.Demand_Factor__c = null;
                opportunityToUpdateMap.put(o.Id, o);   
            }

            updateOpportunityIssueList = [SELECT ID, Area__c, Opportunity__c, Select_Status__c,Previous_Status__c FROM Device_Gap__c Where Opportunity__c In :opportunityToUpdateSet];       
        }
        
        //Code modified by Sunil Arora on 12th July to update actual status in opportunity for case # 57379
        String status='';
        List<Integer> statusIntegerList=new List<integer>();
        Map<Integer,String> selectStatusOpportunityMap=new Map<Integer,String>();
        List<Integer> prevstatusIntegerList=new List<integer>();
        Map<Integer,String> prevStatusOpportunityMap=new Map<Integer,String>();
        List<Device_Gap__c> opportunityIssueList = [SELECT ID, Area__c, Opportunity__c, Select_Status__c,Previous_Status__c FROM Device_Gap__c Where Opportunity__c In :opportunityToUpdateSet]; 
        for (Integer i=0;i<opportunityIssueList.size();i++){
            Integer statusIntegerValue=issueSeverityMap.get(opportunityIssueList[i].Select_Status__c.SubString(0,opportunityIssueList[i].Select_Status__c.indexOf(' -')+2));
            statusIntegerList.add(statusIntegerValue);            
            selectStatusOpportunityMap.put(statusIntegerValue,opportunityIssueList[i].Select_Status__c);  
            
            if(opportunityIssueList[i].Previous_Status__c != null){
                Integer prevStatVal = issueSeverityMap.get(opportunityIssueList[i].Previous_Status__c.SubString(0,opportunityIssueList[i].Previous_Status__c.indexOf(' -')+2));
                prevstatusIntegerList.add(prevStatVal);
                prevStatusOpportunityMap.put(prevStatVal,opportunityIssueList[i].Previous_Status__c);  
            }
        }

        // Set the list of opportunity to update based on the worst issue in the Opportunity Issue
        for (Device_Gap__c oc: updateOpportunityIssueList)
        {
            // Get Opportunity for Opportunity Issue
            Opportunity o = opportunityToUpdateMap.get(oc.Opportunity__c);
            opportunityIssueStatus = oc.Select_Status__c;
            opportunityStatus = o.Worst_Issue_Status__c;
             
             //Code modified by Sunil Arora on 12th July to update actual status in opportunity for case # 57379
             statusIntegerList.sort();
             prevstatusIntegerList.sort();
            // Handle null opportunity status, opportunity with 1 opportunity issue and opportunity with multiple opportunity issues 
            if (o.Worst_Issue_Status__c == null ||
                opportunityIssuesNumberMap.get(o.Id) == 1 || o.Worst_Issue_Status__c!= selectStatusOpportunityMap.get(statusIntegerList[statusIntegerList.size()-1])){
                    o.Worst_Issue_Status__c = selectStatusOpportunityMap.get(statusIntegerList[statusIntegerList.size()-1]);                
                }
            
            if(prevstatusIntegerList.size() > 0){
                if (o.Worst_Issue_Status_P__c == null ||
                    opportunityIssuesNumberMap.get(o.Id) == 1 || o.Worst_Issue_Status_P__c!= prevStatusOpportunityMap.get(prevstatusIntegerList[prevstatusIntegerList.size()-1])){
                        o.Worst_Issue_Status_P__c = prevStatusOpportunityMap.get(prevstatusIntegerList[prevstatusIntegerList.size()-1]);                
                 }
             }
            // Handle updating of Blocking Factor
            if(o.Demand_Factor__c == null)
                o.Demand_Factor__c = oc.Area__c;
            else
            {
                // Does not contain the area picklist value, add it to the list
                if(oc.Area__c != null){
                    if (!o.Demand_Factor__c.contains(oc.Area__c))
                    {
                        o.Demand_Factor__c = o.Demand_Factor__c + ';' + oc.Area__c;
                    }
                }
            }  
            //o.Prob_P__c = o.Probability;
            //o.Worst_Issue_Status_P__c = o.Worst_Issue_Status__c;                 
            opportunityToUpdateMap.put(o.Id, o);    
        }
        
        List <Opportunity> opportunityToUpdateList = opportunityToUpdateMap.Values();
        update opportunityToUpdateList;
        
        //Updated by Arijit: Update Opportunity with SUM(Improve_Prob__c) from Opportunity Issue
        List <Opportunity> LstOppForTotalImprov = new List <Opportunity>();     
        for (AggregateResult dgar : [SELECT Opportunity__c oppId , SUM(Improve_Prob__c) ImproveProb FROM Device_Gap__c Where Opportunity__c In :opportunityToUpdateSet Group by Opportunity__c])      
        {
            Id oppId = (Id)dgar.get('oppId');
            Decimal totalProbValue = (Decimal)dgar.get('ImproveProb');
            Opportunity listOpp = new Opportunity();
            listOpp.Id = oppId;
            listOpp.Total_Improvement_Percentage__c = totalProbValue;
            LstOppForTotalImprov.add(listOpp);
        }
        update LstOppForTotalImprov;
        //End
    }
    
    public static Map<Id, Id> getOppToOppProgMap(List<Device_Gap__c> oppIssueList)
    {
        Set<Id> opportunitiesSet = new Set<Id>();
        Map<Id, Opportunity_Program__c> opportunityProgramMap = new Map<Id, Opportunity_Program__c>();
        Map<Id, Id> oppToOppProgramMap = new Map<Id, Id>();
        
        for (Device_Gap__c dg: oppIssueList)
        {
            opportunitiesSet.add(dg.Opportunity__c);
        }
    
        if (!opportunitiesSet.isEmpty())
        {
            opportunityProgramMap = new Map<Id, Opportunity_Program__c>([select Id, Opportunity__c from Opportunity_Program__c where Opportunity__c in :opportunitiesSet]);
        }
        
        for (Opportunity_Program__c opp: opportunityProgramMap.Values())
        {
            oppToOppProgramMap.put(opp.Opportunity__c, opp.Id);    
        }
 
        return oppToOppProgramMap;
    }
    
}