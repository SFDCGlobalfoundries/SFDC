/*@class: FMSRITFormEditController
@CreatedBy: Inshu Misra
@CreatedDate: 20 Feb, 2017
@Description: Controller for FMS RIT Form...#IM
Modification History:
* 13-Oct-2016  Inshu Misra       Save button function modification 
* 23-Nov-2016  Inshu Misra       to send emails when save button is clicked...#IM
* 6-Dec-2016   Inshu Misra       Added code for exception framework...#IM
* 10-Feb-2017   Inshu Misra      to avoid validation on save button click...#IM
* 16-Feb-2017   Inshu Misra      Added code for RIT form files issue
* 31-May-2017   Inshu Misra      Modified the controller for RIT DropBox Integration...#IM
* 2-Jun-2017    Inshu Misra      Added sender info to packages...#IM
* 8-Jun-2017    Inshu Misra      Bug fix...#232, 249, 251, 252, 253, 254, 257 and 258...#IM
* 13-Jul-2017   Abhita Bansal    Modified the code for UAT Issue #434, 435, 436, 438, 439, 442, 458, 459, 460, 464,468, 469, 316
* 13-Jun-2017    Inshu Misra      Bug fix...#249, 251, 285, 288, 292, 295, 297, 298 and 299...#IM
* 22-Jun-2017    Inshu Misra      Bug fix...#300, 301, 303, 304, 313, 314, 372...#IM
* 24-Jun-2017    Inshu Misra      Bug fix...#374, 375, 376...#IM
* 27-Jun-2017    Inshu Misra      Bug fix related to variable invocation...#IM
* 13-Jul-2017    Inshu Misra      Bug fix...#296, 461...#IM
* 14-Jul-2017  Inshu Misra     Changed the code for history report
* 20-Jul-2017  Ram Rai       Changed the code for step plan search/subscription logic
^ 25-Aug-2017  Ravindra     Changed the document links to libraries
*01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue
*/
public class FMSRITFormController {
    //page1 starts 
    public String pageN {get;set;}
    public Map<Id,FMS_RIT_Drop_Box__c> listToDelete;
    public Map<String, packageWrapper> packWrapper{get;set;}
    
    public List<packageWrapper> navPackWrapperMap{
        get{
            if(navPackWrapperIdMap != null && !navPackWrapperIdMap.isEmpty()){
                navPackWrapperMap = navPackWrapperIdMap.get(selPage);
            }else{
                navPackWrapperMap = new List<packageWrapper>();
            }
            return navPackWrapperMap;
        }
        set; 
    }
    private Map<Integer, List<packageWrapper>> navPackWrapperIdMap{
        get{
            return obj.ListRequested;
        }
        set;
    }
    public List<packageWrapper> navPackWrapper{
        get{
            List<packageWrapper> pack;
            if(navPackWrapper == null || navPackWrapper.isEmpty()){
                pack = new List<packageWrapper>();
                if(navPackWrapperIdMap != null && !navPackWrapperIdMap.isEmpty()){
                    for(List<packageWrapper> packages: navPackWrapperIdMap.values()){
                        pack.addAll(packages);
                    }
                }       
            }else{
                pack=navPackWrapper;
            }
            pack.sort();
            return pack;
        }
        set;
    }
    private List<packageWrapper> packWrapperList{get;set;}
    public Form_Management_System__c formObj{get;set;}
    public Integer rowNum{get;set;} 
    public String formId{get;set;}
    public Integer pageNum{get;Set;}
    public boolean next{get;set;}
    private boolean skipvalidation{get;set;}
    public List<string> holdReason{get;set;}
    public Integer totPageNum;  
    public String soldTo {get;set;}
    public Map<String, String> FMSdocuments {get;set;}   //Added by Ravindra
    private boolean exitForm{get;set;}   
    private Map<String,String> invalidInputCheckMap = new Map<String,String>();
    private boolean isInvalidInp{get;set;}
    private Map<String,String> invalidInpToFieldsMap = new Map<String, String>();
    public Boolean showReadOnlyView{get;set;}
    public Boolean showEditView{get;set;}
    public Boolean showPackage{get;set;}
    public Boolean showCallOutExMessage{get;set;}
    private CustomIterable obj{get;set;}
    public Integer selPage{get;set;}
    public Boolean disPostDesign {get;set;}
    public Integer numberOfPages{
        get{
            return obj.numberOfPages;
        }
        set;
    }
    //page1 ends
    
    //page2 starts
    public String comFileToIdList{get;set;}    
    //page2 ends
    
    //viewpage starts
    public String requestMsg{get;set;}
    public boolean popupVal{get;set;}
    public boolean popupCreateAdd{get;set;}
    public boolean isFMSAdmin{get;set;}
    public boolean isPortalUser{get;set;}
    public boolean showMessage {get;set;}
    public String stateChangeComments{get;set;}
    public String selCreateAddendum{get;set;}
    private String userType = Schema.SObjectType.User.getKeyPrefix();
    private map<String, Id> mapRecordTypeIdName;
    private Set<Id> grpUsers;
    private List<FMS_Subscription__c> fmsSubscriptionList;
    private FMS_Subscription__c fmsSubscription;
    public boolean subscribeFlag{get;set;}
    public boolean validateCheck{get;set;}
    private String holdPreviousStateVal{get;set;}
    public boolean showMainTable {get;set;}
    public boolean hasChildren {get;set;}//Added by Abhita for UAT Issue #433, 434
    public String tranx;//Added by Abhita for UAT Issue #433, 434
    public String deleteId;//Added by Abhita for UAT Issue #433, 434
    public String SubmssnMessg {get;set;}
    //viewpage ends
    
    private String mainrecTypeId;
    private String desrecTypeId;
    private String toprecTypeId;
    public Boolean selCheckExtReport{get;set;}
    public Boolean selExtMessage{get;set;}
    public Boolean num1Sel{
        get{
            return num1==selPage;
        }
        set;
    }
    public Boolean num2Sel{    
        get{
            return num2==selPage;
        }
        set;
    }
    public Boolean num3Sel{
        get{
            return num3==selPage;
        }
        set;
    }
    public String curPage{get;set;}
    
    private final String Final_Submission = EnvironmentVariable.get('FMS_RIT_FINAL_SUB');
    private final String Preliminary_Features_Extraction_Report = EnvironmentVariable.get('FMS_PRELIM_FEAT_EXT_REP');
    private final String Enhanced_Flow = EnvironmentVariable.get('FMS_ENHANCED_FLOW');
    private final String account1 = EnvironmentVariable.get('FMS_SAP_ACC_NO14');
    private final String account2 = EnvironmentVariable.get('FMS_SAP_ACC_NO12');
    private static final String FMS_RIT_Drop_Box_Obj = EnvironmentVariable.get('FMS_RIT_Drop_Box_Obj');
    private final String Select_A_Value = EnvironmentVariable.get('FMS_SELECT_VALUE');
    private final String Yes = EnvironmentVariable.get('FMS_YES');
    private final String No = EnvironmentVariable.get('FMS_NO');
    
