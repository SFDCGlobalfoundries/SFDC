/*
Type Name: CaseTriggerHandler
Author: Cognizant
Created Date: 27/07/2014
Reason: Reason: This is the generic class for CaseTrigger
Test Class: CaseTriggerHandlerTest
Change History:Added Account Check case no:00074425
Author: Cognizant
Modified Date: 7/10/2017
……..//
……..
--
*/
public class CaseTriggerHandler {
    public static Boolean isOwnershipCount = false;  // Added to Remove Duplicate Case Comment or Chatter Comment when Case Assigned User is Out of Office.

    //final Map < String, CaseRecordTypes__c > mapCaseRecordTypes = CaseRecordTypes__c.getall(); //This Custom Setting will hold customer cases related record types.    
    final Map < String, CaseAssignmentRules__c > mapCaseAssignmentRules = CaseAssignmentRules__c.getall(); //This will hold the Category values where custom assignment process is not applicable.        
    
    Map < Id, Id > mapCaseOwnerId = New Map < Id, Id > (); //  Stored AccountId as Key and OwnerId as Value from Account Team Proxy    
    Map < Id, Id > mapCaseOOO = New Map < Id, Id > (); //  Stored OwnerId as Key and DelegatedUser as Value from Out of Office    
    Map < String, Id > mapCaseTeamMem = new Map < String, Id > (); //  Stored TeamMemberId from Case Team Member ..
    Map < String, CaseTeamMember > mapCaseTeamMembers = new Map < String, CaseTeamMember > (); //  Stored TeamMemberId from Case Team Member 
    Map < Id, String > ownerMap = new Map < Id, String > (); //  Stored OwnerId from Out of Office
    Map < Id, Case > mapCase = new Map < Id, Case > ();
    Map < Id, Id > mapConatctUser = new Map < Id, Id > ();
    List < Case > caseList = New List < Case > ();
    List < Case > caseListOOO = New List < Case > ();
    List < Case > listInternalCase = new List < Case > (); //  Stored Case Id for Internal Only Case . 
    List < CaseComment > lstcasecomments = new List < CaseComment > ();
    List < CaseTeamMember > lstCaseteamMember = new List < CaseTeamMember > ();
    List < CaseTeamMember > lstCaseTeamMemberTemp = new List < CaseTeamMember > ();
    List < CaseTeamMember > lstCaseteamMemberDel = new List < CaseTeamMember > ();
    List < User > lstUser = new List < User > ();
    List < Id > teamRoomIds = New List < Id > (); // Team Rooms Ids
    
    Set < Id> lstCaseCollaboration = new Set< Id>();
    Set < Id> lstCaseCollaborationDel = new Set< Id> ();
    Set < Id > setCaseId = new Set < Id > ();
    Set < Id > ownerIds = new Set < Id > ();    
    Set < Id > lstContact = new Set < Id > ();
    Set < Id > lstAccountContact = new Set < Id > ();
    Set<string> recordTypesAssignment = new Set<String>{'Logistics', 'TechnicalPDK'};
   
    Boolean isPublicCommentPermitted;
    
    /**
    Constructor of the Class
    @Constructor name: 
    @parameter:   NA.
    @return :     NA.
    **/
    public CaseTriggerHandler(boolean isExecuting, integer size) {
    }
   
    /***************************************************************** Case object ************************************************************************************ */
    /**
    This method is used from CaseTrigger.
    @method name: OnBeforeInsertCase
    @trigger: CaseTrigger
    @event: Before Insert
    @parameter:   Array of new Cases.
    @return :     NA.
    **/
    public void OnBeforeInsertCase(Case[] newCases) {
        CaseHandlerUtility.isCompleted  = false;
        ValueInitialization(newCases);
        //MasterPDKValidation(newCases); //This functionality no longer needed
        If(UserInfo.getUserType() == 'Standard' || Test.isRunningTest()) {
            DuplicateEmailtoCase(newCases);
        }
        CaseAssignmentProcessOnInsert(newCases);
        CaseHandlerUtility.isCompleted = true;
    }
    
    /**
    This method is used from CaseTrigger.
    @method name: OnBeforeUpdateCase
    @trigger: CaseTrigger
    @event: Before Update
    @parameter:   Array of new oldCases,updatedCases,CaseMap .
    @return :     NA.
    **/
    public void OnBeforeUpdateCase(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMap) {
        
        CaseHandlerUtility.isCompleted = false; 
        
        
        if (!Test.isRunningTest()){
           //ByPassvalidationRule(oldCases, updatedCases); 
        } 
        If(UserInfo.getUserType() == 'Standard') {
            InternalOnlyCaseValidation(oldCases, updatedCases);
            EditPermissionValidation(oldCases, updatedCases, CaseMap);
     
        }
        ClosedByOwnerOnlyValidation(oldCases, updatedCases, CaseMap);
        AdditionalInformationUpdate(oldCases, updatedCases, CaseMap);
        CaseAssignmentProcessOnUpdate(oldCases, updatedCases, CaseMap);
       // CaseSupportLevelCalculationOnUpdate(oldCases, updatedCases, CaseMap);
        //getGroupsForIds(updatedCases); 
        CaseHandlerUtility.isCompleted = true;
    }
    
    /**
    This method is used from CaseTrigger.
    @method name: OnAfterInsertCase
    @trigger: CaseTrigger
    @event: After Insert
    @parameter:   Arry of newCases.
    @return :     NA.
    **/
    public void OnAfterInsertCase(Case[] newCases) {
        CaseHandlerUtility.isCompleted = false;
        TeamMemberOnInsert(newCases);
        If(UserInfo.getUserType() == 'Standard') {
            PublicCommentsOnInsert(newCases);
            RequestorAndContactAccessOnInsert(newCases);   
            CaseAssignmentProcessSFDCSupport(newCases);
        }        
        CaseAssignmentProcessStandard(newCases);        
        CaseApexSharingRecalculationOnInsert(newCases);
        caseTimelineOnInsert(newCases);
       // CaseHandlerUtility.predefindTeamAdd(newCases);
        //getGroupsForIds(newCases);
        CaseHandlerUtility.isCompleted = true;
        CaseHandlerUtility.assignTaskRayToCase(newCases, new Map < ID, Case >());
    }
    
    /**
    This method is used from CaseTrigger.
    @method name: OnAfterUpdateCase
    @trigger: CaseTrigger
    @event: After Update
    @parameter:   Array of oldCases, updatedCases, CaseMapOld.
    @return :     NA.
    **/
    public void OnAfterUpdateCase(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMapOld) {
		if(RecursionPrevent.runOnce()){
            CaseHandlerUtility.predefindTeamAdd(updatedCases);
        }
		
        CaseHandlerUtility.isCompleted = false;
        PublicCommentsOnUpdate(oldCases, updatedCases, CaseMapOld);
        ApprovalProcessesSubmission(oldCases, updatedCases, CaseMapOld);
        If(UserInfo.getUserType() == 'Standard') {            
            TeamMemberOnUpdate(oldCases, updatedCases, CaseMapOld);
            RequestorAndContactAccessOnUpdate(oldCases, updatedCases, CaseMapOld);
            onCaseAccountUpdate(oldCases, updatedCases, CaseMapOld);
        }        
        CaseAssignmentProcessStandard(updatedCases);
        CaseApexSharingRecalculationOnUpdate(oldCases, updatedCases, CaseMapOld);
        caseTimelineOnUpdate(oldCases, updatedCases, CaseMapOld);
        //CaseSupportLevelCalculationOnUpdate(oldCases, updatedCases, CaseMapOld);
        CaseHandlerUtility.validateCaseBugWRAssociations(updatedCases);
        getGroupsForIds(updatedCases);
        
        CaseHandlerUtility.isCompleted = true; 
        CaseHandlerUtility.assignTaskRayToCase(updatedCases,CaseMapOld);
    }
    
    /***************************************************************** Chatter(FeedItem) object ********************************************************************************* */
    /**
    This method is used from CaseFeedItemTrigger.
    @method name: OnBeforeInsertFeedItem
    @trigger: CaseFeedItemTrigger
    @event: Before Insert
    @parameter:   Array of newFeedItems.
    @return :     NA.
    **/
    public void OnBeforeInsertFeedItem(FeedItem[] newFeedItems) {        
        If(UserInfo.getUserType() == 'Standard') {
            FeedItemValidation(newFeedItems);
        }
    }
    
    /**
    This method is used from CaseFeedItemTrigger.
    @method name: OnAfterInsertFeedItem
    @trigger: CaseFeedItemTrigger
    @event: After Insert
    @parameter:   Array of newFeedItems.
    @return :     NA.
    **/
    public void OnAfterInsertFeedItem(FeedItem[] newFeedItems) {
        CaseHandlerUtility.isCompleted = false;
        askCustomerORaskGFfunctionality(newFeedItems);
        if( UserInfo.getUserType() != 'Guest'){
            LastChatterFeedItemUpdateOnInsert(newFeedItems);
        }
        CaseHandlerUtility.isCompleted = true;
    }
    
    /***************************************************************** Case Comment Object **************************************************************************** */
    /**
    This method is used from CaseCommentTrigger.
    @method name: OnBeforeInsertCaseComment
    @trigger: CaseCommentTrigger
    @event: Before Insert
    @parameter:   Array of newCaseComments.
    @return :     NA.
    **/
    public void OnBeforeInsertCaseComment(CaseComment[] newCaseComments) {
        If(UserInfo.getUserType() == 'Standard') {
            CaseCommentValidation(newCaseComments);
        }
    }
    /**
    This method is used from CaseCommentTrigger.
    @method name: OnBeforeUpdateCaseComment
    @trigger: CaseCommentTrigger
    @event: Before Update
    @parameter:   Array of oldCaseComments , updatedCaseComments , CaseCommentMap.
    @return :     NA.
    **/
    public void OnBeforeUpdateCaseComment(CaseComment[] oldCaseComments, CaseComment[] updatedCaseComments, Map < ID, CaseComment > CaseCommentMap) {
        If(UserInfo.getUserType() == 'Standard') {
            CaseCommentValidation(updatedCaseComments);
        }
    }
    /**
    This method is used from CaseCommentTrigger.
    @method name: OnAfterInsertCaseComment
    @trigger: CaseCommentTrigger
    @event: After Insert
    @parameter:   Array of newCaseComments.
    @return :     NA.
    **/
    public void OnAfterInsertCaseComment(CaseComment[] newCaseComments) {
        CaseHandlerUtility.isCompleted = false;
        if( UserInfo.getUserType() != 'Guest'){
            ChatterPostFromCaseComment(newCaseComments);
        }
        CaseHandlerUtility.isCompleted = true;
    }
    
    
    /**
    This method is used from CaseCommentTrigger.
    @method name: OnAfterUpdateCaseComment
    @trigger: CaseCommentTrigger
    @event: After Update
    @parameter:   Array of oldCaseComments, updatedCaseCommets, CaseCommentMapOld.
    @return :     NA.
    **/
    public void OnAfterUpdateCaseComment(CaseComment[] oldCaseComments, CaseComment[] updatedCaseComments, Map < ID, CaseComment> CaseCommentMapOld) {                
        if( UserInfo.getUserType() != 'Guest'){
            ChatterPostFromCaseComment(updatedCaseComments);
        }  
    }
    
    /***************************************************************** Case Collaboration object ********************************************************************** */
    /**
    This method is used from CaseCollaborationTrigger.
    @method name: OnAfterInsertCaseCollaboration
    @trigger: CaseCollaborationTrigger
    @event: After Insert
    @parameter:   Array of newCCtoCase.
    @return :     NA.
    **/
    public void OnAfterInsertCaseCollaboration(Case_Collaboration__c[] newCCtoCase) {
        CaseHandlerUtility.isCompleted = false;
        CaseCollaborationTeamMemberInsert(newCCtoCase);
        CaseHandlerUtility.isCompleted = true;
    }
    
    /**
    This method is used from CaseCollaborationTrigger.
    @method name: OnAfterUpdateCaseCollaboration
    @trigger: CaseCollaborationTrigger
    @event: After Update
    @parameter:   Arry of oldCCtoCase , updateCCtoCase , oldCCtoCaseMap.
    @return :     NA.
    **/
    public void OnAfterUpdateCaseCollaboration(Case_Collaboration__c[] oldCCtoCase, Case_Collaboration__c[] updateCCtoCase, Map < ID, Case_Collaboration__c > oldCCtoCaseMap) {
        CaseHandlerUtility.isCompleted = false;
        CaseCollaborationTeamMemberUpdate(oldCCtoCase, updateCCtoCase, oldCCtoCaseMap);
        CaseHandlerUtility.isCompleted = true;
    }
    /**
    This method is used from CaseCollaborationTrigger.
    @method name: OnAfterDeleteCaseCollaboration
    @trigger: CaseCollaborationTrigger
    @event: After Delete
    @parameter:   Arry of oldCCtoCase , updateCCtoCase.
    @return :     NA.
    **/
    public void OnAfterDeleteCaseCollaboration(Case_Collaboration__c[] oldCCtoCase, Case_Collaboration__c[] updateCCtoCase) {
        CaseHandlerUtility.isCompleted = false;
        CaseCollaborationTeamMemberDelete(oldCCtoCase, updateCCtoCase);
        CaseHandlerUtility.isCompleted = true;
    }
    
    /***************************************************************** Attachment Object **************************************************************************** */
    
    /**
    This method is used from CaseAttachmentTrigger.
    @method name: OnAfterInsertCaseAttachment
    @trigger: CaseAttachmentTrigger 
    @event: After Insert
    @parameter:   Arry of newCaseAttachments.
    @return :     NA.
    **/
    public void OnAfterInsertCaseAttachment(Attachment[] newCaseAttachments) {
        CaseHandlerUtility.isCompleted = false;        
        if( UserInfo.getUserType() != 'Guest'){
            ChatterPostFromCaseAttachment(newCaseAttachments);
        }
        CaseHandlerUtility.isCompleted = true;
    } 
    
    
    /***************************************************************** EmailMessage object ********************************************************************************* */
    /**
    This method is used from EmailMessageTrigger .
    @method name: OnAfterInsertEmailMessage
    @trigger: EmailMessageTrigger
    @event: After Insert
    @parameter:   Array of new EmailMessage .
    @return :     NA.
    **/
    public void OnAfterInsertEmailMessage(EmailMessage [] newEmailMessages) {
        InsertCaseTeamMembersFromCCList(newEmailMessages);
    }
    
