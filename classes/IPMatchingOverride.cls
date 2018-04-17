/*
    Author: Ariz Solito
    Description: Apex class Controller for IP Matching Override
    History: 
    Asolito      07/05/2013    - Apex code created
    Asolito      10/13/2013    - Added validation wherein Approved IP declaration forms cannot be overriden
*/ 
public class IPMatchingOverride {
    private String overrideType;
    private string recId; 

    public IPMatchingOverride(){        
        this.overrideType = ApexPages.currentPage().getParameters().get('override');
        this.recId =  ApexPages.currentPage().getParameters().get('id');
    }
    
    //Method will call AIA to send account details to ERP
    public PageReference init(){            
        try {   
            String result;
            String msg;
            
            for(IP_Declaration_Form__c i :[SELECT status__c
                                             FROM IP_Declaration_Form__c
                                             WHERE id = :this.recId]){
                if(i.status__c == 'Approved'){
                     msg = 'IP Declaration override failed. IP declaration form record is already Approved.';
                     ApexPages.addmessage(
                         new ApexPages.Message(ApexPages.severity.WARNING,msg) 
                    );
                    return null;
                 }                                                                 
            }                                              
                         
            if(this.overrideType == 'VCID'){
                result = IPDeclarationMatching.overrideVCID(new List<String>{this.recId});
            } else if(this.overrideType == 'IP'){
                result = IPDeclarationMatching.overrideIP(new List<String>{this.recId});
            }
                        
            if(this.overrideType == 'VCID'){
                if(result == 'success'){
                    msg = 'IP Declaration matching override by VCID successful.';
                } else {
                    msg = 'IP Declaration matching override by VCID failed. No VCID component list found.';
                }
            } else if(this.overrideType == 'IP'){
                if(result == 'success'){
                    msg = 'IP Declaration matching override by IP successful.';
                } else {
                    msg = 'IP Declaration matching override by IP failed. No IP component list found.';
                }
            }  
            
            if(result == 'success'){
                ApexPages.addmessage(
                    new ApexPages.Message(ApexPages.severity.CONFIRM,msg) 
                );
            } else {
                ApexPages.addmessage(
                    new ApexPages.Message(ApexPages.severity.WARNING,msg) 
                );
            }
            return null;
        } catch (Exception e){
            ApexPages.addmessage(
                new ApexPages.message(ApexPages.severity.ERROR,'Error trying to process IP Declaration override. Please contact the administrator. '+e) 
            );
            return null;           
        }                
        return null;                
    }       
}