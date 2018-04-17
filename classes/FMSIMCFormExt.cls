/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the logic for rendering the IMC page.
 * @ Date :- 04/08/2016
 * @ Change History :-  
 * 21-Sep-2016     Inshu Misra      Added email template functionality 
 * 13-Oct-2016     Inshu Misra      Save button function modification
 * 14-Nov-2016     Ashwin Dash      Added Datachecking option value from Mapping table
 * 23-Nov-2016     Inshu Misra      Additional Contact Issue resolved for loggedinUser details and legacy data upload
 * 23-Nov-2016     Inshu Misra      to send emails when save button is clicked...#IM
 * 6-Dec-2016      Inshu Misra      Added code for exception framework...#IM
 * 3-Jan-2017      Anil Kumar Reddy L  Modified code for device update on Freeze and Redirection on Deletion.
 * 10-Jan-2017     Anil Kumar Reddy L  Modified code for validating data befor creating adendum form.
 * 10-Feb-2017      Inshu Misra     to avoid validation on save button click...#IM
 * 14-Feb-2017     Anirban Roy      Added to redirect the user to FMS Search page.
 *23-Feb-2017      Abhita Bansal    Changed the code for Datachecking Options to add select a value
 * 27-Apr-2017      Inshu Misra     Resolved Public URL Issue...#IM
 *17-May-2017      Abhita Bansal    Fixed the UAT Issue #62
 *19-May-2017      Abhita Bansal    Added the code for Catch-up Release T39 Point 1 and 2
 *22-May-2017      Inshu Misra      Changed the code for Primary and Additional Contact for Issue #170
 *05-Jun-2017      Abhita Bansal    Added by ABhita for new UAT issue #215
 *21-Jun-2017      Inshu Misra      Added code for Public URL issue..#IM
 *11-Jul-2017      Abhita Bansal    Added by Abhita for UAT Issue #420, 417
 *13-Jul-2017      Inshu Misra      Bug #427...#IM
 *14-Jul-2017     Inshu Misra    Added the Defect Fix for History Issue
 *20-Jul-2017    Ram Rai      Modified the subscription logic
 *01-Aug-2017      Abhita Bansal    Modified the code to associate the correct device on creation 
 *25-Aug-2017     Ravindra      Changed the document link to libraries
*01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue 
 *01-Nov-2017     Anirban Roy      Modified the code for Additional Contact Issue and removed with sharing.    
**/

