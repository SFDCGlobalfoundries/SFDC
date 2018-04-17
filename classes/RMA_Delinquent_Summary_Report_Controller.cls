public class RMA_Delinquent_Summary_Report_Controller {
    
    public Integer size{get;set;}
    public List<List<String>> listDetails{get;set;} //for export
    
    public String queryBuilder(){
        
        String query = '';
        query = 'SELECT Id,Name,Workflow_Stage__c,Fab__c,Region__c,RMA_Category__c,Customer_Name__c,Cycle_time_consumed_for_CSR_Submission__c,';
        query += 'Cycle_time_consumed_for_CQ_Validation__c,Cycle_time_consumed_for_Fab_Validation__c,Cycle_time_consumed_for_Finance_Approval__c,Cycle_time_consumed_for_RegionalApproval__c,';
        query += 'Cycle_time_consumed_for_Wafer_Ack__c,Cycle_Time_for_CSR_Submission__c,Cycle_Time_for_Customer_Qty_Validation__c,Cycle_Time_for_Fab_Validation__c,Cycle_Time_for_Finance_Approval__c,';
        query += 'Cycle_Time_for_Regional_Approval__c,Cycle_Time_for_Wafer_Acknowledgement__c,Days_Overdue_CSR_Submission__c,';
        query += 'Days_Overdue_CQ_Validation__c,Days_Overdue_Fab_Validation__c,Days_Overdue_Regional_Approval__c,Days_Overdue_Finance_Approval__c,Days_Overdue_Wafer_Acknowledgement__c,Rejected_Days__c,Days_Overdue_Rejected__c';
        query += ' FROM RMA__c';
        
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
        
        query += ' ORDER BY Customer_Name__c ASC';
        
        return query;               
    }
    
    //standard set controller
    public ApexPages.StandardSetController setCon{
        get{
            if(setCon == NULL){
                size = 10;
                if(!Test.isRunningTest()){
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBuilder()));
                }else{
                    String query = '';
                    query = 'SELECT Id,Name,Workflow_Stage__c,Fab__c,Region__c,RMA_Category__c,Customer_Name__c,Cycle_time_consumed_for_CSR_Submission__c,';
                    query += 'Cycle_time_consumed_for_CQ_Validation__c,Cycle_time_consumed_for_Fab_Validation__c,Cycle_time_consumed_for_Finance_Approval__c,Cycle_time_consumed_for_RegionalApproval__c,';
                    query += 'Cycle_time_consumed_for_Wafer_Ack__c,Cycle_Time_for_CSR_Submission__c,Cycle_Time_for_Customer_Qty_Validation__c,Cycle_Time_for_Fab_Validation__c,Cycle_Time_for_Finance_Approval__c,';
                    query += 'Cycle_Time_for_Regional_Approval__c,Cycle_Time_for_Wafer_Acknowledgement__c,Days_Overdue_CSR_Submission__c,';
                    query += 'Days_Overdue_CQ_Validation__c,Days_Overdue_Fab_Validation__c,Days_Overdue_Regional_Approval__c,Days_Overdue_Finance_Approval__c,Days_Overdue_Wafer_Acknowledgement__c,Rejected_Days__c,Days_Overdue_Rejected__c';
                    query += ' FROM RMA__c';
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                }
                setCon.setPageSize(size);
            }
            return setCon;
        }
        set;
    }
    
    //List of wrapper class o display
    public List<wrapperRMA> retreiveRMAWrapperList(){
        List<wrapperRMA> rWList = new List<wrapperRMA>();        
        List<RMA__c> tempList = setCon.getRecords();
        
        if(!tempList.isEmpty()){        
            for(RMA__c rmaRec : tempList){
                String dept = '';
                Decimal actCycTime;
                Decimal trgCycTime;
                Decimal dueDays;
                                
                if(rmaRec.Workflow_Stage__c == RMA_Constants.RMA_RAISED){
                    dept = RMA_Constants.CSR_DEPT;
                    actCycTime = rmaRec.Cycle_time_consumed_for_CSR_Submission__c;
                    trgCycTime = rmaRec.Cycle_Time_for_CSR_Submission__c;
                    dueDays = rmaRec.Days_Overdue_CSR_Submission__c;
                }
                else if(rmaRec.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                    dept = RMA_Constants.QLTY_DEPT;
                    actCycTime = rmaRec.Cycle_time_consumed_for_CQ_Validation__c;
                    trgCycTime = rmaRec.Cycle_Time_for_Customer_Qty_Validation__c;
                    dueDays = rmaRec.Days_Overdue_CQ_Validation__c;
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL 
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG){
                    dept = RMA_Constants.FAB_DEPT;
                    actCycTime = rmaRec.Cycle_time_consumed_for_Fab_Validation__c;
                    trgCycTime = rmaRec.Cycle_Time_for_Fab_Validation__c;
                    dueDays = rmaRec.Days_Overdue_Fab_Validation__c;
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_VP
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR 
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_LOG_APPR
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_CSR_MGR_APPR){
                         if(!RMA_Utility.checkFab9or10(rmaRec.Fab__c)){
                             dept = RMA_Constants.REG_DEPT;    
                         }
                         else{
                             if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_LOG_APPR){
                                 dept = RMA_Constants.LOG_DEPT;
                             }
                             else{
                                 dept = RMA_Constants.CSRMGR_DEPT;
                             }
                         }
                    actCycTime = rmaRec.Cycle_time_consumed_for_RegionalApproval__c;
                    trgCycTime = rmaRec.Cycle_Time_for_Regional_Approval__c;
                    dueDays = rmaRec.Days_Overdue_Regional_Approval__c;
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR 
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){     
                    dept = RMA_Constants.FIN_DEPT;
                    actCycTime = rmaRec.Cycle_time_consumed_for_Finance_Approval__c;
                    trgCycTime = rmaRec.Cycle_Time_for_Finance_Approval__c;
                    dueDays = rmaRec.Days_Overdue_Finance_Approval__c;
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REC_WAF || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT 
                     || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REC_SCR){
                    dept = RMA_Constants.STORE_DEPT;
                    actCycTime = rmaRec.Cycle_time_consumed_for_Wafer_Ack__c;
                    trgCycTime = rmaRec.Cycle_Time_for_Wafer_Acknowledgement__c;
                    dueDays = rmaRec.Days_Overdue_Wafer_Acknowledgement__c;
                }
                else if(rmaRec.Workflow_Stage__c == RMA_Constants.REJECTED_RMA){
                    dept = RMA_Constants.CSR_DEPT;
                    actCycTime = rmaRec.Rejected_Days__c;
                    trgCycTime = rmaRec.Cycle_Time_for_CSR_Submission__c;
                    dueDays = rmaRec.Days_Overdue_Rejected__c;
                }
                rWList.add(new wrapperRMA(rmaRec,dept,actCycTime,trgCycTime,dueDays));    
            }
        }
        return rWList;
    }
    
    public List<wrapperRMA> RMAWrapperList {
        get{
            return retreiveRMAWrapperList();
        }
        set;
    }
    
    //to refresh
    public pageReference refresh() {
        setCon = null;
        retreiveRMAWrapperList();
        setCon.setPageNumber(1);
        return null;
    }
    
    public boolean hasNext{
        get{
            return setCon.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    public Integer noOfRecords {
        get{
            return setCon.getResultSize();
        }
        set;
    }
    
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    public void first() {
        setCon.first();
    }
    
    public void last(){
        setCon.last();
    }
    
    public void previous(){
        setCon.previous();
    }
    
    public void next(){
        setCon.next();
    }
    
    //to export
    public pageReference exportCsvFile(){
        listDetails = new List<List<String>>();
        createCsvFile();
        return new pageReference('/apex/RMA_Delinquent_Summary_Report_Export_Csv');
    }
    
    //to create Csv
    public void createCsvFile(){
        List<String> headers = new List<String>();
        headers.add('Customer,Responsible Dept,FAB,Region,RMA Category,Stage,RMA No,Actual Cycle Time,Targe Cycle Time,Days Overdue\n');
        listDetails.add(headers);
        List<String> tempList = new List<String>();
        if(rmaWrapperList != NULL && !rmaWrapperList.isEmpty()){
            for(wrapperRMA wrma: rmaWrapperList){
                String details = '';
                details = (wrma.rma.Customer_Name__c != NULL ? wrma.rma.Customer_Name__c : '')+','+
                          (wrma.dept != NULL ? wrma.dept : '')+','+
                          (wrma.rma.Fab__c != NULL ? wrma.rma.Fab__c : '')+','+
                          (wrma.rma.Region__c != NULL ? wrma.rma.Region__c : '')+','+
                          (wrma.rma.RMA_Category__c != NULL ? wrma.rma.RMA_Category__c : '')+','+
                          (wrma.rma.Workflow_Stage__c != NULL ? wrma.rma.Workflow_Stage__c : '')+','+
                          (wrma.rma.Name != NULL ? wrma.rma.Name : '')+','+
                          (wrma.actualCycTime != NULL ? String.valueOf(wrma.actualCycTime) : '')+','+
                          (wrma.targetCycTime != NULL ? String.valueOf(wrma.targetCycTime) : '')+','+
                          (wrma.dueDays != NULL ? String.valueOf(wrma.dueDays) : '')+','+'\n';
                if (tempList.size() < 1000) {
                    tempList.add(details);
                } else {
                    listDetails.add(tempList); 
                    tempList = new List<String>();
                }           
            }
        }
        if (tempList.size() > 0) {
            listDetails.add(tempList);
        }
    }
    
    //wrapper class
    public class wrapperRMA{
        public RMA__c rma{get;set;}
        public String dept{get;set;}
        public Decimal actualCycTime{get;set;}
        public Decimal targetCycTime{get;set;}
        public Decimal dueDays{get;set;}
        
        public wrapperRMA(RMA__c r,String dpt, Decimal act, Decimal tct, Decimal dd){
            rma = r;
            dept = dpt;
            actualCycTime = act;
            targetCycTime = tct;
            dueDays = dd;
        }
    }
    
}