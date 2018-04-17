/*Author: Sujit - Cognizant 
* Description: This is test class for CaseBugAssociation trigger
                and controller
* History: Created on 2/24/2014
Updated MM-24May2016 case52792 
*/


@isTest(SeeAllData=false)
public class CaseBugAssociationTest{
    //MM-24May2016 case52792 - Start    
    /*public static testMethod void testBugCaseAssociation() {
        
        RecordType RecType1 = [Select Id From RecordType  Where SobjectType = 'Case' and RecordType.DeveloperName = 'External_System'];
        RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Bug__c' and RecordType.DeveloperName = 'CAD_Bug'];
        
        Case objCase = new Case(RecordTypeId = RecType1.Id ,
                                Subject='Case - Something');        
        insert objCase;
        
        Bug__c objBug = new Bug__c (RecordTypeId = RecType2.Id,
                                Bug_Title__c='Bug - Something',
                                Origin__c=objCase.Id);
              
        insert objBug;
        //Trigger will prevent creating the duplicate relationship
        CaseBugAssociation__c objCaseBug=new CaseBugAssociation__c(Case__c=objCase.Id,Bug__c=objBug.Id);
        CaseBugAssociation__c objCaseBug1=new CaseBugAssociation__c(Case__c=objCase.Id,Bug__c=objBug.Id);
        try{
               upsert objCaseBug;
               upsert objCaseBug1;
        } catch (Exception e) {
            System.assert(e.getmessage().contains('duplicate')==true);
        }
    }*/
    //MM-24May2016 case52792 End
    public static testMethod void testCaseBugAssociationController() {
        
        RecordType RecType1 = [Select Id From RecordType  Where SobjectType = 'Case' and RecordType.DeveloperName = 'External_System'];
        RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Bug__c' and RecordType.DeveloperName = 'CAD_Bug'];
        
        Case objCase = new Case(RecordTypeId = RecType1.Id ,
                                Subject='Case - Something');        
        insert objCase;
     
        Bug__c objBug = new Bug__c (RecordTypeId = RecType2.Id,
                                Bug_Title__c='Bug - Something');
              
        insert objBug;
        Test.startTest();
        CaseBugAssociation__c objCaseBug1=new CaseBugAssociation__c(Case__c=objCase.Id,Bug__c=objBug.Id);
        CaseBugAssociation__c objCaseBug2=new CaseBugAssociation__c(Case__c=objCase.Id,Bug__c=objBug.Id);        
        PageReference pageRef1 = Page.CaseBugAssociationPage;
        Test.setCurrentPage(pageRef1);         
        apexpages.currentpage().getparameters().put('retURL',objCase.Id);  
        apexpages.currentpage().getparameters().put('saveURL',objCase.Id);                  
        CaseBugAssociationController  controller1 = new CaseBugAssociationController (new ApexPages.StandardController(objCaseBug1));
        controller1.SaveAndNew();
        controller1.Save();
        
        PageReference pageRef = new PageReference('/apex/CaseBugAssociationPage?SaveURL=' + 'test');  
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController  stdController1 = new Apexpages.StandardController(ObjCaseBug1);
        controller1 = new CaseBugAssociationController(stdController1);
        controller1.Save();
        controller1.SaveAndNew(); 
        //MM-24May2016 case52792 Start        
        CaseBugAssociationController  controller2 = new CaseBugAssociationController (new ApexPages.StandardController(objCaseBug2));
        controller2.SaveAndNew();
        controller2.Save();     
        Apexpages.StandardController  stdController2 = new Apexpages.StandardController(ObjCaseBug2);
        controller2 = new CaseBugAssociationController(stdController2);
        controller2.Save();
        controller2.SaveAndNew(); 
        Test.stopTest();
        //MM-24May2016 case52792 end
    }

}