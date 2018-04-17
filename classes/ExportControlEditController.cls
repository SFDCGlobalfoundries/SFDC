/*
  Author: Baijnath Rathour/Anirban Roy
  Description: This is the controller for the ExportControlEdit VF page.
  History:
    BRathour        06282013    - code creation.
    ARoy            07032013    - code modification to include the functionalities for VF page. 
    ARoy            10022013    - code modification to populate the customer portal name, phone, email address and owner for 
                                  Status = 'Undeclared' as per the information of current portal user. 
    ARoy            10312013    - modified code to add the validation only on submission not on save.
    ARoy            11272013    - modified for change in verbiage for GTC and non-GTC users.
    ARoy            03052014    - updated code as per Case - 00005251(addition of new question).   
    Vijay           02092015    - updated the functionality to support the Export Control form for Internal Device.
    Devendra        20092016    - updated the functionality to support the Export Control form for Red system.         
    Devendra        28062017    - updated the functionality to support the MPW ECCN.         
  ARoy            02082017    - added check on Reassign button based on FMS Forms   
    Poulami         15112017    - updated the functionality for GTC Color Zone Mapping requirement.    
*/

public class ExportControlEditController{

    //Variables declaration
    public Boolean initialised{get;set;}
    public static Boolean hasRun = false;
    public Export_Control_Form__c ExportControl{ get; set; }
    public String otherText{get;set;}
    public String queryStr{get;set;}
    public String deviceCRMDID{get;set;}
    public String deviceAccountName{get;set;}
    public String deviceName{get;set;}
    public String deviceFab{get;set;}
    public String deviceProjName{get;set;}
    public String deviceExpConTemplate{get;set;}
    public String devId{get;set;}
    public boolean isGTCUser{get;set;}
    public String gtcUserName{get;set;}      
    public boolean isLocked{get;set;}
    public boolean enableECCN{get;set;}
    private ApexPages.StandardController controller;
  public String isFab9_10Check{get;set;} // ARoy 02082017 - added check on Reassign button based on FMS Forms    
    
    static final string EXPORT_CONTROL_TEMPLATE = EnvironmentVariable.get('EXPORT_CONTROL_CUSTOM_TEMPLATE');
    static final string EXP_CON_STATUS_SUBMIT = EnvironmentVariable.get('EXP_CON_STATUS_SUBMIT');
    static final string EXP_CON_STATUS_ONHOLD = EnvironmentVariable.get('EXP_CON_STATUS_ONHOLD');
    static final string EXP_CON_STATUS_APPROVED = EnvironmentVariable.get('EXP_CON_STATUS_APPROVED');
    
    static final string EXP_CON_GTC_EMAILADDRESS = EnvironmentVariable.get('EXP_CON_GTC_EMAILADDRESS');
   // public Id id{get; set;}
    public Attachment myfile{get;set;}
    public Attachment myfile2{get;set;}
    public Attachment myfile3{get;set;}
    public Attachment myfile4{get;set;}
    public boolean isReadOnly{get;set;}
    public boolean isSingleProduct{get;set;}
    public boolean isExpCusTemplate{get;set;}
    public List<ExportControlHSCode> expConHSCodeList1{get;set;}
    public List<psa_psc_eccn_default__c> eccnDefaultList{get;set;}
    
    public boolean isIntUser{get;set;}
    public boolean isQ3Yes{get;set;}
    public boolean isQ4Yes{get;set;}
    public boolean isITARxv{get;set;}
    public boolean isITARxva{get;set;}
    public boolean isITARxvc{get;set;}
    public boolean isITARxve{get;set;}
    public boolean isQ5Yes{get;set;}
    
    public AttachmentUploadUtil att = new AttachmentUploadUtil();
    Map<String,Attachment> attachMap = new Map<String,Attachment>();
    private Boolean isInternalDevice = false;  
    private Set<String> internalDeviceRecTypeSet = new Set<String>{'Internal_Device','Internal_Device_Read_Only'};
    
    public boolean displayPopup {get; set;}
    public boolean displayPopup1 {get; set;}
    public boolean displayErrorTxt {get; set;}
    public boolean displayErrorTxt1 {get; set;}
    public string psaValue {get; set;}
    public string pscValue {get; set;}
    
