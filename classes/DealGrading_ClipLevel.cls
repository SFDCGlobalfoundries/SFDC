/*
Type name: DealGrading_ClipLevel
Author: Vijay Vemuru

Description: This class evaluates the rules that are active in the below 2 conditions:

1.Client Level: if the client in the exemption matches with the client (Opp's account) in deal grading record, if match is found then result and deal grading status
is changed to 'NO Bid - deal Grading not required.
2.Clip level: If the the combination of 'Target Process Node', Min LTR, Product Line, matches with the current deal grading record in context
then result and deal grading status is changed to 'NO Bid - deal Grading not required'.

Test Class: DealGrading_CliplevelTest
History:    6/7/2016  Code creation
*/
public class DealGrading_ClipLevel {
    
    public void Implementcliplevel(List<Deal_Grading__c> dealgrading){
        List<Clip_Level_Exemption__c> rules     =       new List<Clip_Level_Exemption__c>();
        set<string> typeOfExceptions = new set<String>{'Client Exemption','Clip level'};
        set<id> oppIds = new set<id>();
        for(Deal_Grading__C dg : dealgrading){
           oppIds.add(dg.Opportunity1__c);
           
        }
        map<id,opportunity> oppMap = new map<id,opportunity>();
        try{
            oppMap = new map<id,opportunity>([SELECT accountId FROM Opportunity where id in:oppIds] );
        }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_ClipLevel','Implementcliplevel','','Exception while getting the Opportunity data',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
        try{                    
            rules = [SELECT Account__c,Account__r.id, Target_Process_Node__c, Brand__c, LTR_Min__c, Type_of_Exception__c 
                        FROM Clip_Level_Exemption__c WHERE Active__c =: True AND Type_of_Exception__c IN: typeOfExceptions];
        }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_ClipLevel','Implementcliplevel','','Exception while getting the Clip Level data',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
        for(Deal_Grading__c dg:dealgrading){
            String dg_Combination = dg.Target_Process_Node__c+dg.Product_Line__c;
            for(Clip_Level_Exemption__c rule1 : rules){
                String Rule_Combination = rule1.Target_Process_Node__c+rule1.Brand__c;
                
                //Clip Level Implementation   
                             
                if( (dg_Combination == rule_Combination) && (rule1.Type_of_Exception__c=='Clip level')  && (dg.LTR_Rev__c>rule1.LTR_Min__c)){
                        dg.Result__c                =   'Deal Grading Not Required';   
                        dg.Deal_Grading_status__c   =   'Bid - Review Not Required';
                }
                
                //Client Level Implementation
                
                 if(rule1.Type_of_Exception__c=='Client Exemption' && oppMap.get(dg.Opportunity1__c).AccountId  ==  Rule1.Account__c){ 
                    dg.Result__c                =   'Deal Grading Not Required';   
                     dg.Deal_Grading_status__c   =   'Bid - Review Not Required';
                 }               
             }  
              
         }
        
     }
    
 }