/**
* @ Author :- Navneet Rajput
* @ Company :- Globalfoundries
* @ Description :- Class handles json object creation logic                
* @ Date :- 10/03/2016
* @ Change History :- 
**/

public with sharing class DRC_JsonGenerator {
    
    String objType;
    
    public DRC_JsonGenerator() {
        
    }
    
    // accept list of waiver rule list and waiver collaborator object and preapre json request
    public static String getJsonRequest(List<Waiver_Rule_List__c> lst_WaiverRules,Wavier_Collaborator__c dwcObj){

       try {
        
            JSONGenerator jGen = JSON.createGenerator(true);
            
            if (dwcObj<>NULL) {
                
                jGen.writeStartObject();
                    jGen.writeFieldName('job_level');
                    jGen.writeStartObject();
                    	if(dwcObj.MantisId__c<>null){
                        jGen.writeNumberField('mantis_id', dwcObj.MantisId__c);
                    	}
                    	if(dwcObj.PTSR_Number__c<>null){
                        jGen.writeStringField('ptsr', dwcObj.PTSR_Number__c);
                    	}
                    	if(dwcObj.Waiver_Status__c<>null){
                        jGen.writeStringField('agg_status', dwcObj.Waiver_Status__c);
                    	}
                    	if(dwcObj.PTSR_Status__c<>null){
                        jGen.writeStringField('coll_status', dwcObj.PTSR_Status__c);
                    	}
                        jGen.writeStringField('coll_comment', String.isEmpty(dwcObj.Cancellation_Reason__c)?'No Comments':dwcObj.Cancellation_Reason__c);
                    	
                        
                    jGen.writeEndObject();          
                
                    jGen.writeFieldName('chk_level');
                    jGen.writeStartArray();
                    
                    if (lst_WaiverRules<>NULL && !lst_WaiverRules.isEmpty()) {
                        
                        for (Waiver_Rule_List__c wRule : lst_WaiverRules) {
                            jGen.writeStartObject();
                            if(wRule.RuleId__c<>null){
                            jGen.writeNumberField('check_id', wRule.RuleId__c);
                            }
                            jGen.writeStringField('fe_comment',String.isEmpty(wRule.GF_Internal_Closing_Comment__c)?'No Comments':wRule.GF_Internal_Closing_Comment__c);
                            jGen.writeStringField('final_comments',String.isEmpty(wRule.Customer_Closing_Comment__c)?'No Comments':wRule.Customer_Closing_Comment__c);
                            if(wRule.Final_Stage__c <> null){
                            jGen.writeStringField('collaborator_status', wRule.Final_Stage__c);   
                            }      
                            jGen.writeEndObject();  
                        }
                        
                    }   
                    jGen.writeEndArray();
                jGen.writeEndObject();
                
            }
            
            return jGen<>NULL?jGen.getAsString():null;
            
       } catch (Exception exp) {
        
             GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex class', exp, system.now());
            
       }    
        
        return null;
    }
    
     // accept list of waiver rule list and waiver collaborator object and preapre json request
    public static String getJsonRequestForRevert(List<Waiver_Rule_List__c> lst_WaiverRules,Wavier_Collaborator__c dwcObj){

       try {
        
            JSONGenerator jGen = JSON.createGenerator(true);
            
            if (dwcObj<>NULL) {
                
                jGen.writeStartObject();
                    jGen.writeFieldName('job_level');
                    jGen.writeStartObject();
                    	if(dwcObj.MantisId__c<>null){
                        jGen.writeNumberField('mantis_id', dwcObj.MantisId__c);
                    	}
                    	if(dwcObj.PTSR_Number__c<>null){
                        jGen.writeStringField('ptsr', dwcObj.PTSR_Number__c);
                    	}
                    	
                        jGen.writeStringField('agg_status','cRR');
                    	
                        jGen.writeStringField('coll_status', 'REVERT');
                    	
                        jGen.writeStringField('coll_comment', String.isEmpty(dwcObj.Cancellation_Reason__c)?'No Comments':dwcObj.Cancellation_Reason__c);
                    	
                        
                    jGen.writeEndObject();          
                
                    jGen.writeFieldName('chk_level');
                    jGen.writeStartArray();
                    
                    if (lst_WaiverRules<>NULL && !lst_WaiverRules.isEmpty()) {
                        
                        for (Waiver_Rule_List__c wRule : lst_WaiverRules) {
                            jGen.writeStartObject();
                            if(wRule.RuleId__c<>null){
                            jGen.writeNumberField('check_id', wRule.RuleId__c);
                            }
                            jGen.writeStringField('fe_comment',String.isEmpty(wRule.GF_Internal_Closing_Comment__c)?'No Comments':wRule.GF_Internal_Closing_Comment__c);
                            jGen.writeStringField('final_comments',String.isEmpty(wRule.Customer_Closing_Comment__c)?'No Comments':wRule.Customer_Closing_Comment__c);
                            
                            jGen.writeStringField('collaborator_status','cRR');   
                                  
                            jGen.writeEndObject();  
                        }
                        
                    }   
                    jGen.writeEndArray();
                jGen.writeEndObject();
                
            }
            
            return jGen<>NULL?jGen.getAsString():null;
            
       } catch (Exception exp) {
        
             GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex class', exp, system.now());
            
       }    
        
        return null;
    }
    
}