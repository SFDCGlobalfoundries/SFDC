/*
 @class: FMS_DocumentLinkController
 @CreatedBy: Inshu Misra
 @CreatedDate: 15 Sep, 2016
 @Description: To display the FMS document links...#IM
 @Modifications-
 * 17/10/2016 - Abhita Bansal - Added the code for training Material on main page.
 * 28/11/2016 - Inshu Misra - Modified to have the file link instead of document link for training material on Main page and optimized the code...#IM
 */
public class FMS_DocumentLinkController {
    
    public String documentPage {get;set;}

    public FMS_DocumentLinkController () {
        documentPage = ApexPages.currentPage().getParameters().get('documentPage');
    }
    public List<SampleDoc> getDocumentList(){
        String orgId = UserInfo.getOrganizationId();
        List<SampleDoc> sdList = new List<SampleDoc>();
        List<ContentVersion> dContList = new List<ContentVersion>();
        
        //Ravindra -- Changes Starts for displaying Documents from Libraries.     
        String workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name =: UtilityCls.FMSLibraries][0].id;
        String fileGrp;
        if(documentPage == 'TrainingMat'){
            fileGrp = 'User Training';            
        }else if(documentPage == 'StepPlan'){
            fileGrp = 'Step Plan Package';            
        }
        for(ContentVersion doc : [SELECT id
                                         ,Title
                                         ,ContentSize
                                         ,FileExtension 
                                 FROM    ContentVersion 
                                 WHERE   ContentDocument.ParentId =:workspaceId  
                                 and     IsLatest = TRUE 
                                 and     file_group__c includes(:fileGrp) 
                                 order by Index_number__c]){
            SampleDoc sd = new SampleDoc();
            sd.link = '/sfc/servlet.shepherd/version/download/'+doc.Id;
            sd.contentType = doc.FileExtension;
            sd.size = getSize(doc.ContentSize);
            sd.name = doc.Title;
            sdList.add(sd);
        }

        //Ravindra - Changes Ends 
        return sdList;
    }
    
    public String getSize(Decimal s){
        String fileSize = '';
        if(s<1024){
            fileSize = String.valueOf(s)+' B';
        }else if(s/1024<1024){
            Decimal kbDec = s/1024;
            fileSize = String.valueOf(kbDec.setscale(2))+' KB';
        }else if(s/1024/1024<1024){
            Decimal mbDec = s/1024/1024;
            fileSize = String.valueOf(mbDec.setscale(2))+' MB';
        }else{
            Decimal gbDec = s/1024/1024/1024;
            fileSize = String.valueOf(gbDec.setscale(2))+' GB';
        }
        return fileSize;
    }
    
    public class SampleDoc{
        public String link{get;set;}
        public String contentType{get;set;}
        public String size{get;set;}
        public String name{get;set;}
    }
}