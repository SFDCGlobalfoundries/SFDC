/* 
 @class: FMSmainFormEditController
 @CreatedBy: Inshu Misra
 @CreatedDate: 20 Feb, 2017
 @Description: Controller for FMS main Form...#IM
 @Modifications-
     DATE               NAME                  COMMENTS
     21-Feb-2017        Abhita Bansal         Added the code for customer specific technology for #DEF 294, 349
     22-Feb-2017        Abhita Bansal         Changed the method for #DEF 161,367
     27-Feb-2017        Abhita Bansal         Changed the methods for #DEF 497,499,500,501
     27-Feb-2017        Abhita Bansal         Changed the method for #DEF 496
     27-Feb-2017        Abhita Bansal         Changed the method for #DEF 52
     01-Mar-2017        Abhita Bansal         Added new variables in TFA logic for #DEF 370
     01-Mar-2017        Abhita Bansal         Changed the Contact issue code for #DEF 429
     20-Mar-2017        Abhita Bansal         Added parameter in delete method for #DEF 90
     19-Apr-2017        Anirban Roy           Modified on line 1144-1153 for the fix..
     27-Apr-2017        Inshu Misra           Resolved Public URL Issue...#IM
     17-May-2017        Abhita Bansal         Fixed the code for UAT Issue #145, 146, 126, 127, 128
     18-May-2017        Abhita Bansal         Added the code for Catch-Up Release T39 Point 1, 2, 3, 4, 5
     20-May-2017        Abhita Bansal         Added the code for UAT #156
     23-May-2017        Abhita Bansal         Added By Abhita for new UAT Issue #176 and T37 point 2
     24-May-2017        Abhita Bansal         Changed the code for new UAT Issue #157, 158 and T37 point 1 
     24-May-2017        Abhita Bansal         Changed the code for new UAT Issue #181
     24-May-2017        Abhita Bansal         Changed for new UAT Issue #177,178,179
     29-May-2017        Abhita Bansal         Changed the code for New UAT Issue 115 and T33 Catch-up Release 
     29-May-2017        Abhita Bansal         Changed by Abhita for new UAT Issue #186, 189, 190, 191 and T33 Catch-up Release
     31-May-2017        Abhita Bansal         Changed the condition for new UAT Issue #192
     31-May-2017        Abhita Bansal         Changed the values for T33 Catch-up Release Slide #10, 11.
     05-Jun-2017        Abhita Bansal         Removed space from "4.5on10" for new UAT Issue #235, 238
     08-Jun-2017        Abhita Bansal         Changed By Abhita for new UAT Issue #178, 179
     14-Jun-2017        Abhita Bansal         Added by Abhita for new UAT Issue #334, 335
   21-Jun-2017        Inshu Misra          Added code for Public URL issue..#IM
   28-Jun-2017    Abhita Bansal      Remove the System debugs and hard cording
   13-Jul-2017        Inshu Misra          Bug 427..#IM
   11-Jul-2017        Abhita Bansal         Modified the code for UAT Issue #428
   14-Jul-2017        Inshu Misra           Added the Defect Fix for History Issue
   20-Jul-2017        Ram Rai              Modified against Search and subscription logic
   01-Aug-2017        Abhita Bansal         Modified the code to associate the correct device on creation 
   21-Aug-2017    Abhita Bansal      Modified the code for Prod Issue #51
   25-Aug-2017    Ravindra         Changed the Document Links to Libraries
     01-Sept-2017       Ram Rai               Modified the code to fix Subscription Issue
   05-Seot-2017    Abhita bansal      Added code by Abhita for Legacy form 
**/
public class FMSmainFormEditController{
    public String pageN {get;set;} 
    public String fieldAPI{get;set;}  
    public User loggedInUser{get;set;}
    public String fId{get;set;}
    public Integer pageNum{get;set;}
    public Integer totPageNum{get;set;}
    public Form_Management_System__c formObj{get;set;}
    public boolean exitForm{get;set;}
    public boolean skipvalidation{get;set;}
    public boolean isTFACompany{get;set;}
    // public Map<String, FMSDocumentsLinks__c> FMSdocuments {get;set;}  Commented by Ravindra - Changed the Document Links to Libraries
    public Map<String, String> FMSdocuments {get;set;}   //Added by Ravindra - Changed the Document Links to Libraries
    public String workspaceId; //Added by Ravindra - Changed the Document Links to Libraries
    public List<Apttus_Proposal__Proposal__c> prop{get;set;}

    public List<contact> contactInfo{get;set;}    
    public List<User> loggedInAccContList{get;set;}    
    public Map<String, String> originalvalues{get;set;}
    public Map<String, String> originalvalues1{get;set;}
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public Map<String,String> leftvalues = new Map<String, String>();
    public Map<String, String> rightvalues = new Map<String, String>();
    public String addContName = '';
    public String addContEmail = '';
    public String addContId = '';
    public String addContPhone = '';
    public Map<String, AddContWrapper> selectedContactList{get;set;}
    public List<FMS_Technology__mdt> fmsTechnoMDT{get;set;}
    public Map<String, FMS_Technology__mdt> storedNamefmsTechnoMDTMap = new Map<String, FMS_Technology__mdt>();
    public Set<String> techGeoSet{get;set;}
    public boolean dispTestLevel{get;set;}
    public boolean dispIntConBumpServ{get;set;}    
    public String addContactsCount{get;set;}
    public boolean dispChipEdgeWLCP{get;set;}
    public boolean dispWeapon{get;set;}    
    public String sapAccNum; 
    public String prevLogUser; 
    public String fmsTechbyoldvalue{get;set;}   
    public List<Id> accHList; //Modified the code to associate the correct device on creation

    public List<FMS_Mapping_Table__c> fmsMappingTable{get;set;}
    public List<String> selServiceOptions{get;set;}
    public boolean dispBacksideGrindThickness{get;set;}
    public boolean dispLastMetalUsed{get;set;}
    public boolean dispsourcingLocation{get;set;}
    public boolean dispNumMetalLayers{get;set;}
    public boolean dispPassivation{get;set;}
    public boolean dispPassivation1{get;set;}
    public boolean dispTechFeatures{get;set;}
    public boolean dispNotMfgFeaturesDesc{get;set;}
    public boolean dispOtherServiceFeatures{get;set;}
    public boolean dispStepPlanCustReq{get;set;}
    public boolean dispDeliverableSplit{get;set;}    
    public boolean dispNumThickLevels{get;set;}
    public boolean dispNonStandardCll{get;set;}
    public boolean dispFinalPassivation{get;set;}
    public boolean dispLineFront{get;set;}
    public boolean dispShippingLabelCLL{get;set;}
    public boolean dispChipEdgeDesign{get;set;}
    public boolean dispCll{get;set;}
    public boolean dispWaiverLink{get;set;}
    public boolean dispDataCheckingOpts{get;set;}
    public boolean preMergeReadOnly{get;set;}  
    public boolean displayDicing{get;set;}
    public boolean checkNone{get;set;}

    public boolean dispWireBondSplit{get;set;}
    public boolean dispWireBondSplitTAT{get;set;}
    public boolean dispC4SplitTAT{get;set;}
    public boolean dispOtherSplitDepts{get;set;}
    public boolean dispClientResponseDt{get;set;}
    public boolean dispNeedBizComment{get;set;}
    public boolean dispITARCategory{get;set;}
    public boolean readOnlyCheck{get;set;}
    
    public String wireBondsplit{get;set;}
    public String busComments{get;set;}
    public String wireBondsplitTAT{get;set;}
    public String wirebondwafer{get;set;}
    public String c4Split{get;set;}
    public String c4SplitTAT{get;set;}
    public String c4wafer{get;set;}
    public String othersplits{get;set;}
    public String othersplitsdet{get;set;}
    public String itaCat{get;set;}
    public String clrespdt{get;set;}
    public String bizComment{get;set;}//Modified the code for UAT Issue #428
    public String businessComment{get;set;}//Modified the code for UAT Issue #428

    public boolean dispNumOfDesigns{get;set;}
    public boolean dispMaxChipPower{get;set;}
    public boolean dispC4PadLayout{get;set;}
    public boolean dispC4PadLayoutForDRC{get;set;}
    public boolean dispNumC4Pads{get;set;}
    public boolean dispC4SolderMaterial{get;set;}
    public boolean dispPinOneID{get;set;}
    public boolean dispDesignKitOthers{get;set;}
    public boolean dispNeedAdditionalComments{get;set;}
    public boolean dispadditionalComments{get;set;}
    public boolean dispC4LaminatePackage{get;set;}
    public boolean dispChamferedCorner{get;set;}
    public boolean dispOtherC4PadLayout{get;set;}
    public boolean dispWirebondLayout{get;set;}
    public boolean dispWirebondPad{get;set;}
    public boolean dispWireBondPadPitch{get;set;}
    public boolean dispPickMap{get;set;}
    public boolean config{get;set;}
    public boolean dispCircuitType{get;set;} 
    public boolean isInvalidInp{get;set;} 
    public Map<String,String> invalidInputCheckMap = new Map<String,String>(); 
    public Map<String,String> invalidInpToFieldsMap = new Map<String, String>(); 
    public List<Apttus_Proposal__Proposal__c> lstproposal;
    public List<ContentDocumentLink> conDocShare = new List<ContentDocumentLink>();
    public List<ContentDocument> conDocDelete = new List<ContentDocument>(); // Added By Abhita for Prod issue #203

    public Set<String> servOptsSetPg3;
    public Boolean dispStdReticle {get; set;}
    public Boolean contDicing {get; set;}
    public boolean dispInputMethod{get;set;} 
    public boolean dispStepPlanSection{get;set;} 
    public List < attachementWrapper > attWrap { get; set; }
    public List<string> spleftselected{get;set;}
    public List<string> sprightselected{get;set;}
    public Map<String, String> spleftvalues = new Map<String, String>();
    public Map<String, String> sprightvalues = new Map<String, String>();
    public Map<String, String> sporiginalvalues{get;set;}
    public Map<String, AddStepPlanContWrapper> addContTableList{get;set;}
    public Map<String, String> sporiginalvalues1{get;set;}
    public Boolean dispCrackOptions{get;set;}
    public boolean dispChannelType{get;set;}
    public boolean dispDicingPref{get;set;}
    public string selContentDocId { get; set; }
    public String uploadFileId { get; set;}
    public boolean dispDicingMarks {get;set;}
    public String spaddContId = '';
    public String spaddContName = '';
    public String spaddContEmail = '';
    public List < attachementECCNWrapper > attWrapECCN { get; set; }
    public String uploadECCNFileId { get; set;}
    public string selContentDocEId { get; set; }
    public boolean stepEdgeReadOnly{get;set;} 
    public Integer portalUserList; 
    public String selChipValue{get;set;}
    public Boolean displayNotAvailableMsg {get;set;}
    public String readVerticalX {get;set;}
    public String readHorizontalY {get;set;}
    public Map<String, String> stepPlanIntegartionFields;
    public String webRDTSActive; 
    
    public boolean renderLabel{get;set;}

    public Boolean isPortalUser {get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public String userType = Schema.SObjectType.User.getKeyPrefix();
    public boolean isFMSAdmin {get;set;}
    public String addContactsCountView {get;set;}
    public List < addContactWrapper > selectedAddContList {get;set;}
    public String requestMsg {get;set;}
    public String stateChangeComments {get;set;}
    public boolean popupVal {get;set;}
    public boolean popupCreateAdd {get;set;}
    public boolean hasChildren {get;set;}
    public List < FMS_Subscription__c > fmsSubscriptionList;
    public FMS_Subscription__c fmsSubscription;
    public boolean subscribeFlag {get;set;}
    public boolean dispchipEdgeWLCSP {get;set;}
    public List < String > selServiceOptionsView {get;set;}
    public Integer Page2TFA{get;set;}
    public Integer Page2{get;set;}
    public Integer Page3{get;set;}
    public Integer Page4{get;set;}
    public Integer Page5{get;set;}
    public List<addContactWrapper> addStepPlanList{get;set;}
    public String tranx;
    public String deleteId;

    public Boolean isTechVisible{get;set;}

    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 
    
    public final String FMS_Admin_Group = EnvironmentVariable.get('FMS_Admin_Group');
    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM');
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM');
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE'); 
    
    public Set<Id> accountIds;
    public List<User> userList;
    public List<User> dmeaUserList;
    public final String FMS_DEV_LITE_SOLD_TO = EnvironmentVariable.get('FMS_DEV_LITE_SOLD_TO');
    
    //fms_07
    string currentPageName;
    public FMSmainFormEditController(ApexPages.StandardController controller){
      String pageName = ApexPages.currentPage().getUrl();
        if(pageName.contains('?')) {
          currentPageName = pageName.substringBetween('apex/', '?'); 
        } else {
          currentPageName = pageName.substringAfter('apex/');
        }  
      isTFACompany = false;
      exitForm = true;
      skipvalidation = false;
      isTechVisible = false;
  
      accHList = new List<Id>();//Modified the code to associate the correct device on creation
      leftselected = new List<String>();
      rightselected = new List<String>();
      loggedInAccContList = new List<User>();
      originalvalues = new Map<String, String>();        
      originalvalues1 = new Map<String, String>();
      contactInfo = new List<Contact>();
      selectedContactList = new Map<String, AddContWrapper>();
      techGeoSet = new Set<String>();
      fmsTechnoMDT = new List<FMS_Technology__mdt>();
      dispTestLevel = false;
      dispIntConBumpServ = false;
      
      conDocDelete = new List<ContentDocument>(); // Added by Abhita for Prod issue #203
      portalUserList = 0;
      sporiginalvalues1 = new Map<String, String>();
      sporiginalvalues = new Map<String, String>();
      stepPlanIntegartionFields = new Map<String, String>(); 
  
      accountIds = new Set<Id>(); 
      userList = new List<User>();
      dmeaUserList = new List<User>();
      
      loggedInUser = [SELECT id, Name, ContactId, AccountId, Country, State, Email, Phone FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
      formObj = (Form_Management_System__c) controller.getRecord();       
    fId = ApexPages.currentPage().getParameters().get('id');
        
    FMSdocuments = UtilityCls.getContentList(); 
      
        if(fId != null && fId != ''){            
            String fmsFields = '';
            fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
            fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c,'; 
            fmsFields += ' Customer_Name__r.Id,Customer_Name__r.Name,Device__r.Name,Device__r.id, Opportunity__r.id,';
            fmsFields += ' Opportunity__r.Name, Parent_Form_Id__r.recordtype.Name, Customer_Name__r.SAP_Account_Id__c';       
            string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+ fId +'\'';
            formObj = database.query(soql); 
        }
                
        fmsTechbyoldvalue = formObj.Technology__c;        
  
        if(ApexPages.currentPage().getParameters().get('pageN') != NULL && ApexPages.currentPage().getParameters().get('pageN') != ''){
          pageNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageN'));
        }
        if(pageNum == null || pageNum == 0){
            pageNum = 1;
        }
        if(formObj.Customer_Name__c != null && formObj.Customer_Name__r.SAP_Account_Number__c != null){  
            if(checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO1) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, SAP_ACC_NO) || 
            (formObj.Customer_Name__r.Customer_Category__c != null && (formObj.Customer_Name__r.Customer_Category__c.equalsIgnoreCase('TFA')))){  // || formObj.Customer_Name__r.Customer_Category__c.equalsIgnoreCase('CC') - Remove the TFA Questions for CC Accounts
                isTFACompany = true;
            }else{
                isTFACompany = false;
            } 
        }
         
        if(formobj.Technology__c !=null && formobj.Technology__c !=''
            && formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9' && formobj.Technology__c != 'CNV8SFi'){
            isTechVisible = true;
        }
        // checking whether the logged in User is Standard or not
        if (UserInfo.getUserType()!='Standard'){
            isPortalUser = true;            
        } else {
            isPortalUser = false;
        }
        for(Account_Hierarchy__c accH : [SELECT Account_Id__c,Id,Master_Account_Id__c,Name,Parent_Id__c FROM Account_Hierarchy__c Where Account_Id__c =: formObj.Customer_Name__c]) {
            accHList.add(accH.Parent_Id__c);
        }
            
        List<Device__c> devLst = [select account__c, Design_Partner__c, account__r.SAP_Account_Number__c from Device__c where id = :formObj.Device__c Limit 1];

        if(devLst<>NULL && devLst.size()>0){
            if(devLst[0].account__r.SAP_Account_Number__c == SAP_ACC_NO && devLst[0].Design_Partner__c != null){
                accountIds.add(devLst[0].account__c);
                accountIds.add(devLst[0].Design_Partner__c);
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
            portalUserList = userList.size();
            if(userList<>NULL && !userList.isEmpty()) {
                for(User u: userList) {
                    if(u.Contact.AccountId == devLst[0].account__c) {
                        dmeaUserList.add(u);
                    }
                    sporiginalvalues1.put(u.Name, u.Id);
                    sporiginalvalues.put(u.Id, u.Name); 
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
            if(isPortalUser) {
                originalvalues.put(loggedInUser.Id, loggedInUser.Name); 
                sporiginalvalues.put(loggedInUser.Id, loggedInUser.Name); 
            } else {
                originalvalues.put(loggedInUser.Id, loggedInUser.Name);
            }            
            if(accHList<>NULL && !accHList.isEmpty()){
                loggedInAccContList = new List<User>([Select Id, Name, Contact.Email, Contact.AccountId from User where Contact.AccountId IN :accHList and isActive = true order by name]);
            } else {
                loggedInAccContList = new List<User>([Select Id, Name, Contact.Email, Contact.AccountId from User where Contact.AccountId =:formObj.Customer_Name__c and isActive = true order by name]);
            }
            portalUserList = loggedInAccContList.size();
            if(loggedInAccContList<>NULL && !loggedInAccContList.isEmpty()){
                for(User u : loggedInAccContList){
                    if(u.Name != UserInfo.getName() && u.Contact.Email != UserInfo.getUserEmail()){
                        originalvalues1.put(u.Name, u.Id);
                        originalvalues.put(u.Id, u.Name); 

                        sporiginalvalues1.put(u.Name, u.Id);
                        sporiginalvalues.put(u.Id, u.Name);
                    }
                }
            }   
        } 
        Account acc = [SELECT id, Name, Tech_Geo_Granted__c, SAP_Account_Number__c FROM Account WHERE id = :formObj.Customer_Name__c LIMIT 1];
        if(acc.Tech_Geo_Granted__c != null){
            for(String s : acc.Tech_Geo_Granted__c.split(';')){ 
                techGeoSet.add(s);
            }
        }
        
        if(acc.SAP_Account_Number__c <> NULL && !String.isEmpty(acc.SAP_Account_Number__c)){
            sapAccNum = acc.SAP_Account_Number__c.split('-')[0].right(6);
        }
        Set<Id> userIds = new Set<Id>();
        map<Id, String> userIdNameMap = new map<Id, String>();
        if(formObj.Selected_Contact_Ids__c != null && formObj.Selected_Contact_Ids__c != ''){   
            for(String s : formObj.Selected_Contact_Ids__c.split(';')){
                userIds.add(s);
            }        
            List<User> u = [Select Id,Name from User where Id IN :userIds];
            for(User usr : u) {
                userIdNameMap.put(usr.Id, usr.Name);
            }
            for(String s : userIds){
                if(originalValues.get(s) != null){
                    rightvalues.put(s, originalValues.get(s));
                } else {
                    prevLogUser = s;
                    if(userIdNameMap.keyset() !=null && userIdNameMap.keyset().size()>0){
                        rightvalues.put(s, userIdNameMap.get(s));
                    }
                }
            }
            for(String s : originalValues.keySet()){
                if(s!= null && !rightvalues.containsKey(s)){
                    leftvalues.put(s, originalValues.get(s));
                }
            }            
        }else if(formObj.Name__c != null && formObj.Name__c != ''){
            for(String s : formObj.Name__c.split(';')){
                if(s!= null && !rightvalues.containsKey(s)){
                    rightvalues.put(originalValues1.get(s), s);
                }
            }
            for(String s : originalValues.keySet()){
                if(s != null && !rightvalues.containsKey(s)){
                    leftvalues.put(s, originalValues.get(s));
                }
            }
        }else{
            leftvalues = new Map<String, String>(originalValues);
        }
        if(!rightvalues.values().isEmpty()){
            addContactsCount = String.valueOf(rightvalues.values().size());
        }else{
            addContactsCount = 'No';
        }          
            
        fmsTechnoMDT = [SELECT id, MasterLabel, DeveloperName, FMS_Release_Flow__c, SAP_Account_Number__c, FMS_Tech_Node__c,Order__c FROM FMS_Technology__mdt WHERE FMS_Tech_Node__c IN:techGeoSet OR FMS_Tech_Node__c = null order by Order__c];
        for(FMS_Technology__mdt fmsTech : fmsTechnoMDT){
            storedNamefmsTechnoMDTMap.put(fmsTech.MasterLabel, fmsTech);
        }   
            
        preMergeReadOnly = false;
        displayDicing = false;
        checkNone = false;
        selServiceOptions = new List<String>();
        if(currentPageName == 'FMSmainFormViewPage') {
              fmsMappingTable = [SELECT id, name,Is_Inactive__c, Added_Masks__c, DB_Value__c, Feature_Part_Numbers__c, Field__c, Technology__c, UI_Value__c,Order_Number__c,Chip_Interconnect__c
                                FROM FMS_Mapping_Table__c order by Is_Inactive__c asc,Order_Number__c asc];
            }
            else {
              fmsMappingTable = [SELECT id,Is_Inactive__c, name, Added_Masks__c, DB_Value__c, Feature_Part_Numbers__c, Field__c, Technology__c, UI_Value__c,Order_Number__c,Chip_Interconnect__c
                                FROM FMS_Mapping_Table__c /*where Is_Inactive__c = false*/ order by Order_Number__c asc];
            }     
        
        lstproposal = new List<Apttus_Proposal__Proposal__c>(); 
        attWrap = new List < attachementWrapper > (); 
        spleftselected = new List<String>();
        sprightselected = new List<String>();
        addContTableList = new Map<String, AddStepPlanContWrapper>();   
        //loggedInAccContList = new List<User>();      
        attWrapECCN = new List < attachementECCNWrapper > (); 
        dispInputMethod = false;
        dispStepPlanSection = false;
        dispCrackOptions = false;
        dispChannelType = false;
        dispDicingPref = false;
        dispDicingMarks = false;
        config = false;
        dispC4SolderMaterial = false;
        dispadditionalComments = false;
        isInvalidInp = false; 
        dispStdReticle = false;
        stepEdgeReadOnly = false;
        displayNotAvailableMsg = false;                

        webRDTSActive = Environment_Variable__c.getInstance('WebRDTS_IsActive').value__c;
         
        if (webRDTSActive == 'TRUE' && (formobj.StepPlanRotationActive__c == null || formobj.StepPlanRotationActive__c == '')){ 
            displayNotAvailableMsg = true;
        }
        
        if(formObj.SelAppId__c != null && formObj.SelAppId__c != ''){
            
            List<String> selReviewersId = new List<String>();
            for(String s1 : formObj.SelAppId__c.split(';')){
                selReviewersId.add(s1);
            }
            for(String s : selReviewersId){
                if(sporiginalvalues.get(s) != null){
                    if(selReviewersId.size() == portalUserList){
                        sprightvalues.put('All','All');
                    } else {
                        sprightvalues.put(s, sporiginalvalues.get(s));
                    }
                } 
            }
            for(String s : sporiginalvalues.keySet()){ 
                if(s!= null && !sprightvalues.containsKey(s)){
                    if(!sprightvalues.containsKey('All')){ 
                        spleftvalues.put('All','All');
                    }
                    spleftvalues.put(s, sporiginalvalues.get(s));
                }
            }          
        }else if(formObj.AppName__c != null && formObj.AppName__c != ''){
           
            List<String> selReviewersId = new List<String>();
            for(String s1 : formObj.AppName__c.split(';')){
                selReviewersId.add(s1);
            }
            
            for(String s : selReviewersId){
                if(s!= null && !sprightvalues.containsKey(s)){
                    if(selReviewersId.size() == portalUserList){
                        sprightvalues.put('All','All');
                    } else {
                        sprightvalues.put(sporiginalvalues1.get(s), s);
                    }
                }
            }
            for(String s : sporiginalvalues.keySet()){
                if(s != null && !sprightvalues.containsKey(s)){
                    if(!sprightvalues.containsKey('All')){ 
                        spleftvalues.put('All','All');
                    }
                    spleftvalues.put(s, sporiginalvalues.get(s));
                }
            }
        }else{
            spleftvalues = new Map<String, String>();
            spleftvalues.put('All','All');
            for(String s : sporiginalvalues.keySet()){
                spleftvalues.put(s, sporiginalvalues.get(s));
            }
        }             
        List < String > attachmentECCNIds = new List < String > ();
        List < String > attachmentIds = new List < String > ();

        if (formObj.InputMethod__c != null && formObj.InputMethod__c != '' 
            && formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment' 
            && formObj.FileAttachment__c != null && formObj.FileAttachment__c != '') {
            attachmentIds.add(formObj.FileAttachment__c);
        }
              
        if (formObj.InputMethod__c != null && formObj.InputMethod__c != '' 
            && formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.' 
            && formObj.AdvancedProcessFileAttachment__c != null && formObj.AdvancedProcessFileAttachment__c != '') {
            attachmentIds.add(formObj.AdvancedProcessFileAttachment__c);
        }
        if(!attachmentIds.isEmpty() && attachmentIds<>null){
            Integer filesize;
            for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentIds]) {
                
                attachementWrapper attWrapInst = new attachementWrapper();
                attWrapInst.attName = attDetails.Title ;
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
        if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && 
            (formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign) 
            && formObj.ECCN_attachmentName__c != null && formObj.ECCN_attachmentName__c != '') {
            attachmentECCNIds.add(formObj.ECCN_attachmentName__c);
        }
        
        
        if(!attachmentECCNIds.isEmpty() && attachmentECCNIds<>null) {
            Integer filesize;
            for (ContentVersion attDetails: [SELECT ContentDocumentId, ContentSize, Title FROM ContentVersion where Id IN: attachmentECCNIds]) {
    
                attachementECCNWrapper attWrapInst = new attachementECCNWrapper();
                attWrapInst.attName = attDetails.Title ;
                attWrapInst.attId = attDetails.Id;
                attWrapInst.ContentEDocumentId = attDetails.ContentDocumentId;
                filesize = Integer.valueOf(attDetails.ContentSize/1024);
                if(filesize>1024) {
                    filesize = Integer.valueOf(filesize/1024);
                    attWrapInst.attSize = filesize + ' MB';
                } else if(filesize == 0){
                    attWrapInst.attSize = attDetails.ContentSize + ' Bytes';
                } else {
                    attWrapInst.attSize = filesize + ' KB';
                }
                attWrapECCN.add(attWrapInst);
            }
        }
         
        renderLabel = false;        

        selectedAddContList = new List < addContactWrapper > ();        
        fmsSubscriptionList = new List < FMS_Subscription__c > ();
        fmsSubscription = new FMS_Subscription__c();
        selServiceOptionsView = new List < String > ();
        addStepPlanList = new List<addContactWrapper>();
        servOptsSetPg3 = new Set<String>(); 
        
        requestMsg = '';
        stateChangeComments = '';
        popupVal = false;
        popupCreateAdd = false;
        subscribeFlag = false;
        
        formObj.IsGeneratePublicURLForAttach__c = !isPortalUser;
        formObj.IsGeneratePublicURLForECCNAttach__c = !isPortalUser;
        
        Id grpId = [SELECT ID, Name FROM Group WHERE DeveloperName = :FMS_Admin_Group].id;
        if(!isPortalUser){
            for (GroupMember m: [Select Id, UserOrGroupId From GroupMember Where GroupId = : grpId]) {
                if (((String) m.UserOrGroupId).startsWith(userType)) {
                    grpUsers.add(m.UserOrGroupId);
                }
            }
        }
        if (grpUsers.contains(UserInfo.getUserId())) {
            isFMSAdmin = true;
        } else {
            isFMSAdmin = false;
        }
        
        Map < Id, Form_Management_System__c > allChildrenMap = new Map < Id, Form_Management_System__c > ([SELECT id, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c FROM Form_Management_System__c WHERE Parent_Form_Id__c = : fId]);
        if (allChildrenMap.isEmpty()) {
            hasChildren = false;
        } else {
            hasChildren = true;
        }       
   
        if (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '') {
            for (String s: formObj.ServiceOptions__c.split(';')) {
                selServiceOptionsView.add(s);
                selServiceOptions.add(s);
            }
            servOptsSetPg3.addAll(selServiceOptions);
            if(!formObj.ServiceOptions__c.contains('Dicing')){
                contDicing = true;
            } else {
                contDicing = false;
            }
        }
        
        renderMethodsForView();
        renderFinalPassivationView();        
        renderotherServiceFeaturesView();
        renderChipEdgeWLCP();        
              
        fmsSubscriptionList = [Select id, Form_Inserted__c, Form_Status_Change__c, Form_Updated__c, Subscribed_Date__c, UnSubscribed_Date__c FROM FMS_Subscription__c WHERE Form_Id__c = : fId AND User_Name__c = : UserInfo.getUserId() and UnSubscribed_Date__c=null and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Saved_Search_Id__c=null];    
          
         if(fmsSubscriptionList.size()>0) {      
           fmsSubscription = fmsSubscriptionList[0];
          if (fmsSubscriptionList != null && fmsSubscriptionList.size() > 0) {            
            subscribeFlag = true;    
          }else{    
             subscribeFlag = false;    
          }
        }
        if(isTFACompany && formObj.QuoteOnly__c == 'Yes'){
            Page2TFA = 2;
            Page2 = 0;
            Page3 = 0;
            Page4 = 0;
            Page5 = 0;
        } else if(isTFACompany && formObj.QuoteOnly__c == 'No'){
            if(formObj.TestServices__c == 'Yes' && (formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null)){
                Page2TFA = 2;
                Page2 = 3;
                Page3 = 4;
                Page4 = 5;
                Page5 = 0;
            }else if(formObj.Packaging_Services__c == 'Yes'){
                Page2TFA = 2;
                Page2 = 3;
                Page3 = 4;
                Page4 = 5;
                Page5 = 6;
            }else {
                Page2TFA = 2;
                Page2 = 3;
                Page3 = 4;
                Page4 = 0;
                Page5 = 0;
            }       
        }else {
            if(formObj.TestServices__c == 'Yes' && (formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null)){
                Page2TFA = 0;
                Page2 = 2;
                Page3 = 3;
                Page4 = 4;
                Page5 = 0;
            }else if(formObj.Packaging_Services__c == 'Yes'){
                Page2TFA = 0;
                Page2 = 2;
                Page3 = 3;
                Page4 = 4;
                Page5 = 5;
            }else {
                Page2TFA = 0;
                Page2 = 2;
                Page3 = 3;
                Page4 = 0;
                Page5 = 0;
            }           
        } 
    
        tranx = ApexPages.currentPage().getParameters().get('tranx');   
        deleteId = ApexPages.currentPage().getParameters().get('delFormNum');
        if(tranx == 'Subscribe'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription created successfully'));
        } 
        if(tranx == 'UnSubscribe'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Individual form subscription successfully removed'));
        }  
        if(tranx == 'InActiveStateChange' )  {
            String previousState = ApexPages.currentPage().getParameters().get('previousState'); 
            String newState = ApexPages.currentPage().getParameters().get('newState');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+previousState+' to '+newState));
        } 
        if(tranx == 'delete'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form successfully deleted : '+deleteId));
        } 
        populateAdditionalContacts();
        populateSPContacts();
        if(!ApexPages.currentPage().getUrl().contains('view') && !ApexPages.currentPage().getUrl().contains('View')){
            prepopulateValues(); 
        }
    }
       