    /****************************************************************************************************************************************************************** */  
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    /****************************************************************************************************************************************************************** */    
    /**
    This method is used for converting field set values into List of fields.
    @method name: ValueInitialization
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void ValueInitialization(Case[] newCases) {
        try {
            for (Case caseObj: newCases) {
                //Check if record type is related to Customer cases related record types.
                
                if (caseObj.CustomerRecordType__c) {
                    // Case Assignment Process will not work if Account and Contact is not selected
                   if (!(caseObj.AccountId == null && caseObj.ContactId == null)) {
                        
                        If(UserInfo.getUserType() != 'Standard') {
                            caseObj.Internal_or_external__c = false;
                            caseObj.Origin = System.Label.Case_Origin_Portal_User; // Origin value will be 'Global FV' for Portal Users
                            caseObj.Issue_Encountered_By__c = System.Label.Case_Issue_Encountered_By; // When the case is created by Customer the value is populated as "Customer" .
                        }
                    }
                    
                    //Case Status Change Dates a)Adding start dates
                    if (caseObj.Status == System.Label.Case_Status_Acknowledged) {
                        caseObj.Case_Acknowledged_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_Acknowledged__c = DateTime.Now();
                        caseObj.Is_Assignee_Acknowledged__c = true;
                    } else if (caseObj.Status == System.Label.Case_Status_Inprogress) {
                        caseObj.Case_Inprogress_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_In_Progress__c = DateTime.Now();
                    } else if (caseObj.Status == 'On Hold') {
                        caseObj.OnHold_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_OnHold__c = DateTime.Now();
                    } else if (caseObj.Status == System.Label.Case_Status_Resolved_Pending_PDK_Release) {                        
                        caseObj.Date_Time_Resolved_Pending_PDK_Release__c = DateTime.Now();
                    } else if (caseObj.Status == System.Label.Case_Status_Reopen) {
                        caseObj.Case_Reopen_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_Reopen__c = DateTime.Now();
                    } else if (caseObj.Status.contains('Closed')) {
                        if (caseObj.Status.contains('Verified')) {
                                caseObj.Verified_By__c = UserInfo.getUserId();
                                caseObj.Date_Time_Verified__c = DateTime.Now();
                         }else{
                            caseObj.Case_Closed_By__c = UserInfo.getUserId();
                            caseObj.Close_Date__c = DateTime.Now();
                        }
                    }
                    
                }
                // If the “Region Case Originated” is left blank this will be auto populated. (SWIFT Changes)    
                if (caseObj.Region__c == null) {caseObj.Region__c = caseObj.RegionCaseAccountMaping__c;}         
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ValueInitialization()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //CaseHandlerUtility.trackException('CaseTriggerHandler.ValueInitialization',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Master PDK Name Validation for Technical Cases for Corresponding Account or Account Related to Contact
    @method name: MasterPDKValidation
    @parameter:   Array of newCases.
    @return :     NA.
    ******************* This functionality no longer needed ********************
    private void MasterPDKValidation(Case[] newCases) {
        try {
            Boolean isNotPermited = false;
            List < String > listMasterPdk = new List < String > ();
            caseList = New List < Case > ();
            
            for (Case caseObj: newCases) {
                if (caseObj.Case_Record_Type_API__c == 'TechnicalPDK' && caseObj.Master_PDK__c != null) {
                    if (!(caseObj.AccountId == null && caseObj.ContactId == null)) {
                        caseList.add(caseObj);
                        listMasterPdk.add(caseObj.Master_PDK__c);
                    }
                }
            }
            if (caseList != null && caseList.size() > 0) {
                isNotPermited = CaseHandlerUtility.onCaseMasterPdkValidation(caseList, listMasterPdk);
            }
            
            for (Case caseObj: newCases) {
                if (isNotPermited) {caseObj.Master_PDK__c.addError(Label.Case_Master_PDK_validation);}
            }
        } catch (Exception e) {CaseHandlerUtility.trackException('CaseTriggerHandler.MasterPDKValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());}
    }
    **/
    
