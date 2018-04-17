/*********************************************************************************/
  // Purpose      : CaseFeedCommentTrigger is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 8th Oct, 2015
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : This trigger fires on FeedComment object, when ever the chatter comment added or 
  //                updated on Case object and sends mail to Case owner, creator and Case team members.
  // Change History 
  // 1. [Modify By]     :Cognizant Case Management Team
  //    [Modify Date]   :15thOct,2015
  //    [Reason]        :Implement Ask Question and Update CaseTimeline
/*********************************************************************************/
trigger CaseFeedCommentTrigger on FeedComment(after Insert, after Update) {
    if (!IntegrationUserUtil.isSkipTrigger()) {
        CaseFeedTriggerHandler.updateCaseOnFeedComment(Trigger.new);
        if (trigger.isinsert){
            CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);
            handler.caseQuestionAnswered(Trigger.new);
        }
            
    }
}