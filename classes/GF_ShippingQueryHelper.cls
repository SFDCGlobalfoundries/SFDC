/*
*   @ Author        : Cognizant Technology LTD.
*   @ Description   : Class Handles operation related to Shipping query to generate report for Shipping query 
*   @ Date          : 8th July 2013
*   @ Param         :
*   @ Methods       : 
**/

global class GF_ShippingQueryHelper {

    public String ShippingQuery_FAB                 {get;set;}
    public String ShippingQuery_geometry            {get;set;}
    public String ShippingQuery_LotId               {get;set;}
    public String ShippingQuery_RMA                 {get;set;}
    public String ShippingQuery_InvoiceNumber       {get;set;}
    public String ShippingQuery_PO                  {get;set;}
    public String ShippingQuery_orderType           {get;set;}
    public String ShippingQuery_customerPartName    {get;set;}
    public String ShippingQuery_internalPartName    {get;set;}
    public Date ShippingQuery_lotShipingFrom        {get;set;}
    public Date ShippingQuery_lotShipingTo          {get;set;}
    
    public GF_ShippingQueryHelper(){
        
    }
    
    public List<SelectOption> getFabList() {

        return GF_CommonUtilityCls.getFabList();       
    }
    
    public List<SelectOption> getGeometryList() {

        return GF_CommonUtilityCls.getGeometryList();
    }
    
    public List<SelectOption> getOrderTypeList() {

        return GF_CommonUtilityCls.getOrderTypeList();
    }
}