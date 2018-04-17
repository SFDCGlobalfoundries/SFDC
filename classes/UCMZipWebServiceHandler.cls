/**
 * Zip WebService Class With JSZip
 *
 */
global class UCMZipWebServiceHandler {

    /**
     * Receive Attachments info from Attachment id, FeedItem id, ContentVersion id list
     * Use "," split for multiple Record
     */
    webService static String getAttachmentById(String sfdcId) {
        List < Object > dataList = new List < Object > ();
        
        String attachmentKeyPrefix = Attachment.sObjectType.getDescribe().getKeyPrefix();
        String fiKeyPrefix = FeedItem.sObjectType.getDescribe().getKeyPrefix();
        String cvKeyPrefix = ContentVersion.sObjectType.getDescribe().getKeyPrefix();


        if (String.isEmpty(sfdcId)) return UCMZipUtil.errorJson('Parameter sfdcId is required.');

        List < String > attIdList = new List < String > ();
        List < String > fiIdList = new List < String > ();
        List < String > cvIdList = new List < String > ();

        List < Attachment > attachmentList = new List < Attachment > ();
        List < FeedItem > feedItemList = new List < FeedItem > ();
        List < ContentVersion > contentVersionList = new List < ContentVersion > ();

        List < String > sfdcIdList = sfdcId.split(',');
        
        for (String objStr: sfdcIdList) {
            if (objStr.startsWith(attachmentKeyPrefix)) {attIdList.add(objStr);} 
            else if (objStr.startsWith(fiKeyPrefix)) {fiIdList.add(objStr);} 
            else if (objStr.startsWith(cvKeyPrefix)) {cvIdList.add(objStr);}
        }
        
        if (!fiIdList.isEmpty()) feedItemList = [SELECT Id, ContentData, Title, ContentFileName, ContentType FROM FeedItem WHERE Id IN: fiIdList];
        if (!cvIdList.isEmpty()) contentVersionList = [SELECT Id, Title, ContentDocumentId, versionData, FileExtension, FileType, PathOnClient FROM ContentVersion WHERE Id IN: cvIdList];
        if (!attIdList.isEmpty()) attachmentList = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE Id IN: attIdList];
        
        if (!feedItemList.isEmpty()) dataList.addall(new List < Object > (wrapFeedItemList(feedItemList)));
        if (!contentVersionList.isEmpty()) dataList.addall(new List < Object > (wrapFeedCommentList(contentVersionList)));
        if (!attachmentList.isEmpty()) dataList.addall(new List < Object > (wrapAttachmentList(attachmentList)));
        
        return UCMZipUtil.normalJson(dataList);
    }

    /**
     * Save Zip file to Document
     */
    webService static String saveToDocument(String zipFileData, String fileName) {

        try {
            String userId = UserInfo.getUserId();
            List < Document > docList = [SELECT Id, Name, FolderId, Body FROM Document WHERE Name = : fileName AND FolderId = : userId LIMIT 1];
            Document doc = new Document();
            if (docList == null || docList.size() == 0) {
                doc.Name = fileName;
                doc.FolderId = UserInfo.getUserId();
                doc.Body = EncodingUtil.base64Decode(zipFileData);
                insert doc;
            } else {
                doc = docList.get(0);
                doc.Body = EncodingUtil.base64Decode(zipFileData);
                update doc;
            }
            return UCMZipUtil.normalJson(doc.Id);
        } catch (Exception ex) {
            return UCMZipUtil.errorJson(ex.getMessage());
        }
    }
    
    //Format JSON String from AttachmentList
    private static List < Object > wrapAttachmentList(List < Attachment > attachmentList) {

        List < Object > dataList = new List < Object > ();
        for (Attachment at: attachmentList) {
            Map < String, String > atMap = new Map < String, String > ();
            //atMap.put( 'Id', at.Id );
            atMap.put('Name', at.Name);
            atMap.put('Body', EncodingUtil.base64Encode(at.Body));
            //atMap.put( 'ContentType', at.ContentType );
            dataList.add(atMap);
        }
        return (dataList);
    }
    //Format JSON String from FeedItem List
    private static List < Object > wrapFeedItemList(List < FeedItem > feedItemList) {

        List < Object > dataList = new List < Object > ();
        for (FeedItem fi: feedItemList) {
            Map < String, String > fiMap = new Map < String, String > ();
            //fiMap.put( 'Name', fi.Title);
            fiMap.put('Name', fi.ContentFileName);
            fiMap.put('Body', EncodingUtil.base64Encode(fi.ContentData));
            //fiMap.put( 'ContentType', fi.ContentType );
            dataList.add(fiMap);
        }
        return (dataList);
    }

    //Format JSON String from ContentVersion List
    private static List < Object > wrapFeedCommentList(List < ContentVersion > contentVersionList) {
        List < Object > dataList = new List < Object > ();
        for (contentversion cVersion: contentVersionList) {
            Map < String, String > fcMap = new Map < String, String > ();
            string filename = cVersion.Title + '.' +cVersion.FileExtension;
            fcMap.put('Name', filename);
            fcMap.put('Body', EncodingUtil.base64Encode(cVersion.versionData));
            //fcMap.put( 'ContentType', cVersion.FileType );
            dataList.add(fcMap);
        }
        return (dataList);
    }
}