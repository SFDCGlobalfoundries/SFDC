/*
Type Name: portalTabAccessTriggerHandlerTest
Author: Cognizant
Created Date: 24-April-2013
Reason: This is the Test class for class portalTabAccessTriggerHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    DBiswal     05182015    - Updated code for refactoring of test class.  
*/
@isTest
public class portalTabAccessTriggerHandlerTest
{    
   @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    
    static testMethod void createData()
    {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
    
     User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
      System.runAs(runningUser) {
        
     Set<Id> UserId=new Set<Id>();
     List<String> deptList=new  List<String>();
     Account accntObj = getAccount('MYTEST ACCOUNT1');
       
          //Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design;Procurement;Engineering;Legal;Quality;Supply Chain');   
             Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
          insert conobj;
          
          deptList.add(conobj.Department__c);
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         //insert   portalUser   ;
         Database.insert(portalUser,false);
         
        /* 
         Contact_Portal_Tab_Access__c ContactPTAObj=new Contact_Portal_Tab_Access__c ();
         
         ContactPTAObj.X3rd_Party_IP__c=true;
         ContactPTAObj.Account_Statement__c=true;
         ContactPTAObj.Backlog__c=true;
         ContactPTAObj.Billing__c=true;
         ContactPTAObj.BOM__c=true;
         ContactPTAObj.Certificate_of_Compliance__c=true;
         ContactPTAObj.Configurator__c=true;
         ContactPTAObj.CPK__c=true;
         ContactPTAObj.Credit_and_Debit_Note__c=true;
         ContactPTAObj.Custom_Shipment_Report__c=true;
         ContactPTAObj.Design_Technology_Documents__c=true;
         ContactPTAObj.Design_Enablement__c=true;
         ContactPTAObj.Design_Specification_Packages__c=true;
         ContactPTAObj.Export_Control__c=true;
         ContactPTAObj.Fab_Out_Schedule__c=true;
         ContactPTAObj.Finish_Goods_Report__c=true;

         ContactPTAObj.Forecast_Fab_Cycle_Time__c=true;
         ContactPTAObj.Global_Shuttle_reservation__c=true;
         ContactPTAObj.IP__c=true;
         ContactPTAObj.IP_PLM__c=true;
         ContactPTAObj.IP_Declaration__c=true;
         ContactPTAObj.Lot_Control_table__c=true;
         ContactPTAObj.MPW__c=true;
         ContactPTAObj.New_Part_Creation_after_Proto_form__c=true;
         ContactPTAObj.NRE_Invoice__c=true;
         ContactPTAObj.On_Time_Delivery__c=true;
         ContactPTAObj.Order_Acknowledgement__c=true;
         ContactPTAObj.Shipment_Detail_Unsort_and_Sort__c=true;
         ContactPTAObj.Packaging_List_Report__c=true;
         ContactPTAObj.PCRB__c=true;
        
         ContactPTAObj.Order_Query__c=true;
         ContactPTAObj.PTRF__c=true;
         ContactPTAObj.Protoype_tracking__c=true;
         ContactPTAObj.Product_Wafer_Compliance_Analysis__c=true;
         ContactPTAObj.Production_Query__c=true;
         ContactPTAObj.Production__c=true;
         ContactPTAObj.Process_Technology__c=true;
         ContactPTAObj.Process_Request_Form_PRF__c=true;
         ContactPTAObj.Process_Reliability_Monitoring__c=true;
         ContactPTAObj.Process_ID__c=true;
         ContactPTAObj.Price_List__c=true;
         ContactPTAObj.Yield_Sort_ETest_Reporting__c=true;
         ContactPTAObj.WIP_Status__c=true;
         ContactPTAObj.Web_View__c=true;
         ContactPTAObj.Wafer_Start__c=true;
         ContactPTAObj.Wafer_Inspection__c=true;
         ContactPTAObj.Turnkey__c=true;
         ContactPTAObj.Tester_Gauge_R_R__c=true;
         ContactPTAObj.Tax_Invoice__c=true;
         ContactPTAObj.Stepper_Tooling_Form__c=true;
         ContactPTAObj.Shipping_Query__c=true;
         ContactPTAObj.Shipping__c=true;
         
         
         ContactPTAObj.Shipment_Alert_Report__c=true;
         ContactPTAObj.Ship_Alert_by_Location__c=true;
         ContactPTAObj.Services__c=true;
         ContactPTAObj.RTR_RTP__c=true;
         ContactPTAObj.ROM_Blanket__c=true;
         
         ContactPTAObj.Risk_Waiver__c=true;
         ContactPTAObj.Reticle_Obsolescence__c=true;
         ContactPTAObj.Purchase_Order_Tracking__c=true;
  
         ContactPTAObj.My_Devices__c=true;
         ContactPTAObj.My_wafers__c=true;

         ContactPTAObj.PDK_Design_Documents__c=True;
         ContactPTAObj.Product_Services__c=True;
         ContactPTAObj.Electrical_Test__c=True;
         ContactPTAObj.Orders__c=True;
         ContactPTAObj.Name='Procurement';

         insert ContactPTAObj;*/
         test.starttest();
         Portal_Tab_Access__c PTAObj1= new Portal_Tab_Access__c (Account__c=accntObj.Id ,
                                                               User__c=portalUser.Id,
                                                               my_devices__c=true,
                                                               my_wafers__c=true,
                                                               PDK_Design_Documents__c=True,
                                                               Product_Services__c=True,
                                                               Electrical_Test__c=True);
        //insert PTAObj1;
        Database.insert(PTAObj1,false);
           // System.debug('@@@@@ContactPTAObj'+ContactPTAObj);

        System.debug('@@@@@PTAObj1'+PTAObj1);
        
         UserId.add(portalUser.Id);
       //System.runAs(portalUser)
       //{
         
         
         portalTabAccessTriggerHandler.assignTabAccess(UserId);
         test.stoptest();
         
       //}  
         
        }
     }   
   
   // For Negative testing 
    static testMethod void createDataNegative()
    {
        
        User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
            System.runAs(runningUser) {
             
        
     Set<Id> UserId=new Set<Id>();
     List<String> deptList=new  List<String>();
    
     Account accntObj = getAccount('MYTEST ACCOUNT1');
     
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
          insert conobj;
          
          deptList.add(conobj.Department__c);
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         Database.insert(portalUser,false);
       
         test.starttest();
         Portal_Tab_Access__c PTAObj1= new Portal_Tab_Access__c (Account__c=accntObj.Id ,
                                                               User__c=portalUser.Id,
                                                               my_devices__c=false,
                                                               my_wafers__c=false,
                                                               PDK_Design_Documents__c=false,
                                                               Product_Services__c=false,
                                                               Electrical_Test__c=True);
        //insert PTAObj1;
        Database.insert(PTAObj1,false);
           // System.debug('@@@@@ContactPTAObj'+ContactPTAObj);

        System.debug('@@@@@PTAObj1'+PTAObj1);
        
         UserId.add(portalUser.Id);
     
         
         portalTabAccessTriggerHandler.assignTabAccess(UserId);
         test.stoptest();
 
         
        }
     }
     
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
  }