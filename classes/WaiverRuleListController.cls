/*
    Author: Abhita Bansal
    Company: GLOBALFOUNDRIES
    Project: DRC Application
    Description: This class is used as a controller for WaiverRuleListPage
    History: Suhas Bargi,8/9/2016 
**/
public class WaiverRuleListController {
    
    public Waiver_Rule_List__c waiverRule {get;set;}
    public transient List<Attachment> attachments {get;set;}
    public boolean isPortalUser {get;set;}
    public Id ruleId;
    public Id dfmId;   
    
    public WaiverRuleListController (ApexPages.StandardController stdController) {
        
        isPortalUser = false;
        
        if (UserInfo.getUserType()!='Standard'){ 
            isPortalUser = true;            
        } else {
            isPortalUser = false;
        }
        
        // getting the Rule Id
        ruleId = stdController.getRecord().Id;
        // retreiving Waiver Rule Record
        waiverRule = getWaiverRuleRecord(ruleId);
        // getting the DRC record Id
        dfmId = waiverRule.Waiver_Collaborator__c;
        
        // fetching the attachements related to rule
		attachments = DfmUtilityCls.getAttachments(ruleId);
    }
    
    // get waiver rule field information from field sets
    public List<Schema.FieldSetMember> getFields() {
    	
    	if (UserInfo.getUserType()!='Standard'){
        	return SObjectType.Waiver_Rule_List__c.FieldSets.WRL_View_Customer.getFields();        	
		} else {
			
		}
		return SObjectType.Waiver_Rule_List__c.FieldSets.WRL_View.getFields();
        //return SObjectType.Waiver_Rule_List__c.FieldSets.WRL_View.getFields();
    }
    
    // retrive customer specific waiver collaborator records
    private Waiver_Rule_List__c getWaiverRuleRecord(Id ruleId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += ' Disagree__c,Old_Image_Path__c,Stage__c,Final_Stage__c FROM Waiver_Rule_List__c WHERE Id =:ruleId LIMIT 1';
        return Database.query(query);
    }
    
    // Back Functionality
    public pageReference back(){
        pageReference pgRef;
        if (UserInfo.getUserType()!='Standard'){
        	pgRef = new pageReference('/GlobalfoundryView/DWC_Collaborator?id='+dfmId);
        } else {
        	pgRef = new pageReference('/apex/DWC_Collaborator?id='+dfmId);
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
   
}