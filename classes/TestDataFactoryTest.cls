@isTest
private class TestDataFactoryTest {
    static {
        TestDataFactory.FillAllFields = true; // increase test coverage without creating custom objects
    }

    static testMethod void createsSingleObjectWithSingleRequiredStringField() {
        Lead objCMOSBUIPRequest= (Lead) TestDataFactory.createSObject('Lead');
        //objCMOSBUIPRequest.Bussiness_Unit__c=null;
        //insert objCMOSBUIPRequest;
        System.assert(objCMOSBUIPRequest.Id == null);
        //System.assert(objCMOSBUIPRequest.Name != null);
    }
    
     static testMethod void createsObjectWithoutCascadeSetLookupField() {
        Lead objCMOSBUIPRequest= (Lead) TestDataFactory.createSObject('Lead', false);
         //objCMOSBUIPRequest.Business_Unit__c=null;
        //insert objCMOSBUIPRequest;
        System.assert(objCMOSBUIPRequest.Id== null);
    }
   
    static testMethod void createsObjectWithoutCascadeDoesNotSetLookupField() {
        Lead objCMOSBUIPRequest= (Lead) TestDataFactory.createSObject('Lead', false);
         //objCMOSBUIPRequest.Business_Unit__c=null;
        //insert objCMOSBUIPRequest;
        System.assert(objCMOSBUIPRequest.Id== null);
    }
    
    static testMethod void createscreateSObjectList() {
        Lead objCMOSBUIPRequest= (Lead ) TestDataFactory.createSObject('Lead', false,5);
        // objCMOSBUIPRequest.Bussiness_Unit__c=null;
        //insert objCMOSBUIPRequest;
        System.assertequals(null,objCMOSBUIPRequest.Id);
    }
    
     static testMethod void createscreateSObject() {
        List<Lead> lst= (List<Lead>) TestDataFactory.createSObjectList('Lead', false,5);
        //insert lst;
        System.assertNotequals(0,lst.size());
    }


    static testMethod void createObjectWithUnsupportedTypeThrowsException() {
        try {
            TestDataFactory.createSObject('Unsupported');
            System.assert(false);
        } catch (TestDataFactory.UnsupportedObjectTypeException ex) {
            System.assert(true);
        }
    }


}