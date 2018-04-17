/**
 * Change History:
    DATE            NAME                    Comments
    6-Dec-2016      Inshu Misra             Added code for exception framework...#IM
    12-Dec-2016     Anil Kumar Reddy L      Added code for updating device FMS ID field with form name field.
    3-Jan-2017      Anil Kumar Reddy L      Modified code for including device values in copy funtionality.
    27-Jan-2017     Anil Kumar Reddy L      Modified code for bug fixes.
    06-Mar-2017     Abhita Bansal           Changed the logic in component for #DEF 257, 381
    05-Jun-2017     Ram Rai                 Defect fix for form updation detail of Step Plan.
    06-Jun-2017     Ram Rai                 Defect fix cancel of updation of form detail Step Plan.  
    08-Jun-2017     Inshu Misra             modified clone method call...#IM
    27-Jun-2017     Anirban Roy             modified code for DMEA flow line no # 45, 100
    28-Jun-2017     Anirban Roy             modified to add hard coded values into custom settings
    17-Jul-2017     Anirban Roy             modified for EC Junction creation
    17-Jul-2017     Inshu Misra             Modified query against ExportControl IMC issue
    01-Aug-2017     Abhita Bansal           Modified the code to associate the correct device on creation 
    04-Sept-2017    Abhita Bansal           Added the code for Legacy form
 * */
public class FMSChildCreationController {
    
    public Form_Management_System__c formObj{get;set;}
    public String formType {get;set;}
    public Id formId {get;set;}
    public String tranx {get;set;}
    public String targCustomerPortUser{get;set;}
    public List<contact> contactInfo{get;set;}
    public String custName {get;set;}
    public String selAddendum{get;set;}
    public boolean isDMEA{get;set;}     
    public String selDMEAAccount{get;set;}   
    public String selDMEAAccountName{get;set;}
    public List<Account> dmeaList = new List<Account>();  
    public Id extUserAccountId{get;set;}  
    public String fromNameCopy{get;set;}
    public String formDescriptionCopy {get;set;} 
    public Form_Management_System__c mainRecord;
    public Form_Management_System__c formObjCopy;   
    public String basedeviceId = null;
    public User loggedInUser;  
    public String deviceAccId;
    public Id deviceId;
    public Id parentId {get;set;}
    public Id opportunityId;
    public Id opportunityProgramId;
    public String tapeoutType;
    public Id mainFormDevice;
    public device__c retrofitDeviceCreate;
    public List<Device__c> parentDevice; //Modified the code to associate the correct device on creation - 01082017
    public String parentNameVal{get;set;}
    public String pageURL;
    public Boolean isRITAllowed{
        get{
            Form_Management_System__c fmsObj = [select Id, Device__c, Device__r.Export_Control_Status__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Form_Type__c, Customer_Name__r.Contract_Customer__c from Form_Management_System__c where Id =:parentId];
            return UtilityCls.isRITAddendumAllowed(fmsObj);
        }
        set;
    }
    
    public Form_Management_System__c parentServiceOpts{get;set;}
    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO'); 

    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM'); 
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM'); 
    public final String FMS_DDR_FORM = EnvironmentVariable.get('FMS_DDR_FORM'); 
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM'); 
    public final String FMS_SELECT_VALUE = EnvironmentVariable.get('FMS_SELECT_VALUE'); 
    public final String FMS_IMC_FORM_SHRT = EnvironmentVariable.get('FMS_IMC_FORM_SHRT'); 
    public final String FMS_RIT_FORM_SHRT = EnvironmentVariable.get('FMS_RIT_FORM_SHRT'); 
    public final String FMS_DDR_FORM_SHRT = EnvironmentVariable.get('FMS_DDR_FORM_SHRT'); 
    public final String FMS_MAIN_FORM_SHRT = EnvironmentVariable.get('FMS_MAIN_FORM_SHRT'); 
    public final String FMS_SP_FORM_SHRT = EnvironmentVariable.get('FMS_SP_FORM_SHRT'); 
    
    public boolean dispIMCDatacheckingOpts;//Added by Abhita for Legacy form - 20092017
    public boolean dispDataCheckingOpts;//Added by Abhita for Legacy form - 05092017
    public boolean isRunTest;//Added by Abhita for Legacy form - 05092017
    private Boolean contentCheck;
    private Boolean contentECCNCheck;
    private Id contentDocId;
    private Id contentECCNDocId;
    
