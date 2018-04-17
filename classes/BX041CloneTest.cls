/*
    ZAmbat    04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
    Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.    
    Devendra  10142015      - Updated to fix device validation error
*/

@isTest(SeeAllData=false)
private class BX041CloneTest{
    
  @testsetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        device__c d=DeviceUtilTest.createRetrofitDevice();
        d.Confidence_Level_Tapeout__c = '100';
        test.startTest();
        insert d;
        test.stopTest();
    } 

    static id accId;
    static id oppId;
    static id oppGramId;
    //static list<account_team_proxy__c> atpList;
    static map<string, user> userMap;
    static Device__c dev;
    static process__c proc;
    static String FabNo = 'Fab 3';
    
    static void initialize(){
        //DataUtilTest.loadEnvironmentVariables();
        
        if(userMap == null)  createUserList();
        if(accid == null) createAccount();
        if(oppid == null) createOpportunity(accid);
        if(oppGramId == null) {createOpportunityProgram(accid, oppid); }
        if(dev  == null) createDevice(accid, oppGramId);
        //if(atpList == null)  createAccountTeamProxy(accid);
        if(proc == null) createProcess();
        
    }
    
    
    static void createAccount(){
         Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('ownerid', userMap.get('Owner').id);
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;              
        accId = acc.Id;
    }
    
    static void createUserList(){
        
        userMap = new map<string, user>();
        for(user u :[select id, profile.name, Fab_Assigned__c from user where isactive = true and (profile.name = 'Customer Portal Profile' 
                                                                                                        or profile.name = 'GF System Admin' 
                                                                                                        or (profile.name = 'GF CE' and Fab_Assigned__c includes (:FabNo) ) 
                                                                                                        or profile.name = 'GF FAE/FTS'
                                                                                                        or profile.name = 'GF PIYE'
                                                                                                        or profile.name = 'GF CSR'
                                                                                                        or (profile.name = 'GF Sales User' and userRoleId != null)
                                                                                                        )])
        {
            if(userMap.size() >= 9) break;
            if(u.profile.name == 'Customer Portal Profile' && !userMap.containskey('Customer') ){
                userMap.put('Customer', u);
            } else if(u.profile.name == 'GF System Admin' && !userMap.containskey('Admin')){
                userMap.put('Admin', u);
            } else if(u.profile.name == 'GF Sales User' && !userMap.containskey('Owner')){
                userMap.put('Owner', u);
            } else if(u.profile.name == 'GF CE' && !userMap.containskey('CE')){
                userMap.put('CE', u);
            } else if(u.profile.name == 'GF FAE/FTS' && !userMap.containskey('PFTS')){
                userMap.put('PFTS', u);
            } else if(u.profile.name == 'GF FAE/FTS' && !userMap.containskey('FTS')){
                userMap.put('FTS', u);
            } else if(u.profile.name == 'GF CSR' && !userMap.containskey('PCSR')){
                userMap.put('PCSR', u);
            } else if(u.profile.name == 'GF CSR' && !userMap.containskey('BCSR')){
                userMap.put('BCSR', u);
            } else if(u.profile.name == 'GF PIYE' && !userMap.containskey('PIYE')){
                userMap.put('PIYE', u);
            }
                                                                                            
        }
    }
    /*
    static void createAccountTeamProxy(id acctId){
      if(userMap == null || userMap.size() == 0) createUserList();
      
      atpList = new list<Account_Team_Proxy__c>();
      
      for(string role: userMap.keyset() ){
          if(role == 'CE' || role == 'PFTS' || role == 'FTS' || role == 'PCSR' || role == 'BCSR') {
              Account_Team_Proxy__c proxy =  new Account_Team_Proxy__c();
              if(role == 'PFTS') proxy.Team_Role__c = 'Primary Field Technical Support';
              else if(role == 'FTS')proxy.Team_Role__c = 'Field Technical Support';
              else if(role == 'CE'){proxy.Team_Role__c = 'Customer Engineer';proxy.Fab_Assignment__c =  userMap.get(role).Fab_Assigned__c;}
              else if(role == 'PCSR')proxy.Team_Role__c = 'Primary Customer Service Rep';
              else if(role == 'BSCR')proxy.Team_Role__c = 'Backup Customer Service Rep';
              
              proxy.Account__c = acctId;
              proxy.user__c  = userMap.get(role).id;
              proxy.Account_Access__c = 'Read/Write';
              proxy.Opportunity_Access__c = 'Read/Write';       
              atpList.add(proxy);
          }
      }
      
      insert atpList;
      
    }*/
    
    static void createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();        
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c','0.055UM');
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        oppId =  OpportunityDataFactory.createOpportunity(fieldValueMap).id;
    }
    
    static void createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        
        insert testOpptyProgram;        
        oppGramId = testOpptyProgram.Id;
    }
    static void createOpportunityProgramTeamMember(id OpptyPrgId, id userid){
        Opportunity_Program_Team_Member__c optm = new Opportunity_Program_Team_Member__c();
        optm.Opportunity_Program__c = OpptyPrgId;
        optm.Team_Role__c = 'Account Manager';
        optm.Device_Access__c = 'Read Only';
        optm.Opportunity_Program_Access__c = 'Read Only';
        optm.User__c = userId;
        insert optm;
    }
    static void createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();        
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677-123');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c',FabNo);
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In'); // 
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Semiconductor_Device__c','MEMS - Inertial');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','Generic / Nominal');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        
        dev = DeviceDataFactory.createDevice(fieldValueMap);
    }
        
    static Device__c createRetrofitDevice( Id testOpptyProgramId, Id baseDevId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>(); 
        fieldValueMap.put('Device_Type__c','Retrofit');
        fieldValueMap.put('PTRF_ID__c','bypass');
        fieldValueMap.put('NPC_Form_Originating_Device__c',baseDevId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677-11');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c',FabNo);
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In'); // Testing only for 'design in'
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('Semiconductor_Device__c','MEMS - Inertial');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','Generic / Nominal');
        fieldValueMap.put('MPW_Train_Number__c',createMPW());
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static Device__c createClonedDevice( Id testOpptyProgramId, Id baseDevId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>(); 
        fieldValueMap.put('Device_Type__c','Base');
        //fieldValueMap.put('PTRF_ID__c = 'bypass';
        fieldValueMap.put('Copied_Device__c',baseDevId);
        fieldValueMap.put('Name','CopyTESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c',FabNo);
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In'); // Testing only for 'design in'
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('Semiconductor_Device__c','MEMS - Inertial');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','Generic / Nominal');
        fieldValueMap.put('MPW_Train_Number__c',createMPW());
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static Device__c createReviseDevice( Id testOpptyProgramId, Id baseDevId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>(); 
        fieldValueMap.put('Device_Type__c','Revision');
        fieldValueMap.put('Base_Device__c',baseDevId);
        fieldValueMap.put('Name','REVTESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c',FabNo);
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In'); // Testing only for 'design in'
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('End_Application__c','Server');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('Semiconductor_Device__c','MEMS - Inertial');
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','Generic / Nominal');
        fieldValueMap.put('MPW_Train_Number__c',createMPW());
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    static void createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Available';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'Generic / Nominal';
        insert process1;
        proc = process1;
    }
    static BX_041__c createCDRS(Device__c  device, id procId, String status, id PiyeApprId){
        
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.id;
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        bx041.CRMDID__c = device.CRMDID__c ;
        
        if(status == ''){
            bx041.BX_041_Status__c = 'Pending Submission';
            bx041.Approval_status__c = status;
            bx041.Approval_Step__c = 'Pending for Customer';
            bx041.Initial_Submitter__c = 'Customer';
        } else if(status == 'Approved by FAE/FTS'){
            bx041.BX_041_Status__c = 'Pending Submission';
            bx041.Approval_status__c = status;
            bx041.Approval_Step__c = 'Pending for FAE/FTS';
            bx041.Initial_Submitter__c = 'FAE/FTS';
        } else if(status == 'Approved by CE'){
            bx041.BX_041_Status__c = 'Pending Review';
            bx041.Approval_status__c = status;
            bx041.Approval_Step__c = 'Pending for CE';
            bx041.Approver_1__c = PiyeApprId;
            bx041.Initial_Submitter__c = 'FAE/FTS';
        }else if(status == 'Approved by PI/YE'){
            bx041.BX_041_Status__c = 'Closed';
            bx041.Approval_status__c = status;
            bx041.Approval_Step__c = 'Approved';
            bx041.Initial_Submitter__c = 'FAE/FTS';
            bx041.Approver_1__c = PiyeApprId;
            bx041.Assigned_Process_ID__c = procid;
        }else if(status == 'Backtrack to FTS') {
            bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
            bx041.Approval_status__c = 'Approved by PI/YE';
            bx041.Approval_Step__c = 'Approved';
            bx041.Initial_Submitter__c = 'Customer';
        }else if(status == 'Backtrack to CE') {
            bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
            bx041.Approval_status__c = 'Approved by PI/YE';
            bx041.Approval_Step__c = 'Approved';
            bx041.Initial_Submitter__c = 'FAE/FTS';
            //bx041.Assigned_Process_ID__c = procid;
            bx041.GAP_Closed__c = true;
            
        }
        
                
        bx041.Geometry_Filter__c = device.Geometry_Filter__c;
        bx041.Process_Family_Filter__c = device.Process_Family_Filter__c;
        bx041.Requested_Process_ID__c = procId;

        insert bx041;  
        return bx041;  
    }
    
    
    static IP__c createIP (){
      IP__c ip = new IP__c(IP_Type__c = 'Logic',PH1_QA_Status__c = 'NCR');
      insert ip;
      return ip;
    }
    
       
    static BX041_IP__c createBX041IP (id bx041ID ,id IdkId){
        BX041_IP__c ip = new BX041_IP__c (BX_041__c = bx041ID);
        ip.IP_Type__c = 'LOGIC';
        ip.IP_Master__c = IdkId;
       
        insert ip ;
        return ip ;
    
    }
    
    static list<Question_Metadata__c> createQuestionMt(){
        
        Question_Metadata__c qm11 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Process Id',
                                                            Record_Type__c = 'Process Id',
                                                            //Sequence__c = 90000,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'TopSection');
        Question_Metadata__c qm12 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'Process Information',
                                                            Record_Type__c = 'Process Id',
                                                            //Sequence__c = 90100,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Section');
        Question_Metadata__c qm13 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Mandatory_for_Templates__c  = '',
                                                            Process_field_API_name__c = 'PID_NUMBER__c',
                                                            Mandatory__c = false,
                                                            Question_to_Display__c = 'PLM PID',
                                                            Record_Type__c = 'Process Id',
                                                            //Sequence__c = 90101,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Text');
        Question_Metadata__c qm14 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'POLY_GATE_TYPE__c',
                                                            Mandatory__c = true,
                                                            Question_to_Display__c = 'Gate Type',
                                                            Record_Type__c = 'Process Id',
                                                            //Sequence__c = 90102,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');   
        Question_Metadata__c qm15 = new Question_Metadata__c(API_Name__c = 'Process_Information__c',
                                                            Process_field_API_name__c = 'CORE_VOLTAGES__c',
                                                            Mandatory__c = true,
                                                            Question_to_Display__c = 'Core Voltage/s (V)',
                                                            Record_Type__c = 'Process Id',
                                                            //Sequence__c = 90103,
                                                            Template_Name__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Mandatory_for_Templates__c = 'Geometry 32nm/28nm & below;Geometry 45nm - 40nm;Geometry 90nm - 55nm;Geometry 0.11um - 0.13um;Geometry 0.14um - 0.25um;Geometry 0.30um & Greater',
                                                            Type__c = 'Picklist');  
                                                                                                                                                                            
         list<Question_Metadata__c>  qmList = new list<Question_Metadata__c>{qm11,qm12,qm13,qm14,qm15};
         insert qmList;
                  
         return qmList;
    }
    static void createdPIs(list<Question_Metadata__c> qmList, id cdrsId){
        
        list<Process_Information__c> piList = new list<Process_Information__c>();
        for(Question_Metadata__c qm :qmList){
            
            Process_Information__c pi = new Process_Information__c();
            pi.BX_041__c = cdrsId;
            pi.Question_Metadata__c = qm.id;
            pi.Customer_Request__c = 'test';
            pi.PIYE__c = 'test2';
            piList.add(pi);
        }
        
        insert piList;
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
    
    static testmethod void testReviceDevice()
    {
         test.startTest();
         User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(oppGramId == null) {oppGramId=[select id from Opportunity_Program__c   limit 1].id; }
        if(proc == null) proc=[select id from Process__c    limit 1];
       
        list<Question_Metadata__c> qmList  = createQuestionMt();
        
        System.runAs(admin) {
            
            BX_041__c bx041 = createCDRS(device, proc.id,'Approved by PI/YE' ,admin.id);
        
        createdPIs(qmList, bx041.id);
        IP__c idk = createIP();
        createBX041IP(bx041.id, idk.id);
        
            test.stopTest();
        }
    }   
    
    static testmethod void testRetrofitDevice()
    {
         test.startTest();
        //Test Data creation: 
         User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,NPC_Form__c,Base_Device__c from device__c limit 1];
        if(oppGramId == null) {oppGramId=[select id from Opportunity_Program__c   limit 1].id; }
        if(proc == null) proc=[select id from Process__c    limit 1];
        list<Question_Metadata__c> qmList  = createQuestionMt();
        
        
        System.runAs(admin) {
            
             //Device__c rtfDev =  device; 
            BX_041__c bx041 = createCDRS(device, proc.id,'Approved by CE' , admin.id);
            //DeviceTriggerHelper.CDRSapprovalUserPapulate(device.NPC_Form__c,device.id,device.Base_Device__c);
            //DeviceTriggerHelper.CDRSapprovalUserPapulate(device.id);
            //BX041Clone.cloneBX041Method(new Set<Id>{device.Id});
            test.stopTest();
        }
    }   

    static testmethod void testCopiedDevice()
    {
        test.startTest();
        //Test Data creation: 
         User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,Base_Device__c from device__c limit 1];
        if(oppGramId == null) {oppGramId=[select id from Opportunity_Program__c   limit 1].id; }
        if(proc == null) proc=[select id from Process__c    limit 1];
        createOpportunityProgramTeamMember(oppGramId, admin.id);
        
        list<Question_Metadata__c> qmList  = createQuestionMt();
        
        System.runAs(admin) {
            
            Device__c rtfDev =  device;
            //BX041Clone bc = new BX041Clone();
            //bc.cloneBX041Method(new list<Device__c>{rtfDev});
            BX041Clone.cloneBX041Method(new Set<Id>{rtfDev.Id});
            test.stopTest();
        }
    } 
    
}