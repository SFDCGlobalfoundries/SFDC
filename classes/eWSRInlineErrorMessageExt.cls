/*
    Author: Abhita Bansal
    Description: This Class is used to Show the Error message on View Page whenever the Lot Quantity is greater than Remaining Quantity 
    History: 
    ABansal     12/4/2014 - Code Creation
    ABansal     12/4/2014 - Change the Logic to show the Message dynamic
    ABansal     12/9/2014 - Update the Logic
    ABansal     12/10/2014 - Revert back the changes
*/
public with sharing class eWSRInlineErrorMessageExt{
    
    private ApexPages.StandardController controller{get;set;}
    public Boolean section{get; set;}
    public Integer remQuantity{get;set;}
    public String query{get;set;}
    
    public eWSRInlineErrorMessageExt(ApexPages.StandardController stdcontroller) {
        Decimal formRemQuan;
        section =  false;        
        String id = System.currentPagereference().getParameters().get('id');
        eWSR_Form__c forms = [Select Message__c, recordTypeId, Equivalent_Quantity__c, Remaining_Quantity__c, 
                              Lot_Quantity_No_of_Wafers__c, Full_loop_Short_loop__c from eWSR_Form__c where Id=:id Limit 1];
        RecordType recName = [Select Name from RecordType where id =:forms.recordTypeId Limit 1];
            
            if(recName.Name == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                if(forms.Full_loop_Short_loop__c == 'Short Loop'){
                    formRemQuan  = forms.Remaining_Quantity__c - forms.Equivalent_Quantity__c;
                }
                else{
                  formRemQuan = forms.Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
                }                  
              }
              else{
                 formRemQuan = forms.Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
              }
        if(forms.Message__c != null){
            remQuantity = Integer.valueOf(formRemQuan);
            section = true;
        }             
    }    
}