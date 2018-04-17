public without sharing class IccUserController {

    public List <ContentVersion> getIccUserController { get; set; }
    List<ContentVersion> lstLinksCV = new List<ContentVersion>();
    List<ContentVersion> lstOtherCV = new List<ContentVersion>();
    public ID workspaceId{ get; set; }
    public List <ContentVersion> allDocuments{ get; set; }
    public List <ContentVersion> lstContVersion2{ get; set; }
    public List<ContentDistribution> lstContDist{ get; set; }
    
    public List<MyWrapper> myWrappers {get; set;}
  
  public IccUserController(){
   workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'ICC Migration Training Materials'][0].Id;

     allDocuments = [SELECT Id,Title,ContentUrl,Description,FileType 
                                            FROM ContentVersion 
                                            WHERE ContentDocument.ParentId = :workspaceId];
                                            
       for(ContentVersion cv: allDocuments){
            if(cv.FileType == 'LINK'){
                   lstLinksCV.add(cv);
            }    
            else{
                lstOtherCV.add(cv);
            }
      }
      lstContDist = [SELECT id,RelatedRecordId,ContentVersion.ContentUrl,ContentVersion.Title,ContentVersion.Description,ContentDocumentId,ContentVersionId,DistributionPublicUrl 
                                         FROM ContentDistribution
                                         where ContentVersionId In:lstOtherCV and ContentVersion.IsLatest = true];

  lstContVersion2 = [ SELECT Id,Title,ContentUrl,Description,FileType 
                                            FROM ContentVersion where Id In:lstLinksCV];
  
  myWrappers = new List<MyWrapper>();
    for(ContentDistribution cd1: lstContDist){
    MyWrapper wrap = new MyWrapper();
        wrap.sDistributionPublicUrl =cd1.DistributionPublicUrl;
        wrap.sDescription =cd1.ContentVersion.Description;
        wrap.sTitle =cd1.ContentVersion.Title;
        wrap.isLink=false;
        wrap.sId=cd1.ContentVersionId;
        myWrappers.add(wrap);
    }
    
    for(ContentVersion cv1: lstContVersion2){
    MyWrapper wrap1 = new MyWrapper();
        wrap1.sTitle =cv1.Title;
        wrap1.sDescription =cv1.Description;
        wrap1.sDistributionPublicUrl=cv1.ContentUrl;
        wrap1.isLink=true;
        wrap1.sId=cv1.id;
        myWrappers.add(wrap1);
    }

 
  
  }
  
public Class MyWrapper {
    public string sTitle {get; set;}
    public string sDescription {get; set;}
    public string sDistributionPublicUrl{get; set;}
    public string sId{get; set;}
    public boolean isLink{get; set;}
  }  
  public String getMapCntntVersion() {
        return null;
    }
}