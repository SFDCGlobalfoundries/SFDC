/*  Author: Gandhapumohan
    Company: GLOBALFOUNDRIES
    Project: DRC Application
    Description: This is helper class for the DWC_CollaboratorCtrl
    History:  
**/

public without sharing class DWC_Primediestatus {

    public void init() {
        string waiverid=apexpages.currentpage().getparameters().get('waiverid');
        system.debug('waiverid@@@@@'+waiverid);
        //Wavier_Collaborator__c wc = (Wavier_Collaborator__c)JSON.deserialize(JSON.Serialize([select id from Wavier_Collaborator__c limit 1]),Wavier_Collaborator__c.class);
        
        string ruleList =apexpages.currentpage().getparameters().get('ruleList');
        list<Chip__c> chip = (list<Chip__c>)JSON.deserialize(ruleList , list<Chip__c>.class);
        update chip;
        
        list<Wavier_Collaborator__c> lstOfDrcClosureReport = [select Account_Manager_Approver1__c,FAB__c,DRCServiceoption__c,Workflow_Status__c,Mask_Set_Title__c,Waiver_Status__c,CollaboratorClosedMail__c,isSubmitted__c,MantisIds__c,PTSR_Number__c,Is_All_PI_PW__c,Cancellation_Reason__c,Revert_Collaborator__c,Revert_Reason__c,Revert_Stage__c,Account_Manager_Approver2__c,Account_Manager_Approver3__c,Account_Manager__c,Account_Name__c,Account_Short_Name__c,
                                                              Approval_Field_Engineer__c,CreatedById,CreatedDate,Customer_Full_Name__c,DRB_Group_uIds__c,Selected_Customers__c,Tapeout_Layers__c,isCustomerSelectionSubmitted__c,CRMDID__c,D1_National__C,PTSR_ID__c,LastRuleSelected_GFRisk__c,isMulti__c ,DFM_Transaction_Id__c ,
                                                              isReleaseToCust4MultiDie__c ,LastRuleSelected_Customer__c,File_Name__c,File_Size__c,Is_Submit_4_DFM_Apprval__c ,      
                                                              Id,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,Is_releasedToCustomer__c,Device_Name__c, PTSR_Status__c,Mantis_DRCPLUS__c,Mantis_MAS__c,Mantis_MCD__c,CMP__c,PDK_DRC__c,
                                                              LastActivityDate,Name,LastModifiedById,PTSR_Service_Type__c,Created_By_Shortname__c,Submitted_By_Shortname__c,LastModifiedDate,LastReferencedDate,LastViewedDate,MantisId__c,Prime_Die_Name__c FROM Wavier_Collaborator__c where id=:waiverid limit 1];
        
        List<Waiver_Rule_List__c>  ruleListCount=[select id, Rule_Type__c from Waiver_Rule_List__c  where Waiver_Collaborator__c =: lstOfDrcClosureReport.get(0).id AND Rule_Type__c !='' limit 1];
        system.debug('sent@@ '+lstOfDrcClosureReport.get(0).CollaboratorClosedMail__c+'ruleListCount'+ruleListCount);
        
        if(lstOfDrcClosureReport.get(0).PTSR_Status__c == 'Closed' && ruleListCount.size() !=0 && !lstOfDrcClosureReport.get(0).CollaboratorClosedMail__c) {
        
        WaivercollaboratorTriggerHandler.sendClosureNotificationToMantis(lstOfDrcClosureReport.get(0));
        
        WaivercollaboratorTriggerHandler.sendClosureNotificationToPTSR(lstOfDrcClosureReport.get(0));
        system.debug('Ptsr service type@@'+lstOfDrcClosureReport.get(0).PTSR_Service_Type__c);
        
        if(lstOfDrcClosureReport.get(0).PTSR_Service_Type__c.toUpperCase().contains('DRC') ) { 
                if(lstOfDrcClosureReport.get(0).Waiver_Status__c=='PI' ||lstOfDrcClosureReport.get(0).Waiver_Status__c=='PA' || lstOfDrcClosureReport.get(0).Waiver_Status__c=='PW' || lstOfDrcClosureReport.get(0).Waiver_Status__c=='pWO' || lstOfDrcClosureReport.get(0).Waiver_Status__c=='pOC') { 
                     DRCEmailImplementation.drcPIPWClosureNotification(lstOfDrcClosureReport.get(0));
                     DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
                     system.debug('email sent');
                   } else if(lstOfDrcClosureReport.get(0).Waiver_Status__c=='FD' && !lstOfDrcClosureReport.get(0).CollaboratorClosedMail__c){
                     DRCEmailImplementation.drcDesignRejectNotification(lstOfDrcClosureReport.get(0));
                     DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
                   }else if(lstOfDrcClosureReport.get(0).Waiver_Status__c=='FCF' || lstOfDrcClosureReport.get(0).Waiver_Status__c=='WCR' && !lstOfDrcClosureReport.get(0).CollaboratorClosedMail__c){
                         DRCEmailImplementation.drcReviewSummaryNotification9a(lstOfDrcClosureReport.get(0));
                         DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
                   }else if(lstOfDrcClosureReport.get(0).Waiver_Status__c=='WEA'&& !lstOfDrcClosureReport.get(0).CollaboratorClosedMail__c){
                         DRCEmailImplementation.drcReviewSummaryNotification9b(lstOfDrcClosureReport.get(0));
                         DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
                   }
            
        }else if(lstOfDrcClosureReport.get(0).PTSR_Service_Type__c.toUpperCase().contains('DFM')) {
               DFMEmailImplementation.DFMJobClosureNotification(lstOfDrcClosureReport.get(0));
               DfmUtilityCls.updateCollaborator(JSON.serialize(new Wavier_Collaborator__c(id=lstOfDrcClosureReport.get(0).id,CollaboratorClosedMail__c=true)));
         }
        
        }
        //return null;
    }

}