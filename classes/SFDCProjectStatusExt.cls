public with sharing class SFDCProjectStatusExt {
    private SFDC_Project_Status__c status = null;
    private List<SFDC_Project_Issue__c> openIssues = null;
    
    public SFDCProjectStatusExt(ApexPages.StandardController controller) {
        status = (SFDC_Project_Status__c)controller.getRecord();
        List<SFDC_Project_Status__c> slist = [Select Id, Project__c from SFDC_Project_Status__c where id = :status.id];
        if(slist.size() == 1)
        {
            status = slist.get(0);
        }
    }
    
    public List<SFDC_Project_Issue__c> getOpenIssues()
    {
       if((openIssues == null)&&(status != null))
       {
         String id = status.Project__c;
         openIssues = [SELECT id, Name, Status__c, Type__c,Description__c, Owner__c from SFDC_Project_Issue__c where SFDC_Project__c = :id and Status__c = 'Open'];
       }
       return openIssues;
   }

}