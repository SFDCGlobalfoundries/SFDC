/*
Type Name: ASICLoadBugFieldsClass
Author: UCM Team
Created Date: 10/20/2016
Reason: Reason: This class is used to copy values from case to ASIC bugs
Test Class: ASICLoadBugFieldsTest
Change History:
Author:
Modified Date: 
……..//
……..
--
*/
public class ASICLoadBugFieldsClass {
    
    private ApexPages.StandardController stdCtrl;
    public List<CaseTeamMember> caseTMMebrList=new List<CaseTeamMember>();
    public bug__c bugVar {
        get;
        set;
    }
    public Case caseobj {get; set; }
    public boolean displayRecord {
        get;
        set;
    }
    public string stRecordTypeName;
    public string newId;
    public string bgCaseId;
    public Boolean isActionActivated {get;set;}
    public string bugTitle {
        get;
        set;
    }
    public boolean newFlag {
        get;
        set;
    }
    public string status {
        get;
        set;
    }
    
    public set<String> listProblemType {get;set;}
    
    public String problemType {get;set;}
    public String subTypeA    {get;set;}
    public String subTypeB    {get;set;}
    public String subTypeC    {get;set;}
    public String subTypeD    {get;set;}
    
    public Boolean isShowSubTypeA {get;set;}
    public Boolean isShowSubTypeB {get;set;}
    public Boolean isShowSubTypeC {get;set;}
    public Boolean isShowSubTypeD {get;set;}
    
    public List<SelectOption> listProblemTypeOptions {get;set;}
    public List<SelectOption> listSubTYpeAOptions {get;set;}
    public List<SelectOption> listSubTYpeBOptions {get;set;}
    public List<SelectOption> listSubTYpeCOptions {get;set;}
    public List<SelectOption> listSubTYpeDOptions {get;set;}
    public Boolean isFromConstructor = false;
    public String loadingOrNot  = 'YES';
    
