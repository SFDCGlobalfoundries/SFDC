/*
    Class Name:    UtilityValidatorHelper
    Author:        Prosenjit Saha(PS)
    Description:   This Class blocks recursive call. This is a global  utility class. This can be used to restrict your recursive call of 
                   a functionality in any apex class
    Created Date: 
      PS           01022014    - Code creation.
    Change History:
      Author: 
      Modified Date: 
      Reason:
*/
global class UtilityValidatorHelper{

    private static boolean blnAlreadyDone = false;
    //this method returns flase if calling for the first time. 
    public static boolean hasAlreadyDone(){ 
        return blnAlreadyDone;
    }
    
    //this method is used to set the static variable to true, so that your code will not be called recursively .  
    public static void setAlreadyDone() {  
        blnAlreadyDone = true;
    }
}