/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: Return Material Authorization
* Description: This is a test class for RMA_communityViewCtrl
* History:
*    SurendranadhNune 22032016    -    Created.
**/
@isTest(seeAllData=false)
private class RMA_CommunityViewCtrlTest {
    
    @TestSetup
    static void loadTestData(){
        DataUtilTest.loadEnvironmentVariables();
        Account a = RMA_testDataUtility.createAccount();
            
    }
    static testmethod void testRMA_CommunityViewCtrl(){
        
        test.startTest();
            UserRole role1 = [select id from UserRole where PortalType = 'None' limit 1];
            Account acc = [select id from account limit 1];
            Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = acc.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
            insert con;
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin' limit 1];
            
            User u = [select id from User where UserRoleId != NULL and ProfileId = :profile1.Id and isActive = True limit 1];
            RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc);     
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc);
            
            system.runAs(u){                
                    Test.setCurrentPage(Page.RMA_CommunityView);
                    ApexPages.currentPage().getParameters().put('id', rmaRec.id);
                    RMA_CommunityViewCtrl commViewCtrl = new RMA_CommunityViewCtrl();
            }
		test.stopTest();
    }
}