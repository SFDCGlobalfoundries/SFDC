/*    **
* @author       :   Ankit Singhal
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to change Reticle Obsolescence from Customer Portal                  
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        ASinghal        06/09/2013          Created the Trigger Helper Class
        Sameer Matale   04/03/2014          Sharing with FTA and FAS
        Sameer Matale   05/03/2014          Commenting un-used method 'ROSrollupSummryROScycle'
        NJain           20/03/2014          Optimized the function ROSReticleafterUpdate and removed Customer Portal user sharing
        NJain           15/10/2014          Commented all the Fab User Sharing Logic
        Shuchi          16/02/2015          Added condition to nullify few fields when reticle is activated 
        DBiswal         06172015            Added sharing for PI/YE and CE users
**/

public class ROS_ReticleTriggerHelper{

    public static void ROSReticleBeforeUpdate(List<Reticle__c> LNewReticle,Map<Id,Reticle__c> ReticleOldMap){
        Id CurrentROSCycleId;
        String cycle = ROS_Util.getCurrentROSCycle();
        List<ROS_Cycle__c> lstROScycles = [SELECT Id, Name FROM ROS_Cycle__c WHERE Name = : cycle LIMIT 1];
        if(lstROScycles != NULL && !lstROScycles.isEmpty()){
            CurrentROSCycleId = lstROScycles[0].Id;
        }        
        System.debug('======cycle>>>>>'+Cycle+',,,,CurrentROSCycleId,,,,,,,'+CurrentROSCycleId);
        
        for(Reticle__c temp : LnewReticle){
            Reticle__c oldreticle = ReticleOldMap.get(temp.id);
            if((oldreticle.ROS_Status__c== NULL || oldreticle.ROS_Status__c=='')&&
               (temp.ROS_Status__c!= NULL && temp.ROS_Status__c!='')){
                   if(CurrentROSCycleId != NULL){
                       temp.ROS_Cycle__c=CurrentROSCycleId;
                   }else{
                       temp.addError('There is no active ROS Cycle.');
                   }
            }
            if(oldreticle.Reticle_Workflow_Status__c != temp.Reticle_Workflow_Status__c){
                if( (temp.Reticle_Workflow_Status__c =='Pending for Customer Feedback') || 
                    (temp.Reticle_Workflow_Status__c=='Pending to Notify Customer')     ||
                    (temp.Reticle_Workflow_Status__c== null) //Shuchi -- 16022015
                ){               
                    temp.Shipping_Address__c=null;
                    temp.Item__c=null;
                    temp.HS_Code__c=null;
                    
                    // 19Nov14 -- Removed field updates in Backtrack Logic
                    temp.SAfull__c = NULL;
                    temp.Forwarder_Information__c = NULL;
                    temp.Forwarder_Name__c = NULL;
                    temp.Account_Number__c = NULL;
                    temp.Contact_Name__c = NULL;
                    temp.Contact_Phone_Number__c = NULL;
                    temp.Disposition_Date__c = NULL;
                    temp.Disposition_Requested_by_Customer__c = FALSE;
                    temp.ROS_Status__c = NULL;
                    temp.GE_Form_Date__c = NULL;
                    temp.GE__c = NULL;
                    temp.STF_Obsolence__c = FALSE;
                    
                }
                if(temp.Reticle_Workflow_Status__c =='Pending for Customer Feedback'){
                    if(oldReticle.Customer_Notify_Date__c == NULL){
                        temp.Customer_Notify_Date__c = System.TODAY();
                    }
                }
            }
        }
    }
    
