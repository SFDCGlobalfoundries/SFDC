/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OppStageScheduleCtrlTest>
   @CreateDate <30/12/2016>
   @Description <Apex Test Class For BnP_OppStageScheduleCtrl>
   @Version <>
   @reference <>
 */
@isTest
Public Class BnP_OppStageScheduleCtrlTest{

    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
 Static TestMethod void OppStageScheduleCtrl() 
   {
       
        RecordType recordType = [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('CreatedDate', system.today());
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        System.debug('@@opp1'+ opp1);
        
        Test.startTest();
        opp1.Opportunity_Health__c = 'on track';
        //opp1.Product_Line__c = 'mature';
        opp1.Contract_Pricing__c = 'yes';
        opp1.End_Application_for_Opty__c = 'tablet';
        opp1.Fab_Assignment_1__c = 'fab 1';
        opp1.StageName = '3. Recommendation';
        update opp1;
        
        BnP_OppStageScheduleCtrl ctrl = new BnP_OppStageScheduleCtrl();
        ctrl.oppId=opp1.id;
        BnP_OppStageScheduleCtrl.StageWrapperClass Oppwrapper = new BnP_OppStageScheduleCtrl.StageWrapperClass();
        Oppwrapper.stage = opp1.StageName ;
        Oppwrapper.startdate = opp1.CreatedDate.format() ;
        Oppwrapper.enddate = Date.today().addDays(10).format();
        ctrl.getStageHistorylist();
        ctrl.returnFormattedDate(System.now());
        Object obj;
        ctrl.returnFormattedString(obj);
        Test.stopTest();
        
            }
       }
    }