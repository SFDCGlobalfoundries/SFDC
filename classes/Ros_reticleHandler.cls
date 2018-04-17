/*
Class to send an Email to the Primary csr and back up csr 
when status is changed to pending Debit note.
Author: Ravikiran Nadella
Version 1.0
*/
public class Ros_reticleHandler{
    /*this method is used to find the email Addresses 
for a particular roles from Account Team Proxy*/
OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where displayname= 'Salesforce, Noreply'];
    public Map<id,list<Account_Team_Proxy__c>> findEmailAdd(set<string> roleSet,set<id>set_AccIds){
        
        Map<id,list<Account_Team_Proxy__c>> accEmailMap = new Map<id,list<Account_Team_Proxy__c>>();
        
        for(Account acc:[Select id,(Select id, Account__c, User_Email__c,Team_Role__c,
                                    user__r.Manager.email from Account_Team_Proxy__r where Team_Role__c in :roleSet)
                         from Account where id in :set_AccIds]){
                             if(acc.Account_Team_Proxy__r.size()>0){
                                 accEmailMap.put(acc.id,acc.Account_Team_Proxy__r);
                             }
                             
                         }
        return accEmailMap;
    }
    
    public Map<id,string> formEmailBody(Map<id,reticle__c>accRetMap ,set<id>accIdSet){
        
        Map<id,string> accBodyMap= new Map<id,string>();
        for(Account acc :[Select id,name,(Select id,name,ROS_Cycle__r.name,GlobalFoundries_Device_ID__c,
                                          Pending_Debit_Note_Date__c from Reticles__r where id in :accRetMap.keyset())
                          from Account where id in :accIdSet])
        {   
            string rosCycle='';
            string devices='';
            string reticles = '<table  border="1" style="border-collapse: collapse;"><tr><th >Reticle</th><th >Number of days</th></tr>';
            set<string>devNameSet= new set<string>();
            if(acc.Reticles__r.size()>0){           
                for(Reticle__c rtn : acc.Reticles__r){
                    rosCycle=rtn.ROS_Cycle__r.name;
                    if(!devNameSet.contains(rtn.GlobalFoundries_Device_ID__c)){
                        if(rtn.GlobalFoundries_Device_ID__c!=null)
                            devices +=rtn.GlobalFoundries_Device_ID__c +',';
                        devNameSet.add(rtn.GlobalFoundries_Device_ID__c);
                    }
                    reticles += '<tr><td >' + rtn.name + '</td>';
                    if(rtn.Pending_Debit_Note_Date__c !=null){
                        reticles += '<td >' + rtn.Pending_Debit_Note_Date__c.daysBetween(system.today())+ '</td></tr>';
                    }
                    
                }
                reticles +='</table>';
            }           
            String hbody = '<html><body>Dear CSR,<br><br>';
            hbody +='Please be reminded that the below list of reticles disposed is still Pending for Debit Note<br><br>';
            hbody +='Please proceed with the billing and input the Debit Note number in ROS.'+'<br><br>';
            hbody +='Customer Account:'+acc.name+'<br><br>';
            hbody +='Ros Cycle:'+rosCycle+'<br><br>';
            hbody +='Customer Device ID:'+devices+'<br><br>';
            hbody +='Reticle Id :'+reticles+'<br><br>';
            hbody +='System Generated Notification';
            
            accBodyMap.put(acc.id,hbody);
        }     
        
        return accBodyMap;
    }
    
    public Map<id,string> formSubject(list<reticle__c>rtList,string header){
        
        Map<id,string>accntSubjectMap = new Map<id,string>();
        for(reticle__c rt:rtList){
            string sub='';
            sub = header+'Reticles storage charge pending Debit Note for '+ ' '+rt.account__r.name +' for '+' '+rt.ROS_Cycle__r.name;
            accntSubjectMap.put(rt.account__c,sub);
        }
        return accntSubjectMap;
    }
    
    public map<id,list<string>>formToAddress(list<reticle__c>rtList , string status ,set<id>accIdSet){
        map<id,list<string>>emailAccMap = new map<id,list<string>>();
        set<string>roleSet = new set<string>{'Primary Customer Service Rep','Backup Customer Service Rep'};
            if(status=='Escalation'){
                roleSet.add('Primary Account Manager');
            }
        
        
        Map<id,list<Account_Team_Proxy__c>>actProxyMap = findEmailAdd(roleSet,accIdSet);
        
        for(id accId :accIdSet){
            list<string> emailList= new list<string>();
            for(Account_Team_Proxy__c acp :actProxyMap.get(accId)){
                emailList.add(acp.User_Email__c);
                if(status=='Escalation' && acp.Team_Role__c!='Primary Account Manager'){
                    if(null<>acp.user__r.Manager.email){
                        emailList.add(acp.user__r.Manager.email);
                    }
                }
            }
            emailAccMap.put(accId,emailList);
        }
        
        return emailAccMap;
    }
    
    public void sendEmails(list<Messaging.SingleEmailMessage> mails){
        Messaging.sendEmail(mails);
    }
    
    public void intiateEmails(list<reticle__c>rtList){
        Map<id,reticle__c> retAccMap = new Map<id,reticle__c>();
        Map<id,reticle__c> retAccEsMap = new Map<id,reticle__c>();
        list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
        
        for(reticle__c rtn:rtList){
            integer totalDays=0;
            if(rtn.Pending_Debit_Note_Date__c !=null ){
                totalDays=rtn.Pending_Debit_Note_Date__c.daysBetween(system.today());
            }
            if(totalDays >15 && totalDays <40){
                retAccMap.put(rtn.id,rtn);
            }else if(totalDays >40){
                retAccEsMap.put(rtn.id,rtn);
            }
        }
        
        
        if(retAccMap.values().size()>0){
            
            set<id>accIdSet = new set<id>();
            for(reticle__c rt:retAccMap.values()){
                accIdSet.add(rt.account__c);
            }
            map<id,string>accntBodyMap=formEmailBody(retAccMap,accIdSet);
            
            string header='Reminder  :';
            map<id,string>accntSubjectMap = formSubject(retAccMap.values(),header);
            
            string stat='';
            map<id,list<string>>accntToAddMap = formToAddress(retAccMap.values(),stat,accIdSet);
            
            
            for(id accId:accIdSet){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(accntToAddMap.get(accId));
                mail.setSubject(accntSubjectMap.get(accId));
                mail.setHtmlBody(accntBodyMap.get(accId));
                 if( owea.size() > 0){
                   mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mails.add(mail);
            }
            
        }
        
        if(retAccEsMap.values().size()>0){
            set<id>accIdEsSet = new set<id>();
            for(reticle__c rt:retAccEsMap.values()){
                accIdEsSet.add(rt.account__c);
            }
            map<id,string>accntEsBodyMap=formEmailBody(retAccEsMap,accIdEsSet);
            
            string header='Escalation Reminder  :';
            map<id,string>accntEsSubjectMap = formSubject(retAccEsMap.values(),header);
            
            string stat='Escalation';
            map<id,list<string>>accntEsToAddMap = formToAddress(retAccEsMap.values(),stat,accIdEsSet);
            
            
            for(id accId:accIdEsSet){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(accntEsToAddMap.get(accId));
                mail.setSubject(accntEsSubjectMap.get(accId));
                mail.setHtmlBody(accntEsBodyMap.get(accId));
                if(owea.size() > 0){
                   mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mails.add(mail);
            }
        }
        sendEmails(mails);
    }
}