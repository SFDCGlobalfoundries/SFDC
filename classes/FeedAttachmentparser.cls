public class FeedAttachmentparser
{
    public static Map<Id,Id> FeedAttachmentMapper(Set<Id> ConDocIds)
    {
        Map<Id,Id> Feed2Docaffl=new Map<Id,Id>();
            for(FeedAttachment FA: [select id,RecordId,FeedEntityID from FeedAttachment where RecordId in : ConDocIds])
                Feed2Docaffl.put(FA.RecordId,FA.FeedEntityID);
        return  Feed2Docaffl;       
    }
    
}