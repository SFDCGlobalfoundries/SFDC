/**
 *  Class:      ConfigPlusHeaderComponentCntrlTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Prosenjit Saha
 * Description: This class contains unit tests for validating the behavior of ConfigPlusHeaderComponentCntrl class
 *
 *
 * History:
 *              PSaha          09212015     - code creation.
 */
@isTest(seeAllData = False)
private class ConfigPlusHeaderComponentCntrlTest{
  @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    static testMethod void configPlusHeaderTestMethod1() {
        //Setup the related records for Roadmap feature Controller Test.
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus('PT999','Pending');
        ApexPages.currentPage().getParameters().put('id',ConfigPlusRec.Id);        
        ConfigPlusHeaderComponentCntrl  ControllerTest = new ConfigPlusHeaderComponentCntrl ();
        String TestVariable ;
        TestVariable = ControllerTest.ConfigPlusStep;
        TestVariable = ControllerTest.ConfigPlusAdditionalStep ; 
        TestVariable = ControllerTest.ConfigPlusApprovalStep ;
        TestVariable = ControllerTest.ConfigPlusApproved ;
        ControllerTest.back();
    }
    static testMethod void configPlusHeaderTestMethod2() {
        //Setup the related records for Roadmap feature Controller Test.
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus('NULL','Pending');
        ApexPages.currentPage().getParameters().put('id',ConfigPlusRec.Id);        
        ConfigPlusHeaderComponentCntrl  ControllerTest = new ConfigPlusHeaderComponentCntrl ();
        String TestVariable ;
        TestVariable = ControllerTest.ConfigPlusStep;
        TestVariable = ControllerTest.ConfigPlusAdditionalStep ; 
        TestVariable = ControllerTest.ConfigPlusApprovalStep ;
        TestVariable = ControllerTest.ConfigPlusApproved ;
        ControllerTest.back();
    }
    
    static testMethod void configPlusHeaderTestMethod3() {
        //Setup the related records for Roadmap feature Controller Test.
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus('NULL','Draft');
        ApexPages.currentPage().getParameters().put('id',ConfigPlusRec.Id);        
        ConfigPlusHeaderComponentCntrl  ControllerTest = new ConfigPlusHeaderComponentCntrl ();
        String TestVariable ;
        TestVariable = ControllerTest.ConfigPlusStep;
        TestVariable = ControllerTest.ConfigPlusAdditionalStep ; 
        TestVariable = ControllerTest.ConfigPlusApprovalStep ;
        TestVariable = ControllerTest.ConfigPlusApproved ;
        ControllerTest.back();
    }
    
     //Static method to create Configurator Plus  test record
    static Apttus_Proposal__Proposal__c createConfiguratorPlus(String PTName, String ApprovalStage){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c ConfiguratorPlus = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Process_Technology_Name_Edit__c = PTName=='NULL'? NULL : PTName ,
                                                     Mask_Set_Long__c = 'AB,CD, DA',
                                                     //Mask_Set__c = 'AB,CD, DA',
                                                     //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463                                                     
                                                     RecordTypeId = recType.Id ,
                                                     Apttus_Proposal__Approval_Stage__c = ApprovalStage == 'NULL'? NULL : ApprovalStage 
                                                     );
        
        insert ConfiguratorPlus;
        return ConfiguratorPlus;
    }
}