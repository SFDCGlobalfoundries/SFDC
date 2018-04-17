/*
Author: Cognizant Case Management Team
Description: The purpose of this test utility class is to load/create generic records for test class execution related to Case
History:
 
*/
@isTest(SeeAllData = false)
public class CaseDataUtilTest{

     public static void loadCustomSettingVariables() {
     
        /********* Custom setting Insert ************/
        
        CasePermissions__c settings = CasePermissions__c.getInstance();
        settings = new CasePermissions__c();
        settings.PublicCommentPermitted__c = true;
        settings.InternalCaseOnly__c = true;
           
        insert settings;
        
        /********* CaseAssignmentRules__c Custom setting Insert ************/
        
        CaseAssignmentRules__c setting1 = new CaseAssignmentRules__c();
        setting1.Name = 'Tape Out';
        insert setting1;
        
        CaseAssignmentRules__c setting2 = new CaseAssignmentRules__c();
        setting2.Name = 'Tapeout';
        insert setting2;
        
     }    
    
}