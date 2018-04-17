Public class IPCellSharing_TriggerHandler extends TriggerHandler {

public static IPCellSharing_TriggerHelper helper{get;set;}

    //constructor
    public IPCellSharing_TriggerHandler(){
        helper = new IPCellSharing_TriggerHelper();
   }
   
    public override void afterinsert(){
        helper.insertGroupInSharing();
        
    }
    
    public override void afterUpdate(){
        helper.updateGroupInSharing();
        
    }
}