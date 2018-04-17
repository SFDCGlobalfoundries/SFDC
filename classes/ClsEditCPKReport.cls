/*
Author:         Bhavana Mohan
Company:        Cognizant Technology Solution 
Description:    

History:
BMohan     26062013     -     Class Creation
Vijay      21042014     -     Only QA Approver and QA Approver Backup user are allowed to edit the record when it is in 'pending QA Approval'  
Yash       12102014     -     Only QA Approver and QA Approver Backup user are allowed to edit the record when it is in 'Approved'
DBiswal    03182014     -     Query Active__c for VfEditCPKReport Page.
*/
public without sharing class ClsEditCPKReport{

    public CPK_Report__c cpkReport{get; set;}
    public String account;
    public String fab;
    public Boolean ProcessDesc{get;set;}
    public Boolean ProcessDescQA{get;set;}
    
    public Boolean renderIfQA{get;set;}
    public Boolean isRecordEditable {get;set;}
    public static final String CPK_REPORT_PENDING_QA_APPROVAL_STAGE = 'Pending QA Approval';
    public static final String CPK_REPORT_REJECTED_BY_PI_STAGE = 'Rejected By PI';
    public static final String CPK_REPORT_DRAFT_BY_PI_STAGE = 'Draft';
    public static final String CPK_REPORT_REJECTED_BY_QA_STAGE = 'Rejected By QA';
    public static final String CPK_REPORT_Approved_STAGE = 'Approved';
     
    public ClsEditCPKReport(Apexpages.StandardController stdController){
    
        cpkReport = new CPK_Report__c();
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            cpkReport = [select Name ,
                              PI_Owner_1__c,PI_Owner_1__r.Name,
                              PI_Owner_2__c,PI_Owner_2__r.Name,
                              PI_Owner_3__c,PI_Owner_3__r.Name,
                              FABS__c,
                              Report_Cycle__c,
                              Reminder__c,
                              Report_Cycle_Day__c,
                              Technology__c, Active__c,
                              Geometry__c,Process_Name__c,
                              Global_Report_Cycle_Day__c, Stage__c, QA_Approver__c, QA_Approver_backUp__c, OwnerId
                              from CPK_Report__c where Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        
        if(cpkReport.Stage__c == CPK_REPORT_PENDING_QA_APPROVAL_STAGE || cpkReport.Stage__c == CPK_REPORT_REJECTED_BY_PI_STAGE || cpkReport.Stage__c ==CPK_REPORT_Approved_STAGE  ){
            if( (cpkReport.QA_Approver__c != null && cpkReport.QA_Approver__c == UserInfo.getUserId()) ||
                (cpkReport.QA_Approver_backUp__c != null && cpkReport.QA_Approver_backUp__c == UserInfo.getUserId())) {
                isRecordEditable = true;
                if(cpkReport.Stage__c ==CPK_REPORT_Approved_STAGE )
                {
                    ProcessDesc=False;
                    ProcessDescQA=true;
                }
                else
                {
                    ProcessDesc=true;
                    ProcessDescQA=false;
                }
            }else{
                isRecordEditable = false;
            }   
        }else if(cpkReport.Stage__c == CPK_REPORT_DRAFT_BY_PI_STAGE || cpkReport.Stage__c == CPK_REPORT_REJECTED_BY_QA_STAGE){
            isRecordEditable = true;
            ProcessDesc=true;
            ProcessDescQA=false;
        }else{
            isRecordEditable = false;
            ProcessDesc=false;
            ProcessDescQA=true;
        }
    }
    
    public PageReference Saving(){
    
        PageReference returnUrl;
        if(cpkReport.Technology__c != null && cpkReport.Reminder__c != null && cpkReport.FABS__C != null && cpkReport.Report_Cycle__c != null && cpkReport.Geometry__c != null){
            ClsNewCPKReport ClsNewCPKReportins = new ClsNewCPKReport();
            if(cpkReport.Report_Cycle_Day__c == null){
                cpkReport.Report_Cycle_Day__c = ClsNewCPKReportins.globalReportCycleDay();
            }
            cpkReport.Remind_To_Upload__c = cpkReport.Reminder__c - Integer.valueOf(cpkReport.Report_Cycle_Day__c);
            try{  
                update cpkReport;
                returnUrl=new PageReference('/'+cpkReport.id);
                returnUrl.setRedirect(true);
                return returnUrl;
            }catch(DMLException e){
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'All Fields Marked Required Should Have a Value');
            ApexPages.addMessage(myMsg);
        }
        return null;
    } 
    
    public void sectionAccessToQA(){
        ClsNewCPKReport cpkReportIns = new ClsNewCPKReport();
        renderIfQA = cpkReportIns.sectionAccessToQA();
    }

}