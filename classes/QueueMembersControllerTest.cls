/*
Type Name: QueueMembersControllerTest 
Author: Cognizant Case Management Team
Created Date: 23/03/2015
Reason: This is the Test class for QueueMembersController class. 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
public class QueueMembersControllerTest {
 
    static testMethod void queueMembersSearchTestMethod() {
    
        /* ************ QueueMembersController Start************** */
        
            Test.startTest();
            List< Group > listG = new  List< Group>();    
            List< GroupMember > listGM = new  List< GroupMember >();  
                               
            Group g1 = new Group(Name='Test group name', type='Queue');
            listG.add(g1);
            Group g2 = new Group(Name='Test public group');
            listG.add(g2);
            
            insert listG;  
            
            GroupMember gm1 = new GroupMember(GroupId=g1.Id , UserOrGroupId=UserInfo.getUserId());
            listGM.add(gm1);            
            GroupMember gm2 = new GroupMember(GroupId=g1.Id , UserOrGroupId=g2.Id);
            listGM.add(gm2);            
            GroupMember gm3 = new GroupMember(GroupId=g2.Id , UserOrGroupId=UserInfo.getUserId());
            listGM.add(gm3);
            
            insert listGM;
            
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            
            System.runAs ( thisUser ) {
                insert q1;
            }
            
            // For QueueMembers Search (Internal Users.)
                
            PageReference ref3 = new PageReference('/apex/QueueMembers');
            Test.setCurrentPage(ref3);
            QueueMembersController c = new QueueMembersController();
            ApexPages.currentPage().getParameters().put('fullname', 'User');
            ApexPages.currentPage().getParameters().put('objectName', 'Case');
            ApexPages.currentPage().getParameters().put('queueId', g1.Id);

            c.fullname = 'User';
            c.objectName = 'Case';
            c.queueId = g1.Id;
            c.refresh();
            c.searchUser();
            c.getQueueOptions();
            
            // New Page 
            
            PageReference ref4 = new PageReference('/apex/QueueMembers');
            Test.setCurrentPage(ref4);
            QueueMembersController cl = new QueueMembersController();
            ApexPages.currentPage().getParameters().put('queueId', g1.Id);
            ApexPages.currentPage().getParameters().put('objectName', 'Case');
            QueueMembersController.GetUserIdsFromGroup(g1.Id);
            cl.getQueueOptions();
            cl.queueId = g1.Id;
            cl.objectName = 'Case';
            cl.refresh();
            cl.searchUser();
            cl.getqueueMembers();
            /* ************ QueueMembersController End************** */
            
            Test.stopTest();
        }

}