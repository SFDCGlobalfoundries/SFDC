/*
    Author: Ariz Solito
    Description: Apex class for utils methods
    History: 
    Asolito     04232013    - Apex code created
    Asolito     06102013    - added string list to map method        
*/
public with sharing class UtilsString {

    //Generic method to check if a field/variable is blank  
    public static Boolean isNotBlank(Object val){
        if(val instanceOf String){
            return isNotBlank(String.valueOf(val));
        } else {
            if(val <> null){
                return true;
            }
        }
        return false;
    }
    
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    //Convert string list to string map
    public static Map<String,String> convertStringListToMap(List<String> lst){
        Map<String,String> convertedMap = new Map<String,String>();
        
        for(String l: lst){
            convertedMap.put(l,l);
        } 
        return convertedMap;
    }           
}