/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a PWCA_PublicationCls class. It is used to create PWCA Publication.
 *             It contains PWCA Publication creation business logic.
 * History:
 * <Vijay>     04032014 - updated catch exception block in SavePwcaRecord method 
                          updated Createfolder method.
 * <Vijay>     29032014 - updated the 'Save&New' functionality implementation logic
 *
 * <Amit Kumar Ojha>     10102017 - resolved Collection Size Issue 
 */
public with sharing class PWCA_PublicationCls{

    public PWCA_publication__c pwcaObj {get;set;}
    public string category {get;set;}
    //Below Code is for Customer Selection component
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public Set<String> leftvalues = new Set<String>();
    public Set<String> rightvalues = new Set<String>();
    public Map<String,String> custMap = new Map<String,String>();
    public Set<ID> custid = new Set<ID>();
    // end of Customer Selection Component
    public String operation {get;set;}
    public static final String OPERATION_SAVENEW = 'savenew';
    
    public PWCA_PublicationCls(ApexPages.StandardController controller){
    
        pwcaObj = new PWCA_publication__c();
        pwcaObj.Document_Status__c = 'Preliminary';
        leftselected = new List<String>();
        rightselected = new List<String>();
        
    }
    
    List<PWCAAssociated_Customers__c> customerLst;
    public boolean isError {get;set;}
    // Save PWCA Record and Associated customers for PWCA Record
    public pageReference SavePwcaRecord(){
    isError=false;    
        try {
            if (pwcaObj.Technology_Node__c!=null && 
                pwcaObj.Valid_Till__c!=null &&
                pwcaObj.Lot_ID__c!=null && 
                pwcaObj.Wafer_ID__c!=null && 
                pwcaObj.Device_ID__c!=null &&
                pwcaObj.No_of_Metal_Layers__c!=null && 
                pwcaObj.Regional_Site_Approval__c!=null && 
                pwcaObj.TypeOfDocument__c!=null &&
                pwcaObj.Type_of_Metal_Layers__c!=null && 
                pwcaobj.Dopants_Used_for_Implantation__c!=null &&
                pwcaobj.Fab__c!=null && 
                pwcaobj.Lot_Id__c!='' &&
                pwcaobj.Wafer_Id__c!='' &&
                pwcaobj.Report_Date__c  != NULL &&
                pwcaobj.Device_Id__c!=''){
                // Insert PWCA Record
                
                insert pwcaObj;
                if (pwcaObj.Id!= null){
                    shareAssociatedCustomers(pwcaObj.Id);   
                }
            }else{
                isError=true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter All mandatory fields marked with red.');
                ApexPages.addMessage(errorMsg);
                return null;
            }
            return null;
        }catch(Exception e){
            isError=true;
            if(!ApexPages.hasMessages()){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected error has occurred, please contact to system administrator');
                ApexPages.addMessage(errorMsg);
            }
        }
        return null;
    }
    
    public PWCA_publication__c QueryRecord;
    
    public PageReference Createfolder(){
    
    PageReference returnUrl;
    if(!isError){
    
        try{
        
        
            //QueryRecord=[Select Id,name,OpenTextId__c from PWCA_publication__c where Id=:pwcaObj.id]; Commented code on 03-07-2014
            List<PWCA_publication__c> pwcaPublicationList = [Select Id,name,OpenTextId__c from PWCA_publication__c where Id=:pwcaObj.id];
            if(pwcaPublicationList != null && !pwcaPublicationList.isEmpty()){
                QueryRecord = pwcaPublicationList[0];           
                //String ReportName=QueryRecord.name;       Commented code on 03-07-2014
                //String CPKOTId=QueryRecord.OpenTextId__c;     Commented code on 03-07-2014
                //if(CPKOTId==null || CPKOTId==''){ Commented code on 03-07-2014
                if(QueryRecord.OpenTextId__c == null || QueryRecord.OpenTextId__c == ''){
                    String StatusMessage;
                    QualityService.QACreateFolderService_pt Folderequest = new QualityService.QACreateFolderService_pt();
                    Folderequest.timeout_x=120000;
                    List<QualityService.CreateFolderRequest_element> lstFCrequests = new List<QualityService.CreateFolderRequest_element>();
                    
                    List<QualityService.Response> FCresponse = new List<QualityService.Response>();
                    QualityService.CreateFolderRequest_element FCrequest= new QualityService.CreateFolderRequest_element();
                    List<QualityService.CreateFolder> FolderList=new List<QualityService.CreateFolder>();
                    QualityService.CreateFolder createfolderrequest = new QualityService.CreateFolder();
                    createfolderrequest.Source='PWCA';
                    createfolderrequest.OpenTextId='';
                    //createfolderrequest.ParentOpenTextId=Quality__c.getInstance('QualityParentFolderId').FolderId__c;
                    //createfolderrequest.FolderName=ReportName;    Commented code on 03-07-2014
                    createfolderrequest.FolderName = QueryRecord.name;
                    FolderList.add(createfolderrequest);
                    FCrequest.CreateFolderList=FolderList;
                    lstFCrequests.add(FCrequest);
                    if(!Test.isRunningTest()){
                     if(Environment_Variable__c.getInstance('ROS_GEForm_certificate_enable').value__c != 'false'){
                    Folderequest.clientCertName_x=Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
                    }
                    FCResponse=Folderequest.CreateFolder(FolderList);    
                    }
                    else
                    {
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
                            if(!String.isBlank(operation) && operation == OPERATION_SAVENEW){
                                pwcaObj = new PWCA_publication__c();
                                returnUrl = Page.PWCA_PublicationPage;
                                returnUrl.setRedirect(true);
                            }else{
                                returnUrl = new PageReference('/'+QueryRecord.id);
                            }  
                            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,StatusMessage);
                            //ApexPages.addMessage(myMsg);
                            return returnUrl;
                        
                        }
                        else{
                        
                            StatusMessage=FCResponse[0].ErrorMessage;
                            //returnUrl = page.VfQCNewRecord;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,StatusMessage);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                }
            }
        }catch(Exception e)
        {
            ApexPages.addMessages(e);
            return null;    
        }
    }
    else if(iserror){
    
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter All mandatory fields marked with red.');
    ApexPages.addMessage(myMsg);
    return null;
    
    
    }
return null;
} 
    
    public PageReference saveNew() {
        //checkSaveMethod=False;
       /*
        PageReference returl = SavePwcaRecord();
        if (returl != null){
            pwcaObj = null;
            if (!rightvalues.isEmpty()){
                rightvalues.clear(); 
            }
            return new pageReference('/apex/PWCA_PublicationPage');
        }
        */
        SavePwcaRecord();
        return null;
    }    
    
    public PageReference cancle(){
    
        return new pageReference('/a5i/o');
    }
    
    // CODE FOR CUSTOMER SELECTION 
    
     public void resetAccount()
    {
        //renderIfQA = sectionAccessToQA();
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
           } else if(category != '' && category == 'Qual Customer' && category == 'Auth Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           }  
        } 
        
        

       
            if(accList !=null && accList.size()>0) 
            { 
            for(Account acc : accList) 
                {
                custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
                leftvalues.add(acc.Id);
                }
            }  
   
    }
    
    
    
    public PageReference selectallclick(){
    //rightvalues.clear();
    leftselected.clear();
    rightselected.clear();
    for(String Usr: leftvalues){
        rightvalues.add(usr);
        leftvalues.remove(usr);
    }   
    return null;  
    }
    
    public Pagereference unselectallclick(){
    //rightvalues.clear();
    leftselected.clear();
    rightselected.clear();
    for(String Usr: rightvalues){
        rightvalues.remove(usr);
        leftvalues.add(usr);
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
           List<Account> accList =New List<Account>();
           
           if(category != '' && category != 'Auth Customer' && category != 'Qual Customer') {
	           accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Record_Type_Name__c=:category and id not in:rightvalues ];//category //'Customer'
           } else if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Authorized' and Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
           } else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
           	   accList = [Select Name,Short_Name__c,Stage__c,Id 
	                        From Account 
	                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
           }
           
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
        
           for(String usr : leftvalues){
              if(custMap.get(usr) != null)
              custList.add(new selectOption(usr ,custMap.get(usr)));  
           }
           //custList.sort();
           return selectOptionSortByLabel(custList);   
      }
      
      public static list<selectOption> selectOptionSortByLabel(list<selectOption> selectOptionsToSort) {
                                                            
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
    
     public List<SelectOption> getPopulateCustomerUnSelectOption(){
      List<selectOption> custListSelected = new List<selectOption>();
      custid = new Set<ID>();
      for(String customer : rightvalues)
      {
         custid.add(ID.valueOf(customer));
         if(custMap.get(customer) != null)
         custListSelected.add(new selectOption(customer ,custMap.get(customer))); 
      }  
        //custListSelected.sort();
       return selectOptionSortByLabel(custListSelected);       
    }
    
    // Function use for sharing all associated customers with PWCA Publication Record
    
    public void shareAssociatedCustomers(Id pwcaId){
         if(custid.isempty()){
             for(Id eachId : custmap.keyset())
             custid.add(Id.valueOf(eachId));
         }
         customerLst = new List<PWCAAssociated_Customers__c>();
         
         for (String accountId : custid){
            PWCAAssociated_Customers__c associatedCustomer = new PWCAAssociated_Customers__c();
            associatedCustomer.Account__c = accountId;
            associatedCustomer.PWCA_Publication__c = pwcaId;
            customerLst.add(associatedCustomer);
         }
        try{        
        if (!customerLst.isEmpty()){
             Database.UpsertResult[] srList=database.Upsert(customerLst,false);
             for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {        
                        System.debug('Successfully inserted' + sr.getId());
                    }
                    else{                        
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            
                        }
            }
            }
        }
        }
         catch(DMLException e)
            {
                System.debug('The Exception happened while inserting therecord'+e);
            }
                
    }
    
    // CODE END FOR CUSTOMER SELECTION
    

}