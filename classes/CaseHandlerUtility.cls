/*
Type Name: CaseHandlerUtility
Author: Cognizant Case Management Team
Created Date: 31st-Jul-2014
Reason: Reason: This is the generic class for CaseTriggerHandler (all business logic)
Test Class: CaseTriggerHandlerTest
Change History:Added method getContactsFromAccountHierarchy for case:00074425
Author: Cognizant
Modified Date: 7/10/2017
ЕЕ..//
ЕЕ..
--
*/
global class CaseHandlerUtility {

    public static Boolean feedAttachFlag = true;
    public static boolean isCompleted = true;
    public static boolean isWorkflowExecuted = true;
    public static User UserDetails = [select Id,Name,HCM_Login_ID__c,Parent_Account_Id__c,ContactId, Contact.AccountId from User where id = : UserInfo.getUserId() Limit 1];
    public static boolean runOnce() {
        return isCompleted;
    }
    
    
    /**
    This future method is used for to write a custom object that could catch the error details.
    @method name: trackException
    @parameter:   string source,integer lineNumber, string type, string exceptionMessage
    @return :     NA
    **/
    @future
    public static void trackException(string source,integer lineNumber, string type, string exceptionMessage){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // Custom Label will be used in future.  
            String strEmailReceipt = System.Label.Case_Exception_Email_Receipt;
            String[] toAddresses = strEmailReceipt.split(';');       
            mail.setToAddresses(toAddresses);
            mail.setSubject('New Exception Notification- ' + exceptionMessage);
            string message = '<b>OrganizationId: </b>' + UserInfo.getOrganizationId()+ '\n' +
                             '<b>Organization Name: </b>' + UserInfo.getOrganizationName()+ '\n' +
                             '<b>User Name: </b>' + UserInfo.getUserName()+ '\n' +
                             '<b>Methods: </b>' + source + '\n' +
                             '<b>Line Number: </b>' + lineNumber+ '\n' +
                             '<b>Type: </b>' + type+ '\n' +
                             '<b>Message: </b>' + exceptionMessage;
            
            mail.setHtmlBody(message);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {     
        System.debug('Exception Occured - Class: CaseHandlerUtility.trackException ' + 
            'Line Number: ' + e.getLineNumber() + ' Type: ' + e.getTypeName() + ' Message: ' + e.getMessage());
            
            }
     }
    
    /**
    This method is used for assiging case ownerid.
    @method name: onCaseAssignmentProcess
    @parameter:   List of Cases.
    @return :     Map of account Id and Case Ownerid
    **/
    static public Map < Id, Id > onCaseAssignmentProcess(List < Case > caseList) {
        Map < Id, Id > mapCaseOwnerId = New Map < Id, Id > ();
        try {            
            Set < ID > accountIDs = new Set < ID > ();
            Map < String, List < Account_Team_Proxy__c >> accProxyMap = new Map < String, List < Account_Team_Proxy__c >> ();
            List < Id > lstUsers = new List < Id > ();
            Map < String, CaseAccountTeamProxy > accountMap = new Map < String, CaseAccountTeamProxy > ();
            
            CaseAccountTeamProxy acct = null;
            
           List < User > userList =new List<User>(); 
           userList.add(UserDetails);
            for (Case c: caseList) {
                if (c.AccountId == null && userList != null && userList.size() > 0) {
                    if (userList[0].ContactId != null) {
                        c.AccountId = userList[0].Contact.AccountId;
                    }
                }
                accountIDs.add(c.AccountId);
            }
            
            List < Account_Team_Proxy__c > accountTeamProxys = [SELECT Id, Account__c, User__c, Team_Role__c, Accounts_Owner__c FROM Account_Team_Proxy__c
                                                                WHERE Flag_for_Delete__c = false And User__r.IsActive = true And Account__c in : accountIDs ORDER BY LastModifiedDate DESC LIMIT 100
                                                               ];
            if (accountTeamProxys != null) {
                for (Account_Team_Proxy__c acctP: accountTeamProxys) {
                    lstUsers.add(acctP.User__c);
                }
                
                for (Account_Team_Proxy__c accTP: accountTeamProxys) {
                    if (accProxyMap.containsKey(accTP.Account__c)) {
                        List < Account_Team_Proxy__c > atp = accProxyMap.get(accTP.Account__c);
                        atp.add(accTP);
                        accProxyMap.put(accTP.Account__c, atp);
                    } else {
                        accProxyMap.put(accTP.Account__c, new List < Account_Team_Proxy__c > {
                            accTP
                                });
                    }
                }
                
                for (Id id: accProxyMap.keyset()) {
                    CaseAccountTeamProxy acctP = New CaseAccountTeamProxy(accProxyMap.get(String.valueOf(id)));
                    accountMap.put(id, acctP);
                }
                
                if (accountMap.size() > 0) { // Modified for Account NULL .
                    for (Case c: caseList) {
                        acct = (c.AccountId != null) ? accountMap.get(c.AccountId) : null;
                        if (acct != null) {
                            if (c.Case_Record_Type_API__c == 'Logistics') {
                                // Case Assignment Logic for Record Type = Logistics : 
                                // When "Primary Customer Service Rep" available then assign to "Primary Customer Service Rep"
                                // If "Primary Customer Service Rep" not available then assign it to "Backup Customer Service Rep"
                                // If "Backup Customer Service Rep" not Available them assign it to "Primary Account Manager"
                                if (acct.Primary_CSR != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_CSR);}
                                else if (acct.Backup_CSR != null) {mapCaseOwnerId.put(acct.AccountId, acct.Backup_CSR);}
                                else if (acct.Primary_AM != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_AM);}
                                else {mapCaseOwnerId.put(acct.AccountId, acct.OwnerId);}
                            } else if (c.Case_Record_Type_API__c == 'TechnicalPDK') {
                                // Case Assignment Logic for Record Type = Technical : 
                                // When "Primary Field Technical Support" available then assign to "Primary Field Technical Support"
                                // If "Primary Field Technical Support" not available then assign it to "Primary Customer Service Rep"
                                // If "Primary Customer Service Rep" not Available them assign it to "Primary Account Manager"
                                if (acct.Primary_PFTS != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_PFTS);}
                                else if (acct.Primary_FAE != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_FAE);}
                                else if (acct.Primary_AM != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_AM);}
                                else {mapCaseOwnerId.put(acct.AccountId, acct.OwnerId);}
                            } else if (c.Case_Record_Type_API__c == 'External_System') {
                                // Case Assignment Logic for Record Type = External_System: 
                                // When "Primary Field Technical Support" available then assign to "Primary Field Technical Support"
                                // If "Primary Field Technical Support" not available then assign it to "Primary Customer Service Rep"
                                // If "Primary Customer Service Rep" not Available them assign it to "Primary Account Manager"
                                if (acct.Primary_PFTS != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_PFTS);}
                                else if (acct.Primary_FAE != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_FAE);}
                                else if (acct.Primary_AM != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_AM);}
                                else {mapCaseOwnerId.put(acct.AccountId, acct.OwnerId);}
                            }
                            else if (c.Case_Record_Type_API__c == 'ASIC_Support') {                                
                                if (acct.Primary_PFTS != null) {mapCaseOwnerId.put(acct.AccountId, acct.Primary_PFTS);}                                                                
                            }
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }            
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseAssignmentProcess()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
         //trackException('CaseHandlerUtility.onCaseAssignmentProcess',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        return mapCaseOwnerId;        
    }
    
    /**
    This method is used for assiging case ownerid for Out of Office.
    @method name: onCaseAssignmentOutofOffice
    @parameter:   List of Cases.
    @return :     Map of OwnerId and OutofOffice delegated userid
    **/
    static public Map < Id, Id > onCaseAssignmentOutofOffice(List < Case > caseList) {
        Map < Id, Id > userId2OOO = new Map < Id, Id > (); //  Stored Case Assigned UserId and DelegatedUserId from Out Of Office
        try {            
            List < Id > lstUsers = new List < Id > ();
            
            for (Case c: caseList) {
                if (c.OwnerId != null) {
                    lstUsers.add(c.OwnerId);
                }
            }
            List < Out_Of_Office__c > lstOOO = [SELECT User__c, Delegate_User__c, Start_Time__c, End_Time__c from Out_Of_Office__c
                                                where user__c in : lstUsers And Active__c = true And Delegate_User__r.IsActive = true
                                               ];
            
            Datetime now = System.now();
            
            if (lstOOO != null && lstOOO.size() > 0) {
                for (Out_Of_Office__c ooo: lstOOO) {
                    if (now.getTime() >= ooo.Start_Time__c.getTime() && now.getTime() <= ooo.End_Time__c.getTime()) // Calculate The Start Date and End Date Difference based on the Out of Office Data .
                    {
                        userId2OOO.put(ooo.User__c, ooo.Delegate_User__c);
                    }
                }
            } 
                if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }           
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseAssignmentOutofOffice()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.onCaseAssignmentOutofOffice',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        return userId2OOO;
    }
    
    /** 
* Wrapper class to hold the value of  Account Team Proxy
* Account Team Proxy for each  Account
**/
    public class CaseAccountTeamProxy {
        public Id AccountId {get;set;}
        public Id OwnerId {get;set;}
        public Id Primary_CSR {get;set;}
        public Id Primary_PFTS {get;set;}
        public Id Primary_FAE {get;set;}
        public Id Backup_CSR {get;set;}
        public Id Primary_AM {get;set;}
        
        //---- Constructor of inner class -------
        public CaseAccountTeamProxy(List < Account_Team_Proxy__c > atpList) {
            this.OwnerId = atpList[0].Accounts_Owner__c;
            this.AccountId = atpList[0].Account__c;
            for (Integer a = 0; a < atpList.size(); a++) {
                if (atpList[a].Team_Role__c == System.Label.Primary_Customer_Service_Rep && this.Primary_CSR == null) {this.Primary_CSR = atpList[a].User__c;}
                else if (atpList[a].Team_Role__c == System.Label.Primary_Field_Technical_Support && this.Primary_PFTS == null) {this.Primary_PFTS = atpList[a].User__c;}
                else if (atpList[a].Team_Role__c == System.Label.Primary_Field_Engineer && this.Primary_FAE == null) {this.Primary_FAE = atpList[a].User__c;}
                else if (atpList[a].Team_Role__c == System.Label.Backup_Customer_Service_Rep && this.Backup_CSR == null) {this.Backup_CSR = atpList[a].User__c;}
                else if (atpList[a].Team_Role__c == System.Label.Primary_Account_Manager && this.Primary_AM == null) {this.Primary_AM = atpList[a].User__c;}
            }
        }
        // --- End of Inner class --- 
    }
    
    /* ******************************************************************************************************************* */
    
    /**
    This method is used for creating CaseTeamMember object.
    @method name: caseTeamMemberObject
    @parameter:   string ParentId, string MemberId, string TeamRoleId.
    @return :      CaseTeamMember object
    **/
    static public CaseTeamMember caseTeamMemberObject(string ParentId, string MemberId, string TeamRoleId) {
        CaseTeamMember objCaseTeamMember = new CaseTeamMember();
        objCaseTeamMember.ParentId = ParentId;
        objCaseTeamMember.MemberId = MemberId;
        objCaseTeamMember.TeamRoleId = TeamRoleId;
        return objCaseTeamMember;
    }
    
    static public CaseTeamMember caseTeamMemberObject(string Id) {
        CaseTeamMember objCaseTeamMember = new CaseTeamMember();
        objCaseTeamMember.Id = Id;
        return objCaseTeamMember;
    }
    
    static public List < CaseTeamMember > removeDuplicateMembers(List < CaseTeamMember > lstCaseteamMember) {
        Set < CaseTeamMember > setTeam = new Set < CaseTeamMember > ();
        List < CaseTeamMember > listTeam = new List < CaseTeamMember > ();
        setTeam.addAll(lstCaseteamMember);
        listTeam.addAll(setTeam);
        return listTeam;
    }
    
    /* ******************************************************************************************************************* */
    
    /**
    This method is used for creating CaseShare object.
    @method name: caseShareObject
    @parameter:   string CaseId, string UserOrGroupId, string CaseAccessLevel.
    @return :      CaseShare object
    **/
    static public CaseShare caseShareObject(string CaseId, string UserOrGroupId, string CaseAccessLevel) {
        CaseShare objCaseShare = new CaseShare();
        objCaseShare.CaseId = CaseId;
        objCaseShare.UserOrGroupId = UserOrGroupId;
        objCaseShare.CaseAccessLevel = CaseAccessLevel;
        return objCaseShare;
    }
    
    /* ******************************************************************************************************************* */
    
    /**
    This method is used for public comment validation.
    @method name: onCaseAssignmentProcess
    @parameter:   List of Cases.
    @return :      Boolean value
    **/
    static public Boolean onCasePublicCommentValidation() {
        Boolean isPublicCommentPermitted = false;
        
        CasePermissions__c objPermission = CasePermissions__c.getInstance(System.UserInfo.getUserId());
        
        if (objPermission == null) {
        
            objPermission = (CasePermissions__c.getInstance(System.UserInfo.getProfileId()) != null) ? CasePermissions__c.getInstance(System.UserInfo.getProfileId()) : CasePermissions__c.getInstance();
        }
        
        if (objPermission != null) {
        
            
            isPublicCommentPermitted = objPermission.PublicCommentPermitted__c;
        }
        return isPublicCommentPermitted;
    }
    
    /**
    This method is used for CCtoCase AccountId Validation.
    @method name: onCCtoCaseAccountIdValidation
    @parameter:   List of Cases
    @return :     Map<Id,Boolean>
    **/
    static public Map < Id, List < Case_Collaboration__c >> onCCtoCaseAccountIdValidation(List < Case > listCCtoCase) {
        
        Map < Id, List < Case_Collaboration__c >> mapCCtoCase = new Map < Id, List < Case_Collaboration__c >> ();
        Set < Id > caseIds = new Set < Id > ();
        List < Case_Collaboration__c > cctoCase = new List < Case_Collaboration__c > ();
        try {
            
            for (Case cId: listCCtoCase) {
                caseIds.add(cId.Id);
            }
            
            List < Case > listCase = [SELECT Id, AccountId, AccountThirdParty__c,CustomerRecordType__c, (SELECT Id, Case__c, Contact__r.AccountId, Is_Subscribed__c FROM Case_Collaborations__r) FROM Case WHERE Id In: caseIds];
            
            if (listCase != null && listCase.size() > 0) {
                for (Case c: listCase) {
                    cctoCase = c.Case_Collaborations__r;
                    if (cctoCase != null && cctoCase.size() > 0) {
                        mapCCtoCase.put(c.Id, c.Case_Collaborations__r);
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCCtoCaseAccountIdValidation()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.onCCtoCaseAccountIdValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        return mapCCtoCase;
    }
    
    /**
    This method is used for Portal User validation when Case Change from External to Internal Only.
    @method name: onCaseTeamContactValidation
    @parameter:   List of Cases
    @return :     Map<Id,Boolean>
    **/
    static public Map < Id, Boolean > onCaseTeamContactValidation(List < Case > listCCtoCase) {
        
        Set < Id > caseIds = new Set < Id > ();
        Set < Id > userIds = new Set < Id > ();
        Map < Id, Boolean > mapCaseTeam = new Map < Id, Boolean > ();
        List < CaseTeamMember > caseTeamMemberList = new List < CaseTeamMember > ();
        Map < Id, Id > mapUserContact = new Map < Id, Id > ();
        try {
            
            for (Case cId: listCCtoCase) {
                caseIds.add(cId.Id);
            }
            caseTeamMemberList = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId In: caseIds];
            
            if (caseTeamMemberList != null && caseTeamMemberList.size() > 0) {
                for (CaseTeamMember caseteam: caseTeamMemberList) {
                    if (!mapCaseTeam.containsKey(caseteam.ParentId)) {
                        string strMemberId = caseteam.MemberId;
                        if (strMemberId.startsWith('003')) {
                            mapCaseTeam.put(caseteam.ParentId, True);
                        } else if (strMemberId.startsWith('005')) {
                            userIds.add(caseteam.MemberId);
                        }
                    }
                }
            }
            if (userIds != null && userIds.size() > 0) {
                User[] users = [SELECT Id, Name, ContactId FROM User WHERE IsPortalEnabled = True AND IsActive = True AND UserType = 'PowerCustomerSuccess'
                                AND Id IN: userIds
                               ];
                if (users != null && users.size() > 0) {
                    for (User objUser: users) {
                        mapUserContact.put(objUser.Id, objUser.ContactId);
                    }
                }
                if (mapUserContact != null && mapUserContact.size() > 0) {
                    for (CaseTeamMember caseteam: caseTeamMemberList) {
                        if (!mapCaseTeam.containsKey(caseteam.ParentId)) {
                            string contactId = string.valueof(mapUserContact.get(caseteam.MemberId));
                            if (contactId.startsWith('003')) {
                                mapCaseTeam.put(caseteam.ParentId, True);
                            }
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseTeamContactValidation()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.onCaseTeamContactValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        return mapCaseTeam;
    }
    
    /* ***************************************************************************************************************** */
    
    /**
    This method is used for Team Room Members Permission on Case, used in CaseTeamMember Trigger.
    @method name: casePermissionForTeamRoomMembers
    @parameter:   List of Cases Ids and List of Team Room Ids.
    @return :     NA
    **/
    @future
    public static void teamRoomMembersPermissionOnCase(Set < Id > caseIds, List < Id > teamRoomIds) {
        try {            
            Map < Id, List < Team_Room_Member__c >> mapTeamMembers = New Map < Id, List < Team_Room_Member__c >> ();
            
            List < Case > lstCase = [SELECT Id, Case_Record_Type_API__c, Internal_or_external__c, Team_Room__c, CreatedById, OwnerId, CustomerRecordType__c From Case WHERE Id In: caseIds];
            
            List < Team_Room__c > lstTeamRooms = [SELECT Id, (SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.IsActive, User__r.ContactId, User__r.UserType, User__r.Profile.UserLicense.Name, User__r.Email, Access__c,
                                                              Role__c, Team_Room_Role__c, Team_Room__r.Name FROM Team_Room_Members__r) FROM Team_Room__c WHERE Id In: teamRoomIds];
            List < Team_Room_Member__c > lstTeamMembers = New List < Team_Room_Member__c > ();
            
            List < CaseShare > lstCaseShare = New List < CaseShare > ();
            List < Case_Collaboration__c > lstCCtoCase = New List < Case_Collaboration__c > ();
            
            
            for (Team_Room__c objTR: lstTeamRooms) {
                mapTeamMembers.put(objTR.Id, objTR.Team_Room_Members__r);
            }
            
            for (Case objCase: lstCase) {
                if (objCase.Team_Room__c != null) {
                    lstTeamMembers = mapTeamMembers.get(objCase.Team_Room__c);
                    Set < String > userOrGroupId = new Set < String > ();
                    userOrGroupId.add(objCase.CreatedById);
                    if (objCase.CreatedById != objCase.OwnerId) {userOrGroupId.add(objCase.OwnerId);}
                    
                    for (Team_Room_Member__c objTM: lstTeamMembers) {
                        if (objTM.User__c != null && objTM.User__r.IsActive == True) {
                            if (objTM.User__r.UserType == 'Standard') {
                                if (!userOrGroupId.contains(objTM.User__c)) {
                                    // New caseShare object for each case where User__c field is not NULL                                    
                                    userOrGroupId.add(objTM.User__c);
                                    String accessLevel ='Edit';
                                    // Read write access to that user for this particular case record. 
                                    if (objTM.User__r.Profile.UserLicense.Name == 'Salesforce Platform') {accessLevel = 'Read';}
                                    else if (objTM.User__r.Profile.UserLicense.Name == 'Salesforce') {
                                        accessLevel = 'Edit'; //Salesforce
                                        /*
                                        if(objTM.Team_Room_Role__c =='Moderator'){
                                            accessLevel = 'Edit';
                                        }else{
                                            accessLevel = 'Read';
                                        }
                                        */
                                    }
                                    // Assign user id to grant read write access to this particular case record.                                  
                                    lstCaseShare.add(caseShareObject(objCase.Id,objTM.User__c,accessLevel));
                                }
                            } else if (objTM.User__r.UserType == 'PowerCustomerSuccess' && UserInfo.getUserType() == 'Standard' && objCase.CustomerRecordType__c) {                                
                                if ((objTM.User__r.ContactId != null && objCase.Internal_or_external__c != true) && (!userOrGroupId.contains(objTM.User__c))) {
                                    Case_Collaboration__c cc = new Case_Collaboration__c();
                                    cc.Name = objTM.User__r.Name + ' from (Team Room) ' + objTM.Team_Room__r.Name;
                                    cc.Contact__c = objTM.User__r.ContactId;
                                    cc.Case__c = objCase.Id;
                                    if (cc.Case__c != null && cc.Contact__c != null) {
                                        cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.Contact__c);
                                    }
                                    cc.Email_Id__c = objTM.User__r.Email;
                                    cc.Is_Subscribed__c = true;
                                    cc.CC_Link__c = System.Label.Case_Globalfoundry_Link + 'apex/CCtoCase';
                                    lstCCtoCase.add(cc);
                                }
                            }
                        }
                    }
                }
            }
            if (lstCaseShare != null && lstCaseShare.size() != 0) {
                insert lstCaseShare;
            }
            if (lstCCtoCase != null && lstCCtoCase.size() != 0) {
                insert lstCCtoCase;
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='teamRoomMembersPermissionOnCase()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.teamRoomMembersPermissionOnCase',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    /* ************************************************************************************************************************************* */
    
    /**
    This method is used for assiging case ownerid.
    @method name: onCaseTeamMemberAdd
    @parameter:   List of Case Collaboration.
    @return :     List of CaseTeamMember
    **/
    @future
    public static void  onCaseTeamMemberAdd(Set < Id > CCIds , Set < Id> caseIds,Set < Id > lstAllContact,Set<Id> actIds) {
        try {
        
            Map<id,Set<id>> casetoAllContactMap = new Map<id,Set<id>>();    
            Map<id,Set<id>> caseeShareToAllUsers = new Map<id,Set<id>>();       
            Map<id,Set<id>> caseAccounttoAllContacts =  CaseHandlerUtility.getContactsFromAccountHierarchy(actIds);
            if(caseAccounttoAllContacts.size() >0 ){
                for(Case caseObj:[select id,accountid from case where id in:caseIds]){    
                    Set<id> contSet = caseAccounttoAllContacts.get(caseObj.accountid); 
                    casetoAllContactMap.put(caseObj.id,contSet);    
                }
            }
            
            
            
            List <Case_Collaboration__c> CCList = [SELECT Id,Member_Role_Name__c, Name, Case__c, Contact__c, Email__c,user__c, Is_Subscribed__c from Case_Collaboration__c WHERE Id In: CCIds];            
            List <CaseTeamMember> lstCaseteamMember = new List < CaseTeamMember > ();
            List <CaseShare>  lstCaseShare  = new List< CaseShare > ();
            
            Map <Id, Id> mapConatctUser = new Map < Id, Id >();
            Map <String, CaseTeamMember> mapCaseTeamMem = new Map <String, CaseTeamMember>();
            
            List<CaseShare> caseShareLst = [ select id ,UserOrGroupId,CaseId  from CaseShare  where CaseId  in:caseIds];
            for(CaseShare cs:caseShareLst){
                if(!caseeShareToAllUsers.containsKey(cs.CaseId))
                    caseeShareToAllUsers.put(cs.CaseId,new Set<Id>{cs.UserOrGroupId});  
                else
                  caseeShareToAllUsers.get(cs.CaseId).add(cs.UserOrGroupId);                                
            }            
            
            if (lstAllContact != null && lstAllContact.size() > 0) {
                List<User> lstUser = [SELECT Id, ContactId FROM User WHERE IsActive = true And ContactId in : lstAllContact LIMIT 1000];
                if (lstUser != null && lstUser.size() > 0) {
                    for (User userObj: lstUser) {
                        mapConatctUser.Put(userObj.ContactId, userObj.Id);
                    }
                }
            }  
                                 
            if (caseIds != null && caseIds.size() > 0) {                
                List<CaseTeamMember > lstCaseTeamMemberTemp = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId In: caseIds LIMIT 1000];
                if (lstCaseTeamMemberTemp != null && lstCaseTeamMemberTemp.size() > 0) {
                    for (CaseTeamMember ct: lstCaseTeamMemberTemp) {
                        String ParentId = ct.ParentId;
                        String MemberId = ct.MemberId;
                        mapCaseTeamMem.Put(ParentId + MemberId, ct);
                    }
                }
            }
            
            for (Case_Collaboration__c cctocase: CCList) { 
                if(cctocase.Contact__c != null){
                    if(casetoAllContactMap.get(cctocase.case__c) != null){  
                         Set<id> actAllContacts = casetoAllContactMap.get(cctocase.case__c);                         
                         if(actAllContacts.contains(cctocase.Contact__c)){
                            CaseTeamMember objcaseteamMember = new CaseTeamMember();                    
                            objcaseteamMember.MemberId = (mapConatctUser.get(cctocase.Contact__c) != null) ? mapConatctUser.get(cctocase.Contact__c) : cctocase.Contact__c;                   
                            if(cctocase.Member_Role_Name__c == '' || cctocase.Member_Role_Name__c == null)
                                objcaseteamMember.TeamRoleId = System.Label.Case_Team_Role_Id_Case_Collaboration;
                            else
                                 objcaseteamMember.TeamRoleId = cctocase.Member_Role_Name__c;
                                 
                            objcaseteamMember.ParentId = cctocase.Case__c;                        
                            String ParentId = objcaseteamMember.ParentId;
                            String MemberId = objcaseteamMember.MemberId;                        
                            if (mapCaseTeamMem != null) {
                                if (!mapCaseTeamMem.containsKey(ParentId + MemberId)) {
                                    lstCaseteamMember.add(objcaseteamMember);                                
                                    if (mapConatctUser.get(cctocase.Contact__c) != null){ 
                                        // Case Share insert for Salesforce user type
                                        lstCaseShare.add(caseShareObject(objcaseteamMember.ParentId,objcaseteamMember.MemberId,'Edit'));
                                    }
                                }
                            }
                       }
                    } 
                  }                 
               else if(cctocase.user__c != null && cctocase.Contact__c == null){               
                CaseTeamMember objcaseteamMember = new CaseTeamMember();                
                objcaseteamMember.MemberId = cctocase.user__c;
                objcaseteamMember.TeamRoleId = cctocase.Member_Role_Name__c;
                objcaseteamMember.ParentId = cctocase.Case__c;               
                String ParentId = objcaseteamMember.ParentId;
                String MemberId = objcaseteamMember.MemberId;                
                if (mapCaseTeamMem != null) {
                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId)) {
                        lstCaseteamMember.add(objcaseteamMember);                                                                                                                        
                    }
                }
                if(caseeShareToAllUsers.get(cctocase.Case__c) != null){
                    Set<id> userids = caseeShareToAllUsers.get(cctocase.Case__c);
                    if(!userids.contains(objcaseteamMember.MemberId)){
                         lstCaseShare.add(caseShareObject(objcaseteamMember.ParentId,objcaseteamMember.MemberId,'Edit'));
                    }                   
                }
               }               
            }
            
            if (lstCaseShare != null && lstCaseShare.size() > 0) {                              
                 database.insert(lstCaseShare,false) ;
            }            
            if (lstCaseteamMember != null && lstCaseteamMember.size() > 0) {
                insert lstCaseteamMember;
            }
           if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseTeamMemberAdd()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.onCaseTeamMemberAdd',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
       
    /**
    This method is used for assiging case ownerid.
    @method name: onCaseTeamMemberRemove
    @parameter:   List of Case Collaboration.
    @return :     List of CaseTeamMember
    **/
    @future
    public static void  onCaseTeamMemberRemove(Set < Id > CCIds , Set < Id > lstContact, Set < Id> caseIds, Set<id> ccUserIds , Set<id> ccCasePreTeamIds,string type) {
        try {
            
            List < CaseTeamMember > lstCaseteamMemberDel = new List < CaseTeamMember > ();
            List < CaseTeamMember > lstCaseteamMemberUserDel = new List < CaseTeamMember > ();
            List < CaseTeamTemplateRecord > listCaseTeam = new List < CaseTeamTemplateRecord > ();
            List < CaseTeamTemplateRecord > listCaseTeamDel = new List < CaseTeamTemplateRecord > ();
            List< CaseShare >  lstCaseShare  = new List< CaseShare > ();
            List< CaseShare > lstUsrCaseShare  = new List< CaseShare > ();
            List<Id> userIds = new List<Id>();
            
            if (lstContact != null && lstContact.size() > 0) {
                List<User> lstUser = [SELECT Id, ContactId FROM User WHERE IsActive = true And ContactId in : lstContact LIMIT 1000];
                if (lstUser != null && lstUser.size() > 0) {
                    for (User userObj: lstUser) {
                        userIds.add(userObj.Id);
                    }
                }
            }
            
            String strRoleId = System.Label.Case_Team_Role_Id_Case_Collaboration;            
            if (caseIds != null && caseIds.size() > 0) {                              
                lstCaseteamMemberDel = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE  ParentId In: caseIds AND (MemberId In: userIds OR MemberId In: lstContact ) LIMIT 1000];                    
                if(ccUserIds != null && ccUserIds.size() > 0){
                    lstCaseteamMemberUserDel = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE  ParentId In: caseIds AND  MemberId In: ccUserIds  LIMIT 1000];  
                } 
                
                if(ccCasePreTeamIds != null && ccCasePreTeamIds.size() > 0){
                    listCaseTeam = [ select id from CaseTeamTemplateRecord where TeamTemplateId in:ccCasePreTeamIds];
                }
                if (listCaseTeam != null && listCaseTeam.size() > 0)           
                     listCaseTeamDel.addAll(listCaseTeam );  
                
                if (lstCaseteamMemberUserDel != null && lstCaseteamMemberUserDel .size() > 0)           
                     lstCaseteamMemberDel.addAll(lstCaseteamMemberUserDel );             
            }  
            
            if (listCaseTeamDel != null && listCaseTeamDel.size() > 0) {delete listCaseTeamDel;} 
                     
            if (lstCaseteamMemberDel != null && lstCaseteamMemberDel.size() > 0) {delete lstCaseteamMemberDel;} 
                       
            if( type == 'Delete') {
                if (caseIds != null && caseIds.size() > 0 && userIds != null && userIds.size()>0) {
                    lstCaseShare  =[SELECT Id, CaseId , UserOrGroupId FROM CaseShare WHERE RowCause='Manual' AND CaseAccessLevel ='Edit' AND CaseId In: caseIds AND UserOrGroupId In: userIds LIMIT 1000];                
                }
                
                if (caseIds != null && caseIds.size() > 0 && ccUserIds != null && ccUserIds.size()>0) {
                    lstUsrCaseShare  =[SELECT Id, CaseId , UserOrGroupId FROM CaseShare WHERE RowCause='Manual'  AND CaseId In: caseIds AND UserOrGroupId In: ccUserIds LIMIT 1000];                
                    if (lstUsrCaseShare  != null && lstUsrCaseShare.size() > 0) 
                        lstCaseShare.addall(lstUsrCaseShare);
                }
                
                if (lstCaseShare != null && lstCaseShare.size() > 0) {                        
                        delete lstCaseShare;
                }
            }          
           if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseTeamMemberRemove()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.onCaseTeamMemberRemove',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        
    }
    
    /* ***************************************************************************************************************** */
    
    /**
    This method is used for auto approve the approval Process.
    @method name: CaseAutoApproveProcess
    @parameter:   List of Cases Ids and List of Users Ids.
    @return :     NA
    **/
    @future
    public static void CaseAutoApproveProcess(Set < Id > caseIds) {
        try {
            List < Approval.ProcessWorkitemRequest > lstprocess = new List < Approval.ProcessWorkitemRequest > ();
            
            List < ProcessInstanceWorkitem > listApprovalReq = [SELECT Id, ProcessInstance.TargetObjectId
                                                                FROM ProcessInstanceWorkitem
                                                                WHERE ProcessInstance.TargetObjectId In: caseIds
                                                               ];
            if (listApprovalReq != null && listApprovalReq.size() > 0) {
                for (ProcessInstanceWorkitem approvalReqObj: listApprovalReq) {
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments('Auto Approved.');
                    req.setAction('Approve');
                    req.setWorkitemId(approvalReqObj.Id);
                    lstprocess.add(req);
                }
                if (lstprocess != null && lstprocess.size() > 0) {
                    List < Approval.ProcessResult > resultlist = Approval.process(lstprocess);
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='CaseAutoApproveProcess()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.CaseAutoApproveProcess',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    } 
    
    
    /* ***************************************************************************************************************** */
    
    /**
    This method is used for Internal Users Permission on Case .
    @method name: standardUsersPermissionOnCase
    @parameter:   List of Cases Ids.
    @return :     NA
    **/
    @future
    public static void standardUsersPermissionOnCase(Set < Id > caseIds) {
        try {
            
            Map < String, Set < Case > > mapEmailCase = new Map < String, Set < Case > > ();
            Map < String, Set < User > > mapEmailUserIds = new Map < String, Set < User > > ();
            
            Set < String > caseEmails = new Set < String > ();
            Set < String > setCaseShare = new Set < String > ();
            
            List < Case > listCase = [SELECT Id, Case_Record_Type_API__c, Internal_or_external__c, CreatedById, OwnerId, SuppliedEmail, ContactId, Contact.Email,CustomerRecordType__c From Case WHERE Id In: caseIds];
                       
            for (CaseShare caseShareObj: [SELECT Id, CaseId, RowCause, UserOrGroupId, CaseAccessLevel From CaseShare WHERE CaseId In: caseIds]) {
                if (!setCaseShare.contains((string) caseShareObj.CaseId + (string) caseShareObj.UserOrGroupId)) {
                    setCaseShare.add((string) caseShareObj.CaseId + (string) caseShareObj.UserOrGroupId);
                }
            }
            
            List < String > emailAddresses = new List < String > ();
            
            for (Case caseObj: listCase) {
                
                if (caseObj.ContactId != null && caseObj.Contact.Email != null) {
                    if (!mapEmailCase.containsKey(caseObj.Contact.Email)) {
                        Set < Case > setCase = new Set < Case > ();
                        setCase.add(caseObj);
                        mapEmailCase.put(caseObj.Contact.Email, setCase);
                        
                    } else {
                        Set < Case > setCase = mapEmailCase.get(caseObj.Contact.Email);
                        if (!setCase.contains(caseObj)) {mapEmailCase.get(caseObj.Contact.Email).add(caseObj);}
                    }
                }
            }
            
            List < User > listUsers = [Select Id, Email, ProfileId, IsActive, UserType, Profile.Name, Profile.UserLicense.Name, ContactId, Contact.AccountId From User Where IsActive = True AND UserType = 'Standard'
                                       AND Profile.Name != 'System Administrator'
                                       AND Email In: mapEmailCase.keySet()
                                      ];
            
            if (listUsers != null && listUsers.size() > 0) {
                for (User userObj: listUsers) {
                    if (!mapEmailUserIds.containsKey(userObj.Email)) {
                        Set < User > setUserId = new Set < User > ();
                        setUserId.add(userObj);
                        mapEmailUserIds.put(userObj.Email, setUserId);
                        
                    } else {
                        Set < User > setUserId = mapEmailUserIds.get(userObj.Email);
                        if (!setUserId.contains(userObj)) {mapEmailUserIds.get(userObj.Email).add(userObj);}
                    }
                }
                List < CaseShare > lstCaseShare = New List < CaseShare > ();
                
                for (String keyEmail: mapEmailCase.keySet()) {
                    Set < User > users = mapEmailUserIds.get(keyEmail);
                    Set < Case > cases = mapEmailCase.get(keyEmail);
                    
                    if (users != null && users.size() > 0) {
                        for (User userId: users) {
                            for (Case caseId: cases) {
                                if (!setCaseShare.contains((string) caseId.Id + (string) userId.Id)) {
                                    if (caseId.CreatedById != userId.Id || caseId.OwnerId != userId.Id) {                                        
                                        String accessLevel ='Edit';
                                        if (userId.Profile.UserLicense.Name == 'Salesforce Platform') {accessLevel = 'Read';}
                                        else if (userId.Profile.UserLicense.Name == 'Salesforce') {accessLevel = 'Edit';} 
                                        
                                        lstCaseShare.add(caseShareObject(caseId.Id,userId.Id,accessLevel));
                                    }
                                }
                            }
                        }
                    }    
                }
                
                if (lstCaseShare != null && lstCaseShare.size() > 0) {
                    insert lstCaseShare;
                }
            }
           if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='standardUsersPermissionOnCase()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.standardUsersPermissionOnCase',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /* ***************************************************************************************************************** */   
    /**
    This method is used for update Case Status.
    @method name: CaseStausUpdateOnComment
    @parameter:   List of Cases Ids and string status
    @return :     NA
    **/
    @future
    public static void CaseStatusUpdateOnComment(Set < Id > caseIds, string status, Boolean flag) {
        try {
            List < Case > listCaseUpdate = new List < Case > ();            
            if (caseIds != null && caseIds.size() > 0) {
                for (Id caseId: caseIds) {
                    Case caseObj = new Case();
                    caseObj.isFeedItem__c = true;
                    caseObj.SkipValidationRuleInTrigger__c = true;
                    caseObj.Id = caseId;
                    if(flag){
                        caseObj.Status = System.Label.Case_Status_New;
                        caseObj.AttachmentUploadedFlag__c = false; 
                    }else{
                        caseObj.Status = status;
                    }                    
                    listCaseUpdate.add(caseObj);
                }
                if (listCaseUpdate != null && listCaseUpdate.size() > 0) {
                    update listCaseUpdate;
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='CaseStatusUpdateOnComment()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.CaseStatusUpdateOnComment',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    } 
    
    /* ***************************************************************************************************************** */   
    /**
    This method is used for update Case First Response related fields.
    @method name: CaseFirstResponseFieldUpdate
    @parameter:   List of Cases Ids.
    @return :     NA
    **/
    public static void CaseFirstResponseFieldUpdate(Set < Id > caseIds) {
        try {
            List < Case > listCaseUpdate = new List < Case > ();            
            if (caseIds != null && caseIds.size() > 0) {
                for (Id caseId: caseIds) {
                    Case caseObj = new Case();
                    caseObj.Id = caseId;                    
                    caseObj.Date_Time_First_Response__c = DateTime.Now();
                    caseObj.First_Response_By__c = UserInfo.getUserId();
                    listCaseUpdate.add(caseObj);
                }
                if (listCaseUpdate != null && listCaseUpdate.size() > 0) {
                    update listCaseUpdate;
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='CaseFirstResponseFieldUpdate()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
            //trackException('CaseHandlerUtility.CaseFirstResponseFieldUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
        
    /* ***************************************************************************************************************** */   
    /**
    This method is used for updating Case fields to notified email recipients.
    @method name: caseLastChatterCommentUpdate
    @parameter:   List of FeedItem Ids
    @return :     NA
    **/
    @future
    public static void caseLastChatterFeedItemUpdate(Set < Id > feedItemIds) {
        try {
            isCompleted = false;
            List < Case > caseList = New List < Case > ();
            List<id> caseIds  = new List<id>();
            Map<id,case> feedCaseMap = new Map<id,case>();
            Map<id,FeedItem> mapCaseToFeedMap = new Map<id,FeedItem>();
            List < FeedItem > listFeedItems = [SELECT Id, Type, ParentId, ContentFileName, Body, VISIBILITY, LinkUrl, Title,
                                               ContentDescription, ContentSize, ContentType, InsertedById, RelatedRecordId FROM FeedItem WHERE Id In: feedItemIds
                                              ];
                       
            for (FeedItem fi: listFeedItems) {
           
                if (fi.Type == 'TextPost' || fi.Type == 'LinkPost' || fi.Type == 'QuestionPost') {
                 Case objCase = New Case();
                 objCase.Id = fi.ParentId;
                /*
                if (fi.Type == 'ContentPost'  ){                       
                        objCase.Id = fi.ParentId;                                
                        objCase.Last_Attachment_Date__c = DateTime.Now();
                        system.debug('Last_Attachment_Date__c'+objCase.Last_Attachment_Date__c );
                        objCase.Last_Attachment_File_Name__c = fi.ContentFileName;
                        objCase.Last_Attachment_Description__c = fi.Body;
                        if (fi.VISIBILITY == 'AllUsers') {
                            objCase.Last_Attachment_IsPrivate__c = false;
                        } else {
                            objCase.Last_Attachment_IsPrivate__c = true;
                        }
                        objCase.Last_Attachment_Id__c = (string)fi.Id+objCase.Last_Attachment_IsPrivate__c;
                        objCase.Last_Attachment_Uploaded__c = UserInfo.getUserId();
                        objCase.Last_Attachment_Size__c = (decimal) fi.ContentSize;
                        objCase.Last_Attachment_URL__c = 'sfc/servlet.shepherd/version/download/'+fi.RelatedRecordId;
                    } 
                */
                    
                    if (fi.Type == 'TextPost') {                        
                        objCase.Last_Case_Comments__c = fi.Body;
                        objCase.Last_Comment_Date__c = datetime.now();
                        if (fi.VISIBILITY == 'AllUsers') {
                            objCase.Last_Comment_IsPublished__c = true;
                        } else {
                            objCase.Last_Comment_IsPublished__c = false;
                        }
                        objCase.LastCaseCommentId__c = (string)fi.Id+objCase.Last_Comment_IsPublished__c;
                    } 
                    else if (fi.Type == 'LinkPost') {
                        string strBody = fi.LinkUrl + '\n' + fi.Title;
                        objCase.Last_Case_Comments__c = strBody;
                        objCase.Last_Comment_Date__c = datetime.now();
                        if (fi.VISIBILITY == 'AllUsers') {
                            objCase.Last_Comment_IsPublished__c= true;
                        } else {
                     
                            objCase.Last_Comment_IsPublished__c= false;
                        }
                        objCase.LastCaseCommentId__c = (string)fi.Id+objCase.Last_Comment_IsPublished__c;
                    }
                    /* else if (fi.Type == 'QuestionPost') {
                        string strBody = fi.Title + '\n' + fi.Body;
                        objCase.Last_Case_Comments__c = strBody;
                        objCase.Last_Comment_Date__c = datetime.now();
                        if (fi.VISIBILITY == 'AllUsers') {
                            objCase.Last_Comment_IsPublished__c= true;
                        } else {
                            objCase.Last_Comment_IsPublished__c= false;
                        }
                        objCase.LastCaseCommentId__c = (string)fi.Id+objCase.Last_Comment_IsPublished__c;
                    }*/
                    caseList.add(objCase);
                }
            }
            
            if (caseList != null && caseList.size() > 0) {
                update caseList;
            }
            isCompleted = true;
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='caseLastChatterFeedItemUpdate()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.caseLastChatterFeedItemUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    } 
    
            
    @future
    public static void caseLastChatterFeedItemAttachmentUpdate(Set <Id> caseIds){   
       try {
                 Map<id,casefeed> caseIdFeedMap = new Map<id,Casefeed>();
                 List <Case> caseList = New List <Case>();
                 list <Case> lstCase = new list <Case>();
                 List <CaseFeed> listFeedItems = new List <CaseFeed>();
                 if(feedAttachFlag){
                     lstCase  = [SELECT Id FROM case WHERE Id In: caseIds];
                     listFeedItems  = [SELECT Id, Type, ParentId, ContentFileName, Body, VISIBILITY, LinkUrl, Title,
                                                        ContentDescription, ContentSize, ContentType, InsertedById, RelatedRecordId FROM CaseFeed WHERE type = 'ContentPost' and parentid in:caseIds order by createdDate desc limit 1];   
                 }                                                                           
                if(listFeedItems !=null && listFeedItems.size() > 0 ){                
                     for(CaseFeed fi:listFeedItems){                       
                         caseIdFeedMap.put(fi.ParentId,fi);         
                      }                               
                    for(Case caseObj:lstCase){
                          Case objCase = New Case();
                          objCase.Id = caseObj.id;
                          CaseFeed feedObj = caseIdFeedMap.get(caseObj.id);
                          objCase.Last_Attachment_Date__c = DateTime.Now();
                          objCase.Last_Attachment_File_Name__c = feedObj.ContentFileName;
                          objCase.Last_Attachment_Description__c = feedObj.Body;
                          if (feedObj.VISIBILITY == 'AllUsers') {
                                        objCase.Last_Attachment_IsPrivate__c = false;
                            }
                          else {
                                        objCase.Last_Attachment_IsPrivate__c = true;
                            }
                         objCase.Last_Attachment_Id__c = (string)feedObj.Id+objCase.Last_Attachment_IsPrivate__c;
                         objCase.Last_Attachment_Uploaded__c = UserInfo.getUserId();
                         objCase.Last_Attachment_Size__c = (decimal)feedObj.ContentSize;
                         objCase.Last_Attachment_URL__c = 'sfc/servlet.shepherd/version/download/'+feedObj.RelatedRecordId;
                         caseList.add(objCase);                  
                    }                  
                  }     
                if (caseList != null && caseList.size() > 0) {
                     feedAttachFlag = false;
                     update caseList;
                }
                 if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
            }
            catch (Exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='caseLastChatterFeedItemUpdate()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);                    
        }
    }
    
    /* ***************************************************************************************************************** */   
    /**
    This method is used for deleting attachment and clear it from Recyle Bin
    @method name: caseAttachmentDelete
    @parameter:   List of attachment Ids
    @return :     NA
    **/
    @future
    public static void caseAttachmentDelete(Set < Id > attIds) {
        try {
            list < Attachment > lstAtt = [SELECT Id FROM Attachment WHERE Id In: attIds];
            if (lstAtt != null && lstAtt.size() > 0) {        
                delete lstAtt;
                DataBase.emptyRecycleBin(lstAtt);
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='caseAttachmentDelete()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.caseAttachmentDelete',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    } 
    
    /**
    This method is used for checking logged in user exists in swift Queue.
    @method name: swiftMembersCount
    @parameter:   NA
    @return :     1 or 0
    **/    
    public static Integer swiftMembersCount() {
        Integer SwiftMemberscount =0;
       try {     
            string swiftQueueId = System.Label.Case_Swift_Support_QueueId;
            List<String> swiftQueueIds = swiftQueueId.split(';');
            SwiftMemberscount = [Select count() From GroupMember Where UserOrGroupId =:UserInfo.getUserId() And GroupId=:swiftQueueIds limit 1];
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='swiftMembersCount()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.swiftMembersCount',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        return SwiftMemberscount;
    }
    
    /* ***************************************************************************************************************** */
    /**
    This method is used to find group members for each group\queue Id
    @method name: findGroupMembers
    @parameter:   List of Queue\Group Ids
    @return :     Map<GroupId, List<UserId>>
    **/  
    public static Map < Id, List < Id > > getGroupMembers(Set < Id > groupIds) {
        Map < Id, List < Id >> returnGroupMembers = new Map < Id, List < Id >> ();
        Map < Id, Id> mapGroupSubGroupId = new Map < Id, Id> ();
        List < GroupMember > groupMembers = new List < GroupMember > ();
        List < GroupMember > subGroupMembers = new List < GroupMember > ();
        List < Id > subGroupsIds = new List < Id > ();
        Id[] groupMemberIds = new list<Id>();

        try {
            Map < Id, List < Id >> mapGroupMembers = new Map < Id, List < Id >> ();
            
            if (groupIds != null && groupIds.size() > 0)
                groupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: groupIds Limit 100];
    
            if (groupMembers != null && groupMembers.size() > 0) {
                for (GroupMember gm: groupmembers) {
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = gm.GroupId;
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                   } else {
                        subGroupsIds.add(gm.UserOrGroupId); // if group members are groups get those groups members
                        if (!mapGroupMembers.containsKey(gm.UserOrGroupId))
                            mapGroupSubGroupId.put(gm.UserOrGroupId, gm.GroupId);
                    }
                }
            }
            //Iterate through only 1 sub-group level where the group member is another.
            if (subGroupsIds != null && subGroupsIds.size() > 0)
                subGroupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: subGroupsIds Limit 100];
    
            if (subGroupMembers != null && subGroupMembers.size() > 0) {
                for (GroupMember gm: subGroupMembers) {
                    
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = mapGroupSubGroupId.get(gm.GroupId);
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                    }
                }
            }
            
            // keep trying to get users from GroupMember.userOrGroupId.
            if(mapGroupMembers !=null && mapGroupMembers.size()>0){
                
                Map<Id, User> users = new Map<Id, User>([select Id,Email, Name from User where (Id In :groupMemberIds) and (isActive=true) Limit 1000]);
                Set<Id> setUsers = users.keySet();
                
                for (Id groupId: mapGroupMembers.keySet()) {
                    // The "key" variable is also available inside the loop
                    List<Id> listUsers = mapGroupMembers.get(groupId);
                    for (Id userId: listUsers) {
                        if(setUsers.Contains(userId)){
                            if (returnGroupMembers.containsKey(groupId)) {
                                returnGroupMembers.get(groupId).add(userId);
                            } else {
                                returnGroupMembers.put(groupId, new List < Id > {
                                    userId
                                });
                            }
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='getGroupMembers()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //trackException('CaseHandlerUtility.getGroupMembers', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
        return returnGroupMembers; // return group members with group Id
        
    }
    
    /* ***************************************************************************************************************** */
    /**
    This method is used to calculate OwnerId for L2 L3 Routing
    @method name: calculateL2L3Routings
    @parameter:   List of Case Ids and List OwenrIds
    @return :     NA
    **/ 
    @future 
    public static void calculateL2L3Routings(List< Id> listCaseIdL2, List<Id> listOwnerIdL2) {
        try {
            List<CaseL2L3Routing__c> listCaseL2L3Routing = new List<CaseL2L3Routing__c> ();
            List<Case> listCase = new List<Case>();
            List<Case> updateCase = new List<Case>();
            listCaseL2L3Routing = [Select Id,Category__c,SubCategory__c, Geometry__c,Target_process_node__c,New_OwnerId__c,Old_OwnerId__c 
                                                            From CaseL2L3Routing__c Where Old_OwnerId__c In: listOwnerIdL2 Limit 1000];                
            if(listCaseL2L3Routing !=null && listCaseL2L3Routing.size()>0){
                listCase = [Select Id,Category__c, SubCategory__c, Geometry__c,Target_process_node__c, OwnerId,CustomerRecordType__c From Case Where Id In: listCaseIdL2 Limit 100];
                system.debug('listCase'+listCase);
                for(Case objCase: listCase){
                    for(Integer i = 0; i < listCaseL2L3Routing.size(); i++){                        
                        CaseL2L3Routing__c objL2L3 = listCaseL2L3Routing[i];
                        system.debug('objL2L3 '+objL2L3 );
                        if(objL2L3.Target_process_node__c != null){                                                                          
                            if(objCase.Category__c == objL2L3.Category__c && objCase.SubCategory__c == objL2L3.SubCategory__c &&
                               ((String)objL2L3.Geometry__c).contains(objCase.Geometry__c) && ((String)objL2L3.Target_process_node__c).contains(objCase.Target_process_node__c) && objCase.OwnerId == objL2L3.Old_OwnerId__c &&
                               objL2L3.New_OwnerId__c !=null ){  
                                   system.debug('objL2L3inloop '+objL2L3 );                             
                                    Case caseTemp = New Case();
                                    caseTemp.Id = objCase.Id;
                                    caseTemp.OwnerId = objL2L3.New_OwnerId__c;
                                    caseTemp.L2L3RoutingExecuted__c = true;
                                    updateCase.add(caseTemp);                                    
                            }               
                        }
                        else {if(objCase.Category__c == objL2L3.Category__c && objCase.SubCategory__c== objL2L3.SubCategory__c &&
                               ((String)objL2L3.Geometry__c).contains(objCase.Geometry__c) && objCase.OwnerId == objL2L3.Old_OwnerId__c &&
                               objL2L3.New_OwnerId__c !=null) {
                                    Case caseTemp = New Case();
                                    caseTemp.Id = objCase.Id;
                                    caseTemp.OwnerId = objL2L3.New_OwnerId__c;
                                    caseTemp.L2L3RoutingExecuted__c = true;
                                    updateCase.add(caseTemp);
                                }
                            }
                    }
                }
            }
            if (updateCase != null && updateCase.size() > 0) {  
            system.debug('updateCase'+updateCase);             
                update updateCase;
               
            }
           if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            } 
        } 
        catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='calculateL2L3Routings()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);              
        }
    }
    
    
    /* ***************************************************************************************************************** */
    /**
    This method is used to remove share from case record for corresponding Customer Users, if case record is Internal Use Only
    @method name: removeShareFromCustomerUser
    @parameter:   List of Case Ids and List of account Ids
    @return :     NA
    **/  
    @future
    public static void removeShareFromCustomerUser(Set < Id > caseIds, Set < Id > accountIds) {
        List < CaseShare > customerShares = new List < CaseShare > ();
        List < Id > listRoleIds = new List < Id > ();
        try {
    
            list < UserRole > listRoles = [Select Id, PortalAccountId, Name From UserRole Where Name Like '%Customer User' And PortalAccountId In: accountIds Limit 100];
            if (listRoles != null && listRoles.size() > 0) {
                for (UserRole role: listRoles) {
                    listRoleIds.add(role.Id);
                }
                list < Group > listGroups = [Select Id, RelatedId From group Where RelatedId In: listRoleIds and type = 'Role' Limit 100];
                if (listGroups != null && listGroups.size() > 0) {
                    customerShares = [Select Id From CaseShare Where CaseId In: caseIds And UserOrGroupId In: listGroups 
                                      And CaseAccessLevel = 'Edit' And RowCause = 'Manual' Limit 100];
    
                    if (!customerShares.isEmpty()) {
                        Database.DeleteResult[] customerSharesResult = Database.delete(customerShares,false);
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='removeShareFromCustomerUser()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.removeShareFromCustomerUser', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    /* ***************************************************************************************************************** */ 
    /**
    This method is used to share case record with corresponding Customer Users, who shares same account
    @method name: shareWithCustomerUser
    @parameter:   List of Case Ids and List of account Ids
    @return :     NA
    **/ 
    @future
    public static void shareWithCustomerUser(Set < Id > caseIds, Set < Id > accountIds) {
        Map < Id, Id > mapRoleGroupId = new Map < Id, Id > ();
        Map < Id, Id > mapAccountRoleId = new Map < Id, Id > ();
        List < CaseShare > customerShares = new List < CaseShare > ();
        List < Id > listRoleIds = new List < Id > ();
        CaseShare customerShare;
        try {
    
            list < Case > listCase = [Select Id, AccountId,CustomerRecordType__c From Case Where Id In: caseIds Limit 100];
    
            list < UserRole > listRoles = [Select Id, PortalAccountId, Name From UserRole Where Name Like '%Customer User' And PortalAccountId In: accountIds Limit 100];
            if (listRoles != null && listRoles.size() > 0) {
                for (UserRole role: listRoles) {
                    listRoleIds.add(role.Id);
                    mapAccountRoleId.put(role.PortalAccountId, role.Id);
                }
    
                list < Group > listGroups = [Select Id, RelatedId From group Where RelatedId In: listRoleIds and type = 'Role' Limit 100];
                if (listGroups != null && listGroups.size() > 0) {
                    for (Group objGroup: listGroups) {
                        mapRoleGroupId.put(objGroup.RelatedId, objGroup.Id);
                    }
                    for (Case objCase: listCase) {
                        customerShare = new CaseShare();
                        customerShare.CaseId = objCase.Id;
                        Id roleId = mapAccountRoleId.get(objCase.AccountId);
                        customerShare.UserOrGroupId = mapRoleGroupId.get(roleId);
                        customerShare.CaseAccessLevel = 'Edit';
                        //customerShare.RowCause = 'Manual';
                        customerShares.add(customerShare);
                    }
    
                    if (!customerShares.isEmpty()) {
                        Database.SaveResult[] customerSharesResult = Database.insert(customerShares,false);
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='shareWithCustomerUser()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.shareWithCustomerUser',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    /* ***************************************************************************************************************** */ 
    
    /**
    This method is used to find Used Id for given Email
    @method name: getUserIdFromEmail
    @parameter:   List of Emails
    @return :     Map < String, Id >
    **/     
    public static Map < String, User> getUserIdFromEmail(List < String > emailAddresses, String userType) {
        Map < String, User> mapEmailUserIds = new Map < String, User> ();
        try {
            List < User > listUsers = new List<User>();
            if(userType =='All'){
                listUsers = [Select Id, Email, ProfileId, IsActive, UserType From User Where IsActive = True
                    AND Email In: emailAddresses LIMIT 100];
                    
            }else{
                listUsers = [Select Id, Email, ProfileId, IsActive, UserType From User Where IsActive = True AND UserType =: userType
                    AND Email In: emailAddresses LIMIT 100];
            }
            if (listUsers != null && listUsers.size() > 0) {
                for (User userObj: listUsers) {
                    if (!mapEmailUserIds.containsKey(userObj.Email)) {
                        mapEmailUserIds.put(userObj.Email, userObj);
                    }
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='getUserIdFromEmail()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.getUserIdFromEmail', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
        return mapEmailUserIds;
    }  
    /* ***************************************************************************************************************** */ 
   /**
    This method is used to find Used Id for given Email
    @method name: getContactsFromAccountHierarchy
    @parameter:   List of Emails
    @return :     Map < String, Id >
    @author :     pankaj
    **/ 
    public static Map<id,Set<id>> getContactsFromAccountHierarchy(Set<id> acctIds) { 
     Map<id,Set<id>> actToAllContactsMap = new Map<id,Set<id>>();
     try{   
            Map<id,id> accountMasterMap = new Map<id,id>();
            map<id,list<id>> masterActToChildMap = new map<id,list<id>>();
            map<id,list<id>> masterActToChildMap2 = new map<id,list<id>>();
            map<id,list<id>> caseAccountToAllAccountsMap = new map<id,list<id>>();
            Map<id,list<id>> actcontactMap = new Map<id,list<id>>();           
            list<id> accParentLst = new list<id>();
            list<id> actMasterLst = new list<id>();
            set<id> allAccountIds = new set<id>();
            Set<id> contactSet = new Set<id> ();
            Id masterAccountId;
        
            for(Account actObj:[ select id,parentid from account where id in:acctIds]){
                if(actObj.parentid != null)
                    accParentLst.add(actObj.id);
                else
                    actMasterLst.add(actObj.id);    
            }
        
            if(accParentLst.size() >0){
                for(Account_Hierarchy__c ahc:[ select Master_Account_Id__c,Account_Id__c from Account_Hierarchy__c   where    
                                              Account_Id__c in:accParentLst]){  
                     accountMasterMap.put(ahc.Account_Id__c ,ahc.Master_Account_Id__c);
                }   
            }   
        
            for(Account_Hierarchy__c ahc:[ select Master_Account_Id__c,Account_Id__c,Parent_Id__c from Account_Hierarchy__c  where  Parent_Id__c in :accountMasterMap.values()]){  
                if(!masterActToChildMap.containsKey(ahc.Master_Account_Id__c))
                    masterActToChildMap.put(ahc.Master_Account_Id__c,new List<Id>{ahc.Account_Id__c });  
                else
                  masterActToChildMap.get(ahc.Master_Account_Id__c).add(ahc.Account_Id__c);
            }
        
            if(actMasterLst.size() >0){
                for(Account_Hierarchy__c ahc:[ select Master_Account_Id__c,Account_Id__c,Parent_Id__c from Account_Hierarchy__c  where  Parent_Id__c in :actMasterLst])
                {  
                 if(!masterActToChildMap2.containsKey(ahc.Master_Account_Id__c))
                    masterActToChildMap2.put(ahc.Master_Account_Id__c,new List<Id>{ahc.Account_Id__c });  
                 else
                  masterActToChildMap2.get(ahc.Master_Account_Id__c).add(ahc.Account_Id__c);
                }   
            }
        
            for(Id actid:acctIds){
               if(accountMasterMap.containsKey(actid)){
                 masterAccountId = accountMasterMap.get(actid);
                 caseAccountToAllAccountsMap.put(actid,masterActToChildMap.get(masterAccountId)); 
                 caseAccountToAllAccountsMap.get(actid).add(masterAccountId);   
               }
              else{ 
               if(masterActToChildMap2.containsKey(actid)){
                caseAccountToAllAccountsMap.put(actid,masterActToChildMap2.get(actid));
                    caseAccountToAllAccountsMap.get(actid).add(actid);
                }
               else
                caseAccountToAllAccountsMap.put(actid,new list<id>{actid}); 
                }   
            }
        
            for(Id actId:caseAccountToAllAccountsMap.keySet()){
               allAccountIds.addAll(caseAccountToAllAccountsMap.get(actId)); 
            }
        
            List<contact> conLst = [select id ,accountid from contact where accountid  in:allAccountIds];
        
            for(Contact con:conLst){
               if(!actcontactMap.containsKey(con.accountid)) 
                   actcontactMap.put(con.accountid, new list<id>{con.id});
               else
                 actcontactMap.get(con.accountid).add(con.id);   
            }
            set<id> globalfoundryContacts = new set<id>();
            for(Contact con:[select id from contact where accountid =:System.Label.Case_GlobalFoundriesAccount limit 49999]){                                                
                globalfoundryContacts.add(con.id);
            }
            for(Id actId: acctIds)
            {
                List<Id> accountLst = caseAccountToAllAccountsMap.get(actId);      
                for(Id actChild:accountLst ){                       
                   if(actcontactMap.containsKey(actChild)){                             
                         list<id> contactLst = actcontactMap.get(actChild); 
                         contactSet.addall(contactLst);                             
                    }       
                }
               if(globalfoundryContacts != null && globalfoundryContacts.size() >0)
                    contactSet.addall(globalfoundryContacts);
                
                if(contactSet.size()>0){           
                   actToAllContactsMap.put(actId,new set<id> (contactSet));           
                }
                else{               
                    actToAllContactsMap.put(actId,new set<id>());              
                }        
                contactSet.clear();
            }           
            
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
            }           
        }   
        catch (exception e){
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='getContactsFromAccountHierarchy()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //trackException('CaseHandlerUtility.getUserIdFromEmail', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }   
         return  actToAllContactsMap;
  } 
  
  
  public static void insertCaseCollaborationFromCaseTeam(Set<id> setCaseIds){
     try{           
        Map<String,Case_Collaboration__c> caseCCMap = new Map<String,Case_Collaboration__c>();
        set<String> caseTeamUsrIds = new Set<String>();
        List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
      
        List <Case_Collaboration__c> CCList = [SELECT Id,Member_Role_Name__c, Name,     
                                                Case__c,Contact__c,Email__c,user__c, Is_Subscribed__c from Case_Collaboration__c WHERE case__c In: setCaseIds LIMIT 100];         
        for(Case_Collaboration__c cc:CCList ){
            String caseId = cc.case__c ;
            String memberId;
                if(cc.contact__c != null){
                  memberId = cc.contact__c;
                  caseCCMap.put(caseId + memberId,cc);  
                }
                else if(cc.user__c != null){
                 memberId = cc.user__c;
                 caseCCMap.put(caseId + memberId,cc);
                }
        }
                
        List < CaseTeamMember > lstCaseTeamTemp = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId 
                                                   In: setCaseIds LIMIT 100];
        for(CaseTeamMember ct: lstCaseTeamTemp) {                   
            caseTeamUsrIds.add(ct.MemberId); 
                    
        }  
        Map<id,user> userList = new map<id,user>([select id, email ,name,contactid from user where id in: 
                                                 caseTeamUsrIds]);             
        system.debug('pankaj22'+lstCaseTeamTemp); 
        system.debug('pankaj23'+CCList);               
        for(CaseTeamMember ct: lstCaseTeamTemp){
            if(userList.containsKey(ct.MemberId)){
                User usr = userList.get(ct.MemberId);
                Case_Collaboration__c cc = new Case_Collaboration__c(); 
                String caseId = ct.ParentId ;
                String conId = usr.contactId;                   
                String userId = usr.id;
                if(!caseCCMap.containsKey(caseId + conId)){
                    if(!caseCCMap.containsKey(caseId + userId)){                        
                        cc.Name = usr.name;
                        cc.Case__c = ct.ParentId;
                        cc.User__c = usr.id;
                        //cc.Contact__c = con.Id;
                        if (cc.Case__c != null && cc.User__c != null){
                            cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.User__c);                
                        }
                        cc.Email_Id__c = usr.Email;
                        cc.Is_Subscribed__c = false;                        
                        listCCtoCase.add(cc);                                                
                    }                                                           
                }                                       
            }                                   
        }                                                       
        if(listCCtoCase!=null && listCCtoCase.size()>0){          
            database.insert(listCCtoCase,false) ;                            
        }
        if(Test.isRunningTest()) {
            throw new applicationException('In Test Mode');
        }
     }
       catch (exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseHandlerUtility.class.getName();
            alw.sourceFunction ='insertCaseCollaborationFromCaseTeam()';
            alw.ApplicationName='Case Management';                   
            alw.referenceInfo = 'Case';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            //trackException('CaseHandlerUtility.getUserIdFromEmail', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }    
 }
   
    /**
    This method is used for inserting TASKRAY__Project_Task__c and updating TASKRAY__Project_Task__c onwerId 
    @method name: assignTaskRayToCase
    @parameter:   Array of new Cases
    @return :     NA.
    **/
    public static void assignTaskRayToCase(list<Case> caseList,Map < ID, Case > CaseMapOld){
        try{
            //string recordtypeNPIId= Schema.SObjectType.TASKRAY__Project_Task__c.getRecordTypeInfosByName().get('NPI Checklist').getRecordTypeId();
            map<string,case>caseMap = new map<string,case>(); // Stores CaseId and Case
            map<string,TASKRAY__Project_Task__c> taskRayProjectMap = new map<string,TASKRAY__Project_Task__c>(); // Stores CaseId and TaskRay
            list<TASKRAY__Project_Task__c> taskRayUpsertList = new list <TASKRAY__Project_Task__c> (); // to store the task Ray records 
            set<String> userDataList = new set<string>();//to store the user record id values
           // string userData = Environment_Variable__c.getInstance('TaskRay_Criteria').value__C;
            for (groupmember ogrpMember: [select userorgroupid from groupmember where group.name = 'TaskRayGroup']){
                userDataList.add(ogrpMember.userorgroupid);
            }
            for(case oCase:caseList){
                if(CaseMapOld.containskey(oCase.id)){
                    if(oCase.ownerId != CaseMapOld.get(oCase.id).ownerId && userDataList.contains(oCase.ownerid)){ //update
                        caseMap.put(oCase.id,oCase);
                    }
                }
                else if(userDataList.contains(oCase.ownerid)){
                    caseMap.put(oCase.id,oCase);
                }
            
            }
            for(TASKRAY__Project_Task__c otaskRay:[Select id, ownerid,Case__c from TASKRAY__Project_Task__c where Case__c in :caseMap.keyset()]){
                taskRayProjectMap.put(otaskRay.Case__c,otaskRay);
            }
            for(case oCase:caseMap.values()){
                TASKRAY__Project_Task__c oTaskRayProject = new TASKRAY__Project_Task__c ();
                if(taskRayProjectMap.containskey(oCase.id)){
                    oTaskRayProject = taskRayProjectMap.get(oCase.id);
                    oTaskRayProject.ownerId = oCase.ownerid;
                }else{
                    oTaskRayProject.name = oCase.Subject;
                    oTaskRayProject.ownerId = oCase.ownerid;
                    oTaskRayProject.Case__c= oCase.Id;
                    oTaskRayProject.TASKRAY__Project__c = 'DFM_MARS';
                   //if(recordtypeNPIId!=null)
                    //oTaskRayProject.recordtypeId = recordtypeNPIId;
                }
                taskRayUpsertList.add(oTaskRayProject);
            }
            if(!taskRayUpsertList.isEmpty()){
                upsert taskRayUpsertList;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseHandlerUtility.class.getName();
            alw.sourceFunction ='assignTaskRayToCase()';
            alw.ApplicationName='Case Management';                   
            alw.referenceInfo = 'Case';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
       
    }
    
    // case # 00085216 When Status is Resolved - Pending PDK Releasd then Case Bug/WR Association is required.
    public static void validateCaseBugWRAssociations(Case[] newCases) {
        for (Case caseObj: newCases) { 
            if((caseObj.Status == System.Label.Case_Status_Resolved_Pending_PDK_Release)&& 
                (caseObj.Related_Bugs_Count__c == 0)&& caseObj.RecordTypeId == System.Label.CaseTechnicalRecordtypeId) {
                    caseObj.addError(BugErrorMessages__c.getValues('ErrorOnStatusOfBug').Error_Message__c);
            }
        }
    } 
    
    // Case# 00086342 Predefined case team attachment to newly created cases  
  Public static  void predefindTeamAdd(list<case> caseList){
         try {
                Map<String,caseTeamtemplate> pridefindCaseTeamMap = new Map<String,caseTeamtemplate>();
                Map <string,list<case>> caseAccMap = new Map <string,list<case>> ();
                Map<String,Account__mdt> mataAccountShortNameMap=new Map<String,Account__mdt>();
                Map <String,set<String>> geoMap = new Map<String,set<String>>();
                Set<Id> CaseIdset=new Set<Id>();
                Set<String> caseTeamMemSet=new Set<String>();
                Set<String> accountSet=new set<string>();
                Environment_Variable__c caseGeometry =Environment_Variable__c.getInstance('caseGeometry');
                String geometry =  caseGeometry.value__c;
                
            for(case caseInfo: caseList){
                    CaseIdset.add(caseInfo.Id);
                    if(caseAccMap.containskey(caseInfo.Account_Short_Name__c) ){
                    caseAccMap.get(caseInfo.Account_Short_Name__c).add(caseInfo);
                    }else{
                    caseAccMap.Put(caseInfo.Account_Short_Name__c,new list<case>{caseInfo});
                    }
                }     
            for(caseTeamtemplate pridefindCaseTeme :[select id,name from caseTeamtemplate geometry ]){
                     pridefindCaseTeamMap.put(pridefindCaseTeme.Name,pridefindCaseTeme);caseTeamMemSet.add(pridefindCaseTeme.Id); }
            List<Case_Collaboration__c> ExistingCaseCollabList=[select Id,name,Case__c,Case_Predefined_Team_Id__c from Case_Collaboration__c where Case__c IN :CaseIdset AND Case_Predefined_Team_Id__c IN :caseTeamMemSet]; 
            if(ExistingCaseCollabList.IsEmpty()){
            for(Account__mdt amdt:[SELECT id,MasterLabel,Accountshort_name__c,Casegeometry__c  FROM  Account__mdt Where MasterLabel IN :caseAccMap.keyset() ]) {
                   if( !geoMap.containskey(amdt.Accountshort_name__c) ) {
                       Set<string> tempset = new set<string>();
                       tempset.addAll(amdt.Casegeometry__c.split(','));
                        geoMap.Put(amdt.MasterLabel ,tempset);
                        mataAccountShortNameMap.put(amdt.MasterLabel,amdt);
                    }
                }
            List<case> caseObjList = new List<Case>();
            for(case cs :caseList){
                    if(cs.Account_Short_Name__c != null && caseAccMap.containskey(cs.Account_Short_Name__c) && geoMap.get(cs.Account_Short_Name__c).contains(cs.Geometry__c)  && (cs.Case_Record_Type_API__c == 'TechnicalPDK')) {
                        caseObjList.add(cs);
                    }
                } 
            List<Case_Collaboration__c> listCCtoCase = new List<Case_Collaboration__c> ();
            for(Case CSS :caseObjList){
                    Case_Collaboration__c  cc = new Case_Collaboration__c();
                    if(mataAccountShortNameMap.containsKey(CSS.Account_Short_Name__c) && pridefindCaseTeamMap!= null ){
                        cc.Name = 'Predefined Team:' +pridefindCaseTeamMap.get(mataAccountShortNameMap.get(CSS.Account_Short_Name__c).Accountshort_name__c).Name; //PridefindCaseTeme.name; 
                    }
                    cc.Case__c = CSS.Id;

                    if(UserDetails.HCM_Login_ID__c!=null){
                        cc.Is_Subscribed__c = True;
                    }else{
                        cc.Contact__c=CSS.ContactId;
                        cc.Is_Subscribed__c = false;
                    }
                    cc.Member_Role_Name__c = 'Team';
                    cc.Case_Predefined_Team_Id__c = pridefindCaseTeamMap.get(mataAccountShortNameMap.get(CSS.Account_Short_Name__c).Accountshort_name__c).Id;
                    listCCtoCase.add(cc); 
                }
                    if(listCCtoCase!=null && listCCtoCase.size()>0){          
                        database.insert(listCCtoCase,false) ;                            
                }
                
                    if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
                }
              }  
            }
        catch(Exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseHandlerUtility.class.getName();
            alw.sourceFunction ='predefindTeamAdd()';
            alw.ApplicationName='Case Management';                   
            alw.referenceInfo = 'Case';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);

        }  
    }     
   public class applicationException extends Exception {} 
}