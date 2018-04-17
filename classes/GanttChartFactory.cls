public class GanttChartFactory
{

    public static Object newInstance(String typeName)
    {
    
       if(typeName == 'SFDCPortfolioGanttProjectProvider')
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
           
       return null;
    }

}