/********************************************************************************************************
    Class Name:    BX041_EditTest 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This is test class for BX041_Edit
    Created Date: 
      PS           07102013    - Code creation.
      TL            27022014    - Code Modification
    Change History:
      Vijay     16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
      Vijay     04232015    - added test methods for Internal Device
    Devendra  10142015      - Updated to fix device validation error
 
*********************************************************************************************************/

@isTest(SeeAllData=false)
private class BX041_EditTest
{
    
    /**
        This method helps to test the BX041 record Edit functionalities along with the record submit and other approval process
        functionalities.
        
        @method name: testBX041_Edit
       
     */
     
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables(); 
        
        Test.startTest();
        
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
        
        Account testAcct = AccountDataFactory.createAccount(fieldValueMap);
        
        Contact testContact = new Contact();
        testContact.accountid = testAcct.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;
        
        
    Map<String,Object> fieldValueMapOpp = new Map<String,Object>();
        fieldValueMapOpp.put('AccountId',testAcct.Id);
        fieldValueMapOpp.put('Name','Test Opportunity');  
        fieldValueMapOpp.put('StageName','1. Discovery');
        fieldValueMapOpp.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMapOpp.put('Target_Process_Node__c','14XM');
        fieldValueMapOpp.put('Market_Segment__c','Mobility');  
        fieldValueMapOpp.put('Process_Platform__c','GF Baseline');
        fieldValueMapOpp.put('Fab_Split__c',100);          
        fieldValueMapOpp.put('Process_Geometry__c','0.055UM');  
        fieldValueMapOpp.put('Process_Family__c','MEMS');
        
        OpportunityDataFactory.createOpportunity(fieldValueMapOpp);
        
