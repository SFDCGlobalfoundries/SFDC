/******************************************************************************************************
    Class Name:    BX041_NewQuestionInsert_Test 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This is the test Class for BX041_NewQuestionInsert
    History: 
      PS           11152013    - Code creation.
      Vijay     16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*******************************************************************************************************/
@isTest(SeeAllData=false)

   
public class  BX041_NewQuestionInsert_Test {
    
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static Id createAccount() {
        // Create Account
        Account testAcct = new Account();
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        
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
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return DeviceDataFactory.createDevice(fieldValueMap);  
    }
    static BX_041__c createBX041(ID deviceID){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        insert bx041;  
        return bx041;  
    }
    
    static List<Process_Information__c> createPI (id bx041ID, List<Question_Metadata__c>  qmList, string templateName){
        List<Process_Information__c> insertList = new List<Process_Information__c>();
         for(Question_Metadata__c qm : qmList){
            Process_Information__c pi = new Process_Information__c(BX_041__c = bx041ID );
            pi.Comments__c = 'Test Comment';
            pi.Customer_Comment__c = 'Test CustComment';
            pi.Customer_Request__c = 'Test';
            pi.FE_Requested_Information__c = '';
            pi.mandatory__c = qm.Mandatory__c || (qm.Mandatory_for_Templates__c != null ? qm.Mandatory_for_Templates__c.contains(templateName):false);
            pi.PIYE__c = '';
            pi.Question__c = qm.Question__c;
            pi.Question_Metadata__c = qm.id;
            pi.Question_to_Display__c = qm.Question_to_Display__c;
            pi.Requirement_Gaps__c = 'test';
            
            insertList.add(pi);
        }
        insert insertList;
        return insertList;
    }
    
     static String getTemplate(String geometry){
        Decimal GeomValue ;
        String TempName; 
        if(geometry!= null || geometry != ''){
            GeomValue = Decimal.ValueOf(geometry.replace('UM',''));
            if(GeomValue <= 0.032 ){
                TempName = 'Geometry 32nm/28nm & below';
                
            }
            else if(GeomValue >= 0.040 && GeomValue <= 0.045){
                TempName = 'Geometry 45nm - 40nm';
            }
            else if(GeomValue >= 0.055 && GeomValue <= 0.090){
                TempName= 'Geometry 90nm - 55nm';
            }
            else if(GeomValue >= 0.11 && GeomValue <= 0.13){
                TempName= 'Geometry 0.11um - 0.13um';
            }
            else if(GeomValue >= 0.14 && GeomValue <= 0.25){
                TempName= 'Geometry 0.14um - 0.25um';
            }
            else if(GeomValue >= 0.30){
                TempName= 'Geometry 0.30um & Greater';
            }
            else{
                TempName = 'None';
            }
        }
        return TempName;
    }
    static list<Question_Metadata__c> getQuestionMt(){
        return [select id, 
                       Mandatory_for_Templates__c,
                       Mandatory__c,
                       Record_Type__c,
                       Question__c,
                       Question_to_Display__c
                from Question_Metadata__c where (type__c = 'picklist' or type__c = 'text') and (Record_type__c ='Process Id') order by sequence__c];
    }
    
    /******************************************************************************************************
    @Method Name:    testMethodBX041_Question
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Test Method
    *******************************************************************************************************/    
    static testmethod void testMethodBX041_Question()
    {
        
        //Test Data creation: 
        
        
        String testAcctId = BX041_NewQuestionInsert_Test.createAccount();
        String testOpptyId = BX041_NewQuestionInsert_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = BX041_NewQuestionInsert_Test.createOpportunityProgram(testAcctId, testOpptyId);
        test.startTest();
        Device__c testDevice = BX041_NewQuestionInsert_Test.createDevice(testAcctId, testOpptyProgramId);
        BX_041__c bx041 = BX041_NewQuestionInsert_Test.createBX041(testDevice.id);
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        
       
        
        List<Question_Metadata__c> qstnMetadata = BX041_NewQuestionInsert_Test.getQuestionMt();
        
        
        String tempName = BX041_NewQuestionInsert_Test.getTemplate('0.055UM');
        //BX041_NewQuestionInsert_Test.createPI (bx041.id,qstnMetadata,tempName); 
        id qmid = BX041_NewQuestionInsert_Test.createQuestionMt();
        BX041_NewQuestionInsert.MethodBX041_QuestionInsert(qmid);

        test.stopTest();
        
    }
    
    static id createQuestionMt(){
        
        //Question_Metadata__c qm1 = [select id from Question_Metadata__c where Sequence__c = 10100 ];
        
        Question_Metadata__c qm1010 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = '',
                                                            Mandatory__c = false,
                                                            Question__c = 'Testing',
                                                            Record_Type__c = 'Process Id',
                                                            //Question_Metadata_Section__c = qm1.id,
                                                            Sequence__c = 101010,
                                                            Mandatory_for_Templates__c= 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Text');
                                                                                                                                                                                                                                                 
        insert qm1010;
        return qm1010.id;
        
    }

}