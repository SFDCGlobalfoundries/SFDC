public class RTATMilestoneEditDelete extends RTATMilestoneAdjustment {
    // Author: Elizabeth Button
    // Function: Used by VisualForce page RTATMilestoneEditDelete.vfp when a user tries to update or delete 
    //           a RTAT_Sched_TAT_Adjust__c object (aka RTAT Milestone Adjust)
    // This is a part of the RTAT Schedule Admin app    
    // Created April 24th, 2017      
    
    
    //   
   public RTATMilestoneEditDelete(ApexPages.StandardController controller)
    {
        this.MilestoneTAT = (RTAT_Sched_TAT_Adjust__c) controller.getRecord();
        RTAT_Sched_TAT_Adjust__c myMilestone = [SELECT Id, Parent_Waf_Fab_Schedule__c FROM RTAT_Sched_TAT_Adjust__c 
                                                                WHERE Id = :this.MilestoneTAT.Id  LIMIT 1];
        this.parentID = myMilestone.Parent_Waf_Fab_Schedule__c;
    }
    //end new addition
    //
    
    public override List<RTAT_Sched_TAT_Adjust__c> getMilestones()
    {
        //this.parentID = ApexPages.currentPage().getParameters().get('id');    
        
        MilestoneTATs = [SELECT Name, Process__c,Subprocess__c,Subprocess_TAT__c,Total_TAT__c,End_Date__c,addDays__c, Adjustable_TAT__c, Parent_Waf_Fab_Schedule__c, Location_Name__c FROM RTAT_Sched_TAT_Adjust__c 
                                                                WHERE Parent_Waf_Fab_Schedule__c = :this.parentID  ORDER BY Name ASC LIMIT 50];
        return MilestoneTATs;                                                        
    }
    public override RTAT_Wafer_Fab_Schedule_Inputs__c getWafFabSched()
    {
        RTAT_Wafer_Fab_Schedule_Inputs__c wfsi = [SELECT Name, Id FROM RTAT_Wafer_Fab_Schedule_Inputs__c WHERE Id = :this.parentID LIMIT 1];
          
         return wfsi;
    } 
    
}