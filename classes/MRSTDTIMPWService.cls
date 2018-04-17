public class MRSTDTIMPWService extends MRSGeneralService {

    /*
    * @description 
    * @param
    * @return 
    */
    public override Map<String, String> getFieldMap(){
        return new Map<String, String> {
            FIELD_JV                => 'TDTI_MPW_MEBES_Jobview__c',
            FIELD_APPROVAL_DATE     => 'TDTI_MPW_MEBES_Date__c',
            FIELD_APPROVER          => 'TDTIMPWMebesJobviewApprover__c'
        }; 
    }
    
    /*
    * @description 
    * @param
    * @return 
    */
    public override String getSourceForApprovalEmail(){
        return 'MEBES Jobview - TDTIMPW';
    }
    
    /*
    * @description 
    * @param
    * @return 
    */
    public override String getNoteCategory(){
        return 'GlobalShuttle/TDTI-MPW MEBES Jobview';
    }
}