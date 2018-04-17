/*
* This is a generic WS which can handle MEBES Jobview/GDSOUT Review/Frame Mockup approval request.
*/
global class MRSApprovalService {

    public static String SWIFT_MDP_Data_Not_Found       = 'SWIFT_MDP_Data_Not_Found';
    public static String SWIFT_WS_Unhandled_Exception   = 'SWIFT_Approval_Service_Unhandled_Exception';
    public static String WS_CLASS_NAME                  = 'MRSApprovalService';
    public static String WS_METHOD_NAME                 = 'performApproval';
    
    global class MRSApprovalMsg{
        webservice string messageID ;
        webservice string employeeID ;
        webservice string maskSetTitle;
        webservice string source;
        webservice string statusType;
        webservice string ptrfNumber;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice List<MRSLayerData> layers;
    }
    
    global class MRSLayerData{
        webservice string layerNumber ;
        webservice string layerRev ;
        webservice string romCode;
        webservice string comment;
        webservice List<MRSLayerChipData> layerChips;
    }
    
    global class MRSLayerChipData{
        webservice string chipName ;
        webservice string status ;
    }
    
    /*
    * @description The incoming request will be handled by appropriate service.
    * @param msg An instance of MRSApprovalService.MRSApprovalMsg
    * @return
    */
    public static void performApproval(MRSApprovalMsg msg){
        MRSGeneralService.fetchService(msg.statusType).handleRequest(msg);
    }
    
    /*
    * @description called by other systems for MDP MEBES Jobview approval
    * @param 
    * @return
    */
    webservice static void performApproval_MDP(MRSApprovalMsg msg){
        performApproval(msg);
    }
    
    /*
    * @description called by other systems for TDTI MPW MEBES Jobview approval
    * @param 
    * @return
    */
    webservice static void performApproval_TDTI_MPW(MRSApprovalMsg msg){
        performApproval(msg);
    }
    
    /*
    * @description called by other systems for Foundry MEBES Jobview approval
    * @param 
    * @return
    */
    webservice static void performApproval_Foundry_MEBES(MRSApprovalMsg msg){
        performApproval(msg);
    }
}