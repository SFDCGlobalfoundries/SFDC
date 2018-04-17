/*    
    Author: Yash Kumar 
    Description: This serves as the test class for Batch class UpdateRiskStartSystemDataBatch .
    History:
    Ykumar  08022014        -   Test Class Creation.
      
*/
@isTest(SeeAlldata=false)
public class UpdateRiskStartSystemDataBatchTest { 

@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 1000');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static List<User> lUser {private get; private set;}
    static Account account {private get; private set;}
    static testMethod void doTestUpdateRiskStartSystemDataBatch(){     
  try
  {
        Test.startTest();
  
        //string accid='0019000000GJoM4'; 
        list<SObject> listSObj = new list<Sobject>();
        listSObj.add(new Environment_Variable__c(Name = 'EPTS_SKIP_ACCOUNT', Value__c = 'lsi'));
        DataUtilTest.loadEnvironmentVariables();
        database.insert(listSObj, false);
        
                 Account acc1 = getAccount('Test Account 1000');
  
        Risk_Start_System__c riskStartSystem = new Risk_Start_System__c();

        //riskStartSystem.Customer_Name__c = accid;
        riskStartSystem.Customer_Name__c = acc1.Id;
        riskStartSystem.Recommended_Device__c = 'TESTDEVICE';
        riskStartSystem.Recommended_Quantity__c = 100;
        riskStartSystem.Status__c = 'Conversion in Progress';
        riskStartSystem.Fab__c = 'Fab 2';
              
         
         Risk_Start_System__c riskStartSystem1=[select id, name from Risk_Start_System__c where id =:riskStartSystem.id];           
       
         Manufacturing_Lot__c MANU =new Manufacturing_Lot__c(Account_Name__c=acc1.Id,name='rest546',Active_Flag__c=true,risk_start__c=riskStartSystem1.id,Current_Wafer_Quantity_In_Lot__c=100,  Sales_Order_Number__c=riskStartSystem1.name,Step_ID__c='Wafer',LST_Wafer_Quantity__c='100');
      //  Manufacturing_Lot__c MANU =[select id,Active_Flag__c,  Sales_Order_Number__c,Step_ID__c,LST_Wafer_Quantity__c from Manufacturing_Lot__c  where id='a5d90000000RT0hAAG'];
        
        insert MANU ; 
        MANU.Step_ID__c='Chip';
        MANU.Active_Flag__c=true;
        MANU.LST_Wafer_Quantity__c ='100';
        MANU.Sales_Order_Number__c='201409176012';
        MANU.risk_start__c='a1u900000007uPn';
        Update MANU;
//system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+MANU.risk_start__c);

        
        UpdateRiskStartSystemDataBatch batchapex=new UpdateRiskStartSystemDataBatch();
        ID batchprocessid = Database.executeBatch(batchapex);
        
        
         
        Test.stopTest();

    }
    catch(Exception ex)
    {
        System.debug('%%%%%%%%%%%%%%%%%:  '+ex.getMessage());
    } 
 }
 

    
     private static Account getAccount(string AccountName)
    {
        Account acc1= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acc1;
    }  
}