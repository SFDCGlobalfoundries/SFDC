@isTest
public class AgreementUnRelateControllerTest
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
       Apttus__APTS_Agreement__c Paragr=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Primary Test Agreement',acct);
       SobjList.add(Paragr);
       Apttus__APTS_Agreement__c Childagr=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','Child Test Agreement',acct);     
       SobjList.add(Childagr);
       
       insert SobjList;
        
 }       
   public static testMethod void testController() 
   {
       PageReference pageRef = Page.UnRelate_Agreements;
       Test.setCurrentPage(pageRef);
       
       AgreementUnRelateController controller = new AgreementUnRelateController();
       
       
       Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where name='Primary Test Agreement' limit 1];   
       ApexPages.currentPage().getParameters().put('Id', agr.id);
       
       
       Apttus__APTS_Agreement__c Paragr=[select id from Apttus__APTS_Agreement__c where name='Primary Test Agreement' limit 1];
       
       Apttus__APTS_Agreement__c Childagr=[select id,Name,Apttus__Account__r.Name,Apttus__FF_Agreement_Number__c,Owner.Name from Apttus__APTS_Agreement__c where name='Child Test Agreement' limit 1];
       
       AgreementRelatedController RelatedController= new AgreementRelatedController();
       RelatedController=new AgreementRelatedController();
       RelatedController.SearchName=ChildAgr.Name;
       RelatedController.AccountName=ChildAgr.Apttus__Account__r.Name;
       RelatedController.SearchAgrNumber=ChildAgr.Apttus__FF_Agreement_Number__c;
       RelatedController.OwnerName=ChildAgr.Owner.Name;
       //invoking the search method
       
       RelatedController.SearchAgreement();
       System.assertEquals(RelatedController.AgrSearchList.size(),1);
       
       
       
       //invoking the link method
       
       RelatedController.AgrSearchList[0].isChecked=True;
       RelatedController.AgrSearchList[0].objAgr=Childagr;
       
       System.assertEquals(1,RelatedController.getTotalCount());
       
       RelatedController.Link();
       
       
       
       controller=new AgreementUnRelateController();
            
       controller.getAgrList();
       System.assertEquals(controller.AgrLinkedList.size(),1);
       
       
       
       //invoking the remove method
       
       controller.AgrLinkedList[0].isChecked=True;
       controller.AgrLinkedList[0].objAgr=Childagr;
       
       
       
       controller.remove();
       List<Linked_and_Associated_Contract__c> linkedList=new List<Linked_and_Associated_Contract__c>();
       try
       {
       linkedList=[select id from Linked_and_Associated_Contract__c where Top_Level_Agreement__c=:Paragr.id or Child_Level_Agreement__c=:Paragr.id];
       }
       catch(Exception e){}
       
       System.assertEquals(0,linkedList.size());
       
       
       
       
       controller.closeEvent();
       
       
       
       }
       
       }