/*
Controller class for VF page report.
Author: Rahul Majumder
Version 1.0
*/

public class ICC_VF_ScheduleShipment_Details
{
    public Sales_Order_Line__c obj_SO {get;set;}
    public List<Sales_Order_Schedule__c> lst_Schedules {get;set;}
    public List<Shipment_Line__c> lst_ShipLines {get;set;}
    
    public ICC_VF_ScheduleShipment_Details()
    {
        String strSalesOrderID = System.currentPageReference().getParameters().get('soID');
        
        obj_SO = new Sales_Order_Line__c();
        lst_Schedules = new List<Sales_Order_Schedule__c>();
        lst_ShipLines = new List<Shipment_Line__c>();
        
        List<Sales_Order_Line__c> lstSOL = new List<Sales_Order_Line__c>();
        
        lstSOL = [Select Id, Doc_Number__c, Itm_Number__c, Material__c, Cust_Part__c, NET_PRICE__c, Req_Date__c, Req_Qty__c, Purch_No__c, DOCDATE__c,
                  CURRENCY__c, Account__r.Name
                  FROM Sales_Order_Line__c WHERE Id =: strSalesOrderID ];
        if(!lstSOL.isEmpty())
        {
            obj_SO = lstSOL.get(0);
        }
                  
        lst_Schedules = [Select Id, Confirmed_Date__c, Cum_Cf_Qty__c 
                         FROM Sales_Order_Schedule__c 
                         WHERE Sales_Order_Line__c =: strSalesOrderID ORDER BY Confirmed_Date__c];
                         
        lst_ShipLines = [Select Id, Delivery_Date__c, Ship_Qty__c, Invoice_Num__c, ShipFrom__c, Cust_Shipto__c, Shipment__r.Carrier__c, Shipment__r.Carrier_PRO__c 
                         FROM Shipment_Line__c 
                         WHERE Sales_Order__c =: strSalesOrderID ORDER BY Delivery_Date__c];
    }
}