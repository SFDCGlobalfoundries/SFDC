/*
    Class Name:    CustomLookupController 
    History: 
      TL           17072013    - Code Modification - differentiated IP search function between internal and portal users
      ZA           10282014    - Updated code as per CASE 35430.
      Bakundi      25-Jan-2015    Updated to add further filters
*/
public class CustomLookupController{
  public List<Process__c > processes {get;set;}  
  public List<ip__c> IPs {get;set;}
  Boolean isFirstTime = true;
  string previousSortField = '';
  String selectedBX041 {get;set;}
  Public String bxTextBox {get;set;}
  public String ipTextBox {get;set;}
  public boolean isNew {get;set;}
  public boolean errorExists {get;set;}
  public Process__c proc {get;set;}
  public String FormTag {get;set;}
  // ZA 10282014
  //public String processFamily {get;set;}
  public String geometry {get;set;}
  public String objectType {get;set;}
  public String ipType {get;set;}
  public boolean isCustomer {get;set;}//17072014 TL
    
  public CustomLookupController() {
    //17072014 TL
    String pfName = [select name from profile where id = :UserInfo.getProfileId()].name;
    if(pfName.contains('Portal') ) {
        isCustomer = true;
    } else{
        isCustomer = false;
    }
    
    isAscending = true;
    isNew = false ;
    errorExists = true ;
    previousSortField = 'LastModifiedDate';
    SortField = 'LastModifiedDate';
    isAscending = false;
    
    FormTag = System.currentPageReference().getParameters().get('frm');
    proc  = new process__c ();
    bxTextBox = System.currentPageReference().getParameters().get('pids');
    // ZA 10282014
    //processFamily = System.currentPageReference().getParameters().get('ProcFam');
    geometry = System.currentPageReference().getParameters().get('Geom');
    objectType = System.currentPageReference().getParameters().get('Objct');
    ipType = System.currentPageReference().getParameters().get('iptype');
    processes = new List<Process__c >();
    string searchString = System.currentPageReference().getParameters().get('lksrch');
    if(searchString != null && searchString != ''){
      this.searchText = searchString;   
    }
    QueryProcessesIP();    
    isFirstTime = false;
    excessRowsError = false;
  }
  
  public PageReference search() {
    isAscending = true;
    SortField = 'LastModifiedDate';
    QueryProcessesIP();
    return null;
  } 
  
  public void QueryProcessesIP() {    
    if(isFirstTime && searchText == null) {
        if(objectType == 'REQPID'){
              Processes = processNormalQuery();
        }
        else{
              ips = ipNormalQuery();
        }       
        return ;
   } else{
       string searchString = getSearchString();
       if(objectType == 'REQPID'){
           processes= processSearchQuery(searchString); 
           excessRowsError = processes.size() > 1000 ? true:false;    
       }   
       else if(objectType == 'IP'){
           ips = ipSearchQuery(searchString);
           excessRowsError = ips.size() > 1000 ? true:false;
       }
   }
  } 
  
  public Integer getListSize() {
      return processes.size();
  }
  public Integer getIPListSize(){
      return IPs.size();
  }
  
  public Boolean excessRowsError {
    get;
    set;
  }
  
 public List<Process__c > processSearchQuery(string searchString) {
    processes = new list<Process__c >();
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    }
    
    if(searchString != '' && searchString != null){
        strQuery = 'Select Id, Name,Tech_Geometry__c ,Process_Family__c,Available_to_Sell__c,Tech_Type__c,Process_Technology__c,Bias_Table_Spec__c,Frame_Table_Spec__c  From Process__c where Name LIKE \'' + searchString + '\'' ;
        strQuery +='AND Tech_Geometry__c = \'' + geometry + '\'';
        // ZA 10282014
        //strQuery +=' AND Process_Family__c = \'' + processFamily + '\'';
        strQuery = strQuery + ' ORDER BY ' + SortField;
        strQuery = strQuery + ' ' + sortingOrder;
        strQuery = strQuery + ' NULLS LAST';
    }
    
    List<Process__c > lstProcesses = database.query(strQuery);
       
