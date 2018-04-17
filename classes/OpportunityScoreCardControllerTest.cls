/*
Type Name: OpportunityScoreCardControllerTest
Author: Cognizant
Created Date: 04-June-2014
Reason: This is the Test class for class OpportunityScoreCardController . 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    DBiswal     05182015    - Updated code for refactoring of test class.
 */
@isTest(SeeAllData=false)
private class OpportunityScoreCardControllerTest{
  
  @testSetup static void testdata() {
      DataUtilTest.loadEnvironmentVariables();
      
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
  }
  
  static testMethod void OpportunityScoreCardControllerTestMethod1(){
    Test.startTest();
    //DataUtilTest.loadEnvironmentVariables();
     Account accntObj = getAccount('MYTEST ACCOUNT1');
    Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        List<Opportunity> OppList = new List<Opportunity>();
        
        User u1 = new User(ProfileId = p.Id, Username = 'test1111' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email='testSurvey111@gf.com', EmailEncodingKey='UTF-8', Firstname='Test',
                           Lastname='User1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Chicago'                                             
                          );                 
        insert u1;        
               
        Opportunity opp1 = new Opportunity();
        Opportunity opp2 = new Opportunity();
        
        System.runAs (u1){ 
            
            List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>(); 
            for(integer i=1;i<=2;i++){
                Map<String,Object> fieldValueMap = new Map<String,Object>();                
                fieldValueMap.put('Name','ABC'+i);  
                fieldValueMap.put('AccountId',accntObj.id);
                fieldValueMap.put('StageName','8. Lost');
                fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
                fieldValueMap.put('Target_Process_Node__c','14XM');
                fieldValueMap.put('Market_Segment__c','Mobility');  
                fieldValueMap.put('Process_Platform__c','GF Baseline');
                fieldValueMap.put('Fab_Split__c',100);          
                fieldValueMap.put('Process_Geometry__c','0.010UM');  
                fieldValueMap.put('Process_Family__c','MEMS');
                fieldValueMap.put('FAE_CP2__c',True);
                fieldValueMap.put('FAE_CP3__c',True);
                fieldValueMapList.add(fieldValueMap);
            }
            
            OppList = OpportunityDataFactory.createOpportunities(fieldValueMapList,2);
            opp1 = OppList[0];
            opp2 = OppList[1];
        }

        PageReference pageRef1 = Page.OpportunityScoreCardWrite;
        Test.setCurrentPage(pageRef1);
        
        Opportunity_ScoreCard__c objScore = new  Opportunity_ScoreCard__c();
        objScore.Opportunity__c = opp1.Id;
        objScore.Already_Engaged_with_SEC__c = '1. Likely to lose to SEC';
        objScore.Funding_Resource__c = '2. Private <$100M';
        objScore.IP_Match__c = '1. IPs are not aligned with our current plan/target applications';
        objScore.Margins__c = '2. 20%-25%';
        objScore.Market_Leadership__c = '2. Small Player';
        objScore.Other_Business_Potential__c = '5 = Flood gates open';
        objScore.Pipeline_Cleaning_Value_Friendliness__c = '3. Can tolerate moderate amount of issues if not schedule impact';
        objScore.Strategic_Existing_Customer__c = 'Existing';
        
        pageRef1.getparameters().put('oid',opp1.id);
        pageRef1.getparameters().put('UniqueId__c',opp1.id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(objScore); 
        OpportunityScoreCardController controller1 = new OpportunityScoreCardController(sc);        
        
        controller1.getParameters();
        controller1.returnFunction();
        controller1.insertScoreCard();
        controller1.upsertScoreCard();
        controller1.updateScoreCard();
        controller1.ExportToExcel();
        controller1.ScoreCardWrite();
        
    Test.stopTest();
  }
  
  private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}