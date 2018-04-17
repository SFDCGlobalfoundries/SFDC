/*********************************************************************************/
  // Purpose      : WRCreateController class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 24 Nov, 2015
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Responsible for creating PDK Request from Case Detail Page.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class WRCreateController {
    private ApexPages.StandardController stdCtrl;
    public List<CaseTeamMember> caseTMMebrList=new List<CaseTeamMember>();
    Set<String> ccMemberIdSet = new Set<String>();
    public bug__c bugVar {
        get;
        set;
    }
    public Case caseobj {get; set; }
    
    public boolean displayRecord {
        get;
        set;
    }
    
    public string newId;
    public string bugTitle {
        get;
        set;
    }
    public boolean newPicklist {
        get;
        set;
    }
     public boolean compPicklist {
        get;
        set;
    }
    // Constructor for controller class
    public WRCreateController(ApexPages.StandardController controller) {
        stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        newId = ApexPages.currentPage().getParameters().get('cid');
        
        if(newId != null) {
            displayRecord = true;
            caseTMMebrList = [Select MemberId,ParentId,TeamRoleId,TeamTemplateMemberId from CaseTeamMember where ParentId =:newId
                                    and MemberId IN (Select Id from User where UserType='Standard')];
            bugTitle = 'New Bug/Work Request';
            caseobj = [select id,Description,Subject,Master_PDK__c,Target_process_node__c,Geometry__c,Need_by_Date__c,
                            Process_Variant__c,Account.Name,Opportunity__c,Subcategory__c,AccountId,Metal_Stack__c,Internal_or_external__c from case where id =:newId];
            bugVar = new bug__c();
            bugVar.Bug_Title__c= caseObj.Subject;
            bugVar.Bug_Description__c= caseObj.Description;
            if(caseObj.Master_PDK__c != null) {
                bugVar.Request_Type__c = 'Yes';
            } else {
                bugVar.Request_Type__c = 'No';
            }
            List<SelectOption> selectList = getBugPickVal();
            if(caseObj.Geometry__c != null) {
                boolean flag = getFlag(caseObj.Geometry__c,selectList);
                if(flag == true){
                    bugVar.Geometry__c= caseObj.Geometry__c;
                } 
            }
            bugVar.Need_By_Date__c = caseObj.Need_by_Date__c;
            bugVar.Master_PDK__c = caseObj.Master_PDK__c;
            bugVar.Target_Process_Node__c = caseObj.Target_process_node__c;
            bugVar.Proposed_Technology_Name__c = caseObj.Process_Variant__c;
            bugVar.Opportunity__c = caseObj.Opportunity__c;
            bugVar.Metal_Stack__c = caseObj.Metal_Stack__c;
            
            List<SelectOption> componentList = getCompPickVal();
            if(caseObj.Subcategory__c != null) {
                boolean compFlag = getCompFlag(caseObj.Subcategory__c,componentList);
                if(compFlag == true){
                    bugVar.Component__c= caseObj.Subcategory__c;
                }
            }
             
            bugVar.RecordTypeId= ApexPages.currentPage().getParameters().get('rid');
        }
    }
    
    //Method assign the value to the field
    public List<SelectOption> getBugPickVal() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Bug__c.Geometry__c.getDescribe();
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
    
    //Method assign the value to the field
    public List<SelectOption> getCompPickVal() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Bug__c.Component__c.getDescribe();
        List<Schema.PicklistEntry> bugPickVal = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pickVal : bugPickVal) {
            options.add(new SelectOption(pickVal.getLabel(), pickVal.getValue()));
        } 
        return options;
    }
    
    //Method Contains Picklist Value continues
    public boolean getCompFlag(String bugPickval,List<SelectOption> casePickvalList){
        newPicklist =  false;
        for(System.SelectOption str:casePickvalList) {            
            if(!string.valueOf(bugPickval).equalsIgnoreCase(string.valueOf(str.getValue()))) {
                continue;
            }else {
                compPicklist =true;
                break;
            }          
        }
        return   compPicklist ;
    } 
       
    //Page saves the bug and redirects to list page.
    public pagereference savebug() {
        PageReference bugPage;
        try {
            if (bugVar.Bug_Title__c != '' && bugVar.Bug_Description__c != null && bugVar.Request_Type__c != null && bugVar.Geometry__c != null
                && bugVar.Need_By_Date__c != null && bugVar.Target_Process_Node__c != null) {
                
                insert bugVar;
                
                if(bugVar != null) {
                    
                    CaseBugAssociation__c caseBugAssObj = new CaseBugAssociation__c();
                    caseBugAssObj.Bug__c = bugVar.Id;
                    caseBugAssObj.Case__c = newId;
                    insert caseBugAssObj;
                    
                    Case caseObj = [Select Id,CaseNumber,Internal_or_external__c,AccountId,Account.Name From Case Where Id=:newId limit 1];
                    FeedItem bugFeed = new FeedItem();
                    bugFeed.ParentId = bugVar.Id;
                    bugFeed.body = 'Created from Case - Case '+caseObj.CaseNumber;
                    insert bugFeed;
                    
                    if(bugVar.Metal_Stack__c != null) {
                        Metal_Stacks__c metalStackObj = new Metal_Stacks__c();
                        metalStackObj.Metal_Option_Type__c = 'NA';
                        metalStackObj.Metal__c = bugVar.Metal_Stack__c;
                        metalStackObj.Bug_Work_Request__c = bugVar.Id;
                        insert metalStackObj;
                    }
                    
                    if(bugVar.Component__c != null) {
                        PDK_Component__c pdkComponentObj = new PDK_Component__c();
                        pdkComponentObj.Product_Technology__c = bugVar.Target_Process_Node__c;
                        pdkComponentObj.Component__c = bugVar.Component__c;
                        pdkComponentObj.Bug_Work_Request__c = bugVar.Id;
                        insert pdkComponentObj;
                    }
                    
                    List<Related_Accounts__c> relatedAccObjList = new List<Related_Accounts__c>();
                    Related_Accounts__c relatedAccObj = new Related_Accounts__c();
                    Account accObj = [Select Id,Name from Account where name =: System.Label.GlobalfoundryAccount];
                    if(accObj != null && caseObj.Internal_or_external__c == true) {
                        relatedAccObj.Bug_Work_Request__c = bugVar.Id;
                        relatedAccObj.Account__c = accObj.Id;
                        relatedAccObjList.add(relatedAccObj); 
                    }  
                    else if(caseObj.AccountId != null && caseObj.Internal_or_external__c == false) {
                        relatedAccObj.Bug_Work_Request__c = bugVar.Id;
                        relatedAccObj.Account__c = caseObj.AccountId; 
                        relatedAccObjList.add(relatedAccObj); 
                    }
                    if(relatedAccObjList.size() > 0) {
                        insert relatedAccObjList;
                    }                  
                    List<CC_List__c> ccList = [Select Id,Name,User__c from CC_List__c where Bug_Work_Request__c = :bugVar.Id];
                    for(CC_List__c ccObj : ccList) {
                        ccMemberIdSet.add(ccObj.User__c);
                    }
                    
                    List<CC_List__c> ccTeamList=new List<CC_List__c>();
                    if(caseTMMebrList.size() > 0) {
                        for(CaseTeamMember caseTMObj : caseTMMebrList){
                            if(!ccMemberIdSet.contains(caseTMObj.MemberId)) {
                                CC_List__c ccTeamObj=new CC_List__c();
                                ccTeamObj.Bug_Work_Request__c = bugVar.Id;
                                ccTeamObj.Roles_Responsibility__c = 'Subscription Only';
                                ccTeamObj.Access__c = 'Read/Write';
                                ccTeamObj.User__c = caseTMObj.MemberId;
                                ccTeamList.add(ccTeamObj);
                            }
                        }
                    }
                    if(ccTeamList.size() > 0) {
                        Insert ccTeamList;
                    }
                } 
                
                bugPage = new ApexPages.StandardController(bugVar).view();
                bugPage.setRedirect(true);
                return bugPage;
            } else {
               if (bugVar.Bug_Title__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('ReqBugTitle').Error_Message__c));
                else if (bugVar.Bug_Description__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('WR_ReqBugDesc').Error_Message__c));
                else if (bugVar.Request_Type__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('WR_ReqRequestType').Error_Message__c));
                else if (bugVar.Geometry__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('WR_ReqGeometry').Error_Message__c));
                else if (bugVar.Target_Process_Node__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('WR_ReqTargetNode').Error_Message__c));
                else if (bugVar.Need_By_Date__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, BugErrorMessages__c.getValues('WR_ReqNeedByDate').Error_Message__c));
                return null;
            }
            
        } catch (Exception e) {
            return null;
        }
    }
    
    //Method redirects the list page of Bugs with out saving the bug
    public pagereference cancelBug() {
        PageReference casePage = new ApexPages.StandardController(caseobj).view();
        casePage.setRedirect(true);
        return casePage;
    }
}