/*********************************************************************************/
  // Purpose      : BugRedirectTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 03 Oct, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Test class for BugRedirect
  // Change History 
  //    1. [Modify By] [Modify Date] : [Shiva Kumar] [19 oct,2016]
  //        [Reason] :increase code coverage 
/*********************************************************************************/
@isTest
public class BugRedirectTest{
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
        Schema.DescribeSObjectResult SchResBug = Schema.SObjectType.Bug__c;
        
        PageReference pageRef = new PageReference('/'+ SchResBug.getKeyPrefix() + '/e?nooverride=1&RecordType='+wr1.RecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController sc = new Apexpages.StandardController(wr1);
        BugRedirect Controller=new BugRedirect(sc);
        Controller.selectedrecordtype = wr1.RecordTypeId;
        Controller.redirectToPage();
        Controller.cancelOrder();
        String strType = ApexPages.currentPage().getParameters().put('type','clone');
        Controller.redirectToPage();
        Controller.cancelOrder();
        test.stoptest();
    }
    static Id PDKBugRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('PDK Bug').getRecordTypeId();
        return rtId;
    }
      static Bug__c createPDK() {
        Bug__c PDK1 = new Bug__c();
        PDK1.RecordTypeId = PDKBugRecordType();
        PDK1.Bug_Title__c = 'TestWR4';
        PDK1.Bug_Description__c = 'TestWR4';
        PDK1.Request_Type__c = 'Yes';
        PDK1.Geometry__c = '0.11UM';
        PDK1.Target_Process_Node__c = '110G';       
        PDK1.Need_By_Date__c = Date.today().addDays(2);
        insert PDK1;
        return PDK1;
    }
    
    /*
    Test method for PDK_Bug record type 
    @method name:redirectToPage 
    */
    public static testMethod void testCreatePDKBug() {     
           
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug',
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',
                           Priority = 'Low',Internal_or_external__c = false);
        insert c1;
        
        RecordType reType =[select id,name from recordtype where recordtype.name='PDK Bug'];         
        test.starttest();
        Bug__c PDK1 = createPDk();
        Apexpages.StandardController sc = new Apexpages.StandardController(PDK1);
        BugRedirect Controller=new BugRedirect(sc);
        Controller.selectedRecordType = reType.id;
        Controller.redirectToPage();
        Controller.cancelOrder();
               
        Schema.DescribeSObjectResult SchResBug = Schema.SObjectType.Bug__c;
        
        string caseId = ApexPages.currentPage().getParameters().put('caseid',c1.id);
        Controller.redirectToPage();
        Controller.cancelOrder();
        PageReference pageRef = new PageReference('/apex/loadbugFieldsPage?rid=' + Controller.selectedRecordType + '&caseid=' + caseId);
        Test.setCurrentPage(pageRef);
        
        test.stoptest();
    }
    static Id CDTRequestRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('CDT Bug').getRecordTypeId();
        return rtId;
    }
    static Bug__c createCDT() {
        Bug__c CDT1 = new Bug__c();
        CDT1.RecordTypeId = PDKRequestRecordType();
        CDT1.Bug_Title__c = 'TestWR4';
        CDT1.Bug_Description__c = 'TestWR4';
        CDT1.Request_Type__c = 'Yes';
        CDT1.Geometry__c = '0.11UM';
        CDT1.Target_Process_Node__c = '110G';       
        CDT1.Need_By_Date__c = Date.today().addDays(2);
        insert CDT1;
        return CDT1;
    }
    /*
    Test method for CDT_Bug record type 
    @method name:redirectToPage 
    */
    public static testMethod void testCreateCDTBug() { 
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug',
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',
                           Priority = 'Low',Internal_or_external__c = false);
        
        insert c1;
        
        RecordType reType =[select id,name from recordtype where recordtype.name='CDT Bug']; 
        test.starttest();
        Bug__c CDT1 = createCDT();
        Apexpages.StandardController sc = new Apexpages.StandardController(CDT1);
        BugRedirect Controller=new BugRedirect(sc);
        Controller.selectedRecordType = reType.id;
        Controller.redirectToPage();
        Controller.cancelOrder();
        string caseId = ApexPages.currentPage().getParameters().put('caseid',c1.id);
        Controller.redirectToPage();
        Controller.cancelOrder();
        test.stoptest();
    }
    static Id CADBugRecordType(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Bug__c;
        Map < String, Schema.RecordTypeInfo > WRbugRecordTypes = cfrSchema.getRecordTypeInfosByName();
        Id rtId = WRbugRecordTypes.get('CAD Bug').getRecordTypeId();
        return rtId;
    }
    static Bug__c createCAD() {
        Bug__c CAD1 = new Bug__c();
        CAD1.RecordTypeId = PDKRequestRecordType();
        CAD1.Bug_Title__c = 'TestWR4';
        CAD1.Bug_Description__c = 'TestWR4';
        CAD1.Request_Type__c = 'Yes';
        CAD1.Geometry__c = '0.11UM';
        CAD1.Target_Process_Node__c = '110G';       
        CAD1.Need_By_Date__c = Date.today().addDays(2);
        insert CAD1;
        return CAD1;
    }
    /*
    Test method for CAD_Bug record type 
    @method name:redirectToPage 
    */
    public static testMethod void testCreateCADBug() { 
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug',
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',
                           Priority = 'Low',Internal_or_external__c = false);
        
        insert c1;
        
        RecordType reType =[select id,name from recordtype where recordtype.name='CAD Bug']; 
        test.starttest();
        Bug__c CAD1 = createCDT();
        Apexpages.StandardController sc = new Apexpages.StandardController(CAD1);
        BugRedirect Controller=new BugRedirect(sc);
        Controller.selectedRecordType = reType.id;
        Controller.redirectToPage();
        Controller.cancelOrder();
        string caseId = ApexPages.currentPage().getParameters().put('caseid',c1.id);
        Controller.redirectToPage();
        Controller.cancelOrder();
        test.stoptest();
    }
}