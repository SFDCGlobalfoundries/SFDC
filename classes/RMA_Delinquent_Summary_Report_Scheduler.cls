global class RMA_Delinquent_Summary_Report_Scheduler implements Schedulable {
    
    global void execute(SchedulableContext SC){
        List<AggregateResult> rmaList = new List<AggregateResult>();
        List<String> toList = new List<String>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owa = [select Address,DisplayName from OrgWideEmailAddress where DisplayName = 'Salesforce, Noreply' limit 1];
        
        rmaList = database.query(queryBuilder());
        if(!rmaList.isEmpty()){
            for(AggregateResult rma: rmaList){
                toList.add(String.valueOf(rma.get('OwnerEmail')));
            }
            
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            singleMail.setReplyTo(owa.Address);
            singleMail.setSenderDisplayName(owa.DisplayName);
            singleMail.setToAddresses(toList);  
            singleMail.saveAsActivity = false;  
            singleMail.setSubject('Summary Report for Delinquent RMA Cycletime - '+DateTime.now());
            String body = 'Attention : RMA Originator(s)/CSR(s)';
            body += '<br/>';
            body += '<br/>';
            body += 'RMAs are <b>overdue for response</b>. ';
            body += 'Please <b>take necessary action</b> and <b>follow up</b> to <b>clear</b> them <b>immediately</b>.';
            body += '<br/>';
            body += '<br/>';
            body += 'Please click <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RMA_Delinquent_Summary_Report?sfdc.tabName='+System.Label.RMA_Delinquent_Summary_Report_Tab_Id+'">'+'<b>here</b></a> to access <b>RMA Delinquent Summary Report</b>.';
            body += '<br/>';
            body += '<br/>';
            body += 'RMA escalation email will continue until actions are taken to clear delinquent RMAs.';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank You.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);
        }
        
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
            
    }
    
    public String queryBuilder(){
        
        String query = '';
        query = 'SELECT OwnerId, Owner.Email OwnerEmail from RMA__c';
        
        //condition for RMA Raised
        query += ' WHERE (Workflow_Stage__c = \''+RMA_Constants.RMA_RAISED+'\' AND Days_Overdue_CSR_Submission__c > 0';
        query += ' AND Cycle_time_consumed_for_CSR_Submission__c <> 0 AND Cycle_Time_for_CSR_Submission__c <> 0)';
        
        //condition for Techical Quality Approval
        query += ' OR (Workflow_Stage__c =\''+RMA_Constants.PEN_CQ_VAL+'\' AND Days_Overdue_CQ_Validation__c > 0';
        query += ' AND Cycle_time_consumed_for_CQ_Validation__c <> 0 AND Cycle_Time_for_Customer_Qty_Validation__c <> 0)';
        
        //condition for Technical Validation
        query += ' OR (Workflow_Stage__c IN (\''+RMA_Constants.PEN_FAB_VAL+'\',\''+RMA_Constants.PEN_TNK_VAL+'\',\''+RMA_Constants.PEN_NONFAB_VAL+'\',';
        query += '\''+RMA_Constants.PEN_PRD_ENG+'\')';
        query += ' AND Days_Overdue_Fab_Validation__c > 0 AND Cycle_time_consumed_for_Fab_Validation__c <> 0 AND Cycle_Time_for_Fab_Validation__c <> 0)';
        
        //condition for Regional Recommendation
        query += ' OR (Workflow_Stage__c IN (\''+RMA_Constants.PEN_REG_DIR+'\',\''+RMA_Constants.PEN_REG_VP+'\',\''+RMA_Constants.PEN_REG_SVP+'\',';
        query += '\''+RMA_Constants.PEN_PRD_MGR+'\',\''+RMA_Constants.PEN_PRD_DIR+'\',\''+RMA_Constants.PEN_LOG_APPR+'\',\''+RMA_Constants.PEN_CSR_MGR_APPR+'\')';
        query += ' AND Days_Overdue_Regional_Approval__c > 0 AND Cycle_time_consumed_for_RegionalApproval__c <> 0 AND Cycle_Time_for_Regional_Approval__c <> 0)';
        
        //condition for Finance Approval
        query += ' OR (Workflow_Stage__c IN (\''+RMA_Constants.PEN_FIN_MGR+'\',\''+RMA_Constants.PEN_FIN_FABDIR+'\',\''+RMA_Constants.PEN_FIN_VPFIN+'\',';
        query += '\''+RMA_Constants.PEN_FIN_CORP+'\',\''+RMA_Constants.PEN_FIN_PRC+'\')';
        query += ' AND Days_Overdue_Finance_Approval__c > 0 AND Cycle_time_consumed_for_Finance_Approval__c <> 0 AND Cycle_Time_for_Finance_Approval__c <> 0)'; 
        
        //condition for Acknowledgement
        query += ' OR (Workflow_Stage__c IN (\''+RMA_Constants.PEN_REC_WAF+'\',\''+RMA_Constants.PEN_SCR_CRT+'\',\''+RMA_Constants.PEN_REC_SCR+'\')';
        query += ' AND Days_Overdue_Wafer_Acknowledgement__c > 0 AND Cycle_time_consumed_for_Wafer_Ack__c <> 0 AND Cycle_Time_for_Wafer_Acknowledgement__c <> 0)';
        
        //condition for Rejected RMA
        query += ' OR(Workflow_Stage__c = \''+RMA_Constants.REJECTED_RMA+'\' AND Days_Overdue_Rejected__c > 0';
        query += ' AND Rejected_Days__c <> 0 AND Cycle_Time_for_CSR_Submission__c <> 0)';
        
        query += ' GROUP BY OwnerId, Owner.Email';
                
        return query;               
    }
    
}