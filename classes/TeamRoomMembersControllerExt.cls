public class TeamRoomMembersControllerExt {
    private Team_Room__c teamRoom = null;
    private List<Team_Room_Member__c> lAllTeamMembers = null;

    public List<Team_Room_Member__c> members {get; private set;}    
    public Integer retrivedRecordCount {get; private set;}
    public Integer totalRecordCount {get; private set;}    
    
    public TeamRoomMembersControllerExt(ApexPages.StandardController stdController) {
        this.teamRoom = (Team_Room__c)stdController.getRecord();
        members = new List<Team_Room_Member__c>();
        retrivedRecordCount = 0;
        
        // Retrieve all Team Members.
        if (teamRoom != null) {        
            lAllTeamMembers = [SELECT Id, User__c,User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, 
                                    Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c,Profile__c,Role__c
                               FROM Team_Room_Member__c WHERE Team_Room__c =:teamRoom.id ORDER BY User__r.Name];
    
            //System.debug('@@@@@@@@@@@@@@@@@@'+lAllTeamMembers.size() +'@@@'+  lAllTeamMembers );
            if (lAllTeamMembers != null && lAllTeamMembers.size() > 0) {
                totalRecordCount = lAllTeamMembers.size();
                getTeamMembers();
            } else {
                totalRecordCount = 0;
            }
        }
    }
    
    public Team_Room__c getTeamRoom() {
        return teamRoom;
    }
    
    public PageReference deleteMember() {
       PageReference pageRef = ApexPages.currentPage();
       String id = pageRef.getParameters().get('memberId');
       
       List<Team_Room_Member__c> dlist = [select id from Team_Room_Member__c where id = :id];
       delete dlist;
       
       if(members != null) {
           List<Team_Room_Member__c> nmembers = new List<Team_Room_Member__c>();
           List<Team_Room_Member__c> lTempRemainingMem = new List<Team_Room_Member__c>();
           
           for(Team_Room_Member__c member: members) {
               if(member.Id != id) {
                  nmembers.add(member);
               }
           }
          members = nmembers;
          
          for (Team_Room_Member__c eachMember: lAllTeamMembers) {
              if (eachMember.Id != id) {
                  lTempRemainingMem.add(eachMember);
              }
          }
          
          lAllTeamMembers = lTempRemainingMem;
          
          totalRecordCount = lAllTeamMembers.size();
          retrivedRecordCount = members.size();
       }
        return null;
    }  

    public PageReference getTeamMembers() {
        // Setup retrived record count.
        if (totalRecordCount - retrivedRecordCount > TeamRoomConstants.TEAM_ROOM_MEMBER_COUNT_TO_ADD) {
            retrivedRecordCount += TeamRoomConstants.TEAM_ROOM_MEMBER_COUNT_TO_ADD;
        } else {
            retrivedRecordCount += (totalRecordCount - retrivedRecordCount);
        }
    
        retriveMembersByCount(retrivedRecordCount, false);
        
        return null;
    }

    // This method take care for Show All records Functionality
    public PageReference getAllTeamMembers() {
        retriveMembersByCount(totalRecordCount, true);
        retrivedRecordCount = totalRecordCount;
        
        return null;
    }
    
    // This method retrieve team members to show on UI.
    private void retriveMembersByCount(Integer recordsToRetrieve, Boolean remainingAll) {
        members = new List<Team_Room_Member__c>();
        Integer iterator = 0;
        /*if (!remainingAll) {
            if (Math.mod(recordsToRetrieve, 5) != 0) {
                iterator = recordsToRetrieve - Math.mod(retrivedRecordCount, 5);
            } else {
                iterator = recordsToRetrieve - 5;
            }
        } else {
            iterator = retrivedRecordCount;
        }*/
        
        while(iterator < recordsToRetrieve) {
            Team_Room_Member__c teamRoomMember = lAllTeamMembers.get(iterator);

            if(teamRoomMember != null && teamRoomMember.Is_Group__c != null && teamRoomMember.Is_Group__c == false) {
                if (members != null) {
                    members.add(teamRoomMember);
                }
            }
            
            iterator ++;
        }
    }
}