    if (lstProcesses .size() >= 1000 ) {
         List<process__c> trnctLstProcesses = new List<process__c>();   
         for (integer i = 0 ; i <= 1000; i++) {
             trnctLstProcesses.add(lstProcesses.get(i));
         }
         return trnctLstProcesses ;
   }      
   return lstProcesses;
 }
 public List<IP__c > ipSearchQuery(string searchString) {
    IPS = new list<ip__c >();
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    } 
    
    if(searchString != '' && searchString != null){
        strQuery = 'Select Id, Name,IP_Type__c ,Showstopper__c,IP_Vendor__c, Library_Name__c, IP_Technology__c,Latest_Version__c,IP_Type_Category__c, Description__c,PT_Number__c,PH1_QA_Status__c,Lifecycle__c From ip__c where IPNumber__r.Sponsored_Enabled_IP__c = \'Sponsored\' AND (Name LIKE \'' + String.escapeSingleQuotes(searchString) + '\'' ;
        strQuery += ' OR IP_Technology__c LIKE \'' + String.escapeSingleQuotes(searchString) + '\' OR Library_Name__c LIKE \'' + String.escapeSingleQuotes(searchString) + '\' OR IP_Vendor__c LIKE \'' + String.escapeSingleQuotes(searchString) + '\' OR IP_Type_Category__c LIKE \'' + String.escapeSingleQuotes(searchString) + '\')' ;
        if(isCustomer) strQuery += ' AND Lifecycle__c != \'EOL\'';
        strQuery +=' AND IP_Geometry__c = \'' + geometry + '\'';
        strQuery +=' AND IP_Type__c = \'' + ipType + '\'';
        strQuery = strQuery + ' ORDER BY ' + SortField;
        strQuery = strQuery + ' ' + sortingOrder;
        strQuery = strQuery + ' NULLS LAST';
        //strQuery +='AND IP_Type__c = \'' + ipType + '\'';
    }
    else {
        strQuery = 'Select Id, Name,IP_Type__c ,Showstopper__c,IP_Vendor__c, Library_Name__c, IP_Technology__c,Latest_Version__c,IP_Type_Category__c, Description__c,PT_Number__c,PH1_QA_Status__c,Lifecycle__c From ip__c where IPNumber__r.Sponsored_Enabled_IP__c = \'Sponsored\' AND IP_Geometry__c = \'' + geometry + '\'';
        strQuery +=' AND IP_Type__c = \'' + ipType + '\'';
        if(isCustomer) strQuery += ' AND Lifecycle__c != \'EOL\'';
        strQuery += ' ORDER BY ' + SortField;
        strQuery += ' ' + sortingOrder;
        strQuery += ' NULLS LAST';
    }
    system.debug('customlookup' + strQuery);
    List<ip__c > lstIPs = database.query(strQuery);
       
    if (lstIPs.size() >= 1000 ) {
         List<ip__c> trnctLstIPs = new List<ip__c>();   
         for (integer i = 0 ; i <= 1000; i++) {
             trnctLstIPs.add(lstIPs.get(i));
         }
         return trnctLstIPs;
   }      
   return lstIPs ;

  }
  
  public List<ip__c > ipNormalQuery() {
    IPs = new list<ip__c >();
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    }
    
  
    strQuery = 'Select Id, Name,IP_Type__c ,Showstopper__c, Library_Name__c, IP_Technology__c,IP_Type_Category__c,IP_Vendor__c,Latest_Version__c, Description__c,PT_Number__c,PH1_QA_Status__c,Lifecycle__c From ip__c  where IPNumber__r.Sponsored_Enabled_IP__c = \'Sponsored\' AND IP_Geometry__c = \'' + geometry + '\'';
    strQuery +=' AND IP_Type__c = \'' + ipType + '\'';
    if(isCustomer) strQuery += ' AND Lifecycle__c != \'EOL\'';
    strQuery += ' ORDER BY ' + SortField;
    strQuery += ' ' + sortingOrder;
    strQuery += ' NULLS LAST';
    List<ip__c> IPs= database.query(strQuery);    
         
   if (IPs.size() >= 1000 ) {
         List<ip__c > trnctLstIPs = new List<ip__c >();   
         for (integer i = 0 ; i < 1000; i++) {
             trnctLstIPs.add(IPs.get(i));
         }
         return trnctLstIPs;
   }     
    return IPs;
  }
  
  public List<Process__c > processNormalQuery() {
    Processes = new list<Process__c >();
    string sortingOrder = 'ASC';
    string strQuery = '';
    if (isAscending == false){
      sortingOrder = 'DESC';
    }
    
  
    strQuery = 'Select Id, Name,Tech_Geometry__c ,Process_Family__c,Available_to_Sell__c,Tech_Type__c,Process_Technology__c,Bias_Table_Spec__c,Frame_Table_Spec__c  From Process__c where';
    strQuery +=' Tech_Geometry__c = \'' + geometry + '\'';
    // ZA 10282014
    //strQuery +=' AND Process_Family__c = \'' + processFamily + '\'';
    strQuery = strQuery + ' ORDER BY ' + SortField;
    strQuery = strQuery + ' ' + sortingOrder;
    strQuery = strQuery + ' NULLS LAST';
    List<Process__c> processes= database.query(strQuery);    
         
   if (processes.size() >= 1000 ) {
         List<process__c> trnctLstProcesses = new List<process__c>();   
         for (integer i = 0 ; i < 1000; i++) {
             trnctLstProcesses.add(processes.get(i));
         }
         return trnctLstProcesses;
   }     
    return processes;
  }

  private string getSearchString() {
    if(!String.isblank(searchText)){
        string input = searchText.replace('*','%');
        if(input.indexOf('%') == -1){
          input = '%' + input + '%';
        }
        return input;
    }
    else{
        return NULL;
    }
  }
  public string searchText {
    get;
    set; 
  } 

  public boolean isAscending {
    get;
    set;
  }

  public string sortField {
    get;
    set {
      this.previousSortField = sortField;
      this.sortField = value;
      if(previousSortField == sortField) {
        isAscending = !isAscending;
        return;
      }
      this.isAscending = true;  
    }
  }
    
  // SORTING
  public PageReference DoSort(){
    if(String.isBlank(searchText)) {
      if(objectType == 'REQPID'){
          Processes = processNormalQuery();
      }
      else{
          ips = ipNormalQuery();
      }
      return null;  
    } else{
        string searchString = getSearchString();
        if(objectType == 'REQPID'){
           processes= processSearchQuery(searchString); 
           excessRowsError = processes.size() > 1000 ? true:false;    
        }   
        else if(objectType == 'IP'){
           ips = ipSearchQuery(searchString);
           excessRowsError = ips.size() > 1000 ? true:false;
        }  
    }
    return null; 
  }  

}