/*
Author:         Bhavana Mohan
Company:        Cognizant Technology Solution
Description:    

History:
BMohan     24062013     -     Class Creation
AmarPattanaik           -     Class Modified to add new functionality for Fab 9 & 10

History:
Amit Kumar Ojha     10102017    -    Resolved Collection Size Issue

History:
Sandesh Kumar       10012018    -    Resove Null pointer error for Geometry selection & Value population for Gemetry Report Type
*/
public without sharing class ClsNewCPKReport{
    public CPK_Report__c cpkReport{get; set;}
    public String fixedCycleDay{get; set;}
    public Boolean renderIfQA{get;set;}
    public Map<String,String> custMap = new Map<String,String>();
    //yash
    public Map<String,String> ResellercustMap = new Map<String,String>();
    public Map<String,String> EnablementcustMap = new Map<String,String>();
    public string category{get;set;}
    public String account;
    public String fab;
    public Set<ID> custid = new Set<ID>();
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public Set<String> leftvalues = new Set<String>();
    public Set<String> rightvalues = new Set<String>();
    public CPK_Report__c cpkReportIns;
    public Boolean checkSaveMethod;
    public List<Group> grp =new List<Group>();
    public Boolean isError {get;set;}
    public String ErrorMessage;
    public CPK_Report__c QueryRecord;
    public boolean SaveAndNew{get;set;}
    public FAB__c fabsval{get;set;}
    public boolean fabAllASICCust{get;set;}
    public boolean asiccustomerFlag{get;set;}
    List<Account> accListcust;
    
    
    public ClsNewCPKReport(Apexpages.StandardController stdController){

        cpkReport = new CPK_Report__c();
        cpkReportIns = new CPK_Report__c();
        cpkReport = (CPK_Report__c)stdController.getRecord();
        fixedCycleDay  = globalReportCycleDay();
        cpkReport.Report_Cycle_Day__c = fixedCycleDay;
        
        SaveAndNew = false;
        fabsval = new FAB__c();
        fabAllASICCust = true; 
    }

    public ClsNewCPKReport(){
        isError=false;
        cpkReport = new CPK_Report__c();
        leftselected = new List<String>();
        rightselected = new List<String>();
        custMap = new Map<String,String>();
        leftvalues = new Set<String>();
        rightvalues = new Set<String>();
        custid = new Set<ID>();
        fabAllASICCust = true;
        
        
    }

    public PageReference saveNew(){
        checkSaveMethod=False;
        PageReference returl= saving();
        return returl;
    }    
    
    public PageReference Saving(){
        isError=false; 
        if (cpkReport.Technology__c != null && 
            cpkReport.Geometry__c != null &&              
            cpkReport.Reminder__c != null && 
            cpkReport.FABS__C != null && 
            cpkReport.Report_Cycle__c != null && rightvalues.size() != 0){
            
            try{
            
                if(cpkReport.Report_Cycle_Day__c == null){
                    cpkReport.Report_Cycle_Day__c = fixedCycleDay;
                }
                 
                if(!String.isBlank(cpkReport.Report_Cycle_Day__c) && cpkReport.Reminder__c != NULL){
                    cpkReport.Remind_To_Upload__c = cpkReport.Reminder__c - Integer.valueOf(cpkReport.Report_Cycle_Day__c);
                }
                insert cpkReport;  
                addCustomerList(cpkReport.Id);
                                     
                return null; 
            }
            catch(Exception ex){
                isError=true;
                Errormessage=ex.getdmlMessage(0);
                ApexPages.addMessages(ex); 
            }
        }
        else{
            isError=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'All Fields Marked Required Should Have a Value');
            ApexPages.addMessage(myMsg);
            
        }
        return null;
    }
    
    public PageReference Createfolder(){
        PageReference returnUrl;
        if(isError==false && Environment_Variable__c.getInstance('CPK_service_enable').value__c != 'false'){
            try{
                QueryRecord=[Select Id,name,OpenTextId__c,OpenTextIdPublish__c,ASIC_Report__c,For_All_ASIC_Customers__c from CPK_Report__c where Id=:cpkReport.id];
                String ReportName=QueryRecord.name;
                String CPKOTId=QueryRecord.OpenTextId__c;
                String Asic = QueryRecord.ASIC_Report__c;
                String allAsic = QueryRecord.For_All_ASIC_Customers__c;
                String isAsicValue='True'; 
                if(Asic== null || Asic==''){
                    isAsicValue ='False';
                }else if(Asic=='ASIC' && allAsic=='NO'){
                    isAsicValue ='False';
                    System.debug('isAsicValue'+isAsicValue);
                }else if(Asic=='Geometry' && allAsic=='YES'){
                    isAsicValue ='False'; 
                }else if(Asic=='Geometry' && allAsic=='NO'){
                    isAsicValue ='False'; 
                } 
                else{
                    isAsicValue ='True';
                    System.debug('isAsicValue'+isAsicValue);
                } 
                
                if(CPKOTId==null || CPKOTId==''){
                    String StatusMessage;
                    QualityService.QACreateFolderService_pt Folderequest = new QualityService.QACreateFolderService_pt(); 
                    Folderequest.timeout_x=120000;
                    List<QualityService.CreateFolderRequest_element> lstFCrequests = new List<QualityService.CreateFolderRequest_element>();
                    
                    List<QualityService.Response> FCresponse = new List<QualityService.Response>(); 
                    QualityService.CreateFolderRequest_element FCrequest= new QualityService.CreateFolderRequest_element();
                    List<QualityService.CreateFolder> FolderList=new List<QualityService.CreateFolder>();
                    QualityService.CreateFolder createfolderrequest = new QualityService.CreateFolder();
                    createfolderrequest.Source='CPK';
                    createfolderrequest.OpenTextId=''; 
                    createfolderrequest.IsASIC=isAsicValue;
                    createfolderrequest.FolderName=ReportName;
                    FolderList.add(createfolderrequest); 
                    FCrequest.CreateFolderList=FolderList;
                    lstFCrequests.add(FCrequest);
                    
                    if(!Test.isRunningTest()){
                        
                                Folderequest.clientCertName_x=Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
                        
                        FCResponse=Folderequest.CreateFolder(FolderList);
                    }
                    else{
                        List<QualityService.Response> FCDummyresponse=new List<QualityService.Response>();
                        QualityService.Response res=new QualityService.Response();
                        res.Status='Success';
                        res.OpenTextId='1222222'+';'+'1234567';
                        FCDummyresponse.add(res);
                        FCResponse=FCDummyresponse;
                    }
                     
                    if(FCResponse[0].Status.contains('Success')){
                        List<String> OTIds=new list<String>(FCResponse[0].OpenTextId.split(';'));
                        Queryrecord.OpenTextId__c=OTIds[0];
                        Queryrecord.OpenTextIdPublish__c=OTIds[1];
                        database.update(Queryrecord);
                        StatusMessage='Folder Created Successfully in OpenText';
                        List<CPK_Report__c> cpkreportInsertIns = new List<CPK_Report__c>(); 
                        if(!SaveAndNew){
                            returnUrl = new PageReference('/'+QueryRecord.id);
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,StatusMessage);
                            ApexPages.addMessage(myMsg);
                            return returnUrl;
                        }else{
                            returnUrl = new PageReference('/apex/VfNewCpkReport');
                            returnUrl.setRedirect(true);
                            return returnUrl;
                        }
                    }
                    else{
                        StatusMessage=FCResponse[0].ErrorMessage; 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,StatusMessage);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                return null;  
              
            }catch(DMLException e){ApexPages.addMessages(e);return null;
            }
        }else{ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Errormessage);
            ApexPages.addMessage(myMsg);
            return null;
        }
    }


    public String globalReportCycleDay(){
        return getCustomSettingData('CPKReportCycleDay');
    }
    
    public String getCustomSettingData(String custSettingName){
        map<String,Environment_Variable__c> reportCycleDayCustomSetting = new map<String,Environment_Variable__c>();
        reportCycleDayCustomSetting = Environment_Variable__c.getAll();
        Environment_Variable__c cpkReportCycleDayValue = reportCycleDayCustomSetting.get(custSettingName);
        return cpkReportCycleDayValue.Value__c; 
    }

    public Boolean sectionAccessToQA(){
        List<Group> grp = new List<Group>();
        Boolean QAUser = False;
        Set<String> profileNames = new Set<String>();
        Map<String,CpkProfileToAddPI__c> profileInfoCustomSetting = new Map<String,CpkProfileToAddPI__c>();
        profileInfoCustomSetting = CpkProfileToAddPI__c.getAll();   
        profileNames = profileInfoCustomSetting.keySet();
        Profile userProfile = [Select p.Name, p.Id From Profile p where p.Id =: userinfo.getProfileId() limit 1];
        grp = [Select g.Name, g.Id From Group g where g.Name =: System.Label.CPK_Access_To_QA limit 1];
        if(grp != null && grp.size()>0){
            for (GroupMember grpMem : [Select Id, UserOrGroupId From GroupMember Where GroupId = :grp.get(0).Id]){
                if(grpMem.UserOrGroupId == UserInfo.getUserId()){
                    QAUser =True ;
                }
            }
        }
        if(profileNames.contains(userProfile.Name) || QAUser)
            return true;
        else
            return false; 
    }
    

    public void addCustomerList(ID recId){
        List<CPK_Report_Access_List__c> cpkReportAccessList = new List<CPK_Report_Access_List__c>();  
        if(!CustId.isEmpty()){
            for(String customerId : custid){
                CPK_Report_Access_List__c cpkAccessList = new CPK_Report_Access_List__c();
                cpkAccessList.Account__c = customerId;
                cpkAccessList.CPK_Report__c = recId;
                cpkReportAccessList.add(cpkAccessList); 
            }
        }else{ 
            for(String customerId : custMap.keyset()){
                CPK_Report_Access_List__c cpkAccessList = new CPK_Report_Access_List__c();
                cpkAccessList.Account__c = customerId;
                cpkAccessList.CPK_Report__c = recId;
                cpkReportAccessList.add(cpkAccessList); 
            }
        }
        
        try{
            Database.SaveResult[] srList=database.insert(cpkReportAccessList,false);
            for (Database.SaveResult sr : srList){
                if (sr.isSuccess()) { 
                }
                else{
                    for(Database.Error err : sr.getErrors()) { 
                        
                    }
                }
            }
        }catch(DMLException e){ 
        }
    }
    
    public void resetAccount(){
        renderIfQA = sectionAccessToQA(); 
        
        List<Account> accList =New List<Account>();
        if(rightvalues != null)
        {
           if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Authorized' and Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
           } else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
           }
        }
        else
        {
           if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Authorized' and Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           } else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           }  
        }
        
        if(accList !=null && accList.size()>0){ 
            leftvalues.clear();
            for(Account acc : accList){
               
                custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvalues.add(acc.Id);
            }
        } else {
            leftvalues.clear();
        }
      
        
    }
    
    
    //Amar Smruti Pattanaik
    //This method is used to populate and hide the select list
    public pageReference populateSelectList(){
    fabAllASICCust = true; 
            if(cpkReport.For_All_ASIC_Customers__c=='Yes' && cpkReport.ASIC_Report__c=='ASIC'){ 
                custid = new Set<ID>();
                fabAllASICCust = false;
                leftselected.clear();
                rightselected.clear();
                Map<Id,Account> tempMap = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c FROM Account WHERE Id IN: leftvalues]);
                leftvalues = new Set<String>();
                for(Account acc: tempMap.values()){
                    if(acc.Authorized_for_ASIC_business__c == 'Yes'){ 
                        leftvalues.add(acc.Id);
                    }
                }  
                for(String usr : leftvalues){
                    leftvalues.remove(usr);
                    rightvalues.add(usr);
                }
                for(String customer : rightvalues){ 
                        custid.add(ID.valueOf(customer));
                    }
             
            
            }else if(cpkReport.For_All_ASIC_Customers__c=='No' && cpkReport.ASIC_Report__c=='ASIC')
                { 
                    fabAllASICCust = true;
                    leftselected.clear();
                    rightselected.clear();
                    Map<Id,Account> tempMap = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c FROM Account WHERE Id IN: rightvalues]);
                    rightvalues = new Set<String>();
                    for(Account acc: tempMap.values()){
                        if(acc.Authorized_for_ASIC_business__c == 'Yes'){ 
                            rightvalues.add(acc.Id);
                        }
                    }
                    for(String usr : rightvalues){
                        leftvalues.add(usr);
                        rightvalues.remove(usr);
                    } 
            }else if(cpkReport.For_All_ASIC_Customers__c=='Yes' && cpkReport.ASIC_Report__c=='Geometry')
                { 
                    custid = new Set<ID>();
                    //Sandesh: Show & Hide "For All Customers?" picklist uncommented fabAllASICCust 
                    fabAllASICCust = false;
                    leftselected.clear();
                    rightselected.clear();
                    Map<Id,Account> tempMap = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c,Tech_Geo_Granted__c FROM Account WHERE Id IN: leftvalues]);
                    leftvalues = new Set<String>();
                    for(Account acc: tempMap.values()){
                    	if(acc.Tech_Geo_Granted__c != null && cpkReport.Geometry__c !=null){
                         if(acc.Tech_Geo_Granted__c.contains(cpkReport.Geometry__c)){ 
                            leftvalues.add(acc.Id);
                        	}
                        }
                        else if(acc.Tech_Geo_Granted__c != null){
                         	leftvalues.add(acc.Id);       
                         }
                    }  
                    for(String usr : leftvalues){
                        leftvalues.remove(usr);
                        rightvalues.add(usr);
                    }
                    if(rightvalues.size() == 0){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Customer is assigned with selected geometry value');
                        ApexPages.addMessage(myMsg);
                    }else{
                        fabAllASICCust = false;
                    }
                    for(String customer : rightvalues){ 
                            custid.add(ID.valueOf(customer));
                    } 
            } else if(cpkReport.For_All_ASIC_Customers__c=='No' && cpkReport.ASIC_Report__c=='Geometry')
                { 
                    fabAllASICCust = true;
                    leftselected.clear();
                    rightselected.clear();
                    Map<Id,Account> tempMap = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c,Tech_Geo_Granted__c FROM Account WHERE Id IN: rightvalues]);
                    rightvalues = new Set<String>();
                    for(Account acc: tempMap.values()){
                         if(acc.Tech_Geo_Granted__c !=null && cpkReport.Geometry__c !=null && acc.Tech_Geo_Granted__c.contains(cpkReport.Geometry__c)){ 
                            rightvalues.add(acc.Id);
                        }
                        else if(acc.Tech_Geo_Granted__c !=null){
                            rightvalues.add(acc.Id);
                        }
                    }
                    for(String usr : rightvalues){
                        leftvalues.add(usr);
                        rightvalues.remove(usr);
                    } 
            }  
              
        return null;
    }
    
    public pageReference selectallClick(){
        leftselected.clear();
        rightselected.clear();
        for(String usr : leftvalues){
            leftvalues.remove(usr);
            rightvalues.add(usr);
        }
        return null;
    }
    
    public pageReference unselectallclick(){
        leftselected.clear();
        rightselected.clear();
        for(String usr : rightvalues){
            leftvalues.add(usr);
            rightvalues.remove(usr);   
        }
        
        return null;
    }
    
    public PageReference selectclick(){
        rightselected.clear(); 
        for(String usr : leftselected){
            leftvalues.remove(usr);
            rightvalues.add(usr);
        }
        leftselected.clear();
    return null;
    }

    public PageReference unselectclick(){
        leftselected.clear(); 
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        rightselected.clear();
        
        return null;
    }
     
     public List<SelectOption> getPopulateCustomerSelectOption(){
        List<SelectOption> custList = new List<SelectOption>(); 
        
        //yash
        
        accListcust = New List<Account>();
        List<Account> tempAccList = new List<Account>();
        /*** Commented by Amit 11.10.2017 to remove Collection Size Issue 
        tempAccList = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Tech_Geo_Granted__c, 
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Qualified'
                            AND Record_Type_Name__c=:category 
                            AND id NOT IN:rightvalues];
        ****/
        // [Amit] 11.10.2017 Added Changes Added in place of the Commented Code
        if(category != '' && category != 'Auth Customer' && category != 'Qual Customer') {
        	tempAccList = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Tech_Geo_Granted__c, 
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Qualified'
                            AND Record_Type_Name__c=:category 
                            AND id NOT IN:rightvalues];	
        } else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
        	tempAccList = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Tech_Geo_Granted__c, 
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Qualified'
                            AND Stage__c = 'Authorized'
                            AND Record_Type_Name__c = 'Customer'
                            AND id NOT IN:rightvalues];
        } else if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
        	tempAccList = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Tech_Geo_Granted__c, 
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Authorized'
                            AND Stage__c = 'Qualified'
                            AND Record_Type_Name__c = 'Customer'
                            AND id NOT IN:rightvalues];
        }
        // [Amit] End Changes
        
        if(cpkReport.ASIC_Report__c == 'ASIC'){ 

            for(Account ac : tempAccList){
                    if(ac.Authorized_for_ASIC_business__c == 'YES'){
                    accListcust.add(ac);
                }
            }
            
        }else if(cpkReport.ASIC_Report__c == 'Geometry'){ 
            for(Account ac : tempAccList){
				if(ac.Tech_Geo_Granted__c != null && cpkReport.Geometry__c !=null){ //Added Null Check filter for Geometry
                    if(ac.Tech_Geo_Granted__c.contains(cpkReport.Geometry__c)){
                    accListcust.add(ac);
                    }	
				}
                else if(ac.Tech_Geo_Granted__c != null){ //Added else block to consider all customer account with type Geometry
                    	accListcust.add(ac);
                	}
            } 
        } else {
        	/*** Commented by Amit 11.10.2017 to remove Collection Size Issue
            accListcust = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Record_Type_Name__c=:category 
                            AND id NOT IN:rightvalues ];//category //'Customer'
            ****/
        	// [Amit] 11.10.2017 Added Changes Added in place of the Commented Code  
        	if(category != '' && category != 'Auth Customer' && category != 'Qual Customer') {
        		accListcust = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Record_Type_Name__c=:category 
                            AND id NOT IN:rightvalues ];	
        	} else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
        		accListcust = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Qualified'
                            AND Stage__c = 'Authorized' 
                            AND Record_Type_Name__c = 'Customer'
                            AND id NOT IN:rightvalues ];
        	} else if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
        		accListcust = [SELECT Name,
                                  Short_Name__c,
                                  Stage__c,
                                  Authorized_for_ASIC_business__c,
                                  Id 
                            FROM  Account 
                            WHERE Stage__c != 'Inactive' 
                            AND Stage__c != 'Unqualified'
                            AND Stage__c != 'Authorized'
                            AND Stage__c = 'Qualified' 
                            AND Record_Type_Name__c = 'Customer'
                            AND id NOT IN:rightvalues ];
        	}
        	// [Amit] End Changes              
        }
       
        if(accListcust !=null && accListcust.size()>0){ 
            leftvalues.clear();
            for(Account acc : accListcust){
               
                custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvalues.add(acc.Id);
            }
        }
        else
        {
            leftvalues.clear();
        }
        
        for(String usr : leftvalues){
            if(custMap.get(usr) != null)
            custList.add(new selectOption(usr ,custMap.get(usr)));  
        }
        //custList.sort();
        return selectOptionSortByLabel(custList);   
    }
    public List<SelectOption> getPopulateCustomerUnSelectOption(){
        List<selectOption> custListSelected = new List<selectOption>();
        custid = new Set<ID>(); 
        for(String customer : rightvalues){
             
            custid.add(ID.valueOf(customer));
            if(custMap.get(customer) != null)
                custListSelected.add(new selectOption(customer ,custMap.get(customer))); 
             
        } 
       
         
        return selectOptionSortByLabel(custListSelected);
    }
    
    public static list<selectOption> selectOptionSortByLabel(list<selectOption> selectOptionsToSort){
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
    public void clickbtn(){
        rightvalues.clear();
        fabAllASICCust=true;
    }
}