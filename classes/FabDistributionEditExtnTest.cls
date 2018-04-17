@istest(SeeAllData=false)
public class FabDistributionEditExtnTest{
    public static Fab_Distribution_Table__c FabObj {get;set;}
    public static Fab_Distribution_Table__c FabObj2 {get;set;}
    public static User sysAdminUser {get;set;}
    static{
        CreateData();
    }
    public static void CreateData(){
        List<Fab_Distribution_Table__c> FabList = new List<Fab_Distribution_Table__c>();
        FabObj = new Fab_Distribution_Table__c();
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        FabObj.Fab_No__c = 'FAB 1';
        FabObj.Distribution_List__c = 'test@test.com';
        FabObj.OwnerId = sysAdminUser.Id;
        FabList.add(FabObj);
        FabObj2 = new Fab_Distribution_Table__c();
        FabObj2.Fab_No__c = 'FAB 2';
        FabObj2.Distribution_List__c = 'testSFDC@test.com';
        FabObj2.OwnerId = sysAdminUser.Id;
        FabList.add(FabObj2);        
        insert FabList;
        System.assertNotEquals(FabList,null);
    }
    public static testmethod void NewFABTest(){
        System.runAs(sysAdminUser) {
            Test.startTest();
            
            Test.setCurrentPage(Page.VFMRSFabDistributionEdit);
            FabDistributionEditExtn FabExtnObj = new FabDistributionEditExtn(new apexpages.StandardController(new Fab_Distribution_Table__c())); 
            System.assertEquals(FabExtnObj.isEdit,false);
            List<Schema.FieldSetMember> fM = new List<Schema.FieldSetMember>();
            pagereference pR;
            
            pR = FabExtnObj.CancelValues();
            pR = FabExtnObj.InsertValues();
            fM = FabExtnObj.getLeftColumnFields();
            fM = FabExtnObj.getRightColumnFields();
            FabExtnObj.LeftColumn.Fab_No__c = FabObj2.Fab_No__c;
            pR = FabExtnObj.InsertValues();

            Test.stopTest();
        }
    }
    public static testmethod void EditFABTest(){
        System.runAs(sysAdminUser) {
            Test.startTest();
            
            Test.setCurrentPage(Page.VFMRSFabDistributionEdit);
            ApexPages.currentPage().getParameters().put('id',String.valueOf(FabObj.Id));
            FabDistributionEditExtn FabExtnObj = new FabDistributionEditExtn(new apexpages.StandardController(FabObj)); 
            System.assertEquals(FabExtnObj.isEdit,true);
            List<Schema.FieldSetMember> fM = new List<Schema.FieldSetMember>();
            pagereference pR;
            
            pR = FabExtnObj.CancelValues();
            pR = FabExtnObj.SaveValues();
            fM = FabExtnObj.getLeftColumnFields();
            fM = FabExtnObj.getRightColumnFields();
            FabExtnObj.LeftColumn.Fab_No__c = FabObj2.Fab_No__c;
            FabExtnObj.LeftColumn.Distribution_List__c = 'newMail@test.com';
            pR = FabExtnObj.SaveValues();
            
            Test.stopTest();
        }
    }    
    public static testmethod void EditAllFABTest(){
        System.runAs(sysAdminUser) {
            Test.startTest();
            
            Test.setCurrentPage(Page.VFMRSFabDistributionEdit);
            ApexPages.currentPage().getParameters().put('id',String.valueOf(FabObj.Id));
            FabDistributionEditExtn FabExtnObj = new FabDistributionEditExtn(new apexpages.StandardController(FabObj)); 
            System.assertEquals(FabExtnObj.isEdit,true);
            List<Schema.FieldSetMember> fM = new List<Schema.FieldSetMember>();
            pagereference pR;
            
            FabExtnObj.LeftColumn.Fab_No__c = 'All';
            pR = FabExtnObj.CancelValues();
            pR = FabExtnObj.SaveValues();
            fM = FabExtnObj.getLeftColumnFields();
            fM = FabExtnObj.getRightColumnFields();
            
            Test.stopTest();
        }
    }    

}