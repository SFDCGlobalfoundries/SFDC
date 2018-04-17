/*
    Author: Abhita Bansal
    Description: This Class is used to update Email field in notification group according to the user name present for form
    History: 
    ABansal     11/20/2014 - Code Creation
	ABansal		11/28/2014 - Update the logic to update the Email field 
*/
public class eWSRUpdateEmailFieldClass{
 
    public static void updateField(Set<Id> notGpIds) {
        
        List<eWSR_Notification_Group__c> notiGpList = new List<eWSR_Notification_Group__c>();
        list<String> userList = new List<String>(); 
        map<String, String> mapUserEmail = new Map<String, String>();
        
        for(eWSR_Notification_Group__c notiGroup : [Select User__c from eWSR_Notification_Group__c where Id =:notGpIds]){
          userList.add(notiGroup.user__c);
        }
        
        for(User user :[Select Name, Email from User where Name IN:userList]){
            mapUserEmail.put(user.Name, user.Email);
        }
        
        for(eWSR_Notification_Group__c notiGroup : [Select User_Email__c, User__c from eWSR_Notification_Group__c where Id =:notGpIds]){
          notiGroup.User_Email__c = mapUserEmail.get(notiGroup.User__c);
          notiGpList.add(notiGroup);
        }
        if(!notiGpList.isEmpty()){
           update notiGpList ;
        } 
    }
}