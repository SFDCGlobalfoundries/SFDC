/*
    Author: Abhita Bansal
    Description: This serves as the controller for MPWChangeRequestViewVF.
    History: 
        ABansal   07202015  -  page creation
        
*/
public class MPWChangeRequestViewController {
      
      public UtilClassToGetAllFields util{get;set;}
      public MPW_Change_Request__c mpwChangeRequest{get;set;}
      public List<wrapperApprover> changeReqApproverList{get;set;}
      public List<notesAndAttachments> lstAttachments {get; set;}
      public boolean isExternalUser{get;set;}
      public String valueOptions {get;set;}
      public boolean isValidate {get;set;}
      public User loggedInUser{get;set;}
      public Profile loggedInProfile{get;set;}
      public String radioValue {get;set;}
      public boolean approveYes {get;set;}
      public boolean tranxYes {get;set;}
      public boolean showApprover {get;set;}
      public boolean approverId {get;set;}
      public Boolean isRequestor {get;set;} 
      public Set<Id> userId;
      public Set<Id> internalBudgetUserId;
      public String requestType;
      public String mpwChReqId;
      public String approve;  
      public String tranx;   
      
      public MPWChangeRequestViewController (ApexPages.StandardController sc){
          
          changeReqApproverList = new List<wrapperApprover>();
          lstAttachments = new List<notesAndAttachments>();
          userId = new Set<Id>();
          
          loggedInUser = [select Id, Name from User where Id =: userInfo.getUserId()];
          loggedInProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
          
          approveYes = false;
          approverId = false;
          tranxYes = false;
          showApprover = false;
          isRequestor = false;
          this.isExternalUser = false;
          
          this.requestType = ApexPages.currentPage().getParameters().get('RequestType');
          this.mpwChReqId = ApexPages.currentPage().getParameters().get('Id');
          this.approve = ApexPages.currentPage().getParameters().get('Approve');
          this.tranx = ApexPages.currentPage().getParameters().get('tranx');
          
          if(this.approve != null) {
              approveYes = true;
          }
                    
          if(userInfo.getUserType() == 'CustomerSuccess' || userInfo.getUserType() == 'PowerCustomerSuccess'){
              this.isExternalUser = true;
          }
          
          util = new UtilClassToGetAllFields();
          radioValue= 'Use Inventory Wafers';
          
          if(this.mpwChReqId != NULL) {
              retreiveChangeRequestRecords();
          }  
          
          if(mpwChangeRequest.Status__c == 'Accepted by Turnkey' || mpwChangeRequest.Status__c == 'Accepted by CE' || mpwChangeRequest.Status__c == 'Accepted by MPW Tapeout') {
              tranxYes =  true;
          } 
          
          for(Attachment att : [SELECT Id, ParentId, Name, IsPrivate, ContentType, BodyLength, Body, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Description FROM Attachment WHERE ParentId =: mpwChReqId]){
                notesAndAttachments oNotesAndAtt = new notesAndAttachments();
                oNotesAndAtt.oAttachment = att;
                lstAttachments.add(oNotesAndAtt);
          }
          
          for(Note oNote : [SELECT Id, ParentId, Title, Body, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById, OwnerId, IsPrivate FROM Note WHERE ParentId =: mpwChReqId]){
                notesAndAttachments oNotesAndAtt = new notesAndAttachments();
                oNotesAndAtt.oNote = oNote;
                lstAttachments.add(oNotesAndAtt);
          }
          
          // Group Access
          Group mpwTDTI = getPublicGp('MPW TDTI MPW Queue');
          Group sgpCEFab7 = getPublicGp('MPW Singapore MPW CE Fab 7 Queue');
          Group sgpCE3E = getPublicGp('MPW Singapore MPW CE Giga+ 3E Queue');
          Group dresdenCE = getPublicGp('MPW Dresden MPW CE Queue');
          Group mpwGlobal = getPublicGp('MPW GlobalShuttle MPW Tapeout Queue');
          Group mpwCustomized = getPublicGp('MPW Customized MPW Queue');
          Group usCE = getPublicGp('MPW US MPW CE Queue');
            
          // Group Users
          for(Id queueId : getUserIds(mpwTDTI.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(sgpCEFab7.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(sgpCE3E.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(dresdenCE.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(mpwGlobal.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(mpwCustomized.Id)) {
              userId.add(queueId);
          }
          for(Id queueId : getUserIds(usCE.Id)) {
              userId.add(queueId);
          }
          if(mpwChangeRequest.Internal_Budget_Owner_1__c != null) {
              userId.add(mpwChangeRequest.Internal_Budget_Owner_1__c);
          }
          if(mpwChangeRequest.Internal_Budget_Owner_2__c != null) {
              userId.add(mpwChangeRequest.Internal_Budget_Owner_2__c);
          }
          
          if(userId.contains(UserInfo.getUserId())) {
              showApprover = true;
          }
          
          if(loggedInUser.Id == mpwChangeRequest.CreatedById || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'CTS Developers') {
              isRequestor = true;
          }
          
          if(mpwChangeRequest != null){
               if(mpwChangeRequest.Status__c == 'Draft' || mpwChangeRequest.Status__c.contains('Pending')){
                   changeReqApproverList = new List<wrapperApprover>();
                   for(ProcessInstanceWorkitem workItem: [select Id, ActorId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: mpwChangeRequest.Id]){
                       changeReqApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                   }                  
               }
               if(mpwChangeRequest.Status__c == 'Draft') {
                   if(!mpwChangeRequest.Extra_Dies_Status__c) {
                       changeReqApproverList.add(new wrapperApprover(mpwChangeRequest.Id, mpwChangeRequest.CreatedById, 'Recalled'));
                   } 
               }
          }
      } 
      
      public static Group getPublicGp(String PName){
          Group gp = [Select Type, id From Group where Type= 'Queue' And Name =:PName Limit 1];
          return gp;
      }
    
      public static Set<Id> getUserIds(String gpId){
          Set<Id> userList = new Set<Id>();
          for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
              userList.add(groupMem.UserOrGroupId);
          }
          return userList;
      }
          
      public void retreiveChangeRequestRecords() {
            util = new UtilClassToGetAllFields();
            String queryFields = util.getAllFields('MPW_Change_Request__c');
            queryFields += ', MPW_Change_Request__c.MPW_Prime_Die__r.Prime_Die_Name__c, MPW_Change_Request__c.MPW_Form__r.Category__c';
            String query = 'select '+queryFields+' from MPW_Change_Request__c where Id =\''+mpwChReqId+'\'';
            mpwChangeRequest = database.query(query);
      }
      
      public pageReference appRejRec() {
          validateCheckBox();
          if(!isValidate){
              return null;
          }
          else{
              if(radioValue == 'Use Inventory Wafers') {
                  mpwChangeRequest.Use_Inventory_Wafers__c = true;
              } else if(radioValue == 'Start New Wafers'){
                  mpwChangeRequest.Use_Inventory_Wafers__c = false;
                  mpwChangeRequest.Start_New_Wafers__c = true;
              }
              update mpwChangeRequest;
              pageReference pgRef = new pageReference('/apex/MPWChangeRequestViewVF?Id='+mpwChangeRequest.Id);
              pgRef.getParameters().put('tranx','1');
              pgRef.getParameters().put('approve','1');
              pgRef.setRedirect(true);
              return pgRef;
        }
      }
      
      public pageReference cancelRec() {
          pageReference pgRef = new pageReference('/apex/MPWChangeRequestViewVF?Id='+mpwChReqId);
          pgRef.setRedirect(true);
          return pgRef;
      }
      
      public List<selectOption> getradioOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Use Inventory Wafers','Use Inventory Wafers'));
        options.add(new SelectOption('Start New Wafers','Start New Wafers'));
        return options;
      }
      
      public void validateCheckBox() {
          isValidate = true;
          
          if(radioValue == null) {
              isValidate = false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the radio button before Approve or reject the record.'));
          }
      }
      
      public pageReference approvedRec() {
          
          Id workItemId;
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setComments(mpwChangeRequest.Comments__c);
          req.setAction('Approve');
          if(loggedInProfile.Name == 'System Administrator' || userId.contains(UserInfo.getUserId()) || loggedInProfile.Name == 'CTS Developers'){ //|| loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
             workItemId = getWorkItemIdForAdmin(mpwChangeRequest.Id);
          }
          else{
             workItemId = getWorkItemId(mpwChangeRequest.Id, loggedInUser.Id);
          }
          req.setWorkitemId(workItemId);
          Approval.ProcessResult result =  Approval.process(req);
          pageReference pgRef = new pageReference('/apex/MPWChangeRequestViewVF?Id='+mpwChReqId);
          if(mpwChangeRequest.MPW_Form__r.Category__c != 'IP'){
              pgRef.getParameters().put('Approve','1');
          }
          pgRef.setRedirect(true);
          return pgRef;
      }
      
      public pageReference rejectedRec() {
          
          Id workItemId;
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setComments(mpwChangeRequest.Comments__c);
          req.setAction('Reject');
          if(loggedInProfile.Name == 'System Administrator' || userId.contains(UserInfo.getUserId()) || loggedInProfile.Name == 'CTS Developers'){//|| loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
              workItemId = getWorkItemIdForAdmin(mpwChangeRequest.Id);
          }
          else{
              workItemId = getWorkItemId(mpwChangeRequest.Id, loggedInUser.Id);
          }
          req.setWorkitemId(workItemId);
          Approval.ProcessResult result =  Approval.process(req);
          pageReference pgRef = new pageReference('/apex/MPWChangeRequestViewVF?Id='+mpwChangeRequest.Id);
          pgRef.getParameters().put('Approve','1');
          pgRef.setRedirect(true);
          return pgRef;       
      }
      
      public pageReference recallRec() {
          
          Id workItemId;
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setComments('Recalled');
          req.setAction('Removed');
          if(loggedInProfile.Name == 'System Administrator' || loggedInUser.Id == mpwChangeRequest.CreatedById || loggedInProfile.Name == 'CTS Developers'){//|| loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
              workItemId = getWorkItemIdForAdmin(mpwChangeRequest.Id);
          }
          req.setWorkitemId(workItemId);
          Approval.ProcessResult result =  Approval.process(req);
          pageReference pgRef = new pageReference('/apex/MPWChangeRequestViewVF?Id='+mpwChangeRequest.Id);
          pgRef.setRedirect(true);
          return pgRef;       
      }
      
      public Id getWorkItemId(Id targetObjectId, Id approverUserId){
          Id retVal = null;
          for(ProcessInstanceWorkitem workItem  : [Select p.Id, p.actorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId and p.actorId =: approverUserId]){
              retVal  =  workItem.Id;
          }
          return retVal;
      }
    
      public Id getWorkItemIdForAdmin(Id targetObjectId){
          Id retVal = null;
          for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
              retVal  =  workItem.Id;
          }
          return retVal;
      }
      
      public class wrapperApprover{
          public Id procId{get;set;}
          public String approverName{get;set;}
          public boolean approverId{get;set;}
          public String StepStatus{get;set;}
          public Set<Id> gpMemIds;
          
              public wrapperApprover(Id pId, String aId, String s){
              approverId = false;
              procId = pId;
              if(aId.contains('00G')) {
                  Group gp = [Select Id, Name From Group where Type = 'Queue' And Id =: aId Limit 1];
                  approverName = gp.Name;
                  gpMemIds = getUserIds(gp.Id);
                  for(Id memId : gpMemIds){
                      if(userInfo.getUserId() == memId){
                          approverId = true;
                      }    
                  }
              } else { 
                  User usr = [select Id, Name from User where Id = :aId];
                  approverName = usr.Name;
                  if(userInfo.getUserId() == usr.Id){
                      approverId = true;
                  }
              }
              StepStatus = s;
          }
      }
      
      public class notesAndAttachments {
        public Attachment oAttachment {get; set;}
        public Note oNote {get; set;}
      }
}