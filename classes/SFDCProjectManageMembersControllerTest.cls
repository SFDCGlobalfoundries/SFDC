/*
    Author: Art Contreras
    Created Date: Feb/25/2013 
    Description: Test class for SFDCProjectManageMembersController
    Test cases: 
    1. 
*/

@isTest
public class SFDCProjectManageMembersControllerTest{

    static testMethod void doITProjectManagerTest(){
        testDupeRoleMember('IT Project Manager');
    }
    
    static testMethod void doITProjectManagerBackupTest(){
        testDupeRoleMember('IT Project Manager(backup)');
    }
    
    static testMethod void doITOwnerTest(){
        testDupeRoleMember('IT Owner');
    }
    
     static testMethod void doBusinessOwnerTest(){
        testDupeRoleMember('Business Owner');
    }
    
     static testMethod void doWWMSTest(){
        testDupeRoleMember('WWMS System & Solution Owner');
    }
    
      static testMethod void doWWMSBackupTest(){
        testDupeRoleMember('WWMS Systems & Soluton Owner(backup)');
    }
    
    static testMethod void doITOwnerBackupTest(){
        testDupeRoleMember('IT Owner(backup)');
    }
    
     static testMethod void doBusinessOwnerBackupTest(){
        testDupeRoleMember('Business Owner(backup)');
    }
    
    static void testDupeRoleMember(String roleName)
    {
        test.startTest();
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        PageReference ref = new PageReference('/apex/SFDCProjectManageMembers?id='+newPro.Id); 
        Test.setCurrentPage(ref); 
        
        SFDC_Project_Member__c newMember = null;
        List<User> users = [SELECT Id FROM User where IsActive=true LIMIT 50];
        Integer i = 0;
        Boolean stop = false;
        for(User u:users)
        {
           newMember = new SFDC_Project_Member__c(SFDC_Project__c=newPro.id);
           newMember.User__c = u.id;
           if(i == 0)
           {
               newMember.Role__c = roleName;
           }else if(i == 1)
           {
               newMember.Role__c = roleName;
           }
           else
           {
              stop = true;
           }
           if(stop)
           {
               break;
           }
           insert newMember;
           ++i;
        }
        
        
        
        SFDCProjectManageMembersController controller = new SFDCProjectManageMembersController();
        controller.SFDCProject = newPro;
        controller.addNewRow();
        
        controller.Save();
        
        test.stopTest();

    }
    
     static testMethod void testNullAccess()
    {
        test.startTest();
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        PageReference ref = new PageReference('/apex/SFDCProjectManageMembers?id='+newPro.Id); 
        Test.setCurrentPage(ref); 
        
        SFDC_Project_Member__c newMember = null;
        List<User> users = [SELECT Id FROM User where IsActive=true LIMIT 50];
        Integer i = 0;
        Boolean stop = false;
        for(User u:users)
        {
           newMember = new SFDC_Project_Member__c(SFDC_Project__c=newPro.id);
           newMember.User__c = u.id;
           if(i == 0)
           {
               newMember.Role__c = 'IT Project Manager';
           }else
           {
              stop = true;
           }
           if(stop)
           {
               break;
           }
           
           insert newMember;
           ++i;
        }
        
        
        
        SFDCProjectManageMembersController controller = new SFDCProjectManageMembersController();
        controller.SFDCProject = newPro;
        controller.addNewRow();
        List<SFDC_Project_Member__c> mlist = controller.Members;
        for(SFDC_Project_Member__c mbr:mlist)
        {
           mbr.Access__c = null;
        }
        controller.Save();
        
        test.stopTest();

    }
    
     static testMethod void testNullRole()
    {
        test.startTest();
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        PageReference ref = new PageReference('/apex/SFDCProjectManageMembers?id='+newPro.Id); 
        Test.setCurrentPage(ref); 
        
        SFDC_Project_Member__c newMember = null;
        List<User> users = [SELECT Id FROM User where IsActive=true LIMIT 50];
        Integer i = 0;
        Boolean stop = false;
        for(User u:users)
        {
           newMember = new SFDC_Project_Member__c(SFDC_Project__c=newPro.id);
           newMember.User__c = u.id;
           if(i == 0)
           {
               newMember.Role__c = 'IT Project Manager';
           }else
           {
              stop = true;
           }
           if(stop)
           {
               break;
           }
           
           insert newMember;
           ++i;
        }
        
        
        
        SFDCProjectManageMembersController controller = new SFDCProjectManageMembersController();
        controller.SFDCProject = newPro;
        controller.addNewRow();
        List<SFDC_Project_Member__c> mlist = controller.Members;
        for(SFDC_Project_Member__c mbr:mlist)
        {
           mbr.Role__c = null;
        }
        controller.Save();
        
        test.stopTest();

    }
    
    static testMethod void testFailure()
    {
        test.startTest();
        
        SFDC_Project__c newPro = new SFDC_Project__c(Name='red',Overall_Status__c='Red',Priority_Sequence__c=0);
        insert newPro;
        
        PageReference ref = new PageReference('/apex/SFDCProjectManageMembers?id='+newPro.Id); 
        Test.setCurrentPage(ref); 
        
        SFDC_Project_Member__c newMember = null;
        List<User> users = [SELECT Id FROM User where IsActive=true LIMIT 50];
        Integer i = 0;
        Boolean stop = false;
        for(User u:users)
        {
           newMember = new SFDC_Project_Member__c(SFDC_Project__c=newPro.id);
           newMember.User__c = u.id;
           if(i == 0)
           {
               newMember.Role__c = 'IT Project Manager';
           } else
           {
              stop = true;
           }
           if(stop)
           {
               break;
           }
           insert newMember;
           ++i;
        }
        
        
        
        SFDCProjectManageMembersController controller = new SFDCProjectManageMembersController();
        controller.SFDCProject = newPro;
        controller.addNewRow();
        List<SFDC_Project_Member__c> mlist = controller.Members;
        for(SFDC_Project_Member__c mbr:mlist)
        {
           mbr.Access__c = 'foobar';
        }
        controller.Save();
        
        test.stopTest();

    }
}