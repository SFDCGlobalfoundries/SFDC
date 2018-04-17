/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MPWReticleTypeControllertest {

    static testMethod void myMPWReticleTypeControllerUnitTest() {
        // TO DO: implement unit test
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Active__c=true;
        mpwGeoMap.Use_Process_Type__c=true;
        mpwGeoMap.Geometry_ID__c = '0.028UM';
       try{ 
        insert mpwGeoMap;
       }catch(exception ex){} 
       
       system.assertNotEquals(null,mpwGeoMap.id);
        
        List<MPW_Reticle_Type__c> lst=new List<MPW_Reticle_Type__c>();
        lst.add(new MPW_Reticle_Type__c(name='0.028UM',Reticle_Type__c='test'));
        lst.add(new MPW_Reticle_Type__c(name='0.015UM',Reticle_Type__c='test2'));
       
       try{
         insert lst;
       }catch(exception ex){}
      
       system.assertNotEquals(null,lst.get(0).id);
      
        MPWReticleTypeController obj = new MPWReticleTypeController();
        obj.addNew();

        Test.startTest();
	        obj.sortField = 'Name';
	        obj.sortType='asc';
	        obj.sort();
	        obj.sortType='desc';
	        obj.sort();
	        obj.getHasPrevious();
	        obj.getHasNext();
	        obj.previous();
	        obj.next();
	        obj.first();
	        obj.last();
        Test.stopTest();

    }
    
    static testMethod void myMPWReticleTypeTranxControllerUnitTest() {
        // TO DO: implement unit test
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';
        mpwGeoMap.Active__c=true;
        mpwGeoMap.Use_Process_Type__c=true;
      
       try{ 
         insert mpwGeoMap;
       }catch(exception ex){} 
       
       system.assertNotEquals(null,mpwGeoMap.id);
        
         MPW_Reticle_Type__c objRecType = new MPW_Reticle_Type__c();
         objRecType.name='0.028UM';
         objRecType.Reticle_Type__c='Test';
      
       try{ 
         insert objRecType;
       }catch(exception ex){} 
       
       system.assertNotEquals(null,objRecType.id);
        
        Test.setCurrentPageReference(Page.MPWReticleTypeTranxVF);  
        System.currentPageReference().getParameters().put('id',objRecType.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWReticleTypeTranxController obj2 = new MPWReticleTypeTranxController(new ApexPages.Standardcontroller(new MPW_Reticle_Type__c()));
        MPWReticleTypeTranxController obj = new MPWReticleTypeTranxController();
      
        Test.startTest();
	    obj.save();
        obj.edit();
        obj.cancel();
        obj.getEditId();
        obj.getEditReticleType();
        obj.getShowEdit();
        obj.getShowSave();
        obj.getShowCancel();
        obj.getTechNodesList();
        obj.getEditTechNode();
        
        System.currentPageReference().getParameters().put('tranx','Add');
        obj = new MPWReticleTypeTranxController(new ApexPages.Standardcontroller(new MPW_Reticle_Type__c()));
        Test.stopTest();

    }
}