    //init method
    public PageReference init(){
        PageReference pr = null;
        if (!initialised){
            isIntUser=false;
            isLocked=false;
            String custPortalUsrTyp = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');  
            //updated by Vijay 02092015 - updated below code to support the Export control for internal Device        
            String userRole = (EnvironmentVariable.get('GTC_ROLE') != null) ? EnvironmentVariable.get('GTC_ROLE'): 'GTC - Global Trade Compliance' ;           
            
            Id profId = UserInfo.getProfileId();
            List<User> userList = [select Id, Profile.UserType, UserRole.Name from User where Id = :UserInfo.getUserId() limit 1];
            if(userList.size() > 0){
                
                //if(userList[0].Profile.UserType !=custPortalUsrTyp && (!isInternalDevice || userList[0].UserRole.Name == userRole)){
                if(userList[0].Profile.UserType !=custPortalUsrTyp){
                    isIntUser=true;
                    if(!ExportControl.isNewECForm__c && (ExportControl.Status__c==EXP_CON_STATUS_SUBMIT||ExportControl.Status__c==EXP_CON_STATUS_APPROVED)){
                        pr = new PageReference('/'+ExportControl.Id+'?nooverride=1');
                        pr.setRedirect(true);
                    }else{
                         if(!ApexPages.currentPage().getUrl().contains('ExportControlEditNEW') ){
                            pr = new PageReference('/apex/ExportControlEditNEW?deviceid='+devId);
                            pr.setRedirect(true);
                         }
                    }
                }else{
                    isIntUser=false;
                    if(!ExportControl.isNewECForm__c && (ExportControl.Status__c==EXP_CON_STATUS_SUBMIT||ExportControl.Status__c==EXP_CON_STATUS_APPROVED)){
                        if(!ApexPages.currentPage().getUrl().contains('ExportControlEdit') ){
                            pr = new PageReference('/apex/ExportControlEdit?deviceid='+devId);
                            pr.setRedirect(true);
                        }
                    }else{
                         if(!ApexPages.currentPage().getUrl().contains('ExportControlEditNEW') ){
                            pr = new PageReference('/apex/ExportControlEditNEW?deviceid='+devId);
                            pr.setRedirect(true);
                         }
                    }
            }
            initialised=true;
            }
        }
        return pr;
    
    }
    
