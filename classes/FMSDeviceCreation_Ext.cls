/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the logic for Creating device and retrofit devies and navigations for FMS.
 * @ Date :- 05/12/2016
 * @ Change History :-  
 *  DATE                NAME            Comment
    5-Dec-2016          Inshu Misra     added code for exception handling framework...#IM
    28-Jun-2017         Anirban Roy     Removed the System debugs and Hard coding.
    18-July-2017        Inshu Misra     Changes made for device validation error message issue
    1-Aug-2017          Abhita Bansal   Modified the code to associate the correct device on creation
    1-Aug-2017          Anirban Roy     Added code for generation of Export Control Form and code optimization.
    ....13-12-2017..........Devendra........Fixed duplicate device issue in same account heirarchy
    16-Jan-2018         Poulami Saha    Added code for Skywork Qorvo Template automation
	1-FEB-2018         Devendra -Tapeout process changes
**/
public class FMSDeviceCreation_Ext {
    public Device__c deviceObj {get;set;}
    public Boolean viewPage {get;set;}
    public Boolean editPage {get;set;}
    Public Id deviceId;
    public Boolean retrofit;
    public Boolean fmsFlag {get;set;}
    public Boolean hideRetrofitBtn {get;set;}
    public Boolean isRetrofit{get; set;}
    public string baseDevice{get;set;}
    public string selopportunity{get;set;}
    public boolean validationErrorflag;
    public Id opportunityProgramId {get;set;}
    public Map<String,String> devFieldname {get;set;}
    public Id baseId ;
    public String trans;
    public String ValueReturned {get; set;}
    public Boolean isButtonsAccessable {get;set;}
    public Boolean isExposeDeviceFlag {get;set;}
    public String baseDeviceName;
    public boolean displayPopup {get; set;}
    Id accountId;
    public Boolean isAccountsAvailable {get;set;} 
    public String accountName {get;set;}
    public String accId;
    // Modified the code to associate the correct device on creation - 01082017
    public final String FMS_DEV_LITE_SOLD_TO = EnvironmentVariable.get('FMS_DEV_LITE_SOLD_TO');
    public final String FMS_DEV_LITE_ERROR_MSG = EnvironmentVariable.get('FMS_DEV_LITE_Error_Msg');
    public final String FMS_DEV_LITE_DUPNAME_ERROR_MSG = EnvironmentVariable.get('FMS_DEV_LITE_DUPNAME_ERROR_MSG');
    
    public Boolean isMemberofECTempGroup {get;set;}

