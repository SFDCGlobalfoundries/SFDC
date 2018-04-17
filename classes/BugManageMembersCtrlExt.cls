/*Author: Cognizant
 * Description: This class is created to add, edit and delete bug team members.
 * History: Created on 3/7/2014
 */

public class BugManageMembersCtrlExt {
    public Bug__c BugRoom {
        get;
        set;
    }
    public List < Bug_Team__c > Members {
        get;
        set;
    }
    public List < Group > Groups {
        get;
        set;
    }
    public String BugRoomName {
        get;
        set;
    }
    public Set < String > sTeamMember {
        get;
        set;
    }

    public BugManageMembersCtrlExt() {
        String id = apexpages.currentpage().getparameters().get('id');
        List < Bug__c > bugList = [select Id, Name, Status__c, Bug_Description__c, OwnerId from Bug__c where id = : id];
        if (bugList.size() > 0) {
            BugRoom = bugList.get(0);
        }

        if (bugList != null) {
            BugRoomName = BugRoom.Name;
            Map < String, Bug_Team__c > groupMap = new Map < String, Bug_Team__c > ();
            List < Bug_Team__c > currMembers = null;
            List < Bug_Team__c > sortedMembers = new List < Bug_Team__c > ();
            currMembers = [SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c, Chatter_Only__c, Bug_Update_Only__c
            FROM Bug_Team__c WHERE Bug__c = : BugRoom.id ORDER BY User__r.Name];

            sTeamMember = new Set < String > ();
            Bug_Team__c mbr = new Bug_Team__c(Bug__c = BugRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null, Chatter_Only__c = true, Bug_Update_Only__c = true);
            for (Bug_Team__c member: currMembers) {
                sTeamMember.add(member.User__c);

                if (member.Is_Group__c == null) {
                    member.Is_Group__c = false;
                } else if (member.Is_Group__c == true) {
                    groupMap.put(member.Group_ID__c, member);
                }
            }

            for (Integer iterator = 0; iterator < 5; iterator++) {
                //currMembers.add(new Bug_Team__c(Bug__c = BugRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null));
                currMembers.add(new Bug_Team__c(Bug__c = BugRoom.id,Is_Group__c = false,Access__c = 'Read/Write', Group_Name__c = null));
            }

            Members = currMembers;
        }
    }

    //Method adds new bug team member.
    public PageReference addNewRow() {
        try {
            Bug_Team__c newMember = new Bug_Team__c();
            if (BugRoom != null) {
                newMember.Bug__c = BugRoom.id;
                newMember.Chatter_Only__c = true;
                newMember.Bug_Update_Only__c = true;
                newMember.Access__c = 'Read/Write';
            }

            Members.add(newMember);
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return null;
    }

    // This method deletes Bug Member
    public PageReference deleteMember() {
        try {
            PageReference pageReference = ApexPages.currentPage();
            String memberId = pageReference.getParameters().get('memberId');
            List < String > lDeletedUserIds = new List < String > ();
            List < Bug_Team__c > lDeleteMember = [SELECT Id, User__c FROM Bug_Team__c WHERE Id = : memberId];
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
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return null;
    }

    // Saves the udpated bug team members
    public PageReference Save() {
        try {
            List < Id > newMembers = new List < Id > ();
            PageReference trPage = null;
            if (BugRoom != null) {
                trPage = new PageReference('/' + BugRoom.Id);
            }

            List < Bug_Team__c > umembers = new List < Bug_Team__c > ();
            List < Bug_Team__c > dmembers = new List < Bug_Team__c > ();
            Set < String > sTeamRoomCheck = new Set < String > ();
            sTeamRoomCheck.addAll(sTeamMember);

            for (Bug_Team__c member: Members) {
                // User Team Members only
                if (!member.Is_Group__c) {
                    // Data Validation for Newly added Team Members (Users).                            
                    /*if (member.User__c != null && member.Access__c == null) {
                        member.addError('Please Specify Access for New Team Members');
                        return null;
                    } else if (member.User__c == null && member.Access__c != null) {
                        member.addError('Please Specify User');
                        return null;
                    } else if (member.User__c != null && member.Access__c != null) {*/
                    //} else 
                    if (member.User__c != null ) {
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
            upsert umembers;
            delete dmembers;
            return trPage;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));

            return null;
        }
    }
}