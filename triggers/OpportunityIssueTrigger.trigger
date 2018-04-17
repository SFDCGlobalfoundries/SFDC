// Trigger to update Opportunity Record with Worst Issue Status

trigger OpportunityIssueTrigger on Device_Gap__c (before insert, before update, after insert, after update, after delete, after undelete) 
{
    Map<Id, Id> oppToOppProgramMap = new Map<Id, Id> ();

    if(!IntegrationUserUtil.isSkipTrigger()){
    
        if(Trigger.isAfter)
        {
            // Call Utility Method to Update Opportunity Worst Issue Status
            if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)
            {
                DeviceGapUtilities.updateOpportunityStatus(Trigger.New, false); 
            }
            else
            {
                DeviceGapUtilities.updateOpportunityStatus(Trigger.Old, true);
            } 
        }
        else
        {
            // Insert or Update we will get the Opportunity Program and Set it
            oppToOppProgramMap = DeviceGapUtilities.getOppToOppProgMap(Trigger.New);
            
            if (Trigger.isUpdate)
            {
                // Set Previous Values
                for (Device_Gap__c dg: Trigger.New)
                {
                  // code commented to remove the functionality               
                
                    if (dg.Improve_Prob__c <> Trigger.OldMap.get(dg.Id).Improve_Prob__c)
                        dg.Improve_Prob_P__c = Trigger.OldMap.get(dg.Id).Improve_Prob__c;
                    
                    if (dg.Select_Status__c <> Trigger.OldMap.get(dg.Id).Select_Status__c)
                        dg.Previous_Status__c = Trigger.OldMap.get(dg.Id).Select_Status__c;
                    
                    if (dg.Action_Close_Date__c <> Trigger.OldMap.get(dg.Id).Action_Close_Date__c)
                        dg.Action_Close_Date_P__c = Trigger.OldMap.get(dg.Id).Action_Close_Date__c;
                        
                    dg.Opportunity_Program__c = oppToOppProgramMap.get(dg.Opportunity__c);    
                }
            }
            else
            {
                for (Device_Gap__c dg: Trigger.New)
                {
                    dg.Opportunity_Program__c = oppToOppProgramMap.get(dg.Opportunity__c);          
                }
            }
        }
    }
}