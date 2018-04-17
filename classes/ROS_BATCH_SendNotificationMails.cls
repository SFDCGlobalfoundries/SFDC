/**
* Description   :   Batch class for sending mails for ROS System.                 
* History       :   

        Initials        Date             Description
----------------------------------------------------------------------------
        DBiswal       07062015        Created the Class.
        
**/

global class ROS_BATCH_SendNotificationMails implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    List<Reticle__c> retfabList = new List<Reticle__c>();
    Map<Id,List<Reticle__c>> usrRetstfMap = new Map<Id,List<Reticle__c>>();
    Map<Id, List<Reticle__c>> usrRetfabMap = new Map<Id,List<Reticle__c>>();
    String currentrosCycle = '';
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String stf = 'Pending for STF Obsolescence';
        String fab = 'Pending for Fab\'s Follow-up';
        String soqlQuery;
        currentrosCycle = ROS_Util.getCurrentROSCycle();
        soqlQuery = 'SELECT Id, Name, Account__c, Account__r.Name, Reticle_Type__c, ROS_Cycle__c, ROS_Cycle__r.Name, GlobalFoundries_Device_ID__c, Device_ID__c, FabStr__c, Day_Inactive__c, Day_Inactive_Formula__c, Reticle_workflow_Status__c, ROS_Status__c ' + ' FROM Reticle__c ';
        String whereCond = ' WHERE (Reticle_workflow_Status__c =: stf OR Reticle_workflow_Status__c =: fab ) AND ROS_Cycle__r.Name=:currentrosCycle ORDER by Account__r.Name';
        soqlQuery = soqlQuery + whereCond;
        return Database.getQueryLocator(soqlQuery);
    }
    
    global void execute(SchedulableContext SC){
        ROS_BATCH_SendNotificationMails dailyROSNotification = new ROS_BATCH_SendNotificationMails();
        database.executebatch(dailyROSNotification);        
    }
    
    global void execute(Database.BatchableContext BC, List<Reticle__c> scope){
        Map<Id,Reticle__c> retPiyeMap = new Map<Id,Reticle__c>();
        for(Reticle__c ret: scope){
            if(ret.Reticle_workflow_Status__c == 'Pending for STF Obsolescence'){
                retPiyeMap.put(ret.Id, ret);
            } else if(ret.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up'){
                retfabList.add(ret);
            }
        }
        //for Pending STF Obsolescence
        if(!retPiyeMap.isEmpty()){
            Map<Id, List<Reticle__c>> groupRetMap = new Map<Id, List<Reticle__c>>();
            List<Reticle__Share> lretshare = new List<Reticle__Share>();
            //DBiswal 07112015
            if(!Test.isRunningTest()){
                lretshare = [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Reticle__Share 
                             WHERE ParentId IN: retPiyeMap.keySet() AND RowCause = 'Rule'];
            } else{
                lretshare = [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Reticle__Share 
                             WHERE ParentId IN: retPiyeMap.keySet()];
            }
            for(Reticle__Share rets : lretshare){                
                if(!groupRetMap.containsKey(rets.UserOrGroupId)){
                    groupRetMap.put(rets.UserOrGroupId, new List<Reticle__c>{retPiyeMap.get(rets.ParentId)});
                } else {
                    groupRetMap.get(rets.UserOrGroupId).add(retPiyeMap.get(rets.ParentId));
                }                   
            }
            
            Set<Id> sgroupId = new Set<Id>();
            for(Reticle__Share rets : lretshare){
                sgroupId.add(rets.UserOrGroupId);
            }
            
            String userType = Schema.SObjectType.User.getKeyPrefix();
            Map<Id,GroupMember> gmpiyemap = new Map<Id,GroupMember>([SELECT Id,GroupId,Group.name,UserOrGroupId FROM GroupMember WHERE GroupId IN: sgroupId]);
            Map<Id,List<String>> usrGroupMap = new Map<Id,List<String>>();
            for(Id gId : gmpiyemap.keySet()){               
                if(((String)gmpiyemap.get(gId).UserOrGroupId).startsWith(userType) && gmpiyemap.get(gId).Group.name.startsWith('PI/YE ROS Fab')){
                    if(!usrGroupMap.containsKey(gmpiyemap.get(gId).UserOrGroupId)){
                        usrGroupMap.put(gmpiyemap.get(gId).UserOrGroupId, new List<String>{gmpiyemap.get(gId).GroupId});
                    } else {
                        usrGroupMap.get(gmpiyemap.get(gId).UserOrGroupId).add(gmpiyemap.get(gId).GroupId);
                    }
                }               
            }           
            
             for(Id uId : usrGroupMap.keySet()){
                for(String gId : usrGroupMap.get(uId)){
                    if(!usrRetstfMap.containsKey(uId)){
                        List<Reticle__c> lRet3 = new List<Reticle__c>();
                        lRet3.addAll(groupRetMap.get(gId));
                        usrRetstfMap.put(uId, lRet3);
                    } else {
                        Set<Reticle__c> sRet4 = new Set<Reticle__c>();
                        List<Reticle__c> lRet4 = new List<Reticle__c>();
                        sRet4.addAll(usrRetstfMap.get(uId));                        
                        sRet4.addAll(groupRetMap.get(gId));
                        lRet4.addAll(sRet4);
                        usrRetstfMap.put(uId, lRet4);
                    }
                }
             }             
        }
        //for Pending Fab Follow Up
        if(!retfabList.isEmpty()){
            Map<Id, List<Reticle__c>> groupRetMap = new Map<Id, List<Reticle__c>>();
            Map<Id,Reticle__c> retfabMap = new Map<Id,Reticle__c>(retfabList);
            List<Reticle__Share> lretshare = new List<Reticle__Share>();
            List<group> lfabgroup = new List<group>();
            if(!Test.isRunningTest()){
                lretshare = [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Reticle__Share WHERE ParentId IN: retfabList AND RowCause = 'Rule'];
                lfabgroup = [SELECT Id,Name, Developername FROM group WHERE Name like 'ROS Fab%'];
            } else {
                lretshare = [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Reticle__Share WHERE ParentId IN: retfabList];
                lfabgroup = [SELECT Id,Name, Developername FROM group];
            }
            Set<Id> sgroupId = new Set<Id>();
            for(group g : lfabgroup){
                sgroupId.add(g.Id);
            }
            for(Reticle__Share rets : lretshare){
                if(!groupRetMap.containsKey(rets.UserOrGroupId)){
                    if(sgroupId.contains(rets.UserOrGroupId)){
                        groupRetMap.put(rets.UserOrGroupId, new List<Reticle__c>{retfabMap.get(rets.ParentId)});
                    }
                } else {
                    if(sgroupId.contains(rets.UserOrGroupId)){
                        groupRetMap.get(rets.UserOrGroupId).add(retfabMap.get(rets.ParentId));
                    }
                }
            }
            
            String userType = Schema.SObjectType.User.getKeyPrefix();
            Map<Id,GroupMember> gmfabmap = new Map<Id,GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE GroupId IN: groupRetMap.keySet()]);
            Map<Id,List<String>> usrGroupMap = new Map<Id,List<String>>();
            for(Id gId : gmfabmap.keySet()){                
                if(((String)gmfabmap.get(gId).UserOrGroupId).startsWith(userType)){
                    if(!usrGroupMap.containsKey(gmfabmap.get(gId).UserOrGroupId)){
                        usrGroupMap.put(gmfabmap.get(gId).UserOrGroupId, new List<String>{gmfabmap.get(gId).GroupId});
                    } else {
                        usrGroupMap.get(gmfabmap.get(gId).UserOrGroupId).add(gmfabmap.get(gId).GroupId);
                    }
                }
            }
            
            for(Id uId : usrGroupMap.keySet()){
                for(String gId : usrGroupMap.get(uId)){
                    if(!usrRetfabMap.containsKey(uId)){
                        List<Reticle__c> lRet3 = new List<Reticle__c>();
                        lRet3.addAll(groupRetMap.get(gId));
                        usrRetfabMap.put(uId, lRet3);
                    } else {
                        Set<Reticle__c> sRet4 = new Set<Reticle__c>();
                        List<Reticle__c> lRet4 = new List<Reticle__c>();
                        sRet4.addAll(usrRetfabMap.get(uId));                        
                        sRet4.addAll(groupRetMap.get(gId));
                        lRet4.addAll(sRet4);
                        usrRetfabMap.put(uId, lRet4);
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        Map<String,String> reportMap = new Map<String,String>();
        List<Report> reportlist = [SELECT Id,Name,DeveloperName FROM Report WHERE (DeveloperName = 'Reticles_Pending_for_STF_Obsolescence' OR DeveloperName = 'Reticles_Pending_for_Fab_Follow_Up')];
        for(Report r : reportlist){
            if(r.DeveloperName == 'Reticles_Pending_for_STF_Obsolescence'){
                reportMap.put('stf obsolescence', (String)r.Id);
            } else if(r.DeveloperName == 'Reticles_Pending_for_Fab_Follow_Up'){
                reportMap.put('fab follow up', (String)r.Id);
            }
        }
        List<Messaging.SingleEmailMessage> csrmails = new List<Messaging.SingleEmailMessage>();
        if(!usrRetstfMap.isEmpty()){
            String reportId = reportMap.get('stf obsolescence');
            for(Id csrId : usrRetstfMap.keySet()){
            	Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+usrRetstfMap.get(csrId).size()+') Reticles are pending for STF Obsolescence in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for STF Obsolescence');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!usrRetfabMap.isEmpty()){
            String reportId = reportMap.get('fab follow up');
            for(Id csrId : usrRetfabMap.keySet()){
            	Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+usrRetfabMap.get(csrId).size()+') Reticles are pending for fab follow-up in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for fab follow-up');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!csrmails.isEmpty() && !Test.isRunningTest()){
            Messaging.sendEmail(csrmails);
        }
    }
}