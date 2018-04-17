/*Author: Cognizant UCM Team
* Description: This class is controller class for LoadBugFieldsPage. This page and class are 
                used to created and update the PDK Bug record 
* History: Created on 03/31/2014
           Modified on 08/20/14 for code enhancement.
*/
public class LoadBugFieldsClass {
    private ApexPages.StandardController stdCtrl;
    public List<CaseTeamMember> caseTMMebrList=new List<CaseTeamMember>();
    public bug__c bugVar {
        get;
        set;
    }
    public Case caseobj {get; set; }
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
    public string newId;
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
    public boolean isRequiredFlag {
        get;
        set;
    }
    public string status {
        get;
        set;
    }
    public boolean newPicklist{
        get;
        set;
    }
    // Constructor for controller class
    public LoadBugFieldsClass(ApexPages.StandardController controller) {
        status = 'New';
        stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bgCaseId = ApexPages.currentPage().getParameters().get('caseid');
        disableFields = false;
        isRequiredFlag = false;
        usrAccess = new UserRecordAccess();
        bug__c bugClone = new bug__c();
                newId = ApexPages.currentPage().getParameters().get('cid');
        // Code bloc runs when the bug is cloned
        if (ApexPages.currentPage().getParameters().get('type') == 'clone') {
            newFlag = false;
            bugTitle = 'New Bug';
            bugClone = [Select b.Version__c,
            b.Tool_Version__c, b.Tool_Name__c, b.Status__c,
            b.Severity__c, b.Resolution__c,
            b.Resolution_Details__c, b.RecordTypeId, b.Product_technology__c, b.component__c,
            b.Priority__c, b.OwnerId, b.Origin__c, b.Name,
            b.Id, b.Bug_Title__c, b.Bug_Description__c, b.Related_DMM_Number__c,
            b.Bug_Classification__c, b.Account_Affected__c, recordtype.name,
            b.Bug_Resolved_Date__c, b.DE_Spec_Affected__c, Fixed_Version__c,
            b.Sub_component__c, DM_Team_Classification__c From Bug__c b where id = : bugVar.id];

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
            bugVar.DE_Spec_Affected__c = bugClone.DE_Spec_Affected__c;
            //bugVar.Bug_Description__c = bugClone.Bug_Description__c;// Cloned bug should have blank description so that user cloning the bug will be providing appropriate description for the new bug
            bugVar.Tool_Name__c = bugClone.Tool_Name__c;
            bugVar.Tool_Version__c = bugClone.Tool_Version__c;
            bugVar.Status__c = 'New';
            bugVar.recordtypeid = ApexPages.currentPage().getParameters().get('rid');
            bgCloneId = ApexPages.currentPage().getParameters().get(label.bugOriginId);
            stRecordTypeName = [select name from recordtype where id = : ApexPages.currentPage().getParameters().get('rid')][0].name;
            displayRecord = true;
        }
        else
        {
            // Code block runs when the bug is created.
            newFlag = true;
            bugTitle = 'New Bug';
            bugVar = new bug__c();
            stRecordTypeName = [select name from recordtype where id = : ApexPages.currentPage().getParameters().get('rid')][0].name;
            bugVar.recordtypeid = ApexPages.currentPage().getParameters().get('rid');
            displayRecord = true;
            if (bgCaseId != null) {
                if ([select id from
                case where id = :
                    bgcaseId].size() > 0) {
                    case caseObj = [select id, Specification__c, Target_process_node__c, EDA_Tool__c, PDK_VERSION__c from
                    case where id = :
                        bgCaseId][0];

                    bugVar.DE_Spec_Affected__c = caseObj.Specification__c;
                    bugVar.Product_Technology__c = caseObj.Target_process_node__c;
                    bugVar.Component__c = caseObj.EDA_Tool__c;
                    bugVar.Version__c = caseObj.PDK_VERSION__c;
                }
            }
        }
        
        //Start : Manikumar - Case to PDK Bug 
        if(newId != null) {
            newFlag = false;
                caseTMMebrList = [Select MemberId,ParentId,TeamRoleId,TeamTemplateMemberId from CaseTeamMember where ParentId =:newId 
                                                                and MemberId IN (Select Id from User where UserType='Standard')];
            caseobj = [select id,Description,Subject,EDA_Tool__c,EDA_Tool_verions__c,Target_process_node__c,Subcategory__c,Priority, 
                PDK_VERSION__c,Requested_Severity__c,AccountId from case where id =:newId];
            bugVar = new bug__c();
            bugVar.Bug_Title__c= caseObj.Subject;
            bugVar.Bug_Description__c= caseObj.Description;
            
            List<SelectOption> selectList = getBugPickVal();
            
            if(caseObj.Target_process_node__c !=null){
                boolean flag = getFlag(caseObj.Target_process_node__c,selectList);
                if(flag == true){
                    bugVar.Product_Technology__c= caseObj.Target_process_node__c;
                }
            }
            if(caseObj.Subcategory__c == 'Design Manual'){            
               isRequiredFlag = true;                                               
             }
            bugVar.Component__c= caseObj.Subcategory__c;
            bugVar.Tool_Name__c= caseObj.EDA_Tool__c;
            bugVar.Severity__c = caseObj.Requested_Severity__c;
            bugVar.Tool_Version__c= caseObj.EDA_Tool_verions__c;
            bugVar.Version__c= caseObj.PDK_VERSION__c;
            bugVar.Account_Affected__c = caseObj.AccountId;
            bugVar.RecordTypeId= ApexPages.currentPage().getParameters().get('rid');
            if(caseObj.Priority == 'High') {
                bugVar.Priority__c='P1 - High';
            }
            else if(caseObj.Priority =='Medium') {
                bugVar.Priority__c='P2';
            }
            else {
                bugVar.Priority__c='P3';
            }
        }
    }
    
