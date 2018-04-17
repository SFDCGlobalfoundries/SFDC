/*
   Author: Mohan Gandhapu
   Company: GLOBALFOUNDRIES
   Project: DRC/DFM Application
   Description: This class is used as a controller for WaiverItemsToApprove
   History:  Mohan Gandhapu 11 Jan 2017
**/

public with sharing class Waiverapprovelist
{
    
    
    Public ProcessInstance PI{Get;set;}
    Public List<ProcessInstance> list1{Get;set;}
    Public List<Waiver_Rule_List__c> WRL{Get;set;}
    public string pid{set;get;}
    public User usr{Get;set;}
    public String userName = UserInfo.getName(); 
    Public Waiverapprovelist(){
        
        
            list1 = New List<ProcessInstance >();
            List<ProcessInstance> list2 = New List<ProcessInstance >();
            for(ProcessInstance PI:[SELECT TargetObjectId,Status ,TargetObject.Name,SubmittedBy.Name,SystemModstamp FROM ProcessInstance where  Status = 'Pending'  Order By SystemModstamp desc]){
                 String sObjName = PI.TargetObjectId.getSObjectType().getDescribe().getName();
                system.debug('test'+sObjName);
                if(sObjName.contains('Wavier_Collaborator__c')) {
                    List2.add(PI); 
            }  
            }
            //system.debug('List2'+List2);
            //List2 = [SELECT TargetObjectId,Status ,TargetObject.Name,SubmittedBy.Name,SystemModstamp FROM ProcessInstance where  Status = 'Pending' AND TargetObject.Name like 'DRC%' Order By SystemModstamp desc];
            //List2 = [SELECT TargetObjectID,TargetObject.Name,SubmittedBy.Name,SystemModstamp FROM ProcessInstance  where TargetObjectID like 'aAL%' AND Status = 'Pending' Order By SystemModstamp desc];
            
            //WRL = New List<Waiver_Rule_List__c>();
            Map<Id,Waiver_Rule_List__c> WRL= new Map<Id,Waiver_Rule_List__c>([Select id, Delegation__c from Waiver_Rule_List__c where Delegation__c = True]);
            usr = New user();
            //Usr = [SELECT Name,DelegatedApproverid from User where Name =:userName];
            List<User> userhasDelegate= [SELECT Name,profile.name from User where  id=:userInfo.getUserID() ];
            List<User> isDelegate = [SELECT Name,DelegatedApproverid from User where  DelegatedApproverid =:userInfo.getUserID()];
            //System.debug('@Log Obj::=>'+userhasDelegate+isDelegate );
            
            set<Id> managerIds = new  set<ID>();
            set<Id> DelegdateUserIDs = new Set<ID>();
            
            List<Group > QueueLsit =[Select Id ,name from Group where type='Queue' and Name IN ('Collaborator 4 DE','Collaborator PI/YE 4 FAB7','Collaborator QA 4 FAB7')];
            Set<ID> QueueMemberID = new Set<ID>();
            
            for(GroupMember gm:[Select UserOrGroupId From GroupMember where GroupId =:QueueLsit]){
                QueueMemberID.add(gm.UserOrGroupId ); 
            }
            for(User usId: [select id,DelegatedApproverid,ManagerID,Manager.DelegatedApproverid from user where id=:QueueMemberID OR ManagerID !=null]){
                managerIds.add(usId.ManagerID); 
                
                if(usID.Manager.DelegatedApproverid !=null)
                    DelegdateUserIDs.add(usID.Manager.DelegatedApproverid );     
                
            }
            
                        
            If((userhasDelegate.size()>0 )  || (isDelegate.size()>0)){
                For(ProcessInstance P :List2)
                { 
                    
                   // system.debug(p);
                    IF(WRL.get(p.TargetObjectId) !=null && WRL.get(p.TargetObjectId).Delegation__c == True && isDelegate.size()>0 && DelegdateUserIDs.contains(userInfo.getUserID()))
                    {
                        List1.Add(P);
                    }
                    if(userhasDelegate.size()>0 &&(userhasDelegate[0].profile.name=='System Administrator') ||managerIds.contains(userInfo.getUserID())|| QueueMemberID.contains(userInfo.getUserID()) ){
                        List1.Add(P);
                    }
                    
                }
            }
            else 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You do not have delegated approver'));
            }
       
    }
    public PageReference confirmCertificationStatement() {
           try{
        // Create an approval request for the Expense Report
        pid = ApexPages.currentPage().getParameters().get('Waiverid');
        System.debug('**********Pid******'+Pid);
        List<ProcessInstanceWorkitem> PIW = [Select id,ProcessInstanceId from ProcessInstanceWorkitem Where ProcessInstanceId =:Pid limit 1];
        if(PIW.size()>0)  {
            PageReference p = new PageReference('/p/process/ProcessInstanceWorkitemWizardStageManager?id='+PIW[0].id);
            p.getParameters().put('nooverride','1');
            return p; 
            
          }
                
        }catch (Exception e) {GlobalUtility.logMessage('Debug', 'Waiverapprovelist', 'confirmCertificationStatement()',String.valueOf(Pid), 'Waiver Approvals ', 'This is Exception', 'payLoad','DRC/DFM',e, 2300); }     
        
        return null;
        
    }
    
}