    private final String Apex_FMSRITFormViewPage = EnvironmentVariable.get('FMS_APEX_FMSRITFormViewPage');
    private final String Other = EnvironmentVariable.get('FMS_OTHER');
    private final String RIT = EnvironmentVariable.get('FMS_RIT_FORM_SHRT');
    private final String Apex_FMSmainFormCreation = EnvironmentVariable.get('FMS_APEX_FMSmainFormCreation');
    private final String Error_StateChangeReason = EnvironmentVariable.get('FMS_Error_StateChangeReason');
    private final String Apex_FMSRITFormNewEditPage1 = EnvironmentVariable.get('FMSApex_FMSRITFormNewEditPage1');
    private final String Apex_FMSCopyForms = EnvironmentVariable.get('FMSApex_FMSCopyForms');
    private final String Main_Form = EnvironmentVariable.get('FMS_MAIN_FORM');
    private final String GFV_FMSmainFormViewPage = EnvironmentVariable.get('FMSGFV_FMSmainFormViewPage');
    private final String GFV_FMSIMCFormViewPage = EnvironmentVariable.get('FMSGFV_FMSIMCFormViewPage');
    private final String Apex_FMSRITFormViewPage_Id = EnvironmentVariable.get('FMSApex_FMSRITFormViewPage_Id');
    private final String Apex_FMSIMCFormViewPage_Id = EnvironmentVariable.get('FMSApex_FMSIMCFormViewPage_Id');
    private final String SubmitForm = EnvironmentVariable.get('FMS_SubmitForm');
    private final String SubmitToProcess = EnvironmentVariable.get('FMS_SubmitToProcess');
    private final String RTMProceed = EnvironmentVariable.get('FMS_RTMProceed');
    private final String ProceedToRTM = EnvironmentVariable.get('FMS_ProceedToRTM');
    private final String RTMComplete = EnvironmentVariable.get('FMS_RTMComplete');
    private final String PreliminaryComplete = EnvironmentVariable.get('FMS_PreliminaryComplete');
    private final String PreliminaryRequestAccepted = EnvironmentVariable.get('FMS_PreliminaryRequestAccepted');
    private final String HoldRTMforClientDecision = EnvironmentVariable.get('FMS_HoldRTMforClientDecision');
    private final String Returned = EnvironmentVariable.get('FMS_Returned');
    private final String Cancelled = EnvironmentVariable.get('FMS_Cancelled');
    private final String DDR_Form = EnvironmentVariable.get('FMS_DDR_FORM');
    private final String CreateAddendum = EnvironmentVariable.get('FMS_CreateAddendum');
    private final String Error_ReleaseAutomationTraining = EnvironmentVariable.get('FMS_Error_ReleaseAutomationTraining');
    private final String Error_GovernmentInformation = EnvironmentVariable.get('FMS_Error_GovernmentInformation');
    private final String Error_Waiver = EnvironmentVariable.get('FMS_Error_Waiver');
    private final String Error_TypeOfDataSubmission = EnvironmentVariable.get('FMS_Error_TypeOfDataSubmission');
    private final String Error_IsPurge = EnvironmentVariable.get('FMS_Error_IsPurge');
    private final String Error_PurgeMapFile = EnvironmentVariable.get('FMS_Error_PurgeMapFile');
    private final String Error_PurchaseOrder = EnvironmentVariable.get('FMS_Error_PurchaseOrder');
    private final String Error_RITHold = EnvironmentVariable.get('FMS_Error_RITHold');
    private final String Error_HoldReason = EnvironmentVariable.get('FMS_Error_HoldReason');
    private final String Error_OtherReason = EnvironmentVariable.get('FMSError_OtherReason');
    private final String Error_PostDesignService = EnvironmentVariable.get('FMSError_PostDesignService');
    private final String Error_GdsSubset = EnvironmentVariable.get('FMSError_GdsSubset');
    private final String Error_LeftXCoordinate = EnvironmentVariable.get('FMSError_LeftXCoordinate');
    private final String Error_LeftYCoordinate = EnvironmentVariable.get('FMSError_LeftYCoordinate');
    private final String Error_RightXCoordinate = EnvironmentVariable.get('FMSError_RightXCoordinate');
    private final String Error_RightYCoordinate = EnvironmentVariable.get('FMSError_RightYCoordinate');
    private final String Error_IsArchive = EnvironmentVariable.get('FMSError_IsArchive');
    private final String Error_IsTopcell = EnvironmentVariable.get('FMSError_IsTopcell');
    private final String Apex_FMSSubscribeOtherUserPage = EnvironmentVariable.get('FMSApex_FMSSubscribeOtherUserPage');
    private final String baseURL = EnvironmentVariable.get('FMSbaseURL');
    private final String Apex_FMSRITFormViewPrintPDFId = EnvironmentVariable.get('FMSApex_FMSRITFormViewPrintPDFId');
    private final String GFV_FormManagementMainPage = EnvironmentVariable.get('FMSGFV_FormManagementMainPage');
    private final String Apex_FormManagementMainPage_TabName = EnvironmentVariable.get('FMSApex_FormManagementMainPage_TabName');
    private final String Error_CreateAddendum = EnvironmentVariable.get('FMSError_CreateAddendum');
    private final String Error_InputFormat = EnvironmentVariable.get('FMSError_InputFormat');
    private final String Error_SelectOneFile = EnvironmentVariable.get('FMSError_SelectOneFile');
    private final String page1 = EnvironmentVariable.get('FMSpage1');
    private final String page2 = EnvironmentVariable.get('FMSpage2');
    private final String page3 = EnvironmentVariable.get('FMSpage3');
    private final String Error_FileType = EnvironmentVariable.get('FMSError_FileType');
    private final String Design_File = EnvironmentVariable.get('FMSDesign_File');
    private final String Error_SelectoneDesignFile = EnvironmentVariable.get('FMSError_SelectoneDesignFile') + ' ';
    private final String LeftXCoordinate = EnvironmentVariable.get('FMSLeftXCoordinate');
    private final String LeftYCoordinate = EnvironmentVariable.get('FMSLeftYCoordinate');
    private final String RightXCoordinate = EnvironmentVariable.get('FMSRightXCoordinate');
    private final String RightYCoordinate = EnvironmentVariable.get('FMSRightYCoordinate');
    private final String Apex_FMSRITFormNewEditPage = EnvironmentVariable.get('FMSApex_FMSRITFormNewEditPage');
    private final String Design = EnvironmentVariable.get('FMSDesign');
    private final String Top_Cell = EnvironmentVariable.get('FMStopCell');
    private final String Save_Message = EnvironmentVariable.get('FMSSave_Message');
    private final String Main = EnvironmentVariable.get('FMS_MAIN_FORM_SHRT');
    private final String FMS_Admin_Group = EnvironmentVariable.get('FMS_Admin_Group');
    private final String Standard = EnvironmentVariable.get('FMSStandard');
    private static final String Selected_Files = ' '+EnvironmentVariable.get('FMSSelected_Files');
    private static final String Selection_Not_Possible_Message = EnvironmentVariable.get('FMSSelection_Not_Possible_Message');
    private final String TRUE_STR = EnvironmentVariable.get('FMSTRUE_STR');
    private final String Create_STR = EnvironmentVariable.get('FMSCreate_STR');
    private final String Edit_STR = EnvironmentVariable.get('FMSEdit_STR');
    private final String GFV_STR = EnvironmentVariable.get('FMSGFV_STR');
    private final String Delete_STR = EnvironmentVariable.get('FMSDelete_STR');
    private final String Apex_FMSRITFormViewPageId = EnvironmentVariable.get('FMSApex_FMSRITFormViewPageId');
    private final String Select_Form_Type = EnvironmentVariable.get('FMSSelect_Form_Type');
    private final String Error_StatusValue = EnvironmentVariable.get('FMSError_StatusValue');
    private final String Apex_FMSRITFormNewEditPage3 = EnvironmentVariable.get('FMSApex_FMSRITFormNewEditPage3');
    
    public void setExtMessage(){
        if(formObj.ExtractionReport__c && (formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo != null && ((account1).contains(soldTo)|| (account2).contains(soldTo)))){
            selExtMessage = true;
        }else{
            selExtMessage = false;
        }
    }
    
