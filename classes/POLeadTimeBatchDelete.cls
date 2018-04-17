/*
    Author: Zymark Ambat
    Description: This is a batch class to delete PO Lead Time records.
    History: 
        ZAmbat      09252013    - Code creation.
*/

global class POLeadTimeBatchDelete implements Database.Batchable<sObject> {
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
    global boolean isFromModule {get;set;}
    
    global POLeadTimeBatchDelete(date prd, date grd, date q1, date q2, date q3, date q4, string q, string d, List<string> fv, List<string> gv, string uId, boolean m) {
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
        this.isFromModule = m;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string sQuery = '';
        if (this.isFromModule) {
            sQuery = 'SELECT Id FROM PO_Lead_Time_Report__c WHERE User_Id__c = :userId AND DPML_Selected__c = :dpmlSelected';
        } else {
            sQuery = 'SELECT Id FROM PO_Lead_Time_Report__c';
        }
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        List<PO_Lead_Time_Report__c> listReport = new List<PO_Lead_Time_Report__c>();
        for (PO_Lead_Time_Report__c p : (List<PO_Lead_Time_Report__c>)scope) {
            listReport.add(p);
        }
        
        if (listReport.size() > 0) {
            delete listReport;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        if (this.isFromModule) {
            database.executeBatch(new POLeadTimeBatchUpdate(this.poRaiseDate, this.goodsReceivedDate, this.qtr1Start, this.qtr2Start, this.qtr3Start, this.qtr4Start, this.query, this.dpmlSelected, this.fabValues, this.geometryValues, this.userId));
        }
    }
}