public class MRSMDPService extends MRSGeneralService {

    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override Map<String, String> getFieldMap(){
        return new Map<String, String> {
            FIELD_JV                => 'MDP_MEBES_Jobview__c',
            FIELD_APPROVAL_DATE     => 'MDP_MEBES_Jobview_Date__c',
            FIELD_APPROVER          => 'MDPMebesJobviewApprover__c'
        }; 
    }
    
    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override String getSourceForApprovalEmail(){
        return 'MEBES Jobview - MDP';
    }
    
    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override String getNoteCategory(){
        return 'Tapeout Centre/MDP MEBES Jobview';
    }
}