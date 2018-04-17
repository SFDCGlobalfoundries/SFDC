/*Author: Cognizant Case Mgmt Team
* Description: Test Class for ManageEmailNotificationTrigger
* History: Created on 08/13/2015
*/
@isTest(SeeAllData = false)
public class ManageEmailNotificationTriggerTest{
public static testMethod void testManageEmailRecCreation() {
    test.starttest();
        //inserting test data for custom setting
        list < CSforDefaultownerandteam__c > cslist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'CAD Environment - Documentation';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        c.Bug_Owner__c = Userinfo.getUserId();
        c.Bug_BugTeam__c = Userinfo.getUserId();
        insert c;
        // Creating bug with product/technology and component fields.
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        insert b;
        
        //Creating Manage Email Notification Record
        String manageEmailRecordTypeId = [select id, name from recordtype where name = 'Manage Email Notification-Myself'][0].id;
        Manage_Email_Notification__c manageEmail = new Manage_Email_Notification__c();
        manageEmail.User__c = Userinfo.getUserId(); 
        manageEmail.Chatter_Only__c = true; 
        manageEmail.Bug_Update_Only__c = false; 
        manageEmail.Re_Evaluate__c = true;
        manageEmail.RecordTypeId = manageEmailRecordTypeId ;
        insert manageEmail;
        manageEmail.Chatter_Only__c = false; 
        update manageEmail;
    test.stoptest();
}
}