/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Initiate the request to AIA for SO creation.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    14-Dec-15      Created the Class
        Nikhil Jain    10-May-16      Update the logic for sending the Price as 'Unit Price' instead of 'Total Price'
        Pradosh Samal  27-JUl-17      Changes for adding fab ALTIS
**/
public class RMA_Integration{
    
    String ErrorMessage;
    public RMA_Integration(ApexPages.StandardController controller){}    
    
    @future(callout=true)
    public static void SOdetailsCallout(List<String> rmaApprovedByFinanceList,String sessionId,Decimal TimeZoneOffset,String EnterpriseUrl,string CallType){
        List<RMA__c> lstRMAtoSend = [SELECT Id,Name,Queue_out_Time_for_Finance_Approval__c,RMA_Category__c, Customer_Number__c,
                                         Queue_out_Time_for_Regional_Approval__c,RMA_By__c, Current_Grand_Total__c, Originator_Email__c,
                                         Compensation_Type__c,Fab__c,
                                         (SELECT Id,Invoice_Number__c,Final_RMA_Wfr_Qty_To_Issue_CN_SO__c,Total_Price_Final__c,
                                          Lot_Number__c,Wafer_Id_Regional_Personnel_Recommended__c,Device__c,Fab_Code__c,Wafer_Id_CSR_Submission__c,
                                          Adjusted_Unit_Price__c,Wafer_Die_Unit_Price__c,Die_Selling_Price__c,Wafer_Quantity__c,Purchase_Order_Number__c
                                          FROM RMA_Return_Invoices__r) 
                                        FROM RMA__c
                                        WHERE Id in :rmaApprovedByFinanceList
                                          AND Fab__c NOT IN ('FAB 9','FAB 10','ALTIS')];
        
        List<RMA_SyncService.RMARecord> lstRMAserviceRecords = new List<RMA_SyncService.RMARecord>();
        List<RMA_SyncService.RMAChild> lstRMAserviceChild = new List<RMA_SyncService.RMAChild>();
        String strTimeZoneOffset = '';
        if(TimeZoneOffset >= 0){
            strTimeZoneOffset = '+' + String.valueOf(TimeZoneOffset);
        }else{
            strTimeZoneOffset = String.valueOf(TimeZoneOffset);
        }
        for(RMA__c rmaRec : lstRMAtoSend){
            lstRMAserviceChild.clear();
            RMA_SyncService.RMARecord rmaServiceRecord = new RMA_SyncService.RMARecord();
            rmaServiceRecord.Customer= rmaRec.Customer_Number__c;
            rmaServiceRecord.Id      = rmaRec.Id;
            rmaServiceRecord.Name    = rmaRec.Name;
            if(rmaRec.RMA_Category__c != 'Rework'){
                rmaServiceRecord.FinanceApprovalTime= String.valueOf(rmaRec.Queue_out_Time_for_Finance_Approval__c);
            }else{
                rmaServiceRecord.FinanceApprovalTime= String.valueOf(rmaRec.Queue_out_Time_for_Regional_Approval__c);
            }
            rmaServiceRecord.GrandTotal = String.valueOf(rmaRec.Current_Grand_Total__c);
            rmaServiceRecord.SessionID   = sessionId;
            rmaServiceRecord.TimeZoneOffset = strTimeZoneOffset;
            rmaServiceRecord.EnterpriseUrl  = EnterpriseUrl;
            rmaServiceRecord.OriginatorEmail = rmaRec.Originator_Email__c;
            
            //NJain-20Jul16- New parameter added for Compensation Type
            if(rmaRec.Compensation_Type__c == 'Credit'){
                rmaServiceRecord.CompensationType = 'CN';
            }else if(rmaRec.Compensation_Type__c == 'Credit with charged replacement'){
                if(CallType == 'Quality'){
                    rmaServiceRecord.CompensationType = 'CRO';
                }else{
                    rmaServiceRecord.CompensationType = 'CN';
                }
            }else if(rmaRec.Compensation_Type__c == 'No Compensation'){
                rmaServiceRecord.CompensationType = 'REWORK';
            }else if(rmaRec.Compensation_Type__c == 'Replacement'){
                rmaServiceRecord.CompensationType = 'FOC';
            }
            
            for(RMA_Return_Invoice__c rmaLineItem : rmaRec.RMA_Return_Invoices__r){
                RMA_SyncService.RMAChild rmaServiceChildRecord = new RMA_SyncService.RMAChild();
                
                if(rmaRec.RMA_By__c == 'Wafer' || rmaRec.RMA_By__c == 'Module'){
                    if(rmaLineItem.Adjusted_Unit_Price__c > 0){
                        rmaServiceChildRecord.Price = string.valueOf(rmaLineItem.Adjusted_Unit_Price__c);
                    }else{
                        rmaServiceChildRecord.Price = string.valueOf(rmaLineItem.Wafer_Die_Unit_Price__c);
                    }
                }else{
                    if(rmaLineItem.Adjusted_Unit_Price__c > 0){
                        rmaServiceChildRecord.Price = string.valueOf(rmaLineItem.Adjusted_Unit_Price__c);
                    }else{
                        rmaServiceChildRecord.Price = string.valueOf(rmaLineItem.Die_Selling_Price__c);
                    }
                }
                
                rmaServiceChildRecord.Invoice_Number = rmaLineItem.Invoice_Number__c;
                
                //Njain- 24Aug16
                if(CallType == 'Quality'){
                    rmaServiceChildRecord.Wafer_Qty      = String.valueOf(rmaLineItem.Wafer_Quantity__c);
                }else{
                    rmaServiceChildRecord.Wafer_Qty      = String.valueOf(rmaLineItem.Final_RMA_Wfr_Qty_To_Issue_CN_SO__c);
                }
                
                rmaServiceChildRecord.Lot_Number     = rmaLineItem.Lot_Number__c;
                
                //Njain- 24Aug16
                if(CallType == 'Quality'){
                    rmaServiceChildRecord.Wafers         = rmaLineItem.Wafer_Id_CSR_Submission__c;
                }else{
                    rmaServiceChildRecord.Wafers         = rmaLineItem.Wafer_Id_Regional_Personnel_Recommended__c;
                }                
                
                rmaServiceChildRecord.Device         = rmaLineItem.Device__c;
                rmaServiceChildRecord.FabCode        = rmaLineItem.Fab_Code__c;
                if(rmaServiceRecord.CompensationType == 'CRO'){
                    rmaServiceChildRecord.PO_Number  = rmaLineItem.Purchase_Order_Number__c;
                }
                lstRMAserviceChild.add(rmaServiceChildRecord);
            }
            rmaServiceRecord.RMALines = new List<RMA_SyncService.RMAChild>();
            rmaServiceRecord.RMALines.addAll(lstRMAserviceChild);
            lstRMAserviceRecords.add(rmaServiceRecord);
        }
        
        RMA_SyncService.SFRMASyncService_pt obj = new RMA_SyncService.SFRMASyncService_pt();
        try{
            if(Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE')<> NULL && 
               Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c <> NULL && 
               Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c <> 'NULL'){  
                obj.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
            }
            if(!Test.isRunningTest()){
                String response = obj.process(lstRMAserviceRecords);
            }else{
                Exception e;
                throw e;
            }
        }catch(Exception e){
            List<ApplicationLogWrapper> lstALW = new List<ApplicationLogWrapper>();
            for(RMA__c rmaRec: lstRMAtoSend){
                //Adding code for exception framework
                ApplicationLogWrapper alw = new ApplicationLogWrapper();
                alw.source = RMA_Integration.class.getName();
                alw.sourceFunction = 'SOdetailsCallout()';
                alw.ApplicationName= 'RMA';
                alw.referenceId = rmaRec.id;
                alw.referenceInfo= 'RMA Integration';
                alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel = 'Error';
                alw.logCode = e.getTypeName();
                alw.ex= e.getCause();
                lstALW.add(alw);
            }            
            GlobalUtility.logMessage(lstALW);
        }
    }
    
}