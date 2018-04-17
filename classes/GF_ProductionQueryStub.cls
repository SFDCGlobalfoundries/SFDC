/*
*   @ Author        : Navneet Rajput
*   @ Description   : Class generated from WSDL for Production Query application 
*   @ Date          : 20th Jan 2014
*   @ Param         :
*   @ Methods       : 
*   @ Company       : Cognizant Technology LTD.
*   @ History       : Updated on 2/20/2014 by Navneet.
**/
global class GF_ProductionQueryStub {

    global class WaferStartResponseType {
        global String PO {get;set;}
        global String PO_HYPR{get;set;}
        global String SO{get;set;}
        global String FAB{get;set;}
        global String GEOMETRY_NAME{get;set;}
        global String PROCESS_NAME{get;set;}
        global String DEVICE_NAME{get;set;}
        global String DEVICE_NAME_HYPR{get;set;}
        global String CUSTOMER_PART_NAME{get;set;}
        global String LOTID{get;set;}
        global String LOT_TYPE{get;set;}
        global String LOT_PRIORITY{get;set;}
        global Integer START_LOT_QTY{get;set;}
        global String PLANSTARTTIME{get;set;}
        global String LOT_START_DATE{get;set;}
        global String CSD{get;set;}
        global String OSD{get;set;}
        global String CRD{get;set;}
        global String PLAN_FABOUT_DATE{get;set;}
        global String PRF_ID{get;set;}
        global String ORG_ID{get;set;}
        global String CUSTOMER_ID{get;set;}
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] PO_type_info = new String[]{'PO','',null,'1','1','false'};
        private String[] PO_HYPR_type_info = new String[]{'PO_HYPR','',null,'1','1','false'};
        private String[] SO_type_info = new String[]{'SO','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] GEOMETRY_NAME_type_info = new String[]{'GEOMETRY_NAME','',null,'1','1','false'};
        private String[] PROCESS_NAME_type_info = new String[]{'PROCESS_NAME','',null,'1','1','false'};
        private String[] DEVICE_NAME_type_info = new String[]{'DEVICE_NAME','',null,'1','1','false'};
        private String[] DEVICE_NAME_HYPR_type_info = new String[]{'DEVICE_NAME_HYPR','',null,'1','1','false'};
        private String[] CUSTOMER_PART_NAME_type_info = new String[]{'CUSTOMER_PART_NAME','',null,'1','1','false'};
        private String[] LOTID_type_info = new String[]{'LOTID','',null,'1','1','false'};
        private String[] LOT_TYPE_type_info = new String[]{'LOT_TYPE','',null,'1','1','false'};
        private String[] LOT_PRIORITY_type_info = new String[]{'LOT_PRIORITY','',null,'1','1','false'};
        private String[] START_LOT_QTY_type_info = new String[]{'START_LOT_QTY','',null,'1','1','false'};
        private String[] PLANSTARTTIME_type_info = new String[]{'PLANSTARTTIME','',null,'1','1','false'};
        private String[] LOT_START_DATE_type_info = new String[]{'LOT_START_DATE','',null,'1','1','false'};
        private String[] CSD_type_info = new String[]{'CSD','',null,'1','1','false'};
        private String[] OSD_type_info = new String[]{'OSD','',null,'1','1','false'};
        private String[] CRD_type_info = new String[]{'CRD','',null,'1','1','false'};
        private String[] PLAN_FABOUT_DATE_type_info = new String[]{'PLAN_FABOUT_DATE','',null,'1','1','false'};
        private String[] PRF_ID_type_info = new String[]{'PRF_ID','',null,'1','1','false'};
        private String[] ORG_ID_type_info = new String[]{'ORG_ID','',null,'1','1','false'};
        private String[] CUSTOMER_ID_type_info = new String[]{'CUSTOMER_ID','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'PO','PO_HYPR','SO','FAB','GEOMETRY_NAME','PROCESS_NAME','DEVICE_NAME','DEVICE_NAME_HYPR','CUSTOMER_PART_NAME','LOTID','LOT_TYPE','LOT_PRIORITY','START_LOT_QTY','PLANSTARTTIME','LOT_START_DATE','CSD','OSD','CRD','PLAN_FABOUT_DATE','PRF_ID','ORG_ID','CUSTOMER_ID','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class WaferStartRequest_element {
    
        global String ActStartDate;
        global String OrgId;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] ActStartDate_type_info = new String[]{'ActStartDate','',null,'0','1','true'};
        private String[] OrgId_type_info = new String[]{'OrgId','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'ActStartDate','OrgId','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class FabOutLocationRequest_element {
    
        global String ActFaboutDate;
        global String OrgId;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] ActFaboutDate_type_info = new String[]{'ActFaboutDate','',null,'0','1','true'};
        private String[] OrgId_type_info = new String[]{'OrgId','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'ActFaboutDate','OrgId','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    /*
    * Description :- Entry point for production query services
    * History :- 
    **/
    
    global class SFProdService_pt_pt {
    
        global String clientCertName_x;
        global String endpoint_x;
        global Map<String,String> inputHttpHeaders_x;
        global Map<String,String> outputHttpHeaders_x;
        global String clientCert_x;
        global String clientCertPasswd_x;
        global Integer timeout_x = 120000;
        
        private String[] ns_map_type_info = new String[]{'', 'GF_ProductionQueryStub'};
            
        global SFProdService_pt_pt(){
            if (Test.isRunningTest()){
                endpoint_x = 'https://test.foundryview.com/sfaia/soa-infra/services/SF/SFProdQueryService/SFProdQueryService_client_ep';
             } else { 
                    endpoint_x = GF_DQ_Settings__c.getValues('PRODUCTION_REPORT_END_POINT').Datawarehouse_wsdl__c;
                    if(Environment_Variable__c.getInstance('isDynamicQueryCertificateEnabled').value__c != 'false'){
                        clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
                    }
             }
        }
        
        global GF_ProductionQueryStub.ProcEprfResponse_element SFProcEprfService(String LotId,String InPrm1,
                                                                                 String InPrm2,String InPrm3,
                                                                                 String InPrm4,String InPrm5) {
            
            GF_ProductionQueryStub.ProcEprfRequest_element request_x = new GF_ProductionQueryStub.ProcEprfRequest_element();
            GF_ProductionQueryStub.ProcEprfResponse_element response_x;
            request_x.LotId = LotId;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.ProcEprfResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.ProcEprfResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'SFProcEprfService',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProcEprfRequest',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProcEprfResponse',
                  'GF_ProductionQueryStub.ProcEprfResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        // Wafer Start date service help to call wafer start date service sub report
        
        global GF_ProductionQueryStub.WaferStartResponse_element SFWaferStartService(String ActStartDate,String OrgId,
                                                                                     String InPrm1,String InPrm2,
                                                                                     String InPrm3,String InPrm4,
                                                                                     String InPrm5) {
                                                                                     
            GF_ProductionQueryStub.WaferStartRequest_element request_x = new GF_ProductionQueryStub.WaferStartRequest_element();
            GF_ProductionQueryStub.WaferStartResponse_element response_x;
            request_x.ActStartDate = ActStartDate;
            request_x.OrgId = OrgId;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.WaferStartResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.WaferStartResponse_element>();
            response_map_x.put('response_x', response_x);
            
            // Calling AIA service
            WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'SFWaferStartService',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'WaferStartRequest',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'WaferStartResponse',
                  'GF_ProductionQueryStub.WaferStartResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        // Wip Lot summary report subservice for production query
        
        global GF_ProductionQueryStub.ProdWIPLotSmryResponse_element SFProdWIPLotSmryService(String Fab,String InternalPartname,
                                                                                             String CustomerPartname,String LotID,
                                                                                             String LotType,String PONumber,
                                                                                             String ePRF,String CustomerInitial,
                                                                                             String InPrm1,String InPrm2,
                                                                                             String InPrm3,String InPrm4,
                                                                                             String InPrm5) {
            
            GF_ProductionQueryStub.ProdWIPLotSmryRequest_element request_x = new GF_ProductionQueryStub.ProdWIPLotSmryRequest_element();
            GF_ProductionQueryStub.ProdWIPLotSmryResponse_element response_x;
            request_x.Fab = Fab;
            request_x.InternalPartname = InternalPartname;
            request_x.CustomerPartname = CustomerPartname;
            request_x.LotID = LotID;
            request_x.LotType = LotType;
            request_x.PONumber = PONumber;
            request_x.ePRF = ePRF;
            request_x.CustomerInitial = CustomerInitial;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.ProdWIPLotSmryResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.ProdWIPLotSmryResponse_element>();
            response_map_x.put('response_x', response_x);
            
            // Calling AIA Service
            WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'SFProdWIPLotSmryService',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdWIPLotSmryRequest',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdWIPLotSmryResponse',
                  'GF_ProductionQueryStub.ProdWIPLotSmryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        // Calling production wip ship lot summary subreprot of production query
        global GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element SFProdWIPSHIPLotSmryService(String Fab,String InternalPartname,
                                                                                                     String CustomerPartname,String LotID,
                                                                                                     String LotType,String DateFrom,
                                                                                                     String DateTo,String PONumber,
                                                                                                     String ePRF,String CustomerInitial,
                                                                                                     String InPrm1,String InPrm2,
                                                                                                     String InPrm3,String InPrm4,
                                                                                                     String InPrm5) {
                                                                                                     
            GF_ProductionQueryStub.ProdWIPSHIPLotSmryRequest_element request_x = new GF_ProductionQueryStub.ProdWIPSHIPLotSmryRequest_element();
            GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element response_x;
            request_x.Fab = Fab;
            request_x.InternalPartname = InternalPartname;
            request_x.CustomerPartname = CustomerPartname;
            request_x.LotID = LotID;
            request_x.LotType = LotType;
            request_x.DateFrom = DateFrom;
            request_x.DateTo = DateTo;
            request_x.PONumber = PONumber;
            request_x.ePRF = ePRF;
            request_x.CustomerInitial = CustomerInitial;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element>();
            response_map_x.put('response_x', response_x);
            
            // Service call to AIA
            WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'SFProdWIPSHIPLotSmryService',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdWIPSHIPLotSmryRequest',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdWIPSHIPLotSmryResponse',
                  'GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        // Calling production lot summary Service
         
        global GF_ProductionQueryStub.ProdLotStrtSmryResponse_element SFProdLotStrtSmryService(String Fab,String InternalPartname,String CustomerPartname,String LotID,String LotType,String DateFrom,String DateTo,String PONumber,String ePRF,String CustomerInitial,String InPrm1,String InPrm2,String InPrm3,String InPrm4,String InPrm5) {
            GF_ProductionQueryStub.ProdLotStrtSmryRequest_element request_x = new GF_ProductionQueryStub.ProdLotStrtSmryRequest_element();
            GF_ProductionQueryStub.ProdLotStrtSmryResponse_element response_x;
            request_x.Fab = Fab;
            request_x.InternalPartname = InternalPartname;
            request_x.CustomerPartname = CustomerPartname;
            request_x.LotID = LotID;
            request_x.LotType = LotType;
            request_x.DateFrom = DateFrom;
            request_x.DateTo = DateTo;
            request_x.PONumber = PONumber;
            request_x.ePRF = ePRF;
            request_x.CustomerInitial = CustomerInitial;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.ProdLotStrtSmryResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.ProdLotStrtSmryResponse_element>();
            response_map_x.put('response_x', response_x);
            
            // Service call to AIA
            WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'SFProdLotStrtSmryService',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdLotStrtSmryRequest',
                  'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
                  'ProdLotStrtSmryResponse',
                  'GF_ProductionQueryStub.ProdLotStrtSmryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        global GF_ProductionQueryStub.RunSheetResponse_element SFRunSheetService(String ProcId,String StageName,String StageOrder,String InPrm1,String InPrm2,String InPrm3,String InPrm4,String InPrm5) {
            GF_ProductionQueryStub.RunSheetRequest_element request_x = new GF_ProductionQueryStub.RunSheetRequest_element();
            GF_ProductionQueryStub.RunSheetResponse_element response_x;
            request_x.ProcId = ProcId;
            request_x.StageName = StageName;
            request_x.StageOrder = StageOrder;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.RunSheetResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.RunSheetResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'SFRunSheetService',
              'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
              'RunSheetRequest',
              'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
              'RunSheetResponse',
              'GF_ProductionQueryStub.RunSheetResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        
        global GF_ProductionQueryStub.FabOutLocationResponse_element SFFabOutLocationService(String ActFaboutDate,String OrgId,String InPrm1,String InPrm2,String InPrm3,String InPrm4,String InPrm5) {
            GF_ProductionQueryStub.FabOutLocationRequest_element request_x = new GF_ProductionQueryStub.FabOutLocationRequest_element();
            GF_ProductionQueryStub.FabOutLocationResponse_element response_x;
            request_x.ActFaboutDate = ActFaboutDate;
            request_x.OrgId = OrgId;
            request_x.InPrm1 = InPrm1;
            request_x.InPrm2 = InPrm2;
            request_x.InPrm3 = InPrm3;
            request_x.InPrm4 = InPrm4;
            request_x.InPrm5 = InPrm5;
            Map<String, GF_ProductionQueryStub.FabOutLocationResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.FabOutLocationResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'SFFabOutLocationService',
              'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
              'FabOutLocationRequest',
              'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService',
              'FabOutLocationResponse',
              'GF_ProductionQueryStub.FabOutLocationResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    
    global class ProdLotStrtSmryResponse_element {
        global GF_ProductionQueryStub.ProdLotStrtSmryType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    
    global class RunSheetResponse_element {
        global GF_ProductionQueryStub.RunSheetResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    
    global class ProdWIPSHIPLotSmryResponseType {
        global String GEOMETRY_NAME{get;set;}
        global String FAB{get;set;}
        global String PROCESS_NAME{get;set;}
        global String ORG_ID{get;set;}
        global String MES_PART_NAME{get;set;}
        global String CHARTERED_PART_NAME{get;set;}
        global String CUSTOMER_PART_NAME{get;set;}
        global String LOTID{get;set;}
        global String LOT_WFR_QTY{get;set;}
        global String LOT_TYPE_DESC{get;set;}
        global String LOT_PRIORITY{get;set;}
        global String STG_HYPR{get;set;}
        global String PRCD_ID{get;set;}
        global String STAGE_NAME{get;set;}
        global String STAGE_ORDER{get;set;}
        global String LOT_STATE{get;set;}
        global String LOCATION{get;set;}
        global Integer CURRENT_MASK{get;set;}
        global Integer BALANCE_MASK{get;set;}
        global String ACT_FABOUT_DATE{get;set;}
        global String ETEST_DATE{get;set;}
        global String SOURCE_TYPE{get;set;}
        global String SHIP_DATE{get;set;}
        global String CUSTOMER_ID{get;set;}
        global String SO{get;set;}
        global String SO_HYPR{get;set;}
        global String PO{get;set;}
        global String PO_LINENUM{get;set;}
        global String OSD{get;set;}
        global String CSD{get;set;}
        global String CRD{get;set;}
        global String SHIP_TO_LOCATION{get;set;}
        global String EPRF{get;set;}
        global String CUSTOMER_INITIAL{get;set;}
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] GEOMETRY_NAME_type_info = new String[]{'GEOMETRY_NAME','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] PROCESS_NAME_type_info = new String[]{'PROCESS_NAME','',null,'1','1','false'};
        private String[] ORG_ID_type_info = new String[]{'ORG_ID','',null,'1','1','false'};
        private String[] MES_PART_NAME_type_info = new String[]{'MES_PART_NAME','',null,'1','1','false'};
        private String[] CHARTERED_PART_NAME_type_info = new String[]{'CHARTERED_PART_NAME','',null,'1','1','false'};
        private String[] CUSTOMER_PART_NAME_type_info = new String[]{'CUSTOMER_PART_NAME','',null,'1','1','false'};
        private String[] LOTID_type_info = new String[]{'LOTID','',null,'1','1','false'};
        private String[] LOT_WFR_QTY_type_info = new String[]{'LOT_WFR_QTY','',null,'1','1','false'};
        private String[] LOT_TYPE_DESC_type_info = new String[]{'LOT_TYPE_DESC','',null,'1','1','false'};
        private String[] LOT_PRIORITY_type_info = new String[]{'LOT_PRIORITY','',null,'1','1','false'};
        private String[] STG_HYPR_type_info = new String[]{'STG_HYPR','',null,'1','1','false'};
        private String[] PRCD_ID_type_info = new String[]{'PRCD_ID','',null,'1','1','false'};
        private String[] STAGE_NAME_type_info = new String[]{'STAGE_NAME','',null,'1','1','false'};
        private String[] STAGE_ORDER_type_info = new String[]{'STAGE_ORDER','',null,'1','1','false'};
        private String[] LOT_STATE_type_info = new String[]{'LOT_STATE','',null,'1','1','false'};
        private String[] LOCATION_type_info = new String[]{'LOCATION','',null,'1','1','false'};
        private String[] CURRENT_MASK_type_info = new String[]{'CURRENT_MASK','',null,'1','1','false'};
        private String[] BALANCE_MASK_type_info = new String[]{'BALANCE_MASK','',null,'1','1','false'};
        private String[] ACT_FABOUT_DATE_type_info = new String[]{'ACT_FABOUT_DATE','',null,'1','1','false'};
        private String[] ETEST_DATE_type_info = new String[]{'ETEST_DATE','',null,'1','1','false'};
        private String[] SOURCE_TYPE_type_info = new String[]{'SOURCE_TYPE','',null,'1','1','false'};
        private String[] SHIP_DATE_type_info = new String[]{'SHIP_DATE','',null,'1','1','false'};
        private String[] CUSTOMER_ID_type_info = new String[]{'CUSTOMER_ID','',null,'1','1','false'};
        private String[] SO_type_info = new String[]{'SO','',null,'1','1','false'};
        private String[] SO_HYPR_type_info = new String[]{'SO_HYPR','',null,'1','1','false'};
        private String[] PO_type_info = new String[]{'PO','',null,'1','1','false'};
        private String[] PO_LINENUM_type_info = new String[]{'PO_LINENUM','',null,'1','1','false'};
        private String[] OSD_type_info = new String[]{'OSD','',null,'1','1','false'};
        private String[] CSD_type_info = new String[]{'CSD','',null,'1','1','false'};
        private String[] CRD_type_info = new String[]{'CRD','',null,'1','1','false'};
        private String[] SHIP_TO_LOCATION_type_info = new String[]{'SHIP_TO_LOCATION','',null,'1','1','false'};
        private String[] EPRF_type_info = new String[]{'EPRF','',null,'1','1','false'};
        private String[] CUSTOMER_INITIAL_type_info = new String[]{'CUSTOMER_INITIAL','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'GEOMETRY_NAME','FAB','PROCESS_NAME','ORG_ID','MES_PART_NAME','CHARTERED_PART_NAME','CUSTOMER_PART_NAME','LOTID','LOT_WFR_QTY','LOT_TYPE_DESC','LOT_PRIORITY','STG_HYPR','PRCD_ID','STAGE_NAME','STAGE_ORDER','LOT_STATE','LOCATION','CURRENT_MASK','BALANCE_MASK','ACT_FABOUT_DATE','ETEST_DATE','SOURCE_TYPE','SHIP_DATE','CUSTOMER_ID','SO','SO_HYPR','PO','PO_LINENUM','OSD','CSD','CRD','SHIP_TO_LOCATION','EPRF','CUSTOMER_INITIAL','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    global class WaferStartResponse_element {
        global GF_ProductionQueryStub.WaferStartResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    global class RunSheetResponseType {
        global String STAGE_NAME{get;set;}
        global String MASK_LAYER{get;set;}
        global String STAGE_ORDER{get;set;}
        global String PRM1;
        global String PRM2;
        global String PRM3;
        global String PRM4;
        global String PRM5;
        private String[] STAGE_NAME_type_info = new String[]{'STAGE_NAME','',null,'1','1','false'};
        private String[] MASK_LAYER_type_info = new String[]{'MASK_LAYER','',null,'1','1','false'};
        private String[] STAGE_ORDER_type_info = new String[]{'STAGE_ORDER','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'STAGE_NAME','MASK_LAYER','STAGE_ORDER','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class ProdWIPSHIPLotSmryResponse_element {
        global GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    
    global class RunSheetRequest_element {
        global String ProcId;
        global String StageName;
        global String StageOrder;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] ProcId_type_info = new String[]{'ProcId','',null,'0','1','true'};
        private String[] StageName_type_info = new String[]{'StageName','',null,'0','1','true'};
        private String[] StageOrder_type_info = new String[]{'StageOrder','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'ProcId','StageName','StageOrder','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class ProdLotStrtSmryRequest_element {
        global String Fab;
        global String InternalPartname;
        global String CustomerPartname;
        global String LotID;
        global String LotType;
        global String DateFrom;
        global String DateTo;
        global String PONumber;
        global String ePRF;
        global String CustomerInitial;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] Fab_type_info = new String[]{'Fab','',null,'0','1','true'};
        private String[] InternalPartname_type_info = new String[]{'InternalPartname','',null,'0','1','true'};
        private String[] CustomerPartname_type_info = new String[]{'CustomerPartname','',null,'0','1','true'};
        private String[] LotID_type_info = new String[]{'LotID','',null,'0','1','true'};
        private String[] LotType_type_info = new String[]{'LotType','',null,'0','1','true'};
        private String[] DateFrom_type_info = new String[]{'DateFrom','',null,'0','1','true'};
        private String[] DateTo_type_info = new String[]{'DateTo','',null,'0','1','true'};
        private String[] PONumber_type_info = new String[]{'PONumber','',null,'0','1','true'};
        private String[] ePRF_type_info = new String[]{'ePRF','',null,'0','1','true'};
        private String[] CustomerInitial_type_info = new String[]{'CustomerInitial','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'Fab','InternalPartname','CustomerPartname','LotID','LotType','DateFrom','DateTo','PONumber','ePRF','CustomerInitial','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class ProdWIPLotSmryResponseType {
        global String GEOMETRY_NAME {get;set;}
        global String FAB{get;set;}
        global String PROCESS_NAME{get;set;}
        global String ORG_ID{get;set;}
        global String CHARTERED_PART_NAME{get;set;}
        global String MES_PART_NAME{get;set;}
        global String CUSTOMER_PART_NAME{get;set;}
        global String LOTID{get;set;}
        global String LOT_WFR_QTY{get;set;}
        global String LOT_PRIORITY{get;set;}
        global String LOT_TYPE_DESC{get;set;}
        global String STG_HYPR{get;set;}
        global String STG_HYPR0{get;set;}
        global String STG_HYPR1{get;set;}
        global String STAGE_NAME{get;set;}
        global String LOT_STATE{get;set;}
        global String LOCATION{get;set;}
        global String CURRENT_MASK{get;set;}
        global String BALANCE_MASK{get;set;}
        global String ACT_FABOUT_DATE{get;set;}
        global String ETEST_DATE{get;set;}
        global String SHIP_DATE{get;set;}
        global String CUSTOMER_ID{get;set;}
        global String PO{get;set;}
        global String PO_HYPR{get;set;}
        global String SO{get;set;}
        global String OSD{get;set;}
        global String CSD{get;set;}
        global String CRD{get;set;}
        global String SHIP_TO_LOCATION{get;set;}
        global String EPRF{get;set;}
        global String CUSTOMER_INITIAL{get;set;}
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] GEOMETRY_NAME_type_info = new String[]{'GEOMETRY_NAME','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] PROCESS_NAME_type_info = new String[]{'PROCESS_NAME','',null,'1','1','false'};
        private String[] ORG_ID_type_info = new String[]{'ORG_ID','',null,'1','1','false'};
        private String[] CHARTERED_PART_NAME_type_info = new String[]{'CHARTERED_PART_NAME','',null,'1','1','false'};
        private String[] MES_PART_NAME_type_info = new String[]{'MES_PART_NAME','',null,'1','1','false'};
        private String[] CUSTOMER_PART_NAME_type_info = new String[]{'CUSTOMER_PART_NAME','',null,'1','1','false'};
        private String[] LOTID_type_info = new String[]{'LOTID','',null,'1','1','false'};
        private String[] LOT_WFR_QTY_type_info = new String[]{'LOT_WFR_QTY','',null,'1','1','false'};
        private String[] LOT_PRIORITY_type_info = new String[]{'LOT_PRIORITY','',null,'1','1','false'};
        private String[] LOT_TYPE_DESC_type_info = new String[]{'LOT_TYPE_DESC','',null,'1','1','false'};
        private String[] STG_HYPR_type_info = new String[]{'STG_HYPR','',null,'1','1','false'};
        private String[] STG_HYPR0_type_info = new String[]{'STG_HYPR0','',null,'1','1','false'};
        private String[] STG_HYPR1_type_info = new String[]{'STG_HYPR1','',null,'1','1','false'};
        private String[] STAGE_NAME_type_info = new String[]{'STAGE_NAME','',null,'1','1','false'};
        private String[] LOT_STATE_type_info = new String[]{'LOT_STATE','',null,'1','1','false'};
        private String[] LOCATION_type_info = new String[]{'LOCATION','',null,'1','1','false'};
        private String[] CURRENT_MASK_type_info = new String[]{'CURRENT_MASK','',null,'1','1','false'};
        private String[] BALANCE_MASK_type_info = new String[]{'BALANCE_MASK','',null,'1','1','false'};
        private String[] ACT_FABOUT_DATE_type_info = new String[]{'ACT_FABOUT_DATE','',null,'1','1','false'};
        private String[] ETEST_DATE_type_info = new String[]{'ETEST_DATE','',null,'1','1','false'};
        private String[] SHIP_DATE_type_info = new String[]{'SHIP_DATE','',null,'1','1','false'};
        private String[] CUSTOMER_ID_type_info = new String[]{'CUSTOMER_ID','',null,'1','1','false'};
        private String[] PO_type_info = new String[]{'PO','',null,'1','1','false'};
        private String[] PO_HYPR_type_info = new String[]{'PO_HYPR','',null,'1','1','false'};
        private String[] SO_type_info = new String[]{'SO','',null,'1','1','false'};
        private String[] OSD_type_info = new String[]{'OSD','',null,'1','1','false'};
        private String[] CSD_type_info = new String[]{'CSD','',null,'1','1','false'};
        private String[] CRD_type_info = new String[]{'CRD','',null,'1','1','false'};
        private String[] SHIP_TO_LOCATION_type_info = new String[]{'SHIP_TO_LOCATION','',null,'1','1','false'};
        private String[] EPRF_type_info = new String[]{'EPRF','',null,'1','1','false'};
        private String[] CUSTOMER_INITIAL_type_info = new String[]{'CUSTOMER_INITIAL','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'GEOMETRY_NAME','FAB','PROCESS_NAME','ORG_ID','CHARTERED_PART_NAME','MES_PART_NAME','CUSTOMER_PART_NAME','LOTID','LOT_WFR_QTY','LOT_PRIORITY','LOT_TYPE_DESC','STG_HYPR','STG_HYPR0','STG_HYPR1','STAGE_NAME','LOT_STATE','LOCATION','CURRENT_MASK','BALANCE_MASK','ACT_FABOUT_DATE','ETEST_DATE','SHIP_DATE','CUSTOMER_ID','PO','PO_HYPR','SO','OSD','CSD','CRD','SHIP_TO_LOCATION','EPRF','CUSTOMER_INITIAL','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class ProdWIPLotSmryRequest_element {
        global String Fab;
        global String InternalPartname;
        global String CustomerPartname;
        global String LotID;
        global String LotType;
        global String PONumber;
        global String ePRF;
        global String CustomerInitial;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] Fab_type_info = new String[]{'Fab','',null,'0','1','true'};
        private String[] InternalPartname_type_info = new String[]{'InternalPartname','',null,'0','1','true'};
        private String[] CustomerPartname_type_info = new String[]{'CustomerPartname','',null,'0','1','true'};
        private String[] LotID_type_info = new String[]{'LotID','',null,'0','1','true'};
        private String[] LotType_type_info = new String[]{'LotType','',null,'0','1','true'};
        private String[] PONumber_type_info = new String[]{'PONumber','',null,'0','1','true'};
        private String[] ePRF_type_info = new String[]{'ePRF','',null,'0','1','true'};
        private String[] CustomerInitial_type_info = new String[]{'CustomerInitial','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'Fab','InternalPartname','CustomerPartname','LotID','LotType','PONumber','ePRF','CustomerInitial','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class FabOutLocationResponse_element {
        global GF_ProductionQueryStub.FabOutLocationResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    
    global class ProcEprfResponse_element {
        global GF_ProductionQueryStub.ProcEprfResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
    
    global class ProcEprfRequest_element {
        global String LotId;
        global String InPrm1;
        global String InPrm2;
        global String InPrm3;
        global String InPrm4;
        global String InPrm5;
        private String[] LotId_type_info = new String[]{'LotId','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'LotId','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class ProdLotStrtSmryType {
    
        global String GEOMETRY_NAME {get;set;}
        global String FAB {get;set;}
        global String PROCESS_NAME{get;set;}
        global String CHARTERED_PART_NAME{get;set;}
        global String CUSTOMER_PART_NAME{get;set;}
        global String LOTID{get;set;}
        global String LOT_WFR_QTY{get;set;}
        global String LOT_TYPE_DESC{get;set;}
        global String LOT_PRIORITY{get;set;}
        
        global String STAGE_NAME{get;set;}
        global String LOT_STATE{get;set;}
        global String LOCATION{get;set;}
        global String CURRENT_MASK{get;set;}
        global String BALANCE_MASK{get;set;}
        global String ACT_START_DATE{get;set;}
        global String ACT_FABOUT_DATE{get;set;}
        global String ETEST_DATE{get;set;}
        global String SHIP_DATE{get;set;}
        global String PO{get;set;}
        
        global String SO{get;set;}
        global String OSD{get;set;}
        global String CSD{get;set;}
        global String CRD{get;set;}
        global String SHIP_TO_LOCATION{get;set;}
        global String EPRF{get;set;}
        global String ORG_ID{get;set;}
        global String MES_PART_NAME{get;set;}
        global String STG_HYPR{get;set;}
        global String STG_HYPR0{get;set;}
        global String STG_HYPR1{get;set;}
        global String PO_HYPR{get;set;}
        global String CUSTOMER_INITIAL{get;set;}
        global String CUSTOMER_ID{get;set;}
        
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] GEOMETRY_NAME_type_info = new String[]{'GEOMETRY_NAME','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] PROCESS_NAME_type_info = new String[]{'PROCESS_NAME','',null,'1','1','false'};
        private String[] ORG_ID_type_info = new String[]{'ORG_ID','',null,'1','1','false'};
        private String[] MES_PART_NAME_type_info = new String[]{'MES_PART_NAME','',null,'1','1','false'};
        private String[] CHARTERED_PART_NAME_type_info = new String[]{'CHARTERED_PART_NAME','',null,'1','1','false'};
        private String[] CUSTOMER_PART_NAME_type_info = new String[]{'CUSTOMER_PART_NAME','',null,'1','1','false'};
        private String[] LOTID_type_info = new String[]{'LOTID','',null,'1','1','false'};
        private String[] LOT_WFR_QTY_type_info = new String[]{'LOT_WFR_QTY','',null,'1','1','false'};
        private String[] LOT_PRIORITY_type_info = new String[]{'LOT_PRIORITY','',null,'1','1','false'};
        private String[] LOT_TYPE_DESC_type_info = new String[]{'LOT_TYPE_DESC','',null,'1','1','false'};
        private String[] STG_HYPR_type_info = new String[]{'STG_HYPR','',null,'1','1','false'};
        private String[] STG_HYPR0_type_info = new String[]{'STG_HYPR0','',null,'1','1','false'};
        private String[] STG_HYPR1_type_info = new String[]{'STG_HYPR1','',null,'1','1','false'};
        private String[] STAGE_NAME_type_info = new String[]{'STAGE_NAME','',null,'1','1','false'};
        private String[] LOT_STATE_type_info = new String[]{'LOT_STATE','',null,'1','1','false'};
        private String[] LOCATION_type_info = new String[]{'LOCATION','',null,'1','1','false'};
        private String[] CURRENT_MASK_type_info = new String[]{'CURRENT_MASK','',null,'1','1','false'};
        private String[] BALANCE_MASK_type_info = new String[]{'BALANCE_MASK','',null,'1','1','false'};
        private String[] ACT_START_DATE_type_info = new String[]{'ACT_START_DATE','',null,'1','1','false'};
        private String[] ACT_FABOUT_DATE_type_info = new String[]{'ACT_FABOUT_DATE','',null,'1','1','false'};
        private String[] ETEST_DATE_type_info = new String[]{'ETEST_DATE','',null,'1','1','false'};
        private String[] SHIP_DATE_type_info = new String[]{'SHIP_DATE','',null,'1','1','false'};
        private String[] PO_type_info = new String[]{'PO','',null,'1','1','false'};
        private String[] PO_HYPR_type_info = new String[]{'PO_HYPR','',null,'1','1','false'};
        private String[] SO_type_info = new String[]{'SO','',null,'1','1','false'};
        private String[] OSD_type_info = new String[]{'OSD','',null,'1','1','false'};
        private String[] CSD_type_info = new String[]{'CSD','',null,'1','1','false'};
        private String[] CRD_type_info = new String[]{'CRD','',null,'1','1','false'};
        private String[] SHIP_TO_LOCATION_type_info = new String[]{'SHIP_TO_LOCATION','',null,'1','1','false'};
        private String[] EPRF_type_info = new String[]{'EPRF','',null,'1','1','false'};
        private String[] CUSTOMER_INITIAL_type_info = new String[]{'CUSTOMER_INITIAL','',null,'1','1','false'};
        private String[] CUSTOMER_ID_type_info = new String[]{'CUSTOMER_ID','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'GEOMETRY_NAME','FAB','PROCESS_NAME','ORG_ID','MES_PART_NAME','CHARTERED_PART_NAME','CUSTOMER_PART_NAME','LOTID','LOT_WFR_QTY','LOT_PRIORITY','LOT_TYPE_DESC','STG_HYPR','STG_HYPR0','STG_HYPR1','STAGE_NAME','LOT_STATE','LOCATION','CURRENT_MASK','BALANCE_MASK','ACT_START_DATE','ACT_FABOUT_DATE','ETEST_DATE','SHIP_DATE','PO','PO_HYPR','SO','OSD','CSD','CRD','SHIP_TO_LOCATION','EPRF','CUSTOMER_INITIAL','CUSTOMER_ID','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class FabOutLocationResponseType {
    
        global String PRCD_NAME{get;set;}
        global String PART_ID_HYPR{get;set;}
        global String CHARTERED_PART_NAME{get;set;}
        global String LOTID{get;set;}
        global String LOT_PRIORITY{get;set;}
        global String LOT_TYPE{get;set;}
        global String START_LOT_QTY{get;set;}
        global String CURRENT_LOT_QTY{get;set;}
        global String SO{get;set;}
        global String PO{get;set;}
        global String PO_HYPR{get;set;}
        global String GEOMETRY_NAME{get;set;}
        global String CRD{get;set;}
        global String FAB{get;set;}
        global String CUSTOMER_PART_NAME{get;set;}
        global String LOT_START_DATE{get;set;}
        global String ACTUAL_FAB_OUT_DATE{get;set;}
        global String OSD{get;set;}
        global String CSD{get;set;}
        global String PRF_ID{get;set;}
        global String ORG_ID{get;set;}
        global String CUSTOMER_ID{get;set;}
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] PRCD_NAME_type_info = new String[]{'PRCD_NAME','',null,'1','1','false'};
        private String[] PART_ID_HYPR_type_info = new String[]{'PART_ID_HYPR','',null,'1','1','false'};
        private String[] CHARTERED_PART_NAME_type_info = new String[]{'CHARTERED_PART_NAME','',null,'1','1','false'};
        private String[] LOTID_type_info = new String[]{'LOTID','',null,'1','1','false'};
        private String[] LOT_PRIORITY_type_info = new String[]{'LOT_PRIORITY','',null,'1','1','false'};
        private String[] LOT_TYPE_type_info = new String[]{'LOT_TYPE','',null,'1','1','false'};
        private String[] START_LOT_QTY_type_info = new String[]{'START_LOT_QTY','',null,'1','1','false'};
        private String[] CURRENT_LOT_QTY_type_info = new String[]{'CURRENT_LOT_QTY','',null,'1','1','false'};
        private String[] SO_type_info = new String[]{'SO','',null,'1','1','false'};
        private String[] PO_type_info = new String[]{'PO','',null,'1','1','false'};
        private String[] PO_HYPR_type_info = new String[]{'PO_HYPR','',null,'1','1','false'};
        private String[] GEOMETRY_NAME_type_info = new String[]{'GEOMETRY_NAME','',null,'1','1','false'};
        private String[] CRD_type_info = new String[]{'CRD','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] CUSTOMER_PART_NAME_type_info = new String[]{'CUSTOMER_PART_NAME','',null,'1','1','false'};
        private String[] LOT_START_DATE_type_info = new String[]{'LOT_START_DATE','',null,'1','1','false'};
        private String[] ACTUAL_FAB_OUT_DATE_type_info = new String[]{'ACTUAL_FAB_OUT_DATE','',null,'1','1','false'};
        private String[] OSD_type_info = new String[]{'OSD','',null,'1','1','false'};
        private String[] CSD_type_info = new String[]{'CSD','',null,'1','1','false'};
        private String[] PRF_ID_type_info = new String[]{'PRF_ID','',null,'1','1','false'};
        private String[] ORG_ID_type_info = new String[]{'ORG_ID','',null,'1','1','false'};
        private String[] CUSTOMER_ID_type_info = new String[]{'CUSTOMER_ID','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'PRCD_NAME','PART_ID_HYPR','CHARTERED_PART_NAME','LOTID','LOT_PRIORITY','LOT_TYPE','START_LOT_QTY','CURRENT_LOT_QTY','SO','PO','PO_HYPR','GEOMETRY_NAME','CRD','FAB','CUSTOMER_PART_NAME','LOT_START_DATE','ACTUAL_FAB_OUT_DATE','OSD','CSD','PRF_ID','ORG_ID','CUSTOMER_ID','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class ProdWIPSHIPLotSmryRequest_element {
        global String Fab{get;set;}
        global String InternalPartname{get;set;}
        global String CustomerPartname{get;set;}
        global String LotID{get;set;}
        global String LotType{get;set;}
        global String DateFrom{get;set;}
        global String DateTo{get;set;}
        global String PONumber{get;set;}
        global String ePRF{get;set;}
        global String CustomerInitial{get;set;}
        global String InPrm1{get;set;}
        global String InPrm2{get;set;}
        global String InPrm3{get;set;}
        global String InPrm4{get;set;}
        global String InPrm5{get;set;}
        private String[] Fab_type_info = new String[]{'Fab','',null,'0','1','true'};
        private String[] InternalPartname_type_info = new String[]{'InternalPartname','',null,'0','1','true'};
        private String[] CustomerPartname_type_info = new String[]{'CustomerPartname','',null,'0','1','true'};
        private String[] LotID_type_info = new String[]{'LotID','',null,'0','1','true'};
        private String[] LotType_type_info = new String[]{'LotType','',null,'0','1','true'};
        private String[] DateFrom_type_info = new String[]{'DateFrom','',null,'0','1','true'};
        private String[] DateTo_type_info = new String[]{'DateTo','',null,'0','1','true'};
        private String[] PONumber_type_info = new String[]{'PONumber','',null,'0','1','true'};
        private String[] ePRF_type_info = new String[]{'ePRF','',null,'0','1','true'};
        private String[] CustomerInitial_type_info = new String[]{'CustomerInitial','',null,'0','1','true'};
        private String[] InPrm1_type_info = new String[]{'InPrm1','',null,'0','1','true'};
        private String[] InPrm2_type_info = new String[]{'InPrm2','',null,'0','1','true'};
        private String[] InPrm3_type_info = new String[]{'InPrm3','',null,'0','1','true'};
        private String[] InPrm4_type_info = new String[]{'InPrm4','',null,'0','1','true'};
        private String[] InPrm5_type_info = new String[]{'InPrm5','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'Fab','InternalPartname','CustomerPartname','LotID','LotType','DateFrom','DateTo','PONumber','ePRF','CustomerInitial','InPrm1','InPrm2','InPrm3','InPrm4','InPrm5'};
    }
    
    global class ProcEprfResponseType {
        global String PRF_ID_HYPR{get;set;}
        global String PRF_ID{get;set;}
        global String LOT_ID{get;set;}
        global String WAFER_ID{get;set;}
        global String EDITOR{get;set;}
        global String FAB{get;set;}
        global String CREATE_DATE{get;set;}
        global String STATUS{get;set;}
        global String EDITED_DATE{get;set;}
        global String APPROVEDBY{get;set;}
        global String APPROVEDDATE{get;set;}
        global String EXECUTEDBY{get;set;}
        global String EXECUTEDDATE{get;set;}
        global String CLOSEDBY{get;set;}
        global String CLOSEDDATE{get;set;}
        global String DEVICE_ID{get;set;}
        global String PRECEDE_PRF{get;set;}
        global String PROCESS_ID{get;set;}
        global String STAGE_ID{get;set;}
        global String LOGISTIC_ACTION{get;set;}
        global String NONLOGISTIC_ACTION{get;set;}
        global String PRM1{get;set;}
        global String PRM2{get;set;}
        global String PRM3{get;set;}
        global String PRM4{get;set;}
        global String PRM5{get;set;}
        private String[] PRF_ID_HYPR_type_info = new String[]{'PRF_ID_HYPR','',null,'1','1','false'};
        private String[] PRF_ID_type_info = new String[]{'PRF_ID','',null,'1','1','false'};
        private String[] LOT_ID_type_info = new String[]{'LOT_ID','',null,'1','1','false'};
        private String[] WAFER_ID_type_info = new String[]{'WAFER_ID','',null,'1','1','false'};
        private String[] EDITOR_type_info = new String[]{'EDITOR','',null,'1','1','false'};
        private String[] FAB_type_info = new String[]{'FAB','',null,'1','1','false'};
        private String[] CREATE_DATE_type_info = new String[]{'CREATE_DATE','',null,'1','1','false'};
        private String[] STATUS_type_info = new String[]{'STATUS','',null,'1','1','false'};
        private String[] EDITED_DATE_type_info = new String[]{'EDITED_DATE','',null,'1','1','false'};
        private String[] APPROVEDBY_type_info = new String[]{'APPROVEDBY','',null,'1','1','false'};
        private String[] APPROVEDDATE_type_info = new String[]{'APPROVEDDATE','',null,'1','1','false'};
        private String[] EXECUTEDBY_type_info = new String[]{'EXECUTEDBY','',null,'1','1','false'};
        private String[] EXECUTEDDATE_type_info = new String[]{'EXECUTEDDATE','',null,'1','1','false'};
        private String[] CLOSEDBY_type_info = new String[]{'CLOSEDBY','',null,'1','1','false'};
        private String[] CLOSEDDATE_type_info = new String[]{'CLOSEDDATE','',null,'1','1','false'};
        private String[] DEVICE_ID_type_info = new String[]{'DEVICE_ID','',null,'1','1','false'};
        private String[] PRECEDE_PRF_type_info = new String[]{'PRECEDE_PRF','',null,'1','1','false'};
        private String[] PROCESS_ID_type_info = new String[]{'PROCESS_ID','',null,'1','1','false'};
        private String[] STAGE_ID_type_info = new String[]{'STAGE_ID','',null,'1','1','false'};
        private String[] LOGISTIC_ACTION_type_info = new String[]{'LOGISTIC_ACTION','',null,'1','1','false'};
        private String[] NONLOGISTIC_ACTION_type_info = new String[]{'NONLOGISTIC_ACTION','',null,'1','1','false'};
        private String[] PRM1_type_info = new String[]{'PRM1','',null,'1','1','false'};
        private String[] PRM2_type_info = new String[]{'PRM2','',null,'1','1','false'};
        private String[] PRM3_type_info = new String[]{'PRM3','',null,'1','1','false'};
        private String[] PRM4_type_info = new String[]{'PRM4','',null,'1','1','false'};
        private String[] PRM5_type_info = new String[]{'PRM5','',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'PRF_ID_HYPR','PRF_ID','LOT_ID','WAFER_ID','EDITOR','FAB','CREATE_DATE','STATUS','EDITED_DATE','APPROVEDBY','APPROVEDDATE','EXECUTEDBY','EXECUTEDDATE','CLOSEDBY','CLOSEDDATE','DEVICE_ID','PRECEDE_PRF','PROCESS_ID','STAGE_ID','LOGISTIC_ACTION','NONLOGISTIC_ACTION','PRM1','PRM2','PRM3','PRM4','PRM5'};
    }
    
    global class ProdWIPLotSmryResponse_element {
        global GF_ProductionQueryStub.ProdWIPLotSmryResponseType[] OUTPUTTABLE;
        global String ERROR;
        private String[] OUTPUTTABLE_type_info = new String[]{'OUTPUTTABLE','',null,'0','-1','false'};
        private String[] ERROR_type_info = new String[]{'ERROR','',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/BusinessObject_jws/SFProdQueryService/SFProdQueryService','true','false'};
        private String[] field_order_type_info = new String[]{'OUTPUTTABLE','ERROR'};
    }
}