    //Constructor for Custom Controller
    public ExportControlEditController(ApexPages.StandardController controller) {
        this.controller = controller;
        isIntUser=false;  
        isLocked=false;       
        Id id = ApexPages.currentPage().getParameters().get('deviceid');
        devId = id;
        system.debug('ID==>'+id);
        isSingleProduct=false;
        isQ4Yes=false;
        isQ3Yes=false;
        isITARxv=false;
        isITARxva=false;
        isITARxvc=false;
        isITARxve=false;
        isQ5Yes=false;
        displayPopup = false;
        displayPopup1 = false;
        displayErrorTxt = false;
        displayErrorTxt1 = false;
        
        Device_Export_Control_Junction__c devExpConJunc =  [select  Export_Control_Form__c,
                                                                    CRM_Device_ID__c,
                                                                    Customer_Name__c,
                                                                    Device_Name__c,
                                                                    Export_Control_Template__c,
                                                                    Fab__c,
                                                                    LastModifiedBy__c,
                                                                    Project_Name__c,
                                                                    Device__r.Design_Partner__r.Name,
                                                                    Device__r.Tapeout_Type__c,
                                                                    Device__r.RecordType.DeveloperName
                                                            from Device_Export_Control_Junction__c
                                                            where Device__c = :id limit 1];
        
        if(devExpConJunc.Device__r.Tapeout_Type__c!=null && devExpConJunc.Device__r.Tapeout_Type__c.equalsignorecase('Single Product'))isSingleProduct=true;
        deviceCRMDID = devExpConJunc.CRM_Device_ID__c;
        deviceAccountName = devExpConJunc.Customer_Name__c;
        deviceName = devExpConJunc.Device_Name__c;
        deviceFab = devExpConJunc.Fab__c;
        deviceProjName = devExpConJunc.Project_Name__c;
        deviceExpConTemplate = devExpConJunc.Export_Control_Template__c;
        string deviceDPName=devExpConJunc.Device__r.Design_Partner__r.Name;
        ExportControl = [SELECT Id,
                Account__r.Fab_9_10__c, // ARoy 02082017 - added check on Reassign button based on FMS Forms  
                                Status__c,
                                EC_Status__c,
                                isNewECForm__c,
                                OwnerId__c,
                                Last_Assigned_Customer_User__c,
                                Customer_Trade_Compliance_Contact_Person__c,
                                Phone__c,
                                EC_ENC_Type__c ,
                                ECCN_Wafer__c ,
                                ECCN_Technology__c, 
                                CreatedDate,
                                ITAR_Cat_Equipment__c,
                                ITAR_Cat_IC__c,
                                ITAR_Cat_Tech_Data__c,
                                b2_Desc_Type__c,
                                BIS_Registration__c,
                                Non_Encryption_ECCN_Technology__c,
                                b3_Desc_Type__c,
                                EC_CCATS__c,
                                D1_National_Access_is_Allowed__c,
                                ECCN_Product_Value__c,
                                ECCN_Technology_Data__c,
                                Encryption_Control_Product__c,
                                USG_Review_Date__c,
                                ITAR_Category__c,
                                ITAR_Category_Full__c,
                                Commercial_Satellite__c,
                                Fabricated_by_GF__c,
                                Anti_jam_system__c,
                                Used_by_Govt_of_Canada__c,
                                Designed_for_Antennas__c,
                                Designed_for_Att_Det__c,
                                Designed_for_Proplsn_Sys__c,
                                Email_Address__c,
                                Product_Description__c,
                                Weapon_Product__c,
                                Military_App_Product__c,
                                Military_App_Product_Details__c,
                                Submitted_Date__c,
                                ITAR_Product__c,
                                ITAR_Product_Details__c,
                                US_EAR_Product__c,
                                US_EAR_Product_Details__c,
                                Non_US_EAR_Product__c,
                                Non_US_EAR_Product_Details__c,
                                Harmonized_System__c,
                                Harmonized_System__r.Name,
                                Harmonized_System__r.HS_Code__c, 
                                Harmonized_System__r.HS_Description__c,
                                (select CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Alias, CreatedBy.UserRoleId from ProcessSteps where StepStatus = 'Started' order by CreatedDate desc limit 1),
                                Other_Harmonized_System__c,
                                End_User_Customer_Name__c,
                                CCAT_Number__c, ECCN_Color__c
                         FROM Export_Control_Form__c 
                         WHERE Id = :devExpConJunc.Export_Control_Form__c limit 1];
        isFab9_10Check = ExportControl.Account__r.Fab_9_10__c; // ARoy 02082017 - added check on Reassign button based on FMS Forms      
        //Initializing the customer portal name, phone and email address for Status = 'Undeclared'
        if(ExportControl.Status__c == 'Undeclared'){
            ExportControl.Customer_Trade_Compliance_Contact_Person__c = UserInfo.getLastName()+','+UserInfo.getFirstName();
            User usr = [select phone, email from User where id = :UserInfo.getUserId()];
            ExportControl.Phone__c = usr.phone;
            ExportControl.Email_Address__c = usr.email;
            ExportControl.OwnerId__c = UserInfo.getUserId();
            ExportControl.Last_Assigned_Customer_User__c = UserInfo.getUserId();
        }
        
        /*if(ExportControl.Status__c == 'Reassigned'){
            User usr = [select phone, LastName, FirstName, email from User where id = :ExportControl.OwnerId__c];
            ExportControl.Phone__c = usr.phone;
            ExportControl.Email_Address__c = usr.email;
            ExportControl.Customer_Trade_Compliance_Contact_Person__c = usr.LastName+','+usr.FirstName;
        }*/
        
        if(ExportControl.Status__c == EXP_CON_STATUS_ONHOLD){
            isOnhold=true;
        }else{
            isOnhold=false;
        }
        
        //added new mpw eccn changes
        List<MPWECCNConfigDP__c> dpList=[select id,Name from MPWECCNConfigDP__c];
        set<string> dpSet=new set<string>();
        for(MPWECCNConfigDP__c m:dpList){
            dpSet.add(m.Name);
        }
        
        List<MPWECCNConfigAccount__c> accList=[select id,Name from MPWECCNConfigAccount__c];
        set<string> accSet=new set<string>();
        for(MPWECCNConfigAccount__c m:accList){
            accSet.add(m.Name);
        }
        
        system.debug(accSet);
        system.debug(enableECCN);
        if((dpSet.contains(deviceDPName) || accSet.contains(deviceAccountName) )&& (deviceFab.contains('9')||deviceFab.contains('10'))&& devExpConJunc.Device__r.Tapeout_Type__c.equalsignorecase('Customer MPW')){
            enableECCN=true;
        }
         system.debug(enableECCN);
    
        if(ExportControl.Military_App_Product__c=='Yes')isQ3Yes=true;
        if(ExportControl.ITAR_Product__c=='Yes')isQ4Yes=true;
        if(ExportControl.ITAR_Category_Full__c=='XV')isITARxv=true;
        if(ExportControl.ITAR_Category__c=='XV(a)')isITARxva=true;
        if(ExportControl.ITAR_Category__c=='XV(e)')isITARxve=true;
        if(ExportControl.ITAR_Category__c=='XV(c)')isITARxvc=true; 
        if(ExportControl.Encryption_Control_Product__c=='Yes')isQ5Yes=true;
        if(Approval.isLocked(ExportControl.id))isLocked=true;     
        
        // Querying the Export Control HS code to get the values
        List<Export_Control_HS_Code__c> expConHSCodeList = [select ID, HS_Code__c, HS_Description__c from Export_Control_HS_Code__c order by HS_Code__c asc limit 10];
        expConHSCodeList1 = new List<ExportControlHSCode>();
        for(Export_Control_HS_Code__c expConHSCode : expConHSCodeList){
            ExportControlHSCode exp = new ExportControlHSCode(expConHSCode);
            if(ExportControl.Harmonized_System__c==exp.expConHSCodeId){
                exp.selected = true;
            }else{
                exp.selected = false;
            }
            expConHSCodeList1.add(exp);
        }
        
        // Checking the templates for conditional rendering of VF page
        if(devExpConJunc.Export_Control_Template__c==EXPORT_CONTROL_TEMPLATE){
            isExpCusTemplate=true;
        }else{
            isExpCusTemplate=false;
        }
        
        String custPortalUsrTyp = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');
        
        // Checking the status of the Export Control Form for Submitted, On-hold or Approved
        if(ExportControl.OwnerId__c != UserInfo.getUserId()||ExportControl.Status__c==EXP_CON_STATUS_SUBMIT||ExportControl.Status__c==EXP_CON_STATUS_ONHOLD||ExportControl.Status__c==EXP_CON_STATUS_APPROVED){
            String pageUrl = ApexPages.CurrentPage().getUrl();
            if((userinfo.getusertype()==custPortalUsrTyp) && ExportControl.OwnerId__c != UserInfo.getUserId() && pageUrl.indexOf('ExportControlPdf') == -1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You must be the owner in order to edit this form.'));  
            }            
            isReadOnly = true;
        }else{
            isReadOnly = false;
        }
        // For creation/updation of Attachment           
        attachMap =  att.getAttachments(id);
        myfile = attachMap.get(AttachmentUploadUtil.QUES_4_BEGIN);
        myfile.body=null;
        myfile2 = attachMap.get(AttachmentUploadUtil.QUES_5_BEGIN);
        myfile2.body=null;
        
        //myfile3 = attachMap.get(AttachmentUploadUtil.MPWAGG_BEGIN);
        //myfile3=new attachment();
        //List<attachment> mpwAggAttLst=[select id,name,ParentId ,description from attachment where parentid=:ExportControl.id order by createddate desc limit 1];
        //if(mpwAggAttLst.size()>0)myfile3=mpwAggAttLst[0];
        //myfile3.body=null;
        
        myfile4 = attachMap.get(AttachmentUploadUtil.QUES_5_NEW_BEGIN);
        myfile4.body=null;
        
        PageReference pgr = ApexPages.currentPage();
        system.debug('******************'+pgr.getUrl());
        queryStr = pgr.getParameters().get('retURL');
        if(queryStr <> null){
            queryStr = queryStr.substringAfter('/');
        }
        system.debug('1====>'+queryStr); 
        
        //======Check of Export Control Status for Submitted or Approved========//
        if(ExportControl.Status__c != null && (ExportControl.Status__c == EXP_CON_STATUS_SUBMIT || ExportControl.Status__c == EXP_CON_STATUS_APPROVED)){
            if(ExportControl.ProcessSteps!=null && ExportControl.ProcessSteps.size()>0 && ExportControl.ProcessSteps[0] != null){
                 List<UserRole> usrRole = [select name from UserRole where id = :ExportControl.ProcessSteps[0].CreatedBy.UserRoleId];  
                if(usrRole != null && !usrRole.isEmpty() && usrRole[0].name == EnvironmentVariable.get('GTC_ROLE')){
                    gtcUserName = ExportControl.ProcessSteps[0].CreatedBy.LastName+','+ExportControl.ProcessSteps[0].CreatedBy.FirstName;
                    isGTCUser = true;
                }
            }
        }          
        //===End for Check of Export Control Status for Submitted or Approved===//
        
        initialised = false;
        
        //added by Vijay - 02092015 - added Device Record type check
        if(devExpConJunc.Device__r.RecordType.DeveloperName != null && internalDeviceRecTypeSet.contains(devExpConJunc.Device__r.RecordType.DeveloperName)){
            isInternalDevice = true;
        }
        
        eccnDefaultList = new List<psa_psc_eccn_default__c>(); 
    }

