@isTest(seeAllData=false)
public class GFSSetFieldHistoryUpdateTest{
    
    @isTest static void HistoryTest1() {
        GFSSetFieldHistoryUpdate s = new GFSSetFieldHistoryUpdate();
        Map<Id,sObject> oldMap = new Map<Id,sObject>();
        Map<Id,sObject> newMap = new Map<Id,sObject>();
        Account a = new Account(Name='test');
        insert a;
        //Account a = [select Id,Name from Account limit 1];
        oldMap.put(a.Id,a);
        a.Name = 'test';
        newMap.put(a.Id,a);
        Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#';
        insert sfh;
        GFSSetFieldHistoryUpdate.preRequisite(oldMap,newMap);
        GFSSetFieldHistoryUpdate.updateHistoryObject(oldMap,newMap);
        system.assertEquals(sfh.Name, 'Account');
    }
}