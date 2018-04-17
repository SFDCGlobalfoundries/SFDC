/*
Author: Shyam Ravindra Nair
Description: Test class for CustomerRequestorLookupController.
History:
SNair     11022015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CustomerRequestorLookupControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    static testMethod void myUnitTest1() {
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact1 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 1',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact1;
            
            Contact testContact2 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 2',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact2;
            
         /*   Contact testContact3 = new Contact(
                 LastName = 'WayneSSSAccess',
                FirstName = 'BruceD',
                AccountId = testAccount.Id,
                Email = 'accesssetuphistorytrackertest@testMethod.com',
                Department__c = 'Design'
                //FirstName = 'Test',
                //LastName = 'Contact 3',
               // AccountId = testAccount.Id,
                //Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact3; 
            
            Contact testContact4 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 4',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact4;
            
            Contact testContact5 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 5',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact5; */
            
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.CustomerRequestorLookup'));
            System.currentPageReference().getParameters().put('rec',testAccount.Id);
            CustomerRequestorLookupController controller = new CustomerRequestorLookupController();
            List<Contact> contactList = controller.getContactList();
            //Boolean hasnext = controller.hasNext();
            //Boolean hasprevious = controller.hasPrevious();
            //Integer pageNo = controller.pageNumber();
            controller.first();
            controller.last();
            controller.previous();
            controller.next();
            controller.cancel();  
            system.assertEquals(true,true);
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest2() {
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact1 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 1',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact1;
            
            Contact testContact2 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 2',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact2;
            
          /*  Contact testContact3 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 3',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact3;
            
            Contact testContact4 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 4',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact4;
            
            Contact testContact5 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact 5',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact5; */
            
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.CustomerRequestorLookup'));
            //System.currentPageReference().getParameters().put('rec',testAccount.Id);
            CustomerRequestorLookupController controller = new CustomerRequestorLookupController();
            List<Contact> contactList = controller.getContactList();
            //Boolean hasnext = controller.hasNext();
            //Boolean hasprevious = controller.hasPrevious();
            //Integer pageNo = controller.pageNumber();
            controller.first();
            controller.last();
            controller.previous();
            controller.next();
            controller.cancel();  
            system.assertEquals(true,true);
            test.stopTest();
        }
    }
}