/**
    @class: FMSRepoistoryDocumentsExt
    @CreatedBy : Abhita Bansal
    @CreatedDate: 20 Feb, 2017
    @Description: Controller for FMSRepoistoryDocuments page to show FMS Documents
    @Modifications-
    DATE            NAME                    Comments
    27-06-2017      Abhita Bansal           Added folderId in Environment Variable custom setting 
 * */
public with sharing class FMSRepoistoryDocumentsExt {
    List<Document> docsList = new List<Document>();
    public final String FMSDocumentFolderId = EnvironmentVariable.get('FMSDocumentFolderId'); // Added by Abhita
    
    public FMSRepoistoryDocumentsExt(ApexPages.StandardController controller){
        
    }
    
    public List<Document> getDocs() {
        docsList = [SELECT BodyLength,DeveloperName,FolderId,Id,Keywords,Name,Type,LastModifiedDate FROM Document where FolderId =: FMSDocumentFolderId];
        return docsList;
    }
    
    
}