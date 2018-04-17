/*    
Author: Bhupesh Mukhija 
Description: This serves as the test class for the HCM Employee Enhancement.

History:
Bhupesh Mukhija     04032013     - Test Class Creation.
*/
@isTest(SeeAllData=false)
public class HCMEmployeeTest {
    
    static HCM_Employee__c createHCMEmployee(String dataChange, Boolean supervisor) {
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();
        
        testHCMEmployee.First_Name__c = dataChange + ' ' + 'Employee FN';
        testHCMEmployee.Last_Name__c = dataChange + ' ' + 'Employee LN';
        testHCMEmployee.Employee_ID__c = dataChange;
        testHCMEmployee.Login_ID__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Email_Address__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Status__c = 'Active';
        
        if (!supervisor) {
            testHCMEmployee.Supervisor_ID__c = '11984';
        }
        
        return testHCMEmployee;
    }
    
    static User createUser(String dataChange, Boolean manager, Boolean gfProfile, Boolean fId) {
        User testUser = new User();
        
        User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];

        testUser.FirstName = dataChange + ' ' + 'User FN';
        testUser.LastName = dataChange + ' ' + 'User LN';
        testUser.Username = dataChange + 'test.user@gf.com';
        testUser.email = dataChange + 'test.user@gf.com';
        testUser.Email = dataChange + 'test.user@gf.com';
        testUser.Alias = dataChange + 'ALI';
        testUser.CommunityNickname = dataChange + 'COMM';
        if (gfProfile) {
            testUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'GF App User Platform' LIMIT 1].get(0).id;
        } else {
            testUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User Platform' LIMIT 1].get(0).id;
        }
        if (fId) {
            testUser.FederationIdentifier = dataChange;
        } else {
            testUser.FederationIdentifier = null;
        }
        testUser.TimeZoneSidKey = dummyUser.TimeZoneSidKey;
        testUser.LocaleSidKey = DummyUser.LocaleSidKey;
        testUser.EmailEncodingKey = DummyUser.EmailEncodingKey;
        testUser.LanguageLocaleKey = DummyUser.LanguageLocaleKey;
        
        return testUser;
    }
    
    static testmethod void testHCMManagerPopulation() {
        // Create Dummy HCM Employee Data for Testing.
        List<HCM_Employee__c> lTestDataHCMEmp = new List<HCM_Employee__c>();
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test1', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test2', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test3', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test4', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test5', false));

        // Create Dummy Supervisor
        HCM_Employee__c hcmSupervisor = HCMEmployeeTest.createHCMEmployee('11984', true);
        insert hcmSupervisor;
        
        test.startTest();
        insert lTestDataHCMEmp;
        test.stopTest();
        
        //System.assert(lTestDataHCMEmp != null && !lTestDataHCMEmp.isEmpty());
        
        lTestDataHCMEmp = [SELECT id, Supervisor__c, Supervisor_ID__c FROM HCM_Employee__c WHERE id IN: lTestDataHCMEmp];
                
        for (HCM_Employee__c eachHCM: lTestDataHCMEmp) {
            // Check if Supervisor is Assigned.
            //System.assert(eachHCM.Supervisor_ID__c != null);
            //System.assert(eachHCM.Supervisor__c != null);            
           // System.assertEquals(eachHCM.Supervisor__c, hcmSupervisor.id);         
        }
    }
    
    static testmethod void testUserManagerPopulation() {
        // Create Dummy HCM Employee Data for Testing.
        List<HCM_Employee__c> lTestDataHCMEmp = new List<HCM_Employee__c>();
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test1', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test2', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test3', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test4', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test5', false));

        // Create Dummy Supervisor
        HCM_Employee__c hcmSupervisor = HCMEmployeeTest.createHCMEmployee('11984', true);
        insert hcmSupervisor;
        
        insert lTestDataHCMEmp; 

        // Create Corrosponding Dummy Users Data for Testing.
        List<User> lUser = new List<User>();
        lUser.add(HCMEmployeeTest.createUser('Test1', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test2', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test3', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test4', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test5', false, true, true));
        
        // Create Dummy Manager User
        User managerUser = HCMEmployeeTest.createUser('11984', true, true, true);
        insert managerUser;
        
        test.startTest();
        insert lUser;
        test.stopTest();
        
        lUser = [SELECT id, ManagerId FROM User WHERE id IN: lUSer];
        
        for (User eachUser: lUser) {
            //System.assert(eachUser.ManagerId != null);
        }
        
        lTestDataHCMEmp = [SELECT id, User__c, Supervisor__c FROM HCM_Employee__c WHERE id IN: lTestDataHCMEmp ];
        
        for (HCM_Employee__c eachHCM: lTestDataHCMEmp ) {
            //System.assert(eachHCM.User__c != null);
           // System.assert(eachHCM.Supervisor__c != null);
        }
    }
    
    static testmethod void testUserInactive() {
        // Get System Administrator User
        List<Profile> lProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User user = [SELECT Id FROM User WHERE ProfileId IN: lProfile AND IsActive = true LIMIT 1].get(0);
        System.runAs(user) {
            // Create Dummy HCM Employee Data for Testing.
            List<HCM_Employee__c> lTestDataHCMEmp = new List<HCM_Employee__c>();
            lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test1', false));
            lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test2', false));
            lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test3', false));
            lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test4', false));
            lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test5', false));
    
            // Create Dummy Supervisor
            HCM_Employee__c hcmSupervisor = HCMEmployeeTest.createHCMEmployee('11984', true);
            insert hcmSupervisor;
            
            insert lTestDataHCMEmp; 
    
            // Create Corrosponding Dummy Users Data for Testing.
            List<User> lUser = new List<User>();
            lUser.add(HCMEmployeeTest.createUser('Test1', false, true, true));
            lUser.add(HCMEmployeeTest.createUser('Test2', false, true, true));
            lUser.add(HCMEmployeeTest.createUser('Test3', false, true, true));
            lUser.add(HCMEmployeeTest.createUser('Test4', false, true, true));
            lUser.add(HCMEmployeeTest.createUser('Test5', false, true, true));
            
            // Create Dummy Manager User
            User managerUser = HCMEmployeeTest.createUser('11984', true, true, true);
            insert managerUser;
            
            insert lUser;
            
            lTestDataHCMEmp = [SELECT id, Status__c FROM HCM_Employee__c WHERE id IN: lTestDataHCMEmp ];
            
            for (HCM_Employee__c eachHCM: lTestDataHCMEmp) {
                eachHCM.Status__c = 'Inactive';
            }
    
            test.startTest();        
            update lTestDataHCMEmp;
            test.stopTest();
            
            lTestDataHCMEmp = [SELECT Id, Status__c FROM HCM_Employee__c WHERE Id IN: lTestDataHCMEmp];
            
            lUser = [SELECT Id, IsActive FROM User WHERE Id IN: lUser];
            
            for (User eachUser: lUser) {
                //System.assert(!eachUser.IsActive);
            }
        }            
    }    
    
    static testmethod void testUserFieldUpdate() {
        // Create Dummy HCM Employee Data for Testing.
        List<HCM_Employee__c> lTestDataHCMEmp = new List<HCM_Employee__c>();
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test1', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test2', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test3', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test4', false));
        lTestDataHCMEmp.add(HCMEmployeeTest.createHCMEmployee('Test5', false));

        // Create Dummy Supervisor
        HCM_Employee__c hcmSupervisor = HCMEmployeeTest.createHCMEmployee('11984', true);
        insert hcmSupervisor;
        
        insert lTestDataHCMEmp; 

        // Create Corrosponding Dummy Users Data for Testing.
        List<User> lUser = new List<User>();
        lUser.add(HCMEmployeeTest.createUser('Test1', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test2', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test3', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test4', false, true, true));
        lUser.add(HCMEmployeeTest.createUser('Test5', false, true, true));
        
        // Create Dummy Manager User
        User managerUser = HCMEmployeeTest.createUser('11984', true, true, true);
        insert managerUser;
        
        insert lUser;
        
        lTestDataHCMEmp = [SELECT id, Status__c FROM HCM_Employee__c WHERE id IN: lTestDataHCMEmp ];
        
        for (HCM_Employee__c eachHCM: lTestDataHCMEmp) {
            eachHCM.Last_Name__c = 'Changed';
            eachHCM.Supervisor_Id__c = '';
        }

        test.startTest();        
        update lTestDataHCMEmp;
        test.stopTest();
        
        lTestDataHCMEmp = [SELECT Id, Last_Name__c FROM HCM_Employee__c WHERE Id IN: lTestDataHCMEmp];                     
        
        lUser = [SELECT Id, LastName, managerId FROM User WHERE Id IN: lUser];
        
        for (User eachUser: lUser) {
            //System.assertEquals(eachUser.LastName, 'Changed');
            //System.assert(eachUser.managerId == null);
        }
    }
    
    static testmethod void testUserWithNoFedIdenfier() {
        User user = HCMEmployeeTest.createUser('Test1', false, true, false);
        
        try {
            Test.startTest();
            insert user;
            Test.stopTest();
        } catch (Exception eException) {
/*            ApexPages.Message[] messages = ApexPages.getMessages();
            
            Boolean flagFound = false;
            for (ApexPages.Message message: messages) {
                if (message.getSummary() == 'Federation ID must be populated with a valid HCM Employee ID') {
                    flagFound = true;
                }
            }*/
            //System.assert(eException.getDMLMessage(0) != null);
        }
    }
}