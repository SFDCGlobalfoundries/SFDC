@isTest
private class Cls_Team_Room_delte_log_trgTest {

    static testMethod void testcls_Team_Room_delte_log_trgTest() {
        RecordType recordtypeObj= [select id,Name from RecordType where name='Internal Public'];
        Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
        User userObj = new User();
        Team_Room__c teamRoomObj = new Team_Room__c();
        
         userObj.Alias = 'Sally2';
         userObj.Email='Sally2055@test.com'; 
         userObj.EmailEncodingKey='UTF-8'; 
         userObj.LastName='Kuutti';
         userObj.LanguageLocaleKey='en_US'; 
         userObj.LocaleSidKey='en_US';
         userObj.ProfileId = profileObj.Id;
         userObj.TimeZoneSidKey='America/Los_Angeles'; 
         userObj.UserName='Sally2055@test.com';
         userObj.IsActive = true;
                        
         insert userObj;
         
         teamRoomObj.Team_Room_Administrator__c = userObj.Id;
         teamRoomObj.Name ='Team Room 1';
         teamRoomObj.Team_Room_Description__c = 'Team Room Description';
         teamRoomObj.Terms_n_Conditions_Accepted__c = true;
         teamRoomObj.recordtypeid = recordtypeObj.Id;
            
         insert teamRoomObj;
         System.runAs(userObj)
         {
            Test.startTest();
            delete teamRoomObj;
            Test.stopTest();
                
         }
         
         
        }
           
    }