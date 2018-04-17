/*    
    Author: 
    Description: 
    History:
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    ARoy        10172013    - Modified to fix issues related to governor limits. 
    Tlai        21072014    - Commented method runEditAccountTeamMembersControllerExt because class EditAccountTeamMembersControllerExt is out of use.
    DBiswal     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/
@isTest (SeeAllData = false)
public class TestClasses{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
          List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Account acc= getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
    }
    
    //Test Method for OpportunityTrigger Trigger
    static testMethod void runOpportunityTrigger(){
        
        Profile p = [select id from profile where name='GF Integration'];
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test',Login_ID__c='test',Email_Address__c='agarwalashish@deloitte.com');       
        //insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.id,
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test');      
        
        //insert u;
        
        Account acc= getAccount('MYTEST ACCOUNT1');
        /*Test.startTest();
        insert acc;        
            
          
        Opportunity opp = new Opportunity(Name = 'test7',CloseDate=system.today(),StageName='Prospecting',AccountId=acc.id,X1st_Product_Production_Date__c=System.today(),Years_of_Production__c=2,Siebel_Sync_ID__c=String.valueOf(System.now()+5));       
        insert opp;
               
        
        Quarterly_Revenue_Object__c qro= new Quarterly_Revenue_Object__c(Opportunity__c=opp.id,Date__c=System.today(),ASP__c=5,Volume__c=5);        
        insert qro; 
       
       
        System.runAs(u){ 
       
            opp.Name ='abc';
            opp.Years_of_Production__c=3;
            
            
            update opp;
            
            try{
                Opportunity opp1 = new Opportunity(Name = 'abc',CloseDate=system.today(),StageName='Prospecting',AccountId=acc.id);
                
                insert opp1;
               Test.stopTest();  
            }catch(Exception e){
                System.assert(e.getMessage().contains('Opportunity Name should be unique within the same account.'));
            }
            
            try{
                opp.Siebel_Sync_ID__c=String.valueOf(System.now());
                
                update opp;
              
            }catch(Exception e){
                System.assert(e.getMessage().contains('Out of sequence integration update'));
            }
            
       }*/
       
       
  }
    
    //Test Method for AccountTrigger Trigger
    static testMethod void runAccountTrigger1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Profile p = [select id from profile where name='GF Integration'];
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test1',Login_ID__c='test1',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.id,
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test1');
        //insert u;
        
        
        
        HCM_Employee__c hcm1 = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test2',Login_ID__c='test2',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm1;
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');
        //insert u1;
        test.startTest();
        List<User> users = new List<User>{u,u1};       
        insert users;    
        
        Customer_Number__c cn= new Customer_Number__c(Name='Test',Customer_No__c=5);
        insert cn;
        
        Account acc= getAccount('MYTEST ACCOUNT1');
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test',fab_assignment__c = 'FAB 1');
        
        insert atp; 
        
        
        System.runAs(u){ 
                 
               try{
                  acc.Siebel_Sync_ID__c=String.valueOf(System.now());
                  update acc;
                }catch (Exception e){
                    System.assert(e.getMessage().contains('Out of sequence integration update'));
                }
        }
        test.stopTest();
               
   }
   
    //Test Method for AccountTrigger Trigger
    static testMethod void runAccountTrigger2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Profile p = [select id from profile where name='GF Integration'];
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test1',Login_ID__c='test1',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.id,
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test1');
        //insert u;
        
        HCM_Employee__c hcm1 = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test2',Login_ID__c='test2',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm1;
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');
        //insert u1;
        test.startTest();
        List<User> users = new List<User>{u,u1};       
        insert users;
        
        Customer_Number__c cn= new Customer_Number__c(Name='Test',Customer_No__c=5);
        insert cn;
        
        Account acc= getAccount('MYTEST ACCOUNT1');
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test',fab_assignment__c = 'FAB 1');
        
        insert atp; 
        
        
        acc.OwnerId=u1.id;
        acc.Approval_Status__c='Rejected';
        acc.Stage__c='Qualified';
        acc.Fab_9_10__c='yes';
        //update acc;
        test.stopTest();       
   }
      
    //Test Method for AccountTrigger Trigger
    static testMethod void runAccountTrigger3(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Profile p = [select id from profile where name='GF Integration'];
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test1',Login_ID__c='test1',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.id,
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test1');
        //insert u;
        
        
        
        HCM_Employee__c hcm1 = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test2',Login_ID__c='test2',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm1;
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');
        //insert u1;
        test.startTest();
        List<User> users = new List<User>{u,u1};       
        insert users;
        
        Customer_Number__c cn= new Customer_Number__c(Name='Test',Customer_No__c=5);
        insert cn;
        
        Account acc= getAccount('MYTEST ACCOUNT1');
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test',fab_assignment__c = 'FAB 1');
        
        insert atp;         
        
        try{
            acc.Short_Name__c='test1';
            update acc;    
        }catch(Exception e){
            System.assert(e.getMessage().contains('Short Name can not be modified'));
        }
        test.stopTest();
               
   }
   
    //Test Method for AccountTrigger Trigger
    static testMethod void runAccountTrigger4(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        test.startTest();
        Profile p = [select id from profile where name='GF Integration'];
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test1',Login_ID__c='test1',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.id,
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test1');
        insert u;
        
        HCM_Employee__c hcm1 = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test2',Login_ID__c='test2',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm1;
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');
        insert u1;
        
        Customer_Number__c cn= new Customer_Number__c(Name='Test',Customer_No__c=5);
        insert cn;

        
        Account acc= getAccount('MYTEST ACCOUNT1');
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test',fab_assignment__c = 'FAB 1');
        
        insert atp; 
        test.stopTest();
        
        try{
             AccountTriggerRun.hasAccountTriggerRun = true;
             Account_Short_Name__c asn = new Account_Short_Name__c(Account_Short_Name__c='test4');
             insert asn;
             acc.Short_Name__c='test4';
             update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Short Name can not be modified'));
        }
               
   }
    
    //Test Method for AccountTeamProxy Trigger
    static testMethod void runAccountTeamProxy(){
    
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Profile p = [select id from profile where name='GF Integration'];  
        
        HCM_Employee__c hcm = new HCM_Employee__c(
            First_Name__c='Ashish',
            Last_Name__c='Agarwal',
            Employee_ID__c='Test3',
            Login_ID__c='test',
            Email_Address__c='agarwalashish@deloitte.com'
        );                     
                
        HCM_Employee__c hcm1 = new HCM_Employee__c(
            First_Name__c='Ashish',
            Last_Name__c='Agarwal'
            ,Employee_ID__c='Test4',
            Login_ID__c='test4',
            Email_Address__c='agarwalashish@deloitte.com'
        );
        
        HCM_Employee__c hcm2 = new HCM_Employee__c(
            First_Name__c='Ashish',
            Last_Name__c='Agarwal'
            ,Employee_ID__c='Test5',
            Login_ID__c='test5',
            Email_Address__c='agarwalashish@deloitte.com'
        );
        
        List<HCM_Employee__c> hcms = new List<HCM_Employee__c>{hcm,hcm1,hcm2};        
        insert hcms;                      
        
        User u = new User(
            alias = 'ts1',
            email='testaccss@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast3', 
            firstname='TestFirst3', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = p.id,
            timezonesidkey='America/Los_Angeles', 
            username='testaccss@test.com',
            communitynickname='ts3',
            FederationIdentifier='Test3'
        );
                
        User u1 = new User(
            alias = 'ts4', 
            email='testaccss@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast4', 
            firstname='TestFirst4', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testaccsstt@test.com',
            communitynickname='tst4',
            FederationIdentifier='Test4',
            fab_assigned__c = 'FAB 1;FAB 2;FAB 3'
        );
        
        User u2 = new User(
            alias = 'ts5', 
            email='testaccss@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast5', 
            firstname='TestFirst5', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testaccssttuu@test.com',
            communitynickname='tst5',
            FederationIdentifier='Test5',
            fab_assigned__c = 'FAB 1;FAB 2;FAB 3'
        );
        
        List<User> users = new List<User>{u,u1,u2};       
        insert users;                                                      
                
        Account acc= getAccount('MYTEST ACCOUNT1');         
       Account acc1= getAccount('MYTEST ACCOUNT2');
        
        
                
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
            User__c = u.id,
            Account__c=acc.id,
            Account_Role_ID__c='test',
            Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',
            Team_Role__c='Primary Field Engineer',
            Sequence_No__c='1',
            Siebel_Error_Message__c='test',
            Siebel_Sync_id__c=String.valueof(System.now()+5),
            Siebel_Status__c='SUCCESS',
            Flag_for_Delete__c=false
        );
        
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(
            User__c = u1.id,
            Account__c=acc.id,
            Account_Role_ID__c='test',
            Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',
            Team_Role__c='Fab Planner',
            Sequence_No__c='1',
            Siebel_Error_Message__c='test',
            Siebel_Sync_id__c=String.valueof(System.now()+5),
            Siebel_Status__c='SUCCESS',
            Flag_for_Delete__c=false
        );
        
        List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp1};
        insert atps;
        
        test.startTest();     
                
        System.runAs(u){                
            try{
                atp.Siebel_Sync_ID__c=String.valueOf(System.now());
                 
                update atp;
                 
            }catch (Exception e){
                System.assert(e.getMessage().contains('Out of sequence integration update'));
            }
        } 
                       
        atp.User__c=u2.id;
        atp1.fab_assignment__c = 'FAB 1';          
        update atps;
                               
        try{                
            Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                 User__c = u.id,
                 Account__c=acc1.id,
                 Account_Role_ID__c='testss',
                 Account_Access__c='Read/Write',
                 Opportunity_Access__c='Read/Write',
                 Team_Role__c='Field Engineer',
                 Sequence_No__c='1',
                 Flag_for_Delete__c=true
            );
            
            insert atp2;
             
            }catch(Exception e){
               System.assert(e.getMessage().contains('Flag for delete is not allowed while creating record'));
            }
                 
         try{
            atp.Team_Role__c='Primary Account Manager';            
            update atp;
            
            }catch(Exception e){
                //System.assert(e.getMessage().contains('Role and Seq duplicates'));
            }
         
        try{
             atp.Flag_for_Delete__c=true;
             update atp;
             atp.Flag_for_Delete__c=false;
             update atp;
           }catch(Exception e){
                //System.assert(e.getMessage().contains('Deletion in progress, Flag for delete can not be uncheked'));
           }
           
          try{    
             Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                 User__c = u1.id,
                 Account__c=acc.id,
                 Account_Access__c='Read/Write',
                 Opportunity_Access__c='Read/Write',
                 Team_Role__c='Field Engineer',
                 Sequence_No__c='1',
                 Account_Role_ID__c='test'
             );
             
             insert atp2;
             
           }catch(Exception e){
                //System.assert(e.getMessage().contains('There are duplicate users or roles in the form. Please review the form and update assignment as necessary.'));
           }  
      
        //delete atp;
              
        test.stopTest();              
                
    }
    
    //Test Method for DesignWinMakerConfirm Trigger
    static testMethod void runDesignWinMakerConfirm(){
        Account acc= getAccount('MYTEST ACCOUNT1');
        Opportunity opp = new Opportunity(Name = 'Test2',CloseDate= system.today(),StageName='Prospecting',AccountId=acc.Id);
        insert opp;
        
        Attachment attachment = new Attachment();
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = opp.Id; // the record the file is attached to
        attachment.name='test.gif';
        attachment.body=Blob.valueof('Unit test blob');
        insert attachment;
    }

 /*
 @isTest(SEEALLDATA = false)
    //Test Method for Schedulers Scheduler
     private static void runSchedulers(){
         
         test.starttest();
         Schedulers sc = new Schedulers();        
         String sch = '0 0 23 * * ?';        
         system.schedule('Schedulers', sch, sc);
         test.stopTest();
     }
 */
    //Test Method for SchedullersController Class
     static testMethod void runSchedullersController(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        
        Retry_Logic__c ret = new Retry_Logic__c(Name='Test',MinutesToResendRecord__c=10,Time_to_Recall__c=15,Log__c='test');
        insert ret;
        
       Account acc= getAccount('MYTEST ACCOUNT1');
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test16',Login_ID__c='test16',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test16');
        insert u;
            
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test',Siebel_Status__c='SENT',Siebel_Sync_id__c=String.valueof(System.now()));
        insert atp;
        
        Opportunity opp = new Opportunity(AccountId=acc.Id,Name = 'test8',CloseDate=system.today(),StageName='Prospecting',Siebel_Status__c='SENT',Siebel_Sync_id__c=String.valueof(System.now()));
        insert opp;
        
        Test.stopTest();
     }
     
    //Test Method for UserAccountTeamMemberController Class
     static testMethod void runUserAccountTeamMemberController(){
        Test.startTest();
        Account acc= getAccount('MYTEST ACCOUNT1');
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test4',Login_ID__c='test4',Email_Address__c='agarwalashish@deloitte.com');
        insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000000H2zM',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test4',
        fab_assigned__c = 'FAB 1');
        
        insert u;
        
        /* User u = [
            SELECT    Id
            FROM      User
            WHERE     ProfileId = '00e90000000H2zM'
                      AND fab_assigned__c = 'FAB 1'
                      AND IsActive = true
            LIMIT 1
        ]; */
            
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Sequence_No__c='1',Account_Role_ID__c=u.id +'' + acc.id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Customer Engineer',fab_assignment__c = 'FAB 1');
        insert atp;
       
        apexpages.currentpage().getparameters().put('id',acc.id);
        UserAccountTeamMemberController utm = new UserAccountTeamMemberController(); 
        utm.AccountName=acc.name;
        utm.addNewRow();
        UserAccountTeamMemberController.AccountTeamProxyModel atm = new UserAccountTeamMemberController.AccountTeamProxyModel();       
        utm.Save();
        
        u.Fab_Assigned__c = 'FAB 1';
        update u;
        
        utm.Save();
        Test.stopTest();
     }
     
    /*  @isTest(SEEALLDATA = false)
    //Test Method for EditAccountTeamMembersControllerExt Class
     private static void runEditAccountTeamMembersControllerExt(){
        
        Account acc = new Account(Short_Name__c = 'testclass1',Name='Test',Bill_To_Postal_Zip_Code__c='1111',Corporate_Address_1__c='test',Corporate_City__c='test',Corporate_Postal_Zip_Code__c='1111',Site_Department__c='test dept1',Bill_To_Address_1__c='test',Bill_To_City__c='test',Bill_To_Country__c='Argentina');        
        insert acc;
        
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Ashish',Last_Name__c='Agarwal',Employee_ID__c='Test5',Login_ID__c='test4',Email_Address__c='agarwalashish@deloitte.com');
        //insert hcm;
        
        User u = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast5', firstname='TestFirst5', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='ts1',FederationIdentifier='Test5',
        fab_assigned__c = 'FAB 1');
        
        insert u;
            
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,Sequence_No__c='1',Account_Role_ID__c='test',Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Customer Engineer',fab_assignment__c = 'FAB 1');
        insert atp;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(atp);
        apexpages.currentpage().getparameters().put('id',atp.id);
        EditAccountTeamMembersControllerExt ext = new EditAccountTeamMembersControllerExt(sc); 
        ext.AccountName=acc.name;
        ext.addNewRow();
        EditAccountTeamMembersControllerExt.AccountTeamProxyModel atm = new EditAccountTeamMembersControllerExt.AccountTeamProxyModel();
        atm.ATP=atp;
        ext.AccountTeamProxyList.add(atm);
        ext.Save();
        Test.stopTest(); 
     }*/
     
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}