    //Method assign the value to the field
    public List<SelectOption> getBugPickVal() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
        Bug__c.Product_Technology__c.getDescribe();
        List<Schema.PicklistEntry> bugPickVal = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pickVal : bugPickVal) {
            options.add(new SelectOption(pickVal.getLabel(), pickVal.getValue()));
        } 
        return options;
    }
   
    //Method contains Picklist Value continues
    public boolean getFlag(String bugPickval,List<SelectOption> casePickvalList){
        newPicklist =  false;
        for(System.SelectOption str:casePickvalList) {            
            if(!string.valueOf(bugPickval).equalsIgnoreCase(string.valueOf(str.getValue()))) {
                continue;
            }else {
                newPicklist =true;
                break;
            }          
        }
        return   newPicklist ;
    }
    //End : Manikumar - Case to PDK Bug
    
    //Page saves the bug and redirects to list page.
    public pagereference savebug() {
    PageReference bugPage;
    try {
        bugVar.status__c = 'New';
        if (bugVar.Bug_Title__c != '' && bugVar.Bug_Classification__c != null && bugVar.Product_Technology__c != null && bugVar.Component__c != null  && bugVar.Version__c != null && bugVar.Customer_Severity__c != null) {
            if (bugVar.id == null) {
                if (bgcaseId != null || bgcaseId != '') {
                    if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcaseId;
                }

                if (bgcloneId != null || bgcloneId != '') {
                    if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcloneId;
                }
                insert bugVar;
            }
            //Start: Manikumar - Case to PDK Bug

            if (bugVar.Id != null && newId != null) {
                List < Bug_Team__c > bugTeamList = new List < Bug_Team__c > ();
                CaseBugAssociation__c caseBugAssObj = new CaseBugAssociation__c();
                caseBugAssObj.Bug__c = bugVar.Id;
                caseBugAssObj.Case__c = newId;
                insert caseBugAssObj;

                if (caseTMMebrList.size() > 0) {
                    for (CaseTeamMember caseTMObj: caseTMMebrList) {
                        Bug_Team__c bugTeamObj = new Bug_Team__c();
                        bugTeamObj.Bug__c = bugVar.Id;
                        bugTeamObj.Chatter_Only__c = true;
                        bugTeamObj.Access__c = 'Read/Write';
                        bugTeamObj.User__c = caseTMObj.MemberId;
                        bugTeamList.add(bugTeamObj);
                    }
                }
                if (bugTeamList.size() > 0) {
                    Insert bugTeamList;
                }

                Case caseObj = [Select Id, CaseNumber From Case Where Id = : newId limit 1];
                FeedItem bugFeed = new FeedItem();
                bugFeed.ParentId = bugVar.Id;
                bugFeed.body = 'Created from Case - Case ' + caseObj.CaseNumber;
                insert bugFeed;

            }
            //End : Manikumar - Case to PDK Bug

            if (bgcaseId != null && bgcaseId != '') {
                case c = [select id from
                    case where id = :
                        bgCaseId
                ][0];
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
            else if (bugVar.Customer_Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugCustSeverity').Error_Message__c));
            //else if (bugVar.Priority__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugPriority').Error_Message__c));
            //else if (bugVar.Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugSeverity').Error_Message__c));

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
            if (bugVar.Bug_Title__c != '' && bugVar.Bug_Classification__c != null && bugVar.Product_Technology__c != null && bugVar.Component__c != null  && bugVar.Version__c != null && bugVar.Customer_Severity__c != null) {
                if (bgcaseId != null || bgcaseId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcaseId;
                    }

                    if (bgcloneId != null || bgcloneId != '') {
                        if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcloneId;
                    }

                    insert bugVar;
                    attachmentPage = new PageReference('/p/attach/NoteAttach?pid=' + bugVar.id + '&retURL=' + bugVar.id);
                    system.debug('aat111' + attachmentPage);
                    return attachmentPage;
                
            } else {

                if (bugVar.Bug_Title__c == '') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugTitle').Error_Message__c));
                else if (bugVar.Product_Technology__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugProduct').Error_Message__c));
                else if (bugVar.Version__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugVersion').Error_Message__c));
                else if (bugVar.Bug_Classification__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugClassification').Error_Message__c));
                else if (bugVar.Component__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugComponent').Error_Message__c));
                else if (bugVar.Customer_Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugCustSeverity').Error_Message__c));
                //else if (bugVar.Priority__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugPriority').Error_Message__c));
                //else if (bugVar.Severity__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugSeverity').Error_Message__c));
                
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
        } 
        else if (newId != null) {
            PageReference casePage = new ApexPages.StandardController(caseobj).view();
            casePage.setRedirect(true);
            return casePage;
        } else {
            Schema.DescribeSObjectResult result = bug__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public void checkRequired(){          
        if(bugVar.Component__c == 'Layer database'){            
               isRequiredFlag = true;                                               
             }
             else{
                    isRequiredFlag = false;
             }                          
    }
}