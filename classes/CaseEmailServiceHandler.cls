/*
Type Name: CaseEmailServiceHandler
Author: UCM Cognizant (MM)
Created Date: 19/05/2016
Reason: Reason: This class is used for routing and handling duplicate technical cases created by using Email Service
Test Class: CaseEmailInBoundTest
Change History: Modified to update CC to Case functionlity
Author:
Modified Date: 
……..//
……..
--
*/
global class CaseEmailServiceHandler implements Messaging.InboundEmailHandler {
    Case theCase = null;
    Case caseObj = new Case();
    Case[] matchingCases = new Case[]{};
    Messaging.InboundEmail inboundEmail;
    Messaging.InboundEmailResult result;
    
    CaseEmailInBoundHelper helper;
    public CaseEmailServiceHandler() {
        helper =  new CaseEmailInBoundHelper();
    }
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        result = new Messaging.InboundEmailresult();
        String toemailAddress= envelope.toAddress;
        List < Id > accIds = new List < Id > ();
        List < Id > conIds = new List < Id > ();
        List < Account_Team_Proxy__c > atpList;
        List<Contact> caseConObj = new List<Contact>();
        String value;
        String toAddress;
        String ccAddress;
        String emailServicename ;
                
        try{        
            //Contact[] contObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress];
            if(toemailAddress.containsIgnoreCase('tech'))   
              emailServicename = Environment_Variable__c.getValues('CaseTechEmailAddressName').Value__c;
            else
              emailServicename  =  Environment_Variable__c.getValues('CaseLogisticsEmailAddressName').Value__c;
            
            value = '';
            if (email.toAddresses != null) {
                Boolean seenOne = false;
                for (String to: email.toAddresses) {
                    if (seenOne) {
                        value += ';';
                    }
                    to = extractAddress(to);
                    value += to;
                    seenOne = true;
                }
            }
            toAddress = value;
            
           /* **** CC */
            value = '';
            if (email.ccAddresses != null) {            
                Boolean seenOne = false;
                for (String cc: email.ccAddresses) {
                    if (seenOne) {
                        value += ';';
                    }
                    cc = extractAddress(cc);
                    value += cc;
                    seenOne = true;
                }
            }           
            ccAddress = value;  
            List<string> lstEmail = new List<string>();
            List<string> cclstEmail =  new List<string>();
            if(!String.isBlank(toAddress)){
                for(String str:toAddress.split(';')){                                  
                    String emailStr = str.split('@').get(1);
                    String domainStr = str.split('@').get(0);                                 
                    if(emailStr != System.Label.CaseGlobalFoundaryDomain){
                        if(!domainStr.equalsIgnoreCase(emailServicename))
                            lstEmail.add(str);
                    }
                }
            }
            
            if(!String.isBlank(ccAddress)){
                for(String str:ccAddress.split(';')){
                    String emailStr = str.split('@').get(1);
                    String domainStr = str.split('@').get(0); 
                    if(emailStr != System.Label.CaseGlobalFoundaryDomain)
                        if(!domainStr.equalsIgnoreCase(emailServicename))
                            cclstEmail.add(str);
                }
            }           
            
             if(email.fromAddress.split('@').get(1) != System.Label.CaseGlobalFoundaryDomain){
                    caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress and Is_Portal_User_Active__c = true and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];                    
                    if(caseConObj == null || caseConObj.isEmpty())
                        caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];          
                }
            
            else if(!lstEmail.isEmpty()) {                 
                caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email in:lstEmail and Is_Portal_User_Active__c = true and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];                
                if(caseConObj == null || caseConObj.isEmpty())
                    caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email in:lstEmail and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];                        
            }
            else if(!cclstEmail.isEmpty()){
                caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email in:cclstEmail and Is_Portal_User_Active__c = true and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];                                     
                if(caseConObj == null || caseConObj.isEmpty())
                    caseConObj = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email in:lstEmail and AccountId !=: Label.Case_GlobalFoundriesAccount limit 1];                                                                    
            }
            
            if (caseConObj.size() > 0){
               Contact theContact = caseConObj[0];
               caseObj.AccountId = theContact.AccountId;                       
            }               
            //Routing for Technical Cases
            if (toemailAddress.containsIgnoreCase('tech')){
                system.debug('inif');
                result.success = true;
                this.inboundEmail = email;
                //Mona- Myra case 6/6/16 start
              
                String sub = trimSubject(email.Subject);              
                //Mona- Myra case 6/6/16 end
                //Search for matching cases created within last 6 months and status is not closed             
                 if(caseObj.AccountId != System.Label.Case_GlobalFoundriesAccount && caseConObj.size() > 0){ 
                      matchingCases = [Select Id,AccountId, CaseNumber, Subject, Description from Case 
                                       WHERE (Subject = : sub AND Case_Record_Type_API__c = 'TechnicalPDK'
                                       AND CreatedDate = LAST_N_DAYS:180) AND 
                                       ((AccountId =:caseObj.AccountId) OR(AccountId =:System.Label.Case_GlobalFoundriesAccount OR AccountId =Null))
                                       AND ( ClosedDate = LAST_N_DAYS:15 OR (ClosedDate = NULL))
                                       ORDER BY CreatedDate DESC LIMIT 100];
                    }
                else{
                     matchingCases = [Select Id,AccountId, CaseNumber, Subject, Description from Case 
                                       WHERE (Subject = : sub AND Case_Record_Type_API__c = 'TechnicalPDK'
                                       AND CreatedDate = LAST_N_DAYS:180  AND ( ClosedDate = LAST_N_DAYS:15 OR (ClosedDate = NULL)))
                                       ORDER BY CreatedDate DESC LIMIT 100];
                    }                    
                if (matchingCases.size() > 0) {
                    //update the existing case
                    this.theCase = matchingCases[0];
                }
                //Create new case
                if (this.theCase == null) {
                    // else create a new Case
                    this.theCase = new Case();
                    theCase.SuppliedEmail = email.fromAddress;
                    theCase.SuppliedName = email.fromName;
                    theCase.Status = System.Label.Case_Status_New;
                    theCase.Priority = System.Label.Case_Priority_Medium;
                    theCase.Origin = System.Label.Case_Origin_Email_to_Case;
                    
                    theCase.Subject = sub;
                    //theCase.Subject = email.Subject;
                    string emailBody = 'From:'+ email.fromAddress+'\n To:'+ toAddress + '\n CC:'+ ccAddress + '\n Date: ' + DateTime.now() + '\n Subject: '+ email.Subject + '\n\n' + email.plainTextBody;                   
                    if(emailBody.length() > 30000)
                        theCase.Description = emailBody.substring(0,30000);
                    else
                        theCase.Description = emailBody;                        
                    theCase.RecordTypeId =System.Label.CaseTechnicalRecordtypeId;
                    theCase.Internal_or_external__c = false;
                    theCase.isAssignment__c = false;  
                    theCase.Support_Level__c = 'L2';//MM- added as per Myra's suggestion
                    theCase.Need_by_Date__c=Date.Today().adddays(7);//MM- added as per Myra's suggestion
                   // Contact[] contacts = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress];                                        
                    if (caseConObj.size() > 0) {
                        Contact theContact = caseConObj[0];
                        theCase.ContactId = theContact.Id;
                        theCase.AccountId = theContact.AccountId;
                        conIds.add(theContact.Id);
                        accIds.add(theContact.AccountId);
                        if (accIds.size() > 0) {
                            atpList = [SELECT   Id,
                                                User__c,
                                                Team_Role__c,
                                                Account__c
                                                FROM Account_Team_Proxy__c
                                                WHERE Team_Role__c = : System.Label.Case_Account_Role_Design_and_Technology_Support
                                                AND Account__c IN: accIds
                                            ];
                            if (atpList.size() > 0) {
                                for (Account_Team_Proxy__c proxy: atpList) {
                                    theCase.OwnerId = proxy.User__c;
                                }
                            }else{
                                theCase.OwnerId = CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c;
                            }
                        }                       
                    }
                    else {
                        theCase.AccountId = System.Label.Case_GlobalFoundriesAccount;
                        theCase.OwnerId = CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c;
                    }
                    helper.insertSObject(this.theCase);
                }
                helper.createEmailMessage(theCase, email);
                helper.handleAttachments(theCase, email);
                helper.insertFeed(theCase, email);//MM- added as per Myra's suggestion
                return result;
            }
            //Routing Logistics cases
            else if(toemailAddress.containsIgnoreCase('logistics') || toemailAddress.containsIgnoreCase('qual')){
            system.debug('inelse');
                result.success = true;
                this.inboundEmail = email;
                //Mona- Myra case 6/6/16 start
                String sub = trimSubject(email.Subject);
               
                // try to match subject
                    
                if(caseObj.AccountId != System.Label.Case_GlobalFoundriesAccount && caseConObj.size() > 0){  
                      matchingCases = [Select Id,AccountId, CaseNumber, Subject, Description from Case 
                                   WHERE (Subject = : sub AND Case_Record_Type_API__c = 'Logistics' AND SuppliedEmail != NULL 
                                   AND CreatedDate = LAST_N_DAYS:180) AND 
                                   ((AccountId =:caseObj.AccountId) OR(AccountId =:System.Label.Case_GlobalFoundriesAccount OR AccountId =Null)) 
                                   AND ( ClosedDate = LAST_N_DAYS:15 OR (ClosedDate = NULL))
                                   ORDER BY CreatedDate DESC LIMIT 100];
                    }
                else{
                     matchingCases = [Select Id,AccountId, CaseNumber, Subject, Description from Case 
                                       WHERE (Subject = : sub AND Case_Record_Type_API__c = 'Logistics' AND SuppliedEmail != NULL 
                                       AND CreatedDate = LAST_N_DAYS:180 AND ( ClosedDate = LAST_N_DAYS:15 OR (ClosedDate = NULL)))
                                      ORDER BY CreatedDate DESC LIMIT 100];
                    } 
                if (matchingCases.size() > 0) {
                    //update the existing case
                    this.theCase = matchingCases[0];
                }
                
                if (this.theCase == null) {
                    // else create a new Case
                    this.theCase = new Case();
                    theCase.SuppliedEmail = email.fromAddress;
                    theCase.SuppliedName = email.fromName;
                    theCase.Status = System.Label.Case_Status_New;
                    theCase.Priority = System.Label.Case_Priority_Medium;
                    theCase.Origin = System.Label.Case_Origin_Email_to_Case;
                    //theCase.Subject = email.Subject;
                    //theCase.Subject = TempSubject;
                    theCase.Subject = sub;
                    string emailBody = 'From:'+ email.fromAddress+'\n To:'+ toAddress + '\n CC:'+ ccAddress + '\n Date: ' + DateTime.now() + '\n Subject: '+ email.Subject + '\n\n' + email.plainTextBody;
                    if(emailBody.length() > 30000)
                        theCase.Description = emailBody.substring(0,30000);
                    else
                        theCase.Description = emailBody;
                    theCase.RecordTypeId =System.Label.CaseLogisticsRecordtypeId;
                    theCase.Internal_or_external__c = false;
                    theCase.isAssignment__c = false;
                    theCase.Category__c = System.Label.Case_Category_Quality_Logistics;
                    theCase.OwnerId = CaseQueueSetup__c.getValues('L2 - Fab 9 Quality & Yield').QueueId__c;                 
                    theCase.Support_Level__c = 'L2'; //MM- added as per Myra's suggestion
                    theCase.Need_by_Date__c=Date.Today().adddays(7);//MM- added as per Myra's suggestion
                    //Contact[] contacts = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress];
                    if (caseConObj.size() > 0) {
                        Contact theContact = caseConObj[0];
                        theCase.ContactId = theContact.Id;
                        theCase.AccountId = theContact.AccountId;
                    }
                    helper.insertSObject(this.theCase);
                }
                helper.createEmailMessage(theCase, email);
                helper.handleAttachments(theCase, email);
                helper.insertFeed(theCase, email);//MM- added as per Myra's suggestion
                return result;
            }
            
             //Routing SFDC Internal cases
            else if(toemailAddress.containsIgnoreCase('support') ){
                system.debug('inelsesupportsfdc');
                result.success = true;
                this.inboundEmail = email; 
                String sub = email.Subject; 
                String[] prefixes = new String[] {
                                               'fw:',
                                               're:',
                                               'fwd:',
                                               'FW:',
                                               'RE:',
                                               'FWD:',
                                               'Re:',
                                               'Fwd:',
                                               'Re:',
                                               'automatic reply:',
                                               'out of office autoreply:',
                                               'out of office',
                                               'Automatic Reply:',
                                               'Out Of Office Autoreply:',                                                                                              
                                               'Out Of Office'
                                              };
                for (String prefix: prefixes){
                    if(sub.contains(prefix)){
                        sub = sub.substringAfterLast(prefix).trim();
                    }   
                }
                                
                String regex = '\\[.*?\\]'; 
                sub = sub.replaceAll(regex, '');       
                sub  = sub.replaceAll('(\\s+)', ' ');  
                sub = sub.trim();
                 
                                                    
                matchingCases = [Select Id,AccountId, CaseNumber, Subject, Description from Case 
                                 WHERE Subject = : sub AND Case_Record_Type_API__c = 'Internal_Case' AND SuppliedEmail != NULL 
                                 AND CreatedDate = LAST_N_DAYS:180                        
                                 AND ClosedDate = NULL
                                 ORDER BY CreatedDate DESC LIMIT 100];
                    
                
                if (matchingCases.size() > 0) {
                    //update the existing case
                    this.theCase = matchingCases[0];
                }                
                if (this.theCase == null) {
                    // else create a new Case
                    this.theCase = new Case();
                    theCase.SuppliedEmail = email.fromAddress;
                    theCase.SuppliedName = email.fromName;
                    theCase.Status = System.Label.Case_Status_New;
                    theCase.Priority = System.Label.Case_Priority_Medium;
                    theCase.Origin = 'Email';                   
                    theCase.Subject = sub;
                    string emailBody =  email.plainTextBody;
                    if(emailBody.length() > 30000)
                        theCase.Description = emailBody.substring(0,30000);
                    else
                        theCase.Description = emailBody;
                    theCase.RecordTypeId = Environment_Variable__c.getValues('CaseSfdcSupportRecordtypeId').Value__c; 
                    theCase.Internal_or_external__c = false;
                    theCase.isAssignment__c = false;                   
                    theCase.OwnerId = CaseQueueSetup__c.getValues('General_Case_Queue').QueueId__c;                 
                    theCase.Support_Level__c = 'L1';
                    Contact[] contacts = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Email = : email.fromAddress];
                    if(contacts.size()>0){
                        
                        Contact theContact = contacts[0];
                        if(theContact.AccountId == System.Label.Case_GlobalFoundriesAccount)
                            theCase.ContactId = theContact.Id;
                    }
                    helper.insertSObject(this.theCase);                    
                }
                    helper.createEmailMessage(theCase, email);
                    helper.handleAttachments(theCase, email);
                    helper.insertFeed(theCase, email);
                    return result;
            }
            
            if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
            }
            return result;
                      
        }catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseEmailServiceHandler.class.getName();
                    alw.sourceFunction = 'processInboundEmail()';
                    alw.ApplicationName='Case Management';                  
                    alw.referenceInfo = 'CaseEmailService';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
                    return null;
           // CaseHandlerUtility.trackException('CaseEmailServiceHandler.processInboundEmail',e.getLineNumber(),e.getTypeName(),e.getMessage());
            
        }         
    }
    public String extractAddress(String inAddress) {      
            String address;
            String patternString;
            Pattern thePattern;
            Matcher matcher;
            patternString = '.*<(.*)>.*';
            thePattern = Pattern.compile(patternString);
            matcher = thePattern.matcher(inAddress);
            if (matcher.matches()) {
                address = matcher.group(1);
            } else {
                address = inAddress;
            }            
            return address;         
    }
    
    public string trimSubject(string sub){
                String[] prefixes = new String[] {
                                               'fw:',
                                               're:',
                                               'fwd:',
                                               'FW:',
                                               'RE:',
                                               'FWD:',
                                               'Re:',
                                               'Fwd:',
                                               'Re:',
                                               'automatic reply:',
                                               'out of office autoreply:',
                                               'out of office',
                                               'Automatic Reply:',
                                               'Out Of Office Autoreply:',
                                               ':',
                                               '-',
                                               'Out Of Office'
                                              };
                for (String prefix: prefixes){
                    if(sub.contains(prefix)){
                        sub = sub.substringAfterLast(prefix).trim();
                    }   
                }
        String regex = '\\[.*?\\]'; 
        sub = sub.replaceAll(regex, '');       
        sub  = sub.replaceAll('(\\s+)', ' ');  
        sub = sub.trim(); 
        system.debug('sub  4'+ sub); 
        return sub;
        
    }
    public class applicationException extends Exception {}   
}