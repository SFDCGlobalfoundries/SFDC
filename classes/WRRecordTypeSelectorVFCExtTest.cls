/*********************************************************************************/
  // Purpose      : WRRecordTypeSelectorVFCExtTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 03 April, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Test class for WRRecordTypSelectorVFCExt
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
@isTest(SeeAllData = false)
public class WRRecordTypeSelectorVFCExtTest{
    static Id PDKRequestRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('PDK Request').getRecordTypeId();
        return rtId;
    }
    static Bug__c createWR1() {
        Bug__c wr1 = new Bug__c();
        wr1.RecordTypeId = PDKRequestRecordType();
        wr1.Bug_Title__c = 'TestWR4';
        wr1.Bug_Description__c = 'TestWR4';
        wr1.Request_Type__c = 'Yes';
        wr1.Geometry__c = '0.11UM';
        wr1.Target_Process_Node__c = '110G';       
        wr1.Need_By_Date__c = Date.today().addDays(2);
        insert wr1;
        return wr1;
    }
    
    //Test Method forWRRecordTypSelectorVFCExt class
    public static testMethod void testCreateWRRT() {     
        test.starttest();
        Bug__c wr1 = createWR1();
        PageReference pageRef = new PageReference('/WRRecordTypeSelectorVFP/'+wr1.Id+'/e?retURL=%2F'+wr1.Id+'&RecordType='+wr1.RecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController sc = new Apexpages.StandardController(wr1);
        WRRecordTypeSelectorVFCExt Controller=new WRRecordTypeSelectorVFCExt(sc);
        Controller.editWithRecordType();
        test.stoptest();
    }
}