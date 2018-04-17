/*
 Type Name: cls_Team_Room_Add_DocumentTest
 Author: Cognizant Technology Solutions
 Created Date: 11-July-2013
 Reason: This is the test class for 'cls_Team_Room_Add_Document' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/

@isTest
private class cls_Team_Room_Add_DocumentTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                            
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void testcls_Team_Room_Add_Document() {
        
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();
            Team_Room_Meeting__c teamRoomMeetingObj = new Team_Room_Meeting__c();
            Design_Spec__c designSpecObj  = new Design_Spec__c ();
            Design_Spec__c designSpecObj1  = new Design_Spec__c ();
           // Sub_PDK__c subPdkObj  = new Sub_PDK__c ();
           // Sub_PDK__c subPdkObj1  = new Sub_PDK__c ();
            Package__c packageObj  = new Package__c();
            Package__c packageObj1  = new Package__c();
            Team_Room_Doc__c tmd = new Team_Room_Doc__c();
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            userObj.Alias = 'Sally330';
            userObj.Email='Sally330@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Kuutti';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Sally330@test.com';
            userObj.IsActive = true;
                        
            insert userObj;
            
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
        teamRoomObj.Primary_Account__c=acctObj.id;
            
            insert teamRoomObj;
            
            teamRoomMeetingObj.Team_Room__c = teamRoomObj.id;
            teamRoomMeetingObj.Status__c='Open';
            teamRoomMeetingObj.Subject__c='Test Team Room';
            teamRoomMeetingObj.Start_DateTime__c = System.today().addDays(+1);
            
            insert teamRoomMeetingObj;
            
            RecordType recordTypeobj = [Select Id From RecordType where Name = 'Design Specs'];
            designSpecObj.name = 'Design Spec 1';
            designSpecObj.OpenText_ID__c = 12345;
            designSpecObj.Release_Status__c = 'Specific Account Release';
            designSpecObj.Specification_Type__c = 'Material Specifications';
            designSpecObj.Technology_Type__c = 'Tech 1';
            designSpecObj.Technology_Geometry__c = 'Tech Geo 1';
            designSpecObj.Is_Latest_Revision__c=true;
            designSpecObj.RecordTypeId= recordTypeobj.Id;
            
            insert designSpecObj;
            
            designSpecObj1.name = 'Design Spec 2';
            designSpecObj1.OpenText_ID__c = 123454;
            designSpecObj1.Release_Status__c = 'Specific Account Release';
            designSpecObj1.Specification_Type__c = 'Material Specifications';
            designSpecObj1.Technology_Type__c = 'Tech 12';
            designSpecObj1.Technology_Geometry__c = 'Tech Geo 1';
            designSpecObj1.RecordTypeId= recordTypeobj.Id;
            designSpecObj1.Is_Latest_Revision__c=true;
            
            insert designSpecObj1;
            
            List<Design_Spec__c> designSpecList = new List<Design_Spec__c>();
            designSpecList.add(designSpecObj);
            
           /* subPdkObj.name = 'Sub PDK 1';
            subPdkObj.Sub_PDK_OpenText_Id__c = 12345;
            subPdkObj.Release_Status__c = 'General';
           
            
            subPdkObj.name = 'Sub PDK 2';
            subPdkObj.Sub_PDK_OpenText_Id__c = 123456;
            subPdkObj.Release_Status__c = 'General';
            
            
            List<Sub_PDK__c> subPdkList = new List<Sub_PDK__c>();
            subPdkList.add(subPdkObj); 
            subPdkList.add(subPdkObj1);
            insert  subPdkList;     */   
            
            packageObj.name = 'Package 1';
            packageObj.OpenText_Id__c = 12345;
            packageObj.Package_Release_Status__c = 'Draft';
            insert packageObj;
            
            packageObj1.name = 'Package 2';
            packageObj1.OpenText_Id__c = 123458;
            packageObj1.Package_Release_Status__c = 'Draft';
            insert packageObj1;
            
            List<Package__c> packageList = new List<Package__c>();
            packageList.add(packageObj);   
            
            
            tmd.Design_Spec__c = designSpecObj.Id;
            //tmd.Sub_PDK__c = subPdkObj.Id;
            tmd.Design_Package__c = packageObj.Id;
            tmd.Team_Room__c = teamRoomObj.Id;
            insert tmd;
            
            System.runAs(userObj)
            {
            
                Test.startTest();
                
                ApexPages.currentPage().getParameters().put('itemType','Specifications');
                ApexPages.currentPage().getParameters().put('id',teamRoomObj.Id);
                ApexPages.StandardSetController con1 = new ApexPages.StandardSetController(designSpecList);
                cls_Team_Room_Add_Document clsTeamRoomAddDocumentObj= new cls_Team_Room_Add_Document(new ApexPages.StandardController(teamRoomObj));
                cls_Team_Room_Add_Document.wrappercls wrapperclsObj1 = new cls_Team_Room_Add_Document.wrappercls();
                RecordType rtObj =[Select Id From RecordType where Name = 'Design Specs'];
                
                wrapperclsObj1.checkbox = true;
                wrapperclsObj1.name = 'Design 1';
                wrapperclsObj1.itemID = designSpecObj1.Id;
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.recordTypeobj = rtObj ;
                clsTeamRoomAddDocumentObj.itemType = 'Specifications';
                clsTeamRoomAddDocumentObj.itemInfoGererate();
                clsTeamRoomAddDocumentObj.search();
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.searchParam = 'spec';
                clsTeamRoomAddDocumentObj.search();
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.first();
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.last();
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.previous();
                clsTeamRoomAddDocumentObj.wrapperItemList.add(wrapperclsObj1);
                clsTeamRoomAddDocumentObj.next();
                clsTeamRoomAddDocumentObj.submitItem();
                clsTeamRoomAddDocumentObj.cancel();
                clsTeamRoomAddDocumentObj.cancelAction();
                
              /*  ApexPages.currentPage().getParameters().put('itemType','Sub-Pdk');
                ApexPages.StandardSetController con2 = new ApexPages.StandardSetController(subPdkList);
                cls_Team_Room_Add_Document clsTeamRoomAddDocumentObj1= new cls_Team_Room_Add_Document(new ApexPages.StandardController(teamRoomObj));
                cls_Team_Room_Add_Document.wrappercls wrapperclsObj2 = new cls_Team_Room_Add_Document.wrappercls();
                
                wrapperclsObj2.checkbox = true;
                wrapperclsObj2.name = 'Sub PDK 1';
                wrapperclsObj2.itemID = subPdkObj1.Id;
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.itemType = 'Sub-Pdk';
                clsTeamRoomAddDocumentObj1.itemInfoGererate();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.searchParam = 'pdk';
                clsTeamRoomAddDocumentObj1.search();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.first();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.last();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.previous();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.next();
                clsTeamRoomAddDocumentObj1.wrapperItemList.add(wrapperclsObj2);
                clsTeamRoomAddDocumentObj1.submitItem();
                clsTeamRoomAddDocumentObj1.cancel();
                clsTeamRoomAddDocumentObj1.cancelAction();*/
                
                ApexPages.currentPage().getParameters().put('itemType','Package');
                ApexPages.StandardSetController con3 = new ApexPages.StandardSetController(packageList);
                cls_Team_Room_Add_Document clsTeamRoomAddDocumentObj2= new cls_Team_Room_Add_Document(new ApexPages.StandardController(teamRoomObj));
                cls_Team_Room_Add_Document.wrappercls wrapperclsObj3 = new cls_Team_Room_Add_Document.wrappercls();
               
                wrapperclsObj3.checkbox = true;
                wrapperclsObj3.name = 'Package 1';
                wrapperclsObj3.itemID = packageObj1.Id;
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.itemType = 'Package';
                clsTeamRoomAddDocumentObj2.itemInfoGererate();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.searchParam = 'pkg';
                clsTeamRoomAddDocumentObj2.search();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.first();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.last();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.previous();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.next();
                clsTeamRoomAddDocumentObj2.wrapperItemList.add(wrapperclsObj3);
                clsTeamRoomAddDocumentObj2.submitItem();
                clsTeamRoomAddDocumentObj2.cancel();
                clsTeamRoomAddDocumentObj2.cancelAction();
                Test.stopTest();    
            
            }        
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}