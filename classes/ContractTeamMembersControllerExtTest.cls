/*
    Author:
    Description:
    History:
        Nbustillos    10172013    - Added logic to load environmentVariables.
        Ashwini     05142015    - Updated code for refactoring of test class.
*/
@IsTest (SeeAllData=false)

private class ContractTeamMembersControllerExtTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
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
    
     static testMethod void TestContractTeamMemCntrlrExt(){
             
            //DataUtilTest.loadEnvironmentVariables();       
             // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };        
            insert ndaSyncSettings;
             test.startTest();
             list<account> lstAcnt= new list<account>();
             List<Account> myAcctVal = [select id,(select id,accountid from contacts limit 1) from account where recordtype.name like '%customer%' limit 2];  
             for(account acc : myAcctVal){
               lstAcnt.add(acc);            
            }
           list<account> lstacc = new list<account>();
           if(lstAcnt!=null && lstAcnt.size()>0){
               lstacc = lstAcnt.deepClone(true,true,true);
           }
           else {
               Account acc = getAccount('MYTEST ACCOUNT1');
               lstacc.add(acc);
            }
           system.debug('Account val2' + lstacc ); 
           system.debug('Account val3' + lstAcnt); 
           system.debug('Account val4' + lstacc[0]); 
         
          //insert lstacc;
  
              Map <String,Schema.RecordTypeInfo> recordTypecustNDA = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getRecordTypeInfosByName();       
              Id RecTypeId = recordTypecustNDA.get(System.Label.NDA_RecordType).getRecordTypeId();
              RecordType recType = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where Id = :RecTypeId ];
  
              
            Apttus__APTS_Agreement__c armnt= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1', 
                RecordTypeId = recType.Id,Apttus__Account__c = lstacc[0].Id, GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',Purpose__c = 'Testing',Type__c = 'None',Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),GF_Contract_End_Date__c = date.today()+ 10,Apttus__Status__c='Request',
                geometries__c='0.010UM'+'\\;'+'0.11UM');    
                
            system.debug('Account val5' + armnt);
                           
            list<Apttus__APTS_Agreement__c> ndaMylstAgr=new list<Apttus__APTS_Agreement__c>();
            ndaMylstAgr.add(armnt);
            
           insert ndaMylstAgr;
       test.stopTest();

    ApexPages.StandardController sc = new ApexPages.StandardController(armnt);
    ContractTeamMembersControllerExt ctTeamMemCntrlrExt = new ContractTeamMembersControllerExt(sc);
    Apttus__APTS_Agreement__c  armnt2 = ctTeamMemCntrlrExt.getTeamRoom();
    
    System.assert(armnt2 !=null);
    
    Group grp = new Group(Name='GlobalFoundries Group', Type = 'Regular');
    insert grp;
    
    Contract_Team__c ctTeamMem = new Contract_Team__c();
    ctTeamMem .Group_Id__c = grp.id;
    ctTeamMem .Group_Selected__c=true;
    ctTeamMem .Is_Group__c = true;
    ctTeamMem .Agreement__c = armnt.id; 
    ctTeamMem .Access__c = 'Read/Write';
    insert ctTeamMem ;
    
    Contract_Team__c  ctTeamMem1 = new Contract_Team__c ();
    ctTeamMem1.User__c = UserInfo.getUserId();
    ctTeamMem1.Group_Selected__c=false;
    ctTeamMem1.Is_Group__c = false;
    ctTeamMem1.Agreement__c = armnt.id; 
    ctTeamMem1.Access__c = 'Read/Write';
    insert ctTeamMem1 ;
    apexpages.currentpage().getparameters().put('memberId',ctTeamMem.id);
    
    List<Contract_Team__c> ctTeamMemLst = ctTeamMemCntrlrExt.members;
    System.assert(ctTeamMemLst !=null);
    
    PageReference pgRef = ctTeamMemCntrlrExt.deleteMember();
    System.assert(pgRef==null);
    
    }

public static Apttus__APTS_Agreement__c createContractTeam() {
        
             list<account> lstAcnt1 = new list<account>();
             list<account> lstAcntTst = [select id, name from account where recordtype.name like '%customer%' limit 1]; 
             system.debug('account test val1' + lstAcntTst);
             
           for(account acc :[select id, name from account where recordtype.name like '%customer%' limit 1]){
               lstAcnt1.add(acc);            
           }         
           system.debug('account test val2' + lstAcnt1);
           list<account> lstacc1 = new list<account>();
           if(lstAcnt1!=null && lstAcnt1.size()>0){
               lstacc1 = lstAcnt1.deepClone(true,true,true);}
           else {
                Account acc = getAccount('MYTEST ACCOUNT1');
                lstacc1.add(acc);
                system.debug('account test val3' + lstacc1); 
             }
             
              Map <String,Schema.RecordTypeInfo> recordTypecustNDA = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getRecordTypeInfosByName();       
              Id RecTypeId = recordTypecustNDA.get(System.Label.NDA_RecordType).getRecordTypeId();
              RecordType recType = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where Id = :RecTypeId ];
  
             system.debug('account test val3545' + RecTypeId );
                
            Apttus__APTS_Agreement__c armnt3= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1', 
                RecordTypeId = recType.Id,Apttus__Account__c = lstacc1[0].Id,GF_Department_Name__c = 'Sales', Region__c = 'US East',
                Purpose__c = 'Testing',Type__c = 'None',Apttus__Status_Category__c = 'Request',GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,Apttus__Status__c='Request',
                geometries__c='0.010UM'+'\\;'+'0.11UM'
                );   
               
               return armnt3;
               
          } 

