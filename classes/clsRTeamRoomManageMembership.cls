/*
Type Name: clsRTeamRoomManageMembership 
Author: GlobalFoundries (Dinesh Suggala)
Created Date: 14-June-2017
Reason: This class is used for adding Team Room Members to Team Room. 
Change History:
Author:Dinesh Suggala
Modified Date:28/2/2018
Reason: Removed the code while adding a member no need to select the checkbox now and if HCM Employee record is not present 
        showing error message.
……..
……..
*/
public with sharing class clsRTeamRoomManageMembership {


  public Boolean isAddDelMember { get ; set ;} // boolean to  check whether the current user has the permission to add or delete related members
  private String sTeamRoomId;
  public List<R_Team_Room_Member__c> IndividualMemberList{get;set;}
  public List<User> portaluserlist{get;set;}
  public List<UserWrapper> listwrapper{get;set;}
  public List<R_Team_Room_Member__c> CustIndividualMemberList{get;set;}
  public List<R_Team_Room_Member__c> rtlist;
  public String selectedAccId{get;set;}
  public Map<Id,R_Team_Room_Member__c > PortalUserMap;
  public Map<Id,R_Team_Room_Member__c> PortalAccMap;
  public boolean Isportal{get;set;}
  public boolean Hideportalsection{get;set;}
  public boolean blnDuplicateUser;
  public Id accId;
  public R_Team_Room_Member__c rteam{get;set;}
  
  public clsRTeamRoomManageMembership (){
   isAddDelMember =false;
   Isportal=false;
   Hideportalsection=false;
   sTeamRoomId=Apexpages.currentpage().getparameters().get('id');
        IndividualMemberList=new List<R_Team_Room_Member__c>();
        rtlist=new List<R_Team_Room_Member__c>();
        CustIndividualMemberList=new List<R_Team_Room_Member__c>();
        portaluserlist=new List<User>();
        listwrapper=new List<UserWrapper>();
        
        set<Id> uIds=new set<Id>();
        
        // Check if the logged in user is portal user
         User u = [SELECT Id,UserType,ContactId FROM User WHERE Id = :UserInfo.getUserId()];
          if (u.UserType == 'Standard') {
               Isportal= true;
           }
          else{
               Isportal=false;
               
           } 
           
           if(!Isportal){
             accId = [SELECT AccountId,Id from Contact where Id=:u.ContactId  ].AccountId;
            }   
           set<Id> rtset=new set<Id>();
        
           for(Restricted_Team_Room__c rteamroom:[Select Id,Name from Restricted_Team_Room__c where RecordType.Name='GLOBALFOUNDRIES Internal']){rtset.add(rteamroom.id);}  
           
           if(rtset.contains(sTeamRoomId)){Hideportalsection=true;}                        
           
           dataFetch();
           rteam=new R_Team_Room_Member__c();
           rteam.Restricted_Team_Room__c=sTeamRoomId;
           
  }
  
           //fetching all the Team Room members for the Team room   
            private void dataFetch(){
            IndividualMemberList=new List<R_Team_Room_Member__c>();
            CustIndividualMemberList=new List<R_Team_Room_Member__c>();
            rtlist=new List<R_Team_Room_Member__c>();
            PortalUserMap=new Map<Id,R_Team_Room_Member__c >();
            PortalAccMap=new Map<Id,R_Team_Room_Member__c>();
      
            if(!Isportal){
          
            rtlist=[Select User__c,User__r.UserType,User__r.AccountId,User__r.Name, Restricted_Team_Room__c, Team_Room_Role__c, User_Selected__c,Account__r.Name,Account__c
                                                        From R_Team_Room_Member__c 
                                                        Where Restricted_Team_Room__c=: sTeamRoomId and Account__c=:accId Order By User__r.Name ASC];
            }
            else{
          
            rtlist=[Select User__c,User__r.UserType,User__r.AccountId,User__r.Name, Restricted_Team_Room__c, Team_Room_Role__c, User_Selected__c,Account__r.Name,Account__c
                                                        From R_Team_Room_Member__c 
                                                        Where Restricted_Team_Room__c=: sTeamRoomId  Order By User__r.Name ASC];
            }                                          
                                                     
            for (R_Team_Room_Member__c objTeamRoomMember: rtlist){
                
                if (objTeamRoomMember.Team_Room_Role__c =='Owner') {
                    objTeamRoomMember.Team_Room_Role__c ='Owner';   
                } else if (objTeamRoomMember.Team_Room_Role__c =='Moderator') {
                    objTeamRoomMember.Team_Room_Role__c ='Moderator';   
                } else {
                    objTeamRoomMember.Team_Room_Role__c='Member';
                }
                objTeamRoomMember.User_Selected__c=false;
                if(objTeamRoomMember.User__r.UserType=='Standard'){
                IndividualMemberList.add(objTeamRoomMember);       
                }  
                else{
                 PortalUserMap.put(objTeamRoomMember.User__c,objTeamRoomMember);          
                 CustIndividualMemberList.add(objTeamRoomMember);
            
                }                               
              }
            }
            
            
           
            //On clicking selected account display corresponding portal users 
            public void  fetchportalusers(){    
            listwrapper=new List<UserWrapper>();     
            set<Id> contactids=new set<Id>();
            if(selectedAccId!=null){
              List<Contact> conlist=[Select Id,Is_Portal_User_Active__c,ITAR_Certified__c from Contact where AccountId=:selectedAccId];
               
                for(Contact con:conlist){
                 if(con.Is_Portal_User_Active__c==true && con.ITAR_Certified__c==true){
                 contactids.add(con.Id);
                 }
                }
              }  
            portaluserlist=[Select Id,Name,ContactId from User where ContactId=:contactids];
            for(User u: portaluserlist){
             if(!PortalUserMap.containsKey(u.Id)){
              listwrapper.add(new Userwrapper(u));
             }
            }
            if(listwrapper.size()==0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no portal users for this account to select.')); 
            }                       
            }
            
  
            //populating the member dropdown list   
            public List<SelectOption> MemberRoleList
            {
                get {
                    MemberRoleList=new List<Selectoption>();
                    MemberRoleList.add(new Selectoption('','--None--'));
                    MemberRoleList.add(new Selectoption('Moderator','Moderator'));
                    MemberRoleList.add(new Selectoption('Member','Member'));   
                    return MemberRoleList;
                }
                
                Set;
             }
             
            public List<SelectOption> getAccountNames() {
                  List<SelectOption> accOptions= new List<SelectOption>();               
                  accOptions.add( new SelectOption('','--Select--'));
                  
                  for( R_Team_Room_Account__c rt : [select Id,Restricted_Team_Room__c,Account__r.Id,Account__r.Name,Restricted_Team_Room__r.RecordType.Name from R_Team_Room_Account__c where Restricted_Team_Room__c=:sTeamRoomId] ) {                
                               accOptions.add( new SelectOption(rt.Account__r.Id,rt.Account__r.Name)); 
                          
                  }
                  
                 return accOptions;
           } 
            


             //add row for individual user      
            public PageReference addUserRow() {
                R_Team_Room_Member__c objTRM=new R_Team_Room_Member__c();
                objTRM.Restricted_Team_Room__c=sTeamRoomId;
                IndividualMemberList.add(objTRM);
                return null;
              } 
            
           //Cancel button   
            public PageReference Cancel(){
               PageReference TRPage = new PageReference('/'+ sTeamRoomId);
               return TRPage;  
              }
              
            //Return button   
            public PageReference back(){
               PageReference TRPage = new PageReference('/'+ sTeamRoomId);
               return TRPage;  
              }  
            
            //save button
            public pagereference save(){
     
                if(IndividualMemberList.size()>0){
                try{
                   PageReference TRPage = new PageReference('/'+ sTeamRoomId);
                   blnDuplicateUser=false;
                   Map<Id,R_Team_Room_Member__c> selectedUserIdMap=new Map<Id,R_Team_Room_Member__c>();
                   List<R_Team_Room_Member__c> ActIndividualUserList=new List<R_Team_Room_Member__c>();
                   List<R_Team_Room_Member__c> upsertableUserList=new List<R_Team_Room_Member__c>();
                   
                   
                   for (R_Team_Room_Member__c objTeamRoomMember: IndividualMemberList){
                    if (selectedUserIdMap.containsKey(objTeamRoomMember.User__c)){
                        blnDuplicateUser=true;  
                        break;
                    }else{     
                        selectedUserIdMap.put(objTeamRoomMember.User__c,objTeamRoomMember); 
                        
                    }       
                  }                                
                  
                  //Displaying error message when duplicate user is selected           
                  if (blnDuplicateUser){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate User added. Please remove the duplicate user')); }
                  
                  if (blnDuplicateUser==false) {
                   
                     
                    Map<Id,R_Team_Room_Member__c> upsertableUserMap=new Map<Id,R_Team_Room_Member__c>();
                    ActIndividualUserList=selectedUserIdMap.values();
                    for (R_Team_Room_Member__c objUpsertTeamMember: ActIndividualUserList){
                        if (objUpsertTeamMember.User__c!=null){
                            if (!upsertableUserMap.containsKey(objUpsertTeamMember.User__c) ){                  //Updated 18/10/2017                                                  
                                upsertableUserMap.put(objUpsertTeamMember.User__c,objUpsertTeamMember); 
                                
                            }
                          
                        }
                    }
                    if (upsertableUserMap.size()>0){  
                    R_Team_Room_Member__c objTeamRoomMemberTemp=new R_Team_Room_Member__c();
                    List<User> userList1=[SELECT Id,AccountId,UserType,HCM_Record_ID__c FROM User WHERE Id IN:upsertableUserMap.keyset()];
                    set<String> HCMSetId=new set<String>();
                   // set<String> HCMnullset=new set<String>();
                    
                    for (User objUser:userList1){
                            if(objUser.HCM_Record_ID__c!=null){
                            HCMSetId.add(objUser.HCM_Record_ID__c);
                            }
                           /* else{
                            HCMnullset.add(objUser.Id);
                            }*/
                           
                            objTeamRoomMemberTemp=new R_Team_Room_Member__c();
                            objTeamRoomMemberTemp=upsertableUserMap.get(objUser.Id);
                            if (objTeamRoomMemberTemp.Team_Room_Role__c=='Moderator') {objTeamRoomMemberTemp.Team_Room_Role__c='Moderator';}
                            else {objTeamRoomMemberTemp.Team_Room_Role__c='Internal Member';}                      
                            upsertableUserMap.put(objUser.Id,objTeamRoomMemberTemp);                     
                           }
                           
                         /* if(HCMnullset.size()>0){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'HCM Employee record is not present'));  
                            return null;
                           }*/
                           
                    for(HCM_Employee__c hcmemp:[Select Id,User__r.Name,ITARCertified__c,ITAR_End_Date_Formula__c from HCM_Employee__c where Id=:HCMSetId]){
                           if(hcmemp.ITARCertified__c!=true){
                            system.debug('User:'+hcmemp.User__r.Name);
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'User:'+hcmemp.User__r.Name +' is not ITAR Certified'));  
                            return null;
                            } 
                           }
                           
                    }    
                    
                   upsertableUserList=upsertableUserMap.values();
                   upsert upsertableUserList;          
                    } 
               } 
                catch(Exception ex){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));  return null;}
                
               } 
                List<R_Team_Room_Member__c> insertteamlist=new List<R_Team_Room_Member__c>();
                
                if(listwrapper.size()>0){
                system.debug('Enter wrapper loop');
                for(Userwrapper u: listwrapper){
                 if(u.selectedportaluser==true){
                  R_Team_Room_Member__c insertobj=new R_Team_Room_Member__c();
                  insertobj.Restricted_Team_Room__c=sTeamRoomId;
                  if(!PortalUserMap.containsKey(u.User.Id)){
                  insertobj.User__c=u.User.Id;
                  }
                   if(u.memberadd=='Moderator'){
                   insertobj.Team_Room_Role__c='Moderator';
                   }
                   else{
                   insertobj.Team_Room_Role__c='External Member';
                   }
                  insertobj.Account__c=selectedAccId;  
                  insertteamlist.add(insertobj);
                  }
                  
                 }
                 if(insertteamlist.size()>0){insert insertteamlist;}
                }
                List<R_Team_Room_Member__c> updateteamlist=new List<R_Team_Room_Member__c>();
                if(CustIndividualMemberList.size()>0){
                for(R_Team_Room_Member__c  insertobj1:CustIndividualMemberList ){
                 if(insertobj1.User_Selected__c==true){
                   if(insertobj1.Team_Room_Role__c=='Moderator'){insertobj1.Team_Room_Role__c='Moderator';}
                   else{insertobj1.Team_Room_Role__c='External Member';}              
                   updateteamlist.add(insertobj1);
                }            
               }
               if(updateteamlist.size()>0){Update updateteamlist;}
              }
              dataFetch();
              selectedAccId=null;
              listwrapper.clear();
              return null;
            }
        
            //Delete Individual User Record
            public PageReference DeleteUser(){
                PageReference TRPage = new PageReference('/'+ sTeamRoomId);
                Boolean InternalMemberDel =false;
                Boolean PortalMemberDel =false;
      
                if(IndividualMemberList.size()>0){
                try {
                List<R_Team_Room_Member__c> delTeamRoomMemberList=new List<R_Team_Room_Member__c>();
                for(R_Team_Room_Member__c trmObj :IndividualMemberList){
                  if(trmObj.User_Selected__c==true){
                    delTeamRoomMemberList.add(trmObj);
                  }
                 } 
                  if(delTeamRoomMemberList.size()>0){
                    delete delTeamRoomMemberList;
                  }
                   else if(delTeamRoomMemberList.size()==0){
                    InternalMemberDel =true;
                  }
                 
                }
                 catch(Exception ex){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage())); }                 
                }
                
                if(CustIndividualMemberList.size()>0){
                 
                 try {
                 List<R_Team_Room_Member__c> delportalTeamRoomMemberList=new List<R_Team_Room_Member__c>();
                 for(R_Team_Room_Member__c trmObj1 :CustIndividualMemberList){
                  if(trmObj1.User_Selected__c==true){
                    delportalTeamRoomMemberList.add(trmObj1);
                  }
                }
                 if(delportalTeamRoomMemberList.size()>0){
                    delete delportalTeamRoomMemberList;
                 }
                 else if(delportalTeamRoomMemberList.size()==0){
                    PortalMemberDel =true;
                 } 
                }
                 Catch(Exception e){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));} 
                 }
                if(PortalMemberDel ==true && InternalMemberDel ==true){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one user to delete'));        
                     
                } 
                dataFetch();
                selectedAccId=null;
                listwrapper.clear();
                return null;
              }
            
            
            public Class UserWrapper{
            public boolean selectedportaluser{get;set;}
            public User user{get;set;}
            public String memberadd{get;set;}
            
            public UserWrapper(User u){
            this.User=u;
            this.selectedportaluser=false;
            }
            }
}