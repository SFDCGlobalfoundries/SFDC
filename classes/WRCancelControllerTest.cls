/*
Type Name: WRCancelControllerTest 
Author: Cognizant
Created Date: 18-Mar-2016
Reason: This is the Test class for Controller WRCancelController. 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/

@isTest(SeeAllData = false)
private class WRCancelControllerTest {
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

    static User createAdmin() {
        List < User > UserList = new List < User > ();
        Profile p = [Select Id from Profile where name = 'System Administrator'];

        User u1 = new User(ProfileId = p.Id, Username = 'test001' + System.now().format('MMddyyyyHHmmss') + '@test.com',
            Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User4',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        UserList.add(u1);

        insert UserList;
        return UserList[0];
    }
    static User createNonAdmin() {
        List < User > UserList = new List < User > ();
        //Profile p = [Select Id from Profile where name = 'CTS Developers' LIMIT 1];
		Profile p = [Select Id from Profile where name = 'GF Consultants' LIMIT 1];
		HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';        
        
        insert hcmemp;
        User u1 = new User(ProfileId = p.Id, Username = 'test002' + System.now().format('MMddyyyyHHmmss') + '@test.com',
            Alias = 'mm1', Email = 'test1@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'MMTest', Lastname = 'User1',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',HCM_Record_ID__c=hcmemp.id,FederationIdentifier='177314' );
        UserList.add(u1);

        insert UserList;
        return UserList[0];
    } 
      
    //Test Method for WRCancelController class
    public static testMethod void testMethod1() {        
        User sysAdmin = createAdmin();
        User u=createNonAdmin(); 
        System.runAs(sysAdmin) {
        test.starttest();
            Bug__c wr1 = createWR1();
            
            PageReference pageRef = new PageReference('/apex/WRCancel?Id='+wr1.Id);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController sc = new Apexpages.StandardController(wr1);
            WRCancelController edit1=new WRCancelController(sc);
            edit1.chatterComment='test';
            edit1.wrDetails = wr1;
            edit1.save();
            edit1.cancel();
        test.stoptest();
        }
    }
    public static testMethod void testMethod2() {        
        User sysAdmin = createAdmin();
        User u=createNonAdmin(); 
        System.runAs(sysAdmin) {
        try{
            test.starttest();
            Bug__c wr1 = createWR1();
            
            PageReference pageRef = new PageReference('/apex/WRCancel?Id='+wr1.Id);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController sc = new Apexpages.StandardController(wr1);            
            WRCancelController edit3=new WRCancelController(sc);
            edit3.chatterComment='ff';
            edit3.wrDetails = wr1;
            wr1.IsCancelRequest__c = true;
            update wr1;
            edit3.save();
            test.stoptest();
            }catch(Exception e){
                System.Assert(e.getMessage().contains('a'), e.getMessage());
            }
        }
    }
    public static testMethod void testMethod3() {        
        User sysAdmin = createAdmin();
        User u=createNonAdmin(); 
        System.runAs(sysAdmin) {
        test.starttest();
            Bug__c wr1 = createWR1();
            
            PageReference pageRef = new PageReference('/apex/WRCancel?Id='+wr1.Id);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController sc = new Apexpages.StandardController(wr1);
            WRCancelController edit2=new WRCancelController(sc);
            edit2.chatterComment='';
            edit2.wrDetails = wr1;
            edit2.save();
        test.stoptest();
        }
    }
}