    // Save the record.
    public PageReference saveRecord() {
        boolean isError = save();   
        //After Save, navigate to the visualforce page  
        if(!isError){
                PageReference expPage;
                if(ExportControl.Status__c != null && (ExportControl.Status__c == EXP_CON_STATUS_SUBMIT || ExportControl.Status__c == EXP_CON_STATUS_APPROVED))expPage = new PageReference('/apex/ExportControlEdit');
                else expPage = new PageReference('/apex/ExportControlEditNEW');
                expPage.getParameters().put('deviceid',devId);
                expPage.getParameters().put('retURL','/'+devId);
                String chkPg = ApexPages.currentPage().getParameters().get('type');
                if(chkPg == 'list'){
                    expPage.getParameters().put('type','list');
                }
                expPage.setRedirect(true);
                return expPage;
        }
        return null;      
    }
    
    //Save new ECCN Technology mapping on psa psc eccn default object
    public PageReference saveValue(){
        if(ExportControl.ECCN_Technology__c != null && ExportControl.ECCN_Technology__c != '' && ExportControl.D1_National_Access_is_Allowed__c != null && ExportControl.D1_National_Access_is_Allowed__c != '' && psaValue != null && psaValue != '' && pscValue != null && pscValue != '' &&  ExportControl.ECCN_Color__c != null && ExportControl.ECCN_Color__c != ''){
            List<psa_psc_eccn_default__c> pscpsaDefList = new List<psa_psc_eccn_default__c>();
            pscpsaDefList = [SELECT Name from psa_psc_eccn_default__c where Name =: ExportControl.ECCN_Technology__c];
            if(!pscpsaDefList.isEmpty()){
                displayPopup1 = true;
                displayErrorTxt = false;
                displayErrorTxt1 = true;
                return null;
            }else{
                psa_psc_eccn_default__c eccnDefault = new psa_psc_eccn_default__c();
                eccnDefault.Name = ExportControl.ECCN_Technology__c;
                eccnDefault.D1_National_Access_Allowed__c = ExportControl.D1_National_Access_is_Allowed__c;
                eccnDefault.psa_eccn__c = psaValue;
                eccnDefault.psc_eccn__c = pscValue;
                eccnDefault.ECCN_Color__c = ExportControl.ECCN_Color__c;
                insert eccnDefault;
                displayPopup = false;
                displayPopup1 = false;
                displayErrorTxt = false;
                displayErrorTxt1 = false;
                sendemailtoGTCmember();
                return null;
            }
        }else{
            displayPopup1 = true;
            displayErrorTxt = true;
            displayErrorTxt1 = false;
            return null;
        }
    }
    
