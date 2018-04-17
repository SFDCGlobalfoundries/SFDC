Public class IPRevisionSharing_TriggerHandler extends TriggerHandler {

public static IPRevisionSharing_TriggerHelper helper{get;set;}

    //constructor 
    public IPRevisionSharing_TriggerHandler(){
        helper = new IPRevisionSharing_TriggerHelper();
   }
   
    public override void afterinsert(){
        helper.insertGroupInSharing();
        
    }
     
    public override void afterUpdate(){
        helper.updateGroupInSharing();
        
    }
}