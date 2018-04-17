/*
Type Name: AttachFeedItemController
Author: JK Technosoft Ltd (Ravi Teja B)
Reason: This class is used to attach files as feed items.

Change History:
Author: 
Modified Date: 
Reason: Merged 
Change History: 

History:
Hitesh Madan     21-12-2017    -    Resolve Collection Size Issue
*/
public without sharing class EHSNewRecord {
    public Map<String,String> custMap = new Map<String,String>();
    public String account;    
    public string category{get;set;}
    public string category1{get;set;}
    public List<ID> custid = new List<ID>();
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public Set<String> leftvalues = new Set<String>();
    public Set<String> rightvalues = new Set<String>();
    public Map<String,String> custMapBlack = new Map<String,String>();
    public Set<ID> custidBlack = new Set<ID>();
    public List<string> leftselectedBlack{get;set;}
    public List<string> rightselectedBlack{get;set;}
    public Set<String> leftvaluesBlack = new Set<String>();
    public Set<String> rightvaluesBlack = new Set<String>();
    public set<ID> usrSetToShare = new set<ID>();
    public Other_EHS_CSR_Certificate__c QualityCert{get; set;} 
    public String operation {get;set;}
    public static final String OPERATION_SAVENEW = 'savenew';
    Public String rectypId;
    public String rectypName {get; set;}
    public String baseQuery = 'Select Name,Short_Name__c,Stage__c,Id, Record_Type_Name__c From Account'; // Added by Hitesh. To resolve collection size issue.
    
    
    public EHSNewRecord(ApexPages.StandardController controller) 
    {
        QualityCert = (Other_EHS_CSR_Certificate__c )controller.getRecord();
        rectypId = apexpages.currentpage().getparameters().get('RecordType');
        if(rectypId != null){
            rectypName = [select Id,Name from RecordType where Id =:rectypId].Name;
            system.debug('rectypName***'+rectypName);
        }
        else{
            User u = [Select Profile.Name from User where Id=:UserInfo.getUserId()];
            EHS_BCM_IN_Profile_RT_Access__c EBICustSet = EHS_BCM_IN_Profile_RT_Access__c.getInstance(u.Profile.Name);
            if(EBICustSet != null){
                List<RecordType> rt = [Select Id,Name from Recordtype where SobjectType = 'Other_EHS_CSR_Certificate__c' and Name =: EBICustSet.RecordTypeName__c];
                if(rt.size() > 0){
                    rectypId = rt[0].Id;
                    rectypName = rt[0].Name;
                    system.debug('rectypName***'+rectypName);
                }
            }
        }
    }
    public EHSNewRecord()
    { 
        leftselected = new List<String>();
        rightselected = new List<String>();
        custMap = new Map<String,String>();
        leftvalues = new Set<String>();
        rightvalues = new Set<String>();
        custid = new List<ID>();
        leftselectedBlack = new List<String>();
        rightselectedBlack = new List<String>();
        custMapBlack = new Map<String,String>();
        leftvaluesBlack = new Set<String>();
        rightvaluesBlack = new Set<String>();
        custidBlack = new Set<ID>();
    }
    public boolean iserror {get;set;}
    Public String ErrorMessage;
    public PageReference saving()
    {
        list<Other_EHS_CSR_Certificate__c> ehslst = new list<Other_EHS_CSR_Certificate__c>();
        iserror=false;
        PageReference returnUrl;
        if(
            
            ((QualityCert.Certificate_Title__c != null
              || QualityCert.Certificate_Title__c != '')
             && (QualityCert.Certificate_Type__c != null
                 || QualityCert.Certificate_Type__c != '')
             && QualityCert.FABs__c != null
             && QualityCert.Expiry_Date__c!=null
             && QualityCert.Effective_Date__c != NULL
             && QualityCert.Certificate_Type__c!=null
             && rectypName != 'Impact Notification')||
            (
                (QualityCert.Issue_Description__c!= null
                 || QualityCert.Issue_Description__c!= '')
                &&QualityCert.Date_of_Occurrence__c!= null               
                && QualityCert.FABs__c != null
                && rectypName == 'Impact Notification')                 
        )                 
        {
            try
            {
                Insert QualityCert;
                CustomerList(QualityCert.id);
                return new PageReference('/'+QualityCert.Id);             
            }
            Catch(Exception ex)
            {
                isError=true;
                Errormessage=ex.getdmlMessage(0);
                ApexPages.addMessages(ex);
                System.debug('DML Exception on Insertion'+ex);
                
            }
            
            
        }
        else
        {   
            iserror=true;
            Errormessage='All Fields Marked Required Should Have a Value';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'All Fields Marked Required Should Have a Value');
            ApexPages.addMessage(myMsg);
        }
        return null;
        
    }
    
    
    public PageReference saveNew() 
    {
        try{
            saving();
            return new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/VfEHSNewRecord?RecordType='+apexpages.currentpage().getparameters().get('RecordType')+'&retURL=aAr/o');
        }
        Catch(Exception ex)
            {
                isError=true;
                Errormessage=ex.getdmlMessage(0);
                ApexPages.addMessages(ex);
                System.debug('DML Exception on Insertion'+ex);
                
            }
        return null;
    }
    
    public void resetAccount()
    {
        List<Account> accList =New List<Account>();
        List<Account> accList1 =New List<Account>();     
        
        // Start: [21-12-2017][Hitesh] To resolve collection size issue. 
        String filter;
        String filterBlack;
        String query;
        
        if(rightvalues != null){   
            if(category != '' && category != 'Auth Customer' && category == 'Qual Customer'){
                filter = ' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\' and id not in:rightvalues';
                
            }
            else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer'){
                filter = ' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\' and id not in:rightvalues';
            }
        }
        else{
            if(category != '' && category != 'Auth Customer' && category == 'Qual Customer'){
                filter = ' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\'';
            } 
            else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer'){
                filter = ' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\'';
            } 
        }
        if(rightvaluesBlack != null){
            if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer'){
                filterBlack = ' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\' and id not in:rightvaluesBlack';
            }
            else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer'){
                filterBlack = ' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\' and id not in:rightvaluesBlack'; 
            }
        }
        else{
            if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer'){
                filterBlack = ' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\'';
            }
            else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer'){
                filterBlack = ' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\'';
            }
        }
        if(!String.isBlank(filter)){
            query = baseQuery + filter;
            accList = Database.Query(query);
        }
        if(!String.isBlank(filterBlack)){
            query = baseQuery + filterBlack;
            accList1 = Database.Query(query);
        }
        // End: [21-12-2017][Hitesh] To resolve collection size issue.
        
        if(accList !=null && accList.size()>0) 
        { 
            for(Account acc : accList) 
            {
                custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvalues.add(acc.Id);
                
            }
        }
        if(accList1 !=null && accList1.size()>0) 
        { 
            for(Account acc : accList1) 
            {
                custMapBlack.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvaluesBlack.add(acc.Id);
                
            }
        } 
    }
    
    public void CustomerList(ID recId)
    {
        Boolean custBlackNull = True;
        Boolean custWhiteNull = True;
        List<EHS_Access_List__c> QcAccessList = new List<EHS_Access_List__c>(); 
        System.debug('------>+custidBlack'+custidBlack );
        if(custidBlack != null && custidBlack.size() > 0)
        {
            for(String customerId : custidBlack)
            {
                custBlackNull = False;
                system.debug('INSIDE THE CUSTOER lIST');
                EHS_Access_List__c qcAccessins = new EHS_Access_List__c(); 
                qcAccessins.Account__c = customerId;
                qcAccessins.Other_EHS_CSR_Disclosures__c= recId;
                qcAccessins.Customer_Black_List__c = customerId;
                qcAccessins.checkSource__c =True;
                QcAccessList.add(qcAccessins);
            }
        }
        System.debug('------>+custid'+custid);
        if(custid != null && custid.size() > 0)
        {     
            for(String customerId : custid)
            {
                custWhiteNull = False;
                system.debug('INSIDE THE CUSTOER white lIST');
                if(!custidblack.contains(customerId )){
                    EHS_Access_List__c qcAccessins = new EHS_Access_List__c(); 
                    qcAccessins.Account__c = customerId;
                    qcAccessins.Other_EHS_CSR_Disclosures__c= recId;
                    qcAccessins.Customer_White_List__c = customerId;
                    qcAccessins.checkSource__c =True;
                    QcAccessList.add(qcAccessins);
                }
            }
        }
        System.debug('------>+custWhiteNull'+custWhiteNull+'}}}}}}}}}'+custMap);
        if(custWhiteNull)
        {
            system.debug('INSIDE THE CUSTOMER '+custMap);
            for(Id acctId : custMap.keySet())
            {
                if(!custidblack.contains(acctId)){
                    
                    EHS_Access_List__c qcAccessins = new EHS_Access_List__c(); 
                    qcAccessins.Account__c = acctId;
                    qcAccessins.Other_EHS_CSR_Disclosures__c= recId;
                    qcAccessins.Customer_White_List__c = acctId;
                    qcAccessins.checkSource__c =True;
                    QcAccessList.add(qcAccessins);   
                }         
            }
        }
        
        try
        {
            system.debug('INSIDE THE CUSTOER lIST'+QcAccessList);
            Database.SaveResult[] srList=database.insert (QcAccessList,false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {        
                    System.debug('Successfully inserted account' + sr.getId());
                }
                else{                        
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        
                    }
                }
            }
        }
        catch(DMLException e)
        {
            System.debug('The Exception happened while inserting the sharing record'+e);
        }
        
    }
    
    public List<SelectOption> getPopulateCustomerSelectOptionBlack()
    {
        List<SelectOption> custListBlack = new List<SelectOption>();
        List<Account> accList =New List<Account>();
        
        // Start: [21-12-2017][Hitesh] To resolve collection size issue.
        String query;
        String filter;
                
        if(category1 != '' && category1 != 'Auth Customer' && category1 != 'Qual Customer'){
            filter = ' where (Stage__c = \'Active\' OR Stage__c = \'Authorized\' OR Stage__c = \'Qualified\') and Record_Type_Name__c=:category1'; 
            
        }else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer'){
            filter = ' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\'';
            
        }else if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer'){
            filter = ' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\'';
        }
        if(rightvalues != null && !String.isBlank(filter)){
            filter = filter + ' and id not in:rightvalues';         
        }
        if(rightvaluesBlack != null && !String.isBlank(filter)){
            filter = filter + ' and id not in:rightvaluesBlack';            
        }
        if(!String.isBlank(filter)){
            query = baseQuery + filter;
            accList = Database.Query(query);
        }
         // End: [21-12-2017][Hitesh] To resolve collection size issue.
		
		if(accList !=null && accList.size()>0){ 
            leftvaluesBlack.clear();
            for(Account acc : accList){
                custMapBlack.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvaluesBlack.add(acc.Id);
            }
        }
        else
        {
            leftvaluesBlack.clear();
        }
        for(String usr : leftvaluesBlack)
        {
            if(custMapBlack.get(usr) != null)
                custListBlack.add(new selectOption(usr ,custMapBlack.get(usr)));  
        }
        //custList.sort();
        return selectOptionSortByLabel(custListBlack);   
    }
    
    public static list<selectOption> selectOptionSortByLabel(list<selectOption>
                                                             selectOptionsToSort) {
                                                                 if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
                                                                     return selectOptionsToSort;
                                                                 }
                                                                 List<SelectOption> lessSelectOption = new List<SelectOption>();
                                                                 List<SelectOption> greaterSelectOption = new List<SelectOption>();
                                                                 integer pivot = selectOptionsToSort.size() / 2;
                                                                 
                                                                 //save the pivot and remove it from the selectOption list
                                                                 SelectOption pivotValue = selectOptionsToSort[pivot];
                                                                 selectOptionsToSort.remove(pivot);
                                                                 for(selectOption SO : selectOptionsToSort){
                                                                     if(SO.getLabel() <= pivotValue.getLabel()){
                                                                         lessSelectOption.add(SO);
                                                                     }else if(SO.getLabel() > pivotValue.getLabel()){
                                                                         greaterSelectOption.add(SO);   
                                                                     }
                                                                 }
                                                                 list<selectOption> sortedSelectOptions = new list<selectOption>(); 
                                                                 sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
                                                                 sortedSelectOptions.add(pivotValue);
                                                                 sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
                                                                 return SortedSelectOptions;
                                                             }
    
    public PageReference selectclickBlack(){
        rightselectedBlack.clear();
        for(String usr : leftselectedBlack){
            leftvaluesBlack.remove(usr);
            rightvaluesBlack.add(usr);
            leftvalues.remove(usr);
            
        }
        leftselectedBlack.clear();
        return null;
    }
    
    public PageReference unselectclickBlack(){
        leftselectedBlack.clear();
        for(String s : rightselectedBlack){
            rightvaluesBlack.remove(s);
            leftvaluesBlack.add(s);
            leftvalues.add(s);
        }
        rightselectedBlack.clear();
        return null;
    }
    
    public List<SelectOption> getPopulateCustomerUnSelectOptionBlack(){
        List<selectOption> custListSelectedBlack = new List<selectOption>();
        custidBlack = new Set<ID>();
        for(String customer : rightvaluesBlack)
        {
            custidBlack.add(ID.valueOf(customer));
            if(custMapBlack.get(customer) != null)
                custListSelectedBlack.add(new selectOption(customer ,custMapBlack.get(customer))); 
        }  
        //custListSelected.sort();
        return selectOptionSortByLabel(custListSelectedBlack);
    }
    public List<SelectOption> getPopulateCustomerSelectOption()
    {   
        List<SelectOption> custList = new List<SelectOption>();
        List<Account> accList =New List<Account>();
        // Start: [21-12-2017][Hitesh] To resolve collection size issue. 
        String query;
        String filter;
        
        if(category != '' && category != 'Auth Customer' && category != 'Qual Customer'){
            filter =' where (Stage__c = \'Active\' OR Stage__c = \'Authorized\' OR Stage__c = \'Qualified\') and Record_Type_Name__c=:category';                
                
        }else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer'){
            filter =' where Stage__c = \'Authorized\' and Record_Type_Name__c = \'Customer\'';
            
        }else if(category != '' && category != 'Auth Customer' && category == 'Qual Customer'){
            filter =' where Stage__c = \'Qualified\' and Record_Type_Name__c = \'Customer\'';
       
        }
        if(rightvalues != null && !String.isBlank(filter)){
            filter = filter + ' and id not in:rightvalues';         
        }
        if(rightvaluesBlack != null && !String.isBlank(filter)){
            filter = filter + ' and id not in:rightvaluesBlack';            
        }
        if(!String.isBlank(filter)){
            query = baseQuery + filter;
            accList = Database.Query(query);
        }
        // End: [21-12-2017][Hitesh] To resolve collection size issue.
		
		if(accList !=null && accList.size()>0){ 
            leftvalues.clear();
            for(Account acc : accList){
                
                custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvalues.add(acc.Id);
            }
        }
        else
        {
            leftvalues.clear();
        }
        for(String usr : leftvalues)
        {
            if(custMap.get(usr) != null)
                custList.add(new selectOption(usr ,custMap.get(usr)));  
        }
        //custList.sort();
        return selectOptionSortByLabel(custList);   
    }
    
    public PageReference selectallclick(){
        
        for(String usr : leftvalues){
            rightvalues.add(usr);
            leftvaluesBlack.remove(usr);
            
        }    
        leftselected.clear();
        rightselected.clear();
        leftselectedBlack.clear();
        rightselectedBlack.clear();
        leftvalues.clear();
        //leftvaluesblack.clear();
        //rightvaluesblack.clear();
        return null;    
    }
    
    public PageReference selectallblackclick(){
        
        for(String usr : leftvaluesBlack){
            rightvaluesBlack.add(usr); 
            leftvalues.remove(usr);                   
        }    
        leftselected.clear();
        rightselected.clear();
        leftselectedBlack.clear();
        rightselectedBlack.clear();
        //leftvalues.clear();
        //rightvalues.clear();
        leftvaluesblack.clear();
        return null;   
        
        
    }
    public PageReference selectclick(){
        rightselected.clear();
        for(String usr : leftselected){
            leftvalues.remove(usr);
            rightvalues.add(usr);
            leftvaluesBlack.remove(usr);
        }
        leftselected.clear();
        return null;
    }
    
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
            leftvaluesBlack.add(s);
        }
        rightselected.clear();
        return null;
    }
    
    public PageReference unselectallclick(){
        leftselected.clear();
        rightselected.clear();
        
        for(String s : rightvalues){
            
            rightvalues.remove(s);
            leftvalues.add(s);
            leftvaluesBlack.add(s);    
            
        }
        
        return null;
    }
    
    
    public PageReference unselectallblackclick(){
        leftselectedBlack.clear();
        for(String s : rightvaluesBlack){
            rightvaluesBlack.remove(s);
            leftvaluesBlack.add(s);
            leftvalues.add(s);
        }
        rightselectedBlack.clear();
        return null;
    }
    
    public List<SelectOption> getPopulateCustomerUnSelectOption(){
        List<selectOption> custListSelected = new List<selectOption>();
        custid = new List<ID>();
        for(String customer : rightvalues)
        {
            custid.add(ID.valueOf(customer));
            if(custMap.get(customer) != null)
                custListSelected.add(new selectOption(customer ,custMap.get(customer))); 
        }  
        //custListSelected.sort();
        return selectOptionSortByLabel(custListSelected);
    }
    
    Public Other_EHS_CSR_Certificate__c QueryRecord;
    public PageReference Createfolder() {
        
        PageReference returnUrl;
        if(!iserror){
            try{
                
                
                QueryRecord=[Select Id,name,Date_of_Occurrence__c,Issue_Description__c,Certificate_Title__c, Certificate_Type__c, FABs__c, Expiry_Date__c, Effective_Date__c from Other_EHS_CSR_Certificate__c where Id=:QualityCert.id];
                String ReportName=QueryRecord.name;
                
                
                String StatusMessage='Success';
                
                
                if(StatusMessage.contains('Success')){
                    
                    database.update(Queryrecord);
                    
                    if(!String.isBlank(operation) && operation == OPERATION_SAVENEW){
                        QualityCert = new Other_EHS_CSR_Certificate__c();
                        returnUrl = page.VfEHSNewRecord;
                        returnUrl.setRedirect(true);
                    }else{
                        returnUrl = new PageReference('/'+QueryRecord.id);
                    }                   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,StatusMessage);
                    ApexPages.addMessage(myMsg);
                    return returnUrl;
                    
                }
                else{
                    
                    System.debug('----->'+StatusMessage);
                    returnUrl = page.VfEHSNewRecord;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,StatusMessage);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                
                return null;  
            }catch(DMLException e){
                ApexPages.addMessages(e);
                return null;
            }
        }else{
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Errormessage);
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return null;
    } 
    
    
}