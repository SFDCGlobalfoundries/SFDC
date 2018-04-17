/*
    Description: Class contains test data
*/
@isTest
public class DesignCollaboratorTestData {
    
    public static void getGroupTestData(String gpDeveloperName, String gpName) {
        
        Group gP = new Group();
        gp.DeveloperName = gpDeveloperName;//'DFM_PI_YE_4_FAB7';
        gp.Name = gpName;//'DFM PI YE 4 FAB7';
        
        insert gP;
        
        getGroupMemberTestData(gP.Id);
    }
      
    public static void getGroupMemberTestData(Id gPId) {
        
        GroupMember gPMem = new GroupMember();
        gPMem.GroupId = gPId;
        gPMem.UserOrGroupId = [Select Id from User where IsActive = true LIMIT 1].Id;
                
        if (Test.isRunningTest()) {
                System.runAs(new User(Id = Userinfo.getUserId())) {
                insert gPMem;
            }
        } else {
            insert gPMem;
        }
    }
    
    public static List<Progress_Bar__c> getProgressBarData() {
        
        List<Progress_Bar__c> progBarList =  new List<Progress_Bar__c>();
        
        Progress_Bar__c progBar = new Progress_Bar__c();
        progBar.Name = 'PENDING_DFM';
        progBar.Status_Image__c = '/1.png';     
        insert progBar;     
        progBarList.add(progBar);
        
        Progress_Bar__c progBar1 = new Progress_Bar__c();
        progBar1.Name = 'INITIATED';
        progBar1.Status_Image__c = '/2.png';    
        insert progBar1;    
        progBarList.add(progBar1);
        
        Progress_Bar__c progBar2 = new Progress_Bar__c();
        progBar2.Name = 'CUST_PENDING';
        progBar2.Status_Image__c = '/3.png';    
        insert progBar2;    
        progBarList.add(progBar2);
        
        Progress_Bar__c progBar3 = new Progress_Bar__c();
        progBar3.Name = 'CUST_CLOSED';
        progBar3.Status_Image__c = '/4.png';    
        insert progBar3;    
        progBarList.add(progBar3);
        
        Progress_Bar__c progBar4 = new Progress_Bar__c();
        progBar4.Name = 'DFM_SIMPLIFIED_CLOSED';
        progBar4.Status_Image__c = '/5.png';    
        insert progBar4;    
        progBarList.add(progBar4);
        
        Progress_Bar__c progBar5 = new Progress_Bar__c();
        progBar5.Name = 'PENDING_FAE';
        progBar5.Status_Image__c = '/6.png';    
        insert progBar5;    
        progBarList.add(progBar5);
        
        Progress_Bar__c progBar6 = new Progress_Bar__c();
        progBar6.Name = 'PENDING_CUSTOMER';
        progBar6.Status_Image__c = '/7.png';    
        insert progBar6;    
        progBarList.add(progBar6);
        
        Progress_Bar__c progBar7 = new Progress_Bar__c();
        progBar7.Name = 'CUSTOMER_OP1_ClOSED';
        progBar7.Status_Image__c = '/8.png';    
        insert progBar7;    
        progBarList.add(progBar7);
        
        Progress_Bar__c progBar8 = new Progress_Bar__c();
        progBar8.Name = 'CUSTOMER_OP2_DFM_TO_UPDATE';
        progBar8.Status_Image__c = '/9.png';    
        insert progBar8;    
        progBarList.add(progBar8);
        
        Progress_Bar__c progBar9 = new Progress_Bar__c();
        progBar9.Name = 'CUSTOMER_OP2_ClOSED';
        progBar9.Status_Image__c = '/10.png';       
        insert progBar9;    
        progBarList.add(progBar9);
        
        Progress_Bar__c progBar10 = new Progress_Bar__c();
        progBar10.Name = 'PENDING_FOUNDRY';
        progBar10.Status_Image__c = '/11.png';      
        insert progBar10;       
        progBarList.add(progBar10);
        
        Progress_Bar__c progBar11 = new Progress_Bar__c();
        progBar11.Name = 'FOUNDRY_OP3_DFM_USER_UPDATE';
        progBar11.Status_Image__c = '/12.png';      
        insert progBar11;       
        progBarList.add(progBar11);
        
        Progress_Bar__c progBar12 = new Progress_Bar__c();
        progBar12.Name = 'FOUNDRY_OP3_CLOSED';
        progBar12.Status_Image__c = '/13.png';      
        insert progBar12;       
        progBarList.add(progBar12);
        
        Progress_Bar__c progBar13 = new Progress_Bar__c();
        progBar13.Name = 'FOUNDRY_OP3_REJECTED_BY_DE';
        progBar13.Status_Image__c = '/14.png';      
        insert progBar13;       
        progBarList.add(progBar13);
        
        return progBarList;
    }
    
