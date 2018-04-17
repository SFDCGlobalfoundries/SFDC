/*********************************************************************************/
  // Purpose      : CaseAvailableRelatedBugs class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 16 Mar, 2017
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : Responsible for showing Bug number for the customers.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public without sharing class CaseAvailableRelatedBugs { 
    
    // create a list of strings to hold the conditions
    public Boolean Isportal{get; set;}
    public List<caseBugSubClass> caseObjList{get; set;}
    public List<caseBugSubClass> caseObjExpList{get;set;}
    public String BaseURLStr;
    public String loginUser;
    
    
    private integer offset = 0;
    public Boolean firstOff{set;get;}    // previous part
    public Boolean lastOff{set;get;}     // next part
    public integer totalRecs = 0;
    public integer queryLimit= 10;
    public Integer limits{set;get;}
    public Integer pageNumber{set;get;}
    
        
    // constructor
    public CaseAvailableRelatedBugs() {
        // Check if the logged in user is portal user
        BaseURLStr = URL.getSalesforceBaseURL().toExternalForm();
        String myString = 'globalfoundryview'; 
        loginUser = UserInfo.getUserId();        
        if(BaseURLStr.contains(myString)) {
            Isportal= false;
        }
        else{
            Isportal=true;
        }   
        exportToExcel();
        
        firstOff = false;
        pageNumber = 1;
        limits = 10;
        
        // initialy check page more then 1 or not
        if(totalRecs > queryLimit) lastOff = true;
        else lastOff = false;
           
    }

    public List<caseBugSubClass> getCaseBugAss() {
        
        String queryString = 'Select Id,Name,Bug__c,Case__c,Status__c,Bug__r.Name,Case__r.CaseNumber,Case__r.OwnerId,Case__r.CreatedById,CreatedDate from CaseBugAssociation__c where (NOT (Case__r.Status like \'%Closed%\')) AND (Case__r.OwnerId =:loginUser OR Case__r.CreatedById=:loginUser)';
        if(caseObjList != null && !caseObjList.isEmpty()) {
            caseObjList.clear();
        }
        
        if(totalRecs !=null && totalRecs ==0) {
            List<CaseBugAssociation__c> csTemp = Database.query(queryString);
            totalRecs = (csTemp !=null &&csTemp.size()>0)?csTemp.size():0;
        }
        
        caseObjList = new List<caseBugSubClass>();
        queryString += ' ORDER BY CreatedDate DESC LIMIT :queryLimit OFFSET :offset';
        for(CaseBugAssociation__c c: Database.query(queryString)){
            caseObjList.add(new caseBugSubClass(c));
        }
        
        return caseObjList;
        
    }
    
    public class caseBugSubClass{
        public String bugStatus{get;set;}
        public String caseNumber{get;set;}
        public String bugNumber{get;set;}
        public caseBugSubClass(CaseBugAssociation__c caseBugObj){
                caseNumber = caseBugObj.Case__r.CaseNumber;
                bugNumber = caseBugObj.Bug__r.Name;
                bugStatus = caseBugObj.Status__c;
        }
    }
    
     //exportToExcel Method to download report Data in Excel Sheet
    public pagereference exportToExcel(){
        caseObjExpList=new List<caseBugSubClass>();
        PageReference pageRef;
        transient string url;
        for(CaseBugAssociation__c c: [Select Id,Name,Bug__c,Case__c,Status__c,Bug__r.Name,Case__r.CaseNumber,Case__r.OwnerId,Case__r.CreatedById,CreatedDate from CaseBugAssociation__c where (NOT (Case__r.Status like '%Closed%')) AND (Case__r.OwnerId =:loginUser OR Case__r.CreatedById=:loginUser) Order By CreatedDate]) {
                caseObjExpList.add(new caseBugSubClass(c));
        }
        url = '/apex/CaseAssociationBugsExcel';
        pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    // switch on first page
    public PageReference first() {
        offset = 0;
        firstOff = false;
        lastOff = true;
        pageNumber = 1;
        return null;
    }
    // navigate on previous page
    public PageReference previous() {
        if(offset-queryLimit <= 0){
            offset = 0;
            firstOff = false;
        }else 
        offset = (offset-queryLimit);
        lastOff = true;
        pageNumber--;
        return null;
    }
    // navigate on next page
    public PageReference next() {
        offset = offset + queryLimit;
        if(offset+queryLimit >= totalRecs) lastOff = false;
        firstOff = true;
        pageNumber++;
        return null;
    }
    // switch on last page
    public PageReference last() {
        //offset = totalrecs - math.mod(totalRecs,queryLimit);
        // set page number of and offset
        if(Math.Mod(totalRecs,queryLimit) == 0){
            offset = totalRecs-queryLimit;
            pageNumber = totalRecs/queryLimit;
        }
        else{
            offset = (totalRecs/queryLimit)*queryLimit;
            pageNumber = (totalRecs/queryLimit)+1;
        }
        lastOff = false;
        firstOff = true;
        return null;
    }
    public boolean getprev() {
        if(offset == 0) {
            return true;
        } else {
            return false;
        }
    }
    public boolean getnxt() {
        if((offset + queryLimit) > totalRecs) {
            return true;
        } else {
            return false;
        }
    }
    
     // for direct page switching
    public void pageNavigation() {
    
        /* if user enter more then number ot total page number than
           set the value last page number in PageNumber. */
        if(Math.Mod(totalRecs,queryLimit) == 0 && pageNumber > totalRecs/queryLimit)
            pageNumber = totalRecs/queryLimit;    
        else if(pageNumber > (totalRecs/queryLimit)+1)
            pageNumber = (totalRecs/queryLimit)+1;
        
        // set offset according to pageNumber    
        if((pageNumber-1)*queryLimit < 0) offset = 0;
        else offset = (pageNumber-1)*queryLimit;    
        
        /* if pageNumber is 1 than deactive previous navigator
           else if pageNumber is o tha set the value of pageNumber is 1
           else if pageNumber is more than 1 active next navigator
        */
        if(pageNumber == 1) firstOff = false;
        else if(pageNumber == 0) pageNumber = 1;
        else if(pageNumber > 1) firstOff = true;
        
        // user enter last number of pagenumber than deactive next navigator
        if(Math.Mod(totalRecs,queryLimit) == 0){
            if(pageNumber == totalRecs/queryLimit) lastOff = false;
            else lastOff = true;
        }
        else{
            if(pageNumber == (totalRecs/queryLimit)+1) lastOff = false;
            else lastOff = true;
        }
    }
    
     // Show current record numbers
    public String getRecordInfo(){
        integer lastLimit;
        if(offset+queryLimit > totalRecs) lastLimit = totalRecs;
        else lastLimit = offset+queryLimit;
        return (offset+1) + ' - ' + lastLimit + ' of '+totalRecs;
    }
    
    // change query limit
    public void changeLimit() {
        // set query limit
        queryLimit = Integer.valueOf(limits);
        
        offset = 0;
        firstOff = false;
        
        // initialy check page more then 1 or not
        if(totalRecs > queryLimit) lastOff = true;
        else lastOff = false;
        
        // set page number
        pageNumber = 1;
    }
    
    // for record limits
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        options.add(new SelectOption('200','200'));
        options.add(new SelectOption('500','500'));
        return options;
    }    
}