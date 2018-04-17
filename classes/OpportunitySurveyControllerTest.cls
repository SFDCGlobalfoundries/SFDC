/*
Type Name: OpportunitySurveyControllerTest
Author: Cognizant
Created Date: 27-March-2014
Reason: This is the Test class for Controller OpportunitySurveyController. 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
Ashwini     03302015    - Refactoring test class.
*/
@isTest(SeeAllData=false)
public class OpportunitySurveyControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
       Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);

    }

    static void CustomSettingInsert(){
        
        /********* Custom setting Insert ************/
        
        CustomerSurveySetting__c settings = CustomerSurveySetting__c.getInstance();

        if(settings == null) {
            settings = new CustomerSurveySetting__c();
            settings.Survey_Rate_0_IMG__c = 'test0';
            settings.Survey_Rate_1_IMG__c = 'test1';
            settings.Survey_Rate_2_IMG__c = 'test2';
            settings.Survey_Rate_3_IMG__c = 'test3';
            settings.Survey_Rate_4_IMG__c = 'test4';
            settings.Survey_Rate_5_IMG__c = 'test5';
            settings.Survey_Site_Logo__c = 'logo1';
            settings.Opportunity_Site_URL__c = 'http://globalfoundries.cs6.force.com/case/CaseSurvey';
            insert settings;
        }
        
        
        OpportunitySurveyFormLabel__c customSettingInadequateLabel =  New OpportunitySurveyFormLabel__c();
        
        customSettingInadequateLabel.Name = 'InadequateTech';
        customSettingInadequateLabel.Value__c =  'Inadequate Technology / Process Maturity / Packaging short fall';
        
        insert customSettingInadequateLabel;
        
        OpportunitySurveyFormLabel__c customSettingInadequateLabel2 =  New OpportunitySurveyFormLabel__c();      
        
        customSettingInadequateLabel2.Name = 'Scheduletoolate';       
        customSettingInadequateLabel2.Value__c =  'Schedule too late';     
        
        insert customSettingInadequateLabel2;
        
      }
        
    public static testMethod void OpportunitySurveyControllerTest1() {
        Test.startTest();
        CustomSettingInsert();        
        //DataUtilTest.loadEnvironmentVariables();  
         
         Account testAcct = getAccount('testing501');   
         System.assertEquals('Customer',testAcct.Account_Type__c);

        Profile p = [Select Id ,name from Profile where name = 'System Administrator'];
        System.assertnotEquals(p.name,'admin');
        List<Opportunity> OppList = new List<Opportunity>();
        
        User u1 = new User(ProfileId = p.Id,
                           Username = 'test1111' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1',
                           Email='testSurvey111@gf.com',
                           EmailEncodingKey='UTF-8',
                           Firstname='Test',
                           Lastname='User1',
                           LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US',
                           TimeZoneSidKey='America/Chicago'                                             
                          );                 
        insert u1;       
         System.assert(u1.id!=null);
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();            
            fieldValueMap.put('Name','ABC'+i); 
            fieldValueMap.put('AccountId',testAcct.id);
            fieldValueMap.put('StageName','8. Lost');
            fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
            fieldValueMap.put('Target_Process_Node__c','14XM');
            fieldValueMap.put('Market_Segment__c','Automotive');  
            fieldValueMap.put('Process_Platform__c','GF Baseline');
            fieldValueMap.put('Fab_Split__c',100);          
            fieldValueMap.put('Process_Geometry__c','0.014UM');  
            fieldValueMap.put('Process_Family__c','Super Low Power');
            fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
            fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
            fieldValueMap.put('FAE_CP2__c',True);
            fieldValueMap.put('AM_CP3__c',false);
            fieldValueMap.put('FAE_CP3__c',false);
            fieldValueMap.put('PLM_CP3__c',false);
            fieldValueMap.put('MarketSegment_CP3__c',false);
            fieldValueMap.put('Finance_Check_CP3__c',false);
            fieldValueMapList.add(fieldValueMap);
        }
      
        System.runAs (u1){ 
            OppList = OpportunityDataFactory.createOpportunities(fieldValueMapList,2);
        }
        Opportunity opp1 = OppList[0];
        Opportunity opp2 = OppList[1];
         System.assertEquals('ABC1',opp1.name);
        //Valid scenario 1 with proper data
        PageReference pageRef1 = Page.opportunitysurvey;
        Test.setCurrentPage(pageRef1); 
        apexpages.currentpage().getparameters().put('SurveyFor__c','Lost');
        apexpages.currentpage().getparameters().put('Opportunity__c',opp1.id);
        apexpages.currentpage().getparameters().put('Record_Owner__c',u1.Id);  
               
        OpportunitySurveyController controller1 = new OpportunitySurveyController();        
        OpportunitySurvey__c survey1 = controller1.getParameters();
        controller1.submitForm();
        controller1.getItems();
        controller1 = new OpportunitySurveyController(); 
        
        //Valid scenario 2 with proper data
        PageReference pageRef2 = Page.opportunitysurvey;
        Test.setCurrentPage(pageRef2); 
        apexpages.currentpage().getparameters().put('SurveyFor__c','Void');
        apexpages.currentpage().getparameters().put('Opportunity__c',opp2.id);
        apexpages.currentpage().getparameters().put('Record_Owner__c',u1.Id);  
               
        OpportunitySurveyController controller2 = new OpportunitySurveyController ();        
        OpportunitySurvey__c survey2 = controller2.getParameters();
        controller2.submitForm();
        
        //Invalid scenario with proper data
        PageReference pageRef3 = Page.opportunitysurvey;
        Test.setCurrentPage(pageRef3);        
        apexpages.currentpage().getparameters().put('SurveyFor__c','Dropped');
        OpportunitySurveyController controller3 = new OpportunitySurveyController ();        
        controller3.getParameters();        
        controller3.submitForm();
        
        Test.stopTest();
    }    
    
    /**
    This Test method is used for OpportunitySurveyExtention class.
    @method name: OpportunitySurveyExtentionTest
    
    **/
    
    public static testMethod void OpportunitySurveyExtentionTest() {
        Test.startTest();
        //DataUtilTest.loadEnvironmentVariables();     
        Account testAcct = getAccount('testing501'); 
         

        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        List<Opportunity> OppList = new List<Opportunity>();
        
        User u1 = new User(ProfileId = p.Id, Username = 'test1111' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email='testSurvey111@gf.com', EmailEncodingKey='UTF-8', Firstname='Test',
                           Lastname='User1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Chicago'                                             
                          );                 
        insert u1;        
         System.assert(u1.id!=null);
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name','ABC');  
        fieldValueMap.put('AccountId',testAcct.id);
        fieldValueMap.put('StageName','8. Lost');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');        
        fieldValueMap.put('FAE_CP2__c',True);
        //fieldValueMap.put('FAE_CP3__c',True);
        fieldValueMap.put('AM_CP3__c',false);
            fieldValueMap.put('FAE_CP3__c',false);
            fieldValueMap.put('PLM_CP3__c',false);
            fieldValueMap.put('MarketSegment_CP3__c',false);
            fieldValueMap.put('Finance_Check_CP3__c',false);              
        Opportunity opp1 = new Opportunity();   
        
        System.runAs (u1){ 
            opp1 = OpportunityDataFactory.createOpportunity(fieldValueMap);
        }
        System.assertEquals('ABC',opp1.name);
        OpportunitySurvey__c  oppSurvey = new OpportunitySurvey__c(SurveyFor__c='Lost' , Opportunity__c=opp1.Id , Record_Owner__c =u1.Id, UniqueId__c=opp1.Id);
        
        System.runAs (u1){ 
            insert oppSurvey;
        }
                
        //Valid scenario 1 with proper data
        System.runAs (u1){ 
            ApexPages.StandardController stdcontroller = new ApexPages.StandardController(opp1);
            OpportunitySurveyExtention controller = new OpportunitySurveyExtention(stdcontroller);
        }        
        
        Test.stopTest();
    }   
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name,Account_Type__c FROM Account Where Name =: AccountName];
        
                return testAcct;
            } 
}