/*
Type Name: EmailHandlerUtilityPerMSTTest
Author: Cognizant 
Created Date: 15-December-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/
@isTest(SeeAllData=false)
public class EmailHandlerUtilityPerMSTTest {
    private static User testAdminUserRunAs,testAdminUser;
    private static Account testAccount;
    private static Mask_Set_Title__c testMST;
    private static Account_Team_Proxy__c testATP;
    private static Fab_Distribution_Table__c testFAB;
    private static PTRF__c testPTRF;
    private static list<PTRF_JobViewer_Info__c> testListPTRFJobviewer;
    private static MRS__c testMRS;
    private static list<MRS_Layer_Association__c> testListMRSLA;
    private static list<MRS_Layer_Chip_Association__c> testListMRSLCA;
    
    static {
        prepareTestData();
    }
    private static void prepareTestData() {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].get(0);
        Id sysAdminProfileId = sysAdminProfile.Id;
        
        list<User> listTestUser = new list<User>();
        testAdminUserRunAs = new User(alias = 'test1', email='testRunAs@mrs.com',
                                    emailencodingkey='UTF-8', lastname='RunAs', firstname='Test', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = sysAdminProfileId,HCM_Login_ID__c='E1001',
                                    timezonesidkey='America/Los_Angeles', username='testRunAs@mrs.com.test',communitynickname='testRunAs');
        listTestUser.add(testAdminUserRunAs);                           
        testAdminUser = new User(alias = 'test2', email='testPerMST@mrs.com',
                                    emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = sysAdminProfileId,HCM_Login_ID__c='E1101',
                                    timezonesidkey='America/Los_Angeles', username='testPerMST@mrs.com.test',communitynickname='testAdmin');
        listTestUser.add(testAdminUser);
        insert listTestUser;
        
           
        System.runAs(testAdminUserRunAs){            
            SwiftDataUtilityTest.customSystemData();
            testAccount = SwiftDataUtilityTest.createTestAccount();
            testATP = new Account_Team_Proxy__c(User__c = testAdminUser.id,Account__c=testAccount.id,Account_Access__c='Read/Write',
                            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert testATP;
            
            testMST = SwiftDataUtilityTest.createMST('MPWTEST');
            insert testMST;
            
            testFAB = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='testfab@test.com');
            insert testFAB;
            
            testPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',
                                    MaskSetTitle__c=testMST.Id,Customer__c=testAccount.id,Tech_Geo_Value__c='0.01',
                                    Customer_jobview__c='Gating mask release',Fab__c='Fab1');
            insert testPTRF;
            
            
            testListPTRFJobviewer = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c testCJV = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=testPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=testAdminUser.Id);
            testListPTRFJobviewer.add(testCJV);
            PTRF_JobViewer_Info__c testFJV = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=testPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=testAdminUser.Id);
            testListPTRFJobviewer.add(testFJV);
            insert testListPTRFJobviewer;
            
            testMRS = new MRS__c(Mask_Set_Title__c=testMST.Id);
            insert testMRS;
            
            testListMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=testMRS.Id,Tech_Geo__c='0.01UM',LogicalOperation__c='1101',Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            testListMRSLA.add(objMRSLA1);
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=testMRS.Id,Tech_Geo__c='0.01UM',Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            testListMRSLA.add(objMRSLA2);
            insert testListMRSLA;
               
            List<MRS_Chip_Details__c> testListMRSChip = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=testMRS.Id,Name='Chip001');
            testListMRSChip.add(objMRSCD1);
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=testMRS.Id,Name='Chip002');
            testListMRSChip.add(objMRSCD2);
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=testMRS.Id,Name='Frame');
            testListMRSChip.add(objMRSCD3);
            insert testListMRSChip;
            
            testListMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=testPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=testAccount.Id);
            testListMRSLCA.add(objMRSLCA1);
            testListMRSLCA.add(objMRSLCA2);
            testListMRSLCA.add(objMRSLCA3);
            testListMRSLCA.add(objMRSLCA4);
            testListMRSLCA.add(objMRSLCA5);
            testListMRSLCA.add(objMRSLCA6);
            insert testListMRSLCA;
            
            TECN__c testTECN = new TECN__c(Originator__c='E1101',TECN_No__c='1101',Related_TECN_No__c='1101',TECN_Status__c='In Progress');
            insert testTECN;
        }
    }
    public static testMethod void sendEmailPerMSTNoMaskLayersTest() {
        map<string,Schema.RecordTypeInfo> mapEmailConfigRecType = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo recTypeInfoMSTNoMaskLayers = mapEmailConfigRecType.get('MST-No Mask Layers');
        Id recTypeIdMSTNoMaskLayers;
        if(recTypeInfoMSTNoMaskLayers!=null) {
            recTypeIdMSTNoMaskLayers = recTypeInfoMSTNoMaskLayers.getRecordTypeId();
        }
        list<Email_Config_Settings__c> listTestEmailConfig = new list<Email_Config_Settings__c>();
        Email_Config_Settings__c emailConfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_No_Mask_Layer_For_Shipped_Mask_WIP',
                                                                                    RecordTypeId=recTypeIdMSTNoMaskLayers,
                                                                                    Available_For_Use__c=true,
                                                                                    MPW_PTRF__c=true,
                                                                                    TO__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin',
                                                                                    CC__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin',
                                                                                    BCC__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin');
                                                                                    
        listTestEmailConfig.add(emailConfigObj);
        insert listTestEmailConfig;
        list<string> listLayer = new list<string>{'RXAZ','XPCZ'};
        
        Test.startTest();
        EmailHandlerUtilityPerMST.sendEmailPerMSTNoMaskLayer('Swift_No_Mask_Layer_For_Shipped_Mask_WIP',testMST.Name,listLayer);
        Test.stopTest();
    }
    
    public static testMethod void sendEmailPerMSTTest() {
        map<string,Schema.RecordTypeInfo> mapEmailConfigRecType = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName();
        Schema.RecordTypeInfo perMSTRecTypeInfo = mapEmailConfigRecType.get('MST');
        Id perMSTRecTypeId;
        if(perMSTRecTypeInfo!=null) {
            perMSTRecTypeId = perMSTRecTypeInfo.getRecordTypeId();
        }
        list<Email_Config_Settings__c> listTestEmailConfig = new list<Email_Config_Settings__c>();
        Email_Config_Settings__c emailConfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_Mask_Write_is_hold_due_to_unreleased_TECN',
                                                                                    RecordTypeId=perMSTRecTypeId,
                                                                                    Available_For_Use__c=true,
                                                                                    Tech_Geo_Value__c='0.01',
                                                                                    MPW_PTRF__c=true,
                                                                                    TO__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    CC__c='#Email:testCc@test.com#atp#fab#cjv#fjv#customergroup:Swift_Admin#ptrfsubmitter',
                                                                                    BCC__c='#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                    Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review',
                                                                                    Send_Mail_To_Customer_AS_Submitter__c=true,
                                                                                    Send_Mail_To_Customer__c=true);
        listTestEmailConfig.add(emailConfigObj);
        emailConfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_Device_Layer_s_had_been_released_shipped',
                                                                                    RecordTypeId=perMSTRecTypeId,
                                                                                    Available_For_Use__c=true,
                                                                                    Tech_Geo_Value__c='0.01',
                                                                                    MPW_PTRF__c=true,
                                                                                    TO__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    CC__c='#Email:testCc@test.com#atp#fab#cjv#fjv#customergroup:Swift_Admin#ptrfsubmitter',
                                                                                    BCC__c='#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                    Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review',
                                                                                    Send_Mail_To_Customer_AS_Submitter__c=true,
                                                                                    Send_Mail_To_Customer__c=true);
        listTestEmailConfig.add(emailConfigObj);                                                                    
        emailConfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_Resume_Mask_Write_for_Layer_Chip',
                                                                                    RecordTypeId=perMSTRecTypeId,
                                                                                    Available_For_Use__c=true,
                                                                                    Tech_Geo_Value__c='0.01',
                                                                                    MPW_PTRF__c=true,
                                                                                    TO__c='#User:testPerMST@mrs.com.test#email:testTo@test.com#group:Swift_Admin#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    CC__c='#Email:testCc@test.com#atp#fab#cjv#fjv#customergroup:Swift_Admin#ptrfsubmitter',
                                                                                    BCC__c='#atp#fab#cjv#fjv#customer#ptrfsubmitter',
                                                                                    Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                    Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review',
                                                                                    Send_Mail_To_Customer_AS_Submitter__c=true,
                                                                                    Send_Mail_To_Customer__c=true);
                                                                                    
        listTestEmailConfig.add(emailConfigObj);
        emailConfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_Hold_Mask_Write_for_Layer_Chip',
                                                                                    RecordTypeId=perMSTRecTypeId,
                                                                                    Available_For_Use__c=true,
                                                                                    Tech_Geo_Value__c='0.01',
                                                                                    MPW_PTRF__c=true,
                                                                                    Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                    Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review',
                                                                                    Send_Mail_To_Customer_AS_Submitter__c=true,
                                                                                    Send_Mail_To_Customer__c=true);
                                                                                    
        listTestEmailConfig.add(emailConfigObj);
        insert listTestEmailConfig;
        
        Test.startTest();
        list<MRS_Layer_Association__c> fetchedMRSLAList = [SELECT Id,Name,Mask_Layer_Rev__c,ROM_Code__c,LogicalOperation__c,Mask_Set_Title_Name__c,Tech_geo_int__c 
                                                                    FROM MRS_Layer_Association__c];
        // for template 1C mail is sent to TECN Originators
        EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Mask_Write_is_hold_due_to_unreleased_TECN',fetchedMRSLAList,'');
        // for template 7, PTRF number is passed as an additional parameter
        EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Device_Layer_s_had_been_released_shipped',fetchedMRSLAList,null,new set<string>{'PTRF-01-001'},'');
        // when mail is sent to RMG group, current user and peer customers
        // adding current user to RMG Group
        system.runAs(testAdminUserRunAs) {
            list<Group> rmgGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Swift_RMG'];
            if(rmgGroup!=null && !rmgGroup.isEmpty()) {
                Id currentUserId = (Id)UserInfo.getUserId();
                GroupMember testRMGGroupMember = new GroupMember(GroupId=rmgGroup.get(0).Id,UserOrGroupId=currentUserId);
                insert testRMGGroupMember;
            }
        }
        list<MRS_Layer_Chip_Association__c> fetchedMRSLCAList = [SELECT Id,Layer__c,Chip__r.Name,PTRF__c,PTRF__r.Fab__c,PTRF__r.Name,PTRF__r.Customer__c,PTRF__r.Submitter__c,
                                                                        PTRF__r.Submitter__r.isActive,PTRF__r.Submitter__r.Portal_Email__c
                                                                        FROM MRS_Layer_Chip_Association__c];
        EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Resume_Mask_Write_for_Layer_Chip',fetchedMRSLAList,fetchedMRSLCAList,'test comments');
        
        /** Negative tests **/
        EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Hold_Mask_Write_for_Layer_Chip',fetchedMRSLAList,fetchedMRSLCAList,'test comments');
        EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Mask_Write_is_hold_due_to_unreleased_TECN',null,'');
        EmailHandlerUtilityPerMST.sendEmailPerMST('',null,'');
        
        Test.stopTest();
    }
}