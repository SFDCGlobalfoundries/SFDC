/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This test class is for code coverage for ClsCpkReportProvisioningHandlerCallout
  History:
  ASPattanaik 09112016 - Class Creation.
--------------------------------------------------------------*/
@isTest
public class ClsCpkReportProvisioningCalloutTest {

    @testSetup static void testdata() {
    
    //DataUtilTest.loadEnvironmentVariables();
        

        
        //Inserting custom setting data
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPK Deprovision URL','www.test.com');
        insert env;

        //Inserting custom setting data
		Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
		bl.Bill_To_Address_Number__c = 2072;
		insert bl;

        Environment_Variable__c ev1 = new Environment_Variable__c();
        ev1.Name = 'CPK_service_enable';
        ev1.Value__c ='true';
        insert ev1;

        Environment_Variable__c ev2 = new Environment_Variable__c();
        ev2.Name = 'SELF_SIGNED_CERTIFICATE';
        ev2.Value__c='true';
        insert ev2;

		DataUtilTest.LoadATPEnvVariables();
		Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account;
    
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
            fieldValueMapsList.add(fieldValueMap);
        }
            
            AccountDataFactory.createAccounts(fieldValueMapsList,3);
       
        }
    
    static testmethod void myTestMethod(){
              
        test.startTest();
        User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
        System.runAs(runningUser) {
            
        //Inserting Fab data
        List<FAB__c> fablist = new List<FAB__c>();
        List<CPK_Report__c> cpkReportlist = new List<CPK_Report__c>(); 
        FAB__c fab1 = ClsNewCPKReportTest.createFab('FAB 10', true, true);
        fablist.add(fab1);
        FAB__c fab2 = ClsNewCPKReportTest.createFab('FAB 9', true, true);
        fablist.add(fab2);
        insert fablist;
        
        //inserting Account
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap1.put('stage__c', 'Unqualified');        
        fieldValueMap1.put('sub_type__c', 'Direct');
        fieldValueMap1.put('site_department__c', 'test dept');          
        fieldValueMap1.put('transaction_type__c', 'transactional');                          
        fieldValueMap1.put('region__c', 'APJ');        
        fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Corporate_City__c', 'Test City');                
        fieldValueMap1.put('Corporate_Country__c', 'India');
        fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Bill_To_City__c', 'Test City');            
        fieldValueMap1.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap1.put('Fab_9_10__c','No');
        fieldValueMap1.put('Authorized_for_ASIC_business__c','Yes');
        fieldValueMap1.put('Short_Name__c', 'a1erwerw');
        fieldValueMap1.put('Tech_Geo_Granted__c','0.028UM');
        Account acc1 =  AccountDataFactory.createAccount(fieldValueMap1);
            
        CPK_Report__c cpkReport1 = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 1, fab1.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport1.Stage__c = 'Approved';
        cpkReport1.OpenTextId__c = '111111';
		cpkReport1.OpenTextIdPublish__c='1111';
        cpkReport1.Active__c = true;
        cpkReport1.ASIC_Report__c ='ASIC';
        cpkReport1.For_All_ASIC_Customers__c ='Yes';    
        cpkReportlist.add(cpkReport1);
        CPK_Report__c cpkReport2 = ClsNewCPKReportTest.createCPKReport('28LPS', '0.028UM', System.Today() + 1, fab1.Id, 'Monthly',userInfo.getUserId(), '10');
        cpkReport2.Stage__c = 'Approved';
        cpkReport2.OpenTextId__c = '111111';
		cpkReport2.OpenTextIdPublish__c='1111';
        cpkReport2.Active__c = true;
        cpkReport2.ASIC_Report__c ='Geometry';
        cpkReport2.Geometry__c = '0.028UM';
        cpkReport2.For_All_ASIC_Customers__c ='Yes';
        cpkReportlist.add(cpkReport2);            
		insert cpkReportlist;
		CPK_Report_Access_List__c cas = new CPK_Report_Access_List__c();
		cas.Account__c = acc1.id;
		cas.CPK_Report__c = cpkReportlist[0].id;
		insert cas; 
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
       
        lstacc[0].Tech_Geo_Granted__c='';
        lstacc[0].Has_Valid_NDA__c=false;
        lstacc[0].Valid_Tech_Geos__c='0.30UM;0.032UM;0.153UM;0.010UM';
        lstacc[0].Authorized_for_ASIC_business__c = 'Yes';
        
        lstacc[1].Tech_Geo_Granted__c='0.20UM';
        lstacc[1].Has_Valid_NDA__c=true;
        lstacc[1].Valid_Tech_Geos__c='0.30UM,0.20UM'; 
        lstacc[1].Authorized_for_ASIC_business__c = 'Yes';
        

        
        lstacc[2].Tech_Geo_Granted__c='0.20UM;0.010UM;0.032UM';
        lstacc[2].Has_Valid_NDA__c=true;
        lstacc[2].Valid_Tech_Geos__c=null;
        lstacc[2].Authorized_for_ASIC_business__c = 'Yes';
        
        update lstacc;  
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
        update lstacc;
        
        
        lstacc[2].Tech_Geo_Granted__c='0.020UM';
        lstacc[2].Has_Valid_NDA__c=true;
        lstacc[2].Valid_Tech_Geos__c='0.20UM;0.032UM';
        lstacc[2].Authorized_for_ASIC_business__c = 'No';
        update lstacc; 
		      
        test.stopTest();    
        }
        
    }

	
 
    private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c,Tech_Geo_Granted__c FROM Account limit 3];   
        
        return accList;
    }
}