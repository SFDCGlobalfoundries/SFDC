/*Author: Karthick D
 * Description: Test Class for Bug Search controller.
 * History: Created on 07/31/2014
 */
@isTest(SeeAllData = false)
public class BugSearchTest {
    public static testmethod void createCustSetting(){
        BugErrorMessages__c setting = new BugErrorMessages__c();
        setting.Name = 'AdvBugSearchError';
        setting.Error_Message__c = 'Enter at least two alphanumeric characters to perform search.';
        insert setting;
    }
    public static testMethod void testloadbugfields() {        
        test.starttest();
        createCustSetting();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test yyyy';
        b.product_technology__c = '28LPQ-RF PDK Release';
        //b.Related_DMM_Number__c = '1234';
        insert b;
        PageReference pageRef = Page.BugSearch;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('created_by', UserInfo.getUserId());
        apexpages.currentpage().getparameters().put('owner_id', UserInfo.getUserId());
        apexpages.currentpage().getparameters().put('DMM_Number', '1234');
        apexpages.currentpage().getparameters().put('bug_title', 'test yyyy');


        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugSearch BugSearchVar = new BugSearch(controller);
        BugSearchVar.stStatus = 'New';
        BugSearchVar.stPriority = 'P1';
        BugSearchVar.stSeverity = 'Critical';
        BugSearchVar.stBugClass = 'Enhancement';
        BugSearchVar.stProduct = '28LPSe';
        BugSearchVar.stComponent = 'Apache Totem';
        BugSearchVar.stVersion = 'unspecified';
        BugSearchVar.stBugNo = 'B123';
        BugSearchVar.stBugzillaId = 'B123';

        BugSearchVar.buildQueryforFilters();
        BugSearchVar.Beginning();
        BugSearchVar.Previous();
        BugSearchVar.Next();
        BugSearchVar.End();
        Bugsearchvar.getDisablePrevious();
        Bugsearchvar.getDisableNext();
        Bugsearchvar.getTotal_size();
        Bugsearchvar.getPageNumber();
        Bugsearchvar.getTotalPages();
        Bugsearchvar.getTotalRows();
        Bugsearchvar.doSort();
        Bugsearchvar.getbugvar();
        Bugsearchvar.redirectbug(b);
        Bugsearchvar.getBugListvar();
        Bugsearchvar.ExportExcel();
        Bugsearchvar.getBugTeamVar();
        Bugsearchvar.getBugListExcelVar();
        
        Apexpages.StandardController controller1 = new Apexpages.StandardController(b);
        BugSearch BugSimulationSearchVar = new BugSearch(controller1);
        BugSimulationSearchVar.stStatus = 'New';
        BugSimulationSearchVar.stEncapsulation  = 'Mold_CUF';
        BugSimulationSearchVar.stSubstrate  = 'BU_Core';
        BugSimulationSearchVar.stInterconnect  = 'CuBoP';
        BugSimulationSearchVar.stPackage   = 'LGA';
        BugSimulationSearchVar.stSimulationType  = 'Apache Totem';
        BugSimulationSearchVar.stDieSize  = 'Large ( >12x12 mm)';
        BugSimulationSearchVar.stProductSimulation  = '10 LPP';
        BugSimulationSearchVar.stsimulationbugtitle = 'test';
        BugSimulationSearchVar.stSimulationStatus = 'New';
        BugSimulationSearchVar.stSimulationBugNo = 'B0123';
        BugSimulationSearchVar.simulationFlag  = true;

        BugSimulationSearchVar.buildQueryforFilters();
        BugSimulationSearchVar.resetTab();
        
        bug__c b2 = new bug__c();
        PageReference pageRef2 = Page.BugSearch;
        Test.setCurrentPage(pageRef2);
        Apexpages.StandardController controller2 = new Apexpages.StandardController(b2);
        BugSearch BugSearchVar2 = new BugSearch(controller2);
        BugSearchVar2.buildQueryforFilters();
        
          Case objCase = new Case(Subject='Case - Something');        
         insert objCase;
         
          Bug__c objBug = new Bug__c (Bug_Title__c='Bug - Something');

        test.stoptest();
    }

