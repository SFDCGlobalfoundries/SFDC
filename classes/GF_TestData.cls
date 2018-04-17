@isTest
public class GF_TestData {

    public static List<GF_DQ_FAB_Settings__c> getFabList() {
    
        List<GF_DQ_FAB_Settings__c> fablist = new List <GF_DQ_FAB_Settings__c>();
        GF_DQ_FAB_Settings__c fab1 = new GF_DQ_FAB_Settings__c();
        fab1.Name = 'Fab1';
        fab1.FAB_Value__c = 'Fab1';
        fablist.add(fab1);
        
        GF_DQ_FAB_Settings__c fab2 = new GF_DQ_FAB_Settings__c();
        fab2.Name = 'Fab2';
        fab2.FAB_Value__c = 'Fab2';
        fablist.add(fab2);

        return fablist;
        
    }
    
    public static List<GF_DQ_Geometry_Settings__c> getGeometryList(){
    
        List<GF_DQ_Geometry_Settings__c> geometryList = new List <GF_DQ_Geometry_Settings__c>();
        GF_DQ_Geometry_Settings__c g1 = new GF_DQ_Geometry_Settings__c();
        g1.Name = 'Geometry1';
        g1.Geometry_Name__c ='Geometry1';
        geometryList.add(g1);
        
        GF_DQ_Geometry_Settings__c g2 = new GF_DQ_Geometry_Settings__c();
        g2.Name = 'Geometry2';
        g2.Geometry_Name__c= 'Geometry2';
        geometryList.add(g2);

        return geometryList;
    }
    
    public static List<GF_DQ_Order_status_Settings__c> getOrderStatusList(){
        List<GF_DQ_Order_status_Settings__c> orderStatusList = new List <GF_DQ_Order_status_Settings__c>();
        GF_DQ_Order_status_Settings__c order1 = new GF_DQ_Order_status_Settings__c();
        
        order1.Name = 'order1';
        order1.Order_Status_Name__c= 'order1';
        orderStatusList.add(order1);
        
        GF_DQ_Order_status_Settings__c order2 = new GF_DQ_Order_status_Settings__c();
        order2.Name = 'order2';
        order2.Order_Status_Name__c = 'order2';
        
        orderStatusList.add(order2);
        
        return orderStatusList;
    }
    
    public static List<GF_DQ_Order_Type__c> getOrderTypeList(){
    
        List<GF_DQ_Order_Type__c> orderStatusType = new List <GF_DQ_Order_Type__c>();
        
        GF_DQ_Order_Type__c order1 = new GF_DQ_Order_Type__c();
        order1.Name = 'orderStatus1';
        order1.order_Type_Name__c ='orderStatus1';
        orderStatusType.add(order1);
        
        GF_DQ_Order_Type__c order2 = new GF_DQ_Order_Type__c();
        order2.Name = 'orderStatus2';
        order2.order_Type_Name__c = 'orderStatus2';
        orderStatusType.add(order2);
        
        return orderStatusType;
    }
    
    public static List<GF_DQ_Lot_Type_Settings__c> getLotdataList(){
    
        List<GF_DQ_Lot_Type_Settings__c> lotTypeList = new List <GF_DQ_Lot_Type_Settings__c>();
        
        GF_DQ_Lot_Type_Settings__c lot1 = new GF_DQ_Lot_Type_Settings__c();
        lot1.Name = 'Lot1';
        lot1.Lot_Type_Name__c ='Lot1';
        lotTypeList.add(lot1);
        
        GF_DQ_Lot_Type_Settings__c lot2 = new GF_DQ_Lot_Type_Settings__c();
        lot2.Name = 'Lot2';
        lot2.Lot_Type_Name__c ='Lot2';
        lotTypeList.add(lot2);
        
        return lotTypeList;
    }
    
}