static Contract_Team__c createUserMembers(String agmntID, String memberUserId, String access) {
    
    Contract_Team__c cxteamMember = new Contract_Team__c();
    cxteamMember.Agreement__c = agmntID; 
    cxteamMember.Is_Group__c = false;
    cxteamMember.Access__c = access;
    cxteamMember.User__c = memberUserId;
    return cxteamMember; 
}
    
// Update for Contract Team Member Defect Tests.
static User createUser(String dataChange) {
    
    User testUser = new User();
    User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];
    testUser.FirstName = dataChange + ' ' + 'User FN';
    testUser.LastName = dataChange + ' ' + 'User LN';
    testUser.Username = dataChange + 'test.user@gf.com';
    testUser.email = dataChange + 'test.user@gf.com';
    testUser.Email = dataChange + 'test.user@gf.com';
    testUser.Alias = dataChange + 'ALI';
    testUser.CommunityNickname = dataChange + 'COMM';
    //testUser.ProfileId = [SELECT id FROM Profile WHERE Name = 'GF Platform'].get(0).id;
    testUser.ProfileId = [SELECT id FROM Profile WHERE Name = 'System Administrator'].get(0).id;
    testUser.FederationIdentifier = dataChange;
    testUser.TimeZoneSidKey = dummyUser.TimeZoneSidKey;
    testUser.LocaleSidKey = DummyUser.LocaleSidKey;
    testUser.EmailEncodingKey = DummyUser.EmailEncodingKey;
    testUser.LanguageLocaleKey = DummyUser.LanguageLocaleKey;
    
    return testUser;
}

static testMethod void testShowAll(){

    // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };        
            insert ndaSyncSettings;
// Create Dummy Contract Room, Contract Team Member Data
Apttus__APTS_Agreement__c  Contractteam = ContractTeamMembersControllerExtTest.createContractTeam();
      insert Contractteam;       
        System.debug('Display agremment1' + Contractteam);
  test.startTest();
        List<User> lTeamMemberUsers = new List<User>(); 
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U1'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U2'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U3'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U4'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U5'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U6'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U7'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U8'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U9'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U10'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U11'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U12'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U13'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U14'));
        
           insert lTeamMemberUsers;
           List<Contract_Team__c> lTeamMembers = new List<Contract_Team__c>();
    for (User eachUser: lTeamMemberUsers) {
        lTeamMembers.add(createUserMembers(Contractteam.Id, eachUser.Id, 'Read'));
    }
          insert lTeamMembers;
     ApexPages.StandardController standardController = new ApexPages.StandardController(Contractteam);   
    ContractTeamMembersControllerExt cxTmMemCtrlExt = new ContractTeamMembersControllerExt(standardController);
    
    if (cxTmMemCtrlExt != null && cxTmMemCtrlExt.members != null && cxTmMemCtrlExt.members.size() > 0) {
    System.assert(cxTmMemCtrlExt.members.size() == 5);
    
    cxTmMemCtrlExt.getAllTeamMembers();
    test.stopTest();
    System.assert(cxTmMemCtrlExt.members.size() == 14);
    }
   }
        
 static testMethod void testShowNextAndDelete(){
            // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };        
            insert ndaSyncSettings;
        Apttus__APTS_Agreement__c Contractteam = ContractTeamMembersControllerExtTest.createContractTeam();
        
           insert Contractteam;
           test.startTest();
           List<Apttus__APTS_Agreement__c  > lContractTeam = [SELECT Id, Type__c , Owner.Name, OwnerId from Apttus__APTS_Agreement__c WHERE Id =: Contractteam.Id];
    //Contractteam = lContractTeam.get(0);
        List<User> lTeamMemberUsers = new List<User>(); 
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U1'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U2'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U3'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U4'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U5'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U6'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U7'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U8'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U9'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U10'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U11'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U12'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U13'));
        lTeamMemberUsers.add(ContractTeamMembersControllerExtTest.createUser('U14'));           
        insert lTeamMemberUsers;
              
        List<Contract_Team__c> lTeamMembers = new List<Contract_Team__c>();
        for (User eachUser: lTeamMemberUsers) {
        lTeamMembers.add(createUserMembers(Contractteam.Id, eachUser.Id, 'Read'));
        }
        insert lTeamMembers;
        ApexPages.StandardController standardController = new ApexPages.StandardController(Contractteam); 
        
        ContractTeamMembersControllerExt cxTmMemCtrlExt = new ContractTeamMembersControllerExt(standardController);
        
        if (cxTmMemCtrlExt != null && cxTmMemCtrlExt.members != null && cxTmMemCtrlExt.members.size() > 0) {
        System.assert(cxTmMemCtrlExt.members.size() == 5);
        
        cxTmMemCtrlExt.getTeamMembers();
        
        System.assert(cxTmMemCtrlExt.members.size() == 10);
        
        if (lTeamMembers != null && lTeamMembers.size() > 0) {
        ApexPages.currentPage().getParameters().put('memberId', lTeamMembers.get(0).Id);
        cxTmMemCtrlExt.deleteMember();
           test.stoptest();
        System.assert(cxTmMemCtrlExt.members.size() == 9); 
        }
        }
        }
        
       static testMethod void testNoContractTeam() {
           // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };        
            insert ndaSyncSettings;
       // Create Dummy Contract Team Data
       Apttus__APTS_Agreement__c Contractteam = ContractTeamMembersControllerExtTest.createContractTeam();     
       insert Contractteam;
       test.starttest();
       ApexPages.StandardController standardController = new ApexPages.StandardController(Contractteam); 
        ContractTeamMembersControllerExt ctTmRmCtrlExt = new ContractTeamMembersControllerExt(standardController); 
        
        System.assert(ctTmRmCtrlExt.totalRecordCount == 0);
        System.assert(ctTmRmCtrlExt.retrivedRecordCount== 0); 
        test.stoptest();
        }
        
        private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
        
     }