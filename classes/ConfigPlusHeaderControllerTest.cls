/**
 *  Class:      ConfigPlusHeaderControllerTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Prosenjit Saha
 * Description: This class contains unit tests for validating the behavior of ConfigPlusHeaderController class
 *
 *
 * History:
 *              PSaha          09212015     - code creation.
 */
@isTest(seeAllData = False)
private class ConfigPlusHeaderControllerTest{
	@testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    static testMethod void configPlusHeaderControllerTestMethod() {
         test.starttest();
            Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(); 
            PageReference pageRef = new PageReference ('/apex/ConfigPlusHeader?Id=' + ConfigPlusRec.id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController abc = new ApexPages.StandardController(ConfigPlusRec);
            ConfigPlusHeaderController testController = new ConfigPlusHeaderController (abc);
        test.stoptest();
    }
      //Static method to create Configurator Plus  test record
    static Apttus_Proposal__Proposal__c createConfiguratorPlus(){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c ConfiguratorPlus = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                    /*Mask_Set__c = 'AB,CD, DA', changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = 'AB,CD, DA',
                                                     RecordTypeId = recType.Id 
                                                     );
        
        insert ConfiguratorPlus;
        return ConfiguratorPlus;
    }
}