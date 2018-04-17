public class GanttActivity
{
    private List<GanttActivityTask> tasks = null;
    public String Id{get;set;}
    public String Name{get;set;}
    public Date StartDate{get;set;}    
    public Date EndDate{get;set;}    
    public String Description{get;set;}
        
    public List<GanttActivityTask> getTasks()
    {
       if(tasks == null)
       {
           tasks = new List<GanttActivityTask>();
       }
        return tasks;
    }
    
    public Boolean isEmpty()
    {
        return getTasks().size() == 0;
    }
    
    public void setTasks(List<GanttActivityTask> tasks)
    {
       this.tasks = tasks;
    }
    
    public void addTask(GanttActivityTask task)
    {
        getTasks().add(task);
    }


}