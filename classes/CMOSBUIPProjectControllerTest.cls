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
private class CMOSBUIPProjectControllerTest {

    static testMethod void myUnitTest() {
    	TestDataFactory.FillAllFields=true;
    	
        CMOS_BU_IP_Request__c objCMOSBUIPRequest=new CMOS_BU_IP_Request__c();//(CMOS_BU_IP_Request__c)TestDataFactory.createSObject('CMOS_BU_IP_Request__c');
        objCMOSBUIPRequest.Platform__c=true;
        objCMOSBUIPRequest.Business_Unit__c=null;//This field doesn't have value in record type settings
        //objCMOSBUIPRequest.Stage__c='Accepted';
         objCMOSBUIPRequest.Platform__c=true;
        objCMOSBUIPRequest.Business_Unit__c=null;//This field doesn't have value in record type settings(on PROD and UAT)
        objCMOSBUIPRequest.Reason_Why_Cancelled__c=null;
        objCMOSBUIPRequest.Target_Process_Node__c='22FDX';
        objCMOSBUIPRequest.IP_Subtype__c='Audio ADC';
        objCMOSBUIPRequest.Process_Geometry__c='0.022UM';
        insert objCMOSBUIPRequest; 
        
        system.assertNotEquals(null,objCMOSBUIPRequest.Id);
        
        /*List<PermissionSet> lstps = [SELECT ID From PermissionSet WHERE Name = 'CMOS_BU_IP_Project_Manager'];
        system.assertEquals(true,lstps.size()>0);
        insert new PermissionSetAssignment(AssigneeId = UserInfo.getUserId(), PermissionSetId = lstps.get(0).Id );
        */
        
        Test.Starttest();
       
        CMOSBUIPProjectController.ResultWrapper obj =CMOSBUIPProjectController.createNewIPProject(objCMOSBUIPRequest.id);
       
        objCMOSBUIPRequest.Stage__c='Accepted';
        update objCMOSBUIPRequest;
        
        obj =CMOSBUIPProjectController.createNewIPProject(objCMOSBUIPRequest.id);
     
        Test.stopTest();
        
        
    }
}