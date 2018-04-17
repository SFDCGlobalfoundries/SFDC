public with sharing class SFDCMilestoneEditExt {

    private SFDC_Project_Milestone__c milestone = null;
    private SFDC_Project_Stage__c stage = null;
    ApexPages.StandardController controller = null;

    public SFDCMilestoneEditExt(ApexPages.StandardController controller) 
    {
        this.controller = controller;
        milestone = (SFDC_Project_Milestone__c)controller.getRecord();
        List<SFDC_Project_Milestone__c> mlist = [SELECT Stage__c from SFDC_Project_Milestone__c where id = :milestone.id];
        if(mlist.size() == 1)
        {
            String stageId = mlist.get(0).Stage__c;
            List<SFDC_Project_Stage__c> slist = [SELECT id, Name, Name__c from SFDC_Project_Stage__c where id = :stageId];
            if(slist.size() == 1)
            {
               stage = slist.get(0);
            }
        }
    }
    
    public PageReference Save()    
    {      
       if(getStage().Name__c == getImplementationStageName())       
       {  
          milestone.Name = milestone.Implement_Name__c;      
       }else    
       {  
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
        return stage;
    }
    
    

}