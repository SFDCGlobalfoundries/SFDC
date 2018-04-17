public class GanttProject implements Comparable
{
    private List<GanttActivity> activities = null;
    public String Id {get;set;}    
    public String Name{get;set;}
    public String Description{get;set;}
    
    public List<GanttActivity> getActivities()
    {
       if(activities == null)
       {
          activities = new List<GanttActivity>();
       }
       return activities;
    }
    
    public Boolean isEmpty()
    {
        return getActivities().size() == 0;
    }
    
    
    public void removeEmptyActivities()
    {
        List<GanttActivity> nl = new List<GanttActivity>();
        List<GanttActivity> al = getActivities();
        for(GanttActivity ga:al)
        {
            if(!ga.isEmpty())
            {
                nl.add(ga);
            }
        }
        this.activities = nl;
    }
    
    public Integer compareTo(Object compareTo)
    {
        GanttProject compareToProj = (GanttProject)compareTo;
        if (Name == compareToProj.Name) return 0;
        if (Name > compareToProj.Name) return 1;
        return -1;     
       
    }
    
    public void addActivity(GanttActivity activity)
    {
       getActivities().add(activity);
    }
    
    public void setActivities(List<GanttActivity> activities)
    {
        this.activities = activities;
    }


}