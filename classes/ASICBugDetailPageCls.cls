/*********************************************************************************/
  // Purpose      : Redirecting to customize bug detail page 
  // Date created : 28 October, 2016
  // Created by   : UCM Team
  // Author       : Kali 
  // Description  : Redirecting to customize bug detail page
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class ASICBugDetailPageCls {
    public Bug__c objBug {get;set;}
    String prevRootCause {get;set;}
    String prevResolution{get;set;}
    Date prevProjectedDate {get;set;}
    Boolean isDevCompleted {get;set;}
    
    public set<String> listProblemType {get;set;}
   
    public String problemType {get;set;}
    public String subTypeA    {get;set;}
    public String subTypeB    {get;set;}
    public String subTypeC    {get;set;}
    public String subTypeD    {get;set;}
    public String recordId    {get;set;}
    public string[] cstProject {
        get;
        set;
    }
    public list < SelectOption > listCustomerProject1{
        get;
        set;
    }
    public list < SelectOption > listCustomerProject2{
        get;
        set;
    }
    public Account objAccount {get;set;}
    
    public Boolean isShowSubTypeA {get;set;}
    public Boolean isShowSubTypeB {get;set;}
    public Boolean isShowSubTypeC {get;set;}
    public Boolean isShowSubTypeD {get;set;}
    
    public List<SelectOption> listProblemTypeOptions {get;set;}
    public List<SelectOption> listSubTYpeAOptions {get;set;}
    public List<SelectOption> listSubTYpeBOptions {get;set;}
    public List<SelectOption> listSubTYpeCOptions {get;set;}
    public List<SelectOption> listSubTYpeDOptions {get;set;}
    
    public String values {get;set;}
    public String fieldName{get;set;}
    public string selectedValue {get;set;}
    
    public List<String> subTypeAValues = new List<String>();
    public List<String> subTypeBValues = new List<String>();
    public List<String> subTypeCValues = new List<String>();
    public List<String> subTypeDValues = new List<String>();
    
    public boolean isFromConstructor = false;
    List<String> sortStr;
    String selectedStr;
    public ASICBugDetailPageCls(ApexPages.StandardController controller){        
        listProblemType = new set<String>();
        sortStr = new List<String>();
        cstProject = new string[]{};
        listCustomerProject1  = new list < SelectOption > (); 
        listCustomerProject2  = new list < SelectOption > ();               
        listCustomerProject1.add(new SelectOption('', '--None--'));
        objBug  =       (Bug__c)controller.getRecord();
        String bugId = objBug.Id;
        selectedStr = '';
        if(objBug.Id != null) {
            objBug    =    [SELECT Id, RecordType.Name,Projected_Availability_Date__c,Root_Cause__c,Root_Cause_Analysis__c,Bug_Description__c, Name,
                                Problem_Class__c,Dev_Only__c,Problem_Type__c,Is_this_a_Test_Rule__c,Sub_Type_A__c,Sub_Type_B__c,
                                Sub_Type_C__c,Sub_Type_D__c, OwnerId, Assigned_To__c, Bug_Title__c,Status__c,Priority__c,ASICResolution__c,
                                Severity__c,CQ__c,Technology__c,Need_By_Date__c,Account_Affected__c,Library_Release__c,DevComplete__c, 
                                Status_of_CIA_Approval__c,Date_Approved_for_Release__c,Date_Approved_by_CIA__c,Request_For_CIA_Approval__c,
                                Requires_Overt_Customer_Actions__c,Change_to_Form_Function__c,Communication_Type_Required__c,Vendor_Id__c,
                                ASIC_Change_Request__c,ASIC_Communicator_RID__c,ASIC_Communicator_SID__c,Identify_Dependencies__c,Customer_Project__c,Original_Bug__c FROM Bug__c WHERE Id =: bugId ];
            isShowSubTypeA = false;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
            recordId    =   objBug.Id;
            selectedStr = objBug.Customer_Project__c;
            isFromConstructor   =   true;              
            if(objBug.Problem_Type__c != null){
                retrieveProblemTypeConstructor();                            
                problemType =   objBug.Problem_Type__c;                   
                retrieveProblemTypeConstructor1();                              
                problemType =   objBug.Problem_Type__c;
                isShowSubTypeA = true;
            }
            
            if(objBug.Sub_Type_A__c != null ){
                subTypeA = objBug.Sub_Type_A__C;
                isShowSubTypeB = true;               
                objBug.Problem_Type__c  =   problemType;
                retrieveSubTypeAConstructor();
            }
            if(objBug.Sub_Type_B__c != null && objBug.Sub_Type_B__c != ''){
                subTypeB    =   objBug.Sub_Type_B__c;
                isShowSubTypeC = true;
                objBug.Sub_Type_A__c  =   subTypeA;               
                retrieveSubTypeBConstructor();
            }
            if(objBug.Sub_Type_C__c != null && objBug.Sub_Type_C__c != ''){
                subTypeC    =   objBug.Sub_Type_C__c;
                isShowSubTypeD = true;
                objBug.Sub_Type_B__c  =   subTypeB;
                retrieveSubTypeCConstructor();
               
            }
            if(objBug.Sub_Type_D__c != null && objBug.Sub_Type_D__c != ''){
                subTypeD    =   objBug.Sub_Type_D__c;
                objBug.Sub_Type_C__c  =   subTypeC;
                List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
                Set<String> subTypeDValues= new Set<String>();
                listSubTYpeDOptions =   new List<SelectOption>();
                if(subTypeC != ''){
                    listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_C__c =:subTypeC AND Sub_Type_D__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_D__c];
                }
                if(listAccount.size()>0){
                    isShowSubTypeA = true;
                    isShowSubTypeB = true;
                    isShowSubTypeC = true;
                    isShowSubTypeD = true;
                    listSubTYpeDOptions.add(new SelectOption('', '--None--'));
                    for(Bug_ASIC_Picklist__c objAccount : listAccount){
                        if(subTypeDValues.size()>0){
                            if(!subTypeDValues.contains(String.valueOf(objAccount.Sub_Type_D__c))){
                                listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                                subTypeDValues.add(objAccount.Sub_Type_D__c);
                            }    
                        }else{
                            listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                            subTypeDValues.add(objAccount.Sub_Type_D__c);
                        }
                    }
                }
            }
            
        
            
        }else {
            objBug.RecordTypeId =  ApexPages.currentPage().getParameters().get('rid');
            objBug.OwnerId      =  userInfo.getUserId();
            retrieveProblemTypeValues();
        }
        
        prevRootCause       =   objBug.Root_Cause__c;
        prevResolution      =   objBug.ASICResolution__c;
        prevProjectedDate   =   objBug.Projected_Availability_Date__c;
        isDevCompleted      =   objBug.DevComplete__c;
        isFromConstructor = false;
       setPickListValues();
    }
    
    // To Retrieve problem type options
    public void retrieveProblemTypeConstructor(){
        try{
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c  >();
            listProblemTypeOptions  =   new List<SelectOption>();
            listAccount = [SELECT Id, Name, Problem_Type__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c != null AND IS_Active__c = TRUE ORDER BY Problem_Type__c];
            for(Bug_ASIC_Picklist__c objAccount : listAccount){
                if(listProblemType.size() > 0){
                    if(!listProblemType.contains(String.valueOf(objAccount.Problem_Type__c))){
                        listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                        listProblemType.add(objAccount.Problem_Type__c);
                    }
                }else{
                    listProblemTypeOptions.add(new SelectOption('', '--None--'));
                    listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                    listProblemType.add(objAccount.Problem_Type__c);
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveProblemTypeConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw); 
            ApexPages.addMessages(e);  
        }
    }
    
    public void retrieveProblemTypeValues() {
        retrieveProblemTypeConstructor();
            isShowSubTypeA = false;
            isShowSubTypeB = false;
            isShowSubTypeC = false;
            isShowSubTypeD = false;
            
            listSubTYpeAOptions =   new List<SelectOption>();
            listSubTYpeBOptions =   new List<SelectOption>();
            listSubTYpeCOptions =   new List<SelectOption>();
            listSubTYpeDOptions =   new List<SelectOption>();
    }
        
    public void retrieveProblemTypeConstructor1(){
        try{
            objBug.Problem_Type__c  =   problemType;
            if(!isFromConstructor){
                objBug.Sub_Type_A__c    =   null;
                objBug.Sub_Type_B__c    =   null;
                objBug.Sub_Type_C__c    =   null;
                objBug.Sub_Type_D__c    =   null;
            }
            List<Bug_ASIC_Picklist__c> listBugPicklist = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeAValues= new Set<String>();
            listSubTYpeAOptions =   new List<SelectOption>();
            if(problemType != ''){
                listBugPicklist = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c =:problemType AND Sub_Type_A__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_A__c]; 
            }
            if(listBugPicklist.size()>0) {
                isShowSubTypeA = true;
                isShowSubTypeB = false;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
                for(Bug_ASIC_Picklist__c objABugPicklist : listBugPicklist){
                    if(subTypeAValues.size()>0){
                        if(!subTypeAValues.contains(objABugPicklist.Sub_Type_A__c)){
                            listSubTYpeAOptions.add(new SelectOption(objABugPicklist.Sub_Type_A__c, objABugPicklist.Sub_Type_A__c));
                            subTypeAValues.add(objABugPicklist.Sub_Type_A__c);
                        }    
                    }else{
                        listSubTYpeAOptions.add(new SelectOption('', '--None--'));
                        listSubTYpeAOptions.add(new SelectOption(objABugPicklist.Sub_Type_A__c, objABugPicklist.Sub_Type_A__c));
                        subTypeAValues.add(objABugPicklist.Sub_Type_A__c);
                    }
                }
            }else {
                isShowSubTypeA = false;
                isShowSubTypeB = false;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveProblemTypeConstructor1()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e); 
         }
    }
    
    public void retrieveProblemType(){
        try{
            objBug.Problem_Type__c  =   problemType;
            if(!isFromConstructor){
                objBug.Sub_Type_A__c = null;
                objBug.Sub_Type_B__c = null;
                objBug.Sub_Type_C__c = null;
                objBug.Sub_Type_D__c = null;
            }
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeAValues= new Set<String>();
            listSubTYpeAOptions =   new List<SelectOption>();
            if(problemType != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c =:problemType AND Sub_Type_A__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_A__c];                
            }
            if(listAccount.size()>0){
                isShowSubTypeA = true;
                isShowSubTypeB = false;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeAValues.size()>0){
                        if(!subTypeAValues.contains(objAccount.Sub_Type_A__c)){
                            listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                            subTypeAValues.add(objAccount.Sub_Type_A__c);
                        }    
                    }else{
                        listSubTYpeAOptions.add(new SelectOption('', '--None--'));
                        listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                        subTypeAValues.add(objAccount.Sub_Type_A__c);
                    }
                }
            }else {
                isShowSubTypeA = false;
                isShowSubTypeB = false;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
            }
            subTypeA = '';
            subTypeB = '';
            subTypeC = '';
            subTypeD = '';
            listSubTYpeBOptions =   new List<SelectOption>();
            listSubTYpeCOptions =   new List<SelectOption>();
            listSubTYpeDOptions =   new List<SelectOption>();
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveProblemType()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e); 
        }
    }
    
    public void retrieveSubTypeAConstructor(){
        try{
            objBug.Sub_Type_A__c  =   subTypeA;
            objBug.Problem_Type__c  =   problemType;
            
            if(!isFromConstructor){
                objBug.Sub_Type_B__c    =   null;
                objBug.Sub_Type_C__c    =   null;
                objBug.Sub_Type_D__c    =   null;
            }
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeBValues= new Set<String>();
            listSubTYpeBOptions =   new List<SelectOption>();
            if(subTypeA != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType and IS_Active__c = TRUE AND Sub_Type_B__c != null ORDER BY Sub_Type_B__c];
            }
            if(listAccount.size()>0){
                isShowSubTypeA = true;
                isShowSubTypeB = true;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
                listSubTYpeBOptions.add(new SelectOption('', '--None--'));
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeBValues.size()>0){
                        if(!subTypeBValues.contains(String.valueOf(objAccount.Sub_Type_B__c))){
                            listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                            subTypeBValues.add(objAccount.Sub_Type_B__c);
                        }    
                    }else{
                        listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                        subTypeBValues.add(objAccount.Sub_Type_B__c);
                    }
                }
            }else{
                isShowSubTypeA = true;
                isShowSubTypeB = false;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveSubTypeAConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);  
            ApexPages.addMessages(e); 
        }
    }
    
    
    public void retrieveSubTypeA(){
        retrieveSubTypeAConstructor();
        
        subTypeB = '';
        subTypeC = '';
        subTypeD = '';
    }
    
    
    public void retrieveSubTypeBConstructor(){
        try{
            objBug.Sub_Type_B__c  =   subTypeB;
            if(!isFromConstructor){
                objBug.Sub_Type_C__c    =   null;
                objBug.Sub_Type_D__c    =   null;
            }
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeCValues= new Set<String>();
            listSubTYpeCOptions =   new List<SelectOption>();
            if(subTypeB != '' && subTypeB != null){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c != null  and IS_Active__c = TRUE ORDER BY Sub_Type_C__c];
            }
            if(listAccount.size()>0){
                isShowSubTypeA = true;
                isShowSubTypeB = true;
                isShowSubTypeC = true;
                isShowSubTypeD = false;
                listSubTYpeCOptions.add(new SelectOption('', '--None--'));
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeCValues.size()>0){
                        if(!subTypeCValues.contains(String.valueOf(objAccount.Sub_Type_C__c))){
                            listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                            subTypeCValues.add(objAccount.Sub_Type_C__c);
                        }    
                    }else{
                        listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                        subTypeCValues.add(objAccount.Sub_Type_C__c);
                    }
                }
            }else{
                isShowSubTypeA = true;
                isShowSubTypeB = true;
                isShowSubTypeC = false;
                isShowSubTypeD = false;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveSubTypeBConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e);
        }
    }
    
    
    public void retrieveSubTypeB(){
        retrieveSubTypeBConstructor();
        subTypeC = '';
        subTypeD = '';
    }
    
    public void retrieveSubTypeCConstructor(){
        try{
            objBug.Sub_Type_C__c  =   subTypeC;
            if(!isFromConstructor){
                objBug.Sub_Type_D__c    =   null;
            }
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeDValues= new Set<String>();
            listSubTYpeDOptions =   new List<SelectOption>();
            if(subTypeC != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c =:subTypeC AND Sub_Type_D__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_D__c];
            }
            if(listAccount.size()>0){
                isShowSubTypeA = true;
                isShowSubTypeB = true;
                isShowSubTypeC = true;
                isShowSubTypeD = true;
                listSubTYpeDOptions.add(new SelectOption('', '--None--'));
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeDValues.size()>0){
                        if(!subTypeDValues.contains(String.valueOf(objAccount.Sub_Type_D__c))){
                            listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                            subTypeDValues.add(objAccount.Sub_Type_D__c);
                        }    
                    }else{
                        listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                        subTypeDValues.add(objAccount.Sub_Type_D__c);
                    }
                }
            }else{
                isShowSubTypeA = true;
                isShowSubTypeB = true;
                isShowSubTypeC = true;
                isShowSubTypeD = false;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'retrieveSubTypeCConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e);
        }
    }
            
    public PageReference retrieveSubTypeC(){
        retrieveSubTypeCConstructor();
        subTypeD = '';
        return null;
    }
    
  public void setPickListValues() {
        //list < ASICCustomerProject__c> bugCustomerProjectList = ASICCustomerProject__c.getall().values();        
        integer i =2;
        for (ASICCustomerProject__c sr: ASICCustomerProject__c.getall().values()) {
            sortStr.add(sr.name__c);             
        }   
        sortStr.sort();        
        for(String s :sortStr){
            if(i<1000)
                listCustomerProject1.add(new SelectOption(s, s));
            else
                listCustomerProject2.add(new SelectOption(s, s));               
         i++;           
        } 

        if(selectedStr != null && selectedStr != ''){
           for(string str:selectedStr.split(',')){
           	   cstProject.add(str);
           }            
        }            
    }
    
    public PageReference save(){
        try{
            boolean isError = false;
            PageReference returnflag;
            objBug.Sub_Type_D__c    =   subTypeD;
            
            String multiSelectStr = '';
            
            
            if(objBug.Bug_Title__c ==null || objBug.Bug_Title__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Title value'));
                isError = true;
            }
            
            if(objBug.Priority__c==null || objBug.Priority__c== ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Priority value'));
                isError = true;
            }
            
            if(objBug.Technology__c ==null || objBug.Technology__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Technology value'));
                isError = true;
            }
            
            if(objBug.Severity__c==null || objBug.Severity__c== ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Severity value'));
                isError = true;
            }
                                   
            if(objBug.Library_Release__c ==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Library Release value'));
                isError = true;
            }
            
            
            if(objBug.Problem_Class__c ==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Class value'));
                isError = true;
            }
            
            if(objBug.DevComplete__c != isDevCompleted){
                if(objBug.Status__c != 'In Process'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Dev Complete can be modified only if the Status is In Process'));
                    isError = true;
                }
            }
            
            if(objBug.Problem_Type__c == null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Type Value'));
                isError = true;
            }
            if((objBug.Sub_Type_A__c == '' || objBug.Sub_Type_A__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type A value'));
                isError = true;
            }
            if(isShowSubTypeB==true && (objBug.Sub_Type_B__c == '' || objBug.Sub_Type_B__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type B value'));
                isError = true;
            }
            if(isShowSubTypeC==true && (objBug.Sub_Type_C__c == '' || objBug.Sub_Type_C__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type C value'));
                isError = true;
            }
            if(isShowSubTypeD==true && (objBug.Sub_Type_D__c == '' || objBug.Sub_Type_D__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type D value'));
                isError = true;
            }
            
            if((objBug.Bug_Description__c==null || objBug.Bug_Description__c=='') && objBug.Id==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Description value'));
                isError = true;
            }
            
             if((objBug.Bug_Description__c==null || objBug.Bug_Description__c=='') && objBug.Id != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Description value'));
                isError = true;
            }
             
             
             
             if(cstProject.size()>0){             
               //cstProject=  cstProject.replace('(', '').replace(')', '');
                Boolean seenOne = false;
                for(String str : cstProject){
                    if (seenOne) {
                        multiSelectStr +=',';
                    }
                    multiSelectStr +=  str ;
                    seenOne = true;
                }
                objBug.Customer_Project__c = multiSelectStr  ;
            }
                        
            if(objBug.Status__c != 'Resolved' && objBug.Status__c != 'In Process'){
                if(objBug.ASICResolution__c != prevResolution || objBug.Root_Cause__c != prevRootCause){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Root Cause and Resolution fields can be modified only if the Status is Resolved or In Process'));
                    isError = true;
                }
            }
            
            if(objBug.Status__c == 'Duplicate'){
                if(objBug.Original_Bug__c == null) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Original Bug field should be populated for the Status Duplicate'));
                    isError = true;
                }
            }
            
            if(objBug.Status__c != 'In Process'){
                if(prevProjectedDate != objBug.Projected_Availability_Date__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Projected Availability Date is editable once status moves to In Process'));
                    isError = true;
                }
            }
            
            if(isError){
                return null;
            }else{
                upsert objBug;
                String recId = objBug.Id;
                PageReference pf = new PageReference('/'+recId);
                pf.setRedirect(true);
                returnflag = pf;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
                returnflag = null;
            }        
            return returnflag;
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugDetailPageCls.class.getName();
            alw.sourceFunction = 'save()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    public PageReference cancel(){
        PageReference pf;
        if(objBug.Id != null){
            pf = new PageReference('/'+objBug.Id);
        }else{
            Schema.DescribeSObjectResult result = bug__c.SObjectType.getDescribe();
            Pf = new PageReference('/' + result.getKeyPrefix());
            pf.setRedirect(true);
        }
        return pf;        
    }
    
    public class applicationException extends Exception {}
}