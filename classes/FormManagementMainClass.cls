/* 
    Author: Abhita Bansal
    Company: GLOBALFOUNDRIES
    Project:
    Description: 
    Change History: 
          Date               Name                    Comments
        21-Jul-2016        Ashwin Dash          Added method to go to the main form creation page on click of Create button
        11-Aug-2016        Ashwin Dash          Adding code for Search functionality and save search
        07-Oct-2016        Anil Kumar Reddy L   Adding code for search criteria based on user date type choice.
        01-Nov-2016        Ashwin Dash          Adding code for bringing All to the top as requested by Shiva
        09-Nov-2016        Ashwin Dash          Added new panel to stop viewing the criteria for quick search
        17-Nov-2016        Anil Kumar Reddy L   Modified code for date range filterations.
        6-Dec-2016         Inshu Misra          Added code for exception framework...#IM
        19-Apr-2017       Anirban Roy           Modified on line 1835 to change the condition and remove blank check as Id can have only null check.
        26-May-2017       Anirban Roy           Modified code for Product Name and Product Revision multiselect picklist
        29-May-2017       Ram Rai               Creator field added in CSV file/ Search query modfied and CreatedByName is Added    
        31-May-2017       Ram Rai              Mysubscription View Form Link 
        12-Jun-2017       Ram Rai               Search Result Issue 
        15 - Jun-2017     Ram Rai               My subscription issue
        28-Jun-2017       Anirban Roy           Modified to incorporate the code review comments
        18-July-2017      Ram Rai               Search Related Change for Step Plans issue #478.
        27-July-2017      Anirban Roy           Modified code for Product Name and Product Revision issue.
        14-Aug-2017       Ram Rai               Modified Code to fix form state issue.  
        01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue
*/
public with sharing class FormManagementMainClass {
    
    public Boolean isExternalUser {get;set;}
    public List<List<string>> listDetails{get; set;}
    public User loggedInUser{get;set;}
    public FMS_Search_Filter__c fmsSearchFilterObj{get;set;}
    public FMS_Search_Filter__c fmsSearchFilterViewObj{get;set;}
    public List<String> selAddSearchFilter{get;set;}
    public String selAddSearchFilter1{get;set;}
    public List<string> customerLeftSelected{get;set;}
    public List<string> customerRightSelected{get;set;}
    public transient Set<string> customerLeftValues{get;set;}
    public Set<string> customerRightValues{get;set;}
    public Set<string> customerRightValuesDup{get;set;}
    public List<string> formTypeLeftSelected{get;set;}
    public List<string> formTypeRightSelected{get;set;}
    public Set<string> formTypeLeftValues{get;set;}
    public Set<string> formTypeRightValues{get;set;}
    public Set<string> formTypeRightValuesDup{get;set;}
    public List<string> prodNameLeftSelected{get;set;}
    public List<string> prodNameRightSelected{get;set;}
    public Set<string> prodNameLeftValues{get;set;}
    public Set<string> prodNameRightValues{get;set;}
    public Set<string> prodNameRightValuesDup{get;set;}
    public List<string> prodRevLeftSelected{get;set;}
    public List<string> prodRevRightSelected{get;set;}
    public Set<string> prodRevLeftValues{get;set;}
    public Set<string> prodRevRightValues{get;set;}
    public Set<string> prodRevRightValuesDup{get;set;}
    public Set<String> customerSet{get;set;}
    
    public Set<String> formTypeSet{get;set;}
    public Set<String> prodNameSet{get;set;} 
    public Set<String> prodRevSet{get;set;} 
    public Set<String> customerSetInsideMethod{get;set;}
    public Set<String> formTypeSetInsideMethod{get;set;}
    public Map<String, boolean> renderingMap{get;set;}
    public String fmsFilterId{get;set;}
    public boolean sameIMCforMain{get;set;}
    public boolean popupVal{get;set;}
    public String requestMsg{get;set;}
    public boolean saveNewRecordCheck{get;set;}
    public boolean dispCustomer{get;set;}
    public boolean dispFormTypes{get;set;}
    public String queryString{get;set;}
    public boolean dispSearchResult{get;set;}
    public Date varFromCreatedDate{get;set;}
    public Date varToCreatedDate{get;set;}
    public Date varFromModifiedDate{get;set;}
    public Date varToModifiedDate{get;set;}
    public Date varProjectionDate{get;set;}
    public String quickSearchFormId{get;set;}
    public String recievedFromQuickSearch{get;set;}
    public String savedSearchQuery{get;set;}
    public transient List<ActionTableWrapper> fmsSvSrchList{get;set;}
    public transient List<Form_Management_System__c> FMSRecords{set;}
    public transient List<ActionTableWrapper> FMSSavSearchRecords{set;}
    Public Integer noOfSubscribedRecords{get; set;}
    Public Integer pagesize{get;set;}
    Public Boolean fmsRecoFlag{get;set;}
    Public Map < String,FMSDocumentsLinks__c > FMSdocuments {get;set;}
    public boolean isDMEA{get;set;} 
    public transient List<fmsSearchResultWrapper> accessFMSRecords{set;}  
    public boolean dispAccessFMSRecords{get;set;}    
    public boolean isQuickSearch{get;set;} 

    public boolean autoSubscibeChkBox{get;set;}
    public FMS_My_Subscription__c fmsMySub {get;set;}
    public List<FMS_Subscription__c> fmsSubscription {get;set;}
    public Id unsubscribeId {get;set;}
    public Id formrecordtypeId{get;set;}
    public Id formId{get;set;}
    public boolean mysubResultError {get;set;}
    public String ActiveTab {get; set;}
    public Id searchUnsubscibeId{get;set;}

    public String dateOptionTypeOpted {get;set;}
    public String dateOptionOpted {get;set;}
    public String modifyDateOptTypeOpted {get;set;}
    public String modifydateOptionOpted {get;set;}
    public Date varafterCreatedDate;
    public Date varafterModifiedDate;
    
    public string editCreationDateOptnOptd;
    public string editModifyDateOptnOptd;
    public String hideOtherSections{get;set;} 
    public boolean searchScrollMessage{get;set;}
    public boolean searchcall {get;set;}
    public boolean quickSearchCall {get;set;}
    public boolean viewResultsCall {get;set;}
    public String deleted{get;set;}  
    public Integer status{get;set;}  
    public String nameVal{get;set;}  
    public String escapedNameString{get;set;} 
    public String tranx;
    public String deleteId;
    public Map<Id,Id> accPrt = new Map<Id,Id>();
    public String SortFieldSave;
    public boolean setConFlag;
    public List<FMS_Subscription__c> subsList1{get;set;}
    public List<String> sortedList{get;set;}
    public Set<String> formIds; 
    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 
   // map<string,Account> mpAccounts = new map<string,Account>();

    // added account recordtype filter
        list<String> accountRecordTypes = new list<String>();
    Integer vfPagelistSize;   
    public FormManagementMainClass() {  
        vfPagelistSize = (Environment_Variable__c.getInstance('FMS_VFPagelist_Limit') == NULL || Environment_Variable__c.getInstance('FMS_VFPagelist_Limit').Value__c == NULL) ? 950 : Integer.valueOf(Environment_Variable__c.getInstance('FMS_VFPagelist_Limit').Value__c);
        accountRecordTypes.add(Environment_Variable__c.getInstance('ACCT_RT_ID_CUSTOMER').Value__c);
        accountRecordTypes.add(Environment_Variable__c.getInstance('ACCT_RT_ID_EN_PARTNER').Value__c);
        accountRecordTypes.add(Environment_Variable__c.getInstance('ACCT_RT_ID_RESELLER').Value__c);
		accountRecordTypes.add(Environment_Variable__c.getInstance('ACCT_RT_ID_GF_INTERNAL').Value__c);		
        lstProdOpts = new list<list<SelectOption>>(); 
        lstSelectedProdOpts = new list<list<SelectOption>>(); 
        lstProdRevs = new list<list<SelectOption>>();
        lstSelectedProdRevs = new list<list<SelectOption>>();
        dispAccessFMSRecords = false; 
        isQuickSearch = true; 
        customerRightValues = new Set<String>();
        formTypeRightValues = new Set<String>();
        customerLeftValues = new Set<String>();
        formTypeLeftValues = new Set<String>();
        formTypeRightValuesDup = new Set<String>();
        customerRightValuesDup = new Set<String>();
        prodNameLeftValues = new Set<String>();
        prodNameRightValues = new Set<String>();
        prodRevLeftValues = new Set<String>();
        prodRevRightValues = new Set<String>();
        List<FMS_Subscription__c> subsList = new List<FMS_Subscription__c>();
        subsList1 = new List<FMS_Subscription__c>();
        Set<String> fmsset = new Set<String>();
   

        customerSet = new Set<String>();
        formTypeSet = new Set<String>();
        prodNameSet = new Set<String>();
        prodRevSet = new Set<String>();
        sortedList = new List<String>();
        sameIMCforMain = false;
        searchcall = false;
        quickSearchCall= false;
        viewResultsCall =false;
        escapedNameString = '';
        status = 1;   
        SortFieldSave = SortField; 
        setConFlag= true;
                    subsList = [SELECT Saved_Search_Id__r.name,Saved_Search_Id__c,Form_Inserted__c,Form_Status_Change__c,Form_Updated__c,Form_Deleted__c FROM FMS_Subscription__c WHERE User_Name__c=:userinfo.getuserid() and Saved_Search_Id__r.name!=null and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true)];
        for (FMS_Subscription__c s : subsList) {
            if (fmsset.add(s.Saved_Search_Id__r.name)) {
                subsList1.add(s);
            }
        }

        tranx = ApexPages.currentPage().getParameters().get('tranx');   
        deleteId = ApexPages.currentPage().getParameters().get('delFormNum');
        if(tranx == 'delete'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form successfully deleted : '+deleteId));
        }        
        isDMEA = false;     
        fmsFilterId = ApexPages.currentPage().getParameters().get('id'); 
            
        hideOtherSections = ApexPages.currentPage().getParameters().get('hideOthers');  
        if(hideOtherSections == null || hideOtherSections == ''){
            hideOtherSections = 'No';
        }
        selAddSearchFilter = new List<String>();
        selAddSearchFilter1 = ''; 
        dispFormTypes = true;   
        dispCustomer = true;    
        popupVal = false;
        requestMsg = '';
        queryString = '';
        quickSearchFormId = '';
        recievedFromQuickSearch = '';
        saveNewRecordCheck = false;
        dispSearchResult = false;
        fmsSvSrchList = new List<ActionTableWrapper>();
        listDetails = new List<List<string>>();
        fmsRecoFlag =  false;
        searchScrollMessage = false;
        
        customerRightValues.add('All');
        FMSdocuments = FMSDocumentsLinks__c.getAll();
        
        loggedInUser = [SELECT id, Name, ContactId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1]; 
        savedSearchQuery = 'SELECT id, Name, OwnerId,createdbyid,createdby.Name, Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c, Customer__c, '+
                           ' Design_Submission_Type__c, Form_State__c, Form_Type__c, Last_Modified_From__c, Last_Modified_To__c,' +
                           ' Package_Requirement__c, Package_Type__c, Packaging_Services__c, PO_Submission__c, Product_Name__c,'+ 
                           ' Product_Revision__c,CreationDateOptions__c, ModifiedDateOptions__c, Release_Process__c, '+
                           ' Step_Plan_Input_Method__c, Submission_Type__c, Tapeout_Date_Projection__c, Technology__c, '+
                           ' Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c, CreatedDate, LastModifiedDate ,Customer_Names__c, '+
                           ' (SELECT Form_Deleted__c, Form_Id__c, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Id, '+ 
                           ' Saved_Search_Id__c, User_Name__c FROM FMS_Subscriptions__r where UnSubscribed_Date__c = null and Saved_Search_Id__c != null limit 1) FROM FMS_Search_Filter__c '+ 
                           ' WHERE OwnerId = \''+loggedInUser.Id+'\'';
        fmsSearchFilterViewObj = new FMS_Search_Filter__c();
        if(fmsFilterId != null && fmsFilterId != ''){
            try{
                fmsSearchFilterObj = [SELECT id, Name, OwnerId,createdbyid, createdby.Name,Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c, Customer__c, 
                                      Design_Submission_Type__c, Form_State__c, Form_Type__c, Last_Modified_From__c, Last_Modified_To__c, 
                                      Package_Requirement__c,Package_Type__c, Packaging_Services__c, PO_Submission__c, Product_Name__c, 
                                      Product_Revision__c, Release_Process__c, Step_Plan_Input_Method__c,Submission_Type__c, Tapeout_Date_Projection__c, 
                                      Technology__c, Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c, CreatedDate, LastModifiedDate ,
                                      CreationDateOptions__c, ModifiedDateOptions__c, Customer_Names__c  FROM FMS_Search_Filter__c WHERE id = :fmsFilterId LIMIT 1];
            }Catch(Exception e){
                fmsSearchFilterObj = new FMS_Search_Filter__c();
            }
        }else{
            fmsSearchFilterObj = new FMS_Search_Filter__c();
            dateOptionTypeOpted = 'alldates';
            fmsSearchFilterObj.CreationDateOptions__c = 'alldates';
            modifyDateOptTypeOpted = 'alldates';
            fmsSearchFilterObj.ModifiedDateOptions__c = 'alldates';
        }
        
        if(fmsSearchFilterObj.CreationDateOptions__c != null && fmsSearchFilterObj.CreationDateOptions__c != ''){
            if(fmsSearchFilterObj.CreationDateOptions__c == 'alldates' 
               || fmsSearchFilterObj.CreationDateOptions__c == 'daterange'){
                   
                dateOptionTypeOpted = fmsSearchFilterObj.CreationDateOptions__c;           
            }
            else{
                dateOptionOpted = fmsSearchFilterObj.CreationDateOptions__c; 
            }
        }
        
        if(fmsSearchFilterObj.ModifiedDateOptions__c != null && fmsSearchFilterObj.ModifiedDateOptions__c != ''){
            if(fmsSearchFilterObj.ModifiedDateOptions__c == 'alldates' 
               || fmsSearchFilterObj.ModifiedDateOptions__c == 'daterange'){
                   
                modifyDateOptTypeOpted = fmsSearchFilterObj.ModifiedDateOptions__c;           
            }
            else{
                modifydateOptionOpted = fmsSearchFilterObj.ModifiedDateOptions__c; 
            }
        }
        

        editCreationDateOptnOptd = fmsSearchFilterObj.CreationDateOptions__c;   
        editModifyDateOptnOptd = fmsSearchFilterObj.ModifiedDateOptions__c; 
        
        
        renderingMap = new Map<String, boolean>();
        for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){
            renderingMap.put(addFilters.Field_API_Name__c,false);
        }       
        isExternalUser = false;
        if(UserInfo.getUserType()!='Standard'){
            isExternalUser = true;            
        } else{
            isExternalUser = false;
        }
        
        
        
        Contact dmeaCont;
        String soldTo;
        List<Account> dmeaAccList = new List<Account>();
        Set<Id> accId = new Set<Id>();
        Set<Id> accId1 = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        
        User loggedInUser = [SELECT id, Name, ContactId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
        if(isExternalUser && loggedInUser.ContactId != null){
            dmeaCont = [SELECT id, Name,account.name,accountid,Account.SAP_Account_Number__c FROM Contact WHERE id = :loggedInUser.ContactId LIMIT 1];    
            if(checkFormCompany(dmeaCont.Account.SAP_Account_Number__c, SAP_ACC_NO)){   
                isDMEA = true;
            }
            soldTo = dmeaCont.Account.SAP_Account_Number__c;     
        }       
        
        if(!isExternalUser && hideOtherSections == 'No'){         
            customerRightValues.add('All');
        } 
        if(!isExternalUser && hideOtherSections == 'Yes'){
            customerLeftValues.add('All');
        }
        // Issue #60 fixed by akash, for adding sap account  number(soldto)
        if(!isDMEA && !isExternalUser){        
        for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes' AND RecordTypeId IN :accountRecordTypes]){
          customerLeftValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));
      //  mpAccounts.put(a.Name + (a.SAP_Account_Number__c == NULL ? '' : ( ' ('+a.SAP_Account_Number__c + ')' )),a);
        }     
        
        }
        else if(!isDMEA && isExternalUser){
        
            for(Account a : [SELECT id,Name,Fab_9_10__c,parentid FROM Account WHERE Fab_9_10__c = 'Yes' AND RecordTypeId IN :accountRecordTypes]){
                accId.add(a.id);
                accMap.put(a.id,a);
                accPrt.put(a.id,a.parentid);                
            }            
          Account acc = [select parentid from account where id = : dmeaCont.accountid  AND RecordTypeId IN :accountRecordTypes ];
          checkChild(acc.parentid);
          // Issue #60 fixed by akash, for adding sap account  number(soldto)
          for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE id=:accPrt.keyset() AND RecordTypeId IN :accountRecordTypes]){           
            customerLeftValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));           
           // mpAccounts.put(a.Name  + (a.SAP_Account_Number__c == NULL ? '' : ( ' ('+a.SAP_Account_Number__c + ')' )),a);
          }        
        }      
        else{          
          populateDMEACust dCustObj = new populateDMEACust();
          dmeaAccList = dCustObj.dmeaList(soldTo);            
        // Issue #60 fixed by akash, for adding sap account  number(soldto)
          for(Account a : dmeaAccList){
            customerLeftValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));
           // mpAccounts.put(a.Name  + (a.SAP_Account_Number__c == NULL ? '' : ( ' ('+a.SAP_Account_Number__c + ')' )),a);
          }   
        }
        
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();   
        if(fmsSearchFilterObj.Form_Type__c == null || fmsSearchFilterObj.Form_Type__c == ''){
            formTypeRightValues.add('All');
        }else if(fmsSearchFilterObj.Form_Type__c != null && fmsSearchFilterObj.Form_Type__c != ''){
            Set<String> tempSet = new Set<String>();
            tempSet.addAll(fmsSearchFilterObj.Form_Type__c.split(';'));
            if(!tempSet.contains('All'))
                formTypeLeftValues.add('All');
        }
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            if(info.getName() != 'Master')
                formTypeLeftValues.add(info.getName());
        }
        
        Map<String, String> tempMap;
        if(fmsSearchFilterObj.Customer__c != null && fmsSearchFilterObj.Customer__c != ''){
            tempMap = new Map<String, String>();
            map<string,Account> mpTempAcc = new map<string,Account>(); 
            for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes' AND RecordTypeId IN :accountRecordTypes]){              
              mpTempAcc.put(a.Name,a);
            }   
            for(String s : fmsSearchFilterObj.Customer__c.split(';')){
                if(mpTempAcc.containsKey(s)) {
                  Account a = mpTempAcc.get(s);
                  s = s + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' ));
                }
                customerRightValues.add(s);
                tempMap.put(s,s);
            }
            for(String s : customerLeftValues){
                if(tempMap.containsKey(s)){
                    customerLeftValues.remove(s);
                }
            }
        }
        if(fmsSearchFilterObj.Form_Type__c != null && fmsSearchFilterObj.Form_Type__c != ''){
            tempMap = new Map<String, String>();
            for(String s : fmsSearchFilterObj.Form_Type__c.split(';')){
                formTypeRightValues.add(s);
                tempMap.put(s,s);
            }
            for(String s : formTypeLeftValues){
                if(tempMap.containsKey(s)){
                    formTypeLeftValues.remove(s);
                }
            }  
        }        
       //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
        Boolean prodNameChkSavedSearch = false;
        Boolean prodRevChkSavedSearch = false;
        if(fmsSearchFilterObj.Add_Filter_Value__c != null && fmsSearchFilterObj.Add_Filter_Value__c != ''){
            selAddSearchFilter.clear();
            for(String s : fmsSearchFilterObj.Add_Filter_Value__c.split(';')){
                 //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
                if(s == 'Product_Name__c'){
                    prodNameChkSavedSearch=true;
                }else if(s == 'Product_Revision__c'){
                    prodRevChkSavedSearch=true;
                }else if(s == 'Form_State__c'){         
                    getFormStateList();
                }
                //14-08-2017 Issue fix for the form state.    
                //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - END
                selAddSearchFilter.add(s);
            }
             //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
            if(prodNameChkSavedSearch){
                prodNamePicklistReset();
                tempMap = new Map<String, String>();
                for(String s : fmsSearchFilterObj.Product_Name__c.split(';')){
                    prodNameRightValues.add(s);
                    if(s != 'All' && prodNameRightValues.contains('All')){
                        prodNameRightValues.remove('All');                               
                    }
                    tempMap.put(s,s);                    
                }
                for(String s : prodNameLeftValues){
                    if(tempMap.containsKey(s)){
                        prodNameLeftValues.remove(s);
                    }
                }
            }
            if(prodRevChkSavedSearch){
                prodRevPicklistReset();
                tempMap = new Map<String, String>();
                for(String s : fmsSearchFilterObj.Product_Revision__c.split(';')){
                    prodRevRightValues.add(s);
                    if(s != 'All' && prodRevRightValues.contains('All')){
                        prodRevRightValues.remove('All');                               
                    }
                    tempMap.put(s,s);
                }
                for(String s : prodRevLeftValues){
                    if(tempMap.containsKey(s)){
                        prodRevLeftValues.remove(s);
                    }
                }
            }
            populateProdOpts(); // changed to fix more than 1000 prod name error
            populateProdRevs();
            //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - END
        } 
        
        alertAddFilter();
        
        mysubResultError= false;
        fmsMySub = new FMS_My_Subscription__c();
        List<FMS_My_Subscription__c> fmsMySubList = [SELECT id,Subscribed_All__c,Subscribed_Date__c,UnSubscribed_Date__c,UserName__c from FMS_My_Subscription__c where UserName__c =:Userinfo.getUserId()];
        if(fmsMySubList!=null && fmsMySubList.size()>0) {
            fmsMySub=fmsMySubList[0];
        }
        else{
            mysubResultError = true;
        }
        

        fmsSubscription = new  List<FMS_Subscription__c>();
        autoSubscibeChkBox= fmsMySub.Subscribed_All__c;
        ActiveTab = ApexPages.currentPage().getParameters().get('ActiveTab');
        if(ActiveTab==null){
            ActiveTab = 'Search'; 
        }
        
    }
    
    
    public boolean fetchAccnts = false;
    public set<String> leftCustomerValues() {
     
      set<String> lstCustomerValues = new set<String>();
      if(Test.isRunningTest() && fetchAccnts) {
        return lstCustomerValues;
      } 
      fetchAccnts = true;
      String soldTo;
      Contact dmeaCont;
      List<Account> dmeaAccList = new List<Account>();
      User loggedInUser = [SELECT id, Name, ContactId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
        if(isExternalUser && loggedInUser.ContactId != null){
            dmeaCont = [SELECT id, Name,account.name,accountid,Account.SAP_Account_Number__c FROM Contact WHERE id = :loggedInUser.ContactId LIMIT 1];    
            if(checkFormCompany(dmeaCont.Account.SAP_Account_Number__c, SAP_ACC_NO)){   
                isDMEA = true;
            }
            soldTo = dmeaCont.Account.SAP_Account_Number__c;     
        }           
      if(!isDMEA && !isExternalUser){        
        for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes' AND RecordTypeId IN :accountRecordTypes]){
          lstCustomerValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));
        }     
         
        }
        else if(!isDMEA && isExternalUser){
            Set<Id> accId = new Set<Id>();
            Map<Id,Account> accMap = new Map<Id,Account>();
            if(!accId.isEmpty())accId.clear(); 
            if(!accMap.isEmpty())accMap.clear();
            if(!accPrt.isEmpty())accMap.clear(); 
            for(Account a : [SELECT id,Name,Fab_9_10__c,parentid FROM Account WHERE Fab_9_10__c = 'Yes' AND RecordTypeId IN :accountRecordTypes]){
                accId.add(a.id);
                accMap.put(a.id,a);
                accPrt.put(a.id,a.parentid);                
            }            
            Account acc = [select parentid from account where id = : dmeaCont.accountid AND RecordTypeId IN :accountRecordTypes ];
            checkChild(acc.parentid);
            for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE id=:accPrt.keyset() AND RecordTypeId IN :accountRecordTypes]){           
              lstCustomerValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));           
            }        
        }      
        else{          
          populateDMEACust dCustObj = new populateDMEACust();
          dmeaAccList = dCustObj.dmeaList(soldTo);            
          for(Account a : dmeaAccList){
            lstCustomerValues.add(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )));
          }   
        }   
      return lstCustomerValues;
    }
    
    public PageReference createMainForm(){
        PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
        pgRef.getParameters().put('tranx', 'Create');
        pgRef.getParameters().put('Type', 'Main');
        pgRef.setRedirect(true);
        return pgRef;
    }
   
    public boolean checkFormCompany(String soldTo, String str){
        if(soldTo != null && soldTo != '' && str != null && str != ''){
            if(str.right(6).equals(soldTo.split('-')[0].right(6))){
                return true;
            }else{
                return false;
            }
        }
        return false;
    } 
        
    public void checkChild(Id Acc){
        
        accPrt.remove(acc);
        if( acc !=null ){       
            List<Account> acLst = [select id,parentid from account where id =: acc];            
        if(acLst !=null && acLst.size()>0 && acLst[0].parentid!=null)
            checkChild(acLst[0].parentid);  
        }
    }
   
    public List<SelectOption> getAddFilterList(){
        List<SelectOption> options1 = new List<SelectOption>();
        Set<String> selectedSearchCriteria = new Set<String>();
        selectedSearchCriteria.addAll(selAddSearchFilter);
        options1.add(new SelectOption('','------- Select --------'));
        if(formTypeRightValues.contains('All')){
            status = 1;
        }else{
            status = 0;
        }
        if(status == 1){
            for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){                
                if(!selectedSearchCriteria.contains(addFilters.Field_API_Name__c)){
                    options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));              
                }
            }
        }else{
          
            for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){
                  
                if(!selectedSearchCriteria.contains(addFilters.Field_API_Name__c)){
                    if(addFilters.Field_API_Name__c == 'Form_State__c' && !formTypeRightValues.isEmpty()){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Chip_Interconnect__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Design_Submission_Type__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Package_Requirement__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Package_Type__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Packaging_Services__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Product_Name__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Product_Revision__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Release_Process__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'PO_Submission__c' && formTypeRightValues.contains('Design Data Submission (RIT)')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Submission_Type__c' && formTypeRightValues.contains('Design Data Submission (RIT)')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Step_Plan_Input_Method__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Tapeout_Date_Projection__c' && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Technology__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Test_Levels_Desired__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                    if(addFilters.Field_API_Name__c == 'Test_Services__c' && formTypeRightValues.contains('Main Product Definition Form')){
                        options1.add(new SelectOption(addFilters.Field_API_Name__c,addFilters.Field_Name__c));
                    }
                }
            }
        }
        return options1;
    }
    
    public void getFormStateList(){
        List<SelectOption> options1 = new List<SelectOption>();
        Set<String> uniqueStateValSet = new Set<String>();
        options1.add(new SelectOption('','--None--'));
        for(FMS_Form_States__c frmStates : FMS_Form_States__c.getAll().values()){
            if(formTypeRightValues.contains('Incremental Mask Change (IMC)') && frmStates.Form_Type__c == 'Main Product Definition Form'){
                sameIMCforMain = true;
            }else{
                sameIMCforMain = false;
            }
            if(!formTypeRightValues.contains('All') && (formTypeRightValues.contains(frmStates.Form_Type__c) || sameIMCforMain)){
                uniqueStateValSet.add(frmStates.Form_State__c);
            }else if(formTypeRightValues.contains('All')){
                uniqueStateValSet.add(frmStates.Form_State__c);
            }         
        }
        sortedList = new List<String>();
        sortedList.addAll(uniqueStateValSet);
    }
        
    public void alertAddFilter(){
        Set<String> selectedValSet = new Set<String>();
        selectedValSet.addAll(selAddSearchFilter);
        
        if(formTypeRightValues.contains('All')){
            if(selectedValSet.contains('Form_State__c')){
                renderingMap.put('Form_State__c',true);
            }else{
                renderingMap.put('Form_State__c',false);
            }
            if(selectedValSet.contains('Chip_Interconnect__c') ){
                renderingMap.put('Chip_Interconnect__c',true);
            }else{
                renderingMap.put('Chip_Interconnect__c',false);
            }
            if(selectedValSet.contains('Design_Submission_Type__c')){
                renderingMap.put('Design_Submission_Type__c',true);
            }else{
                renderingMap.put('Design_Submission_Type__c',false);
            }
            if(selectedValSet.contains('Package_Requirement__c')){
                renderingMap.put('Package_Requirement__c',true);
            }else{
                renderingMap.put('Package_Requirement__c',false);
            }
            if(selectedValSet.contains('Package_Type__c')){
                renderingMap.put('Package_Type__c',true);
            }else{
                renderingMap.put('Package_Type__c',false);
            }
            if(selectedValSet.contains('Packaging_Services__c')){
                renderingMap.put('Packaging_Services__c',true);
            }else{
                renderingMap.put('Packaging_Services__c',false);
            }
            if(selectedValSet.contains('Product_Name__c')){
                renderingMap.put('Product_Name__c',true);
            }else{
                renderingMap.put('Product_Name__c',false);
            }
            if(selectedValSet.contains('Product_Revision__c')){
                renderingMap.put('Product_Revision__c',true);
            }else{
                renderingMap.put('Product_Revision__c',false);
            }
            if(selectedValSet.contains('Release_Process__c')){
                renderingMap.put('Release_Process__c',true);
            }else{
                renderingMap.put('Release_Process__c',false);
            }       
            if(selectedValSet.contains('PO_Submission__c')){
                renderingMap.put('PO_Submission__c',true);
            }else{
                renderingMap.put('PO_Submission__c',false);
            }
            if(selectedValSet.contains('Submission_Type__c')){
                renderingMap.put('Submission_Type__c',true);
            }else{
                renderingMap.put('Submission_Type__c',false);
            }
            if(selectedValSet.contains('Step_Plan_Input_Method__c')){
                renderingMap.put('Step_Plan_Input_Method__c',true);
            }else{
                renderingMap.put('Step_Plan_Input_Method__c',false);
            }
            if(selectedValSet.contains('Tapeout_Date_Projection__c')){
                renderingMap.put('Tapeout_Date_Projection__c',true);
            }else{
                renderingMap.put('Tapeout_Date_Projection__c',false);
            }
            if(selectedValSet.contains('Technology__c')){
                renderingMap.put('Technology__c',true);
            }else{
                renderingMap.put('Technology__c',false);
            }
            if(selectedValSet.contains('Test_Levels_Desired__c')){
                renderingMap.put('Test_Levels_Desired__c',true);
            }else{
                renderingMap.put('Test_Levels_Desired__c',false);
            }
            if(selectedValSet.contains('Test_Services__c')){
                renderingMap.put('Test_Services__c',true);
            }else{
                renderingMap.put('Test_Services__c',false);
            }
        }else{  
            if(selectedValSet.contains('Form_State__c')){
                renderingMap.put('Form_State__c',true);
            }else{
                renderingMap.put('Form_State__c',false);
            }
            if(selectedValSet.contains('Chip_Interconnect__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Chip_Interconnect__c',true);
            }else{
                renderingMap.put('Chip_Interconnect__c',false);
            }
            if(selectedValSet.contains('Design_Submission_Type__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Design_Submission_Type__c',true);
            }else{
                renderingMap.put('Design_Submission_Type__c',false);
            }
            if(selectedValSet.contains('Package_Requirement__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Package_Requirement__c',true);
            }else{
                renderingMap.put('Package_Requirement__c',false);
            }
            if(selectedValSet.contains('Package_Type__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Package_Type__c',true);
            }else{
                renderingMap.put('Package_Type__c',false);
            }
            if(selectedValSet.contains('Packaging_Services__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Packaging_Services__c',true);
            }else{
                renderingMap.put('Packaging_Services__c',false);
            }
            if(selectedValSet.contains('Product_Name__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Product_Name__c',true);
            }else{
                renderingMap.put('Product_Name__c',false);
            }
            if(selectedValSet.contains('Product_Revision__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Product_Revision__c',true);
            }else{
                renderingMap.put('Product_Revision__c',false);
            }
            if(selectedValSet.contains('Release_Process__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Release_Process__c',true);
            }else{
                renderingMap.put('Release_Process__c',false);
            }       
            if(selectedValSet.contains('PO_Submission__c') && formTypeRightValues.contains('Design Data Submission (RIT)')){
                renderingMap.put('PO_Submission__c',true);
            }else{
                renderingMap.put('PO_Submission__c',false);
            }
            if(selectedValSet.contains('Submission_Type__c') && formTypeRightValues.contains('Design Data Submission (RIT)')){
                renderingMap.put('Submission_Type__c',true);
            }else{
                renderingMap.put('Submission_Type__c',false);
            }
            if(selectedValSet.contains('Step_Plan_Input_Method__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Step_Plan_Input_Method__c',true);
            }else{
                renderingMap.put('Step_Plan_Input_Method__c',false);
            }
            if(selectedValSet.contains('Tapeout_Date_Projection__c') && (formTypeRightValues.contains('Main Product Definition Form') || formTypeRightValues.contains('Incremental Mask Change (IMC)'))){
                renderingMap.put('Tapeout_Date_Projection__c',true);
            }else{
                renderingMap.put('Tapeout_Date_Projection__c',false);
            }
            if(selectedValSet.contains('Technology__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Technology__c',true);
            }else{
                renderingMap.put('Technology__c',false);
            }
            if(selectedValSet.contains('Test_Levels_Desired__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Test_Levels_Desired__c',true);
            }else{
                renderingMap.put('Test_Levels_Desired__c',false);
            }
            if(selectedValSet.contains('Test_Services__c') && formTypeRightValues.contains('Main Product Definition Form')){
                renderingMap.put('Test_Services__c',true);
            }else{
                renderingMap.put('Test_Services__c',false);
            }
        }
    }
     
    public PageReference deleteSavedSearch(){
        String valRecieved = Apexpages.currentPage().getParameters().get('searchId'); 
        List<FMS_Search_Filter__c> toBeDeletedList = new List<FMS_Search_Filter__c>();
        List<FMS_Subscription__c> subscriptionDeleteList = new List<FMS_Subscription__c>();
        fmsSvSrchList = getFMSSavSearchRecords(); 
        if (valRecieved == null || valRecieved == '') {     
            return null;
        }else{
            if(fmsSvSrchList != null && !fmsSvSrchList.isEmpty()){
                for(ActionTableWrapper fWrap : fmsSvSrchList){
                    if(valRecieved == fWrap.searchObj.Id){
                        toBeDeletedList.add(fWrap.searchObj);
                    }
                }
            }
        }
        
        if(toBeDeletedList != null && !toBeDeletedList.isEmpty()){
            UtilityCls.deleteSubscription(toBeDeletedList);
            delete toBeDeletedList;
         }
          
        return resetSearch();
    }
    
    public PageReference showResultsMethod(){
        dispAccessFMSRecords = false;  
        isQuickSearch = true;  
        String valRecieved = Apexpages.currentPage().getParameters().get('viewSearchId'); 
        dispSearchResult = false;   
        searchScrollMessage = true;
        searchcall = false;
        quickSearchCall= false;
        viewResultsCall = true;
                
        String retrieveSearchResultQuery = 'SELECT id, Name, OwnerId, createdbyId,createdby.Name,Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c,'+
                                           ' Customer__c, Design_Submission_Type__c, Form_State__c, Form_Type__c, Last_Modified_From__c,'+
                                           ' Last_Modified_To__c, CreationDateOptions__c, ModifiedDateOptions__c , Package_Requirement__c,'+
                                           ' Package_Type__c, Packaging_Services__c, PO_Submission__c, Product_Name__c, Product_Revision__c,'+
                                           ' Release_Process__c, Step_Plan_Input_Method__c, Submission_Type__c, Tapeout_Date_Projection__c,'+
                                           ' Technology__c, Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c, CreatedDate,'+
                                           ' LastModifiedDate FROM FMS_Search_Filter__c WHERE id = \''+valRecieved+'\' LIMIT 1';
        List<FMS_Search_Filter__c> tempList = (List<FMS_Search_Filter__c>)Database.query(retrieveSearchResultQuery);

        fmsSearchFilterViewObj = tempList[0];
        if(fmsSearchFilterViewObj.Form_State__c != null && fmsSearchFilterViewObj.Form_State__c != ''){
            renderingMap.put('Form_State__c', true);
        }
        if(fmsSearchFilterViewObj.Technology__c != null && fmsSearchFilterViewObj.Technology__c != ''){
            renderingMap.put('Technology__c', true);
        }
        for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){
            renderingMap.put(addFilters.Field_API_Name__c,true);
        }
        //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
        Boolean prodNameChkSavedSearch=false;
        Boolean prodRevChkSavedSearch=false;       
        //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - END
        if(fmsSearchFilterViewObj.Add_Filter_Value__c != null && fmsSearchFilterViewObj.Add_Filter_Value__c != ''){
            selAddSearchFilter.clear();
            for(String s : fmsSearchFilterViewObj.Add_Filter_Value__c.split(';')){
                 //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
                if(s == 'Product_Name__c'){
                    prodNameChkSavedSearch=true;
                }else if(s == 'Product_Revision__c'){
                    prodRevChkSavedSearch=true;
                }
                //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - END
                selAddSearchFilter.add(s);
            }
        } 
          //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - START
        if(prodNameChkSavedSearch){
            prodNamePicklistReset();
            Map<String,String> tempMap = new Map<String, String>();
            for(String s : fmsSearchFilterViewObj.Product_Name__c.split(';')){
                prodNameRightValues.add(s);
                if(s != 'All' && prodNameRightValues.contains('All')){
                    prodNameRightValues.remove('All');                               
                }
                tempMap.put(s,s);                    
            }
            for(String s : prodNameLeftValues){
                if(tempMap.containsKey(s)){
                    prodNameLeftValues.remove(s);
                }
            }
        }
        if(prodRevChkSavedSearch){
            prodRevPicklistReset();
            Map<String,String> tempMap = new Map<String, String>();
            for(String s : fmsSearchFilterViewObj.Product_Revision__c.split(';')){
                prodRevRightValues.add(s);
                if(s != 'All' && prodRevRightValues.contains('All')){
                    prodRevRightValues.remove('All');                               
                }
                tempMap.put(s,s);
            }
            for(String s : prodRevLeftValues){
                if(tempMap.containsKey(s)){
                    prodRevLeftValues.remove(s);
                }
            }
        }
        populateProdOpts(); // changed to fix more than 1000 prod name error
        populateProdRevs();
        //27-07-2017 Anirban Roy : Modified code for Product Name and Product Revision - END 

        alertAddFilter();
        String viewResQueryString = 'SELECT id, Name,createdbyid,createdby.Name,Form_Name__c, Technology__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,PurchaseOrder__c,SubmissionType__c,PackageType__c,Packaging_Services__c,ProductName__c,ProductRevision__c,InputMethod__c,ProjectedTapeout__c,TestLevels__c,TestServices__c,DesignSubmission__c,CreatedDate, LastModifiedDate,Latest_Step_Plan__r.LastModifiedDate,Latest_Step_Plan__r.State_of_the_Form__c, Chip_Interconnect__c, OwnerId, Parent_Form_Id__c FROM Form_Management_System__c WHERE ';  
        Set<String> custFSSet = new Set<String>();
        Set<String> testCustSet = new Set<String>();
        if(fmsSearchFilterViewObj.Customer__c != null && fmsSearchFilterViewObj.Customer__c != ''){
            testCustSet.addAll(fmsSearchFilterViewObj.Customer__c.split(';'));
            if(testCustSet.contains('All')){
                for(Account accs:[SELECT id, Name, Fab_9_10__c FROM Account WHERE Fab_9_10__c = 'Yes'  AND RecordTypeId IN :accountRecordTypes]){
                    custFSSet.add(accs.Name);
                }    
            }else{
                for(String s : fmsSearchFilterViewObj.Customer__c.split(';')){
                    custFSSet.add(s);
                }
            }
        }
  
        Set<String> fTypeFSSet = new Set<String>();
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
        Set<String> testFtype = new Set<String>();
        if(fmsSearchFilterViewObj.Form_Type__c != null && fmsSearchFilterViewObj.Form_Type__c != ''){
            testFtype.addAll(fmsSearchFilterViewObj.Form_Type__c.split(';'));
            if(testFtype.contains('All')){              
                fTypeFSSet = rtMapByName.keySet();
            }else{
                for(String s : fmsSearchFilterViewObj.Form_Type__c.split(';')){
                    fTypeFSSet.add(s);
                }
            }
        }
         if(custFSSet.isEmpty()){
            dispCustomer = false;
        }else if(fTypeFSSet.isEmpty()){
            dispFormTypes = false;
        }else{
            dispCustomer = true;
            dispFormTypes = true;
            if(testFtype.contains('All')){
                formTypeRightValuesdup = testFtype;
            }else{
                formTypeRightValuesdup = fTypeFSSet;
            }
            if(testCustSet.contains('All')){
                customerRightValuesdup = testCustSet;
            }else{
                customerRightValuesdup = custFSSet;
            }
            
        }     
        queryString = '';
        
        queryString = searchStringMethod(viewResQueryString,fmsSearchFilterViewObj.Technology__c, fmsSearchFilterViewObj.Form_State__c, fmsSearchFilterViewObj, custFSSet, fTypeFSSet,false);

        if(queryString.endsWithIgnoreCase('where ')){
            queryString = queryString.removeEnd('WHERE ');
        }
        
        refresh();
        if(noOfRecords > 0){
            dispSearchResult = true;
        }
        fmsSearchFilterObj = fmsSearchFilterViewObj;
        fmsSearchFilterObj = new FMS_Search_Filter__c();
        return null;
    }
       
    public PageReference custSelectclick(){
        customerLeftValues = leftCustomerValues();
        customerRightSelected.clear();
        for(String s : customerLeftSelected){            
            if(customerRightValues.contains('All')){
                customerRightValues.remove('All');
                customerLeftValues.add('All');
                customerRightValues.add(s);
                customerLeftValues.remove(s);
            }else if(!s.equalsIgnoreCase('All')){
                customerLeftValues.remove(s);
                customerRightValues.add(s);
            }else if(s.equalsIgnoreCase('All')){
                customerLeftValues.addAll(customerRightValues);
                customerRightValues = new Set<String>();
                customerLeftValues.remove(s);
                customerRightValues.add(s);
            }
        }
        for(String s : customerRightValues) {
          customerLeftValues.remove(s);
        }
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }

        return null;
    }
     
    public PageReference custUnselectclick(){
        customerLeftSelected.clear();
        customerLeftValues = leftCustomerValues();
        for(String s : customerRightSelected){
            if(s != 'All'){
                customerRightValues.remove(s);
                customerLeftValues.add(s);
               
            }
        }
        if(customerRightValues.isEmpty()){
            
            customerRightValues.add('All');
            if(customerLeftValues.contains('All')){
                customerLeftValues.remove('All');
            }
        }
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }
        return null;
    }
 
    public List<SelectOption> getcustUnSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        List<string> tempList1 = new List<String>();   
        customerLeftValues = leftCustomerValues();
        for(String s : customerRightValues) {
          customerLeftValues.remove(s);
        }     
        tempList.addAll(customerLeftValues);
        tempList.sort();
        if(customerLeftValues.contains('All')){
            for(Integer i = 0; i < tempList.size(); i++){
                if(tempList[i] == 'All'){
                    tempList.remove(i);
                }
            }
            tempList1.add('All');
            for(String str : tempList){
                tempList1.add(str );
            }
        }else{
            tempList1 = tempList;
        }
        for(string s : tempList1)   
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getcustSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        if(customerRightValues.size()>1)
        customerRightValues.remove('All');    
        tempList.addAll(customerRightValues);
        tempList.sort();          
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public PageReference formTypeSelectclick(){        
        formTypeRightSelected.clear();
        for(String s : formTypeLeftSelected){            
            if(formTypeRightValues.contains('All')){
                formTypeRightValues.remove('All');
                formTypeLeftValues.add('All');
                formTypeRightValues.add(s);
                formTypeLeftValues.remove(s);
            }else if(!s.equalsIgnoreCase('All')){
                formTypeLeftValues.remove(s);
                formTypeRightValues.add(s);
            }else if(s.equalsIgnoreCase('All')){
                formTypeLeftValues.addAll(formTypeRightValues);
                formTypeRightValues = new Set<String>();
                formTypeLeftValues.remove(s);
                formTypeRightValues.add(s);
            }
        }
        getFormStateList();    
        alertAddFilter(); 
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }
        return null;
    }
     
    public PageReference formTypeUnselectclick(){
        formTypeLeftSelected.clear();
        for(String s : formTypeRightSelected){
            if(s != 'All'){
                formTypeRightValues.remove(s);
                formTypeLeftValues.add(s);
            }
        }
        if(formTypeRightValues.isEmpty()){
            formTypeRightValues.add('All');
            if(formTypeLeftValues.contains('All')){
                formTypeLeftValues.remove('All');
            }
        }
        getFormStateList();
        alertAddFilter();
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }
        return null;
    }
 
    public List<SelectOption> getformTypeUnSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(formTypeLeftValues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getformTypeSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(formTypeRightValues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public PageReference prodNameSelectclick(){
        prodNameRightSelected.clear();    
        for(String s : prodNameLeftSelected){
            if(prodNameRightValues.contains('All')){
                prodNameRightValues.remove('All');
                prodNameLeftValues.add('All');
                prodNameRightValues.add(s);
                prodNameLeftValues.remove(s);
            }else if(!s.equalsIgnoreCase('All')){
                prodNameLeftValues.remove(s);
                prodNameRightValues.add(s);
            }else if(s.equalsIgnoreCase('All')){
                prodNameLeftValues.addAll(prodNameRightValues);
                prodNameRightValues = new Set<String>();
                prodNameLeftValues.remove(s);
                prodNameRightValues.add(s);
            }
        }   
        populateProdOpts(); // changed to fix more than 1000 prod name error
        return null;
    }
     
    public PageReference prodNameUnselectclick(){
        prodNameLeftSelected.clear();
        for(String s : prodNameRightSelected){
            if(s != 'All'){
                prodNameRightValues.remove(s);
                prodNameLeftValues.add(s);
               
            }
        }
        if(prodNameRightValues.isEmpty()){
            
            prodNameRightValues.add('All');
            if(prodNameLeftValues.contains('All')){
                prodNameLeftValues.remove('All');
            }
        }
        populateProdOpts(); // changed to fix more than 1000 prod name error
        return null;
    }
    
    private void populateProdOpts() {
      lstProdOpts = new list<list<SelectOption>>();       
      list<SelectOption> tempLst = new list<SelectOption>(); 
      List<string> tempUnselectList = new List<String>();
      tempUnselectList.addAll(prodNameLeftValues);
      tempUnselectList.sort();
      for(String prd : tempUnselectList) {
         if(tempLst.size() < vfPagelistSize){
           tempLst.add(new SelectOption(prd,prd));
         }else {                    
           lstProdOpts.add(tempLst); 
           tempLst = new List<SelectOption>();
           tempLst.add(new SelectOption(prd,prd));
         } 
      }      
      if(tempLst.size() > 0){
          lstProdOpts.add(tempLst);
      }
      
      lstSelectedProdOpts = new list<list<SelectOption>>(); 
      list<SelectOption> tempLst1 = new list<SelectOption>(); 
      List<string> tempSelectList = new List<String>();
      tempSelectList.addAll(prodNameRightValues);
      tempSelectList.sort();
      for(String prd : prodNameRightValues) {
         if(tempLst1.size() < vfPagelistSize){
           tempLst1.add(new SelectOption(prd,prd));
         }else {                    
           lstSelectedProdOpts.add(tempLst1); 
           tempLst1 = new List<SelectOption>();
           tempLst1.add(new SelectOption(prd,prd));
         } 
      }      
      if(tempLst1.size() > 0){
          lstSelectedProdOpts.add(tempLst1);
      }
      
    }
    
    
    
    
     public List<SelectOption> getProdElement0(){
        if(lstProdOpts.size() >= 1) {
          return lstProdOpts[0];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement1(){
        if(lstProdOpts.size() >= 2) {
          return lstProdOpts[1];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement2(){
        if(lstProdOpts.size() >= 3) {
          return lstProdOpts[2];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement3(){
        if(lstProdOpts.size() >= 4) {
          return lstProdOpts[3];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement4(){
        if(lstProdOpts.size() >= 5) {
          return lstProdOpts[4];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement5(){
        if(lstProdOpts.size() >= 6) {
          return lstProdOpts[5];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement6(){
        if(lstProdOpts.size() >= 7) {
          return lstProdOpts[6];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement7(){
        if(lstProdOpts.size() >= 8) {
          return lstProdOpts[7];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdElement8(){
        if(lstProdOpts.size() >= 9) {
          return lstProdOpts[8];
        }   
        return new list<SelectOption>();
      }
    
       // selected prod names
       public List<SelectOption> getProdSelElement0(){
        if(lstSelectedProdOpts.size() >= 1) {
          return lstSelectedProdOpts[0];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement1(){
        if(lstSelectedProdOpts.size() >= 2) {
          return lstSelectedProdOpts[1];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement2(){
        if(lstSelectedProdOpts.size() >= 3) {
          return lstSelectedProdOpts[2];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement3(){
        if(lstSelectedProdOpts.size() >= 4) {
          return lstSelectedProdOpts[3];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement4(){
        if(lstSelectedProdOpts.size() >= 5) {
          return lstSelectedProdOpts[4];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement5(){
        if(lstSelectedProdOpts.size() >= 6) {
          return lstSelectedProdOpts[5];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement6(){
        if(lstSelectedProdOpts.size() >= 7) {
          return lstSelectedProdOpts[6];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement7(){
        if(lstSelectedProdOpts.size() >= 8) {
          return lstSelectedProdOpts[7];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption>getProdSelElement8(){
        if(lstSelectedProdOpts.size() >= 9) {
          return lstSelectedProdOpts[8];
        }   
        return new list<SelectOption>();
      }
      
    
    public list<list<SelectOption>> lstProdOpts;   
    public list<list<SelectOption>> lstSelectedProdOpts;   
    
    public List<SelectOption> getProdNameSelectedValues(){      
        return new List<SelectOption>();
    }
       
    public PageReference prodRevSelectclick(){
        prodRevRightSelected.clear();
        for(String s : prodRevLeftSelected){            
            if(prodRevRightValues.contains('All')){
                prodRevRightValues.remove('All');
                prodRevLeftValues.add('All');
                prodRevRightValues.add(s);
                prodRevLeftValues.remove(s);
            }else if(!s.equalsIgnoreCase('All')){
                prodRevLeftValues.remove(s);
                prodRevRightValues.add(s);
            }else if(s.equalsIgnoreCase('All')){
                prodRevLeftValues.addAll(prodRevRightValues);
                prodRevRightValues = new Set<String>();
                prodRevLeftValues.remove(s);
                prodRevRightValues.add(s);
            }
        }   
        populateProdRevs();
        return null;
    }
     
    public PageReference prodRevUnselectclick(){
        prodRevLeftSelected.clear();
        for(String s : prodRevRightSelected){
            if(s != 'All'){
                prodRevRightValues.remove(s);
                prodRevLeftValues.add(s);
               
            }
        }
        if(prodRevRightValues.isEmpty()){
            
            prodRevRightValues.add('All');
            if(prodRevLeftValues.contains('All')){
                prodRevLeftValues.remove('All');
            }
        }
        populateProdRevs();
        return null;
    }
 
 
    public List<SelectOption> getProdRevSelectedValues(){
        return new List<SelectOption>();
    }
    
    list<list<SelectOption>> lstProdRevs{get;set;}
    list<list<SelectOption>> lstSelectedProdRevs{get;set;}
    private void populateProdRevs() {
      lstProdRevs = new list<list<SelectOption>>(); 
      list<SelectOption> tempLst = new list<SelectOption>(); 
      List<string> tempUnselectList = new List<String>();
      tempUnselectList.addAll(prodRevLeftValues);
      tempUnselectList.sort();
      for(String prd : tempUnselectList) {
         if(tempLst.size() < vfPagelistSize){
           tempLst.add(new SelectOption(prd,prd));
         }else {                    
           lstProdRevs.add(tempLst); 
           tempLst = new List<SelectOption>();
           tempLst.add(new SelectOption(prd,prd));
         } 
      }
      
      if(tempLst.size() > 0){
          lstProdRevs.add(tempLst);
      }
      
      
      lstSelectedProdRevs = new list<list<SelectOption>>(); 
      list<SelectOption> tempLst1 = new list<SelectOption>(); 
      List<string> tempSelectList = new List<String>();
      tempSelectList.addAll(prodRevRightValues);
      tempSelectList.sort();
      for(String prd : tempSelectList) {
         if(tempLst1.size() < vfPagelistSize){
           tempLst1.add(new SelectOption(prd,prd));
         }else {                    
           lstSelectedProdRevs.add(tempLst1); 
           tempLst1 = new List<SelectOption>();
           tempLst1.add(new SelectOption(prd,prd));
         } 
      }
      
      if(tempLst1.size() > 0){
          lstSelectedProdRevs.add(tempLst1);
      }
      
    }
    public List<SelectOption> getRevElement0(){
        if(lstProdRevs.size() >= 1) {
          return lstProdRevs[0];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement1(){
        if(lstProdRevs.size() >= 2) {
          return lstProdRevs[1];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement2(){
        if(lstProdRevs.size() >= 3) {
          return lstProdRevs[2];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement3(){
        if(lstProdRevs.size() >= 4) {
          return lstProdRevs[3];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement4(){
        if(lstProdRevs.size() >= 5) {
          return lstProdRevs[4];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement5(){
        if(lstProdRevs.size() >= 6) {
          return lstProdRevs[5];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement6(){
        if(lstProdRevs.size() >= 7) {
          return lstProdRevs[6];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement7(){
        if(lstProdRevs.size() >= 8) {
          return lstProdRevs[7];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevElement8(){
        if(lstProdRevs.size() >= 9) {
          return lstProdRevs[8];
        }   
        return new list<SelectOption>();
      }
      
      
      public List<SelectOption> getRevSelElement0(){
        if(lstSelectedProdRevs.size() >= 1) {
          return lstSelectedProdRevs[0];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement1(){
        if(lstSelectedProdRevs.size() >= 2) {
          return lstSelectedProdRevs[1];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement2(){
        if(lstSelectedProdRevs.size() >= 3) {
          return lstSelectedProdRevs[2];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement3(){
        if(lstSelectedProdRevs.size() >= 4) {
          return lstSelectedProdRevs[3];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement4(){
        if(lstSelectedProdRevs.size() >= 5) {
          return lstSelectedProdRevs[4];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement5(){
        if(lstSelectedProdRevs.size() >= 6) {
          return lstSelectedProdRevs[5];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement6(){
        if(lstSelectedProdRevs.size() >= 7) {
          return lstSelectedProdRevs[6];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement7(){
        if(lstSelectedProdRevs.size() >= 8) {
          return lstSelectedProdRevs[7];
        }   
        return new list<SelectOption>();
      }
      public List<SelectOption> getRevSelElement8(){
        if(lstSelectedProdRevs.size() >= 9) {
          return lstSelectedProdRevs[8];
        }   
        return new list<SelectOption>();
      }
      
      
    
    public PageReference resetSearch(){        
        PageReference pgRef = new PageReference('/apex/FormManagementMainPage');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public boolean checkDate(){
        boolean val = false;
        if(dateOptionTypeOpted == 'daterange'){
            if(((fmsSearchFilterObj.Created_Date_From__c > fmsSearchFilterObj.Created_Date_To__c && fmsSearchFilterObj.Created_Date_To__c != null) || (fmsSearchFilterObj.Created_Date_To__c == null && fmsSearchFilterObj.Created_Date_From__c > Datetime.now())) || fmsSearchFilterObj.Created_Date_From__c > Datetime.now()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Form Creation: From date cannot be greater than To date or Today'));
                val = true;
                
            }
            if(fmsSearchFilterObj.Created_Date_From__c == null && fmsSearchFilterObj.Created_Date_To__c == null ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Form Creation: Please provide either "From" or "To" date '));
                val = true;
               
            }
        }
        if(modifyDateOptTypeOpted == 'daterange'){
            if(((fmsSearchFilterObj.Last_Modified_From__c > fmsSearchFilterObj.Last_Modified_To__c && fmsSearchFilterObj.Last_Modified_To__c != null) || (fmsSearchFilterObj.Last_Modified_To__c == null && fmsSearchFilterObj.Last_Modified_From__c > Datetime.now())) || fmsSearchFilterObj.Last_Modified_From__c > Datetime.now()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Form Last Modified: From date cannot be greater than To date or Today'));
                val = true;
                
            }
            if(fmsSearchFilterObj.Last_Modified_From__c == null && fmsSearchFilterObj.Last_Modified_To__c == null ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Form Last Modified: Please provide either "From" or "To" date '));
                val = true;
                
            }
        }
        return val;
    }
    
    public PageReference searchMethod(){  
        map<string,String> mpAccounts = new map<string,String>();
        for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes'  AND RecordTypeId IN :accountRecordTypes]){        
          mpAccounts.put(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )),a.SAP_Account_Number__c == NULL ? a.Short_Name__c : a.SAP_Account_Number__c);
        }
        
        dispAccessFMSRecords = false;  
        isQuickSearch = true; 
        recievedFromQuickSearch = Apexpages.currentPage().getParameters().get('searchQuick'); 
        dispSearchResult = false; 
        searchScrollMessage = false;
        searchcall = false;
        quickSearchCall= false;
        viewResultsCall = false;
        
        if(recievedFromQuickSearch != null && recievedFromQuickSearch != ''){    
            searchcall = false;
            quickSearchCall= true;
            viewResultsCall = false;          
            quickSearchFormId = quickSearchFormId.trim(); 
           //20-7-2017 Anirban Roy - Modified the query against Search logic for step plan
            String queryStr = 'SELECT id, Name,createdbyid,createdby.name, Form_Name__c, Technology__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,CreatedDate, LastModifiedDate,Chip_Interconnect__c, OwnerId, Parent_Form_Id__c,Latest_Step_Plan__c,Latest_Step_Plan__r.name,Latest_Step_Plan__r.LastModifiedDate,Latest_Step_Plan__r.State_of_the_Form__c FROM Form_Management_System__c WHERE (Name = :quickSearchFormId '; //Ravindra- Added new fields in query for Step Plan quick search
            String oldFormStr = '';
            String externalUserStr ='';            
            
            if(quickSearchFormId != null && quickSearchFormId != ''){
                oldFormStr = ' OR Old_Form_Id__c= :quickSearchFormId ';
            }
            queryString = queryStr+oldFormStr+')'+externalUserStr;
            
            refresh();               
            
            if(noOfRecords > 0){
                dispSearchResult = true;
                searchScrollMessage = true;
            }
            isQuickSearch = false; 
            recievedFromQuickSearch = '';
            return null;
        }
        if(checkDate()){
            return null;
        }
        if(customerRightValues.isEmpty()){
            dispCustomer = false;
        }else if(formTypeRightValues.isEmpty()){
            dispFormTypes = false;
        }else{
            dispCustomer = true;
            dispFormTypes = true;
        }     
        
        
        
        String queryString1 = 'SELECT id, Name,createdbyid,createdby.name,Form_Name__c, Technology__c,Latest_Step_Plan__r.LastModifiedDate,Latest_Step_Plan__r.State_of_the_Form__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,PurchaseOrder__c,SubmissionType__c,PackageType__c,Packaging_Services__c,ProductName__c,ProductRevision__c,InputMethod__c,ProjectedTapeout__c,TestLevels__c,TestServices__c,DesignSubmission__c,PackageRequirement__c,CreatedDate, LastModifiedDate, Chip_Interconnect__c, OwnerId, Owner.Profile.UserType, Parent_Form_Id__c FROM Form_Management_System__c WHERE ';    
        if(!customerRightValues.isEmpty()){
            
            if(customerRightValues.contains('All')){
                customerLeftValues = leftCustomerValues();
                for(String s : customerLeftValues){
                    String temp = s;
                    if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
                      temp = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
                    customerSet.add(temp);
                    }else{
                    	customerSet.add(s.substringbeforelast('(').substringbeforelast(' '));    
                    }
                    
                    
                }           
            }else{
                customerSet.clear();
                for(String s : customerRightValues){
                    String temp = s;
                    if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
                      temp = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
                    customerSet.add(temp);                    
                    }else{
                        customerSet.add(s.substringbeforelast('(').substringbeforelast(' '));
                    }
                }   
            }
            
        }        

        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
        if(!formTypeRightValues.isEmpty()){
            if(formTypeRightValues.contains('All')){                
                formTypeSet = rtMapByName.keySet();
                if(formTypeSet.contains('Master')){
                    formTypeSet.remove('Master');
                }
            }else{
                formTypeSet = new Set<String>();
                for(String s : formTypeRightValues){
                    formTypeSet.add(s);
                } 
            }
        }   
        customerRightValuesDup = customerRightValues;
        formTypeRightValuesDup = formTypeRightValues;
        
        Set<String> selAddSearchFilterSet = new Set<String>(selAddSearchFilter);
        
        queryString = searchStringMethod(queryString1, fmsSearchFilterObj.Technology__c, fmsSearchFilterObj.Form_State__c, fmsSearchFilterObj, customerSet, formTypeSet, false);
               

        if(queryString.endsWithIgnoreCase('where ')){
            queryString = queryString.removeEnd('WHERE ');
        }

        refresh();      
        
        if(noOfRecords > 0){
            dispSearchResult = true;
            searchScrollMessage = true;
        }
        return null;
    }
    
    public String searchStringMethod(String queryString1, String techSel, String formStateSel, FMS_Search_Filter__c filterObj, Set<String> custSet, Set<String> fTypeSet, Boolean viewExiting){
        Set<String> selectedField = new Set<String>(selAddSearchFilter);
        // Code added for Issue 378 by Ram Rai for Search Step Plan.
        if(custSet != null && !custSet.isEmpty()){
            customerSetInsideMethod = custSet;
            queryString1 = queryString1 + 'Customer__c IN :customerSetInsideMethod AND ';
        }
        if(fTypeSet != null && !fTypeSet.isEmpty()){
            formTypeSetInsideMethod = fTypeSet;           
            
            if(!fTypeSet.contains('Step Plan Approval (SP)')){
                queryString1 = queryString1 + 'Form_Type__c IN :formTypeSetInsideMethod AND ';
            }else{
                String queryStr='';
                Integer formCount=1;     
                for(String formtype : fTypeSet){
                    if(formCount == 1){
                        queryStr += '(';
                    }
                    if(formtype == 'Step Plan Approval (SP)'){
                        queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_Id__c=null) OR ';
                    }else if(formtype != 'Step Plan Approval (SP)'){
                        queryStr += '(Form_Type__c=\''+formtype+'\') OR ';
                    } 
                    if(formCount==fTypeSet.size()){
                        queryStr = queryStr.removeEnd('OR ');
                        queryStr+=') ';
                    } 
                    formCount++;    
                }
                if(queryStr!=null && queryStr!=''){ 
                    queryStr += 'AND ';
                    queryString1 += queryStr;
                }    

            }
        }

        dateOptionOpted = filterObj.CreationDateOptions__c;
         dateOptionTypeOpted = filterObj.CreationDateOptions__c;    

        if(!viewExiting){
            if(dateOptionTypeOpted != 'daterange'){
                varafterCreatedDate = null;
                if(dateOptionOpted == '1day'){
                    varafterCreatedDate = system.today().addDays(-1);
                }
                else if(dateOptionOpted == '1week'){
                    varafterCreatedDate = system.today().addDays(-7);
                    
                }
                else if(dateOptionOpted == '2weeks'){
                    varafterCreatedDate = system.today().addDays(-14);
                }
                else if(dateOptionOpted == '1month'){
                    varafterCreatedDate = system.today().addMonths(-1);
                }
                else if(dateOptionOpted == '6months'){
                    varafterCreatedDate = system.today().addMonths(-6);
                }
                else if(dateOptionOpted == '1year'){
                    varafterCreatedDate = system.today().addYears(-1);
                }
                
                
                varToCreatedDate = system.today();
                varToCreatedDate = varToCreatedDate.addDays(1);
                if(varafterCreatedDate!=null && dateOptionTypeOpted != 'alldates'){  
                    queryString1 = queryString1 + ' CreatedDate >= :varafterCreatedDate AND CreatedDate <= :varToCreatedDate AND ';
                 }   
            }
            else if(dateOptionTypeOpted == 'daterange'){
                if(filterObj.Created_Date_From__c != null){            
                    varFromCreatedDate = filterObj.Created_Date_From__c;
                    queryString1 = queryString1 + 'CreatedDate >= :varFromCreatedDate AND ';
                }
                if(filterObj.Created_Date_To__c != null){            
                    varToCreatedDate = filterObj.Created_Date_To__c;
                    
                    varToCreatedDate = varToCreatedDate.addDays(1);
                    queryString1 = queryString1 + 'CreatedDate <= :varToCreatedDate AND ';

                }
                
                
                
            }
        }
        else{
            if(filterObj.Created_Date_From__c != null){            
                varFromCreatedDate = filterObj.Created_Date_From__c;
                queryString1 = queryString1 + 'CreatedDate >= :varFromCreatedDate AND ';
            }
            if(filterObj.Created_Date_To__c != null){            
                varToCreatedDate = filterObj.Created_Date_To__c;
                
                varToCreatedDate = varToCreatedDate.addDays(1);
                queryString1 = queryString1 + 'CreatedDate <= :varToCreatedDate AND ';
            }   
        }
         
        if(!viewExiting){
            
            if(modifyDateOptTypeOpted != 'daterange') {
               
                varafterModifiedDate = null;
                if(modifydateOptionOpted == '1day'){
                    varafterModifiedDate = system.today().addDays(-1);
                }
                else if(modifydateOptionOpted == '1week'){
                    varafterModifiedDate = system.today().addDays(-7);
                }
                else if(modifydateOptionOpted == '2weeks'){
                    varafterModifiedDate = system.today().addDays(-14);
                }
                else if(modifydateOptionOpted == '1month'){
                    varafterModifiedDate = system.today().addMonths(-1);
                }
                else if(modifydateOptionOpted == '6months'){
                    varafterModifiedDate = system.today().addMonths(-6);
                }
                else if(modifydateOptionOpted == '1year'){
                    varafterModifiedDate = system.today().addYears(-1);
                }
                if(varafterModifiedDate!=null && modifyDateOptTypeOpted != 'alldates'){
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        queryString1 = queryString1 + 'LastModifiedDate >= :varafterModifiedDate AND ';
                    }else{

                        String queryStr='';
                        Integer formCount=1;     
                        for(String formtype : fTypeSet){
                            if(formCount == 1){
                                queryStr += '(';

                            }
                            if(formtype == 'Step Plan Approval (SP)' ){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate >=:varafterModifiedDate) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate >= :varafterModifiedDate))) OR ';
                            }else if(formtype != 'Step Plan Approval (SP)'){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and LastModifiedDate >= :varafterModifiedDate) OR ';

                            } 
                            if(formCount==fTypeSet.size()){
                                queryStr = queryStr.removeEnd('OR ');
                                queryStr+=') ';



                            } 
                            formCount++;    
                        }
                        if(queryStr!=null && queryStr!=''){ 
                            queryStr += 'AND ';
                            queryString1 += queryStr;


                        }    
                    } 
                }
            }
            //20-7-2017 START Anirban Roy- Modified the Step Plan search logic
            else if (modifyDateOptTypeOpted == 'daterange'){
                if(filterObj.Last_Modified_From__c != null){
                    varFromModifiedDate = filterObj.Last_Modified_From__c;

                    //queryString1 = queryString1 + 'LastModifiedDate >= :varFromModifiedDate AND ';
                    
                    //===============================================================//
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        queryString1 = queryString1 + 'LastModifiedDate >= :varFromModifiedDate AND ';
                    }else{
                        String queryStr='';
                        Integer formCount=1;     
                        for(String formtype : fTypeSet){
                            if(formCount == 1){
                                queryStr += '(';

                            }
                            if(formtype == 'Step Plan Approval (SP)' ){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate >=:varFromModifiedDate) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate >= :varFromModifiedDate))) OR ';
                            }else if(formtype != 'Step Plan Approval (SP)'){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and LastModifiedDate >= :varFromModifiedDate) OR ';

                            } 
                            if(formCount==fTypeSet.size()){
                                queryStr = queryStr.removeEnd('OR ');
                                queryStr+=') ';



                            } 
                            formCount++;    
                        }
                        if(queryStr!=null && queryStr!=''){ 
                            queryStr += 'AND ';
                            queryString1 += queryStr;


                        }    
                    }                       
                }

                if(filterObj.Last_Modified_To__c != null){
                    varToModifiedDate = filterObj.Last_Modified_To__c;
                    varToModifiedDate = varToModifiedDate.addDays(1);
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        queryString1 = queryString1 + 'LastModifiedDate <= :varToModifiedDate AND ';
                    }else{
                        String queryStr='';
                        Integer formCount=1;     
                        for(String formtype : fTypeSet){
                            if(formCount == 1){
                                queryStr += '(';

                            }
                            if(formtype == 'Step Plan Approval (SP)' ){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate <=:varToModifiedDate) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate <= :varToModifiedDate))) OR ';
                            }else if(formtype != 'Step Plan Approval (SP)'){
                                queryStr += '(Form_Type__c = \''+formtype+'\' and LastModifiedDate <= :varToModifiedDate) OR ';

                            } 
                            if(formCount==fTypeSet.size()){
                                queryStr = queryStr.removeEnd('OR ');
                                queryStr+=') ';



                            } 
                            formCount++;    
                        }
                        if(queryStr!=null && queryStr!=''){ 
                            queryStr += 'AND ';
                            queryString1 += queryStr;


                        }    
                    }                       
                   //20-7-2017 END Anirban Roy- Modified the Step Plan search logic         
                }
            }
        }
        else{
            if(filterObj.Last_Modified_From__c != null){
                varFromModifiedDate = filterObj.Last_Modified_From__c;
                queryString1 = queryString1 + 'LastModifiedDate >= :varFromModifiedDate AND ';
            }
            if(filterObj.Last_Modified_To__c != null){
                varToModifiedDate = filterObj.Last_Modified_To__c;
                varToModifiedDate = varToModifiedDate.addDays(1);
                queryString1 = queryString1 + 'LastModifiedDate <= :varToModifiedDate AND ';
            }     
        }
        
        for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){
            if(selectedField.contains(addFilters.Field_API_Name__c) && renderingMap.get(addFilters.Field_API_Name__c)){
                if(selectedField.contains('Technology__c') && renderingMap.get('Technology__c')){
                    if(filterObj.Technology__c != null && filterObj.Technology__c != '' && filterObj.Technology__c != 'All'){
                        string tempTech = '';
                        for(string s: filterObj.Technology__c.split(';')){
                            tempTech = tempTech + '\''+ s + '\'' + ',';
                        }
                        tempTech = tempTech.substring(0,tempTech.length()-1);
                        queryString1 = queryString1 + ' Technology__c ' + ' IN (' + tempTech + ') AND ';
                    }else if(filterObj.Technology__c == null || filterObj.Technology__c == '' || filterObj.Technology__c == 'All'){                   
                        queryString1 = queryString1 + ' Technology__c!=null AND Technology__c!=\'--None--\' AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Form_State__c'  && renderingMap.get('Form_State__c')){
                    if(filterObj.Form_State__c != null && filterObj.Form_State__c != '' && filterObj.Form_State__c != 'All'){
                        string tempFS = '';
                        for(string s: filterObj.Form_State__c.split(';')){
                            tempFS = tempFS + '\''+ s + '\'' + ',';
                        }
                        tempFS = tempFS.substring(0,tempFS.length()-1);
                        // Code added for Issue 378 by Ram Rai for Search Step Plan.
                        if(fTypeSet.size()>0){
                            if(!fTypeSet.contains('Step Plan Approval (SP)')){
                                queryString1 = queryString1 + ' State_of_the_Form__c ' + ' IN (' + tempFS + ') AND ';

                            }else{
                              String queryStr='';
                              Integer formCount=1;     

                            
                                for(String formtype : fTypeSet){
                                    if(formCount == 1){


                                          queryStr += '(';
                                      }
                                    if(formtype == 'Step Plan Approval (SP)'){
                                        queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and State_of_the_Form__c IN (' + tempFS + '))  OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.State_of_the_Form__c IN (' + tempFS + ')))) OR ';
                                    }else if(formtype != 'Step Plan Approval (SP)'){
                                         queryStr += '(Form_Type__c = \''+formtype+'\' and State_of_the_Form__c ' + ' IN (' + tempFS + ')) OR ';

                                    } 
                                    if(formCount==fTypeSet.size()){
                                        queryStr = queryStr.removeEnd('OR ');
                                        queryStr+=') ';



                                    } 
                                    formCount++;    
                                }
                                if(queryStr!=null && queryStr!=''){ 
                                    queryStr += 'AND ';
                                    queryString1 += queryStr;




                                }    
                            }
                        }
                    }else if(filterObj.Form_State__c == null || filterObj.Form_State__c == '' || filterObj.Form_State__c == 'All'){
                        queryString1 = queryString1 + ' State_of_the_Form__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Chip_Interconnect__c'){
                    if(filterObj.Chip_Interconnect__c != null && filterObj.Chip_Interconnect__c != '' && filterObj.Chip_Interconnect__c != 'All'){
                        string tempCI = '';
                        for(string s: filterObj.Chip_Interconnect__c.split(';')){
                            tempCI = tempCI + '\''+ s + '\'' + ',';
                        }
                        tempCI = tempCI.substring(0,tempCI.length()-1);
                        queryString1 = queryString1 + addFilters.Field_API_Name__c + ' IN (' + tempCI + ') AND ';
                    }else if(filterObj.Chip_Interconnect__c == null || filterObj.Chip_Interconnect__c == '' || filterObj.Chip_Interconnect__c == 'All'){
                        queryString1 = queryString1 + addFilters.Field_API_Name__c + '!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Design_Submission_Type__c'){
                    if(filterObj.Design_Submission_Type__c != null && filterObj.Design_Submission_Type__c != '' && filterObj.Design_Submission_Type__c != 'All'){
                        string tempDST = '';
                        string tempValue = '';
                        for(string s: filterObj.Design_Submission_Type__c.split(';')){
                            if(s.equalsIgnoreCase('Single Chip (one GDS)')){
                                tempValue = 'Single Chip (one GDS)';
                            }else if(s.equalsIgnoreCase('Multi-Chiplet Design')){
                                tempValue = 'Multi-Chiplet Design (one GDS, single Topcell)';
                            }else if(s.equalsIgnoreCase('Multi-Design Reticle')){
                                tempValue = 'Multi-Design Reticle (>1 Topcell)';
                            }
                            tempDST = tempDST + '\''+ tempValue + '\'' + ',';
                        }
                        tempDST = tempDST.substring(0,tempDST.length()-1);
                        queryString1 = queryString1 + ' DesignSubmission__c ' + ' IN (' + tempDST + ') AND ';
                    }else if(filterObj.Design_Submission_Type__c == null || filterObj.Design_Submission_Type__c == '' || filterObj.Design_Submission_Type__c == 'All'){
                        queryString1 = queryString1 + ' DesignSubmission__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Package_Requirement__c'){
                    if(filterObj.Package_Requirement__c != null && filterObj.Package_Requirement__c != '' && filterObj.Package_Requirement__c != 'All'){
                        string tempPR = '';
                        for(string s: filterObj.Package_Requirement__c.split(';')){
                            tempPR = tempPR + '\''+ s + '\'' + ',';
                        }
                        tempPR = tempPR.substring(0,tempPR.length()-1);
                        queryString1 = queryString1 + ' PackageRequirement__c ' + ' IN (' + tempPR + ') AND ';
                    }else if(filterObj.Package_Requirement__c == null || filterObj.Package_Requirement__c == '' || filterObj.Package_Requirement__c == 'All'){
                        queryString1 = queryString1 + ' PackageRequirement__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Package_Type__c'){
                    if(filterObj.Package_Type__c != null && filterObj.Package_Type__c != '' && filterObj.Package_Type__c != 'All'){
                        string tempPT = '';
                        for(string s: filterObj.Package_Type__c.split(';')){
                            tempPT = tempPT + '\''+ s + '\'' + ',';
                        }
                        tempPT = tempPT.substring(0,tempPT.length()-1);
                        queryString1 = queryString1 + ' PackageType__c ' + ' IN (' + tempPT + ') AND ';
                    }else if(filterObj.Package_Type__c == null || filterObj.Package_Type__c == '' || filterObj.Package_Type__c == 'All'){
                        queryString1 = queryString1 + ' PackageType__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Packaging_Services__c'){
                    if(filterObj.Packaging_Services__c != null && filterObj.Packaging_Services__c != '' && filterObj.Packaging_Services__c != 'All'){
                        string tempPS = '';
                        for(string s: filterObj.Packaging_Services__c.split(';')){
                            tempPS = tempPS + '\''+ s + '\'' + ',';
                        }
                        tempPS = tempPS.substring(0,tempPS.length()-1);
                        queryString1 = queryString1 + addFilters.Field_API_Name__c + ' IN (' + tempPS + ') AND ';
                    }else if(filterObj.Packaging_Services__c == null || filterObj.Packaging_Services__c == '' || filterObj.Packaging_Services__c == 'All'){
                        queryString1 = queryString1 + addFilters.Field_API_Name__c+ '!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Product_Name__c' && !prodNameRightValues.isEmpty()){                    
                    
                    if(prodNameRightValues.contains('All')){
                        for(String s : prodNameLeftValues){
                            prodNameSet.add(s);
                        }           
                    }else{
                        prodNameSet.clear();
                        for(String s : prodNameRightValues){
                            prodNameSet.add(s);
                        }   
                    }
                    queryString1 = queryString1 + 'ProductName__c IN :prodNameSet AND ';
                }
                if(addFilters.Field_API_Name__c == 'Product_Revision__c' && !prodRevRightValues.isEmpty()){
                    
                    if(prodRevRightValues.contains('All')){
                        for(String s : prodRevLeftValues){
                            prodRevSet.add(s);
                        }           
                    }else{
                        prodRevSet.clear();
                        for(String s : prodRevRightValues){
                            prodRevSet.add(s);
                        }   
                    }
                    queryString1 = queryString1 + 'ProductRevision__c IN :prodRevSet AND ';
                }
                if(addFilters.Field_API_Name__c == 'Release_Process__c'){
                    if(filterObj.Release_Process__c != null && filterObj.Release_Process__c != '' && filterObj.Release_Process__c != 'All'){
                        string tempRP = '';
                        for(string s: filterObj.Release_Process__c.split(';')){
                            tempRP = tempRP + '\''+ s + '\'' + ',';
                        }
                        tempRP = tempRP.substring(0,tempRP.length()-1);
                        queryString1 = queryString1 + ' ReleaseProcessFlow__c ' + ' IN (' + tempRP + ') AND ';
                    }else if(filterObj.Release_Process__c == null || filterObj.Release_Process__c == '' || filterObj.Release_Process__c == 'All'){
                        queryString1 = queryString1 + ' ReleaseProcessFlow__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'PO_Submission__c'){
                    if(filterObj.PO_Submission__c != null && filterObj.PO_Submission__c != '' && filterObj.PO_Submission__c != 'All'){
                        string tempPO = '';
                        for(string s: filterObj.PO_Submission__c.split(';')){
                            tempPO = tempPO + '\''+ s + '\'' + ',';
                        }
                        tempPO = tempPO.substring(0,tempPO.length()-1);
                        queryString1 = queryString1 + ' PurchaseOrder__c ' + ' IN (' + tempPO + ') AND ';
                    }else if(filterObj.PO_Submission__c == null || filterObj.PO_Submission__c == '' || filterObj.PO_Submission__c == 'All'){
                        queryString1 = queryString1 + ' PurchaseOrder__c!=null AND '; 
                    }
                }
                if(addFilters.Field_API_Name__c == 'Submission_Type__c'){
                    if(filterObj.Submission_Type__c != null && filterObj.Submission_Type__c != '' && filterObj.Submission_Type__c != 'All'){
                        string tempST = '';
                        string tempValue = '';
                        for(string s: filterObj.Submission_Type__c.split(';')){
                            if(s.equalsIgnoreCase('Final Submission')){
                                tempValue = 'Final Submission';
                            }else if(s.equalsIgnoreCase('Prelim - Checking Only')){
                                tempValue = 'Preliminary - Checking Only';
                            }else if(s.equalsIgnoreCase('Prelim - Checking and Design Services')){
                                tempValue = 'Preliminary - Checking and Design Services';
                            }else if(s.equalsIgnoreCase('Prelim - Design Services only')){
                                tempValue = 'Preliminary - Design Services only';
                            }else if(s.equalsIgnoreCase('Prelim - Features Extraction Report')){
                                tempValue = 'Preliminary - Features Extraction Report';
                            }
                            tempST = tempST + '\''+ tempValue + '\'' + ',';
                        }
                        tempST = tempST.substring(0,tempST.length()-1);
                        queryString1 = queryString1 + ' SubmissionType__c ' + ' IN (' + tempST + ') AND ';
                    }else if(filterObj.Submission_Type__c == null || filterObj.Submission_Type__c == '' || filterObj.Submission_Type__c == 'All'){
                        queryString1 = queryString1 + ' SubmissionType__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Step_Plan_Input_Method__c'){
                    if(filterObj.Step_Plan_Input_Method__c != null && filterObj.Step_Plan_Input_Method__c != '' && filterObj.Step_Plan_Input_Method__c != 'All'){
                        string tempSPIM = '';
                        string tempValue = '';
                        for(string s: filterObj.Step_Plan_Input_Method__c.split(';')){
                            if(s.equalsIgnoreCase('Std Process: via FMS questions')){
                                tempValue = 'Standard Process: Inputs via Step Plan Design FMS questions';
                            }else if(s.equalsIgnoreCase('Std Process: via FMS Ques & attachment')){
                                tempValue = 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment';
                            }else if(s.equalsIgnoreCase('Adv Process: via XML file attachment')){
                                tempValue = 'Advanced Process: Inputs via XML file attachment';
                            }
                            tempSPIM = tempSPIM + '\''+ tempValue + '\'' + ',';
                        }
                        tempSPIM = tempSPIM.substring(0,tempSPIM.length()-1);
                        queryString1 = queryString1 + ' InputMethod__c ' + ' IN (' + tempSPIM + ') AND ';
                    }else if(filterObj.Step_Plan_Input_Method__c == null || filterObj.Step_Plan_Input_Method__c == '' || filterObj.Step_Plan_Input_Method__c == 'All'){
                        queryString1 = queryString1 + ' InputMethod__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Tapeout_Date_Projection__c'){
                    if(filterObj.Tapeout_Date_Projection__c != null){
                        varProjectionDate = filterObj.Tapeout_Date_Projection__c;
                        queryString1 = queryString1 + 'ProjectedTapeout__c = :varProjectionDate AND ';
                    }else if(filterObj.Tapeout_Date_Projection__c == null){
                        queryString1 = queryString1 + 'ProjectedTapeout__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Test_Levels_Desired__c'){
                    if(filterObj.Test_Levels_Desired__c != null && filterObj.Test_Levels_Desired__c != '' && filterObj.Test_Levels_Desired__c != 'All'){
                        string tempTLD = '';
                        for(string s: filterObj.Test_Levels_Desired__c.split(';')){
                            tempTLD = tempTLD + '\''+ s + '\'' + ',';
                        }
                        tempTLD = tempTLD.substring(0,tempTLD.length()-1);
                        queryString1 = queryString1 + ' TestLevels__c ' + ' IN (' + tempTLD + ') AND ';
                    }else if(filterObj.Test_Levels_Desired__c == null || filterObj.Test_Levels_Desired__c == '' || filterObj.Test_Levels_Desired__c == 'All'){
                        queryString1 = queryString1 + ' TestLevels__c!=null AND ';
                    }
                }
                if(addFilters.Field_API_Name__c == 'Test_Services__c'){
                    if(filterObj.Test_Services__c != null && filterObj.Test_Services__c != '' && filterObj.Test_Services__c != 'All'){
                        string tempTS = '';
                        for(string s: filterObj.Test_Services__c.split(';')){
                            tempTS = tempTS + '\''+ s + '\'' + ',';
                        }
                        tempTS = tempTS.substring(0,tempTS.length()-1);
                        queryString1 = queryString1 + ' TestServices__c ' + ' IN (' + tempTS + ') AND ';
                    }else if(filterObj.Test_Services__c == null || filterObj.Test_Services__c == '' || filterObj.Test_Services__c == 'All'){
                        queryString1 = queryString1 + ' TestServices__c!=null AND ';
                    }
                }              
            }
        }  
        queryString1 = queryString1.removeEnd('AND ');
        
        return queryString1;
    }
    
    public List<Form_Management_System__c> getIntermediateSearch(){
        map<string,string> mpAccounts = new map<string,string>();
        for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes'  AND RecordTypeId IN :accountRecordTypes]){        
          mpAccounts.put(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )),a.SAP_Account_Number__c == NULL ? a.Short_Name__c : a.SAP_Account_Number__c);
        }
        Set<String> customerIntSet = new Set<String>();
        Set<String> formTypeIntSet = new Set<String>();
        String queryStringInt = 'SELECT id,ProductName__c,ProductRevision__c FROM Form_Management_System__c WHERE ';    
        if(!customerRightValues.isEmpty()){
            if(customerRightValues.contains('All')){
                customerLeftValues = leftCustomerValues();
                for(String s : customerLeftValues){
                  if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
                    s = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
                  }
                  customerIntSet.add(s);
                }            
            }else{
                customerIntSet.clear();
                for(String s : customerRightValues){
                    if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
                      s = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
                    }
                    customerIntSet.add(s);
                }   
            }
        }   
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
        if(!formTypeRightValues.isEmpty()){
            if(formTypeRightValues.contains('All')){                
                formTypeIntSet = rtMapByName.keySet();
                if(formTypeIntSet.contains('Master')){
                    formTypeIntSet.remove('Master');
                }
            }else{
                formTypeIntSet = new Set<String>();
                for(String s : formTypeRightValues){
                    formTypeIntSet.add(s);
                } 
            }
        }
        
        if(customerIntSet.size()>0){            
            queryStringInt = queryStringInt + 'Customer__c IN :customerIntSet AND ';
        }
    // Code added for Issue 378 by Ram Rai for Search Step Plan.
        if(formTypeIntSet.size()>0){
            if(!formTypeIntSet.contains('Step Plan Approval (SP)')){
                queryStringInt = queryStringInt + 'Form_Type__c IN :formTypeIntSet AND ';
            }else{
                String queryStr='';
                Integer formCount=1;     
                for(String formtype : formTypeIntSet){
                    if(formCount == 1){
                        queryStr += '(';
                    }
                    if(formtype == 'Step Plan Approval (SP)'){
                        queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_Id__c=null) OR ';
                    }else if(formtype != 'Step Plan Approval (SP)'){
                        queryStr += '(Form_Type__c=\''+formtype+'\') OR ';
                    } 
                    if(formCount==formTypeIntSet.size()){
                        queryStr = queryStr.removeEnd('OR ');
                        queryStr+=') ';
                    } 
                    formCount++;    
                }
                if(queryStr!=null && queryStr!=''){ 
                    queryStr += 'AND ';
                    queryStringInt += queryStr;
                }    



            }        
        }
        Boolean viewExiting=false;
        
        if(!viewExiting){
            if(dateOptionTypeOpted != 'daterange'){
                varafterCreatedDate = null;
                if(dateOptionOpted == '1day'){
                    varafterCreatedDate = system.today().addDays(-1);
                }
                else if(dateOptionOpted == '1week'){
                    varafterCreatedDate = system.today().addDays(-7);
                }
                else if(dateOptionOpted == '2weeks'){
                    varafterCreatedDate = system.today().addDays(-14);
                }
                else if(dateOptionOpted == '1month'){
                    varafterCreatedDate = system.today().addMonths(-1);
                }
                else if(dateOptionOpted == '6months'){
                    varafterCreatedDate = system.today().addMonths(-6);
                }
                else if(dateOptionOpted == '1year'){
                    varafterCreatedDate = system.today().addYears(-1);
                }
                
                if(varafterCreatedDate!=null && dateOptionTypeOpted != 'alldates'){  
                    queryStringInt = queryStringInt + ' CreatedDate >= :varafterCreatedDate AND ';
                 }   
            }
            else if(dateOptionTypeOpted == 'daterange'){
                if(fmsSearchFilterObj.Created_Date_From__c != null){            
                    varFromCreatedDate = fmsSearchFilterObj.Created_Date_From__c;
                    queryStringInt = queryStringInt + 'CreatedDate >= :varFromCreatedDate AND ';
                }
                if(fmsSearchFilterObj.Created_Date_To__c != null){            
                    varToCreatedDate = fmsSearchFilterObj.Created_Date_To__c;
                    
                    varToCreatedDate = varToCreatedDate.addDays(1);
                    queryStringInt = queryStringInt + 'CreatedDate <= :varToCreatedDate AND ';
                }
            }
        }       
        
        
        if(!viewExiting){
            if(modifyDateOptTypeOpted != 'daterange') {
               
                varafterModifiedDate = null;
                
                if(modifydateOptionOpted == '1day'){
                    varafterModifiedDate = system.today().addDays(-1);
                }
                else if(modifydateOptionOpted == '1week'){
                    varafterModifiedDate = system.today().addDays(-7);
                }
                else if(modifydateOptionOpted == '2weeks'){
                    varafterModifiedDate = system.today().addDays(-14);
                }
                else if(modifydateOptionOpted == '1month'){
                    varafterModifiedDate = system.today().addMonths(-1);
                }
                else if(modifydateOptionOpted == '6months'){
                    varafterModifiedDate = system.today().addMonths(-6);
                }
                else if(modifydateOptionOpted == '1year'){
                    varafterModifiedDate = system.today().addYears(-1);
                }
                if(varafterModifiedDate!=null && modifyDateOptTypeOpted != 'alldates'){
                    if(formTypeIntSet.size()>0){
                        if(!formTypeIntSet.contains('Step Plan Approval (SP)')){
                             queryStringInt = queryStringInt + 'LastModifiedDate >= :varFromModifiedDate AND ';

                        }else{
                            String queryStr='';
                            Integer formCount=1;     
                            for(String formtype : formTypeIntSet){
                                if(formCount == 1){
                                    queryStr += '(';

                                }
                                if(formtype == 'Step Plan Approval (SP)'){
                                    queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate >=:varafterModifiedDate) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate >= :varafterModifiedDate))) OR ';
                                }else if(formtype != 'Step Plan Approval (SP)'){
                                    queryStr += '(Form_Type__c=\''+formtype+'\' and LastModifiedDate >= :varFromModifiedDate) OR ';

                                } 
                                if(formCount==formTypeIntSet.size()){
                                    queryStr = queryStr.removeEnd('OR ');
                                    queryStr+=') ';



                                } 
                                formCount++;    
                            }
                            if(queryStr!=null && queryStr!=''){ 
                                queryStr += 'AND ';
                                queryStringInt += queryStr;



                            }    
                        }
                    }                   
                }          
            }
            else if (modifyDateOptTypeOpted == 'daterange'){
                if(fmsSearchFilterObj.Last_Modified_From__c != null){
                    varFromModifiedDate = fmsSearchFilterObj.Last_Modified_From__c;                    

                }
                if(fmsSearchFilterObj.Last_Modified_To__c != null){
                    varToModifiedDate = fmsSearchFilterObj.Last_Modified_To__c;
                    
                    varToModifiedDate = varToModifiedDate.addDays(1);

                    if(formTypeIntSet.size()>0){
                        if(!formTypeIntSet.contains('Step Plan Approval (SP)')){
                             queryStringInt = queryStringInt + 'LastModifiedDate >= :varFromModifiedDate AND ';

                        }else{
                            String queryStr='';
                            Integer formCount=1;     
                            for(String formtype : formTypeIntSet){
                                if(formCount == 1){
                                    queryStr += '(';

                                }
                                if(formtype == 'Step Plan Approval (SP)'){
                                    queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate >=:varafterModifiedDate) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate >= :varafterModifiedDate))) OR ';
                                }else if(formtype != 'Step Plan Approval (SP)'){
                                    queryStr += '(Form_Type__c=\''+formtype+'\' and LastModifiedDate >= :varFromModifiedDate) OR ';

                                } 
                                if(formCount==formTypeIntSet.size()){
                                    queryStr = queryStr.removeEnd('OR ');
                                    queryStr+=') ';



                                } 
                                formCount++;    
                            }
                            if(queryStr!=null && queryStr!=''){ 
                                queryStr += 'AND ';
                                queryStringInt += queryStr;





                            }    
                        }
                    }
                }
            }
        }

        queryStringInt = queryStringInt.removeEnd('AND ');

        List<Form_Management_System__c> fmsIntList = (List<Form_Management_System__c>)Database.query(queryStringInt);
        return fmsIntList;
    }
    
    
    public PageReference saveNewSearch(){ 
        
        map<string,String> mpAccounts = new map<string,String>();
        for(Account a : [SELECT id,SAP_Account_Number__c, Name, Fab_9_10__c,Short_Name__c FROM Account WHERE Fab_9_10__c = 'Yes'  AND RecordTypeId IN :accountRecordTypes]){        
          mpAccounts.put(a.Name + (a.SAP_Account_Number__c == NULL ? (a.Short_Name__c == NULL ? '' : ' ('+a.Short_Name__c + ')' ) : ( ' ('+a.SAP_Account_Number__c + ')' )),a.SAP_Account_Number__c == NULL ? a.Short_Name__c : a.SAP_Account_Number__c);
        }
        
        Set<String> saveSearchSet = new Set<String>(selAddSearchFilter);
        fmsSearchFilterObj.Add_Filter_Value__c = '';
        for(String s : selAddSearchFilter){
            fmsSearchFilterObj.Add_Filter_Value__c = fmsSearchFilterObj.Add_Filter_Value__c + s + ';';
                        //27-07-2017 Anirban Roy : Modified for Product Name and Product Revision filters - START
            if(s=='Product_Name__c'){
                fmsSearchFilterObj.Product_Name__c = '';
                for(String prodNameVal : prodNameRightValues){
                    fmsSearchFilterObj.Product_Name__c = fmsSearchFilterObj.Product_Name__c + prodNameVal + ';';
                }
            }else if(s=='Product_Revision__c'){
                fmsSearchFilterObj.Product_Revision__c = '';
                for(String prodRevVal : prodRevRightValues){
                    fmsSearchFilterObj.Product_Revision__c = fmsSearchFilterObj.Product_Revision__c + prodRevVal +';';
                }
            }
            //27-07-2017 Anirban Roy : Modified for Product Name and Product Revision filters - END
            
        }
        fmsSearchFilterObj.Customer__c = '';
        for(String s : customerRightValues){
             //String temp = s;
             if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
               s = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
             }
            fmsSearchFilterObj.Customer__c = fmsSearchFilterObj.Customer__c + s + ';';
        }
        if(!customerRightValues.isEmpty() && customerRightValues.contains('All')){
            customerLeftValues = leftCustomerValues();
            for(String s : customerLeftValues){
                if(mpAccounts.containsKey(s) && mpAccounts.get(s) != NULL && s.contains(' ('+mpAccounts.get(s)+')')) {
                  s = s.substring(0,s.lastindexOf(' ('+mpAccounts.get(s)+')'));
                }
                fmsSearchFilterObj.Customer_Names__c = (fmsSearchFilterObj.Customer_Names__c==null?'':fmsSearchFilterObj.Customer_Names__c) + s + ';';
            }    
        }
        fmsSearchFilterObj.Form_Type__c = '';
        for(String s : formTypeRightValues){
            fmsSearchFilterObj.Form_Type__c = fmsSearchFilterObj.Form_Type__c + s +';';
        }
        
        if(dateOptionTypeOpted == 'alldates' && dateOptionTypeOpted != editCreationDateOptnOptd){  
                fmsSearchFilterObj.CreationDateOptions__c = 'alldates';
                fmsSearchFilterObj.Created_Date_From__c  = null;
                fmsSearchFilterObj.Created_Date_To__c = null;   
            }
            else if(dateOptionTypeOpted == 'daterange' && dateOptionTypeOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = 'daterange';  
            }
             else if(dateOptionOpted == '1day' && dateOptionOpted != editCreationDateOptnOptd){ 
                fmsSearchFilterObj.CreationDateOptions__c = '1day' ;
                fmsSearchFilterObj.Created_Date_From__c  = system.today().addDays(-1);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
    
            else if(dateOptionOpted == '1week' && dateOptionOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = '1week' ;
                fmsSearchFilterObj.Created_Date_From__c  = system.today().addDays(-7);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
            else if(dateOptionOpted == '2weeks' && dateOptionOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = '2weeks' ;
                fmsSearchFilterObj.Created_Date_From__c  =  system.today().addDays(-14);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
            else if(dateOptionOpted == '1month' && dateOptionOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = '1month' ;
                fmsSearchFilterObj.Created_Date_From__c  =  system.today().addMonths(-1);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
            else if(dateOptionOpted == '6months' && dateOptionOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = '6months' ;
                fmsSearchFilterObj.Created_Date_From__c  =  system.today().addMonths(-6);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
            else if(dateOptionOpted == '1year' && dateOptionOpted != editCreationDateOptnOptd){
                fmsSearchFilterObj.CreationDateOptions__c = '1year' ;
                fmsSearchFilterObj.Created_Date_From__c  =   system.today().addYears(-1);
                fmsSearchFilterObj.Created_Date_To__c = system.today();
            }
            
        
            if(modifyDateOptTypeOpted == 'alldates' && modifyDateOptTypeOpted!=editModifyDateOptnOptd){  
                fmsSearchFilterObj.ModifiedDateOptions__c = 'alldates';
                fmsSearchFilterObj.Last_Modified_From__c  = null;
                fmsSearchFilterObj.Last_Modified_To__c = null;   
            }
            else if(modifyDateOptTypeOpted == 'daterange' && modifyDateOptTypeOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = 'daterange';  
            }
             else if(modifydateOptionOpted == '1day' && modifydateOptionOpted!=editModifyDateOptnOptd){ 
                fmsSearchFilterObj.ModifiedDateOptions__c = '1day' ;
                fmsSearchFilterObj.Last_Modified_From__c  = system.today().addDays(-1);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }
    
            else if(modifydateOptionOpted == '1week' && modifydateOptionOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = '1week' ;
                fmsSearchFilterObj.Last_Modified_From__c  = system.today().addDays(-7);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }
            else if(modifydateOptionOpted == '2weeks' && modifydateOptionOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = '2weeks' ;
                fmsSearchFilterObj.Last_Modified_From__c  =  system.today().addDays(-14);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }
            else if(modifydateOptionOpted == '1month' && modifydateOptionOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = '1month' ;
                fmsSearchFilterObj.Last_Modified_From__c  =  system.today().addMonths(-1);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }
            else if(modifydateOptionOpted == '6months' && modifydateOptionOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = '6months' ;
                fmsSearchFilterObj.Last_Modified_From__c  =  system.today().addMonths(-6);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }
            else if(modifydateOptionOpted == '1year' && modifydateOptionOpted!=editModifyDateOptnOptd){
                fmsSearchFilterObj.ModifiedDateOptions__c = '1year' ;
                fmsSearchFilterObj.Last_Modified_From__c  =   system.today().addYears(-1);
                fmsSearchFilterObj.Last_Modified_To__c = system.today();
            }

        if(!saveNewRecordCheck){
            try{
                update fmsSearchFilterObj;
                Boolean fmsIsCreated = false;
                Boolean fmsIsUpdated = false;
                Boolean fmsIsDeleted = false;
                Boolean fmsIsStatusChange = false;
                Integer count = 0;
                List<FMS_Subscription__c> fmsSubList = new List<FMS_Subscription__c>();
                for(FMS_Subscription__c fmsSub : [SELECT Form_Deleted__c, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Id, UnSubscribed_Date__c  FROM FMS_Subscription__c WHERE Saved_Search_Id__c = : fmsSearchFilterObj.id and UnSubscribed_Date__c = null]){
                    if(count==0){
                        fmsIsCreated = fmsSub.Form_Inserted__c;
                        fmsIsUpdated = fmsSub.Form_Updated__c;
                        fmsIsDeleted = fmsSub.Form_Deleted__c;
                        fmsIsStatusChange = fmsSub.Form_Status_Change__c;
                        count++;
                    }
                    fmsSub.Form_Inserted__c = false;
                    fmsSub.Form_Updated__c = false;
                    fmsSub.Form_Deleted__c = false;
                    fmsSub.Form_Status_Change__c = false;
                    fmsSub.UnSubscribed_Date__c = system.today();
                    fmsSubList.add(fmsSub);
                }
                if(fmsSubList.size()>0){
                    update fmsSubList;
                    ApexPages.currentPage().getParameters().put('id',fmsSearchFilterObj.id);
                    ApexPages.currentPage().getParameters().put('tnx','sub');
                    FMSSubscribeSearchCtrl fmsSubCtrl = new FMSSubscribeSearchCtrl();
                    fmsSubCtrl.allEvents = (fmsIsCreated && fmsIsUpdated && fmsIsDeleted && fmsIsStatusChange)?true:false;
                    fmsSubCtrl.formCreated = fmsIsCreated;
                    fmsSubCtrl.formEdited = fmsIsUpdated;
                    fmsSubCtrl.formDeleted = fmsIsDeleted;
                    fmsSubCtrl.formStatusChange = fmsIsStatusChange;
                    fmsSubCtrl.submit();    
                }                            
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FormManagementMainClass.class.getName(), 'saveNewSearch()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }           
        }else
        {
            if(fmsSearchFilterObj.Name == null || fmsSearchFilterObj.Name == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Save Search Name: is a required field'));
                return null;
            }
            String ownId = String.valueOf(loggedInUser.Id);
            escapedNameString = String.escapeSingleQuotes(String.valueOf(fmsSearchFilterObj.Name));  
            String savedSearchQueryString1 = 'SELECT id, Name, OwnerId, Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c,'+
                                             ' Customer__c, Design_Submission_Type__c, Form_State__c, Form_Type__c, Last_Modified_From__c,'+
                                             ' Last_Modified_To__c,CreationDateOptions__c, ModifiedDateOptions__c, Package_Requirement__c,'+
                                             ' Package_Type__c, Packaging_Services__c, PO_Submission__c, Product_Name__c, Product_Revision__c,'+
                                             ' Release_Process__c, Step_Plan_Input_Method__c, Submission_Type__c, Tapeout_Date_Projection__c,'+
                                             ' Technology__c, Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c, CreatedDate, Customer_Names__c, '+
                                             ' LastModifiedDate FROM FMS_Search_Filter__c WHERE OwnerId = \''+ownId+'\' AND Name = \''+escapedNameString+'\'';
            ApexPages.StandardSetController setConSavedSearch1 = new ApexPages.StandardSetController(Database.getQueryLocator(savedSearchQueryString1));
            
            if(!((List<FMS_Search_Filter__c>)setConSavedSearch1.getRecords()).isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: The Name Should be unique.'));
                return null;
            }
            
            String savedSearchQueryString = 'SELECT id, Name, OwnerId, Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c, '+
                                            ' Customer__c, Design_Submission_Type__c, Form_State__c, Form_Type__c, Last_Modified_From__c,'+
                                            ' Last_Modified_To__c,CreationDateOptions__c, ModifiedDateOptions__c, Package_Requirement__c,'+
                                            ' Package_Type__c, Packaging_Services__c, PO_Submission__c, Product_Name__c, '+
                                            ' Product_Revision__c, Release_Process__c, Step_Plan_Input_Method__c, Submission_Type__c, '+
                                            ' Tapeout_Date_Projection__c, Technology__c, Test_Levels_Desired__c, Test_Services__c,Customer_Names__c, '+
                                            ' Add_Filter_Value__c, CreatedDate, LastModifiedDate FROM FMS_Search_Filter__c '+
                                            ' WHERE OwnerId = \''+ownId+'\' AND ';
            
            Integer count = 0;
            
            String option = '';
            Date fromDate = null;
            Date toDate = null;

            
            if(dateOptionTypeOpted != 'daterange'){
                if(dateOptionOpted == '1day'){
                    option = '1day' ;
                    fromDate = system.today().addDays(-1);
                    toDate = system.today().addDays(1);
                }else if(dateOptionOpted == '1week'){
                    option = '1week' ;
                    fromDate = system.today().addDays(-7);
                    toDate = system.today().addDays(1);
                }else if(dateOptionOpted == '2weeks'){
                    option = '2weeks' ;
                    fromDate =  system.today().addDays(-14);
                    toDate = system.today().addDays(1);
                }else if(dateOptionOpted == '1month'){
                    option = '1month' ;
                    fromDate =  system.today().addMonths(-1);
                    toDate = system.today().addDays(1);
                }else if(dateOptionOpted == '6months'){
                    option = '6months' ;
                    fromDate =  system.today().addMonths(-6);
                    toDate = system.today().addDays(1);
                }else if(dateOptionOpted == '1year'){
                    option = '1year' ;
                    fromDate = system.today().addYears(-1);
                    toDate = system.today().addDays(1);
                }else if(dateOptionTypeOpted == 'alldates'){
                    option = 'alldates';
                    fromDate = null;
                    toDate = null;   
                }
            }else if(dateOptionTypeOpted == 'daterange'){
                option = 'daterange';
                if(fmsSearchFilterObj.Created_Date_From__c != null){            
                    fromDate = fmsSearchFilterObj.Created_Date_From__c;
                }
                if(fmsSearchFilterObj.Created_Date_To__c != null){            
                    toDate = fmsSearchFilterObj.Created_Date_To__c;
                }
                 fmsSearchFilterObj.CreationDateOptions__c = option;  
            }
            if(option != ''){
                if(option != 'daterange'){
                    fmsSearchFilterObj.CreationDateOptions__c = option;
                    fmsSearchFilterObj.Created_Date_From__c  = fromDate;
                    fmsSearchFilterObj.Created_Date_To__c = toDate;   
                }
                savedSearchQueryString = savedSearchQueryString + 'CreationDateOptions__c =: option AND Created_Date_From__c =: fromDate AND Created_Date_To__c =: toDate AND ';
                count++;
            }
            String mOption = '';
            Date mFromDate = null;
            Date mToDate = null;
            
            if(modifyDateOptTypeOpted != 'daterange') {
               if(modifydateOptionOpted == '1day'){
                    mOption = '1day' ;
                    mFromDate  = system.today().addDays(-1);
                    mToDate = system.today().addDays(1);
                }
                else if(modifydateOptionOpted == '1week'){
                    mOption = '1week' ;
                    mFromDate = system.today().addDays(-7);
                    mToDate = system.today().addDays(1);
                }
                else if(modifydateOptionOpted == '2weeks'){
                    mOption = '2weeks' ;
                    mFromDate = system.today().addDays(-14);
                    mToDate = system.today().addDays(1);
                }
                else if(modifydateOptionOpted == '1month'){
                    mOption = '1month' ;
                    mFromDate = system.today().addMonths(-1);
                    mToDate = system.today().addDays(1);
                }
                else if(modifydateOptionOpted == '6months'){
                    mOption = '6months' ;
                    mFromDate = system.today().addMonths(-6);
                    mToDate = system.today().addDays(1);
                }
                else if(modifydateOptionOpted == '1year'){
                    mOption = '1year' ;
                    mFromDate = system.today().addYears(-1);
                    mToDate = system.today().addDays(1);
                }
                else if(modifyDateOptTypeOpted == 'alldates'){
                    mOption = 'alldates';
                    mFromDate = null;
                    mToDate = null; 
                }          
            }
            else if (modifyDateOptTypeOpted == 'daterange'){
                mOption = 'daterange';
                if(fmsSearchFilterObj.Last_Modified_From__c != null){
                    mFromDate = fmsSearchFilterObj.Last_Modified_From__c;
                }
                if(fmsSearchFilterObj.Last_Modified_To__c != null){
                    mToDate = fmsSearchFilterObj.Last_Modified_To__c;
                }
                fmsSearchFilterObj.ModifiedDateOptions__c = mOption;
            }
            if(mOption != ''){
                if(mOption != 'daterange'){
                    fmsSearchFilterObj.ModifiedDateOptions__c = mOption;
                    fmsSearchFilterObj.Last_Modified_From__c  = mFromDate;
                    fmsSearchFilterObj.Last_Modified_To__c = mToDate;   
                }
                savedSearchQueryString = savedSearchQueryString + 'ModifiedDateOptions__c =: option AND Last_Modified_From__c =: fromDate AND Last_Modified_To__c =: toDate AND ';
                count++;
            }
            
            for(FMS_Additional_Filters__c addFilters : FMS_Additional_Filters__c.getAll().values()){
                if(saveSearchSet.contains(addFilters.Field_API_Name__c) && renderingMap.get(addFilters.Field_API_Name__c)){
                    if(saveSearchSet.contains('Technology__c') && fmsSearchFilterObj.Technology__c != null && fmsSearchFilterObj.Technology__c != ''){
                        string tempTech = '';
                        for(string s: fmsSearchFilterObj.Technology__c.split(';')){
                            tempTech = tempTech + '\''+ s + '\'' + ',';
                        }
                        tempTech = tempTech.substring(0,tempTech.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Technology__c ' + ' IN (' + tempTech + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Form_State__c' && fmsSearchFilterObj.Form_State__c != null && fmsSearchFilterObj.Form_State__c != ''){
                        string tempFS = '';
                        for(string s: fmsSearchFilterObj.Form_State__c.split(';')){
                            tempFS = tempFS + '\''+ s + '\'' + ',';
                        }
                        tempFS = tempFS.substring(0,tempFS.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Form_State__c ' + ' IN (' + tempFS + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Chip_Interconnect__c' && fmsSearchFilterObj.Chip_Interconnect__c != null && fmsSearchFilterObj.Chip_Interconnect__c != ''){
                        string tempCI = '';
                        for(string s: fmsSearchFilterObj.Chip_Interconnect__c.split(';')){
                            tempCI = tempCI + '\''+ s + '\'' + ',';
                        }
                        tempCI = tempCI.substring(0,tempCI.length()-1);
                        savedSearchQueryString = savedSearchQueryString + addFilters.Field_API_Name__c + ' IN (' + tempCI + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Design_Submission_Type__c' && fmsSearchFilterObj.Design_Submission_Type__c != null && fmsSearchFilterObj.Design_Submission_Type__c != ''){
                        string tempDST = '';
                        for(string s: fmsSearchFilterObj.Design_Submission_Type__c.split(';')){
                            tempDST = tempDST + '\''+ s + '\'' + ',';
                        }
                        tempDST = tempDST.substring(0,tempDST.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Design_Submission_Type__c ' + ' IN (' + tempDST + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Package_Requirement__c' && fmsSearchFilterObj.Package_Requirement__c != null && fmsSearchFilterObj.Package_Requirement__c != ''){
                        string tempPR = '';
                        for(string s: fmsSearchFilterObj.Package_Requirement__c.split(';')){
                            tempPR = tempPR + '\''+ s + '\'' + ',';
                        }
                        tempPR = tempPR.substring(0,tempPR.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Package_Requirement__c ' + ' IN (' + tempPR + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Package_Type__c' && fmsSearchFilterObj.Package_Type__c != null && fmsSearchFilterObj.Package_Type__c != ''){
                        string tempPT = '';
                        for(string s: fmsSearchFilterObj.Package_Type__c.split(';')){
                            tempPT = tempPT + '\''+ s + '\'' + ',';
                        }
                        tempPT = tempPT.substring(0,tempPT.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Package_Type__c ' + ' IN (' + tempPT + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Packaging_Services__c' && fmsSearchFilterObj.Packaging_Services__c != null && fmsSearchFilterObj.Packaging_Services__c != ''){
                        string tempPS = '';
                        for(string s: fmsSearchFilterObj.Packaging_Services__c.split(';')){
                            tempPS = tempPS + '\''+ s + '\'' + ',';
                        }
                        tempPS = tempPS.substring(0,tempPS.length()-1);
                        savedSearchQueryString = savedSearchQueryString + addFilters.Field_API_Name__c + ' IN (' + tempPS + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Product_Name__c' && !prodNameRightValues.isEmpty()){                       
                        fmsSearchFilterObj.Product_Name__c = '';
                        for(String s : prodNameRightValues){
                            fmsSearchFilterObj.Product_Name__c = fmsSearchFilterObj.Product_Name__c + s + ';';
                        }
                    }
                    if(addFilters.Field_API_Name__c == 'Product_Revision__c' && !prodRevRightValues.isEmpty()){                   
                        fmsSearchFilterObj.Product_Revision__c = '';
                        for(String s : prodRevRightValues){
                            fmsSearchFilterObj.Product_Revision__c = fmsSearchFilterObj.Product_Revision__c + s +';';
                        }
                    }
                    if(addFilters.Field_API_Name__c == 'Release_Process__c' && fmsSearchFilterObj.Release_Process__c != null && fmsSearchFilterObj.Release_Process__c != ''){
                        string tempRP = '';
                        for(string s: fmsSearchFilterObj.Release_Process__c.split(';')){
                            tempRP = tempRP + '\''+ s + '\'' + ',';
                        }
                        tempRP = tempRP.substring(0,tempRP.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Release_Process__c ' + ' IN (' + tempRP + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'PO_Submission__c' && fmsSearchFilterObj.PO_Submission__c != null && fmsSearchFilterObj.PO_Submission__c != ''){
                        string tempPO = '';
                        for(string s: fmsSearchFilterObj.PO_Submission__c.split(';')){
                            tempPO = tempPO + '\''+ s + '\'' + ',';
                        }
                        tempPO = tempPO.substring(0,tempPO.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' PO_Submission__c ' + ' IN (' + tempPO + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Submission_Type__c' && fmsSearchFilterObj.Submission_Type__c != null && fmsSearchFilterObj.Submission_Type__c != ''){
                        string tempST = '';
                        for(string s: fmsSearchFilterObj.Submission_Type__c.split(';')){
                            tempST = tempST + '\''+ s + '\'' + ',';
                        }
                        tempST = tempST.substring(0,tempST.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Submission_Type__c ' + ' IN (' + tempST + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Step_Plan_Input_Method__c' && fmsSearchFilterObj.Step_Plan_Input_Method__c != null && fmsSearchFilterObj.Step_Plan_Input_Method__c != ''){
                        string tempSPIM = '';
                        for(string s: fmsSearchFilterObj.Step_Plan_Input_Method__c.split(';')){
                            tempSPIM = tempSPIM + '\''+ s + '\'' + ',';
                        }
                        tempSPIM = tempSPIM.substring(0,tempSPIM.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Step_Plan_Input_Method__c ' + ' IN (' + tempSPIM + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Tapeout_Date_Projection__c' && fmsSearchFilterObj.Tapeout_Date_Projection__c != null){
                        varProjectionDate = fmsSearchFilterObj.Tapeout_Date_Projection__c;
                        savedSearchQueryString = savedSearchQueryString + 'Tapeout_Date_Projection__c = :varProjectionDate AND ';
                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Test_Levels_Desired__c' && fmsSearchFilterObj.Test_Levels_Desired__c != null && fmsSearchFilterObj.Test_Levels_Desired__c != ''){
                        string tempTLD = '';
                        for(string s: fmsSearchFilterObj.Test_Levels_Desired__c.split(';')){
                            tempTLD = tempTLD + '\''+ s + '\'' + ',';
                        }
                        tempTLD = tempTLD.substring(0,tempTLD.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Test_Levels_Desired__c ' + ' IN (' + tempTLD + ') AND ';

                        count++;
                    }
                    if(addFilters.Field_API_Name__c == 'Test_Services__c' && fmsSearchFilterObj.Test_Services__c != null && fmsSearchFilterObj.Test_Services__c != ''){
                        string tempTS = '';
                        for(string s: fmsSearchFilterObj.Test_Services__c.split(';')){
                            tempTS = tempTS + '\''+ s + '\'' + ',';
                        }
                        tempTS = tempTS.substring(0,tempTS.length()-1);
                        savedSearchQueryString = savedSearchQueryString + ' Test_Services__c ' + ' IN (' + tempTS + ') AND ';

                        count++;
                    }
                }
            }
            if(savedSearchQueryString.endsWithIgnoreCase('AND '))
                savedSearchQueryString = savedSearchQueryString.removeEnd('AND ');
            
            List<FMS_Search_Filter__c> checkExistingRecForFMSFilter = Database.Query(savedSearchQueryString);
            List<FMS_Search_Filter__c> checkExistingRecForFMSFilter1 = new List<FMS_Search_Filter__c>();
            if(!checkExistingRecForFMSFilter.isEmpty()){
                for(FMS_Search_Filter__c fmsFilter : checkExistingRecForFMSFilter){
                    if(((fmsSearchFilterObj.Add_Filter_Value__c == null || fmsSearchFilterObj.Add_Filter_Value__c =='') && (fmsFilter.Add_Filter_Value__c == null || fmsFilter.Add_Filter_Value__c =='')) || fmsSearchFilterObj.Add_Filter_Value__c == fmsFilter.Add_Filter_Value__c){
                        if(fmsSearchFilterObj.Customer__c != null && fmsSearchFilterObj.Customer__c != '' && fmsFilter.Customer__c != null && fmsSearchFilterObj.Form_Type__c != null && fmsSearchFilterObj.Form_Type__c != '' && fmsFilter.Form_Type__c != null){
                            if(fmsFilter.Customer__c == fmsSearchFilterObj.Customer__c && fmsFilter.Form_Type__c == fmsSearchFilterObj.Form_Type__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }
                        else if(fmsSearchFilterObj.Customer__c != null && fmsSearchFilterObj.Customer__c != '' && fmsFilter.Customer__c != null){
                            if(fmsFilter.Customer__c == fmsSearchFilterObj.Customer__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }else if(fmsSearchFilterObj.Form_Type__c != null && fmsSearchFilterObj.Form_Type__c != '' && fmsFilter.Form_Type__c != null){
                            if(fmsFilter.Form_Type__c == fmsSearchFilterObj.Form_Type__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }else if(fmsSearchFilterObj.Product_Name__c != null && fmsSearchFilterObj.Product_Name__c != '' && fmsFilter.Product_Name__c != null && fmsSearchFilterObj.Product_Revision__c != null && fmsSearchFilterObj.Product_Revision__c != '' && fmsFilter.Product_Revision__c != null){
                            if(fmsFilter.Product_Name__c == fmsSearchFilterObj.Product_Name__c && fmsFilter.Product_Revision__c == fmsSearchFilterObj.Product_Revision__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }
                        else if(fmsSearchFilterObj.Product_Name__c != null && fmsSearchFilterObj.Product_Name__c != '' && fmsFilter.Product_Name__c != null){
                            if(fmsFilter.Product_Name__c == fmsSearchFilterObj.Product_Name__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }else if(fmsSearchFilterObj.Product_Revision__c != null && fmsSearchFilterObj.Product_Revision__c != '' && fmsFilter.Product_Revision__c != null){
                            if(fmsFilter.Product_Revision__c == fmsSearchFilterObj.Product_Revision__c){
                                checkExistingRecForFMSFilter1.add(fmsFilter);
                            }
                        }else if(count > 0){
                            checkExistingRecForFMSFilter1.add(fmsFilter);
                        }
                    }
                }
            }
            if(!checkExistingRecForFMSFilter1.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: The Search Filters selected already exists , please enter a unique search filters.'));
                return null;
            }
            
            try{
                insert fmsSearchFilterObj;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FormManagementMainClass.class.getName(), 'saveNewSearch()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }           
        }
        PageReference pgRef = new PageReference('/apex/FormManagementMainPage');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public void addFilterField() {
        selAddSearchFilter.add(selAddSearchFilter1);
        alertAddFilter();
        getFormStateList();
        
        if(selAddSearchFilter1 == 'Product_Name__c'){
            prodNamePicklistReset();
        }
        if(selAddSearchFilter1 == 'Product_Revision__c'){
            prodRevPicklistReset();
        }
    }
    
    public void prodNamePicklistReset(){
        prodNameLeftValues.clear();
        for(Form_Management_System__c fms : getIntermediateSearch()){
            if(fms.ProductName__c!=null && !prodNameLeftValues.contains(fms.ProductName__c)){
                prodNameLeftValues.add(fms.ProductName__c);
            }
        }
        prodNameRightValues.clear();
        if(!prodNameLeftValues.isEmpty()){
            prodNameRightValues.add('All');
        }
        populateProdOpts(); // changed to fix more than 1000 prod name error
    }
   
    public void prodRevPicklistReset(){
        prodRevLeftValues.clear();
        for(Form_Management_System__c fms : getIntermediateSearch()){
            if(fms.ProductRevision__c!=null && !prodRevLeftValues.contains(fms.ProductRevision__c)){
                prodRevLeftValues.add(fms.ProductRevision__c);
            }
        }
        prodRevRightValues.clear();
        if(!prodRevLeftValues.isEmpty()){
            prodRevRightValues.add('All');
        }
        populateProdRevs();
    }
       
    public void showPopup(){  
        if(checkDate()){
            return;
        }
        requestMsg = Apexpages.currentPage().getParameters().get('searchResId');    
        if(requestMsg != null && requestMsg != ''){
            saveNewRecordCheck = false;
            popupVal = true;
        }else{
            saveNewRecordCheck = true;
            popupVal = true;
        }
        if(customerRightValues.isEmpty()){
            dispCustomer = false;
        }else if(formTypeRightValues.isEmpty()){
            dispFormTypes = false;
        }else{
            dispCustomer = true;
            dispFormTypes = true;
        }    
    }
    
    public void closePopup() {
        popupVal = false;
    }
    
    public class ActionTableWrapper{
        public Id searchId{get;set;}
        public String status{get;set;}
        public FMS_Search_Filter__c searchObj{get;set;}
        
        public ActionTableWrapper(Id sId, FMS_Search_Filter__c sObj){
            this.searchId = sId;
            this.searchObj = sObj;
        }
    }
    
    public class fmsSearchResultWrapper{
        public String urlToNavigate{get;set;}
        public Form_Management_System__c fmsObject{get;set;}
        public Datetime lastUpdatedDt{get;set;} //Ravindra: Added for Quick Search
        public String formState{get;set;} //Ravindra: Added for Quick Search
        
        public fmsSearchResultWrapper(Form_Management_System__c fmsObj){
            this.fmsObject = fmsObj;
            this.lastUpdatedDt = fmsObj.LastModifiedDate;
            this.formState = fmsObj.State_of_the_Form__c;
            if(fmsObj.Form_Type__c == 'Main Product Definition Form'){
                this.urlToNavigate = '/apex/FMSmainFormViewPage?id='+fmsObj.id+'&pageNo=1';
            }else if(fmsObj.Form_Type__c == 'Design Data Submission (RIT)'){
                this.urlToNavigate = 'apex/FMSRITFormViewPage?id='+fmsObj.id+'&pageNo=1';
            }else if(fmsObj.Form_Type__c == 'Incremental Mask Change (IMC)'){
                this.urlToNavigate = '/apex/FMSIMCFormViewPage?id='+fmsObj.id+'&pageNo=1';
            }else if(fmsObj.Form_Type__c == 'Design Data Return (DDR)'){
                this.urlToNavigate = '/apex/FMSDDRFormViewPage?id='+fmsObj.id;
            }else if(fmsObj.Form_Type__c == 'Step Plan Approval (SP)'){
                if(fmsObj.Parent_Form_Id__c != null) {
                    this.urlToNavigate = '/apex/FMSStepPlanFormView?id='+fmsObj.id;
                }else{
                    this.urlToNavigate = '/apex/FMSStepPlanFormView?id='+fmsObj.id;
                }
                //Ravindra: Changes for Step Plan Quick Search - Starts
                if(fmsObj.Latest_Step_Plan__c!=null)    { 
                    this.lastUpdatedDt = fmsObj.Latest_Step_Plan__r.LastModifiedDate;
                    this.formState = fmsObj.Latest_Step_Plan__r.State_of_the_Form__c;
                }
                
                //Ravindra: Changes for Step Plan Quick Search - Ends
            }
        }
    }
    
    public Integer noOfRecords{get; set;}
    public Integer size{get;set;}
    public Integer noOfRecordssaveSrch{get; set;}
    public Integer sizesaveSrch{get;set;}
    


    public ApexPages.StandardSetController setConSavedSearch {
        get{
            if(setConSavedSearch == null){
                sizesaveSrch = 5;       
                setConSavedSearch = new ApexPages.StandardSetController(Database.getQueryLocator(savedSearchQuery));
                setConSavedSearch.setPageSize(sizesaveSrch);
                noOfRecordssaveSrch = setConSavedSearch.getResultSize();
            }
            return setConSavedSearch;
        }set;
    }
    public List<ActionTableWrapper> getFMSSavSearchRecords(){
        Set<Id> searchId = new Set<Id>();
        List<ActionTableWrapper> actionTableList = new List<ActionTableWrapper>();
        ActionTableWrapper searchFilterObj;     
        for(FMS_Search_Filter__c f : (List<FMS_Search_Filter__c>)setConSavedSearch.getRecords()){ 
            searchFilterObj = new ActionTableWrapper(f.id, f);
             
            if(f.FMS_Subscriptions__r != null && (f.FMS_Subscriptions__r).size()>0){
                for(FMS_Subscription__c sub : f.FMS_Subscriptions__r){
                    if(sub.Form_Deleted__c == false && sub.Form_Inserted__c == false && sub.Form_Status_Change__c == false && sub.Form_Updated__c == false) {
                        searchFilterObj.status = 'UnSubscribed';
                    }
                    else{
                        searchFilterObj.status = 'Subscribed';
                    }
                }
            }
            else{
                searchFilterObj.status = 'NotSubscribed';
            }
            actionTableList.add(searchFilterObj);
        }
        return actionTableList;
    }
    public Boolean hasNextsaveSrch {
        get {
            return setConSavedSearch.getHasNext();
        }
        set;
    }
    public Boolean hasPrevioussaveSrch {
        get {
            return setConSavedSearch.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumbersaveSrch {
        get {
            return setConSavedSearch.getPageNumber();
        }
        set;
    }
  
    public void firstsaveSrch() {
        setConSavedSearch.first();
    }
  
    public void lastsaveSrch() {
        setConSavedSearch.last();
    }
  
    public void previoussaveSrch() {
        setConSavedSearch.previous();
    }
  
    public void nextsaveSrch() {
        setConSavedSearch.next();
    }   
    
    public ApexPages.StandardSetController setCon {
        get{

            if(setCon == null || setConFlag){
                size = 10;       

                if(queryString.contains('ORDER BY')){
                    queryString = queryString.substringBefore('ORDER BY');
                }
                    
                queryString += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' Limit 9500 ';


                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
                setConFlag = false;
              }

            return setCon;
        }set;
    }
    
    public List<fmsSearchResultWrapper> getFMSRecords(){
        List<fmsSearchResultWrapper> fmsList = new List<fmsSearchResultWrapper>();
        fmsSearchResultWrapper fmsSearchWrap;
        for(Form_Management_System__c a : (List<Form_Management_System__c>)setCon.getRecords()){            
            fmsSearchWrap = new fmsSearchResultWrapper(a);          
            fmsList.add(fmsSearchWrap);
        }
        if(fmsList.size()>0){
            fmsRecoFlag = false;
        }
        else{
            fmsRecoFlag = true;
        }
        return fmsList;
    }

    public List<fmsSearchResultWrapper> getAccessFMSRecords(){
        List<fmsSearchResultWrapper> fmsList = new List<fmsSearchResultWrapper>();
        fmsSearchResultWrapper fmsSearchWrap;
        for(Form_Management_System__c a : (List<Form_Management_System__c>)setCon.getRecords()){            
            fmsSearchWrap = new fmsSearchResultWrapper(a);          
            fmsList.add(fmsSearchWrap);
        }
        if(fmsList.size()>0){
            fmsRecoFlag = false;
        }
        else{
            fmsRecoFlag = true;
        }
        return fmsList;
    }
    
    public pageReference refreshSearch(){
        setCon = null;
        getAccessFMSRecords();
        setCon.setPageNumber(1);
        return null;
    }
    
    public void accessSearch(){
        String selfFormsSearchSting = Apexpages.currentPage().getParameters().get('selfFormsSearch'); 
        
        searchcall = false;
        quickSearchCall= false;  
        viewResultsCall = false;
        if(selfFormsSearchSting!=null && selfFormsSearchSting!=''){
            searchcall = true;
            quickSearchCall= false;
            viewResultsCall = false;
        }
        formIds = new Set<String>(); 
        //Added by Anirban for search functionality - 15072017
        Set<String> tempformIds = new Set<String>();


        for(Form_System_History__c fsh : [select Main_Form__c,Main_Form__r.Form_Type__c,Main_Form__r.Parent_Form_Id__c,Main_Form__r.Latest_Step_Plan__c, Main_Form__r.Main_Form_Id__c from Form_System_History__c where LastModifiedById = :Userinfo.getUserId()]){
            if(fsh.Main_Form__r.Form_Type__c != 'Step Plan Approval (SP)'){
                formIds.add(fsh.Main_Form__c);
            }else{
                if(fsh.Main_Form__r.Parent_Form_Id__c == null){
                    formIds.add(fsh.Main_Form__c);
                }else{
                    tempformIds.add(fsh.Main_Form__r.Main_Form_Id__c);
                }
            }
        }
        for(Form_Management_System__c fmsSP : [select id from Form_Management_System__c where Main_Form_Id__c in :tempformIds and Parent_Form_Id__c = null and Form_Type__c = 'Step Plan Approval (SP)']){
            formIds.add(fmsSP.Id);
        }

        queryString = 'SELECT id, Name, CreatedById, createdby.name, Form_Name__c, Technology__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,CreatedDate,Latest_Step_Plan__c, LastModifiedDate,Chip_Interconnect__c,Latest_Step_Plan__r.LastModifiedDate,Latest_Step_Plan__r.State_of_the_Form__c, OwnerId, Owner.Profile.UserType, Parent_Form_Id__c FROM Form_Management_System__c WHERE Id in :formIds';
        refreshSearch();
        dispAccessFMSRecords = true;
        dispSearchResult = false;
        
    }
 
    public pageReference refresh() {
        setCon = null;
        getFMSRecords();
        setCon.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext {
        get {
            setConFlag= false;
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            setConFlag= false;
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setConFlag= false;
        setCon.first();
    }
  
    public void last() {
        setConFlag= false;
        setCon.last();
    }
  
    public void previous() {
        setConFlag= false;
        setCon.previous();
    }
  
    public void next() {
        setConFlag= false;
        setCon.next();
    }   
    
    public PageReference exportCsvFile() {
        this.listDetails = new List<List<string>>();
        createCsvFile();
        return new PageReference('/apex/FMSCSVExport');
    }
    
    public void createCsvFile() {
        List<string> headers = new List<string>();
        List<String> fmsIdList = new List<String>();
        List<Form_Management_System__c> fmsSrchList = (List<Form_Management_System__c>)Database.query(queryString);
        List<string> tempList = new List<string>();
        String varHeader = '';
        varHeader+= (renderingMap.containsKey('PO_Submission__c') && renderingMap.get('PO_Submission__c'))?'PO Submission,':'';
        varHeader+= (renderingMap.containsKey('Submission_Type__c') && renderingMap.get('Submission_Type__c'))?'Submission Type,':'';
        varHeader+= (renderingMap.containsKey('Package_Type__c') && renderingMap.get('Package_Type__c'))?'Package Type,':'';
        varHeader+= (renderingMap.containsKey('Packaging_Services__c') && renderingMap.get('Packaging_Services__c'))?'Packaging Services?,':'';
        varHeader+= (renderingMap.containsKey('Product_Name__c') && renderingMap.get('Product_Name__c'))?'Product Name,':'';
        varHeader+= (renderingMap.containsKey('Product_Revision__c') && renderingMap.get('Product_Revision__c'))?'Product Revision,':'';
        varHeader+= (renderingMap.containsKey('Step_Plan_Input_Method__c') && renderingMap.get('Step_Plan_Input_Method__c'))?'Step Plan Input Method,':'';
        varHeader+= (renderingMap.containsKey('Tapeout_Date_Projection__c') && renderingMap.get('Tapeout_Date_Projection__c'))?'Tapeout Date Projection,':'';
        varHeader+= (renderingMap.containsKey('Technology__c') && renderingMap.get('Technology__c'))?'Technology,':'';
        varHeader+= (renderingMap.containsKey('Test_Levels_Desired__c') && renderingMap.get('Test_Levels_Desired__c'))?'Test Services?,':'';
        varHeader+= (renderingMap.containsKey('Design_Submission_Type__c') && renderingMap.get('Design_Submission_Type__c'))?'Design Submission Type,':'';
        varHeader+= (renderingMap.containsKey('Chip_Interconnect__c') && renderingMap.get('Chip_Interconnect__c'))?'Chip Interconnect,':'';
        varHeader+= (renderingMap.containsKey('Package_Requirement__c') && renderingMap.get('Package_Requirement__c'))?'Package Requirement,':'';
        headers.add('Form Id , Form Name , Customer , State of the Form , Form Type , Form Description ,'+varHeader+'Creator, Created Date, Last Modified Date\n');
        this.listDetails.add(headers); 
        if(fmsSrchList != null && !fmsSrchList.isEmpty()){
            for(Form_Management_System__c a : fmsSrchList){
                String detail = '';
                detail += (a.name != null?'"'+a.Name+'"':'')+','+(a.Form_Name__c != null?'"'+a.Form_Name__c+'"':'')+','+(a.Customer__c != null?'"'+a.Customer__c+'"':'')+','+(a.State_of_the_Form__c != null?'"'+a.State_of_the_Form__c+'"':'')+','+(a.Form_Type__c != null?'"'+a.Form_Type__c+'"':'')+','+(a.Form_Description__c != null?'"'+a.Form_Description__c+'"':'')+',';
                detail += (renderingMap.containsKey('PO_Submission__c') && renderingMap.get('PO_Submission__c'))?((a.PurchaseOrder__c != null)?'"'+a.PurchaseOrder__c+'",':','):'';
                detail += (renderingMap.containsKey('Submission_Type__c') && renderingMap.get('Submission_Type__c'))?((a.SubmissionType__c != null)?'"'+a.SubmissionType__c+'",':','):'';
                detail += (renderingMap.containsKey('Package_Type__c') && renderingMap.get('Package_Type__c'))?((a.PackageType__c!= null)?'"'+a.PackageType__c+'",':','):'';
                detail += (renderingMap.containsKey('Packaging_Services__c') && renderingMap.get('Packaging_Services__c'))?((a.Packaging_Services__c!= null)?'"'+a.Packaging_Services__c+'",':','):'';
                detail += (renderingMap.containsKey('Product_Name__c') && renderingMap.get('Product_Name__c'))?((a.ProductName__c!= null)?'"'+a.ProductName__c+'",':','):'';
                detail += (renderingMap.containsKey('Product_Revision__c') && renderingMap.get('Product_Revision__c'))?((a.ProductRevision__c!= null)?'"'+a.ProductRevision__c+'",':','):'';
                detail += (renderingMap.containsKey('Step_Plan_Input_Method__c') && renderingMap.get('Step_Plan_Input_Method__c'))?((a.InputMethod__c!= null)?'"'+a.InputMethod__c+'",':','):'';
                detail += (renderingMap.containsKey('Tapeout_Date_Projection__c') && renderingMap.get('Tapeout_Date_Projection__c'))?((a.ProjectedTapeout__c!= null)?'"'+a.ProjectedTapeout__c+'",':','):'';
                detail += (renderingMap.containsKey('Technology__c') && renderingMap.get('Technology__c'))?((a.Technology__c != null)?'"'+a.Technology__c+'",':','):'';
                detail += (renderingMap.containsKey('Test_Levels_Desired__c') && renderingMap.get('Test_Levels_Desired__c'))?((a.TestLevels__c!= null)?'"'+a.TestLevels__c+'",':','):'';
                detail += (renderingMap.containsKey('Test_Services__c') && renderingMap.get('Test_Services__c'))?((a.TestServices__c!= null)?'"'+a.TestServices__c+'",':','):'';
                detail += (renderingMap.containsKey('Design_Submission_Type__c') && renderingMap.get('Design_Submission_Type__c'))?((a.DesignSubmission__c!= null)?'"'+a.DesignSubmission__c+'",':','):'';
                detail += (renderingMap.containsKey('Chip_Interconnect__c') && renderingMap.get('Chip_Interconnect__c'))?((a.Chip_Interconnect__c != null)?'"'+a.Chip_Interconnect__c+'",':','):'';
                detail += (renderingMap.containsKey('Package_Requirement__c') && renderingMap.get('Package_Requirement__c'))?((a.PackageRequirement__c!= null)?'"'+a.PackageRequirement__c+'",':','):'';
                detail += (a.createdbyId != null?String.valueOf(a.createdby.name ):'')+',' +(a.createdDate != null?String.valueOf(a.createdDate):'')+','+(a.lastModifiedDate != null?'"'+String.valueOf(a.lastModifiedDate)+'"':'')+','+'\n';
                
                if(tempList.size() < 1000){
                    tempList.add(detail);
                }else {                    
                    this.listDetails.add(tempList); 
                    tempList = new List<string>();
                    tempList.add(detail);
                }
            } 
        }
        if(tempList.size() > 0){
            this.listDetails.add(tempList);
        }
        
    }
    
    public ApexPages.StandardSetController setSubscribes {
        get{
            if(setSubscribes == null){
                pagesize = 10;
                fmsSubscription = FMSSubsciptions();
                setSubscribes = new ApexPages.StandardSetController(fmsSubscription);
                setSubscribes.setPageSize(pagesize);
                noOfSubscribedRecords = setSubscribes.getResultSize();
            }
            return setSubscribes;
        }set;
    }
    Public List<FMS_Subscription__c> FMSSubsciptions(){
        fmsSubscription.clear();             
         // Added the code for Subscription Object 1Sept2017 
        for(FMS_Subscription__c frmSubVali : [SELECT id,Form_Id__c,Form_Id__r.Form_Name__c,Form_Id__r.RecordTypeId,Form_Id__r.Name,Form_Id__r.Customer__c,Form_Id__r.SAP_Account_Number__c, 
                                                    Form_Id__r.CreatedDate, Form_Inserted__c,Form_Status_Change__c,Form_Updated__c,
                                                    MySubscriptionId__c,Name,OwnerId,Subscribed_Date__c,UnSubscribed_Date__c,
                                                    User_Name__c, Form_Deleted__c, CreatedDate,Form_Id__r.Parent_Form_Id__r.CreatedDate,
                                                    Form_Id__r.Parent_Form_Id__r.Name,Form_Id__r.Parent_Form_Id__r.Form_Name__c,
                                                    Form_Id__r.Parent_Form_Id__c,Form_Id__r.Form_Type__c FROM FMS_Subscription__c 
                                                    WHERE  User_Name__c =:Userinfo.getUserId() 
                                                   and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true 
                                                    or Form_Deleted__c = true) and Saved_Search_Id__c=null ORDER BY Form_Id__r.CreatedDate DESC]){
            system.debug('frmSubVali ==> '+frmSubVali);
            if(frmSubVali.UnSubscribed_Date__c != null ){
                if(frmSubVali.Subscribed_Date__c >= frmSubVali.UnSubscribed_Date__c) {
                    fmsSubscription.add(frmSubVali);
                }    
            }
            else{
                 fmsSubscription.add(frmSubVali);
            }
        }
        
        return fmsSubscription;
        
    }
    
    Public List<FMS_Subscription__c> getFMSSubscriptionVal(){
        List<FMS_Subscription__c> subList = new List<FMS_Subscription__c>();
        for(FMS_Subscription__c subscriptions : (List<FMS_Subscription__c>)setSubscribes.getRecords()){
            subList.add(subscriptions);
        }
        
        return subList;
    }
    
    public pageReference refreshSubsciption() {
        setSubscribes = null;
        getFMSSubscriptionVal();
        setSubscribes.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNextSubscription {
        get {
            return setSubscribes.getHasNext();
        }
        set;
    }
    public Boolean hasPreviousSubscription {
        get {
            return setSubscribes.getHasPrevious();
        }
        set;
    }
  
    public Integer subscriptionPageNumber {
        get {
            return setSubscribes.getPageNumber();
        }
        set;
    }
  
    public void firstSubList() {
        setSubscribes.first();
    }
  
    public void lastSubList() {
        setSubscribes.last();
    }
  
    public void previousSubList() {
        setSubscribes.previous();
    }
  
    public void nextSubList() {
        setSubscribes.next();
    }
    
    
    public pageReference viewFMSPage() {       
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosById();

        string recordTypeName = rtMap.get(formrecordtypeId).getName();
        
        PageReference pg ;
        
        if(recordTypeName.trim() == 'Design Data Return (DDR)')
        {
            pg = new PageReference('/apex/FMSDDRFormViewPage?id='+formId);
        }
        else if(recordTypeName.trim() == 'Design Data Submission (RIT)'){
            pg = new PageReference('/apex/FMSRITFormViewPage?id='+formId);
        }
        else if(recordTypeName.trim() == 'Incremental Mask Change (IMC)'){
            pg = new PageReference('/apex/FMSIMCFormViewPage?id='+formId);   
        }
        else if(recordTypeName.trim() == 'Main Product Definition Form'){
            pg = new PageReference('/apex/FMSmainFormViewPage?id='+formId); 
        }
        else if(recordTypeName.trim() == 'Step Plan Approval (SP)'){
            pg = new PageReference('/apex/FMSStepPlanFormView?id='+formId); 
        }
        
        pg.setRedirect(true);
        return pg;
    }
    
    public void unsubscribeAll() {
        fmsMySub.Subscribed_All__c = autoSubscibeChkBox;
        if(!autoSubscibeChkBox){
            fmsMySub.UnSubscribed_Date__c = system.today();
        }
        else{
            fmsMySub.Subscribed_Date__c = system.today();
        }
      
        try{
            update fmsMySub;
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FormManagementMainClass.class.getName(), 'unsubscribeAll()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }

    }
     public pageReference unsubForm() {
        FMS_Subscription__c fmsSubRec = new FMS_Subscription__c(id=unsubscribeId);
        fmsSubRec.Form_Inserted__c = false;
        fmsSubRec.Form_Status_Change__c = false;
        fmsSubRec.Form_Updated__c = false;
        fmsSubRec.Form_Deleted__c = false;
        fmsSubRec.UnSubscribed_Date__c = system.today(); 
        
        try{
            update fmsSubRec;
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FormManagementMainClass.class.getName(), 'unsubForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }

        PageReference pg = new PageReference('/apex/FormManagementMainPage');
        pg.getParameters().put('ActiveTab', 'My Subscriptions');
        pg.setRedirect(true);
        return pg;
    }
     public Boolean subResultError {
        get {
            return (FMSSubsciptions().size()==0?true:false);
        }
        set;
    }
    
    public pageReference unSubscribeSearch() {
        List<FMS_Subscription__c> fmsSubscriptionUpdate =  new List<FMS_Subscription__c>();
        List<FMS_Subscription__c> fmsSubscriptionList = [SELECT CreatedDate, Form_Deleted__c, Form_Id__c, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Id, LastModifiedDate, MySubscriptionId__c, Name, OwnerId, Saved_Search_Id__c, Subscribed_Date__c, SystemModstamp, UnSubscribed_Date__c, User_Name__c FROM FMS_Subscription__c WHERE Saved_Search_Id__c = : searchUnsubscibeId and UnSubscribed_Date__c = null];
        for(FMS_Subscription__c subRec : fmsSubscriptionList){
            subRec.Form_Inserted__c = false;
            subRec.Form_Status_Change__c = false;
            subRec.Form_Updated__c = false;
            subRec.Form_Deleted__c = false;
            subRec.UnSubscribed_Date__c = system.today();
            fmsSubscriptionUpdate.add(subRec);
        }
        
        if(fmsSubscriptionUpdate!=null && fmsSubscriptionUpdate.size()>0){ 
            try{
                update fmsSubscriptionUpdate;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FormManagementMainClass.class.getName(), 'unSubscribeSearch()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

        }
        PageReference pg = new PageReference('/apex/FormManagementMainPage');
        pg.setRedirect(true);
        return pg;
    }
    
     public List<SelectOption> getdateOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1day','1 day'));
        options.add(new SelectOption('1week','1 week')); 
        options.add(new SelectOption('2weeks','2 weeks')); 
        options.add(new SelectOption('1month','1 month'));
        options.add(new SelectOption('6months','6 months')); 
        options.add(new SelectOption('1year','1 year'));

        return options; 
    }
    public List<SelectOption> getdateTypeOption() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('alldates','All Dates')); 
        options.add(new SelectOption('daterange','Date range'));        
        return options; 
    }
    public PageReference tesemehtod(){        
        fmsSearchFilterObj.CreationDateOptions__c = ((dateOptionTypeOpted!=null&&dateOptionTypeOpted!='')?dateOptionTypeOpted:dateOptionOpted);
        fmsSearchFilterObj.ModifiedDateOptions__c= ((modifyDateOptTypeOpted!=null&&modifyDateOptTypeOpted!='')?modifyDateOptTypeOpted:modifydateOptionOpted);
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }
        return null;
    }

    public PageReference refreshProdNmRev(){
        if(renderingMap.containsKey('Product_Name__c')){
            prodNamePicklistReset();
        }
        if(renderingMap.containsKey('Product_Revision__c')){
            prodRevPicklistReset();
        }
        return null;
    }
    
    public void checkTimeInterval(){
        deleted = '';
    }

    public void removeFilter(){
        nameVal = ApexPages.currentPage().getParameters().get('fieldName');
        renderingMap.put(nameVal, false);
        Set<String> selectedValSet = new Set<String>();
        selectedValSet.addAll(selAddSearchFilter);
        selectedValSet.remove(nameVal);
        selAddSearchFilter = new List<String>(selectedValSet);
    }
    
    @TestVisible
    private static List<SelectOption> getPicklistValue(sObject obj, String fld)
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.sObjectType objType = Form_Management_System__c.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues(); 
   
        for (Schema.PicklistEntry a : values)
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        return options;       
    }
    
    public without sharing class populateDMEACust{
    
        public List<Account> dmeaList(String sol){
            return [SELECT id, Name, SAP_Account_Number__c, Customer_Category__c,Short_Name__c FROM Account WHERE  ( (Customer_Category__c = 'TFA' OR Customer_Category__c = 'CC') OR SAP_Account_Number__c = :sol)];    
        }
    }
    
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'desc'; } return SortDirection;  }
        set;
    }
    
    public String SortField {
        get { if (SortField == null) {SortField = 'LastModifiedDate'; } return SortField;  }
        set; 
    }
    
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
     
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
         setConFlag= true;
        getFMSRecords();
    }
    
}