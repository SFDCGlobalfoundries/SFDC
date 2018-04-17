/*
*   @ Author        : Navneet Rajput
*   @ Description   : Common utility class Dynamic Query module, Class Handles common operation of production/shipping/order query.  
*   @ Date          : 8th July 2013
*   @ Param         :
*   @ Methods       : 
*   @ Company       : Cognizant Technology LTD.
**/

global with sharing class GF_CommonUtilityCls {
    
    private static GF_OrderQueryHelper orderInstance;
    private static GF_ProductionQueryHelper productionInstance;
    private static GF_ShippingQueryHelper shipingInstance;
    private static sObject instance;

    /*
    * @ Description :- method returns orderQuery instance
    * @ Param       :-
    * @ Return      :- instance of OrderQueryHelper class
    **/
    
    public static GF_OrderQueryHelper getInstanceOfOrderQuery(){
        
        //if (instanceName ==GF_ConstantsCls.ORDER_Q){
            if (orderInstance == null){
                 orderInstance = new GF_OrderQueryHelper();
                 return orderInstance;
            } else
                return orderInstance;
        //}
    }   
    
    /*
    * @ Description :- method returns productionQuery instance
    * @ Param       :-
    * @ Return      :- instance of ProductionQueryHelper class
    **/
    
    public static GF_ProductionQueryHelper getInstanceOfProductionQuery(){ 
        //if (instanceName == GF_ConstantsCls.PRODUCTION_Q){
            if (productionInstance == null){
                 productionInstance = new GF_ProductionQueryHelper();
                 return productionInstance;
            } else
                return productionInstance; 
        //}
    }  
    
    /*
    * @ Description :- method returns shippingQuery instance
    * @ Param       :-
    * @ Return      :- instance of ShippingQueryHelper class
    **/
    
    public static GF_ShippingQueryHelper getInstanceOfShippingQuery(){ 
        // (instanceName == GF_ConstantsCls.SHIPPING_Q){
            if (shipingInstance==null){
                 shipingInstance = new GF_ShippingQueryHelper();
                 return shipingInstance;
            } else
                return shipingInstance;
        //}
    } 
 
    /*
    * @ Description :- method prepare instance of class at runtime
    * @ Param       :- class name
    * @ Return      :- Type of object
    * @ Date        :- 07-04-2013   
    **/
    
    public static Type getInstance(String className){
        return GF_DynamicQueryObjectFactory.getDynamicQueryObjectInstance(className);
    }
    
    /*
    * @ Description :- method prepare picklist values for FAB and take all picklist values from custom settings
    * @ Param       :- GF_DQ_FAB_Settings__c custom setting,FAB_Value__c custom field of custom setting field.
    * @ Return      :- List<SelectOption> (picklist values)
    * @ Date        :- 07-12-2013 
    **/
    
    public static List<SelectOption> getFabList() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ALL','ALL'));
        List<String> fabNames = new List<String>();
        Map<String, GF_DQ_FAB_Settings__c> fabValueMap = GF_DQ_FAB_Settings__c.getAll();
        fabNames.addAll(fabValueMap.keySet());
        fabNames.sort();
        
        for (String key : fabNames) {
            GF_DQ_FAB_Settings__c fabObj = fabValueMap.get(key);
            options.add(new SelectOption(fabObj.FAB_Value__c,fabObj.Name));
        }
        
        return options;
       
    }
    
    /*
    * @ Description :- method prepare picklist values for Geometry and take all picklist values from custom settings
    * @ Param       :- GF_DQ_Geometry_Settings__c custom setting,Geometry_Name__c custom field of custom setting field.
    * @ Return      :- List<SelectOption> (picklist values)
    * @ Date        :- 07-12-2013 
    **/
    
   public static List<SelectOption> getGeometryList() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ALL','ALL'));
        List<String> geometryNames = new List<String>();
        Map<String, GF_DQ_Geometry_Settings__c> geometryValueMap = GF_DQ_Geometry_Settings__c.getAll();
        geometryNames.addAll(geometryValueMap.keySet());
        geometryNames.sort();
        
        for (String key : geometryNames) {
            GF_DQ_Geometry_Settings__c geometryObj = geometryValueMap.get(key);
            options.add(new SelectOption(geometryObj.Geometry_Name__c,geometryObj.Name));
        }
        
        return options;
       
    }
    
    /*
    * @ Description :- method prepare picklist values for order Type and take all picklist values from custom settings
    * @ Param       :- GF_DQ_Order_Type__c custom setting,order_Type_Name__c custom field of custom setting field.
    * @ Return      :- List<SelectOption> (picklist values)
    * @ Date        :- 07-12-2013 
    **/
    
     public static List<SelectOption> getOrderTypeList() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ALL','ALL'));
        List<String> orderNames = new List<String>();
        Map<String, GF_DQ_Order_Type__c> orderValueMap = GF_DQ_Order_Type__c.getAll();
        orderNames.addAll(orderValueMap.keySet());
        orderNames.sort();
        
        for (String key : orderNames) {
            GF_DQ_Order_Type__c orderObj = orderValueMap.get(key);
            options.add(new SelectOption(orderObj.order_Type_Name__c,orderObj.Name));
        }
        
        return options;
       
    }
    
    /*
    * @ Description :- method prepare picklist values for order status list and take all picklist values from custom settings
    * @ Param       :- GF_DQ_Order_status_Settings__c custom setting,Order_Status_Name__c custom field of custom setting field.
    * @ Return      :- List<SelectOption> (picklist values)
    * @ Date        :- 07-12-2013 
    **/
    
     public static List<SelectOption> getOrderStatusList() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ALL','ALL'));
        List<String> orderStatusNames = new List<String>();
        Map<String, GF_DQ_Order_status_Settings__c> orderSatusValueMap = GF_DQ_Order_status_Settings__c.getAll();
        orderStatusNames.addAll(orderSatusValueMap.keySet());
        orderStatusNames.sort();
        
        for (String key : orderStatusNames) {
            GF_DQ_Order_status_Settings__c statusObj = orderSatusValueMap.get(key);
            options.add(new SelectOption(statusObj.Order_Status_Name__c,statusObj.Name));
        }
        return options;
    }
     
   /*
    * @ Description :- method prepare picklist values for Lot Type and take all picklist values from custom settings
    * @ Param       :- GF_DQ_Lot_Type_Settings__c custom setting,Lot_Type_Name__c custom field of custom setting field.
    * @ Return      :- List<SelectOption> (picklist values)
    * @ Date        :- 07-12-2013 
    **/  
   
   public static List<SelectOption> getLotTypeList() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('ALL','ALL'));
        List<String> orderLotNames = new List<String>();
        Map<String, GF_DQ_Lot_Type_Settings__c> orderLotValueMap = GF_DQ_Lot_Type_Settings__c.getAll();
        orderLotNames.addAll(orderLotValueMap.keySet());
        orderLotNames.sort();
        
        for (String key : orderLotNames) {
            GF_DQ_Lot_Type_Settings__c orderLotObj = orderLotValueMap.get(key);
            options.add(new SelectOption(orderLotObj.Lot_Type_Name__c,orderLotObj.Name));
        }
        return options;
    }
    
    /*
    * @ Description :- method prepare grid of column name values in the form of JSON object string
    * @ Param       :- List of string (column names)
    * @ Return      :- List<String> (column names in the form of JSON object)
    * @ Date        :- 07-25-2013 
    **/
    
    public static String getColumns(List<String> listOfColumns){
        String startElement ='[';
        String endElement =']';
        String cNames ='';
        for (String col : listOfColumns){
            if (cNames=='' || cNames==null){
                cNames ='\''+col+'\'';
            } else
               cNames =cNames+','+'\''+col+'\'';    
        }
        return startElement+cNames+endElement;
    }
    
    /*
    * @ Description :- method prepare column Model for jqueryGrid column name values in the form of JSON object string
    * @ Param       :- List of string (column names)
    * @ Return      :- List<String> (columnModel in the form of JSON object)
    * @ Date        :- 07-25-2013 
    **/
    
    public static String getColumnModel (List<String> listOfColumns){

        String startElement ='[';
        String endElement =']';
        String columnModel ='';
        String tempStr ='';
        
        for (String col : listOfColumns){
            // need to put or conditon for all column model who has link
            if (col.equalsIgnoreCase('CHARTERED_PART_NAME') ||col.equalsIgnoreCase('PO')||
                col.equalsIgnoreCase('SHIP_DATE')||col.equalsIgnoreCase('RMA_NO')||
                col.equalsIgnoreCase('BKLG_QTY_WFR')||col.equalsIgnoreCase('SHIPPED_QTY_WFR')||
                col.equalsIgnoreCase('BKLG_QTY_DIE')||col.equalsIgnoreCase('SHIPPED_QTY_DIE')||
                col.equalsIgnoreCase('TAX_INVOICE_LINK')){
                    // BELOW CODE IS USE TO CREATE LINK ON COLUMN CELL IN GRID                  
                columnModel = '{'+'name:'+'\''+col+'\''+','+'index:'+'\''+col+'\''+','+'formatter:'+'\'showlink\''+','+'formatoptions:'+'{baseLinkUrl:'+'\'#\''+'}'+','+'align:'+'\'center\''+','+'hidden:'+'false'+','+'sortable:'+'true'+','+'resizable:'+'true'+'}';
            } else if (col.equalsIgnoreCase('ORG_ID')|| col.equalsIgnoreCase('CUSTOMER_ID')||col.equalsIgnoreCase('ITEM_TYPE')||
                       col.equalsIgnoreCase('SO_HYPR_LINK')||col.equalsIgnoreCase('CUST_ID')||
                       col.equalsIgnoreCase('PRM2')||col.equalsIgnoreCase('PRM1')){
                        // BELOW CODE IS USE TO HIDE COLUMN
                columnModel = '{'+'name:'+'\''+col+'\''+','+'index:'+'\''+col+'\''+','+'align:'+'\'center\''+','+'hidden:'+'true'+','+'hidedlg:'+'true'+','+'sortable:'+'true'+','+'resizable:'+'true'+'}';
                
            } else if (col.equalsIgnoreCase('UNIT_SELLING_PRICE')||col.equalsIgnoreCase('BOOK_DATE')){
                       
                  if (GF_CommonUtilityCls.getProfileName()=='GF CSR' || GF_CommonUtilityCls.getProfileName()=='GF System Admin'
                      || GF_CommonUtilityCls.getProfileName()=='GF Global Admin' || GF_CommonUtilityCls.getProfileName()=='System Administrator'){
                      
                       columnModel = '{'+'name:'+'\''+col+'\''+','+'index:'+'\''+col+'\''+','+'align:'+'\'center\''+','+'hidden:'+'false'+','+'sortable:'+'true'+','+'resizable:'+'true'+'}';                  
                  } else {
                       columnModel = '{'+'name:'+'\''+col+'\''+','+'index:'+'\''+col+'\''+','+'align:'+'\'center\''+','+'hidden:'+'true'+','+'hidedlg:'+'true'+','+'sortable:'+'true'+','+'resizable:'+'true'+'}';        
                  }     
            
            } else {
                // BELOW CODE IS USE TO CREATE COLUMN MODEL WITH GENERAL ATTRIBUTE
                columnModel = '{'+'name:'+'\''+col+'\''+','+'index:'+'\''+col+'\''+','+'align:'+'\'center\''+','+'hidden:'+'false'+','+'sortable:'+'true'+','+'resizable:'+'true'+'}';
            }                                                                                                        
            
            if (tempStr == '')
                tempStr = columnModel;
            else 
                tempStr =tempStr+','+columnModel;   
        }
        return startElement+tempStr+endElement; 
   }
   
   // Method returns logged in users profile name
   public static String profileName='';
   
   public static String getProfileName(){
       
       if (profileName == '' || profileName == null){
            User userObject = [SELECT accountId,Portal_Login__c,
                                      HCM_Login_ID__c,UserType,
                                      FederationIdentifier 
                               FROM   User 
                               WHERE  Id =:userInfo.getUserId()];
            
            profile profileObj = [SELECT Name
                                  FROM   Profile
                                  WHERE  Id = : Userinfo.getProfileId()];
       
            profileName = profileObj.Name;   
       }
       
       return profileName;
    } // END OF getProfileName() Method  
    
}// END OF CLASS