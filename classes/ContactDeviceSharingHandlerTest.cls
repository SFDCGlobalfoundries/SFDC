/*
Type Name: ContactDeviceSharingHandlerTest
Author: Cognizant
Created Date: 24-April-2013
Reason: This is the Test class for class ContactDeviceSharingHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Nbustillos  10182013    - Optimized code logic on doing test execution. 
                            - Commented unused variables.
    Ashwini     05132015    - Updated code for refactoring of test class.                        
 */
@isTest
private class ContactDeviceSharingHandlerTest{
    static Account mainAccount;
    static Opportunity testOppty;
    static Opportunity_Program__c testOpptyProgram; 
    static Mask_Set_Title__c mst;
    static MSTAccount__c mstAcc;
    @testSetup static void testdata() {
            
         DataUtilTest.loadEnvironmentVariables();
         
          List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
                fieldValueMap.put('Name', 'MYTESTACC'+z);            
                fieldValueMap.put('stage__c', 'Unqualified');        
                fieldValueMap.put('sub_type__c', 'Direct');
                fieldValueMap.put('site_department__c', 'test dept');          
                fieldValueMap.put('transaction_type__c', 'transactional');                          
                fieldValueMap.put('region__c', 'APJ');        
                fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Corporate_City__c', 'Test City');                
                fieldValueMap.put('Corporate_Country__c', 'India');
                fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Bill_To_City__c', 'Test City');            
                fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
                fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMapsList.add(fieldValueMap);
        }
            
