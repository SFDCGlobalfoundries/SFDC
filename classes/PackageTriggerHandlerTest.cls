/*
Type Name: PackageTriggerHandlerTest.
Author: Cognizant
Created Date: 17-Aug-2013
Reason: This is the Test class for PackageTriggerHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
  Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
  DBiswal     05182015    - Updated code for refactoring of test class.  
*/
@isTest(seeAllData = false)
public class PackageTriggerHandlerTest
{   
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    
    }
     
    static testMethod void testPackageSpecDelete(){
    
     List<package__c> lstPck = new List<package__c>() ;
        package__c objPkg2 = new package__c();
        objPkg2.Name = 'Test2';
        objPkg2.Tech_Geometry__c = '0.10UM';
        objPkg2.Package_Release_Status__c='Draft';
         
        package__c objPkg3 = new package__c();
        objPkg3.Name = 'Test3';
        objPkg3.Tech_Geometry__c = '0.10UM';
        objPkg3.Package_Release_Status__c='Draft';
        //insert objPkg3 ;
              
        //lstPck.add(objPkg) ; 
        lstPck.add(objPkg2) ; 
        lstPck.add(objPkg3) ;  
        
        insert lstPck ; 

        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-006',Document_Number__c='7007089',technology_geometry__c='0.11UM',OpenText_ID__c=10070012,Release_Status__c='Release to White List'));
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.10UM',OpenText_ID__c=7007007,Release_Status__c='General Release'));
        insert lstSpec;
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
    

        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg3.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg3.id,design_spec__c=lstspec[1].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg2.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg2.id,design_spec__c=lstspec[1].id));

        insert lstPckgSpec;
        

        List<Document_Provisioning__c > docProvList=new List<Document_Provisioning__c >();
        Document_Provisioning__c docProv1=new Document_Provisioning__c (Design_Package__c=objPkg3.Id,status__c='Provisioned');
        Document_Provisioning__c docProv2=new Document_Provisioning__c (Design_Package__c=objPkg3.Id,status__c='Provisioned');
        
        Document_Provisioning__c docProv3=new Document_Provisioning__c (Design_spec__c=lstspec[0].id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg3.Id);
        Document_Provisioning__c docProv4=new Document_Provisioning__c (Design_spec__c=lstspec[1].id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg3.Id);
        
        docProvList.add(docProv1);
        docProvList.add(docProv2);
        docProvList.add(docProv3);
        docProvList.add(docProv4);

        insert docProvList;
        delete lstPckgSpec.get(0);
        
        lstPck.get(0).Package_Release_Status__c='General Release';
        try{
               update lstPck.get(0);
           }catch(Exception e){
        
           }
        try{
               delete lstPck.get(0);
           }catch(Exception e){
        
           }

    }
    
    
    static testMethod void testDraftPackageScenarios(){
        //DataUtilTest.loadEnvironmentVariables();

    
        Account accntObj= getAccount('MYTEST ACCOUNT1');
        
        Account accntObj1= getAccount('MYTEST ACCOUNT2');
        
        
        
        
                list<contact> lstcon=new list<contact>();
                Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
                Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj1.Id,Email='con21@gf.com',Department__c='Design');
                lstcon.add(conobj);
                lstcon.add(conobj2);
                insert lstcon;

        //insert conobj;
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        list<user> lstusr=new list<user>();     
        User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com1',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com1',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.Id,
                                                Portal_Login__c='abc12'
                                               );
//insert  portalUser ;

User portalUser2 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser2@testorg.com3',
                                                Alias = 'auser3',
                                                Email='portaluser@testorg.com3',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj2.id,
                                                Portal_Login__c='abc123'
                                               ); 
        lstusr.add(portalUser);
        lstusr.add(portalUser2);
        insert  lstusr;
        
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-006',Document_Number__c='7007089',technology_geometry__c='0.11UM',OpenText_ID__c=10070012,Release_Status__c='General Release'));
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.10UM',OpenText_ID__c=7007007,Release_Status__c='General Release'));
        insert lstSpec;
        RecordType rtypes = [Select Name, Id From RecordType 
                              where sObjectType='White_list__c' and isActive=true and name like '%Design_Spec%' limit 1];
        
        list<white_list__c> lstWL=new list<white_list__c>();
        lstWL.add(new white_list__c(account__c=accntObj.id,    Design_Spec__c=lstspec[0].id,    recordtypeid=rtypes.id)); 
        lstWL.add(new white_list__c(account__c=accntObj.id,    Design_Spec__c=lstspec[1].id,    recordtypeid=rtypes.id));
        lstWL.add(new white_list__c(account__c=accntObj1.id,    Design_Spec__c=lstspec[0].id,    recordtypeid=rtypes.id)); 
        lstWL.add(new white_list__c(account__c=accntObj1.id,    Design_Spec__c=lstspec[1].id,    recordtypeid=rtypes.id));
        insert lstWL;

    
        
        List<package__c> lstPck = new List<package__c>() ;
        package__c objPkg2 = new package__c();
        objPkg2.Name = 'Test2';
        objPkg2.Tech_Geometry__c = '0.10UM';
        objPkg2.Package_Release_Status__c='Draft';
         
        package__c objPkg3 = new package__c();
        objPkg3.Name = 'Test3';
        objPkg3.Tech_Geometry__c = '0.10UM';
        objPkg3.Package_Release_Status__c='Draft';
        //insert objPkg3 ;
              
        //lstPck.add(objPkg) ; 
        lstPck.add(objPkg2) ; 
        lstPck.add(objPkg3) ;  
        
        insert lstPck ; 
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
    

        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg3.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg3.id,design_spec__c=lstspec[1].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg2.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg2.id,design_spec__c=lstspec[1].id));

        insert lstPckgSpec;

        test.startTest();
         
        
        List<Document_Provisioning__c > docProvList=new List<Document_Provisioning__c >();
        Document_Provisioning__c docProv1=new Document_Provisioning__c (Design_Package__c=objPkg3.Id,status__c='Provisioned');
        Document_Provisioning__c docProv2=new Document_Provisioning__c (Design_Package__c=objPkg3.Id,status__c='Provisioned');
        
        Document_Provisioning__c docProv3=new Document_Provisioning__c (Design_spec__c=lstspec[0].id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg3.Id);
        Document_Provisioning__c docProv4=new Document_Provisioning__c (Design_spec__c=lstspec[1].id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg3.Id);
        
        docProvList.add(docProv1);
        docProvList.add(docProv2);
        docProvList.add(docProv3);
        docProvList.add(docProv4);

        insert docProvList;
        
        
        //update objPkg3;
        
       
        /*objPkg3.Package_Release_Status__c='Draft';
        update objPkg3;*/
        
        objPkg3.Package_Release_Status__c='General Release';
        update objPkg3;
        
        lstPck.get(0).Package_Release_Status__c='Draft';
        lstPck.get(1).Package_Release_Status__c='Draft';

        update lstPck;
        

        test.stopTest();

     }
     
     private static Account getAccount(string AccountName)
        {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
        }
}