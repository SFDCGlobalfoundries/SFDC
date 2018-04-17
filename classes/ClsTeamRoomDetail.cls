/*
Type Name: clsTeamRoomDetail
Author: Cognizant 
Created Date: 21st-May-2013
Reason: This class is used as the controller to the VF Page VFTeamRoomDetail to retrieve the corresponding data
Change History:Case-4331
Author: Cognizant FV Team
Modified Date: Jan-08-2014
Reason: Replacing Portal Login ID with Federation ID  
……..
……..
*/
public with sharing class ClsTeamRoomDetail {

    public Boolean showNotesAndAttachments { get ; set ;} // boolean to  check whether show notes and Attachments for the record Type   
    public Integer currentActPage { get ; set ;} // the current displayed page of related team room accounts
    public Integer currentMemberPage { get ; set ;} // the current displayed page of related team room members
    public Integer currentOpenActPage { get ; set ;} // the current displayed page of related open activities
    public Integer currentActHistPage { get ; set ;}  // the current displayed page of related activity histories
    public Map<Decimal,List<Account>> mapPageToAccRecords { get ; set ;} //map to hold the page numbers and the corresponding list of account records mapping
    public Map<Decimal,List<Team_Room_Member__c>> mapPageToMemberRecords { get ; set ;} //map to hold the page numbers and the corresponding list of member records mapping
    public Map<Decimal,List<ActivityWrapper>> mapPageToOpenActRecords { get ; set ;} //map to hold the page numbers and the corresponding list of open activity records mapping
    public Map<Decimal,List<ActivityWrapper>> mapPageToActHistRecords { get ; set ;} //map to hold the page numbers and the corresponding list of activity history records mapping
    public Map<String,String> mapFieldNameToLabel { get ; set ;} //map to hold the field names to field labels for activities
    public Map<String,String> mapFieldNameToSobjectName { get ; set ;} //map to hold the field names to the sobject they belong to in case of GF Tasks and Meetings
    public Map<String,List<Integer>> mapObjectToLstDisplayNumber { get ; set ;}//map to gold the current displayed page numbers for all sections
    public Boolean isAddDelMember { get ; set ;} // boolean to  check whether the current user has the permission to add or delete related members
    public Boolean isOwnerorAdmin { get ; set ;} // boolean to  check whether the current user is the team room owner or an admin
    private Team_Room__c objTeamRoom; // current record
    private String totalQuery;//query to retrieve all the corresponding team room details
    private String recordId;// the ecord id of the current team room
    private Integer accPageSize = 0;//page size of account section
    private Integer memberPageSize =0;//page size of member section
    private Integer openActPageSize=0;//page size of open activity section
    private Integer actHistPageSize=0;  //page size of activity history section       
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    private Map<String,String> mapObjFieldNameToFieldId;//map to hold id of Team Room Look Up Fields on related pages for prepopulation
    private String currentURL;//current url of visualforce page
    private Map<Id,Id> mapAccIdToTeamRoomId;//map of account if to corresponding team room account id
    public String accNotDelMsg { get ; set ;}//string to store the message displayed when a team room account is not allowed to be deleted
    public Map<Id,String> mapAccountIdToType { get ; set ;}
    public List<Team_Room_Doc__c> trdocList = new List<Team_Room_Doc__c>();
    public String documentURL{get;set;}
    Public Integer count{get;set;}
    Public Boolean showOpenTextSession{get;set;}
    Public Boolean showWaitSession {get;set;}
    Public Boolean disableremovedocButton{get;set;} 
    private Profile objProfile;
    public Boolean blnExternalUser { get ; set ;}
    Public Boolean blnaddremoveDoc{ get ; set ;}
    public String memNotDelMsg { get ; set ;} //string to store the message displayed when a team room member is not allowed to be deleted
    public String OpenTextLoginServerURL {get; set;}    
    public String portalLoginUser;    
    User portaluserObj = new User();
    public Boolean isMember { get ; set ;}
    
    public Boolean showCalendar { get ; set ;}// added by Sunil Arora for case #19342 to show/hide calendar
    
  //Updated by JOYDEV on 2nd Oct 3013:
    public List<Apttus_Proposal__Proposal__c> LstProposals {get; set;}    
    /**
        This constructor sets the team room sobject details into the sObject. It also instantiate the class for accessing from the page
        
        @method name: ClsVFTeamRoomDetail
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    
    public ClsTeamRoomDetail (ApexPages.StandardController controller) {
        
        showNotesAndAttachments = false;       
        recordId=((Team_Room__c)controller.getRecord()).Id;
        mapObjFieldNameToFieldId=new Map<String,String>();
        currentActPage =1;
        currentMemberPage =1;
        currentOpenActPage =1;
        currentActHistPage =1;
        isAddDelMember =false; 
        isOwnerorAdmin =false;  
        isMember = false;  
        mapPageToAccRecords =new Map<Decimal,List<Account>>();
        mapPageToMemberRecords =new Map<Decimal,List<Team_Room_Member__c>>();
        mapPageToOpenActRecords =new Map<Decimal,List<ActivityWrapper>>();
        mapPageToActHistRecords =new Map<Decimal,List<ActivityWrapper>>();
        mapFieldNameToLabel=new Map<String,String>();
        mapFieldNameToSobjectName =new Map<String,String>();
        mapObjectToLstDisplayNumber =new Map<String,List<Integer>>();
        mapAccountIdToType =new Map<Id,String>();
        mapAccIdToTeamRoomId=new Map<Id,Id>();
        currentURL=ApexPages.currentPage().getURL();
        accNotDelMsg =null;
        //Fields added by Sunil Arora for case # 19342
        Team_Room__c trmopentextObj = [Select OpenText_Id__c,CreatedbyId, Primary_Account__c, Primary_Account__r.RecordTypeId from Team_Room__c where id =:recordId]; 
        //Case-4331:Adding Federation ID in query:Change-001
        portaluserObj = [SELECT Federationidentifier,Portal_Login__c FROM User WHERE Id =:userInfo.getUserId()];        
        //Case-4331:Replacing Portal Login ID with Federation ID:Change-002
        //portalLoginUser = portaluserObj.Portal_Login__c; 
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = portaluserObj.Federationidentifier ;   
        else 
            portalLoginUser = null;     
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        Decimal openTextId = trmopentextObj.OpenText_Id__c;
        System.debug('openTextId -------------->'+openTextId);
        
        //documentURL = System.Label.TR_Documents_URL + openTextId;
         documentURL = System.Label.TR_Documents_URL + openTextId+'&username='+portalLoginUser;
       
        
        trdocList = [Select Id from Team_Room_Doc__c where Team_Room__c =:recordId];
        if(trdocList.size()==0)
            disableremovedocButton = True;
        else
            disableremovedocButton = False;
        
        //collect the default page sizes for all sections from custom setting
        Map<String,Default_Page_Size__c> mapSectionToPageSizeConfig=Default_Page_Size__c.getAll();
        if(mapSectionToPageSizeConfig.containsKey('Account')){
            accPageSize=Integer.valueOf(mapSectionToPageSizeConfig.get('Account').Page_Size__c);
        }
        
        if(mapSectionToPageSizeConfig.containsKey('Member')){
             memberPageSize =Integer.valueOf(mapSectionToPageSizeConfig.get('Member').Page_Size__c);
        }
        
        if(mapSectionToPageSizeConfig.containsKey('Open Activity')){
             openActPageSize=Integer.valueOf(mapSectionToPageSizeConfig.get('Open Activity').Page_Size__c);
        }
        
        if(mapSectionToPageSizeConfig.containsKey('Activity History')){
             actHistPageSize=Integer.valueOf(mapSectionToPageSizeConfig.get('Activity History').Page_Size__c);
        }
        
       objProfile=[Select Name from Profile where id=:Userinfo.getProfileId()];
        //Modified by Sunil Arora for Case # 10023 to add OverageCustomerPortalProfile
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
       //Code added by Sunil Arora for case #19342 to show/hide calendar
       showCalendar=true;
        Set<Id> accRecordTypesSet=new Set<Id>();//to add Customer, Enablement Partner and Reseller record types below
        accRecordTypesSet.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        accRecordTypesSet.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Enablement Partner').getRecordTypeId());
        accRecordTypesSet.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller').getRecordTypeId());

        if(trmopentextObj.Primary_Account__c !=null && accRecordTypesSet.contains(trmopentextObj.Primary_Account__r.RecordTypeId)){
                showCalendar=false;
        }
        if(blnExternalUser==true  ){
            Contact[] conRecord=[Select Id,AccountId,Account.RecordTypeId, User_Name__c from Contact where  User_Name__c=: userInfo.getUserName() and Account.RecordTypeId IN:accRecordTypesSet];
            if(conRecord.size()>0){
                showCalendar=false;
            }
            
        }
        //Code end by Sunil
        
        
        
        
        
        System.debug(blnExternalUser+'*****blnExternalUser');
        Team_Room__c TeamRoomObj = [Select OwnerId from Team_Room__c where id =:recordId];
        Id TeamRoomOwnerId =TeamRoomObj.OwnerId ;

        if ((objProfile.Name=='System Administrator') || (objProfile.Name=='GF FAE/FTS') || 
            (objProfile.Name=='GF Global Admin') || (objProfile.Name=='GF System Admin') || 
            (objProfile.Name=='GF Training Admin') || (objProfile.Name=='GF Product Marketing')||
            (TeamRoomOwnerId==UserInfo.getUserId())){
            blnaddremoveDoc=true;       
        }else{
            blnaddremoveDoc=false;    
        }
        
        
        
        
        //construct individual queries for all the related sobjects 
        String teamRoomAccountQuery= '('+constructQuery('Team_Room_Account__c','Team_Room_Accounts__r','','',new Set<String>{'Account__c','Association_Type__c'})+')';
        String teamRoomMemberQuery='('+constructQuery('Team_Room_Member__c','Team_Room_Members__r','VFTeamRoomDetail_Member_Fields','',new Set<String>{'User__c','Account__c','Public_Group_Name__c'})+')';
        String teamRoomMeetingQuery='('+constructQuery('Team_Room_Meeting__c','Team_Room_Meetings__r','VFTeamRoomDetail_Meeting_Fields','',null)+')';
        String teamRoomTaskQuery='('+constructQuery('GF_Task__c','GF_Tasks__r','VFTeamRoomDetail_Task_Fields','',null)+')';
        
        totalQuery='Select Id,OwnerId,Name,'+teamRoomAccountQuery+','+teamRoomMemberQuery+','+teamRoomMeetingQuery+','+teamRoomTaskQuery+
                          ' from Team_Room__c where Id =:recordId';

        queryDetails();
        //Updated by JOYDEV on 2nd Oct 3013:
        queryProposals();
        
        populateAllFieldMappings();
        populateAccountMap();
        populateMemberMap();
        populateActivityMap();
        checkUserPermissions();
        calcDisplayPgNum('Account',1);
        calcDisplayPgNum('Member',1);
        calcDisplayPgNum('OpenActivity',1);
        calcDisplayPgNum('ActivityHistory',1);

        showNotesAndAttachments();        
        
    }
    
    /**
        This method is used to redirect page for new team room record Type Pre FV2
        
        @method name: redirectToStandardPage
        @parameter:   none
        @return :     none
    **/    
    public PageReference redirectToStandardPage(){

        String recordId = ApexPages.currentPage().getParameters().get('id');
        Team_Room__c trtypeObj = [Select recordtype.name from Team_Room__c where id =:recordId]; 
        
        if(trtypeObj.recordtype.name == 'Pre FV2 Teamroom'){
            PageReference p = new PageReference('/'+recordId);
            p.getParameters().put('nooverride','1');
            return p;
        }
        return null;
    }
    
    /**
        This method is used to show notes and Attachments for the record Type 
        
        @method name: showNotesAndAttachments
        @parameter:   none
        @return :     boolean
    **/    
    public Boolean showNotesAndAttachments(){

        String recordId = ApexPages.currentPage().getParameters().get('id');
        Team_Room__c trtypeObj = [Select recordtype.name from Team_Room__c where id =:recordId]; 
        
        if(trtypeObj.recordtype.name == 'Internal Private' || trtypeObj.recordtype.name == 'Internal Public'){
           showNotesAndAttachments = true;
        }
        return showNotesAndAttachments;
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
        This method is used to check whether the current user has the permission to add or delete related members
        
        @method name: checkUserPermissions
        @parameter:   none
        @return :     none
    **/
    private void checkUserPermissions(){
        
        //check if the current user is the owner of the team room 
        if(objTeamRoom.OwnerId==UserInfo.getUserId()){
            isAddDelMember=true;
            isOwnerorAdmin =true;
        }
        else{
            //else check if the current user is a system administrator
            for(Profile p:[Select Id from Profile where Name='System Administrator' OR Name='GF Global Admin' OR Name='GF System Admin' OR Name='GF Training Admin' OR Name='GF Regional Admin']){
                if(UserInfo.getProfileId()==p.Id){
                    isAddDelMember=true;
                    isOwnerorAdmin =true;
                    break;
                }
            }
        }
        //else check if the current user is a moderator
        if(!isAddDelMember){
            for(Team_Room_Member__c trm:objTeamRoom.Team_Room_Members__r){
                if(trm.User__c==UserInfo.getUserId() && trm.Team_Room_Role_Formula__c=='Moderator'){
                    isAddDelMember=true;
                }
            }
        }
        
        for(Team_Room_Member__c trm:objTeamRoom.Team_Room_Members__r){
                if(trm.User__c==UserInfo.getUserId()){
                    isMember=true;
                }
        }
    }
    
    
    /**
        This method is used to populate the account map containing the page numbers and corresponding related records
        
        @method name: populateAccountMap
        @parameter:   none
        @return :     none
    **/   
    public void populateAccountMap(){
    
        Set<String> setRelatedAccountIds=new Set<String>();
        System.Debug('Id:'+objTeamRoom.Id);
        mapPageToAccRecords.clear();
        
        try{
            //add the parent account ids to a set
            for(Team_Room_Account__c tra:objTeamRoom.Team_Room_Accounts__r){
                setRelatedAccountIds.add(tra.Account__c);
                mapAccIdToTeamRoomId.put(tra.Account__c,tra.Id);
                mapAccountIdToType.put(tra.Account__c,tra.Association_Type__c);
            }
            //construct query to retrieve parent account details
            String query=constructQuery('Account','','VFTeamRoomDetail_Account_Fields','Id in:setRelatedAccountIds',null);
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
        System.Debug('*******mapPageToAccRecords******'+mapPageToAccRecords);
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    
    /**
        This method is used to populate the member map containing the page numbers and corresponding related records
        
        @method name: populateMemberMap
        @parameter:   none
        @return :     none
    **/   
    public void populateMemberMap(){
        List<Team_Room_Member__c> lstCurrent=new List<Team_Room_Member__c>();//list to hold the accounts to be added to the current page
        mapPageToMemberRecords.clear();
        try{
            List<Team_Room_Member__c> lstMem = objTeamRoom.Team_Room_Members__r;
            //loop in the related Team Room Members
            for(Integer i=1;i<=lstMem .size();i++){ 
                lstCurrent.add(lstMem [i-1]);     
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration   
                if(math.mod(i,memberPageSize)==0 || i==lstMem.size()){
                      Decimal t=i;                      
                      Decimal pageNumber=t/memberPageSize;
                      pageNumber=pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToMemberRecords.put(pageNumber,lstCurrent);
                      lstCurrent=new List<Team_Room_Member__c>();
                }
            }
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    /**
        This method is used to populate the open activity and activity history map containing the page numbers and corresponding related records
        
        @method name: populateActivityMap
        @parameter:   none
        @return :     none
    **/   
    public void populateActivityMap(){
    
        List<ActivityWrapper> lstOpenActWraps=new List<ActivityWrapper>();//list to hold open GF Tasks and Team Room Meetings
        List<ActivityWrapper> lstActHistWraps=new List<ActivityWrapper>();//list to hold closed GF Tasks and Team Room Meetings
        mapPageToActHistRecords.clear();
        mapPageToOpenActRecords.clear();
        
        
        try{
            //iterate the team room meetings and add them to open acitvity list or closed activity list correspondingly
            for(Team_Room_Meeting__c tr:objTeamRoom.Team_Room_Meetings__r){
                ActivityWrapper aw=new ActivityWrapper(tr,null);
                System.Debug('************'+tr.End_DateTime__c+'---------'+System.Now()+'^^^^^^^^^');
                if(tr.Status__c!='Closed' && (tr.End_DateTime__c>System.Now() || tr.End_DateTime__c==null)){
                     System.Debug('************'+tr.Id);
                     lstOpenActWraps.add(aw);
                }
                else{
                    System.Debug('@@@@@@@@@@@'+tr.Id);
                    lstActHistWraps.add(aw);
                }
               
            }
            
            //iterate the GF Tasks and add them to open acitvity list or closed activity list correspondingly
            for(GF_Task__c tr:objTeamRoom.GF_Tasks__r){
                ActivityWrapper aw=new ActivityWrapper(null,tr);
                if(tr.Status__c!='Completed' && (tr.Due_Date__c>=System.Today() || tr.Due_Date__c==null)){
                    lstOpenActWraps.add(aw);
                }
                else{
                    lstActHistWraps.add(aw);
                }               
            }
            
            //prepare map of page number to list of open activity records 
            List<ActivityWrapper> lstCurrent=new List<ActivityWrapper>();
            for(Integer i=1;i<=lstOpenActWraps.size();i++){ 
                lstCurrent.add(lstOpenActWraps[i-1]);
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration           
                if(math.mod(i,openActPageSize)==0 || i==lstOpenActWraps.size()){
                      Decimal t=i;                       
                      Decimal pageNumber=t/openActPageSize;
                      pageNumber=pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToOpenActRecords.put(pageNumber,lstCurrent);
                      lstCurrent=new List<ActivityWrapper>();
                }
            }
            
            //prepare map of page number to list of closed activity records 
            lstCurrent=new List<ActivityWrapper>();
            for(Integer i=1;i<=lstActHistWraps.size();i++){ 
                lstCurrent.add(lstActHistWraps[i-1]); 
                //if the counter has reached the map size or the total list size, add them to map and move to next page iteration         
                if(math.mod(i,actHistPageSize)==0 || i==lstActHistWraps.size()){
                      Decimal t=i;                    
                      Decimal pageNumber=t/actHistPageSize;
                      pageNumber=pageNumber.round(System.RoundingMode.CEILING);
                      mapPageToActHistRecords.put(pageNumber,lstCurrent);
                      lstCurrent=new List<ActivityWrapper>();
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
        This method is used to get the total number of Member Section pages through the map size
        
        @method name: getMemberMapSize
        @parameter:   none
        @return :     none
    **/
    public Integer getMemberMapSize(){
        return mapPageToMemberRecords.size();
    }
    
    /**
        This method is used to get the total number of Open Activity pages through the map size
        
        @method name: getOpenActivityMapSize
        @parameter:   none
        @return :     none
    **/
    public Integer getOpenActivityMapSize(){
        return mapPageToOpenActRecords.size();
    }
    
    /**
        This method is used to get the total number of Activity History pages through the map size
        
        @method name: getClosedActivityMapSize
        @parameter:   none
        @return :     none
    **/
    public Integer getClosedActivityMapSize(){
        return mapPageToActHistRecords.size();
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
            Team_Room_Member__c delTeamRoomMember=[Select Id,User__r.AccountId from Team_Room_Member__c Where Id=:memberId];
            if((blnExternalUser==true && Userobj.AccountId==delTeamRoomMember.User__r.AccountId) || blnExternalUser==false){
                Team_Room_Member__c trm=new Team_Room_Member__c(Id=memberId);
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
        This method is used to delete a member and reconstruct the pages through the coressponding map
        
        @method name: deleteMember
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
            for(Team_Room_Member__c trm:objTeamRoom.Team_Room_Members__r){
                if(setUserIds.contains(trm.User__c)){
                    accNotDelMsg = 'This team room account for '+accName+' cannot be deleted as a team member is a part of the account team';
                    break;
                }
            }
            //if any team room member is not a part of the account team of the account passed,the team room account can be deleted
            if(accNotDelMsg==null){
                String traId=mapAccIdToTeamRoomId.get(accId);
                system.debug('traId'+traId);
                Team_Room_Account__c tra=new Team_Room_Account__c(Id=traId);
                system.debug('@@@@@@tra'+tra);
                delete tra;
                queryDetails();
                populateAccountMap();
            }
            
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    /**
        This method is used to delete an activity and reconstruct the pages through the coressponding map
        
        @method name: deleteActivity
        @parameter:   none
        @return :     none
    **/
    public void deleteActivity(){
        try{
            //get the passed activity id to be deleted
            String meetingId=ApexPages.currentPage().getParameters().get('MeetingTonavigate');
            String taskId=ApexPages.currentPage().getParameters().get('TaskTonavigate');
            if(meetingId!=null){
                Team_Room_Meeting__c trm=new Team_Room_Meeting__c(Id=meetingId);
                delete trm;
            }
            else{
                Gf_Task__c gft=new Gf_Task__c(Id=taskId);
                delete gft;
            }
            queryDetails();
            populateActivityMap();
        }catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    /**
        This method is used to navigate to the edit activity page
        
        @method name: goToEditActivity
        @parameter:   none
        @return :     pagereference
    **/   
    public pagereference goToEditActivity(){
        String activityId=ApexPages.currentPage().getParameters().get('objectToEdit');

        if(Site.getCurrentSiteUrl()!=null){
            if(Site.getCurrentSiteUrl().contains(Label.Community_Name)){
                return new pagereference('/'+activityId+'/e?retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);
            }else{
                return new pagereference('/'+activityId+'/e?retURL=/'+objTeamRoom.Id+'&saveURL='+objTeamRoom.Id);
            }           
        } else {
            return new pagereference('/'+activityId+'/e?retURL=/'+objTeamRoom.Id+'&saveURL='+objTeamRoom.Id);
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
        String referenceFieldId; 
        Schema.DescribeSObjectResult D = Team_Room_Account__c.sObjectType.getDescribe();     
        String objPrefix=D.getKeyPrefix();  
               
        
        //pick the Team Room look up field id from the custom setting
        if(mapObjFieldNameToFieldId.containsKey('Team_Room_Account__c-Team_Room__c')){      
            referenceFieldId=mapObjFieldNameToFieldId.get('Team_Room_Account__c-Team_Room__c');
        }
        if(referenceFieldId!=null){   
            if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){         
                return new pagereference('/'+objPrefix+'/e?CF'+referenceFieldId+'='+objTeamRoom.Name+'&CF'+referenceFieldId+'_lkid='+objTeamRoom.Id+'&'+'retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id);
            }else{
                return new pagereference('/'+objPrefix+'/e?CF'+referenceFieldId+'='+objTeamRoom.Name+'&CF'+referenceFieldId+'_lkid='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
            }
        } 
        else{            
             if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){         
                return new pagereference('/'+objPrefix+'/e?retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);
            }else{
                return new pagereference('/'+objPrefix+'/e?retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id); }
        }        
        
    }
    
    
    /**
        This method is used to navigate to the new meeting visualforce page
        
        @method name: goToNewMeeting
        @parameter:   none
        @return :     pagereference
    **/   
    public pagereference goToNewMeeting(){         
        if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){
            return new pagereference('/apex/VFTeamRoomMeeting?trid='+objTeamRoom.Id+'&'+'retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);
        }else{
            return new pagereference('/apex/VFTeamRoomMeeting?trid='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
        }
        
    }
    
      
    /**
        This method is used to navigate to the new GF Task page
        
        @method name: goToNewtask
        @parameter:   none
        @return :     pagereference
    **/    
    public pagereference goToNewtask(){ 
        String referenceFieldId;  
        Schema.DescribeSObjectResult D = GF_task__c.sObjectType.getDescribe();     
        String objPrefix=D.getKeyPrefix();  
        
         //pick the Team Room look up field id from the custom setting
        if(mapObjFieldNameToFieldId.containsKey('GF_Task__c-Team_Room__c')){      
            referenceFieldId=mapObjFieldNameToFieldId.get('GF_Task__c-Team_Room__c');
        }        
       
        if(referenceFieldId!=null){ 
            if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){           
                return new pagereference('/'+objPrefix+'/e?CF'+referenceFieldId+'='+objTeamRoom.Name+'&CF'+referenceFieldId+'_lkid='+objTeamRoom.Id+'&'+'retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);
            }else{
                 return new pagereference('/'+objPrefix+'/e?CF'+referenceFieldId+'='+objTeamRoom.Name+'&CF'+referenceFieldId+'_lkid='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);          
            }
        } 
        else{
            if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){           
                return new pagereference('/'+objPrefix+'/e?retURL=/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL=/'+Label.Community_Name+'/'+objTeamRoom.Id);

            }else{
                return new pagereference('/'+objPrefix+'/e?retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
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
         if(currentURL.toLowerCase().contains(Label.Community_Name.toLowerCase())){
            //return new pagereference('/apex/vfmanagemembership?id='+objTeamRoom.Id+'&'+'retURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id);
            return new pagereference('/apex/VFTeamRoomManageMembership?id='+objTeamRoom.Id+'&'+'retURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id+'&saveURL='+'/'+Label.Community_Name+'/'+objTeamRoom.Id);
         }else{
            //return new pagereference('/apex/vfmanagemembership?id='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
            return new pagereference('/apex/VFTeamRoomManageMembership?id='+objTeamRoom.Id+'&'+'retURL=/'+objTeamRoom.Id+'&saveURL=/'+objTeamRoom.Id);
         }
    }
    
    /**
        This method is used to populate the field ids from custom settings to help in prepopulation
        
        @method name: populateAllFieldMappings
        @parameter:   none
        @return :     none
    **/ 
    private void populateAllFieldMappings(){
        if(!Salesforce_Field_Ids__c.getAll().isEmpty()){
            for(Salesforce_Field_Ids__c objSfId:Salesforce_Field_Ids__c.getAll().values()){
                mapObjFieldNameToFieldId.put(objSfId.SObject_Name__c+'-'+objSfId.Field_Name__c,objSfId.Id__c);
            }
        }
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
                       if(sObjectName=='GF_Task__c' || sObjectName=='team_Room_Meeting__c'){
                           mapFieldNameToLabel.put(fsm.getFieldPath(),fsm.getLabel());    
                           if(mapFieldNameToSobjectName.containsKey(fsm.getFieldPath())){
                               mapFieldNameToSobjectName.put(fsm.getFieldPath(),'Both');
                           }
                           else{
                               mapFieldNameToSobjectName.put(fsm.getFieldPath(),sObjectName);
                           }
                       }
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
        else if(objectTonavigate=='OpenActivity'){
            currentOpenActPage=currentOpenActPage+1;
            calcDisplayPgNum(objectTonavigate,currentOpenActPage);
        }
        else{
            currentActHistPage =currentActHistPage +1;
            calcDisplayPgNum(objectTonavigate,currentActHistPage);
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
        else if(objectTonavigate=='OpenActivity'){
            currentOpenActPage=currentOpenActPage-1;
            calcDisplayPgNum(objectTonavigate,currentOpenActPage);
        }
        else{
            currentActHistPage =currentActHistPage -1;
            calcDisplayPgNum(objectTonavigate,currentActHistPage);
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
        if(objectTonavigate=='Account'){
            currentActPage =1;
            calcDisplayPgNum(objectTonavigate,currentActPage);
        }else if(objectTonavigate=='Member'){
            currentMemberPage =1;
            calcDisplayPgNum(objectTonavigate,currentMemberPage);
        }
        else if(objectTonavigate=='OpenActivity'){
            currentOpenActPage=1;
            calcDisplayPgNum(objectTonavigate,currentOpenActPage);
        }
        else{
            currentActHistPage =1;
            calcDisplayPgNum(objectTonavigate,currentActHistPage);
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
        if(objectTonavigate=='Account'){
            currentActPage =mapPageToAccRecords.size();
            calcDisplayPgNum(objectTonavigate,currentActPage);
        }else if(objectTonavigate=='Member'){
            currentMemberPage =mapPageToMemberRecords.size();
            calcDisplayPgNum(objectTonavigate,currentMemberPage );
        }
        else if(objectTonavigate=='OpenActivity'){
            currentOpenActPage=mapPageToOpenActRecords.size();
            calcDisplayPgNum(objectTonavigate,currentOpenActPage);
        }
        else{
            currentActHistPage =mapPageToActHistRecords.size();
            calcDisplayPgNum(objectTonavigate,currentActHistPage);
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

         if(sectionName=='Account'){
             lastPgNum=mapPageToAccRecords.size();
             currentActPage=p;
         }
         else if(sectionName=='Member'){
             lastPgNum=mapPageToMemberRecords.size();
             currentMemberPage =p;
         }
         else if(sectionName=='OpenActivity'){
             lastPgNum=mapPageToOpenActRecords.size();
             currentOpenActPage =p;
         }
         else{
             lastPgNum=mapPageToActHistRecords.size();
             currentActHistPage =p;
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
        This method is used to add the document
        
        @method name: addDoc
        @parameter:   none
        @return :     none
    **/
    
    public pagereference addDoc(){
        return (new pagereference ('/apex/VF_Team_Room_Add_Document?id='+ApexPages.currentPage().getParameters().get('id')));
    }
    
    /**
        This method is used to remove the document
        
        @method name: removeDoc
        @parameter:   none
        @return :     none
    **/
    
    public pagereference removeDoc(){
         return (new pagereference ('/apex/VF_Team_Room_Remove_Document?id='+ApexPages.currentPage().getParameters().get('id')));
    }
    
    
    /* Wrapper class to merge the GF Tasks and Team Room Meeting to show the Open Activities and the Activity History*/
    public class ActivityWrapper
    {
        public GF_Task__c tskRec {get; set;}
        public Team_Room_Meeting__c meetingRec{get; set;}
        
        public ActivityWrapper(Team_Room_Meeting__c meeting , GF_Task__c tskRec)
        {
            this.meetingRec= meeting ;
            this.tskRec= tskRec;
        }
    }
    
    /**
        This method is used to refresh the pageblock when OpenTextId is updated in the team room
        
        @method name: autorefresh
        @parameter:   none
        @return :     none
    **/
   
   public PageReference autorefresh() 
    {
        Decimal openTextId;
        Team_Room__c trmopentextObj = [Select OpenText_Id__c from Team_Room__c where id =:recordID]; 
        openTextId = trmopentextObj.OpenText_Id__c;
        //documentURL = System.Label.TR_Documents_URL + openTextId;
        documentURL = System.Label.TR_Documents_URL + openTextId+'&username='+portalLoginUser;
        if(openTextId == NULL )
        {
            showOpenTextSession = False;
            showWaitSession = True;
            return null;
        }
        else if (openTextId  != NULL)
        {
           
           showOpenTextSession = True;
           showWaitSession = False;
           count = 1;
           return null;
        }
       return null;
        
    
    }
     /**
        Created by JOYDEV on 2nd Oct 3013:
        
        This method is used to fetch the related Proposals of the eam room
        
        @method name: queryProposals
        @parameter:   none
        @return :     none
    **/
    private void queryProposals(){
        //LstProposals = Database.query(constructQuery('Apttus_Proposal__Proposal__c','Proposals__r','Related_List_Column_for_Team_Room','',null));
         
        //Query strings generated from field sets (For Related Proposals)
        String szProposalQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.Related_List_Column_for_Team_Room.getFields()) {
            szProposalQuery += f.getFieldPath() + ', ';
        }
        
        szProposalQuery += 'Id FROM Apttus_Proposal__Proposal__c Where Team_Room__c = \'' + ApexPages.CurrentPage().getparameters().get('Id') + '\'';
        
        LstProposals = Database.query(szProposalQuery);
    }
    
    /**
        Created by JOYDEV on 2nd Oct 3013:
        This method is used to redirect to proposal edit page with teamroom prepopulated and record Type 'Proposal From Teamroom'
        
        @method name: redirectToStandardPage
        @parameter:   none
        @return :     none
    **/    
    public PageReference createProposalRedirection(){
        /*
        /a3D/e?
        CF00NO000000109fR=TR+-+POC+-+001
        &
        CF00NO000000109fR_lkid=a0JO0000002FUZO
        &
        retURL=%2Fa0JO0000002FUZO
        &
        RecordType=012O00000008mld
        &
        ent=01I90000001IH1t
        */
        
        /*
        PageReference pageRef = new PageReference('/a3D/e?'
                                                 + 'CF00NO000000109Me=' + objTeamRoom.Name + '&'
                                                 + 'CF00NO000000109Me_lkid=' + objTeamRoom.Id + '&'
                                                 + 'RecordType=012O00000008mld' + '&'
                                                 + 'ent=01I90000001IH1t');// + '&'
                                                 //+ 'retURL=/apex/VFTeamRoomDetail?id=' + objTeamRoom.Id);
        */
        
        //Get the custom settings for the URL parameters
       // New_Proposal_from_Teamroom_URL_Params__c urlParams
         //           = New_Proposal_from_Teamroom_URL_Params__c.getInstance('TR-Proposal-URL');
        
       // PageReference pageRef = new PageReference('/' + urlParams.ObjectPrefix__c + '/e');
        
    //    pageRef.getParameters().put(urlParams.NameId__c, objTeamRoom.Name);
    /*    pageRef.getParameters().put(urlParams.LookupId__c, objTeamRoom.Id);
        pageRef.getParameters().put('ent', urlParams.Ent_Id__c);
        pageRef.getParameters().put('RecordType', urlParams.RecordTypeId__c);
        pageRef.getParameters().put('retURL', ApexPages.currentPage().GetURL());
       */ 
        /*
        PageReference pageRef = new PageReference('/a3D/e');
        //PageReference pageRef = new PageReference('https://cs5.salesforce.com/a3D/e');
        
        pageRef.getParameters().put('CF00NO0000000xS6y', objTeamRoom.Name);
        pageRef.getParameters().put('CF00NO0000000xS6y_lkid', objTeamRoom.Id);
        pageRef.getParameters().put('ent', '01I90000001IH1t');
        pageRef.getParameters().put('RecordType', '012O00000008mld');
        pageRef.getParameters().put('retURL', ApexPages.currentPage().GetURL());
        */
     //Get the custom settings for the URL parameters
        New_Proposal_from_Teamroom_URL_Params__c urlParams
                    = New_Proposal_from_Teamroom_URL_Params__c.getInstance('TR-Proposal-URL');
        User CurrentUser = [SELECT      id,
                                        Parent_Account_Id__c,
                                        Parent_Account_Name__c
                            FROM        USER
                            WHERE       ID = :UserInfo.getUserId()
                            LIMIT       1];
        
        
        PageReference pageRef = new PageReference('/' + urlParams.ObjectPrefix__c + '/e');
        
        pageRef.getParameters().put(urlParams.NameId__c, objTeamRoom.Name);
        pageRef.getParameters().put(urlParams.LookupId__c, objTeamRoom.Id);
        pageRef.getParameters().put('ent', urlParams.Ent_Id__c);
        pageRef.getParameters().put('RecordType', urlParams.RecordTypeId__c);
        pageRef.getParameters().put('retURL', ApexPages.currentPage().GetURL());
        //PS: added 7th April,2014: 
        if(CurrentUser != NULL){
            pageRef.getParameters().put('CF00N90000006EPVs', CurrentUser.Parent_Account_Name__c);
            pageRef.getParameters().put('CF00N90000006EPVs_lkid', CurrentUser.Parent_Account_Id__c);
        }        
        return pageRef;
    }
}