@isTest(seeAllData=true)
private class IccUserController_Test{

@isTest
  private static void testIccUserController(){
  Test.startTest();
  ContentDocument cod = new ContentDocument();
  Id workspaceId = [select id,name from ContentWorkspace where name = 'ICC Migration Training Materials'].id;
    ContentVersion cv = new ContentVersion(Title='Test Title',Description='test description',
                                                                     ContentUrl='http://www.google.com');                                                             
       insert cv;
    ContentDistribution cdn = new ContentDistribution(Name='test name',ContentVersionId=cv.Id);          

      List<ContentDistribution> cdn1=new List<ContentDistribution>();
     cdn1 = [select Id, Name from ContentDistribution where Id=:cdn.Id limit 1];
     cdn1.add(cdn);
        system.debug('list of cdn is'+ cdn1);
      ApexPages.currentPage().getParameters().put('id',cdn.Id);
      
        PageReference pageRef = Page.IccUsers;
        Test.setCurrentPage(pageRef);
        IccUserController iuc = new IccUserController();
        IccUserController.MyWrapper instaceOftextBoxClass = new IccUserController.MyWrapper();
        String s1=instaceOftextBoxClass.sTitle;
        String s2=instaceOftextBoxClass.sDescription;
        String s3=instaceOftextBoxClass.sDistributionPublicUrl;
        boolean s4=instaceOftextBoxClass.isLink;
        instaceOftextBoxClass.sDescription='sdfsdfsd';
        instaceOftextBoxClass.sTitle='vscxfvsdf';
      List <ContentVersion> cv1=iuc.allDocuments;
      List <ContentVersion> cv2=iuc.lstContVersion2;
      List<ContentDistribution> cd2=iuc.lstContDist;
      List <ContentVersion> cv3=iuc.getIccUserController;
       List<ContentVersion> lstLinksCV = new List<ContentVersion>();
      List<ContentVersion> lstOtherCV = new List<ContentVersion>();
      lstLinksCV.add(cv);
      lstOtherCV.add(cv);
      instaceOftextBoxClass.isLink=false;
      iuc.getMapCntntVersion();
      
Test.stopTest();
  }

}