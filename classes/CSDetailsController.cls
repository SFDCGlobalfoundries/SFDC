/*********************************************************************************/
  // Purpose      : CSDetailsController class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 25 Aug, 2015
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : Responsible for modifying custom csSettings data as a customizable way.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public with sharing class CSDetailsController{

    // create a list of strings to hold the conditions
    List<string> searchCon = new List<string>();
    private integer totalRecs = 0;
    private integer offset = 0;
    private integer queryLimit= 10;
    public Integer limits{set;get;}
    private String exptype;
    
    public Boolean firstOff{set;get;}    // previous part
    public Boolean lastOff{set;get;}     // next part
    public Integer pageNumber{set;get;}

    //Custom setting fields display
    public CSforDefaultownerandteam__c editCSObj { get; set; }
    public List<CSforDefaultownerandteam__c> csObjList {get;set;}
    public transient List<CSforDefaultownerandteam__c> csObjexportList {get;set;}
    public boolean exportExcel {get; set;}
    public boolean editPanel {get; set;}
    public boolean newPanel {get; set;}
    public string csName {get; set;}
    public string bugAdmin {get; set;}
    public string bugComponent {get; set;}
    public string bugOwner {get; set;}
    public string bugTeam {get; set;}
	public string addBugTeam {get; set;}
    public string productAffected {get; set;}
    public boolean csEditFlag{get;set;}
    Public List<User> userList{get;set;}
    Public List<Group> groupList{get;set;}
    Public String searchStr{get;set;}
    public boolean searchSection {get; set;}
    public boolean newButtonPanel {get; set;}
    public boolean recordSearch {get; set;}
    public Map<string,string> groupMap{get;set;}
	public Map<string,string> addGroupMap{get;set;}
    public Map<id,List<string>> bbTeamMap{get;set;}
	public Map<id,List<string>> addBugTeamMap{get;set;}
    public Map<id,List<string>> bOwnerMap{get;set;}
    
    
    // initial query string for Custom settings
    String queryString = 'Select Name,Bug_Component__c,Bug_Admin__c,Bug_Owner__c,Product_affected__c,Bug_BugTeam__c,Additional_Bug_Team__c from CSforDefaultownerandteam__c';

    public CSDetailsController() {
        editCSObj = new CSforDefaultownerandteam__c();
        csObjexportList = new List<CSforDefaultownerandteam__c>();
        newpanel = false;
        exportExcel = false;
        csEditFlag=false;
        editPanel = true;
        recordSearch = true;
        newButtonPanel = true;
        exptype = '';
        limits = 10;
        firstOff = false;
        pageNumber = 1;
        
        // initialy check page more then 1 or not
        if(totalRecs > queryLimit) lastOff = true;
        else lastOff = false;
        
        List<CSforDefaultownerandteam__c> csList=database.query(queryString);
        groupmap=new Map<string,string>();
		addGroupMap=new Map<string,string>();
        Set<id> bugAdminIdSet=new Set<id>();
        Set<id> userIdSet=new Set<id>();
        
        bbTeamMap=new Map<id,List<string>>();
		addBugTeamMap=new Map<id,List<string>>();
        
        for(CSforDefaultownerandteam__c cs:csList){
            List<string> sTemp = new List<string>();
            List<string> ssTemp = new List<string>();
            bbTeamMap.put(cs.id,sTemp);
            addBugTeamMap.put(cs.id,ssTemp);
            List<string> str = new List<String>();
            if(cs.Bug_BugTeam__c!=null) {
                str = cs.Bug_BugTeam__c.split(',');
                if(str.size()>0) {
                    for(string strCS : str) {
                        if(strCS != null && strCS.substring(0,3)=='00G') {
                            bugAdminIdSet.add(strCS.trim());
                        }  else if(strCS != null && strCS.substring(0,3)=='005') {
                            userIdSet.add(strCS.trim());
                        }    
                        bbTeamMap.get(cs.id).add(strCS);
                        groupmap.put(strCS,'');
                    }
                }
            }
			if(cs.Additional_Bug_Team__c!=null) {
                str = cs.Additional_Bug_Team__c.split(',');
                if(str.size()>0) {
                    for(string strCS : str) {
                        if(strCS != null && strCS.substring(0,3)=='00G') {
                            bugAdminIdSet.add(strCS.trim());
                        }  else if(strCS != null && strCS.substring(0,3)=='005') {
                            userIdSet.add(strCS.trim());
                        }    
                        addBugTeamMap.get(cs.id).add(strCS);
                        addGroupMap.put(strCS,'');
                    }
                }
            }
            if(cs.Bug_Admin__c!=null && cs.Bug_Admin__c.substring(0,3)=='00G') {
                bugAdminIdSet.add(cs.Bug_Admin__c.trim());
            } else if(cs.Bug_Admin__c!=null && cs.Bug_Admin__c.substring(0,3)=='005') {
                userIdSet.add(cs.Bug_Admin__c.trim());
            }
            if(cs.Bug_Owner__c!=null && cs.Bug_Owner__c.substring(0,3)=='00G') {
                bugAdminIdSet.add(cs.Bug_Owner__c.trim());
            } else if(cs.Bug_Owner__c!=null && cs.Bug_Owner__c.substring(0,3)=='005') {
                userIdSet.add(cs.Bug_Owner__c.trim());
            }
            groupmap.put(cs.Bug_Owner__c,'');
            groupmap.put(cs.Bug_Admin__c,'');
            
        }
        Map<string,group> groupmapTemp=new Map<string,group>([select id,name from group where id in: bugAdminIdSet]);
        Map<string,user> userTemp=new Map<string,user>([select id,name from user where id in: userIdSet]);
        for(string str : groupmapTemp.keyset()) {
            groupmap.put(string.valueof(str).substring(0,15),groupmapTemp.get(str).Name);
            groupmap.put(str,groupmapTemp.get(str).Name);
            
			addGroupMap.put(string.valueof(str).substring(0,15),groupmapTemp.get(str).Name);
            addGroupMap.put(str,groupmapTemp.get(str).Name);
        }
        for(string str : userTemp.keyset()) {
            groupmap.put(string.valueof(str).substring(0,15),userTemp.get(str).Name);
            groupmap.put(str,userTemp.get(str).Name);
            
			addGroupMap.put(string.valueof(str).substring(0,15),userTemp.get(str).Name);
            addGroupMap.put(str,userTemp.get(str).Name);
        }
        
        //generating bugbug team column values
        for(id id : bbTeamMap.keyset()) {
            groupmap.put(id,'');
            string strCS = '';
            for(string str : bbTeamMap.get(id)) {
                strCS = strCS+groupmap.get(str)+',';
            }
            strCS = strCS.substringbeforelast(',');
            groupmap.put(id,strCS);
        }
		
		//generating Additional Bug team column values
        for(id id : addBugTeamMap.keyset()) {
            addGroupMap.put(id,'');
            string strCS = '';
            for(string str : addBugTeamMap.get(id)) {
                strCS = strCS+addGroupMap.get(str)+',';
            }
            strCS = strCS.substringbeforelast(',');
            addGroupMap.put(id,strCS);
        }
    }
    
    public void newCS() {
        newPanel = true;
        editPanel = false;
        csEditFlag=true;
        recordSearch = false;
    }

    public pageReference saveNew() {
        editpanel = false;
        String queryStr = 'Select Name from CSforDefaultownerandteam__c where Name =:csName';
        csObjList  =Database.query(queryStr);
        if(csObjList.size() > 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'There is already an item in this list with the name '+csName));
            return null;
            newPanel = false;
        }
        if(csName == '' || csName == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter name'));
            return null;
            newPanel = false;
        }
        CSforDefaultownerandteam__c csObj = new CSforDefaultownerandteam__c();                   
        csObj.name = csName;
        csObj.Bug_Admin__c = bugAdmin;
        csObj.Bug_Component__c = bugComponent;
        csObj.Bug_Owner__c = bugOwner;
        csObj.Product_affected__c = productAffected;
        csObj.Bug_BugTeam__c = bugTeam;
		csObj.Additional_Bug_Team__c = addBugTeam;

        try {
            upsert csObj;
        } catch(DMLException e) {
            System.debug(e.getMessage());
        }
        pageReference pageRef = page.CSDetailsPage;
        pageref.setRedirect(true);
        return pageref; 
    }

    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);   
    }
    
    public pagereference cancel() {
        pageReference pageRef = page.CSDetailsPage;
        pageref.setRedirect(true);
        return pageref;
    }

    public PageReference cancelEdit() {
        editCSObj = null;
        return null;
    }

    public PageReference saveEdit() {
        newPanel = false;
        try {    
            UPDATE editCSObj;
            editCSObj = null;
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        pageReference pageRef = page.CSDetailsPage;
        pageref.setRedirect(true);
        return pageRef;
    }
    public PageReference editCS() {
        String editCsId = getParam('editCsId');
        editCSObj = [SELECT Name,Bug_Component__c,Bug_Admin__c,Bug_Owner__c,Product_affected__c,Bug_BugTeam__c,Additional_Bug_Team__c 
        FROM CSforDefaultownerandteam__c WHERE id=:editCsId];
        return null;
    }
    public PageReference delCS() {
        try {
            String delCsId = getParam('delCsId');
            CSforDefaultownerandteam__c csObj = [SELECT Id FROM CSforDefaultownerandteam__c WHERE ID=:delCsId];
            DELETE csObj;
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        pageReference pageRef = page.CSDetailsPage;
        pageref.setRedirect(true);
        return pageRef;
    }

    public void searchCS() {
        csObjList = new List<CSforDefaultownerandteam__c>();
        newButtonPanel = false;
        totalRecs = 0;
        offset = 0;
        if(csObjList !=null && csObjList.size()>0) {
            csObjList=null;
        }
        searchCSetings();
        searchCon.clear();
    }

    public void searchCSetings() {
        String queryString = 'Select Name,Bug_Component__c,Bug_Admin__c,Bug_Owner__c,Product_affected__c,Bug_BugTeam__c,Additional_Bug_Team__c from CSforDefaultownerandteam__c';
        if(csObjList != null && !csObjList.isEmpty()) {
            csObjList.clear();
        }
        if(editCSObj != null) {
            if(editCSObj.Bug_Component__c !=null && editCSObj.Bug_Component__c !='') {
            searchCon.add('Bug_Component__c Like \'%' +editCSObj.Bug_Component__c +'%\' ');
            }
            if(editCSObj.Product_affected__c !=null && editCSObj.Product_affected__c !='') {
                searchCon.add('Product_affected__c Like\'%' +editCSObj.Product_affected__c+'%\' ');
            }    
        }
        if (searchCon.size() > 0) {
            queryString += '  WHERE ' + searchCon[0];
            for (Integer i = 1; i < searchCon.size(); i++)
            queryString += '  AND ' + searchCon[i];
        }
        if(totalRecs !=null && totalRecs ==0) {
            List<CSforDefaultownerandteam__c> csTemp = Database.query(queryString);
            totalRecs = (csTemp !=null &&csTemp.size()>0)?csTemp.size():0;
        }
        
        if (exportExcel == true) {
            queryString += ' ORDER BY CreatedDate DESC LIMIT :limits OFFSET :offset';
            csObjexportList  = Database.query(queryString);
        }
        else {
        // add sort and limits at the end  
        queryString += ' ORDER BY CreatedDate DESC LIMIT :queryLimit OFFSET :offset';
        csObjList  =Database.query(queryString);
        }
    }
   /* 
    Public PageReference resetPagination() {
        totalRecs = 0;
        offset = 0;
        searchCSetings();
        return null;
    }
    */
    public PageReference ClearAll(){
        if(editCSObj != null) {
            editCSObj.Bug_Component__c = '';
            editCSObj.Product_affected__c = '';
        }
        newButtonPanel = false;
        totalRecs = 0;
        offset = 0;
        limits = 10;
        changeLimit();
        searchCSetings();
        return null;
    }
    // switch on first page
    public PageReference first() {
        offset = 0;
        firstOff = false;
        lastOff = true;
        pageNumber = 1;
        searchCSetings();
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
        searchCSetings();
        return null;
    }
    // navigate on next page
    public PageReference next() {
        offset = offset + queryLimit;
        if(offset+queryLimit >= totalRecs) lastOff = false;
        firstOff = true;
        pageNumber++;
        searchCSetings();
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
        searchCSetings();
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
        searchCSetings();
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
    
    public void userSearchMethod() {
        userList = New List<User>();
        searchSection = true;
        if(searchStr.length() > 1) {
            String searchStr1 = '*'+searchStr+'*';
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  User (Id,Name,Email,Username)';
            List<List <sObject>> searchList = search.query(searchQuery);
            userList = ((List<User>)searchList[0]);
            if(userList.size() == 0) {
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results returned with matching string..'));
                return;
            }
        } else {
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
    }

    public void groupSearchMethod() {
        groupList = New List<Group>();
        searchSection = true;
        if(searchStr.length() > 1) {
            String searchStr1 = '*'+searchStr+'*';
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Group(Id,Name,Type WHERE Type !=\'Queue\')';
            List<List <sObject>> searchList = search.query(searchQuery);
            groupList= ((List<Group>)searchList[0]);
            if(groupList.size() == 0) {
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results returned with matching string..'));
                return;
            }
        } else {
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
    }
           
    //exportToExcel Method to download CustomSettings Data in Excel Sheet
    public pagereference exportToExcel(){
        /*PageReference exdownload = null;
        exdownload = Page.CSSearchExcel;
        exdownload.setRedirect(false);
        searchCS();
        return exdownload ;*/
        exportExcel = true;
        PageReference pageRef;
        if (totalRecs != null && totalRecs > 0) {
            transient string url;
            url = '/apex/CSSearchExcel';
            searchCSetings();
            pageRef = new PageReference(url);
            pageRef.setRedirect(false);
        }
        return pageRef;
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