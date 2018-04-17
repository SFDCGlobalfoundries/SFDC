@isTest
public class Device_TriggerHelper_Version2Test {
    
  @testSetup
  static void testDataSetup(){
      DataUtilTest.loadEnvironmentVariables();  
  }
        
 static testmethod void devceTrigger(){
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            DeviceChecklistTestDataUtils.createAccountID();
            
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
            Account acc= AccountDataFactory.createAccount(fieldValueAccMap);
            
            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
    
            Opportunity_Program_Team_Member__c opTeam = new Opportunity_Program_Team_Member__c();
            opteam.Opportunity_Program__c =  oppProgId ;
            
            opteam.User__c = userinfo.getuserid();
            opteam.Team_Role__c = 'Field Application Engineer';
            opteam.Opportunity_Program_Access__c = 'Read Only';
            opteam.Device_Access__c= 'Read Only';
            opteam.Core_Team_Member__c= true;
               
            insert opteam;   
           
           Test.startTest(); 
             Device__c dev = deviceutiltest.createDevicePM(acc.Id,oppId,oppProgId);
            dev.Confidence_Level_Tapeout__c = '100';
            dev.Expose_Device_to_Customer__c = false ; 
            dev.Fab__c = 'Fab 3';
            dev.Assigned_Process_ID__c = p.Id;
            dev.Enabled_via_previous_MPW_1__c='No';
            dev.CRMDID__c = '123456';
            insert dev;
            List<Id> devIdList = new List<Id>();
            devIdList.add(dev.id);
            update dev; 
            Device_TriggerHelper_Version2.deviceUpate(devIdList);
            
            
            
             Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Form_Name__c = 'testSubForm';
            fmsRec.State_of_the_Form__c = 'Draft';
            fmsRec.Customer_Name__c = acc.id;
           
            fmsRec.ProductName__c = 'test';
            fmsRec.ProductRevision__c = 'Test';
            fmsRec.IMCProjectedTapeout__c = Date.valueOf(Date.newInstance(2016, 10, 11));
            fmsRec.Waivers__c = 'Yes';
            fmsRec.IMCMaskLevelsImpacted__c = 'Test';
            fmsRec.ListOfMasksReused__c = 'Test';
            fmsRec.NewMarkingInfo__c = 'Yes';
            fmsRec.OverrideParentOptions__c = 'Yes';
            fmsRec.DataCheckingOptions__c = 'Full';
            fmsRec.ServiceOptions__c = 'None';
            fmsRec.Deliverable__c = 'yes';
            fmsRec.IMCOtherComments__c = 'Test';
            fmsRec.ParentChangesIdentified__c = 'Yes';
            fmsRec.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
            fmsRec.NumOfUniqDesigns__c = 'Yes';
            fmsRec.IMCInputMethod__c = 'Standard Process: Inputs via Reticle Layout attachment';
            
            fmsRec.IMCNumOfDesigns__c = 10;
            fmsRec.IMCNumOfFEOLDesigns__c = 10;
            fmsRec.IMCNumOfBEOLDesigns__c = 10;
            fmsRec.TechFeatureRemoval__c = 'No';
            fmsRec.Device__c = dev.Id;
            Insert fmsRec;
 }
}

}