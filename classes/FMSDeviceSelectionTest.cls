/*
 @class: FMSDeviceSelectionTest
 @CreatedBy: Ram Rai
 @CreatedDate: 28 Sep, 2016
 @Description: to test Device Selection Functionality
 @Modifications-
    ** Ram Rai      03/07/2017    Changed the logic of test classes according code review Comments
 */
@isTest(SeeAllData = false)
public class FMSDeviceSelectionTest {

  @testSetup
  static void testDataSetup(){
      DataUtilTest.loadEnvironmentVariables();       
  }
           
    static testMethod void testMethod1() {
        
        PageReference pageRef = Page.FMSDeviceSelectionPage;            
        Test.setCurrentPage(pageRef);
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
      System.runAs(admin){
      IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
      insert skipUser; 
      
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
        fieldValueAccMap.put('SAP_Account_Number__c', '016133');
        fieldValueAccMap.put('Customer_Category__c', 'TFA');
        fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
        Account acc;
        try{
            acc= AccountDataFactory.createAccount(fieldValueAccMap);
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        Account_Hierarchy__c accH = new Account_Hierarchy__c(Account_Id__c=acc.Id,Parent_Id__c=acc.Id);
        try{
            insert accH;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', acc.id);
        Opportunity opp1;
        try {
            opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        } 
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',acc.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        try{
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Account__c', acc.id);
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        fieldValueMap1.put('Device_Mask_Set_Title__c','MPW');
        fieldValueMap1.put('Fab__c','FAB 9');
        
        Device__c Dev = new Device__c ();
        Test.startTest();
        try{
            Dev = DeviceDataFactory.createDevice(fieldValueMap1);
        }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }           
        Test.stopTest(); 
 
             Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
            fieldValueAccMap2.put('Customer_Name__c', acc.id);
            fieldValueAccMap2.put('Form_Name__c', 'test');
            fieldValueAccMap2.put('Device__c', dev.Id);
            Form_Management_System__c  formObj;
            try{
                formObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);           
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceSelectionTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        } 
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
             
            FMSDeviceSelection obj = new FMSDeviceSelection();
            System.runAs(FMSDataFactory.testUser){
            obj.contW();
            obj.canCel();
            FMSDeviceSelection.wrapperClass wrpClass= new FMSDeviceSelection.wrapperClass(dev);
              wrpClass.checkDevice = true;
            obj.wrapperList.add(wrpClass);
            System.assertEquals(formObj.Form_Name__c,'test');   
            }                        
         
      }
    }
    
}