    //Send email notification to specific GTC User on adding new ECCN Technology mapping on psa psc eccn default object
    Public void sendemailtoGTCmember(){
         List<String> listofuseremail = new List<String>();
         if(EXP_CON_GTC_EMAILADDRESS != null && EXP_CON_GTC_EMAILADDRESS != ''){
            listofuseremail.addAll(EXP_CON_GTC_EMAILADDRESS.split('[,;]'));
         }
         List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
         Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
         if(!listofuseremail.isEmpty()){
            singleMail.setToAddresses(listofuseremail);
            singleMail.setSubject('ACTION REQUIRED - NEW ECCN MAPPING');
            String body = 'Dear Recipients,';
            body+= '<br/>';
            body+= '<br/>';
            body+= 'GTC has added the following ECCN - Technology value, its associated export control color, D1 and PSC/PSA attributes to the master ECCN / COLOR mapping table';
            body+= '<br/>';
            body+= '<br/>';
            body+= 'ECCN - Technology :' +ExportControl.ECCN_Technology__c;
            body+= '<br/>';
            body+= 'D1 National Access Allowed :' +ExportControl.D1_National_Access_is_Allowed__c;
            body+= '<br/>';
            body+= 'PSC :' +pscValue;
            body+= '<br/>';
            body+= 'PSA :' +psaValue;
            body+= '<br/>';
            body+= 'ECCN Color :' +ExportControl.ECCN_Color__c;
            body+= '<br/>';
            body+= '<br/>';
            body+= 'Please refer to the following link for accessing the Device :-<br/>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+devId;
            body+= '<br/>';
            body+= '<br/>';             
            body+= 'Please update your systems and tables accordingly.';
            body+= '<br/>';
            body+= '<br/>';
            body+= '<address>Please contact the GTC team at <a href="mailto:globaltrade@globalfoundries.com">globaltrade@globalfoundries.com</a> if you have any questions.</address>';
            singleMail.setHtmlBody(body);
            newMails.add(singleMail);
         }
        if(!newMails.isEmpty()){
            Messaging.sendEmail(newMails);
        }
    }
    
