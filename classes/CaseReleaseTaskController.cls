/*
Type Name: CaseReleaseTaskController
Author: Cognizant Case Management Team
Created Date: 27-Jan-2015
Reason: Reason: This is the controllar class for CaseReleaseTask page.
Test Class: CaseVisualforceControllerTest
Change History:
Author: 
Modified Date: 
……..
……..//
--
*/

public with sharing class CaseReleaseTaskController{
public transient String QueryCase;
private final Id releaseTaskid;
public final Release_Task__c releaseTask{get; set;}

public String SearchName {get; set;}
public String SearchCaseNumber{get; set;}
public String creator {get; set;}
public list<caseWrapper> caseSearchList {get;set;}

    public CaseReleaseTaskController() {
        caseSearchList  = new list<caseWrapper>();
        if(isNotBlank(ApexPages.currentPage().getParameters().get('Id'))) {
            if(releaseTaskid==null)
                if(validateId(ApexPages.currentPage().getParameters().get('Id'))!=null)
                    releaseTaskid = ApexPages.currentPage().getParameters().get('Id');
            
            if(releaseTaskid!=null){
                    if(releaseTask ==null)
                        releaseTask = [Select Id, Name from Release_Task__c where Id =: releaseTaskid];         
            }
        }     
    }
    
    /***
    * SearchCase - set search criteria fields and refresh Case table
    ***/
    public PageReference SearchCase() { 
        getCaseList();
        return null;
    }
    public void getCaseList() {
        if (isNotBlank(SearchName) || isNotBlank(SearchCaseNumber) || isNotBlank(creator)){        
            transient list < Case > listCase = new list < Case > ();
            if(caseSearchList !=null)
                caseSearchList.clear();
            BuildQuery();
            listCase = Database.Query(QueryCase);
            if(listCase != null && listCase.size()>0)
            {
                for(Case co : listCase)
                {
                     caseSearchList.add(new caseWrapper(false,co));               
                }
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter any search string(Subject/Case Number/Case Creator).'));
        }         
    }
    
    /**
    This method is used for Adding & Validating CCtoCase records
    @method name: add
    @parameter:   NA.
    @return :     NA.
    **/
    public PageReference add() {
        
        Set<String> setTempIds = new Set<String>();
        transient list < Case > listCase = new list < Case > ();
        PageReference pr = null; 
        integer caseCount = 0;
        try{
            if(!caseSearchList.isEmpty()) 
            {
                for(caseWrapper co : caseSearchList)
                {
                    if(co.isChecked)
                    {
                        co.objCase.Release_Task__c =releaseTaskid;
                        listCase.add(co.objCase);                    
                        caseCount ++;   
                    }
                }
            }
            
            if(caseCount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No records were selected, please select atleast one records to link.'));
            }else if(caseCount > 0)
            {                
                    if(listCase !=null && listCase.size()>0){
                        update listCase;
                        pr = new PageReference('/'+releaseTaskid);                   
                    }
            }
        }Catch(Exception e){System.Debug('Exception Occurred' + e.getMessage());}
         return pr;
    }
    
    
    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() {
        String QueryWhere = '';
        QueryCase = 'SELECT Id, CaseNumber, ContactId, Contact.Name, Description, Priority, Category__c , Status , Subject , PDK_Name__c, CreatedBy.Id , Account_Name__c, SubCategory__c ,' + 
                    'Classification__c , ClosedDate, CreatedDate, Case_Record_Type__c, OwnerId, Owner.Name, Origin,Age_of_Case__c, Release_Task__c,' +  
                    'Need_by_Date__c, Expected_Close_Date__c, CreatedById, CreatedBy.Name,LastModifiedDate ' +
            ' FROM Case';
        
        QueryWhere = BuildWhere(QueryWhere, ' (Release_Task__c  = null)');
        QueryWhere = BuildWhere(QueryWhere, ' (Case_Record_Type_API__c  IN (\'Internal_Case\',\'External_System\'))');
             
        if (SearchName != null && SearchName !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (Subject LIKE \'%' + String.escapeSingleQuotes(SearchName) + '%\')');
        }
        if (SearchCaseNumber != null && SearchCaseNumber !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (CaseNumber LIKE \'%' + String.escapeSingleQuotes(SearchCaseNumber) + '%\')');
        }               
        if (creator != null && creator !='') {
            QueryWhere = BuildWhere(QueryWhere, ' (CreatedBy.Name LIKE \'%' + String.escapeSingleQuotes(creator) + '%\')');            
        }
        QueryCase += QueryWhere;  
        QueryCase += ' ORDER BY LastModifiedDate LIMIT 20';
    }
    
    /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;            
        }
    }
    
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    /***
    * ClearCaseSelectedSet - remove selected Cases and initialize counter
    ***/
    public PageReference ClearAll(){
        SearchName = '';
        SearchCaseNumber = '';
        creator ='';
        if(caseSearchList !=null)
            caseSearchList.clear();
        return null;
    }
     /**
    This method is used for validating Case Ids & users Ids
    @method name: validateId
    @parameter:   String Case Id.
    @return :     String Case Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
    }
    
    public PageReference closeEvent() {        
        PageReference pr = new PageReference('/'+releaseTaskid);
        return pr;
    }
    
     /**
    This class is used for creating mapping between isChecked & contact contactFound.
    @Class name: contactWrapper
    @parameter:   NA.
    @return :     NA.
    **/
    public class caseWrapper
    {
        public boolean isChecked{get;set;}
        public Case objCase{get;set;}

        public caseWrapper(boolean x,Case y)
        {
            isChecked = x;
            objCase = y;
        }
    }
}