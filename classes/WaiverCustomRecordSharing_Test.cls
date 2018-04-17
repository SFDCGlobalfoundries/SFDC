/*
  @Author :-Mohan Gandhapu 
  @Details :- Test Class for WaiverCustomRecordSharing
  @History :- Mohan Gandhapu 11 Jan 2017
 */
 
@IsTest
Public Class WaiverCustomRecordSharing_Test
{
  
  public Static Boolean isSuccess = True;
  Public static testMethod void shareRecordTest()
  {
    Test.StartTest();
    List<Group > QueueLsit = New List<Group>();
    List<GroupMember > GroupMemberLsit = New List<GroupMember >();
    Set<ID> QueueMemberID = new Set<ID>();
    set<Id> managerIds = new  set<ID>();
    set<Id> DelegdateUserIDs = new Set<ID>();
    
    User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    System.runAs (thisUser) {
     
    List<User> users = [SELECT Id,DelegatedApproverid,ManagerID,Manager.DelegatedApproverid FROM User WHERE IsActive = true and Manager.DelegatedApproverid <> Null LIMIT 3];
      Id User1Id = users[0].Id;
      Id User2Id = users[1].Id;
      Id User3Id = users[2].Id;
      
      for(User usId: users)
      {
       managerIds.add(usId.ManagerID); 
       DelegdateUserIDs.add(usID.Manager.DelegatedApproverid );     
      }  
    
    Group grp1 = new Group(Name = 'Collaborator 4 DE',Type='Queue');
    QueueLsit.Add(grp1);
    
    Group grp2 = new Group(Name = 'Collaborator PI/YE 4 FAB7',Type='Queue');
    QueueLsit.Add(grp2);
    
    Group grp3 = new Group(Name = 'Collaborator QA 4 FAB7',Type='Queue');
    QueueLsit.Add(grp3);
    
    Insert QueueLsit;
        
    GroupMember GM1 = New GroupMember(UserOrGroupId = User1Id ,GroupId =grp1.ID);
    GroupMemberLsit.Add(GM1);
    
    GroupMember GM2 = New GroupMember(UserOrGroupId = User2Id ,GroupId =grp2.ID);
    GroupMemberLsit.Add(GM2);
    
    GroupMember GM3 = New GroupMember(UserOrGroupId = User3Id ,GroupId =grp3.ID);
    GroupMemberLsit.Add(GM3);
    
    Insert GroupMemberLsit;
        
    for(GroupMember gm:GroupMemberLsit)
    {
    QueueMemberID.add(gm.UserOrGroupId ); 
    }
    
     Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
               
    Wavier_Collaborator__Share waiverShare = new Wavier_Collaborator__Share();
                    waiverShare.ParentId = waiverColl.id;
                    waiverShare.UserOrGroupId = User2Id ;
                    waiverShare.AccessLevel = 'Edit';
        Try{      
        string WCId = waiverColl.id;
        WaiverCustomRecordSharing.shareRecord(waiverColl.id, WCId);      
        Insert waiverShare;
        }catch (Exception e){          
           
             //System.assertEquals(e.getMessage(), e.getMessage());
			                     
          }  
    }    
  Test.StopTest();
  }
}