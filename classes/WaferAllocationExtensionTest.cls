/*
    Author: Abhita Bansal
    Created Date: 12/10/2014 
    Description: Test class for WaferAllocationExtension 
*/
@isTest(SeeAllData = False)
public class WaferAllocationExtensionTest {

    static testMethod void myWaferAllExtMethod() {
  
        User user4 = eWSRUtilityTestDataClass.getuser4();
        User user5 = eWSRUtilityTestDataClass.getuser5();
        
        Wafer_Allocation__c wafer = new Wafer_Allocation__c();
        wafer.Fab__c = 'FAB 5JV';
        wafer.Module1__c = 'CleanTech';
        wafer.Year__c = '2015';
        wafer.Wafer_Quantity_Allocated__c = 100;
        
        List<Id> user4Id = new List<Id>();
        user4Id.add(user4.Id);
        
        Test.startTest();
        System.runAs(user4){
            insert wafer;
            ApexPages.StandardController sc = new ApexPages.StandardController(wafer);
            WaferAllocationExtension waferClass = new WaferAllocationExtension(sc);
            waferClass.userId = user4Id;
            waferClass.gpYes = true;
            waferClass.Search(); 
            waferClass.Create();
            waferClass.EditPage();
            waferClass.getmoduleVal();
            waferClass.getprogramVal();
            waferClass.ViewPage();
            waferClass.cancel();
            waferClass.Back();
            waferClass.EditOnViewPage();
            waferClass.Reset();
            waferClass.Save();
            waferClass.SaveButton();
        }
       
        Wafer_Allocation__c wafer1 = new Wafer_Allocation__c();
        wafer1.Fab__c = 'FAB 3E';
        wafer1.Module1__c = 'CleanTech';
        wafer1.Year__c = '2015';
        wafer1.Wafer_Quantity_Allocated__c = 100;
        
        System.runAs(user4){
            insert wafer1;
            ApexPages.StandardController sc = new ApexPages.StandardController(wafer1);
            WaferAllocationExtension waferClass = new WaferAllocationExtension(sc);
            waferClass.Search(); 
            waferClass.Create();
            waferClass.EditPage();
            waferClass.getmoduleVal();
            waferClass.getprogramVal();
            waferClass.ViewPage();
            waferClass.cancel();
            waferClass.Back();
            waferClass.EditOnViewPage();
            waferClass.Reset();
            waferClass.Save();
            waferClass.SaveButton();
        }
        
        Wafer_Allocation__c wafer2 = new Wafer_Allocation__c();
        wafer2.Fab__c = 'FAB 5JV';
        wafer2.Module1__c = 'CleanTech';
        wafer2.Year__c = '2015';
        wafer2.Wafer_Quantity_Allocated__c = 100;
        
        System.runas(user5){
            insert wafer2;
            ApexPages.StandardController sc = new ApexPages.StandardController(wafer2);
            WaferAllocationExtension waferClass = new WaferAllocationExtension(sc);
            waferClass.gpYes = true;
            waferClass.Search(); 
            waferClass.Create();
            waferClass.EditPage();
            waferClass.getmoduleVal();
            waferClass.getprogramVal();
            waferClass.ViewPage();
            waferClass.cancel();
            waferClass.Back();
            waferClass.EditOnViewPage();
            waferClass.Reset();
            waferClass.Save();
            waferClass.SaveButton();
        }
        Test.stopTest();
    }
    
    
    
}