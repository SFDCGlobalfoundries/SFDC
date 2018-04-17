Public class IPElementSharing_TriggerHandler extends TriggerHandler {

public static IPElementSharing_TriggerHelper helper{get;set;}

    //constructor  
    public IPElementSharing_TriggerHandler(){
        helper = new IPElementSharing_TriggerHelper();
   }
   
    public override void afterinsert(){
        helper.insertGroupInSharing();
		helper.createIPRecord();
        
    }
    
    public override void afterUpdate(){
		helper.createIPRecord();
        helper.updateGroupInSharing();
       
    }
    
    public override void beforeDelete(){
        helper.deleteGroupInSharing();
       
    }
}