/*
    Author:         CTS
    Company:        Cognizant Technology Solution
    Description:    This is a test class for apex class ROS_BATCH_UpdateReticleInactiveDays
    History:        
        NJain       25/03/2014          Created
        
*/

@isTest(SEEALLDATA = false)
private class ROS_TestBatchUpdateReticleInactiveDays {
    static void loadCustomSettings(){
        DataUtilTest.loadEnvironmentVariables();
      /*DataUtilTest.LoadFabEnvVariables();
      DataUtilTest.LoadATPEnvVariables();
      DataUtilTest.LoadDeviceEnvVariable();
      DataUtilTest.LoadFabReticleEnvVariables();
      DataUtilTest.LoadHCMEnvVariables();
      DataUtilTest.LoadOpptyEnvVariables();
      DataUtilTest.LoadOPTMEnvVariables();
      DataUtilTest.LoadReticleDeviceEnvVariables();
      DataUtilTest.LoadReticleDWEnvVariables();
      DataUtilTest.LoadReticleEnvVariables(); */
    }
    
    static User createAdminUser(){
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testAdm';
        usr1.Email= 'testAdmin@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testAdminUser@test.com';  
        usr1.Fab_Assigned__c = 'FAB 1';
        usr1.IsActive = true;
        usr1.FederationIdentifier = '222222';
        insert(usr1);
        return usr1;
    }

    static Account createAccount(){
        Account acc = new Account(Name='CIRRUS LOGIC Test',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');
        
        insert acc;
        return acc;
    }

    static Id createReticleCycle() {
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }

    static Reticle__c createReticle(string reticleName, String accountId, String rosCycle, Integer dayInactive) {
        Reticle__c rt                 = new Reticle__c();
        rt.Account__c                 = accountId;
        rt.ROS_Cycle__c               = rOSCycle;
        rt.Day_Inactive__c            = dayInactive;
        rt.Solution_Team_Confirm__c   = true;
        rt.Name                       = reticleName;
        rt.Reticle_Type__c            = 'BINARY';
        rt.Region__c                  = 'US';
        rt.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        return rt;
    }
   
    static testMethod void testUpdateReticleInactiveDays() {
        loadCustomSettings();
        User adminUser = ROS_TestBatchUpdateReticleInactiveDays.createAdminUser();

        test.startTest();

        System.runAs(adminUser) {
            String cycle = ROS_TestBatchUpdateReticleInactiveDays.createReticleCycle();
            Account account = ROS_TestBatchUpdateReticleInactiveDays.createAccount();
            List<Reticle__c> listReticle = new List<Reticle__c>();
    
            for(integer i = 0; i < 20; i++) {
                Reticle__c reticle = ROS_TestBatchUpdateReticleInactiveDays.createReticle('reticle' + i, account.Id, cycle, 100);
                listReticle.add(reticle);
            }
            
            insert listReticle;
            
            listReticle.clear();
            for(Reticle__c reticle : [Select id, Inactive_Days_Start_Date__c From Reticle__c Where isActive__c = true  ]) {
                reticle.Inactive_Days_Start_Date__c = date.today().addDays(-366);
                listReticle.add(reticle);
            }
            update listReticle;

            System.assertEquals(100, [Select Id, Day_Inactive__c From Reticle__c Limit 1].Day_Inactive__c);
            Database.executeBatch(new ROS_BATCH_UpdateReticleInactiveDays(), 20);
        }
        test.stopTest();

    }
    
    
    
}