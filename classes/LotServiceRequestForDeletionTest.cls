/*
    Author: Nikhil Jain
    Description: This Class serves as the test class for all the classes that needs to be deleted.
    History: 
        NJain        13-Aug-15    - Code creation
*/

@isTest(SeeAllData=false)
public class LotServiceRequestForDeletionTest{
      
    static testMethod void testLotServiceRequestPopulateTables() {
        test.startTest();
            LotServiceRequestPopulateTables l = new LotServiceRequestPopulateTables();
        test.stopTest();
    }
    
    
    static testMethod void testLotRequest_RecordTypeUpdate() {
        test.startTest();
            LotRequest_RecordTypeUpdate l = new LotRequest_RecordTypeUpdate();
        test.stopTest();
    }
    
}