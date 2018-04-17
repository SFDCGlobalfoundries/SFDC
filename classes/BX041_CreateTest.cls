/*
 Type Name: BX041_Create Test
 Author: Prosenjit Saha and Thomas Lai
 Created Date: 19-Aug-2013
 Reason: This is the test class for 'BX041_Create' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
     DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
  Devendra  10142015      - Updated to fix device validation error
*/


@isTest(SeeAllData=false)
private class BX041_CreateTest
{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
	
	Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'MyTestACC1');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');  
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
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
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
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
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty;
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
    
     static Id createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'MEMS - Inertial');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'Single Product');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('PTRF_ID__c','test');
        
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
    }
    
    static Device__c createDevicePM(Id testAcctId, Id testOpptyProgramId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'MEMS - Inertial');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'Single Product');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('OwnerId',UserInfo.getUserID());
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static Device__c createDevicePM1(Id testAcctId, Id testOpptyProgramId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'MEMS - Inertial');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'Single Product');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('OwnerId',UserInfo.getUserID());
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
        process1 = [select id, name from process__c where id = : process1.id];
        return process1;
    }
    
    
    /*
    static testmethod void submit(){
        String testAcctId = BX041_CreateTest.createAccount();
        String testOpptyId = BX041_CreateTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_CreateTest.createOpportunityProgram(testAcctId, testOpptyId);
        String testDeviceId = BX041_CreateTest.createDevice(testAcctId, testOpptyProgramId);
        BX_041__c  bx041 = new BX_041__c();
        
        PageReference pageRef = Page.BX041_Create_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL',testDeviceId);   
        BX041_Create ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        ctrl.save();
        bx041 = ctrl.bx041;
        PageReference pageRef2 = Page.BX041_View_Page;
        Test.setCurrentPage(pageRef2); 
        
        test.StartTest();
        //BX041_Edit ctrl2 = new BX041_Edit(new ApexPages.StandardController(bx041));
        test.StopTest();   
    }*/
    static void createQuestionMt(){
        
        Question_Metadata__c qm11 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Process Id',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10000,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm12 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Process Information',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10100,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Section');
        Question_Metadata__c qm13 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Process_field_API_name__c = 'PID_NUMBER__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'PLM PID',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10101,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Text');
        Question_Metadata__c qm14 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'POLY_GATE_TYPE__c',
                                                            Mandatory__c = true,
                                                            Question_to_Display__c = 'Gate Type',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10102,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');   
        Question_Metadata__c qm15 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'CORE_VOLTAGES__c',
                                                            Mandatory__c = true,
                                                            Question_to_Display__c = 'Core Voltage/s (V)',
                                                            Record_Type__c = 'Process Id',
                                                            Sequence__c = 10103,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');  
        
        /*====== GAP Analyis ====================== */
        Question_Metadata__c qm21 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Gap Analysis',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20000,
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm22 = new Question_Metadata__c(API_Name__c = 'c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Basic Information',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20100,
                                                            Type__c = 'Section'); 
        Question_Metadata__c qm23 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'PID',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20101,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm24 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = true,
                                                            Question_to_Display__c = 'Does the Process require a customized development ?',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20102,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm25 = new Question_Metadata__c(API_Name__c = 'Gap_Analysis_Form__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'IP QA Status',
                                                            Record_Type__c = 'Gap Analysis',
                                                            Sequence__c = 20103,
                                                            Type__c = 'Picklist');                                                                                                                                                                                                                                          
        /*====== RF Analyis ====================== */
        Question_Metadata__c qm31 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Gap Analysis',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30000,
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm32 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Basic Information',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30100,
                                                            Type__c = 'Section'); 
        Question_Metadata__c qm33 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Stack MIM',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30101,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm34 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'RF LDMOS',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 30102,
                                                            Type__c = 'Picklist');
        Question_Metadata__c qm35 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Additional Well',
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
    @isTest static  void saveClose(){
        
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = BX041_CreateTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_CreateTest.createOpportunityProgram(testAcctId, testOpptyId);
	test.StartTest();
        String testDeviceId = BX041_CreateTest.createDevice(testAcctId, testOpptyProgramId);
        BX_041__c  bx041 = new BX_041__c();
        //BX041_CreateTest.createQuestionMt();
        Process__c process1 = createProcess();
        
        PageReference pageRef = Page.BX041_Create_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL',testDeviceId);  
        ApexPages.currentPage().getHeaders().put('host','www.salesforce.com'); 
        BX041_Create ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        ctrl.bx041.Need_RF__c = true;
        
        for(BX041_Create.TopSectionWrapper tsw :ctrl.topSecWrapperList){
            for( BX041_Create.SectionWrapper sw: tsw.sectionList)   {
                for( BX041_Create.RowWrapper rw : sw.rowList){
                    if(rw.fieldType == 'Text'){
                        rw.value = 'Test';
                    }else if(rw.fieldType == 'Picklist'){
                        rw.value = 'None';
                        /*if('IP QA Status' == rw.question2Display){
                            rw.value = 'None';
                        }*/
                    }
                }
            }
        }
        ctrl.bx041.Process_ID_is_known__c = 'Yes';
        ctrl.bx041.Reference_Process_ID_txt__c = process1.Name;
        ctrl.saveAndClose();
        test.StopTest();
        //System.assertEquals(nextPage, '/'+testDeviceId);
    }
    
    
    static testmethod void save(){
        
        Process__c process = BX041_CreateTest.createProcess();
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = BX041_CreateTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_CreateTest.createOpportunityProgram(testAcctId, testOpptyId);
	test.StartTest();
        String testDeviceId = BX041_CreateTest.createDevice(testAcctId, testOpptyProgramId);
        IP__c testIP = createIP();
        IP_Merge__c testIPM = createIPMerge();
        
        BX_041__c  bx041 = new BX_041__c();
        //BX041_CreateTest.createQuestionMt();
        
        PageReference pageRef = Page.BX041_Create_Page;
        Test.setCurrentPage(pageRef);      
        
        ApexPages.currentPage().getParameters().put('retURL',testDeviceId);   
        ApexPages.currentPage().getHeaders().put('host','www.salesforce.com');
        BX041_Create ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        ctrl.bx041.Need_IP_information__c = true;
        //ctrl.getDynamicComp();
        BX041_IP__c bx041Ip = ctrl.ipwList[0].bx041Ip;
        bx041Ip.IP_Type__c = testIP.IP_Type__c;
        ApexPages.currentPage().getParameters().put('ipSeq','0');        
        ctrl.onchangeIPType();
        bx041ip.IP_Master__c = testIP.Id;
        ctrl.onchangePopulateIP();
        ctrl.displayPopup = true;
        ctrl.getDynamicComp();
        ctrl.saveIpPopup();
        ctrl.editIp();   
        ctrl.cancelIpPopup();
        
        ctrl.addIp();
        bx041Ip = ctrl.ipwList[1].bx041Ip;
        bx041Ip.IP_Type__c = testIP.IP_Type__c;
        bx041ip.IP_Master__c = testIP.Id;
        ApexPages.currentPage().getParameters().put('ipSeq','1');
        ctrl.onchangePopulateIP();
        ctrl.remIp();
        
        ctrl.addIp();
        bx041Ip = ctrl.ipwList[1].bx041Ip;
        bx041Ip.remarks__c = 'test';
        ctrl.saveIpPopup();
        
        ctrl.bx041.Need_IP_Merge_information__c = true;
        BX041_IP_Merge__c bx041Ipm = ctrl.ipmList[0];
        bx041Ipm.IP_Master__c = testIPM.Id;
        ctrl.addIpm();
        bx041Ipm = ctrl.ipmList[1];
        bx041Ipm.IP_Master__c = testIPM.Id;
        ctrl.remIpm();
        
        ctrl.addIpm();
        bx041Ipm = ctrl.ipmList[1];
        bx041Ipm.Remarks__c = 'test';
        
        ctrl.bx041.Process_ID_is_known__c = 'Yes';
        ctrl.bx041.Reference_Process_ID_txt__c = process.name;
        //ctrl.bx041.Requested_Process_ID__c = process.id;
        //ctrl.onchangePopulateFEComments();
        
        for(BX041_Create.TopSectionWrapper tsw :ctrl.topSecWrapperList){
            for( BX041_Create.SectionWrapper sw: tsw.sectionList)   {
                for( BX041_Create.RowWrapper rw : sw.rowList){
                    if(rw.fieldType == 'Text'){
                        rw.value = 'Test';
                    }else if(rw.fieldType == 'Picklist'){
                        rw.value = 'None';
                        if('Does the Process require a customized development ?' == rw.question2Display){
                            rw.value = 'None';
                        }
                    }
                }
            }
        }
        String nextPage = ctrl.save() != null ? ctrl.save().getUrl() : '' ;
        
        test.StopTest();
        //System.assertEquals(nextPage, '/'+ctrl.bx041.id);
    }
    
    static IP__c createIP(){
        
        IP__c ip = new IP__c(IP_Type__c = 'IO',
                            Latest_Version__c = '20',
                            IP_Vendor__c = 'Test',
                            PH1_QA_Status__c = 'NCR',
                            Showstopper__c = 'Yes');
        insert ip;
        return ip;
    }
    static IP_Merge__c createIPMerge(){
        IP_Merge__c ipm = new IP_Merge__c(IP_Type__c = 'IO',
                                            Latest_Version__c = '20',
                                            IP_Vendor__c = 'Test',
                                            PH1_QA_Status__c = 'NCR',
                                            Showstopper__c = 'Yes');
        insert ipm;
        return ipm;
    }
    
    @isTest static  void testRun1(){
       
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = BX041_CreateTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_CreateTest.createOpportunityProgram(testAcctId, testOpptyId);
        Process__c process = BX041_CreateTest.createProcess();
        
        
        Test.startTest();
        
        //String testDeviceId = BX041_CreateTest.createDevice(testAcctId, testOpptyProgramId);
        
        Device__c device = createDevicePM(testAcctId,testOpptyProgramId);
       /* device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // Testing only for 'design in'
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.OwnerId = UserInfo.getUserID();
        
        insert device;*/
        
        System.debug('device : ' + device.OwnerId);
        System.debug('device : ' + device.Owner.name);
        
        BX_041__c  bx041 = new BX_041__c();
        //BX041_CreateTest.createQuestionMt();
        //Process__c process1 = createProcess();
        
        PageReference pageRef = Page.BX041_Create_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL', '/GlobalfoundryView//' + device.Id);  
        ApexPages.currentPage().getHeaders().put('host','www.salesforce.com'); 
        BX041_Create ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        
        ApexPages.currentPage().getParameters().put('retURL', device.Id);  
        ApexPages.currentPage().getHeaders().put('host','www.globalfoundryview.com'); 
        ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        
        ctrl.deviceOwnerName = 'Test';
        ctrl.deviceOwnerId = UserInfo.getUserID();
        Test.stopTest();
    }
    
     @isTest static  void testRun2(){
       
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = BX041_CreateTest.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_CreateTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        Test.startTest();
        
        //String testDeviceId = BX041_CreateTest.createDevice(testAcctId, testOpptyProgramId);
        
        Device__c device = createDevicePM1(testAcctId,testOpptyProgramId);
        /*device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // Testing only for 'design in'
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.OwnerId = UserInfo.getUserID();
        
        insert device;*/
        
        createQuestionMt();
        IP__c testIP = createIP();
        
        BX_041__c  bx041 = new BX_041__c();
        //BX041_CreateTest.createQuestionMt();
        //Process__c process1 = createProcess();
        
        PageReference pageRef = Page.BX041_Create_Page;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL', device.Id);  
        ApexPages.currentPage().getHeaders().put('host','www.salesforce.com'); 
        BX041_Create ctrl = new BX041_Create(new ApexPages.StandardController(bx041));
        
        ctrl.bx041.Need_IP_information__c  = true;
        ctrl.bx041.Need_IP_Merge_information__c  = true;
        
        ctrl.bx041.Process_ID_is_known__c = 'Yes';
        ctrl.bx041.Reference_Process_ID_txt__c  = null;
        ctrl.saveAndClose();
        
        Process__c processObj = new Process__c();
        processObj.Name = 'Test Process1';
        processObj.Available_to_Sell__c = 'Available';//Prototype Ready; MPW Ready;'Registered/TBO
        //processObj.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        processObj.Bias_Table_Spec__c = 'Test bais tabel spec';
        processObj.Tech_Geometry__c = '0.055UM';
        processObj.Process_Family__c = 'MEMS';
        insert processObj;
        
        ctrl.bx041.Reference_Process_ID_txt__c  = processObj.Name;
        ctrl.bx041.Requested_Process_ID__c  = processObj.Id;
        ctrl.bx041.Process_Family_Filter__c  = processObj.Process_Family__c;
        ctrl.bx041.Geometry_Filter__c  = processObj.Tech_Geometry__c;
        ctrl.saveAndClose();
        
        ctrl.bx041.Reference_Process_ID_txt__c  = null;
        ctrl.bx041.Process_ID_is_known__c  = 'No';
        ctrl.bx041.Requested_Process_ID__c  = processObj.Id;
        ctrl.bx041.Process_Family_Filter__c  = processObj.Process_Family__c;
        ctrl.bx041.Geometry_Filter__c  = 'Temp';
        ctrl.saveAndClose();
        
        ctrl.getFields();
        
        ctrl.currentIP.stepNo = '2';
        ctrl.cancelIpPopup();
        
        ctrl.currentIP.stepNo = '3';
        ctrl.saveIpPopup();
        
        ctrl.getDynamicComp();
        
        Test.stopTest();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}