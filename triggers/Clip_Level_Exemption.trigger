/*
Type name: Clip_Level_Exemption
Author: Vijay Vemuru
Description: This is a Trigger on DealGrading Clip Level, where Clip Level and Client Level Implementation is done. For selected Accounts and selected criteria the Deal Grading is not required.
    
    History: 07192016    - Code creation
*/
trigger Clip_Level_Exemption on Clip_Level_Exemption__c (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate || trigger.isInsert){
            set<id> Accids = new set<id>();
            for(Clip_Level_Exemption__c exe : trigger.new){
                if( trigger.isInsert || 
                    exe.Account__c != trigger.oldmap.get(exe.id).Account__c || exe.Target_Process_Node__c != trigger.oldmap.get(exe.id).Target_Process_Node__c ||exe.brand__c != trigger.oldmap.get(exe.id).brand__c || exe.LTR_Min__c != trigger.oldmap.get(exe.id).LTR_Min__c || 
                    exe.Active__c  != trigger.oldmap.get(exe.id).active__c ) {
                        Accids.add(exe.Account__c);
                    }
            }    
            List<Opportunity> oppList = new List<Opportunity>();
            try{
                oppList = [SELECT id,Target_Process_Node__c,Product_Line__c, LTR_Rev_M__c, AccountID,Deal_Grading_Result__c, Deal_Grading_Status__c FROM opportunity WHERE AccountId IN:Accids ];
            }catch(Exception excp){GlobalUtility.logMessage('Error','Clip_Level_Exemption.trigger','After insert or update','','Exception while getting the  Opportunity data',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
            
            if(oppList.size() >0){
                List<opportunity> updateOppList = new list<Opportunity>();
                for(opportunity dg:oppList){
                    
                    String dg_Combination = dg.Target_Process_Node__c+dg.Product_Line__c;
                    for(Clip_Level_Exemption__c rule1 : trigger.new){
                        if(rule1.Active__c){
                            String Rule_Combination = rule1.Target_Process_Node__c+rule1.Brand__c;
                           //Clip Level Implementation                
                            if( (dg_Combination == rule_Combination) && (rule1.Type_of_Exception__c=='Clip level')  && (dg.LTR_Rev_M__c>rule1.LTR_Min__c)){
                                    updateOppList.add(new opportunity(id = dg.id,Deal_Grading_Result__c   =   'Deal Grading Not Required',Deal_Grading_Status__c   =   'Bid - Review Not Required')); 
                            }else if(rule1.Type_of_Exception__c=='Client Exemption' && dg.AccountId  ==  Rule1.Account__c){ 
                                updateOppList.add(new opportunity(id = dg.id,Deal_Grading_Result__c   =   'Deal Grading Not Required',Deal_Grading_Status__c   =   'Bid - Review Not Required')); 
                            } 
                        }else if(dg.Deal_Grading_Result__c   ==   'Deal Grading Not Required' || dg.Deal_Grading_Status__c   ==   'Bid - Review Not Required') {
                            updateOppList.add(new opportunity(id = dg.id,Deal_Grading_Result__c   =   '',Deal_Grading_Status__c   =   '')); 
                        }
                                      
                    }   
                      
                }
                
                if(!oppList.isEmpty()) {
                    RecursionPrevent.alreadyModified = true;
                    update updateOppList;
                }
            }      
        }
    }
}