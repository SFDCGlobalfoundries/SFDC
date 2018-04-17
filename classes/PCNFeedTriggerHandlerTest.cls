/*
  Author: Ramareddy Karri
  Description: This is the test class for the PCNFeedTriggerHandler
  History:
    Ramareddy   12062016    - code creation.
    Dinesh      12272016    - code modified                            
*/
@isTest(SeeAllData=false)
private class PCNFeedTriggerHandlerTest {
@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
     static testmethod void testmethod1()
    {
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = new Account();
            Contact conobj=new Contact();
            User accoutOwner = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
            acctObj.Name='TestAccount';
            acctobj.ownerId = accoutOwner.Id;
            acctObj.Site_Department__c = 'Site1';
            acctObj.Sub_Type__c = 'Direct';
            acctObj.Transaction_Type__c = 'Transactional';
            acctObj.Region__c = 'APJ';
            acctObj.Bill_To_Address_1__c='KOL';
            acctObj.Bill_To_City__c = 'KOL';
            acctObj.Bill_To_Country__c = 'INDIA';
            acctObj.Corporate_Address_1__c = 'Street';
            acctObj.Corporate_City__c = 'KOL';
            acctObj.Corporate_Country__c = 'INDIA';            
            insert acctObj; 
        
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
            System.runAs(userObj)
            {
            // Insert PCN
            list<PCN_EOL__c> pcnLst = new  list<PCN_EOL__c>();
            PCN_EOL__c EOL = QS_TestUtil.createPCNEOL('PCNEOL36','Fab 10','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 185,System.today() + 200,System.today() + 300);
            EOL.Fab__c ='Fab 10';
            EOL.LMT_Affected__c ='ASIC';
            EOL.Package_Type_Affected__c ='Cu11';
            EOL.Reason_for_the_discontinuance__c = 'testreasion';
            EOL.Technology_Affected__c = '32G';
            EOL.EOL_Stage__c = 'Sent to Customers';
            EOL.Name = 'testName2';
            pcnLst.add(EOL);
            PCN_EOL__c EOL1 = QS_TestUtil.createPCNEOL('PCNEOL37','Fab 9','ASIC','Cu11','Sent to Customers','testreasion',True,True,True,'000',System.today() + 200,System.today() + 400,System.today() + 650);
            EOL1.Fab__c ='Fab 9';
            EOL1.LMT_Affected__c ='ASIC';
            EOL1.Package_Type_Affected__c ='Cu11';
            EOL1.Reason_for_the_discontinuance__c = 'testreasion';
            EOL1.Technology_Affected__c = '32G';
            EOL1.EOL_Stage__c = 'Sent to Customers';
            EOL1.Name = 'testName3';
            pcnLst.add(EOL1);
            Insert pcnLst;                    
                    
            // Insert FeedItem for PCN
            List<FeedItem> feedlist = new List<FeedItem>(); 
            List<String> parentlist = new List<String>();
            FeedItem post1 = new FeedItem();
            post1.ParentId = pcnLst[0].Id;
            post1.Body = 'Enter post text here';
            FeedItem post2 = new FeedItem();
            post2.ParentId = pcnLst[1].Id;
            post2.Body = 'Enter post text here';
            feedlist.add(post1);
            parentlist.add(pcnLst[0].Id);
            parentlist.add(pcnLst[1].Id);
            feedlist.add(post2);
            Insert feedlist;             
            PCNFeedTriggerHandler.emailNotificationforFeedComment(feedlist,parentlist);
            Delete feedlist;            
                }
            Test.stopTest();  
        }
    }