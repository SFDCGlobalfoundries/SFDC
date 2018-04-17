@isTest(seeAllData=false)
private class OpportunitySendMailClass_Test{
  @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testMethod void Testopportunitychecklistmember1(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='0.Pre-Discovery';
        update optylist;
        System.assertEquals('0.Pre-Discovery',optylist[0].StageName);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember2(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='1. Discovery';
        update optylist;
        System.assertEquals('1. Discovery',optylist[0].StageName);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember3(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        system.AssertEquals('Second Source', opty.Opportunity_Sourcing_Type__c);
        List<Opportunity> optylist = [Select id,FAE_Head__c,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,AM_CP3__c,FAE_CP3__c,PLM_CP3__c ,MarketSegment_CP3__c,  stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='1. Discovery';
        optylist[0].AM_CP2__c =true;
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        //osc.checkflag1 = true;
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember4(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id,AM_CP1__c, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='0.Pre-Discovery';
        optylist[0].AM_CP1__c = true;
        update optylist;
        System.assertEquals(true,optylist[0].AM_CP1__c);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember5(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id,AM_CP1__c,FAE_CP1__c, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='0.Pre-Discovery';
        optylist[0].AM_CP1__c = true;
        optylist[0].FAE_CP1__c = true;
        update optylist;
        System.assertEquals(true,optylist[0].FAE_CP1__c);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember6(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        system.AssertEquals('Second Source', opty.Opportunity_Sourcing_Type__c);
        List<Opportunity> optylist = [Select id,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,AM_CP3__c,FAE_CP3__c,PLM_CP3__c ,MarketSegment_CP3__c,  stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='1. Discovery';
        optylist[0].AM_CP2__c =true;
        optylist[0].FAE_CP2__c=true;
        optylist[0].MarketSegment_CP2__c=true;
        optylist[0].PLM_CP2__c=true;
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        //osc.checkflag1 = true;
        Test.StopTest();  
    }
    private static testMethod void Testopportunitychecklistmember7(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        system.AssertEquals('Second Source', opty.Opportunity_Sourcing_Type__c);
        List<Opportunity> optylist = [Select id,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,AM_CP3__c,FAE_CP3__c,PLM_CP3__c ,MarketSegment_CP3__c,  stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='2. Assessment';
        optylist[0].AM_CP2__c =true;
        optylist[0].FAE_CP2__c=true;
        optylist[0].MarketSegment_CP2__c=true;
        optylist[0].PLM_CP2__c=true;
        optylist[0].AM_CP3__c=true;
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        //osc.checkflag1 = true;
        Test.StopTest();  
    }
    
    private static testMethod void Testopportunitychecklistmember8(){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id,AM_CP1__c,AM_CP2__c, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='0.Pre-Discovery';
        optylist[0].AM_CP1__c = true;
        optylist[0].FAE_CP1__c = true;
        optylist[0].AM_CP2__c=true;
        optylist[0].FAE_CP2__c=true;
        optylist[0].PLM_CP2__c =true;
        optylist[0].MarketSegment_CP2__c=true;
        update optylist;
        System.assertEquals(true,optylist[0].AM_CP1__c);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }

     private static testMethod void Testopportunitychecklistmember9(){
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Test.StartTest();   
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opty = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        List<Opportunity> optylist = [Select id,AM_CP1__c,FAE_CP1__c,AM_CP2__c, stagename from opportunity where id =: opty.id];
        
        optylist[0].StageName ='0.Pre-Discovery';
        optylist[0].AM_CP1__c = true;
        optylist[0].AM_CP2__c=true;
        optylist[0].FAE_CP1__c = true;
        update optylist;
        System.assertEquals(true,optylist[0].FAE_CP1__c);
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
    private static testMethod void Testopportunitychecklistmember10(){
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
        OpportunitySendMailClass osc = new OpportunitySendMailClass();
        osc.opportunitychecklistmember(optylist );
        Test.StopTest();   
    }
    
}