/*********************************************************************************/
  // Purpose      : CaseTeamQueueMemberController class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 16 Feb, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Responsible for assign the Users to Case Team.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class CaseTeamQueueMemberController {
  public Set<Id> queueSetId=new set<Id>();
  public String queueId{get;set;}
  public String caseId{get;set;}
  Set<String> caseTMIdSet = new Set<String>();
  public String caseNumber{get;set;}
  public boolean displayBtn{get;set;}
  
  //Constructor
  public CaseTeamQueueMemberController(){
    queueSetId = new Set<Id>();
    displayBtn = false;
    if(ApexPages.currentPage().getParameters().get('cId') != NULL) {
      caseId = ApexPages.currentPage().getParameters().get('cId');
      caseNumber = [Select Id,CaseNumber from Case where Id=:caseId].CaseNumber;
    }else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please pass parameters (ID) properly'));
        }
  }
  
  //Displays all Case related Queues
  public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
    List<QueueSobject> queueObjList=[select Id,QueueId,Queue.Name,SobjectType From QueueSobject where SobjectType='Case'];
    options.add(new SelectOption('', '--None--'));
    for(QueueSobject queueObj: queueObjList) {
      options.add(new SelectOption(queueObj.queueId,queueObj.queue.Name));        
    }
    return options;
  }
  
  //Fetching Public Group Users
  public static Set<id> GetUserIdsFromGroup(Id groupId) {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();

        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId]) {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)) {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType)) {
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }
        return result;  
    }
    
    //Refersh the queue selection list
    public PageReference refresh() {
        return null;
    }
    
    // List of all Users associated with queue
    public List<User> getqueueMembers() {
        displayBtn = false;
        Set<Id> userIds = new Set<Id>(GetUSerIdsFromGroup(queueId));
        if(userIds.size() > 0) {
          displayBtn = true;
        } 
        return [ SELECT id, firstName, lastName, alias, isactive, username, email, userRole.name, profile.name FROM User
                WHERE id In: userIds ORDER BY firstName Limit 100];
    }
    
  //Inserting the queue Members into CaseTeam
  public PageReference assignMembers() {
    if(caseId != null) {
      List<CaseTeamMember> caseTMList = [Select Id,MemberId from CaseTeamMember where ParentId = :caseId];
      CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];
        for(CaseTeamMember caseTMObj : caseTMList) {
            caseTMIdSet.add(caseTMObj.MemberId);
        }          
      
      List<CaseTeamMember> caseTMObjList = new List<CaseTeamMember>();
      if(getqueueMembers().size() > 0) {
        for (User userObj : getqueueMembers()) {
          if(!caseTMIdSet.contains(userObj.Id)) {
            if(userObj.IsActive == true) {
              CaseTeamMember caseTMsObj = new CaseTeamMember();
              caseTMsObj.ParentId = caseId;
              caseTMsObj.MemberId = userObj.Id;
              caseTMsObj.TeamRoleId = caseTMRoleObj.Id;
              caseTMObjList.add(caseTMsObj);
            }
          }
        }  
      }
      if(caseTMObjList.size() > 0) {
              try {
                Insert caseTMObjList;
              } catch(exception e) {
                System.debug('@@@Unable to insert Members into CaseTeam');
              }
            }
    }
    PageReference pageRef = new PageReference('/'+caseId);
    pageRef.setRedirect(true);
        return pageRef; 
  } 
  
  //Redirecting to Case Detail Page
  public PageReference cancelJob() {
    PageReference pageRef = new PageReference('/'+caseId);
    pageRef.setRedirect(true);
        return pageRef; 
  } 
}