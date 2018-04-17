/*
    Author : Abhita Bansal
    Description : This trigger is used to update the Remaining Quantity if the Remaining Quantity is not null. If user adds the 
                   wafer allocated Quantity, then remaining quantity will update accordingly.
    Code Creation: 15/12/2014
*/
trigger WaferAllocRemQuanUpdate on Wafer_Allocation__c (before update) {
    
    public Wafer_Allocation__c WaferQuanAllocOld;
    public Decimal WaferQuanAllocNew;
    public Decimal WaferRemQuanOld;
    public Map<Id, Decimal> mapOldToId = new Map<Id, Decimal>();
    public Map<Id, Decimal> mapNewToId = new Map<Id, Decimal>();
    public List<Wafer_Allocation__c> waferList = new List<Wafer_Allocation__c>();
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        
            for(Wafer_Allocation__c wafer1: trigger.new){
                    
                WaferQuanAllocOld = Trigger.oldMap.get(wafer1.Id);
                System.debug('wafer1.Wafer_Quantity_Allocated__c'+wafer1.Wafer_Quantity_Allocated__c);
                if(wafer1.Wafer_Quantity_Allocated__c != WaferQuanAllocOld.Wafer_Quantity_Allocated__c  && wafer1.Wafer_Quantity_Allocated__c != null && WaferQuanAllocOld.Wafer_Quantity_Allocated__c != null){
                    WaferQuanAllocNew = wafer1.Wafer_Quantity_Allocated__c - WaferQuanAllocOld.Wafer_Quantity_Allocated__c;
                    System.debug('WaferQuanAllocNew'+WaferQuanAllocNew );
                    WaferRemQuanOld = WaferQuanAllocOld.Remaining_Quantity__c;
                    wafer1.Remaining_Quantity__c = WaferRemQuanOld + WaferQuanAllocNew;
                    System.debug('wafer1.Remaining_Quantity__c'+wafer1.Remaining_Quantity__c);
                }
            }               
       
            
   }
}