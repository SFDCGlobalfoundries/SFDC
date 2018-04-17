/**
 *    Company       :   Cognizant Technologies PTE Ltd.
 *    Description   :   Test Class for ROS_UpdateIndividualReticleGFForm
 *    History       :   

        Initials         Date                Description
-----------------------------------------------------------------------------------------
        Vijay Mahajan    04/25/2014           Test class created.
        
**/ 
@isTest(SEEALLDATA = false)
private class ROS_UpdateIndividualReticleGFFormTest{

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
         List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
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
            fieldValueMap.put('Fab_9_10__c','no');
           
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Account acc= getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
    }

    //static Account account;
    static Reticle__c reticle;
    static User csrUser;
    
    // Creation of an Account
    static Account createAccount(){
        Account acc= getAccount('MYTEST ACCOUNT1');
        return acc;
    }
    
    
    static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }
    
     static Id createReticleCycle() {
        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }
    
    static void createHCMEmplyee(){
        List<HCM_Employee__c> lstHCMEmployee = new List<HCM_Employee__c >();
        
        HCM_Employee__c hcmEmp= new HCM_Employee__c();
        hcmEmp.Login_ID__c = 'testHCM';
        hcmEmp.Last_Name__c = 'TestCSRUser';
        hcmEmp.First_Name__c = 'Test';
        hcmEmp.Department_Name__c =  'IT';
        hcmEmp.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmp.Job_Title__c = 'TestTitle';
        hcmEmp.Phone_Number__c =  '999999999';
        hcmEmp.Employee_ID__c = '123456';
        lstHCMEmployee.add(hcmEmp);
        
        insert lstHCMEmployee;
    }
    static User createCSRUser(){
        Profile systemCSRProfile = [select id from Profile where name = 'GF CSR'];
        User usr1 = new User();           
        usr1.Alias= 'testCSR';
        usr1.Email= 'tesCSR@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.LastName = 'TestCSRUser';
        usr1.FirstName = 'Test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemCSRProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testCSRnUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.IsActive = true;
        usr1.FederationIdentifier = '123456';
        insert(usr1);
        return usr1;
    }
    
    
    
    static void prepareData(){
        
        
       Account account = createAccount();
        String Cycle = createReticleCycle();
        createHCMEmplyee();
        csrUser = createCSRUser();
        reticle = createReticle(null, cycle, 500,csrUser.Id);
       
    }
    static testMethod void testNavigatetoGEFormfromReticle(){
       prepareData(); 
       ROS_UpdateIndividualReticleGFForm rosUpdateIndividualReticleGFForm = new ROS_UpdateIndividualReticleGFForm(new ApexPages.StandardController(reticle));
       Test.startTest();
       PageReference pageRef = rosUpdateIndividualReticleGFForm.NavigatetoGEFormfromReticle();
       Test.stopTest();
       System.assertNotEquals(null, pageRef);
    } 
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}