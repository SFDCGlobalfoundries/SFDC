/*
Type Name: OutOfOfficeTriggerTest
Author: Cognizant
Created Date: 17-Dec-2013
Reason: This is the Test class for OutOfOfficeCheckForDuplicate. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
 */

@isTest
private class OutOfOfficeTriggerTest{

    public static testMethod void testOOONotification() {
    
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(  alias = 'standt', email='standarduser@testorg.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', username='testOOOTrigger@testorg.com');
        insert u;         // Insertion of Standard User 1          

        User u2 = new User( alias = 'standt2', email='standarduser2@testorg.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', username='testOOOTrigger2@testorg.com');
        insert u2;        // Insertion of Standard User 2          
        
        //RecordType RecType1 = [Select Id From RecordType  Where SobjectType = 'Out_Of_Office__c' and RecordType.Name = 'Out Of Office-Others'];
        //RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Out_Of_Office__c' and RecordType.Name = 'Out Of Office-Personal'];
        
        Out_Of_Office__c newOOO = new Out_Of_Office__c (user__c = u.Id,
                                                        Message__c = 'Test',
                                                        //RecordTypeId = RecType1.Id ,
                                                        Active__c  = true ,
                                                       Start_Time__c = Datetime.now()+1,
                                                       End_Time__c = (Datetime.now()+2),
                                                       Delegate_User__c = u2.Id
                                                        );
        insert newOOO;     // Out of Office Created for Standard User 1 .
        newOOO.Active__c =false;
        update newOOO ;
        
        Out_Of_Office__c duplicateOOO = new Out_Of_Office__c (user__c = u.Id,
                                                        Message__c = 'Test',
                                                        //RecordTypeId = RecType1.Id ,
                                                        Active__c  = true ,
                                                       Start_Time__c = Datetime.now()+1,
                                                       End_Time__c = (Datetime.now()+2),
                                                       Delegate_User__c = u2.Id
                                                        );
        
        try{
            insert duplicateOOO ;    // Duplicate Out of Office Created for Standard User 1 .
         }
        catch(Exception e){
         e.getMessage();
         }

        Out_Of_Office__c duplicateOOO1 = new Out_Of_Office__c (user__c = u2.Id,
                                                        Message__c = 'Test',
                                                        //RecordTypeId = RecType1.Id ,
                                                        Active__c  = true ,
                                                       Start_Time__c = Datetime.now()+1,
                                                       End_Time__c = (Datetime.now()+2),
                                                       Delegate_User__c = u.Id
                                                        );
        
        try{
            insert duplicateOOO1 ;    // Out of Office Created for Standard User 2 .
         }
        catch(Exception e){
         e.getMessage();
         }
        
        Out_Of_Office__c duplicateOOO2 = new Out_Of_Office__c (
                                                        Message__c = 'Test',
                                                        //RecordTypeId = RecType1.Id ,
                                                        Active__c  = true ,
                                                       Start_Time__c = Datetime.now()+1,
                                                       End_Time__c = (Datetime.now()+2),
                                                       Delegate_User__c = u.Id
                                                        );
        
        try{
            insert duplicateOOO2 ;     // Duplicate Out of Office Created for Standard User 2 .
         }
        catch(Exception e){
         e.getMessage();
         }
         
        Out_Of_Office__c duplicateOOO3 = new Out_Of_Office__c (
                                                        Message__c = 'Test',
                                                        //RecordTypeId = RecType2.Id ,
                                                        Active__c  = true ,
                                                       Start_Time__c = Datetime.now()+1,
                                                       End_Time__c = (Datetime.now()+2),
                                                       Delegate_User__c = u2.Id
                                                        );
        
        try{
            insert duplicateOOO3 ;
         }
        catch(Exception e){
         e.getMessage();
         }
         
        
        
        Database.SaveResult[] sr = Database.insert(new Out_Of_Office__c[] {duplicateOOO},false);
        
        System.assertEquals(sr[0].isSuccess(), false);
        
        System.runAs(u2)
        {
            FeedItem post = new FeedItem (ParentId = u.Id,
                                          Body = 'test');
            insert post;
            
            post = [select id, (select id, CommentBody from FeedComments) from FeedItem where id = :post.Id];
            //System.assertEquals(post.feedComments[0].CommentBody, 'Test');                            
        }
        
        
    }
}