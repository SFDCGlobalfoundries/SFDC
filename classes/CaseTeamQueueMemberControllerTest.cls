/*********************************************************************************/
  // Purpose      : CaseTeamQueueMemberControllerTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 17 Feb, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : This is Test class for CaseTeamQueueMemberController class.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
@isTest(seeAllData=false)
public class CaseTeamQueueMemberControllerTest {
  
  //Positive Inputs
  static testMethod void queueMembersInsertMethod() {          
    Test.startTest();
        
    List< Group > listG = new  List< Group>();    
        List< GroupMember > listGM = new  List< GroupMember >();  
                           
        Group g1 = new Group(Name='Test group name', type='Queue');
        listG.add(g1);
        Group g2 = new Group(Name='Test public group');
        listG.add(g2);
        
        insert listG;  
        
        GroupMember gm1 = new GroupMember(GroupId=g1.Id , UserOrGroupId=UserInfo.getUserId());
        listGM.add(gm1);            
        GroupMember gm2 = new GroupMember(GroupId=g1.Id , UserOrGroupId=g2.Id);
        listGM.add(gm2);            
        GroupMember gm3 = new GroupMember(GroupId=g2.Id , UserOrGroupId=UserInfo.getUserId());
        listGM.add(gm3);
        
        insert listGM;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'sUcm1', Email = 'testUCM9@testsOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestsUcm1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testsUCMUser9@testsorg.com');
        insert usr;
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Internal_or_external__c = true,
            //AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
            
        );
        
        System.runAs (usr) {
            insert q1;
            insert caseObj;
        }
                  
    CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];          
    CaseTeamMember caseTMsObj = new CaseTeamMember(
      ParentId = caseObj.Id,
      MemberId = usr.Id,
      TeamRoleId = caseTMRoleObj.Id
    );    
                      
    PageReference pageRef1 = new PageReference('/apex/CaseTeamQueueMemberPage');
    Test.setCurrentPage(pageRef1);
    ApexPages.currentPage().getParameters().put('cId', caseObj.Id);
    CaseTeamQueueMemberController controller = new CaseTeamQueueMemberController();
    CaseTeamQueueMemberController.GetUserIdsFromGroup(g1.Id);
    controller.queueId = g1.Id;
    controller.caseId = caseObj.Id;
    controller.refresh();
    controller.getItems();
    controller.getqueueMembers();
    controller.cancelJob();
    controller.assignMembers();
                      
    Test.stopTest();
  }
  
  //Negative Inputs 
  static testMethod void queueMembersNegativeMethod() { 
        PageReference pageRef2 = new PageReference('/apex/CaseTeamQueueMemberPage');
        Test.setCurrentPage(pageRef2);
        ApexPages.currentPage().getParameters().put('cId',null);
        CaseTeamQueueMemberController controller = new CaseTeamQueueMemberController();
        controller.assignMembers();
    }    
}