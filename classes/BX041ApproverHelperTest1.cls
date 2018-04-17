/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions
 * Description: It is a BX041ApprovalHelperTest1 class.
 *             
 * History:
 * <Vijay>     04262015 - Test class created
 *  Devendra  10142015      - Updated to fix device validation error
 *  SNune    12062015    - Modified code for improving test coverage.
 */
@isTest
private class BX041ApproverHelperTest1{

    static id accId;
    static id oppId;
    static id oppGramId;
    static list<account_team_proxy__c> atpList;
    static map<string, user> userMap;
    static Device__c dev;
    static process__c proc;
    static String FabNo = 'Fab 3';
   @testsetup static void testdata() {
      DataUtilTest.loadEnvironmentVariables();
       createUserList();
        Id testAcctId = createAccount();
        Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', testAcctId, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        test.startTest();
        Id testOpptyId = createOpportunity(testAcctId); 
        Id testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        insert DeviceUtilTest.createCustomerMPWDeviceNew3(testAcctId, testOpptyId, testOpptyProgramId);
        test.stoptest(); 
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
    static BX_041__c createCDRSForInternalDevice(Device__c deviceObj, Id processId, String status){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceObj.id;
        if(status == ''){
            bx041.BX_041_Status__c = 'Pending Submission';
            bx041.Approval_status__c = '';
            bx041.Approval_Step__c = 'Pending for Account Owner';
            bx041.Initial_Submitter__c = 'Device Owner/Account Admin';
        } else if(status == 'Approved by CE'){
            bx041.BX_041_Status__c = 'Pending Review';
            bx041.Approval_status__c = 'Approved by CE';
            bx041.Approval_Step__c = 'Pending for CE';
            bx041.Initial_Submitter__c = 'FAE/FTS';
        }else if(status == 'Backtrack to FTS') {
            bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
            bx041.Approval_status__c = 'Approved by PI/YE';
            bx041.Approval_Step__c = 'Approved';
            bx041.Initial_Submitter__c = 'Device Owner/Account Admin';
        }else if(status == 'Backtrack to CE') {
            bx041.BX_041_Status__c = 'Frozen/Pending PID Assignment';
            bx041.Approval_status__c = 'Approved by PI/YE';
            bx041.Approval_Step__c = 'Approved';
            bx041.Initial_Submitter__c = 'FAE/FTS';
            //bx041.Assigned_Process_ID__c = procid;
            bx041.GAP_Closed__c = true;
            
        }
                 bx041.Assigned_Process_ID__c = processId;
        bx041.Geometry_Filter__c = deviceObj.Internal_Device_Geometry__c;
        bx041.Process_Family_Filter__c = deviceObj.Internal_Device_Process_Family__c;
        bx041.Requested_Process_ID__c = processId;

        insert bx041;  
        return bx041;
    }
    
    static testMethod void testSubmitForApproval(){
          User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
          Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,Internal_Device_Geometry__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Internal_Device_Process_Family__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,Assigned_Process_ID__c  from device__c limit 1];
        System.runAs(admin) {
            test.startTest();
            
            //BX_041__c bx041 = createCDRSForInternalDevice(device, DeviceUtilTest.createProcess('0.10UM'),'');
            BX_041__c bx041 = createCDRSForInternalDevice(device, device.Assigned_Process_ID__c ,'');
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            //FE Submission
            helper.submitForApproval(bx041.id, 'submission comment', null);
            helper.revertBX041(bx041); 
            helper.rejectReq(bx041.id,'reject comment');
            
            helper.submitForApproval(bx041.id, 'resubmission comment', null);
            helper.approveReq(bx041.id,'approve comment');
            system.assertEquals(device.Id, bx041.Device__c);
            test.stopTest();
        }
    }
    
    static testMethod void testSubmitForApproval1(){
        User piyeUser = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,Internal_Device_Geometry__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Internal_Device_Process_Family__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,Assigned_Process_ID__c from device__c limit 1];
        System.runAs(admin) {
            test.startTest();
            //BX_041__c bx041 = createCDRSForInternalDevice(device, DeviceUtilTest.createProcess('0.10UM'),'Approved by CE');
            BX_041__c bx041 = createCDRSForInternalDevice(device, device.Assigned_Process_ID__c,'Approved by CE');
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            
            helper.submitForApproval(bx041.id, 'submission comment', new list<id>{piyeUser.Id});
            helper.approveReq(bx041.id,'approve comment');
            system.assertEquals(device.Id, bx041.Device__c);
            test.stopTest();
        }
    }
    
     static testmethod void testBacktrack2CEForInternalDevice(){
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,Internal_Device_Geometry__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Internal_Device_Process_Family__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,Assigned_Process_ID__c from device__c limit 1];
        //string processId = DeviceUtilTest.createProcess('0.10UM');
        test.startTest();
        System.runAs(admin) {
             
            //BX_041__c bx041 = createCDRSForInternalDevice(device, processId,'Backtrack to CE');
            BX_041__c bx041 = createCDRSForInternalDevice(device, device.Assigned_Process_ID__c,'Backtrack to CE');
            //bx041.Assigned_Process_ID__c = processId;
            bx041.Assigned_Process_ID__c = device.Assigned_Process_ID__c;
            update bx041;
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            helper.BackTrackApproval(bx041.id, 'backtrack comment','Backtrack to CE');
            system.assertEquals(device.Id, bx041.Device__c);
            
        }
        test.stopTest();
    }
    
    static testmethod void testBacktrack2CEForInternalDevice2(){
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        Device__c device =  [select id,Name,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,
         Market_Segment__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,
         Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,Internal_Device_Geometry__c,CRMDID__c,Device_Type__c,MPW_Train_Number__c,
         Confidence_Level_Tapeout__c,Reticle_Type__c,Original_Forecasted_Tapeout_Date__c,
         Previous_Enabling_Devices_MPW__c,Actual_Tapeout_Date__c,Process_Family_Filter__c,Internal_Device_Process_Family__c,Device_Mask_Set_Title__c,
         Geometry_Filter__c,End_Application__c,PTRF_ID__c,Assigned_Process_ID__c from device__c limit 1];
        //string processId = DeviceUtilTest.createProcess('0.10UM');
        test.startTest();
        System.runAs(admin) {
             
            //BX_041__c bx041 = createCDRSForInternalDevice(device, processId,'Backtrack to FTS');
            BX_041__c bx041 = createCDRSForInternalDevice(device, device.Assigned_Process_ID__c,'Backtrack to FTS');
            //bx041.Assigned_Process_ID__c = processId;
            bx041.Assigned_Process_ID__c = device.Assigned_Process_ID__c;
            update bx041;
            BX041ApprovalHelper helper = new BX041ApprovalHelper();
            helper.BackTrackApproval(bx041.id, 'backtrack comment','Backtrack to FTS');
            system.assertEquals(device.Id, bx041.Device__c);            
        }
        test.stopTest();
    }    
}