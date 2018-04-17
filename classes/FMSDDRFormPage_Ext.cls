/*
* @ Author :- Anil Kumar Reddy L
* @ Description :- contains the logic for rendering the DDR Form
* @ Date :- 15/07/2016
* @ Change History :-  
* 13-Oct-2016   Inshu Misra         Save button function modification
* 23-Nov-2016   Inshu Misra         to send emails when save button is clicked...#IM
* 6-Dec-2016    Inshu Misra         Added code for exception framework...#IM.
* 3-Jan-2017    Anil Kumar Reddy L  Modified code for Redirection on form Deletion and invalid fields exception.
* 10-Feb-2017   Inshu Misra         to avoid validation on save button click...#IM
* 14-Feb-2017   Anirban Roy         Added to redirect the user to FMS Search page.
* 28-Jun-2017   Abhita Bansal    Removed hard coding and system debugs
* 14-Jul-2017  Inshu Misra      Changed the code for history report
* 18-Jul-2017  Inshu Misra      Modified against #503
* 20-Jul-2017  Ram Rai        Modified against subscription logic
* 25-Aug-2017   Ravindra      Changed the document links to libraries
01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue 
**/
public class FMSDDRFormPage_Ext{
    public Form_Management_System__c formObj {
        get;
        set;
    }
    public Boolean showReport{get;set;}
    public String formId {
        get;
        set;
    }
    public boolean skipvalidation {
        get;
        set;
    }
    public boolean typeOfdataFlag {
        get;
        set;
    }
    public String userType = null;
    public Boolean dispPostDesign{
        get;
        set;
    }
    public Boolean dispReturnReason{
        get;
        set;
    }
    public boolean exitForm{get;set;}
    public List<FMS_Subscription__c> fmsSubscriptionList;
    public FMS_Subscription__c fmsSubscription;
    public boolean subscribeFlag{get;set;}
    // public Map<String, FMSDocumentsLinks__c> FMSdocuments {get;set;}  Commented by Ravindra
    public Map<String, String> FMSdocuments {get;set;}   //Added by Ravindra
    public Map<String,String> invalidInputCheckMap = new Map<String,String>(); 
    public Map<String,String> invalidInpToFieldsMap = new Map<String, String>(); 
    public boolean isInvalidInp{get;set;}
    public String tranx{get;set;}
    //public Map<String,String> invalidInpToFieldsMap{get;set;} 
    public boolean validateCheck{get;set;} 
    public String fieldAPI{get;set;}
    public boolean isPortalUser {get;set;}
    public boolean isFMSAdmin {get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public final String FMS_Admin_Group = EnvironmentVariable.get('FMS_Admin_Group'); 
    public String ddrXleft{get;set;}
    public String ddrYleft{get;set;}
    public String ddrXright{get;set;}
    public String ddrYright{get;set;}
    
    public FMSDDRFormPage_Ext(ApexPages.StandardController controller) {

        exitForm = true;
        showReport = false;
        isInvalidInp = false; 
        validateCheck = false;
        dispPostDesign = false;
        Id FMS_Admin_Group_ID = [SELECT ID,Name FROM Group WHERE DeveloperName = :FMS_Admin_Group].id;
        String userType = Schema.SObjectType.User.getKeyPrefix();
        
        fmsSubscriptionList = new List<FMS_Subscription__c>();
        fmsSubscription = new FMS_Subscription__c();
       
        //Ravindra - Changes Starts for displaying files from Libraries
          //FMSdocuments = FMSDocumentsLinks__c.getAll();
          FMSdocuments =  UtilityCls.getContentList(); 
        //Ravindra - Changes Ends
        
        tranx = ApexPages.currentPage().getParameters().get('tranx');      
        
        if (UserInfo.getUserType() != 'Standard') {
            isPortalUser = true;
        } else {
            isPortalUser = false;
        }

        if (!isPortalUser) {
            for (GroupMember m: [Select Id, UserOrGroupId From GroupMember Where GroupId = :FMS_Admin_Group_ID]) {
                if (((String) m.UserOrGroupId).startsWith(userType)) {
                    grpUsers.add(m.UserOrGroupId);
                }
            }
            if (grpUsers.contains(UserInfo.getUserId())) {
                isFMSAdmin = true;
            } else {
                isFMSAdmin = false;
            }
        }

        skipvalidation = false;
        typeOfdataFlag = false;

        formId = ApexPages.currentPage().getParameters().get('id');

        if (formId != null && formId != '') {
            
            formObj = [SELECT Name, Main_Form_Id__r.ProductName__c, id, State_of_the_Form__c, TypeOfData__c, ReturnReason__c, IsPostDesign__c, Parent_Form_Id__r.RitHold__c, form_type__c,
                       Parent_Form_Id__r.HoldReason__c, Parent_Form_Id__r.PostDesignServices__c, DDRLeftXCoordinate__c, DDRLeftYCoordinate__c, DDRRightXCoordinate__c, Previous_State_Of_Form__c,
                       DDRRightYCoordinate__c,Parent_Form_Id__c , Parent_Form_Id__r.recordtype.Name,Parent_Form_Id__r.RITProductName__c from Form_Management_System__c WHERE id = : formId];
            ddrXleft = formObj.DDRLeftXCoordinate__c == null?'':String.valueOf(formObj.DDRLeftXCoordinate__c);
            ddrYleft = formObj.DDRLeftYCoordinate__c == null?'':String.valueOf(formObj.DDRLeftYCoordinate__c);
            ddrXright = formObj.DDRRightXCoordinate__c == null?'':String.valueOf(formObj.DDRRightXCoordinate__c);
            ddrYright = formObj.DDRRightYCoordinate__c == null?'':String.valueOf(formObj.DDRRightYCoordinate__c);

        }

        if (formObj.TypeOfData__c != null && formObj.TypeOfData__c.contains('Post Design Service (Cheese and Fill)') && formObj.IsPostDesign__c == 'Yes' ) {
            typeOfdataFlag = true;
        } else {
            typeOfdataFlag = false;
        }

        if (formObj.TypeOfData__c != null && formObj.TypeOfData__c.contains('Post Design Service (Cheese and Fill)')) {
            dispPostDesign = true;
        } else {
            dispPostDesign = false;
        }

        if((formObj.Parent_Form_Id__r.RitHold__c == 'Yes' && dispPostDesign && (formObj.Parent_Form_Id__r.HoldReason__c == 'Review Post Design Service (Cheese and Fill) data')) 
            || (formObj.Parent_Form_Id__r.PostDesignServices__c == 'Yes' && dispPostDesign)) {
            dispReturnReason = true;
        } else {
            dispReturnReason = false;
        }
        
        /**Start -- Added By Abhita for Issue 505**/
        subscribeFlag = false;
     // Added the sharing for Subscription Object 1Sept2017 
        fmsSubscriptionList = [Select id,Form_Inserted__c,Form_Status_Change__c,Form_Updated__c,Subscribed_Date__c,UnSubscribed_Date__c, Form_Deleted__c FROM FMS_Subscription__c WHERE Form_Id__c = : formId AND User_Name__c =:UserInfo.getUserId() and UnSubscribed_Date__c=null and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Saved_Search_Id__c=null];
        
        if(fmsSubscriptionList != null && fmsSubscriptionList.size()>0){  
             fmsSubscription = fmsSubscriptionList[0];       
                subscribeFlag = true;
            }
            else{
                subscribeFlag = false;
            } 
        
        if(tranx == 'Subscribe'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription created successfully'));
        } 
        if(tranx == 'UnSubscribe'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription successfully removed'));
        }
        /**End -- Added By Abhita for Issue 505**/    
    }

    
    public void TypeOfData() {
        resetDependentFields();        
        if (formObj.TypeOfData__c != null && formObj.TypeOfData__c.contains('Post Design Service (Cheese and Fill)') ) {
            dispPostDesign = true;
            typeOfdataFlag = formObj.IsPostDesign__c == 'Yes'?true:false;
        } else {
            typeOfdataFlag = false;
            dispPostDesign = false;
        }
        if((formObj.Parent_Form_Id__r.RitHold__c == 'Yes' && dispPostDesign && (formObj.Parent_Form_Id__r.HoldReason__c == 'Review Post Design Service (Cheese and Fill) data')) 
            || (formObj.Parent_Form_Id__r.PostDesignServices__c == 'Yes' && dispPostDesign)) {
            dispReturnReason = true;
        } else {
            dispReturnReason = false;
        }
        setCoordinates();
    }

    /**Start --- Added By Abhita for Issue 501--*/
    public List<SelectOption> getpostDesignList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.IsPostDesign__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){             
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            if(formObj.IsPostDesign__c == '' || formObj.IsPostDesign__c == null){
                formObj.IsPostDesign__c = 'No';
            }
        } 
        
