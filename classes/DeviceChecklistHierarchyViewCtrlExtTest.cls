/***************************************************************************************************************************
Class:         DeviceChecklistCloneAPI
----------------------------------------------------------------------------------------------------------------------------
Author:        Sreedhar karukonda
Created Date:  14/08/2014
Reason:        This test class tests DeviceChecklistHierarchyViewCtrlExt class

Change Log:    Created     -     Sreedhar     -     14/08/2014
                Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
    Devendra  10142015      - Updated to fix device validation error
***************************************************************************************************************************/

@isTest(SeeAllData=false)
private class DeviceChecklistHierarchyViewCtrlExtTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId, String dName){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name',dName);
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
        fieldValueMap.put('BX041_Status__c','Closed');
        fieldValueMap.put('IP_Gap__c',false);
        return DeviceDataFactory.CreateDevice(fieldValueMap);
        
    }
    
    /*
    * This method tests five level of projects and its statistics
    * This test method tests DeviceChecklistHierarchyViewCtrlExt class
    */
    public static testMethod void testDeviceChecklistHierarchyMultilevelProjects(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess();   
            //Created new device
            Device__c dev = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 
             // Top Level new Project == Device Program
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            System.assertEquals(program.Device__c,  dev.id, 'Checking Device on the Checklist');
            // First Level new Projects (3 Projects)
            Test.startTest();
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
    
            List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> secondLevelTasks = DeviceChecklistTestDataUtils.createTasks(secondLevelProjects, 3);
    
            List<Checklist_Container__c> thirdLevelProjects = DeviceChecklistTestDataUtils.createSubProject(secondLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> thirdLevelTasks = DeviceChecklistTestDataUtils.createTasks(thirdLevelProjects, 3);
    
            List<Checklist_Container__c> fourthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(thirdLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fourthLevelTasks = DeviceChecklistTestDataUtils.createTasks(fourthLevelProjects, 3);
    
            List<Checklist_Container__c> fifthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(fourthLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fiftyLevelTasks = DeviceChecklistTestDataUtils.createTasks(fifthLevelProjects, 3);
            
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistHierarchyViewCtrlExt controller = new DeviceChecklistHierarchyViewCtrlExt(stdOptyCtrl);
            DeviceChecklistContainerModel container = controller.containerTree;
            Checklist_Container__c topLevelProject = controller.programDetails;
    
            System.assertEquals(topLevelProject.Name, container.Name);
            System.assertEquals(3, container.chldContainer.size(), 'There should be one child project');
            System.assertEquals(3, container.chldContainer[0].rows.size(), 'There should 3 Tasks under the project');
            container.chldContainer[0].rows[0].task.Not_Applicable__c = true;
            container.chldContainer[0].rows[0].updated = true;
            controller.saveEdits();
            controller.containerTree = null;
            container = controller.containerTree;
            System.assertEquals(2, container.chldContainer[0].rows.size(), 'There should 3 Tasks under the project');
    
            // Chatter Feed Item
            Checklist_Task__c feedTask = controller.showFeedForTaskRecord;
            System.assertNotEquals(null, feedTask, 'Feed Task should be defined');
    
            controller.showFeedForTask = fourthLevelTasks[0].id;
            System.assertEquals(fourthLevelTasks[0].Name, controller.showFeedForTaskRecord.Name, 'Feed Task should be updated');
            Test.stopTest();
        }   
    }

    
    /*
    * This method tests Inserting a ad-hoc task & remove project
    * This test method tests DeviceChecklistHierarchyViewCtrlExt class
    */
    public static testMethod void testDeviceChecklistInsertTaskAndRemoveProject(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess();   
            //Created new device
            Device__c dev = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 
             // Top Level new Project == Device Program
            Test.startTest();
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            System.assertEquals(program.Device__c,  dev.id, 'Checking Device on the Checklist');
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
    
            List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> secondLevelTasks = DeviceChecklistTestDataUtils.createTasks(secondLevelProjects, 3);
    
            List<Checklist_Container__c> thirdLevelProjects = DeviceChecklistTestDataUtils.createSubProject(secondLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> thirdLevelTasks = DeviceChecklistTestDataUtils.createTasks(thirdLevelProjects, 3);
    
            List<Checklist_Container__c> fourthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(thirdLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fourthLevelTasks = DeviceChecklistTestDataUtils.createTasks(fourthLevelProjects, 3);
    
            List<Checklist_Container__c> fifthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(fourthLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fiftyLevelTasks = DeviceChecklistTestDataUtils.createTasks(fifthLevelProjects, 3);
            
            
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistHierarchyViewCtrlExt controller = new DeviceChecklistHierarchyViewCtrlExt(stdOptyCtrl);
            System.assert(controller.isAdmin, 'User Should be a admin.');
            DeviceChecklistContainerModel container = controller.containerTree;
            Checklist_Container__c topLevelProject = controller.programDetails;
            System.assertEquals(topLevelProject.Name, container.Name);
            controller.projectId = fifthLevelProjects[0].Id;
            controller.sortOrder = 0;
            controller.newTask.Name= 'TEST TASK INSERTED 1';
            controller.newTask.Days_Due_Before_TO__c  = 10;
            controller.newTask.Deadline__c = Date.today();
            controller.newTask.OwnerId = UserInfo.getUserId();
            controller.insertTask();
            controller.projectId = fifthLevelProjects[0].Id;
            controller.sortOrder = 0;
            controller.newTask.Name= 'TEST TASK INSERTED 2';
            controller.newTask.Days_Due_Before_TO__c  = 10;
            controller.newTask.Override_Tapeout_Date__c = true;
            controller.newTask.Deadline__c = Date.today();
            controller.newTask.OwnerId = UserInfo.getUserId();
            controller.insertTask();
            List<Checklist_Task__c> insertedtask = [select id, Name, Override_Tapeout_Date__c, Deadline__c from Checklist_Task__c 
                                                            where Container__c= : fifthLevelProjects[0].Id and Name  like 'TEST TASK INSERTED%'];
            System.assertEquals(2, insertedtask.size(), 'There should be one task inserted');
            Device__c devQueried = [select id, Current_Forecast_Tapeout_Date__c from Device__c where Id=: dev.id];
            for(Checklist_Task__c task: insertedtask){
                if(task.Name == 'TEST TASK INSERTED 1'){
                    System.assertEquals(devQueried.Current_Forecast_Tapeout_Date__c - 10, task.Deadline__c, 'Deadline should be Device\'s Current Forecast Tapeout Date - 10 Days');
                }
                if(task.Name == 'TEST TASK INSERTED 2'){
                    System.assertEquals(date.today(), task.Deadline__c, 'Deadline should be today');
                }
            }
            controller.projectToBeRemoved = fifthLevelProjects[0].Id;
            controller.removeProjectFromChecklist();
            Checklist_Container__c removedProject = [select Id, Name, Not_Applicable__c, 
                                (select id, Not_Applicable__c from Checklist_Tasks__r where Not_Applicable__c =true ) from Checklist_Container__c where Id =: fifthLevelProjects[0].Id];
            
            PageReference pageRefAfterSync = controller.SyncTasks();
            System.assert(pageRefAfterSync == null, 'After synch page should be stay in the same page and refreshed');
            System.assertEquals(true, removedProject.Not_Applicable__c, 'The project should be Not Applicable');
            System.assertEquals(5, removedProject.Checklist_Tasks__r.size(), 'There should be five Not Applicable tasks');
            Test.stopTest();
            /*
            * Test Archive and Unarchive a checklist
            */
            PageReference pref1 = controller.archiveChecklist();
            List<Checklist_Container__c> projectsPartOfProjects = [select Id, Archive_Project__c from Checklist_Container__c where Program__c = :program.id];

            for(Checklist_Container__c cont: projectsPartOfProjects){
                System.assertEquals(true, cont.Archive_Project__c, 'All Projects should be archived');
            }
        }   
    }
    
    public static testMethod void testDeviceChecklistInsertTaskAndRemoveProject2(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess();   
            //Created new device
            Device__c dev = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 
             // Top Level new Project == Device Program
            Test.startTest();
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            System.assertEquals(program.Device__c,  dev.id, 'Checking Device on the Checklist');
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
    
            List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> secondLevelTasks = DeviceChecklistTestDataUtils.createTasks(secondLevelProjects, 3);
    
            List<Checklist_Container__c> thirdLevelProjects = DeviceChecklistTestDataUtils.createSubProject(secondLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> thirdLevelTasks = DeviceChecklistTestDataUtils.createTasks(thirdLevelProjects, 3);
    
            List<Checklist_Container__c> fourthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(thirdLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fourthLevelTasks = DeviceChecklistTestDataUtils.createTasks(fourthLevelProjects, 3);
    
            List<Checklist_Container__c> fifthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(fourthLevelProjects[0], 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> fiftyLevelTasks = DeviceChecklistTestDataUtils.createTasks(fifthLevelProjects, 3);
            
            
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistHierarchyViewCtrlExt controller = new DeviceChecklistHierarchyViewCtrlExt(stdOptyCtrl);
            System.assert(controller.isAdmin, 'User Should be a admin.');
            DeviceChecklistContainerModel container = controller.containerTree;
            Checklist_Container__c topLevelProject = controller.programDetails;
            System.assertEquals(topLevelProject.Name, container.Name);
            controller.projectId = fifthLevelProjects[0].Id;
            controller.sortOrder = 0;
            controller.newTask.Name= 'TEST TASK INSERTED 1';
            controller.newTask.Days_Due_Before_TO__c  = 10;
            controller.newTask.Deadline__c = Date.today();
            controller.newTask.OwnerId = UserInfo.getUserId();
            controller.insertTask();
            controller.projectId = fifthLevelProjects[0].Id;
            controller.sortOrder = 0;
            controller.newTask.Name= 'TEST TASK INSERTED 2';
            controller.newTask.Days_Due_Before_TO__c  = 10;
            controller.newTask.Override_Tapeout_Date__c = true;
            controller.newTask.Deadline__c = Date.today();
            controller.newTask.OwnerId = UserInfo.getUserId();
            controller.insertTask();
            List<Checklist_Task__c> insertedtask = [select id, Name, Override_Tapeout_Date__c, Deadline__c from Checklist_Task__c 
                                                            where Container__c= : fifthLevelProjects[0].Id and Name  like 'TEST TASK INSERTED%'];
            System.assertEquals(2, insertedtask.size(), 'There should be one task inserted');
            Device__c devQueried = [select id, Current_Forecast_Tapeout_Date__c from Device__c where Id=: dev.id];
            for(Checklist_Task__c task: insertedtask){
                if(task.Name == 'TEST TASK INSERTED 1'){
                    System.assertEquals(devQueried.Current_Forecast_Tapeout_Date__c - 10, task.Deadline__c, 'Deadline should be Device\'s Current Forecast Tapeout Date - 10 Days');
                }
                if(task.Name == 'TEST TASK INSERTED 2'){
                    System.assertEquals(date.today(), task.Deadline__c, 'Deadline should be today');
                }
            }
            controller.projectToBeRemoved = fifthLevelProjects[0].Id;
            controller.removeProjectFromChecklist();
            Checklist_Container__c removedProject = [select Id, Name, Not_Applicable__c, 
                                (select id, Not_Applicable__c from Checklist_Tasks__r where Not_Applicable__c =true ) from Checklist_Container__c where Id =: fifthLevelProjects[0].Id];
            
            PageReference pageRefAfterSync = controller.SyncTasks();
            System.assert(pageRefAfterSync == null, 'After synch page should be stay in the same page and refreshed');
            System.assertEquals(true, removedProject.Not_Applicable__c, 'The project should be Not Applicable');
            System.assertEquals(5, removedProject.Checklist_Tasks__r.size(), 'There should be five Not Applicable tasks');
            Test.stopTest();
            /*
            * Test Archive and Unarchive a checklist
            */
            PageReference pref2 = controller.unarchiveChecklist();
            List<Checklist_Container__c> projectsPartOfProjects1 = [select Id, Archive_Project__c from Checklist_Container__c where Program__c = :program.id];
            for(Checklist_Container__c cont: projectsPartOfProjects1){
                System.assertEquals(false, cont.Archive_Project__c, 'All Projects should be unarchived');
            }
        }   
    }
}