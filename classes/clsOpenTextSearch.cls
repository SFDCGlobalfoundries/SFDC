/*
    History: 
        ZAmbat      05192014    - Updated code as per CASE 8653.
        Asolito     01082015    - Added configuration search
        Author: Sunita
        Modified Date: Jun-23-2015
        Reason: Case 35310 - Global Search
        Devendra- Added collaborator search 03/10/2017
        Pradosh - Added PNP Release search  12-21-2017 
*/
public with sharing class clsOpenTextSearch
{ 
    public Map<String,OpenTextUrlValues__c> openTextUrlValue;
    public String inputSearchText{get;set;}
    Public String recordId{get;set;}
    Public OpenTextUrlValues__c urlvalue;
    Public Integer accountReturnedSize{get;set;}
    Public Integer contactReturnedSize{get;set;}
    Public Integer teamRoomReturnedSize{get;set;}
    Public Integer userReturnedSize{get;set;}
    Public Integer deviceReturnedSize{get;set;}
    Public List<Account> accounts{get;set;}
    Public List<Contact> contacts{get;set;}
    Public List<Team_Room__c> teamRoom{get; set;}
    Public List<User> userList{get; set;}
    public List<Apttus_Proposal__Proposal__c> configurations {get; set;}
    public list<Wavier_Collaborator__c> collabList{get;set;}
    public list<Waiver_Rule_List__c> ruleList{get;set;}
    public List<PNP_Release__c> pnpReleaseList {get; set;}
    
    Public List<DeviceWrapper> deviceList{get; set;} 
    Public Boolean accountReturned{get;set;}
    Public Boolean contactReturned{get;set;}
    Public Boolean teamRoomReturned{get;set;}
    Public Boolean userReturned{get;set;}
    Public Boolean deviceReturned{get;set;}
    Public Boolean searchResult{get;set;}
    Public Boolean searchResultpbsection{get;set;}
    public boolean isExportControlVisible {get;set;} 
    public boolean isIPDeclarationVisible {get;set;}
    Public String IframeUrl{get;set;}
    //Public String specialChars = '&|\'|^|@|\\|/|?|!|#|$|%|*|(|)|:|;|\"|-|_|{|}|[|]|<|>|~|`'; 
    Public String specialChars = '/|@|\'';   
    Public String OpenTextLoginServerURL {get; set;}    
    User userObj = new User();    
    public String portalLoginUser; 
    public String UserId;  //added for Case 35310
    public String UserName;  //added for Case 35310
    public String ShortName;  //added for Case 35310
    public Integer count{get;set;}
    public string sortBy {get;set;}
    public string prevSortBy {get;set;}
    public string orderBy {get;set;}
    public Map<integer, List<DeviceWrapper>> mapDeviceRecords {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer deviceFrom {get;set;}
    public integer deviceTo {get;set;}
    
    /** Modified for Search on Cases **/
    public List < Case > results {get;set;} // search results
    private final Map < String, Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe();
    public List < String > selectedFields {get;set;}
    Public Boolean caseReturned{get;set;}
    
    public clsOpenTextSearch()
    {
      /** Modified for modifying Search By External Users **/
      userObj = [SELECT id,Portal_Login__c,HCM_Login_ID__c,Name,Contact.AccountId, Parent_Account_Id__c FROM User WHERE Id =:userInfo.getUserId()];//modified for Case 35310
      /** Modified for modifying Search By External Users **/
          
      portalLoginUser = userObj.Portal_Login__c;
      UserId=userObj.id ;  //added for Case 35310   
      UserName=userObj.Name;//added for Case 35310   
      ShortName=userObj.HCM_Login_ID__c;//added for Case 35310        
      OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
      urlvalue=new OpenTextUrlValues__c();
      accounts=new List<Account>();
      contacts=new List<Contact>();
      teamRoom = new List<Team_Room__c>();
      userList = new List<User>();
      this.configurations = new List<Apttus_Proposal__Proposal__c>();
      this.collabList = new List<Wavier_Collaborator__c>();
      this.ruleList = new List<Waiver_Rule_List__c>();
      this.pnpReleaseList = new List<PNP_Release__c>();
      
      deviceList = new List<DeviceWrapper>();
      accountReturned=False;
      contactReturned=False;
      searchResult=False;
      teamRoomReturned = False;
      userReturned = False;
      deviceReturned = false;
      caseReturned = false;
      this.isExportControlVisible = false;
      this.isIPDeclarationVisible = false;
      count = 0;
      inputSearchText=System.currentPageReference().getParameters().get('InputSearchText');//.escapeEcmaScript();
      for(integer i=0; i<specialChars.split('|').size(); i++)
      inputSearchText = inputSearchText.replace(specialChars.split('|')[i], '');
      System.debug('Special Character removed :'+inputSearchText);
      openTextUrlValue=OpenTextUrlValues__c.getAll();
      this.sortBy = 'Name';
      this.prevSortBy = 'Name';
      this.orderBy = 'ASC';
      this.mapDeviceRecords = new Map<integer, List<DeviceWrapper>>();
      search() ;
     }
 
    public void Search()
    {
     try
      {
        accounts = new List<Account>();
        contacts = new List<Contact>();
        teamRoom = new List<Team_Room__c>();
        userList = new List<User>();
        collabList = new List<Wavier_Collaborator__c>();
        ruleList = new List<Waiver_Rule_List__c>();
        pnpReleaseList = new List<PNP_Release__c>();
        searchResult = False;
        accountReturned = False;
        contactReturned = False;
        teamRoomReturned = False;
        userReturned = False;
        System.debug('@@@@@@OpenTextParamValue'+openTextUrlValue);
        if(inputSearchText!=null && inputSearchText!='')
           {
            if(openTextUrlValue!=null)
             {
             urlvalue = openTextUrlValue.get('OpenTextParam');
             searchResult=True;
             //Old Url IframeUrl='http://f2fvcsmsd1.gfoundries.com/otcs/livelink.exe?slice=61626&searchbarwidgetmode=fulltext&where1='+inputSearchText+'&ScopeSelection=61626&lookfor1=allwords&modifier1=relatedto&boolean2=And&lookfor2=complexquery&typeDropDownId=1&boolean3=And&lookfor3=complexquery&dateDropDownId=1&func=search&objType=258&SearchBarSearch=TRUE&facets=true&fulltextMode=allwords';
             //UAT URL
          /*   IframeUrl='https://test.foundryview.com/otext/otcs/livelink.exe?slice='+urlvalue.slice__c+'&searchbarwidgetmode=fulltext&where1='+
                       inputSearchText+
                       '&ScopeSelection='+urlvalue.ScopeSelection__c+'&lookfor1=allwords&modifier1=relatedto&boolean2=And&lookfor2=complexquery&typeDropDownId=1&boolean3=And&lookfor3=complexquery&dateDropDownId=1&func=search&objType=258&SearchBarSearch=TRUE&facets=true&fulltextMode=allwords&username='+ portalLoginUser ;  */
             //Production URL
             if(inputSearchText.contains('-'))inputSearchText=inputSearchText.replace('-','\\-');
            /* IframeUrl='https://www.global-foundryview.com/otext/otcs/llisapi.dll?slice='+urlvalue.slice__c+'&searchbarwidgetmode=fulltext&where1='+
                         inputSearchText+
                         '&ScopeSelection='+urlvalue.ScopeSelection__c+'&lookfor1=allwords&modifier1=relatedto&boolean2=And&lookfor2=complexquery&typeDropDownId=1&boolean3=And&lookfor3=complexquery&dateDropDownId=1&func=search&objType=258&SearchBarSearch=TRUE&facets=true&fulltextMode=allwords&username='+ portalLoginUser; */
               IframeUrl= system.Label.OpenTextSearchURL+urlvalue.slice__c+'&searchbarwidgetmode=fulltext&where1='+
                       inputSearchText+
                       '&ScopeSelection='+urlvalue.ScopeSelection__c+'&lookfor1=allwords&modifier1=relatedto&boolean2=And&lookfor2=complexquery&typeDropDownId=1&boolean3=And&lookfor3=complexquery&dateDropDownId=1&func=search&objType=258&SearchBarSearch=TRUE&facets=true&fulltextMode=allwords&username='+ portalLoginUser ;
             }
             System.debug('@@@@@IframeUrl'+IframeUrl);
             /** Modified for modifying Search By External Users **/
             String searchquery='FIND '+'{' +inputSearchText+'}'+ 
                                ' RETURNING Account(Name,Parent.Name,Customer_Portal_Admin__r.Name,Stage__c,Website,Id), '+
                                ' Contact(Id,FirstName,LastName,Account.Name,Customer_Portal_Admin__r.Name,Email,Phone), '+
                                ' Team_Room__c(Name,Owner.Name,Team_Room_Administrator__r.Name,Parent_TR__r.Name,Primary_Account__r.Name,Id), '+
                                ' User(Name,Email,Username,Phone,Department,Id,Parent_Account_Id__c) ,' +
                                ' Apttus_Proposal__Proposal__c(id,Apttus_Proposal__Proposal_Name__c,name,Apttus_Proposal__Account__r.name, '+
                                ' Apttus_Proposal__Opportunity__r.name,device__r.name,Process_Technology_Geometry__c,Process_Technology_Name__c), '+
                                
                                'Wavier_Collaborator__c(id,Name,Account__c,Account__R.Name,Device_Name__c,CRM_Device__c,Mask_Set_Title__c,CRM_Device__r.Name,Prime_Die_Name__c,Prime_Die__c,PTSR_Number__c), '+
                                'Waiver_Rule_List__c(id,Name), '+
                                ' PNP_Release__c(Name, PNP_Release_Stage__c, Priority__c, Lot_Size__c)';
             /** Modified for modifying Search By External Users **/
             System.debug('@@@inside Search'+searchquery);
             List<List<SObject>> searchList=search.query(searchquery);
             if(searchList[0]!=null && searchList[0].Size()>0)
                 {
                  accounts = ((List<Account>) searchList[0]);
                  accountReturnedSize=accounts.size();
                  AccountReturned=True;
                  System.debug('@@@@InsideIf'+accounts );
                 }
            
            if(searchList[1]!=null && searchList[1].Size()>0)
                {
                  contacts = ((List<Contact>) searchList[1]);
                  contactReturnedSize=contacts.size();
                  contactReturned=True; 
                }
            if(searchList[2]!=null && searchList[2].Size()>0)
                 {
                  teamRoom = ((List<Team_Room__c>) searchList[2]);
                  teamRoomReturnedSize=teamRoom.size();
                  teamRoomReturned=True;
                  System.debug('@@@@InsideIf'+teamRoom);
                 }
            if(searchList[3]!=null && searchList[3].Size()>0){
                  /** Modified for modifying Search By External Users **/
                  if(userObj.Parent_Account_Id__c!=null){
                      List<User> tempUserList = new List<User>();
                      tempUserList = ((List<User>) searchList[3]);
                      for(User objUser: tempUserList){
                          if(objUser.parent_Account_Id__c==userObj.Parent_Account_Id__c){
                              userList.add(objUser);   
                          }
                      }    
                  }
                  else{
                      userList = ((List<User>) searchList[3]);
                  }
                  /** Modified for modifying Search By External Users **/
                 
                  userReturnedSize=userList.size();
                  userReturned=True;
                  System.debug('@@@@InsideIf'+userList);
             }
             //Asolito 01/09/2015
             //added configuration search
             if(searchList[4]!=null && searchList[4].Size()>0){
                 this.configurations = ((List<Apttus_Proposal__Proposal__c>) searchList[4]);   
             }
             
             if(searchList[5]!=null && searchList[5].Size()>0){
                this.collabList = ((List<Wavier_Collaborator__c>) searchList[5]);   }
             
             if(searchList[6]!=null && searchList[6].Size()>0){
                 this.ruleList = ((List<Waiver_Rule_List__c>) searchList[6]);    }
                 
            if(searchList[7]!=null && searchList[7].Size()>0){
                 this.pnpReleaseList = ((List<PNP_Release__c>) searchList[7]);   
            }
                 
                 /** Modified for Search on Cases **/
                 
                  selectedFields = getSearchResultItems('CaseSearchResults'); 
                  String queryString = createSOSLString('CaseSearchResults');
                  
                  String query = 'FIND '+'{' +inputSearchText+'}' + ' RETURNING ' + queryString + '';                
                  List < List < SObject >> caseList = search.query(query);
                  results = ((List < Case > ) caseList[0]); 
                  
                  if(results.size()>0)
                      caseReturned = true;
                  
                  /** Modified for Search on Cases **/
                 
                List<Device__c> listDevice = DeviceSearchGFV.retrieveDevices(this.userObj.Contact.AccountId, inputSearchText);
                if (listDevice.size() > 0) {
                    Map<Id, Device_Export_Control_Junction__c> mapExportControlForm = new Map<Id, Device_Export_Control_Junction__c>(); 
                    Map<Id, IP_Declaration_Form__c> mapIpDeclarationForm = new Map<Id, IP_Declaration_Form__c>(); 
                    for (Device__c d : listDevice) {
                        DeviceWrapper dw = new DeviceWrapper();
                        dw.Id = d.Id;   
                        dw.Name = d.Name;
                        dw.Stage = d.Stage__c;
                        dw.ShortName = d.Account_Short_Name__c;
                        dw.Fab = d.Fab__c;
                        dw.Geometry = d.Geometry__c;
                        dw.CurrentForecastTapeoutDate = d.Current_Forecast_Tapeout_Date__c;
                        this.deviceList.add(dw);
                        mapExportControlForm.put(d.Id, null);
                        mapIpDeclarationForm.put(d.Id, null);
                    }
                    
                    if (this.deviceList.size() > 0) {
                        // Retrieve Export Control Form
                        for (Device_Export_Control_Junction__c ec : [SELECT     Device__c
                                                                                , Export_Control_Form__c
                                                                                , Export_Control_Number__c
                                                                     FROM       Device_Export_Control_Junction__c
                                                                     WHERE      Device__c IN :mapExportControlForm.keySet()]) {
                            if (mapExportControlForm.containsKey(ec.Device__c)) {
                                mapExportControlForm.put(ec.Device__c, ec);
                            }
                        }
                        
                        // Retrieve IP Declaration Form
                        for (IP_Declaration_Form__c ip : [SELECT    Id
                                                                    , Name
                                                                    , Device__c
                                                          FROM      IP_Declaration_Form__c
                                                          WHERE     Device__c IN :mapIpDeclarationForm.keySet()]) {
                            if (mapIpDeclarationForm.containsKey(ip.Device__c)) {
                                mapIpDeclarationForm.put(ip.Device__c, ip);
                            }
                        }
                        
                        for (DeviceWrapper dw : this.deviceList) {
                            if (mapExportControlForm.get(dw.Id) != null) {
                                dw.ExportControlFormId = mapExportControlForm.get(dw.Id).Export_Control_Form__c;
                                dw.ExportControlFormName = mapExportControlForm.get(dw.Id).Export_Control_Number__c;
                            }
                            
                            if (mapIpDeclarationForm.get(dw.Id) != null) {
                                dw.IpDeclarationFormId = mapIpDeclarationForm.get(dw.Id).Id;
                                dw.IpDeclarationFormName = mapIpDeclarationForm.get(dw.Id).Name; 
                            }
                        }
                        
                        // Check Access Setup of user
                        Portal_Tab_Access__c accessSetup = [
                            SELECT      Id
                                        , Export_Control__c
                                        , IP_Declaration__c
                            FROM        Portal_Tab_Access__c
                            WHERE       User__c = :UserInfo.getUserId()
                            LIMIT 1
                        ];
                        
                        this.isExportControlVisible = accessSetup.Export_Control__c;
                        this.isIPDeclarationVisible = accessSetup.IP_Declaration__c;
                        
                        // Paginate
                        paginate();
                        this.deviceList = this.mapDeviceRecords.get(1);
                    }
                                    
                    this.deviceReturnedSize = this.deviceList.size();
                    this.deviceReturned = true;
                    this.deviceFrom = 1;
                    this.deviceTo = this.deviceList.size();
                }
                
          }                    
       }
   
     Catch(Exception e)
       {
        System.debug('Exception:'+e);
       }
    }
    
/*--------------------added for Case 35310 start-----------------------------------------------*/    
    public PageReference insertsearchresulttable()
    {
    System.debug('@@@@@@insertsearchresulttable');//global search
    System.debug('@@@@@@inputSearchText'+inputSearchText);//global search
    
    if(inputSearchText!=null && inputSearchText!='')
           {
           
           Search_Result__c result=new Search_Result__c ();
           result.User__c=UserId;
           result.Search_Keyword__c =inputSearchText;
           result.User_Name__c=UserName;
           result.ShortName__c=ShortName;
           result.Date_Searched__c=System.Today();
           System.debug('@@@@@@result'+result);//global search
           insert result;
           
           }
           
           return null;
    }
/*--------------------added for Case 35310 end-----------------------------------------------*/      
    
    /**
    This method is used for populate FieldSetMember for Case object
    @method name: getSearchResultItems
    @parameter:   NA.
    @return :     List<String> .
    **/
    public List<String> getSearchResultItems(string fieldSetName) {
    
        List <String> lstFS = New List <String> ();
        lstFS.add('CaseNumber');
        lstFS.add('Subject');        
        Schema.DescribeSObjectResult res = globalDescribe.get('Case').getDescribe();
        List < Schema.FieldSetMember > fields = res.fieldSets.getMap().get(fieldSetName).getFields();

        for (Schema.FieldSetMember fsm: fields) {            
            lstFS.add(fsm.getFieldPath());
        }
        return lstFS;
    }
    
    /**
    This method is used for creating SOSL String from Object & corresponding Field Set Name
    @method name: createSOSLString
    @parameter:   String object Name, String fieldSet Name
    @return :     String.
    **/
    public string createSOSLString(string fieldSetName) {
        String query = ' Case(Id, CaseNumber, Subject, Description ';

        Schema.DescribeSObjectResult res = globalDescribe.get('Case').getDescribe();
        Map < String, Schema.FieldSet > fieldSetMap = res.fieldSets.getMap();
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);

        for (Schema.FieldSetMember fsm: fs.getFields()) {
            query = query + ',' + fsm.getFieldPath();
        }        
        query = query + ' ORDER BY LastModifiedDate DESC LIMIT 10)';

        return query;
    }
    
       
    public PageReference onClickRedirect() 
      {
      PageReference redirect = new PageReference('/'+recordId); 
      system.debug('REDIRECTTTTTTTTTTTT'+recordId);
      redirect.setRedirect(true); 
      return redirect;
      }
      
      public PageReference autoRefresh()
      {
          
          count ++;
          searchResultpbsection = True;
          System.debug('count ------>'+count);
          return null;
      }
      
    public List<DeviceWrapper> getSortedDeviceList() {
        Map<string, DeviceWrapper> mapSort = new Map<string, DeviceWrapper>(); 
        for (DeviceWrapper dw : this.deviceList) {
            if (this.sortBy == 'Name') {
                mapSort.put(dw.Name, dw);
            } else if (this.sortBy == 'Stage') {
                mapSort.put(dw.Stage + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'ShortName') {
                mapSort.put(dw.ShortName + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'Fab') {
                mapSort.put(dw.Fab + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'Geometry') {
                mapSort.put(dw.Geometry + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'CurrentForecastTapeoutDate') {
                mapSort.put(dw.CurrentForecastTapeoutDate + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'ExportControlForm') {
                mapSort.put(dw.ExportControlFormName + ' ' + dw.Name, dw);
            } else if (this.sortBy == 'IpDeclarationForm') {
                mapSort.put(dw.IpDeclarationFormName + ' ' + dw.Name, dw);
            }
        }
        
        List<string> sortList = new List<string>();
        sortList.addAll(mapSort.keySet());
        sortList.sort();
        
        List<DeviceWrapper> sortedList = new List<DeviceWrapper>(); 
        if (this.sortBy != this.prevSortBy) {
            this.orderBy = 'ASC';
            this.prevSortBy = this.sortBy;
        }
        
        if (this.orderBy == 'ASC') {
            for (string s : sortList) {
                sortedList.add(mapSort.get(s));
            }
        } else if (this.orderBy == 'DESC') {
            for (integer n=sortList.size(); n>0; n--) {
                sortedList.add(mapSort.get(sortList[n-1]));
            }
        }
        
        return sortedList;
    }
    
    // Pagination
    private void paginate() {
        // Init
        integer rowsPerPage = integer.valueOf(Environment_Variable__c.getInstance('DEVICE_SEARCH_RECORDS_PER_PAGE_GFV').Value__c);
        this.currentPageNo = 1;
        this.totalNoOfPages = 1;
        this.totalNoOfRecords = 0;
        
        this.mapDeviceRecords = new Map<integer, List<DeviceWrapper>>(); 
        Integer counter = 1;
        Integer pageKey = 1;
        
        for(DeviceWrapper d: this.deviceList){
            if(counter <= integer.valueOf(Environment_Variable__c.getInstance('DEVICE_SEARCH_RECORDS_PER_PAGE_GFV').Value__c)) {
                if(this.mapDeviceRecords.containsKey(pageKey)){
                    this.mapDeviceRecords.get(pageKey).add(d);
                } else {
                    this.mapDeviceRecords.put(pageKey, new List<DeviceWrapper>{d});
                }
                counter ++;
            } else {               
                counter = 1;
                pageKey++;
            }
        } 
        
        this.totalNoOfPages = this.mapDeviceRecords.keyset().size();       
    }
    
    public boolean getHasPrevious() {        
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.sortBy = 'Name';
        this.prevSortBy = 'Name';
        this.orderBy = 'ASC';
        this.currentPageNo--;      
        this.deviceList = this.mapDeviceRecords.get(this.currentPageNo);
        this.deviceFrom = (this.currentPageNo * integer.valueOf(Environment_Variable__c.getInstance('DEVICE_SEARCH_RECORDS_PER_PAGE_GFV').Value__c)) + 1;
        this.deviceTo = (this.deviceFrom + this.deviceList.size()) - 1;
    }
    
    public void next() {
        this.sortBy = 'Name';
        this.prevSortBy = 'Name';
        this.orderBy = 'ASC';
        this.currentPageNo++;       
        this.deviceList = this.mapDeviceRecords.get(this.currentPageNo);
        this.deviceFrom = (this.currentPageNo * integer.valueOf(Environment_Variable__c.getInstance('DEVICE_SEARCH_RECORDS_PER_PAGE_GFV').Value__c)) + 1;
        this.deviceTo = (this.deviceFrom + this.deviceList.size()) - 1;
    }
    
    public void first() {
        this.sortBy = 'Name';
        this.prevSortBy = 'Name';
        this.orderBy = 'ASC';
        this.currentPageNo = 1;      
        this.deviceList = this.mapDeviceRecords.get(1);
        this.deviceFrom = 1;
        this.deviceTo = this.deviceList.size();
    }
    
    public void last() {
        this.sortBy = 'Name';
        this.prevSortBy = 'Name';
        this.orderBy = 'ASC';
        this.currentPageNo = this.totalNoOfPages;       
        this.deviceList = this.mapDeviceRecords.get(this.totalNoOfPages);
        this.deviceFrom = ((this.totalNoOfPages - 1) * integer.valueOf(Environment_Variable__c.getInstance('DEVICE_SEARCH_RECORDS_PER_PAGE_GFV').Value__c)) + 1;
        this.deviceTo = (this.deviceFrom + this.deviceList.size()) - 1;
    }
    
    // Wrapper Class
    public class DeviceWrapper {
        public string Id {get;set;}
        public string Name {get;set;}
        public string Stage {get;set;}
        public string ShortName {get;set;}
        public string Fab {get;set;}
        public string Geometry {get;set;}
        public date CurrentForecastTapeoutDate {get;set;}
        public string ExportControlFormId {get;set;}
        public string ExportControlFormName {get;set;}
        public string IpDeclarationFormId {get;set;}
        public string IpDeclarationFormName {get;set;} 
    }
}