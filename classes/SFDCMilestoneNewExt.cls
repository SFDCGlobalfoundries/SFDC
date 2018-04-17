public with sharing class SFDCMilestoneNewExt {

    private SFDC_Project_Milestone__c milestone = null;
    private SFDC_Project_Stage__c stage = null;
    ApexPages.StandardController controller = null;

    public SFDCMilestoneNewExt(ApexPages.StandardController controller) 
    {
        this.controller = controller;
        milestone = (SFDC_Project_Milestone__c)controller.getRecord();
    }
    
    public PageReference Save()
    {
       
       if((getStage() != null)&&(getStage().Name__c == getImplementationStageName()))
       {
           if(milestone.Implement_Name__c == null)
           {
               milestone.addError('Name is required');
               return null;
           }
           milestone.Name = milestone.Implement_Name__c;
       } 
       else
       {
           if(milestone.Name__c == null)
           {
               milestone.addError('Name is required');
               return null;
           }
           milestone.Name = milestone.Name__c;
       }
        return controller.Save();
    }
    
    public String getImplementationStageName()
    {
       return SFDCConstants.IMPLEMENTATION_STAGE;
    }
    
    public SFDC_Project_Milestone__c getMilestone()
    {
       return milestone;
    }
    
    public SFDC_Project_Stage__c getStage()
    {
        if(stage == null)
        {
           List<SFDC_Project_Stage__c> slist = [SELECT id, Name, Name__c from SFDC_Project_Stage__c where id = :milestone.Stage__c];
           if(slist.size() == 1)
           {
             stage = slist.get(0);
           }
        }
        return stage;
    }
    
    

}