/*
Author: Shyam Ravindra Nair
Description: Test class to calculate code coverage for CuSRNewEditCostExtension class.
History:
SNair     09012015     - code creation
SNair     10012015     - added more test cases.
SNair     28042015     - modified.
*/
@isTest(SeeAllData=false)
public class CuSRNewEditCostExtensionTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod(){
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
            
            CuSR_Form__c testCuSRForm1 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New',
                OwnerId = testUser.Id
            );
            insert testCuSRForm1;
            
            CuSR_Form__c testCuSRForm2 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_5__c = true,
                Technology__c = 'ANA 0.18UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New',
                OwnerId = testUser.Id
            );
            insert testCuSRForm2;
            
            CuSR_Form__c testCuSRForm3 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_8__c = true,
                Technology__c = 'XM 0.010UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New',
                OwnerId = testUser.Id
            );
            insert testCuSRForm3;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
            CuSR_Cost__c testCuSRCost1 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Fab__c = 'FAB 1',
                Site__c = 'Dresden',
                Labour_Cost__c = cusrLabourCostSetting.get('Dresden').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost1;
            
            CuSR_Cost__c testCuSRCost2 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm2.Id,
                Fab__c = 'FAB 5',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost2;
            
            CuSR_Cost__c testCuSRCost3 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm3.Id,
                Fab__c = 'FAB 8',
                Site__c = 'Malta',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost3;
            
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',testCuSRForm1.Id);
            System.currentPageReference().getParameters().put('Site','Dresden');
            CuSRNewEditCostInfoExtension controller1 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',testCuSRForm2.Id);
            System.currentPageReference().getParameters().put('Site','Singapore');
            CuSRNewEditCostInfoExtension controller5 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',testCuSRForm3.Id);
            System.currentPageReference().getParameters().put('Site','Malta');
            CuSRNewEditCostInfoExtension controller6 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            
            CuSRNewEditCostInfoExtension controller2 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(testCuSRCost1));
            controller2.cusrCost.Implementation__c = Date.newInstance(2015,1,31);
            controller2.Save();
            controller2.Cancel();
            controller2.DeleteCost();
            
            CuSRNewEditCostInfoExtension controller3 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(testCuSRCost2));
            controller3.cusrCost.Implementation__c = Date.newInstance(2015,1,31);
            controller3.Save();
            controller3.Cancel();
            controller3.DeleteCost();
            
            CuSRNewEditCostInfoExtension controller4 = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(testCuSRCost3));
            controller4.cusrCost.Implementation__c = Date.newInstance(2015,1,31);
            controller4.Save();
            controller4.Cancel();
            controller4.DeleteCost();
            
            test.stopTest();
        }
    }
    
    public static testMethod void testRun2(){
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
            
            List<CuSR_Form__c> cusrFormList = new List<CuSR_Form__c>();
            CuSR_Form__c fab9CuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                Additional_FAB_9__c = TRUE,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            cusrFormList.add(fab9CuSRForm);
            
            CuSR_Form__c fab10CuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_10__c = true,
                Additional_FAB_10__c = TRUE,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            cusrFormList.add(fab10CuSRForm);
            
            CuSR_Form__c asicCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                ASIC__c = true,
                Additional_ASIC__c = TRUE,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            cusrFormList.add(asicCuSRForm);
            insert cusrFormList;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Essex Junction', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'East Fishkill', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'ASIC', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
            List<CuSR_Cost__c> cusrCostList = new List<CuSR_Cost__c>();
            CuSR_Cost__c fab9CuSRCost = new CuSR_Cost__c(
                CuSR_Form__c = fab9CuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Labour_Cost__c = cusrLabourCostSetting.get('Essex Junction').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(fab9CuSRCost);
            
            CuSR_Cost__c fab10CuSRCost = new CuSR_Cost__c(
                CuSR_Form__c = fab10CuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Labour_Cost__c = cusrLabourCostSetting.get('East Fishkill').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(fab10CuSRCost);
            
            CuSR_Cost__c asicCuSRCost = new CuSR_Cost__c(
                CuSR_Form__c = asicCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Labour_Cost__c = cusrLabourCostSetting.get('ASIC').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(asicCuSRCost);
            insert cusrCostList;
            
            test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',fab9CuSRForm.Id);
            System.currentPageReference().getParameters().put('Site','Essex Junction');
            CuSRNewEditCostInfoExtension fab9Controller = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            fab9Controller.Save();
            fab9Controller.Cancel();
            fab9Controller.DeleteCost();
            fab9Controller.disableEditDeleteMethod();
            System.assertEquals(fab9Controller.disableEditDelete, TRUE);
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',fab10CuSRForm.Id);
            System.currentPageReference().getParameters().put('Site','East Fishkill');
            CuSRNewEditCostInfoExtension fab10Controller = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            fab10Controller.Save();
            fab10Controller.Cancel();
            fab10Controller.DeleteCost();
            fab10Controller.disableEditDeleteMethod();
            System.assertEquals(fab10Controller.disableEditDelete, TRUE);
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRNewEditCostInfo'));
            System.currentPageReference().getParameters().put('CuSRForm',asicCuSRForm.Id);
            System.currentPageReference().getParameters().put('Site','ASIC');
            CuSRNewEditCostInfoExtension asicController = new CuSRNewEditCostInfoExtension(new ApexPages.Standardcontroller(new CuSR_Cost__c()));
            asicController.Save();
            asicController.Cancel();
            asicController.DeleteCost();
            asicController.disableEditDeleteMethod();
            System.assertEquals(asicController.disableEditDelete, TRUE);
            
            test.stopTest();
        }
    }
}