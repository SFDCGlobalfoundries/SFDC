/*
*   @ Author        : Navneet Rajput
*   @ Description   : Class contains all constant of dynamic query module 
*   @ Date          : 8th July 2013
*   @ Company       : Cognizant Technology LTD
*   @ Param         :
**/

public with sharing class GF_ConstantsCls {
    
    public static final String ORDER_Q                  ='OrderQueryHelper';
    public static final String SHIPPING_Q               ='ShippingQueryHelper';
    public static final String PRODUCTION_Q             ='ProductionQueryHelper';
    public static final String FAB_API_NAME             ='GF_Fab__c';
    public static final String GEOMETRY_API_NAME        ='GF_Geometry__c';
    public static final String LOT_TYPE_API_NAME        ='GF_Lot_Type__c';
    public static final String ORDER_STATUS_API_NAME    ='GF_Order_Status__c';
    public static final String ORDER_TYPE_API_NAME      ='GF_Order_Type__c'; 
    public static final String ORDER_PAGE               ='GF_OrderQueryPage';
    public static final String SHIPPING_PAGE            ='GF_ShippingQueryPage';
    public static final String PRODUCTION_PAGE          ='GF_ProductionQueryPage';
    public static final String SUCCESS                  ='100';
    public static final String ERROR_TOOMANY_ROWS       ='101';
    public static final String ERROR_NO_DATA_FOUND      ='102';
    public static final String ERROR_DATE_IS_NULL       ='103';
    public static final String ERROR_LOGIN_FAIL         ='104';
    public static final String ERROR_CANNOT_BE_NULL     ='106';
    
    public GF_ConstantsCls(){
    
    }
    
}