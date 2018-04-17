/*
Type Name: clsApexObjectFactory
Author: Cognizant Technology Solutions
Created Date: 21-5-2013
Reason: The class invokes the provider classes for open task/open meeting occurances/activity history. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/



public class clsApexObjectFactory
{
    
    /**
        The method invokes the provider classes for open task/open meeting occurances/activity history used in the calendar component.
        
        @method name: newInstance
        @parameter:   String 
        @return :     Object
    **/
    public static Object newInstance(String typeName)
    {    
       if(typeName == 'clsMeetingOccuranceGFCalActivityProvider')
       {          
           return new clsMeetingOccuranceGFCalActivityProvider();
       }
       
       else if(typeName == 'clsTaskGFCalActivityProvider')
       {        
           return new clsTaskGFCalActivityProvider();
       }
       
       else if(typeName == 'clsActivityHistoryGFCalActivityProvider')
       {        
           return new clsActivityHistoryGFCalActivityProvider();
       }
                  
       return null;
    }
}