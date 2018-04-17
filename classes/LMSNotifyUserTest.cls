/*
    Author: Nino Bustillos
    Description: Test class for LMSNotifyUser trigger.
    History:
        Nbustillos    04292013    - created.
*/
@isTest
public class LMSNotifyUserTest{
    static testMethod void TestLMSNotifyUser() {
      /*lmscons__Training_Path__c objCourse = new lmscons__Training_Path__c();
      objCourse.Name = 'Sample Course';
      objCourse.lmscons__Description__c = 'This is a sample Course';
      objCourse.Market_Segment__c = 'Automotive';
      objCourse.lmscons__Language__c = 'English';
      objCourse.lmscons__Delivery_Type__c = 'Online';
      insert objCourse;
      
      lmscons__Training_Content__c objModule = new lmscons__Training_Content__c();
      //objModule.Name = 'Test Module';
      objModule.lmsilt__Module_Type__c = 'Event';
      objModule.lmscons__Language__c = 'en_US';
      insert objModule;
      
      RecordType r = [select id from RecordType where SobjectType = 'lmscons__Training_Path_Item__c' and Name = 'Module' limit 1];
      
      lmscons__Training_Path_Item__c objCourseItem = new lmscons__Training_Path_Item__c();
      //objCourseItem.Name = 'Sample Course Item';
      objCourseItem.lmscons__Training_Path__c = objCourse.Id;
      objCourseItem.lmscons__Training_Content__c = objModule.Id;
      insert objCourseItem;
      
      lmscons__Transcript__c objTranscript = new lmscons__Transcript__c();
      objTranscript.lmscons__Trainee__c = UserInfo.getUserId();
        objTranscript.lmscons__Trainee_User_Profile__c = 'Test Profile';
        insert objTranscript;
        
        lmscons__Training_Content_License__c objContentLicense = new lmscons__Training_Content_License__c();
        objContentLicense.lmscons__Training_Content__c = objModule.Id;
        objContentLicense.lmscons__Expiration_Date__c = system.today().addDays(365);
        insert  objContentLicense;
        
        lmscons__Training_User_License__c objTranscriptUserLicense = new lmscons__Training_User_License__c();
        objTranscriptUserLicense.lmscons__Expiration__c = system.today().addDays(365);
         objTranscriptUserLicense.lmscons__User__c = UserInfo.getUserId();
         objTranscriptUserLicense.lmscons__Content_License__c = objContentLicense.Id;
        insert objTranscriptUserLicense;
        
        lmscons__Transcript_Line__c objTranscriptLine = new lmscons__Transcript_Line__c();
        objTranscriptLine.lmscons__Transcript__c = objTranscript.Id;
        objTranscriptLine.lmscons__Training_User_License__c = objTranscriptUserLicense.Id;
        insert objTranscriptLine;*/
    }
}