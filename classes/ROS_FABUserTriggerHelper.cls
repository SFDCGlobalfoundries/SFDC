/*    
* Author       :   Nikhil Jain
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Helper Class for Trigger:ROS_FABUserTrigger                  
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        NJain           08-Oct-14           Created the Trigger Helper Class
*/

public class ROS_FABUserTriggerHelper{
    
    //++ Before Insert Logic
    public static void FabUserBeforeInsert(List<Fab_User__c> lstFabUsersNew){
        Set<Id> SUserIds=new Set<Id>();
        Map<Id,String> MFabIds=new Map<Id,String>();
        for(Fab_User__c temp: lstFabUsersNew){
            SUserIds.add(temp.User__c);
            MFabIds.put(temp.id,temp.Fab__r.Name);
        }
        Map<Id,User> MUsers=new Map<Id,User>([Select Id,Fab_Assigned__c from User where Id in :SUserIds]);
        for(Fab_User__c temp: lstFabUsersNew){
            if(MUsers.get(temp.User__c).Fab_Assigned__c==null){
                temp.addError('This User is not allowed on this Fab');
            }
        }
    }    
    //-- Before Insert Logic
    
    //++ After Insert Logic
    public static void FabUserAfterInsert(List<Fab_User__c> lstFabUsersNew){
        
        //++ Prepare data for Insertion of users in ROS Fab Groups
        prepareData(lstFabUsersNew);
        //-- Prepare data for Insertion of users in ROS Fab Groups
        
        //++ Preparing User data that needs to be added to the Litho Group for granting Account Access
        String lithoGroupId;
        List<Group> lithoGroup = [SELECT id FROM Group WHERE Name='Litho Group' limit 1];
        if(lithoGroup != NULL && !lithoGroup.isEmpty()){            
            if(String.valueOf(lithoGroup[0].id).length()>15){
               lithoGroupId = String.valueOf(lithoGroup[0].id).subString(0,15);
            }else{
               lithoGroupId = lithoGroup[0].id;
            }
            system.debug('####lithoGroupId####'+lithoGroupId);
        }
        //-- Preparing User data that needs to be added to the Litho Group for granting Account Access
        
        //Making a future call for inserting Group Members
        if(!setUsers.isEmpty()){
            InsertLithoMember(lithoGroupId,setUsers,mapUserGroupMembers);
        }
    }
    
    // Method to insert the following:    
    // 1. New Fab User as a Litho Group member to get the Account Read Access
    // 2. Fab Users as a ROS Group Members as per the Fab to grant Reticle Access
    @future
    public static void InsertLithoMember(String lithoGroupId, Set<Id> setUsers,Map<String,Id> mapUserGroupMembers){
        List<GroupMember> lstMembers = new List<GroupMember>();
        
        //Group Members for Litho Group to be added
        for(Id userId: setUsers){
            GroupMember gm = new GroupMember();
            gm.UserOrGroupId  = userId;
            gm.GroupId        = Id.valueOf(lithoGroupId);
            lstMembers.add(gm);
        }
        
        //Group Members for ROS Fab Groups
        for(String userId: mapUserGroupMembers.keySet()){
            GroupMember gm = new GroupMember();
            gm.UserOrGroupId  = userId.subString(0,15);
            gm.GroupId        = mapUserGroupMembers.get(userId);
            lstMembers.add(gm);
        }
        
        if(!Test.isRunningTest()){
            if(!lstMembers.isEmpty()){
                insert lstMembers;
            }
        }
    }
    //-- After Insert Logic
    
    
    //++ After Delete Logic
    public static void FabUserAfterDelete(List<Fab_User__c> lstFabUsersOld){
        Set<Id> fabSet = new Set<Id>();
        Set<Id> SUserIds=new Set<Id>();
        Set<String> fabNameSet = new Set<String>();
        
        for(Fab_User__c temp: lstFabUsersOld){
            system.debug('###Before Update###'+temp.is_ROS_User__c + '###' + temp.Id);
            if(temp.Is_ROS_User__c){
                SUserIds.add(temp.User__c);
                fabSet.Add(temp.Fab__c);
            }
        }
        
        //++ Prepare data for Deletion of users in ROS Fab Groups
        prepareData(lstFabUsersOld);
        //-- Prepare data for Deletion of users in ROS Fab Groups
        
        //Deleting the user from Litho Group if the User(currently deleted) doesn't exist in any of the Fabs
        Set<Id> setAvailableFabUsers = new Set<Id>();
        Set<Id> setUserToRemoveAsLitho = new Set<Id>();
        for(Fab_User__c fabUser: [select id,User__c from Fab_User__c where User__c in :SUserIds and Is_ROS_User__c = True]){
            setAvailableFabUsers.add(fabUser.User__c);
        }
        for(Id userId : SUserIds){
            if(!setAvailableFabUsers.contains(userId)){
                setUserToRemoveAsLitho.add(userId);
            }
        }
        
        if(!setUserToRemoveAsLitho.isEmpty() || !mapUserGroupMembers.isEmpty()){
            RemoveLithoMember(setUserToRemoveAsLitho,mapUserGroupMembers);
        }
    }
    