            AccountDataFactory.createAccounts(fieldValueMapsList,3);
       
        }
  
    private static void init() {
        
        mainAccount = new Account();
        mainAccount.name = 'THE MOSIS SERVICE';
        mainAccount.Site_Department__c = 'Site13';
        mainAccount.Sub_Type__c = 'Direct';
        mainAccount.Transaction_Type__c = 'Transactional';
        mainAccount.Region__c = 'APJ';
        mainAccount.Bill_To_Address_1__c = 'New Bill43';
        mainAccount.Bill_To_City__c = 'city13';
        mainAccount.Bill_To_Country__c = 'Austria';
        mainAccount.Corporate_Address_1__c = 'BTM';
        mainAccount.Corporate_City__c = 'city13';
        mainAccount.Corporate_Country__c = 'Austria';
        insert mainAccount;
        
        // Create Opportunity Record
        testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.Opportunity_Sourcing_Type__c = 'First Source';
        testOppty.End_Application_for_Opty__c = 'Server';
        testOppty.AccountId = mainAccount.Id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM'; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        testOppty.Fab_Assignment_1__c = 'FAB 1';
        
        insert testOppty;
        
        // Create Opportunity Program Record
        testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = mainAccount.Id;
        testOpptyProgram.Opportunity__c = testOppty.Id;
        
        Insert testOpptyProgram;
        
        
        
        //Create Mask Set Title Record
        mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT1';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        
        mstAcc = new MSTAccount__c();
        mstAcc.Account__c = mainAccount.id;
        mstAcc.Mask_Set_Title__c = mst.id;
        insert mstAcc;  
    }
    
    static testMethod void testcreateSharingOnDevice(){
     
        
        
        Account account1 = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct',
                                Transaction_Type__c = 'Transactional', Region__c = 'SiPh', Bill_To_Address_1__c = 'New Bill',
                                Bill_To_City__c = 'city1', Bill_To_Country__c = 'USA', Bill_To_State__c = 'CA',Corporate_Address_1__c = '',
                                Corporate_City__c = 'city1', Corporate_Country__c = 'USA',Corporate_State__c='USA');
        insert account1;
            
        
        Set<Id> accountidSet = new Set<Id>();  
        Set<Id> contactIdList = new Set<Id>();
        Map<Id,String> contactDepts = new Map<Id,String>(); 
        Test.startTest();
        Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=account1.Id, Email='con1@gf.com', Department__c='Design;Procurement');
        insert conobj;
    

        contactIdList.add(conobj.Id);
        contactDepts.put(conobj.Id,'Design;Procurement');
        
         
        
        Account account2 = new Account(name = 'acc2', Site_Department__c = 'Site2', Sub_Type__c = 'Direct',
                                Transaction_Type__c = 'Transactional', Region__c = 'SiPh', Bill_To_Address_1__c = 'New Bill',
                                Bill_To_City__c = 'city1', Bill_To_Country__c = 'USA', Bill_To_State__c = 'CA',Corporate_Address_1__c = '',
                                Corporate_City__c = 'city1', Corporate_Country__c = 'USA',Corporate_State__c='USA');
        insert account2;       
        
        List<Contact> MyconList = new List<Contact>();
            Contact Mycon1 = new Contact(
                firstName = 'test1', lastName = 'test1',accountId = account2.id);
             MyconList.add(Mycon1);
               insert MyconList;
                
        Map<id,Contact> oldContMap = new Map<id,Contact>();
        oldContMap.put(conobj.id, conobj);
        
        // Create Contact
        
        
        init();
        Test.stopTest();        
        
        
         //Create Device Record
        Device__c dev = new Device__c();
        dev.Name = 'TEST123.01';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = account2.Id;
        dev.Design_Partner__c = account1.Id;
        dev.Opportunity2__c = testOppty.Id;
        dev.Opportunity_Program__c= testOpptyProgram.Id;
        dev.Market_Segment__c = 'Mobility';
        dev.Semiconductor_Device__c = 'Analog Amplifier';
        dev.End_Application__c = 'Server';
        dev.Device_Sourcing__c = 'First Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Reason_For_Status_On_Hold__c = 'test';
        dev.Internal_Device_Process_Family__c = 'Super Low Power';
        dev.Fab__c = 'FAB 2';
        dev.Internal_Device_Geometry__c = '0.055UM';
        dev.GSOP_Assignment_Tapeout_Plan__c = 'No';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        
        List<Device__Share> deviceShareList = [SELECT AccessLevel FROM Device__Share WHERE Parent.Design_Partner__c =: account1.Id AND 
                                                RowCause =: Schema.Device__Share.RowCause.Design_Partner_Sharing__c];
                       
        System.AssertEquals(dev.Status__c, 'Active');
               
        ContactDeviceSharingHandler cls = new ContactDeviceSharingHandler();
        cls.removeDesignPartnerDeviceAccess(null,null);  
        cls.shareDesignPartnerDevice(null); 
        
    }
    
    static testMethod void testcreateSharingOnDevice1(){
        Test.startTest();    
        init();
        
        List<Contact> MyconList = new List<Contact>();
            Contact Mycon1 = new Contact(
                firstName = 'test1', lastName = 'test1',accountId = mainAccount.id);
             MyconList.add(Mycon1);
               insert MyconList;
        Test.stopTest();
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        insert pt;
        
         //Create Device Record
        Device__c dev = new Device__c();
        dev.Name = 'TEST123.01';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = mainAccount.Id;
        dev.Design_Partner__c = mainAccount.Id;
        dev.Expose_Device_to_Customer__c = true;
        dev.Process_Technology_2__c = pt.Id;
        dev.Opportunity2__c = testOppty.Id;
        dev.Opportunity_Program__c= testOpptyProgram.Id;
        dev.Market_Segment__c = 'Mobility';
        dev.Semiconductor_Device__c = 'Analog Amplifier';
        dev.End_Application__c = 'Server';
        dev.Device_Sourcing__c = 'First Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Reason_For_Status_On_Hold__c = 'test';
        dev.Internal_Device_Process_Family__c = 'Super Low Power';
        dev.Fab__c = 'FAB 2';
        dev.Internal_Device_Geometry__c = '0.055UM';
        dev.GSOP_Assignment_Tapeout_Plan__c = 'No';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
         
        System.AssertEquals(dev.Status__c, 'Active');
               
        ContactDeviceSharingHandler cls = new ContactDeviceSharingHandler();
        cls.shareDesignPartnerDevice(MyconList);
        cls.removeDesignPartnerDeviceAccess(null,null);  
        cls.shareDesignPartnerDevice(null);
         
    }
    
  
    //Negative test
     static testMethod void createSharingOnDeviceNegative(){
       
         User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
        Test.startTest(); 
        // Create Custom Settings Value
        List<Contact_Portal_Tab_Access__c> lstContactPortalCustomSettingsObj = new List<Contact_Portal_Tab_Access__c>();
        lstContactPortalCustomSettingsObj.add(new Contact_Portal_Tab_Access__c(
                                                                    Name='Design',My_Devices__c=true,My_wafers__c=true,Product_Services__c=true,
                                                                    PDK_Design_Documents__c = false,IP_Declaration__c=true,BOM__c=true,
                                                                    Electrical_Test__c = false,Wafer_Inspection__c = false,Yield_Sort_ETest_Reporting__c = false,
                                                                    CPK__c = false,Tester_Gauge_R_R__c = false,Product_Wafer_Compliance_Analysis__c = false,
                                                                    PCRB__c = true,Export_Control__c = false,PTRF__c = false,Web_View__c = true,
                                                                    Global_Shuttle_reservation__c = true,Stepper_Tooling_Form__c = true,
                                                                    New_Part_Creation_after_Proto_form__c = true,
                                                                    Process_Request_Form_PRF__c = false,Risk_Waiver__c = false,RTR_RTP__c = true,
                                                                    Process_Reliability_Monitoring__c = false,Reticle_Obsolescence__c = true,
                                                                    Orders__c= true,Production__c= true,Shipping__c= true,Order_Query__c = true,
                                                                    Production_Query__c = true,Shipping_Query__c = true,Forecast_Fab_Cycle_Time__c = true,
                                                                    Wafer_Start__c = true,WIP_Status__c = true,Fab_Out_Schedule__c = true,
                                                                    Finish_Goods_Report__c = true,Lot_Control_table__c = true,Account_Statement__c = true,
                                                                    Backlog__c = true,Billing__c = true,Credit_and_Debit_Note__c = true,NRE_Invoice__c = true,
                                                                    Order_Acknowledgement__c = true,Purchase_Order_Tracking__c = true,Tax_Invoice__c = true,
                                                                    ROM_Blanket__c = true,Certificate_of_Compliance__c = true,Custom_Shipment_Report__c = true,
                                                                    On_Time_Delivery__c = true,Shipment_Alert_Report__c = true,Shipment_Detail_Unsort_and_Sort__c = true,
                                                                    Ship_Alert_by_Location__c = true,Packaging_List_Report__c = true,Configurator__c = true,
                                                                    Design_Enablement__c = true,Process_Technology__c = true,Process_ID__c = true,IP__c = true,
                                                                    X3rd_Party_IP__c = true,Price_List__c = true,MPW__c = true,Turnkey__c = true,Services__c = true,
                                                                    Design_Specification_Packages__c = true,Design_Technology_Documents__c = true,
                                                                    IP_PLM__c= true,Construction_Analysis_report__c=false,Change_request_report__c=false,
                                                                    WLR_Monitoring_report__c=false,Engineering_Lot_status_report__c=false,ET_and_Inline_CPK_report__c=false,Wafer_Scrap__c=true,
                                                                    Scrap_Reports__c =true,Lot_History__c =true,Fab_WIP__c =true,Custom_Order_Report__c =true,Custom_Mfg_Report__c=true,
                                                                    Procedure__c=True)); 
    
     
       insert lstContactPortalCustomSettingsObj;
        
       // Create Account
       List<Account> lstAccount = getAccounts();
       
       
       Account fistChildacctObj = lstAccount[0];
  
       Account childacctObj = lstAccount[1];
       childacctObj.ParentId =  lstAccount[0].id;
       update childacctObj;
            
       Account ParentacctObj = lstAccount[2];
       ParentacctObj.ParentId =  lstAccount[1].id;
       update ParentacctObj;
       
        // Create Contact
        Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=ParentacctObj.Id, Email='con1@gf.com', Department__c='Design;Procurement');
        insert conobj;
    
        Test.stopTest();
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
       
        // Create User      
        User userObj = new User(Alias = 'Shyam', Email='shyam@test.com', EmailEncodingKey='UTF-8', LastName='Paul',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName='shyam@test.com', Portal_Login__c = 'xyz', contactId = conobj.Id, IsActive = true,CommunityNickname = 'testUser123');   
        insert userObj;
        
        System.AssertEquals(userObj.Email, 'shyam@test.com');
        
        // insert portal tab access
        Portal_Tab_Access__c portalTabObj = new Portal_Tab_Access__c(
                                                        Account__c=ParentacctObj.Id,My_Devices__c = true,User__c=null,My_Wafers__c=true,PDK_Design_Documents__c=true,
                                                      Product_Services__c=true,Electrical_Test__c=true,Wafer_Inspection__c=true,Yield_Sort_ETest_Reporting__c=true);
        insert portalTabObj;
  
        Set<Id> accountidSet = new Set<Id>();  
      
        Set<Id> contactIdList = new Set<Id>();
    
        Map<Id,String> contactDepts = new Map<Id,String>(); 
    
    
        accountidSet.add(ParentacctObj.Id);
        
        contactIdList.add(conobj.Id);
        
        contactDepts.put(conobj.Id,'Design;Procurement');
   }
    private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account];   
        
        return accList;
    }
}