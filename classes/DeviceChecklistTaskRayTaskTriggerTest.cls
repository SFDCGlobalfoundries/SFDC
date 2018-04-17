/*Author: Prashant Srivastava
    Description: This is a Test class for TaskRay Project Task object Trigger and its corresponding helper class. 
    History:
    03192014     - code creation.
    05142014     - Updated Code to test updated requiremtns.
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
*/
@isTest (SeeAllData=false)
public class DeviceChecklistTaskRayTaskTriggerTest{
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
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
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('BX041_Status__c','Closed');
        fieldValueMap.put('IP_Gap__c',false);
        return DeviceDataFactory.CreateDevice(fieldValueMap);
        
    }
    
    public static testMethod void testInsertProjectTasks(){
      User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
      System.runAs(admin){
          IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
          insert skipUser;
          Test.startTest();      
          Account acc = DeviceChecklistTestDataUtils.createAccount();
          Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
          Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);        
          Device__c device = createDevice(acc.Id,opty.Id,optyPrgm.Id);    
          // Top Level Project == Device Program with Device      
         Checklist_Container__c program = DeviceChecklistTestDataUtils.createDeviceProgramTemplate( acc, opty, optyPrgm,device);               
         //  First Level Projects (3 Projects)
          List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
          // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
           List<Checklist_Task__c> firstLevelHoldingTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open');             
           List<Checklist_Task__c> firstLevelPrioritizedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open');
           List<Checklist_Task__c> firstLevelStartedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1, 'Open');
           List<Checklist_Task__c> firstLevelFinishedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Completed');
           List<Checklist_Task__c> firstLevelBlockedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open');
           List<Checklist_Task__c> retrievedHoldingTask  = [select Deadline__c from 
               Checklist_Task__c where id = :firstLevelHoldingTask[0].id];             
          Device__c device1 = [select Id, Current_Forecast_Tapeout_Date__c from Device__c where Id=:device.Id ];
          for(Checklist_Task__c task : retrievedHoldingTask){
            System.assertEquals(device1.Current_Forecast_Tapeout_Date__c - 10, task.Deadline__c);
           }
           Test.stopTest();
      }
    }
      
    public static testMethod void testUpdateProjectTasks(){
      User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
      System.runAs(admin){
          IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
          insert skipUser;
          Test.startTest();
          Account acc = DeviceChecklistTestDataUtils.createAccount();
          Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
          Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);        
          Device__c device = createDevice(acc.Id,opty.Id,optyPrgm.Id);    
         // Top Level Project == Device Program with Device      
         Checklist_Container__c program = DeviceChecklistTestDataUtils.createDeviceProgramTemplate( acc, opty, optyPrgm,device);               
         //  First Level Projects (1 Projects)
         List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);
         List<Checklist_Task__c> firstLevelHoldingTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open'); 
         List<Checklist_Task__c> firstLevelStartedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1, 'Open');
         List<Checklist_Task__c> firstLevelFinishedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Completed');
         List<Checklist_Task__c> firstLevelBlockedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open'); 
         Checklist_Task__c retrievedUpdatedTask = null;
         List<Checklist_Task__c> updatedTasks = new List<Checklist_Task__c>();
         for(Checklist_Task__c task : firstLevelHoldingTask){
              task.Days_Due_Before_TO__c = 12;
              task.Status__c = 'Open';
              updatedTasks.add(task);
          }
          update updatedTasks;
          Set<id> taskIds = new Set<Id>();
          for(Checklist_Task__c updatedTask :updatedTasks ){
              taskIds.add(updatedTask.id);
          }
            
        //New Task Ray Project with same id as Task.Checklist_Container__c  
         retrievedUpdatedTask = [select Container__c,Is_Completed__c,Completed_Date__c from Checklist_Task__c where id in :taskIds];
         System.assertEquals(false,retrievedUpdatedTask.Is_Completed__c);
         System.assertEquals(retrievedUpdatedTask.Completed_Date__c,null);  
         List<Checklist_Task__c> firstLevelPrioritizedTask = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 1,'Open');
         updatedTasks = new List<Checklist_Task__c>();
          for(Checklist_Task__c task : firstLevelPrioritizedTask ){
            task.Days_Due_Before_TO__c = null;
            task.Status__c = 'Completed';
            updatedTasks.add(task);          
          }
          update updatedTasks;
          Test.stopTest();
          taskIds = new Set<Id>();
          for(Checklist_Task__c updatedTask :updatedTasks ){
              taskIds.add(updatedTask.id);
          }
         retrievedUpdatedTask = [select Is_Completed__c,Completed_Date__c from Checklist_Task__c 
             where id in :taskIds];
         System.assertEquals(true, retrievedUpdatedTask.Is_Completed__c);
         System.assertEquals(retrievedUpdatedTask.Completed_Date__c, Date.today());
      }
    }

    /*
      * This method tests behavior of the system on Tasks delete.
      */
      public static testMethod void testDeleteProjectTasks(){
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Test.startTest();      
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);        
            Device__c device = createDevice(acc.Id,opty.Id,optyPrgm.Id);    
            // Top Level Project == Device Program with Device      
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createDeviceProgramTemplate( acc, opty, optyPrgm,device);               
            //  First Level Projects (1 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 1);
            Set<id> projectIds = new Set<id>();
            for(Checklist_Container__c project : firstLevelProjects){
                projectIds.add(project.id);
            }
            List<Checklist_Task__c> firstLevelHoldingTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3,'Open'); 
            List<Checklist_Task__c> deleteTasks = new List<Checklist_Task__c>();
    
            for(Checklist_Task__c task : firstLevelHoldingTasks){
                deleteTasks.add(task);            
            } 
            List<Checklist_Task__c> taskBeforeDelete = [select id from Checklist_Task__c where Container__c in :projectIds]; 
            System.assertEquals(3,taskBeforeDelete.size());
            delete deleteTasks;
            List<Checklist_Task__c> taskAfterDelete = [select id from Checklist_Task__c where Container__c in :projectIds]; 
            System.assertEquals(0,taskAfterDelete.size());
            Test.stopTest();
        }
      }

    /*
    * This method tests If the Task Status chaged to Finished to Holding and Holding to Finished.
    * Also, Tests manual update of Deadline of the task
    */
    public static testMethod void testCompleteTask(){
      User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
      System.runAs(admin){
      IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
      insert skipUser;
      Test.startTest(); 
          Account acc = DeviceChecklistTestDataUtils.createAccount();
          Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
          Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);        
          Device__c device = createDevice(acc.Id,opty.Id,optyPrgm.Id);    
   
         // Top Level Project == Device Program with Device      
         Checklist_Container__c program = DeviceChecklistTestDataUtils.createDeviceProgramTemplate( acc, opty, optyPrgm,device);
  
         //  First Level Projects (3 Projects)
          List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
          // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
           List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3, 'Open');
           
           DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
           firstLevelTasks[0].Status__c = 'Completed';
           firstLevelTasks[1].Status__c = 'Completed';
           firstLevelTasks[2].Status__c = 'Completed';
           update firstLevelTasks;
           List<Checklist_Task__c> updatedTasks = [select id, Is_Completed__c, Status__c, Completed_Date__c from Checklist_Task__c
              where id in (:firstLevelTasks[0].id, :firstLevelTasks[1].id, :firstLevelTasks[2].id)];
           for(Checklist_Task__c task: updatedTasks){
              System.assertEquals(true, task.Is_Completed__c, 'Completed should be true');
              System.assertNotEquals(null, task.Completed_Date__c, 'Completed Date should not be null');
           }
           firstLevelTasks[0].Status__c = 'Open';
           firstLevelTasks[1].Status__c = 'Open';
           firstLevelTasks[2].Status__c = 'Open';
           firstLevelTasks[0].Deadline__c = Date.today()+1;
           firstLevelTasks[1].Deadline__c = Date.today()+1;
           firstLevelTasks[2].Deadline__c = Date.today()+1;
           update firstLevelTasks;
           Test.stopTest(); 
           List<Checklist_Task__c> updatedTasksToHolding = [select id, Is_Completed__c, Status__c,Override_Tapeout_Date__c, Deadline__c, Completed_Date__c from Checklist_Task__c
              where id in (:firstLevelTasks[0].id, :firstLevelTasks[1].id, :firstLevelTasks[2].id)];
           for(Checklist_Task__c task: updatedTasksToHolding){
              System.assertEquals(false, task.Is_Completed__c, 'Completed should be false');
              System.assertEquals(null, task.Completed_Date__c, 'Completed Date should  be null');
              System.assertEquals( task.Override_Tapeout_Date__c, true, 'Deadline Should override Tapeout Date');
           }
      }
    }
}