/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 19/08/2016 
    Description: Test class for BNPTaskAssigneeLookupCtrl
*/
@isTest
public class BNPTaskAssigneeLookupCtrlTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpTaskAssigneeLookupUsrTestMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User usr = new User(Alias = 'standt', Email='bnpstandarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='bnpstandarduser@testorg.com');
        insert usr;

        Test.startTest();
        //Test.setCurrentPageReference(new PageReference('Page.BNPTaskAssigneeLookup'));
        //System.currentPageReference().getParameters().put('queryfield', 'User');
        
        PageReference tpageRef = Page.BNPTaskAssigneeLookup;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('queryfield', 'User');
        System.assertEquals( 'User',ApexPages.currentPage().getParameters().get('queryfield'));

        BNPTaskAssigneeLookupCtrl bnpTskassigneeLookup = new BNPTaskAssigneeLookupCtrl();
        bnpTskassigneeLookup.query = 'Testing';
        bnpTskassigneeLookup.runQuery();
        
        Test.stopTest() ; 
    }
    
    public static testMethod void bnpTaskAssigneeLookupGrpTestMethod(){
        Group grp = new Group();
        grp.Name = 'Test Group';
        insert grp;
        
        Test.startTest();
        //Test.setCurrentPageReference(new PageReference('Page.BNPTaskAssigneeLookup'));
        //System.currentPageReference().getParameters().put('queryfield', 'Group');
        
        PageReference tpageRef = Page.BNPTaskAssigneeLookup;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('queryfield', 'Group');
        System.assertEquals( 'Group',ApexPages.currentPage().getParameters().get('queryfield'));
        
        
        BNPTaskAssigneeLookupCtrl bnpTskassigneeLookup = new BNPTaskAssigneeLookupCtrl();
        bnpTskassigneeLookup.query = 'Testing';
        bnpTskassigneeLookup.runQuery();
        Test.stopTest() ; 
    }
    
    public static testMethod void bnpTaskAssigneeLookupUsrExpTestMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User usr = new User(Alias = 'standt', Email='bnpstandarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='bnpstandarduser@testorg.com');
        insert usr;
        
        Test.startTest();
        //Test.setCurrentPageReference(new PageReference('Page.BNPTaskAssigneeLookup'));
        //System.currentPageReference().getParameters().put('queryfield', 'User');
        
        PageReference tpageRef = Page.BNPTaskAssigneeLookup;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('queryfield', 'User');
        System.assertEquals( 'User',ApexPages.currentPage().getParameters().get('queryfield'));
        
        BNPTaskAssigneeLookupCtrl bnpTskassigneeLookupExp = new BNPTaskAssigneeLookupCtrl();
        bnpTskassigneeLookupExp.runQuery();
        
        Test.stopTest() ; 
    }
    
    public static testMethod void bnpTaskAssigneeLookupGrpExpTestMethod(){
        
        Group grp = new Group();
        grp.Name = 'Test Group';
        insert grp;
        
        Test.startTest();
        //Test.setCurrentPageReference(new PageReference('Page.BNPTaskAssigneeLookup'));
        //System.currentPageReference().getParameters().put('queryfield', 'Group');
        
        PageReference tpageRef = Page.BNPTaskAssigneeLookup;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('queryfield', 'Group');
        System.assertEquals( 'Group',ApexPages.currentPage().getParameters().get('queryfield'));
        
        BNPTaskAssigneeLookupCtrl bnpTskassigneeLookupExp = new BNPTaskAssigneeLookupCtrl();
        bnpTskassigneeLookupExp.runQuery();
        
        Test.stopTest() ; 
    }
}