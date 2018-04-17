public class SFDCPortfolioDashboardController
{
     List<SFDC_Project__c> projects = null;
     public Integer redCount{get;set;}
     public Integer yellowCount{get;set;}
     public Integer greenCount{get;set;}
     ApexPages.StandardSetController controller = null;
          
     public SFDCPortfolioDashboardController(){}
     public SFDCPortfolioDashboardController(ApexPages.StandardSetController controller) 
     {
        this.controller = controller;
     } 
     
     public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name,Overall_Status__c from SFDC_Project__c order by Name]));
            }
            return setCon;
        }
        set;
    }

        
     public List<SFDC_Project__c> getProjects()
     {
         redCount = 0;
         yellowCount = 0;
         greenCount = 0;
         
         if(projects == null)
         {
            projects = (List<SFDC_Project__c>) setCon.getRecords();
            for(SFDC_Project__c p:projects)
            {
            
                if(p.Overall_Status__c == 'Red')
                {
                   ++redCount;
                }else if(p.Overall_Status__c == 'Yellow')
                {
                   ++yellowCount;
                }else if(p.Overall_Status__c == 'Green')
                {
                   ++greenCount;
                }
                
            }
         }
         return projects;
     }
     

}