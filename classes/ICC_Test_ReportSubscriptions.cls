@isTest
public class ICC_Test_ReportSubscriptions
{
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    @isTest
   static void test_New_And_ListUserReportSubscriptions()
    {
        try
        {
            User portalUser;
        
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            
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
             Account accntObj2 = new Account(name ='acc2',Site_Department__c='Site1',Sub_Type__c='Direct',
                                  Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                                  Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                                  Corporate_City__c='city1',Corporate_Country__c='Austria'
                                  );
                                  
              insert accntObj2; 
              
                List<LOT_Status__c> lst = new List<LOT_Status__c>();
            for(Integer i=0; i < 500; i++)
            {
                LOT_Status__c objMES = new LOT_Status__c();
                objMES.Account__c = accntObj2.id;
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
                
                
                
    
            Report_Subscription__c testRS1 = new Report_Subscription__c(Interval__c  = 'Daily', 
                                                                       Report_Type__c = 'Standard',
                                                                       SF_Object__c = 'LOT_Status__c',
                                                                       Report_SOQL__c = 'Select Id,Name FROM LOT_Status__c',
                                                                       MasterDetail_To_Account_Field_Name__c = 'account__c',
                                                                       Report_Id__c = 'Test_Report',
                                                                       Subscriber__c = UserInfo.getUserId());
            insert testRS1;
            
            
            
            Test.startTest();
           Id batchJobId = Database.executeBatch(new ICC_Process_UserReportSubscription_Batch(), 200);
           Test.stopTest();
           PageReference pageRef1 = Page.ICC_Email_csv_VF;
            Test.setCurrentPage(pageRef1); 
    
           System.currentPageReference().getParameters().put('mdField', testRS1.MasterDetail_To_Account_Field_Name__c);
           System.currentPageReference().getParameters().put('subscriber', testRS1.Subscriber__c);
           System.currentPageReference().getParameters().put('query', testRS1.Report_SOQL__c);
           
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
            alw.source = ICC_Test_ReportSubscriptions.class.getName();
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
    
    private static testmethod void test_ICC_My_Personal_CustomReports()
    {
        ICC_My_Personal_CustomReports test = new ICC_My_Personal_CustomReports();
    }
    
    private static testmethod void test_Scheduler_CleanseReportSubs()
    {
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',
                        '0 0 0 15 3 ? 2022',
                        new ICC_Scheduler_CleanseReportSubscriptions());
        Test.stopTest();
    }
    
    private static testmethod void test_Scheduler_ProcessSubscription()
    {
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',
                        '0 0 0 15 3 ? 2022',
                        new ICC_Schedule_ReportSubscriptionBatch());
        Test.stopTest();
    }
    
    @isTest
    private static void test_ICC_Test_ReportSubscriptions()
    {
        ICC_Test_ReportSubscriptions test_ICC_Test_ReportSubscriptions = new ICC_Test_ReportSubscriptions();
    }
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}