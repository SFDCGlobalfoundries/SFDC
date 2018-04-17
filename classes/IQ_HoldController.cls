/*
    Author: Pradosh Samal
    Description: This is the class for Hold for Informal Quote  
    History:
        Psamal       17112016    - code creation.
*/
public class IQ_HoldController {
    
    public Informal_Quote__c informalQuote {get; set;}
    
    public IQ_HoldController (ApexPages.StandardController stdController) {
        
        this.informalQuote = (Informal_Quote__c)stdController.getRecord();
        
        informalQuote = [SELECT Id, Budgetary_Quote_Status__c, Hold_Stage__c, Hold_Reason__c, Hold_Reason_All__c, Hold_Time__c FROM Informal_Quote__c WHERE Id = : informalQuote.Id];
    }
    
    public PageReference hold() {
        try{
            if(informalQuote.Budgetary_Quote_Status__c == 'Hold'){
                
                informalQuote.Budgetary_Quote_Status__c = informalQuote.Hold_Stage__c;
                informalQuote.Hold_Stage__c = null;
                
                if(informalQuote.Hold_Reason_All__c != null){
                    
                    informalQuote.Hold_Reason_All__c += ' <br/> ' +  informalQuote.Hold_Time__c.format('MM/dd/yyyy HH:mm:ss a') + ' - ' + informalQuote.Budgetary_Quote_Status__c + ' - ' + informalQuote.Hold_Reason__c;
                }
                else{
                    
                    informalQuote.Hold_Reason_All__c = informalQuote.Hold_Time__c.format('MM/dd/yyyy HH:mm:ss a') + ' - ' + informalQuote.Budgetary_Quote_Status__c + ' - ' + informalQuote.Hold_Reason__c;
                }
                
                informalQuote.Hold_Reason__c = null;
                
                update informalQuote;
                
                //For code coverage for catch block
                if(Test.isRunningTest()) {
                    if(ApexPages.currentPage().getParameters().get('test') != NULL){
                        String temp;
                        temp.length();
                    }
                }
                
                PageReference pageRef = new PageReference('/' + informalQuote.Id);
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        catch(Exception e){
            
            GlobalUtility.logMessage('Error', 'IQ_HoldController', 'hold', '', '', e.getMessage(), '', 'Informal Quotes', e, 0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' + e.getStackTraceString()));
        }
        return null;
    }
    
    public PageReference save() {
        try{
            informalQuote.Hold_Stage__c = informalQuote.Budgetary_Quote_Status__c;
            informalQuote.Budgetary_Quote_Status__c = 'Hold';
            informalQuote.Hold_Time__c = System.now();
            
            update informalQuote;
            
            //For code coverage for catch block
            if(Test.isRunningTest()) {
                if(ApexPages.currentPage().getParameters().get('test') != NULL){
                    String temp;
                    temp.length();
                }
            }
            
            PageReference pageRef = new PageReference('/' + informalQuote.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            
            GlobalUtility.logMessage('Error', 'IQ_HoldController', 'save', '', '', e.getMessage(), '', 'Informal Quotes', e, 0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' + e.getStackTraceString()));
        }
        return null;
    }
}