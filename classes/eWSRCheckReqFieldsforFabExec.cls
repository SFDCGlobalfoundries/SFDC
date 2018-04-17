/*
    Author: Abhita Bansal
    Description: This Class is used for Error Message
                a) if Approver approves the record with filling Lot Id Assigned and Plan Start Date, it will throw an error.
                b) if user clicks on recall button when Status is Pending With Planner Approval, it will throw an error.
    History: 
    ABansal     11/24/2014 - Code Creation
    Abansal     11/26/2014 - Changed the Code for Approval error
    ABansal     12/08/2013 - added the code for recall functionality
*/
public class eWSRCheckReqFieldsforFabExec{
    
    public static void checkReqFields(List<eWSR_Form__c> formsList){
       
        for(eWSR_Form__c eWSRForms : formsList){      
            if(eWSRForms.Lot_ID_Assigned__c == null && eWSRForms.Plan_Start_Date__c == null){             
                eWSRForms.addError(eWSRConstantsVariablesClass.ERRORMSGAPPROVAL);              
            }
        }
    }
    
    public static void checkStatusField(List<eWSR_Form__c> formsList){
        
        for(eWSR_Form__c eWSRForms : formsList){
             eWSRForms.addError(eWSRConstantsVariablesClass.ERRORMSGONRECALL);              
        }      
    }
}