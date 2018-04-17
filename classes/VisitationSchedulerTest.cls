/*
Type Name: VisitationSchedulerTest
Author: Vijay Vemuru
Created Date: 05th-Apr-2016
Reason: This Test class is used for Visitation Report.
Change History:
Author: 
Modified Date: 
*/

@isTest(seeAllData = false)
public class VisitationSchedulerTest {
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'GLOBALFOUNDRIES INTERNAL');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '500013');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    public static testMethod void executiveReportmethod1() {
        Test.starttest();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='afdasfasfsdafasd123@sfdsfa.com');
            insert usr;
           
            visitation_executive__c  execCustom = new visitation_executive__c(name='test attendee',title__c ='TestDepartment');
            insert execCustom;
          
            String AccId = [SELECT id FROM account LIMIT 1].id;
            Visitation_Record__c CVA = new Visitation_Record__c();
            CVA.Account__c = accId;
            CVA.Visit_Name__c = 'Test';
            CVA.Visit_Type__c = 'Visit from Customer';
            CVA.Start_Date__c = System.Today();
            CVA.End_Date__c = System.Today();
            CVA.Purpose__c = 'QBR';
            CVA.Visit_Location__c = 'Singapore';
            CVA.Customer_Status__c  = '3. Logistics Preparation';
            insert CVA;
            Contact con = new contact(FirstName='test',Lastname='attendee',phone='1223443',email='test@salforce.com',accountid=AccID);
            insert con;
            
            Visitation_Attendee__c VA = new Visitation_Attendee__c();
                VA.Name ='Test';
                VA.attendee__c = con.id;
                VA.Visitation__c = CVA.Id;
                VA.Type_of_attendee__c = 'Partner Attendee';
                VA.Request_Status__c  = 'Requested';
            insert VA;
            Visitation_Attendee__c VA1 = new Visitation_Attendee__c();
                VA1.Name ='Test1';
                VA1.Visitation__c = CVA.Id;
                VA1.Type_of_attendee__c = 'Partner Attendee';
                VA1.attendee__c = con.id;
                VA1.Request_Status__c  = 'Declined';
            insert VA1;
            Visitation_Attendee__c VA2 = new Visitation_Attendee__c();
                VA2.Name ='Test2';
                VA2.Visitation__c = CVA.Id;
                VA2.Type_of_attendee__c = 'Partner Attendee';
                VA2.attendee__c = con.id;
                VA2.Request_Status__c  = 'Confirmed';
            insert VA2;
            
            VisitationReportController contrl = new VisitationReportController();
            VisitationReportScheduler sch = new VisitationReportScheduler();
                sch.sendEmailTemplate();
            string CRON_EXP = '0 0 0 15 3 ? 2022';
            String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, sch);
           
        Test.stopTest();
    }
}