/*
Type Name: clsGFCalendarComponentController
Author: Cognizant Technology Solutions
Created Date: 21-5-2013
Reason: Class behind the component GFCalenderActivityComponent which is used to display the calendar of the logged in user. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/



public class clsGFCalendarComponentController
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
    
    
     /**
        This constructor instantiates the class for accessing from the component.
        
        @method name: clsGFCalendarComponentController
        @parameter:   none
        @return :     none
    **/
    public clsGFCalendarComponentController()
    {
         // modified as compared to the former class 
         openActivityColor = '#99FFCC';
         pastActivityColor = '#99CCFF';
         showOpenActivities = false;
         showActivityHistory = false;
    }
    
    /**
        The method is used to get the properties of the open/closed activity - color/label for display in the calendar component.
        
        @method name: getProviderActivityTypes
        @parameter:   none
        @return :     List<GFCalActivityType>
    **/    
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
    
    /**
        The method is used to obtain a list of the provider names provided through the calendar component.
        
        @method name: getProviders
        @parameter:   none
        @return :     List<GFCalActivityProvider>
    **/     
    public List<GFCalActivityProvider> getProviders()
    {
        if(providersList == null)
        {
           providersList = new List<GFCalActivityProvider>();
           loadProviders(providersList);
        }        
        return providersList;    
    }
    
    /**
        The method is used to obtain a list of the provider names provided through the calendar component.
        It also invokes the provider classes for open task/open meeting occurances/activity history.
        
        @method name: loadProviders
        @parameter:   List<GFCalActivityProvider>
        @return :     none
    **/     
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
                //invokes the provider classes for open task/open meeting occurances/activity history
                obj  = clsApexObjectFactory.newInstance(s.trim());                
                plist.add((GFCalActivityProvider)obj);                
            }
            
            catch(Exception e)
            {
                 System.debug(e);
            }        
        }        
    }
    
    /**
        
        
        @method name: getProviderActivities
        @parameter:   none
        @return :     List<GFCalActivity>
    **/  
    public List<GFCalActivity> getProviderActivities()
    {
       if(providerActivities == null)
       {         
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
     
    /**
        The method obtains the number of days in a week.
        
        @method name: getNumDaysInWeek
        @parameter:   none
        @return :     List<Integer>
    **/      
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
     
     /**
        The method obtains the number of working days in a week.
        
        @method name: getNumWeeks
        @parameter:   none
        @return :     List<Integer>
    **/
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
     
     /**
        The method obtains all the activity history records.
        
        @method name: getActivityHistories
        @parameter:   none
        @return :     List<ActivityHistory>
    **/             
     public List<ActivityHistory> getActivityHistories()
     {
         List<SObject> olist = null;
         List<ActivityHistory> rlist = new List<ActivityHistory>();
         
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
     
     /**
        The method obtains all the open activity records.
        
        @method name: getOpenActivities
        @parameter:   none
        @return :     List<OpenActivity>
    **/  
     public List<OpenActivity> getOpenActivities()
     {
         List<SObject> olist = null;
         List<OpenActivity> rlist = new List<OpenActivity>();
         
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