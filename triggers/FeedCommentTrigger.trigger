/*Author: Karthick D
* Description: This trigger fires on FeedComment object, when ever the chatter comment added or 
                updated on bug object and sends mail to bug owner, creator and bug team members.
* History: Created on 09/08/2014
           
*/
trigger FeedCommentTrigger on FeedComment(after insert, before delete) {

    FeedTriggerHandler feedtriggerhandlerVar = new FeedTriggerHandler();
    WRFeedTriggerHandler WRfeedtriggerhandlerVar = new WRFeedTriggerHandler();
    SimulationRequestHandler SimulationRequestHandlerVar = new SimulationRequestHandler();
    if (!IntegrationUserUtil.isSkipTrigger()) {

        String oppKeyPrefix = bug__c.sObjectType.getDescribe().getKeyPrefix();
        feedtriggerhandlerVar.feedcommentlistNew = trigger.new;
        feedtriggerhandlerVar.feedcommentmapNew = trigger.newMap;
        feedtriggerhandlerVar.parentIds = new list < string > ();
        WRfeedtriggerhandlerVar.feedcommentlistNew = trigger.new;
        SimulationRequestHandlerVar.feedcommentlistNew = trigger.new;
        list<string> parentIds = new list<string>();
        
        if (trigger.isinsert) {
            if (!BugTriggerHandler.CheckMailSkipforFeed()) {
                for (FeedComment fdComment: trigger.new) {
                    String parentIdTemp = fdComment.parentId;
                    if (parentIdTemp.startsWith(oppKeyPrefix))
                        parentIds.add(parentIdTemp);
                        
                }
                if( parentIds.size() > 0)
                {
                    for(bug__c b : [select id, isbug__c,Record_Type_API__c,IsASICBug__c,IsIPDEV__c from bug__c where id in :parentIds])
                        {
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
                                WRfeedtriggerhandlerVar.parentIds.add(b.id);
                        }
                 }   
                //Handler class executed only when comment added or updated on bug record.
                if (feedtriggerhandlerVar.parentIds.size() > 0){
                    feedtriggerhandlerVar.emailNotificationforFeedComment();
                    feedtriggerhandlerVar.updateBugChatterFieldFeedComment();
                }
                if (WRfeedtriggerhandlerVar.parentIds.size() > 0)
                    WRfeedtriggerhandlerVar.emailNotificationforFeedComment();
                if (SimulationRequestHandlerVar.parentIds.size() > 0)
                   SimulationRequestHandlerVar.emailNotificationforFeedComment();                   
            }
        } 
        
        if (trigger.isdelete) {
            //checks the user have permission to delete chatter comments
            if (!feedtriggerhandlerVar.ValidateChatterDelete()) {
                for (FeedComment fdComment: trigger.old) {
                    String parentIdTemp = fdComment.parentId;
                    if (parentIdTemp.startsWith(oppKeyPrefix))
                        fdComment.adderror(label.BugChatterError);
                }
            }
        }
    }
}