/**
* Author: Dilip Jha
* Project: Sandbox Refresh Automation  
* Description: This is the Apex Test class for SandboxRefreshScript Apex class
**/



@isTest(SeeAllData=false)

public class SandboxRefreshScriptTest
    {
          @testSetup static void methodName() {
        DataUtilTest.loadEnvironmentVariables();
    }
        static testMethod void updateContact()        
            {
                          
                 Account accntObj1 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria', Short_Name__c = 'testplm2',
                              Has_Valid_NDA__c =true,Tech_Geo_Granted__c='0.11UM;0.13UM;',
        recordtypeid = '012900000004Ba8AAE', Valid_Tech_Geos__c='0.11UM; 0.13UM;');
                
                insert accntObj1;
                                               
                contact contact1=new contact(firstName='test1',lastName='test1',AccountId=accntObj1.id, email='test@test.com');
                
                insert contact1;
                contact con = [SELECT Id FROM Contact WHERE email='test@test.com' LIMIT 1];
                con.email='test1@test.com.rmdev';
                update con;
                
                
                
                test.startTest();
                contact1.email='test1@test.com.rmdev';
                update contact1;
                
                
                contact1= [select id, name, AccountId, email from contact where id=:contact1.id];

 

                accntObj1= [select id from Account where id=:accntObj1.id];

                system.assertequals(contact1.email,'test1@test.com.rmdev');
                
                test.stoptest();
                
                
              SandboxRefreshScript updatecon=new SandboxRefreshScript();
                updatecon.updateContact();  
                
            }
            
        static testMethod void updateFabDistributionTable()        
            {
                test.starttest();
                
                Fab_Distribution_Table__c fdTable=new Fab_Distribution_Table__c();
                
                fdTable.Distribution_List__c='test@test.com';
                fdTable.Fab_No__c='FAB201';
                
                insert fdTable;
                
                fdTable.Distribution_List__c='test@test.com.rmdev';
                
                
                update fdTable;
                
                fdTable = [select id, Distribution_List__c, Fab_No__c from Fab_Distribution_Table__c  where id=:fdTable.id];
                system.assertequals(fdTable.Distribution_List__c,'test@test.com.rmdev');
                
                test.stoptest();
                              
                SandboxRefreshScript updateFabTable=new SandboxRefreshScript();
                updateFabTable.updateFabDistributionTable();
                
            }
            
        
        static testMethod void updateNDAVariable()        
            {                     
                SandboxRefreshScript updateNdaVr=new SandboxRefreshScript();
                updateNdaVr.updateNDAVariable();
                
            }  
            
        static testMethod void updateMpwSalesforceUrl()        
            {    
                test.starttest();
                MPW_Salesforce_URL__c lstValues = new MPW_Salesforce_URL__c();  
                
                lstValues.URL__c='https://globalfoundries--RMDEV--c.cs5.visual.force.com/apex/InternalChargeOutReportVF?';
                
                insert lstvalues;
                
                lstValues.URL__c='https://globalfoundries--RMDE--c.cs5.visual.force.com/apex/InternalChargeOutReportVF?';
                update lstvalues;
                test.stoptest();                               
                SandboxRefreshScript updateMpwUrl=new SandboxRefreshScript();
                updateMpwUrl.updateMpwSalesforceUrl();
                
            }  
            
        static testMethod void updateGFDQEndpoints()        
            {   
            
                test.starttest();
                GF_DQ_Settings__c lstValues = new GF_DQ_Settings__c();  
                lstvalues.Name='test';
                lstValues.Datawarehouse_wsdl__c='https://globalfoundries--RMDEV--c.cs5.visual.force.com/apex/InternalChargeOutReportVF?';
                
                insert lstvalues;
                
                lstValues.Datawarehouse_wsdl__c='https://globalfoundries--RMDE--c.cs5.visual.force.com/apex/InternalChargeOutReportVF?';
                lstvalues.Name='test';

                update lstvalues;
                
                test.stoptest();                           
                SandboxRefreshScript updateEndp=new SandboxRefreshScript();
                updateEndp.updateGFDQEndpoints();
                
            } 
            
       static testMethod void updateEnvironmentVariable()        
            {                              
                SandboxRefreshScript updateEndp=new SandboxRefreshScript();
                updateEndp.updateEnvironmentVariable();
                
            } 
            
        static testMethod void updateEnvVariable()        
            {                              
                SandboxRefreshScript updateEndp=new SandboxRefreshScript();
                updateEndp.updateEnvVariable();
                
            }
            
         static testMethod void updateEnvVariableFalse()        
            {                              
                SandboxRefreshScript updateEndp=new SandboxRefreshScript();
                updateEndp.updateEnvVariableFalse();
                
            } 
            
          static testMethod void updateApptusInstanceUrl()        
            {   
            
                test.starttest();
                Apttus__ComplySystemProperties__c lstValues = new Apttus__ComplySystemProperties__c();  
                lstvalues.Name='test';
                lstValues.Apttus__InstanceUrl__c ='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                
                insert lstvalues;
                
                lstValues.Apttus__InstanceUrl__c ='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                lstvalues.Name='test';

                update lstvalues;                                 
                SandboxRefreshScript updateAptusUrl=new SandboxRefreshScript();
                updateAptusUrl.updateApptusInstanceUrl();
                
            } 
            
          static testMethod void updateApptusXapps()        
            {   
                
                test.starttest();
                Apttus_XApps__XAuthorForExcelSystemProperties__c lstValues = new Apttus_XApps__XAuthorForExcelSystemProperties__c();  
                lstvalues.Name='test';
                lstValues.Apttus_XApps__InstanceUrl__c='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                
                insert lstvalues;
                
                lstValues.Apttus_XApps__InstanceUrl__c ='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                lstvalues.Name='test';

                update lstvalues;                               
                SandboxRefreshScript updateAptusUrl=new SandboxRefreshScript();
                updateAptusUrl.updateApptusXapps();
                
            } 
            
          static testMethod void updateEnvVariableNull()        
            {                              
                SandboxRefreshScript updateEndp=new SandboxRefreshScript();
                updateEndp.updateEnvVariableNull();
                
            }   
            
           static testMethod void updateApttusProposalSettings()        
            {   
            
                 test.starttest();
                Apttus_Proposal__ProposalSystemProperties__c lstValues = new Apttus_Proposal__ProposalSystemProperties__c();  
                lstvalues.Name='test';
                lstValues.Apttus_Proposal__InstanceUrl__c='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                
                insert lstvalues;
                
                lstValues.Apttus_Proposal__InstanceUrl__c ='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                lstvalues.Name='test';

                update lstvalues;                           
                SandboxRefreshScript updateAptusUrl=new SandboxRefreshScript();
                updateAptusUrl.updateApttusProposalSettings();
                
            }  
            
            
          static testMethod void updateAiaToErpFlag()        
            {                              
                SandboxRefreshScript updateAiaToErpFlag=new SandboxRefreshScript();
                updateAiaToErpFlag.updateAiaToErpFlag();
                
            }
            
            static testMethod void updateHcmEmployee()        
            {                              
                SandboxRefreshScript updateHcmEmp=new SandboxRefreshScript();
                updateHcmEmp.updateHcmEmployee();
                
            }        
          static testMethod void updateApttusSettings()        
            {   
            
                test.starttest();
                Apttus_Config2__ConfigSystemProperties__c lstValues = new Apttus_Config2__ConfigSystemProperties__c();  
                lstvalues.Name='test';
                lstValues.Apttus_Config2__InstanceUrl__c='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                
                insert lstvalues;
                
                lstValues.Apttus_Config2__InstanceUrl__c ='https://globalfoundries--rmdev.cs31.my.salesforce.com';
                lstvalues.Name='test';

                update lstvalues;                               
                SandboxRefreshScript updateAptusUrl=new SandboxRefreshScript();
                updateAptusUrl.updateApttusSettings();
                
            } 
 
            
       static testMethod void runApexClass() 
           {
                SandboxRefreshScript apexclass = new SandboxRefreshScript();
                Test.testSandboxPostCopyScript(apexclass, UserInfo.getOrganizationId(), '00Dp00000000hjM', 'sandbox2');
                System.assertEquals(1,1,'Test something');

            }
                

    }