        Test.stopTest();
    }
    
    
    static Id createAccount() {
        Account accountObj = [SELECT Id FROM Account WHERE Name = 'MYTEST ACCOUNT1' LIMIT 1];
        return accountObj.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        Opportunity opportunityObj = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        return opportunityObj.Id;
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
    
    static Id createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        
        insert m;
        return m.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        Id mpwId = createMPW();
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');
        fieldValueMap.put('Process_Family_Filter__c', 'MEMS');
        fieldValueMap.put('End_Application__c', 'Body');    
        fieldValueMap.put('Confidence_Level_Tapeout__c', '40'); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', System.today());   
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier' );
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        fieldValueMap.put('MPW_Train_Number__c',mpwId);
        
        return DeviceDataFactory.createDevice(fieldValueMap);  
        
    }
    static Device__c createDevicePM(Id testAcctId,Id testOpptyProgramId){
        Id mpwId = createMPW();

        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 1');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Confidence_Level_Tapeout__c','40');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('MPW_Train_Number__c',MPWID);
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    static Device__c createDevicePM1(Id testAcctId, Id testOpptyProgramId){
        Id mpwId = createMPW();

        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 1');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');          
        fieldValueMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Confidence_Level_Tapeout__c','40');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('MPW_Train_Number__c',MPWID);
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today().addDays(5));
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    static Process__c createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Registered/TBO';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        process1.CORE_VOLTAGES__c = '15V';
        insert process1;
        return process1;
    }
    
    static Process__c createProcess2(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process2';
        process1.Available_to_Sell__c = 'Prototype Ready';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        process1.CORE_VOLTAGES__c = '20V';
        insert process1;
        return process1;
    }
    static BX_041__c createBX041(Device__c device){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.ID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        bx041.CRMDID__c = device.CRMDID__c ;
        //bx041.Template_Name__c = 'Geometry 90nm - 55nm';
        //bx041.Assigned_Process_ID__c = AssgnProcID;
        //bx041.Requested_Process_ID__c = reqProcID;
        bx041.Need_IP_information__c = true;
        bx041.Need_IP_Merge_information__c = true;
        bx041.GAP_Closed__c = false;
        insert bx041;  
        return bx041;  
    }
    
    static BX_041__c createBX041_2(Device__c device, id AssgnProcID){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.ID;
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        bx041.CRMDID__c = device.CRMDID__c ;
        //bx041.Template_Name__c = 'Geometry 90nm - 55nm';
        bx041.Assigned_Process_ID__c = AssgnProcID;
        //bx041.Requested_Process_ID__c = reqProcID;
        bx041.Need_IP_information__c = true;
        bx041.Need_IP_Merge_information__c = true;
        bx041.GAP_Closed__c = false;
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
    
    static List<Gap_Analysis_Form__c> createGA (id bx041ID,List<id>  questionMetadataIDList){
        List<Gap_Analysis_Form__c > insertList = new List<Gap_Analysis_Form__c >();
        for(id questionMetadataID : questionMetadataIDList){
            Gap_Analysis_Form__c ga = new Gap_Analysis_Form__c  (BX_041__c = bx041ID );
            ga.APTS_Comments__c = null;
            ga.Gap_Name__c = 'test';
            ga.Question_Metadata__c = questionMetadataID ; 
            ga.APTS_Resolution__c = null;
            ga.APTS_Status__c = 'Closed';
            insertList.add(ga);
        }
        insert insertList ;
        return insertList ;
    }
    static string createIP(){
        
        IP__c ip = new IP__c(IP_Type__c = 'IO',
                            Latest_Version__c = '20',
                            IP_Vendor__c = 'Test',
                            PH1_QA_Status__c = 'NCR',
                            Showstopper__c = 'Yes');
        insert ip;
        return ip.id;
    }
    static string createIPMerge(){
        IP_Merge__c ipm = new IP_Merge__c(IP_Type__c = 'IO',
                                            Latest_Version__c = '20',
                                            IP_Vendor__c = 'Test',
                                            PH1_QA_Status__c = 'NCR',
                                            Showstopper__c = 'Yes');
        insert ipm;
        return ipm.id;
    }
    
    static List<BX041_IP__c> createBXIP (id bx041ID ,List<id> IPdesignKitIDList){
        List<BX041_IP__c> insertList = new List<BX041_IP__c>();
        for(id IPdesignKitID : IPdesignKitIDList){
            BX041_IP__c ip = new BX041_IP__c (BX_041__c = bx041ID);
            ip.IP_Type__c = 'IO';
            ip.IP_Master__c = IPdesignKitID;
            insertList.add(ip);
        }
        insert insertList ;
        return insertList ;
    
    }
    
    static List<BX041_IP_Merge__c> createBXIPM (id bx041ID, List<id> ipMergeIDList){
        List<BX041_IP_Merge__c > insertList = new List<BX041_IP_Merge__c >();
        for(id ipMergeID : ipMergeIDList){
            BX041_IP_Merge__c ipm = new BX041_IP_Merge__c(BX_041__c = bx041ID);
            ipm.GF_Supported_IP__c = true;
            ipm.IP_Master__c = ipMergeID;
            ipm.Remarks__c = 'test';
            ipm.Merge_Kit_Name__c = 'Test';
            insertList.add(ipm);
        }
        insert insertList ;
        return insertList ;
    
    }
     
    static List<RF__c> createRF (id bx041ID ,List<id> questionMetadataIDList){
        List<RF__c> insertList = new List<RF__c>();
        for(id questionMetadataID : questionMetadataIDList){
            RF__c rf= new RF__c (BX_041__c = bx041ID);
            rf.Question_Metadata__c = questionMetadataID;
            rf.RF_Name__c = 'test';
            rf.Value__c = 'test';
            insertList.add(rf);
        }
        insert insertList ;
        return insertList ;
    } 
    
    static List<Non_Volatile_Memory__c> createNVM (id bx041ID ,List<id> questionMetadataIDList){
        List<Non_Volatile_Memory__c> insertList = new List<Non_Volatile_Memory__c>();
        for(id questionMetadataID : questionMetadataIDList){
            Non_Volatile_Memory__c nvm= new Non_Volatile_Memory__c (BX_041__c = bx041ID);
            nvm.Question_Metadata__c = questionMetadataID;
            nvm.NVM_Name__c = 'test';
            nvm.Value__c = 'test';
            insertList.add(nvm);
        }
        insert insertList ;
        return insertList ;
    }
    
    static List<High_Voltage__c> createHV (id bx041ID ,List<id> questionMetadataIDList){
        List<High_Voltage__c > insertList = new List<High_Voltage__c >();
        for(id questionMetadataID : questionMetadataIDList){
            High_Voltage__c HV= new High_Voltage__c (BX_041__c = bx041ID);
            HV.Question_Metadata__c = questionMetadataID;
            HV.High_Voltage_Name__c = 'test';
            HV.Value__c = 'test';
            insertList.add(HV);
        }
        insert insertList ;
        return insertList ;
    }
    
    static List<PowerMOS__c> createPowerMOS (id bx041ID ,List<id> questionMetadataIDList){
        List<PowerMOS__c > insertList = new List<PowerMOS__c >();
        for(id questionMetadataID : questionMetadataIDList){
            PowerMOS__c pmos= new PowerMOS__c (BX_041__c = bx041ID);
            pmos.Question_Metadata__c = questionMetadataID;
            pmos.PowerMOS_Name__c = 'test';
            pmos.Value__c = 'test';
            insertList.add(pmos);
        }
        insert insertList ;
        return insertList ;
    }
    
    static List<eDRAM__c> createeDRAM (id bx041ID ,List<id> questionMetadataIDList){
        List<eDRAM__c > insertList = new List<eDRAM__c >();
        for(id questionMetadataID : questionMetadataIDList){
            eDRAM__c edram= new eDRAM__c (BX_041__c = bx041ID);
            edram.Question_Metadata__c = questionMetadataID;
            edram.eDRAM_Name__c = 'test';
            edram.Value__c = 'test';
            insertList.add(edram);
        }
        insert insertList ;
        return insertList ;
    }
    
    static List<Turnkey__c>  createTurnkey (id bx041ID ,List<id> questionMetadataIDList){
        List<Turnkey__c > insertList = new List<Turnkey__c >();
        for(id questionMetadataID : questionMetadataIDList){
            Turnkey__c turnkey = new Turnkey__c (BX_041__c = bx041ID);
            turnkey.Question_Metadata__c = questionMetadataID;
            turnkey.Turnkey_Name__c = 'test';
            turnkey.Value__c = 'test';
            insertList.add(turnkey);
        }
        insert insertList ;
        return insertList ;
    }
    
    static List<MEMS__c> createMEMS  (id bx041ID ,List<id> questionMetadataIDList){
        List<MEMS__c > insertList = new List<MEMS__c >();
        for(id questionMetadataID : questionMetadataIDList){
            MEMS__c mems = new MEMS__c (BX_041__c = bx041ID);
            mems.Question_Metadata__c = questionMetadataID;
            mems.MEMS_Name__c = 'test';
            mems.Value__c = 'test';
            insertList.add(mems);
        }
        insert insertList ;
        return insertList ;
    }
    
    
    static list<Question_Metadata__c> createQuestionMt(){
        return [select id, Mandatory__c,Record_Type__c from Question_Metadata__c where (type__c = 'picklist' or type__c = 'text') and (Record_type__c = 'Process Id' or Record_type__c = 'RF' or Record_type__c ='Gap Analysis') order by sequence__c];
    }
    
    static testmethod void testBX041_update(){
    
        
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
       
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        test.startTest(); 
        Device__c testDevice = BX041_EditTest.createDevice(testAcctId, testOpptyProgramId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        
       Process__c process1 = BX041_EditTest.createProcess();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getQueries());
        BX_041__c bx041 = BX041_EditTest.createBX041(testDevice);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getQueries());
        
        
        List<id> ipMasterList = new List<id>();
        ipMasterList.add(createIP());
        
        List<id> ipMergeMasterList = new List<id>();
        ipMergeMasterList.add(createIPMerge());
        
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        List<Question_Metadata__c> qstnMetadata = createQuestionMt();
        if(qstnMetadata.size() > 0){
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
        }
        
        List<String> recordTypeList = new String []{ 'Process Id','Gap Analysis','MEMS','PowerMOs','Turnkey','NVM','RF','High Voltage','eDRAM','IP','IPMerge'};
        //test.startTest();
        for(String rt : recordTypeList ){
            if(MapPicklist.get(rt) != NULL){
                if(rt == 'Process Id')         BX041_EditTest.createPI (bx041.id,MapPicklist.get(rt));
                else if(rt == 'Gap Analysis')  BX041_EditTest.createGA (bx041.id,MapPicklist.get(rt)); 
                else if(rt == 'RF')            BX041_EditTest.createRF (bx041.id,MapPicklist.get(rt));
                else if(rt == 'IPMerge')       BX041_EditTest.createBXIPM (bx041.id,ipMergeMasterList);
                else if(rt == 'IP')            BX041_EditTest.createBXIP (bx041.id,ipMasterList);
            }
        }
        test.stopTest();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context5: ' +  Limits.getQueries());
        Pagereference pf = page.bx041_edit_page; 
        Test.setCurrentPage(pf);
            
        ApexPages.currentPage().getParameters().put('Id', bx041.id); 
        ApexPages.currentPage().getHeaders().put('host','www.salesforce.com'); 
        //test.startTest();
        BX041_Edit testController = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        testController.bx041.Process_ID_is_known__c = 'Yes';
        testController.bx041.Reference_Process_ID_txt__c = 'Test Process1';
        testController.bx041.Need_IP_information__c = true;
        testController.bx041.Need_IP_Merge_information__c = true;
        testController.onchangePopulateFEComments();
        for(BX041_Edit.TopSectionWrapper tsw :testController.WrapperTopSectionList){
            for(BX041_Edit.SectionWrapper sw: tsw.AllWrapperSection){
                for(BX041_Edit.RowWrapper rw: sw.WrapperList){
                    if(rw.fieldType == 'Picklist'){
                        SelectOption so = rw.CustInfoList[0];
                        rw.value = so.getValue();
                    } else {
                        rw.value = 'test';
                    }
                    
                }
            }
        }
        testController.addIpm();
        testController.ipmList[0].Ip_master__c = createIPMerge();
        testController.addIp();
        testController.ipwList[0].bx041ip.ip_type__c = 'IO';
        testController.ipwList[0].bx041ip.ip_master__c = createIp();
        ApexPages.currentPage().getParameters().put('ipSeq','0');
        testController.onchangePopulateIP();
        testController.displayPopup = true;
        testController.getDynamicComp();
        ApexPages.currentPage().getParameters().put('ipSeq','0');
        testController.saveIpPopup();
        
        pf = testController.updatebx041();
        testController.reopen();
        
        testController.submitForApproval();
        
        
    }
    
    static testmethod void testBX041_Edit()
    {
        
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
         Process__c process1 = BX041_EditTest.createProcess();
        test.startTest();
        Device__c testDevice = BX041_EditTest.createDevice(testAcctId, testOpptyProgramId);
        
       
        
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        //Process__c process2 = BX041_EditTest.createProcess();
        BX_041__c bx041 = BX041_EditTest.createBX041(testDevice);
        
        System.debug('2nd Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getQueries());
        List<id> ipMasterList = new List<id>();
        ipMasterList.add(createIP());
        
        
        List<id> ipMergeMasterList = new List<id>();
        ipMergeMasterList.add(createIPMerge());
        
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        List<Question_Metadata__c> qstnMetadata = BX041_EditTest.createQuestionMt();
        
        System.debug('qstnMetadata ' +qstnMetadata.size() );
        if(qstnMetadata.size() > 0){
            for(Question_metadata__c  qm : qstnMetadata ){
            System.debug('MapPicklist Before' +MapPicklist.get(qm.Record_Type__c));
                if(MapPicklist.get(qm.Record_Type__c) == NULL){
                    List<id> i = new List<id>();
                    i.add(qm.id);
                    MapPicklist.put(qm.Record_Type__c , i);
                    System.debug('MapPicklist Before1' +MapPicklist.get(qm.Record_Type__c));
                }
                else{
                    MapPicklist.get(qm.Record_Type__c).add(qm.id);   
                    System.debug('MapPicklist Before2' +MapPicklist.get(qm.Record_Type__c)); 
                }   
                System.debug('MapPicklist After' +MapPicklist.get(qm.Record_Type__c));                               
            } 
        }
            User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
            
            
            
            List<String> recordTypeList = new String []{ 'Process Id','Gap Analysis','MEMS','PowerMOs','Turnkey','NVM','RF','High Voltage','eDRAM','IP','IPMerge'};
            System.debug('MapPicklist' +MapPicklist);
            //test.startTest();
            for(String rt : recordTypeList ){
                if(MapPicklist.get(rt) != NULL){
                    if(rt == 'Process Id')         BX041_EditTest.createPI (bx041.id,MapPicklist.get(rt));
                    else if(rt == 'Gap Analysis')  BX041_EditTest.createGA (bx041.id,MapPicklist.get(rt)); 
                    //else if(rt == 'MEMS')          BX041_EditTest.createMEMS (bx041.id,MapPicklist.get(rt));
                    //else if(rt == 'PowerMOs')      BX041_EditTest.createPowerMOS (bx041.id,MapPicklist.get(rt));
                    //else if(rt == 'Turnkey')       BX041_EditTest.createTurnkey (bx041.id,MapPicklist.get(rt));
                    //else if(rt == 'NVM')           BX041_EditTest.createNVM (bx041.id,MapPicklist.get(rt));
                    else if(rt == 'RF')            BX041_EditTest.createRF (bx041.id,MapPicklist.get(rt));
                    else if(rt == 'IPMerge')       BX041_EditTest.createBXIPM (bx041.id,ipMergeMasterList);
                    else if(rt == 'IP')            BX041_EditTest.createBXIP (bx041.id,ipMasterList);
                    //else if(rt == 'High Voltage')  BX041_EditTest.createHV (bx041.id,MapPicklist.get(rt));
                    //else if(rt == 'eDRAM')         BX041_EditTest.createeDRAM (bx041.id,MapPicklist.get(rt));
               } 
            }
         //}   
            //test.startTest();
           
            system.runAs(admin){
                Pagereference pf = page.bx041_edit_page; 
                //ApexPages.currentPage().getParameters().put('Id', bx041.id);  
                Test.setCurrentPage(pf);
                
                ApexPages.currentPage().getParameters().put('Id', bx041.id); 
                ApexPages.currentPage().getHeaders().put('host','www.salesforce.com');  
                BX041_Edit testController = new BX041_Edit(new ApexPages.StandardController(bx041));
                
                testController.bx041.Requested_Process_ID__c = process1.id;
                testController.bx041.Assigned_Process_ID__c = process1.id;
                testController.onchangePopulateFEComments();
                testController.onchangePopulatePIYEComments();
                testController.exportToExcel();
                testController.showPIPdf();
                testController.editbx();
                //System.assertEquals(true,testController.validateMandatoryData());
                testController.addIp();
                //ApexPages.currentPage().getParameters().put('ipSeq','1');
                ApexPages.currentPage().getParameters().put('ipSeq','0');
                //testController.ipwList[1].bx041Ip.Ip_type__c = 'IO';
                testController.ipwList[0].bx041Ip.Ip_type__c = 'IO';
                testController.onchangeIPType();
                //testController.ipwList[1].bx041Ip.Ip_master__c = ipMasterList[0];
                testController.ipwList[0].bx041Ip.Ip_master__c = ipMasterList[0];
                testController.onchangePopulateIP();
                testController.saveIpPopup();
                testController.editIp();
                testController.cancelIpPopup() ;
                testController.saveIP();            
                testController.remIp();
                
                testController.addIpm();
                //ApexPages.currentPage().getParameters().put('ipmSeq','1');
                ApexPages.currentPage().getParameters().put('ipmSeq','0');
                testController.remIpm();
                system.debug(logginglevel.error, testController.bx041.device__r.Confidence_Level_Tapeout__c);
                system.debug(logginglevel.error, testController.bx041.device__r.Account__c);
                testController.submitForApproval();
                testController.backTrackForApproval();
                
                testController.approve();
                testController.reject();
                testController.cancel();
                testController.showPiyeAppr();
                //testController.displayPopup = true;
                testController.getDynamicComp();
                testController.closepopup();
                testController.backtrack();
                testController.cancelbx();
                testController.cancelEditbx();
                testController.getFields();
                //testController.submitforApproval();
                testController.bx041.device__r.Account__c = testAcctId;
                
                
                BX041EmailHandler.sendEmailOne(testController.bx041, 'GF_Device_Requirement_Backtrack_Template','bck');
                map<string, list<BX_041__c> > bx041Map = new map<string, list<BX_041__c> >();
                bx041Map.put('GF_Device_Requirements_Closed_Template',new list<BX_041__c>{testController.bx041});
                bx041Map.put('GF_Device_Frozen_Pending_PID_Assignment_Template',new list<BX_041__c>{testController.bx041});
                bx041Map.put('GF_Device_Requirements_Rejected_Email_Template_4FAEFTS',new list<BX_041__c>{testController.bx041});
                bx041Map.put('GF_Device_Requirement_PO_Issuance_Approved_Template',new list<BX_041__c>{testController.bx041});
                bx041Map.put('GF_Device_Requirements_Rejected_Email_Template_4CE',new list<BX_041__c>{testController.bx041});
                test.stopTest();
                BX041EmailHandler.sendEmailAllInOne(bx041Map);
                
                System.debug('2nd Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getQueries());
                //test.stopTest();
            }   
            
            
     //}   
    }
    static testmethod void testBX041_reopen()
    {
        
        String testAcctId = BX041_EditTest.createAccount();
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('3rd Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
        Process__c process1 = BX041_EditTest.createProcess();
        
        System.debug('3rd  Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        
        
        test.startTest();
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('3rd Total Number of SOQL Queries allowed in this apex code context3: ' +  Limits.getQueries());
        
        
        Device__c testDevice = BX041_EditTest.createDevice(testAcctId, testOpptyProgramId);
        System.debug('3rd Total Number of SOQL Queries allowed in this apex code context4: ' +  Limits.getQueries());
        
        //Process__c process2 = BX041_EditTest.createProcess();
        BX_041__c bx041 = BX041_EditTest.createBX041_2(testDevice, process1.id);
        
        System.debug('3rd Total Number of SOQL Queries allowed in this apex code context5: ' +  Limits.getQueries());
        test.stopTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        //Portal_Tab_Access__c pta = [select id,User__c from Portal_Tab_Access__c where Change_request_report__c = true and user__r.isactive = true and user__r.profile.name = 'Customer Portal Profile' limit 1];
       
        //User customer= [SELECT Id FROM user WHERE id =:pta.user__c];
        //test.startTest();
        system.runas(admin){
            Pagereference pf = page.bx041_edit_page; 
            //ApexPages.currentPage().getParameters().put('Id', bx041.id);  
            Test.setCurrentPage(pf);
            
            ApexPages.currentPage().getParameters().put('Id', bx041.id); 
            ApexPages.currentPage().getHeaders().put('host','www.salesforce.com');  
            BX041_Edit testController = new BX041_Edit(new ApexPages.StandardController(bx041));
            
            testController.submitForApproval();
            testController.reopen();
            
        }
        
    }
    
    //testMethod for Internal Device 
    static testMethod void testBX041_EditForInternalDevice(){
        List<RecordType> recTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recTypeList.isEmpty()){                      
            account.RecordTypeId = recTypeList[0].Id;
        }
        update account;
        System.debug('account====='+account);
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        String testOpptyId = createOpportunity(account.id);
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(account.id, testOpptyId);
         Test.startTest();
        Device__c device = createDevice(account.id,testOpptyProgramId);
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        Process__c processObj = BX041_EditTest.createProcess();
        BX_041__c bx041 = BX041_EditTest.createBX041(device);
        List<id> ipMasterList = new List<id>();
        ipMasterList.add(createIP());
        List<id> ipMergeMasterList = new List<id>();
        ipMergeMasterList.add(createIPMerge());
        
        Map<String , List<id>> MapPicklist = new map<String ,List<id>>();
        List<Question_Metadata__c> qstnMetadata = BX041_EditTest.createQuestionMt();
        if(qstnMetadata.size() > 0){
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
        }
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        //test.startTest();
        
        
        List<String> recordTypeList = new String []{ 'Process Id','Gap Analysis','MEMS','PowerMOs','Turnkey','NVM','RF','High Voltage','eDRAM','IP','IPMerge'};
        
        for(String rt : recordTypeList ){
            if(MapPicklist.get(rt) != NULL){
                if(rt == 'Process Id')         BX041_EditTest.createPI (bx041.id,MapPicklist.get(rt));
                else if(rt == 'Gap Analysis')  BX041_EditTest.createGA (bx041.id,MapPicklist.get(rt)); 
                //else if(rt == 'MEMS')          BX041_EditTest.createMEMS (bx041.id,MapPicklist.get(rt));
                //else if(rt == 'PowerMOs')      BX041_EditTest.createPowerMOS (bx041.id,MapPicklist.get(rt));
                //else if(rt == 'Turnkey')       BX041_EditTest.createTurnkey (bx041.id,MapPicklist.get(rt));
                //else if(rt == 'NVM')           BX041_EditTest.createNVM (bx041.id,MapPicklist.get(rt));
                else if(rt == 'RF')            BX041_EditTest.createRF (bx041.id,MapPicklist.get(rt));
                else if(rt == 'IPMerge')       BX041_EditTest.createBXIPM (bx041.id,ipMergeMasterList);
                else if(rt == 'IP')            BX041_EditTest.createBXIP (bx041.id,ipMasterList);
                //else if(rt == 'High Voltage')  BX041_EditTest.createHV (bx041.id,MapPicklist.get(rt));
                //else if(rt == 'eDRAM')         BX041_EditTest.createeDRAM (bx041.id,MapPicklist.get(rt));
            }
        }
        
        System.debug('4rth Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
       
       
         system.runas(admin){
            Pagereference pf = page.bx041_edit_page; 
            Test.setCurrentPage(pf);
            ApexPages.currentPage().getParameters().put('Id', bx041.id); 
            ApexPages.currentPage().getHeaders().put('host','www.salesforce.com');  
            BX041_Edit testController = new BX041_Edit(new ApexPages.StandardController(bx041));
            testController.bx041.Requested_Process_ID__c = processObj.id;
            testController.bx041.Assigned_Process_ID__c = processObj.id;
            testController.onchangePopulateFEComments();
            testController.onchangePopulatePIYEComments();
            testController.submitForApproval();
            testController.approve();
        }
        
        System.debug('4rth Total Number of SOQL Queries allowed in this apex code context2: ' +  Limits.getQueries());
        test.stopTest();
    }
    
    @isTest static  void testRun1(){
        
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
        //Test.startTest();
        
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        test.starttest();
        Device__c device = createDevicePM(testAcctId,testOpptyProgramId);
        
         
        Process__c process1 = BX041_EditTest.createProcess();
        
        BX_041__c bx041 = BX041_EditTest.createBX041(device);
        bx041.BX_041_Status__c = 'Pending Review';
        bx041.Next_WorkItem_Id__c = 'Test';
        update bx041;
        
        createQuestion();
        
        Pagereference pf = page.bx041_edit_page; 
        Test.setCurrentPage(pf);
            
        ApexPages.currentPage().getParameters().put('Id', bx041.id); 
        ApexPages.currentPage().getHeaders().put('host','www.globalfoundryview.com'); 
        //test.startTest();
        BX041_Edit bx041_EditObj = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        //bx041_EditObj.Next_WorkItem_Id__c = 'test';
        //bx041.reopen();
        
        bx041_EditObj.QueueID = 'test';
        bx041_EditObj.isAuthorizedCustomer =true;
        
        BX041_Edit.RowWrapper rowWrapper = new BX041_Edit.RowWrapper();
        rowWrapper.question = 'test';
        rowWrapper.FEinfo = 'test';
        rowWrapper.PiyeInfo = 'test';
        rowWrapper.Comments = 'test';
        rowWrapper.CustInfoList = new List<selectOption>();
        rowWrapper.value = 'test';
        rowWrapper.custcomment = 'test';
        rowWrapper.resolution = 'test';
        rowWrapper.fieldType = 'test';
        rowWrapper.GAResolution = 'test';
        rowWrapper.editfe = true;
        rowWrapper.editpiye = true;
        rowWrapper.metadataid = 'test';
        rowWrapper.reqGap = 'test';
        rowWrapper.intlCmt = 'test';
        rowWrapper.mandatory = true;
        
        BX041_Edit.SectionWrapper sectionWrapper = new BX041_Edit.SectionWrapper();
        sectionWrapper.PISectionList = new Question_Metadata__c();
        sectionWrapper.WrapperList = new List<BX041_Edit.RowWrapper>();
        sectionWrapper.title = 'test';
        
        BX041_Edit.TopSectionWrapper topSectionWrapper = new BX041_Edit.TopSectionWrapper();
        topSectionWrapper.SectionName = 'test';
        topSectionWrapper.AllWrapperSection = new List<BX041_Edit.SectionWrapper>();
        topSectionWrapper.visible = true;
        topSectionWrapper.shortName = 'true';
        topSectionWrapper.recordType = 'true';
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Pending Submission';
        bx041_EditObj.isAdmin = true;
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Approved by CE';
        bx041_EditObj.bx041.Next_WorkItem_Id__c = '';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_3__c = null;
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed';
        bx041_EditObj.updatebx041();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed1';
        bx041_EditObj.bx041.Assigned_Process_ID__c = process1.Id;
        bx041_EditObj.prevAssignedPID = device.Id;
        bx041_EditObj.updatebx041();
        
        Test.stopTest();
    }
    
    @isTest static  void testRun2(){
        
         
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
       
        
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        
        Device__c device = createDevicePM(testAcctId,testOpptyProgramId);
        Test.startTest();
        Process__c process1 = BX041_EditTest.createProcess();
        /*
        Assigned_Process__c ap = new Assigned_Process__c();
        ap.device__c = device.Id;
        ap.process__c = process1.Id;
        ap.primary_process__c = false;
        insert ap;
        */
        BX_041__c bx041 = BX041_EditTest.createBX041(device);
        bx041.BX_041_Status__c = 'Pending Review';
        bx041.Next_WorkItem_Id__c = 'Test';
        update bx041;
        
        createQuestion();
        
        Pagereference pf = page.bx041_edit_page; 
        Test.setCurrentPage(pf);
            
        ApexPages.currentPage().getParameters().put('Id', bx041.id); 
        ApexPages.currentPage().getHeaders().put('host','www.globalfoundryview.com'); 
        
        BX041_Edit bx041_EditObj = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        bx041.BX_041_Status__c = 'Pending Submission';
        bx041.Next_WorkItem_Id__c = 'Test';
        update bx041;
        bx041_EditObj = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        Test.stopTest();
    }
    
    @isTest static  void testRun3(){
        
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
       
        
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        Test.startTest();
        Device__c device = createDevicePM1(testAcctId,testOpptyProgramId);
        Test.stopTest();
        /*device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 1';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        //device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'GlobalShuttle MPW';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Confidence_Level_Tapeout__c = '40'; 
        device.End_Application__c = 'Body';
        device.MPW_Train_Number__c = createMPW();
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Original_Forecasted_Tapeout_Date__c = System.today().addDays(5);
        insert device;*/
         
        Process__c process1 = BX041_EditTest.createProcess();
        
        BX_041__c bx041 = BX041_EditTest.createBX041(device);
        
        Assigned_Process__c ap = new Assigned_Process__c();
        ap.device__c = device.Id;
        ap.process__c = process1.Id;
        ap.primary_process__c = false;
        insert ap;
        
        List<id> ipMergeMasterListTemp = new List<id>();
        
        IP_Merge__c ipmTemp = new IP_Merge__c(IP_Type__c = 'IO',
                                            Latest_Version__c = '20',
                                            IP_Vendor__c = 'Test',
                                            PH1_QA_Status__c = 'NCR',
                                            Showstopper__c = 'Yes');
        ipMergeMasterListTemp.add(ipmTemp.Id);
        BX041_EditTest.createBXIPM (bx041.id, ipMergeMasterListTemp);
        
        Pagereference pf = page.bx041_edit_page; 
        Test.setCurrentPage(pf);
            
        ApexPages.currentPage().getParameters().put('Id', bx041.id); 
        ApexPages.currentPage().getParameters().put('ipSeq', '0'); 
        ApexPages.currentPage().getHeaders().put('host','www.globalfoundryview.com'); 
        
        BX041_Edit bx041_EditObj = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed';
        bx041_EditObj.updatebx041();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed1';
        bx041_EditObj.bx041.Assigned_Process_ID__c = process1.Id;
        bx041_EditObj.prevAssignedPID = device.Id;
        bx041_EditObj.updatebx041();
        
        bx041_EditObj.bx041.Process_ID_is_known__c = 'Yes';
        bx041_EditObj.bx041.Reference_Process_ID_txt__c = null;
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed1';
        bx041_EditObj.prevAssignedPID = process1.Id;
        bx041_EditObj.updatebx041();
        
        Process_Information__c pi = new Process_Information__c();
        pi.BX_041__c = bx041_EditObj.bx041.Id;
        insert pi;
        
        bx041_EditObj.bx041.Next_WorkItem_Id__c = process1.Id;
        bx041_EditObj.reopen();
        
        bx041_EditObj.isInternalDevice = true;
        bx041_EditObj.reopen();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Closed';
        bx041_EditObj.backtrack();
        
        Process_Information__c pi1 = new Process_Information__c();
        pi1.BX_041__c = bx041_EditObj.bx041.Id;
        pi1.mandatory__c = true;
        pi1.Customer_request__c = '';
        pi1.FE_Requested_Information__c = '';
        insert pi1;
        
        bx041_EditObj.validateMandatoryData();
        
        BX041_IP__c bx = new BX041_IP__c();
        BX041_Edit.Bx041IpWrapper bx041IpWrapper = new BX041_Edit.Bx041IpWrapper(bx, false);
        bx041IpWrapper.index = 7;
        
        bx041_EditObj.ipmList = new List<BX041_IP_Merge__c>();
        
        List<id> ipMergeMasterList = new List<id>();
        
        IP_Merge__c ipm = new IP_Merge__c(IP_Type__c = 'IO',
                                            Latest_Version__c = '20',
                                            IP_Vendor__c = 'Test',
                                            PH1_QA_Status__c = 'NCR',
                                            Showstopper__c = 'Yes');
        insert ipm;
        ipMergeMasterList.add(ipm.Id);
        
        IP_Merge__c ipm1 = new IP_Merge__c(IP_Type__c = 'IO',
                                            Latest_Version__c = '20',
                                            IP_Vendor__c = 'Test',
                                            PH1_QA_Status__c = 'NCR',
                                            Showstopper__c = 'Yes');
        insert ipm1;
        ipMergeMasterList.add(ipm1.Id);
        
        bx041_EditObj.ipmList = BX041_EditTest.createBXIPM (bx041.id, ipMergeMasterList);
        bx041_EditObj.ipmList.addAll( BX041_EditTest.createBXIPM (bx041.id, ipMergeMasterList) );
        BX041_IP_Merge__c bimTemp = new BX041_IP_Merge__c();
        bimTemp.IP_Master__c = ipm1.Id;
        bx041_EditObj.ipmList.add(bimTemp);
        
        BX041_IP_Merge__c bimTemp1 = new BX041_IP_Merge__c();
        bimTemp1.remarks__c = 'testChange';
        bimTemp1.BX_041__c = bx041.id;
        bx041_EditObj.ipmList.add(bimTemp1);
        
        BX041_IP_Merge__c bimTemp2 = new BX041_IP_Merge__c();
        bimTemp2.remarks__c = null;
        bimTemp2.BX_041__c = bx041.id;
        bx041_EditObj.ipmList.add(bimTemp2);
        
        bx041_EditObj.ipmOldMap = new map<id,BX041_IP_Merge__c>();

        for(BX041_IP_Merge__c obj : bx041_EditObj.ipmList){
            obj.remarks__c = 'testChange';
            bx041_EditObj.ipmOldMap.put(obj.Id, obj);
        }
        
        bx041_EditObj.saveIpmKit();
        
        bx041_EditObj.ipwList = new List<BX041_Edit.Bx041IpWrapper>();
        
        BX041_IP__c bx1 = new BX041_IP__c();
        bx1.IP_Master__c =  ipm1.Id;
        bx1.BX_041__c = bx041_EditObj.bx041.Id;     
        BX041_Edit.Bx041IpWrapper bx041IpWrapper1 = new BX041_Edit.Bx041IpWrapper(bx1, false); 
        bx041IpWrapper1.isNew = true;
        
        bx041_EditObj.ipwList.add(bx041IpWrapper1);
        
        BX041_IP__c bx2 = new BX041_IP__c();
        bx2.IP_Master__c =  ipm1.Id;
        BX041_Edit.Bx041IpWrapper bx041IpWrapper2 = new BX041_Edit.Bx041IpWrapper(bx2, false); 
        bx041_EditObj.ipwList.add(bx041IpWrapper2);
        
        bx041_EditObj.onchangePopulateIP();
        bx041_EditObj.saveIP();
        
        bx041_EditObj.currentIP.isNew = false;
        bx041_EditObj.saveIpPopup();
        
        bx041_EditObj.currentIP.isNew = true;
        bx041_EditObj.cancelIpPopup();
        
        bx041_EditObj.accountRegion = '';
        bx041_EditObj.submitForApproval();
        
        bx041_EditObj.accountRegion = 'Test';
        bx041_EditObj.bx041.Initial_Submitter__c = '';
        bx041_EditObj.isInternalDevice = true;
        bx041_EditObj.isCustomer = true;
        bx041_EditObj.submitForApproval();
        
        bx041_EditObj.accountRegion = 'Test';
        bx041_EditObj.bx041.Initial_Submitter__c = '';
        bx041_EditObj.isInternalDevice = false;
        bx041_EditObj.isCustomer = true;
        bx041_EditObj.submitForApproval();
        
        bx041_EditObj.accountRegion = 'Test';
        bx041_EditObj.bx041.Initial_Submitter__c = 'Test';
        bx041_EditObj.isInternalDevice = false;
        bx041_EditObj.isCustomer = true;
        bx041_EditObj.submitForApproval();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by FAE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = null;
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by FAE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = UserInfo.getUserId();
        bx041_EditObj.bx041.Next_WorkItem_Id__c = 'Test';
        
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by FAE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = UserInfo.getUserId();
        bx041_EditObj.bx041.Next_WorkItem_Id__c = null;
        
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by CE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = UserInfo.getUserId();
        bx041_EditObj.bx041.Next_WorkItem_Id__c = null;
        
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by CE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = null;
        bx041_EditObj.bx041.Next_WorkItem_Id__c = null;
        
        bx041_EditObj.approve();
        
        bx041_EditObj.bx041.BX_041_Status__c = 'Test';
        bx041_EditObj.bx041.Approval_Status__c = 'Approved by CE';
        bx041_EditObj.bx041.Approver_1__c = null;
        bx041_EditObj.bx041.Approver_2__c = null;
        bx041_EditObj.bx041.Approver_3__c = null;
        bx041_EditObj.bx041.Next_WorkItem_Id__c = 'test';
        bx041_EditObj.isGapNone = true;
        
        bx041_EditObj.approve();
        
        
    }
    
    @isTest static  void testRun4(){
        
        String testAcctId = BX041_EditTest.createAccount();
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1a: ' +  Limits.getQueries());
        
        String testOpptyId = BX041_EditTest.createOpportunity(testAcctId);
        System.debug('Total Number of SOQL Queries allowed in this apex code context1: ' +  Limits.getQueries());
        Test.startTest();
        
        String testOpptyProgramId = BX041_EditTest.createOpportunityProgram(testAcctId, testOpptyId);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context1b: ' +  Limits.getQueries());
        
        Device__c device = createDevicePM1(testAcctId,testOpptyProgramId);
       /* device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 1';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        //device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'GlobalShuttle MPW';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Confidence_Level_Tapeout__c = '40'; 
        device.End_Application__c = 'Body';
        device.MPW_Train_Number__c = createMPW();
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Original_Forecasted_Tapeout_Date__c = System.today().addDays(5);
        insert device;*/
        
        Process__c process1 = BX041_EditTest.createProcess();
        
        BX_041__c bx041 = BX041_EditTest.createBX041(device);
        
        Assigned_Process__c ap = new Assigned_Process__c();
        ap.device__c = device.Id;
        ap.process__c = process1.Id;
        ap.primary_process__c = false;
        insert ap;
        
        createQuestion();
        
        List<id> ipMasterList = new List<id>();
        ipMasterList.add(createIP());
        
        BX041_EditTest.createBXIP (bx041.id,ipMasterList);
        
        BX041_Edit.RowWrapper rowWrapper = new BX041_Edit.RowWrapper();
        rowWrapper.question = 'test';
        
        BX041_Edit.SectionWrapper sectionWrapper = new BX041_Edit.SectionWrapper();
        
        List<Question_Metadata__c> qstnMetadata = BX041_EditTest.createQuestionMt();
        
        sectionWrapper.PISectionList = qstnMetadata[0];
        sectionWrapper.WrapperList = new List<BX041_Edit.RowWrapper>();
        sectionWrapper.WrapperList.add(rowWrapper);
        sectionWrapper.title = 'test';
        
        BX041_Edit.TopSectionWrapper topSectionWrapper = new BX041_Edit.TopSectionWrapper();
        topSectionWrapper.SectionName = 'test';
        topSectionWrapper.AllWrapperSection = new List<BX041_Edit.SectionWrapper>();
        topSectionWrapper.AllWrapperSection.add(sectionWrapper);
        topSectionWrapper.visible = true;
        topSectionWrapper.shortName = 'test';
        topSectionWrapper.recordType = Label.QM_RT_PI;
        
        
        
        Pagereference pf = page.bx041_edit_page; 
        Test.setCurrentPage(pf);
            
        ApexPages.currentPage().getParameters().put('Id', bx041.id); 
        ApexPages.currentPage().getParameters().put('ipSeq', '0'); 
        ApexPages.currentPage().getHeaders().put('host','www.globalfoundryview.com'); 
        
        BX041_Edit bx041_EditObj = new BX041_Edit(new ApexPages.StandardController(bx041));
        
        bx041_EditObj.WrapperTopSectionList = new List<BX041_Edit.TopSectionWrapper>();
        bx041_EditObj.WrapperTopSectionList.add(topSectionWrapper);
        
        bx041_EditObj.bx041.Assigned_Process_ID__c = process1.Id;
        
        bx041_EditObj.onchangePopulatePIYEComments();
        
        bx041_EditObj.prevAssignedPID = process1.Id;
        bx041_EditObj.onchangePopulatePIYEComments();
        
        bx041_EditObj.bx041.Assigned_Process_ID__c = null;
        bx041_EditObj.onchangePopulatePIYEComments();
        
        bx041_EditObj.bx041.Requested_Process_ID__c = process1.Id;
        bx041_EditObj.onchangePopulateFEComments();
        
        bx041_EditObj.bx041.Requested_Process_ID__c = null;
        bx041_EditObj.onchangePopulateFEComments();
        
        try{
            bx041_EditObj.bx041.BX_041_Status__c = 'Closed1';
            bx041_EditObj.bx041.Assigned_Process_ID__c = process1.Id;
            bx041_EditObj.prevAssignedPID = device.Id;
            bx041_EditObj.bx041.Assigned_Process_ID__c = null;
            bx041_EditObj.bx041.Process_ID_is_known__c = 'Yes1';
            bx041_EditObj.updatebx041();
        }
        catch(Exception e){}
        
        Test.stopTest();
    }    
    
    
    static void createQuestion(){
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
      Question_Metadata__c qm321 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Basic Information',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 301001,
                                                            Type__c = 'Section'); 

    Question_Metadata__c qm322 = new Question_Metadata__c(API_Name__c = 'RF__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Basic Information',
                                                            Record_Type__c = 'RF',
                                                            Sequence__c = 301002,
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
                                                                               qm31,qm32,qm33,qm34,qm35,qm321,qm322};
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
            
            if(qmList[i].Type__c == 'Section'){
                
                qmList[i].Question_Metadata_Section__c = qm31.Id;
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
}