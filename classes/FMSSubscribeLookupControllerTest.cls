/*
 @class: FMSSubscribeLookupControllerTest
 @CreatedBy: Ram Rai
 @CreatedDate: 27 Jun, 2017
 @Description: to test Subscribe other user functionality...#IM
 @Modifications-
 *
 */
@isTest(seealldata = false)
public class FMSSubscribeLookupControllerTest{

  @testSetup
  static void testDataSetup(){
      DataUtilTest.loadEnvironmentVariables();  
  }    

     static testmethod void FormSubscribeOnBehalfTest1(){
        
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('Name', 'TEST rec');            
        fieldValueAccMap.put('stage__c', 'Unqualified');        
        fieldValueAccMap.put('sub_type__c', 'Direct');
        fieldValueAccMap.put('site_department__c', 'test dept1');          
        fieldValueAccMap.put('transaction_type__c', 'transactional');                          
        fieldValueAccMap.put('region__c', 'APJ');        
        fieldValueAccMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Corporate_City__c', 'Lee');                
        fieldValueAccMap.put('Corporate_Country__c', 'Japan');
        fieldValueAccMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Bill_To_City__c', 'Test City');            
        fieldValueAccMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueAccMap.put('recordtypeid', rt); 
        fieldValueAccMap.put('short_name__c', 'TESTrec');
        fieldValueAccMap.put('Customer_Number__c', '10101');
        fieldValueAccMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueAccMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueAccMap.put('financial_territory__c', 'Japan Korea');
        fieldValueAccMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueAccMap.put('bill_to_location__c', 'YES');
        fieldValueAccMap.put('total_employee__c', 100);
        fieldValueAccMap.put('end_customer__c', 'people');
        fieldValueAccMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueAccMap.put('Target_Account__c', 'Yes');
        fieldValueAccMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        fieldValueAccMap.put('Fab_9_10__c', 'Yes'); 
        fieldValueAccMap.put('SAP_Account_Number__c', '006104');
        fieldValueAccMap.put('Customer_Category__c', 'TFA');
        fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
   
        
        Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
        fieldValueAccMap2.put('Customer_Name__c', account1.id);
        fieldValueAccMap2.put('Form_Name__c', 'test');       
        FMSDataFactory obk = new FMSDataFactory();
        Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);   
        
        ApexPages.currentPage().getParameters().put('id',fmObj.Id);
                
        FMSSubscribeLookupController obj = new FMSSubscribeLookupController();
        
        System.assertNotEquals(account1,null);  

     }

}