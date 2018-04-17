/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
*  Jabee 09092016 case#00059787
**/
global class SFFGEmailNotificationBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String soql = 'Select Id, Geometry_NM__c, Device_Mask_Set_Title__c,'+ 
                'Tapeout_Type__c, Fab__c,reticle_Type__c, CRMDID__c,  (select Requester_Username__c,'+ 
                'isNotified__c,Fab__c,Device__c,Name,SFFG_Frame_Status__c from SFFG_Standard_Foundry_Frames__r limit 1),Name,Account__r.name,'+ 
                'Current_Forecast_Tapeout_Date__c,Customer_Tapeout_Date__c,Geometry__c '+ 
                '  FROM Device__c where Generate_Standard_Frame__c=\'Yes\' and Stage__c=\'Design In\' and Tapeout_Type__c=\'Single Product\' and (Status__c!=\'Void\' and Status__c!=\'Inactive\')';
        return Database.getQueryLocator(soql);
    }
   
    global void execute(Database.BatchableContext bc, List<Device__c> deviceList) {
        //for getting keyset of ids
        Map<Id, List<Account_Team_Proxy__c>> frameFAEListMap = new Map<Id, List<Account_Team_Proxy__c>>();
        
        //seto of account ids
        set<id> accIds=new set<id>();
        List<device__c> emailObjList=new List<device__c>();
        
        
        for(Device__c d : deviceList) {
            integer diffDate;
            if(d.Customer_Tapeout_Date__c<d.Current_Forecast_Tapeout_Date__c)
                diffDate=(d.Customer_Tapeout_Date__c!=null)?system.today().daysBetween(d.Customer_Tapeout_Date__c):null; 
            else
                diffDate=(d.Current_Forecast_Tapeout_Date__c!=null)?system.today().daysBetween(d.Current_Forecast_Tapeout_Date__c):null; 
             accIds.add(d.Account__c);
             if((d.reticle_Type__c!=null && d.reticle_Type__c.contains('SLR') &&
                        diffDate<=7)){
                         if(d.SFFG_Standard_Foundry_Frames__r!=null && 
                                    d.SFFG_Standard_Foundry_Frames__r.size()>0){
                            if(d.SFFG_Standard_Foundry_Frames__r[0].SFFG_Frame_Status__c!='Finalize')
                            {
                                emailObjList.add(d);
                            }
                        }else{
                            emailObjList.add(d);
                        }
                    }
        }
        
        if(!emailObjList.isEmpty()){
            if(!accIds.isEmpty()){
            List<Account_Team_Proxy__c> proxyList = [select User__c, User__r.Name,Account__c, User_Email__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN :accIds and Team_Role__c IN ('Field Application Engineer','Primary Field Application Engineer') order by Team_Role__c desc];
                if(!proxyList.isEmpty()){
                    for(Account_Team_Proxy__c p: proxyList){
                        if(p.Team_Role__c == 'Field Application Engineer' || p.Team_Role__c == 'Primary Field Application Engineer'){
                            if(frameFAEListMap.containskey(p.Account__c)){
                                frameFAEListMap.get(p.Account__c).add(p);
                            }else{
                                List<Account_Team_Proxy__c> feList = new List<Account_Team_Proxy__c>();
                                feList.add(p);
                                frameFAEListMap.put(p.Account__c,feList);
                            }
                        }
                    }
                }
            }
            
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            list<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = 'Salesforce, Noreply' LIMIT 1];
            for(Device__c dev : emailObjList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendto.add(userinfo.getuseremail());
                for(Account_Team_Proxy__c p: frameFAEListMap.get(dev.Account__c)){
                    sendTo.add(p.User_Email__c);
                }
                string ccEmail='';
                ccEmail=(SFFG_Configuration__c.getInstance('TapeOutCenter Email')!=null)?SFFG_Configuration__c.getInstance('TapeOutCenter Email').Value__c:'';
                mail.setToAddresses(sendTo);
                if(!lstOrgWideEmailAddress.isempty()) {
                    mail.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
                }
                mail.setCcAddresses(new List<string>{ccEmail});
                mail.setReplyTo('noreply-salesforce@globalfoundries.com');
                mail.setSubject('Device '+dev.Name+':Reminder to finalize Standard Foundry Frame Generation');
                String body = 'Hi Team,<br/><br/>';
                body += 'Please finalize Frame Generation required details in Global-FoundryView Device '+dev.Name+' <br/><br/>';
                body += 'Account Name:'+dev.Account__r.name+'<br/>';
                body += 'Device Id:'+dev.Name+'<br/>';
                body += 'CRM DID:'+dev.CRMDID__c+'<br/>';
                body += 'Current Forecast Tapeout Date:'+dev.Current_Forecast_Tapeout_Date__c.format()+'<br/>';
                body += 'Fab:'+dev.Fab__c+'<br/>';
                body += 'Tapeout Type:'+dev.Tapeout_type__c+'<br/>';
                body += 'Geometry:'+dev.Geometry_NM__c+'<br/>';
                body += 'Mask Set Title:'+dev.Device_Mask_Set_Title__c+'<br/>';
                body += '<br/>';
                String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/SFFGFrameDetails?id='+dev.id;
                body += '<a href="'+hyperLink+'">Click here to open</a>';
                body += '<br/>Thanks,<br/>Salesforce Admin<br/>';
                mail.setHtmlBody(body);               
                mailList.add(mail);
                
            }
            if(!test.isRunningtest()){
                Messaging.sendEmail(mailList);
            }
        }
    }
   
    global void finish(Database.BatchableContext bc) {
        
    }
}