/*Author: Cognizant Case Management Team
 * Description: This class is controller class for BugCDTCreate. This page and class are used to created and update the CDT Bug record.
 * History: Created on 8thSept,2015
 */
public with sharing class BugCDTCreateController {
    private ApexPages.StandardController stdCtrl;
    public bug__c bugVar {
        get;
        set;
    }
    public boolean disableFields {
        get;
        set;
    }
    public UserRecordAccess usrAccess {
        get;
        set;
    }
    public boolean displayRecord {
        get;
        set;
    }
    public string stRecordTypeName;
    public string bgCaseId;
    public string bugTitle {
        get;
        set;
    }
    public string bgCloneId;
    public boolean newFlag {
        get;
        set;
    }

    // Constructor for controller class
    public BugCDTCreateController(ApexPages.StandardController controller) {
        stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bgCaseId = ApexPages.currentPage().getParameters().get('caseid');
        disableFields = false;
        usrAccess = new UserRecordAccess();
        bug__c bugClone = new bug__c();

        // Code bloc runs when the bug is cloned
        if (ApexPages.currentPage().getParameters().get('type') == 'clone') {
            bugTitle = 'New Bug';
            bugClone = [Select b.Version__c,
            b.Tool_Version__c, b.Tool_Name__c, b.Status__c,
            b.Severity__c, b.Resolution__c,
            b.Resolution_Details__c, b.RecordTypeId, b.Product_technology__c, b.component__c,
            b.Priority__c, b.OwnerId, b.Origin__c, b.Name,
            b.Id, b.Bug_Title__c, b.Bug_Description__c, b.Related_DMM_Number__c,
            b.Bug_Classification__c, b.Account_Affected__c, recordtype.name,
            b.Bug_Resolved_Date__c, b.DE_Spec_Affected__c, Fixed_Version__c,
            b.Sub_component__c, DM_Team_Classification__c, b.Bugzilla_ID__c, b.URL_to_Legacy_Bug__c, b.Legacy_Bug_Owner__c, b.Legacy_Bug_Requester__c, b.Date_Time_Assigned_Start__c,
            b.DuplicateBug__c, b.Decision_Status__c
            From Bug__c b where id = : bugVar.id];
            bugVar = new bug__c();
            bugVar.Bug_Title__c = bugClone.Bug_Title__c;
            bugVar.Product_Technology__c = bugClone.Product_Technology__c;
            bugVar.Status__c = bugClone.Status__c;
            bugVar.Version__c = bugClone.Version__c;
            bugVar.Bug_Classification__c = bugClone.Bug_Classification__c;
            bugVar.Component__c = bugClone.Component__c;
            bugVar.Priority__c = bugClone.Priority__c;
            bugVar.Sub_component__c = bugClone.Sub_component__c;
            bugVar.Severity__c = bugClone.Severity__c;
            bugVar.Tool_Name__c = bugClone.Tool_Name__c;
            bugVar.Tool_Version__c = bugClone.Tool_Version__c;
            bugVar.Status__c = 'New';
            bugVar.DuplicateBug__c = bugClone.DuplicateBug__c;
            bugVar.Decision_Status__c = bugClone.Decision_Status__c;
            bugVar.Bugzilla_ID__c = bugClone.Bugzilla_ID__c;
            bugVar.URL_to_Legacy_Bug__c = bugClone.URL_to_Legacy_Bug__c;
            bugVar.Legacy_Bug_Owner__c = bugClone.Legacy_Bug_Owner__c;
            bugVar.Legacy_Bug_Requester__c = bugClone.Legacy_Bug_Requester__c;
            bugVar.Date_Time_Assigned_Start__c = bugClone.Date_Time_Assigned_Start__c;
            bugVar.recordtypeid = ApexPages.currentPage().getParameters().get('rid');
            bgCloneId = ApexPages.currentPage().getParameters().get(label.bugOriginId);
            stRecordTypeName = [select name from recordtype where id = : ApexPages.currentPage().getParameters().get('rid')][0].name;
            displayRecord = true;

        } else

        {
            // Code block runs when the bug is created.
            newFlag = true;
            bugTitle = 'New Bug';
            bugVar = new bug__c();
            stRecordTypeName = [select name from recordtype where id = : ApexPages.currentPage().getParameters().get('rid')][0].name;
            bugVar.recordtypeid = ApexPages.currentPage().getParameters().get('rid');
            displayRecord = true;
        }
    }

    //Page saves the bug and redirects to list page.
    public pagereference savebug() {
        PageReference bugPage;
        try {
            bugVar.status__c = 'New';
            if (bugVar.Bug_Title__c != '' && bugVar.Bug_Classification__c != null && bugVar.Product_Technology__c != null && bugVar.Severity__c != null && bugVar.Priority__c != null) {
                if (bugVar.id != null) {
                    update bugVar;
                } else {
                    if (bgcaseId != null || bgcaseId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcaseId;
                    }

                    if (bgcloneId != null || bgcloneId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcloneId;
                    }

                    insert bugVar;
                }

                if (bgcaseId != null && bgcaseId != '') {
                    case c = [select id from
                    case where id = :
                        bgCaseId][0];
                    bugPage = new ApexPages.StandardController(c).view();
                } else bugPage = new ApexPages.StandardController(bugVar).view();
                bugPage.setRedirect(true);
                return bugPage;
            } else {

                if (bugVar.Bug_Title__c == '') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugTitle').Error_Message__c));
                else if (bugVar.Product_Technology__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugProduct').Error_Message__c));
                else if (bugVar.Version__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugVersion').Error_Message__c));
                else if (bugVar.Bug_Classification__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugClassification').Error_Message__c));
                else if (bugVar.Component__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugComponent').Error_Message__c));
                else if (bugVar.Priority__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugPriority').Error_Message__c));
                else if (bugVar.Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugSeverity').Error_Message__c));
                return null;
            }
        } catch (Exception e) {
            if (e.getmessage().contains(BugErrorMessages__c.getValues('BugResolutionValidation').Error_Message__c)) apexpages.addmessage(new apexpages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('BugResolutionValidation').Error_Message__c));
            else if (e.getmessage().contains(BugErrorMessages__c.getValues('BugDuplicateValidation').Error_Message__c)) apexpages.addmessage(new apexpages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('BugDuplicateValidation').Error_Message__c));
            else if (e.getmessage().contains(BugErrorMessages__c.getValues('BugDupeBlockerValidation').Error_Message__c)) return null;
            else {

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            }
            return null;
        }
    }

    //Page saves the bug and redirects to to add attachment page.
    public pagereference SubmitBugandAddAttachment() {
        PageReference attachmentPage;
        try {
            bugVar.status__c = 'New';
            if (bugVar.Bug_Title__c != '' && bugVar.Bug_Classification__c != null && bugVar.Product_Technology__c != null && bugVar.Severity__c != null && bugVar.Priority__c != null) {
                if (bugVar.id != null) {
                    update bugVar;
                } else {
                    if (bgcaseId != null || bgcaseId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcaseId;
                    }

                    if (bgcloneId != null || bgcloneId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcloneId;
                    }

                    insert bugVar;
                }
                attachmentPage = new PageReference('/p/attach/NoteAttach?pid=' + bugVar.id + '&retURL=' + bugVar.id);
                system.debug('aat111' + attachmentPage);
                return attachmentPage;
            } else {

                if (bugVar.Bug_Title__c == '') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugTitle').Error_Message__c));
                else if (bugVar.Product_Technology__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugProduct').Error_Message__c));
                else if (bugVar.Version__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugVersion').Error_Message__c));
                else if (bugVar.Bug_Classification__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugClassification').Error_Message__c));
                else if (bugVar.Component__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugComponent').Error_Message__c));
                else if (bugVar.Priority__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugPriority').Error_Message__c));
                else if (bugVar.Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugSeverity').Error_Message__c));
                return null;
            }
        } catch (Exception e) {

            if (e.getmessage().contains(BugErrorMessages__c.getValues('BugDupeBlockerValidation').Error_Message__c)) return null;
            else {

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
            }
            return null;
        }
    }

    //Method redirects the list page of Bugs with out saving the bug
    public pagereference cancelBug() {
        if (bugVar.id != null) {
            PageReference bugPage = new ApexPages.StandardController(bugVar).view();
            bugPage.setRedirect(true);
            return bugPage;
        } else {
            Schema.DescribeSObjectResult result = bug__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
}