/*Author: Shyam Ravindra Nair
Description: Apex class will act as handler for TriggerOnCuSRVoidHistory trigger.
History:
SNair     13042015     - code creation
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
public with sharing class TriggerOnCuSRVoidHistoryHandler {
    public CuSR_Void_History__c cusrVoidHistory{get;set;}
    public CuSR_Form__c cusrForm{get;set;}
    public User initiator{get;set;}
    public List<User> qaUserList{get;set;}
    public List<User> ceUsers{get;set;}
    public List<User> assigneeList{get;set;}
    public List<User> ampmUserList{get;set;}
    public List<User> approverUserList{get;set;}
    public Account acc{get;set;}
    public List<CuSR_Notification_Group__c> memberList{get;set;}
    public List<CuSR_Implementation__c> cusrImplementationList{get;set;}
    public List<CuSR_Void_History__c> cusrVoidHistoryList{get;set;}
    public List<CuSR_Approval_Process__c> cusrApprovalList{get;set;}
    public User voidedByUser{get;set;}
    public list<String> CCMailList_1=new list<String>();
    public list<String> CCMailList_2=new list<String>();
    public list<String> CCMailList_3=new list<String>();
   public list<String> ToMailList=new list<String>();
    public void afterInsert(List<CuSR_Void_History__c> newCuSRVoidHistory){
    //--Case#00063079---Start--Jabee----
         
        for(CuSR_Void_History__c newCuSRVoid: newCuSRVoidHistory){      
            if(newCuSRVoid.Void_All__c){
                VOIDSendToAddresslist(newCuSRVoid.Id);
                if(CCMailList_1.size()!=0){
                 sendEmailForVoidAll(ToMailList,CCMailList_1);
                }
                if(CCMailList_2.size()!=0){
                    sendEmailForVoidAll(ToMailList,CCMailList_2);
                }
                if(CCMailList_3.size()!=0){
                    sendEmailForVoidAll(ToMailList,CCMailList_3);
                }
            }
            else{
                VOIDSendToAddresslist(newCuSRVoid.Id);
                if(CCMailList_1.size()!=0){
                    sendEmailForVoidingFab(ToMailList,CCMailList_1);
                }
                if(CCMailList_2.size()!=0){
                    sendEmailForVoidingFab(ToMailList,CCMailList_2);
                }
                if(CCMailList_3.size()!=0){
                    sendEmailForVoidingFab(ToMailList,CCMailList_3);
                }
            }
        }
        //--Case#00063079---End--Jabee----
    }
    
     //--Case#00063079---Start--Jabee----
    public Void VOIDSendToAddresslist(String cusrVoidHistoryRecordId){
       
       UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String cusrVoidFields = util.getAllFields('CuSR_Void_History__c');
        String cusrVoidquery = 'select '+cusrVoidFields+' from CuSR_Void_History__c where Id =\''+cusrVoidHistoryRecordId+'\'';
        cusrVoidHistory = database.query(cusrVoidquery);
        voidedByUser = [select Id, Name from User where Id =: cusrVoidHistory.Voided_By__c];
        emailRecipients(cusrVoidHistory.CuSR_Form__c);
        
        List<String> toList = new List<String>();
            toList.add(initiator.Email);
            if(!ampmUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User ampm: ampmUserList){
                    toList.add(ampm.Email);
                }
            }
            if(!assigneeList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User assignee: assigneeList){
                    toList.add(assignee.Email);
                }
            }
            ToMailList.addAll( toList);
       
        List<String> ccList = new List<String>();
        if(!approverUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
            for(User approver: approveruserList){
                    ccList.add(approver.Email);
            }
        }
        if(!qaUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User qa: qaUserList){
                        ccList.add(qa.Email);
                }
        }
        if(ceUsers.size()>0){
            for(User ce: ceUsers){
                ccList.add(ce.Email);
            }
        }
        if(!memberList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
            for(CuSR_Notification_Group__c member: memberList){
                    ccList.add(member.User__r.Email);
            }
        }
        if(ccList.size()>0){
            CCMailList_1=new list<String>();
            for(Integer I=0;I<ccList.size();I++){
               if(!Test.isRunningTest()){
                    if(I<25){
                        CCMailList_1.add(ccList[I]);
                    }
                }if(Test.isRunningTest()){
                    CCMailList_1.add(ccList[0]);
                }
            }
         } 
            if(ccList.size()>25){      
            CCMailList_2=new list<String>();
            for(Integer I=25;I<ccList.size();I++){
                if(!Test.isRunningTest()){
                    if(I<50){
                    CCMailList_2.add(ccList[I]);
                    }
                }
                if(Test.isRunningTest()){
                    CCMailList_2.add(ccList[0]);
                }
            }
            }
            if(ccList.size()>50){
            CCMailList_3=new list<String>();
            for(Integer I=50;I<ccList.size();I++){
                if(!Test.isRunningTest()){
                    if(I<100){
                    CCMailList_3.add(ccList[I]);
                    }
                }
                if(Test.isRunningTest()){
                    CCMailList_3.add(ccList[0]);
                }
            }
            }
        
    }
    //--Case#00063079---End--Jabee----
    
    public void sendEmailForVoidAll(list<string> ToMailList,list<string> CCMailList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String cusrVoidFields = util.getAllFields('CuSR_Void_History__c');
        //String cusrVoidquery = 'select '+cusrVoidFields+' from CuSR_Void_History__c where Id =\''+cusrVoidHistoryRecordId+'\'';
        //cusrVoidHistory = database.query(cusrVoidquery);
        //voidedByUser = [select Id, Name from User where Id =: cusrVoidHistory.Voided_By__c];
        //emailRecipients(cusrVoidHistory.CuSR_Form__c);
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            singleMail.setReplyTo('do-not-reply@globalfoundries.com');
            singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
            /*List<String> toList = new List<String>();
            toList.add(initiator.Email);
            if(!ampmUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User ampm: ampmUserList){
                    toList.add(ampm.Email);
                }
            }
            if(!assigneeList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User assignee: assigneeList){
                    toList.add(assignee.Email);
                }
            }*/
            singleMail.setToAddresses(ToMailList);
            
            /*List<String> ccList = new List<String>();//--Case#00063079---Commented--Jabee----
            if(!approverUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User approver: approveruserList){
                    if(ccList.size()<25){
                        ccList.add(approver.Email);
                    }
                }
            }
            if(!qaUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User qa: qaUserList){
                    if(ccList.size()<25){
                        ccList.add(qa.Email);
                    }
                }
            }
            if(ceUsers.size()>0){
                for(User ce: ceUsers){
                    if(ccList.size()<25){
                    ccList.add(ce.Email);
                    }
                }
            }
            if(!memberList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(CuSR_Notification_Group__c member: memberList){
                    if(ccList.size()<25){
                        ccList.add(member.User__r.Email);
                    }
                }
            }*/
            //--Case#00063079---Commented--Jabee----         
            
            singleMail.setCCAddresses(CCMailList);
            singleMail.saveAsActivity = false;
            singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' has been voided');
            String body = 'Dear Users';
            body += '<br/>';
            body += '<br/>';
            body += 'Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' has been voided by '+voidedByUser.Name+'.';
            body += '<br/>';
            body += '<br/>'; 
            body += 'Reason to Void: '+cusrVoidHistory.Reason_To_Void__c;
            body += '<br/>';
            body += '<br/>';
            body += 'You can access the CuSR using the following link:';
            body += '<br/>';
            body += '<br/>';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
            body += '<br/>';
            body += '<br/>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank You.';
            body += '<br/>';
            body += 'For further clarification/queries, please contact the originator of the CuSR.';
            body += '<br/>';
            body += 'This is a system generated auto email. Please do not reply.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }       
    }
    
    public void sendEmailForVoidingFab(list<String> ToMailList,list<String> CCMailList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String cusrVoidFields = util.getAllFields('CuSR_Void_History__c');
        //String cusrVoidquery = 'select '+cusrVoidFields+' from CuSR_Void_History__c where Id =\''+cusrVoidHistoryRecordId+'\'';
        //cusrVoidHistory = database.query(cusrVoidquery);
        //voidedByUser = [select Id, Name from User where Id =: cusrVoidHistory.Voided_By__c];
        //emailRecipients(cusrVoidHistory.CuSR_Form__c);
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            singleMail.setReplyTo('do-not-reply@globalfoundries.com');
            singleMail.setSenderDisplayName('GLOBALFOUNDRIES');
            /*List<String> toList = new List<String>();
            toList.add(initiator.Email);
            if(!ampmUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User ampm: ampmUserList){
                    toList.add(ampm.Email);
                }
            }
            if(!assigneeList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User assignee: assigneeList){
                    toList.add(assignee.Email);
                }
            }*/
            singleMail.setToAddresses(ToMailList);
            /*List<String> ccList = new List<String>();//--Case#00063079---Commented--Jabee----
            if(!approverUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User approver: approveruserList){
                    if(ccList.size()<25){
                        ccList.add(approver.Email);
                    }
                }
            }
            if(ceUsers.size()>0){
                for(User ce: ceUsers){
                    if(ccList.size()<25){
                        ccList.add(ce.Email);
                    }
                }
            }
            if(!qaUserList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(User qa: qaUserList){
                    if(ccList.size()<25){
                        ccList.add(qa.Email);
                    }
                }
            }
            if(!memberList.isEmpty() && (cusrForm.Status__c != 'New' && cusrForm.Status__c != 'Rejected')){
                for(CuSR_Notification_Group__c member: memberList){
                    ccList.add(member.User__r.Email);
                }
            }*/
            //--Case#00063079---Commented--Jabee----
           
            singleMail.setCCAddresses(CCMailList);
            singleMail.saveAsActivity = false;
            singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' has been voided for '+cusrVoidHistory.Fab__c);
            String body = 'Dear Users';
            body += '<br/>';
            body += '<br/>';
            body += 'Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' has been voided by '+voidedByUser.Name+' for '+cusrVoidHistory.Fab__c+'.';
            body += '<br/>';
            body += '<br/>'; 
            body += 'Reason to Void: '+cusrVoidHistory.Reason_To_Void__c;
            body += '<br/>';
            body += '<br/>';
            body += 'You can access the CuSR using the following link:';
            body += '<br/>';
            body += '<br/>';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
            body += '<br/>';
            body += '<br/>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank You.';
            body += '<br/>';
            body += 'For further clarification/queries, please contact the originator of the CuSR.';
            body += '<br/>';
            body += 'This is a system generated auto email. Please do not reply.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
    }
    
    public void emailRecipients(String cusrFormRecordId){
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
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String cusrFields = util.getAllFields('CuSR_Form__c');
        String cusrquery = 'select '+cusrFields+' from CuSR_Form__c where Id =\''+cusrFormRecordId+'\'';
        cusrForm = database.query(cusrquery);
        initiator = new User();
        initiator = [select Id, Email from User where Id =: cusrForm.OwnerId];
        Set<Id> qaUserIds = new Set<Id>();
        qaUserList = new List<User>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        acc = new Account();
        if(cusrForm.Customer_Name__c != null){
            acc = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
        }
        memberList = new List<CuSR_Notification_Group__c>();
        memberList = [select Id, User__c, User__r.Name, User__r.Email, CuSR_Form__c from CuSR_Notification_Group__c where CuSR_Form__c =: cusrForm.Id];
        List<Account_Team_Proxy__c> teamProxyUserList = [select Id, User__c, Team_Role__c, Account__c, Fab_Assignment__c from Account_Team_Proxy__c where Account__c =: acc.Id and Team_Role__c = 'Customer Engineer'];
        Set<Id> proxyUserIdList = new Set<Id>();
        //List<User> ceUsers = new List<User>();
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
        if(fab1selected){
            fab1QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 1 QA'];
            for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab1QAGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                    qaUserIds.add(m.UserOrGroupId);
                }
            }   
        }
            if(fab2selected){
                fab2QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 2 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab2QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab3selected){
                fab3QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 3 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab3QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab3eselected){
                fab3eQAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 3E QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab3eQAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab5selected){
                fab5QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 5 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab5QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab6selected){
                fab6QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 6 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab6QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab7selected){
                fab7QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 7 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab7QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab8selected){
                fab8QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 8 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab8QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab9selected){
                fab9QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 9 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab9QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(fab10selected){
                fab10QAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR FAB 10 QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: fab10QAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(asicselected){
                asicQAGroup = [select Type, Id, Name from Group where Type =: 'Regular' and Name ='CuSR ASIC QA'];
                for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: asicQAGroup.Id]){
                    if(((String)m.UserOrGroupId).startsWith(userType)){
                            qaUserIds.add(m.UserOrGroupId);
                    }
                }
            }
            if(qaUserIds.size()>0){
                qaUserList = [select Id, Email from User where Id IN: qaUserIds];
            }
            if(teamProxyUserList.size() > 0){
                for(Account_Team_Proxy__c pro : teamProxyUserList){
                    if(pro.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                    if(pro.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c && !(proxyUserIdList.contains(pro.User__c))){
                        proxyUserIdList.add(pro.User__c);
                    }
                }
            }
            ceUsers = new List<User>();
            if(proxyUserIdList.size() > 0){
                ceUsers = [select Id, Email from User where Id IN: proxyUserIdList];
            }
            cusrImplementationList = new List<CuSR_Implementation__c>();
            cusrImplementationList  = [select Id, CuSR_Form__c, Assignee__c from CuSR_Implementation__c where CuSR_Form__c =: cusrForm.Id];
            Set<Id> assigneeSet = new Set<Id>();
            for(CuSR_Implementation__c cusrImplementation: cusrImplementationList){
                assigneeSet.add(cusrImplementation.Assignee__c);
            }
            assigneeList = new List<User>();
            assigneeList = [select Id, Email from User where Id IN: assigneeSet];
            cusrApprovalList = new List<CuSR_Approval_Process__c>();
            cusrApprovalList = [select Id, Type_of_Approver__c, Approver1__c, Approver2__c, Approver3__c, Approver4__c, Approver5__c, AM_Approved_By__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id];
            Set<Id> approverSet = new Set<Id>();
            Set<Id> ampmSet = new Set<Id>();
            ampmUserList = new List<User>();
            approverUserList = new List<User>();
            if(cusrForm.PM_Approved_By__c != null){
                ampmSet.add(cusrForm.PM_Approved_By__c);
            }
            if(!cusrApprovalList.isEmpty()){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(cusrApproval.Type_of_Approver__c == 'AM'){
                        ampmSet.add(cusrApproval.AM_Approved_By__c);
                    }
                    else{
                        if(cusrApproval.Approver1__c != null){
                            approverSet.add(cusrApproval.Approver1__c);
                        }
                        if(cusrApproval.Approver2__c != null){
                            approverSet.add(cusrApproval.Approver2__c);
                        }
                        if(cusrApproval.Approver3__c != null){
                            approverSet.add(cusrApproval.Approver3__c);
                        }
                        if(cusrApproval.Approver4__c != null){
                            approverSet.add(cusrApproval.Approver4__c);
                        }
                        if(cusrApproval.Approver5__c != null){
                            approverSet.add(cusrApproval.Approver5__c);
                        }
                    }
                }
                if(!approverSet.isEmpty()){
                    approverUserList = [select Id, Email from User where Id IN: approverSet];
                }
                if(!ampmSet.isEmpty()){
                    ampmUserList = [select Id, Email from User where Id IN: ampmSet];
                }
            }
    }
}