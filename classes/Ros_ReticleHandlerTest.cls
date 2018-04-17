/*
Test Classfor Rosr_reticle handler
 to send an Email to the Primary csr and back up csr 
when status is changed to pending Debit note.
Author: Ravikiran Nadella
Version 1.0.
*/
@isTest
public class Ros_ReticleHandlerTest{
 @testSetup
  static void testDataSetup(){
      Environment_Variable__c envvar1 = new Environment_Variable__c(Name = 'ROS_EUCForm_Table_Headers',Value__c = 'Product Description;Product Code;HS Code;Brand;Model;Quantity;Value;');
        Environment_Variable__c envvar2 = new Environment_Variable__c(Name = 'ROS_EUCForm_Fabs',Value__c = 'FAB 2;FAB 3;FAB 3E;FAB 5;FAB 6;FAB 7');
        Environment_Variable__c envvar3 = new Environment_Variable__c(Name = 'SIEBEL_OPPTY_ID_SEQUENCE_NO',Value__c = '34342');
        Environment_Variable__c envvar4 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_HS_Code_Assign',Value__c = 'Pending HS Code Assignment');
        Environment_Variable__c envvar5 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_Wit_Arriv_Date',Value__c = 'Pending Witness Arrival Date');
        Environment_Variable__c envvar6 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_EUC_Form',Value__c = 'Pending EUC Form');
        Environment_Variable__c envvar7 = new Environment_Variable__c(Name = 'ACCT_RT_ID_CUSTOMER',Value__c = '012900000004Ba9');
        Environment_Variable__c envvar8 = new Environment_Variable__c(Name = 'ACCT_RT_ID_GF_INTERNAL',Value__c = '012900000004Aa8');
        List<Environment_Variable__c> lstenvvar = new List<Environment_Variable__c>{envvar1,envvar2,envvar3,envvar4,envvar5,envvar6,envvar7,envvar8};
        insert lstenvvar;
        
        Error_Codes__c err = new Error_Codes__c(Name='CONFIG_STAGE_VALIDATION',Message__c='Test Error Message');
        insert err;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
            fieldValueMap.put('Account_Type__c', 'Customer');                           
            fieldValueMap.put('sub_type__c', 'Indirect');        
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
            //AccountDataFactory.createAccount(fieldValueMap);
            Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
       bl.Name='Update Bill To Address No';
       bl.Bill_To_Address_Number__c = 2072;
       insert bl;
  }
  
  static void loadCustomSettings(){
        DataUtilTest.LoadFabEnvVariables();
        DataUtilTest.LoadATPEnvVariables();
        DataUtilTest.LoadDeviceEnvVariable();
        DataUtilTest.LoadFabReticleEnvVariables();
        //DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadOpptyEnvVariables();
        DataUtilTest.LoadOPTMEnvVariables();
        DataUtilTest.LoadReticleDeviceEnvVariables();
        DataUtilTest.LoadReticleDWEnvVariables();
        DataUtilTest.LoadReticleEnvVariables();
        list<Environment_Variable__c> evList = [select name, value__c from Environment_Variable__c where Name = 'HCM Account Id'];
        system.debug(logginglevel.error, evList);
        ROS_Witness_Arrival_Accounts__c roswa = new ROS_Witness_Arrival_Accounts__c(SetupOwnerId = UserInfo.getOrganizationId(),Account_Short_Name__c='TestAcct1N');
        insert roswa;
    }
       static Id createReticleCycle() {        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    
    }
  static user createUser(id profileId,String uName,string eId){
     
      User u = new User(Alias = 'standt', Email=eId, 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = profileId, 
                TimeZoneSidKey='America/Los_Angeles', UserName=uName);
        insert u ;
        return u;
  }
  
    
    static Account_Team_Proxy__c createApxy(string accId,string usrId ,string Role){
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c();
        atp1.Account__c=accid;
        atp1.User__c=usrId;
        atp1.Account_Access__c='Read/Write';
        atp1.Opportunity_Access__c='Read/Write';
        atp1.Team_Role__c=Role;
        insert atp1;
        return atp1;
    }

        
        
  static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending Debit Note';
        RT.ROS_Status__c ='Keep';
        
        insert RT;
        return RT;
    }
  
  private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        return acct;
    }
      
      @isTest
      static void testMethod1(){
          loadCustomSettings();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        
        user bckCSR=createUser(p.id,'bcsr@csr.com','bcsr@csr.com');
        user priCSR=createUser(p.id,'csgfr@csgfr.com','csgfr@csgfr.com');
        priCSR.ManagerId=bckCSR.id;
        update priCSR;
       // user priAM=createUser(p.id,'pam@csr.com','pam@csr.com');
        //user priCSRM=createUser(p.id,'pri@csr.com','pri@csr.com');
        //Account accntObj = getAccount('MYTEST ACCOUNT1'); 
        String accountId = DeviceUtilTest.createAccount();
        
        system.debug('accountId****>>??' +accountId);
        Account_Team_Proxy__c createApxy1=createApxy(accountId,priCSR.id ,'Primary Customer Service Rep');
       system.debug('createApxy1****>>??' +createApxy1);
       //Account_Team_Proxy__c createApxy2=createApxy(accountId,bckCSR.id ,'Backup Customer Service Rep');
        //Account_Team_Proxy__c createApxy3=createApxy(accountId,priAM.id ,'Primary Account Manager');
        string rosCycle = createReticleCycle();
        system.debug('rosCycle****>>??' +rosCycle);
        Reticle__c rt=createReticle(accountId,rosCycle,20,priCSR.id);
        
        system.debug('reticle****>>??' +rt);
        test.startTest();
        RT.Pending_Debit_Note_Date__c=date.newInstance(2016, 10, 21);
        update RT;
         ROS_PendingDebitNoteSchedular sh1 = new ROS_PendingDebitNoteSchedular();
String sch = '0 0 23 * * ?';
 system.schedule('Test Schedular Check', sch, sh1); 

        test.stopTest();
        
      }
    
}