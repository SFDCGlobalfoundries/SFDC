/**
 *  Class:      ConfigPlusRoadmapFeatureControllerTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Prosenjit Saha
 * Description: This class contains unit tests for validating the behavior of Apex classes
 *              and triggers.
 *              Class: ConfigPlusRoadmapFeatureViewController , ConfigPlusRoadmapFeatureController
 *
 *
 * History:
 *              PSaha          09212015     - code creation.
 */
@isTest(seeAllData = False)
private class ConfigPlusRoadmapFeatureControllerTest {
	@testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    static testMethod void configPlusRoadmapTestMethod() {
        //Setup the related records for Roadmap feature Controller Test.
        Process_Technology__c TestPT = createPT() ; 
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(TestPT); 
        createConfigPlusQustion(TestPT);
        Test.startTest();
            PageReference pageRef = Page.ConfigPlusRoadmapFeature;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', ConfigPlusRec.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(ConfigPlusRec);                
        
            ConfigPlusRoadmapFeatureController RoadMapController = new ConfigPlusRoadmapFeatureController(sc);      
            RoadMapController.saveResponse();  
            RoadMapController.cancelResponse();
            
        Test.stopTest();        
    }
    
    static testMethod void configPlusRoadmapeViewTestMethod() {
        //Setup the related records for Roadmap feature Controller Test.
        Process_Technology__c TestPT = createPT() ; 
        Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(TestPT); 
        createConfigPlusQustion(TestPT);
        Test.startTest();
            PageReference pageRef = Page.ConfigPlusRoadmapFeatureView;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', ConfigPlusRec.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(ConfigPlusRec);                
        
            ConfigPlusRoadmapFeatureViewController RoadMapViewController = new ConfigPlusRoadmapFeatureViewController(sc);      
            
        Test.stopTest();        
    }
    
    //static method to create Configurator Plus Questions
    static List<Configurator_Plus_Question__c> createConfigPlusQustion(Process_Technology__c TempPT){
        List<Configurator_Plus_Question__c> FinalQstnList = new List<Configurator_Plus_Question__c>();
        List<String> RoadmapQstnTypes = new List<String>{'Roadmap Devices','Roadmap IP Design Kits','Roadmap Packaging options','Roadmap Metal Stacks'};
        for(String QstType : RoadmapQstnTypes){
            Configurator_Plus_Question__c TempNewQstn = new Configurator_Plus_Question__c(  Active__c = TRUE 
                                                                                            , Data_Type__c = 'Checkbox'
                                                                                            , Question_Type__c = QstType
                                                                                            , Process_Technology__c = TempPT.id
                                                                                            , Question_Name__c = 'Test Qstn');
            FinalQstnList.add(TempNewQstn); 
        }
        insert FinalQstnList; 
        return FinalQstnList ; 
    }
    
    //Static method to create Configurator Plus  test record
    static Apttus_Proposal__Proposal__c createConfiguratorPlus(Process_Technology__c PTNumber){
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
                                                     Process_Technology_Lookup__c = PTNumber.id ,
                                                     Process_Technology__c = PTNumber.name
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