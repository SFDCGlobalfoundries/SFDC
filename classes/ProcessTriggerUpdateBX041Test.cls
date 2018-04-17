/*
 Type Name: ProcessTriggerUpdateBX041Test
 Author: Prosenjit Saha and Thomas Lai
 Created Date: 19-Aug-2013
 Reason: This is the test class for 'ProcessUpdateBX041Trigger' trigger.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 Vijay      16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
 DBiswal    04092015    - Updated code for refactoring of test class.
*/


@isTest(SeeAllData=false)
private class ProcessTriggerUpdateBX041Test
{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('testing901'); 
        
        Contact testContact = new Contact();
        testContact.accountid = testAcct.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;
       
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');       
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
       
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Fab__c','FAB 3'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('Tapeout_Type__c','Single Product'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c','100'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1'); 
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    static Process__c createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Registered/TBO';//Prototype Ready; MPW Ready;'Registered/TBO
        process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        insert process1;
        return process1;
    }
    static BX_041__c createBX041(ID deviceID, ID reqProcID){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Status__c = 'Registered/TBO PID Assigned';
        //bx041.Assigned_Process_ID__c = AssgnProcID;
        //bx041.Requested_Process_ID__c = reqProcID;
        insert bx041;  
        
        
        return bx041;  
    }
    
    static List<Process_Information__c> createPI (id bx041ID, List<id> questionMetadataIDList){
        List<Process_Information__c> insertList = new List<Process_Information__c>();
        for(id questionMetadataID :questionMetadataIDList){
            Process_Information__c pi = new Process_Information__c(BX_041__c = bx041ID );
            pi.Comments__c = 'Test Comment';
            pi.Customer_Comment__c = 'Test CustComment';
            pi.Customer_Request__c = 'Test';
            pi.FE_Requested_Information__c = '';
            pi.mandatory__c = true;
            pi.PIYE__c = '';
            pi.Question__c = 'Lifecycle';
            pi.Question_Metadata__c = questionMetadataID;
            pi.Question_to_Display__c = 'Lifecycle';
            pi.Requirement_Gaps__c = 'test';
            insertList.add(pi);
        }
        insert insertList;
        return insertList;
    }
    
    
    
    static testmethod void testProcessTrigger2()
    {
        //DataUtilTest.loadEnvironmentVariables(); //loading data
        //Test Data creation: 
        
        String testAcctId = createAccount();
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = createDevice(testAcctId, testOpptyProgramId);
        test.startTest();
        Device__c testDevice = createDevice(testAcctId, testOpptyProgramId);
        
        //Device__c testDevice = DeviceUtilTest.createSPDeviceNew(testAcctId, testOpptyProgramId);
        Process__c process1 = createProcess();
        testDevice.Assigned_Process_ID__c = process1.id;
        testDevice.requested_Process_ID__c = process1.id;
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        List<Question_Metadata__c> qstnMetadata = createQuestionMt();
        for(Question_metadata__c  qm : qstnMetadata ){
            if(MapPicklist.get(qm.Record_Type__c) == NULL){
                List<id> i = new List<id>();
                i.add(qm.id);
                MapPicklist.put(qm.Record_Type__c , i);
            }
            else{
                MapPicklist.get(qm.Record_Type__c).add(qm.id);    
            }                                  
        } 
        
        //test.startTest();
        update testDevice;
        
              
        
        BX_041__c bx041 = createBX041(testDevice.id,process1.id);
        createPI (bx041.id,MapPicklist.get('Process Id'));
        bx041.Assigned_Process_ID__c = process1.id;
        bx041.requested_Process_ID__c = process1.id;
        bx041.BX_041_Status__c = 'Registered/TBO PID Assigned';
        update bx041;
        process1.Available_to_Sell__c = 'MPW Ready';
        process1.ATTRIBUTE_READINESS_CALCULATED__c = 'Suspended';
        update process1;
        
        bx041.BX_041_Status__c = 'Suspended PID Assigned';
        update bx041;
        process1.Available_to_Sell__c = 'Available';
        process1.ATTRIBUTE_READINESS_CALCULATED__c = '';
        update process1;
        test.stopTest();  
        //test.stopTest();       
    }
    // test -- update 'lifecycle' for FE and PIYE column
    static testmethod void testProcessTrigger()
    {
        //DataUtilTest.loadEnvironmentVariables(); //loading data
        //Test Data creation: 
        
        String testAcctId = createAccount();
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        test.startTest();
        //Device__c testDevice = createDevice(testAcctId, testOpptyProgramId);
        Device__c testDevice = createDevice(testAcctId, testOpptyProgramId);
        
        //insert testDevice;
        Process__c process1 = createProcess();
        testDevice.Assigned_Process_ID__c = process1.id;
        testDevice.requested_Process_ID__c = process1.id;
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        List<Question_Metadata__c> qstnMetadata = createQuestionMt();
        for(Question_metadata__c  qm : qstnMetadata ){
            if(MapPicklist.get(qm.Record_Type__c) == NULL){
                List<id> i = new List<id>();
                i.add(qm.id);
                MapPicklist.put(qm.Record_Type__c , i);
            }
            else{
                MapPicklist.get(qm.Record_Type__c).add(qm.id);    
            }                                  
        } 
        
        
        //test.startTest();
        
        update testDevice;
        
        
        BX_041__c bx041 = createBX041(testDevice.id,process1.id);
        createPI (bx041.id,MapPicklist.get('Process Id'));
        bx041.Assigned_Process_ID__c = process1.id;
        bx041.requested_Process_ID__c = process1.id;
        update bx041;
        
        
        process1.ATTRIBUTE_READINESS_CALCULATED__c = 'Suspended';
        update process1;
        process1.Available_to_Sell__c = 'MPW Ready';
        update process1;
        test.stopTest();
        
        //test.stopTest();       
    }
    
    static list<Question_Metadata__c> createQuestionMt(){
        
        Question_Metadata__c qm11 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question__c = 'Process Id',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10000,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm12 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question__c = 'Process Information',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10100,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Section');
        Question_Metadata__c qm13 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Process_field_API_name__c = 'PID_NUMBER__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'PLM PID',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10101,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Text');
        Question_Metadata__c qm14 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'AVAILABLE_TO_SELL__c',
                                                            Mandatory__c = true,
                                                            Question__c = 'Lifecycle',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10102,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');   
        Question_Metadata__c qm15 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'CORE_VOLTAGES__c',
                                                            Mandatory__c = true,
                                                            Question__c = 'Core Voltage/s (V)',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10103,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');  
        
        /*====== GAP Analyis ====================== */
        Question_Metadata__c qm21 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Gap Analysis',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20000,
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm22 = new Question_Metadata__c(API_Name__c = 'c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Basic Information',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20100,
                                                            Type__c = 'Section'); 
        Question_Metadata__c qm23 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'PID',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20101,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm24 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = true,
                                                            Question__c = 'Does the Process require a customized development ?',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20102,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm25 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'IP QA Status',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20103,
                                                            Type__c = 'Picklist');                                                                                                                                                                                                                                          
        /*====== RF Analyis ====================== */
        Question_Metadata__c qm31 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Gap Analysis',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30000,
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm32 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Basic Information',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30100,
                                                            Type__c = 'Section'); 
        Question_Metadata__c qm33 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Stack MIM',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30101,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm34 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'RF LDMOS',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30102,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm35 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question__c = 'Additional Well',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30103,
                                                            Type__c = 'Text'); 
                                                                                                                                                                            
         list<Question_Metadata__c>  qmList = new list<Question_Metadata__c>{qm11,qm12,qm13,qm14,qm15,
                                                                               qm21,qm22,qm23,qm24,qm25,
                                                                               qm31,qm32,qm33,qm34,qm35};
         insert qmList;
         
         id parentId = null;
         for(integer i = 0 ; i < qmList.size(); i++){
            if(qmList[i].Type__c == 'TopSection'){
                parentId =  qmList[i].id;           
            } else if(qmList[i].Type__c == 'Section'){
                qmList[i].Question_Metadata_Section__c = parentId;
                parentId =  qmList[i].id;
            } else {
                qmList[i].Question_Metadata_Section__c = parentId;
            }
         }
         
         update qmList; 
         /* PI PV*/
         Question_Metadata_Picklist_Value__c qm14pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[3].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'None');
         Question_Metadata_Picklist_Value__c qm14pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[3].id,
                                                                                        Sequence__c = 2,
                                                                                        Value__c = 'Available');                                                                         
         Question_Metadata_Picklist_Value__c qm15pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[4].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'None');                                                                                                                                         
        Question_Metadata_Picklist_Value__c qm15pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[4].id,
                                                                                                Sequence__c = 2,
        /* GAP PV */                                                                                    Value__c = '1');    
        Question_Metadata_Picklist_Value__c qm23pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[7].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'No Gap/NA');
        Question_Metadata_Picklist_Value__c qm23pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[7].id,
                                                                                                Sequence__c = 2,
                                                                                                Value__c = 'Yes');
        Question_Metadata_Picklist_Value__c qm23pv3 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[7].id,
                                                                                                Sequence__c = 3,
                                                                                                Value__c = 'In Progress');
        Question_Metadata_Picklist_Value__c qm23pv4 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[7].id,
                                                                                                Sequence__c = 4,
                                                                                                Value__c = 'Closed');
        Question_Metadata_Picklist_Value__c qm23pv5 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[7].id,
                                                                                                Sequence__c = 5,
                                                                                                Value__c = 'None');
        Question_Metadata_Picklist_Value__c qm24pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[8].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'None');
        Question_Metadata_Picklist_Value__c qm24pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[8].id,
                                                                                                Sequence__c = 2,
                                                                                                Value__c = 'Yes');
        Question_Metadata_Picklist_Value__c qm24pv3 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[8].id,
                                                                                                Sequence__c = 3,
                                                                                                Value__c = 'No');
        Question_Metadata_Picklist_Value__c qm25pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[9].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'No Gap/NA');
        Question_Metadata_Picklist_Value__c qm25pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[9].id,
                                                                                                Sequence__c = 2,
                                                                                                Value__c = 'Yes');
        Question_Metadata_Picklist_Value__c qm25pv3 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[9].id,
                                                                                                Sequence__c = 3,
                                                                                                Value__c = 'In Progress');
        Question_Metadata_Picklist_Value__c qm25pv4 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[9].id,
                                                                                                Sequence__c = 4,
                                                                                                Value__c = 'Closed');
        Question_Metadata_Picklist_Value__c qm25pv5 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[9].id,
                                                                                                Sequence__c = 5,
                                                                                                Value__c = 'None');
        /* RF  PV*/
        Question_Metadata_Picklist_Value__c qm34pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[13].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'None');
        Question_Metadata_Picklist_Value__c qm34pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[13].id,
                                                                                                Sequence__c = 2,
                                                                                                Value__c = 'Yes');
        Question_Metadata_Picklist_Value__c qm34pv3 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[13].id,
                                                                                                Sequence__c = 3,
                                                                                                Value__c = 'No');
        Question_Metadata_Picklist_Value__c qm35pv1 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[14].id,
                                                                                                Sequence__c = 1,
                                                                                                Value__c = 'None');
        Question_Metadata_Picklist_Value__c qm35pv2 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[14].id,
                                                                                                Sequence__c = 2,
                                                                                                Value__c = 'Yes');
        Question_Metadata_Picklist_Value__c qm35pv3 = new Question_Metadata_Picklist_Value__c(Question_Metadata__c = qmList[14].id,
                                                                                                Sequence__c = 3,
                                                                                                Value__c = 'No');
        list <Question_Metadata_Picklist_Value__c> qmpvList = new list<Question_Metadata_Picklist_Value__c>{qm14pv1, qm14pv2,qm15pv1, qm15pv2,
                                                                                                            qm34pv1, qm34pv2, qm34pv3,qm35pv1,qm35pv2,qm35pv3,
                                                                                                            qm23pv1, qm23pv2, qm23pv3,qm23pv4,qm23pv5,qm24pv1,qm24pv2,qm24pv3,qm25pv1,qm25pv2,qm25pv3,qm25pv4,qm25pv5};
        insert qmpvList;
        
        list<Question_Metadata__c> result = new list<Question_Metadata__c>{qm13,qm14,qm15,qm23,qm24,qm25,qm33,qm34,qm35};
        return result;
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
    
}