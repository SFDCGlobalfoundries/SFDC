/**
 Type Name: VisitationFromGFCalActivityProviderTest
Author: Vijay Vemuru
Created Date: 05th-Apr-2016
Reason: This Test class is used for Visitation Calendar.
Change History:
Author: Vijay Vemuru
Modified Date: 
 */
 
@isTest
private class VisitationFromGFCalActivityProviderTest {
    
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

    static testMethod void GFCalActivity() {
        // TO DO: implement unit test
        String AccId = [SELECT id FROM account LIMIT 1].id;
        List<Visitation_Record__c> visitationList    =  new List<Visitation_Record__c>();
        for(Integer i=0; i<9;i++) {
            Visitation_Record__c CVA    =   new Visitation_Record__c();
                CVA.Account__c          =   accid;
                CVA.Visit_Name__c       =   'Test';
                CVA.Visit_Type__c       =   'Visit from Customer';
                CVA.Start_Date__c       =   System.Today().addDays(1);
                CVA.End_Date__c         =   System.Today().addDays(3);
                CVA.Purpose__c          =   'QBR';
                visitationList.add(CVA);
        }
        
        visitationList[0].Visit_Location__c     =   'test location';
        visitationList[1].Visit_Location__c     =   'GLOBALFOUNDRIES Other Site';
        visitationList[2].Visit_Location__c     =   'Singapore';
        visitationList[3].Visit_Location__c     =   'Santa Clara';
        visitationList[4].Visit_Location__c     =   'Williston';
        visitationList[5].Visit_Location__c     =   'Burlington';
        visitationList[6].Visit_Location__c     =   'East Fishkill';
        visitationList[7].Visit_Location__c     =   'Malta';
        visitationList[8].Visit_Location__c     =   'Dresden';
        insert visitationList;
        VisitationFromGFCalActivityProvider GFCalActivity = new VisitationFromGFCalActivityProvider();
        GFCalActivity.findActivities(visitationList[0].id);
        GFCalActivity.getActivityTypes();
    }
    
    
}