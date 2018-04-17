/*
Type Name: UnauthorizedDeniedPartyBatch
Author: JK Technosoft
Created Date: 12-08-2016
Reason: UnauthorizedDeniedPartyBatch used to excute logic to find unauthorized records from LEAD,ACCOUNT,DEVICE
……..
……..
*/
global class DeniedPart_UnauthorizedDeniedPartyBatch implements Database.Batchable<SObject>,Schedulable {
       
        global Database.QueryLocator start(Database.BatchableContext bcMain) {
            String DPLRecords = 'SELECT id,COMPANY_NAME__c FROM Denied_Party_List__c';
            return Database.getQueryLocator(DPLRecords);
        }
        
        global void execute(Database.BatchableContext bcMain, List<Denied_Party_List__c> DPLRecords) {
           DeniedPartyListHelperClass.DeniedPartyList(DPLRecords);                                                                    
        }
        
        global void finish(Database.BatchableContext bcMain) {
        }
        //Scedulable Batch Class
        global void execute(SchedulableContext scMain) {
            if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
                DeniedPart_UnauthorizedDeniedPartyBatch dpl = New DeniedPart_UnauthorizedDeniedPartyBatch();
                DataBase.ExecuteBatch(dpl,1);
            } 
        }
    }