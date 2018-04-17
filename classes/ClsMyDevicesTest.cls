/*
 Type Name: ClsMyDevicesTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsMyDevices' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10182013    - Added call to loadEnvironmentVariables() method.
                            - Moved calls to Test.StartTest() and Test.StopTest() to prevent governor limit.
    Ashwini     05132015    - Updated code for refactoring of test class.                        
    Author: Dinesh Suggala    
    Modified Date:30th-Mar-2017  -Added few lines code for DropBox code coverage. 
*/



@isTest(SeeAllData=false)
private class ClsMyDevicesTest 
{
    @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
    
            AccountDataFactory.createAccount(fieldValueMap);
        }
    /**
        This method helps to test the PortalTabAccess record List for My Devices to check its all elements are set as 'True'
        and test the Page Redirection phase.
        
        @method name: testClsMyDevices
       
     */
     
    { 
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
    }
    
    static testmethod void testClsMyDevices()
    {
            
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
          //  UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
           // User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT');
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            Customer_Layer_Summary_Permission__c clsp = new Customer_Layer_Summary_Permission__c();
            
           //  User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
            
                     
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';                          
            insert conobj;
            
            User userObj = [ select Id,ProfileId,contactId,accountId from User where ProfileId =: profileObj.Id and contactId != null and accountId != null limit 1];
            userObj.Alias = 'Shyamtst';
          /*  userObj.Email='shyam@test124.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul123';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
           // userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyamtst@test123.com';
            userObj.Portal_Login__c = 'xyz';
           // userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            //userObj.userRoleId = usrRole.Id;
           */             
            update userObj;
            
            clsp.Customer__c = acctObj.Id;
            clsp.Customer_Remote_Jobview__c = true;
            clsp.Frame_Mockup__c = true;
            clsp.GDSOUT_Review__c = true;
            clsp.MEBES_Jobview__c = true;
            
            insert clsp;
            
            Test.startTest();
            portaltabObj.User__c = userObj.id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.My_Devices__c = true;
            portaltabObj.Wafer_Inspection__c = true;
            portaltabObj.WIP_Status__c = true; 
            portaltabObj.Tester_Gauge_R_R__c = true; 
            portaltabObj.Product_Wafer_Compliance_Analysis__c = true; 
            portaltabObj.Electrical_Test__c = true; 
            portaltabObj.CPK__c = true;
            portaltabObj.Yield_Sort_ETest_Reporting__c = true;
            portaltabObj.Process_Technology__c = true; 
            portaltabObj.Lot_Control_table__c = true;
            portaltabObj.Web_View__c = true; 
            portaltabObj.Stepper_Tooling_Form__c = true; 
            portaltabObj.Risk_Waiver__c = true; 
            portaltabObj.Reticle_Obsolescence__c = true; 
            portaltabObj.RTR_RTP__c = true; 
            portaltabObj.PCRB__c = true;
            portaltabObj.Prototype_tracking__c = true;
            portaltabObj.Process_Request_Form_PRF__c = true; 
            portaltabObj.Process_Reliability_Monitoring__c = true; 
            portaltabObj.PTRF__c = true; 
            portaltabObj.New_Part_Creation_after_Proto_form__c = true; 
            portaltabObj.IP_Declaration__c = true; 
            portaltabObj.Global_Shuttle_reservation__c = true; 
            portaltabObj.Export_Control__c = true; 
            portaltabObj.BOM__c = true;
            portaltabObj.WLR_Monitoring_report__c= true;
            portaltabObj.Engineering_Lot_status_report__c= true;
            portaltabObj.ET_and_Inline_CPK_report__c= true;
            portaltabObj.Construction_Analysis_report__c= true;
            portaltabObj.Change_request_report__c= true;
            portaltabObj.Module_Final_Test__c = true;
            portaltabObj.Wafer_Sort_Test__c = true;
            portaltabObj.GFV_Fab9_10_Reports__c = true;
         
         
            insert portaltabObj;
               
          
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);  
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
                clsMyDevicesObj.Page = 'mydeviceshome';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'electricaltest';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page ='ModuleFinalTest';
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page ='WaferSortTest';
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'waferinspection';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'yieldreporting';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'cpk';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'testerGauge';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'productwafer';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'wipstat';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'lotcontrol';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'processtech';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'pcrb';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'WLR';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'cpkreport';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'analysisreport';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'lotstatusreport';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'CR';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'ExportControlList';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'IPDeclarationList';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'NewPartCreationForm';  
                clsMyDevicesObj.redirect();                    
                clsMyDevicesObj.Page = 'QC';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'MyDeviceRequirementList';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'steppertoolingform';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'globalShuttleRepresent';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'processRequest';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'CreateDRT';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'SearchDRT';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'DetailDRT';  
                clsMyDevicesObj.redirect(); 
                clsMyDevicesObj.Page = 'LayerSummaryPage';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'GDSOUTReviewCustomer';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'GDSOUTReviewFoundry';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'FrameMockupReviewCustomer';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'FrameMockupReviewFoundry';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'SendPrimeData';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'SendFrameData';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewCustomer';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewFoundry';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewTapeoutCentre';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewTapeoutApplication';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewGlobalShuttle';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewMDP';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'MEBESJobviewMPWTDTI';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'HoldResumeLayer';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'TIDBView';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'TIDBFileExtraction';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'TIDBSearch';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'myMPWDevices';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'viewMPWSchedule';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'searchMPW';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'userGuide';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'Proposals';
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'FMSFAB_9_10_DevicesPage';
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'FMSRepoistoryDocuments';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'FormManagementSystemPage';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'SFFGeneration';  
                clsMyDevicesObj.redirect();
                clsMyDevicesObj.Page = 'myMPWWIP';  
                clsMyDevicesObj.redirect();
                
                System.assertEquals(false, clsMyDevicesObj.showmydeviceshomeLink);    
                                     
            Test.stopTest();
    }
    
    /**
        This method helps to test the PortalTabAccess record List for My Devices to check its all elements are set as 'False'.
               
        @method name: testClsMyDevicesPTA
       
     */
   
   /*  
    static testmethod void testClsMyDevicesPTA()
    {
            
           Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT');
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
            Customer_Layer_Summary_Permission__c clsp1 = new Customer_Layer_Summary_Permission__c();           
            
            User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];            
            
            
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            clsp1.Customer__c = acctObj.Id;
            clsp1.Customer_Remote_Jobview__c = false;
            clsp1.Frame_Mockup__c = false;
            clsp1.GDSOUT_Review__c = false;
            clsp1.MEBES_Jobview__c = false;
            
            insert clsp1;
            
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            userObj.Alias = 'John1208';
            userObj.Email='John1208@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='John1208@test.com';
            userObj.Portal_Login__c = 'xyz1208';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            //userObj.userRoleId = usrRole.Id;
                        
            insert userObj;
        
            
            Test.startTest();
            portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.My_Devices__c = false;
            portaltabObj.Wafer_Inspection__c = false;
            portaltabObj.WIP_Status__c = false; 
            portaltabObj.Tester_Gauge_R_R__c = false; 
            portaltabObj.Product_Wafer_Compliance_Analysis__c = false; 
            portaltabObj.Electrical_Test__c = false; 
            portaltabObj.CPK__c = false;
            portaltabObj.Yield_Sort_ETest_Reporting__c = false;
            portaltabObj.Process_Technology__c = false; 
            portaltabObj.Lot_Control_table__c = false;
            portaltabObj.Web_View__c = false; 
            portaltabObj.Stepper_Tooling_Form__c = false; 
            portaltabObj.Risk_Waiver__c = false; 
            portaltabObj.Reticle_Obsolescence__c = false; 
            portaltabObj.RTR_RTP__c = false; 
            portaltabObj.PCRB__c = false;
            portaltabObj.Prototype_tracking__c = false;
            portaltabObj.Process_Request_Form_PRF__c = false; 
            portaltabObj.Process_Reliability_Monitoring__c = false; 
            portaltabObj.PTRF__c = false; 
            portaltabObj.New_Part_Creation_after_Proto_form__c = false; 
            portaltabObj.IP_Declaration__c = false; 
            portaltabObj.Global_Shuttle_reservation__c = false; 
            portaltabObj.Export_Control__c = false; 
            portaltabObj.BOM__c = false;
            portaltabObj.WLR_Monitoring_report__c= false;
            portaltabObj.Engineering_Lot_status_report__c= false;
            portaltabObj.ET_and_Inline_CPK_report__c= false;
            portaltabObj.Construction_Analysis_report__c= false;
            portaltabObj.Change_request_report__c= false;
         
         
            insert portaltabObj;
        }  
            System.runAs(userObj)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);  
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
                 
                
                //System.assertEquals(false, clsMyDevicesObj.showwaferinspectionLink);
                //System.assertEquals(false, clsMyDevicesObj.showelectrictestLink);
                      
            } 
            Test.stopTest(); 
    }
     */
     
     @isTest
    public static void testClsMyDevicesWithoutAccountSystemAdmin1()
    {
        User u;
        test.startTest();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u;
            
            List<Group> ListOfGroups = [select Id, Name from Group where Name like 'Swift%']; //createGroups();
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
            }
            insert GM;
            System.runAs(u)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);          
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
            } 
        }
        test.stopTest();
    }
    
    @isTest
    public static void testClsMyDevicesWithoutAccountSystemAdmin()
    {
       Test.startTest();
        User u;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u;
            
            List<Group> ListOfGroups = [select Id, Name from Group where Name like 'Swift%']; //createGroups();
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
            }
            insert GM;
            System.runAs(u)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);          
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
            } 
        }
        test.stopTest();
    }
    
    @isTest
    public static void testClsMyDevicesGF_FAE_FTS()
    {
      test.startTest();
        User u;
        
        List<SObject> lstSwift_MRS_Fields_Permission_Config_Data = Test.loadData(MRS_Fields_Permission_Config__c.sObjectType,'Swift_MRS_Fields_Permission_Config_Data');
        Map<String,MRS_Fields_Permission_Config__c> mrsFieldPermissionConfig  = MRS_Fields_Permission_Config__c.getAll();
        if (mrsFieldPermissionConfig.containsKey('SWIFT_FE')){
            
        } else{
            MRS_Fields_Permission_Config__c MRSFPC=new MRS_Fields_Permission_Config__c();
            MRSFPC.CustomerRemoteJobviewFrame__c=true;
            MRSFPC.CustomerRemoteJobviewPrime__c=true;
            MRSFPC.DRW__c=true;
            MRSFPC.FoundryRemoteJobviewFrame__c=true;
            MRSFPC.FoundryRemoteJobviewPrime__c=true;
            MRSFPC.FrameMockupCustomer__c=true;
            MRSFPC.FrameMockupFoundry__c=true;
            MRSFPC.GDSOUTReviewCustomer__c=true;
            MRSFPC.GDSOUTReviewFoundry__c=true;
            MRSFPC.MEBESJobviewCustomer__c=true;
            MRSFPC.MEBESJobviewFoundry__c=true;
            MRSFPC.MEBESJobviewGlobalShuttle__c=true;
            MRSFPC.MEBESJobviewMDP__c=true;
            MRSFPC.MEBESJobviewTapeoutAPPLICATIONS__c=true;
            MRSFPC.MEBESJobviewTapeoutCenter__c=true;
            MRSFPC.MEBESJobviewTDTIMPW__c=true;
            MRSFPC.MEBESReceivedFrame__c=true;
            MRSFPC.MEBESReceivedPrime__c=true;
            MRSFPC.Name='SWIFT_FE';
            MRSFPC.ORC__c=true;
            MRSFPC.SendDataFrame__c=true;
            MRSFPC.SendDataPrime__c=true;
            insert MRSFPC;   
        }
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u;            
            
            Account acctObj = getAccount('MYTEST ACCOUNT');
            
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                    User__c = u.id,
                    Account__c=acctObj.id,
                    Account_Access__c='Read/Write',
                    Opportunity_Access__c='Read/Write',
                    Team_Role__c='Primary Field Application Engineer',
                    Sequence_No__c='1',
                    Account_Role_ID__c='test1239'
            );
             
            insert atp;
            system.assertNotEquals(atp.Id, null);
            
            List<Group> ListOfGroups = [select Id, Name from Group where Name like 'Swift%']; //createGroups();
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
            }
            insert GM;
            System.runAs(u)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);  
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
            } 
        }
       test.stopTest();
    }
    
    @isTest
    public static void testClsMyDevicesGroupAndGroupMember()
    {
        test.startTest();
        User u;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u;
            
            List<Group> ListOfGroups = [select Id, Name from Group where Name like 'Swift%']; //createGroups();
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
            }
            insert GM;
            System.runAs(u)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);  
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
            } 
        }
        test.stopTest();
    }
    
    @isTest
    public static void testClsMyDevicesAccountProxy()
    {
        test.startTest();
        User u;
        List<SObject> lstSwift_MRS_Fields_Permission_Config_Data = Test.loadData(MRS_Fields_Permission_Config__c.sObjectType,'Swift_MRS_Fields_Permission_Config_Data');
        Map<String,MRS_Fields_Permission_Config__c> mrsFieldPermissionConfig  = MRS_Fields_Permission_Config__c.getAll();
        if (mrsFieldPermissionConfig.containsKey('SWIFT_FE')){
            
        } else{
            MRS_Fields_Permission_Config__c MRSFPC=new MRS_Fields_Permission_Config__c();
            MRSFPC.CustomerRemoteJobviewFrame__c=true;
            MRSFPC.CustomerRemoteJobviewPrime__c=true;
            MRSFPC.DRW__c=true;
            MRSFPC.FoundryRemoteJobviewFrame__c=true;
            MRSFPC.FoundryRemoteJobviewPrime__c=true;
            MRSFPC.FrameMockupCustomer__c=true;
            MRSFPC.FrameMockupFoundry__c=true;
            MRSFPC.GDSOUTReviewCustomer__c=true;
            MRSFPC.GDSOUTReviewFoundry__c=true;
            MRSFPC.MEBESJobviewCustomer__c=true;
            MRSFPC.MEBESJobviewFoundry__c=true;
            MRSFPC.MEBESJobviewGlobalShuttle__c=true;
            MRSFPC.MEBESJobviewMDP__c=true;
            MRSFPC.MEBESJobviewTapeoutAPPLICATIONS__c=true;
            MRSFPC.MEBESJobviewTapeoutCenter__c=true;
            MRSFPC.MEBESJobviewTDTIMPW__c=true;
            MRSFPC.MEBESReceivedFrame__c=true;
            MRSFPC.MEBESReceivedPrime__c=true;
            MRSFPC.Name='SWIFT_FE';
            MRSFPC.ORC__c=true;
            MRSFPC.SendDataFrame__c=true;
            MRSFPC.SendDataPrime__c=true;
            insert MRSFPC;   
        }
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u;            
            
            Account acctObj = getAccount('MYTEST ACCOUNT');
            
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                    User__c = u.id,
                    Account__c=acctObj.id,
                    Account_Access__c='Read/Write',
                    Opportunity_Access__c='Read/Write',
                    Team_Role__c='Primary Field Application Engineer',
                    Sequence_No__c='1',
                    Account_Role_ID__c='test1239'
            );
             
            insert atp;
            system.assertNotEquals(atp.Id, null);
            System.runAs(u)
            {
            
                ApexPages.currentPage().getHeaders().put('Host',system.label.Internal_URL);  
                ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
                      
            } 
        }
        test.stopTest();
    }
    
    public static testMethod void MDDTestMethod(){
       Test.startTest();
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
        user us = [Select ID,AccountId from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        Account acctObj=new Account();
        Contact conobj=new Contact();
        Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
        Customer_Layer_Summary_Permission__c clsp = new Customer_Layer_Summary_Permission__c();
        System.runAs(us){
            RecordType rt = [SELECT  Id FROM RecordType WHERE SObjectType = 'Account'  AND Name = 'Customer'];
            Map<String,Object> fieldValueMap = New Map<String,Object>();
            fieldValueMap.put('Name','NamePvt company');
            fieldValueMap.put('Stage__c','Unqualified');
            fieldValueMap.put('Site_Department__c','Test Department1');
            fieldValueMap.put('Sub_Type__c','Direct');
            fieldValueMap.put('Transaction_Type__c','Transactional');
            fieldValueMap.put('Region__c','APJ');
            fieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
            fieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
            fieldValueMap.put('Bill_To_City__c','Test City');
            fieldValueMap.put('Corporate_City__c','Test City');
            fieldValueMap.put('Bill_To_Country__c','Singapore');
            fieldValueMap.put('Corporate_Country__c','Singapore');
            fieldValueMap.put('RecordTypeId',rt.id);
            fieldValueMap.put('Short_Name__c','TestAcct');
            acctObj = AccountDataFactory.createAccount(fieldValueMap);
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            insert conobj;
            User userObj = [ select Id,ProfileId,contactId from User where ProfileId =: profileObj.Id and contactId != null limit 1];
            userObj.Alias = 'Shyam';
            /*userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.IsActive = true; */
            update userObj;
            clsp.Customer__c = acctObj.Id;
            clsp.Customer_Remote_Jobview__c = true;
            clsp.Frame_Mockup__c = true;
            clsp.GDSOUT_Review__c = true;
            clsp.MEBES_Jobview__c = true;
            insert clsp;
            
            portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
            portaltabObj.My_Devices__c = true;
            portaltabObj.Wafer_Inspection__c = true;
            portaltabObj.WIP_Status__c = true; 
            portaltabObj.Tester_Gauge_R_R__c = true; 
            portaltabObj.Product_Wafer_Compliance_Analysis__c = true; 
            portaltabObj.Electrical_Test__c = true; 
            portaltabObj.CPK__c = true;
            portaltabObj.Yield_Sort_ETest_Reporting__c = true;
            portaltabObj.Process_Technology__c = true; 
            portaltabObj.Lot_Control_table__c = true;
            portaltabObj.Web_View__c = true; 
            portaltabObj.Stepper_Tooling_Form__c = true; 
            portaltabObj.Risk_Waiver__c = true; 
            portaltabObj.Reticle_Obsolescence__c = true; 
            portaltabObj.RTR_RTP__c = true; 
            portaltabObj.PCRB__c = true;
            portaltabObj.Prototype_tracking__c = true;
            portaltabObj.Process_Request_Form_PRF__c = true; 
            portaltabObj.Process_Reliability_Monitoring__c = true; 
            portaltabObj.PTRF__c = true; 
            portaltabObj.New_Part_Creation_after_Proto_form__c = true; 
            portaltabObj.IP_Declaration__c = true; 
            portaltabObj.Global_Shuttle_reservation__c = true; 
            portaltabObj.Export_Control__c = true; 
            portaltabObj.BOM__c = true;
            portaltabObj.WLR_Monitoring_report__c= true;
            portaltabObj.Engineering_Lot_status_report__c= true;
            portaltabObj.ET_and_Inline_CPK_report__c= true;
            portaltabObj.Construction_Analysis_report__c= true;
            portaltabObj.Change_request_report__c= true;
            portaltabObj.MDD_Parts__c = true;
            portaltabObj.BCM__c = true;
            portaltabObj.Quality_System__c = true;
            portaltabObj.ImpactNotify__c = true;
            portaltabObj.Other_EHS_CSR_Disclosures__c = true;
            insert portaltabObj;
            
            //Added the code for DropBox Link 
            DropBox__c drp=new DropBox__c();
            drp.Name='Dropbox';
            drp.DropBox__c='DropBox';
            drp.DropBox_InternalURL__c='https://ec2-107-22-125-226.compute-1.amazonaws.com/ODC/?un=internal';
            drp.DropBox_ExternalURL__c='https://ec2-107-22-125-226.compute-1.amazonaws.com/ODC/?un=external';
            insert drp;
            //Code Ended here for DropBox Link
            
            ApexPages.currentPage().getHeaders().put('Host','https://gfvdev-globalfoundryview.cs5.force.com/GlobalfoundryView/apex/MyDevices');  
            ClsMyDevices  clsMyDevicesObj = new ClsMyDevices ();
            clsMyDevicesObj.steppertoolingformLink = 'Test';
            clsMyDevicesObj.showprocesstechnologyLink = true;
            clsMyDevicesObj.showPartSearchLink = true;
            clsMyDevicesObj.showReachLink = true;
            clsMyDevicesObj.showChinaRohsLink = true;
            clsMyDevicesObj.showEngineeringSpecLink = true;
            clsMyDevicesObj.showMDD = true;
            clsMyDevicesObj.showQualityApp = true;
            clsMyDevicesObj.OtherEHS = true;
            clsMyDevicesObj.ImptNotification = true;
            clsMyDevicesObj.BCM = true;
            clsMyDevicesObj.Page = 'mydeviceshome';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'electricaltest';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'waferinspection';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'yieldreporting';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'cpk';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'testerGauge';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'productwafer';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'wipstat';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'lotcontrol';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'processtech';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'pcrb';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'WLR';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'cpkreport';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'analysisreport';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'lotstatusreport';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'CR';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ExportControlList';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'IPDeclarationList';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'NewPartCreationForm';  
            clsMyDevicesObj.redirect();                    
            clsMyDevicesObj.Page = 'QC';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'MyDeviceRequirementList';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'steppertoolingform';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'globalShuttleRepresent';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'processRequest';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'CreateDRT';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'SearchDRT';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'DetailDRT';  
            clsMyDevicesObj.redirect(); 
            clsMyDevicesObj.Page = 'LayerSummaryPage';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'GDSOUTReviewCustomer';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'GDSOUTReviewFoundry';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'FrameMockupReviewCustomer';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'FrameMockupReviewFoundry';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'SendPrimeData';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'SendFrameData';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewCustomer';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewFoundry';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewTapeoutCentre';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewTapeoutApplication';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewGlobalShuttle';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewMDP';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MEBESJobviewMPWTDTI';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'HoldResumeLayer';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'TIDBView';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'TIDBFileExtraction';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'TIDBSearch';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'MDDPartSearch';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ReachDeclatarion';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ChinaROHS_Declaration';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ViewAllEOLPCNs';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page='DropBox';
            clsMyDevicesObj.redirect();
            Part_Family__c f = new Part_Family__c();
            f.Name = 'Engineering Specs';
            insert f;
            clsMyDevicesObj.Page = 'EngineeringSpec';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ISOCertification';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'EHSDisclosures';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'ImpactNotification';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'BCManagement';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'InlineMeasurement';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'reticleobsolescence';  
            clsMyDevicesObj.redirect();
            clsMyDevicesObj.Page = 'DesignWaiverCollaboratorList';  
            clsMyDevicesObj.redirect();
            System.assertEquals(false, clsMyDevicesObj.showmydeviceshomeLink);  
        }
      test.stopTest();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}