        return options;     
    }
    /**End --- Added By Abhita for Issue 501--*/
    public PageReference copyAsNewForm(){
        PageReference pgRef = new PageReference('/apex/FMSCopyForms');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference RequestAccepted() {
        formobj.Previous_State_Of_Form__c = formobj.State_of_the_Form__c;
        formobj.State_of_the_Form__c = 'RequestAccepted';
        try{
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formobj.Previous_State_Of_Form__c+' to '+formobj.State_of_the_Form__c));
            
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'RequestAccepted()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id);
        return pgRef;
    }

    public PageReference FormReturned() {
        formobj.Previous_State_Of_Form__c = formobj.State_of_the_Form__c;
        formobj.State_of_the_Form__c = 'FormReturned';
        
        try{
            update formObj;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formobj.Previous_State_Of_Form__c+' to '+formobj.State_of_the_Form__c));
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'FormReturned()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id);
        return pgRef;
    }

    public PageReference Cancelled() {
        formobj.Previous_State_Of_Form__c = formobj.State_of_the_Form__c ;
        formobj.State_of_the_Form__c = 'Cancelled';
        
        try{
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formobj.Previous_State_Of_Form__c+' to '+formobj.State_of_the_Form__c));
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'Cancelled()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id);
        return pgRef;
    }

    public PageReference SubmitForDesign() {
        if (validations()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Submit for design data return process} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        formobj.Previous_State_Of_Form__c = formobj.State_of_the_Form__c;
        formobj.State_of_the_Form__c = 'SubmitToProcess';
        try{
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formobj.Previous_State_Of_Form__c+' to '+formobj.State_of_the_Form__c));
        
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'SubmitForDesign()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id);
        return pgRef;
    } 

    public PageReference EditForm() {
        PageReference pgRef = new PageReference('/apex/FMSDDRFormPage?id=' + formId);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference deleteForm() {
        Id parentformid = formObj.Parent_Form_Id__c;
        String parRecordType = formObj.Parent_Form_Id__r.recordtype.Name;
        try {
        delete formObj;
        } catch(DMLException de) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getMessage()));
            return null;
        }
        PageReference pg1;
        String PageURL = ApexPages.currentPage().getUrl();
        if(PageURL.containsIgnoreCase('GlobalfoundryView')){
            pg1 = new PageReference('/GlobalfoundryView/apex/FMSRITFormViewPage?id='+parentformid); 
        }
        else{
            pg1 = new PageReference('/apex/FMSRITFormViewPage?id='+parentformid);
        }
        pg1.getParameters().put('tranx', 'delete');
        pg1.getParameters().put('delFormNum', formObj.Name);
        pg1.setRedirect(true);
        return pg1;

    }
    
    private void setCoordinates(){
        if(ddrXleft.contains('.')){
            formObj.DDRLeftXCoordinate__c = null;    
            ddrXleft = '';
        }else{
            formObj.DDRLeftXCoordinate__c = (ddrXleft == null || ddrXleft == '')?null:Integer.valueOf(ddrXleft);
        }
        if(ddrYleft.contains('.')){
            formObj.DDRLeftYCoordinate__c = null;  
            ddrYleft = '';
        }else{
            formObj.DDRLeftYCoordinate__c = (ddrYleft == null || ddrYleft == '')?null:Integer.valueOf(ddrYleft);
        }
        if(ddrXright.contains('.')){
            formObj.DDRRightXCoordinate__c = null;   
            ddrXright = '';
        }else{
            formObj.DDRRightXCoordinate__c = (ddrXright == null || ddrXright == '')?null:Integer.valueOf(ddrXright);
        }
        if(ddrYright.contains('.')){
            formObj.DDRRightYCoordinate__c = null;     
            ddrYright = '';
        }else{
            formObj.DDRRightYCoordinate__c = (ddrYright == null || ddrYright == '')?null:Integer.valueOf(ddrYright);
        }
    }
    
    public PageReference validateSave() {
        boolean val = validations();
        
        if (!exitForm || skipvalidation || !val) {
            //formobj.State_of_the_Form__c = 'Draft';/**Added by Abhita for Issue 506**/
            setCoordinates();
            try{
                update formObj;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        } else{
            return null;
        }

        PageReference pgRef;        
        if(exitForm){
            pgRef = new PageReference('/apex/FMSDDRFormViewPage?id=' + formObj.id);
            if(!val)pgRef.setRedirect(true);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your form has been saved successfully!'));
            exitForm = true;
            return null;
        }
        return pgRef;
    }

    public PageReference saveandExit() {
        skipvalidation = true;
        return validateSave();
    }

    /*
     @MethodName: saveForm
     @Parameters: 
     @ReturnType: PageReference
     @Author: Inshu Misra
     @CreatedDate: 13 Oct,2016
     @Description: to stop navigation to view page if the Save button is clicked...#IM
     @Modifications-
     * Date         Modified by             Comments
     * 10-Feb-2017  Inshu Misra             to avoid validation on save button click...#IM
     *
     */
    public PageReference saveForm(){  
        exitForm = false;
        return validateSave();        
    }
    
    public boolean validations() {
        boolean valdationRes = false;
        if (formObj.TypeOfData__c == '' || formObj.TypeOfData__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What type of data would you like returned?: is a Required field'));
            valdationRes = true;
        }

        if (dispReturnReason && (formObj.ReturnReason__c == null || formObj.ReturnReason__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Why are you requesting an additional return of the Post Design Service (Cheese and Fill) data? is a Required field'));
            valdationRes = true;
        }

        if (dispPostDesign && (formObj.IsPostDesign__c == '' || formObj.IsPostDesign__c == null)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: For your Post Design Service request, do you need a subset of the submitted GDS?  is a Required field'));
            valdationRes = true;
        }
        if (typeOfdataFlag){
            Map<String, String> fldLabel = new Map<String, String>();
            fldLabel.put('ddrXleft', 'X coordinate LL Corner (um)');
            fldLabel.put('ddrYleft', 'Y coordinate LL Corner (um)');
            fldLabel.put('ddrXright', 'X coordinate UR Corner (um)');
            fldLabel.put('ddrYright', 'Y coordinate UR Corner (um)');
            if(ddrXleft == null || ddrXleft == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: X coordinate LL Corner (um): is a Required field'));
                valdationRes = true;
            }else if(ddrXleft.contains('.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format for '+fldLabel.get('ddrXleft')+'. Please note the value entered in wrong format will not be saved.'));
                valdationRes = true;
            }
            if (ddrYleft == null || ddrYleft == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Y coordinate LL Corner (um): is a Required field'));
                valdationRes = true;
            }else if(ddrYleft.contains('.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format for '+fldLabel.get('ddrYleft')+'. Please note the value entered in wrong format will not be saved.'));
                valdationRes = true;
            }
            if (ddrXright == null || ddrXright == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: X coordinate UR Corner (um): is a Required field'));
                valdationRes = true;
            }else if(ddrXright.contains('.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format for '+fldLabel.get('ddrXright')+'. Please note the value entered in wrong format will not be saved.'));
                valdationRes = true;
            }
            if (ddrYright == null || ddrYright == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Y coordinate UR Corner (um): is a Required field'));
                valdationRes = true;
            }else if(ddrYright.contains('.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format for '+fldLabel.get('ddrYright')+'. Please note the value entered in wrong format will not be saved.'));
                valdationRes = true;
            }
        }

        return valdationRes;
    }
    //20-7-2017 Ram Rai Modified the method against subscription logic
    public PageReference Subscribe(){        
        
         Id userId = userinfo.getUserId();
        FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
        
        List<FMS_Subscription__c>  subscpList = new List<FMS_Subscription__c>();         
         // Added the sharing for Subscription Object 1Sept2017         
        subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userId  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true) and Form_Id__c =:formObj.id and Saved_Search_Id__c=null ];            
        List < FMS_My_Subscription__c > fmsMySubList = [SELECT id, Name, Subscribed_All__c FROM FMS_My_Subscription__c where UserName__c = : userId];
        
        
        if(fmsMySubList != null && fmsMySubList.size() > 0){
        
            fmsMySub = fmsMySubList[0];
        }else{
        
            fmsMySub = new FMS_My_Subscription__c();
            fmsMySub.Subscribed_All__c = true;
            fmsMySub.Subscribed_Date__c = system.today();
            fmsMySub.UserName__c = userId;
            
        try{
           if(fmsMySub!=null){
                Insert fmsMySub;
                // Added the sharing for Subscription Object 1Sept2017 
                 fmsMySub = [select id, username__c, UserName__r.UserType from FMS_My_Subscription__c where id = :fmsMySub.id];
                 if(fmsMySub.UserName__r.UserType!='Standard'){
                        FMS_My_Subscription__Share fmsRecordShare1 = new FMS_My_Subscription__Share();  
                        fmsRecordShare1.UserOrGroupId = fmsMySub.UserName__c;
                        fmsRecordShare1.ParentId = fmsMySub.Id;
                        fmsRecordShare1.AccessLevel = 'Edit'; 
                        Database.Insert(fmsRecordShare1,false);
                 }  
            }     
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'Subscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
        
        if( subscpList  ==null || subscpList.size() ==0 ){   
            FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();
        
            fmsSubscribe.Form_Id__c = formObj.id;  
        //  fmsSubscribe.Form_Id__c =  latestFormId; //Ravindra - changed to use latest step plan form. 
            fmsSubscribe.Form_Inserted__c = true;
            fmsSubscribe.Form_Status_Change__c = true;
            fmsSubscribe.Form_Updated__c = true;
            fmsSubscribe.Form_Deleted__c = true;
            fmsSubscribe.MySubscriptionId__c = fmsMySub.id;
            fmsSubscribe.User_Name__c = userId;
            fmsSubscribe.Subscribed_Date__c = system.today();
            
            try{     
         if(fmsSubscribe!=null){
                  Insert fmsSubscribe;
                  subscribeFlag = true;
                  // Added the sharing for Subscription Object 1Sept2017 
                  fmsSubscribe = [select id, User_Name__c, User_Name__r.UserType from FMS_Subscription__c where id = :fmsSubscribe.id];
                  if(fmsSubscribe.User_Name__r.UserType!='Standard'){
                      FMS_Subscription__Share fmsRecordShare1 = new FMS_Subscription__Share();  
                      fmsRecordShare1.UserOrGroupId = fmsSubscribe.User_Name__c  ;
                      fmsRecordShare1.ParentId = fmsSubscribe.Id;
                      fmsRecordShare1.AccessLevel = 'Edit'; 
                      Database.Insert(fmsRecordShare1,false);
                  }
              }     
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }    
            
             PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id=' + formObj.id);
            pgRef.getParameters().put('tranx', 'Subscribe');
            pgRef.setRedirect(true);
            return pgRef;
            }
            
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The User is already subscribed to this form'));
                return null;
        
            }               
    }
     public PageReference UnSubscribe(){        
        if(fmsSubscription!= null){
            fmsSubscription.Form_Inserted__c = false;
            fmsSubscription.Form_Status_Change__c = false;
            fmsSubscription.Form_Updated__c = false;
            fmsSubscription.Form_Deleted__c = false;
            fmsSubscription.UnSubscribed_Date__c = system.today();
            
            try{
                update fmsSubscription;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_Ext.class.getName(), 'UnSubscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            subscribeFlag = false;
        }
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage?id=' + formObj.id);
        pgRef.getParameters().put('tranx', 'UnSubscribe');
        pgRef.setRedirect(true);
        return pgRef;
    }
     public PageReference cancelForm(){
        PageReference pgRef = new PageReference('/apex/FMSDDRFormViewPage');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true); 
        return pgRef;
    }
     public PageReference SubscribeUser(){       
        String PageURL = ApexPages.currentPage().getUrl(); 
        PageReference pgRef = new PageReference('/apex/FMSSubscribeOtherUserPage');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put('baseURL',PageURL);
        pgRef.setRedirect(true); 
        return pgRef;
    }
    
    
    public void invInput(){
        String inputValue = Apexpages.currentPage().getParameters().get('inpVal');
        String mapFieldValue = Apexpages.currentPage().getParameters().get('fieldName');
        invalidInputCheckMap.put(inputValue.right(3), inputValue.removeEnd(inputValue.right(3)));
        invalidInpToFieldsMap.put(mapFieldValue, inputValue.removeEnd(inputValue.right(3)));
        isInvalidInp = true;
    }
    public PageReference openPDF(){
        PageReference pgRef = new PageReference( '/apex/FMSDDRFormViewPrintPDF?id='+formObj.id);        
        pgRef.setRedirect(true); 
        return pgRef;
    }
    
     
    public PageReference redirectToSearchPage(){
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/FormManagementMainPage');
        }else{
            pr = new PageReference('/apex/FormManagementMainPage?sfdc.tabName='+Environment_Variable__c.getInstance('FMS_TAB_ID').Value__c);
        }
        return pr;
    }
    
    public void resetDependentFields(){
        
        FMS_HierarchyLogic.getDependentFieldsToReset(fieldAPI,formObj,'DDR');
        fieldAPI = '';
    }
    
           /*
   *************************************    
   @ Name -  Browse History
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
   public PageReference chngHistory() {
      return UtilityCls.changeHistory(formObj);
   } 
    
}