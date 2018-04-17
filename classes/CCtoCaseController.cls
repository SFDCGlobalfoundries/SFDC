/*
Type Name: CCtoCaseController
Author: Cognizant 
Created Date: 21-Nov-2013
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
*/


public class CCtoCaseController {

    public final Case cas {get; set;}
    private final Id accId;
    private final Id caseid;    
    public List<Case_Collaboration__c> existCCList;
    public Set<String> setExistContactIds{get;set;}
    public Set<String> setExistUserIds{get;set;}
    public Set<String> setExistPortalUserIds{get;set;}
    public String conName{get;set;}
    public Id contactId{get;set;}
    Map<User,string> usrMap = new  Map<User,String>();
    Map<User,string> portaUsrMap = new  Map<User,String>();
    public string searchString{get;set;}
    public string  filterString{get;set;} 
    public string  roleSelected {get;set;}  
    public list<contactwrapper> contactSearchList {get;set;}
    public list<userwrapper>   userSearchList {get;set;}
    public Set<id> actIds {get;set;}
    public list<portaluserwrapper>   portalUserSearchList {get;set;}
	public transient  Map<id,Set<id>> caseAccounttoAllContacts;
    public Boolean isClose{get;set;}
    public boolean portalCheck {get;set;}
    public integer total_Limit = 100;
    public CaseTeamTemplateRecord CTM {get; set;}
    
    public string searchUserString{get;set;}
    public string searchUserId{get;set;}
    
    public String createdBy{get; set;}
    public String createdByIds{get; set;}
    
    public string UserString{get;set;}
    public string UserId{get;set;}
    
    public string userIdsFromURL{get;set;}
    public boolean clearFlag{get;set;}
    
    public boolean clearFlagCheck{get;set;}
    public Boolean ClearFlagParent{get; set;}
        
    public list<string> lstCaseIds;
    
    public boolean displayReadOnly{get;set;}
    public boolean searchflag{get;set;} 
    
    public Boolean isErrorMessages {
        get;
        set;
    }
    public List < CaseTeamTemplate > results {
        get;
        set;
    } 
    public String messages {
        get;
        set;
    } 
    
    public string caseTeamSearchString {
        get;
        set;
    }
    
    public list <CaseTeamWrap> listCaseTeam {get; set;}
     
     public CCtoCaseController(){
        listCaseTeam = new list <CaseTeamWrap> ();
        displayReadOnly = false;
        searchflag = false;
        lstCaseIds = new list<string>();
        clearFlag = true;
        userIdsFromURL = ApexPages.currentPage().getParameters().get('createdBy');
         if(caseid==null)
            caseid= ApexPages.currentPage().getParameters().get('Id');

        if(caseid!=null){
            if(cas ==null)
                cas = [Select Id, CaseNumber, AccountID,Internal_or_external__c, AccountThirdParty__c, CreatedBy.ContactId, IsClosed from Case where Id =: caseid ];                            
         }
        if(userIdsFromURL != null){              
            List<CaseTeamTemplate> userListReturned = new List<CaseTeamTemplate>();
            List<String> userIdsList = new List<String>();
            userIdsList = userIdsFromURL.split(',');         
            userListReturned = [select id,name from CaseTeamTemplate where id IN : userIdsList];
            if(userListReturned.size() > 0){
                for(CaseTeamTemplate us : userListReturned){
                    listCaseTeam.add(new CaseTeamWrap(us,true));
                }                          
                if(searchflag == false){
                    displayReadOnly = true; 
                }           
            }
        }   
     
     }

