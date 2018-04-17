/*Author: Prashant Srivastava
    Description: This is a Test class for TaskRayUtils helper class. 
    History:
    03212014     - code creation.
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
    Devendra  10142015      - Updated to fix device validation error
*/
@isTest (SeeAllData=false)
public class DeviceChecklistUtilsTest {
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
    
    /*
    * THIS METHOD TESTS DEVICE CURRENT FORCAST TAPEOUT DATE. 
    * THIS DATE CHANGE SHOULD REFLECT IN ALL TASKS WHICH ARE NOT FLAGED TO OVERRIDE TAPEOUT DATE
    */
    public static testMethod void testOnDeviceToChange(){
        User adminUser = DeviceChecklistTestDataUtils.createUser('System Administrator');
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            
            Account acc = DeviceChecklistTestDataUtils.createAccount();
            Opportunity opty = DeviceChecklistTestDataUtils.createOppty(acc);
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opty);
            Process__c process = DeviceChecklistTestDataUtils.createProcess();      
            //Created new device
            test.startTest();
            Device__c devNew = createDevice(acc.id, opty.Id, optyPrgm.Id, process.Id);
            
             // Top Level new Project == Device Program
             
            Checklist_Container__c program = DeviceChecklistTestDataUtils.createProgramWithDevice( acc, opty, optyPrgm, devNew);
            
            System.assertEquals(program.Device__c,  devNew.id, 'Checking Device on the Checklist');
            devNew.Semiconductor_Device__c = 'Analog Others';
            //devNew.Tapeout_Type__c = 'Single Product';
            devNew.Current_Forecast_Tapeout_Date__c = date.newInstance(2012,2,4);
            devNew.Checklist__c = program.id;
            devNew.Enabled_via_previous_MPW_1__c='No';
            devNew.Mask_Set_Title_Lookup__c = null;
            update devNew;
            Test.stopTest();
            // First Level new Projects (3 Projects)
            List<Checklist_Container__c> firstLevelProjects = DeviceChecklistTestDataUtils.createSubProject(program, 3);
            
            // Add Tasks first Level Project (3 Tasks each project = 9 Tasks) 
            List<Checklist_Task__c> firstLevelTasks = DeviceChecklistTestDataUtils.createTasks(firstLevelProjects, 3);
            Checklist_Task__c task = firstLevelTasks.get(0);
            Checklist_Task__c retrievedTask = [select Deadline__c,Override_Tapeout_date__c,Days_Due_Before_TO__c from Checklist_Task__c where id = :task.id];         
            retrievedTask.Days_Due_Before_TO__c = 10;
            retrievedTask .Deadline__c = Date.today();
            update retrievedTask;
            Checklist_Task__c retrievedTaskAfterUpdate = [select Id, Deadline__c,Override_Tapeout_date__c,Days_Due_Before_TO__c from Checklist_Task__c where id = :retrievedTask.id];
            System.assertEquals( false, retrievedTaskAfterUpdate.Override_Tapeout_Date__c, 'Override Tapeout should be set');
            DeviceChecklistUtils.deviceTapeoutDatePropagation = false;

            retrievedTask.Days_Due_Before_TO__c = 10;
            retrievedTask .Deadline__c = Date.today();
            update retrievedTask;
            Checklist_Task__c retrievedTaskAfterUpdate2 = [select Deadline__c,Override_Tapeout_date__c,Days_Due_Before_TO__c from Checklist_Task__c where id = :retrievedTask.id];
            System.assertEquals( true, retrievedTaskAfterUpdate2.Override_Tapeout_Date__c, 'Override Tapeout should be set');
            
        }       
    }
    
    public static testMethod void testOnDeviceForTrigger(){
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
            Test.startTest();
            dcuser.HCM_Login_ID__c = 'E12140';
            update dcuser;
            Device__c dev = createDevice(acctId,oppId,oppProgId,p.Id);
           // Device__c dev1 = createDevice(acc,oppId,oppProgId,p.Id);
            
            Test.stopTest();
            //devList.add(dev);
            //devList.add(dev1);    
            dev.Stage__c = 'Production';
            dev.Device_ID__c = 'xyzabcd';
            dev.IP_Gap__c = false;
            delete skipUser;
            /*devList[1].Stage__c = 'Prototype';
            devList[1].Status__c = 'On Hold';
            devList[1].Reason_For_Status_On_Hold__c = 'reason for onhold';
            devList[1].Device_ID__c ='qwertr';
            devList[1].Tapeout_Type__c ='Customer MPW';*/
           // devList[0].Device_Mask_Set_Title__c = 'MPW13';
            //update devList;
            
            dev.Stage__c = 'Tapeout';
            update dev;
            
        }
    }
    
    public static testMethod void testOnDeviceForTrigger1(){
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
           // Id MST = DeviceUtilTest.createMaskSetTtitleMPW();
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Test.startTest();
            dcuser.HCM_Login_ID__c = 'E12140';
            update dcuser;
            Device__c dev = createDevice(acctId,oppId,oppProgId,p.Id);
            Test.stopTest();
            dev.Device_ID__c ='poiuyu';
            dev.Stage__c = 'Design In';
            dev.Tapeout_Type__c ='GlobalShuttle MPW';
            dev.MPW_Train_Number__c =   DeviceUtilTest.createMPWTrainMnt();
            dev.Product_TO_Date__c = Date.today()+1;
            dev.Forecasted_Production_Start_Date__c = Date.today()+3;
            update dev;
            
       }
    }
}