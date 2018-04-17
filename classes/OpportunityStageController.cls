/*……………………………………………………………………………..
Type Name: OpportunityStageController 
Author: IBM
Created Date: 25th-July-2017
Reason: This class is used for opportunity survey
Test Class: OpportunityStageController_Test
Change History:
Author: 
Modified Date: 
………………………………………………………………………………..*/

public with sharing class OpportunityStageController {

    public opportunity oOpportunity { get; set; }
    public string oppId {get;set;}
    public string Stage{get; set;}
    public string reasonForLostDropped {get;set;}
    public string headerMessage {get;set;}

    public OpportunityStageController (ApexPages.StandardController stdController) {
         try{
             	oOpportunity = (opportunity)stdController.getRecord();
				oppId=oOpportunity.id;
                if (oppId != null) {
                    oOpportunity = [select id, ownerid from opportunity where id = :oppId ];
                    headerMessage= Environment_Variable__c.getInstance('Lost').value__c;
                    headerMessage+= Environment_Variable__c.getInstance('Dropped').value__c;
                    headerMessage+= Environment_Variable__c.getInstance('Dropped_v1').value__c;
                    headerMessage+= Environment_Variable__c.getInstance('Void').value__c;
                }
        Stage = 'Lost';   
        }catch(Exception Ex){
            system.debug('Exception'+ex);
         }
        
        
    }
    
    public List<SelectOption> getClosedStages() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Lost','8. Lost'));
        options.add(new SelectOption('Dropped','9. Dropped'));
        options.add(new SelectOption('Void','10. Void'));
        return options;
    }
    
    /* public List<SelectOption> getReasonForLostDroppedValues() {
         List<SelectOption> options = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult = Opportunity.Reason_for_Loss_Dropped__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry oValue : ple)
        {
            options.add(new SelectOption(oValue.getLabel(), oValue.getValue()));
        }       
        return options;
    }*/
    
    public PageReference Next() {
        PageReference pageRef = new PageReference('/apex/OpportunitySurvey');
        pageRef.getParameters().put('SurveyFor__c',Stage);
        pageRef.getParameters().put('Record_Owner__c',oOpportunity.ownerid);
        pageRef.getParameters().put('Opportunity__c',oOpportunity.Id);
        if(Stage=='Lost' || Stage =='Dropped')
            pageRef.getParameters().put('RFLD',reasonForLostDropped);
         return pageRef;
    }
}