    // Method to delete the following:    
    // 1. New Fab Users as a Litho Group member to remove the Account Read Access
    // 2. Fab Users as a ROS Group Members as per the Fab to remove Reticle Access
    @future
    public static void RemoveLithoMember(Set<Id> setUserToRemoveAsLitho,Map<String,Id> mapUserGroupMembers){
        List<GroupMember> lstMembers = new List<GroupMember>();
        
        //Querying users to remove user from Litho Group
        if(!setUserToRemoveAsLitho.isEmpty()){
            lstMembers.addAll([SELECT Id from GroupMember 
                                WHERE Group.Name ='Litho Group'
                                  AND UserOrGroupId in :(setUserToRemoveAsLitho)]);
        }
        
        //Preparing Group Members for ROS Fab Groups to be removed
        if(!mapUserGroupMembers.isEmpty()){
            List<GroupMember> lstAllGroupMember = [select id,UserOrGroupId,GroupId  from GroupMember 
                                                    where Group.Name like 'ROS Fab%' and Group.Type= 'Regular'];
            Map<String,GroupMember> mapGroupIds = new Map<String,GroupMember>();
            for(GroupMember gm: lstAllGroupMember){
                 mapGroupIds.put(gm.UserOrGroupId+';'+gm.GroupId,gm);
            }
            system.debug('######mapGroupIds##New###'        +mapGroupIds);
            system.debug('######mapUserGroupMembers##New###'+mapUserGroupMembers);
            for(String userId: mapUserGroupMembers.keySet()){
                if(mapGroupIds.get(userId.split(';')[0]+';'+mapUserGroupMembers.get(userId)) != NULL){
                    lstMembers.add(mapGroupIds.get(userId.split(';')[0]+';'+mapUserGroupMembers.get(userId)));
                }
            }
        }
        
        system.debug('######lstMembers####'+lstMembers);
        if(!Test.isRunningTest()){
            if(lstMembers != NULL && !lstMembers.isEmpty()){
                delete lstMembers;
            }
        }
    }
    //-- After Delete Logic
    
    
    //++ Before Update Logic
    public static void FabUserAfterUpdate(List<Fab_User__c> lstFabUsersUpdated, Map<Id,Fab_User__c> mapFabUserOldMap){
        
        List<Fab_User__c> lstNewROSfabUser = new List<Fab_User__c>();
        List<Fab_User__c> lstOldROSfabUser = new List<Fab_User__c>();
            
        for(Fab_User__c fabUser: lstFabUsersUpdated){
            if(fabUser.User__c != mapFabUserOldMap.get(fabUser.Id).User__c){
                fabUser.addError('The User cannot be edited on the Fab User record. Please create a new fab user and delete this one.');
            }
            
            //Remove or Grant Access based on Is_ROS_User flag update
            if(fabUser.Is_ROS_User__c == True && mapFabUserOldMap.get(fabUser.Id).Is_ROS_User__c == False){
                lstNewROSfabUser.add(fabUser);
            }else if(fabUser.Is_ROS_User__c == False && mapFabUserOldMap.get(fabUser.Id).Is_ROS_User__c == True){
                lstOldROSfabUser.add(fabUser);
            }
        }
        if(lstNewROSfabUser != NULL && !lstNewROSfabUser.IsEmpty()){
            system.debug('####Users to Grant Access for Reticles:####'+lstNewROSfabUser);
            FabUserAfterInsert(lstNewROSfabUser);
        }
        
        if(lstOldROSfabUser != NULL && !lstOldROSfabUser.IsEmpty()){
            //FabUserAfterDelete(lstOldROSfabUser);
            system.debug('####Users to Revoke Access for Reticles:####'+lstOldROSfabUser);
            Map<String,List<Id>> mapFabAndUsers= new Map<String,List<Id>>();
            for(Fab_User__c temp: lstOldROSfabUser){
                setUsers.add(temp.User__c);
                if(!mapFabAndUsers.containsKey(temp.Fab__c)){
                    mapFabAndUsers.put(temp.Fab__c,new List<Id>());
                }
                mapFabAndUsers.get(temp.Fab__c).add(temp.User__c);
            }
            genericData();
            for(String fabId: mapFabAndUsers.keySet()){
                for(Id UserId: mapFabAndUsers.get(fabId)){
                    mapUserGroupMembers.put(userId+';'+fabId,mapFabIdGroupId.get(fabId));
                }
            }
            
            //Deleting the user from Litho Group if the User(currently deleted) doesn't exist in any of the Fabs
            Set<Id> setAvailableFabUsers = new Set<Id>();
            Set<Id> setUserToRemoveAsLitho = new Set<Id>();
            for(Fab_User__c fabUser: [select id,User__c from Fab_User__c where User__c in :setUsers and Is_ROS_User__c = True]){
                setAvailableFabUsers.add(fabUser.User__c);
            }
            system.debug('####setUsers :####'+setUsers );
            system.debug('####setAvailableFabUsers:####'+setAvailableFabUsers);
            if(setAvailableFabUsers == NULL || setAvailableFabUsers.isEmpty()){
                setUserToRemoveAsLitho.addAll(setUsers);
            }else{
                for(Id userId : setUsers){
                    if(!setAvailableFabUsers.contains(userId)){
                        setUserToRemoveAsLitho.add(userId);
                    }
                }
            }
            if(!setUserToRemoveAsLitho.isEmpty() || !mapUserGroupMembers.isEmpty()){
                RemoveLithoMember(setUserToRemoveAsLitho,mapUserGroupMembers);
            }
        }
    }
    //-- Before Update Logic
    
    
    public static Set<Id> setUsers               = new Set<Id>();
    public static Map<String,Id> mapFabs         = new Map<String, Id>();
    public static Map<Id, Id>    mapFabIdGroupId = new Map<Id,Id>();
    public static Map<String,Id> mapUserGroupMembers = new Map<String,Id>();

