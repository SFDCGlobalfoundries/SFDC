/*
    Author: Zymark Ambat
    Description: This Class serves as a flag to prevent recursive PTRF Triggers.
    History: 
        ZAmbat      06112013    - Code creation.
        ZAmbat      10172013    - Added test method.
*/
@isTest
public class PTRFTriggerStopper {

    public static boolean isExecuted = false;
    
    static testMethod void runTest() {
        PTRFTriggerStopper.isExecuted = false;
    }
}