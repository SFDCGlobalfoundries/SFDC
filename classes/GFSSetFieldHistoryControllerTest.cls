@isTest(seeAllData=false)
public class GFSSetFieldHistoryControllerTest{

    @isTest public static void HistoryTest1() {
        /*Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#Active__c#';
        sfh.Profiles__c = 'GF CE#GF System Admin';
        inert sfh;  */
        
        GFSSetFieldHistoryController s = new GFSSetFieldHistoryController();
        GFSSetFieldHistoryController.LayoutWrapper wrapper = new GFSSetFieldHistoryController.LayoutWrapper();
        wrapper.chkVal = true;
        wrapper.layoutName = 'Account-Account Layout';
        
        s.layoutWrapperlist = new list<GFSSetFieldHistoryController.LayoutWrapper>();
        s.layoutWrapperlist.add(wrapper);
        
        s.doneClicked();
        s.selectedObject ='Account';
        s.leftselected.add('GF CE');
        s.leftselected.add('GF CSR');
        s.leftselected.add('GF CSR Lite');
        s.rightselected.add('GF Apps User Lite');
        s.getunSelectedValues();
        s.getSelectedValues();
        s.selectclick();
        s.unselectclick();
        s.FieldList();
        s.nextPage();
        test.startTest();
        s.saveChanges();
        //string baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0]+'my.salesforce.com';
        //GFSSetFieldHistoryHelper.createNewHistoryObject('Account','Account',baseURL ,userinfo.getSessionId(),sfh.Id);
        system.assertEquals(s.selectedObject, 'Account');
        test.stopTest();
    }
    @isTest static void HistoryTest2() {    
        string sysAdminId = [Select Id, Name from Profile where Name='System Administrator'].Id;
        Set_Field_History__c sfh = new Set_Field_History__c();
        sfh.Name = 'Account';
        sfh.FieldNameList__c ='Name#Active__c#';
        sfh.Layouts__c = 'Account-Account Layout';
        sfh.Profiles__c = sysAdminId;
        sfh.All_Layouts__c = 'Account-Account Layout';
        insert sfh;                  
        
        GFSSetFieldHistoryController s = new GFSSetFieldHistoryController();     
        GFSSetFieldHistoryController.LayoutWrapper wrapper = new GFSSetFieldHistoryController.LayoutWrapper();
        wrapper.chkVal = true;
        wrapper.layoutName = 'Account-Account Layout';
        
        s.layoutWrapperlist = new list<GFSSetFieldHistoryController.LayoutWrapper>();
        s.layoutWrapperlist.add(wrapper);
                   
        s.doneClicked();
        s.selectedObject ='Account';
        s.leftselected.add('GF CE');
        s.leftselected.add('GF CSR');
        s.leftselected.add('GF CSR Lite');
        s.rightselected.add('GF Apps User Lite');
        s.getunSelectedValues();
        s.getSelectedValues();
        s.selectclick();
        s.unselectclick();
        s.FieldList();
        s.fieldWrapperList[0].fieldCheck = true;
        s.nextPage();
        s.cancel();
        test.startTest();
        //s.saveChanges();
        test.stopTest();
        GFSFieldHistoryProfileBatch b = new GFSFieldHistoryProfileBatch('Account',userinfo.getSessionId(),userinfo.getUserEmail(),sfh.Id);
        Database.executeBatch(b,5);   
        system.assertEquals(s.selectedObject, 'Account');
        //string baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0]+'my.salesforce.com';
        //GFSSetFieldHistoryHelper.updateProfileAccess('Account',new list<string>{sysAdminId}, userinfo.getSessionId(),'a@b.com');
    } 
}