    public void setExtReportDisabled(){
        resetDependentFields();
        selCheckExtReport = formObj.SubmissionType__c == Final_Submission || formObj.SubmissionType__c == Preliminary_Features_Extraction_Report;
        if((formObj.SubmissionType__c == Final_Submission || formObj.SubmissionType__c == Preliminary_Features_Extraction_Report) 
           && (formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo != null && ((account1).contains(soldTo)|| (account2).contains(soldTo)))) {
               formObj.ExtractionReport__c = true;
               selCheckExtReport = true;
           }else{
               selCheckExtReport = false;
           }
        setExtMessage();
        List<FMSRITPickMessages__mdt>  FMSRITMssgPckList = [SELECT Design_Submission__c,DeveloperName,DSMessage__c,Id,Label FROM FMSRITPickMessages__mdt where Design_Submission__c =: formObj.SubmissionType__c];
        if(FMSRITMssgPckList!=null && FMSRITMssgPckList.size() >0){
            
            SubmssnMessg = FMSRITMssgPckList[0].DSMessage__c ;
        }
    }
    public FMSRITFormController (ApexPages.StandardController controller) {
        mapRecordTypeIdName = new map<String, Id>();
        for(RecordType rt : [Select DeveloperName, Id from RecordType where SobjectType =: FMS_RIT_Drop_Box_Obj]) {
            mapRecordTypeIdName.put(rt.DeveloperName, rt.Id);
        }
        showPackage = false;
        showReadOnlyView = true;
        showEditView = false;
        showCallOutExMessage = false;
        mainrecTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('Main Zip File').getRecordTypeId();
        desrecTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('File Name').getRecordTypeId();
        toprecTypeId = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('TopCell Name').getRecordTypeId();
        listToDelete = new Map<Id, FMS_RIT_Drop_Box__c>();
        num1 = 0;
        num2 = 0;
        num3 = 0;
        selPage = 0;
        curPage = '3';
        //page1 starts
        packWrapper = new Map<String, packageWrapper>();
        packWrapperList = new List<packageWrapper>();
        obj = new CustomIterable(packWrapperList);          
        exitForm = true;
        skipvalidation = false;
        soldTo = null;
        isInvalidInp = false;
        formId = ApexPages.currentPage().getParameters().get('id'); 
        
        FMSdocuments =  UtilityCls.getContentList(); 
        
        if(formId!=null && formId != ''){
            String ritFields = '';
            ritFields = UtilityCls.getAllFields('Form_Management_System__c');     
            ritFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, Parent_Form_Id__r.Waivers__c, Parent_Form_Id__r.ReleaseProcessFlow__c,'; 
            ritFields += ' Customer_Name__r.Id,Customer_Name__r.Name,Device__r.Name,Device__r.id, Opportunity__r.id, Parent_Form_Id__r.State_of_the_Form__c, Main_Form_Id__r.State_of_the_Form__c,';
            ritFields += ' Opportunity__r.Name, Parent_Form_Id__r.recordtype.Name, Customer_Name__r.SAP_Account_Id__c,';      
            ritFields += ' Parent_Form_Id__r.ProductName__c, Parent_Form_Id__r.ProductRevision__c, Parent_Form_Id__r.Technology__c, Main_Form_Id__r.ItarData__c, Main_Form_Id__r.Technology__c,Main_Form_Id__r.ReleaseProcessFlow__c';
            string soql = 'select ' + ritFields + ' from Form_Management_System__c WHERE Id = \''+ formId +'\'';
            formObj = database.query(soql);
            holdReason = new List<String>();
            String hReason = formObj.HoldReason__c;
            if(hReason != null && hReason != ''){
                holdReason = hReason.split(';',0);
            }
            if (formObj.Customer_Name__r.SAP_Account_Number__c != null) {
                soldTo = formObj.Customer_Name__r.SAP_Account_Number__c.split('-')[0];
            }            
            holdPreviousStateVal = formObj.State_of_the_Form__c;
        }
        if(ApexPages.currentPage().getParameters().get('pageN') != NULL && ApexPages.currentPage().getParameters().get('pageN') != ''){
            pageNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageN'));
        }
        if(pageNum == null || pageNum == 0){
            pageNum = 1;
        }
        selCheckExtReport = formObj.SubmissionType__c == Final_Submission || formObj.SubmissionType__c == Preliminary_Features_Extraction_Report;
        if(selCheckExtReport && (formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo != null && ((account1).contains(soldTo)|| (account2).contains(soldTo)))){
            formObj.ExtractionReport__c = true;
        }
        if((formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo != null && ((account1).contains(soldTo)|| (account2).contains(soldTo))) && formObj.ExtractionReport__c == true){
            selExtMessage = true;
        }else{
            selExtMessage = false;
        }
        //page1 ends
        //viewpage starts
        grpUsers = new Set<Id>();
        fmsSubscriptionList = new List<FMS_Subscription__c>();
        fmsSubscription = new FMS_Subscription__c();
        validateCheck = false;
        showMainTable = false;
        showMessage = true;
        popupVal = false;
        popupCreateAdd = false;
        requestMsg = '';
        stateChangeComments = '';
        viewPageMethods();
        page2Methods();
        page3Methods();
        
        List<FMSRITPickMessages__mdt>  FMSRITMssgPckList = [SELECT Design_Submission__c,DeveloperName,DSMessage__c,Id,Label FROM FMSRITPickMessages__mdt where Design_Submission__c =: formObj.SubmissionType__c];
        if(FMSRITMssgPckList!=null && FMSRITMssgPckList.size() >0){
            
            SubmssnMessg = FMSRITMssgPckList[0].DSMessage__c ;
        }
        //Added the code by Abhita for UAT Issue #433, 434
        Map < Id, Form_Management_System__c > allChildrenMap = new Map < Id, Form_Management_System__c > ([SELECT id, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c FROM Form_Management_System__c WHERE Parent_Form_Id__c = : formId]);
        if (allChildrenMap.isEmpty()) {
            hasChildren = false;
        } else {
            hasChildren = true;
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
        //End Here for UAT Issue #433, 434
    }
    public Integer num1{get{return obj.num1;}set;}
    public Integer num2{get{return obj.num2;}set;}
    public Integer num3{get{return obj.num3;}set;}
    
    public Boolean hasNext {
        get{
            return obj.hasNext();
        }
        set;
    }                  
    public Boolean hasPrevious {
        get{
            return obj.hasPrevious();
        }
        set;
    }                 
    public void next(){             
        selPage = obj.next();        
    }                  
    public void last(){             
        selPage = obj.last();        
    }                  
    public void previous(){             
        selPage = obj.previous();        
    }     
    public void first(){             
        selPage = obj.first();        
    }
    
    public void pageCall(){
        packWrapperList = obj.pageCall(selPage);
    }
    public void readOnlyPackage(){
        showReadOnlyView = true;
        showEditView = false;
        if(navPackWrapper != null && !navPackWrapper.isEmpty()){
            showPackage = true;
            Boolean flag = false;
            for(packageWrapper packW : navPackWrapper){
                for(ritDropBoxWrapper ritWrap : packW.packDropBoxData.values()){
                    if(ritWrap.isSelected == true){
                        flag = true;
                        showMessage = false;
                        packW.showPackage = true;
                        packW.showTable = true;
                    }else{
                        packW.packDropBoxData.remove(ritWrap.dropBoxFile.File_Id__c);
                    }
                }
            }
            if(!flag){
                showMessage = true;
            }
        }else{
            showMessage = true;
        }
    }
    
    public void showExistingSel(){
        String ritFields1 = UtilityCls.getAllFields(FMS_RIT_Drop_Box_Obj); 
        string soql1 = 'select ' + ritFields1 + ' from FMS_RIT_Drop_Box__c WHERE Form_Id__c = \''+formId +'\' order by Name';
        showReadOnlyView = true;
        showEditView = false;
        packWrapper = new Map<String, packageWrapper>();
        Boolean flag = false;
        List<FMS_RIT_Drop_Box__c> drFiles = new List<FMS_RIT_Drop_Box__c>();
        List<FMS_RIT_Drop_Box__c> dFiles = new List<FMS_RIT_Drop_Box__c>();
        List<FMS_RIT_Drop_Box__c> tFiles = new List<FMS_RIT_Drop_Box__c>();
        for(FMS_RIT_Drop_Box__c ritDropBox : Database.query(soql1)){
            if(ritDropBox.RecordTypeId == mainrecTypeId){
                drFiles.add(ritDropBox);
            }else if(desrecTypeId == ritDropBox.RecordTypeId){
                dFiles.add(ritDropBox);
            }else if(toprecTypeId == ritDropBox.RecordTypeId){
                tFiles.add(ritDropBox);
            }
        }
        for(FMS_RIT_Drop_Box__c ritDropBox : drFiles){
            ritDropboxWrapper dropFile = new ritDropBoxWrapper(ritDropBox);
            dropFile.isSelected = true;
            if(packWrapper.get(ritDropBox.Package_Id__c) != null){
                if(packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData == null 
                   || packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.isEmpty()
                   || packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.get(ritDropBox.File_Id__c) == null){
                       populateData(ritDropBox, dFiles, tFiles, dropFile);
                       packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.put(ritDropBox.File_Id__c, dropFile);
                       flag = true;
                   }
            } else{
                populateData(ritDropBox, dFiles, tFiles, dropFile);
                packagewrapper pack = new packageWrapper(ritDropBox);
                pack.packDropBoxData.put(ritDropBox.File_Id__c, dropFile);
                packWrapper.put(ritDropBox.Package_Id__c, pack);
            }
            packWrapper.get(ritDropBox.Package_Id__c).showTable = true;
            packWrapper.get(ritDropBox.Package_Id__c).showPackage = true;
            if(packWrapper.get(ritDropBox.Package_Id__c) != null 
               && packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData != null
               && !packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.isEmpty()
               && packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.get(ritDropBox.File_Id__c) != null){
                   packWrapper.get(ritDropBox.Package_Id__c).packDropBoxData.get(ritDropBox.File_Id__c).isSelected = true;
                   flag = true;
               }
            showMessage = false;
        }
        
        if(!flag){
            showMessage = true;
        }
        packWrapperList = packWrapper.values();
        obj = new CustomIterable(packWrapperList);          
    }
    
    public void populateData(FMS_RIT_Drop_Box__c ritDropBox, List<FMS_RIT_Drop_Box__c> dFiles, List<FMS_RIT_Drop_Box__c> tFiles, ritDropboxWrapper dropFile){
        for(FMS_RIT_Drop_Box__c ritD : dFiles){
            if(ritD.FMS_RIT_Drop_Box__c == ritDropBox.Id){
                ritDropboxWrapper desFile = new ritDropboxWrapper(ritD);
                desFile.isSelected = true;
                for(FMS_RIT_Drop_Box__c ritTC : tFiles){
                    if(ritTC.FMS_RIT_Drop_Box__c == ritD.Id){
                        ritDropboxWrapper tcFile = new ritDropboxWrapper(ritTC);
                        tcFile.isSelected = true;
                        desFile.topCellFileListWrapper.add(tcFile);
                    }
                }
                dropFile.designFileListWrapper.add(desFile);
            }
        }
        for(FMS_RIT_Drop_Box__c ritTC : tFiles){
            if(ritTC.FMS_RIT_Drop_Box__c == ritDropBox.Id){
                ritDropboxWrapper tcFile = new ritDropboxWrapper(ritTC);
                tcFile.isSelected = true;
                dropFile.topCellFileListWrapper.add(tcFile);
            }
        }        
    }
    
    public void editPackage(){
        try{
            if(Environment_Variable__c.getValues('DropBox_Is_Active') != null && Environment_Variable__c.getValues('DropBox_Is_Active').Value__c == TRUE_STR){
                FMSDropServiceStepPlanDetails_API.Dropbox dbox = FMSDropServiceStepPlanDetails_API.dropBoxService(UserInfo.getUserEmail());
                FMSDropServiceStepPlanDetails_API.Data dat;
                showCallOutExMessage = false;
                List<FMSDropServiceStepPlanDetails_API.Packages> pack = new List<FMSDropServiceStepPlanDetails_API.Packages>();
                List<FMSDropServiceStepPlanDetails_API.Packages_To_User> packU = new List<FMSDropServiceStepPlanDetails_API.Packages_To_User>();
                if(dbox != null){
                    dat = dbox.data;
                    pack = dat.packages;
                    packU = dat.packages_To_User;
                }
                showEditView = true;
                showReadOnlyView = false;
                Map<String, List<FMSDropServiceStepPlanDetails_API.File>> fileMap = new Map<String, List<FMSDropServiceStepPlanDetails_API.File>>();
                
                if(pack != null && !pack.isEmpty()){
                    for(FMSDropServiceStepPlanDetails_API.Packages packI: pack){
                        fileMap.put(packI.Id, packI.files);
                    }
                }
                if(packU != null && !packU.isEmpty()){
                    for(FMSDropServiceStepPlanDetails_API.Packages_To_User packUI : packU){
                        fileMap.put(packUI.Id, packUI.files);
                    }
                }
                if(pack != null && !pack.isEmpty()){
                    for(FMSDropServiceStepPlanDetails_API.Packages packI : pack){
                        if(packWrapper == null || packWrapper.isEmpty()){
                            packWrapper = new Map<String, packageWrapper>();
                        }
                        PackageWrapper newPackWrap;
                        if(!packWrapper.keySet().contains(packI.Id)){
                            newPackWrap = new PackageWrapper(null);
                        }else{
                            newPackWrap = packWrapper.get(packI.Id);
                        }    
                        newPackWrap.isSelected = false;
                        newPackWrap.packageId = packI.Id;
                        newPackWrap.packageName = packI.packageName;
                        newPackWrap.senderInfo = packI.pkgSenderEmail;
                        for(String rEmail : packI.pkgReceiversEmail){
                            if(rEmail == Environment_Variable__c.getInstance('Foundry Admin User').value__c){
                                newPackWrap.packageToUser = true;
                                break;
                            }
                        }
                        newPackWrap.sentDate = DateTime.valueOf(packI.sentDate);
                        for(FMSDropServiceStepPlanDetails_API.File file : fileMap.get(packI.Id)){
                            if(newPackWrap.packDropBoxData.get(file.fileId) == null){
                                FMS_RIT_Drop_Box__c ritDB = new FMS_RIT_Drop_Box__c();
                                ritDB.File_Id__c = file.fileId;
                                ritDB.Drop_Box_File_Name__c = file.fileName;
                                ritDB.Drop_Box_File_Size__c = file.fileSize;
                                ritDB.Form_Id__c = formObj.Id;
                                ritDB.Package_Id__c = packI.Id;
                                ritDB.Package_Name__c = packI.packageName;
                                ritDB.senderEmail__c = newPackWrap.senderInfo;
                                ritDB.SentDate__c = newPackWrap.sentDate;
                                ritDB.RecordTypeId = mainrecTypeId;
                                ritDropBoxWrapper newWrap = new ritDropBoxWrapper(ritDB);
                                newWrap.isSelected = false;
                                newPackWrap.packDropBoxData.put(ritDB.File_Id__c, newWrap);
                            }
                        }
                        if(newPackWrap.packDropBoxData != null && !newPackWrap.packDropBoxData.isEmpty()){
                            newPackWrap.showTable = true;
                        }
                        setCheckBox(newPackWrap);
                        packWrapper.put(packI.Id, newPackWrap);
                    }
                }
                if(packU != null && !packU.isEmpty()){
                    for(FMSDropServiceStepPlanDetails_API.Packages_To_User packUI : packU){
                        if(packWrapper == null || packWrapper.isEmpty()){
                            packWrapper = new Map<String, packageWrapper>();
                        }
                        PackageWrapper newPackWrap;
                        if(!packWrapper.keySet().contains(packUI.Id)){
                            newPackWrap = new PackageWrapper(null);
                        }else{
                            newPackWrap = packWrapper.get(packUI.Id);
                        }       
                        newPackWrap.isSelected = false;
                        newPackWrap.packageId = packUI.Id;
                        newPackWrap.packageName = packUI.packageName;
                        for(String rEmail : packUI.pkgReceiversEmail){
                            if(rEmail == Environment_Variable__c.getInstance('Foundry Admin User').value__c){
                                newPackWrap.packageToUser = true;
                                break;
                            }
                        }
                        newPackWrap.senderInfo = packUI.pkgSenderEmail;
                        newPackWrap.sentDate = DateTime.valueOf(packUI.sentDate);
                        for(FMSDropServiceStepPlanDetails_API.File file : fileMap.get(packUI.Id)){
                            if(newPackWrap.packDropBoxData.get(file.fileId) == null){
                                FMS_RIT_Drop_Box__c ritDB = new FMS_RIT_Drop_Box__c();
                                ritDB.File_Id__c = file.fileId;
                                ritDB.Drop_Box_File_Name__c = file.fileName;
                                ritDB.Drop_Box_File_Size__c = file.fileSize;
                                ritDB.Form_Id__c = formObj.Id;
                                ritDB.Package_Id__c = packUI.Id;
                                ritDB.Package_Name__c = packUI.packageName;
                                ritDB.senderEmail__c = newPackWrap.senderInfo;
                                ritDB.SentDate__c = newPackWrap.sentDate;
                                ritDB.RecordTypeId = mainrecTypeId;
                                ritDropBoxWrapper newWrap = new ritDropBoxWrapper(ritDB);
                                newWrap.isSelected = false;
                                newPackWrap.packDropBoxData.put(ritDB.File_Id__c, newWrap);
                            }
                        }
                        setCheckBox(newPackWrap);
                        packWrapper.put(packUI.Id, newPackWrap);
                    }
                }
                if(!packWrapper.isEmpty()){
                    selPage = 1;
                }
                obj = new CustomIterable(packWrapper.values());          
                obj.setPageSize = 20;
                obj.selPage = selPage;
                obj.setNums(selPage);
            }else{
                showEditView = true;
                showReadOnlyView = false;
                showCallOutExMessage = true;            
            }
        } catch (Exception e){
            showEditView = true;
            showReadOnlyView = false;
            showCallOutExMessage = true;            
        }
    }
    public void setCheckBox(packageWrapper packWrap){
        if(packWrap.packDropBoxData != null && !packWrap.packDropBoxData.isEmpty()){
            packWrap.showTable = true;
            for(ritDropBoxWrapper ritWrap : packWrap.packDropBoxData.values()){
                packWrap.isSelected = true;
                if(ritWrap != null && !ritWrap.isSelected){
                    packWrap.isSelected = false;
                    break;
                }
            }
        }
    }  
    //page1 starts
    public List<SelectOption> getTypeSubList(){
        List<SelectOption> tempList = new List<SelectOption>(); 
        Schema.DescribeFieldResult fieldResult = Form_Management_System__c.SubmissionType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        tempList.add(new SelectOption('', Select_A_Value));   
        for( Schema.PicklistEntry f : ple) {
            
            if(f.getValue() != Preliminary_Features_Extraction_Report) {
                tempList.add(new SelectOption(f.getLabel(), f.getValue()));
            } else if(f.getValue() == Preliminary_Features_Extraction_Report && formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo != null && (account1.contains(soldTo) || account2.contains(soldTo))) {
                tempList.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
        
        return tempList;
    }
    public List<packageWrapper> getPackages() {
        packWrapper.remove(null);
        packWrapperList = packWrapper.values();
        packWrapperList.sort();
        return packWrapperList;
    }
    public Integer gettotalPageNums(){
        if(formObj.IsArchive__c == Yes && formObj.IsMultipleTopCell__c == Yes){
            totPageNum = 3;
        } else if(formObj.IsArchive__c == Yes || formObj.IsMultipleTopCell__c == Yes){
            totPageNum = 2;
        } else {
            totPageNum = 1;
        }
        return totPageNum;
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
        *
    */
    public PageReference saveForm(){  
        exitForm = false;
        return validateSave();        
    }
    
    public PageReference cancelForm(){
        PageReference pgRef = new PageReference(Apex_FMSRITFormViewPage);
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true); 
        return pgRef;
    }
    
    public PageReference saveandExit(){  
        skipvalidation = true;
        return validateSave();        
    }
    
    public List<selectoption> getHoldReasonsList() 
    {           
        list<selectoption> options = new list<selectoption>();            
        try 
        {               
            Schema.DescribeFieldResult fieldResult = Form_Management_System__c.HoldReason__c.getDescribe();
            
            list<schema.picklistentry> values = fieldResult.getPickListValues();               
            for (Schema.PicklistEntry val : values) 
            {                  
                options.add(new SelectOption(val.getLabel(), val.getValue()));
            }           
        }  
        catch (Exception exp) 
        {             
            ApexPages.addMessages(exp);           
        }
        
        return options; 
    }
    
    //Invalid Input check method called from visualforce page.
    public void invInput(){
        String inputValue = Apexpages.currentPage().getParameters().get('inpVal');
        String mapFieldValue = Apexpages.currentPage().getParameters().get('fieldName');
        
        invalidInputCheckMap.put(inputValue.right(3), inputValue.removeEnd(inputValue.right(3)));
        invalidInpToFieldsMap.put(inputValue.right(3), mapFieldValue);
        
        isInvalidInp = false;
        for(String str : invalidInputCheckMap.keySet()){
            if(invalidInputCheckMap.get(str) == TRUE_STR){
                isInvalidInp = true;
            }
        }
    }
    
    public Boolean getOtherReason() {
        if(holdReason != null && !holdReason.isEmpty()) {
            for(String hReason: holdReason){
                if(hReason == Other){
                    return true;
                }
            }
        }
        return false;
    }
    
    public String fieldAPI{get;set;}
    public void resetDependentFields(){
        FMS_HierarchyLogic.getDependentFieldsToReset(fieldAPI,formObj,RIT);
        fieldAPI = '';
    }
    //page1 ends    
    
    //viewpage starts
    public PageReference continueCheck(){
        String addenTypeString = Apexpages.currentPage().getParameters().get('addenType'); 
        if(addenTypeString != null && addenTypeString != ''){
            PageReference pgRef = new PageReference(Apex_FMSmainFormCreation);
            pgRef.getParameters().put('ParentId', formObj.id);
            pgRef.getParameters().put('tranx', Create_STR);
            pgRef.getParameters().put('Type', addenTypeString);
            pgRef.setRedirect(true);
            return pgRef;
        }
        formObj.Mandatory_State_Change_Comments__c = stateChangeComments;
        if(stateChangeComments == null || stateChangeComments == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_StateChangeReason));
            return null;
        }
        return stateCommentChange();
    }
    
    public PageReference editForm(){
        PageReference pgRef = new PageReference(Apex_FMSRITFormNewEditPage1);
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put('pageN', '1');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Added copy method - Ashwin
    public PageReference copyAsNewForm(){
        PageReference pgRef = new PageReference(Apex_FMSCopyForms);
        pgRef.getParameters().put('id', formObj.id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference updateFormDetails(){
        PageReference pgRef = new PageReference(Apex_FMSmainFormCreation);
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put('tranx', Edit_STR);
        pgRef.getParameters().put('Type', RIT);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference deleteForm(){
        Id parentformid = formObj.Parent_Form_Id__c;
        String parRecordType = formObj.Parent_Form_Id__r.recordtype.Name;
        
        try{
            delete formObj;
        }catch(DMLException de){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, de.getMessage()));
            return null;
        }
        PageReference pg1;
        String PageURL = ApexPages.currentPage().getUrl();
        if(PageURL.containsIgnoreCase(GFV_STR)){
            if(parRecordType == Main_Form){
                pg1 = new PageReference(GFV_FMSmainFormViewPage+parentformid);
            } else{
                pg1 = new PageReference(GFV_FMSIMCFormViewPage+parentformid);
            } 
        }
        else{
            if(parRecordType == Main_Form){
                pg1 = new PageReference(Apex_FMSRITFormViewPage_Id+parentformid);
            } else{
                pg1 = new PageReference(Apex_FMSIMCFormViewPage_Id+parentformid);
            } 
        }
        
        pg1.getParameters().put('tranx', Delete_STR);
        pg1.getParameters().put('delFormNum', formObj.Name);
        pg1.setRedirect(true);
        return pg1;
    }
    
    public PageReference statusChange(){ 
        String stateValue;
        formObj.Mandatory_State_Change_Comments__c = '';
        stateValue = Apexpages.currentPage().getParameters().get('stateValue');
        if(stateValue == RTMComplete) {
            formObj.State_of_the_Form__c = RTMComplete;
        }else if(stateValue == RTMProceed) {
            formObj.State_of_the_Form__c = ProceedToRTM;
        }else if(stateValue == PreliminaryComplete) {
            formObj.State_of_the_Form__c = PreliminaryRequestAccepted;
        }else if(stateValue == HoldRTMforClientDecision){
            formObj.State_of_the_Form__c = HoldRTMforClientDecision;
        }else if(stateValue == Returned){
            formObj.State_of_the_Form__c = Returned;
        }else if(stateValue == Cancelled){
            formObj.State_of_the_Form__c = Cancelled;
        }
        try{
            formObj.Previous_State_Of_Form__c = holdPreviousStateVal;
            update formObj;
        } catch(Exception e){
            UtilityCls.saveExceptionLog(FMSRITFormController.class.getName(), 'statusChange()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);// Added for exception framework...#IM
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }   
        PageReference pgRef = new PageReference(Apex_FMSRITFormViewPageId+formObj.id);
        //Added the code by Abhita for UAT Issue #433, 434
        pgRef.getParameters().put('tranx', 'InActiveStateChange');
        pgRef.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pgRef.getParameters().put('newState', formObj.State_of_the_Form__c);
        //End Here for UAT Issue #433, 434
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference submitForm(){ 
        PageReference pgRef = new PageReference(Apex_FMSRITFormViewPageId+formObj.id);
        if (validationCheck()) {//Added by Abhita for Legacy form - 20092017
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Can\' t complete action{Freeze Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
            return null;
        }
        formObj.Previous_State_Of_Form__c = formObj.State_of_the_Form__c;
        formObj.State_of_the_Form__c = SubmitToProcess;
        formObj.Mandatory_State_Change_Comments__c = '';
        try {
            update formObj;           
            pgRef.getParameters().put('tranx', 'InActiveStateChange');
            pgRef.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
            pgRef.getParameters().put('newState', formObj.State_of_the_Form__c);
            pgRef.setRedirect(true);
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            UtilityCls.saveExceptionLog(FMSRITFormController.class.getName(), 'statusChange()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            return null;
        }
        return pgRef;
    }
    
    public PageReference stateCommentChange(){ 
        popupVal = false;
        if(requestMsg == HoldRTMforClientDecision){
            formObj.State_of_the_Form__c = HoldRTMforClientDecision;
        } else if(requestMsg == Returned){
            formObj.State_of_the_Form__c = Returned;
        } else if(requestMsg == Cancelled){
            formObj.State_of_the_Form__c = Cancelled;
        }
        try{
            formObj.Previous_State_Of_Form__c = holdPreviousStateVal;
            update formObj;
        }Catch(Exception e){
            UtilityCls.saveExceptionLog(FMSRITFormController.class.getName(), 'stateCommentChange()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);// Added for exception framework...#IM
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        PageReference pg = new PageReference(Apex_FMSRITFormViewPage);
        pg.getParameters().put('id',formObj.id);
        //Added the code by Abhita for UAT Issue #433, 434
        pg.getParameters().put('tranx', 'InActiveStateChange');
        pg.getParameters().put('previousState', formObj.Previous_State_Of_Form__c);
        pg.getParameters().put('newState', formObj.State_of_the_Form__c);
        //End here for UAT Issue #433, 434
        pg.setRedirect(true);
        return pg; 
    }
    
    public List<SelectOption> getSelectAddendumValues(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', Select_Form_Type));
        options.add(new SelectOption('DDR', DDR_Form));
        return options;
    }
    
    public void showPopup(){
        requestMsg = Apexpages.currentPage().getParameters().get('stateVal');       
        if(requestMsg == CreateAddendum){
            popupCreateAdd = true;
            popupVal = false;
        }else{
            popupVal = true;
        }
    }  
    
    public void closePopup() {
        popupVal = false;
        popupCreateAdd = false;
    }
    
    public boolean validationCheck(){
        boolean val = false;
        if(formObj.ReleaseAutomationTraining__c == '' || formObj.ReleaseAutomationTraining__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_ReleaseAutomationTraining));
            val = true;
        }
        /*if(formObj.GovernmentInformation__c == '' || formObj.GovernmentInformation__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_GovernmentInformation));
            val = true;
        }*/
        if(formObj.Parent_Form_Id__r.Waivers__c == Yes && (formObj.Waivers__c == '' || formObj.Waivers__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_Waiver));
            val = true;
        }
        if(formObj.SubmissionType__c == '' || formObj.SubmissionType__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_TypeOfDataSubmission));
            val = true;
        }
        if(formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo!=null && (account1.contains(soldTo)|| account2.contains(soldTo)) && (formObj.IsPurge__c == '' || formObj.IsPurge__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsPurge));
            val = true;
        }
        if(formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && formObj.IsPurge__c == Yes && (formObj.PurgeMapFile__c == '' || formObj.PurgeMapFile__c == null) && soldTo!= null && (account1.contains(soldTo)|| account2.contains(soldTo)) ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PurgeMapFile));
            val = true;
        }
        if(formObj.SubmissionType__c == Final_Submission && (formObj.PurchaseOrder__c == '' || formObj.PurchaseOrder__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PurchaseOrder));
            val = true;
        }
        if(formObj.SubmissionType__c == Final_Submission && (formObj.RitHold__c == '' || formObj.RitHold__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RITHold));
            val = true;
        }
        if(formObj.RitHold__c == Yes && formObj.SubmissionType__c == Final_Submission && (formObj.HoldReason__c == '' || formObj.HoldReason__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_HoldReason));
            val = true;
        }
        if(formObj.SubmissionType__c == Final_Submission && formObj.RitHold__c == Yes && formObj.HoldReason__c.contains(Other) && (formObj.OtherReason__c == '' || formObj.OtherReason__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_OtherReason));
            val = true;
        }
        if(formObj.SubmissionType__c == Final_Submission && (formObj.PostDesignServices__c == '' || formObj.PostDesignServices__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PostDesignService));
            val = true;
        }
        if(formObj.SubmissionType__c == Final_Submission && formObj.PostDesignServices__c == Yes && (formObj.GdsSubset__c == '' || formObj.GdsSubset__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_GdsSubset));
            val = true;
        }
        if(formObj.GdsSubset__c == Yes && formObj.PostDesignServices__c == Yes && formObj.LeftXCoordinate__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_LeftXCoordinate));
            val = true;
        }
        if(formObj.GdsSubset__c == Yes && formObj.PostDesignServices__c == Yes && formObj.LeftYCoordinate__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_LeftYCoordinate));
            val = true;
        }
        if(formObj.GdsSubset__c == Yes && formObj.PostDesignServices__c == Yes && formObj.RightXCoordinate__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RightXCoordinate));
            val = true;
        }
        if(formObj.GdsSubset__c == Yes && formObj.PostDesignServices__c == Yes && formObj.RightYCoordinate__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RightYCoordinate));
            val = true;
        }
        boolean flagSelect = false;
        
        for(packageWrapper pac : navPackWrapper) {
            for(ritDropBoxWrapper dropWrap: pac.getDropBoxFilesW()){
                if(dropWrap.isSelected){
                    flagSelect = true;
                    if(formObj.IsArchive__c == 'Yes'){
                        if(dropWrap.dropBoxFile.File_Type__c == null || dropWrap.dropBoxFile.File_Type__c == '') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_FileType+dropWrap.dropBoxFile.Drop_Box_File_Name__c));
                            val = true;
                        } else if(dropWrap.dropBoxFile.File_Type__c != Design_File){
                            Boolean designFileP = false;
                            if(dropWrap.designFileListWrapper == null || dropWrap.designFileListWrapper.isEmpty()){
                                designFileP = true;
                            }else{
                                for(ritDropBoxWrapper filedb : dropWrap.designFileListWrapper){
                                    if(!designFileP && (filedb.dropBoxFile.Design_File_Name__c == null || filedb.dropBoxFile.Design_File_Name__c == '')){
                                        designFileP = true;
                                    }else{
                                        designFileP = false;
                                        break;
                                    }
                                }
                            }
                            if(designFileP && formObj.IsArchive__c == 'Yes'){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_SelectoneDesignFile+dropWrap.dropBoxFile.Drop_Box_File_Name__c));
                                val = true;
                            }
                        }
                    }
                }
            }
        }
        if(!flagSelect) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_SelectOneFile));
            val = true;
        }               
        if(formObj.IsArchive__c == '' || formObj.IsArchive__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsArchive));
            val = true;
        }
        if(formObj.IsMultipleTopCell__c == '' || formObj.IsMultipleTopCell__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsTopcell));
            val = true;
        }   
        validateCheck = val;
        return val;
    }
    
    public PageReference validationBeforeAddendum(){
        String statusValue = Apexpages.currentPage().getParameters().get('stateChangeVal');
        validationCheck();
        String errormsg = Error_StatusValue.replace('statusValue',statusValue);
        if(validateCheck){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errormsg));
            return null;
        }
        return null;
    }
    //20-7-2017 Ram Rai- Modified the method for step plan subscription
    public PageReference Subscribe(){      
    
        Id userId = userinfo.getUserId();
        FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
        
        List<FMS_Subscription__c>  subscpList = new List<FMS_Subscription__c>();         
        subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userId  and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Form_Id__c =:formObj.id and Saved_Search_Id__c=null];             
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
                // Added the code for Subscription Object 1Sept2017
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
            
             PageReference pgRef = new PageReference(Apex_FMSRITFormViewPageId+ formObj.id);
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
                UtilityCls.saveExceptionLog(FMSRITFormController.class.getName(), 'UnSubscribe()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);// Added for exception framework...#IM
            }
            subscribeFlag = false;
        }
        //Added the code by Abhita for UAT Issue #433, 434
        PageReference pgRef = new PageReference(Apex_FMSRITFormViewPageId+ formObj.id);
        pgRef.getParameters().put('tranx', 'UnSubscribe');
        //End here UAT Issue #433, 434
        pgRef.setRedirect(true);
        return pgRef;
    }
    public PageReference SubscribeUser(){       
        String PageURL = ApexPages.currentPage().getUrl(); 
        PageReference pgRef = new PageReference(Apex_FMSSubscribeOtherUserPage);
        pgRef.getParameters().put('id', formObj.id);
        pgRef.getParameters().put(baseURL,PageURL);
        pgRef.setRedirect(true); 
        return pgRef;
    }
    public PageReference openPDF(){
        PageReference pgRef = new PageReference( Apex_FMSRITFormViewPrintPDFId+formObj.id);        
        pgRef.setRedirect(true); 
        return pgRef;
    }
    
    public PageReference redirectToSearchPage(){
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains(GFV_STR)){
            pr = new PageReference(GFV_FormManagementMainPage);
        }else{
            pr = new PageReference(Apex_FormManagementMainPage_TabName+Environment_Variable__c.getInstance('FMS_TAB_ID').Value__c);
        }
        return pr;
    }
    //Added to redirect to new addendum form creation page
    public pageReference createAddendumForm() {
        PageReference pgRef;
        if (validationCheck()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_CreateAddendum));
        }
        else{        
            pgRef = new PageReference(Apex_FMSmainFormCreation);
            pgRef.getParameters().put('ParentId', formObj.id);
            pgRef.getParameters().put('tranx', Create_STR);
            pgRef.getParameters().put('Type', RIT);
            pgRef.getParameters().put('parentName', formObj.Name);
            pgRef.setRedirect(true);
        }
        return pgRef;
    }
    //viewpage ends
    
    public Boolean valCheck(Boolean next){
        Boolean val = false;
        if(pageN == page1){
            if(formObj.ReleaseAutomationTraining__c == '' || formObj.ReleaseAutomationTraining__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_ReleaseAutomationTraining));
                val = true;
            }
            /*if(formObj.GovernmentInformation__c == '' || formObj.GovernmentInformation__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_GovernmentInformation));
                val = true;
            }*/
            if(formObj.Parent_Form_Id__r.Waivers__c == Yes && (formObj.Waivers__c == '' || formObj.Waivers__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_Waiver));
                val = true;
            }
            if(formObj.Main_Form_Id__r.ReleaseProcessFlow__c == Enhanced_Flow && soldTo!=null && (account1.contains(soldTo)|| account2.contains(soldTo))){
                if (formObj.IsPurge__c == '' || formObj.IsPurge__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsPurge));
                    val = true;
                } else if(formObj.IsPurge__c == Yes && (formObj.PurgeMapFile__c == '' || formObj.PurgeMapFile__c == null)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PurgeMapFile));
                    val = true;
                }
            }
            boolean flag = false;
            if(holdReason != null && !holdReason.isEmpty()) {
                for(String hReason: holdReason){
                    if(hReason == Other){
                        flag = true;
                    }
                }
            } 
            if(formObj.SubmissionType__c == '' || formObj.SubmissionType__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_TypeOfDataSubmission));
                val = true;
            } else if(formObj.SubmissionType__c == Final_Submission){
                if(formObj.PurchaseOrder__c == '' || formObj.PurchaseOrder__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PurchaseOrder));
                    val = true;
                }
                if(formObj.RitHold__c == '' || formObj.RitHold__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RITHold));
                    val = true;
                } else if(formObj.RitHold__c == Yes){
                    if(holdReason.isEmpty() || holdReason == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_HoldReason));
                        val = true;
                    } else if(flag && (formObj.OtherReason__c == '' || formObj.OtherReason__c == null)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_OtherReason));
                        val = true;
                    }
                }
                if(formObj.SubmissionType__c == Final_Submission && formObj.PostDesignServices__c == Yes && (formObj.GdsSubset__c == '' || formObj.GdsSubset__c == null)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_GdsSubset));
                    val = true;
                }
                if(formObj.PostDesignServices__c == '' || formObj.PostDesignServices__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_PostDesignService));
                    val = true;
                } else if(formObj.PostDesignServices__c == Yes && formObj.GdsSubset__c == Yes){
                    if(formObj.LeftXCoordinate__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_LeftXCoordinate));
                        val = true;
                    }
                    if(formObj.LeftYCoordinate__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_LeftYCoordinate));
                        val = true;
                    }
                    if(formObj.RightXCoordinate__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RightXCoordinate));
                        val = true;
                    }
                    if(formObj.RightYCoordinate__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_RightYCoordinate));
                        val = true;
                    }
                }
            }
            if(formObj.IsArchive__c == '' || formObj.IsArchive__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsArchive));
                val = true;
            }
            if(formObj.IsMultipleTopCell__c == '' || formObj.IsMultipleTopCell__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_IsTopcell));
                val = true;
            }
            boolean flagDrop = false;
            boolean flagSelect = false;
            
            for(packageWrapper pac : navPackWrapper) {
                for(ritDropBoxWrapper dropWrap: pac.getDropBoxFilesW()){
                    if(dropWrap.isSelected){
                        flagSelect = true;
                        break;
                    }
                }
            }
            //Validation check if Invalid input is given 
            if(isInvalidInp){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_InputFormat));
                val = true;
            }
            if(!flagSelect) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_SelectOneFile));
                val = true;
            }               
        } else if (pageN == page2){
            for(packageWrapper pack : navPackWrapper){
                for(ritDropBoxWrapper dropb : pack.getdropBoxFilesW()) {
                    if(dropb.isSelected == true){
                        if(dropb.dropBoxFile.File_Type__c == null || dropb.dropBoxFile.File_Type__c == '') {
                            //modified the message against Issue#296...7-7-17...#IM
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_FileType+dropb.dropBoxFile.Drop_Box_File_Name__c));
                            val = true;
                        } else if(dropb.dropBoxFile.File_Type__c != Design_File){
                            if(dropb.designFileListWrapper == null || dropb.designFileListWrapper.isEmpty()){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_SelectoneDesignFile+dropb.dropBoxFile.Drop_Box_File_Name__c));
                                val = true;
                            }else{
                                Boolean designFileP = false;
                                for(ritDropBoxWrapper filedb : dropb.designFileListWrapper){
                                    if(!designFileP && (filedb.dropBoxFile.Design_File_Name__c == null || filedb.dropBoxFile.Design_File_Name__c == '')){
                                        designFileP = false;
                                    }else{
                                        designFileP = true;
                                        break;
                                    }
                                }
                                if(!designFileP){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_SelectoneDesignFile+dropb.dropBoxFile.Drop_Box_File_Name__c));
                                    val = true;
                                }
                            }
                        }
                    }
                }
            }
        } 
        if(!invalidInputCheckMap.isEmpty()){
            for(String str : invalidInputCheckMap.keySet()){
                if(invalidInputCheckMap.get(str) == TRUE_STR){
                    if(invalidInpToFieldsMap.get(str) == LeftXCoordinate){
                        formObj.LeftXCoordinate__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(str) == LeftYCoordinate){
                        formObj.LeftYCoordinate__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(str) == RightXCoordinate){
                        formObj.RightXCoordinate__c = null;     
                    }
                    if(invalidInpToFieldsMap.get(str) == RightYCoordinate){
                        formObj.RightYCoordinate__c = null;     
                    }
                }
            }                           
        }
        return val;
    }
    
    public PageReference nextPage(){
        PageReference pgRef;
        Boolean val = valCheck(true);
        if(!val){
            if(pageN == page1){
                if(formObj.IsArchive__c == No && formObj.IsMultipleTopCell__c == Yes){
                    pageNum = 3;
                    curPage = '2';
                    page3Methods();
                }else if(formObj.IsArchive__c == Yes){
                    pageNum = 2;
                    page2Methods();
                }
                pgRef = new PageReference(Apex_FMSRITFormNewEditPage+pageNum);
            } else if(pageN == page2){
                pgRef = new PageReference(Apex_FMSRITFormNewEditPage3);
                page3Methods();
                pageNum = 3;
            }
        }else{
            return null;
        }   
        return pgRef;
    }
    
    public PageReference prevPage(){
        PageReference pgRef;
        if(pageN == page2){
            pgRef = new PageReference(Apex_FMSRITFormNewEditPage1);
            pageNum = 1;
        } else if(pageN == page3){
            if(formObj.IsArchive__c == No){
                pageNum = 1;
            }else {
                pageNum = 2;
            }
            pgRef = new PageReference(Apex_FMSRITFormNewEditPage+pageNum);
        }
        return pgRef;
    }
    
    public PageReference validateSave(){
        Map<Id, List<FMS_RIT_Drop_Box__c>> saveRecords1 = new Map<Id, List<FMS_RIT_Drop_Box__c>>();
        Map<Id, List<FMS_RIT_Drop_Box__c>> saveRecords2 = new Map<Id, List<FMS_RIT_Drop_Box__c>>();
        Map<Id, List<FMS_RIT_Drop_Box__c>> saveRecords3 = new Map<Id, List<FMS_RIT_Drop_Box__c>>();
        boolean val = valCheck(false);
        if(!exitForm || skipvalidation || !val){
            for(packageWrapper packW : navPackWrapper){
                for(FMS_RIT_Drop_Box__c rit: packW.listToDelete){
                    listToDelete.put(rit.Id, rit);
                }
                dropBoxData(saveRecords1, null, packW.getDropBoxFilesW(), Main, mainrecTypeId);
            }
            if(holdReason != null && !holdReason.isEmpty()) {
                String reason = '';
                for(String hReason: holdReason){
                    reason += hReason+';';
                }
                reason = reason.removeEnd(';');
                formObj.HoldReason__c = reason;
            }
            
            try{
                FMSEmailTemplates.SendEditEmail = false;
                update formObj;
                FMSEmailTemplates.lmDate = System.now();
                if(saveRecords1 != NULL && saveRecords1.values() != null && !saveRecords1.values().isEmpty()) {
                    List<FMS_RIT_Drop_Box__c> saveR = new List<FMS_RIT_Drop_Box__c>();
                    for(List<FMS_RIT_Drop_Box__c> saverec : saveRecords1.values()){
                        saveR.addAll(saverec);
                    }
                    upsert saveR;
                    for(packageWrapper pack : navPackWrapper){
                        for(ritDropBoxWrapper wrap : pack.getdropBoxFilesW()){
                            dropBoxData(saveRecords2, wrap, wrap.designFileListWrapper, Design, desrecTypeId);
                        }
                    }
                    if(saveRecords2 != NULL && saveRecords2.values() != null && !saveRecords2.values().isEmpty()) {
                        List<FMS_RIT_Drop_Box__c> saveR1 = new List<FMS_RIT_Drop_Box__c>();
                        for(List<FMS_RIT_Drop_Box__c> saverec : saveRecords2.values()){
                            saveR1.addAll(saverec);
                        }
                        upsert saveR1;
                    }
                    for(packageWrapper pack : navPackWrapper){
                        for(ritDropBoxWrapper wrap : pack.getdropBoxFilesW()){
                            if(wrap.dropBoxFile.File_Type__c == Design_File){
                                dropBoxData(saveRecords3, wrap, wrap.topCellFileListWrapper, Top_Cell, toprecTypeId);
                            }else{
                                for(ritDropBoxWrapper desfl : wrap.designFileListWrapper){
                                    dropBoxData(saveRecords3, desfl, desfl.topCellFileListWrapper, Top_Cell, toprecTypeId);
                                }
                            }
                        }
                    }
                    if(saveRecords3 != NULL && saveRecords3.values() != null && !saveRecords3.values().isEmpty()) {
                        List<FMS_RIT_Drop_Box__c> saveR2 = new List<FMS_RIT_Drop_Box__c>();
                        for(List<FMS_RIT_Drop_Box__c> saverec : saveRecords3.values()){
                            if(saverec!=null && !saverec.isEmpty()){
                                for(FMS_RIT_Drop_Box__c saverec1:saverec){
                                    if(saverec1 != null && saverec1.Form_Id__c != null){
                                        saveR2.add(saverec1);
                                    }
                                }
                            }
                        }
                        upsert saveR2;
                    }               
                }
                FMSEmailTemplates.sendNotificationOnRITFormCreation(formObj);
                if(!listToDelete.values().isEmpty()){
                    listToDelete.remove(null);
                    Database.delete(listToDelete.values(), false) ;
                    listToDelete = new Map<Id, FMS_RIT_Drop_Box__c>();
                }
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITFormController.class.getName(), 'validateSave()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);// Added for exception framework...#IM
            }
        } else {
            return null;
        }
        
        PageReference pgRef;
        if(exitForm){
            pgRef = new PageReference(Apex_FMSRITFormViewPage);
            if(!val || pageN == page3){
                pgRef.getParameters().put('id', formObj.id);
                pgRef.setRedirect(true);
            }else{
                viewPageMethods();
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Save_Message));
            exitForm = true;
            return null;
        }
        return pgRef;
    }   
    
    public void dropBoxData(Map<Id, List<FMS_RIT_Drop_Box__c>> saveRecords, ritDropBoxWrapper wrap, List<ritDropBoxWrapper> wrapper, String type, String recTypeId){
        for(ritDropBoxWrapper desfile : wrapper){
            if((type == Design && desfile.dropBoxFile.Design_File_Name__c != NULL && !String.isEmpty(desfile.dropBoxFile.Design_File_Name__c))
               || (type == Top_Cell && desfile.dropBoxFile.TopCellName__c != NULL && !String.isEmpty(desfile.dropBoxFile.TopCellName__c))
               || (type == Main && desfile.isSelected && desfile.dropBoxFile.Drop_Box_File_Name__c != NULL && !String.isEmpty(desfile.dropBoxFile.Drop_Box_File_Name__c))){
                   if(desfile.dropBoxFile.Form_Id__c == null || String.isEmpty(desfile.dropBoxFile.Form_Id__c)){
                       desfile.dropBoxFile.Form_Id__c = formObj.Id;
                   }
                   if(type != Main){
                       desfile.dropBoxFile.FMS_RIT_Drop_Box__c = wrap.dropBoxFile.Id;
                       if(type != Design){
                           desfile.dropBoxFile.Design_File_Name__c = wrap.dropBoxFile.Design_File_Name__c;
                       }
                       desfile.dropBoxFile.Drop_Box_File_Name__c = wrap.dropBoxFile.Drop_Box_File_Name__c;
                       desfile.dropBoxFile.File_Type__c = wrap.dropBoxFile.File_Type__c;
                       desfile.dropBoxFile.Drop_Box_File_Size__c = wrap.dropBoxFile.Drop_Box_File_Size__c; 
                       desfile.isSelected = wrap.isSelected;
                       desfile.dropBoxFile.Package_Name__c = wrap.dropBoxFile.Package_Name__c;
                       desfile.dropBoxFile.Package_Id__c = wrap.dropBoxFile.Package_Id__c;
                   }
                   
                   if(type != Design || desfile.dropBoxFile.File_Type__c != Design_File){
                       desfile.dropBoxFile.RecordTypeId = recTypeId;
                   }
               } else {
                   if(type == Main){
                       if(!desfile.designfilelistwrapper.isEmpty()){
                           removeDesignFiles(desfile.designfilelistwrapper);
                       }
                       if(!desfile.topCellfilelistwrapper.isEmpty()){
                           removeTopCellFiles(desfile.topCellFileListWrapper);
                       }
                   }
                   listToDelete.put(desfile.dropBoxFile.Id, desfile.dropBoxFile);
               }
            if(wrap != null && wrap.listToDelete != null && !wrap.listToDelete.isEmpty()){
                for(FMS_RIT_Drop_Box__c del:wrap.listToDelete){
                    listToDelete.put(del.Id, del);
                }
            }
            if(desfile.isSelected){
                if(saveRecords.get(desfile.dropBoxFile.Id) == null || saveRecords.get(desfile.dropBoxFile.Id).isEmpty()){
                    saveRecords.put(desfile.dropBoxFile.Id, new List<FMS_RIT_Drop_Box__c>());
                }      
                if(desfile != null && desfile.dropBoxFile!=null){
                    saveRecords.get(desfile.dropBoxFile.Id).add(desfile.dropBoxFile);
                }
            }
        }
    }
    
    public void page2Methods(){
        for(packageWrapper pack: navPackWrapper){
            for(ritDropBoxWrapper wrap : pack.getdropBoxFilesW()){
                if(!wrap.isSelected){
                    if(!wrap.getDesignDropBoxFilesW().isEmpty()){
                        removeDesignFiles(wrap.getDesignDropBoxFilesW());
                    }
                    if(!wrap.getTopCellDropBoxFilesW().isEmpty()){
                        removeTopCellFiles(wrap.getTopCellDropBoxFilesW());
                    }
                    listToDelete.put(wrap.dropboxfile.Id, wrap.dropboxfile);
                    pack.packDropBoxData.remove(wrap.dropboxfile.File_Id__c);
                }
            }
            navSteps(pack.getdropBoxFilesW(), mainrecTypeId, Design);
        }
    }
    
    public void page3Methods(){
        List<ritDropBoxWrapper> designWrapper = new List<ritDropBoxWrapper>();
        for(packageWrapper pack: navPackWrapper){
            for(ritDropBoxWrapper wrap : pack.getdropBoxFilesW()){
                if(formObj.IsArchive__c == No && formObj.IsMultipleTopCell__c == Yes){
                    wrap.dropBoxFile.File_Type__c = Design_File;
                }
                if(wrap.dropBoxFile.File_Type__c == Design_File){
                    if(!wrap.designFileListWrapper.isEmpty()){
                        removeDesignFiles(wrap.designFileListWrapper);
                    }
                }else {
                    if(!wrap.topCellFileListWrapper.isEmpty()){
                        removeTopCellFiles(wrap.topCellFileListWrapper);
                    }
                }
                designWrapper.addAll(wrap.designFileListWrapper);
            }
            navSteps(designWrapper, desrecTypeId, Top_Cell);
        }
    }
    public void removeDesignFiles(List<ritDropboxWrapper> designList){
        for(ritDropBoxWrapper desFile : designList){
            if(!desFile.topCellFileListWrapper.isEmpty()){
                removeTopCellFiles(desFile.topCellFileListWrapper);
            }
            listToDelete.put(desFile.dropboxfile.Id, desFile.dropboxfile);
        }
        designList.clear();
    }
    
    public void removeTopCellFiles(List<ritDropboxWrapper> topCellList){
        for(ritDropboxWrapper topcell : topCellList){
            listToDelete.put(topcell.dropBoxfile.Id, topcell.dropboxfile);
        }
        topCellList.clear();
    }
    
    public void navSteps(List<ritDropBoxWrapper> wrapper, Id recTypeId, String type){
        for(ritDropBoxWrapper wrap : wrapper){
            if(type == Design || type == Top_Cell){
                if(wrap.dropBoxFile.Id == NULL){
                    if((type == Design && wrap.dropBoxFile.Design_File_Name__c != NULL && !String.isEmpty(wrap.dropBoxFile.Design_File_Name__c)) 
                       || (type == Top_Cell && wrap.dropBoxFile.Drop_Box_File_Name__c != null && wrap.dropBoxFile.Drop_Box_File_Name__c !='')){
                           wrap.dropBoxFile.Form_Id__c = formObj.Id;
                           wrap.dropBoxFile.RecordTypeId = recTypeId;
                           wrap.isSelected = true;
                       }
                }
            }
        }        
    }
    
    public void viewPageMethods(){
        Id grpId = [SELECT ID,Name FROM Group WHERE DeveloperName =: FMS_Admin_Group].Id;
        for(GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :grpId]){
            if(((String)m.UserOrGroupId).startsWith(userType)){
                grpUsers.add(m.UserOrGroupId);
            }
        }
        isFMSAdmin = grpUsers.contains(UserInfo.getUserId());
        isPortalUser = (UserInfo.getUserType() != Standard);
        showExistingSel();
        if(navPackWrapper != null && !navPackWrapper.isEmpty()){
            for(packageWrapper packW: navPackWrapper){
                if(packW.packDropBoxData != null && !packW.packDropBoxData.isEmpty()){
                    packW.showTable = true;
                    showMessage = false;
                    for(ritDropBoxWrapper drop : packW.packDropBoxData.values()){
                        if(drop.dropBoxFile.File_Type__c != null){
                            showMainTable = true;
                        }
                    }
                }
            }
        }
        subscribeFlag = false;
        // Added the code for Subscription Object 1Sept2017
        fmsSubscriptionList = new List<FMS_Subscription__c>([Select id,Form_Inserted__c,Form_Status_Change__c,Form_Updated__c,Subscribed_Date__c,UnSubscribed_Date__c, Form_Deleted__c FROM FMS_Subscription__c WHERE Form_Id__c = :formId AND User_Name__c =:UserInfo.getUserId() and UnSubscribed_Date__c=null and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c = true or Form_Deleted__c = true) and Saved_Search_Id__c=null]);
         
        if(fmsSubscriptionList != null && !fmsSubscriptionList.isEmpty()){
                fmsSubscription = fmsSubscriptionList[0];
                subscribeFlag = true;
            }
            else{
                subscribeFlag = false;
            }
    }
    
    public class PackageWrapper implements Comparable{
        public String packageName{get;set;}
        public String packageId{get;set;}
        public String senderInfo{get;set;}
        public DateTime sentDate {get;set;}
        public Map<String, ritDropBoxWrapper> packDropBoxData{get;set;}
        public Integer rows {get;set;}
        public Integer rowNum {get;set;}
        public Boolean packageToUser{get;set;}
        public Boolean showError{get;set;}
        public Boolean showPackage{get;set;}
        public Boolean showTable{get;set;}
        public Boolean isSelected{get;set;}
        public List<FMS_RIT_Drop_Box__c> listToDelete;
        
        public packageWrapper (FMS_RIT_Drop_Box__c ritDropBox){
            packDropBoxData = new Map<String, ritDropBoxWrapper>();
            rows = 10;
            showError = false;
            showPackage = false;
            showTable = false;
            isSelected = true;
            packageToUser = false;
            listToDelete = new List<FMS_RIT_Drop_Box__c>();
            if(ritDropBox != null){
                ritDropBoxWrapper d = new ritDropBoxWrapper(ritDropBox);
                packageName = ritDropBox.Package_Name__c;
                packageId = ritDropBox.Package_Id__c;
                senderInfo = ritDropBox.senderEmail__c;
                sentDate =ritDropBox.SentDate__c;
                packDropBoxData.put(ritDropBox.File_Id__c, d);
            }
        }
        public void delRowFromDropBoxFile(){
            String recordId = ApexPages.currentPage().getParameters().get('fileRecordId');
            String fileName = ApexPages.currentPage().getParameters().get('index');
            if(packDropBoxData.get(fileName).isSelected == true){
                packDropBoxData.get(fileName).isSelected = false;
            }
            if(!String.isEmpty(recordId) && recordId != null){
                if(packDropBoxData.get(fileName).dropBoxFile.id != null){
                    listToDelete.add(packDropBoxData.get(fileName).dropBoxFile);
                    for(ritDropBoxWrapper des : packDropBoxData.get(fileName).getDesignDropBoxFilesW()){
                        listToDelete.add(des.dropBoxFile);
                        if(!des.getTopCellDropBoxFilesW().isEmpty()){
                            for(ritDropBoxWrapper top : des.getTopCellDropBoxFilesW()){
                                listToDelete.add(top.dropBoxFile);
                            }
                        }
                    }
                    for(ritDropBoxWrapper top : packDropBoxData.get(fileName).getTopCellDropBoxFilesW()){
                        listToDelete.add(top.dropBoxFile);
                    }
                }
            }
            packDropBoxData.remove(fileName);
        }
        
        public List<ritDropBoxWrapper> getdropBoxFilesW() {
            if(packDropBoxData==NULL || packDropBoxData.isEmpty()){
                packDropBoxData = new Map<String, ritDropBoxWrapper>();
            }
            packDropBoxData.remove(null);
            return packDropBoxData.values();
        }
        
        public Integer compareTo(OBject obj){
            packageWrapper compareToPack = (packageWrapper)obj;
            if (sentDate == compareToPack.sentDate) return 0;
            if (sentDate < compareToPack.sentDate) return 1;
            return -1;
        }
        
        public String getPackageText(){
            String text = '';
            if(packageToUser){
                Integer count = 0;
                for(ritDropBoxWrapper rit:getdropBoxFilesW()){
                    if(rit.isSelected){
                        count++;
                    }
                }
                if(count > 0){
                    text = count+FMSRITFormController.Selected_Files;
                } 
            }else{
                text = FMSRITFormController.Selection_Not_Possible_Message;
            }
            return text;
        }
    }    
    
    public class CustomIterable {    
        list<packageWrapper> InnerList{get; set;}    
        Map<Integer, List<packageWrapper>> ListRequested{
            get{
                Map<Integer, List<packageWrapper>> pWrap = new Map<Integer, List<packageWrapper>>();
                Integer j = 1;
                Integer k = 1;
                InnerList.sort();
                for(packageWrapper pack: InnerList){
                    if(pWrap.get(j) == null || pWrap.get(j).isEmpty()){
                        pWrap.put(j, new List<packageWrapper>());                                
                    }
                    pWrap.get(j).add(pack);
                    if(k<setPageSize){
                        k++;
                    }else{
                        k=1;
                        j++;
                    }
                }
                pWrap.remove(null);
                return pWrap;
            } 
            set;
        }    
        public Integer selPage {get; set;}    
        public Integer setPageSize {get;set;}    
        public Integer numberOfPages {
            get{
                return ListRequested.size();
            } 
            set;
        }
        public Integer num1 {get;set;}
        public Integer num2 {get;set;}
        public Integer num3 {get;set;}
        public CustomIterable(List<packageWrapper> lstAccWr)    {        
            InnerList = new list<packageWrapper>();         
            InnerList = lstAccWr;     
            setPageSize = 50;
            selPage = 0; 
            num1 = 0;
            num2 = 0;
            num3 = 0;
        }       
        public boolean hasNext(){        
            if(selPage >= numberOfPages){
                return false;
            } else {
                return true;
            }
        }
        public boolean hasPrevious(){         
            if(selPage <= 1) {            
                return false;         
            } else {            
                return true;        
            }    
        }
        public Integer last(){               
            selPage = numberOfPages;
            setNums(selPage);
            return selPage;    
        }         
        
        public Integer next(){
            if(hasNext()){
                selPage += 1;
            }
            setNums(selPage);
            return selPage;    
        }         
        public Integer previous(){            
            if(hasPrevious()){
                selPage -= 1;
            }
            setNums(selPage);
            return selPage;   
        }
        public Integer first(){            
            selPage = 1;
            setNums(selPage);
            return selPage;   
        }
        
        public list<packageWrapper > pageCall(Integer selP){            
            selPage = selP;
            setNums(selPage);
            if(ListRequested.get(selPage) != null && !ListRequested.get(selPage).isEmpty()){
                return ListRequested.get(selPage);   
            }else{
                return null;
            }
        }
        
        public void setNums(Integer selPage){
            if(selPage <= numberOfPages){
                Integer startNum = (selPage*setPageSize)-setPageSize;
                Integer curScreen = (startNum/(setPageSize*3))+1;
                num1 = ((curScreen-1)*3)+1;
                if(numberOfPages>num1){
                    num2 = num1+1;
                    if(numberOfPages>num2){
                        num3 = num2+1;
                    } else{
                        num3 = 0;
                    }
                } else{
                    num2 = 0;
                }
            }
        }
    }
    
    public class ritDropBoxWrapper {
        public FMS_RIT_Drop_Box__c dropBoxFile {get;set;}
        public List<ritDropBoxWrapper> designFileListWrapper {get;set;}
        public List<ritDropBoxWrapper> topCellFileListWrapper {get;set;}
        public Boolean showError {get;set;}
        public Integer rowNum{get;set;}
        public List<FMS_RIT_Drop_Box__c> listToDelete;
        public boolean topCellTable {get;set;}
        public Integer rowS {get;set;}
        public Boolean isSelected {get;set;}
        public List<ritDropBoxWrapper> getDesignDropBoxFilesW() {
            if(designFileListWrapper==NULL || designFileListWrapper.isEmpty()){
                designFileListWrapper.add(new ritDropBoxWrapper(new FMS_RIT_Drop_Box__c()));
            }
            return designFileListWrapper;
        }
        public List<ritDropBoxWrapper> getTopCellDropBoxFilesW() {
            if(topCellFileListWrapper==NULL || topCellFileListWrapper.isEmpty()){
                topCellFileListWrapper.add(new ritDropBoxWrapper(new FMS_RIT_Drop_Box__c()));
            }
            return topCellFileListWrapper;
        }
        public ritDropBoxWrapper (FMS_RIT_Drop_Box__c ritDropBoxRecord1){
            dropBoxFile = ritDropBoxRecord1;
            designFileListWrapper = new List<ritDropBoxWrapper>();
            topCellFileListWrapper = new List<ritDropBoxWrapper>();
            rowS = 20;
            showError = false;
            String ritFields = '';
            isSelected = false;
            listToDelete = new List<FMS_RIT_Drop_Box__c>();
            ritFields = UtilityCls.getAllFields(FMSRITFormController.FMS_RIT_Drop_Box_Obj); 
            topCellTable = false;
        }
        public void addRowToDesignFile(){
            addRow(designFileListWrapper);
        }
        public void delRowToDesignFile(){
            delRow(designFileListWrapper);
        }
        public void addRowToTopCellFile(){
            addRow(topCellFileListWrapper);
        }
        public void delRowToTopCellFile(){
            delRow(topCellFileListWrapper);
        }
        
        public String getSize(){
            Decimal d = dropBoxFile.Drop_Box_File_Size__c == null?0:Decimal.valueOf(dropBoxFile.Drop_Box_File_Size__c);
            String ret = '';
            if(d != 0){
                if(d < 1024){
                    ret = d.setScale(2) + ' B';
                } else if(d < (1024*1024)){
                    ret = (d/1024).setScale(2) + ' KB';
                } else {
                    ret = (d/(1024*1024)).setScale(2) + ' MB';
                }
            } else {
                ret = '0 B';
            }
            return ret;
        }
        
        public void addRow(List<ritDropBoxWrapper> wrapper){
            wrapper.add(new ritDropBoxWrapper(new FMS_RIT_Drop_Box__c()));
        }
        public void delRow(List<ritDropBoxWrapper> wrapper){
            String recordId = ApexPages.currentPage().getParameters().get('fileRecordId');
            rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
            if(wrapper != null && !wrapper.isEmpty()){
                if(wrapper[rowNum].dropBoxFile != null && wrapper[rowNum].dropBoxFile.id != null){
                    listToDelete.add(wrapper[rowNum].dropBoxFile);
                    if(!wrapper[rowNum].getTopCellDropBoxFilesW().isEmpty()){
                        for(ritDropBoxWrapper top: wrapper[rowNum].getTopCellDropBoxFilesW()){
                            listToDelete.add(top.dropBoxFile);
                        }
                    }
                }
                wrapper.remove(rowNum);
            }
        }
    }
    
     public PageReference chngHistory() {
        return UtilityCls.changeHistory(formObj);
     }   
}