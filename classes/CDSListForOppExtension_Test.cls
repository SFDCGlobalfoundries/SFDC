/* 
  @Author <Cognizant>
   @name <CDSListForOppExtension_Test>
   @CreateDate <07/09/2016>
   @Description <Test Class for CDSListForOppExtension> 
   @Version <1.0>
*/
@isTest
public class CDSListForOppExtension_Test{
    
    @TestSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
     }

   /*
   *************************************    
   @ Name -  checkTestECCNValue
   @ Description - Test ECCN Value.
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */        
    public static testMethod void checkTestECCNValue(){
     
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(thisUser){
        
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
         
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
             Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
       
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            fieldValueMap1.put('Primary_Option__c',opt1.Id);
            
            Map<String,Object> fieldValueMap2 = new Map<String,Object>();
            fieldValueMap2.put('Device_Sourcing__c','Sole Source');        
            fieldValueMap2.put('ECCN_Technology__c','3E001.&');
            fieldValueMap2.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap2);
            system.debug('--Dev1 -'+Dev1.id);
            Custom_Design__c cd = new Custom_Design__c();
            cd.Customer__c = account1.id;
            cd.CDS_Status__c = 'Draft';
            cd.Device__c = Dev1.id;
            cd.Design_System__c = 'Cu-08';
            cd.Color_ECCN__c = 'RED';
            cd.DIW_Option_Control_Number__c = opt1.id ;
            cd.DIW_Opp_Control_Number__c  = opp1.id;
            insert cd;
        
            CDS_Color_zone__c CDSCZ = new CDS_Color_zone__c();
            CDSCZ.Name = '3E001.&';
            CDSCZ.Color__c = 'RED';
            Insert CDSCZ;
            
            PageReference pageRef = Page.CDSListForOpp;
            Test.setCurrentPage(pageRef);
    
            pageRef.getParameters().put('oppId',opp1.id);
            pageRef.getParameters().put('devId',Dev1.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
            CDSListForOppExtension obj = new CDSListForOppExtension(sc);
            
            obj.checkECCNValue(); 
        }      
    }
}