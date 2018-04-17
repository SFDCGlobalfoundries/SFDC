/*******************************************************************
* Author: Sakthi 
* Project: DIW-DesignExecution 
* Name: DesignExecutionController 
* Description: Class is created for inserting/updating or handle all Sing Off Module for different permissionSet
* CreatedDate:
* Modified By : Abhishek/Sandesh 
* Modified date : 03-Dec-2016  
* Modefied date : 10-May-2017
				  Line:486, 659  & methods: saveSignOffDetail & saveSignOffRTMDetail - Verify the permission Set type and assigned the corrosponding date and user in SignOff Module
				  Line:676  & Method:getApprovedMileStones  - Add mile stone on same order which we have in record type list in vf page
				  14-Jun-2017, added validateSelectedMileStone method is validate selected value for SignOff milestone
				  24-Jun-2017, added sendSignOffTeamMemberEmail method is used to send the Email notification based on Opportunity Team member record
                  11-Sept-2017 added method call to reflect actual sign off date
********************************************************************/
public class DesignExecutionSignOffController {
    private final String SIGNOFF_RTF = 'RTF';
    private final String SIGNOFF_EFF = 'EFF';
    private final String SIGNOFF_RTP = 'RTP';
    private final String SIGNOFF_EFP = 'EFP';
    private final String SIGNOFF_RTL = 'RTL';
    private final String SIGNOFF_RTC_READY = 'RTC DT ready';
    private final String SIGNOFF_RTC_RIT_B_READY = 'RTC RIT B ready';
    private final String SIGNOFF_RTC_RIT_A_READY = 'RTC RIT A ready';
    private final String SIGNOFF_RTM_RIT_A_READY = 'RTM RIT A ready';
    private final String SIGNOFF_RTM_RIT_B_READY = 'RTM RIT B ready';
    private final String SIGNOFF_RTM_DT = 'RTM DT';
	private final String SIGNOFF_RTM_DT_READY = 'RTM DT ready';
    private final String SIGNOFF_RTM_RIT_A = 'RTM RIT A';
    private final String SIGNOFF_RTM_RIT_B = 'RTM RIT B';
    private final String SIGNOFF_RTC_RIT_A_B_Ready = 'RTC RIT A/B ready';
    private final String SIGNOFF_RTM_RIT_A_B = 'RTM RIT A/B';
   
    private Set<String> enrolledRecordTypeByName;
    private Set<String> setOfPermissionSet;
    private String signOffExtVal;
    private string idrValue; 
    private Date idrActualDate;
    public id deId;
    private id cdsId;
    private Boolean dtRTCCheckpointFlag;
    private Boolean dtRTMCheckpointFlag;
    private Boolean rtcRITAFlag;
    private Boolean rtmRITAFlag;
    private String cancelDT;
    private String enableCreateRTDTButton;
    private Map<String,Sign_off_Module__c> signOffModuleMap;
    
    public Sign_off_Module__c signOffModue {get; set;}
    public List<Sign_off_Module__c> listOfsignOffModue {get;set;}
    public String recordTypeName {get; set;}
    public String selectedRT {get; set;}
    public boolean customerChecked{get; set;}
    public boolean customerReviewed{get; set;}
    public boolean cusomerReviewedRTM {get;set;}
    public boolean resetBtnDisp {get; set;}
    public boolean displayPopup {get; set;}
    public List<Attachment> soAttList{get;set;}
    private set<string> setSignoffRTs;
    //public Id deId {get; set;}
    public  SignOffMileStoneApprover signOffApprover {get; set;}
    
    public Design_Execution__c designExecution{
        get { if (designExecution == null)designExecution = new Design_Execution__c();
            return designExecution;
        }
        set;
      }
    
    public class SignOffMileStoneApprover{
        public Boolean aeApproval {get; set;}
        public Boolean dceApproval {get; set;}
        public Boolean pdApproval {get; set;}
        public Boolean peApproval {get; set;}
        public Boolean rtlCheckPointApproval {get; set;}
        public Boolean dceReviewdApproval {get; set;}
        public Boolean selectPE {get; set;}
        public Boolean selectAE {get; set;}
        public Boolean selectDCE {get; set;}
        public Boolean selectPD {get; set;}
        public Boolean selectRTLDCE {get; set;}
        public Boolean selectDCEReview {get; set;}
        public Boolean aeChecked {get; set;}
        public Boolean dceChecked {get; set;}
        public Boolean pdChecked {get; set;}
        public Boolean peChecked {get; set;}
        public Boolean rtlChecked {get; set;}
        public Boolean dceReviewChecked {get; set;}

    }

    public DesignExecutionSignOffController(){
        //Assigned All required IDS
        idrValue = ApexPages.currentPage().getParameters().get('IDRvalue');
        //cdsId = ApexPages.currentPage().getParameters().get('cdsId');
        deId  = ApexPages.currentPage().getParameters().get('deid');
        //deId  = ApexPages.currentPage().getParameters().get('deId');
        if(deId !=null)
            deId  = deId;
        if(idrValue != null) {
            idrActualDate = date.parse(idrValue);
        }
  
        recordTypeName = ApexPages.currentPage().getParameters().get('RTName');
        enrolledRecordTypeByName = new Set<String>(); 
        signOffModueDetails();
        displaySignOffApprovedMSG();
        designExecution = DesignExecutionUtility.fetchDErecords(deId); 
        cdsid = designExecution.Customer_Design_Specification__c;
        displayPopup = false;
    }
    
   
    
    /**
    * @description OpenDesignPhaseForm method is used to redirect to DesignExecutionRead
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
    public Pagereference openDesignPhaseForm(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionRead?RTName=' + selectedRT+'&deId='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;    
    }
     
    /**
    * @description cancelExecutionDetail method is used to redirect to DesignExecutionRead
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
    public Pagereference cancelExecutionDetail(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionRead?deId='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    * @description RequoteExecutionDetail method is used to redirect to DesignExecutionDetail
    * @param    No Parameter
    * @return   Pagereference DesignExecutionDetail page
    */
    public Pagereference requoteExecutionDetail(){
        id reqid = DesignExecutionUtility.requote(cdsid);
        if(reqid != null){
            pageReference pageRef = new pageReference('/' + reqid );
            pageRef.setRedirect(true);
            return pageRef;
        }
        else{
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Request Information is Not available');
            apexpages.addmessage(msg);
            return null;
        }
    }
    
