/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_ControllerSearchReticleGFForm
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    02/24/2014        Test class created.
        DBiswal        03082016          Modified according to code review.
**/

 
@isTest
private class ROS_ControllerSearchReticleGFForm_Test {
    
    //DBiswal 01082016
    @testSetup static void testdata() {
        EUC_Form__c eucformrec = new EUC_Form__c(End_User_Stmt_Sec_1__c='Test data1');
        insert eucformrec;
        
        Environment_Variable__c envvar1 = new Environment_Variable__c(Name = 'ROS_EUCForm_Table_Headers',Value__c = 'Product Description;Product Code;HS Code;Brand;Model;Quantity;Value;');
        Environment_Variable__c envvar2 = new Environment_Variable__c(Name = 'ROS_EUCForm_Fabs',Value__c = 'FAB 2;FAB 3;FAB 3E;FAB 5;FAB 6;FAB 7');
        List<Environment_Variable__c> lstenvvar = new List<Environment_Variable__c>{envvar1,envvar2};
        insert lstenvvar;
   Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
       bl.Name='Update Bill To Address No';
       bl.Bill_To_Address_Number__c = 2072;
       insert bl;
    }
    
    static void loadCustomSettings(){
        DataUtilTest.LoadFabEnvVariables();
        DataUtilTest.LoadATPEnvVariables();
        DataUtilTest.LoadDeviceEnvVariable();
        DataUtilTest.LoadFabReticleEnvVariables();
       // DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadOpptyEnvVariables();
        DataUtilTest.LoadOPTMEnvVariables();
        DataUtilTest.LoadReticleDeviceEnvVariables();
        DataUtilTest.LoadReticleDWEnvVariables();
        DataUtilTest.LoadReticleEnvVariables();
        list<Environment_Variable__c> evList = [select name, value__c from Environment_Variable__c where Name = 'HCM Account Id'];
        system.debug(logginglevel.error, evList);
        ROS_Witness_Arrival_Accounts__c roswa = new ROS_Witness_Arrival_Accounts__c(SetupOwnerId = UserInfo.getOrganizationId(),Account_Short_Name__c='TestAcct1N');
        insert roswa;
    }
    
    static ROS_Error_Messages__c assignErrorMessage(String name,String value){
        ROS_Error_Messages__c rosErr = new ROS_Error_Messages__c();
        rosErr.name = name;
        rosErr.value__c = value;
        return rosErr;
    }
    
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    static ROS_Column_Definition__c assignROSColumnDef(String name,String label){
        ROS_Column_Definition__c rosColDef = new ROS_Column_Definition__c();
        rosColDef.name = name;
        rosColDef.label__c = label;
        return rosColDef;
    }
    
