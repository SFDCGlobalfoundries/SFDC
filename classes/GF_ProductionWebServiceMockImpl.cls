/*
* @ Author         :- Navneet Rajput
* @ Description    :- Class test all produtction query services
* @ Date           :- 26/02/2014  
* @ History        :-  
*
**/

@isTest
global class GF_ProductionWebServiceMockImpl implements WebServiceMock {
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
        
        // code test Prod Wip & Ship Lot Summary service
        GF_ProductionQueryStub.SFProdService_pt_pt productionResult = new GF_ProductionQueryStub.SFProdService_pt_pt();
           
        Map<String, GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element> response_map_x = new Map<String, GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element>();
                                                                                 
        GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element wipShipResponse_element = new GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element();
        
        GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType wipShipElement = new GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType();
        wipShipElement.FAB = 'FAB1';   
        
        List<GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> OUTPUTTABLE = new List<GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType>();                                                                         
        
        OUTPUTTABLE.add(wipShipElement);
        
        wipShipResponse_element.ERROR = '100';
        wipShipResponse_element.OUTPUTTABLE= OUTPUTTABLE;
                                                                                 
                                                                                  
        GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element response_x = wipShipResponse_element;                                                                         
        response_map_x.put('response_x', response_x);
        
        
   }
}