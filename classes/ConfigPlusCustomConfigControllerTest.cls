/**
 *  Class:      ConfigPlusCustomConfigurationControllerTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:     Anirban Roy
 * Description: This class is the test class for ConfigPlusCustomConfigurationController.
 *
 *
 * History:
 *           ARoy          11272015     - code creation.
 */
@isTest(SeeAllData = False)
private class ConfigPlusCustomConfigControllerTest {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    // Test Method for Custom Configurator Plus Controller with a recommended PT
    static testMethod void configPlusCustomConfigTestMethod1() {
        //Setup the related records for Roadmap feature Controller Test.
        Process_Technology__c TestPT = createPT() ; 
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(TestPT,'PT00045');
        Test.startTest();
            PageReference pageRef = Page.ConfigPlusCustomConfiguration;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', ConfigPlusRec.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(ConfigPlusRec);                
        
            ConfigPlusCustomConfigurationController CustomConfigController = new ConfigPlusCustomConfigurationController(sc);      
            PageReference pgr = CustomConfigController.setFieldVisibility();
            system.assert(pgr==null);
            
            pgr = CustomConfigController.saveValue();
            system.assert(pgr.getUrl().contains(ConfigPlusRec.id));
            
        Test.stopTest();
    }
    
    // Test Method for Custom Configurator Plus Controller with PT = 'Others'
    static testMethod void configPlusCustomConfigTestMethod2() {
        //Setup the related records for Roadmap feature Controller Test.
        Process_Technology__c TestPT = createPT() ; 
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(TestPT,'Others');
        Test.startTest();
            PageReference pageRef = Page.ConfigPlusCustomConfiguration;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', ConfigPlusRec.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(ConfigPlusRec);                
        
            ConfigPlusCustomConfigurationController CustomConfigController = new ConfigPlusCustomConfigurationController(sc);      
            PageReference pgr = CustomConfigController.setFieldVisibility();
            system.assert(pgr==null);
            
            pgr = CustomConfigController.saveValue();
            system.assert(pgr.getUrl().contains(ConfigPlusRec.id));
            
        Test.stopTest();
    }
    
    
    //Static method to create Configurator Plus  test record
    static Apttus_Proposal__Proposal__c createConfiguratorPlus(Process_Technology__c PTNumber, String ptName){
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
                                                     RecordTypeId = recType.Id ,
                                                     Process_Technology_Lookup__c = PTNumber.id,
                                                     Process_Technology_Name_1__c = ptName
                                                     );
        
        insert ConfiguratorPlus;
        return ConfiguratorPlus;
    }
    
    
    //static method to create process technology
    static Process_Technology__c createPT(){
      Process_Technology__c TempPT = new Process_Technology__c(Name = 'PTXXX01' , PT_Number__c='PTXXX01');
      insert TempPT;
      return TempPT ; 
    }
}