/*
*    Author: Sreedhar Karukonda
*    Description:  This class is used as Test data creation for all PEOL related Test classes
*    History: 
*    skarukon      09/22/2015    - Apex code created    
*/
@isTest
public class DevicePEOLTestsData {
    public static Account createAccount(String shortName, String customerNumber){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
        fieldValueMap.put('Short_Name__c', shortName);        
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Customer_Number__c',customerNumber);

        return AccountDataFactory.createAccount(fieldValueMap);                
    }

    public static List<Account_Team_Proxy__c> createAccountTeam(Account acc, List<String> teamRoles, List<User> users){
        List<Account_Team_Proxy__c> teamProxies = new List<Account_Team_Proxy__c>();
        for(Integer idx = 0; idx < teamRoles.size(); idx++ ){
            teamProxies.add(new Account_Team_Proxy__c(Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write', Team_Role__c= teamRoles[idx], Account__c=acc.Id, USer__c=users[idx].Id));
        }
        insert teamProxies;
        return teamProxies;
    }

    public static ERP_Device__c createERPDevice(String inventoryId, String fabs){
        ERP_Device__c d1 = new ERP_Device__c(
            name = 'd1',
            fab__c = fabs,
            geometry__c = '0.028UM',
            ERP_Inventory_Id__c =  inventoryId           
        );
        insert d1;
        return d1;
    }

 public static ERP_Device__c createERPDevice(String inventoryId, String fabs, String crmdid, String processName){
    ERP_Device__c d1 = new ERP_Device__c(
            Name = 'd1',
            Fab__c = fabs,
            Geometry__c = '0.028UM',
            ERP_Inventory_Id__c =  inventoryId,
            CRMDID__c = crmdid,
            Process_ID_Name__c = processName
        );
        insert d1;
    return d1;
  }

    public static List<Customer_Item__c> createCustomerItems(String deviceInventoryId, List<String> customerShortNames ){
        List<Customer_Item__c> customerItems = new List<Customer_Item__c>();
        for(String cs : customerShortNames){
            customerItems.add(new Customer_Item__c(ERP_Device_Inventory_Id__c = deviceInventoryId, Customer_Short_Name__c = cs));
        }
        insert customerItems;
        return customerItems;
    }

    public static User createUser(String profile, String name){
      Profile prf = [SELECT Id  FROM Profile  WHERE Name = :profile];
                      
      User usr = new User(alias = ('xU' + Math.Random()).substring(0,7),
                      email = 'xUser@testorg.com' + Math.Random(),
                      emailencodingkey = 'UTF-8',
                      firstName = name,
                      lastname = 'xUser' + Math.Random(), 
                      languagelocalekey = 'en_US',
                      localesidkey = 'en_US',
                      profileid = prf.Id,
                      Portal_Login__c = 'TestxUserLogin0001' + Math.Random(),
                      timezonesidkey = 'America/Los_Angeles',
                      username = 'xUser@testorg.com' + Math.Random());
      insert usr;
      return usr;
  }

  public static Process__c createProcess( String processName){
      Process__c p = new Process__c();
      p.Name = processName;
      p.Available_to_Sell__c = 'Available';
      insert p;
      return p;  
  }
// Creation of an opportunity for Test
  public static Id createOpp(Id acctId){
      Opportunity opp = new Opportunity(Name='Test Opportunity'+Math.random(),AccountId=acctId,StageName='1. Discovery',Market_Segment__c='Automotive',
                                      Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                      Process_Geometry__c = '0.09UM',Process_Family__c = 'Generic / Nominal',
                                      Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21));
      
      insert opp;
      return opp.Id;
  }

  // Creation of an opportunity program for Test
  public static Id createOppProg(Id acctId, Id oppId){
      Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
      insert opProg;
      return opProg.Id;
  }

  public static Device__c createDevice(Id accId,  Id processId, String crmdid){
      Id optyId = createOpp(accId);
      Id optyProgramId = createOppProg(accId, optyId);
      Device__c dev = new Device__c( Name = 'TESTDEVICE1947',Stage__c = 'Design In',Status__c = 'Active',
      Account__c = accId,Opportunity2__c = optyId, Opportunity_Program__c = optyProgramId, Market_Segment__c = 'Automotive',
      Semiconductor_Device__c = 'Analog Regulator',End_Application__c = 'Body',Device_Sourcing__c = '3rd Source',
      Tapeout_Type__c = 'Customer MPW',Siebel_Device_ID__c = '0987654321',IP_Gap__c = false,Assigned_Process_ID__c = processId,
      BX041_Status__c = 'Closed', Actual_Tapeout_Date__c = date.newInstance(2013,5,20), 
      Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
      Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4)); 
      dev.Confidence_Level_Tapeout__c = '100';
      dev.Fab__c = 'Fab 3'; 
      dev.Original_Forecasted_Tapeout_Date__c = System.today();
      dev.CRMDID__c = crmdid; 
      insert dev;
      return dev; 
  }
    
}