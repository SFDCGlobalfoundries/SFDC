/*************************************************************************************************************************************************************
@ Class:          WorkOrderLotDetails
@ Version:        1.0
@ Author:         Yathish(yathish.ns1@globalfoundries.com)
@ Purpose:        This class consists of Logic that is been used in Work_Order_Lot and Work_Order_LotCreation visualforce page.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.09.2017 / Yathish / Created the class.
**************************************************************************************************************************************************************/
public class WorkOrderLotDetails{

    Private ApexPages.StandardController stdcon {get;set;}
    Private Work_Order__c rwo {get;set;}
    Public List<Work_Order_Lot__c> wolList {get;set;}
    public List<WorkOrderLotWrapper> wolw {get;set;}
    //Public String typeSelected {get;set;}
    public final String STATUS_DRAFT{get;set;}
    public final String STATUS_REJECTED{get;set;}
    public final String STATUS_ZONE_88{get;set;}
    public Work_Order__c workOrder {get;set;}
    
    public WorkOrderLotDetails(ApexPages.StandardController sc){
        this.stdcon = sc;
        STATUS_DRAFT = Environment_Variable__c.getInstance('QMX_WO_STATUS_DRAFT').Value__c;
        STATUS_REJECTED = Environment_Variable__c.getInstance('QMX_WO_STATUS_REJECTED').Value__c;
        STATUS_ZONE_88 = Environment_Variable__c.getInstance('QMX_WO_STATUS_ZONE_88').Value__c;
        //typeSelected = ApexPages.CurrentPage().getParameters().get('type');
        rwo = (Work_Order__c )stdcon.getRecord();
        wolList = new List<Work_Order_Lot__c>();
        wolw = new List<WorkOrderLotWrapper>();
        
        workOrder = [SELECT Id, Approval_Status__c FROM Work_Order__c WHERE Id =: sc.getId()];  
    }
    public WorkOrderLotDetails(){
        //typeSelected = '';
    }
    public void getLotDetails(){
        if(rwo.Id !=null){
        List<Work_Order_Lot__c> rwolList = [select Id,Original_Lot_Numbers__c,Rework_Lots__c,Qual_Code__c,Lot_Qty__c,Work_Order__c from Work_Order_Lot__c where Work_Order__c =:rwo.Id];
        if(rwolList.size()>0)
        {
            for(Work_Order_Lot__c ol:rwolList){
                wolw.add(new WorkOrderLotWrapper(ol.id,ol.Rework_Lots__c,ol.Original_Lot_Numbers__c,ol.Qual_Code__c,ol.Lot_Qty__c));            
            }
        }
        }
        }
   
    
    public pagereference SaveWOLot(){
        wolList.clear();
        for(WorkOrderLotWrapper wo: wolw){
        Work_Order_Lot__c rwol = new Work_Order_Lot__c();
        rwol.Rework_Lots__c = wo.reworkLot;
        rwol.Original_Lot_Numbers__c = wo.OriginalLot;
        rwol.Qual_Code__c = wo.qualCode;
        rwol.Lot_Qty__c = wo.lotQty;
        if(rwo.Id !=null){
        rwol.Work_Order__c = rwo.Id;
        }
        rwol.Id = wo.wolId;
        wolList.add(rwol);
        }
        try{
            update wolList;
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'WorkOrderLotDetails', 'SaveWOLot', '', '', e.getMessage(), '', 'Work Order', e, 0);
        }    
        pagereference pr = new PageReference('/'+ rwo.Id);
        pr.setRedirect(True);
        return pr;
        //return null;
    }
    
    public pagereference deleteWOLot(){
        Id woltId = ApexPages.CurrentPage().getParameters().get('delWol');
        Work_Order_Lot__c woltoDel = [Select Id from Work_Order_Lot__c where Id =:woltId limit 1];  
        try{
            delete woltoDel;
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'WorkOrderLotDetails', 'deleteWOLot', '', '', e.getMessage(), '', 'Work Order', e, 0);
        } 
        wolw.clear();
        getLotDetails();
        //wolw.remove(Integer.ValueOf(ApexPages.CurrentPage().getParameters().get('delcol')));
        return null;
    }
   
    
    public pagereference addNewWOLot(){       
        Work_Order_Lot__c rwol = new Work_Order_Lot__c();
        rwol.Rework_Lots__c = '';
        rwol.Original_Lot_Numbers__c = '';
        rwol.Qual_Code__c = '00';
        rwol.Lot_Qty__c =0 ;
        if(rwo.Id !=null){
        rwol.Work_Order__c = rwo.Id;
        }
        try{    
            insert rwol;
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'WorkOrderLotDetails', 'addNewWOLot', '', '', e.getMessage(), '', 'Work Order', e, 0);
        }
        wolw.add(new WorkOrderLotWrapper(rwol.Id,'','','00',0));
        return null;
    }
    
    public class WorkOrderLotWrapper{
        public Id wolId {get;set;}
        public String reworkLot {get;set;}
        public string OriginalLot {get;set;}
        public string qualCode {get;set;}
        public Decimal lotQty {get;set;}
        
        public WorkOrderLotWrapper(Id wid,String rl,string ol,string qc,Decimal lq){
            //if(wid !=null){
            wolId = wid;
            //}
            reworkLot = rl;
            OriginalLot = ol;
            qualCode = qc;
            lotQty = lq;
        }
    }
    
    
    
}