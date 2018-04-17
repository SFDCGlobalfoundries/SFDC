/*
  Author: Ramareddy Karri
  Description: This is the test class for the PCNEOL_GFViewController
  History:
    Ramareddy   12012016    - code creation.
    Dinesh      12272016    - code modified  
    Sameera     02232017    - code modified                           
*/

@isTest(SeeAllData=false)
public class PCNEOL_GFViewControllerTest {

  @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
   
   
    // positive search results test
        static testMethod void testSaving2()
    {
        User loggedinuser = [Select id,Name,UserRole.Name from User where Id = :UserInfo.getUserId()];     
       
        // create Account
        Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account;
        Map<String, Schema.RecordtypeInfo> recordTypeMap = descSobjResult.getRecordTypeInfosByName();
        Map<String,Object> fieldValueMap = New Map<String,Object>();
        fieldValueMap.put('Name','test1');
        fieldValueMap.put('Stage__c','Active');
        fieldValueMap.put('Short_Name__c','TestAcct');
        fieldValueMap.put('Site_Department__c','siteDept');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','Transactional');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c','Mature');
        fieldValueMap.put('Region__c','GC');
        fieldValueMap.put('Sales_Territory__c','US-West');
        fieldValueMap.put('Copy_Address__c',true);
        fieldValueMap.put('Corporate_Address_1__c','Corporate Address 2');
        fieldValueMap.put('Corporate_Country__c','Afghanistan'); 
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 2');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap.put('FE_Territory__c','APJ-FE-CHINA');       
        fieldValueMap.put('Total_Employee__c',100);  
        fieldValueMap.put('RecordTypeId',recordTypeMap.get('Customer').getRecordTypeId());
        fieldValueMap.put('OwnerId',loggedinuser.Id); 
        Account account1 = AccountDataFactory.createAccount(fieldValueMap);
        
        
        // create contact
        Contact contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin','Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        
        
        // Create Portal User
         Id p = [SELECT id,Name FROM profile WHERE Name ='Customer Portal Admin'].id;
         SYSTEM.DEBUG('profile'+p);
         User portaluser = QS_TestUtil.createPortalUser('batman','bruce.wayne@wayneenterprises.com','Bruce','Wayne',p,contact.id,'TestUserCheckOut@gmail.com'); 
         portaluser.PortalRole = 'Manager';
         portaluser.CommunityNickname = 'testUser123';
         portaluser.IsActive = true;
         portaluser.FederationIdentifier='everyabcd';
         Insert portaluser;

