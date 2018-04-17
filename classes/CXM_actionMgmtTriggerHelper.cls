/*
    Author: DBiswal
    Description: Helper class for actionMgmtTrigger 
    History: 
        DBiswal    04112017    Modified for Escalation team enhancement.
        DBiswal    07252017    Modified for L5 enhancements.
*/
public class CXM_actionMgmtTriggerHelper {
    /*Global Variables*/
    public Map<Id,Escalation_Complaint__c> triggerOldMap{get; set;}
    public Map<Id,Escalation_Complaint__c> triggerNewMap{get; set;}
    
    public CXM_actionMgmtTriggerHelper(){
        triggerOldMap = ((Map<Id,Escalation_Complaint__c>)Trigger.oldMap);
        triggerNewMap = ((Map<Id,Escalation_Complaint__c>)Trigger.newMap);
    }
    
    public void processingMethod(List<Escalation_Complaint__c> actmList){
        Map<String,List<Escalation_Complaint__c>> updatedRecMap = new Map<String,List<Escalation_Complaint__c>>();
        Map<String,List<Escalation_Complaint__c>> notifyEscTeamMap = new Map<String,List<Escalation_Complaint__c>>();
        
        if(trigger.isInsert){
            recordnotification(actmList, 'New');
            for(Escalation_Complaint__c actm : actmList){
                if(actm.Escalation_Level__c != null && (actm.Escalation_Level__c.containsIgnorecase('L2') || actm.Escalation_Level__c.containsIgnorecase('L3') 
                    || actm.Escalation_Level__c.containsIgnorecase('L4'))){
                    if(!notifyEscTeamMap.containsKey(actm.Escalation_Level__c)){
                        notifyEscTeamMap.put(actm.Escalation_Level__c, new List<Escalation_Complaint__c>{actm});
                    } else {
                        notifyEscTeamMap.get(actm.Escalation_Level__c).add(actm);
                    }
                }
            }
        }
        if(trigger.isUpdate){
            for(Escalation_Complaint__c actm : actmList){
                if(actm.Stage__c != 'New' && triggerOldMap.get(actm.Id).Stage__c != actm.Stage__c){
                    if(!updatedRecMap.containsKey(actm.Stage__c)){
                        updatedRecMap.put(actm.Stage__c, new List<Escalation_Complaint__c>{actm});
                    } else {
                        updatedRecMap.get(actm.Stage__c).add(actm);
                    }
                }
                if(actm.Escalation_Level__c != null && actm.Escalation_Level__c != triggerOldMap.get(actm.Id).Escalation_Level__c &&
                    (actm.Escalation_Level__c.containsIgnorecase('L2') || actm.Escalation_Level__c.containsIgnorecase('L3') || actm.Escalation_Level__c.containsIgnorecase('L4'))){
                    if(!notifyEscTeamMap.containsKey(actm.Escalation_Level__c)){
                        notifyEscTeamMap.put(actm.Escalation_Level__c, new List<Escalation_Complaint__c>{actm});
                    } else {
                        notifyEscTeamMap.get(actm.Escalation_Level__c).add(actm);
                    }
                }
            }
        }
                
        if(updatedRecMap != null && !updatedRecMap.isEmpty()){
            for(String keyval : updatedRecMap.keySet()){
                if(updatedRecMap.get(keyval) != null && updatedRecMap.get(keyval).size() > 0){
                    recordnotification(updatedRecMap.get(keyval),keyval);
                }
            }        
        }
        if(notifyEscTeamMap != null && !notifyEscTeamMap.isEmpty()){
            for(String keyval : notifyEscTeamMap.keySet()){
                if(notifyEscTeamMap.get(keyval).size() > 0){
                    notifyEscalationTeams(notifyEscTeamMap.get(keyval),keyval);
                }
            }
        }
        
        //DBiswal 08012017 - for approval to Region head
        Map<String,List<Escalation_Complaint__c>> regAccMap = new Map<String,List<Escalation_Complaint__c>>();
        for(Escalation_Complaint__c actm : actmList){
            if(actm.Alert_Senior_Leadership_Team__c){
                if(!regAccMap.containsKey(actm.Account__c)){
                    regAccMap.put(actm.Account__c, new List<Escalation_Complaint__c>{actm});
                } else {
                    regAccMap.get(actm.Account__c);
                }
            }
        }
        try{
            if(!regAccMap.isEmpty()){
                List<Approval.ProcessSubmitRequest> lstprocess = new List<Approval.ProcessSubmitRequest>();
                for(Account acc : [select Id,Region_Head_lk__c from Account where id IN: regAccMap.keySet()]){
                    List<Id> usrIds = new List<Id>();
                    if(acc.Region_Head_lk__c != null){
                        usrIds.add(acc.Region_Head_lk__c);
                        for(Escalation_Complaint__c act : regAccMap.get(acc.Id)){
                            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                            req.setComments('submit to Regional VPs');
                            req.setObjectId(act.id);
                            req.setNextApproverIds(usrIds);
                            lstprocess.add(req);
                        }
                    } else{
                        regAccMap.get(acc.Id)[0].addError('There are no Regional VP available for the Customer.');
                    }
                }
                List<Approval.ProcessResult> resultlist = Approval.process(lstprocess);
            }
        } catch(Exception e){
            CXM_actionMgmtTriggerHelper.exceptionHandleMethod(CXM_actionMgmtTriggerHelper.class.getName(),'processingMethod()','cxm record','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
    }
    
    public void recordnotification(List<Escalation_Complaint__c> actmgmtList, String scenario){
        Map<Id,Escalation_Complaint__c> recordDetailMap = new Map<Id,Escalation_Complaint__c>();
        Map<String,Set<String>> recordmailMap = new Map<String,Set<String>>();
        List<CXM_Escalation_Team__c> escTeamstoInsert = new List<CXM_Escalation_Team__c>();
        List<Escalation_Complaint__c> actmgmttoUpd = new List<Escalation_Complaint__c>();
        List<Escalation_Complaint__c> actmgmtConList = [SELECT Id,Name,Account__c,Account__r.Name,Subject__c,Stage__c,CreatedById,Assigned_Resolution_Owner__c,Assigned_Resolution_Owner__r.Name,OwnerId,Owner.Name,LastModifiedById,
                                                        Account__r.Sales_Territory__c,Escalation_User_1__c,Escalation_User_2__c,Escalation_User_3__c,Description__c,Expected_Close_Date__c FROM Escalation_Complaint__c WHERE Id IN: actmgmtList];
        
        for(Escalation_Complaint__c actm : actmgmtConList){
            if(actm.Assigned_Resolution_Owner__c != null){
                Escalation_Complaint__c esc = new Escalation_Complaint__c();
                esc.Id = actm.Id;
                esc.OwnerId = actm.Assigned_Resolution_Owner__c;
                actmgmttoUpd.add(esc);
                
                CXM_Escalation_Team__c newTeam1 = new CXM_Escalation_Team__c(Action_Management__c = actm.Id,User__c = actm.OwnerId,Escalation_Level__c = 'L2 - Account Team Level');
                CXM_Escalation_Team__c newTeam2 = new CXM_Escalation_Team__c(Action_Management__c = actm.Id,User__c = actm.Assigned_Resolution_Owner__c,Escalation_Level__c = 'L2 - Account Team Level');
                escTeamstoInsert.add(newTeam1);
                escTeamstoInsert.add(newTeam2);
            }
            recordDetailMap.put(actm.Id, actm);
            if(actm.Escalation_User_1__c != null){
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, new Set<String>{actm.Escalation_User_1__c});
                } else {
                    recordmailMap.get(actm.Id).add(actm.Escalation_User_1__c);
                }
            }
            if(actm.Escalation_User_2__c != null){
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, new Set<String>{actm.Escalation_User_2__c});
                } else {
                    recordmailMap.get(actm.Id).add(actm.Escalation_User_2__c);
                }
            }
            if(actm.Escalation_User_3__c != null){
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, new Set<String>{actm.Escalation_User_3__c});
                } else {
                    recordmailMap.get(actm.Id).add(actm.Escalation_User_3__c);
                }
            }
            if(scenario.equalsIgnoreCase('New') || scenario.equalsIgnoreCase('Assigned')){
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, new Set<String>{actm.CreatedById});
                } else {
                    recordmailMap.get(actm.Id).add(actm.CreatedById);
                }
            }
            if(scenario.equalsIgnoreCase('Assigned') || scenario.equalsIgnoreCase('Acknowledged') || scenario.equalsIgnoreCase('In Process') || scenario.equalsIgnoreCase('Closed') || scenario.equalsIgnoreCase('Resolved') || scenario.equalsIgnoreCase('Reassign')){
                Set<String> templist = new Set<String>{actm.Assigned_Resolution_Owner__c};
                templist.add(actm.OwnerId);
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, templist);
                } else {
                    recordmailMap.get(actm.Id).addAll(templist);
                }
            }
            if(scenario.equalsIgnoreCase('Assigned')){
                if(!recordmailMap.containsKey(actm.Id)){
                    recordmailMap.put(actm.Id, new Set<String>{actm.LastModifiedById});
                } else {
                    recordmailMap.get(actm.Id).add(actm.LastModifiedById);
                }
            }
        }
        
        try{
            if(actmgmttoUpd.size() > 0){
                Database.update(actmgmttoUpd);
            }
            if(escTeamstoInsert.size() > 0){
                Database.insert(escTeamstoInsert);
            }
        } catch(Exception e){
            System.debug('Error: '+ e.getMessage());
            CXM_actionMgmtTriggerHelper.exceptionHandleMethod(CXM_actionMgmtTriggerHelper.class.getName(),'recordnotification()','cxm record','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
        
        if(scenario.equalsIgnoreCase('New') || scenario.equalsIgnoreCase('Closed') || scenario.equalsIgnoreCase('Resolved') || scenario.equalsIgnoreCase('Reassign')){
            for(CXM_Escalation_Team__c atp : [SELECT Id,User__c,User__r.email,Action_Management__c FROM CXM_Escalation_Team__c WHERE Action_Management__c IN: actmgmtConList]){
                for(Escalation_Complaint__c actm : actmgmtConList){
                    if(atp.Action_Management__c == actm.Id){
                        if(!recordmailMap.containsKey(actm.Id)){
                            recordmailMap.put(actm.Id, new Set<String>{atp.User__c});
                        } else {
                            recordmailMap.get(actm.Id).add(atp.User__c);
                        }
                    }
                }
            }           
        }
        
        //Send email
        try{
            CXM_BatchEscalationReminders.cxmUtilMailContainer(recordmailMap,recordDetailMap,scenario);
        } catch(Exception e){
            CXM_actionMgmtTriggerHelper.exceptionHandleMethod(CXM_actionMgmtTriggerHelper.class.getName(),'recordnotification()','cxm record','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
    }
    
    //For notifying L2,L3,L4 Team
    public void notifyEscalationTeams(List<Escalation_Complaint__c> actmList, String level){
        Map<Id,Set<String>> atpMap = new Map<Id,Set<String>>();
        Map<Id,Escalation_Complaint__c> recordDetailMap = new Map<Id,Escalation_Complaint__c>();
        Map<String,Set<String>> escTeammailMap = new Map<String,Set<String>>();
        
        for(CXM_Escalation_Team__c atp : [SELECT Id,User__c,Action_Management__c FROM CXM_Escalation_Team__c WHERE Action_Management__c IN: actmList]){
            if(!atpMap.containsKey(atp.Action_Management__c)){
                atpMap.put(atp.Action_Management__c, new Set<String>{atp.User__c});
            } else {
                atpMap.get(atp.Action_Management__c).add(atp.User__c);
            }
        }
        List<Escalation_Complaint__c> actmgmtConList = [SELECT Id,Name,Account__c,Account__r.Name,Subject__c,Stage__c,Escalation_Level__c,Assigned_Resolution_Owner__c,Assigned_Resolution_Owner__r.Name,Account__r.Sales_Territory__c,
                                                        OwnerId,Owner.Name,Escalation_User_1__c,Escalation_User_2__c,Escalation_User_3__c,Description__c,Expected_Close_Date__c FROM Escalation_Complaint__c WHERE Id IN: actmList];
        for(Escalation_Complaint__c actm : actmgmtConList){
            recordDetailMap.put(actm.Id, actm);
            
            if(actm.Escalation_Level__c.containsIgnorecase('L') && !atpMap.isEmpty()){
                for(Id escId : atpMap.keySet()){
                    if(actm.Id == escId){
                        if(!escTeammailMap.containsKey(actm.Id)){
                            Set<String> tempset = new Set<String>();
                            tempset.addAll(atpMap.get(escId));
                            escTeammailMap.put(actm.Id, tempset);
                        } else {
                            escTeammailMap.get(actm.Id).addAll(atpMap.get(escId));
                        }
                    }
                }
            }
            
            if(actm.Escalation_User_1__c != null){
                if(!escTeammailMap.containsKey(actm.Id)){
                    escTeammailMap.put(actm.Id, new Set<String>{actm.Escalation_User_1__c});
                } else {
                    escTeammailMap.get(actm.Id).add(actm.Escalation_User_1__c);
                }
            }
            if(actm.Escalation_User_2__c != null){
                if(!escTeammailMap.containsKey(actm.Id)){
                    escTeammailMap.put(actm.Id, new Set<String>{actm.Escalation_User_2__c});
                } else {
                    escTeammailMap.get(actm.Id).add(actm.Escalation_User_2__c);
                }
            }
            if(actm.Escalation_User_3__c != null){
                if(!escTeammailMap.containsKey(actm.Id)){
                    escTeammailMap.put(actm.Id, new Set<String>{actm.Escalation_User_3__c});
                } else {
                    escTeammailMap.get(actm.Id).add(actm.Escalation_User_3__c);
                }
            }
        }
        
        try{
            //Send email
            CXM_BatchEscalationReminders.cxmUtilMailContainer(escTeammailMap,recordDetailMap,level);
            if(actmList != null && actmList.size() > 0){
                List<FeedItem> actmfeedList = new List<FeedItem>();
                for(Escalation_Complaint__c actm : actmList){
                    FeedItem txtpost = new FeedItem();
                    txtpost.Body = level.containsIgnorecase('L2') ? 'First Notification has been sent to L2 Escalation Team.' : 
                                   level.containsIgnorecase('L3') ? 'First Notification has been sent to L3 Escalation Team.' :
                                   level.containsIgnorecase('L4') ? 'First Notification has been sent to L4 Escalation Team.' : '';
                    txtpost.ParentId = actm.Id;
                    txtpost.Type = 'TextPost';
                    actmfeedList.add(txtpost);
                }
                if(actmfeedList.size() > 0){
                    Database.insert(actmfeedList);
                }
            }
        } catch(Exception e){
            System.debug('Error: '+e.getMessage());
            CXM_actionMgmtTriggerHelper.exceptionHandleMethod(CXM_actionMgmtTriggerHelper.class.getName(),'notifyEscalationTeams()','cxm record','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
    }
    
     public Static void exceptionHandleMethod(String SrcName,String SrcFunctionName,String Obj, String logMsg,String logcd,Exception exc){
        ApplicationLogWrapper alw = new ApplicationLogWrapper();
        alw.source = SrcName;
        alw.sourceFunction = SrcFunctionName;
        alw.ApplicationName = 'Account Management';
        alw.referenceId = obj;
        alw.referenceInfo = 'PSP';
        alw.logMessage = logMsg;
        alw.debugLevel = 'Error';
        alw.logCode = logcd;
        alw.ex = exc;
        GlobalUtility.logMessage(alw);
    }
}