/*
Author: Prashant Srivastava
Description: Test class for TaskRay_project trigger and its corresponding helper class
History:
   18032014 - Initial code
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
*/
@isTest (SeeAllData=false)
public class DeviceChecklistTaskRayProjectTriggerTest{

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
  * This test method tests Template Lock of the Child project, If top level project is Template
  */
  public static testMethod void testInsertProjectAndSubProject(){
    User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
    System.runAs(admin){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        Account acc = DeviceChecklistTestDataUtils.createAccount();
        Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
        Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
        Process__c process = DeviceChecklistTestDataUtils.createProcess();   
        Device__c device = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 

        Test.startTest();
        // Top Level Project == Device Program
        Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, device);
       //  First Level Projects (1 Projects)
        List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);


         Checklist_Container__c retFirstLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                    Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                    WHERE id = :firstLevelProjects[0].id ];
         System.assertEquals(1, retFirstLevel.Hierarchy_Level__c, 'This project should be at level one');
         System.assertEquals(device.Id, retFirstLevel.Device__c, 'Device Id should be copied from Program');
         System.assertEquals(acc.Id, retFirstLevel.Account__c, 'Account Id should be copied from Program');
         System.assertEquals(opty.Id, retFirstLevel.Opportunity__c, 'Oppty Id should be copied from Program');
         System.assertEquals(optyPrgm.Id, retFirstLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');

         System.assertEquals(program.Id, retFirstLevel.Program__c);
         
         List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 1);
         Checklist_Container__c retSecondLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                    Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                    WHERE id = :secondLevelProjects[0].id ];
         System.assertEquals(2, retSecondLevel.Hierarchy_Level__c, 'This project should be at level one');
         System.assertEquals(device.Id, retSecondLevel.Device__c, 'Device Id should be copied from Program');
         System.assertEquals(acc.Id, retSecondLevel.Account__c, 'Account Id should be copied from Program');
         System.assertEquals(opty.Id, retSecondLevel.Opportunity__c, 'Oppty Id should be copied from Program');
         System.assertEquals(optyPrgm.Id, retSecondLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');
         System.assertEquals(program.Id, retSecondLevel.Program__c);


         List<Checklist_Container__c> thirdLevelProjects = DeviceChecklistTestDataUtils.createSubProject(secondLevelProjects  [0], 1);
         Checklist_Container__c retthirdLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                    Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                    WHERE id = :thirdLevelProjects[0].id ];
         System.assertEquals(3, retthirdLevel.Hierarchy_Level__c, 'This project should be at level one');
         System.assertEquals(device.Id, retthirdLevel.Device__c, 'Device Id should be copied from Program');
         System.assertEquals(acc.Id, retthirdLevel.Account__c, 'Account Id should be copied from Program');
         System.assertEquals(opty.Id, retthirdLevel.Opportunity__c, 'Oppty Id should be copied from Program');
         System.assertEquals(optyPrgm.Id, retthirdLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');
         System.assertEquals(program.Id, retthirdLevel.Program__c);


         List<Checklist_Container__c> fourthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(thirdLevelProjects[0], 1);
         Checklist_Container__c retfourthLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                    Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                    WHERE id = :fourthLevelProjects[0].id ];
         System.assertEquals(4, retfourthLevel.Hierarchy_Level__c, 'This project should be at level one');
         System.assertEquals(device.Id, retfourthLevel.Device__c, 'Device Id should be copied from Program');
         System.assertEquals(acc.Id, retfourthLevel.Account__c, 'Account Id should be copied from Program');
         System.assertEquals(opty.Id, retfourthLevel.Opportunity__c, 'Oppty Id should be copied from Program');
         System.assertEquals(optyPrgm.Id, retfourthLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');
         System.assertEquals(program.Id, retfourthLevel.Program__c);

         List<Checklist_Container__c> fifthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(fourthLevelProjects[0], 1);
         Checklist_Container__c retfifthLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                    Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                    WHERE id = :fifthLevelProjects[0].id ];
         System.assertEquals(5, retfifthLevel.Hierarchy_Level__c, 'This project should be at level one');
         System.assertEquals(device.Id, retfifthLevel.Device__c, 'Device Id should be copied from Program');
         System.assertEquals(acc.Id, retfifthLevel.Account__c, 'Account Id should be copied from Program');
         System.assertEquals(opty.Id, retfifthLevel.Opportunity__c, 'Oppty Id should be copied from Program');
         System.assertEquals(optyPrgm.Id, retfifthLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');
         System.assertEquals(program.Id, retfifthLevel.Program__c);
         Test.stopTest();
    }
  }


    /*
    * This test method tests Template Lock of the Child project, If top level project is Template
    */
    public static testMethod void testCascadedDelete(){
    User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess();   
            Device__c device = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id, 'DEV'); 

            Test.startTest();
            // Top Level Project == Device Program
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, device);
           //  First Level Projects (1 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);

             List<Checklist_Container__c> secondLevelProjects = DeviceChecklistTestDataUtils.createSubProject(firstLevelProjects[0], 1);
             
             List<Checklist_Container__c> thirdLevelProjects = DeviceChecklistTestDataUtils.createSubProject(secondLevelProjects  [0], 1);
             
             List<Checklist_Container__c> fourthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(thirdLevelProjects[0], 1);
             
             List<Checklist_Container__c> fifthLevelProjects = DeviceChecklistTestDataUtils.createSubProject(fourthLevelProjects[0], 1);

             List<Checklist_Task__c>  fourthLevelTasks = DeviceChecklistTestDataUtils.createTasks(fourthLevelProjects, 3);
             List<Checklist_Task__c>  fifthLevelTasks = DeviceChecklistTestDataUtils.createTasks(fifthLevelProjects, 3);

             List<Id> tasksIds = new List<Id>{fourthLevelTasks[0].Id, fourthLevelTasks[1].Id, fourthLevelTasks[2].Id, fifthLevelTasks[0].Id, fifthLevelTasks[1].Id, fifthLevelTasks[2].Id };
             
             List<Checklist_Task__c> queriedTask = [select Id from Checklist_Task__c where Id in:tasksIds];
             System.assertEquals(6, queriedTask.size(), 'There should be six tasks');

             Checklist_Container__c retfifthLevel = [Select Template_Lock__c, Account__c, Opportunity__c, Opportunity_Program__c, 
                                                        Device__c, Subtype__c, Hierarchy_Level__c, Program__c from Checklist_Container__c 
                                                        WHERE id = :fifthLevelProjects[0].id ];
             System.assertEquals(5, retfifthLevel.Hierarchy_Level__c, 'This project should be at level one');
             System.assertEquals(device.Id, retfifthLevel.Device__c, 'Device Id should be copied from Program');
             System.assertEquals(acc.Id, retfifthLevel.Account__c, 'Account Id should be copied from Program');
             System.assertEquals(opty.Id, retfifthLevel.Opportunity__c, 'Oppty Id should be copied from Program');
             System.assertEquals(optyPrgm.Id, retfifthLevel.Opportunity_Program__c, 'Opty Program Id should be copied from Program');
             System.assertEquals(program.Id, retfifthLevel.Program__c);
             List<Id> projectIds = new List<Id>{thirdLevelProjects[0].id, fourthLevelProjects[0].id, fifthLevelProjects[0].id };
             delete thirdLevelProjects;

             List<Checklist_Container__c> deletedProject = [select Id from Checklist_Container__c where Id in: projectIds];
             System.assert(deletedProject.size() == 0, 'All projects should be deleted');

             List<Checklist_Task__c> queriedTaskAfterDelete = [select Id from Checklist_Task__c where Id in:tasksIds];
             System.assertEquals(0, queriedTaskAfterDelete.size(), 'There should be six tasks');
             Test.stopTest();
        }
    }
}