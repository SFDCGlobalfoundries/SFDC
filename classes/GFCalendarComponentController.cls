public class GFCalendarComponentController
{
    public Boolean showOpenActivities{get;set;}
    public Boolean showActivityHistory{get;set;}
    public String objectId{get;set;}
    public String typeName{get;set;}
    public String providers{get;set;} 
    public String openActivityColor {get;set;}
    public String pastActivityColor {get;set;}
    
    private List<Integer> numDaysInWeek = null;
    private List<Integer> numWeeks = null;
    private List<GFCalActivityProvider> providersList = null;
    List<GFCalActivity> providerActivities = null;
    List<GFCalActivityType> providerActivityTypes = null; 
    
    public GFCalendarComponentController()
    {
         openActivityColor = '#99FFCC';
         pastActivityColor = '#99CCFF';
         showOpenActivities = true;
         showActivityHistory = true;
    }
    
     public List<GFCalActivityType> getProviderActivityTypes()
    {
       if(providerActivityTypes == null)
       {
        
         providerActivityTypes = new List<GFCalActivityType>();
         List<GFCalActivityProvider> plist = getProviders();
         List<GFCalActivityType> paList = null;
         for(GFCalActivityProvider p:plist)
         {
            paList = p.getActivityTypes();
            if(paList != null)
            {
               providerActivityTypes.addAll(paList);
            }
         }
       }
        
       return providerActivityTypes;
    }
    
    
    public List<GFCalActivityProvider> getProviders()
    {
        if(providersList == null)
        {
           providersList = new List<GFCalActivityProvider>();
           loadProviders(providersList);
        }
        
        return providersList;
    
    }
    
    
    void loadProviders(List<GFCalActivityProvider> plist)
    {
        if(providers == null)
        {
           return;
        }
        
       
        Object obj = null;
        String[] pa = providers.split(',');
        for(String s:pa)
        {
            try
            {
                obj  = ApexObjectFactory.newInstance(s);
                plist.add((GFCalActivityProvider)obj);
            }catch(Exception e)
            {
                 System.debug(e);
            }
        
        }    
    
    }
    
    public List<GFCalActivity> getProviderActivities()
    {
       if(providerActivities == null)
       {
         System.debug('getting provider activities ');
         providerActivities = new List<GFCalActivity>();
         List<GFCalActivityProvider> plist = getProviders();
         List<GFCalActivity> paList = null;
         for(GFCalActivityProvider p:plist)
         {
            paList = p.findActivities(objectId);
            if(paList != null)
            {
               providerActivities.addAll(paList);
            }
         }
       }
        
       return providerActivities;
    }
     
     
     public List<Integer> getNumDaysInWeek()
     {
        if(numDaysInWeek == null)
        {
          numDaysInWeek = new List<Integer>();
           for(Integer i = 1; i <= 7; ++i)
           {
               numDaysInWeek.add(i);
           }
        }
        return numDaysInWeek;
     }
     
      public List<Integer> getNumWeeks()
     {
        if(numWeeks == null)
        {
          numWeeks = new List<Integer>();
           for(Integer i = 1; i <= 5; ++i)
           {
               numWeeks.add(i);
           }
        }
        return numWeeks;
     }
     
     public List<ActivityHistory> getActivityHistories()
     {
         List<SObject> olist = null;
         List<ActivityHistory> rlist = new List<ActivityHistory>();
         if((typeName == null)||(objectId == null))
         {
            return rlist;
         }
         String soql = 'SELECT (SELECT Id, Subject, ActivityType, ActivityDate, Description FROM ActivityHistories) ';
         soql += 'FROM ';
         soql += typeName;
         soql += ' WHERE Id = \'';
         soql += objectId;
         soql += '\' LIMIT 500';
         olist = Database.query(soql);  
         Schema.DescribeSObjectResult typeDescribe = null;
         Schema.SObjectField ahField = null;
         Schema.DescribeFieldResult ahFieldDesc = null;
         Map<String, Schema.SObjectField> fieldMap = null;
         Object obj = null;
         List<ActivityHistory> activityHistories = null;
         for(SObject sobj:olist)
         {
            obj = sobj.getSObjects('ActivityHistories');
            if(obj != null)
            {
              
              activityHistories = (List<ActivityHistory>)obj;
              for(ActivityHistory ah:activityHistories)
              {
                rlist.add(ah);
              }
            }
        
         }          
         return rlist;
     }
     
      public List<OpenActivity> getOpenActivities()
     {
         List<SObject> olist = null;
         List<OpenActivity> rlist = new List<OpenActivity>();
         if((typeName == null)||(objectId == null))
         {
            return rlist;
         }
         String soql = 'SELECT (SELECT Id, Subject, ActivityType, ActivityDate, Description FROM OpenActivities) ';
         soql += 'FROM ';
         soql += typeName;
         soql += ' WHERE Id = \'';
         soql += objectId;
         soql += '\' LIMIT 500';
         olist = Database.query(soql);  
         Schema.DescribeSObjectResult typeDescribe = null;
         Schema.SObjectField ahField = null;
         Schema.DescribeFieldResult ahFieldDesc = null;
         Map<String, Schema.SObjectField> fieldMap = null;
         Object obj = null;
         List<OpenActivity> openActivities = null;
         for(SObject sobj:olist)
         {
            obj = sobj.getSObjects('OpenActivities');
            if(obj != null)
            {
              
              openActivities = (List<OpenActivity>)obj;
              for(OpenActivity oa:openActivities)
              {
                rlist.add(oa);
              }
            }
        
         }          
         return rlist;
     }
     
}