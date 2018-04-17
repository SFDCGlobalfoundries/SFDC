/*
    Author: Deepti Narayan Biswal
    Description: This Class is used to send Reminder Notifications for CSR users in ROS System.
    History:
        DBiswal     08192015    - Created.
        DBiswal     09042015    - Modified code according to code review.
*/
global class ROS_BATCH_CSRNotifications implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    Map<Id,List<Reticle__c>> csrPNCMap = new Map<Id,List<Reticle__c>>(); //Map for user and reticles with Pending to Notify Customer status
    Map<Id, List<Reticle__c>> csrPCFMap = new Map<Id, List<Reticle__c>>(); //Map for user and reticles with Pending for Customer Feedback status
    Map<Id, List<Reticle__c>> usrtradecompMap = new Map<Id, List<Reticle__c>>(); //Map for user and reticles for ROS Trade compliance Team
    Map<Id, List<Reticle__c>> cePWADMap = new Map<Id, List<Reticle__c>>(); //Map for user and reticles with pending witness arrival date status
    String currentrosCycle = '';
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        currentrosCycle = ROS_Util.getCurrentROSCycle();
        String stf='Pending for STF Obsolescence';
        String pfab='Pending for Fab\'s Follow-up';
        String query = 'SELECT Id,Name,Account__c,Account__r.Name,Reticle_Type__c,GlobalFoundries_Device_ID__c,Device_ID__c,FabStr__c,Day_Inactive__c,Day_Inactive_Formula__c,ROS_Status__c,Reticle_workflow_Status__c,ROS_Cycle__c,ROS_Cycle__r.Name,HS_Code_Assigned__c FROM Reticle__c ';
        String wherecond = ' WHERE (Reticle_workflow_Status__c = \'Pending to Notify Customer\' OR Reticle_workflow_Status__c = \'Pending for Customer Feedback\' OR Reticle_workflow_Status__c = \'Pending Witness Arrival Date\' OR Reticle_workflow_Status__c =: stf OR Reticle_workflow_Status__c =: pfab) AND ROS_Cycle__r.Name=:currentrosCycle ORDER BY Account__c';
        query = query+wherecond;
        return Database.getQueryLocator(query);
    }
    global void execute(SchedulableContext SC){
        Database.executeBatch(new ROS_BATCH_CSRNotifications());
    }
    global void execute(Database.BatchableContext BC, List<Reticle__c> scope){
        Map<Id,Reticle__c> retPNCMap = new Map<Id,Reticle__c>(); //Map for reticles with Pending to Notify Customer status
        Map<Id,Reticle__c> retPCFMap = new Map<Id,Reticle__c>(); //Map for reticles with Pending for Customer Feedback status
        Map<Id,Reticle__c> rettradecompMap = new Map<Id,Reticle__c>(); //Map for reticles with Pending for STF Obsolescence status
        Map<Id,Reticle__c> retPWADMap = new Map<Id,Reticle__c>(); //Map for reticles with pending witness arrival date status
        Set<Id> accIdset = new Set<Id>();
        for(Reticle__c ret : scope){
            if(ret.Reticle_workflow_Status__c == 'Pending to Notify Customer' || ret.Reticle_workflow_Status__c == 'Pending for Customer Feedback'){
                accIdset.add(ret.Account__c);
                if(ret.Reticle_workflow_Status__c == 'Pending to Notify Customer'){
                    retPNCMap.put(ret.Id, ret);
                } else if(ret.Reticle_workflow_Status__c == 'Pending for Customer Feedback'){
                    retPCFMap.put(ret.Id, ret);
                } 
        	} else if((ret.Reticle_workflow_Status__c == 'Pending for STF Obsolescence' || ret.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up') && ret.ROS_Status__c == 'Return' && ret.HS_Code_Assigned__c == false){
                rettradecompMap.put(ret.Id, ret);
            } else if(ret.Reticle_workflow_Status__c == 'Pending Witness Arrival Date' && ret.ROS_Status__c == 'Scrap'){
                retPWADMap.put(ret.Id, ret);
            }        
        }
        
        Set<Id> csrUsrIdset = new Set<Id>();
        for(Account_Team_Proxy__c atp : [SELECT Id,Team_Role__c,User__c FROM Account_Team_Proxy__c WHERE Account__c IN: accIdset AND (Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')) AND User__r.IsActive = true]){
            csrUsrIdset.add(atp.User__c);
        }
        
        List<GroupMember> ltradecompGM = [SELECT Id,Group.Name,UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'ROS_Trade_Compliance_Team' AND Group.Type = 'Queue'];
        
        for(Reticle__Share rets : [SELECT Id,UserOrGroupId,ParentId,RowCause FROM Reticle__Share 
                                   WHERE ParentId IN: scope AND (RowCause = 'Sharing_with_CSR__c' OR RowCause = 'Sharing_with_Trade_Compliance__c' OR RowCause = 'Sharing_with_CE__c') ORDER BY RowCause]){
            if(rets.RowCause == 'Sharing_with_CSR__c'){
                if(csrUsrIdset.contains(rets.UserOrGroupId)){
                    if(retPNCMap.containsKey(rets.ParentId)){
                        if(!csrPNCMap.containsKey(rets.UserOrGroupId)){
                            csrPNCMap.put(rets.UserOrGroupId, new List<Reticle__c>{retPNCMap.get(rets.ParentId)});
                        } else {
                            csrPNCMap.get(rets.UserOrGroupId).add(retPNCMap.get(rets.ParentId));
                        }
                    }
                    if(retPCFMap.containsKey(rets.ParentId)){
                        if(!csrPCFMap.containsKey(rets.UserOrGroupId)){
                            csrPCFMap.put(rets.UserOrGroupId, new List<Reticle__c>{retPCFMap.get(rets.ParentId)});
                        } else {
                            csrPCFMap.get(rets.UserOrGroupId).add(retPCFMap.get(rets.ParentId));
                        }
                    }
            	}
            } else if(rets.RowCause == 'Sharing_with_Trade_Compliance__c'){
                if(rettradecompMap.containsKey(rets.ParentId)){
                    if(!ltradecompGM.isEmpty()){
                        for(GroupMember gm : ltradecompGM){
                            if(!usrtradecompMap.containsKey(gm.UserOrGroupId)){
                                usrtradecompMap.put(gm.UserOrGroupId, new List<Reticle__c>{rettradecompMap.get(rets.ParentId)});
                            } else {
                                usrtradecompMap.get(gm.UserOrGroupId).add(rettradecompMap.get(rets.ParentId));
                            }
                        }
                    }
                }
            } else if(rets.RowCause == 'Sharing_with_CE__c'){
                if(retPWADMap.containsKey(rets.ParentId)){
                    if(!cePWADMap.containsKey(rets.UserOrGroupId)){
                        cePWADMap.put(rets.UserOrGroupId, new List<Reticle__c>{retPWADMap.get(rets.ParentId)});
                    } else {
                        cePWADMap.get(rets.UserOrGroupId).add(retPWADMap.get(rets.ParentId));
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        Map<String,String> reportMap = new Map<String,String>();
        List<Report> reportlist = [SELECT Id,Name,DeveloperName FROM Report WHERE (DeveloperName = 'Reticles_Pending_for_Notify_Customer' OR DeveloperName = 'Reticles_Pending_for_Customer_Feedback' OR DeveloperName = 'Reticles_Pending_for_HS_Code_Assignment' OR DeveloperName = 'Reticles_Pending_for_Witness_Arrival_Date')];
        for(Report r : reportlist){
            if(r.DeveloperName == 'Reticles_Pending_for_Notify_Customer'){
                reportMap.put('notify customer', (String)r.Id);
            } else if(r.DeveloperName == 'Reticles_Pending_for_Customer_Feedback'){
                reportMap.put('customer feedback', (String)r.Id);
            } else if(r.DeveloperName == 'Reticles_Pending_for_HS_Code_Assignment'){
                reportMap.put('hs code assignment', (String)r.Id);
            } else if(r.DeveloperName == 'Reticles_Pending_for_Witness_Arrival_Date'){
                reportMap.put('witness arrival date', (String)r.Id);
            }
        }
        List<Messaging.SingleEmailMessage> csrmails = new List<Messaging.SingleEmailMessage>();
        if(!csrPNCMap.isEmpty()){
            String reportId = reportMap.get('notify customer');
            for(Id csrId : csrPNCMap.keySet()){
              Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+csrPNCMap.get(csrId).size()+') Reticles are pending for Customer Notification in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for the Customer Notification');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!csrPCFMap.isEmpty()){
            String reportId = reportMap.get('customer feedback');
            for(Id csrId : csrPCFMap.keySet()){
              Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+csrPCFMap.get(csrId).size()+') Reticles are pending for Customer Feedback in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for the Customer Feedback');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!usrtradecompMap.isEmpty()){
            String reportId = reportMap.get('hs code assignment');
            for(Id csrId : usrtradecompMap.keySet()){
              Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+usrtradecompMap.get(csrId).size()+') Reticles are pending for HS Code and Item Number Assignment in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for the HS Code and Item Numbers Assignment');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!cePWADMap.isEmpty()){
            String reportId = reportMap.get('witness arrival date');
            for(Id csrId : cePWADMap.keySet()){
              Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSenderDisplayName('ROS System');
                mail1.setTargetObjectId(csrId);
                mail1.setHtmlBody('Dear Team,<br/><br/>A number of('+cePWADMap.get(csrId).size()+') Reticles are pending for Witness Arrival Date in the ROS system.<br/><br/>Request you to log into the system and process the reticles accordingly.<br/><br/><a href="'+baseUrl+'/'+reportId+'">Click here to view its Report.</a>');
                mail1.setSubject('(ROS '+currentrosCycle+'): Reticles Pending for Witness Arrival Date');
                mail1.setSaveAsActivity(false);
                csrmails.add(mail1);
            }
        }
        if(!csrmails.isEmpty() && !Test.isRunningTest()){
            Messaging.sendEmail(csrmails);
        }
    }
}