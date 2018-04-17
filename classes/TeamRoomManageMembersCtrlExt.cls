/**
* Author: Nino Bustillos
* Description: This class serves as ManageMembers Controller.
* History:
*     Nbustillos     02202013       Code Creation.
*     BMukhija       06032013       Fix for Multiple Member addtition, Blank Placeholders
                                    Duplicate User addition revoke.
**/
public class TeamRoomManageMembersCtrlExt {

    public TeamRoomManageMembersCtrlExt() {
         String id = apexpages.currentpage().getparameters().get('id');
         List<Team_Room__c> trList = [select Id, Name, Team_Room_Description__c, OwnerId from Team_Room__c where id = :id];
         
         if(trList.size() > 0) {
            TeamRoom = trList.get(0);
         }
         
         if(TeamRoom != null) {
            TeamRoomName = TeamRoom.name;
            Map<String,Team_Room_Member__c> groupMap = new Map<String,Team_Room_Member__c>();
            List<Team_Room_Member__c> currMembers = null;
            List<Team_Room_Member__c> sortedMembers = new List<Team_Room_Member__c>();
            currMembers = [SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c 
                           FROM Team_Room_Member__c WHERE Team_Room__c = :TeamRoom.id ORDER BY User__r.Name];

            sTeamMember = new Set<String>();

            Team_Room_Member__c mbr = new Team_Room_Member__c(Team_Room__c = TeamRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null);            
            
            for(Team_Room_Member__c member: currMembers) {
                sTeamMember.add(member.User__c);
                
                if(member.Is_Group__c == null) {
                   member.Is_Group__c = false;
                }else if(member.Is_Group__c == true) {
                    groupMap.put(member.Group_ID__c, member);
                } /* Commented for Defect# D-00001
                if(member.Is_Group__c == false) {
                   sortedMembers.add(member);
                }*/
            }

            // Defect# D-00001-C: Placeholders (5) for new Users.
            for (Integer iterator = 0; iterator < TeamRoomConstants.COUNT_ADD_TEAM_MEMBERS; iterator++) {
                currMembers.add(new Team_Room_Member__c(Team_Room__c = TeamRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null));
            }
            
            //QUERY GROUPS
            Groups = [select Id,Type,Name from Group where Type = 'Regular'];
            for(Group g:Groups)
            {
               mbr = groupMap.get(g.Id);
               if(mbr == null)
               {
                   mbr = new Team_Room_Member__c(Team_Room__c = TeamRoom.id, Access__c = null,Group_Selected__c = false, Group_ID__c = g.Id, Is_Group__c = true, Group_Name__c = g.Name);
                   
               }else
               {
                   mbr.Group_Selected__c = true;
                   mbr.Is_Group__c = true;
                   mbr.Group_Name__c = g.Name;
                   mbr.Group_ID__c = g.Id;
               }
               
               sortedMembers.add(mbr);
            }

             // Defect#D-00001-A: Multiple users addition.
            // Members = sortedMembers
            Members = currMembers;
         }
    }

    public Team_Room__c TeamRoom{get;set;}
    public List<Team_Room_Member__c> Members{get;set;}
    public List<Group> Groups{get;set;}    
    public String TeamRoomName{get;set;}
    // Defect 00001B - Fix for Duplicate Memebers addition.    
    public Set<String> sTeamMember {get; set;}

    public PageReference addNewRow() {
       Team_Room_Member__c newMember = new Team_Room_Member__c();
       if(TeamRoom != null) {
           newMember.Team_Room__c = TeamRoom.id;
       }
       
       Members.add(newMember);
       return null;
    }
    
    // This method deletes Team Member
    public PageReference deleteMember() {
        PageReference pageReference = ApexPages.currentPage();
        String memberId = pageReference.getParameters().get('memberId');
        
        List<String> lDeletedUserIds = new List<String>();
        List<Team_Room_Member__c> lDeleteMember = [SELECT Id, User__c FROM Team_Room_Member__c WHERE Id =: memberId];
        
        Integer iterator = 0;
        while (iterator < Members.size()) {
            if (Members.get(iterator).Id == memberId) {
                lDeletedUserIds.add(Members.get(iterator).User__c);            
                Members.remove(iterator);
            } else {
                iterator++;
            }
        }
        
        sTeamMember.removeAll(lDeletedUserIds);
        
        delete lDeleteMember;
        
        return null;
    }
    
    public PageReference Save() {
        
       try {
            List<Id> newMembers = new List<Id>();
            PageReference trPage = null;
            
            if(TeamRoom != null) {
               trPage = new PageReference('/'+TeamRoom.Id);
            }
            
            List<Team_Room_Member__c> umembers = new List<Team_Room_Member__c>();
            List<Team_Room_Member__c> dmembers = new List<Team_Room_Member__c>();
            Set<String> sTeamRoomCheck = new Set<String>();
            
            sTeamRoomCheck.addAll(sTeamMember);
            
            // Defect 00001B - Fix for Duplicate Memebers addition.
            for(Team_Room_Member__c member: Members) { 
                // User Team Members only
                if(!member.Is_Group__c) {
                    // Data Validation for Newly added Team Members (Users).
                    if (member.User__c != null && member.Access__c == null) {
                        member.addError('Please Specify Access for New Team Members');
                        return null;
                    } else if (member.User__c == null && member.Access__c != null) {
                        member.addError('Please Specify User');
                        return null;
                    } else if (member.User__c != null && member.Access__c != null) {
                        // Check if users are newly added.
                        String strId = member.Id;
                        if (strId != null && strId.length() > 0) {
                            umembers.add(member);
                        } else {
                            Boolean addResult = sTeamRoomCheck.add(member.User__c);
                            if (!addResult) {
                                member.addError('A user can only be added once.');
                                return null;
                            } else {
                                newMembers.add(member.User__c);
                                umembers.add(member);
                            }
                        }
                  }
               }
            }
            
            for(Team_Room_Member__c member :Members)
            {
                if(member.Is_Group__c == false)
                {
                   continue;
                }
                if(member.Group_ID__c == null)
                {
                   continue;
                }
                
                
                if (member.Access__c == null )
                {
                   member.addError('Please specify Access for New Group Members');
                   return null;
                }
                
                if(member.Group_Selected__c == true)
                {
                    //umembers.add(member);       
                }else
                {
                    if(member.Id != null) {
                       dmembers.add(member);
                    }
                }
            }
            upsert umembers;
            delete dmembers;
            
            // Defect 00001B - Fix for Sending out eMail.
            TeamRoomHelper.sendEmailToTeamMembers(newMembers, TeamRoom);            
            
            return trPage;
        } catch (Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0));  
           ApexPages.addMessage(myMsg);
           
           return null;
        }
    }
}