    public static Map<String,String> getProgressBarMap (List<Progress_Bar__c> progBarDataList) {
        
        Map<String,String> mapOfpBarStatusImgs = new Map<String,String>();
        
        for(Progress_Bar__c pBar : progBarDataList) {
            mapOfpBarStatusImgs.put(pBar.Name, pBar.Status_Image__c);
        }
        
        return mapOfpBarStatusImgs;
    }
    
    
    public static List<User> getUserTestData() {
        
        List<User> userList = [Select Id, FederationIdentifier from User where IsActive = true AND UserRoleId != null AND Profile.Name = 'GF PIYE Platform' LIMIT 2];
        
        return userList;
        
    }
    
    /*public static Id createAccount() {
    
        RecordType rt =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        
        Account testAcct = new Account();
        testAcct.OwnerId = thisUser.Id;
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        insert testAcct;
        
        return testAcct.Id;
    }
    
    public static Id createContact(Id accountId) {
    
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = accountId;
        con.Email = 'test1@test.com';
        con.Department__c='Design';
        insert con;  
        
        return con.Id;
    }*/
    
    public static User createPortalUser() {
             
        List<User> user = [Select Id from User where IsActive = true AND UserRoleId != null AND Profile.Name = 'Customer Portal Profile' LIMIT 1];
       /* Profile p = [Select Id,Name from Profile where Name = 'Customer Portal Admin' limit 1];
        
        User u = new User();
        u.LastName = 'LastName';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        u.Portal_login__c = 'xyz';
        u.ContactId = contactId;
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        insert u;*/
        
        if(user == null || user.isEmpty()) {
            
            user = [Select Id, FederationIdentifier from User where IsActive = true AND UserRoleId != null AND Profile.Name = 'GF PIYE' LIMIT 1];
        }
        
        return user.get(0);
    }
    
