/*
 Type Name: ClsPdkDesignDocTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsPdkDesignDoc' class.
 Change History:
 Author: 
 Modification History: 
 ZAmbat     10182013        - Optimized code to load custom setting values and set running user. 
 Ashwini    03262015        - Updated code for refactoring of test class.
 …….. 
 ……..
*/

@isTest
private class ClsPdkDesignDocTest 
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
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    /**
        This method helps to test the PortalTabAccess record List for PDK Design & Docs to check its all elements are set as 'True'
        and test the Page Redirection phase.
        
        @method name: testClsPdkDesignDoc
       
     */
     
    static testmethod void testClsPdkDesignDoc()
    {
            //DataUtilTest.loadEnvironmentVariables();
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
            System.runAs(runningUser) {
      
             Account acctObj = getAccount('MYTEST ACCOUNT1');
             acctObj.Authorized_for_ASIC_business__c = 'Yes';
             update acctObj;
                
                
                conobj.FirstName='Mr';
                conobj.LastName='Testcon1';
                conobj.AccountId=acctObj.Id;
                conobj.Email='con1@gf.com';
                conobj.Department__c='Design';
                Test.startTest();                          
                insert conobj;
                system.assertEquals(conobj.Email,'con1@gf.com'); 
                
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
                userObj.CommunityNickname = 'zTestUser123';
                           
                insert userObj;
                //commented to resolve test failures
                //portaltabObj.User__c = userObj.Id;
                portaltabObj.Account__c = acctObj.Id;
                 
                
                portaltabObj.BOM__c = true;
                portaltabObj.Design_Specification_Packages__c = true;
                portaltabObj.Design_Technology_Documents__c = true; 
                portaltabObj.New_Part_Creation_after_Proto_form__c = true; 
                portaltabObj.PDK__c = true; 
                portaltabObj.IP_PLM__c = true; 
                portaltabObj.PTRF__c = true;
                
                
                insert portaltabObj;  //Uncommented by Ashish
                portaltabObj.User__c = userObj.Id;
                update portaltabObj;
            }
            
            System.runAs(userObj)
            {
            
                
                ClsPdkDesignDoc  clsPdkDesignDocObj = new ClsPdkDesignDoc ();
                clsPdkDesignDocObj.Page = 'designspec';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'designtechdoc';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'pdk';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ipplm';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'bom';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'new_part_creation';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ptrf';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ipkit';  
                clsPdkDesignDocObj.redirect();
                
                
                // Inserting New pages for covering code coverage of ASICNewsletter functionlity by Ashish Jadhav
                clsPdkDesignDocObj.Page = 'ASICnewsalerts';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ASICipagreements';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ASICdkdesignkits';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.Page = 'ASICdocumentation';  
                clsPdkDesignDocObj.redirect();
                clsPdkDesignDocObj.FTPswitch();
                clsPdkDesignDocObj.maintainSession();
                clsPdkDesignDocObj.PDKInstallation();
                clsPdkDesignDocObj.PDKInstallationQuick();
                
                // till here
                Test.stopTest();    
                
               // System.assertEquals(true, clsPdkDesignDocObj.showbomLink);    
            }                           
    }
    
    /**
        This method helps to test the PortalTabAccess record List for PDK Design & Docs to check its all elements are set as 'False'.
        
        
        @method name: testClsPdkDesignDocPTA
       
     */
     static testmethod void testClsPdkDesignDocPTA()
     {
            //DataUtilTest.loadEnvironmentVariables();
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Contact conobj=new Contact();
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            
            User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
            System.runAs(runningUser) {
            
          
         
                Account acctObj = getAccount('MYTEST ACCOUNT1');
                acctObj.Authorized_for_ASIC_business__c ='No';
                update acctObj;
                
                conobj.FirstName='Mr';
                conobj.LastName='Testcon11';
                conobj.AccountId=acctObj.Id;
                conobj.Email='con11@gf.com';
                conobj.Department__c='Design';
                Test.startTest();                          
                insert conobj;
                
                
                userObj.Alias = 'John1207';
                userObj.Email='John1207@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='John1207@test.com';
                userObj.Portal_Login__c = 'xyz1207';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;
                userObj.CommunityNickname = 'zTestUser123';
                            
                insert userObj;
                
               //commented to resolve test failures
                //portaltabObj.User__c = userObj.Id;
                portaltabObj.Account__c = acctObj.Id;
                 
                
                portaltabObj.BOM__c = false;
                portaltabObj.Design_Specification_Packages__c = false;
                portaltabObj.Design_Technology_Documents__c = false; 
                portaltabObj.New_Part_Creation_after_Proto_form__c = false; 
                portaltabObj.PDK__c = false; 
                portaltabObj.IP_PLM__c = false; 
                portaltabObj.PTRF__c = false;
                portaltabObj.Access_Setup_News_Alerts_ASIC__c = true;
                portaltabObj.Access_Setup_Design_Kits_ASIC_DK__c = true;
                portaltabObj.Access_Setup_Documentation_ASIC__c = true;
             
             /* Changed for Case-00004721 Start */
                
                insert portaltabObj; // Uncommented this line. 
                portaltabObj.User__c = userObj.Id;
                update portaltabObj;
                
             /* Changed for Case-00004721 End */   
            }
                        
            
            System.runAs(userObj)
            {
            
                
                ClsPdkDesignDoc  clsPdkDesignDocObj = new ClsPdkDesignDoc ();
               // clsPdkDesignDocObj.getRowList();
                Test.stopTest();    
                
                //System.assertEquals(false, clsPdkDesignDocObj.showpdkLink);    
            }   
/* Changed for Case-00004721 Code Added Start */
            
                portaltabObj.BOM__c = true;
                portaltabObj.Design_Specification_Packages__c = true;
                portaltabObj.Design_Technology_Documents__c = true; 
                portaltabObj.New_Part_Creation_after_Proto_form__c = true; 
                portaltabObj.PDK__c = true; 
                portaltabObj.IP_PLM__c = true; 
                portaltabObj.PTRF__c = true; 
                
                update portaltabObj;

                System.runAs(userObj)
                {
                    ClsPdkDesignDoc  clsPdkDesignDocObj = new ClsPdkDesignDoc ();      
                }                          
                
            /* Changed for Case-00004721 Code Added End */                                     
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}