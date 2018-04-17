/*
Author: Prashant Srivastava
Description: Test class for DeviceChecklistCreateCtrlExt class
History:
   18032014 - Initial code
*/

@isTest (SeeAllData=false)
private class DeviceChecklistCreateCtrlExtTest{
    /**
    * Test Data Setup
    **/
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICESP');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now());
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('Geometry_Filter__c','0.10UM');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Expose_Device_to_Customer__c',false);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('Assigned_Process_ID__c',processId);
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        return DeviceDataFactory.CreateDevice(fieldValueMap);
    }
    
    static void createAccountTeamProxy(id accountId, list<id> userIdList, list<string> roleList){
        list<Account_Team_Proxy__c> atpList = new list<Account_Team_Proxy__c>();
        for(integer i = 0; i < userIdlist.size(); i++){
            Account_Team_Proxy__c  atp = new Account_Team_Proxy__c();
            atp.Account__c = accountId;
            atp.Account_Access__c = 'Read/Write';
            atp.Opportunity_Access__c = 'Read/Write';
            atp.Team_Role__c = roleList[i];
            if (roleList[i].equals('Customer Engineer')||roleList[i].equals('Fab Planner'))
            {
                atp.Fab_Assignment__c = 'FAB 3';
            }
            atp.User__c = userIdList[i];
            
            
            atpList.add(atp);
        }
        
        insert atpList;
    }
    
    /*
    * This method tests the available templates are displayed
    * Test method for DeviceChecklistCreateCtrlExt class
    */
    static testMethod void testAvailableTemplates(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Test.startTest();
            String acctId = DeviceChecklistTestDataUtils.createAccountID();
            String oppId = DeviceChecklistTestDataUtils.createOpp(acctId);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acctId, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Device__c dev = createDevice(acctId,oppId,oppProgId,p.Id);
            Checklist_Container__c project = DeviceChecklistTestDataUtils.createProgramWithNPIProgramType(acctId,oppId,oppProgId,dev.id);
            PageReference pageRef = Page.DeviceChecklistDeviceReportView;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController stdController = new ApexPages.StandardController(dev);
            DeviceChecklistCreateCtrlExt controller = new DeviceChecklistCreateCtrlExt(stdController);
            Map<Id, Checklist_Container__c> mapTaskRay = controller.availableTemplates;
            Checklist_Container__c program = mapTaskRay.get(project.id);
            Test.stopTest();
            System.assert(program != null);
            System.assertEquals('NPI Checklist',program.Type__c,'Program Type is not matching');
            System.assertEquals('Checklist Template',program.Subtype__c,'Program Subtype is not matching');
        }
    }

    /*
    * This Test methods Tests Clonning of the Device Checklist
    * Test method for DeviceChecklistCreateCtrlExt class
    */
    static testMethod void testCloneTemplateChecklist(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        //GF_TaskRay_Project_NPI_Editors__c editor = new GF_TaskRay_Project_NPI_Editors__c(NPI_Project_Template_Editable__c=true, SetupOwnerId= admin.id);
        //insert editor;
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Test.starttest();
            String acctId = DeviceChecklistTestDataUtils.createAccountID();
            String oppId = DeviceChecklistTestDataUtils.createOpp(acctId);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acctId, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Device__c dev = createDevice(acctId,oppId,oppProgId,p.Id);
            Checklist_Container__c project = DeviceChecklistTestDataUtils.createDeviceProgram(acctId,oppId,oppProgId,dev.id);
            // Level 1
            List<Checklist_Container__c> childProjects1 = DeviceChecklistTestDataUtils.createSubProject(project, 3);
            // Tasks at Level 1
            
            List<Checklist_Task__c> tasks1 = DeviceChecklistTestDataUtils.createTasks(childProjects1, 3);
            // Level 2
            List<Checklist_Container__c> childProjects2 = DeviceChecklistTestDataUtils.createSubProject(childProjects1[2], 3);
            // Tasks at Level 1
            List<Checklist_Task__c> tasks2 = DeviceChecklistTestDataUtils.createTasks(childProjects2, 3);
            PageReference pageRef = Page.DeviceChecklistDeviceReportView;
            Test.setCurrentPageReference(pageRef);
            Test.stopTest();
            ApexPages.StandardController stdController = new ApexPages.StandardController(dev);
            DeviceChecklistCreateCtrlExt controller = new DeviceChecklistCreateCtrlExt(stdController);
        }
    }

    
    /*
    * This Test methods Tests user without Checklist create option
    * Test method for DeviceChecklistCreateCtrlExt class
    */
    static testMethod void testUserWithoutPermissionToCreateChecklist(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        User dcuser = DeviceChecklistTestDataUtils.createUserWithDCUser('System Administrator');
        System.runAs(dcuser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = dcuser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            List<Device__c> devList = new List<Device__c>();
            String acctId = DeviceChecklistTestDataUtils.createAccountID();
            string acc = DeviceChecklistTestDataUtils.createAccountID();
            String oppId = DeviceChecklistTestDataUtils.createOpp(acctId);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acctId, oppId);
            Id oppProgId1 = DeviceChecklistTestDataUtils.createOppProg(acc, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            
            dcuser.HCM_Login_ID__c = 'E12140';
            update dcuser;
            Test.startTest();
            Device__c dev = DeviceChecklistTestDataUtils.createDevice(acctId,oppId,oppProgId,p.Id);
            Device__c dev1 = DeviceChecklistTestDataUtils.createDevice(acctId,oppId,oppProgId,null);
            devList.add(dev);devList.add(dev1);
            Test.stopTest();
            Checklist_Container__c project = DeviceChecklistTestDataUtils.createDeviceProgram(acctId,oppId,oppProgId,dev.id);
            // Level 1
            List<Checklist_Container__c> childProjects1 = DeviceChecklistTestDataUtils.createSubProject(project, 3);
            // Tasks at Level 1
            
            List<Checklist_Task__c> tasks1 = DeviceChecklistTestDataUtils.createTasks(childProjects1, 3);
            // Level 2
            List<Checklist_Container__c> childProjects2 = DeviceChecklistTestDataUtils.createSubProject(childProjects1[2], 3);
            // Tasks at Level 1
            
            List<Checklist_Task__c> tasks2 = DeviceChecklistTestDataUtils.createTasks(childProjects2, 3);
            PageReference pageRef = Page.DeviceChecklistDeviceReportView;
            Test.setCurrentPageReference(pageRef);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(dev);
            DeviceChecklistCreateCtrlExt controller = new DeviceChecklistCreateCtrlExt(stdController);
            System.assertEquals(false, controller.showMessage, 'User dose not have permission to clone Template');
            List<String> userNames = controller.getUserWhoCanCreateChecklist();
            System.assert(userNames.size() > 0, 'There should be only one admin user, who can create checklist');
            
            boolean createdAdminFound = false;
            User adminUser = [select id, name from User where id=:admin.id];
            for(String name: userNames){
                if(adminUser.Name == name){
                    createdAdminFound = true;
                }
            }
            System.assert(createdAdminFound, 'Admin name should match' + userNames + '  '+ admin.Name);
            System.assert(controller.reportUtil != null, 'Device should have Checklist. Please check create class whether Device is updated with Checklist.');
            New_Part_Creation_Form__c NPC = new New_Part_Creation_Form__c();
            NPC.Account__c = acctId;
            NPC.Originating_Device__c =devList[1].id;
            NPC.Secure_Device__c = 'Yes';
            NPC.Tapeout_Required__c = 'Yes';
            NPC.Automotive_Device__c ='Yes';
            NPC.Reason_for_New_Part__c='Fab to Fab Transfer';
            NPC.BASE_Device__c = dev.Id;
           // insert NPC;
            //Test.stopTest();
            delete skipUser;
            dev.Semiconductor_Device__c = 'Analog Others';
            dev.Product_TO_Date__c = Date.today();
            dev.Forecasted_Production_Start_Date__c = Date.today()+1;
            dev.Mask_Set_Title_Lookup__c = DeviceUtilTest.createMaskSetTtitle();
            dev.Device_ID__c = 'abcd';
            dev.Device_Mask_Set_Title__c = '';
            dev.Opportunity_Program__c = oppProgId1;
            devList[1].Assigned_Process_Id__c =p.Id;
            devList[1].Device_ID__c = 'abcdqrwd';
            devList[1].Secure_Device__c ='Yes';
            devList[1].Stage__c='Design In';
            //update devList;
            
            
            
            
        }
    }
}