    public static testMethod void testloadbugfieldsOwnerTest() {        
        test.starttest();
        createCustSetting();
        Bug__c b = new bug__c();
        PageReference pageRef = Page.BugSearch;
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugSearch BugSearchVar = new BugSearch(controller);
        BugSearchVar.stOwner = 'Test';
        BugSearchVar.stCreatedBy = 'Test';
        BugSearchVar.stBugTitle = 'Test';
        BugSearchVar.stRelatedDmmNumber = 'New';

        BugSearchVar.buildQueryforFilters();
        BugSearchVar.Beginning();
        BugSearchVar.Previous();
        BugSearchVar.Next();
        BugSearchVar.End();
        Bugsearchvar.getDisablePrevious();
        Bugsearchvar.getDisableNext();
        Bugsearchvar.getTotal_size();
        Bugsearchvar.getPageNumber();
        Bugsearchvar.getTotalPages();
        Bugsearchvar.getTotalRows();
        Bugsearchvar.doSort();
        Bugsearchvar.getbugvar();
        Bugsearchvar.redirectbug(b);
        Bugsearchvar.getBugListvar();
        Bugsearchvar.ExportExcel();
        Bugsearchvar.getBugTeamVar();
        Bugsearchvar.getBugListExcelVar();
        test.stoptest();
    }
    public static testMethod void testAdvSerachAllString() {        
        test.starttest();
        createCustSetting();
        Bug__c b = new bug__c();
        PageReference pageRef = Page.BugSearch;
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugSearch BugSearchVar = new BugSearch(controller);
        BugSearchVar.textSearch = 'Test';
        BugSearchVar.searchstring = 'all';

        BugSearchVar.advSearch();
        BugSearchVar.BeginningAdvSearch();
        BugSearchVar.PreviousAdvSearch();
        BugSearchVar.NextAdvSearch();
        BugSearchVar.EndAdvSearch();
        Bugsearchvar.getDisablePreviousAdvSearch();
        Bugsearchvar.getDisableNextAdvSearch();
        Bugsearchvar.gettotal_SizeAdvSearchAdvSearch();
        Bugsearchvar.getPageNumberAdvSearch();
        Bugsearchvar.getTotalPagesAdvSearch();
        Bugsearchvar.getTotalRowsAdvSearch();
        Bugsearchvar.getbugvar();
        Bugsearchvar.getBugListvarAdvSearch();
        Bugsearchvar.ExportExcelAdvSearch();
        test.stoptest();
    }
    public static testMethod void testAdvSerachAnyString() {        
        test.starttest();
        createCustSetting();
        Bug__c b = new bug__c();
        PageReference pageRef = Page.BugSearch;
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugSearch BugSearchVar = new BugSearch(controller);
        BugSearchVar.textSearch = 'Test';
        BugSearchVar.searchstring = 'any';
        BugSearchVar.stQueryFilterAdvSearch ='test';
        BugSearchVar.advSearch();
        Bugsearchvar.doSortAdv();
        BugSearchVar.BeginningAdvSearch();
        BugSearchVar.PreviousAdvSearch();
        BugSearchVar.NextAdvSearch();
        BugSearchVar.EndAdvSearch();
        Bugsearchvar.getDisablePreviousAdvSearch();
        Bugsearchvar.getDisableNextAdvSearch();
        Bugsearchvar.gettotal_SizeAdvSearchAdvSearch();
        Bugsearchvar.getPageNumberAdvSearch();
        Bugsearchvar.getTotalPagesAdvSearch();
        Bugsearchvar.getTotalRowsAdvSearch();
        Bugsearchvar.getbugvar();
        Bugsearchvar.getBugListvarAdvSearch();
        Bugsearchvar.ExportExcelAdvSearch();
        test.stoptest();
    }
    public static testMethod void testAdvSerachErrorString() {        
        test.starttest();
        createCustSetting();
        try {
            Bug__c b = new bug__c();
            PageReference pageRef = Page.BugSearch;
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugSearch BugSearchVar = new BugSearch(controller);
            BugSearchVar.textSearch = 'T*';
            BugSearchVar.searchstring = 'all';
           
            BugSearchVar.advSearch();
            BugSearchVar.BeginningAdvSearch();
            BugSearchVar.PreviousAdvSearch();
            BugSearchVar.NextAdvSearch();
            BugSearchVar.EndAdvSearch();
            Bugsearchvar.getDisablePreviousAdvSearch();
            Bugsearchvar.getDisableNextAdvSearch();
            Bugsearchvar.gettotal_SizeAdvSearchAdvSearch();
            Bugsearchvar.getPageNumberAdvSearch();
            Bugsearchvar.getTotalPagesAdvSearch();
            Bugsearchvar.getTotalRowsAdvSearch();
            Bugsearchvar.doSort();           
            Bugsearchvar.getbugvar();
            Bugsearchvar.getBugListvarAdvSearch();
            Bugsearchvar.getBugListExcelVarAdvSearch();
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    }
    public static testMethod void testCreatedBySearch() {
            test.starttest();
            createCustSetting();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test yyyy';
            b.product_technology__c = '28LPQ-RF PDK Release';
            insert b;
            bug__c bug = new bug__c();
            PageReference pageRef = Page.BugSearch;
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugSearch BugSearchVar = new BugSearch(controller);
            string st = UserInfo.getUserId();
            BugSearchVar.clearFlagCheck = true;
            BugSearchVar.UserString ='test';
            BugSearchVar.SetValues();
            BugSearchVar.clearFlagCheck = false;
            BugSearchVar.SetValues();
            
            BugSearchVar.buildQueryforFilters();
            BugSearchVar.clearAll();
            System.assertequals('',BugSearchVar.createdBy);
            test.stoptest();
    }
    public static testMethod void testUserSearch() {
            test.starttest();
            List<User> sysAdmin = createUser('System Administrator');
            createCustSetting();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test yyyy';
            b.product_technology__c = '28LPQ-RF PDK Release';
            insert b;
            bug__c bug = new bug__c();
            PageReference pageRef = Page.UserSearch;
            
            Test.setCurrentPage(pageRef);
            apexpages.currentpage().getparameters().put('userSearchFlag', 'true'); 
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugSearch BugSearchVar = new BugSearch(controller);                     
            BugSearchVar.userSearchString = 'test';
            
            BugSearchVar.SearchUser();
            BugSearchVar.NextUsers();
            BugSearchVar.PreviousUsers();
            BugSearchVar.addAllUsers();
            System.assertequals(10,BugSearchVar.listUserPage.size());
            BugSearchVar.searchUserString = 'test1';
            BugSearchVar.searchUserId ='test2';
            BugSearchVar.addAllUsers();
            
            test.stoptest();
    }
    public static testMethod void testUserSearchPageLoad() {
            test.starttest();
            createCustSetting();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test yyyy';
            b.product_technology__c = '28LPQ-RF PDK Release';
            insert b;
            bug__c bug = new bug__c();
            PageReference pageRef = Page.UserSearch;
            Test.setCurrentPage(pageRef);
            string st = UserInfo.getUserId();
            apexpages.currentpage().getparameters().put('createdBy', st);   
            apexpages.currentpage().getparameters().put('userSearchFlag', 'true');          
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugSearch BugSearchVar = new BugSearch(controller);
           
            BugSearchVar.SetValues();
            System.assertequals(true,BugSearchVar.displayReadOnly);         
            test.stoptest();   

    }
    public static List<User> createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        List<user> userList = new List<User>();
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u);
        User u1 = new User(Alias = 'standt1', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u1);
        User u2 = new User(Alias = 'standt2', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing2', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser2' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');  
        userList.add(u2);
        User u3 = new User(Alias = 'standt3', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing3', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u3);  
        User u4 = new User(Alias = 'standt4', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing4', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser4' + System.now().format('MMddyyyyHHmmss') + '@testorg.com'); 
        userList.add(u4);
        User u5 = new User(Alias = 'standt5', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing5', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser5' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u5);
        User u6 = new User(Alias = 'standt6', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing6', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser6' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u6);
        User u7 = new User(Alias = 'standt7', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing7', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser7' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u7);
        User u8 = new User(Alias = 'standt8', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing8', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser8' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u8); 
        User u9 = new User(Alias = 'standt9', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing9', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser9' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u9);
        User u10 = new User(Alias = 'standt10', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing10', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser10' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u10);
        User u11 = new User(Alias = 'standt11', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing11', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser11' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        userList.add(u11); 
        insert userList;               
        return userList;
    }
}