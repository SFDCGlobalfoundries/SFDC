public class GFCalActivity
{

    private String id = null;
    private String type = null;
    private String subject = null;
    private String backgroundColor = null;
    private Date activityDate = null;
    private Date startDate = null;
    private Date endDate = null;
    private Map<String,String> filterMap = new Map<String,String>();
    

      public GFCalActivity()
      {
      
      }
      
   
   public void put(String key, String value)
   {
       filterMap.put(key,value);
   }   
   
   public String getJSFilter()
   {
   
      String str = '{';
      Set<String>keys = filterMap.keySet();
      List<String>klist = new List<String>();
      for(String skey:keys)
      {
          if(filterMap.get(skey)!= null)
          {
              klist.add(skey);
          }
      }
      String fkey = null;
      String val = null;
      for(Integer i = 0; i < klist.size(); ++i)
      {
         fkey = klist.get(i);
         val = filterMap.get(fkey);
         str += '\'';
         str += fkey;
         str += '\':\'';
         str += val;
         str += '\'';
         if(i+1<klist.size())
         {
             str += ',';
         }
      }
      str += '}';
      return str;
   }
   
   
   public String getId(){return id;} 
   public String getType(){return type;}  
   public String getSubject(){return subject;}  
   public String getBackgroundColor(){return backgroundColor;}
   public Date getActivityDate(){return activityDate;} 
   public Date getStartDate(){return startDate;} 
   public Date getEndDate(){return endDate;}    
   public void setId(String id){this.id = id;}
   public void setType(String type){this.type = type;}
   public void setSubject(String subject){this.subject = subject;}
   public void setActivityDate(Date activityDate){this.activityDate = activityDate;}
   public void setStartDate(Date startDate){this.startDate = startDate;}
   public void setEndDate(Date endDate){this.endDate = endDate;}
   public void setBackgroundColor(String bc){this.backgroundColor = bc;}


}