/*
Type Name: ClsR_TeamRoomDetail  Class
Author: Global Foundries (Dinesh Suggala) 
Created Date: 13-06-2017
Reason: This Page is used for overriding team room view page and display the corresponding details of the team room 
Change History:
Author: Dinesh Suggala    
Modified Date: 28/2/2018
Reason:Added the code to check ITAR Expiry date in HCM Employee.If it is expired then we are making boolean "userd" to true.

*/
public class ClsR_TeamRoomDetail {
    
    public Boolean isOwnerorAdmin { get ; set ;} // boolean to  check whether the current user is the team room owner or an admin
    public Boolean isAddDelMember { get ; set ;} // boolean to  check whether the current user has the permission to add or delete related members
    public Boolean isAdmin {get;set;}
    private Restricted_Team_Room__c objTeamRoom; // current record
    private String currentURL;                   //current url of visualforce page
    public Map<Decimal,List<R_Team_Room_Member__c>> mapPageToMemberRecords { get ; set ;} //map to hold the page numbers and the corresponding list of member records mapping
    private Profile objProfile;
    public Boolean blnExternalUser { get ; set ;}
    public String memNotDelMsg { get ; set ;} //string to store the message displayed when a team room member is not allowed to be deleted
    private String totalQuery;//query to retrieve all the corresponding team room details
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    public Map<String,String> mapFieldNameToLabel { get ; set ;} //map to hold the field names to field labels for activities
    public Map<String,String> mapFieldNameToSobjectName { get ; set ;} //map to hold the field names to the sobject they belong to in case of GF Tasks and Meetings
    public Map<String,List<Integer>> mapObjectToLstDisplayNumber { get ; set ;}//map to hold the current displayed page numbers for all sections
    public String accNotDelMsg { get ; set ;}//string to store the message displayed when a team room account is not allowed to be deleted
    private Map<Id,Id> mapAccIdToTeamRoomId;//map of account if to corresponding team room account id
    private Map<String,String> mapObjFieldNameToFieldId;//map to hold id of Team Room Look Up Fields on related pages for prepopulation
    public Map<Decimal,List<Account>> mapPageToAccRecords { get ; set ;} //map to hold the page numbers and the corresponding list of account records mapping
   // public Map<Decimal,List<ActivityWrapper>> mapPageToOpenActRecords { get ; set ;} //map to hold the page numbers and the corresponding list of open activity records mapping
    public Map<Id,String> mapAccountIdToType { get ; set ;}
   // public List<ActivityWrapper> activitywrapper{get;set;}
  //  public List<Task> tasklist{get;set;}
   // public Event event{get;set;}
    public boolean AddAccount{get;set;}
     
    private String recordId;// the ecord id of the current team room
    public Integer currentMemberPage { get ; set ;} // the current displayed page of related team room members
    public Integer currentActPage { get ; set ;} // the current displayed page of related team room accounts
    public Integer currentOpenActPage { get ; set ;} // the current displayed page of related open activities
    
    private Integer accPageSize = 0;//page size of account section
    private Integer memberPageSize =0;//page size of member section

    
    public List<ContentDocumentLink> ContentDocumentList{get;set;}
    public List<ContentDocumentLinkWrapper> listwrapper{get;set;}
    public String SNodeId{get;set;}
    public String CurrentId;
    public Boolean ITARUSER{get;set;}
    public Boolean FirstNode{get;set;}
    public Folder__c folder{get;set;}
    public boolean displayPopup {get; set;} 
    public boolean showonclick{get;set;}
    public boolean userd {get;set;}
     
