/*********************************************************************************/
  // Purpose      : Sending emails to the users when bug record has been created.
  // Date created : 07 October, 2016
  // Created by   : UCM Team
  // Author       : Kali 
  // Description  : Sending emails to the users when bug record has been created or updated
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class ASICBugEmailTemplateHandler { 
    
    
    public static final string strOrgId = UserInfo.getOrganizationId();    
    public static final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id
    public static string htmlBody;      
    public static  Map<Id,Account> actMap{get;set;}
    public static  Map<Id,User> userMap{get;set;}
    public static Map<id,Bug__c> idModifiedByMap {get;set;}
    public static final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;    
    public static String stTargetId = [SELECT Id FROM Contact WHERE Email = 'noreply@salesforce.com' LIMIT 1].id;
    // Send email to the Owner and Bug Teams on creation of the bug record.
    public static Map<String, Set<String>> bugTeamMapCreation(List<Bug__c> listBugs, Boolean isAddCreator){
     Map<String, Set<String>> bugTeamMap  =   new Map<String, Set<String>>();
     
        try{          
           // Map<String, Set<String>>  mapBugAndTeam   =   new Map<String, Set<String>>();             
            List<Bug_Team__c> listBugTeams            =   new List<Bug_Team__c>();
            listBugTeams    =   [SELECT Id, Bug__r.CreatedBy.Email,Bug__r.Assigned_To__r.Email, CreatedBy.Email, User__c, User__r.Email, Bug__r.Owner.Email FROM Bug_Team__c WHERE Bug__c IN :listBugs];
            Set<String> userIds ;
            for(Bug_Team__c objBugTeam : listBugTeams){
                if(bugTeamMap.containsKey(objBugTeam.Bug__c)){
                    bugTeamMap.get(objBugTeam.Bug__c).add(objBugTeam.User__r.Email);
                    
                }else{
                    bugTeamMap.put(objBugTeam.Bug__c, new Set<String>{objBugTeam.User__r.Email});
                    bugTeamMap.get(objBugTeam.Bug__c).add(objBugTeam.Bug__r.Owner.Email);
                    if(objBugTeam.Bug__r.Assigned_To__r.email != null && objBugTeam.Bug__r.Assigned_To__r.email != '')
                        bugTeamMap.get(objBugTeam.Bug__c).add(objBugTeam.Bug__r.Assigned_To__r.Email);
                    if(isAddCreator){
                        bugTeamMap.get(objBugTeam.Bug__c).add(objBugTeam.Bug__r.CreatedBy.Email);                       
                    }
                }
            }
            if(listBugTeams.size()==0){
                List<Bug__c> listFBugs = new List<Bug__c>();
                listFBugs = [SELECT Id, CreatedBy.Email, Owner.Email,Assigned_To__r.Email FROM Bug__c WHERE Id IN :listBugs];
                for(Bug__c objBug : listFBugs){
                    if(bugTeamMap.containsKey(objBug.Id)){
                        bugTeamMap.get(objBug.Id).add(objBug.Owner.Email);
                        
                    }else{
                        bugTeamMap.put(objBug.Id, new Set<String>{objBug.Owner.Email});
                        if(objBug.Assigned_To__r.email != null && objBug.Assigned_To__r.email != '')
                                bugTeamMap.get(objBug.id).add(objBug.Assigned_To__r.Email);
                        if(isAddCreator){
                            bugTeamMap.get(objBug.Id).add(objBug.CreatedBy.Email);                      
                        }
                    }
                }
            }                                                                   
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
           
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugEmailTemplateHandler.class.getName();
            alw.sourceFunction = 'sendEmailOnBugCreation()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            
        }
        return bugTeamMap ; 
    }
    
    public static void sendEmailOnBugCreation(List<Bug__c> listBugs, Boolean isAddCreator){ 
      Map<String, Set<String>> mapBugAndTeam  =   new Map<String, Set<String>>(); 
       mapBugAndTeam = bugTeamMapCreation(listBugs,isAddCreator);
        if(mapBugAndTeam.size()>0){
                sendEmailGeneric(mapBugAndTeam, false);
            }   
    }
    
    public static void sendEmailToAssignedToOwner(List<Bug__c> listBugs, Map<Id, Bug__c> oldBugs){
        List<Bug__c> requiredBugs   =    new List<Bug__c>();
        Set<Id> recIds   =   new Set<Id>();
        
        for(Bug__c objBug : listBugs){
            if(objBug.get('Assigned_To__c') != oldBugs.get(objBug.Id).get('Assigned_To__c')) { 
              recIds.add(objBug.Id);
            }
        }
        if(recIds.size()>0){
            requiredBugs    =   [SELECT Id, Assigned_To__r.Email, CreatedBy.Email FROM Bug__c WHERE Id IN :recIds];
            Map<String, Set<String>>  mapBugAndTeam   =   new Map<String, Set<String>>();
            for(Bug__c objBug : requiredBugs){
                mapBugAndTeam.put(objBug.Id, new Set<String>{objBug.Assigned_To__r.Email});
                mapBugAndTeam.get(objBug.Id).add(objBug.CreatedBy.Email);
            }
            if(mapBugAndTeam.size()>0){
                sendEmailGeneric(mapBugAndTeam, false);
            }
        }
    }
    
    // Send Email on Every field Change.
    public static void sendEmailOnEveryFieldChange(Map<Id, Bug__c> bugmapnew, List<Bug__c> buglistOld ){
        try{       
           BugTriggerHandler bugtriggerhandlerVar = new BugTriggerHandler();
           Map<String, Set<String>> bugTeamMap  =   new Map<String, Set<String>>(); 
            List<String> toAddress = new List<String>();           
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];            
            list < Messaging.SingleEmailMessage > emailList = new list < Messaging.SingleEmailMessage > ();  
            Set<Id> recIds =   new Set<Id>(); 
            Set<Id> recId =   new Set<Id>();            
            String actName ='Empty';
            String usrName ='Empty';
            string lastModifiedName = 'Empty';
            bugTeamMap  =   bugTeamMapCreation(buglistOld, true);
            idModifiedByMap  = new Map<id,Bug__c>([select id,LastModifiedBy.Name from bug__c where id in:bugmapnew.keySet()]);       
            //sendEmailOnBugCreation(buglistOld, true);
            for(Bug__c objBug :buglistOld ){
                        
                recIds.add(objBug.Account_Affected__c);          
            }
            for(Bug__c objBug :buglistOld ){            
                recId.add(objBug.Assigned_To__c);  
                recId.add(objBug.CreatedById);         
            }
            if(recIds.size()>0){         
               actMap = new Map<Id,Account>([select id,name from account where id in:recIds]);             
             }
            if(recId.size()>0){         
               userMap = new Map<Id,User>([select id,name from user where id in:recId]);             
             }
            for (bug__c bugTemp: buglistOld){                    
                    if(bugTemp.Account_Affected__c != null){
                            Account act =  actMap.get(bugTemp.Account_Affected__c);
                            actName  = act.name;
                    }
                                       
                    if(bugTemp.Assigned_To__c != null  ){
                            User assignedUsr =  userMap.get(bugTemp.Assigned_To__c); 
                            usrName  =   assignedUsr.name;             
                    } 
                                                                         
                    User crtdUsr =  userMap.get(bugTemp.CreatedById);                                               
                    if(bugTeamMap.size()>0){
                            toAddress.addAll(bugTeamMap.get(bugTemp.id));
                    }                    
                   bug__c bugTempNew = bugmapnew.get(bugTemp.id);
                   bug__c bugtemp2 =  idModifiedByMap.get(bugTempNew.id); 
                   lastModifiedName = bugtemp2.LastModifiedBy.Name ;      
                    String bugTempId = bugTemp.id;
                    String bug15DigitId = bugTempId.substring(0, 15);
                    string strValue = bugtriggerhandlerVar.GetOldNewValue(bugTemp, bugTempNew);                    
                    if(strValue !=null && strValue !=''){
                         htmlBody = '<table><tr><td>' +
                        '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                        '<tr><td>Dear User/Team,  <br><br></td></tr>' +
                        '<tr><td> The following problem has been changed in the ASIC Management System, please take necessary action on this bug. <br> <br></td></tr>'+
                        '<tr><td> Bug '+'<b>'+ bugTemp.name + '</b>' +'  has been updated by  ' + '<b>' + lastModifiedName + '</b>' + '  recently. '+ '<br><br></td></tr>' +
                        '<tr><td> Bug Title: '+ bugTemp.Bug_Title__c + ' <br></td></tr>' +
                        '<tr><td> Submitter: '+ crtdUsr.name + ' <br></td></tr>' +
                        '<tr><td> Assigned To: '+ usrName   + ' <br></td></tr>' +
                        '<tr><td> Severity: '+ bugTemp.Severity__c + ' <br></td></tr>' +
                        '<tr><td> Owner: '+ bugTemp.OwnerFullName__c + ' <br></td></tr>' +
                        '<tr><td> Status: '+ bugTemp.Status__c + ' <br></td></tr>' +
                        '<tr><td> Customer: '+ actName  + ' <br></td></tr>' +
                        '<tr><td> Development Only: '+ bugTemp.Dev_Only__c + ' <br></td></tr>' +
                        '<tr><td> Problem Classification: '+ bugTemp.Problem_Class__c + ' <br></td></tr>' +
                        '<tr><td> Problem Type: '+ bugTemp.Problem_Type__c + ' <br></td></tr>' +
                        '<tr><td> SubType A: '+ bugTemp.Sub_Type_A__c + ' <br></td></tr>' +
                        '<tr><td> SubType B: '+ bugTemp.Sub_Type_B__c + ' <br></td></tr>' +
                        '<tr><td> Technology: '+ bugTemp.Technology__c + ' <br></td></tr>' +
                        '<tr><td> Date Needed: '+ bugTemp.Need_By_Date__c + ' <br></td></tr>' +
                        '<tr><td> Bug Description: '+ bugTemp.Bug_Description__c + ' <br><br></td></tr>' +
                        '<tr><td> Please refer to the following link for accessing the Bug: <br></td></tr>' +
                        '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bug15DigitId + '</td></tr><br><br>' + 
                        '<tr><td> The following fields have been updated: <br></td></tr>' +
                        '<tr><td> ' + strValue + ' <br><br></td></tr>' +                        
                        '<tr><td>Thank You <br>' +
                        '</td></tr></table>'; 
                        if(toAddress.size()>0){
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Problem_Type__c + ': ' + bugTemp.Status__c+ ': ' + bugtemp.bug_title__c);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stTargetId);
                            email.setSaveAsActivity(false);
                            email.setOrgWideEmailAddressId(owa.id);
                            email.setToAddresses(toAddress);
                            emailList.add(email);   
                        }                       
                }
            }
            if (emailList.size() > 0) {Messaging.sendEmail(emailList);}
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
    
        } Catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugEmailTemplateHandler.class.getName();
            alw.sourceFunction = 'sendEmailOnEveryFieldChange()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    // Dev Complete sending email
    public static void sendEmailOnDevComplete(List<Bug__c> listBugs, Map<Id, Bug__c> oldBugs){
        List<Bug__c> requiredBugs   =    new List<Bug__c>();
        Set<Id> recIds              =   new Set<Id>();
        Map<String, Set<String>>  mapBugAndTeam   =   new Map<String, Set<String>>();
            for(Bug__c objBug : requiredBugs){
                mapBugAndTeam.put(objBug.Id, new Set<String>{objBug.Assigned_To__r.Email});
                mapBugAndTeam.get(objBug.Id).add(objBug.CreatedBy.Email);
            }
        for(Bug__c objBug : listBugs){
            if(objBug.get('DevComplete__c')==true && oldBugs.get(objBug.Id).get('DevComplete__c') == false) {
                mapBugAndTeam.put(objBug.Id, new Set<String>());
            }
        }
        if(mapBugAndTeam.size()>0){
            sendEmailGeneric(mapBugAndTeam,true);
        }
    }
    
    
    public static void sendEmailGeneric(Map<String, Set<String>> mapData, Boolean isDevComplete){
        try{
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        EmailTemplate templateId = [Select id from EmailTemplate where Developername = 'Email_Notification_for_ASIC_Bug_Assignment'];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> toAddress = new List<String>();
        Group objGroup  =   [SELECT Id, Name FROM Group WHERE DeveloperName = 'ASIC_Bug_Queue'];
        List<GroupMember> listGroupMember   =   [SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE GroupId =:objgroup.Id]; 
        Set<String> listGroupUserIds    =   new Set<String>();
        for(GroupMember objMember : listGroupMember){
            listGroupUserIds.add(objMember.UserOrGroupId);
        }
        List<User> listUsers = new List<User>();
        if(listGroupUserIds.size()>0){
            listUsers = [SELECT Id, Name, Email FROM User WHERE Id IN:listGroupUserIds];
        }
        Set<String> defaultEmails = new Set<String>();
        for(User objUser : listUsers){
            defaultEmails.add(objUser.email);
        }
            for(String bugId : mapData.keySet()){
                if(!isDevComplete){
                    toAddress.addAll(mapData.get(bugId));
                }else{
                    toAddress.addAll(defaultEmails);
                }
                //string strValue = GetOldNewValue(bugTemp, bugTempNew);
                if(toAddress.size()>0) {
                    String userEmail = toAddress[0];
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(templateId.Id); 
                    mail.setTargetObjectId(stTargetId);
                    mail.setSaveAsActivity(false);
                    mail.setOrgWideEmailAddressId(owa.id);
                    mail.setWhatId(bugId); 
                    mail.setToAddresses(toAddress);
                    allmsg.add(mail);
                }
            }
            if(toAddress.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg,false);
                if (results[0].success) {
                } else {
                    System.debug('The email failed to send: '+ results[0].errors[0].message);
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugEmailTemplateHandler.class.getName();
            alw.sourceFunction = 'sendEmailGeneric()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    public class applicationException extends Exception {}
    
}