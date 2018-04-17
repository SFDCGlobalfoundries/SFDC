/*Author: UCM Team(Kali)
* Description: Test Class for ASICBugDetailPageCls,ASICBugEmailTemplateHandler
               
* History: Created on 11/3/2016
*/
@isTest(SeeAllData = false)
private class ASICBugDetailPageClsTest {
    public static String recordTypeId(){
        return String.valueOf(Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId());
    }
    
    
    public static User createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
        System.assert(u.id != null);
        return u;
    }
    
    
    private static testMethod void test1(){
        
        
        test.starttest();
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        User u2 = new User(Alias = 'standt2', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p2.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        insert u2;
        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   'FX14 Onwards';
        custSet.Sub_Type_B__c   =   'ASIC Front End Processing/DFTS';
        custSet.Sub_Type_C__c   =   'RTL Compiler';
        custSet.Sub_Type_D__c   =   'FX-14P';
        insert custSet;       
        
        BugErrorMessages__c setting = new BugErrorMessages__c();
        setting.Name = 'ASICOwnerResetConfirm';
        setting.Error_Message__c = 'Should the system re-route to the new owners/bug team members based on this Sub Types changes?';
        insert setting;
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'FX14 Onwards';
        b.Sub_Type_B__c   =   'ASIC Front End Processing/DFTS';
        b.Sub_Type_C__c   =   'RTL Compiler';
        b.Sub_Type_D__c   =   'FX-14P';
        insert b;
        
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        ASICBugUpdateOwnerAndTeam BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        
        
        BugUpdateOwnerandTeamVar.validateId('005p00000019FZI');
        BugUpdateOwnerandTeamVar.validateUserId('005p00000019FZI');
        BugUpdateOwnerandTeamVar.validateUserId('12345');
        BugUpdateOwnerandTeamVar.validateId('12345');
        
        b.Sub_Type_D__c   =   'Arabica Boards';
        BugUpdateOwnerandTeamVar.bugVar.Old_SubTypeA_TypeB_TypeC_TypeD__c = 'FX14 Onwards,ASIC Front End Processing/DFTS,RTL Compiler,FX-14P';
        
        BugUpdateOwnerandTeamVar.DeleteOldBugTeamMembers();
        
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.getAlertmessage();
        
        test.stoptest();
    }
    
    private static testMethod void test3(){
        List<Bug_ASIC_Picklist__c> listBugASIC = new List<Bug_ASIC_Picklist__c>();
        Bug_ASIC_Picklist__c objTestASICPicklist = new Bug_ASIC_Picklist__c();
        objTestASICPicklist.Problem_Type__c =   'Tool';
        objTestASICPicklist.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist.Sub_Type_D__c   =   'Timing and Coupled Noise';
        objTestASICPicklist.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist);
        
        Bug_ASIC_Picklist__c objTestASICPicklist2 = new Bug_ASIC_Picklist__c();
        objTestASICPicklist2.Problem_Type__c =   'Tool';
        objTestASICPicklist2.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist2.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist2.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist2.Sub_Type_D__c   =   'Testability and Test Generation';
        objTestASICPicklist2.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist2);
        insert listBugASIC;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        User u2 = new User(Alias = 'standt2', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p2.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        insert u2;
        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   '14LPP Prior';
        custSet.Sub_Type_B__c   =   'TheGuide Methodologies';
        custSet.Sub_Type_C__c   =   'SOM Methodology';
        custSet.Sub_Type_D__c   =   'Timing and Coupled Noise';
        insert custSet;       
        
        BugErrorMessages__c setting = new BugErrorMessages__c();
        setting.Name = 'ASICOwnerResetConfirm';
        setting.Error_Message__c = 'Should the system re-route to the new owners/bug team members based on this Sub Types changes?';
        insert setting;
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Problem_Type__c =   'Tool';
        b.Sub_Type_A__c   =   '14LPP Prior';
        b.Sub_Type_B__c   =   'TheGuide Methodologies';
        b.Sub_Type_C__c   =   'SOM Methodology';
        b.Sub_Type_D__c   =   'Timing and Coupled Noise';
        insert b;
        
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        ASICBugUpdateOwnerAndTeam BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        
        
        BugUpdateOwnerandTeamVar.bugVar.Old_SubTypeA_TypeB_TypeC_TypeD__c = 'FX14 Onwards,ASIC Front End Processing/DFTS,RTL Compiler,FX-14P';
        Apexpages.StandardController controller1 = new Apexpages.StandardController(b);
        ASICBugDetailPageCls objBugDetailPageCls = new ASICBugDetailPageCls(controller1);
        
        test.starttest();
        try{
            BugUpdateOwnerandTeamVar.ResetOwnerandTeam(); 
            objBugDetailPageCls.problemType = 'Tool';
            objBugDetailPageCls.retrieveProblemType(); 
            objBugDetailPageCls.isFromConstructor = false;
            objBugDetailPageCls.retrieveSubTypeB();
            objBugDetailPageCls.retrieveSubTypeC();
            objBugDetailPageCls.retrieveSubTypeA();
        }catch(Exception e){}
        test.stoptest();
        
    }
    
    
    private static testMethod void test() {
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = recordTypeId();
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Boards';
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        ASICBugDetailPageCls testASICBug = new ASICBugDetailPageCls(controller);
        testASICBug.selectedValue  = 'ESPRESSIO';
        testASICBug.values = 'ESPRESSIO,PEPS,FLANKERCR';
        testASICBug.fieldName = 'Sub_Type_A__c';
        testASICBug.values = 'ESPRESSIO,PEPS,FLANKERCR';
        testASICBug.fieldName = 'Sub_Type_B__c';
        testASICBug.values = 'ESPRESSIO,PEPS,FLANKERCR';
        testASICBug.fieldName = 'Sub_Type_C__c';
        testASICBug.values = 'ESPRESSIO,PEPS,FLANKERCR';
        testASICBug.fieldName = 'Sub_Type_D__c';
        b.Bug_Title__c = null;
        b.Technology__c = null;
        b.Need_By_Date__c = null;
        b.Account_Affected__c = null;
        b.Library_Release__c = null;
        b.Problem_Class__c = null;
        b.Problem_Type__c = null;
        b.Sub_TYpe_A__c = null;
        b.Sub_Type_B__c = '--None--';
        b.Sub_TYpe_C__c = '--None--';
        b.Sub_Type_D__c = null;
        b.Status__c = 'New';
        b.Resolution__c = 'Documentation';
        b.Projected_Availability_Date__c = Date.today();
        b.DevComplete__c = true;
        testASICBug.save();
        testASICBug.cancel();
    }
    
    private static testMethod void test2(){
        Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
                
        bug__c bugStatusChk1 = new bug__c();
        bugStatusChk1.Bug_Title__c = 'test ABC';
        bugStatusChk1.Product_technology__c = 'AMS Reference Flow';
        bugStatusChk1.Component__c = 'Block Packaging';
        bugStatusChk1.Status__c = 'New';
        bugStatusChk1.RecordTypeid = cadRecordTypeId;
        bugStatusChk1.Sub_Type_A__c = '';
        bugStatusChk1.Status__c = 'New';
        
        Apexpages.StandardController controller = new Apexpages.StandardController(bugStatusChk1);
        ASICBugDetailPageCls testASICBug = new ASICBugDetailPageCls(controller);
    }

}