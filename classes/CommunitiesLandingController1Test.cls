/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
   
 */
@IsTest public with sharing class CommunitiesLandingController1Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    @IsTest(SeeAllData=false)
    static void testCommunityTermsAndConditionsAcceptance(){
        
         User admUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
         System.runAs(admUser){
             CommunitiesLandingController1 clc = New CommunitiesLandingController1();
             clc.redirectToHomePage();
             clc.redirectToLogInPage();
             
             Account accntObj = new Account(name ='acc',
                                   Site_Department__c='Site1',
                                   Sub_Type__c='Direct',
                                   Transaction_Type__c='Transactional',
                                   Region__c='APJ',
                                   Bill_To_Address_1__c='New Bill',
                                   Bill_To_City__c='city1',
                                   Bill_To_Country__c='Austria',
                                   Corporate_Address_1__c='',
                                   Corporate_City__c='city1',
                                   Corporate_Country__c='Austria');                            
            insert accntObj; 
            
            Contact conobj = new Contact(FirstName='Param',
                                 LastName='Iyer',
                                 AccountId=accntObj.Id,
                                 Email='portaluser@testorg.com',
                                 Department__c='Design',
                                 status__c='Active',
                                 Login_Id__c='abc12',
                                 is_portal_user_active__c=true
                                 );           
            insert conobj; 
            Profile profile1 = [SELECT Id FROM Profile WHERE Name='Overage Customer Portal Admin'];

             User portalUser = new User(ProfileId = profile1.Id,
                                  Username = 'portaluser@testorg.com',
                                  Alias = 'cusernov',
                                  Email='portaluser@testorg.com',
                                  EmailEncodingKey='UTF-8',
                                  Firstname='Param',
                                  CommunityNickname='portaluser11022016',
                                  Lastname='Iyer',
                                  LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US',
                                  TimeZoneSidKey='America/Chicago',
                                  ContactId=conobj.id,
                                  Portal_Login__c='abc12'
                                  
                                  );
              insert portalUser;
              
              system.runAs(portalUser){
                   CommunitiesLandingController1 clcasPortaluser = New CommunitiesLandingController1();
                   clcasPortaluser.redirectToHomePage();
                   clcasPortaluser.redirectToLogInPage();
                   CommunitiesLandingController1.runOnce();
              }
         }
    }  
}