    public CCtoCaseController(ApexPages.StandardController controller) {
        
        transient List < User > userList = [select Id, ContactId, Contact.AccountId from User where id = : UserInfo.getUserId() Limit 1];
        existCCList = new List<Case_Collaboration__c>(); 
        contactSearchList = new list<contactwrapper>(); 
        userSearchList  = new list<userwrapper>();
        portalUserSearchList = new list<portaluserwrapper>();
        setExistContactIds= new Set<String>();
        setExistUserIds = new Set<String>();
        setExistPortalUserIds = new Set<String>();
        CTM = new CaseTeamTemplateRecord();
        actIds = new Set<Id>();
        portalCheck = true;
        caseAccounttoAllContacts  = new Map<id,Set<id>>();
        results  = new List < CaseTeamTemplate > ();
        User usr = [select id ,IsPortalEnabled, IsActive from user where id =:userinfo.getuserid()];
        if(usr.IsPortalEnabled)
          portalCheck = false;
        if(caseid==null)
            caseid= validateId(ApexPages.currentPage().getParameters().get('Id'));

        if(caseid!=null){
            if(cas ==null)
                cas = [Select Id, CaseNumber, AccountID,Internal_or_external__c, AccountThirdParty__c, CreatedBy.ContactId, IsClosed from Case where Id =: caseid ];                            
            if((!cas.IsClosed)&&(cas.AccountID!=null)){        
                if(UserInfo.getUserType()!='Standard'){
                        if(userList != null && userList.size() > 0) {
                             if (cas.AccountId!=null && userList[0].Contact.AccountId == cas.AccountId) {accId = cas.AccountId;}
                             else if (cas.AccountThirdParty__c !=null && userList[0].Contact.AccountId == cas.AccountThirdParty__c ) {accId=cas.AccountThirdParty__c ;}
                             else{accId = userList[0].Contact.AccountId;}
                        }
                } 
                isClose=true;
                actIds.add(cas.AccountId);
                getexistCCList();
                SearchAllContacts();
                if(cas.AccountID !=  System.Label.Case_GlobalFoundriesAccount)
                    caseAccounttoAllContacts  =  CaseHandlerUtility.getContactsFromAccountHierarchy(actIds);              
            }else if(cas.IsClosed){
                isClose=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Closed Case! '+System.Label.CC_to_Case_Subscription_Not_aplicable));
            }else{
                isClose=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No Account Found! '+System.Label.CC_to_Case_Subscription_Not_aplicable));
            }
        }
        
    }
   
           
    public void runSearch() {       
        List <CaseTeamTemplate> lstCase = New List <CaseTeamTemplate> ();
        List < Case > lstCaseRet = New List < Case > ();
        searchUserString = '';
        listCaseTeam = new list <CaseTeamWrap> ();
        isErrorMessages = false;
        searchUserId = ''; 
        displayReadOnly = false;
        clearFlag = false;
        String query;
        try {                                            
                if(caseTeamSearchString != '' && caseTeamSearchString != null){                    
                    if (caseTeamSearchString.length() == 1) {
                            isErrorMessages = true;                        
                    }
                    else
                    {
                        searchflag = true;
                        query = ' select name from CaseTeamTemplate WHERE Name LIKE \'%' + caseTeamSearchString + '%\'';
                        lstCase = database.query(query);
                    }                       
                }
                else{
                    searchflag = true;
                    query = ' select name from CaseTeamTemplate limit 10';
                    lstCase = database.query(query);                  
                }                                                                   
                if(lstCase.size() > 0){
                    for(CaseTeamTemplate us: lstCase){
                        listCaseTeam.add(new CaseTeamWrap(us,false));
                    }
                }
                
                system.debug('pankaj1'+listCaseTeam);
                        
        } catch (Exception e) {ApexPages.addMessages(e);} // Don't redirect if something goes wrong. May be a validation or trigger issue on save.                      
    }
    
    
   public PageReference addAllUsers() {       
        if(searchUserString != ''){
            searchUserString = searchUserString + ',';
            searchUserId = searchUserId + ',';
        }
        
        if(!listCaseTeam.isEmpty()){
            for(CaseTeamWrap uw: listCaseTeam){
                if(uw.isSelected == true && (!searchUserString.contains(uw.casePreTeam.Name))){
                    searchUserId = searchUserId + uw.casePreTeam.id + ',';    
                    searchUserString = searchUserString + uw.casePreTeam.Name + ',';
                }
            }
            system.debug('pankaj2'+searchUserString );
            if(searchUserId != ''){
                searchUserId = searchUserId.substring(0, searchUserId.length() - 1);
                searchUserString = searchUserString.substring(0, searchUserString.length() - 1);
            }
        }
        return null;
    }
        
    public void SetValues(){        
        if(clearFlagCheck == true){
            if(UserString != null){
            createdBy = UserString;
            createdByIds = UserId;     
            } 
            else{
            createdBy = '';
            createdByIds = '';             
            }  
        }
        else{
            if(createdBy != '' && createdBy != null){
                createdBy = createdBy+','+UserString;
                createdByIds = createdByIds +','+UserId;
            }
            else{
                createdBy = UserString;
                createdByIds = UserId;
            }
        }                             
    }
    
