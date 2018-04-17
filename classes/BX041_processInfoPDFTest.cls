/*
 Type Name: BX041_processInfoPDFTest
 Author: Prosenjit Saha and Thomas Lai
 Created Date: 10-Oct-2013
 Reason: This is the test class for 'BX041_processInfoPDF ' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
Ashwini     05132015    - Updated code for refactoring of test class. 
  Devendra  10142015      - Updated to fix device validation error                                
*/


@isTest(SeeAllData=false)
private class BX041_processInfoPDFTest
{
    @testSetup static void testdata() {
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
        fieldValueMap.put('Process_Family__c','Generic / Nomina');
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }

    static Opportunity createOpportunity1(Id testAcctId) {
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
        fieldValueMap.put('Process_Family__c','Generic / Nomina');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
                
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
        fieldValueMap.put('Name','TESTDEVICESP');
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now());
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        
        return DeviceDataFactory.createDevice(fieldValueMap);  
    }
    static Process__c createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Available';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        insert process1;
        return process1;
    }
    static BX_041__c createBX041(ID deviceID, ID reqProcID, ID AssgnProcID){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        insert bx041;
        //bx041.Assigned_Process_ID__c = AssgnProcID;
        //bx041.Requested_Process_ID__c = reqProcID;
        //update bx041;  
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
   
    
    
    /***********************************************************************************************
        This method helps to test the generate PDF/excel functionality in View page.
        
        @method name: testBX041_processInfoPDF 
       
     ***********************************************************************************************/
     static testmethod void testBX041_processInfoPDF (){
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = BX041_processInfoPDFTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_processInfoPDFTest.createOpportunityProgram(testAcctId, testOpptyId);
        test.startTest();
        Device__c testDevice = BX041_processInfoPDFTest.createDevice(testAcctId, testOpptyProgramId);
        Process__c process1 = BX041_processInfoPDFTest.createProcess();
        Process__c process2 = BX041_processInfoPDFTest.createProcess();
        createQuestionMt();
        //test.startTest();
        BX_041__c bx041 = BX041_processInfoPDFTest.createBX041(testDevice.id,process1.id,process1.id);
        
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        for(Question_metadata__c  qm : [SELECT   id,
                                                 name,
                                                 Record_Type__c,
                                                 Type__c,
                                                 Question__c,
                                                 Mandatory__c,
                                                 Mandatory_for_Templates__c,
                                                 Template_Name__c,
                                                 Question_Metadata_Section__c
                                      FROM       Question_Metadata__c
                                      WHERE      (Type__c = 'Picklist' 
                                      OR         Type__c = 'Text')]){
            if(MapPicklist.get(qm.Record_Type__c) == NULL){
                List<id> i = new List<id>();
                i.add(qm.id);
                MapPicklist.put(qm.Record_Type__c , i);
            }
            else{
                MapPicklist.get(qm.Record_Type__c).add(qm.id);    
            }                                  
        }
        test.stopTest();
        BX041_processInfoPDFTest.createPI (bx041.id,MapPicklist.get('Process Id'));
        
        ApexPages.currentPage().getParameters().put('Id', bx041.id);  
        
            BX041_processInfoPDF testController = new BX041_processInfoPDF( new ApexPages.StandardController(bx041));   
        
        
     }
     
     static void createQuestionMt(){
        
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
                                                            Process_field_API_name__c = 'POLY_GATE_TYPE__c',
                                                            Mandatory__c = true,
                                                            Question__c = 'Gate Type',
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
                                                                                        Value__c = 'Dualcide');                                                                         
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
    }
 
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}