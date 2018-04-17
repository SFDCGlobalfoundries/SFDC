/*
  Author: Ariz Solito
  Description: Helper class for Error Codes custom setting.
  History:
    Asolito    09182014:    Code created
*/
public class ErrorCode {
  
    // retrieves the value of the global variable 'name'
    public static String get(String name){
        String returnValue = null;
        final Map<String,Error_Codes__c> all = Error_Codes__c.getAll();
    
        if((name!=null) && (name.trim()!=null) && (name.trim().length()>0) && (all!=null) && (all.get(name)!=null)){
            returnValue = all.get(name).Message__c;
        }
        return returnValue;
    }
}