  /**
   public  void ByPassvalidationRule(Case[] oldCases, Case[] updatedCases){ 
        
            for(Case caseObj: updatedCases){
                if(caseObj.isFeedItem__c == true && caseObj.SkipValidationRuleInTrigger__c == true ){                   
                    caseObj.SkipValidationRuleInTrigger__c = true;
                    caseObj.isFeedItem__c = false;
                }
                else{
                        caseObj.SkipValidationRuleInTrigger__c = false;   
                }
                       
        }
        
    }
    
    **/
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Control the Visibility of any Case Based on Internal Use Only Check Box .
    @method name: InternalOnlyCaseValidation
    @parameter:   Array of oldCases , updatedCases.
    @return : NA    
    **/
    private void InternalOnlyCaseValidation(Case[] oldCases, Case[] updatedCases) {
        try {        
            caseList = new List < Case > (); //  Stored Case Id for AccountId\AccountThirdPart__c will be removed or not.    
            
            for (Case caseObj: updatedCases) {
                Integer j = 0;
                /* CC to Case Validation- If CCtoCase records exists system won't allow to change Account */
                /* **********Start ******************* */

                if (caseObj.CustomerRecordType__c && (UserInfo.getUserType() == 'Standard')) {
                    if ((caseObj.AccountId != oldCases[j].AccountId) || (caseObj.AccountThirdParty__c != oldCases[j].AccountThirdParty__c)) {
                        caseList.add(caseObj);
                    }
                    
                    if (caseObj.Internal_or_external__c != oldCases[j].Internal_or_external__c) {
                        if (caseObj.Internal_or_external__c && caseObj.CCtoCaseCount__c == 0) {
                            listInternalCase.add(caseObj);
                        }
                    }
                }
                /* CC to Case Validation- If CCtoCase records exists system won't allow to change Account */
                j++;
            }    
            
            /* CC to Case Validation- If CCtoCase records exists system won't allow to change Account */
            Map < Id, List < Case_Collaboration__c >> mapCCtoCase = new Map < Id, List < Case_Collaboration__c >> ();
            if (caseList != null && caseList.size() > 0) {
                mapCCtoCase = CaseHandlerUtility.onCCtoCaseAccountIdValidation(caseList);
            }
            
            /* Case Team Validation- If Contact records existsin Team system won't allow to change Internal Only Case settings*/
            Map < Id, Boolean > mapCaseTeam = new Map < Id, Boolean > ();
            
            if (listInternalCase != null && listInternalCase.size() > 0) {mapCaseTeam = CaseHandlerUtility.onCaseTeamContactValidation(listInternalCase);}
            
            for (Case caseObj: updatedCases) {
                Integer i = 0;
                if (caseObj.CustomerRecordType__c) {
                    
                    /* CC to Case Validation- If CCtoCase records exists system won't allow to change Account */
                    if (mapCCtoCase != null && mapCCtoCase.size() > 0) {
                        List < Case_Collaboration__c > cctoCase = new List < Case_Collaboration__c > ();
                        cctocase = mapCCtoCase.get(caseObj.Id);
                        if (cctoCase != null && cctoCase.size() > 0) {
                            for (Case_Collaboration__c cc: cctoCase) {                          
                                //Mona: Case Account change error Myra case 13june216 start
                                /*if ((caseObj.AccountId != oldCases[i].AccountId) && (oldCases[i].AccountId == cc.Contact__r.AccountId)) {
                                    caseObj.AccountId.addError(Label.CC_to_Case_remove_contacts);
                                }*/
                                if ((caseObj.AccountId != oldCases[i].AccountId) && (oldCases[i].AccountId == cc.Contact__r.AccountId) && oldCases[i].AccountId != Label.Case_GlobalFoundriesAccount) {
                                    caseObj.AccountId.addError(Label.CC_to_Case_remove_contacts);
                                }
                                
                                if ((caseObj.AccountThirdParty__c != oldCases[i].AccountThirdParty__c) && (oldCases[i].AccountThirdParty__c == cc.Contact__r.AccountId)) {
                                    caseObj.AccountThirdParty__c.addError(Label.CC_to_Case_remove_contacts);
                                }
                            }
                        }
                    }
                    
                    /* Case Team Validation- If Contact records existsin Team system won't allow to change Internal Only Case settings option**/
                    if (mapCaseTeam != null && mapCaseTeam.size() > 0) {
                        
                        Boolean isExists = (mapCaseTeam.get(caseObj.Id) != null) ? mapCaseTeam.get(caseObj.Id) : false;
                        if (isExists) {caseObj.addError(Label.Case_Internal_Use_Only_Team_Member_Validation_Error);}
                    }
                    /* CC to Case Validation- If CCtoCase records exists system won't allow to change Account */
                }
                i++;
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='InternalOnlyCaseValidation()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.InternalOnlyCaseValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to validate , only case Queue members can close the case.
    @method name: ClosedByOwnerOnlyValidation
    @parameter:   Array of oldCases , updatedCases.
    @return : NA    
    **/
   private void ClosedByOwnerOnlyValidation(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMap) {
        try {  
            Set<Id> ownerIds = new Set<Id>();
            Map < Id, List < Id >> mapGroupMembers = new Map < Id, List < Id >> ();
             
            for (Case caseObj: updatedCases) {
               
                if (caseObj.CustomerRecordType__c && ((String)caseObj.OwnerId).substring(0,3) == '00G'
                && ((String)caseObj.Status).contains('Closed')) {
                    Case oldCaseObj = CaseMap.get(caseObj.Id);
                    if(caseObj.Status != oldCaseObj.Status && (!((String)oldCaseObj.Status).contains('Closed'))
                    && caseObj.Close_Requested_Date__c == oldCaseObj.Close_Requested_Date__c){
                        if(!ownerIds.contains(caseObj.OwnerId))
                            ownerIds.add(caseObj.OwnerId);
                    }
                }
            }
            if(ownerIds !=null && ownerIds.size()>0){
                mapGroupMembers = CaseHandlerUtility.getGroupMembers(ownerIds);              
                for (Case caseObj: updatedCases) {
                    Boolean isError = true;
                    List<Id> groupMembers = mapGroupMembers.get(caseObj.OwnerId); 
                    if(groupMembers !=null && groupMembers.size()>0){
                        for(Id userId: groupMembers){
                            if(UserInfo.getUserId() == userId)
                                isError = false;
                        }
                    }
                    if(isError)
                        caseObj.Status.addError(Label.Case_Owner_Validation_Error_Message);
                }
            }
           if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ClosedByOwnerOnlyValidation()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.ClosedByOwnerOnlyValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
        
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Limit editing cases for users.This is for Swift only.In future it will be extended for other Teams
    @method name: EditPermissionValidation
    @parameter:   Array of oldCases , updatedCases.
    @return : NA    
    **/
    private void EditPermissionValidation(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMap) {
        try{    
            string swiftEmails = System.Label.Case_Swift_Email_for_Edit_Permission;  
            Integer SwiftMemberscount = CaseHandlerUtility.swiftMembersCount();
             
            for (Case caseObj: updatedCases) {    
                
                if (caseObj.Case_Record_Type_API__c=='External_System' && caseObj.Category__c=='Tapeout') {  
                    Case oldCaseObj = CaseMap.get(caseObj.Id);
                    if ((caseObj.AccountId != oldCaseObj.AccountId) || (caseObj.Region__c != oldCaseObj.Region__c) ||
                        (caseObj.Origin != oldCaseObj.Origin) || (caseObj.Description != oldCaseObj.Description) ||
                        (caseObj.Expected_Close_Date__c!= oldCaseObj.Expected_Close_Date__c) ||   (caseObj.Need_by_Date__c!= oldCaseObj.Need_by_Date__c)||
                        (caseObj.Subject != oldCaseObj.Subject) || (caseObj.AccountThirdParty__c != oldCaseObj.AccountThirdParty__c) ||
                        (caseObj.ParentId != oldCaseObj.ParentId) ||   (caseObj.Priority != oldCaseObj.Priority) ||
                        (caseObj.ContactId != oldCaseObj.ContactId ) ||   (caseObj.OwnerId != oldCaseObj.OwnerId ) ||
                        (caseObj.CaseOwner__c != oldCaseObj.CaseOwner__c) ||   (caseObj.Priority_stakeholder_Priority__c != oldCaseObj.Priority_stakeholder_Priority__c) ||                    
                        (caseObj.Category__c!= oldCaseObj.Category__c) ||   (caseObj.Business_process__c!= oldCaseObj.Business_process__c) ||
                        (caseObj.Classification__c != oldCaseObj.Classification__c) ||   (caseObj.Close_Comment__c!= oldCaseObj.Close_Comment__c) ||
                        (caseObj.Internal_or_external__c != oldCaseObj.Internal_or_external__c) ||   (caseObj.Subcategory__c!= oldCaseObj.Subcategory__c) ||
                        (caseObj.Support_Level__c != oldCaseObj.Support_Level__c) ||   (caseObj.Team_Room__c != oldCaseObj.Team_Room__c) ||  
                        (caseObj.Application__c != oldCaseObj.Application__c) ||   (caseObj.Estimation_of_Effort__c!= oldCaseObj.Estimation_of_Effort__c) ||  
                        (caseObj.Release_Task__c != oldCaseObj.Release_Task__c ) ||   (caseObj.Service_Now__c != oldCaseObj.Service_Now__c ) ||                       
                        (caseObj.isAssignment__c != oldCaseObj.isAssignment__c ) || (caseObj.Public__c != oldCaseObj.Public__c))
                    {
                        if (!(swiftEmails.containsIgnoreCase(UserInfo.getUserEmail()) || (SwiftMemberscount == 1)||
                              (caseObj.CreatedById==UserInfo.getUserId())|| (UserInfo.getProfileId() == System.Label.Case_Automated_User_ProfileId))){caseObj.addError(System.Label.Case_Swift_Edit_Restriction_Messages);}
                    }
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='EditPermissionValidation()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.EditPermissionValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }   
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Case Additional Information Update.
    At the Time of Update .
    @method name: AdditionalInformationUpdate
    @parameter:   Array of oldCases, updatedCases, CaseMap .
    @return :     NA.
    **/
    private void AdditionalInformationUpdate(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMap) {
        try {
            setCaseId = new Set < Id > ();
            List<Id> listCaseIdL2 = new List<Id>();
            List<Id> listOwnerIdL2 = new List<Id>();
            List<string> groupId = new List<string>();
            Set<Id> userL2Ids = new Set<Id>(); 
            List<string> l1SupportProfile = new List<string>();
            
            for (CaseL1SupportProfile__c key: CaseL1SupportProfile__c.getall().values()){
                    l1SupportProfile .add((string)key.Name);       
            }
            
            Map<Id,user> listL1Users = new Map<Id,user>([Select Id from user where  Profile.Name in :l1SupportProfile]); 
            List<Group> groupList = [select Id,Name,DeveloperName,Type,OwnerId from Group where DeveloperName='Level_2_Technical_Support' and Type='regular' LIMIT 1];             
            
            if(groupList.size() > 0) {                
                    for(Group groupObj : groupList){
                            groupId.add(groupObj.Id); // fetching groupId for Group member
                    }                           
              List<GroupMember> groupMemList = [Select GroupId, UserOrGroupId  from GroupMember where groupId IN:groupId];                    
                    if(groupMemList .size() > 0){ 
                            for (GroupMember groupMemObj : groupMemList) {   
                                userL2Ids.add(groupMemObj.UserOrGroupId);  
                            } 
                     }
             }
            
            for (Case caseObj: updatedCases) {
                Case oldCaseObj = CaseMap.get(caseObj.Id);
                if (caseObj.OwnerId != oldCaseObj.OwnerId) {
                    //Support Level changes
                    if(((String)caseObj.OwnerId).substring(0,3) == '00G'){
            if(((String)caseObj.OwnerQueueName__c).contains('ESD')){caseObj.Support_Level__c = 'L3';}
                        else if(((String)caseObj.OwnerQueueName__c).contains('L1')){caseObj.Support_Level__c = 'L1';}
                        else if(((String)caseObj.OwnerQueueName__c).contains('L2')){
                            caseObj.Support_Level__c = 'L2';
                            if((!caseObj.L2L3RoutingExecuted__c) && (caseObj.Case_Record_Type_API__c == 'TechnicalPDK')){
                                listCaseIdL2.add(caseObj.Id);
                                listOwnerIdL2.add(caseObj.OwnerId);
                            }
                        }
                        else if(((String)caseObj.OwnerQueueName__c).contains('L3')){caseObj.Support_Level__c = 'L3';}
                    }
                    else{                                                                     
                        if(userL2Ids.contains(caseobj.ownerid)){                       
                            caseObj.Support_Level__c = 'L2';
                         }
                        else if(listL1Users.keySet().contains(caseobj.ownerid)){
                            system.debug('*******pankaj1 in 2nd loop'); 
                            caseObj.Support_Level__c = 'L1';
                         }
                        else{
                            caseObj.Support_Level__c = 'L3';  
                         }  
                    }                                                                                                                                      
                    //status Reassigned
                    if ((!caseObj.Status.contains('Closed')) && caseObj.Status !='New'){                        
                        caseObj.Status = 'Reassigned';                        
                     }
                                                                   
                    }                 
                // Status Dates Tracking logic
                if (caseObj.Status != oldCaseObj.Status) {
                    if (caseObj.Status == System.Label.Case_Status_Acknowledged) {
                        caseObj.Case_Acknowledged_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_Acknowledged__c = DateTime.Now();
                        caseObj.Is_Assignee_Acknowledged__c = true;
                        caseObj.Date_Time_Acknowledged_End__c = null;
                    } else if (caseObj.Status == System.Label.Case_Status_Inprogress) {
                        caseObj.Case_Inprogress_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_In_Progress__c = DateTime.Now();
                        caseObj.Date_Time_In_Progress_End__c = null;
                    } else if (caseObj.Status == 'On Hold') {
                        caseObj.OnHold_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_OnHold__c = DateTime.Now();
                        caseObj.Date_Time_OnHold_End__c = null;
                    } else if (caseObj.Status == System.Label.Case_Status_Resolved_Pending_PDK_Release) {                        
                        caseObj.Date_Time_Resolved_Pending_PDK_Release__c = DateTime.Now();
                    } else if (caseObj.Status == System.Label.Case_Status_Reopen) {
                        caseObj.Case_Reopen_By__c = UserInfo.getUserId();
                        caseObj.Date_Time_Reopen__c = DateTime.Now();
                        caseObj.Reopen_As_New_Case__c = true;
                        if (caseObj.Reopen_Request_Status__c == 'Submitted' && caseObj.CustomerRecordType__c) {
                            caseObj.Reopen_Request_Status__c = 'Accepted';
                           setCaseId.add(caseObj.Id);
                        }
                        caseObj.Date_Time_Reopen_End__c = null;
                    } else if (caseObj.Status.contains('Closed')) {
                        if(!((String)oldCaseObj.Status).contains('Closed')) {
                            caseObj.Case_Closed_By__c = UserInfo.getUserId();
                            caseObj.Close_Date__c = DateTime.Now();
                            caseObj.isReopenBySurvey__c = false;
                        }else {
                            if (caseObj.Status.contains('Verified')) {
                                caseObj.Verified_By__c = UserInfo.getUserId();
                                caseObj.Date_Time_Verified__c = DateTime.Now();
                            }
                        }
                    }                                       
                    //End Dates
                    if (oldCaseObj.Status == 'New') {caseObj.Date_Time_New_End__c = DateTime.Now();}
                    else if (oldCaseObj.Status == System.Label.Case_Status_Acknowledged) {caseObj.Date_Time_Acknowledged_End__c = DateTime.Now();}
                    else if (oldCaseObj.Status == System.Label.Case_Status_Inprogress) {caseObj.Date_Time_In_Progress_End__c = DateTime.Now();}
                    else if (oldCaseObj.Status == 'On Hold') {caseObj.Date_Time_OnHold_End__c = DateTime.Now();}
                    else if (oldCaseObj.Status == System.Label.Case_Status_Reopen) {caseObj.Date_Time_Reopen_End__c = DateTime.Now();}
                }
                //Resolution Details
                if (caseObj.Resolution_Results__c != oldCaseObj.Resolution_Results__c) {
                    caseObj.Resolution_By__c = UserInfo.getUserId();
                    caseObj.Resolution_Date__c = DateTime.Now();
                }
                //Investigation Details
                if (caseObj.Investigation_Results__c != oldCaseObj.Investigation_Results__c) {
                    caseObj.Investigated_By__c = UserInfo.getUserId();
                    caseObj.Investigation_Date__c = DateTime.Now();
                }
                //Parent Case Id Update
                if (caseObj.ParentId != oldCaseObj.ParentId) {
                    caseObj.Parent_Case__c = caseObj.ParentId;
                }
                if (caseObj.Parent_Case__c != oldCaseObj.Parent_Case__c) {
                   caseObj.ParentId = caseObj.Parent_Case__c;
                }              
                
            }
            //calculate OwnerId for L2 L3 Routing
            if(listCaseIdL2 !=null && listCaseIdL2.size()>0){
                CaseHandlerUtility.calculateL2L3Routings(listCaseIdL2,listOwnerIdL2);
            }
            if (setCaseId != null && setCaseId.size() > 0) {
                CaseHandlerUtility.CaseAutoApproveProcess(setCaseId);
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='AdditionalInformationUpdate()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.AdditionalInformationUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }    
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for User Sharing on Cases 
    @method name: RequestorAndContactAccessOnInsert
    @parameter:   Array of new newCases.
    @return :     NA.
    **/
    private void RequestorAndContactAccessOnInsert(Case[] newCases) {
        try {
            setCaseId = new Set < Id > ();
            for (Case caseObj: newCases) {
                if (caseObj.ContactId != null) {
                    if (caseObj.Contact_Account_Short_Name__c == System.Label.GLOBALFOUNDRIES_Short_Name) {setCaseId.add(caseObj.Id);}
                }
            }            
            if (setCaseId != null && setCaseId.size() > 0) {
                CaseHandlerUtility.standardUsersPermissionOnCase(setCaseId);
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='RequestorAndContactAccessOnInsert()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    //CaseHandlerUtility.trackException('CaseTriggerHandler.RequestorAndContactAccessOnInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /**
    This method is used for User Sharing on Cases 
    @method name: RequestorAndContactAccessOnUpdate
    @parameter:   Array of oldCases, newCases And CaseMapOld
    @return :     NA.
    **/
    private void RequestorAndContactAccessOnUpdate(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld) {
        try {
            setCaseId = new Set < Id > ();
            for (Case caseObj: newCases) {   
                if(caseObj.ContactId !=null){
                    Case tempCase = CaseMapOld.get(caseObj.Id);
                    if (caseObj.ContactId != tempCase.ContactId ){
                        if(caseObj.Contact_Account_Short_Name__c == System.Label.GLOBALFOUNDRIES_Short_Name){setCaseId.add(caseObj.Id);}
                    }
                }
            }
            if (setCaseId!= null && setCaseId.size() > 0) {CaseHandlerUtility.standardUsersPermissionOnCase(setCaseId);}  
           if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }  
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='RequestorAndContactAccessOnUpdate()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.RequestorAndContactAccessOnUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Case Assignment Process Based on the Business Logic Implemented on CaseHandlerUtility Class .
    At the Time of Insertion .
    @method name: CaseAssignmentProcessOnInsert
    @parameter:   Array of newCases.
    @return :     NA.
    **/
     private void CaseAssignmentProcessOnInsert(Case[] newCases) {
        try {
            caseList = new List < Case > (); //
            
            for (Case caseObj: newCases) {
                //Check if record type is related to Customer cases related record types.
                
                if (recordTypesAssignment.contains(caseObj.Case_Record_Type_API__c) && caseObj.Origin != 'Email to Case') {//MM-added Case origin
                    // Case Assignment Process will not work if Account and Contact is not selected                          
                    if (!(caseObj.AccountId == null && caseObj.ContactId == null)) {                    
                        CaseAssignmentRules__c objRules = CaseAssignmentRules__c.getValues(caseObj.Category__c);
                        
                        if (objRules != null) {
                            if (objRules.AccountShortName__c != null && caseObj.Account_Short_Name__c != null) {
                                if (objRules.AccountShortName__c != caseObj.Account_Short_Name__c) {
                                    if (!caseObj.Internal_or_external__c) {caseList.add(caseObj);}
                                }
                            }else if((caseObj.UserLicense__c != 'Standard' || caseObj.Account_Short_Name__c != null) && caseObj.Category__c !=null) {                                
                                if ((!caseObj.Internal_or_external__c)&& ((string)caseObj.Category__c).contains('ESD')) {caseList.add(caseObj);}
                            }
                        } else {
                            if (!caseObj.Internal_or_external__c) {
                                caseList.add(caseObj);
                            }
                        }
                    }
                }
            }
            
            if (caseList != null && caseList.size() > 0) {
                
                mapCaseOwnerId = CaseHandlerUtility.onCaseAssignmentProcess(caseList); // Calculate Ownership based on the Account Team Proxy
                
                If(mapCaseOwnerId.size() > 0) {
                    for (Case c: newCases) {                        
                        c.isAssignment__c = false;
                        c.CaseOwner__c = (c.AccountId != null) ? mapCaseOwnerId.get(c.AccountId) : c.OwnerId; // for Portal Users only 
                        If(UserInfo.getUserType() == 'Standard') {
                            c.OwnerId = (c.AccountId != null) ? mapCaseOwnerId.get(c.AccountId) : c.OwnerId; // for Internal Users only                        
                            c.IsNew__c = false;                                
                            c.AutoAssignmentCount__c = (c.AutoAssignmentCount__c != null) ? (c.AutoAssignmentCount__c + 1) : 1;
                        }
                    }
                }
                
                mapCaseOOO = CaseHandlerUtility.onCaseAssignmentOutofOffice(newCases); // Calculate Ownership if orginal owner is in Out of Office
                
                If(mapCaseOOO.size() > 0) {
                    for (Case c: newCases) {
                        c.OutofOfficeOwner__c = c.OwnerId; // Stored the Orginal Owner, this owner will be insert as Case Team Member as  'Case Manager' role
                        c.OwnerId = (mapCaseOOO.get(c.OwnerId) != null) ? mapCaseOOO.get(c.OwnerId) : c.OwnerId;
                        c.CaseOwner__c = (mapCaseOOO.get(c.OwnerId) != null) ? mapCaseOOO.get(c.OwnerId) : c.OwnerId;
                    }
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseAssignmentProcessOnInsert()';
                    alw.ApplicationName='Case Management';                 
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseAssignmentProcessOnInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Case Assignment Process Based on the Business Logic Implemented on CaseHandlerUtility Class .
    At the Time of Update .
    @method name: CaseAssignmentProcessOnUpdate
    @parameter:   Array of oldCases, updatedCases , CaseMap.
    @return :     NA.
    **/
    private void CaseAssignmentProcessOnUpdate(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMap) {
        try {
            caseList = new List < Case > (); //
            for (Case caseObj: updatedCases) {
                if (recordTypesAssignment.contains(caseObj.Case_Record_Type_API__c)&& caseObj.Origin != 'Email to Case') {//MM-added Case origin             
                    if ((!(caseObj.AccountId == null && caseObj.ContactId == null) && (caseObj.IsNew__c))) {
                        CaseAssignmentRules__c objRules = CaseAssignmentRules__c.getValues(caseObj.Category__c);
                        if (objRules != null) {
                            if (objRules.AccountShortName__c != null && caseObj.Account_Short_Name__c != null) {
                                if (objRules.AccountShortName__c != caseObj.Account_Short_Name__c) {
                                    if (!caseObj.Internal_or_external__c) {caseList.add(caseObj);}
                                }
                            }else if((caseObj.UserLicense__c != 'Standard' || caseObj.Account_Short_Name__c != null) && caseObj.Category__c !=null){                                
                                if ((!caseObj.Internal_or_external__c) && ((string)caseObj.Category__c).contains('ESD')) {caseList.add(caseObj);}
                            }
                        } else {
                            if (!caseObj.Internal_or_external__c) {caseList.add(caseObj);}
                        }
                    }                    
                }
                if (caseObj.CustomerRecordType__c) {
                    Case oldCaseObj = CaseMap.get(caseObj.Id);
                    if ((caseObj.OwnerId != oldCaseObj.OwnerId || caseObj.IsNew__c) && ((string)caseObj.OwnerId).startsWith('005')) { 
                        caseListOOO.add(caseObj);
                    }
                }
            }
            
            if (caseList != null && caseList.size() > 0) {
                mapCaseOwnerId = CaseHandlerUtility.onCaseAssignmentProcess(caseList); // Calculate Ownership based on the Account Team Proxy
                If(mapCaseOwnerId.size() > 0) {
                    for (Case c: updatedCases) {
                        if (c.IsNew__c) {                            
                            c.CaseOwner__c = (c.AccountId != null) ? mapCaseOwnerId.get(c.AccountId) : c.OwnerId; //Account Team Member Assigned    
                            c.OwnerId = (c.AccountId != null) ? mapCaseOwnerId.get(c.AccountId) : c.OwnerId;
                            c.OutofOfficeOwner__c = null;
                            c.IsNew__c = false;
                            c.isAssignment__c = false;
                            c.AutoAssignmentCount__c = (c.AutoAssignmentCount__c != null) ? (c.AutoAssignmentCount__c + 1) : 1;
                            c.Support_Level__c = 'L1';
                            caseListOOO.add(c);
                        }
                    }
                }
            }
            
            if (caseListOOO != null && caseListOOO.size() > 0) {
                mapCaseOOO = CaseHandlerUtility.onCaseAssignmentOutofOffice(caseListOOO); // Calculate Ownership if orginal owner is in Out of Office
                
                If(mapCaseOOO.size() > 0) {
                    for (Case c: updatedCases) {
                        c.OutofOfficeOwner__c = c.OwnerId; // Stored the Orginal Owner, this owner will be insert as Case Team Member as  'Case Manager' role
                        c.OwnerId = (mapCaseOOO.get(c.OwnerId) != null) ? mapCaseOOO.get(c.OwnerId) : c.OwnerId;
                    }
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseAssignmentProcessOnUpdate()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseAssignmentProcessOnUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Standard Case Assignment Process where Applicable .
    @method name: CaseAssignmentProcessStandard
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void CaseAssignmentProcessStandard(Case[] newCases) {
        try {
            List < Case > tempCaseList  = new List < Case >();
            List < Id > caseIds = new List < Id > {};
                caseList = New List < Case > ();
            
            for (Case caseObj: newCases) {
                if ((caseObj.CustomerRecordType__c) && (caseObj.isAssignment__c)) {
                    
                    if (mapCaseAssignmentRules.containsKey(caseObj.Category__c)) {
                        CaseAssignmentRules__c objRules = CaseAssignmentRules__c.getValues(caseObj.Category__c);
                        if (objRules != null) {
                            if (objRules.AccountShortName__c != null && caseObj.Account_Short_Name__c != null) {
                                if (objRules.AccountShortName__c == caseObj.Account_Short_Name__c) {caseIds.add(caseObj.Id);}
                            } else{caseIds.add(caseObj.Id);}
                        }
                    }else if(caseObj.Case_Record_Type_API__c=='External_System'){
                        //All internal only and customer cases of this type to be routed to different queue
                        caseIds.add(caseObj.Id);
                    }
                    
                    if (caseIds != null && caseIds.size() > 0) {
                        if (!(caseObj.AccountId == null && caseObj.ContactId == null)) {  
                            if (!caseObj.Internal_or_external__c){tempCaseList.add(caseObj);}
                        }
                    }
                }                
            }
            
            if (caseIds != null && caseIds.size() > 0) {
                if (tempCaseList != null && tempCaseList.size() > 0){mapCaseOwnerId = CaseHandlerUtility.onCaseAssignmentProcess(tempCaseList);} // Calculate Ownership based on the Account Team Proxy
                
                for (Case c: [SELECT Id, AccountId, Region__c, RegionCaseAccountMaping__c FROM Case WHERE Id in : caseIds]) {
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    c.OutofOfficeOwner__c = null;
                    If(mapCaseOwnerId.size() > 0){c.CaseOwner__c = (c.AccountId != null) ? mapCaseOwnerId.get(c.AccountId) : c.OwnerId;}
                    
                    c.IsNew__c = false;
                    c.isAssignment__c = false;
                    c.AutoAssignmentCount__c = (c.AutoAssignmentCount__c != null) ? (c.AutoAssignmentCount__c + 1) : 1;
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    c.setOptions(dmo);
                    caseList.add(c);
                }
                Database.update(caseList, false);
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseAssignmentProcessStandard()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseAssignmentProcessStandard',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for SFDc Support Case Assignment auto trigger on Insert.
    @method name: CaseAssignmentProcessStandard
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void CaseAssignmentProcessSFDCSupport(Case[] newCases) {
        try {
            List < Id > caseIds = new List < Id > {};
                caseList = New List < Case > ();
            for (Case caseObj: newCases) {
                 if (caseObj.Case_Record_Type_API__c=='Internal_Case'){caseIds.add(caseObj.Id);}
            }
            if (caseIds != null && caseIds.size() > 0) {
                for (Case c: [SELECT Id FROM Case WHERE Id in : caseIds]) {
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    c.IsNew__c = false;
                    c.isAssignment__c = false;
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    c.setOptions(dmo);
                    caseList.add(c);
                }
                Database.update(caseList, false);
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseAssignmentProcessSFDCSupport()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseAssignmentProcessSFDCSupport',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to share case record with corresponding Customer Users, who shares same account at the Time of Insertion .
    @method name: CaseApexSharingRecalculationOnInsert
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void CaseApexSharingRecalculationOnInsert(Case[] newCases) {
        try {
                Map < String, CaseSharingPortalAccountId__c > mapPortalAccountId = CaseSharingPortalAccountId__c.getall(); //This Custom Setting will hold account Ids where apex sharing is not applicable.    
                setCaseId = new Set<Id>();
                Set<Id> setAccountId = new Set<Id>();
                for (Case objCase: newCases) {
                    if (objCase.CustomerRecordType__c) {
                         if (!(objCase.Internal_or_external__c)) {
                            if (!(objCase.AccountId == null && objCase.ContactId == null)) {
                                 if(objCase.AccountId !=null ){
                                     if(!mapPortalAccountId.containsKey(((string)objCase.AccountId).substring(0, 15))) {
                                         setAccountId.add(objCase.AccountId);
                                     }
                                 }else if(objCase.Contact.AccountId !=null ){
                                     if(!mapPortalAccountId.containsKey(((string)objCase.Contact.AccountId).substring(0, 15))) {
                                         setAccountId.add(objCase.Contact.AccountId);
                                     }
                                 }
                                 if(!setAccountId.isEmpty())
                                         setCaseId.add(objCase.Id);
                             }
                         }
                    }
                } 
                if(setCaseId != null && setCaseId.size()>0){CaseHandlerUtility.shareWithCustomerUser(setCaseId, setAccountId);}
                 if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }    
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseApexSharingRecalculation()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseApexSharingRecalculation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to share case record with corresponding Customer Users, who shares same account at the Time of Insertion .
    @method name: CaseApexSharingRecalculationOnUpdate
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void CaseApexSharingRecalculationOnUpdate(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld) {
        try {
                Map < String, CaseSharingPortalAccountId__c > mapPortalAccountId = CaseSharingPortalAccountId__c.getall(); //This Custom Setting will hold account Ids where apex sharing is not applicable.    
                setCaseId = new Set<Id>();
                Set<Id> setAccountId = new Set<Id>();
                Set<Id> setCaseIdDel = new Set<Id>();
                Set<Id> setAccountIdDel = new Set<Id>();
                
                for (Case objCase: newCases) {                
                    if (objCase.CustomerRecordType__c) {
                         Case objOldCase = CaseMapOld.get(objCase.Id);
                         if((objCase.Internal_or_external__c != objOldCase.Internal_or_external__c)||
                            (objCase.AccountId != objOldCase.AccountId)){
                                 if(!objCase.Internal_or_external__c){
                                     if (!(objCase.AccountId == null && objCase.ContactId == null)){
                                             if(objCase.AccountId !=null ){
                                                 if(!mapPortalAccountId.containsKey(((string)objCase.AccountId).substring(0, 15))) {
                                                     setAccountId.add(objCase.AccountId);
                                                 }
                                             }else if(objCase.Contact.AccountId !=null ){
                                                 if(!mapPortalAccountId.containsKey(((string)objCase.Contact.AccountId).substring(0, 15))) {
                                                     setAccountId.add(objCase.Contact.AccountId);
                                                 }
                                             }
                                             if(!setAccountId.isEmpty())
                                                     setCaseId.add(objCase.Id);
                                     }
                                     if (!(objOldCase.AccountId == null && objOldCase.ContactId == null)){
                                         if (objCase.AccountId != objOldCase.AccountId) {
                                                 if(objOldCase.AccountId !=null){
                                                       if(!(setAccountIdDel.contains(objOldCase.AccountId) && mapPortalAccountId.containsKey(((string)objCase.AccountId).substring(0, 15))))
                                                           setAccountIdDel.add(objOldCase.AccountId);
                                                       if(!setAccountIdDel.isEmpty())
                                                           setCaseIdDel.add(objCase.Id);
                                                }
                                          }
                                      }
                                 }else{
                                     if(objOldCase.AccountId !=null){
                                           if(!(setAccountIdDel.contains(objOldCase.AccountId) && mapPortalAccountId.containsKey(((string)objOldCase.AccountId).substring(0, 15))))
                                               setAccountIdDel.add(objOldCase.AccountId);
                                           if(!setAccountIdDel.isEmpty())
                                               setCaseIdDel.add(objCase.Id);
                                      }          
                             }
                         }
                    }
                } 
                if(setCaseIdDel != null && setCaseIdDel.size()>0){CaseHandlerUtility.removeShareFromCustomerUser(setCaseIdDel, setAccountIdDel);}
                if(setCaseId != null && setCaseId.size()>0){CaseHandlerUtility.shareWithCustomerUser(setCaseId, setAccountId);}
                if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseApexSharingRecalculationOnUpdate()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseApexSharingRecalculation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Restrict the User to Post Public Comments according to their Profile at the time of INSERT ..
    @method name: PublicCommentsOnInsert
    @parameter:   Array of new Cases.
    @return :   NA
    **/
    private void PublicCommentsOnInsert(Case[] newCases) {
        try {
            for (Case objCase: newCases) {
                if (objCase.CustomerRecordType__c) {
                    if (!ownerIds.contains(objCase.OwnerId)) {ownerIds.add(objCase.OwnerId); }
                    if (!ownerIds.contains(objCase.OutofOfficeOwner__c)) {ownerIds.add(objCase.OutofOfficeOwner__c);}
                }
            }    
            if (ownerIds.size() > 0) {
                User[] users = [SELECT Id, Name FROM User WHERE Id IN: ownerIds AND IsActive = true LIMIT 100];
                for (Integer i = 0; i < users.size(); i++) {
                    ownerMap.put(users[i].Id, users[i].Name);
                }
            }
            
            for (Case myCase: newCases) {
                if (myCase.CustomerRecordType__c) {
                    // Check if Case Comment when Case Assigned User is Out of Office is already added or not .
                    if(!isOwnershipCount){
                        if (myCase.OutofOfficeOwner__c != null) {
                            String OOOMessage = ownerMap.get(myCase.OutofOfficeOwner__c) + ' ' + System.Label.Out_of_Office_Comments + ' ' + ownerMap.get(myCase.OwnerId);
                            if(myCase.Last_Case_Comments__c != OOOMessage ){
                                // To Add Case Comment when Case Assigned User is Out of Office.
                                CaseComment cc = new CaseComment(CommentBody = OOOMessage, parentID = myCase.Id, IsPublished = false);
                                lstcasecomments.add(cc);
                                isOwnershipCount = true; // Execute only once .
                            }
                        }
                    }                    
                }
            }
            if (lstcasecomments != null && lstcasecomments.size() > 0) {
                insert lstcasecomments;
            }
          if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }   
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='PublicCommentsOnInsert()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.PublicCommentsOnInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    } 
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Restrict the User to Post Public Comments according to their Profile at the time of UPDATE ..
    and Addition of Out of Office Comments .
    @method name: PublicCommentsOnUpdate
    @parameter:   Array of oldCases , newCases , CaseMapOld.
    @return :     NA.
    **/
    private void PublicCommentsOnUpdate(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld) {
        try {
            isPublicCommentPermitted = CaseHandlerUtility.onCasePublicCommentValidation();                        
            lstcasecomments = new List < CaseComment > ();
            for (Case objCase: newCases) {
                if (objCase.CustomerRecordType__c) {
                    if (!ownerIds.contains(objCase.OwnerId)) {
                        ownerIds.add(objCase.OwnerId);
                    }
                    if (!ownerIds.contains(objCase.OutofOfficeOwner__c)) {
                        ownerIds.add(objCase.OutofOfficeOwner__c);
                    }
                }
            }
            
            if (ownerIds.size() > 0) {
                User[] users = [SELECT Id, Name FROM User WHERE Id IN: ownerIds AND IsActive = true LIMIT 100];
                for (Integer i = 0; i < users.size(); i++) {
                    ownerMap.put(users[i].Id, users[i].Name);
                }
            }
            
            for (Case myCase: newCases) {
                if (myCase.CustomerRecordType__c) {                               
                    if ((myCase.Public_comments__c != CaseMapOld.get(myCase.Id).Public_comments__c) && (myCase.Public_comments__c != '') && (myCase.isClosed)  && (CaseHandlerUtility.isWorkflowExecuted)) {
                        String strUserType = UserInfo.getUserType();
                        String caseId = myCase.ID;                        
                        CaseHandlerUtility.isWorkflowExecuted = false;                        
                        if (strUserType == 'Standard') { // For Internal Users
                            CaseComment cc = new CaseComment(CommentBody = myCase.Public_comments__c, parentID = caseId, IsPublished = myCase.Public__c);                                                                                   
                            if (isPublicCommentPermitted == true && myCase.Public__c == false) {
                                lstcasecomments.add(cc);
                            } else if (isPublicCommentPermitted == true && myCase.Public__c == true) {
                                lstcasecomments.add(cc);
                            } else if (isPublicCommentPermitted == false && myCase.Public__c == true) {
                                myCase.addError(Label.Case_Comment_Restriction_Error_Message);
                                break;
                            } else {
                                lstcasecomments.add(cc);
                            }
                        } else { // For Other Users                                                                       
                            CaseComment cc = new CaseComment(CommentBody = myCase.Public_comments__c, parentID = caseId, IsPublished = true);
                            lstcasecomments.add(cc);
                        }
                    }
                    
                    // To Add Case Comment when Case Assigned User is Out of Office ..
                    // Check if Case Comment when Case Assigned User is Out of Office is already added or not .
                    if(!isOwnershipCount){
                        if (myCase.OutofOfficeOwner__c !=null && myCase.OutofOfficeOwner__c != CaseMapOld.get(myCase.Id).OutofOfficeOwner__c) {
                            if (ownerMap.get(myCase.OutofOfficeOwner__c) !=null && ownerMap.get(myCase.OwnerId) != null) {
                                String OOOMessage = ownerMap.get(myCase.OutofOfficeOwner__c) + ' ' + System.Label.Out_of_Office_Comments + ' ' + ownerMap.get(myCase.OwnerId);
                                if(myCase.Last_Case_Comments__c != OOOMessage ){
                                    CaseComment cc = new CaseComment(CommentBody = OOOMessage, parentID = myCase.Id, IsPublished = false);
                                    lstcasecomments.add(cc);
                                    isOwnershipCount = true; // Execute only once .
                                }
                            }                  
                        }
                    }
                    // To Add Reopen Comment when Case Reopen Requested by customer.
                    if ((myCase.Survey_Comments__c != CaseMapOld.get(myCase.Id).Survey_Comments__c) && (myCase.Survey_Comments__c!= '') && (myCase.isClosed) && (myCase.Reopen_Request_Status__c=='Submitted')) {
                        String strUserType = UserInfo.getUserType();
                        String caseId = myCase.ID;
                        
                        if (strUserType != 'Standard') { // For Internal Users
                            string reopenUser = '';
                            if( UserInfo.getUserType() == 'Guest'){reopenUser = myCase.Survey_re_Open_User__c;}
                            else{reopenUser = UserInfo.getName();}
                            
                            string strReopenComment = System.Label.Case_Reopen_Request_Message1 + ' ' + reopenUser + '.\n' + System.Label.Case_Reopen_Request_Message2 + ' ' + myCase.Survey_Comments__c;
                            CaseComment cc = new CaseComment(CommentBody = strReopenComment, parentID = caseId, IsPublished = true);
                            lstcasecomments.add(cc);
                        } 
                    }
                }
            }
            if (lstcasecomments != null && lstcasecomments.size() > 0 ) {            
                insert lstcasecomments;
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='PublicCommentsOnUpdate()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.PublicCommentsOnUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }     
        
    }  
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Submit ApprovalProcesses for Cases.
    @method name: ApprovalProcessesSubmission
    @parameter:   Array of oldCases , newCases , CaseMapOld.
    @return :     NA.
    **/
    private void ApprovalProcessesSubmission(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld) {
        try {
            List<Approval.ProcessSubmitRequest> lstprocess=new List<Approval.ProcessSubmitRequest>();
            
            for (Integer i = 0; i < Trigger.new.size(); i++) { 
                if (newCases[i].CustomerRecordType__c && newCases[i].Reopen_Request_Status__c == 'Submitted'  &&  oldCases[i].Reopen_Request_Status__c <> newCases[i].Reopen_Request_Status__c ) {
                    
                    // create the new approval request to submit
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setSubmitterId(newCases[i].CreatedById);
                    req.setComments(newCases[i].Survey_Comments__c);
                    req.setObjectId(Trigger.new[i].Id);
                    
                    lstprocess.add(req);
                } 
            }
            // submit the approval request for processing
            //Approval.ProcessResult result = Approval.process(req);
            // display if the request was successful
            if(lstprocess != null && lstprocess.size() > 0){
                List<Approval.ProcessResult> resultlist = Approval.process(lstprocess);
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ApprovalProcessesSubmission()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.ApprovalProcessesSubmission',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }       
    }   
    
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for converting field set values into List of fields.
    @method name: ChatterPostFromCaseComment
    @parameter:   Arry of new CaseComments.
    @return :     NA.
    **/
    private void ChatterPostFromCaseComment(CaseComment[] newCaseComments) {
        try {
            List<FeedItem> feedItemList = New List <FeedItem> ();
            
            for (CaseComment t: newCaseComments) {
                FeedItem objFeedItem = New FeedItem();
                objFeedItem.parentId = t.ParentId;
                objFeedItem.Body = t.CommentBody;
                // Check if Chatter Comment when Case Assigned User is Out of Office is already added or not .
                if(!isOwnershipCount){
                    if(t.IsPublished){objFeedItem.VISIBILITY = 'AllUsers';}
                    else{objFeedItem.VISIBILITY = 'InternalUsers';}
                    feedItemList.add(objFeedItem);
                }
            }
            
            if (feedItemList != null && feedItemList.size() > 0) {
                insert feedItemList;
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ChatterPostFromCaseComment()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.ChatterPostFromCaseComment',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for converting field set values into List of fields.
    @method name: ChatterPostFromCaseComment
    @parameter:   Arry of new CaseComments.
    @return :     NA.
    **/
    
     private void ChatterPostFromCaseAttachment(Attachment[] newAttachments) {
        try {  
                 
            Boolean isPublic = true;
            String communityId = null;
            Set<Id> caseAttchIds = new Set<Id>();
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

            If(UserInfo.getUserType() == 'Standard') {isPublic = CaseHandlerUtility.onCasePublicCommentValidation();}
            else{communityId = Network.getNetworkId();} 
            
            Set < Id > listAttachmentDel = new Set < Id > ();
            for (Attachment attach: newAttachments) {
                            
                CaseHandlerUtility.feedAttachFlag = false;                 
                listAttachmentDel.add(attach.Id);                
                caseAttchIds.add(attach.ParentId);
                                
                ConnectApi.BinaryInput newChatterFile = new ConnectApi.BinaryInput(attach.Body, 'ContentPost', attach.Name);                                              
                ConnectApi.ContentCapabilityInput contentInput = new ConnectApi.ContentCapabilityInput();
                contentInput.title = attach.name;

                ConnectApi.FeedElementCapabilitiesInput capabilities = new ConnectApi.FeedElementCapabilitiesInput();
                capabilities.content = contentInput;
                                
                ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
                //input.attachment = cai;
                input.capabilities = capabilities;
                input.subjectId = attach.ParentId;
                input.feedElementType = ConnectApi.FeedElementType.FeedItem;
                
                if(isPublic){input.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;}
                else{input.visibility = ConnectApi.FeedItemVisibilityType.InternalUsers;}
                //TargetRecordId is the record id of the chatter feed you want to post on
                
                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input,newChatterFile);
                batchInputs.add(batchInput);
            }
            if(batchInputs.size() > 0 && batchInputs != null){
                ConnectApi.ChatterFeeds.postFeedElementBatch(communityId, batchInputs);
            }
            
            if(caseAttchIds != null && caseAttchIds.size() > 0) { 
                CaseHandlerUtility.feedAttachFlag = true;           
                CaseHandlerUtility.caseLastChatterFeedItemAttachmentUpdate(caseAttchIds);
            }           
            if (listAttachmentDel != null && listAttachmentDel.size() > 0) {           
                CaseHandlerUtility.caseAttachmentDelete(listAttachmentDel);
            }
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ChatterPostFromCaseAttachment()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.ChatterPostFromCaseAttachment',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Duplicate Email to Case Creation with Case Status "Closed Duplicate" Business Logic 
    when Email send with same Case Subject .
    @method name: DuplicateEmailtoCase
    @parameter:   Array of newCases.
    @return :     
    **/
    private void DuplicateEmailtoCase(Case[] newCases) {
        try {
            String[] prefixes = new String[] {
                'fw:',
                're:',
                'aw:',
                'wg:',
                'fwd:'
            };
            Set < String > emailtoCaseInternal = new Set < String > ();
            Set < String > emailtoCaseSwift = new Set < String > ();
            Set < String > emailtoCaseTech = new Set < String > ();
            Set < String > emailtoCaseLogistics = new Set < String > ();
            List < Id > accIds = new List < Id > ();
            List < Id > conIds = new List < Id > ();
            List < Contact > conList;
            List < Account_Team_Proxy__c > atpList;
            Map < String, Id > mapEmail_Account = new Map < String, Id > (); //Map of emailId and associated account
            Map < String, Id > mapEmail_Owner = new Map < String, Id > (); //Map of emailId and associated DTS userId
            Map < Id, Id > mapAccIdUserId = new Map < Id, Id > (); //Map of accountId and associated DTS userId
            //Mona-End
            Id defaultSwiftOwnerId;
            Group[] queues = [select Id, Name from Group where Name = 'Swift Support'
                And Type = 'Queue'
                Limit 1
            ];
            defaultSwiftOwnerId = queues[0].Id;
            
            for (Case emailCase: newCases) {
                if ((emailCase.subject != null) && (emailCase.SuppliedEmail != null)) {
    
                    String emailSubject = emailCase.subject;
                    String target = emailSubject.toLowerCase();                                   
                    if ((emailCase.Case_Record_Type_API__c == 'Internal_Case') && (emailCase.Origin == 'Email')) {
                        for (String prefix: prefixes) {
                            Integer index = target.indexOf(prefix);
                            if (index == 0) {
                                String mainSubject = emailSubject.substring(prefix.length(), emailSubject.length());
                                emailtoCaseInternal.add(mainSubject.trim());
                                break;
                            }
                        }
                    } else if ((emailCase.Case_Record_Type_API__c == 'External_System') && (emailCase.Origin == 'Email to Case')) {
                        if (defaultSwiftOwnerId != null) {
                            emailCase.OwnerId = defaultSwiftOwnerId;
                        }
                        emailCase.Internal_or_external__c = false;
                        emailCase.isAssignment__c = false;
                        emailCase.Category__c = System.Label.Case_Category_Tapeout_Swift;
                        emailCase.Issue_Encountered_By__c = System.Label.Case_Issue_Encountered_By; // When the case is created by Customer the value is populated as "Customer" .
                        // If the “Region Case Originated” is left blank this will be auto populated. (SWIFT Changes)
                        if (emailCase.Region__c == null) {
                            emailCase.Region__c = emailCase.RegionCaseAccountMaping__c;
                        }
    
                        for (String prefix: prefixes) {
                            Integer index = target.indexOf(prefix);
                            if (index == 0) {
                                String mainSubject = emailSubject.substring(prefix.length(), emailSubject.length());
                                emailtoCaseSwift.add(mainSubject.trim());
                                break;
                            }
                        }
                    }                     
                }
            }
            //Internal_Case
            if (emailtoCaseInternal != null && emailtoCaseInternal.size() > 0) {                       
                Case[] matchingCases = [SELECT Id, Subject, Status, Contact_Account_Name__c FROM Case where Case_Record_Type_API__c = 'Internal_Case'
                    AND SuppliedEmail != NULL AND Subject in : emailtoCaseInternal AND CreatedDate = LAST_N_DAYS: 5 ORDER BY CreatedDate DESC
                ];
    
                // Checking for Duplicate Cases from Email to Case and Status Update ..
    
                if (matchingCases.size() > 0) {
                    for (Case caseObj: newCases) {
                        for (Integer j = 0; j < matchingCases.size(); j++) {
                            if ((caseObj.Case_Record_Type_API__c == 'Internal_Case') && (caseObj.subject != null) && (caseObj.SuppliedEmail != null) && (caseObj.Origin == 'Email')) {
                                String subject = caseObj.subject;
                                String emailSubject = subject.substring(3).trim();
    
                                if (emailtoCaseInternal.contains(emailSubject) && emailSubject == matchingCases[j].subject) {
                                    caseObj.ParentId = matchingCases[j].Id;
                                    caseObj.Status = 'Closed - Duplicate';
                                    caseObj.DuplicateEmailtoCase__c = true;
                                    caseObj.Case_Link_Parent__c = System.Label.Case_Link_for_Internal_User + matchingCases[j].Id; //Link stored for Portal Users                       
                                }
                            }
                        }
                    }
                }
            }
    
            // External_System
            if (emailtoCaseSwift != null && emailtoCaseSwift.size() > 0) {
    
                Case[] matchingCases = [SELECT Id, Subject, Status, Contact_Account_Name__c FROM Case WHERE Case_Record_Type_API__c = 'External_System'
                    AND SuppliedEmail != NULL AND Subject in : emailtoCaseSwift AND CreatedDate = LAST_N_DAYS: 5 ORDER BY CreatedDate DESC
                ];
    
                // Checking for Duplicate Cases from Email to Case and Status Update
    
                if (matchingCases.size() > 0) {
                    for (Case caseObj: newCases) {
                        for (Integer j = 0; j < matchingCases.size(); j++) {
                            if ((caseObj.Case_Record_Type_API__c == 'External_System') && (caseObj.subject != null) && (caseObj.SuppliedEmail != null) && (caseObj.Origin == 'Email to Case')) {
                                String subject = caseObj.subject;
                                String emailSubject = subject.substring(3).trim();
    
                                if (emailtoCaseSwift.contains(emailSubject) && emailSubject == matchingCases[j].subject && caseObj.Contact_Account_Name__c == matchingCases[j].Contact_Account_Name__c) {
                                    caseObj.ParentId = matchingCases[j].Id;
                                    caseObj.Status = 'Closed - Duplicate';
                                    caseObj.DuplicateEmailtoCase__c = true;
                                    caseObj.Case_Link_Parent__c = System.Label.Case_Link_for_Internal_User + matchingCases[j].Id; //Link stored for Portal Users                       
                                }
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
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='DuplicateEmailtoCase()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
           // CaseHandlerUtility.trackException('CaseTriggerHandler.DuplicateEmailtoCase', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Insert or Update Case TeamMembers according to their Team Role at the time of Case INSERT .
    @method name: TeamMemberOnInsert
    @parameter:   Array of newCases.
    @return :     NA.
    **/
    private void TeamMemberOnInsert(Case[] newCases) {
        try {
            Map < String, CasePredefinedTeam__c > mapCasePredefinedTeam  = CasePredefinedTeam__c.getall();            
            List < String > emailAddresses = new List < String > ();
            List < String > emailAddressesTechAndLogistics = new List < String > (); //MM- created
            Map < String, User> mapEmailUserIdsTechLog = new Map < String, User> (); //MM- created
            Map < String, User> mapEmailUserIds = new Map < String, User> ();
            caseList = New List < Case > ();
            Set<Id> caseIds = new Set<Id>();  
            Set<Id> teamParentIds = new Set<id>();                    
            List < CaseTeamTemplateRecord > listCaseTeam = new List < CaseTeamTemplateRecord > ();
            
            for (Case objCase: newCases) {
                setCaseId.add(objCase.Id);
                if (objCase.Team_Room__c != null) {
                    caseIds.add(objCase.Id);
                    teamRoomIds.add(objCase.Team_Room__c);
                }
                /*MM- before implementing email to case for logistics and technical
                if(objCase.SuppliedEmail !=null){
                    emailAddresses.add(objCase.SuppliedEmail);
                }*/
                //MM: Case generated from email-to-case and is of Technical/Logistics record type
                if(objCase.SuppliedEmail !=null){
                    if(objCase.RecordTypeId == System.Label.CaseTechnicalRecordtypeId || objCase.RecordTypeId == System.Label.CaseLogisticsRecordtypeId){
                        emailAddressesTechAndLogistics.add(objCase.SuppliedEmail);
                    }else
                        emailAddresses.add(objCase.SuppliedEmail);
                }
                //MM-end
                // to add predefined Case Team
                if(objCase.Account_Short_Name__c != null && mapCasePredefinedTeam.containsKey(objCase.Account_Short_Name__c) && objCase.CustomerRecordType__c){
                   if(objCase.Internal_or_external__c){
                       string preDefinedTeamId = (mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).Internal_Team__c;
                       if(isNotBlank((mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).Internal_Team__c)){
                           CaseTeamTemplateRecord objCaseTeam = new CaseTeamTemplateRecord(ParentId = objCase.Id, TeamTemplateId = (mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).Internal_Team__c);
                           listCaseTeam.add(objCaseTeam);
                        }
                     }else{
                       if(isNotBlank((mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).Internal_Team__c)){
                           CaseTeamTemplateRecord objCaseTeam = new CaseTeamTemplateRecord(ParentId = objCase.Id, TeamTemplateId = (mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).Internal_Team__c);
                           listCaseTeam.add(objCaseTeam);
                        } 
                        if(isNotBlank((mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).External_Team__c)){
                           CaseTeamTemplateRecord objCaseTeam = new CaseTeamTemplateRecord(ParentId = objCase.Id, TeamTemplateId = (mapCasePredefinedTeam.get(objCase.Account_Short_Name__c)).External_Team__c);
                           listCaseTeam.add(objCaseTeam);
                        }
                        
                     }
                   }
            }
            
            if (teamRoomIds != null && teamRoomIds.size() > 0) {CaseHandlerUtility.teamRoomMembersPermissionOnCase(caseIds, teamRoomIds);}
            
            List < CaseTeamMember > lstCaseTeamMemberTemp = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId In: setCaseId LIMIT 100];
            for (CaseTeamMember ct: lstCaseTeamMemberTemp) {
                String ParentId = ct.ParentId;
                String MemberId = ct.MemberId;
                mapCaseTeamMem.Put(ParentId + MemberId, ct.Id);
            }
            if(emailAddresses !=null && emailAddresses.size() > 0){
                mapEmailUserIds = CaseHandlerUtility.getUserIdFromEmail(emailAddresses, 'Standard');
            }
            //MM: Case generated from email-to-case and is of Technical/Logistics record type
            if(emailAddressesTechAndLogistics !=null && emailAddressesTechAndLogistics.size() > 0){
                mapEmailUserIdsTechLog = CaseHandlerUtility.getUserIdFromEmail(emailAddressesTechAndLogistics, 'All');
            }
            for (Case objCase: newCases) {
                String ParentId = objCase.Id;                
                if (UserInfo.getProfileId() != System.Label.Case_Automated_User_ProfileId) {
                    String MemberId1 = objCase.CreatedById;
                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                        Case tempCase = new Case();
                        tempCase.Id = objCase.Id;   
                        tempCase.Originator__c = objCase.CreatedById;                 
                        caseList.add(tempCase);
                        //Case Creator is Added to the Case Team with a Team Role - Case Creator.
                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id,objCase.CreatedById,System.Label.Case_Team_Role_Id_Case_Creator));
                        mapCaseTeamMem.Put(ParentId + MemberId1, null);
                    }
                }else if(objCase.UserLicense__c == 'Standard' && objCase.SuppliedEmail !=null && mapEmailUserIds.get(objCase.SuppliedEmail ) != null){
                    String MemberId1 = mapEmailUserIds.get(objCase.SuppliedEmail).Id;
                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                        Case tempCase = new Case();
                        tempCase.Id = objCase.Id;
                        tempCase.Originator__c = mapEmailUserIds.get(objCase.SuppliedEmail).Id;    
                        if(objCase.Case_Record_Type_API__c !='Internal_Case')
                            tempCase.Internal_or_external__c = false;             
                        caseList.add(tempCase);
                        //Case Requestor is Added to the Case Team with a Team Role - Case Creator.
                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id,mapEmailUserIds.get(objCase.SuppliedEmail).Id,System.Label.Case_Team_Role_Id_Case_Creator));
                        mapCaseTeamMem.Put(ParentId + MemberId1, null); 
                    }
                }
                //MM- added
                else if(objCase.SuppliedEmail !=null && mapEmailUserIdsTechLog.get(objCase.SuppliedEmail ) != null){
                    String MemberId1 = mapEmailUserIdsTechLog.get(objCase.SuppliedEmail).Id;
                    
                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                        Case tempCase = new Case();
                        tempCase.Id = objCase.Id;
                        tempCase.Originator__c = mapEmailUserIdsTechLog.get(objCase.SuppliedEmail).Id;
                        caseList.add(tempCase);
                        User usr = mapEmailUserIdsTechLog.get(objCase.SuppliedEmail);
                        if(usr.UserType == 'Standard') {
                            //Case Requestor is Added to the Case Team with a Team Role - Case Creator.
                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id,mapEmailUserIdsTechLog.get(objCase.SuppliedEmail).Id,System.Label.Case_Team_Role_Id_Case_Creator));
                        } else {
                            //Case Requestor is Added to the Case Team with a Team Role - Case Creator External.
                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id,mapEmailUserIdsTechLog.get(objCase.SuppliedEmail).Id,System.Label.Case_Team_Role_Id_Case_Creator_External));
                        }
                        
                        mapCaseTeamMem.Put(ParentId + MemberId1, null);
                    }
                    
                }
                //MM- end
                if (objCase.OutofOfficeOwner__c !=null && objCase.CreatedById != objCase.OutofOfficeOwner__c) {
                    String MemberId2 = objCase.OutofOfficeOwner__c;
                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId2)) {
                        if (objCase.OutofOfficeOwner__c != null && objCase.CreatedById != objCase.OutofOfficeOwner__c) {                            
                            //If Case Out of Office Existed Then Case Assigned Owner is Added to the Case Team with a Team Role - Case Manager for further Access to the Case..
                            lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id, objCase.OutofOfficeOwner__c, System.Label.Case_Team_Role_Id_Case_Manager));
                        }
                    }
                }
                if(objCase.SuppliedEmail ==null || objCase.SuppliedEmail == '')
                    teamParentIds.add(objCase.Id);
                
            }  
            if (caseList != null && caseList.size() > 0) {
                Database.update(caseList, false);
            }             
            if (lstCaseteamMember != null && lstCaseteamMember.size() > 0) {
                //Database.insert(lstCaseteamMember, false);
                insert lstCaseteamMember;
            }
            // to add predefined Case Team
            if (listCaseTeam != null && listCaseTeam.size() > 0) {
                insert listCaseTeam;
            }
            if (lstCaseteamMember != null && lstCaseteamMember.size() > 0 && teamParentIds.size() > 0  && teamParentIds != null){
                system.debug(lstCaseteamMember );
               CaseHandlerUtility.insertCaseCollaborationFromCaseTeam(teamParentIds);
            }
            
            
            if(Test.isRunningTest()) {
                                throw new applicationException('In Test Mode');
                        }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='TeamMemberOnInsert()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.TeamMemberOnInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Insert or Update Case TeamMembers according to their Team Role at the time of Case UPDATE .
    @method name: TeamMemberOnUpdate
    @parameter:   Array of oldCases , newCases , CaseMapOld.
    @return :     NA.
    **/
    private void TeamMemberOnUpdate(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld) {
        try {
            Set < Id > caseIds = new Set < Id > ();
            caseList = New List < Case > ();
            Set < Id > queueIds = new Set < Id > ();
            Map < Id, List < Id >> mapGroupMembers = new Map < Id, List < Id >> ();
            Set<Id> teamParentIds = new Set<id>();
    
            for (Case c: newCases) {
                Case oldCaseObj = CaseMapOld.get(c.Id);
                if (c.CustomerRecordType__c) {
                    if (((string) oldCaseObj.OwnerId).startsWith('00G')) {
                        queueIds.add(oldCaseObj.OwnerId);
                    }
                    setCaseId.add(c.Id);
                    caseList.Add(c);
                }
                if (c.Team_Room__c != null) {
                    if (!(oldCaseObj.Team_Room__c != null)) {
                        caseIds.add(c.Id);
                        teamRoomIds.add(c.Team_Room__c);
                    }
                }
                
                if(c.SuppliedEmail ==null || c.SuppliedEmail == '')
                    teamParentIds.add(c.Id);
            }
    
            // return group members with group Id
            if (queueIds != null && queueIds.size() > 0) {
                mapGroupMembers = CaseHandlerUtility.getGroupMembers(queueIds);
            }
    
            if (teamRoomIds != null && teamRoomIds.size() > 0) {
                CaseHandlerUtility.teamRoomMembersPermissionOnCase(caseIds, teamRoomIds);
            }
    
            List < CaseTeamMember > lstCaseTeamMemberTemp = New List < CaseTeamMember > ();
            if (setCaseId != null && setCaseId.size() > 0) {
                lstCaseTeamMemberTemp = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId In: setCaseId LIMIT 5000];
                for (CaseTeamMember ct: lstCaseTeamMemberTemp) {
                    String ParentId = ct.ParentId;
                    String MemberId = ct.MemberId;
                    mapCaseTeamMem.Put(ParentId + MemberId, ct.Id);
                }
    
                for (Case c: caseList) {
                    Case oldCaseObj = CaseMapOld.get(c.Id);
                    String ParentId = c.Id;
                    if (!(((string) oldCaseObj.OwnerId).startsWith('00G'))) {
                        //If Manual Case Ownership Changes then The old Case Owner is Added to the Case Team with a Team Role - Case Manager for further Access to the Case..
                        if (oldCaseObj.Owner_IsActive__c) {
                            if (oldCaseObj != null && oldCaseObj.OwnerId != c.OwnerId) {
                                String MemberId1 = oldCaseObj.OwnerId;
                                if (c.CreatedById != oldCaseObj.OwnerId) {
                                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, oldCaseObj.OwnerId, System.Label.Case_Team_Role_Id_Case_Manager));
                                        mapCaseTeamMem.Put(ParentId + MemberId1, null);
                                    } else {
                                        if ((mapCaseTeamMem.get(ParentId + MemberId1)) != null) {
                                            lstCaseteamMemberDel.add(CaseHandlerUtility.caseTeamMemberObject(mapCaseTeamMem.get(ParentId + MemberId1)));
                                            lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, oldCaseObj.OwnerId, System.Label.Case_Team_Role_Id_Case_Manager));
                                        }
                                    }
                                } else if (UserInfo.getProfileId() != System.Label.Case_Automated_User_ProfileId){
                                    if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                                        lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, MemberId1, System.Label.Case_Team_Role_Id_Case_Creator));
                                        mapCaseTeamMem.Put(ParentId + MemberId1, null);
                                    } else {
                                        if ((mapCaseTeamMem.get(ParentId + MemberId1)) != null) {
                                            lstCaseteamMemberDel.add(CaseHandlerUtility.caseTeamMemberObject(mapCaseTeamMem.get(ParentId + MemberId1)));
                                            lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, MemberId1, System.Label.Case_Team_Role_Id_Case_Creator));
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (c.OutofOfficeOwner__c != null && c.OwnerId != c.OutofOfficeOwner__c && c.CreatedById != c.OutofOfficeOwner__c ) {
                            String MemberId2 = c.OutofOfficeOwner__c;
                            if (!mapCaseTeamMem.containsKey(ParentId + MemberId2)) {
                                //If Case Out of Office Existed for Case Update Then Case Assigned Owner is Added to the Case Team with a Team Role - Case Manager for further Access to the Case.                            
                                lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(c.Id, c.OutofOfficeOwner__c, System.Label.Case_Team_Role_Id_Case_Manager));
                                mapCaseTeamMem.Put(ParentId + MemberId2, null);
                            } else {
                                if ((mapCaseTeamMem.get(ParentId + MemberId2)) != null) {
                                    lstCaseteamMemberDel.add(CaseHandlerUtility.caseTeamMemberObject(mapCaseTeamMem.get(ParentId + MemberId2)));
                                    lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(c.Id, c.OutofOfficeOwner__c, System.Label.Case_Team_Role_Id_Case_Manager));
                                }
                            }
                        }
                        
                    } else {
                        //If Manual Case Ownership Changes then The old Case Queue Members is Added to the Case Team with a Team Role - Case Manager for further Access to the Case..
                        if (mapGroupMembers != null && mapGroupMembers.size() > 0) {
                            List < Id > groupMembers = mapGroupMembers.get(oldCaseObj.OwnerId);
                            if (groupMembers != null && groupMembers.size() > 0) {
                                for (Id userId: groupMembers) {
                                    if (oldCaseObj != null && oldCaseObj.OwnerId != c.OwnerId) {
                                        String MemberId1 = userId;
                                        if (c.CreatedById != userId) {
                                            if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                                                lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, userId, System.Label.Case_Team_Role_Id_Case_Manager));
                                                mapCaseTeamMem.Put(ParentId + MemberId1, null);
                                            } else {
                                                if ((mapCaseTeamMem.get(ParentId + MemberId1)) != null) {
                                                    lstCaseteamMemberDel.add(CaseHandlerUtility.caseTeamMemberObject(mapCaseTeamMem.get(ParentId + MemberId1)));
                                                    lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, userId, System.Label.Case_Team_Role_Id_Case_Manager));
                                                }
                                            }
                                        } else {
                                            if (!mapCaseTeamMem.containsKey(ParentId + MemberId1)) {
                                                lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, userId, System.Label.Case_Team_Role_Id_Case_Creator));
                                                mapCaseTeamMem.Put(ParentId + MemberId1, null);
                                            } else {
                                                if ((mapCaseTeamMem.get(ParentId + MemberId1)) != null) {
                                                    lstCaseteamMemberDel.add(CaseHandlerUtility.caseTeamMemberObject(mapCaseTeamMem.get(ParentId + MemberId1)));
                                                    lstCaseteamMember.add(CaseHandlerUtility.caseTeamMemberObject(oldCaseObj.Id, userId, System.Label.Case_Team_Role_Id_Case_Creator));
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }  
                    
                }
            }
            if (lstCaseteamMemberDel != null && lstCaseteamMemberDel.size() > 0) {
                //Known Issues: Case Team Members Losing Access on Case Owner Change
                //Workaround: Remove and re-add the members into Case Team to restore access.
                //Remove Duplicate id in list                
                delete CaseHandlerUtility.removeDuplicateMembers(lstCaseteamMemberDel);
            }
            if (lstCaseteamMember != null && lstCaseteamMember.size() > 0) {
                //Remove Duplicate id in list
                insert CaseHandlerUtility.removeDuplicateMembers(lstCaseteamMember);
            }
            if (lstCaseteamMember != null && lstCaseteamMember.size() > 0 && teamParentIds.size() > 0  && teamParentIds != null){
               CaseHandlerUtility.insertCaseCollaborationFromCaseTeam(teamParentIds);
            }
            if(Test.isRunningTest()) {
                                throw new applicationException('In Test Mode');
                        }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='TeamMemberOnUpdate()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
           // CaseHandlerUtility.trackException('CaseTriggerHandler.TeamMemberOnUpdate', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used for Chatter Feed Item Creation as per Business Logic .
    @method name: OnBeforeInsertFeedItem
    @parameter:   Array of new FeedItems.
    @return :     NA.
    **/
    private void FeedItemValidation(FeedItem[] newFeedItems) {
        try {
            Boolean isError = false; 
            Boolean flag = false;   
            setCaseId = new Set < Id > ();
            Set < Id > caseIdFirstRes = new Set < Id > ();
            Set < Id > caseIdNew = new Set < Id > ();
            Set < Id > caseIdAck = new Set < Id > ();
            
            string swiftEmails = System.Label.Case_Swift_Email_for_Edit_Permission;  
            Integer SwiftMemberscount = CaseHandlerUtility.swiftMembersCount();            
            
            for (FeedItem f: newFeedItems) {
                setCaseId.add(f.parentId);
            }
            if (setCaseId != null && setCaseId.size() > 0) {
                Map < Id, Case > mCase = new Map < ID, Case > ([ select id,Status,SuppliedEmail,AttachmentUploadedFlag__c,
                                                                Case_Record_Type_API__c, Internal_or_external__c, CreatedById, Category__c,Date_Time_First_Response__c,First_Response_By__c,  
                                                               Ownership_Transfer_Count__c,CustomerRecordType__c from case WHERE Case_Record_Type_API__c != 'Internal_Case' AND Id IN:setCaseId ]);
                if (mCase != null && mCase.size() > 0) { 
                    isPublicCommentPermitted = CaseHandlerUtility.onCasePublicCommentValidation();                   
                    for (FeedItem fi: newFeedItems) {
                        Case caseObj = mCase.get(fi.ParentId);   
                        if(caseObj.CustomerRecordType__c){                                                 
                            if (caseObj.Internal_or_external__c ==false && isPublicCommentPermitted == false && fi.VISIBILITY == 'AllUsers') {
                                isError = true;
                                fi.addError(Label.Case_Comment_Restriction_Error_Message);
                                break;
                            }                            
                            if (caseObj.Case_Record_Type_API__c=='External_System' && caseObj.Category__c=='Tapeout') {
                                if (!(swiftEmails.containsIgnoreCase(UserInfo.getUserEmail()) || (SwiftMemberscount == 1)||
                                      (caseObj.CreatedById==UserInfo.getUserId())||(UserInfo.getProfileId() == System.Label.Case_Automated_User_ProfileId))){
                                      isError = true;
                                }
                            } 
                            
                            //used for update Case Status to  Acknowledged-In Queue.
                            if (caseObj.Status == 'New'){ 
                                caseIdNew.add(caseObj.Id); 
                                flag= caseObj.AttachmentUploadedFlag__c;
                            } 
                            //used for update Case First Response related fields.
                            if (caseObj.Date_Time_First_Response__c == null || caseObj.First_Response_By__c  == null)
                                caseIdFirstRes.add(caseObj.Id);
                            //used for update Case Second Level Response related fields. This will be done in Acknowledged status only
                            if (caseObj.Status == System.Label.Case_Status_Acknowledged && caseObj.Ownership_Transfer_Count__c >0 
                                && (caseObj.Date_Time_First_Response__c != null || caseObj.First_Response_By__c  != null))
                                caseIdAck.add(caseObj.Id); 
                        }                       
                    }
                    
                    if(!isError){
                        if(caseIdNew.size() >0){
                            CaseHandlerUtility.CaseStatusUpdateOnComment(caseIdNew, System.Label.Case_Status_Acknowledged, flag);
                        }
                            
                        if(caseIdFirstRes.size() >0)
                            CaseHandlerUtility.CaseFirstResponseFieldUpdate(caseIdFirstRes);
                        if(caseIdAck.size() >0)
                            CaseHandlerUtility.CaseStatusUpdateOnComment(caseIdAck, System.Label.Case_Status_Inprogress,flag);
                    }
                }
            }
            if(Test.isRunningTest()) {
                                throw new applicationException('In Test Mode');
                        }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='FeedItemValidation()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.FeedItemValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Restrict the User to Post Public Comments according to their Profile at the time of INSERT ..
    @method name: CaseCommentValidation
    @parameter:   Array of new CaseComments.
    @return :     NA.
    **/
    private void CaseCommentValidation(CaseComment[] newCaseComments) {
        try {                    
            setCaseId = new Set < Id > ();
            for (CaseComment cc: newCaseComments) {
                setCaseId.add(cc.ParentId);
            }
            
            Map < Id, Case > mCase = new Map < ID, Case > ([select id, Case_Record_Type_API__c, Internal_or_external__c,CustomerRecordType__c  from
                                                            case WHERE Case_Record_Type_API__c != 'Internal_Case' AND Id IN:
                                                            setCaseId
                                                           ]);
            
            if(mCase!= null && mCase.size() > 0 ){
                isPublicCommentPermitted = CaseHandlerUtility.onCasePublicCommentValidation();              
                for (CaseComment cc: newCaseComments) {
                    if (mCase.get(cc.ParentId).Internal_or_external__c ==false && mCase.get(cc.ParentId).CustomerRecordType__c 
                        && isPublicCommentPermitted == false && cc.IsPublished == true) {cc.addError(Label.Case_Comment_Restriction_Error_Message);}
                }
            }
            if(Test.isRunningTest()) {
                                throw new applicationException('In Test Mode');
                        }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='FeedItemValidation()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseCommentValidation',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to Insert Case TeamMembers according to their Team Role at the time of Case Collaboration Insert .
    @method name: CaseCollaborationTeamMemberInsert
    @parameter:   Array of newCCtoCase.
    @return :     NA.
    **/
     private void CaseCollaborationTeamMemberInsert(Case_Collaboration__c[] newCCtoCase) {
        try {
            set<id> actIds = new set<id>();
            Set<id> contactIds = new Set<id> ();                   
            Map<id,Set<id>> casetoAllContactMap = new Map<id,Set<id>>();
            Map<ID,Case_Collaboration__c> cctocaseMap= new map<ID,Case_Collaboration__c>([select id,Contact__c,Case__c, Case__r.accountid from Case_Collaboration__c where id IN: newCCtoCase]);
            for (Case_Collaboration__c cctoCase: cctocaseMap.values()) {
                lstCaseCollaboration.add(cctoCase.Id);
                if(cctoCase.Contact__c != null)
                    lstContact.add(cctoCase.Contact__c);
                setCaseId.add(cctoCase.Case__c);  
                if(cctoCase.case__r.accountid != null){
                        actIds.add(cctoCase.case__r.accountid);              
                }                 
            }            
                                                
            if (lstCaseCollaboration != null && lstCaseCollaboration.size() > 0) {
                CaseHandlerUtility.onCaseTeamMemberAdd(lstCaseCollaboration, setCaseId,lstContact,actIds);
            }
            if(Test.isRunningTest()) {
                                throw new applicationException('In Test Mode');
                        }
            
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseCollaborationTeamMemberInsert()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseCollaborationTeamMemberInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to UPDATE Case TeamMembers according to their Team Role at the time of Case Collaboration UPDATE .
    @method name: CaseCollaborationTeamMemberUpdate
    @parameter:   ArrAy of oldCCtoCase, updateCCtoCase , oldCCtoCaseMap.
    @return :     NA.
    **/
   private void CaseCollaborationTeamMemberUpdate(Case_Collaboration__c[] oldCCtoCase, Case_Collaboration__c[] updateCCtoCase, Map < ID, Case_Collaboration__c > oldCCtoCaseMap) {
        try {
            set<id> actIds = new set<id>();
            Set<id> contactIds = new Set<id> (); 
            Set<id> ccUserIds = new Set<Id>();
            Set<id> ccCasePreTeamIds = new Set<id>();
            Map<id,set<id>> caseToContactMap = new Map<id,set<id>>();
            Map<ID,Case_Collaboration__c> cctocaseMap= new map<ID,Case_Collaboration__c>([select id,name,Case_Predefined_Team_Id__c ,Contact__c,Is_Subscribed__c,Case__c, Case__r.accountid,user__c from Case_Collaboration__c where id IN: updateCCtoCase]);
            
            for (Case_Collaboration__c cctoCase: cctocaseMap.values()) {
                if (cctoCase.Is_Subscribed__c != oldCCtoCaseMap.get(cctoCase.Id).Is_Subscribed__c) {
                    if (cctoCase.Is_Subscribed__c) {
                        lstCaseCollaboration.add(cctoCase.Id);
                    }
                    else {
                        lstCaseCollaborationDel.add(cctoCase.Id);
                        if(cctoCase.user__c != null && cctoCase.Contact__c == null){
                            ccUserIds.add(cctoCase.user__c );
                        }
                    }
                    
                }
                if(cctoCase.case__r.accountid != null){
                        actIds.add(cctoCase.case__r.accountid);              
                } 
                if(cctoCase.Contact__c != null)
                    lstContact.add(cctoCase.Contact__c);
                    
                if(cctoCase.name.contains('Predefined Team:')){
                    ccCasePreTeamIds.add(cctoCase.Case_Predefined_Team_Id__c );
                }    
                setCaseId.add(cctoCase.Case__c);
               
            }
                                                                
            if (lstCaseCollaborationDel != null && lstCaseCollaborationDel.size() > 0) {
                 CaseHandlerUtility.onCaseTeamMemberRemove(lstCaseCollaborationDel, lstContact, setCaseId,ccUserIds,ccCasePreTeamIds, 'Delete');
            }
            
            if (lstCaseCollaboration != null && lstCaseCollaboration.size() > 0) {
                CaseHandlerUtility.onCaseTeamMemberAdd(lstCaseCollaboration,setCaseId,lstContact,actIds);
            }   
            if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    }           
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseCollaborationTeamMemberUpdate()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseCollaborationTeamMemberUpdate',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to DELETE Case TeamMembers according to their Team Role at the time of Case Collaboration DELETE .
    @method name: CaseCollaborationTeamMemberDelete
    @parameter:   Array of oldCCtoCase , updateCCtoCase .
    @return :     NA.
    **/
    private void CaseCollaborationTeamMemberDelete(Case_Collaboration__c[] oldCCtoCase, Case_Collaboration__c[] updateCCtoCase) {
        try {
            Set<id> ccUserIds = new Set<Id>();
            Set<id> ccCasePreTeamIds = new Set<id>();
            for (Case_Collaboration__c cctoCase: oldCCtoCase) {
                
                lstCaseCollaborationDel.add(cctoCase.Id);
               
                if(cctoCase.Contact__c != null)
                    lstContact.add(cctoCase.Contact__c);
                    
                if(cctoCase.user__c != null && cctoCase.Contact__c == null){
                    ccUserIds.add(cctoCase.user__c );
                }
                if(cctoCase.name.contains('Predefined Team:')){
                    ccCasePreTeamIds.add(cctoCase.Case_Predefined_Team_Id__c );
                }
                                    
                setCaseId.add(cctoCase.Case__c);
            }
            
            if (lstCaseCollaborationDel != null && lstCaseCollaborationDel.size() > 0) {
                CaseHandlerUtility.onCaseTeamMemberRemove(lstCaseCollaborationDel, lstContact, setCaseId,ccUserIds,ccCasePreTeamIds, 'Delete');
            }
            if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    }   
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='CaseCollaborationTeamMemberDelete()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.CaseCollaborationTeamMemberDelete',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }    
    
    /***********************************************Chatter Post******************************************************************************************************************* */
    
    /**
    This method is used for converting field set values into List of fields.
    @method name: LastChatterCommentUpdateOnInsert
    @parameter:   Array of new FeedItem.
    @return :     NA.
    **/
    private void LastChatterFeedItemUpdateOnInsert(FeedItem[] newFeedItems) {
        try {
            Set<Id> caseIds = new Set <Id>();
            Set < Id > feedItemIds = new Set < Id > ();
            Set<Id> contentPostFeed = new Set<Id>();
            for (FeedItem f: newFeedItems) {                
                caseIds.add(f.ParentId);
                if(f.Type == 'ContentPost' && f.body != null){
                    contentPostFeed.add(f.id);
                }
                else{
                     feedItemIds.add(f.Id);
                }
            }
            if (feedItemIds != null && feedItemIds.size() > 0) {
                CaseHandlerUtility.caseLastChatterFeedItemUpdate(feedItemIds); 
                //CaseHandlerUtility.caseLastChatterFeedItemAttachmentUpdate(caseIds);              
            }
            
            if (contentPostFeed!= null && contentPostFeed.size() > 0) {
               // CaseHandlerUtility.caseLastChatterFeedItemUpdate(feedItemIds); 
                CaseHandlerUtility.caseLastChatterFeedItemAttachmentUpdate(caseIds);              
            }
                
           if(Test.isRunningTest()){
                 throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='LastChatterFeedItemUpdateOnInsert()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.LastChatterFeedItemUpdateOnInsert',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to INSERT Case Timeline when any new case created.
    @method name: caseTimelineOnInsert
    @parameter:   Array of new Cases .
    @return :     NA.
    **/
    public void caseTimelineOnInsert(Case[] newCases) {
        try {
            List < CaseTimeline__c > ctl_List = New List < CaseTimeline__c > ();
            for (Case caseObj: newCases) {
                Date cdate = caseObj.CreatedDate.date();
                String[] dts = ((string)(System.Label.CaseTimeLine_DeploymentDate)).split('/');
                Date dDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
                if (dDate <= cdate) {
                    ctl_List.add(createCaseTimelineObject(caseObj));
                }
            }
            if (ctl_List.size() > 0) {
                insert ctl_List;
            }
            if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='caseTimelineOnInsert()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.caseTimelineOnInsert', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to CREATE Case Timeline when any new case created or updated.
    @method name: createCaseTimelineObject
    @parameter:   Array of Cases .
    @return :     CaseTimeline__c.
    **/
    public CaseTimeline__c createCaseTimelineObject(Case c){
        CaseTimeline__c ctl= new CaseTimeline__c();     
        ctl.OwnerId = c.OwnerId;
        ctl.Assignee__c = c.Assignee__c;
        ctl.End_DateTime__c = null;
        ctl.Start_DateTime__c=System.now();
        ctl.Status__c=c.Status;
        ctl.Sub_Status__c=c.SubStatus__c;
        ctl.Support_Level__c=c.Support_Level__c;
        ctl.Case__c = c.Id;
        ctl.Ask_Customer__c = c.Ask_Customer__c; 
        ctl.Ask_GF__c = c.Ask_GF__c; 
        return ctl;
    }    
    /****************************************************************************************************************************************************************** */
    /**
    This method is used to UPDATE Case Timeline when any case updated.
    @method name: caseTimelineOnUpdate
    @parameter:   Array of old Cases, updated cases, map of old cases.
    @return :     NA.
    **/
    public void caseTimelineOnUpdate(Case[] oldCases, Case[] updatedCases, Map < ID, Case > CaseMapOld) {
        try {
            List < CaseTimeline__c > lstCTLupdate = new List < CaseTimeline__c > ();
            List < CaseTimeline__c > lstCTL_TBI = new List < CaseTimeline__c > ();
            List < CaseTimeline__c > lstCTL = [SELECT Id,OwnerId,Assignee__c,Case__c,End_DateTime__c,Start_DateTime__c,Status__c,Sub_Status__c,
                                                Ask_Customer__c,Ask_GF__c,Time_Duration__c FROM CaseTimeline__c WHERE Case__c IN: updatedCases AND End_DateTime__c = null];
            for (Case caseObj: updatedCases) {
                Case oldCaseObj = CaseMapOld.get(caseObj.Id);
                Date cdate = caseObj.CreatedDate.date();
                String[] dts = ((string)(System.Label.CaseTimeLine_DeploymentDate)).split('/');
                Date dDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
                if (dDate <= cdate) {
                    if (caseObj.OwnerId != oldCaseObj.OwnerId || caseObj.Status != oldCaseObj.Status || caseObj.SubStatus__c != oldCaseObj.SubStatus__c || caseObj.Assignee__c != oldCaseObj.Assignee__c || caseObj.Support_Level__c != oldCaseObj.Support_Level__c || caseObj.Ask_Customer__c != oldCaseObj.Ask_Customer__c || caseObj.Ask_GF__c != oldCaseObj.Ask_GF__c) {
                        for (CaseTimeline__c ctl: lstCTL) {
                            if (ctl.Case__c == caseObj.Id) {
                                ctl.End_DateTime__c = System.now();
                                if (ctl.OwnerId == oldCaseObj.OwnerId && (ctl.End_DateTime__c != ctl.Start_DateTime__c)) {
                                    lstCTLupdate.add(ctl);
                                    lstCTL_TBI.add(createCaseTimelineObject(caseObj));
                                }
                            }
                        }
                    }
                }
            }
            if (lstCTLupdate.size() > 0) {
                update lstCTLupdate;
            }
            if (lstCTL_TBI.size() > 0) {
                insert lstCTL_TBI;
            }
            if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    }
        } catch (Exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='caseTimelineOnUpdate()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.caseTimelineOnUpdate', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    /**
    This method is used for updating the Ask customer and Ask GF value whenever any question posted.
    @method name: askCustomerORaskGFfunctionality
    @parameter:   Array of new FeedItem.
    @return :     NA.
    **/
    public void askCustomerOraskGFfunctionality(FeedItem[] newFeedItems) {
        try {
            Set < FeedItem > feedItemList = new Set < FeedItem > ();
            Set<Id> caseIds=new Set<Id>();
            Set<Id> setParentIds = new Set<Id>();
            
            for (FeedItem f: newFeedItems) {
                if(f.Type == 'QuestionPost'){
                    if(f.VISIBILITY!= 'AllUsers'){
                        f.addError(System.Label.Case_AskQuestion_GFonly_Error);
                        break;
                    }else{
                        feedItemList.add(f);
                        caseIds.add(f.ParentId);
                    }
                }                
            }
            if (caseIds != null && caseIds.size() > 0) {
                List < Case > caseList = new List < Case > ();              
                for(Case objCase:[SELECT Id,Case_Record_Type_API__c,Internal_or_external__c, AccountId,CustomerRecordType__c from case where Id IN:caseIds]){                                
                    if(!(objCase.Internal_or_external__c) && (objCase.AccountId !=null)){
                        if(UserInfo.getUserType() == 'PowerCustomerSuccess'){
                            objCase.Ask_GF__c = 'Question asked';
                        }
                        if(UserInfo.getUserType() == 'Standard'){
                            objCase.Ask_Customer__c = 'Question asked';
                        }                
                        caseList.add(objCase);
                    }else{                       
                       if(!setParentIds.Contains(objCase.Id))
                       setParentIds.add(objCase.Id);
                    }
                }
                if (caseList != null && caseList.size() > 0) {
                    update caseList;
                }
            } 
            if (setParentIds != null && setParentIds.size() > 0) {
                for (FeedItem f: feedItemList) {                    
                    if(setParentIds.Contains(f.ParentId))
                        f.addError(System.Label.Case_AskCustomer_InternalUseonly_Error);
                }
            }
             if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    } 
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='askCustomerORaskGFfunctionality()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.askCustomerORaskGFfunctionality',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    /**
    This method is used for updating the Ask customer and Ask GF value whenever any question Answered.
    @method name: caseQuestionAnswered
    @trigger: CaseFeedCommentTrigger
    @parameter:   Array of new FeedComment.
    @return :     NA.
    **/
    public void caseQuestionAnswered(List<FeedComment> newFeedComments) {
        try{
            String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
            List<Case> caseListtoUpdate = new List<Case>();
            list<string> parentCase = new list<string>();
            Set<Id> setfeeditemId=new Set<Id>();
            for (FeedComment fdComment: newFeedComments) {
                String parentIdTemp = fdComment.parentId;
                Id feeditemId = fdComment.FeedItemId;
                if (parentIdTemp.startsWith(caseKeyPrefix)){
                    parentCase.add(parentIdTemp);
                    //FeedItem associated with the feedcomment
                    setfeeditemId.add(feeditemId);
                }                    
            }
            
            if( parentCase.size() > 0){      
                List<Case> caseList = [select id, Ask_Customer__c, Ask_GF__c,CustomerRecordType__c from Case where id in :parentCase];
                for(FeedItem f: [SELECT Id, createdbyID from FeedItem where Id IN:setfeeditemId]){
                    for(Case c: caseList){ 
                        //Update the value if the comment will not post by the creator
                        if(UserInfo.getUserType() == 'PowerCustomerSuccess' && c.Ask_Customer__c == 'Question asked' && f.createdbyID!=UserInfo.getUserId()){
                            c.Ask_Customer__c = 'Question answered';
                            caseListtoUpdate.add(c);
                        }
                        if(UserInfo.getUserType() == 'Standard' && c.Ask_GF__c =='Question asked' && f.createdbyID!=UserInfo.getUserId()){
                            c.Ask_GF__c = 'Question answered';
                            caseListtoUpdate.add(c);
                        }                        
                    } 
                }   
            }
            if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    } 
                                    
            if (caseListtoUpdate != null && caseListtoUpdate.size() > 0) 
                update caseListtoUpdate;
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='caseQuestionAnswered()';
                    alw.ApplicationName='Case Management';                
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('CaseTriggerHandler.caseQuestionAnswered',e.getLineNumber(),e.getTypeName(),e.getMessage());
        }
    }
    
    /**
    This method is used for inserting Case Team Member and Case Collaboration based on the CcAddress and ToAddress.
    @method name: InsertCaseTeamMembersFromCCList
    @parameter:   Array of new EmailMessage.
    @return :     NA.
    **/
     public void InsertCaseTeamMembersFromCCList(EmailMessage [] newEmailMessages) {
        List<Case> caseList = new List<Case>();
        Set<String> contactEmail = new  Set<String>();//PK
        //List<String> inActiveUserEmail = new  List<String>();
        List<User> inActiveUserEmail = new List<User>();
        Set<Id> accountIds = new Set<id>();
        Set<id> contactIds = new Set<id>(); 
        List<String> lstToEmail = new List<String>();
        Map<Id, Set<String>> mapParentIdEmail = new Map<Id, Set<String>>();
        Map<String,Id> mapFromEmailParentId = new Map<String,Id>();//PK
        Map<Id,String> mapParentIdInActiveUser = new Map<Id,String> ();//PK
        List<string> emailAddresses = new List<string>();
        Map < String, User> mapEmailUserIds = new Map < String, User> ();
        List < CaseTeamMember > caseTeamMemberList = new List < CaseTeamMember> ();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        List < CaseTeamMember > membersAssociatedwithCase = new List < CaseTeamMember> (); //MM added 21stapril16
        Map<Id,CaseTeamMember> MapCaseAndMembers = new Map<Id,CaseTeamMember>();//MM added 21stapril16
        Set<Id> caseIds=new Set<Id>();
        Map < String, CaseTeamMember > mapCaseTeamMem = new Map < String, CaseTeamMember >();
        Map < String, Case_Collaboration__c > mapCaseAndcaseCollaborater = new Map < String, Case_Collaboration__c >();
        List<CaseTeamMember > lstCaseTeamMemberTemp =new List<CaseTeamMember > ();
        List<Case_Collaboration__c > lstCaseCollTemp = new List<Case_Collaboration__c > ();
        
        List < Case_Collaboration__c > caseCollaboratorList = new List < Case_Collaboration__c> ();
        List<String> emailIdsPortalUser= new List < String> ();
        List<String> listAddress = new List<string>();
        
        try{
            for(EmailMessage newEmail: newEmailMessages){
                
                if(newEmail.ToAddress != null){
                    String strToAddress = newEmail.ToAddress;                  
                    listAddress = strToAddress.split(';');                                  
                }
                if(newEmail.CcAddress !=null){
                   String strCcAddress = newEmail.CcAddress; 
                   List<String> listCcAddress = strCcAddress.split(';');
                   listAddress.addAll(listCcAddress);             
                }
                //MM- added
                String fromAddress =((string)newEmail.FromAddress).trim();                  
                mapFromEmailParentId.put(fromAddress ,newEmail.ParentId);                           
                listAddress.add(fromAddress);
                //MM- end
                Set<String> setAddress =new Set<String>(listAddress);
                mapParentIdEmail.put(newEmail.ParentId,setAddress);
                for(String emailId:setAddress){
                    emailAddresses.add(emailId.trim());
                }
            }
            if(emailAddresses !=null && emailAddresses.size() > 0){             
                mapEmailUserIds = CaseHandlerUtility.getUserIdFromEmail(emailAddresses,'All'); 
            }
            //PK-Added
            if(emailAddresses !=null && emailAddresses.size() > 0){                                 
                if(mapEmailUserIds.size() > 0){
                    for(String email:emailAddresses){                    
                        if (!mapEmailUserIds.containsKey(email.trim())) {
                            contactEmail.add(email.trim());
                        }
                    } 
                }
                else{
                         contactEmail =new Set<String>(emailAddresses);
                }        
            }           
            //Pk-End
            if(contactEmail !=null && contactEmail.size() > 0){
                if(mapFromEmailParentId.size() > 0){
                    for(String email:contactEmail){
                        if(!email.containsIgnoreCase('fdrytech')){
                            if (mapFromEmailParentId.containsKey(email.trim())) {
                                    mapParentIdInActiveUser.put(mapFromEmailParentId.get(email),email);
                                } 
                        }                           
                    }
                }
            }                                           
            if(mapEmailUserIds.size() > 0){
                caseList = [SELECT Id,SuppliedEmail,accountid FROM Case WHERE Id In:mapParentIdEmail.KeySet() AND (Case_Record_Type_API__c ='TechnicalPDK' OR Case_Record_Type_API__c ='Logistics')]; //MM- Logistics record type added                
                if(caseList.size()>0){
                    for(Case c:caseList){
                        caseIds.add(c.Id);
                        accountIds.add(c.accountId);
                    }
                }
                if (caseIds != null && caseIds.size() > 0) 
                    lstCaseTeamMemberTemp = [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId In: caseIds LIMIT 1000];
                if (lstCaseTeamMemberTemp != null && lstCaseTeamMemberTemp.size() > 0) {
                    for (CaseTeamMember ct: lstCaseTeamMemberTemp) {
                        String ParentId = ct.ParentId;
                        String MemberId = ct.MemberId;
                        mapCaseTeamMem.Put(ParentId + MemberId, ct);
                    }
                }
                if(caseList !=null && caseList.size()>0){
                    for(Case objCase:caseList){
                        Set<string> emails = mapParentIdEmail.get(objCase.Id);                
                        for(string email:emails){
                            if(mapEmailUserIds.size()>0){                        
                                if(mapEmailUserIds.containsKey(email.trim())){ 
                                    //Internal user will have Role as "Case Manager (Internal)"
                                    if(mapEmailUserIds.get(email.trim()).UserType == 'Standard'){
                                        //MM added
                                        if (mapCaseTeamMem != null) {
                                            String parentKey=objCase.Id;
                                            String memberKey= mapEmailUserIds.get(email.trim()).Id;
                                            if (!mapCaseTeamMem.containsKey(parentKey+memberKey)) {
                                                caseTeamMemberList.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id, mapEmailUserIds.get(email.trim()).Id, System.Label.Case_Team_Role_Id_Case_Manager));
                                            }
                                        }else{
                                            caseTeamMemberList.add(CaseHandlerUtility.caseTeamMemberObject(objCase.Id, mapEmailUserIds.get(email.trim()).Id, System.Label.Case_Team_Role_Id_Case_Manager));
                                        }
                                        
                                    }else {
                                        emailIdsPortalUser.add(email.trim());
                                    }
                                }
                            }                             
                        }
                    }
                } 
            }  
                 
            if(emailIdsPortalUser.size()>0){               
                if (caseIds != null && caseIds.size() > 0)
                    lstCaseCollTemp = [SELECT UniqueId__c,Case__c,Contact__c FROM Case_Collaboration__c WHERE Case__c In: caseIds LIMIT 1000];
                
                if (lstCaseCollTemp != null && lstCaseCollTemp.size() > 0) {
                    for (Case_Collaboration__c cc: lstCaseCollTemp) {
                        mapCaseAndcaseCollaborater.Put(cc.UniqueId__c, cc);
                    }
                }
                List <Contact> contactForCustomer = [SELECT Id,Email, Name, Account.Name from Contact where Email IN:emailIdsPortalUser];
                Map<id,Set<id>> accountContactMap = CaseHandlerUtility.getContactsFromAccountHierarchy(accountIds);// PK added for case:00074425                                                     
                 
                 if(contactForCustomer.size()>0){                                                                    
                    for(Contact con: contactForCustomer){
                        for(Case objCase:caseList){
                          if(objCase.accountid != null){
                              contactIds = accountContactMap.get(objCase.accountid);
                           }
                            if(contactIds.size()>0 && contactIds != null){
                                if((contactIds.contains(con.id)) || (objCase.accountid == Label.Case_GlobalFoundriesAccount)){
                                    Case_Collaboration__c cc = new Case_Collaboration__c();
                                    cc.Name= con.Name+' from ' + con.Account.Name;
                                    cc.Case__c = objCase.Id;
                                    cc.Contact__c = con.Id;
                                    if (cc.Case__c != null && cc.Contact__c != null) {
                                        cc.UniqueId__c = string.valueOf(cc.Case__c) + string.valueOf(cc.Contact__c);
                                    }
                                    cc.Email_Id__c = con.Email;
                                    cc.Is_Subscribed__c = false;
                                    if (mapCaseAndcaseCollaborater != null) {
                                        if (!mapCaseAndcaseCollaborater.containsKey(cc.UniqueId__c)) {
                                            caseCollaboratorList.add(cc);
                                        }
                                    }else{
                                        caseCollaboratorList.add(cc);
                                    } 
                                }
                            }                               
                        }
                    }
                }                
            }        
           if(mapParentIdInActiveUser.size() > 0){ 
                EmailTemplate Noti_TempId_notify = [SELECT Id, body, HtmlValue, subject FROM EmailTemplate WHERE Name = 'CaseAutoResponseToInactiveUser'];
                caseList = [SELECT Id,SuppliedEmail,subject FROM Case WHERE Id in: mapParentIdInActiveUser.KeySet() AND (Case_Record_Type_API__c ='TechnicalPDK' OR Case_Record_Type_API__c ='Logistics')]; //MM- Logistics record type added              
                if(caseList.size()>0){
                    for(Case objCase:caseList){                   
                        if(objCase.SuppliedEmail == mapParentIdInActiveUser.get(objCase.id)){ 
                                List<String> sendTo = new List<String>();
                                sendTo.add(mapParentIdInActiveUser.get(objCase.id));                                                                                                        
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                                                               
                                String emailBody = Noti_TempId_notify.body;
                                String subjct =  objCase.Subject;                                
                                mail.setPlainTextBody(emailBody);
                                mail.setToAddresses(sendTo);
                                mail.setSubject(subjct);       
                                mail.saveAsActivity = false; 
                                mails.add(mail);                                                                                                                              
                        }
                    }                               
                }
            }               
           
            if(mails !=null && mails.size() > 0){
                Messaging.sendEmail(mails);         
            }
            if(caseTeamMemberList.size()>0){
                insert caseTeamMemberList;
            } 
            if(caseCollaboratorList.size()>0){
                insert caseCollaboratorList;
            }
            if(caseTeamMemberList.size()>0 || caseCollaboratorList.size()>0){
                 system.debug('pankaj1'+caseTeamMemberList);
                 CaseHandlerUtility.insertCaseCollaborationFromCaseTeam(caseIds);
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }           
        }catch (Exception e) {              
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='InsertCaseTeamMembersFromCCList()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  
                    //CaseHandlerUtility.trackException('CaseTriggerHandler.InsertCaseTeamMembersFromCCList',e.getLineNumber(),e.getTypeName(),e.getMessage());
        } 
    }
    
    /**
    This method is used trigger notification to entire IP-QA group when a specific team member in IP-QA group is assigned as case owner.
    @method name: getGroupsForIds
    @parameter:   Array of new newCases.
    @return :     NA.
    **/    
    public void getGroupsForIds(Case[] newCases) {
         try {             
             caseList = new List <Case>();
             Case obj = null;
             List<string> groupId = new List<string>();
             Set<Id> userIds = new Set<Id>();             
             //fetching group ids
             List<Group> groupList = [select Id,Name,DeveloperName,Type,OwnerId from Group where DeveloperName='L3_DE_QA' and Type='regular' LIMIT 1];             
             if(groupList.size() > 0) {                
                for(Group groupObj : groupList) {
                    groupId.add(groupObj.Id); // fetching groupId for Group member
                }                
                List<GroupMember> groupMemList = [Select GroupId, UserOrGroupId  from GroupMember where groupId IN:groupId];   
                 
                 if(groupMemList .size() > 0){ 
                    for (GroupMember groupMemObj : groupMemList) {   
                        userIds.add(groupMemObj.UserOrGroupId);  
                    } 
                 }                 
                for(Case caseObj: newCases) {                                          
                    if(userIds.contains(caseobj.ownerid)) {
                        obj = new Case();
                        obj.id = caseobj.id;
                        obj.GroupOwner__c = true;
                    } else {
                        obj = new Case();
                        obj.id = caseobj.id;
                        obj.GroupOwner__c = false;
                        //caseobj.GroupOwner__c = false;
                    }
                    caseList.add(obj);                    
                }   
             }
              if (caseList != null && caseList.size() > 0) {                
                update caseList;
            }  
                if(Test.isRunningTest()) {
                                            throw new applicationException('In Test Mode');
                                    }           
         } catch (Exception e) {         
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='getGroupsForIds()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Case';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);
         //CaseHandlerUtility.trackException('CaseTriggerHandler.InsertCaseTeamMembersFromCCList',e.getLineNumber(),e.getTypeName(),e.getMessage());
         }          
    }
    
   private void onCaseAccountUpdate(Case[] oldCases, Case[] newCases, Map < ID, Case > CaseMapOld){
         try{
             set<id> actIds = new set<id>();
            Set<Id> caseId = new Set<Id> ();
            Set<Id> lstContact = new Set<Id>();
            Set<id> lstCaseCollaboration = new Set<id>();
            Map<id,Set<id>> casetoAllContactMap = new Map<id,Set<id>>();
            for (Case objCase: newCases){
                if(objCase.CustomerRecordType__c){
                    if(CaseMapOld.get(objCase.id).accountid == System.Label.Case_GlobalFoundriesAccount&& objCase.accountid != CaseMapOld.get(objCase.id).accountid){                       
                        actIds.add(objCase.accountid); 
                        caseId.add(objCase.id);
                    }
                }                                     
            }
        
           // Map<id,Set<id>> caseAccounttoAllContacts =  CaseHandlerUtility.getContactsFromAccountHierarchy(actIds);
            List <Case_Collaboration__c > listCollaboration = [SELECT Id, Case__c, Contact__r.AccountId, Is_Subscribed__c,contact__c FROM Case_Collaboration__c  WHERE case__c In: caseId];
            for (Case_Collaboration__c  objCase: listCollaboration){                
                lstCaseCollaboration.add(objCase.id);
                if(objCase.Contact__c != null)
                    lstContact.add(objCase.Contact__c);
                
            }
            
            if (caseId != null && caseId.size() > 0) {
                        CaseHandlerUtility.onCaseTeamMemberAdd(lstCaseCollaboration,caseId,lstContact,actIds);
            }
			if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }       
         }
         catch (exception e){
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseHandlerUtility.class.getName();
                    alw.sourceFunction ='onCaseAccountUpdate()';
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
    
public class applicationException extends Exception {}     
}