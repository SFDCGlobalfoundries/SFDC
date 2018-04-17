/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormVF.
    History: 
        ZAmbat      07292014    - Code creation.
        Vijay       11262014    - updated the validateDevice method, added the Device Complete check(means all minimal set of required attributes populated on Device)
                                  in this method. If Device Complete check is not true, system won't allow you to expose the device to customer. 
        Sunil       05102015    - catch block added by Sunil Arora for case # 47415.
        Sunil       06282016    - IF Condition added by Sunil Arora for case # 56466
        Devendra    07202017    - condition added to stop emails for Fab9/10
*/    

public class DeviceExposeToCustomer {
    
    public boolean showSelectAccounts {get;set;}
    public boolean showSelectUsers {get;set;}
    public boolean showErrorMessage {get;set;}
    public boolean selectAllAccounts {get;set;}
    public boolean selectAllDPAccounts {get;set;}
    public boolean exportControlAllowSelect {get;set;}
    public boolean ipDeclarationAllowSelect {get;set;}
    public boolean hasRecords {get;set;}
    public Device__c device {get;set;}
    public Map<string, WrapperListUser> mapAccountUsers {get;set;}
    public List<WrapperAccount> listAccounts {get;set;}
    public List<WrapperAccount> listDPAccounts {get;set;}
    public List<WrapperAccount> listSelectedAccounts {get;set;}
    public List<WrapperAccount> listSelectedDPAccounts {get;set;}
    public Set<string> exportControlUserIds {get;set;}
    public Set<string> ipDeclarationUserIds {get;set;}
    public ExposeDeviceToCustomer.ReturnMessage returnMessage {get;set;}
    
    public DeviceExposeToCustomer() {
        this.device = new Device__c();
        this.device = [
            SELECT      Id
                        , Account__c
            , Design_Partner__c
                        , Account__r.ParentId
            , Design_Partner__r.ParentId
                        , Expose_Device_to_Customer__c
                        , Process_Technology_2__c
                        , Tapeout_Type__c
						,Tapeout_Process__c
                        , Device_Type__c
                        , Stage__c
                        , Export_Control_User_Ids__c
                        , IP_Declaration_User_Ids__c
                        , Opportunity_Program__c
                        , Name
                        , CRMDID__c
                        , Export_Control_Status__c
                        , Export_Control_Form_Submitted_Date__c
                        , IP_Declaration_Status__c
                        , IP_Declaration_Submitted_Date__c
                        , BX041_Status__c
                        , BX041_Submission_Date__c
                 //       , Export_Control_Count__c
                        , Export_Control_Junction__c
                        , IP_Declaration_Form_Count__c
                        , Device_Complete__c
                        , Fab__c,Reticle_Type__c,Current_Forecast_Tapeout_Date__c
                        , Confidence_Level_Tapeout__c
                        , Semiconductor_Device__c
                        , Enabled_via_previous_MPW_1__c
                        , MPW_Train_Number__c
                        , Original_Forecasted_Tapeout_Date__c, Export_Control_Template__c
            FROM        Device__c
            WHERE       Id = :ApexPages.currentPage().getParameters().get('deviceId')
        ];
        
        this.hasRecords = false;
        //if (this.device.Export_Control_Count__c > 0 || this.device.IP_Declaration_Form_Count__c > 0) {
        if (this.device.Export_Control_Junction__c =='1' || this.device.IP_Declaration_Form_Count__c > 0) {
            this.hasRecords = true;
        }
        
        this.exportControlUserIds = new Set<string>();
        if (this.device.Export_Control_User_Ids__c != null) {
            this.exportControlUserIds.addAll(this.device.Export_Control_User_Ids__c.split(';'));
        }
        
        this.ipDeclarationUserIds = new Set<string>();
        if (this.device.IP_Declaration_User_Ids__c != null) {
            this.ipDeclarationUserIds.addAll(this.device.IP_Declaration_User_Ids__c.split(';'));
        }
        
        this.exportControlAllowSelect = false;
        if (!this.device.Expose_Device_to_Customer__c) {
            this.exportControlAllowSelect = true;
        } else {
            if (this.device.Export_Control_Status__c == 'Undeclared'
                || this.device.Export_Control_Status__c == 'Recalled'
                || this.device.Export_Control_Status__c == 'Pending Resubmission'
                || this.device.Export_Control_Status__c == 'Draft') {
                this.exportControlAllowSelect = true;   
            }
        }
        
        this.ipDeclarationAllowSelect = false;
        if (!this.device.Expose_Device_to_Customer__c) {
            this.ipDeclarationAllowSelect = true;
        } else {
            if (this.device.IP_Declaration_Status__c == 'Undeclared'
                || this.device.IP_Declaration_Status__c == 'Recalled'
                || this.device.IP_Declaration_Status__c == 'Pending Resubmission'
                || this.device.IP_Declaration_Status__c == 'Draft') {
                this.ipDeclarationAllowSelect = true;   
            }
        }
        
        // Get all Accounts based on Account Hierarchy
        // Validate Device
        if (validateDevice()) {
            this.showErrorMessage = false;
            this.showSelectAccounts = true;
            this.showSelectUsers = false;
            this.selectAllAccounts = false;
        this.selectAllDPAccounts = false;
            
            retrieveAllAccounts();
        retrieveDesignPartnerAccs();
        } else {
            this.showErrorMessage = true;
            this.showSelectAccounts = false;
            this.showSelectUsers = false;
            this.selectAllAccounts = false;
        this.selectAllDPAccounts = false;
        }
    }
    
