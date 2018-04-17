/*
    Author: Anirban Roy
    Description: This is the controller class for the inline visualforce page Expose Control Attachment. 
    History:
        ARoy        06112013    - code creation.        
*/

public class ExpConAttachController {
    
    // Declare variables
    private List<Attachment> expConAttch;
    private Export_Control_Form__c expCntrForm;
    
    // Constructor to get records using the standard controller
    public ExpConAttachController(ApexPages.StandardController controller){
        this.expCntrForm = (Export_Control_Form__c)controller.getRecord();
    }
    
    // Retrieve the list of Attachment with the Q4 and Q5 description
    // of Export Control
    public List<Attachment> getExpConAttch(){
        expConAttch = [select id, name,description from Attachment 
                      where parentid = :expCntrForm.id 
                      order by lastmodifieddate desc];

        if(expConAttch.size()>0){
            return expConAttch;
        }else{
            return null;
        }       
    }
}