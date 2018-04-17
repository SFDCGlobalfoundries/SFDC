/*
*   This class is generated from WSDL file provided by AIA/MDP
*/
public class MRSMDPResponseService {
    public class serviceMDPfeedbackResults {
        public String serviceMDPfeedbackResult;
        private String[] serviceMDPfeedbackResult_type_info = new String[]{'serviceMDPfeedbackResult','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService','true','false'};
        private String[] field_order_type_info = new String[]{'serviceMDPfeedbackResult'};
    }
    public class mdpLayerStatus {
        public String layerNumber;
        public String layerRevision;
        public String ROMcode;
        public String layerStatus;
        public String message;
        public MRSMDPResponseService.mdpLayChip[] layerChipStatus;
        private String[] layerNumber_type_info = new String[]{'layerNumber','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] layerRevision_type_info = new String[]{'layerRevision','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] ROMcode_type_info = new String[]{'ROMcode','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] layerStatus_type_info = new String[]{'layerStatus','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] layerChipStatus_type_info = new String[]{'layerChipStatus','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService','true','false'};
        private String[] field_order_type_info = new String[]{'layerNumber','layerRevision','ROMcode','layerStatus','message','layerChipStatus'};
    }
    public class serviceMDPfeedbackRequest {
        public String messageID;
        public String transactionStatus;
        public String transactionErrorMessage;
        public String ptrfNumber;
        public MRSMDPResponseService.mdpLayerStatus[] layerStatus;
        private String[] messageID_type_info = new String[]{'messageID','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] transactionStatus_type_info = new String[]{'transactionStatus','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] transactionErrorMessage_type_info = new String[]{'transactionErrorMessage','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] ptrfNumber_type_info = new String[]{'ptrfNumber','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] layerStatus_type_info = new String[]{'layerStatus','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService','true','false'};
        private String[] field_order_type_info = new String[]{'messageID','transactionStatus','transactionErrorMessage','ptrfNumber','layerStatus'};
    }
    public class mdpLayChip {
        public String chipName;
        public String chipStatus;
        public String message;
        private String[] chipName_type_info = new String[]{'chipName','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] chipStatus_type_info = new String[]{'chipStatus','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService','true','false'};
        private String[] field_order_type_info = new String[]{'chipName','chipStatus','message'};
    }
    public class MDPMRSResponseService_pt {
        //public String endpoint_x = 'https://test.foundryview.com/sfaia/soa-infra/services/SF/MDPMRSResponseService/MDPMRSResponseService_client_ep';
        public String endpoint_x = Environment_Variable__c.getInstance('SWIFT_MRS_Approval_EndPoint').value__c;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService', 'MRSMDPResponseService'};
        public String process(String messageID,String transactionStatus,String transactionErrorMessage,String ptrfNumber,MRSMDPResponseService.mdpLayerStatus[] layerStatus) {
            MRSMDPResponseService.serviceMDPfeedbackRequest request_x = new MRSMDPResponseService.serviceMDPfeedbackRequest();
            request_x.messageID = messageID;
            request_x.transactionStatus = transactionStatus;
            request_x.transactionErrorMessage = transactionErrorMessage;
            request_x.ptrfNumber = ptrfNumber;
            request_x.layerStatus = layerStatus;
            MRSMDPResponseService.serviceMDPfeedbackResults response_x;
            Map<String, MRSMDPResponseService.serviceMDPfeedbackResults> response_map_x = new Map<String, MRSMDPResponseService.serviceMDPfeedbackResults>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'process',
              'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',
              'serviceMDPfeedbackRequest',
              'http://xmlns.oracle.com/GF/MDPMRSResponseService/MDPMRSResponseService',
              'serviceMDPfeedbackResults',
              'MRSMDPResponseService.serviceMDPfeedbackResults'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.serviceMDPfeedbackResult;
        }
    }
}