/*
eJSDV - Customer Mebes Jv WS
WS basic flow: MDP > CAD > MRS
*/
public with sharing class MRSCustomerMEBESJVService extends MRSGeneralService {
    
    public override Map<String, String> getFieldMap() {
        return new Map<String, String> {
            FIELD_JV            => 'Customer_MEBES_Jobview__c',
            FIELD_APPROVAL_DATE => 'Customer_MEBES_Jobview_Date__c',
            FIELD_APPROVER      => 'CustomerMebesJobviewApprover__c'
        }; 
    }
    
    public override String getSourceForApprovalEmail() {
        return 'MEBES Jobview - Customer';
    }
    
    public override String getNoteCategory() {
        return 'Customer MEBES Jobview';
    }
}