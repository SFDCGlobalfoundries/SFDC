/*
*   @ Author        : Navneet Rajput
*   @ Description   : Class Handles operation related to order query/ product query/shipping query 
*   @ Date          : 7th July 2013
*   @ Param         :
*   @ Methods       : 
*   @ Company       : Cognizant Technology LTD.
*   @ History       : Updated on 2/20/2014 by Navneet.
                    : updated on 18/06/2014 by Thomas Lai
					: updated on 29/12/2017 by Hitesh for restricting portal 
                      user to view other Account related record for 
                      Production Report, Order Report and Shipping Report
**/

global without sharing class GF_DynamicQueryHandler {
    
    public  GF_OrderQueryHelper orderQueryObj;
    public  GF_ProductionQueryHelper productQueryObj;
    public  GF_ShippingQueryHelper shippingQueryObj;
    public String DynamicQueryURL;
    public String fileType {get;set;}
    public static String cNames {get;set;}
    public static String cModelNames {get;set;}
    public string gridParam {get;set;}
    public string gridName {get;set;}
    public Boolean isShippingReport {get;set;}
    public Boolean isPoReport {get;set;}
    public Boolean isIpnReport {get;set;}
    public Boolean isLotReport {get;set;}
    public Boolean isShipDateReport {get;set;}
    public Boolean isShipingDetailReport {get;set;}
    public Boolean isOrderReport {get;set;}
    public Boolean isBacklogreport{get;set;}
    public Boolean isOrderShipmentReport{get;set;}
    public List<List<GF_SF_Stub.ShipInfo_element>> listOfShippingReport {get;set;}
    public List<List<GF_SF_Stub.ShipmentAlertInfo_element>> listOfShipDateReport{get;set;}
    public List<List<GF_SF_Stub.RMAInfo_element>> listOfLotReport{get;set;}
    public List<List<GF_SF_Stub.MaskLayerInfo_element>> listOfIpnReport{get;set;}
    public List<List<GF_SF_Stub.POTrackingInfo_element>> listOfPoReport {get;set;}
    public List<List<GF_SF_Stub.ShipmentDetailInfo_element>> listOfShipmentDetailReport {get;set;}   
    public static List<List<GF_OrderStub.OrderSummaryInfo_element>> listOfOrderReport{get;set;} 
    public List<List<GF_OrderStub.BackLogInfo_element>> listOfBklOrderReport{get;set;}
    public List<List<GF_OrderStub.ShipSummaryForOrderInfo_element>> listOfShipmentOrderReport{get;set;}
    public List<GF_SF_Stub.ShipmentAlertInfo_element> DummyShipDateLst;
    public List <GF_SF_Stub.ShipInfo_element> DummyShippingLst;
    public List <GF_SF_Stub.RMAInfo_element> DummyLotLst;
    public List <GF_SF_Stub.MaskLayerInfo_element> DummyIpnLst;
    public List <GF_SF_Stub.POTrackingInfo_element> DummyPoLst;
    public List<GF_SF_Stub.ShipmentDetailInfo_element> DummyShipmentDetailLst;
    public string fileName {get;set;}
    public String userName;
    public String recordCount{get;set;}
	public String rTypeValue;
    /*
    * @ Description : GF_DynamicQueryHandler constructor use to initialise all helper classes
    * @ Date        :
    * @ Param       : productQuery/orderQuery/shipping query objects
    */
    
    public GF_DynamicQueryHandler(){
        
        DynamicQueryURL = ApexPages.currentPage().getUrl();
        if (DynamicQueryURL.contains(GF_ConstantsCls.PRODUCTION_PAGE)){
            productQueryObj = GF_CommonUtilityCls.getInstanceOfProductionQuery();
        } else if (DynamicQueryURL.contains(GF_ConstantsCls.ORDER_PAGE)){
            orderQueryObj = GF_CommonUtilityCls.getInstanceOfOrderQuery();  
        } else if (DynamicQueryURL.contains(GF_ConstantsCls.SHIPPING_PAGE)){
            shippingQueryObj = GF_CommonUtilityCls.getInstanceOfShippingQuery();
        }
        userName = GF_DynamicQueryHandler.getUserShortName();
        // Set export to excel count
        if (GF_DQ_RECORD_COUNT__c.getValues('RECORD_COUNT')!=null && 
            (GF_DQ_RECORD_COUNT__c.getValues('RECORD_COUNT').COUNT__c!=null && GF_DQ_RECORD_COUNT__c.getValues('RECORD_COUNT').COUNT__c!='')){
                
            recordCount = GF_DQ_RECORD_COUNT__c.getValues('RECORD_COUNT').COUNT__c; 
        } else {
            recordCount = '100';
        }
        system.debug('Record Count Is >>>>>>>>>>>>> '+recordCount);
    }
    
    // common variables for all queries
    //public string orderQuery_Fab{get;set;}
    //public string shipppingQuery_Fab{get;set;}
    
    // Setter for orderQueryObject
    public void setOrderQueryObj(GF_OrderQueryHelper orderQueryObj){
        this.orderQueryObj = orderQueryObj;
    }
    // Getter for orderQueryObject
    public GF_OrderQueryHelper getOrderQueryObj(){
        return this.orderQueryObj;
    }
    
    // Setter for production query object
    public void setproductQueryObj(GF_ProductionQueryHelper productQueryObj){
        this.productQueryObj = productQueryObj; 
    }

    // Getter for production query object   
    public GF_ProductionQueryHelper getproductQueryObj(){
        return this.productQueryObj;
    }
    
    //Setter for shipping query object
    public void setShippingQueryObj(GF_ShippingQueryHelper shippingQueryObj){
        shippingQueryObj=shippingQueryObj;
    }
    
    // Getter for shipping query object
    
    public GF_ShippingQueryHelper getShippingQueryObj(){
        return shippingQueryObj;
    }
        
    public static void prepareGridColumn(){
        
        List <String> columnList = new List<String>();
        String DQ_URL = ApexPages.currentPage().getUrl();
        String columnNames ='';
        String columnModelNames='';
        
        if (DQ_URL.contains(GF_ConstantsCls.PRODUCTION_PAGE)){
            // PREPARE PRODUCTION GRID COLUMN AND COLUMN MODEL
        } else if (DQ_URL.contains(GF_ConstantsCls.ORDER_PAGE)){
            // PREPARE ORDER QUERY GRID COLUMN AND COLUMN MODEL
            columnNames = 'PO#'+','+'PO LINE NUMBER'+','+'SO#'+','+'CUSTOMER ID'+','
                            +'GEOMETRY NAME'+','+'CLEAN ROOM'+','+'ORG ID'+','+'INTERNAL PART NAME'+','
                            +'CUSTOMER PART NAME'+','+'ORDER QTY(WFR)'+','+'BKLG QTY(WFR)'+','+'SHIP QTY(WFR)'+','
                            +'ORDER QTY(DIE)'+','+'BKLG QTY(DIE)'+','+'SHIP QTY(DIE)'+','+'ASP'+','+'ORDER DATE'+','
                            +'CRD'+','+'OSD'+','+'CSD'+','+'SHIP TO LOCATION'+','
                            +'ITEM TYPE'+','+'UNIT SELLING PRICE'+','+'LATEST ORDER TYPE'+','
                            +'BLANKET ORDER NUMBER'+','+'BOOK DATE'+','+'CUSTOMER SHORT NAME'; 
                            
            columnModelNames = 'PO'+','+'PO_LINENUM'+','+'SO'+','+'CUSTOMER_ID'+','
                            +'GEOMETRY_NAME'+','+'FAB'+','+'ORG_ID'+','+'CHARTERED_PART_NAME'+','
                            +'CUSTOMER_PART_NAME'+','+'ORDER_QTY_WFR'+','+'BKLG_QTY_WFR'+','+'SHIPPED_QTY_WFR'+','
                            +'ORDER_QTY_DIE'+','+'BKLG_QTY_DIE'+','+'SHIPPED_QTY_DIE'+','+'PRM1'+','+'ORDER_DATE'+','
                            +'CRD'+','+'OSD'+','+'CSD'+','+'SHIP_TO_LOCATION'+','
                            +'ITEM_TYPE'+','+'UNIT_SELLING_PRICE'+','+'LATEST_ORDER_TYPE'+','
                            +'BLANKET_ORDER_NUMBER'+','+'BOOK_DATE'+','+'CUSTOMER_INITIAL'; 
            
        } else if (DQ_URL.contains(GF_ConstantsCls.SHIPPING_PAGE)){
            // PREPARE SHIPPING QUERY GRID COLUMN AND COLUMN MODEL
            // USING HARD CODED STRING BECAUSE NEED TO HAVE ORDER COLLECTION OF STRING 
            columnNames = 'GEOMETRY NAME'+','+'CLEAN ROOM'+','+'PROCESS NAME'+','+'ORG_ID'+','
                            +'INTERNAL PART NAME'+','+'CUSTOMER PART NAME'+','+'LOT ID'+','+'CUSTOMER_ID'+','
                            +'SHIP QTY'+','+'SHIP QTY (DIE)'+','+'LOT PRIORITY'+','
                            +'LOT TYPE'+','+'SO#'+','+'ITEM_TYPE'+','+'SO_HYPR_LINK'+','+'PO#'+','
                            +'PO LINE NUMBER'+','+'OSD'+','+'CSD'+','+'ETEST'+','+'SHIP DATE'+','+'TAX INVOICE'+','
                            +'COC'+','+'SHIP ALERT'+','+'SHIP TO LOCATION'+','
                            +'RMA#'+','+'CUSTOMER SHORT NAME'+','+'HAWB'+','+'MAWB'+','
                            +'FLIGHT NUM'+','+'CONNECTING FLIGHT NUM'+','+'PRM1';
            
            columnModelNames = 'GEOMETRY_NAME'+','+'FAB'+','+'PROCESS_NAME'+','+'ORG_ID'+','
                            +'CHARTERED_PART_NAME'+','+'CUSTOMER_PART_NAME'+','+'LOT_ID'+','+'CUSTOMER_ID'+','
                            +'SHIP_QTY'+','+'SHIP_QTY_DIE'+','+'LOT_PRIORITY'+','
                            +'LOT_TYPE'+','+'SO'+','+'ITEM_TYPE'+','+'SO_HYPR_LINK'+','+'PO'+','
                            +'PO_LINENUM'+','+'OSD'+','+'CSD'+','+'ETEST'+','+'SHIP_DATE'+','+'TAX_INVOICE_LINK'+','
                            +'COC_LINK'+','+'SHIP_ALERT_LINK'+','+'SHIP_TO_LOCATION'+','
                            +'RMA_NO'+','+'CUSTOMER_INITIAL'+','+'HAWB'+','+'MAWB'+','
                            +'FLIGHT_NUM'+','+'CONNECTING_FLIGHT_NUM'+','+'PRM1';
        }                       
            List<String> cNameLst = columnNames.split(',');
            List<String> cModelNameLst = columnModelNames.split(',');
            cNames = GF_CommonUtilityCls.getColumns(cNameLst);
            cModelNames = GF_CommonUtilityCls.getColumnModel(cModelNameLst);    
    }
  
    /*
     * @ Author      :- Navneet 
     * @ Description :- Wrapper classes which are used in to page for showing list of respective shipment records and error code
     * @ History     :-    
     */      
     
    global class ShippingWrapperCls {
        
        global List <GF_SF_Stub.ShipInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingWrapperCls (List <GF_SF_Stub.ShipInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShippingDetailWrapperCls {
        
        global List<GF_SF_Stub.ShipmentDetailInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingDetailWrapperCls (List <GF_SF_Stub.ShipmentDetailInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShippingDateWrapperCls {
        
        global List<GF_SF_Stub.ShipmentAlertInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingDateWrapperCls (List<GF_SF_Stub.ShipmentAlertInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShippingLotWrapperCls {
        
        global List<GF_SF_Stub.RMAInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingLotWrapperCls (List<GF_SF_Stub.RMAInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShippingPoWrapperCls {
        
        global List<GF_SF_Stub.POTrackingInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingPoWrapperCls (List<GF_SF_Stub.POTrackingInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShippingIPNWrapperCls {
        
        global List<GF_SF_Stub.MaskLayerInfo_element> ShipingInfoLst;
        global String ERROR_CODE;
        
        global ShippingIPNWrapperCls (List<GF_SF_Stub.MaskLayerInfo_element> ShipingInfoLst,String ERROR_CODE){
            this.ShipingInfoLst=ShipingInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    /* 
    * @ Author         :- Navneet Rajput
    * @ Description    :- Remote actions for shipment queries which are getting called from shipment page and result will be
    *                     return from data warehouse.
    *                     getting result in the form of wrapper class and it is holding list of respective query result and error code. 
    * @ History        :- 
    */
    @RemoteAction
    global static ShippingDetailWrapperCls getWfrReport(String LOT_NUMBER,Integer CUST_ID,String InPrm1,String InPrm2){
        
        GF_SF_Stub.SFShipment_pt shipmentDetailObj = new GF_SF_Stub.SFShipment_pt();
        GF_SF_Stub.ShipmentDetailResponse_element response = shipmentDetailObj.ShipmentDetail(LOT_NUMBER,CUST_ID,'','');
        //GF_SF_Stub.ShipmentDetailResponse_element response = shipmentDetailObj.ShipmentDetail('7TEF39004.000',1108,'',''); 
        ShippingDetailWrapperCls shippingObj;
        if (response!=null){
            shippingObj = new ShippingDetailWrapperCls(response.ShipmentDetailInfo,response.Error);
            response=null;
        }
        return shippingObj;  
    }
    
    @RemoteAction
    global static ShippingDateWrapperCls getShipDateReport(String SHIP_DATE,Integer ORG_ID,Integer CUST_ID,String InPrm1,String InPrm2){
        
        GF_SF_Stub.SFShipment_pt shipDateObj = new GF_SF_Stub.SFShipment_pt();
        GF_SF_Stub.ShipmentAlertResponse_element response = shipDateObj.ShipmentAlert(SHIP_DATE, ORG_ID, CUST_ID, InPrm1, InPrm2); 
        //GF_SF_Stub.ShipmentAlertResponse_element response = shipDateObj.ShipmentAlert('05-Aug-2010',13,187,' ',' ');
       /* system.debug('response.Error>>>>>>'+response.Error);
        if (response.Error == null || response.Error==''){
            response.Error='102';
        }*/
        ShippingDateWrapperCls shippingObj;
        
        if (response!=null){
            shippingObj = new ShippingDateWrapperCls(response.ShipmentAlertInfo,response.Error);
            response=null;
        }
        return shippingObj;  
    }
    
    @RemoteAction
    global static ShippingLotWrapperCls getLotReport(String LotId,String InPrm1,String InPrm2){
        
        GF_SF_Stub.SFShipment_pt lotObj = new GF_SF_Stub.SFShipment_pt();
        GF_SF_Stub.RMAResponse_element response = lotObj.RMA(LotId,'','');
        //GF_SF_Stub.RMAResponse_element response = lotObj.RMA('2TRG21226.1','','');
        ShippingLotWrapperCls shippingObj;
        
        if (response!=null){
            shippingObj = new ShippingLotWrapperCls(response.RMAInfo,response.Error);
            response=null;
        }
        return shippingObj;  
    }
    
    @RemoteAction
    global static ShippingPoWrapperCls getPoReport(String SONumber,Integer CustomerId,String InPrm1,String InPrm2){
        
        GF_SF_Stub.SFShipment_pt poTrackingObj = new GF_SF_Stub.SFShipment_pt();
        GF_SF_Stub.POTrackingResponse_element response = poTrackingObj.POTracking(SONumber,CustomerId,'','');
        
        ShippingPoWrapperCls shippingObj;
        
        if (response!=null){
            shippingObj = new ShippingPoWrapperCls(response.POTrackingInfo,response.Error);
            response=null;
        }
        return shippingObj;  
    }
    
    @RemoteAction
    global static ShippingIPNWrapperCls getIPNReport(Integer OrgId,String deviceName,String InPrm1,String InPrm2){
        
        GF_SF_Stub.SFShipment_pt resp = new GF_SF_Stub.SFShipment_pt();                                                 
        GF_SF_Stub.MaskLayerResponse_element  response = resp.MaskLayer(OrgId,deviceName,'','');
        //GF_SF_Stub.MaskLayerResponse_element  response = resp.MaskLayer(3,'2T15ABCF-8-U-U08','','');
        ShippingIPNWrapperCls shippingObj;
        if (response!=null){
            shippingObj = new ShippingIPNWrapperCls(response.MaskLayerInfo,response.Error);
            response=null;
        }
        //system.debug('RESULT FOR IPN >>>>>>>>>>>> '+response);
        return shippingObj;  
    }
    
    @RemoteAction
    global static ShippingWrapperCls getShippingReport(String ShippingQuery_geometry, String ShippingQuery_FAB,
                                                       String ShippingQuery_internalPartName, String ShippingQuery_customerPartName,
                                                       String ShippingQuery_LotId, String fromDate,
                                                       String toDate, String ShippingQuery_orderType,
                                                       String ShippingQuery_PO, String ShippingQuery_InvoiceNumber, 
                                                       String ShippingQuery_RMA,String counter,String custName){
             
         
         String customerShortName;
           
         if (custName=='' || custName== null || custName=='@@'){  
            customerShortName = GF_DynamicQueryHandler.getUserShortName();
         }else{
            customerShortName = custName+':'+'Portal User';     
         }
         
         GF_SF_Stub.SFShipment_pt resp = new GF_SF_Stub.SFShipment_pt();                                                    
            //List <GF_SF_Stub.ShipInfo_element>                                                
         GF_SF_Stub.ShipDetailResponse_element response = resp.ShipSummary(ShippingQuery_geometry,ShippingQuery_FAB,
                                                                        ShippingQuery_internalPartName,ShippingQuery_customerPartName,
                                                                        ShippingQuery_LotId,fromDate,toDate,
                                                                        ShippingQuery_orderType,ShippingQuery_PO,
                                                                        ShippingQuery_InvoiceNumber,ShippingQuery_RMA,
                                                                        customerShortName,counter,'');
         
         ShippingWrapperCls shippingResult;
         
         if (response!=null){
             shippingResult = new ShippingWrapperCls(response.ShipInfo,response.Error);
             response = null;        
         }
        return shippingResult;
    }
     
    //##########################  ORDER QUERY REPORT START ###############################################################
    /*
     * @ Author         :- Navneet Rajput
     * @ Description    :- Wrapper classes for Oreder query report which help to hold order report data and error code 
     *                     generated from DW
     * @ History        :- 
     */
    
    global class OrderWrapperCls {
        
        global List <GF_OrderStub.OrderSummaryInfo_element> orderInfoLst;
        global String ERROR_CODE;
        
        global OrderWrapperCls (List <GF_OrderStub.OrderSummaryInfo_element> orderInfoLst,String ERROR_CODE){
            this.orderInfoLst=orderInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
     
    global class BacklogWrapperCls {
        
        global List<GF_OrderStub.BackLogInfo_element> backLogInfoLst;
        global Integer ERROR_CODE;
        
        global BacklogWrapperCls (List<GF_OrderStub.BackLogInfo_element> backLogInfoLst,Integer ERROR_CODE){
            this.backLogInfoLst=backLogInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ShipmentForOrderWrapperCls {
        
        global List <GF_OrderStub.ShipSummaryForOrderInfo_element> ShipmentInfoLst;
        global Integer ERROR_CODE;
        
        global ShipmentForOrderWrapperCls (List <GF_OrderStub.ShipSummaryForOrderInfo_element> ShipmentInfoLst,Integer ERROR_CODE){
            this.ShipmentInfoLst=ShipmentInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
        
    
        
    @RemoteAction
    global static OrderWrapperCls getOrderReport(String PONumber, String SONumber,
                                                 String Geometry, String Fab,
                                                 String InternalPartname, String CustomerPartname,
                                                 String OrderStatus, String OrderType,
                                                 String OrderFrom, String OrderTo, 
                                                 String counter,String CustomerInitial){
                                                 
         String customerShortName;
         if (CustomerInitial=='' || CustomerInitial== null || CustomerInitial=='@@'){  
            customerShortName = GF_DynamicQueryHandler.getUserShortName();
         }else{
            customerShortName = CustomerInitial+':'+'Portal User';     
         }
         system.debug('customerShortName>>>>>>>>>>>>>>>'+customerShortName);                                                               
        GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();
        GF_OrderStub.OrderSummaryResponse_element Result = resp.OrderSummary(PONumber,SONumber,Geometry,
                                                                             Fab,InternalPartname,CustomerPartname,
                                                                             OrderStatus, OrderType,OrderFrom,OrderTo,
                                                                             customerShortName,counter,'');
        
        OrderWrapperCls orderReport;
        if (Result != null){
            orderReport = new OrderWrapperCls(Result.OrderSummaryInfo,Result.ERROR);
            Result =null;
        }
        return orderReport;
    }
    
    
    @RemoteAction
    global static BacklogWrapperCls getBacklogReport(String PONumber){
        
        GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();
        GF_OrderStub.BackLogResponse_element Result = resp.BackLog(PONumber,'',''); 
        
        BacklogWrapperCls backLogReport;
        if (Result!=null){
            backLogReport = new BacklogWrapperCls(Result.BackLogInfo,Result.ERROR);
            Result = null;
        }
        return backLogReport;
    }
    
    @RemoteAction
    global static ShipmentForOrderWrapperCls getShipmentOrderReport(String PONumber){
        
        GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();
        GF_OrderStub.ShipSummaryForOrderResponse_element Result = resp.ShipSummaryForOrder(PONumber,'','');
        
        ShipmentForOrderWrapperCls shipmentReport; 
        if (Result!=null){
            shipmentReport = new ShipmentForOrderWrapperCls(Result.ShipSummaryForOrderInfo,Result.ERROR);
            Result = null;
        }
        return shipmentReport;
    }
    //########################## ORDER QUERY REPORT END #################################################################
      
      
    //########################## START OF PRODUCTION QUERY REPORT #####################################################
    
    /*
     * @ Author         :- Navneet Rajput
     * @ Description    :- Wrapper classes for production query report which help to hold production report data and error code 
     *                     generated from DW
     * @ History        :- 
     */
    
    global class ProdWIPLotSmryWrapperCls {
        
        global List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> shipInfoLst;
        global String ERROR_CODE;
        
        global ProdWIPLotSmryWrapperCls (List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> shipInfoLst,String ERROR_CODE){
            this.shipInfoLst=shipInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ProdWIPSHIPLotSmryWrapperCls {
        
        global List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> shipLotInfoLst;
        global String ERROR_CODE;
        
        global ProdWIPSHIPLotSmryWrapperCls (List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> shipLotInfoLst,String ERROR_CODE){
            this.shipLotInfoLst=shipLotInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ProdLotStrtSmryWrapperCls {
        
        global List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotInfoLst;
        global String ERROR_CODE;
        
        global ProdLotStrtSmryWrapperCls (List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotInfoLst,String ERROR_CODE){
            this.lotInfoLst=lotInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class FabOutLocationWrapperCls{
        global List<GF_ProductionQueryStub.FabOutLocationResponseType> fabOutInfoLst;
        global String ERROR_CODE;
        
        global FabOutLocationWrapperCls(List<GF_ProductionQueryStub.FabOutLocationResponseType> fabOutInfoLst,String ERROR_CODE){
            this.fabOutInfoLst=fabOutInfoLst;
            this.ERROR_CODE=ERROR_CODE;
        }
    }
    
    global class ProcEprfServiceWrapperCls{
        global List<GF_ProductionQueryStub.ProcEprfResponseType> eprfInfoLst;
        global String ERROR_CODE;
        
        global ProcEprfServiceWrapperCls(List<GF_ProductionQueryStub.ProcEprfResponseType> eprfInfoLst,String ERROR_CODE){
            this.eprfInfoLst= eprfInfoLst;
            this.ERROR_CODE = ERROR_CODE;
        }
    }
    
    global class currentRunSheetWrapperCls{
    
        global List<GF_ProductionQueryStub.RunSheetResponseType> runshitInfoLst;
        global String ERROR_CODE;
        
        global currentRunSheetWrapperCls(List<GF_ProductionQueryStub.RunSheetResponseType> runshitInfoLst, String ERROR_CODE){
            this.runshitInfoLst = runshitInfoLst;
            this.ERROR_CODE     = ERROR_CODE;
        }
        
    }
    
    global class wfrstartDateWrapperCls{
        
        global List<GF_ProductionQueryStub.WaferStartResponseType> startDateInfoLst;
        global String ERROR_CODE;
        
        global wfrstartDateWrapperCls(List<GF_ProductionQueryStub.WaferStartResponseType> startDateInfoLst,String ERROR_CODE){
            this.startDateInfoLst = startDateInfoLst;
            this.ERROR_CODE       = ERROR_CODE;
        }
        
    }
    
     @RemoteAction  
     global static ProdWIPLotSmryWrapperCls geProductionReport1(String str1,String str2,String str3,
                                                                String str4,String str5,String str6,
                                                                String str7,String str8,String str9){
         String customerShortName;
           
         if (str9 =='' || str9 == null || str9 =='@@'){  
            customerShortName = GF_DynamicQueryHandler.getUserShortName();
         }else{
            customerShortName = str9 +':'+'Portal User';     
         }  
         GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();
         GF_ProductionQueryStub.ProdWIPLotSmryResponse_element response = result.SFProdWIPLotSmryService(str1,str2,
                                                                                                         str3,str4,
                                                                                                         str5,str6,
                                                                                                         str7,customerShortName,
                                                                                                         str8,'','','','');
         
         ProdWIPLotSmryWrapperCls prodWipWrapper;
         
         if (response!= null){
             prodWipWrapper = new ProdWIPLotSmryWrapperCls(response.OUTPUTTABLE,response.ERROR);
             response =null;
         }                                        
        
        return prodWipWrapper;
     }  
    
    @RemoteAction  
     global static ProdWIPSHIPLotSmryWrapperCls geProductionReport2(String str1,String str2,String str3,
                                                                    String str4,String str5,String str6,
                                                                    String str7,String str8,String str9,
                                                                    String str10,String str11){
         
         String customerShortName;
           
         if (str11 =='' || str11 == null || str11 =='@@'){  
            customerShortName = GF_DynamicQueryHandler.getUserShortName();
         }else{
            customerShortName = str11 +':'+'Portal User';     
         }
                                              
         GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();
    
         GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element response = result.SFProdWIPSHIPLotSmryService(str1,str2,
                                                                                                                 str3,str4,
                                                                                                                 str5,str6,
                                                                                                                 str7,str8,
                                                                                                                 str9,customerShortName,
                                                                                                                 str10,'','','','');
                                                                                     
           ProdWIPSHIPLotSmryWrapperCls prodWIpShipLotWrapperObj;
           
           if (response!=null){
               prodWIpShipLotWrapperObj = new ProdWIPSHIPLotSmryWrapperCls(response.OUTPUTTABLE,response.ERROR);
               response=null;
           }
        
        return prodWIpShipLotWrapperObj;
     }
     
     @RemoteAction  
     global static ProdLotStrtSmryWrapperCls geProductionReport3(String str1,String str2,String str3,
                                                                 String str4,String str5,String str6,
                                                                 String str7,String str8,String str9,
                                                                 String str10,String str11){
        
        String customerShortName;
           
         if (str11 =='' || str11 == null || str11=='@@'){  
            customerShortName = GF_DynamicQueryHandler.getUserShortName();
         }else{
            customerShortName = str11 +':'+'Portal User';     
         }
           
        GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();
        GF_ProductionQueryStub.ProdLotStrtSmryResponse_element response = result.SFProdLotStrtSmryService(str1,str2,
                                                                                                          str3,str4,
                                                                                                          str5,str6,
                                                                                                          str7,str8,
                                                                                                          str9,customerShortName,
                                                                                                          str10,'','','','');
       ProdLotStrtSmryWrapperCls prodLotWrapperObj;                                                                                                   
           
       if (response!=null){
           prodLotWrapperObj = new ProdLotStrtSmryWrapperCls(response.OUTPUTTABLE,response.ERROR);
           response=null;
       }
        
        return prodLotWrapperObj;
     }
     
     @RemoteAction  
     global static ProcEprfServiceWrapperCls getEPRFReport(String str1){
     
        GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();
        GF_ProductionQueryStub.ProcEprfResponse_element response = result.SFProcEprfService(str1,'','','','','');
    
        ProcEprfServiceWrapperCls eprfObj;
        if (response!=null){
            eprfObj = new ProcEprfServiceWrapperCls(response.OUTPUTTABLE,response.ERROR);
        }
        return eprfObj;
     }
     
     @RemoteAction  
     global static FabOutLocationWrapperCls getFabOutLocationReport(String str1,String str2,String str3){
        
        GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();   
        GF_ProductionQueryStub.FabOutLocationResponse_element response = result.SFFabOutLocationService(str1,str2,str3,'','','','');
        //system.debug('Error COde >>>>>>>>>'+response.ERROR); 
        
        FabOutLocationWrapperCls faboutObj;
        
        if (response!=null){
            faboutObj = new FabOutLocationWrapperCls(response.OUTPUTTABLE,response.ERROR);
        } 
        return faboutObj;
     }
     
     @RemoteAction
     global static currentRunSheetWrapperCls getCurrentRunSheetReport(String str1,String str2,String str3){
     
         GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();  
         GF_ProductionQueryStub.RunSheetResponse_element response = result.SFRunSheetService(str1,str2,str3,'','','','','');
        
         currentRunSheetWrapperCls runsheet;
         if (response!=null){
             runsheet = new currentRunSheetWrapperCls(response.OUTPUTTABLE,response.ERROR);
         }    
         return runsheet;
         
     }
     
     @RemoteAction
     global static  wfrstartDateWrapperCls getWfrStartReport(String str1,String str2,String str3){
     
         GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();  
         GF_ProductionQueryStub.WaferStartResponse_element response = result.SFWaferStartService(str1,str2,str3,'','','','');
         
         wfrstartDateWrapperCls startDate;
         if (response!=null){
             startDate = new wfrstartDateWrapperCls(response.OUTPUTTABLE,response.ERROR);
         }
         return startDate;
     }
    
     
    //######################### END OF PRODUCTION QUERY REPORT #########################################################   
    /*
    *   @ Author        :- Navneet Rajput        
    *   @ Description   :- Function use to export shipping data in to excel file
    *   @ Date          :- 20th August 2013
    **/
      
    public pageReference exportToExcel(){
        Boolean isError = false;
        if (gridName.equalsIgnoreCase('ShippingReport')){
            resetShippingQueryFlags(true,false,false,false,false,false,false,false,false);
            system.debug('Inside Shipping Report>>>>>>>>>>'+gridName);
            fileName='Shipping Report.xls';
            //isError = shippingReportToExcel();   
            //exprotMasterReportToExcel('ShipingReport');                                                               
        }else if (gridName.equalsIgnoreCase('PO_Report')){
            resetShippingQueryFlags(false,true,false,false,false,false,false,false,false);
            fileName='PO Tracker Report.xls';
            isError = poReportToExcel();                                                                    
        }else if (gridName.equalsIgnoreCase('IPN_Report')){
            resetShippingQueryFlags(false,false,true,false,false,false,false,false,false);
            fileName='Mask Layer Report.xls';
            isError = ipnReportToExcel();                                                                   
        }else if (gridName.equalsIgnoreCase('Lot_Data_Report')){
            resetShippingQueryFlags(false,false,false,true,false,false,false,false,false);
            fileName='RMA Report.xls';
            isError = lotReportToExcel();                                                                   
        }else if (gridName.equalsIgnoreCase('Ship_Date_Report')){
            resetShippingQueryFlags(false,false,false,false,true,false,false,false,false);
            fileName='Shipment Alert Report.xls';
            isError = shipDateReportToExcel();                                                                  
        }else if (gridName.equalsIgnoreCase('Shipment_Detail_Report')){
            resetShippingQueryFlags(false,false,false,false,false,true,false,false,false);
            fileName='Shipment Detail Report.xls';
            isError = shipmentDetailReportToExcel();                                                                    
        } else if (gridName.equalsIgnoreCase('Order_Report')){
            system.debug('Inside Order Report >>>>>>>>');
            //resetShippingQueryFlags(false,false,false,false,false,false,true,false,false);
            //fileName='Order Report.xls';
            //isError = orderReportToExcel();
           // String reportUrl = exprotMasterReportToExcel('OrderReport');
            //return new ApexPages.PageReference(reportUrl).setRedirect(true);
           
        } else if (gridName.equalsIgnoreCase('Backlog_Report')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,true,false);
            fileName = 'Backlog Report.xls';
            isError = orderBacklogReportToExcel();
        } else if (gridName.equalsIgnoreCase('Shipment_Report')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,true);
            fileName = 'Shipment for order Report.xls';
            isError = orderShipmentReportToExcel();
        } else if (gridName.equalsIgnoreCase('EprfReport')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,false,false,true,false,false,false);
            fileName = 'Eprf Report.xls';
            isError = EprfReportToExcel();
            
        } else if (gridName.equalsIgnoreCase('currentRunSheetReport')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,false,false,false,true,false,false);
            fileName = 'Current RunSheet Report.xls';
            isError = currentRunShitReportToExcel();
            
        } else if (gridName.equalsIgnoreCase('WaferStartReport')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,false,false,false,false,true,false);
            fileName = 'Wafer Start Report.xls';
            isError = waferStartReportToExcel();
            
        } else if (gridName.equalsIgnoreCase('FabOutLocationReport')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,false,false,false,false,false,true);
            fileName = 'Fabout Location.xls';
            isError = faboutLocationReportToExcel();
            
        } else if (gridName.equalsIgnoreCase('ProductionReport1')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(true,false,false,false,false,false,false);
            fileName = 'WIP LOT Report.xls';
            //isError = ProductionReport1ToExcel();
            //exprotMasterReportToExcel('Prod1Report');
            
        } else if (gridName.equalsIgnoreCase('ProductionReport2')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,true,false,false,false,false,false);
            fileName = 'WIP lot and Ship lot Report.xls';
            //isError = ProductionReport2ToExcel();
            //exprotMasterReportToExcel('Prod2Report');
            
        } else if (gridName.equalsIgnoreCase('ProductionReport3')){
            resetShippingQueryFlags(false,false,false,false,false,false,false,false,false);
            resetProductionQueryFlags(false,false,true,false,false,false,false);
            fileName = 'Wip lot start date Report.xls';
            //isError = ProductionReport3ToExcel();
            //exprotMasterReportToExcel('Prod3Report');
        }   
    
        if (isError){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Due to some technical issues you are not able to download Excel. Please try after some time.'));
            return null;
        } else {
            return Page.GF_ConvertInToExcel;
        }
    }
    
    // production query export to excel flags used to generate specific excel
    
    public boolean isProduction1     {get;set;}
    public boolean isProduction2     {get;set;}
    public boolean isProduction3     {get;set;}
    public boolean isEPRF            {get;set;}
    public boolean isCurrentRunSheet {get;set;}
    public boolean isWaferStart      {get;set;}
    public boolean isFaboutLocation  {get;set;}
    
    public List <GF_ProductionQueryStub.ProdWIPLotSmryResponseType> wipLotReport {get;set;}
    public List <GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponseType> wipAndShipLotReport {get;set;}
    public List <GF_ProductionQueryStub.ProdLotStrtSmryType> lotStartDateReport {get;set;}
    public List <GF_ProductionQueryStub.ProcEprfResponseType> eprfReport {get;set;}
    public List <GF_ProductionQueryStub.RunSheetResponseType> currentRunsheetReport {get;set;}
    public List <GF_ProductionQueryStub.WaferStartResponseType> waferStartReport {get;set;}
    public List <GF_ProductionQueryStub.FabOutLocationResponseType> faboutLocationReport {get;set;}
    
    private void resetProductionQueryFlags(boolean isProduction1,boolean isProduction2,
                                           boolean isProduction3,boolean isEPRF,
                                           boolean isCurrentRunSheet,boolean isWaferStart,boolean isFaboutLocation){
                                           
        this.isProduction1 = isProduction1;
        this.isProduction2 = isProduction2;
        this.isProduction3 = isProduction3;
        this.isEPRF = isEPRF;
        this.isCurrentRunSheet = isCurrentRunSheet;
        this.isWaferStart = isWaferStart;
        this.isFaboutLocation = isFaboutLocation;
    }
    
    public pageReference redirectToConverToExcel(){
        return Page.GF_ConvertInToExcel;
    }
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for Ship Date data
    * @ Author      :- Navneet Rajput
    **/
    
    private Boolean shipDateReportToExcel(){
        Boolean isError = false;
        try {
            DummyShipDateLst        = new List<GF_SF_Stub.ShipmentAlertInfo_element>();
            listOfShipDateReport    = new List<List<GF_SF_Stub.ShipmentAlertInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            
            GF_SF_Stub.SFShipment_pt shipDateObj = new GF_SF_Stub.SFShipment_pt();
            GF_SF_Stub.ShipmentAlertResponse_element response = shipDateObj.ShipmentAlert(inputParam[0], Integer.valueOf(inputParam[1]),
                                                                                          Integer.valueOf(inputParam[2]),'','');
            for (GF_SF_Stub.ShipmentAlertInfo_element shipDateElement : response.ShipmentAlertInfo){
                DummyShipDateLst.add(shipDateElement);
                if (DummyShipDateLst.size() == 1000){
                    listOfShipDateReport.add(DummyShipDateLst);
                    DummyShipDateLst = new List<GF_SF_Stub.ShipmentAlertInfo_element>();
                }
            }
            if (DummyShipDateLst.size()>0){
                listOfShipDateReport.add(DummyShipDateLst);
            } 
            return isError;                                                                           
         } catch (Exception e){
            system.debug('EXCEPTION :: '+e.getMessage());
            isError = true;
            return isError;
        }                                                                             
    }
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for Shipment detail data
    * @ Author      :- Navneet Rajput
    **/
    private Boolean shipmentDetailReportToExcel(){
        Boolean isError =false;
        try {
            DummyShipmentDetailLst      = new List<GF_SF_Stub.ShipmentDetailInfo_element>();
            listOfShipmentDetailReport  = new List<List<GF_SF_Stub.ShipmentDetailInfo_element>>();
            list<string> inputParam     = gridParam.split(',');
            
            GF_SF_Stub.SFShipment_pt shipmentDetailObj = new GF_SF_Stub.SFShipment_pt();
            GF_SF_Stub.ShipmentDetailResponse_element response = shipmentDetailObj.ShipmentDetail(inputParam[0],Integer.valueOf(inputParam[1]),'','');
            
            for (GF_SF_Stub.ShipmentDetailInfo_element shipDetailElement : response.ShipmentDetailInfo){
                DummyShipmentDetailLst.add(shipDetailElement);
                if (DummyShipmentDetailLst.size() == 1000){
                    listOfShipmentDetailReport.add(DummyShipmentDetailLst);
                    DummyShipmentDetailLst = new List<GF_SF_Stub.ShipmentDetailInfo_element>();
                }
            }
            if (DummyShipmentDetailLst.size()>0){
                listOfShipmentDetailReport.add(DummyShipmentDetailLst);
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }   
    }
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for PO data
    * @ Author      :- Navneet Rajput
    **/
    private Boolean poReportToExcel(){
        Boolean isError = false;
        try {
            DummyPoLst = new List <GF_SF_Stub.POTrackingInfo_element>();
            listOfPoReport = new List<List<GF_SF_Stub.POTrackingInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            GF_SF_Stub.SFShipment_pt poTrackingObj = new GF_SF_Stub.SFShipment_pt();
            GF_SF_Stub.POTrackingResponse_element response = poTrackingObj.POTracking(inputParam[0],Integer.valueof(inputParam[1]),'','');
            
            for (GF_SF_Stub.POTrackingInfo_element poElement : response.POTrackingInfo){
                DummyPoLst.add(poElement);
                if (DummyPoLst.size() == 1000){
                    listOfPoReport.add(DummyPoLst);
                    DummyPoLst = new List <GF_SF_Stub.POTrackingInfo_element>();
                }
            }
            if (DummyPoLst.size()>0){
                listOfPoReport.add(DummyPoLst);
            }
            return isError;
        } catch (Exception e){
            system.debug('EXCEPTION :: '+e.getMessage());
            isError = true;
            return isError;
        }   
    }
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for IPN data
    * @ Author      :- Navneet Rajput
    **/
    private Boolean ipnReportToExcel(){
        Boolean isError = false;
        try {       
            DummyIpnLst = new List <GF_SF_Stub.MaskLayerInfo_element>();
            listOfIpnReport = new List<List<GF_SF_Stub.MaskLayerInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            
            GF_SF_Stub.SFShipment_pt resp = new GF_SF_Stub.SFShipment_pt();                                                 
            GF_SF_Stub.MaskLayerResponse_element  response = resp.MaskLayer(Integer.valueOf(inputParam[0]),inputParam[1],'','');
    
            for (GF_SF_Stub.MaskLayerInfo_element ipnElement : response.MaskLayerInfo){
                DummyIpnLst.add(ipnElement);
                if (DummyIpnLst.size() == 1000){
                    listOfIpnReport.add(DummyIpnLst);
                    DummyIpnLst = new List <GF_SF_Stub.MaskLayerInfo_element>();
                }
            }
            if (DummyIpnLst.size()>0){
                listOfIpnReport.add(DummyIpnLst);
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }   
    }
    
     /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for lot data
    * @ Author      :- Navneet Rajput
    **/
    
    private Boolean lotReportToExcel(){
        Boolean isError = false;
        try {
            DummyLotLst             = new List <GF_SF_Stub.RMAInfo_element>();
            listOfLotReport         = new List<List<GF_SF_Stub.RMAInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            
            GF_SF_Stub.SFShipment_pt lotObj = new GF_SF_Stub.SFShipment_pt();
            GF_SF_Stub.RMAResponse_element response = lotObj.RMA(inputParam[0],'','');
            //ShippingLotWrapperCls shippingObj = new ShippingLotWrapperCls(response.RMAInfo,response.Error);
            for (GF_SF_Stub.RMAInfo_element lotElement : response.RMAInfo){
                DummyLotLst.add(lotElement);
                if (DummyLotLst.size() == 1000){
                    listOfLotReport.add(DummyLotLst);
                    DummyLotLst = new List <GF_SF_Stub.RMAInfo_element>();
                }
            }
            if (DummyLotLst.size()>0){
                listOfLotReport.add(DummyLotLst);
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }   
    }
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- Generate Excel for shipping data
    * @ Author      :- Navneet Rajput
    **/
    /*
    private Boolean shippingReportToExcel(){
        Boolean isError = false;
        try {
            String CustomerInitial = GF_DynamicQueryHandler.getUserShortName();
            DummyShippingLst = new List <GF_SF_Stub.ShipInfo_element>();
            listOfShippingReport = new List<List<GF_SF_Stub.ShipInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            GF_SF_Stub.SFShipment_pt resp = new GF_SF_Stub.SFShipment_pt();                                                 
            
            String customerShortName;
             if (inputParam[12]=='' || inputParam[12]== null || inputParam[12]=='@@'){  
                customerShortName = GF_DynamicQueryHandler.getUserShortName();
             }else{
                customerShortName = inputParam[12]+':'+'Portal User';     
             }  
              
            if (inputParam.size()>0){       
                GF_SF_Stub.ShipDetailResponse_element response = resp.ShipSummary(inputParam[0], inputParam[1],
                                                                        inputParam[2],inputParam[3],
                                                                        inputParam[4],inputParam[5],inputParam[6],
                                                                        inputParam[7],inputParam[8],
                                                                        inputParam[9],inputParam[10],
                                                                        customerShortName,inputParam[11],recordCount);
                                                                        
                for (GF_SF_Stub.ShipInfo_element shipingElement : response.ShipInfo){
                    DummyShippingLst.add(shipingElement);
                    if (DummyShippingLst.size() == 1000){
                        listOfShippingReport.add(DummyShippingLst);
                        DummyShippingLst = new List <GF_SF_Stub.ShipInfo_element>();
                    }
                }
                if (DummyShippingLst.size()>0){
                    listOfShippingReport.add(DummyShippingLst);
                }
                response= null;
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }   
   }
   */
   
   public String para {get;set;}
   public String reportUrl {get;set;}
   public String customerInitial {get;set;}
   
   public void exportToExcelReport(){
   		system.debug('para is >>>>>>>>>>'+para);
   		system.debug('Customer Initial >>>>>>>>>>'+customerInitial);
   		if (para<>NULL && !String.isBlank(para)){
	   		if(para.contains('OrderReport')){
	   			exprotMasterReportToExcel('OrderReport');
	   		} else if(para.contains('ShipingReport')){
	   			exprotMasterReportToExcel('ShipingReport');
	   		} else if(para.contains('Prod1Report')){
	   			exprotMasterReportToExcel('Prod1Report');
	   		} else if(para.contains('Prod2Report')){
	   			exprotMasterReportToExcel('Prod2Report');
	   		} else if(para.contains('Prod3Report')){
	   			system.debug('Inside Prod 3 Report>>>>>>>>>>>');
	   			exprotMasterReportToExcel('Prod3Report');
	   		}
   		}
   }
   
  // ORDER REPORT TO EXCEL START  
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 09-11-2013 
    * @ Description :- Generate Excel for Order Report data
    * @ Author      :- Navneet Rajput
    **/
  transient MAP<ID,Account> allAccMap;// = new MAP<ID,Account>([SELECT ID,Name, Short_Name__c, ParentID from Account]);
  Map<Id,Account> accParentMap;// = new Map<ID,account>();
  String shortNames='';
  String tempShrtName='';
  
  private String exprotMasterReportToExcel(String rType){
  	
    String userShortName = GF_DynamicQueryHandler.getUserShortName();
    String accShortNames;
    String PONumber;
    String SONumber;
    String Geometry;
    String Fab;
    String InternalPartname;
    String CustomerPartname;
    String OrderStatus;
    String OrderType;
    String fromDate;
    String toDate; 
    String baseUrl=URL.getSalesforceBaseUrl().toExternalForm() +'/GlobalfoundryView/';   
    String filter='';                    
    //String reportUrl;
    ID rTypeId = null;
    Map<String,Id> mapOfReport = new Map<String,Id>();
    //String rType= getReprotType();
    ApexPages.PageReference report = null;
    List<Report> lstReport =[SELECT Id,Name 
                             FROM Report 
                             WHERE Name 
                             IN ('OrderReport4CSR','OrderReport4Admin','OrderReport4User'
                                ,'ShipingReport4CSR','ShipingReport4Admin','ShipingReport4User'
                                ,'Prod1Report4CSR','Prod1Report4Admin','Prod1Report4User'
                                ,'Prod2Report4CSR1','Prod2Report4Admin1','Prod2Report4User1'
                                ,'Prod3Report4CSR','Prod3Report4Admin','Prod3Report4User'
                                )
                        ];
                        
    if(lstReport<>NULL && !lstReport.isEmpty()){                    
        for(Report rName : lstReport){
            mapOfReport.put(rName.Name,rName.Id);
        }
    }                    
    system.debug('userShortName>>>>>>>>>>>>>>>'+userShortName);
    if(userShortName<>NULL && userShortName.contains('CSR') && mapOfReport<>NULL){
        
        if(rType.contains('OrderReport')){
            system.debug('Order Report for CSR #######');
            filter = getOrderFilters('CSR');
            rTypeId=mapOfReport.get('OrderReport4CSR');
        } else if (rType.contains('ShipingReport')){
            system.debug('ShipingReport for CSR #######');
            filter = getShipmentFilters('CSR');
            rTypeId=mapOfReport.get('ShipingReport4CSR');
        } else if (rType.contains('Prod1Report')){
            system.debug('Prod1Report for CSR #######');
            filter = getProd1Filters('CSR');
            rTypeId=mapOfReport.get('Prod1Report4CSR');
        } else if (rType.contains('Prod2Report')){
        	filter = getProd2Filters('CSR');
            rTypeId=mapOfReport.get('Prod2Report4CSR1');
        } else if (rType.contains('Prod3Report')){
        	filter = getProd3Filters('CSR');
            rTypeId=mapOfReport.get('Prod3Report4CSR');
        }
        
        reportUrl = baseUrl+rTypeId+filter+'&export=1&enc=UTF-8&xf=xls';
        //reportUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/GlobalfoundryView/'+rTypeId+'?pv0='+accShortNames+'&pn0=eq'+'&export=1&enc=UTF-8&xf=xls';
        
    } else if(userShortName<>NULL && userShortName.contains('Admin') && mapOfReport<>NULL){
        //ID rTypeId = null;
        system.debug('Inside ADMIN View ###########');
        if(rType.contains('OrderReport')){
        	filter = getOrderFilters('Admin');
            rTypeId=mapOfReport.get('OrderReport4Admin');
            system.debug('OrderReport for Admin #######'+rTypeId);
        } else if (rType.contains('ShipingReport')){
        	filter = getShipmentFilters('Admin');
            rTypeId=mapOfReport.get('ShipingReport4Admin');
        } else if (rType.contains('Prod1Report')){
        	filter = getProd1Filters('Admin');
            rTypeId=mapOfReport.get('Prod1Report4Admin');
        } else if (rType.contains('Prod2Report')){
        	filter = getProd2Filters('Admin');
            rTypeId=mapOfReport.get('Prod2Report4Admin1');
        } else if (rType.contains('Prod3Report')){
        	filter = getProd3Filters('Admin');
            rTypeId=mapOfReport.get('Prod3Report4Admin');
        }
        reportUrl = baseUrl+rTypeId+filter+'&export=1&enc=UTF-8&xf=xls';
        //reportUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/GlobalfoundryView/'+rTypeId+'?export=1&enc=UTF-8&xf=xls';
        system.debug('Export to excel URL >>>>>>>>>>>>>'+reportUrl);
        
    } else if(userShortName<>NULL && userShortName.contains('Portal User') && mapOfReport<>NULL){
        accShortNames = userShortName.split(':')[0];        
        rTypeValue = String.valueof(rType);         // [Hitesh] To resolve portal user access issue.
        reportUrl = null;                           // [Hitesh] To resolve portal user access issue.
    }    
    return reportUrl;
  }
  
  public pageReference reDirectToExport(){
  	
  	 // Start : [Hitesh] To resolve portal user access issue.
    if(reportUrl != null){
    // End : [Hitesh] To resolve portal user access issue.
         PageReference newpage=new PageReference(reportUrl);
         newpage.setRedirect(true);  
         return newpage;
    // Start : [Hitesh] To resolve portal user access issue.    
    }
    else{ 
        PageReference newocp = Page.exportToExcelPageForPortalUser;
        return newocp;
    } 
    // End : [Hitesh] To resolve portal user access issue.
  
  }
  
    // Start : [Hitesh] To resolve portal user access issue.  
    List<String> shortNamesForQuery = new List<String>();
    public List<String> lstcollumns{get; set;} 
    public List<String> lstcollumnsLabel{get; set;}
    public List<SObject> lstSObject {get;set;}
    Date fromDate;
    Date todate;
    
    /*
    * @ Description :- Method to get list of fields from field set to be displayed in excel for portal users.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */
    public String getFieldsForPortalUser(String reportType){
      
        List<Schema.FieldSetMember> fieldSetSchema = new List<Schema.FieldSetMember>();
        String fromText;
        lstcollumns = new List<String>();
        lstcollumnsLabel = new List<String>();
                
        if(reportType == 'OrderReport'){
            
            fieldSetSchema = SObjectType.OrderReport__c.FieldSets.Order_Report_Fields_For_Portal_User.getFields();
            fromText = ' from OrderReport__c';
        
        }else if(reportType == 'ShipingReport'){
            
            fieldSetSchema = SObjectType.ShippingReport__c.FieldSets.Shipping_Report_Fields_For_Portal_User.getFields();
            fromText = ' from ShippingReport__c';
                    
        }else if(reportType == 'Prod1Report'){
             
            fieldSetSchema = SObjectType.ProductionReport__c.FieldSets.Prod1_Report_Fields_For_Portal_User.getFields();
            fromText = ' from ProductionReport__c';

        }else if(reportType == 'Prod2Report'){
            
            fieldSetSchema = SObjectType.ProductionReport__c.FieldSets.Prod2_Report_Fields_For_Portal_User.getFields();
            fromText = ' from ProductionReport__c';
 
        }else if(reportType == 'Prod3Report'){
            
            fieldSetSchema = SObjectType.ProductionReport__c.FieldSets.Prod3_Report_Fields_For_Portal_User.getFields();
            fromText = ' from ProductionReport__c';
                   
        }   
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldSetSchema){
            query += f.getFieldPath() + ',';
            lstcollumns.add(String.ValueOf(f.getFieldPath()));
            lstcollumnsLabel.add(String.ValueOf(f.getLabel()));
        }
        query = query.substring(0,query.length()-1);
        query = query + fromText;
        return query;
    }
    /*
    * @ Description :- Method to get list of Account' shortNames which are to be accessed by current logged in portal user.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */
    
    public String getFiltersForPortalUser(String reportType){
        list<string> inputParam = gridParam.split(',');
        String filter =' where ';
        String userShortName = GF_DynamicQueryHandler.getUserShortName();
        String accShortNames;  
        accShortNames=userShortName.split(':')[0];
        shortNames = getAccShortNames(accShortNames);
        shortNamesForQuery = shortNames.split(',');
        filter=filter+' CUSTOMER_INITIAL__c IN: shortNamesForQuery';
        if(rTypeValue.contains('Prod2Report') || rTypeValue.contains('Prod3Report')){
            fromDate = convertStringToDate(inputParam[5]);
            toDate = convertStringToDate(inputParam[6]);
            filter = filter + ' and SHIP_DATE__c >= :fromDate and SHIP_DATE__c <= :toDate';
           
        } 
        if(rTypeValue.contains('OrderReport')){
            fromDate = convertStringToDate(inputParam[8]);
            toDate = convertStringToDate(inputParam[9]);
            filter = filter + ' and ORDER_DATE__c >= :fromDate and ORDER_DATE__c <= :toDate';
        
        } 
        if(rTypeValue.contains('ShipingReport')){
            fromDate = convertStringToDate(inputParam[5]);
            toDate = convertStringToDate(inputParam[6]);
            filter = filter + ' and SHIP_DATE__c >= :fromDate and SHIP_DATE__c <= :toDate';
        } 
        return filter;
    } 
    
    /*
    * @ Description :- Method will accept string in format(MM-DD-YYYY) and return Date.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */  
    public Date convertStringToDate(String stringDate){
        
        list<string> dd = stringDate.split('/');
        Date d = date.newinstance(Integer.ValueOf(dd[2]),Integer.ValueOf(dd[0]),Integer.ValueOf(dd[1]));    
        return d;
    }
    /*
    * @ Description :- Method used by VF page to prepare list of records to be exported.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */  
    public void exportToExcelForPortalUser(){
        
        fileType ='';        
        string queryFields; 
        string queryFilters; 
        
        if(rTypeValue.contains('OrderReport')){
            queryFields = getFieldsForPortalUser('OrderReport');
            queryFilters = getFiltersForPortalUser('OrderReport');
        } else if (rTypeValue.contains('ShipingReport')){
            queryFields = getFieldsForPortalUser('ShipingReport');
            queryFilters = getFiltersForPortalUser('ShipingReport');
        } else if (rTypeValue.contains('Prod1Report')){
            queryFields = getFieldsForPortalUser('Prod1Report');
            queryFilters = getFiltersForPortalUser('Prod1Report');
        } else if (rTypeValue.contains('Prod2Report')){
            queryFields = getFieldsForPortalUser('Prod2Report');
            queryFilters = getFiltersForPortalUser('Prod2Report');
        } else if (rTypeValue.contains('Prod3Report')){
            queryFields = getFieldsForPortalUser('Prod3Report');
            queryFilters = getFiltersForPortalUser('Prod3Report');
        }
        
        string queryString = queryFields + queryFilters;
        List<SObject> lstOfAllRecords = new List<SObject>();
        lstOfAllRecords = Database.Query(queryString);
        lstSObject = new List<SObject>();
        
        if(lstOfAllRecords.size()>0){
            if(rTypeValue.contains('OrderReport')){
                applyPageFiltersOfOrderReport(lstOfAllRecords);
            
            } else if (rTypeValue.contains('ShipingReport')){
                applyPageFiltersOfShipReport(lstOfAllRecords);
            
            } else if (rTypeValue.contains('Prod1Report') || (rTypeValue.contains('Prod2Report')) || (rTypeValue.contains('Prod3Report'))){
                applyPageFiltersOfProdReport(lstOfAllRecords);
            
            }
        }
    }
    /*
    * @ Description :- Method to apply filters on prod report which are used by portal user on page.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */  
    public void applyPageFiltersOfProdReport(List<ProductionReport__c> lstOfAllProdRecords){
    
        list<string> inputParam = gridParam.split(',');
        for(ProductionReport__c prod1 :lstOfAllProdRecords){
            
                Boolean passed = True;
                if(!inputParam[0].trim().contains('ALL')){
                    if(inputParam[0].contains('FAB 35')){
                        if(prod1.ACTUAL_FAB_GROUP__c !='FAB 3' && prod1.ACTUAL_FAB_GROUP__c != 'FAB 5'){
                            passed = False;
                        }
                    }else{
                        if(prod1.ACTUAL_FAB_GROUP__c != inputParam[0]){
                            passed = False;
                        }
                    }
                }       
                if(!inputParam[1].trim().contains('ALL')){
                    if(String.isBlank(prod1.CHARTERED_PART_NAME__c) || !prod1.CHARTERED_PART_NAME__c.contains(inputParam[1])){
                        passed = False;
                    }   
                }
                if(!inputParam[2].trim().contains('ALL')){
                    if(String.isBlank(prod1.CUSTOMER_PART_NAME__c) || !prod1.CUSTOMER_PART_NAME__c.contains(inputParam[2])){
                        passed = False;
                    }   
                }
                if(!inputParam[3].trim().contains('ALL')){
                    if(String.isBlank(prod1.LOTID__c) || !prod1.LOTID__c.contains(inputParam[3])){
                        passed = False;
                    }
                }
                if(!inputParam[4].trim().contains('ALL')){
                    if(String.isBlank(prod1.LOT_TYPE_DESC__c) || !prod1.LOT_TYPE_DESC__c.contains(inputParam[4])){
                        passed = False;
                    }
                }
                
            if(rTypeValue.contains('Prod1Report')){
                
                if(!inputParam[5].trim().contains('ALL')){
                    if(String.isBlank(prod1.PO_NO__c) || !prod1.PO_NO__c.contains(inputParam[5])){
                        passed = False;
                    }
                }
                if(!inputParam[6].trim().contains('ALL')){
                    if(String.isBlank(prod1.EPRF__c) || !prod1.EPRF__c.contains(inputParam[6])){
                        passed = False;
                    }
                }
                
            }
            if(rTypeValue.contains('Prod2Report') || rTypeValue.contains('Prod3Report')){
             
                if(!inputParam[7].trim().contains('ALL')){
                    if(String.isBlank(prod1.PO_NO__c) || !prod1.PO_NO__c.contains(inputParam[7])){
                        passed = False;
                    }
                }
                if(!inputParam[8].trim().contains('ALL')){
                    if(String.isBlank(prod1.EPRF__c) || !prod1.EPRF__c.contains(inputParam[8])){
                        passed = False;
                    }
                }
            }
            if(passed == True){
                lstSObject.add(prod1);
            }
        }
    }    
    /*
    * @ Description :- Method to apply filters on order report which are used by portal user on page.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */  
    public void applyPageFiltersOfOrderReport(List<OrderReport__c> lstOfAllOrderRecords){
        
        list<string> inputParam = gridParam.split(',');
        for(OrderReport__c ord :lstOfAllOrderRecords){
            
            Boolean passed = True;
            if(!inputParam[0].trim().contains('ALL')){
                if(String.isBlank(ord.PO__c) || !ord.PO__c.contains(inputParam[0])){
                    passed = False;
                }
            }
            if(!inputParam[1].trim().contains('ALL')){
                if(String.isBlank(ord.SO__c) || !ord.SO__c.contains(inputParam[1])){
                    passed = False;
                }
            }
            if(!inputParam[2].trim().contains('ALL')){
                if(String.isBlank(ord.GEOMETRY__c) || !ord.GEOMETRY__c.contains(inputParam[2])){
                    passed = False;
                }
            }
            if(!inputParam[3].trim().contains('ALL')){
                if(inputParam[3].contains('FAB 35')){
                    if(ord.ACTUAL_FAB_GROUP__c !='FAB 3' && ord.ACTUAL_FAB_GROUP__c != 'FAB 5'){
                            passed = False;
                    } 
                    else{
                        if(ord.ACTUAL_FAB_GROUP__c != inputParam[3]){
                            passed = False;
                        }
                    }
                }
            }
            if(!inputParam[4].trim().contains('ALL')){
                if(String.isBlank(ord.CHARTERED_PART_NAME__c) || !ord.CHARTERED_PART_NAME__c.contains(inputParam[4])){
                    passed = False;
                }
            }
            if(!inputParam[5].trim().contains('ALL')){
                if(String.isBlank(ord.CUSTOMER_PARTNO__c) || !ord.CUSTOMER_PARTNO__c.contains(inputParam[5])){
                    passed = False;
                }
            }
            if(!inputParam[6].trim().contains('ALL')){
                if(String.isBlank(ord.ORDER_STATUS__c) || !ord.ORDER_STATUS__c.contains(inputParam[6])){
                    passed = False;
                }
            }
            if(!inputParam[7].trim().contains('ALL')){
                if(String.isBlank(ord.ITEM_TYPE__c) || !ord.ITEM_TYPE__c.contains(inputParam[7])){
                    passed = False;
                }
            } 
            if(passed == True){
                lstSObject.add(ord);  
            } 
        }   
    }
    
    /*
    * @ Description :- Method to apply filters on shipping report which are used by portal user on page.  
    * @ Date :-        26th Dec 2017
    * @ Author :-      Hitesh Madan
    */  
    public void applyPageFiltersOfShipReport(List<ShippingReport__c> lstOfAllShipRecords){
        
        list<string> inputParam = gridParam.split(',');
        for(ShippingReport__c ship :lstOfAllShipRecords){
            
            Boolean passed = True;
            if(!inputParam[0].trim().contains('ALL')){
                if(String.isBlank(ship.GEOMETRY_NAME__c) || !ship.GEOMETRY_NAME__c.contains(inputParam[0])){
                    passed = False;
                }
            }
            if(!inputParam[1].trim().contains('ALL')){
                if(inputParam[1].contains('FAB 35')){
                    if(ship.ACTUAL_FAB_GROUP__c !='FAB 3' && ship.ACTUAL_FAB_GROUP__c != 'FAB 5'){
                            passed = False;
                    } 
                    else{
                        if(ship.ACTUAL_FAB_GROUP__c != inputParam[1]){
                            passed = False;
                        }
                    }
                }
            }
            if(!inputParam[2].trim().contains('ALL')){
                if(String.isBlank(ship.CHARTERED_PART_NAME__c) || !ship.CHARTERED_PART_NAME__c.contains(inputParam[2])){
                    passed = False;
                }
            }
            if(!inputParam[3].trim().contains('ALL')){
                if(String.isBlank(ship.CUSTOMER_PART_NAME__c) || !ship.CUSTOMER_PART_NAME__c.contains(inputParam[3])){
                    passed = False;
                }
            }
            if(!inputParam[4].trim().contains('ALL')){
                if(String.isBlank(ship.LOT_ID__c) || !ship.LOT_ID__c.contains(inputParam[4])){
                    passed = False;
                }
            }
            if(!inputParam[7].trim().contains('ALL')){
                if(String.isBlank(ship.ITEM_TYPE__c) || !ship.ITEM_TYPE__c.contains(inputParam[7])){
                    passed = False;
                }
            }
            if(!inputParam[8].trim().contains('ALL')){
                if(String.isBlank(ship.PO__c) || !ship.PO__c.contains(inputParam[8])){
                    passed = False;
                }
            }
            if(!inputParam[9].trim().contains('ALL')){
                if(String.isBlank(ship.TAX_INVOICE__c) || !ship.TAX_INVOICE__c.contains(inputParam[9])){
                    passed = False;
                }
            }
            if(!inputParam[10].trim().contains('ALL')){
                if(String.isBlank(ship.RMA_NO__c) || !ship.RMA_NO__c.contains(inputParam[10])){
                    passed = False;
                }
            }            
            if(passed == True){
                lstSObject.add(ship);  
            } 
        }   
    }
    // End: [Hitesh] To resolve portal user access issue. 
    /*
  * @ Description :- Method prepare order query filters dynamically
  * @ Date :- 9th Feb 2015
  * @ Author :- Navneet Rajput
  */
  public String getOrderFilters(String uType){
  	    String filter ='?';
  		list<string> inputParam = gridParam.split(',');
  		String userShortName = GF_DynamicQueryHandler.getUserShortName();
		String accShortNames;  

    	if(!inputParam[0].trim().contains('ALL')){
    		filter=filter+'&pv0='+inputParam[0]+'&pn0=co';
    	}
    	if(!inputParam[1].trim().contains('ALL')){
    		filter=filter+'&pv1='+inputParam[1]+'&pn1=co';
    	}
    	if(!inputParam[2].trim().contains('ALL')){
    		filter=filter+'&pv2='+inputParam[2]+'&pn2=co';
    	}
    	if(!inputParam[3].trim().contains('ALL')){
    		system.debug('Is it FAB filter ????????????????'+inputParam[3]);
    		if(inputParam[3].contains('FAB 35')){
    			filter=filter+'&pv3='+'FAB 3,FAB 5'+'&pn3=eq';
    		} else {
    			filter=filter+'&pv3='+inputParam[3]+'&pn3=eq';
    		}
    		system.debug('filter>>>>>>>>>>>>>'+filter);
    		//filter=filter+'&pv3='+inputParam[3]+'&pn3=eq';
    	}
    	if(!inputParam[4].trim().contains('ALL')){
    		filter=filter+'&pv4='+inputParam[4]+'&pn4=co';
    	}
    	if(!inputParam[5].trim().contains('ALL')){
    		filter=filter+'&pv5='+inputParam[5]+'&pn5=co';
    	}
    	if(!inputParam[6].trim().contains('ALL')){
    		filter=filter+'&pv6='+inputParam[6]+'&pn6=co';
    	}
    	if(!inputParam[7].trim().contains('ALL')){
    		filter=filter+'&pv7='+inputParam[7]+'&pn7=co';
    	}
    	// FROM DATE
    	filter=filter+'&pv9='+inputParam[8]+'&pn9=ge';
    	//TO DATE
    	filter=filter+'&pv10='+inputParam[9]+'&pn10=le';
    	if(uType.contains('Portal User')){
    		accShortNames=userShortName.split(':')[0];
        	shortNames = getAccShortNames(accShortNames);
        	 
        	system.debug('accShortNames>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+shortNames);
    		filter=filter+'&pv8='+shortNames+'&pn8=eq';
    		
    	} else if (uType.contains('Admin')){
    		//filter=filter+'&pv8='+accShortNames+'&pn8=co';
    	} else if(uType.contains('CSR')){
    		if(inputParam[11].trim().contains('@@') || inputParam[11].trim().contains('ALL')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        	system.debug('accShortNames>>>>>>>>'+accShortNames);
	        } else {
	        	accShortNames = inputParam[11].trim();
	        	accShortNames = getAccShortNames(accShortNames);
		        system.debug('Inside else accShortNames >>>>>>>>>>>>>'+accShortNames);
	        }
	        //accShortNames = inputParam[11].trim();
	        filter=filter+'&pv8='+accShortNames+'&pn8=eq';
    	}
    	system.debug('filter is >>>>>>>>>>>>>>>>'+filter);
        	
  		return filter;
  }
  /*
  * @ Description :- Method prepare Production query filters dynamically
  * @ Date :- 10th Feb 2015
  * @ Author :- Navneet Rajput
  */
  public String getProd1Filters(String uType){
		String filter ='?';
  		list<string> inputParam = gridParam.split(',');
  		String userShortName = GF_DynamicQueryHandler.getUserShortName();
		String accShortNames;  

    	if(!inputParam[0].trim().contains('ALL')){
    		//filter=filter+'&pv0='+inputParam[0]+'&pn0=co';
    		system.debug('Is it FAB filter ????????????????'+inputParam[0]);
    		if(inputParam[0].contains('FAB 35')){
    			filter=filter+'&pv0='+'FAB 3,FAB 5'+'&pn0=eq';
    		} else {
    			filter=filter+'&pv0='+inputParam[0]+'&pn0=eq';
    		}
    	}
    	if(!inputParam[1].trim().contains('ALL')){
    		filter=filter+'&pv1='+inputParam[1]+'&pn1=co';
    	}
    	if(!inputParam[2].trim().contains('ALL')){
    		filter=filter+'&pv2='+inputParam[2]+'&pn2=co';
    	}
    	if(!inputParam[3].trim().contains('ALL')){
    		filter=filter+'&pv3='+inputParam[3]+'&pn3=co';
    	}
    	if(!inputParam[4].trim().contains('ALL')){
    		filter=filter+'&pv4='+inputParam[4]+'&pn4=co';
    	}
    	if(!inputParam[5].trim().contains('ALL')){
    		filter=filter+'&pv5='+inputParam[5]+'&pn5=co';
    	}
    	if(!inputParam[6].trim().contains('ALL')){
    		filter=filter+'&pv6='+inputParam[6]+'&pn6=co';
    	}
    	//FROM DATE
    	//filter=filter+'&pv10='+inputParam[5]+'&pn10=eq';
    	// TO DATE
    	//filter=filter+'&pv11='+inputParam[6]+'&pn11=eq';
    	
    	if(uType.contains('Portal User')){
    		accShortNames=userShortName.split(':')[0];
        	/*Account acc = [SELECT ID,Short_Name__c FROM Account WHERE Short_Name__c =:accShortNames limit 1];
        	accShortNames = getAllChildAccounts(acc.ID);
        	system.debug('accShortNames>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+accShortNames);*/
        	shortNames = getAccShortNames(accShortNames);
        	system.debug('shortNames>>>>>>>>>>>>>>>>>>>>>>>'+shortNames);
    		filter=filter+'&pv7='+shortNames+'&pn7=eq';
    		
    	} else if (uType.contains('Admin')){
    		//filter=filter+'&pv8='+accShortNames+'&pn8=co';
    	} else if(uType.contains('CSR')){
            //accShortNames = inputParam[8].trim();
            if(inputParam[8].trim().contains('@@') || inputParam[8].trim().contains('ALL')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        	system.debug('accShortNames>>>>>>>>'+accShortNames);
	        } else {
		        accShortNames = inputParam[8].trim();
		        accShortNames = getAccShortNames(accShortNames);
		        system.debug('Inside else accShortNames >>>>>>>>>>>>>'+accShortNames);
	        }
	        filter=filter+'&pv7='+accShortNames+'&pn7=eq';
    	}
    	system.debug('filter is >>>>>>>>>>>>>>>>'+filter);
        	
  		return filter;
  }
  
  /*
  * @ Description :- Method prepare Production query filters dynamically
  * @ Date :- 16th Feb 2015
  * @ Author :- Navneet Rajput
  */
  public String getProd2Filters(String uType){
		String filter ='?';
  		list<string> inputParam = gridParam.split(',');
  		String userShortName = GF_DynamicQueryHandler.getUserShortName();
		String accShortNames;  

    	if(!inputParam[0].trim().contains('ALL')){
    		//filter=filter+'&pv0='+inputParam[0]+'&pn0=co';
    		system.debug('Is it FAB filter ????????????????'+inputParam[0]);
    		if(inputParam[0].contains('FAB 35')){
    			filter=filter+'&pv0='+'FAB 3,FAB 5'+'&pn0=eq';
    		} else {
    			filter=filter+'&pv0='+inputParam[0]+'&pn0=eq';
    		}
    	}
    	if(!inputParam[1].trim().contains('ALL')){
    		filter=filter+'&pv1='+inputParam[1]+'&pn1=co';
    	}
    	if(!inputParam[2].trim().contains('ALL')){
    		filter=filter+'&pv2='+inputParam[2]+'&pn2=co';
    	}
    	if(!inputParam[3].trim().contains('ALL')){
    		filter=filter+'&pv3='+inputParam[3]+'&pn3=co';
    	}
    	if(!inputParam[4].trim().contains('ALL')){
    		filter=filter+'&pv4='+inputParam[4]+'&pn4=co';
    	}
    	// FROM DATE
    	filter=filter+'&pv8='+inputParam[5]+'&pn8=ge';
    	// TO DATE
    	filter=filter+'&pv9='+inputParam[6]+'&pn9=le';
    	if(!inputParam[7].trim().contains('ALL')){
    		filter=filter+'&pv5='+inputParam[7]+'&pn5=co';
    	}
    	if(!inputParam[8].trim().contains('ALL')){
    		filter=filter+'&pv6='+inputParam[8]+'&pn6=co';
    	}
    	
    	if(uType.contains('Portal User')){
    		//accShortNames=userShortName.split(':')[0];
    		accShortNames=userShortName.split(':')[0];
        	/*Account acc = [SELECT ID,Short_Name__c FROM Account WHERE Short_Name__c =:accShortNames limit 1];
        	accShortNames = getAllChildAccounts(acc.ID);
        	system.debug('accShortNames>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+accShortNames);*/
        	shortNames = getAccShortNames(accShortNames);
        	system.debug('shortNames>>>>>>>>>>>>>>>>>>>>>>>'+shortNames);
        	
    		filter=filter+'&pv7='+shortNames+'&pn7=eq';
    	} else if (uType.contains('Admin')){
    		//filter=filter+'&pv8='+accShortNames+'&pn8=co';
    	} else if(uType.contains('CSR')){
            //accShortNames = inputParam[10].trim();
            if(inputParam[10].trim().contains('@@') || inputParam[10].trim().contains('ALL')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        	system.debug('accShortNames>>>>>>>>'+accShortNames);
	        } else {
		        accShortNames = inputParam[10].trim();
		        accShortNames = getAccShortNames(accShortNames);
		        system.debug('Inside else accShortNames >>>>>>>>>>>>>'+accShortNames);
	        }
	        filter=filter+'&pv7='+accShortNames+'&pn7=eq';
    	}
    	system.debug('filter is >>>>>>>>>>>>>>>>'+filter);
        	
  		return filter;
  }
  
  /*
  * @ Description :- Method prepare Production query filters dynamically
  * @ Date :- 10th Feb 2015
  * @ Author :- Navneet Rajput
  */
  public String getProd3Filters(String uType){
		String filter ='?';
  		list<string> inputParam = gridParam.split(',');
  		String userShortName = GF_DynamicQueryHandler.getUserShortName();
		String accShortNames;  

    	if(!inputParam[0].trim().contains('ALL')){
    		//filter=filter+'&pv0='+inputParam[0]+'&pn0=co';
    		system.debug('Is it FAB filter ????????????????'+inputParam[0]);
    		if(inputParam[0].contains('FAB 35')){
    			filter=filter+'&pv0='+'FAB 3,FAB 5'+'&pn0=eq';
    		} else {
    			filter=filter+'&pv0='+inputParam[0]+'&pn0=eq';
    		}
    	}
    	if(!inputParam[1].trim().contains('ALL')){
    		filter=filter+'&pv1='+inputParam[1]+'&pn1=co';
    	}
    	if(!inputParam[2].trim().contains('ALL')){
    		filter=filter+'&pv2='+inputParam[2]+'&pn2=co';
    	}
    	if(!inputParam[3].trim().contains('ALL')){
    		filter=filter+'&pv3='+inputParam[3]+'&pn3=co';
    	}
    	if(!inputParam[4].trim().contains('ALL')){
    		filter=filter+'&pv4='+inputParam[4]+'&pn4=co';
    	}
    	// FROM DATE
    	filter=filter+'&pv8='+inputParam[5]+'&pn8=ge';
    	// TO DATE
    	filter=filter+'&pv9='+inputParam[6]+'&pn9=le';
    	if(!inputParam[7].trim().contains('ALL')){
    		filter=filter+'&pv5='+inputParam[7]+'&pn5=co';
    	}
    	if(!inputParam[8].trim().contains('ALL')){
    		filter=filter+'&pv6='+inputParam[8]+'&pn6=co';
    	}
    	
    	if(uType.contains('Portal User')){
    		//accShortNames=userShortName.split(':')[0];
    		accShortNames=userShortName.split(':')[0];
        	/*Account acc = [SELECT ID,Short_Name__c FROM Account WHERE Short_Name__c =:accShortNames limit 1];
        	accShortNames = getAllChildAccounts(acc.ID);
        	system.debug('accShortNames>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+accShortNames);*/
        	shortNames = getAccShortNames(accShortNames);
        	system.debug('shortNames>>>>>>>>>>>>>>>>>>>>>>>'+shortNames);
    		filter=filter+'&pv7='+shortNames+'&pn7=eq';
    	} else if (uType.contains('Admin')){
    		//filter=filter+'&pv8='+accShortNames+'&pn8=co';
    	} else if(uType.contains('CSR')){
            //accShortNames = inputParam[10].trim();
	        if(inputParam[10].trim().contains('@@') || inputParam[10].trim().contains('ALL')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        	system.debug('accShortNames>>>>>>>>'+accShortNames);
	        } else {
		        accShortNames = inputParam[10].trim();
		        accShortNames = getAccShortNames(accShortNames);
		        system.debug('Inside else accShortNames >>>>>>>>>>>>>'+accShortNames);
	        }
	        filter=filter+'&pv7='+accShortNames+'&pn7=eq';
    	}
    	system.debug('filter is >>>>>>>>>>>>>>>>'+filter);
        	
  		return filter;
  }
  
	/*
  * @ Description :- Method prepare Shiping query filters dynamically
  * @ Date :- 10th Feb 2015
  * @ Author :- Navneet Rajput
  */
  public String getShipmentFilters(String uType){
  	    String filter ='?';
  		list<string> inputParam = gridParam.split(',');
  		String userShortName = GF_DynamicQueryHandler.getUserShortName();
		String accShortNames;  

    	if(!inputParam[0].trim().contains('ALL')){
    		filter=filter+'&pv0='+inputParam[0]+'&pn0=co';
    	}
    	if(!inputParam[1].trim().contains('ALL')){
    		//filter=filter+'&pv1='+inputParam[1]+'&pn1=co';
    		system.debug('Is it FAB filter ????????????????'+inputParam[1]);
    		if(inputParam[1].contains('FAB 35')){
    			filter=filter+'&pv1='+'FAB 3,FAB 5'+'&pn1=eq';
    		} else {
    			filter=filter+'&pv1='+inputParam[1]+'&pn1=eq';
    		}
    	}
    	if(!inputParam[2].trim().contains('ALL')){
    		filter=filter+'&pv2='+inputParam[2]+'&pn2=co';
    	}
    	if(!inputParam[3].trim().contains('ALL')){
    		filter=filter+'&pv3='+inputParam[3]+'&pn3=co';
    	}
    	if(!inputParam[4].trim().contains('ALL')){
    		filter=filter+'&pv4='+inputParam[4]+'&pn4=co';
    	}
    	if(!inputParam[7].trim().contains('ALL')){
    		filter=filter+'&pv5='+inputParam[7]+'&pn5=co';
    	}
    	if(!inputParam[8].trim().contains('ALL')){
    		filter=filter+'&pv6='+inputParam[8]+'&pn6=co';
    	}
    	if(!inputParam[9].trim().contains('ALL')){
    		filter=filter+'&pv7='+inputParam[9]+'&pn7=co';
    	}
    	if(!inputParam[10].trim().contains('ALL')){
    		filter=filter+'&pv8='+inputParam[10]+'&pn8=co';
    	}
    	//FROM DATE
    	filter=filter+'&pv10='+inputParam[5]+'&pn10=ge';
    	// TO DATE
    	filter=filter+'&pv11='+inputParam[6]+'&pn11=le';
    	
    	if(uType.contains('Portal User')){
    		//accShortNames=userShortName.split(':')[0];
    		accShortNames=userShortName.split(':')[0];
        	/*Account acc = [SELECT ID,Short_Name__c FROM Account WHERE Short_Name__c =:accShortNames limit 1];
        	accShortNames = getAllChildAccounts(acc.ID);
        	system.debug('accShortNames>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+accShortNames);*/
        	shortNames = getAccShortNames(accShortNames);
        	system.debug('shortNames>>>>>>>>>>>>>>>>>>>>>>>'+shortNames);
        	
    		filter=filter+'&pv9='+shortNames+'&pn9=eq';
    	} else if (uType.contains('Admin')){
    		//filter=filter+'&pv8='+accShortNames+'&pn8=co';
    	} else if(uType.contains('CSR')){
    		/*if(customerInitial.contains('@@')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        } else {
	        	accShortNames = inputParam[11].trim();
	        }*/
	        if(inputParam[12].trim().contains('@@') || inputParam[12].trim().contains('ALL')){
	        	accShortNames = GF_DynamicQueryHandler.getCSRs(userInfo.getUserId());
	        	system.debug('accShortNames>>>>>>>>'+accShortNames);
	        } else {
		        accShortNames = inputParam[12].trim();
		        accShortNames = getAccShortNames(accShortNames);
		        system.debug('Inside else accShortNames >>>>>>>>>>>>>'+accShortNames);
	        }
	        filter=filter+'&pv9='+accShortNames+'&pn9=eq';
    	}
    	system.debug('filter is >>>>>>>>>>>>>>>>'+filter);
        	
  		return filter;
  }
		
   /*
  * @ Description :- common method which help to iterate account hirarchy and get account short names 
  * @ Date :- 12nd March 2015
  * @ Author :- Navneet Rajput
  */
  
  public String getAccShortNames(String accShortNames){
	    allAccMap = new MAP<ID,Account>([SELECT ID,Name, Short_Name__c, ParentID from Account]);
		Account acc = [SELECT ID,Short_Name__c FROM Account WHERE Short_Name__c =:accShortNames limit 1];
		if(String.isBlank(shortNames)){
			if(allAccMap<>NULL && !allAccMap.isEmpty()){
				shortNames = allAccMap.get(acc.ID).Short_Name__c;
			}
		}
		String tempAccNames='';
			
    	for(Account acc1 : [SELECT ID,Name, Short_Name__c, ParentID from Account Where ParentID = : acc.Id]){
    		system.debug('Accout names :::>>>>>>>>>>>>>'+acc1.Short_Name__c);
    		tempShrtName='';
    		if(String.isBlank(tempAccNames)){
    			tempAccNames = getAllChildAccounts(acc1.ID);
    		} else{
    			tempAccNames = tempAccNames+','+getAllChildAccounts(acc1.ID);
    		}
    	}
    	if(!String.isBlank(tempAccNames)){
    		shortNames=shortNames+','+tempAccNames;
    	} 
    	return shortNames; 	
  }
  
  /*
  * @ Description :- Method iterate through account hirarchy and get all child account of selected account 
  * @ Date :- 2nd March 2015
  * @ Author :- Navneet Rajput
  */
  public String getAllChildAccounts(ID accID){
	  	system.debug('Inside getAllChildAccounts>>>>>>>>'+accID);
	  	accParentMap = new Map<ID,account>();
	  	
	  	if(String.isBlank(tempShrtName)){
	  		if(allAccMap<>NULL && !allAccMap.isEmpty()){
	  			tempShrtName = allAccMap.get(accID).Short_Name__c;
	  		}
	  	}
	  	if(allAccMap<>NULL && !allAccMap.isEmpty()){
	  		if(accParentMap==NULL || accParentMap.isEmpty()){
	  			for(Account acc : allAccMap.values()){
	  				if(acc.ParentId<>NULL){
	  					accParentMap.put(acc.ParentId,acc);
	  				}
	  			}
	  		}
	  	}
	  	system.debug('accParentMap>>>>>>>>'+accParentMap);
	  	//system.debug('allAccMap>>>>>>>>>>>>>'+allAccMap);
	  	//system.debug('accParentMap.containsKey(accID)>>>>>>>>>>>>>>.'+accParentMap.containsKey(accID));
	  	if(accParentMap<>NULL && accParentMap.containsKey(accID)){
	  		ID newParentId = accParentMap.get(accID).Id;
	  		if(!String.isBlank(tempShrtName)){
	  			tempShrtName = tempShrtName+','+accParentMap.get(accID).Short_Name__c;
	  			system.debug('tempShrtName>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..'+tempShrtName);
	  		}
	  		// Call recursive 
	  		getAllChildAccounts(newParentId);
	  	}
  		return tempShrtName;
  }		
  
  /*  
    private Boolean orderReportToExcel(){
        Boolean isError = false;
        try {
            String customerShortName;
            list<string> inputParam = gridParam.split(',');
            
             if (inputParam[11]=='' || inputParam[11]== null || inputParam[11]=='@@'){  
                customerShortName = GF_DynamicQueryHandler.getUserShortName();
             }else{
                customerShortName = inputParam[11]+':'+'Portal User';     
             }
            List<GF_OrderStub.OrderSummaryInfo_element> DummyorderLst = new List <GF_OrderStub.OrderSummaryInfo_element>();
            listOfOrderReport = new List<List<GF_OrderStub.OrderSummaryInfo_element>>();
            
            GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();                                                   
            if (inputParam.size()>0){                                           
                GF_OrderStub.OrderSummaryResponse_element Result = resp.OrderSummary(inputParam[0], inputParam[1],
                                                                                    inputParam[2],inputParam[3],
                                                                                    inputParam[4],inputParam[5],inputParam[6],
                                                                                    inputParam[7],inputParam[8],
                                                                                    inputParam[9],customerShortName,inputParam[10],recordCount);
                                                                        
                //ShipingRecordsLst = response.ShipInfo;    
                
                for (GF_OrderStub.OrderSummaryInfo_element orderElement : Result.OrderSummaryInfo){
                    DummyorderLst.add(orderElement);
                    if (DummyorderLst.size() == 1000){
                        listOfOrderReport.add(DummyorderLst);
                        DummyorderLst = new List <GF_OrderStub.OrderSummaryInfo_element>();
                    }
                }
                if (DummyorderLst.size()>0){
                    listOfOrderReport.add(DummyorderLst);
                }
                Result=null;
            }
            
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
    }
 */   
    
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 09-11-2013 
    * @ Description :- Generate Excel for Order Backlog Report data
    * @ Author      :- Navneet Rajput
    **/
   
    private Boolean orderBacklogReportToExcel(){
        Boolean isError = false;
        try {
            List<GF_OrderStub.BackLogInfo_element> DummyorderBklLst = new List<GF_OrderStub.BackLogInfo_element>();
            listOfBklOrderReport = new List<List<GF_OrderStub.BackLogInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();                                                   
            if (inputParam.size()>0){                                           
                GF_OrderStub.BackLogResponse_element Result = resp.BackLog(inputParam[0],'','');                                                        
                //ShipingRecordsLst = response.ShipInfo;    
                for (GF_OrderStub.BackLogInfo_element orderElement : Result.BackLogInfo){
                    DummyorderBklLst.add(orderElement);
                    if (DummyorderBklLst.size() == 1000){
                        listOfBklOrderReport.add(DummyorderBklLst);
                        DummyorderBklLst = new List <GF_OrderStub.BackLogInfo_element>();
                    }
                }
                if (DummyorderBklLst.size()>0){
                    listOfBklOrderReport.add(DummyorderBklLst);
                }
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
    }
    
    /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 09-11-2013 
    * @ Description :- Generate Excel for Order Shipment Report data
    * @ Author      :- Navneet Rajput
    **/
   
    private Boolean orderShipmentReportToExcel(){
        Boolean isError = false;
        try {
            List <GF_OrderStub.ShipSummaryForOrderInfo_element> dummyOrderShipmentlst = new List <GF_OrderStub.ShipSummaryForOrderInfo_element>();
            listOfShipmentOrderReport = new List<List<GF_OrderStub.ShipSummaryForOrderInfo_element>>();
            list<string> inputParam = gridParam.split(',');
            GF_OrderStub.SFOrderQueryService_pt resp = new GF_OrderStub.SFOrderQueryService_pt();                                                   
            if (inputParam.size()>0){                                           
                GF_OrderStub.ShipSummaryForOrderResponse_element Result = resp.ShipSummaryForOrder(inputParam[0],'','');                                                        
                for (GF_OrderStub.ShipSummaryForOrderInfo_element orderElement : Result.ShipSummaryForOrderInfo){
                    dummyOrderShipmentlst.add(orderElement);
                    if (dummyOrderShipmentlst.size() == 1000){
                        listOfShipmentOrderReport.add(dummyOrderShipmentlst);
                        dummyOrderShipmentlst = new List <GF_OrderStub.ShipSummaryForOrderInfo_element>();
                    }
                }
                if (dummyOrderShipmentlst.size()>0){
                    listOfShipmentOrderReport.add(dummyOrderShipmentlst);
                }
            }
            return isError;
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
    }
    
  // ORDER REPORT TO EXCEL END  
 
  // PRODUCTION QUERY REPORT EXPORT TO EXCEL START
  
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for EPRF production Report data
    * @ Author      :- Navneet Rajput
    **/
   
   private boolean EprfReportToExcel(){
        Boolean isError = false;
        try {
            String CustomerInitial = GF_DynamicQueryHandler.getUserShortName();
            list<string> inputParam = gridParam.split(',');
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
                GF_ProductionQueryStub.ProcEprfResponse_element response = result.SFProcEprfService(inputParam[0],'','','','','');
                                                                        
               eprfReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
   
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for Current Runsheet production Report data
    * @ Author      :- Navneet Rajput
    **/
   
   private boolean currentRunShitReportToExcel(){
       Boolean isError = false;
        try {
            String CustomerInitial = GF_DynamicQueryHandler.getUserShortName();
            list<string> inputParam = gridParam.split(',');
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
                GF_ProductionQueryStub.RunSheetResponse_element response = result.SFRunSheetService(inputParam[0],inputParam[1],inputParam[2],'','','','','');
                                                                        
               currentRunsheetReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
   
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for wafer start production Report data
    * @ Author      :- Navneet Rajput
    **/
   
   private boolean waferStartReportToExcel(){
   
       Boolean isError = false;
        try {
            String CustomerInitial = GF_DynamicQueryHandler.getUserShortName();
            list<string> inputParam = gridParam.split(',');
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
               GF_ProductionQueryStub.WaferStartResponse_element response = result.SFWaferStartService(inputParam[0],inputParam[1],inputParam[2],'','','','');                                                                        
               waferStartReport = response.OUTPUTTABLE;
               system.debug('Wafer Start Report Export to Excel>>>>>>>>>>>>>>>>'+waferStartReport); 
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
   
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for FabOut Location production Report data
    * @ Author      :- Navneet Rajput
    **/
   
   private boolean faboutLocationReportToExcel(){
       Boolean isError = false;
        try {
            String CustomerInitial = GF_DynamicQueryHandler.getUserShortName();
            list<string> inputParam = gridParam.split(',');
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
               GF_ProductionQueryStub.FabOutLocationResponse_element response = result.SFFabOutLocationService(inputParam[0],inputParam[1],inputParam[2],'','','','');
               faboutLocationReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
   
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for WIP production Report data
    * @ Author      :- Navneet Rajput
    **/
   /*
   private boolean ProductionReport1ToExcel(){
   
       Boolean isError = false;
        try {
            String customerShortName;
             list<string> inputParam = gridParam.split(',');
             
             if (inputParam[8]=='' || inputParam[8] == null || inputParam[8]=='@@'){  
                customerShortName = GF_DynamicQueryHandler.getUserShortName();
             }else{
                customerShortName = inputParam[8]+':'+'Portal User';     
             }
             
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
                GF_ProductionQueryStub.ProdWIPLotSmryResponse_element response = result.SFProdWIPLotSmryService(inputParam[0],inputParam[1],
                                                                                                                inputParam[2],inputParam[3],
                                                                                                                inputParam[4],inputParam[5],
                                                                                                                inputParam[6],customerShortName,inputParam[7],
                                                                                                                recordCount,'','','');
                                                                        
               wipLotReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   } 
  */
  
  /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for WIP&Lot production Report data
    * @ Author      :- Navneet Rajput
    **/
/*   
   private boolean ProductionReport2ToExcel(){
       Boolean isError = false;
        try {
             String customerShortName;
             list<string> inputParam = gridParam.split(',');
             
             if (inputParam[10]=='' || inputParam[10] == null || inputParam[10] =='@@'){  
                customerShortName = GF_DynamicQueryHandler.getUserShortName();
             }else{
                customerShortName = inputParam[10]+':'+'Portal User';     
             }
            //list<string> inputParam = gridParam.split(',');
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
                GF_ProductionQueryStub.ProdWIPSHIPLotSmryResponse_element response = result.SFProdWIPSHIPLotSmryService(inputParam[0],inputParam[1],
                                                                                                                        inputParam[2],inputParam[3],
                                                                                                                        inputParam[4],inputParam[5],
                                                                                                                        inputParam[6],inputParam[7],
                                                                                                                        inputParam[8],customerShortName,
                                                                                                                        inputParam[9],recordCount,'','','');
                                                                        
               wipAndShipLotReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
 */ 
   /*
    * @ company     :- Cognizant Technology Solution
    * @ Date        :- 18-02-2014 
    * @ Description :- Generate Excel for Lot start date production Report data
    * @ Author      :- Navneet Rajput
    **/
 /*  
   private boolean ProductionReport3ToExcel(){
       Boolean isError = false;
        try {
             String customerShortName;
             list<string> inputParam = gridParam.split(',');
             if (inputParam[10]=='' || inputParam[10] == null || inputParam[10]=='@@'){  
                customerShortName = GF_DynamicQueryHandler.getUserShortName();
             }else{
                customerShortName = inputParam[10]+':'+'Portal User';     
             }
             
            GF_ProductionQueryStub.SFProdService_pt_pt result = new GF_ProductionQueryStub.SFProdService_pt_pt();                                                 
          
            if (inputParam.size()>0){       
                GF_ProductionQueryStub.ProdLotStrtSmryResponse_element response = result.SFProdLotStrtSmryService(inputParam[0],inputParam[1],
                                                                                                                  inputParam[2],inputParam[3],
                                                                                                                  inputParam[4],inputParam[5],
                                                                                                                  inputParam[6],inputParam[7],
                                                                                                                  inputParam[8],customerShortName,
                                                                                                                  inputParam[9],recordCount,'','','');
                                                                        
               lotStartDateReport = response.OUTPUTTABLE;
            
            }
            return isError;
            
        } catch (Exception e){
            isError = true;
            system.debug('EXCEPTION :: '+e.getMessage());
            return isError;
        }
   }
 */ 
  //PRODUCTION QUERY REPORT EXPORT TO EXCEL END
 
 
    
   /*
    * @ Author      :- Cognizant Technology Solution
    * @ Date        :- 08-22-2013 
    * @ Description :- set flages to true/false on basis of report type and generate excel file for true flag
    **/
     
     
   public void resetShippingQueryFlags(Boolean isShippingReport,Boolean isPoReport,Boolean isIpnReport,
                                        Boolean isLotReport,Boolean isShipDateReport,Boolean isShipingDetailReport,
                                        Boolean isOrderReport,Boolean isBacklogreport,Boolean isOrderShipmentReport){
                                            
        this.isShippingReport       =   isShippingReport;
        this.isPoReport             =   isPoReport; 
        this.isIpnReport            =   isIpnReport;
        this.isLotReport            =   isLotReport;
        this.isShipDateReport       =   isShipDateReport;
        this.isShipingDetailReport  =   isShipingDetailReport;
        this.isOrderReport          =   isOrderReport;
        this.isBacklogreport        =   isBacklogreport;
        this.isOrderShipmentReport  =   isOrderShipmentReport;
   } 
    
    public  pageReference refreshGrid(){
        //system.debug('ERROR MESSAGE IS >>>>>>>>>>>>: '+errorMessage);
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
        //ApexPages.addMessage(myMsg);
        return null;    
    }
    
    // CODE NEED TO DELETE AFTER TESTING
    public static string custName {get;set;}
    public static string oldDate {get;set;}
    
    // CODE FOR GETTING PREVIOUS DATA VALUES FROM CUSTOM SETTING
    public List<SelectOption> getPreviousDate(){
  
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('---NONE---','---NONE---'));
        options.add(new SelectOption('7','Last Week'));
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('365','Last 1 Year'));
        options.add(new SelectOption('730','ALL'));
        
       /* List<String> dateValues = new List<String>();
        Map<String, GF_DQ_Date_Settings__c> dateValueMap = GF_DQ_Date_Settings__c.getAll();
        dateValues.addAll(dateValueMap.keySet());
        dateValues.sort();
        for (String key : dateValues) {
            options.add(new SelectOption(dateValueMap.get(key).Number_Of_Days__c,dateValueMap.get(key).Name));
        }*/
        return options;
    }
    
   // Method returms list of customer short name which are associated with CSR user
    
   public List<SelectOption> getCustomerList() {
  
        List<Account_Team_Proxy__c> accountTeamProxyRecordsList;
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('---ALL---','---ALL---'));
        String userShortName = GF_DynamicQueryHandler.getUserShortName(); 
          
        if (userShortName!=null && userShortName!=''){   
            if (userShortName.contains('CSR')){  
            
               accountTeamProxyRecordsList = [Select Id,Account_Short_Name__c 
                                              From   Account_Team_Proxy__c   
                                              where  User__c =:UserInfo.getUserId()];
                
                if (!accountTeamProxyRecordsList.isEmpty()){
                    for (Account_Team_Proxy__c ATP : accountTeamProxyRecordsList){
                        if (ATP.Account_Short_Name__c!=null && ATP.Account_Short_Name__c!=''){
                            options.add(new SelectOption(ATP.Account_Short_Name__c,ATP.Account_Short_Name__c));
                        }                        
                    } 
                }
            }
       }     
        
        return options;
   }   
    
   // Method Returns logged in yours short name 
   private static string getUserShortName(){
        
        String userShortName;
        User userObject = [SELECT accountId,Portal_Login__c,
                                  HCM_Login_ID__c,UserType,
                                  FederationIdentifier,
                                  Profile.Name 
                           FROM   User 
                           WHERE  Id =:userInfo.getUserId()];
        
       /* Profile profileName = [SELECT Name
                               FROM   Profile
                               WHERE  Id = : Userinfo.getProfileId()];*/
        String profile4CSR = Environment_Variable__c.getValues('USER_SHORTNAME_CSR_PROFILES')!=null?Environment_Variable__c.getValues('USER_SHORTNAME_CSR_PROFILES').value__c:'';       //Thomas Lai  on 18/06/2014  
        String profile4Admin = Environment_Variable__c.getValues('USER_SHORTNAME_ADMIN_PROFILES')!=null?Environment_Variable__c.getValues('USER_SHORTNAME_ADMIN_PROFILES').value__c:'';   //Thomas Lai  on 18/06/2014    
                           
        if (profile4CSR.contains(userObject.Profile.Name)){           //Thomas Lai  on 18/06/2014                
             userShortName = userObject.HCM_Login_ID__c+':'+'CSR';             
                           
        } else if (profile4Admin.contains(userObject.Profile.Name)){    //Thomas Lai  on 18/06/2014  
        
             userShortName = 'ALL' + ':' +'Admin';
             
        } else if (userObject.UserType != 'Standard'){
        
             Account accountShortName = [SELECT Short_Name__c
                                         FROM   Account
                                         WHERE  Id =: userObject.accountId];
                                         
             userShortName = accountShortName.Short_Name__c+':'+'Portal User';                             
        }
        return userShortName;
     }        
    
    // Method use to get list of CSRs for export to excel     
    private static String getCSRs(Id csrUsr){
        String accSrtNames='';
        List<Account_Team_Proxy__c> lstOfATP = [SELECT User__r.Name,User__c,Account__r.Short_Name__c 
                                                FROM Account_Team_Proxy__c 
                                                WHERE User__c =: csrUsr];
                                                
        if(lstOfATP<>NULL && !lstOfATP.isEmpty()){                                      
            for (Account_Team_Proxy__c ATP : lstOfATP){
                if(String.isBlank(accSrtNames)){
                    accSrtNames = ATP.Account__r.Short_Name__c;
                } else {
                    accSrtNames=accSrtNames+','+ATP.Account__r.Short_Name__c;
                }
            }   
        }                                   
        
        return accSrtNames;
    } 
     
 }