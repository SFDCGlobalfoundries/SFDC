/*
    Author : Abhita Bansal
    Description : This trigger is used Show the error messages on status update
    Code Creation: 24/11/2014
*/
trigger eWSRFormBeforeUpdateTrigger on eWSR_Form__c (before Update) {
    
    List<eWSR_Form__c> eWSRFormsListApp = new List<eWSR_Form__c>();
    List<eWSR_Form__c> eWSRFormsListNew = new List<eWSR_Form__c>();
    
    if(!IntegrationUserUtil.isSkipTrigger()){
    
    for(eWSR_Form__c forms : trigger.new){
      if(forms.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
          eWSRFormsListApp.add(forms);
      }
      //if(forms.Status__c == eWSRConstantsVariablesClass.STATUSNEW && trigger.oldMap.get(forms.Id).Status__c.contains(eWSRConstantsVariablesClass.STATUSPLANAPPROVAL)){
      if(forms.Status__c == eWSRConstantsVariablesClass.STATUSNEW && eWSRConstantsVariablesClass.STATUSPLANAPPROVAL.contains(trigger.oldMap.get(forms.Id).Status__c)){
          eWSRFormsListNew.add(forms);
      }
    }
    if(!eWSRFormsListApp.isEmpty()){
        eWSRCheckReqFieldsforFabExec.checkReqFields(eWSRFormsListApp);
    } 
    if(!eWSRFormsListNew.isEmpty()){
        eWSRCheckReqFieldsforFabExec.checkStatusField(eWSRFormsListNew);
    } 
    }
}