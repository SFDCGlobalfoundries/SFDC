public with sharing class SFDCProjectStatusNewExt {

   private SFDC_Project_Status__c status = null;

    public SFDCProjectStatusNewExt(ApexPages.StandardController controller)
    {
        status = (SFDC_Project_Status__c)controller.getRecord();
        
        status.Week_Ending_Date__c = DateUtil.getCurrentWeekFridayLocalDate();
    }

}