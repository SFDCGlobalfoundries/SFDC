@isTest
public class PopulateAndUpdateFieldsTest 
{
public static Id acc;
public static Id opp;
public static string processId;
public static Device__c dev=new Device__c();

Public String newWorkItemIds3;
@testSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
        acc=DeviceUtilTest.createAccount();
        opp=DeviceUtilTest.createOpp(acc,'0.014UM');
        test.startTest();
        dev=createDevice(acc,opp,'0.014UM','On Hold');
        createApprovalSetting(acc);
        
        createConfig(dev.id);
        test.stopTest();
    }
   static void createApprovalSetting(string  accId){
   	  ConfiguratorApprovalSetting__c obj=new ConfiguratorApprovalSetting__c(Default_Approver__c=UserInfo.getUserId(),FAB_Name__c='FAB 2,FAB 3,FAB 3E,FAB 7,FAB 5,FAB 6',Maximum_Approver__c=15);
      insert obj;
      
      Contact objContact=new Contact(LastName='Test'+UserInfo.getUserId(),FirstName='Test',email='test@test731723.com');
      insert objContact;
      
      User u1 = new User(alias = 'ts1', email='testaccss@test.com',isActive=true,
      emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
      localesidkey='en_US', profileid = '00e90000001232a',
      Fab_Assigned__c='Fab 2',
      timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');         
      insert u1;
      
      Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = u1.id,
                Account__c=accId,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Customer Engineer',
                Sequence_No__c='1',
                Account_Role_ID__c='test1',
                Fab_Assignment__c='Fab 7'
            );
            
            insert atp;
   }
    
  static Id createMaskSetTitle(){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name', 'MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        Mask_Set_Title__c mstRec = MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap);
        
        return mstRec.Id;
    }
    
    public static Device__c createDevice(string acctId,string opptyId,string geometry,string status) 
    {
         
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        processId = DeviceUtilTest.createProcess('0.014UM');
        //string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
       String MSTId = createMaskSetTitle();
      string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Account__c',acctId); 
        fieldValueMap.put('Name','TESTDEVICE');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('Internal_Device_Geometry__c','0.014UM');
        fieldValueMap.put('Internal_Device_Process_Family__c','Generic / Nominal');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c',status);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Reason_For_Status_On_Hold__c','Test');
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
   
    
  
    
    public static void createConfig(String devid)
    {
        
       Process_Technology__c PT = new Process_Technology__c();
       PT.Tech_Geometry__c ='0.040UM';
       insert PT; 
        
       Apttus_Proposal__Proposal__c testcon=new Apttus_Proposal__Proposal__c();
       testcon.Apttus_Proposal__Proposal_Name__c='TestConfig';
       testcon.Apttus_Proposal__Primary__c=true;
       testcon.Apttus_Proposal__Approval_Stage__c='Draft';
       testcon.Apttus_Proposal__Account__c=acc;
       testcon.Apttus_Proposal__Opportunity__c=opp;
       testcon.Device__c=devid;
       testcon.Assigned_Process_ID__c=DeviceUtilTest.createProcess('0.014UM'); 
       testcon.Process_Technology__c =PT.id;
       testcon.Approval_Check__c =false;
       testcon.Purpose_of_the_Configuration__c='Final';
       
       
       testcon.SRAM__c='Yes';
       testcon.SRAM_Gate_Orientation__c='Horizontal';
       testcon.ACLV_Gate_Orientation__c ='Horizontal';
       testcon.Gate_Orientation_PFET__c ='Horizontal';
       testcon.Justification_of_Retrofit__c='test';
      // testcon.Consolidated_IP_Status_Check__c = 'No';
       
       insert testcon;
       
            
    }
     
    
    
     static Map<String, Id> profileMap = new Map<String, Id>();
        static void getProfileMap()
     {
         if (profileMap.size() == 0)
         {
             List<Profile> profiles = [select ID, Name from Profile];
        
             for(Profile p : profiles)
             {
                 profileMap.put(p.Name, p.Id);
             }
         }
     }

 
  static User createUser(Id contactId, string profileName)
    {
        Integer iCount = 1;
        getProfileMap();
        Id custPortalId = profileMap.get('Customer Portal Profile');
        Id profileId = profileMap.get(profileName);
        
        User user = new User(Alias = 'ts'+iCount, Email= 'testing' + iCount + '@cy.com',
                 EmailEncodingKey='UTF-8', LastName='TestCY' + iCount, LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = profileId, communitynickname='ts' + iCount, Fab_Assigned__c='FAB 2',
                 FederationIdentifier='Test2014'+iCount, TimeZoneSidKey='America/Los_Angeles', UserName= 'testing' + iCount + '@cy.com');
                 
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c(First_Name__c='TestFirst' + iCount, Last_Name__c='TestCY' + iCount,
                 Employee_ID__c='Test2014'+iCount, Login_ID__c='testing' + iCount + '@cy.com', Email_Address__c='testing' + iCount + '@cy.com',
                 Status__c='Active');      
        
        if (profileId == custPortalId)
            user.ContactId = contactId;
                 
        
        insert testHCMEmployee;
        insert user;
        
        return user;
       
    }
    
    
    public static testmethod void Approvaltest(){
    
    Apttus_Proposal__Proposal__c configupdate =[Select id from Apttus_Proposal__Proposal__c  where Apttus_Proposal__Proposal_Name__c='TestConfig'];
       Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(configupdate.Id);
        
        Approval.ProcessResult resu = Approval.process(req);
        // Verify the result
        System.assert(resu.isSuccess());
        List<Id> newWorkItemIds = resu.getNewWorkitemIds();
        System.debug('ID of the record being processed------>'+resu.getEntityId());
        System.debug('error occurred------>'+resu.getErrors());
        System.debug('ID of the approval process ---->'+resu.getInstanceId());
        System.debug('status of the current approval process 1------>'+resu.getInstanceStatus());
        System.debug('IDs of the new items submitted to the approval process------>'+resu.getNewWorkitemIds());
        System.debug('config record'+configupdate);   
         Test.StartTest();
        User unauthUser =createUser(null, 'GF PIYE Platform'); 
    
        System.runAs(unauthUser) {
       
        Approval.ProcessWorkitemRequest req2 =  new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});//UserInfo.getUserId()
        system.debug('req2::'+req2);
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
       // newWorkItemIds2  = req2.getWorkitemId();
        system.debug('req3::'+req2);
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        System.debug('status 2------>'+result2.getInstanceStatus());
        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());

        System.assertEquals('Approved', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());
    
    
        Test.StopTest();
     
    }}
    
    public static testmethod void Approvaltest2(){
    
    Apttus_Proposal__Proposal__c configupdate =[Select id from Apttus_Proposal__Proposal__c  where Apttus_Proposal__Proposal_Name__c='TestConfig'];
       Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(configupdate.Id);
        
        Approval.ProcessResult resu = Approval.process(req);
        // Verify the result
        System.assert(resu.isSuccess());
        List<Id> newWorkItemIds = resu.getNewWorkitemIds();
        System.debug('ID of the record being processed------>'+resu.getEntityId());
        System.debug('error occurred------>'+resu.getErrors());
        System.debug('ID of the approval process ---->'+resu.getInstanceId());
        System.debug('status of the current approval process 1------>'+resu.getInstanceStatus());
        System.debug('IDs of the new items submitted to the approval process------>'+resu.getNewWorkitemIds());
        System.debug('config record'+configupdate);   
        
        Test.StartTest();
        User unauthUser =createUser(null, 'GF System Admin'); 
    
        System.runAs(unauthUser) {
        
        Approval.ProcessWorkitemRequest req2 =  new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});//UserInfo.getUserId()
        system.debug('req2::'+req2);
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
       // newWorkItemIds2  = req2.getWorkitemId();
        system.debug('req3::'+req2);
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        System.debug('status 2------>'+result2.getInstanceStatus());
        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());

        System.assertEquals('Approved', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());
    
    
        Test.StopTest();
     
    }}
    
    public static testmethod void Approvaltest3(){
    
    Process_Technology__c PT = new Process_Technology__c();
       PT.Tech_Geometry__c ='0.040UM';
       insert PT; 
        
       Apttus_Proposal__Proposal__c testcon2=new Apttus_Proposal__Proposal__c();
       testcon2.Apttus_Proposal__Proposal_Name__c='TestConfig2';
       testcon2.Apttus_Proposal__Primary__c=true;
       testcon2.Apttus_Proposal__Approval_Stage__c='Process Flow Accepted';
       //apttus_proposal__approval_stage__c == 
       testcon2.Apttus_Proposal__Account__c=acc;
       testcon2.Apttus_Proposal__Opportunity__c=opp;
       //testcon2.Device__c=devid;
       testcon2.Assigned_Process_ID__c=DeviceUtilTest.createProcess('0.014UM'); 
       testcon2.Process_Technology__c =PT.id;
       testcon2.Approval_Check__c =true;
       testcon2.PID_Mail_sent__c =false;
       testcon2.Purpose_of_the_Configuration__c ='final';
       testcon2.SRAM__c='Yes';
       testcon2.SRAM_Gate_Orientation__c='Horizontal';
       testcon2.ACLV_Gate_Orientation__c ='Horizontal';
       testcon2.Gate_Orientation_PFET__c ='Horizontal';
       testcon2.Justification_of_Retrofit__c='test';
       
       insert testcon2;
    
    
    
    }
    
    public static testmethod void Approvaltest4(){
        NPCCopyConfigurationController.InsideNPCCopyConfig = true;
    
        Apttus_Proposal__Proposal__c configupdate =[Select id from Apttus_Proposal__Proposal__c  where Apttus_Proposal__Proposal_Name__c='TestConfig'];
        update configupdate;
    }
    
    static testmethod void TestStageChange()
     {   
        test.startTest();
        
        Apttus_Proposal__Proposal__c testvar=[Select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c limit 1];
        testvar.Apttus_Proposal__Approval_Stage__c='Configuration Design Phase';
              
        update testvar;
        
        //testvar.Apttus_Proposal__Approval_Stage__c='Process Flow Accepted';
              
        //update testvar;
        
        Opportunity o=[select id, Apttus_Configuration_Score__c from Opportunity limit 1];
        //System.assertEquals(0,o.Apttus_Configuration_Score__c);
        
    
     }
     
       public static testmethod void ApprovaltestwithFAE(){
        try{
               Apttus_Proposal__Proposal__c configupdate =[Select id from Apttus_Proposal__Proposal__c  where Apttus_Proposal__Proposal_Name__c='TestConfig'];
             
              User FAEUser =createUser(null, 'GF FAE/FTS'); 
        
              System.runAs(FAEUser) {  
              List<EmailTemplate> ETList = new List<EmailTemplate>();
              EmailTemplate et = new EmailTemplate();  
                et.isActive = true;  
                et.Name = 'testTemplate';  
                et.DeveloperName = 'testTemplate';
                et.TemplateType = 'text';  
                et.FolderId = FAEUser.id; 
                et.Body = 'test'; 
                ETList.add(et);
                
                
                EmailTemplate et2 = new EmailTemplate();  
                et2.isActive = true;  
                et2.Name = 'testTemplate2';  
                et2.DeveloperName = 'testTemplate2';
                et2.TemplateType = 'text';  
                et2.FolderId = FAEUser.id; 
                et2.Body = 'test'; 
                ETList.add(et2);
                
                Database.insert(ETList);
                
                
               List<Sobject> CSList = new List<Sobject>();
                CPQTempCS__c tempcs = new CPQTempCS__c();
                tempcs.Name='CPQTemplate';
                tempcs.Template_Name__c='testTemplate';
                tempcs.FAE_Template_Name__c='testTemplate2';
                CSList.add(tempcs);
                
                
                CPQCS__c CS = new CPQCS__c();
                CS.Name='checkexternaluser';
                CS.Is_submitted_by_External_User__c= true;
                CSList.add(CS);
                Database.insert(CSList);
              Test.StartTest(); 
              Contact con = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc,
                Email = 'noreply@salesforce.com',
                Department__c = 'Design',
                Status__c = 'Draft'
                );
                Database.insert(con);
                System.assertEquals(con.FirstName,'testing1'); 
                   
             
              
               
            configupdate.Apttus_Proposal__Approval_Stage__c='Submitted Phase';
            Database.update(configupdate);
            System.assertEquals(configupdate.Apttus_Proposal__Approval_Stage__c,'Submitted Phase');
            configupdate.Apttus_Proposal__Approval_Stage__c='Configuration Design Phase';
            Database.update(configupdate);
            System.assertEquals(configupdate.Apttus_Proposal__Approval_Stage__c,'Configuration Design Phase');
             
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(configupdate.Id);
        
            Approval.ProcessResult result = Approval.process(req);
            Test.StopTest();
           }
           
          }catch(Exception excp){
                 GlobalUtility.logMessage('Error','PopulateAndUpdateFieldsTest','ApprovaltestwithFAE','','Exception while inserting configuration record PDF file in attachement object or sending email to configurator creater in Test class',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
              } 
         
    }
     
     
     static testmethod void TestOppChange()
     {   
        test.startTest();
        
        Apttus_Proposal__Proposal__c testvar=[Select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c limit 1];
        testvar.Apttus_Proposal__Approval_Stage__c='Configuration Design Phase';
              
        update testvar;
        
        testvar.Apttus_Proposal__Opportunity__c=NULL;
              
        update testvar;
        
        Opportunity o=[select id, Apttus_Configuration_Score__c from Opportunity limit 1];
        System.assertEquals(0,o.Apttus_Configuration_Score__c);
        
    
     }
     
     
     
     static testmethod void TestDevChange()
     {   
        test.startTest();
        
        Apttus_Proposal__Proposal__c testvar=[Select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c limit 1];
        testvar.Apttus_Proposal__Approval_Stage__c='Configuration Design Phase';
              
        update testvar;
        
        testvar.Device__c=NULL;
              
        update testvar;
        
        Opportunity o=[select id, Apttus_Configuration_Score__c from Opportunity limit 1];
        
     }
     }