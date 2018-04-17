/*
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
      Devendra  10142015      - Updated to fix device validation error
      SNune    12062015    - Modified code for improving test coverage.
*/

@isTest(seeAllData=false)
private class BX041ApproverHelperTest{
  
  static id accId;
    static id oppId;
    static id oppGramId;
    static list<account_team_proxy__c> atpList;
    static map<string, user> userMap;
    static Device__c dev;
    static process__c proc;
    static String FabNo = 'Fab 3';
  @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
      
        createUserList();
        accId = createAccount();
        createAccountTeamProxy(accId);
        Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', accId, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        test.startTest();
        oppId = createOpportunity(accId); 
        oppGramId = createOpportunityProgram(accId, oppId);
        Device__c testDevice = createCustomerMPWDeviceNew3(accId, oppId, oppGramId);
        //insert testDevice;
        
        system.debug('\n\n #### testDevice : ' + testDevice);
        test.stoptest(); 
    }
  
    private static Id createMaskSetTtitle() {
        
        Map<String, Object> tempMap = new Map<String, Object>();
        tempMap.put('Name', 'MSTTRT1');
        tempMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle1(tempMap);
        return mst.Id;
    }
    
    private static Device__c createCustomerMPWDeviceNew3(Id testAcctId, Id testOpptyId, Id testOpptyProgramId) {
        // Create Device
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Device__c device = new Device__c();
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Opportunity2__c',testOpptyId);
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Actual_Tapeout_Date__c',date.today());
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',date.today());
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.today());
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Siebel_Sync_id__c',String.valueOf(System.now()));
        fieldValueMap.put('Siebel_Status__c','SENT');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        //Insert device;
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    
    static void initialize(){
        //DataUtilTest.loadEnvironmentVariables();
        
        if(userMap == null)  createUserList();
        if(accid == null) createAccount();
        if(oppid == null) createOpportunity(accid);
        if(oppGramId == null) createOpportunityProgram(accid, oppid);
        if(dev  == null) createDevice(accid, oppGramId);
        if(atpList == null)  createAccountTeamProxy(accid);
        if(proc == null) createProcess();
        
    }
    
    
    static ID createAccount(){
                                
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('ownerid', userMap.get('Owner').id);
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        return AccountDataFactory.createAccount(fieldValueMap).id;
    }
    
    static void createUserList(){
        
        userMap = new map<string, user>();
        for(user u :[select id, profile.name, Fab_Assigned__c from user where isactive = true and (profile.name = 'Customer Portal Profile' 
                                                                                                        or profile.name = 'GF System Admin' 
                                                                                                        or (profile.name = 'GF CE' and Fab_Assigned__c includes (:FabNo) ) 
                                                                                                        or profile.name = 'GF FAE/FTS'
                                                                                                        or profile.name = 'GF PIYE Platform'
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
            } else if(u.profile.name == 'GF PIYE Platform' && !userMap.containskey('PIYE')){
                userMap.put('PIYE', u);
            }
                                                                                            
        }
    }
    
    static void createAccountTeamProxy(id acctId){
      if(userMap == null || userMap.size() == 0) createUserList();
      
      atpList = new list<Account_Team_Proxy__c>();
      
      for(string role: userMap.keyset() ){
          if(role == 'CE' || role == 'PFTS' || role == 'FTS' || role == 'PCSR' || role == 'BCSR') {
              Account_Team_Proxy__c proxy =  new Account_Team_Proxy__c();
              if(role == 'PFTS') proxy.Team_Role__c = 'Primary Field Application Engineer';
              else if(role == 'FTS')proxy.Team_Role__c = 'Field  Application Engineer';
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
      
    }
    
    static id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        
        insert testOppty;
        return testOppty.id;
    }
    
    static id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        
        insert testOpptyProgram;        
        return testOpptyProgram.Id;
    }
    
    static void createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = DeviceUtilTest.createSingleProductDevice();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Fab__c = FabNo;
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // 
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        //Added by Baij-04/09/2015
        device.Reticle_Type__c = 'Single Layer Reticle (SLR)';
        //device.Geometry_Filter__c = '0.055UM';
        //device.Process_Family_Filter__c = 'MEMS';
        device.Enabled_via_previous_MPW_1__c = 'No';
        
        Insert device;
        
        dev = device;
    }
    
    static Device__c createGlobalShuttleDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = DeviceUtilTest.createGlobalShuttleMPWDevice();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Fab__c = FabNo;
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
        device.Tapeout_Type__c = 'GlobalShuttle MPW';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Enabled_via_previous_MPW_1__c = 'No';
         //Added by Baij-04/09/2015
        device.Reticle_Type__c = 'Single Layer Reticle (SLR)';
        
        Insert device;
        
        return device;
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
    static BX_041__c createCDRS(Device__c  device, id procId, String status){
        
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.id;
        
        if(status == ''){
            bx041.BX_041_Status__c = 'Pending Submission';
            bx041.Approval_status__c = '';
            bx041.Approval_Step__c = 'Pending for Customer';
            bx041.Initial_Submitter__c = 'Customer';
        } else if(status == 'Approved by FAE/FTS'){
            bx041.BX_041_Status__c = 'Pending Submission';
            bx041.Approval_status__c = 'Approved by FAE/FTS';
            bx041.Approval_Step__c = 'Pending for FAE/FTS';
            bx041.Initial_Submitter__c = 'FAE/FTS';
        } else if(status == 'Approved by CE'){
            bx041.BX_041_Status__c = 'Pending Review';
            bx041.Approval_status__c = 'Approved by CE';
            bx041.Approval_Step__c = 'Pending for CE';
            bx041.Initial_Submitter__c = 'FAE/FTS';
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
        //bx041.Requested_Process_ID__c = procId;
    bx041.Assigned_Process_ID__c = procId;
        insert bx041;  
        return bx041;  
    }
    
    
    static IP__c createIP (){
      IP__c ip = new IP__c(IP_Type__c = 'Logic',PH1_QA_Status__c = 'NCR');
      insert ip;
      return ip;
    }
    
    static List<IP_Merge__c> createIPMs (){
      return new IP_Merge__c[] {new IP_Merge__c(IP_Type__c = 'Logic',PH1_QA_Status__c = 'NCR')};
    }
    
    static BX041_IP__c createBX041IP (id bx041ID ,id IdkId){
        BX041_IP__c ip = new BX041_IP__c (BX_041__c = bx041ID);
        ip.IP_Type__c = 'LOGIC';
        ip.IP_Master__c = IdkId;
       
        insert ip ;
        return ip ;
    
    }
    
    static List<BX041_IP_Merge__c> createBX041IPM (id bx041ID, List<IP_Merge__c> ipMergeList){
        List<BX041_IP_Merge__c > insertList = new List<BX041_IP_Merge__c >();
        for(IP_Merge__c ipMerge : ipMergeList){
            BX041_IP_Merge__c ipm = new BX041_IP_Merge__c(BX_041__c = bx041ID);
            ipm.GF_Supported_IP__c = true;
            ipm.IP_Master__c = ipMerge.id;
            ipm.Remarks__c = 'test';
            ipm.Merge_Kit_Name__c = 'Test';
            insertList.add(ipm);
        }
        insert insertList ;
        return insertList ;
    
    }
    
   
    static testmethod void testAppOrRejByCE()
    {
        //Test Data creation: 
        
        //BX041ApproverHelperTest.initialize();
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c where Name = 'TESTDEVICEZAIH12345677' limit 1];
        system.debug('Device name' +device.Name);
        if(proc == null) createProcess();
        //System.runAs(userMap.get('Admin')) {
            test.startTest();
            //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id,'Approved by FAE/FTS' );
             
            BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id,'Approved by FAE/FTS' );
        
            
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            //FE Submission
            helper.submitForApproval(bx041.id, 'submission comment', null);
            helper.revertBX041(bx041); 
            helper.rejectReq(bx041.id,'reject comment');
            
            helper.submitForApproval(bx041.id, 'resubmission comment', null);
            helper.approveReq(bx041.id,'approve comment');
            
            
            
            /*bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id,'Approved by CE' );
        
            
            
            //CE Submission
            helper.submitForApproval(bx041.id, 'submission comment', null);
            helper.revertBX041(bx041); 
            helper.rejectReq(bx041.id,'reject comment');
            
            helper.submitForApproval(bx041.id, 'resubmission comment', null);
            helper.approveReq(bx041.id,'approve comment');*/
            
            
            
			system.assertEquals(device.id,bx041.Device__c);     
            
            test.stopTest();
        //}
        
        
    }
    
    static testmethod void testAppOrRejByPIYE()
    {
        //BX041ApproverHelperTest.initialize();
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(proc == null) createProcess();
        test.startTest();
        //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, 'Approved by CE');
        BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, 'Approved by CE');
        if(userMap == null)  createUserList();
        System.runAs(userMap.get('Admin')) {
            
            try{
                BX041ApprovalHelper helper = new BX041ApprovalHelper();
                helper.submitForApproval(bx041.id, 'submission comment', new list<id>{userMap.get('PIYE').id});
                helper.rejectReq(bx041.id,'reject comment');
                
                helper.submitForApproval(bx041.id, 'submission comment', new list<id>{userMap.get('PIYE').id});
                helper.approveReq(bx041.id,'approve');
            }
            catch(Exception e){}
        
           
        }
        system.assertEquals(device.id,bx041.Device__c);
         test.stopTest();
        
    }
    
    static testmethod void testAppOrRejByFE()
    {
        //BX041ApproverHelperTest.initialize();
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(proc == null) createProcess();
        
        test.startTest();
        //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, '');
        BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, '');
        //System.runAs(userMap.get('Admin')) {
            

            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            helper.revertBX041(bx041);
            helper.submitForApproval(bx041.id, 'submission comment', null);
            helper.rejectReq(bx041.id,'reject comment');
            
            helper.submitForApproval(bx041.id, 'submission comment', null);
            helper.approveReq(bx041.id,null);
        	system.assertEquals(device.id,bx041.Device__c);
            
        //}
        test.stopTest();
    }
    
    static testmethod void testBacktrack2FE()
    {
        //BX041ApproverHelperTest.initialize();
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(proc == null) createProcess();
        test.startTest();
        //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, 'Backtrack to FTS');
        BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, 'Backtrack to FTS');
       
        //System.runAs(userMap.get('Admin')) {
            

            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            helper.BackTrackApproval(bx041.id, 'backtrack comment','Backtrack to FTS');
            
        //}  
            
           
            
            //bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, 'Backtrack to CE');
            bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, 'Backtrack to CE');
       
        //System.runAs(userMap.get('Admin')) {
            

            BX041ApprovalHelper helper1 = new BX041ApprovalHelper();
            helper1.BackTrackApproval(bx041.id, 'backtrack comment','Backtrack to CE');
            
            
        	system.assertEquals(device.id,bx041.Device__c);
           
        //}
         test.stopTest();
    }
    
    static testmethod void testBacktrack2CE()
    {
        //BX041ApproverHelperTest.initialize();
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(proc == null) createProcess();
        test.startTest();
        //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, 'Backtrack to CE');
        BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, 'Backtrack to CE');
        bx041.Assigned_Process_ID__c = proc.Id;
        system.debug(bx041.Geometry_Filter__c + ' vs' + proc.Tech_Geometry__c);
        system.debug(bx041.Process_Family_Filter__c + ' vs ' + proc.Process_Family__c);
        //System.runAs(userMap.get('Admin')) {
            
            
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            helper.BackTrackApproval(bx041.id, 'backtrack comment','Backtrack to CE');
        system.assertEquals(device.id,bx041.Device__c);
            
        //}
        test.stopTest();
    }
    
    static testmethod void testReopen()
    {
      Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
        if(proc == null) createProcess();
        test.startTest();
        //BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(dev, proc.id, 'Backtrack to CE');
        BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id, 'Backtrack to CE');
        bx041.Assigned_Process_ID__c = proc.Id;
        
        
        BX041ApprovalHelper helper = new BX041ApprovalHelper();
        helper.submitForApproval(bx041.id, 'submission comment', null);
        helper.recallReq(bx041, null);
        system.assertEquals(device.id,bx041.Device__c);
        test.stopTest();
    }
  
    static testmethod void testDeviceShare(){
      device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
        Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
        Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
        Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
        Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Device_Mask_Set_Title__c,
        Geometry_Filter__c,End_Application__c,PTRF_ID__c from device__c limit 1];
       if(proc == null) createProcess();
       if(userMap == null)  createUserList();
         test.startTest();
            BX_041__c bx041 = BX041ApproverHelperTest.createCDRS(device, proc.id,'Approved by FAE/FTS' );
            bx041.device__r = device;
            bx041.device__r.base_device__c = bx041.device__c;
             BX041ApprovalHelper helper = new BX041ApprovalHelper();
             if(userMap.containsKey('PIYE'))
                helper.shareDevicePIYEUsers(bx041, new list<id>{userMap.get('PIYE').id});
         system.assertEquals(device.id,bx041.Device__c);
         test.stopTest();
    }
    
}