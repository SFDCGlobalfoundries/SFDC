/***************************************************************************************************************************
Class:         DeviceChecklist_CodeCoverage_Delete_Test
----------------------------------------------------------------------------------------------------------------------------
Author:        Sreedhar karukonda
Created Date:  02/10/2014
Reason:        There few components which are not required for Device Checklsit, but Fast Deploy don't let you delete components.
               This class written just becocouse we need code coverage for those unneccessary components.
               Unnneccessary components 
               1. DeviceChecklistCDRSTrigger Trigger  on BX041__c
               2. DeviceChecklistTaskRayProjectTrigger Trigger on TASKRAY__Project__c
               3. DeviceChecklistTaskRayTaskTrigger on TASKRAY__Project_Task__c

Change Log:    Created     -     Sreedhar     -     02/10/2014
    Devendra  10142015      - Updated to fix device validation error
***************************************************************************************************************************/

@isTest(SeeAllData=false)
private class DeviceChecklist_CodeCoverage_Delete_Test {
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
    
    public static testMethod void testUnneccessaryComponents(){
        DataUtilTest.loadEnvironmentVariables();
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
            test.starttest();


            TASKRAY__Project__c prj = new TASKRAY__Project__c(Name = 'TASKRAY__Project__c');
            insert prj;
            TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c(Name = 'TASKRAY__Project_Task__c');
            insert task;

            BX_041__c cdrsRecord = new BX_041__c(Device__c = dev.id);
            insert cdrsRecord;
            test.stoptest();
        }
    }
}