/*
    Author: Shyam Ravindra Nair
    Description: serves as handler for MPWTurnkeyTrigger trigger.
    History: 
        SNair      31082015    - Code creation.
        Poulami      03182016    - updated code to add 2 methods.
                                    - sendReminderForShipmentInformationUpdate (used to send email notification to requestor (MPW CE or turnkey), Account AM , CSR, FAE and customer once Shipment information is updated)
                                    - getGroupMembers (this method will return lsit of email address of group memebers of a particular queue/group)
        Anil Kumar 00070566 : April 7, 2017 : MPW-PP126 : Commented the functionality for Forecast ship date notification
*/

public class MPWTurnKeyTriggerHandler {

    List<Messaging.SingleEmailMessage> mails{get;set;}

    public MPWTurnKeyTriggerHandler(){
        mails = new List<Messaging.SingleEmailMessage>();
    }
    
    public void sendReminderForShipmentInformation(List<MPW_Turnkey__c> newMPWTurnkeyList){
        Map<Id, List<Account_Team_Proxy__c>> mpwturnkeyproxymap = new Map<Id, List<Account_Team_Proxy__c>>(); 
        Set<Id> turnkeyIdList = new Set<Id>();
        for(MPW_Turnkey__c m: newMPWTurnkeyList){
            turnkeyIdList.add(m.Id);
        }
        if(!turnkeyIdList.isEmpty()){
            List<MPW_Turnkey__c> mpwTurnkeyList = new List<MPW_Turnkey__c>();
            mpwTurnkeyList = [select Id, Prime_Die_Name__c, MPW_Reservation__c, MPW_Reservation__r.Customer_Company_Name__c, Wafer_Ship_Date__c, AWB__c, Ship_Date__c, Company_Name__c, MPW_No__c from MPW_Turnkey__c where Id IN: turnkeyIdList];
            if(!mpwTurnkeyList.isEmpty()){
                Set<Id> accountIds = new Set<Id>();
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    accountIds.add(m.MPW_Reservation__r.Customer_Company_Name__c);
                }
                if(!accountIds.isEmpty()){
                    List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                    accTeamProxyList = [select Id, User__c, User_Email__c,Account__c,Team_Role__c from Account_Team_Proxy__c where Team_Role__c IN ('Primary Account Manager','Primary Customer Service Rep','Primary Field Application Engineer','Customer Service Rep','Backup Customer Service Rep') and User__r.isActive = true and Account__c IN: accountIds];
                    if(!accTeamProxyList.isEmpty()){
                        for(MPW_Turnkey__c m: mpwTurnkeyList){
                            List<Account_Team_Proxy__c> tempList = new List<Account_Team_Proxy__c>();
                            for(Account_Team_Proxy__c a: accTeamProxyList){
                                if(m.MPW_Reservation__r.Customer_Company_Name__c ==  a.Account__c){
                                    tempList.add(a);
                                }
                            }
                            if(!tempList.isEmpty()){
                                mpwturnkeyproxymap.put(m.Id,tempList);    
                            }
                        }
                    }
                }
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    List<Id> toList = new List<Id>();
                    if(!mpwturnkeyproxymap.isEmpty()){
                        for(Account_Team_Proxy__c a: mpwturnkeyproxymap.get(m.Id)){
                            toList.add(a.User__c);
                        }
                    }
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(to);
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject(m.MPW_No__c+' Shipment Information.');
                        String body = 'MPW : '+m.MPW_No__c;
                        body += '<br/>';
                        body += 'Company Name : '+m.Company_Name__c;
                        body += '<br/>';
                        body += 'AWB#: '+m.AWB__c;
                        body += '<br/>';
                        body += 'Device Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        String baredie = '';
                        if(m.Ship_Date__c != null){
                            Datetime barediedatetime = Datetime.newInstance(m.Ship_Date__c.year(), m.Ship_Date__c.month(), m.Ship_Date__c.day());
                            baredie = barediedatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Bare Die Ship Date: '+baredie;
                        body += '<br/>';
                        String waferdate = '';
                        if(m.Wafer_Ship_Date__c != null){
                            Datetime waferdatetime = Datetime.newInstance(m.Wafer_Ship_Date__c.year(), m.Wafer_Ship_Date__c.month(), m.Wafer_Ship_Date__c.day());
                            waferdate = waferdatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Wafer Ship Date: '+waferdate;
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c+'">'+hyperLink+'</a>';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    //03182016 - Added by Poulami Starts.
    public void sendReminderForShipmentInformationUpdate(List<MPW_Turnkey__c> newMPWTurnkeyList, Boolean isUpdateForecast){
        List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<Account_Team_Proxy__c>> mpwturnkeyproxymap = new Map<Id, List<Account_Team_Proxy__c>>(); 
        Set<Id> turnkeyIdList = new Set<Id>();
        for(MPW_Turnkey__c m: newMPWTurnkeyList){
            turnkeyIdList.add(m.Id);
        }
        if(!turnkeyIdList.isEmpty()){
            List<MPW_Turnkey__c> mpwTurnkeyList = new List<MPW_Turnkey__c>();
            mpwTurnkeyList = [select Id, Prime_Die_Name__c, MPW_Reservation__c, MPW_Reservation__r.Customer_Company_Name__c, Wafer_Ship_Date__c, Bare_Die_Forecast_Ship_Date__c, AWB__c, Ship_Date__c, Company_Name__c, MPW_No__c, Expected_Wafer_Skeleton_Return_Date__c, MPW_Reservation__r.Fab__c, MPW_Reservation__r.Category__c , MPW_Reservation__r.Customer_Email__c, MPW_Reservation__r.Requestor_Email__c, LastModifiedBy.Email from MPW_Turnkey__c where Id IN: turnkeyIdList];
            if(!mpwTurnkeyList.isEmpty()){
                Set<Id> accountIds = new Set<Id>();
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    accountIds.add(m.MPW_Reservation__r.Customer_Company_Name__c);
                }
                if(!accountIds.isEmpty()){
                    List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                    accTeamProxyList = [select Id, User__c, User_Email__c,Account__c,Team_Role__c from Account_Team_Proxy__c where Team_Role__c IN ('Primary Account Manager','Primary Customer Service Rep','Primary Field Application Engineer','Customer Service Rep','Backup Customer Service Rep','Field Application Engineer') and User__r.isActive = true and Account__c IN: accountIds];
                    if(!accTeamProxyList.isEmpty()){
                        for(MPW_Turnkey__c m: mpwTurnkeyList){
                            List<Account_Team_Proxy__c> tempList = new List<Account_Team_Proxy__c>();
                            for(Account_Team_Proxy__c a: accTeamProxyList){
                                if(m.MPW_Reservation__r.Customer_Company_Name__c ==  a.Account__c){
                                    tempList.add(a);
                                }
                            }
                            if(!tempList.isEmpty()){
                                mpwturnkeyproxymap.put(m.Id,tempList);    
                            }
                        }
                    }
                }
                Map<Id, List<String>> mpwTurnToListMap = new Map<id, List<String>>();
                Map<Id, List<String>> mpwTurnCcListMap = new Map<id, List<String>>();
                Set<String> ceMemQueueGrpList = new Set<String>();
                Set<String> turnkeyMemQueueGrpList = new Set<String>();
                
                Map<String, MPW_CE_Turnkey_QueueIDName__c> mpwQueueIdNameCusset = MPW_CE_Turnkey_QueueIDName__c.getAll();
                
                for(MPW_CE_Turnkey_QueueIDName__c mpwCETurnkeyCusset : mpwQueueIdNameCusset.values()){
                    if(mpwCETurnkeyCusset.isCEUser__c == true){
                        ceMemQueueGrpList.add(mpwCETurnkeyCusset.Name);
                        ceMemQueueGrpList.add(mpwCETurnkeyCusset.Group_Name__c);
                    }
                    if(mpwCETurnkeyCusset.isTurnkeyUser__c == true){
                        turnkeyMemQueueGrpList.add(mpwCETurnkeyCusset.Name);
                        turnkeyMemQueueGrpList.add(mpwCETurnkeyCusset.Group_Name__c);
                    }
                    
                }
                List<GroupMember> grpMemList = [SELECT Group.developerName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()];// AND Group.Type = 'Queue'
                Set<String> memNameList = new Set<String>();
                Boolean ceMember = false;
                Boolean turnkeyMember = false;
                for(GroupMember grpMem : grpMemList){
                    memNameList.add(grpMem.Group.developerName);
                }
                for(String mem : memNameList){
                        if(ceMemQueueGrpList.contains(mem)){
                            ceMember = true;
                        }
                        if(turnkeyMemQueueGrpList.contains(mem)){
                            turnkeyMember = true;
                        }
                }
                
                List<Group> grpList = new List<Group>();
                grpList = [SELECT id, developerName from Group where type='Queue' and developerName IN: mpwQueueIdNameCusset.keyset()];
                Set<Id> grpId = new set<Id>();
                if(grpList.size() > 0){
                    for(Group grp : grpList){
                        grpId.add(grp.id);
                    }
                }
                Map <Id, List<String>> grpIdMemberMap = getGroupMembers(grpId);
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    if(!mpwturnkeyproxymap.isEmpty()){
                        for(Account_Team_Proxy__c a: mpwturnkeyproxymap.get(m.Id)){
                            if (mpwTurnToListMap.containsKey(m.id)) {
                                mpwTurnToListMap.get(m.id).add(a.User_Email__c);
                            } 
                            else 
                            {
                                mpwTurnToListMap.put(m.id, new List <String> {
                                        a.User_Email__c
                                    });
                            }
                        }
                    }
                    if(!grpIdMemberMap.isEmpty()){
                        for(MPW_CE_Turnkey_QueueIDName__c mpwCETurnkeyCusset : mpwQueueIdNameCusset.values()){
                            Set<String> fabNameList = new Set<String>();
                            for(String fabName : mpwCETurnkeyCusset.Fab__c.split(',')){
                                fabNameList.add(fabName);
                            }
                            if(ceMember){
                                if(fabNameList.contains(m.MPW_Reservation__r.Fab__c) && mpwCETurnkeyCusset.isCEUser__c == true){
                                    system.debug('=====1 : ' + mpwCETurnkeyCusset.Queue_Name__c);
                                    system.debug('=====2 : ' + grpIdMemberMap);
                                    for(String userEmail : grpIdMemberMap.get(mpwCETurnkeyCusset.Queue_Name__c))
                                    {
                                        if (mpwTurnCcListMap.containsKey(m.id)) {
                                            mpwTurnCcListMap.get(m.id).add(userEmail);
                                        } 
                                        else 
                                        {
                                            mpwTurnCcListMap.put(m.id, new List <String> {
                                                    userEmail
                                                });
                                        }
                                    }
                                }
                            
                            }
                            if(turnkeyMember){
                                if(fabNameList.contains(m.MPW_Reservation__r.Fab__c) && mpwCETurnkeyCusset.isTurnkeyUser__c == true){
                                    for(String userEmail : grpIdMemberMap.get(mpwCETurnkeyCusset.Queue_Name__c))
                                    {
                                        if (mpwTurnCcListMap.containsKey(m.id)) {
                                            mpwTurnCcListMap.get(m.id).add(userEmail);
                                        } 
                                        else 
                                        {
                                            mpwTurnCcListMap.put(m.id, new List <String> {
                                                    userEmail
                                                });
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    List<String> toList = new List<String>();
                    List<String> ccList = new List<String>();
                    if(!mpwTurnToListMap.isEmpty()){
                        toList = mpwTurnToListMap.get(m.id);
                    }
                    if(!mpwTurnCcListMap.isEmpty()){
                        ccList = mpwTurnCcListMap.get(m.id);
                    }
                    String[] toAddresses = new String[]{};
                    String[] ccAddresses = new String[]{};
                    if(m.MPW_Reservation__r.Category__c == 'Customer' && m.MPW_Reservation__r.Customer_Email__c != '' && m.MPW_Reservation__r.Customer_Email__c != null){
                        toList.add(m.MPW_Reservation__r.Customer_Email__c);
                    }else if(m.MPW_Reservation__r.Category__c == 'IP' && m.MPW_Reservation__r.Requestor_Email__c != '' && m.MPW_Reservation__r.Requestor_Email__c != null){
                        toList.add(m.MPW_Reservation__r.Requestor_Email__c);
                    }
                    ccList.add(m.LastModifiedBy.Email);
                    if(toList.size() > 0){
                        toAddresses = toList;
                        singleMail.setToAddresses(toAddresses);
                    }
                    if(ccList.size() > 0){
                        ccAddresses = ccList;
                        singleMail.setCcAddresses(ccAddresses);
                    }
                    singleMail.saveAsActivity = false;
                    String body;
                    if(isUpdateForecast == false){
                        singleMail.setSubject(m.Company_Name__c +' '+ m.MPW_No__c+' Shipment Information.');
                        body = 'MPW : '+m.MPW_No__c;
                        body += '<br/>';
                        body += 'Company Name : '+m.Company_Name__c;
                        body += '<br/>';
                        body += 'AWB#: '+m.AWB__c;
                        body += '<br/>';
                        body += 'PrimeDie Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        String baredie = '';
                        if(m.Ship_Date__c != null){
                            Datetime barediedatetime = Datetime.newInstance(m.Ship_Date__c.year(), m.Ship_Date__c.month(), m.Ship_Date__c.day());
                            baredie = barediedatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Bare Die Ship Date: '+baredie;
                        body += '<br/>';
                        String waferdate = '';
                        if(m.Wafer_Ship_Date__c != null){
                            Datetime waferdatetime = Datetime.newInstance(m.Wafer_Ship_Date__c.year(), m.Wafer_Ship_Date__c.month(), m.Wafer_Ship_Date__c.day());
                            waferdate = waferdatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Wafer Ship Date: '+waferdate;
                        body += '<br/>';
                        String expectedwaferdate = '';
                        if(m.Expected_Wafer_Skeleton_Return_Date__c != null){
                            Datetime expectedwaferdatetime = Datetime.newInstance(m.Expected_Wafer_Skeleton_Return_Date__c.year(), m.Expected_Wafer_Skeleton_Return_Date__c.month(), m.Expected_Wafer_Skeleton_Return_Date__c.day());
                            expectedwaferdate = expectedwaferdatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Expected Wafer Skeleton Return Date: '+expectedwaferdate;
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Please trigger billing & invoice customer.';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c+'">'+hyperLink+'</a>';
                    }
                    /** Commented by Anil on April 7, 2017 : MPW-PP126
                    if(isUpdateForecast == true){
                        singleMail.setSubject(m.MPW_No__c+' Shipment Forecast Information.');
                        body = 'MPW : '+m.MPW_No__c;
                        body += '<br/>';
                        body += 'Company Name : '+m.Company_Name__c;
                        body += '<br/>';
                        body += 'PrimeDie Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        String baredieforecast = '';
                        if(m.Bare_Die_Forecast_Ship_Date__c != null){
                            Datetime baredieforecastdatetime = Datetime.newInstance(m.Bare_Die_Forecast_Ship_Date__c.year(), m.Bare_Die_Forecast_Ship_Date__c.month(), m.Bare_Die_Forecast_Ship_Date__c.day());
                            baredieforecast = baredieforecastdatetime.format('dd/MMM/yyyy');
                        }
                        body += 'Bare Die Forecast Ship Date: '+baredieforecast;
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c+'">'+hyperLink+'</a>';
                    }
                    */
                    singleMail.setHtmlBody(body);
                    newMails.add(singleMail);
                }
            }
        }
        if(!newMails.isEmpty()){
            Messaging.sendEmail(newMails);
        }
    }
    //03182016 - Added by Poulami Ends.
    
    //Added by Anil : Backlog - MPW-PP109: Actual Wafer Skeleton Return Date
    public void sendReminderForReturnDateUpdate(List<MPW_Turnkey__c> lstTurnkey){
        List<Messaging.SingleEmailMessage> newMails = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<Account_Team_Proxy__c>> mpwturnkeyproxymap = new Map<Id, List<Account_Team_Proxy__c>>(); 
        Set<Id> turnkeyIdList = new Set<Id>();
        for(MPW_Turnkey__c m: lstTurnkey){
            turnkeyIdList.add(m.Id);
        }
        if(!turnkeyIdList.isEmpty()){
            List<MPW_Turnkey__c> mpwTurnkeyList = new List<MPW_Turnkey__c>();
            mpwTurnkeyList = [select Id, Prime_Die_Name__c, MPW_Reservation__c, MPW_Reservation__r.Customer_Company_Name__c, Wafer_Ship_Date__c, Bare_Die_Forecast_Ship_Date__c, AWB__c, Ship_Date__c, Company_Name__c, MPW_No__c, Expected_Wafer_Skeleton_Return_Date__c, Actual_Wafer_Skeleton_Return_Date__c, MPW_Reservation__r.Fab__c, MPW_Reservation__r.Category__c , MPW_Reservation__r.Customer_Email__c, MPW_Reservation__r.Requestor_Email__c, LastModifiedBy.Email from MPW_Turnkey__c where Id IN: turnkeyIdList];
            if(!mpwTurnkeyList.isEmpty()){
                Set<Id> accountIds = new Set<Id>();
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    accountIds.add(m.MPW_Reservation__r.Customer_Company_Name__c);
                }
                if(!accountIds.isEmpty()){
                    List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                    accTeamProxyList = [select Id, User__c, User_Email__c,Account__c,Team_Role__c from Account_Team_Proxy__c where Team_Role__c IN ('Primary Account Manager','Primary Customer Service Rep','Primary Field Application Engineer','Customer Service Rep','Backup Customer Service Rep','Field Application Engineer') and User__r.isActive = true and Account__c IN: accountIds];
                    if(!accTeamProxyList.isEmpty()){
                        for(MPW_Turnkey__c m: mpwTurnkeyList){
                            List<Account_Team_Proxy__c> tempList = new List<Account_Team_Proxy__c>();
                            for(Account_Team_Proxy__c a: accTeamProxyList){
                                if(m.MPW_Reservation__r.Customer_Company_Name__c ==  a.Account__c){
                                    tempList.add(a);
                                }
                            }
                            if(!tempList.isEmpty()){
                                mpwturnkeyproxymap.put(m.Id,tempList);    
                            }
                        }
                    }
                }
                Map<Id, List<String>> mpwTurnToListMap = new Map<id, List<String>>();
                Map<Id, List<String>> mpwTurnCcListMap = new Map<id, List<String>>();
                Set<String> ceMemQueueGrpList = new Set<String>();
                Set<String> turnkeyMemQueueGrpList = new Set<String>();
                
                Map<String, MPW_CE_Turnkey_QueueIDName__c> mpwQueueIdNameCusset = MPW_CE_Turnkey_QueueIDName__c.getAll();
                
                for(MPW_CE_Turnkey_QueueIDName__c mpwCETurnkeyCusset : mpwQueueIdNameCusset.values()){
                    if(mpwCETurnkeyCusset.isCEUser__c == true){
                        ceMemQueueGrpList.add(mpwCETurnkeyCusset.Name);
                        ceMemQueueGrpList.add(mpwCETurnkeyCusset.Group_Name__c);
                    }
                    if(mpwCETurnkeyCusset.isTurnkeyUser__c == true){
                        turnkeyMemQueueGrpList.add(mpwCETurnkeyCusset.Name);
                        turnkeyMemQueueGrpList.add(mpwCETurnkeyCusset.Group_Name__c);
                    }
                    
                }
                List<GroupMember> grpMemList = [SELECT Group.developerName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()];// AND Group.Type = 'Queue'
                Set<String> memNameList = new Set<String>();
                Boolean ceMember = false;
                Boolean turnkeyMember = false;
                for(GroupMember grpMem : grpMemList){
                    memNameList.add(grpMem.Group.developerName);
                }
                for(String mem : memNameList){
                        if(ceMemQueueGrpList.contains(mem)){
                            ceMember = true;
                        }
                        if(turnkeyMemQueueGrpList.contains(mem)){
                            turnkeyMember = true;
                        }
                }
                
                List<Group> grpList = new List<Group>();
                grpList = [SELECT id, developerName from Group where type='Queue' and developerName IN: mpwQueueIdNameCusset.keyset()];
                Set<Id> grpId = new set<Id>();
                if(grpList.size() > 0){
                    for(Group grp : grpList){
                        grpId.add(grp.id);
                    }
                }
                Map <Id, List<String>> grpIdMemberMap = getGroupMembers(grpId);
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    if(!mpwturnkeyproxymap.isEmpty()){
                        for(Account_Team_Proxy__c a: mpwturnkeyproxymap.get(m.Id)){
                            if (mpwTurnToListMap.containsKey(m.id)) {
                                mpwTurnToListMap.get(m.id).add(a.User_Email__c);
                            } 
                            else 
                            {
                                mpwTurnToListMap.put(m.id, new List <String> {
                                        a.User_Email__c
                                    });
                            }
                        }
                    }
                    if(!grpIdMemberMap.isEmpty()){
                        for(MPW_CE_Turnkey_QueueIDName__c mpwCETurnkeyCusset : mpwQueueIdNameCusset.values()){
                            Set<String> fabNameList = new Set<String>();
                            for(String fabName : mpwCETurnkeyCusset.Fab__c.split(',')){
                                fabNameList.add(fabName);
                            }
                            if(ceMember){
                                if(fabNameList.contains(m.MPW_Reservation__r.Fab__c) && mpwCETurnkeyCusset.isCEUser__c == true){
                                    for(String userEmail : grpIdMemberMap.get(mpwCETurnkeyCusset.Queue_Name__c))
                                    {
                                        if (mpwTurnCcListMap.containsKey(m.id)) {
                                            mpwTurnCcListMap.get(m.id).add(userEmail);
                                        } 
                                        else 
                                        {
                                            mpwTurnCcListMap.put(m.id, new List <String> {
                                                    userEmail
                                                });
                                        }
                                    }
                                }
                            
                            }
                            if(turnkeyMember){
                                if(fabNameList.contains(m.MPW_Reservation__r.Fab__c) && mpwCETurnkeyCusset.isTurnkeyUser__c == true){
                                    for(String userEmail : grpIdMemberMap.get(mpwCETurnkeyCusset.Queue_Name__c))
                                    {
                                        if (mpwTurnCcListMap.containsKey(m.id)) {
                                            mpwTurnCcListMap.get(m.id).add(userEmail);
                                        } 
                                        else 
                                        {
                                            mpwTurnCcListMap.put(m.id, new List <String> {
                                                    userEmail
                                                });
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                for(MPW_Turnkey__c m: mpwTurnkeyList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    List<String> toList = new List<String>();
                    List<String> ccList = new List<String>();
                    if(!mpwTurnToListMap.isEmpty()){
                        toList = mpwTurnToListMap.get(m.id);
                    }
                    if(!mpwTurnCcListMap.isEmpty()){
                        ccList = mpwTurnCcListMap.get(m.id);
                    }
                    String[] toAddresses = new String[]{};
                    String[] ccAddresses = new String[]{};
                    if(m.MPW_Reservation__r.Category__c == 'Customer' && m.MPW_Reservation__r.Customer_Email__c != '' && m.MPW_Reservation__r.Customer_Email__c != null){
                        toList.add(m.MPW_Reservation__r.Customer_Email__c);
                    }else if(m.MPW_Reservation__r.Category__c == 'IP' && m.MPW_Reservation__r.Requestor_Email__c != '' && m.MPW_Reservation__r.Requestor_Email__c != null){
                        toList.add(m.MPW_Reservation__r.Requestor_Email__c);
                    }
                    ccList.add(m.LastModifiedBy.Email);
                    if(toList.size() > 0){
                        toAddresses = toList;
                        singleMail.setToAddresses(toAddresses);
                    }
                    if(ccList.size() > 0){
                        ccAddresses = ccList;
                        singleMail.setCcAddresses(ccAddresses);
                    }
                    singleMail.saveAsActivity = false;
                    String body;
                    singleMail.setSubject(m.Company_Name__c +' '+ m.MPW_No__c+' Wafer Skeleton Received.');
                    body = 'MPW : '+m.MPW_No__c;
                    body += '<br/>';
                    body += 'Company Name : '+m.Company_Name__c;
                    body += '<br/>';
                    body += 'AWB#: '+m.AWB__c;
                    body += '<br/>';
                    body += 'PrimeDie Name: '+m.Prime_Die_Name__c;
                    body += '<br/>';
                    String expectedwaferdate = '';
                    if(m.Expected_Wafer_Skeleton_Return_Date__c != null){
                        Datetime expectedwaferdatetime = Datetime.newInstance(m.Expected_Wafer_Skeleton_Return_Date__c.year(), m.Expected_Wafer_Skeleton_Return_Date__c.month(), m.Expected_Wafer_Skeleton_Return_Date__c.day());
                        expectedwaferdate = expectedwaferdatetime.format('dd/MMM/yyyy');
                    }
                    body += 'Expected Wafer Skeleton Return Date: ' + expectedwaferdate;
                    body += '<br/>';
                    String actualwaferdate = '';
                    if(m.Actual_Wafer_Skeleton_Return_Date__c != null){
                        Datetime actualwaferdatetime = Datetime.newInstance(m.Actual_Wafer_Skeleton_Return_Date__c.year(), m.Actual_Wafer_Skeleton_Return_Date__c.month(), m.Actual_Wafer_Skeleton_Return_Date__c.day());
                        actualwaferdate = actualwaferdatetime.format('dd/MMM/yyyy');
                    }
                    body += '​Actual Wafer Skeleton Return Date: ' + actualwaferdate;
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.MPW_Reservation__c+'">'+hyperLink+'</a>';

                    singleMail.setHtmlBody(body);
                    newMails.add(singleMail);
                }
            }
        }
        if(!newMails.isEmpty()){
            Messaging.sendEmail(newMails);
        }
    }
    
    //03182016 - Added by Poulami Starts.
    public static Map <Id, List <String>> getGroupMembers(Set <Id> groupIds) {
        Map <Id, List <String>> returnGroupMembers = new Map <Id, List <String>> ();
        Map <Id, Id> mapGroupSubGroupId = new Map <Id, Id> ();
        List <GroupMember> groupMembers = new List <GroupMember> ();
        List <GroupMember> subGroupMembers = new List <GroupMember> ();
        List <Id> subGroupsIds = new List <Id> ();
        Id[] groupMemberIds = new list<Id>();

        try {
            Map <Id, List <Id>> mapGroupMembers = new Map <Id, List <Id>> ();
            if (groupIds != null && groupIds.size() > 0)
                groupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: groupIds Limit 100];
            if (groupMembers != null && groupMembers.size() > 0) {
                for (GroupMember gm: groupmembers) {
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = gm.GroupId;
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                   } else {
                        subGroupsIds.add(gm.UserOrGroupId); // if group members are groups get those groups members
                        if (!mapGroupMembers.containsKey(gm.UserOrGroupId))
                            mapGroupSubGroupId.put(gm.UserOrGroupId, gm.GroupId);
                    }
                }
            }
            //Iterate through only 1 sub-group level where the group member is another.
            if (subGroupsIds != null && subGroupsIds.size() > 0)
                subGroupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: subGroupsIds Limit 100];
    
            if (subGroupMembers != null && subGroupMembers.size() > 0) {
                for (GroupMember gm: subGroupMembers) {
                    
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = mapGroupSubGroupId.get(gm.GroupId);
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                    }
                }
            }
            
            // Keep trying to get users from GroupMember.userOrGroupId.
            if(mapGroupMembers !=null && mapGroupMembers.size()>0){
                
                Map<Id, User> users = new Map<Id, User>([select Id,Email, Name from User where (Id In :groupMemberIds) and (isActive=true) Limit 1000]);
                Set<Id> setUsers = users.keySet();
                
                for (Id groupId: mapGroupMembers.keySet()) {
                    // The "key" variable is also available inside the loop
                    List<Id> listUsers = mapGroupMembers.get(groupId);
                    for (Id userId: listUsers) {
                        if(setUsers.Contains(userId)){
                            User usr = users.get(userId);
                            if (returnGroupMembers.containsKey(groupId)) {
                                //returnGroupMembers.get(groupId).add(userId);
                                returnGroupMembers.get(groupId).add(usr.Email);
                            } else {
                                /*returnGroupMembers.put(groupId, new List <Id> {
                                    userId
                                });*/
                                returnGroupMembers.put(groupId, new List <String> {
                                    usr.Email
                                });
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {e.getMessage();}
        return returnGroupMembers; // return group members with group members email id
    }
    //03182016 - Added by Poulami Ends.
}