    public ClsR_TeamRoomDetail(ApexPages.StandardController controller) {
    recordId=((Restricted_Team_Room__c)controller.getRecord()).Id;
    isOwnerorAdmin =false;
    isAdmin=false;
    isAddDelMember =false;
    AddAccount=false;
    ITARUSER=false;
    currentActPage =1;
    currentMemberPage =1;
   // currentOpenActPage =1;
    currentURL=ApexPages.currentPage().getURL();
    CurrentId= ApexPages.currentPage().getParameters().get('Id');
    mapPageToMemberRecords =new Map<Decimal,List<R_Team_Room_Member__c>>();
    mapFieldNameToLabel=new Map<String,String>();
    mapFieldNameToSobjectName =new Map<String,String>();
    mapObjectToLstDisplayNumber =new Map<String,List<Integer>>();
    mapAccIdToTeamRoomId=new Map<Id,Id>();
    mapObjFieldNameToFieldId=new Map<String,String>();
    mapPageToAccRecords =new Map<Decimal,List<Account>>();
   // mapPageToOpenActRecords =new Map<Decimal,List<ActivityWrapper>>();
    mapAccountIdToType =new Map<Id,String>();
    //activitywrapper=new List<ActivityWrapper>();
    folder=new Folder__c();
    displayPopUp=false;
    showonclick=false;
    userd=false;
    
    //Added by Dinesh 28/2/2018
    set<Id> userhcmids=new set<Id>();
    set<Id> usercontids=new set<Id>();
    for(User u:[SELECT Id,ContactId,HCM_Record_ID__c FROM User WHERE Id =:userinfo.getUserId()]){
     userhcmids.add(u.HCM_Record_ID__c);
     usercontids.add(u.ContactId);
    }
   
    for(HCM_Employee__c hcmemp:[Select Id,ITAR_EndDate__c from HCM_Employee__c where Id=:userhcmids]){
    system.debug('date****'+hcmemp.ITAR_EndDate__c );
    system.debug('date.today()'+date.today());
     if(hcmemp.ITAR_EndDate__c< Date.today() || hcmemp.ITAR_EndDate__c==null){
     userd =true;
     }
    }
    
     for(Contact con:[Select Id,ITAR_Expiry_Prior_One_Day__c from Contact where Id=:usercontids]){
     if(con.ITAR_Expiry_Prior_One_Day__c< Date.today() || con.ITAR_Expiry_Prior_One_Day__c==null){
     userd =true;
     }
    }
   //Ended by Dinesh 28/2/2018
    
    objProfile=[Select Name from Profile where id=:Userinfo.getProfileId()];
        
    if ((objProfile.Name==System.Label.CustomerPortalAdmin) || (objProfile.Name==System.Label.CustomerPortalProfile) || 
        (objProfile.Name==System.Label.OverageCustomerPortalAdmin) || (objProfile.Name==System.Label.OverageCustomerPortalProfile) ||         
        (objProfile.Name==System.Label.OverageEnablementPartnerPortalAdmin) || (objProfile.Name==System.Label.OverageEnablementPartnerPortalProfile) || 
        (objProfile.Name==System.Label.OverageResellerPortalAdmin) || (objProfile.Name==System.Label.OverageResellerPortalProfile) || 
        (objProfile.Name==System.Label.OverageSupplierPortalAdmin) || (objProfile.Name==System.Label.OverageSupplierPortalProfile) || 
        (objProfile.Name==System.Label.EnablementPartnerPortalAdmin) || (objProfile.Name==System.Label.EnablementPartnerPortalProfile) || 
        (objProfile.Name==System.Label.ResellerPortalAdmin) || (objProfile.Name==System.Label.ResellerPortalProfile) || 
        (objProfile.Name==System.Label.SupplierPortalAdmin) || (objProfile.Name==System.Label.SupplierPortalProfile)) {
            blnExternalUser=true;       
        }else{
            blnExternalUser=false;    
        }
        
      //collect the default page sizes for all sections from custom setting
        Map<String,Default_Page_Size__c> mapSectionToPageSizeConfig=Default_Page_Size__c.getAll();
        if(mapSectionToPageSizeConfig.containsKey('Account')){
            accPageSize=Integer.valueOf(mapSectionToPageSizeConfig.get('Account').Page_Size__c);
        }
        
        if(mapSectionToPageSizeConfig.containsKey('Member')){
             memberPageSize =Integer.valueOf(mapSectionToPageSizeConfig.get('Member').Page_Size__c);
        }
        
    
    
     //construct individual queries for all the related sobjects 
      String teamRoomAccountQuery= '('+constructQuery('R_Team_Room_Account__c','R_Team_Room_Accounts__r','','',new Set<String>{'Account__c','Association_Type__c'})+')';
      String teamRoomMemberQuery='('+constructQuery('R_Team_Room_Member__c','R_Team_Room_Members__r','R_VFTeamRoomDetail_Member_Fields','',new Set<String>{'User__c','Account__c'})+')';
        
      totalQuery='Select Id,OwnerId,RecordType.Name,Name,'+teamRoomAccountQuery+','+teamRoomMemberQuery+
                          ' from Restricted_Team_Room__c where Id =:recordId';
                          
      accNotDelMsg =null;
      queryDetails();
      populateAllFieldMappings();
      populateAccountMap();
      populateMemberMap();
      checkUserPermissions();
      calcDisplayPgNum('Member',1);
      calcDisplayPgNum('Member',1);
      calcDisplayPgNum('OpenActivity',1);
      LoadAllFiles();
      
    }
    
    
    
