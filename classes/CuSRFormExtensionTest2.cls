/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormExtension class.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormExtensionTest2 {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void testImplementation(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller1.addNewFab1Implementation();
            controller1.addNewFab2Implementation();
            controller1.addNewFab3Implementation();
            controller1.addNewFab3eImplementation();
            controller1.addNewFab5Implementation();
            controller1.addNewFab6Implementation();
            controller1.addNewFab7Implementation();
            controller1.addNewFab8Implementation();
            controller1.addNewFab9Implementation();
            controller1.addNewFab10Implementation();
            controller1.addNewASICImplementation();
            controller1.addCuSRCostForMalta();
            controller1.addCuSRCostForEssexJunction();
            controller1.addCuSRCostForEastFishkill();
            controller1.addCuSRCostForASIC();
            controller1.addCuSRCostForSingapore();
            controller1.addCuSRCostForDresden();
            controller1.EditButtonOnInitiatorTab();
            controller1.EditButtonOnDresdenApprovalTab();
            controller1.EditButtonOnDresdenImplementationTab();
            controller1.EditButtonOnSingaporeApprovalTab();
            controller1.EditButtonOnSingaporeImplementationTab();
            controller1.EditButtonOnMaltaApprovalTab();
            controller1.EditButtonOnMaltaImplementationTab();
            controller1.EditButtonOnEssexJunctionApprovalTab();
            controller1.EditButtonOnEssexJunctionImplementationTab();
            controller1.EditButtonOnEastFishkillApprovalTab();
            controller1.EditButtonOnEastFishkillImplementationTab();
            controller1.EditButtonOnASICApprovalTab();
            controller1.EditButtonOnASICImplementationTab();
            controller1.EditButtonOnPMTab();
            test.stopTest();
        }
    }
    
    public static testMethod void testImplementationRecords(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm;
            
            CuSR_Implementation__c fab3Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab3Implementation;
            
            CuSR_Implementation__c fab1Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab1Implementation;
            
            CuSR_Implementation__c fab2Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab2Implementation;
            
            CuSR_Implementation__c fab3eImplementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3E',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab3eImplementation;
            
            CuSR_Implementation__c fab5Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 5',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab5Implementation;
            
            CuSR_Implementation__c fab6Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 6',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab6Implementation;
            
            CuSR_Implementation__c fab7Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 7',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab7Implementation;
            
            CuSR_Implementation__c fab8Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab8Implementation;
            
            CuSR_Implementation__c fab9Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab9Implementation;
            
            CuSR_Implementation__c fab10Implementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert fab10Implementation;
            
            CuSR_Implementation__c asicImplementation = new CuSR_Implementation__c(
                Assignee__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Planned_End_Date__c = date.today(),
                Status__c = 'Pending'
            );
            insert asicImplementation;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testCostRecords(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Essex Junction', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'East Fishkill', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'ASIC', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
            CuSR_Form__c testCuSRForm1 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm1;
            
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
                CuSR_Form__c = testCuSRForm1.Id,
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
                CuSR_Form__c = testCuSRForm1.Id,
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
            
            CuSR_Cost__c testCuSRCost9 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm1.Id,
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
            insert testCuSRCost9;
            
            CuSR_Cost__c testCuSRCost10 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm1.Id,
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
            insert testCuSRCost10;
            
            CuSR_Cost__c testCuSRCostASIC = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm1.Id,
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
            insert testCuSRCostASIC;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm1));
            test.stopTest();
        }
    }
    
    public static testMethod void testAdditionalFab1(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Additional_FAB_2__c = true,
                Additional_FAB_3__c = true,
                Additional_FAB_3E__c = true,
                Additional_FAB_5__c = true,
                Additional_FAB_6__c = true,
                Additional_FAB_7__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c singaporeSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert singaporeSystem;
            
            CuSR_Approval_Process__c fab2Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 2',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert fab2Approval;
            
            CuSR_Approval_Process__c fab3Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert fab3Approval;
            
            CuSR_Approval_Process__c fab3EApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3E',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert fab3EApproval;
            
            CuSR_Approval_Process__c fab5Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 5',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert fab5Approval;
            
            CuSR_Approval_Process__c fab6Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 6',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert fab6Approval;
            
            CuSR_Approval_Process__c fab7Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 7',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert fab7Approval;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testAdditionalFab2(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Additional_FAB_1__c = true,
                Additional_FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c dresdenSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert dresdenSystem;
            
            CuSR_Approval_Process__c maltaSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert maltaSystem;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
            
            CuSR_Approval_Process__c fab8Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 8',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert fab8Approval;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testAdditionalFab3(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Additional_FAB_2__c = true,
                Additional_FAB_3__c = true,
                Additional_FAB_3E__c = true,
                Additional_FAB_5__c = true,
                Additional_FAB_6__c = true,
                Additional_FAB_7__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'Yes',
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c singaporeSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'System Owner'
            );
            insert singaporeSystem;
            
            CuSR_Approval_Process__c fab2Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 2',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert fab2Approval;
            
            CuSR_Approval_Process__c fab3Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert fab3Approval;
            
            CuSR_Approval_Process__c fab3EApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3E',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert fab3EApproval;
            
            CuSR_Approval_Process__c fab5Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 5',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert fab5Approval;
            
            CuSR_Approval_Process__c fab6Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 6',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert fab6Approval;
            
            CuSR_Approval_Process__c fab7Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 7',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert fab7Approval;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testAdditionalFab4(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Additional_FAB_1__c = true,
                Additional_FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'Yes',
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c dredenSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Approved',
                Type_of_Approver__c = 'System Owner'
            );
            insert dredenSystem;
            
            CuSR_Approval_Process__c maltaSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Malta',
                Status__c = 'Approved',
                Type_of_Approver__c = 'System Owner'
            );
            insert maltaSystem;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
            
            CuSR_Approval_Process__c fab8Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 8',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert fab8Approval;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testAdditionalFab5(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Additional_FAB_9__c = true,
                Additional_FAB_10__c = true,
                Additional_ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c essexJunctionSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert essexJunctionSystem;
            
            CuSR_Approval_Process__c eastFishkillSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert  eastFishkillSystem;
            
            CuSR_Approval_Process__c asicSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert  asicSystem;
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Fab__c = 'FAB 9',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            insert fab9Approval;
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Fab__c = 'FAB 10',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            insert fab10Approval;
            
            CuSR_Approval_Process__c asicApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Fab__c = 'ASIC',
                Status__c = 'New',
                Type_of_Approver__c = 'ASIC Owner'
            );
            insert asicApproval;
            
            testCuSRForm.Esx_Jun_System_Owner_Approval_Required__c = 'Yes';
            testCuSRForm.EastFishkillSystemOwnerApproval_Required__c = 'Yes';
            testCuSRForm.ASIC_System_Owner_Approval_Required__c = 'Yes';
            update testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller1.cusrForm.FAB_9__c, TRUE);
            System.assertEquals(controller1.cusrForm.FAB_10__c, TRUE);
            System.assertEquals(controller1.cusrForm.ASIC__c, TRUE);
            test.stopTest();
        }
    }
    
    public static testMethod void testPendingApproval1(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c dredenSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert dredenSystem;
            
            CuSR_Approval_Process__c maltaSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Malta',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert maltaSystem;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
            
            CuSR_Approval_Process__c fab8Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Malta',
                Fab__c = 'FAB 8',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert fab8Approval;
            
            testCuSRForm.Dresden_Ready_for_Approval__c = true;
                testCuSRForm.Malta_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testPendingApproval2(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Singapore_System_Owner_Approval_Required__c = 'Yes',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c singaporeSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert singaporeSystem;
            
            CuSR_Approval_Process__c fab2Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 2',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert fab2Approval;
            
            CuSR_Approval_Process__c fab3Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert fab3Approval;
            
            CuSR_Approval_Process__c fab3eApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3E',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert fab3eApproval;
            
                testCuSRForm.Singapore_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testPendingApproval3(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Singapore_Ready_for_Approval__c = true,
                Singapore_System_Owner_Approval_Required__c = 'Yes',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c singaporeSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert singaporeSystem;
            
            CuSR_Approval_Process__c fab5Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 5',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert fab5Approval;
            
            CuSR_Approval_Process__c fab6Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 6',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert fab6Approval;
            
            CuSR_Approval_Process__c fab7Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 7',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert fab7Approval;
            
                testCuSRForm.Singapore_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();
        }
    }
    
    public static testMethod void testPendingApproval4(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            //DataUtilTest.loadEnvironmentVariables();
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Esx_Jun_System_Owner_Approval_Required__c = 'Yes',
                EastFishkillSystemOwnerApproval_Required__c = 'Yes',
                ASIC_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c essexJunctionSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert essexJunctionSystem;
            
            CuSR_Approval_Process__c eastFishkillSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert eastFishkillSystem;
            
            CuSR_Approval_Process__c asicSystem = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Status__c = 'New',
                Type_of_Approver__c = 'System Owner'
            );
            insert asicSystem;
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                Approver3__c = testUser.Id,
                Approver4__c = testUser.Id,
                Approver5__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Fab__c = 'FAB 9',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            insert fab9Approval;
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                Approver3__c = testUser.Id,
                Approver4__c = testUser.Id,
                Approver5__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Fab__c = 'FAB 10',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            insert fab10Approval;
            
            CuSR_Approval_Process__c asicApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                Approver3__c = testUser.Id,
                Approver4__c = testUser.Id,
                Approver5__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Fab__c = 'ASIC',
                Status__c = 'New',
                Type_of_Approver__c = 'ASIC Owner'
            );
            insert asicApproval;
            
            testCuSRForm.Essex_Junction_Ready_for_Approval__c = true;
            testCuSRForm.East_Fishkill_Ready_for_Approval__c = true;
            testCuSRForm.ASIC_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller1.cusrForm.FAB_9__c, TRUE);
            System.assertEquals(controller1.cusrForm.FAB_10__c, TRUE);
            System.assertEquals(controller1.cusrForm.ASIC__c, TRUE);
            test.stopTest();
        }
    }
}