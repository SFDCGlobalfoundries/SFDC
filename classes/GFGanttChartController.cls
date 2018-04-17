public class GFGanttChartController
{
    public String Id {get;set;}
    private String projectLabel = null;
    private String activityLabel = null;
    public String Provider {get;set;}
    private List<GanttProject> projects = null;
    
    public void setProjectLabel(String str){projectLabel = str;}
    public void setActivityLabel(String str){activityLabel = str;}
    public String getProjectLabel()
    {
       if(projectLabel == null)
       {
           projectLabel = 'Project';
       }
       return projectLabel;
    }
    
    public String getActivityLabel()
    {
        if(activityLabel == null)
        {
            activityLabel = 'Stage';
        }
        return activityLabel;
    }
    
    
    public GFGanttChartController()
    {
       Provider = 'SFDCPortfolioGanttProjectProvider';
      
    }
    
     public List<GanttProject> getGanttProjects()
     {
     
       if(projects == null)
       {
          GanttProjectProvider projectProvider = (GanttProjectProvider)GanttChartFactory.newInstance(Provider);
          if(projectProvider != null)
          {
             if(Id != null)
             {
                 projects = projectProvider.getProjects(Id);
             }else
             {
                 projects = projectProvider.getProjects();
             }
          }
       }
         
       return projects;
     }
     
    
    




}