    static void createROSQueryDataSettings() {
        List<SObject> lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType,'TestROSQueryUCData');
    }
        
    static user CraeteSolutionteam(){
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testSol';
        usr1.Email= 'testSolutionUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestSolutionUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testSolutionUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.FederationIdentifier = '111111';
        usr1.IsActive = true;
        insert(usr1);
        return usr1;        
    }
    
    static Id createShippingAddress(String AccountId){
        Shipping_Address__c shipAddress=new Shipping_Address__c(Account__c=AccountId,Address1__c='test',Address2__c='Test',Shipping_Country__c='Country',Shipping_State__c='State',zip_code__c='11111');
        insert shipAddress;
        return shipAddress.Id;
    }
    
    static Id createForwarderInfo(String AccountId){
        Forwarder_Information__c fwdInfo = new Forwarder_Information__c(Account__c=AccountId,Contact_Name__c='test',Contact_Phone_No__c='12345',Forwarder_Name__c='fwd name',Account_No__c='11111');
        insert fwdInfo;
        return fwdInfo.Id;
    }
    
    static id createFab(){
        FAB__c FB = new FAB__c(Name='FAB 3');
        insert FB;
        return FB.id;   
    }
    
    static User createFabUser(string FABId,String UserId){
            Fab_User__c FUser = new Fab_User__c(Fab__c =Fabid,user__c=userid,Is_ROS_User__c=true);
            insert FUser;
            User u=[Select Id,name from User where id=:Fuser.User__c];
            return u;
    }
    
    static Id createReticleDatawareHouse(Integer DayInactive,String RetcileId) {
      
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
        
        DW.Customer_ID__c= 'broadcom';
        DW.CustomerDevice_ID__c = '1313AA-U01';
        DW.FAB__c = 'FAB 3';
        DW.GlobalFoundries_DeviceID__c = '1313AA-U01';
        DW.InactiveDay__c = DayInactive;
        DW.Region_Name__c = 'US';
        DW.Reticle_Status__c = '';
        DW.Reticle_Type__c = 'BINARY';   
        DW.Name = RetcileId;
        insert DW;
        return DW.Id;
    }  
    static Id createReticleCycle() {        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H15',Cycle_Year__c='2015',Cycle_Month__c='August',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }
    
    static Id createReticleDevice(String RetcileId){
        Reticle_Device__c RD = new Reticle_Device__c(Reticle__c =RetcileId,CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011');
        insert RD;
        return RD.Id;
    }
    
    static Id createReticleFab(String RetcileId,String fabId){
        Fab_Reticle__c RD = new Fab_Reticle__c(Reticle__c =RetcileId,fab__C=fabId);
        insert RD;
        return RD.Id;
    }
    
    static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }
    
    static Reticle__c createReticle(String name, Id accountId, String rosCycle, Integer dayInactive, Id ownerId,
                                     Boolean solTeamConfirm, String reticleType, String region, String workflowStatus){
        return new Reticle__c(Name = name, Account__c  = accountId, ROS_Cycle__c = rosCycle, Day_Inactive__c = dayInactive,
                              OwnerId = Ownerid,  Solution_Team_Confirm__c   = solTeamConfirm,Reticle_Type__c = reticleType,
                              Region__c = region, Reticle_workflow_Status__c = workflowStatus);                            
    }
    
    static testMethod void methodForSearchActiveRetcile() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
       
            obj.toAddress = 'test@test.com';
            obj.ccAddress = 'test2@test.com';
            obj.bccAddress = 'test3@test.com';
            obj.emailBody = 'testBody';
            obj.emailSubject = 'testSubject';
            obj.selectedOptionNotify = 'With_Reticle';
            obj.getItemsforNotify();
            obj.closePopup();
            obj.showPopup();
            obj.emailBody = 'testBody';
            obj.emailSubject = 'testSubject';
            
            obj.displayNotifyWindow();
            System.assertEquals(true,obj.displayNotifyByEmail); 
            obj.ReticleSearch();
            for(ROS_ControllerSearchReticleGFForm.Reticlewrapper obj1 : obj.summaries){
                obj1.isselected = true;
            }
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle ,true)); 
            obj.summaries = obj.getSelectedRetwrapper();
            System.assert(obj.summaries.size()>0);
            PageReference clearSearch = obj.clearSearch();
            System.assertEquals('none',obj.Category);
            obj.Category = 'pCstfdbk';
            obj.ReticleSearch();
            
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle ,true)); 
            PageReference returnRetilce = obj.returnRetilce();                              
            obj.changeDispositiontype();
            System.assert(obj.lOptionDispositionType.size()>0);
            
            obj.ReticleSearch();
            obj.Category = 'Active Reticles';  
            obj.changeDispositiontype();
            obj.ReticleSearch();
            
            obj.Category = 'Inactive Reticles';  
            obj.ReticleId = '1313AA-05AZ';
            obj.ReticleSearch();
            
            obj.next();
            obj.previous();
            obj.Category  = 'Archived Reticles';
            
            obj.ReticleSearch();
            obj.end();
            obj.beginning();
            Integer P = obj.getPageNumber();
            System.assert(P != 0);
            Boolean getDisablePrevious= obj.getDisablePrevious();
            Boolean getDisableNext= obj.getDisableNext();
            integer TP = obj.getTotalPages();
            Integer RecordStart = obj.getDisplayRecordStart();
            Integer TotalRecord = obj.getTotalRecords();
            Integer DisplayRecordEnd= obj.getDisplayRecordEnd();
            Integer PageNumber = obj.getPageNumber();
            obj.changeDispositiontype();
        Test.stopTest();          
    }
    
    static testMethod void methodForDisposition_Keep(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        ROS_Error_Messages__c rosError = new ROS_Error_Messages__c(Name = 'Debit note Number',Value__c = 'Debit note Number');
        insert rosError;
        
        ROS_Error_Messages__c rosError2 = new ROS_Error_Messages__c(Name = 'Request Waive Off',Value__c = 'Request Waive Off');
        insert rosError2;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
        
            reticle.Reticle_Workflow_Status__c = 'Pending for Customer Feedback'; //Added on 8/8/14
            reticle.Invalid__c = false;
            update reticle;
            
            PageReference returnRetilce = obj.returnKeep();
            obj.changeDispositiontype();
            obj.Category  = 'pDebitNote';
            PageReference PRedirectNote =  obj.updateDebitReference();
            PageReference PRedirectNote1 = Page.ROSVF_debitnote;
            Test.setCurrentPageReference (PRedirectNote1 );
            PageReference  Te = obj.loadreticleForDebitNote();
            List<Reticle__c> Res =  obj.getupdateDebitReticle();
            System.assert(Res.size()>0);
            
            PageReference PdebitNoteWaiveOff = obj.debitNoteWaiveOff();
            PageReference P1 = obj.saveDebitNote();
            System.assertEquals(true,obj.IsDebitNoteSaved);
        Test.stopTest();
    }
    
    static testMethod void methodForExportCSV(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        List<ROS_Column_Definition__c> lstColDef = new List<ROS_Column_Definition__c>();
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Account__r.Name','Account'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Name','Reticle Id'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Reticle_Type__c','Reticle Type'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Shipping_Address__r.Name','Ship Add'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Forwarder_Information__r.Name','Fwd Add'));
        insert lstColDef;
        
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        
        Forwarder_Information__c fwdInfo = new Forwarder_Information__c(Forwarder_Name__c='testFw',Account_No__c='123',Contact_Name__c='test',Contact_Phone_No__c='999');
        insert fwdInfo;
        Shipping_Address__c shipInfo = new Shipping_Address__c(Address1__c='add1',Address2__c='add2',Shipping_State__c='state',Shipping_Country__c='cntry',zip_code__c='1111');
        insert shipInfo;
        
        reticle.Shipping_Address__c = shipInfo.Id;
        reticle.Forwarder_Information__c = fwdInfo.Id;
        
    Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
       
            obj.UserType = 'System Administrator';
            obj.reticleSearch();
            
            for(ROS_ControllerSearchReticleGFForm.Reticlewrapper obj1 : obj.summaries){
                obj1.isselected = true;
            }
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle,true)); 
            PageReference exportfile = obj.exportCsvFile();
            System.assert(exportfile != null);
        Test.stopTest();
    }
    
    static testMethod void methodForExportCsvFileNotify(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        List<ROS_Column_Definition__c> lstColDef = new List<ROS_Column_Definition__c>();
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Account__r.Name','Account'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Name','Reticle Id'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Reticle_Type__c','Reticle Type'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Shipping_Address__r.Name','Ship Add'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Forwarder_Information__r.Name','Fwd Add'));
        insert lstColDef;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        
        Forwarder_Information__c fwdInfo = new Forwarder_Information__c(Forwarder_Name__c='testFw',Account_No__c='123',Contact_Name__c='test',Contact_Phone_No__c='999');
        insert fwdInfo;
        Shipping_Address__c shipInfo = new Shipping_Address__c(Address1__c='add1',Address2__c='add2',Shipping_State__c='state',Shipping_Country__c='cntry',zip_code__c='1111');
        insert shipInfo;
        
        reticle.Shipping_Address__c = shipInfo.Id;
        reticle.Forwarder_Information__c = fwdInfo.Id;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
        
            obj.UserType = 'System Administrator';
            obj.reticleSearch();
            for(ROS_ControllerSearchReticleGFForm.Reticlewrapper obj1 : obj.summaries){
                obj1.isselected = true;
            }
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle,true)); 
            obj.showPopup();
            System.assert(obj.displayPopup == true);
            PageReference exportnotify = obj.exportCsvFileNotify();
            System.assert(exportnotify != null);
        Test.stopTest();
    }
        
    static testMethod void method_ShippingAddressInsert(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
                
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
       
            reticle.Reticle_Workflow_Status__c = 'Pending for Customer Feedback';
            reticle.Invalid__c = false;
            update reticle;            
            
            obj.ShipaddressAccountId();
            System.assertEquals(null,obj.shipaddressaccount);
            
            PageReference pgRefAdd = Page.ROSVF_shippingAddress;
            Test.setCurrentPageReference (pgRefAdd);
            ApexPages.currentPage().getParameters().put('AccountId', accountId);
            
            obj.ShippingAddress = 'test shipping address';

            String Id = createShippingAddress(accountId);
            obj.ForwarderAccountNumber = '1234';
            obj.ForwarderName= 'test';
            obj.selectedAddress1 = 'Other';
            obj.NewAddress = obj.getNewAddress();
            obj.NewAddress.Address1__c = 'Test';
            obj.NewAddress.Address2__c = 'Test';
            obj.NewAddress.Shipping_Country__c= 'US';
            obj.NewAddress.Shipping_State__c = 'Test';
            obj.NewAddress.zip_code__c = 'Test';
            obj.ShippingAddressSave();
            System.assertEquals(null,obj.selectedaddress1);
            
            obj.NewFwdInfo = obj.getNewFwdInfo();
            obj.NewFwdInfo.Contact_Name__c = 'Test';
            obj.NewFwdInfo.Contact_Phone_No__c= '12345';
            obj.NewFwdInfo.Forwarder_Name__c= 'Test';
            obj.NewFwdInfo.Account_No__c= '123456';
            obj.FwdInfoSave();  
            System.assertEquals(null,obj.selectedFwdInfo1);
            
            obj.selectedAddress1 = Id;
            obj.ShippingAddressInsert();
            
            for(SelectedReticleWrapper  eachreticlewrapper : obj.SelReturnReticles){
                eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Name__c = 'Test';
                eachreticlewrapper.eachSelectedreticlewrapper.Account_Number__c = '123456';
                eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c = shippingAddrId;
            }
            obj.ShippingAddressInsert();
            System.assertEquals(true,obj.IsReturnSubmitted);
        Test.stopTest();
    }
    
    static testMethod void methodForWebService(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
          Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
      
            PageReference pgRefGE = Page.ROS_GEForm;
            Test.setCurrentPageReference(pgRefGE);
            ROS_GEFormModel ObjGE = obj.getGEFormRequest();
            ObjGE.SetShipToCompany('Test');
            ObjGE.SetRequestNo('134');
            ObjGE.SetFab('FAB 3');
            ObjGE.SetRaiseDate('20/10/2014');
            obj.selectedReticles = obj.getselectedReticles();
            obj.selectedReticles.add(reticle);
            System.assert(obj.selectedReticles.size() > 0);
            test.SetMock(WebServiceMock.class, new WebServiceMockImpl());
            obj.formSearch();
        Test.stopTest();
    }
    
    
    static testMethod void methodForUtil(){
        List<User> userRecord = [select id from User where isActive = True limit 1];
        
        if(userRecord != NULL && !userRecord.isEmpty()){
            Set<String> str = ROS_Util.getUserReticles(userRecord[0].Id);
        }
    }
    
    static testMethod void methodForDisposition_NotifyCustomerCallDirect(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        List<ROS_Column_Definition__c> lstColDef = new List<ROS_Column_Definition__c>();
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Account__r.Name','Account'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Name','Reticle Id'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Reticle_Type__c','Reticle Type'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Shipping_Address__r.Name','Ship Add'));
        lstColDef.add(ROS_ControllerSearchReticleGFForm_Test.assignROSColumnDef('Forwarder_Information__r.Name','Fwd Add'));
        insert lstColDef;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        
        Forwarder_Information__c fwdInfo = new Forwarder_Information__c(Forwarder_Name__c='testFw',Account_No__c='123',Contact_Name__c='test',Contact_Phone_No__c='999');
        insert fwdInfo;
        Shipping_Address__c shipInfo = new Shipping_Address__c(Address1__c='add1',Address2__c='add2',Shipping_State__c='state',Shipping_Country__c='cntry',zip_code__c='1111');
        insert shipInfo;
        
        reticle.Shipping_Address__c = shipInfo.Id;
        reticle.Forwarder_Information__c = fwdInfo.Id;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
        
            obj.toAddress = 'test@test.com';
            obj.ccAddress = 'test2@test.com';
            obj.bccAddress = 'test3@test.com';
            obj.emailBody = 'testBody';
            obj.emailSubject = 'testSubject';
            obj.selectedOptionNotify = 'With_Reticle';
            obj.emailBody = 'testBody';
            obj.emailSubject = 'testSubject';
            obj.ReticleId  = '1313AA-05AZ1';
            obj.UserType = 'System Administrator';
            obj.Category = 'pNotifyCust';
            obj.notifyCustomer();
            System.assert(obj.displayPopup == false);
        Test.stopTest();
    } 
    
    
    static testMethod void method_RecalculateSharing(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        insert lstEnv;
                
        List<User> users = new List<User>();
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');               
        
        User u2 = new User(alias = 'ts2', email='testaccss2@test.com',
        emailencodingkey='UTF-8', lastname='TestLast2', firstname='TestFirst2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss23@test.com',communitynickname='tsss2',FederationIdentifier='Test3');      
        
        User u3 = new User(alias = 'ts3', email='testaccss3@test.com',
        emailencodingkey='UTF-8', lastname='TestLast3', firstname='TestFirst3', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss24@test.com',communitynickname='tsss3',FederationIdentifier='Test4');
        
        users.add(u1);
        users.add(u2);
        users.add(u3);
        insert users; 
        
        String accountId = DeviceUtilTest.createAccount();
            
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = u1.id,
                Account__c=accountId,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test'
            );
            
            Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = u2.id,
                Account__c=accountId,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='2',
                Account_Role_ID__c='test'
            );
            
            Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = u3.id,
                Account__c=accountId,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Technical Support',
                Sequence_No__c='3',
                Account_Role_ID__c='test'
            );
            
            List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3};             
            insert atps;
            
            
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        Test.startTest();
            List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
            List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
            Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011');
            reticleDeviceList.add(reticleDevice);
            fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
            insert reticleDeviceList;
            insert fabReticleList;
        
            ROS_ReCalculateSharing obj2 = new ROS_ReCalculateSharing();
            obj2.reticleRecord.Account__c     = accountId;
            obj2.reticleRecord.ROS_Cycle__c   = Cycle;
            obj2.ReCalculateSharing();
            
            ROS_ReCalculateSharing obj = new ROS_ReCalculateSharing('');
            database.executeBatch(obj,1);
                        
            // Schedule the test job
            String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new ROS_BATCH_SCHEDULER_RecalculateSharing());
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            
            //testing the concurrent request for Recalculation
            obj2.ReCalculateSharing();
            
            Pagereference returnpage = obj.returnToReticleSearch();
            System.assert(returnpage != null);
        Test.stopTest();
    }
    
    //Added for Tlai new methods for Scrap
    static testMethod void methodForDisposition_scrap2(){
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
                
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
        
            reticle.Reticle_Workflow_Status__c = 'Pending for Customer Feedback';
            reticle.Invalid__c  = false;
            reticle.Made_Valid_by_CSR_Team__c = true;
            update reticle;

            PageReference scrapPage = obj.redirectScrap();
            Test.setCurrentPageReference(scrapPage);
            System.assert(obj.SelReturnReticles.size() > 0);
            
            obj.performScrap();
            System.assertEquals('Scrap',[Select Id,ROS_Status__c from Reticle__c where Id=:reticle.Id].ROS_Status__c);
            
            obj.Category  = 'pDisCert';
            obj.ReticleSearch();
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle,true)); 
            List<Reticle__c> Res = obj.getselectedreticles();
            PageReference  pCer = obj.createDispositionCertificate();
            System.assert(pCer != null);
            
            Test.setCurrentPageReference(pCer);
            ApexPages.currentPage().getParameters().put('AccountId', accountId);
            obj.disposalCertificate.Authorizing_User__c = 'Test';
            obj.disposalCertificate.Designation__c = 'Test'; 
            obj.disposalCertificate.Scrap_Date__c = System.Today();
            obj.GenerateDisposalCertificate();
            obj.getDisposalCertificate();
            obj.createFile();
        Test.stopTest();
    }
    
    static testMethod void method_changeDispositionType_pGeForm() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        for(Environment_Variable__c evs:[select name from Environment_Variable__c ]){
            system.debug('****' +evs);
        }
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
       
            obj.Category = 'pGeForm';
            PageReference returnRetilce = obj.returnRetilce();
            obj.changeDispositiontype();
            System.assertEquals('Return',obj.dispositionType);
        Test.stopTest();
    }
    
    static testMethod void method_changeDispositionTypeAllCategories() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        
        
            obj.Category = 'pDisCert';
            obj.changeDispositiontype();
            System.assertEquals('Scrap',obj.dispositionType);
            
            obj.Category = 'pDebitNote';
            obj.changeDispositiontype();
            obj.ReticleSearch();
            System.assertEquals('Keep',obj.dispositionType);
            
            obj.Category = 'pStfObsel';
            obj.changeDispositiontype();
            System.assert(obj.lOptionDispositionType.size() > 0);
            
            obj.Category = 'pDisShip';
            obj.changeDispositiontype();
            obj.ReticleSearch();
            System.assertEquals('Return',obj.dispositionType);
            
            obj.Category = 'pforVerification';
            obj.changeDispositiontype();            
            obj.ReticleSearch();
            System.assertEquals(true,obj.isDisableChkBx);
        Test.stopTest();
    }
    
    static testMethod void method_NavigatetoGEForm() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1000',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        Reticle__c reticle2 = createReticle('A1001',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending to Notify Customer');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AA-U011',
                                                    GF_Device_Id__c='1313AA-U011',
                                                    Global_foundries_device_Id__c='1313AA-U011');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        Test.startTest();
        ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
        obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle2, true));
        
        
            PageReference pageRef = obj.NavigatetoGEForm();
            System.assert(pageRef != null);
        Test.stopTest();
    }
    
    //DBiswal 08042015
    static testMethod void myunitTest1() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
        
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1005',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending for Customer Feedback');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1313AB-U067',
                                                    GF_Device_Id__c='1313AB-U067',
                                                    Global_foundries_device_Id__c='1313AB-U067');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add( new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;
        
        Test.startTest();
            reticle.ROS_Status__c = 'Return';
            update reticle;  
                    
            PageReference pageRef = Page.ROSVF_SearchReticlesGFForm;
            Test.setCurrentPage(pageRef);
            
            ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
            
            ApexPages.currentPage().getParameters().put('SIinput', 'Provide two test.');        
            
            ROS_ControllerSearchReticleGFForm.FormWrapper fw = new ROS_ControllerSearchReticleGFForm.FormWrapper('testformid');
            
            obj.Category = 'pHSCodAsign';
            obj.changeDispositiontype();
            obj.ReticleSearch();
            System.assertEquals('Return',obj.dispositionType);
            
            List<ROS_ControllerSearchReticleGFForm.Reticlewrapper> TestWr = obj.getSelectedRetwrapper();
            PageReference pageRef1 = obj.storesplinst();
            System.assert(obj.splInst != null);
            PageReference pageRef2 = obj.deletesplinst();
            System.assert(obj.splInst == null);
            
            obj.HSCode = 'testHSCode1';
            obj.Item   = 'testItem1';
            PageReference pageRef3 = obj.assign();            
            PageReference pageRef4 = obj.performSTFObsolescence();            
            obj.getradioOptions();
            obj.setselectedsplinst('Yes');
            obj.getselectedsplinst();
            obj.setsplinstforsubmit('Provide two test.');
            String spl = obj.getsplinstforsubmit();
            System.assert(spl != null);
            obj.getsplinstlist();
            obj.getFabs();
        Test.stopTest();
    }
    
    static testMethod void myunitTest2() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
                
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1086',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending for Customer Feedback');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1312AB-U068',
                                                    GF_Device_Id__c='1312AB-U068',
                                                    Global_foundries_device_Id__c='1312AB-U068');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;               
        
        Test.startTest();
            reticle.ROS_Status__c = 'Scrap';
            update reticle; 
        
            reticle.Reticle_workflow_Status__c = 'Pending Witness Arrival Date';
            update reticle;
        
            PageReference pageRef = Page.ROSVF_SearchReticlesGFForm;
            Test.setCurrentPage(pageRef);
            
            ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
            
            obj.Category = 'pWADate';
            obj.changeDispositiontype();
            obj.ReticleSearch();
            System.assertEquals('Scrap',obj.dispositionType);
            
            List<reticle__c> retList = new List<reticle__c>{reticle};
            obj.RetcileListDevice = ROS_STFObsolescenceProcess.reticlDeviceLevelDisplay(retList);
            for(Device__c devId : obj.RetcileListDevice.keySet()){
                if(!obj.RetcileListDevice.get(devId).isSelected){
                    obj.RetcileListDevice.get(devId).isSelected = true;
                    obj.RetcileListDevice.get(devId).deviveRetcileList = retList;
                }
            }
            
            PageReference pageRef1 = obj.submitWitArrivDate();
            System.assertEquals('Pending Witness Arrival Date',reticle.Reticle_workflow_Status__c);
            PageReference pageRef2 = obj.updatePIYEstep();
            //System.assertNotEquals(0, obj.SelReturnReticles.size());
            PageReference pageRef3 = obj.ViewScrapCertificate();
            System.assert(pageRef3 != null);
            PageReference pageRef4 = obj.redirectToRecalculate();
            System.assert(pageRef4 != null);
            PageReference pageRef5 = obj.redirectToDisposalCert();
            System.assert(pageRef5 != null);
            obj.UserType= 'PI/YE Team';
            obj.getHelpText();
            obj.UserType= 'Trade Comp';
            obj.getHelpText();
            
            reticle.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
            update reticle;
            
            updateHSCodeBatch bt = new updateHSCodeBatch();
            database.executebatch(bt);
            
            PageReference pageRef6 = obj.createDispositionCertificate();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertNotEquals(0, pageMessages.size());
        Test.stopTest();
    }
    static testMethod void myunitTest3() {
        loadCustomSettings();
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT','Retrofit'));
        lstEnv.add(ROS_ControllerSearchReticleGFForm_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT','Single Product'));
        insert lstEnv;
        
        String accountId = DeviceUtilTest.createAccount();
        String Cycle = createReticleCycle();
        String fab = createFab();
        createROSQueryDataSettings();
                
        String shippingAddrId = createShippingAddress(accountId);
        String fwdInfoId      = createForwarderInfo(accountId);
            
        Reticle__c reticle = createReticle('A1086',accountId, cycle, 500, userInfo.getUserId(), true, 'Binary', 
                                           'US', 'Pending for Customer Feedback');
        insert reticle;
        
        List<Reticle_Device__c> reticleDeviceList = new List<Reticle_Device__c>();
        List<Fab_Reticle__c> fabReticleList = new List<Fab_Reticle__c>();
        Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c =reticle.Id, CRM_Device_ID__c='1312AB-U068',
                                                    GF_Device_Id__c='1312AB-U068',
                                                    Global_foundries_device_Id__c='1312AB-U068');
        reticleDeviceList.add(reticleDevice);
        fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
        insert reticleDeviceList;
        insert fabReticleList;               
        
        Test.startTest();
            reticle.ROS_Status__c = 'Scrap';
            update reticle; 
        
            reticle.Reticle_workflow_Status__c = 'Pending Witness Arrival Date';
            update reticle;
        
            PageReference pageRef = Page.ROSVF_SearchReticlesGFForm;
            Test.setCurrentPage(pageRef);
            
            ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
            
            obj.Category = 'pWADate';
            obj.changeDispositiontype();
            obj.ReticleSearch();
            System.assertEquals('Scrap',obj.dispositionType);
            
            List<reticle__c> retList = new List<reticle__c>{reticle};
            obj.RetcileListDevice = ROS_STFObsolescenceProcess.reticlDeviceLevelDisplay(retList);
            for(Device__c devId : obj.RetcileListDevice.keySet()){
                if(!obj.RetcileListDevice.get(devId).isSelected){
                    obj.RetcileListDevice.get(devId).isSelected = true;
                    obj.RetcileListDevice.get(devId).deviveRetcileList = retList;
                }
            }
            
            PageReference pageRef1 = obj.submitWitArrivDate();
            System.assertEquals('Pending Witness Arrival Date',reticle.Reticle_workflow_Status__c);
            PageReference pageRef2 = obj.updatePIYEstep();
            //System.assertNotEquals(0, obj.SelReturnReticles.size());
            PageReference pageRef3 = obj.ViewScrapCertificate();
            System.assert(pageRef3 != null);
            PageReference pageRef4 = obj.redirectToRecalculate();
            System.assert(pageRef4 != null);
            PageReference pageRef5 = obj.redirectToDisposalCert();
            System.assert(pageRef5 != null);
            obj.UserType= 'PI/YE Team';
            obj.getHelpText();
            obj.UserType= 'Trade Comp';
            obj.getHelpText();
            
            reticle.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
        
            reticle.ROS_Status__c='Return' ;
             reticle.HS_Code__c='';
              reticle.Item__c='';
            update reticle;
            
            updateHSCodeBatch bt = new updateHSCodeBatch();
            database.executebatch(bt);
            
            PageReference pageRef6 = obj.createDispositionCertificate();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertNotEquals(0, pageMessages.size());
        Test.stopTest();
    }
}