    // Constructor for controller class
    public ASICLoadBugFieldsClass(ApexPages.StandardController controller) {
        listProblemType = new set<String>();
        status = 'New';
        stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bgCaseId = ApexPages.currentPage().getParameters().get('caseid');
        bug__c bugClone = new bug__c();
        newId = ApexPages.currentPage().getParameters().get('cid');
        newFlag = true;
        bugTitle = 'New Bug';
        bugVar = new bug__c();
        bugVar.recordtypeid = ApexPages.currentPage().getParameters().get('rid');
        displayRecord = true;
        //Start : Manikumar - Case to PDK Bug 
        if(newId != null) {
            newFlag = false;
                caseTMMebrList = [Select MemberId,ParentId,TeamRoleId,TeamTemplateMemberId from CaseTeamMember where ParentId =:newId 
                                                                and MemberId IN (Select Id from User where UserType='Standard')];
            caseobj = [select id,Problem_Type__c,Severity__c,Target_process_node__c ,Library_Release__c,Need_by_Date__c,Technology__c,Sub_Type_A__c, Sub_Type_B__c, Sub_Type_C__c, Sub_Type_D__c, Description,Subject,AccountId,Problem_Class__c,Priority from case where id =:newId];
            bugVar = new bug__c();
            bugVar.Bug_Title__c= caseObj.Subject;
            if(caseObj.Technology__c == 'FX-14') {
                bugVar.Technology__c = 'FX-14P';
            }
            else {
                bugVar.Technology__c=caseObj.Technology__c;
            }
            bugVar.Problem_Class__c = caseObj.Problem_Class__c;
            bugVar.Problem_Type__c= caseObj.Problem_Type__c;
            bugVar.Need_By_Date__c = System.today()+1;
            bugVar.Account_Affected__c= caseObj.AccountId;
            bugVar.Library_Release__c = caseObj.Library_Release__c;
            bugVar.Bug_Description__c= caseObj.Description;
            bugVar.Priority__c = caseObj.Priority;
            bugVar.Severity__c = caseObj.Severity__c;
            bugVar.Sub_Type_A__c= caseObj.Sub_Type_A__c;
            bugVar.Sub_Type_B__c= caseObj.Sub_Type_B__c;
            bugVar.Sub_Type_C__c = caseObj.Sub_Type_C__c;
            bugVar.Sub_Type_D__c = caseObj.Sub_Type_D__c;
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
            
            // Code to dispaly the picklist values in UI
            isFromConstructor   =   true;
            if(bugVar.Problem_Type__c != null){
                retrieveProblemTypeConstructor();
                
                problemType =   bugVar.Problem_Type__c;
                retrieveProblemTypeConstructor1();
                
                problemType =   bugVar.Problem_Type__c;
                isShowSubTypeA = true;
            }
            if(bugVar.Sub_Type_A__c != null ){
                subTypeA = bugVar.Sub_Type_A__C;
                isShowSubTypeB = true;
                bugVar.Problem_Type__c  =   problemType;
                
                retrieveSubTypeAConstructor();
            }
            if(bugVar.Sub_Type_B__c != null && bugVar.Sub_Type_B__c != ''){
                listSubTYpeBOptions.add(new SelectOption(bugVar.Sub_Type_B__c,bugVar.Sub_Type_B__c));
                subTypeB    =   bugVar.Sub_Type_B__c;
                isShowSubTypeC = true;
                bugVar.Sub_Type_A__c  =   subTypeA;
                
                retrieveSubTypeBConstructor();
            }
            if(bugVar.Sub_Type_C__c != null && bugVar.Sub_Type_C__c != ''){
                subTypeC    =   bugVar.Sub_Type_C__c;
                isShowSubTypeD = true;
                bugVar.Sub_Type_B__c  =   subTypeB;
                listSubTYpeCOptions.add(new SelectOption(bugVar.Sub_Type_C__c,bugVar.Sub_Type_C__c));
                retrieveSubTypeCConstructor();
               
            }
            if(bugVar.Sub_Type_D__c != null && bugVar.Sub_Type_D__c != ''){
                subTypeD    =   bugVar.Sub_Type_D__c;
                bugVar.Sub_Type_C__c  =   subTypeC;
                List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
                Set<String> subTypeDValues= new Set<String>();
                listSubTYpeDOptions =   new List<SelectOption>();
                if(subTypeC != ''){
                    listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_C__c =:subTypeC AND Sub_Type_D__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_D__c];
                }
                if(listAccount.size()>0){
                    isShowSubTypeA = true;
                    isShowSubTypeB = true;
                    isShowSubTypeC = true;
                    isShowSubTypeD = true;
                    listSubTYpeDOptions.add(new SelectOption('', '--None--'));
                    for(Bug_ASIC_Picklist__c objAccount : listAccount){
                        if(subTypeDValues.size()>0){
                            if(!subTypeDValues.contains(String.valueOf(objAccount.Sub_Type_D__c))){
                                listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                                subTypeDValues.add(objAccount.Sub_Type_D__c);
                            }    
                        }else{
                            listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                            subTypeDValues.add(objAccount.Sub_Type_D__c);
                        }
                    }
                }
                listSubTYpeDOptions.add(new SelectOption(bugVar.Sub_Type_D__c,bugVar.Sub_Type_D__c));
            }
            isFromConstructor = false;
            
            
        }
    }
    
    public void retrieveProblemTypeConstructor(){
        
        List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c  >();
        listProblemTypeOptions  =   new List<SelectOption>();
        listAccount = [SELECT Id, Name, Problem_Type__c FROM Bug_ASIC_Picklist__c    WHERE Problem_Type__c != null AND IS_Active__c = true ORDER BY Problem_Type__c];
        for(Bug_ASIC_Picklist__c objAccount : listAccount){
            if(listProblemType.size() > 0){
            
                if(!listProblemType.contains(String.valueOf(objAccount.Problem_Type__c))){
                    listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                    listProblemType.add(objAccount.Problem_Type__c);
                }
            }else{
                listProblemTypeOptions.add(new SelectOption('', '--None--'));
                listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                listProblemType.add(objAccount.Problem_Type__c);
            }
        }
    }
    
    public void retrieveProblemTypeValues(){
        retrieveProblemTypeConstructor();
        isShowSubTypeA = false;
        isShowSubTypeB = false;
        isShowSubTypeC = false;
        isShowSubTypeD = false;
    
        listSubTYpeAOptions =   new List<SelectOption>();
        listSubTYpeBOptions =   new List<SelectOption>();
        listSubTYpeCOptions =   new List<SelectOption>();
        listSubTYpeDOptions =   new List<SelectOption>();
    }
    
    public void retrieveProblemTypeConstructor1(){
        bugVar.Problem_Type__c  =   problemType;
        if(!isFromConstructor){
            bugVar.Sub_Type_A__c    =   null;
            bugVar.Sub_Type_B__c    =   null;
            bugVar.Sub_Type_C__c    =   null;
            bugVar.Sub_Type_D__c    =   null;
        }
        List<Bug_ASIC_Picklist__c> listBugPicklist = new List<Bug_ASIC_Picklist__c>();
        Set<String> subTypeAValues= new Set<String>();
        listSubTYpeAOptions =   new List<SelectOption>();
        if(problemType != ''){
            listBugPicklist = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c =:problemType AND Sub_Type_A__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_A__c];
        }
        if(listBugPicklist.size()>0){
            isShowSubTypeA = true;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
            for(Bug_ASIC_Picklist__c objABugPicklist : listBugPicklist){
                if(subTypeAValues.size()>0){
                    if(!subTypeAValues.contains(objABugPicklist.Sub_Type_A__c)){
                        listSubTYpeAOptions.add(new SelectOption(objABugPicklist.Sub_Type_A__c, objABugPicklist.Sub_Type_A__c));
                        subTypeAValues.add(objABugPicklist.Sub_Type_A__c);
                    }    
                }else{
                    listSubTYpeAOptions.add(new SelectOption('', '--None--'));
                    listSubTYpeAOptions.add(new SelectOption(objABugPicklist.Sub_Type_A__c, objABugPicklist.Sub_Type_A__c));
                    subTypeAValues.add(objABugPicklist.Sub_Type_A__c);
                }
            }
        }else{
            isShowSubTypeA = false;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
        }
    }
    
    public void retrieveProblemType(){
        bugVar.Problem_Type__c  =   problemType;
        if(!isFromConstructor){
            bugVar.Sub_Type_A__c = null;
            bugVar.Sub_Type_B__c = null;
            bugVar.Sub_Type_C__c = null;
            bugVar.Sub_Type_D__c = null;
        }
        List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
        Set<String> subTypeAValues= new Set<String>();
        listSubTYpeAOptions =   new List<SelectOption>();
        if(problemType != ''){
            listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c =:problemType AND Sub_Type_A__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_A__c];
        }
        if(listAccount.size()>0){
            isShowSubTypeA = true;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
            for(Bug_ASIC_Picklist__c objAccount : listAccount){
                if(subTypeAValues.size()>0){
                    if(!subTypeAValues.contains(objAccount.Sub_Type_A__c)){
                        listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                        subTypeAValues.add(objAccount.Sub_Type_A__c);
                    }    
                }else{
                    listSubTYpeAOptions.add(new SelectOption('', '--None--'));
                    listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                    subTypeAValues.add(objAccount.Sub_Type_A__c);
                }
            }
        }else{
            isShowSubTypeA = false;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
        }
            
        subTypeA = '';
        subTypeB = '';
        subTypeC = '';
        subTypeD = '';
        listSubTYpeBOptions =   new List<SelectOption>();
        listSubTYpeCOptions =   new List<SelectOption>();
        listSubTYpeDOptions =   new List<SelectOption>();
    }
    
    public void retrieveSubTypeAConstructor(){
        bugVar.Sub_Type_A__c  =   subTypeA;
        bugVar.Problem_Type__c  =   problemType;
        if(!isFromConstructor){
            bugVar.Sub_Type_B__c    =   null;
            bugVar.Sub_Type_C__c    =   null;
            bugVar.Sub_Type_D__c    =   null;
        }
        List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
        Set<String> subTypeBValues= new Set<String>();
        listSubTYpeBOptions =   new List<SelectOption>();
        system.debug(':::: subTYpeA'+subTypeA);
        if(subTypeA != ''){
            listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType and IS_Active__c = TRUE AND Sub_Type_B__c != null ORDER BY Sub_Type_B__c];
        }
        if(listAccount.size()>0){
            isShowSubTypeA = true;
            isShowSubTypeB = true;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
            listSubTYpeBOptions.add(new SelectOption('', '--None--'));
            for(Bug_ASIC_Picklist__c objAccount : listAccount){
                if(subTypeBValues.size()>0){
                    if(!subTypeBValues.contains(String.valueOf(objAccount.Sub_Type_B__c))){
                        listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                        subTypeBValues.add(objAccount.Sub_Type_B__c);
                    }    
                }else{
                    listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                    subTypeBValues.add(objAccount.Sub_Type_B__c);
                }
            }
        }else{
            isShowSubTypeA = true;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
        }
    }
    
    
    public void retrieveSubTypeA(){
        retrieveSubTypeAConstructor();
        subTypeB = '';
        subTypeC = '';
        subTypeD = '';
    }
    
    
    public void retrieveSubTypeBConstructor(){
        bugVar.Sub_Type_B__c  =   subTypeB;
        if(!isFromConstructor){
            bugVar.Sub_Type_C__c    =   null;
            bugVar.Sub_Type_D__c    =   null;
        }
        List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
        Set<String> subTypeCValues= new Set<String>();
        listSubTYpeCOptions =   new List<SelectOption>();
        if(subTypeB != '' && subTypeB != null){
            listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c != null  and IS_Active__c = TRUE ORDER BY Sub_Type_C__c];
        }
        if(listAccount.size()>0){
            isShowSubTypeA = true;
            isShowSubTypeB = true;
            isShowSubTypeC = true;
            isShowSubTypeD = false;
            listSubTYpeCOptions.add(new SelectOption('', '--None--'));
            for(Bug_ASIC_Picklist__c objAccount : listAccount){
                if(subTypeCValues.size()>0){
                    if(!subTypeCValues.contains(String.valueOf(objAccount.Sub_Type_C__c))){
                        listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                        subTypeCValues.add(objAccount.Sub_Type_C__c);
                    }    
                }else{
                    listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                    subTypeCValues.add(objAccount.Sub_Type_C__c);
                }
            }
        }else{
            isShowSubTypeA = true;
            isShowSubTypeB = true;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
        }
    }
    
    
    public void retrieveSubTypeB(){
        retrieveSubTypeBConstructor();
        subTypeC = '';
        subTypeD = '';
    }
    
    public void retrieveSubTypeCConstructor(){
        bugVar.Sub_Type_C__c  =   subTypeC;
        if(!isFromConstructor){
            bugVar.Sub_Type_D__c    =   null;
        }
        List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
        Set<String> subTypeDValues= new Set<String>();
        listSubTYpeDOptions =   new List<SelectOption>();
        if(subTypeC != ''){
            listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c =:subTypeC AND Sub_Type_D__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_D__c];
        }
        if(listAccount.size()>0){
            isShowSubTypeA = true;
            isShowSubTypeB = true;
            isShowSubTypeC = true;
            isShowSubTypeD = true;
            listSubTYpeDOptions.add(new SelectOption('', '--None--'));
            for(Bug_ASIC_Picklist__c objAccount : listAccount){
                if(subTypeDValues.size()>0){
                    if(!subTypeDValues.contains(String.valueOf(objAccount.Sub_Type_D__c))){
                        listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                        subTypeDValues.add(objAccount.Sub_Type_D__c);
                    }    
                }else{
                    listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                    subTypeDValues.add(objAccount.Sub_Type_D__c);
                }
            }
        }else {
            isShowSubTypeA = true;
            isShowSubTypeB = true;
            isShowSubTypeC = true;
            isShowSubTypeD = false;
        }
    }
    
    public PageReference retrieveSubTypeC(){
        retrieveSubTypeCConstructor();
        subTypeD = '';
        return null;
    }
    
    //Page saves the bug and redirects to list page.
    public pagereference savebug() {
        PageReference bugPage;
        bugVar.Sub_Type_D__c = subTypeD;
        try {
            bugVar.status__c = 'New';
            bugVar.Customer_Project__c = 'ALL CUSTOMERS';
            Boolean isError = false;
            if(bugVar.Problem_Type__c == null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Type Value'));
                isError = true;
            }
            
            if((bugVar.Sub_TYpe_A__c == null || bugVar.Sub_Type_A__c == '') ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub Type A Value'));
                isError = true;
            }
            
            if(isShowSubTypeB==true && (bugVar.Sub_Type_B__c == '' || bugVar.Sub_Type_B__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type B value'));
                isError = true;
            }
            if(isShowSubTypeC==true && (bugVar.Sub_Type_C__c == '' || bugVar.Sub_Type_C__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type C value'));
                isError = true;
            }
            if(isShowSubTypeD==true && (bugVar.Sub_Type_D__c == '' || bugVar.Sub_Type_D__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type D value'));
                isError = true;
            }
            
            if((bugVar.Bug_Description__c==null || bugVar.Bug_Description__c=='') && bugVar.Id==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Description value'));
                isError = true;
            }
            
            if (bugVar.Bug_Title__c == '') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, BugErrorMessages__c.getValues('ReqBugTitle').Error_Message__c));
            if (bugVar.Problem_Type__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Problem Type'));
            if(bugVar.Priority__c==null || bugVar.Priority__c== ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Priority value'));
                isError = true;
            }
            if(bugVar.Severity__c==null || bugVar.Severity__c== ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Severity value'));
                isError = true;
            }
            if (bugVar.Technology__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Technology'));
            if (bugVar.Problem_Class__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Problem Class'));
            if (bugVar.Library_Release__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Library Release'));
            if (bugVar.Account_Affected__c == null) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Account Affected'));
            
            if(!isError){
                if (bugVar.Bug_Title__c != '' && bugVar.Technology__c != null && bugVar.Problem_Class__c!= null && 
                    bugVar.Problem_Type__c!= null && bugVar.Library_Release__c!= null &&
                    bugVar.Sub_Type_A__c != null && bugVar.Account_Affected__c != null) {
                    if (bugVar.id == null) {
                        if (bgcaseId != null || bgcaseId != '') {
                            if (bugVar.Origin__c == null || bugVar.Origin__c == '') bugVar.Origin__c = bgcaseId;
                        }
                        insert bugVar;
                    }
                    
                    if (bugVar.Id != null && newId != null) {
                        List < Bug_Team__c > bugTeamList = new List < Bug_Team__c > ();
                        CaseBugAssociation__c caseBugAssObj = new CaseBugAssociation__c();
                        caseBugAssObj.Bug__c = bugVar.Id;
                        caseBugAssObj.Case__c = newId;
                        caseBugAssObj.UniqueCaseBug__c = bugVar.Id+newId;
                        insert caseBugAssObj;
        
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
                    }
                    return null;
                } else{
                    return null;
                }
        } catch (Exception e) {            
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICLoadBugFieldsClass.class.getName();
            alw.sourceFunction = 'savebug()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
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
    
    public class applicationException extends Exception {}
}