/*
Class name : CLM_AgreementMassEditCntrlExtTest

Changes:
DBiswal		10192017	changed at line no. 65 for failure fix.
*/
@isTest
public class CLM_AgreementMassEditCntrlExtTest {
    
    @testsetup
    public static void TestSetupMethod()
    {       
        AgreementTestDataFactory.loaddefaults();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        Account acct = AccountDataFactory.createAccount(fieldValueMap);     
    }
    
    
    public static testMethod void testControllerExtension()
    {
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();
            testHCMEmployee.First_Name__c = 'Employee FN';
            testHCMEmployee.Last_Name__c ='Employee LN';
            testHCMEmployee.Employee_ID__c = 'RC1000';
            testHCMEmployee.Login_ID__c ='RC1000';
            testHCMEmployee.Email_Address__c ='abc@test.com';
            testHCMEmployee.Status__c = 'Active';
            
            insert testHCMEmployee;
        
        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='GF Biz Ops Alliances'];
        User ndaUser = new User(alias = 'testuser', email='abc@test.com',
               emailencodingkey='UTF-8', lastname='testLastname', firstname='testFirstname', languagelocalekey='en_US',
               localesidkey='en_US', profileid = stdUserProfile.Id, FederationIdentifier = 'RC1000',
               timezonesidkey='America/Los_Angeles', username='abc1234gf@test.com',communitynickname='testname');

        Database.insert(ndaUser);
        System.runAs(ndaUser)
        {
            List<SObject> SobjList = new List<SObject>();
            Account acct = getAccount('MYTEST ACCOUNT1');
            Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
            SobjList.add(con);
            Apttus__APTS_Agreement__c Agr=AgreementTestDataFactory.GenerateAgreement('Sales_Agreements','Test Agreement',acct);      
            SobjList.add(Agr);        
            Environment_Variable__c var = new Environment_Variable__c();
            var.Name='NDA_MassEdit_RecordTypes';
            var.Value__c = 'Sales_Agreements';
            SobjList.add(var);
            
			test.startTest();
            try{
                database.insert(SobjList,false);           
            }catch(DMLException e){
                GlobalUtility.logMessage('Error', 'AgreementMassEditCntrlExtTest', 'TestSetupMethod','', 'Exception while inserting sObject Record', String.valueof(e.getMessage()),'','NDA Management',e,0);
            }  
            System.assert(testHCMEmployee != null);            
            PageReference pageRef = Page.CLM_Mass_Edit_Agreement;
            Test.setCurrentPage(pageRef);
        
            //Apttus__APTS_Agreement__c Agr=[select Id,Name,Apttus__FF_Agreement_Number__c,GF_Contract_End_Date__c,Warning_Notice_Recipient_1__c,Warning_Notice_Recipient_2__c,CLM_Contract_Administrator__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
            ApexPages.currentPage().getParameters().put('ids', Agr.id);
            CLM_AgreementMassEditCntrlExt controller = new CLM_AgreementMassEditCntrlExt(new ApexPages.StandardController(Agr));
               
            Agr.Warning_Notice_Recipient_1__c='abc@test.com';
            Agr.Warning_Notice_Recipient_2__c='xyz@test.com';
        
            
            PageReference pg = controller.doSave();
            PageReference pg1 = controller.doCancel();
              
            System.AssertEquals(Agr.name,'Test Agreement');
            System.AssertEquals(Agr.Warning_Notice_Recipient_1__c,'abc@test.com');
            System.AssertEquals(Agr.Warning_Notice_Recipient_2__c,'xyz@test.com');
        
            PageReference pageRef1 = Page.CLM_MassEditAgreement_EmailLookup;
            Test.setCurrentPage(pageRef1);
        
            ApexPages.currentPage().getParameters().put('emailId', 'abc@test.com');
        
            CLM_AgreementMassEditCntrlExt controller1 = new CLM_AgreementMassEditCntrlExt();
            PageReference pg2 = controller1.userEmailLookUp();
            System.Assert(controller1.userlist1.size()>0,Userinfo.getUserEmail());
        
            test.stopTest();
        }
    }
    
        private static Account getAccount(string AccountName)
        {
            Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];         
            return acct;
        } 

}