public with sharing class SFDCProjectMilestonesController {

    private SFDC_Project__c project = null;
    List<SFDC_Project_Milestone__c> milestones = null;

    public SFDCProjectMilestonesController(ApexPages.StandardController controller) {
             project = (SFDC_Project__c)controller.getRecord();
    }
    public List<SFDC_Project_Milestone__c> getMilestones()
    {
         if((milestones == null)&&(project != null))
         {
            String id = project.id;
            milestones = [SELECT M.Id, M.Name, M.Name__c, M.Implement_Name__c, M.Start_Date__c, M.End_Date__c,M.Completed__c,M.Chart_Color__c,
                         M.Stage__r.Id, M.Stage__r.Name, M.Stage__r.Name__c, M.Stage__r.Start_Date__c, M.Stage__r.End_Date__c,M.Stage__r.Completed__c,
                         M.Stage__r.SFDC_Project__r.Id,M.Stage__r.SFDC_Project__r.Name,M.Stage__r.SFDC_Project__r.Description__c
                         from SFDC_Project_Milestone__c M WHERE M.Stage__r.SFDC_Project__r.id = :id order by M.Start_Date__c LIMIT 500];
         }else
         {
             return new List<SFDC_Project_Milestone__c>();
         }
         
         return milestones;
                                                 
    }

}