@isTest(seeAllData=false)
private class OpportunityReviewChecklist_Test{
  @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testMethod void TestOpportunityReviewChecklist1(){
		Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id,AM_CP1__c,AM_CP2__c, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='2. Assessment';
        optylist[0].AM_CP1__c = true;
		optylist[0].FAE_CP1__c = true;
        optylist[0].AM_CP2__c=true;
		optylist[0].FAE_CP2__c=true;
		optylist[0].PLM_CP2__c =true;
		optylist[0].MarketSegment_CP2__c=true;
		optylist[0].AM_CP3__c=true;
        update optylist;
        System.assertEquals(true,optylist[0].AM_CP1__c);
        OpportunityReviewChecklist osc = new OpportunityReviewChecklist();
		osc.oppId = optylist[0].id;
		osc.getopp();
        Test.StopTest();
    }
  }