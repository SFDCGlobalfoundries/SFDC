@isTest(seeAllData=false)
public class GFSSetFieldHistoryBatchTest{

    @isTest public static void BatchHistoryObjectTest1() {
        string sysAdminId = [Select Id, Name from Profile where Name='System Administrator'].Id;
        Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#Active__c';
        sfh.Profiles__c = sysAdminId;
        sfh.Layouts__c = 'Account-Account Layout';
        sfh.All_Layouts__c = 'Account-Account Layout';
        insert sfh; 
        Test.startTest();  
        
        string baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0]+'my.salesforce.com';
        GFSFieldHistoryObjectBatch batch = new GFSFieldHistoryObjectBatch(sfh.Id,baseURL,userinfo.getSessionId(),userinfo.getUserEmail(),'Account');
        Database.executeBatch(batch, 1);
        
        //GFSFieldHistoryProfileBatch batch1 = new GFSFieldHistoryProfileBatch('Account',userinfo.getSessionId(),userinfo.getUserEmail(),sfh.Id);
        //Database.executeBatch(batch1, 1);
        system.assert(baseURL!='');
        test.stopTest();
    }
    
    @isTest public static void BatchHistoryProfileTest1() {
        string sysAdminId = [Select Id, Name from Profile where Name='System Administrator'].Id;
        Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#Active__c';
        sfh.Profiles__c = sysAdminId;
        //sfh.Layouts__c = 'Account-Account Layout';
        //sfh.All_Layouts__c = 'Account-Account Layout';
        insert sfh; 
        Test.startTest();  
        
        string baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0]+'my.salesforce.com';        
        GFSFieldHistoryProfileBatch batch1 = new GFSFieldHistoryProfileBatch('Account',userinfo.getSessionId(),userinfo.getUserEmail(),sfh.Id);
        Database.executeBatch(batch1);
        system.assert(baseURL!='');
        test.stopTest();
    }
    
    @isTest public static void BatchHistoryLayoutTest1() {
        string sysAdminId = [Select Id, Name from Profile where Name='System Administrator'].Id;
        Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#Active__c';
        sfh.Profiles__c = sysAdminId;
        sfh.Layouts__c = 'Account-Account Layout';
        sfh.All_Layouts__c = 'Account-Account Layout';
        insert sfh; 
        Test.startTest();  
        
        string baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0]+'my.salesforce.com';        
        GFSFieldHistoryLayoutBatch batch1 = new GFSFieldHistoryLayoutBatch('Account',userinfo.getSessionId(),userinfo.getUserEmail(),sfh.Id, new map<string, string>{});
        Database.executeBatch(batch1, 1);
        system.assert(baseURL!='');
        test.stopTest();
    }
}