    public boolean validateDevice() {
        boolean isValid = true;
        
        //IF Condition added by Sunil Arora for case # 56466
        Date tapeoutDate = Date.newInstance(2015, 8, 31);
        if (this.device.Reticle_Type__c == null && this.device.Current_Forecast_Tapeout_Date__c!=null && this.device.Current_Forecast_Tapeout_Date__c>tapeoutDate){ 
            // Reticle_Type__c should not be blank
            isValid = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_EXPOSE_RETICLE_TYPE_BLANK').Message__c));
        }
        //  code change for case # 56466 ends here  
        
        if (this.device.Process_Technology_2__c == null){ 
            // Process Technology should not be blank
            isValid = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_EXPOSE_PROCESS_TECH_BLANK').Message__c));
        } 
        
        
        if(!this.device.Device_Complete__c) {
            isValid = false;
            String errorMsg = '';
            if (Error_Codes__c.getInstance('DEVICE_COMPLETION')!= null){
                errorMsg =  Error_Codes__c.getInstance('DEVICE_COMPLETION').Message__c;
                errorMsg = (!String.isBlank(errorMsg)) ? errorMsg : 'Required fields are missing on Device.';
            }else{
                errorMsg = 'Required fields are missing on Device.';
            }
            
            String mandatoryFields = ' [';
            mandatoryFields += (String.isBlank(this.device.FAB__c)) ? Schema.sObjectType.Device__c.fields.FAB__c.getLabel() + ', ':'';
            
            mandatoryFields += (String.isBlank(this.device.Confidence_Level_Tapeout__c)) ? Schema.sObjectType.Device__c.fields.Confidence_Level_Tapeout__c.getLabel() + ', ' :'';
            
            mandatoryFields += (String.isBlank(this.device.Semiconductor_Device__c)) ? Schema.sObjectType.Device__c.fields.Semiconductor_Device__c.getLabel() + ', ' :'';
            
            mandatoryFields += (this.device.Tapeout_Type__c == 'Single Product' && String.isBlank(this.device.Enabled_via_previous_MPW_1__c)) ? Schema.sObjectType.Device__c.fields.Enabled_via_previous_MPW_1__c.getLabel() + ', ' :'';
            
            mandatoryFields += (this.device.Tapeout_Type__c == 'GlobalShuttle MPW' &&  this.device.MPW_Train_Number__c == null) ? Schema.sObjectType.Device__c.fields.MPW_Train_Number__c.getLabel() + ', ' :'';
            
            mandatoryFields += (this.device.Original_Forecasted_Tapeout_Date__c == null) ? Schema.sObjectType.Device__c.fields.Original_Forecasted_Tapeout_Date__c.getLabel() + ', ':'';
            
            if(String.isNotBlank(mandatoryFields)){
                errorMsg  +=  mandatoryFields.substringBeforeLast(',') + ']';
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
        }
        if (this.device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c) {
            // Retrofit Devices cannot be exposed to customer
            isValid = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_EXPOSE_RETROFIT_REVISION').Message__c));
        }
        if(this.device.Account__c != null || this.device.Design_Partner__c !=null){
            // Check for Contact within the Account Hierarchy
            this.returnMessage = new ExposeDeviceToCustomer.ReturnMessage();
            List<Device__c> listDevices = new List<Device__c>();
            listDevices.add(this.device);
            Set<Id> accountIds = new Set<Id>();
            if(this.device.Account__c!=null){
                accountIds.add(this.device.Account__c);
            }
            if(this.device.Design_Partner__c!=null){
                accountIds.add(this.device.Design_Partner__c);
            }
            this.returnMessage = ExposeDeviceToCustomer.validate(listDevices, accountIds);
            
            if (this.returnMessage.errorMessage != null) {
                isValid = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, this.returnMessage.errorMessage));
            }
        }
        
