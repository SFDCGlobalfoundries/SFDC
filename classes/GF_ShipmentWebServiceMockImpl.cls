@isTest
global class GF_ShipmentWebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        
        // Code handles request/response for Shipment main query
           
        Map<String, GF_SF_Stub.ShipDetailResponse_element> response_map_x = new Map<String, GF_SF_Stub.ShipDetailResponse_element>();
                                                                                 
        GF_SF_Stub.ShipDetailResponse_element shipDetailResponse = new GF_SF_Stub.ShipDetailResponse_element();
        
        GF_SF_Stub.ShipInfo_element shipInfoElement = new GF_SF_Stub.ShipInfo_element();
        shipInfoElement.FAB = 'FAB1';
                
        List<GF_SF_Stub.ShipInfo_element> shipInfoElementList = new List<GF_SF_Stub.ShipInfo_element>();
        shipInfoElementList.add(shipInfoElement);
        
        shipDetailResponse.Error = '101';
        shipDetailResponse.ShipInfo = shipInfoElementList;
                                                                                  
        GF_SF_Stub.ShipDetailResponse_element response_x = shipDetailResponse;                                                                         
        response_map_x.put('response_x', response_x);
        
        // Code handles getWfrReport test coverage
        Map<String, GF_SF_Stub.ShipmentDetailResponse_element> detail_response_map_x = new Map<String, GF_SF_Stub.ShipmentDetailResponse_element>();
        GF_SF_Stub.ShipmentDetailResponse_element shipDetailResponseElement = new GF_SF_Stub.ShipmentDetailResponse_element();
        
        GF_SF_Stub.ShipmentDetailInfo_element shipDetailInfoElement = new GF_SF_Stub.ShipmentDetailInfo_element();
        shipDetailInfoElement.PO = '1111';
        
        List<GF_SF_Stub.ShipmentDetailInfo_element> shipDetailInfoElementList = new List<GF_SF_Stub.ShipmentDetailInfo_element>();
        shipDetailInfoElementList.add(shipDetailInfoElement);
        
        shipDetailResponseElement.Error = '101';
        shipDetailResponseElement.ShipmentDetailInfo = shipDetailInfoElementList;
        
        GF_SF_Stub.ShipmentDetailResponse_element detail_Response_x = shipDetailResponseElement;
        detail_response_map_x.put('response_x',detail_Response_x);
        
        // Code handles getShipdate test coverage 
         Map<String, GF_SF_Stub.ShipmentAlertResponse_element> alert_response_map_x = new Map<String, GF_SF_Stub.ShipmentAlertResponse_element>();
         GF_SF_Stub.ShipmentAlertResponse_element shipmentAlertResponseElement = new GF_SF_Stub.ShipmentAlertResponse_element();
         
        GF_SF_Stub.ShipmentAlertInfo_element shipmentAlertInfoElement = new GF_SF_Stub.ShipmentAlertInfo_element();
        shipmentAlertInfoElement.PO = '111';
        
        List<GF_SF_Stub.ShipmentAlertInfo_element> shipmentAlertInfoList = new List<GF_SF_Stub.ShipmentAlertInfo_element>();
        shipmentAlertInfoList.add(shipmentAlertInfoElement);
        
        shipmentAlertResponseElement.Error = '101';
        shipmentAlertResponseElement.ShipmentAlertInfo = shipmentAlertInfoList;
        
        GF_SF_Stub.ShipmentAlertResponse_element shipmentAlertResponseElement_Response = shipmentAlertResponseElement;
        alert_response_map_x.put('response_x',shipmentAlertResponseElement_Response);
        
        // Code Handles RMA test coverage
        Map<String, GF_SF_Stub.RMAResponse_element> RMA_response_map_x = new Map<String, GF_SF_Stub.RMAResponse_element>();
        GF_SF_Stub.RMAResponse_element RMA_ResponseElement = new GF_SF_Stub.RMAResponse_element();
        GF_SF_Stub.RMAResponse_element RMA_ResponseElement1 = new GF_SF_Stub.RMAResponse_element();
        
         GF_SF_Stub.RMAInfo_element RMA_InfoElement = new  GF_SF_Stub.RMAInfo_element();
         RMA_InfoElement.RMA_NO = '1111';
         
         List< GF_SF_Stub.RMAInfo_element> RMA_InfoElementList = new List< GF_SF_Stub.RMAInfo_element>();
         RMA_InfoElementList.add(RMA_InfoElement);
         
         RMA_ResponseElement.Error = '102';
         RMA_ResponseElement.RMAInfo = RMA_InfoElementList;
         
         RMA_ResponseElement1 = RMA_ResponseElement;
         RMA_response_map_x.put('response_x',RMA_ResponseElement1);
         
         //Code Handles getPoReport test Coverage
         Map<String, GF_SF_Stub.POTrackingResponse_element> PO_response_map_x = new Map<String, GF_SF_Stub.POTrackingResponse_element>();
         GF_SF_Stub.POTrackingResponse_element po_responseElement = new GF_SF_Stub.POTrackingResponse_element();
         GF_SF_Stub.POTrackingResponse_element po_responseElement1 = new GF_SF_Stub.POTrackingResponse_element();
         
         GF_SF_Stub.POTrackingInfo_element poTrackingInfoElement = new GF_SF_Stub.POTrackingInfo_element();
         poTrackingInfoElement.SALES_ORDER_NUM ='12345';
         
         List<GF_SF_Stub.POTrackingInfo_element> poTrackingInfoElementList = new List<GF_SF_Stub.POTrackingInfo_element>();
         poTrackingInfoElementList.add(poTrackingInfoElement);
         
         po_responseElement.Error = '101';
         po_responseElement.POTrackingInfo = poTrackingInfoElementList;
         po_responseElement1 = po_responseElement;
         
         PO_response_map_x.put('response_x',po_responseElement1);
         
         // Code Handle getIPNReport test Coverage
         Map<String, GF_SF_Stub.MaskLayerResponse_element> Mask_response_map_x = new Map<String, GF_SF_Stub.MaskLayerResponse_element>();
         
         GF_SF_Stub.MaskLayerResponse_element Mask_responseElement = new GF_SF_Stub.MaskLayerResponse_element();
         GF_SF_Stub.MaskLayerResponse_element Mask_responseElement1 = new GF_SF_Stub.MaskLayerResponse_element();
         
         GF_SF_Stub.MaskLayerInfo_element maskLayerInfoElement = new GF_SF_Stub.MaskLayerInfo_element();
         maskLayerInfoElement.SR_NO = '1212';
         
         List<GF_SF_Stub.MaskLayerInfo_element> maskLayerInfoElementList = new List<GF_SF_Stub.MaskLayerInfo_element>(); 
         maskLayerInfoElementList.add(maskLayerInfoElement);
         
         Mask_responseElement.Error = '101';
         Mask_responseElement.MaskLayerInfo = maskLayerInfoElementList;
         
         Mask_response_map_x.put('response_x',Mask_responseElement);
         
   }
}