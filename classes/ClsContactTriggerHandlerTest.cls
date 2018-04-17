/*
Type Name: ClsContactTriggerHandlerTest 
Author: Cognizant
Created Date: 24-April-2013
Reason: This is the Test class for class ClsContactTriggerHandler. 
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
private class ClsContactTriggerHandlerTest {
    
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
  
    static testMethod void testcreateSharingOnAccount(){
        
       
     User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
           
        System.runAs(runningUser) {
        
        Test.startTest();
    
        // Create Custom Settings Value
        List<Contact_Portal_Tab_Access__c> lstContactPortalCustomSettingsObj = new List<Contact_Portal_Tab_Access__c>();
        lstContactPortalCustomSettingsObj.add(new Contact_Portal_Tab_Access__c(
                                                                    Name='Design',My_Devices__c=true,My_wafers__c=true,Product_Services__c=true,
                                                                    PDK_Design_Documents__c = true,IP_Declaration__c=true,BOM__c=true,
                                                                    Electrical_Test__c = true,Wafer_Inspection__c = true,Yield_Sort_ETest_Reporting__c = true,
                                                                    CPK__c = true,Tester_Gauge_R_R__c = true,Product_Wafer_Compliance_Analysis__c = true,
                                                                    PCRB__c = true,Export_Control__c = true,PTRF__c = true,Web_View__c = true,
                                                                    Global_Shuttle_reservation__c = true,Stepper_Tooling_Form__c = true,
                                                                    New_Part_Creation_after_Proto_form__c = true,
                                                                    Process_Request_Form_PRF__c = true,Risk_Waiver__c = true,RTR_RTP__c = true,
                                                                    Process_Reliability_Monitoring__c = true,Reticle_Obsolescence__c = true,
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
                                                                    IP_PLM__c= true,Construction_Analysis_report__c=true,Change_request_report__c=true,
                                                                    WLR_Monitoring_report__c=true,Engineering_Lot_status_report__c=true,ET_and_Inline_CPK_report__c=true,Wafer_Scrap__c=true,
                                                                    Scrap_Reports__c =true,Lot_History__c =true,Fab_WIP__c =true,Custom_Order_Report__c =true,Custom_Mfg_Report__c=true,
                                                                    Procedure__c=True)); 
    
        
       insert lstContactPortalCustomSettingsObj;
        
       // Create Account
       
       List<Account> lstAccount = getAccounts();
       Account fistChildacctObj = lstAccount[0];
            
       Account childacctObj = lstAccount[1];
       childacctObj.ParentId =  fistChildacctObj.Id;
       update childacctObj;
            
       Account ParentacctObj = lstAccount[2];
       ParentacctObj.ParentId =  childacctObj.Id;
       update ParentacctObj;
               

        // Create Contact
        Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=ParentacctObj.Id, Email='con1@gf.com', Department__c='Design',Is_Portal_User_Active__c=false,Role__c = 'Primary Account Admin');
        insert conobj;
        conobj.Is_Portal_User_Active__c = true;
        conobj.Department__c = 'Quality';
        update conobj;
    
    Test.stopTest();
        // retrieve portal profile
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        
        // Create User
        User userObj = new User(Alias = 'tUsernew', Email='xyznew@testnew.com', EmailEncodingKey='UTF-8', LastName='TLnamenew',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName='tUsernew@test.com', Portal_Login__c = 'xyz', contactId = conobj.Id, IsActive = true,CommunityNickname = 'testUser1234');   
        insert userObj;
        
        
        // insert portal tab access
        Portal_Tab_Access__c portalTabObj = new Portal_Tab_Access__c(
                                                        Account__c=ParentacctObj.Id ,User__c = userObj.id,My_Devices__c = true,My_Wafers__c=true,PDK_Design_Documents__c=true,
                                                      Product_Services__c=true,Electrical_Test__c=true,Wafer_Inspection__c=true,Yield_Sort_ETest_Reporting__c=true);
        database.insert(portalTabObj,false);
    
        //AccountShare accShareParentparentObj= new AccountShare();
        //AccountShare accShareparentObj= new AccountShare();
        //AccountShare accShareObj= new AccountShare();
        //AccountShare accChildShareObj= new AccountShare();
        //AccountShare accChildChildShareObj= new AccountShare();
        
       
     
        Set<Id> accountidSet = new Set<Id>();  
        //Map<Id, ID> childParentMap = new Map<Id, Id>();
        Set<Id> contactIdList = new Set<Id>();
        //Map <Id, List<Id>> mapAccountContact= new Map<Id, List<Id>>(); 
        //Map<Id, ID> userContactmap= new Map<Id, Id>(); 
        //Map<Id, List<id>> parentChildMap = new Map<Id, List<id>>();
        //Map <Id, Id> mapParentparentAccount= new Map<Id, Id>();
        //List<Id> accountIdList = new List<Id>();    
        //List<id> childList = new List<Id>(); 
        //List<AccountShare> accShareList = new List<AccountShare>();
        Map<Id,String> contactDepts = new Map<Id,String>(); 
    
    
        accountidSet.add(ParentacctObj.Id);
        
        //childParentMap.put(parentParentacctObj.Id, parentparentacctObj.Id);
        //accountIdList.add(parentParentacctObj.Id);

        contactIdList.add(conobj.Id);
       

        //userContactmap.put(conobj.Id, userObj.Id);    
        contactDepts.put(conobj.Id,'Design;Procurement');
        
        //parentChildMap.put(parentParentacctObj.Id, childList);
        //mapParentparentAccount.put(parentParentacctObj.Id, parentparentacctObj.Id);
          
            
            
     //   System.runAs(userObj){
            
            try{
                ClsContactTriggerHandler.updatePortalTabAccess(contactIdList,contactDepts);
                //ClsContactTriggerHandler.createSharingOnAccount(contactIdList);
               
            }catch(Exception e){
                Boolean expectedExceptionThrown =  (e.getMessage().contains('Field is not writeable: AccountShare.UserOrGroupId')) ? true : false;
               // System.AssertEquals(expectedExceptionThrown, true);
            }
            
                  
      //  }   
      }
    }
    
    
  
    //Negative test
     static testMethod void createSharingOnAccountNegative(){
       
         User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
           
        System.runAs(runningUser) {
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
        Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=ParentacctObj.Id, Email='con1@gf.com', Department__c='Design',Is_Portal_User_Active__c=true);
        insert conobj;
        conobj.Is_Portal_User_Active__c = false;
        conobj.Department__c = 'Quality';
        update conobj;
    
    Test.stopTest();
        // retrieve portal profile
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
       
        // Create User      
        User userObj = new User(Alias = 'Shyam', Email='shyam@test.com', EmailEncodingKey='UTF-8', LastName='Paul',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName='shyam@test.com', Portal_Login__c = 'xyz', contactId = conobj.Id, IsActive = true,CommunityNickname = 'testUser123');   
        insert userObj;
        
        
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
       

        //userContactmap.put(conobj.Id, userObj.Id);    
        contactDepts.put(conobj.Id,'Design;Procurement');
          
      
        ClsContactTriggerHandler.updatePortalTabAccess(contactIdList,contactDepts);
        ClsContactTriggerHandler.createSharingOnAccount(contactIdList);
               
    }
   }
    private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account];   
        
        return accList;
    }
}