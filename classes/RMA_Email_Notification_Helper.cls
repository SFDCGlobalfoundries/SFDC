/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This class will help for custom email notification on RMA Record. This class will be used on RMA_Trigger trigger.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Shyam Nair      8-Nov-15      Created the Class
**/
public without sharing class RMA_Email_Notification_Helper {
    public static Map<String, List<String>> groupIdToUsersMap;
    public static Map<String, List<String>> groupIdToManagerMap;
    private static Map<Id,Group> queueMap;
    private static List<GroupMember> groupMemberList;
    private static Map<Id,Group> groupMap;
    private static List<GroupMember> groupUserList; 
    private static Map<Id,User> userMap;
    static{
        getQueueUsers();
    }
    
    private static void getQueueUsers(){
        queueMap = new Map<Id,Group>([select Id,Name from Group where Type = 'Queue' and Name LIKE 'RMA%']);
        
        groupMemberList = [select UserOrGroupId,GroupId,Group.Name from GroupMember where GroupId IN: queueMap.keySet()];
        
        Set<Id> groupIdList = new Set<Id>();
        for(GroupMember member : groupMemberList){
            if(String.valueOf(member.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){
                groupIdList.add(member.UserOrGroupId);
            }
        }
        
        groupMap = new Map<Id,Group>([select Id,Name from Group where Id IN: groupIdList]);
        
        groupUserList = [select UserOrGroupId,GroupId,Group.Name from GroupMember where GroupId IN: groupMap.keySet()];
        
        Set<Id> userList = new Set<Id>();
        for(GroupMember member : groupUserList){
            if(String.valueOf(member.UserOrGroupId).startsWith(RMA_Constants.USER_KEYPREFIX)){
                userList.add(member.UserOrGroupId);
            }
        }
        
        userMap = new Map<Id,User>([select Id,Email,Manager.Email from User where isActive = true and Id IN: userList]);
    } 
    
    public static void afterQualityApproval(RMA__c rmaRec, String emailType){
        String hyperLink = '';
        
        createQueueUserEmailMap();
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        List<RMA_Access_User__c> rmaAccessUserList = new List<RMA_Access_User__c>();
        
        //retrieve users from RMA_Access_User object
        rmaAccessUserList = [select Id, RMA__c, Category__c, RMA__r.Owner.Email, User__r.Email from RMA_Access_User__c where RMA__c =: rmaRec.Id];
            
        //get all CSRs
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c, User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c =: rmaRec.Customer__c and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep','Customer Engineer')];
        List<String> lstUserEmails = new List<String>();
        List<String> lstCEEmails = new List<String>();
        if(!lstAccountTeamProxy.isEmpty()){
            for(Account_Team_Proxy__c proxy : lstAccountTeamProxy){
                if(rmaRec.Customer__c == proxy.Account__c){
                    if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c != 'Customer Engineer'){
                        lstUserEmails.add(proxy.User__r.Email);
                    }
                    else if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c == 'Customer Engineer'){
                        lstCEEmails.add(proxy.User__r.Email);
                    }
                }
            }
        }
        
        if(emailType == 'Technical Quality Approval'){
            toList = new List<String>();
            ccList = new List<String>();
            for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                toList.add(s);
            }
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_CQ_VAL; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_CQ_VAL+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Customer_Qty_Validation__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));
        }
        else if(emailType == 'Failure Analysis'){
            toList = new List<String>();
            ccList = new List<String>();
            for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                toList.add(s);
            }
            if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                if(!rmaAccessUserList.isEmpty()){
                    for(RMA_Access_User__c member : rmaAccessUserList){
                        if(member.Category__c == 'Return Wafer'){
                            toList.add(member.User__r.Email);
                        }
                    }
                }
                if(!lstCEEmails.isEmpty()){
                    for(String cc : lstCEEmails){
                        ccList.add(cc);
                    }   
                }
            }
            else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                if(!rmaAccessUserList.isEmpty()){
                    for(RMA_Access_User__c member : rmaAccessUserList){
                        if(member.Category__c == 'Scrap Certificate'){
                            toList.add(member.User__r.Email);
                        }
                    }
                }
            }
            else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                if(!rmaAccessUserList.isEmpty()){
                    for(RMA_Access_User__c member : rmaAccessUserList){
                        if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                            toList.add(member.User__r.Email);
                        }
                    }
                }
                if(!lstCEEmails.isEmpty()){
                    for(String cc : lstCEEmails){
                        ccList.add(cc);
                    }   
                }
            }
            if(!lstUserEmails.isEmpty()){
                for(String cc: lstUserEmails){
                    ccList.add(cc);
                }
            }
            for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                ccList.add(s);
            }
            if(!rmaAccessUserList.isEmpty()){
                for(RMA_Access_User__c member : rmaAccessUserList){
                    if(member.Category__c == 'Notify/Circulate'){
                        ccList.add(member.User__r.Email);
                    }
                }
            }
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
            body += '<br/>';
            body += '<br/>';
            body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));
        }
        else if(emailType == 'Pending for Product Engineer Validation'){            
            toList = new List<String>();
            ccList = new List<String>();
            for(String s : groupIdToUsersMap.get('RMA PE Personnel')){
                toList.add(s);
            }  
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_ENG; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_ENG+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));  
            
            //for Ackowledgement
            if((rmaRec.Disposition_of_Wafers__c == 'Return to GF' && !rmaRec.Acknowledged_Wafer_Return__c)
            || (rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && !rmaRec.Acknowledged_Wafer_Scrap__c)
            || (rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site' && (!rmaRec.Acknowledged_Wafer_Return__c 
            || !rmaRec.Acknowledged_Wafer_Scrap__c))){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(!lstUserEmails.isEmpty()){
                    for(String cc: lstUserEmails){
                        ccList.add(cc);
                    }
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_ENG; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_ENG+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        else if(emailType == 'Pending for Fab Validation'){
            toList = new List<String>();
            ccList = new List<String>();
            for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                toList.add(s);
            }
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));  
            
            //for Ackowledgement
            if((rmaRec.Disposition_of_Wafers__c == 'Return to GF' && !rmaRec.Acknowledged_Wafer_Return__c)
            || (rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && !rmaRec.Acknowledged_Wafer_Scrap__c)
            || (rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site' && (!rmaRec.Acknowledged_Wafer_Return__c || !rmaRec.Acknowledged_Wafer_Scrap__c))){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(!lstUserEmails.isEmpty()){
                    for(String cc: lstUserEmails){
                        ccList.add(cc);
                    }
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
            
            if(rmaRec.Notify_For_Fab__c != NULL){
                toList = new List<String>();
                ccList = new List<String>();
                if(!rmaAccessUserList.isEmpty()){
                    for(RMA_Access_User__c member : rmaAccessUserList){
                        if(member.Category__c == 'Fab'){
                            toList.add(member.User__r.Email);
                        }
                    }
                }
                ccList.add(rmaRec.Originator_Email__c);
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_FAB_VAL+'.';
                body += 'Please validate the RMA.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        else if(emailType == 'Pending for Turnkey/ Sub-con Validation'){
            toList = new List<String>();
            ccList = new List<String>();
            for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                toList.add(s);
            }
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL;
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList,ccList,subject,body));
            
            //for Ackowledgement
            if((rmaRec.Disposition_of_Wafers__c == 'Return to GF' && !rmaRec.Acknowledged_Wafer_Return__c)
            || (rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && !rmaRec.Acknowledged_Wafer_Scrap__c)
            || (rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site' && (!rmaRec.Acknowledged_Wafer_Return__c || !rmaRec.Acknowledged_Wafer_Scrap__c))){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(!lstUserEmails.isEmpty()){
                    for(String cc: lstUserEmails){
                        ccList.add(cc);
                    }
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
            
            if(rmaRec.Notify_For_Turnkey__c != NULL){
                toList = new List<String>();
                ccList = new List<String>();
                if(!rmaAccessUserList.isEmpty()){
                    for(RMA_Access_User__c member : rmaAccessUserList){
                        if(member.Category__c == 'Turnkey'){
                            toList.add(member.User__r.Email);
                        }
                    }
                }
                ccList.add(rmaRec.Originator_Email__c);
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_TNK_VAL+'.';
                body += 'Please validate the RMA.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        else if(emailType == 'Pending for Product Engineering - Manager'){
            toList = new List<String>();
            ccList = new List<String>();
            for(String s : groupIdToUsersMap.get('RMA PE Manager')){
                toList.add(s);
            }
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_MGR; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_MGR+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Regional_Approval__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));
            
            //for Ackowledgement
            if(rmaRec.RMA_Category__c == 'Business'
            && (rmaRec.Disposition_of_Wafers__c == 'Return to GF' && !rmaRec.Acknowledged_Wafer_Return__c)
            || (rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && !rmaRec.Acknowledged_Wafer_Scrap__c)
            || (rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site' && (!rmaRec.Acknowledged_Wafer_Return__c || !rmaRec.Acknowledged_Wafer_Scrap__c))){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(!lstUserEmails.isEmpty()){
                    for(String cc: lstUserEmails){
                        ccList.add(cc);
                    }
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_MGR; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_PRD_MGR+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        else if(emailType == 'Pending for Regional Recommendation Director'){
            toList = new List<String>();
            ccList = new List<String>();
            toList.add(rmaRec.Region_Head_Email__c);
            if(!String.isEmpty(rmaRec.Region_Head_Backup_Email__c)){
                toList.add(rmaRec.Region_Head_Backup_Email__c);
            }
            ccList.add(rmaRec.Originator_Email__c);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_REG_DIR; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_REG_DIR+'.';
            body += 'Please respond within '+rmaRec.Cycle_Time_for_Regional_Approval__c+' days.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body));  
            
            //for Ackowledgement
            if(rmaRec.RMA_Category__c == 'Business' 
            && (rmaRec.Disposition_of_Wafers__c == 'Return to GF' && !rmaRec.Acknowledged_Wafer_Return__c)
            || (rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site' && !rmaRec.Acknowledged_Wafer_Scrap__c)
            || (rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site' && (!rmaRec.Acknowledged_Wafer_Return__c || !rmaRec.Acknowledged_Wafer_Scrap__c))){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(!rmaAccessUserList.isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserList){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!lstCEEmails.isEmpty()){
                        for(String cc : lstCEEmails){
                            ccList.add(cc);
                        }   
                    }
                }
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(!lstUserEmails.isEmpty()){
                    for(String cc: lstUserEmails){
                        ccList.add(cc);
                    }
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_REG_DIR; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+RMA_Constants.PEN_REG_DIR+'.';
                body += '<br/>';
                body += '<br/>';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        //to send emails
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }  
    
    public static void sendEmailNotification(List<RMA__c> RMARecordList, String emailType){
        
        String hyperLink = '';
        
        createQueueUserEmailMap();
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        Map<RMA__c, List<RMA_Access_User__c>> rmaAccessUserMap = new Map<RMA__c, List<RMA_Access_User__c>>();
        List<RMA_Access_User__c> rmaAccessUserList = new List<RMA_Access_User__c>();
        
        //retrieve users from RMA_Access_User object
        rmaAccessUserList = [select Id, RMA__c, Category__c, RMA__r.Owner.Email, User__r.Email from RMA_Access_User__c where RMA__c IN: RMARecordList];
        if(!rmaAccessUserList.isEmpty()){
            for(RMA__c rmaRec: RMARecordList){
                List<RMA_Access_User__c> tempList = new List<RMA_Access_User__c>();
                for(RMA_Access_User__c member: rmaAccessUserList){
                    if(member.RMA__c == rmaRec.Id){
                        tempList.add(member);
                    }       
                } 
                rmaAccessUserMap.put(rmaRec, tempList);
            }
        }
        
        //to get Non-Fab users
        Map<RMA__c,List<String>> rmaNonFabMap = new Map<RMA__c,List<String>>(); 
        Set<String> userIdList = new Set<String>();
        for(RMA__c rmaRec : RMARecordList){
            List<String> tempList = new List<String>();
            for(Schema.FieldSetMember members: SObjectType.RMA__c.FieldSets.RMA_Non_Fab_Approvers.getFields()){
                if(rmaRec.get(members.getFieldPath()) != NULL){
                    tempList.add((String)rmaRec.get(members.getFieldPath()));
                    userIdList.add((String)rmaRec.get(members.getFieldPath())); 
                }
            }
            rmaNonFabMap.put(rmaRec,tempList);
        }
        
        Map<String,User> userEmailMap = new Map<String,User>([select Id,Email,Manager.Email from User where Id IN : userIdList]);
        
        Map<RMA__c,List<String>> nonFabFinalMap = new Map<RMA__c,List<String>>();
        Map<RMA__c,List<String>> nonFabManagerFinalMap = new Map<RMA__c,List<String>>();
        
        if(!rmaNonFabMap.isEmpty()){
            for(RMA__c rmaRec : RMARecordList){
                List<String> tempList1 = new List<String>();
                List<String> tempList2 = new List<String>();
                for(String i : rmaNonFabMap.get(rmaRec)){
                    if(userEmailMap.containsKey(i)){
                        tempList1.add(userEmailMap.get(i).Email);
                        tempList2.add(userEmailMap.get(i).Manager.Email);
                    }
                }
                nonFabFinalMap.put(rmaRec,tempList1);
                nonFabManagerFinalMap.put(rmaRec,tempList2);
            }
        }
        
        //get all CSRs
        Map<RMA__c, List<String>>  mapRMAProxyEmails = new Map<RMA__c, List<String>>();
        Map<RMA__c, List<String>>  mapRMACEEmails = new Map<RMA__c, List<String>>();
        Set<String> setAccountId = new Set<String>();
        for(RMA__c rmaRec : RMARecordList){
            setAccountId.add(rmaRec.Customer__c);
        }
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c, User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c IN: setAccountId and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep','Customer Engineer')];
        for(RMA__c rmaRec : RMARecordList){
            List<String> lstUserEmails = new List<String>();
            List<String> lstCEEmails = new List<String>();
            for(Account_Team_Proxy__c proxy : lstAccountTeamProxy){
                if(rmaRec.Customer__c == proxy.Account__c){
                    if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c != 'Customer Engineer'){
                        lstUserEmails.add(proxy.User__r.Email);
                    }
                    else if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c == 'Customer Engineer'){
                        lstCEEmails.add(proxy.User__r.Email);
                    }
                }
            }
            if(!lstUserEmails.isEmpty()){
                mapRMAProxyEmails.put(rmaRec,lstUserEmails);
            }
            if(!lstCEEmails.isEmpty()){
                mapRMACEEmails.put(rmaRec,lstCEEmails);
            }
        }
        
        //when submitted for Pending for Regional Approval - Snr. VP
        if(emailType == 'Pending for Regional Approval - Snr. VP'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Sales_SVP_Email__c);
                ccList.add(rmaRec.Originator_Email__c);
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += 'Please respond within '+rmaRec.Cycle_Time_for_Regional_Approval__c+' days.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
                
            }
        }
        
        if(emailType == 'Product Engineering - Director Approval'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s : groupIdToUsersMap.get('RMA PE Director')){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += 'Please respond within '+rmaRec.Cycle_Time_for_Regional_Approval__c+' days.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));  
                
            }
        }
        
        if(emailType=='Tech-Reg Validation'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                toList.add(rmaRec.Region_Head_Email__c);
                if(!String.isEmpty(rmaRec.Region_Head_Backup_Email__c)){
                    toList.add(rmaRec.Region_Head_Backup_Email__c);
                }
                ccList = new List<String>();
                ccList.add(rmaRec.Originator_Email__c);
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += 'Please respond within '+rmaRec.Cycle_Time_for_Regional_Approval__c+' days.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));  
            }
        }
        
        //For voided RMAs
        if(emailType == 'Void'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Region_Head_Email__c);
                if(!String.isEmpty(rmaRec.Region_Head_Backup_Email__c)){
                    toList.add(rmaRec.Region_Head_Backup_Email__c);
                }
                for(String s : groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Reason for Voiding: '+rmaRec.Reason_to_Void__c;
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));  
                
            }
        }
        
        //Pending for Finance Approval
        if(emailType == 'Pending Finance Approval'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                String previousAppr = 'RMA Fab Finance Manager';
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                    body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'The physical wafers/scrap cert wafers has been received, Pending Finance approval.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please respond immediately.';
                    body += '<br/>';
                    body += '<br/>';
                    body += createHyperLink(rmaRec);
                    body += '<br/>';
                    body += '<br/>';
                    body += createDisclaimer(rmaRec,false);
                }
                else{
                    if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                        if(!rmaRec.Is_SMPLSI__c){
                            for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                                toList.add(s);
                            }   
                        }
                        else{
                            for(String s : groupIdToUsersMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                                toList.add(s);
                            }
                        }
                    }
                    else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                        for(String s : groupIdToUsersMap.get('RMA VP Operations - Finance')){
                            toList.add(s);
                        }
                    }
                    else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                        for(String s : groupIdToUsersMap.get('RMA Corporate Controller')){
                            toList.add(s);
                        }
                    }
                    else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                        for(String s : groupIdToUsersMap.get('RMA Pricing Council')){
                            toList.add(s);
                        }
                    }
                    body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'The RMA has been approved by '+previousAppr+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please respond immediately.';
                    body += '<br/>';
                    body += '<br/>';
                    body += createHyperLink(rmaRec);
                    body += '<br/>';
                    body += '<br/>';
                    body += createDisclaimer(rmaRec,false);
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c; 
                ccList.add(rmaRec.Originator_Email__c);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        if(emailType == 'Quality Rejected'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    ccList.add(s);
                }
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please take necessary action before re-submitting.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        if(emailType == 'Tech Validation Rejected'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s : groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please take necessary action before re-submitting.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        if(emailType == 'Regional Rejected'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head_Email__c);
                    if(!String.isEmpty(rmaRec.Region_Head_Backup_Email__c)){
                        toList.add(rmaRec.Region_Head_Backup_Email__c);
                    }
                    for(String s : groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                    for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                    /*for(String s: groupIdToUsersMap.get('RMA Global AR Team')){
                        ccList.add(s);
                    }*/
                    if(rmaRec.Grand_Total_Final__c > 25000 && rmaRec.Grand_Total_Final__c<=50000){
                        for(String s: groupIdToUsersMap.get('RMA Finance Director')){
                            ccList.add(s);
                        }
                    }
                    else if(rmaRec.Grand_Total_Final__c > 50000 && rmaRec.Grand_Total_Final__c<=1000000){
                        for(String s: groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                    else if(rmaRec.Grand_Total_Final__c > 1000000 && rmaRec.Grand_Total_Final__c<=3000000){
                        for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                            ccList.add(s);
                        }
                    }
                    else if((rmaRec.Grand_Total_Final__c > 3000000 && rmaRec.Grand_Total_Final__c<=5000000 && rmaRec.Fab__c != 'FAB 5')
                    ||(rmaRec.Grand_Total_Final__c > 60000 && rmaRec.Grand_Total_Final__c<=5000000 && rmaRec.Fab__c == 'FAB 5')){
                        for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                            ccList.add(s);
                        }
                    }
                    else if(rmaRec.Grand_Total_Final__c > 5000000){
                        for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA PE Director')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA PE Manager')){
                        ccList.add(s);
                    }
                }
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please take necessary action before re-submitting.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        if(emailType == 'Finance Rejected'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA Global AR Team')){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA AR Section Manager')){
                    ccList.add(s);
                }
                for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Please take necessary action before re-submitting.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList, ccList, subject, body));
                
            }
        }
        
        //for sending emails or Fab Validation Extension
        if(emailType == 'Request Extension'){
            for(RMA__c rmaRec: RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                ccList = new List<String>();
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            ccList.add(s);  
                        }   
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Fab validation personnel '+rmaRec.Extension_Requested_By__c+' has requested to extend time for validation and is pending for your approval.';
                body += '<br/>';
                body += '<br/>';
                body += 'Request to Extend by : '+rmaRec.Number_of_Days__c+' days';
                body += '<br/>';
                body += 'Reason for request : '+rmaRec.Extension_Reason__c;
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //when pending acknowledgement
        if(emailType == 'Pending for Acknowledgement'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s : groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                
                subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c; 
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is pending for your acknowledgement upon receipt of physical wafers/ receipt of scrap certificate.  Please acknowledge in the system within '+rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c+' working day upon the receipt of the physical wafers.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList, ccList, subject, body));
            }
        }
        
        //when extension rejected
        if(emailType == 'Extension Rejected'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }   
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'The Extension request is rejected.';
                body += '<br/>';
                body += '<br/>';
                body += 'Reason: '+rmaRec.Extension_Approve_Reject_Reason__c;
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //when extension approved
        if(emailType == 'Extension Approved'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                ccList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'The Extension request is Appproved.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //when assgined to other technical validation group
        if(emailType == 'Pending for Technical Validation'){
            String category = '';
            for(RMA__c rmaRec: RMARecordList){
                category = '';
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                    ccList.add(rmaRec.Originator_Email__c);
                    
                    subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                    body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'This RMA is been assigned for Non-Fab personnel validation.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
                    body += '<br/>';
                    body += '<br/>';
                    body += createHyperLink(rmaRec);
                    body += '<br/>';
                    body += '<br/>';
                    body += createDisclaimer(rmaRec,false);
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    category = 'Turnkey';
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                    ccList.add(rmaRec.Originator_Email__c);
                    
                    subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                    body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'This RMA is been assigned for Turnkey/Sub-con validation.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
                    body += '<br/>';
                    body += '<br/>';
                    body += createHyperLink(rmaRec);
                    body += '<br/>';
                    body += '<br/>';
                    body += createDisclaimer(rmaRec,true);
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    category = 'Fab';
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                    ccList.add(rmaRec.Originator_Email__c);
                    
                    subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                    body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'This RMA is been assigned for Fab validation.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please respond within '+rmaRec.Cycle_Time_for_Fab_Validation__c+' days.';
                    body += '<br/>';
                    body += '<br/>';
                    body += createHyperLink(rmaRec);
                    body += '<br/>';
                    body += '<br/>';
                    body += createDisclaimer(rmaRec,true);
                }
                mails.add(createEmail(toList,ccList,subject,body));
                
                if(category != ''){
                    toList = new List<String>();
                    ccList = new List<String>();
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == category){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(!toList.isEmpty()){
                        ccList.add(rmaRec.Originator_Email__c);
                        subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c; 
                        body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                        body += 'Please validate the RMA.';
                        body += '<br/>';
                        body += '<br/>';
                        body += createHyperLink(rmaRec);
                        body += '<br/>';
                        body += '<br/>';
                        body += createDisclaimer(rmaRec,true);
                        
                        mails.add(createEmail(toList, ccList, subject, body));
                    }  
                }
            }
            
        }
        
        if(emailType == 'Reject Acknowledgement'){
            for(RMA__c rmaRec: RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'The Store Personnels have refused to acknowledge the RMA. Please take necessary actions and resubmit the RMA.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Pending for SO Issue'){
            for(RMA__c rmaRec: RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Pending for CN Issue'){
            for(RMA__c rmaRec: RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Closed after CN Issue'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(rmaRec.Grand_Total_Final__c > 25000 && rmaRec.Grand_Total_Final__c<=50000){
                    for(String s: groupIdToUsersMap.get('RMA Finance Director')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 50000 && rmaRec.Grand_Total_Final__c<=1000000){
                    for(String s: groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 1000000 && rmaRec.Grand_Total_Final__c<=3000000){
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        toList.add(s);
                    }
                }
                else if((rmaRec.Grand_Total_Final__c > 3000000 && rmaRec.Grand_Total_Final__c<=5000000 && rmaRec.Fab__c != 'FAB 5')
                ||(rmaRec.Grand_Total_Final__c > 60000 && rmaRec.Grand_Total_Final__c<=5000000 && rmaRec.Fab__c == 'FAB 5')){
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 5000000){
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        toList.add(s);
                    }
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is Approved & Closed';
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is Approved & Closed.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA has been Approved & Closed.  Refer to the following details:';
                body += '<br/>';
                body += 'RMA Wafer Qty : '+rmaRec.Total_Wafers_Final__c;
                body += '<br/>';
                body += 'RMA Amount : '+rmaRec.Grand_Total_Final__c;
                body += '<br/>';
                if(rmaRec.CN_DN_Number__c != NULL){
                    body += 'CN# : '+rmaRec.CN_DN_Number__c;
                }
                else if(rmaRec.Sales_Order_Number__c != NULL){
                    body += 'SO# : '+rmaRec.Sales_Order_Number__c;
                }
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Closed RMA for FA'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                subject = rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is Approved & Closed';
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is Approved/Closed.';
                body += '<br/>';
                body += '<br/>';
                body += 'The Physical wafers , Wfr qty '+rmaRec.Total_Wafers__c+' has been received.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA has been Approved & Closed.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //to send emails
        if(!mails.isEmpty()){
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
            }else{
                List<Messaging.SingleEmailMessage> mailSingle = new List<Messaging.SingleEmailMessage>();
                mailSingle.add(mails[0]);
                Messaging.sendEmail(mailSingle);
            }
        }
        
    }
    
    public static void sendReminderEmail(List<RMA__c> RMARecordList, String emailType){
        String hyperLink = '';
        
        createQueueUserEmailMap();
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        Map<RMA__c, List<RMA_Access_User__c>> rmaAccessUserMap = new Map<RMA__c, List<RMA_Access_User__c>>();
        List<RMA_Access_User__c> rmaAccessUserList = new List<RMA_Access_User__c>();
        
        //retrieve users from RMA_Access_User object
        rmaAccessUserList = [select Id, RMA__c, Category__c, RMA__r.Owner.Email, User__r.Email from RMA_Access_User__c where RMA__c IN: RMARecordList];
        if(!rmaAccessUserList.isEmpty()){
            for(RMA__c rmaRec: RMARecordList){
                List<RMA_Access_User__c> tempList = new List<RMA_Access_User__c>();
                for(RMA_Access_User__c member: rmaAccessUserList){
                    if(member.RMA__c == rmaRec.Id){
                        tempList.add(member);
                    }       
                } 
                rmaAccessUserMap.put(rmaRec, tempList);
            }
        }
        
        //to get Non-Fab users
        Map<RMA__c,List<Id>> rmaNonFabMap = new Map<RMA__c,List<Id>>(); 
        Set<Id> userIdList = new Set<Id>();
        for(RMA__c rmaRec : RMARecordList){
            List<Id> tempList = new List<Id>();
            for(Schema.FieldSetMember members: SObjectType.RMA__c.FieldSets.RMA_Non_Fab_Approvers.getFields()){
                if(rmaRec.get(members.getFieldPath()) != NULL){
                    tempList.add((Id)rmaRec.get(members.getFieldPath()));
                    userIdList.add((Id)rmaRec.get(members.getFieldPath())); 
                }
            }
            rmaNonFabMap.put(rmaRec,tempList);
        }
        
        Map<Id,User> userEmailMap = new Map<Id,User>([select Id,Email,Manager.Email from User where Id IN : userIdList]);
        
        Map<RMA__c,List<String>> nonFabFinalMap = new Map<RMA__c,List<String>>();
        Map<RMA__c,List<String>> nonFabManagerFinalMap = new Map<RMA__c,List<String>>();
        
        for(RMA__c rmaRec : RMARecordList){
            List<String> tempList1 = new List<String>();
            List<String> tempList2 = new List<String>();
            for(Id i : rmaNonFabMap.get(rmaRec)){
                if(userEmailMap.containsKey(i)){
                    tempList1.add(userEmailMap.get(i).Email);
                    tempList2.add(userEmailMap.get(i).Manager.Email);
                }
            }
            nonFabFinalMap.put(rmaRec,tempList1);
            nonFabManagerFinalMap.put(rmaRec,tempList2);
        }
        
        //get all CSRs
        Map<RMA__c, List<String>>  mapRMAProxyEmails = new Map<RMA__c, List<String>>();
        Map<RMA__c, List<String>>  mapRMACEEmails = new Map<RMA__c, List<String>>();
        Set<String> setAccountId = new Set<String>();
        for(RMA__c rmaRec : RMARecordList){
            setAccountId.add(rmaRec.Customer__c);
        }
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c, User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c IN: setAccountId and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep','Customer Engineer')];
        for(RMA__c rmaRec : RMARecordList){
            List<String> lstUserEmails = new List<String>();
            List<String> lstCEEmails = new List<String>();
            for(Account_Team_Proxy__c proxy : lstAccountTeamProxy){
                if(rmaRec.Customer__c == proxy.Account__c){
                    if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c != 'Customer Engineer'){
                        lstUserEmails.add(proxy.User__r.Email);
                    }
                    else if(rmaRec.OwnerId != proxy.User__c && proxy.Team_Role__c == 'Customer Engineer'){
                        lstCEEmails.add(proxy.User__r.Email);
                    }
                }
            }
            if(!lstUserEmails.isEmpty()){
                mapRMAProxyEmails.put(rmaRec,lstUserEmails);
            }
            if(!lstCEEmails.isEmpty()){
                mapRMACEEmails.put(rmaRec,lstCEEmails);
            }
        }
        
        //22 days after rejection
        if(emailType == 'Rejected Reminder 22 days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Status__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Status__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'For your information, as no action taken on this document for the last 3 weeks, system auto voided this RMA.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,false);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //For Quality Approval escalation Emails
        if(emailType == 'Quality Approval Due Date'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Today is the due date to respond this RMA, so please respond immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Quality Approval Due 1 Day'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    toList.add(s);
                }
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    ccList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 1 day. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Quality Approval Due 2 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    toList.add(s);
                }
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    ccList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 2 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Quality Approval Due 3 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    toList.add(s);
                }
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c+' Technical Quality Team')){
                    ccList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 3 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        } 
        
        //For Fab validation escalation Emails
        if(emailType == 'Fab Validation Due Date'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }   
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                }
                
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Today is the due date to respond this RMA, so please respond immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Fab Validation Due 1 Day'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }   
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToManagerMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabManagerFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabManagerFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            ccList.add(s);  
                        }   
                    }
                }
                
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 1 day. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Fab Validation Due 2 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }   
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToManagerMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabManagerFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabManagerFinalMap.get(rmaRec)){
                            ccList.add(s);  
                        }   
                    }
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            toList.add(s);  
                        }   
                    }
                }
                
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 2 days . Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Fab Validation Due 3 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL){
                    for(String s: groupIdToManagerMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }   
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                    for(String s: groupIdToManagerMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Turnkey '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                    if(!nonFabManagerFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabManagerFinalMap.get(rmaRec)){
                            ccList.add(s);  
                        }   
                    }
                    if(!nonFabFinalMap.get(rmaRec).isEmpty()){
                        for(String s : nonFabFinalMap.get(rmaRec)){
                            ccList.add(s);  
                        }   
                    }
                }
                
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 3 days . Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //for wafer/scrap acknowledgement reminder
        if(emailType == 'Ackn Due Date'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                toList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.Is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Is_SMPLSI__c){
                    //need to check with Nikhil
                }
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Today is the due date to acknowledge this RMA, so please acknowledge immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Ackn Due 1 Day'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                
                toList.add(rmaRec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    toList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(rmaRec.Originator_Supervisor_Email__c != NULL){
                    toList.add(rmaRec.Originator_Supervisor_Email__c);
                }
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(!rmaRec.Is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }   
                }   
                else if(rmaRec.Is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                    //need to check for Fab PE Personnel and PE Manager
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 1 day. Please take appropriate action and prompt the owners so that this RMA is responded immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Ackn Due 2 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                
                if(!rmaRec.is_SMPLSI__c){
                    toList.add(rmaRec.Region_Head_Email__c);    
                }
                else if(rmaRec.is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA PE Director')){
                        toList.add(s);
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(rmaRec.Originator_Supervisor_Email__c != NULL){
                    ccList.add(rmaRec.Originator_Supervisor_Email__c);
                }
                
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(!rmaRec.is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }   
                }
                else if(rmaRec.is_SMPLSI__c){
                    //need to check with Nikhil
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 2 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Ackn Due 3 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(rmaRec.Originator_Supervisor_Email__c != NULL){
                    ccList.add(rmaRec.Originator_Supervisor_Email__c);
                }
                
                if(rmaRec.Disposition_of_Wafers__c == 'Return to GF'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'To Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                }
                else if(rmaRec.Disposition_of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                    if(rmaAccessUserMap.containsKey(rmaRec) && !rmaAccessUserMap.get(rmaRec).isEmpty()){
                        for(RMA_Access_User__c member : rmaAccessUserMap.get(rmaRec)){
                            if(member.Category__c == 'Scrap Certificate' || member.Category__c == 'Return Wafer'){
                                ccList.add(member.User__r.Email);
                            }
                        }
                    }
                    if(mapRMACEEmails.containsKey(rmaRec) && !mapRMACEEmails.get(rmaRec).isEmpty()){
                        ccList.addAll(mapRMACEEmails.get(rmaRec));
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA Store Personnel- '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head__c);  
                }
                else if(rmaRec.is_SMPLSI__c){
                    for(String s: groupIdToUsersMap.get('RMA PE Director')){
                        toList.add(s);
                    }
                }
                for(String s: groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 3 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Regional Reminder Due Date'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR){
                    toList.add(rmaRec.Region_Head_Email__c);
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                    toList.add(rmaRec.Sales_SVP_Email__c);
                }
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR){
                    for(String s: groupIdToUsersMap.get('RMA PE Manager')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_DIR){
                    for(String s: groupIdToUsersMap.get('RMA PE Director')){
                        toList.add(s);
                    }
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Today is the due date to respond this RMA, so please respond immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Regional Reminder 1 Day'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR){
                    if(rmaRec.Region_Head_Manager_Email__c != NULL){
                        toList.add(rmaRec.Region_Head_Manager_Email__c);    
                    }
                    ccList.add(rmaRec.Region_Head_Email__c);
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                    if(rmaRec.Sales_SVP_Manager_Email__c != NULL){
                        toList.add(rmaRec.Sales_SVP_Manager_Email__c);
                    }
                    if(rmaRec.Sales_SVP_Email__c != NULL){
                        ccList.add(rmaRec.Sales_SVP_Email__c);
                    }
                }
                
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 1 day. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Regional Reminder 2 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR){
                    if(rmaRec.Region_Head_Manager_Email__c != NULL){
                        toList.add(rmaRec.Region_Head_Manager_Email__c);    
                    }
                    ccList.add(rmaRec.Region_Head_Email__c);
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                    if(rmaRec.Sales_SVP_Manager_Email__c != NULL){
                        toList.add(rmaRec.Sales_SVP_Manager_Email__c);
                    }
                    if(rmaRec.Sales_SVP_Email__c != NULL){
                        ccList.add(rmaRec.Sales_SVP_Email__c);
                    }
                }
                
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    ccList.add(s);
                }
                subject = 'Escalation - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 2 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Regional Reminder 3 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR){
                    if(rmaRec.Region_Head_Manager_Email__c != NULL){
                        toList.add(rmaRec.Region_Head_Manager_Email__c);    
                    }
                    ccList.add(rmaRec.Region_Head_Email__c);
                    for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                    if(rmaRec.Sales_SVP_Manager_Email__c != NULL){
                        toList.add(rmaRec.Sales_SVP_Manager_Email__c);
                    }
                    if(rmaRec.Sales_SVP_Email__c != NULL){
                        ccList.add(rmaRec.Sales_SVP_Email__c);
                    }
                    for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                        ccList.add(s);
                    }
                }
                
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                
                subject = 'Escalation - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 3 days. Please take appropriate action and prompt the owners so that this RMA is responded immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Finance Reminder Due Date'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                }
                
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }   
                    }
                    else{
                        for(String s : groupIdToUsersMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        toList.add(s);
                    }
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head__c);
                }
                
                subject = 'Reminder - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'Today is the due date to approve this RMA, so please approve immediately.';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
            
        }
        
        if(emailType == 'Finance Reminder 1 Day'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }   
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                    for(String s: groupIdToManagerMap.get('RMA VP Operations - Finance')){
                        toList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    for(String s: groupIdToManagerMap.get('RMA Corporate Controller')){
                        toList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    for(String s: groupIdToManagerMap.get('RMA Pricing Council')){
                        toList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        ccList.add(s);
                    }
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head__c);
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 1 day. Please take appropriate action and prompt the owners so that this RMA is approved immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Finance Reminder 2 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                if(rmaRec.Grand_Total_Final__c > 9000 && rmaRec.Grand_Total_Final__c <= 60000 && rmaRec.Fab__c  == 'FAB 5'){
                    for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 50000 && rmaRec.Grand_Total_Final__c <= 1000000){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            toList.add(s);
                        }
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 1000000 && rmaRec.Grand_Total_Final__c<=3000000){
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 3000000 && rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        toList.add(s);
                    }
                }
                else if(rmaRec.Grand_Total_Final__c > 5000000 && rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        toList.add(s);
                    }
                }
                
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }   
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                    for(String s: groupIdToManagerMap.get('RMA VP Operations - Finance')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    for(String s: groupIdToManagerMap.get('RMA Corporate Controller')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    for(String s: groupIdToManagerMap.get('RMA Pricing Council')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        ccList.add(s);
                    }
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head__c);
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 2 days. Please take appropriate action and prompt the owners so that this RMA is approved immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        if(emailType == 'Finance Reminder 3 Days'){
            for(RMA__c rmaRec : RMARecordList){
                toList = new List<String>();
                ccList = new List<String>();
                //Need to check with Nikhil for CFO
                for(String s: groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
                    toList.add(s);
                }
                
                if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Finance Manager Interco- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                    if(!rmaRec.Is_SMPLSI__c){
                        for(String s : groupIdToManagerMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }   
                    }
                    else{
                        for(String s : groupIdToManagerMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                        for(String s : groupIdToUsersMap.get('RMA Fab Director Intercompany- '+rmaRec.Fab__c)){
                            ccList.add(s);
                        }
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                    for(String s: groupIdToManagerMap.get('RMA VP Operations - Finance')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA VP Operations - Finance')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    for(String s: groupIdToManagerMap.get('RMA Corporate Controller')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Corporate Controller')){
                        ccList.add(s);
                    }
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    for(String s: groupIdToManagerMap.get('RMA Pricing Council')){
                        ccList.add(s);
                    }
                    for(String s: groupIdToUsersMap.get('RMA Pricing Council')){
                        ccList.add(s);
                    }
                }
                ccList.add(RMArec.Originator_Email__c);
                if(mapRMAProxyEmails.containsKey(rmaRec) && !mapRMAProxyEmails.get(rmaRec).isEmpty()){
                    ccList.addAll(mapRMAProxyEmails.get(rmaRec));
                }
                if(!rmaRec.is_SMPLSI__c){
                    ccList.add(rmaRec.Region_Head__c);
                }
                subject = 'Escalation Mail - '+rmaRec.Fab__c+' '+rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+rmaRec.Workflow_Stage__c;
                body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' had been raised and is '+rmaRec.Workflow_Stage__c+'.';
                body += '<br/>';
                body += '<br/>';
                body += 'This RMA is over due by 3 days. Please take appropriate action and prompt the owners so that this RMA is approved immediately';
                body += '<br/>';
                body += '<br/>';
                body += createHyperLink(rmaRec);
                body += '<br/>';
                body += '<br/>';
                body += createDisclaimer(rmaRec,true);
                
                mails.add(createEmail(toList,ccList,subject,body));
            }
        }
        
        //to send emails
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
        
    }
    
    public static void checkFailReliability(RMA__c rmaRec, String Stage){
        String hyperLink = '';
        
        createQueueUserEmailMap();
        
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c, User__r.Email from Account_Team_Proxy__c where Account__c =: rmaRec.Customer__c and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        
        for(String s : groupIdToUsersMap.get('RMA QA '+rmaRec.Fab__c)){
            toList.add(s);
        }
        for(String s : groupIdToUsersMap.get('RMA '+rmaRec.Fab__c)){
            toList.add(s);
        }
        ccList.add(rmaRec.Originator_Email__c);
        if(lstAccountTeamProxy != NULL && !lstAccountTeamProxy.isEmpty()){
            for(Account_Team_Proxy__c proxy : lstAccountTeamProxy){
                if(proxy.User__c != rmaRec.OwnerId){
                    ccList.add(proxy.User__r.Email);
                }
            }
        }
        subject = 'Rel Impact:- '+rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+Stage; 
        body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+Stage+'.';
        body += '<br/>';
        body += '<br/>';
        body += 'As per the originator this RMA have lot that have Field reliability impact.';
        body += '<br/>';
        body += '<br/>';
        body += 'This is for your info & necessary action.';
        body += '<br/>';
        body += '<br/>';
        body += createHyperLink(rmaRec);
        body += '<br/>';
        body += '<br/>';
        body += createDisclaimer(rmaRec,true);
        
        mails.add(createEmail(toList, ccList, subject, body));
        
        //to send emails
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    public static void checkAccessImpact(RMA__c rmaRec, String Stage){
        String hyperLink = '';
        
        createQueueUserEmailMap();
        
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c, User__r.Email from Account_Team_Proxy__c where Account__c =: rmaRec.Customer__c and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        
        for(String s : groupIdToUsersMap.get('RMA ENV Personnels')){
            toList.add(s);  
        }
        ccList.add(rmaRec.Originator_Email__c);
        
        subject = rmaRec.Access_Impact__c+':- '+rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+Stage; 
        body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' is '+Stage+'.';
        body += '<br/>';
        body += '<br/>';
        body += 'As per the originator this RMA have impact to '+rmaRec.Access_Impact__c+'.';
        body += '<br/>';
        body += '<br/>';
        body += 'This is for your info & necessary action.';
        body += '<br/>';
        body += '<br/>';
        body += createHyperLink(rmaRec);
        body += '<br/>';
        body += '<br/>';
        body += createDisclaimer(rmaRec,true);
        
        mails.add(createEmail(toList, ccList, subject, body));
        
        //to send emails
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    //when new validator is added
    public static void checkTechValidator(RMA__c rmaRec, String Stage, String email){
        String hyperLink = '';
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String subject = '';
        String body = '';
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        List<RMA_Access_User__c> rmaAccessUserList = new List<RMA_Access_User__c>();
        
        //retrieve users from RMA_Access_User object
        rmaAccessUserList = [select Id, RMA__c, Category__c, RMA__r.Owner.Email, User__r.Email from RMA_Access_User__c where Category__c IN ('Fab','Turnkey') and RMA__c =: rmaRec.Id];
        
        String accessCategory = Stage == RMA_Constants.PEN_FAB_VAL?'Fab':'Turnkey';
        if(!rmaAccessUserList.isEmpty()){
            for(RMA_Access_User__c member : rmaAccessUserList){
                if(member.Category__c == accessCategory){
                    toList.add(member.User__r.Email);
                }
            }
        }
        if(!toList.isEmpty()){
            ccList.add(rmaRec.Originator_Email__c);
            ccList.add(email);
            subject = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+Stage; 
            body = rmaRec.Fab__c +' '+ rmaRec.Name+' for '+rmaRec.Customer_Name__c+' has been raised and is '+Stage+'.';
            body += 'Please validate the RMA.';
            body += '<br/>';
            body += '<br/>';
            body += createHyperLink(rmaRec);
            body += '<br/>';
            body += '<br/>';
            body += createDisclaimer(rmaRec,true);
            
            mails.add(createEmail(toList, ccList, subject, body)); 
            
            //to send emails
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
        }
    }
    
    public static Messaging.SingleEmailMessage createEmail(List<String> toList, List<String> ccList, String subject, String body){
        
        List<String> bccList = new List<String>();
        List<String> tList = new List<String>();
        List<String> cList = new List<String>();
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage(); 
        singleMail.saveAsActivity = false;
        if(!toList.isEmpty()){
            for(String s: toList){
                if(s != null){
                    tList.add(s);
                }
            }
        }
        if(!ccList.isEmpty()){
            for(String s: ccList){
                if(s != null){
                    cList.add(s);
                }
            }
        }
        if(!tList.isEmpty()){
            singleMail.setToAddresses(tList);
        }
        if(!cList.isEmpty()){
            Set<String> setCClist = new Set<String>();
            List<String> lstTempCClist = new List<String>();
            setCClist.addAll(cList);
            lstTempCClist.addAll(setCClist);
            cList.clear();            
            if(lstTempCClist.size()<=25){
                for(Integer i=0;i<lstTempCClist.size();i++){
                    cList.add(lstTempCClist[i]);
                }
            }else{
                for(Integer i=0;i<25;i++){
                    cList.add(lstTempCClist[i]);
                }
                for(Integer j=25;j<lstTempCClist.size();j++){
                    if(j<45){
                        bccList.add(lstTempCClist[j]);
                    }
                }
            }
            singleMail.setCCAddresses(cList);
        }
        bccList.add(RMA_CONSTANTS.EMAIL_SERVICE_ADDRESS);
        singleMail.setBccAddresses(bccList);
        singleMail.setSubject(subject);
        singleMail.setHtmlBody(body);
        return singleMail;
    }
    
    public static void createQueueUserEmailMap(){
        Map<Id,List<String>> groupUserMap = new Map<Id,List<String>>();
        Map<Id,List<String>> groupUserManagerMap = new Map<Id,List<String>>();
        for(Id groupId : groupMap.keySet()){
            groupUserMap.put(groupMap.get(groupId).Id,new List<String>());
            groupUserManagerMap.put(groupMap.get(groupId).Id,new List<String>());
        }
        
        for(GroupMember member: groupUserList){
            if(userMap.containsKey(member.UserOrGroupId)){
                groupUserMap.get(member.GroupId).add(userMap.get(member.UserOrGroupId).Email);
                if(userMap.get(member.UserOrGroupId).Manager.Email != NULL){
                    groupUserManagerMap.get(member.GroupId).add(userMap.get(member.UserOrGroupId).Manager.Email);
                }
            }
        }
        
        groupIdToUsersMap = new Map<String,List<String>>();
        groupIdToManagerMap = new Map<String,List<String>>();
        for(Id queueId : queueMap.keySet()){
            groupIdToUsersMap.put(queueMap.get(queueId).Name,new List<String>());
            groupIdToManagerMap.put(queueMap.get(queueId).Name,new List<String>());
        }
        
        for(GroupMember member: groupMemberList){
            if(groupUserMap.containsKey(member.UserOrGroupId)){
                groupIdToUsersMap.get(member.Group.Name).addAll(groupUserMap.get(member.UserOrGroupId));
                groupIdToManagerMap.get(member.Group.Name).addAll(groupUserManagerMap.get(member.UserOrGroupId));
            }
        }
        
    }
    
    public static String createHyperLink(RMA__c rmaRec){
        return 'Click <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+rmaRec.Id+'">'+'<b>here</b></a> to access the RMA request.';
    }
    
    public static String createDisclaimer(RMA__c rmaRec,Boolean withOrgDetail){
        String body = '';
        if(withOrgDetail == true){
            body = 'Thank You.';
            body += '<br/>';
            body += '<br/>';
            body += '_________________________________________________________________________________________________________';
            body += '<br/>';
            body += 'For further clarification / queries please contact  the originator of the RMA, if there are any issues: ';
            body += '<br/>';
            body += '<br/>';
            body += 'RMA Originator : '+rmaRec.Originator_Name__c;
            body += '<br/>';
            body += 'Contact : '+rmaRec.Originator_Contact__c;
            body += '<br/>';
            body += 'Email ID : '+rmaRec.Originator_Email__c;
            body += '<br/>';
            body += '<br/>';
            body += 'Note: This is a System generated auto email Notification. Please do not reply.';
        }
        else if(withOrgDetail == false){
            body = 'Thank You.';
            body += '<br/>';
            body += '<br/>';
            body += '_________________________________________________________________________________________________________';
            body += '<br/>';
            body += 'Note: This is a System generated auto email Notification. Please do not reply.';
        }
        
        return body;
    }

}