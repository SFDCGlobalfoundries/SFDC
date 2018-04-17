/*
  Author: Ramareddy Karri
  Description: This is the test class for the PCNEOL_PartCustomerController1
  History:
    Ramareddy   11222016    - code creation.
    Dinesh      12272016    - code modified   
    Sameera     02232017    - code modified                          
*/

@isTest(SeeAllData=false)
    public class PCNEOL_PartCustomerController1Test {
       
        @testSetup static void testdata() 
        {
            DataUtilTest.loadEnvironmentVariables();
        }
    
            static testMethod void testSaving1()
            {
               User usr = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
                   
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
            fieldValueMap.put('OwnerId',usr.Id); 
            Account account1 = AccountDataFactory.createAccount(fieldValueMap);
         
            // create contact
             Contact contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin','Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
             insert contact;
                       
             Id p = [SELECT id,Name FROM profile WHERE Name ='Customer Portal Admin'].id;
             
             User user2 = new User(contactid=contact.id,ProfileId = p,PortalRole = 'Manager',Username = 'TestUserCheckOut@gmail.com',Alias = 'batman',Email='bruce.wayne@wayneenterprises.com',EmailEncodingKey='UTF-8',Firstname='Bruce',Lastname='Wayne',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago');
             user2.CommunityNickname = 'testUser123';
             User2.contactid = contact.id; 
             user2.IsActive = true;
             user2.FederationIdentifier='abcd';               
             Insert user2; 
             Test.startTest();
             
             System.runAs(user2)
             {
                         
             Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',account1.Id);
             Insert shpInternal;
             
             List<Shipment_Line_Internal__c> shiplst = new List<Shipment_Line_Internal__c>();
             shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,account1.Id,'123'));
             shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname2',shpInternal.Id,account1.Id,'1234'));
             shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname3',shpInternal.Id,account1.Id,'12345'));
             Insert shiplst; 
            
            
            // context user
            PCN_EOL__c  EOL = QS_TestUtil.createPCNEOL('PCNEOL36','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
            EOL.Fab__c ='Fab 10';
            EOL.LMT_Affected__c ='ASIC';
            EOL.Package_Type_Affected__c ='Cu11';
            EOL.Reason_for_the_discontinuance__c = 'testreasion';
            EOL.Technology_Affected__c = '32G';
            EOL.Name = 'testName2'; 
            EOL.EOL_Stage__c='Sent to Customers';
            EOL.Method_to_contrl_discontinued_device_p_n__c='TEST';
            Insert EOL;
            
            Part_Customer_Infomation__c pcust = QS_TestUtil.createPartCustomers(EOL.Id,shiplst[0].Id,account1.Id);
            pcust.End_Of_Life__c = EOL.Id;
            pcust.Select_Checkbox__c= True;
            pcust.IBM_Part_Number__c = 'test12';
            pcust.Ultimate_Customer_Account__c=account1.Id;
            Insert pcust;
            
            Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(EOL.Id,shiplst[0].Id,account1.Id);
            pcust.End_Of_Life__c = EOL.Id;
            pcust1.Ultimate_Customer_Select_Checbox__c=true;
            pcust1.IBM_Part_Number__c = 'test12';
            pcust1.Acknowledged__c = true;
            Insert pcust1;
            
            ApexPages.standardController stdContrl= new ApexPages.standardController(EOL);
            PCNEOL_PartCustomerController1 pem = new PCNEOL_PartCustomerController1(stdContrl);          
            pem.listwrapper[0].selected=true;
            List<Part_Customer_Infomation__c> partcust = new List<Part_Customer_Infomation__c>();
            partcust.add(pcust);
            partcust.add(pcust1);
            pem.partcustomerinfo = partcust;
                     
            pem.SendtoCustomer();
           
            PCNEOL_EmaiHandler.sendTriggerEmail(EOL);
            PCNEOL_EmaiHandler.SendEmailtoPrimarys(EOL);
             }
            Test.stopTest();
            }
            static testMethod void testSaving2(){
                
                Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
                User userObj = new User();
                Account acctObj = new Account();
                Contact conobj=new Contact();
                User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
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
                conobj.FirstName='Mr';
                conobj.LastName='Testcon1';
                conobj.AccountId=acctObj.Id;
                conobj.Email='con1@gf.com';
                conobj.Department__c='Design';
                                          
                insert conobj;
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam@test.com';
                userObj.Portal_Login__c = 'xyz';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;
                userObj.FederationIdentifier='abcd';                        
                insert userObj;
                
                Test.startTest();
                System.runAs(userObj)
                {
                Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
                Insert shpInternal;
                system.debug('shpInternal&&&'+shpInternal);
                Shipment_Line_Internal__c shiplst1 = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
                Insert shiplst1; 
                PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Closed','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
                EOL1.Fab__c ='Fab 10';
                EOL1.LMT_Affected__c ='ASIC';
                EOL1.Package_Type_Affected__c ='Cu11';
                EOL1.Reason_for_the_discontinuance__c = 'testreasion';
                EOL1.Technology_Affected__c = '32G';
                EOL1.Name = 'testName4'; 
                Insert EOL1;                
                ApexPages.standardController stdContrl= new ApexPages.standardController(EOL1);
                PCNEOL_PartCustomerController1 pem = new PCNEOL_PartCustomerController1(stdContrl);         
                pem.SendtoCustomer();
                pem.openPCNEOL();
                }
              Test.stopTest(); 
          }
          
          static testMethod void testSaving3(){
                
                Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
                User userObj = new User();
                Account acctObj = new Account();
                Contact conobj=new Contact();
                User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
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
                conobj.FirstName='Mr';
                conobj.LastName='Testcon1';
                conobj.AccountId=acctObj.Id;
                conobj.Email='con1@gf.com';
                conobj.Department__c='Design';
                                          
                insert conobj;
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam1@test.com';
               // userObj.Portal_Login__c = 'xyz';
                //userObj.contactId = conobj.Id;
                userObj.IsActive = true;
                userObj.FederationIdentifier='abcd';                        
                insert userObj;
                
                Test.startTest();
                System.runAs(userObj)
                {
                Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
                Insert shpInternal;
                system.debug('shpInternal&&&'+shpInternal);
                Shipment_Line_Internal__c shiplst1 = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
                Insert shiplst1; 
                PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Closed','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
                EOL1.Fab__c ='Fab 10';
                EOL1.LMT_Affected__c ='ASIC';
                EOL1.Package_Type_Affected__c ='Other';
                EOL1.Reason_for_the_discontinuance__c = 'testreasion';
                EOL1.Technology_Affected__c = '32G';
                EOL1.Name = 'testName4'; 
                Insert EOL1;                
                ApexPages.standardController stdContrl= new ApexPages.standardController(EOL1);
                PCNEOL_PartCustomerController1 pem = new PCNEOL_PartCustomerController1(stdContrl);         
                pem.SendtoCustomer();
                pem.openPCNEOL();
                }
              Test.stopTest(); 
          }
          
          static testMethod void testSaving4(){
                
                Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
                //Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
                
                User userObj = new User();
                Account acctObj = new Account();
                Contact conobj=new Contact();
                User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
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
                conobj.FirstName='Mr';
                conobj.LastName='Testcon1';
                conobj.AccountId=acctObj.Id;
                conobj.Email='con1@gf.com';
                conobj.Department__c='Design';                          
                insert conobj;
                
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam2@test.com';
                userObj.Portal_Login__c = 'xyz';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;      
                userObj.FederationIdentifier='abcd';                  
                insert userObj;
                
                Test.startTest();
                System.runAs(userObj)
                {
                Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
                Insert shpInternal;
                system.debug('shpInternal&&&'+shpInternal);
                Shipment_Line_Internal__c shiplst1 = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
                Insert shiplst1; 
                PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Closed','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
                EOL1.Fab__c ='Fab 10';
                EOL1.LMT_Affected__c ='ASIC';
                EOL1.Package_Type_Affected__c ='Cu11';
                EOL1.Reason_for_the_discontinuance__c = 'testreasion';
                EOL1.Technology_Affected__c = '32G';
                EOL1.Name = 'testName4'; 
                Insert EOL1;                
                ApexPages.standardController stdContrl= new ApexPages.standardController(EOL1);
                PCNEOL_PartCustomerController1 pem = new PCNEOL_PartCustomerController1(stdContrl);         
                pem.SendtoCustomer();
                pem.openPCNEOL();
                }
              Test.stopTest(); 
          }
          
          static testMethod void testSaving5(){
                
                Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
                //Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
                
                User userObj = new User();
                Account acctObj = new Account();
                Contact conobj=new Contact();
                User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
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
                conobj.FirstName='Mr';
                conobj.LastName='Testcon1';
                conobj.AccountId=acctObj.Id;
                conobj.Email='';
                conobj.Department__c='Design';                          
                insert conobj; 
                
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam3@test.com';
                userObj.Portal_Login__c = 'xyz';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;     
                userObj.FederationIdentifier='abcd';                   
                insert userObj;
                
                Test.startTest();
                System.runAs(userObj)
                {
                Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
                Insert shpInternal;
                system.debug('shpInternal&&&'+shpInternal);
                Shipment_Line_Internal__c shiplst1 = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'123');
                Insert shiplst1; 
                PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Closed','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
                EOL1.Fab__c ='Fab 10';
                EOL1.LMT_Affected__c ='ASIC';
                EOL1.Package_Type_Affected__c ='Cu11';
                EOL1.Reason_for_the_discontinuance__c = 'testreasion';
                EOL1.Technology_Affected__c = '32G';
                EOL1.Name = 'testName4'; 
                Insert EOL1;                
                ApexPages.standardController stdContrl= new ApexPages.standardController(EOL1);
                PCNEOL_PartCustomerController1 pem = new PCNEOL_PartCustomerController1(stdContrl);         
                pem.SendtoCustomer();
                pem.openPCNEOL();
                }
              Test.stopTest(); 
          }
            
       }