        Test.startTest();
          System.RunAs(portaluser)
        {
         
         // create Shipment Internal
         Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',account1.Id);
         Insert shpInternal;
         
         // create Shipment Line Internal
         List<Shipment_Line_Internal__c> shiplst = new List<Shipment_Line_Internal__c>();
         shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,account1.Id,'123'));
         shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname2',shpInternal.Id,account1.Id,'1234'));
         shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname3',shpInternal.Id,account1.Id,'12345'));
         Insert shiplst; 
    
         
        // create PCN EOL
         List<PCN_EOL__c> listpcn = new List<PCN_EOL__c>();
         PCN_EOL__c EOL = QS_TestUtil.createPCNEOL('PCNEOL36','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
         EOL.Fab__c ='Fab 10';
         EOL.LMT_Affected__c ='ASIC';
         EOL.Package_Type_Affected__c ='Cu11';
         EOL.Reason_for_the_discontinuance__c = 'testreasion';
         EOL.Technology_Affected__c = '32G';
         EOL.Name = 'testName2'; 
         
         listpcn.add(EOL);
         Insert listpcn;
        
         // Create Part Customer
         Part_Customer_Infomation__c pcust = QS_TestUtil.createPartCustomers(EOL.Id,shiplst[0].Id,account1.Id);
         pcust.End_Of_Life__c = EOL.Id;
         pcust.Select_Checkbox__c= True;
         pcust.IBM_Part_Number__c = 'test12';
         Insert pcust;
          
         PCNEOL_GFViewController pcnGf = new PCNEOL_GFViewController();
         ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listpcn);
         pcnGf.setCon = sc;
         pcnGf.ACPCN = 'Open PCN';
         list<SelectOption> slist= pcnGf.getstagePCN();
         pcnGf.setstagePCN(slist);
         pcnGf.requestor = portaluser.Name;
         pcnGf.getrequestorvalues();
         pcnGf.status = 'Sent to Customers';
         pcnGf.size = 2;
         pcnGf.eDate = System.today();
         pcnGf.Records = 'Yes';
         pcnGf.searchValue = 'test12';
         pcnGf.refresh();
         
        }
        Test.stopTest();
    }
   // Negative search results test
   static testMethod void testSaving3()
    {
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        User userObj = new User();
        Account acctObj = new Account();
        Contact conobj=new Contact();
        Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
        
        User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        //create portal Account
        acctObj.Name='TestAccount';
        acctobj.ownerId = accoutOwner.Id;
        acctObj.Site_Department__c = 'Site1';
        acctObj.Sub_Type__c = 'Direct';
        acctObj.Transaction_Type__c = 'Transactional';
        acctObj.Region__c = 'APJ';
        acctObj.Bill_To_Address_1__c='KOL';
        acctObj.Bill_To_City__c = 'KOL';
        acctObj.Bill_To_Country__c = 'INDIA';
        acctObj.Corporate_Address_1__c = 'Street';
        acctObj.Corporate_City__c = 'KOL';
        acctObj.Corporate_Country__c = 'INDIA';
        insert acctObj;
        
        //Create portal Contact    
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
        insert conobj;
        
        //Create portal user    
        userObj.Alias = 'Shyam';
        userObj.Email='shyam@test.com'; 
        userObj.EmailEncodingKey='UTF-8'; 
        userObj.LastName='Paul';
        userObj.LanguageLocaleKey='en_US'; 
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profileObj.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles'; 
        userObj.UserName='shyam132@test.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;        
        userObj.FederationIdentifier='abcd';                
        insert userObj;
        Test.startTest();
        System.RunAs(userObj)
        {
         Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
        Insert shpInternal;
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
        Insert shipline;
        // create PCN EOL 
        List<PCN_EOL__c> listpcn = new List<PCN_EOL__c>();
        PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Closed','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
        EOL1.Fab__c ='Fab 10';
        EOL1.LMT_Affected__c ='ASIC';
        EOL1.Package_Type_Affected__c ='Cu11';
        EOL1.Reason_for_the_discontinuance__c = 'testreasion';
        EOL1.Technology_Affected__c = '32G';
        EOL1.Name = 'testName4';
        EOL1.Affected_Part_Numbers__c='test12,123';
        listpcn.add(EOL1);
        Insert listpcn;
        // create Partner Customer
        Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(listpcn[0].Id,shipline.Id,acctObj.Id);
        pcust1.End_Of_Life__c = listpcn[0].Id;
        pcust1.Select_Checkbox__c= True;
        pcust1.IBM_Part_Number__c = 'test12';
        Insert pcust1;
        
        PCNEOL_GFViewController pcnGf = new PCNEOL_GFViewController();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listpcn);
        pcnGf.setCon = sc;
        pcnGf.Isportal = true;
        pcnGf.ACPCN = 'Closed PCN';          
        list<SelectOption> slist= pcnGf.getstagePCN();
        pcnGf.setstagePCN(slist);        
        pcnGf.status = 'Closed';
        pcnGf.requestor = userObj.Name;
        pcnGf.getrequestorvalues();                 
        pcnGf.size = 2;
        pcnGf.eDate = System.today();
        pcnGf.Records = 'Yes';
        pcnGf.searchValue = 'test1234567,  123,456  ,test12';
        pcnGf.refresh();
        pcnGf.first();
        pcnGf.last();
        pcnGf.next();
        pcnGf.previous();   
        }
        Test.stopTest();
      }
      static testMethod void testSaving4()
    {
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        User userObj = new User();
        Account acctObj = new Account();
        Contact conobj=new Contact();
        Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
        
        User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        //create portal Account
        acctObj.Name='TestAccount';
        acctobj.ownerId = accoutOwner.Id;
        acctObj.Site_Department__c = 'Site1';
        acctObj.Sub_Type__c = 'Direct';
        acctObj.Transaction_Type__c = 'Transactional';
        acctObj.Region__c = 'APJ';
        acctObj.Bill_To_Address_1__c='KOL';
        acctObj.Bill_To_City__c = 'KOL';
        acctObj.Bill_To_Country__c = 'INDIA';
        acctObj.Corporate_Address_1__c = 'Street';
        acctObj.Corporate_City__c = 'KOL';
        acctObj.Corporate_Country__c = 'INDIA';
        insert acctObj;
        
        //Create portal Contact    
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
        insert conobj;
        
        //Create portal user    
        userObj.Alias = 'Shyam';
        userObj.Email='shyam@test.com'; 
        userObj.EmailEncodingKey='UTF-8'; 
        userObj.LastName='Paul';
        userObj.LanguageLocaleKey='en_US'; 
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profileObj.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles'; 
        userObj.UserName='shyam89@test.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;     
        userObj.FederationIdentifier='abcd';                   
        insert userObj;
        Test.startTest();
        System.RunAs(userObj)
        {
          Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
        Insert shpInternal;
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
        Insert shipline;
           // create PCN EOL 
        List<PCN_EOL__c> listpcn = new List<PCN_EOL__c>();
        PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Cancelled','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
        EOL1.Fab__c ='Fab 10';
        EOL1.LMT_Affected__c ='ASIC';
        EOL1.Package_Type_Affected__c ='Cu11';
        EOL1.Reason_for_the_discontinuance__c = 'testreasion';
        EOL1.Technology_Affected__c = '32G';
        EOL1.Name = 'testName4';
        listpcn.add(EOL1);
        Insert listpcn;
        // create Partner Customer
        Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(listpcn[0].Id,shipline.Id,acctObj.Id);
        pcust1.End_Of_Life__c = listpcn[0].Id;
        pcust1.Select_Checkbox__c= True;
        pcust1.IBM_Part_Number__c = 'test12';
        Insert pcust1;
        
        PCNEOL_GFViewController pcnGf = new PCNEOL_GFViewController();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listpcn);
        pcnGf.setCon = sc;
        pcnGf.Isportal = true;
        pcnGf.ACPCN = 'Cancelled PCN';          
        list<SelectOption> slist= pcnGf.getstagePCN();
        pcnGf.setstagePCN(slist);        
        pcnGf.status = 'Cancelled';
        pcnGf.requestor = userObj.Name;
        pcnGf.getrequestorvalues();             
        pcnGf.size = 2;
        pcnGf.eDate = System.today();
        pcnGf.refresh();
        pcnGf.first();
        pcnGf.last();
        pcnGf.next();
        pcnGf.previous();        
        }
        Test.stopTest();
      }
      static testMethod void testSaving5()
    {
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        User userObj = new User();
        Account acctObj = new Account();
        Contact conobj=new Contact();
        Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
        
        User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        //create portal Account
        acctObj.Name='TestAccount';
        acctobj.ownerId = accoutOwner.Id;
        acctObj.Site_Department__c = 'Site1';
        acctObj.Sub_Type__c = 'Direct';
        acctObj.Transaction_Type__c = 'Transactional';
        acctObj.Region__c = 'APJ';
        acctObj.Bill_To_Address_1__c='KOL';
        acctObj.Bill_To_City__c = 'KOL';
        acctObj.Bill_To_Country__c = 'INDIA';
        acctObj.Corporate_Address_1__c = 'Street';
        acctObj.Corporate_City__c = 'KOL';
        acctObj.Corporate_Country__c = 'INDIA';
        insert acctObj;
        
        //Create portal Contact    
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
        insert conobj;
        
        //Create portal user    
        userObj.Alias = 'Shyam';
        userObj.Email='shyam@test.com'; 
        userObj.EmailEncodingKey='UTF-8'; 
        userObj.LastName='Paul';
        userObj.LanguageLocaleKey='en_US'; 
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profileObj.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles'; 
        userObj.UserName='shyam312@test.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;   
        userObj.FederationIdentifier='abcd';                     
        insert userObj;
        Test.startTest();
        System.RunAs(userObj)
        {
        Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
        Insert shpInternal;
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
        Insert shipline;
           // create PCN EOL 
        List<PCN_EOL__c> listpcn = new List<PCN_EOL__c>();
        PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Rejected','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
        EOL1.Fab__c ='Fab 10';
        EOL1.LMT_Affected__c ='ASIC';
        EOL1.Package_Type_Affected__c ='Cu11';
        EOL1.Reason_for_the_discontinuance__c = 'testreasion';
        EOL1.Technology_Affected__c = '32G';
        EOL1.Name = 'testName4';
        listpcn.add(EOL1);
        Insert listpcn;
        // create Partner Customer
        Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(listpcn[0].Id,shipline.Id,acctObj.Id);
        pcust1.End_Of_Life__c = listpcn[0].Id;
        pcust1.Select_Checkbox__c= True;
        pcust1.IBM_Part_Number__c = 'test12';
        Insert pcust1;
        
        PCNEOL_GFViewController pcnGf = new PCNEOL_GFViewController();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listpcn);
        pcnGf.setCon = sc;
        pcnGf.Isportal = true;
        pcnGf.ACPCN = 'Rejected PCN';          
        list<SelectOption> slist= pcnGf.getstagePCN();
        pcnGf.setstagePCN(slist);        
        pcnGf.status = 'Rejected';
        pcnGf.requestor = userObj.Name;
        pcnGf.getrequestorvalues();                     
        pcnGf.size = 2;
        pcnGf.eDate = System.today();
        pcnGf.refresh();
        pcnGf.eDate = System.today().addDays(2);
        pcnGf.refresh();
        pcnGf.first();
        pcnGf.last();
        pcnGf.next();
        pcnGf.previous();        
        }
        Test.stopTest();
      }
       // test methode for none portal user
    static testMethod void testSaving6()
    {
     User accoutOwner = [select Id,Name from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        Account acctObj = new Account();
        Contact conobj=new Contact();
         //create portal Account
        acctObj.Name='TestAccount';
        acctobj.ownerId = accoutOwner.Id;
        acctObj.Site_Department__c = 'Site1';
        acctObj.Sub_Type__c = 'Direct';
        acctObj.Transaction_Type__c = 'Transactional';
        acctObj.Region__c = 'APJ';
        acctObj.Bill_To_Address_1__c='KOL';
        acctObj.Bill_To_City__c = 'KOL';
        acctObj.Bill_To_Country__c = 'INDIA';
        acctObj.Corporate_Address_1__c = 'Street';
        acctObj.Corporate_City__c = 'KOL';
        acctObj.Corporate_Country__c = 'INDIA';
        insert acctObj;
        
        //Create portal Contact    
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
        insert conobj;
        
        Test.startTest();
        System.RunAs(accoutOwner)
        {
         Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
        Insert shpInternal;
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
        Insert shipline;
           // create PCN EOL 
        List<PCN_EOL__c> listpcn = new List<PCN_EOL__c>();
        PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Rejected','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
        EOL1.Fab__c ='Fab 10';
        EOL1.LMT_Affected__c ='ASIC';
        EOL1.Package_Type_Affected__c ='Cu11';
        EOL1.Reason_for_the_discontinuance__c = 'testreasion';
        EOL1.Technology_Affected__c = '32G';
        EOL1.Name = 'testName4';
        listpcn.add(EOL1);
        Insert listpcn;
        // create Partner Customer
        Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(listpcn[0].Id,shipline.Id,acctObj.Id);
        pcust1.End_Of_Life__c = listpcn[0].Id;
        pcust1.Select_Checkbox__c= True;
        pcust1.IBM_Part_Number__c = 'test12';
        Insert pcust1;
        
        PCNEOL_GFViewController pcnGf = new PCNEOL_GFViewController();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listpcn);
        pcnGf.setCon = null;
        pcnGf.Isportal = false;
        pcnGf.ACPCN = 'None';          
        list<SelectOption> slist= pcnGf.getstagePCN();
        pcnGf.setstagePCN(slist);        
        pcnGf.status = '';
        pcnGf.requestor = accoutOwner.Name ;
        pcnGf.getrequestorvalues();                     
        pcnGf.size = 2;
        pcnGf.eDate = System.today().addDays(2);
        pcnGf.refresh();
               
        }
        Test.stopTest();
      }
       
    
}