    public FMSChildCreationController(ApexPages.StandardController controller) {
        parentDevice = new list<Device__c>();//Modified the code to associate the correct device on creation - 01082017
        contactInfo = new List<Contact>();
        isDMEA = false;
        tapeoutType = null;
        fromNameCopy = '';
        formDescriptionCopy = ''; 
        isRunTest = false;
        contentCheck = false;
        contentECCNCheck = false;
        formObj = (Form_Management_System__c) controller.getRecord();
        
        pageURL = ApexPages.currentPage().getUrl();
        formId = ApexPages.currentPage().getParameters().get('id');
        tranx = ApexPages.currentPage().getParameters().get('tranx');
        parentId = ApexPages.currentPage().getParameters().get('ParentId');
        formType = ApexPages.currentPage().getParameters().get('Type');
        deviceId =  ApexPages.currentPage().getParameters().get('DeviceId');        
        deviceAccId = ApexPages.currentPage().getParameters().get('AccountId');

        opportunityId = ApexPages.currentPage().getParameters().get('OppId');
        opportunityProgramId = ApexPages.currentPage().getParameters().get('OppProgramId');
        
        parentNameVal = ApexPages.currentPage().getParameters().get('parentName') ;

        if(deviceId!=null){
            //Modified the code to associate the correct device on creation - 01082017
            parentDevice = [Select id,Base_Device__c,Tapeout_Type__c,Account__c, Account__r.Name, Device_Type__c, account__r.Contract_Customer__c, Opportunity2__c, Opportunity_Program__c from Device__c Where id =:deviceId] ;
            /*End*/
            if(parentDevice.size()>0){
                if(parentDevice.get(0).Device_Type__c == 'Retrofit'){
                        tapeoutType = parentDevice.get(0).Tapeout_Type__c;
                        formType = FMS_IMC_FORM_SHRT;  
                }
                if(formType == FMS_MAIN_FORM_SHRT){
                    formObj.Customer_Name__c = parentDevice.get(0).Account__c;
                }
            }
        }
              
        if(tranx == 'Create') {
            /*-----Start the code By Abhita-----Modified the code to associate the correct device on creation - 01082017*/
            loggedInUser = [SELECT id, Email, ContactId, Contact.Account.Name, Contact.Account.SAP_Account_Number__c FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];//Chnaged By Abhita
            if(formType == FMS_MAIN_FORM_SHRT) {              
                if(loggedInUser != null && (loggedInUser.ContactId != null && String.valueOf(loggedInUser.ContactId) != '')){
                    //contactInfo = [SELECT id, Name, AccountId, Account.Name, Account.SAP_Account_Number__c FROM Contact WHERE id = :loggedInUser.ContactId LIMIT 1]; 

                    //if(!contactInfo.isEmpty()){
                        if(!checkFormCompany(loggedInUser.Contact.Account.SAP_Account_Number__c, SAP_ACC_NO)){   
                            isDMEA = false;                     
                            targCustomerPortUser = parentDevice.get(0).Account__r.Name ; 
                            extUserAccountId = parentDevice.get(0).Account__c;                        
                        }
                    //}
                    /*-----End the code By Abhita-----*/
                }
                List<Device__c> devLst = [select Account__c,Account__r.Name,Account__r.SAP_Account_Number__c,Design_Partner__c,Design_Partner__r.Name from Device__c where id = :deviceId];                
                dmeaList = [SELECT id, Name, SAP_Account_Number__c, Customer_Category__c FROM Account WHERE Customer_Category__c = 'TFA' OR Customer_Category__c = 'CC' OR SAP_Account_Number__c = :SAP_ACC_NO];
                
                if(devLst!=null && devLst.size()>0 && checkFormCompany(devLst[0].Account__r.SAP_Account_Number__c, SAP_ACC_NO)){                                       
                    if(devLst!=null && devLst.size()>0 && devLst[0].Design_Partner__c!=null){
                        selDMEAAccount = devLst[0].Design_Partner__c;
                        selDMEAAccountName = devLst[0].Design_Partner__r.Name;
                    }else{
                        selDMEAAccount = devLst[0].Account__c;
                        selDMEAAccountName = devLst[0].Account__r.Name;
                    }
                    isDMEA = true;
                }     
            } else {            
                if(parentId != null){
                    String fmsFields = '';
                    fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
                    fmsFields += ', Main_Form_Id__r.Device__c, Device__r.CRMDID__c '; 
                    fmsFields += ', Main_Form_Id__r.Technology__c, Main_Form_Id__r.ReleaseProcessFlow__c ';
                    fmsFields += ', Parent_Form_Id__r.DataCheckingOptions__c, Parent_Form_Id__r.StepPlanCustomRequirement1__c ';
                    fmsFields += ', Main_Form_Id__r.TestServices__c, Main_Form_Id__r.Packaging_Services__c ';
                    fmsFields += ', Main_Form_Id__r.ItarData__c, Parent_Form_Id__r.OverrideParentOptions__c ';
                    string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+ parentId +'\'';
                    mainRecord = database.query(soql); //Modified by Abhita for Legacy form - 05092017
                    custName = mainRecord.Customer__c;
                    if(deviceId==null){
                        basedeviceId = mainRecord.Device__c;
                        mainFormDevice = mainRecord.Main_Form_Id__r.Device__c;                       
                    }
                }
            }
        }
        
        if(tranx == 'Edit' || tranx == 'Copy') { 
            formObj = [Select Customer__c, Form_Name__c, Form_Description__c, Customer_Name__c, Parent_Form_Id__c, Copied_Form_Number__c from Form_Management_System__c where Id =: formId];         
            if(tranx == 'Copy'){
                fromNameCopy = 'Copy of '+formObj.Form_Name__c;
            }
        }
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
        
    public List<SelectOption> getDMEAAccountList(){
        List<SelectOption> tempList = new List<SelectOption>(); 
        tempList.add(new SelectOption('', FMS_SELECT_VALUE));
        String soldTo;        
        dmeaList = [SELECT id, Name, SAP_Account_Number__c, Customer_Category__c FROM Account WHERE Customer_Category__c = 'TFA' OR Customer_Category__c = 'CC' OR SAP_Account_Number__c = :SAP_ACC_NO];        
        
        if(!dmeaList.isEmpty()){
            for(Account acc : dmeaList){
                tempList.add(new SelectOption(acc.Id, acc.Name));
            }
        }    
        return tempList;
    }        
    
    public PageReference continueCheck(){ 
        PageReference pg;  
        boolean val = false;     
        boolean valAddendum = false;//Added by Abhita for Legacy form - 05092017
        
        if(((targCustomerPortUser == null || targCustomerPortUser == '') && !isDMEA) && (formObj.Customer_Name__c == null) && formType == FMS_MAIN_FORM_SHRT && tranx == 'Create'){         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Target Customer is a Reqired field'));
            val = true;
        }
        
        if((selDMEAAccount == null || selDMEAAccount == '') && isDMEA && formType == FMS_MAIN_FORM_SHRT && tranx == 'Create'){            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Target Customer is a Reqired field'));
            val = true;
        }
        
        if(formObj.Form_Name__c == null || formObj.Form_Name__c == ''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Form name is a Required field'));
             val = true;
        }
        if(val){
            return null;
        }
        
        if(formObj.id != null) { 

            if(tranx == 'Copy'){
                
                if(formType == FMS_MAIN_FORM_SHRT){
                    
                    String fmsFields = '';
                    fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
                    fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c';       
                    string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+ formObj.id +'\' LIMIT 1';
                    
                    formObj = database.query(soql);
                    
                }else if((formType == FMS_IMC_FORM_SHRT || formType == FMS_RIT_FORM_SHRT || formType == FMS_DDR_FORM_SHRT) && String.valueOf(parentId) != ''){
                    
                    String fmsFields = '';
                    fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
                    fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c';       
                    string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+ formObj.id +'\' LIMIT 1';
                    
                    formObj = database.query(soql);             
                    
                }
                
                formObjCopy = formObj.clone(false,true,false,true);
                formObjCopy.Form_Name__c = fromNameCopy;
                formObjCopy.State_of_the_Form__c = 'Draft';
                formObjCopy.Form_Description__c = formDescriptionCopy; 
                formObjCopy.Copied_Form_Number__c = formObj.Name;
                
                //make inactive fields blank
                List<FMS_Mapping_Table__c> lstFMSTableValidate = [Select Id,DB_value__c,Technology__c,Field__c,Is_Inactive__c,FMS_Field_API__c FROM FMS_Mapping_Table__c WHERE Is_Inactive__c = True];
                map<String,set<String>> mpFMSTableValidate = new map<String,set<String>>(); 
                set<String> stFMSField = new set<String>(); 
                for(FMS_Mapping_Table__c fmsMap : lstFMSTableValidate) {
                  if(fmsMap.FMS_Field_API__c != NULL) {
                    stFMSField.add(fmsMap.FMS_Field_API__c);
                  }                  
                  if(fmsMap.Technology__c != NULL && fmsMap.FMS_Field_API__c != NULL) {                  	
                    if(!mpFMSTableValidate.containsKey(fmsMap.Technology__c+'-'+fmsMap.FMS_Field_API__c)) {
                      mpFMSTableValidate.put(fmsMap.Technology__c+'-'+fmsMap.FMS_Field_API__c,new set<String>{fmsMap.DB_Value__c});
                    }
                    else {
                      mpFMSTableValidate.get(fmsMap.Technology__c+'-'+fmsMap.FMS_Field_API__c).add(fmsMap.DB_Value__c);
                    }
                  }
                  if((fmsMap.Technology__c == 'All' || fmsMap.Technology__c == NULL) && fmsMap.FMS_Field_API__c != NULL) {                  	
                    if(!mpFMSTableValidate.containsKey(fmsMap.Technology__c+'-'+fmsMap.FMS_Field_API__c)) {
                      mpFMSTableValidate.put(fmsMap.FMS_Field_API__c,new set<String>{fmsMap.DB_Value__c});
                    }
                    else {
                      mpFMSTableValidate.get(fmsMap.FMS_Field_API__c).add(fmsMap.DB_Value__c);
                    }
                 }
               }
               for(String sField : stFMSField) {
               	 String val1 = formObjCopy.get(sField) == NULL ? '' : String.valueOf(formObjCopy.get(sField)); 
               	 if(mpFMSTableValidate.containsKey(sField) && mpFMSTableValidate.get(sField).contains(val1)) {
               	   formObjCopy.put(sField,NULL);
               	 } 
                 if(formObjCopy.Technology__c != NULL) {
                   String Key = formObjCopy.Technology__c+'-'+sField;
                   String val2 = formObjCopy.get(sField) == NULL ? '' : String.valueOf(formObjCopy.get(sField)); 
                   if(mpFMSTableValidate.containsKey(key) && mpFMSTableValidate.get(key).contains(val2)) {
                     formObjCopy.put(sField,NULL);
                   } 
                 }
               }																							  
                //
                if(formObj.Mandatory_State_Change_Comments__c != null && formObj.Mandatory_State_Change_Comments__c != '') {
                    formObjCopy.Mandatory_State_Change_Comments__c = '';
                }
                if(formType == FMS_MAIN_FORM_SHRT) {
                    formObjCopy.Device__c = deviceId;
                    formObjCopy.Opportunity__c = (parentDevice.size()>0)?parentDevice[0].Opportunity2__c:formObjCopy.Opportunity__c;
                    formObjCopy.Opportunity_Program__c = (parentDevice.size()>0)?parentDevice[0].Opportunity_Program__c:formObjCopy.Opportunity_Program__c;
                    formObjCopy.StepPlanRotationActive__c = '';
                    formObjCopy.minScribeXVal__c = '';
                    formObjCopy.minScribeYVal__c = '';
                    formObjCopy.minSpdScribeXVal__c = '';
                    formObjCopy.minSpdScribeYVal__c = '';
                    formObjCopy.DesignNotch__c = '';
                    formObjCopy.minWlcspScribeXVal__c = '';
                    formObjCopy.minWlcspScribeYVal__c = '';
                    formObjCopy.StepPlanRotationWlcspEnabled__c = '';
                    
                    if(formObj.AdvancedProcessFileAttachment__c != null && formObj.AdvancedProcessFileAttachment__c != '') {
                        ContentVersion contentVerRec = cloneContentVerRec(formObj.AdvancedProcessFileAttachment__c);
                        formObjCopy.AdvancedProcessFileAttachment__c = contentVerRec.Id;
                        contentCheck = true;
                        contentDocId = getcontentDocId(contentVerRec.Id);
                    } else if(formObj.FileAttachment__c != null && formObj.FileAttachment__c != '') {
                        ContentVersion contentVerRec = cloneContentVerRec(formObj.FileAttachment__c);
                        formObjCopy.FileAttachment__c = contentVerRec.Id;
                        contentCheck = true;
                        contentDocId = getcontentDocId(contentVerRec.Id);
                    }
                    if(formObj.ECCN_attachmentName__c != null && formObj.ECCN_attachmentName__c != '') {
                        ContentVersion contentVerRec = cloneContentVerRec(formObj.ECCN_attachmentName__c);
                        formObjCopy.ECCN_attachmentName__c = contentVerRec.Id;
                        contentECCNCheck = true;
                        contentECCNDocId = getcontentDocId(contentVerRec.Id);
                    }
                }
                if(formType == FMS_IMC_FORM_SHRT){
                    Id contentId;
                    deviceId = createRetrofitDevice(formObj.Device__c).Id;
                    formObjCopy.Device__c = deviceId;
                                        
                    if(formObj.AdvancedProcessFileAttachment__c != null && formObj.AdvancedProcessFileAttachment__c != '') {
                        ContentVersion contentVerRec = cloneContentVerRec(formObj.AdvancedProcessFileAttachment__c);
                        formObjCopy.AdvancedProcessFileAttachment__c = contentVerRec.Id;
                        contentCheck = true;
                        contentDocId = getcontentDocId(contentVerRec.Id);
                    } else if(formObj.FileAttachment__c != null && formObj.FileAttachment__c != '') {
                        ContentVersion contentVerRec = cloneContentVerRec(formObj.FileAttachment__c);
                        formObjCopy.FileAttachment__c = contentVerRec.Id;
                        contentCheck = true;
                        contentDocId = getcontentDocId(contentVerRec.Id);
                    }
                }
                if((formType == FMS_RIT_FORM_SHRT || formType == FMS_IMC_FORM_SHRT || formType == FMS_DDR_FORM_SHRT) && String.valueOf(parentId) != ''){
                    formObjCopy.Parent_Form_Id__c = parentId;
                    formObjCopy.Main_Form_Id__c = formObj.Main_Form_Id__c;
                }
                try{                  
                    UtilityCls.saveHistory = false;
                    if(formObjCopy.Form_Name__c == null || formObjCopy.Form_Name__c == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Form name is a Required field'));
                        val = true;
                    }
                    
                    if(val){
                        return null;
                    }
                    insert formObjCopy;
                    if(contentCheck) {
                        linkContentDoc(formObjCopy.Id, contentDocId);
                        List<Form_Management_System__c> fmsNewList = new List<Form_Management_System__c>();
                        fmsNewList.add(formObjCopy);
                        UtilityCls.createContent(fmsNewList);
                    }
                    if(contentECCNCheck) {
                        linkContentDoc(formObjCopy.Id, contentECCNDocId);
                        List<Form_Management_System__c> fmsNewList = new List<Form_Management_System__c>();
                        fmsNewList.add(formObjCopy);
                        UtilityCls.createContent(fmsNewList);
                    }
                }catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'continueCheck()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    return null;
                }
            }else{
                try{
                    update formObj;
                } catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'continueCheck()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
            }
            
            if(tranx == 'Copy'){
                
                if(formType == FMS_MAIN_FORM_SHRT){
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSmainFormCreationPg1?id='+formObjCopy.id);
                    } else {
                        pg = new PageReference('/apex/FMSmainFormCreationPg1?id='+formObjCopy.id); 
                    }
                } else if (formType == FMS_IMC_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSIMCFormPage?id='+formObjCopy.id);
                    } else {
                        pg = new PageReference('/apex/FMSIMCFormPage?id='+formObjCopy.id); 
                    }
                } else if (formType == FMS_RIT_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSRITFormNewEditPage1?id='+formObjCopy.id);
                    } else {
                        pg = new PageReference('/apex/FMSRITFormNewEditPage1?id='+formObjCopy.id); 
                    }
                } else if (formType == FMS_DDR_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSDDRFormPage?id='+formObjCopy.id);
                    } else {
                        pg = new PageReference('/apex/FMSDDRFormPage?id='+formObjCopy.id); 
                    }
                }
                pg.getParameters().put('tranx', tranx);
            } else if(tranx == 'Edit') {
                if(formType == FMS_MAIN_FORM_SHRT){
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSmainFormViewPage?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSmainFormViewPage?id='+formObj.id); 
                    }
                } else if (formType == FMS_IMC_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSIMCFormViewPage?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSIMCFormViewPage?id='+formObj.id); 
                    }
                } else if (formType == FMS_RIT_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSRITFormViewPage?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSRITFormViewPage?id='+formObj.id); 
                    }
                } else if (formType == FMS_DDR_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSDDRFormViewPage?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id); 
                    }
                } else if (formType == FMS_SP_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        
                        pg = new PageReference('/GlobalfoundryView/apex/FMSStepPlanFormView?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSStepPlanFormView?id='+formObj.id); 
                    }
                } 
            }
            pg.setRedirect(true);
            return pg;    
        } else { 
            if(formType == FMS_MAIN_FORM_SHRT) {
                Account acc;        
                if(formObj.Customer_Name__c != null){             
                    acc = [SELECT id, Name FROM Account WHERE id = :formObj.Customer_Name__c];      
                    formObj.Customer__c = acc.Name;
                } 
                if(!contactInfo.isEmpty() && (targCustomerPortUser != null && targCustomerPortUser != '')){  
                    formObj.Customer__c = targCustomerPortUser;
                    formObj.Customer_Name__c = extUserAccountId;    
                }  
                
                if(isDMEA && selDMEAAccount!=null){
                    if(!dmeaList.isEmpty()){
                        for(Account a1 : dmeaList){
                            if(a1.id == Id.valueOf(selDMEAAccount)){
                                formObj.Customer__c = a1.Name;
                            }
                        }
                    }                       
                    formObj.Customer_Name__c = Id.valueOf(selDMEAAccount);
                    
                    
                }
                
            } else {
                formObj.Customer__c = mainRecord.Customer__c;
                formObj.Customer_Name__c = mainRecord.Customer_Name__c;
                if(String.isEmpty(mainRecord.Main_Form_Id__c)){
                    formObj.Main_Form_Id__c = parentId;
                } else {
                    formObj.Main_Form_Id__c = mainRecord.Main_Form_Id__c;
                }
                formObj.Parent_Form_Id__c = parentId;
            }      
            formObj.State_of_the_Form__c = 'Draft';
            formObj.eventTypeName__c = 'StateChange';
            formObj.Creator_Email__c = loggedInUser.Email;
            if(formType == FMS_MAIN_FORM_SHRT){         
                formObj.recordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_MAIN_FORM).getRecordTypeId();
                formObj.Device__c = deviceId;
            } else if(selAddendum == FMS_IMC_FORM_SHRT) {
                valAddendum = validationCheckForAddendum(parentId);//Added by Abhita for Legacy form - 05092017
                formObj.recordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_IMC_FORM).getRecordTypeId();
                if(!valAddendum) {//Added by Abhita for Legacy form - 05092017
                    if(deviceId==null){
                        
                       retrofitDeviceCreate = createRetrofitDevice(basedeviceId); 
                       
                       formObj.Device__c = retrofitDeviceCreate.id;
                    }
                    else{
                        formObj.Device__c = deviceId;
                    }
                }//End---Added by Abhita for Legacy form - 05092017
            } else if (selAddendum == FMS_RIT_FORM_SHRT) {
                valAddendum = validationCheckForAddendum(parentId);//Added by Abhita for Legacy form - 05092017
                formObj.recordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_RIT_FORM).getRecordTypeId();
            } else if (selAddendum == FMS_DDR_FORM_SHRT) {
                valAddendum = validationCheckForAddendum(parentId);//Added by Abhita for Legacy form - 05092017
                formObj.recordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_DDR_FORM).getRecordTypeId(); 
            }                  
            
            formObj.Opportunity__c = opportunityId;
            formObj.Opportunity_Program__c = opportunityProgramId; 

            if(!valAddendum) {//Added by Abhita for Legacy form - 05092017
                try{
                    insert formObj;
                    
                    if((formObj.recordTypeId == Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId())|| (formObj.recordTypeId == Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_IMC_FORM).getRecordTypeId()))
                    {
                      if(formObj.device__c!=null){
                                    
                                    Form_Management_System__c fms = [SELECT ID,NAME,device__c FROM Form_Management_System__c WHERE ID =:formObj.ID];
                                    if(fms.name!=null){
                                        Device__c deviceRec = new Device__c(id=fms.device__c, FMS_ID__c = fms.Name);                           
                                    }
                      }
                    }
                    
                } catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'continueCheck()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }            
            } else {//Added by Abhita for Legacy form - 05092017
                return null;
            }//End
            
            if(formType == FMS_MAIN_FORM_SHRT){
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSmainFormCreationPg1?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSmainFormCreationPg1?id='+formObj.id); 
                }
            } else if (selAddendum == FMS_IMC_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSIMCFormPage?id='+formObj.id+'&tranx=New');
                } else {
                    pg = new PageReference('/apex/FMSIMCFormPage?id='+formObj.id+'&tranx=New'); 
                }
            } else if (selAddendum == FMS_RIT_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSRITFormNewEditPage1?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSRITFormNewEditPage1?id='+formObj.id); 
                }
            } else if (selAddendum == FMS_DDR_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSDDRFormPage?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSDDRFormPage?id='+formObj.id); 
                }
            }
            pg.setRedirect(true);
            return pg;
        }
        return null;
    }    

    public device__c createRetrofitDevice(Id parDeviceId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Device__c.FieldSets.FMS_DeviceFields.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id  FROM Device__c WHERE Id =:parDeviceId';
        
        Device__c  retrofitDevice = UtilityCls.createRetrofitDevice(Database.query(query),null);   
        try{
            Id accoutnid = retrofitDevice.Account__c;
            retrofitDevice.FMS_ID__c = 'FMS';
            
            insert retrofitDevice;
            
            if(retrofitDevice.id != null){
                Device__c retroupdate = new Device__c(Id = retrofitDevice.id , account__c = accoutnid);
                update retroupdate;                
            }
            // Added by Anirban for EC Junction creation on 17072017 - Start
            Device_Export_Control_Junction__c decj = UtilityCls.createExportControlJunction(retrofitDevice.Base_Device__c, retrofitDevice.Id);
            if(decj!=null){
                insert decj;
            }
            // Added by Anirban for EC Junction creation on 17072017 - End
            return retrofitDevice;
        }
        catch(Exception E){
            UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'createRetrofitDevice(Id parDeviceId)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in Retroift device creation:' + e.getMessage()));
        }     
        return null;
    }
    
    public PageReference cancelRecord(){
        PageReference pg;
        boolean val = false;
        if(formObj.id != null) {        
            if(formType == FMS_MAIN_FORM_SHRT){
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSmainFormViewPage?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSmainFormViewPage?id='+formObj.id); 
                }
            } else if (formType == FMS_IMC_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSIMCFormViewPage?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSIMCFormViewPage?id='+formObj.id); 
                }
            } else if (formType == FMS_RIT_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSRITFormViewPage?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSRITFormViewPage?id='+formObj.id); 
                }
            } else if (formType == FMS_DDR_FORM_SHRT) {
                if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FMSDDRFormViewPage?id='+formObj.id);
                } else {
                    pg = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id); 
                }
            }       
            else if (formType == FMS_SP_FORM_SHRT) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSStepPlanFormView?id='+formObj.id);
                    } else {
                        pg = new PageReference('/apex/FMSStepPlanFormView?id='+formObj.id); 
                    }                           
                }             
            pg.setRedirect(true);
            return pg;   
        } else{           
            if(parentId != null) {                
                Form_Management_System__c fmsParentRec = [Select id,recordtype.Name FROM Form_Management_System__c where id= :parentId];
                
                if(fmsParentRec.recordtype.Name == FMS_MAIN_FORM){
                    if(pageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSmainFormViewPage?id='+parentId);
                    } else {
                        pg = new PageReference('/apex/FMSmainFormViewPage?id='+parentId);
                    }
                }  else if(fmsParentRec.recordtype.Name == FMS_IMC_FORM){
                    if(pageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSIMCFormViewPage?id='+parentId);
                    } else {
                        pg = new PageReference('/apex/FMSIMCFormViewPage?id='+parentId);
                    }
                } else if (fmsParentRec.recordtype.Name == FMS_RIT_FORM) {
                    if(pageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSRITFormViewPage?id='+parentId);
                    } else {
                        pg = new PageReference('/apex/FMSRITFormViewPage?id='+parentId);
                    }
                } else if (fmsParentRec.recordtype.Name == FMS_DDR_FORM) {
                    if(pageURL.containsIgnoreCase('GlobalfoundryView')){
                        pg = new PageReference('/GlobalfoundryView/apex/FMSDDRFormViewPage?id='+parentId);
                    } else {
                        pg = new PageReference('/apex/FMSDDRFormViewPage?id='+parentId);
                    }
                } 
            } else {
                if(pageURL.containsIgnoreCase('GlobalfoundryView')){
                    pg = new PageReference('/GlobalfoundryView/apex/FormManagementMainPage');
                } else {
                    pg = new PageReference('/apex/FormManagementMainPage');
                }
            }
            pg.setRedirect(true);
            return pg;
        }
        return null;
    } 

    public List<SelectOption> getaddendumList(){
        List<SelectOption> tempList = new List<SelectOption>();
        /*Form_Management_System__c fmsObj;
        //17-7-2017 Modified query against ExportControl IMC issue...#IM
        fmsObj = [select Id, Device__c, Device__r.Export_Control_Status__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Form_Type__c, Customer_Name__r.Contract_Customer__c from Form_Management_System__c where Id =:parentId];
        */
        tempList.add(new SelectOption('', '=== Select form type ==='));
        if(formType == 'Other') {
            tempList.add(new SelectOption(FMS_IMC_FORM_SHRT, FMS_IMC_FORM));
            if(isRITAllowed){
                tempList.add(new SelectOption(FMS_RIT_FORM_SHRT, FMS_RIT_FORM));
            }
        }
        if(formType == FMS_RIT_FORM_SHRT) {
            tempList.add(new SelectOption(FMS_DDR_FORM_SHRT, FMS_DDR_FORM));
        }
        if(formType == FMS_IMC_FORM_SHRT) {
            tempList.add(new SelectOption(FMS_IMC_FORM_SHRT, FMS_IMC_FORM));
            tempList.add(new SelectOption(FMS_RIT_FORM_SHRT, FMS_RIT_FORM));
        }
        return tempList;
    } 
    
    //Added by Abhita for Legacy form - 05092017
    public Boolean validationCheckForAddendum(String parentId){
        List<String> errorMsgs = new List<String>();
        List<FMSValidations__c> listIMCValidations = new List<FMSValidations__c>();
        List<FMSValidations__c> listRITValidations = new List<FMSValidations__c>();
        List<FMSValidations__c> listDDRValidations = new List<FMSValidations__c>();
        
        Boolean valAddendum = false;
        Sobject fmsSobject = mainRecord;
        List<FMSValidations__c> mcs = FMSValidations__c.getall().values();
        
        for(FMSValidations__c fmsVal : mcs){
            if(fmsVal.Type_of_Form__c.contains(FMS_IMC_FORM_SHRT)) {
                listIMCValidations.add(fmsVal);
            }   
            if(fmsVal.Type_of_Form__c.contains(FMS_RIT_FORM_SHRT)) {
                listRITValidations.add(fmsVal);
            }
            if(fmsVal.Type_of_Form__c.contains(FMS_DDR_FORM_SHRT)){
                listDDRValidations.add(fmsVal);
            }
        }
      
        String formId = String.valueOf(mainRecord.Name);
        if(mainRecord != null && (formId.startsWith('1') || isRunTest)) {
            if(formType == 'Other') {
                if(selAddendum == FMS_IMC_FORM_SHRT) {              
                    for(FMSValidations__c val : listIMCValidations){
                        if(val.Name == 'DataCheckingOptions__c'){
                            renderDataCheckingOpts(mainRecord.Technology__c);
                            if(dispDataCheckingOpts && ((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null)){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else {
                            if((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        }
                    }
                } else if (selAddendum == FMS_RIT_FORM_SHRT) {
                    for(FMSValidations__c val : listRITValidations){
                        if((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null){
                            errorMsgs.add(val.LabelValue__c);
                        }
                    }  
                } 
            } else if(formType == FMS_IMC_FORM_SHRT) {
                parentServiceOpts=UtilityCls.getParentDesignServiceData(mainRecord);
                if(selAddendum == FMS_IMC_FORM_SHRT) { 
                    for(FMSValidations__c val : listIMCValidations){                      
                        if(val.Name == 'ProductName__c' || val.Name == 'ProductRevision__c'){
                            if((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'DataCheckingOptions__c'){
                            renderIMCDataCheckingOpts(mainRecord);
                            if (dispIMCDatacheckingOpts && (parentServiceOpts.DataCheckingOptions__c == '' || parentServiceOpts.DataCheckingOptions__c == null)) {
                                errorMsgs.add(val.LabelValue__c);                               
                            }
                        } else if(val.Name == 'Deliverable__c'){
                            if(mainRecord.OverrideParentOptions__c == 'Yes' && (parentServiceOpts.Deliverable__c == '' || parentServiceOpts.Deliverable__c == null)){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'ServiceOptions__c'){
                            if(mainRecord.OverrideParentOptions__c == 'Yes' && (parentServiceOpts.ServiceOptions__c == '' || parentServiceOpts.ServiceOptions__c == null)){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'DesignSubmission__c'){
                            if(mainRecord.OverrideParentOptions__c == 'Yes' && (parentServiceOpts.DesignSubmission__c == '' || parentServiceOpts.DesignSubmission__c == null)){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'Technology__c') {
                            if(mainRecord.Main_Form_Id__r.Technology__c == '' || mainRecord.Main_Form_Id__r.Technology__c == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'ReleaseProcessFlow__c'){
                            if(mainRecord.Main_Form_Id__r.ReleaseProcessFlow__c == '' || mainRecord.Main_Form_Id__r.ReleaseProcessFlow__c == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        }
                    }
                } else if (selAddendum == FMS_RIT_FORM_SHRT) {
                    for(FMSValidations__c val : listRITValidations){
                        if(val.Name == 'ProductName__c' || val.Name == 'ProductRevision__c'){
                            if((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'Technology__c') {
                            if(mainRecord.Main_Form_Id__r.Technology__c == '' || mainRecord.Main_Form_Id__r.Technology__c == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'ReleaseProcessFlow__c'){
                            if(mainRecord.Main_Form_Id__r.ReleaseProcessFlow__c == '' || mainRecord.Main_Form_Id__r.ReleaseProcessFlow__c == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'DesignSubmission__c'){
                            if(mainRecord.OverrideParentOptions__c == 'Yes' && (parentServiceOpts.DesignSubmission__c == '' || parentServiceOpts.DesignSubmission__c == null)){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        } else if(val.Name == 'ItarData__c'){
                            if(mainRecord.Main_Form_Id__r.ItarData__c == '' || mainRecord.Main_Form_Id__r.ItarData__c == null){
                                errorMsgs.add(val.LabelValue__c);
                            }
                        }
                    }
                }
            }
            if(selAddendum == FMS_DDR_FORM_SHRT){
                for(FMSValidations__c val : listDDRValidations){
                    if((String) fmsSobject.get(val.Name) == '' || (String) fmsSobject.get(val.Name) == null){
                        errorMsgs.add(val.LabelValue__c);
                    }
                }  
            }
            if(errorMsgs != null && !errorMsgs.isEmpty()){
                for(String str : errorMsgs){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, str));
                }
                valAddendum = true; 
            }
        }
        return valAddendum;
    }

    public void renderDataCheckingOpts(String technology){
        if(technology == UtilityCls.X32SOI || technology == UtilityCls.CNV8SFi || technology == UtilityCls.CMOS_9RFe || technology == UtilityCls.CMOS_9SF || technology == UtilityCls.CMOS_10LP || technology == UtilityCls.CMOS_10LPe || technology == UtilityCls.CMOS_10RFe || technology == UtilityCls.CMOS_10SF || technology == UtilityCls.SOI12S0 || technology == UtilityCls.BiMOS_P6 || technology == UtilityCls.BMSP6C9){
            dispDataCheckingOpts = false;
        }else{
            dispDataCheckingOpts = true;
        }
    }
    
    public void renderIMCDataCheckingOpts(Form_Management_System__c IMCFormObj){
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
            IMCFormObj.Main_Form_Id__r.Technology__c == 'CM7FRAM' || IMCFormObj.Main_Form_Id__r.Technology__c == 'BiCMOS 7PA (SiGe 7PA)') 
            && IMCFormObj.OverrideParentOptions__c == 'No' && parentServiceOpts.DataCheckingOptions__c == 'Full' && 
            ((IMCFormObj.Main_Form_Id__r.TestServices__c == 'No' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c  == 'No') || 
            (IMCFormObj.Main_Form_Id__r.TestServices__c == 'Yes' && IMCFormObj.Main_Form_Id__r.Packaging_Services__c  == 'No' && 
            (parentServiceOpts.StepPlanCustomRequirement1__c == 'Yes'))) && 
            (parentServiceOpts.DataCheckingOptions__c != null && parentServiceOpts.DataCheckingOptions__c != ''))){        
            dispIMCDatacheckingOpts = true;
        }else{
            dispIMCDatacheckingOpts = false;
        }        
    }   
    
    //End ---- Added by Abhita for Legacy form - 05092017
    
    private ContentVersion cloneContentVerRec (Id contentVerId) {
        ContentVersion contVersionRec = [SELECT Id, ContentSize, Title, VersionData, VersionNumber, PathOnClient, FileExtension, FileType, Description FROM ContentVersion where Id = :contentVerId];
        ContentVersion contVerRecClone = contVersionRec.clone(false,true,false,true);
        try {
            insert contVerRecClone;
        } catch(Exception E){
            UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'cloneContentVerRec', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }       
        return contVerRecClone;
    }
    
    private Id getcontentDocId(Id contentVerCopyId) {
        ContentVersion contVersionRec = [SELECT Id, ContentDocumentId FROM ContentVersion where Id = :contentVerCopyId];
        return contVersionRec.ContentDocumentId;
    }
    
    @future
    private static void linkContentDoc(Id copyformId, Id conDocId){
        ContentDocumentLink ct = new ContentDocumentLink(LinkedEntityId = copyformId, ContentDocumentId = conDocId, ShareType = 'V', Visibility = 'AllUsers');
        try {
            insert ct;
        } catch(Exception E){
            UtilityCls.saveExceptionLog(FMSChildCreationController.class.getName(), 'linkContentDoc', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        
    }
}