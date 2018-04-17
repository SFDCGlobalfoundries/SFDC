public class SFDCPortfolioGanttProjectProvider implements GanttProjectProvider
{
    
    
    public SFDCPortfolioGanttProjectProvider()
    {
        
    }
    
    public List<GanttProject> getProjects(String id)
    {
        return null;
    }

    public List<GanttProject> getProjects()
    {
        List<GanttProject> projects = new List<GanttProject>();
        
        Map<String,GanttProject> projMap = new Map<String,GanttProject>();
        Map<String,GanttActivity> actMap = new Map<String,GanttActivity>();
        GanttProject project = null;
        GanttActivity activity = null;
        GanttActivityTask task = null;
        
        List<SFDC_Project_Milestone__c> milestones = [SELECT M.Id, M.Name,M.Name__c,M.Implement_Name__c, M.Start_Date__c, M.End_Date__c,M.Chart_Color__c,
                                                 M.Stage__r.Id, M.Stage__r.Name, M.Stage__r.Name__c, M.Stage__r.Start_Date__c, M.Stage__r.End_Date__c,
                                                 M.Stage__r.SFDC_Project__r.Id,M.Stage__r.SFDC_Project__r.Name,M.Stage__r.SFDC_Project__r.Description__c
                                                 from SFDC_Project_Milestone__c M order by M.Start_Date__c LIMIT 500];
                                                 
        for(SFDC_Project_Milestone__c m:milestones)
        {
           project = projMap.get(m.Stage__r.SFDC_Project__r.Id);
           if(project == null)
           {
              project = new GanttProject();
              project.Id = m.Stage__r.SFDC_Project__r.Id;
              project.Name = m.Stage__r.SFDC_Project__r.Name;
              project.Description = m.Stage__r.SFDC_Project__r.Description__c;
              projMap.put(m.Stage__r.SFDC_Project__r.Id,project);
              projects.add(project);
           }
           activity = actMap.get(M.Stage__r.Id);
           if(activity == null)
           {
               activity = new GanttActivity();
               activity.Id = m.Stage__r.Id;
               activity.Name = M.Stage__r.Name__c;
               activity.StartDate = M.Stage__r.Start_Date__c;
               activity.EndDate = M.Stage__r.End_Date__c;
               actMap.put(M.Stage__r.Id,activity);
               project.addActivity(activity);
           }
           
           task = new GanttActivityTask();
           task.Id = m.Id; 
           if(M.Stage__r.Name__c == 'Implementation')
           {
              task.Name = m.Implement_Name__c;
           }else
           {
              task.Name = m.Name__c; 
           }
          
           task.StartDate = m.Start_Date__c; 
           task.EndDate = m.End_Date__c;
           task.CSSClass = toCSSClass(m.Chart_Color__c);
           if((task.StartDate != null)&&(task.EndDate != null))
               activity.addTask(task);
           
        }
        
        for(GanttProject gp:projects)
        {
            gp.removeEmptyActivities();
        }
        
       
        
        List<GanttProject> rlist = new List<GanttProject>();
        for(GanttProject gp:projects)
        {
           if(!gp.isEmpty())
           {
               rlist.add(gp);
           }
        }
        
        projMap.clear();
        for(GanttProject gp:rlist)
        {
          projMap.put(gp.Id,gp);
        }
        
         List<SFDC_Project_Stage__c> stages = [SELECT M.Id, M.Name, M.Name__c, M.Start_Date__c, M.End_Date__c,
                                                 M.SFDC_Project__r.Id,M.SFDC_Project__r.Name,M.SFDC_Project__r.Description__c
                                                 from SFDC_Project_Stage__c M where M.Start_Date__c != null
                                                 and M.End_Date__c != null
                                                 order by M.Start_Date__c LIMIT 500];
                                                 
        for(SFDC_Project_Stage__c m:stages)
        {
            project = projMap.get(m.SFDC_Project__r.Id);
           if(project == null)
           {
              project = new GanttProject();
              project.Id = m.SFDC_Project__r.Id;
              project.Name = m.SFDC_Project__r.Name;
              project.Description = m.SFDC_Project__r.Description__c;
              projMap.put(m.SFDC_Project__r.Id,project);
              projects.add(project);
              rlist.add(project);
           }
           activity = actMap.get(M.Id);
           if(activity == null)
           {
               activity = new GanttActivity();
               activity.Id = m.Id;
               activity.Name = M.Name__c;
               activity.StartDate = M.Start_Date__c;
               activity.EndDate = M.End_Date__c;
               actMap.put(M.Id,activity);
               project.addActivity(activity);
               
               task = new GanttActivityTask();
               task.Id = m.Id;
               task.Name = m.Name__c;
               task.StartDate = m.Start_Date__c; 
               task.EndDate = m.End_Date__c;
               task.CSSClass = 'ganttOrange';
               activity.addTask(task);
           }
  
           
        }
        
        rlist.sort();
        
        return rlist;
    }
    
    
    
    private String toCSSClass(String id)
    {
       if(id != null)
       {
          if(id == 'Blue')
          {
             return 'ganttBlue';
          }else if(id == 'Green')
          {
             return 'ganttGreen';
          }else if(id == 'Orange')
          {
             return 'ganttOrange';
          }
       }
       return 'ganttRed';
    }

}