/*
  Author: Ramareddy Karri
  Description: This is the test class for the PCNEOL_EmaiHandler
  History:
    Ramareddy   12072016    - code creation.
    Dinesh      12272016    - code modified                            
*/

@isTest(SeeAllData=false)
public class PCNEOL_EmaiHandlerTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
        
     static testMethod void testSaving2()
    {
        User loggedinuser = [Select id,Name,UserRole.Name from User where Id = :UserInfo.getUserId()];
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
        
        PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Submitted, Awaiting LMT Approval','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
        EOL1.Fab__c ='Fab 10';
        EOL1.LMT_Affected__c ='ASIC';
        EOL1.Package_Type_Affected__c ='Cu11';
        EOL1.Reason_for_the_discontinuance__c = 'testreasion';
        EOL1.Technology_Affected__c = '32G';
        EOL.Name = 'testName3'; 
        listpcn.add(EOL1);
        Insert listpcn;
            
        // Create Part Customer
        list<Part_Customer_Infomation__c> pcilst = new list<Part_Customer_Infomation__c>();
        Part_Customer_Infomation__c pcust1 = QS_TestUtil.createPartCustomers(EOL.Id,shiplst[0].Id,account1.Id);
        pcust1.End_Of_Life__c = EOL.Id;
        pcust1.Select_Checkbox__c= True;
        pcust1.IBM_Part_Number__c = 'test12';
        Part_Customer_Infomation__c pcust2 = QS_TestUtil.createPartCustomers(EOL.Id,shiplst[1].Id,account1.Id);
        pcust2.End_Of_Life__c = EOL.Id;
        pcust2.Select_Checkbox__c= True;
        pcust2.IBM_Part_Number__c = 'test123';
        pcilst.add(pcust1);
        pcilst.add(pcust2);
        Insert pcilst;            
        PCNEOL_EmaiHandler.sendTriggerEmail(listpcn[0]);
        PCNEOL_EmaiHandler.SendEmailtoPrimarys(listpcn[0]);        
        }
         Test.stopTest(); 
    }
}