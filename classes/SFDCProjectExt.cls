public with sharing class SFDCProjectExt {

    SFDC_Project__c project = null;
    public String CurrentStageName {get;set;}
    public String CurrentMilestoneName {get;set;}
    
   
    
    public SFDCProjectExt(ApexPages.StandardController controller) {
        project = (SFDC_Project__c)controller.getRecord();
        SFDC_Project_Stage__c currentStage = SFDCUtil.findCurrentStage(project.id);
        
        if(currentStage != null)
        {
           CurrentStageName = currentStage.Name;
           SFDC_Project_Milestone__c currentMilestone = SFDCUtil.findCurrentMilestone(currentStage.id);
           if(currentMilestone != null)
           {
             CurrentMilestoneName = currentMilestone.Name;
           }
        }
        
        
        
    }

}