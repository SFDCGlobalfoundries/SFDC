/*
Type Name: clsUpdateDocProvisioningHandlerTest.
Author: Cognizant
Created Date: 19-Sep-2013
Reason: This is the Test class for apex class clsUpdateDocProvisioningHandler
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/
@isTest
public class clsUpdateDocProvisioningHandlerTest
{    
   
   @testSetup static void testdata() {
    
    DataUtilTest.loadEnvironmentVariables();
    
     List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
                fieldValueMap.put('Name', 'TESTACC'+z);            
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
                fieldValueMap.put('Authorized_for_ASIC_business__c','Yes');                  
            fieldValueMapsList.add(fieldValueMap);
        }
            
            AccountDataFactory.createAccounts(fieldValueMapsList,3);
       
        }

      
    static testMethod void clsUpdateDocProvisioningHandlerTest()
    {
        // Load Environment Variables   
      //  DataUtilTest.loadEnvironmentVariables();
      User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];

        List<Account> lstTestAcc = getAccounts();
        list<account> lstacc=new list<account>();
         
        for(Account acc:lstTestAcc)
        {
          Account accIn = new Account();
          accIn.id= acc.id;
          accIn.Short_name__c =acc.name;
          accIn.Valid_Tech_Geos__c='0.10UM;0.20UM;0.11UM';
          accIn.Tech_Geo_Granted__c='0.10UM;0.20UM;0.11UM;0.15UM';
          accIn.Has_Valid_NDA__c=true;
          lstacc.add(accIn);
        }
        
       update lstacc;
       
              
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=lstacc[0].Id,Email='con1@gf.com',Department__c='Design');   
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=lstacc[1].Id,Email='con2@gf.com',Department__c='Design');   
        Contact conobj3=new Contact(FirstName='Mr',LastName='Testcon3',AccountId=lstacc[2].Id,Email='con3@gf.com',Department__c='Design');   
        list<contact> lstcon=new list<contact>();
        lstcon.add(conobj);
        lstcon.add(conobj2);
        lstcon.add(conobj3);
        insert lstcon;                         
           
            System.runAs(runningUser) {
  
     
        List<PDK__c> listPDK=new  List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPdk.Master_PDK_ASIC__c = true;
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 93799501;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123; 
        objPDK.PDK_Lifecycle_Phase__c = 'RELEASED';
        objPDK.Tech_Geometry__c = '0.20UM';
        listPDK.add(objPDK);
        insert listPDK; 
        
        List<sub_PDK__c> listsubPDK=new  List<sub_PDK__c>();
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'Release to White list'; 
        
      // Creating multiple Sub Pdk
       for(Integer i=0;i<6;i++)
       {
        sub_PDK__c objSubPDK1 = new sub_PDK__c ();
        
        objSubPDK1.name = 'TestSubPDK'+i;
        objSubPDK1.PDK__c = objPDK.id;
        objSubPDK1.Bundle_Name__c = 'Test Bundle'+i;
        objSubPDK1.Release_Status__c = 'Specific Account Release ';
        listsubPDK.add(objSubPDK1);
       }
        
    
        listsubPDK.add(objSubPDK);
        
        insert listsubPDK;
        
        
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.10UM',OpenText_ID__c=76787007,Specification_Release_List_Long__c='acc;acc2;acc3',Release_Status__c='Specific Account Release',Specification_sub_class__c='ASIC'));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.20UM',OpenText_ID__c=72355007,Specification_Release_List_Long__c='acc;acc2;acc3',Release_Status__c='Specific Account Release',Specification_sub_class__c='ASIC'));
        lstSpec.add(new Design_Spec__c(Name='Spec-003',Document_Number__c='7007007',technology_geometry__c='',OpenText_ID__c=1708407,Specification_Release_List_Long__c='acc;acc2;acc3',Release_Status__c='Release to White list',Specification_sub_class__c='ASIC'));
        lstSpec.add(new Design_Spec__c(Name='Spec-004',Document_Number__c='70077',technology_geometry__c='0.032UM',OpenText_ID__c=1738407,Specification_Release_List_Long__c='acc;acc2;acc3',Release_Status__c='Specific Account Release',Specification_sub_class__c='ASIC'));
        lstSpec.add(new Design_Spec__c(Name='Spec-005',Document_Number__c='707077',technology_geometry__c='0.15UM',OpenText_ID__c=1733407,Specification_Release_List_Long__c='acc2',Release_Status__c='Specific Account Release',Specification_sub_class__c='ASIC'));
        lstSpec.add(new Design_Spec__c(Name='Spec-006',Document_Number__c='707077',technology_geometry__c='0.20UM',OpenText_ID__c=1764107,Specification_Release_List_Long__c='acc;acc2;acc3',Release_Status__c='Release to White list',Specification_sub_class__c='ASIC'));
        insert lstspec;  
        
        Package__c pack1=new Package__c();
        pack1.name = 'Testpack1';
        pack1.Technology_Type__c = 'ANALOG';
        pack1.Tech_Geometry__c = '0.10UM'; 
        
        test.starttest();
        insert pack1;
        
        Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<String> deptList=new  List<String>();
        
              
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        list<user> lstusr=new list<user>();     

        /*Modified By Cognizant for CR # 15680 starts*/
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];    
        System.runAs(admUser){  
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
                                                ContactId=lstcon[0].id,
                                                Portal_Login__c='abc12'
                                               // UserRoleId=UserInfo.getUserRoleId()//Added By Cognizant for CR # 15680

                                               );
        User portalUser2 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser2@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce1',
                                                Lastname='Wayne1',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=lstcon[1].id,
                                                Portal_Login__c='abc12'
                                               // UserRoleId=UserInfo.getUserRoleId()//Added By Cognizant for CR # 15680

                                               );
        User portalUser3 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser3@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce2',
                                                Lastname='Wayn2',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=lstcon[2].id,
                                                Portal_Login__c='abc123'
                                               // UserRoleId=UserInfo.getUserRoleId()//Added By Cognizant for CR # 15680

                                               );
        lstusr=new list<user>();     
        lstusr.add(portalUser);
        lstusr.add(portalUser2);                                  
        lstusr.add(portalUser3);
        insert   lstusr;
        }
        
        /*Modified By Cognizant for CR # 15680 ends*/
        
        List<White_List__c > lstWL=new List<White_List__c >();
        
        White_List__c wList1=new White_List__c();
        wList1.Sub_PDK__c= objSubPDK.id;
        wList1.Account__c= lstacc[1].id;
        
        White_List__c wList2=new White_List__c();
        wList2.Sub_PDK__c= listsubPDK[0].id;
        wList2.Account__c= lstacc[1].id;
        
        lstWL.add(wList1);
        lstWL.add(wList2);
        
        insert lstWL;
        
         
        list<document_provisioning__c> lstprov=new list<document_provisioning__c>();
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[0].id,user__c=lstusr[0].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[0].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[1].id,user__c=lstusr[0].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[0].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[2].id,user__c=lstusr[2].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[1].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[3].id,user__c=lstusr[2].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[1].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[4].id,user__c=lstusr[0].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[0].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[4].id,user__c=lstusr[2].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[1].id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[5].id,user__c=lstusr[2].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=lstacc[1].id));
       
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[0].id,user__c=lstusr[2].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[0].id,AccountID__c=lstacc[2].id));   
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[1].id,user__c=lstusr[1].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[1].id,AccountID__c=lstacc[1].id));   
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[2].id,user__c=lstusr[0].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[2].id,AccountID__c=lstacc[0].id));   
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[3].id,user__c=lstusr[1].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[3].id,AccountID__c=lstacc[1].id));   
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[4].id,user__c=lstusr[0].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[4].id,AccountID__c=lstacc[0].id)); 
        
       /* lstprov.add(new document_provisioning__c(design_package__c=pack1.id,user__c=lstusr[0].Id,status__c='Provisioned',AccountID__c=accntObj.id));
        lstprov.add(new document_provisioning__c(design_package__c=pack1.id,user__c=lstusr[1].Id,status__c='Provisioned',AccountID__c=accntObj1.id));
        lstprov.add(new document_provisioning__c(design_package__c=pack1.id,user__c=lstusr[2].Id,status__c='Provisioned',AccountID__c=accntObj2.id));*/
        
        /**
        lstprov.add(new document_provisioning__c(design_package__c=objPkg.id,user__c=lstusr[0].Id,status__c='Provisioned'));
        lstprov.add(new document_provisioning__c(sub_pdk__c=spdk.id,user__c=lstusr[0].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=spdk.id)); 
        lstprov.add(new document_provisioning__c(sub_pdk__c=spdk2.id,user__c=lstusr[0].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=spdk2.id)); 
        
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[0].id,user__c=lstusr[1].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[1].id,user__c=lstusr[1].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true));
        //lstprov.add(new document_provisioning__c(design_spec__c=lstspec[0].id,user__c=lstusr[1].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true));
        lstprov.add(new document_provisioning__c(design_package__c=objPkg.id,user__c=lstusr[1].Id,status__c='Provisioned'));
        lstprov.add(new document_provisioning__c(sub_pdk__c=spdk.id,user__c=lstusr[1].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=spdk.id));   
        **/
        insert lstprov;
         
           
       
        lstacc[0].Tech_Geo_Granted__c='';
        lstacc[0].Has_Valid_NDA__c=false;
        lstacc[0].Valid_Tech_Geos__c='0.30UM;0.032UM;0.153UM;0.010UM';
        lstacc[0].Authorized_for_ASIC_business__c = 'Yes';
        
        lstacc[1].Tech_Geo_Granted__c='0.20UM';
        lstacc[1].Has_Valid_NDA__c=true;
        lstacc[1].Valid_Tech_Geos__c='0.30UM,0.20UM';
        lstacc[1].Stage__c='Inactive';
        lstacc[1].Authorized_for_ASIC_business__c = 'Yes';
        

        
        lstacc[2].Tech_Geo_Granted__c='0.20UM;0.010UM;0.032UM';
        lstacc[2].Has_Valid_NDA__c=true;
        lstacc[2].Valid_Tech_Geos__c=null;
        lstacc[2].Authorized_for_ASIC_business__c = 'Yes';
        system.debug('****BEfore - lstacc***'+lstacc); 
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = false;       
        update lstacc;
               
               
        lstprov.add(new document_provisioning__c(sub_pdk__c=listsubPDK[0].id,user__c=lstusr[0].Id,status__c='Provisioned',sub_PDK_Provisioned_for__c=listsubPDK[1].id));   
        
        lstacc[0].Tech_Geo_Granted__c='0.20UM;0.010UM;0.032UM';
        lstacc[0].Has_Valid_NDA__c=true;
        lstacc[0].Valid_Tech_Geos__c='0.20UM;0.010UM;0.032UM';
        lstacc[0].Authorized_for_ASIC_business__c = 'Yes';
        lstacc[0].Authorized_for_ASIC_business__c = 'Yes';
        
        lstacc[1].Tech_Geo_Granted__c='0.20UM';
        lstacc[1].Has_Valid_NDA__c=false;
        lstacc[1].Valid_Tech_Geos__c='0.30UM;0.032UM;0.153UM';
        lstacc[1].Stage__c='Inactive';
        lstacc[1].Authorized_for_ASIC_business__c = 'Yes';
        
        lstacc[2].Tech_Geo_Granted__c='0.20UM;0.010UM;0.032UM';
        lstacc[2].Has_Valid_NDA__c=false;
        lstacc[2].Valid_Tech_Geos__c='0.30UM;0.032UM';
        lstacc[2].Authorized_for_ASIC_business__c = 'Yes';                
        
        lstacc[2].Tech_Geo_Granted__c='0.020UM';
        lstacc[2].Has_Valid_NDA__c=true;
        lstacc[2].Valid_Tech_Geos__c='0.20UM;0.032UM';
        lstacc[2].Authorized_for_ASIC_business__c = 'No';
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger        = false;
        update lstacc;
        Map<ID,String> AsicAccountsNew = new Map<ID,String>() ; 
        Map<ID,String> AsicAccountsOld = new Map<ID,String>() ; 
        AsicAccountsNew.put(lstacc[1].ID,'Yes');
        AsicAccountsOld.put(lstacc[1].ID,'No');     
        
        AsicAccountsNew.put(lstacc[2].ID,'No');
        AsicAccountsOld.put(lstacc[2].ID,'Yes');
                    
         clsUpdateDocProvisioningHandler.handleDocProvisioningUpdateASICFuture(AsicAccountsNew,AsicAccountsOld);
     
         system.debug('****lstacc***'+lstacc);
       //system.assert(false);
       
        test.stoptest();

        system.assert(lstprov[0].status__c=='Provisioned');
        
    }
 }   
 
  private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account limit 3];   
        
        return accList;
    } 
}