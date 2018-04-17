/*
  Author: Anirban Roy
  Description: This is the test class for the CPQInformationRequiredController class.
  History:
    ARoy        03032015    - code creation.
    sShar       10122015    - code modifications 
                1. seeAllData=false 
                2. Invoking "DataUtilTest.loadEnvironmentVariables()" at the beginning of each test method
*/

@isTest(SeeAllData=false)
public class CPQInformationRequiredControllerTest {
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
        fieldValueMap.put('Account_Manager__c',userinfo.getuserid());

        AccountDataFactory.createAccount(fieldValueMap);
    }
    // Test for Information Required
    static testMethod void cpqInformationRequiredTest1(){
               
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        addAccountTeamProxy(acctId);
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, Null, Null, Null, Null);
        rec.Apttus_Proposal__Approval_Stage__c = 'Submitted Phase';
        update rec; 
        
        CPQInformationRequiredController irc = new CPQInformationRequiredController(new ApexPages.StandardController(rec));             
    }
    
    // Test for Information Required
    static testMethod void cpqInformationRequiredTest2(){
        
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        addAccountTeamProxy(acctId);
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, Null, Null, Null, Null);
        rec.Apttus_Proposal__Approval_Stage__c = 'Submitted Phase';
        rec.Information_Required_Status__c = 'Information Required from Customer';
        update rec; 
        
        CPQInformationRequiredController irc = new CPQInformationRequiredController(new ApexPages.StandardController(rec));             
    }
    
    // Test for Information Required
    static testMethod void cpqInformationRequiredTest3(){
        
        Test.startTest();
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        addAccountTeamProxy(acctId);
        Id oppId = createOpp(acctId);
        Id oppProgId = createOppProg(acctId,oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        Device__c dev = createDevice(acctId, oppId, oppProgId);
        Test.stopTest();
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, oppId, dev.Id, Null, Null);
        rec.Apttus_Proposal__Approval_Stage__c = 'Configuration Design Phase';
        update rec;                 
        
        CPQInformationRequiredController irc = new CPQInformationRequiredController(new ApexPages.StandardController(rec));
        
        ApexPages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');
        
        PageReference pr = irc.submitPage();
        
        system.assert(pr.getUrl().contains('/GlobalfoundryView/'+rec.id));
        
        ApexPages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');
        
        pr = irc.cancel();
        
        system.assert(pr.getUrl().contains('/GlobalfoundryView/'+rec.id));                             
    }
    
    // Test for Information Required
    static testMethod void cpqInformationRequiredTest4(){
        
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        addAccountTeamProxy(acctId);
        Id oppId = createOpp(acctId);
        Id oppProgId = createOppProg(acctId,oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        Test.startTest();
        Device__c dev = createDevice(acctId, oppId, oppProgId);
        
        
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, oppId, dev.Id, Null, Null);
        rec.Apttus_Proposal__Approval_Stage__c = 'Configuration Design Phase';
        rec.Information_Required_Status__c = 'Information Required from FAE';
        update rec; 
        Test.stopTest();
        CPQInformationRequiredController irc = new CPQInformationRequiredController(new ApexPages.StandardController(rec));
        
        ApexPages.currentPage().getHeaders().put('Referer', 'test');
        
        PageReference pr = irc.submitPage();
        
        system.assert(pr.getUrl().contains('/' + rec.id));
        
        ApexPages.currentPage().getHeaders().put('Referer', 'test');
        
        pr = irc.cancel();
        
        system.assert(pr.getUrl().contains('/' + rec.id)); 
        
                     
    }
    
    /* 
        Method :        testCPQApprovalHandler1
        Reason:         This method tests CPQApprovalHandler 
        Author:         Prosenjit Saha - 02162015
    Modified by:   Shivam Sharma - 12102015
            Invoking "createAccount" and "createOpp" methods for creation of test data, instead of quering the organization Database
  */
    static testMethod void testCPQApprovalHandler1(){     
        
   
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        
        Id oppId = createOpp(acctId);
        
        Id oppProgId = createOppProg(acctId,oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        insert dev;
        
        
            Apttus_Proposal__Proposal__c Configuration = createProposal(acctId, oppId, dev.Id, null, Null);
    
        
            Configuration.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
            Configuration.Approval_Check__c = true ; 
            Update Configuration; 
        Test.stopTest();
    }
    
    /* 
        Method :        testCPQApprovalHandler2
        Reason:         This method tests CPQApprovalHandler 
        Author:         Prosenjit Saha - 02162015
    Modified by:   Shivam Sharma - 12102015
            Invoking "createAccount" and "createOpp" methods for creation of test data, instead of quering the organization Database
  */
    static testMethod void testCPQApprovalHandler2(){     
        
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        
        Id oppId = createOpp(acctId);
        
        Id oppProgId = createOppProg(acctId,oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        Device__c dev = createDevice(acctId, oppId, oppProgId);
        
        Test.startTest();        
                
        GroupMember PIYEtestUserGrpMem = new GroupMember ();
        for(GroupMember gmem : [select Group.Name, Group.id,   UserOrGroupId from GroupMember where Group.Type = 'Queue' AND Group.Name = 'Packaging Users Fab3' limit 1]){
            PIYEtestUserGrpMem = gmem;
        }
        
        User PIYEUser = new User();
        if(PIYEtestUserGrpMem != NULL && PIYEtestUserGrpMem.UserOrGroupId != NULL){
            for(user u: [SELECT id,name FROM user WHERE id = :PIYEtestUserGrpMem.UserOrGroupId and IsActive= true LIMIT 1] ){
                PIYEUser  = u;
            }
        }else{
            PIYEUser = [SELECT id,name,user.profile.name FROM user WHERE user.profile.name = 'GF PIYE' and IsActive= true LIMIT 1] ;
            User usr1 = [select id from User where profile.name = 'GF System Admin' and IsActive= true limit 1];
            List<Group> grpList = [select Name, Id from Group where Type in ('Queue','Regular') and Name = 'Packaging Users Fab3' limit 2];
            System.runAs(usr1){
                List<GroupMember> gmList = new List<GroupMember>();
                for(Group g : grpList){
                    GroupMember member = new GroupMember();
                    member.UserOrGroupId = PIYEUser.Id;
                    member.GroupId = g.id;
                    gmList.add(member);
                }          
                insert gmList;
            }            
        }        
        
        Apttus_Proposal__Proposal__c Configuration = createProposal(acctId, oppId, dev.Id, null, Null);
        
        Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
        propShare.ParentId = Configuration.Id;
        propShare.UserOrGroupId = PIYEUser.Id;
        propShare.AccessLevel = 'edit';
        insert propShare;
        
        System.runAs(PIYEUser){            
            Configuration.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
            Configuration.Approval_Check__c = true ; 
            Update Configuration; 
        }
        
        Test.stopTest();
        
    }
    
    // Creation of an Account
    static Id createAccount(){      
        
        Account acc = new Account(Name='MTK Test Account',Site_Department__c='IT',Sub_Type__c='Indirect',
                                    Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                    Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                    Corporate_City__c='Test City',Corporate_Country__c='India',Account_Manager__c=UserInfo.getUserId()
                                    );            
        insert acc;        
        return acc.Id;
    }
    
    static void addAccountTeamProxy(Id acctId){
        User u = [select id from User where id != :UserInfo.getUserId() and profile.name = 'GF Global Admin' and IsActive=true limit 1];
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.Id
                                                              ,Account__c=acctId
                                                              ,Account_Access__c='Read/Write'
                                                              ,Opportunity_Access__c='Read/Write'
                                                              ,Team_Role__c='Field Application Engineer');
        insert atp;    
    }
    
     // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');          
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;               
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1947');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('Confidence_Level_Tapeout__c','0');
        fieldValueMap.put('IP_Gap__c',false);
        fieldValueMap.put('Fab__c','FAB 3');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     //Mask_Set__c = szMaskSet,
                                                     //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}