    /**
    * @description readExecutionDetail method is used to redirect to DesignExecutionRead
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
    public Pagereference readExecutionDetail(){
        pageReference pageRef = new pageReference('/apex/DesignExecutionRead?deId='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    * @description viewSignOffRT method is used to redirect to DesignExecutionSignOffRecType
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
    public Pagereference viewSignOffRT(){
        Design_Execution__c DEC = [select id from Design_Execution__c where ((actual_date__c =: idrActualDate and Customer_Design_Specification__c =: cdsId) OR id =: designexecution.id) limit 1 ];
        id deseuid = DEC.id;
        pageReference pageRef = new pageReference('/apex/DesignExecutionSignOffRecType?deId='+designExecution.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
	    
    /**
    * @description getSignOffRTDetail method is cretae list of Select options,
    *              which contains map of all signOff record type as a key, value pair.
    * @param    No Parameter
    * @return   SelectOption options
    */
    public List<SelectOption> getSignOffRTDetail() {
        List<SelectOption> options = new List<SelectOption>();
        string signoffRecTypes = Label.DesignExecutionSignOffModuleRecordTypes;
        setSignoffRTs = new set<string>();
        if(signoffRecTypes != null && signoffRecTypes!= ''){ 
            setSignoffRTs.addAll(signoffRecTypes.split('[,;]'));
            
        }
        if(setSignoffRTs.size() > 0){
           for(String s : setSignoffRTs) {
               options.add(new SelectOption(s,s));
           }
        }
        return options;
    }
    
    
    /**
    * @description displaySignOffApprovedMSG method is return message if already approved milestones details.
    * @param    No Parameter
    */
    public void displaySignOffApprovedMSG(){
        //getSignOffProfileStaus();
        if(getApprovedMileStones().contains(recordTypeName)){
          apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Design Execution Sign Off has been Approved for MileStones' + getApprovedMileStones());
          apexpages.addmessage(msg);
        }
    }
    
