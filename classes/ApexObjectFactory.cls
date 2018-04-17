public class ApexObjectFactory
{

    public static Object newInstance(String typeName)
    {
    
       if(typeName == 'TeamRoomGFCalActivityProvider')
       {
           return new TeamRoomGFCalActivityProvider();
       }
       else if(typeName == 'SFDCPortfolioGanttProjectProvider')
       {
           return new SFDCPortfolioGanttProjectProvider();
       }
       else if(typeName == 'SFDCProjectGanttProjectProvider') 
       {   
           return new SFDCProjectGanttProjectProvider();
       }
       else if(typeName == 'SFDCProjectStageGanttProjectProvider')
       {    
           return new SFDCProjectStageGanttProjectProvider();
       }
       else if(typeName == 'VisitationFromGFCalActivityProvider')
       {    
           return new VisitationFromGFCalActivityProvider();
       }
       else if(typeName == 'VisitationToGFCalActivityProvider')
       {    
           return new VisitationToGFCalActivityProvider();
       }
       
       
           
       return null;
    }

}