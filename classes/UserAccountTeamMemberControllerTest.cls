/*
History:
    DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
    Vijay       04222015    - added test method for UserAccountTeamMemberController constructor
*/

@isTest(SeeAllData = false)
public  class UserAccountTeamMemberControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Fab_9_10__c','no');
               fieldValueMap.put('ownerid',userinfo.getuserid());
                fieldValueMap.put('Account_Manager__c',userinfo.getuserid());
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }    
    
    static map<string, user> createUserList(){
        
        map<string, user> userMap = new map<string, user>();
        for(user u :[select id, profile.name, Fab_Assigned__c from user where isactive = true and (//profile.name = 'Customer Portal Profile' 
                                                                                                       ( profile.name = 'GF System Admin' and Fab_Assigned__c = null and userRoleId != null)
                                                                                                        or (profile.name = 'GF CE' and Fab_Assigned__c != null ) 
                                                                                                        or profile.name = 'GF FAE/FTS'
                                                                                                        //or profile.name = 'GF PIYE'
                                                                                                        or profile.name = 'GF CSR'
                                                                                                        or (profile.name = 'GF Sales User' and userRoleId != null)
                                                                                                        )])
        {
            if(userMap.size() >= 10) break;
            if(u.profile.name == 'GF System Admin' && u.id != UserInfo.getUserId() && !userMap.containskey('Admin')){
                userMap.put('Admin', u);
            } else if(u.profile.name == 'GF Sales User' && !userMap.containskey('Owner')){
                userMap.put('Owner', u);
            } else if(u.profile.name == 'GF CE' && !userMap.containskey('CE')){
                userMap.put('CE', u);
            } else if(u.profile.name == 'GF FAE/FTS' && !userMap.containskey('PFTS')){
                userMap.put('PFTS', u);
            } else if(u.profile.name == 'GF FAE/FTS' && !userMap.containskey('FTS')){
                userMap.put('FTS', u);
            } else if(u.profile.name == 'GF CSR' && !userMap.containskey('BCSR')){
                userMap.put('BCSR', u);
            } else if(u.profile.name == 'GF CSR' && !userMap.containskey('CSR')){
                userMap.put('CSR', u);
            } 
                                                                                            
        }
        
        return userMap;
    }
    
    static account createAccount(id ownerid){
         Account acc= getAccount('MYTEST ACCOUNT1');
        acc.Account_Manager__c =  ownerid;
        acc.ownerid = ownerid;
        update acc;
        return acc; 
    }
    
    static account createAccount2(id ownerid){
         Account acc= getAccount('MYTEST ACCOUNT2');
        acc.Account_Manager__c =  ownerid;
        acc.ownerid = ownerid;
        update acc;
        return acc; 
        
    }
    
    static void createAtpList(id AccId, map<string, user> userMap){
        list<Account_Team_Proxy__c> atpList = new list<Account_Team_Proxy__c>();
        
        for(string role : userMap.keyset()){
            User usr = userMap.get(role);
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = usr.id);
            
            if(role == 'CE'){
                atp.Team_Role__c='Customer Engineer';
                atp.fab_assignment__c = usr.Fab_Assigned__c;
            }else if(role == 'PFTS'){
                atp.Team_Role__c='Primary Field Application Engineer';
            }else if(role == 'BCSR'){
                atp.Team_Role__c='Backup Customer Service Rep';
            }else{
                continue; 
            }
            
            
            atp.Sequence_No__c= String.valueOf(atpList.size() + 1);
            atp.Account_Role_ID__c = accid + ''+ usr.id;
            atp.Account__c = accid;
            atp.Account_Access__c='Read/Write';
            atp.Opportunity_Access__c='Read/Write';
            
            
            atpList.add(atp);
        }    
        
        insert atpList;
    }
    
    @isTest
     private static void testNewATP(){
        //DataUtilTest.loadEnvironmentVariables();
        map<string, user> userMap = createUserList();
        Id accOwnerId = userMap.get('Owner').id;
        Account acc = createAccount(accOwnerId);
        createAtpList(acc.id, userMap);
        
        
        Test.startTest();
        
        PageReference pref = Page.UserAccountTeamMember;
        Test.setCurrentPage(pref); 
        ApexPages.currentPage().getParameters().put('id',acc.id);
        UserAccountTeamMemberController ctrl = new UserAccountTeamMemberController(); 
        
        ctrl.addNewRow();
        integer newRowIndex = ctrl.AccountTeamProxyList.size() -1;
        Account_Team_Proxy__c newAtp = ctrl.AccountTeamProxyList[newRowIndex].atpObj;
        newAtp.User__c = userMap.get('Admin').id;
        newAtp.Account_Access__c = 'Read/Write';
        newAtp.Opportunity_Access__c='Read/Write';
        newAtp.Team_Role__c = 'Account Manager';
            
        ctrl.Save();
        Test.stopTest(); 
     }
     
     @isTest
     private static void testNewATPasCE(){
        //DataUtilTest.loadEnvironmentVariables();
        map<string, user> userMap = createUserList();
        Id accOwnerId = userMap.get('Owner').id;
        Account acc = createAccount(accOwnerId);
        createAtpList(acc.id, userMap);
        
        
        Test.startTest();
        
        PageReference pref = Page.UserAccountTeamMember;
        Test.setCurrentPage(pref); 
        ApexPages.currentPage().getparameters().put('id',acc.id);
        UserAccountTeamMemberController ctrl = new UserAccountTeamMemberController(); 
        
        ctrl.addNewRow();
        integer newRowIndex = ctrl.AccountTeamProxyList.size() -1;
        Account_Team_Proxy__c newAtp = ctrl.AccountTeamProxyList[newRowIndex].atpObj;
        newAtp.User__c = userMap.get('Admin').id;
        newAtp.Account_Access__c = 'Read/Write';
        newAtp.Opportunity_Access__c='Read/Write';
        newAtp.Team_Role__c = 'Cutomer Engineer';
            
        ctrl.Save();
        Test.stopTest(); 
     }
     
     @isTest
     private static void testNewPFTSandBCSR(){
        //DataUtilTest.loadEnvironmentVariables();
        
        map<string, user> userMap = createUserList();
        Id accOwnerId = userMap.get('Owner').id;
        Account acc = createAccount(accOwnerId);
        createAtpList(acc.id, userMap);
        
        
        Test.startTest();
        PageReference pref = Page.UserAccountTeamMember;
        Test.setCurrentPage(pref); 
        ApexPages.currentPage().getparameters().put('id',acc.id);
        UserAccountTeamMemberController utm = new UserAccountTeamMemberController(); 
        
        //utm.AccountName=acc.name;
        for(UserAccountTeamMemberController.AccountTeamProxyModel atpm :utm.AccountTeamProxyList){
            system.debug(logginglevel.Error,'running here '+atpm.oldRole);
            if(atpm.atpObj.Team_Role__c == 'Primary Field Application Engineer'){
                atpm.atpObj.Team_Role__c = 'Field Application Engineer';
                system.debug(logginglevel.Error,'running here '+atpm.oldRole);
                
            }else if(atpm.atpObj.Team_Role__c == 'Backup Customer Service Rep'){
                atpm.atpObj.Team_Role__c = 'Customer Service Rep';
                system.debug(logginglevel.Error,'running here' + atpm.oldRole);
                
            }
        }
        
        utm.addNewRow();
        integer newRowIndex = utm.AccountTeamProxyList.size() -1;
        Account_Team_Proxy__c newAtp = utm.AccountTeamProxyList[newRowIndex].atpObj;
        newAtp.User__c = userMap.get('FTS').id;
        newAtp.Account_Access__c = 'Read/Write';
        newAtp.Opportunity_Access__c='Read/Write';
        newAtp.Team_Role__c = 'Primary Field Application Engineer';
        
        utm.addNewRow();
        newRowIndex = utm.AccountTeamProxyList.size() -1;
        Account_Team_Proxy__c newAtp2 = utm.AccountTeamProxyList[newRowIndex].atpObj;
        newAtp2.User__c = userMap.get('CSR').id;
        newAtp2.Account_Access__c = 'Read/Write';
        newAtp2.Opportunity_Access__c='Read/Write';
        newAtp2.Team_Role__c = 'Backup Customer Service Rep';
            
        utm.Save();
        Test.stopTest(); 
     }
     
     static testMethod void testUserAccountTeamMemberController(){
        map<string, user> userMap = createUserList();
        Id accOwnerId = userMap.get('Owner').id;
        Account acc = createAccount(accOwnerId);
        Test.startTest();
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userMap.get('CE').id, Team_Role__c='Primary Field Application Engineer', Sequence_No__c= '1', Account_Role_ID__c = acc.Id + ''+ UserInfo.getUserId(),
                                                                Account__c = acc.Id, Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write');
        insert atp;
        
        PageReference pref = Page.UserAccountTeamMember;
        Test.setCurrentPage(pref); 
        ApexPages.currentPage().getparameters().put('id',atp.id);
        UserAccountTeamMemberController userAccTeamCntrl = new UserAccountTeamMemberController(new ApexPages.StandardController(atp)); 
        Test.stopTest();
        
     }
     
   private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }     
}