    //++ Method for preparing Data for Group Members that needs to added/deleted
    public static void prepareData(List<Fab_User__c> lstFabUsers){
    
        Map<String,List<Id>> mapFabAndUsers= new Map<String,List<Id>>();
        for(Fab_User__c temp: lstFabUsers){
            system.debug('###Before Update Prepare Data ###'+temp.is_ROS_User__c + '###' + temp.Id);
            if(temp.Is_ROS_User__c){
                setUsers.add(temp.User__c);
                if(!mapFabAndUsers.containsKey(temp.Fab__c)){
                    mapFabAndUsers.put(temp.Fab__c,new List<Id>());
                }
                mapFabAndUsers.get(temp.Fab__c).add(temp.User__c);
            }
        }
        
        genericData();
        
        for(String fabId: mapFabAndUsers.keySet()){
            for(Id UserId: mapFabAndUsers.get(fabId)){
                mapUserGroupMembers.put(userId+';'+fabId,mapFabIdGroupId.get(fabId));
            }
        }
        
        system.debug('###mapFabs###' + mapFabs);
        system.debug('###mapFabIdGroupId###' + mapFabIdGroupId);
        system.debug('###mapUserGroupMembers###' + mapUserGroupMembers);
    }
    
    public static void genericData(){
        for(Fab__c fabRec: [select id,name from Fab__c]){
            mapFabs.put(fabRec.Name,fabRec.Id);
        }
        
        for(Group g: [select id,Name from Group where Type= 'Regular' and Name like 'ROS Fab%']){
            if(g.Name.containsIgnoreCase('FAB 1')){
                mapFabIdGroupId.put(mapFabs.get('FAB 1'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 2')){
                mapFabIdGroupId.put(mapFabs.get('FAB 2'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 35')){
                mapFabIdGroupId.put(mapFabs.get('FAB 35'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 3E')){
                mapFabIdGroupId.put(mapFabs.get('FAB 3E'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 3') && !g.Name.containsIgnoreCase('FAB 3E') && !g.Name.containsIgnoreCase('FAB 35')){
                mapFabIdGroupId.put(mapFabs.get('FAB 3'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 5')){
                mapFabIdGroupId.put(mapFabs.get('FAB 5'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 6')){
                mapFabIdGroupId.put(mapFabs.get('FAB 6'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 7')){
                mapFabIdGroupId.put(mapFabs.get('FAB 7'),g.Id);
            }else if(g.Name.containsIgnoreCase('FAB 8')){
                mapFabIdGroupId.put(mapFabs.get('FAB 8'),g.Id);
            }
        }
    }
}