    public FMSDeviceCreation_Ext(ApexPages.StandardController sc) {
        viewPage = false;
        editPage = false;
        fmsFlag = false;
        hideRetrofitBtn = false;
        isRetrofit =false;
        validationErrorflag = false;
        this.ValueReturned = 'SUCCESS';
        isButtonsAccessable = false;
        isAccountsAvailable = false;
        isExposeDeviceFlag=false;
        displayPopup = false;
        
        deviceObj = (Device__c) sc.getRecord();
        deviceId = ApexPages.currentPage().getParameters().get('id');
        trans = ApexPages.currentPage().getParameters().get('tnx');
        opportunityProgramId = ApexPages.currentPage().getParameters().get('oppProgId');
        baseId = ApexPages.currentPage().getParameters().get('baseId');
        retrofit = false;
        User userObj = [SELECT Id ,Contact.Account.Contract_Customer__c,Contact.AccountId, Contact.Account.SAP_Account_Number__c, Contact.Account.Name FROM User WHERE Id =:userInfo.getUserId()];
        accountName = userObj.Contact.Account.Name;
        accId=userObj.Contact.AccountId;
        // Modified the code to associate the correct device on creation - 01082017
         if(userObj.Contact.Account.Contract_Customer__c && UserInfo.getUserType() != 'Standard'){
            isButtonsAccessable = true;
             isExposeDeviceFlag = true;
        }
        else if(UserInfo.getUserType() == 'Standard'){
            isExposeDeviceFlag = true;
        }
        
        if (trans == 'edit') {
            editPage = true;
        }
        
        isMemberofECTempGroup = false;
        Set<String> groupNames = new Set<String>();
        for (GroupMember gm : [select 
                                 group.name,
                                 group.DeveloperName 
                              from GroupMember 
                              where UserOrGroupId = :UserInfo.getUserId()]) {
           groupNames.add(gm.group.DeveloperName);
        }
        if(!groupNames.isEmpty()){
            if (groupNames.contains('EC_Temp_Access_Group')) {
                isMemberofECTempGroup = true;
            }else{
                isMemberofECTempGroup = false;
            }
        }

        
        // Modified the code to associate the correct device on creation - 01082017
        /*-----Start the code By Abhita----Modified the code to associate the correct device on creation - 01082017-*/
        List<Account_Hierarchy__c> accHie = [SELECT Account_Id__c, Account_Id__r.SAP_Account_Number__c, Master_Account_Id__c FROM Account_Hierarchy__c where Account_Id__c = :userObj.Contact.AccountId];
        if(userObj.Contact.AccountId != null) {
            //System.debug('*****accHie 1*****' +accHie);
            //System.debug('***** userObj.Contact.Account.SAP_Account_Number__c *****' +userObj.Contact.Account.SAP_Account_Number__c);
            //System.debug('***** FMS_DEV_LITE_SOLD_TO *****' +FMS_DEV_LITE_SOLD_TO.contains(userObj.Contact.Account.SAP_Account_Number__c));
            if((accHie.isEmpty() || (accHie!=null && accHie.size()>0 && accHie[0].Account_Id__c == accHie[0].Master_Account_Id__c)) && userObj.Contact.Account.SAP_Account_Number__c!=null && FMS_DEV_LITE_SOLD_TO.contains(userObj.Contact.Account.SAP_Account_Number__c)) {    
                System.debug('*****accHie 2*****' +accHie);
                deviceObj.account__c = userObj.Contact.AccountId;
                isAccountsAvailable = true;
                System.debug('*****isAccountsAvailable 0*****' +isAccountsAvailable);
            } else if(accHie!=null && accHie.size()>0 && (accHie[0].Account_Id__c != accHie[0].Master_Account_Id__c || (accHie[0].Account_Id__c == accHie[0].Master_Account_Id__c && (userObj.Contact.Account.SAP_Account_Number__c==null || !FMS_DEV_LITE_SOLD_TO.contains(userObj.Contact.Account.SAP_Account_Number__c))))){
                System.debug('*****accHie 3*****' +accHie);
                List<Account_Hierarchy__c> lstAccHie = new List<Account_Hierarchy__c>();
                for(Account_Hierarchy__c accH : [Select Account_Id__c, Account_Id__r.SAP_Account_Number__c, Master_Account_Id__c, Parent_Id__c, Account_Id__r.Name from Account_Hierarchy__c where Parent_Id__c =: accHie[0].Master_Account_Id__c]){
                    if(accH.Account_Id__r.SAP_Account_Number__c != null && accH.Account_Id__r.SAP_Account_Number__c != '' && FMS_DEV_LITE_SOLD_TO.contains(accH.Account_Id__r.SAP_Account_Number__c)) {
                        deviceObj.account__c = accH.Account_Id__c;
                        isAccountsAvailable = true;
                        break; 
                    }
                }
                System.debug('*****isAccountsAvailable 1 *****' +isAccountsAvailable);
                if(!isAccountsAvailable){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, FMS_DEV_LITE_ERROR_MSG));
                }
            } else{
                System.debug('*****isAccountsAvailable 2 *****' +isAccountsAvailable);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, FMS_DEV_LITE_ERROR_MSG));
            }
        } else {
            System.debug('*****isAccountsAvailable 3 *****' +isAccountsAvailable);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, FMS_DEV_LITE_ERROR_MSG));
        }
        /*-----End the code By Abhita-----*/
        if(trans == 'copy' || trans == 'createRetor'){
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Device__c.FieldSets.FMS_DeviceFields.getFields()) {
                query += f.getFieldPath() + ', ';
            }
            query += ' Id  FROM Device__c WHERE Id =:baseId';
            
            Device__c baseDeviceCopy= Database.query(query); 
            if(deviceObj.Device_Type__c != 'Retrofit' && trans != 'createRetor'){
                deviceObj = baseDeviceCopy.clone(false, true);
            }
            if(deviceObj.Device_Type__c == 'Retrofit' || trans == 'createRetor'){
                
                baseDeviceName = baseDeviceCopy.Name;
                id baseDeviceId = baseDeviceCopy.Base_Device__c;
                deviceObj = UtilityCls.createRetrofitDevice(baseDeviceCopy,String.valueOf(baseDeviceCopy.name)); 
                if(trans == 'copy'){
                    deviceObj.Base_Device__c = baseDeviceId;
                }
            } 
            deviceObj.FMS_ID__c = 'FMS';
        }
        else{
            if (deviceId != null) {
                viewPage = true;
                List < Form_Management_System__c > deviceIdList = [Select id from Form_Management_System__c where Device__c = : deviceId];
                
                fmsFlag = (deviceIdList.size() > 0 ? false : true);
                 
                Device__c deviceName = [Select id, Opportunity_Program__r.name,Account__r.name,Opportunity2__r.name, Base_Device__r.name,Device_Type__c,(select id,Device_Type__c from Devices__r where Device_Type__c = 'Retrofit') from Device__c where id =: deviceId];
                
                if(deviceName!=null){
                    baseDevice = deviceName.Base_Device__r.name;
                    devFieldname = new Map<String,String>();
                    devFieldname.put('Opportunity_Program__c', deviceName.Opportunity_Program__r.name);   
                    devFieldname.put('Account__c', deviceName.Account__r.name);   
                    devFieldname.put('Opportunity2__c', deviceName.Opportunity2__r.name );
                    if(deviceName.Device_Type__c == 'Retrofit'){
                        hideRetrofitBtn = true;
                        isRetrofit = true;
                    }
                    else{
                        isRetrofit = false;
                        hideRetrofitBtn = (((deviceName.Devices__r).size()>0)?true:false);
                    }
                    
                }
            }
            else{
                if(deviceObj.Tapeout_Type__c==null||deviceObj.Tapeout_Type__c ==''){
                    deviceObj.Tapeout_Type__c = 'Single Product';   
                }
                //Starting code for review comments by Abhita
                if(deviceObj.Reticle_Type__c==null||deviceObj.Reticle_Type__c ==''){
                    deviceObj.Reticle_Type__c = 'Single Layer Reticle (SLR)';   
                }
                if(deviceObj.Automotive_Device__c==null||deviceObj.Automotive_Device__c ==''){
                    deviceObj.Automotive_Device__c = 'No';   
                }
                //Ending code for review comments by Abhita
                deviceObj.FMS_ID__c = 'FMS';
                
            }
        }
    }
    
    //16-01-2018    Poulami Saha    Added code for opening popup on selecting on Export Control Template value - START
    public PageReference openPopUp() {
        if(deviceObj.Export_Control_Template__c != null && deviceObj.Export_Control_Template__c != ''){
            
            if(deviceId == null && !editPage){          
                validationErrorflag = checkValidation();
                if(!validationErrorflag){
                    displayPopup = true;
                }
            }else if(deviceId != null && editPage){
                Device__c dev = [SELECT id, Export_Control_Template__c from Device__c where id = :deviceId];
                if(dev.Export_Control_Template__c != deviceObj.Export_Control_Template__c){
                    validationErrorflag = checkValidation();
                    if(!validationErrorflag){
                        displayPopup = true;
                    }
                }else{
                    PageReference pageRef = save();
                    return pageRef;
                }
            }
            return null;
        }else{
            PageReference pageRef = save();
            return pageRef;
        }
    }
    //16-01-2018    Poulami Saha    Added code for opening popup on selecting on Export Control Template value - END
    
    //16-01-2018    Poulami Saha    Added code for closing popup - START
    public void closePopup() {
        displayPopup = false;
    }
    //16-01-2018    Poulami Saha    Added code for closing popup - END
    
    public boolean checkValidation(){
        Boolean valErrorflag = false;
        //User userObj = [SELECT Id ,Contact.Account.Contract_Customer__c,Contact.AccountId, Contact.Account.SAP_Account_Number__c FROM User WHERE Id =:userInfo.getUserId()];
        //string accId=userObj.Contact.AccountId;
        if(accId!=null && deviceObj.id == null){
            set<id> accIdsSet=getAccountIds(accId);
            List<Device__c> devChkList=[select id,name from device__c where Account__c IN :accIdsSet and name=:deviceObj.name];
            if(!devChkList.isempty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, FMS_DEV_LITE_DUPNAME_ERROR_MSG));
                valErrorflag = true;
            }
        }
        if(deviceObj.Customer_Tapeout_Date__c!= null && deviceObj.Customer_Tapeout_Date__c < System.today()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer Expected Tapeout Date Should be Today or greater'));
            valErrorflag = true;
        }

        if(trans == 'createRetor' && deviceObj.name ==baseDeviceName ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Device ID should not be same as Base Device ID,Please change'));
            valErrorflag = true;
        }      
        
        if(deviceObj.Automotive_Device__c== 'Yes' && (deviceObj.Automotive_Grade__c==null || deviceObj.Automotive_Grade__c=='')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Automotive Grade value'));
            valErrorflag = true; 
        }
        if(deviceObj.account__c !=null){
            Account acc = [Select Fab_9_10__c from Account where id =:deviceObj.account__c];
             if(acc.Fab_9_10__c != 'Yes'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account Fab9/10 field should be \'Yes\''));
                valErrorflag = true;  
             } 
        }
        List<Device_Export_Control_Junction__c> devExpJun = [select id, Export_Control_Form__c, Export_Control_Form__r.Status__c, Device__c from Device_Export_Control_Junction__c where Device__c = :deviceObj.id];
        if(deviceId != null){
            Device__c dev = [SELECT id, Export_Control_Template__c from Device__c where id = :deviceId];
            if(dev.Export_Control_Template__c != deviceObj.Export_Control_Template__c){
                if(!devExpJun.isEmpty() && devExpJun[0].Export_Control_Form__c != null){
                    if(devExpJun[0].Export_Control_Form__r.Status__c == 'Submitted' || devExpJun[0].Export_Control_Form__r.Status__c == 'Approved'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Cannot change Export Control Template value once EC form is in \'Submitted\' or \'Approved\''));
                        valErrorflag = true;
                    }
                }
            
            }
        }
        
        return valErrorflag;
    }

    public PageReference save() {
        displayPopup = false;
        validationErrorflag = checkValidation();
        if(!((trans == 'copy' && deviceObj.Device_Type__c == 'Retrofit' )||(trans == 'createRetor'))){

            if (!editPage) {
                deviceObj.Device_Type__c = (deviceObj.Base_Device__c == null ? 'Base' : 'Retrofit');
                deviceObj.RecordTypeId = Schema.SObjectType.Device__c.getRecordTypeInfosByName().get('Device').getRecordTypeId();
                deviceObj.Fab__c = 'FAB 9';
                deviceObj.Tapeout_Process__c = 'FMS 2.0';
                deviceObj.Confidence_Level_Tapeout__c = '100';
                deviceObj.Stage__c = 'Design In';
                deviceObj.Status__c = 'Active';
                deviceObj.Enabled_via_previous_MPW_1__c = 'No';
                deviceObj.CRMDID__c = '';
                deviceObj.Automotive_Device__c = 'No';
                deviceObj.Secure_Device__c = 'No';
                deviceObj.Generate_Standard_Frame__c = 'No';

                List<Account> acc = [select name from Account where id=:deviceObj.Account__c];
                String oppName = (acc!=null && acc.size()>0)?acc[0].Name+' OPP DUMMY':'';
                List<Opportunity_Program__c> oppProgList = [Select id, Opportunity__c,Account__c, Opportunity__r.Business_Unit__c,Opportunity__r.Product_Line__c from Opportunity_Program__c Where Account__c = :deviceObj.Account__c and Opportunity__r.name =:oppName];
                Opportunity_Program__c oppProg;
                if(oppProgList!=null && oppProgList.size()>0){
                    oppProg = oppProgList[0];
                }
                deviceObj.Opportunity_Program__c = oppProg.id;
                deviceObj.Opportunity2__c = oppProg.Opportunity__c;
                deviceObj.Product_Line__c =  oppProg.Opportunity__r.Product_Line__c;
                deviceObj.Business_Unit__c = oppProg.Opportunity__r.Business_Unit__c;
            }
        }
        if(!validationErrorflag){
            Boolean sendEmail = false;
            accountId = deviceObj.Account__c;
            if(deviceObj.Original_Forecasted_Tapeout_Date__c==null)deviceObj.Original_Forecasted_Tapeout_Date__c = deviceObj.Customer_Tapeout_Date__c;
            if(deviceObj.Current_Forecast_Tapeout_Date__c==null)deviceObj.Current_Forecast_Tapeout_Date__c = deviceObj.Customer_Tapeout_Date__c;        
            
            //16-01-2018    Poulami Saha    Added code for populating device fields based on Export Control Template value - START
            if(deviceObj.Export_Control_Template__c != null && deviceObj.Export_Control_Template__c != ''){
                List<EC_Template_for_Skyworks_Qorvo__c> skyquoECTemplateList = new List<EC_Template_for_Skyworks_Qorvo__c>();
                skyquoECTemplateList = [SELECT id, name, Semiconductor_Device__c,Export_Control_Template__c,Market_Segment__c,End_Application__c,Device_Description__c,Design_Rules_Applied__c,Automotive_Device__c,Product_Line__c,Business_Unit__c  from EC_Template_for_Skyworks_Qorvo__c WHERE Account__c = :deviceObj.account__c and Export_Control_Template__c = :deviceObj.Export_Control_Template__c and IsActive__c = 'Yes'];
                if(!skyquoECTemplateList.isEmpty()){
                    deviceObj.Semiconductor_Device__c = skyquoECTemplateList[0].Semiconductor_Device__c;
                    deviceObj.Market_Segment__c = skyquoECTemplateList[0].Market_Segment__c;
                    deviceObj.End_Application__c = skyquoECTemplateList[0].End_Application__c;
                    deviceObj.Device_Description__c = skyquoECTemplateList[0].Device_Description__c;
                    deviceObj.Design_Rules_Applied__c = skyquoECTemplateList[0].Design_Rules_Applied__c;
                    deviceObj.Automotive_Device__c = skyquoECTemplateList[0].Automotive_Device__c;
                    deviceObj.Product_Line__c = skyquoECTemplateList[0].Product_Line__c;
                    deviceObj.Business_Unit__c = skyquoECTemplateList[0].Business_Unit__c;
                }
            }
            //16-01-2018    Poulami Saha    Added code for populating device fields based on Export Control Template value - END
            
            try {
                if(deviceId == null){
                    sendEmail = true;
                    
                }
                /*Device__c dev = new Device__c();
                if (deviceId != null) {
                    dev = [SELECT id, Export_Control_Template__c from Device__c where id = :deviceId];
                }*/
              
                upsert deviceObj Id;
                if(deviceObj.Export_Control_Template__c != null && deviceObj.Export_Control_Template__c != ''){
                    createExpControl();
                }
                if(sendEmail){
                    deviceObj.Account__c = accountId;
                    deviceSharingToExtUser(deviceObj);
                    if(deviceObj.Export_Control_Template__c == null || deviceObj.Export_Control_Template__c == ''){
                        Device__c devUpdate = new Device__c(id=deviceObj.id,Account__c = accountId);
                        update devUpdate ;
                    }
                    FMSEmailTemplates.sendNotificationOnDeviceCreation(String.valueOf(deviceObj.Id));
                    
                }
            }   
            catch (Exception e) {
                if (e.getMessage().indexOf('DUPLICATE_VALUE') > -1) {
                    Error_Codes__c ec = Error_Codes__c.getInstance('DEVICE_ID_ALREADY_EXIST');
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Device ID Already Exists, Please re-enter Device ID'));
                    
                } 
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error :' + e.getMessage()));  
                }
                UtilityCls.saveExceptionLog(FMSDeviceCreation_Ext.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                return null;
            }    
        }
        else{
            return null;
        }
        //18-7-2017  Changes made for device validation error message issue...#IM
        PageReference ref = Page.FMSDeviceCreationPage;
        ref.getParameters().put('id',deviceObj.id);
        ref.setRedirect(true);
        return ref;
    }
    public PageReference changeECTemp() {
        System.debug('*****Onchange1 *****');
        if(deviceObj.Export_Control_Template__c != null && deviceObj.Export_Control_Template__c != ''){
            System.debug('*****Onchange2 *****');
                List<EC_Template_for_Skyworks_Qorvo__c> skyquoECTemplateList = new List<EC_Template_for_Skyworks_Qorvo__c>();
                skyquoECTemplateList = [SELECT id, name, Semiconductor_Device__c,Export_Control_Template__c,Market_Segment__c,End_Application__c,Device_Description__c,Design_Rules_Applied__c,Automotive_Device__c,Product_Line__c,Business_Unit__c  from EC_Template_for_Skyworks_Qorvo__c WHERE Account__c = :deviceObj.account__c and Export_Control_Template__c = :deviceObj.Export_Control_Template__c and IsActive__c = 'Yes'];
                if(!skyquoECTemplateList.isEmpty()){
                    System.debug('*****Onchange3 *****');
                    deviceObj.Semiconductor_Device__c = skyquoECTemplateList[0].Semiconductor_Device__c;
                    deviceObj.Market_Segment__c = skyquoECTemplateList[0].Market_Segment__c;
                    deviceObj.End_Application__c = skyquoECTemplateList[0].End_Application__c;
                    deviceObj.Device_Description__c = skyquoECTemplateList[0].Device_Description__c;
                    deviceObj.Design_Rules_Applied__c = skyquoECTemplateList[0].Design_Rules_Applied__c;
                    deviceObj.Automotive_Device__c = skyquoECTemplateList[0].Automotive_Device__c;
                    deviceObj.Product_Line__c = skyquoECTemplateList[0].Product_Line__c;
                    deviceObj.Business_Unit__c = skyquoECTemplateList[0].Business_Unit__c;
                }
        }
        return null;
    }
    public PageReference newFMSMainForm() {
        Id parentId;
        String parentName;
        Device__c deviceObject = [select id, Account__c, Base_Device__c, Opportunity__c,Opportunity2__c, Opportunity_Program__c from Device__c where id = : deviceObj.Id];
        if (deviceObject.Base_Device__c != null) {
            List < Form_Management_System__c > fmsMainRec = [Select id, Name , Form_Name__c, Main_Form_Id__c,State_of_the_Form__c from Form_Management_System__c where Device__c = : deviceObject.Base_Device__c];
            if (!fmsMainRec.isEmpty()) {
                if(fmsMainRec[0].State_of_the_Form__c!='Draft'){
                     parentId = fmsMainRec[0].id;
                     parentName = fmsMainRec[0].Name;
                    PageReference ref = new PageReference('/GlobalfoundryView/apex/FMSmainFormCreation?tranx=Create&Type=IMC&DeviceId=' + deviceObject.Id + '&AccountId=' + deviceObject.Account__c + '&OppId=' + deviceObject.Opportunity2__c + '&OppProgramId=' + deviceObject.Opportunity_Program__c + '&ParentId=' + parentId + '&parentName=' + parentName);
                    ref.setRedirect(true);
                    return ref; 
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You cant create IMC form because Main form <a href="/GlobalfoundryView/apex/FMSMainformviewPage?id='+fmsMainRec[0].id +'" target="_blank" style="font-size: larger;font-weight: bold;">'+fmsMainRec[0].Form_Name__c +'</a>  state is Draft, Please change state on main form, so that you can create IMC form from here'));
                    return null;   
                }
            } 
            else {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create a FMS Main form for Base Device '));
                return null;
            }
        }
        PageReference ref = new PageReference('/GlobalfoundryView/apex/FMSmainFormCreation?tranx=Create&Type=Main&DeviceId=' + deviceObject.Id + '&AccountId=' + deviceObject.Account__c + '&OppId=' + deviceObject.Opportunity2__c + '&OppProgramId=' + deviceObject.Opportunity_Program__c);
        ref.setRedirect(true);
        return ref;
    }
    
    public void deviceSharingToExtUser(Device__c devObj){
        // 01-08-2017    Anirban Roy    Query optimization - START
        Set<Id> accountIds = getAccountIds(devObj.Account__c);        
        // 01-08-2017    Anirban Roy    Query optimization - END

        Set<Id> userIds = new Set<Id>();
        if(accountIds.size()>0){
            for (User u : [SELECT    Id                                
                           FROM      User
                           WHERE     Contact.AccountId IN :accountIds
                           AND       IsActive = true
                           AND       isPortalEnabled = true]){
                userIds.add(u.Id);            
            }
                   
            if(userIds.size()>0){
                List<Device__Share> shareDevices = new List<Device__Share>();
                for (Portal_Tab_Access__c p : [SELECT   My_Devices__c                                               
                                                        , User__c
                                               FROM     Portal_Tab_Access__c
                                               WHERE    User__c IN :userIds
                                               AND      My_Devices__c = true]) {
                    Device__Share rec = new Device__Share();
                    rec.AccessLevel = 'Edit';
                    rec.ParentId = devObj.Id;
                    rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                    rec.UserOrGroupId = p.User__c;
                    shareDevices.add(rec);
                }
                if(shareDevices.size()>0){
                    insert shareDevices;         
                }                
                
            }            
        
        }
        
    } 
    //Starting code for review comments by Abhita
    public List<SelectOption> getdevicePurposeList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult fieldResult = Device__c.Device_Purpose__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();           
        for(Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Customer Test Chip' || f.getValue() == 'Product'){                
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    //Ending code for review comments by Abhita
    
    //16-01-2018    Poulami Saha    Added code for populating Export Control Template values - START
    public List<SelectOption> getecTemplateList(){
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('','--None--'));
        List<EC_Template_for_Skyworks_Qorvo__c> skyquoECTemplateList = new List<EC_Template_for_Skyworks_Qorvo__c>();
        skyquoECTemplateList = [SELECT id, name, Export_Control_Template__c from EC_Template_for_Skyworks_Qorvo__c WHERE Account__c = :deviceObj.account__c and IsActive__c = 'Yes'];
        system.debug('*****deviceObj.account__c*****' +deviceObj.account__c);
        system.debug('*****skyquoECTemplateList*****' +skyquoECTemplateList);
        if(!skyquoECTemplateList.isEmpty()){
            for(EC_Template_for_Skyworks_Qorvo__c ecTemp : skyquoECTemplateList){
                options.add(new SelectOption(ecTemp.Export_Control_Template__c, ecTemp.Export_Control_Template__c));
            }
        }
        return options;
    }
    //16-01-2018    Poulami Saha    Added code for populating Export Control Template values - END
    
    //16-01-2018    Poulami Saha    Added code for creating Export Control Form - START
    public void createExpControl(){
        try{
            List<Device_Export_Control_Junction__c> devExpJun = [select id, Export_Control_Form__c, Device__c from Device_Export_Control_Junction__c where Device__c = :deviceObj.id];
            //if(devExpJun.isEmpty()){
                Map<String,List<ExposeDeviceToCustomer.RecordDetail>> records = new Map<String,List<ExposeDeviceToCustomer.RecordDetail>>();        
                List<Contact> conList = new List<Contact>();
                Set<Id> accountIds = getAccountIds(deviceObj.Account__c);
                
                for(Contact con : [SELECT email,role__c, (select id from Access_Setup__r where Tapeout_Fab_9_10__c =true and My_Devices__c = true limit 1)  
                                   FROM Contact
                                   WHERE is_portal_user_active__c = true
                                   AND is_portal_user_created__c = true 
                                   AND  AccountID in :accountIds]){
                    if(con.Access_Setup__r != null && con.Access_Setup__r.size()>0){
                        conList.add(con);
                    }           
                }
                List<Device__c> devList = [select id,fab__c,opportunity_program__c,account__c,Account_Short_Name__c,Export_Control_Template__c from Device__c where id=:deviceObj.id ];
                ExposeDeviceToCustomer.RecordDetail expRec = new ExposeDeviceToCustomer.RecordDetail(devList[0],devList[0].Account_Short_Name__c);        
                if(conList.size()>0){
                    expRec.addContacts(conList);
                }
                records.put(deviceObj.Account__c,new List<ExposeDeviceToCustomer.RecordDetail>{expRec});
                ExposeDeviceToCustomer.exposeCustomer(records,false);
                User usr = [Select ContactId From User Where Id = :UserInfo.getUserId()];
                ExposeDeviceToCustomer.sendEmail(records, new Set<Id>{usr.ContactId}, new Set<Id>());
    
                devExpJun = [select id, Export_Control_Form__c, Device__c from Device_Export_Control_Junction__c where Device__c = :deviceObj.id];
            //}
            /*if(!devExpJun.isEmpty() && devExpJun[0].Export_Control_Form__c != null){
                PageReference pg = new PageReference('/apex/ExportControlEdit?deviceid='+devExpJun[0].Device__c);
                pg.setRedirect(true);
                return pg;
            }*/
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_Ext.class.getName(), 'generateExpControl()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        //return null;
    }
    //16-01-2018    Poulami Saha    Added code for creating Export Control Form - END
    
    //01-08-2017    Anirban Roy    Added code for generation of Export Control Form - START
    public PageReference generateExpControl(){
        try{
            List<Device_Export_Control_Junction__c> devExpJun = [select id, Export_Control_Form__c, Device__c from Device_Export_Control_Junction__c where Device__c = :deviceObj.id];
            if(devExpJun.isEmpty()){
                Map<String,List<ExposeDeviceToCustomer.RecordDetail>> records = new Map<String,List<ExposeDeviceToCustomer.RecordDetail>>();        
                List<Contact> conList = new List<Contact>();
                Set<Id> accountIds = getAccountIds(deviceObj.Account__c);
                
                for(Contact con : [SELECT email,role__c, (select id from Access_Setup__r where Tapeout_Fab_9_10__c =true and My_Devices__c = true limit 1)  
                                   FROM Contact
                                   WHERE is_portal_user_active__c = true
                                   AND is_portal_user_created__c = true 
                                   AND  AccountID in :accountIds]){
                    if(con.Access_Setup__r != null && con.Access_Setup__r.size()>0){
                        conList.add(con);
                    }           
                }
                List<Device__c> devList = [select id,fab__c,opportunity_program__c,account__c,Account_Short_Name__c,Export_Control_Template__c from Device__c where id=:deviceObj.id ];
                ExposeDeviceToCustomer.RecordDetail expRec = new ExposeDeviceToCustomer.RecordDetail(devList[0],devList[0].Account_Short_Name__c);        
                if(conList.size()>0){
                    expRec.addContacts(conList);
                }
                records.put(deviceObj.Account__c,new List<ExposeDeviceToCustomer.RecordDetail>{expRec});
                ExposeDeviceToCustomer.exposeCustomer(records,false);
                User usr = [Select ContactId From User Where Id = :UserInfo.getUserId()];
                ExposeDeviceToCustomer.sendEmail(records, new Set<Id>{usr.ContactId}, new Set<Id>());
    
                devExpJun = [select id, Export_Control_Form__c, Device__c from Device_Export_Control_Junction__c where Device__c = :deviceObj.id];
            }
            if(!devExpJun.isEmpty() && devExpJun[0].Export_Control_Form__c != null){
                PageReference pg = new PageReference('/apex/ExportControlEdit?deviceid='+devExpJun[0].Device__c);
                pg.setRedirect(true);
                return pg;
            }
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_Ext.class.getName(), 'generateExpControl()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        return null;
    }
    //01-08-2017    Anirban Roy    Added code for generation of Export Control Form - END
    
    //01-08-2017    Anirban Roy    Get the account hierarchy account ids
    public static Set<Id> getAccountIds(Id accId){
        Set<Id> accIds = new Set<Id>();
        for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c,
                                                    Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       (Account_Id__c = :accId
                                                    AND Parent_Id__c != :accId) 
                                        OR          (Parent_Id__c = :accId
                                                    AND Account_Id__c != :accId)]) { 
            if(ah.Account_Id__c == accId && ah.Parent_Id__c != accId){
                accIds.add(ah.Parent_Id__c);
            }else if(ah.Parent_Id__c == accId && ah.Account_Id__c != accId){
                accIds.add(ah.Account_Id__c);
            }
        }
        accIds.add(accId);
        return accIds;    
    }
    //01-08-2017    Anirban Roy    Get the account hierarchy account ids
}