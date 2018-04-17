/*
Author: Thomas Lai
Description: Utility to send email
History:
    TLai     20102013     - Code Creation
    TLai     19022014     - Modified getPOApprover(), added primary CSR and backup CSR as recipients
*/

Public class BX041EmailHandler{
   
    public class IPNotificationWrapper{
        
        public string customerName {get; set;}
        public string customerSFID {get; set;}
        public string deviceId {get; set;}
        public String deviceStage {get; set;}
        public string ipNo {get; set;}
        public list<String> emailList {get; set;}
    }
    
    public class EmailWrapper{
        public id recId {get; set;}
        public String templateName {get; set;}
        public set<id> targetObjSet {get; set;}
        public map<string, string> stackHolder {get; set;}
        
    }
    public static void sendEmail(list<EmailWrapper> wrapperList ){// batch send single email msgs via setTargetObjectId(ID)
        /* Prepare Template Map ==Start*/
        set<string> templateSet = new set<string>();
        for(EmailWrapper wrp : wrapperList){
            templateSet.add(wrp.templateName);
        }
        
        if(!templateSet.isEmpty()){
            Map<String, Messaging.SingleEmailMessage> name2templateMap = new Map<String, Messaging.SingleEmailMessage>();
            //template name 2 id map
            Map<String,id> template2IdMap = new map<string,id>();
            for(EmailTemplate et : [SELECT id,DeveloperName, Subject, Body,HtmlValue from EmailTemplate where DeveloperName in :templateSet]){
                template2IdMap.put(et.DeveloperName, et.id);
            }
            if(template2IdMap.isEmpty()){
                system.debug('=========>No Email Template found in SendEmail in BX041EmailHandler.');
                return;
            }
            /* prepare dummy templates */
            Contact c = [SELECT id,email FROM Contact WHERE email <> null LIMIT 1];
            map<id, Messaging.SingleEmailMessage> rec2MsgMap = new map<id, Messaging.SingleEmailMessage>(); 
            list<Messaging.SingleEmailMessage> tempMailList = new list<Messaging.SingleEmailMessage>();
            
            set<id> rejectedIdSet = new set<id>();//for rejection comment
            for(EmailWrapper wrp : wrapperList){
                
                if(template2IdMap.containskey(wrp.templateName)){
                    id templateId = template2IdMap.get(wrp.templateName);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    /*Populate singleEmailMessage  == Start */   
                    mail.templateId = templateId;
                    mail.setTargetObjectId(c.id);
                    mail.setWhatId(wrp.recId);
                    mail.setSaveAsActivity(false);
                    mail.setToAddresses(new List<String>{'blank@blank.com'});  
                    rec2MsgMap.put(wrp.recId, mail);
                    
                    if(wrp.templateName == 'GF_Device_Requirements_Rejected_Email_Template'){
                        rejectedIdSet.add(wrp.recId);//cdrs which is reject
                    }
                }    
            }
            
            //Rollback to get the email template data
             
            try{
                Savepoint sp = Database.setSavepoint();
                messaging.reserveSingleEmailCapacity(rec2MsgMap.size());
                Messaging.sendEmail(rec2MsgMap.values()); 
                Database.rollback(sp);
            }catch(Exception ex){
                system.debug(ex.getMessage());
                return;
            }
              
            map<id,string> rec2commentMap = new map<id,string>();
            if(!rejectedIdSet.isEmpty()){
                list<ProcessInstanceStep> stepList = [SELECT Processinstance.targetobjectid, comments 
                                                    FROM ProcessInstanceStep 
                                                    where Processinstance.targetobjectid in :rejectedIdSet 
                                                        and stepstatus = 'Rejected' 
                                                    order by processinstance.targetobjectid ,createddate desc ];
                for(integer i = 0; i< stepList.size(); i++){
                    ProcessInstanceStep pis = stepList[i];
                    if(i==0){
                        rec2commentMap.put(pis.Processinstance.targetobjectid, pis.comments);
                    }else if(pis.Processinstance.targetobjectid != stepList[i-1].Processinstance.targetobjectid){
                        rec2commentMap.put(pis.Processinstance.targetobjectid, pis.comments);
                    }
                }
            }
            
            list<Messaging.SingleEmailMessage> finalList = new list<Messaging.SingleEmailMessage>();
            for(EmailWrapper wrp : wrapperList){
                Messaging.SingleEmailMessage tempMsg = rec2MsgMap.get(wrp.recId);
                if(wrp.templateName == 'GF_Device_Requirements_Rejected_Email_Template' && rec2commentMap.containskey(wrp.recId)){
                    String rejCommt = rec2commentMap.get(wrp.recId);
                    if(String.isEmpty(rejCommt)) rejCommt = '';
                    String plainBody = tempMsg.getPlainTextBody();
                    tempMsg.setPlainTextBody(plainBody.replace('{RejectedComments}',rejCommt));
                    String htmlBody = tempMsg.getHtmlBody();
                    tempMsg.setHtmlBody(htmlBody.replace('{RejectedComments}',rejCommt));
                }else if(wrp.templateName == 'GF_Device_Requirement_Backtrack_Template' ){//29/11/2013 SGT Thomas: add backtrack comment to email template
                    String backtrackComment = wrp.stackHolder.get('{BacktrackComment}');
                    if(String.isEmpty(backtrackComment)) backtrackComment = '';
                    String plainBody = tempMsg.getPlainTextBody();
                    tempMsg.setPlainTextBody(plainBody.replace('{BacktrackComment}',backtrackComment));
                    String htmlBody = tempMsg.getHtmlBody();
                    tempMsg.setHtmlBody(htmlBody.replace('{BacktrackComment}',backtrackComment));
                }
                for(Id usrId : wrp.targetObjSet){
                    Messaging.SingleEmailMessage newMsg = new Messaging.SingleEmailMessage();
                    newMsg.setReplyTo('do-not-reply@globalfoundries.com');
                    newMsg.setSenderDisplayName('No Reply');
                    //newMsg.setBccAddresses(new String[]{''});
                    newMsg.setBccSender(false);
                    newMsg.setUseSignature(false);
                    newMsg.setSubject(tempMsg.subject);
                    newMsg.setHtmlBody(tempMsg.htmlBody);
                    system.debug('------------>' + tempMsg.htmlBody);
                    system.debug('------------>' + newMsg.htmlBody);
                    newMsg.setPlainTextBody(tempMsg.plainTextBody);
                    newMsg.setTargetObjectId(usrId);
                    newMsg.setSaveAsActivity(false);
                    finalList.add(newMsg);
                }
            }
            try{
                
                if(finalList.size() > 0) {
                    list<Messaging.SingleEmailMessage> tempList = new list<Messaging.SingleEmailMessage>();
                    for(integer i = 0; i <finalList.size(); i++){
                        if(tempList.size() < 100){
                            tempList.add(finalList[i]);
                            if(i == finalList.size() -1 || tempList.size() == 100){
                                Messaging.reserveSingleEmailCapacity(tempList.size());
                                Messaging.sendEmail(tempList,false);
                            }
                        }else {
                            tempList = new list<Messaging.SingleEmailMessage>();
                            tempList.add(finalList[i]);
                        }
                    }
                }   
            }catch(exception ex){
                system.debug('SingleEmailException: ' + ex.getMessage());
                return;
            }
            
            system.debug('End of sendEmail');
        }
    }
    public static void sendEmail(list<IPNotificationWrapper> ipnWrapper, String templateName){
        EmailTemplate emailTemp = null;
        system.debug('****start sending email.');
        if(templateName == 'IP_DM_Change_Notification'){
            list<EmailTemplate> templateList = [SELECT id, Subject, Body,HtmlValue from EmailTemplate where DeveloperName = :templateName];
            if(!templateList.isEmpty()){
                emailTemp = templateList[0];
            
                list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
                for(IPNotificationWrapper ipnw : ipnWrapper){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    mail.setSubject(emailTemp.Subject);
                    mail.setToAddresses(ipnw.emailList);
                    system.debug(ipnw.emailList);
                    mail.setCcAddresses(null);
                    
                    mail.setReplyTo('do-not-reply@globalfoundries.com');
                    mail.setSenderDisplayName('No Reply');
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    
                    String emailTxtBody = emailTemp.Body;
                    emailTxtBody = emailTxtBody.replace('{Account_Name}',ipnw.customerName);
                    emailTxtBody = emailTxtBody.replace('{Device_ID}', ipnw.deviceId);
                    emailTxtBody = emailTxtBody.replace('{Device_Stage}', ipnw.deviceStage);
                    emailTxtBody = emailTxtBody.replace('{IP_No}', ipnw.ipNo);
                    
                    String emialHtmlBody = emailTemp.HtmlValue;
                    emialHtmlBody = emialHtmlBody.replace('{Account_Name}',ipnw.customerName);
                    emialHtmlBody = emialHtmlBody.replace('{Device_ID}', ipnw.deviceId);
                    emialHtmlBody = emialHtmlBody.replace('{Device_Stage}', ipnw.deviceStage);
                    emialHtmlBody = emialHtmlBody.replace('{IP_No}', ipnw.ipNo);
                    
                    if(!String.isEmpty(emailTxtBody)){
                        mail.setPlainTextBody(emailTxtBody);
                        
                    }
                    
                    if(!String.isEmpty(emialHtmlBody)){
                        mail.setHtmlBody(emialHtmlBody);
                    }
                    
                    mailList.add(mail);
                }
                if(!Test.isRunningTest()){
                    try{
                        Messaging.reserveSingleEmailCapacity(mailList.size());
                        Messaging.sendEmail(mailList);
                    }catch(Exception ex){
                        system.debug('SingleEmailException: ' + ex.getMessage());
                        return;
                    }
                }
                
            }
        }
    }
    
    /*-------------------------------------------------------------
    Method :        Retrieve CE Approver/Queue Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    
    Required Field: BX_041__c.id
                              device__r.Tapeout_Type__c
                              device__r.account__c
                              device__r.fab__c
    Custom Setting: Environment_Variable__c.ACT_TM_PRXY_TM_RL_CE
    Queue:          BX041 CE-FAB Approver Queue
                    BX041 CE-FAB1 Approver Queue
                    BX041 CE-FAB8 Approver Queue
    -------------------------------------------------------------*/
    public static map<id,list<id>> getCEApprover(List<BX_041__c> bx041List){
        
        map<id,list<id>> result = new map<id,list<id>>();
        List<BX_041__c> MPWList = new List<BX_041__c>();
        List<BX_041__c> nonMPWList = new List<BX_041__c>();
        set<id> acctIdSet = new set<id>();
        for(BX_041__c bx041 : bx041List){
            if(bx041.device__r.Tapeout_Type__c == 'GlobalShuttle MPW'){
                MPWList.add(bx041);
            }else {
                nonMPWList.add(bx041);
                acctIdSet.add(bx041.device__r.account__c);
            }
        }
        
        if(!MPWList.isEmpty()){
            Map<string,list<id>> mpwQueueMap = new Map<string,list<id>>();
            /*for(Group grp :  [SELECT id, Email,Name 
                                            FROM Group 
                                            where  type = 'Queue' 
                                               and Name like 'BX041 CE-FAB%']){
                mpwQueueMap.put(grp.name,grp.Email);                        
            }*/
            for(GroupMember gm : [SELECT GroupId,
                                         Group.Name,
                                         UserOrGroupId
                                    FROM GroupMember
                                    where  Group.Type = 'Queue' 
                                        and Group.Name like 'BX041 CE-FAB%' 
                                    order by groupId]){
                                        
                String usrid  = String.valueOf(gm.UserOrGroupId);
                if(usrid.startsWith('005')){
                    if(mpwQueueMap.containsKey(gm.group.name)){
                        mpwQueueMap.get(gm.group.name).add(gm.UserOrGroupId);
                    }else{
                        list<id> usrList = new list<id>{gm.UserOrGroupId};
                        mpwQueueMap.put(gm.group.name, usrList);
                    }
                }
                                
            }
            
            if(!mpwQueueMap.isEmpty()){
                for(BX_041__c bx041 : MPWList){
                    string seq = '';
                    if(bx041.device__r.fab__c == 'FAB 1'){
                        seq = '1';
                    }else if (bx041.device__r.fab__c == 'FAB 8'){
                        seq = '8';
                    }
                    
                    String ceQueueName = 'BX041 CE-FAB' + seq +' Approver Queue'; 
                    if(mpwQueueMap.containskey(ceQueueName)){
                        result.put(bx041.id, mpwQueueMap.get(ceQueueName));
                    }
                }
            }
            
        }
        if(!nonMPWList.isEmpty()){
            String ceRole = Environment_Variable__c.getInstance('ACT_TM_PRXY_TM_RL_CE').value__c;
            map<id, list<Account_Team_Proxy__c>> acct2CEMap = new map <id, list<Account_Team_Proxy__c>> ();
                    
            for(Account_Team_Proxy__c proxy : [select User__c,Account__c, Fab_Assignment__c
                                                from Account_Team_Proxy__c 
                                                where Account__c = :acctIdSet 
                                                    and Team_Role__c = :ceRole
                                                    and User__r.isActive = true
                                                order by Account__c, createddate]){
                
                if(acct2CEMap.containsKey(proxy.Account__c)){              
                    acct2CEMap.get(proxy.Account__c).add(proxy);
                }else{
                    list<Account_Team_Proxy__c> proxyList = new Account_Team_Proxy__c[]{proxy};
                    acct2CEMap.put(proxy.Account__c, proxyList);
                }
                
            }  
            
            if(!acct2CEMap.isEmpty()){
                for(BX_041__c bx041 : nonMPWList){
                    if(acct2CEMap.containskey(bx041.device__r.Account__c)){
                        list<id> usrList = new list<id>();
                        for(Account_Team_Proxy__c proxy : acct2CEMap.get(bx041.device__r.Account__c)){
                            if(proxy.Fab_Assignment__c.contains(bx041.device__r.Fab__c) && usrList.size() < 10){
                                usrList.add(proxy.user__c);
                            }
                        }
                        
                        result.put(bx041.id, usrList);
                    }
                }   
            }
        }
    
        return result;
    }
    
    /*
    Method :        Retrieve PIYE Approver Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    
    Required Field: BX_041__c.id
                              approver_1__c
                              approver_2__c
                              approver_3__c
    */
    public static map<id,list<id>> getPIYEApprover(List<BX_041__c> bx041List){
        map<id,list<id>> result = new map<id,list<id>>();
        for(BX_041__c bx041 :bx041List){
            list<id> usrList = new list<id>();
            for(integer i = 1; i <=3 ; i++){
                Id apprId = (Id)bx041.get('approver_'+ i + '__c');
                if(apprId != null){
                    usrList.add(apprId);
                }
            }
            
            if(!usrList.isEmpty()){
                result.put(bx041.id, usrList);
            }
        }
        
        return result;
    }
    
    /*
    Method :        Retrieve PIYE Approver Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    
    Required Field: BX_041__c.id
                              approver_1__c
                              approver_2__c
                              approver_3__c
    */
    public static map<id,list<id>> getCustomerSubmitter(List<BX_041__c> bx041List){
        map<id,list<id>> result = new map<id,list<id>>();
        for(BX_041__c bx041 :bx041List){
            list<id> usrList = new list<id>{bx041.CreatedById};
            result.put(bx041.id, usrList);
        }
        
        return result;
    }
    
    /*
    Method :        Retrieve Primary FTS Approver Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    
    Required Field: BX_041__c.id
                              device__r.account__c
    Custom Setting: Environment_Variable__c.ACCT_TM_PRXY_TM_RL_PFTS
    */
    /*
    public static map<id,list<id>> getFTSApprover (List<BX_041__c> bx041List) {
        
        map<id,list<id>> result = new map<id,list<id>>();
        set<id> acctIdSet = new set<id>();
        for(BX_041__c bx041 : bx041List){
            acctIdSet.add(bx041.device__r.account__c);
        }
        
            
        if(!acctIdSet.isEmpty()){
            list<string> roleList = new list<string>{ Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c,
                                                      Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FTS').value__c
                                                        };
            map<id, list<id>> acct2FTSMap = new map <id, list<id>> ();
                    
            for(Account_Team_Proxy__c proxy : [select User__c,Account__c
                                                from Account_Team_Proxy__c 
                                                where Account__c = :acctIdSet 
                                                    and Team_Role__c = :roleList
                                                    and User__r.isActive = true
                                                order by Account__c,Team_Role__c desc]){
                
                if(acct2FTSMap.containsKey(proxy.Account__c)){              
                    acct2FTSMap.get(proxy.Account__c).add(proxy.User__c);
                }else{
                    list<String> usrList = new list<String>{proxy.User__c};
                    acct2FTSMap.put(proxy.Account__c, usrList);
                }
                
            }  
            
            if(!acct2FTSMap.isEmpty()){
                for(BX_041__c bx041 : bx041List){
                    if(acct2FTSMap.containskey(bx041.device__r.Account__c)){
                        result.put(bx041.id, acct2FTSMap.get(bx041.device__r.Account__c));
                    }
                }   
            }
        }
        
        return result;
    }
    */
    /*
    Method :        Retrieve FAE Approver/Queue Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    
    Required Field: BX_041__c.id
                              bx041.Device__r.Account__r.Region__c
    Custom Setting: Environment_Variable__c.ACT_TM_PRXY_TM_RL_CE
    Queue:          BX041 FAE-APJ Approver Queue
                    BX041 FAE-EUR Approver Queue
                    BX041 FAE-US Approver Queue
    */
    /*
    public static map<id,list<id>> getFAEApprover(List<BX_041__c> bx041List){
        
        map<id,list<id>> result = new map<id,list<id>>();
                
        Map<string,list<id>> faeQueueMap = new Map<string, list<id>>();
                    
        for(GroupMember gm : [SELECT GroupId,
                                     Group.Name,
                                     UserOrGroupId
                                FROM GroupMember
                                where   Group.Type = 'Queue' 
                                    and Group.Name like 'BX041 FAE-%' 
                                order by groupId]){
            String usrid  = String.valueOf(gm.UserOrGroupId);
            if(usrid.startsWith('005')){
                if(faeQueueMap.containsKey(gm.group.name)){
                    faeQueueMap.get(gm.group.name).add(gm.UserOrGroupId);
                }else{
                    list<id> usrList = new list<id>{gm.UserOrGroupId};
                    faeQueueMap.put(gm.group.name, usrList);
                }   
            }
        }
        
        if(!faeQueueMap.isEmpty()){
            for(BX_041__c bx041 : bx041List){
                String faeQueueName = 'BX041 FAE-'+ bx041.Device__r.Account__r.Region__c +' Approver Queue'; 
                if(faeQueueMap.containskey(faeQueueName)){
                    result.put(bx041.id, faeQueueMap.get(faeQueueName));
                }
            }
        }
    
        return result;
    }*/
    
    /*
    Method :        Retrieve PO Recipients Email list
    Paremeter:      List<BX_041__c> - bx041List
    Return Type:    map<id,list<string>> - bx041ID --> Email List
    Required Field: BX_041__c.id
                              device__r.account__c
    Custom Setting: Environment_Variable__c.ACCT_TM_PRXY_TM_RL_AM
                    Environment_Variable__c.ACCT_TM_PRXY_TM_RL_PCSR
                    Environment_Variable__c.ACCT_TM_PRXY_TM_RL_BCSR
                    Environment_Variable__c.ACCT_TM_PRXY_TM_RL_CSR
    History:      18/11/13 Thomas : Created
    */
    public static map<id,list<id>> getPOApprover(List<BX_041__c> bx041List){
        
        map<id,list<id>> result = new map<id,list<id>>();
        set<id> acctIdSet = new set<id>();
        for(BX_041__c bx041 : bx041List){
            acctIdSet.add(bx041.device__r.account__c);
        }
        // send notification to AM if PAM not found
        // send notofication to BCSR if PCSR not found; Send notification to CSR if BCSR not found
        if(!acctIdSet.isEmpty()){
            list<String> roleList  = new String[]{Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_AM').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PAM').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PCSR').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_CSR').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_BCSR').value__c};
            map<id, list<id>> acc2POMap = new map <id, list<id>> ();
            list<id> csrList = new list<id>();  
            //list<id> amList = new list<id>(); 
            boolean hasPrmCsr  = false;
            boolean hasPrmAm  = false;
            id accId = null; 
            boolean firstCsr = false;
            for(Account_Team_Proxy__c proxy : [select User__c,Account__c,Team_Role__c
                                                from Account_Team_Proxy__c 
                                                where Account__c = :acctIdSet 
                                                    and Team_Role__c in :roleList
                                                    and User__r.isActive = true
                                                order by Account__c, Team_Role__c desc]){
                system.debug('$$$$$'+proxy.user__c + '$$$$'+ proxy.Team_role__c);
                if(acc2POMap.containsKey(proxy.Account__c)){    
                    
                    if (proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PAM').value__c){
                        hasPrmAm = true;
                    }else if(proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_CSR').value__c){
                        if(!hasPrmCsr) csrList.add(proxy.User__c);
                        continue;
                    }else if (proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_BCSR').value__c){
                        if(hasPrmCsr) continue;
                        hasPrmCsr = true;
                    }else if (proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_AM').value__c){
                        if(hasPrmAm) continue;
                    }else if(proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PCSR').value__c){
                        hasPrmCsr = true;
                    }
                              
                    acc2POMap.get(proxy.Account__c).add(proxy.User__c);
                    
                }else{
                    // Set CSR as recipients if no primary or backup CSR found.
                    if(accId != null && !hasPrmCsr && !csrList.isEmpty()){
                        acc2POMap.get(accId).addAll(csrList);
                    }
                    /*
                    if(accId != null && !hasPrmAm && !amList.isEmpty()){
                        acc2POMap.put(accId,amList);
                    }*/
                    // reset viarables
                    accId = proxy.Account__c;
                    csrList = new list<id>();
                    //amList = new list<id>();
                    hasPrmCsr = false;
                    hasPrmAm = false;
                    firstCsr = false;
                    
                    if(proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PCSR').value__c){
                        hasPrmCsr = true;
                    }else if (proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PAM').value__c){
                        hasPrmAm = true;
                    } else if(proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_CSR').value__c){
                        if(!hasPrmCsr) {
                            csrList.add(proxy.User__c);
                            acc2POMap.put(proxy.Account__c, new list<String>());
                        }
                        continue;  
                    }else if(proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_BCSR').value__c){
                        if(hasPrmCsr) continue;
                        hasPrmCsr = true;
                    }else if (proxy.Team_Role__c == Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_AM').value__c){
                        if(hasPrmAm) continue;
                    }
                    
                    
                    list<String> usrList = new list<String>{proxy.User__c};
                    acc2POMap.put(proxy.Account__c, usrList);
                }
                
            }  
            
            if(accId != null && !hasPrmCsr && !csrList.isEmpty()){
                acc2POMap.get(accId).addAll(csrList);
            }
                    
            if(!acc2POMap.isEmpty()){
                for(BX_041__c bx041 : bx041List){
                    if(acc2POMap.containskey(bx041.device__r.Account__c)){
                        result.put(bx041.id, acc2POMap.get(bx041.device__r.Account__c));
                        system.debug('&&&&&&&&'+acc2POMap.get(bx041.device__r.Account__c).size());
                        system.debug('&&&&&&&&'+acc2POMap.get(bx041.device__r.Account__c));
                    }
                }   
            }
        }
        
        return result;
    }
    
    public static void sendEmailOne(BX_041__c bx041, String template, String comment){//for submission and rejection
        list<BX041EmailHandler.EmailWrapper> bx041WrpList = new list<BX041EmailHandler.EmailWrapper>();
        BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
        wrp.templateName = template;
        wrp.recId = bx041.id;
        wrp.stackHolder = new map<String, String>();
        wrp.stackHolder.put('{BacktrackComment}', comment);
        //setBodyNSub(bx041, wrp, comment);
        wrp.targetObjSet = new set<id>();
        
        if(bx041.Approval_Step__c == 'Pending for CE'){//reject by PIYE or submit for apporval by FTS
            map<id,list<id>> ceMap = BX041EmailHandler.getCEApprover(new BX_041__c[]{bx041});
            if(ceMap.containsKey(wrp.recId)){
                wrp.targetObjSet.addAll(ceMap.get(wrp.recId));
            }
            
        } else if(bx041.Approval_Step__c == 'Pending for FAE/FTS'){
            map<id,list<id>> customerMap = BX041EmailHandler.getFAEFTSApprover(new BX_041__c[]{bx041});
            if(customerMap.containsKey(wrp.recId)){
                wrp.targetObjSet.addAll(customerMap.get(wrp.recId));
            }
        } /*else if(bx041.Approval_Step__c == 'Pending for FAE'){
            map<id,list<id>> customerMap = BX041EmailHandler.getFAEApprover(new BX_041__c[]{bx041});
            if(customerMap.containsKey(wrp.recId)){
                wrp.targetObjSet.addAll(customerMap.get(wrp.recId));
            }
            
        } else if(bx041.Approval_Step__c == 'Pending for PIYE'){
            map<id,list<id>> piyeMap = BX041EmailHandler.getPIYEApprover(new BX_041__c[]{bx041});
            if(piyeMap.containsKey(wrp.recId)){
                wrp.targetObjSet.addAll(piyeMap.get(wrp.recId));
            }
        } */
        
        if(!wrp.targetObjSet.isEmpty()){
            bx041WrpList.add(wrp);
            BX041EmailHandler.sendEmail(bx041WrpList);
        }
    }
    public static void sendEmailAllInOne(map<string, list<BX_041__c> > bx041Map){//for closed and Frozen/Pending PID 
                                                                                //18/11/13 Thomas: PO Issuance
        list<BX041EmailHandler.EmailWrapper> bx041WrpList = new list<BX041EmailHandler.EmailWrapper>();
        //18/11/13 Thomas: PO Issuance
        if(bx041Map.containsKey('GF_Device_Requirement_PO_Issuance_Approved_Template')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Requirement_PO_Issuance_Approved_Template');
            if(!bx041List.isEmpty()){
                map<id,list<id>> poMap = BX041EmailHandler.getPOApprover(bx041List);
                
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Requirement_PO_Issuance_Approved_Template';
                    wrp.recId = bx041.id;
                    /* populate targetObjSet */
                    wrp.targetObjSet = new set<id>();
                    if(poMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(poMap.get(wrp.recId));
                    }
                    
                    //setBodyNSub(bx041, wrp, '');
                    
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
        }
        
        if(bx041Map.containsKey('GF_Device_Requirements_Closed_Template')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Requirements_Closed_Template');
            if(!bx041List.isEmpty()){
                map<id,list<id>> ceMap = BX041EmailHandler.getCEApprover(bx041List);
                map<id,list<id>> ftsMap = BX041EmailHandler.getFAEFTSApprover(bx041List); 
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Requirements_Closed_Template';
                    wrp.recId = bx041.id;
                    /* populate targetObjSet */
                    wrp.targetObjSet = new set<id>();
                    if(ceMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(ceMap.get(wrp.recId));
                    }
                    
                    if(ftsMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(ftsMap.get(wrp.recId));
                    }
                    
                    //setBodyNSub(bx041, wrp, '');
                    
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
        }
        if(bx041Map.containsKey('GF_Device_Frozen_Pending_PID_Assignment_Template')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Frozen_Pending_PID_Assignment_Template');
            if(!bx041List.isEmpty()){
                map<id,list<id>> piyeMap = BX041EmailHandler.getPiyeApprover(bx041List);
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Frozen_Pending_PID_Assignment_Template';
                    wrp.recId = bx041.id;
                    
                    wrp.targetObjSet = new set<id>();
                    if(piyeMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(piyeMap.get(wrp.recId));
                    }
                    //setBodyNSub(bx041, wrp, '');
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
            
        } 
        
        if(bx041Map.containsKey('GF_Device_Requirements_Rejected_Email_Template_4FAEFTS')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4FAEFTS');
            if(!bx041List.isEmpty()){
                
                map<id,list<id>> customerMap = BX041EmailHandler.getFAEFTSApprover(bx041List);
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Requirements_Rejected_Email_Template';
                    wrp.recId = bx041.id;
                    
                    wrp.targetObjSet = new set<id>();
                    if(customerMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(customerMap.get(wrp.recId));
                    }
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
        } 
        
        
        if(bx041Map.containsKey('GF_Device_Requirements_Rejected_Email_Template_4CE')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4CE');
            if(!bx041List.isEmpty()){
                
                map<id,list<id>> ceMap = BX041EmailHandler.getCEApprover(bx041List);
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Requirements_Rejected_Email_Template';
                    wrp.recId = bx041.id;
                    
                    wrp.targetObjSet = new set<id>();
                    if(ceMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(ceMap.get(wrp.recId));
                    }
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
        } 
        
        if(bx041Map.containsKey('GF_Device_Requirements_Rejected_Email_Template_4Customer')){
            list<BX_041__c> bx041List = bx041Map.get('GF_Device_Requirements_Rejected_Email_Template_4Customer');
            if(!bx041List.isEmpty()){
                
                map<id,list<id>> customerMap = BX041EmailHandler.getCustomerSubmitter(bx041List);
                
                for(BX_041__c bx041 : bx041List){
                    BX041EmailHandler.EmailWrapper wrp = new BX041EmailHandler.EmailWrapper();
                    
                    wrp.templateName = 'GF_Device_Requirements_Rejected_Email_Template';
                    wrp.recId = bx041.id;
                    
                    wrp.targetObjSet = new set<id>();
                    if(customerMap.containsKey(wrp.recId)){
                        wrp.targetObjSet.addAll(customerMap.get(wrp.recId));
                    }
                    if(!wrp.targetObjSet.isEmpty()){
                        bx041WrpList.add(wrp);
                    }
                }
            }
        } 
        
        if(!bx041WrpList.isEmpty()){
            BX041EmailHandler.sendEmail(bx041WrpList);
        }
    }
    
    public static map<id, list<id>> getFAEFTSApprover(List<BX_041__c> bx041List){
        
        
        map<id,list<id>> result = new map<id,list<id>>();
        //Get FTS approvers
        set<id> acctIdSet = new set<id>();
        for(BX_041__c bx041 : bx041List){
            acctIdSet.add(bx041.device__r.account__c);
        }
            
        list<string> roleList = new list<string>{ Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_PFTS').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FTS').value__c,
                                                  Environment_Variable__c.getInstance('ACCT_TM_PRXY_TM_RL_FAE').value__c
                                                    };
        map<id, list<id>> acct2FTSMap = new map <id, list<id>> ();
                
        for(Account_Team_Proxy__c proxy : [SELECT User__c,Account__c
                                            FROM Account_Team_Proxy__c 
                                            WHERE Account__c = :acctIdSet 
                                                AND (    Team_Role__c = :roleList
                                                    OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                    OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                                AND User__r.isActive = true
                                            ORDER BY Account__c,Team_Role__c desc]){
            
            if(acct2FTSMap.containsKey(proxy.Account__c)){              
                acct2FTSMap.get(proxy.Account__c).add(proxy.User__c);
            }else{
                list<String> usrList = new list<String>{proxy.User__c};
                acct2FTSMap.put(proxy.Account__c, usrList);
            }
        }  
        
        // get FAE approvers
        Map<string,list<id>> faeQueueMap = new Map<string, list<id>>();
                    
        for(GroupMember gm : [SELECT GroupId,
                                     Group.Name,
                                     UserOrGroupId
                                FROM GroupMember
                                where   Group.Type = 'Queue' 
                                    and Group.Name like 'BX041 FAE-%' 
                                order by groupId]){
            String usrid  = String.valueOf(gm.UserOrGroupId);
            if(usrid.startsWith('005')){
                if(faeQueueMap.containsKey(gm.group.name)){
                    faeQueueMap.get(gm.group.name).add(gm.UserOrGroupId);
                }else{
                    list<id> usrList = new list<id>{gm.UserOrGroupId};
                    faeQueueMap.put(gm.group.name, usrList);
                }   
            }
        }
        
        for(BX_041__c bx041 : bx041List){
            String faeQueueName = 'BX041 FAE-'+ bx041.Device__r.Account__r.Region__c +' Approver Queue'; 
            if(!acct2FTSMap.isEmpty() && acct2FTSMap.containskey(bx041.device__r.Account__c)){
                result.put(bx041.id, acct2FTSMap.get(bx041.device__r.Account__c));
            }
            if(!faeQueueMap.isEmpty() && faeQueueMap.containskey(faeQueueName)){
                if(result.containsKey(bx041.id)){
                    result.get(bx041.id).addAll(faeQueueMap.get(faeQueueName));
                } else{
                    result.put(bx041.id, faeQueueMap.get(faeQueueName));
                }
                
            }
        }
        return result;
    
    }
}