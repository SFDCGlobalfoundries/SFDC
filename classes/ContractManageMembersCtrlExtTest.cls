/*
    Author:
    Description:
    History:
        Nbustillos    10172013    - Added logic to load environmentVariables.
        Ashwini     05142015    - Updated code for refactoring of test class.
*/
@isTest
public class ContractManageMembersCtrlExtTest
{
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
    
static testMethod void TestContractMngMemCntrlrExt(){

 // DataUtilTest.loadEnvironmentVariables();
 
      // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };
          
          insert ndaSyncSettings;
                Account NDAtestAccount = getAccount('MYTEST ACCOUNT1');
                Contact ndacon2 = new Contact(
                firstName = 'NDAtest1', lastName = 'NDAtest1',accountId = NDAtestAccount.id);
                insert ndacon2 ;             
                Map <String,Schema.RecordTypeInfo> recordTypecustNDA = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getRecordTypeInfosByName();
                Id RecTypeIdNDA = recordTypecustNDA.get(Label.NDA_Multi_Party_Record_Type).getRecordTypeId();
                RecordType recType = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where Id = :RecTypeIdNDA ];
            
                Apttus__APTS_Agreement__c agmnt = new Apttus__APTS_Agreement__c(Name='NDAGLOBALFOUNDRIES NDA1', 
                RecordTypeId = recType.Id,Apttus__Account__c = NDAtestAccount.id,Apttus__Primary_Contact__c = ndacon2.Id,GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',Purpose__c = 'Testing',Type__c = 'None',Apttus__Status_Category__c = 'Request',GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,Apttus__Status__c='Request',How_many_Other_Parties_for_the_NDA__c = '2',Account_2__c = NDAtestAccount.Id,
                Contact_2__c = ndacon2.Id );    
                                        
                test.startTest();
                insert agmnt ;
                test.stopTest();

    apexpages.currentpage().getparameters().put('id',agmnt.id);
    
    Group grp = new Group(Name='GlobalFoundries Group', Type = 'Regular');
    insert grp;
    
    Contract_Team__c ctTeam = new Contract_Team__c();
    ctTeam.Group_Id__c = grp.id;
    ctTeam.Group_Selected__c=true;
    ctTeam.Is_Group__c = true;
    ctTeam.Agreement__c = agmnt.id; 
    ctTeam.Access__c = 'Read/Write';
    
    insert ctTeam;
    Contract_Team__c ctTeamMem2 = new Contract_Team__c ();
    ctTeamMem2.User__c=UserInfo.getUserId();
    ctTeamMem2.Group_Selected__c=true;
    ctTeamMem2.Is_Group__c = false;
    ctTeamMem2.Agreement__c = agmnt.id;
    ctTeamMem2.Access__c = 'Read/Write'; 
       insert ctTeamMem2 ;
    
    Contract_Team__c  ctTeamMem3 = new Contract_Team__c ();
    ctTeamMem3.Group_Id__c = grp.id;
    ctTeamMem3.Group_Selected__c=false;
    ctTeamMem3.Is_Group__c = true;
    ctTeamMem3.Agreement__c = agmnt.id; 
    ctTeamMem3.Access__c = 'Read';
    insert ctTeamMem3 ;
    ContractManageMembersCtrlExt ctMngMemCtrlExt = new ContractManageMembersCtrlExt(); 
    PageReference pgRef1 = ctMngMemCtrlExt.Save();
    PageReference pgRef = ctMngMemCtrlExt.addNewRow();
    PageReference pgRef2 = ctMngMemCtrlExt.deleteMember();
    System.assert(pgRef==null);
    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    }