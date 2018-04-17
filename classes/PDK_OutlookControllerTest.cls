@isTest

private class PDK_OutlookControllerTest{
    
    @isTest
    private static void testOutlookController(){
        
        ContentWorkspace WrkSpc = [SELECT id,DeveloperName FROM ContentWorkspace where DeveloperName !='' Limit 1];
          
        ContentDocument cod = new ContentDocument();
        //cod.parentId=WrkSpc.id;
        //cod.contentVersionId=cv.id;
       // update cod;
        
        ContentVersion cv = new ContentVersion(Title='Test Title',Description='test description',ContentDocumentId=cod.id,
                                            PathOnClient='/cod.id',VersionData=blob.valueOf('1'));                                                          
        insert cv;
      
        
        ContentDistribution cdn = new ContentDistribution(Name='test name',ContentVersionId=cv.Id);     
        insert cdn;
        
        List<Environment_Variable__c> lstVar = new List<Environment_Variable__c>();
        Environment_Variable__c v = new Environment_Variable__c();
        v.Name = 'PDK respective';
        v.value__c = 'Upcoming PDK Release';
        lstVar.add(v);
        
        Environment_Variable__c v1 = new Environment_Variable__c();
        v1.Name = 'PDK Outlook';
        v1.value__c = 'PDK_9_10_Outlook';
        lstVar.add(v1);
        
        Environment_Variable__c v2 = new Environment_Variable__c();
        v2.Name = 'PDK release';
        v2.value__c = WrkSpc.DeveloperName;
        lstVar.add(v2);
        
        insert lstVar;
        
         PageReference pageRef = Page.PDK_9_10_Outlook;
         Test.setCurrentPage(pageRef);
         test.startTest();
         PDK_OutlookController iuc = new PDK_OutlookController();
         test.stopTest();
    }
    
    
    
    
    
}