    public void addCaseTeam(){
        try {
              Set<string> caseTeamIds = new Set<string>();
              Boolean isSuccess =  false;
              List < CaseTeamTemplateRecord > listCaseTeam = new List < CaseTeamTemplateRecord > ();
               
              
              List<CaseTeamTemplateRecord> caseTeamTeamplateLst = [select id ,ParentId,TeamTemplateId from CaseTeamTemplateRecord where parentid =:cas.Id];
              
             
              
              for(CaseTeamTemplateRecord ct:caseTeamTeamplateLst){
                 caseTeamIds.add(ct.TeamTemplateId);                       
              }
              
              List <CaseTeamTemplate> listCasePreTeam;
              
              if(createdByIds != null || createdByIds != ''){
                  lstCaseIds  = createdByIds.split(',');
              }
              
              if(lstCaseIds.size() >0){
                  listCasePreTeam = [select id, name from CaseTeamTemplate where id in: lstCaseIds];
                }               
              List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
              Case_Collaboration__c cc;
              CaseTeamTemplateRecord ct;
              for(CaseTeamTemplate teamObj:listCasePreTeam ){
                  if(!caseTeamIds.contains(teamObj.id)){ 
                      cc = new Case_Collaboration__c();
                      ct = new CaseTeamTemplateRecord();
                      cc.Name = 'Predefined Team:' + teamObj.name; 
                      cc.Case__c = cas.Id;
                      cc.Is_Subscribed__c = true;
                      cc.Member_Role_Name__c = 'Team';
                      cc.CC_Link__c = System.Label.Case_Globalfoundry_Link+'apex/CCtoCase';                  
                      cc.Case_Predefined_Team_Id__c = teamObj.id;
                      
                      if (cc.Case__c != null && cc.Case_Predefined_Team_Id__c != null){
                        cc.UniqueId__c = string.valueOf(cc.Case__c) + cc.Case_Predefined_Team_Id__c;                
                      }
                      
                      listCCtoCase.add(cc); 
                      
                      ct.ParentId = cas.Id;
                      ct.TeamTemplateId = teamObj.id;
                      listCaseTeam.add(ct);
                   }                           
             }       
             if(listCCtoCase!=null && listCCtoCase.size()>0){
                    insert listCCtoCase;
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Records added Succesfully!'));          
                }
                
             if(listCaseTeam !=null && listCaseTeam.size()>0){
                    insert listCaseTeam;
                    isSuccess  = true;            
                }
             if(listCasePreTeam != null &&   listCasePreTeam.size()>0 && listCaseTeam.isEmpty()){
                 
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Record already Exists'));                
             }
        }
     Catch(Exception e) 
        {system.debug('case12'+e.getLineNumber());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'A user has updated subscription list. Refresh your page and try again.'));}
    }
    /**
    This method is used for creating SOQL for contact search
    @method name: createContactSOQL
    @parameter:   NA.
    @return :     String.
    **/
    public  String createContactSOQL(){     
    String query = createQueryString('Contact','CC_To_Case');            
            if(UserInfo.getUserType()!='Standard'){ 
                   query = query + ' where AccountId=' + '\'' + accId  + '\''; 
            }else{
                if(cas.AccountThirdParty__c !=null){
                    query = query + ' where (AccountId=' + '\'' + cas.AccountID  + '\''; 
                    query = query + ' or AccountId=' + '\'' + cas.AccountThirdParty__c + '\')';
                }else{
                    query = query + ' where AccountId=' + '\'' + cas.AccountID  + '\''; 
                }
            }            
            if(setExistContactIds!=null && setExistContactIds.size()>0){
                query = query + ' AND Id NOT IN: setExistContactIds';   
            }
            if(cas.CreatedBy.ContactId !=null){
                query = query + ' AND Id!=' + '\'' + cas.CreatedBy.ContactId  + '\''; 
            } 
            
            return query ;
    
    }
    
    /**
    This method is used for searching Contact from contact object on View Suggested Contact and default
    @method name: AllContacts
    @parameter:   NA.
    @return :     NA.
    **/
    public  void AllContacts(){
        clearcontact();
        SearchAllContacts();        
    } 
    
    
    
    /**
    This method is used for searching Contact from contact object on View Suggested Contact and default
    @method name: SearchAllContacts
    @parameter:   NA.
    @return :     NA.
    **/
    public  void SearchAllContacts(){               
        list<contact> contactResult = new list<contact>();   
        filterString  = 'Cont'; 
         if(searchString == null || searchString == '')
        {             
            String query = createContactSOQL();                        
            query = query + ' AND Is_Portal_User_Active__c =true' ;              
            if(setExistPortalUserIds !=null && setExistPortalUserIds.size()>0) { 
                query = query +  ' and Id not in :setExistPortalUserIds ';  
             }                     
            query = query + ' order by Name Limit ' + total_Limit;            
            contactResult = Database.Query(query);                  
             if(!contactResult.isEmpty())
            {
                for(contact co : contactResult )
                {
                    contactSearchList.add(new contactwrapper(false,co));
                }
            }
        }
    } 
    
    /**
    This method is used for searching Contact from contact object
    @method name: searchContact
    @parameter:   NA.
    @return :     NA.
    **/
    public  void searchContact(){               

        //searchString = Apexpages.currentPage().getParameters().get('searchString');
        list<contact> contactResult = new list<contact>();
        list<user> userResult = new List<user>();
        list<user> portaluserResult = new List<user>();
        contactSearchList.clear();
        userSearchList.clear();
        portalUserSearchList.clear();
        Boolean isPortal=false;
        List <Case_Collaboration__c> existCCLst = getexistCCList(); 
        if(cas.AccountID !=  System.Label.Case_GlobalFoundriesAccount){
           caseAccounttoAllContacts  =  CaseHandlerUtility.getContactsFromAccountHierarchy(actIds); 
        }
        if(searchString != null && searchString != '' && filterString == 'Cont')
        { 
            String query = createContactSOQL();            
                       
            query = query + ' AND name like ' + '\'%' + searchString + '%\'';                     
            query = query + ' order by Name Limit ' + total_Limit;
            contactResult = Database.Query(query);                  
        }
       

        else if(searchString != null && searchString != '' && filterString == 'User')
        { 
            String query =  'select name,email,IsActive, UserType, Profile.Name,UserRole.Name  from user where name like ' + '\'%' + searchString + '%\'' + ' and IsPortalEnabled = false and IsActive = True ' ;                            
            
            if(setExistUserIds !=null && setExistUserIds.size()>0) { 
                query = query +  '  AND Id NOT IN: setExistUserIds ' ;  
             }
           
            query = query + ' order by Name Limit ' + total_Limit;                                    
            userResult = Database.Query(query);                                          
        }
        else if(searchString != null && searchString != '' && filterString == 'ContUser'){
        
                string query = ' select name,email,IsActive, UserType, Profile.Name,UserRole.Name,ContactId,contact.Account.Name  from user where name like ' + '\'%' + searchString + '%\'' + ' and IsPortalEnabled = True and IsActive = True ' ;                                    
                
                if(caseAccounttoAllContacts != null && caseAccounttoAllContacts.size() >0){
                    Set<id> contIds = caseAccounttoAllContacts.get(cas.AccountID);
                    query = query +  ' and ContactId in :contIds'  ; 
                }
                
                if(setExistUserIds !=null && setExistUserIds.size()>0) { 
                    query = query +   ' AND Id NOT IN: setExistUserIds'  ;  
                }
                
                if(setExistContactIds !=null && setExistContactIds.size()>0) { 
                        query = query +  ' and ContactId not in :setExistContactIds'  ;  
                }   

                
               portaluserResult = Database.Query(query); 
        }        
         else
        {
            SearchAllContacts();
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, System.Label.CC_to_Case_Search_String_Error));
            return;    
        }
        
        if(!contactResult.isEmpty())
        {
            for(contact co : contactResult )
            {
                IF((!co.Is_Portal_User_Active__c)&&(!isPortal)) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.CC_to_Case_Warning_Error));
                    isPortal=true;
                }
                contactSearchList.add(new contactwrapper(false,co));
            }
        }
        
       else if(!userResult.isEmpty())
        {       
            for(user usr : userResult ){                    
                userSearchList.add(new userwrapper(false,usr,''));
            }
        }
        else if(!portaluserResult.isEmpty())
        {        
            for(user usr : portaluserResult ){               
                portalUserSearchList.add(new portaluserwrapper(false,usr,''));
            }
        }       
        else{
            contactSearchList = new list<contactwrapper>(); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.CC_to_Case_No_record_found));
            return;    
        }
    } 
       
    /**
    This method is used for clear search string & search List.
    @method name: clearcontact
    @parameter:   NA.
    @return :     NA.
    **/
    public  void clearcontact(){
        contactSearchList.clear();
        userSearchList.clear();
        portalUserSearchList.clear();
        searchString = null;
        filterString = null;
    }
    
    /**
    This method is used to unsubscribe all contacts
    @method name: unsubscribe
    @parameter:   NA.
    @return :     NA.
    **/
    public void unsubscribe() {
        try {            
                if(!existCCList.isEmpty())
                {
                    Transient List<Case_Collaboration__c> listCC = new List<Case_Collaboration__c>();
                    for(Case_Collaboration__c cc:  existCCList)  {
                        if(cc.Is_Subscribed__c){
                            cc.Is_Subscribed__c = false;
                            listCC.add(cc);
                        }
                    }
                    if(!listCC.isEmpty())
                    {
                        update listCC;
                        getexistCCList();
                    }   
                } 
            } catch(Exception e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));}
    }
    
    /**
    This method is used to subscribe all contacts
    @method name: subscribe
    @parameter:   NA.
    @return :     NA.
    **/
    public void subscribe() {
        try {            
                if(!existCCList.isEmpty())
                {
                    Transient List<Case_Collaboration__c> listCC = new List<Case_Collaboration__c>();
                    for(Case_Collaboration__c cc:  existCCList)  {
                        if(!cc.Is_Subscribed__c){
                            cc.Is_Subscribed__c = true;
                            listCC.add(cc);
                        }
                    }
                    if(!listCC.isEmpty())
                    {
                        update listCC;
                        getexistCCList();
                    }                       
                } 
            } catch(Exception e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));}
    }
    
    /**
    This method is used for Adding & Validating CCtoCase records
    @method name: add
    @parameter:   NA.
    @return :     NA.
    **/
    public void add() {
        Set<String> setTempIds = new Set<String>();
        List<Contact> lstContacts = new  List<Contact>();
        List<User> lstUsers = new  List<User>();       
        integer contactCount = 0;
        if(cas.Internal_or_external__c ){
       
          contactCount =1;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please uncheck "Internal Use Only" box before adding external Contacts'));                
        }
       
        else if(!contactSearchList.isEmpty()) 
        {
            for(contactWrapper co : contactSearchList)
            {
                if(co.isChecked)
                {
                    lstContacts.add(co.contactFound);                    
                    contactCount ++;   
                }
            }
            if(contactCount > 0)
            {                
                if(insertCaseCollaborator(lstContacts)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, System.Label.CC_to_Case_Contact_Added));
                }
            }
        }        
        else if(!userSearchList.isEmpty()) 
        {
            for(userWrapper co : userSearchList)
            {
                if(co.isChecked)
                {
                    usrMap.put(co.userFound,co.roleSelected);                    
                    contactCount ++;   
                }
            }
            if(contactCount > 0)
            {                
                if(insertUsrCaseCollaborator(usrMap)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, System.Label.CC_to_Case_Contact_Added));
                }
            }

        }
        
          else if(!portalUserSearchList.isEmpty()) 
        {
            for(portaluserwrapper co : portalUserSearchList)
            {
                if(co.isChecked)
                {
                    portaUsrMap.put(co.userFound,co.roleSelected);                    
                    contactCount ++;   
                }
            }
            if(contactCount > 0)
            {                
                if(insertPortalUsrCaseCollaborator(portaUsrMap)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, System.Label.CC_to_Case_Contact_Added));
                }
            }

        }
           
             
        if(contactCount == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, System.Label.CC_to_Case_Select_Contact));
            return; 
        }
        else
        {
             clearcontact();
        }

    }
    
    /**
    This method is used for Inserting CCtoCase record.
    @method name: insertCaseCollaborator
    @parameter:   List<Contact>.
    @return :     NA.
    **/
    public Boolean insertCaseCollaborator( List<Contact> lstContact)
    {
        Boolean isSuccess =  false;
        try{
            List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
            Case_Collaboration__c cc;
            for(Contact co: lstContact){  
                cc = new Case_Collaboration__c();
                cc.Name= co.Name+' from ' + co.Account.Name;
                cc.Contact__c = co.Id;
                cc.Case__c = cas.Id;
                if (cc.Case__c != null && cc.Contact__c != null){
                    cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.Contact__c);                
                }
                cc.Email_Id__c=co.Email;
                cc.Is_Subscribed__c = true;
                cc.CC_Link__c = System.Label.Case_Globalfoundry_Link+'apex/CCtoCase';
                listCCtoCase.add(cc); 
            }
            if(listCCtoCase!=null && listCCtoCase.size()>0){
                insert listCCtoCase;
                isSuccess  = true;            
            }
            
        }
        Catch(Exception e) 
        {system.debug(e);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'A user has updated subscription list. Refresh your page and try again.'));}
        return isSuccess ;
    }
    
    
    public Boolean insertPortalUsrCaseCollaborator(Map<User,string> lstUsr)
    {
        Boolean isSuccess =  false;
        string memrole = '';
        try{
            List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
            Case_Collaboration__c cc;
            for(User co: lstUsr.keyset()){  
                cc = new Case_Collaboration__c();
                cc.Name = co.Name + ' from ' + co.contact.Account.Name;
                cc.Contact__c = co.ContactId;
                memrole  = portaUsrMap.get(co);
                if(memrole == 'CaseCollaborator')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Collaboration;
                else if(memrole == 'CaseManager')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Manager;
                else if(memrole == 'CaseCreator')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Creator;
                else if(memrole == 'CaseCreatorExternal')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Creator_External;
                else
                    cc.Member_Role_Name__c = Environment_Variable__c.getValues('Case_Team_Role_Id_Case_Stakeholder').Value__c; 
                cc.User__c = co.id;
                cc.Case__c = cas.Id;
                if (cc.Case__c != null && cc.Contact__c != null){
                    cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.Contact__c);                
                }
                cc.Email_Id__c=co.Email;
                cc.Is_Subscribed__c = true;
                cc.CC_Link__c = System.Label.Case_Globalfoundry_Link+'apex/CCtoCase';
                listCCtoCase.add(cc); 
            }
            if(listCCtoCase!=null && listCCtoCase.size()>0){
                insert listCCtoCase;
                isSuccess  = true;            
            }
            
        }
        Catch(Exception e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'A user has updated subscription list. Refresh your page and try again.'));}
        return isSuccess ;
    }
    
    public Boolean insertUsrCaseCollaborator(Map<User,string> lstUsr)
    {
        Boolean isSuccess =  false;
        string memrole = '';
        try{
            List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
            Case_Collaboration__c cc;
            for(User co: lstUsr.keyset()){  
                cc = new Case_Collaboration__c();
                cc.Name = co.name;  
                memrole  = usrMap.get(co);
                if(memrole == 'CaseCollaborator')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Collaboration;
                else if(memrole == 'CaseManager')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Manager;
                else if(memrole == 'CaseCreator')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Creator;
                else if(memrole == 'CaseCreatorExternal')
                    cc.Member_Role_Name__c = System.Label.Case_Team_Role_Id_Case_Creator_External;
                else
                    cc.Member_Role_Name__c = Environment_Variable__c.getValues('Case_Team_Role_Id_Case_Stakeholder').Value__c;                                      
                cc.User__c = co.id;              
                cc.Case__c = cas.Id;
                if (cc.Case__c != null && cc.User__c != null){
                    cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.User__c);                
                }
                cc.Email_Id__c=co.Email;
                cc.Is_Subscribed__c = true;
                cc.CC_Link__c = System.Label.Case_Globalfoundry_Link+'apex/CCtoCase';
                listCCtoCase.add(cc); 
            }
            if(listCCtoCase!=null && listCCtoCase.size()>0){
                insert listCCtoCase;
                isSuccess  = true;            
            }
            
        }
        Catch(Exception e) {
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'A user has updated subscription list. Refresh your page and try again.'));}
        return isSuccess ;
    }
    
    /**
    This method is used for redirect page when Edit button clicked
    @method name: editCC
    @parameter:   NA.
    @return :     PageReference.
    **/
    public PageReference editCC() {
        String ccId = ApexPages.currentPage().getParameters().get('ccId');
        PageReference pr = new PageReference('/'+ccId+'/e?retURL=/apex/CCtoCaseAdd?Id='+cas.Id);
        return pr;
    }


    /**
    This method is used for deleting CCtoCase record.
    @method name: deleteCC
    @parameter:   NA.
    @return :     PageReference .
    **/
    public PageReference deleteCC() {
        String ccId = ApexPages.currentPage().getParameters().get('ccId');
        Case_Collaboration__c cc = new Case_Collaboration__c(Id= ccId);
        delete cc;  
        setExistContactIds.clear();   
        setExistUserIds.clear();
        setExistPortalUserIds.clear();   
        getexistCCList();
        clearcontact();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, System.Label.CC_to_Case_Contact_Deleted));                    
        return null;
    }
    
    /**
    This method is used for creating list which are already subscribed in CCtoCase.
    @method name: getexistCCList
    @parameter:   NA.
    @return :     List<Case_Collaboration__c>
    **/
    public List<Case_Collaboration__c> getexistCCList() {
        try {            
            existCCList = [Select Id, Name, Case__c, Contact__c, Email__c,user__c,user__r.contactid,Email_Id__c, Is_Subscribed__c, Case__r.Subject, Case__r.CaseNumber , Contact__r.Email,Contact__r.Account.Name from Case_Collaboration__c where Case__c =: cas.Id];
            if(existCCList!=null && existCCList.size()>0 ){
                for(Case_Collaboration__c cc:  existCCList){
                    if(cc.Contact__c != null)
                        setExistContactIds.add(cc.Contact__r.Id);
                    if(cc.user__c != null && cc.Contact__c == null)
                        setExistUserIds.add(cc.user__c);
                    if(cc.user__c != null && cc.Contact__c != null)
                        setExistPortalUserIds.add(cc.user__r.contactid);
                }
            }
        } catch(Exception e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));}
        return existCCList;
    }
     /**
    This method is used for creating SOQL from Object & corresponding Field Set Name
    @method name: createQueryString
    @parameter:   String object Name, String fieldSet Name.
    @return :     String.
    **/
    public string createQueryString(string sObjectName,string fieldSetName)
    {        
        String query = 'SELECT Id';
        transient Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe(); 
        transient Schema.DescribeSObjectResult res=globalDescribe.get(sObjectName.toLowerCase()).getDescribe();
        transient Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap();
        transient Schema.FieldSet fs = fieldSetMap.get(fieldSetName);                        

        for(Schema.FieldSetMember fsm : fs.getFields() ) 
        {                                    
            query = query + ',' + fsm.getFieldPath();    
        }          

        query = query + ' , Account.Name from ' + sObjectName;

        return query;            
    }
    
    /**
    This method is used for validating Case Ids & users Ids
    @method name: validateId
    @parameter:   String Case Id.
    @return :     String Case Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && (id.startsWith('500'))) {
            return id;
        }
        return null;
    }
    
    /**
    This class is used for creating mapping between isChecked & contact contactFound.
    @Class name: contactWrapper
    @parameter:   NA.
    @return :     NA.
    **/
    public class contactWrapper
    {
        public boolean isChecked{get;set;}
        public contact contactFound{get;set;}

        public contactWrapper(boolean x,contact y)
        {
            isChecked = x;
            contactFound = y;
        }
    } 

    public class userWrapper
    {
        public boolean isChecked{get;set;}
        public user userFound{get;set;}
        public string  roleSelected{get;set;}

        public userWrapper(boolean x,user y,string z)
        {
            isChecked = x;
            userFound = y;
            roleSelected = z;
        }
    }  
    public class portaluserwrapper
    {
        public boolean isChecked{get;set;}
        public user userFound{get;set;}
        public string  roleSelected{get;set;}

        public portaluserwrapper(boolean x,user y,string z)
        {
            isChecked = x;
            userFound = y;
            roleSelected = z;
        }
    } 
    
    public class CaseTeamWrap {
        public boolean isSelected {get;set;}
        public CaseTeamTemplate casePreTeam{get;set;}
        
        public CaseTeamWrap(CaseTeamTemplate y ,boolean x){
            isSelected = x;
            casePreTeam = y; 
        }
    } 
    
    
}