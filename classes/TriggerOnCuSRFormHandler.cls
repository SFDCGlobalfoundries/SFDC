/*
Author: Shyam Ravindra Nair
Description: Apex class will act as handler for TriggerOnCuSRForm.
History:
SNair     24112014     - code creation
SNair     31122014     - added logic for AM Approval.
SNair     03012015     - added logic notification group.
SNair     04012015     - updated informCEsAfterInsert method.
Kyash     27102015     - added logic fab9 and fab 10.
SArora    24112015     - //code modified by sunil for case # 48872
SArora    01062016     -  code added by Sunil for case # 55682
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/

public without sharing class TriggerOnCuSRFormHandler {
    
    public UtilClassToGetAllFields utilClass{get;set;}
    public Account acc{get;set;}
    public List<Account_Team_Proxy__c> accountTeamProxyList{get;set;}
    List<Messaging.SingleEmailMessage> mails{get;set;}
    public List<CuSR_Form__c> cusrFormList{get;set;}
    
    public TriggerOnCuSRFormHandler(){
        utilClass = new UtilClassToGetAllFields();
        acc = new Account();
        accountTeamProxyList = new List<Account_Team_Proxy__c>();
        mails = new List<Messaging.SingleEmailMessage>();
    }
    
    public void onBeforeUpdate(List<CuSR_Form__c> newCuSRFormRecord){
        integer count=0;
        boolean success = false;
        cusrFormList = new List<CuSR_Form__c>();
        cusrFormList = [select Id, Status__c from CuSR_Form__c where Id IN: newCuSRFormRecord];
        List<CuSR_Approval_Process__c> CuSRApprovalList = new List<CuSR_Approval_Process__c>();
        for(CuSR_Form__c cusrRecord: newCuSRFormRecord){
                if(cusrRecord.FAB_1__c == true && !(cusrRecord.FAB_1_Void__c))
                {
                    if(cusrRecord.Dresden_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
                if(cusrRecord.FAB_8__c == true && !(cusrRecord.FAB_8_Void__c)){
                    if(cusrRecord.Malta_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
                if(cusrRecord.FAB_9__c == true && !(cusrRecord.FAB_9_Void__c)){
                    if(cusrRecord.Essex_Junction_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
                if(cusrRecord.FAB_10__c == true && !(cusrRecord.FAB_10_Void__c)){
                    if(cusrRecord.East_Fishkill_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
                if(cusrRecord.ASIC__c == true && !(cusrRecord.ASIC_Void__c)){
                    if(cusrRecord.ASIC_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
                if((cusrRecord.FAB_2__c == true && !(cusrRecord.FAB_2_Void__c)) || (cusrRecord.FAB_3__c == true && !(cusrRecord.FAB_3_Void__c)) || (cusrRecord.FAB_3E__c == true && !(cusrRecord.FAB_3E_Void__c)) || (cusrRecord.FAB_5__c == true && !(cusrRecord.FAB_5_Void__c)) || (cusrRecord.FAB_6__c == true && !(cusrRecord.FAB_6_Void__c)) || (cusrRecord.FAB_7__c == true && !(cusrRecord.FAB_7_Void__c))){
                    if(cusrRecord.Singapore_Ready_for_Approval__c == true){
                        success = true;
                    }
                    else{
                        success = false;
                        break;
                    }
                }
        }
        if(success){
            CuSRApprovalList = [select Id, CuSR_Form__c,CuSR_Form__r.Singapore_System_Owner_Approval_Required__c, Status__c, Approved__c from CuSR_Approval_Process__c where CuSR_Form__c IN: newCuSRFormRecord];
            system.debug('System Approval is '+CuSRApprovalList.size());
            for(CuSR_Approval_Process__c CuSRApproval: CuSRApprovalList){
                system.debug('ZZZZZZZZZZZZZZZZZ'+CuSRApproval.CuSR_Form__r.Singapore_System_Owner_Approval_Required__c);
                if((CuSRApproval.Status__c == 'New' || CuSRApproval.Status__c == 'Rejected' || CuSRApproval.Status__c == 'Approved') && !(CuSRApproval.Approved__c) && cusrFormList[0].Status__c != 'Implemented'){
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting Request for Approval.');
                    req.setObjectId(CuSRApproval.Id);
                    system.debug('*****************'+req);
                    Approval.ProcessResult result = Approval.process(req);
                    count++;
                }
                if((CuSRApproval.Status__c == 'New' || CuSRApproval.Status__c == 'Rejected') && cusrFormList[0].Status__c == 'Implemented'){
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting Request for Approval.');
                    req.setObjectId(CuSRApproval.Id);
                    Approval.ProcessResult result = Approval.process(req);
                }
            }
        }
        if(count>0)
        {
            system.debug('CuSR Form Record Size is: '+cusrFormList.size());
            if(cusrFormList.size() > 0){
                List<CuSR_Form__c> updateCuSRFormList = new List<CuSR_Form__c>();
                for(CuSR_Form__c cusrRecord: cusrFormList ){
                    if(cusrRecord.Status__c == 'New' || cusrRecord.Status__c == 'Rejected'){
                        cusrRecord.Status__c = 'Pending Stakeholder Review';
                        cusrRecord.Fifth_Day_Reminder__c = false;
                        cusrRecord.Ninth_Day_Reminder__c = false;
                        //update cusrRecord;
                        updateCuSRFormList.add(cusrRecord);
                    }
                }
                if(updateCuSRFormList.size() > 0){
                    update updateCuSRFormList;
                }
            }
            
        }
    }
    
    public void onAfterUpdate(List<CuSR_Form__c> newCuSRFormRecord){
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
        List<CuSR_Approval_Process__c> CuSRApprovalList = new List<CuSR_Approval_Process__c>();
        system.debug('CUSR File size is '+newCuSRFormRecord.size());
        boolean pmApprovalSuccess = false;
        boolean needAMApproval = false;
        boolean pendingImplementation = false;
        boolean reminder = false;
        String newCuSRFormId;
        for(CuSR_Form__c newCuSR: newCuSRFormRecord){
            newCuSRFormId = newCuSR.Id;
        }
        System.debug(newCuSRFormId+':::newCuSRFormId:::');
        String formFields = utilClass   .getAllFields('CuSR_Form__c');
        String queryForm = 'select '+formFields+' from CuSR_Form__c where Id =\''+newCuSRFormId+'\'';
        cusrFormList = new List<CuSR_Form__c>();
        cusrFormList = database.query(queryForm);
        System.debug(cusrFormList+':::cusrFormList:::');
        for(CuSR_Form__c cusrRecord: newCuSRFormRecord){
            if(cusrRecord.Status__c == 'Pending Stakeholder Review' && cusrRecord.Stakeholder_Approval_Completed__c == true){
                pmApprovalSuccess = true;
            }
            system.debug('ZZZZZZZZZZZZZZZZZZZZ*******'+cusrRecord);
            if(cusrRecord.Status__c == 'Pending PM Review' && cusrRecord.PM_Approved__c == true){
                if(cusrRecord.Any_Cost_Impact__c == 'Yes'){
                    needAMApproval = true;
                }
                else{
                    system.debug('&&&&&&&&&&&&&&&EEEEEEEEE&&&&&&&&&&&');
                    pendingImplementation = true;
                }
            }
            if(cusrRecord.Status__c != 'Implemented' && cusrRecord.Status__c != 'Void' && cusrRecord.Status__c != 'Rejected' && cusrRecord.Status__c != 'New'){
                reminder = true;
            }
        }
        
        if(reminder){
            List<CuSR_Approval_Process__c> systemOwnerApprovalList = new List<CuSR_Approval_Process__c>();
            systemOwnerApprovalList = [select Id, CuSR_Form__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c, Type_of_Approver__c from CuSR_Approval_Process__c where Type_of_Approver__c =: 'System Owner' and Status__c != 'Approved' and CuSR_Form__c IN: cusrFormList];
            List<Id> userIDs = new List<Id>();
            acc = new Account();
            String accId;
            String initiatorId;
            for(CuSR_Form__c cusrForm: cusrFormList){
                 accId = cusrForm.Customer_Name__c;
                 initiatorId = cusrForm.OwnerId;
            }
            User initiator = [select Id, Email from User where Id =: initiatorId];
            acc = [select Id, Name from Account where Id =: accId];
            for(CuSR_Approval_Process__c systemOwnerApproval: systemOwnerApprovalList){
                if(systemOwnerApproval.Approver1__c != null){
                    userIDs.add(systemOwnerApproval.Approver1__c);
                }
                if(systemOwnerApproval.Approver2__c != null){
                    userIDs.add(systemOwnerApproval.Approver2__c);
                }
                if(systemOwnerApproval.Approver3__c != null){
                    userIDs.add(systemOwnerApproval.Approver3__c);
                }
                if(systemOwnerApproval.Approver4__c != null){
                    userIDs.add(systemOwnerApproval.Approver4__c);
                }
                if(systemOwnerApproval.Approver5__c != null){
                    userIDs.add(systemOwnerApproval.Approver5__c);
                }
            }
            List<User> systemUserList = new List<User>();
            systemUserList = [select Id, Email from User where Id IN : userIDs];
            if(systemUserList.size() > 0){
                for(CuSR_Form__c cusrForm: cusrFormList){
                    if(cusrForm.Seventh_Day_Reminder_to_System_Owner__c || cusrForm.Fourteenth_Day_Reminder_to_System_Owner__c){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        List<String> toList = new List<String>();
                        for(User systemUser: systemUserList){
                            toList.add(systemUser.Email);
                        }
                        singleMail.setToAddresses(toList);
                        List<String> ccList = new List<String>();
                        ccList.add(initiator.Email);
                        singleMail.saveAsActivity = false;
                        singleMail.setCcAddresses(ccList);
                        singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is due to be implemented in '+cusrForm.Requested_Effective_Date__c);
                        String body = 'Dear User,';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is in '+cusrForm.Status__c+' status.';
                        body += 'The due date for implementation is '+cusrForm.Requested_Effective_Date__c+'.';
                        body += '<br/>';
                        body += 'Please review and take necessary actions.';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Thank you,';
                        body += '<br/>';
                        body += 'For further clarification/queries , please contact the CE.';
                        body += '<br/>';
                        body += 'This is a system generated auto email. Please do not reply.';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);  
                    }
                }
            }
            
            if(mails.size() > 0){
                Messaging.sendEmail(mails);
            }   
        }
        
        if(needAMApproval){
            acc = new Account();
            acc = [select Id from Account where Id =: cusrFormList[0].Customer_Name__c];
            String fieldsAccountTeamProxy = utilClass.getAllFields('Account_Team_Proxy__c');
            fieldsAccountTeamProxy += ', User__r.Name, User__r.isActive';
            String queryAccountTeamProxy = 'select '+fieldsAccountTeamProxy+' from Account_Team_Proxy__c where Account__c = \''+acc.Id+'\' and Team_Role__c LIKE \'%Account Manager\' and User__r.isActive = true order by Team_Role__c DESC';
            accountTeamProxyList = Database.query(queryAccountTeamProxy);   
            if(accountTeamProxyList.size() > 0){
                CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c();
                amApproval.CuSR_Form__c = cusrFormList[0].Id;
                amApproval.Status__c = 'New';
                amApproval.Type_of_Approver__c = 'AM';
                if(accountTeamProxyList.size() == 1){
                    amApproval.No_of_Approvers__c = '1';
                    system.debug(accountTeamProxyList[0].User__c);
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                }
                else if(accountTeamProxyList.size() == 2){
                    amApproval.No_of_Approvers__c = '2';
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                    amApproval.Approver2__c = accountTeamProxyList[1].User__c;
                }
                else if(accountTeamProxyList.size() == 3){
                    amApproval.No_of_Approvers__c = '3';
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                    amApproval.Approver2__c = accountTeamProxyList[1].User__c;
                    amApproval.Approver3__c = accountTeamProxyList[2].User__c;
                }
                else if(accountTeamProxyList.size() == 4){
                    amApproval.No_of_Approvers__c = '4';
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                    amApproval.Approver2__c = accountTeamProxyList[1].User__c;
                    amApproval.Approver3__c = accountTeamProxyList[2].User__c;
                    amApproval.Approver4__c = accountTeamProxyList[3].User__c;
                }
                else if(accountTeamProxyList.size() == 5){
                    amApproval.No_of_Approvers__c = '5';
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                    amApproval.Approver2__c = accountTeamProxyList[1].User__c;
                    amApproval.Approver3__c = accountTeamProxyList[2].User__c;
                    amApproval.Approver4__c = accountTeamProxyList[3].User__c;
                    amApproval.Approver5__c = accountTeamProxyList[4].User__c;
                }
                else if(accountTeamProxyList.size() > 5){
                    amApproval.No_of_Approvers__c = '5';
                    amApproval.Approver1__c = accountTeamProxyList[0].User__c;
                    amApproval.Approver2__c = accountTeamProxyList[1].User__c;
                    amApproval.Approver3__c = accountTeamProxyList[2].User__c;
                    amApproval.Approver4__c = accountTeamProxyList[3].User__c;
                    amApproval.Approver5__c = accountTeamProxyList[4].User__c;
                }
                insert amApproval;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting Request for AM Approval.');
                req.setObjectId(amApproval.Id);
                Approval.ProcessResult result = Approval.process(req);
            }
        }
        
        if(pendingImplementation){
            system.debug('!!!!!!!!!!!!SAMPLE!!!!!!!!!!!!');
            acc = new Account();
            acc = [select Id, Name from Account where Id =: cusrFormList[0].Customer_Name__c];
            String fieldsAccountTeamProxy = utilClass.getAllFields('Account_Team_Proxy__c');
            fieldsAccountTeamProxy += ', User__r.Name, User__r.isActive';
            String queryAccountTeamProxy = 'select '+fieldsAccountTeamProxy+' from Account_Team_Proxy__c where Account__c = \''+acc.Id+'\' and Team_Role__c LIKE \'%Account Manager\' and User__r.isActive = true order by Team_Role__c DESC';
            accountTeamProxyList = Database.query(queryAccountTeamProxy);  
            Set<Id> amUserId = new Set<Id>();
            List<User> amList = new List<User>();
            Set<Id> userIds = new Set<Id>();
            String userType = Schema.SObjectType.User.getKeyPrefix();
            Group pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
            for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            userIds.add(m.UserOrGroupId);
                    }
            }
            List<User> pmUserList = [select Id, Email from User where Id IN: userIds];
            if(!accountTeamProxyList.isEmpty()){
                for(Account_Team_Proxy__c accountTeamProxy: accountTeamProxyList){
                    amUserId.add(accountTeamProxy.User__c);
                }
                amList = [select Id, Email from User where Id IN: amUserId];
            }
            List<User> ceList = getCEUsersFromAccount(cusrFormList[0].Id);
            User initiator = [select Id, Email from User where Id =: cusrFormList[0].OwnerId];
            if(!amList.isEmpty()){
                mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
                for(CuSR_Form__c cusrForm: cusrFormList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    List<String> toList = new List<String>();
                    for(User am: amList){
                        toList.add(am.Email);
                    }
                    singleMail.setToAddresses(toList);
                    List<String> ccList = new List<String>();
                    ccList.add(initiator.Email);
                    if(!ceList.isEmpty()){
                        for(User ce: ceList){
                            ccList.add(ce.Email);
                        }
                    }
                    if(!pmUserList.isEmpty()){
                        for(User pm: pmUserList){
                            ccList.add(pm.Email);
                        }
                    }
                    singleMail.setCcAddresses(ccList);
                    singleMail.saveAsActivity = false;
                    singleMail.setSubject('Notification on Customer Specific Request '+cusrForm.Name+' for '+acc.Name);
                    String body = 'Dear Account Managers,';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'This is to notify you that a Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' has been approved by Product Marketing Team with no cost impact.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'You can access the CuSR using the following link:';
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thank You.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'For further clarification / queries, please contact the Initiator of the CUSR.';
                    body += '<br/>';
                    body += 'This is a system generated auto email. Please do not reply.';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
                }
                
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
            String cusrId;
            system.debug('****************SAMPLE*************'+cusrFormList.size());
            for(CuSR_Form__c cusrForm: cusrFormList){
                cusrId = cusrForm.Id;
            }
            List<CuSR_Implementation__c> cusrImplementationList = [select Id, Fab__c, Status__c from CuSR_Implementation__c where CuSR_Form__c =: cusrId];
            integer dresdencount = 0;
            integer singaporecount = 0;
            integer maltacount = 0;
            integer essexjunctioncount = 0;
            integer eastfishkillcount = 0;
            integer asiccount = 0;
            List<CuSR_Implementation__c> implementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> dresdenimplementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> singaporeimplementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> maltaimplementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> essexjunctionimplementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> eastfishkillimplementationList = new List<CuSR_Implementation__c>();
            List<CuSR_Implementation__c> asicimplementationList = new List<CuSR_Implementation__c>();
            system.debug(cusrId+'cusrImplementationList:::'+cusrImplementationList);
            if(!cusrImplementationList.isEmpty()){
                for(CuSR_Form__c cusrForm: cusrFormList){
                    for(CuSR_Implementation__c implementation: cusrImplementationList){
                            if(implementation.Fab__c == 'FAB 1' && cusrForm.FAB_1_Void__c == false){
                                dresdenimplementationList.add(implementation);
                            }
                            if(implementation.Fab__c == 'FAB 8' && cusrForm.FAB_8_Void__c == false){
                                maltaimplementationList.add(implementation);
                            }
                            if(implementation.Fab__c == 'FAB 9' && cusrForm.FAB_9_Void__c == false){
                                essexjunctionimplementationList.add(implementation);
                            }
                            if(implementation.Fab__c == 'FAB 10' && cusrForm.FAB_10_Void__c == false){
                                eastfishkillimplementationList.add(implementation);
                            }
                            if(implementation.Fab__c == 'ASIC' && cusrForm.ASIC_Void__c == false){
                                asicimplementationList.add(implementation);
                            }
                            if((implementation.Fab__c == 'FAB 2' && cusrForm.FAB_2_Void__c == false) || (implementation.Fab__c == 'FAB 3' && cusrForm.FAB_3_Void__c == false) || (implementation.Fab__c == 'FAB 3E' && cusrForm.FAB_3E_Void__c == false) || (implementation.Fab__c == 'FAB 5' && cusrForm.FAB_5_Void__c == false) || (implementation.Fab__c == 'FAB 6' && cusrForm.FAB_6_Void__c == false) || (implementation.Fab__c == 'FAB 7' && cusrForm.FAB_7_Void__c == false)){
                                singaporeimplementationList.add(implementation);
                            }
                    }
                }
                for(CuSR_Form__c cusrForm: cusrFormList){
                    if(cusrForm.FAB_1__c && cusrForm.FAB_1_Void__c == false){
                        system.debug('Dresden selected');
                        List<CuSR_Implementation__c> dresdenSucessList = new List<CuSR_Implementation__c>();
                        if(!dresdenimplementationList.isEmpty()){
                            for(CuSR_Implementation__c dresden: dresdenimplementationList){
                                if(dresden.Status__c != 'Pending'){
                                    dresdenSucessList.add(dresden);
                                }
                            }
                            if(dresdenSucessList.size() == dresdenimplementationList.size()){
                                for(CuSR_Implementation__c dresden: dresdenSucessList){
                                    if(dresden.Status__c == 'Completed'){
                                        system.debug('Completed in Dresden');
                                        dresdencount = 0;
                                        break;
                                    }
                                    else{
                                        dresdencount++;
                                    }
                                }
                            }
                            else{
                                dresdencount++;
                            }
                        }
                        else{
                            dresdencount++;
                        }
                    }
                    if(cusrForm.FAB_8__c && cusrForm.FAB_8_Void__c == false){
                            system.debug('Malta selected');
                            List<CuSR_Implementation__c> maltaSucessList = new List<CuSR_Implementation__c>();
                            if(!maltaimplementationList.isEmpty()){
                                for(CuSR_Implementation__c malta: maltaimplementationList){
                                    if(malta.Status__c != 'Pending'){
                                        maltaSucessList.add(malta);
                                    }
                                }
                                if(maltaSucessList.size() == maltaimplementationList.size()){
                                    for(CuSR_Implementation__c malta: maltaSucessList){
                                        if(malta.Status__c == 'Completed'){
                                            system.debug('Completed in Malta');
                                            maltacount = 0;
                                            break;
                                        }
                                        else{
                                            maltacount++;
                                        }
                                    }
                                }
                                else{
                                    maltacount++;
                                }
                            }
                            else{
                                maltacount++;
                            }
                    }
                    if(cusrForm.FAB_9__c && cusrForm.FAB_9_Void__c == false){
                            system.debug('Essex Junction selected');
                            List<CuSR_Implementation__c> essexjunctionSucessList = new List<CuSR_Implementation__c>();
                            if(!essexjunctionimplementationList .isEmpty()){
                                for(CuSR_Implementation__c essexjunction: essexjunctionimplementationList ){
                                    if(essexjunction.Status__c != 'Pending'){
                                        essexjunctionSucessList.add(essexjunction);
                                    }
                                }
                                if(essexjunctionSucessList.size() == essexjunctionimplementationList .size()){
                                    for(CuSR_Implementation__c essexjunction: essexjunctionSucessList){
                                        if(essexjunction.Status__c == 'Completed'){
                                            system.debug('Completed in Essex Junction');
                                            essexjunctioncount = 0;
                                            break;
                                        }
                                        else{
                                            essexjunctioncount++;
                                        }
                                    }
                                }
                                else{
                                    essexjunctioncount++;
                                }
                            }
                            else{
                                essexjunctioncount++;
                            }
                    }
                    if(cusrForm.FAB_10__c && cusrForm.FAB_10_Void__c == false){
                            system.debug('East Fishkill selected');
                            List<CuSR_Implementation__c> eastfishkillSucessList = new List<CuSR_Implementation__c>();
                            if(!eastfishkillimplementationList .isEmpty()){
                                for(CuSR_Implementation__c eastfishkill: eastfishkillimplementationList ){
                                    if(eastfishkill.Status__c != 'Pending'){
                                        eastfishkillSucessList.add(eastfishkill);
                                    }
                                }
                                if(eastfishkillSucessList.size() == eastfishkillimplementationList .size()){
                                    for(CuSR_Implementation__c eastfishkill: eastfishkillSucessList){
                                        if(eastfishkill.Status__c == 'Completed'){
                                            system.debug('Completed in East Fishkill');
                                            eastfishkillcount = 0;
                                            break;
                                        }
                                        else{
                                            eastfishkillcount++;
                                        }
                                    }
                                }
                                else{
                                    eastfishkillcount++;
                                }
                            }
                            else{
                                eastfishkillcount++;
                            }
                    }
                    if(cusrForm.ASIC__c && cusrForm.ASIC_Void__c == false){
                            system.debug('ASIC selected');
                            List<CuSR_Implementation__c> asicSucessList = new List<CuSR_Implementation__c>();
                            if(!asicimplementationList.isEmpty()){
                                for(CuSR_Implementation__c asic: asicimplementationList){
                                    if(asic.Status__c != 'Pending'){
                                        asicSucessList.add(asic);
                                    }
                                }
                                if(asicSucessList.size() == asicimplementationList.size()){
                                    for(CuSR_Implementation__c asic: asicSucessList){
                                        if(asic.Status__c == 'Completed'){
                                            system.debug('Completed in ASIC');
                                            asiccount = 0;
                                            break;
                                        }
                                        else{
                                            asiccount++;
                                        }
                                    }
                                }
                                else{
                                    asiccount++;
                                }
                            }
                            else{
                                asiccount++;
                            }
                    }
                    if((cusrForm.FAB_2__c && !(cusrForm.FAB_2_Void__c)) || (cusrForm.FAB_3__c && !(cusrForm.FAB_3_Void__c)) || (cusrForm.FAB_3E__c && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_5__c && !(cusrForm.FAB_5_Void__c)) || (cusrForm.FAB_6__c && !(cusrForm.FAB_6_Void__c)) || (cusrForm.FAB_7__c && !(cusrForm.FAB_7_Void__c))){
                            system.debug('Singapore selected');
                            system.debug('SSSSSSSSSSSSSSSSSSSSSSS');
                            List<CuSR_Implementation__c> singaporeSucessList = new List<CuSR_Implementation__c>();
                            if(!singaporeimplementationList.isEmpty()){
                                for(CuSR_Implementation__c singapore: singaporeimplementationList){
                                    if(singapore.Status__c != 'Pending'){
                                        singaporeSucessList.add(singapore);
                                    }
                                }
                                if(singaporeSucessList.size() == singaporeimplementationList.size()){
                                    for(CuSR_Implementation__c singapore: singaporeSucessList){
                                        if(singapore.Status__c == 'Completed'){
                                            system.debug('Completed in Singapore');
                                            singaporecount = 0;
                                            break;
                                        }
                                        else{
                                            
                                            singaporecount++;
                                        }
                                    }
                                }
                                else{
                                    singaporecount++;
                                }
                            }
                            else{
                                singaporecount++;
                            }
                    }
                        
                }
                
            }
            else{
                system.debug('AAAAAAAAAAAA&&&&AAAAAAAAAAAAA'+dresdencount);
                dresdencount++;
                singaporecount++;
                maltacount++;
                essexjunctioncount++;
                eastfishkillcount++;
                asiccount++;
            }
            system.debug(dresdencount+'@@@@@@@@@@@@@@@@@@SAM'+singaporecount+'PLETESTMY@@@@@@@@@@'+maltacount);
            for(CuSR_Form__c cusrForm: cusrFormList){
                System.debug(dresdencount+'dresdencount'+singaporecount+'singaporecount'+maltacount+'maltacount'+essexjunctioncount+'essexjunctioncount'+eastfishkillcount+'eastfishkillcount'+asiccount+'asiccount');
                if(dresdencount == 0 && singaporecount == 0 && maltacount == 0 && essexjunctioncount == 0 && eastfishkillcount == 0 && asiccount == 0){
                    cusrForm.Status__c = 'Implemented';

                }
                else{
                    cusrForm.Status__c = 'Pending Implementation';
                    cusrForm.Fifth_Day_Reminder__c = false;
                    cusrForm.Ninth_Day_Reminder__c = false;
                }
                 //code modified by sunil for case # 48872
                    String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
                    if(!baseURL.contains('visual.force')){
                        newCuSRFormRecord[0].addError(System.Label.CUSR_Approval_Error);
                    }
                //update cusrForm;
            }
            update cusrFormList;
        }
        
        if(pmApprovalSuccess){
            for(CuSR_Form__c cusrForm: cusrFormList){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting Request for PM Approval.');
                req.setObjectId(cusrForm.Id);
                Approval.ProcessResult result = Approval.process(req);
                system.debug('PM Approval Submitted');    
            }
        }

        
    }
    
    //method to send email to PM for approval.
    public void sendEmailForPMApproval(List<CuSR_Form__c> newCuSRFormList){
        system.debug(';;;;;;;;;;;;;;;;');
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
        Set<Id> userIds = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        Group pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
        for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                        userIds.add(m.UserOrGroupId);
                }
        }
        List<User> pmUserList = [select Id, Email from User where Id IN: userIds];
        List<User> ceList = getCEUsersFromAccount(newCuSRFormList[0].Id);
        User initiator = new User();
        initiator = [select Id, Email from User where Id =:newCuSRFormList[0].OwnerId];
        acc = [select Id, Name from Account where Id =:newCuSRFormList[0].Customer_Name__c];
            for(CuSR_Form__c newCuSRForm: newCuSRFormList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    List<String> toList = new List<String>();
                    if(!pmUserList.isEmpty()){
                        for(User pmUser: pmUserList){
                            toList.add(pmUser.Email);
                        }
                        singleMail.setToAddresses(toList);
                    }
                    List<String> ccList = new List<String>();
                    ccList.add(initiator.Email);
                    if(!ceList.isEmpty()){
                        for(User ce: ceList){
                            ccList.add(ce.Email);
                        }
                    }
                    if(!ccList.isEmpty()){
                        singleMail.setCcAddresses(ccList);  
                    }
                    singleMail.saveAsActivity = false;
                    singleMail.setSubject('Customer Specific Request '+newCuSRForm.Name+' for '+acc.Name+' is '+newCuSRForm.Status__c);
                    String body = 'Dear Users,';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Customer Specific Request '+newCuSRForm.Name+' for '+acc.Name+' is '+newCuSRForm.Status__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'You can access the CuSR using the following link: ';
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+newCuSRForm.Id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newCuSRForm.Id+'">'+hyperLink+'</a>';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thank You.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'For further clarification / queries, please contact the Initiator of the CUSR.';
                    body += '<br/>';
                    body += 'This is a system generated auto email. Please do not reply';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
            }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    public void notifyGroupAndCustomer(List<CuSR_Form__c> newCuSRFormList){
        //boolean notifyGroup = false;
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
        boolean fab1selected = false;
        boolean fab2selected = false;
        boolean fab3selected = false;
        boolean fab3eselected = false;
        boolean fab5selected = false;
        boolean fab6selected = false;
        boolean fab7selected = false;
        boolean fab8selected = false;
        boolean fab9selected = false;
        boolean fab10selected = false;
        boolean asicselected = false;
        Group fab1QAGroup;
        Group fab2QAGroup;
        Group fab3QAGroup;
        Group fab3eQAGroup;
        Group fab5QAGroup;
        Group fab6QAGroup;
        Group fab7QAGroup;
        Group fab8QAGroup;
        Group fab9QAGroup;
        Group fab10QAGroup;
        Group asicQAGroup;
        String userType = Schema.SObjectType.User.getKeyPrefix();
           Account acc= new Account();
            String accountId;
            for(CuSR_Form__c newCuSRForm: newCuSRFormList){
                accountId = newCuSRForm.Customer_Name__c;
            }
            acc = [select Id, Name from Account where Id =: accountId];
            UtilClassToGetAllFields util= new UtilClassToGetAllFields();
            String cusrFormFields = util.getAllFields('CuSR_Form__c');
            String query = 'select '+cusrFormFields+' from CuSR_Form__c where Id = \''+newCuSRFormList[0].Id+'\'';
            cusrFormList = new List<CuSR_Form__c>();
            //cusrFormList = [select Id, OwnerId, Name, Additional_Fab_Added__c, Status__c, Customer_Name__c, Customer_Requestor__c, Notify_Customer_after_Implementation__c, Scope__c from CuSR_Form__c where Id IN: newCuSRFormList];
            cusrFormList = Database.query(query);
            List<CuSR_Notification_Group__c> memberList = new List<CuSR_Notification_Group__c>();
            memberList = [select Id, User__c, User__r.Name, User__r.Email, CuSR_Form__c from CuSR_Notification_Group__c where CuSR_Form__c IN: cusrFormList];
            List<Account_Team_Proxy__c> teamProxyUserList = [select Id, User__c, Team_Role__c, Account__c, Fab_Assignment__c from Account_Team_Proxy__c where Account__c =: cusrFormList[0].Customer_Name__c and Team_Role__c = 'Customer Engineer'];
            Set<Id> proxyUserIdList = new Set<Id>();
            List<Id> toAddressUserIdList = new List<Id>();
            List<User> ceUsers = new List<User>();
            for(CuSR_Form__c cusrForm: cusrFormList){
                if(cusrForm.FAB_1__c){
                    fab1selected = true;
                }
                if(cusrForm.FAB_2__c){
                    fab2selected = true;
                }
                if(cusrForm.FAB_3__c){
                    fab3selected = true;
                }
                if(cusrForm.FAB_3E__c){
                    fab3eselected = true;
                }
                if(cusrForm.FAB_5__c){
                    fab5selected = true;
                }
                if(cusrForm.FAB_6__c){
                    fab6selected = true;
                }
                if(cusrForm.FAB_7__c){
                    fab7selected = true;
                }
                if(cusrForm.FAB_8__c){
                    fab8selected = true;
                }
                if(cusrForm.FAB_9__c){
                    fab9selected = true;
                }
                if(cusrForm.FAB_10__c){
                    fab10selected = true;
                }
                if(cusrForm.ASIC__c){
                    asicselected = true;
                }
            }
            if(fab1selected){
                fab1QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 1 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab1QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab2selected){
                fab2QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 2 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab2QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab3selected){
                fab3QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 3 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab3QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab3eselected){
                fab3eQAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 3E QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab3eQAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab5selected){
                fab5QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 5 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab5QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab6selected){
                fab6QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 6 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab6QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab7selected){
                fab7QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 7 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab7QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab8selected){
                fab8QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 8 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab8QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab9selected){
                fab9QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 9 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab9QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab10selected){
                fab10QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 10 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab10QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(asicselected){
                asicQAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR ASIC QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: asicQAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            toAddressUserIdList.add(m.UserOrGroupId);
                    }
                }
            }
            if(teamProxyUserList.size() > 0){
                for(Account_Team_Proxy__c pro : teamProxyUserList){
                    if(pro.Fab_Assignment__c.contains('FAB 1') && cusrFormList[0].FAB_1__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 2') && cusrFormList[0].FAB_2__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 3') && cusrFormList[0].FAB_3__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('E') && cusrFormList[0].FAB_3E__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 5') && cusrFormList[0].FAB_5__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 6') && cusrFormList[0].FAB_6__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 7') && cusrFormList[0].FAB_7__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 8') && cusrFormList[0].FAB_8__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 9') && cusrFormList[0].FAB_9__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 10') && cusrFormList[0].FAB_10__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('ASIC') && cusrFormList[0].ASIC__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                }
            }
            if(proxyUserIdList.size() > 0){
                ceUsers = [select Id, Email from User where Id IN: proxyUserIdList];
            }
            List<CuSR_Implementation__c> cusrImplementationList  = [select Id, CuSR_Form__c, Assignee__c from CuSR_Implementation__c where CuSR_Form__c IN: cusrFormList];
            for(CuSR_Implementation__c cusrImplementation: cusrImplementationList){
                toAddressUserIdList.add(cusrImplementation.Assignee__c);
            }
            List<CuSR_Approval_Process__c> cusrApprovalList = [select Id, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c, AM_Approved_By__c from CuSR_Approval_Process__c where CuSR_Form__c IN: cusrFormList];
            List<User> ampmUserList = new List<User>();
            List<User> approverUserList = new List<User>();
            for(CuSR_Form__c cusrForm: cusrFormList){
                if(cusrForm.PM_Approved_By__c != null){
                    toAddressUserIdList.add(cusrForm.PM_Approved_By__c);
                }
            }
            if(!cusrApprovalList.isEmpty()){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(cusrApproval.Type_of_Approver__c == 'AM'){
                        toAddressUserIdList.add(cusrApproval.AM_Approved_By__c);
                    }
                    else{
                        if(cusrApproval.Approver1__c != null){
                            toAddressUserIdList.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            toAddressUserIdList.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            toAddressUserIdList.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            toAddressUserIdList.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            toAddressUserIdList.add(cusrApproval.Approver5__c);
                        }
                    }
                }
            }
            List<User> toAddressUserList = new List<User>();
            if(toAddressUserIdList.size() > 0){
                toAddressUserList = [select Id, Email from User where Id IN: toAddressUserIdList];
            }
            system.debug('No of users in to address: '+toAddressUserList.size());
            if(toAddressUserList.size() > 0){
                User u = new User();
                u = [select Id, Email from User where Id =: cusrFormList[0].OwnerId];
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                singleMail.setReplyTo('do-not-reply@globalfoundries.com');
                singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
                List<String> toList = new List<String>();
                toList.add(u.Email);
                for(User toUser: toAddressUserList){
                    toList.add(toUser.Email);
                }
                if(!memberList.isEmpty()){
                    for(CuSR_Notification_Group__c member: memberList){
                        toList.add(member.User__r.Email);
                    }
                }
                singleMail.setToAddresses(toList);
                List<String> ccList = new List<String>();
                if(ceUsers.size() > 0){
                    for(User c: ceUsers){
                        ccList.add(c.Email); 
                    }
                }
                singleMail.setCcAddresses(ccList);
                singleMail.saveAsActivity = false;
                singleMail.setSubject('Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Implemented');
                String body = 'Dear Users';
                body += '<br/>';
                body += '<br/>';
                body += 'Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Implemented Successfully.';
                body += '<br/>';
                body += '<br/>'; 
                body += 'You can access the CuSR using the following link.';
                body += '<br/>';
                body += '<br/>';
                String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id;
                body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id+'">'+hyperLink+'</a>';
                body += '<br/>';
                body += '<br/>';
                body += 'Thank you';
                body += '<br/>';
                body += 'For further clarification/queries, please contact the originator of the CuSR.';
                body += '<br/>';
                body += 'This is a system generated auto email. Please do not reply.';
                singleMail.setHtmlBody(body);
                mails.add(singleMail);
            }
            
            Set<Id> contactIdSet = new Set<Id>();
            Set<Id> userIdSet = new Set<Id>();
            for(CuSR_Form__c cusrForm : cusrFormList){
                if(cusrForm.Notify_Customer_after_Implementation__c == 'Yes'){
                    
                    contactIdSet.add(cusrForm.Customer_Requestor__c);
                    userIdSet.add(cusrForm.OwnerId);
                }
            }
            
            Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE Id  IN :contactIdSet]);
            Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :userIdSet]);
            
            for(CuSR_Form__c cusrForm: cusrFormList){
                if(cusrForm.Notify_Customer_after_Implementation__c == 'Yes'){
                    //Contact con = new Contact();
                    //con = [select Id, Name from Contact where Id  =: cusrForm.Customer_Requestor__c];
                    Contact con = contactMap.get(cusrForm.Customer_Requestor__c);
                    //User u = new User();
                    //u = [select Id, Email from User where Id =: cusrForm.OwnerId];
                    User u = userMap.get(cusrForm.OwnerId);
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    singleMail.setReplyTo('do-not-reply@globalfoundries.com');
                    singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
                    singleMail.setTargetObjectId(cusrForm.Customer_Requestor__c);
                    List<String> ccList = new List<String>();
                    ccList.add(u.Email);
                    String ceEmail = '';
                    if(ceUsers.size() > 0){
                        for(User c: ceUsers){
                            ccList.add(c.Email); 
                            ceEmail += ', '+c.Email;   
                        }
                        ceEmail = ceEmail.subString(2);
                    }
                    singleMail.setCcAddresses(ccList);
                    singleMail.setSubject(cusrForm.Name+' has been implemented by GLOBALFOUNDRIES Team');
                    String body = 'Dear '+con.Name+', ';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Kindly take note that Customer Specific Request '+cusrForm.Name+' has been implemented in the GLOBALFOUNDRIES.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Following are the CUSR details for your reference.';
                    body += '<br/>';
                    body += '<b>CUSR Requirements: </b>'+cusrForm.Actual_Requirement__c;
                    body += '<br/>';
                    body += '<b>Category:</b> '+cusrForm.System__c;
                    body += '<br/>';
                    body += '<b>Technology:</b> '+cusrForm.Technology__c; 
                    body += '<br/>';
                    body += '<b>Fab:</b> '+cusrForm.Scope__c;
                    body += '<br/>';
                    if(cusrForm.Validity_Period_of_this_Request__c == 'EOL'){
                        body += '<b>Validity Period of this request:</b> '+cusrForm.Validity_Period_of_this_Request__c; 
                    }
                    else{
                        body += '<b>Validity Period of this request:</b> '+cusrForm.Validity_Period__c+' '+cusrForm.Validity_Period_of_this_Request__c;
                    }
                    body += '<br/>';
                    body += '<b>Customer Specific Name and Version:</b> '+cusrForm.Customer_Specification_Name__c+'/'+cusrForm.Version__c ;
                    body += '<br/>';
                    body += '<br/>';
                    body += 'For further clarification / queries, please contact your respective CEs whose email address can be found below:';
                    body += '<br/>';
                    body += ceEmail;
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thank you.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Note: This is a system generated auto email Notification. Please do not reply to this email.';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
                }
            }
            if(mails.size() > 0){
                Messaging.sendEmail(mails);
            }
    }
    
    public void notifyInitiatorAndNotificationGroupOnUpdate(List<CuSR_Form__c> newCuSRFormList){
        boolean notifyGroupAndInitiator = false;
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
         cusrFormList = new List<CuSR_Form__c>();
            cusrFormList = [select Id, OwnerId, Name, Additional_Fab_Added__c, Status__c, Customer_Name__c, Customer_Requestor__c, Notify_Customer_after_Implementation__c, Scope__c from CuSR_Form__c where Id IN: newCuSRFormList];
            List<CuSR_Notification_Group__c> memberList = new List<CuSR_Notification_Group__c>();
            memberList = [select Id, User__c, User__r.Name, CuSR_Form__c from CuSR_Notification_Group__c where CuSR_Form__c IN: cusrFormList];
            Account acc= new Account();
            acc = [select Id, Name from Account where Id =: cusrFormList[0].Customer_Name__c];
            if(memberList.size() > 0){
                for(CuSR_Notification_Group__c member: memberList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    singleMail.setTargetObjectId(member.User__c);
                    singleMail.saveAsActivity = false;
                    singleMail.setSubject('Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Updated');
                    String body = 'Dear '+member.User__r.Name+', ';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Updated.';
                    body += 'Please click the below link to access the record.';
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id+'">'+hyperLink+'</a>';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thank you,';
                    body += '<br/>';
                    body += 'For further clarification/query, please contact the CE.';
                    body += '<br/>';
                    body += 'This is a system generated auto email. Please do not reply.';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
                } 
            }
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    List<User> ceList = getCEUsersFromAccount(cusrFormList[0].Id);
                    User u = [select Id, Name from User where Id =: cusrFormList[0].OwnerId];
                    singleMail.setTargetObjectId(u.Id);
                    List<String> ccList = new List<String>();
                    if(!ceList.isEmpty()){
                        for(User ce: ceList){
                            ccList.add(ce.Email);
                        }
                    }
                    singleMail.setCcAddresses(ccList);
                    singleMail.saveAsActivity = false;
                    singleMail.setSubject('Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Updated');
                    String body = 'Dear '+u.Name+', ';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Customer Specific Request '+cusrFormList[0].Name+' for '+acc.Name+' is Updated.';
                    body += 'Please click the below link to access the record.';
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrFormList[0].Id+'">'+hyperLink+'</a>';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thank you,';
                    body += '<br/>';
                    body += 'For further clarification/query, please contact the CE.';
                    body += '<br/>';
                    body += 'This is a system generated auto email. Please do not reply.';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
                    
                    if(mails.size() > 0){
                        Messaging.sendEmail(mails);
                    }
    }
    
    //method to check which fab is selected after implementation
    public void checkFabAfterImplementation(List<CuSR_Form__c> oldCuSRFormList, List<CuSR_Form__c> newCuSRFormList){
        String selectedFab = '';
        boolean updateForm = false;
        boolean addFab1 = false;
        boolean addFab2 = false;
        boolean addFab3 = false;
        boolean addFab3e = false;
        boolean addFab5 = false;
        boolean addFab6 = false;
        boolean addFab7 = false;
        boolean addFab8 = false;
        boolean addFab9 = false;
        boolean addFab10 = false;
        boolean addASIC = false;
        for(CuSR_Form__c newCuSRForm : newCuSRFormList){
               for(CuSR_Form__c oldCuSRForm: oldCuSRFormList){
                    if(newCuSRForm.FAB_1__c && (newCuSRForm.FAB_1__c != oldCuSRForm.FAB_1__c)){
                        newCuSRForm.Additional_FAB_1__c = true;
                    }
                    if(newCuSRForm.FAB_2__c && (newCuSRForm.FAB_2__c != oldCuSRForm.FAB_2__c)){
                        newCuSRForm.Additional_FAB_2__c = true;
                    }
                    if(newCuSRForm.FAB_3__c && (newCuSRForm.FAB_3__c != oldCuSRForm.FAB_3__c)){
                        newCuSRForm.Additional_FAB_3__c = true;
                    }
                    if(newCuSRForm.FAB_3E__c && (newCuSRForm.FAB_3E__c != oldCuSRForm.FAB_3E__c)){
                        newCuSRForm.Additional_FAB_3E__c = true;
                    }
                    if(newCuSRForm.FAB_5__c && (newCuSRForm.FAB_5__c != oldCuSRForm.FAB_5__c)){
                        newCuSRForm.Additional_FAB_5__c = true;
                    }
                    if(newCuSRForm.FAB_6__c && (newCuSRForm.FAB_6__c != oldCuSRForm.FAB_6__c)){
                        newCuSRForm.Additional_FAB_6__c = true;
                    }
                    if(newCuSRForm.FAB_7__c && (newCuSRForm.FAB_7__c != oldCuSRForm.FAB_7__c)){
                        newCuSRForm.Additional_FAB_7__c = true;
                    }
                    system.debug(oldCuSRForm.FAB_8__c+'ZZZZZZZZZZZZZ'+newCuSRForm.FAB_8__c);
                    if(newCuSRForm.FAB_8__c && (newCuSRForm.FAB_8__c != oldCuSRForm.FAB_8__c)){
                        newCuSRForm.Additional_FAB_8__c = true;
                    }
                    if(newCuSRForm.FAB_9__c && (newCuSRForm.FAB_9__c != oldCuSRForm.FAB_9__c)){
                        newCuSRForm.Additional_FAB_9__c = true;
                    }
                    if(newCuSRForm.FAB_10__c && (newCuSRForm.FAB_10__c != oldCuSRForm.FAB_10__c)){
                        newCuSRForm.Additional_FAB_10__c = true;
                    }
                    if(newCuSRForm.ASIC__c && (newCuSRForm.ASIC__c != oldCuSRForm.ASIC__c)){
                        newCuSRForm.Additional_ASIC__c = true;
                    }
                }
        }
    }
    
    //Added By Abhita
    
    public Group getQueue(String QName){
        Group gp = [Select Type, Id From Group where Type =: 'QUEUE' And Name =:QName Limit 1];
        return gp;
    }
    
    public void provideAccess(List<CuSR_Form__c> newCuSRFormRecord){
            List<CuSR_Form__Share> formShares = new List<CuSR_Form__Share>();
              
            Group grp = getQueue('CuSR PM Queue');
    
            for(CuSR_Form__c cusrRecord: newCuSRFormRecord){
                CuSR_Form__Share approvalShare = new CuSR_Form__Share ();
                approvalShare.UserOrGroupId = grp.Id;
                approvalShare.ParentId = cusrRecord.Id;
                approvalShare.AccessLevel = 'EDIT';
                approvalShare.RowCause = Schema.CuSR_Form__Share.RowCause.Sharing_Access__c;
                formShares.add(approvalShare);        
            }
            Database.SaveResult[] formSharesInsertResult = Database.insert(formShares ,false);    
    }
    
    //method to send 5th day reminder
    public void sendFirstReminder(String cusrFormId){
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String cusrFields = utilClass.getAllFields('CuSR_Form__c');
        String cusrQuery = 'select '+cusrFields+' from CuSR_Form__c where Id =\''+cusrFormId+'\'';
        CuSR_Form__c cusrForm = new CuSR_Form__c();
        cusrForm = database.query(cusrQuery);
        List<CuSR_Approval_Process__c> cusrApprovalList = new List<CuSR_Approval_Process__c>();
        List<CuSR_Implementation__c> cusrImplementationList = new List<CuSR_Implementation__c>();
        Group pmGroup = new Group();
        Set<Id> toUserIdList = new Set<Id>();
        if(cusrForm.Status__c == 'Pending Stakeholder Review'){
            cusrApprovalList = [select Id, Status__c, Approved__c, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id and Type_of_Approver__c != 'AM'];
            if(cusrApprovalList.size() > 0){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(!cusrApproval.Approved__c){
                        if(cusrApproval.Approver1__c != null){
                            toUserIdList.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            toUserIdList.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            toUserIdList.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            toUserIdList.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            toUserIdList.add(cusrApproval.Approver5__c);
                        }
                    }
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending PM Review'){
            pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
            for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                    toUserIdList.add(m.UserOrGroupId);
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending AM Review'){
        
            system.debug('******@@****'+cusrForm.Status__c);
            cusrApprovalList = [select Id, Status__c, Approved__c, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id and Type_of_Approver__c = 'AM'];
            if(cusrApprovalList.size() > 0){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(!cusrApproval.Approved__c){
                        if(cusrApproval.Approver1__c != null){
                            toUserIdList.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            toUserIdList.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            toUserIdList.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            toUserIdList.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            toUserIdList.add(cusrApproval.Approver5__c);
                        }
                    }
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending Implementation'){
            cusrImplementationList = [select Id, Fab__c, Status__c, Assignee__c from CuSR_Implementation__c where CuSR_Form__c =: cusrForm.Id];
            if(cusrImplementationList.size() > 0){
                for(CuSR_Implementation__c cusrImplementation: cusrImplementationList){
                    if(cusrImplementation.Fab__c == 'FAB 1' && !(cusrForm.FAB_1_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 2' && !(cusrForm.FAB_2_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 3' && !(cusrForm.FAB_3_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 3E' && !(cusrForm.FAB_3E_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 5' && !(cusrForm.FAB_5_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 6' && !(cusrForm.FAB_6_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 7' && !(cusrForm.FAB_7_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 8' && !(cusrForm.FAB_8_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                     if(cusrImplementation.Fab__c == 'FAB 9' && !(cusrForm.FAB_9_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                     if(cusrImplementation.Fab__c == 'FAB 10' && !(cusrForm.FAB_10_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'ASIC' && !(cusrForm.ASIC_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                }
            }
        }
        system.debug('List of receipt: '+toUserIdList.size());
        if(!toUserIdList.isEmpty()){
            List<User> toUserList = new List<User>();
            toUserList = [select Id, Email from User where Id IN: toUserIdList];
            User initiator = new User();
            initiator = [select Id, Email from User where Id =: cusrForm.OwnerId];
            Account acc = new Account();
            acc = [select Name from Account where Id =: cusrForm.Customer_Name__c];
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                singleMail.setReplyTo('do-not-reply@globalfoundries.com');
                singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
                List<String> toList = new List<String>();
                for(User toUser: toUserList){
                    toList.add(toUser.Email);
                }
                toList.add(initiator.Email);
                singleMail.setToAddresses(toList);
                singleMail.saveAsActivity = false;
                singleMail.setSubject('1st Reminder: Customer Specific Request for Account '+acc.Name+' is in '+cusrForm.Status__c+' status.');
                String body = 'Dear User,';
                body += '<br/>';
                body += '<br/>';
                body += 'Customer Specific Request CuSR '+cusrForm.Name+' for Account '+acc.Name+' is in '+cusrForm.Status__c+' status.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please review and take necessary actions.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please click the below link to access the record.';
                body += '<br/>';
                body += '<br/>';
                String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                body += '<br/>';
                body += '<br/>';
                body += 'Thank you,';
                body += '<br/>';
                body += 'For further clarification/queries , please contact the CE.';
                body += '<br/>';
                body += 'This is a system generated auto email. Please do not reply.';
                singleMail.setHtmlBody(body);
                mails.add(singleMail);  
            }    
        system.debug('Size of mails: '+mails.size());
        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }
    }
    
    //method to send 9th day reminder
    public void sendSecondReminder(String cusrFormId){
        mails = new List<Messaging.SingleEmailMessage>(); // line added by Sunil for case # 55682
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String cusrFields = utilClass.getAllFields('CuSR_Form__c');
        String cusrQuery = 'select '+cusrFields+' from CuSR_Form__c where Id =\''+cusrFormId+'\'';
        CuSR_Form__c cusrForm = new CuSR_Form__c();
        cusrForm = database.query(cusrQuery);
        List<CuSR_Approval_Process__c> cusrApprovalList = new List<CuSR_Approval_Process__c>();
        List<CuSR_Implementation__c> cusrImplementationList = new List<CuSR_Implementation__c>();
        Group pmGroup = new Group();
        Set<Id> toUserIdList = new Set<Id>();
        if(cusrForm.Status__c == 'Pending Stakeholder Review'){
            cusrApprovalList = [select Id, Status__c, Approved__c, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id and Type_of_Approver__c != 'AM'];
            if(cusrApprovalList.size() > 0){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(!cusrApproval.Approved__c){
                        if(cusrApproval.Approver1__c != null){
                            toUserIdList.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            toUserIdList.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            toUserIdList.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            toUserIdList.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            toUserIdList.add(cusrApproval.Approver5__c);
                        }
                    }
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending PM Review'){
            pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
            for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                    toUserIdList.add(m.UserOrGroupId);
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending AM Review'){
            cusrApprovalList = [select Id, Status__c, Approved__c, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id and Type_of_Approver__c = 'AM'];
            if(cusrApprovalList.size() > 0){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(!cusrApproval.Approved__c){
                        if(cusrApproval.Approver1__c != null){
                            toUserIdList.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            toUserIdList.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            toUserIdList.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            toUserIdList.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            toUserIdList.add(cusrApproval.Approver5__c);
                        }
                    }
                }
            }
        }
        else if(cusrForm.Status__c == 'Pending Implementation'){
            cusrImplementationList = [select Id, Fab__c, Status__c, Assignee__c from CuSR_Implementation__c where CuSR_Form__c =: cusrForm.Id];
            if(cusrImplementationList.size() > 0){
                for(CuSR_Implementation__c cusrImplementation: cusrImplementationList){
                    if(cusrImplementation.Fab__c == 'FAB 1' && !(cusrForm.FAB_1_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 2' && !(cusrForm.FAB_2_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 3' && !(cusrForm.FAB_3_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 3E' && !(cusrForm.FAB_3E_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 5' && !(cusrForm.FAB_5_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 6' && !(cusrForm.FAB_6_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 7' && !(cusrForm.FAB_7_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 8' && !(cusrForm.FAB_8_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 9' && !(cusrForm.FAB_9_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'FAB 10' && !(cusrForm.FAB_10_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                    if(cusrImplementation.Fab__c == 'ASIC' && !(cusrForm.ASIC_Void__c) && cusrImplementation.Status__c == 'Pending'){
                        toUserIdList.add(cusrImplementation.Assignee__c);
                    }
                }
            }
        }
        if(!toUserIdList.isEmpty()){
            List<User> toUserList = new List<User>();
            toUserList = [select Id, Email from User where Id IN: toUserIdList];
            User initiator = new User();
            initiator = [select Id, Email from User where Id =: cusrForm.OwnerId];
            Account acc = new Account();
            acc = [select Name from Account where Id =: cusrForm.Customer_Name__c];
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            singleMail.setReplyTo('do-not-reply@globalfoundries.com');
            singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
            List<String> toList = new List<String>();
            for(User toUser: toUserList){
                toList.add(toUser.Email);
            }
            toList.add(initiator.Email);
            singleMail.setToAddresses(toList);
            singleMail.saveAsActivity = false;
            singleMail.setSubject('2nd Reminder: Customer Specific Request for Account '+acc.Name+' is in '+cusrForm.Status__c+' status.');
            String body = 'Dear User,';
            body += '<br/>';
            body += '<br/>';
            body += 'Customer Specific Request CuSR '+cusrForm.Name+' for Account '+acc.Name+' is in '+cusrForm.Status__c+' status.';
            body += '<br/>';
            body += '<br/>';
            body += 'Please review and take necessary actions.';
            body += '<br/>';
            body += '<br/>';
            body += 'Please click the below link to access the record.';
            body += '<br/>';
            body += '<br/>';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank you,';
            body += '<br/>';
            body += 'For further clarification/queries , please contact the CE.';
            body += '<br/>';
            body += 'This is a system generated auto email. Please do not reply.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);  
        }
        system.debug('Size of mails: '+mails.size());
        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }
    }
    
    public void updateCuSRAfterPMApproval(String cusrRecordId){
        //String userType = Schema.SObjectType.User.getKeyPrefix();
        String cusrFields = utilClass.getAllFields('CuSR_Form__c');
        String cusrQuery = 'select '+cusrFields+' from CuSR_Form__c where Id =\''+cusrRecordId+'\'';
        CuSR_Form__c cusrForm = new CuSR_Form__c();
        cusrForm = database.query(cusrQuery);
        cusrForm.Fifth_Day_Reminder__c = false;
        cusrForm.Ninth_Day_Reminder__c = false;
        update cusrForm;
    }
    
    //to get the list of CEs
    public List<User> getCEUsersFromAccount(String tempcusrFormId){
        Set<Id> ceUserIds = new Set<Id>();
        String query = 'select Id, Name, FAB_1__c, FAB_2__c, FAB_3__c, FAB_3E__c, FAB_5__c, FAB_6__c, FAB_7__c, FAB_8__c, FAB_9__c, FAB_10__c, ASIC__c, Customer_Name__c from CuSR_Form__c where Id = \''+tempcusrFormId+'\'';
        CuSR_Form__c cusrForm = database.query(query);
        List<Account_Team_Proxy__c> tempProxyList = [select Id, User__c, Team_Role__c, Account__c, Fab_Assignment__c, User__r.isActive from Account_Team_Proxy__c where Account__c =:cusrForm.Customer_Name__c and Team_Role__c = 'Customer Engineer' and User__r.isActive = true];
        if(!tempProxyList.isEmpty()){
            for(Account_Team_Proxy__c teamProxy: tempProxyList){
                if(teamProxy.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c == true){
                    ceUserIds.add(teamProxy.User__c); 
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
            }
        }
        return [select Id, Email from User where Id IN: ceUserIds];
    }
}