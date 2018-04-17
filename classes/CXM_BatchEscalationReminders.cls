/*
     Author: DBiswal
     Description: Batch Class to send Reminder to Escalation group
     History: 
         DBiswal    04112017    Modified for Escalation team enhancement.
*/
global class CXM_BatchEscalationReminders implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
  
    global Map<Id,Escalation_Complaint__c> eachRecMap = new Map<Id,Escalation_Complaint__c>();  
    global Map<String,Set<String>> recipientMap = new Map<String,Set<String>>();
    private static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    
    global Database.QueryLocator start(Database.BatchableContext dbc){
        Date mydate1 = Date.today();
        Date mydate2 = Date.today().addDays(-1);
        String query = 'SELECT Id,Name,Account__c,Account__r.Name,Account__r.Sales_Territory__c,Stage__c,Subject__c,Assigned_Resolution_Owner__r.Name,Department__c,Escalation_Level__c,Escalation_Level_Duration__c,' +
                       'FAB__c,Expected_Close_Date__c,Escalation_User_1__c,Escalation_User_2__c,Escalation_User_3__c,Description__c,Owner.Name From Escalation_Complaint__c ';
        String whereCond = 'WHERE (Stage__c!=\'Closed\' AND Stage__c!=\'Resolved\') AND Escalation_Level__c != null';
        return Database.getQueryLocator(query+whereCond);
    }
    
    global void execute(SchedulableContext sc) {
      CXM_BatchEscalationReminders cxmbatch = new CXM_BatchEscalationReminders(); 
        Database.executebatch(cxmbatch);
    }
    
    global Escalation_Complaint__c fetchRecordforUpdate(Escalation_Complaint__c esc,String lvl){
        Escalation_Complaint__c actmNewVal = esc;
        actmNewVal.Escalation_Level__c = lvl;
        return actmNewVal;
    }
    
    global void execute(Database.BatchableContext dbc, List<Escalation_Complaint__c> scope){
        Map<Id,Set<String>> atpMap = new Map<Id,Set<String>>();
        Map<Id,Set<String>> atpMap2 = new Map<Id,Set<String>>();
        List<Escalation_Complaint__c> actmUpdatelevelList = new List<Escalation_Complaint__c>();
        
        for(Escalation_Complaint__c actm : scope){
            eachRecMap.put(actm.Id, actm);
            if(actm.Escalation_Level__c == 'L1 - Customer Action'){
                if(actm.Expected_Close_Date__c != null && actm.Expected_Close_Date__c <= Date.today().addDays(-1)){
                    actmUpdatelevelList.add(fetchRecordforUpdate(actm,'L2 - Account Team Level'));
                }
            } else if(actm.Escalation_Level__c == 'L2 - Account Team Level'){
                if(actm.Escalation_Level_Duration__c > 10){
                    actmUpdatelevelList.add(fetchRecordforUpdate(actm,'L3 - Director/VP'));
                }
            } else if(actm.Escalation_Level__c == 'L3 - Director/VP'){
                if(actm.Escalation_Level_Duration__c > 5){
                    actmUpdatelevelList.add(fetchRecordforUpdate(actm,'L4 - Sr VP'));
                }
            }
        }
        
        //for updating escalation level
        try{
            if(actmUpdatelevelList.size() > 0){
                Database.update(actmUpdatelevelList);
            }
        } catch(Exception e){
            System.debug('Error: '+ e.getMessage());
        }
        //Set<String> atproleSet = new Set<String>{'Primary Account Manager','Account Manager'};
        for(CXM_Escalation_Team__c atp : [SELECT Id,User__c,Action_Management__c,Escalation_Level__c FROM CXM_Escalation_Team__c WHERE Action_Management__c IN : eachRecMap.keySet()]){
            if(atp.Escalation_Level__c.containsIgnorecase('L2')){
                if(!atpMap.containsKey(atp.Action_Management__c)){
                    atpMap.put(atp.Action_Management__c, new Set<String>{atp.User__c});
                } else {
                    atpMap.get(atp.Action_Management__c).add(atp.User__c);
                }
            } else if(atp.Escalation_Level__c.containsIgnorecase('L3')){
                if(!atpMap2.containsKey(atp.Action_Management__c)){
                    atpMap2.put(atp.Action_Management__c, new Set<String>{atp.User__c});
                } else {
                    atpMap2.get(atp.Action_Management__c).add(atp.User__c);
                }
            }
        }
        
        for(Escalation_Complaint__c act : scope){
            if(act.Escalation_Level__c.containsIgnorecase('L2') && act.Escalation_Level_Duration__c >= 7){
                for(Id actid : atpMap.keySet()){
                    if(act.Id == actid){
                        if(!recipientMap.containsKey(act.Id + '-L2')){
                            Set<String> tempset = new Set<String>();
                            tempset.addAll(atpMap.get(actid));
                            recipientMap.put(act.Id + '-L2', tempset);
                        } else {
                            recipientMap.get(act.Id + '-L2').addAll(atpMap.get(actid));
                        }
                    }
                }
            }
            
            if(act.Escalation_Level__c.containsIgnorecase('L3') && act.Escalation_Level_Duration__c >= 2){
                for(Id actid : atpMap2.keySet()){
                    if(act.Id == actid){
                        if(!recipientMap.containsKey(act.Id + '-L3')){
                            Set<String> tempset = new Set<String>();
                            tempset.addAll(atpMap2.get(actid));
                            recipientMap.put(act.Id + '-L3', tempset);
                        } else {
                            recipientMap.get(act.Id + '-L3').addAll(atpMap2.get(actid));
                        }
                    }
                }
            }
            
            //check for Action Users
            if(!recipientMap.isEmpty()){
                if(act.Escalation_User_1__c != null){
                    if(!recipientMap.containsKey(act.Id)){
                        recipientMap.put(act.Id, new Set<String>{act.Escalation_User_1__c});
                    } else {
                        recipientMap.get(act.Id).add(act.Escalation_User_1__c);
                    }
                }
                if(act.Escalation_User_2__c != null){
                    if(!recipientMap.containsKey(act.Id)){
                        recipientMap.put(act.Id, new Set<String>{act.Escalation_User_2__c});
                    } else {
                        recipientMap.get(act.Id).add(act.Escalation_User_2__c);
                    }
                }
                if(act.Escalation_User_3__c != null){
                    if(!recipientMap.containsKey(act.Id)){
                        recipientMap.put(act.Id, new Set<String>{act.Escalation_User_3__c});
                    } else {
                        recipientMap.get(act.Id).add(act.Escalation_User_3__c);
                    }
                }
            }
        }
    }
        
    global void finish(Database.BatchableContext dbc){
        Map<String,String> actmfeedUpdateMap = new Map<String,String>();
        cxmUtilMailContainer(recipientMap,eachRecMap,'batch');
        
        if(!recipientMap.isEmpty()){
            for(String key : recipientMap.keySet()){
                Escalation_Complaint__c tempactm = new Escalation_Complaint__c();
                if(key.containsIgnoreCase('L2')){
                    actmfeedUpdateMap.put(key.substring(0 , key.indexOf('-L')),'Reminder Notification has been sent to L2 Escalation Team.');
                } else if (key.containsIgnoreCase('L3')){
                    actmfeedUpdateMap.put(key.substring(0 , key.indexOf('-L')),'Reminder Notification has been sent to L3 Escalation Team.');
                }
            }
        }
        try{
            if(!actmfeedUpdateMap.isEmpty()){
                List<FeedItem> actmfeedList = new List<FeedItem>();
                for(String actmId : actmfeedUpdateMap.keySet()){
                    FeedItem txtpost = new FeedItem();
                    txtpost.Body = actmfeedUpdateMap.get(actmId);
                    txtpost.ParentId = actmId;
                    txtpost.Type = 'TextPost';
                    actmfeedList.add(txtpost);
                }
                if(actmfeedList.size() > 0){
                    Database.insert(actmfeedList);
                }
            }
        } catch(Exception e){
            System.debug('Error: '+ e.getMessage());
        }
    }
    
    global static void cxmUtilMailContainer(Map<String,Set<String>> escTeammailMap,Map<Id,Escalation_Complaint__c> recordDetailMap,String scenario){
        List<Messaging.SingleEmailMessage> notifymails = new List<Messaging.SingleEmailMessage>();
        try{
            List<EmailTemplate> template = [SELECT Id,Name,DeveloperName,HtmlValue FROM EmailTemplate WHERE DeveloperName='CXM_Generic_Template'];
             
            String htmlval = '' + template[0].HtmlValue + '';
            if(scenario.containsIgnorecase('L2')){
               htmlval += '<br/>This is to notify you that an Action has been escalated on Level 2 with below details:<br/><br/>';
            } else if(scenario.containsIgnorecase('L3')){
               htmlval += '<br/>This is to notify you that an Action has been escalated on Level 3 with below details:<br/><br/>';
            } else if(scenario.containsIgnorecase('L4')){
               htmlval += '<br/>This is to notify you that an Action has been escalated on Level 4 with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('batch')){
                htmlval += '<br/>This is to notify you that an Action needs your attention. If you do not take any action, it will be escalated to higher level soon. Please find its details: <br/><br/>';
            }else if(scenario.equalsIgnoreCase('New')){
                htmlval += '<br/>This is to notify you that an Action has been created with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('Assigned')){
                htmlval += '<br/>This is to notify you that an Action has been assigned a Resolution Owner with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('Acknowledged')){
                htmlval += '<br/>This is to notify you that an Action has been acknowledged with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('In Process')){
                htmlval += '<br/>This is to notify you that an Action has been modified and is still in process with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('Reassign')){
                htmlval += '<br/>This is to notify you that an Action has been reassigned a new Resolution Owner with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('Resolved')){
                htmlval += '<br/>This is to notify you that an Action has been resolved with below details:<br/><br/>';
            } else if(scenario.equalsIgnoreCase('Closed')){
                htmlval += '<br/>This is to notify you that an Action has been resolved and closed with below details:<br/><br/>';
            }
             
            if(!escTeammailMap.isEmpty()){
                for(String recId : escTeammailMap.keySet()){
                    Escalation_Complaint__c tempactm = (recId.containsIgnoreCase('-L') && scenario.equalsIgnoreCase('batch')) ? recordDetailMap.get(recId.substring(0 , recId.indexOf('-L'))) :  recordDetailMap.get(recId);
                    htmlval += '<table style="width:60%;border-width: 1px;"><tr><td>Action Name </td><td>'+tempactm.Name+'</td></tr>';
                    htmlval += '<tr><td>Account Name </td><td>'+tempactm.Account__r.Name+'</td></tr>';
                    htmlval += '<tr><td>Action </td><td>'+tempactm.Subject__c+'</td></tr>';
                    String details = tempactm.Description__c != null ? tempactm.Description__c.length() > 50 ? tempactm.Description__c.left(50)+ '... ' : tempactm.Description__c : '';
                    htmlval += '<tr><td>Action Details </td><td>'+ details +'</td></tr>';
                    htmlval += '<tr><td>Expected Close Date </td><td>'+Date.valueOf(tempactm.Expected_Close_Date__c)+'</td></tr>';
                    htmlval += '<tr><td>Stage </td><td>'+tempactm.Stage__c+'</td></tr>';
                    if(tempactm.Assigned_Resolution_Owner__c != null){
                        htmlval += '<tr><td>Action Owner </td><td>'+tempactm.Assigned_Resolution_Owner__r.Name+'</td></tr>';
                    } else {
                        htmlval += '<tr><td>Action Owner </td><td>'+tempactm.Owner.Name+'</td></tr>';
                    }
                    htmlval += '<tr><td colspan="2"><a href="'+baseUrl+'/'+tempactm.Id+'">Click here to view the Action</a></td></tr></table></body></html>';
                    for(String usr : escTeammailMap.get(recId)){
                        if(usr != null && usr != ''){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setSenderDisplayName('GF');
                            mail.setTargetObjectId(usr);
                            if(scenario.equalsIgnoreCase('batch')){
                                if(recId.containsIgnoreCase('L')){
                                    mail.setSubject('Reminder to take action on '+tempactm.Name);
                                } else {
                                    mail.setSubject('Reminder to take action on '+tempactm.Name+' (Other Action users)');
                                }
                            } else if(scenario.containsIgnorecase('L')) {
                                mail.setSubject('Escalation on Action: '+tempactm.Name);
                            } else {
                                mail.setSubject('Information on Action: '+tempactm.Name);
                            }
                            mail.setSaveAsActivity(false);
                            mail.setHtmlBody(htmlval);
                            notifymails.add(mail);
                        }
                    }
                }
            }
            if(notifymails.size() > 0){
                Messaging.sendEmail(notifymails);
            }
        } catch (Exception e){
            System.debug('Error: '+e.getMessage());
        }
    }
}