/*
Type Name: RTATMilestoneAdjustment
Author: Elizabeth Button
*/   
public virtual class RTATMilestoneAdjustment{
    
    // This needs a header and exception handling for the updates
  public List<RTAT_Wafer_Fab_Schedule_Inputs__c> wfsInputs;
    
    public List<RTAT_Sched_TAT_Adjust__c> MilestoneTATs;
    public RTAT_Sched_TAT_Adjust__c MilestoneTAT; 
    public String parentID;
    
    public virtual List<RTAT_Sched_TAT_Adjust__c> getMilestones()
    {
        this.parentID = ApexPages.currentPage().getParameters().get('id');    
        
        MilestoneTATs = [SELECT Name, Process__c,Subprocess__c,Subprocess_TAT__c,Total_TAT__c,End_Date__c,addDays__c, Adjustable_TAT__c, Parent_Waf_Fab_Schedule__c, Location_Name__c FROM RTAT_Sched_TAT_Adjust__c 
                                                                WHERE Parent_Waf_Fab_Schedule__c = :this.parentID  ORDER BY Name ASC LIMIT 50];
        return MilestoneTATs;                                                        
    }
    public void setMilestones(List<RTAT_Sched_TAT_Adjust__c> adjTATs)
    {
        this.MilestoneTATs = adjTATs;
      
    }  
    public virtual RTAT_Wafer_Fab_Schedule_Inputs__c getWafFabSched()
    {
        this.parentID = ApexPages.currentPage().getParameters().get('id');    
         RTAT_Wafer_Fab_Schedule_Inputs__c wfsi = [SELECT Name, Id FROM RTAT_Wafer_Fab_Schedule_Inputs__c WHERE Id = :this.parentID LIMIT 1];
          
         return wfsi;
    }
    public void save()
    {     
    }    
    public void junk()
    {
        this.parentId = 'junk';
        this.MilestoneTAT = new RTAT_Sched_TAT_Adjust__c();
    }
    public void junky()
    {
        this.parentId = 'junky';
        this.MilestoneTAT = new RTAT_Sched_TAT_Adjust__c();
    }
    public void junk2()
    {
        this.parentId = 'junk';
        this.MilestoneTAT = new RTAT_Sched_TAT_Adjust__c();
    }
    public void junk3()
    {
        this.parentId = 'junky';
        this.MilestoneTAT = new RTAT_Sched_TAT_Adjust__c();
    }
    public void junk4()
    {
        this.parentId = 'junky4';
        this.MilestoneTAT = new RTAT_Sched_TAT_Adjust__c();
    }
    
    public void adjust()
    {
        List<RTAT_Fab_Shutdown_Date__c> listShutDownDays;
        // Assuming location BTV for now
        ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.INFO, 'Schedule adjusted!'));
        for (Integer ii = 0; ii < MilestoneTATs.size(); ii++)
        {
            //get each milestone, then add to the total for the milestone
            MilestoneTAT = MilestoneTATs.get(ii);
            if (MilestoneTAT.addDays__c <> 0)
            {
                if (String.isBlank( MilestoneTAT.Subprocess__c ))
                {
                    MilestoneTAT.Total_TAT__c = MilestoneTAT.Total_TAT__c + MilestoneTAT.addDays__c;
                }
                else
                {   
                   MilestoneTAT.Subprocess_TAT__c = MilestoneTAT.Subprocess_TAT__c + MilestoneTAT.addDays__c;
                } 
                
                MilestoneTAT.addDays__c = 0;
                MilestoneTATs.set(ii, MilestoneTAT);
            }
            
        }
        //update MilestoneTATs;
        
        //get the first milestone's start date and set the totat TAT to zero
        MilestoneTAT = MilestoneTATs.get(0);
        Date ScheduleStartDate = MilestoneTAT.End_Date__c;
        Double dTotalTAT = 0;
        Double dTotalSubProcTAT = 0;
        
        for (Integer jj = 1; jj < MilestoneTATs.size(); jj++)
        {
            MilestoneTAT = MilestoneTATs.get(jj);
            
            if (MilestoneTAT.End_Date__c  != null)
            {
                //This is a stand alone milestone, so add the milestone's TAT to the total
                if (String.isBlank(MilestoneTAT.Subprocess__c))
                {
                    dTotalTAT = dTotalTAT + MilestoneTAT.Total_TAT__c;
                    
                }
                else  //Totaling milestone, add the submilestones total time
                {
                    dTotalTAT = dTotalTAT + dTotalSubProcTAT;
                    MilestoneTAT.Total_TAT__c = dTotalSubProcTAT;
                    dTotalSubProcTAT = 0;  //reset it back to zero
                }
                
                Date varEndDate = ScheduleStartDate.addDays(dTotalTAT.intValue());
                Date varStartDate = varEndDate.addDays(-(MilestoneTAT.Total_TAT__c.intValue()));
                // --------insert the shutdown subroutine below here --------------
                listShutDownDays = [SELECT Shutdown_date__c, Site__c  FROM RTAT_Fab_Shutdown_Date__c WHERE ((Shutdown_date__c >= :varStartDate) and  (Shutdown_date__c <= :varEndDate) and (Site__c = :MilestoneTAT.Location_Name__c))
                                                         ORDER BY Shutdown_date__c ASC LIMIT 20];
                
                //System.debug(listShutDownDays); 
                if (listShutDownDays.size() > 0)
                {
                    RTAT_Fab_Shutdown_Date__c shutdownDay = listShutDownDays.get(0);
                    Date fabClosedDate = shutdownDay.Shutdown_date__c;
                    while (listShutDownDays.size() > 0)
                    {
                         varEndDate = varEndDate.addDays(1);
                         MilestoneTAT.Total_TAT__c = MilestoneTAT.Total_TAT__c + 1;
                         dTotalTAT = dTotalTAT + 1;
                         fabClosedDate = fabClosedDate.addDays(1);
                         //lookup the next day in the list
                         listShutDownDays = [SELECT Shutdown_date__c, Site__c  FROM RTAT_Fab_Shutdown_Date__c WHERE ((Shutdown_date__c = :fabClosedDate) and (Site__c = :MilestoneTAT.Location_Name__c))
                                                         ORDER BY Shutdown_date__c ASC LIMIT 1];
                                    
                    }
                    
                }
                
                //Set the MilestoneTAT end date 
                MilestoneTAT.End_Date__c = varEndDate;
                
                MilestoneTATs.set(jj, MilestoneTAT);
            }
            // No end date?  then this is a subprocess.
            else
            {
                dTotalSubProcTAT = dTotalSubProcTAT + MilestoneTAT.Subprocess_TAT__c;
            }    
        }           
        update MilestoneTATs;
        return; 
    } 
}