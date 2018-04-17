public class ContractTeamMembersControllerExt {
    private Apttus__APTS_Agreement__c teamRoom = null;
    private List<Contract_Team__c> lAllTeamMembers = null;
    public List<Contract_Team__c> members {get; private set;}    
    public Integer retrivedRecordCount {get; private set;}
    public Integer totalRecordCount {get; private set;}    
    
    public ContractTeamMembersControllerExt(ApexPages.StandardController stdController) {
        this.teamRoom = (Apttus__APTS_Agreement__c )stdController.getRecord();
        members = new List<Contract_Team__c>();
        retrivedRecordCount = 0;
        
        // Retrieve all Contract Team Members.
        if (teamRoom != null) {        
            lAllTeamMembers = [SELECT Id, User__c,User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, 
                                    Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c,User_Profile__c,User_Role__c
                               FROM Contract_Team__c WHERE Agreement__c =:teamRoom.id ORDER BY User__r.Name];
            if (lAllTeamMembers != null && lAllTeamMembers.size() > 0) {
                totalRecordCount = lAllTeamMembers.size();
                getTeamMembers();
            } else {
                totalRecordCount = 0;
            }
        }
    }
    public Apttus__APTS_Agreement__c getTeamRoom() {
        return teamRoom;
    }
    public PageReference deleteMember() {
       PageReference pageRef = ApexPages.currentPage();
       String id = pageRef.getParameters().get('memberId');  
       List<Contract_Team__c> dlist = [select id from Contract_Team__c where id = :id];
       delete dlist;
       if(members != null) {
           List<Contract_Team__c> nmembers = new List<Contract_Team__c>();
           List<Contract_Team__c> lTempRemainingMem = new List<Contract_Team__c>();
           
           for(Contract_Team__c member: members) {
               if(member.Id != id) {
                  nmembers.add(member);
               }
           }
          members = nmembers;
          
          for (Contract_Team__c eachMember: lAllTeamMembers) {
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
       
        if (totalRecordCount - retrivedRecordCount > 5) {
                retrivedRecordCount += 5;
        } else {
            retrivedRecordCount += (totalRecordCount - retrivedRecordCount);
        }
    
        retriveMembersByCount(retrivedRecordCount, false);
        
        return null;
    }
    public PageReference getAllTeamMembers() {
        retriveMembersByCount(totalRecordCount, true);
        retrivedRecordCount = totalRecordCount;
           
        return null;
    }
    
    // This method retrieve team members to show on UI.
    private void retriveMembersByCount(Integer recordsToRetrieve, Boolean remainingAll) {
        members = new List<Contract_Team__c>();
        Integer iterator = 0;
            
        while(iterator < recordsToRetrieve) {
            Contract_Team__c teamRoomMember = lAllTeamMembers.get(iterator);

            if(teamRoomMember != null && teamRoomMember.Is_Group__c != null && teamRoomMember.Is_Group__c == false) {
                if (members != null) {
                    members.add(teamRoomMember);
                }
            }
            
            iterator ++;
        }
    }
}