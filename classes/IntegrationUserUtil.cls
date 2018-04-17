/*
  Author: Anirban Roy
  Description: This is a utility class to skip trigger run for data loading using Integration Users.
  History:
    ARoy            11052013    - code creation.                     
*/

public class IntegrationUserUtil {
    
    public static boolean isSkipTrigger(){
        boolean isSkipTrigger = false;      
        IntegrationUsers__c intUsr = IntegrationUsers__c.getValues(UserInfo.getUserId());
        if(intUsr <> null && intUsr.Skip_Trigger__c){
            isSkipTrigger = true;
        }
        return isSkipTrigger;
    }
    
    public static boolean isSkipNotification(){
        boolean isSkipNotification = false;      
        IntegrationUsers__c intUsr = IntegrationUsers__c.getValues(UserInfo.getUserId());
        if(intUsr <> null && intUsr.Skip_Notification__c){
            isSkipNotification = true;
        }
        return isSkipNotification;
    }
}