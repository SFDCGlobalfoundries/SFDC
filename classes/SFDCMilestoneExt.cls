public with sharing class SFDCMilestoneExt {

    private SFDC_Project_Milestone__c milestone = null;
    private SFDC_Project_Stage__c stage = null;
    
    public SFDCMilestoneExt(ApexPages.StandardController controller) 
    {
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
    
    public String getImplementationStageName()
    {
       return SFDCConstants.IMPLEMENTATION_STAGE;
    }
    
    
    public SFDC_Project_Stage__c getStage()
    {
       return stage;
    }

}