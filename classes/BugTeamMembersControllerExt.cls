/*Author: Cognizant
* Description: This class is controller class BugTeamMembers page. created to show the 
                list of bug team members for a bug with delete option.
* History: 03/07/2014
*/


public class BugTeamMembersControllerExt {
    private Bug__c teamRoom = null;
    private List<Bug_Team__c> lAllTeamMembers = null;
    public List<Bug_Team__c> members {get; private set;}    
    public Integer retrivedRecordCount {get; private set;}
    public Integer totalRecordCount {get; private set;}    
    
    public BugTeamMembersControllerExt (ApexPages.StandardController stdController) {
        this.teamRoom = (Bug__c )stdController.getRecord();
        members = new List<Bug_Team__c>();
        retrivedRecordCount = 0;
        
        // Retrieve all Team Members.
        if (teamRoom != null) {        
            lAllTeamMembers = [SELECT Id, User__c,User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, 
                                    Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c,User_Profile__c,User_Role__c,Bug_Update_Only__c,Chatter_Only__c
                               FROM Bug_Team__c WHERE Bug__c =:teamRoom.id ORDER BY User__r.Name];
    
            if (lAllTeamMembers != null && lAllTeamMembers.size() > 0) {
                totalRecordCount = lAllTeamMembers.size();
                getTeamMembers();
            } else {
                totalRecordCount = 0;
            }
        }
    }
    
    //Returns the bug record
    public Bug__c getTeamRoom() {
        return teamRoom;
    }
    
    //Deletes the bug team member.
    public PageReference deleteMember() {
       PageReference pageRef = ApexPages.currentPage();
       String id = pageRef.getParameters().get('memberId');
       
       List<Bug_Team__c> dlist = [select id from Bug_Team__c where id = :id];
       delete dlist;
       
       if(members != null) {
           List<Bug_Team__c> nmembers = new List<Bug_Team__c>();
           List<Bug_Team__c> lTempRemainingMem = new List<Bug_Team__c>();
           
           for(Bug_Team__c member: members) {
               if(member.Id != id) {
                  nmembers.add(member);
               }
           }
          members = nmembers;
          
          for (Bug_Team__c eachMember: lAllTeamMembers) {
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
    
    
    //Method retrives only 5 teammembers at a time
    public PageReference getTeamMembers() {
       
        if (totalRecordCount - retrivedRecordCount > 5) {
                retrivedRecordCount += 5;
        } else {
            retrivedRecordCount += (totalRecordCount - retrivedRecordCount);
        }
    
        retriveMembersByCount(retrivedRecordCount, false);
        
        return null;
    }

   //Method retrives all the team members for the bug record
    public PageReference getAllTeamMembers() {
        retriveMembersByCount(totalRecordCount, true);
        retrivedRecordCount = totalRecordCount;
        
        return null;
    }
    
    // This method retrieve team members to show on UI.
    private void retriveMembersByCount(Integer recordsToRetrieve, Boolean remainingAll) {
        members = new List<Bug_Team__c>();
        Integer iterator = 0;
       
        
        while(iterator < recordsToRetrieve) {
            Bug_Team__c teamRoomMember = lAllTeamMembers.get(iterator);

            if(teamRoomMember != null && teamRoomMember.Is_Group__c != null && teamRoomMember.Is_Group__c == false) {
                if (members != null) {
                    members.add(teamRoomMember);
                }
            }
            
            iterator ++;
        }
    }
}