    public static void ROSReticleafterUpdate(Map<Id,Reticle__c> ReticleNewMap,Map<Id,Reticle__c> ReticleOldMap){
        List<Reticle__c> LReticlelist = new List<Reticle__c>([Select Id,(Select Id,Fab__c from Fab_Reticle__r), Name,Account__c from Reticle__c where id in :ReticleNewMap.keyset()]);
        //Map<Id,List<Id>> Reticle= new Map<Id,List<Id>>();
        //Set<Id> fabIds = new Set<Id>();

        //for(Reticle__C obj : LReticlelist ){
        //    List<Id> Fabs = new List<ID>();
        //    for(Fab_Reticle__c obj1 : obj.Fab_Reticle__r){
        //        Fabs.add(obj1.Fab__c);
        //    }
        //    fabIds.addAll(Fabs);
        //    Reticle.put(obj.Id,Fabs);
        //}

        //List<Fab_User__c> mapfabUser = new List<Fab_User__C>([Select Id,User__C,FAB__c from Fab_User__c where fab__c in : fabIds and Is_ROS_User__c =: true]);

        Map<Id,Id> MAccountIds=new Map<Id,Id>();
        Map<Id,List<Account_Team_Proxy__c>> MRetIdATPProxyMap = new Map<Id,List<Account_Team_Proxy__c>>();
        //Map<Id,List<FAb_User__c>> RetcileFabUserMap = new Map<Id,List<FAb_User__c>>(); // Get All Fab Users
        Map<Id,Set<Id>> MAllRetIdCSRUsers= new Map<Id,Set<Id>>();
        
        Map<String,Integer> MWorkflowSeq = new Map<String,Integer>();
        //List<Reticle__c> LReticles = new List<Reticle__c>();
        List<String> lstPickvals=new List<String>();

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Reticle__c');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Reticle_Workflow_Status__c').getDescribe().getPickListValues();

        for(Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(a.getValue());
        }

        Integer i = 1;
        for(String eachstatus : lstPickvals){
            MWorkflowSeq.put(eachstatus, i);
            i++;
        }
        
        for(Reticle__c ret : LReticlelist) {
            MAccountIds.put(ret.Id,ret.Account__c);
        }
        
