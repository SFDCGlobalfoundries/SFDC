/*
    Company:        Cognizant Technology Solution
    Description:    Batch class to upload/update the Invoice records for Fab 9 an 10 from Shipping Data.
    History:        1/12/2016    Created the class    
        NJain       11-May-16    Modified the Start method to query DNCN based on RMA pending for CN Issue
*/

public class RMA_BATCH_InvoiceFabRed implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start (Database.BatchableContext batchableContext) {
        return Database.getQueryLocator(  ' SELECT Id,Name,'
                                        + '  Lot_Qty__c,' //Bill Quantity
                                        + '  Lot_Num__c,' //Lot Name
                                        + '  COO__c,    ' //Origin
                                        + '  Ship_Item_Id__r.Del_Plant__c,FAB_Site__c, ' //Fab Group
                                        + '  Ship_Item_Id__r.Last_Date__c,' //Invoice Date
                                        + '  Ship_Item_Id__r.Invoice_Num__c,  ' //Invoice Number
                                        + '  Ship_Item_Id__r.IBM_Part_Num__c, ' //Part Number
                                        + '  Ship_Item_Id__r.Cust_Part_Num__c, ' //Customer Part Number
                                        + '  Ship_Item_Id__r.PO_Num__c,       ' //Purchase Order Number
                                        + '  Ship_Item_Id__r.Order_Num__c,    ' //Sales order Number
                                        + '  Ship_Item_Id__r.Cust_Shipto__c,  ' //Ship To Address
                                        + '  Ship_Item_Id__r.Net_Price__c, Delivery_Batch_Item__c, Handling_Unit_ID__c,'//for Price
                                        + '  Ship_Item_Id__r.Shipment__r.Account__c,' //Customer Name
                                        + '  (SELECT Wafer_ID__c FROM Shipment_Lot_Wafer_Internal__r)' //For Wafer Ids
                                        + ' FROM Shipment_Lot_Internal__c '
                                        + ' WHERE RMA_Job_Id__c = NULL AND Ship_Item_Id__r.Invoice_Num__c != NULL ' );
    }
    
    public void execute(Database.BatchableContext batchableContext, List<Shipment_Lot_Internal__c> lstShipmentLot){
        Map<String,Shipment_Lot_Internal__c> mapLotInvoiceVsSL = new Map<String,Shipment_Lot_Internal__c>();
        Map<String,Shipment_Lot_Internal__c> mapLotInvoiceVsSLfull = new Map<String,Shipment_Lot_Internal__c>();
        Map<String,Invoice__c> mapInvoices = new Map<String,Invoice__c>();
        Map<String,String> mapPartVsType = new Map<String,String>();
        Map<String,ERP_Device__c> mapPartVsERPDevice = new Map<String,ERP_Device__c>();
        List<String> lstIBMpartNo = new List<String>();
        Map<String,Invoice__c> mapInvoicesToUpsert = new Map<String,Invoice__c>();
        
		List<RMA_Deliver_Plant_Fabs__mdt> RMAFabs = [SELECT Label,Fab__c FROM RMA_Deliver_Plant_Fabs__mdt];
        Map<String,RMA_Deliver_Plant_Fabs__mdt> RMAFABMataMap=new Map<String,RMA_Deliver_Plant_Fabs__mdt>();
        for(RMA_Deliver_Plant_Fabs__mdt RMADPF :RMAFabs){
            RMAFABMataMap.put(RMADPF.Label,RMADPF);
        }
		
        //Prepare the map for External Id and new Shipment Lots from the batch
        for(Shipment_Lot_Internal__c shipLot: lstShipmentLot){
            mapLotInvoiceVsSL.put(shipLot.Lot_Num__c +  '-' + 
                                  shipLot.Ship_Item_Id__r.Invoice_Num__c + '-' + 
                                  shipLot.Delivery_Batch_Item__c, shipLot);
            mapLotInvoiceVsSLfull.put(shipLot.Lot_Num__c +  '-' + 
                                      shipLot.Ship_Item_Id__r.Invoice_Num__c + '-' + 
                                      shipLot.Delivery_Batch_Item__c + '-' +
                                      shipLot.Handling_Unit_ID__c, shipLot);
            lstIBMpartNo.add(shipLot.Ship_Item_Id__r.IBM_Part_Num__c);
            
            //Assign Job id to the processed records
            shipLot.RMA_Job_Id__c = batchableContext.getJobId();
        }
        
        //Prepare the map for External Id vs Existing Invoice records
        for(Invoice__c existingInvoice : [SELECT Id,Name,ExternalId__c,Bill_Quantity__c,Wafer_Id__c,Item_Type__c
                                            FROM Invoice__c where ExternalId__c in :mapLotInvoiceVsSL.keySet()]){
            mapInvoices.put(existingInvoice.ExternalId__c,existingInvoice);
        }
        
        //Prepare a map for Part Number
        for(ERP_Device__c erpDev: [SELECT Deliverable_Type__c,Part_Number__c,Fab__c,Business_Unit__c,Product_Line__c from ERP_Device__c 
                                    WHERE Part_Number__c IN :lstIBMpartNo]){
            if(erpDev.Deliverable_Type__c == 'MOD' || erpDev.Deliverable_Type__c == 'MODULE' || erpDev.Deliverable_Type__c == 'MODULE-MCM-P'){
                mapPartVsType.put(erpDev.Part_Number__c,'MOD');
            }else if(erpDev.Deliverable_Type__c == 'CWA' || erpDev.Deliverable_Type__c == 'WAFER'){
                mapPartVsType.put(erpDev.Part_Number__c,'CWA');
            }else if(erpDev.Deliverable_Type__c == 'CHIP' || erpDev.Deliverable_Type__c == 'DEV'){
                mapPartVsType.put(erpDev.Part_Number__c,'DEV');
            }else{
                mapPartVsType.put(erpDev.Part_Number__c,'NA');
            }
            mapPartVsERPDevice.put(erpDev.Part_Number__c,erpDev);
        }
        
        //Prepare the invoice records                
        for(String LotInvoice: mapLotInvoiceVsSLfull.keySet()){
            string externalId = mapLotInvoiceVsSLfull.get(LotInvoice).Lot_Num__c + '-' + 
                                mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Invoice_Num__c + '-' + 
                                mapLotInvoiceVsSLfull.get(LotInvoice).Delivery_Batch_Item__c;
            Invoice__c invoiceRec;
            if(mapInvoices.containsKey(externalId)){
                invoiceRec = mapInvoices.get(externalId);
            }else{
                invoiceRec = new Invoice__c();
            }
            
            invoiceRec.ExternalId__c = externalId;
            if(mapLotInvoiceVsSLfull.get(LotInvoice) != NULL){
                
                invoiceRec.Customer_Name__c    = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Shipment__r.Account__c;
				if(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Last_Date__c != NULL){
                    invoiceRec.Invoice_Date__c = Date.valueOf(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Last_Date__c);
                }
                invoiceRec.Invoice_Number__c   = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Invoice_Num__c;
                invoiceRec.Lot_Name__c         = mapLotInvoiceVsSLfull.get(LotInvoice).Lot_Num__c;
                invoiceRec.Origin__c           = mapLotInvoiceVsSLfull.get(LotInvoice).COO__c;
                invoiceRec.Part_Number__c      = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c;
                invoiceRec.Cust_Part_Num__c    = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Cust_Part_Num__c;
                invoiceRec.Sales_Order_Number__c = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Order_Num__c;
                invoiceRec.Ship_from_Address__c  = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Cust_Shipto__c;
                invoiceRec.Purchase_Order_Number__c = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.PO_Num__c;
                
                if(mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c) != NULL){
				
					If(mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c).Fab__c==null){
						if(RMAFABMataMap.containsKey(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Del_Plant__c)){
							invoiceRec.Fab_Group__c=RMAFABMataMap.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Del_Plant__c).Fab__c;							
						}
						
					}else{
					
						invoiceRec.Fab_Group__c        = mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c).Fab__c ;
					}
                    invoiceRec.Business_Unit__c    = mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c).Business_Unit__c;
                    invoiceRec.Product_Line__c     = mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c).Product_Line__c;
                }
                if(mapPartVsType.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c) != NULL){
                    invoiceRec.Item_Type__c        = mapPartVsType.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c);
                }
				
				if(mapPartVsERPDevice.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.IBM_Part_Num__c) == NULL){
                    if(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Del_Plant__c!=null){
                        if(RMAFABMataMap.containsKey(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Del_Plant__c)){
                            invoiceRec.Fab_Group__c=RMAFABMataMap.get(mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Del_Plant__c).Fab__c;
                        }
                    }
                }
                
                //Sum up the Bill Quantity of the lots with same Lot#,Invoice#, and Delivery Batch Item #
                if(invoiceRec.Bill_Quantity__c != NULL){
                    invoiceRec.Bill_Quantity__c += mapLotInvoiceVsSLfull.get(LotInvoice).Lot_Qty__c;
                }else{
                    invoiceRec.Bill_Quantity__c = mapLotInvoiceVsSLfull.get(LotInvoice).Lot_Qty__c;
                }
                
                //Populating Wafer Ids from Shipment Lot Wafer records
                string waferId = '';
                Set<String> setWaferIds = new Set<String>();
                if(invoiceRec.Wafer_Id__c != NULL && invoiceRec.Wafer_Id__c != ''){
                    setWaferIds.addAll(invoiceRec.Wafer_Id__c.split(';'));
                }
                for(Shipment_Lot_Wafer_Internal__c slw: mapLotInvoiceVsSLfull.get(LotInvoice).Shipment_Lot_Wafer_Internal__r){
                    if(slw.Wafer_ID__c != '' && slw.Wafer_ID__c != NULL){
                        setWaferIds.add(slw.Wafer_ID__c);
                    }
                }
                if(!setWaferIds.isEmpty()){
                    for(String wId :setWaferIds){
                        waferId += wId + ';';
                    }
                    waferId = waferId.substring(0,waferId.length()-1);
                    invoiceRec.Wafer_Id__c = waferId;
                }
                
                //Populating the Unit Price based on the Item Type
                if(invoiceRec.Item_Type__c == 'DEV'){
                    invoiceRec.Die_Selling_Price__c  = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Net_Price__c;
                }else{
                    invoiceRec.Unit_Selling_Price__c = mapLotInvoiceVsSLfull.get(LotInvoice).Ship_Item_Id__r.Net_Price__c;
                }
                
            }
            mapInvoicesToUpsert.put(invoiceRec.ExternalId__c,invoiceRec);
            mapInvoices.put(invoiceRec.ExternalId__c,invoiceRec);
        }
        database.upsert(mapInvoicesToUpsert.values());
        database.update(lstShipmentLot);
    }
    
    public void finish (Database.BatchableContext batchableContext) {
        // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,  
                                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                            from AsyncApexJob where Id = :batchableContext.getJobId()];  
        
        // Email the Batch Job's submitter that the Job is finished.  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setSubject('RMA Invoice Job Status: ' + a.Status);  
        mail.setPlainTextBody('Hi,\n\nThe batch Apex job processed ' + a.TotalJobItems +  
                              ' batches with '+ a.NumberOfErrors + ' failures.' + '\n\nSalesforce Support');  
        
        if(System.Label.RMA_InvoiceJobStatus.equalsIgnoreCase('true')){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}