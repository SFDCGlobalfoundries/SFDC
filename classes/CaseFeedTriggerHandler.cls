/*********************************************************************************/
  // Purpose      : CaseFeedTriggerHandler class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 12th Oct, 2015
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  /* Description  : This class is handler class for CaseFeedCommentTrigger. The method sends mail
                    to all the Case creator , owner and Case team members when ever there is chatter
                    comment added or updated to Case record. */
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class CaseFeedTriggerHandler {
    
    public static boolean updateCaseOnFeedComment(List<FeedComment> newFCList) {
        
        if(newFCList == null || newFCList.size() < 1) {
            return false;
        }
        
        String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
        Map<Id, FeedComment> mapIdByFeedComment = new Map<Id, FeedComment>();
        Map<id,id> feedItemIdMap= new Map<id,id>();
        Map<id,id> relatedRecordIdMap = new Map<id,id>();
        
        for(FeedComment fc : newFCList) {
            String parentIdTemp = fc.parentId;
            if(parentIdTemp.startswith(caseKeyPrefix)) {
                mapIdByFeedComment.Put(fc.ParentId, fc);
                feedItemIdMap.put(fc.feeditemId,fc.id);
                relatedRecordIdMap.put(fc.RelatedRecordId,fc.id);
            }
        }
        
        if(!mapIdByFeedComment.IsEmpty()) {
            List<Case> caseList = [select Id,File_FeedComment__c,Last_FeedAttachment_IsPrivate__c,Feed_Comment__c,Last_FeedAttachment_Id__c,Last_FeedAttachment_FileName__c,
            							Last_Feed_Attachment_URL__c,Last_FeedComment_IsPublished__c,LastCaseFeedCommentId__c from Case where Id =: mapIdByFeedComment.KeySet()];
            
            List<FeedItem> feedItemList = [select id,visibility from feeditem where id in :feedItemIdMap.keyset()];
        	List<ContentVersion> contentversionList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion where id in :relatedRecordIdMap.keyset()];
        	
            for(FeedItem feedObj : feedItemList) { 
                for(Case caseObj : caseList) {
                	if(contentversionList.size() > 0) {
                		for(ContentVersion cVersion : contentversionList){
		                    if(mapIdByFeedComment.get(caseObj.Id).RelatedRecordId != null && feedObj.Visibility == 'AllUsers') {
		                        caseObj.File_FeedComment__c = mapIdByFeedComment.get(caseObj.Id).CommentBody; 
		                        caseObj.Last_FeedAttachment_IsPrivate__c = false;
		                        caseObj.Last_FeedAttachment_FileName__c = cVersion.title;
		                        caseObj.Last_FeedAttachment_Id__c = (string)mapIdByFeedComment.get(caseObj.Id).Id+caseObj.Last_FeedAttachment_IsPrivate__c;  
		                        caseObj.Last_Feed_Attachment_URL__c = 'sfc/servlet.shepherd/version/download/'+mapIdByFeedComment.get(caseObj.Id).RelatedRecordId;
		                    }
		                    else if(mapIdByFeedComment.get(caseObj.Id).RelatedRecordId != null && feedObj.Visibility == 'InternalUsers') {
		                        caseObj.File_FeedComment__c = mapIdByFeedComment.get(caseObj.Id).CommentBody;  
		                        caseObj.Last_FeedAttachment_IsPrivate__c = true; 
		                        caseObj.Last_FeedAttachment_FileName__c = cVersion.title;
		                        caseObj.Last_FeedAttachment_Id__c = (string)mapIdByFeedComment.get(caseObj.Id).Id+caseObj.Last_FeedAttachment_IsPrivate__c; 
		                        caseObj.Last_Feed_Attachment_URL__c = 'sfc/servlet.shepherd/version/download/'+mapIdByFeedComment.get(caseObj.Id).RelatedRecordId;
		                    }
                		}
                	}
                    else if(mapIdByFeedComment.get(caseObj.Id).RelatedRecordId == null && feedObj.Visibility == 'AllUsers') {
                        caseObj.Feed_Comment__c= mapIdByFeedComment.get(caseObj.Id).CommentBody; 
                        caseObj.Last_FeedComment_IsPublished__c = true;
                        caseObj.LastCaseFeedCommentId__c = (string)mapIdByFeedComment.get(caseObj.Id).Id+caseObj.Last_FeedComment_IsPublished__c;
                    }
                    else if(mapIdByFeedComment.get(caseObj.Id).RelatedRecordId == null && feedObj.Visibility == 'InternalUsers') {
                        caseObj.Feed_Comment__c= mapIdByFeedComment.get(caseObj.Id).CommentBody; 
                        caseObj.Last_FeedComment_IsPublished__c = false;
                        caseObj.LastCaseFeedCommentId__c = (string)mapIdByFeedComment.get(caseObj.Id).Id+caseObj.Last_FeedComment_IsPublished__c;
                    }
                }
            }
            
            if(caseList.size() > 0) {
                try {
                    update caseList;
                } catch(DMLException e) {
                    System.debug('### Unable to update Case object. Error message :: ' + e.getMessage());
                }
            }
        } 
        return true;  
    }
}