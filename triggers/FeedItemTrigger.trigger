/*Author: Karthick D
* Description: This trigger fires on FeedItem object, when ever the chatter comment added or 
                updated on bug object and sends mail to bug owner, creator and bug team members.
* History: Created on 09/03/2014

            Modified By- Dinesh Suggala
            Modified Date-4th August 2017
            Reason- Calling FeedItemHandler method
*/
trigger FeedItemTrigger on FeedItem(before insert,after insert, before delete) {
    
   new FeedItemHandler().run();
    //BugTriggerHandler class is initiated to for static varibale.
    FeedTriggerHandler feedtriggerhandlerVar = new FeedTriggerHandler();
    WRFeedTriggerHandler WRFeedTriggerHandlerVar = new WRFeedTriggerHandler();
    SimulationRequestHandler SimulationRequestHandlerVar = new SimulationRequestHandler();
    if (!IntegrationUserUtil.isSkipTrigger()) {
        String oppKeyPrefix = bug__c.sObjectType.getDescribe().getKeyPrefix();
        feedtriggerhandlerVar.feeditemlistNew = trigger.new;
        feedtriggerhandlerVar.feeditemmapNew = trigger.newMap;
        feedtriggerhandlerVar.parentIds = new list < string > ();
        WRFeedTriggerHandlerVar.feeditemlistNew = trigger.new;
        SimulationRequestHandlerVar.feeditemlistNew = trigger.new;
        list<string> parentIds = new list<string>();

        if (trigger.isinsert) {
            if (!BugTriggerHandler.CheckMailSkipforFeed()) {
                for (FeedItem fdItem: trigger.new) {
                    String parentIdTemp = fdItem.parentId;
                    if (parentIdTemp.startsWith(oppKeyPrefix))
                        parentIds.add(parentIdTemp);
                }
                
                if( parentIds.size() > 0) {
                    for(bug__c b : [select id, isbug__c,IsIPDEV__c,IsASICBug__c,Record_Type_API__c from bug__c where id in :parentIds]) {
                            if(b.isbug__c)                          
                                feedtriggerhandlerVar.parentIds.add(b.id);
                            else if(b.IsASICBug__c){
                                feedtriggerhandlerVar.parentIds.add(b.id);
                                feedtriggerhandlerVar.asicFlag = true;                              
                            }
							else if(b.IsIPDEV__c){
                                feedtriggerhandlerVar.parentIds.add(b.id);
                                feedtriggerhandlerVar.ipDevFlag = true;                              
                            }
                            else if(b.Record_Type_API__c =='Simulation_Request')
                                SimulationRequestHandlerVar.parentIds.add(b.id);
                            else
                                WRFeedTriggerHandlerVar.parentIds.add(b.id);
					}    
                }   
                
                //Handler class executed only when comment added or updated on bug record.
                if (feedtriggerhandlerVar.parentIds.size() > 0 && BugTriggerHandler.runOnce()){
                    feedtriggerhandlerVar.emailNotificationforFeedItem();
                    feedtriggerhandlerVar.updateBugChatterField();
                }
                if (WRFeedTriggerHandlerVar.parentIds.size() > 0)
                    WRFeedTriggerHandlerVar.emailNotificationforFeedItem();
                if (SimulationRequestHandlerVar.parentIds.size() > 0)
                   SimulationRequestHandlerVar.emailNotificationforFeedItem();
            }
             //Added by Dinesh
             String PCNKeyPrefix = PCN_EOL__c.sObjectType.getDescribe().getKeyPrefix();
             List<FeedItem> feedlist=new List<FeedItem>();
             List<String> parentlist=new List<String>();
             Boolean Isportal;
             User portaluser = [SELECT Id,ContactId FROM User WHERE Id =:UserInfo.getUserId()];
             if(portaluser.ContactId!=null){
              Isportal=true;
             }
             else{
              Isportal=false;
             }
             if(Isportal){
             for(FeedItem feed: trigger.new){
              //if(feed.InsertedById== portaluser.Id){
              String parentIdTemp = feed.parentId;
                    if (parentIdTemp.startsWith(PCNKeyPrefix )){
                        parentlist.add(parentIdTemp);
                        feedlist.add(feed);
                        }
                   //  }   
                }
              }  
            if(parentlist.size()>0){
				PCNFeedTriggerHandler.emailNotificationforFeedComment(feedlist,parentlist);
            }
        }
        
        
        if (trigger.isdelete) {
            //checks the user have permission to delete chatter feeds
            if (!feedtriggerhandlerVar.ValidateChatterDelete()) {
                for (FeedItem fdItem: trigger.old) {
                    String parentIdTemp = fdItem.parentId;
                    if (parentIdTemp.startsWith(oppKeyPrefix))
                        fdItem.adderror(label.BugChatterError);
                }
            }
        }
        
    }
}