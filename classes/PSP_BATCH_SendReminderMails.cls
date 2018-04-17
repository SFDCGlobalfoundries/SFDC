/**
* Description   :   Batch class for sending reminder mails for PSP to AM and CE.                 
* History       :   

        Initials        Date              Description
----------------------------------------------------------------------------
        DBiswal       05022016        Created the Class.
        
**/

global class PSP_BATCH_SendReminderMails implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String soqlQuery = 'SELECT Id, Name, Account__c, Account__r.Name,PSP_to_be_Locked_by_Date__c,TapeOut_AM__c,Primary_Device_AM__c,Account__r.Account_Manager__c,'+
                           'CE_assigned_for_PSP__c,Proto_Wafer_First_Lot_Start_Date__c,Product_TO_Date__c,Proto_Wafer_Fab_Shipped_Date__c,Forecasted_Proto_Date__c,' + 
                           'Respin_Date__c,Forecasted_RTP_Date__c,Risk_Wafer_Shipped_Date__c,End_Customer_Qual_Complete_Date__c,Forecasted_Production_Start_Date__c,Product_TO_Current__c,'+
                           'Proto_Wafer_First_Lot_Start_Current__c,Proto_Wafer_Fab_Shipped_Current__c,Assembled_Tested_Part_Shipped_Current__c,Respin_Impact_to_Schedule_Current__c,' +
                           'Risk_Wafer_Start_Current__c,Risk_Wafer_Shipped_Current__c,End_Customer_Qual_Complete_Current__c,Production_Wafer_Start_Current__c ' + ' FROM Device__c ';
        String whereCond = ' WHERE PSP_to_be_Locked_by_Date__c = TODAY AND Proto_Wafer_First_Lot_Start_Current__c!=null AND Proto_Wafer_Fab_Shipped_Current__c!=null AND '+ 
                           'Assembled_Tested_Part_Shipped_Current__c!=null AND Respin_Impact_to_Schedule_Current__c!=null AND Risk_Wafer_Start_Current__c!=null AND Risk_Wafer_Shipped_Current__c!=null AND '+
                           'End_Customer_Qual_Complete_Current__c!=null AND Production_Wafer_Start_Current__c!=null AND Product_TO_Current__c!=null AND PSP_Dates_Locked__c = FALSE';
        soqlQuery = soqlQuery + whereCond;
        return Database.getQueryLocator(soqlQuery);
    }
    
    global void execute(SchedulableContext SC){
        PSP_BATCH_SendReminderMails pspReminder = new PSP_BATCH_SendReminderMails();
        database.executebatch(pspReminder);        
    }
    
    global void execute(Database.BatchableContext BC, List<Device__c> scope){
        List<Device__c> devList = new List<Device__c>();
        List<Device__c> devPORtoupdateList = new List<Device__c>();
        for(Device__c dev : scope){
            if(dev.PSP_to_be_Locked_by_Date__c == Date.today()){
                devList.add(dev);
            }
        }
        
        if(devList.size() > 0){
            for(Device__c dev : devList){
                dev.Proto_Wafer_First_Lot_Start_Date__c = dev.Proto_Wafer_First_Lot_Start_Current__c;
                dev.Product_TO_Date__c = dev.Product_TO_Current__c;
                dev.Proto_Wafer_Fab_Shipped_Date__c = dev.Proto_Wafer_Fab_Shipped_Current__c;
                dev.Forecasted_Proto_Date__c = dev.Assembled_Tested_Part_Shipped_Current__c;
                dev.Respin_Date__c = dev.Respin_Impact_to_Schedule_Current__c;
                dev.Forecasted_RTP_Date__c = dev.Risk_Wafer_Start_Current__c;
                dev.Risk_Wafer_Shipped_Date__c = dev.Risk_Wafer_Shipped_Current__c;
                dev.End_Customer_Qual_Complete_Date__c = dev.End_Customer_Qual_Complete_Current__c;
                dev.Forecasted_Production_Start_Date__c = dev.Production_Wafer_Start_Current__c;
                dev.PSP_Dates_Locked__c = true;
                devPORtoupdateList.add(dev);
            }
        }
        
        if(devPORtoupdateList.size() > 0){
            Database.update(devPORtoupdateList);
        }
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}