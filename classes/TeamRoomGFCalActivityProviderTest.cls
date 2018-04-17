/*
    Author: Anirban Roy
    Description: Test class for TeamRoomGFCalActivityProvider
    History:
        ARoy  12022013  - code creation
*/

@isTest(SeeAllData=false)
public class TeamRoomGFCalActivityProviderTest{

     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void doTestActivities(){
        test.startTest();
          Account accntObj1 = getAccount('Test Account 009');
        
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 008',Team_Room_Description__c = 'Meeting Team Room1',Primary_Account__c=accntObj1.id);
        insert tmRm;
        Team_Room_Meeting_Minutes__c tmRmMtMnt = new Team_Room_Meeting_Minutes__c();       
        tmRmMtMnt.Team_Room__c = tmRm.id;
        tmRmMtMnt.Meeting_Date__c = Date.valueOf('2013-12-01');
        tmRmMtMnt.Meeting_Type__c = 'Weekly';
        insert tmRmMtMnt;
        String id = String.valueOf(tmRm.id);
        TeamRoomGFCalActivityProvider tmRmGFCalActPrv = new TeamRoomGFCalActivityProvider(); 
        List<GFCalActivity> gfclLst = tmRmGFCalActPrv.findActivities(id);
        System.assert(gfclLst!=null);
        List<GFCalActivityType> gfcActType = tmRmGFCalActPrv.getActivityTypes();
        System.assert(gfcActType!=null);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }

}