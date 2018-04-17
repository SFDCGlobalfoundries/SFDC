/*
    Author: Abhita Bansal
    Description: This Class is used to send the emails on approve of Form to all the users present in the notification Group 
                according to the Custom Template
    History: 
    ABansal     11/27/2014 - Code Creation
    ABansal     11/28/2014 - Added the email Template for all Approvals
    ABansal     12/1/2014 - Remove the Logic for all approvals
    SArora      18/06/2015- code added by Sunil Arora for case # 42796
*/
public class eWSRSendEmailtoNotiGroupClass{
    
    public static List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    public static List<String> sendCc = new List<String>();
    public static List<String> ccTo = new List<String>();
   
    public static User getUserManager(String OwnerId){
        User userManger = [Select Id, Email, Name from User where Id =:OwnerId Limit 1];
        return userManger;
    }
        
    public static void sendEmail(List<eWSR_Form__c> formList){
        eWSR_Form__c forms = new eWSR_Form__c();
        Map<String,list<String>> mapUsersForm = new Map<String,List<String>>();
        List<Id> usersList = new List<Id>();
        Set<Id> formIds = new Set<Id>();
        for(eWSR_Form__c forms1 : formList){
           formIds.add(forms1.Id);
        }
        
        for(eWSR_Notification_Group__c notiGroup : [Select eWSR_Form__c, User__c, UserId__c, User_Email__c from eWSR_Notification_Group__c 
                                                    where eWSR_Form__c IN:formIds]){ 
            usersList.add(notiGroup.UserId__c); 
            mapUsersForm.put(notiGroup.eWSR_Form__c,usersList);                
        }
     
        Messaging.reserveSingleEmailCapacity(10);
        try{ 
              
        for(eWSR_Form__c tempforms: formList){
            forms = tempforms;
        }
        
        if(forms.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> arrayList = new List<String>();
            RecordType recName = [Select Name from RecordType where Id =:forms.RecordTypeId Limit 1];       
            User org = getUserManager(forms.Lot_Owner__c);
            User org1 = getUserManager(forms.OwnerId);
            if(mapUsersForm.get(forms.Id) != null){
                arrayList = mapUsersForm.get(forms.Id);            
                if(arrayList.size() > 0){
                    for(Integer i=0 ; i<arrayList.size();i++){
                        sendCc.add(arrayList[i]);
                    }    
                }                          
                for(User user : [Select Id, Email from User where Id =:sendCc]){
                    ccTo.add(user.Email);
                }      
            }
            ccTo.add(org.Email);
            //code added by Sunil Arora for case # 42796
            //User userHod=getUserManager(forms.HOD__c);
            //User userProgManager=getUserManager(forms.Program_Manager__c);
            //ccTo.add(userHod.Email);
            //ccTo.add(userProgManager.Email);
            //Code of Sunil ends here
            
             if(forms.HOD__c!= null){
                 User userHod=getUserManager(forms.HOD__c);
                 if(userHod!=null)
                 ccTo.add(userHod.Email);
                 }
                 if (forms.Program_Manager__c != null){
                            User userProgManager=getUserManager(forms.Program_Manager__c);
                            if(userProgManager!=null)
                            ccTo.add(userProgManager.Email);
                }

            mail.setTargetObjectId(forms.OwnerId);           
            mail.saveAsActivity = false;
            mail.setCcAddresses(ccTo);    
                         
            String urlName = URL.getSalesforceBaseUrl().toExternalForm();
            
            mail.setSubject(recName.Name +' Engineering Wafer Start Request : '+ forms.Request_Number__c+' Approved');
            String body = 'Dear User, <br/><br/>' ;
            body += 'The following eWSR has been approved <br/><br/>';
            body += 'eWSR Number :'+ forms.Request_Number__c+ '<br/><br/>';
            body += 'Lot ID Assigned :'+ forms.Lot_ID_Assigned__c+ '<br/><br/>';
            body += 'Wafer Quantity :'+ forms.Lot_Quantity_No_of_Wafers__c+ '<br/><br/>';
            body += 'Plan Start Date :'+ forms.Plan_Start_Date__c+ '<br/><br/>';
            body += 'Please click the link to access the eWSR form: ';
            body += '<a href='+urlName+'/'+forms.Id+'>Click Here</a>';
            body += '<br/><br/>';
            body += 'Thank you,<br/><br/>';
            body += 'For further clarifications, please contact the Lot Owner';
            mail.setHtmlBody(body);   
            mails.add(mail);                    
        }    
        Messaging.sendEmail(mails);     
        }
        catch(Exception e){}             
    }  
}