/* 
 * This class is Utility class for ROS Project
 * Change History
     Njain   07-Jul-2014     Commenting 6 month logic for computing ROS Cycle for case #28528
     Njain   24-Jul-2014     Changed the logic for fetching the ROS Cycle in getCurrentROSCycle method
     DBiswal 06152015        Usertypes PI/YE and trade compliance added.
*/

public without sharing class ROS_Util {
    
    public static void insertException(Exception ex, String source, String project){
        Error_Log__c errObj     = new Error_Log__c();
        errObj.LineNumber__c    = ex.getLineNumber();
        errObj.Message__c       = ex.getMessage();
        errObj.Source__c        = source;
        errObj.Project__c       = project;
        errObj.Type_Name__c     = ex.getTypeName();
        insert errObj;
    }

    public static String getCurrentROSCycle() {
        String retVal = '';
        
        Date todaysDate = date.today();         
        String currentYear = String.valueof(todaysDate.year());
        Integer currentmonth = todaysDate.month();
        
        String cycle;
        List<ROS_cycle__c> lstROScycle = new List<ROS_cycle__c>();
        lstROScycle = [SELECT id,name 
                        FROM ROS_cycle__c                         
                        WHERE 
                            Cycle_Start_Date__c <= TODAY and
                            (Cycle_End_Date__c   >= TODAY OR Cycle_End_Date__c = NULL)
                       LIMIT 1];
                    
        if(!lstROScycle.isEmpty()){
            cycle = lstROScycle[0].name;
        }
        /*if(currentmonth > 6) {
            cycle = '2';
        } else if(currentmonth<=6) {
            cycle = '1';
        }
        cycle = '1';
        retVal = cycle + 'H' + currentYear.substring(2,4);
        return retVal;
        */
        return cycle;
    }
    
    public static Set<String> getUserReticles(Id userId) {
        Set<String> sRetVal = new Set<String>();
        String rosCycle = ROS_Util.getCurrentROSCycle();
        SYSTEM.DEBUG('ROS CYCLE : ' + rosCycle);

        List<Group> lGroup = [ SELECT Id 
                               FROM Group 
                               WHERE Type ='Queue' 
                                   AND Name='WWMS ROS Team' LIMIT 1 ];                         
        Id groupId;
        if (lGroup != null && !lGroup.isEmpty()) {
            groupId = lGroup.get(0).Id;
        }
        SYSTEM.DEBUG('GROUP ID : ' + groupId);
        List<GroupMember> lGroupUser = [ SELECT Id
                                              , GroupId
                                              , UserOrGroupId 
                                         FROM GroupMember 
                                         WHERE GroupId = :groupId ];

        if (rosCycle != null) {
            List<Reticle__Share> lReticleShare = [ SELECT parentId
                                                        , userOrGroupId
                                                        , Parent.Name
                                                        , Parent.Account__r.Name
                                                        , Parent.Account__c
                                                   FROM Reticle__Share
                                                   WHERE Parent.ROS_Cycle__r.Name = :rosCycle
                                                       AND (UserOrGroupId = :userId
                                                               OR UserOrGroupId = :groupId)
                                                       AND (Parent.Reticle_workflow_Status__c = 'Shipped Out'
                                                               OR Parent.Reticle_workflow_Status__c = 'Closed')
                                                       AND Parent.isFinalNotified__c = false ];

           SYSTEM.DEBUG('RETICLE SHARE LENGTH : ' + lReticleShare.size());
           for(Reticle__Share eachReticleShare :lReticleShare) {
               sRetVal.add(eachReticleShare.parentId);
           }
           SYSTEM.DEBUG('RETICLE LIST LENGTH : ' + sRetVal.size());
        }
        
        return sRetVal;
    }

    public static void sendNotification(String templateId, Id targetObjectId) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        SYSTEM.DEBUG('SEND NOTIFICTION TEMPLATE NAME : ' + templateId);
        SYSTEM.DEBUG('SEND NOTIFICTION TARGET OBJECT : ' + targetObjectId);
        
        if (targetObjectId != null) {
            message.setTargetObjectId(targetObjectId);
            message.setSaveAsActivity(false);
        } else {
            // THROW CUSTOM EXCEPTION FOR NO TO ADDRESS.
        }

        if (templateId != null && templateId.length() > 0) {
            message.setTemplateId(templateId);
        } else {
            // THROW EXCEPTION FOR TEMPLATE
        }
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});
    }
    
    /*
    Method to remove edit access on reticle record based on parameters
    */
    public static List<Reticle__Share> updateReticleAccess(Set<String> sReticle, String sharingReason, String recordAccess) {
        List<Reticle__Share> retVal = [ SELECT Id
                                               FROM Reticle__Share
                                               WHERE ParentId IN :sReticle
                                                   AND RowCause = :sharingReason ];

        if (retVal != null && !retVal.isEmpty() && recordAccess != null) {
            for (Reticle__Share reticleShare :retVal) {
                reticleShare.AccessLevel = recordAccess;
            }
        }
        
        return retVal;
    }
    
    public static string UserType() {
        String UserType = 'None';
        List<Account_Team_Proxy__C> ATP = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__C> ATP1 = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__C> ATP2 = new List<Account_Team_Proxy__c>();
        ATP = [ Select Id,Team_Role__c 
                from Account_Team_Proxy__c 
                where User__c =: UserInfo.getUserId() 
                    and (  Team_Role__c='Customer Service Rep' 
                        OR Team_Role__c='Primary Customer Service Rep' 
                        OR Team_Role__c='Backup Customer Service Rep')];
        
        ATP1 = [SELECT Id,Team_Role__c 
                FROM Account_Team_Proxy__c 
                WHERE User__c =: UserInfo.getUserId() 
                    AND (  Team_Role__c = 'Primary Field Application Engineer' 
                        OR Team_Role__c = 'Field Application Engineer'
                        OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                        OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE))];
                        
        ATP2 = [Select Id,Team_Role__c 
                from Account_Team_Proxy__c 
                where User__c =: UserInfo.getUserId() 
                    and (Team_Role__c='Customer Engineer')]; 
        
        if(!ATP.IsEmpty()||!ATP1.IsEmpty()||!ATP2.IsEmpty() ){            
               if(!ATP1.IsEmpty())
               {  
                 UserType = 'FAE';
               }
               else if(!ATP2.IsEmpty())
               {
                   UserType = 'CE';
               }  
               else if(!ATP.IsEmpty())
               {
                   UserType = 'CSR';
               }            
        } else {
            List<Fab_User__c> LFabUsers = new List<Fab_User__c>([Select Id from Fab_User__c where User__c=:UserInfo.getUserId() and Is_ROS_User__c =: true]);
            if(!LFabUsers.IsEmpty()){
                UserType = 'FAB';
            } 
            else {
                     //DBiswal
                     List<GroupMember> GM1 = [Select Id from GroupMember where Group.Name = 'WWMS ROS Team' and Group.Type = 'Queue' and UserOrGroupId = :UserInfo.getUserId()];
                     if(!GM1.IsEmpty()){
                           UserType = 'Solution Team';
                     }
                     
                     //DBiswal 06152015 - Added code for PI/YE usertypes
                     List<GroupMember> GMList = [SELECT Id, Group.Name FROM GroupMember WHERE (Group.Name LIKE '%PI/YE ROS FAB%' OR Group.Name = 'ROS Trade Compliance Team') AND Group.Type = 'Queue' AND UserOrGroupId = :UserInfo.getUserId()];
                     if(!GMList.IsEmpty()) {
                         for(GroupMember gm : GMList) {
                             if(gm.Group.Name == 'ROS Trade Compliance Team'){
                                 UserType = 'Trade Comp';
                             } else{
                                 UserType = 'PI/YE Team';
                             }
                         }
                     }                     
                     
                     else {
                         List<User> usersL = [Select Id,Name,Profile.Name,UserType from User where Id =: UserInfo.getUserId()];
                         System.Debug('>>>>>>>>>>>>>>>>>>>>>> : '+usersL);
                         if(!usersL.IsEmpty()){
                             if(usersL[0].Profile.Name == 'System Administrator'){
                                  UserType = 'System Administrator';   
                             }else if(   usersL[0].Profile.Name == 'Customer Portal User' 
                                    || usersL[0].Profile.Name == 'Customer Portal Manager'
                                    || usersL[0].Profile.Name == 'Customer Portal Manager - GF'
                                    || usersL[0].Profile.Name == 'Customer Portal Manager Custom'                                    
                                    || usersL[0].Profile.Name == 'Customer Portal User - GF'
                                    
                                    || usersL[0].Profile.Name == 'Customer Portal Admin'
                                    || usersL[0].Profile.Name == 'Customer Portal Profile'
                                    || usersL[0].Profile.Name == 'Enablement Partner Portal Admin'
                                    || usersL[0].Profile.Name == 'Enablement Partner Portal Profile'
                                    || usersL[0].Profile.Name == 'Reseller Portal Admin'
                                    || usersL[0].Profile.Name == 'Reseller Portal Profile'
                                    || usersL[0].Profile.Name == 'Supplier Portal Admin'
                                    || usersL[0].Profile.Name == 'Supplier Portal Profile'
                                    || usersL[0].Profile.Name == 'Overage Customer Portal Admin'
                                    || usersL[0].Profile.Name == 'Overage Customer Portal Profile'
                                    || usersL[0].Profile.Name == 'Overage Enablement Partner Portal Admin'
                                    || usersL[0].Profile.Name == 'Overage Enablement Partner Portal Profile'
                                    || usersL[0].Profile.Name == 'Overage Reseller Portal Admin'
                                    || usersL[0].Profile.Name == 'Overage Reseller Portal Profile'
                                    || usersL[0].Profile.Name == 'Overage Supplier Portal Admin'
                                    || usersL[0].Profile.Name == 'Overage Supplier Portal Profile'                                    
                                  ){
                                      UserType = 'Customer'; 
                                  }
                                  else if(usersL[0].Profile.Name =='GF FAE/FTS')
                                  {
                                    UserType = 'FAE';
                                  }
                                  else if(usersL[0].Profile.Name =='GF CE')
                                  {
                                    UserType = 'CE';
                                  }
                                  
                             
                         }
                     
                     }
                 }
        }
         return UserType ;   
    }
    
}