    public static Account getAccountTestData() {
        
        Account account = new Account();
        account.Name = 'Test Account' + System.now();
        account.Short_Name__c = 'testacc12345';
        account.RecordTypeId = [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'].id;
        account.Site_Department__c = 'Test' + System.now();
        account.Sub_Type__c = 'Test';
        account.Transaction_Type__c = 'Test';
        account.Region__c = 'US';
        account.Corporate_Address_1__c = 'Test Address';
        account.Corporate_City__c = 'Test City';
        account.Corporate_Country__c = 'India';
        account.Bill_To_Address_1__c = 'Test Address Bill 1';
        account.Bill_To_City__c = 'Test Bill City';
        account.Bill_To_Country__c = 'India';
        
        insert account;
        return account;
    }
    
    public static List<Account_Team_Proxy__c> getAccountTeamTestData(Id accountId, Id userId, Id userId1) {
        
        List<Account_Team_Proxy__c> accTeamList = new List<Account_Team_Proxy__c>();
        
        Account_Team_Proxy__c accTeam = new Account_Team_Proxy__c();
        accTeam.Account__c = accountId; 
        accTeam.User__c = userId;
        accTeam.Team_Role__c = 'Account Manager';
        accTeam.Account_Access__c = 'Read/Write';
        accTeam.Opportunity_Access__c = 'Read/Write';
        accTeamList.add(accTeam);
        
        Account_Team_Proxy__c accTeam1 = new Account_Team_Proxy__c();
        accTeam1.Account__c = accountId;    
        accTeam1.User__c = userId1;
        accTeam1.Team_Role__c = 'Primary Field Application Engineer';
        accTeam1.Account_Access__c = 'Read/Write';
        accTeam1.Opportunity_Access__c = 'Read/Write';
        accTeamList.add(accTeam1);
                
        insert accTeamList; 
        return accTeamList;
    }
    
   public static Wavier_Collaborator__c getWaiverCollaborator(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
       waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        return waiverColl;
    }
    
      public static Wavier_Collaborator__c getWaiverCollaboratordata(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
      //  waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCTemplate5(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.Account_Short_Name__c='acc1';
        waiverColl.Mask_Set_Title__c='MPWTEST';
        insert waiverColl;
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator8(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.DFM_Transaction_Id__c = 'PTSR-XXXX-000';
        waiverColl.FAB__c = '8';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.DFM_Design_Type__c = 'DFM Design';
        waiverColl.DFMServiceOption__c = 'DFM Service Option';
        waiverColl.Account_Short_Name__c='acc1';
        waiverColl.Revert_Collaborator__c = true;
        insert waiverColl;
        system.debug('DFMId'+waiverColl.DFM_Transaction_Id__c);
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator1(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
       waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }
    
   
    
     public static Wavier_Collaborator__c getWaiverCollaborator9(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '9';
       waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator4DRC(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }

    
    public static Wavier_Collaborator__c getWaiverCollaborator0() {     
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.isAllPartyApproved__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator1() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.IsCustomerAcceptsRisk__c = true;
        waiverColl.PTSR_Number__c = '6473783';
        waiverColl.FAB__c = '7';
        waiverColl.Account_Short_Name__c = 'testacc';
        
        insert waiverColl;
        return waiverColl;
    }
    
      public static Wavier_Collaborator__c getWaiverCollaboratorDRCRequest() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.IsCustomerAcceptsRisk__c = true;
        waiverColl.PTSR_Number__c = '6473783';
        waiverColl.FAB__c = '7';
        waiverColl.Account_Short_Name__c = 'testacc';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator2() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.IsCustomerAgreeToFix__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator3() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator4(Id userId, Id deviceId, Id accId) { 
             
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Account_Manager_Approver1__c = userId;
        waiverColl.Account__c = accId;
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.CRM_Device__c = deviceId;
        waiverColl.PTSR_Number__c = 'PTSRTestingData1';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator5(String fedInde1, String fedInde2) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account_Short_Name__c = 'testacc';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator6(String fedInde1, String fedInde2) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator7() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Waiver_Status__c = 'Open';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator8() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator81() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator82() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '8';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'CHIP';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator83() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '9';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator84() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '7';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator85() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator86() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'WAF';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator87() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '7';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator88() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '8';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator89() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '9';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Design';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator9() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.IsGfAcceptsRisk__c = false;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator10() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.Is_Submit_4_DFM_Apprval__c=True;
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator11() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.Account_Short_Name__c = 'testacc';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator12() { 
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.Account_Manager_Approver1__c = null;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Attachment getAttachmentTestData(Id waiverCollId) {
        
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = waiverCollId;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        insert attachment;
        return attachment;
    }
    
    public static Opportunity getOppTestData(Id accId) {
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.AccountId = accId;
        opp.StageName = '1. Discovery';
        opp.CloseDate = Date.Today().addDays(10);
        opp.Target_Process_Node__c = '14XM';
        opp.Market_Segment__c = 'Mobility';
        opp.Process_Platform__c = 'GF Baseline';
        opp.Fab_Split__c = 100;
        opp.Process_Family__c = 'Super Low Power';
        opp.Process_Geometry__c = '0.028UM';
        
        insert opp;
        return opp;
    }
    
    public static Opportunity_Program__c getOppProgTestData(Id accId,Id oppId) {
        
        Opportunity_Program__c oppProgram = new Opportunity_Program__c();
        oppProgram.Name = 'Test Opportunity Program';
        oppProgram.Account__c = accId;
        oppProgram.Opportunity__c = oppId;
        
        insert oppProgram;
        return oppProgram;
    }
    
    public static Device__c getDeviceTestData(Id accId, Id oppId, Id oppProgramId) {
        
        Device__c device = new Device__c();
        device.Name = 'TestData';
        device.Tapeout_Type__c = 'GlobalShuttle MPW';
        device.CRMDID__c = '786372';
        device.Account__c = accId;
        device.Opportunity2__c = oppId;
        device.Opportunity_Program__c = oppProgramId;
        device.Device_Sourcing__c = '1st Source';
        device.End_Application__c = 'Powertrain';
        device.Fab__c = 'FAB 1';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Actual_Tapeout_Date__c = datetime.now();
        device.Process_Family_Filter__c = 'Super Low Power';
        device.Device_Mask_Set_Title__c = 'MPWTEST';
        device.Reticle_type__c = 'Small Field Reticle (SFR)';
        device.Confidence_Level_Tapeout__c = '100';    
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.PTRF_ID__c = 'test';
        
        insert device;
        return device;
    }
    
    public static Chip__c getChipTestData(Id waiverCollId) {
        
        Chip__c chip = new Chip__c();
        chip.Chip_Name__c = 'Test Data';
        chip.Wavier_Collaborator__c = waiverCollId;
        
        insert chip;
        return chip;
    }
    
    // test methods for Progress Bar Conditions
    public static Wavier_Collaborator__c getWaiverCollaborator13() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
       // waiverColl.Is_Submit_4_DFM_Apprval__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator14() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
         waiverColl.Progressbar_staus__c='Initiated';
        waiverColl.Waiver_Status__c = 'open';
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator141() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Progressbar_staus__c='Review_Disposition';
        waiverColl.Is_Sync_with_AIA__c=False; 
        waiverColl.Waiver_Status__c = 'open';
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator142() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Progressbar_staus__c='Execution';
        waiverColl.Is_Sync_with_AIA__c=False; 
        waiverColl.Waiver_Status__c = 'open';
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator15() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator16() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.Is_Submit_4_DFM_Apprval__c = true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator17() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.Is_releasedToCustomer__c = false;
        waiverColl.IsCustomerAcceptsRisk__c = false;
        waiverColl.IsCustomerAgreeToFix__c = false;
        waiverColl.IsGfAcceptsRisk__c = false;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator18() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.IsCustomerAcceptsRisk__c = false;
        waiverColl.IsCustomerAgreeToFix__c = false;
        waiverColl.IsGfAcceptsRisk__c = false;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator19() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsCustomerAgreeToFix__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator20() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.IsCustomerAcceptsRisk__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator21() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Is_Sync_with_AIA__c=false;
        waiverColl.DFMServiceOption__c ='DFM Services and Analysis';
        waiverColl.Progressbar_staus__c = 'Closed';
        
      //  waiverColl.IsCustomerAcceptsRisk__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator22() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = false;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator23() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
     //   waiverColl.PTSR_Status__c = 'Approved';
       // waiverColl.Waiver_Status__c = 'Rejected';
      //  waiverColl.IsGfAcceptsRisk__c = true;
       // waiverColl.isAllPartyApproved__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator24() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = true;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator25() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = false;
        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator26(Id deviceId, Id accId) { 
             
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.PTSR_Service_Type__c = 'Service Request';
        waiverColl.isAllPartyApproved__c = true;        
        waiverColl.Account__c = accId;
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.CRM_Device__c = deviceId;
        waiverColl.PTSR_Number__c = 'PTSRTestingData1';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator27() { 
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 1';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator28() { 
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 8';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator29() { 
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 9';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator30() { 
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator31() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.Progressbar_staus__c='Initiated';
        waiverColl.DFMServiceOption__c ='DFM Services and Analysis'; 
       
                insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator32() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFMServiceOption__c ='DFM Services and Analysis'; 
       
                insert waiverColl;
            
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator33() { 
             
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.PTSR_Service_Type__c = 'Service Request';
        waiverColl.isAllPartyApproved__c = true;        
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Number__c = 'PTSRTestingData1';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.Waiver_Status__c='Open';
        waiverColl.DFMServiceOption__c ='Waiver request'; 
        insert waiverColl;
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator34() { 
             
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Waiver_Status__c ='VCP'; 
        waiverColl.Is_Submit_4_DFM_Apprval__c =True;
         waiverColl.Progressbar_staus__c='Cancelled';
         waiverColl.PTSR_Status__c = 'Cancel';
        waiverColl.DFMServiceOption__c ='DFM Services and Analysis';
        
        insert waiverColl;
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator35() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Waiver_Status__c ='VCP'; 
        waiverColl.Progressbar_staus__c = 'Cancelled';
        waiverColl.PTSR_Status__c = 'Cancel';
        waiverColl.DFMServiceOption__c ='DFM Services and Analysis';
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
   
    public static Wavier_Collaborator__c getWaiverFields(Wavier_Collaborator__c waiverColl) {
        
        Wavier_Collaborator__c waiverColl1 = [Select Waiver_Status__c, Workflow_Status__c, IsGfAcceptsRisk__c, Is_Sync_with_AIA__c,
                                              isAllPartyApproved__c, IsCustomerAcceptsRisk__c, IsCustomerAgreeToFix__c,Progressbar_staus__c,
                                              Is_releasedToCustomer__c, Is_Submit_4_DFM_Apprval__c from Wavier_Collaborator__c 
                                              where Id =: waiverColl.Id];
        return waiverColl1;
    }
    
    // get Waiver_Rule_List__c  FD
    public static void getWaiverRuleListForiFD(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 1';
        waiverListObj.Final_Stage__c = 'FCF';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FD';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFD1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFDWCR(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'WCR';
        waiverListObj.Prime_Die_Name__c = 'Prime Die1';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'iFD';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAgreeToFix';
         waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
      public static void getWaiverRuleListForNonMatch(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'WCR';
        waiverListObj.Prime_Die_Name__c = 'Prime Die1';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'iFD';
        waiverListObj.Rule_Type__c='';
        waiverListObj.Prime_Die_Name__c='Test';
        waiverListObj.Prime_Die_Comment__c='Test;comment';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAgreeToFix';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFDWCR1(Id drcId1){ 
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'Open';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'iFD';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAgreeToFix';
         waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFDWCR2(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAgreeToFix';
         waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFDWEA(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 12';
        waiverListObj.Final_Stage__c = 'WEA';
        waiverListObj.Prime_Die_Name__c = 'Prime Die1';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'iFD';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'GfAcceptsRisk';
         waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForiFDFD(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 13';
        waiverListObj.Final_Stage__c = 'FD';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'iFD';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    
    public static void getWaiverRuleListForFDCC(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 2';
        waiverListObj.Final_Stage__c = 'FD';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FDCC';
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCC1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCWCR(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 21';
        waiverListObj.Final_Stage__c = 'WCR';
        waiverListObj.Prime_Die_Name__c = 'Prime Die1';
        //waiverListObj.Final_Status__c= '';
        waiverListObj.GF_Internal_Closing_Comment__c= 'Testing';
        waiverListObj.Customer_Closing_Comment__c= 'TESTING';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FDCC';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAcceptsRisk';
        waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCWCR1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 21';
        waiverListObj.Final_Stage__c = 'Closed';
        waiverListObj.Prime_Die_Name__c = 'Prime Die1';
        //waiverListObj.Final_Status__c= '';
        waiverListObj.GF_Internal_Closing_Comment__c= 'Testing';
        waiverListObj.Customer_Closing_Comment__c= 'TESTING';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FDCC';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAcceptsRisk';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCWCR2(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        //waiverListObj.Final_Status__c= '';
        waiverListObj.GF_Internal_Closing_Comment__c= 'Testing';
        waiverListObj.Customer_Closing_Comment__c= 'TESTING';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Customer_Closing_Comment__c = 'CustomerAcceptsRisk';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCWEA(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 22';
        waiverListObj.Final_Stage__c = 'WEA';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FCC';
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCWEA1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 22';
        waiverListObj.Final_Stage__c = 'WEA';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FCC';
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'WEA';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForFDCCFD(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 23';
        waiverListObj.Final_Stage__c = 'FD';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for FDCC';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= 'FDCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForPI(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 3';
        waiverListObj.Final_Stage__c = 'PI';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for PI';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= 'PI';
        waiverListObj.Mantis_Stage__c = 'PI';
        waiverListObj.Revert_Rule__c = true;
        waiverListObj.Waiver_Collaborator__c=drcId1;
        waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForPI1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    
    
    public static void getWaiverRuleListForPW(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 4';
        waiverListObj.Final_Stage__c = 'PW';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for PW';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= 'PW';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCService() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Service_Type__c='DRC Service Request';
        waiverColl.FAB__c = '1';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.PTSR_Number__c = '545454';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisId__c=545454;
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        getWaiverRuleListForPW(waiverColl.Id);
        getWaiverRuleListForPI(waiverColl.Id);
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCService_forService() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Service_Type__c='DRC Service Request';
        waiverColl.FAB__c = '1';
        waiverColl.PTSR_Status__c = 'pending';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.PTSR_Number__c = '545454';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisId__c=545454;
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;        
        return waiverColl;
    }
    
    
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCTrigger() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='acc1';
        waiverColl.PTSR_Number__c='PTSR-2023-999';
        insert waiverColl;
        getWaiverRuleListForPW(waiverColl.Id);
        getWaiverRuleListForPI(waiverColl.Id);
        return waiverColl;
    }
     
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCTriggert() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        getWaiverRuleListForPW(waiverColl.Id);
        getWaiverRuleListForPI(waiverColl.Id);
        return waiverColl;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaboratorDRCTrigger1() {     
        
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
         waiverColl.Metal_Stacks__c = 'Test Metal Stack';
         waiverColl.FAB__c = '1';
         waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        
         waiverColl.Is_releasedToCustomer__c = true;
         waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
         waiverColl.Account_Short_Name__c='acc1';
         insert waiverColl;
         getWaiverRuleListForPW(waiverColl.Id);
         getWaiverRuleListForPI(waiverColl.Id);
         return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCTrigger2() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Service_Type__c='DRC Service Request';
        waiverColl.FAB__c = '1';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c='FCF';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.PTSR_Number__c = '545454';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisId__c=545454;
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        getWaiverRuleListForiFDWCR(waiverColl.Id);
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaboratorDRCTrigger3() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Service_Type__c='DRC Service Request'; 
        waiverColl.FAB__c = '1';
        waiverColl.PTSR_Status__c = 'Rejected';
        waiverColl.Waiver_Status__c='FD';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.PTSR_Number__c = '545454';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisId__c=545454;
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        getWaiverRuleListForFDCCFD(waiverColl.Id); 
        return waiverColl;
    }
    
    public static List<Waiver_Rule_List__c> getWaiverRuleList(Id drcId1){
        List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,Prime_Die_Comment__c,Rule_Type__c ,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,Disagree__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c
                                                   WHERE Waiver_Collaborator__c  =:drcId1];     
        
        return waiverRuleList;           
    }
public static Wavier_Collaborator__c getWaiverCollaboratorT() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.IsCustomerAcceptsRisk__c = true;
        waiverColl.PTSR_Number__c = '6473783';
        waiverColl.FAB__c = '7';
        waiverColl.Account_Short_Name__c = 'testacc';
        //waiverColl.Selected_Customers__c='this is test line';
        insert waiverColl;
        return waiverColl;
    }    
    // created for dfm email
    public static void getWaiverRuleListForiFD1T(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'test';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FD';
        waiverListObj.Prime_Die_Name__c= 'PD1';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
 
   }
   public static void getWaiverRuleListForiFD1T1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'test';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'eFD';
        waiverListObj.Prime_Die_Name__c= 'PD1';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    public static void getWaiverRuleListForFCF(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'test';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FCF';
        waiverListObj.Prime_Die_Name__c= 'PD1';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
     public static void getWaiverRuleListForFCF1(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'FCF';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'WCR';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    
    public static void getWaiverRuleListForWCR(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'WCR';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'WCR';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    public static void getWaiverRuleListForIfd12(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'test';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    /*public static Set<Id>getWaiverRuleListForIfd123(Id drcId1){
        list<Waiver_Rule_List__c>lst=new list<Waiver_Rule_List__c>();
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj.Final_Stage__c = 'test';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'test desc';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FCC';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        lst.add(waiverListObj);
        Waiver_Rule_List__c waiverListObj1 = new Waiver_Rule_List__c();
        waiverListObj1.Design_Rule_Name__c = 'DRC Waiver Rule 11';
        waiverListObj1.Final_Stage__c = 'test1';
        //waiverListObj.Final_Status__c= '';
        //waiverListObj.GF_Review_Results__c= 'Testing1';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj1.Number_of_Violation__c= 3;
        waiverListObj1.Rule_Description__c= 'test desc';
        waiverListObj1.RuleId__c = 5454.012;
        waiverListObj1.isAllPartyApproved__c=FALSE;
        waiverListObj1.Stage__c= 'FCC';
        waiverListObj1.Waiver_Collaborator__c=drcId1;
        lst.add(waiverListObj1);
       set<id>sid=new set<Id>();
       sid.add(lst.id);
        //insert waiverListObj;
        return sid;
        }*/
    public static List<Waiver_Rule_List__c> getWaiverRuleList1(Id drcId1){
        List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,Prime_Die_Name__c,AIA_Is_Sync_Message__c,Customer_Closing_Comment__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,Disagree__c,
                                                   Stage__c,Waiver_Collaborator__c,Waiver_Collaborator__r.PTSR_Service_Type__c FROM Waiver_Rule_List__c
                                                   WHERE Waiver_Collaborator__c  =:drcId1];     
        
        return waiverRuleList;           
    }
     public static Wavier_Collaborator__c getWaiverCollaborator191() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.IsCustomerAgreeToFix__c = true;
            waiverColl.Is_Sync_with_AIA__c=false;        
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator131() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    
     public static Wavier_Collaborator__c getWaiverCollaborator1311() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Cancel';
        waiverColl.Waiver_Status__c = 'VCP';
        waiverColl.Progressbar_staus__c = 'Pending_FAE_Cancelled';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
     public static Wavier_Collaborator__c getWaiverCollaborator1312() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Progressbar_staus__c = 'Cancelled';
        waiverColl.Is_Sync_with_AIA__c=false;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
   public static Wavier_Collaborator__c getWaiverCollaborator132() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Approved'; 
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=FALSE;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
public static Wavier_Collaborator__c getWaiverCollaboratorDFMService() {     
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Service_Type__c='DFM Service Request';
        waiverColl.FAB__c = '1';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.isAllPartyApproved__c = true;
        waiverColl.PTSR_Number__c = '545454';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.MantisId__c=545454;
        waiverColl.DRB_Group_uIds__c='1001301,1004363';
        
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        getWaiverRuleListForPW(waiverColl.Id);
        getWaiverRuleListForPI(waiverColl.Id);
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator133() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        //waiverColl.IsGfAcceptsRisk__c = true;
        //waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=FALSE;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator134() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.IsGfAcceptsRisk__c = true;
        waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=FALSE;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator135() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        //waiverColl.IsGfAcceptsRisk__c = true;
        //waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator136() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Open';
        waiverColl.Waiver_Status__c = 'Open';
        //waiverColl.IsGfAcceptsRisk__c = true;
        //waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=FALSE;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator137() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        //waiverColl.IsGfAcceptsRisk__c = true;
        //waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
    public static Wavier_Collaborator__c getWaiverCollaborator138() {
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.PTSR_Status__c = 'Freeze';
        waiverColl.Waiver_Status__c = 'Open';
        //waiverColl.IsGfAcceptsRisk__c = true;
        //waiverColl.isAllPartyApproved__c = true;
        //waiverColl.Is_Submit_4_DFM_Apprval__c= true;
        waiverColl.Is_Sync_with_AIA__c=true;
        insert waiverColl;
        
        Wavier_Collaborator__c waiverColl1 = getWaiverFields(waiverColl);
        return waiverColl1;
    }
     
   public static Wavier_Collaborator__c getWaiverCollaboratortest() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
       waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = 'test';
        waiverColl.Submitted_By_Shortname__c = 'test1';
        //waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaboratorfortrigger() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.Is_Sync_with_AIA__c=true;
        insert waiverColl;
        return waiverColl;
    }
    public static Wavier_Collaborator__c getWaiverCollaboratorfortrigger1() {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.FAB__c = '1';
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.PTSR_Status__c = 'Approved';
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.DFM_Design_Type__c = 'chip';
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.Is_Sync_with_AIA__c=true;
        waiverColl.Is_All_PI_PW__c=true;
        insert waiverColl;
        return waiverColl;
    }
    public static void getWaiverRuleListForPA(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 3';
        waiverListObj.Final_Stage__c = 'PA';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for PI';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= 'PI';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    public static void getWaiverRuleListForPWO(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 3';
        waiverListObj.Final_Stage__c = 'PWO';
         
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for PI';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= 'PI';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
     public static void getWaiverRuleListForPOC(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 3';
        waiverListObj.Final_Stage__c = 'POC';
        
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for PI';
        waiverListObj.RuleId__c = 121221;
        waiverListObj.Stage__c= 'PI';
        waiverListObj.Waiver_Collaborator__c=drcId1;
        
        insert waiverListObj;
        //return waiverListObj;          
    }
    public static void getWaiverRuleListForDisagree(Id drcId1){
        
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = '';
        waiverListObj.Final_Stage__c = '';
        waiverListObj.Disagree__c=true;
        //waiverListObj.GF_Review_Results__c= 'Testing';
        // waiverListObj.Name= 'DRC-000060';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= '';
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.Stage__c= '';
        waiverListObj.Waiver_Collaborator__c=drcId1;
         waiverListObj.Rule_Type__c='1';
        
        insert waiverListObj;
        //return waiverListObj;       
    }
    
     public static Waiver_Rule_List__c getWaiverRuleListForApproval(String fedInde1, String fedInde2, Id accountId){
        
         Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
         waiverColl.Metal_Stacks__c = 'Test Metal Stack';
         waiverColl.FAB__c = '9';
         waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
         waiverColl.Created_By_Shortname__c = fedInde1;
         waiverColl.Submitted_By_Shortname__c = fedInde2;
         waiverColl.PTSR_Status__c = 'Open';
         waiverColl.Waiver_Status__c = 'Open';
         waiverColl.Account__c = accountId;
         waiverColl.Is_releasedToCustomer__c = true;
         waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
         waiverColl.Account_Short_Name__c='ACCOUNT1';
         insert waiverColl;
         
         
         Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
         waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 1';
         waiverListObj.Final_Stage__c = 'FCF';
         //waiverListObj.Final_Status__c= '';
         //waiverListObj.GF_Review_Results__c= 'Testing';
         waiverListObj.IsGfAcceptsRisk__c= TRUE;
         waiverListObj.Number_of_Violation__c= 3;
         waiverListObj.Rule_Description__c= 'Testing for iFD';
         waiverListObj.RuleId__c = 5454.012;
         waiverListObj.isAllPartyApproved__c=FALSE;
         waiverColl.PTSR_Number__c = '545454';
         waiverColl.Is_Sync_with_AIA__c=true;
         waiverListObj.RecallApprovalProcess__c='Recall';
         waiverListObj.Stage__c= 'iFD';
         waiverListObj.Waiver_Collaborator__c=waiverColl.Id;
         
         insert waiverListObj;
         return waiverListObj;       
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator4DFM(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        waiverColl.DFM_Design_Type__c='Chip';
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        //waiverColl.Waiver_Status__c = 'Open';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator4DRC_1(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.DFMServiceOption__c = 'Waiver Request';
        waiverColl.DFM_Design_Type__c='Chip';
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.Is_Sync_with_AIA__c=true;
        //waiverColl.Waiver_Status__c = 'Open';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }
    
    public static Wavier_Collaborator__c getWaiverCollaborator4DFM_1(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '1';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.DFMServiceOption__c = 'Review';
        waiverColl.DFM_Design_Type__c='Chip';
        waiverColl.Is_Submit_4_DFM_Apprval__c = true;
        waiverColl.Is_Sync_with_AIA__c=false;
        waiverColl.Waiver_Status__c = 'Open';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.Account_Short_Name__c='ACCOUNT1';
        insert waiverColl;
        return waiverColl;
    }
   public static Wavier_Collaborator__c getWaiverCollabDRC(String fedInde1, String fedInde2, Id accountId) {
            
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = '7';
        waiverColl.DRB_Group_uIds__c='1001301,1004363,1002646,1003840,1003530';
        waiverColl.Created_By_Shortname__c = fedInde1;
        waiverColl.Submitted_By_Shortname__c = fedInde2;
        waiverColl.Account__c = accountId;
        waiverColl.Is_releasedToCustomer__c = true;
        waiverColl.PTSR_Service_Type__c = 'DRC Service Request';
        waiverColl.PTSR_Status__c = 'Closed';
        waiverColl.PTSR_Number__c = 'PTSR-XXXX-000';
        waiverColl.MantisId__c = 384868;
        waiverColl.MantisIds__c='384868;384845';
        waiverColl.Account_Short_Name__c='acc1';
        insert waiverColl;
        return waiverColl;
    }
    
    public static Approval_Task_Instance__c getApprovalTaskInstance(Id WaiverCollId){
    
        Approval_Task_Instance__c appTaskInstnc = new Approval_Task_Instance__c();
        appTaskInstnc.Approvers__c = 'Test Approver';
        appTaskInstnc.Approved_Rejected_Date__c = system.today();
        appTaskInstnc.Name = 'Test Apprv Instnc';
        appTaskInstnc.Reassigned_Process__c = true;
        appTaskInstnc.WaiverRule__c = WaiverCollId;
        insert appTaskInstnc;
        return appTaskInstnc;
    
    }
    public static Approval_Task_Instance__c getApprovalTaskInstance1(Id WaiverCollId){
    
        Approval_Task_Instance__c appTaskInstnc = new Approval_Task_Instance__c();
        appTaskInstnc.Approvers__c = 'Test Approver1';
        appTaskInstnc.Approved_Rejected_Date__c = system.today();
        appTaskInstnc.Name = 'Test Apprv Instnc1';
        appTaskInstnc.Reassigned_Process__c = true;
        appTaskInstnc.WaiverRule__c = WaiverCollId;
        insert appTaskInstnc;
        return appTaskInstnc;
    
    }
    public static Approval_Task_Instance__c getApprovalTaskInstance2(Id WaiverCollId){
    
        Approval_Task_Instance__c appTaskInstnc = new Approval_Task_Instance__c();
        appTaskInstnc.Approvers__c = 'Test Approver2';
        appTaskInstnc.Approved_Rejected_Date__c = system.today();
        appTaskInstnc.Name = 'Test Apprv Instnc2';
        appTaskInstnc.Reassigned_Process__c = true;
        appTaskInstnc.WaiverRule__c = WaiverCollId;
        insert appTaskInstnc;
        return appTaskInstnc;
    
    }
    
    public static Approval_Task_Instance__c getApprovalTaskInstance3(Id WaiverCollId){
    
        Approval_Task_Instance__c appTaskInstnc = new Approval_Task_Instance__c();
        appTaskInstnc.Approvers__c = 'Test Approver3';
        appTaskInstnc.Approved_Rejected_Date__c = system.today();
        appTaskInstnc.Name = 'Test Apprv Instnc3';
        appTaskInstnc.Reassigned_Process__c = true;
        appTaskInstnc.WaiverRule__c = WaiverCollId;
        insert appTaskInstnc;
        return appTaskInstnc;
    
    }
    
    public static Environment_Variable__c getCustomSettings(String cSName){
        
        Environment_Variable__c customSettings2 = new Environment_Variable__c();
        customSettings2.Name = cSName;
        customSettings2.Value__c = '012900000004Ba8';   
        insert customSettings2;
        return customSettings2;
    }
    
    public static Error_Codes__c getCustomSettings1(String cSName1){
    
        Error_Codes__c CustSettings = new Error_Codes__c();
        CustSettings.Name = cSName1;
        CustSettings.Message__c = 'Test Message';
        
        insert CustSettings;
        return CustSettings;
    } 
    
        public static Environment_Variable__c getCustomSettings2(String cSName){
        
        Environment_Variable__c customSettings2 = new Environment_Variable__c();
        customSettings2.Name = cSName;
        customSettings2.Value__c = '12345';   
        insert customSettings2;
        return customSettings2;
    } 
    
    public static CS_Device_Stage__c getDevCustomSettings(String cSName){
    
        CS_Device_Stage__c customSettings = new CS_Device_Stage__c ();
        customSettings.Name = cSName;
        customSettings.Value__c = 'Test Message';
        insert customSettings;
        return customSettings;
    }
    
        public static CS_Manual_Device__c getDevCustomSettings2(String cSName){
    
        CS_Manual_Device__c customSettings = new CS_Manual_Device__c ();
        customSettings.Name = cSName;
        customSettings.Value__c = 'Test Message';
        insert customSettings;
        return customSettings;
    }  
    
    public static CRMDID__c getDevCustomSettings3(String cSName){
    
        CRMDID__c customSettings = new CRMDID__c ();
        customSettings.Name = cSName;
        customSettings.CRMDID_No__c = 12345;
        insert customSettings;
        return customSettings;
    }
    
    public static Bill_To_Address_Number__c getCustomSettings4(String cSName){
        
        Bill_To_Address_Number__c customSettings = new Bill_To_Address_Number__c ();
        customSettings.Name = cSName;
        customSettings.Bill_To_Address_Number__c = 119035;   
        insert customSettings;
        return customSettings;
    }       
}