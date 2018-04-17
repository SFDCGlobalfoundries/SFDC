/**
* Description   :   Handler Class for CXM_actionMgmtTrigger Trigger on Action Management Object.
* History       :   

        Initials        Date              Description
----------------------------------------------------------------------------
        DBiswal       08012017          Created the Class.
        
**/
Public Class CXM_actionMgmtTriggerHandler extends TriggerHandler{
  
    /*Global variable*/
    public CXM_actionMgmtTriggerHelper helper { get; set; }

    public CXM_actionMgmtTriggerHandler() {
        helper = new CXM_actionMgmtTriggerHelper();
    }
    
    public override void beforeInsert() {
    }
    
    public override void afterInsert() {
        helper.processingMethod(Trigger.New);
    }
    
    public override void beforeUpdate() {
    }
        
    public override void afterUpdate() {
        helper.processingMethod(Trigger.New);
    }
    
    public override void beforeDelete() {
    }
        
    public override void afterDelete() {
    }
    
    public override void afterUndelete() {
    }
}