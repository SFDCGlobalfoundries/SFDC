/*
    Author: Zymark Ambat
    Description: This is a batch class to update PO Lead Time records.
    History: 
        ZAmbat      09252013    - Code creation.
*/

global class POLeadTimeBatchUpdate implements Database.Batchable<sObject> {
    global date poRaiseDate {get;set;}
    global date goodsReceivedDate {get;set;}
    global date qtr1Start {get;set;}
    global date qtr2Start {get;set;}
    global date qtr3Start {get;set;}
    global date qtr4Start {get;set;}
    global string query {get;set;}
    global string dpmlSelected {get;set;}
    global string userId {get;set;}
    global List<string> fabValues {get;set;}
    global List<string> geometryValues {get;set;}
    
    global POLeadTimeBatchUpdate(date prd, date grd, date q1, date q2, date q3, date q4, string q, string d, List<string> fv, List<string> gv, string uId) {
        this.poRaiseDate = prd;
        this.goodsReceivedDate = grd;
        this.qtr1Start = q1;
        this.qtr2Start = q2;
        this.qtr3Start = q3;
        this.qtr4Start = q4;
        this.query = q;
        this.dpmlSelected = d;
        this.userId = uId;
        this.fabValues = fv;
        this.geometryValues = gv;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        List<PO_Lead_Time__c> listPoLeadTime = (List<PO_Lead_Time__c>)scope; 
        List<PO_Lead_Time_Report__c> listReport = new List<PO_Lead_Time_Report__c>();
        for (PO_Lead_Time__c p : listPoLeadTime) {
            PO_Lead_Time_Report__c r = new PO_Lead_Time_Report__c();
            r.Account__c = p.Account__r.Name;
            r.Account_Short_Name__c = p.Device_Account_Short_Name__c;
            r.Device__c = p.Base_Device__c;
            r.DPML_Selected__c = this.dpmlSelected;
            r.Geometry__c = p.Geometry__c;
            r.User_Id__c = this.userId;
            r.Fab__c = p.Fab__c;
            r.ML_Count__c = p.ML_Count_FEOL_BEOL__c;
            r.PF_Adder__c = p.PF_Adder_day__c;
            r.Fab_Queue_Time__c = p.PO_Lead_Time_day__c;
            r.Process_Id__c = p.Process_Flow_Pid_PT_Id__c;
            r.Device_Stage__c = p.Device_Stage__c;
            
            date tempDate;
            if (this.poRaiseDate != null && this.goodsReceivedDate == null) {              
                tempDate = this.poRaiseDate;
            } else if (this.poRaiseDate == null && this.goodsReceivedDate != null) {            
                tempDate = this.goodsReceivedDate;
            } else {
                tempDate = date.today();
            }

            // Total Lead Time
            decimal dpml = 0;
            if (tempDate >= this.qtr1Start && tempDate <= this.qtr2Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (p.Standard_DPML_day_CurrQtr__c != null && p.Standard_DPML_day_CurrQtr__c.trim() != '') {
                        dpml = decimal.valueOf(p.Standard_DPML_day_CurrQtr__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr1__c != null && p.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr1__c != null && p.Bullet_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (p.Hot_DPML_12w_day_CurrQtr1__c != null && p.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (p.Hot_DPML_12w_day_CurrQtr1__c != null && p.Hot_DPML_12w_day_CurrQtr1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr1__c);
                    }
                }
            } else if (tempDate >= this.qtr2Start && tempDate <= this.qtr3Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (p.Standard_DPML_day_CurrQtr_1__c != null && p.Standard_DPML_day_CurrQtr_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Standard_DPML_day_CurrQtr_1__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_1__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_1_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_1_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_1_1__c != null && p.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_1__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_1_1__c != null && p.Hot_DPML_12w_day_CurrQtr_1_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_1_1__c);
                    }
                }
            } else if (tempDate >= this.qtr3Start && tempDate <= this.qtr4Start.addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (p.Standard_DPML_day_CurrQtr_2__c != null && p.Standard_DPML_day_CurrQtr_2__c.trim() != '') {
                        dpml = decimal.valueOf(p.Standard_DPML_day_CurrQtr_2__c);
                    } 
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_2__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_2_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_2_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_2_1__c != null && p.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_2__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_2_1__c != null && p.Hot_DPML_12w_day_CurrQtr_2_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_2_1__c);
                    }
                }
            } else if (tempDate >= this.qtr4Start && tempDate <= this.qtr4Start.addMonths(3).addDays(-1)) {
                if (this.dpmlSelected == 'Standard') {
                    if (p.Standard_DPML_day_CurrQtr_3__c != null && p.Standard_DPML_day_CurrQtr_3__c.trim() != '') {
                        dpml = decimal.valueOf(p.Standard_DPML_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'BulletLE12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'BulletG12') {
                    if (p.Bullet_DPML_12w_day_CurrQtr_3_1__c != null && p.Bullet_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Bullet_DPML_12w_day_CurrQtr_3_1__c);
                    }
                } else if (this.dpmlSelected == 'HotLE12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_3_1__c != null && p.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_3__c);
                    }
                } else if (this.dpmlSelected == 'HotG12') {
                    if (p.Hot_DPML_12w_day_CurrQtr_3_1__c != null && p.Hot_DPML_12w_day_CurrQtr_3_1__c.trim() != '') {
                        dpml = decimal.valueOf(p.Hot_DPML_12w_day_CurrQtr_3_1__c);
                    }
                }
            }
                
            integer noOfMaskLayers = 0;
            if (p.ML_Count_FEOL_BEOL__c != null && p.ML_Count_FEOL_BEOL__c.trim() != '') {
                noOfMaskLayers = integer.valueOf(p.ML_Count_FEOL_BEOL__c);
            }
            
            integer pfAdder = 0;
            if (p.PF_Adder_day__c != null && p.PF_Adder_day__c.trim() != '') {
                pfAdder = integer.valueOf(p.PF_Adder_day__c);
            }
            
            integer fabQueueTime = 0;
            if (p.PO_Lead_Time_day__c != null && p.PO_Lead_Time_day__c.trim() != '') {
                fabQueueTime = integer.valueOf(p.PO_Lead_Time_day__c);
            }
            
            decimal pTotalLeadTime = (fabQueueTime + pfAdder + (dpml * noOfMaskLayers)).round(System.RoundingMode.UP);
            r.Total_Lead_Time__c = string.valueOf(pTotalLeadTime);
            r.DPML__c = string.valueOf(dpml);
            if (this.poRaiseDate != null && this.goodsReceivedDate == null) {              
                r.PO_Raise_Date__c = this.poRaiseDate;
                r.Wafer_Shipped_Date__c = this.poRaiseDate.addDays(integer.valueOf(pTotalLeadTime));
            } else if (this.poRaiseDate == null && this.goodsReceivedDate != null) {            
                r.PO_Raise_Date__c = this.poRaiseDate.addDays(integer.valueOf(pTotalLeadTime) * -1);
                r.Wafer_Shipped_Date__c = this.goodsReceivedDate;
            } else {
                r.PO_Raise_Date__c = date.today();
                r.Wafer_Shipped_Date__c = date.today().addDays(integer.valueOf(pTotalLeadTime));
            }
            
            listReport.add(r);
        }
        
        if (listReport.size() > 0) {
            insert listReport;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // Send Email
        try {
            Messaging.reserveSingleEmailCapacity(2);
            
            // Get Email template
            EmailTemplate template = [
                SELECT      Id 
                FROM        EmailTemplate 
                WHERE       name = 'PO Lead Time Export Data'
            ];
            
            // Dummy recipient
            Contact c = [
                SELECT      id
                            ,email 
                FROM        Contact 
                WHERE       email <> null 
                            LIMIT 1
            ];
            
            List<Messaging.SingleEmailMessage> listTemp = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage temp = new Messaging.SingleEmailMessage();       
            temp.templateId = template.Id;
            temp.setTargetObjectId(c.Id);
            temp.setSaveAsActivity(false);
            temp.setToAddresses(new List<String>{'blank@blank.com'}); 
            listTemp.add(temp);
            
            //Rollback to get the email template data
            Savepoint sp = Database.setSavepoint();      
            Messaging.sendEmail(listTemp);        
            Database.rollback(sp);
            
            // Replace merge field(s)
            User u = [
                SELECT      Name
                            , Email
                FROM        User
                WHERE       Id = :this.userId
            ];
            
            string reportId = Environment_Variable__c.getInstance('PO_Lead_Time_Report_Id').Value__c;
            string userFieldId = Environment_Variable__c.getInstance('PO_Lead_Time_Report_User_Id').Value__c;
            string dpmlFieldId = Environment_Variable__c.getInstance('PO_Lead_Time_Report_DPML').Value__c;
            string poRaiseDateFieldId = Environment_Variable__c.getInstance('PO_Lead_Time_Report_PO_Raise_Date').Value__c;
            string downloadURL = Environment_Variable__c.getInstance('SFDC_INSTANCE').Value__c + '/' + reportId + '?pc0=' + userFieldId + '&pn0=eq&pv0=' + this.userId + '&pc1=' + dpmlFieldId + '&pn1=eq&pv1='+ this.dpmlSelected + '&export=1&enc=UTF-8&xf=csv';
            List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setHtmlBody(listTemp[0].htmlBody.replace('{UserName}', u.Name).replace('{DownloadURL}', downloadURL));
            email.setPlainTextBody(listTemp[0].plainTextBody.replace('{UserName}', u.Name).replace('{DownloadURL}', downloadURL));
            email.setToAddresses(new List<string>{u.Email});
            email.setSubject(listTemp[0].subject);
            listEmail.add(email);
            
            // Send email
            if (!test.isRunningTest()) { 
                Messaging.sendEmail(listEmail);
            }
        } catch (Exception e) {
            system.debug('Error ==========> ' + e.getMessage());
        }
    }
}