/*Author: Sreedhar Karukonda
    Description: This is a Test class for DeviceChecklistSelectCtrlExt and its corresponding helper class. 
    History:
    05192014     - code creation.
    Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
    Devendra  10142015      - Updated to fix device validation error
*/
@isTest(SeeAllData = false)
private class DeviceChecklistSelectCtrlExtTest {

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
    * This method tests Device With Device Checklist
    */
    public static testMethod void testSelectDeviceWithChecklist(){
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
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(new Checklist_Container__c());
            DeviceChecklistSelectCtrlExt controller = new DeviceChecklistSelectCtrlExt(stdOptyCtrl);
            System.assertEquals(null, controller.message, 'There should not be any message');
            controller.program.Device__c = dev.id;
            PageReference navigateToPage = controller.getPrograms();
            test.stoptest();
            System.assertEquals(null, navigateToPage, '"Get checklist button should return to same page"');
            System.assertEquals(1, controller.programs.size(), 'There should be on Device Checklist for the device');
            System.assertEquals(true, controller.displayPrograms, 'After button click Checklist should be displayed');
        }
    }
    
    /*
    * This method tests Device Without Device Checklist
    */
    public static testMethod void testSelectDeviceWithoutChecklist(){
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
            
            ApexPages.StandardController stdOptyCtrl = new ApexPages.StandardController(new Checklist_Container__c());
            DeviceChecklistSelectCtrlExt controller = new DeviceChecklistSelectCtrlExt(stdOptyCtrl);
            System.assertEquals(null, controller.message, 'There should not be any message');
            controller.program.Device__c = dev.id;
    
            PageReference navigateToPage = controller.getPrograms();
            System.assertEquals(null, navigateToPage, '"Get checklist button should return to same page"');
            System.assertEquals(null, controller.programs, 'There should be on Device Checklist for the device');
            System.assertEquals(true, controller.displayPrograms, 'After button click Checklist should be displayed');
            System.assertEquals('No programs found for the device', controller.message, 'There should be message');
        }
    }
}