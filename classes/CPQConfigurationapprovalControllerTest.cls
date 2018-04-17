/*
    Author: Monalisa Mohhapatra
    Description: This Class serves as the controller for the CPQConfigurationapprovalController.
    History: 
        Monalisa      15122014    - Code creation.
        ARoy          11062015    - Code modification for new validation.
        Karna Shiva   Sprint II   - Code modification for retrofit validation.
        Amrita Agarwala sprint 4  - Added test method for Design Win
        
*/ 
@isTest(SeeAllData=false)
private class CPQConfigurationapprovalControllerTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('IP_Declaration_Template__c', 'IP_Declaration_Version_default');        
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
    //Creation of User
    static User createUser1(){
        User usr1 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    static User createUser2(){
        User usr2 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF Global Admin') and IsActive=true limit 1];
        return usr2;
    }
    static User createUser3(){
        User usr3 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF FAE/FTS') and IsActive=true limit 1];
        return usr3;
    }
    static User createUser4(){
        User usr4 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF PIYE') and IsActive=true limit 1];
        return usr4;
    
    
    }
   
    
    
    
  
    
    // Creation of Account Team Proxy
    static void createAccountTeamProxy(Id acctId){
        List<User> usrList = [select    id
                              from      User
                              where     profileId in (select id from Profile where Name='GF FAE/FTS') and IsActive=true
                              limit 10
                             ];
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        for(User u : usrList){
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acctId,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer');
            atpList.add(atp);
        }
        insert atpList;
        
    }
    
    // Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact();
        con.FirstName='Mr';
        con.LastName='Testcontact1';
        con.AccountId=acctId;
        con.Email='con1@gf.com';
        con.Department__c='Design';
                                  
        insert con;
        return con.Id;
    }
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name='Win Test Opportunity 12345_MM',AccountId=acctId,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Process_Geometry__c = '0.09UM',Process_Family__c = 'Generic / Nominal',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21));
        
        insert opp;
        return opp.Id;
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345_MM',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Technical Support',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    //Static method to create product test record
    static Process_Technology__c createProcess(String szName){
        //Create a proposal line item
        Process_Technology__c process = new Process_Technology__c(Name = szName  ); 
        insert process;
        return process;
    }
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        pt.Tech_Geometry__c ='0.014UM';
        insert pt;
        return pt;   
    }
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Retrofit';
        dev.Device_ID__c ='89898989';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = true ; 
        dev.Fab__c = 'Fab 3';
        dev.Process_Technology_2__c = createProcess('PT00test').id ; 
        
        insert dev;
        return dev; 
    }
    
    //Creation of Configuration
     //Creation of Configuration For Design Win
    static Apttus_Proposal__Proposal__c createConfigfordesignwin(Id accId, Id oppId) {
        
        Apttus_Proposal__Proposal__c config4designWin=new Apttus_Proposal__Proposal__c();
        config4designWin.Apttus_Proposal__Opportunity__c=oppId;
        config4designWin.Apttus_Proposal__Account__c=accId;
        config4designWin.Apttus_Proposal__Proposal_Name__c='TestConfig4designwin';
        config4designWin.Purpose_of_the_Configuration__c = 'For Design Win';
         config4designWin.Metal_Option_Not_Listed__c = true;
       
        /*Schema.DescribeFieldResult statusFieldDescription = Apttus_Proposal__Proposal__c.Purpose_of_the_Configuration__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){
            if(pickListEntry.getLabel() == 'For Design Win' ){
                system.debug('>>For Design Win');
                config4designWin.Purpose_of_the_Configuration__c = 'For Design Win';
            }
        }*/
        
        insert config4designWin;
        
       // system.debug('>>Purpose_of_the_Configuration__c = ' + config4designWin.Purpose_of_the_Configuration__c);
        
        return config4designWin;
    }
    static Apttus_Proposal__Proposal__c createConfig1() {
        // Create Configuration
        
        Apttus_Proposal__Proposal__c config1=new Apttus_Proposal__Proposal__c();
        
        config1.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config1.APTPS_Primary__c = True;
        config1.Metal_Option_Not_Listed__c = true;
        insert config1;
        
        return config1;
    }
    //Creation of Configuration with all data
    static Apttus_Proposal__Proposal__c createConfig3(Id accId,Id oppId, Id devId, Process_Technology__c pt) {
        
        Apttus_Proposal__Proposal__c config3=new Apttus_Proposal__Proposal__c();
        config3.Apttus_Proposal__Opportunity__c=oppId;
        config3.Apttus_Proposal__Account__c=accId;
        config3.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config3.Device__c=devId;
        config3.Process_Technology_Lookup__c = pt.Id;
        config3.APTPS_Primary__c = True;
        //Nikhil Bajaj
      //  Config3.SRAM__c = 'Yes';
          //  Config3.PTRF_Rotation__c = '90';
          //  Config3.SRAM_Gate_Orientation__c = 'Horizontal';
         //   Config3.ACLV_Gate_Orientation__c  = 'Horizontal';
         //   Config3.Approval_Check__c =true;
           // Config3.Device__r.Fab__c ='FAB 1';
         //   Config3.Approved_by_Packaging_Team__c =false;
         config3.Consolidated_IP_Status_Check__c = 'yes';
         config3.Purpose_of_the_Configuration__c ='Preliminary';
         
         Config3.Process_Technology__c = 'PT002421';
            Config3.SRAM__c = 'Yes';
            Config3.PTRF_Rotation__c = '90';
            Config3.SRAM_Gate_Orientation__c = 'Horizontal';
            Config3.ACLV_Gate_Orientation__c  = 'Horizontal';


            
            
           
            
            
        insert config3;
        
        return config3;
    }
    
    
     static Apttus_Proposal__Proposal__c createConfigTest(Id accId,Id oppId, Id devId, Process_Technology__c pt) {
     Apttus_Proposal__Proposal__c config3=new Apttus_Proposal__Proposal__c();
     config3.Process_Technology_Lookup__c = pt.Id;
       config3.Apttus_Proposal__Account__c=accId;  
      config3.Purpose_of_the_Configuration__c ='Preliminary';
      config3.IS_Manually_Configured__c =True;
     // config3.Process_Technology_Name__c =
      config3.Process_Technology_Name_1__c ='28nm Generic (G) Baseline (PT002167)';
      config3.Device__c=devId;
      config3.SRAM__c='Yes';
      config3.SRAM_Gate_Orientation__c ='Horizontal';
      config3.Gate_Orientation_PFET__c ='Horizontal';
      
      
      //config3.Poly_Orientation_Status_1__c
     // config3.Device__r.Tapeout_Type__c = 'Retrofit';
      config3.Justification_of_Retrofit__c ='test';
      //config3.Process_Technology_Geometry__c = '0.014UM';
      config3.Packaging_Disclaimer_Message__c='test';
     
        
        
        config3.Apttus_Proposal__Opportunity__c=oppId;
        
        config3.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config3.Device__c=devId;
        
        config3.APTPS_Primary__c = True;
     
         config3.Consolidated_IP_Status_Check__c = 'yes';
        
         
         Config3.Process_Technology__c = 'PT002421';
           // Config3.SRAM__c = 'Yes';
            Config3.PTRF_Rotation__c = '90';
            Config3.SRAM_Gate_Orientation__c = 'Horizontal';
            Config3.ACLV_Gate_Orientation__c  = 'Horizontal';


            
            
           
            
            
        insert config3;
        
        return config3;
    }
    
    
    
    
    //Creation of Configuration without Device
    static Apttus_Proposal__Proposal__c createConfig2(Id accId,Id oppId) {
        // Create Configuration
       
        Apttus_Proposal__Proposal__c config2=new Apttus_Proposal__Proposal__c();
        
        config2.Apttus_Proposal__Account__c=accId;
        config2.Apttus_Proposal__Opportunity__c=oppId;
        config2.Apttus_Proposal__Proposal_Name__c='TestConfig1';
        config2.Device__c=null;
        config2.APTPS_Primary__c = False;
        insert config2;
        
        return config2;
    }
    
  /*  static testMethod void testApprovalProcessInternal(){
      
       Profile profile = [Select Id from Profile where name = 'System Administrator'];


          User admin= new User( ProfileId = profile.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                        HCM_Employee_ID__c='E1006044',
                        HCM_Login_ID__c='E1006044'

                                               );
       test.startTest();
      System.runAs(admin){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT111');            
        fieldValueMap.put('IP_Declaration_Template__c', 'IP_Declaration_Version_default');        
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

    Account accId=  AccountDataFactory.createAccount(fieldValueMap);

        User user = CPQConfigurationapprovalControllerTest.createUser1();
           String oppId = CPQConfigurationapprovalControllerTest.createOpp(accId.Id);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(accId.Id, oppId);
        
        //String acctId = getAccount('MYTEST ACCOUNT1').id;
       // String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        //String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = CPQConfigurationapprovalControllerTest.createOppProgTmMem(oppProgId, user.Id); 
        
        
            Device__c dev2;
            Process_Technology__c testPt=CPQConfigurationapprovalControllerTest.createPT();
            
         


          
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            dev2 = CPQConfigurationapprovalControllerTest.createDevice(accId.Id,oppId,oppProgId);
           
            Apttus_Proposal__Proposal__c testConfig3 =CPQConfigurationapprovalControllerTest.createConfig3(accId.Id,oppId,dev2.Id,testPt);
            //testConfig3.Process_Technology__c = 'PT002421';
            //testConfig3.SRAM__c = 'Yes';
            //testConfig3.PTRF_Rotation__c = '90';
            //testConfig3.SRAM_Gate_Orientation__c = 'Horizontal';
           // testConfig3.ACLV_Gate_Orientation__c  = 'Horizontal';
           // update testConfig3;
            Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig3);
            system.currentPageReference().getParameters().put('id', testConfig3.Id);
            Apexpages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');                        
            CPQConfigurationapprovalController testApproval1=new CPQConfigurationapprovalController(stdController);
            testApproval1.initialised = false;
            testApproval1.errorFlag = false;                      
            testApproval1.ErrorMessage = '';                        
            testApproval1.userType = null;                     
            testApproval1.entryFlag = true;
            testApproval1.acntFlag = false;
            testApproval1.ptFlag = false;
            testApproval1.posFlag = false;
            testApproval1.devFlag = false;
            testApproval1.devFabFlag = false;
            testApproval1.ddDisableFlag = false;
            testApproval1.metalOptionFlag= false;  
            
            testApproval1.init();
            

        test.stopTest();
         }
    }*/

   
    static testMethod void testApprovalProcessExternal(){
 	   test.startTest();
       
        User user = CPQConfigurationapprovalControllerTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        createAccountTeamProxy(acctId);
	    Device__c dev2;
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId); 
                   
        Process_Technology__c testPt=CPQConfigurationapprovalControllerTest.createPT();
          
        Profile profile = [Select Id from Profile where name = 'System Administrator'];


          User admin= new User( ProfileId = profile.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                        HCM_Employee_ID__c='E1006044',
                        HCM_Login_ID__c='E1006044'

                                               );
                                               
		    System.runAs(admin){
             	EmailTemplate et = new EmailTemplate();  
                et.isActive = true;  
                et.Name = 'testTemplate';  
                et.DeveloperName = 'testTemplate';
                et.TemplateType = 'text';  
                et.FolderId = UserInfo.getUserId(); 
                et.Body = 'test'; 
                Database.insert(et);
                System.assertEquals(et.Name,'testTemplate');
                
                EmailTemplate et2 = new EmailTemplate();  
                et2.isActive = true;  
                et2.Name = 'testTemplate2';  
                et2.DeveloperName = 'testTemplate2';
                et2.TemplateType = 'text';  
                et2.FolderId = UserInfo.getUserId(); 
                et2.Body = 'test'; 
                Database.insert(et2);
                System.assertEquals(et2.Name,'testTemplate2');
                  
                
                
              CPQTempCS__c tempcs = new CPQTempCS__c();
                tempcs.Name='CPQTemplate';
                tempcs.Template_Name__c='testTemplate';
                tempcs.FAE_Template_Name__c='testTemplate2';
                Database.insert(tempcs);
                System.assertEquals(tempcs.Name,'CPQTemplate');
                
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            dev2 = CPQConfigurationapprovalControllerTest.createDevice(acctId,oppId,oppProgId);
          
   
            Apttus_Proposal__Proposal__c testConfig3 =CPQConfigurationapprovalControllerTest.createConfig3(acctId,oppId,dev2.Id,testPt);
                test.stopTest();
          
            
            Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
            propShare.ParentId = testConfig3.Id;
            propShare.UserOrGroupId = user.Id;
            propShare.AccessLevel = 'edit';
            insert propShare;
            Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig3);
            system.currentPageReference().getParameters().put('id', testConfig3.Id);
            Apexpages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');                        
            CPQConfigurationapprovalController testApproval1=new CPQConfigurationapprovalController(stdController);
            testApproval1.initialised = false;
            testApproval1.errorFlag = false;                      
            testApproval1.ErrorMessage = '';                        
            testApproval1.userType = null;                     
            testApproval1.entryFlag = true;
            testApproval1.acntFlag = false;
            testApproval1.ptFlag = false;
            testApproval1.posFlag = false;
            testApproval1.devFlag = false;
            testApproval1.devFabFlag = false;
            testApproval1.ddDisableFlag = false;
            testApproval1.metalOptionFlag= false;  

            CPQConfigurationApprovalHelper testAppHelper = new CPQConfigurationApprovalHelper();
            testAppHelper.submitForApproval(testConfig3);
                     
             try{
            	String x = null;
            	x.toLowerCase();
            }catch(Exception e){
                testApproval1.handleException('test',e);
            }
            }
                 
           
    }
   
    static testMethod void testApprovalProcess2(){
        
         test.startTest();
        User user = CPQConfigurationapprovalControllerTest.createUser2();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        //String conId = CPQConfigurationapprovalControllerTest.createContact(acctId);
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = CPQConfigurationapprovalControllerTest.createOppProgTmMem(oppProgId, user.Id);     
        Apttus_Proposal__Proposal__c testConfig1=CPQConfigurationapprovalControllerTest.createConfig1();
        
       
            
            Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig1);
            system.currentPageReference().getParameters().put('id', testConfig1.Id);
            CPQConfigurationapprovalController testApproval2=new CPQConfigurationapprovalController(stdController);
        test.stopTest();
    }
    static testMethod void testApprovalProcess3(){

        User user = CPQConfigurationapprovalControllerTest.createUser3();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        test.startTest();
       // String conId = CPQConfigurationapprovalControllerTest.createContact(acctId);
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = CPQConfigurationapprovalControllerTest.createOppProgTmMem(oppProgId, user.Id);     
       // Apttus_Proposal__Proposal__c testConfig2=CPQConfigurationapprovalControllerTest.createConfig2(acctId,oppId);
        Apttus_Proposal__Proposal__c testConfig1=CPQConfigurationapprovalControllerTest.createConfig1();
         
        
            System.runAs(user){
            Apexpages.StandardController stdController1 = new Apexpages.StandardController(testConfig1);
            system.currentPageReference().getParameters().put('id', testConfig1.Id);
            CPQConfigurationapprovalController testApproval1=new CPQConfigurationapprovalController(stdController1);

            }
        test.stopTest();
    }
    static testMethod void testApprovalProcess4(){
        test.startTest(); 
        User user = CPQConfigurationapprovalControllerTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        //String conId = CPQConfigurationapprovalControllerTest.createContact(acctId);
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = CPQConfigurationapprovalControllerTest.createOppProgTmMem(oppProgId, user.Id); 
        Apttus_Proposal__Proposal__c testConfig1=CPQConfigurationapprovalControllerTest.createConfig1();
                   
            
            PageReference myVfPage = Page.CPQConfigurationApprovalVF;
            Test.setCurrentPageReference(myVfPage);  
            ApexPages.currentPage().getHeaders().put('referer', 'GlobalfoundryView');

            ApexPages.currentPage().getParameters().put('id',testConfig1.Id);
            String id = ApexPages.currentPage().getParameters().get('id');
            system.assertEquals(true,id!=null);
           
            ApexPages.StandardController sc = new ApexPages.StandardController(testConfig1);
            CPQConfigurationapprovalController testApproval1 = new CPQConfigurationapprovalController(sc);
            testApproval1.Back();
            testApproval1.init();
            try{
            String x = null;
            x.toLowerCase();
            }catch(Exception e){
                testApproval1.handleException('ALREADY_IN_PROCESS',e);
            }
        test.stopTest();
    }
    
    
     static testMethod void testApprovalProcess5(){
   

        User user = CPQConfigurationapprovalControllerTest.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = CPQConfigurationapprovalControllerTest.createOppProgTmMem(oppProgId, user.Id); 
        
        test.startTest();
            
          Profile profile = [Select Id from Profile where name = 'System Administrator'];


          User admin= new User( ProfileId = profile.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                        HCM_Employee_ID__c='E1006044',
                        HCM_Login_ID__c='E1006044'

                                               );


          System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            }
            Apttus_Proposal__Proposal__c testConfig3 =CPQConfigurationapprovalControllerTest.createConfigfordesignwin(acctId,oppId);
      

            Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig3);
            system.currentPageReference().getParameters().put('id', testConfig3.Id);
            Apexpages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');                        
            CPQConfigurationapprovalController testApproval1=new CPQConfigurationapprovalController(stdController);
            testApproval1.initialised = false;
            testApproval1.errorFlag = false;                      
            testApproval1.ErrorMessage = '';                        
            testApproval1.userType = null;                     
            testApproval1.entryFlag = true;
            testApproval1.acntFlag = false;
            testApproval1.ptFlag = false;
            testApproval1.posFlag = false;
            testApproval1.devFlag = false;
            testApproval1.devFabFlag = false;
            testApproval1.ddDisableFlag = false;
            testApproval1.metalOptionFlag= false;  
            testApproval1.init();
            try{
            String x = null;
            x.toLowerCase();
            }catch(Exception e){
                testApproval1.handleException('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY',e);
            }
            
            
        test.stopTest();

       
    }
    
    
    static testMethod void testApprovalProcessExternal2(){
         
        test.startTest();
        
        TriggerHandler.byPass('User_TriggerHandler');
        User user = CPQConfigurationapprovalControllerTest.createUser1();
    
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        createAccountTeamProxy(acctId);
        Device__c dev2;
         
        String oppId = CPQConfigurationapprovalControllerTest.createOpp(acctId);
        String oppProgId = CPQConfigurationapprovalControllerTest.createOppProg(acctId, oppId); 
                   
         Process_Technology__c testPt=CPQConfigurationapprovalControllerTest.createPT();
       
         Profile profile = [Select Id from Profile where name = 'System Administrator'];
         User admin= new User( ProfileId = profile.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                        HCM_Employee_ID__c='E1006044',
                        HCM_Login_ID__c='E1006044'

                                               );
                                               
              
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            TriggerHandler.byPass('Device_TriggerHandler');
            dev2 = CPQConfigurationapprovalControllerTest.createDevice(acctId,oppId,oppProgId);
          
   
            Apttus_Proposal__Proposal__c testConfig3 =CPQConfigurationapprovalControllerTest.createConfigTest(acctId,oppId,dev2.Id,testPt);
                test.stopTest();
                System.runAs(admin){
           
           EmailTemplate et = new EmailTemplate();  
                et.isActive = true;  
                et.Name = 'testTemplate';  
                et.DeveloperName = 'testTemplate';
                et.TemplateType = 'text';  
                et.FolderId = userinfo.getUserId(); 
                et.Body = 'test'; 
                Database.insert(et);
                System.assertEquals(et.Name,'testTemplate');
                
                CPQTempCS__c tempcs = new CPQTempCS__c();
                tempcs.Name='CPQTemplate';
                tempcs.Template_Name__c='testTemplate';
                tempcs.FAE_Template_Name__c='testTemplate2';
                Database.insert(tempcs);
                System.assertEquals(tempcs.Name,'CPQTemplate');
           }
          
            
            Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
            propShare.ParentId = testConfig3.Id;
            propShare.UserOrGroupId = user.Id;
            propShare.AccessLevel = 'edit';
            insert propShare;
            Apexpages.StandardController stdController = new Apexpages.StandardController(testConfig3);
            system.currentPageReference().getParameters().put('id', testConfig3.Id);
            Apexpages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');                        
            CPQConfigurationapprovalController testApproval1=new CPQConfigurationapprovalController(stdController);
            testApproval1.errorFlag = false;
            testApproval1.entryFlag = true;                      
            testApproval1.acntFlag = false;                        
            testApproval1.ptFlag = false;                     
            testApproval1.posFlag = false;
            testApproval1.initialised = false;
            
            testApproval1.devFlag = false;//device
            testApproval1.devFabFlag = false;//Fab_Name__c
            testApproval1.pocFlag = false; //Purpose_of_the_Configuration__c 
            testApproval1.ptnFlag = false; //Process_Technology_Name__c 
            testApproval1.deviceFlag = false;
            
            testApproval1.conIpStatus= false; 
            testApproval1.metalOptionFlag=false;
            testApproval1.JustRetrofit=false;
           // testApproval1.validateConfiguration();
            
            CPQConfigurationApprovalHelper testAppHelper = new CPQConfigurationApprovalHelper();
            testAppHelper.submitForApproval(testConfig3);
            try{
            String x = null;
            x.toLowerCase();
            }catch(Exception e){
                testApproval1.handleException('FIELD_CUSTOM_VALIDATION_EXCEPTION',e);
            }
           
            
        
                 
           
    }
    
   
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}