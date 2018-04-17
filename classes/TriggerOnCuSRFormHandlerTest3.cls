/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRForm trigger.
History:
SNair     04052015     - code creation
*/
@isTest(SeeAllData=false)
public class TriggerOnCuSRFormHandlerTest3 {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod4(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            insert teamProxyList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            test.startTest();
            testCuSRForm.Any_Cost_Impact__c = 'Yes';
            testCuSRForm.PM_Comments__c = 'Sample';
            testCuSRForm.Status__c = 'Pending PM Review';
            update testCuSRForm;
            
            testCuSRForm.PM_Approved__c = true;
            testCuSRForm.PM_Approved_By__c = pmUser.Id;
            testCuSRForm.PM_Approved_On__c = Date.newInstance(2015,1,31);
            test.stopTest();
        }
    }
}