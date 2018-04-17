/*
    Author: Anil Kumar
    Description: Batch class is used to send email notification 7 days before closing the reservation form.
    History: 
        Anil Kumar 12/29/2016 - Code creation.
        Mohan Venkates 4/26/2017 - Added more cc email fields
        //Kanishk Singh 06/01/2017
       //For To address: toEmails,CC_Address_1__c,CC_Address_2__c,CC_Address_3__c
       //For CC address: toEmails,CC_Address_4__c,CC_Address_5__c,CC_Address_6__c,CC_Address_7__c,CC_Address_8__c
*/ 
global class MPWReservationCloseReminderBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date dtTemp = Date.today().addDays(7); 
        String query = 'SELECT Id, Name, MPW_Train_No__c, Reservation_Close_Date__c, Geometry__c, CDRS_Submit_Date__c, Cancellation_Deadline__c, '; 
        query += 'GDSII_Cutoff_for_Dry_Run_DRC__c, Tapeout_Date_Other_Participant__c, Tapeout_Date_Customer__c, Projected_1st_Batch_Bare_Die_Ship__c, ';
        query += 'Projected_2nd_Batch_Bare_Die_Ship__c, Status__c, Publish__c, Train_Type__c ';
        query += 'FROM MPW_Train_Maintenance__c WHERE Active__c = TRUE AND Publish__c = TRUE AND Train_Type__c = \'GlobalShuttle\' ';
        query += 'AND Reservation_Close_Date__c != NULL AND DAY_ONLY(Reservation_Close_Date__c) =: dtTemp';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<MPW_Train_Maintenance__c> scope){
        if(scope.size() > 0){
            SendReminderEmail(scope); 
        } 
    }
    
    public void SendReminderEmail(List<MPW_Train_Maintenance__c> lstTrainMaintenance) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String toEmails = 'globalshuttle@globalfoundries.com';
        String ccemails = '';
        //String ccemails = 'dl.gf.Product_Marketing@globalfoundries.com;dl.SGP.TD_ALL@globalfoundries.com;dl.SGP.TD.Design_ServiceDivision_Singapore@globalfoundries.com;dl.SGP.QRA.Reliability@globalfoundries.com;custeng@globalfoundries.com;dl.SGP.TD.DEA_US@globalfoundries.com;dl.SGP.TD.DEA_SG@globalfoundries.com;dl.gf.wwSales_FAE@globalfoundries.com;dl.gf.wwsalesae_all@globalfoundries.com;dl.gf.wwfae_all@globalfoundries.com;dl.SGP.TD.Design_ServiceDivision@globalfoundries.com;gfopctdf@globalfoundries.com;td.tsd.tdti@globalfoundries.com;dl.gf.Technology_Foundations_Booleans@globalfoundries.com;JingMei.TAO@globalfoundries.com;dl.SGP.BD_GlobalShuttle@globalfoundries.com;dl.gf.wwsalesops_all@globalfoundries.com;dl.gf.ww_CSR@globalfoundries.com;dl.gf.wwsales_us_pp@globalfoundries.com;dl.gf.wwSales@globalfoundries.com';
       
       //Update by Venkat starts
       //Added CC_Address_5__c, CC_Address_6__c, CC_Address_7__c, CC_Address_8__c
       
       //Kanishk Singh
       //For To address: toEmails,CC_Address_1__c,CC_Address_2__c,CC_Address_3__c
       //For CC address: toEmails,CC_Address_4__c,CC_Address_5__c,CC_Address_6__c,CC_Address_7__c,CC_Address_8__c
       
        for(MPWReservationCloseReminder__c cs : [SELECT Id, Active__c, CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c, CC_Address_7__c, CC_Address_8__c, ToAddress__c 
                                                FROM MPWReservationCloseReminder__c WHERE Active__c = TRUE LIMIT 1]) {
            if((cs.ToAddress__c != null && cs.ToAddress__c.trim() != '') || (cs.CC_Address_1__c != null && cs.CC_Address_1__c.trim() != '') || (cs.CC_Address_2__c != null && cs.CC_Address_2__c.trim() != '') || (cs.CC_Address_3__c != null && cs.CC_Address_3__c.trim() != '')) {
                toEmails='';
                
                if(cs.ToAddress__c != null && cs.ToAddress__c.trim() != '') {
                    toEmails = cs.ToAddress__c.trim();
                }
                 
                if(cs.CC_Address_1__c != null && cs.CC_Address_1__c.trim() != '') {
                    toEmails += toEmails != '' ? ';' + cs.CC_Address_1__c.trim() : cs.CC_Address_1__c.trim();
                }
                
                if(cs.CC_Address_2__c != null && cs.CC_Address_2__c.trim() != '') {
                    toEmails += toEmails != '' ? ';' + cs.CC_Address_2__c.trim() : cs.CC_Address_2__c.trim();
                }
                
                if(cs.CC_Address_3__c != null && cs.CC_Address_3__c.trim() != '') {
                    toEmails += toEmails != '' ? ';' + cs.CC_Address_3__c.trim() : cs.CC_Address_3__c.trim();
                }
                 
            }
            if((cs.CC_Address_4__c != null && cs.CC_Address_4__c.trim() != '') || (cs.CC_Address_5__c != null && cs.CC_Address_5__c.trim() != '') || (cs.CC_Address_6__c != null && cs.CC_Address_6__c.trim() != '') || (cs.CC_Address_7__c != null && cs.CC_Address_7__c.trim() != '') || (cs.CC_Address_8__c != null && cs.CC_Address_8__c.trim() != '')) {
                ccemails = '';
                
                 if(cs.CC_Address_4__c != null && cs.CC_Address_4__c.trim() != '') {
                    ccemails = cs.CC_Address_4__c.trim();
                }
                
                if(cs.CC_Address_5__c != null && cs.CC_Address_5__c.trim() != '') {
                    ccemails += ccemails != '' ? ';' + cs.CC_Address_5__c.trim() : cs.CC_Address_5__c.trim();
                }
                if(cs.CC_Address_6__c != null && cs.CC_Address_6__c.trim() != '') {
                    ccemails += ccemails != '' ? ';' + cs.CC_Address_6__c.trim() : cs.CC_Address_6__c.trim();
                }
                if(cs.CC_Address_7__c != null && cs.CC_Address_7__c.trim() != '') {
                    ccemails += ccemails != '' ? ';' + cs.CC_Address_7__c.trim() : cs.CC_Address_7__c.trim();
                }
                if(cs.CC_Address_8__c != null && cs.CC_Address_8__c.trim() != '') {
                    ccemails += ccemails != '' ? ';' + cs.CC_Address_8__c.trim() : cs.CC_Address_8__c.trim();
                }
            }
        }
        //Update by Venkat Ends
        
        OrgWideEmailAddress[] owea = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        
        String emailSubject = '';
        String emailBody = '';
        String[] toAddresses =toEmails != null && toEmails.trim() != '' ? toEmails.split(';') : new String[]{};
        String[] ccAddresses = ccemails != null && ccemails.trim() != '' ? ccemails.split(';') : new String[]{};
            
        for(MPW_Train_Maintenance__c mpw : lstTrainMaintenance){
            String strMPW_Train_No = mpw.Name;
            String strGeometry = mpw.Geometry__c != null ? mpw.Geometry__c : '';
            
            String strReservation_Close_Date = mpw.Reservation_Close_Date__c != null ? formatDateTime(mpw.Reservation_Close_Date__c) : '';
            String strCDRS_Submit_Date = mpw.CDRS_Submit_Date__c != null ? formatDateTime(mpw.CDRS_Submit_Date__c) : '';
            String strCancellation_Deadline = mpw.Cancellation_Deadline__c != null ? formatDateTime(mpw.Cancellation_Deadline__c) : '';
            String strGDSII_Cutoff_for_Dry_Run_DRC = mpw.GDSII_Cutoff_for_Dry_Run_DRC__c != null ? formatDateTime(mpw.GDSII_Cutoff_for_Dry_Run_DRC__c) : '';
            String strTapeout_Date_Other_Participant = mpw.Tapeout_Date_Other_Participant__c != null ? formatDateTime(mpw.Tapeout_Date_Other_Participant__c) : '';
            String strTapeout_Date_Customer = mpw.Tapeout_Date_Customer__c != null ? formatDateTime(mpw.Tapeout_Date_Customer__c) : '';
            
            String strProjected_1st_Batch_Bare_Die_Ship = mpw.Projected_1st_Batch_Bare_Die_Ship__c != null ? mpw.Projected_1st_Batch_Bare_Die_Ship__c : '';
            String strProjected_2nd_Batch_Bare_Die_Ship = mpw.Projected_2nd_Batch_Bare_Die_Ship__c != null ? mpw.Projected_2nd_Batch_Bare_Die_Ship__c : '';
            String strStatus = mpw.Status__c != null ? mpw.Status__c : '';
                        
            emailSubject = 'Reservation for ' + strMPW_Train_No + ' will be closed on ' + strReservation_Close_Date;
            emailBody = 'Hi,<br/><br/>Reservation for ' + strMPW_Train_No + ' will be closed on ' + strReservation_Close_Date + '.<br/><br/>';
            emailBody += '<table border="1" style="border-collapse:collapse;"><thead style="background-color:lightgray;"><tr><th style="padding:5px;">MPW#</th><th style="padding:5px;">Geometry</th><th style="padding:5px;">Reservation Close Date</th><th style="padding:5px;">CDRS Submit Date</th><th style="padding:5px;">Cancellation Deadline</th><th style="padding:5px;">Dry Run DRC Cut Off</th><th style="padding:5px;">Other Participants Tapeout Date</th><th style="padding:5px;">Customer Tapeout Date</th><th style="padding:5px;">Projected 1st Batch Bare Die Ship</th><th style="padding:5px;">Projected 2nd Batch Bare Die Ship</th><th style="padding:5px;">Process Offering</th></tr></thead><tbody>';
            emailBody += '<tr><td style="padding:5px;">' + strMPW_Train_No + '</td><td style="padding:5px;">' + strGeometry + '</td><td style="padding:5px;">' + strReservation_Close_Date + '</td><td style="padding:5px;">' + strCDRS_Submit_Date + '</td><td style="padding:5px;">' + strCancellation_Deadline + '</td><td style="padding:5px;">' + strGDSII_Cutoff_for_Dry_Run_DRC + '</td><td style="padding:5px;">' + strTapeout_Date_Other_Participant + '</td><td style="padding:5px;">' + strTapeout_Date_Customer + '</td><td style="padding:5px;">' + strProjected_1st_Batch_Bare_Die_Ship + '</td><td style="padding:5px;">' + strProjected_2nd_Batch_Bare_Die_Ship + '</td><td style="padding:5px;">' + strStatus + '</td></tr>';
            emailBody += '</tbody></table><br/><br/>Please submit your reservation if you are interested in participating.<br/><br/>';
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(toAddresses);
            if(ccAddresses.size() > 0) {
               mail.setCcAddresses(ccAddresses);
            }
            mail.setSubject(emailSubject);
            mail.setHtmlBody(emailBody);
            mails.add(mail);
        }
       
        Messaging.sendEmail(mails);
    }
    
    public String formatDateTime(DateTime pDT) {
        String temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');    
        DateTime pstTime = DateTime.valueOf(temp);
        long timeDiff = pstTime.getTime() - pDT.getTime();
        Integer seconds = Integer.valueOf(timeDiff/1000);
        pDT = pDT.addSeconds(seconds);
        return pDT.month() + '/' + pDT.day() + '/' + pDT.year();
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}