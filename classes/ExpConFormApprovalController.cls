/*
  Author: Anirban Roy
  Description: This is the controller for the Export Control Form Approval Process.
  History:
    ARoy            10292013    - code creation. 
    ARoy            03052014    - updated code as per Case - 00005251(addition of new question).                     
  DBiswal         11112014    - added code to do a validation check for CCAT Number if ECCN Number is '5A002'.
  Devendra        20092016    - updated the functionality to support the Export Control form for Red system.
*/

public class ExpConFormApprovalController {
    
    private string recId; 

    public ExpConFormApprovalController(){
        this.recId=  ApexPages.currentPage().getParameters().get('id');
    }
    
    public String validateECForm(Export_Control_Form__c ecf){
        
        String retMsg = '';     
        
        if(ecf.Email_Address__c == null){
            retMsg += Error_Codes__c.getInstance('EXPORT_CONTROL_EMAIL_VALIDATION').Message__c+'<br/>';                  
        }
        if(ecf.Phone__c == null){
            retMsg += Error_Codes__c.getInstance('EXPORT_CONTROL_PHONE_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Customer_Trade_Compliance_Contact_Person__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_CUSTTRADECOMPPER_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Product_Description__c == null){
            retMsg += Error_Codes__c.getInstance('EXPORT_CONTROL_PROD_DESC_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Weapon_Product__c == null){
            retMsg += Error_Codes__c.getInstance('EXPORT_CONTROL_WEAPON_PROD_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Military_App_Product__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_MILITARY_APP_PROD_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Military_App_Product__c == 'Yes' && ecf.Military_App_Product_Details__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_MLTRY_APP_PROD_DTL_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.ITAR_Product__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_ITAR_PROD_FLD_VALIDATION').Message__c+'<br/>';
        }
        
        if(ecf.Encryption_Control_Product__c == 'No' && ecf.US_EAR_Product__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_US_EAR_PROD_FLD_VALIDATION').Message__c+'<br/>';
        }
        
        if(ecf.Non_US_EAR_Product__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_NON_US_CTRL_PROD_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Non_US_EAR_Product__c == 'Yes' && ecf.Non_US_EAR_Product_Details__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_NON_US_CTRL_PROD_DTL_VALID').Message__c+'<br/>';
        }
        if(ecf.Harmonized_System__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_HARMONIZED_SYS_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.Harmonized_System__c <> null && ecf.Harmonized_System__r.Name == 'Other' && ecf.Other_Harmonized_System__c == null){
            retMsg += Error_Codes__c.getInstance('EXP_CON_OTHER_VALIDATION').Message__c+'<br/>';
        }
        if(ecf.End_User_Customer_Name__c == null && ecf.CreatedDate>=Date.valueOf(Environment_Variable__c.getInstance('EXP_CNTRL_Q8_VALID_DATE').Value__c)){
            retMsg += Error_Codes__c.getInstance('EXP_CON_END_USR_CUST_NAME').Message__c+'<br/>';
        }
     //11112014 DBiswal - Validation Check for CCAT Number
        List<String> ccatValues = Environment_Variable__c.getinstance('EXP_CON_FORM_Q5_CCAT_CHECK').value__c.split(';');
        Boolean check = false;
        try{
        if(ecf.US_EAR_Product_Details__c <> null){ 
            for(String ccat:ccatValues){
                if(ecf.US_EAR_Product_Details__c.contains(ccat) && ecf.CCAT_Number__c == null){        
                    check = true;
                }
            }
        }
        }catch(Exception e){
            system.debug('Exception'+ e.getMessage());
        }
        if(check){
            retMsg += Error_Codes__c.getInstance('EXP_CON_CCAT_NO_VALIDATION').Message__c+'<br/>';
        }
        
        return retMsg;
    }
    
    // This method is used to call the approval process for Export Control Form
    public PageReference submitExpConForm(){
        
        String id = this.recId;
        boolean isAtt1Chk = false;
        boolean isAtt2Chk = false;
        boolean isAtt3Chk = false;
        String q4Desc = EnvironmentVariable.get('EXP_CON_FORM_Q4_DESC');
        String q5Desc = EnvironmentVariable.get('EXP_CON_FORM_Q5_DESC');
        String q4Name = EnvironmentVariable.get('QUES_4_STARTSWITH');
        String q5Name = EnvironmentVariable.get('QUES_5_STARTSWITH');

        string QUES_5_NEW_DESC = EnvironmentVariable.get('QUES_5_NEW_DESC');
        string QUES_5_NEW_BEGIN = EnvironmentVariable.get('QUES_5_NEW_STARTSWITH');             
                
        try{
            Export_Control_Form__c ecf = [SELECT    Email_Address__c,
                                                    Phone__c,
                                                    Customer_Trade_Compliance_Contact_Person__c,
                                                    Product_Description__c,
                                                    Weapon_Product__c,
                                                    Military_App_Product__c,
                                          			Encryption_Control_Product__c,
                                                    Military_App_Product_Details__c,
                                                    ITAR_Product__c,
                                                    ITAR_Product_Details__c,
                                                    (SELECT Id,
                                                    Name 
                                                    FROM Attachments WHERE Name LIKE 'Q4_%' OR Name LIKE 'Q5_%' or Name LIKE 'Q6_%'),
                                                    US_EAR_Product__c,
                                                    US_EAR_Product_Details__c,
                                                    Non_US_EAR_Product__c,
                                                    Non_US_EAR_Product_Details__c,
                                                    Harmonized_System__c,
                                                    Harmonized_System__r.Name,
                                                    Other_Harmonized_System__c,
                                                    End_User_Customer_Name__c,
                                                    CreatedDate,
                                                    CCAT_Number__c
                                          FROM      Export_Control_Form__c
                                          WHERE     Id = :id];
            
            if(ecf != null){
                
                for(Attachment att : ecf.Attachments){
                    if(att.name.startsWith(q4Name)){
                        isAtt1Chk = true;
                    }
                    if(att.name.startsWith(q5Name)){
                        isAtt2Chk = true;
                    }
                    if(att.name.startsWith(QUES_5_NEW_BEGIN)){
                        isAtt3Chk = true;
                    }
                }
                
                String retMsg = validateECForm(ecf);
                
                /*
                if(ecf.ITAR_Product__c == 'Yes'&& !isAtt1Chk){
                    retMsg += q4Desc + '<br/>';
                }
                
                if(ecf.US_EAR_Product__c == 'Yes' && ecf.US_EAR_Product_Details__c == null && !isAtt2Chk){
                    retMsg += q5Desc + '<br/>';
                }
                
                if(ecf.Encryption_Control_Product__c == 'Yes'&& !isAtt3Chk){
                    retMsg += QUES_5_NEW_DESC + '<br/>';
                }
                
                */
                
                if(retMsg <> ''){
                    retMsg = retMsg.removeEnd('<br/>');
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,retMsg));
                }else{
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(id);
                    
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                    
                    // Return the result status
                    if(result.isSuccess()){
                        PageReference pgr = new PageReference('/'+id);
                        pgr.setRedirect(true);
                        return pgr;
                    }
                }               
            }                        
        }catch(System.DMLException e){
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public PageReference cancel(){
        return new PageReference('/'+this.recId);
    }
}