    // Save the record and Reassign
    public PageReference saveWithReassign() {       
        boolean isError = save();        
        //After Save, navigate to the visualforce page
        if(!isError){                     
            PageReference expPage = new PageReference('/apex/ExportControlReassignOwner');
            expPage.getParameters().put('id',ExportControl.Id);
            expPage.getParameters().put('deviceid',devId);
            String chkPg = ApexPages.currentPage().getParameters().get('type');
            if(chkPg == 'list'){
                expPage.getParameters().put('type','list');                   
            }
            expPage.setRedirect(true);
            return expPage;         
        }
        return null;      
    }
    
    // Submission of Approval    
    public PageReference submitForApproval() {
        boolean isError = save();   
        if(!isError){
            ExpConFormApprovalController ecfAppConObj = new ExpConFormApprovalController();
            String returnMessage = ecfAppConObj.validateECForm(ExportControl);                      
            if(returnMessage==''){ 
                // Calling standard approval process
                boolean isSuccess = approvalSubmit(ExportControl.Id);
                if(isSuccess){
                    PageReference expPage;
                    if(ExportControl.Status__c != null && (ExportControl.Status__c == EXP_CON_STATUS_SUBMIT || ExportControl.Status__c == EXP_CON_STATUS_APPROVED))expPage = new PageReference('/apex/ExportControlEdit');
                    else expPage = new PageReference('/apex/ExportControlEditNEW');
                    expPage.getParameters().put('deviceid',devId);
                    expPage.getParameters().put('retURL','/'+devId);
                    String chkPg = ApexPages.currentPage().getParameters().get('type');
                    if(chkPg == 'list'){
                        expPage.getParameters().put('type','list');
                    }
                    expPage.setRedirect(true);
                    return expPage;
                }
            }else if(returnMessage <> ''){
                returnMessage = returnMessage.removeEnd('<br/>');
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,returnMessage));
            }
        }
        return null;
    }
    
    // Save function invoked when Save, Submit or Reassign operations are performed
    private boolean save(){
        try {            
            ExportControlEditController.hasRun = true;
            boolean isNotValid = false;
            boolean isError = false;
            List<Attachment> listAttach = new List<Attachment>();   
            if(ExportControl.ECCN_Technology__c != '' && ExportControl.ECCN_Technology__c != null && ExportControl.ITAR_Product__c != null && ExportControl.ITAR_Product__c != '' && ExportControl.ITAR_Product__c == 'No'){
                eccnDefaultList = [SELECT name, D1_National_Access_Allowed__c, psa_eccn__c, psc_eccn__c, ECCN_Color__c from psa_psc_eccn_default__c where name = :ExportControl.ECCN_Technology__c];
                if(!eccnDefaultList.isEmpty()){
                    ExportControl.D1_National_Access_is_Allowed__c = eccnDefaultList[0].D1_National_Access_Allowed__c;
                    ExportControl.ECCN_Color__c = eccnDefaultList[0].ECCN_Color__c;  
                }else if((ExportControl.ECCN_Technology__c).startsWithIgnoreCase('itar')){
                        eccnDefaultList = [SELECT name, D1_National_Access_Allowed__c, psa_eccn__c, psc_eccn__c, ECCN_Color__c from psa_psc_eccn_default__c where name = 'ITAR'];
                        ExportControl.D1_National_Access_is_Allowed__c = eccnDefaultList[0].D1_National_Access_Allowed__c;
                        ExportControl.ECCN_Color__c = eccnDefaultList[0].ECCN_Color__c;   
                        //After Save, navigate to the visualforce page  
                }else{
                    displayPopup = true;
                    displayPopup1 = false;
                    displayErrorTxt = false;
                    displayErrorTxt1 = false;
                    return true;
                }
            }else if(ExportControl.ITAR_Product__c != null && ExportControl.ITAR_Product__c != '' && ExportControl.ITAR_Product__c == 'Yes'){
                ExportControl.D1_National_Access_is_Allowed__c = 'No';
                ExportControl.ECCN_Color__c = 'Red';
            }
            if(expConHSCodeList1.size()>0){
                Integer i=0;
                for(ExportControlHSCode expConHSCode : expConHSCodeList1){                  
                    if(expConHSCode.selected){
                        if(expConHSCode.expConHSCode!='Other'){
                            ExportControl.Other_Harmonized_System__c = '';
                        }
                        ExportControl.Harmonized_System__c = expConHSCode.expConHSCodeId;
                        i++;
                    }
                }
                if(i==0){
                    ExportControl.Other_Harmonized_System__c = '';
                    ExportControl.Harmonized_System__c = null;
                }
            }
            // Validation of the data of Export Control
            //isNotValid = checkDataValid(ExportControl);
            //if(!isNotValid){
                
            if(ExportControl.Status__c=='Undeclared'){
                ExportControl.Status__c = 'Draft';
                ExportControl.OwnerId__c = UserInfo.getUserId();
            }
            if(ExportControl.Status__c!='Approved'||ExportControl.Status__c!='Submitted'){
                ExportControl.isNewECForm__c = true;
            }
            // Data upsertion for Export Control
            upsert(ExportControl);
                        
            if(att.parentId==null){
                att.parentId = ExportControl.Id;
            }
            
            //  Uploading attachment 
            att.attachMap.put(AttachmentUploadUtil.QUES_4_BEGIN,myfile);
            att.attachMap.put(AttachmentUploadUtil.QUES_5_BEGIN,myfile2);
            //att.attachMap.put(AttachmentUploadUtil.MPWAGG_BEGIN,myfile3);
            att.attachMap.put(AttachmentUploadUtil.QUES_5_NEW_BEGIN,myfile4);
            
            isError = att.saveAttachList();
            /*}else{
                isError = true;
            }*/
                                 
            return isError;            
           
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return false;
        }
    }
    
    // Cancel functionality
    public PageReference cancel() {
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg=='list'){
            PageReference expPage = new PageReference('/apex/MyDevices?sfdc.tabName=01r900000003eSG');
            expPage.getParameters().put('name','ExportControl');
            expPage.setRedirect(true);
            return expPage;
        }else{
            String queryParam = ApexPages.currentPage().getParameters().get('deviceid');
            if(UtilsString.isNotBlank(queryParam)){
                PageReference pgr1 = new PageReference('/'+queryParam);             
                pgr1.setRedirect(true);
                return pgr1;
            }
            return controller.cancel();
        }
    }
    
    // Sending request for approval process
    private boolean approvalSubmit(Id id){
        try{
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(id);
            system.debug('Id==>'+id);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            // Return the result status
            return result.isSuccess();
        }catch(System.DMLException e){
            system.debug('Exception===>'+e.getMessage());
            ApexPages.addMessages(e);
            return false;
        }
    }
    
    // Checking if data is valid for submit for approval

    
    public boolean isOnhold{get;set;}
    public void toggleOnhold(){
        string message='';
        try{
        if(ExportControl != null){           
            if(ExportControl.Status__c == EXP_CON_STATUS_SUBMIT){
                ExportControl.Status__c = EXP_CON_STATUS_ONHOLD;
                isOnhold=true;
                 message = 'Status changed to '+EXP_CON_STATUS_ONHOLD+' successfully';
            }else if(ExportControl.Status__c == EXP_CON_STATUS_ONHOLD){
                ExportControl.Status__c = EXP_CON_STATUS_SUBMIT;
                isOnhold=false;
                message = 'Status changed to '+EXP_CON_STATUS_SUBMIT+' successfully';
            }
            
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM,message));
            update ExportControl;
        }
        }catch(Exception E){
                message = E.getmessage();
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,message));
            
        }
    }
    
    public pagereference editRecord(){
        isReadOnly=false;
        return null;
    }
    
    public pagereference unlockRecord(){
        try{
        Approval.unlock(Exportcontrol.id);
        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM,'Unlocked successfully'));
            update ExportControl;
            }catch(Exception E){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,E.getmessage()));
            }
        return null;
    }
    
    public pagereference reOpenRec() {
        try{
            String roleGTC = EnvironmentVariable.get('GTC_ROLE');
            String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
            String expConStatusApproved = EnvironmentVariable.get('EXP_CON_STATUS_APPROVED');
            String expConStatusPendingResubmission = EnvironmentVariable.get('EXP_CON_STATUS_PENDING_RESUBMISSION');           
            String returnMsg = 'NOT OK';
            String usrRole = '';
            String profName = '';
            
            Id usrRoleId = UserInfo.getUserRoleId();
            List<UserRole> usrRoleList = [select name from UserRole where Id = :usrRoleId limit 1];
            if(usrRoleList.size()>0){
                usrRole = usrRoleList[0].Name;
            }
            
            Id profId = UserInfo.getProfileId();
            List<Profile> profNameList = [select name from Profile where Id = :profId limit 1];
            if(profNameList.size()>0){
                profName = profNameList[0].Name;
            }
            
            if(usrRole == roleGTC || profName == sysAdmin){                                     
               
                if(ExportControl!= null && ExportControl.Status__c == expConStatusApproved){
                    ExportControl.Status__c = expConStatusPendingResubmission;
                    //ExportControl.OwnerId__c = ExportControl.Last_Assigned_Customer_User__c;
                    update ExportControl;
                    //ExpCntrlFrmService.sendMail(ExportControl);
                    returnMsg = 'OK';
                    pagereference pr=new PageReference('/apex/ExportControlEditNEW?deviceid='+devId);
                    pr.setredirect(true);
                    return pr;
                    
                }else if(ExportControl!= null && ExportControl.Status__c != expConStatusApproved){
                    returnMsg = 'NotApproved';
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.Error,'The Re-open operation is only possible when the status is Approved'));             
                    
                }
            }else{
                returnMsg = 'NotPermitted';
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.Error,'You are not authorized to perform the Re-open operation. Only GTC users are authorized.'));
                
           }
           
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.Error,ex.getMessage()));
           
        }
        return null;
 
    }
    
    // Inner class for Export Control HS Code
    class ExportControlHSCode{
        public boolean selected {get;set;}
        public ID expConHSCodeId {get;set;}
        public String expConHSCode{get;set;}
        public String expConHSDescription{get;set;}
        
        public ExportControlHSCode(Export_Control_HS_Code__c exp){
            selected = false;
            expConHSCodeId = exp.Id;
            expConHSCode = exp.HS_Code__c;
            expConHSDescription = exp.HS_Description__c;
        }
    }
    
    public void closePopup() {
        displayPopup = false;
        displayPopup1 = false;
        displayErrorTxt = false;
        displayErrorTxt1 = false;
    }
    
    public void showPopup1() {
        displayPopup = false;
        displayPopup1 = true;
        displayErrorTxt = false;
        displayErrorTxt1 = false;
    }
}