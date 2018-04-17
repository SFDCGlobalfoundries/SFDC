/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: Return Material Authorization
* Description: This class is used to declare string constants being used in RMA application.
* History:
*    SurendranadhNune 13112015    -    Created.
*    NJain            21012016    -    Added constants for Workflow Stage  
**/
public class RMA_Constants{
    
    //RMA Business Category values
    public static final String FOUNDRY = 'Foundry';
    public static final String ASIC = 'ASIC';
    public static final String IBM_SERVER = 'IBM Server';
    
    //RMA tab names
    public static final String DISPOSITION_OF_WAFER = 'Disposition of Wafers';
    public static final String TECHNICAL_VALIDATION = 'Technical Validation';
    public static final String RMA_INFORMATION = 'RMA Information';
    public static final String RMA_ALL = 'RMA Information;Disposition of Wafers;Technical Validation';
    
    //RMA tab short names
    public static final String tabName_RMA_INFORMATION = 'RMA_Information';
    public static final String tabName_DISPOSITION_OF_WAFER = 'Disposition_of_Wafers';
    public static final String tabName_FAB_VALIDATION = 'Technical_Validation';
        
    //Agere customer
    public static final String AGERE_CUSTOMER_SHORT_NAME = 'agere';
    public static final String AGERE_CUSTOMER_NUMBER     = '10156';
    
    //Audit log Record type Developer Name
    public static final String CYCLE_TIME_LOG = 'Cycle Time Log';
    public static final String MAIL_LOG = 'Mail Log';
    
    //MailLog Report
    public static final String MAIL_LOG_REPORT_DEVELOPER_NAME = 'RMA_with_Mail_logs';
    
    //Workflow Stage Name
    public static final String RMA_RAISED = 'RMA Raised';
    public static final String VOIDED_RMA = 'Voided RMA';
    public static final String REJECTED_RMA = 'Rejected RMA';
    public static final String PEN_CQ_VAL = 'Pending for Quality Validation';
    public static final String PEN_FAB_VAL = 'Pending for Fab Validation';
    public static final String PEN_TNK_VAL = 'Pending for Turnkey/ Sub-con Validation';
    public static final String PEN_NONFAB_VAL = 'Pending for Non Fab Category Validation';
    public static final String PEN_LOG_APPR = 'Pending for Logistics Approval';
    public static final String PEN_CSR_MGR_APPR = 'Pending for CSR Manager Approval';
    public static final String PEN_REG_DIR = 'Pending for Regional Recommendation - Director';
    public static final String PEN_REG_VP  = 'Pending for Regional Recommendation - VP';
    public static final String PEN_REG_SVP = 'Pending for Regional Approval - Snr. VP';
    public static final String PEN_REC_WAF = 'Pending for Receipt of Physical Wafers';
    public static final String PEN_SCR_CRT = 'Pending for Receipt of Scrap Certificate';
    public static final String PEN_REC_SCR = 'Pending for Receipt of Physical Wafers & Scrap Certificate';
    public static final String DIS_NOT_DEF = 'Disposition of Wafers Not Defined';
    public static final String PEN_FIN     = 'Pending for Finance Approval - Verifier';
    public static final String PEN_FIN_MGR = 'Pending for Finance Approval - Manager';
    public static final String PEN_FIN_ARMGR = 'Pending for Finance Approval - AR Section Manager';
    public static final String PEN_FIN_CORP = 'Pending for Finance Approval - Corporate Controller';
    public static final String PEN_FIN_FINDIR = 'Pending for Finance Approval - Finance Director';
    public static final String PEN_FIN_FABDIR = 'Pending for Finance Approval - Fab Director';
    public static final String PEN_FIN_PRC = 'Pending for Finance Approval - Pricing Council';
    public static final String PEN_FIN_VPFIN = 'Pending for Finance Approval - VP Operations,Finance';
    public static final String PEN_CN_ISS  = 'Pending for CN Issue';
    public static final String PEN_SO_ISS  = 'Pending for SO Issue';
    public static final String CLOSED_RMA  = 'Closed RMA';
    public static final String PEN_PRD_ENG = 'Pending for Product Engineering Validation';
    public static final String PEN_PRD_MGR = 'Pending for Product Engineering - Manager';
    public static final String PEN_PRD_DIR = 'Pending for Product Engineering - Director';
    
    //keyPrefix for Group and User
    public static final String GROUP_KEYPREFIX = Schema.SObjectType.Group.getKeyPrefix();
    public static final String USER_KEYPREFIX = Schema.SObjectType.User.getKeyPrefix();
    
    //record type ids for RMA PRF/CAR Particular object
    public static final String PRFCAR_CAR = Schema.SObjectType.RMA_PRF_CAR_Particulars__c.getRecordTypeInfosByName().get('CAR').getRecordTypeId();
    public static final String PRFCAR_FailureMode = Schema.SObjectType.RMA_PRF_CAR_Particulars__c.getRecordTypeInfosByName().get('Failure Mode').getRecordTypeId();
    public static final String PRFCAR_PRF = Schema.SObjectType.RMA_PRF_CAR_Particulars__c.getRecordTypeInfosByName().get('PRF').getRecordTypeId();
    public static final String RMA_EMAL_SERVICE = 'RMA Mail log Service';
    public static final String EMAIL_SERVICE_ADDRESS = RMA_UTILITY.retrieveRMAEmailServiceAddress(RMA_EMAL_SERVICE);
    
    //RMA Status
    public static final String DRAFT_STATUS = 'Draft';
    public static final String SUBMITTED_STATUS = 'Submitted';
    public static final String REJECTED_STATUS = 'Rejected';
    public static final String VOIDED_STATUS = 'Voided';
    
    //related department for Delinquent Summary Report
    public static final String CSR_DEPT = 'CSR';
    public static final String QLTY_DEPT = 'Technical Quality Team';
    public static final String FAB_DEPT = 'QA/PI/YE/PE';
    public static final String REG_DEPT = 'Regional Personnel';
    public static final String LOG_DEPT = 'Logistic Manager';
    public static final String CSRMGR_DEPT = 'Logistic Manager';
    public static final String FIN_DEPT = 'Finance';
    public static final String STORE_DEPT = 'Store';
    
    //CRM Content Library Name
    public static final String RMA_CONTENT_LIBRARY_NAME = 'RMA ATTACHMENTS';
}