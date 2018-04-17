/*
Author: Shyam Ravindra Nair
Description: Apex class will act as controller for component CuSRFormTableForAnnualReminderComponent.
History:
SNair     06022015     - code creation
SNair     09022015     - modified
*/
public class CuSRFormTableForAnnualReminderController {
    public String originatorId {get;set;}
    public String frontURL{get;set;}
    public CuSRFormTableForAnnualReminderController(){
        frontURL = URL.getSalesforceBaseUrl().toExternalForm();
    }
    public List<CuSR_Form__c> getCuSRFormList(){
        Date currentDate = Date.today();
        Integer tempMonth = currentDate.month()+1;
        if(tempMonth == 13){
            tempMonth = 1;
        }
        String currentMonth = String.valueOf(tempMonth);
        List<CuSR_Form__c> cusrFormList = new List<CuSR_Form__c>();
        cusrFormList = [select Id, Name, Customer_Name__c, Customer_Name__r.Name, Scope__c, System__c, Requested_Effective_Date__c from CuSR_Form__c where OwnerId =: originatorId and Status__c = 'Implemented' and Request_Effective_Month__c =: currentMonth and Validity_Period_of_this_Request__c = 'EOL'];
        return cusrFormList;
    }
}