        return isValid;
    }
    public void retrieveDesignPartnerAccs() {
        Set<Id> designPartaccIds = new Set<Id>();
        if(this.device.Design_Partner__r.ParentId != null){
            for (Account_Hierarchy__c acctHi : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :this.device.Design_Partner__c
                                                        AND Parent_Id__c != :this.device.Design_Partner__c]) { 
                designPartaccIds.add(acctHi.Parent_Id__c);
            }
            
        }  
        
        for (Account_Hierarchy__c acctHi : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :this.device.Design_Partner__c
                                                    AND Account_Id__c != :this.device.Design_Partner__c]) { 
            designPartaccIds.add(acctHi.Account_Id__c);
        }
        designPartaccIds.add(this.device.Design_Partner__c);
        
        this.listDPAccounts = new List<WrapperAccount>();
        for (Account a : [SELECT    Id
                                    , Name
                                    , Site_Department__c
                                    , Stage__c
                                    , Short_Name__c
                                    , ParentId
                                    , Parent.Name
                                    , Parent.Short_Name__c
                          FROM      Account
                          WHERE     Id IN :designPartaccIds
                          ORDER BY  Name ASC]) {
            WrapperAccount w = new WrapperAccount();
            w.Id = a.Id;
            w.Name = a.Name;
            w.SiteDepartment = a.Site_Department__c;
            w.Stage = a.Stage__c;
            w.ShortName = a.Short_Name__c;
            w.ParentId = a.ParentId;
            w.ParentName = a.Parent.Name;
            w.ParentShortName = a.Parent.Short_Name__c;
            w.isDPSelected = true;
            if (this.device.Design_Partner__c == a.Id) {
                w.isMainDPAccount = true;
            } else {
                w.isMainDPAccount = false;
            }
            
            this.listDPAccounts.add(w);
        }
    }  
    
    public void retrieveAllAccounts() {
        // Get Accounts in the Account Hierarchy
        Set<Id> accountIds = new Set<Id>();
        if (this.device.Account__r.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :this.device.Account__c
                                                        AND Parent_Id__c != :this.device.Account__c]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :this.device.Account__c
                                                    AND Account_Id__c != :this.device.Account__c]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(this.device.Account__c);
        
        this.listAccounts = new List<WrapperAccount>();
        for (Account a : [SELECT    Id
                                    , Name
                                    , Site_Department__c
                                    , Stage__c
                                    , Short_Name__c
                                    , ParentId
                                    , Parent.Name
                                    , Parent.Short_Name__c
                          FROM      Account
                          WHERE     Id IN :accountIds
                          ORDER BY  Name ASC]) {
            WrapperAccount w = new WrapperAccount();
            w.Id = a.Id;
            w.Name = a.Name;
            w.SiteDepartment = a.Site_Department__c;
            w.Stage = a.Stage__c;
            w.ShortName = a.Short_Name__c;
            w.ParentId = a.ParentId;
            w.ParentName = a.Parent.Name;
            w.ParentShortName = a.Parent.Short_Name__c;
            w.isSelected = false;
            if (this.device.Account__c == a.Id) {
                w.isMainAccount = true;
            } else {
                w.isMainAccount = false;
            }
            
            this.listAccounts.add(w);
        }
    }
    
    public void retrieveAllUsers() {
        // Get Selected Accounts
        Set<Id> selectedAccountIds = new Set<Id>();
        this.listSelectedAccounts = new List<WrapperAccount>();
    this.listSelectedDPAccounts = new List<WrapperAccount>();
        this.mapAccountUsers = new Map<string, WrapperListUser>();
        for (WrapperAccount a : this.listAccounts) {
            if (a.isSelected) {
                selectedAccountIds.add(a.Id);
                this.listSelectedAccounts.add(a);
                WrapperListUser wl = new WrapperListUser();
                wl.AccountId = a.Id;
                if (a.ShortName != null && a.ShortName.trim() != '') {
                    this.mapAccountUsers.put(a.Name + ' (' + a.ShortName + ')', wl);
                } else {
                    this.mapAccountUsers.put(a.Name, wl);
                }
            }
        }
    
    for (WrapperAccount a : this.listDPAccounts) {
            if (a.isDPSelected) {
                selectedAccountIds.add(a.Id);
                this.listSelectedDPAccounts.add(a);
                WrapperListUser wl = new WrapperListUser();
                wl.AccountId = a.Id;
                if (a.ShortName != null && a.ShortName.trim() != '') {
                    this.mapAccountUsers.put(a.Name + ' (' + a.ShortName + ')', wl);
                } else {
                    this.mapAccountUsers.put(a.Name, wl);
                }
            }
        }
        
        if (this.listSelectedAccounts.size() > 0) {
            // Get Users
            Set<Id> userIds = new Set<Id>();
            List<WrapperUser> listUsers = new List<WrapperUser>();
            for (User u : [SELECT       Id
                                        , Name
                                        , ContactId
                                        , Contact.Email
                                        , Contact.AccountId
                                        , Contact.Account.Name
                                        , Contact.Account.Short_Name__c
                           FROM         User
                           WHERE        Contact.AccountId IN :selectedAccountIds
                                        AND IsActive = true
                           ORDER BY     Contact.Account.Name ASC, Name ASC]) {
                WrapperUser w = new WrapperUser();
                w.Id = u.Id;
                w.AccountId = u.Contact.AccountId;
                w.ContactId = u.ContactId;
                if (u.Contact.Account.Short_Name__c != null && u.Contact.Account.Short_Name__c.trim() != '') {
                    w.AccountName = u.Contact.Account.Name + ' (' + u.Contact.Account.Short_Name__c + ')';
                } else {
                    w.AccountName = u.Contact.Account.Name;
                }
                w.Name = u.Name;
                w.Email = u.Contact.Email;
                
                listUsers.add(w);
                userIds.add(u.Id);
            }
            
            // Get User Access
            Map<Id, Portal_Tab_Access__c> mapAccessSetup = new Map<Id, Portal_Tab_Access__c>();
            for (Portal_Tab_Access__c p : [SELECT   My_Devices__c
                                                    , Export_Control__c
                                                    , IP_Declaration__c
                                                    , Change_request_report__c
                                                    , User__c
                                           FROM     Portal_Tab_Access__c
                                           WHERE    User__c IN :userIds]) {
                mapAccessSetup.put(p.User__c, p);
            }
            
            for (WrapperUser u : listUsers) {
                if (mapAccessSetup.containsKey(u.Id)) {
                    if (mapAccessSetup.get(u.Id).My_Devices__c && mapAccessSetup.get(u.Id).Export_Control__c) {
                        if (this.exportControlAllowSelect) {
                            u.HasExportControlFormAccess = true;
                        }
                        
                         if (((u.AccountId == this.device.Account__c || u.AccountId == this.device.Design_Partner__c) && !this.device.Expose_Device_to_Customer__c) || this.exportControlUserIds.contains(u.Id)) {
                             system.debug('_______=ENTERDesignPartner=_______'+this.device.Design_Partner__c);
                            u.ExportControlForm = true;
                        } else {
                            u.ExportControlForm = false;
                        }
                    }
                    
                    if (mapAccessSetup.get(u.Id).My_Devices__c && mapAccessSetup.get(u.Id).IP_Declaration__c) {
                        if (this.ipDeclarationAllowSelect) {
                            u.HasIpDeclarationFormAccess = true;
                        }
                        
                        if (((u.AccountId == this.device.Account__c || u.AccountId == this.device.Design_Partner__c) && !this.device.Expose_Device_to_Customer__c) || this.ipDeclarationUserIds.contains(u.Id)) {
                            u.IpDeclarationForm = true;
                        } else {
                            u.IpDeclarationForm = false;
                        }
                    }
                    
                    if (mapAccessSetup.get(u.Id).My_Devices__c && mapAccessSetup.get(u.Id).Change_request_report__c) {
                        u.HasCdrsAccess = true;
                        if ((u.AccountId == this.device.Account__c || u.AccountId == this.device.Design_Partner__c) && !this.device.Expose_Device_to_Customer__c) {
                            u.Cdrs = true;
                        } else {
                            u.Cdrs = false;
                        }
                    } 
                } else {
                    u.IpDeclarationForm = false;
                    u.HasIpDeclarationFormAccess = false;
                    u.ExportControlForm = false;
                    u.HasExportControlFormAccess = false;
                    u.Cdrs = false;
                }
                
                if (this.exportControlUserIds.contains(u.Id)) {
                    u.EcEMailAlreadySent = true;
                }
                
                if (this.ipDeclarationUserIds.contains(u.Id)) {
                    u.IpEMailAlreadySent = true;
                }
                
                // Map Users per Account
                WrapperListUser tempWLU = this.mapAccountUsers.get(u.AccountName);
                tempWLU.ListWrapperUsers.add(u);
                this.mapAccountUsers.put(u.AccountName, tempWLU);
            }
            
            // Set 'Select All' checkboxes
            for (string key : this.mapAccountUsers.keySet()) {
                if (this.mapAccountUsers.get(key).ListWrapperUsers.size() > 0) {
                    integer exportControlCtr = 0;
                    integer ipDeclarationCtr = 0;
                    integer cdrsCtr = 0;
                    integer exportControlTotal = 0;
                    integer ipDeclarationTotal = 0;
                    integer cdrsTotal = 0;
                    for (WrapperUser w : this.mapAccountUsers.get(key).ListWrapperUsers) {
                        if (w.HasExportControlFormAccess) {
                            if (!w.ExportControlForm) {
                                exportControlCtr++;
                            }
                            exportControlTotal++;
                        }
                        
                        if (w.HasIpDeclarationFormAccess) {
                            if (!w.IpDeclarationForm) {
                                ipDeclarationCtr++;
                            }
                            ipDeclarationTotal++;
                        }
                        
                        if (w.HasCdrsAccess) {
                            if (!w.Cdrs) {
                                cdrsCtr++;  
                            }
                            cdrsTotal++;
                        }
                    }
                    
                    if (exportControlTotal > 0) {
                        if (this.exportControlAllowSelect) {
                            this.mapAccountUsers.get(key).IsExportControlSelectAllDisabled = false;
                        }
                        
                        if (exportControlCtr == 0) {
                            this.mapAccountUsers.get(key).ExportControlSelectedAll = true;
                        }
                    }
                    
                    if (ipDeclarationTotal > 0) {
                        if (this.ipDeclarationAllowSelect) {
                            this.mapAccountUsers.get(key).IsIpDeclarationSelectAllDisabled = false; 
                        }
                        
                        if (ipDeclarationCtr == 0) {
                            this.mapAccountUsers.get(key).IpDeclarationSelectedAll = true;
                        }
                    }
                    
                    if (cdrsTotal > 0) {
                        this.mapAccountUsers.get(key).IsCdrsSelectAllDisabled = false;
                        if (cdrsCtr == 0) {
                            this.mapAccountUsers.get(key).CdrsSelectedAll = true;
                        }
                    }
                } 
            }
            
            this.showErrorMessage = false;
            this.showSelectAccounts = false;
            this.showSelectUsers = true;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_EXPOSE_NO_ACCOUNTS_SELECTED').Message__c));
            this.showErrorMessage = true;
        }
    }
    
    public PageReference exposeDevice() {
        PageReference pageRef;
        try {
            // Expose Device to customer
            if (!this.device.Expose_Device_to_Customer__c) {
                ExposeDeviceToCustomer.exposeCustomer(this.returnMessage.recordsMap, this.hasRecords);
            }
            
            Set<Id> ecContactIds = new Set<Id>();
            Set<Id> ipContactIds = new Set<Id>();
            Set<Id> cdContactIds = new Set<Id>();
            this.device.Export_Control_User_Ids__c = '';
            this.device.IP_Declaration_User_Ids__c = '';
            for (string key : this.mapAccountUsers.keySet()) { 
                for (WrapperUser u : this.mapAccountUsers.get(key).ListWrapperUsers) {
                    if (u.ExportControlForm) {
                        if (!this.exportControlUserIds.contains(u.Id)) {
                            ecContactIds.add(u.ContactId);
                        }
                        
                        if (this.device.Export_Control_User_Ids__c == '') {
                            this.device.Export_Control_User_Ids__c = u.Id;
                        } else {
                            this.device.Export_Control_User_Ids__c = this.device.Export_Control_User_Ids__c + ';' + u.Id;
                        }
                    }
                    if (u.IpDeclarationForm) {
                        if (!this.ipDeclarationUserIds.contains(u.Id) && !(this.device.Fab__c!=null && ((this.device.Fab__c.equalsignorecase('FAB 9')||this.device.Fab__c.equalsignorecase('FAB 10'))&& this.device.Tapeout_Process__c!='PTRF'))) {
                            ipContactIds.add(u.ContactId);
                        }
                        
                        if (this.device.IP_Declaration_User_Ids__c == '') {
                            this.device.IP_Declaration_User_Ids__c = u.Id;
                        } else {
                            this.device.IP_Declaration_User_Ids__c = this.device.IP_Declaration_User_Ids__c + ';' + u.Id;
                        }
                    }
                    if (u.Cdrs) {
                        cdContactIds.add(u.ContactId);
                    }
                }
                
            }
            
            // Send Export Control and IP Declaration emails
            if (!test.isRunningTest()) {
                system.debug(ecContactIds.size()+'_______=CONTACT=_______'+ecContactIds);
                ExposeDeviceToCustomer.sendEmail(this.returnMessage.recordsMap, ecContactIds, ipContactIds);
            }
            
            // Set Expose_Device_to_Customer__c field
            if (!this.device.Expose_Device_to_Customer__c) {
                this.device.Expose_Device_to_Customer__c = true;
            }
            update this.device;
            
            // Back to Device detail page
            pageRef = new PageReference('/' + this.device.Id);
        } 
        //catch block added by Sunil Arora for case # 47415
        catch(System.EmailException emlEx) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Please select less than 99 recipients. '+emlEx)); 
            this.showErrorMessage = true;
        }catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            this.showErrorMessage = true;
        }
        
        return pageRef;
    }
    
    public PageReference backToAccountsSelection() {
        PageReference pageRef;
        try {
            // Expose Device to customer
            if (!this.device.Expose_Device_to_Customer__c) {
                ExposeDeviceToCustomer.exposeCustomer(this.returnMessage.recordsMap, this.hasRecords);
            }
            
            Set<Id> ecContactIds = new Set<Id>();
            Set<Id> ipContactIds = new Set<Id>();
            Set<Id> cdContactIds = new Set<Id>();
            this.device.Export_Control_User_Ids__c = '';
            this.device.IP_Declaration_User_Ids__c = '';
            for (string key : this.mapAccountUsers.keySet()) { 
                for (WrapperUser u : this.mapAccountUsers.get(key).ListWrapperUsers) {
                    if (u.ExportControlForm) {
                        if (!this.exportControlUserIds.contains(u.Id)) {
                            ecContactIds.add(u.ContactId);
                        }
                        
                        if (this.device.Export_Control_User_Ids__c == '') {
                            this.device.Export_Control_User_Ids__c = u.Id;
                        } else {
                            this.device.Export_Control_User_Ids__c = this.device.Export_Control_User_Ids__c + ';' + u.Id;
                        }
                    }
                    if (u.IpDeclarationForm) {
                        if (!this.ipDeclarationUserIds.contains(u.Id) && !(this.device.Fab__c!=null && ((this.device.Fab__c.equalsignorecase('FAB 9')||this.device.Fab__c.equalsignorecase('FAB 10'))&& this.device.Tapeout_Process__c!='PTRF'))) {
                            ipContactIds.add(u.ContactId);
                        }
                        
                        if (this.device.IP_Declaration_User_Ids__c == '') {
                            this.device.IP_Declaration_User_Ids__c = u.Id;
                        } else {
                            this.device.IP_Declaration_User_Ids__c = this.device.IP_Declaration_User_Ids__c + ';' + u.Id;
                        }
                    }
                    if (u.Cdrs) {
                        cdContactIds.add(u.ContactId);
                    }
                }
                
            }
            
            // Send Export Control and IP Declaration emails
            if (!test.isRunningTest()) {
                ExposeDeviceToCustomer.sendEmail(this.returnMessage.recordsMap, ecContactIds, ipContactIds);
            }
            
            // Set Expose_Device_to_Customer__c field
            if (!this.device.Expose_Device_to_Customer__c) {
                this.device.Expose_Device_to_Customer__c = true;
            }
            update this.device;
            
            // Back to Device detail page
            pageRef = new PageReference('/apex/DeviceExposeToCustomerVF?deviceId=' + this.device.Id);
            this.showSelectAccounts = true;
            this.showSelectUsers = false;
            pageRef.setRedirect(true);
            return pageRef;
        } 
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            this.showErrorMessage = true;
        }
        
        return null;
    }
    
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + this.device.Id);
        
        return pageRef;
    }
    
    public class WrapperListUser {
        public string AccountId {get;set;}
        public List<WrapperUser> ListWrapperUsers {get;set;}
        public boolean ExportControlSelectedAll {get;set;}
        public boolean IpDeclarationSelectedAll {get;set;}
        public boolean CdrsSelectedAll {get;set;}
        public boolean IsExportControlSelectAllDisabled {get;set;}
        public boolean IsIpDeclarationSelectAllDisabled {get;set;}
        public boolean IsCdrsSelectAllDisabled {get;set;}
        public integer getListSize() {
            return ListWrapperUsers.size();
        }
        
        public WrapperListUser() {
            this.ListWrapperUsers = new List<WrapperUser>();
            this.ExportControlSelectedAll = false;
            this.IpDeclarationSelectedAll = false;
            this.CdrsSelectedAll = false;
            this.IsExportControlSelectAllDisabled = true;
            this.IsIpDeclarationSelectAllDisabled = true;
            this.IsCdrsSelectAllDisabled = true;
        }
    }
    
    public class WrapperAccount {
        public string Id {get;set;}
        public string Name {get;set;}
        public string SiteDepartment {get;set;}
        public string Stage {get;set;}
        public string ShortName {get;set;}
        public string ParentId {get;set;}
        public string ParentName {get;set;}
        public string ParentShortName {get;set;}
        public boolean isSelected {get;set;}
    public boolean isDPSelected {get;set;}
        public boolean isMainAccount {get;set;}
    public boolean isMainDPAccount {get;set;}
        
        public WrapperAccount() {
            this.isSelected = false;
        this.isDPSelected = true;
            this.isMainAccount = false;
        this.isMainDPAccount = false;
        }
    }
    
    public class WrapperUser {
        public string Id {get;set;}
        public string AccountId {get;set;}
        public string AccountName {get;set;}
        public string ContactId {get;set;}
        public string Name {get;set;}
        public string Email {get;set;}
        public boolean IpDeclarationForm {get;set;}
        public boolean HasIpDeclarationFormAccess {get;set;}
        public boolean ExportControlForm {get;set;}
        public boolean HasExportControlFormAccess {get;set;}
        public boolean Cdrs {get;set;}
        public boolean HasCdrsAccess {get;set;}
        public boolean EcEMailAlreadySent {get;set;}
        public boolean IpEmailAlreadySent {get;set;}
        
        public WrapperUser() {
            this.IpDeclarationForm = false;
            this.HasIpDeclarationFormAccess = false;
            this.ExportControlForm = false;
            this.HasExportControlFormAccess = false;
            this.Cdrs = false;
            this.HasCdrsAccess = false;
            this.EcEMailAlreadySent = false;
            this.IpEmailAlreadySent = false;
        }
    }
}