/**
   @Author <Cognizant Technology Solutions>
   @name <BNPTRCloneCtrl_Test>
   @CreateDate <05/10/2016>
   @Description <Apex Test Class For BNPTRCloneCtrl>
   @Version <>
   @reference <>
 */
@isTest
public Class BNPDeviceGapUtilities_Test
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    Static TestMethod void BNPCreateOppIssue()
    {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
             opp1.StageName = '2. Assessment';
            ////testOppty.FAE_CP2__c = True;
            ////testOppty.FAE_CP3__c = True; 
            update opp1;
         
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            // Create the Opportunity Issue
            List <Device_Gap__c> opportunityIssueList = new List <Device_Gap__c> ();
            Device_Gap__c dg = new Device_Gap__c();
            dg.Issue_Comments__c = 'Price Too High';
            dg.Area__c = 'Price';
            dg.Improve_Prob__c = 20;
            dg.Need_by_Date__c = Date.Today().addMonths(1);
            dg.Select_Status__c = 'R3 - Help Requested from Council';
            dg.Stage__c = 'New';
            dg.Opportunity__c = opp1.Id;
            dg.Opportunity_Program__c = oppprogram.Id;
            
            opportunityIssueList.add (dg);
            
            Device_Gap__c dg1 = new Device_Gap__c();
            dg1.Issue_Comments__c = 'Price Too High 2';
            dg1.Area__c = 'Price';
            dg1.Improve_Prob__c = 20;
            dg1.Need_by_Date__c = Date.Today().addMonths(1);
            dg1.Select_Status__c = 'G - Major Issue. Action in Place, High Conf of Closure. Date Not in Critical Path';
            dg1.Stage__c = 'New';
            dg1.Opportunity__c = opp1.Id;
            dg1.Opportunity_Program__c = oppprogram.Id;
            
            opportunityIssueList.add(dg1);
            
            Test.startTest();
            insert opportunityIssueList;           
            DeviceGapUtilities.updateOpportunityStatus(opportunityIssueList, true);
            DeviceGapUtilities.getOppToOppProgMap(opportunityIssueList);
            Test.stopTest();                                 
        }
    } 
}