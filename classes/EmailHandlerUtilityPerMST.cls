/**
* This is the Email Configuration utility class for record types MST,MST_Reviewer_Notification,MST_No_Mask_Layers
**/

public class EmailHandlerUtilityPerMST {
    // email config delimiter
    private static string configDelimiter=',';
    
    /**
        This is a method for sending emails for record type 'MST_No_Mask_Layers' according to email config configuration
        @method name: sendEmailPerMSTNoMaskLayer
        @param:   string {template developer name}, string {Mask Set Title Name}, list<string> {list of Layers from Pairing table}
        @return : none
    **/
    public static void sendEmailPerMSTNoMaskLayer(string templateDevName,string maskSetTitleName, list<string> listLayer) {
        try {
            if(string.isBlank(templateDevName) || (listLayer==null || listLayer.isEmpty())) {
                return;
            }
            list<EmailTemplate> etList =[Select Id,Name,DeveloperName,Subject,Body,HtmlValue from EmailTemplate where DeveloperName=:templateDevName];
            list<Email_Config_Settings__c> ecsList;
            if(etList!=null && !etList.isEmpty()) {
                EmailTemplate et = etList.get(0);
                ecsList = [SELECT Id,Name,MPW_PTRF__c,TO__c,CC__c,BCC__c FROM Email_Config_Settings__c WHERE Email_Template_Name__c = :et.DeveloperName  
                                                                            AND RecordType.DeveloperName = 'MST_No_Mask_Layers' 
                                                                            AND Available_For_Use__c=true];
                boolean mpwMST; // flag for MPW mst
                if(ecsList!=null && !ecsList.isEmpty()) {                                                   
                    // Building Email Recipient wrapper list parsing To,CC,BCC fields of Email Config Setting records
                    list<EmailRecipientWrapper> recipientWrapperList = parseRecipientString(ecsList);
                
                    maskSetTitleName = (maskSetTitleName==null)?'':maskSetTitleName;
                    // set flag for MPW mst
                    mpwMST=maskSetTitleName.startsWith('MPW')?true:false;
                    // comma-separated layer details
                    string layerString = string.join(listLayer,',');
                    
                    if(ecsList!=null && !ecsList.isEmpty()) {
                        Messaging.SingleEmailMessage[] singleEmailMessageList = new Messaging.SingleEmailMessage[]{};
                        OrgWideEmailAddress orgEmailAddress = [Select Id,DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
                        integer ecsCounter = 0;
                        // internal set for avoiding duplicate emails in list
                        set<string> setUniqueEmail = new set<string>();
                        // to list
                        list<string> toList = new list<string>();
                        // cc list
                        list<string> ccList = new list<string>();
                        // bcc list
                        list<string> bccList = new list<string>();  
                        for(Email_Config_Settings__c ecs : ecsList) {
                            if(ecs.MPW_PTRF__c!=mpwMST) {
                                ecsCounter++;
                                continue;
                            }
                            toList.clear();
                            ccList.clear();
                            bccList.clear();
                            // to list preparation
                            setUniqueEmail.clear();
                            setUniqueEmail.addAll(recipientWrapperList.get(ecsCounter).toList);
                            toList.addAll(setUniqueEmail);
                            
                            // CC list preparation
                            setUniqueEmail.clear();
                            setUniqueEmail.addAll(recipientWrapperList.get(ecsCounter).ccList);
                            ccList.addAll(setUniqueEmail);
                            
                            // BCC list preparation
                            setUniqueEmail.clear();
                            setUniqueEmail.addAll(recipientWrapperList.get(ecsCounter).bccList);
                            bccList.addAll(setUniqueEmail);
                            
                            /** Email Subject and Body preparaion **/
                            /** prepare email subject **/
                            string subject = et.subject==null?'':et.subject;
                            subject = subject.replace('<MRS.Mask Set Title>',maskSetTitleName);
                            
                            /** prepare email body **/
                            string emailBody = et.Body==null?'':et.Body;
                            // add mask set title name
                            emailBody = emailBody.replace('<MRS.Mask Set Title>',maskSetTitleName);
                            emailBody = emailBody.replace('<MRS.Mask Layer Details>',layerString);
                            emailBody = emailBody.replace('<ECS No>','ECS : '+ecsList.get(ecsCounter).Name);    // Added for ECS Number
                            // add to list of single email message
                            singleEmailMessageList.addAll(MRSHandlerUtility.partingToCCBccAddress((string[])toList,(string[])ccList,(string[])bccList,orgEmailAddress,false,subject,emailBody));
                            
                            ecsCounter++;
                        }
                        system.debug('$$singleEmailMessageList: ' + singleEmailMessageList);
                        system.debug('$$singleEmailMessageListSize: ' + singleEmailMessageList.size());
                        if(singleEmailMessageList.size() > 0){
                            Messaging.SendEmailResult[] listSendEmailResult = Messaging.sendEmail(singleEmailMessageList);
                        }
                    }
                } 
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','sendEmailPerMSTNoMaskLayer');
        }                                                                                                          
    }
    /**
        This is an overloaded method for sending emails for 'MST' record type according to email configuration
        @method name: sendEmailPerMST
        @param:   string {template developer name}, list<MRS_Layer_Association__c> {list of MRS Layer Association records}, string {comments}
        @return :     none
    **/
    public static void sendEmailPerMST(string templateDevName,list<MRS_Layer_Association__c> listMRSLayerAssoc,string comments) {
        try {
            
            //SWGP-1168: stop release email for fab 9,10
            //if email template = 'SWIFT_Layer_is_Released_For_Mask_Write' >>> add-in restrict by fab 9,10
            
            sendEmailPerMST(templateDevName,listMRSLayerAssoc,null,null,comments);
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','sendEmailPerMST');
        }                                                                                                               
    }
    /**
        This is an overloaded for sending Emails for 'MST' record type according to email configuration
        @method name: sendEmailPerMST
        @param:   string {template developer name}, list<MRS_Layer_Association__c> {list of MRS Layer Association records}, 
                      list<MRS_Layer_Chip_Association__c> {list of MRS Layer Chip Association records}, string {comments}
        @return :     none
    **/
    public static void sendEmailPerMST(string templateDevName, list<MRS_Layer_Association__c> listMRSLayerAssoc, list<MRS_Layer_Chip_Association__c> listMRSChipLayerAssoc,
                                       string comments) {
        try {
            sendEmailPerMST(templateDevName,listMRSLayerAssoc,listMRSChipLayerAssoc,null,comments);
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','sendEmailPerMST');
        }
    }
    
    /**
        This is an overloaded method for sending Emails for 'MST' record type according to email configuration
        @method name: sendEmailPerMST
        @param:   string {template developer name}, list<MRS_Layer_Association__c> {list of MRS Layer Association records}, 
                      list<MRS_Layer_Chip_Association__c> {list of MRS Layer Chip Association records}, 
                      set<string> {PTRF Number set}, string {comments}
        @return :     none
    **/
    public static void sendEmailPerMST(string templateDevName, list<MRS_Layer_Association__c> listMRSLayerAssoc, list<MRS_Layer_Chip_Association__c> listMRSChipLayerAssoc,
                                                    set<string> setPTRFNumber, string comments) {
        try {
            if(string.isBlank(templateDevName) || ((listMRSLayerAssoc==null || listMRSLayerAssoc.isEmpty()) && (listMRSChipLayerAssoc==null || listMRSChipLayerAssoc.isEmpty())) ) {
                return;
            }
            list<EmailTemplate> etList =[Select Id,Name,DeveloperName,Subject,Body,HtmlValue from EmailTemplate where DeveloperName=:templateDevName];
            if(etList!=null && !etList.isEmpty()) {
                list<Email_Config_Settings__c> ecsList = [SELECT Id,Name,TO__c,CC__c,BCC__c,Customer_Jobviewer_Type__c,Send_Mail_To_Customer__c,
                                                                Foundry_Jobviewer_Type__c,MPW_PTRF__c,
                                                                Send_Mail_To_Customer_AS_Submitter__c,Tech_Geo_Value__c                                                      
                                                         FROM Email_Config_Settings__c 
                                                         WHERE Email_Template_Name__c = :etList.get(0).DeveloperName AND RecordType.DeveloperName = 'MST' AND Available_For_Use__c=true];
                if(ecsList!=null && !ecsList.isEmpty()) {
                    sendEmailPerConfig(etList.get(0),ecsList,listMRSLayerAssoc,listMRSChipLayerAssoc,setPTRFNumber,comments);
                }
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','sendEmailPerMST');
        }
    }
    
    /**
        This is an internal method for sending Emails per Email Config record, called from sendEmailPerMST public methods
        @method name: sendEmailPerConfig
        @param:   EmailTemplate {email template}, list<Email_Config_Settings__c> {email config records},
                  list<MRS_Layer_Association__c> {list of MRS Layer Association records}, 
                  list<MRS_Layer_Chip_Association__c> {list of MRS Layer Chip Association records},
                  set<string> {PTRF Number set}, string {comments}
        @return :     none
    **/
    private static void sendEmailPerConfig(EmailTemplate et,list<Email_Config_Settings__c> ecsList,list<MRS_Layer_Association__c> listMRSLayerAssoc,
                       list<MRS_Layer_Chip_Association__c> listMRSChipLayerAssoc, set<string> setPTRFNumber, string comments) {
        try {
            // Building Email Recipient wrapper list parsing To,CC,BCC fields of Email Config Setting records
            list<EmailRecipientWrapper> recipientWrapperList = parseRecipientString(ecsList);
            
            // declaration of maps keying ECS Id-Account Id concatenation
            map<string,set<string>> mapMaskLayerTECN = new map<string,set<string>>();
            map<string,set<Id>> mapMRSLayerAssoIds = new map<string,set<Id>>();
            map<string,list<MRS_Layer_Chip_Association__c>> mapMRSLayerChipList = new map<string,list<MRS_Layer_Chip_Association__c>>();
            map<string,list<TECN__c>> mapTECNList = new map<string,list<TECN__c>>();
            map<string,set<string>> mapOriginatorSet = new map<string,set<string>>();
            map<string,set<Id>> mapAccountId = new map<string,set<Id>>();
            map<string,set<string>> mapPTRFSubmitterEmail = new map<string,set<string>>();
            map<string,set<Id>> mapPTRFId = new map<string,set<Id>>();
            map<string,set<string>> mapATPEmail = new map<string,set<string>>();
            map<string,set<string>> mapTECNOriginatorEmail = new map<string,set<string>>();
            map<string,list<string>> mapCJVEmail = new map<string,list<string>>();
            map<string,list<string>> mapFJVEmail = new map<string,list<string>>();
            map<string,list<string>> mapFABEmail = new map<string,list<string>>();
            map<string,set<string>> mapPTRFSet = new map<string,set<string>>();
            map<string,set<string>> mapCustomerEmail = new map<string,set<string>>();
            map<string,set<Id>> mapContactId = new map<string,set<Id>>();
            
            // other map variables
            map<string,User> originatorNameMap = new map<string,User>();
            map<string,list<string>> mapFabDistList = new map<string,list<string>>();
            map<Id,map<string,string>> mapECSToCcBcc = new map<Id,map<string,string>>();
            map<Id,Email_Config_Settings__c> mapECS = new map<Id,Email_Config_Settings__c>();
            map<Id,integer> mapECSCounter = new map<Id,integer>();
            
            // other variables
            string maskSetTitleName = listMRSLayerAssoc.get(0).Mask_Set_Title_Name__c;
            boolean mpwMST = false;
            if(!string.isBlank(maskSetTitleName) && (maskSetTitleName.startsWith('MPW'))) {
                mpwMST = true;
            }
            // Comma separated PTRF Number
            string ptrfNumberString='';
            if(setPTRFNumber!=null) {
                list<string> listPTRFNumber = new list<string>();
                listPTRFNumber.addAll(setPTRFNumber);
                ptrfNumberString = string.join(listPTRFNumber,',');
            }
            // flag indicating whether or not to query MRS Layer Chip Association records
            boolean mrsLayerChipListNotEmpty = (listMRSChipLayerAssoc==null || listMRSChipLayerAssoc.isEmpty()) ? false : true;
            // current user
            User currentUser = [SELECT Id,Name,Portal_Email__c,AccountId,UserName FROM User WHERE Id = :UserInfo.getUserId()].get(0);
            
            // Set containing templates where mails are sent to RMG group if current user is in RMG group
            set<string> setSendMailToRMGTemplates=new set<string>{'Swift_Hold_Mask_Write_for_Layer_Chip','Swift_Resume_Mask_Write_for_Layer_Chip',
                                                'Swift_Hold_Mask_Write_for_Layer','Swift_Resume_Mask_Write_for_Layer'};
            
            // variables for RMG group email                                
            list<string> rmgEmailList;
            boolean sendMailToRMG=false;
            if(setSendMailToRMGTemplates.contains(et.DeveloperName) && isGroupUser(currentUser.Id,new list<string>{'SWIFT_RMG'})) {
                Environment_Variable__c envConfig = Environment_Variable__c.getInstance('SWIFT_RMG_EMAIL');
                if(envConfig != null && (envConfig.Value__c != null)) {
                    rmgEmailList = envConfig.Value__c.split(';');
                }
                sendMailToRMG=true;
            }
            
            // set containing templates where mail is sent to logged in user in CC
            set<string> setSendMailToUserTemplates = new set<string>{'Swift_Hold_Mask_Write_for_Layer','Swift_Resume_Mask_Write_for_Layer',
                        'Swift_Hold_Mask_Write_for_Layer_Chip','Swift_Resume_Mask_Write_for_Layer_Chip'};
            
            // set containing templates where mail is sent to TECN originators
            set<string> setSendMailToTECNOriginatorsTemplates = new set<string>{'Swift_Mask_Write_is_hold_due_to_unreleased_TECN'};
            
            // flag indicating whether to send mail to User or not          
            boolean sendMailToUser=setSendMailToUserTemplates.contains(et.DeveloperName)?true:false;
            
            // set containing templates where mail is sent to Customers having same account as logged in user
            set<string> setSendMailToCustomerTemplates = new set<string>{'Swift_Hold_Mask_Write_for_Layer','Swift_Resume_Mask_Write_for_Layer'};
            
            // flag indicating whether to send mail to Customers only when related account is same as current user account
            boolean checkCurrentUserAccountId = setSendMailToCustomerTemplates.contains(et.DeveloperName)?true:false;
            
            // conditional boolean flags for deciding whether to execute certain code for emails
            boolean tecnOriginatorsRequired = false;
            boolean atpRequired = false;
            boolean ptrfSubmitterRequired = false;
            boolean jobviewerEmailRequired = false;
            boolean fabEmailRequired = false;
            boolean customerEmailRequired = false;
            
            // initializing ECS maps and flags
            integer ecsCounter=0;
            for(Email_Config_Settings__c ecs : ecsList) {
                mapECSToCcBcc.put(ecs.Id, new map<string,string>());
                mapECS.put(ecs.Id,ecs);
                mapECSCounter.put(ecs.Id,ecsCounter);
                ecsCounter++;
                // variables for To,CC,BCC fields
                string ecsTo,ecsCc,ecsBcc;
                
                // set values to boolean flags based on hashtag presence
                if(ecs.To__c != null){
                    ecsTo = ecs.To__c.replaceAll('\\s+','')+'#';
                    mapECSToCcBcc.get(ecs.Id).put('to',ecsTo);
                    
                    jobviewerEmailRequired = jobviewerEmailRequired || ecsTo.containsIgnorecase('#CJV#') || ecsTo.containsIgnorecase('#FJV#')?true:false;
                    fabEmailRequired = fabEmailRequired || ecsTo.containsIgnorecase('#FAB#')?true:false;
                    atpRequired = atpRequired || ecsTo.containsIgnorecase('#ATP#')?true:false;
                    ptrfSubmitterRequired = ptrfSubmitterRequired || (ecs.Send_Mail_To_Customer_AS_Submitter__c && ecsTo.containsIgnorecase('#PTRFSubmitter#'))?true:false;
                    customerEmailRequired = customerEmailRequired || (ecs.Send_Mail_To_Customer__c && ecsTo.containsIgnorecase('#Customer#'))?true:false;
                }
                if(ecs.CC__c != null){
                    ecsCc = ecs.CC__c.replaceAll('\\s+','')+'#';
                    mapECSToCcBcc.get(ecs.Id).put('cc',ecsCc);
                    
                    jobviewerEmailRequired = jobviewerEmailRequired || ecsCc.containsIgnorecase('#CJV#') || ecsCc.containsIgnorecase('#FJV#')?true:false;
                    fabEmailRequired = fabEmailRequired || ecsCc.containsIgnorecase('#FAB#')?true:false;
                    atpRequired = atpRequired || ecsCc.containsIgnorecase('#ATP#')?true:false;
                    ptrfSubmitterRequired = ptrfSubmitterRequired || (ecs.Send_Mail_To_Customer_AS_Submitter__c && ecsCc.containsIgnorecase('#PTRFSubmitter#'))?true:false;
                    customerEmailRequired = customerEmailRequired || (ecs.Send_Mail_To_Customer__c && ecsCc.containsIgnorecase('#Customer#'))?true:false;
                }
                if(ecs.BCC__c != null){
                    ecsBcc = ecs.BCC__c.replaceAll('\\s+','')+'#';
                    mapECSToCcBcc.get(ecs.Id).put('bcc',ecsBcc);
                    
                    jobviewerEmailRequired = jobviewerEmailRequired || ecsBcc.containsIgnorecase('#CJV#') || ecsBcc.containsIgnorecase('#FJV#')?true:false;
                    fabEmailRequired = fabEmailRequired || ecsBcc.containsIgnorecase('#FAB#')?true:false;
                    atpRequired = atpRequired || ecsBcc.containsIgnorecase('#ATP#')?true:false;
                    ptrfSubmitterRequired = ptrfSubmitterRequired || (ecs.Send_Mail_To_Customer_AS_Submitter__c && ecsBcc.containsIgnorecase('#PTRFSubmitter#'))?true:false;
                    customerEmailRequired = customerEmailRequired || (ecs.Send_Mail_To_Customer__c && ecsBcc.containsIgnorecase('#Customer#'))?true:false;
                }
            }
    
            // Check whether to execute code for sending mail to TECN Originators
            tecnOriginatorsRequired = setSendMailToTECNOriginatorsTemplates.contains(et.DeveloperName)?true:false;
            
            // Instantiating class for Subject & Body preparation
            EmailSubjectBodyPerMST objEmailSubjectBodyPerMST = new EmailSubjectBodyPerMST();
            
            // getting dymanic query for MRS Layer Chip and TECN objects
            list<string> dynamicQueryList = objEmailSubjectBodyPerMST.getDynamicQueries(et.DeveloperName);
            string mrsLayerChipQuery = dynamicQueryList.get(0);
            string tecnQuery = dynamicQueryList.get(1);
            
            /** Performing query for MRS Layer Chip Association**/
            
            set<Id> setMRSLayerAssoIds = new set<Id>();
            for(MRS_Layer_Association__c m : listMRSLayerAssoc){
                setMRSLayerAssoIds.add(m.Id);
            }
            set<Id> setMRSLayerChipId = new set<Id>();
            if(mrsLayerChipListNotEmpty) {
                for(MRS_Layer_Chip_Association__c m : listMRSChipLayerAssoc) {
                    setMRSLayerChipId.add(m.Id);
                }
                mrsLayerChipQuery += ' WHERE Id IN :setMRSLayerChipId';
            }
            else {
                mrsLayerChipQuery += ' WHERE Layer__c IN :setMRSLayerAssoIds';
            }
            
            
            //swgp-1168: stop rtm email for fab9,10
            
            String fabToStopRTMEmail = 'Fab9;Fab10';
            try { fabToStopRTMEmail = Environment_Variable__c.getInstance('SWIFT_FAB_VALUE_STOP_RTM_EMAIL').value__c; } catch(exception e) {fabToStopRTMEmail = 'Fab9;Fab10';}
                
            
            list<String> fabList = new list<String>();
            fabList = fabToStopRTMEmail.split(';');
            
            mrsLayerChipQuery += ' AND PTRF__r.Fab__c not in :fabList';
            //swgp-1168: end
            
            list<MRS_Layer_Chip_Association__c> listMRSLayerChipAssoc = new list<MRS_Layer_Chip_Association__c>();
            if(mrsLayerChipListNotEmpty || (!setMRSLayerAssoIds.isEmpty())) {
                listMRSLayerChipAssoc = Database.query(mrsLayerChipQuery);
            }
            
            // Building of map keying concatenation of ECS and Account
            set<string> setECSAccountKey = new set<string>();
            for(MRS_Layer_Chip_Association__c m : listMRSLayerChipAssoc) {
                // TASK-2476: code update by Saurav, Long add comments
                // The value of Customer_Name__c field from MRS Layer Chip Association records were taken. 
                // Since there were some record in production where Customer_Name__c field was blank, 
                // there was an Invalid Id error. Now the value PTRF__r.Customer__c will be taken.
                string accountIdStr = (m.PTRF__r.Customer__c==null)?'':m.PTRF__r.Customer__c;
                // TASK-2476_END
                for(Email_Config_Settings__c ecs : ecsList) {
                    string key = ecs.Id+'-'+accountIdStr;
                    setECSAccountKey.add(key);
                }
            }
            
            // initializing ECS-Account maps
            for(string ecsAccKey : setECSAccountKey) {
                mapMRSLayerChipList.put(ecsAccKey, new list<MRS_Layer_Chip_Association__c>());
                mapPTRFSubmitterEmail.put(ecsAccKey, new set<string>());
                mapFABEmail.put(ecsAccKey, new list<string>());
                mapAccountId.put(ecsAccKey, new set<Id>());
                mapPTRFId.put(ecsAccKey, new set<Id>());
                mapPTRFSet.put(ecsAccKey,new set<string>());
                mapMRSLayerAssoIds.put(ecsAccKey, new set<Id>());
                mapMaskLayerTECN.put(ecsAccKey, new set<string>());
                mapTECNList.put(ecsAccKey, new list<TECN__c>());
                mapOriginatorSet.put(ecsAccKey, new set<string>());
                mapTECNOriginatorEmail.put(ecsAccKey, new set<string>());
                mapCJVEmail.put(ecsAccKey, new list<string>());
                mapFJVEmail.put(ecsAccKey, new list<string>());
                mapATPEmail.put(ecsAccKey, new set<string>());
                mapContactId.put(ecsAccKey, new set<Id>());
                mapCustomerEmail.put(ecsAccKey, new set<string>());
            }
            
            // Fab distribution map preparation
            if(fabEmailRequired) {
                for(Fab_Distribution_Table__c f : [select id,Fab_No__c,Distribution_List__c from Fab_Distribution_Table__c]) {
                    if(f.Fab_No__c != null) {
                        string fabNo = f.Fab_No__c.toUppercase();
                        if(!mapFabDistList.containsKey(f.Fab_No__c)) {
                            mapFabDistList.put(fabNo, new list<string>());
                        }
                        if((f.Distribution_List__c != null) && f.Distribution_List__c.contains(';')) {
                            mapFabDistList.get(fabNo).addAll(f.Distribution_List__c.split(';'));
                        }
                        else if(f.Distribution_List__c != null) {
                            mapFabDistList.get(fabNo).add(f.Distribution_List__c);
                        }
                    }
                }
            }
            
            // looping all MRS Chip Layer Association and building PTRF Submitter CC list, Fab email list and other data structures
            Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');  // tech geo pattern for matching
            string fabStr,ptrfNumber;
            if(mrsLayerChipListNotEmpty || (!setMRSLayerAssoIds.isEmpty()) ) {
               Email_Config_Settings__c ecs;
               for(MRS_Layer_Chip_Association__c m : listMRSLayerChipAssoc) {
                    for(string ecsAccKey : setECSAccountKey) {
                        Id accId = (Id)ecsAccKey.substringAfter('-');
                        string ecsKey = ecsAccKey.substringBefore('-');
                        ecs = mapECS.get(ecsKey);
                        if( (string.isBlank(ecs.Tech_Geo_Value__c) || (!string.isBlank(ecs.Tech_Geo_Value__c) && 
                                (containsNumber(new list<string>{m.Layer__r.tech_geo_int__c},ecs.Tech_Geo_Value__c.split(';'),techGeoPattern)))) && 
                                (ecs.MPW_PTRF__c==mpwMST)  && (m.PTRF__r.Customer__c==accId)) {
                            
                            // map of MRS Layer Association ids
                            mapMRSLayerAssoIds.get(ecsAccKey).add(m.Layer__c);
                            // map of MRS Layer TECN Nos
                            if(tecnOriginatorsRequired && (m.Layer__r.LogicalOperation__c!=null)) {
                                mapMaskLayerTECN.get(ecsAccKey).addAll(m.Layer__r.LogicalOperation__c.split(';'));               
                            }
                            
                            // build map of MRS Layer Chip records to segregate records based on ECS-Account key
                            mapMRSLayerChipList.get(ecsAccKey).add(m);
                            
                            if(ptrfSubmitterRequired && (m.PTRF__r.Submitter__c!=null) && (m.PTRF__r.Submitter__r.isActive)) {
                                mapPTRFSubmitterEmail.get(ecsAccKey).add(m.PTRF__r.Submitter__r.Portal_Email__c);
                            }
                            if(fabEmailRequired) {
                                fabStr = m.PTRF__r.Fab__c!=null?m.PTRF__r.Fab__c.toUppercase():'';
                                if(mapFabDistList.containsKey(fabStr)) {
                                    mapFABEmail.get(ecsAccKey).addAll(mapFabDistList.get(fabStr));
                                }
                            }
                            mapAccountId.get(ecsAccKey).add(m.PTRF__r.Customer__c);
                            mapPTRFId.get(ecsAccKey).add(m.PTRF__c);
                            // if MRS Layer Chip records are passed as parameter prepare required data structures
                            if(mrsLayerChipListNotEmpty) {
                                ptrfNumber = m.PTRF__r.Name==null ? '' : m.PTRF__r.Name;
                                mapPTRFSet.get(ecsAccKey).add(ptrfNumber);
                            }
                        }
                    }
               }
            }
            
            /** Getting dynamic query for TECN parsing email template **/
            
            set<string> setMaskLayerTECN = new set<string>();
            for(set<string> s : mapMaskLayerTECN.values()) {
                setMaskLayerTECN.addAll(s);
            }
            if(tecnOriginatorsRequired) {
                tecnQuery += ' WHERE Related_TECN_No__c IN :setMaskLayerTECN AND TECN_Status__c!=\'Released\'';
            }
            else {
                tecnQuery += ' WHERE Related_TECN_No__c IN :setMaskLayerTECN';
            }
            
            // TECN Originators email list preparation and segregating data based on ECS
            if(!setMaskLayerTECN.isEmpty()) {
               for(TECN__c t : Database.query(tecnQuery)){
                   for(string ecsAccKey : setECSAccountKey) {
                        if(mapMaskLayerTECN.get(ecsAccKey).contains(t.Related_TECN_No__c)) {
                            mapTECNList.get(ecsAccKey).add(t);
                            if(tecnOriginatorsRequired && (t.Originator__c!=null)) {
                                mapOriginatorSet.get(ecsAccKey).add(t.Originator__c.trim().toLowerCase());
                                mapOriginatorSet.get(ecsAccKey).add(t.Originator__c.trim().toUpperCase());
                            }
                        }
                   }
               }
            }
            if(tecnOriginatorsRequired) {
                set<string> originatorSet = new set<string>();
                for(set<string> s : mapOriginatorSet.values()) {
                    originatorSet.addAll(s);
                }
                if(!originatorSet.isEmpty()) {
                    for(User objUser : [SELECT Id,Portal_Email__c,Name,HCM_Login_ID__c FROM User WHERE HCM_Login_ID__c IN :originatorSet AND IsActive=true]){
                        originatorNameMap.put(objUser.HCM_Login_ID__c,objUser);
                        for(string ecsAccKey : setECSAccountKey) {
                            if(mapOriginatorSet.get(ecsAccKey).contains(objUser.HCM_Login_ID__c)) {
                                mapTECNOriginatorEmail.get(ecsAccKey).add(objUser.Portal_Email__c);
                            }
                        }     
                    }
                }
            }
         
            // Customer and Foundry jobviewers email list preparation
            if(jobviewerEmailRequired) {
                set<Id> setPTRFId = new set<Id>();
                for(set<Id> s : mapPTRFId.values()){
                    setPTRFId.addAll(s);
                }
                if(!setPTRFId.isEmpty()) {
                    Email_Config_Settings__c ecs; // Email Config record            
                    for(PTRF_JobViewer_Info__c p : [SELECT PTRF__c,User__r.Portal_Email__c,Jobview__c,Jobview_Type__c,User__r.isActive FROM PTRF_JobViewer_Info__c WHERE PTRF__c IN :setPTRFId]){
                        for(string ecsAccKey : setECSAccountKey) {
                            ecs = mapECS.get(ecsAccKey.substringBefore('-'));
                            if(mapPTRFId.get(ecsAccKey).contains(p.PTRF__c) && (p.Jobview__c!=null) && p.User__r.isActive) {
                                list<string> ptrfJobviewTypeList = (p.Jobview_Type__c!=null)?p.Jobview_Type__c.split(';'):new list<string>();
                                if(p.Jobview__c == 'Customer') {
                                    if(!string.isBlank(ecs.Customer_Jobviewer_Type__c)) {
                                        list<string> ecsJobviewTypeList = ecs.Customer_Jobviewer_Type__c.split(';');
                                        if(containsAnyIgnorecase(ecsJobviewTypeList,ptrfJobviewTypeList)) {
                                            mapCJVEmail.get(ecsAccKey).add(p.User__r.Portal_Email__c);
                                        }
                                    }
                                    else {
                                        mapCJVEmail.get(ecsAccKey).add(p.User__r.Portal_Email__c);
                                    }
                                }
                                else if(p.Jobview__c == 'Foundry') {
                                    if(!string.isBlank(ecs.Foundry_Jobviewer_Type__c)) {
                                        list<string> ecsJobviewTypeList = ecs.Foundry_Jobviewer_Type__c.split(';');
                                        if(containsAnyIgnorecase(ecsJobviewTypeList,ptrfJobviewTypeList)) {
                                            mapFJVEmail.get(ecsAccKey).add(p.User__r.Portal_Email__c);
                                        }
                                    }
                                    else {
                                        mapFJVEmail.get(ecsAccKey).add(p.User__r.Portal_Email__c);
                                    }
                                }
                            }
                        }
                    }   
                }
            }
            
            set<Id> setAccountId = new set<Id>();
            for(set<Id> s : mapAccountId.values()) {
                setAccountId.addAll(s);
            }
            // Account Team Proxy email list preparation
            if(atpRequired && (!setAccountId.isEmpty())) {
                Environment_Variable__c envConfig = Environment_Variable__c.getInstance('SwiftFETeamRoles');
                list<string> teamRoleList = (envConfig!=null && envConfig.Value__c!=null)?envConfig.Value__c.split(','):(new list<string>());
                for(Account_Team_Proxy__c atp : [SELECT Account__c,User__c,User__r.Portal_Email__c 
                                                                FROM Account_Team_Proxy__c 
                                                                WHERE Account__c IN:setAccountId AND Team_Role__c IN :teamRoleList AND User__r.IsActive=true]) {
                    
                    for(string ecsAccKey : setECSAccountKey) {
                        if(!string.isBlank(atp.User__r.Portal_Email__c) && mapAccountId.get(ecsAccKey).contains(atp.Account__c)) {
                            mapATPEmail.get(ecsAccKey).add(atp.User__r.Portal_Email__c);
                        }
                    }
                }
            }
            //Customer email list preparation
            Id currentUserAccountId = currentUser.AccountId;
            if(customerEmailRequired && 
                    ( (!setAccountId.isEmpty() && (!checkCurrentUserAccountId)) || (checkCurrentUserAccountId && (currentUserAccountId!=null)) )) {
                map<Id,User> mapContactIdUser = new map<Id,User>();
                string userQuery = 'SELECT Id,AccountId,ContactId,Portal_Email__c FROM User ';
                if(currentUserAccountId!=null) {
                    userQuery += 'WHERE ((AccountId IN :setAccountId) OR (AccountId = :currentUserAccountId)) ';
                }
                else {
                    userQuery += 'WHERE AccountId IN :setAccountId ';
                }
                userQuery += 'AND isActive=true';
                
                for(User u : Database.query(userQuery)) {
                    mapContactIdUser.put(u.ContactId,u);
                    for(string ecsAccKey : setECSAccountKey) {
                        if((u.AccountId!=null) && mapAccountId.get(ecsAccKey).contains(u.AccountId)) {
                            mapContactId.get(ecsAccKey).add(u.ContactId);
                        }
                    }
                }
                set<Id> setContactId = mapContactIdUser.keySet();
                
                if(!setContactId.isEmpty()) {
                    User userObj;
                    for(Portal_Tab_Access__c p : [SELECT Id,Contact__c,My_Devices__c,PTRF__c FROM Portal_Tab_Access__c WHERE Contact__c IN :setContactId] ) {
                        for(string ecsAccKey : setECSAccountKey) {
                            if(p.My_Devices__c && p.PTRF__c && mapContactIdUser.containsKey(p.Contact__c)) {
                                userObj = mapContactIdUser.get(p.Contact__c);
                                if(!checkCurrentUserAccountId && mapContactId.get(ecsAccKey).contains(p.Contact__c)) {
                                    mapCustomerEmail.get(ecsAccKey).add(userObj.Portal_Email__c);
                                }
                                else if(checkCurrentUserAccountId && (userObj.AccountId==currentUserAccountId)) {
                                    mapCustomerEmail.get(ecsAccKey).add(userObj.Portal_Email__c);
                                }
                            }
                        }
                    }
                }
            }
            
            /** preparing data for email subject & body **/
            map<integer,list<MRS_Layer_Chip_Association__c>> queriedLayerChipAssociationData = new map<integer,list<MRS_Layer_Chip_Association__c>>();
            map<integer,list<TECN__c>> queriedTECNData = new map<integer,list<TECN__c>>();
            integer ecsAccCounter=0; // ECS-Acc Counter
            for(string ecsAccKey : setECSAccountKey) {
                if(mapMRSLayerAssoIds.get(ecsAccKey).isEmpty()){
                    ecsAccCounter++;
                    continue;
                }
                queriedLayerChipAssociationData.put(ecsAccCounter,mapMRSLayerChipList.get(ecsAccKey));
                queriedTECNData.put(ecsAccCounter,mapTECNList.get(ecsAccKey));
                ecsAccCounter++;
            }
            // name-value pair data   ------   Changed to key to uppercase.
            map<string,string> mapNameValuePair = new map<string,string>();
            mapNameValuePair.put('USER_NAME',currentUser.Name);
            mapNameValuePair.put('USER_ID',currentUser.Username);
            mapNameValuePair.put('REASON',comments);
            mapNameValuePair.put('PTRF_NUMBER',ptrfNumberString);
            
            map<integer,list<string>> mapSubjectBody = objEmailSubjectBodyPerMST.replaceSubjectAndContent(queriedLayerChipAssociationData,queriedTECNData,mapNameValuePair);
    
            Messaging.SingleEmailMessage[] singleEmailMessageList = new Messaging.SingleEmailMessage[]{};
            OrgWideEmailAddress orgEmailAddress = [Select Id,DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
            // internal set for avoiding duplicate emails in list
            set<string> setUniqueEmail = new set<string>();
            // to list
            list<string> toList = new list<string>();
            // cc list
            list<string> ccList = new list<string>();
            // bcc list
            list<string> bccList = new list<string>();
            // temporary list
            list<string> tempList = new list<string>();
            // variables for To,Cc,Bcc
            string ecsTo,ecsCc,ecsBcc;
            Email_Config_Settings__c ecs;
            Id accountId;
            ecsAccCounter = 0;
            for(string ecsAccKey : setECSAccountKey) {
                if(mapMRSLayerAssoIds.get(ecsAccKey).isEmpty()){
                    ecsAccCounter++;
                    continue;
                }
                toList.clear();
                ccList.clear();
                bccList.clear();
                // to list preparation
                setUniqueEmail.clear();
                ecs = mapECS.get(ecsAccKey.substringBefore('-'));
                accountId = (Id)ecsAccKey.substringAfter('-');
                if(mapECSToCcBcc.get(ecs.Id).containsKey('to')) {
                    ecsTo = mapECSToCcBcc.get(ecs.Id).get('to'); // to string
                    if(ecsTo.containsIgnorecase('#CJV#')) {
                        setUniqueEmail.addAll(mapCJVEmail.get(ecsAccKey));
                    }
                    if(ecsTo.containsIgnorecase('#FJV#')) {
                        setUniqueEmail.addAll(mapFJVEmail.get(ecsAccKey));
                    }
                    if(ecsTo.containsIgnorecase('#FAB#')) {
                        setUniqueEmail.addAll(mapFABEmail.get(ecsAccKey));
                    }
                    if(ecsTo.containsIgnorecase('#ATP#')) {
                        setUniqueEmail.addAll(mapATPEmail.get(ecsAccKey));
                    }
                    if(ecsTo.containsIgnorecase('#PTRFSubmitter#')) {
                        setUniqueEmail.addAll(mapPTRFSubmitterEmail.get(ecsAccKey));
                    }
                    if(ecsTo.containsIgnorecase('#Customer#')) {
                        setUniqueEmail.addAll(mapCustomerEmail.get(ecsAccKey));
                    }
                }
                // Checking whether to send mail to TECN Orginators or not
                if(tecnOriginatorsRequired) {
                    setUniqueEmail.addAll(mapTECNOriginatorEmail.get(ecsAccKey));
                }
                setUniqueEmail.addAll(recipientWrapperList.get(mapECSCounter.get(ecs.Id)).toList);
                toList.addAll(setUniqueEmail);
            
                // CC list preparation
                setUniqueEmail.clear();
                if(mapECSToCcBcc.get(ecs.Id).containsKey('cc')) {
                    ecsCc = mapECSToCcBcc.get(ecs.Id).get('cc'); // cc string
                    if(ecsCc.containsIgnorecase('#CJV#')) {
                        setUniqueEmail.addAll(mapCJVEmail.get(ecsAccKey));
                    }
                    if(ecsCc.containsIgnorecase('#FJV#')) {
                        setUniqueEmail.addAll(mapFJVEmail.get(ecsAccKey));
                    }
                    if(ecsCc.containsIgnorecase('#FAB#')) {
                        setUniqueEmail.addAll(mapFABEmail.get(ecsAccKey));
                    }
                    if(ecsCc.containsIgnorecase('#ATP#')) {
                        setUniqueEmail.addAll(mapATPEmail.get(ecsAccKey));
                    }
                    if(ecsCc.containsIgnorecase('#PTRFSubmitter#')) {
                        setUniqueEmail.addAll(mapPTRFSubmitterEmail.get(ecsAccKey));
                    }
                    if(ecsCc.containsIgnorecase('#Customer#')) {
                        setUniqueEmail.addAll(mapCustomerEmail.get(ecsAccKey));
                    }
                }
                // Checking whether to add RMG group in CC or not
                if(sendMailToRMG && rmgEmailList!=null) {
                    setUniqueEmail.addAll(rmgEmailList);
                }
                // Checking whether to send mail to User or not
                if(sendMailToUser /*&& ((currentUser.AccountId==null) || ((currentUser.AccountId!=null) && (currentUser.AccountId==accountId))) */) {
                    setUniqueEmail.add(currentUser.Portal_Email__c);
                }
                setUniqueEmail.addAll(recipientWrapperList.get(mapECSCounter.get(ecs.Id)).ccList);
                ccList.addAll(setUniqueEmail);
                
                // BCC list preparation
                setUniqueEmail.clear();
                if(mapECSToCcBcc.get(ecs.Id).containsKey('bcc')) {
                    ecsBcc = mapECSToCcBcc.get(ecs.Id).get('bcc'); // bcc string
                    if(ecsBcc.containsIgnorecase('#CJV#')) {
                        setUniqueEmail.addAll(mapCJVEmail.get(ecsAccKey));
                    }
                    if(ecsBcc.containsIgnorecase('#FJV#')) {
                        setUniqueEmail.addAll(mapFJVEmail.get(ecsAccKey));
                    }
                    if(ecsBcc.containsIgnorecase('#FAB#')) {
                        setUniqueEmail.addAll(mapFABEmail.get(ecsAccKey));
                    }
                    if(ecsBcc.containsIgnorecase('#ATP#')) {
                        setUniqueEmail.addAll(mapATPEmail.get(ecsAccKey));
                    }
                    if(ecsBcc.containsIgnorecase('#PTRFSubmitter#')) {
                        setUniqueEmail.addAll(mapPTRFSubmitterEmail.get(ecsAccKey));
                    }
                    if(ecsBcc.containsIgnorecase('#Customer#')) {
                        setUniqueEmail.addAll(mapCustomerEmail.get(ecsAccKey));
                    }
                }
                setUniqueEmail.addAll(recipientWrapperList.get(mapECSCounter.get(ecs.Id)).bccList);
                bccList.addAll(setUniqueEmail);
                
                /** Email Subject and Body preparaion **/
                
                list<string> dynSubjectBody = mapSubjectBody.get(ecsAccCounter);
                string subject = dynSubjectBody.get(0);
                string emailBody = dynSubjectBody.get(1);
                emailBody = emailBody.replace(']]>','').replace('<![CDATA[','');
                emailBody = emailBody.replace('#ECS','ECS : '+ecs.Name);          // Added for ECS Number
                // add to list of single email message
                singleEmailMessageList.addAll(MRSHandlerUtility.partingToCCBccAddress((string[])toList,(string[])ccList,(string[])bccList,orgEmailAddress,true,subject,emailBody));
                // increment ECS-Acc counter
                ecsAccCounter++;
            }
            system.debug('$$singleEmailMessageList: ' + singleEmailMessageList);
            system.debug('$$singleEmailMessageListSize: ' + singleEmailMessageList.size());
            if(singleEmailMessageList.size() > 0){
                Messaging.SendEmailResult[] listSendEmailResult = Messaging.sendEmail(singleEmailMessageList);
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','sendEmailPerConfig');
        }
    }
    
    /**
    * Returns a list of EmailRecipientWrapper corresponding to each Email Config Setting record after parsing to,cc,bcc
    * for generic tags #User,#Email or #Group
    **/
    private static list<EmailRecipientWrapper> parseRecipientString(list<Email_Config_Settings__c> ecsList) {
        // the list to return
        list<EmailRecipientWrapper> listEmailRecipientWrapper = new list<EmailRecipientWrapper>();
        try {
            // internal map
            map<Id,map<integer,set<string>>> mapUserName = new map<Id,map<integer,set<string>>>();
            // list of to, cc, bcc strings
            list<string> recipientStringList = new list<string>();
            // list of all usernames found from parsing
            list<string> userNameList = new list<string>();
            // list of all group names found from parsing
            list<string> groupNameList = new list<string>();
            // counter for ECS loop
            integer ecsCounter=0;
            // counter indicating whether parsing To, Cc or Bcc fields of ECS
            integer toCcBccCounter=0;
            
            // looping through ECS list
            for(Email_Config_Settings__c ecs : ecsList) {
                // initializing data structures
                recipientStringList.clear();
                recipientStringList.addAll(new list<string>{ecs.To__c,ecs.CC__c,ecs.BCC__c});
                toCcBccCounter=0;
                listEmailRecipientWrapper.add(new EmailRecipientWrapper());
                mapUserName.put(ecs.Id,new map<integer,set<string>>());
                boolean firstIteration; // first iteration of tags in To,Cc or Bcc
                // looping through To, Cc, Bcc fields
                for(string recipientString : recipientStringList) {
                    // initializing data structures
                    mapUserName.get(ecs.Id).put(toCcBccCounter, new set<string>());
                    // remove whitespaces from To, Cc or Bcc field
                    if(recipientString != null) {
                        recipientString = recipientString.replaceAll('\\s+','');
                    }
                    recipientStringList = (recipientString != null)?recipientString.split('#'):new list<string>();
                    // reset first iteration of inner for loop to true
                    firstIteration=true;
                    // looping within either of To, Cc or Bcc field
                    for(string rString : recipientStringList) {
                        if(firstIteration) {
                            firstIteration=false;
                            continue;
                        }
                        string key = (rString!=null)?rString.substringBefore(':'):'';
                        key = (key!=null)?key.trim():'';
                        if(key.equalsIgnorecase('User')) {
                            // parse User string
                            string userString = rString.substringafter(':');
                            userString = (userString != null)?userString.trim().toLowerCase():userString;
                            list<string> listUserNameString = (userString != null)?userString.split(configDelimiter):new list<string>();
                            // store username for query purpose
                            userNameList.addAll(listUserNameString);
                            mapUserName.get(ecs.Id).get(toCcBccCounter).addAll(listUserNameString);
                        }
                        else if(key.equalsIgnorecase('Email')) {
                            // parse Email string
                            string emailString = rString.substringafter(':');
                            emailString = (emailString != null)?emailString.trim():emailString;
                            list<string> emailList = (emailString != null)?emailString.split(configDelimiter):new list<string>();
                            if(emailList!=null && !emailList.isEmpty()) {
                                set<string> setEmail = new set<string>();
                                setEmail.addAll(emailList);
                                emailList = new list<string>();
                                emailList.addAll(EmailValidation.parseValidEmails(setEmail));
                            }
                            // add email to final list
                            if(toCcBccCounter==0) {
                                listEmailRecipientWrapper.get(ecsCounter).toList.addAll(emailList);
                            }
                            else if(toCcBccCounter==1) {
                                listEmailRecipientWrapper.get(ecsCounter).ccList.addAll(emailList);
                            }
                            else {
                                listEmailRecipientWrapper.get(ecsCounter).bccList.addAll(emailList);
                            }
                        }
                        else if(key.equalsIgnorecase('Group')) {
                            // parse Group string
                            string groupString = rString.substringafter(':');
                            groupString = (groupString != null)?groupString.trim():groupString;
                            list<string> listGroupNameString = (groupString != null)?groupString.split(configDelimiter):new list<string>();
                            if(listGroupNameString!=null) {
                                string csName;
                                for(string groupName : listGroupNameString) {
                                    csName = (groupName!=null?groupName.toUppercase():groupName)+'_EMAIL';
                                    if(Environment_Variable__c.getInstance(csName) != null && (Environment_Variable__c.getInstance(csName).Value__c != null)) {
                                        string groupStr = Environment_Variable__c.getInstance(csName).Value__c;
                                        list<string> groupEmailList = groupStr.split(';');
                                        // add email to final list
                                        if(toCcBccCounter==0) {
                                            listEmailRecipientWrapper.get(ecsCounter).toList.addAll(groupEmailList);
                                        }
                                        else if(toCcBccCounter==1) {
                                            listEmailRecipientWrapper.get(ecsCounter).ccList.addAll(groupEmailList);
                                        }
                                        else {
                                            listEmailRecipientWrapper.get(ecsCounter).bccList.addAll(groupEmailList);
                                        }   
                                    }
                                }
                            }
                        }
                    }
                    toCcBccCounter++;
                }
                ecsCounter++;
            }
            
            if(!userNameList.isEmpty()) {
                for(User u : [SELECT Id,UserName,Portal_Email__c FROM User WHERE Username IN :userNameList AND isActive=true]){
                    ecsCounter=0;
                    for(Email_Config_Settings__c ecs : ecsList) {
                        set<string> toUserName = mapUserName.get(ecs.Id).get(0);
                        set<string> ccUserName = mapUserName.get(ecs.Id).get(1);
                        set<string> bccUserName = mapUserName.get(ecs.Id).get(2);
                        
                        if(toUserName.contains(u.UserName)) {
                            listEmailRecipientWrapper.get(ecsCounter).toList.add(u.Portal_Email__c);
                        }
                        if(ccUserName.contains(u.UserName)) {
                            listEmailRecipientWrapper.get(ecsCounter).ccList.add(u.Portal_Email__c);
                        }
                        if(bccUserName.contains(u.UserName)) {
                            listEmailRecipientWrapper.get(ecsCounter).bccList.add(u.Portal_Email__c);
                        }
                        ecsCounter++;
                    }
                }
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','parseRecipientString');
        }
        return listEmailRecipientWrapper;
    }
    /**
    * Returns true if any element in the first list is also present in the second list (case-insensitive)
    * @param: list<string> {first list} , list<string> {second list}
    * @return: boolean
    **/
    private static boolean containsAnyIgnorecase(list<string> firstList, list<string> secondList) {
        try {
            if((firstList!=null) && (secondList!=null)) {
                for(string s1 : firstList) {
                    for(string s2 : secondList) {
                        if((s1!=null) && (s1.equalsIgnorecase(s2))) {
                            return true;
                        }
                    }
                }
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','containsAnyIgnorecase');
        }
        return false;
    }
    /**
    * Returns true if sourceList contains a number present in targetList
    * @param: list<string> {source list} , list<string> {target list}, Pattern {the Pattern for searching}
    * @return: boolean
    **/
    private static boolean containsNumber(list<string> sourceList,list<string> targetList,Pattern techGeoPattern) {
        try {
            Decimal numKey, targetNum;
            Matcher pm;
            if(sourceList!=null && targetList!=null) {
                for(string s1 : sourceList) {
                    if(s1!=null) {
                        pm = techGeoPattern.matcher(s1);
                        numKey=null;
                        if(pm.matches() && !string.isBlank(pm.group(1))){
                            numKey = Decimal.valueOf(pm.group(1));
                        }
                        for(string s2 : targetList) {
                            if(s2!=null) {
                                pm = techGeoPattern.matcher(s2);
                                targetNum=null;
                                if(pm.matches() && !string.isBlank(pm.group(1))){
                                    targetNum = Decimal.valueOf(pm.group(1));
                                }
                                if(numKey!=null && targetNum!=null && (numKey==targetNum)) {
                                    return true;
                                }
                            }
                        }
                        
                    }
                }
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','containsNumber');
        }
        return false;
    }
    /**
    * Checks whether user is in a specified group or not
    **/
    private static boolean isGroupUser(Id userId,list<string> listGroupName) {
        try {
            if(userId!=null && (listGroupName!=null)) {
                for(GroupMember gm : [SELECT Id FROM GroupMember WHERE UserOrGroupId = :userId AND Group.DeveloperName IN :listGroupName LIMIT 1]) {
                    return true;
                }
            }
        }catch(Exception e) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(e,'','','EmailHandlerUtilityPerMST','isGroupUser');
        }
        return false;
    }
    /**
    * Wrapper class for holding to, cc, bcc list
    **/
    private class EmailRecipientWrapper {
        public list<string> toList;
        public list<string> ccList;
        public list<string> bccList;
        
        public EmailRecipientWrapper() {
            this.toList = new list<string>();
            this.ccList = new list<string>();
            this.bccList = new list<string>();
        }
    }
}