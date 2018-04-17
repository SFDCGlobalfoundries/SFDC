@isTest
global class GF_WebServiceMockImpl implements WebServiceMock {
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
        
        // Code handles request/response for Order main query
           
        Map<String, GF_OrderStub.OrderSummaryResponse_element> response_map_x = new Map<String,
                                                                                 GF_OrderStub.OrderSummaryResponse_element>();
                                                                                 
        GF_OrderStub.OrderSummaryResponse_element OrderSummaryResponse_element = new GF_OrderStub.OrderSummaryResponse_element();
        
        GF_OrderStub.OrderSummaryInfo_element summaryElement = new GF_OrderStub.OrderSummaryInfo_element();
        summaryElement.SO = '111';   
                                                                                 
        List<GF_OrderStub.OrderSummaryInfo_element> MockOrderSummaryInfo;
        MockOrderSummaryInfo= new List<GF_OrderStub.OrderSummaryInfo_element>();
        MockOrderSummaryInfo.add(summaryElement);
        
        OrderSummaryResponse_element.ERROR = '101';
        OrderSummaryResponse_element.OrderSummaryInfo = MockOrderSummaryInfo;
                                                                                 
                                                                                  
        GF_OrderStub.OrderSummaryResponse_element response_x = OrderSummaryResponse_element;                                                                         
        response_map_x.put('response_x', response_x);
        
        // Code handles request/response for backlog report
        
        Map<String, GF_OrderStub.BackLogResponse_element> bklg_response_map_x = new Map<String, GF_OrderStub.BackLogResponse_element>();
        GF_OrderStub.BackLogResponse_element backlogResponseElement = new GF_OrderStub.BackLogResponse_element();
        
        GF_OrderStub.BackLogInfo_element backlogInfoElement = new GF_OrderStub.BackLogInfo_element();
        backlogInfoElement.PO = '1111';
        
        List<GF_OrderStub.BackLogInfo_element> backlogInfoElementList = new List<GF_OrderStub.BackLogInfo_element>();
        backlogInfoElementList.add(backlogInfoElement);
        
        backlogResponseElement.ERROR = 100;
        backlogResponseElement.BackLogInfo = backlogInfoElementList;
        
        GF_OrderStub.BackLogResponse_element bklg_response_x = backlogResponseElement;
        bklg_response_map_x.put('response_x',bklg_response_x);
        
        // Code Handles Request/Response for Shipment Order Report
        
        Map<String, GF_OrderStub.ShipSummaryForOrderResponse_element> Summary_response_map_x = new Map<String, GF_OrderStub.ShipSummaryForOrderResponse_element>();
        GF_OrderStub.ShipSummaryForOrderResponse_element summaryResponseElement = new GF_OrderStub.ShipSummaryForOrderResponse_element();
                
        GF_OrderStub.ShipSummaryForOrderInfo_element summaryInfo = new GF_OrderStub.ShipSummaryForOrderInfo_element();
        summaryInfo.FAB = 'FAB1';
        
        List<GF_OrderStub.ShipSummaryForOrderInfo_element> summaryInfoElementList = new List<GF_OrderStub.ShipSummaryForOrderInfo_element>();
        summaryInfoElementList.add(summaryInfo);
        
        summaryResponseElement.ERROR = 100;
        summaryResponseElement.ShipSummaryForOrderInfo = summaryInfoElementList;
        
        GF_OrderStub.ShipSummaryForOrderResponse_element summary_bklg_response_x = summaryResponseElement;
        Summary_response_map_x.put('response_x',summary_bklg_response_x);
        
   }
}