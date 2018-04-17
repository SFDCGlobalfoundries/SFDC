/*
* @ Author :- SUHAS BARGI
* @ Description :- 
* @ Template 4 DRC: reminder mail, scheduled batch - Collaborator status is “Pending Customer/ Foundry” for >2days. THEN IF Release Report pending for every 24hrs until closed
* @ Template L6 DFM - Reminder for: Response Required for DFM Review Report is pending > 2 days. 
* @ Date :- 15 MARCH 2016
* @ Change History :-  Mohan 11 Jan 2017
**/
global class DRCReminderResponseRequiredBatch implements Database.Batchable<sObject>,Database.stateful {
    
   
   global String Waivercoll;
   global string ObjectName;
   global date previousDate ;
   global date colpreviousdate;
   global DRCReminderResponseRequiredBatch(string Waivercoll , string ObjectName) {
       
       this.Waivercoll=Waivercoll;
       this.ObjectName=ObjectName;
       String DWC_AutoCloseAfter= EnvironmentVariable.get('DWC_AutoCloseAfter');
       DWC_AutoCloseAfter=(DWC_AutoCloseAfter!=null)?DWC_AutoCloseAfter:'30';
       previousDate = date.Today().addDays(-2);
       colpreviousdate=date.Today().addDays(-integer.valueof(DWC_AutoCloseAfter));
        
   } 
    
   
    Set<Id> alreadySentSet= new Set<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC){  
        
       
        
       system.debug('Object name '+ObjectName);
       system.debug('Waivercoll## '+Waivercoll);
       
       
        //LastModifiedDate <= : previousDate AND
        return Database.getQueryLocator(Waivercoll);       
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> objList){
        
        
        Set<Id> setOfWaiverCollaboratorIdsForTemplate4DRC= new Set<Id>(); 
        Set<Id> setOfWaiverCollaboratorIdsForTemplate6DFM= new Set<Id>();
        list<Wavier_Collaborator__c> wclist=new list<Wavier_Collaborator__c>();
        list<Wavier_Collaborator__c> waiver=new list<Wavier_Collaborator__c>();
       
        system.debug('Object@@@@@@ '+objList);
        
        if (objList<>NULL && !objList.isEmpty()  ){
            if(ObjectName=='Wavier_Collaborator__c'){
            system.debug('Object name '+ObjectName);
           for(sObject wc :objList){
             Wavier_Collaborator__c WColl=(Wavier_Collaborator__c)wc;
               if(!WColl.CollaboratorClosedMail__c && WColl.isReleaseToCust4MultiDie__c) {
               WColl.Waiver_Status__c='DRC Run Only - No Review ';
               WColl.PTSR_Status__c='Closed';
               WColl.Progressbar_staus__c='Closed';
               wclist.add(WColl);
               }
                                    
          }                            
            if(wclist.size()>0)update wclist;
            
            for(Wavier_Collaborator__c waiverColl :wclist){
                    
                    WaivercollaboratorTriggerHandler.sendClosureNotificationToMantis(waiverColl);
                    //system.debug('waiverColl@'+waiverColl);
                    WaivercollaboratorTriggerHandler.sendClosureNotificationToPTSR(waiverColl);
                    DFMEmailImplementation.DFMReviewSummaryNotificationL3L4(waiverColl);
                    waiverColl.CollaboratorClosedMail__c=true;
                    waiver.add(waiverColl);
              }
              DfmUtilityCls.stopTrigger=true; 
              update waiver; 
            
        } else {
            
            for (sObject so : objList){
                Waiver_Rule_List__c Wlist= (Waiver_Rule_List__c)so;
               
                String ptsrType = '';
                if(Test.isRunningTest()){
                    ptsrType = 'DFM Service Request';
                }else{
                    ptsrType = Wlist.Waiver_Collaborator__r.PTSR_Service_Type__c;
                }
                
                if(ptsrType.contains('DRC')) {
                    setOfWaiverCollaboratorIdsForTemplate4DRC.add(Wlist.Waiver_Collaborator__c);
                     
                }else{
                    setOfWaiverCollaboratorIdsForTemplate6DFM.add(Wlist.Waiver_Collaborator__c); 
                   
                    
                }
            }
            if(!setOfWaiverCollaboratorIdsForTemplate4DRC.isEmpty()){
                for(Id collaboratorId : setOfWaiverCollaboratorIdsForTemplate4DRC){ 
                    if(!alreadySentSet.contains(collaboratorId)){
                    	DRCEmailImplementation.drcReminderResponseRequiredReport(collaboratorId);
                    	alreadySentSet.add(collaboratorId);  
                    }
                }
            }else if(!setOfWaiverCollaboratorIdsForTemplate6DFM.isEmpty()){
                for(Id collaboratorId : setOfWaiverCollaboratorIdsForTemplate6DFM){
                	if(!alreadySentSet.contains(collaboratorId)){
                    	DFMEmailImplementation.ReminderResponseRequired4DFMReviewReport(collaboratorId);
                    	alreadySentSet.add(collaboratorId);  
                    }  
                }
            }
          }
        }
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}