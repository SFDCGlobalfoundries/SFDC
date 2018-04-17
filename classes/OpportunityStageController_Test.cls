@isTest(SeeAllData=false)
public class OpportunityStageController_Test {
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

     public static testMethod void opportunityStageControllerTestMethod() {
       Test.startTest();
          
        Account testAcct = getAccount('testing501'); 
        System.assertEquals('Customer',testAcct.Account_Type__c);
        Profile p = [Select Id,name from Profile where name = 'System Administrator'];
        System.assertnotEquals(p.name,'admin');
        
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
       // fieldValueMap.put('FAE_CP3__c',True);
                  
        Opportunity opp1 = new Opportunity();   
        
        System.runAs (u1){ 
            opp1 = OpportunityDataFactory.createOpportunity(fieldValueMap);
        }
        System.assertEquals('ABC',opp1.name);
        createEnvironmentalvariable();
        //Valid scenario 1 with proper data
        PageReference pageRef1 = Page.OpportunityStage;
        Test.setCurrentPage(pageRef1); 
        apexpages.currentpage().getparameters().put('id',opp1.id);
        
          ApexPages.StandardController sc = new ApexPages.StandardController(new opportunity(id=opp1.id));
        opportunityStageController controller1 = new opportunityStageController(sc);
         
        
        System.assertEquals('Lost',controller1.Stage);
        controller1.getClosedStages();
        //controller1.getReasonForLostDroppedValues();
        controller1.Next();
        
       
        Test.stopTest();
     }
     private static void createEnvironmentalvariable (){
    
        list <Environment_Variable__c> environmentalVariableList = new list <Environment_Variable__c> ();
         
        Environment_Variable__c ev1 = new Environment_Variable__c();
        ev1.Name = 'Dropped';
        ev1.Value__c ='TestDropped';
        environmentalVariableList.add (ev1);

        Environment_Variable__c ev2 = new Environment_Variable__c();
        ev2.Name = 'Dropped_v1';
        ev2.Value__c='TestDropped_V1';
        environmentalVariableList.add (ev2);
        
        Environment_Variable__c ev3 = new Environment_Variable__c();
        ev3.Name = 'Void';
        ev3.Value__c='TestVoid';
        environmentalVariableList.add (ev3);
        
         Environment_Variable__c ev4 = new Environment_Variable__c();
        ev4.Name = 'Lost';
        ev4.Value__c='TestLost';
        environmentalVariableList.add (ev4);
        
        insert environmentalVariableList;
     }
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name,Account_Type__c FROM Account Where Name =: AccountName];
        
                return testAcct;
            } 

}