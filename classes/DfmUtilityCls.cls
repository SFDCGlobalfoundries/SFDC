/*
* @ Author :- Navneet Rajput
* @ Description :- Utility class for common functions 
* @ Date :-10/11/2015
* @ Change History :-  Mohan 11/01/2017 
**/

public without sharing class DfmUtilityCls {
    
    public static integer ruleCount=0; 
    public static boolean loadFromMantis=false; 
    public static boolean stopTrigger=false;
    public static boolean initialExecution=false;
	public DfmUtilityCls(){
        
    }
    
    @future
    public static void updateCollaborator(string JSONString){
      Wavier_Collaborator__c w=(Wavier_Collaborator__c)JSON.deserialize(JSONString, Wavier_Collaborator__c.class);
      update w;
    }
    // method help to get users from public froup
    
    public static map<id,GroupMember> getUsersFromPublicGroup(String pGroupName){
        
        map<id,GroupMember> mapOfGroupMembers = new map<id,GroupMember>();
        
        List<Group> pGroup = [SELECT ID,Name FROM Group WHERE DeveloperName = : pGroupName];
        if (pGroup<>NULL && !pGroup.isEmpty()){
            
             for (GroupMember gMember : [Select Id, UserOrGroupId From GroupMember Where GroupId = :pGroup[0].Id]){
                mapOfGroupMembers.put(gMember.UserOrGroupId,gMember);   
            }
        }
        if (mapOfGroupMembers<>NULL && !mapOfGroupMembers.isEmpty()){
            return mapOfGroupMembers;
        }
         return null;
    } 
    
    // pass account short name and method will return list of FAE user ids
    
    public static Set<Id> getATPUsersByRole (String accShortName,list<String> teamRoles){
        set<Id> userIds = new set<Id>();
        List<Account_Team_Proxy__c> listOfATP;
        Boolean isFAE=false;
        
        for(String teamRole : teamRoles){
            if(teamRole=='Field Application Engineer' || teamRole=='Primary Field Application Engineer'){
                isFAE=true;
            }
        }
        
        if (accShortName<>NULL && !String.isEmpty(accShortName)){
            if(isFAE){
                 listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
                                                            Team_Role__c,Account__r.Short_Name__c 
                                                     FROM Account_Team_Proxy__c 
                                                     WHERE (Is_FAE__c=true OR Team_Role__c IN  : teamRoles) AND  User__r.IsActive = true AND Account__r.Short_Name__c =: accShortName];
                                                     
                                                     
            }else{
            listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,Team_Role__c,Account__r.Short_Name__c  FROM Account_Team_Proxy__c  WHERE Team_Role__c IN : teamRoles AND  User__r.IsActive = true AND Account__r.Short_Name__c =: accShortName];
            }
        }                                        
        
        if (listOfATP<>NULL && !listOfATP.isEmpty()){
            
            for (Account_Team_Proxy__c ATP : listOfATP){
                if (ATP.User__c<>NULL){
                    userIds.add(ATP.User__c);
                }
            }
        }
        
        return userIds;
    } 
    
    //This will return the Account Managers which have FAE flag as True.
    public static Set<Id> getATPUsersByRoleFAEflag(String accShortName){
        set<Id> userIds = new set<Id>();
        List<Account_Team_Proxy__c> listOfATP;
        if (accShortName<>NULL && !String.isEmpty(accShortName)){
            listOfATP = [SELECT Id,Name,Account_Short_Name__c,Account__c,User__c,
                                Team_Role__c,Account__r.Short_Name__c 
                         FROM Account_Team_Proxy__c 
                         WHERE (  ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                               OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE)) AND  User__r.IsActive = true
                         AND Account__r.Short_Name__c =: accShortName];
        }
        if (listOfATP<>NULL && !listOfATP.isEmpty()){
            for (Account_Team_Proxy__c ATP : listOfATP){
                if (ATP.User__c<>NULL){
                    userIds.add(ATP.User__c);
                }
            }
        }
        return userIds;
    }
  
    // Share record with public group or user
    public static boolean shareRecord(Id objId, Set<Id> grOrUsrId,String accessLevel){
        
        Boolean isSuccess = false;
        List<Wavier_Collaborator__Share> lstOfWaivers = new List<Wavier_Collaborator__Share>();
        
        if (grOrUsrId<>NULL && !grOrUsrId.isEmpty()){
            for (Id uId : grOrUsrId){
                Wavier_Collaborator__Share waiverShare = new Wavier_Collaborator__Share();
                waiverShare.ParentId = objId;
                waiverShare.UserOrGroupId = uId;
                waiverShare.AccessLevel = accessLevel;
                lstOfWaivers.add(waiverShare);
            }
            if (lstOfWaivers<>NULL && !lstOfWaivers.isEmpty()){
                 Try{
                Database.SaveResult[] result = Database.Insert(lstOfWaivers,false);
                isSuccess = DfmUtilityCls.validateResult(result);
            }Catch(Exception e){
            GlobalUtility.logMessage('Debug', 'DfmUtilityCls', 'shareRecord()', +String.valueOf(lstOfWaivers), 'sharing record to public group or user ' ,'this is error message', 'payLoad','Other SFDC',e,2300);
        }
       }
    }
                         
        return isSuccess;
    }
    
    // Validate DML result and return True is success and false if Error
    public static boolean validateResult(Database.SaveResult[] result){
        
        for (Database.SaveResult sr : result) {
            if (sr.isSuccess()){
                system.debug('SUccessfully inserted record  :: '+sr.getId());
                return true;
                
            } else {
                
                 for(Database.Error err : sr.getErrors()) { return false;
                 }
            }
        }
        
        return true;
    }
    
    // Get set of user ids by passing created and submited name
    public static Set<Id> getCustomers(String createdByNames,String submitedByNames){
        
        Map<Id,User> useMap;
        List<String> userFederationIds = new List<String>();
        
        if (createdByNames<> NULL && !String.isEmpty(createdByNames)){
            userFederationIds.add(createdByNames);
        }
        if (submitedByNames <> NULL && !String.isEmpty(submitedByNames)){
            userFederationIds.add(submitedByNames);
        }
        if (userFederationIds<>NULL && !userFederationIds.isEmpty()){
            useMap = new Map<Id,User>([SELECT Id,Name,FederationIdentifier,HCM_Employee_ID__c,HCM_Login_ID__c FROM User WHERE FederationIdentifier IN : userFederationIds OR HCM_Employee_ID__c IN : userFederationIds OR HCM_Login_ID__c IN : userFederationIds]); 
        }                                             
        if (useMap<>NULL && !useMap.isEmpty()){
            
            return useMap.keySet();
        }   else {
            
            return null;
        }                   
    }
    
    // get email ids by passing user ids
    public static List<String> getEmailIds(Set<Id> uIds){
        
        List<User> users;
        List<String> userEmailIds = new List<String>();
        
        if (uIds<>NULL && !uIds.isEmpty()){
            users = [SELECT Id,Name,Email FROM User WHERE Id IN : uIds];
        }
        if (users<>NULL && !users.isEmpty()){
            for (User u : users){
                userEmailIds.add(u.Email);
            }
        }
        return userEmailIds;
    }
    
    // create notification url for approval process
    public static String generateApprovalURL(Id rId){  
      String approvalUrl='';  
        
      List<ProcessInstanceWorkitem> workItemLst = [SELECT id  
                                                    FROM ProcessInstanceWorkitem  
                                                    WHERE processInstance.TargetObjectId=:rId];   
      if(workItemLst<>NULL && !workItemLst.isEmpty()) { 
         
        approvalUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
     }  
     
     return approvalUrl;  
   }  
    
    // This code help to create custom attachment section (only view attachment) for customers
    public static List<Attachment> getAttachments(Id rId){
    
        List<Attachment> lstOfCustomerAttachments = [SELECT Id,Name,BodyLength,CreatedBy.Name,Body,
                                                            CreatedDate,LastModifiedBy.Name,LastModifiedDate 
                                                    FROM Attachment 
                                                    WHERE ParentId=:rId];
        
        return  lstOfCustomerAttachments;
    }
    
    // get Notes details related to waiver collaborator
    public static List<Note> getNotesForCollaborator(Id dfmId1){
        
        List<Note> wcNotesList = [SELECT CreatedById,CreatedDate,CreatedBy.Name,LastModifiedDate,Title FROM Note WHERE ParentId =:dfmId1];
                     
        return wcNotesList;            
    }

    
    // get prime die name for respective DFM
    public static string getPrimeDieName(Id dfmId){
        
        String chipName = '';
        List<Chip__c> chips = [SELECT Id,Chip_Name__c FROM Chip__c WHERE Wavier_Collaborator__c =: dfmId];
        if (chips<>NULL && !chips.isEmpty()){
            for (Chip__c chip : chips){
                if (chipName==''){
                    chipName = chip.Chip_Name__c;
                } else {
                    chipName = chipName +','+ chip.Chip_Name__c;//chips.get(0).Chip_Name__c;
                    
                }
            }
        }
        return chipName;
    }
    
    /*
      * @ Description :- Method help to return on standard list view of respective object. We need to pass object APi name to below mwthod. 
      * @ Date :-
      * @ Change History :-
    */
    public static pageReference returnToListView(String objectName){ 
        system.debug('Inside returnToListView >>>>>>>>>>> ');
        Map<String,Schema.SObjectType> describeResultMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = describeResultMap.get(objectName);
        Schema.DescribeSObjectResult sObjectSchema = sobjType.getDescribe();
        String objectIdPrefix = sObjectSchema.getKeyPrefix();
        PageReference pageReference = new PageReference('/'+objectIdPrefix+'/o');
        pageReference.setRedirect(true);
        
        return pageReference;
      
    }
  
    // General method to get all the fields for the given Object
    public static string getAllFields(string objectName){
        String fieldnames = '';
        String sql='';
        sObject obj;
        try{
            Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe();
            Schema.Sobjecttype s = m.get(objectName);
            Schema.Describesobjectresult r = s.getDescribe(); 
            
            //get fields
            Map<String, Schema.Sobjectfield> fields = r.fields.getMap();
            for(string field: fields.keySet()){
                if(fieldnames == ''){
                    fieldnames = field;
                }
                else{
                    fieldnames += ',' + field; 
                }
            }
        }
        catch(Exception e){
            GlobalUtility.logMessage('Debug', 'DfmUtilityCls', 'getAllFields()', +String.valueOf(fieldnames), 'all field names' ,'this is error message', 'payLoad','Other SFDC',e,2300);
            
            return null;
        }
        return fieldnames;
    }
    
    // Get set of user ids for DRB Group
    public static Set<Id> getUsersForDRBGp(String DRBGroupIds){

        Map<Id,User> useMap;
        List<String> userFedIds = new  List<String>();
        
        if(DRBGroupIds <> null && !String.isEmpty(DRBGroupIds)){
            for (String str : DRBGroupIds.split(',')){
                userFedIds.add(str.trim());
            }
        }
        
        if (userFedIds<>NULL && !userFedIds.isEmpty()){
          
            useMap = new Map<Id,User>([SELECT Id,Name,FederationIdentifier,HCM_Employee_ID__c,HCM_Login_ID__c 
                                       FROM User
                                       WHERE HCM_Login_ID__c IN : userFedIds]);                                         
        }                                        
        if (useMap<>NULL && !useMap.isEmpty()){
            
            return useMap.keySet();
        }   else {
            
            return new Set<Id>();
        }                   
    }
    
     public static String drbNames(String drbGrpIds){  
       
        Set<Id> dRBGroupIds = getUsersForDRBGp(drbGrpIds); 
        String drbNameString;
        List<User> useMap = [SELECT Id,Name FROM User  WHERE Id IN : dRBGroupIds];
         for ( User usr :useMap ){
             if(String.isEmpty(drbNameString)){  drbNameString=usr.Name;
             }else{ drbNameString += ';'+usr.Name;
             }
         }
         
         return drbNameString;
            
    }
        
    public static List<String> drbEmailIDs(String drbGrpIds){  
       
        Set<Id> dRBGroupIds = getUsersForDRBGp(drbGrpIds); 
        
        if(dRBGroupIds <> null && !dRBGroupIds.isEmpty()){     
            return getEmailIds(dRBGroupIds);
        }else {
            return null;
        }
    }
    
    // get chip details related to waiver collaborator
    public static List<Waiver_Rule_List__c> getWaiverRuleList(Id drcId1){
        List<Waiver_Rule_List__c> waiverRuleList= [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:drcId1 AND Rule_Type__c !='' ORDER BY Rule_Type__c DESC,Prime_Die_Name__c ASC limit 9999];        
                                
        return waiverRuleList;           
    }
    //Query for PDF 
     public static List<Waiver_Rule_List__c> getWaiverRuleListForPDF(Id drcId1){
        List<Waiver_Rule_List__c> waiverRulesList= [SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,Prime_Die_Comment__c ,Rule_Type__c,Customer_Closing_Comment__c,GF_Review_Result__c,Rule_Final_Status__c,isIntermediateSave__c,
                                                   Customer_Review_Request__c,Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,
                                                   GF_Review_Results__c,Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,
                                                   IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,AcceptRisk__c,Is_Sync_with_AIA__c,LastModifiedDate,Operation_Type__c,Disagree__c,Old_Image_Path__c,Warning__c,RecallApprovalProcess__c,
                                                   MantisId__c,Revert_Rule__c ,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,
                                                   Stage__c,Waiver_Collaborator__c,Prime_Die_Name__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c  =:drcId1 AND Rule_Type__c=:'' ORDER BY Prime_Die_Name__c ASC  limit 9999];        
                                
        return waiverRulesList;           
    }
    
   
    
    
     public static Map<Id,Waiver_Rule_List__c> getWaiverRuleRecordMap(List<Id> wrcIDList){
        
        Map<Id,Waiver_Rule_List__c> wrObjMap=new Map<Id,Waiver_Rule_List__c>([SELECT Id,Design_Rule_Name__c, Rule_Description__c,Stage__c,Final_Stage__c,Waiver_Collaborator__c  FROM Waiver_Rule_List__c WHERE Id IN :wrcIDList AND Waiver_Collaborator__r.PTSR_Service_Type__c LIKE '%DRC%' ]);
        
        return wrObjMap; 
        
    }  
    
    public static Map<Id,String>  getGroupNamesForList(List<Id> useridsFromPI){
         String grpName;
         Group gMember= new Group();
         
         Map<Id,String> nameMap = new  Map<Id,String>();
         try{
            Map<Id,Group> gMemberMap   =  new Map<Id,Group>([SELECT Name,Id from Group where Group.Id IN :useridsFromPI ]);
            //System.debug('===gMemberMap size====='+gMemberMap.size());
            
              for ( ID aID : gMemberMap.keySet() ){
                 gMember = gMemberMap.get(aID);
                 if(gMember<>null){
                         //System.debug('===inside gMember object =====');
                         grpName= gMember.Name;
                         //System.debug('===inside gMember object  groupname====='+grpName);
                         nameMap.put(aID, grpName);
                     }
                 
              }
            
            
         //}Catch(System.QueryException ex){
          //  GlobalUtility.logMessage('Debug', 'DfmUtilityCls', 'getGroupNamesForList()', +String.valueOf(gMember), 'FOUND No group name' ,'this is error message', 'payLoad','Other SFDC',ex,2300); 
            // System.debug('==FOUND No group name =='+ex.getMessage()); 
         }Catch(Exception ex){
             GlobalUtility.logMessage('Debug', 'DfmUtilityCls', 'getGroupNamesForList()', +String.valueOf(gMember), 'Caught generic exception' ,'this is error message', 'payLoad','Other SFDC',ex,2300);
            //System.debug('==Caught generic exception =='+ex.getMessage()); 
         }
         
        
         if(nameMap<>null && !nameMap.isEmpty()){ 
            return nameMap;
         }else {
             return null;
         }
         
     } 
    
      public static List<Wavier_Collaborator__History>  getClosingSectionList(Id dfmId){         
         
          List<Wavier_Collaborator__History> historyList = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedBy.Name FROM Wavier_Collaborator__History WHERE ParentId =:dfmId ORDER BY CreatedDate DESC];
          List<Wavier_Collaborator__History> historyListTemp = new List<Wavier_Collaborator__History>(); 
          for (Wavier_Collaborator__History hstry : historyList ){
            if(hstry.Field.toLowerCase()=='locked'){ historyListTemp.add(hstry);
             }
              break;
          }
          
          return historyListTemp;
      }
    
    public static Wavier_Collaborator__c getWaiverCollaborator(Id drcId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        query +=  'Account_Manager_Approver1__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,'
            +'Approval_Field_Engineer__c,CreatedById,CreatedDate,Customer_Full_Name__c,'           
            +'DRB_Group_uIds__c,Selected_Customers__c,Tapeout_Layers__c,isCustomerSelectionSubmitted__c,'       
            +'Id,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,Is_releasedToCustomer__c,'
            +'LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,MantisId__c,'
            +'Prime_Die_Name__c  '
            +' FROM Wavier_Collaborator__c WHERE Id =:drcId LIMIT 1';
        
        return Database.query(query);
    }
    
    
    // get waiver collaborator field information from respective field sets
    public static List<Schema.FieldSetMember> getFields() {
        boolean isStandardUser;
        boolean isPortalUser ;
        boolean isDfmUser ;
        boolean isDfmManager;
        if (UserInfo.getUserType()!='Standard'){
            isStandardUser = false;
            isPortalUser = true;
            return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_Custome_View.getFields();
            
        } else {           
            isStandardUser = true;
            isPortalUser = false;            
        }
        return SObjectType.Wavier_Collaborator__c.FieldSets.DFM_FAE_View.getFields();
    }
    
    
}