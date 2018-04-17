public with sharing class SFDCProjectStagesControllerExt {

    private SFDC_Project__c project = null;
    private List<SFDC_Project_Stage__c> stages = null;
    public SFDC_Project_Stage__c CurrentStage{get;set;}
    public SFDC_Project_Milestone__c CurrentMilestone{get;set;}
    
    public SFDCProjectStagesControllerExt(ApexPages.StandardController controller) {
        SFDC_Project_Stage__c pstg = null;
        List<SFDC_Project_Stage__c> rlist = new List<SFDC_Project_Stage__c>();
        Map<String,SFDC_Project_Stage__c> smap = new Map<String,SFDC_Project_Stage__c>();
        project = (SFDC_Project__c)controller.getRecord();
        List<SFDC_Project_Stage__c> slist = [select Id, Name__c, Start_Date__c, End_Date__c,Completed__c,Skip__c from SFDC_Project_Stage__c where SFDC_Project__c = :project.id]; 
        for(SFDC_Project_Stage__c stg:slist)
        {
            smap.put(stg.Name__c,stg);
        }
        
        //GRAB PICKLIST VALUES FROM STAGE NAME PICKLIST
        Schema.DescribeFieldResult f = Schema.SObjectType.SFDC_Project_Stage__c.fields.Name__c;
        List <Schema.PicklistEntry> plentries = f.getPicklistValues();
        Map<String,SFDC_Project_Stage__c> clones = new Map<String,SFDC_Project_Stage__c>();
        SFDC_Project_Stage__c clone = null;
        
        //LOOP THROUGH STAGE NAME PICK LIST ENTRIES
        for(Schema.PicklistEntry ple:plentries)
        {
           //LOOKUP STAGE IN LOCAL MAP
           pstg = smap.get(ple.getValue());
           
           
           //CHECK IF STAGE FOUND IN MAP
           if(pstg == null)
           {
              //NOT FOUND SO CREATE STAGE OBJECT 
              pstg = new SFDC_Project_Stage__c();
              pstg.SFDC_Project__c = project.id;
              pstg.Name__c = ple.getValue();
              pstg.Name = pstg.Name__c;
              
           }
           
          
           rlist.add(pstg);
           
        }
        
        stages = rlist;
    }
    
    public SFDC_Project__c getProject()
    {
        return project;
    }
    
    public List<SFDC_Project_Stage__c> getStages()
    {
        
         return stages;
    
    }
    
    
   
    

}