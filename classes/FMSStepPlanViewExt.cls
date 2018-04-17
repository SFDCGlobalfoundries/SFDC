/**
 * Change History:
    DATE            NAME                    Comments

    05-Jun-2017     Ram Rai                 Defect fix for Step Plan.
    20-Jun-2017     Ram Rai                 Defect fix for Step Plan.  
    28-Jun-2017     Ram Rai                 Removed Hard Coding. 
    10-July-2017     Ram Rai                 Added the Defect Fix for unlock Link.#Issue 480 
    01-Sept-2017     Ram Rai                Modified the code to fix Subscription Issue
 * */
public with sharing class FMSStepPlanViewExt {

    public String fId {get;set;}
    public Form_Management_System__c formObj {get;set;}
    public boolean isPortalUser { get;set; }
    public boolean isFMSAdmin {get;set;}
    public boolean hasChildren { get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public String userType = Schema.SObjectType.User.getKeyPrefix();
    public list<wrapperClass> wrapperList{get;set;}
    public boolean popupVal{get;set;}
    public boolean requnck{get;set;}
    public String stateChangeComments{get;set;}
    public String selection{get;set;}
    public Id frmId{get;set;}
    public String frmState{get;set;}
    public List<Form_Management_System__c> fmList{get;set;}
    public List < FMS_Subscription__c > fmsSubscriptionList;
    public FMS_Subscription__c fmsSubscription;
    public boolean subscribeFlag {get;set;}
    public String rvdbyName{get;set;}
    public String webRDTSActive; 
    public Boolean displayNotAvailableMsg {get;set;}
    public String err;
    public String err1;
    public String approvedBy{get;set;} 
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE'); 
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM'); 
    public String latestFormId;
    public String getFormId() {
    
        return ApexPages.currentPage().getParameters().get('id');    
    }
    
  /*
   *************************************    
   @ Name -  Constructor 
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public FMSStepPlanViewExt(ApexPages.StandardController controller) {
            
         fId = ApexPages.currentPage().getParameters().get('id');        
        Id grpId = [SELECT ID, Name FROM Group WHERE DeveloperName = 'FMS_Admin_Group'].id;
        wrapperList = new list<wrapperClass>();
        Map<Id,List<Attachment>> fmMap = new Map<Id,List<Attachment>>();
        List<Attachment> attList = new List<Attachment>();
        Set<Id> fmId = new Set<Id>();
        fmsSubscriptionList = new List < FMS_Subscription__c > ();
        fmsSubscription = new FMS_Subscription__c();
        fmsSubscriptionList = new List < FMS_Subscription__c > ();
        fmsSubscription = new FMS_Subscription__c();
        stateChangeComments = ''; 
        requnck = false;
        webRDTSActive = 'false';
        err = ApexPages.currentPage().getParameters().get('err');
        err1 = ApexPages.currentPage().getParameters().get('err1');
        
         
         if(fId != null && fId != ''){
            formObj = [SELECT id, name, ProductName__c,Mandatory_State_Change_Comments__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c,Reviewed_By__c, RejectionReason__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name,Parent_Form_Id__c , Main_Form_Id__c,PrelimOrFinal__c,ReviewedBy__c ,Selection__c,LastModifiedBy.Name, CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate, Form_Description__c, Form_Type__c,Latest_Step_Plan__c  FROM Form_Management_System__c WHERE id = :fId];  
        }
     //Ravindra: Changes for Subscription based on latest Step Plan - Starts		
     		
       if(formObj.Latest_Step_Plan__c!=null){		
           latestFormId =formObj.Latest_Step_Plan__c;		
       }		
       else{		
           latestFormId=fId;		
       }		
      System.debug('latestFormId<====>'+latestFormId);		
       //Ravindra: Changes for Subscription based on latest Step Plan - Ends
       
         fmList = new List<Form_Management_System__c>();
         fmList = [SELECT id, name, UniqueWebRDTSId__c,Main_Form_Id__r.name,CustomerApprovalFlag__c,ProductName__c,Mandatory_State_Change_Comments__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c,Reviewed_By__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c,RejectionReason__c , Selection__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name, Main_Form_Id__c,PrelimOrFinal__c,ReviewedBy__c,LastModifiedBy.Name, CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate, Form_Description__c, Form_Type__c,Latest_Step_Plan__c from Form_Management_System__c where main_form_id__c =: formObj.Main_Form_Id__c and Form_Type__c =: FMS_SP_FORM order by CreatedDate desc];
             
             fmId.add(formObj.id);
             for(Form_Management_System__c  fm :fmList  ){
                 fmId.add(fm.id);
             }
             
             attList = [SELECT Description,Id,Name,BodyLength,ContentType,ParentId FROM Attachment where ParentId in: fmId];
             
             for(Attachment at : attList ){
                 List<attachment> lst = new list <attachment>();
                 if(fmMap.containskey(at.ParentId)){
                     lst = fmmap.get(at.parentId);
                     lst.add(at);
                     fmmap.put(at.parentid, lst);
                 }
                 else
                 fmMap.put(at.ParentId ,new List<Attachment> {at});
                  
             }
             
             
             Integer i;
             Integer Size;
             if(!fmList.isempty()){
            if( fmList.size()!= 0){
            Size = fmList.size();
            frmState = fmList[0].State_of_the_Form__c;
            
            
            if(fmList[0].Selection__c =='None'){
            selection = '';
            
            }
            else
            selection = fmList[0].Selection__c ;
            
            }
           
            
           
            frmId = fmList[0].id;
                     
            i =fmList.size() ;
             }
             
             else{
             selection = formObj.Selection__c ;
             frmState = formObj.State_of_the_Form__c;
             }
            Integer siz = fmList.size(); 
            if(fmList != null)
                approvedBy = fmList[siz-1].Reviewed_By__c ;
            // Added the sharing for Subscription Object 1Sept2017 
                 
            
  fmsSubscriptionList = [Select id, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Subscribed_Date__c, UnSubscribed_Date__c 
                         FROM FMS_Subscription__c 
                         WHERE Form_Id__c = : latestFormId 
                         AND User_Name__c = : UserInfo.getUserId() 
                         AND UnSubscribed_Date__c =null and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Saved_Search_Id__c=null];
                         
  if (fmsSubscriptionList != null && fmsSubscriptionList.size() > 0){
  	subscribeFlag = true;
  	}else {
  		subscribeFlag = false;
  	}
            
    
        DateTime cretedDateTime; 
        Integer lstSize;
        Integer lstCount;
        
        if( fmList!= null && fmList.size()>0)
            lstCount = 0;
         
        for(Form_Management_System__c fms: fmList ){
            lstSize = fmList.size();
            
             cretedDateTime = fmList[lstSize -1].createddate;
            wrapperClass fmWrap1 = new wrapperClass(fms);

            system.debug('--formname--'+fms.name);
            fmWrap1.prelimPara = '';
            fmWrap1.prelimName = 'Preliminary Step Plan:';
            if(fms.PrelimOrFinal__c =='Final'){ 
                i--;  
                system.debug('-reviewd-'+fmList[lstCount].Reviewed_By__c);
                system.debug('-reviewd-'+fmList[lstCount].name);
                
                fmWrap1.approvalName = fmList[lstCount + 1].Reviewed_By__c;
            }
            if(fms.PrelimOrFinal__c =='Preliminary'){   
            fmWrap1.counterWrap = i;
             i--;
             }
            fmWrap1.lstattch = fmMap.get(fms.id);
            
            fmWrap1.createdDate = cretedDateTime ;
            
            lstCount = lstCount + 1 ; 
            wrapperList.add(fmWrap1);
           
         }
         
         if (UserInfo.getUserType() == 'Standard'){
          	          
	         for(GroupMember m: [Select Id, UserOrGroupId From GroupMember Where GroupId = : grpId]){
	            if(((String) m.UserOrGroupId).startsWith(userType)) {
	                grpUsers.add(m.UserOrGroupId);
	            }
	         }         
         }
        
        if (grpUsers.contains(UserInfo.getUserId())) {
            isFMSAdmin = true;
        } else {
            isFMSAdmin = false;
        }
        if (UserInfo.getUserType() != 'Standard') {
            isPortalUser = true;
        } else {
            isPortalUser = false;
        }                  
        
        
        
        
        if(err== 'error'){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Select One: is a Required field')); 
        }   
        
        if(err1== 'error1'){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field')); 
        }   
        
     }    
       /*
   *************************************    
   @ Name -  Wrapper Class
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public class wrapperClass{
        
        public Form_Management_System__c wrapFmObj{get;set;}
        public Integer counterWrap{get;set;}
        public String prelimPara {get;set;}
        public String prelimName{get;set;}
        public List<Attachment> lstattch{get;set;}
        public datetime createdDate {get;set;}
        public string dattime {get;set;}
        public string approvalName {get;set;}
        
        public wrapperClass(Form_Management_System__c WrapfmObj ) {
            
            this.wrapFmObj=WrapfmObj ; 
            this.prelimPara = '';  
                
        }                      
    }       
    /*
   *************************************    
   @ Name -  unlckStpPlan
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public void unlckStpPlan(){
        // Added the Code to unlock Step Plan.
        if(fmList[0].Selection__c =='Reject Preliminary Step Plan' && ( fmList[0].RejectionReason__c == null || fmList[0].RejectionReason__c == '' ))
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field'));
        else{
        popupVal = true;
        requnck= false;
        }
        
    }
        /*
   *************************************    
   @ Name -  requnlckStpPlan
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    
     public void requnlckStpPlan(){
             
      if(fmList[0].Selection__c =='Reject Preliminary Step Plan' &&  ( fmList[0].RejectionReason__c == null || fmList[0].RejectionReason__c == '' ))
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field'));
        else{
       popupVal = true;    
       requnck= true;
       } 
        }
            /*
   *************************************    
   @ Name -  spComplete
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public PageReference spComplete(){
    
        frmState = fmList[0].State_of_the_Form__c;
        
        frmState ='StepPlanComplete';
        fmList[0].State_of_the_Form__c = frmState ;

         try{
        update fmList;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'spComplete()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId);     
        pgRef.setRedirect(true);
       
        return pgRef;

    }
                /*
   *************************************    
   @ Name -  conUnlcPlan
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */
    
    public PageReference conUnlcPlan(){
        
        fmList[0].Mandatory_State_Change_Comments__c = stateChangeComments ;
        
        if (stateChangeComments == null || stateChangeComments == '') {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please provide brief description explaining the reason for this action - is a Required field'));
            return null;
            }else{       
        if(requnck){
        popupVal = false;                       
        frmState = 'RequestToUnlockStepPlan';
        fmList[0].State_of_the_Form__c = frmState ;
        try{
        update fmList;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'conUnlcPlan()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        }
        else{ 
        requnck = true;       
        frmState = 'StepPlanUnlocked';
        fmList[0].State_of_the_Form__c = frmState ;
        
         try{
         if(fmList !=null)
         update fmList;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'conUnlcPlan()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        }
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId );
        pgRef.setRedirect(true);
         return pgRef ; 
        }    
         
    }
                   /*
   *************************************    
   @ Name -  closePopup
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
    
    
    public PageReference closePopup() {
        popupVal = false;
        
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId );
        pgRef.setRedirect(true);
        return pgRef;
    }
    
     /*
   *************************************    
   @ Name -  editForm
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
    public PageReference editForm(){
        
        PageReference pgRef = new PageReference('/apex/FMSStepPlanEditForm');
        pgRef.getParameters().put('id', fId );
        pgRef.setRedirect(true);
        return pgRef;
    
    } 
    /*
   *************************************    
   @ Name -  formSelection
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */    
    public PageReference formSelection(){
        PageReference pgRef = new PageReference('/apex/FMSmainFormViewPage');    
        pgRef.getParameters().put('id', formObj.Main_Form_Id__c );
        pgRef.setRedirect(true);
        return pgRef;   
    
    }
      /*
   *************************************    
   @ Name -  viewPdf
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */
        public PageReference viewPdf(){
    
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormViewPDF');
        pgRef.getParameters().put('id', fId );
        pgRef.setRedirect(true);
        return pgRef;   
    
    }
      /*
   *************************************    
   @ Name -  deleteForm
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */
    public PageReference deleteForm(){
    
     try{   
     delete formObj ;
     delete fmList ;
     
     }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'deleteForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    PageReference pg1;
  String PageURL = ApexPages.currentPage().getUrl();
  if(PageURL.containsIgnoreCase('GlobalfoundryView')){
  pg1 = new PageReference('/GlobalfoundryView/apex/FMSmainFormViewPage');
  pg1.getParameters().put('id', formObj.Main_Form_Id__c );
  }
  else{
  pg1 = new PageReference('/apex/FMSmainFormViewPage');
  pg1.getParameters().put('id', formObj.Main_Form_Id__c );
  }
  pg1.getParameters().put('tranx', 'delete');
  pg1.getParameters().put('delFormNum', formObj.Name);
  pg1.setRedirect(true);
  
  return pg1;
    
    }
      /*
   *************************************    
   @ Name -  updateFormDetailApprove
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */
     public PageReference updateFormDetailApprove(){
        frmState ='PrelimStepPlanApproved';
        Form_Management_System__c fmObj = new Form_Management_System__c();        
        fmObj = fmList[0];   
        fmObj.State_of_the_Form__c = frmState ;
        User u = [SELECT Id,firstname,lastname FROM User WHERE id = :UserInfo.getUserId()];
        fmObj.Reviewed_By__c = u.firstname + ' ' + u.lastname ; 
        webRDTSActive = Environment_Variable__c.getInstance('WebRDTS_IsActive').value__c;
        if(webRDTSActive =='TRUE'){
            FMSDropServiceStepPlanDetails_API apiObj = new FMSDropServiceStepPlanDetails_API();
            
            if(fmObj.UniqueWebRDTSId__c !=null && fmObj.Main_Form_Id__r.name !=null  ){
                apiObj.FMSStepPlaApproval_API(Integer.valueof(fmObj.UniqueWebRDTSId__c),String.valueof(fmObj.Main_Form_Id__r.name),fmObj.CustomerApprovalFlag__c,'');
                
                fmObj.WebRDTS_Step_Plan_Comment__c = apiObj.comments;
                fmObj.WebRDTS_Step_Plan_Result__c= apiObj.statusCode;               
           }
        
        try{         
        
            if(fmObj!=null) {
                update fmObj;
            }            
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'updateFormDetailApprove()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId);     
        pgRef.setRedirect(true);
       
        return pgRef;
          }else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:WbRDTS Service is Down')); 
            
           return null;
          }
        
    }     
   /*
   *************************************    
   @ Name -  updateFormDetailReject
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
    public PageReference updateFormDetailReject(){
    
 		Form_Management_System__c fmObj = new Form_Management_System__c(); 
        fmObj = fmList[0];          
        if( fmObj.RejectionReason__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field'));
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RejectReason  )); 
            return null;
        }
        else{
        frmState = 'PrelimStepPlanRejected';
        fmObj.State_of_the_Form__c = frmState ;
        User u = [SELECT Id,firstname,lastname FROM User WHERE id = :UserInfo.getUserId()];
        fmObj.Reviewed_By__c = u.firstname + ' ' + u.lastname ; 
        webRDTSActive = Environment_Variable__c.getInstance('WebRDTS_IsActive').value__c;
        if(webRDTSActive =='TRUE'){
            
            FMSDropServiceStepPlanDetails_API apiObj = new FMSDropServiceStepPlanDetails_API();
            if(fmObj.UniqueWebRDTSId__c !=null && fmObj.Main_Form_Id__r.name !=null && fmObj.Main_Form_Id__r.name !=null ){
           
            apiObj.FMSStepPlaApproval_API(Integer.valueof(fmObj.UniqueWebRDTSId__c),String.valueof(fmObj.Main_Form_Id__r.name),fmObj.CustomerApprovalFlag__c,fmObj.RejectionReason__c);
        
            fmObj.WebRDTS_Step_Plan_Comment__c = apiObj.comments;
            fmObj.WebRDTS_Step_Plan_Result__c= apiObj.statusCode;
        } 
        }
        try{ 
        if(fmObj !=null)
        update fmObj;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'updateFormDetailReject()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId);     
        pgRef.setRedirect(true);
        return pgRef;
        }
        return null;
        
    } 
   /*
   *************************************    
   @ Name -  updateFormDetails
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */
    public PageReference updateFormDetails() {
        PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
        pgRef.getParameters().put('id', fId);
        pgRef.getParameters().put('tranx', 'Edit');
        pgRef.getParameters().put('Type', 'SP');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
   /*
   *************************************    
   @ Name -  Subscribe
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
   public PageReference Subscribe() {
     
       Id userId = userinfo.getUserId();
       FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
       List<FMS_Subscription__c>  subscpList = new List<FMS_Subscription__c>(); 
	   // Added the sharing for Subscription Object 1Sept2017 
       //Ravindra: changed to use latest step plan form. 
       subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userId  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true) and Form_Id__c =:latestFormId and Saved_Search_Id__c=null];        
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
                  
                    //  fmsSubscribe.Form_Id__c = fId;  
                    fmsSubscribe.Form_Id__c =  latestFormId; //Ravindra - changed to use latest step plan form. 
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
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }    
       return new PageReference('/apex/FMSStepPlanFormView?id=' + fId);
       }
       else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The User is already subscribed to this form'));
            return null;
        
        }
  }
   /*
   *************************************    
   @ Name -  UnSubscribe
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */   
    
  public PageReference UnSubscribe() {
  if (fmsSubscription != null) {
  fmsSubscription.Form_Inserted__c = false;
  fmsSubscription.Form_Status_Change__c = false;
  fmsSubscription.Form_Updated__c = false;
  fmsSubscription.Form_Deleted__c = true;
  fmsSubscription.UnSubscribed_Date__c = system.today();
  try{
  if(fmsSubscription !=null)
  update fmsSubscription;
  } catch(Exception e){
  UtilityCls.saveExceptionLog(FMSStepPlanViewExt.class.getName(), 'UnSubscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
  }
  subscribeFlag = false;
  }
  return new PageReference('/apex/FMSStepPlanFormView?id=' +fId);
  }  
   /*
   *************************************    
   @ Name -  SubscribeUser
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
  public PageReference SubscribeUser() {
  
  Id userId = userinfo.getUserId();
   FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
        
        
        List < FMS_My_Subscription__c > fmsMySubList = [SELECT id, Name, Subscribed_All__c FROM FMS_My_Subscription__c where UserName__c = : userId];
        
        if(fmsMySubList != null && fmsMySubList.size() > 0){
            fmsMySub = fmsMySubList[0];
        }else{
            
            fmsMySub = new FMS_My_Subscription__c();
            fmsMySub.Subscribed_All__c = true;
            fmsMySub.Subscribed_Date__c = system.today();
            fmsMySub.UserName__c = userId;
            
            try{
                if(fmsMySub!=null)
                Insert fmsMySub;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'SubscribeUser()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
     
       FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();
                    fmsSubscribe.Form_Id__c = fId;
                    fmsSubscribe.Form_Inserted__c = true;
                    fmsSubscribe.Form_Status_Change__c = true;
                    fmsSubscribe.Form_Updated__c = true;
                    fmsSubscribe.Form_Deleted__c = true;
                    fmsSubscribe.MySubscriptionId__c = fmsMySub.id;
                    fmsSubscribe.User_Name__c = userId;
                    fmsSubscribe.Subscribed_Date__c = system.today();
                try{
                if(fmsSubscribe!=null)
                Insert fmsSubscribe;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'SubscribeUser()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }     
    
  
  String PageURL = ApexPages.currentPage().getUrl();
  PageReference pgRef = new PageReference('/apex/FMSSubscribeOtherUserPage'); 
  pgRef.getParameters().put('id', fId); 
  pgRef.getParameters().put('baseURL', PageURL);
  pgRef.setRedirect(true);
  return pgRef;
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
        UtilityCls.isStepPlan = true;
        return UtilityCls.changeHistory(formObj);
    }  
}