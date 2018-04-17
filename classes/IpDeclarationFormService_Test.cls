/*
  Author: Anirban Roy
  Description: This is the test class for the IpDeclarationFormService class.
  History:
    ARoy        10132013    - code creation. 
    Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.                      
*/

@isTest(seealldata=false)
public class IpDeclarationFormService_Test {
    @testSetup static void testdata() {
        
        DataUtilTest.loadEnvironmentVariables();
        //string acctId = DeviceUtilTest.createAccount();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'Test Account');
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
        String acctId = AccountDataFactory.createAccount(fieldValueMap).Id;
        
        
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Test.startTest();
        Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        Insert Device;
        Test.stopTest();
    }
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    
    
    /*static List<User> retrieveUserList(){
        List<User> usrList = [select id,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];
        return usrList;
    }*/
    
     static List<User> retrieveUserList(){
        List<User> usrList = [select id,name,email,IsActive  from User where profileId in (select id from Profile where Name in ('GF FAE/FTS','GF FE')) limit 10];
        return usrList;
    }  
    
    // Creation of an Account
    static Id createAccount(){
        Account acc = new Account(Name='win Test Account 12345',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India',IP_Declaration_Template__c = 'IP_Declaration_Version_default');
        
        insert acc;
        return acc.Id;
    }
    
    // Creation of an Account
    static Id createAccount1(){
        Account acc = new Account(Name='Win Test Account 23456',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India',IP_Declaration_Template__c='IP_Decl_Cust01');
        
        insert acc;
        return acc.Id;
    }
    
    // Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact();
        con.FirstName='Mr';
        con.LastName='Testcon1';
        con.AccountId=acctId;
        con.Email='con1@gf.com';
        con.Department__c='Design';
                                  
        insert con;
        return con.Id;
    }
    
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Win Test Opportunity 12345');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    // Creation of an opportunity program team member
    static List<Opportunity_Program_Team_Member__c> createOppProgTmMem1(Id oppProgId){
        List<Opportunity_Program_Team_Member__c> opptmList = new List<Opportunity_Program_Team_Member__c>();
        List<User> usrList = [select id,isactive,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];
       
      //  for(User u : userList){
            Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                            User__c=usrList[0].Id,Flag_for_Delete__c=false);
            
            Opportunity_Program_Team_Member__c oppProgTM1 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Primary Account Manager',
                                            User__c=usrList[1].Id,Flag_for_Delete__c=false,Is_FAE__c=true);
          
           
           Opportunity_Program_Team_Member__c oppProgTM2 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Account Manager',
                                            User__c=usrList[2].Id,Flag_for_Delete__c=false,Is_FAE__c=true);
          
          Opportunity_Program_Team_Member__c oppProgTM3 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c=' Primary Customer Service Rep',
                                            User__c=usrList[3].Id,Flag_for_Delete__c=false);
          
          
          Opportunity_Program_Team_Member__c oppProgTM4 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Primary Field Application Engineer',
                                            User__c=usrList[4].Id,Flag_for_Delete__c=false);
          
          
           Opportunity_Program_Team_Member__c oppProgTM5 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Backup Customer Service Rep',
                                            User__c=usrList[5].Id,Flag_for_Delete__c=false);
            opptmList.add(oppProgTM);    
            opptmList.add(oppProgTM1);  
            opptmList.add(oppProgTM2); 
            opptmList.add(oppProgTM3); 
            opptmList.add(oppProgTM4); 
            opptmList.add(oppProgTM5);   
       // }
            
        insert opptmList;
        return opptmList;
    }
    
    //Creation of Process Technology
    static Process_Technology__c createPT(){
        Process_Technology__c rq = new Process_Technology__c (name = 'PT002929',PT_number__c = 'PT002929');
        insert rq;
        Process_Technology__c PT = [Select id,name, PT_number__c from Process_Technology__c where PT_number__c = 'PT002929' limit 1];
        return PT;
    }
    
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Confidence_Level_Tapeout__c = '0';
        dev.Fab__c = 'FAB 1';
        insert dev;
        return dev;
    }
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id PTId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.process_technology_2__c = PTId;
        dev.Confidence_Level_Tapeout__c = '0';
        dev.Fab__c = 'FAB 1';
        insert dev;
        return dev; 
    }
       */
    static IP_Declaration_Form__c createIpDecForm(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Draft';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        IpDecForm.Last_Assigned_Customer_User__c = UserInfo.getUserId();
        
        Insert ipDecForm;        
        
        return ipDecForm;
    }
    
    static IP_Component_From_ERP__c createIPCompFromERP(){
        IP_Component_From_ERP__c comERP2 = new IP_Component_From_ERP__c (
            Name = 'ARAGIO_110G_IO_X',
            oic_ip_component__c = 'ARAGIO_130_IO_X',
            vendor__c = 'ARAGIO',
            FV_vendor__c = 'Aragio',
            tech_geo__c = '28nm',
            tech_type__c = '28G',
            IP_type__c = 'IO',
            IP_type_desc__c = 'IO Library',
            FV_IP_type__c = 'IO Library',
            Enabled_Flag__c = true 
        ); 
        insert comERP2;
        return comERP2;
    }
    
     static IP_Declaration_Component__c createIPDecComponent(Id ipCompFromERPId, Id ipDecFormId){
        IP_Declaration_Component__c decComp1 = new IP_Declaration_Component__c(
            master_ip_component__c = ipCompFromERPId,
            ip_declaration_form__c = ipDecFormId,
            vendor__c = 'vendor 1',
            IP_type__c = 'IO',
            tech_type__c = '0.11',
            tech_geometry__c = '0.11'
            
        ); 
        insert decComp1;
        return decComp1;
    }
    
    static Process_Technology_IP_Component__c createPTIPCom(id ipcerpId, id ptid){
        Process_Technology_IP_Component__c  ptipc = new Process_Technology_IP_Component__c(IP_Component_from_ERP__c = ipcerpId, Process_Technology__c = ptid);
        insert ptipc;
        return ptipc;
    }
    static testMethod void reOpenIpDecFormTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User user = IpDeclarationFormService_Test.createUser1();
        //List<User> userList = [select id,isactive,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];
       
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Test.startTest();
        Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        IP_Declaration_Form__c ipDecForm = IpDeclarationFormService_Test.createIpDecForm(dev.Id);
        
        ipDecForm.Status__c = 'Approved';
        update ipDecForm;
        
        List<Opportunity_Program_Team_Member__c> oppProgTM = IpDeclarationFormService_Test.createOppProgTmMem1(testOpptyProgramId.Id);  
        system.debug('oppProgTM%%%'+oppProgTM);
          
        PermissionSetAssignment psa = [Select PermissionSet.Name, Assignee.id From PermissionSetAssignment where PermissionSet.Name = 'DE_Administrator' and Assignee.isActive = true limit 1];
        User u = psa.Assignee;
        System.runAs(u){
        String retMsg = IpDeclarationFormService.reOpen(ipDecForm.Id);
        }
        String retMsg1 = IpDeclarationFormService.reOpen(ipDecForm.Id);
        //system.assertEquals(retMsg,'OK');
        Test.stopTest();
     }
     
     static testMethod void submitIpDecFormTestRequiredPT(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
       List<User> userList = [select id,isactive,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];
       
        //Required PT validation
        Process_Technology__c PT = IpDeclarationFormService_Test.createPT();                
       // Device__c dev = DeviceUtilTest.createDevice();
        Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
         
        Test.startTest();
         Device__c dev = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
         
        dev.Process_Technology_2__c=PT.id;
        update dev;
        
        IP_Declaration_Form__c ipDecForm = IpDeclarationFormService_Test.createIpDecForm(dev.Id);  
            
        IP_Declaration_Form__c ipDecForm1= [Select Id,device__r.Opportunity_Program__c,device__r.Process_Technology_2__r.name from IP_Declaration_Form__c where device__c=:dev.Id];
            
        system.debug('ipDecForm1.device__r.Process_Technology_2__c%%%'+ipDecForm1.device__r.Process_Technology_2__r.name);
             
         
        
        PermissionSetAssignment psa = [Select PermissionSet.Name, Assignee.id From PermissionSetAssignment where PermissionSet.Name = 'DE_Administrator' and Assignee.isActive = true limit 1];
        User u = psa.Assignee;
        System.runAs(u){
            
            IP_Component_From_ERP__c ipc_erp = IpDeclarationFormService_Test.createIPCompFromERP();    
            
            IP_Component_From_ERP__c ipc_erp1  = [Select Id,fv_vendor__c from IP_Component_From_ERP__c where name = 'ARAGIO_110G_IO_X'];
            
            String retMsg2 = IpDeclarationFormService.submitForApproval(ipDecForm1.Id);
            
            IP_Declaration_Component__c ipdc = createIPDecComponent(ipc_erp1.id, ipDecForm1.id);
            
            String retMsg3 = IpDeclarationFormService.submitForApproval(ipDecForm1.Id);

            
            Process_Technology_IP_Component__c ptipc = createPTIPCom(ipc_erp1.id, PT.id);
            system.debug('ptipc.process_technology__c %%%'+ptipc.process_technology__c);
            system.debug('Process_Technology_IP_Component__cptipc.ip_component_from_ERP__c %%%'+ptipc.ip_component_from_ERP__c);
            
            
            
            Process_Technology_IP_Component__c ptipc1 = [Select Id,process_technology__c,ip_component_from_ERP__c,
                                                                 ip_component_from_ERP__r.fv_vendor__c 
                                                                 from Process_Technology_IP_Component__c where process_technology__c=:PT.id];
            
            system.debug('ipc_erp1.fv_vendor__c %%%'+ipc_erp1.fv_vendor__c);
            system.debug(' ip_component_from_ERP__r.fv_vendor__c %%%'+ptipc1.ip_component_from_ERP__r.fv_vendor__c);
            
            
            
            String retMsg = IpDeclarationFormService.submitForApproval(ipDecForm1.Id);
        }
        
        List<Opportunity_Program_Team_Member__c> oppProgTM = IpDeclarationFormService_Test.createOppProgTmMem1(testOpptyProgramId.Id);  
            system.debug('oppProgTM%%%'+oppProgTM);
         
        String retMsg1 = IpDeclarationFormService.submitForApproval(ipDecForm1.Id);
        
        
        Test.stopTest();
     }
     
    /*  static testMethod void submitIpDecFormTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        //List<User> userList = IpDeclarationFormService_Test.retrieveUserList();
         List<User> userList = [select id,isactive,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];  
         Account acctId = [Select Id from Account where name = 'Test Account'];
        Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        
        List<Opportunity_Program_Team_Member__c> oppProgTM = IpDeclarationFormService_Test.createOppProgTmMem1(testOpptyProgramId.id, userList);  
       
        
        system.debug('testOpptyProgramId d%%%'+testOpptyProgramId.id);
        
        Test.startTest();
        Device__c dev = [Select Id,Opportunity_Program__c  from Device__c where name = 'TESTDEVICEZAIH12345677'];
        system.debug('dev d%%%'+dev.Opportunity_Program__c);
        IP_Declaration_Form__c ipDecForm = IpDeclarationFormService_Test.createIpDecForm(dev.Id); 
        IP_Declaration_Form__c ipDecForm1=[select id,Device__c,Device__r.Opportunity_Program__c from IP_Declaration_Form__c where Device__c=:dev.id];
        
        
         
        String retMsg = IpDeclarationFormService.submitForApproval(ipDecForm1.Id);
        //system.assertEquals(retMsg,'OK');                
        Test.stopTest();
     }*/
}