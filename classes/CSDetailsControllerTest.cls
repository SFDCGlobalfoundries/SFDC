/*********************************************************************************/
  // Purpose      : CSDetailsControllerTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 20 Sep, 2015
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : This is the test class for CSDetailsController class.  
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
@isTest(SeeAllData=false)
public class CSDetailsControllerTest{
    static Account mainAccount;
    static Contact mainContact;
    static User user;  
    /* 
        Description : Used to create sample dataset required by test methods 
    */
    private static void init() {
        
        HCM_Employee__c hcmEmployee = new HCM_Employee__c();
        hcmEmployee.Login_ID__c = 'testHCM';
        hcmEmployee.Last_Name__c = 'TestGFSysUser';
        hcmEmployee.First_Name__c = 'Test';
        hcmEmployee.Department_Name__c =  'IT';
        hcmEmployee.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmployee.Job_Title__c = 'TestTitle';
        hcmEmployee.Phone_Number__c =  '999999999';
        hcmEmployee.Employee_ID__c = 'Test5052';
        insert hcmEmployee;
        
        user = new User();
        user.ProfileID = [Select Id From Profile Where UserType=:System.Label.Standard limit 1].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@gftest.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.Phone = '9901624987';
        user.IsActive = true;
        user.FederationIdentifier='Test5052';

        insert user;     
     }
     private static testmethod void testInsertCSDetails(){
         init();
         Test.startTest();
         String userId = user.Id;
         CSforDefaultownerandteam__c csDetails =  new CSforDefaultownerandteam__c(
             Name = 'TestCS',
             Bug_Admin__c = userId.substring(0,15),
             Bug_BugTeam__c = userId.substring(0,15),
             Additional_Bug_Team__c = userId.substring(0,15),
             Bug_Component__c = 'Digital PnR',
             Bug_Owner__c = userId.substring(0,15),
             Product_affected__c = '110G'
         );
        try {
            insert csDetails;
        } catch(Exception e) {
            String errroMessage = e.getMessage();
            System.assert(errroMessage.contains('Unable to create'),e.getMessage());
        }
        CSDetailsController csDetailCon = new CSDetailsController();
        csDetailCon.newCS();
        csDetailCon.saveNew();
        csDetailCon.getParam('Test');
        csDetailCon.cancel();
        csDetailCon.cancelEdit();
        csDetailCon.saveEdit();
        csDetailCon.searchCS();
        csDetailCon.searchCSetings();
        csDetailCon.ClearAll();
        csDetailCon.first();
        csDetailCon.last();
        
        Test.stopTest();
     }
     public static testmethod void setOfInsertCSDetails() {
         init();
         Test.startTest();
         String userId = user.Id;
         CSforDefaultownerandteam__c csDetails2 =  new CSforDefaultownerandteam__c(
             Name = 'TestCS',
             Bug_Admin__c = userId.substring(0,15),
             Bug_BugTeam__c = userId.substring(0,15),
             Additional_Bug_Team__c = userId.substring(0,15),
             Bug_Component__c = 'Digital PnR',
             Bug_Owner__c = userId.substring(0,15),
             Product_affected__c = '110G'
         );
        try {
            insert csDetails2;
        } catch(Exception e) {
            String errroMessage = e.getMessage();
            System.assert(errroMessage.contains('Unable to create'),e.getMessage());
        }
        
        PageReference pageRef = Page.CSDetailsPage;
        Test.setCurrentPage(pageRef);
        CSDetailsController csDetailCon = new CSDetailsController();            
        pageRef = csDetailCon.next();
        system.assert(pageRef==null);
        pageRef = csDetailCon.previous();
        system.assert(pageRef==null);
        pageRef = csDetailCon.first();
        system.assert(pageRef==null);
        pageRef = csDetailCon.last();
        system.assert(pageRef==null);
        boolean prevChk = csDetailCon.getprev();
        boolean nextChk = csDetailCon.getnxt();
        csDetailCon.bugAdmin = userId.substring(0,15);
        csDetailCon.bugTeam = userId.substring(0,15);
        csDetailCon.bugComponent = 'Digital PnR';
        csDetailCon.bugOwner = userId.substring(0,15);
        csDetailCon.productAffected = '110G';
        
        CSDetailsController csDetailEdit= new CSDetailsController();
        ApexPages.currentPage().getParameters().put('editCsId',csDetails2.id); 
        csDetailEdit.editCS(); 
        
        CSforDefaultownerandteam__c csDetails3 = new CSforDefaultownerandteam__c();
        PageReference pageRef2 = Page.CSDetailsPage;
        Test.setCurrentPage(pageRef2);
        
        Test.stopTest();

     }
    private static testmethod void testDeleteCSDetails() {
        init();
        Test.startTest();
        
         String userId = user.Id;
         CSforDefaultownerandteam__c csDetails5 =  new CSforDefaultownerandteam__c(
             Name = 'TestCS',
             Bug_Admin__c = userId.substring(0,15),
             Bug_BugTeam__c = userId.substring(0,15),
             Additional_Bug_Team__c = userId.substring(0,15),
             Bug_Component__c = 'Digital PnR',
             Bug_Owner__c = userId.substring(0,15),
             Product_affected__c = '110G'
         );
        try {
            insert csDetails5;
        } catch(Exception e) {
            String errroMessage = e.getMessage();
            System.assert(errroMessage.contains('Unable to create'),e.getMessage());
        }
        PageReference pageRef = Page.CSDetailsPage;
        Test.setCurrentPage(pageRef);
        CSDetailsController csDetailCon = new CSDetailsController();
        pageRef = csDetailCon.next();
        system.assert(pageRef==null);
        pageRef = csDetailCon.previous();
        system.assert(pageRef==null);
        pageRef = csDetailCon.first();
        system.assert(pageRef==null);
        pageRef = csDetailCon.last();
        system.assert(pageRef==null);
        boolean prevChk = csDetailCon.getprev();
        boolean nextChk = csDetailCon.getnxt();
        csDetailCon.newCS();
        csDetailCon.saveNew();
        csDetailCon.getParam('Test');
        csDetailCon.cancel();
        csDetailCon.cancelEdit();
        csDetailCon.saveEdit();
        csDetailCon.searchCS();
        csDetailCon.searchCSetings();
        csDetailCon.ClearAll();
        csDetailCon.delCS();
        csDetailCon.getItems();
        csDetailCon.exportToExcel();
        csDetailCon.pageNavigation();
        csDetailCon.getRecordInfo();
        CSforDefaultownerandteam__c csObj = [SELECT Id,IsDeleted FROM CSforDefaultownerandteam__c where Id = :csDetails5.Id ALL ROWS];
        Test.stopTest();
    }
    private static testmethod void testSearchUser() {
        Test.startTest();
        HCM_Employee__c hcmEmployee = new HCM_Employee__c();
        hcmEmployee.Login_ID__c = 'testHCM';
        hcmEmployee.Last_Name__c = 'TestGFSysUser';
        hcmEmployee.First_Name__c = 'Test';
        hcmEmployee.Department_Name__c =  'IT';
        hcmEmployee.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmployee.Job_Title__c = 'TestTitle';
        hcmEmployee.Phone_Number__c =  '999999999';
        hcmEmployee.Employee_ID__c = 'Test1425';
        insert hcmEmployee;
        
        user = new User();
        user.ProfileID = [Select Id From Profile Where UserType=:System.Label.Standard limit 1].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'firstTest';
        user.LastName = 'lastTest';
        user.Username = 'testMe@gftest.com';   
        user.CommunityNickname = 'testUserMe123';
        user.Alias = 't1Me';
        user.Email = 'noE@email.com';
        user.Phone = '9901624987';
        user.IsActive = true;
        user.FederationIdentifier='Test1425';
        insert user;
        
        PageReference pageRef = Page.CSDetailsPage;
        Test.setCurrentPage(pageRef);
        CSDetailsController csDetailCon = new CSDetailsController();
        csDetailCon.searchStr = 'firstTest';
        csDetailCon.userSearchMethod();
        
        CSDetailsController csDetailCon1 = new CSDetailsController();
        csDetailCon1.searchStr = 'T';
        try{
            csDetailCon1.userSearchMethod();
        }catch(Exception e) {
            String errroMessage = e.getMessage();
            System.assert(errroMessage.contains('Please enter at least two characters..'),e.getMessage());
        }
        
        Test.stopTest();
    }
    private static testmethod void testSearchGroup() {
        Test.startTest();
        Group groupObj = new Group (
            Name = 'Test Group',
            Type = 'Regular'
        );
        insert groupObj;
        PageReference pageRef = Page.CSDetailsPage;
        Test.setCurrentPage(pageRef);
        CSDetailsController csDetailCon = new CSDetailsController();
        csDetailCon.searchStr = 'Test Group';
        csDetailCon.groupSearchMethod();
        
        CSDetailsController csDetailCon1 = new CSDetailsController();
        csDetailCon1.searchStr = 'T';
        try{
            csDetailCon1.groupSearchMethod();
        }catch(Exception e) {
            String errroMessage = e.getMessage();
            System.assert(errroMessage.contains('Please enter at least two characters..'),e.getMessage());
        }
        
        Test.stopTest();
    }
}