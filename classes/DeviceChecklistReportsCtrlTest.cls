/*
Author: Sreedhar Karukonda
Description: Test class for DeviceChecklistReportsCtrlExt, DeviceChecklistOpptyCtrlExt, DeviceChecklistCreateCtrlExt classes
History:
   18032014 - Initial code
   Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency 
    Devendra  10142015      - Updated to fix device validation error  
*/

@isTest(SeeAllData = false)
private class DeviceChecklistReportsCtrlTest {

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
    * This test method test opportunithy report generated for opportunity Details page. 
    * Opportunity is related to multiple Device Checklists.
    */
    public static testMethod void testMultipleDeviceChecklists(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess(); 
            Process__c process1 = DeviceChecklistTestDataUtils.createProcess();      
           Test.startTest();
            //Created new device
            Device__c dev = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 
             // Top Level new Project == Device Program
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            System.assertEquals(program.Device__c,  dev.id, 'Checking Device on the Checklist');
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
             
            //Created new device
            //Device__c dev1 = createDevice(acc.Id, opty.Id, optyPrgm.Id, process1.Id, 'DEV1'); 
             // Top Level new Project == Device Program
            Checklist_Container__c program1 = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects1 = DeviceChecklistTestDataUtils.createSubProject(program1, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks1 = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects1, 3);
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(opty);
            DeviceChecklistOpptyCtrlExt controller = new DeviceChecklistOpptyCtrlExt(stdOptyCtrl);
            List<DeviceChecklistReportsCtrlExt.ThisProjectStatus> optyReport =  controller.getOpportunityChecklistsStatus();
            
            System.assertEquals(2, optyReport.size(), 'There are 2 Programs under this Opportunity');
            for(DeviceChecklistReportsCtrlExt.ThisProjectStatus dcStatus: optyReport){
                System.assertEquals(9, dcStatus.total, 'There should be 9 Tasks in each program');
                System.assertEquals(9, dcStatus.due, 'There should be 9 Tasks in due each program' + dcStatus);
            }
            for(Checklist_Task__c task: firstLevelTasks){
                task.Deadline__c = Date.today();
            }
            update firstLevelTasks;
            for(Checklist_Task__c task: firstLevelTasks1){
                task.Deadline__c = Date.today() - 100;
                task.Red_Flag__c = true;
            }
            update firstLevelTasks1;
            Test.stopTest();
            
            List<Checklist_Task__c> queriedTasks = [select id, Deadline__c, Task_Status__c, Red_Flag__c, Override_Tapeout_Date__c from Checklist_Task__c where id in : firstLevelTasks1];
            for(Checklist_Task__c task : queriedTasks){
                System.assertEquals(true, task.Red_Flag__c, 'Falg should be set ' + task);
                System.assertEquals(date.Today() - 100 , task.Deadline__c, 'Deadline should be updated ' +task);
                System.assertEquals('Over Due - Flagged', task.Task_Status__c, 'Falg should be set '+ task);
                System.assertEquals(true, task.Override_Tapeout_Date__c, 'Override_Tapeout_Date__c should be true ' +task);
            }
    
            List<DeviceChecklistReportsCtrlExt.ThisProjectStatus> optyReport1 =  controller.getOpportunityChecklistsStatus();
            for(DeviceChecklistReportsCtrlExt.ThisProjectStatus dcStatus: optyReport1){
                if(dcStatus.pid == program.id){
                    System.assertEquals(9, dcStatus.dueSoon , 'There should be 9 Tasks in due soon each program' + dcStatus);
                }else{
                    System.assertEquals(9, dcStatus.overdue, 'There should be 9 Tasks in over due in program1' + dcStatus);
                }
            }
            Map<id, Checklist_Container__c> optyReports = controller.allOpportunityDeviceChecklists;
            System.assertEquals(2, optyReports.size(), 'Only one checklist is created for the opportunity');
       }
    }


    
    /*
    * This test method test opportunithy report generated for opportunity Details page. 
    * Opportunity isnot  related to any Device Checklists.
    */
    public static testMethod void testNoDeviceChecklists(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(opty);
            DeviceChecklistOpptyCtrlExt controller = new DeviceChecklistOpptyCtrlExt(stdOptyCtrl);
            List<DeviceChecklistReportsCtrlExt.ThisProjectStatus> optyReport =  controller.getOpportunityChecklistsStatus();
            System.assertEquals(0, optyReport.size());
        }
    }


    /*
    * This method test Checklist Report
    */
    public static testMethod void testDeviceChecklistReport(){
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
             test.starttest();
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, dev);
            System.assertEquals(program.Device__c,  dev.id, 'Checking Device on the Checklist');
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
            
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistReportsCtrlExt controller = new DeviceChecklistReportsCtrlExt(stdOptyCtrl);
            Map<Id, DeviceChecklistReportsCtrlExt.ThisProjectStatus> projectsReport =  controller.getProjectsStatus();
            System.assertEquals(9, projectsReport.get(program.id).total);
            System.assertEquals(3, projectsReport.get(firstLevelProjects[0].id).total);
            System.assertEquals(9, projectsReport.get(program.id).due);
            map<id, DeviceChecklistReportsCtrlExt.UserStats> userStatsMap = controller.userStatsMap;
            id userid = UserInfo.getUserId();
            System.assertEquals(9, userStatsMap.get(userid).total);
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            List<DeviceChecklistReportsCtrlExt.ThisProjectStatus> opptyReports = controller.getOpportunityChecklistsStatus();
            System.assertEquals(1, opptyReports.size(), 'There should be only one device and one Checklist');
            System.assertEquals(9, opptyReports[0].total, 'There should be only one device and one Checklist with 9 tasks');
            test.stoptest();
        }
    }


   /*
    * This method tests five level of projects and its statistics
    */
    public static testMethod void testDeviceChecklistReportMultilevelProjects(){
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
             test.starttest();
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
            DeviceChecklistReportsCtrlExt controller = new DeviceChecklistReportsCtrlExt(stdOptyCtrl);
            Map<Id, DeviceChecklistReportsCtrlExt.ThisProjectStatus> projectsReport =  controller.getProjectsStatus();
            System.assertEquals(45, projectsReport.get(program.id).total);
            System.assertEquals(39, projectsReport.get(firstLevelProjects[0].id).total);
            System.assertEquals(30, projectsReport.get(secondLevelProjects[0].id).total);
            System.assertEquals(21, projectsReport.get(thirdLevelProjects[0].id).total);
            System.assertEquals(12, projectsReport.get(fourthLevelProjects[0].id).total);
            System.assertEquals(3, projectsReport.get(fifthLevelProjects[0].id).total);
            test.stoptest();
        }
    }


    /*
    * This methods tests various Task Status and User Statistics.
    */
    public static testMethod void testDeviceChecklistTaskStatus(){
        User usr = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(usr){
            
            test.starttest();
            
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = usr.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);
            // Add Tasks first Level Project (3 Tasks each project = 3 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);

            List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 1);
            // Add Tasks first Level Project (3 Tasks each project = 3 Tasks) 
            List<Checklist_Task__c> secondLevelTasks = DeviceChecklistTestDataUtils.createTasks(secondLevelProjects, 3);
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistReportsCtrlExt controller = new DeviceChecklistReportsCtrlExt(stdOptyCtrl);
            Map<Id, DeviceChecklistReportsCtrlExt.ThisProjectStatus> projectsReport =  controller.getProjectsStatus();
            System.assertEquals(6, projectsReport.get(program.id).total);
            System.assertEquals(6, projectsReport.get(firstLevelProjects[0].id).total);
            System.assertEquals(3, projectsReport.get(secondLevelProjects[0].id).total);

            firstLevelTasks[0].Deadline__c = Date.today() - 10;
            firstLevelTasks[1].Deadline__c = Date.today() + 10;
            firstLevelTasks[2].Red_Flag__c = true;
            firstLevelTasks[1].Deadline__c = Date.today() + 1;

            secondLevelTasks[0].Deadline__c = Date.today() - 10;
            secondLevelTasks[0].Red_Flag__c = true;
            secondLevelTasks[1].Deadline__c = Date.today() + 10;
            secondLevelTasks[2].Status__c = 'Completed';
            update firstLevelTasks;
            update secondLevelTasks;
            Map<Id, DeviceChecklistReportsCtrlExt.ThisProjectStatus> projectsReport1 =  controller.getProjectsStatus();
            System.assertEquals(6, projectsReport1.get(program.id).total, 'There should be 18 Tasks under the Device Checklist   '+ projectsReport1.get(program.id));
            System.assertEquals(1, projectsReport1.get(program.id).closed, 'There should be 1 Completed Tasks under the Device Checklist  '+ projectsReport1.get(program.id));
            System.assertEquals(2, projectsReport1.get(program.id).flagged, 'There should be 1 Flagged Tasks under the Device Checklist  '+ projectsReport1.get(program.id));
            System.assertEquals(2, projectsReport1.get(program.id).overdue, 'There should be 2 Over Due Tasks under the Device Checklist  '+ projectsReport1.get(program.id));
            System.assertEquals(2, projectsReport1.get(program.id).due, 'There should be 2 Due Tasks under the Device Checklist  '+ projectsReport1.get(program.id));
            System.assertEquals(1, projectsReport1.get(program.id).dueSoon, 'There should be 2 Due Soon Tasks under the Device Checklist  '+ projectsReport1.get(program.id));
            // USER STATS //
            map<id, DeviceChecklistReportsCtrlExt.UserStats> userStatsMap = controller.userStatsMap;
            id userid = UserInfo.getUserId();
            System.assertEquals(6, userStatsMap.get(userid).total, userStatsMap.get(userid) );
            System.assertEquals(2, userStatsMap.get(userid).totalMissedDeadline, 'There should be 2 Missed Dealine Tasks under the Device Checklist User ' + userStatsMap.get(userid));
            /*System.assertEquals(2, userStatsMap.get(userid).totalMissedDeadline, 'There should be 2 Missed Dealine Tasks under the Device Checklist User ' + userStatsMap.get(userid));*/
            System.assertEquals(10, userStatsMap.get(userid).getAvgLate(), '2 Missed Deadlines with 10 Days each, so avarage late should be 10 ' + userStatsMap.get(userid));
            DeviceChecklistReportsCtrlExt.TreeeModel programTree = controller.programTree; 
            System.assertEquals(1, programTree.children.size(), 'There should be one Project under checklst');  
            System.assertEquals(1, programTree.children[0].children.size(), 'There should be one Project under checklst');
            test.stoptest();
        }
    }


   /*
    * This test method tests UI interactions in reports page
    */
    public static testMethod void testDeviceChecklistUITest(){
        User usr = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(usr){
            test.starttest();
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = usr.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
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
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);
            // Add Tasks first Level Project (3 Tasks each project = 3 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);

            List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 1);
            // Add Tasks first Level Project (3 Tasks each project = 3 Tasks) 
            List<Checklist_Task__c> secondLevelTasks = DeviceChecklistTestDataUtils.createTasks(secondLevelProjects, 3);
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(program);
            DeviceChecklistReportsCtrlExt controller = new DeviceChecklistReportsCtrlExt(stdOptyCtrl);
            PageReference pageRef = Page.DeviceChecklistReportsView;
            Test.setCurrentPage(pageRef);
            Map<Id, DeviceChecklistReportsCtrlExt.ThisProjectStatus> projectsReport =  controller.getProjectsStatus();
            System.assertEquals(6, projectsReport.get(program.id).total);
            System.assertEquals(6, projectsReport.get(firstLevelProjects[0].id).total);
            System.assertEquals(3, projectsReport.get(secondLevelProjects[0].id).total);
            //Click on Show Opportunity report
            PageReference optyReportPage = controller.switchToReportToOpptyReport();
            System.assertEquals(null, optyReportPage , 'Oppty Report is on the same page, only rerender needs to happen');
            System.assertEquals(false, controller.checklistReportView, 'Checklist report should be hidden');
            // Click on Device Checklist report
            PageReference checklistReportPage = controller.switchToReportToChecklistReport();
            System.assertEquals(null, checklistReportPage , 'Checklist Report Report is on the same page, only rerender needs to happen');
            System.assertEquals(true, controller.checklistReportView, 'Checklist report should be hidden');
            test.stoptest();

        }
    }
}