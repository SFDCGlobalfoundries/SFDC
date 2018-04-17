/*Author: Vijay Vemuru
    Description: This Test Class is for Sending Visitation Executives Reports 
    History:
    Created     -     Vijay Vemuru-    05/02/2016      - code creation.
*/@isTest(seeAllData=false)
private class VisitationExecutiveReportTest {
    
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
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        String AccId = [SELECT id FROM account LIMIT 1].id;
      
        Visitation_Record__c CVA = new Visitation_Record__c();
        CVA.Account__c = AccId;
        CVA.Visit_Name__c = 'Test';
        CVA.Visit_Type__c = 'Visit from Customer';
        CVA.Visitation_Host__c = Userinfo.getuserId();
        CVA.Start_Date__c = System.Today().addDays(3);
        CVA.End_Date__c = System.Today().addDays(3);
        CVA.Purpose__c = 'QBR';
        CVA.Visit_Location__c= 'Singapore';
        insert CVA;
        
        Visitation_Attendee__c VA = new Visitation_Attendee__c();
        VA.Name ='Test';
        VA.Visitation__c = CVA.Id;
        VA.User__c = userinfo.getuserId();
        VA.Type_of_attendee__c = 'Customer Attendee';
        insert VA;
        VisitationExecutiveReport  visit = new VisitationExecutiveReport();
        visit.visitId = CVA.id;
        List<Visitation_Attendee__c> attendees = visit.getAttendeeList();
        
    }
}