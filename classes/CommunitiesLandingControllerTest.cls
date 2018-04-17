/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
   Ashwini     05142015    - Updated code for making SeeAllData=false and refactoring of test class.
 */
@IsTest
public with sharing class CommunitiesLandingControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
      }
      
    /*
    Added by Cognizant (FOUNDRYVIEW - Case# 4487)--------------------- BEGIN ------------------------------------------------------------ 
    Reason: To modify the landing page of portal users the Terms and Conditions VF page which by OOTB is not supported.     
    Date: 11-MAR-2014
    */
    
    static testMethod void testCommunityTermsAndConditionsAcceptance()
    {    
       // DataUtilTest.loadEnvironmentVariables();   
        
        User admUser = [SELECT Id 
                          FROM User 
                         WHERE Profile.Name LIKE '%system admin%' AND
                               IsActive =: True 
                         LIMIT 1];
        
        Account accntObj;
        Contact conobj;
        User portalUser;
        
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser','PowerPartner','PowerCustomerSuccess','CustomerSuccess'};
        
        Profile profile1 = [SELECT Id,
                                   Name,
                                   Usertype 
                              FROM Profile 
                             WHERE Name='Customer Portal Manager Custom' AND 
                                   UserType = :'PowerCustomerSuccess' 
                             LIMIT 1];
        
        accntObj = getAccount('MYTEST ACCOUNT1');
        
        conobj = new Contact(FirstName='Param',
                             LastName='Iyer',
                             AccountId=accntObj.Id,
                             Email='portaluser@testorg.com',
                             Department__c='Design',
                             status__c='Active',
                             Login_Id__c='12',
                             is_portal_user_active__c=true
                             );           
        insert conobj;         
        
        System.runAs(admUser){
            
            portalUser = new User(ProfileId = profile1.Id,
                                  Username = 'portaluser@testorg.com',
                                  Alias = 'auser',
                                  Email='portaluser@testorg.com',
                                  EmailEncodingKey='UTF-8',
                                  Firstname='Param',
                                  Lastname='Iyer',
                                  LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US',
                                  TimeZoneSidKey='America/Chicago',
                                  ContactId=conobj.id,
                                  Portal_Login__c='abc12'
                                  
                                  );
            
            insert portalUser;
        }
        
        Community_TC__c comObj = new Community_TC__c(isActive__c=true,
                                                     TCDetail__c='Test');
        insert comObj;
        

        
        PageReference pageRef = Page.CommunitiesLanding;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        
        System.runAs(portalUser){
            
            CommunitiesLandingController controller = new CommunitiesLandingController();
            
            controller.redirectToHomePage();
            controller.redirectToLogInPage();
            
            controller = new CommunitiesLandingController();
            controller.redirectToHomePage();
            
          
             
             /* try{
             //comObj2.isActive__c = true;
             insert comObj2;
             }catch(Exception e){}*/
             //controller = new CommunitiesLandingController();
             
            /* try{
             comObj.isActive__c = true;
             update comObj;
             }catch(Exception e){}*/
            


             
             System.Debug('Static variable val ---'+ CommunitiesLandingController.IsInsertEvent);
             
           
            controller = new CommunitiesLandingController();
            controller.redirectToHomePage();
            
            /*comObj = new Community_TC__c();
            
            insert comObj;*/
        } 
        
          System.runAs(admuser){            
              
              comObj = new Community_TC__c(isActive__c=true, TCDetail__c='Test 2');            
            insert comObj;
            
            CommunitiesLandingController.IsInsertEvent=false;
           /* comObj.TCDetail__c= 'temp';
            update comObj;*/
            
            /*insert new Community_TC__c(isActive__c=true, TCDetail__c='Test 2');
            
            CommunitiesLandingController.IsInsertEvent=false;
           
            comObj.isActive__c = true;
            update comObj;*/
            
            Community_TC__c comObj2 =new Community_TC__c(isActive__c=false, TCDetail__c='Test 2');         
            insert comObj2 ;
            System.Debug('Static variable val ---'+ CommunitiesLandingController.IsInsertEvent);

            
            CommunitiesLandingController.IsInsertEvent=false;

             /*comObj2.isActive__c = true;
             update comObj2;*/
             
             /*comObj.TCDetail__c= 'test 1';
             update comObj;*/
             
             
                      try{
             comObj2.isActive__c = true;
             update comObj2;
             }catch(Exception e){}
             
             }
        
        Test.stopTest();
    }
    
    static testMethod void testCommunityTermsAndConditionsAcceptance2()
    {    User admUser = [SELECT Id 
                          FROM User 
                         WHERE Profile.Name LIKE '%system admin%' AND
                               IsActive =: True 
                         LIMIT 1];
                         
        System.runAs(admuser){            
              
            Community_TC__c  comObj = new Community_TC__c(isActive__c=true, TCDetail__c='Test 2');            
            insert comObj;
            
            
           /* comObj.TCDetail__c= 'temp';
            update comObj;*/
            
            /*insert new Community_TC__c(isActive__c=true, TCDetail__c='Test 2');
            
            CommunitiesLandingController.IsInsertEvent=false;
           
            comObj.isActive__c = true;
            update comObj;*/
            
            Community_TC__c comObj2 =new Community_TC__c(isActive__c=true, TCDetail__c='Test 2');         
            insert comObj2 ;
            
            CommunitiesLandingController.IsInsertEvent=false;
            try{
                //comObj.isActive__c = true;
                update comObj;
               }catch(Exception e){}
    
    }
    
    
    }
    

    /*Added by Cognizant (FOUNDRYVIEW - Case# 4487)--------------------- END ----------------------------------------------------------*/
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}