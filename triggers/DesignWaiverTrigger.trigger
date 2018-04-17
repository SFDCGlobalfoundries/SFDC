/*
* @ Author :- Navneet Rajput
* @ Description :- 
* @ Date :-
* @ Change History :- Adding the code for DRC - 18032016 - Abhita 
					  Adding the code for Email notification - 18012017 - SUHAS  
					  Added condition in if statement to skip trigger execution for integration user - 04052017 - SUHAS 
**/

trigger DesignWaiverTrigger on Wavier_Collaborator__c (after update) {
      list<Wavier_Collaborator__c > WaiverList=new list<Wavier_Collaborator__c>();
    
    if(!DfmUtilityCls.stopTrigger){
        
        List<Wavier_Collaborator__c> lstOfWaiverCollaborator = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfRejectedWaiverReport = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfFinalRejectionWaiverReports = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> listOfFinalApprovalReport = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfDRCWaiverCollaborator = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfDrcClosureReport = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfDrcAutoClosureReport = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfDrcCancellationReport = new List<Wavier_Collaborator__c>();
        List<Wavier_Collaborator__c> lstOfDrcRevertReport = new List<Wavier_Collaborator__c>();
        
        // avoid execution of trigger in when same object update in future context
        //if (!System.isFuture()){
            if (Trigger.isAfter && Trigger.isUpdate){
                if (!System.isFuture()){
                    for (Wavier_Collaborator__c waiver : Trigger.new){
                    
                    
                    //if (waiver.Waiver_Status__c == 'Approved' && Trigger.oldMap.get(waiver.Id).Waiver_Status__c!='Approved')
                        if(waiver.PTSR_Service_Type__c<>NULL && waiver.PTSR_Service_Type__c.contains('DFM')){
                            if (waiver.Waiver_Status__c == 'Approved' && Trigger.oldMap.get(waiver.Id).Waiver_Status__c!='Approved' 
                                && waiver.PTSR_Status__c=='Closed'){                           
                                lstOfWaiverCollaborator.add(waiver);   
                             
                            }else if (waiver.DFM_Design_Type__c <> null && waiver.DFMServiceOption__c <>null && waiver.Waiver_Status__c != 'Approved' &&
                               (!waiver.isAllPartyApproved__c) &&  waiver.DFMServiceOption__c.toLowerCase()!='waiver request'){                               
                                lstOfRejectedWaiverReport.add(waiver);
                            }                    
                            
                        }
                    }
                }
                // For DRC Application
				Wavier_Collaborator__c Coll =trigger.new[0];
                List<Waiver_Rule_List__c>  Wlist=[select id, Rule_Type__c from Waiver_Rule_List__c  where Waiver_Collaborator__c =: Coll.id AND Rule_Type__c =:'' limit 10];
                List<Waiver_Rule_List__c>  Wlist1=[select id, Rule_Type__c from Waiver_Rule_List__c  where Waiver_Collaborator__c =: Coll.id AND Rule_Type__c !='' limit 1];
                system.debug('test@@@'+Wlist);
                for (Wavier_Collaborator__c waiver : Trigger.new){
                    if(waiver.PTSR_Service_Type__c<>NULL ){
                    
                         system.debug('waiver.Progressbar_staus__c'+waiver.Progressbar_staus__c+'isreleasedtocustomer'+waiver.Is_releasedToCustomer__c );
                          
                    if(waiver.Progressbar_staus__c<>null && waiver.Progressbar_staus__c.trim().toLowerCase()=='Review_Disposition' && !waiver.ReviewSummaryMail__c ){
                    
                              DFMEmailImplementation.DFMReviewSummaryNotificationL3L4(waiver);
                              DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,ReviewSummaryMail__c=true)));
                        }  
                        
                        
                      if(Wlist1.size()<>null && Wlist1.size() !=0 && !waiver.Is_releasedToCustomer__c &&!waiver.PendingForFAEMail__c && waiver.isReleaseToCust4MultiDie__c ){
                             DFMEmailImplementation.DFMReviewSummaryNotificationL3L4(waiver);
                             DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,PendingForFAEMail__c=true)));
                       }
                                      
                        if(waiver.Is_Sync_with_AIA__c && !Trigger.oldMap.get(waiver.Id).Is_Sync_with_AIA__c){// && !Trigger.oldMap.get(waiver.Id).Is_Sync_with_AIA__c) //need to add more conditions based on final scenario                       
                            lstOfDRCWaiverCollaborator.add(waiver);
                        } 
                        system.debug('Wlist1'+Wlist1.size());                   
                        if (waiver.PTSR_Status__c == 'Closed' && (waiver.PTSR_Status__c != Trigger.oldMap.get(waiver.Id).PTSR_Status__c) && Wlist1.size() !=0) {
                            system.debug(' DRC closed  ###########' +waiver);
                            lstOfDrcClosureReport.add(waiver);
                        }
                        if (waiver.PTSR_Status__c == 'Closed' && waiver.isReleaseToCust4MultiDie__c && !waiver.CollaboratorClosedMail__c &&waiver.PTSR_Service_Type__c.toUppercase().contains('DFM') && Wlist1.size() ==0) {
                            system.debug(' DRC closed  ###########' +waiver);
                            lstOfDrcAutoClosureReport.add(waiver);
                            DFMEmailImplementation.DFMJobClosureNotification(waiver);
                            DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,CollaboratorClosedMail__c=true)));
                            
                        } 
                        if (waiver.PTSR_Status__c == 'Cancel' && (waiver.PTSR_Status__c != Trigger.oldMap.get(waiver.Id).PTSR_Status__c)){
                            lstOfDrcCancellationReport.add(waiver);
                        }
                        if (waiver.Revert_Collaborator__c){//SUHAS_Revert
                            lstOfDrcRevertReport.add(waiver);
                        }
                        system.debug('test'+waiver.isReleaseToCust4MultiDie__c);
                       
                        if(waiver.isReleaseToCust4MultiDie__c && waiver.PTSR_Service_Type__c.toUppercase().contains('DRC')){
                        system.debug('test@@@'+waiver.isReleaseToCust4MultiDie__c);
                        
                           //list<Waiver_Rule_List__c>  Wlist=[select id, Rule_Type__c from Waiver_Rule_List__c  where Waiver_Collaborator__c =:waiver.Id AND Rule_Type__c =:'' limit 10];
                           system.debug('Wlist>>>'+Wlist);
                            
                            if(Wlist.size()>0 && !waiver.isNonmatchmailsent__c) { 
                            
                            WaiverList.add(new Wavier_Collaborator__c(id=waiver.id,isNonmatchmailsent__c=true));
                            System.debug('isNonMatchMailSent inside'+waiver.isNonmatchmailsent__c);
                            DRCEmailImplementation.nonMatchingRulesForDRC(waiver.id);
                            }
                            
                         }
                         System.debug('outside >>'+waiver.isNonmatchmailsent__c);
                        if(waiver.Prime_Die__c!=null && waiver.Mask_Set_Title_ID__c!=null && DfmUtilityCls.initialExecution ){
                           
                            system.debug('Acknoledgement mail ********* '+waiver.PTSR_Service_Type__c);
                            if(waiver.PTSR_Service_Type__c.toUppercase().contains('DRC') && !waiver.AcknowledgementMailSent__c){
                                system.debug('Acknoledgement mail ######### ');
                                DRCEmailImplementation.collaboratorAcknowledgementForDRC(waiver.Id);
                                DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,AcknowledgementMailSent__c=true)));
                                
                            }else{
                                //L0 & S0 Mails
                                system.debug('waiver.AcknowledgementMailSent__c'+waiver.AcknowledgementMailSent__c+'Service options'+waiver.DFMServiceOption__c);
                                if (waiver.DFMServiceOption__c <>null && !waiver.AcknowledgementMailSent__c  && waiver.DFMServiceOption__c.trim().toLowerCase()=='waiver request'){
                                    system.debug('LONG FLOW MAIL TRIGGERED###### ');
                                    DFMEmailImplementation.collaboratorAcknowledgementForLongFlow(waiver.Id); 
                                    DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,AcknowledgementMailSent__c=true)));
                                    
                                }else if (waiver.DFMServiceOption__c <>null && !waiver.AcknowledgementMailSent__c){
                                    system.debug('SHORT FLOW MAIL TRIGGERED###### ');
                                    DFMEmailImplementation.collaboratorAcknowledgementForShortFlow(waiver.Id); 
                                    DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiver.id,AcknowledgementMailSent__c=true)));
                                     
                                }
                            }
                        DfmUtilityCls.initialExecution=false;
                        }
                    } 
                }
                update WaiverList;
                
                // handle Revert notification to mantis and ptsr systems
                if (lstOfDrcRevertReport<>NULL && !lstOfDrcRevertReport.isEmpty()){
                    WaivercollaboratorTriggerHandler.sendRevertNotificationToMantis(lstOfDrcRevertReport.get(0));
                }
                
                // handle cancellation notification to mantis and ptsr systems
                if (lstOfDrcCancellationReport<>NULL && !lstOfDrcCancellationReport.isEmpty()){
                    DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcCancellationReport.get(0).id,CollaboratorCancelledMail__c=true)));
                    WaivercollaboratorTriggerHandler.sendCancelNotificationToMantis(lstOfDrcCancellationReport.get(0));
                    WaivercollaboratorTriggerHandler.sendCancelNotificationToPTSR(lstOfDrcCancellationReport.get(0),
                                                                                 Trigger.oldMap.get(lstOfDrcCancellationReport.get(0).Id).PTSR_Status__c);
                    
                }
                
                if (lstOfWaiverCollaborator<>NULL && !lstOfWaiverCollaborator.isEmpty()){
                    WaivercollaboratorTriggerHandler.shareDFMReport(lstOfWaiverCollaborator,true); 
                }
                
                if (lstOfRejectedWaiverReport<>NULL && !lstOfRejectedWaiverReport.isEmpty() && !test.isrunningtest()){
                    WaivercollaboratorTriggerHandler.shareDFMReport(lstOfRejectedWaiverReport,false);
                } 
               
                
                // for DRC Application
                if (lstOfDRCWaiverCollaborator<>NULL && !lstOfDRCWaiverCollaborator.isEmpty()){
                    WaivercollaboratorTriggerHandler.shareDRCReport(lstOfDRCWaiverCollaborator); 
                }
                
                if (lstOfDrcAutoClosureReport <>NULL && !lstOfDrcAutoClosureReport .isEmpty()){
                    WaivercollaboratorTriggerHandler.sendClosureNotificationToPTSR(lstOfDrcAutoClosureReport.get(0));
                }
                // Send closure notification to PTSR and Mantis
                if (lstOfDrcClosureReport<>NULL && !lstOfDrcClosureReport.isEmpty()) { 
                   /* DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
                    WaivercollaboratorTriggerHandler.sendClosureNotificationToMantis(lstOfDrcClosureReport.get(0));
                    system.debug('lstOfDrcClosureReport'+lstOfDrcClosureReport);
                    WaivercollaboratorTriggerHandler.sendClosureNotificationToPTSR(lstOfDrcClosureReport.get(0)); */
                    
                    Wavier_Collaborator__c waiverColl = lstOfDrcClosureReport.get(0);
                    //List<Waiver_Rule_List__c> waiverRuleList = DfmUtilityCls.getWaiverRuleList(waiverColl.Id);
                    //system.debug(' DRC closed  ###########' +waiverRuleList.size()+'>>>>details '+waiverRuleList);
                     
                    if(waiverColl.PTSR_Service_Type__c.toUpperCase().contains('DRC')){
                        if(waiverColl.Waiver_Status__c=='PI' ||waiverColl.Waiver_Status__c=='PA' || waiverColl.Waiver_Status__c=='PW' || waiverColl.Waiver_Status__c=='pWO' || waiverColl.Waiver_Status__c=='pOC'){
                            WaivercollaboratorTriggerHandler.shareDRCReportWithCustomers(waiverColl); 
                           /* DRCEmailImplementation.drcPIPWClosureNotification(waiverColl);
                            //DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorClosedMail__c=true)));
                        }else if(waiverColl.Waiver_Status__c=='FD' && !waiverColl.CollaboratorClosedMail__c){
                            DRCEmailImplementation.drcDesignRejectNotification(waiverColl);
                            DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorRejectionMail__c=true)));
                        }else if((waiverColl.Waiver_Status__c=='FCF' || waiverColl.Waiver_Status__c=='WCR') && !waiverColl.CollaboratorClosedMail__c){
                            DRCEmailImplementation.drcReviewSummaryNotification9a(waiverColl);
                            DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorClosedMail__c=true)));
                        }else if(waiverColl.Waiver_Status__c=='WEA'&& !waiverColl.CollaboratorClosedMail__c){
                            DRCEmailImplementation.drcReviewSummaryNotification9b(waiverColl);
                            DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorClosedMail__c=true))); */
                        } 
                    } else if(waiverColl.PTSR_Service_Type__c.toUpperCase().contains('DFM')){ 
                        system.debug('Test@@'+waiverColl.Waiver_Status__c);

                         if(waiverColl.Waiver_Status__c=='FD' && !waiverColl.CollaboratorClosedMail__c){
                              //L12: at least one rule is FinalWaiverStatus = (“FD”)
                              DFMEmailImplementation.DFMReviewSummaryNotification3(waiverColl);
                              DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorClosedMail__c=true)));      
                         } /* else if(waiverColl.Progressbar_staus__c=='Closed' && waiverColl.PTSR_Status__c =='Closed' && !waiverColl.CollaboratorClosedMail__c ) {
                             system.debug('Test'+waiverColl);
                             DFMEmailImplementation.DFMJobClosureNotification(waiverColl);
                             DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=waiverColl.id,CollaboratorClosedMail__c=true)));
                         } */
                         else if(waiverColl.Waiver_Status__c=='FCF'){
                             //L11  :Job is closed AND no rule is FinalWaiverlStatus = (FD)AND at least one rule is FinalWaiverStatus = (“FCF”)
                            // DFMEmailImplementation.DFMReviewSummaryNotification2(waiverColl);
                             //WaivercollaboratorTriggerHandler.sendClosureMailsForDFMInCaseFCF(waiverColl);
                         }else if(waiverColl.Waiver_Status__c=='WCR' || waiverColl.Waiver_Status__c=='WEA'){
                             //WaivercollaboratorTriggerHandler.sendClosureMailsForDFM(waiverColl);
                         }
                         
                         //L13: Job is cancelled
    
                    }             
                }
            }
        } 
}