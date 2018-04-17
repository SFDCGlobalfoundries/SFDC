/*
  Author: Ramareddy Karri
  Description: This is the test class for the PCN_EOLController_Modified
  History:
    Ramareddy   11252016    - code creation.
    Dinesh      12272016    - code modified          
    Sameera     02232017    - code modified                   
*/
@istest
public class PCN_EOLController_ModifiedTest {
    static Account account1;
    static Account account2;
    static Contact contact;
    static User portalUser;
    static string searchtext;
    static PCN_EOL__c pcnEol;
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static void setupData(){     
        
        //create Account
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
        account1 = AccountDataFactory.createAccount(fieldValueMap);
        
        //Create Contact
        contact = QS_TestUtil.createContact('Test Contact', 'Test Contact', account1.Id, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        
        //Create Shipment Internel
        Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',account1.Id);
        Insert shpInternal;
        
        //Create Shipline Internel
        List<Shipment_Line_Internal__c> shiplst = new List<Shipment_Line_Internal__c>();
        shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,account1.Id,'123'));
        shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname2',shpInternal.Id,account1.Id,'1234'));
        shiplst.add(QS_TestUtil.createShipment_Line_Internal('testname3',shpInternal.Id,account1.Id,'12345'));
        Insert shiplst; 

        
    }
    static testMethod void testSaving2(){
        setupData();  
        User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        Account acctObj = new Account();
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
        
        Shipment_Internal__c shpInternal = QS_TestUtil.createShipment_Internal('testShipInternal',acctObj.Id);
        Insert shpInternal;
        
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'1234');
        Insert shipline;
        
        ApexPages.standardController stdContrl= new ApexPages.standardController(new PCN_EOL__c());
        PCN_EOLController_Modified pem = new PCN_EOLController_Modified(stdContrl);
        pem.EOL = QS_TestUtil.createPCNEOL('PCNEOL36','Fab 10','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'0000000KM565',System.today() + 185,System.today() + 200,System.today() + 300);
        insert pem.EOL;
        List<Part_Customer_Infomation__c> pcinfo=[Select End_Of_Life__c,Shipment_Line_Internal__c,Account__c from Part_Customer_Infomation__c where End_Of_Life__c=:pem.EOL.Id];
        pem.EOL.Fab__c ='Fab 10';
        pem.EOL.LMT_Affected__c ='ASIC';
        pem.EOL.Package_Type_Affected__c ='Cu11';
        pem.EOL.Reason_for_the_discontinuance__c = 'testreasion';
        pem.EOL.Technology_Affected__c = '32G';
        pem.EOL.Name = 'testName2';
        pem.searchtext ='0000P01DW337,0000P01DW338';
        pem.search();
        pem.save();    
        Test.startTest();  
        PageReference pageRef = Page.PCN_EOLPageModified;
        Test.setCurrentPage(pageRef);
        system.debug('&&&&'+pem.EOL);
        List<PCN_EOL__c> pcn = [Select CreatedDate from PCN_EOL__c where id=:pem.EOL.Id];
        Datetime dt=pcn[0].CreatedDate ;
        
        Date cDate = date.newinstance(dT.year(), dT.month(), dT.day());
        pem.EOL.Last_Order_Date__c=cDate-5;
        update pem.EOL;
        
        List<PCN_EOL__c> pcn1 = [Select Last_Order_Date__c from PCN_EOL__c where id=:pem.EOL.Id];
        pem.EOL.Last_Order_Date__c=pcn1[0].Last_Order_Date__c-100;
        update pem.EOL;
        ApexPages.currentPage().getParameters().put('Id', pem.EOL.Id);       
        Apexpages.currentpage().getParameters().put('index1','123');  
        Apexpages.currentpage().getParameters().put('index','123');  
        PCN_EOLController_Modified IMCext = new PCN_EOLController_Modified(new ApexPages.StandardController(pem.EOL));
        IMCext.EOL.EOL_Stage__c = 'Sent to Customers';
        IMCext.searchtext = '1234,12345';
        IMCext.EOL.Reason_for_the_discontinuance__c = 'test1234'; 
        IMCext.listwrapper.add(new PCN_EOLController_Modified.ShipmentWrapper([select id,Shipment__c,IBM_Part_Num__c,Ultimate_Customer_Account__c,Shipment__r.Account__c from Shipment_Line_Internal__c  where id=:shipline.Id]));
        IMCext.var = pem.EOL.Id;
        IMCext.save();        

        IMCext.removingRow();
        IMCext.removingRow1();
        Test.stopTest();
        
    }
    static testMethod void testSaving3(){
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
        userObj.UserName='shyam@test.com';
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
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'1234');
        Insert shipline;
        
        
        PCN_EOL__c EOL2 = QS_TestUtil.createPCNEOL('PCNEOL36','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);       
        EOL2.Fab__c ='Fab 10';
        EOL2.LMT_Affected__c ='ASIC';
        EOL2.Package_Type_Affected__c ='Cu11';
        EOL2.Reason_for_the_discontinuance__c = 'testreasion';
        EOL2.Technology_Affected__c = '32G';
        EOL2.Name = 'testName2';
        ApexPages.standardController stdContrl= new ApexPages.standardController(new PCN_EOL__c());
        PCN_EOLController_Modified pem = new PCN_EOLController_Modified(stdContrl);
        pem.searchtext = '1234;12345';
        pem.search();
        pem.listwrapper.add(new PCN_EOLController_Modified.ShipmentWrapper([select id,Shipment__c,IBM_Part_Num__c,Ultimate_Customer_Account__c,Shipment__r.Account__c from Shipment_Line_Internal__c  where id=:shipline.Id]));
        pem.save();  
        EOL2.Fab__c ='Fab 9';
        pem.save();

        }
        Test.stopTest();
    }
    
    static testMethod void testSaving4(){
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
        userObj.UserName='shyam123@test.com';
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
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'0000000KM565');
        Insert shipline;
        
        
        PCN_EOL__c EOL21 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);       
        EOL21.Fab__c ='Fab 10';
        EOL21.LMT_Affected__c ='ASIC';
        EOL21.Package_Type_Affected__c ='Cu11';
        EOL21.Reason_for_the_discontinuance__c = 'testreasion';
        EOL21.Technology_Affected__c = '32G';
        EOL21.Name = 'testName2';
        ApexPages.standardController stdContrl= new ApexPages.standardController(new PCN_EOL__c());
        PCN_EOLController_Modified pem = new PCN_EOLController_Modified(stdContrl);
        pem.searchtext = '0000000KM565';
        pem.search();
        pem.listwrapper.add(new PCN_EOLController_Modified.ShipmentWrapper([select id,Shipment__c,IBM_Part_Num__c,Ultimate_Customer_Account__c,Shipment__r.Account__c from Shipment_Line_Internal__c  where id=:shipline.Id]));
        pem.save();  
        EOL21.Fab__c ='Fab 9';
        pem.save();
        
        }
        Test.stopTest();
    }
    
    static testMethod void testSaving5(){
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
        userObj.UserName='shyam12345@test.com';
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
            
        Shipment_Line_Internal__c shipline = QS_TestUtil.createShipment_Line_Internal('testname1',shpInternal.Id,acctObj.Id,'0000000KM565');
        Insert shipline;
        
        
        PCN_EOL__c EOL21 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 90,System.today() + 200,System.today() + 300);       
        EOL21.Fab__c ='Fab 10';
        EOL21.LMT_Affected__c ='ASIC';
        EOL21.Package_Type_Affected__c ='Cu11';
        EOL21.Reason_for_the_discontinuance__c = 'testreasion';
        EOL21.Technology_Affected__c = '32G';
        EOL21.Name = 'testName2';
        ApexPages.standardController stdContrl= new ApexPages.standardController(new PCN_EOL__c());
        PCN_EOLController_Modified pem = new PCN_EOLController_Modified(stdContrl);
        pem.searchtext = '0000000KM565';
        pem.search();
        pem.listwrapper.add(new PCN_EOLController_Modified.ShipmentWrapper([select id,Shipment__c,IBM_Part_Num__c,Ultimate_Customer_Account__c,Shipment__r.Account__c from Shipment_Line_Internal__c  where id=:shipline.Id]));
        pem.save();  
        EOL21.Fab__c ='Fab 9';
        pem.save();
        
        }
        Test.stopTest();
    }
        
}