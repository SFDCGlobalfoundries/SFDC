/*
* @ Author :- Navneet Rajput
* @ Description :- This class handles all after update operation of Drc_DrcRuleInfoTrigger
                    It will get all drc rule records and update DWC final status and aggregated waiver status 
                    It will final stage of every rule and based on some calculations it will update DWC final staus
* @ Date :- 5 th April 2016
* @ Change History :-  
**/

public with sharing class DRC_DrcRuleInfoTriggerHandler {
    
    public Map<Id,List<Waiver_Rule_List__c>> map_waiverRules;
     
    
    public DRC_DrcRuleInfoTriggerHandler() {
        
        map_waiverRules = new Map<Id,List<Waiver_Rule_List__c>>();
        
    }
    
    // Method helps to prepare rule table information
    public static void prepareRuleTable(List<Waiver_Rule_List__c> lst_Rules) {
        
        Set<Id> set_DrcIds = new Set<Id>();
        
        for (Waiver_Rule_List__c wrObj : lst_Rules){
            
            if (!set_DrcIds.contains(wrObj.Waiver_Collaborator__c)) {
                set_DrcIds.add(wrObj.Waiver_Collaborator__c);
            }
            
        }
        
        if (set_DrcIds<>NULL && !set_DrcIds.isEmpty()){
            
            new DRC_DrcRuleInfoTriggerHandler().getAllRules (set_DrcIds);
        }
    }
    
    
    @future(callout=true)
    public static void getStatusData(string collId){
        system.debug('collId future'+collId);
        Pagereference pr = Page.DWC_getSetOfFinalStatus;
        pr.getParameters().put('id',collId);
        
        String xmlContent='';
         if(!test.isrunningtest())xmlContent= pr.getContent().toString();
         else xmlContent='[POF,FD]';
         
        
        string str=xmlContent.replace('\n','').replace('[','').replace(']','').replaceAll(' ','');
        List<string> strList=str.split(',');
        set<string> setOfstatus=new set<string>();
        //for(string s:strList){
            setOfstatus.addAll(strList);
        //}
        system.debug(setOfstatus);
        system.debug('-----'+setOfstatus.contains('OPEN'));
        Wavier_Collaborator__c w=[SELECT Id,AcknowledgementMailSent__c,DRCServiceoption__c,isReleaseToCust4MultiDie__c,Is_All_PI_PW__c,PendingForFAEMail__c,Is_Sync_with_AIA__c,Is_releasedToCustomer__c,Waiver_Status__c,PTSR_Status__c,PTSR_Service_Type__c,Progressbar_staus__c FROM Wavier_Collaborator__c WHERE Id =:collId];
        if (setOfstatus.contains('OPEN') || setOfstatus.contains('FCD' ) ){
                    
                   // new Wavier_Collaborator__c(id=collId,Waiver_Status__c='Open');
                    if(w.PTSR_Service_Type__c.contains('DRC') ) {
                    if(w.DRCServiceoption__c <>Null && w.DRCServiceoption__c.toLowerCase() !='DRC Run Only') {
                    w.Waiver_Status__c='Open';
                     }
                    } else w.Waiver_Status__c='Open';
                    w.Is_All_PI_PW__c=false;
                    DfmUtilityCls.stopTrigger=true;
                    update w;
                }else{
                    prepareRuleMatrix(setOfstatus,collId);
                    
                }
        
        
    }
    
    // This function will help to calculate aggregare and final status of DWC
    private void getAllRules (Set<Id> waiverIds) {
        List<id> idList=new List<id>();
        idList.addAll(waiverIds);
        getStatusData(string.valueof(idList[0]));
        
        
    }
    // Prepare rule map 
    private static void prepareRuleMatrix(Set<String> setOfFinalStatus,string collabid) {
        
        List<Wavier_Collaborator__c> lst_DwcRecords = [SELECT Id,AcknowledgementMailSent__c,DRCServiceoption__c,isReleaseToCust4MultiDie__c,PendingForFAEMail__c,Is_Sync_with_AIA__c,Is_releasedToCustomer__c,Waiver_Status__c,PTSR_Status__c,PTSR_Service_Type__c,Progressbar_staus__c FROM Wavier_Collaborator__c WHERE Id =:collabid];
        
        
        if (lst_DwcRecords <>NULL && !lst_DwcRecords.isEmpty() && lst_DwcRecords.get(0).Is_Sync_with_AIA__c) {
            
            for (Wavier_Collaborator__c wcRecord : lst_DwcRecords) {
                if(wcRecord.PTSR_Service_Type__c.toUpperCase().contains('DRC') && !wcRecord.Is_releasedToCustomer__c &&!wcRecord.PendingForFAEMail__c && wcRecord.isReleaseToCust4MultiDie__c){
                    DRCEmailImplementation.drcReleaseReportToCustomer(wcRecord.Id);
                    DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=wcRecord.id,PendingForFAEMail__c=true)));
                }
              
                
                if(setOfFinalStatus.size()>0 )setFinalStatus(setOfFinalStatus,collabid);
                  
               
            } // end of outer for loop
        } // end of first if statement
    } // End of prepareRuleMap
    
    
    
     // Verify all status and set final status 
    public static void setFinalStatus(Set<String> setOfFinalStatus,string collabid) {
        Wavier_Collaborator__c collaborator=[select id,Waiver_Status__c,Progressbar_staus__c,DRCServiceoption__c,Is_releasedToCustomer__c,PTSR_Status__c,Is_All_PI_PW__c,isSubmitted__c from Wavier_Collaborator__c where id=:collabid limit 1];
        collaborator.Is_All_PI_PW__c=false;
        if (setOfFinalStatus.contains('FD') || setOfFinalStatus.contains('IFD')){
            System.debug('Set Final Status');
            collaborator.Waiver_Status__c = 'FD';
            collaborator.PTSR_Status__c = 'Closed';
            collaborator.Progressbar_staus__c='Closed';
        } 
        else if (setOfFinalStatus.contains('FCF')) {
            collaborator.Waiver_Status__c = 'FCF';
            if(collaborator.Is_releasedToCustomer__c){
            collaborator.PTSR_Status__c = 'Closed';
            collaborator.Progressbar_staus__c='Closed';
            }else{
            collaborator.Is_All_PI_PW__c=true;  
            }
        } 
        else if (setOfFinalStatus.contains('WCR')) {
           
            collaborator.Waiver_Status__c = 'WCR';
            if(collaborator.Is_releasedToCustomer__c){
            collaborator.PTSR_Status__c = 'Closed';
            collaborator.Progressbar_staus__c='Closed';
            }else{
            collaborator.Is_All_PI_PW__c=true;
            collaborator.Progressbar_staus__c='Closed';  
            }
        }
        else if (setOfFinalStatus.contains('WEA')) { 
           if(collaborator.Is_releasedToCustomer__c){
             collaborator.PTSR_Status__c = 'Closed';
             collaborator.Progressbar_staus__c='Closed';
           }else{
            collaborator.Is_All_PI_PW__c=true;
            //collaborator.Progressbar_staus__c='Pending For FAE'; 
            }
             collaborator.Waiver_Status__c = 'WEA';
           
        }
        else if (setOfFinalStatus.contains('PW')) {
            collaborator.Waiver_Status__c = 'PW';            
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PI')) {
            collaborator.Waiver_Status__c = 'PI';
            collaborator.Is_All_PI_PW__c=true;
        } 
        else if (setOfFinalStatus.contains('PA')) {
            collaborator.Waiver_Status__c = 'PA';
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PWA')) {
            collaborator.Waiver_Status__c = 'PWA';
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PWO')) {
            collaborator.Waiver_Status__c = 'pWO';
            collaborator.PTSR_Status__c = 'Closed';
            collaborator.Progressbar_staus__c='Closed';
        }
        else if (setOfFinalStatus.contains('POC')) {
            collaborator.Waiver_Status__c = 'pOC';
            collaborator.PTSR_Status__c = 'Closed';
            collaborator.Progressbar_staus__c='Closed';
        }
        else if (setOfFinalStatus.contains('POF')) {
            collaborator.Waiver_Status__c = 'POF';
            collaborator.Is_All_PI_PW__c=true;
        }
        if(!collaborator.Is_All_PI_PW__c){
        collaborator.isSubmitted__c=true;
        }
        DfmUtilityCls.stopTrigger=false;
        try{
        update collaborator;
        }
    
        
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRC_DrcRuleInfoTriggerHandler', 'setFinalStatus()', String.valueOf(collaborator.Id), 'DRC rule information', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }   
        
    }
    
    // Verify all status and set final status 
    public void setFinalStatus(Set<String> setOfFinalStatus,Wavier_Collaborator__c collaborator) {
        if (setOfFinalStatus.contains('FD') || setOfFinalStatus.contains('IFD')){
            System.debug('Set Final Status');
            collaborator.Waiver_Status__c = 'FD';
            collaborator.PTSR_Status__c = 'Closed';
        } 
        else if (setOfFinalStatus.contains('FCF')) {
            collaborator.Waiver_Status__c = 'FCF';
            if(collaborator.Is_releasedToCustomer__c){
            collaborator.PTSR_Status__c = 'Closed';
            }else{
            collaborator.Is_All_PI_PW__c=true;  
            }
        } 
        else if (setOfFinalStatus.contains('WCR')) {
           
            collaborator.Waiver_Status__c = 'WCR';
            if(collaborator.Is_releasedToCustomer__c){
            collaborator.PTSR_Status__c = 'Closed';
            }else{
            collaborator.Is_All_PI_PW__c=true;  
            }
        }
        else if (setOfFinalStatus.contains('WEA')) { 
           if(collaborator.Is_releasedToCustomer__c){
             collaborator.PTSR_Status__c = 'Closed';
           }else{
            collaborator.Is_All_PI_PW__c=true;  
            }
             collaborator.Waiver_Status__c = 'WEA';
           
        }
        else if (setOfFinalStatus.contains('PW')) {
            collaborator.Waiver_Status__c = 'PW';            
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PI')) {
            collaborator.Waiver_Status__c = 'PI';
            collaborator.Is_All_PI_PW__c=true;
        } 
        else if (setOfFinalStatus.contains('PA')) {
            collaborator.Waiver_Status__c = 'PA';
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PWA')) {
            collaborator.Waiver_Status__c = 'PWA';
            collaborator.Is_All_PI_PW__c=true;
        }
        else if (setOfFinalStatus.contains('PWO')) {
            collaborator.Waiver_Status__c = 'pWO';
            collaborator.PTSR_Status__c = 'Closed';
        }
        else if (setOfFinalStatus.contains('POC')) {
            collaborator.Waiver_Status__c = 'pOC';
            collaborator.PTSR_Status__c = 'Closed';
        }
        else if (setOfFinalStatus.contains('POF')) {
            collaborator.Waiver_Status__c = 'POF';
            collaborator.Is_All_PI_PW__c=true;
        }
        if(!collaborator.Is_All_PI_PW__c){
        collaborator.isSubmitted__c=true;
        }
        DfmUtilityCls.stopTrigger=false;
        try{
        update collaborator;
        }
    
        
        catch (Exception e) {
              GlobalUtility.logMessage('Debug', 'DRC_DrcRuleInfoTriggerHandler', 'setFinalStatus()', String.valueOf(collaborator.Id), 'DRC rule information', 'this is error message', 'payLoad','Other SFDC',e, 2300);
                  
              }   
        
    }
    
}