/*
    Author: Sandesh Singh
    Description: This is the test class for InternalImpMapp_TriggerHelper class 
    History:
        Sandesh 24/10/2017    - code creation.
*/
@isTest
public class InternalImpMapp_TriggerHelperTest {
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
     private static Merit__c getMerit(){
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        // Overwrite default values
        MeritIndexDataFactory.createMerit(fieldValueMap1);
        return [Select Id, Name From Merit__c Limit 1];
    }
 
    private static Internal_Impersonation_Mapping__c createimpersonationRecord(){
        Internal_Impersonation_Mapping__c impr = new Internal_Impersonation_Mapping__c(Name='aA56F000000blL6', 
                                                                                  Accounts_ShortName__c ='gigalane,hideep,Fudan',
                                                                                  User_Shortname__c ='ABHITA'
                                                                                 );
        insert impr;
        return [Select Id, Name,Accounts_ShortName__c,User_Shortname__c From  Internal_Impersonation_Mapping__c Limit 1];
    }
    
   private static User createUser(){
        Profile profileId = [SELECT Id, UserLicense.Name FROM Profile 
                             WHERE UserLicense.Name = 'Salesforce'
                             AND name='System Administrator' LIMIT 1];
     	User usr = new User(LastName = 'ABHITA',
                           FirstName='JASON',
                           HCM_Login_ID__c = 'ABHITA',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'jason.liveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        return [Select Id, Name, HCM_Login_ID__c,Profile.UserLicense.Name From User WHERE Profile.UserLicense.Name ='Salesforce' LIMIT 1];
    }
    
    public static testMethod void testassignCustomerSatAccess(){
        User user = createUser();
        Merit__c merit = getMerit();
       
        Internal_Impersonation_Mapping__c intrImp = createimpersonationRecord();
        List<Merit__Share> meritShares = [Select Id From Merit__Share WHERE RowCause = 'Manual'];
          
        //validate record after creation of Impersination
		system.assert(intrImp !=null);
        system.assertEquals(meritShares.size(), 1);
     
        intrImp.Accounts_ShortName__c = 'gigalane,hideep';
        update intrImp;
        
        //validate record after update of Impersination Fudan has removed from short name
        meritShares = [Select Id From Merit__Share WHERE RowCause = 'Manual'];
        
		system.assert(intrImp !=null);
        system.assertEquals(meritShares.size(), 0);
        
    }
   
}