     /**
        This method is used to query the team room and corresponding related records
        
        @method name: queryDetails
        @parameter:   none
        @return :     none
    **/
    private void queryDetails(){
         objTeamRoom=Database.query(totalQuery);
    }
    
     /**
        This method is used to populate the account map containing the page numbers and corresponding related records
        
        @method name: populateAccountMap
        @parameter:   none
        @return :     none
    **/   
    public void populateAccountMap(){
    
        Set<String> setRelatedAccountIds=new Set<String>();
        mapPageToAccRecords.clear();
        
        try{
            //add the parent account ids to a set
            for(R_Team_Room_Account__c tra:objTeamRoom.R_Team_Room_Accounts__r){
                setRelatedAccountIds.add(tra.Account__c);
                mapAccIdToTeamRoomId.put(tra.Account__c,tra.Id);
                mapAccountIdToType.put(tra.Account__c,tra.Association_Type__c);
            }
            //construct query to retrieve parent account details
            String query=constructQuery('Account','','R_VFTeamRoomDetail_Account_Fields','Id in:setRelatedAccountIds',null);
            List<Account> lstCurrent=new List<Account>();//list to hold the accounts to be added to the current page
            
            List<Account> lstAcc = Database.query(query);
            for(Integer i=1;i<=lstAcc.size();i++){ 
                lstCurrent.add(lstAcc[i-1]);      
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration
                if(math.mod(i,accPageSize)==0 || i==lstAcc.size()){
                      Decimal t=i;                     
                      Decimal pageNumber=t/accPageSize;
                      pageNumber=pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToAccRecords.put(pageNumber,lstCurrent);                     
                      lstCurrent=new List<Account>();
                }
            }
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
   /**
        This method is used to get the total number of Account Section pages through the map size
        
        @method name: getAccMapSize
        @parameter:   none
        @return :     none
    **/   
    public Integer getAccMapSize(){
        return mapPageToAccRecords.size();
    }
    
     /**
        This method is used to populate the field ids from custom settings to help in prepopulation
        
        @method name: populateAllFieldMappings
        @parameter:   none
        @return :     none
    **/ 
    private void populateAllFieldMappings(){
        if(!R_Team_Room_Salesforce_Field_Ids__c.getAll().isEmpty()){
            for(R_Team_Room_Salesforce_Field_Ids__c objSfId:R_Team_Room_Salesforce_Field_Ids__c.getAll().values()){
                mapObjFieldNameToFieldId.put(objSfId.SObject_Name__c+'-'+objSfId.Field_Name__c,objSfId.Id__c);
            }
        }
    }
    
    /**
        This method is used to navigate to the edit team room account page
        
        @method name: goToEditTRAccount
        @parameter:   none
        @return :     pagereference
    **/   
    public pagereference goToEditTRAccount(){
        String accId=ApexPages.currentPage().getParameters().get('accToEdit');
        String traId=mapAccIdToTeamRoomId.get(accId);
        if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){
            return new pagereference('/'+traId+'/e?retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);
        }else{
            return new pagereference('/'+traId+'/e?retURL=/'+objTeamRoom.Id+'&saveURL='+objTeamRoom.Id);
        }
    }
    
    
    /**
        This method is used to navigate to the add team room account page
        
        @method name: goToNewTRAccount
        @parameter:   none
        @return :     pagereference
    **/ 
    public pagereference goToNewTRAccount(){
        
        String accid=Apexpages.CurrentPage().getparameters().get('accToEdit');
       
            return new pagereference('/apex/VFRTeamRoomAccountPage?id='+objTeamRoom.Id +'&recordId='+accid);          
        
    }
    
      /**
        This method is used to delete a member and reconstruct the pages through the coressponding map
        
        @method name: deleteTRAccount
        @parameter:   none
        @return :     none
    **/
    public void deleteTRAccount(){
        try{
            accNotDelMsg =null;
            // the account id is passed
            String accId=ApexPages.currentPage().getParameters().get('accToDelete');
            //the account name is passed
            String accName=ApexPages.currentPage().getParameters().get('accNameToDelete');
            Set<Id> setUserIds=new Set<Id>();
            //add the user ids part of the account teams of the account passed
            for(AccountTeamMember atm:[Select UserId from AccountTeamMember where AccountId=:accId]){
                setUserIds.add(atm.UserId );
            }
            //iterate the team room members to check if any team room member is part of the account team of the account passed
            for(R_Team_Room_Member__c trm:objTeamRoom.R_Team_Room_Members__r){
                if(setUserIds.contains(trm.User__c)){
                    accNotDelMsg = 'This team room account for '+accName+' cannot be deleted as a team member is a part of the account team';
                    break;
                }
            }
            //if any team room member is not a part of the account team of the account passed,the team room account can be deleted
            if(accNotDelMsg==null){
                String traId=mapAccIdToTeamRoomId.get(accId);
                R_Team_Room_Account__c tra=new R_Team_Room_Account__c(Id=traId);
           
                delete tra;
                deleterelatedmembers();
                queryDetails();
                populateAccountMap();
            }
            
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void deleterelatedmembers(){
    String accountId=ApexPages.currentPage().getParameters().get('accToDelete');
    List<R_Team_Room_Member__c> deletememblist=[Select Id,User__c, Restricted_Team_Room__c,Team_Room_Role__c,Account__c
                                                        From R_Team_Room_Member__c where Restricted_Team_Room__c=: recordId and Account__c=:accountId];
     if(deletememblist.size()>0){
      delete deletememblist; 
     }
    }
    
     /**
        This method is used to check whether the current user has the permission to add or delete related members
        
        @method name: checkUserPermissions
        @parameter:   none
        @return :     none
    **/
    public void checkUserPermissions(){
    
       
        List<RecordType> rtByName= [SELECT Name FROM RecordType WHERE SObjectType = 'Restricted_Team_Room__c' and (Name='GLOBALFOUNDRIES Internal' or Name='GLOBALFOUNDRIES with Single party')];
        
        if(objTeamRoom.RecordType.Name==rtByName[0].Name || objTeamRoom.RecordType.Name==rtByName[1].Name){
        AddAccount=true;
        }
        
        //check if the current user is the owner of the team room 
        if(objTeamRoom.OwnerId==UserInfo.getUserId()){
              isOwnerorAdmin =true;
               isAddDelMember=true;
        }
        else{
            //else check if the current user is a system administrator
            for(Profile p:[Select Id from Profile where Name='System Administrator' OR Name='GF Global Admin' OR Name='GF System Admin' OR Name='GF Regional Admin']){
                if(UserInfo.getProfileId()==p.Id){
                    isAddDelMember=true;
                    isOwnerorAdmin =true;
                    isAdmin=true;
                    break;
                }
            }
        }
        //else check if the current user is a moderator
        if(!isAddDelMember){
            for(R_Team_Room_Member__c trm:objTeamRoom.R_Team_Room_Members__r){
                if(trm.User__c==UserInfo.getUserId() && trm.Team_Room_Role_Formula__c=='Moderator'){
                    isAddDelMember=true;
                }
            }
        }
       
        
    }
    
    /**
        This method is used to navigate to the new Member page
        
        @method name: goToNewMember
        @parameter:   none
        @return :     pagereference
    **/  
    public pagereference goToNewMember(){
    system.debug('Enter member loop');
         if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){     
            return new pagereference('/apex/VFR_TeamRoomManageMembership?id='+objTeamRoom.Id+'&'+'retURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id);
         }else{
            return new pagereference('/apex/VFR_TeamRoomManageMembership?id='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
         }
    }
    
 
    /**
        This method is used to populate the member map containing the page numbers and corresponding related records
        
        @method name: populateMemberMap
        @parameter:   none
        @return :     none
    **/   
    public void populateMemberMap(){
        List<R_Team_Room_Member__c> lstCurrent=new List<R_Team_Room_Member__c>();//list to hold the accounts to be added to the current page
        mapPageToMemberRecords.clear();
        try{
            List<R_Team_Room_Member__c> lstMem = objTeamRoom.R_Team_Room_Members__r;
            //loop in the related Team Room Members
            for(Integer i=1;i<=lstMem .size();i++){ 
                lstCurrent.add(lstMem [i-1]);     
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration   
                if(math.mod(i,memberPageSize)==0 || i==lstMem.size()){
                      Decimal t=i;                      
                      Decimal pageNumber=t/memberPageSize;
                      pageNumber=pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToMemberRecords.put(pageNumber,lstCurrent);
                      lstCurrent=new List<R_Team_Room_Member__c>();
                }
            }
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
     /**
        This method is used to get the total number of Member Section pages through the map size
        
        @method name: getMemberMapSize
        @parameter:   none
        @return :     none
    **/
    public Integer getMemberMapSize(){
        return mapPageToMemberRecords.size();
    }
    
     /**
        This method is used to delete a member and reconstruct the pages through the coressponding map
        
        @method name: deleteMember
        @parameter:   none
        @return :     none
    **/
   public void deleteMember(){
        try{
            String memberId=ApexPages.currentPage().getParameters().get('memberId');           
            User Userobj=[Select Id,AccountId from User where Id=:UserInfo.getUserId()];
            R_Team_Room_Member__c delTeamRoomMember=[Select Id,User__r.AccountId from R_Team_Room_Member__c Where Id=:memberId];
            if(blnExternalUser==true && (Userobj.AccountId==delTeamRoomMember.User__r.AccountId) || blnExternalUser==false){
                R_Team_Room_Member__c trm=new R_Team_Room_Member__c(Id=memberId);
                delete trm;
                queryDetails();
                populateMemberMap();
            }else{
                memNotDelMsg ='Cannot delete Member of another account';
            }
           
            
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    /**
        This method is used to navigate to the next page of records corresponding to the section name passed
        
        @method name: next
        @parameter:   none
        @return :     none
    **/ 
    public void next(){
        //get the object section name passed
        String objectTonavigate=ApexPages.currentPage().getParameters().get('objectTonavigate');
        if(objectTonavigate=='Account'){
            currentActPage =currentActPage +1;
            calcDisplayPgNum(objectTonavigate,currentActPage );
        }else if(objectTonavigate=='Member'){
            currentMemberPage =currentMemberPage +1;
            calcDisplayPgNum(objectTonavigate,currentMemberPage );
        }
        
        
    } 
    
    /**
        This method is used to navigate to the previous page of records corresponding to the section name passed
        
        @method name: previous
        @parameter:   none
        @return :     none
    **/ 
    public void previous(){
        //get the object section name passed
        String objectTonavigate=ApexPages.currentPage().getParameters().get('objectTonavigate');
        if(objectTonavigate=='Account'){
            currentActPage =currentActPage -1;
            calcDisplayPgNum(objectTonavigate,currentActPage);
        }else if(objectTonavigate=='Member'){
            currentMemberPage =currentMemberPage -1;
            calcDisplayPgNum(objectTonavigate,currentMemberPage);
        }
        
    } 
    
    /**
        This method is used to navigate to the first page of records corresponding to the section name passed
        
        @method name: first
        @parameter:   none
        @return :     none
    **/  
    public void first(){
       //get the object section name passed
        String objectTonavigate=ApexPages.currentPage().getParameters().get('objectTonavigate');
        if(objectTonavigate=='Member'){
            currentMemberPage =1;
            calcDisplayPgNum(objectTonavigate,currentMemberPage);
        }
        else  if(objectTonavigate=='Account'){
            currentActPage =1;
            calcDisplayPgNum(objectTonavigate,currentActPage);
            } 
    }
    
    /**
        This method is used to navigate to the last page of records corresponding to the section name passed
        
        @method name: last
        @parameter:   none
        @return :     none
    **/  
    public void last(){
       //get the object section name passed
        String objectTonavigate=ApexPages.currentPage().getParameters().get('objectTonavigate');
        if(objectTonavigate=='Member'){
            currentMemberPage =mapPageToMemberRecords.size();
            calcDisplayPgNum(objectTonavigate,currentMemberPage );
        }  
        else  if(objectTonavigate=='Account'){
            currentActPage =mapPageToAccRecords.size();
            calcDisplayPgNum(objectTonavigate,currentActPage);
        }
    }
    
    /**
        This method is used to calculate the list of page numbers to be displayed for the corresponding section
        
        @method name: calcDisplayPgNum
        @parameter:   sectionName - name of the section passed where pages have to be recalculated
                      p-the page number clicked on the visualforce page 
        @return :     none
    **/
    private void calcDisplayPgNum(String sectionName,Integer p){
         
         Integer lastPgNum;

         if(sectionName=='Member'){
             lastPgNum=mapPageToMemberRecords.size();
             currentMemberPage =p;
         }
         else if(sectionName=='Account'){
             lastPgNum=mapPageToAccRecords.size();
             currentActPage=p;
          }
         
         List<Integer> lstPageNumbers= mapObjectToLstDisplayNumber.get(sectionName);
         //rearrange the page numbers
         if(p==1){
            lstPageNumbers =new List<Integer>{p,p+1,p+2};
        }
        else if(p==lastPgNum){
           lstPageNumbers =new List<Integer>{p-2,p-1,p};
        }
        else{
            lstPageNumbers =new List<Integer>{p-1,p,p+1};
        }
        mapObjectToLstDisplayNumber.put(sectionName,lstPageNumbers);
    }
    
    /**
        This method is used to update the Page Number display when clicked on a page number
        
        @method name: updatePageNumberDisplay
        @parameter:   none
        @return :     none
    **/
    public void updatePageNumberDisplay(){
        String sectionName=ApexPages.currentPage().getParameters().get('objectTonavigate');
        Integer p=Integer.valueOf(ApexPages.currentPage().getParameters().get('selectedPageNum'));        
        calcDisplayPgNum(sectionName,p);
       
    }
    
    
     /**
        This method is used to construct the query
        
        @method name: constructQuery
        @parameter:   sObjectName-name of the object to be queried
                      relationshipName-name of the relationship to be queried
                      fieldSetName-name of the field sets from where fields are to be picked
                      whereClause-where clause to be used in the query
                      additionalFields-any additional fields to be queried apart from field sets
        @return :     String
    **/ 
    private String constructQuery(String sObjectName,String relationshipName,String fieldSetName,String whereClause,Set<String> additionalFields){

        
        try{
            String query = 'SELECT Id';
            Set<String> fields=new Set<String>{'Id'};
            if(additionalFields!=null){
                for( String fs : additionalFields ) {                   
                   //add only unique fields
                   if(!fields.contains(fs)){
                       //maintain a set of fields so that only unique fields are added in query
                       fields.add(fs);
                       query = query+','+fs;
                   }        
                }
            }
            //describe the provided sObject
            Schema.DescribeSObjectResult res=globalDescribe.get(sObjectName).getDescribe();
            //get the fields set map
           
            Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap();        
            
            if(fieldSetName!=''){
               Schema.FieldSet fs = fieldSetMap.get(fieldSetName);
                for( Schema.FieldSetMember fsm : fs.getFields() ) {                   
                   //add only unique fields
                   if(!fields.contains(fsm.getFieldPath())){
                       //maintain a set of fields so that only unique fields are added in query
                       fields.add(fsm.getFieldPath());   
                               
                       query = query+','+fsm.getFieldPath();
                      /* if(sObjectName=='R_GF_Task__c' || sObjectName=='R_Team_Room_Meeting__c'){
                           mapFieldNameToLabel.put(fsm.getFieldPath(),fsm.getLabel());    
                           if(mapFieldNameToSobjectName.containsKey(fsm.getFieldPath())){
                               mapFieldNameToSobjectName.put(fsm.getFieldPath(),'Both');
                           }
                           else{
                               mapFieldNameToSobjectName.put(fsm.getFieldPath(),sObjectName);
                           }
                       }*/
                   }        
                }
            }
            if(relationshipName==''){
                query = (whereClause == '' || whereClause ==null) 
                                ? (query + ' FROM '+sObjectName) 
                                : (query + ' FROM '+sObjectName+ ' WHERE ' + whereClause);
            }
            else{
                query = (whereClause == '' || whereClause ==null) 
                                ? (query + ' FROM '+relationshipName) 
                                : (query + ' FROM '+relationshipName+ ' WHERE ' + whereClause);
            }
            
            return query;
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }   

     public void Displayattachments(){
      showonclick=false;
      if(!Test.isRunningTest()){
      ContentDocumentList=[SELECT ContentDocument.LatestPublishedVersionId, ContentDocumentId, ContentDocument.Title, LinkedEntityId,ContentDocument.Fileextension, ContentDocument.ContentModifiedDate, ContentDocument.Owner.Name from ContentDocumentLink where LinkedEntityId =:SNodeId ];
      
      List<Folder__c> folderlist=[Select Id,Name from Folder__c where Id=:SNodeId];
      listwrapper=new List<ContentDocumentLinkWrapper>();
      for(ContentDocumentLink feed:ContentDocumentList){
       listwrapper.add(new ContentDocumentLinkWrapper(feed,folderlist[0]));
      }    
      }
     }
    
    public void LoadAllFiles(){
      showonclick=true;
      set<Id> foldersetid=new set<Id>();
      Map<String,Folder__c> FolderMap=new Map<String,Folder__c>();
      for(Folder__c folder:[Select Id,Name,Restricted_Team_Room__c from Folder__c where Restricted_Team_Room__c=:CurrentId]){
       foldersetid.add(folder.Id);
       FolderMap.put(folder.Id,folder);
      }
      
      ContentDocumentList=[SELECT ContentDocument.LatestPublishedVersionId, ContentDocumentId, ContentDocument.Title, LinkedEntityId,ContentDocument.Fileextension, ContentDocument.ContentModifiedDate, ContentDocument.Owner.Name  from ContentDocumentLink where LinkedEntityId=:foldersetid];
      Map<String,String> ContentFolderMap=new Map<String,String>();
      
      for(ContentDocumentLink cd:ContentDocumentList){
      ContentFolderMap.put(cd.Id,cd.LinkedEntityId);
      }

      
      listwrapper=new List<ContentDocumentLinkWrapper>();
      for(ContentDocumentLink f:ContentDocumentList){
        if(FolderMap!=null && ContentFolderMap!=null){
        listwrapper.add(new ContentDocumentLinkWrapper(f,FolderMap.get(ContentFolderMap.get(f.Id))));
        }
      }

    }
    
   
    public pageReference DeleteRow() {

        List<ContentDocumentLink> listEmpForDel = new List<ContentDocumentLink>();
        List<ContentDocumentLink> listEmpForDelOwners = new List<ContentDocumentLink>();
        List<ContentDocumentLinkWrapper> listTempWrapper = new List<ContentDocumentLinkWrapper>();
        for(ContentDocumentLinkWrapper w : listwrapper) {
            if(w.selected==true && w.content.ContentDocument.Owner.Id==Userinfo.getuserid()) {
                system.debug('Enter selected loop');
                listEmpForDel.add(w.content);
            }
            else if(w.selected==true && w.content.ContentDocument.Owner.Id!=Userinfo.getuserid()){
                listEmpForDelOwners.add(w.content);
            }
             else {
                listTempWrapper.add(w);
            }
        }

        if(listEmpForDel.size() > 0) {
            delete listEmpForDel;
            listwrapper= listTempWrapper;
        }
        else if(listEmpForDelOwners.size()>0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot delete the file as you are not the Owner of the File'));
        }
         else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select at least one attachment to delete'));
        }
        return null;
    }
    
    public pagereference savefolder(){
        system.debug('Method is calling again');
        folder.Restricted_Team_Room__c=CurrentId;
        insert folder;     
        displayPopup = false;      
        return null; 
    }
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {  
        folder=new Folder__c();      
        displayPopup = true;    
    }
    
    
    
    public Class ContentDocumentLinkWrapper{
     
     public boolean selected{get;set;}
     public ContentDocumentLink content{get;set;}
     public Folder__c folder{get;set;}
     
      public ContentDocumentLinkWrapper(ContentDocumentLink contentdocumentlink,Folder__c folderw){
      this.content=contentdocumentlink;
      this.folder=folderw;
      this.selected=false;
      }
      

    }   
    
}