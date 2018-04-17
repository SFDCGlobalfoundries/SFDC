@isTest(seeAllData = false)
public with sharing class FV_EditPackageClsTest{
    
    static testMethod void FV_EditPackageClsTest(){
    
        List<Design_Spec__c> dSpecList = new List<Design_Spec__c>();
            Design_Spec__c DSpec = new Design_Spec__c(Name='Spec-001',Document_Number__c='007',
                                                    technology_geometry__c='0.10UM',OpenText_ID__c=7007007,
                                                    Release_Status__c='Draft');
            //dSpecList.add(DSpec); 
            insert DSpec;     
                                                    
            Design_Spec__c DSpec1 = new Design_Spec__c(Name='Spec-002',Document_Number__c='008',
                                                    technology_geometry__c='0.10UM',OpenText_ID__c=700117007,
                                                    Release_Status__c='General Release');
            //dSpecList.add(DSpec1);                                        
            insert DSpec1;                                        
             
            package__c objPkg = new package__c();
            objPkg.Name = 'Test';
            objPkg.Tech_Geometry__c = '0.10UM';
            objPkg.Package_Release_Status__c='General Release'; 
            
            package__c objPkg1 = new package__c();
            objPkg.Name = 'Test121';
            objPkg.Tech_Geometry__c = '0.10UM';
            objPkg.Package_Release_Status__c='General Release';
            
            insert objPkg; 
            insert objPkg1;

        Test.startTest();
                       
            ApexPages.StandardController sc = new ApexPages.StandardController(objPkg);
            FV_EditPackageCls packageCls = new FV_EditPackageCls(sc);
            
            System.assertEquals(packageCls.designPackage.Package_Release_Status__c='General Release',
                                objPkg.Package_Release_Status__c='General Release');
                                
            packageCls.designPackage = objPkg;
            
            Package_Spec__c PckgSpec = new Package_Spec__c(package__c = objPkg.id,design_spec__c = DSpec.id);
            insert PckgSpec;
            
            packageCls.savePackage();
            
            try {
            
                ApexPages.StandardController sc1 = new ApexPages.StandardController(objPkg);
                FV_EditPackageCls packageCls1 = new FV_EditPackageCls(sc1);
            
                Package_Spec__c PckgSpec2 = new Package_Spec__c(package__c = objPkg1.id,design_spec__c = DSpec1.id);
                insert PckgSpec2;
                     
                packageCls1.savePackage();
                
            } catch (Exception e){
                system.assert(e.getMessage().contains('INVALID_FIELD_FOR_INSERT_UPDATE'),e.getMessage());          
             }    
            
        Test.stopTest();

    }
   
    
}