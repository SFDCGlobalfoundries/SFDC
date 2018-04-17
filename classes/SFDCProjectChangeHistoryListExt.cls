public class SFDCProjectChangeHistoryListExt {

    private List<SFDC_Change_History__c> changeHistories = null;
    private SFDC_Project__c project = null;
    
    
    
    public SFDCProjectChangeHistoryListExt(ApexPages.StandardController controller) {
        project = (SFDC_Project__c)controller.getRecord();
        changeHistories = [select Id, Name, Diff__c,CreatedDate from SFDC_Change_History__c where SFDC_Project__c = :project.id]; 
        
    }
    
    public SFDC_Project__c getProject()
    {
        return project;
    }
    
    public List<SFDC_Change_History__c> getChangeHistories()
    {
        
         return changeHistories;
    
    }

}