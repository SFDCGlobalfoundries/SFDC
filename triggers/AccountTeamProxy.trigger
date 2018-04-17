/*
    Author:
    Description:
    History:
        Nbustillos  02182013    - added logic to delete opportunity program team member to all accounts Opportunity Program.
                                  (NOTE: code for managing account team proxy is not bulk optimized.
                                  It was decided not to change the logic for the moment as it entails regression testing.)
        Nbustillos  02202013    - added logic to insert/update opportuniy program team member to all accounts Opportunity Program.
        Nbustillos  02282013    - Updated logic when updating Team Member to also update Opportunity Program/Device Access based on Account Opportunity Access.
        Asolito     04222013    - Added codes to fire Account to ERP sync when a new Account proxy records is created or updated
        ARoy        04222013    - Added codes to prevent the firing of ERP sync when the Account proxy is updated by AccountTeamUpdateBatch batch process.
        ASinghal    06182013    - Added Code to enable User to modify Fab Assignment from Account Proxy Record.
        ASinghal    06242013    - Added Code to update Fab Deleted on Account Proxy as per modification by User.
        Asinghal    06242013    - Added Code to check that GF Integration Profile logic runs only on Update.
        Nbustillos  07092013    - Added logic to populate new 'Account_Team_Proxy__c' on Opportunity Program Team Member record.
                                  Added logic to force update Oppty Program Team Member if Fab Assignment is updated.
        Yash Kumar  06242013    - Added Code to for Oppty team program issue.
        Asolito     09022013    - Added logic which will fire ERP based on certain roles.
        Nbustillos  10102013    - Updated logic on retrieving duplicate role/user error message. Fix for case 00002030.
        Asolito     12092013    - Code optimization
        Asolito     12112013    - added skip trigger check 
        Tlai        18032014    - Commented code for swapping CE and FAB Planner
                                - Added condition only when siebel account id is not null, then update siebel status
        Tlai        11042014    - Added validtion to create optm under opportunity program of the same account as ATP
                                - Removed Delete events
        Tlai        09062014    - Remove dependancy on Sieble
        Vijay       02102015    - updated the to support the Internal Device functionality. added method invocation onAfter Trigger event. The actual
                                  Internal Device Sharing with ATP members business logic has been implemented in ClsAccountTeamProxyTriggerHandler class.
<<<<<<< .mine
        Shuchi      03042015    - Added record type check on the ERP callout to bypass IBM Accounts                                   
        Vijay       05082015    - Skipped the Opportunity Program Team Member Create/Update functionality for Internal Account
        NJain       04262016    - Logic for ATP Changes related to FAE and AM team roles.
||||||| .r4978
        Shuchi      03042015    - Added record type check on the ERP callout to bypass IBM Accounts                                   
        Vijay       05082015    - Skipped the Opportunity Program Team Member Create/Update functionality for Internal Account
        NJain       04262016    - Logic for ATP Changes related to FAE and AM team roles.
=======
        Shuchi      03042015     - Added record type check on the ERP callout to bypass IBM Accounts                                   
        Vijay       05082015    - Skipped the Opportunity Program Team Member Create/Update functionality for Internal Account  
>>>>>>> .r5521
*/
trigger AccountTeamProxy on Account_Team_Proxy__c (after insert, after update,before insert, before update) {  
                                                                                                                    
    final string DEVICE_STATUS_ACTIVE = Environment_Variable__c.getinstance('DEVICE_STATUS_ACTIVE').value__c;
    final string ACC_TEAM_PRXY_TM_RL_CE = Environment_Variable__c.getinstance('ACT_TM_PRXY_TM_RL_CE').value__c;
    final string ACC_TEAM_PRXY_TM_RL_FP = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_FP').value__c;
    final string ACCT_TM_PRXY_TM_RL_AM = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_AM').value__c;
    final string ACCT_TM_PRXY_TM_RL_TS = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_TS').value__c;
    final string ACCT_TM_PRXY_TM_RL_AE = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_AE').value__c;
    final string ACCT_TM_PRXY_TM_RL_CSR = Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_CSR').value__c;
    final string GF_INTEGRATION_PROFILE_ID = Environment_Variable__c.getinstance('GF_INTEGRATION_PROFILE_ID').value__c;
    
    // added by TLai 18032014 for atp validation
    final string ACCT_TM_DUP_USER_ROLE_ERROR = Error_Codes__c.getinstance('ACCT_TM_DUP_USER_ROLE_ERROR').Message__c;
    final string ATP_INTEGRATION_SEQUENCE_ERROR = Error_Codes__c.getinstance('ATP_INTEGRATION_SEQUENCE_ERROR').Message__c;
    final string ATP_FLAG_FOR_DELETE_UPDATE_ERROR = Error_Codes__c.getinstance('ATP_FLAG_FOR_DELETE_UPDATE_ERROR').Message__c;
    final string ATP_FLAG_FOR_DELETE_CREATION_ERROR = Error_Codes__c.getinstance('ATP_FLAG_FOR_DELETE_CREATION_ERROR').Message__c;
    
    //TEAM MEMBER SYNC
    Map<String,String> AccessC = new Map<String,String>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'};
    Map<String,String> currMap = new Map<String,String>();
    Map<Id,User> mNewAtpUser = new Map<Id,User>();
    List<String> UpdatedFab = new List<String>();
    List<String> OldFab= new List<String>();
    //---END OF TEAM MEM SYNC

    //UNIQUE ROLE
    set<string> newAtpUniqRoleSet = new set<string>();
    //END OF UNIQUE ROLE
    
    //added by Vijay 05082015 
    public static final String GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE = 'GLOBALFOUNDRIES_Internal';
    
    //Asolito 12112013 - skip trigger check
    if(!IntegrationUserUtil.isSkipTrigger()){
    
        if(trigger.isbefore){                      
            if (Trigger.isInsert || Trigger.isUpdate){ 
                //Asolito 12042013
                //fix for to many soql queries check if current user is integration user get the siebel account IDs from account related to ATP records
                Boolean isIntegrationUser = false;
                IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
                if(setting != null && setting.Is_Integration_User__c){
                    isIntegrationUser = true;
                }
                
                Set<Id> tempAccountIdSet = new Set<id>();
                Set<id> newUserIdSet = new Set<id>();
                list <Account_Team_Proxy__c> atpList = new  list< Account_Team_Proxy__c>();
                
                for(Account_Team_Proxy__c atp: trigger.new){
                    if(Trigger.isUpdate){
                        //checking sieble sync id
                        if(userinfo.getProfileId() == GF_INTEGRATION_PROFILE_ID  && atp.Siebel_Sync_ID__c < Trigger.oldMap.get(atp.id).Siebel_Sync_ID__c){
                            atp.addError(ATP_INTEGRATION_SEQUENCE_ERROR);    
                            continue;
                        } 
                        //Checking Delete Flag uncheck
                        if(Trigger.oldMap.get(ATP.id).Flag_for_Delete__c && Trigger.oldMap.get(ATP.id).Flag_for_Delete__c !=ATP.Flag_for_Delete__c){
                            atp.addError(ATP_FLAG_FOR_DELETE_UPDATE_ERROR);
                            continue;
                        }
                    }
                
                    //Checking Delete Flag while creating Record
                    if (Trigger.IsInsert && atp.Flag_for_Delete__c){
                        atp.adderror(ATP_FLAG_FOR_DELETE_CREATION_ERROR);
                        continue;
                    }   
                    
                    //Tlai 17032014 check duplicate atp in trigger.new
                    //*********************************Start Check duplicate ATP*************************** 
                                       
                    if(!(Trigger.isUpdate && Trigger.oldMap.get(atp.Id).User__c == atp.User__c)){  
                        if (newAtpUniqRoleSet.contains(atp.Account__c +''+atp.User__C)){
                            atp.addError(ACCT_TM_DUP_USER_ROLE_ERROR);
                            continue;
                        } else {
                            newAtpUniqRoleSet.add(atp.Account__c +''+atp.User__C);
                        }
                        
                        newUserIdSet.add(atp.user__c);
                        
                    } 
                    //**********************************End check duplicate ATP****************************
                    if(Trigger.isUpdate &&( (Trigger.oldMap.get(atp.id).Team_Role__c!=ACC_TEAM_PRXY_TM_RL_CE) &&
                                 (Trigger.oldMap.get(atp.id).Team_Role__c!=ACC_TEAM_PRXY_TM_RL_FP)) && 
                                 ((atp.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE) ||(atp.Team_Role__c ==ACC_TEAM_PRXY_TM_RL_FP))){ 
                            newUserIdSet.add(atp.user__c);
                     }
                     //swap assignment from CE to FP or FP to CE
                    if(Trigger.isUpdate &&((Trigger.oldMap.get(atp.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE) &&
                                 (atp.Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP)||(Trigger.oldMap.get(atp.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP) &&
                                 (atp.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE))){
                            newUserIdSet.add(atp.user__c);      
                    }
                    
                    tempAccountIdSet.add(atp.account__c);
                    
                    atpList.add(atp);
                }//end for loop
                
                if(atpList.size() > 0){// 3 queries
                    Set<String> existAtpSet = new Set<String>();
                    List<Account_Team_Proxy__c> lstExistingATP = new List<Account_Team_Proxy__c>();
                    // check for new ATP or updated ATP with user change
                    if(newAtpUniqRoleSet.size() > 0){
                        
                        for(Account_Team_Proxy__c atp : [select Id,Account_Role_ID__c from Account_Team_Proxy__c where account__c in :tempAccountIdSet]){
                            existAtpSet.add(atp.Account_Role_ID__c);
                        }
                    }
                    
                    //check for new atp user or updated user with user change or role change
                    if(newUserIdSet.size() > 0){
                        mNewAtpUser = new Map<Id,User>([Select Id,name,Fab_Assigned__c,Fab_Assignment_Change__c from User where id in :newUserIdSet and isActive = true]);
                    }
                    
                    //map<ID,Account> accountDetails = new map<ID,Account>([SELECT id,siebel_account_id__c  FROM Account  WHERE id IN:tempAccountIdSet]);  
                    //system.debug('Siebel_Account_id:' + accountDetails);    
                    
                    for(Account_Team_Proxy__c atp1: atpList){
                        //retrieve user fab assignment
                        String usrAssignedFab = '';
                        if( newUserIdSet.contains(atp1.user__c)){
                            if(mNewAtpUser.containskey(atp1.User__c)){
                                usrAssignedFab = !String.isblank(mNewAtpUser.get(atp1.User__c).Fab_Assigned__c)?mNewAtpUser.get(atp1.User__c).Fab_Assigned__c:'';
                            }else{// InActive user 
                                 atp1.addError('Inactive user cannot be assigned');//put it to error code 
                                 continue;
                            }
                        }
                            
                        //duplication check for New ATP or updated ATP with user change
                        if(newAtpUniqRoleSet.size() > 0){                 
                            //check duplicate ATP in database
                            String atpUniId = atp1.Account__c+''+atp1.User__c;
                            if( newAtpUniqRoleSet.contains(atpUniId) && existAtpSet.contains(atpUniId)){
                                atp1.addError(ACCT_TM_DUP_USER_ROLE_ERROR);
                                continue;
                            }else{
                                //updating Account Role ID = Account.ID + User.ID 
                                atp1.Account_Role_ID__c = atp1.Account__c+''+atp1.User__c ;
                            }
                        }
                        
                        if(Trigger.Isinsert && (atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE ||atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP)){
                            atp1.Fab_Assignment__c = usrAssignedFab;
                        }
                        
                        //get the fab assignment from user for new/updated CE and FE atp roles  
                        else if(Trigger.isUpdate &&( (Trigger.oldMap.get(atp1.id).Team_Role__c!=ACC_TEAM_PRXY_TM_RL_CE) &&
                                 (Trigger.oldMap.get(atp1.id).Team_Role__c!=ACC_TEAM_PRXY_TM_RL_FP)) && 
                                 ((atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE) ||(atp1.Team_Role__c ==ACC_TEAM_PRXY_TM_RL_FP))){ 
                                                                                
                            atp1.Fab_Assignment__c=usrAssignedFab;
                        //swap assignment from CE to FP or FP to CE                                                     
                        }else if(Trigger.isUpdate &&((Trigger.oldMap.get(atp1.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE) &&
                                 (atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP)||(Trigger.oldMap.get(atp1.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP) &&
                                 (atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE))){
                                
                            atp1.Fab_Assignment__c=usrAssignedFab;
                            atp1.Fab_Assignment_change__c=false;
                            
                            List<String> APFab = new List<String>(Trigger.oldMap.get(atp1.id).Fab_Assignment__c.split('\\;')); 
                            List<String> UserFab = new List<String>(usrAssignedFab.split('\\;'));
                            
                            Set<String> fabDeleted=new Set<String>(APFab);
                            String finalval = '';
                            
                            if(atp1.fab_deleted__c!=null){
                                currMap = UtilsString.convertStringListToMap(atp1.fab_deleted__c.split('\\;'));
                            }
                            
                            fabDeleted.removeAll(UserFab);
                            
                            for(String n:Fabdeleted){
                                if(!currMap.containsKey(n)){
                                    finalval+=';'+n;
                                }
                            }
                            
                            if(atp1.fab_deleted__c <> null){
                                atp1.fab_deleted__c+=finalval;
                            } else if(finalval!='' && atp1.fab_deleted__c==null){
                                finalval=finalval.subString(1);
                                atp1.fab_deleted__c=finalval;
                            } 
                        //user changes the fab assignment for CE and FP                                             
                        }else if(Trigger.isUpdate &&(((Trigger.oldMap.get(atp1.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE) && (atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_CE))
                                                    ||((Trigger.oldMap.get(atp1.id).Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP) && (atp1.Team_Role__c==ACC_TEAM_PRXY_TM_RL_FP)))){
                                    
                            if(Trigger.oldMap.get(atp1.id).Fab_Assignment__c!=null){
                                OldFab =(Trigger.oldMap.get(atp1.id).Fab_Assignment__c.split('\\;'));
                            }                        
                            if(atp1.Fab_Assignment__c!=null){
                                UpdatedFab = atp1.Fab_Assignment__c.split('\\;');
                            }
                            
                            Set<String> FabDeleted=new Set<String>(OldFab);
                            String finalval='';
                            
                            if(atp1.fab_deleted__c!=null){
                               currMap = UtilsString.convertStringListToMap(atp1.fab_deleted__c.split('\\;'));
                            } 
                              
                            if(atp1.Fab_Assignment__c==usrAssignedFab){
                               atp1.Fab_Assignment_Change__c=false;
                            } else { 
                               atp1.Fab_Assignment_Change__c=true;
                            }
                               
                            FabDeleted.removeAll(UpdatedFab);
                            
                            for(String n:Fabdeleted){
                                if(!currMap.containsKey(n)){
                                    finalval+=';'+n;
                                }
                            }
                            
                            if(atp1.fab_deleted__c!=null){
                                atp1.fab_deleted__c+=finalval;
                            } else if(finalval!='' && atp1.fab_deleted__c==null){
                               finalval=finalval.subString(1);
                               atp1.fab_deleted__c=finalval;
                            }                           
                        } 

                        //populate integration fields based on the workflow condition: "Account Team Proxy - Outbound Message - To AIA"              
                        //**************************************************************************************  
                            if(/* con1*/(isIntegrationUser && String.isblank(atp1.siebel_status__c))
                                /* con2*/|| (!isIntegrationUser && (trigger.isinsert))
                                /* con3*/|| (!isIntegrationUser && trigger.isupdate && (atp1.fab_assignment__c <> trigger.oldMap.get(atp1.id).fab_assignment__c
                                                                                            || atp1.account_access__c <> trigger.oldMap.get(atp1.id).account_access__c
                                                                                            || atp1.opportunity_access__c <> trigger.oldMap.get(atp1.id).opportunity_access__c
                                                                                            || atp1.flag_for_delete__c <> trigger.oldMap.get(atp1.id).flag_for_delete__c
                                                                                            || atp1.team_role__c <> trigger.oldMap.get(atp1.id).team_role__c))
                                /*con4*/|| (trigger.isupdate && atp1.batch_sync_id__c <> trigger.oldMap.get(atp1.id).batch_sync_id__c)
                            ){
                                atp1.siebel_error_message__c = null;
                                atp1.siebel_sent_dateTime__c = datetime.now();
                                atp1.siebel_status__c = 'SENT';
                                atp1.siebel_sync_id__c = datetime.now().format();
                                atp1.martinistore_sync_status__c = 'SENT';
                            }
                        
                    } //end for loop
                }//end Qualified ATP check                                    
            }//Ending of Trigger=Update or Trigger=Insert in before trigger
            
        } // End Trigger.isBefore       
    
        if(Trigger.isAfter){
            set<string> sATP4deletion = new set<String>(); // acctId+ userId
            set <string> sAccountId4ATPDeletion = new set <string>();
            set <string> sUserId4ATPDeletion = new set <string>();
            
            set <string> sAccountId4AccTeamInsert = new set <string>();
            set <string> sUserId4AccTeamInsert = new set <string>();
            set <id> atpDelSet = new set <id>();   
                
            // VARIABLE FOR ACCOUNT TEAM MEMBER ROLLDOWN TO OPPTY PROGRAM   
            set<string> sOpptyTeamMemberKeysForDeletion = new set<string>(); // delete            
            set<id> setNewUpdateAcctTeamMemberAcctIDs = new set<id>();// insert/update
            map<string,Account_Team_Proxy__c> mOpptyTeamMembersForUpsert = new map<string,Account_Team_Proxy__c>(); // key: AccountID + _ + UserID          
                
            set<id> sAcctUpdate = new set<id>();//Tlai 27032014 for ClsAccountTeamProxyTriggerHandler
            
            //TLai 13032014: Updated code - remove inner query and DML operation in for loop
            if(Trigger.isUpdate || Trigger.isInsert){
                set <id> setActiveUserIDs = new set <id>();
                set<Id> userIdSet = new Set<Id>();
                for(Account_Team_Proxy__c atp : Trigger.new){
                    userIdSet.add(atp.User__c);
                }
                list <AccountTeamMember> listAccTMforInsert = new list <AccountTeamMember>(); 
                for (user u:[select id from user where IsActive = TRUE AND Id =: userIdSet]){
                    setActiveUserIDs.add(u.id);
                }  
                
                for(Account_Team_Proxy__c  atp: trigger.new){
                    
                    if( trigger.isinsert 
                        ||(trigger.isupdate && (atp.Flag_for_Delete__c == false || Trigger.oldMap.get(atp.id).Flag_for_Delete__c !=atp.Flag_for_Delete__c))){
                            sAcctUpdate.add(atp.account__c);
                    }
                    //Tlai  18032014 Optimized code to reomve DLM operation in for loop
                    if(trigger.isUpdate){
                        if(atp.Flag_for_Delete__c && Trigger.oldMap.get(atp.id).Flag_for_Delete__c !=atp.Flag_for_Delete__c ){ //
                            sATP4deletion.add(atp.Account__c +''+ atp.User__c);
                            sAccountId4ATPDeletion.add(atp.Account__c);
                            sUserId4ATPDeletion.add(atp.user__c);
                            //added by Vijay 05082015 skip the Opportunity Program Team Member deletion for Internal Account
                            if(atp.Account_RecType_DeveloperName__c != GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE){
                                sOpptyTeamMemberKeysForDeletion.add(createOpptyProgTeamMemKey(atp.Account__c,atp.User__c));
                            }
                            atpDelSet.add(atp.id);
                            continue;
                                                  
                        }
                    }
                    
                    //added by Vijay 05082015 added check to skip the Opportuinty related below logic for Internal Account
                    if(atp.Account_RecType_DeveloperName__c != GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE){
                        // Added by Nbustillos 02192013
                        // Cache account team member for insert or update (if team role, Opportunity Access changes, Fab Assignment)
                        if(trigger.isInsert && atp.Opportunity_Access__c!=null && setActiveUserIDs.contains(atp.user__c)){
                            // Added by Nbustillos 02202013, for insert/update rolldown of account team member
                            setNewUpdateAcctTeamMemberAcctIDs.add(atp.Account__c);
                            mOpptyTeamMembersForUpsert.put(createOpptyProgTeamMemKey(atp.Account__c,atp.User__c),atp);
                        }else if(trigger.isUpdate && setActiveUserIDs.contains(atp.user__c) && 
                                ((atp.Team_Role__c != trigger.oldmap.get(atp.id).Team_Role__c) || 
                                 (atp.Opportunity_Access__c != trigger.oldmap.get(atp.id).Opportunity_Access__c) || 
                                 (atp.Fab_Assignment__c != trigger.oldmap.get(atp.id).Fab_Assignment__c) ||
                                 (atp.Is_FAE__c != trigger.oldmap.get(atp.id).Is_FAE__c)
                                )){
                            if(atp.Opportunity_Access__c!=null){
                                // Added by Nbustillos 02252013, for insert/update rolldown of account team member
                                setNewUpdateAcctTeamMemberAcctIDs.add(atp.Account__c);
                                mOpptyTeamMembersForUpsert.put(createOpptyProgTeamMemKey(atp.Account__c,atp.User__c),atp);
                            }else{
                                // Added by Nbustillos 02252013, for delete rolldown of account team member when no opportunity access was given
                                sOpptyTeamMemberKeysForDeletion.add(createOpptyProgTeamMemKey(atp.Account__c,atp.User__c));
                            }
                        }
                    }
                    //only process the records that are not flagged for delete
                    if (!atp.Flag_for_Delete__c && setActiveUserIDs.contains(atp.user__c)){
                        AccountTeamMember atm = new AccountTeamMember (accountid=atp.Account__c, teammemberrole = atp.Team_Role__c, Userid=atp.User__c);
                        listAccTMforInsert.add (atm);
                        //Get the list of Account ID's and User ID's affected by the update
                        sAccountId4AccTeamInsert.add(atp.Account__c);
                        sUserId4AccTeamInsert.add(atp.User__c);
                    }
                                
                } //end for loop    
                
                /*==============================Operation after for loop ===============================*/
                   
                    
                 // insert account team member
                if(listAccTMforInsert.size() > 0){
                    insert listAccTMforInsert;
                }
                
                //update Account Team Share Record &  Insert Account Follower Record
                if(sAccountId4AccTeamInsert.size() > 0 && sUserId4AccTeamInsert.size() > 0){
                    
                    map <string, AccountShare> mapAccountShares = new map <string, AccountShare>();
                    //list <AccountShare> updateAccountShare = new list <AccountShare>();
                    //Nikhil- 28Apr16 - Changed from List to Set to avoid duplicates.
                    Set<AccountShare> updateAccountShare = new Set<AccountShare>();
                    
                    set <string> setAccountFollowers = new set <string>();
                    //list <EntitySubscription> insertAccountFollowers = new list <EntitySubscription>();
                    //Nikhil- 28Apr16 - Changed from List to Set to avoid duplicates.
                    Set<EntitySubscription> insertAccountFollowers = new Set<EntitySubscription>();
                    
                    //Code for Inserting the Account Team Share Record
                    //query the Account Team Share table to get all records affected
                    for (AccountShare accountShareRecord: [SELECT Id, AccountId,  UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel FROM AccountShare WHERE RowCause = 'Team' AND AccountId IN :sAccountId4AccTeamInsert AND UserOrGroupId IN :sUserId4AccTeamInsert]){
                        mapAccountShares.put(accountShareRecord.AccountId +'' +  accountShareRecord.UserOrGroupId, AccountShareRecord);
                    }
                    
                    //query the EntitySubscription table to get all records affected
                    for (EntitySubscription AccountES: [SELECT id, parentid, subscriberid, parent.name FROM EntitySubscription WHERE parentid = :sAccountId4AccTeamInsert and subscriberid =:sUserId4AccTeamInsert]){
                        setAccountFollowers.add(AccountES.parentid +'' + AccountES.subscriberid);
                    }
                    
                    //build the list of Account Share records for update
                    for (Account_Team_Proxy__c atp: trigger.new){
                        //only process records that are not flagged for delete, not an inactive user, and not the Account Owner                 
                        if (!atp.Flag_for_Delete__c &&  atp.IsAccountOwner__c == 'FALSE' && setActiveUserIDs.contains(atp.User__c) ){
                            string AccountID = atp.Account__c;
                            string UserID = atp.User__c;
                            AccountShare AccountShr = mapAccountShares.get(AccountID + UserID);
                            AccountShr.AccountAccessLevel = AccessC.get(atp.Account_Access__c);
                            AccountShr.OpportunityAccessLevel = (AccessC.get(atp.Opportunity_Access__c) != null)?AccessC.get(atp.Opportunity_Access__c): 'None';
                            
                            updateAccountShare.add(AccountShr);                 
                        }
                        
                        //only process records that are not flagged for delete, not an inactive user                    
                        if (!atp.Flag_for_Delete__c && setActiveUserIDs.contains(atp.User__c) ){
                            //Existing set does not Contain, so need to create a new Entity Subscription
                            if (!setAccountFollowers.contains(atp.Account__c+'' + atp.User__c)){
                                insertAccountFollowers.add(new EntitySubscription(SubscriberId=atp.User__c, ParentId= atp.Account__c));
                            }
                        }
                    }
                    //update the list of Account Share records
                    if(updateAccountShare.size() > 0){
                        List<AccountShare> lstUpdateAccountShare = new List<AccountShare>();
                        lstUpdateAccountShare.addAll(updateAccountShare);
                        update lstUpdateAccountShare;
                    }
                    if(insertAccountFollowers.size()>0){
                        List<EntitySubscription> lstInsertAccountFollowers = new List<EntitySubscription>();
                        lstInsertAccountFollowers.addAll(insertAccountFollowers);
                        insert lstInsertAccountFollowers;
                    }
                }
                
            }// end trigger.isupdate||trigger.isinsert in after trigger
            
            
            
            /*==============================Operation for all after events ===============================*/    
            // Delete accountteammember & EntitySubscription
            if((trigger.isUpdate) && sATP4deletion.size()>0 ){
                        
                //delect accountteammember
                list <AccountTeamMember> atmDelList = new list<AccountTeamMember>();
                for(AccountTeamMember atm : [select accountid, UserId,TeamMemberRole from AccountTeamMember where UserId in : sUserId4ATPDeletion and accountid in:sAccountId4ATPDeletion]){
                    if(sATP4deletion.contains(atm.accountid+''+atm.UserId)){
                        atmDelList.add(atm);
                    }
                }
                
                if(atmDelList.size() >0){
                    delete atmDelList;
                }
                
                //delete EntitySubscription
                list<EntitySubscription> esDelList = new list<EntitySubscription>();
                for(EntitySubscription es : [SELECT id, parentid, subscriberid FROM EntitySubscription WHERE subscriberid in :sUserId4ATPDeletion and parentid in :sAccountId4ATPDeletion]){
                    if(sATP4deletion.contains(es.parentid +''+ es.subscriberid)){
                        esDelList.add(es);
                    }
                }
                
                if(esDelList.size()>0){
                    delete esDelList;
                }
                
                //Added by Vijay 05082015 added isEmpty check
                if(!sOpptyTeamMemberKeysForDeletion.isEmpty()){
                    rolldownDeleteToOpptyTeamMember(sOpptyTeamMemberKeysForDeletion);
                }
                
                //Delete ATP
                if(atpDelSet.size()>0){
                    list<Account_Team_Proxy__c >atpDelList = [select id from Account_Team_Proxy__c where id in:atpDelSet];
                    delete atpDelList;
                }  
            }  
            
            // check if there are inserts to roll down 
            system.debug(logginglevel.error, mOpptyTeamMembersForUpsert);
            if((trigger.isInsert || trigger.isUpdate) && mOpptyTeamMembersForUpsert.size()>0){
                rolldownInsertUpdateToOpptyTeamMember(setNewUpdateAcctTeamMemberAcctIDs, mOpptyTeamMembersForUpsert);
            }
            
            //updating the Primary CSR field in account. 
            if((trigger.isupdate || trigger.isinsert) && sAcctUpdate.size() >0 && !system.isFuture() && !system.isBatch())  {
                ClsAccountTeamProxyTriggerHandler.populatePrimaryCSR(sAcctUpdate); //!!!!got error here
            }
            //Added by ASOLITO 04/22/2013
            //Account to ERP integration when created or updated                                                    
            if(!AccountDetailChange.hasRun && (trigger.isInsert || trigger.isUpdate)){
                Map<String,Account_Team_Proxy__c> processRecs = new Map<String,Account_Team_Proxy__c>();        
                
                //Shuchi - 03042015 - Added record type check on the ERP callout to bypass IBM Accounts   
                Map<Id,Id> accRecType = new Map<Id,Id>(); 
                set<Id> accId = new set<Id>();
                for(Account_Team_proxy__c accTeamProxy: trigger.new){
                    accId.add(accTeamProxy.account__c);
                }
                for(account acc:[select id,recordtypeId from account where Id IN: accId]){
                    accRecType.put(acc.id,acc.recordtypeId);
                }                     
                for(Account_Team_proxy__c a: trigger.new ){
                    //Only 1 account team proxy record for the same account should be sent to AIA
                    if(!processRecs.containsKey(a.account__c) && accRecType.get(a.account__c) != EnvironmentVariable.get('ACCT_RT_ID_IBM_ACCOUNT')){                    
                        if(trigger.isInsert){ 
                            //Added by ASOLITO 09/01/2013
                            //Filter team roles for ERP integration
                            if(UtilsString.isNotBlank(a.team_role__c)){
                                if(a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_AM) || a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_TS) ||
                                   a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_AE) || a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_CSR)){
                                    processRecs.put(a.account__c,a);
                                }
                            }
                        //Added the check to prevent execution by the AccountTeamUpdateBatch class                  
                        } else if(trigger.isUpdate && (a.Batch_Sync_Id__c == trigger.oldMap.get(a.Id).Batch_Sync_Id__c ) &&
                                 (a.account_access__c <> trigger.oldMap.get(a.id).account_access__c || 
                                  a.opportunity_access__c <> trigger.oldMap.get(a.id).opportunity_access__c ||
                                  a.team_role__c <> trigger.oldMap.get(a.id).team_role__c) &&
                                  //Added by ASOLITO 09/01/2013
                                  //Filter team roles for ERP integration 
                                  (a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_AM) || a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_TS) ||
                                   a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_AE) || a.team_role__c.contains(ACCT_TM_PRXY_TM_RL_CSR) ||
                                   trigger.oldMap.get(a.id).team_role__c.contains(ACCT_TM_PRXY_TM_RL_AM) ||
                                   trigger.oldMap.get(a.id).team_role__c.contains(ACCT_TM_PRXY_TM_RL_TS) ||
                                   trigger.oldMap.get(a.id).team_role__c.contains(ACCT_TM_PRXY_TM_RL_AE) ||
                                   trigger.oldMap.get(a.id).team_role__c.contains(ACCT_TM_PRXY_TM_RL_CSR))){
                                                                                                                                                               
                             processRecs.put(a.account__c,a);
                        }
                    }
                }  
                
                System.debug(processRecs);
                
                for(String p: processRecs.keySet()){    
                    AccountDetailChange.send(processRecs.get(p));   
                }
            }
            
            //Added by Vijay 02032015 - below code has been added for Internal Device sharing
            if(Trigger.isInsert){
                ClsAccountTeamProxyTriggerHandler atpTriggerHandler = new ClsAccountTeamProxyTriggerHandler(Trigger.isExecuting, Trigger.size);
                atpTriggerHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
            }else if(Trigger.isUpdate){
                ClsAccountTeamProxyTriggerHandler atpTriggerHandler = new ClsAccountTeamProxyTriggerHandler(Trigger.isExecuting, Trigger.size);
                atpTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap); 
            }
            
            
        } //end trigger.isafter
        
         
        
    }// end integraion usr check
        
    // function that deletes related oppty team member based on account and user id
    // TBD: This potentially can hit governor limit. Can be moved as asynchronous process via @future.
    private void rolldownDeleteToOpptyTeamMember(set<string> sAccountUserKeys){
         
         // Retrieve all existing oppty team members related to accounts
         // yash change Account_User_Key__c to ExternalUserKeyField__c
         list<Opportunity_Program_Team_Member__c> lstOpptyTeamMemberForDelete = new list<Opportunity_Program_Team_Member__c>();
         for(Opportunity_Program_Team_Member__c oOpptyTeamMember : [select id from Opportunity_Program_Team_Member__c 
                                                                    where ExternalUserKeyField__c like :sAccountUserKeys]){
            lstOpptyTeamMemberForDelete.add(oOpptyTeamMember);
         }
         
         // check if there are oppty team members to delete
         if(lstOpptyTeamMemberForDelete.size()>0){
            delete lstOpptyTeamMemberForDelete;
            
         }
    }    
    
    // function that updates related oppty team member based on account and user id
    // TBD: This potentially can hit governor limit. Can be moved as asynchronous process via @future.
    private void rolldownInsertUpdateToOpptyTeamMember(set<id> setAcctIDs, map<string,Account_Team_Proxy__c> mNewTeamMembersForUpsert){
        //list<Opportunity_Program_Team_Member__c> lstProgTeamMemberToInsert = new list<Opportunity_Program_Team_Member__c>();
        list<Opportunity_Program_Team_Member__c> lstProgTeamMemberToUpsert = new list<Opportunity_Program_Team_Member__c>();
        
        system.debug('mNewTeamMembersForUpsert: ' + mNewTeamMembersForUpsert);
        
        // retrieve and cache any existing Oppty Program Member with same Account ID, User ID key
        map<string,Opportunity_Program_Team_Member__c> mOpptyProgramTeamMembers = new map<string,Opportunity_Program_Team_Member__c>(); //key: AccountId + _ + UserId + _ + OpptyProgramId
        // yash
        for(Opportunity_Program_Team_Member__c oOpptyTeamMember : [select id, Account_User_Key__c, ExternalUserKeyField__c, User__c, Team_Role__c, Core_Team_Member__c, 
                                                                   Opportunity_Program__c from Opportunity_Program_Team_Member__c
                                                                where ExternalUserKeyField__c in :mNewTeamMembersForUpsert.keySet()]){
            mOpptyProgramTeamMembers.put((oOpptyTeamMember.ExternalUserKeyField__c+ '_' + oOpptyTeamMember.Opportunity_Program__c), oOpptyTeamMember);
        }
        system.debug('mOpptyProgramTeamMembers: ' + mOpptyProgramTeamMembers);
        
        // retrieve all oppty programs related to account
        map<id, set<id>> mAcctId2SetOppGrm = new map<id, set<id>>();
        for(Opportunity_Program__c op :[select id, Account__c from Opportunity_Program__c where Account__c in :setAcctIDs order by Account__c]){
            if(mAcctId2SetOppGrm.containskey(op.Account__c)){
                mAcctId2SetOppGrm.get(op.Account__c).add(op.id);
            }else{
                mAcctId2SetOppGrm.put(op.Account__c, new set<id>{op.id});
            }
        }
        system.debug('mAcctId2SetOppGrm: ' + mAcctId2SetOppGrm);
         
        // iterate mNewTeamMembersForUpsert to find Opportunity Program team member for upsert
        for(string key : mNewTeamMembersForUpsert.keySet()){
            //Tlai 11042014 - added validtion to create optm under opportunity program of the same account as ATP
            Account_Team_Proxy__c atp = mNewTeamMembersForUpsert.get(key);
            
            if(mAcctId2SetOppGrm.containskey(atp.account__c)){
                // iterate to list of Oppty Program related to accounts
                for(id opptyProgId : mAcctId2SetOppGrm.get(atp.account__c)){
                    //build the key
                    string sAcctUserOpptyProgKey = key + '_' + opptyProgId;
                    // check if there is already a member for this Opportunity Program
                    if(mOpptyProgramTeamMembers.containsKey(sAcctUserOpptyProgKey)){
                        // get oppty program team and update role and convert to core team
                        Opportunity_Program_Team_Member__c oUpdatedOpptyProgTeamMember = mOpptyProgramTeamMembers.get(sAcctUserOpptyProgKey);
                        
                        oUpdatedOpptyProgTeamMember.Team_Role__c = atp.Team_Role__c;
                        oUpdatedOpptyProgTeamMember.Core_Team_Member__c = true;
                        oUpdatedOpptyProgTeamMember.Device_Access__c = atp.Opportunity_Access__c;
                        oUpdatedOpptyProgTeamMember.Opportunity_Program_Access__c = atp.Opportunity_Access__c;
                        oUpdatedOpptyProgTeamMember.Account_Team_Proxy__c = atp.Id; // Added by Nbustillos 07/09/2013
                        //yash
                        oUpdatedOpptyProgTeamMember.ExternalUserKeyField__c = atp.Account__c + '_' +  atp.User__c;
                        oUpdatedOpptyProgTeamMember.Is_FAE__c = atp.Is_FAE__c;
                        
                        lstProgTeamMemberToUpsert.add(oUpdatedOpptyProgTeamMember);
                    }else {
                        // generate new oppty program team member
                        //yash
                        lstProgTeamMemberToUpsert.add(new Opportunity_Program_Team_Member__c(
                                                            User__c=atp.User__c,
                                                            Opportunity_Program__c=opptyProgId,
                                                            Core_Team_Member__c=true,
                                                            Device_Access__c=atp.Opportunity_Access__c,
                                                            Opportunity_Program_Access__c=atp.Opportunity_Access__c,
                                                            Team_Role__c=atp.Team_Role__c,
                                                            ExternalUserKeyField__c=atp.Account__c + '_' +  atp.User__c,
                                                            Account_Team_Proxy__c=atp.Id,
                                                            Is_FAE__c = atp.Is_FAE__c
                                                ));
                    }
            
                }
            }
            
        }
        
        system.debug('lstProgTeamMemberToUpsert: ' + lstProgTeamMemberToUpsert);
        if(lstProgTeamMemberToUpsert.size()>0){
            upsert lstProgTeamMemberToUpsert;
        }
    }   
    
    private string createOpptyProgTeamMemKey(id accountID, id userID){
        return (accountID + '_' + userID);
    }
    
   
  
}