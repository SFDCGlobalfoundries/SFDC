/*
Type Name: ClsLeadConversionTrigHandlerTest
Author: Cognizant
Created Date: 30-May-2013
Reason: This is the Test class for class ClsLeadConversionTrigHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/
@isTest
public class ClsLeadConversionTrigHandlerTest
{
      @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
            
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                       
            fieldValueMap.put('Bill_To_Address_1__c', 'Woodland Drive');          
            fieldValueMap.put('Bill_To_City__c', 'New Jersey');            
            fieldValueMap.put('Bill_To_Country__c', 'Portugal');        
            fieldValueMap.put('Fab_9_10__c','No');
    
            AccountDataFactory.createAccount(fieldValueMap);
        }
     static testMethod void createData()   
{     
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
      
       
     Lead leadObj=new Lead();
     leadObj.Company ='Company1';
     leadObj.Account_Type__c ='Customer';
     leadObj.Region__c='APJ';
     leadObj.Status ='Open';
     leadObj.Market_Segment__c='Automotive';
     leadObj.LastName='new Lead';
     leadObj.Bill_To_Address_1__c='Woodland Drive';
     leadObj.Bill_To_City__c='New Jersey';
     leadObj.Bill_To_Country__c='Portugal';
     
     leadObj.Corporate_Address_1__c = 'Portugal Corporate Address';
     leadObj.Corporate_City__c = 'Test Corporate City';
     insert leadObj;
     
     List<Lead> LeadList=new List<Lead>();
     List<Id> idList = new List<Id>();   
     idList.add(leadObj.Id);
      
     Database.LeadConvert[] leadsToConvert = new Database.LeadConvert[0];       
     Database.LeadConvert converter = new Database.LeadConvert();    
          
    for (Id leadId : idList )
      {             
        converter.setLeadId(leadId );                      
        account account = getAccount('MYTEST ACCOUNT1');            
        converter.setAccountId(account.id); 
        contact contact = new contact(firstname='test', lastname='test', accountid=account.id,email='test@gmail.com');               
        insert contact;               
        converter.setContactId(contact.id);                           
        converter.setConvertedStatus('Unqualified'); 
        converter.setDoNotCreateOpportunity( true );               
        leadsToConvert.add( converter );         
        }       
        Database.ConvertLead( leadsToConvert, true );   
        LeadList.add(leadObj);
        Test.startTest(); 
        ClsLeadConversionTrigHandler.onLeadConversion(LeadList);
        Test.stopTest();
    
     } 
     
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}