/*
* @ Author :- Anil Kumar Reddy L
* @ Description :- Functionality for subscription from Search Filter.
* @ Date :- 25/08/2016
* @ Change History :-  
    DATE            NAME            Comments
    6-Dec-2016      Inshu Misra     Added code for exception framework...#IM
    18-May-2017     Ram Rai         Remove the limit clause in Account Query.
    20-July-2017    Anirban Roy     Search Query Modification for Last Modified Date to Resolve Issue.
    26-July-2017    Anirban Roy     Escaped single quotes from customer name
    26-July-2017    Ram Rai         Added Logic for Product name and Product Revision 
    01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue
**/
public with sharing class FMSSubscribeSearchCtrl {
    
    public boolean allEvents {
        get;
        set;
    }
    public boolean formCreated {
        get;
        set;
    }
    public boolean formEdited {
        get;
        set;
    }
    public boolean formStatusChange {
        get;
        set;
    }
    public boolean formDeleted {
        get;
        set;
    }
    
    public id searchObjId;
    public string tranxType;
    public FMS_Search_Filter__c fmsSearchFilterObj;
    public List < FMS_Search_Filter__c > searchFilterList;
    public List < Form_Management_System__c > fmsObjectList;
    public List < FMS_Subscription__c > fmsSubscriptionList;
    List < FMS_Subscription__c > fmsSubscibeList = new List < FMS_Subscription__c > (); 
    public boolean fmsRecResult{get;set;}
    public Boolean isExternalUser {get;set;}
    public Map<Id,Id> accPrt = new Map<Id,Id>();
    
    public Date varFromCreatedDate;
    public Date varToCreatedDate;
    public Date varFromModifiedDate;
    public Date varToModifiedDate;
    
    public FMSSubscribeSearchCtrl() {
        searchFilterList = new List < FMS_Search_Filter__c > ();
        fmsSearchFilterObj = new FMS_Search_Filter__c();
        fmsObjectList = new List < Form_Management_System__c > ();
        searchObjId = ApexPages.currentPage().getParameters().get('Id');
       
        tranxType = ApexPages.currentPage().getParameters().get('tnx');
        Contact dmeaCont;
        Set<Id> accId1 = new Set<Id>();
        // Added the sharing for Subscription Object 1Sept2017 
        if(UserInfo.getUserType()!='Standard'){
            isExternalUser = true;
            User loggedInUser = [SELECT ContactId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
            dmeaCont = [SELECT accountid FROM Contact WHERE id = :loggedInUser.ContactId LIMIT 1];             
        } else{
            isExternalUser = false;
        }
        allEvents = false;
        formCreated = false;
        formEdited = false;
        formStatusChange = false;
        formDeleted = false;
        fmsRecResult = true;
        
        // Added the sharing for Subscription Object 1Sept2017 
        fmsSubscriptionList = [SELECT CreatedDate, Form_Deleted__c, Form_Id__c, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Id, LastModifiedDate, MySubscriptionId__c, Name, OwnerId, Saved_Search_Id__c, Subscribed_Date__c, SystemModstamp, UnSubscribed_Date__c, User_Name__c FROM FMS_Subscription__c WHERE Saved_Search_Id__c = : searchObjId and UnSubscribed_Date__c = null ];
        
        if (tranxType == 'editsub') {
           
            if (fmsSubscriptionList != null && fmsSubscriptionList.size() > 0) {

                if (fmsSubscriptionList[0].Form_Deleted__c == true && fmsSubscriptionList[0].Form_Inserted__c == true && fmsSubscriptionList[0].Form_Status_Change__c == true && fmsSubscriptionList[0].Form_Updated__c == true) {
                    allEvents = true;
                    formCreated = fmsSubscriptionList[0].Form_Inserted__c;
                    formEdited = fmsSubscriptionList[0].Form_Updated__c;
                    formStatusChange = fmsSubscriptionList[0].Form_Status_Change__c;
                    formDeleted = fmsSubscriptionList[0].Form_Deleted__c;
                } else {
                    formCreated = fmsSubscriptionList[0].Form_Inserted__c;
                    formEdited = fmsSubscriptionList[0].Form_Updated__c;
                    formStatusChange = fmsSubscriptionList[0].Form_Status_Change__c;
                    formDeleted = fmsSubscriptionList[0].Form_Deleted__c;

                }
            }
        }
        else if(tranxType == 'sub'){
            if (fmsSubscriptionList == null || fmsSubscriptionList.size() == 0) {
                   
                searchFilterList = [SELECT id,CreationDateOptions__c,ModifiedDateOptions__c, Name, OwnerId, Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c, Customer__c, Design_Submission_Type__c, Form_State__c,
                    Packaging_Services__c, Package_Type__c, 
                    Form_Type__c, Last_Modified_From__c, Last_Modified_To__c, Package_Requirement__c, PO_Submission__c, Product_Name__c, Product_Revision__c, Release_Process__c, Step_Plan_Input_Method__c, Submission_Type__c, Tapeout_Date_Projection__c, Technology__c, Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c
                    FROM FMS_Search_Filter__c WHERE id = : searchObjId
                ];
                
    
                if (searchFilterList != null && searchFilterList.size() > 0) {
                    fmsSearchFilterObj = searchFilterList[0];
                }
                
                String whereClause = '';
                String fmsQuery = 'SELECT Id from Form_Management_System__c';
    
                if (fmsSearchFilterObj.Chip_Interconnect__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    string tempCI = '';
                    for(string s: fmsSearchFilterObj.Chip_Interconnect__c.split(';')){
                        tempCI = tempCI + '\''+ s + '\'' + ',';
                    }
                    tempCI = tempCI.substring(0,tempCI.length()-1);
                    whereClause += ' Chip_Interconnect__c ' + ' IN (' + tempCI + ') ';
                }
                 // code block added by akash starts on nov 8th to fix the logc of relative date saved search based subscription  for created date 
                if (fmsSearchFilterObj.CreationDateOptions__c != 'daterange' && fmsSearchFilterObj.CreationDateOptions__c != NULL && fmsSearchFilterObj.CreationDateOptions__c != 'alldates') {                                      
                    varFromCreatedDate = null;
                    if(fmsSearchFilterObj.CreationDateOptions__c == '1day'){
                        varFromCreatedDate = system.today().addDays(-1);                    
                    }                       
                    else if(fmsSearchFilterObj.CreationDateOptions__c == '1week'){
                        varFromCreatedDate = system.today().addDays(-7);                           
                    }
                    else if(fmsSearchFilterObj.CreationDateOptions__c == '2weeks'){
                        varFromCreatedDate = system.today().addDays(-14);
                    }
                    else if(fmsSearchFilterObj.CreationDateOptions__c == '1month'){
                        varFromCreatedDate = system.today().addMonths(-1);
                    }
                    else if(fmsSearchFilterObj.CreationDateOptions__c == '6months'){
                        varFromCreatedDate = system.today().addMonths(-6);
                    }
                    else if(fmsSearchFilterObj.CreationDateOptions__c == '1year'){
                        varFromCreatedDate = system.today().addYears(-1);
                    }
                    varToCreatedDate = system.today();
                    varToCreatedDate = varToCreatedDate.addDays(1);                                          
                 }
                 else if(fmsSearchFilterObj.CreationDateOptions__c == 'daterange'){
                    if(fmsSearchFilterObj.Created_Date_From__c != null){                                        
                      varFromCreatedDate = fmsSearchFilterObj.Created_Date_From__c;                                                       
                    }       
                    
                    if(fmsSearchFilterObj.Created_Date_To__c != null){                                      
                      varToCreatedDate = fmsSearchFilterObj.Created_Date_To__c;
                      varToCreatedDate = varToCreatedDate.addDays(1);                                                         
                    }                                      
                 }
                 // add fromcreateddate to query string if not null  
                 if(varFromCreatedDate != NULL) {
                   if (whereClause != null && whereClause != '') {
                     whereClause += ' and ';
                   }                                   
                   Datetime createdDateFrom = datetime.newInstance(varFromCreatedDate.year(), varFromCreatedDate.month(), varFromCreatedDate.day());
                   whereClause += ' CreatedDate  >= :varFromCreatedDate ';                  
                 }
                 
                 if(varToCreatedDate != NULL) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    Datetime createdDateTo = datetime.newInstance(varToCreatedDate.year(), varToCreatedDate.month(), varToCreatedDate.day(), 11, 59, 59);
                    whereClause += ' CreatedDate <= :varToCreatedDate ';                   
                    
                 } 
                 // code block added by akash ends           
               
    
                if (fmsSearchFilterObj.Customer__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    List < String > customers = new List<String>();  
                    if(fmsSearchFilterObj.Customer__c.contains('All') ){
                    // Added the sharing for Subscription Object 1Sept2017 
                        if(!isExternalUser){
                            for(Account a : [SELECT Name FROM Account WHERE Fab_9_10__c = 'Yes']){                               
                                customers.add(a.Name);
                            }  
                        }else{
                            for(Account a : [SELECT id, parentid FROM Account WHERE Fab_9_10__c = 'Yes']){
                                accPrt.put(a.id,a.parentid);                
                            } 
                            Account acc = [select parentid from account where id = :dmeaCont.accountid];
                            checkChild(acc.parentid);
                            for(Account a : [SELECT Name FROM Account WHERE id=:accPrt.keyset()]){           
                               customers.add(a.Name);          
                            }                                  
                        }    
                    }
                    else{
                        customers = (fmsSearchFilterObj.Customer__c).split(';');   
                    }
                     //20-7-2017 Anirban Roy- modified against search logic for Step Plan
                     //26-07-2017 Anirban Roy - escaped single quotes from customer name
                    String custTemp='';
                    for(String cust : customers){
                        custTemp= custTemp+ '\''+ String.escapeSingleQuotes(cust) + '\'' + ',';
                    }
                    custTemp = custTemp.substring(0,custTemp.length()-1);
                    
                    whereClause += ' Customer__c'+  ' IN (' + custTemp + ') ';
                    }
                if (fmsSearchFilterObj.Design_Submission_Type__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                         
                    }
                    
                    string tempDST = '';
                    string tempValue = '';
                    for(string s: fmsSearchFilterObj.Design_Submission_Type__c.split(';')){
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
                    whereClause += ' DesignSubmission__c ' + ' IN (' + tempDST + ') ';
                }
                if (fmsSearchFilterObj.Form_State__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempFS = '';
                    for(string s: fmsSearchFilterObj.Form_State__c.split(';')){
                        tempFS = tempFS + '\''+ s + '\'' + ',';
                    }
                   //START 20-7-2017 Anirban Roy- modified against search logic for Step Plan
                    tempFS = tempFS.substring(0,tempFS.length()-1);                    
                    
                    List < String > formtypeLst = new  List < String >();
                    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
                    
                    if(fmsSearchFilterObj.Form_Type__c.contains('All')){
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - Start
                        for(String recordTypeStr : rtMapByName.keySet()){
                            if(!recordTypeStr.contains('Master')){
                                formtypeLst.add(recordTypeStr);
                            }
                        }
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - End
                    }
                    else{
                        formtypeLst = (fmsSearchFilterObj.Form_Type__c).split(';');                                               
                    }
                    
                    Set<String> fTypeSet = new Set<String>();
                    fTypeSet.addAll(formtypeLst);
                    
                    //==============//
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        whereClause += ' State_of_the_Form__c ' + ' IN (' + tempFS + ') ';
                    }else{
                        String queryStr='';
                        Integer formCount=1;     

                            
                        for(String formtype : fTypeSet){
                            if(formCount == 1){

                                 queryStr += ' (';
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
                            whereClause += queryStr;
                        } 
                    }
                }
                 //END 20-7-2017 Anirban Roy- modified against search logic for Step Plan 
                if (fmsSearchFilterObj.Form_Type__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    List < String > formtypeLst = new List<String>();
                    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
                    if(fmsSearchFilterObj.Form_Type__c.contains('All')){
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - Start
                        for(String recordTypeStr : rtMapByName.keySet()){
                            if(!recordTypeStr.contains('Master')){
                                formtypeLst.add(recordTypeStr);
                            }
                        }
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - End
                    }
                    else{
                        formtypeLst = (fmsSearchFilterObj.Form_Type__c).split(';');                       
                    }
                    Set<String> fTypeSet = new Set<String>();
                    fTypeSet.addAll(formtypeLst);
                  
                    
                    //==============//
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        String formType='';
                        for(String ftype : fTypeSet){
                            formType= formType+ '\''+ ftype + '\'' + ',';
                        }
                        formType = formType.substring(0,formType.length()-1);
                        
                     
                         whereClause += ' Form_Type__c'+' IN (' + formType + ') ';
                    }else{
                        String queryStr='';
                        Integer formCount=1;
                            
                        for(String formtype : fTypeSet){
                            if(formCount == 1){

                                 queryStr += ' (';
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
                            whereClause += queryStr;
                        } 
                    }                                        
                    
                }    
                // code block added by akash starts on nov 8th to fix the logc of relative date saved search based subscription  for modified date date 
                if(fmsSearchFilterObj.ModifiedDateOptions__c != 'daterange' && fmsSearchFilterObj.ModifiedDateOptions__c != NULL  && fmsSearchFilterObj.ModifiedDateOptions__c != 'alldates') {
               
                    varFromModifiedDate = null;
                    if(fmsSearchFilterObj.ModifiedDateOptions__c == '1day'){
                        varFromModifiedDate = system.today().addDays(-1);
                    }
                    else if(fmsSearchFilterObj.ModifiedDateOptions__c == '1week'){
                        varFromModifiedDate = system.today().addDays(-7);
                    }
                    else if(fmsSearchFilterObj.ModifiedDateOptions__c == '2weeks'){
                        varFromModifiedDate = system.today().addDays(-14);
                    }
                    else if(fmsSearchFilterObj.ModifiedDateOptions__c == '1month'){
                        varFromModifiedDate = system.today().addMonths(-1);
                    }
                    else if(fmsSearchFilterObj.ModifiedDateOptions__c == '6months'){
                        varFromModifiedDate = system.today().addMonths(-6);
                    }
                    else if(fmsSearchFilterObj.ModifiedDateOptions__c == '1year'){
                        varFromModifiedDate = system.today().addYears(-1);
                    }
                    varToModifiedDate = system.today();
                    varToModifiedDate = varToModifiedDate.addDays(1);   
                }  
                else if(fmsSearchFilterObj.ModifiedDateOptions__c == 'daterange'){
                    if(fmsSearchFilterObj.Last_Modified_From__c != null){                                       
                      varFromModifiedDate = fmsSearchFilterObj.Last_Modified_From__c;                                                         
                    }                           
                    if(fmsSearchFilterObj.Last_Modified_To__c != null){                                     
                      varToModifiedDate = fmsSearchFilterObj.Last_Modified_To__c;   
                      varToModifiedDate = varToModifiedDate.addDays(1);                                                       
                    }                                      
                }  
              
              // code block added by akash ends 
                if (varFromModifiedDate != null ) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    Date modifiedDateFrom = varFromModifiedDate;
                    List < String > formtypeLst = new List<String>();
                 
                    Map<String,Schema.RecordTypeInfo> rtMapByName = SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
                    if(fmsSearchFilterObj.Form_Type__c.contains('All')){
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - Start
                        for(String recordTypeStr : rtMapByName.keySet()){
                            if(!recordTypeStr.contains('Master')){
                                formtypeLst.add(recordTypeStr);
                            }
                        }
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - End
                    }
                    else{
                        formtypeLst = (fmsSearchFilterObj.Form_Type__c).split(';');                       
                    }
                     Set<String> fTypeSet = new Set<String>();
                    fTypeSet.addAll(formtypeLst);
                    
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        whereClause += ' LastModifiedDate  >= :modifiedDateFrom ';
                    }else{
                        
                        String queryStr='';
                        Integer formCount=1;
                            
                        for(String formtype : fTypeSet){
                            if(formCount == 1){

                                 queryStr += ' (';
                            }
                        
                        if(formtype == 'Step Plan Approval (SP)'){
                            //Code Change Done for the Last Modified Date Query to Resolve Issue   20/07/2017
                            queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate >=:modifiedDateFrom ) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate >= :modifiedDateFrom ))) OR ';      
                            }else if(formtype != 'Step Plan Approval (SP)'){
                                 queryStr +=  '(Form_Type__c = \''+formtype+'\' and LastModifiedDate  >= :modifiedDateFrom) OR ';
                            } 
                            
                            if(formCount==fTypeSet.size()){
                                queryStr = queryStr.removeEnd('OR ');
                                queryStr+=') ';

                             } 
                            formCount++;    
                        }
                        if(queryStr!=null && queryStr!=''){ 
                            whereClause += queryStr;
                        }                     
                    }
                    
                    }
                if (varToModifiedDate != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    Date modifiedDateTo = varToModifiedDate; 
                    List < String > formtypeLst = new List<String>();
                 
                    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
                    if(fmsSearchFilterObj.Form_Type__c.contains('All')){                       
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - Start
                        for(String recordTypeStr : rtMapByName.keySet()){
                            if(!recordTypeStr.contains('Master')){
                                formtypeLst.add(recordTypeStr);
                            }
                        }
                        //Code changed to add the recordtypes in a list - ARoy 21/07/2017 - End                        
                    }
                    else{
                        formtypeLst = (fmsSearchFilterObj.Form_Type__c).split(';');                       
                    }
                    Set<String> fTypeSet = new Set<String>();
                    fTypeSet.addAll(formtypeLst);
                    
                    if(!fTypeSet.contains('Step Plan Approval (SP)')){
                        whereClause += ' LastModifiedDate <= :modifiedDateTo';
                    }else{
                        
                        String queryStr='';
                        Integer formCount=1;
                            
                        for(String formtype : fTypeSet){
                            if(formCount == 1){

                                 queryStr += ' (';
                            }
                        
                        if(formtype == 'Step Plan Approval (SP)'){
                            //Code Change Done for the Last Modified Date Query to Resolve Issue    20/07/2017                     
                            queryStr += '(Form_Type__c = \''+formtype+'\' and Parent_Form_ID__c = null and ((Latest_Step_Plan__c = null and LastModifiedDate <=:modifiedDateTo) OR (Latest_Step_Plan__c != null and Latest_Step_Plan__r.LastModifiedDate <= :modifiedDateTo))) OR ';      
                            }else if(formtype != 'Step Plan Approval (SP)'){
                                 queryStr += '(Form_Type__c = \''+formtype+'\' and LastModifiedDate <= :modifiedDateTo) OR ';
                            } 
                            
                            if(formCount==fTypeSet.size()){
                                queryStr = queryStr.removeEnd('OR ');
                                queryStr+=') ';

                             } 
                            formCount++;    
                        }
                        if(queryStr!=null && queryStr!=''){ 
                            whereClause += queryStr;
                        }                     
                    }                                            
                }
    
                if (fmsSearchFilterObj.Package_Requirement__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempPR = '';
                    for(string s: fmsSearchFilterObj.Package_Requirement__c.split(';')){
                        tempPR = tempPR + '\''+ s + '\'' + ',';
                    }
                    tempPR = tempPR.substring(0,tempPR.length()-1);
                    whereClause += ' PackageRequirement__c ' + ' IN (' + tempPR + ') ';
                }
    
                if (fmsSearchFilterObj.Package_Type__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempPT = '';
                    for(string s: fmsSearchFilterObj.Package_Type__c.split(';')){
                        tempPT = tempPT + '\''+ s + '\'' + ',';
                    }
                    tempPT = tempPT.substring(0,tempPT.length()-1);
                    whereClause += ' PackageType__c ' + ' IN (' + tempPT + ') ';
                }
                if (fmsSearchFilterObj.Packaging_Services__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempPS = '';
                    for(string s: fmsSearchFilterObj.Packaging_Services__c.split(';')){
                        tempPS = tempPS + '\''+ s + '\'' + ',';
                    }
                    tempPS = tempPS.substring(0,tempPS.length()-1);
                    whereClause += ' Packaging_Services__c ' + ' IN (' + tempPS + ') ';
                }
                if (fmsSearchFilterObj.PO_Submission__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempPOSub = '';
                    for(string s: fmsSearchFilterObj.PO_Submission__c.split(';')){
                        tempPOSub = tempPOSub + '\''+ s + '\'' + ',';
                    }
                    tempPOSub = tempPOSub.substring(0,tempPOSub.length()-1);
                    whereClause += ' PurchaseOrder__c ' + ' IN (' + tempPOSub + ') ';
                }
    
                if (fmsSearchFilterObj.Product_Name__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    // 26/07/2017 Anirban START - Changes for Product Name search
                    string tempProd = '';
                    //26/07/2017 RRAI START - Added logic for Product name search
                    if(fmsSearchFilterObj.Product_Name__c== 'All;'){
                        whereClause += ' ProductName__c'  + ' != null ';
                    }else if(fmsSearchFilterObj.Product_Name__c!= 'All;') {
                    
                    for(string prodName: fmsSearchFilterObj.Product_Name__c.split(';')){
                        tempProd = tempProd + '\''+ String.escapeSingleQuotes(prodName) + '\'' + ',';
                    }
                    tempProd = tempProd.substring(0,tempProd.length()-1);
                    whereClause += ' ProductName__c ' + ' IN (' + tempProd + ') ';
                    }
                    // 26/07/2017 RRAI END - End Of Change 
                    // 26/07/2017 Anirban END - Changes for Product Name search
                    
                    //whereClause += ' ProductName__c = \'' + fmsSearchFilterObj.Product_Name__c + '\'';
                }
                if (fmsSearchFilterObj.Product_Revision__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    system.debug('-inside-'+fmsSearchFilterObj.Product_Revision__c);
                    // 26/07/2017 Anirban START - Changes for Product Revision search
                    string tempProd = '';
                    //26/07/2017 RRAI START - Added logic for Product Revision search
                    if(fmsSearchFilterObj.Product_Revision__c == 'All;'){
                         whereClause += ' ProductRevision__c'  + ' != null ';
                         
                    }
                    else if(fmsSearchFilterObj.Product_Revision__c != 'All;') {
                  
                    for(string prodRev: fmsSearchFilterObj.Product_Revision__c.split(';')){
                        tempProd = tempProd + '\''+ String.escapeSingleQuotes(prodRev) + '\'' + ',';
                    }
                    tempProd = tempProd.substring(0,tempProd.length()-1);
                    whereClause += ' ProductRevision__c ' + ' IN (' + tempProd + ') ';
                    }
                    //26/07/2017 RRAI END- Added logic for Product Revision search
                    // 26/07/2017 Anirban END - Changes for Product Revision search
                    
                    //whereClause += ' ProductRevision__c = \'' + fmsSearchFilterObj.Product_Revision__c + '\'';
                }
    
                if (fmsSearchFilterObj.Release_Process__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempRP = '';
                    for(string s: fmsSearchFilterObj.Release_Process__c.split(';')){
                        tempRP = tempRP + '\''+ s + '\'' + ',';
                    }
                    tempRP = tempRP.substring(0,tempRP.length()-1);
                    whereClause += ' ReleaseProcessFlow__c ' + ' IN (' + tempRP + ') ';
                }
                if (fmsSearchFilterObj.Step_Plan_Input_Method__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempSPIM = '';
                    string tempValue = '';
                    for(string s: fmsSearchFilterObj.Step_Plan_Input_Method__c.split(';')){
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
                    whereClause += ' InputMethod__c ' + ' IN (' + tempSPIM + ') ';
                }
                if (fmsSearchFilterObj.Submission_Type__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempST = '';
                    string tempValue = '';
                    for(string s: fmsSearchFilterObj.Submission_Type__c.split(';')){
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
                    whereClause += ' SubmissionType__c ' + ' IN (' + tempST + ') ';
                }
                if (fmsSearchFilterObj.Tapeout_Date_Projection__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    date tapoutdate = fmsSearchFilterObj.Tapeout_Date_Projection__c;
                    whereClause += ' ProjectedTapeout__c = :tapoutdate ';
                }
                if (fmsSearchFilterObj.Technology__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempTech = '';
                    for(string s: fmsSearchFilterObj.Technology__c.split(';')){
                        tempTech = tempTech + '\''+ s + '\'' + ',';
                    }
                    tempTech = tempTech.substring(0,tempTech.length()-1);
                    whereClause += ' Technology__c ' + ' IN (' + tempTech + ') ';
                }
                if (fmsSearchFilterObj.Test_Levels_Desired__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempTL = '';
                    for(string s: fmsSearchFilterObj.Test_Levels_Desired__c.split(';')){
                        tempTL = tempTL + '\''+ s + '\'' + ',';
                    }
                    tempTL = tempTL.substring(0,tempTL.length()-1);
                    whereClause += ' TestLevels__c ' + ' IN (' + tempTL + ') ';
                }
                if (fmsSearchFilterObj.Test_Services__c != null) {
                    if (whereClause != null && whereClause != '') {
                        whereClause += ' and ';
                    }
                    
                    string tempTS = '';
                    for(string s: fmsSearchFilterObj.Test_Services__c.split(';')){
                        tempTS = tempTS + '\''+ s + '\'' + ',';
                    }
                    tempTS = tempTS.substring(0,tempTS.length()-1);
                    whereClause += ' TestServices__c ' + ' IN (' + tempTS + ') ';
                }
    
                if (whereClause != null && whereClause != '') {
                    fmsQuery += ' WHERE ' + whereClause;
                }
              
               system.debug('fmsQuery==>'+ fmsQuery);
                fmsObjectList = Database.query(fmsQuery);
                if(fmsObjectList!=null && fmsObjectList.size()>0){
                    fmsRecResult = true;   
                }
                else{
                    fmsRecResult = false; 
                }
                
                
            }
        }        
    }

    // Added the sharing for Subscription Object 1Sept2017 
    public void checkChild(Id Acc){       
        accPrt.remove(acc);
        if(acc!=null){      
            List<Account> acLst = [select id,parentid from account where id =:Acc];            
            if(!acLst.isEmpty() && acLst[0].parentid!=null){
                checkChild(acLst[0].parentid);
            }  
        }
    }
    public pagereference submit() {
       
        if (tranxType == 'editsub') {
             modifySubscription(fmsSubscriptionList);    
        }
        else if(tranxType == 'sub') {
            if(fmsSubscriptionList == null || fmsSubscriptionList.size()==0 ){
                Boolean check=false;
				for (Form_Management_System__c fmsobj: fmsObjectList) {
                    FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();
                    fmsSubscribe.Form_Id__c = fmsobj.id;
                    if (allEvents) {
                        fmsSubscribe.Form_Inserted__c = true;
                        fmsSubscribe.Form_Status_Change__c = true;
                        fmsSubscribe.Form_Updated__c = true;
                        fmsSubscribe.Form_Deleted__c = true;
                    } 
                    else {
                        fmsSubscribe.Form_Inserted__c = formCreated;
                        fmsSubscribe.Form_Status_Change__c = formStatusChange;
                        fmsSubscribe.Form_Updated__c = formEdited;
                        fmsSubscribe.Form_Deleted__c = formDeleted;
                    }
                    fmsSubscribe.Saved_Search_Id__c = searchObjId;
                    fmsSubscribe.User_Name__c = UserInfo.getUserId();
                    fmsSubscribe.Subscribed_Date__c = System.today();
					if(!check){
						fmsSubscribe.SavedSearchKey__c = searchObjId;
						check=true;
					}
                    fmsSubscibeList.add(fmsSubscribe);
                }
                if (fmsSubscibeList != null && fmsSubscibeList.size() > 0) {
                    
                    try{
                        insert fmsSubscibeList;
                    } catch(Exception e){
                        UtilityCls.saveExceptionLog(FMSSubscribeSearchCtrl.class.getName(), 'submit()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                    }

                }
            }
            else{
                modifySubscription(fmsSubscriptionList);
            }  
        }
 
        PageReference pageRef = new PageReference('/apex/FormManagementMainPage');
        pageRef.setRedirect(true);
        return pageRef;    
    }
    
    private void modifySubscription(List<FMS_Subscription__c> fmsSubscriptionLstval ){
        for (FMS_Subscription__c fmsSubscribe: fmsSubscriptionLstval) {
            if (allEvents) {
                fmsSubscribe.Form_Inserted__c = true;
                fmsSubscribe.Form_Status_Change__c = true;
                fmsSubscribe.Form_Updated__c = true;
                fmsSubscribe.Form_Deleted__c = true;
            } else {
                fmsSubscribe.Form_Inserted__c = formCreated;
                fmsSubscribe.Form_Status_Change__c = formStatusChange;
                fmsSubscribe.Form_Updated__c = formEdited;
                fmsSubscribe.Form_Deleted__c = formDeleted;
                if(!(formCreated || formStatusChange || formEdited || formDeleted)){
                    fmsSubscribe.unsubscribed_date__c  = System.today();    
                }  
            }
            
            fmsSubscibeList.add(fmsSubscribe);
        }
        If(fmsSubscibeList != null && fmsSubscibeList.size() > 0) {
            
            try{
                update fmsSubscibeList;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSSubscribeSearchCtrl.class.getName(), 'modifySubscription(List<FMS_Subscription__c> fmsSubscriptionLstval )', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

        }
    }
    
}