    /**
    * @description openSignOffForm method is redirect to DesignExecutionSignOffRTM.
    * @param    No Parameter
    * @return   Pagereference pageRef
    */
    public Pagereference openSignOffForm(){
        system.debug('**selectedRT***' + selectedRT); 
        validateSelectedMileStone();       
        pageReference pageRef;
        String rtcDTErrorMassage = DesignExecutionStaticValue__c.getvalues('Sign Off RTC DT Ready').value__c;
        String rtcRITBErrorMassage = DesignExecutionStaticValue__c.getvalues('Sign Off RTC RIT B').value__c;
        String rtmDTErrorMassage = DesignExecutionStaticValue__c.getvalues('SignOff RTM DT').value__c;
        String rtmRITBErrorMassage = DesignExecutionStaticValue__c.getvalues('SignOff RTM RIT B').value__c;
        
        //Validate condition to redirect signOff Module page
        if(selectedRT.contains('RTM') || selectedRT.contains('PTRF')){
        	//validate RTM DT checkpoint exists in design execution, and DT sign-off is not yet completed. Do not allow user to proceed with   Sign-off of Rit A/B or Rit A. (RTM)
        	if(!dtRTMCheckpointFlag && (selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_A) || selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_A_B))){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, rtmDTErrorMassage));
        	}
        	//Validate Rit A/B Split is set in design execution, and Rit A sign-off is not yet completed. Do not allow user to proceed with Sign-off of Rit B (RTM)
        	else if(!rtmRITAFlag && (selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_B))){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, rtmRITBErrorMassage));
        	}
        	else{
        		pageRef = new pageReference('/apex/DesignExecutionSignOffRTM?RTName=' + selectedRT+'&deId='+designExecution.id);
        	}
        }
        else{
        	//validate RTM DT checkpoint exists in design execution, and DT sign-off is not yet completed. Do not allow user to proceed with   Sign-off of Rit A/B or Rit A. (RTC)
        	if(!dtRTCCheckpointFlag && (selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_A_READY)|| selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_A_B_Ready))){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, rtcDTErrorMassage));
        	
        	}
        	//Validate Rit A/B Split is set in design execution, and Rit A sign-off is not yet completed. Do not allow user to proceed with Sign-off of Rit B (RTC)
        	else if(!rtcRITAFlag && (selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_B_READY))){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, rtcRITBErrorMassage));
        	}
        	
        	else{
        		pageRef = new pageReference('/apex/DesignExecutionSignOff?RTName=' + selectedRT+'&deId='+designExecution.id);
        	}
        }
        if(selectedRT == '--NONE--'){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select RTx Checklist type'));
            return null;
        }
        
        if(pageRef !=null){
        	pageRef.setRedirect(true);
        	pageRef.getParameters().put('cancelDT',cancelDT);
        	pageRef.getParameters().put('enableCreateRTDTButton',enableCreateRTDTButton);
        }
        	
        return pageRef;    
    }
    
    /**
    * signOffAttachment variable of type Attachement which return signOffAttachment.
    */
    public Attachment signOffAttachment {
    get {
      if (signOffAttachment == null)
        signOffAttachment = new Attachment();
      return signOffAttachment;
    }
    set;
    }
    
    /**
    * signOffAttachmentRTC variable of type Attachement which return signOffAttachmentRTC.
    */
    public Attachment signOffAttachmentRTC {
    get {
      if (signOffAttachmentRTC == null)
        signOffAttachmentRTC = new Attachment();
      return signOffAttachmentRTC;
    }
    set;
    }
    
    /**
    * signOffAttachmentTMD variable of type Attachement which return signOffAttachmentTMD.
    */
    public Attachment signOffAttachmentTMD {
    get {
      if (signOffAttachmentTMD == null)
        signOffAttachmentTMD = new Attachment();
      return signOffAttachmentTMD;
    }
    set;
    }
    
    /**
    * signOffAttachmentRTM variable of type Attachement which return signOffAttachmentRTM.
    */
    public Attachment signOffAttachmentRTM {
    get {
      if (signOffAttachmentRTM == null)
        signOffAttachmentRTM = new Attachment();
      return signOffAttachmentRTM;
    }
    set;
    }
    
    /**
    * signOffAttachmentTDI variable of type Attachement which return signOffAttachmentTDI.
    */
    public Attachment signOffAttachmentTDI {
    get {
      if (signOffAttachmentTDI == null)
        signOffAttachmentTDI = new Attachment();
      return signOffAttachmentTDI;
    }
    set;
    }
    
    /**
    * signOffAttachmentQLD variable of type Attachement which return signOffAttachmentQLD.
    */
    public Attachment signOffAttachmentQLD {
    get {
      if (signOffAttachmentQLD == null)
        signOffAttachmentQLD = new Attachment();
      return signOffAttachmentQLD;
    }
    set;
    }
    
    /**
    * customerApprovalAttachment variable of type Attachement which return customerApprovalAttachment.
    */
    public Attachment customerApprovalAttachment {
    get {
      if (customerApprovalAttachment == null)
        customerApprovalAttachment = new Attachment();
      return customerApprovalAttachment;
    }
    set;
    }
    
    /**
    * customerApprovalAttachmentRTM variable of type Attachement which return customerApprovalAttachmentRTM.
    */
    public Attachment customerApprovalAttachmentRTM {
    get {
      if (customerApprovalAttachmentRTM == null)
        customerApprovalAttachmentRTM = new Attachment();
      return customerApprovalAttachmentRTM;
    }
    set;
    }

    /**
    * @description getSOMAttachmentId method return signOffAttach 
    * @param    No Parameter
    * @return   List<Attachment> signOffAttach 
    */     
    public List<Attachment> getSOMAttachmentId() {
        if(signOffModue != null ) {
           Id sId = signOffModue.Id;
           List<Attachment> signOffAttach = [Select Id, Name, CreatedBy.Name from Attachment Where ParentId =: sId ];
            if(signOffAttach !=null && !signOffAttach.isEmpty()) {
                return signOffAttach;
            } 
        }
        return null;
     } 
    
    /**
    * @description signOffModueDetails method is used to fetch the sign Off record from,
    *             Sign_off_Module__c.
    * @param    No Parameter
    * @return   void
    */
    public void signOffModueDetails() { 
        signOffExtVal = deId+':'+recordTypeName;
        list<Sign_off_Module__c> listOfSignOffRecord = [SELECT Id, Name, RecordTypeId, RTL_Checkpoint_Reached__c, stage__c, Design_Execution__c, RIT_Type__c,
                                                        Application_Engineer__c, Field_Design_Center_Engineer__c, Design_Execution__r.Option__r.RIT_Type__c,
                                                        Physical_Design_Engineer__c, Product_Engineer__c, IBM_ASIC__c, 
                                                        Customer_Details__c, Profile_ID__c, SignOffExternalId__c, RTM_Ready__c,
                                                        RTM_Comments__c, TMD_Comments__c, TDI_ERelease__c, TDI_ERelease_Initials__c, TDI_Library_Usage_File_LUF__c,
                                                        TDI_Library_Usage_File_LUF_Initials__c, TDI_VIM__c, TDI_VIM_Initials__c, TDI_Waiver_File__c, TDI_Waiver_File_Initials__c,
                                                        TDI_LPXREF__c, TDI_LPXREF_Initials__c, TDI_TMD__c, TDI_TMD_Initials__c, TDI_Testbench_LUF_TLUF__c,
                                                        TDI_Testbench_LUF_TLUF_Initials__c, TDI_Comments__c, QLD_Comments__c, T2_qualification__c, Qualification_Dates__c,
                                                        Qualified_Comments__c, PLLs_Comments__c, DCE_RTL_Checkpoin__c, DCE_Review_Approved__c, Customer_Approval__c, 
                                                        Customer__c, RIT_Customer_Reviewed__c, Customer_RTM_Reviewed__c, TMD_Generation__c,
                                                        TMD_Pre_Layout_ATPG__c, TMD_Post_Layout_Produciton__c, TMD_TSV_checks__c, TMD_MSV_checks__c,
                                                        TMD_LUF_file__c, TMD_LUF__c, TMD_Test_Data_Volume_exceed__c, TMD_ECID_macro__c, TMD_ECID_section_of_the_LPXREF__c, QLD__c,
                                                        T2__c, Unqualified__c, Qualified__c, PLLs__c,AE_Approval__c,AE_Approval_User__c,DCE_Approval__c,DCE_Approval_User__c,PD_Approval__c,
                                                        PD_Approval_User__c,PE_Approval__c,PE_Approval_User__c
                                                        FROM Sign_off_Module__c 
                                                        Where SignOffExternalId__c =: signOffExtVal Limit 1];
                        
        if(listOfSignOffRecord != null && !listOfSignOffRecord.isEmpty()) {
            signOffModue = listOfSignOffRecord[0];
        }
        else{
            signOffModue = new Sign_off_Module__c();
        }
    }
    
    
    /**
    * @description listOfApprovedMileStoneRecords method is call all approved milestones
    *              from singOff Module       
    * @param    No Parameter
    * @return   pageReference: Null
    */
    public pageReference listOfApprovedMileStoneRecords(){
        getApprovedMileStones();
        return null;
    }
    
    /**
    * @description getUserLavelSignOffAccess method is used to set the access lavel for 
    *              logged in user based on profile and permission set access lavel
    * @param    No Parameter
    * @return   Void : Null
    */
    public void getUserLavelSignOffAccess(){
        signOffModueDetails();
        setOfPermissionSet = DesignExecutionUtility.setOfPermissionSetForLoggedInUser();
        signOffApprover = new SignOffMileStoneApprover();
        Sign_off_Module__c sfm = signOffModue;    
        
        signOffApprover.aeApproval = true;
        signOffApprover.dceApproval = true;
        signOffApprover.pdApproval = true;
        signOffApprover.peApproval = true;
        signOffApprover.rtlCheckPointApproval = true;
        signOffApprover.dceReviewdApproval = true;
        signOffApprover.selectDCE = false;
        signOffApprover.selectPD = false;
        signOffApprover.selectAE = false;
        signOffApprover.selectPE = false; 
        signOffApprover.selectRTLDCE = false;
        signOffApprover.selectDCEReview = false;
        
        if(sfm.stage__c ==null){
            if(setOfPermissionSet.contains(label.DIWApplicationEngineer)){ 
                signOffApprover.aeApproval = false;
            } 
            if(setOfPermissionSet.contains(label.DIWDesignCenterEngineer)){  
                signOffApprover.dceApproval = false;
                signOffApprover.rtlCheckPointApproval = false;
                signOffApprover.dceReviewdApproval = false;
            }
            if(setOfPermissionSet.contains(label.DIWPhysicalDesignEngineer)){  
                signOffApprover.pdApproval = false;
            }
            if(setOfPermissionSet.contains(label.DIWProductEngineer)){  
                signOffApprover.peApproval = false;
            }
        }
        else{
            if(sfm.Application_Engineer__c){
                signOffApprover.selectAE = true;
                signOffApprover.aeApproval =true;
            }
            if(sfm.Field_Design_Center_Engineer__c){
                signOffApprover.selectDCE = true;
                signOffApprover.dceApproval =true;
            }
            if(sfm.DCE_RTL_Checkpoin__c){
              signOffApprover.rtlCheckPointApproval = true;
              signOffApprover.selectRTLDCE = true;
            }
            if(sfm.DCE_Review_Approved__c){
              signOffApprover.dceReviewdApproval = true;
              signOffApprover.selectDCEReview = true;             
            }
            if(sfm.Physical_Design_Engineer__c){
                signOffApprover.selectPD = true;
                signOffApprover.pdApproval =true;
            }
            if(sfm.Product_Engineer__c){
                signOffApprover.selectPE = true;
                signOffApprover.peApproval =true;
            }
            if(setOfPermissionSet.contains(label.DIWApplicationEngineer)){  
                if(!sfm.Application_Engineer__c){
                    signOffApprover.aeApproval = false;
                }
            }
            if(setOfPermissionSet.contains(label.DIWDesignCenterEngineer)){  
                if(!sfm.Field_Design_Center_Engineer__c){
                    signOffApprover.dceApproval = false;
                }
                if(!sfm.DCE_RTL_Checkpoin__c){
                    signOffApprover.rtlCheckPointApproval = false;
                    signOffApprover.selectRTLDCE = false;
                }
                if(!sfm.DCE_Review_Approved__c){
                    signOffApprover.dceReviewdApproval = false;
                    signOffApprover.selectDCEReview = false;              
                }
            } 
            if(setOfPermissionSet.contains(label.DIWPhysicalDesignEngineer)){  
                if(!sfm.Physical_Design_Engineer__c){
                    signOffApprover.pdApproval = false;
                }
            } 
            if(setOfPermissionSet.contains(label.DIWProductEngineer)){  
                if(!sfm.Product_Engineer__c){
                    signOffApprover.peApproval = false;
                }
            }
        }
    }
    
    /**
    * @description saveSignOffDetail method is used to cretae new SignOff record.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionSignOff page
    */
    public Pagereference saveSignOffDetail(){
      try{
          //assigned the som record
          Sign_off_Module__c som = signOffModue;
          som.stage__c = recordTypeName; 
          if(null ==som.Design_Execution__c)
            som.Design_Execution__c = deId;
          som.SignOffExternalId__c = deId+':'+recordTypeName; 
          if(signOffApprover.aeChecked && !som.Application_Engineer__c && null ==som.AE_Approval__c && null ==som.AE_Approval_User__c) {
              som.Application_Engineer__c = true;
              som.AE_Approval__c = System.today();
              som.AE_Approval_User__c = UserInfo.getUserId();
          }
          if(signOffApprover.peChecked && !som.Product_Engineer__c && null ==som.PE_Approval__c && null ==som.PE_Approval_User__c) {
              som.Product_Engineer__c = true;
              som.PE_Approval__c = System.today();
              som.PE_Approval_User__c = UserInfo.getUserId();
              //updateDEActualDate(deId, recordTypeName, System.today());
          }
          if(signOffApprover.dceChecked && !som.Field_Design_Center_Engineer__c && null ==som.DCE_Approval__c && null ==som.DCE_Approval_User__c) {
              som.Field_Design_Center_Engineer__c = true;
              som.DCE_Approval__c = System.today();
              som.DCE_Approval_User__c = UserInfo.getUserId();
              updateDEActualDate(deId, recordTypeName, System.today());
          }
          if(signOffApprover.rtlChecked == true){
              som.DCE_RTL_Checkpoin__c = true;
          }
          if(signOffApprover.dceReviewChecked == true){
              som.DCE_Review_Approved__c = true;
          }
          if(signOffApprover.pdChecked && !som.Physical_Design_Engineer__c && null ==som.PD_Approval__c && null ==som.PD_Approval_User__c) {
              som.Physical_Design_Engineer__c = true;
              som.PD_Approval__c = System.today();
              som.PD_Approval_User__c = UserInfo.getUserId();
          }
          
        try{
          if(null !=som)
            upsert som SignOffExternalId__c;
        } 
        catch (Exception e) {
            GlobalUtility.logMessage('Error','DesignExecutionSignOffController','saveSignOffDetail','','Exception while creating Sign Off Module record',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
          
        if(signOffAttachment !=null && signOffAttachment.body != null) {
          signOffAttachment.Name = 'SOMAttachment_'+signOffAttachment.name;
          signOffAttachment.ParentId = som.Id; // the record the file is attached to
          insert signOffAttachment;
          signOffAttachment.clear();
        }    
        if(customerApprovalAttachment !=null && customerApprovalAttachment.body != null) {
          customerApprovalAttachment.Name = 'CustomerApproval_'+customerApprovalAttachment.name;
          customerApprovalAttachment.ParentId = som.Id; // the record the file is attached to
          insert customerApprovalAttachment;
          customerApprovalAttachment.clear();
        }
        }catch(DmlException ex){
          system.debug('Exception detail ' + ex);
        }
        
        cancelDT  = ApexPages.currentPage().getParameters().get('cancelDT');
    	enableCreateRTDTButton  = ApexPages.currentPage().getParameters().get('enableCreateRTDTButton');
        PageReference pageRef = new PageReference('/apex/DesignExecutionSignOffRecType?deId='+designExecution.id + '&cancelDT=' + cancelDT + '&enableCreateRTDTButton='+enableCreateRTDTButton); 
    	pageRef.setRedirect(true);
    	
        return pageRef; 
    }
    /**
    * @description showPopup method is to display the Pop up.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionSignOffRecType page
    */      
    public void showPopup(){
        List<String> SomList = new List<String>();
        for(Sign_off_Module__c som : listOfsignOffModue){
        	SomList.add(som.stage__c);                
        }
        if(!SomList.contains(selectedRT)){            
        	displayPopup = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select signed off RTx Checklist type to reset'));
        }
        else{           
            displayPopup = true;
        }
    	    
        
    }
    /**
    * @description closePopup method is to close the pop up.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionSignOffRecType page
    */     
    public void closePopup(){
    	displayPopup = false;    
    }    
    /**
    * @description resetSignOffDetail method is used to reset the existing SignOff record.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionSignOffRecType page
    */    
    public Pagereference resetSignOffDetail(){
        PageReference pageRef;
        List<String> lstSom = new List<String>();
        List<Sign_off_Module__c> somList= new List<Sign_off_Module__c>();	
        for(Sign_off_Module__c som : listOfsignOffModue){
            lstSom.add(som.stage__c);
            system.debug('lstSom**::'+lstSom);
            system.debug('signOffModue::::'+listOfsignOffModue); 
            if(som.Design_Execution__c == deId){
                system.debug('som.Design_Execution__c::::'+som.Design_Execution__c);
                if(som.SignOffExternalId__c != null && som.stage__c == selectedRT){
                    system.debug('som.stage__c::::'+som.stage__c);
                    if(som.Application_Engineer__c != null && som.Application_Engineer__c == true){
                        som.Application_Engineer__c = false;
                        som.AE_Approval__c = NULL;
                        som.AE_Approval_User__c = NULL;
                    }
                    if(som.Product_Engineer__c != null && som.Product_Engineer__c == true){
                        som.Product_Engineer__c = false;
                        som.PE_Approval__c = NULL;
                        som.PE_Approval_User__c = NULL;
                    }
                    if(som.Field_Design_Center_Engineer__c != null && som.Field_Design_Center_Engineer__c == true){
                        som.Field_Design_Center_Engineer__c = false;
                        som.DCE_Approval__c = NULL;
                        som.DCE_Approval_User__c = NULL;
                        if(som.DCE_RTL_Checkpoin__c != null && som.DCE_RTL_Checkpoin__c == true){
                            som.DCE_RTL_Checkpoin__c = false;
                        }
                        if(som.DCE_Review_Approved__c != null && som.DCE_Review_Approved__c == true){
                            som.DCE_Review_Approved__c = false;
                        }
                    }
                    if(som.Physical_Design_Engineer__c != null && som.Physical_Design_Engineer__c == true){
                        som.Physical_Design_Engineer__c = false;
                        som.PD_Approval__c = NULL;
                        som.PD_Approval_User__c = NULL;
                    }
                    
                    somList.add(som);
                }
            }           
        }
        system.debug('somList**::'+somList.size());
        if(!somList.IsEmpty()){
            try{    
        		update somList;
            } Catch(DmlException ex){
            	system.debug('Exception detail ' + ex);	    
            }       
        }    
        cancelDT  = ApexPages.currentPage().getParameters().get('cancelDT');
        enableCreateRTDTButton  = ApexPages.currentPage().getParameters().get('enableCreateRTDTButton');

        if(selectedRT == 'RTM RIT A'){
            pageRef = new pageReference('/apex/DesignExecutionSignOffRTM?RTName=' + selectedRT+'&deId='+designExecution.id);	    
        }
        else{
            pageRef = new PageReference('/apex/DesignExecutionSignOff?RTName=' + selectedRT+'&deId='+designExecution.id);
        }
        if(pageRef != null){
            pageRef.setRedirect(true);
            pageRef.getParameters().put('cancelDT',cancelDT);
            pageRef.getParameters().put('enableCreateRTDTButton',enableCreateRTDTButton);
        }    
        return pageRef;
    }
    
    /**
    * @description saveSignOffRTMDetail method is used to cretae new SignOff record.
    * @param    No Parameter
    * @return   Pagereference DesignExecutionSignOff page
    */    
    public Pagereference saveSignOffRTMDetail(){
        try{
            Sign_off_Module__c som = signOffModue;
            //Assigned value for som
            if(null ==som.stage__c)
                som.stage__c = recordTypeName; 
            if(null ==som.Design_Execution__c)
                som.Design_Execution__c = deId;
            if(null ==som.SignOffExternalId__c)
                som.SignOffExternalId__c = deId+':'+recordTypeName; 
            system.debug('signOffVal:::'+som.SignOffExternalId__c);
            //Verify the permission Set type and assigned the corrosponding date in SignOff Module based on user
            if(signOffApprover.aeChecked && !som.Application_Engineer__c && null ==som.AE_Approval__c && null ==som.AE_Approval_User__c) {
                som.Application_Engineer__c = true;
                som.AE_Approval__c = System.today();
                som.AE_Approval_User__c = UserInfo.getUserId();
            }
            if(signOffApprover.peChecked && !som.Product_Engineer__c && null ==som.PE_Approval__c && null ==som.PE_Approval_User__c) {
                som.Product_Engineer__c = true;
                som.PE_Approval__c = System.today();
                som.PE_Approval_User__c = UserInfo.getUserId();
                updateDEActualDate(deId, recordTypeName, System.today());
            }
            if(signOffApprover.dceChecked && !som.Field_Design_Center_Engineer__c && null ==som.DCE_Approval__c && null ==som.DCE_Approval_User__c) {
                som.Field_Design_Center_Engineer__c = true;
                som.DCE_Approval__c = System.today();
                som.DCE_Approval_User__c = UserInfo.getUserId();
                //updateDEActualDate(deId, recordTypeName, System.today());
            }
            if(signOffApprover.pdChecked && !som.Physical_Design_Engineer__c && null ==som.PD_Approval__c && null==som.PD_Approval_User__c) {
                som.Physical_Design_Engineer__c = true;
                som.PD_Approval__c = System.today();
                som.PD_Approval_User__c =UserInfo.getUserId();
            }
            if(customerChecked == true) {
                som.Customer__c = true;
                som.Customer_Approval__c = System.today();
            }
            if(customerReviewed == true) {
                som.RIT_Customer_Reviewed__c = true;
            }
            if(cusomerReviewedRTM == true){
                som.Customer_RTM_Reviewed__c = true;
            }
            if(som.RTM_Ready__c!= Null){
                updateDEActualDateReady(deId, recordTypeName, som.RTM_Ready__c);
            }
             if(null !=som){
                 upsert som SignOffExternalId__c;
                 
    	  /** Kushal commented - 2/15    if(designExecution != null && (designExecution.RTM_RIT_A_ready_Actual_Date__c != null
                                               && designExecution.RTM_RIT_B_ready_Actual_Date__c != null)){ */
                                                        
                 if(null !=designExecution && (null !=designExecution.RTM_e_Release_RIT_B_Actual_Date__c )){ 
                    BnP_OptionUtility  bnpOption = new BnP_OptionUtility();                            
                    bnpOption.updateOptionStages(new List<Id>{designExecution.Option__c}, 'Prototype Fulfillment');                                  
                 }

            } 
            
            if(signOffAttachment !=null && signOffAttachment.body != null) {
                signOffAttachment.Name = 'SOMAttachment_'+signOffAttachment.name;
                signOffAttachment.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachment;
                signOffAttachment.clear();
            }    
            if(signOffAttachmentRTC !=null && signOffAttachmentRTC.body != null) {
                signOffAttachmentRTC.Name = 'RTCSOMAttachment_'+signOffAttachmentRTC.name;
                signOffAttachmentRTC.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachmentRTC;
                signOffAttachmentRTC.clear();
            }    
            if(signOffAttachmentRTM !=null && signOffAttachmentRTM.body != null) {
                signOffAttachmentRTM.Name = 'RTMAttachment_'+signOffAttachmentRTM.name;
                signOffAttachmentRTM.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachmentRTM;
                signOffAttachmentRTM.clear();
            }   
            if(signOffAttachmentTMD !=null && signOffAttachmentTMD.body != null) {
                signOffAttachmentTMD.Name = 'TMDAttachment_'+signOffAttachmentTMD.name;
                signOffAttachmentTMD.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachmentTMD;
                signOffAttachmentTMD.clear();
            }  
            if(signOffAttachmentTDI !=null && signOffAttachmentTDI.body != null) {
                signOffAttachmentTDI.Name = 'TMDAttachment_'+signOffAttachmentTDI.name;
                signOffAttachmentTDI.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachmentTDI;
                signOffAttachmentTDI.clear();
            }   
            if(signOffAttachmentQLD !=null && signOffAttachmentQLD.body != null) {
                signOffAttachmentQLD.Name = 'QLDAttachment_'+signOffAttachmentQLD.name;
                signOffAttachmentQLD.ParentId = som.Id; // the record the file is attached to
                insert signOffAttachmentQLD;
                signOffAttachmentQLD.clear();
            }  
            if(customerApprovalAttachment !=null && customerApprovalAttachment.body != null) {
                customerApprovalAttachment.Name = 'CustomerApproval_'+customerApprovalAttachment.name;
                customerApprovalAttachment.ParentId = som.Id; // the record the file is attached to
                insert customerApprovalAttachment;
                customerApprovalAttachment.clear();
            } 
            if(customerApprovalAttachmentRTM !=null && customerApprovalAttachmentRTM.body != null) {
                customerApprovalAttachmentRTM.Name = 'CustomerApprovalRTM_'+customerApprovalAttachmentRTM.name;
                customerApprovalAttachmentRTM.ParentId = som.Id; // the record the file is attached to
                insert customerApprovalAttachmentRTM;
                customerApprovalAttachmentRTM.clear();
            }
        }
        catch (Exception e) {
            GlobalUtility.logMessage('Error','DesignExecutionSignOffController','saveSignOffRTMDetail','','Exception while creating Sign Off Module record for RTM type',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
          
      cancelDT  = ApexPages.currentPage().getParameters().get('cancelDT');
      enableCreateRTDTButton  = ApexPages.currentPage().getParameters().get('enableCreateRTDTButton');    
      PageReference pageRef = new PageReference('/apex/DesignExecutionSignOffRecType?deId='+designExecution.id); 
      if(pageRef !=null){
        	pageRef.setRedirect(true);
        	pageRef.getParameters().put('cancelDT',cancelDT);
        	pageRef.getParameters().put('enableCreateRTDTButton',enableCreateRTDTButton);
        }
      return pageRef; 
    }
    
    private Set<String> getApprovedMileStones(){
    	resetBtnDisp = true;
        Set<String> setOfMileStones = new Set<String>();
        signOffModuleMap = New Map<String,Sign_off_Module__c>();
        listOfsignOffModue = new List<Sign_off_Module__c>();
        
        getSignOffRTDetail();
        for(Sign_off_Module__c sfm : [SELECT Id, Name, RecordTypeId, RTL_Checkpoint_Reached__c, Application_Engineer__c, Field_Design_Center_Engineer__c, 
                                          Physical_Design_Engineer__c, Product_Engineer__c, IBM_ASIC__c, Customer_Details__c,AE_Approval__c , PD_Approval__c, 
                                          PE_Approval__c, DCE_Approval__c,  RIT_Type__c, Profile_ID__c, SignOffExternalId__c, Stage__c, Design_Execution__c,
                                          AE_Approval_User__c, DCE_Approval_User__c, PD_Approval_User__c, PE_Approval_User__c,Design_Execution__r.Option__r.RIT_Type__c,
                                          AE_Approval_Name__c, DCE_Approval_Name__c, PD_Approval_Name__c, PE_Approval_Name__c
                                          FROM Sign_off_Module__c 
                                          WHERE Design_Execution__c=:deId]){
          setOfMileStones.add(sfm.Stage__c);  
          signOffModuleMap.put(sfm.Stage__c, sfm);                                    
        } 
        
        //Add mile stone on same order which we have in record type list in vf page
        for(String mileStonetype: setSignoffRTs){
            if(signOffModuleMap.containsKey(mileStonetype))
               listOfsignOffModue.add(signOffModuleMap.get(mileStonetype)); 
        }
        if(!listOfsignOffModue.IsEmpty()){            
            for(Sign_off_Module__c som : listOfsignOffModue){
                if(som.stage__c == 'RTM RIT B' || som.stage__c == 'RTM RIT A/B'){
                	resetBtnDisp = false;
                    system.debug('resetBtnDisp*::::'+resetBtnDisp);
                }
                else{
                    resetBtnDisp = true;
                    system.debug('resetBtnDisp****::::'+resetBtnDisp);
                }
            }     
        }
        else{
            resetBtnDisp = false;
        }            
        return setOfMileStones;
    } 
    
    /**
    * @description updateDEActualDate method is used to update DE Actual date in DE page based on the
    *              different conditions of SignOff Module.
    * @param    No Parameter
    * @return   Null
    */
   @testvisible private void updateDEActualDate(String deId, String checkPoint, Date actualDate){
        //update DE object based on checkpoint entry in DE
        if(designExecution != null){
            if(checkPoint.equals(SIGNOFF_RTF)){
                designExecution.Release_to_Floorplan_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_EFF)){
                designExecution.Exit_from_Floorplan_Actual_Date__c = actualDate;
            } 
            if(checkPoint.equals(SIGNOFF_RTP)){
                designExecution.Release_to_Preliminary_Actual_Date__c = actualDate;
            } 
            if(checkPoint.equals(SIGNOFF_EFP)){
                designExecution.Exit_from_Preliminary_Actual_Date__c = actualDate;
            } 
            if(checkPoint.equals(SIGNOFF_RTL)){
                designExecution.Release_to_Layout_Actual_Date__c = actualDate;
            } 
            if(checkPoint.equals(SIGNOFF_RTC_READY)){
                designExecution.RTC_DT_ready_Actual_Date__c = actualDate;
            }   
            if(checkPoint.equals(SIGNOFF_RTC_RIT_B_READY)){
                designExecution.RTC_RIT_B_ready_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTC_RIT_A_READY)){
                designExecution.RTC_RIT_A_ready_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_RIT_A_READY)){
                designExecution.RTM_RIT_A_ready_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_RIT_B_READY)){
                designExecution.RTM_RIT_B_ready_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_DT)){
                designExecution.RTM_e_Release_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_RIT_A)){
                designExecution.RTM_e_Release_RIT_A_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_RIT_B)){
                designExecution.RTM_e_Release_RIT_B_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTC_RIT_A_B_Ready)){
               designExecution.RTC_Rit_A_B_Ready_Actual_Date__c = actualDate;
               designExecution.RTC_RIT_A_ready_Actual_Date__c = actualDate;
			   designExecution.RTC_RIT_B_ready_Actual_Date__c = actualDate;
            }
			if(checkPoint.equals(SIGNOFF_RTM_RIT_A_B)){
               designExecution.RTM_RIT_A_B_Actual_Date__c =actualDate;
               designExecution.RTM_e_Release_RIT_A_Actual_Date__c = actualDate;
			   designExecution.RTM_e_Release_RIT_B_Actual_Date__c = actualDate;
            }
			if(checkPoint.equals(SIGNOFF_RTM_DT_READY)){
               designExecution.RTM_DT_ready_Actual_Date__c =actualDate;
            }
        }                               
        try{
           if(Test.isRunningTest()){
              if(null !=designExecution)
                designExecution.id = deId;
                update designExecution;
           }
           else{
               if(null !=designExecution) 
                update designExecution;    
           }	    
	  //added by Naman :  logic to update Design Execution Sign off dates to device fields for PSP milestones
          if(null !=designExecution && designExecution.option__c != null && designExecution.option__r.device__c != null
            && (checkPoint.equals(SIGNOFF_RTM_RIT_B) || checkPoint.equals(SIGNOFF_RTM_RIT_A_B) || checkPoint.equals(SIGNOFF_RTM_RIT_A) || checkPoint.equals(SIGNOFF_RTM_DT))){
                
                Device__c dev = [Select id, Product_Line__c, RTM_e_Release_Dt_Current__c, RTM_e_Release_Dt_Done__c, RTM_e_Release_A_Current__c, RTM_e_Release_A_Done__c, Product_TO_Current__c, Actual_Tapeout_Date_Done__c from Device__c where id =: designExecution.option__r.device__c];
                
                if(dev.Product_Line__c == 'ASIC'){
                    if(checkPoint.equals(SIGNOFF_RTM_DT)){
                        dev.RTM_e_Release_Dt_Current__c = designExecution.RTM_e_Release_Actual_Date__c;
                        dev.RTM_e_Release_Dt_Done__c = true;
                    }
                    if(checkPoint.equals(SIGNOFF_RTM_RIT_A)){
                        dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_Actual_Date__c;
                        dev.RTM_e_Release_A_Done__c = true;
                    }
                    if(checkPoint.equals(SIGNOFF_RTM_RIT_B)){
                        dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_Actual_Date__c;
                        dev.Actual_Tapeout_Date_Done__c = true;
                    }
                    if(checkPoint.equals(SIGNOFF_RTM_RIT_A_B)){
                        dev.RTM_e_Release_A_Current__c = designExecution.RTM_e_Release_RIT_A_Actual_Date__c;
                        dev.Product_TO_Current__c = designExecution.RTM_e_Release_RIT_B_Actual_Date__c;
                        dev.Actual_Tapeout_Date_Done__c = true;
                        dev.RTM_e_Release_A_Done__c = true;
                    }
                }
                update dev;
          }
        } 
        catch (Exception e) {
            GlobalUtility.logMessage('Error','DesignExecutionSignOffController','updateDEActualDate','','Exception while Updating Actual date in Design Execution record',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
    }
    
     /**
    * @description updateDEActualDateReady method is used to update DE Ready Actual date in DE page based on the
    *              different conditions of SignOff Module.
    * @param    No Parameter
    * @return   Null
    */
    @testvisible private void updateDEActualDateReady(String deId, String checkPoint, Date actualDate){
        //update DE object based on checkpoint entry in DE
        if(designExecution != null){
            
            if(checkPoint.equals(SIGNOFF_RTM_RIT_A_READY) || checkPoint.equals(SIGNOFF_RTM_RIT_A)){
                designExecution.RTM_RIT_A_ready_Actual_Date__c = actualDate;
            }
            if(checkPoint.equals(SIGNOFF_RTM_RIT_B_READY) || checkPoint.equals(SIGNOFF_RTM_RIT_B)){
                designExecution.RTM_RIT_B_ready_Actual_Date__c = actualDate;
            }
           
            if(checkPoint.equals(SIGNOFF_RTM_DT_READY) || checkPoint.equals(SIGNOFF_RTM_DT)){
               designExecution.RTM_DT_ready_Actual_Date__c =actualDate;
            }
            
            if(checkPoint.equals(SIGNOFF_RTM_RIT_A_B)){
               designExecution.RTM_RIT_A_B_ready_Actual_Date__c = actualDate;
               designExecution.RTM_RIT_A_ready_Actual_Date__c = actualDate;
               designExecution.RTM_RIT_B_ready_Actual_Date__c = actualDate;
            }
        }                               
        try{
          if(null !=designExecution)
            update designExecution;
        } 
        catch (Exception e) {
            GlobalUtility.logMessage('Error','DesignExecutionSignOffController','updateDEActualDateReady','','Exception while Updating Actual date in Design Execution record',String.valueof(e.getMessage()),'','Design Execution',e,0);
        }
    }
    /**
    * @description validateSelectedMileStone method is validate selected value for SignOff milestone.
    *			  If DT checkpoint exists in design execution, and DT sign-off is not yet completed. 
    *			  Do not allow user to proceed with   Sign-off of Rit A/B or Rit A. (RTC Ready, RTM) & If Rit A/B Split is set in design execution, 
    *			  and Rit A sign-off is not yet completed. Do not allow user to proceed with Sign-off of Rit B (RTC Ready, RTM).	
    * @param    No Parameter
    */
    private void validateSelectedMileStone(){
    	dtRTCCheckpointFlag =false;
    	dtRTMCheckpointFlag = false;
    	rtcRITAFlag = false;
    	rtmRITAFlag =false;
    	Sign_off_Module__c signOffTemp = new Sign_off_Module__c();
    	
    	getApprovedMileStones();
    	
    	cancelDT  = ApexPages.currentPage().getParameters().get('cancelDT');
    	enableCreateRTDTButton  = ApexPages.currentPage().getParameters().get('enableCreateRTDTButton');
    	
    	signOffTemp = (!signOffModuleMap.isEmpty() && signOffModuleMap.containsKey(selectedRT))?signOffModuleMap.get(selectedRT):null;
    	
    	if(cancelDT.equalsIgnoreCase('False') || (cancelDT.equalsIgnoreCase('True') && !signOffModuleMap.isEmpty() && signOffModuleMap.containsKey(SIGNOFF_RTC_READY) 
    		&& (signOffModuleMap.get(SIGNOFF_RTC_READY).AE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTC_READY).DCE_Approval__c !=null 
    		|| signOffModuleMap.get(SIGNOFF_RTC_READY).PD_Approval__c !=null | signOffModuleMap.get(SIGNOFF_RTC_READY).PE_Approval__c !=null) 
    		&& (selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_A_READY)|| selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_A_B_Ready)))){
    		dtRTCCheckpointFlag =true;
    	}
    	
    	if(enableCreateRTDTButton.equalsIgnoreCase('False') || (enableCreateRTDTButton.equalsIgnoreCase('True') && !signOffModuleMap.isEmpty() && signOffModuleMap.containsKey(SIGNOFF_RTC_RIT_A_READY) 
    		&& (signOffModuleMap.get(SIGNOFF_RTC_RIT_A_READY).AE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTC_RIT_A_READY).DCE_Approval__c !=null 
    		|| signOffModuleMap.get(SIGNOFF_RTC_RIT_A_READY).PD_Approval__c !=null | signOffModuleMap.get(SIGNOFF_RTC_RIT_A_READY).PE_Approval__c !=null) 
    		&& (selectedRT.equalsIgnoreCase(SIGNOFF_RTC_RIT_B_READY)))){
    		rtcRITAFlag =true;
    	}
    	
    	if(cancelDT.equalsIgnoreCase('False') || (cancelDT.equalsIgnoreCase('True') && !signOffModuleMap.isEmpty() && signOffModuleMap.containsKey(SIGNOFF_RTM_DT)
    		&& (signOffModuleMap.get(SIGNOFF_RTM_DT).AE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTM_DT).DCE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTM_DT).PD_Approval__c !=null
    		|| signOffModuleMap.get(SIGNOFF_RTM_DT).PE_Approval__c !=null) && (selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_A) || selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_A_B)))){
    		dtRTMCheckpointFlag =true;
    	}
    	
    	if(enableCreateRTDTButton.equalsIgnoreCase('False') || enableCreateRTDTButton.equalsIgnoreCase('True')&& !signOffModuleMap.isEmpty() && signOffModuleMap.containsKey(SIGNOFF_RTM_RIT_A)
    		&& (signOffModuleMap.get(SIGNOFF_RTM_RIT_A).AE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTM_RIT_A).DCE_Approval__c !=null || signOffModuleMap.get(SIGNOFF_RTM_RIT_A).PD_Approval__c !=null 
    		|| signOffModuleMap.get(SIGNOFF_RTM_RIT_A).PE_Approval__c !=null) && (selectedRT.equalsIgnoreCase(SIGNOFF_RTM_RIT_B))){
    		rtmRITAFlag =true;
    	}
    }
    
     /**
    * @description sendSignOffTeamMemberEmail method is used to send the Email notification based on Opportunity Team member record 
    * @param    No Parameter
    * @return   Pagereference DesignExecutionRead page
    */
    public PageReference sendSignOffTeamMemberEmail() {
    	 Set<String> oppTeamEmails = new Set<String>();
		 oppTeamEmails = DesignExecutionUtility.fetchOpportunityTeamEmails(deid);
		//New instance of a single email message
		Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
		// Who you are sending the email to
		Contact c = [select id, Email from Contact Where email ='noreply@salesforce.com'  limit 1];
		Design_Execution__c DE =[Select id,RTx_Checklist__c  from Design_Execution__c where id=: designExecution.id limit 1];
        DE.RTx_Checklist__c = selectedRT;
        Update DE;
		mail.setTargetObjectId(c.id);
		mail.setTreatTargetObjectAsRecipient(false);
		//OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
		//mail.setOrgWideEmailAddressId(owa.id)
		//add To Address
		set<string> setEmailAddresses = new set<string>();
		if(oppTeamEmails != null && !oppTeamEmails.isEmpty() && oppTeamEmails.size() > 0){
			List<String> emails =new List<String>();
			emails.addAll(oppTeamEmails);
			mail.setToAddresses(emails);
		}
		//add the additional address into CC
		set<string> ccEmailAddresses = new set<string>();
		
		//add requestor in cc Email chain
		ccEmailAddresses.add(UserInfo.getUserEmail());
	
		if(setEmailAddresses.size() == 0 && ccEmailAddresses.size() == 0){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Email Id (To OR Additional Addresses) is Mandatory while sending the Email'));
			return null;
		}
	   // set<string> setCCEmailAddresses = new set<string>();
		if(ccEmailAddresses.size() > 0){
			List<String> emails =new List<String>();
			emails.addAll(ccEmailAddresses);
			mail.setCcAddresses(emails);
		}

		mail.setWhatId(signOffModue.Id); //Waiver Id to merge the template
		// The email template ID used for the email
		//EmailTemplate et= [Select id from EmailTemplate where DeveloperName='DesignExecutionWaiverCapability'];
		EmailTemplate et= [Select id from EmailTemplate where DeveloperName=:Label.DIWSignOffEmailTemplate];
		mail.setTemplateId(et.id);
        mail.setWhatId(designExecution.Id); 
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setSaveAsActivity(false);  
		
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
        cancelDT  = ApexPages.currentPage().getParameters().get('cancelDT');
    	enableCreateRTDTButton  = ApexPages.currentPage().getParameters().get('enableCreateRTDTButton');
        PageReference pageRef = new PageReference('/apex/DesignExecutionSignOffRecType?deId='+designExecution.id + '&cancelDT=' + cancelDT + '&enableCreateRTDTButton='+enableCreateRTDTButton); 
    	pageRef.setRedirect(true);
    	
    	return pageRef;      
    }
}