/*
    Author: Poulami Saha
    Description: This serves as utility class to calculate running number (eg, 1 - 99, A0 - Z9, AA - ZZ).
    History: 
        Poulami     01142016    - Code creation.
*/

public class MPWTrainRunningNumber {

    public static string calculateRunningNumber(String runningNumber) {
        string additionalPrefix = '';
        for (integer i=0; i<runningNumber.length(); i++) {
            if(runningNumber.length() == 2){
                //Incrementing running number by 1 for 1 - 99
                if(runningNumber.isNumeric() && Integer.valueOf(runningNumber) < 99){
                    runningNumber = string.valueOf(integer.valueOf(runningNumber.substring(i, runningNumber.length())) + 1);
                    break;
                }
                //Resetting running Number to A0 after 99
                else if(runningNumber.isNumeric() && Integer.valueOf(runningNumber) == 99)
                {
                    runningNumber = 'A0';
                    break;
                }
                //Resetting running number to AA after Z9
                else if(runningNumber == 'Z9'){
                    runningNumber = 'AA';
                    break;
                }
                //Incrementing the numeric part of alpha numeric running number (A1 - A9)
                else if (runningNumber.substring(i, runningNumber.length()).isNumeric()) {
                    runningNumber = additionalPrefix + string.valueOf(integer.valueOf(runningNumber.substring(i, runningNumber.length())) + 1);
                    break;
                }
                //Incrementing the alphabet part of alpha numeric running number (B0 after A9)
                else if(!runningNumber.isNumeric() && runningNumber.substring(1,2) == '9'){
                    String char1 = runningNumber.substring(0,runningNumber.length()-1);
                    Integer[] int1 = char1.getChars();
                    List<Integer> intArr = new List<Integer>{int1[0] + 1};
                    String newChar = string.fromCharArray(intArr);
                    runningNumber = newChar + '0';
                    break;
                }
                //Incrementing the character part of alphabet running number (AB - ZZ)
                else if(!runningNumber.isNumeric() && !runningNumber.substring(1,2).isNumeric() && i == 1){
                    //Incrementing left character part of alphabet running number after AZ to B@ (As @ is previous character of A)
                    if(runningNumber.substring(1,2) == 'Z'){
                        String addchar1 = additionalPrefix;
                        Integer[] addint1 = addchar1.getChars();
                        List<Integer> addintArr = new List<Integer>{addint1[0] + 1};
                        String addnewChar = string.fromCharArray(addintArr);
                        additionalPrefix = addnewChar;
                        runningNumber = additionalPrefix + '@';
                        i=0;
                        continue;
                    }
                    //Incrementing right character part of alphabet running number (AB - AZ)
                    String char1 = runningNumber.substring(1,runningNumber.length());
                    Integer[] int1 = char1.getChars();
                    List<Integer> intArr = new List<Integer>{int1[0] + 1};
                    String newChar = string.fromCharArray(intArr);
                    runningNumber = additionalPrefix + newChar;
                    break;
                }
                //Fetching alphabet part of alpha numeric running number
                else {
                    additionalPrefix = runningNumber.substring(0, i + 1);
                }
            }
            if(runningNumber.length() == 1){
                if(runningNumber.isNumeric()){
                    runningNumber = '0' + string.valueOf(integer.valueOf(runningNumber.substring(i, runningNumber.length())) + 1);
                    break;
                }
            }
        }
        return runningNumber;
    }
}