/*
 Type Name: ClsMySubscriptionTest
 Author: Cognizant Technology Solutions
 Created Date: 30-Aug-2013
 Reason: This is the test class for 'ClsMySubscription' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Nbustillos  10182013    - Moved calls to Test.StartTest() and Test.StopTest() to prevent governor limit.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/



@isTest
private class ClsMySubscriptionTest
{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    /**
        This method helps to test the VFMySubscription page.
        
        @method name: testClsMySubscription
       
     */
     
    static testmethod void testClsMySubscription()
    {
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
        
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
         User userObj = new User();
         Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();                        
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            Test.startTest();
            //commented to resolve test failures
            //portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acctObj.Id;
             
            
            portaltabObj.My_Devices__c = true;
            portaltabObj.Wafer_Inspection__c = true;
            portaltabObj.WIP_Status__c = true; 
            portaltabObj.Tester_Gauge_R_R__c = true; 
            portaltabObj.Product_Wafer_Compliance_Analysis__c = true; 
            portaltabObj.Electrical_Test__c = true; 
            portaltabObj.CPK__c = true;
            portaltabObj.Yield_Sort_ETest_Reporting__c = true;
            portaltabObj.Process_Technology__c = true; 
            portaltabObj.Lot_Control_table__c = true;
            portaltabObj.Web_View__c = true; 
            portaltabObj.Stepper_Tooling_Form__c = true; 
            portaltabObj.Risk_Waiver__c = true; 
            portaltabObj.Reticle_Obsolescence__c = true; 
            portaltabObj.RTR_RTP__c = true; 
            portaltabObj.PCRB__c = true;
            portaltabObj.Prototype_tracking__c = true;
            portaltabObj.Process_Request_Form_PRF__c = true; 
            portaltabObj.Process_Reliability_Monitoring__c = true; 
            portaltabObj.PTRF__c = true; 
            portaltabObj.New_Part_Creation_after_Proto_form__c = true; 
            portaltabObj.IP_Declaration__c = true; 
            portaltabObj.Global_Shuttle_reservation__c = true; 
            portaltabObj.Export_Control__c = true; 
            portaltabObj.BOM__c = true;
            portaltabObj.WLR_Monitoring_report__c= true;
            portaltabObj.Engineering_Lot_status_report__c= true;
            portaltabObj.ET_and_Inline_CPK_report__c= true;
            portaltabObj.Construction_Analysis_report__c= true;
            portaltabObj.Change_request_report__c= true;
         
         
            insert portaltabObj;
            portaltabObj.User__c = userObj.Id;
            update portaltabObj;            
            
            System.runAs(userObj)
            {
            
                
                ClsMySubscription  clsMySubscriptionObj = new ClsMySubscription();
                
            }
            Test.stopTest();
    }  
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    } 
}