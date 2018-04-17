/*
Class Name:    AATReq_TriggerHelper 
Author:        Ravi Teja.B
Description:   This Class manages Approval process and Comments for AAT Request.
History: 
Ravi Teja.B           12092017x     - Code Create.
*/
public class AATReq_TriggerHelper{
    Public Map<Id,AAT_Request__c> triggerOldMap;
    Public Map<Id,AAT_Request__c> triggerNewMap;
    Public List<AAT_Request__c> triggerNewList;
    public AATReq_TriggerHelper(){
        triggerOldMap = (Map<Id,AAT_Request__c>) trigger.oldMap;
        triggerNewList = (List<AAT_Request__c>) trigger.new;
        triggerNewMap = (Map<Id,AAT_Request__c>) trigger.newMap;
    }
    public void submitForApproval(){
        List<AAT_Request__c> aatSubmitValuesList = new List<AAT_Request__c>();
        List<AAT_Request__c> aatReSubmitValuesList = new List<AAT_Request__c>();
        if(!triggerNewList.isEmpty()){
            for(AAT_Request__c aat: triggerNewList){
                if(Trigger.IsUpdate){
                    if((aat.Next_AAT_Meeting__c != null && aat.Ready_for_CIA_Technical_Approval__c && !triggerOldMap.get(aat.Id).Ready_for_CIA_Technical_Approval__c) || (aat.Next_AAT_Meeting__c != null && aat.Next_AAT_Meeting__c != triggerOldMap.get(aat.Id).Next_AAT_Meeting__c)){
                        if(aat.Stage__c != 'Under Review'){
                            aatSubmitValuesList.add(aat);
                        }
                        else{
                            aatReSubmitValuesList.add(aat);
                        }
                    }
                }
                else if(Trigger.IsInsert && aat.Next_AAT_Meeting__c != null && aat.Ready_for_CIA_Technical_Approval__c)
                    aatSubmitValuesList.add(aat); 
            }
        }
        Map<Id,Id> aatWorkItemIdMap = new Map<Id,Id>();
        for(ProcessInstanceWorkitem piw : [SELECT Id,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem
        WHERE     ProcessInstance.TargetObjectId in: aatReSubmitValuesList
        AND       ProcessInstance.Status = 'Pending']){
        aatWorkItemIdMap.put(piw.ProcessInstance.TargetObjectId,piw.Id);                                         
        
        }
        for(AAT_Request__c aat: aatSubmitValuesList){
            Approval.ProcessSubmitRequest oRequest = new Approval.ProcessSubmitRequest();
            oRequest.setObjectId(aat.Id);
            Approval.ProcessResult oResult = Approval.process(oRequest);
        }
        for(AAT_Request__c aat: aatReSubmitValuesList){
            if(aatWorkItemIdMap.containsKey(aat.Id)){
            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setComments('Next Meeting Date has been changed');
            pwr.setAction('Removed');
            pwr.setWorkitemId(aatWorkItemIdMap.get(aat.Id));        
            Approval.ProcessResult result =  Approval.process(pwr);

            Approval.ProcessSubmitRequest oRequest = new Approval.ProcessSubmitRequest();
            oRequest.setObjectId(aat.Id);
            Approval.ProcessResult oResult = Approval.process(oRequest);
            }
        }   
    }
    public void commentsHandler(){
        if(!triggerNewList.isEmpty()){
            for(AAT_Request__c aat: triggerNewList){
                if(aat.Next_AAT_Meeting__c != null){
                    if(aat.Meeting_Span__c.contains('min')){
                        aat.Next_AAT_Meeting_End__c = aat.Next_AAT_Meeting__c.addMinutes(integer.valueof(aat.Meeting_Span__c.split('min')[0].trim()));
                    }
                }
                string ciaComment = aat.AAT_CIA_Team_Meeting_Minutes__c != null ? aat.AAT_CIA_Team_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                string ciaCommentOld = triggerOldMap.get(aat.Id).AAT_CIA_Team_Meeting_Minutes__c != null ? triggerOldMap.get(aat.Id).AAT_CIA_Team_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                string techComment = aat.AAT_Technical_Team_Meeting_Minutes__c != null ? aat.AAT_Technical_Team_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                string techCommentOld = triggerOldMap.get(aat.Id).AAT_Technical_Team_Meeting_Minutes__c != null ? triggerOldMap.get(aat.Id).AAT_Technical_Team_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                string PDTComment = aat.PDT_Meeting_Minutes__c != null ? aat.PDT_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                string PDTCommentOld = triggerOldMap.get(aat.Id).PDT_Meeting_Minutes__c != null ? triggerOldMap.get(aat.Id).PDT_Meeting_Minutes__c.stripHtmlTags().remove(' ') : null;
                if((aat.AAT_CIA_Team_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).AAT_CIA_Team_Meeting_Minutes__c == null) || (aat.AAT_CIA_Team_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).AAT_CIA_Team_Meeting_Minutes__c != null && ciaComment != ciaCommentOld)){
                    aat.AAT_CIA_Team_Meeting_Minutes__c = 'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aat.AAT_CIA_Team_Meeting_Minutes__c;
                }
                if((aat.AAT_Technical_Team_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).AAT_Technical_Team_Meeting_Minutes__c == null) || (aat.AAT_Technical_Team_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).AAT_Technical_Team_Meeting_Minutes__c != null && techComment != techCommentOld)){
                    aat.AAT_Technical_Team_Meeting_Minutes__c = 'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aat.AAT_Technical_Team_Meeting_Minutes__c;
                }
                if((aat.PDT_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).PDT_Meeting_Minutes__c == null) || (aat.PDT_Meeting_Minutes__c != null && triggerOldMap.get(aat.Id).PDT_Meeting_Minutes__c != null && PDTComment != PDTCommentOld)){
                    aat.PDT_Meeting_Minutes__c = 'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aat.PDT_Meeting_Minutes__c;
                }
                if(aat.Next_AAT_Meeting__c != triggerOldMap.get(aat.Id).Next_AAT_Meeting__c){
                    aat.Previous_AAT_Meeting__c = triggerOldMap.get(aat.Id).Next_AAT_Meeting__c;
                    aat.Previous_AAT_Meeting_End__c = triggerOldMap.get(aat.Id).Next_AAT_Meeting_End__c;
                } 
            }
        }
    }
    public void AATTechCIAEvaluation(){
        Set<Id> aatIdsToReSubmit = new Set<Id>();
        if(!triggerNewMap.isEmpty()){
            for(AAT_Request__c aat: triggerNewMap.values()){
                if((aat.Stage__c != triggerOldMap.get(aat.Id).Stage__c && aat.Stage__c == 'Approved') ||(aat.Evaluate_Technical_CIA__c && !triggerOldMap.get(aat.Id).Evaluate_Technical_CIA__c) || (aat.PDT_Queue_Update__c && !triggerOldMap.get(aat.Id).PDT_Queue_Update__c)){
                    aatIdsToReSubmit.add(aat.Id);
                }
            }
            if(!aatIdsToReSubmit.isEmpty())
                updateComments(aatIdsToReSubmit);
        }
    }
    @future
    public static void updateComments(Set<Id> aatIds){
        system.debug('list==>'+aatIds);
        Map<Id,String> aatIdCIACommentMap = new Map<Id,String>();
        Map<Id,String> aatIdTechCommentMap = new Map<Id,String>();
        Map<Id,String> aatIdPDTCommentMap = new Map<Id,String>();
        Map<Id,AAT_Request__c> aatReqMap =  new Map<Id,AAT_Request__c>([Select Id,AAT_CIA_Team_Meeting_Minutes__c,AAT_Technical_Team_Meeting_Minutes__c,
                                                                        PDT_Meeting_Minutes__c, Is_CIA_Approved__c, Is_Technical_Approved__c, Is_PDT_Approved__c,
                                                                        RequestTechnology__c from AAT_Request__c where Id in: aatIds]);
        if(!aatReqMap.isEmpty()){
            for(ProcessInstanceStep pi: [SELECT Actor.userRole.Name, OriginalActor.Name, OriginalActor.Title, StepStatus, comments,
                                         ProcessInstance.CompletedDate, ElapsedTimeInDays, ElapsedTimeInHours, ElapsedTimeInMinutes, ProcessInstance.TargetObjectId
                                         FROM ProcessInstanceStep where ProcessInstance.TargetObjectId in: aatReqMap.keySet()
                                         and stepStatus='Approved']){
                                             system.debug('pi.OriginalActor.Name===>'+pi.OriginalActor.Name);
                                             if(pi.OriginalActor.Name == 'AAT CIA Team' && !aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_CIA_Approved__c){
                                                 aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_CIA_Approved__c = true;
                                                 aatIdCIACommentMap.put(pi.ProcessInstance.TargetObjectId,pi.Comments);
                                             }
                                             if(pi.OriginalActor.Name == 'AAT Technical Team' && !aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_Technical_Approved__c){
                                                 aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_Technical_Approved__c = true;
                                                 aatIdTechCommentMap.put(pi.ProcessInstance.TargetObjectId,pi.Comments);
                                             }
                                             if(pi.OriginalActor.Name != 'AAT Technical Team' && pi.OriginalActor.Name != 'AAT CIA Team' && pi.OriginalActor.Name == aatReqMap.get(pi.ProcessInstance.TargetObjectId).RequestTechnology__c && !aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_PDT_Approved__c){
                                                 aatReqMap.get(pi.ProcessInstance.TargetObjectId).Is_PDT_Approved__c = true;
                                                 aatIdPDTCommentMap.put(pi.ProcessInstance.TargetObjectId,pi.Comments);
                                             }
                                         }
        }
        system.debug('aatIdCIACommentMap==>'+aatIdCIACommentMap);
        system.debug('aatIdTechCommentMap==>'+aatIdTechCommentMap);
        system.debug('aatIdPDTCommentMap==>'+aatIdPDTCommentMap);
        
        for(AAT_Request__c aat: aatReqMap.values()){
            system.debug('AAT_Technical_Team_Meeting_Minutes__cbefore==>'+aat.AAT_Technical_Team_Meeting_Minutes__c);
            if(aatIdCIACommentMap.containsKey(aat.id) && aat.Is_CIA_Approved__c){
                aat.AAT_CIA_Team_Meeting_Minutes__c = aatIdCIACommentMap.get(aat.id);//'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aatIdCIACommentMap.get(aat.id) + '<br/>' + aat.AAT_CIA_Team_Meeting_Minutes__c;
            }
            if(aatIdTechCommentMap.containsKey(aat.id) && aat.Is_Technical_Approved__c){
                system.debug('aatIdTechCommentMap.get(aat.Id)==>'+aatIdTechCommentMap.get(aat.Id));
                aat.AAT_Technical_Team_Meeting_Minutes__c = aatIdTechCommentMap.get(aat.Id);//'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aatIdTechCommentMap.get(aat.Id) + '<br/>' + aat.AAT_Technical_Team_Meeting_Minutes__c;
            }
            if(aatIdPDTCommentMap.containsKey(aat.id) && aat.Is_PDT_Approved__c){
                aat.PDT_Meeting_Minutes__c = aatIdPDTCommentMap.get(aat.Id); //'Comment Added By '+ UserInfo.getFirstName() +' '+UserInfo.getLastName() + ' ' +system.now() + '<br/>' +aatIdPDTCommentMap.get(aat.Id) + '<br/>' + aat.PDT_Meeting_Minutes__c;
            }
            system.debug('AAT_Technical_Team_Meeting_Minutes__cafter==>'+aat.AAT_Technical_Team_Meeting_Minutes__c);
        }
        try{
            database.update(aatReqMap.values());
        }
        catch(exception e){
            
        }
    }
    public void resubmitApprovalProcess2(){
        Set<Id> aatIds = new Set<Id>();
        for(AAT_Request__c aat: triggerNewMap.values()){
            if(aat.Evaluate_Technical_CIA__c && aat.Is_CIA_Approved__c && !triggerOldMap.get(aat.Id).Is_CIA_Approved__c && !aat.Is_Technical_Approved__c){
                aatIds.add(aat.Id);
            }
            if(aat.Evaluate_Technical_CIA__c && aat.Is_Technical_Approved__c && !triggerOldMap.get(aat.Id).Is_Technical_Approved__c && !aat.Is_CIA_Approved__c){
                aatIds.add(aat.Id);
            }
            
        }
        if(!aatIds.IsEmpty())
            submitInFuture(aatIds);
    }
    @future
    public static void submitInFuture(Set<Id> aatIds){
        Set<Id> aatNotToSubmitIds = new Set<Id>();
        for(ProcessInstanceWorkItem piw : [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId in: aatIds]){
            aatNotToSubmitIds.add(piw.ProcessInstance.TargetObjectId);
        }
        for(Id id: aatIds){
            if(!aatNotToSubmitIds.contains(id)){
                Approval.ProcessSubmitRequest oRequest1 = new Approval.ProcessSubmitRequest();
                oRequest1.setObjectId(id);
                Approval.ProcessResult oResult = Approval.process(oRequest1);
            }
        }
    }
    public void PDTApprovalPopulation(){
        Set<string> pdtEmailSet = new Set<String>();
        Map<String,Id> userEmailUserIdMap = new Map<String,Id>();
        Map<String,Id> techUserIdMap = new Map<String,Id>();
        Map<String,PDT_Approvers__c> pdtCustSet =  PDT_Approvers__c.getAll();
        for(PDT_Approvers__c pdt : pdtCustSet.values()){
            pdtEmailSet.add(pdt.Email__c);
        }
        system.debug('pdtEmailSet==>'+pdtEmailSet);
        for(User u: [Select Id, Email from User where Email in: pdtEmailSet]){
            userEmailUserIdMap.put(u.Email,u.id);
        }
        system.debug('techUserIdMap==>'+techUserIdMap);
        for(PDT_Approvers__c pdt : pdtCustSet.values()){
            if(userEmailUserIdMap.containsKey(pdt.Email__c))
            techUserIdMap.put(pdt.Name,userEmailUserIdMap.get(pdt.Email__c));
        }
        system.debug('techUserIdMap==>'+techUserIdMap);
        for(AAT_Request__c aat: triggerNewList){
            if(trigger.IsInsert || (trigger.isUpdate && aat.RequestTechnology__c != triggerOldMap.get(aat.Id).RequestTechnology__c)){
                if(aat.RequestTechnology__c != null && techUserIdMap.containsKey(aat.RequestTechnology__c))
                    aat.PDT_Approver__c = techUserIdMap.get(aat.RequestTechnology__c);
            }
        }
    }
    public void checkPDTQueueUpdate(){
        Set<Id> aatIds = new Set<Id>();
        for(AAT_Request__c aat: triggerNewList){
            if(aat.PDT_Queue_Update__c && !triggerOldMap.get(aat.Id).PDT_Queue_Update__c){
                aatIds.add(aat.Id);
            }
        }
        if(aatids.size() > 0){
            assignQueue(aatids);
        }
    }
    @future
    public static void assignQueue(Set<Id> aatIds){
        Map<String,String> queueNamesTechMap = new Map<String,String>();
        Map<String,PDT_Approvers__c> pdtCustSet =  PDT_Approvers__c.getAll();
        Map<String,Id> techNameQueueIdMap = new Map<String,Id>();
        
        system.debug('queueNamesTechMap==>'+queueNamesTechMap);
        for(QueueSobject q: [Select QueueId,Queue.Name from QueueSobject where SobjectType = 'AAT_Request__c' and Queue.Name in: pdtCustSet.keySet()]){
            system.debug('==>'+q.Queue.Name);
            if(pdtCustSet.containsKey(q.Queue.Name))
                techNameQueueIdMap.put(q.Queue.Name,q.QueueId);
        }
        system.debug('techNameQueueIdMap==>'+techNameQueueIdMap);
        Map<Id,ProcessInstanceWorkItem> aatIdProcessMap = new Map<Id,ProcessInstanceWorkItem>(); 
        for(ProcessInstanceWorkItem workItem: [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId in: aatIds order by createddate desc limit 1]){
            if(!aatIdProcessMap.containsKey(workItem.ProcessInstance.TargetObjectId))
                aatIdProcessMap.put(workItem.ProcessInstance.TargetObjectId,workItem);
        }
        system.debug('aatIdProcessMap==>'+aatIdProcessMap);
        List<ProcessInstanceWorkItem> processListToUpdate = new List<ProcessInstanceWorkItem>();
        for(AAT_Request__c aat : [Select Id,RequestTechnology__c, PDT_Queue_Update__c from AAT_Request__c where Id in: aatIds]){
            if(techNameQueueIdMap.containsKey(aat.RequestTechnology__c) && aatIdProcessMap.containsKey(aat.Id)){
                ProcessInstanceWorkItem wi = new ProcessInstanceWorkItem(Id = aatIdProcessMap.get(aat.Id).id);
                wi.ActorId = techNameQueueIdMap.get(aat.RequestTechnology__c);
                wi.OriginalActorId = techNameQueueIdMap.get(aat.RequestTechnology__c);
                processListToUpdate.add(wi);
            }
        }
        system.debug('processListToUpdate==>'+processListToUpdate);
        if(!processListToUpdate.isEmpty())
            database.update(processListToUpdate);
    }
}