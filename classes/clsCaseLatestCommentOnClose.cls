/*
Type Name: clsCaseLatestCommentOnClose
Author: Cognizant
Created Date: 7th-Apr-2014
Reason: This class is used in CaseLatestCommentOnClose componet for creating Visualforce Email Template
Test Class: 
Change History:
Author: 
Modified Date: 
……..
……..
--
*/

public class clsCaseLatestCommentOnClose{    
    public Id parentId{get;set;}
    public String type{get;set;}
    
    public List<CaseComment> getCaseLatestComment()
    {
        List<CaseComment> casecomments;
        casecomments = [select Id,CommentBody,IsPublished,CreatedBy.Name,CreatedDate from CaseComment where ParentId =: parentId Order BY CreatedDate Desc Limit 1];
        return casecomments;
    }  
    
    public List<FeedItem> getCaseAllComments()
    {
        List<FeedItem> casecomments;
        casecomments = [SELECT Id, Type, ParentId, ContentFileName, Body, VISIBILITY, LinkUrl, Title,
                ContentDescription, ContentSize, ContentType, InsertedById , CreatedBy.Name ,CreatedDate FROM FeedItem where ParentId =: parentId And VISIBILITY = 'AllUsers' AND Type = 'TextPost' Order BY CreatedDate Desc];
        return casecomments;
    }    
}