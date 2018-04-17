/*
Type Name: CaseCloseController 
Author: Cognizant Case Mgmt Team
Created Date: Nov-24-2014
Reason: Reason: This is the controllar class for CaseClose page.
Test Class: CaseVisualforceControllerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public class CaseCloseController {
    public Case objCase {get;set;}
    public String closeReason {get;set;}
    public String closeComment {get;set;}
    public Boolean isError {get;set;}
    private final Id caseid;
    
    /***
    * CaseCloseController - Constructor initialization
    ***/
    public CaseCloseController() {
        try {
            isError = false;
            if (caseid == null && ApexPages.currentPage().getParameters().get('Id') != null) {
                caseid = validateId(ApexPages.currentPage().getParameters().get('Id'));
                objCase = [Select Id, CaseNumber, Subject, AccountID, Status, Category__c, CreatedById, IsClosed, Owner.Name, CreatedBy.Name, Case_Closed_By__c from Case where Id = : caseid AND IsClosed = false LIMIT 1];
            }

        } catch (System.Exception e) {
            //ApexPages.addMessages(e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Case is already closed, please post comment to contact Case Owner.'));
            isError = true;
        }
    }
    
    // On save, update case object and insert case comment
    public PageReference save() {
        PageReference pr;
        try {
    
            if (objCase != null && isNotBlank(closeComment)) {
                string strComment = '';
                strComment += 'OK to Close \n Close Reason: ' + closeReason + '\n Close Comment: ' + closeComment;
    
                objCase.Close_Reason__c = closeReason;
                objCase.Close_Comment__c = closeComment.trim();
                objCase.Close_Requested_Date__c = DateTime.Now();
                if (UserInfo.getUserId() == objCase.CreatedById) {
                    objCase.Status = 'Closed - Verified';
                    strComment += '\n Case Status: Closed - Verified';
                }
                update objCase;
                
                FeedItem fi = New FeedItem();
                fi.Body = strComment;
                fi.parentId = objCase.Id;
                if(UserInfo.getUserType() != 'Standard'){
                    fi.VISIBILITY='AllUsers';
                }else{
                    fi.VISIBILITY='InternalUsers';
                }
                insert fi;
                //CaseComment cc = new CaseComment(CommentBody = strComment, parentID = objCase.Id, IsPublished = true);
                //insert cc;
    
                //  After Save, navigate to the case view page:
                pr = new PageReference('/' + objCase.Id);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please provide Case Comment.'));
            }
    
        } catch (System.DMLException e) {
            ApexPages.addMessages(e);
            isError = true;
        }
        return pr;
    }
    
    // On cancel, navigate to the case view page:
    public PageReference cancel() {        
        PageReference pr = new PageReference('/' + objCase.Id);
        return pr;
    }
    
    //Method will generate close Reasonpicklist
    public List < selectOption > getcloseReasonList() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '--None--'));

        Schema.DescribeFieldResult fieldResult = Case.Close_Reason__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
   
    //This method is used for validating Case Ids & users Ids  
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && (id.startsWith('500'))) {
            return id;
        }
        return null;
    }
    
     /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val.trim() <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
}