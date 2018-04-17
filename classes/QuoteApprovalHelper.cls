/*
    Author: 
    Description: This class expose a webservice called from the custom 'submit for approval' button on the 
                 Informal_Quote__c object.
    History:
        Nbustillos    10/01/2013    - Code creation.
*/
global class QuoteApprovalHelper{
    WebService static String processApproval(String quoteId) {
        String retVal;
        
        Informal_Quote__c objQuote = [select Total_Line_Items__c, Budgetary_Quote_Status__c from Informal_Quote__c where Id = :quoteId]; 
        if(objQuote.Total_Line_Items__c>0){
            system.debug('STATUS: ' + objQuote.Budgetary_Quote_Status__c);
            if(objQuote.Budgetary_Quote_Status__c == 'Draft' || objQuote.Budgetary_Quote_Status__c == 'Rejected'){ 
                Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                approvalReq.setObjectId(objQuote.id);
    
                // Submit the approval request for the account 
                Approval.ProcessResult processResult = Approval.process(approvalReq);
                
                retVal = 'success';
            }else{
                retVal = 'You cannot resubmit the record with pending approval/approved/rejected.';
            }
        }else{
            retVal = 'Atleast one Quote Item is required before submitting Informal Quote for approval.';
        }
        return retVal;
    }
    public static void updateFieldEngineers(List<Informal_Quote__c> IInformalQuote, List<Account_Team_Proxy__c> lAccountTeamProxies) {
    final String ROLE_PRIMARY_FIELD_ENGINEER
      = Account_Team_Roles__c.getInstance('ROLE_PRIMARY_FIELD_ENGINEER').Role__c;
    
        // Set Corrosponding Account Manager(s) to Risk Start System.
        String FieldEngineer;
        Boolean flagFieldEngineer = false;
        if (lAccountTeamProxies != null && !lAccountTeamProxies.isEmpty()) {
            for (Informal_Quote__c eachInformalQuote: IInformalQuote) {
                eachInformalQuote.User1__c = null;
                eachInformalQuote.User2__c = null;
                
                for (Account_Team_Proxy__c eachAccountTeamProxy: lAccountTeamProxies) {
                      if (eachInformalQuote.Account__c == eachAccountTeamProxy.Account__c) {
						//Commenting the check as the result set already contains FAE atps only
                        //if (eachAccountTeamProxy.Team_Role__c.equalsIgnoreCase(ROLE_PRIMARY_FIELD_ENGINEER))
                        //{
                            if (!flagFieldEngineer) {
                                FieldEngineer = eachAccountTeamProxy.User__c;
                                eachInformalQuote.User1__c = FieldEngineer;
                                eachInformalQuote.User2__c = FieldEngineer;
                                flagFieldEngineer = true;
                            }

                            if (eachInformalQuote.User1__c == FieldEngineer) {
                                    eachInformalQuote.User1__c = eachAccountTeamProxy.User__c;
                            } else if (eachInformalQuote.User2__c == FieldEngineer) {
                                    eachInformalQuote.User2__c = eachAccountTeamProxy.User__c;
                                }
                            
                        //}
                    }
                }
            }
        }
    }
}