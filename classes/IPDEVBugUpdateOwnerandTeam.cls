/*Author: UCM Team
* Description: This class is developed to reset the owner and bug team on component change. 
The reset is done on user confirmation.

Created on : Sep 22, 2017
*/
public class IPDEVBugUpdateOwnerandTeam {
    public bug__c bugVar;
    public list < Bug_Team__c > bgTeamList;
    public Map<id, id> userMap = new Map<id, id>();

    public string getAlertmessage()
    {
        string st = BugErrorMessages__c.getValues('IPDEVOwnerResetConfirm').Error_Message__c;
        return st;
    }

    //Contructor class
    public IPDEVBugUpdateOwnerandTeam(ApexPages.StandardController controller) {
        ApexPages.StandardController stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bugvar = [select id, IPDEV_Component__c, Old_IPDEV_Component__c from bug__c where id = : bugvar.id][0];
        bgTeamList = new list < Bug_Team__c > ();
    }
    
    //This method is used for validating Users Ids and GroupId
    public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005'))||(id.startsWith('00G')))) {
            return id;
        }
        return null;
    }
    
     //This method is used for validating Users Ids
     public String validateUserId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005')))) {
            return id;
        }
        return null;
     }

    //Method resets the owner, bugteam internal reference field and redirects to detail page.
   public void ResetOwnerandTeam() {
        Map <Id,Boolean> userVsBugUpdateChk = new Map <Id,Boolean>();
        Map <Id,Boolean> userVsChatterUpdateChk = new Map <Id,Boolean>();
        list <IPDEVforDefaultOwnerandTeam__c> cslist = new list <IPDEVforDefaultOwnerandTeam__c> ();
        bug_team__c bgTeam;
        list < id > userIds = new list < id > ();
        try {
            cslist = [select Bug_Owner__c, Bug_BugTeam__c from IPDEVforDefaultOwnerandTeam__c where
            IPDEV_Component__c = : bugVar.IPDEV_Component__c];
            
            DeleteOldBugTeamMembers();
            for (bug_team__c b: [select user__c, id from bug_team__c where Bug__c = : bugvar.id]) {
                userMap.put(b.user__c, b.user__c);
            }
            if (cslist.size() > 0) {
    
                if (cslist[0].Bug_Owner__c != null && cslist[0].Bug_Owner__c != '') {
                    if (validateId(cslist[0].Bug_Owner__c) != null) {
                        if (((string) cslist[0].Bug_Owner__c).startsWith('005')) {
                            if ([select id from user where id = : cslist[0].Bug_Owner__c and isactive = true].size() > 0) bugvar.ownerid = cslist[0].Bug_Owner__c;
                        } else {
                            bugvar.ownerid = cslist[0].Bug_Owner__c;
                        }
                    }    
                }
                if (cslist[0].Bug_BugTeam__c != null && cslist[0].Bug_BugTeam__c != '') {
                    for (string st: cslist[0].Bug_BugTeam__c.split(',')) {
                        if (userMap.get(st) == null) if (validateUserId(st) != null) {
                            userIds.add(st);
                        }
                    }
                }
                
                List<Manage_Email_Notification__c> manageEmailNotification = new  List<Manage_Email_Notification__c>();
                manageEmailNotification = [select User__c,Chatter_Only__c,Bug_Update_Only__c from Manage_Email_Notification__c where User__c IN: userIds];
                for(Manage_Email_Notification__c  manageEmail : manageEmailNotification ){
                    userVsBugUpdateChk.put(manageEmail.User__c,manageEmail.Bug_Update_Only__c);
                    userVsChatterUpdateChk.put(manageEmail.User__c,manageEmail.Chatter_Only__c);
                }                    
                for (user u: [select id from user where id in : userIDs and isactive = true]) {
                    bgTeam = new bug_team__c();
                    bgTeam.Bug__c = bugvar.id;
                    if (!userVsBugUpdateChk.containsKey(u.id)) {
                        bgTeam.Bug_Update_Only__c = true;
                    }
                    else if(userVsBugUpdateChk.get(u.id) == true){
                        bgTeam.Bug_Update_Only__c = true;
                    }
                    else{
                        bgTeam.Bug_Update_Only__c = false;
                    }
                    if (!userVsChatterUpdateChk.containsKey(u.id)) {
                        bgTeam.Chatter_Only__c = true;
                    }
                    else if(userVsChatterUpdateChk.get(u.id) == true){
                        bgTeam.Chatter_Only__c = true;
                    }
                    else{
                        bgTeam.Chatter_Only__c = false;
                    }                         
                    bgTeam.user__c = u.id;
                    bgTeam.Access__c = 'Read/Write';
                    bgTeamList.add(bgTeam);
                }
            if (bgTeamList.size() > 0) insert bgTeamList;
            }
            bugvar.Old_IPDEV_Component__c = bugvar.IPDEV_Component__c;
            update bugvar;
        } catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
    
     }

    //Method resets the  internal reference field and redirects to detail page.
    public void NoResetOwnerandTeam() {
        bugvar.Old_IPDEV_Component__c = bugvar.IPDEV_Component__c;
        update bugvar;
    }

    //This method deletes the bug team members previously added for the old product and component values.
    public void DeleteOldBugTeamMembers() {
        list < bug_team__c > bglist = new list < bug_team__c > ();
        String stlist = bugvar.Old_IPDEV_Component__c;
        list < IPDEVforDefaultOwnerandTeam__c > cslistOld = new list < IPDEVforDefaultOwnerandTeam__c > ();
        cslistOld = [select Bug_Owner__c, Bug_BugTeam__c from IPDEVforDefaultOwnerandTeam__c where
            IPDEV_Component__c = : stlist
        ];        
        list < id > userIds = new list < id > ();
        if (cslistOld.size() > 0) {
            if (cslistOld[0].Bug_BugTeam__c != null && cslistOld[0].Bug_BugTeam__c != '') {
                for (string st: cslistOld[0].Bug_BugTeam__c.split(',')) {
                    userIds.add(st);
                }
            }
            bglist = [select id from bug_team__c where user__c in : userIds and Bug__c = : bugvar.id];
            if (bglist.size() > 0)
            delete bglist;
        }
    }
}