    //Added by Anirban on 9/22/2017 for automatic CPQ License assignment
    public void init(){
        if(formObj != null && formObj.ReleaseProcessFlow__c == 'Original Flow'){
            String licStatus = ClsProductServices.checkLicense();    
        }
        if(fId != null && fId != '') {
            lstproposal = getconfigData();
        }
        prop = [select id from Apttus_Proposal__Proposal__c where FMS_Proposal__c=:formObj.id];
    }
    
    public void populateAdditionalContacts(){
        selectedAddContList = new List<addContactWrapper>(); 
        List < String > nameList = new List<String>();
        List < String > phoneList = new List<String>();
        List < String > emailList = new List<String>();
        if (formObj.Name__c != null && formObj.Name__c != '') {
            nameList = formObj.Name__c.split(';');
            if (formObj.Phone__c != null && formObj.Name__c != '')phoneList = formObj.Phone__c.split(';');
            if (formObj.Email__c != null && formObj.Name__c != '')emailList = formObj.Email__c.split(';');
            addContactWrapper adc;
            for (Integer i = 0; i < nameList.size(); i++) {
                adc = new addContactWrapper(nameList[i], i<phoneList.size()?phoneList[i]:'', i<emailList.size()?emailList[i]:'');
                selectedAddContList.add(adc);
            }
        }else{
            selectedAddContList.clear();
        }
        if (selectedAddContList != null && !selectedAddContList.isEmpty()) {
            addContactsCountView = String.valueOf(selectedAddContList.size());
        } else {
            addContactsCountView = 'No';
        }
    }
    
    public void populateSPContacts(){
        addStepPlanList = new List<addContactWrapper>(); 
        List < String > spNameList = new List<String>();
        //List < String > phoneList = new List<String>();
        List < String > spEmailList = new List<String>();
        System.debug(formObj.AppName__c);
        if (formObj.AppName__c != null && formObj.AppName__c != '') {
            spNameList = formObj.AppName__c.split(';');
            //if (formObj.Phone__c != null && formObj.Name__c != '')phoneList = formObj.Phone__c.split(';');
            if (formObj.AppEmail__c != null && formObj.AppName__c != '')spEmailList = formObj.AppEmail__c.split(';');
            addContactWrapper adc;
            for (Integer i = 0; i < spNameList.size(); i++) {
                adc = new addContactWrapper(spNameList[i],'', i<spEmailList.size()?spEmailList[i]:'');
                addStepPlanList.add(adc);
            }
        }else{
            addStepPlanList.clear();    
        }
    }
    
    public void renderPage1Methods() {
                    
        if(formObj.Technology__c != null && formObj.Technology__c != '' && !storedNamefmsTechnoMDTMap.isEmpty()){
            if(storedNamefmsTechnoMDTMap.get(formObj.Technology__c) != null){
                formObj.Technology__c = storedNamefmsTechnoMDTMap.get(formObj.Technology__c).MasterLabel;
            }
        }
        if(formOBj.TestServices__c != null && formObj.TestServices__c != '' && formObj.TestServices__c == 'Yes'){
            dispTestLevel = true;
        }
        renderingOfIntConBumpSource();
        changeReleGuide(); 
       
    }
    
    public void renderPage2Methods() {
        displayDicing = false;
        checkNone = false;
        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){
            if(formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == ''){           
                selServiceOptions.add(UtilityCls.Dicing);
                displayDicing = true;
            } else{
                Set<String> selOptsSet = new Set<String>();
                selOptsSet.addAll(formObj.ServiceOptions__c.split(';'));
                if(!selOptsSet.isEmpty()){
                    if(!selOptsSet.contains(UtilityCls.Dicing)){
                        selServiceOptions.add(UtilityCls.Dicing);
                    }
                } 
            }
            displayDicing = true;
        } else if(formObj.technology__c == UtilityCls.CSOI8SW && (formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == '')) {
            selServiceOptions.clear();
            selServiceOptions.add('None');
            checkNone = true;
        } else{
            if(formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == ''){
                selServiceOptions.clear();
            }
        }

