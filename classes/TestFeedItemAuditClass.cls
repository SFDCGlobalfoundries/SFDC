/*  Author : Ashwini Dengi
    Description : This test class is used for FeedItemAuditClass batch class.
    Code Creation: 21/11/2014
    */

@isTest
                                
    private class TestFeedItemAuditClass {
        static testmethod void test() {
            User u =[select Name, ID, Firstname,Email,Alias from user where Lastname ='RATHOUR' and Email = 'baijnath.rathour@globalfoundries.com' and Alias ='brath'limit 1];
            ID parentids = u.ID;
            system.runAs(u){
            Blob body=[Select Name, ContentType, Body From StaticResource where name='testchatterfile22'].body;
            Contentversion testcontent= new contentversion();
            testcontent.VersionData = body;
            testcontent.PathOnClient = 'testchatterfile1.txt';
            testcontent.Origin = 'H';
            testcontent.OwnerId = parentids;
            insert testcontent;
            Contentversion testcontent2= new contentversion();
            testcontent2.VersionData = body;
            testcontent2.PathOnClient = 'testchatterfile2.txt';
            testcontent2.Origin = 'H';
            testcontent2.OwnerId = parentids;
            insert testcontent2;
            //List<ContentVersion> cont = [select contentdocumentId,ID from ContentVersion ];
            ID conte = [select contentdocumentId,ID from ContentVersion where ID =: testcontent.ID].contentdocumentId;
            Organization orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId() limit 1];
            ContentDocumentLink a= new ContentDocumentLink();
            a.ContentDocumentId = conte;
            a.LinkedEntityId = orgDetails.ID;
            a.ShareType = 'V';
            a.Visibility = 'AllUsers';
            insert a;
            ContentVersion ab = [select contentdocumentId,ID from ContentVersion where ID =: testcontent2.ID];
            ContentDocumentLink pq= new ContentDocumentLink();
            pq.ContentDocumentId = ab.contentdocumentId;
            pq.LinkedEntityId = orgDetails.ID;
            pq.ShareType = 'V';
            pq.Visibility = 'AllUsers';
            insert pq;
            List<Chatter_Audit_Setting__c> testvalue = new List<Chatter_Audit_Setting__c>();
            Chatter_Audit_Setting__c tests= new Chatter_Audit_Setting__c();
            tests.Exact_Match_Terms__c ='Invoice';
            tests.Name = 'first';
            testvalue.add(tests) ;
            Chatter_Audit_Setting__c testss= new Chatter_Audit_Setting__c();
            testss.Exact_Match_Terms__c ='Purchase Order';
            testss.Name = 'second';
            testvalue.add(testss) ;
            insert testvalue;
            List<Chatter_Audit_Date__c> testdate = new List<Chatter_Audit_Date__c>();
            Chatter_Audit_Date__c testdate1 = new Chatter_Audit_Date__c();
            testdate1.Name = 'first';
            testdate1.Start_Date__c = date.newInstance(2014,10,15);
            testdate.add(testdate1);
            insert testdate;
            CollaborationGroup chattertestgrp = new CollaborationGroup();
            chattertestgrp.Name  = 'GF Chatter Auditorss';
            chattertestgrp.OwnerId = parentids;
            chattertestgrp.CanHaveGuests = false;
            chattertestgrp.CollaborationType = 'Private';
            insert chattertestgrp;
            List<Flagged_File_Post__c> lstExistFlagpostdataa=new List<Flagged_File_Post__c>();
            Flagged_File_Post__c  existflagg = new Flagged_File_Post__c();
            existflagg.Chatter_File_ID__c =  conte;
            existflagg.Chatter_File_Verified__c = false;
            existflagg.Comments__c = 'need to check';
            lstExistFlagpostdataa.add(existflagg);
            insert lstExistFlagpostdataa;
            Test.startTest();
            Id [] fixedSearchResults = new Id[]{testcontent.ID,testcontent2.ID};
            Test.setFixedSearchResults(fixedSearchResults);
            // Schedule the test job
            FeedItemAuditclass abcd = new FeedItemAuditclass();
            Database.executeBatch(abcd);  
            System.schedule('Test1',  '0 0 * * * ?', new scheduleFeedItemAuditclass());
            Test.stopTest();
            }

    }

}