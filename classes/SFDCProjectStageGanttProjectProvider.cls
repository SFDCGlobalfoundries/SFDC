public class SFDCProjectStageGanttProjectProvider implements GanttProjectProvider
{
    
    
    public SFDCProjectStageGanttProjectProvider()
    {
        
    }
    
    public List<GanttProject> getProjects()
    {
        return null;
    }

    public List<GanttProject> getProjects(String id)
    {
        List<GanttProject> projects = new List<GanttProject>();
        Map<String,GanttProject> projMap = new Map<String,GanttProject>();
        Map<String,GanttActivity> actMap = new Map<String,GanttActivity>();
        GanttProject project = null;
        GanttActivity activity = null;
        GanttActivityTask task = null;
        
        List<SFDC_Task__c> stages = [SELECT 
                                                 T.Id, T.Name,T.Task_Name__c, T.Start_Date__c, T.Due_Date__c,
                                                 T.Milestone__r.Id, T.Milestone__r.Name,T.Milestone__r.Name__c,
                                                 T.Milestone__r.Implement_Name__c,
                                                  T.Milestone__r.Start_Date__c, T.Milestone__r.End_Date__c,T.Milestone__r.Chart_Color__c,
                                                 T.Milestone__r.Stage__r.Id, T.Milestone__r.Stage__r.Name, T.Milestone__r.Stage__r.Name__c, T.Milestone__r.Stage__r.Start_Date__c, T.Milestone__r.Stage__r.End_Date__c,
                                                 T.Milestone__r.Stage__r.SFDC_Project__r.Id
                                                 from SFDC_Task__c T where T.Milestone__r.Stage__r.Id = :id
                                                 order by T.Start_Date__c LIMIT 500];
                                                 
        for(SFDC_Task__c m:stages)
        {
           project = projMap.get(m.Milestone__r.Stage__r.Id);
           if(project == null)
           {
              project = new GanttProject();
              project.Id = m.Milestone__r.Stage__r.Id;
              project.Name = m.Milestone__r.Stage__r.Name__c;
              project.Description = '';
              projMap.put(m.Milestone__r.Stage__r.Id,project);
              projects.add(project);
           }
           activity = actMap.get(m.Milestone__r.Id);
           if(activity == null)
           {
               activity = new GanttActivity();
               activity.Id = m.Milestone__r.Id;
               if( m.Milestone__r.Stage__r.Name__c == SFDCConstants.IMPLEMENTATION_STAGE)
               {
                   activity.Name = m.Milestone__r.Implement_Name__c;
               }else
               {
                   activity.Name = m.Milestone__r.Name__c;
               }
             
               activity.StartDate = m.Milestone__r.Start_Date__c;
               activity.EndDate = m.Milestone__r.End_Date__c;
               actMap.put(m.Milestone__r.Id,activity);
               project.addActivity(activity);
           }
           
           task = new GanttActivityTask();
           task.Id = m.Id; 
           task.Name = m.Task_Name__c; 
           task.StartDate = m.Start_Date__c; 
           task.EndDate = m.Due_Date__c;
           task.CSSClass = toCSSClass(m.Milestone__r.Chart_Color__c);
           activity.addTask(task);
           
        }
        
        projects.sort();
        return projects;
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