/*
Type Name: WREditController 
Author: Cognizant UCM Team
Created Date: 10-01-2015
Reason: Reason: This is the controllar class for WRLockedEdit page.
Test Class: WRLockedEdit
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public class WREditController {
    public Bug__c wr {
        get;
        set;
    }
    private final Id wrid;

    public WREditController() {
        try {
            if (wrid == null && ApexPages.currentPage().getParameters().get('Id') != null) {
                wrid = validateId(ApexPages.currentPage().getParameters().get('Id'));
                wr = [Select Id, Name, Bug_Description__c, Bug_Title__c, Status__c, Proposed_Technology_Name__c, Request_Type__c, Geometry__c, Target_Process_Node__c, Master_PDK__c, New_Devices_Required__c, Process_Technology__c,
                Need_By_Date__c, OwnerId, Project_Manager__c, Project_Manager_Queue__c from Bug__c where Id = : wrid];
            }
        } catch (System.Exception e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference cancel() {
        PageReference pr = new PageReference('/' + wr.Id);
        return pr;
    }

    public PageReference save() {
        PageReference pr;
        try {
            update wr;
            //  After Save, navigate to the wr view page:
            pr = new PageReference('/' + wr.Id);
        } catch (System.DMLException e) {
            ApexPages.addMessages(e);
        }
        return pr;
    }
    //This method is used for validating Case Ids & users Ids  
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
    }
}