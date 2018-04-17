/*********************************************************************************/
  // Purpose      : Update the records and owners based on the Sub Type A, Sub TYpe B Sub TYpe C and Sub Type D values.
  // Date created : 04 October, 2016
  // Created by   : UCM Team
  // Author       : Kali 
  // Description  : Update the Bug Team and Owners based on the Combination of the Bug Update Owner and Team values
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class ASICBugUpdateOwnerAndTeam {
    
    public bug__c bugVar;
    public list < Bug_Team__c > bgTeamList;
    public Map<id, id> userMap = new Map<id, id>();

    public string getAlertmessage() 
    {
        string st = BugErrorMessages__c.getValues('ASICOwnerResetConfirm').Error_Message__c;
        return st;
    }

    //Contructor class
    public ASICBugUpdateOwnerAndTeam(ApexPages.StandardController controller) {
        ApexPages.StandardController stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bugvar = [select id,Sub_Type_A__c, Sub_Type_B__c, Sub_Type_C__c, Sub_Type_D__c,Old_SubTypeA_TypeB_TypeC_TypeD__c from bug__c where id = : bugvar.id][0];
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
        list < Bug_Default_Owner_Team__c> cslist = new list < Bug_Default_Owner_Team__c> ();
        bug_team__c bgTeam;
        list < id > userIds = new list < id > ();
        try {
            if(bugVar.Sub_Type_D__c != null ){
                cslist = [select id,Name__c,Bug_Admin__c,Bug_BugTeam__c,Bug_Owners__c,Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c  from Bug_Default_Owner_Team__c where Sub_Type_A__c = : bugVar.Sub_Type_A__c and Sub_Type_B__c = : bugVar.Sub_Type_B__c and Sub_Type_D__c = : bugVar.Sub_Type_D__c and Sub_Type_C__c = : bugVar.Sub_Type_C__c];   
            }
            else if(bugVar.Sub_Type_C__c != null){
                cslist = [select id,Name__c,Bug_Admin__c,Bug_BugTeam__c,Bug_Owners__c,Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c  from Bug_Default_Owner_Team__c where Sub_Type_A__c = : bugVar.Sub_Type_A__c and Sub_Type_B__c = : bugVar.Sub_Type_B__c and Sub_Type_C__c = : bugVar.Sub_Type_C__c];   
            }
            else if(bugVar.Sub_Type_B__c != null){
                cslist = [select id,Name__c,Bug_Admin__c,Bug_BugTeam__c,Bug_Owners__c,Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c  from Bug_Default_Owner_Team__c where Sub_Type_A__c = : bugVar.Sub_Type_A__c and Sub_Type_B__c = : bugVar.Sub_Type_B__c ];   
            }
            else{
                cslist = [select id,Name__c,Bug_Admin__c,Bug_BugTeam__c,Bug_Owners__c,Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c  from Bug_Default_Owner_Team__c where Sub_Type_A__c = : bugVar.Sub_Type_A__c];   
            }
            DeleteOldBugTeamMembers();
            for (bug_team__c b: [select user__c, id from bug_team__c where Bug__c = : bugvar.id]) {
                userMap.put(b.user__c, b.user__c);
            }
            if (cslist.size() > 0) {
    
                if (cslist[0].Bug_Owners__c != null) {
                    if (validateId(cslist[0].Bug_Owners__c) != null) {
                        if (((string) cslist[0].Bug_Owners__c).startsWith('005')) {
                            if ([select id from user where id = : cslist[0].Bug_Owners__c and isactive = true].size() > 0) bugvar.ownerid = cslist[0].Bug_Owners__c;
                        } else {
                            bugvar.ownerid = cslist[0].Bug_Owners__c;
                        }
                    }    
                }
                if (cslist[0].Bug_BugTeam__c != null && cslist[0].Bug_BugTeam__c != '') {
                    for (string st: cslist[0].Bug_BugTeam__c.split(',')) {
                        if (userMap.get(st) == null) if (validateUserId(st) != null) {
                            userIds.add(st);
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
                }
                if (bgTeamList.size() > 0) insert bgTeamList;
            }
            bugvar.Old_SubTypeA_TypeB_TypeC_TypeD__c = bugvar.Sub_Type_A__c + ',' + bugvar.Sub_Type_B__c+ ',' + bugvar.Sub_Type_C__c + ',' + bugvar.Sub_Type_D__c ;
            Database.update(bugvar);
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugUpdateOwnerAndTeam.class.getName();
            alw.sourceFunction = 'ResetOwnerandTeam()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    
     }

    //Method resets the  internal reference field and redirects to detail page.
    public void NoResetOwnerandTeam() { 
        bugvar.Old_SubTypeA_TypeB_TypeC_TypeD__c = bugvar.Sub_Type_A__c + ',' + bugvar.Sub_Type_B__c+ ',' + bugvar.Sub_Type_C__c + ',' + bugvar.Sub_Type_D__c ;
        update bugvar;
    }

    //This method deletes the bug team members previously added for the old product and component values.
    public void DeleteOldBugTeamMembers() {
        list < bug_team__c > bglist = new list < bug_team__c > ();
        list < string > stlist = bugvar.Old_SubTypeA_TypeB_TypeC_TypeD__c.split(',');
        list < Bug_Default_Owner_Team__c > cslistOld = new list < Bug_Default_Owner_Team__c > ();
        cslistOld = [select Bug_Owners__c, Bug_BugTeam__c from Bug_Default_Owner_Team__c where Sub_Type_A__c  = : stlist[0] and Sub_Type_B__c = : stlist[1] and Sub_Type_C__c = : stlist[2] and Sub_Type_D__c     = : stlist[3]];        
        list < id > userIds = new list < id > ();
        if (cslistOld.size() > 0) {
            if (cslistOld[0].Bug_BugTeam__c != null && cslistOld[0].Bug_BugTeam__c != '') {
                for (string st: cslistOld[0].Bug_BugTeam__c.split(','))
                    userIds.add(st);
                bglist = [select id from bug_team__c where user__c in : userIds and Bug__c = : bugvar.id];
                if (bglist.size() > 0) delete bglist;
            }
        }
    }
    public class applicationException extends Exception {}
}