        renderLastMetalUsed();
        rendersourcingLocation();
        renderNumMetalLayers();
        renderPassivation();
    getPassivationList();
        renderPassivation1();
        renderTechFeatures();
        renderOtherServiceFeatures();
        renderNotMfgFeaturesDesc();
        renderStepPlanCustomReq();
        renderDeliverableSplit();
        renderNumThickLevel();
        renderBacksideGrindThickness();
        renderCll();
        renderNonStandardCll();
        renderFinalPassivation();
        renderLineFront();
        renderShippingLabelCLL();
        renderChipEdgeDesign();
        renderWaiverLink();
        renderDataCheckingOpts();
        renderMetalizationOption(); 
        
    }
    
    public void renderPage2TFAMethods() {
        readOnlyCheck = readOnlyCheckMethod();
        
        wireBondsplit = formObj.WireBondSplit__c;
        busComments = formObj.BusinessComments__c;
        wireBondsplitTAT = formObj.WireBondSplitTAT__c;
        wirebondwafer = formObj.WireBondWaferReq__c;
        c4Split = formObj.C4Split__c;
        c4SplitTAT = formObj.C4SplitTAT__c;
        c4wafer = formObj.C4WaferReq__c;
        othersplits = formObj.OtherSplits__c;
        othersplitsdet = formObj.OtherSplitDets__c;
        itaCat = formObj.ItarCategory__c;
        clrespdt = String.valueOf(formObj.ClientResponseDt__c);
        bizComment = formObj.NeedBizComment__c; //Modified the code for UAT Issue #428
        businessComment = formObj.BusinessComments__c; //Modified the code for UAT Issue #428
        
        renderWireBondSplit();
        renderWireBondSplitTAT();
        renderC4SplitTAT();
        renderOtherSplitDets();
        renderClientResponseDt();
        renderNeedBizComment();
        renderITARCat();
    }
    
    public void renderPage3Methods() {
        dispStdReticle = false;
        dispCrackOptions = false; 
        servOptsSetPg3 = new Set<String>();
        servOptsSetPg3.addAll(selServiceOptions);
        if(!servOptsSetPg3.contains('Dicing')){
            contDicing = true;
        } else {
            contDicing = false;
        }

        if((formObj.FileAttachment__c == null || formObj.FileAttachment__c == '') && (formObj.Packaging_Services__c == 'Yes'|| formObj.Packaging_Services__c == 'No') && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle && (formObj.InputMethod__c == null || formObj.InputMethod__c == '')) {
            attWrap.clear();
        }
        readVerticalX = String.ValueOf(formobj.VerticalX__c);
        readHorizontalY = String.ValueOf(formobj.HorizontalY__c);

        renderNumOfDesigns();
        renderMaxChipPower();
        renderC4PadLayout();
        renderC4PadLayoutForDRC();
        renderNumC4Pads();
        renderPinOneID();
        renderdesignKitOthers();
        renderNeedAdditionalComments();
        renderadditionalComments();
        renderC4SolderMaterial();
        renderC4LaminatePackage();
        renderChamferedCorner();
        renderOtherC4PadLayout();
        renderWirebondLayout();
        renderWireBondPad();
        renderWirebondPadPitch();
        renderPickMap();
        renderCircuitType(); 
        
        renderInputMethod();
        renderStepPlanSection();
        renderCrackOptions();
        renderDicingMarks();

        displayRenderLabel();
    }
    
    public void renderMethodsForView() {
        renderPage1Methods();
        renderPage2Methods();
        renderPage2TFAMethods();
        renderPage3Methods();
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
    
    public List<Apttus_Proposal__Proposal__c> getconfigData(){
        List<Apttus_Proposal__Proposal__c> proposals = [SELECT Id,Name,Apttus_Proposal__Account__c,FMS_Proposal__c,Apttus_Proposal__Opportunity__c, Fab_Name__c ,                                                                      
                                                                        Apttus_Proposal__Account__r.Name, Apttus_Proposal__Opportunity__r.Name, Apttus_Proposal__Proposal_Name__c
                                                                        FROM Apttus_Proposal__Proposal__c
                                                                        WHERE FMS_Proposal__c=:fId];
        if(proposals != null && proposals.size() !=0 ){
            fetch_ApttusProposalLineItems(proposals.get(0));
        }
        return  proposals;
    }
    public Boolean isTechnologyConfigured {get; set;}
    public Product2 bundleProduct {get; set;}
    public Map<Id, Apttus_Config2__ProductOptionGroup__c> mapTabPOGs {get; set;}
    public Map<Id, List<Apttus_Config2__ProductOptionGroup__c>> sectionsByTab {get; set;}
    public Map<Id, List<Apttus_Config2__ProductOptionComponent__c>> optionsBy_POG_Ids {get; set;}
    public void fetch_ApttusProposalLineItems(Apttus_Proposal__Proposal__c proposalRecord){
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems =[Select  Apttus_QPConfig__OptionId__c, Apttus_Proposal__Product__c 
                                                                            from Apttus_Proposal__Proposal_Line_Item__c 
                                                                            where Apttus_Proposal__Proposal__c = :proposalRecord.Id Order By  Apttus_QPConfig__OptionId__r.Family, Apttus_QPConfig__OptionId__r.Name];
        if(lstProposalLineItems != null && lstProposalLineItems.size() >0 && lstProposalLineItems.get(0).Apttus_Proposal__Product__c != null){
            bundleProduct = [Select Name, Description, PT_Number__c, Geometry__c, Mask_Sets__c, Product_External_ID__c from Product2 where Id = : lstProposalLineItems.get(0).Apttus_Proposal__Product__c ].get(0); 
            isTechnologyConfigured = true;
        }else{
            return;
        }
        Set<Id> setOfAllSelectedoptions = new Set<Id>();
        for(Apttus_Proposal__Proposal_Line_Item__c pli : lstProposalLineItems){
            if(pli.Apttus_QPConfig__OptionId__c != null)
                setOfAllSelectedoptions.add(pli.Apttus_QPConfig__OptionId__c);
        }
        lstProposalLineItems.clear();
        
        optionsBy_POG_Ids = new Map<Id, List<Apttus_Config2__ProductOptionComponent__c>>();
        for(Apttus_Config2__ProductOptionComponent__c poc : [Select id, Apttus_Config2__ComponentProductId__c, Apttus_Config2__ProductOptionGroupId__c, Apttus_Config2__ComponentProductId__r.Name, 
                                                                Apttus_Config2__ComponentProductId__r.Family, Apttus_Config2__ComponentProductId__r.Mask_Sets__c, Apttus_Config2__ComponentProductId__r.Description
                                                                from Apttus_Config2__ProductOptionComponent__c 
                                                                where Apttus_Config2__ComponentProductId__c != '' AND Apttus_Config2__ProductOptionGroupId__c != '' AND Apttus_Config2__ComponentProductId__c IN : setOfAllSelectedoptions
                                                                Order by Apttus_Config2__Sequence__c]){
            if(optionsBy_POG_Ids.containsKey(poc.Apttus_Config2__ProductOptionGroupId__c))
                optionsBy_POG_Ids.get(poc.Apttus_Config2__ProductOptionGroupId__c).add(poc);
            else
                optionsBy_POG_Ids.put(poc.Apttus_Config2__ProductOptionGroupId__c, new List<Apttus_Config2__ProductOptionComponent__c>{poc});
        }
        setOfAllSelectedoptions.clear();
        
        mapTabPOGs = new Map<Id, Apttus_Config2__ProductOptionGroup__c>();
        sectionsByTab = new Map<Id, List<Apttus_Config2__ProductOptionGroup__c>>();
        
        Map<Id, Apttus_Config2__ProductOptionGroup__c> mapOfPOGs = new Map<Id, Apttus_Config2__ProductOptionGroup__c>([Select id, Apttus_Config2__OptionGroupId__c, Apttus_Config2__OptionGroupId__r.Apttus_Config2__Label__c, Apttus_Config2__IsHidden__c, Apttus_Config2__IsLeaf__c, Apttus_Config2__ParentOptionGroupId__c
                                                                from Apttus_Config2__ProductOptionGroup__c 
                                                                where Apttus_Config2__ProductId__c =: bundleProduct.Id 
                                                                Order By Apttus_Config2__RootSequence__c, Apttus_Config2__OptionGroupId__r.Apttus_Config2__Left__c]);
                                                              
        for(Apttus_Config2__ProductOptionGroup__c tabPOG : mapOfPOGs.values()){
            if(tabPOG.Apttus_Config2__ParentOptionGroupId__c == null && !tabPOG.Apttus_Config2__IsHidden__c){
                if(tabPOG.Apttus_Config2__IsLeaf__c && optionsBy_POG_Ids.containsKey(tabPOG.Id)){
                    sectionsByTab.put(tabPOG.Apttus_Config2__OptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>{tabPOG});
                    mapTabPOGs.put(tabPOG.Apttus_Config2__OptionGroupId__c, tabPOG);
                }
                else if(!tabPOG.Apttus_Config2__IsLeaf__c){
                    sectionsByTab.put(tabPOG.Apttus_Config2__OptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>());
                    mapTabPOGs.put(tabPOG.Apttus_Config2__OptionGroupId__c, tabPOG);
                }
                mapOfPOGs.remove(tabPOG.Id);
            }
        }
        
        for(Apttus_Config2__ProductOptionGroup__c sectionPOG : mapOfPOGs.values()){ 
            if(sectionPOG.Apttus_Config2__ParentOptionGroupId__c != null && optionsBy_POG_Ids.containsKey(sectionPOG.Id)){
                if(sectionsByTab.containsKey(sectionPOG.Apttus_Config2__ParentOptionGroupId__c))
                    sectionsByTab.get(sectionPOG.Apttus_Config2__ParentOptionGroupId__c).add(sectionPOG);
                else
                    sectionsByTab.put(sectionPOG.Apttus_Config2__ParentOptionGroupId__c, new List<Apttus_Config2__ProductOptionGroup__c>{sectionPOG});
            }
        }
        mapOfPOGs.clear();
    }
    
    public List<SelectOption> getformTechnology(){
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('', FMS_SELECT_VAL));
        for(FMS_Technology__mdt fmsTech : fmsTechnoMDT){
            if(fmsTech.FMS_Tech_Node__c != null) {
                tempList.add(new SelectOption(fmsTech.MasterLabel, fmsTech.MasterLabel));
            } else {
                if(fmsTech.SAP_Account_Number__c != null ) {
                    if(sapAccNum != null && fmsTech.SAP_Account_Number__c.contains(sapAccNum)){
                        tempList.add(new SelectOption(fmsTech.MasterLabel, fmsTech.MasterLabel));
                    }
                }
            }
        }
        return tempList;
    }
    
    public void renderChipEdgeWLCP(){       
        resetDependentFields();
        if((formObj.Technology__c == UtilityCls.CSOI_7RF && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No') && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) && (formObj.IntConBumpSource__c == 'Yes' && formObj.QuoteOnly__c != 'Yes')){
            dispChipEdgeWLCP = true;
        }else{
            dispChipEdgeWLCP = false;
        }
    }
    
    public List<SelectOption> getchipEdgeWLCSPList(){
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('', FMS_SELECT_VAL));
        tempList.add(new SelectOption('Yes', 'Yes'));
        tempList.add(new SelectOption('No', 'No'));
        return tempList;
    }
        
    public List<SelectOption> getformReleaseProcess(){
        List<SelectOption> tempList = new List<SelectOption>();    
        if(formObj.Technology__c != null && formObj.Technology__c != '--None--'){
            for(FMS_Technology__mdt fmsTech : fmsTechnoMDT){
                if(fmsTech.MasterLabel == formObj.Technology__c){
                    tempList.add(new SelectOption(fmsTech.FMS_Release_Flow__c, fmsTech.FMS_Release_Flow__c));
                }
            }
        }else{
            tempList.add(new SelectOption('', FMS_SELECT_VAL));         
            tempList.add(new SelectOption('Enhanced Flow', 'Enhanced Flow')); 
        }
        return tempList;
        
    }
    
    public List<SelectOption> gettestServicesList(){
        List<SelectOption> tempList = new List<SelectOption>();     
        if(formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != UtilityCls.BMSP6C9){
            tempList.add(new SelectOption('', FMS_SELECT_VAL));  
            tempList.add(new SelectOption('Yes', 'Yes'));
        }
        tempList.add(new SelectOption('No', 'No'));
        
        return tempList;
    }
    
    public List<SelectOption> getpackagingServList(){
        List<SelectOption> tempList = new List<SelectOption>();   
        if(formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != UtilityCls.BMSP6C9){          
            tempList.add(new SelectOption('', FMS_SELECT_VAL));    
            tempList.add(new SelectOption('Yes', 'Yes'));
        }
        tempList.add(new SelectOption('No', 'No'));
        return tempList;
    }
    
    public List<SelectOption> getchipInterconnectList(){
        if(formOBj.Chip_Interconnect__c == null || formObj.Chip_Interconnect__c == ''){
            formObj.Chip_Interconnect__c = '';
        }
        List<SelectOption> tempList = new List<SelectOption>(); 
        tempList.add(new SelectOption('', FMS_SELECT_VAL)); 
        tempList.add(new SelectOption(UtilityCls.Wirebond, UtilityCls.Wirebond));     
        if(formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != UtilityCls.BMSP6C9){
            tempList.add(new SelectOption(UtilityCls.C4flipchip, UtilityCls.C4flipchip));
        }
        if(formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c  == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4){ 
            tempList.add(new SelectOption(UtilityCls.CopperPillar, UtilityCls.CopperPillar));
        }
        if(formObj.Technology__c == UtilityCls.CSOI_7RF){
            tempList.add(new SelectOption(UtilityCls.WLCSP_RDL, UtilityCls.WLCSP_RDL));
            tempList.add(new SelectOption(UtilityCls.WLCSP_BoP, UtilityCls.WLCSP_BoP));
        }
        if(tempList.size() == 2){
            tempList.remove(0);
        }
        return tempList;
    }
    
    public List<SelectOption> gettestLevelList(){
        List<SelectOption> options = new List<SelectOption>();   
        options.add(new SelectOption('', FMS_SELECT_VAL));           
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.TestLevels__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){
            if(formObj.TestServices__c == 'Yes' && (formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null)){
                if(f.getValue() == 'Wafer'){                
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }else if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){  
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        if(options.size() == 2){
            options.remove(0);
        }
        return options;     
    }
    
    public List<SelectOption> getIntConBumpSourceList(){
        List<SelectOption> tempList = new List<SelectOption>();  
        tempList.add(new SelectOption('', FMS_SELECT_VAL));
        tempList.add(new SelectOption('Yes', 'Yes'));
        tempList.add(new SelectOption(UtilityCls.No_21L2039, UtilityCls.No_21L2039)); 
        return tempList;
    }
    
    public void renderingOfTestLevel(){

        if(formObj.TestServices__c == 'Yes'){
            dispTestLevel = true;
        }else{
            dispTestLevel = false;
        }
        renderingOfIntConBumpSource();
    }
    
    public void renderingOfIntConBumpSource(){
        resetDependentFields();
        if(((formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
            formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_9SF || formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || 
            formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.CMOS_6SF || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
            formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
            formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == '' || 
            formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe || formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.SOI12S0 || formObj.Technology__c == UtilityCls.X32SOI || 
            formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == '45RFSOI' ) 
            && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && 
            (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)
            
            )||((formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar ))){            
                
                dispIntConBumpServ = true;
        }else{
            dispIntConBumpServ = false;
        }
        renderChipEdgeWLCP();
    }
        
    public List<SelectOption> getprimaryContactsList(){
        List<User> newUserList = new List<User>();
        List<SelectOption> tempList = new List<SelectOption>();
        if(formObj.UserIdPrimary__c != null && formObj.UserIdPrimary__c != '' && formObj.UserIdPrimary__c != loggedInUser.Id){
            tempList.add(new SelectOption(formObj.UserIdPrimary__c, formObj.NamePrimary__c));
        } //else {
            tempList.add(new SelectOption(loggedInUser.Id, loggedInUser.Name));         
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
                if(u.Name != UserInfo.getName() && u.Contact.Email != UserInfo.getUserEmail() && u.Id != formObj.UserIdPrimary__c){
                    tempList.add(new SelectOption(u.Id, u.Name));
                }
            }
        }
        return tempList;
    }
    
    public List<SelectOption> getreleGuideList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('', FMS_SELECT_VAL));              
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.HasReleaseGuidelines__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;        
    }    
    
    public void changeTechOptForOriginal(){
        Boolean isCheck=false;
        if(prop!=null && prop.size()>0){
            List<Apttus_Config2__ProductConfiguration__c> prodConfig = [select id from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c=:prop[0].id];
            delete prop;
            if(prodConfig!=null && prodConfig.size()>0){
                delete prodConfig;
            }
            lstproposal = new List<Apttus_Proposal__Proposal__c>();
            isTechnologyConfigured=null; 
            mapTabPOGs=null;  
            sectionsByTab=null;
            optionsBy_POG_Ids=null;
            isCheck=true;
        }
        prop = null;
        changeReleGuide();
        if(isCheck){
            formObj.Technology_Features__c = '';
            try {
                update formObj;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'changeTechOptForOriginal()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    public void changeReleGuide(){
        fmsTechbyoldvalue = formObj.Technology__c;
        resetDependentFields();
        
        if(formObj.Technology__c == UtilityCls.BiMOS_P6 || formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.BMSP6C9){                
            renderingOfTestLevel();
        }
        renderingOfIntConBumpSource();
        if(formobj.Technology__c !=null && formobj.Technology__c !=''
            && formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9' && formobj.Technology__c != 'CNV8SFi'){
            isTechVisible = true;
        }else{
            isTechVisible = false;
        }
    }
    
    public void assignCPQLicense(){
        if(formObj.ReleaseProcessFlow__c == 'Original Flow'){
            String licStatus = ClsProductServices.checkLicense(); 
        }    
    }  
    
    public void prepopulateValues(){
        if(formObj.UserIdPrimary__c != null && formObj.UserIdPrimary__c != ''){
            List<User> primUser = new List<User>([select Id, Name, email, Contact.Email, country, state, phone from User where Id =:formObj.UserIdPrimary__c]);
            if(!primUser.isEmpty()){
                formObj.NamePrimary__c = primUser[0].name;
                formObj.EmailPrimary__c = (primUser[0].Contact.Email != null) ? primUser[0].Contact.Email : primUser[0].email;
                formObj.CountryPrimary__c = primUser[0].Country;
                formObj.StatePrimary__c = primUser[0].State;
                formObj.PhonePrimary__c = primUser[0].Phone; 
            }
        }else{
            formObj.NamePrimary__c = loggedInUser.name;
            formObj.EmailPrimary__c = loggedInUser.email;
            formObj.CountryPrimary__c = loggedInUser.Country;
            formObj.StatePrimary__c = loggedInUser.State;
            formObj.PhonePrimary__c = loggedInUser.Phone;
        }
    }

    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.put(s, originalValues.get(s));
        }
        updateCountOfAddContacts();
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.put(s, originalValues.get(s));
        }
        updateCountOfAddContacts();
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(string s : leftvalues.keySet()){
            if(s != null && leftvalues.get(s) != null){
                options.add(new SelectOption(s,leftvalues.get(s))); 
            }
        }
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        for(String s : rightvalues.keySet()){
            if(s != null && rightvalues.get(s) != null){                
                options1.add(new SelectOption(s,rightvalues.get(s)));   
            }
        }
        return options1;
    }
    
    public void updateCountOfAddContacts(){
        if(!rightvalues.values().isEmpty()){
            addContactsCount = String.valueOf(rightvalues.values().size());
        }else{
            addContactsCount = 'No';
        }
    }
    
    public List<AddContWrapper> getaddContTable(){
        selectedContactList = new Map<String, AddContWrapper>();
        if(!rightvalues.keySet().isEmpty()){
            if(rightvalues.keySet().contains(UserInfo.getUserId())){
                selectedContactList.put(UserInfo.getUserId(), new AddContWrapper(UserInfo.getName(), UserInfo.getUserEmail(), loggedinUser.Phone, UserInfo.getUserId()));
            }   
            if(rightvalues.containskey(prevLogUser)){
                //Modified below query against Issue#427...#IM...10-7-17
                List<User> prevUser = new List<User>([SELECT id, Name, Phone, Email, Contact.Email FROM User WHERE Id = :prevLogUser LIMIT 1]);
                if(!prevUser.isEmpty()){
                    String newEmail = (prevUser[0].Contact.Email != null) ? prevUser[0].Contact.Email : prevUser[0].email;
                    selectedContactList.put(prevUser[0].Id, new AddContWrapper(prevUser[0].Name, newEmail, prevUser[0].Phone, prevUser[0].Id));
                }
            }
            //Modified below query against Issue#427...#IM...7-7-17
            for(User u:[SELECT id, Name, Phone, Email, Contact.Email FROM User WHERE Id IN : rightvalues.keySet() and isActive =true order by Name]){
                String newEmail = (u.Contact.Email != null) ? u.Contact.Email : u.email;
                selectedContactList.put(u.Id, new AddContWrapper(u.Name, newEmail, u.Phone, u.Id));
            }            
        }
        return selectedContactList.values();
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

    public void renderWaiverLink(){
        resetDependentFields();
        if(formObj.Waivers__c == 'Yes'){
            dispWaiverLink = true;
        }else{
            dispWaiverLink = false;
        }
    }
        
    public List<SelectOption> getlastMetalUsedList(){
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('', FMS_SELECT_VAL));
         
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Last Metal Used') { 
                
                if(fmsTab.is_InActive__c && formObj.LastMetalUsed__c != fmsTab.DB_Value__c) {
                  continue;
                }
                               
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe ||
                    formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || 
                    formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP ||
                    formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.CMOS_6SF || 
                    formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.SOI7SWT)){              
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }else{               
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG) && formObj.Chip_Interconnect__c != UtilityCls.CopperPillar ){
                        if(fmsTab.UI_Value__c != 'MZ (Not Qualified with Copper Pillar)' && fmsTab.UI_Value__c != 'ML (Not Qualified with Copper Pillar)'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }                   
                    }
                    
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG) && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                        if(fmsTab.DB_Value__c == 'AM' || fmsTab.DB_Value__c == 'MA' || fmsTab.UI_Value__c == 'MZ (Not Qualified with Copper Pillar)' || fmsTab.UI_Value__c == 'ML (Not Qualified with Copper Pillar)'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL &&  fmsTab.DB_Value__c.deleteWhitespace() == 'LD(ThreeThickWires)'){                     
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }      
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL &&  fmsTab.DB_Value__c.deleteWhitespace() != 'LD(ThreeThickWires)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMHV7SF &&  fmsTab.DB_Value__c.deleteWhitespace() == 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)') {
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    } else if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMHV7SF &&  fmsTab.DB_Value__c.deleteWhitespace() == 'C3(3umCuWireforMEMS)(MT,FT,E1,F1)(84Y8174)' && formObj.Chip_Interconnect__c != UtilityCls.CopperPillar && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3)){ 
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7RF){
                        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.Wirebond) && fmsTab.DB_Value__c.deleteWhitespace() == 'LD(LD,VV,EZ,E2,E1,FT,MT)(45Y0368)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        } 
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) 
                            && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && fmsTab.DB_Value__c.deleteWhitespace() == 'LD(LD,VV,EZ,E2,E1,FT,MT)(45Y0368)') {
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes')) && 
                        (formObj.Chip_Interconnect__c == UtilityCls.Wirebond || formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || 
                        formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && 
                        (fmsTab.DB_Value__c.deleteWhitespace() == 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)' || 
                        fmsTab.DB_Value__c.deleteWhitespace() == 'MA(DualLastMetal)(MA,ZF,E2,E1,FT,MT)(70P5487)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && 
                        formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && 
                        (fmsTab.DB_Value__c.deleteWhitespace() == 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)' || fmsTab.DB_Value__c.deleteWhitespace() == 'MA(DualLastMetal)(MA,ZF,E2,E1,FT,MT)(70P5487)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.Wirebond || 
                        formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP 
                        || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.IntConBumpSource__c == 'Yes' && 
                        (fmsTab.DB_Value__c.deleteWhitespace() == 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)' || fmsTab.DB_Value__c.deleteWhitespace() == 'MA(DualLastMetal)(MA,ZF,E2,E1,FT,MT)(70P5487)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.Wirebond) && 
                        (fmsTab.DB_Value__c.deleteWhitespace() == 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)' || fmsTab.DB_Value__c.deleteWhitespace() == 'MA(DualLastMetal)(MA,ZF,E2,E1,FT,MT)(70P5487)')){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7SW){
                        /*(checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4) && 
                        (fmsTab.DB_Value__c.deleteWhitespace() == 'AM,FT(AnalogLastMetal)(AM,FT,MR)(84Y9647)' || 
                        fmsTab.DB_Value__c.deleteWhitespace() == 'MA,FT(DualLastMetal)(MA,ZF,E2,E1,FT,MR)(84Y9648)')){  
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == 'AM,FQ(AnalogLastMetal)(AM,FQ,MR)(84Y9601)' || 
                        fmsTab.DB_Value__c.deleteWhitespace() == 'MA,FQ(DualLastMetal)(MA,ZF,E2,E1,FQ,MR)(84Y9602)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }*/
            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CSOI8SW) &&
                    (fmsTab.UI_Value__c == 'ML (Thin Aluminum Analog Metal) (ML, ZF) (00VD439)'||
                    fmsTab.UI_Value__c == 'MA (Thick Aluminum Analog Metal) (MA, ZF) (00VD440)')){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) &&
                    (fmsTab.UI_Value__c == 'MA (Dual Metal) (MT, FT, E1, E2, ZF, MA) (70P5487)')){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
            }
        }
         if(tempList.size() == 2){
                 tempList.remove(0);
       }
        if(tempList.size() == 1 && dispLastMetalUsed){
            for(SelectOption s1 : tempList){
                formObj.LastMetalUsed__c = s1.getValue();
            }
        }
        return tempList;
    }
    
    public void renderLastMetalUsed(){
        if(formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || 
            formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
            formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || 
            formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.CMOS_6SF || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
                dispLastMetalUsed = true;
        }else{
            dispLastMetalUsed = false;
        }
    }

    public void rendersourcingLocation(){
        if((formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' 
            || formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CSOI 7SW' 
            || formObj.Technology__c == 'SOI7SWT') && (checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4)
            || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO5))){
                dispsourcingLocation = true;
            } else {
                 dispsourcingLocation = false;
            }
    }
    
    public List<SelectOption> getSourcingLocList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('', FMS_SELECT_VAL));              
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.SourcingLocation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for( Schema.PicklistEntry f : ple){
            if(f.getValue() == 'FAB 2 (Singapore) - 200mm') {
                if(formObj.Technology__c == 'SOI7SWT' || formObj.Technology__c == 'CSOI 7SW'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
            if(f.getValue() == 'FAB 9 (Burlington, VT) - 200mm') {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getValue() == 'FAB 10 (East Fishkill, NY) - 300mm') {
                if(formObj.Technology__c == UtilityCls.CSOI_7RF) {
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
            if(f.getValue() == 'X-FAB (Essonnes, France) - 200mm') {
                if(formObj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formObj.Technology__c == 'CMOS 7TG (CMRF7TG)' 
                    || formObj.Technology__c == UtilityCls.CSOI_7RF){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }                        
        }       
        return options;        
    }
    
    public void renderCll(){
        if((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO7) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c,UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c,UtilityCls.FMS_SAP_ACC_NO17)) && 
        (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.IPD5PAE || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
        formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.CSOI_7TF || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || 
        formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){  
            dispCll = true;
        }else{
            dispCll = false;
        }
    }
    
    public void renderNonStandardCll(){
        resetDependentFields();
        if((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO7) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO17)) && 
        (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.IPD5PAE || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
        formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.CSOI_7TF || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || 
        formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && formObj.CLL__c == 'Non-standard CLL (requires pre-approval)'){ 
            dispNonStandardCll = true;
        }else{
            dispNonStandardCll = false;
        }       
        renderShippingLabelCLL();
    }
    
    public void renderShippingLabelCLL(){
        if((checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO13) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO7) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO6) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO10) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO8) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO3) || 
        checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO9)|| checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO16) || checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO17)) && 
        (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.CSOI_7TF || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || 
        formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && (formObj.CLL__c == 'Non-standard CLL (requires pre-approval)' || formObj.CLL__c == 'Standard CLL (133X71LS)')){   
            dispShippingLabelCLL = true;
        }else{
            dispShippingLabelCLL = false;
        }
    }
    
    public List<SelectOption> getNumMetalLayersList(){
        List<SelectOption> tempList = new List<SelectOption>();  

        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Num Metal Layer'){
                
                if(fmsTab.is_InActive__c && formObj.NumMetalLayers__c != fmsTab.DB_Value__c) {
                  continue;
                }
                
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4 || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || 
                formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == UtilityCls.BiMOS_P6 || formObj.Technology__c == UtilityCls.BMSP6C9 || 
                formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.IPD5PAE )){ 
                    tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }else{
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe)){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == '3LM(01L6950)' && formObj.LastMetalUsed__c == 'AM (Analog Metal) (MT, FT, AM) (70P5485)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '4LM(01L6951)' && (formObj.LastMetalUsed__c == 'AM (Analog Metal) (MT, FT, AM) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Metal) (MT, FT, E1, F1, MA) (44K1363)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '5LM(01L6952)' && formObj.LastMetalUsed__c == 'MA (Dual Metal) (MT, FT, E1, F1, MA) (44K1363)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL){
                        if(formObj.LastMetalUsed__c == 'AM' && fmsTab.DB_Value__c == '3'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.LastMetalUsed__c == 'MA' && fmsTab.DB_Value__c == '7'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '4' || fmsTab.DB_Value__c.deleteWhitespace() == '5' || fmsTab.DB_Value__c.deleteWhitespace() == '6'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL){
                        if(fmsTab.DB_Value__c == '3' && (formObj.LastMetalUsed__c == 'AM' || formObj.LastMetalUsed__c == 'ML (Last Metal)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }if((fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6') && formObj.LastMetalUsed__c != 'LD (Three Thick Wires)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }if(fmsTab.DB_Value__c == '7' && formObj.LastMetalUsed__c == 'MA'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }if(fmsTab.DB_Value__c == '8' && formObj.LastMetalUsed__c == 'LD (Three Thick Wires)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }                   
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP)){
                        if((fmsTab.DB_Value__c.deleteWhitespace() == '5(01L6952)' || fmsTab.DB_Value__c.deleteWhitespace() == '6(01L6953)' || fmsTab.DB_Value__c.deleteWhitespace() == '7(29L6986)') && formObj.LastMetalUsed__c == 'AM (Analog Metal) (06K3730)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if((fmsTab.DB_Value__c.deleteWhitespace() == '6(01L6953)' || fmsTab.DB_Value__c.deleteWhitespace() == '7(29L6986)'|| fmsTab.DB_Value__c.deleteWhitespace() == '8(45L8958)')  && formObj.LastMetalUsed__c == 'MA (Dual Metal) (84Y9326)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }                 
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMHV7SF){
                        if((fmsTab.DB_Value__c == '3' || fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6' || fmsTab.DB_Value__c == '7') && formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '8' && formObj.LastMetalUsed__c == 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF){
                        if(fmsTab.DB_Value__c == '3' && (formObj.LastMetalUsed__c == 'ML' || formObj.LastMetalUsed__c == 'AM')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '7' && formObj.LastMetalUsed__c == 'MA'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }                   
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6SF){
                        if(fmsTab.DB_Value__c == '2' && formObj.LastMetalUsed__c != 'LM'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '3' || fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG)){
                        if((fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6') && formObj.LastMetalUsed__c != 'MZ'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if((formObj.LastMetalUsed__c == 'ML' || formObj.LastMetalUsed__c == 'AM') && formObj.LastMetalUsed__c != 'MZ' && fmsTab.DB_Value__c == '3'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.LastMetalUsed__c != 'MZ' && formObj.LastMetalUsed__c == 'MA' && fmsTab.DB_Value__c == '8'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c)); 
                        }else if(fmsTab.DB_Value__c == '7'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7RF){
                        if((formObj.TestServices__c != '' && formObj.Packaging_Services__c != '') && (formObj.Chip_Interconnect__c == UtilityCls.Wirebond || 
                        formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || 
                        formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == '3LM(01L6950)' || fmsTab.DB_Value__c.deleteWhitespace() == '4LM(01L6951)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }else if((formObj.TestServices__c != '' && formObj.Packaging_Services__c != '') && (formObj.Chip_Interconnect__c == UtilityCls.Wirebond || 
                        formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || 
                        formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (Ma, ZF, E2, E1, FT, MT) (70P5487)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == '5LM(01L6952)' || fmsTab.DB_Value__c.deleteWhitespace() == '4LM(01L6951)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }else if((formObj.TestServices__c != '' && formObj.Packaging_Services__c != '') && (formObj.Chip_Interconnect__c == UtilityCls.Wirebond || 
                        formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || 
                        formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == '5LM(01L6952)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7SW){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == '3LM(01L6950)' && (formObj.LastMetalUsed__c == 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)' || formObj.LastMetalUsed__c == 'AM, FQ with Dense MR (Analog Last Metal) (AM, FQ, MR) (00VD054)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '4LM(01L6951)' && (formObj.LastMetalUsed__c == 'AM, FQ with Dense MR (Analog Last Metal) (AM, FQ, MR) (00VD054)' || formObj.LastMetalUsed__c == 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)' || formObj.LastMetalUsed__c == 'MA, FQ (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (84Y9602)' || formObj.LastMetalUsed__c == 'MA, FQ with Dense MR (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (00VD055)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '5LM(01L6952)' && (formObj.LastMetalUsed__c == 'MA, FQ (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (84Y9602)' || formObj.LastMetalUsed__c == 'MA, FQ with Dense MR (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (00VD055)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7TF){
                        if(fmsTab.DB_Value__c == '3' && formObj.LastMetalUsed__c == 'AM (Analog Last Metal)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '8' && formObj.LastMetalUsed__c == 'MA (Dual Metal Last Metals)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c == '4' || fmsTab.DB_Value__c == '5' || fmsTab.DB_Value__c == '6' || fmsTab.DB_Value__c == '7'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.SOI7SWT){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == '3LM(01L6950)' && ( formObj.LastMetalUsed__c == 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)' || formObj.LastMetalUsed__c == 'AM, FQ with Dense MR (Analog Last Metal) (AM, FQ, MR) (00VD054)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '4LM(01L6951)' && (formObj.LastMetalUsed__c == 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)' || formObj.LastMetalUsed__c == 'MA, FQ (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (84Y9602)' || formObj.LastMetalUsed__c == 'AM, FQ with Dense MR (Analog Last Metal) (AM, FQ, MR) (00VD054)' || formObj.LastMetalUsed__c == 'MA, FQ with Dense MR (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (00VD055)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == '5LM(01L6952)' && ( formObj.LastMetalUsed__c == 'MA, FQ (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (84Y9602)' || formObj.LastMetalUsed__c == 'MA, FQ with Dense MR (Dual Last Metal) (MA, ZF, E2, E1, FQ, MR) (00VD055)')){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                }
            }
        }
         if(tempList.size() > 1){
            tempList.add(new SelectOption('', FMS_SELECT_VAL));
            tempList.sort();
        }

       return tempList;
    }
    
    public void renderNumMetalLayers(){
        if(formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CSOI_7RF || 
        formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
        formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || 
        formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7TF || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiMOS_P6 || formObj.Technology__c == UtilityCls.BMSP6C9 || formObj.Technology__c == UtilityCls.CMOS_6SF || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
            dispNumMetalLayers = true;
        }else{
            dispNumMetalLayers = false;
        }
    }
    
    public List<SelectOption> getPassivation1List(){
        List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('', FMS_SELECT_VAL));
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
             if(fmsTab.Field__c == 'Through-Silicon Via'){
                if(fmsTab.is_InActive__c && formObj.Passivation1__c != fmsTab.DB_Value__c) {
                  continue;
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe
                && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == 'NoTSVRequired'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umShortBarwithCV(TSV2)(00VD867)'){
                      options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                   }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umShortBar(TSV2)(84Y7202)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umShortBar(TSV2)(84Y6145)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '85umShortBar(TSV2)(84Y7823)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umTSV(TWV)(46D7994)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));                                                  
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umTSV(TWV)(56Y8542)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == 'NoTSVRequired'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umShortBar(TSV2)(84Y6145)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '85umShortBar(TSV2)(84Y7823)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umShortBar(TSV2)(84Y7202)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umTSV(TWV)(46D7994)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umTSV(TWV)(56Y8542)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX) && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == 'NoTSVRequired'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umShortBar(84Y6145)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }               
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP) && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == 'NoTSVrequested'){  
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umTSV(70Y8337)(TSV2)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.IPD5PAE && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == 'NoTSVrequested'){  
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '100umTSV(56Y8542)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umTSV(46D7994)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4){
                    if(fmsTab.DB_Value__c == 'No TSV required'){  
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c == '100um Short Bar (TSV2) (00VE000)'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
            }
        }

        return options;
    }
    
    public List<SelectOption> getNumThickLevelsList(){
        List<SelectOption> tempList = new List<SelectOption>();  
        Set<String> thickLevelSet = new Set<String>();
        
           if(formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF){
           tempList.add(new SelectOption('', FMS_SELECT_VAL));
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Num Thick Cu Levels'){
                    if(fmsTab.is_InActive__c && formObj.NumThickCuLevels__c != fmsTab.DB_Value__c) {
                      continue;
                    }
                    if((formObj.NumMetalLayers__c == '7' || formObj.NumMetalLayers__c == '8') && fmsTab.DB_Value__c.deleteWhitespace() == '3-LMFinalWirelevel(45L8957)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if((formObj.NumMetalLayers__c == '6' || formObj.NumMetalLayers__c == '7' || formObj.NumMetalLayers__c == '8') && fmsTab.DB_Value__c.deleteWhitespace() == '1-MAFinalWirelevel(70P7912)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if((formObj.NumMetalLayers__c == '7' || formObj.NumMetalLayers__c == '8') && fmsTab.DB_Value__c.deleteWhitespace() == '2-MAFinalWirelevel(70P7913)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(formObj.NumMetalLayers__c == '7'&& fmsTab.DB_Value__c.deleteWhitespace() == '1-AMFinalWirelevel(56Y9981)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(formObj.NumMetalLayers__c == '8' && fmsTab.DB_Value__c.deleteWhitespace() == '2-OLLDFinalWiringlevels(42K7667)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '2-LMFinalWirelevel(45L8956)' || fmsTab.DB_Value__c.deleteWhitespace() == '1-OLLDFinalWiringlevels(42K7666)'){
                        tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }   
                }
            }
        }
        return tempList;
    }
    
    public void renderNumThickLevel(){
        if(formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF){
            dispNumThickLevels = true;
        }else{
            dispNumThickLevels = false;
        }
    }

    public List<SelectOption> getPassivationList(){
        List<SelectOption> tempList = new List<SelectOption>(); 
         tempList.add(new SelectOption('', FMS_SELECT_VAL));
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Passivation'){
                if(fmsTab.is_InActive__c && formObj.Passivation__c != fmsTab.DB_Value__c) {
                  continue;
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6SF && (fmsTab.DB_Value__c == 'LV' || fmsTab.DB_Value__c == 'YV')){
                    tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }else{
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.X32SOI && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == 'XK-TD-FV'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.X32SOI && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    } 
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(LVdrawn)(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV-NoPolyimide(LVdrawn)(39N3035)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && fmsTab.DB_Value__c.deleteWhitespace() == 'LV-NoPolyimide(48J7330)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX)){                      
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(LVdrawn)(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)) && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if((formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)) && fmsTab.DB_Value__c.deleteWhitespace() == 'SZ(NoPolyimide)(LVdrawn)(84Y6986)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'RZ(NoPolyimide)(LVdrawn)(84Y6897)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL){
                        if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }else if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA){
                        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){
                            if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes'){
                            if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No'){
                            if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'){
                            if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'RZ(NoPolyimide)(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' && formObj.IntConBumpSource__c == 'Yes'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }else if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && (fmsTab.DB_Value__c.deleteWhitespace() == 'SZ(NoPolyimide)(LVdrawn)(84Y6986)' || 
                            fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)') && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){   
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.LastMetalUsed__c != 'LD (Three Thick Wires)' 
                            && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.LastMetalUsed__c != 'LD (Three Thick Wires)' 
                            && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }   
                        if((formObj.Chip_Interconnect__c == UtilityCls.Wirebond || formObj.Chip_Interconnect__c == UtilityCls.C4flipchip)
                            && formObj.LastMetalUsed__c == 'LD (Three Thick Wires)' && fmsTab.DB_Value__c.deleteWhitespace() == 'FV-Polyimideonly(DVdrawn)(84Y8379)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 
                            && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.LastMetalUsed__c != 'LD (Three Thick Wires)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond 
                            && formObj.LastMetalUsed__c != 'LD (Three Thick Wires)' && fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }   
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){ 
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c == 'DV (29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c == 'LV (01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'){
                            if(fmsTab.DB_Value__c == 'RZ-No Polyimide (DV drawn) (84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c == 'SZ - No Polyimide (LV drawn) (84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }   
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' ){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){ 
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){ 
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMHV7SF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.Chip_Interconnect__c != UtilityCls.CopperPillar && formObj.LastMetalUsed__c != 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.Chip_Interconnect__c != UtilityCls.CopperPillar && formObj.LastMetalUsed__c != 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.LastMetalUsed__c != 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-WirebondwithoutPolyimide'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.LastMetalUsed__c != 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-C4withoutPolyimide'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ(NoPolyimide)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.LastMetalUsed__c == 'C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_10LP){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_10LPe){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(withPSPI)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_10RFe){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(withPSPI)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip ){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    system.debug('UtilityCls.CMOS_10SF==>'+UtilityCls.CMOS_10SF + '-' +formObj.Technology__c +'-'+fmsTab.Technology__c);
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_10SF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV-NoPolyimide(39N3035)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV-NoPolyimide(48J7330)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6SF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV' || fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV' || fmsTab.DB_Value__c.deleteWhitespace() == 'YV'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV-FV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF){
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.LastMetalUsed__c != 'MZ' && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(((formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039) || (formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.C4flipchip))) && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.LastMetalUsed__c == 'MZ' && fmsTab.DB_Value__c.deleteWhitespace() == 'TV(01L6999)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.LastMetalUsed__c != 'MZ' && fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.C4flipchip) && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-C4withoutPolyimide(LVdrawn)(84Y6986)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.CopperPillar) && fmsTab.DB_Value__c.deleteWhitespace() == 'SZ(NoPolyimide)(LVdrawn)(84Y6986)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG){
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.LastMetalUsed__c != 'MZ'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }                       
                        if((formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039) || (formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.C4flipchip))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.LastMetalUsed__c == 'MZ'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV(01L6999)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.LastMetalUsed__c != 'MZ'){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.C4flipchip) && formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.IntConBumpSource__c.deleteWhitespace() == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-C4withoutPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.CopperPillar)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ(NoPolyimide)(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                     
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF){
                        if(formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond) && formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' &&
                        ((formObj.NumThickCuLevels__c.deleteWhitespace() == '1-MAFinalWirelevel(70P7912)' || formObj.NumThickCuLevels__c.deleteWhitespace() == 
                        '2-MAFinalWirelevel(70P7913)') || (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-OLLDFinalWiringlevels(42K7666)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '2-OLLDFinalWiringlevels(42K7667)') || 
                        (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-AMFinalWirelevel(56Y9981)'))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip) && formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' && ((formObj.NumThickCuLevels__c.deleteWhitespace() == '1-MAFinalWirelevel(70P7912)' || formObj.NumThickCuLevels__c.deleteWhitespace() == '2-MAFinalWirelevel(70P7913)') || 
                        (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-OLLDFinalWiringlevels(42K7666)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '2-OLLDFinalWiringlevels(42K7667)') || 
                        (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-AMFinalWirelevel(56Y9981)'))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        
                       if(formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' && (formObj.NumThickCuLevels__c.deleteWhitespace() == '2-LMFinalWirelevel(45L8956)' || formObj.NumThickCuLevels__c.deleteWhitespace() == '3-LMFinalWirelevel(45L8957)')  && 
                        (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip)) {
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV-TD-FV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' && (formObj.NumThickCuLevels__c.deleteWhitespace() == '2-LMFinalWirelevel(45L8956)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '3-LMFinalWirelevel(45L8957)') && formObj.Chip_Interconnect__c.equalsIgnoreCase(UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TV-TD-DV'){

                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }                           
                          
                        if(( formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'
                           && formObj.Chip_Interconnect__c == UtilityCls.Wirebond) && formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' && 
                        (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-MAFinalWirelevel(70P7912)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '2-MAFinalWirelevel(70P7913)' || formObj.NumThickCuLevels__c.deleteWhitespace() == '1-OLLDFinalWiringlevels(42K7666)' || formObj.NumThickCuLevels__c.deleteWhitespace() == '2-OLLDFinalWiringlevels(42K7667)' ||  formObj.NumThickCuLevels__c.deleteWhitespace() == '1-AMFinalWirelevel(56Y9981)')){
                        
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DVwithoutPolyimide' ){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                         if(( formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'
                           && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039) && formObj.NumThickCuLevels__c != null && formObj.NumThickCuLevels__c != '' && 
                        (formObj.NumThickCuLevels__c.deleteWhitespace() == '1-MAFinalWirelevel(70P7912)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '2-MAFinalWirelevel(70P7913)' || 
                        formObj.NumThickCuLevels__c.deleteWhitespace() == '1-OLLDFinalWiringlevels(42K7666)' || formObj.NumThickCuLevels__c.deleteWhitespace() == '2-OLLDFinalWiringlevels(42K7667)' ||  formObj.NumThickCuLevels__c.deleteWhitespace() == '1-AMFinalWirelevel(56Y9981)')){
                        
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LVwithoutPolyimide' ){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }                       
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ(NoPolyimide)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_9RFe){                   
                        if(formObj.IntConBumpSource__c == UtilityCls.No_21L2039 || formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(withPSPI)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }  
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && (formObj.IntConBumpSource__c == UtilityCls.No_21L2039 || formObj.Chip_Interconnect__c == UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(noPSPI)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_9SF){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)' || fmsTab.DB_Value__c.deleteWhitespace() == 'DVNoBuildwithFiberButtConnection(84Y6444)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' || fmsTab.DB_Value__c.deleteWhitespace() == 'LVNoBuildwithFiberButtConnection(84Y6443)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }                       
                    }                   
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7RF && dispPassivation){
                        if(((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' 
                            && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' 
                            && formObj.Packaging_Services__c == 'Yes')) && formObj.Chip_Interconnect__c == UtilityCls.Wirebond 
                            && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                            && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            formObj.Passivation__c = fmsTab.DB_Value__c;
                        }
                        if(((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' 
                            && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' 
                            && formObj.Packaging_Services__c == 'Yes')) && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip 
                            && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                            && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            formObj.Passivation__c = fmsTab.DB_Value__c;
                        }
                        if(((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' 
                            && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes')) 
                            && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP 
                            || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
                            || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                            && fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            formObj.Passivation__c = fmsTab.DB_Value__c;
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)'
                             && fmsTab.DB_Value__c.deleteWhitespace() == 'FV-Polyimideonly(DVdrawn)(84Y8379)') {
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            formObj.Passivation__c = fmsTab.DB_Value__c;
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)'
                             && fmsTab.DB_Value__c.deleteWhitespace() == 'FV-Polyimideonly(LVdrawn)(84Y8379)') {
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            formObj.Passivation__c = fmsTab.DB_Value__c;
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'){
                            if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond 
                                && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
                                || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                                && (fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)' || fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)')){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == 'Yes'  
                                && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
                                || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                                && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                                formObj.Passivation__c = fmsTab.DB_Value__c;
                            }
                            if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || 
                                formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && (fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' || fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)')){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));                             
                            }
                            if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == 'Yes' && 
                            (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || 
                            formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && 
                            fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c)); 
                                formObj.Passivation__c = fmsTab.DB_Value__c;
                            }
                            if((formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && 
                            (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || 
                            formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && (fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' || 
                            fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)')){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));                                     
                            }
                            if((formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 && 
                            formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' && fmsTab.DB_Value__c.deleteWhitespace() == 'FV-Polyimideonly(LVdrawn)(84Y8379)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));  
                                formObj.Passivation__c = fmsTab.DB_Value__c;
                            }   
                            if((formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) && formObj.IntConBumpSource__c == 'Yes' && 
                            (formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || 
                            formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));  
                                formObj.Passivation__c = fmsTab.DB_Value__c;
                            }   
                        }                        
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7SW){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }   
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }   
                        }
            if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar 
                        && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L9668)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }   
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
            if(formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond 
                        && fmsTab.DB_Value__c.deleteWhitespace() == 'RZandDV-WithPolyimide(00VD251)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip) || 
                        (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || 
                        (formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZandLV-WithPolyimide(LVdrawn)(00VD252)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TVandLV-WithPolyimide(LVdrawn)(01XL020)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI_7TF){
                        if(formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV-NoPolyimide'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond || (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039 || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV-NoPolyimide'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.IPD5PAE){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(LVdrawn)(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && ((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes') || 
                        (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' && 
                        formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && 
                        formObj.IntConBumpSource__c == 'Yes'))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(LVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }                          
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.SOI12S0){
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV' || fmsTab.DB_Value__c.deleteWhitespace() == 'TV-TD-FV(TVTDFV)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.SOI7SWT){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
            if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar 
                        && formObj.IntConBumpSource__c == UtilityCls.No_21L2039){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L9668)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZ-NoPolyimide(LVdrawn)(84Y6986)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'RZ-NoPolyimide(DVdrawn)(84Y6897)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
            if(formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond 
                        && fmsTab.DB_Value__c.deleteWhitespace() == 'RZandDV-WithPolyimide(00VD251)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip) || 
                        (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || 
                        (formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)))){
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'SZandLV-WithPolyimide(LVdrawn)(00VD252)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(fmsTab.DB_Value__c.deleteWhitespace() == 'TVandLV-WithPolyimide(LVdrawn)(01XL020)'){
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == '45RFSOI'){                       
                        if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond && (fmsTab.UI_Value__c=='RZ (No Polyimide) (DV drawn) (84Y6897)' || fmsTab.UI_Value__c=='DV (29L5231)')) {
                          tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        else if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)' && formobj.IntConBumpSource__c=='Yes') {
                          tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        else if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.UI_Value__c=='SZ (No Polyimide) (LV drawn) (84Y6986)' && formobj.IntConBumpSource__c=='No(21L2039)') {
                          tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        else if(formObj.Packaging_Services__c != 'No' || formObj.TestServices__c != 'No') {
                          if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c.deleteWhitespace() == 'DV(29L5231)'){ 
                              tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                          }
                          if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && fmsTab.DB_Value__c.deleteWhitespace() == 'LV(01L6998)'){
                              tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                          }
                        }
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CSOI8SW){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'Yes' && fmsTab.UI_Value__c=='DV (29L5231)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'No' && fmsTab.UI_Value__c=='DV (29L5231)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes' && fmsTab.UI_Value__c=='DV (29L5231)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && (fmsTab.UI_Value__c=='RZ - No Polyimide (DV drawn) (84Y6897)' || fmsTab.UI_Value__c=='DV (29L5231)')){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'Yes' && fmsTab.UI_Value__c=='LV (01L6998)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'No' && fmsTab.UI_Value__c=='LV (01L6998)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes' && fmsTab.UI_Value__c=='LV (01L6998)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formobj.IntConBumpSource__c=='Yes' && fmsTab.UI_Value__c=='LV (01L6998)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formobj.IntConBumpSource__c=='No(21L2039)' && (fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)' || fmsTab.UI_Value__c=='LV (01L6998)')){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            
                        }
                        if(formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'Yes'&& fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c == 'No'&& fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes'&& fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formobj.IntConBumpSource__c=='Yes'&& fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)'){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            if(formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No' && formobj.IntConBumpSource__c=='No(21L2039)'&& (fmsTab.UI_Value__c=='SZ - No Polyimide (LV drawn) (84Y6986)' || fmsTab.UI_Value__c=='LV (01L6998)')){ 
                                tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                            }
                            
                        }                      
                    }
                    if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4){
                        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c == 'DV (LV drawn) (29L5231)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond && fmsTab.DB_Value__c == 'RZ (No Polyimide) (LV drawn) (84Y6897)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)) && fmsTab.DB_Value__c == 'LV (01L6998)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                        if((formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c == UtilityCls.No_21L2039)) && fmsTab.DB_Value__c == 'SZ (No Polyimide) (LV drawn) (84Y6986)'){
                            tempList.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        }
                    }
                }
            }
        }
     
        if(tempList.size() == 2){
            tempList.remove(0);
      SelectOption opt = tempList[0];
            formObj.Passivation__c = opt.getValue();
        }
        return tempList;
    }
    
    public void renderPassivation(){
        if(formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || 
        formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.CMOS_10LPe || 
        formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.CMOS_10SF || 
        formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMHV7SF || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.CMOS_9SF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.IPD5PAE || 
        formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.SOI12S0 || formObj.Technology__c == UtilityCls.CMOS_6SF || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == '45RFSOI' ||
        formObj.Technology__c == UtilityCls.X32SOI || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
            dispPassivation = true;
        }else{
            dispPassivation = false;
        }
    }
    
    public void renderPassivation1(){            
       if(formObj.QuoteOnly__c != 'Yes' && formObj.Chip_Interconnect__c == 'Wirebond' && 
        ( 
        ((formObj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formObj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)' || 
        formObj.Technology__c == 'BiCMOS 5PAX (1K5PAXE)' || formObj.Technology__c == 'BiCMOS 5PAX (SiG5PAX)' || formObj.Technology__c == 'IPD5PAE') &&
         formObj.Passivation__c == 'DV (LV drawn) (29L5231)' )
         ||  ((formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' || formObj.Technology__c == 'BiCMOS 8XP (SiGe 8XP)') && formObj.Passivation__c == 'DV (29L5231)')      
        || (formObj.Technology__c == 'BiCMOS5PA4 (HRS5PA4)' && ((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No') || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && formObj.Passivation__c == 'DV (LV drawn) (29L5231)'))))) {
            dispPassivation1 = true;
        } else {
            dispPassivation1 = false;
        }            
    }
    
    public List<SelectOption> getWiringOptionsList(){
        List<SelectOption> options = new List<SelectOption>();  
        
        if(formOBj.Technology__c==UtilityCls.CSOI8SW){
            options.add(new SelectOption('', FMS_SELECT_VAL));
            options.add(new SelectOption('None', 'None'));
            options.add(new SelectOption('M2 (M2, V2) (00VD442)', 'M2 (M2, V2) (00VD442)'));
            options.add(new SelectOption('E1 (E1, E2) (00VD441)', 'E1 (E1, E2) (00VD441)'));
            options.add(new SelectOption('M2 and E1 (M2, V2, E1, E2) (00VD442; 00VD441)', 'M2 and E1 (M2, V2, E1, E2) (00VD442; 00VD441)'));
        }else{
            options.add(new SelectOption('MQ-LQ-LD (42K7664)', 'MQ-LQ-LD (42K7664)'));
            if(formObj.NumMetalLayers__c == '8' || formObj.NumMetalLayers__c == '9'){
                options.add(new SelectOption('MQ-MG-LQ-LD (42K7665)', 'MQ-MG-LQ-LD (42K7665)')); 
            }
            if(formObj.NumMetalLayers__c == '5' || formObj.NumMetalLayers__c == '6' || formObj.NumMetalLayers__c == '7'){
                options.add(new SelectOption('MQ-OL-LD (42K7666)', 'MQ-OL-LD (42K7666)')); 
            }
            if(formObj.NumMetalLayers__c == '8'){
                options.add(new SelectOption('MQ-MG-OL-LD (42K7667)', 'MQ-MG-OL-LD (42K7667)')); 
            }
            if(options.size() > 0){
                options.add(new SelectOption('', FMS_SELECT_VAL));
                options.sort();
            }
        }
        
        
        return options;
    }
    
    public List<SelectOption> getFinalPassivationList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('', FMS_SELECT_VAL));     
        if(formObj.Passivation__c == 'FV - Polyimide only (LV drawn) (84Y8379)'){ 
            options.add(new SelectOption('Yes; 4X FV SHIFT (84Y8783)', 'Yes; 4X FV SHIFT (84Y8783)')); 
        }
        if(formObj.Passivation__c == 'LV (01L6998)'){
            options.add(new SelectOption('Yes; 4X LV SHIFT (84Y8784)', 'Yes; 4X LV SHIFT (84Y8784)')); 
        }
        options.add(new SelectOption('No', 'No')); 
         if(options.size() == 2){
            options.remove(0);
        } 
        return options;
    }
    
    public void renderFinalPassivation(){
        resetDependentFields();
        if(checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11)) { 
            dispFinalPassivation = true;
        } else{
            dispFinalPassivation = false;
        }
        renderLineFront();
    }
    
    public void renderLineFront(){
        resetDependentFields();
        if(checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11)) { 
            dispLineFront = true;
        } else{
            dispLineFront = false;
        }
    }
        
    public void renderTechFeatures(){
        resetDependentFields();
        if(formObj.Custom_Features__c == 'Yes'){
            dispTechFeatures = true;
        }else{
            dispTechFeatures = false;
        }
        renderFinalPassivation();
    }
    
    public void renderNotMfgFeaturesDesc(){
        resetDependentFields();
        if(formObj.NotMfgFeatures__c == 'Yes'){
            dispNotMfgFeaturesDesc = true;
        }else{
            dispNotMfgFeaturesDesc = false;
        }
    }
    
    public void renderStepPlanCustomReq(){
        if((formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes') && (formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7RF || 
        formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.SOI7SWT || 
        formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
        formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c ==  UtilityCls.CSOI8SW ||
        formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == '45RFSOI' || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
            dispStepPlanCustReq = true;
        }else{
            dispStepPlanCustReq = false;
        }
    }
    
    public List<SelectOption> getDataCheckOptionsList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.DataCheckingOptions__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();     
        options.add(new SelectOption('', FMS_SELECT_VAL));        
        if(((formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || 
        formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
        formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL ||formObj.Technology__c ==  UtilityCls.CSOI8SW) && 
        (!((formObj.TestServices__c == 'Yes' || formObj.Packaging_Services__c == 'Yes') && (formObj.Technology__c == '' || 
        formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || 
        formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || 
        formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || 
        formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CMOS_6SF || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c ==  UtilityCls.CSOI8SW || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe)))) || (formObj.StepPlanCustomRequirement1__c == 'Yes' && 
        !(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes') && !(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes') && 
        (formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == '' || 
        formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
        formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || 
        formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
        formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == '45RFSOI' || formObj.Technology__c ==  UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)) || ((formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL ||formObj.Technology__c == '45RFSOI' || formObj.Technology__c ==  UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && 
        formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No')){
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.Technology__c == 'All' && fmsTab.DB_Value__c == 'MFG-Only'){
                    for(Schema.PicklistEntry f : ple){
                        if(f.getValue() == 'MFG-Only'){
                            options.add(new SelectOption(f.getValue(), fmsTab.UI_Value__c));
                        }
                    }  
                }
            }               
        } else if((formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || 
        formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.CMOS_6SF) || 
        ((formObj.Technology__c == UtilityCls.IPD5PAE || formObj.Technology__c == UtilityCls.CSOI_7RF || formObj.Technology__c == '' || formObj.Technology__c == UtilityCls.CMHV7SF || 
        formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || 
        formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.CSOI_7SW || 
        formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || 
        formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || 
        formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == '45RFSOI' || formObj.Technology__c ==  UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) && 
        ((formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes') || (formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes') || 
        (formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No' && (formObj.StepPlanCustomRequirement1__c == 'No' || formObj.StepPlanCustomRequirement1__c == '' || formObj.StepPlanCustomRequirement1__c == null))))){
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.Technology__c == 'All' && fmsTab.DB_Value__c == 'Full'){
                    for( Schema.PicklistEntry f : ple){
                        if(f.getValue() == 'Full'){
                            options.add(new SelectOption(f.getLabel(), fmsTab.UI_Value__c));
                        }
                    }  
                }
            }              
        }
        return options;
    }
    
    public void renderDataCheckingOpts(){
        if(formObj.Technology__c == UtilityCls.X32SOI || formObj.Technology__c == UtilityCls.CNV8SFi || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_9SF || formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe || formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.SOI12S0 || formObj.Technology__c == UtilityCls.BiMOS_P6 || formObj.Technology__c == UtilityCls.BMSP6C9){
            dispDataCheckingOpts = false;
        }else{
            dispDataCheckingOpts = true;
        }
    }
    
    public List<SelectOption> getServiceOptionsList(){
            
        List<SelectOption> options = new List<SelectOption>();           
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.ServiceOptions__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == UtilityCls.Dicing || f.getValue() == 'Other'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else if(f.getValue() == 'Backside Grind'){
                if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.Packaging_Services__c == 'No'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
            else if(f.getValue() == 'Wafer Thermal Cycle' && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO2) && (formObj.ServiceOptions__c != null && (formObj.ServiceOptions__c.contains('Wafer Thermal Cycle')))){     
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            else if(f.getValue() == 'None'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }        
        return options;        
    }
    
    public void renderotherServiceFeatures(){
        resetDependentFields();
        if(selServiceOptions != null && !selServiceOptions.isEmpty()){
            Set<String> sOpt1 = new Set<String>();
            sOpt1.addAll(selServiceOptions);
            if(sOpt1.contains('Other') && formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c != '--None--'){
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
        if((formObj.Packaging_Services__c == 'Yes' || selOpt.contains(UtilityCls.Dicing)) && (formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.SOI7SWT || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CSOI_7RF || 
        formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || 
        formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || 
        formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || 
        formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == '45RFSOI' || formObj.Technology__c ==  UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
            dispChipEdgeDesign = true;
        }else{
            dispChipEdgeDesign = false;
        }
    }
    
    public List<SelectOption> getDeliverablesList(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> selOpt = new Set<String>();
        selOpt.addAll(selServiceOptions);
        options.add(new SelectOption('', FMS_SELECT_VAL));
        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes' && !selOpt.contains(UtilityCls.Dicing)){
            selServiceOptions.add(UtilityCls.Dicing);
            selOpt.add(UtilityCls.Dicing);
        }
        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && !selOpt.contains(UtilityCls.Dicing)){
            options.add(new SelectOption('Untested Wafer', 'Untested Wafer'));     
            formObj.Deliverable__c = 'Untested Wafer';
        }
        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No' && selOpt.contains(UtilityCls.Dicing)){
            options.add(new SelectOption('Untested Chip', 'Untested Chip'));     
            formObj.Deliverable__c = 'Untested Chip';
        }
        if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'Yes'){
            options.add(new SelectOption('Untested Module', 'Untested Module'));   
            formObj.Deliverable__c = 'Untested Module'; 
        }
        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No' && !selOpt.contains(UtilityCls.Dicing)){
            options.add(new SelectOption('Tested Wafer', 'Tested Wafer'));     
            formObj.Deliverable__c = 'Tested Wafer';
        }
        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'No' && selOpt.contains(UtilityCls.Dicing)){
            options.add(new SelectOption('Tested Chip', 'Tested Chip'));     
            formObj.Deliverable__c = 'Tested Chip';
        }
        if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes' && selOpt.contains(UtilityCls.Dicing)){
            options.add(new SelectOption('Tested Module', 'Tested Module')); 
            formObj.Deliverable__c = 'Tested Module';
        } 
        if(options.size() == 2){
            options.remove(0);
        } 
        return options;
    }

    public List<SelectOption> getDesignSubmissionList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.DesignSubmission__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        options.add(new SelectOption('', FMS_SELECT_VAL));
          
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == UtilityCls.Design_ChipletDesign){
                if(formObj.TestServices__c == 'No' && formObj.Packaging_Services__c == 'No'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }else{
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }     
        if(options.size() == 2){
            options.remove(0);
        }        
        return options;        
    }
           
    public List<SelectOption> getBacksideGrindThicknessList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.BacksideGrindThickness__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        options.add(new SelectOption('', FMS_SELECT_VAL));        
        for(Schema.PicklistEntry f : ple){
                  
            if(f.getValue() == '180 um' && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11) && formObj.BacksideGrindThickness__c == '180 um'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            if(f.getValue() != '180 um'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }       
        if(options.size() == 2){
            options.remove(0);
        }
        return options;   
    }
    
    public void renderBacksideGrindThickness(){
        Set<String> servOptsSet = new Set<String>();
        servOptsSet.addAll(selServiceOptions);
        if(formObj.QuoteOnly__c != 'Yes' && servOptsSet.contains('Backside Grind')){
            dispBacksideGrindThickness = true;
        }else{
            dispBacksideGrindThickness = false;
        }
    }
    
    public void renderDeliverableSplit(){
        resetDependentFields();
        if(formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle || formObj.DesignSubmission__c == null || formObj.DesignSubmission__c == ''){
            dispDeliverableSplit = false;
        }else{
            dispDeliverableSplit = true;
        }
        if(formObj.DesignSubmission__c == UtilityCls.Design_SingleChip || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign){
            preMergeReadOnly = true;
        }else{
            preMergeReadOnly = false;
        }
    }
    
    public List<SelectOption> getPreMergeList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.Premerge__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  
        options.add(new SelectOption('', FMS_SELECT_VAL));
        for(Schema.PicklistEntry f : ple){
        
            if((formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign && f.getValue() == 'Yes') ||
               (formObj.DesignSubmission__c == UtilityCls.Design_SingleChip && f.getValue() == 'No')){
                formObj.Premerge__c = f.getValue();
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else if(formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else{
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
        if(options.size() == 2){
            options.remove(0);
        }
        return options;   
    }

    public List<MetalizationWrapper> lstMetalWrapper{get;set;}
    public List<SelectOption> lstMetalOptions {get;set;}
    public pageReference renderMetalizationOption(){
        lstMetalWrapper = new List<MetalizationWrapper>();
        lstMetalOptions = new List<SelectOption>();
        
        for(FMS_Mapping_Table__c fmp: fmsMappingTable){
            if(fmp.Field__c == 'MetalizationOption' && fmp.Technology__c == formObj.Technology__c){
                if((fmp.Chip_Interconnect__c == '' || fmp.Chip_Interconnect__c == NULL) || 
                   (formObj.Chip_Interconnect__c == fmp.Chip_Interconnect__c)){
                        
                   if(fmp.is_InActive__c && formObj.MetallizationOpts__c != fmp.DB_Value__c) {
                        continue;
                   }
                        
                    
                        boolean selectFlag = false;
                        if(formObj.MetallizationOpts__c == fmp.DB_Value__c){
                            selectFlag = true;
                        }
                        lstMetalOptions.add(new SelectOption(fmp.DB_Value__c,fmp.DB_Value__c));
                        MetalizationWrapper metalWrapper = new MetalizationWrapper(fmp.UI_Value__c.split('##')[0],
                                                                                   fmp.UI_Value__c.split('##')[1],
                                                                                   fmp.UI_Value__c.split('##')[2],
                                                                                   fmp.UI_Value__c.split('##')[3],
                                                                                   fmp.DB_Value__c,
                                                                                   selectFlag);
                        lstMetalWrapper.add(metalWrapper);
                }
            }
        }
        if(formObj.MetallizationOpts__c == 'Other'){
            lstMetalWrapper.add(new MetalizationWrapper('Other','','','','Other',true));
            lstMetalOptions.add(new SelectOption('Other','Other'));
        }else{
            lstMetalWrapper.add(new MetalizationWrapper('Other','','','','Other',false));
            lstMetalOptions.add(new SelectOption('Other','Other'));
        }
        return NULL;
    }
    
    public class MetalizationWrapper{
        public string description{get;set;}
        public string totalWiringLvl{get;set;}
        public string lastWiringLvl{get;set;}
        public string featurePartNo{get;set;}
        public string selectedValue{get;set;}
        public boolean isSelected{get;set;}
        
        public MetalizationWrapper(string dscrptn,string ttlWiringLvl,string lstWiringLvl,string ftrPartNo,string selValue,boolean selFlag){
            description = dscrptn;
            totalWiringLvl = ttlWiringLvl;
            lastWiringLvl = lstWiringLvl;
            featurePartNo = ftrPartNo;
            selectedValue = EncodingUtil.urlEncode(selValue,'UTF-8');
            isSelected = selFlag;
        }
    }
    
    public PageReference getSelectedMetalOption(){
        String metDBValue = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('selectedVal'),'UTF-8');
        if(metDBValue != 'Other'){
            formObj.MetallizationOpts__c = metDBValue;
            formObj.OtherMetallization__c = '';
        }else{
            formObj.MetallizationOpts__c = 'Other';
        }
        return null;
    }

    public boolean readOnlyCheckMethod(){
        if(formObj.QuoteOnly__c == 'No' && checkStatesForTFAReadOnly() && isTFACompany){
            return true;
        }
        return false;
    }
    
    public void renderWireBondSplit(){
        if(formObj.QuoteOnly__c == 'Yes' || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote) || 
        (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))){
            dispWireBondSplit = true;
        }else{
            dispWireBondSplit = false;
        }
    }
    
    public void renderWireBondSplitTAT(){
        if((formObj.QuoteOnly__c == 'Yes' && formObj.WireBondSplit__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote && 
        formObj.WireBondSplit__c == 'Yes') || (checkStatesForTFAReadOnly() && formObj.WireBondSplit__c == 'Yes')){
            dispWireBondSplitTAT = true;
        }else{
            dispWireBondSplitTAT = false;
        }
    }
    
    public void renderC4SplitTAT(){
        if((formObj.QuoteOnly__c == 'Yes' && formObj.C4Split__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote && 
        formObj.C4Split__c == 'Yes') || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes') && formObj.C4Split__c == 'Yes')){
            dispC4SplitTAT = true;
        }else{
            dispC4SplitTAT = false;
        }
    }
    
    public void renderOtherSplitDets(){
        if((formObj.QuoteOnly__c == 'Yes' && formObj.OtherSplits__c == 'Yes') || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote && 
        formObj.OtherSplits__c == 'Yes') || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes') && formObj.OtherSplits__c == 'Yes')){
            dispOtherSplitDepts = true;
        }else{
            dispOtherSplitDepts = false;
        }
    }
    
    public void renderITARCat(){
        if((formObj.QuoteOnly__c == 'Yes'  || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote) || (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))) && formObj.AssetProtectionCode__c != '0'){
            dispITARCategory = true;
        }else{
            dispITARCategory = false;
        }
    }
    
    public void renderClientResponseDt(){
        if(formObj.QuoteOnly__c == 'Yes'  || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote) || 
        (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes')) && isTFACompany){
            dispClientResponseDt = true;
        }else{
            dispClientResponseDt = false;
        }
    }
    
    public void renderNeedBizComment(){
        if((formObj.QuoteOnly__c == 'Yes' && isTFACompany) || (formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote) || 
        (checkStatesForTFAReadOnly() && (formObj.WireBondSplit__c == 'No' || formObj.WireBondSplit__c == 'Yes'))){
            dispNeedBizComment = true;
        }else{
            dispNeedBizComment = false;
        }
    }   

    public List<SelectOption> getNeedBizCommentList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('', FMS_SELECT_VAL));
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
       return options;        
    }
    
    public void renderNumOfDesigns(){
        if(formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle){
            dispNumOfDesigns = true;
        }else{
            dispNumOfDesigns = false;
        }
    }
    
    public void renderMaxChipPower(){
        if(formObj.Packaging_Services__c == 'Yes' && formObj.Technology__c != '--None--'){
            dispMaxChipPower = true;
        }else{
            dispMaxChipPower = false;
        }   
    }
    
    public List<SelectOption> getChamferedCornersList(){ 
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.ChamferedCorner__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  
        options.add(new SelectOption('', FMS_SELECT_VAL));        
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == '125um' && formObj.Technology__c != UtilityCls.CMOS_10LPe && formObj.Technology__c != UtilityCls.CMOS_10RFe){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getValue() == '74um' && (formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.CMOS_10LPe)){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getValue() == 'No'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }   
        if(options.size() == 2){
            options.remove(0);
        }
        return options;
    }
    
    public void renderChamferedCorner(){
        if(formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.SOI12S0 || formObj.Technology__c == '45RFSOI'){ 
            dispChamferedCorner = true;
        }else{
            dispChamferedCorner = false;
        }
    }
    
    public List<SelectOption> getC4PadLayoutList(){
        List<SelectOption> options = new List<SelectOption>();   
        options.add(new SelectOption('', FMS_SELECT_VAL));         
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Pad Layout'){
                if(fmsTab.is_InActive__c && formObj.C4PadLayout__c != fmsTab.DB_Value__c) {
                  continue;
                }
                
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
                    formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT|| formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
                    if(fmsTab.UI_Value__c == '3 on 6 (prior approval required)' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.Technology__c != UtilityCls.CMHV7SF && formObj.Technology__c != UtilityCls.CMOS_7TG_CMRF7TG){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '3 on 6' && fmsTab.UI_Value__c != '3 on 6 (prior approval required)' && (formObj.Chip_Interconnect__c == UtilityCls.CopperPillar)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.Technology__c !=UtilityCls.CMOS_8RF_CMRF8SF){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == 'Other' ){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.X32SOI && (fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == 'Other' || fmsTab.DB_Value__c.deleteWhitespace() == '185umminimum')){
                    options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || 
                formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
                formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.IPD5PAE)){
                    if(fmsTab.DB_Value__c == '4 on 8' || fmsTab.DB_Value__c == '4 on 9' || fmsTab.DB_Value__c == '5 on 10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                        
                    }else if((fmsTab.DB_Value__c == '5 on 10' || fmsTab.DB_Value__c == '5 on 9') && formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF){
                           
                       options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CSOI_7RF)){
                    
                    if(fmsTab.UI_Value__c == '3 on 6 (prior approval required)' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){                     
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '3 on 6' && fmsTab.UI_Value__c != '3 on 6 (prior approval required)' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '350um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '400um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '500um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe || 
                formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF)){
                    if((fmsTab.DB_Value__c.deleteWhitespace() == '3on6' && fmsTab.UI_Value__c == '3 on 6 (prior approval)') || fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formObj.Technology__c == UtilityCls.CNV8SFi)){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '4.5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if((fmsTab.DB_Value__c.deleteWhitespace() == '4.5on10' || fmsTab.DB_Value__c.deleteWhitespace() == '5on9') && formObj.Technology__c == UtilityCls.CNV8SFi){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6SF){
                    if(fmsTab.UI_Value__c.deleteWhitespace() == '4on8(priorapproval)' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '4.5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c &&  formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF){
                    if(fmsTab.DB_Value__c == '3 on 6' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_9SF)){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '3on6' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.SOI12S0){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == '185umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == '200umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == 'NoC4bonding' || fmsTab.DB_Value__c.deleteWhitespace() == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == '45RFSOI'){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == 'NoC4bonding' || fmsTab.DB_Value__c.deleteWhitespace() == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
            }
        }

        return options;        
    }
    
    public void renderCircuitType(){
        if(formObj.Packaging_Services__c == 'Yes' && formObj.TestServices__c != 'Yes' && (formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != '--None--' && formObj.Technology__c != UtilityCls.BMSP6C9)){
            dispCircuitType = true;
        }else {
            dispCircuitType = false;
        }
    }
    
    public void renderC4PadLayout(){
        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP){
            dispC4PadLayout = true;
        }else{
            dispC4PadLayout = false;
        }
    }
    
    public void renderOtherC4PadLayout(){
        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) && formObj.C4PadLayout__c == 'Other'){
            dispOtherC4PadLayout = true;
        }else{
            dispOtherC4PadLayout = false;
        }
    }   
    
    public List<SelectOption> getC4PadLayoutForDRCList(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('', FMS_SELECT_VAL));            
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            
            if(fmsTab.Field__c == 'DRC Pad Layout'){
                if(fmsTab.is_InActive__c && formObj.C4PadLayoutForDRC__c != fmsTab.DB_Value__c) {
                  continue;
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formObj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
                    formObj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formObj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formObj.Technology__c == UtilityCls.CSOI_7SW || formObj.Technology__c == UtilityCls.SOI7SWT || formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4)){
                   if(fmsTab.DB_Value__c == '3 on 6' && (formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.Technology__c != UtilityCls.CMHV7SF && formObj.Technology__c != UtilityCls.CMOS_7TG_CMRF7TG)))
                    {     
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.X32SOI && (fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == '185umminimum')){
                    options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                } 
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formObj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || 
                formObj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formObj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
                formObj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formObj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || formObj.Technology__c == UtilityCls.CSOI_7TF || formObj.Technology__c == UtilityCls.IPD5PAE)){
                    if(fmsTab.DB_Value__c == '4 on 8' || fmsTab.DB_Value__c == '4 on 9' || fmsTab.DB_Value__c == '5 on 10'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c.deleteWhitespace() == '5on9' && formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CSOI_7RF)){
                    if(fmsTab.UI_Value__c == '3 on 6 (prior approval required)' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '3 on 6' && fmsTab.UI_Value__c != '3 on 6 (prior approval required)' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '350um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '400um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '500um' && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == 'Other' && formObj.Chip_Interconnect__c == UtilityCls.Wirebond){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe || 
                formObj.Technology__c == UtilityCls.CMOS_10RFe || formObj.Technology__c == UtilityCls.CMOS_10SF)){
                    if((fmsTab.DB_Value__c.deleteWhitespace() == '3on6' && fmsTab.UI_Value__c == '3 on 6 (prior approval)') || fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10' || fmsTab.DB_Value__c == 'Other'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF  || formObj.Technology__c == UtilityCls.CNV8SFi)){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '4.5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if((fmsTab.DB_Value__c.deleteWhitespace() == '4.5on10' || fmsTab.DB_Value__c.deleteWhitespace() == '5on9') && formObj.Technology__c == UtilityCls.CNV8SFi){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.CMOS_6SF){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '4.5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on9' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c &&  formObj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF){
                    if(fmsTab.DB_Value__c == '3 on 6' && formObj.Chip_Interconnect__c == UtilityCls.CopperPillar){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 8' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '4 on 9' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }else if(fmsTab.DB_Value__c == '5 on 10' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && (formObj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_9SF)){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '4on8' || fmsTab.DB_Value__c.deleteWhitespace() == '4on9' || fmsTab.DB_Value__c.deleteWhitespace() == '3on6' || fmsTab.DB_Value__c.deleteWhitespace() == '5on10'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == UtilityCls.SOI12S0){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == '185umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == '200umminimum' || fmsTab.DB_Value__c.deleteWhitespace() == 'NoC4bonding'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
                if(fmsTab.Technology__c == formObj.Technology__c && formObj.Technology__c == '45RFSOI'){
                    if(fmsTab.DB_Value__c.deleteWhitespace() == '150umminimum'  || fmsTab.DB_Value__c.deleteWhitespace() == 'NoC4bonding'){
                        options.add(new SelectOption(fmsTab.DB_Value__c, fmsTab.UI_Value__c));
                    }
                }
            }
        }
        if(options.size() == 2){
          options.remove(0);
       }
        
        return options;        
    }            
    
    public void renderC4PadLayoutForDRC(){
        resetDependentFields();
        if(formObj.C4PadLayout__c == 'Other' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP)){
            dispC4PadLayoutForDRC = true;
        }else{
            dispC4PadLayoutForDRC = false;
        }
        renderOtherC4PadLayout();
    }
    
    public void renderNumC4Pads(){
        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.IntConBumpSource__c != UtilityCls.No_21L2039){
            dispNumC4Pads = true;
        }else{
            dispNumC4Pads = false;
        }
    }
    
    public List<SelectOption> getC4SolderMaterialList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', FMS_SELECT_VAL)); 
        if(formobj.Technology__c != UtilityCls.SOI7SWT && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_SiG5PAX && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_1K5PAXE && 
        formobj.Technology__c != UtilityCls.BiCMOS_9HP_SiGe_9HP && formobj.Technology__c != UtilityCls.CMOS_9SF && formobj.Technology__c != UtilityCls.BiCMOS_8HP_SiGe_8HP && 
        formobj.Technology__c != UtilityCls.IPD5PAE && formobj.Technology__c != UtilityCls.BiCMOS_5PAe_SiGe_5PAe && formobj.Technology__c != UtilityCls.BiCMOS_5PAe_1KW5PAe && 
        formobj.Technology__c != UtilityCls.CSOI_7RF && formobj.Technology__c != UtilityCls.BiCMOS_8XP_SiGe_8XP && formobj.Technology__c != '--None--' && 
        formobj.Technology__c != UtilityCls.BiCMOS_5HPE_SiGe_5HPE && formobj.Technology__c != UtilityCls.BiCMOS_6WL_SiGe_6WL && formobj.Technology__c != UtilityCls.BiCMOS_7WL_SiGe_7WL && 
        formobj.Technology__c != UtilityCls.BiCMOS_8WL_SiGe_8WL && formobj.Technology__c != UtilityCls.CMHV7SF && formobj.Technology__c != UtilityCls.CMOS_6RF_CMRF6SF && 
        formobj.Technology__c != UtilityCls.CMOS_6SF && formobj.Technology__c != UtilityCls.CMOS_7RF_CMRF7SF && formobj.Technology__c != UtilityCls.CMOS_7TG_CMRF7TG && 
        formobj.Technology__c != UtilityCls.CMOS_8RF_CMRF8SF && formobj.Technology__c != UtilityCls.CMOS_9LP_CMOS_9RF && formobj.Technology__c != UtilityCls.CMOS_9RFe && 
        formobj.Technology__c != UtilityCls.CNV8SFi && formobj.Technology__c != UtilityCls.CSOI_7TF && formobj.Technology__c != UtilityCls.CSOI_7SW && formobj.Technology__c != UtilityCls.CMS90WG_CMOS9WG && 
        formobj.Technology__c != UtilityCls.BiCMOS_7PA_SiGe_7PA && formobj.Technology__c != UtilityCls.CMOS_10LP && formobj.Technology__c != UtilityCls.CMOS_10LPe && 
        formobj.Technology__c != UtilityCls.CMOS_10RFe && formobj.Technology__c != UtilityCls.CMOS_10SF && formobj.Technology__c != UtilityCls.SOI12S0 && formobj.Technology__c != UtilityCls.X32SOI
        && formobj.Technology__c != '45RFSOI' && formObj.Technology__c != UtilityCls.CSOI8SW && formObj.Technology__c != UtilityCls.BiCMOS5PA4_HRS5PA4){
            options.add(new SelectOption('Standard HTS Bump', 'Standard HTS Bump'));      
        }
        if(formobj.Technology__c != UtilityCls.BiCMOS_5PAX_SiG5PAX && formobj.Technology__c != UtilityCls.SOI7SWT && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_1K5PAXE && 
        formobj.Technology__c != UtilityCls.BiCMOS_9HP_SiGe_9HP && formobj.Technology__c != UtilityCls.BiCMOS_8HP_SiGe_8HP && formobj.Technology__c != UtilityCls.IPD5PAE && 
        formobj.Technology__c != UtilityCls.BiCMOS_5PAe_SiGe_5PAe && formobj.Technology__c != UtilityCls.BiCMOS_5PAe_1KW5PAe && formobj.Technology__c != UtilityCls.CSOI_7RF && 
        formobj.Technology__c != UtilityCls.BiCMOS_8XP_SiGe_8XP && formobj.Technology__c != UtilityCls.BiCMOS_5HPE_SiGe_5HPE && formobj.Technology__c != '--None--' && 
        formobj.Technology__c != UtilityCls.BiCMOS_6WL_SiGe_6WL && formobj.Technology__c != UtilityCls.BiCMOS_7WL_SiGe_7WL && formobj.Technology__c != UtilityCls.BiCMOS_8WL_SiGe_8WL && 
        formobj.Technology__c != UtilityCls.CMHV7SF && formobj.Technology__c != UtilityCls.CMOS_6RF_CMRF6SF && formobj.Technology__c != UtilityCls.CMOS_6SF && 
        formobj.Technology__c != UtilityCls.CMOS_7RF_CMRF7SF && formobj.Technology__c != UtilityCls.CMOS_7TG_CMRF7TG && formobj.Technology__c != UtilityCls.CMOS_8RF_CMRF8SF && 
        formobj.Technology__c != UtilityCls.CMOS_9LP_CMOS_9RF && formobj.Technology__c != UtilityCls.BiCMOS_7PA_SiGe_7PA && formobj.Technology__c != UtilityCls.CMOS_9RFe && 
        formobj.Technology__c != UtilityCls.CNV8SFi && formobj.Technology__c != UtilityCls.CSOI_7TF && formobj.Technology__c != UtilityCls.CSOI_7SW && formobj.Technology__c != UtilityCls.CMS90WG_CMOS9WG && formObj.Technology__c != UtilityCls.CSOI8SW && formObj.Technology__c != UtilityCls.BiCMOS5PA4_HRS5PA4){
            options.add(new SelectOption('Standard PbFree Bump', 'Standard PbFree Bump'));  
        }        
        if(formobj.Technology__c == UtilityCls.CMOS_9SF || formobj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formobj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || 
        formobj.Technology__c == UtilityCls.SOI7SWT || formobj.Technology__c == UtilityCls.IPD5PAE || formobj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || 
        formobj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe || formobj.Technology__c == UtilityCls.CSOI_7RF || formobj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP || 
        formobj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formobj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formobj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || 
        formobj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formobj.Technology__c == UtilityCls.CMHV7SF || formobj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || 
        formobj.Technology__c == UtilityCls.CMOS_6SF || formobj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF || formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || 
        formobj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formobj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF || formobj.Technology__c == UtilityCls.CMOS_9RFe || 
        formobj.Technology__c == UtilityCls.CNV8SFi || formobj.Technology__c == UtilityCls.CSOI_7TF || formobj.Technology__c == UtilityCls.CSOI_7SW || formobj.Technology__c == UtilityCls.CMS90WG_CMOS9WG || 
        formobj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formobj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX || formobj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formobj.Technology__c == '' || (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c != UtilityCls.No_21L2039 && (formObj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4))){
            options.add(new SelectOption('Contracted Vendor C4 (Pb Free) (41K8146)', 'Contracted Vendor C4 (Pb Free) (41K8146)'));      
        }
        if(options.size() == 2){
            options.remove(0);
        }
        return options;
    }
    
    public void renderC4SolderMaterial(){
        if(formObj.Chip_Interconnect__c == UtilityCls.C4flipchip && formObj.IntConBumpSource__c != UtilityCls.No_21L2039){
            dispC4SolderMaterial = true;
        }else{
            dispC4SolderMaterial = false;
        }
    }
    
    public void renderC4LaminatePackage(){
        if((formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar) && formObj.Packaging_Services__c == 'No'){
            dispC4LaminatePackage = true;
        }else{
            dispC4LaminatePackage = false;
        }
    }
    
    public void renderWirebondLayout(){
        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && formObj.Technology__c != UtilityCls.BiMOS_P6 && formObj.Technology__c != '--None--' && formObj.Technology__c != UtilityCls.BMSP6C9){
            dispWirebondLayout = true;
        }else{
            dispWirebondLayout = false;
        }
    }
    
    public void renderWireBondPad(){
        Set<String> servOptsSet = new Set<String>();
        if(formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != ''){
            servOptsSet.addAll(formObj.ServiceOptions__c.split(';'));
        }
        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && (servOptsSet.contains(UtilityCls.Dicing) || formObj.TestServices__c == 'Yes') && formObj.Technology__c != '--None--'){
            dispWirebondPad = true;
        }else{
            dispWirebondPad = false;
        }
    }
    
    public void renderWirebondPadPitch(){
        if(formObj.Chip_Interconnect__c == UtilityCls.Wirebond && (formObj.Packaging_Services__c == 'Yes' || formObj.TestServices__c == 'Yes') && formObj.Technology__c != '--None--'){
            dispWireBondPadPitch = true;
        }else{
            dispWireBondPadPitch = false;
        }
    }
    
    public void renderPinOneID(){
        if(formObj.Packaging_Services__c == 'Yes'){
            dispPinOneID = true;
        }else{
            dispPinOneID = false;
        }
    }
    
    public void renderdesignKitOthers(){
        resetDependentFields();
        if(formObj.IpIdentification__c == 'Yes'){
            dispDesignKitOthers = true;
        }else{
            dispDesignKitOthers = false;
        }
    }
    
    public void renderPickMap(){
        if(formObj.DesignSubmission__c == UtilityCls.Design_SingleChip && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4)){   
            dispPickMap = true;
        }else{
            dispPickMap = false;
        }
    }   
    
    public void renderNeedAdditionalComments(){
        if((formObj.QuoteOnly__c == 'No' && formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote) || !(formObj.QuoteOnly__c == 'Yes' && isTFACompany)){ 
            dispNeedAdditionalComments = true;
        }else{
            dispNeedAdditionalComments = false;
        }
    }

    /**Start -- Added by Abhita for Issue 512**/
    public List<SelectOption> getneedAddCommentsList(){
        List<SelectOption> options = new List<SelectOption>();             
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.NeedAdditionalComments__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){             
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            if(formObj.NeedAdditionalComments__c == '' || formObj.NeedAdditionalComments__c == null){
                formObj.NeedAdditionalComments__c = 'No';
            }
        } 
        
        return options;     
    }
    /**End -- Added by Abhita for Issue 512**/
    public void renderadditionalComments(){
        resetDependentFields();
        if(dispNeedAdditionalComments && formObj.NeedAdditionalComments__c == 'Yes'){
            dispadditionalComments = true;
        }else{
            dispadditionalComments = false;
        }
    }
         
    public PageReference configPage(){
        config = true;
        skipValidation = true;
        return validateSave();
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
    
    public void renderStepPlanSection() {
        
        if( (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No'  
        && servOptsSetPg3.contains(UtilityCls.Dicing) && (formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign 
        || formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) ) 
        || (formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'Yes' && servOptsSetPg3.contains(UtilityCls.Dicing) 
        && formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) 
        || (formObj.Packaging_Services__c == 'Yes' 
        && formObj.TestServices__c == 'No' &&
        formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) || (formObj.Packaging_Services__c == 'Yes' 
        && formObj.TestServices__c == 'Yes' &&
        servOptsSetPg3.contains(UtilityCls.Dicing) && formObj.DesignSubmission__c == UtilityCls.Design_SingleChip) 
        || servOptsSetPg3 == null || servOptsSetPg3.isEmpty()){
            dispStepPlanSection = false; 
            addContTableList.clear();  
        } else {
            dispStepPlanSection = true;
            renderChannelType();
            renderDicingPref();

            if (webRDTSActive == 'TRUE' && (dispChannelType || dispDicingPref)){
                
                if(formobj.StepPlanRotationActive__c == null || formobj.StepPlanRotationActive__c == ''){
                    stepPlanIntegartionFields = FMSDropServiceStepPlanDetails_API.GetTechnologyDefault(formObj.Technology__c);
                    setIntegrationFields (stepPlanIntegartionFields);
                } 
            } else if(webRDTSActive == 'FALSE'){
                displayNotAvailableMsg = false;
            } else {
                displayNotAvailableMsg = false;
            }
        } 
        if((formObj.DesignSubmission__c == UtilityCls.Design_SingleChip || formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle) && formObj.Premerge__c == 'No'){
            stepEdgeReadOnly = true;
        }else{
            stepEdgeReadOnly = false;
        }      
    }

    public void setIntegrationFields (Map<String, String> stepPlanIntegartionFields){

        if(stepPlanIntegartionFields != null && !stepPlanIntegartionFields.isEmpty()){
            formobj.StepPlanRotationActive__c = stepPlanIntegartionFields.get('active');
            formobj.minScribeXVal__c = stepPlanIntegartionFields.get('min_scribe_x');
            formobj.minScribeYVal__c = stepPlanIntegartionFields.get('min_scribe_y');
            formobj.minSpdScribeXVal__c = stepPlanIntegartionFields.get('min_spd_scribe_x');
            formobj.minSpdScribeYVal__c = stepPlanIntegartionFields.get('min_spd_scribe_y');
            formobj.DesignNotch__c = stepPlanIntegartionFields.get('design_notch');
            formobj.minWlcspScribeXVal__c = stepPlanIntegartionFields.get('min_default_wlcsp_scribe_x');
            formobj.minWlcspScribeYVal__c = stepPlanIntegartionFields.get('min_default_wlcsp_scribe_y');
            formobj.StepPlanRotationWlcspEnabled__c = stepPlanIntegartionFields.get('wlcsp_enabled');
            displayNotAvailableMsg = false;
        } else {
            displayNotAvailableMsg = true;
        }
    }
    
    public void renderInputMethod() {
        
        if((formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing)) || ((formObj.Packaging_Services__c == 'Yes' || servOptsSetPg3.contains(UtilityCls.Dicing)) && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle)) {
            dispInputMethod = true;
            if((formObj.Packaging_Services__c == 'Yes'|| formObj.Packaging_Services__c == 'No') && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle && (formObj.InputMethod__c == '' || formObj.InputMethod__c == null)){
                dispStdReticle = true;
            } else {
                dispStdReticle = false;
            }
        } else {
            dispInputMethod = false;
        }
    }
    
    public List<SelectOption> getinputMethodList(){
        List<SelectOption> tempList = new List<SelectOption>(); 

        if(formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing) && formObj.DesignSubmission__c != UtilityCls.Design_MultiReticle){
            tempList.add(new SelectOption('Standard Process: Inputs via Step Plan Design FMS questions', 'Standard Process: Inputs via Step Plan Design FMS questions'));
        }        
        if((formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == 'Yes') && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle){
            tempList.add(new SelectOption('Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment', 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment'));           
        }
        if(formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing)){ 
            tempList.add(new SelectOption('Advanced Process: Inputs via XML file attachment.', 'Advanced Process: Inputs via XML file attachment. Pre-Approval Required'));
        }

        return tempList;       
    }

    public void changeInputMethod() {
        resetDependentFields();
        dispStdReticle = false;
        attWrap.clear();
    }
    
    public void updateFiledetails(){
        
        String uploadedFile = Apexpages.currentPage().getParameters().get('uploadFileId');
        String uploadedFileName = Apexpages.currentPage().getParameters().get('uploadFileName');
        ContentVersion contVersionRec;
        Integer filesize;
        
        if(uploadedFile != null){

            if (formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.') {
                formobj.AdvancedProcessFileAttachment__c = uploadedFile; 
            } else if(formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment'){
                formobj.FileAttachment__c= uploadedFile;
            }

            contVersionRec = [SELECT Id, ContentSize, Title, ContentDocumentId FROM ContentVersion where Id = :uploadedFile];
            contVersionRec.Title = uploadedFileName;
            try {
                update contVersionRec;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'updateFiledetails()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
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
            LinkedEntityId = formObj.Id, 
            ContentDocumentId = contVersionRec.ContentDocumentId, 
            ShareType = 'V', 
            Visibility = 'AllUsers');
            conDocShare.add(ct);
        }
    }
    
    public void updateECCNFiledetails(){
        
        String uploadECCNFile = Apexpages.currentPage().getParameters().get('uploadECCNFileId');
        String uploadECCNFileName = Apexpages.currentPage().getParameters().get('uploadECCNFileName');
        ContentVersion contVersionRec;
        Integer filesize;
        
        if(uploadECCNFile != null){

            if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && (formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle 
                        || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign)) {
                formobj.ECCN_attachmentName__c = uploadECCNFile;        
            }

            contVersionRec = [SELECT Id, ContentSize, Title, ContentDocumentId FROM ContentVersion where Id = :uploadECCNFile];
            contVersionRec.Title = uploadECCNFileName;
            try {
                update contVersionRec;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'updateECCNFiledetails()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            attachementECCNWrapper attWrapInst = new attachementECCNWrapper();
            attWrapInst.attName = uploadECCNFileName;
            attWrapInst.attId = contVersionRec.Id;
            attWrapInst.ContentEDocumentId = contVersionRec.ContentDocumentId;
            filesize = Integer.valueOf(contVersionRec.ContentSize/1024);
            if(filesize>1024) {
                filesize = Integer.valueOf(filesize/1024);
                attWrapInst.attSize = filesize + ' MB';
            } else if(filesize == 0){
                attWrapInst.attSize = contVersionRec.ContentSize + ' Bytes';
            } else {
                attWrapInst.attSize = filesize + ' KB';
            }
            attWrapECCN.add(attWrapInst);
            
            ContentDocumentLink ct = new ContentDocumentLink(
            LinkedEntityId = formObj.Id, 
            ContentDocumentId = contVersionRec.ContentDocumentId, 
            ShareType = 'V', 
            Visibility = 'AllUsers');
            conDocShare.add(ct);
        }
     }
    
     public void deleteAttachment(){
        if(String.isNotBlank(selContentDocId)){
            ContentDocument cDoc = new ContentDocument(id=selContentDocId);
            conDocDelete.add(cDoc);
            if (formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment') {
                 formobj.FileAttachment__c = null;
            } else if(formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.') {
                formobj.AdvancedProcessFileAttachment__c = null;
            }
            attWrap.clear();
        } else if(String.isNotBlank(selContentDocEId)){
            ContentDocument cDoc = new ContentDocument(id=selContentDocEId);
            conDocDelete.add(cDoc);         
            if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && (formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle 
                    || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign)) {
                formobj.ECCN_attachmentName__c = null;      
            }
            attWrapECCN.clear();
        }           
     }
     
    public class attachementWrapper {

        public string attName {get; set; }
        public id attId {get; set; }
        public String ContentDocumentId {get; set; }
        public String attSize {get; set; }
    }
    public class attachementECCNWrapper {

        public string attName {get; set; }
        public id attId {get; set; }
        public String ContentEDocumentId {get; set; }
        public String attSize {get; set; }
    }
    
    public List<SelectOption> getspunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(string s : spleftvalues.keySet()){
            if(s != null && spleftvalues.get(s) != null){
                options.add(new SelectOption(s,spleftvalues.get(s)));
            }
        }
        return options;
    }
 
    public List<SelectOption> getspSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        for(String s : sprightvalues.keySet()){
            if(s != null && sprightvalues.get(s) != null){
                options1.add(new SelectOption(s,sprightvalues.get(s)));
            }
        }
        return options1;
    }
    
    public PageReference spselectclick(){
        sprightselected.clear();
        for(String s : spleftselected){
            if(s=='All') {
                for(String s1 : sprightvalues.keySet()){
                    spleftvalues.put(s1, sporiginalValues.get(s1));
                }
                sprightvalues.clear();
                sprightvalues.put('All','All');
            } else {
                sprightvalues.remove('All');
                spleftvalues.put('All','All');
                sprightvalues.put(s, sporiginalValues.get(s));
            }
            spleftvalues.remove(s);
        }
        return null;
    }
     
    public PageReference spunselectclick(){
        spleftselected.clear();
        for(String s : sprightselected){
            if(s=='All'){
                spleftvalues.put('All','All');
            } else {
                spleftvalues.put(s, sporiginalValues.get(s));
            }
            sprightvalues.remove(s);           
        }
        return null;
    }
    
    public List<AddStepPlanContWrapper> getspaddContTable(){
        addContTableList = new Map<String, AddStepPlanContWrapper>();
        if(!sprightvalues.keySet().isEmpty()){
            if(sprightvalues.containsKey('All')){
                if(accountIds<>NULL && !accountIds.isEmpty()) {
                    if(userList<>NULL && !userList.isEmpty()) {
                        for(User u: userList) {
                            addContTableList.put(u.Id, new AddStepPlanContWrapper(u.Name, u.Contact.Email, u.Id));
                        }
                    }
                } else if(loggedInAccContList<>NULL && !loggedInAccContList.isEmpty()){                   
                    if(loggedInAccContList<>NULL && !loggedInAccContList.isEmpty()){
                        for(User u : loggedInAccContList){
                            //if(u.Name != UserInfo.getName() && u.Email != UserInfo.getUserEmail()){
                                addContTableList.put(u.Id, new AddStepPlanContWrapper(u.Name, u.Contact.Email, u.Id));
                            //}
                        }
                    }
                }
            } else {
                for(User u:[SELECT id, Name, Phone, Email, Contact.Email FROM User WHERE Id IN : sprightvalues.keySet() and IsActive = true order by Name]) {
                    addContTableList.put(u.Id, new AddStepPlanContWrapper(u.Name, u.Contact.Email, u.Id));
                }
            }
        }
        return addContTableList.values();  
    }

    public class RadioButtonWithImage {
        public String chipRotation {get; set;}
        public String chipRotationImage {get; set;}

        public RadioButtonWithImage() {
            this.chipRotation = '';
            this.chipRotationImage = '';
        }
    }

    public List<RadioButtonWithImage> getchipRotationList() {
        List<RadioButtonWithImage> options = new List<RadioButtonWithImage>();
        
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.StepPlanChipRotation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){   
            RadioButtonWithImage obj = new RadioButtonWithImage(); 
            obj.chipRotation = f.getLabel();
            obj.chipRotationImage = 'FMS_SP_Images/' + f.getValue() +'.png';
            options.add(obj);
        }
        return options;
    }

    public pageReference chipRotationValues(){
        formobj.StepPlanChipRotation__c = selChipValue;
        return null;
    }
    
    public void renderCrackOptions(){
        if(formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing)){
            if (checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4) && formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG){
                dispCrackOptions = true;
            } else if(formobj.Technology__c != UtilityCls.CSOI8SW && formObj.Technology__c != UtilityCls.BiCMOS5PA4_HRS5PA4 && formobj.Technology__c != UtilityCls.BiCMOS_8XP_SiGe_8XP && formobj.Technology__c != UtilityCls.BiCMOS_9HP_SiGe_9HP && formobj.Technology__c != 'CSOI 7SW' && formobj.Technology__c != UtilityCls.CMS90WG_CMOS9WG && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_1K5PAXE && formobj.Technology__c != UtilityCls.BiCMOS_5PAX_SiG5PAX && formobj.Technology__c != UtilityCls.SOI7SWT && formobj.Technology__c != UtilityCls.X32SOI && formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9' && formobj.Technology__c != 'BiCMOS 7PA (SiGe 7PA)' && formobj.Technology__c != '45RFSOI'){// && !checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4)){
                dispCrackOptions = true;
            } else {
                dispCrackOptions = false;
            }
        } else { 
            dispCrackOptions = false; 
        }
    }

    public List<SelectOption> getCrackstopOptList(){
        List<SelectOption> options = new List<SelectOption>();   
        options.add(new SelectOption('', FMS_SELECT_VAL));           
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.CrackstopOptions__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){
            if(f.getLabel() == 'Enhanced Crackstop methodology Pcell: GUARDEDGE layer utilized in GDS (84Y7710)'
                && (formobj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formobj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)'
                || formobj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formobj.Technology__c == 'CMOS 7TG (CMRF7TG)'
                || formobj.Technology__c == 'CSOI 7RF' ||formobj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)'
                || formobj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || formobj.Technology__c == 'CMOS 9LP (CMOS 9RF)')){
                //&& !checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4)){----Modified the code for Prod Issue #51---
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            if(f.getLabel() == 'Legacy Crackstop methodology: GLOBALFOUNDRIES will add a Crackstop'
                && (formobj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formobj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)'
                || formobj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formobj.Technology__c == 'CMOS 7TG (CMRF7TG)'
                || formobj.Technology__c == 'CSOI 7RF' || formobj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)'
                || formobj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || formobj.Technology__c == 'CMOS 9LP (CMOS 9RF)'
                || formobj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formobj.Technology__c == 'IPD5PAE'
                || formobj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formobj.Technology__c == 'CMOS 6RF (CMRF6SF)'
                || formobj.Technology__c == 'CMOS 6SF' || formobj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)'
                || formobj.Technology__c == 'CMHV7SF' || formobj.Technology__c == 'CSOI 7TF'
                || formobj.Technology__c == 'CMOS 8RF (CMRF8SF)' || formobj.Technology__c == 'CNV8SFi'
                || formobj.Technology__c == 'CMOS 9RFe' || formobj.Technology__c == 'CMOS 10LPe'
                || formobj.Technology__c == 'CMOS 10LP' || formobj.Technology__c == 'CMOS 9SF'
                || formobj.Technology__c == 'CMOS 10RFe' || formobj.Technology__c == 'CMOS 10SF'
                || formobj.Technology__c == 'SOI12S0' || formobj.Technology__c == '45RFSOI')){
                //&& !checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4)){----Modified the code for Prod Issue #51---
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getLabel() == 'Legacy Crackstop methodology: Do not add the GLOBALFOUNDRIES Crackstop (84Y6905)'
                && (formobj.Technology__c == 'BiCMOS 5PAe (SiGe 5PAe)' || formobj.Technology__c == 'BiCMOS 5PAe (1KW5PAe)'
                || formobj.Technology__c == 'CMOS 7RF (CMRF7SF)' || formobj.Technology__c == 'CMOS 7TG (CMRF7TG)'
                || formobj.Technology__c == 'CSOI 7RF' || formobj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)'
                || formobj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || formobj.Technology__c == 'CMOS 9LP (CMOS 9RF)'
                || formobj.Technology__c == 'BiCMOS 5HPE (SiGe 5HPE)' || formobj.Technology__c == 'IPD5PAE'
                || formobj.Technology__c == 'BiCMOS 6WL (SiGe 6WL)' || formobj.Technology__c == 'CMOS 6RF (CMRF6SF)'
                || formobj.Technology__c == 'CMOS 6SF' || formobj.Technology__c == 'BiCMOS 7WL (SiGe 7WL)'
                || formobj.Technology__c == 'CMHV7SF' || formobj.Technology__c == 'CMOS 8RF (CMRF8SF)')){
                //&& !checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, FMS_SAP_ACC_NO4)){----Modified the code for Prod Issue #51---
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getLabel() == 'Legacy Crackstop methodology: Passivated Crackstop (56Y8510)'
                && formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO4)) { 
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        if(options.size() == 2){
            options.remove(0);
        }
        return options;     
    }
    
    public void renderChannelType() {
        
        if((formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing)) 
            && (formobj.Technology__c == UtilityCls.CSOI_7SW || formobj.Technology__c == UtilityCls.BiCMOS_5PAe_SiGe_5PAe || formobj.Technology__c == UtilityCls.BiCMOS_5PAe_1KW5PAe 
            || formobj.Technology__c == UtilityCls.IPD5PAE || formobj.Technology__c == UtilityCls.BiCMOS_5PAX_1K5PAXE || formobj.Technology__c == UtilityCls.BiCMOS_5PAX_SiG5PAX 
            || formobj.Technology__c == UtilityCls.BiCMOS_6WL_SiGe_6WL || formobj.Technology__c == UtilityCls.CMOS_6RF_CMRF6SF || formobj.Technology__c == UtilityCls.CMOS_6SF 
            || formobj.Technology__c == UtilityCls.BiCMOS_7WL_SiGe_7WL || formobj.Technology__c == UtilityCls.CMHV7SF || formobj.Technology__c == UtilityCls.CMOS_7RF_CMRF7SF 
            || formobj.Technology__c == UtilityCls.CMOS_7TG_CMRF7TG || formobj.Technology__c == UtilityCls.CSOI_7RF || formobj.Technology__c == UtilityCls.CSOI_7SW 
            || formobj.Technology__c == UtilityCls.SOI7SWT || formobj.Technology__c == UtilityCls.CSOI_7TF || formobj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL 
            || formobj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF || formobj.Technology__c == UtilityCls.BiCMOS_7PA_SiGe_7PA || formobj.Technology__c == 'BiMOS P6' || formobj.Technology__c == 'BMSP6C9'
            || formobj.Technology__c == UtilityCls.BiCMOS_5HPE_SiGe_5HPE || formobj.Technology__c == UtilityCls.CSOI8SW || formObj.Technology__c == UtilityCls.BiCMOS5PA4_HRS5PA4) ) {
                dispChannelType = true;
        } else {
            dispChannelType = false;
        }
    }
     
    public List<SelectOption> getchannelTypeList(){
        List<SelectOption> tempList = new List<SelectOption>(); 
        tempList.add(new SelectOption('', FMS_SELECT_VAL)); 
        
        String op1 = 'Std channels; GLOBALFOUNDRIES-sourced WLCSP; Minimum width allowed X = ' + formobj.minWlcspScribeXVal__c + ' Y = ' + formobj.minWlcspScribeYVal__c; 
        String op2 = 'Standard channels; Minimum width allowed X = ' + formobj.minScribeXVal__c + ' Y = ' + formobj.minScribeYVal__c;
        String op3 = 'SPD channels; Minimum width allowed X = ' + formobj.minSpdScribeXVal__c + ' Y = ' + formobj.minSpdScribeYVal__c;       
        String op4 = 'SPD channels; GLOBALFOUNDRIES-sourced WLCSP; Minimum width allowed X = ' + formobj.minWlcspScribeXVal__c + ' Y = ' + formobj.minWlcspScribeYVal__c; 
        
        if(formobj.Technology__c == UtilityCls.CSOI_7RF && (formobj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formobj.Chip_Interconnect__c == 'WLCSP-BoP') 
            && formobj.IntConBumpSource__c == 'Yes') {
            tempList.add(new SelectOption(op1, op1));
        }         
        if(!(formobj.Technology__c == UtilityCls.CSOI_7RF && (formobj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formobj.Chip_Interconnect__c == 'WLCSP-BoP') && formobj.IntConBumpSource__c == 'Yes')) {            
            tempList.add(new SelectOption(op2, op2));            
        }
        tempList.add(new SelectOption('Standard channels; Custom minimum width', 'Standard channels; Custom minimum width'));
        tempList.add(new SelectOption('Standard channels; Fixed custom width', 'Standard channels; Fixed custom width'));
        
        if(!(formobj.Technology__c == UtilityCls.CSOI_7RF && (formobj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formobj.Chip_Interconnect__c == 'WLCSP-BoP') && formobj.IntConBumpSource__c == 'Yes')) {
            tempList.add(new SelectOption(op3, op3));
        }
        
        tempList.add(new SelectOption('SPD channels; Fixed custom width', 'SPD channels; Fixed custom width'));
        if(formobj.Technology__c == UtilityCls.CSOI_7RF && (formobj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formobj.Chip_Interconnect__c == 'WLCSP-BoP') 
            && formobj.IntConBumpSource__c == 'Yes') {
            tempList.add(new SelectOption(op4, op4));
        }

        tempList.add(new SelectOption('Compare Standard and SPD channels for optimal CPW', 'Compare Standard and SPD channels for optimal CPW'));
              
        if(tempList.size() == 2){
            tempList.remove(0);
        }
        return tempList;
    }
    
    public pageReference assignValues(){
        resetDependentFields();
        if(formObj.Channel_Type__c != null && formObj.Channel_Type__c != '' && formObj.Channel_Type__c.contains('Standard channels; Minimum width allowed')
            && formobj.minScribeXVal__c != null && formobj.minScribeXVal__c != '' 
            && formobj.minScribeYVal__c != null && formobj.minScribeYVal__c != ''){
            formObj.VerticalX__c = Decimal.ValueOf(formobj.minScribeXVal__c);
            readVerticalX = String.ValueOf(formObj.VerticalX__c);
            formObj.HorizontalY__c = Decimal.ValueOf(formobj.minScribeYVal__c);
            readHorizontalY = String.ValueOf(formObj.HorizontalY__c);
        } else if (formObj.Channel_Type__c != null && formObj.Channel_Type__c != '' && formObj.Channel_Type__c.contains('SPD channels; Minimum width allowed')  
            && formobj.minSpdScribeXVal__c != null && formobj.minSpdScribeXVal__c != '' 
            && formobj.minSpdScribeYVal__c != null && formobj.minSpdScribeYVal__c != ''){
            formObj.VerticalX__c = Decimal.ValueOf(formobj.minSpdScribeXVal__c);
            readVerticalX = String.ValueOf(formObj.VerticalX__c);
            formObj.HorizontalY__c = Decimal.ValueOf(formobj.minSpdScribeYVal__c);
            readHorizontalY = String.ValueOf(formObj.HorizontalY__c);          
        } else if (formObj.Channel_Type__c != null && formObj.Channel_Type__c != '' && formObj.Channel_Type__c.contains('GLOBALFOUNDRIES-sourced WLCSP;')
            && formobj.minWlcspScribeXVal__c != null && formobj.minWlcspScribeXVal__c != '' && formobj.minWlcspScribeYVal__c != null 
            && formobj.minWlcspScribeYVal__c != ''){
            formObj.VerticalX__c = Decimal.ValueOf(formobj.minWlcspScribeXVal__c);
            readVerticalX = String.ValueOf(formObj.VerticalX__c);
            formObj.HorizontalY__c = Decimal.ValueOf(formobj.minWlcspScribeYVal__c);
            readHorizontalY = String.ValueOf(formObj.HorizontalY__c);            
        } else if (formObj.ChannelStdOnly__c != null && formObj.ChannelStdOnly__c != '' && formObj.ChannelStdOnly__c.contains('Minimum width allowed') 
            && formobj.minScribeXVal__c != null && formobj.minScribeXVal__c != '' && formobj.minScribeYVal__c != null && formobj.minScribeYVal__c != ''){
            formObj.VerticalX__c = Decimal.ValueOf(formobj.minScribeXVal__c);
            readVerticalX = String.ValueOf(formObj.VerticalX__c);
            formObj.HorizontalY__c = Decimal.ValueOf(formobj.minScribeYVal__c); 
            readHorizontalY = String.ValueOf(formObj.HorizontalY__c);        
        }
        return null;
    }
    
    public void renderDicingPref() {
        
        if((formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing)) 
            && (formobj.Technology__c == UtilityCls.X32SOI || formobj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP || formobj.Technology__c == UtilityCls.BiCMOS_8XP_SiGe_8XP 
            || formobj.Technology__c == UtilityCls.CNV8SFi || formobj.Technology__c == UtilityCls.BiCMOS_9HP_SiGe_9HP || formobj.Technology__c == UtilityCls.CMOS_9LP_CMOS_9RF 
            || formobj.Technology__c == UtilityCls.CMOS_9SF || formobj.Technology__c == UtilityCls.CMOS_9RFe || formobj.Technology__c == UtilityCls.CMS90WG_CMOS9WG 
            || formobj.Technology__c == UtilityCls.CMOS_10LP || formobj.Technology__c == UtilityCls.CMOS_10LPe || formobj.Technology__c == UtilityCls.CMOS_10RFe 
            || formobj.Technology__c == UtilityCls.CMOS_10SF || formobj.Technology__c == UtilityCls.SOI12S0 || formobj.Technology__c == '45RFSOI') ) {
                dispDicingPref = true;
        } else {
            dispDicingPref = false;
        }
    }
    
    public List<SelectOption> getdicingPrefList(){
        List<SelectOption> tempList = new List<SelectOption>(); 
        tempList.add(new SelectOption('', FMS_SELECT_VAL)); 
        String op1 = 'Minimum width allowed X = ' + formobj.minScribeXVal__c + ' Y = ' + formobj.minScribeYVal__c; 
        
        tempList.add(new SelectOption(op1, op1));
        tempList.add(new SelectOption('Custom minimum width', 'Custom minimum width'));
        tempList.add(new SelectOption('Fixed custom width', 'Fixed custom width'));
        
        
        if(tempList.size() == 2){
            tempList.remove(0);
        }
        return tempList;
    }
    
    public List<SelectOption> getstepPlanEdgeList(){
        List<SelectOption> tempList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.StepPlanEdgeField__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        tempList.add(new SelectOption('', FMS_SELECT_VAL)); 
        for(Schema.PicklistEntry f : ple){       
            if((formObj.DesignSubmission__c == UtilityCls.Design_SingleChip || formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle) && f.getValue() == 'No' && formObj.Premerge__c == 'No'){
                formObj.StepPlanEdgeField__c = f.getValue();
                tempList.add(new SelectOption(f.getLabel(), f.getValue()));
            }else if((formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign) && formObj.Premerge__c == 'Yes'){
                tempList.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }        
        return tempList;
    }

    public void renderDicingMarks() {
        if((formObj.Packaging_Services__c == 'No' && !servOptsSetPg3.contains(UtilityCls.Dicing) && formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle)
            && (formobj.Technology__c == UtilityCls.X32SOI || formobj.Technology__c == UtilityCls.SOI12S0 || formobj.Technology__c == UtilityCls.CMOS_10SF || formobj.Technology__c == UtilityCls.CMOS_10LP || formobj.Technology__c == UtilityCls.CMOS_10RFe 
            || formobj.Technology__c == UtilityCls.CMOS_10LPe || formobj.Technology__c == '45RFSOI')) {
                dispDicingMarks = true;
        } else {
            dispDicingMarks = false;
        }
    }
       
    public boolean displayRenderLabel() {
        if(formObj.Technology__c == UtilityCls.CMOS_9SF || formObj.Technology__c == UtilityCls.CMOS_9RFe || formObj.Technology__c == UtilityCls.CMOS_8RF_CMRF8SF 
            || formObj.Technology__c == UtilityCls.CMHV7SF || formObj.Technology__c == UtilityCls.X32SOI || formObj.Technology__c == UtilityCls.CMOS_6SF 
            || formObj.Technology__c == UtilityCls.CNV8SFi || formObj.Technology__c == UtilityCls.CMOS_10LP || formObj.Technology__c == UtilityCls.CMOS_10LPe 
            || formObj.Technology__c == UtilityCls.CMOS_10SF || formObj.Technology__c == UtilityCls.SOI12S0) {
            renderLabel = true;
        } else {
            renderLabel = false;
        }
        return renderLabel;
    }
    
    public List<SelectOption> getPacTypeList(){
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.PackageType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', FMS_SELECT_VAL));   
        for( Schema.PicklistEntry f : ple) {
            if(f.getValue() == 'Other'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getValue() == 'FC PBGA' && formObj.Chip_Interconnect__c == UtilityCls.C4flipchip){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if(f.getValue() == 'FC CSP' && (formObj.Chip_Interconnect__c == UtilityCls.C4flipchip || formObj.Chip_Interconnect__c == UtilityCls.CopperPillar)) {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            if((f.getValue() == 'BCC' || f.getValue() == 'EPBGA' || f.getValue() == 'FBGA' || f.getValue() == 'QFP' || f.getValue() == 'QFN' || f.getValue() == 'HPBGA' || f.getValue() == 'PBGA' 
                || f.getValue() == 'PLGA' || f.getValue() == 'TE-EPBGA' || f.getValue() == 'Ceramic WB BGA' || f.getValue() == 'TAPP' || f.getValue() == 'TSSOP' || f.getValue() == 'PLCC' 
                || f.getValue() == 'PoP-WB' || f.getValue() == 'PoP-FC' || f.getValue() == 'WLP' || f.getValue() == 'Request IBM Proposal') && formObj.Chip_Interconnect__c == UtilityCls.Wirebond) {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
          if(options.size() == 2){
              options.remove(0);
         }
        return options;
    }

    public boolean checkStatesForTFAReadOnly(){
        if(formObj.State_of_the_Form__c == UtilityCls.Draft || formObj.State_of_the_Form__c == UtilityCls.Submitted || formObj.State_of_the_Form__c == UtilityCls.Frozen || formObj.State_of_the_Form__c == UtilityCls.Thawed || formObj.State_of_the_Form__c == UtilityCls.InactiveSubmitted || formObj.State_of_the_Form__c == UtilityCls.InactiveThawed || formObj.State_of_the_Form__c == UtilityCls.SubmittedForQuote || formObj.State_of_the_Form__c == UtilityCls.InactiveSubmittedForQuote){
            return true;
        }
        return false;
    }

    public Integer gettotalPageNums(){
        if(isTFACompany && formObj.QuoteOnly__c == 'Yes'){
            totPageNum = 2;
        }else if(isTFACompany && formObj.QuoteOnly__c == 'No' && checkStatesForTFAReadOnly()){ 
            if(formObj.TestServices__c == 'Yes' && (formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null)){
                totPageNum = 5;
            }else if(formObj.Packaging_Services__c == 'Yes'){
                totPageNum = 6;
            }else {
                totPageNum = 4;
            }       
        }else{
            if(formObj.TestServices__c == 'Yes' && (formObj.Packaging_Services__c == 'No' || formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null)){
                totPageNum = 4;
            }else if(formObj.Packaging_Services__c == 'Yes'){
                totPageNum = 5;
            }else {
                totPageNum = 3;
            }           
        }
        return totPageNum;
    }

    public PageReference next(){

        Set<String> servOptsSet = new Set<String>();
        servOptsSet.addAll(selServiceOptions);
        if(!servOptsSet.contains(UtilityCls.Dicing) && formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){
            selServiceOptions.add(UtilityCls.Dicing);
        }

        if(!validationCheck(formObj)){
            if(pageN == 'page1'){
                pageNum = 2;
                holdPage1Fields();
                if(isTFACompany){ 
                    renderPage2TFAMethods();
                    return Page.FMSmainFormCreationPg2TFA;        
                } else{
                    renderPage2Methods();
                    return Page.FMSmainFormCreationPg2;
                }
            } else if (pageN == 'page2'){

                if(isTFACompany){
                    pageNum = 4;
                }else{
                    pageNum = 3;
                }
                holdPage2Fields();
                renderPage3Methods();
                return Page.FMSmainFormCreationPg3;
            } else if (pageN == 'page2tfa'){
                pageNum = 3;
                holdPage2tfaFields();
                renderPage2Methods();
                return Page.FMSmainFormCreationPg2;
            } else if(pageN == 'page3'){
                if(isTFACompany && (totPageNum > 4)){
                    pageNum = 3;
                }else{
                    pageNum = 4;
                }
                holdPage3Fields();
                return Page.FMSmainFormCreationPg4;
            } else if(pageN == 'page4'){
                
                if(isTFACompany && (totPageNum > 5)){
                    pageNum = 6;
                }else{
                    pageNum = 5;
                }
                return Page.FMSmainFormCreationPg5;
            }
        } else {
            return ApexPages.currentPage();
        }
        return null;
    }

    public PageReference prev(){
        if(pageN == 'page2'){
            if(isTFACompany){
                pageNum = 2;
                renderPage2TFAMethods();
                return Page.FMSmainFormCreationPg2TFA;
            }else{
                pageNum = 1;
                holdPage2Fields();
                renderPage1Methods();
                return Page.FMSmainFormCreationPg1;
            }
        } else if (pageN == 'page2tfa'){
            pageNum = 1;
            holdPage2tfaFields();
            renderPage1Methods();
            return Page.FMSmainFormCreationPg1;
        } else if (pageN == 'page3'){
            if(isTFACompany){
                pageNum = 3;
            }else{
                pageNum = 2;
            }
            holdPage3Fields();
            
            renderPage2Methods();
            return Page.FMSmainFormCreationPg2;
        } else if (pageN == 'page4'){
            
            if(isTFACompany){
                pageNum = 4;
            }else{
                pageNum = 3;
            }
            renderPage3Methods();
            return Page.FMSmainFormCreationPg3;
        } else if (pageN == 'page5'){
            if(isTFACompany){
                pageNum = 5;
            }else{
                pageNum = 4;
            }
            holdPage5Fields();
            return Page.FMSmainFormCreationPg4;
        }
        return null;
    }
    public PageReference saveandExit(){  
        skipvalidation = true;
        config = false;
        if(pageN == 'page2tfa'){
            readOnlyCheck = true;
            holdPage2tfaFields();
        } else if (pageN == 'page1') {
            holdPage1Fields();
        } else if (pageN == 'page2') {
            holdPage2Fields();
        } else if (pageN == 'page3') {
            holdPage3Fields();
        } else if (pageN == 'page5') {
            holdPage5Fields();
        }
        
        return validateSave();        
    }
   
    public PageReference saveForm(){ 
        exitForm = false;
        config = false;
        if(pageN == 'page2tfa'){
            readOnlyCheck = true;
            holdPage2tfaFields();
        } else if (pageN == 'page1') {
            holdPage1Fields();
            
        } else if (pageN == 'page2') {
            holdPage2Fields();
        } else if (pageN == 'page3') {
            holdPage3Fields();
        } else if (pageN == 'page5') {
            holdPage5Fields();
        }
        return validateSave();        
    }

    public PageReference cancelForm(){
        PageReference pgRef = new PageReference('/apex/FMSmainFormViewPage');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true); 
        return pgRef;
    }

    public void holdPage1Fields() {
        
        for(AddContWrapper cc : selectedContactList.values()){
            if(!addContId.contains(cc.Id)){
                addContId += cc.Id+';';
                addContEmail = addContEmail+cc.Email+';';                    
                addContName = addContName+cc.Name+';';
                if(cc.Phone == null || cc.Phone == ''){
                    addContPhone = addContPhone+'NA;';
                }else{  
                    addContPhone = addContPhone+cc.Phone+';';
                }
            }
        }
        
        formObj.Selected_Contact_Ids__c = addContId;
        formObj.Name__c = addContName;
        formObj.Email__c = addContEmail;
        formObj.Phone__c = addContPhone;
        if(formObj.TestServices__c == 'Yes' && formObj.TestLevels__c != null && formObj.TestLevels__c != ''){
            formObj.TestLevels__c = formObj.TestLevels__c.trim();
        }
        if(!dispIntConBumpServ) {
            formObj.IntConBumpSource__c = '';
        }
    }

    public void holdPage2Fields() {

        if(!dispLastMetalUsed)
            formObj.LastMetalUsed__c = '';
        if(!dispNumMetalLayers)
            formObj.NumMetalLayers__c = '';
        if(!dispPassivation)
            formObj.Passivation__c = '';
        if(!dispPassivation1)
            formObj.Passivation1__c = '';
        if(!dispTechFeatures)
            formObj.CustomFeaturesDesc__c = '';     
        if(!dispNotMfgFeaturesDesc)
            formObj.NotMfgFeaturesDesc__c = ''; 

        String ServiceOpts = '';
        Set<String> servOptsSet = new Set<String>();
        servOptsSet.addAll(selServiceOptions);
        Boolean Start = true;
        if(!selServiceOptions.isEmpty()){
            if(!servOptsSet.contains(UtilityCls.Dicing) && formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){
                selServiceOptions.add(UtilityCls.Dicing);
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
            if(formObj.TestServices__c == 'Yes' && formObj.Packaging_Services__c == 'Yes'){
                selServiceOptions.add(UtilityCls.Dicing);
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
        formObj.ServiceOptions__c = ServiceOpts;
        if(!dispOtherServiceFeatures)
            formObj.OtherServiceFeatures__c = '';          
        if(!dispBacksideGrindThickness)
            formObj.BacksideGrindThickness__c = '';
        if(!dispFinalPassivation)
            formObj.FinalPassivation__c = '';
        if(!dispNumThickLevels)
            formObj.NumThickCuLevels__c = '';
        if(formObj.QuoteOnly__c == 'Yes' || (formObj.Technology__c != UtilityCls.BiCMOS_8WL_SiGe_8WL && formObj.Technology__c != UtilityCls.CSOI8SW))
            formObj.Wiringoptions__c = '';     
    }

    public void holdPage2tfaFields() {
        if(!dispNeedBizComment){ // Modified by Abhita for UAT Issue #428
            formObj.NeedBizComment__c = '';
        }
    }

    public void holdPage3Fields() {
        if(!addContTableList.isEmpty()){
            for(AddStepPlanContWrapper cc : addContTableList.values()){
                if(!spaddContId.contains(cc.spId)){
                    spaddContId += cc.spId+';';
                    spaddContEmail = spaddContEmail+cc.spEmail+';';                    
                    spaddContName = spaddContName+cc.spName+';';
                }
            }
        } else {
            spaddContId = '';
            spaddContName = '';
            spaddContEmail = '';
        }
          
        formObj.SelAppId__c = spaddContId;
        formObj.AppName__c = spaddContName;
        formObj.AppEmail__c = spaddContEmail;
        
        if(!invalidInputCheckMap.isEmpty()){
            for(String s : invalidInputCheckMap.keySet()){
                if(invalidInputCheckMap.get(s) == 'true'){
                    if(invalidInpToFieldsMap.get(s) == 'DieXSize__c'){
                        formObj.DieXSize__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'DieYSize__c'){
                        formObj.DieYSize__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NumOfDesigns__c'){
                        formObj.NumOfDesigns__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NumOfBEOLDesigns__c'){
                        formObj.NumOfBEOLDesigns__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NumOfFEOLDesigns__c'){
                        formObj.NumOfFEOLDesigns__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'WireBondPadPitch__c'){
                        formObj.WireBondPadPitch__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NumC4Pads__c'){
                        formObj.NumC4Pads__c = null;        
                    }
                    if(invalidInpToFieldsMap.get(s) == 'WireBondPad__c'){
                        formObj.WireBondPad__c = null;      
                    }
                    if(invalidInpToFieldsMap.get(s) == 'VerticalX__c'){
                        formObj.VerticalX__c = null;      
                    }
                    if(invalidInpToFieldsMap.get(s) == 'HorizontalY__c'){
                        formObj.HorizontalY__c = null;      
                    }
                }
            }                           
        }
    }

    public void holdPage5Fields() {
        if(!invalidInputCheckMap.isEmpty()){
            for(String s : invalidInputCheckMap.keySet()){
                if(invalidInputCheckMap.get(s) == 'true'){
                    if(invalidInpToFieldsMap.get(s) == 'CrossFlowIFPM__c'){
                        formObj.CrossFlowIFPM__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NoOfPowerSupplies__c'){
                        formObj.NoOfPowerSupplies__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'ModulePinsBallsTotal__c'){
                        formObj.ModulePinsBallsTotal__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'ModulePinsBallsSignal__c'){
                        formObj.ModulePinsBallsSignal__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'ModulePinsBallsPower__c'){
                        formObj.ModulePinsBallsPower__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'ModulePinsBallsGround__c'){
                        formObj.ModulePinsBallsGround__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(s) == 'ModulePinsBallsUnused__c'){
                        formObj.ModulePinsBallsUnused__c = null;        
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NumberModuleDecouplingCapacitors__c'){
                        formObj.NumberModuleDecouplingCapacitors__c = null;      
                    }
                    if(invalidInpToFieldsMap.get(s) == 'NoOfDiffPairs__c'){
                        formObj.NoOfDiffPairs__c = null;      
                    }
                }
            }                           
        }
    }
    
    public PageReference validateSave(){
        boolean val = validationCheck(formObj);
        
        if((pageN == 'page2tfa' && readOnlyCheck) || !exitForm || skipValidation || !val){
            
            if(pageN == 'page2tfa') {
                holdPage2tfaFields();
            } else if(pageN == 'page1') {
                holdPage1Fields();
            } else if(pageN == 'page2') {
                holdPage2Fields();
            } else if(pageN == 'page3') {
                holdPage3Fields();
            } else if(pageN == 'page5') {
                holdPage5Fields();
            }
            try{
                
                if(!conDocShare.isEmpty()){
                    Upsert conDocShare;
                }
                if(!conDocDelete.isEmpty()){
                    delete conDocDelete;
                }

                update formObj;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
        } else {
            return null;
        }
        PageReference pgRef;

        if(config){            
            if(lstproposal<>NULL && !lstproposal.isEmpty()) {
                pgRef = new PageReference('/apex/Apttus_QPConfig__ProposalConfiguration?flow=FMSFlow&id='+lstproposal[0].id);
            }
            else {
                RecordType recType = [Select Id From RecordType Where Name='Proposal from FMS Read Only' And SobjectType = 'Apttus_Proposal__Proposal__c'];
                Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where name = 'FMS Price List'];
                                
                Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = formObj.Form_Name__c,
                                                     Device__c = formObj.Device__r.id, Apttus_Proposal__Account__c = formObj.Customer_Name__r.Id,                                                   
                                                     Apttus_proposal__approval_stage__c = 'FMS Draft Phase', FMS_Proposal__c = formObj.id, 
                                                     RecordTypeid= recType.id, Actual_Tapeout_Date_FAB_9_and_FAB_10__c = formObj.ProjectedTapeout__c,
                                                     Apttus_Proposal__Opportunity__c = formObj.Opportunity__c, Apttus_QPConfig__PriceListId__c = priceList.id);
                try{
                    insert proposal;
                } catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
                
                if(proposal <> null){
                    List<product2> productbundle= [Select id from product2 where Apttus_Config2__ConfigurationType__c='Bundle' and Product_External_ID__c=:(formObj.Technology__c+'_FMS')]; 
                
                    if(productbundle != null && productbundle.size()>0){
                        
                        String cartId = CPQ_ProposalCartHandler.addBundleToCart(proposal.id,productbundle[0].id);
                        pgRef = new PageReference('/apex/Apttus_QPConfig__ProposalConfiguration?flow=FMSFlow&id='+proposal.id);
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Could not find the Technology "'+formObj.Technology__c+'" in configurator, so please contact CPQ Configurator team for help.'));
                    }                
                }
                
            }
            pgRef.setRedirect(true); 
        } else if(exitForm){
            populateAdditionalContacts();
            populateSPContacts();
            pgRef = new PageReference('/apex/FMSmainFormViewPage');
            if(!val){
                pgRef.getParameters().put('id', formObj.id);
                pgRef.setRedirect(true);
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your form has been saved successfully!'));
            skipvalidation = false;
            exitForm = true;
            return null;
        }
        return pgRef;
    }
    
    public Boolean validationCheck(Form_Management_System__c formOBj){
        Boolean val = false;
        if(pageN == 'page1'){
            if(formOBj.HasReleaseGuidelines__c == '' || formOBj.HasReleaseGuidelines__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Have you read and do you understand the Foundry Release Requirements? is a Required field'));
                val = true;
            }
            if(formObj.ProductName__c == '' || formObj.ProductName__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Product Name: is a Required field'));
                val = true;
            }
            if(formObj.ProductRevision__c == '' || formObj.ProductRevision__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Product Revision: is a Required field'));
                val = true;
            }
            if(formObj.ItarData__c =='' || formObj.ItarData__c == null){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product subject to the International Traffic in Arms Regulations (ITAR)? is a Required field'));
                val = true;
            }
            if(formObj.HazardousUse__c =='' || formObj.HazardousUse__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this Hazardous Use (HU): is a Required field'));
                val = true;
            }
            if(formObj.Technology__c == '' || formObj.Technology__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Foundry Technology: is a Required field'));
                val = true;
            }
            if(formObj.ReleaseProcessFlow__c == '' || formObj.ReleaseProcessFlow__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Release Process: is a Required field'));
                val = true;
            }
            if(formObj.TestServices__c == '' || formObj.TestServices__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Test Services: is a Required field'));
                val = true;
            }
            if(formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Packaging Services: is a Required field'));
                val = true;
            }
            if(formObj.Chip_Interconnect__c == '' || formObj.Chip_Interconnect__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Chip Interconnect: is a Required field'));
                val = true;
            }
            if(formObj.TestServices__c != '' && formObj.TestServices__c != null && formObj.TestServices__c == 'Yes' && (formObj.TestLevels__c == '' || formObj.TestLevels__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What test levels do you desire? is a Required field'));
                val = true;
            }
            if(dispIntConBumpServ && (formObj.IntConBumpSource__c == null || formObj.IntConBumpSource__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is the Interconnect Bumping being sourced by GLOBALFOUNDRIES? is a Required field'));
                val = true;
            }
            if(((formObj.Technology__c == UtilityCls.CSOI_7RF && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No') && (formObj.Chip_Interconnect__c == UtilityCls.WLCSP_RDL || formObj.Chip_Interconnect__c == UtilityCls.WLCSP_BoP) && (formObj.IntConBumpSource__c == 'Yes' && formObj.QuoteOnly__c != 'Yes')) && (formObj.ChipEdgeWLCSP__c == null || formObj.ChipEdgeWLCSP__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: GLOBALFOUNDRIES sourced WLCSP will be supported only if the PDK-supplied crackstop (Enhanced Crackstop) is present inside your design’s CHIPEDGE. Have you included the unmodified PDK-supplied crackstop within your design(s)? is a Required field'));
                val = true;
            }
            if(isTFACompany){
                if(formObj.AssetProtectionCode__c == null || formObj.AssetProtectionCode__c ==''){ 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Asset Protection Code: is a Required field'));
                    val = true;
                }
                if(formObj.MedicalDevice__c == null || formObj.MedicalDevice__c ==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product to be used in conjunction with a medical device?: is a Required field'));
                    val = true;
                }
                if(formObj.NuclearDevice__c == null || formObj.NuclearDevice__c ==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product to be used in conjunction with a nuclear application?: is a Required field'));
                    val = true;
                }
                if(formObj.QuoteOnly__c == null || formObj.QuoteOnly__c ==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this form for quote purposes only?: is a Required field'));
                    val = true;
                }
            }
            
        } else if(pageN == 'page2'){
            if(String.valueOf(formObj.ProjectedTapeout__c) == null || String.valueOf(formObj.ProjectedTapeout__c) == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Projected GDS submission (tapeout) is a Required field'));
                val = true;
            }
            if(dispsourcingLocation && (formObj.SourcingLocation__c == null || formObj.SourcingLocation__c == '' || formObj.SourcingLocation__c == FMS_SELECT_VAL)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your preferred sourcing location is a Required field'));
                val = true;
            }           
            if(dispLastMetalUsed && (formObj.LastMetalUsed__c == null || formObj.LastMetalUsed__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Last Metal Used is a Required field'));
                val = true;
            }
            if(formObj.Waivers__c == null || formObj.Waivers__c == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will you require waivers for any DRC violations? is a Required field'));
                val = true;
            }
            if(String.isBlank(formObj.MetallizationOpts__c) && lstMetalWrapper.size()>1){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Metallization Option is a Required field'));
              val = true;
            }
            if(dispNumMetalLayers && (formObj.NumMetalLayers__c == null || formObj.NumMetalLayers__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total Number of Metal Layers is a Required field'));
                val = true;
            }
            if(dispPassivation && (formObj.Passivation__c == null || formObj.Passivation__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Passivation is a Required field'));
                val = true;
            }
            if(formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9') {
                if(formObj.Custom_Features__c == null || formObj.Custom_Features__c == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any custom or development features that are not part of the base or optional features listings in the published design manual? is a Required field'));
                    val = true;
                }
                if(dispTechFeatures && (formObj.CustomFeaturesDesc__c == null || formObj.CustomFeaturesDesc__c == '')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list these non standard features: is a Required field'));
                    val = true;
                }
                if(formObj.NotMfgFeatures__c == null || formObj.NotMfgFeatures__c == ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any features that should NOT be manufactured for this program revision? is a Required field'));
                    val = true;
                }
                if(dispNotMfgFeaturesDesc && (formObj.NotMfgFeaturesDesc__c == null || formObj.NotMfgFeaturesDesc__c == '')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list all features that should be excluded from the build: is a Required field'));
                    val = true;
                }
            }
            if(dispStepPlanCustReq && (formObj.StepPlanCustomRequirement1__c == null || formObj.StepPlanCustomRequirement1__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will your orders be placed for wafer quantity, with wafer functional test as a service-only adder?: is a Required field'));
                val = true;
            }           
            if(dispDataCheckingOpts && formObj.DataCheckingOptions__c == null || formObj.DataCheckingOptions__c == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Data Checking Options: is a Required field'));
                val = true;
            }
            if(selServiceOptions == null || selServiceOptions.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Service Options: is a Required field'));
                val = true;
            }
            if(dispOtherServiceFeatures && (formObj.OtherServiceFeatures__c == null || formObj.OtherServiceFeatures__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other service features: is a Required field'));
                val = true;
            }
            if(formObj.DesignSubmission__c == null || formObj.DesignSubmission__c == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Type Of Design Submission: is a Required field'));
                val = true;
            }
            if(formObj.Deliverable__c == null || formObj.Deliverable__c == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Deliverable: is a Required field'));
                val = true;
            }
            if(formObj.QuoteOnly__c != 'Yes' && (formObj.Premerge__c == null || formObj.Premerge__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does this design data submission contain any premerged design(s)? is a Required field'));
                val = true;
            }
            if(dispDeliverableSplit && (formObj.DeliverableSplit__c == null || formObj.DeliverableSplit__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are you expecting more than one deliverable (splits) from this single GDS? is a Required field'));
                val = true;
            }
            if(dispBacksideGrindThickness && (formObj.BacksideGrindThickness__c == null || formObj.BacksideGrindThickness__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please choose a Backside Grind Thickness: is a Required field'));
                val = true;
            }
            if(dispCll && (formObj.CLL__c == null || formObj.CLL__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select Custom Lot Labeling (CLL) and Laser Scribe Requirements: is a Required field'));
                val = true;
            }
            if(dispNonStandardCll && (formObj.NonstandardCLL__c == null || formObj.NonstandardCLL__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Describe your Non-standard CLL Laser Scribe Area Requirements: is a Required field'));
                val = true;
            }
            if((formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && dispFinalPassivation && formObj.Packaging_Services__c == 'No' 
                && ((formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)') || ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
                || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'LV (01L6998)' 
                && formObj.Chip_Interconnect__c == 'C4 flip chip'))) && (formObj.FinalPassivation__c == null || formObj.FinalPassivation__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require final passivation films in the front side scribe region?: is a Required field'));
                val = true;
            }
            if((formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && dispLineFront && formObj.Packaging_Services__c == 'No' 
                && ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
                && formObj.Passivation__c == 'SZ - No Polyimide (LV drawn) (84Y6986)' && formObj.Chip_Interconnect__c == 'C4 flip chip') 
                || (formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' && formObj.Passivation__c == 'FV - Polyimide only (84Y8379)' 
                && formObj.FinalPassivation__c == 'Yes; 4X FV SHIFT (84Y8783)') || ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
                || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'LV (01L6998)' 
                && formObj.Chip_Interconnect__c == 'C4 flip chip' && formObj.FinalPassivation__c == 'Yes; 4X LV SHIFT (84Y8784)')) 
                && (formObj.LineFront__c == null || formObj.LineFront__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require 2 line front side scribe?: is a Required field'));
                val = true;
            }
            if(dispShippingLabelCLL && (formObj.ShippingLabelCLL__c == null || formObj.ShippingLabelCLL__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Identify your Shipping Label Customer Part Number for CLL: is a Required field'));
                val = true;
            }
            if(dispChipEdgeDesign && (formObj.Chipedgedesign__c == null || formObj.Chipedgedesign__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: GLOBALFOUNDRIES sourced dicing will be supported only if the PDK-supplied crackstop is present inside your design(s) CHIPEDGE. Have you included the unmodified PDK-supplied crackstop within your design(s)?: is a Required field'));
                val = true;
            }
            if(dispNumThickLevels && (formObj.NumThickCuLevels__c == null || formObj.NumThickCuLevels__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of Thick Cu Levels: is a Required field'));
                val = true;
            }
            if((formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == UtilityCls.BiCMOS_8WL_SiGe_8WL || formObj.Technology__c == UtilityCls.CSOI8SW)) && (formObj.Wiringoptions__c == null || formObj.Wiringoptions__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wiring Options: is a Required field'));
                val = true;
            }
            if((formObj.Technology__c == UtilityCls.CNV8SFi) && (formObj.DesignDelivered__c == null || formObj.DesignDelivered__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What format will the design be delivered in?: is a Required field'));
                val = true;
            }
            if(formObj.Technology__c == UtilityCls.BiCMOS_8HP_SiGe_8HP && (formObj.EnhancedWiring__c == null || formObj.EnhancedWiring__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Enhanced Cu Wiring: is a Required field'));
                val = true;
            }
            if(dispPassivation1 && (formObj.Passivation1__c == null || formObj.Passivation1__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Through-Silicon Via: is a Required field'));
                val = true;
            }
            
            if(dispStepPlanCustReq && formObj.StepPlanCustomRequirement1__c == 'No' && (formObj.StepPlanCustomRequirementInput1__c == null || formObj.StepPlanCustomRequirementInput1__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please explain how your orders will be placed: is a Required field'));
                val = true;
            }
            if((formObj.Technology__c != '' && formObj.Technology__c != null && formObj.Technology__c != '--None--') && (formObj.MetallizationOpts__c == null || formObj.MetallizationOpts__c == '') && Environment_Variable__c.getInstance('METALLIZATIONOPT_TECH').Value__c.contains(formObj.Technology__c) ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Metallizations: is a Required field'));
                val = true;    
            }
            if(formObj.MetallizationOpts__c == 'Other' && (formObj.OtherMetallization__c == '' || formObj.OtherMetallization__c == NULL)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: OtherMetallization: is a Required field'));
                val = true;
            }
            if(formObj.ReleaseProcessFlow__c == 'Original Flow' && (getconfigData()==null || isTechnologyConfigured==null || mapTabPOGs==null  
                || sectionsByTab==null || optionsBy_POG_Ids==null) && isTechVisible){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Technology Features inside Configurator are Required.'));
                val = true;
            }
        } else if(pageN == 'page2tfa' && !readOnlyCheck){
            if(dispWireBondSplit && (formObj.WireBondSplit__c =='' || formObj.WireBondSplit__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be a wirebond split? is a Required field'));
                val = true;
            }
            if(dispWireBondSplitTAT && (formObj.WireBondSplitTAT__c =='' || formObj.WireBondSplitTAT__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What Turnaround time do you need for the wirebond split? is a Required field'));
                val = true;
            }
            if(dispWireBondSplitTAT && (formObj.WireBondWaferReq__c =='' || formObj.WireBondWaferReq__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What are your wafer requirements for wirebond wafers? is a Required field'));
                val = true;
            }
            if(dispWireBondSplit && (formObj.C4Split__c =='' || formObj.C4Split__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be a C4 split? is a Required field'));
                val = true;
            }
            if(dispC4SplitTAT && (formObj.C4SplitTAT__c =='' || formObj.C4SplitTAT__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What Turnaround time do you need for the C4 split? is a Required field'));
                val = true;
            }
            if(dispC4SplitTAT && (formObj.C4WaferReq__c =='' || formObj.C4WaferReq__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What are your wafer requirements for C4 wafers? is a Required field'));
                val = true;
            }
            if(dispWireBondSplit && (formObj.OtherSplits__c =='' || formObj.OtherSplits__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be any other splits? is a Required field'));
                val = true;
            }
            if(dispOtherSplitDepts && (formObj.OtherSplitDets__c == '' || formObj.OtherSplitDets__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please explain splits and their requirements: is a Required field'));
                val = true;
            }
            if(dispITARCategory && (formObj.ItarCategory__c == null || formObj.ItarCategory__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ITAR Category: is a Required field'));
                val = true;
            }
            if(dispClientResponseDt && (String.valueOf(formObj.ClientResponseDt__c) == '' || formObj.ClientResponseDt__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Client Requested Quote Response Date: is a Required field'));
                val = true;
            }
            if((formObj.NeedBizComment__c == 'Yes' && dispNeedBizComment) && (formObj.BusinessComments__c == '' || formObj.BusinessComments__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Client Requested Quote Response Date: is a Required field'));
                val = true;
            }
        } else if(pageN == 'page3'){
            /*if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && (formObj.DesignSubmission__c == UtilityCls.Design_MultiReticle 
                || formObj.DesignSubmission__c == UtilityCls.Design_ChipletDesign) && (formObj.ECCN_attachmentName__c == null 
                || String.valueOf(formObj.ECCN_attachmentName__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select ECCN Layout file'));
                val = true;
            }*/
            if(dispNumOfDesigns && (formObj.NumOfDesigns__c == null || String.valueOf(formObj.NumOfDesigns__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What is the total number of Topcells that will be submitted for this program? is a Required field'));
                val = true;
            }
            if(dispNumOfDesigns && (formObj.NumOfFEOLDesigns__c == null || String.valueOf(formObj.NumOfFEOLDesigns__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Front End of Line (precontact) designs: is a Required field'));
                val = true;
            }
            if(dispNumOfDesigns && (formObj.NumOfBEOLDesigns__c == null || String.valueOf(formObj.NumOfBEOLDesigns__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Back End of Line (Metal) designs: is a Required field'));
                val = true;
            }
            if(dispMaxChipPower && (formObj.MaxChipPower__c == null || formObj.MaxChipPower__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Max Chip Power: is a Required field'));
                val = true;
            }
            if(dispCircuitType && (formObj.CircuitType__c == null || formObj.CircuitType__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Circuit Type: is a Required field'));
                val = true;
            }
            if(dispC4PadLayout && (formObj.C4PadLayout__c == null || formObj.C4PadLayout__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Pad/Bump Pitch: is a Required field'));
                val = true;
            }
            if(dispC4PadLayoutForDRC && (formObj.C4PadLayoutForDRC__c == null || formObj.C4PadLayoutForDRC__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Pad/Bump Pitch used for DRC? is a Required field'));
                val = true;
            }
            if(dispNumC4Pads && (formObj.NumC4Pads__c == null || String.valueOf(formObj.NumC4Pads__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total number of active and dummy pads: is a Required field'));
                val = true;
            }
            if(dispC4SolderMaterial && (formObj.C4SolderMaterial__c == null || formObj.C4SolderMaterial__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: C4 Solder Material: is a Required field'));
                val = true;
            }
            if(dispPinOneID && (formObj.PinOneID__c == null || formObj.PinOneID__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: How are you identifying pin one to IBM: is a Required field'));
                val = true;
            }
            if(formObj.IpIdentification__c == null || formObj.IpIdentification__c ==''){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does your design(s) contain any IP that requires identification? is a Required field'));
                val = true;
            }
            if(dispDesignKitOthers && (formObj.DesignKitOthers__c == null || formObj.DesignKitOthers__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list the IP Provider Name and Library(s) contained within your design(s). Examples of providers: ARM, ASIC North, IBM, Novocell, Synopsys, etc.: is a Required field'));
                val = true;
            }
            if(dispadditionalComments && (formObj.AdditionalComments__c == null || formObj.AdditionalComments__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List additional information here: is a Required field'));
                val = true;
            }
            if(dispC4LaminatePackage && (formObj.C4LaminatePkg__c == null || formObj.C4LaminatePkg__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will you be using a laminate package?: is a Required field'));
                val = true;
            }
            if(dispOtherC4PadLayout && (formObj.OtherC4PadLayout__c == null || formObj.OtherC4PadLayout__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other (microns): is a Required field'));
                val = true;
            }
            if(dispWirebondLayout && (formObj.WireBondLayout__c == null || formObj.WireBondLayout__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wirebond Layout: is a Required field'));
                val = true;
            }
            if(dispWirebondPad && (formObj.WireBondPad__c == null || String.valueOf(formObj.WireBondPad__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total number of active and dummy Wirebond pads?: is a Required field'));
                val = true;
            }
            if(dispWireBondPadPitch && (formObj.WireBondPadPitch__c == null || String.valueOf(formObj.WireBondPadPitch__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wirebond Pad Pitch (microns): is a Required field'));
                val = true;
            }
            
            if(!displayNotAvailableMsg && dispStepPlanSection &&  (formObj.StepPlanEducation__c == null || String.valueOf(formObj.StepPlanEducation__c) =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Have you read and do you understand the Step Plan Education Package?'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && dispInputMethod && (formObj.InputMethod__c == null || String.valueOf(formObj.InputMethod__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your step plan input Methodology:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.' 
                && (formObj.AdvancedProcessFileAttachment__c == null || String.valueOf(formObj.AdvancedProcessFileAttachment__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select Reticle Layout XML file'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment' 
                && (formObj.FileAttachment__c == null || String.valueOf(formObj.FileAttachment__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select Reticle Layout Information'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.DesignSubmission__c != UtilityCls.Design_MultiReticle && formobj.Technology__c != UtilityCls.X32SOI 
                && formObj.InputMethod__c != 'Advanced Process: Inputs via XML file attachment.' && (formobj.StepPlanChipRotation__c == null 
                || formobj.StepPlanChipRotation__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select chip design rotation. Rotation value selected is counter-clockwise with chip origin (0,0) in lower left corner.'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && dispCrackOptions && (formObj.CrackstopOptions__c == null || formObj.CrackstopOptions__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Crackstop methodology:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && dispChannelType && (formObj.Channel_Type__c == null || formObj.Channel_Type__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Dicing Channel type:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && dispDicingPref && (formObj.ChannelStdOnly__c == null || formObj.ChannelStdOnly__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Dicing Channel preference:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.DesignSubmission__c != '' && formObj.DesignSubmission__c != null && formObj.Packaging_Services__c == 'No' 
                && (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '' || !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)) && ((formObj.Channel_Type__c != 'Compare Standard and SPD channels for optimal CPW' && formObj.Channel_Type__c != null
                && formObj.Channel_Type__c != '') || dispDicingPref) && formObj.VerticalX__c == null){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify your preferred Dicing Channel width X (um):'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.DesignSubmission__c != '' && formObj.DesignSubmission__c != null && formObj.Packaging_Services__c == 'No' 
                && (formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == '' || !formObj.ServiceOptions__c.contains(UtilityCls.Dicing)) && ((formObj.Channel_Type__c != 'Compare Standard and SPD channels for optimal CPW' && formObj.Channel_Type__c != null
                && formObj.Channel_Type__c != '') || dispDicingPref) && formObj.HorizontalY__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify your preferred Dicing Channel width Y (um):    '));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.Packaging_Services__c == 'No' && (formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == '' || !formObj.ServiceOptions__c.contains(UtilityCls.Dicing))
                && formObj.Channel_Type__c == 'Compare Standard and SPD channels for optimal CPW' && (formObj.CompareChannels__c == null || formObj.CompareChannels__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify the Dicing Channel widths (X,Y) to be used for the comparison:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.Packaging_Services__c == 'No' && (formObj.ServiceOptions__c == null || formObj.ServiceOptions__c == '' || !formObj.ServiceOptions__c.contains(UtilityCls.Dicing))
                && (formObj.StepPlanEdgeField__c == null || formObj.StepPlanEdgeField__c =='')){     
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is Enhanced Edge Field Stepping required for improved chips-per-wafer?'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && dispDicingMarks && (formObj.DiceMarks__c == null || formObj.DiceMarks__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require dice marks placed in the GLOBALFOUNDRIES-placed DICING CHANNELS?'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && (formObj.StepPlanCustomRequirement__c == null || formObj.StepPlanCustomRequirement__c =='')){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you have any custom step plan requirements not outlined above?'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && formObj.StepPlanCustomRequirement__c == 'Yes' && (formObj.StepPlanCustomRequirementInput__c == null 
                || formObj.StepPlanCustomRequirementInput__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List custom requirements here:'));
                val = true;
            }
            if(!displayNotAvailableMsg && dispStepPlanSection && contDicing && formObj.Packaging_Services__c == 'No' && addContTableList.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Atleast one Step Plan Approver user is required'));
                val = true;
            }
            
            if(dispPickMap && (formObj.PickMap__c == null || formObj.PickMap__c == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are you ordering an Untested Pick-All Wafer Map (Default Map)?: is a Required field'));
                val = true;
            }
            if((formObj.DesignSubmission__c != UtilityCls.Design_MultiReticle && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && formObj.QuoteOnly__c != 'No')) && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && isTFACompany))) && (formObj.DieXSize__c == null || String.valueOf(formObj.DieXSize__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Final Chip Size x (mm): is a Required field'));
                val = true;
            }
            if((formObj.DesignSubmission__c != UtilityCls.Design_MultiReticle && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && formObj.QuoteOnly__c != 'No')) && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && isTFACompany))) && (formObj.DieYSize__c == null || String.valueOf(formObj.DieYSize__c) == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Final Chip Size y (mm): is a Required field'));
                val = true;
            } 
            if(isInvalidInp){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format. Please note the value enterred in wrong format will not be saved.'));
                val = true;
            }
        } else if(pageN == 'page4'){
            if(formObj.WorstCaseTj__c == null || formObj.WorstCaseTj__c ==''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Maximum Tj:is a Required field'));
                val = true;
            }
        } else if(pageN == 'page5'){            
            if (formObj.Packaging_Services__c == 'Yes' && (formObj.PackageRequirement__c == '' || formObj.PackageRequirement__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Package Requirements: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.PackageType__c == '' || formObj.PackageType__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Package Type needed (Click the Help icon to view the descriptions): is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.PackageType__c == 'Other' && formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.PackageTypeOther__c == '' || formObj.PackageTypeOther__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.SID__c == '' || formObj.SID__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: SID or IBM Part Number: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && (formObj.ModulePowerMax__c == '' || formObj.ModulePowerMax__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Module Power (Max): is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && (formObj.Cooling__c == '' || formObj.Cooling__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Cooling: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.Cooling__c == 'Other' && (formObj.CoolingOther__c == '' || formObj.CoolingOther__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.Cooling__c == 'Cross Flow' && (formObj.CrossFlowIFPM__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Cross Flow (feet/min): is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && (formObj.LifetimePOH__c == '' || formObj.LifetimePOH__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Lifetime Power On Hours: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.LifetimePOH__c == 'Other' && (formObj.LifetimePOHOther__c == '' || formObj.LifetimePOHOther__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.DiffPairRequired__c == 'Yes' && (formObj.NoOfDiffPairs__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: How many: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && (formObj.ModuleType__c == '' || formObj.ModuleType__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is the package a single chip module or a multichip module?: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.ModuleType__c == 'Multi-Chip Module'
                && (formObj.MultiChipDetails__c == '' || formObj.MultiChipDetails__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: If multichip, provide additional details: is a Required field'));
                val = true;
            }
            if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.ModulePinsBallsTotal__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total: is a Required field'));
                val = true;
            }
            if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.ModulePinsBallsSignal__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Signal: is a Required field'));
                val = true;
            }
            if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.ModulePinsBallsPower__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Power is a Required field'));
                val = true;
            }
            if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.ModulePinsBallsGround__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Ground: is a Required field'));
                val = true;
            }
            if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.ModulePinsBallsUnused__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Unused: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.ModuleDecouplingCapacitors__c == 'Yes' && formObj.CapacitanceValue__c == 'Other' && (formObj.CapacitanceValueOther__c == '' || formObj.CapacitanceValueOther__c == null )) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
                val = true;
            }
            if (formObj.Packaging_Services__c == 'Yes' && formObj.ProductShipReq__c == 'Other' && (formObj.ProductShipReqOther__c == '' || formObj.ProductShipReqOther__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field '));
                val = true;
            }
            if(isInvalidInp){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please enter the correct input format. Please note the value enterred in wrong format will not be saved.'));
                val = true;
            }
        }
        return val;
    }

    public void resetDependentFields(){
        FMS_HierarchyLogic.getDependentFieldsToReset(fieldAPI,formObj,'Main');
        fieldAPI = '';
    }

   @RemoteAction
   public static String checkLicense(){
       String errorMsg = '';
       Boolean bypass = false;      
       Boolean userAccessChk = (Test.isRunningTest())?false:UserInfo.isCurrentUserLicensed('Apttus_Config2');
        
       for(CPQLicenseUnavailable__c cs : CPQLicenseUnavailable__c.getAll().values()){           
           if(userinfo.getProfileId().contains(cs.id__c)){
               bypass = true;              
           }                
       } 
                      
       if(!userAccessChk && bypass == false){
           String sub = 'Apttus CPQ License for '+UserInfo.getName();
           List<Case> existingCase = [Select id,CaseNumber from Case where subject = :sub  and createdbyId =: userinfo.getUserId()];
           if(!existingCase.isEmpty()){
               errorMsg = 'Already a Case #No.' + existingCase[0].CaseNumber + ' is existing for your apttus access';
           }
           else{
               errorMsg = Label.CPQ_License_Unavailable; 
               ClsProductServices.sendEmail(URL.getCurrentRequestUrl().toExternalForm());
           }                              
           return errorMsg;           
       }
       else{           
           return null;
       }                 
   }

    public void renderFinalPassivationView() {
        if(formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' 
        && checkFormCompany(formObj.Customer_Name__r.SAP_Account_Number__c, UtilityCls.FMS_SAP_ACC_NO11) &&
        formObj.Packaging_Services__c == 'No' 
        && ((formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' 
        && formObj.Passivation__c == 'FV - Polyimide only (84Y8379)') 
        || ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
        || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
        && formObj.Passivation__c == 'LV (01L6998)' && formObj.Chip_Interconnect__c == 'C4 flip chip'))) {  
            dispFinalPassivation = true;
        } else {
            dispFinalPassivation = false;
        }
    }
    
    public void renderotherServiceFeaturesView() {
        if (formObj.ServiceOptions__c != null && formObj.ServiceOptions__c != '') {
            Set < String > sOpt1 = new Set < String > ();
            if(formObj.ServiceOptions__c!= null && formObj.ServiceOptions__c!=''){
                sOpt1.addAll(formObj.ServiceOptions__c.split(';'));    
            }
            
            if (sOpt1.contains('Other') && formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c != '--None--') {
                dispOtherServiceFeatures = true;
            } else {
                dispOtherServiceFeatures = false;
            }
        } else {
            dispOtherServiceFeatures = false;
        }
    }
    
    public List<MetallizationOptionWrapper> getMetalizationOption(){
        List<MetallizationOptionWrapper> mList = new List<MetallizationOptionWrapper>();
        MetallizationOptionWrapper mow;
        if(formObj.MetallizationOpts__c!=null && formObj.MetallizationOpts__c!='Other'){
            String uiValue ='';
            for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
                if(fmsTab.Technology__c == formObj.Technology__c 
                    && fmsTab.DB_Value__c == formObj.MetallizationOpts__c){
                    uiValue = fmsTab.UI_Value__c;
                    break;
                }
            }
            if(uiValue != '' && uiValue != null){
                String[] strArr = uiValue.split('##');
                mow = new MetallizationOptionWrapper(strArr[0],strArr[1],strArr[2],strArr[3]);
                mList.add(mow);
            }               
        }
        return mList;
    }

    public String getDataCheckingOptsList(){
        for(FMS_Mapping_Table__c fmsTab : fmsMappingTable){
            if(fmsTab.Field__c == 'Datacheck Options' && fmsTab.DB_Value__c == formObj.DataCheckingOptions__c){
                return fmsTab.UI_Value__c;
            }
        }
        return '';
    }
   
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

        public addContactWrapper(String n, String p, String e) {
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

    public class AddStepPlanContWrapper{
        public String spname{get;set;}
        public String spemail{get;set;}
        public String spId{get;set;}
        public AddStepPlanContWrapper(String spname, String spemail, String spId) {
            this.spname = spname;
            this.spemail = spemail;
            this.spId = spId;
        }
    }
    
    
    public class MetallizationOptionWrapper{
        public String metalizationOption{get;set;}
        public String totWiringLevel{get;set;}
        public String lastWiringLevels{get;set;}
        public String featurePartNumbers{get;set;}
        
        public MetallizationOptionWrapper(String metalizationOption,String totWiringLevel,String lastWiringLevels,String featurePartNumbers){
            this.metalizationOption = metalizationOption;
            this.totWiringLevel = totWiringLevel;
            this.lastWiringLevels = lastWiringLevels;
            this.featurePartNumbers = featurePartNumbers;
        }                
    }
    

    public PageReference freezeForm() {
        if (validationCheckView(null)) {//Added by Abhita for Legacy form - 05092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Freeze Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = 'Frozen';
        formObj.Mandatory_State_Change_Comments__c = ''; 
        formObj.History_Time__c = null;
        try {
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formObj.Previous_State_Of_Form__c+' to '+formObj.State_of_the_Form__c));
            Device__c device = new Device__c(id=formObj.device__c,Stage__c='Tapeout');
            update device;
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'freezeForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return new PageReference('/apex/FMSmainFormViewPage?id=' + formObj.id);
    }

    public PageReference submitForm() {
        if (validationCheckView(null)) {//Added by Abhita for Legacy form - 05092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Submit Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = 'Submitted';
        formObj.Mandatory_State_Change_Comments__c = ''; 
        formObj.History_Time__c = null;
        try {
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formObj.Previous_State_Of_Form__c+' to '+formObj.State_of_the_Form__c));
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'submitForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return new PageReference('/apex/FMSmainFormViewPage?id=' + formObj.id);
    }

    public PageReference submitForQuote() {
        if (validationCheckView(null)) {//Added by Abhita for Legacy form - 05092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Submit for Quote} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = 'SubmittedForQuote';
        formObj.Mandatory_State_Change_Comments__c = '';
        formObj.History_Time__c = null;
        try {
            update formObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form state successfully changed from '+formObj.Previous_State_Of_Form__c+' to '+formObj.State_of_the_Form__c));
            
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'submitForQuote()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return new PageReference('/apex/FMSmainFormViewPage?id=' + formObj.id);
    }

    public pageReference createAddendumForm() {
        
        PageReference pgRef;
        
        if (validationCheckView('CreateAddendum')) {//Added by Abhita for Legacy form - 05092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Create addendum} as data integrity checks failed. Please edit the form and visit page to fix the issues.'));
        }
        else{        
            pgRef = new PageReference('/apex/FMSmainFormCreation');
            pgRef.getParameters().put('ParentId', formObj.id);
            pgRef.getParameters().put('tranx', 'Create');
            pgRef.getParameters().put('Type', 'Other');
            pgRef.getParameters().put('parentName', formObj.Name);
            pgRef.setRedirect(true);
        }
        return pgRef;
    }

    public List < SelectOption > getSelectAddendumValues() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('', FMS_SELECT_VAL));
        options.add(new SelectOption('IMC', FMS_IMC_FORM));
        options.add(new SelectOption('RIT', FMS_RIT_FORM));
        return options;
    }

    public PageReference makeFormInactive() {
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        if (formObj.State_of_the_Form__c == 'Submitted') {
            formObj.State_of_the_Form__c = 'InactiveSubmitted';
        } else if (formObj.State_of_the_Form__c == 'Draft') {
            formObj.State_of_the_Form__c = 'InactiveDraft';
        } else if (formObj.State_of_the_Form__c == 'Thawed') {
            formObj.State_of_the_Form__c = 'InactiveThawed';
        }else if(formObj.State_of_the_Form__c == 'SubmittedForQuote'){
            formObj.State_of_the_Form__c = 'InactiveSubmittedForQuote';
        }
        formObj.Mandatory_State_Change_Comments__c = '';
        formObj.History_Time__c = null;
        try {
            update formObj;
        }
        Catch(Exception e) {
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'makeFormInactive()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }
        PageReference pg = new PageReference('/apex/FMSmainFormViewPage');
        pg.getParameters().put('id', formObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', formObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference makeFormActive() {
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        if (formObj.State_of_the_Form__c == 'InactiveDraft') {
            formObj.State_of_the_Form__c = 'Draft';
        } else if (formObj.State_of_the_Form__c == 'InactiveSubmitted') {
            formObj.State_of_the_Form__c = 'Submitted';
        } else if (formObj.State_of_the_Form__c == 'InactiveThawed') {
            formObj.State_of_the_Form__c = 'Thawed';
        }else if(formObj.State_of_the_Form__c == 'InactiveSubmittedForQuote'){
            formObj.State_of_the_Form__c = 'SubmittedForQuote';
        }
        formObj.Mandatory_State_Change_Comments__c = '';
        formObj.History_Time__c = null;
        try {
            update formObj;           
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'makeFormActive()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSmainFormViewPage');
        pg.getParameters().put('id', formObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', formObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference requestToThawForm() {
        popupVal = false;
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = 'RequestToThaw';
        formObj.History_Time__c = null;
        try {
            update formObj;
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'requestToThawForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSmainFormViewPage');
        pg.getParameters().put('id', formObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', formObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference thawForm() {
        popupVal = false;
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = 'Thawed';
        formObj.History_Time__c = null;
        try {
            update formObj;
        }
        Catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'thawForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        PageReference pg = new PageReference('/apex/FMSmainFormViewPage');
        pg.getParameters().put('id', formObj.id);
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', formObj.State_of_the_Form__c);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference editForm() {
        PageReference pgRef = new PageReference('/apex/FMSmainFormCreationPg1');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference updateFormDetails() {
        PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put('tranx', 'Edit');
        pgRef.getParameters().put('Type', 'Main');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference copyAsNewForm() {
        PageReference pgRef = new PageReference('/apex/FMSDeviceSelectionPage');
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put('tranx', 'Copy');
        pgRef.getParameters().put('Type', 'Main');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
//20-7-2017 Ram Rai-Modified the method against Search and subscription logic
    public PageReference Subscribe() {
            
        Id userId = userinfo.getUserId();
        FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
        
        List<FMS_Subscription__c>  subscpList = new List<FMS_Subscription__c>(); 
        // Added the sharing for Subscription Object 1Sept2017         
        subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userId  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true) and Form_Id__c =:formObj.id and UnSubscribed_Date__c=null and Saved_Search_Id__c=null];            
        List < FMS_My_Subscription__c > fmsMySubList = [SELECT id, Name, Subscribed_All__c FROM FMS_My_Subscription__c where UserName__c = : userId];
        List < FMS_My_Subscription__c > fmsMySubList1 = new List < FMS_My_Subscription__c >();        
        
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
                    // Added the sharing for Subscription Object 1Sept2017 
                    fmsSubscribe = [select id, User_Name__c, User_Name__r.UserType from FMS_Subscription__c where id = :fmsSubscribe.id];
                    subscribeFlag = true;    //Ravindra - changed to display unsubscribed link on page. 
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
            
            PageReference pgRef = new PageReference('/apex/FMSmainFormViewPage?id=' + formObj.id);
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
                UtilityCls.saveExceptionLog(FMSmainFormEditController.class.getName(), 'UnSubscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            subscribeFlag = false;
        }
        PageReference pgRef = new PageReference('/apex/FMSmainFormViewPage?id=' + formObj.id);
        pgRef.getParameters().put('tranx', 'UnSubscribe');
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference SubscribeUser() {
        String PageURL = ApexPages.currentPage().getUrl();
        PageReference pgRef = new PageReference('/apex/FMSSubscribeOtherUserPage');  
        pgRef.getParameters().put('id', formObj.id); 
        pgRef.getParameters().put('baseURL', PageURL);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference deleteForm(){
        try {
            delete formObj;
        } catch (DMLException de) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getMessage()));
            return null;
        }
        PageReference pg1;
        String PageURL = ApexPages.currentPage().getUrl();
        if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                pg1 = new PageReference('/GlobalfoundryView/apex/FormManagementMainPage');
        }
        else{
            pg1 = new PageReference('/apex/FormManagementMainPage');
        }
        pg1.getParameters().put('tranx', 'delete');
        pg1.getParameters().put('delFormNum', formObj.Name);
        pg1.setRedirect(true);
        return pg1;
    }

    public PageReference continueCheck() {
        if (stateChangeComments == null || stateChangeComments == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please provide a brief description explaining the reason for this action - is a Required field'));
            return null;
        }
        formObj.Mandatory_State_Change_Comments__c = stateChangeComments;
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

    public boolean validationCheckView(String Type){//Added by Abhita for Legacy form - 05092017
        boolean val = false;
        //Added by Abhita for Legacy form - 05092017
        String formId;
        if(formObj != null && formObj.Name != null){
            formId= String.valueOf(formObj.Name);
        }
        if(formId != null && formObj.Id != null && formId.startsWith('1') && Type == 'CreateAddendum'){
            val = false;
        }
        else {//END -- Added by Abhita for Legacy form - 05092017
      if (formObj.HasReleaseGuidelines__c == '' || formObj.HasReleaseGuidelines__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Have you read and do you understand the Foundry Release Requirements? is a Required field'));
        val = true;
      }
      if (formObj.ProductName__c == '' || formObj.ProductName__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Product Name: is a Required field'));
        val = true;
      }
      if (formObj.ProductRevision__c == '' || formObj.ProductRevision__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Product Revision: is a Required field'));
        val = true;
      }
      if (formObj.ItarData__c == '' || formObj.ItarData__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product subject to the International Traffic in Arms Regulations (ITAR)? is a Required field'));
        val = true;
      }
      if (formObj.HazardousUse__c == '' || formObj.HazardousUse__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this Hazardous Use (HU): is a Required field'));
        val = true;
      }       
      if(isTFACompany){
        if(formObj.AssetProtectionCode__c == '' || formObj.AssetProtectionCode__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Asset Protection Code: is a Required field'));
          val = true;
        }
        if(formObj.MedicalDevice__c == '' || formObj.MedicalDevice__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product to be used in conjunction with a medical device?: is a Required field'));
          val = true;
        }
        if(formObj.NuclearDevice__c == null || formObj.NuclearDevice__c == ''){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this product to be used in conjunction with a nuclear application?: is a Required field'));
          val = true;
        }
        
        if(formObj.QuoteOnly__c == null || formObj.QuoteOnly__c == ''){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is this form for quote purposes only?: is a Required field'));
          val = true;
        }
      }
      if (formObj.Technology__c == '' || formObj.Technology__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Foundry Technology: is a Required field'));
        val = true;
      }
      if (formObj.ReleaseProcessFlow__c == '' || formObj.ReleaseProcessFlow__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Release Process: is a Required field'));
        val = true;
      }
      if (formObj.TestServices__c == '' || formObj.TestServices__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Test Services: is a Required field'));
        val = true;
      }
      if (formObj.Packaging_Services__c == '' || formObj.Packaging_Services__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Packaging Services: is a Required field'));
        val = true;
      }
      if (formObj.Chip_Interconnect__c == '' || formObj.Chip_Interconnect__c == null) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Chip Interconnect: is a Required field'));
        val = true;
      }
      if (formObj.TestServices__c != '' && formObj.TestServices__c != null && formObj.TestServices__c == 'Yes' && (formObj.TestLevels__c == '' || formObj.TestLevels__c == null)) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What test levels do you desire? is a Required field'));
        val = true;
      }
      if (dispIntConBumpServ && (formObj.IntConBumpSource__c == null || formObj.IntConBumpSource__c == '')) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is the Interconnect Bumping being sourced by GLOBALFOUNDRIES? is a Required field'));
        val = true;
      }
      if (((formObj.Technology__c == 'CSOI 7RF' && formObj.Packaging_Services__c == 'No' && formObj.TestServices__c == 'No') && (formObj.Chip_Interconnect__c == 'WLCSP-RDL' || formObj.Chip_Interconnect__c == 'WLCSP-BoP') && (formObj.IntConBumpSource__c == 'Yes' && formObj.QuoteOnly__c != 'Yes')) && (formObj.ChipEdgeWLCSP__c == null || formObj.ChipEdgeWLCSP__c == '')) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: GLOBALFOUNDRIES sourced WLCSP will be supported only if the PDK-supplied crackstop (Enhanced Crackstop) is present inside your design’s CHIPEDGE. Have you included the unmodified PDK-supplied crackstop within your design(s)? is a Required field'));
        val = true;
      }
      if(Page2 == 3 || Page2 == 2){
        if (String.valueOf(formObj.ProjectedTapeout__c) == null || String.valueOf(formObj.ProjectedTapeout__c) == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Projected GDS submission (tapeout) is a Required field'));
          val = true;
        }
         
        if (dispsourcingLocation && (formObj.SourcingLocation__c == null || formObj.SourcingLocation__c == FMS_SELECT_VAL)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your preferred sourcing location is a Required field'));
          val = true;
        }
        if (dispLastMetalUsed && (formObj.LastMetalUsed__c == null || formObj.LastMetalUsed__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Last Metal Used is a Required field'));
          val = true;
        }
        if (formObj.Waivers__c == null || formObj.Waivers__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will you require waivers for any DRC violations? is a Required field'));
          val = true;
        }
        if(String.isBlank(formObj.MetallizationOpts__c) && lstMetalWrapper.size()>1){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Metallization Option is a Required field'));
          val = true;
        }
        if (dispNumMetalLayers && (formObj.NumMetalLayers__c == null || formObj.NumMetalLayers__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total Number of Metal Layers is a Required field'));
          val = true;
        }
        if (dispPassivation && (formObj.Passivation__c == null || formObj.Passivation__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Passivation is a Required field'));
          val = true;
        }
        if(formobj.Technology__c != 'BiMOS P6' && formobj.Technology__c != 'BMSP6C9') {
          if (formObj.Custom_Features__c == null || formObj.Custom_Features__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any custom or development features that are not part of the base or optional features listings in the published design manual? is a Required field'));
            val = true;
          }
          if (formObj.Custom_Features__c == 'Yes' && (formObj.CustomFeaturesDesc__c == null || formObj.CustomFeaturesDesc__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list these non standard features: is a Required field'));
            val = true;
          }
          if (formObj.NotMfgFeatures__c == null || formObj.NotMfgFeatures__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does the Design contain any features that should NOT be manufactured for this program revision? is a Required field'));
            val = true;
          }
          if (formObj.NotMfgFeatures__c == 'Yes' && (formObj.NotMfgFeaturesDesc__c == null || formObj.NotMfgFeaturesDesc__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list all features that should be excluded from the build: is a Required field'));
            val = true;
          }
        }
        if (dispStepPlanCustReq && (formObj.StepPlanCustomRequirement1__c == null || formObj.StepPlanCustomRequirement1__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will your orders be placed for wafer quantity, with wafer functional test as a service-only adder?: is a Required field'));
          val = true;
        }
        if (dispDataCheckingOpts && (formObj.DataCheckingOptions__c == null || formObj.DataCheckingOptions__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Data Checking Options: is a Required field'));
          val = true;
        }
        if (formObj.ServiceOptions__c == null && formObj.ServiceOptions__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Service Options: is a Required field'));
          val = true;
        }
        if (dispOtherServiceFeatures && (formObj.OtherServiceFeatures__c == null || formObj.OtherServiceFeatures__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other service features: is a Required field'));
          val = true;
        }
        if (formObj.DesignSubmission__c == null || formObj.DesignSubmission__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Type Of Design Submission: is a Required field'));
          val = true;
        }
        if (formObj.Deliverable__c == null || formObj.Deliverable__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Deliverable: is a Required field'));
          val = true;
        }
        if (formObj.Premerge__c == null || formObj.Premerge__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does this design data submission contain any premerged design(s)? is a Required field'));
          val = true;
        }
        if (dispDeliverableSplit && (formObj.DeliverableSplit__c == '' || formObj.DeliverableSplit__c == null)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are you expecting more than one deliverable (splits) from this single GDS? is a Required field'));
          val = true;
        }       
        if (dispBacksideGrindThickness && (formObj.BacksideGrindThickness__c == null || formObj.BacksideGrindThickness__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please choose a Backside Grind Thickness: is a Required field'));
          val = true;
        }
        if (dispCll && (formObj.CLL__c == null || formObj.CLL__c == 'renderDeliverableSplit')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select Custom Lot Labeling (CLL) and Laser Scribe Requirements: is a Required field'));
          val = true;
        }       
        if (dispNonStandardCll && (formObj.NonstandardCLL__c == null || formObj.NonstandardCLL__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Describe your Non-standard CLL Laser Scribe Area Requirements: is a Required field'));     
          val = true;
        }
        if (dispShippingLabelCLL && (formObj.ShippingLabelCLL__c == null || formObj.ShippingLabelCLL__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Identify your Shipping Label Customer Part Number for CLL: is a Required field'));
          val = true;
        }
        if((formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && dispFinalPassivation && formObj.Packaging_Services__c == 'No' 
          && ((formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)') || ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
          || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'LV (01L6998)' 
          && formObj.Chip_Interconnect__c == 'C4 flip chip'))) && (formObj.FinalPassivation__c == null || formObj.FinalPassivation__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require final passivation films in the front side scribe region?: is a Required field'));
          val = true;
        }
        if((formObj.QuoteOnly__c != 'Yes' && formObj.Technology__c == 'CSOI 7RF' && dispLineFront && formObj.Packaging_Services__c == 'No' 
          && ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') 
          && formObj.Passivation__c == 'SZ - No Polyimide (LV drawn) (84Y6986)' && formObj.Chip_Interconnect__c == 'C4 flip chip') 
          || (formObj.LastMetalUsed__c == 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)' && formObj.Passivation__c == 'FV - Polyimide only (84Y8379)' 
          && formObj.FinalPassivation__c == 'Yes; 4X FV SHIFT (84Y8783)') || ((formObj.LastMetalUsed__c == 'AM (Analog Last Metal) (AM, FT, MT) (70P5485)' 
          || formObj.LastMetalUsed__c == 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)') && formObj.Passivation__c == 'LV (01L6998)' 
          && formObj.Chip_Interconnect__c == 'C4 flip chip' && formObj.FinalPassivation__c == 'Yes; 4X LV SHIFT (84Y8784)')) 
          && (formObj.LineFront__c == null || formObj.LineFront__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require 2 line front side scribe?: is a Required field'));
          val = true;
        }         
        if (dispChipEdgeDesign && (formObj.Chipedgedesign__c == null || formObj.Chipedgedesign__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: GLOBALFOUNDRIES sourced dicing will be supported only if the PDK-supplied crackstop is present inside your design(s) CHIPEDGE. Have you included the unmodified PDK-supplied crackstop within your design(s)?: is a Required field'));
          val = true;
        }       
        if (dispNumThickLevels && (formObj.NumThickCuLevels__c == null || formObj.NumThickCuLevels__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of Thick Cu Levels: is a Required field'));
          val = true;
        }
        if ((formObj.QuoteOnly__c != 'Yes' && (formObj.Technology__c == 'BiCMOS 8WL (SiGe 8WL)' || formObj.Technology__c == 'CSOI8SW')) && (formObj.Wiringoptions__c == null || formObj.Wiringoptions__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wiring Options: is a Required field'));
          val = true;
        }       
        if ((formObj.Technology__c == 'CNV8SFi') && (formObj.DesignDelivered__c == null || formObj.DesignDelivered__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What format will the design be delivered in?: is a Required field'));
          val = true;
        }
        if (formObj.Technology__c == 'BiCMOS 8HP (SiGe 8HP)' && (formObj.EnhancedWiring__c == null || formObj.EnhancedWiring__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Enhanced Cu Wiring: is a Required field'));
          val = true;
        }
        if (dispPassivation1 && (formObj.Passivation1__c == null || formObj.Passivation1__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Through-Silicon Via: is a Required field'));
          val = true;
        }         
        if (dispStepPlanCustReq && formObj.StepPlanCustomRequirement1__c == 'No' && (formObj.StepPlanCustomRequirementInput1__c == null || formObj.StepPlanCustomRequirementInput1__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please explain how your orders will be placed: is a Required field'));
          val = true;
        }        
      
        if((formObj.Technology__c != '' && formObj.Technology__c != null && formObj.Technology__c != '--None--') && (formObj.MetallizationOpts__c == null || formObj.MetallizationOpts__c == '') && Environment_Variable__c.getInstance('METALLIZATIONOPT_TECH').Value__c.contains(formObj.Technology__c) ){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Metallizations: is a Required field'));
          val = true;    
        }
        if(formObj.ReleaseProcessFlow__c == 'Original Flow' && (getconfigData()==null || isTechnologyConfigured==null || mapTabPOGs==null  
          || sectionsByTab==null || optionsBy_POG_Ids==null) && isTechVisible){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Technology Features inside Configurator are Required.'));
          val = true;
        }
        
      }    

      if(Page3 == 3 || Page3 == 4) {
        /*if(isTFACompany && formObj.DesignSubmission__c != null && formObj.DesignSubmission__c != '' && (formObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' 
          || formObj.DesignSubmission__c == 'Multi-Chiplet Design (one GDS, single Topcell)') && (formObj.ECCN_attachmentName__c == null 
          || String.valueOf(formObj.ECCN_attachmentName__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select ECCN Layout file'));
          val = true;
        }*/
        
        if (formObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' && (formObj.NumOfDesigns__c == null || String.valueOf(formObj.NumOfDesigns__c) == '')) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What is the total number of Topcells that will be submitted for this program? is a Required field'));
          val = true;
        }
        if (formObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' && (formObj.NumOfFEOLDesigns__c == null || String.valueOf(formObj.NumOfFEOLDesigns__c) == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Front End of Line (precontact) designs: is a Required field'));
          val = true;
        }
        if (formObj.DesignSubmission__c == 'Multi-Design Reticle (>1 Topcell)' && (formObj.NumOfBEOLDesigns__c == null || String.valueOf(formObj.NumOfBEOLDesigns__c) == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Number of unique Back End of Line (Metal) designs: is a Required field'));
          val = true;
        }
        if((formObj.DesignSubmission__c != 'Multi-Design Reticle (>1 Topcell)' && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && formObj.QuoteOnly__c != 'No')) && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && isTFACompany))) && (formObj.DieXSize__c == null || String.valueOf(formObj.DieXSize__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Final Chip Size x (mm): is a Required field'));
          val = true;
        }
        if((formObj.DesignSubmission__c != 'Multi-Design Reticle (>1 Topcell)' && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && formObj.QuoteOnly__c != 'No')) && (!(formObj.ReleaseProcessFlow__c == 'Enhanced Flow' && isTFACompany))) && (formObj.DieYSize__c == null || String.valueOf(formObj.DieYSize__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Final Chip Size y (mm): is a Required field'));
          val = true;
        }
        if (formObj.Packaging_Services__c == 'Yes' && formObj.Technology__c != '--None--' && (formObj.MaxChipPower__c == null || formObj.MaxChipPower__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Max Chip Power: is a Required field'));
          val = true;
        }   
        if(dispCircuitType && (formObj.CircuitType__c == null || formObj.CircuitType__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Circuit Type: is a Required field'));
          val = true;
        }       
        if(dispC4PadLayout && (formObj.C4PadLayout__c == null || formObj.C4PadLayout__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Pad/Bump Pitch: is a Required field'));
          val = true;
        }
        if(dispC4PadLayoutForDRC && (formObj.C4PadLayoutForDRC__c == null || formObj.C4PadLayoutForDRC__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Pad/Bump Pitch used for DRC? is a Required field'));
          val = true;
        }
        if (dispNumC4Pads && (formObj.NumC4Pads__c == null || String.valueOf(formObj.NumC4Pads__c) == '')) { 
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total number of active and dummy pads: is a Required field'));
          val = true;
        }
        if (dispC4SolderMaterial && (formObj.C4SolderMaterial__c == null || formObj.C4SolderMaterial__c == '')) {      
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: C4 Solder Material: is a Required field'));
          val = true;
        }
        if (dispPinOneID && (formObj.PinOneID__c == null || formObj.PinOneID__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: How are you identifying pin one to IBM: is a Required field'));
          val = true;
        }
        if (formObj.IpIdentification__c == null || formObj.IpIdentification__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Does your design(s) contain any IP that requires identification? is a Required field'));
          val = true;
        }
        if (dispDesignKitOthers && (formObj.DesignKitOthers__c == null || formObj.DesignKitOthers__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please list the IP Provider Name and Library(s) contained within your design(s). Examples of providers: ARM, ASIC North, IBM, Novocell, Synopsys, etc.: is a Required field'));
          val = true;
        }       
        if (dispadditionalComments && (formObj.AdditionalComments__c == null || formObj.AdditionalComments__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List additional information here: is a Required field'));
          val = true;
        }
        if (dispC4LaminatePackage && (formObj.C4LaminatePkg__c == null || formObj.C4LaminatePkg__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will you be using a laminate package?: is a Required field'));
          val = true;
        }
        if (dispOtherC4PadLayout && (formObj.OtherC4PadLayout__c == null || formObj.OtherC4PadLayout__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other (microns): is a Required field'));
          val = true;
        }

        if (dispWirebondLayout && (formObj.WireBondLayout__c == null || formObj.WireBondLayout__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wirebond Layout: is a Required field'));
          val = true;
        }

        if (dispWirebondPad && (formObj.WireBondPad__c == null || String.valueOf(formObj.WireBondPad__c) == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total number of active and dummy Wirebond pads?: is a Required field'));
          val = true;
        }
        
        if (dispWireBondPadPitch && (formObj.WireBondPadPitch__c == null || String.valueOf(formObj.WireBondPadPitch__c) == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Wirebond Pad Pitch (microns): is a Required field'));
          val = true;
        }
        
        if(dispStepPlanSection && (formObj.StepPlanEducation__c == null || String.valueOf(formObj.StepPlanEducation__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Have you read and do you understand the Step Plan Education Package?'));
          val = true;
        }
        if(dispStepPlanSection && dispInputMethod && (formObj.InputMethod__c == null || formObj.InputMethod__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your step plan input Methodology:'));
          val = true;
        }
        if(dispStepPlanSection && formObj.InputMethod__c == 'Advanced Process: Inputs via XML file attachment.' 
          && (formObj.AdvancedProcessFileAttachment__c == null || String.valueOf(formObj.AdvancedProcessFileAttachment__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select Reticle Layout XML file'));
          val = true;
        }
        if(dispStepPlanSection && formObj.InputMethod__c == 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment' 
          && (formObj.FileAttachment__c == null || String.valueOf(formObj.FileAttachment__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select Reticle Layout Information'));
          val = true;
        }
        if(dispStepPlanSection && formObj.DesignSubmission__c != 'Multi-Design Reticle (>1 Topcell)' && formobj.Technology__c != '32SOI' 
          && formObj.InputMethod__c != 'Advanced Process: Inputs via XML file attachment.' && (formobj.StepPlanChipRotation__c == null
          || formobj.StepPlanChipRotation__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select chip design rotation. Rotation value selected is counter-clockwise with chip origin (0,0) in lower left corner.'));
          val = true;
        }
        if(dispStepPlanSection && dispCrackOptions && (formObj.CrackstopOptions__c == null || formObj.CrackstopOptions__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Crackstop methodology:'));
          val = true;
        }
        if(dispStepPlanSection && dispChannelType && (formObj.Channel_Type__c == null || formObj.Channel_Type__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Dicing Channel type:'));
          val = true;
        }
        if(dispStepPlanSection && dispDicingPref && (formObj.ChannelStdOnly__c == null || formObj.ChannelStdOnly__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Select your Dicing Channel preference:'));
          val = true;
        }
        if(dispStepPlanSection && formObj.DesignSubmission__c != '' && formObj.DesignSubmission__c != null && formObj.Packaging_Services__c == 'No' 
          && (!formObj.ServiceOptions__c.contains('Dicing')) && (formObj.Channel_Type__c != 'Compare Standard and SPD channels for optimal CPW' || dispDicingPref)
          && formObj.VerticalX__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify your preferred Dicing Channel width X (um):'));
          val = true;
        }
        if(dispStepPlanSection && formObj.DesignSubmission__c != '' && formObj.DesignSubmission__c != null && formObj.Packaging_Services__c == 'No' 
          && (!formObj.ServiceOptions__c.contains('Dicing')) && (formObj.Channel_Type__c != 'Compare Standard and SPD channels for optimal CPW' || dispDicingPref)
          && formObj.HorizontalY__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify your preferred Dicing Channel width Y (um):'));
          val = true;
        }
        if(dispStepPlanSection && formObj.Packaging_Services__c == 'No' && (!formObj.ServiceOptions__c.contains('Dicing'))
          && formObj.Channel_Type__c == 'Compare Standard and SPD channels for optimal CPW' && (formObj.CompareChannels__c == null || formObj.CompareChannels__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Specify the Dicing Channel widths (X,Y) to be used for the comparison:'));
          val = true;
        }
        if(dispStepPlanSection && formObj.Packaging_Services__c == 'No' && (!formObj.ServiceOptions__c.contains('Dicing'))
          && (formObj.StepPlanEdgeField__c == null || formObj.StepPlanEdgeField__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is Enhanced Edge Field Stepping required for improved chips-per-wafer?'));
          val = true;
        }
        if(dispStepPlanSection && dispDicingMarks && (formObj.DiceMarks__c == null || formObj.DiceMarks__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you require dice marks placed in the GLOBALFOUNDRIES-placed DICING CHANNELS?'));
          val = true;
        }
        if(dispStepPlanSection && (formObj.StepPlanCustomRequirement__c == null || formObj.StepPlanCustomRequirement__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Do you have any custom step plan requirements not outlined above?'));
          val = true;
        }
        if(dispStepPlanSection && formObj.StepPlanCustomRequirement__c == 'Yes' && (formObj.StepPlanCustomRequirementInput__c == null 
          || formObj.StepPlanCustomRequirementInput__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: List custom requirements here:'));
          val = true;
        }
        if(dispStepPlanSection && contDicing && formObj.Packaging_Services__c == 'No' && addStepPlanList.isEmpty()){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Atlease one Step Plan Approver user is required'));
          val = true;
        }       
        if (dispPickMap && (formObj.PickMap__c == null || formObj.PickMap__c == '')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Are you ordering an Untested Pick-All Wafer Map (Default Map)?: is a Required field'));
          val = true;
        }
      }

      if(Page4 == 4 || Page4 == 5){
        if (formObj.WorstCaseTj__c == null || formObj.WorstCaseTj__c == '') {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Maximum Tj:is a Required field'));
          val = true;
        }
      }

      if(Page5 == 5 || Page5 == 6) {
        if (formObj.Packaging_Services__c == 'Yes') {
          if (formObj.PackageRequirement__c == null || formObj.PackageRequirement__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Package Requirements: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.PackageType__c == null || formObj.PackageType__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Package Type needed (Click the Help icon to view the descriptions): is a Required field'));
            val = true;
          }           
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && formObj.PackageType__c == 'Other' && (formObj.PackageTypeOther__c == null || formObj.PackageTypeOther__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (formObj.SID__c == null || formObj.SID__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: SID or IBM Part Number: is a Required field'));
            val = true;
          }
          if (String.valueOf(formObj.ModulePowerMax__c) == null || String.valueOf(formObj.ModulePowerMax__c) == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Module Power (Max): is a Required field'));
            val = true;
          }
          if (formObj.Cooling__c == null || formObj.Cooling__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Cooling: is a Required field'));
            val = true;
          }
          if (formObj.Cooling__c == 'Other' && (formObj.CoolingOther__c == null || formObj.CoolingOther__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
            val = true;
          }
          if (formObj.Cooling__c == 'Cross Flow' && (String.valueOf(formObj.CrossFlowIFPM__c) == null || String.valueOf(formObj.CrossFlowIFPM__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Cross Flow (feet/min): is a Required field'));
            val = true;
          }
          if (formObj.LifetimePOH__c == null || formObj.LifetimePOH__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Lifetime Power On Hours: is a Required field'));
            val = true;
          }
          if (formObj.LifetimePOH__c == 'Other' && (formObj.LifetimePOHOther__c == null || formObj.LifetimePOHOther__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
            val = true;
          }
          if (formObj.DiffPairRequired__c == 'Yes' && (String.valueOf(formObj.NoOfDiffPairs__c) == null || String.valueOf(formObj.NoOfDiffPairs__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: How many: is a Required field'));
            val = true;
          }
          if (formObj.ModuleType__c == '' || formObj.ModuleType__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Is the package a single chip module or a multichip module?: is a Required field'));
            val = true;
          }
          if (formObj.ModuleType__c == 'Multi-Chip Module' && (formObj.MultiChipDetails__c == null || formObj.MultiChipDetails__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: If multichip, provide additional details: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (String.valueOf(formObj.ModulePinsBallsTotal__c) == null || String.valueOf(formObj.ModulePinsBallsTotal__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Total: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (String.valueOf(formObj.ModulePinsBallsSignal__c) == null || String.valueOf(formObj.ModulePinsBallsSignal__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Signal: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (String.valueOf(formObj.ModulePinsBallsPower__c) == null || String.valueOf(formObj.ModulePinsBallsPower__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Power is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (String.valueOf(formObj.ModulePinsBallsGround__c) == null || String.valueOf(formObj.ModulePinsBallsGround__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Ground: is a Required field'));
            val = true;
          }
          if (formObj.PackageRequirement__c == 'Customer Existing Package' && (String.valueOf(formObj.ModulePinsBallsUnused__c) == null || String.valueOf(formObj.ModulePinsBallsUnused__c) == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Unused: is a Required field'));
            val = true;
          }
          if (formObj.ModuleDecouplingCapacitors__c == 'Yes' && formObj.CapacitanceValue__c == 'Other' && (formObj.CapacitanceValueOther__c == null || formObj.CapacitanceValueOther__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field'));
            val = true;
          }
          if (formObj.ProductShipReq__c == 'Other' && (formObj.ProductShipReqOther__c == null || formObj.ProductShipReqOther__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Other: is a Required field '));
            val = true;
          }                
        }
      }

      if(Page2TFA == 2 && !readOnlyCheck){
        if(dispWireBondSplit && (formObj.WireBondSplit__c == null || formObj.WireBondSplit__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be a wirebond split? is a Required field'));
          val = true;
        }
        if(dispWireBondSplitTAT && (formObj.WireBondSplitTAT__c == null || formObj.WireBondSplitTAT__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What Turnaround time do you need for the wirebond split? is a Required field'));
          val = true;
        }
        if(dispWireBondSplitTAT && (formObj.WireBondWaferReq__c == null || formObj.WireBondWaferReq__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What are your wafer requirements for wirebond wafers? is a Required field'));
          val = true;
        }
        if(dispWireBondSplit && (formObj.C4Split__c == null || formObj.C4Split__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be a C4 split? is a Required field'));
          val = true;
        }
        if(dispC4SplitTAT && (formObj.C4SplitTAT__c == null || formObj.C4SplitTAT__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What Turnaround time do you need for the C4 split? is a Required field'));
          val = true;
        }
        if(dispC4SplitTAT && (formObj.C4WaferReq__c == null || formObj.C4WaferReq__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: What are your wafer requirements for C4 wafers? is a Required field'));
          val = true;
        }
        if(dispWireBondSplit && (formObj.OtherSplits__c == null || formObj.OtherSplits__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Will there be any other splits? is a Required field'));
          val = true;
        }
        if(dispOtherSplitDepts && (formObj.OtherSplitDets__c == null || formObj.OtherSplitDets__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please explain splits and their requirements: is a Required field'));
          val = true;
        }
        if(dispITARCategory && (formObj.ItarCategory__c == null || formObj.ItarCategory__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ITAR Category: is a Required field'));
          val = true;
        }
        if(dispClientResponseDt && (formObj.ClientResponseDt__c == null || String.valueOf(formObj.ClientResponseDt__c) == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Client Requested Quote Response Date: is a Required field'));
          val = true;
        }           
        if((formObj.NeedBizComment__c == 'Yes' && dispNeedBizComment) && (formObj.BusinessComments__c == null || formObj.BusinessComments__c == '')){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Client Requested Quote Response Date: is a Required field'));
          val = true;
        }            
      }
        }//Added by Abhita for Legacy form - 05092017
        return val;
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

    public PageReference openPDF(){
        PageReference pgRef = new PageReference( '/apex/FMSmainFormViewPrintPDF?id='+formObj.id);        
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
        //Added the Defect Fix for History Issue
        return UtilityCls.changeHistory(formObj);
    }  

}