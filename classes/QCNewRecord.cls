/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QCNewRecord class. It is used to create Quality Certificate.
 *             It contains Quality Certificate creation business logic.
 * History:
 * <Vijay>     04032014 - updated the 'Save&New' functionality implementation logic 
 *
 * <Amit Kumar Ojha>     10102017 - resolved Collection Size Issue 
 */
public without sharing class QCNewRecord {
   public Map<String,String> custMap = new Map<String,String>();
    public String account;
    //public ClsNewCPKReport ClsNewCPKReportIns;
    public Boolean checkSaveMethod;
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
    public Quality_Certificate__c QualityCert{get; set;} 
    public String operation {get;set;}
    public static final String OPERATION_SAVENEW = 'savenew';
    
    public QCNewRecord(ApexPages.StandardController controller) 
    {
        
        QualityCert = (Quality_Certificate__c )controller.getRecord();

    }
     public QCNewRecord()
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
         //ClsNewCPKReportIns = new ClsNewCPKReport();
         iserror=false;
         PageReference returnUrl;
         if((QualityCert.Certificate_Title__c != null
                 || QualityCert.Certificate_Title__c != '')
                 && (QualityCert.Certificate_Type__c != null
                 || QualityCert.Certificate_Type__c != '')
                 && QualityCert.FABs__c != null
                 && QualityCert.Expiry_Date__c!=null
                 && QualityCert.Effective_Date__c != NULL
                 && QualityCert.Certificate_Type__c!=null)
         {
             
             try
             {
                 Insert QualityCert;
                 CustomerList(QualityCert.id);
                 
                 /*
                 if(checkSaveMethod==False)
                         {
                         returnUrl = page.VfQCNewRecord;
                         }
                 else
                        {
                        returnUrl = new PageReference('/'+QualityCert.id);
                        }
                 returnUrl.setRedirect(true);   
                 //return returnUrl; 
                 */
                 
             return null;             
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
    public Quality_Certificate__c QueryRecord;
    public PageReference Createfolder() {

        PageReference returnUrl;
        if(!iserror){
            try{
                
                
                QueryRecord=[Select Id,name,OpenTextId__c from Quality_Certificate__c where Id=:QualityCert.id];
                String ReportName=QueryRecord.name;
                String CPKOTId=QueryRecord.OpenTextId__c;
                System.debug('&&&&&&'+QueryRecord.id);
                System.debug('&&&&&&'+ReportName);
                if(CPKOTId==null || CPKOTId==''){
                
                    String StatusMessage;
                    QualityService.QACreateFolderService_pt Folderequest = new QualityService.QACreateFolderService_pt();
                    Folderequest.timeout_x=120000;
                    List<QualityService.CreateFolderRequest_element> lstFCrequests = new List<QualityService.CreateFolderRequest_element>();
                    
                    List<QualityService.Response> FCresponse = new List<QualityService.Response>();
                    QualityService.CreateFolderRequest_element FCrequest= new QualityService.CreateFolderRequest_element();
                    List<QualityService.CreateFolder> FolderList=new List<QualityService.CreateFolder>();
                    QualityService.CreateFolder createfolderrequest = new QualityService.CreateFolder();
                    createfolderrequest.Source='QC';
                    createfolderrequest.OpenTextId='';
                    //createfolderrequest.ParentOpenTextId=Quality__c.getInstance('QualityParentFolderId').FolderId__c;
                    createfolderrequest.FolderName=ReportName;
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
                    
                    System.debug('))))))))'+FCResponse[0].Status);
                        if(FCResponse[0].Status.contains('Success')){
                            List<String> OTIds=new list<String>(FCResponse[0].OpenTextId.split(';'));
                            Queryrecord.OpenTextId__c=OTIds[0];
                            Queryrecord.OpenTextIdPublish__c=OTIds[1];
                            database.update(Queryrecord);
                            StatusMessage='Folder Created Successfully in OpenText';
                            if(!String.isBlank(operation) && operation == OPERATION_SAVENEW){
                                QualityCert = new Quality_Certificate__c();
                                returnUrl = page.VfQCNewRecord;
                                returnUrl.setRedirect(true);
                            }else{
                                returnUrl = new PageReference('/'+QueryRecord.id);
                            }                   
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,StatusMessage);
                            ApexPages.addMessage(myMsg);
                            return returnUrl;
                        
                        }
                        else{
                        
                            StatusMessage=FCResponse[0].ErrorMessage;
                            System.debug('----->'+StatusMessage);
                            //returnUrl = page.VfQCNewRecord;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,StatusMessage);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
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
    } 
     
    public PageReference saveNew() 
    {
        //checkSaveMethod = False;
        PageReference returl= saving();
        return returl;
    }
    
     public void resetAccount()
    {
       List<Account> accList =New List<Account>();
       List<Account> accList1 =New List<Account>();
       
       /*** Commented by Hitesh 20.11.2017 to remove Collection Size Issue
       if(rightvalues != null)
        {
        accList = [Select Name,Short_Name__c,Stage__c,Id ,Record_Type_Name__c 
                    From Account 
                    where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category and id not in:rightvalues ];//category //'Customer'
        }
        else
        {
        accList = [Select Name,Short_Name__c,Stage__c,Id ,Record_Type_Name__c 
                    From Account 
                    where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category  ];//category //'Customer'  
        }
        if(rightvaluesBlack != null)
        {
        accList1 = [Select Name,Short_Name__c,Stage__c,Id,Record_Type_Name__c 
                    From Account 
                    where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category1 and id not in:rightvaluesBlack  ];//category //'Customer'
        }
        else
        {
        accList1 = [Select Name,Short_Name__c,Stage__c,Id,Record_Type_Name__c 
                    From Account 
                    where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category1  ];//category //'Customer'  
        }
        **/
        // Start: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code
        
        if(rightvalues != null)
        {
        if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
        accList = [Select Name,Short_Name__c,Stage__c,Id ,Record_Type_Name__c 
                    From Account 
                    where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
        }
        else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
        accList = [Select Name,Short_Name__c,Stage__c,Id 
                    From Account 
                    where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and id not in:rightvalues ];//category //'Customer'
           }
        }
        else
        {
        if(category != '' && category != 'Auth Customer' && category == 'Qual Customer') {
               accList = [Select Name,Short_Name__c,Stage__c,Id 
                            From Account 
                            where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           } 
           else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer') {
               accList = [Select Name,Short_Name__c,Stage__c,Id 
                            From Account 
                            where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           }  
        }
        if(rightvaluesBlack != null)
        {
        if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer') {
        accList1 = [Select Name,Short_Name__c,Stage__c,Id ,Record_Type_Name__c 
                    From Account 
                    where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and id not in:rightvaluesBlack ];//category //'Customer'
        }
        else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer') {
        accList1 = [Select Name,Short_Name__c,Stage__c,Id 
                    From Account 
                    where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and id not in:rightvaluesBlack ];//category //'Customer'
                    
           }
        }
        else
        {
        if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer') {
               accList1 = [Select Name,Short_Name__c,Stage__c,Id 
                            From Account 
                            where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           } 
           else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer') {
               accList1 = [Select Name,Short_Name__c,Stage__c,Id 
                            From Account 
                            where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer'];//category //'Customer'
           }  
        }
        // End: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code    
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
   List<QC_Access_List__c> QcAccessList = new List<QC_Access_List__c>(); 
   System.debug('------>+custidBlack'+custidBlack );
    if(custidBlack != null && custidBlack.size() > 0)
        {
       for(String customerId : custidBlack)
            {
             custBlackNull = False;
             system.debug('INSIDE THE CUSTOER lIST');
             QC_Access_List__c qcAccessins = new QC_Access_List__c(); 
             qcAccessins.Account__c = customerId;
             qcAccessins.Quality_Certificate__c= recId;
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
                 QC_Access_List__c qcAccessins = new QC_Access_List__c(); 
                 qcAccessins.Account__c = customerId;
                 qcAccessins.Quality_Certificate__c= recId;
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
             
             QC_Access_List__c qcAccessins = new QC_Access_List__c(); 
             qcAccessins.Account__c = acctId;
             qcAccessins.Quality_Certificate__c= recId;
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
     
                        
      public void shareToQAandPIDetail(Map<Id,Set<ID>> userGrpMap)
    {
      system.debug('Sharing the record'+userGrpMap);
        List<Quality_Certificate__share> qcShareList = new List<Quality_Certificate__share>();
        for(ID mapIdins : userGrpMap.keySet())
        {
            for(ID idins : userGrpMap.get(mapIdins))
            {
            Quality_Certificate__share qcShare = new Quality_Certificate__share();
            qcShare.ParentId = mapIdins ;
            qcShare.UserOrGroupId = idins;
            qcShare.AccessLevel = 'Edit';
            qcShareList.add(qcShare);
            }
            system.debug('Sharing the record cpkReportShareList'+qcShareList);
        }
        try
        {
            System.debug('**************'+qcShareList);
            Database.SaveResult[] srList= Database.insert(qcShareList,false);
            system.debug('Record Shared'+srList);     
            for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted Sharing records');
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
}    
        }
        catch(Exception ex)
        {
        system.debug('The exception occured during inserting share rule');  
        }
      }
     
    
    public List<SelectOption> getPopulateCustomerSelectOptionBlack()
    {
       List<SelectOption> custListBlack = new List<SelectOption>();
       List<Account> accList =New List<Account>();
            /*** Commented by Hitesh 20.11.2017 to remove Collection Size Issue
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category1 and (id not in:rightvaluesBlack and id not in:rightvalues)  ];//category //'Customer'
            **/
            
            // Start: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code  
            if(category1 != '' && category1 != 'Auth Customer' && category1 != 'Qual Customer') {
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category1 and (id not in:rightvaluesBlack and id not in:rightvalues) ];//category //'Customer'
       
            } 
            else if(category1 != '' && category1 != 'Qual Customer' && category1 == 'Auth Customer') {
            
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and (id not in:rightvaluesBlack and id not in:rightvalues) ];//category //'Customer'
       
            } 
            else if(category1 != '' && category1 != 'Auth Customer' && category1 == 'Qual Customer') {
            
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and (id not in:rightvaluesBlack and id not in:rightvalues) ];//category //'Customer'
       
            }
            // End: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code  
            
            if(accList !=null && accList.size()>0){ 
                leftvaluesBlack.clear();
                for(Account acc : accList){
                   
                    custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
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
       
       /*** Commented by Hitesh 20.11.2017 to remove Collection Size Issue
       
       accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category and (id not in:rightvalues and id not in:rightvaluesBlack) ];//category //'Customer'
       **/
        
       // Start: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code       
       if(category != '' && category != 'Auth Customer' && category != 'Qual Customer'){
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c != 'Inactive' and Stage__c != 'Unqualified' and Stage__c != 'Qualified' and Record_Type_Name__c=:category and (id not in:rightvalues and id not in:rightvaluesBlack) ];//category //'Customer'
       
        }
        else if(category != '' && category != 'Qual Customer' && category == 'Auth Customer'){
            
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c = 'Authorized' and Record_Type_Name__c = 'Customer' and (id not in:rightvalues and id not in:rightvaluesBlack) ];//category //'Customer'
       
            
        }
        else if(category != '' && category != 'Auth Customer' && category == 'Qual Customer'){
            
            accList = [Select Name,Short_Name__c,Stage__c,Id 
                        From Account 
                        where Stage__c = 'Qualified' and Record_Type_Name__c = 'Customer' and (id not in:rightvalues and id not in:rightvaluesBlack) ];//category //'Customer'
       
        }
        // End: [Hitesh] 20.11.2017 Added Changes in place of the Commented Code
       
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
    
    public static void  CreateDeleteObject(Map<String,String> MapId)
    {
        System.debug('CreateDeleteObject---'+mapId);
        List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
        List<DeleteObjectFromOpenText__c> DeleteObjectInsertList = new List<DeleteObjectFromOpenText__c>();
        DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c = 'SUCCESS'limit 999];
        for(String id: MapId.keySet())        
        {
            System.debug('id---'+id);
            System.debug('MapId.get(id)---'+MapId.get(id));
            for(String otid : MapId.get(id).split(';')){
                System.debug('otid ---'+otid );
                    if(otid!=null && otid!=''){
                        DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
                        //deleteobjectIns.OpenTextId__c = MapId.get(id);
                        deleteobjectIns.OpenTextId__c = otid;
                        deleteobjectIns.SFDCId__c = id;
                        deleteobjectIns.Source__c = 'QC';
                        DeleteObjectInsertList.add(deleteobjectIns);
                    }
                }
        }
    try
    {
    System.debug('DeleteObjectList ---'+DeleteObjectList );
        System.debug('DeleteObjectInsertList---'+DeleteObjectInsertList);
    if(DeleteObjectList != null && DeleteObjectList.size() > 0)
    delete DeleteObjectList; 
    insert DeleteObjectInsertList;
    
    }
    catch(Exception e)
    {
        system.debug('Exception during deleteobject Insertion or deletion is'+e);
    }
    }
    
}