public class FMSIMCFormExt{
    public Form_Management_System__c IMCFormObj {get;set;}
    public String fId {get;set;}
    public User loggedInUser {get;set;}
    public List < contact > contactInfo {get;set;}
    public String targCustomerPortUser {get;set;}
    public List < User > loggedInAccContList {get;set;}
    public Map < String, String > originalvalues = new Map < String, String > ();
    public Map <String, String> originalvalues1{get;set;}
    public String tranx{get;set;}
    public Set < String > techGeoSet {get;set;}
    public List < string > leftselected {get;set;}
    public List < string > rightselected {get;set;}
    public Map < String, string > leftvalues = new Map < String, string > ();
    public Map < String, string > rightvalues = new Map < String, string > ();
    public Map<String, AddContWrapper> selectedContactList{get;set;}
    public boolean skipvalidation {get;set;}
    public String addContactsCount {get;set;}
    public String uploadFileId {get;set;}
    public String uploadFileName {get;set;}
    public String uploadFileSize {get;set;}
    public String addContId = '';
    public String addContName = '';
    public String addContEmail = '';
    public String addContPhone = '';
    public List < List < String >> attachments {get;set;}
    public List < attachementWrapper > attWrap {get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public String userType = Schema.SObjectType.User.getKeyPrefix();
    public boolean isPortalUser {get;set;}
    public boolean popupVal {get;set;}
    public String requestMsg {get;set;}
    public String stateChangeComments {get;set;}
    public boolean popupCreateAdd {get;set;}
    public List < FMS_Subscription__c > fmsSubscriptionList;
    public FMS_Subscription__c fmsSubscription;
    public boolean subscribeFlag {get;set;}
    public List < addContactWrapper > selectedAddContList {get;set;}
    Public String soldTo {get;set;}
    public boolean shipCLLMainTech {get;set;}
    public List<ContentDocumentLink> conDocShare = new List<ContentDocumentLink>();
    public Map<String, String> FMSdocuments {get;set;}   //Added by Ravindra
    
    public boolean isFMSAdmin {get;set;}
    public Map<String,String> invalidInputCheckMap = new Map<String,String>();
    public boolean isInvalidInp{get;set;}
    public List<FMS_Mapping_Table__c> fmsMappingTable{get;set;}  
    public boolean exitForm{get;set;}
    public boolean dispDatacheckingOpts{get;set;}   
    public Map<String,String> invalidInpToFieldsMap = new Map<String, String>(); 
    public string selContentDocId { get; set; }
    public List<String> selServiceOptions{get;set;}
    public boolean showDesignChange{get;set;}
    public String deleteId;
    public Boolean checkBackside{get;set;}
    public Boolean checkOther{get;set;}
    public Boolean checkDicing{get;set;}
    public boolean dispBacksideGrindThickness{get;set;}
    public boolean dispOtherServiceFeatures{get;set;}
    public boolean dispChipEdgeDesign{get;set;}
    public Boolean disNumOfUniqDesigns{get;set;}
    public Boolean disDesignChangesSection{get;set;}
    public boolean hasChildren {get;set;} 
    public List<Id> accHList; //Modified the code to associate the correct device on creation
  public Boolean dispOrderPlacWafer{get;set;}
  
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE'); 
    public final String FMS_Admin_Group = EnvironmentVariable.get('FMS_Admin_Group'); 
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM'); 
    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM'); 
    
    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 
    public final String FMS_SAP_ACC_NO2 = EnvironmentVariable.get('FMS_SAP_ACC_NO2'); 
    public final String FMS_SAP_ACC_NO3 = EnvironmentVariable.get('FMS_SAP_ACC_NO3');
    public final String FMS_SAP_ACC_NO4 = EnvironmentVariable.get('FMS_SAP_ACC_NO4'); 
    public final String FMS_SAP_ACC_NO5 = EnvironmentVariable.get('FMS_SAP_ACC_NO5'); 
    public final String FMS_SAP_ACC_NO6 = EnvironmentVariable.get('FMS_SAP_ACC_NO6');
    public final String FMS_SAP_ACC_NO7 = EnvironmentVariable.get('FMS_SAP_ACC_NO7');
    public final String FMS_SAP_ACC_NO8 = EnvironmentVariable.get('FMS_SAP_ACC_NO8');
    public final String FMS_SAP_ACC_NO9 = EnvironmentVariable.get('FMS_SAP_ACC_NO9');
    public final String FMS_SAP_ACC_NO10 = EnvironmentVariable.get('FMS_SAP_ACC_NO10');
    public final String FMS_SAP_ACC_NO11 = EnvironmentVariable.get('FMS_SAP_ACC_NO11');
    public final String FMS_SAP_ACC_NO13 = EnvironmentVariable.get('FMS_SAP_ACC_NO13');
    public final String FMS_SAP_ACC_NO15 = EnvironmentVariable.get('FMS_SAP_ACC_NO15');
    
    public Set<Id> accountIds;
    public List<User> userList;
    public List<User> dmeaUserList;

    public List<ContentDocument> conDocDelete = new List<ContentDocument>(); // Added By Abhita for Prod issue #203
    
    //===============================(Start)Prod Issue# 164=================================== 
    public Form_Management_System__c parentServiceOpts{get;set;}
  
    //===============================(End)Prod Issue# 164===================================

  string currentPageName;
    public FMSIMCFormExt(ApexPages.StandardController controller) {
        String pageName = ApexPages.currentPage().getUrl();
      if(pageName.contains('?')) {
        currentPageName = pageName.substringBetween('apex/', '?'); 
      } else {
        currentPageName = pageName.substringAfter('apex/');
      }
    skipvalidation = false;
    dispDatacheckingOpts = false;    
    leftselected = new List < String > ();
    loggedInAccContList = new List < User > ();
    accHList = new List<Id>();//Modified the code to associate the correct device on creation
    originalValues = new Map<String, String>();
    originalvalues1 = new Map<String, String>(); 
    tranx = ApexPages.currentPage().getParameters().get('tranx');
    contactInfo = new List < Contact > ();
    selectedContactList = new Map<String, AddContWrapper>();
    techGeoSet = new Set < String > ();
    attachments = new List < List < String >> ();
    attWrap = new List < attachementWrapper > ();
    selectedAddContList = new List < addContactWrapper > ();
    checkBackside = false;
    checkOther = false;
    checkDicing = false;
    soldTo = null;
    shipCLLMainTech = false;
    exitForm = true;
    rightselected = new List < string > ();
    isInvalidInp = false; 
    disNumOfUniqDesigns = false;
    disDesignChangesSection = false; 
    if(currentPageName == 'FMSIMCFormPage') { 
              fmsMappingTable = [SELECT id, name, Added_Masks__c, DB_Value__c, Feature_Part_Numbers__c, Field__c, Technology__c, UI_Value__c FROM FMS_Mapping_Table__c Where is_Inactive__c = false];
            }
            else {
              fmsMappingTable = [SELECT id, name, Added_Masks__c, DB_Value__c, Feature_Part_Numbers__c, Field__c, Technology__c, UI_Value__c FROM FMS_Mapping_Table__c order by is_Inactive__c asc];
            }
    Id grpId = [SELECT ID, Name FROM Group WHERE DeveloperName = :FMS_Admin_Group].id;
    
        fId = ApexPages.currentPage().getParameters().get('id');
        
    loggedInUser = [SELECT id, Name, ContactId, Country, State, Email, Phone FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
    IMCFormObj = new Form_Management_System__c();
    popupCreateAdd = false;
    showDesignChange = false;
    fmsSubscriptionList = new List < FMS_Subscription__c > ();
    fmsSubscription = new FMS_Subscription__c();
    selServiceOptions = new List<String>();
    
    conDocDelete = new List<ContentDocument>(); // Added By Abhita for Prod issue #203
    
    FMSdocuments =  UtilityCls.getContentList(); 
     
    accountIds = new Set<Id>(); 
    userList = new List<User>();
    dmeaUserList = new List<User>();
    
    if (UserInfo.getUserType() != 'Standard') {
      isPortalUser = true;
    } else {
      isPortalUser = false;
    }
    
    if (!isPortalUser) {
      for (GroupMember m: [Select Id, UserOrGroupId From GroupMember Where GroupId = :grpId]) {
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
    System.debug('parentServiceOpts===============================>BEFORE FID' + fId);
    if (fId != null && fId != '') {
       //===============================(Start)Prod Issue# 164===================================
      // To fix Prod Issue#164 --Start
      IMCFormObj = [SELECT id, name, Name__c, Phone__c, Email__c, AdvancedProcessFileAttachment__c, ListOfMasksReusedFromOther__c , Waivers__c, State_of_the_Form__c, Mandatory_State_Change_Comments__c, DataCheckingOptions__c, IsGeneratePublicURLForAttach__c,
              ServiceOptions__c, ListOfMasksReused__c, FileAttachment__c, StepPlanCustomRequirement1__c, Main_Form_Id__r.Chip_Interconnect__c,Technology__c, Parent_Form_Id__r.ProductName__c, Parent_Form_Id__r.Technology__c,
              Parent_Form_Id__r.ProductRevision__c, Main_Form_Id__r.Technology__c, Main_Form_Id__r.QuoteOnly__c, form_type__c, Main_Form_Id__r.DesignSubmission__c, Main_Form_Id__r.TestServices__c, 
              Main_Form_Id__r.Packaging_Services__c, Main_Form_Id__r.CLL__c, ProductName__c, ParentChangesIdentified__c, PadLocFuncChange__c, Parent_Form_Id__r.ReleaseProcessFlow__c, ProductRevision__c, NamePrimary__c, 
              EmailPrimary__c, CountryPrimary__c, StatePrimary__c, IMCProjectedTapeout__c, Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, RolePrimary__c, ProjectedTapeout__c, IMCMaskLevelsImpacted__c, 
              NewMarkingInfo__c, Packaging_Services__c, PackageNetlistChange__c, TestServices__c, IMCOtherComments__c, OverrideParentOptions__c, Parent_Form_Id__r.DataCheckingOptions__c, Parent_Form_Id__r.ServiceOptions__c, 
              Parent_Form_Id__r.OtherServiceFeatures__c, Parent_Form_Id__r.Deliverable__c,QuoteOnly__c,Main_Form_Id__r.Device__c, Main_Form_Id__r.DataCheckingOptions__c, Main_Form_Id__r.ServiceOptions__c, 
              Main_Form_Id__r.OtherServiceFeatures__c, Main_Form_Id__r.Deliverable__c, Parent_Form_Id__r.IMCInputMethod__c, IMCInputMethod__c,Previous_State_Of_Form__c, DesignSubmission__c, 
              Parent_Form_Id__r.DesignSubmission__c, Parent_Form_Id__r.StepPlanCustomRequirement1__c, OtherServiceFeatures__c, Deliverable__c, NumOfUniqDesigns__c, Main_Form_Id__r.InputMethod__c, IMCNumOfDesigns__c, 
              IMCNumOfFEOLDesigns__c, NumOfBEOLDesigns__c, IMCNumOfBEOLDesigns__c, Custom_Features__c, CustomFeaturesDesc__c, StepPlanCustomRequirementInput1__c, TechFeatureRemoval__c, ShippingLabelCLL__c, Chipedgedesign__c, BacksideGrindThickness__c, NotMfgFeatures__c,  Selected_Contact_Ids__c  ,NotMfgFeaturesDesc__c ,
              Main_Form_Id__r.ReleaseProcessFlow__c, UserIdPrimary__c,Parent_Form_Id__r.CountryPrimary__c,Parent_Form_Id__r.StatePrimary__c, Main_Form_Id__r.StepPlanCustomRequirement1__c, Device__c,Parent_Form_Id__c , 
              Parent_Form_Id__r.recordtype.Name,PhonePrimary__c,Main_Form_Id__r.Display_Dicing__c,Parent_Form_Id__r.UserIdPrimary__c,Parent_Form_Id__r.NamePrimary__c,Parent_Form_Id__r.EmailPrimary__c,
              Parent_Form_Id__r.PhonePrimary__c,Parent_Form_Id__r.RolePrimary__c,Main_Form_Id__r.BacksideGrindThickness__c, Parent_Form_Id__r.BacksideGrindThickness__c,Parent_Form_Id__r.StepPlanCustomRequirementInput1__c ,
              Parent_Form_Id__r.OverrideParentOptions__c,Parent_Form_Id__r.Chipedgedesign__c 
              FROM Form_Management_System__c WHERE id = :fId];  
      
      parentServiceOpts=UtilityCls.getParentDesignServiceData(IMCFormObj);
      
      //===============================(End)Prod Issue# 164===================================
      
      if ((IMCFormObj.ProductName__c == null || IMCFormObj.ProductName__c == '') && tranx == 'New') {
        IMCFormObj.ProductName__c = IMCFormObj.Parent_Form_Id__r.ProductName__c;
      }
      if (IMCFormObj.Customer_Name__r.SAP_Account_Number__c != null) {                 
        soldTo = IMCFormObj.Customer_Name__r.SAP_Account_Number__c.split('-')[0];    
      }
      if (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE MR (SiGe 5MR)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PA (SiGe 5AM PA)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7TF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8SFG' || IMCFormObj.Main_Form_Id__r.Technology__c == 'EDRAM 8SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)') {
        shipCLLMainTech = true;
      }
      //===============================(Start)Prod Issue# 164===================================
      if(parentServiceOpts.ServiceOptions__c != '' && parentServiceOpts.ServiceOptions__c != NULL){
        if(parentServiceOpts.ServiceOptions__c.contains('Backside Grind') || parentServiceOpts.ServiceOptions__c.contains('Backside Grind')){
          checkBackside = true;
        } else {
          checkBackside = false;
        }
        if(parentServiceOpts.ServiceOptions__c.contains('Other'))  {
          checkOther = true;
        } else {
          checkOther = false;
        }
         }
      //===============================(End)Prod Issue# 164===================================
      if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && (IMCFormObj.ServiceOptions__c == null || IMCFormObj.ServiceOptions__c == '')){
        selServiceOptions = new List<String>();
        selServiceOptions.add('Dicing');
      }else if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && (IMCFormObj.ServiceOptions__c != null || IMCFormObj.ServiceOptions__c != '')){
        Set<String> selOptsSet = new Set<String>();
        selOptsSet.addAll(IMCFormObj.ServiceOptions__c.split(';'));
        for(String s : IMCFormObj.ServiceOptions__c.split(';')){
          selServiceOptions.add(s);
        }
        if(!selOptsSet.isEmpty()){
          if(!selOptsSet.contains('Dicing')){
            selServiceOptions.add('Dicing');
          }
        }            
        }else if(IMCFormObj.ServiceOptions__c != null && IMCFormObj.ServiceOptions__c != ''){
        for(String s : IMCFormObj.ServiceOptions__c.split(';')){
          selServiceOptions.add(s);
        }
      }
      Map < Id, Form_Management_System__c > allChildrenMap = new Map < Id, Form_Management_System__c > ([SELECT id, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c FROM Form_Management_System__c WHERE Parent_Form_Id__c = : fId]);
      if (allChildrenMap.isEmpty()) {
        hasChildren = false;
      } else {
        hasChildren = true;
      } 

      deleteId = ApexPages.currentPage().getParameters().get('delFormNum');
      if(tranx == 'delete'){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form successfully deleted : '+deleteId));
      }  
      if(tranx == 'InActiveStateChange')  {
        String previousState = ApexPages.currentPage().getParameters().get('previousState'); 
        String newState = ApexPages.currentPage().getParameters().get('newState');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+previousState+' to '+newState));
      }
      if(tranx == 'Subscribe'){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription created successfully'));
      } 
      if(tranx == 'UnSubscribe'){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription successfully removed'));
      }    
            
            for(Account_Hierarchy__c accH : [SELECT Account_Id__c,Id,Master_Account_Id__c,Name,Parent_Id__c FROM Account_Hierarchy__c Where Account_Id__c =: IMCFormObj.Customer_Name__c]) {
                accHList.add(accH.Parent_Id__c);
            }
            
            List<Device__c> devLst = [select account__c, Design_Partner__c, account__r.SAP_Account_Number__c from Device__c where id = :IMCFormObj.Main_Form_Id__r.Device__c Limit 1];
            
            if(devLst<>NULL && devLst.size()>0){
                if(devLst[0].account__r.SAP_Account_Number__c == SAP_ACC_NO){
                    accountIds.add(devLst[0].account__c);
                }
            }
            
            originalvalues.put(loggedInUser.Id, loggedInUser.Name);
            
            if(accountIds<>NULL && !accountIds.isEmpty()) {
                if(accHList<>NULL && !accHList.isEmpty()){
                    for(Id accHId : accHList){
                        if(!accountIds.contains(accHId)){
                            accountIds.add(accHId);
                        }
                    }
                }
                userList = [Select Id, Name, Contact.Email, Phone, Contact.AccountId from User where Contact.AccountId IN :accountIds and IsActive = true order by name];
                if(userList<>NULL && !userList.isEmpty()) {
                    for(User u: userList) {
                        if(u.Contact.AccountId == devLst[0].account__c) {
                            dmeaUserList.add(u);
                        }
                    }
                }
                if(dmeaUserList<>NULL && !dmeaUserList.isEmpty()){
                    for(User u : dmeaUserList){
                        if(u.Name != UserInfo.getName() && u.Contact.Email != UserInfo.getUserEmail()){
                            //For Additional Contacts
                            originalvalues1.put(u.Name, u.Id);
                            originalvalues.put(u.Id, u.Name);                    
                        }                       
                    }    
                }
            } else {           
                if(accHList<>NULL && !accHList.isEmpty()){
                    loggedInAccContList = new List<User>([Select Id, Name, Contact.Email, Contact.AccountId from User where Contact.AccountId IN :accHList and isActive = true order by name]);
                } else {
                    loggedInAccContList = new List<User>([Select Id, Name, Contact.Email, Contact.AccountId from User where Contact.AccountId =:IMCFormObj.Customer_Name__c and isActive = true order by name]);
                }
                if(loggedInAccContList<>NULL && !loggedInAccContList.isEmpty()){
                    for(User u : loggedInAccContList){
                        if(u.Name != UserInfo.getName() && u.Contact.Email != UserInfo.getUserEmail()){
                            originalvalues1.put(u.Name, u.Id);
                            originalvalues.put(u.Id, u.Name); 
                        }
                    }
                }
            }
            
            if (IMCFormObj.Selected_Contact_Ids__c != null && IMCFormObj.Selected_Contact_Ids__c != '') {
                for (String s: IMCFormObj.Selected_Contact_Ids__c.split(';')) {
                    if(originalValues.get(s) != null){
                        rightvalues.put(s, originalValues.get(s));
                    }
                }
                for (String s: originalValues.keySet()) {
                    if (s!= null && !rightValues.containsKey(s)) {
                        leftvalues.put(s, originalValues.get(s));
                    }
                }
            } else if(IMCFormObj.Name__c != null && IMCFormObj.Name__c != ''){
                for(String s : IMCFormObj.Name__c.split(';')){
                    if(s!= null && !rightvalues.containsKey(s)){
                        rightvalues.put(originalValues1.get(s), s);
                    }
                }
                for(String s : originalValues.keySet()){
                    if(s != null && !rightvalues.containsKey(s)){
                        leftvalues.put(s, originalValues.get(s));
                    }
                }
            }else {
                leftvalues = new Map<String, String>(originalValues);
            }
            
            if (!rightvalues.values().isEmpty()) {
                addContactsCount = String.valueOf(rightvalues.values().size());
            } else {
                addContactsCount = 'No';
            }
            List < String > attachmentIds = new List < String > ();
            if (IMCFormObj.IMCInputMethod__c != null && IMCFormObj.IMCInputMethod__c != '' 
                && IMCFormObj.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment' 
                && IMCFormObj.FileAttachment__c != null && IMCFormObj.FileAttachment__c != '') {
                attachmentIds.add(IMCFormObj.FileAttachment__c);
            }
                  
            if (IMCFormObj.IMCInputMethod__c != null && IMCFormObj.IMCInputMethod__c != '' 
                && IMCFormObj.IMCInputMethod__c == 'Advanced Process: Inputs via XML file attachment' 
                && IMCFormObj.AdvancedProcessFileAttachment__c != null && IMCFormObj.AdvancedProcessFileAttachment__c != '') {
                attachmentIds.add(IMCFormObj.AdvancedProcessFileAttachment__c);
            }
            if(!attachmentIds.isEmpty() && attachmentIds<>null){
                Integer filesize;
                for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentIds]) {
                    attachementWrapper attWrapInst = new attachementWrapper();
                    attWrapInst.attName = attDetails.Title;
                    attWrapInst.attId = attDetails.Id;
                    attWrapInst.ContentDocumentId = attDetails.ContentDocumentId;
                    filesize = Integer.valueOf(attDetails.ContentSize/1024);
                    if(filesize>1024) {
                        filesize = Integer.valueOf(filesize/1024);
                        attWrapInst.attSize = filesize + ' MB';
                    } else if(filesize == 0){
                        attWrapInst.attSize = attDetails.ContentSize + ' Bytes';
                    } else {
                        attWrapInst.attSize = filesize + ' KB';
                    }
                    attWrap.add(attWrapInst);
                }
            }
            IMCFormObj.IsGeneratePublicURLForAttach__c = !isPortalUser;
            
            subscribeFlag = false;
            fmsSubscriptionList = [Select id, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Subscribed_Date__c, UnSubscribed_Date__c, Form_Deleted__c FROM FMS_Subscription__c WHERE Form_Id__c = :fId AND User_Name__c = :UserInfo.getUserId() and UnSubscribed_Date__c=null  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Saved_Search_Id__c=null];
            
            if (fmsSubscriptionList != null && fmsSubscriptionList.size() > 0) {
                fmsSubscription = fmsSubscriptionList[0];
                subscribeFlag = true;
            } else {
                subscribeFlag = false;
            }
           
            renderotherServiceFeatures();
            renderChipEdgeDesign();
            renderBacksideGrindThickness();
            renderDataCheckingOpts(); 
            renderDesignChangesSection(); 
            renderDispWaferQuant();
            getIMCDataCheckingOption();
            if(!ApexPages.currentPage().getUrl().contains('view') && !ApexPages.currentPage().getUrl().contains('View')){
                prepopulateValues(); 
            }
            populateAdditionalContacts();
        }
    }
    public void populateAdditionalContacts(){
        if (IMCFormObj.Name__c != null && IMCFormObj.Name__c != '') {
            List < String > nameList = IMCFormObj.Name__c.split(';');
            List < String > phoneList = (IMCFormObj.Phone__c != null && IMCFormObj.Phone__c != '')?IMCFormObj.Phone__c.split(';'):new List<String>();
            List < String > emailList = (IMCFormObj.Email__c != null && IMCFormObj.Email__c != '')?IMCFormObj.Email__c.split(';'):new List<String>();
            addContactWrapper adc;
            for (Integer i = 0; i < nameList.size(); i++) {
                adc = new addContactWrapper(nameList[i], i<emailList.size()?emailList[i]:'', i<phoneList.size()?phoneList[i]:'');
                selectedAddContList.add(adc);
            }
        }else{
            selectedAddContList.clear();
        }
        if (selectedAddContList != null && !selectedAddContList.isEmpty()) {
            addContactsCount = String.valueOf(selectedAddContList.size());
        } else {
            addContactsCount = 'No';
        }
    }
   
    //===============================(Start)Prod Issue# 164===================================
    public void renderDataCheckingOpts(){
        if((IMCFormObj.OverrideParentOptions__c == 'Yes' && (parentServiceOpts.DataCheckingOptions__c != null && parentServiceOpts.DataCheckingOptions__c != '')) || 
            ((IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' ||
            IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF'  || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)'  || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)'  || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') 
            && IMCFormObj.OverrideParentOptions__c == 'No' && parentServiceOpts.DataCheckingOptions__c == 'Full' && 
            ((IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c  == 'No') || 
            (IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c  == 'No' && 
            (parentServiceOpts.StepPlanCustomRequirement1__c == 'Yes'))) && 
            (parentServiceOpts.DataCheckingOptions__c != null && parentServiceOpts.DataCheckingOptions__c != ''))){
                dispDatacheckingOpts = true;
            }else{
                dispDatacheckingOpts = false;
            }        
            renderDesignChangesSection(); 
    }
    
    public void renderDispWaferQuant(){
        if((IMCFormObj.Main_Form_Id__r.Technology__c ==  UtilityCls.IPD5PAE 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CSOI_7RF 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CSOI_7SW 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CSOS_7RF 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMHV7SF  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF   
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP  
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CM7FRAM 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMS90WG_CMOS9WG 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.SOI7SWT 
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.I45RFSOI
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.CSOI8SW
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4
            || IMCFormObj.Main_Form_Id__r.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA)){
                dispOrderPlacWafer = true;
            }else{
                dispOrderPlacWafer = false;
            }             
    }
    
    //===============================(End)Prod Issue# 164===================================
    public void renderingOfSelected(){
        resetDependentFields();
    }

    public void changeInputMethod() {
        resetDependentFields();
        attWrap.clear();
    }

    public List < SelectOption > getprimaryContactsList() {
        List<User> newUserList = new List<User>();
        List < SelectOption > tempList = new List < SelectOption > ();
        if((IMCFormObj.UserIdPrimary__c == null || IMCFormObj.UserIdPrimary__c == '') && (IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c != null && IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c != '' && IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c != UserInfo.getUserId())){
            tempList.add(new SelectOption(IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c, IMCFormObj.Parent_Form_Id__r.NamePrimary__c));
        } else if(IMCFormObj.UserIdPrimary__c != null && IMCFormObj.UserIdPrimary__c != '' && IMCFormObj.UserIdPrimary__c != UserInfo.getUserId()){
            tempList.add(new SelectOption(IMCFormObj.UserIdPrimary__c, IMCFormObj.NamePrimary__c));
        } //else {
            tempList.add(new SelectOption(UserInfo.getUserId(), UserInfo.getName()));
        //}
        if(accountIds<>NULL && !accountIds.isEmpty()) {
            if(dmeaUserList<>NULL && !dmeaUserList.isEmpty()){
                newUserList.addAll(dmeaUserList);
            }
        } else if(loggedInAccContList<>NULL && !loggedInAccContList.isEmpty()) {
            newUserList.addAll(loggedInAccContList);
        } 
        if(newUserList<>NULL && !newUserList.isEmpty()){
            for(User u : newUserList){
                if(u.Name != UserInfo.getName() && u.Contact.Email != UserInfo.getUserEmail() && u.Id != IMCFormObj.UserIdPrimary__c){
                    tempList.add(new SelectOption(u.Id, u.Name));
                }
            }
        }
        return tempList;
    }

    public List < SelectOption > getParentChangesIdentified() {

        List < SelectOption > options = new List < SelectOption > ();
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.ParentChangesIdentified__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', FMS_SELECT_VAL));
        for(Schema.PicklistEntry f : ple){             
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            if(IMCFormObj.ParentChangesIdentified__c == null || IMCFormObj.ParentChangesIdentified__c == ''){
                IMCFormObj.ParentChangesIdentified__c = 'No';
            }
        } 
        return options;
    }

    public void prepopulateValues() {
        Id primaryUserId;
        if((IMCFormObj.UserIdPrimary__c == null || IMCFormObj.UserIdPrimary__c == '') && (IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c != null && IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c != '')){
            primaryUserId = IMCFormObj.Parent_Form_Id__r.UserIdPrimary__c;
        } else {
            primaryUserId = IMCFormObj.UserIdPrimary__c;
        }
        List<User> primUser = new List<User>([select Id, Name, email, Contact.Email, country, state, phone from User where Id =:primaryUserId]);
        if(primUser<>NULL && !primUser.isEmpty()){
            IMCFormObj.NamePrimary__c = primUser[0].name;
            IMCFormObj.EmailPrimary__c = (primUser[0].Contact.Email != null) ? primUser[0].Contact.Email : primUser[0].email;
            IMCFormObj.CountryPrimary__c = primUser[0].Country;
            IMCFormObj.StatePrimary__c = primUser[0].State;
            IMCFormObj.PhonePrimary__c = primUser[0].Phone;
        }
    }
  
    public PageReference selectclick() {
        rightselected.clear();
        for (String s: leftselected) {
            leftvalues.remove(s);
            rightvalues.put(s, originalValues.get(s));
        }
        updateCountOfAddContacts();
        return null;
    }

    public PageReference unselectclick() {
        leftselected.clear();
        for (String s: rightselected) {
            rightvalues.remove(s);
            leftvalues.put(s, originalValues.get(s));
        }
        updateCountOfAddContacts();
        return null;
    }
    public List < SelectOption > getunSelectedValues() {
        List < SelectOption > options = new List < SelectOption > ();
        for (string s: leftValues.keySet()){
            if(s!= null){
                options.add(new SelectOption(s, originalValues.get(s)));
            }
        }
        return options;
    }

    public List < SelectOption > getSelectedValues() {
        List < SelectOption > options1 = new List < SelectOption > ();
        for (String s: rightValues.keySet()){
            if(s != null){
                options1.add(new SelectOption(s, originalValues.get(s)));
            }
        }
        return options1;
    }

    public List<AddContWrapper> getaddContTable(){
        selectedContactList = new Map<String, AddContWrapper>();
        if(!rightvalues.keySet().isEmpty()){
            if(rightvalues.keySet().contains(UserInfo.getUserId())){
                selectedContactList.put(UserInfo.getUserId(), new AddContWrapper(UserInfo.getName(), UserInfo.getUserEmail(), loggedinUser.Phone, UserInfo.getUserId()));
            }
            for(User u:[SELECT id, Name, Phone, Email, Contact.Email FROM User WHERE Id IN : rightvalues.keySet() and isActive =true order by Name]){
                String newEmail = (u.Contact.Email != null) ? u.Contact.Email : u.email;
                selectedContactList.put(u.Id, new AddContWrapper(u.Name, newEmail, u.Phone, u.Id));
            } 
        }
        return selectedContactList.values();
    }
    
    //===============================(start)Prod Issue# 164===================================
    public String getdataCheckingOptsIMC(){
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Datacheck Options'){
                if(parentServiceOpts.DataCheckingOptions__c != null && parentServiceOpts.DataCheckingOptions__c != ''){
                    if(fmsTab.DB_Value__c == parentServiceOpts.DataCheckingOptions__c){
                        return fmsTab.UI_Value__c;
                    }
                }
            }
        }
        return '';
    }
    //===============================(End)Prod Issue# 164===================================
      
    public String getdataCheckingOptsIMCOnly(){
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.DB_Value__c == IMCFormObj.DataCheckingOptions__c){
                return fmsTab.UI_Value__c;
            }
        }
        return '';
    }

    public List < SelectOption > getIMCDataCheckingOption() {
        List < SelectOption > tempList = new List < SelectOption > ();
        tempList.add(new SelectOption('', FMS_SELECT_VAL));
        if(IMCFormObj.DataCheckingOptions__c != null && IMCFormObj.DataCheckingOptions__c != '') {
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.DB_Value__c == IMCFormObj.DataCheckingOptions__c){
                    tempList.add(new SelectOption(IMCFormObj.DataCheckingOptions__c, fmsTab.UI_Value__c));
                }
            }
        }

        if (IMCFormObj.DataCheckingOptions__c != 'MFG-Only' && ((IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' ||
                                                       IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)'
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' ||
                                                       IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)'
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') && 
                                                       
                                                       !((IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' || IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes') && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6HP (SiGe 6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6HP DM (SiGe 6SF DM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HP (SiGe 5HP)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HP AM (SiGe 5AM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PA (SiGe 5AM PA)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5DP (SiGe 5DP)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5DM (SiGe 5DM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE MR (SiGe 5MR)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5S0' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7TF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CIMG 7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CIMG 7HY' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6MS' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' 
                                                       || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)'))) || (IMCFormObj.StepPlanCustomRequirement1__c == 'Yes') ||
            (IMCFormObj.OverrideParentOptions__c == 'No' && IMCFormObj.StepPlanCustomRequirement1__c == 'Yes') || (IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' && IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No')) {
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.Technology__c == 'All' && fmsTab.DB_Value__c == 'MFG-Only' && fmsTab.DB_Value__c != IMCFormObj.DataCheckingOptions__c){
                    tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }
            }               
        }

        if (IMCFormObj.DataCheckingOptions__c != 'Full' && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6HP (SiGe 6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6HP DM (SiGe 6SF DM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HP (SiGe 5HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HP AM (SiGe 5AM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PA (SiGe 5AM PA)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5DP (SiGe 5DP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5DM (SiGe 5DM)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE MR (SiGe 5MR)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5S0' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7TF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CIMG 7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CIMG 7HY' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6SF' || 
            ((IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || 
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' ||
            IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') 
            && ((IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes') || (IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes') || (IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && IMCFormObj.StepPlanCustomRequirement1__c == 'No'
            ))))) {
            
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.Technology__c == 'All' && fmsTab.DB_Value__c == 'Full' && fmsTab.DB_Value__c != IMCFormObj.DataCheckingOptions__c){
                    tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }
            }               
            
        }
        return tempList;
    }

    public boolean validationCheck(String Type){//Added by Abhita for Legacy form - 20092017
        boolean val = false;
        //Added by Abhita for Legacy form - 20092017
        String formId;
        if(IMCFormObj != null && IMCFormObj.Name != null){
            formId= String.valueOf(IMCFormObj.Name);
        }
        if(formId != null && IMCFormObj.Id != null && formId.startsWith('1') && Type == 'CreateAddendum'){
            val = false;
        }
        else {//END -- Added by Abhita for Legacy form - 20092017
            if (IMCFormObj.ProductName__c == null || IMCFormObj.ProductName__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: New Product Name (only alter if changing): is a Required field'));
                val = true;
            }
            if (IMCFormObj.ProductRevision__c == null || IMCFormObj.ProductRevision__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: New Product Revision: is a Required field'));
                val = true;
            }
            if (IMCFormObj.IMCProjectedTapeout__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Projected GDS submission (tapeout): is a Required field'));
                val = true;
            }

            if (IMCFormObj.Waivers__c == null || IMCFormObj.Waivers__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will you require waivers for any DRC violations? is a Required field'));
                val = true;
            }
            if (IMCFormObj.IMCMaskLevelsImpacted__c == null || IMCFormObj.IMCMaskLevelsImpacted__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: New mask levels to be built (impacted list): is a Required field'));
                val = true;
            }
            if (soldTo != null && checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO15) && (IMCFormObj.ListOfMasksReusedFromOther__c == null || IMCFormObj.ListOfMasksReusedFromOther__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List of masks to be reused from other designs. List specific revision number or product name. List by level and IBM Mask Part Number: is a Required field'));
                val = true;
            }
            if (IMCFormObj.ListOfMasksReused__c == null || IMCFormObj.ListOfMasksReused__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List of masks to be reused. List specific revision number or product name. List by level is a Required field'));
                val = true;
            }
            if (soldTo != null && (checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO13) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO7) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO6) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO10) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO8) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO3) || checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO9)) && shipCLLMainTech && (IMCFormObj.Main_Form_Id__r.CLL__c == 'Standard CLL (133X71LS)' || IMCFormObj.Main_Form_Id__r.CLL__c == 'Non-standard CLL (requires pre-approval)') && (IMCFormObj.ShippingLabelCLL__c == null || IMCFormObj.ShippingLabelCLL__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Identify your Shipping Label Customer Part Number for CLL: is a Required field'));
                val = true;
            }
            if ((IMCFormObj.NewMarkingInfo__c == null || IMCFormObj.NewMarkingInfo__c == '') && (IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: New Marking information? is a Required field'));
                val = true;
            }
            if ((IMCFormObj.PackageNetlistChange__c == null || IMCFormObj.PackageNetlistChange__c == '') && (IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Package Netlist change?: is a Required field'));
                val = true;
            }
            if ((IMCFormObj.PadLocFuncChange__c == null || IMCFormObj.PadLocFuncChange__c == '') && (IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Pad I/O location and/or function change?: is a Required field'));
                val = true;
            }
            if (IMCFormObj.Main_Form_Id__r.QuoteOnly__c != 'Yes' && (IMCFormObj.OverrideParentOptions__c == null || IMCFormObj.OverrideParentOptions__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you wish to change these Design/Service options?: is a Required field'));
                val = true;
            }
            if (dispDatacheckingOpts && (IMCFormObj.DataCheckingOptions__c == null || IMCFormObj.DataCheckingOptions__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Data Checking Options: is a Required field'));
                val = true;
            }
            if (IMCFormObj.OverrideParentOptions__c == 'Yes' && (selServiceOptions == null || selServiceOptions.isEmpty())) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Service Options: is a Required field'));
                val = true;
            }
            set<String> serviceOptSet = new set<String>();
            serviceOptSet.addAll(selServiceOptions);
            if (dispOtherServiceFeatures && IMCFormObj.OverrideParentOptions__c == 'Yes' && (IMCFormObj.OtherServiceFeatures__c == null || IMCFormObj.OtherServiceFeatures__c == '' || IMCFormObj.OtherServiceFeatures__c == 'None')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other service features: is a Required field'));
                val = true;
            }
            if ((IMCFormObj.OverrideParentOptions__c == 'Yes') && (IMCFormObj.Deliverable__c == null || IMCFormObj.Deliverable__c == '' || IMCFormObj.Deliverable__c == 'None')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Deliverable: is a Required field'));
                val = true;
            }

            if ((IMCFormObj.IMCOtherComments__c == null || IMCFormObj.IMCOtherComments__c == '') && (IMCFormObj.ParentChangesIdentified__c == 'Yes')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Describe those changes: is a Required field'));
                val = true;
            }
            
            if ((IMCFormObj.OverrideParentOptions__c == 'Yes') && (IMCFormObj.DesignSubmission__c == null || IMCFormObj.DesignSubmission__c == '' || IMCFormObj.DesignSubmission__c == 'None')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Type of Design Submission: is a Required field'));
                val = true;
            }
            if(disDesignChangesSection && disNumOfUniqDesigns && (IMCFormObj.NumOfUniqDesigns__c == null || IMCFormObj.NumOfUniqDesigns__c == '')) {  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are you changing the number of unique Front-End or Back-End designs for this product? is a Required field'));
                val = true;
            }
            if(disDesignChangesSection && (IMCFormObj.IMCInputMethod__c == null || IMCFormObj.IMCInputMethod__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your step plan input Methodology: is a Required field'));
                val = true;
            }
            if (IMCFormObj.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment' &&(IMCFormObj.FileAttachment__c == null || IMCFormObj.FileAttachment__c=='')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Reticle Layout Information: is required'));
                val = true;
            }
            
            if (IMCFormObj.IMCInputMethod__c == 'Advanced Process: Inputs via XML file attachment' &&(IMCFormObj.AdvancedProcessFileAttachment__c == null || IMCFormObj.AdvancedProcessFileAttachment__c=='')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Reticle Layout XML file: is required'));
                val = true;
            }
            if ((IMCFormObj.NumOfUniqDesigns__c != '' && IMCFormObj.NumOfUniqDesigns__c != null 
                && disDesignChangesSection && IMCFormObj.IMCInputMethod__c != '' && IMCFormObj.IMCInputMethod__c != FMS_SELECT_VAL) && IMCFormObj.IMCNumOfDesigns__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What is the total number of Topcells that will be submitted for this program?: is a Required field'));
                val = true;
            }
            if ((IMCFormObj.NumOfUniqDesigns__c != '' && IMCFormObj.NumOfUniqDesigns__c != null 
                && disDesignChangesSection && IMCFormObj.IMCInputMethod__c != '' && IMCFormObj.IMCInputMethod__c != FMS_SELECT_VAL) && IMCFormObj.IMCNumOfFEOLDesigns__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Front End of Line (precontact) designs: is a Required field'));
                val = true;
            }
            if ((IMCFormObj.NumOfUniqDesigns__c != '' && IMCFormObj.NumOfUniqDesigns__c != null 
                && disDesignChangesSection && IMCFormObj.IMCInputMethod__c != '' && IMCFormObj.IMCInputMethod__c != FMS_SELECT_VAL) && IMCFormObj.IMCNumOfBEOLDesigns__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Back End of Line (Metal) designs: is a Required field'));
                val = true;
            }
            if (dispChipEdgeDesign && IMCFormObj.OverrideParentOptions__c == 'Yes' && (IMCFormObj.Chipedgedesign__c == null || IMCFormObj.Chipedgedesign__c == '')  ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: GLOBALFOUNDRIES sourced dicing will be supported only if the PDK-supplied crackstop is present inside your design(s) CHIPEDGE. Have you included the unmodified PDK-supplied crackstop within your design(s)? is a Required field'));
                val = true;
            }
            if (dispBacksideGrindThickness && IMCFormObj.OverrideParentOptions__c == 'Yes' && (IMCFormObj.BacksideGrindThickness__c == null || IMCFormObj.BacksideGrindThickness__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please choose a Backside Grind Thickness: is a Required field')); 
                val = true;
            }
            if ((IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes') && (IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT') && (IMCFormObj.OverrideParentOptions__c == 'Yes' || (IMCFormObj.OverrideParentOptions__c == 'No' && (IMCFormObj.Parent_Form_Id__r.StepPlanCustomRequirement1__c == 'Yes') && IMCFormObj.Parent_Form_Id__r.DataCheckingOptions__c == 'Full')) && (IMCFormObj.StepPlanCustomRequirement1__c == null || IMCFormObj.StepPlanCustomRequirement1__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will your orders be placed for wafer quantity, with wafer functional test as a service-only adder? is a Required field'));
                val = true;
            }
            
            
            if ((IMCFormObj.StepPlanCustomRequirement1__c == 'No' && ((IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' 
                && IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes') && (IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOS 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') && (IMCFormObj.OverrideParentOptions__c == 'Yes' 
                || (IMCFormObj.OverrideParentOptions__c == 'No' && (parentServiceOpts.StepPlanCustomRequirement1__c == 'Yes') 
                && parentServiceOpts.DataCheckingOptions__c == 'Full')))) && (IMCFormObj.StepPlanCustomRequirementInput1__c == null 
                || IMCFormObj.StepPlanCustomRequirementInput1__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please explain how your orders will be placed: is a Required field'));
                val = true;
            }

            
            if ((IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)'  
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe'  
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9SF' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)'
                 || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI'
                 || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)')
                 && (IMCFormObj.TechFeatureRemoval__c == null || IMCFormObj.TechFeatureRemoval__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the design contain any additions or removals of technology features compared to the previous revision? is a Required field'));
                val = true;
            } 

            
            if (IMCFormObj.TechFeatureRemoval__c == 'Yes' && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)'
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)'
                || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI'
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') 
                && (IMCFormObj.Custom_Features__c == null || IMCFormObj.Custom_Features__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any custom or development features that are not part of the base or optional features listings in the published design manual is a Required field'));
                val = true;
            }
            
             
            if (IMCFormObj.TechFeatureRemoval__c == 'Yes' && IMCFormObj.Custom_Features__c == 'Yes' 
                && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9SF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') 
                && (IMCFormObj.CustomFeaturesDesc__c == null || IMCFormObj.CustomFeaturesDesc__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list these non standard features: is a Required field'));
                val = true;
            }

           
            if (IMCFormObj.TechFeatureRemoval__c == 'Yes' && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)')
                && (IMCFormObj.NotMfgFeatures__c == null || IMCFormObj.NotMfgFeatures__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any features that should NOT be manufactured for this program revision? is a Required field'));
                val = true;
            }
            
          
            if (IMCFormObj.TechFeatureRemoval__c == 'Yes' && IMCFormObj.NotMfgFeatures__c == 'Yes' 
                && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9RFe' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'IPD5PAE' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMHV7SF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7HP (SiGe 7SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 8RF (CMRF8SF)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9SF' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 6RF (CMRF6SF)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7WL (SiGe 7WL)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
                || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)' || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI' || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)') && (IMCFormObj.NotMfgFeaturesDesc__c == null 
                || IMCFormObj.NotMfgFeaturesDesc__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list all features that should be excluded from the build is a Required field'));
                val = true;
            }
           
            if(isInvalidInp){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format. Please note the value enterred in wrong format will not be saved. is a Required field'));
                val = true;
            }
            if(IMCFormObj.ParentChangesIdentified__c == null || IMCFormObj.ParentChangesIdentified__c == '' ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are there any changes from the parent form not identified elsewhere in this IMC form? is a Required field'));
                val = true; 
            }
        }//Added by Abhita for Legacy form - 20092017
        return val;
    }
    
    public PageReference validateSave(){
        boolean val = false;
        val = validationCheck(null); //Added by Abhita for Legacy form - 20092017
        if (!exitForm || skipValidation || !val) {
            for(AddContWrapper cc : selectedContactList.values()){
                Boolean addNamePhone = false;
                if(!addContId.contains(cc.Id)){
                    addContId += cc.Id+';';
                    addNamePhone = true;
                }
                if(addNamePhone){
                    addContEmail = addContEmail + cc.Email + ';';
                    addContName = addContName + cc.Name + ';';
                    if (cc.Phone == null || cc.Phone == '') {
                        addContPhone = addContPhone + 'NA;';
                    } else {
                        addContPhone = addContPhone + cc.Phone + ';';
                    }
                }
            }
            IMCFormObj.Selected_Contact_Ids__c = addContId;
            IMCFormObj.Name__c = addContName;
            IMCFormObj.Email__c = addContEmail;
            IMCFormObj.Phone__c = addContPhone;
            if(!invalidInputCheckMap.isEmpty()){
                for(String s : invalidInputCheckMap.keySet()){
                    if(invalidInputCheckMap.get(s) == 'true'){
                        if(invalidInpToFieldsMap.get(s) == 'IMCNumOfBEOLDesigns__c'){
                            IMCFormObj.IMCNumOfBEOLDesigns__c = null;     
                        }
                        if(invalidInpToFieldsMap.get(s) == 'IMCNumOfDesigns__c'){
                            IMCFormObj.IMCNumOfDesigns__c = null;     
                        }
                        if(invalidInpToFieldsMap.get(s) == 'IMCNumOfFEOLDesigns__c'){
                            IMCFormObj.IMCNumOfFEOLDesigns__c = null;     
                        }
                    }
                }                           
            }
            String ServiceOpts = '';
            Set<String> servOptsSet = new Set<String>();
            servOptsSet.addAll(selServiceOptions);
            Boolean Start = true;
            if(!selServiceOptions.isEmpty()){
                if(!servOptsSet.contains('Dicing') && IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes'){
                    selServiceOptions.add('Dicing');
                }
                for(String s : selServiceOptions){
                    if(Start){
                        ServiceOpts = s;
                        Start = false;
                    }else{
                        ServiceOpts = ServiceOpts +';'+s;
                    }           
                }
            
            }else if(selServiceOptions.isEmpty()){
                if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes'){
                    selServiceOptions.add('Dicing');
                    for(String s : selServiceOptions){
                        if(Start){
                            ServiceOpts = s;
                            Start = false;
                        }else{
                            ServiceOpts = ServiceOpts +';'+s;
                        }           
                    }   
                }
            }
            IMCFormObj.ServiceOptions__c = ServiceOpts;
            try{              
                if(!conDocShare.isEmpty()){
                    Upsert conDocShare;
                }
                if(!conDocDelete.isEmpty()){
                    delete conDocDelete;
                }
                update IMCFormObj;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        } else{
            return null;
        }
        PageReference pgRef;
        if(exitForm){
            populateAdditionalContacts();
            pgRef = new PageReference('/apex/FMSIMCFormViewPage?id=' + IMCFormObj.id);
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
    
    public void updateCountOfAddContacts() {
        if (!rightvalues.isEmpty()) {
            addContactsCount = String.valueOf(rightvalues.size());
        } else {
            addContactsCount = 'No';
        }
    }

    public void updateFiledetails(){

        String uploadedFile = Apexpages.currentPage().getParameters().get('uploadFileId');
        String uploadedFileName = Apexpages.currentPage().getParameters().get('uploadFileName');       
        Integer filesize;
        ContentVersion contVersionRec;
        
        if(uploadedFile != null){
            if (IMCFormObj.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment') {
                IMCFormObj.FileAttachment__c = uploadedFile;
            } else {
                IMCFormObj.AdvancedProcessFileAttachment__c = uploadedFile;
            }

            contVersionRec = [SELECT Id, ContentSize, Title, ContentDocumentId FROM ContentVersion where Id = :uploadedFile];
            contVersionRec.Title = uploadedFileName;
            try {
                update contVersionRec;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'updateFiledetails()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            attachementWrapper attWrapInst = new attachementWrapper();
            attWrapInst.attName = uploadedFileName;
            attWrapInst.attId = contVersionRec.Id;
            attWrapInst.ContentDocumentId = contVersionRec.ContentDocumentId;
            filesize = Integer.valueOf(contVersionRec.ContentSize/1024);
            if(filesize>1024) {
                filesize = Integer.valueOf(filesize/1024);
                attWrapInst.attSize = filesize + ' MB';
            } else if(filesize == 0){
                attWrapInst.attSize = contVersionRec.ContentSize + ' Bytes';
            } else {
                attWrapInst.attSize = filesize + ' KB';
            }
            attWrap.add(attWrapInst);
            
            if(conDocShare == null)conDocShare = new List<ContentDocumentLink>();
            ContentDocumentLink ct = new ContentDocumentLink(
            LinkedEntityId = IMCFormObj.Id, 
            ContentDocumentId = contVersionRec.ContentDocumentId, 
            ShareType = 'V', 
            Visibility = 'AllUsers');
            conDocShare.add(ct);
        }
    }

    public class attachementWrapper {
        public string attName {get;set;}
        public id attId {get;set;}
        public String attSize {get;set;}
        public id ContentDocumentId{get;set;}
    }

    public PageReference freezeForm() {
        if (validationCheck(null)) {//Added by Abhita for Legacy form - 20092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Freeze Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c;
        IMCFormObj.State_of_the_Form__c = 'Frozen';
        IMCFormObj.Mandatory_State_Change_Comments__c = '';
        try {
            update IMCFormObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+IMCFormObj.Previous_State_Of_Form__c+' to '+IMCFormObj.State_of_the_Form__c));
            FMSFutureCallClass.updateStage(IMCFormObj.device__c);
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'freezeForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        return new PageReference('/apex/FMSIMCFormViewPage?id=' + IMCFormObj.id);
    }

    public PageReference submitForm() {
        if (validationCheck(null)) {//Added by Abhita for Legacy form - 20092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Submit Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c;
        IMCFormObj.State_of_the_Form__c = 'Submitted';
        IMCFormObj.Mandatory_State_Change_Comments__c = '';
        try {
            update IMCFormObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+IMCFormObj.Previous_State_Of_Form__c+' to '+IMCFormObj.State_of_the_Form__c));
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'submitForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        return new PageReference('/apex/FMSIMCFormViewPage?id=' + IMCFormObj.id);
    }

    public pageReference createAddendumForm() {
        
        PageReference pgRef;
        if (validationCheck('CreateAddendum')) {//Added by Abhita for Legacy form - 20092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Create addendum} as data integrity checks failed. Please edit the form and visit page to fix the issues.'));
        }
        else{        
            pgRef = new PageReference('/apex/FMSmainFormCreation');
            pgRef.getParameters().put('ParentId', IMCFormObj.id);
            pgRef.getParameters().put('tranx', 'Create');
            pgRef.getParameters().put('Type', 'IMC');
            pgRef.getParameters().put('parentName', IMCFormObj.Name);
            pgRef.setRedirect(true);
        }
        return pgRef;
    }

    public List < SelectOption > getSelectAddendumValues() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', '== Select Form Type =='));
        options.add(new SelectOption('IMC', FMS_IMC_FORM));
        options.add(new SelectOption('RIT', FMS_RIT_FORM));
        return options;
    }

    public PageReference makeFormInactive() {
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c;
        if (IMCFormObj.State_of_the_Form__c == 'Submitted') {
            IMCFormObj.State_of_the_Form__c = 'InactiveSubmitted';
        } else if (IMCFormObj.State_of_the_Form__c == 'Draft') {
            IMCFormObj.State_of_the_Form__c = 'InactiveDraft';
        } else if (IMCFormObj.State_of_the_Form__c == 'Thawed') {
            IMCFormObj.State_of_the_Form__c = 'InactiveThawed';
        }
        IMCFormObj.Mandatory_State_Change_Comments__c = ''; 
        try {
            update IMCFormObj;         
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'makeFormInactive()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSIMCFormViewPage');
        pg.getParameters().put('id', IMCFormObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', IMCFormObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', IMCFormObj.State_of_the_Form__c);
        pg.setRedirect(true);// Added by Abhita for UAT Issue #417
        return pg;
    }

    public PageReference makeFormActive() {
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c;
        if (IMCFormObj.State_of_the_Form__c == 'InactiveDraft') {
            IMCFormObj.State_of_the_Form__c = 'Draft';
        } else if (IMCFormObj.State_of_the_Form__c == 'InactiveSubmitted') {
            IMCFormObj.State_of_the_Form__c = 'Submitted';
        } else if (IMCFormObj.State_of_the_Form__c == 'InactiveThawed') {
            IMCFormObj.State_of_the_Form__c = 'Thawed';
        }
        IMCFormObj.Mandatory_State_Change_Comments__c = ''; 
        try {
            update IMCFormObj;
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'makeFormActive()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSIMCFormViewPage');
        pg.getParameters().put('id', IMCFormObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', IMCFormObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', IMCFormObj.State_of_the_Form__c);
        pg.setRedirect(true);// Added by Abhita for UAT Issue #420
        return pg;
    }

    public PageReference requestToThawForm() {
        popupVal = false;
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c;
        IMCFormObj.State_of_the_Form__c = 'RequestToThaw';
        try {
            update IMCFormObj;
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'requestToThawForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSIMCFormViewPage');
        pg.getParameters().put('id', IMCFormObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', IMCFormObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', IMCFormObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference thawForm() {
        popupVal = false;
        IMCFormObj.Previous_State_Of_Form__c = IMCFormObj.State_of_the_Form__c; 
        IMCFormObj.State_of_the_Form__c = 'Thawed';
        try {
            update IMCFormObj;
            
        }
        Catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'thawForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSIMCFormViewPage');
        pg.getParameters().put('id', IMCFormObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', IMCFormObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', IMCFormObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference editForm() {
        PageReference pgRef = new PageReference('/apex/FMSIMCFormPage');
        pgRef.getParameters().put('id', IMCFormObj.id);
        pgRef.getParameters().put('pageNo', '1');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference updateFormDetails() {
        PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
        pgRef.getParameters().put('id', IMCFormObj.id);
        pgRef.getParameters().put('tranx', 'Edit');
        pgRef.getParameters().put('Type', 'IMC');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference copyAsNewForm() {
        PageReference pgRef = new PageReference('/apex/FMSCopyForms');
        pgRef.getParameters().put('id', IMCFormObj.id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference Subscribe() {
    
        Id userId = userinfo.getUserId();
        FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
        
        List<FMS_Subscription__c>  subscpList = new List<FMS_Subscription__c>();         
        subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userId  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true) and Form_Id__c =:IMCFormObj.id and Saved_Search_Id__c=null ];            
        //Modified Query to fetch Subscription Record 1Sept2017
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
                // Added the sharing for MySubscription Object 1Sept2017
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
        
            fmsSubscribe.Form_Id__c = IMCFormObj.id;  
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
                    subscribeFlag = true;    //Ravindra - changed to display unsubscribed link on page. 
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
            
                PageReference pgRef = new PageReference('/apex/FMSIMCFormViewPage?id=' + IMCFormObj.id);
                pgRef.getParameters().put('tranx', 'Subscribe');
                pgRef.setRedirect(true);
                return pgRef;
             }
            
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The User is already subscribed to this form'));
                return null;
        
            }               
    
         
    }

    public PageReference UnSubscribe() {
        if (fmsSubscription != null) {
            fmsSubscription.Form_Inserted__c = false;
            fmsSubscription.Form_Status_Change__c = false;
            fmsSubscription.Form_Updated__c = false;
            fmsSubscription.Form_Deleted__c = false;
            fmsSubscription.UnSubscribed_Date__c = system.today();
            try{
                update fmsSubscription;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSIMCFormExt.class.getName(), 'UnSubscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            subscribeFlag = false;
        }
        PageReference pgRef = new PageReference('/apex/FMSIMCFormViewPage?id=' + IMCFormObj.id);
        pgRef.getParameters().put('tranx', 'UnSubscribe');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference SubscribeUser() {
        String PageURL = ApexPages.currentPage().getUrl();
        PageReference pgRef = new PageReference('/apex/FMSSubscribeOtherUserPage');
        pgRef.getParameters().put('id', IMCFormObj.id);
        pgRef.getParameters().put('baseURL', PageURL);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference deleteForm() {
        Id parentformid = IMCFormObj.Parent_Form_Id__c;
        String parRecordType = IMCFormObj.Parent_Form_Id__r.recordtype.Name;
        try {
            delete IMCFormObj;
        } catch(DMLException de) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getMessage()));
            return null;
        }
        
        PageReference pg1;
        String PageURL = ApexPages.currentPage().getUrl();
        if(PageURL.containsIgnoreCase('GlobalfoundryView')){
            if(parRecordType == 'Main Product Definition Form'){
                pg1 = new PageReference('/GlobalfoundryView/apex/FMSmainFormViewPage?id='+parentformid);
            } else{
                pg1 = new PageReference('/GlobalfoundryView/apex/FMSIMCFormViewPage?id='+parentformid);
            } 
        }
        else{
            if(parRecordType == 'Main Product Definition Form'){
                pg1 = new PageReference('/apex/FMSmainFormViewPage?id='+parentformid);
            } else{
                pg1 = new PageReference('/apex/FMSIMCFormViewPage?id='+parentformid);
            } 
        }
        pg1.getParameters().put('tranx', 'delete');
        pg1.getParameters().put('delFormNum', IMCFormObj.Name);
        pg1.setRedirect(true);
        return pg1;
    }

    public PageReference continueCheck() {
        if (stateChangeComments == null || stateChangeComments == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please provide a brief description explaining the reason for this action - is a Required field'));
            return null;
        }
        IMCFormObj.Mandatory_State_Change_Comments__c = stateChangeComments;
        if (requestMsg == 'RequestToThaw') {
            return requestToThawForm();
        } else if (requestMsg == 'Thawed') {
            return thawForm();
        }
        return null;
    }

    public void showPopup() {
        requestMsg = Apexpages.currentPage().getParameters().get('stateVal');
        popupVal = true;
    }

    public void closePopup() {
        popupVal = false;
    }

    public PageReference cancelForm() {
        PageReference pgRef = new PageReference('/apex/FMSIMCFormViewPage');
        pgRef.getParameters().put('id', IMCFormObj.id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /*public PageReference inputAttachments() {
        List < String > attachmentIds = new List < String > ();
        attWrap.clear();
        if (IMCFormObj.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment' && IMCFormObj.FileAttachment__c != null && IMCFormObj.FileAttachment__c != '') {
            attachmentIds = IMCFormObj.FileAttachment__c.split(';');
        }
        if (IMCFormObj.IMCInputMethod__c == 'Advanced Process: Inputs via XML file attachment' && IMCFormObj.AdvancedProcessFileAttachment__c != null && IMCFormObj.AdvancedProcessFileAttachment__c != '') {
            attachmentIds = IMCFormObj.AdvancedProcessFileAttachment__c.split(';');
        }
        Integer filesize;
        for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentIds]) {

            attachementWrapper attWrapInst = new attachementWrapper();
            attWrapInst.attName = attDetails.Title;
            attWrapInst.attId = attDetails.Id;
            attWrapInst.ContentDocumentId = attDetails.ContentDocumentId;
            filesize = Integer.valueOf(attDetails.ContentSize/1024);
            if(filesize>1024) {
                filesize = Integer.valueOf(filesize/1024);
                attWrapInst.attSize = filesize + ' MB';
            } else if(filesize == 0){
                attWrapInst.attSize = attDetails.ContentSize + ' Bytes';
            } else {
                attWrapInst.attSize = filesize + ' KB';
            }
            attWrap.add(attWrapInst);
        }
        return null;
    }*/

    public class addContactWrapper {
        public String addContName {
            get;
            set;
        }
        public String addContEmail {
            get;
            set;
        }
        public String addContPhone {
            get;
            set;
        }

        public addContactWrapper(String n, String e, String p) {
            if (n == 'NA') {
                n = '';
            }
            this.addContName = n;
            if (e == 'NA') {
                e = '';
            }
            this.addContEmail = e;
            if (p == 'NA') {
                p = '';
            }
            this.addContPhone = p;     
        }
    }
    

    public void invInput(){
        String inputValue = Apexpages.currentPage().getParameters().get('inpVal');
        String mapFieldValue = Apexpages.currentPage().getParameters().get('fieldName');
        invalidInputCheckMap.put(inputValue.right(3), inputValue.removeEnd(inputValue.right(3)));
        invalidInpToFieldsMap.put(inputValue.right(3), mapFieldValue);
        isInvalidInp = false;
        for(String str : invalidInputCheckMap.keySet()){
            if(invalidInputCheckMap.get(str) == 'true'){
                isInvalidInp = true;
            }
        }
    }
    
    public PageReference openPDF(){
        PageReference pgRef = new PageReference( '/apex/FMSIMCFormViewPrintPDF?id='+IMCFormObj.id);        
        pgRef.setRedirect(true); 
        return pgRef;
    }
    
    public class AddContWrapper{
        public String name{get;set;}
        public String email{get;set;}
        public String phone{get;set;}
        public String id{get;set;}
        public AddContWrapper(String name, String email, String phone, String Id) {
            this.name = name;
            this.email = email;
            this.phone = phone;
            this.id = Id;
        }
    }  
    public void DeleteAttachment() {
        if(String.isNotBlank(selContentDocId)){
            ContentDocument contdoc = new ContentDocument(id = selContentDocId);
            conDocDelete.add(contdoc);
            if (IMCFormObj.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment') {
                IMCFormObj.FileAttachment__c = null;
            } else if(IMCFormObj.IMCInputMethod__c == 'Advanced Process: Inputs via XML file attachment.') { 
                IMCFormObj.AdvancedProcessFileAttachment__c = null;
            }
            attWrap.clear();        
        }  
    }
    
    public List < SelectOption > getDesignSubmission() {
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.DesignSubmission__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        options.add(new SelectOption('', FMS_SELECT_VAL));
          
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Multi-Chiplet Design (one GDS, single Topcell)'){
                if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }else{
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }     
            
        return options;   
    }
    
    public List<SelectOption> getDeliverablesList(){
        List<SelectOption> options = new List<SelectOption>();        
        Set<String> selOpt = new Set<String>();
        selOpt.addAll(selServiceOptions);
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && !selOpt.contains('Dicing')){
            selServiceOptions.add('Dicing');
            selOpt.add('Dicing');
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && !selOpt.contains('Dicing')){
            options.add(new SelectOption('Untested Wafer', 'Untested Wafer'));     
            IMCFormObj.Deliverable__c = 'Untested Wafer';
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && selOpt.contains('Dicing')){
            options.add(new SelectOption('Untested Chip', 'Untested Chip'));     
            IMCFormObj.Deliverable__c = 'Untested Chip';
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes'){
            options.add(new SelectOption('Untested Module', 'Untested Module'));   
            IMCFormObj.Deliverable__c = 'Untested Module';
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && !selOpt.contains('Dicing')){
            options.add(new SelectOption('Tested Wafer', 'Tested Wafer'));     
            IMCFormObj.Deliverable__c = 'Tested Wafer';
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No' && selOpt.contains('Dicing')){
            options.add(new SelectOption('Tested Chip', 'Tested Chip'));     
            IMCFormObj.Deliverable__c = 'Tested Chip';
        }
        if(IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'Yes' && selOpt.contains('Dicing')){
            options.add(new SelectOption('Tested Module', 'Tested Module')); 
            IMCFormObj.Deliverable__c = 'Tested Module';
        }
        return options;
    }
    
    public List<SelectOption> getServiceOptionsList(){
        List<SelectOption> options = new List<SelectOption>();           
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.ServiceOptions__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Dicing' || f.getValue() == 'Other'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else if(f.getValue() == 'Backside Grind'){
                if(IMCFormObj.Main_Form_Id__r.Chip_Interconnect__c == 'Wirebond' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c == 'No'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }else if(f.getValue() == 'Wafer Thermal Cycle' && checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO2) && (IMCFormObj.ServiceOptions__c != null && IMCFormObj.ServiceOptions__c.contains('Wafer Thermal Cycle'))){  
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else if(f.getValue() == 'None'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }       
        return options;        
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
    public List<SelectOption> getBacksideGrindThickness(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', FMS_SELECT_VAL));      
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.BacksideGrindThickness__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for( Schema.PicklistEntry f : ple){
            if( f.getValue() != '180 um' || (f.getValue() == '180 um' && checkFormCompany(IMCFormObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO11)&& IMCFormObj.BacksideGrindThickness__c == '180 um') ){
                options.add(new SelectOption(f.getLabel(), f.getValue()));    
            }
        }       
        return options; 
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
    
    public List<SelectOption> getIMCInputList(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Standard Process: Inputs via Reticle Layout attachment', 'Standard Process: Inputs via Reticle Layout attachment'));
        options.add(new SelectOption('Advanced Process: Inputs via XML file attachment', 'Advanced Process: Inputs via XML file attachment. Pre-Approval Required'));
            
        return options;
    }
    
   //===============================(Start)Prod Issue# 164===================================
    public void renderDesignChangesSection(){
        resetDependentFields();  
        if(parentServiceOpts.DesignSubmission__c != 'Multi-Design Reticle (>1 Topcell)' && IMCFormObj.OverrideParentOptions__c == 'Yes'
            && IMCFormObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)') {
                disDesignChangesSection = true;
        } else if(parentServiceOpts.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' && IMCFormObj.OverrideParentOptions__c == 'No') {
                disDesignChangesSection = true;
        } else if(parentServiceOpts.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' && IMCFormObj.OverrideParentOptions__c == 'Yes'
            && IMCFormObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)'){
            disDesignChangesSection = true;
        } else {
            disDesignChangesSection = false;
        }
        if(disDesignChangesSection) {
            if(IMCFormObj.IMCInputMethod__c == null || IMCFormObj.IMCInputMethod__c == '') {
                if(IMCFormObj.Parent_Form_Id__c != null && parentServiceOpts.IMCInputMethod__c != null){
                    if(parentServiceOpts.IMCInputMethod__c == 'Standard Process: Inputs via Reticle Layout attachment') {
                        IMCFormObj.IMCInputMethod__c = 'Standard Process: Inputs via Reticle Layout attachment';
                    } else if(parentServiceOpts.IMCInputMethod__c == 'Advanced Process: Inputs via XML file attachment') {           
                        IMCFormObj.IMCInputMethod__c = 'Advanced Process: Inputs via XML file attachment';
                    }
                } else if(parentServiceOpts != null && parentServiceOpts.IMCInputMethod__c == null && IMCFormObj.Main_Form_Id__r.InputMethod__c != null) {
                    if(IMCFormObj.Main_Form_Id__r.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment' 
                        || IMCFormObj.Main_Form_Id__r.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions') {
                        IMCFormObj.IMCInputMethod__c = 'Standard Process: Inputs via Reticle Layout attachment';
                    } else if(IMCFormObj.Main_Form_Id__r.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.') {           
                        IMCFormObj.IMCInputMethod__c = 'Advanced Process: Inputs via XML file attachment';
                    } 
                } else {
                    IMCFormObj.IMCInputMethod__c = 'Standard Process: Inputs via Reticle Layout attachment';
                }
            }
        }
        renderNumOfUniqDesigns();
    } 
    
    public void renderNumOfUniqDesigns() {
        if(IMCFormObj.OverrideParentOptions__c == 'No'){
            if(parentServiceOpts.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)'){
                disNumOfUniqDesigns = true;
            }
        } else if(IMCFormObj.OverrideParentOptions__c =='Yes'){
            if(IMCFormObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)'){
                disNumOfUniqDesigns = true;
            }
        } else {
            disNumOfUniqDesigns = false;
        }
    }
  //===============================(End)Prod Issue# 164===================================  
    public String fieldAPI{get;set;}
    public void resetDependentFields(){
        FMS_HierarchyLogic.getDependentFieldsToReset(fieldAPI,IMCFormObj,'IMC');
        fieldAPI = '';
    }

    public void renderotherServiceFeatures(){
        if(selServiceOptions != null && !selServiceOptions.isEmpty()){
            Set<String> sOpt1 = new Set<String>();
            sOpt1.addAll(selServiceOptions);
            if(sOpt1.contains('Other') && IMCFormObj.Main_Form_Id__r.QuoteOnly__c != 'Yes' && IMCFormObj.Main_Form_Id__r.Technology__c != '--None--'){
                dispOtherServiceFeatures = true;
            }else{
                dispOtherServiceFeatures = false;
            }
        }else{
            dispOtherServiceFeatures = false;
        }
        renderBacksideGrindThickness();
        renderChipEdgeDesign();
    }

    public void renderChipEdgeDesign(){
        Set<String> selOpt = new Set<String>();
        selOpt.addAll(selServiceOptions);
        if((IMCFormObj.Main_Form_Id__r.ServiceOptions__c==null 
            || !(IMCFormObj.Main_Form_Id__r.ServiceOptions__c.contains('Dicing')))
            && selOpt.contains('Dicing') && (IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'SOI7SWT' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 9LP (CMOS 9RF)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7RF' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI 7SW' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7RF (CMRF7SF)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMOS 7TG (CMRF7TG)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 9HP (SiGe 9HP)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8XP (SiGe 8XP)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)' 
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CMS90WG (CMOS9WG)'
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 8WL (SiGe 8WL)'
            || IMCFormObj.Main_Form_Id__r.Technology__c == '45RFSOI'
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'CSOI8SW'
            || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS5PA4 (HRS5PA4)')){
            dispChipEdgeDesign = true;
        }else{
            dispChipEdgeDesign = false;
        }
    }

    public void renderBacksideGrindThickness(){
        Set<String> servOptsSet = new Set<String>();
        servOptsSet.addAll(selServiceOptions);
        if(IMCFormObj.Main_Form_Id__r.QuoteOnly__c != 'Yes' && servOptsSet.contains('Backside Grind')){
            dispBacksideGrindThickness = true;
        }else{
            dispBacksideGrindThickness = false;
        }
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
        //Added the Defect Fix for History Issue
        return UtilityCls.changeHistory(IMCFormObj);
    }  
}