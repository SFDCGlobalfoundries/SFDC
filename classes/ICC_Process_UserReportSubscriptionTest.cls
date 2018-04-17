/*
Test class for ICC_Process_UserReportSubscription_Batch
Author: Rahul Majumder
* History
* Amit Kumar Ojha  4/7/2017 - Added testmethods to cover ICC_Email_Csv class
*/
@isTest
public class ICC_Process_UserReportSubscriptionTest
{
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        // Inserting an Account for External Users(or portal Users)
        Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
            fieldValueMap.put('Account_Type__c', 'Customer');                           
            fieldValueMap.put('sub_type__c', 'Indirect');        
            fieldValueMap.put('site_department__c', 'IT');  
            fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
            fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
            fieldValueMap.put('region__c', 'US');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            
            Account accntCreateObj = AccountDataFactory.createAccount(fieldValueMap);
       
    }
    //Amith - 4/7/2017 - Adding test methods for Email CSV user difference funtionality - Start
     @isTest
	static void testBatchRun(){
        Report_Subscription__c testRS1 = new Report_Subscription__c(Interval__c  = 'Daily', 
                                                                       Report_Type__c = 'Standard',
                                                                       SF_Object__c = 'LOT_Status__c',
                                                                       Report_SOQL__c = 'Select Id,Name, Account__r.Name FROM LOT_Status__c',
                                                                       MasterDetail_To_Account_Field_Name__c = 'account__c',
                                                                       Report_Id__c = 'Test_Report1',
                                                                       Subscriber__c = UserInfo.getUserId());
            insert testRS1;
            
            system.debug('testRS1***'+testRS1);
            
            //Test.startTest();
           Id batchJobId = Database.executeBatch(new ICC_Process_UserReportSubscription_Batch(), 200);
    }
   @isTest
   static void test_New_And_ListUserReportSubscriptions()
    {
        try
        {
            User portalUser;
        
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                          Test.startTest();

            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = ur.id,
                TimeZoneSidKey='America/Los_Angeles', UserName='stduser@testingorg.com');
    
            System.runAs(u) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
            fieldValueMap.put('Account_Type__c', 'Customer');                           
            fieldValueMap.put('sub_type__c', 'Indirect');        
            fieldValueMap.put('site_department__c', 'IT');  
            fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
            fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
            fieldValueMap.put('region__c', 'US');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
                    

            AccountDataFactory.createAccount(fieldValueMap);
            
            Account accntObj = getAccount('MYTEST ACCOUNT1'); 
            
                 Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
              insert conobj;
              
              Profile profile1 = [Select Id, name from Profile where name = 'Customer Portal Admin'];
              portalUser = new User( ProfileId = profile1.Id,
                                                    Username = 'portaluser@testorg.com',
                                                    Alias = 'auser',
                                                    Email='portaluser@testorg.com',
                                                    EmailEncodingKey='UTF-8',
                                                    Firstname='Bruce',
                                                    Lastname='Wayne',
                                                    LanguageLocaleKey='en_US',
                                                    LocaleSidKey='en_US',
                                                    TimeZoneSidKey='America/Chicago',
                                                    ContactId=conobj.id,
                                                    Portal_Login__c='abc12'
                                                   );
                                                   
             //insert   portalUser   ;
     
                List<LOT_Status__c> lst = new List<LOT_Status__c>();
            for(Integer i=0; i < 500; i++)
            {
                LOT_Status__c objMES = new LOT_Status__c();
                objMES.Account__c = accntObj.id;
                objMES.Name = 'ICC Test '+string.valueOf(i);
                objMES.CONFIRMED_DATE__c = Date.Today();
                objMES.CUST_LOC__c = 'in';
                objMES.CUST_SOLD_TO__c = 'xx---xx';
                objMES.CUST_SHIP_TO__c = 'xx--xx';
                objMES.CURRENT_IBM_PN__c = 'xxxxxxx';
                objMES.PO_LINE_ITEM__c = 'lineItem';
                objMES.LOTNUM_300MM__c = 'lot num';
                objMES.IBM_PN__c = 'text';
                objMES.LOT_NUM__c = 'numnum';
                objMES.LOT_PLANT__c = 'ppp';
                objMES.OUTLOOK_DATE__c = Date.Today();
                objMES.REC_SEQ__c = 12;
                objMES.SECTOR__c = 'secsec';
                //objMES.SO_WITH_SCH_LINE__c = 'text14';
                lst.add(objMES);
            
            }
            
            
            insert lst;
            }
            
         
             
            system.runAs(u) 
            {
                PageReference pageRef = Page.ICC_User_Report_Subscriptions;
                Test.setCurrentPage(pageRef);
            
                // Instantiate a new controller with all parameters in the page
                ICC_User_Report_Subscriptions testcontroller = new ICC_User_Report_Subscriptions();
                testController.refreshAllSubscriptionSOQLs();
                // For first time, current subscriber must have 0 subscriptions
                system.assertEquals([select id FROM Report_Subscription__c Where Subscriber__c =: portalUser.Id].size(), 0);
                
                Report_Subscription__c testRS = new Report_Subscription__c();
            
                ApexPages.StandardController sc = new ApexPages.StandardController(testRS);
                ICC_NewSubscription testNewSub = new ICC_NewSubscription(sc);
            
                PageReference pageRefNew = Page.ICC_New_Subscription;
                //pageRef.getParameters().put('id', String.valueOf(testAccountPlanInsert.Id));
                Test.setCurrentPage(pageRefNew);  
                
                testNewSub.rtSubr.Report_Type__c = 'Custom';
                testNewSub.getReports();
                testNewSub.rtSubr.Report_Type__c = 'Standard';
                testNewSub.getReports(); 
                
                testNewSub.fetchReportsOfSeletedReportType();
                testNewSub.save();
                
                testNewSub.rtSubr.Interval__c = 'Daily';
                //testNewSub.rtSubr.Report_Id__c = '000000000000000';
                //testNewSub.save();
                
                
                //testNewSub.fetchDataTypeOfFields('Account');
                
                
                
    
            Report_Subscription__c testRS1 = new Report_Subscription__c(Interval__c  = 'weekly', 
                                                                       Report_Type__c = 'Standard',
                                                                       SF_Object__c = 'LOT_Status__c',
                                                                       Report_SOQL__c = 'Select Id,Name, Account__r.Name FROM LOT_Status__c',
                                                                       MasterDetail_To_Account_Field_Name__c = 'account__c',
                                                                       Report_Id__c = 'Test_Report',
                                                                       Subscriber__c = UserInfo.getUserId());
            insert testRS1;
            
            system.debug('testRS1***'+testRS1);
            
            //Test.startTest();
           Id batchJobId = Database.executeBatch(new ICC_Process_UserReportSubscription_Batch(), 200);
           Test.stopTest();
           
           PageReference pageRef1 = Page.ICC_Email_csv_VF;
            Test.setCurrentPage(pageRef1); 
    
           System.currentPageReference().getParameters().put('mdField', testRS1.MasterDetail_To_Account_Field_Name__c);
           System.currentPageReference().getParameters().put('subscriber', testRS1.Subscriber__c );
           System.currentPageReference().getParameters().put('query', testRS1.Report_SOQL__c );
           
           ICC_Email_csv testEmailCSV = new ICC_Email_csv();
           
           PageReference pageRef3 = Page.ICC_User_Report_Subscriptions;
                Test.setCurrentPage(pageRef3);
            System.currentPageReference().getParameters().put('delReportSubID', testRS1.id);
                // Instantiate a new controller with all parameters in the page
                ICC_User_Report_Subscriptions testcontroller3 = new ICC_User_Report_Subscriptions();
           testcontroller3.deleteReportSubscription();
           System.currentPageReference().getParameters().put('delReportSubID', null);
           testcontroller3.deleteReportSubscription();
           
            
            }
        }
        catch(exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_Process_UserReportSubscriptionTest.class.getName();
            alw.sourceFunction ='test_New_And_ListUserReportSubscriptions()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }  
    }
    // Code Coverage for 5 Levels of Hierarchy for External Users
    //Amith - 4/7/2017 - Adding test methods for Email CSV user difference funtionality - Start
    @isTest
    static void portalTest_Method()
    {
       Test.startTest();
       //Account accntObj = getAccount('MYTEST ACCOUNT1'); 
       ICC_Base_Master_Object_Field__c shipLotWafObjField = new ICC_Base_Master_Object_Field__c(Name = 'shipment_lot_wafer__c',ShareObject__c='Shipment__Share',BaseMasterObjectIdField__c = 'shipment_lot_id__r.ship_item_id__r.shipment__c'); 
       insert shipLotWafObjField;
       Account accntObj = getAccount('MYTEST ACCOUNT1');
       Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
       insert conobj;
       Profile profile1 = [Select Id, name from Profile where name = 'Customer Portal Admin'];
       User portalUser = new User(ProfileId = profile1.Id,
                                   Username = 'portaluser@testorg.com',
                                   Alias = 'auser',
                                   Email='portaluser@testorg.com',
                                   EmailEncodingKey='UTF-8',
                                   Firstname='Bruce',
                                   Lastname='Wayne',
                                   LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US',
                                   TimeZoneSidKey='America/Chicago',
                                   Portal_Login__c='abc1',
                                   IsActive = true, 
                                   ContactId = conobj.Id , 
                                   HCM_Login_ID__c='abc',
                                   federationidentifier='abcdef' );
        insert portalUser;
        System.debug('***portalUser***'+portalUser);
        
        // Insert Shippment Record
        Shipment__c ship = new Shipment__c(Name = 'Test Shipment',Account__c=accntObj.Id);
        insert ship;
        
        // Insert Sales Order Record
        Sales_Order_Line__c so = new Sales_Order_Line__c(Name = 'Test SO',Account__c=accntObj.Id);
        insert so;
        
        // Insert Shipment Line Record
        Shipment_Line__c shipLine = new Shipment_Line__c(Name = 'Test Ship Line', Sales_Order__c = so.Id, Shipment__c = ship.Id);
        insert shipLine;
        
        // Insert Shipment Container Record (Master-Detail with Shipment)
        Shipment_Container__c shipCont = new  Shipment_Container__c (Shipment_Id__c = ship.Id);
        insert shipCont; 
                
        // Insert Shipment Lot Record
        Shipment_Lot__c shipLot = new Shipment_Lot__c(Ship_Item_Id__c = shipLine.Id, Shipment_Container__c = shipCont.Id);
        insert shipLot;
        
        // Insert Shipment Lot Wafer Record
        Shipment_Lot_Wafer__c shipLotWafer = new Shipment_Lot_Wafer__c(Shipment_Container__c = shipCont.Id, Shipment_Lot_Id__c = shipLot.Id);
        insert shipLotWafer;
        
        Report_Subscription__c testRSRec = new Report_Subscription__c(Interval__c  = 'Daily', 
                                                                       Report_Type__c = 'Standard',
                                                                       SF_Object__c = 'shipment_lot_wafer__c',
                                                                       Report_SOQL__c = 'select shipment_lot_id__r.ship_item_id__r.shipment__r.account__r.name,  shipment_lot_id__r.ship_item_id__r.shipment_id__c from shipment_lot_wafer__c',
                                                                       MasterDetail_To_Account_Field_Name__c = 'Shipment_Container__r.Shipment_Id__r.Account__c',
                                                                       Report_Id__c = 'TestID',
                                                                       Subscriber__c = portalUser.Id);
            insert testRSRec;
       
          PageReference pageRef1 = Page.ICC_Email_csv_VF;
          Test.setCurrentPage(pageRef1); 
    
           System.currentPageReference().getParameters().put('mdField', testRSRec.MasterDetail_To_Account_Field_Name__c);
           System.currentPageReference().getParameters().put('subscriber', testRSRec.Subscriber__c );
           System.currentPageReference().getParameters().put('query', testRSRec.Report_SOQL__c );
           
           ICC_Email_csv testEmailCSV = new ICC_Email_csv();
       
       
   }
   // Code Coverage for 4 Levels of Hierarchy for Internal Users 
    @isTest
    static void nonportalTest_Method()
    {
       Test.startTest();
       //Account accntObj = getAccount('MYTEST ACCOUNT1'); 
       ICC_Base_Master_Object_Field__c shipLotWafObjField = new ICC_Base_Master_Object_Field__c(Name = 'shipment_lot_wafer__c',ShareObject__c='Shipment__Share',BaseMasterObjectIdField__c = 'shipment_lot_id__r.ship_item_id__r.shipment__c'); 
       insert shipLotWafObjField;
       Account accntObj = getAccount('MYTEST ACCOUNT1');
       Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
       insert conobj;
       Profile profile = [Select Id, name from Profile where name = 'System Administrator'];
       User nonportalUser = new User(ProfileId = profile.Id,
                                   Username = 'portaluser@testorg.com',
                                   Alias = 'auser',
                                   Email='portaluser@testorg.com',
                                   EmailEncodingKey='UTF-8',
                                   Firstname='Bruce',
                                   Lastname='Wayne',
                                   LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US',
                                   TimeZoneSidKey='America/Chicago',
                                   IsActive = true,  
                                   HCM_Login_ID__c='abc',
                                   federationidentifier='abcdef' );
        insert nonportalUser;
        
        // Insert Account Share record
        AccountShare accShare = new AccountShare(AccountId = accntObj.Id, AccountAccessLevel='Read', OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read', UserorGroupId = nonportalUser.Id);
        insert accShare;
        
        // Insert Shippment Record
        Shipment__c ship = new Shipment__c(Name = 'Test Shipment',Account__c=accntObj.Id, gross_weight__c = '22.000');
        insert ship;
        
        // Insert Sales Order Record
        Sales_Order_Line__c so = new Sales_Order_Line__c(Name = 'Test SO',Account__c=accntObj.Id);
        insert so;
        
        // Insert Shipment Line Record
        Shipment_Line__c shipLine = new Shipment_Line__c(Name = 'Test Ship Line', Sales_Order__c = so.Id, Shipment__c = ship.Id);
        insert shipLine;
        
        // Insert Shipment Container Record (Master-Detail with Shipment)
        Shipment_Container__c shipCont = new  Shipment_Container__c (Shipment_Id__c = ship.Id);
        insert shipCont; 
                
        // Insert Shipment Lot Record
        Shipment_Lot__c shipLot = new Shipment_Lot__c(Ship_Item_Id__c = shipLine.Id, Shipment_Container__c = shipCont.Id);
        insert shipLot;
        
        // Insert Shipment Lot Wafer Record
        Shipment_Lot_Wafer__c shipLotWafer = new Shipment_Lot_Wafer__c(Shipment_Container__c = shipCont.Id, Shipment_Lot_Id__c = shipLot.Id);
        insert shipLotWafer;
        
        Report_Subscription__c testRSRec = new Report_Subscription__c(Interval__c  = 'Daily', 
                                                                       Report_Type__c = 'Standard',
                                                                       SF_Object__c = 'shipment_lot_wafer__c',
                                                                       Report_SOQL__c = 'select shipment_lot_id__r.ship_item_id__r.shipment__r.gross_weight__c,  shipment_lot_id__r.ship_item_id__r.shipment_id__c from shipment_lot_wafer__c',
                                                                       MasterDetail_To_Account_Field_Name__c = 'Shipment_Container__r.Shipment_Id__r.Account__c',
                                                                       Report_Id__c = 'TestID',
                                                                       Subscriber__c = nonportalUser.Id);
            insert testRSRec;
       
          PageReference pageRef1 = Page.ICC_Email_csv_VF;
          Test.setCurrentPage(pageRef1); 
    
           System.currentPageReference().getParameters().put('mdField', testRSRec.MasterDetail_To_Account_Field_Name__c);
           System.currentPageReference().getParameters().put('subscriber', testRSRec.Subscriber__c );
           System.currentPageReference().getParameters().put('query', testRSRec.Report_SOQL__c );
           
           ICC_Email_csv testEmailCSV = new ICC_Email_csv();
       
       
   }
    //Amith - 4/7/2017 - Adding test methods for Email CSV user difference funtionality - End
    private static testMethod void test_ICC_My_Personal_CustomReports()
    {
        ICC_My_Personal_CustomReports test = new ICC_My_Personal_CustomReports();
    }
    
    private static testMethod void test_Scheduler_CleanseReportSubs()
    {
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',
                        '0 0 0 15 3 ? 2022',
                        new ICC_Scheduler_CleanseReportSubscriptions());
        Test.stopTest();
    }
    
    private static testMethod void test_Scheduler_ProcessSubscription()
    {
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',
                        '0 0 0 15 3 ? 2022',
                        new ICC_Schedule_ReportSubscriptionBatch());
        Test.stopTest();
    }
    
       
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name, OwnerId FROM Account Where Name =: AccountName];
        
        return acct;
    }
}