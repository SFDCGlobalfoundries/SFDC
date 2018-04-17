public class GFGanttController
{
    public String Provider {get;set;}
    public String ProjectLabel{get;set;}
    public String ActivityLabel{get;set;}
    private List<GanttProject> projects = null;
    
    public GFGanttController()
    {
       Provider = 'SFDCPortfolioGanttProjectProvider';
       ProjectLabel = 'Project';
       ActivityLabel = 'Stage';
    }
    
    public List<GanttProject> getGanttProjects()
     {
     
       if(projects == null)
       {
          GanttProjectProvider projectProvider = (GanttProjectProvider)ApexObjectFactory.newInstance(Provider);
          if(projectProvider != null)
          {
             projects = projectProvider.getProjects();
          }
       }
         
       return projects;
     }
     
    
    




}