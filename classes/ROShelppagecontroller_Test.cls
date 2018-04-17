/*
    Author: Deepti Narayan Biswal
    Description: This Class serves as the test class for ROShelppagecontroller class.
    History: 
    	DBiswal      08072015    - Code creation.
*/
@isTest(SeeAllData = false)
private class ROShelppagecontroller_Test {
    
    @testSetup static void testdata() {
        Environment_Variable__c env = new Environment_Variable__c(Name='ROS_HelpPage_User_Access',Value__c='Test1 TestSolutionUser');
        insert env;
    }
    
    static void createHCMEmployee(){
        List<HCM_Employee__c> lstHCMEmployee = new List<HCM_Employee__c >();
        
        HCM_Employee__c hcmEmp3= new HCM_Employee__c();
        hcmEmp3.Login_ID__c = 'testHCM3';
        hcmEmp3.Last_Name__c = 'TestSolutionUser';
        hcmEmp3.First_Name__c = 'Test1';
        hcmEmp3.Department_Name__c =  'IT';
        hcmEmp3.Email_Address__c = 'testSolutionUser@test.com';
        hcmEmp3.Job_Title__c = 'TestTitle';
        hcmEmp3.Phone_Number__c =  '999999997';
        hcmEmp3.Employee_ID__c = '111111';
        lstHCMEmployee.add(hcmEmp3);
        
        insert lstHCMEmployee;
    }
    
    static user createTestuser(){
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testSol';
        usr1.Email= 'testSolutionUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test1';
        usr1.LastName = 'TestSolutionUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testSolutionUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.FederationIdentifier = '111111';
        usr1.IsActive = true;
        insert(usr1);
        return usr1;        
    }
    
    static ROS_Help__c createrosHelp() {
        ROS_Help__c rh = new ROS_Help__c();
        rh.Help_Content__c = 'Test Rich text area';
        insert rh;
        return rh;
    }
    
    static testmethod void roshelpTest(){
        createHCMEmployee();
        User solteam = createTestuser();
        ROS_Help__c testroshelp = createrosHelp();
        
        Test.startTest();
            System.runAs(solteam){
                PageReference pg = Page.ROSVF_HelpPage;
                Test.setCurrentPageReference(pg);
                
                ApexPages.StandardController testsc = new ApexPages.StandardController(testroshelp);
                ROShelppagecontroller testcon = new ROShelppagecontroller(testsc);
                PageReference pgf1 = testcon.editHelp();
                PageReference pgf2 = testcon.saveHelp();
            }
        Test.stopTest();
    }
}