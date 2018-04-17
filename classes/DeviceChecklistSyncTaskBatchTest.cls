/***************************************************************************************************************************
Class:         DeviceChecklistSyncTaskBatchTest
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  11/07/2014
Reason:        Test class that covers batch apex class "DeviceChecklistSyncTaskBatch"

Change Log:    Created     -     JOYDEV     -     11/07/2014 
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
                Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.                        
***************************************************************************************************************************/

@isTest(SeeAllData=false)
public class DeviceChecklistSyncTaskBatchTest {

    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
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
    
     public static testMethod void SyncTaskTest1() {
         User admin = new User(Id=UserInfo.getUserId());
       System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            createSyncVariables();
            Map<String, String> mapOpps = new Map<String, String>();
            List<Opportunity> opps = new List<Opportunity>();
            List<Checklist_Container__c> projs = new List<Checklist_Container__c>();
            List<Checklist_Task__c> tasks = new List<Checklist_Task__c>();
            Account acc = getAccount('MYTEST ACCOUNT1');
           
            Map<String, Map<String, Object>> oppFieldMap = new Map<String, Map<String, Object>> 
                {'IsPrivate' => new Map<string, Object>     {'Dependent_Field_Type__c' => 'Boolean',
                                                             'Dependent_Field_Completed_Value__c' => True},
                 'AccountId' => new Map<string, Object>     {'Dependent_Field_Type__c' => 'Lookup',
                                                             'Dependent_Field_Completed_Value__c' => acc.Id},
                 'CloseDate' => new Map<string, Object>     {'Dependent_Field_Type__c' => 'Date',
                                                             'Dependent_Field_Completed_Value__c' => Date.today()},
                 'Type' => new Map<string, Object>          {'Dependent_Field_Type__c' => 'Picklist',
                                                             'Dependent_Field_Completed_Value__c' => 'test entry'},
                 'Probability' => new Map<string, Object>   {'Dependent_Field_Type__c' => 'Number',
                                                             'Dependent_Field_Completed_Value__c' => 85},
                 'Description__c'=> new Map<string, Object> {'Dependent_Field_Type__c' => 'Text',
                                                             'Dependent_Field_Completed_Value__c' => 'test desc'},
                 'End_Customers__c'=> new Map<string, Object> {'Dependent_Field_Type__c' => 'Text',
                                                             'Dependent_Field_Completed_Value__c' => '__notnull'}};
            Opportunity opp = createOpportunity(acc.Id);
            for(String fieldName : oppFieldMap.keySet()) {
                
                if(oppFieldMap.get(fieldName).get('Dependent_Field_Completed_Value__c') != '__notnull'){
                    opp.put(fieldName, oppFieldMap.get(fieldName).get('Dependent_Field_Completed_Value__c'));
                }else{
                    opp.put(fieldName, '');
                }
                opps.add(opp);
                mapOpps.put(opp.Name, fieldName);
            }
           // insert opps;
            Map<Id, Opportunity> mapOppIdWithOpp = new Map<Id, Opportunity>();
            for(Opportunity opp1 : opps) {
                mapOppIdWithOpp.put(opp1.Id, opp);
            }
            for(Opportunity opp2 : opps) {
                Checklist_Container__c proj = createProject(opp2.Id);
                projs.add(proj);
            }
            Opportunity_Program__c optyPrgm = DeviceChecklistTestDataUtils.createOpptyProgram(acc,  opps[0]);
            test.startTest();
            Device__c device = createDevice(acc.id, opps[0].Id, optyPrgm.Id, null, 'DEV'); 
            projs[0].Device__c = device.id;
            insert projs;
    
            BX_041__c cdrsRecord = new BX_041__c(Device__c = device.id);
            insert cdrsRecord;
            
            for(Checklist_Container__c proj : projs) {
                String fieldName = mapOpps.get(mapOppIdWithOpp.get(proj.Opportunity__c).Name);
                Map<string, Object> fieldDetail = oppFieldMap.get(fieldName);
                
                Checklist_Task__c tsk = createTask(proj.Id);
                tsk.Dependent_Object__c = 'Opportunity';
                tsk.Dependent_Field_Type__c = String.valueOf(fieldDetail.get('Dependent_Field_Type__c'));
                tsk.Dependent_Field__c = fieldName;
                tsk.Dependent_Field_Completed_Value__c = String.valueOf(fieldDetail.get('Dependent_Field_Completed_Value__c'));
                
                tasks.add(tsk);
            }
            insert tasks;
            
                String query = 'SELECT Id, '
                             +'        Name, '
                             +'        Is_Completed__c, '
                             +'        Dependent_Object__c, '
                             +'        Dependent_Field__c, '
                             +'        Dependent_Field_Type__c, '
                             +'        Dependent_Field_Completed_Value__c, '
                             +'        Container__r.Opportunity__c, '
                             +'        Container__r.Program__c, '
                             +'        Container__r.Device__c '
                             +'   FROM Checklist_Task__c '
                             +'  WHERE Container__r.Opportunity__r.AccountId = \'' + acc.Id + '\'';
                                    
                DeviceChecklistSyncTaskBatch btch = new DeviceChecklistSyncTaskBatch();
                DeviceChecklistSyncTaskBatch.Interval = 100000;
                DeviceChecklistSyncTaskBatch.LastSyncDateTime = datetime.now().addMinutes(-1);
                ID batchprocessid = Database.executeBatch(btch);
                
                btch.start(null);
                btch.execute(null, Database.query(query));
                btch.finish(null); 
                
            test.stopTest();
            }
    }
    
    public static testMethod void SyncTaskTest2() {
          User admin = new User(Id=UserInfo.getUserId());
            System.runAs(admin){
               IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
               insert skipUser;
                createSyncVariables();
                DeviceChecklistSyncTaskBatchUtil dcutil = new DeviceChecklistSyncTaskBatchUtil();
                dcutil.BatchErrors = 'dummy';
                dcutil.BatchErrorsHtml = 'dummy';
                        
                String[] recipients = new List<String>();
                
                for(SyncTaskErrorDL__c rep : SyncTaskErrorDL__c.getall().values()) {
                    recipients.add(rep.Email__c);
                }
                        
                dcutil.SendMail(recipients);
                DeviceChecklistCDRSReferenceBatchUtil CDRSUtils = new DeviceChecklistCDRSReferenceBatchUtil();
                CDRSUtils.BatchErrors ='This is to just SEND MAIL';
                CDRSUtils.SendMail(recipients);
           }
    }
    
    public static Checklist_Task__c createTask(Id projId) {
        return new Checklist_Task__c(Name = 'TSKX' + Math.Random(),
                                            Status__c = 'Open',
                                            Container__c = projId);
    }
    
    public static Checklist_Container__c createProject(Id oppId) {
        return new Checklist_Container__c(Name = 'PRJX' + Math.Random(),
                                       Opportunity__c = oppId);
    }
    
    public static Opportunity createOpportunity(Id accId) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',accId);
        fieldValueMap.put('Name','OPPX' + Math.Random());  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.today().adddays(5));  
        fieldValueMap.put('Target_Process_Node__c','10XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Production_Confidence__c','30%');
        fieldValueMap.put('Opportunity_Health__c','On Track');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);        
    }
    
    public static void createSyncVariables() {
        insert new SyncTaskFrequency__c(Name = 'Sync Interval',
                                        Frequency__c = 1,
                                        Last_Sync_Date_Time__c = datetime.now());
                                        
        insert new SyncTaskErrorDL__c(Name = 'DL 1',
                                      Email__c = 'dl.1@gf.com');
    }


    /*public static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c( Name = 'TESTDEVICE1947',Stage__c = 'Design In',Status__c = 'Active',
        Account__c = accId,Opportunity2__c = oppId,Opportunity_Program__c = oppProgId,Market_Segment__c = 'Automotive',
        Semiconductor_Device__c = 'Analog Regulator',End_Application__c = 'Body',Device_Sourcing__c = '3rd Source',
        Tapeout_Type__c = 'Customer MPW',Siebel_Device_ID__c = '0987654321',IP_Gap__c = false,
        BX041_Status__c = 'Closed', Actual_Tapeout_Date__c = date.newInstance(2013,5,20), 
        Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
        Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4));  
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Fab__c = 'Fab 3';
            
        insert dev;
        return dev; 
    }*/
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}