        Map<Id,Account> MAccountATPContactlist = new Map<Id,Account>([SELECT Id, Name, 
                                                                             (SELECT Id, Team_Role__c, User__c 
                                                                              FROM Account_Team_Proxy__r 
                                                                              WHERE (    Team_Role__c = 'Primary Customer Service Rep'
                                                                                      OR Team_Role__c = 'Backup Customer Service Rep'
                                                                                      OR Team_Role__c = 'Customer Service Rep'
                                                                                      OR Team_Role__c = 'Primary Field Application Engineer'
                                                                                      OR Team_Role__c = 'Field Application Engineer'
                                                                                      OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                                      OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))
                                                                                  And User__r.IsActive = true)
                                                                       FROM Account 
                                                                       WHERE Id in :MAccountIds.values()]);
        
        
        //Modifying the query to filter the results based on Row Cause
        List<Reticle__Share> LAllSharedRecords=new List<Reticle__Share>([Select Id,UserOrGroupId,ParentId from Reticle__Share where ParentId in :ReticleNewMap.values() 
                                                                          and rowCause in ('Sharing_with_CSR__c','Sharing_with_Fab_Users_after_Obselescenc__c')]);
        
        //Nikhil--preparing map of Reticle and its sharing records
        map<Id,List<Reticle__Share>> mapRetShare = new map<Id,List<Reticle__Share>>();
        for(Reticle__Share retShare :LAllSharedRecords){
            if(mapRetShare.containsKey(retShare.ParentId)){
                mapRetShare.get(retShare.ParentId).add(retShare);
            }else{
                mapRetShare.put(retShare.ParentId, new List<Reticle__Share>{retShare});
            }
        }
                                                                    
        for(Reticle__c ret : ReticleNewMap.values()) {
            if(ret.Account__c != null) {
                Set<Id> SUsers = new Set<Id>();                
                for(Account_Team_Proxy__c atp :MAccountATPContactlist.get(MAccountIds.get(ret.Id)).Account_Team_Proxy__r){
                    SUsers.add(atp.User__c);
                }
                MAllRetIdCSRUsers.put(ret.Id,SUsers); 
            }
        }
        
        Set<Id> WWSMQueueIds = new Set<Id>();
        //Set<String> SRemoveFabUsersAccess = new Set<String>();
        Set<String> SRemoveCSRAccess = new Set<String>();
        
        for(GroupMember g :[Select UserorGroupId From GroupMember where Group.Name =:'WWMS ROS Team']){
            WWSMQueueIds.add(g.UserorGroupId);
        }
        
        Set<Reticle__share>  addShare     = new Set<Reticle__share>();
        List<Reticle__share> removeShare  = new List<Reticle__share>();
        List<Reticle__share> updateShare  = new List<Reticle__share>();
        
        for(Reticle__c temp : ReticleNewMap.values()){
            
            Reticle__c tempOldReticle = ReticleoldMap.get(temp.id);
            
            if(temp.Account__c!= NULL &&
               tempOldReticle.ROS_Status__c =='' && 
               temp.ROS_Status__c != '' &&
               temp.Reticle_Workflow_Status__c != 'Pending for Customer Feedback' 
               ){                
                   temp.adderror(ROS_Error_Messages__c.getInstance('Obselence_Customer_Feedback').Value__c);
            }       
                    
            if(   temp.Account__c!=null 
                &&(temp.Debit_Note_Number__c     == tempOldReticle.Debit_Note_Number__c)
                &&(temp.Debit_Note_Waive_Off__c  == tempOldReticle.Debit_Note_Waive_Off__c)
                &&(temp.ROS_Status__c            == tempOldReticle.ROS_Status__c)
                &&(temp.Reticle_workflow_Status__c==tempOldReticle.Reticle_workflow_Status__c)
                &&(temp.Evidence_Certificate__c  == tempOldReticle.Evidence_Certificate__c)
                &&(temp.Draft__c                 == tempOldReticle.Draft__c)
                &&(temp.Shipping_Address__c      == tempOldReticle.Shipping_Address__c)
                &&(temp.ROS_Status__c            == tempOldReticle.ROS_Status__c)
                &&(MAllRetIdCSRUsers.get(temp.Id).contains(Userinfo.getUserId()))){
                    temp.adderror(ROS_Error_Messages__c.getInstance('CSR_Error_Message').Value__c);
            }
            
            //=================== Code for Back Track================
            if(temp.Account__c !=null){
                if (temp.Reticle_workflow_Status__c == 'Pending to Notify Customer'){                        
                    Set<Id> tempUsersToRemoveSharing = new Set<Id>();
                     
                    //Add sharing for CSR
                    if(MAllRetIdCSRUsers.containsKey(temp.id)){
                        addShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(temp.id,MAllRetIdCSRUsers.get(temp.id),'edit',''+Schema.Reticle__Share.RowCause.Sharing_with_CSR__c+''));
                    }
                                          
                    //if(mapRetShare.containsKey(temp.id) && mapRetShare.get(temp.Id) != NULL){
                    //    tempUsersToRemoveSharing.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsersNew(temp.id,Reticle,mapfabUser,mapRetShare.get(temp.id)));
                    //}
                    if(!tempUsersToRemoveSharing.isEmpty() && mapRetShare.get(temp.Id) != NULL){
                        removeShare.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecords(temp.id,tempUsersToRemoveSharing,mapRetShare.get(temp.id)));
                    }   
                }
                else if(temp.Reticle_workflow_Status__c == 'Pending for Customer Feedback'){
                    Set<Id> tempUsersToRemoveSharing = new Set<Id>();
                     
                    if(MAllRetIdCSRUsers.containsKey(temp.id)){
                        addShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(temp.id,MAllRetIdCSRUsers.get(temp.id),'edit',''+Schema.Reticle__Share.RowCause.Sharing_with_CSR__c+''));
                        tempUsersToRemoveSharing.addAll(MAllRetIdCSRUsers.get(temp.id));
                    }
                    //if(mapRetShare.containsKey(temp.id) && mapRetShare.get(temp.Id) != NULL){
                    //    tempUsersToRemoveSharing.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsersNew(temp.id,Reticle,mapfabUser,mapRetShare.get(temp.id)));
                    //}                    
                    if(!tempUsersToRemoveSharing.isEmpty() && mapRetShare.get(temp.Id) != NULL){
                        removeShare.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecords(temp.id,tempUsersToRemoveSharing,mapRetShare.get(temp.id)));
                    }                     
                }
                else if (temp.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up'){
                    Set<Id> tempUsersToRemoveSharing = new Set<Id>();
                    //addShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithFabUser(temp.id,Reticle,mapfabUser,'edit',''+Schema.Reticle__Share.RowCause.Sharing_with_Fab_Users_after_Obselescenc__c+''));
                    
                    if(MAllRetIdCSRUsers.containsKey(temp.id)){
                        addShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(temp.id,MAllRetIdCSRUsers.get(temp.id),'read',''+Schema.Reticle__Share.RowCause.Sharing_with_CSR__c+''));
                        tempUsersToRemoveSharing.addAll(MAllRetIdCSRUsers.get(temp.id));
                    }
                    //if(mapRetShare.containsKey(temp.id) && mapRetShare.get(temp.Id) != NULL){
                    //    tempUsersToRemoveSharing.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsersNew(temp.id,Reticle,mapfabUser,mapRetShare.get(temp.id)));
                    //}                    
                    if(!tempUsersToRemoveSharing.isEmpty() && mapRetShare.get(temp.Id) != NULL){
                        removeShare.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecords(temp.id,tempUsersToRemoveSharing,mapRetShare.get(temp.id)));
                    }
                }
                else if (temp.Reticle_workflow_Status__c == 'Pending for STF Obsolescence'){
                    
                    Set<Id> tempUsersToRemoveSharing = new Set<Id>();
                    
                    if(MAllRetIdCSRUsers.containsKey(temp.id)){
                        addShare.addAll(ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(temp.id,MAllRetIdCSRUsers.get(temp.id),'read',''+Schema.Reticle__Share.RowCause.Sharing_with_CSR__c+''));
                        tempUsersToRemoveSharing.addAll(MAllRetIdCSRUsers.get(temp.id));
                    }
                    //if(mapRetShare.containsKey(temp.id) && mapRetShare.get(temp.Id) != NULL){
                    //    tempUsersToRemoveSharing.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsersNew(temp.id,Reticle,mapfabUser,mapRetShare.get(temp.id)));
                    //}                    
                    if(!tempUsersToRemoveSharing.isEmpty() && mapRetShare.get(temp.Id) != NULL){
                        removeShare.addAll(ROS_ReticleDatawarehousehelper.RemoveSharingRecords(temp.id,tempUsersToRemoveSharing,mapRetShare.get(temp.id)));
                    }
                }
            }
            //End Code for Back Track
            
            if(temp.Account__c != NULL){
                if( temp.Reticle_workflow_Status__c == 'Pending to Notify Customer'){
                    MRetIdATPProxyMap.put(temp.id,MAccountATPContactlist.get(MAccountIds.get(temp.id)).Account_Team_Proxy__r);
                }

                //Remove CSRs edit access after Reticle Workflow Status is Pending for Fab's Followup
                if(temp.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up' && 
                        (tempOldReticle.STF_Obsolence__c == false|| ReticleNewMap.get(temp.Id).STF_Obsolence__c==true) && 
                        !temp.isActive__c) {
                    SRemoveCSRAccess.add(temp.Id);   
                }
                //Remove Fab's User edit access after Reticle Workflow Status is closed
                //else if(temp.Account__c!=null && 
                //        temp.Reticle_workflow_Status__c == 'Closed' && 
                //        tempOldReticle.Reticle_workflow_Status__c != 'Closed' && 
                //        !temp.isActive__c) {
                //    SRemoveFabUsersAccess.add(temp.Id);   
                //}
                
                //Adding record sharing to fab Users
                //if( temp.Reticle_workflow_Status__c == 'Pending for STF Obsolescence' && 
                //    temp.STF_Obsolence__c == true && 
                //    (temp.ROS_Status__c=='Return' || temp.ROS_Status__c=='Scrap')){
                //        LReticles.add(temp);
                //}
            }
        }

        if(!MRetIdATPProxyMap.isEmpty()){
            ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs(MRetIdATPProxyMap);
        }        
        //if(!LReticles.isEmpty()){
        //    ROS_ReticleDatawarehousehelper.SharingRecordswithFabUsers(LReticles);
        //}

        //if(!SRemoveFabUsersAccess.isEmpty()){
        //    updateShare.addAll(ROS_Util.updateReticleAccess(SRemoveFabUsersAccess,'Sharing_with_Fab_Users_after_Obselescenc__c','Read'));
        //}

        if(!SRemoveCSRAccess.isEmpty()){
            updateShare.addAll(ROS_Util.updateReticleAccess(SRemoveCSRAccess,'Sharing_with_CSR__c','Read'));
        }
        
        List<Reticle__share> lstShare = new List<Reticle__share>();
        lstShare.addAll(addShare);
        
        delete removeShare;
        Database.SaveResult[] lsr = Database.insert(lstShare, false);
        Database.SaveResult[] lSaveResultUpdate = Database.update(updateShare, false);
    }
    //shuchi --17022015
    public static void ROSReticleafterUpdateAccountSharing(List<Reticle__c> lstReticles){
        Set<String> setAccount = new Set<String>();
        List<Account_Team_Proxy__c> lstAccTeamProxy = new List<Account_Team_Proxy__c>();
        List<Reticle__Share> lstReticleShare = new List<Reticle__Share>();
        Map<Reticle__c, List<Account_Team_Proxy__c>> reticleAccTeamProxy = new Map<Reticle__c, List<Account_Team_Proxy__c>>();
        
        for(Reticle__c Eachreticle: lstReticles){
            setAccount.add(Eachreticle.Account__c);
        }
        lstAccTeamProxy = [SELECT Id,User__c,Account__c from Account_Team_Proxy__c 
                            WHERE Account__c IN:setAccount 
                                AND (  Team_Role__c = 'Primary Customer Service Rep' 
                                    OR Team_Role__c = 'Backup Customer Service Rep' 
                                    OR Team_Role__c = 'Customer Service Rep'  
                                    OR Team_Role__c = 'Primary Field Technical Support'
                                    OR Team_Role__c = 'Primary Field Application Engineer'                            
                                    OR Team_Role__c = 'Field Technical Support'
                                    OR Team_Role__c = 'Field Application Engineer'
                                    OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                    OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))
                                AND User__r.IsActive = true];            

        for(Reticle__C eachReticle: lstReticles){
            List<Account_Team_Proxy__c> AccTeamProxyNew = new List<Account_Team_Proxy__c>();    
            for(Account_Team_Proxy__c eachATP: lstAccTeamProxy){
                if(eachReticle.Account__c == eachATP.Account__c){
                    AccTeamProxyNew.add(eachATP);
                }
            }
            if(!AccTeamProxyNew.isEmpty()){
                reticleAccTeamProxy.put(eachReticle,AccTeamProxyNew);
            }
        }
            
        if(!reticleAccTeamProxy.isEmpty()){
            for(Reticle__c reticleEach : reticleAccTeamProxy.keySet()){
                for(Account_Team_Proxy__c  accTeam: reticleAccTeamProxy.get(reticleEach)){
                    Reticle__share reticleShare = new Reticle__share();
                    reticleShare.ParentId = reticleEach.Id;
                    reticleShare.UserOrGroupId = accTeam.User__c;                            
                    reticleShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_CSR__c;
                    if(reticleEach.Reticle_workflow_Status__c == 'Pending to Notify Customer' 
                        || reticleEach.Reticle_workflow_Status__c == 'Pending for Customer Feedback' 
                        || reticleEach.Reticle_workflow_Status__c == 'Pending for STF Obsolescence' 
                        || reticleEach.Reticle_workflow_Status__c == NULL){
                        reticleShare.AccessLevel = 'Edit';
                    }
                    else{
                        reticleShare.AccessLevel = 'Read';
                    }
                    lstReticleShare.add(reticleShare);
                }
            }
        }
        if(!lstReticleShare.isEmpty()){
            insert lstReticleShare;
        }
    } 
    
    /*
    public static Set<Reticle__Share> piyeSharingfab(ID reticleID, Set<Id> groupIdset,String Accesslevel,String rowCause){
        Set<Reticle__Share> sReticleshare = new Set<Reticle__Share>();
        
        for(ID Ids : groupIdset){
            Reticle__Share Retshare    = new Reticle__Share();
            Retshare.ParentId          = reticleID;
            Retshare.UserOrGroupId     = Ids;
            Retshare.AccessLevel       = Accesslevel;
            Retshare.RowCause          = rowCause;
            sReticleshare.add(Retshare);
        }
        return sReticleshare;
    }*/
    
    //DBiswal 06172015
    public static void updatePIYESharingforFab (Map<Id,Reticle__c> newMap, Map<Id,Reticle__c> oldMap, String triggerContext){
        List<Reticle__Share> listFabShare = new List<Reticle__Share>();
        
        List<Reticle__c> listReticle = [SELECT Id, Account__c, FabStr__c, Reticle_workflow_Status__c, Witness_Arrival_Date__c, ROS_Status__c,HS_Code__c ,Item__c,HS_Code_Assigned__c  
                                        FROM Reticle__c WHERE Id IN: newMap.keySet()];
        List<Group> groupList = [SELECT Id, Name, Type FROM Group 
                                 WHERE (Name LIKE '%PI/YE ROS%' OR Name LIKE 'ROS Trade Compliance%') AND Type = 'Queue'];
        Map<String,Group> groupMap = new Map<String,Group>();
        if(groupList != null){
            for(Group gr: groupList){
                groupMap.put(gr.Name, gr);
            }
        }
        
        if(triggerContext == 'After Update' && oldMap.size() > 0 && listReticle != null) {
            /*List<Reticle__Share> listRetShare = [SELECT Id,UserOrGroupId,ParentId,RowCause 
                                                 FROM Reticle__Share WHERE ParentId in :listReticle 
                                                 AND (RowCause  = 'Sharing_Reticles_with_PIYE_Team__c' OR RowCause  = 'Sharing_with_CE__c')];
            
            Map<Id,Set<String>> mapPiyeRets = new Map<Id,Set<String>>();
            Map<Id,Set<String>> mapCERets = new Map<Id,Set<String>>();
            Set<String> piyeSet = new Set<String>();
            Set<String> ceSet = new Set<String>();
            String check = '';
            for(Reticle__Share rets : listRetShare){
                if(rets.RowCause == 'Sharing_Reticles_with_PIYE_Team__c'){
                    if((String)rets.ParentId == check){
                        piyeSet.add(rets.UserOrGroupId);                  
                    } else {
                        piyeSet.clear();
                        piyeSet.add(rets.UserOrGroupId);
                    }
                } else if(rets.RowCause == 'Sharing_with_CE__c'){
                    if((String)rets.ParentId == check){
                        ceSet.add(rets.UserOrGroupId);                  
                    } else {
                        ceSet.clear();
                        ceSet.add(rets.UserOrGroupId);
                    }                
                }
                check = (String)rets.ParentId;
                mapPiyeRets.put(rets.ParentId, piyeSet);
                mapCERets.put(rets.ParentId, ceSet);
            }*/
            
            //Sharing with PI/YE
            for(Reticle__c ret : listReticle){
            /*
                Integer shareCount = 0;
                if(ret.Fab_Reticle__r.size() > 0){
                    for(Fab_Reticle__c fabRet : ret.Fab_Reticle__r){
                        if(fabRet.FAB__r.Name == 'FAB 2' || fabRet.FAB__r.Name == 'FAB 3' || fabRet.FAB__r.Name == 'FAB 5' || fabRet.FAB__r.Name == 'FAB 6'){
                            isSharingFabs = true;
                        }
                        if(shareCount == 0 && isSharingFabs){
                            String key1 = 'PI/YE ROS '+ 'FAB 2' +' Team';
                            Id groupId1 = groupMap.containsKey(key1) == true ? groupMap.get(key1).Id : '';
                            String key2 = 'PI/YE ROS '+ 'FAB 3' +' Team';
                            Id groupId2 = groupMap.containsKey(key2) == true ? groupMap.get(key2).Id : '';
                            String key3 = 'PI/YE ROS '+ 'FAB 5' +' Team';
                            Id groupId3 = groupMap.containsKey(key3) == true ? groupMap.get(key3).Id : '';
                            String key4 = 'PI/YE ROS '+ 'FAB 6' +' Team';
                            Id groupId4 = groupMap.containsKey(key4) == true ? groupMap.get(key4).Id : '';
                            
                            Set<Id> groupIdset = new Set<Id>{groupId1,groupId2,groupId3,groupId4};
                            listFabShare.addAll(piyeSharingfab(ret.Id,groupIdset,'Edit',Schema.Reticle__Share.RowCause.Sharing_Reticles_with_PIYE_Team__c));
                            shareCount++;
                        }
                        if(!isSharingFabs){
                            String key = 'PI/YE ROS '+ fabRet.FAB__r.Name +' Team';
                            Id groupId = groupMap.containsKey(key) == true ? groupMap.get(key).Id : '';
                            if(mapPiyeRets.isEmpty() || (mapPiyeRets.get(ret.Id) == null ? null : !mapPiyeRets.get(ret.Id).contains(groupId))){
                                Reticle__Share retFabShare = new Reticle__Share();
                                retFabShare.ParentId = ret.Id;
                                retFabShare.UserorGroupId = groupId;
                                retFabShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_Reticles_with_PIYE_Team__c;
                                retFabShare.AccessLevel = 'Edit';
                                
                                listFabShare.add(retFabShare);
                            }
                        }
                    }                     
                }*/
                if((ret.Reticle_workflow_Status__c == 'Pending for STF Obsolescence' || ret.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up') && ret.ROS_Status__c == 'Return'
                    && ret.HS_Code_Assigned__c == false){
                    Reticle__Share retcompShare = new Reticle__Share();
                    retcompShare.ParentId = ret.Id;
                    retcompShare.UserorGroupId = groupMap.get('ROS Trade Compliance Team').Id;
                    retcompShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_Trade_Compliance__c;
                    retcompShare.AccessLevel = 'Edit';
                    
                    listFabShare.add(retcompShare);                       
                }
            }
            //Sharing with CE
            Map<Id,Id> acctIdsMap = new Map<Id,Id>();
            for(Reticle__c r : listReticle){
                acctIdsMap.put(r.Id, r.Account__c);
            }
            Map<Id,Account> atpMap = new Map<Id,Account>([SELECT Id, Name, (SELECT Id, Team_Role__c, User__c 
                                                                            FROM Account_Team_Proxy__r 
                                                                            WHERE (Team_Role__c = 'Customer Engineer'
                                                                                   And User__r.IsActive = true)) 
                                                                            FROM Account 
                                                                            WHERE Id in :acctIdsMap.values()]);
            
            for(Reticle__c ret : listReticle){
                if(ret.Reticle_workflow_Status__c == 'Pending Witness Arrival Date' && ret.ROS_Status__c == 'Scrap'){
                    if(atpMap != null && !atpMap.isEmpty()){
                        if(atpMap.get(ret.Account__c) != null && atpMap.get(ret.Account__c).Account_Team_Proxy__r.size()>0){
                            for(Account_Team_Proxy__c atp : atpMap.get(ret.Account__c).Account_Team_Proxy__r){
                                Reticle__Share retCEShare = new Reticle__Share();
                                retCEShare.ParentId = ret.Id;
                                retCEShare.UserorGroupId = atp.User__c;
                                retCEShare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_CE__c;
                                retCEShare.AccessLevel = 'Edit';
                                
                                listFabShare.add(retCEShare);                            
                            }
                        }
          }                    
                }
            }
        }
        if(listFabShare.size()>0){
            insert listFabShare;
        }
    }      
}