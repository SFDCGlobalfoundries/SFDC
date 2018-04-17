/*
*   @ Author        : Cognizant Technology LTD.
*   @ Description   : Class Handles operation related to order query to generate report for order query 
*   @ Date          : 8th July 2013
*   @ Param         :
*   @ Methods       : 
**/

global class GF_OrderQueryHelper {
    
    public String orderQuery_PO                 {get;set;}
    public string orderQuery_SO                 {get;set;}
    public String orderQuery_customerPartName   {get;set;}
    public String orderQuery_internalPartName   {get;set;}
    public String orderQuery_FAB                {get;set;}
    public String orderQuery_orderStatus        {get;set;}
    public String orderQuery_geometry           {get;set;}
    public String orderQuery_orderType          {get;set;}
    public String orderQuery_hiddenField        {get;set;}
    
    public GF_OrderQueryHelper(){
        
    }
    
    public List<SelectOption> getFabList() { 
       
        return GF_CommonUtilityCls.getFabList();
    }
    
    public List<SelectOption> getGeometryList() {

        return GF_CommonUtilityCls.getGeometryList();
    }
    
    public List<SelectOption> getOrderStatusList() {
        
        return GF_CommonUtilityCls.getOrderStatusList();
    }
    
    public List<SelectOption> getOrderTypeList() {

       return GF_CommonUtilityCls.getOrderTypeList();
    }
}