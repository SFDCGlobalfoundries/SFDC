/*
Type Name: DealGrading_Only1DGPerOPP
Author : Deal Grading Team
Description: Logic for insert and update is seperate, this is to make sure that we have only 1 DG per Opp
Only1DgPerOpp- This class checks for the count of existing deal grading record on Opportunity on before Insert and it also checks for the count of existing deal grading record on Opportunity on before update 
Test Class: DealGrading_Only1DGPerOPPTest
History: 
        6/20/2016        code creation
*/
Public class DealGrading_Only1DGPerOPP{
    
    public static void Only1DgPerOpp2(List<Deal_Grading__c> Deal_Grading){

        set<id> oppids = new set<id>();
        for(Deal_Grading__c dg : Deal_Grading) {
            oppids.add(dg.Opportunity1__c);
        }
        Map<id,opportunity> oppMap = new map<id,opportunity>();            
        System.debug('oppLst::'+oppMap);            
        try{
            oppMap = new Map<Id,opportunity>([Select Id,Deal_Grading_Status__c From opportunity Where Id In :oppids]);            
        }catch(Exception excp){GlobalUtility.logMessage('Error','DealGrading_Only1DGPerOPP','Only1DgPerOpp2','','Exception while getting the opportunity records',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}
        for(Deal_Grading__c dg : Deal_Grading) {
            System.debug('STatus:::'+oppMap.get(dg.Opportunity1__c).Deal_Grading_Status__c);
            if(oppMap.get(dg.Opportunity1__c).Deal_Grading_Status__c != null && oppMap.get(dg.Opportunity1__c).Deal_Grading_Status__c != null && oppMap.get(dg.Opportunity1__c).Deal_Grading_Status__c != 'Previously Approved'){
                 dg.addError('Deal Grading exists, please make sure that you have only 1 Deal Grading per Opportunity');
            }	                
        } 
    }   
}