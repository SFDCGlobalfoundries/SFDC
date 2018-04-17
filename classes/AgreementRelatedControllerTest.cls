@isTest
public class AgreementRelatedControllerTest
{
   
   @testsetup  
   public static void TestSetupMethod()
   {
       List<SObject> SobjList=new List<SObject>();
       AgreementTestDataFactory.loaddefaults();
	
         
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'MyTestACC1');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');  
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
        Account acct = AccountDataFactory.createAccount(fieldValueMap);
	            
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       Apttus__APTS_Agreement__c Paragr=AgreementTestDataFactory.GenerateAgreement('Sales_Agreements','Primary Test Agreement',acct);
       SobjList.add(Paragr);
       Apttus__APTS_Agreement__c Childagr=AgreementTestDataFactory.GenerateAgreement('Sales_Agreements','Child Test Agreement',acct);     
       SobjList.add(Childagr);
       
       insert SobjList;
   }       
   public static testMethod void testController() 
   {
       PageReference pageRef = Page.Linked_Agreements;
       Test.setCurrentPage(pageRef);
       
       AgreementRelatedController controller = new AgreementRelatedController();
       
       
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Primary Test Agreement' limit 1];   
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       
       
       Apttus__APTS_Agreement__c Paragr=[select id from Apttus__APTS_Agreement__c where name='Primary Test Agreement' limit 1];
       
       Apttus__APTS_Agreement__c Childagr=[select id,Name,Apttus__Account__r.Name,Apttus__FF_Agreement_Number__c,Owner.Name from Apttus__APTS_Agreement__c where name='Child Test Agreement' limit 1];
       
       controller=new AgreementRelatedController();
       controller.SearchName=ChildAgr.Name;
       controller.AccountName=ChildAgr.Apttus__Account__r.Name;
       controller.SearchAgrNumber=ChildAgr.Apttus__FF_Agreement_Number__c;
       controller.OwnerName=ChildAgr.Owner.Name;
       //invoking the search method
       
       controller.SearchAgreement();
       System.assertEquals(controller.AgrSearchList.size(),1);
       
       
       
       //invoking the link method
       
       controller.AgrSearchList[0].isChecked=True;
       controller.AgrSearchList[0].objAgr=Childagr;
       
       System.assertEquals(1,controller.getTotalCount());
       
       controller.Link();
       
       List<Linked_and_Associated_Contract__c> linkedList=[select id from Linked_and_Associated_Contract__c where Top_Level_Agreement__c=:Paragr.id or Child_Level_Agreement__c=:Paragr.id];
       System.assertEquals(2,linkedList.size());
       
       controller.ClearAll();
       System.assertEquals(controller.AgrSearchList.size(),0);
       
       
       controller.closeEvent();
       
       pageRef = new PageReference('/'+Paragr.id);
       Test.setCurrentPage(pageRef);
       
       System.assertEquals(FALSE,controller.hasNext);
       System.assertEquals(FALSE,controller.hasPrevious);
       
       
       controller.contextItem=Childagr.id;
       controller.doSelectItem();
       System.assertEquals(1,controller.getSelectedCount());
       controller.doDeselectItem();
       System.assertEquals(0,controller.getSelectedCount());
       
       
           
       }
       
       }