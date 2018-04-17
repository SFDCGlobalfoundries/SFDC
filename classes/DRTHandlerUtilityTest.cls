/*
    Author: Cognizant
    Description: Apex test class for DRTHandlerUtility class
    History: 
    Debasish      05/05/2014    - Apex code created
*/
@istest(SeeAllData=false)
public class DRTHandlerUtilityTest {

	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
	
 /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchCustomerName()
 */     
@isTest
    public static void fetchCustomerNameTest(){
        
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User u1, u2;
        
        System.runAs ( thisUser ) {
            Id sysAdminProfileId,feProfileId;
            for(Profile p: [SELECT Id,Name FROM Profile WHERE Name in ('System Administrator','GF FAE/FTS')]) {
                if(p.Name == 'System Administrator') {
                    sysAdminProfileId = p.Id;
                }
                else {
                    feProfileId = p.Id;
                }
            }
            
            u1 = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfileId,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u1;
        }
        
        test.startTest();
        System.runAs(u1) {
            list<Account> accountList=new DRTHandlerUtility().fetchCustomerName();
            system.assert(accountList != null);
        }
        test.stopTest();
    }
    
    
 /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchMSTList()
 */        
   @isTest
    public static void fetchMSTListTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        
        User u2;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            u2 = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u2;
            
            Group testGroup = new Group();
            testGroup.Name = 'Swift_GlobalShuttle';
            testGroup.DeveloperName = 'testDeveloperName';
            insert testGroup;
            
            GroupMember GM = new GroupMember();
            GM.GroupId = testGroup.id;
            GM.UserOrGroupId = u2.Id;
            insert GM;   
        }
        System.RunAs(u2){
        
            list<Mask_Set_Title__c> mstList1=new DRTHandlerUtility().fetchMSTList(acc.Id);
            system.assertEquals(1,mstList1.size());
            system.assertEquals(mstList[0].Name,mstList1[0].Name);
            test.stopTest();
       }                                                            
    }
    
   /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchTechGeoList()
 */  
    @isTest
    public static void fetchTechGeoListTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drtList[0].Id,ptrf.Id);
        
        set<String> setTechGeo=DRTHandlerUtility.fetchTechGeoList(mstList[0].Id,drtList[0].Type__c);
        system.assertNotEquals(setTechGeo.size(), 0);
        String techGeo = (new list<string>(setTechGeo))[0];
        system.assertEquals(techGeo, '0.02UM (20nm)');
        
        DRT__c drt1=drtList[0];
        drt1.Type__c = 'frame';
        drt1.Tech_Geo__c = '0.02UM';
        update drt1;
        
        ptrf.Frame_Tapeout__c=true;
        ptrf.Prime_Tapeout__c=false;
        update ptrf;
        
        User u;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            u = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            Insert u;
            
            List<Group> ListOfGroups = [select Id, DeveloperName, Name from Group where Name like 'Swift%']; //createGroups();
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
            }
            insert GM; 
        }
        System.RunAs(u){
            set<String> setTechGeo2=DRTHandlerUtility.fetchTechGeoList(mstList[0].Id,drt1.Type__c);
            system.assertNotEquals(setTechGeo2.size(), 0);
            String techGeo2 = (new list<string>(setTechGeo2))[0];
            system.assertEquals(techGeo2, '');
        } 
        test.stopTest();
    }
    
   /*
   This test method tests the below functionality of the class DRTHandlerUtility
   fetchChipDetails()
 */   
   @isTest
    public static void fetchChipDetailsTest(){
        // comment-out, refactor with testSetup method setup()
		// SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        Chip_Detail__c chip_detail = SwiftDataUtilityTest.createChipDetailDRT(ptrf.Id);
        
        list<Chip_Detail__c> cdList=DRTHandlerUtility.fetchChipDetails(mstList[0].Id,ptrf.Tech_Geo__c);
        system.assertEquals(1,cdList.size());
        system.assertEquals(chip_detail.Name,cdList[0].Name);
        list<Chip_Detail__c> cdList1=DRTHandlerUtility.fetchChipDetails('',ptrf.Tech_Geo__c);
        system.assertEquals(0,cdList1.size());
        test.stopTest();
    }
    
   
  
}