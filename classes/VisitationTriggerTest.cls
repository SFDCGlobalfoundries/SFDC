/*
    Author: Zymark Ambat
    Description: This serves as the test class for VisitationTrigger.
    History: 
        ZAmbat      08252014    - Code creation.
*/
@isTest(SeeAllData=false)
public class VisitationTriggerTest {
	public static Id createCVA(id accid){
        Visitation_Record__c CVA = new Visitation_Record__c();
        CVA.Account__c = accid;
        CVA.Visit_Name__c = 'Test';
        CVA.Visit_Type__c = 'Visit from Customer';
        CVA.Start_Date__c = System.Today().addDays(1);
        CVA.End_Date__c = System.Today().addDays(3);
        CVA.Purpose__c = 'QBR';
        CVA.Visit_Location__c = 'Singapore';
        CVA.Add_as_attendee_Host__c  = true;
        insert CVA;
        return CVA.Id;
    }  
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name','GLOBALFOUNDRIES INTERNAL');
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
    static testMethod void testVisitationTrigger() {
    	test.startTest();
    		string testAccountId = [SELECT id from Account LIMIT 1].id;
    		try{
    			string testVisitationRecord = VisitationTriggerTest.createCVA(testAccountId);
    		}catch(exception excp) {
    			Account acc = new account(id=testAccountId,Region_Head_lk__c = userinfo.getuserid());
    			update Acc;
    			string testVisitationRecord = VisitationTriggerTest.createCVA(testAccountId);
    		}
    	test.stopTest();
    }
}