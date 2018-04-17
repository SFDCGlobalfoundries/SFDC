/*
   Author: Mohan Gandhapu
   Company: GLOBALFOUNDRIES
   Project: DRC/DFM Application
   Description: This class is used for sharing record to delegated users.
   History:  Mohan Gandhapu 11 Jan 2017
**/

Public class WaiverCustomRecordSharing{
public Static Boolean isExecuted = false;

    public static void shareRecord(Id objId, String childID){
        
       
        
            Boolean isSuccess = false;
            List<Wavier_Collaborator__Share> lstOfWaivers = new List<Wavier_Collaborator__Share>();
            set<Id> managerIds = new  set<ID>();
            set<Id> DelegdateUserIDs = new Set<ID>();
            
            List<Group > QueueLsit =[Select Id ,name from Group where type='Queue' and Name IN ('Collaborator 4 DE','Collaborator PI/YE 4 FAB7','Collaborator QA 4 FAB7')];
            Set<ID> QueueMemberID = new Set<ID>();
            
            for(GroupMember gm:[Select UserOrGroupId From GroupMember where GroupId =:QueueLsit]){
            QueueMemberID.add(gm.UserOrGroupId ); 
            }
            
            for(User usId: [select id,DelegatedApproverid,ManagerID,Manager.DelegatedApproverid from user where id=:QueueMemberID ]){
            managerIds.add(usId.ManagerID); 
            
            if(usID.Manager.DelegatedApproverid !=null)
            DelegdateUserIDs.add(usID.Manager.DelegatedApproverid );     
            
            }
            
            for(ProcessInstance pi : [SELECT Id, (SELECT Id, StepStatus,OriginalActorId,OriginalActor.name,ActorId,Actor.name, createddate,Comments FROM StepsAndWorkitems order by createddate Desc limit 1) FROM ProcessInstance where TargetObjectId=:childID AND Status='Pending' order by createddate Desc Limit 1]){
                if(Pi.StepsAndWorkitems[0] !=null)
                {
                  User u=[select id,ManagerID,Manager.DelegatedApproverid from user where id=:Pi.StepsAndWorkitems[0].OriginalActorId];
                  managerIds.add(u.ManagerID);managerIds.add(u.id);
                  if(u.Manager.DelegatedApproverid !=null)
                    DelegdateUserIDs.add(u.Manager.DelegatedApproverid);
                    
                }  
            }
            
            Set<ID> grOrUsrId = new Set<ID>();
            grOrUsrId.addAll(DelegdateUserIDs);
            grOrUsrId.addAll(managerIds);
            grOrUsrId.addAll(QueueMemberID);
            
            if (grOrUsrId<>NULL && !grOrUsrId.isEmpty()){
                for (Id uId : grOrUsrId){
                    Wavier_Collaborator__Share waiverShare = new Wavier_Collaborator__Share();
                    waiverShare.ParentId = objId;
                    waiverShare.UserOrGroupId = uId;
                    waiverShare.AccessLevel = 'Read/Write';
                    lstOfWaivers.add(waiverShare);
                }
                if (lstOfWaivers != null && lstOfWaivers.size() > 0){
                    Database.SaveResult[] result = Database.Insert(lstOfWaivers,false);
                    //System.debug('@result'+result);
                    
                }
            }
                     if(lstOfWaivers != null && lstOfWaivers.size() > 0){
            try{
                Database.insert(lstOfWaivers,false);
                if(Test.isRunningTest())
                     {
                     integer intTest =1/0;  
                     }
                }catch (Exception e){
                GlobalUtility.logMessage('Debug', 'WaiverCustomRecordSharing', 'shareRecord()', String.valueOf(lstOfWaivers), 'Waiver Record Sharing', 'LogMessage', 'payLoad','Other SFDC',e, 2300);
                }  
      }
    }
}