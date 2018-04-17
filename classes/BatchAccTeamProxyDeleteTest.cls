/*
    Author: Cognizant
    Description: Apex test class for BatchAccTeamProxyDelete
    History: 
*/
@istest(SeeAllData=false)
public class BatchAccTeamProxyDeleteTest {
    public static testmethod void emailsentForGDSOUTReview(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
                                emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = sysAdminProfile.Id,
                                timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        User userSAccounTeamproxy = new User(alias = 'testMRS', email='testMRS@test.com',
                                emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = sysAdminProfile.Id,
                                timezonesidkey='America/Los_Angeles', username='testMRS1@test.com',communitynickname='testMRS1');
        insert userSAccounTeamproxy ;
        System.runAs(sysAdminUser){
         SwiftDataUtilityTest.customSystemData();
         Account acc = SwiftDataUtilityTest.createTestAccount();
         
         
         
         //Device__c deviceObject = new Device__c()
         Test.startTest();
        /* Opportunity oppObject = new Opportunity(Name = 'Opp1',AccountId = acc.Id,CloseDate = system.today(),StageName = '2. Assessment',Market_Segment__c='Automotive',Production_Confidence__c='30%',Target_Process_Node__c='10XM',Process_Platform__c='GF Baseline',Opportunity_Health__c='Minor Challenges',Opportunity_Sourcing_Type__c='Second Source',End_Application_for_Opty__c='Cell Handset',Fab_Split__c=100,Fab_Assignment_1__c ='FAB 1',Process_Family__c ='Super Low Power',Process_Geometry__c ='0.010UM');
         insert oppObject ;
         oppObject.StageName = '7. Revenue' ;
         update oppObject;
         List<Opportunity_Program__c> oppProgramLst = [Select Id FROM Opportunity_Program__c WHERE Opportunity__c =:oppObject.Id ];
         system.debug('$$$$$oppProgramLst $$'+oppProgramLst );*/
         Mask_Set_Title__c objMST = MRSDataUtilityTest.createMST();
            
            Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
            Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id,oppr.Id);
            Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
            
            Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id,oppr.Id,opprProg.Id,pt.Id);
            
            Opportunity_Program_Team_Member__c oppTeamMem = new Opportunity_Program_Team_Member__c();
            oppTeamMem.Opportunity_Program__c = opprProg.Id;
            oppTeamMem.User__c = userSA.Id;
            oppTeamMem.Team_Role__c= 'Pricing';
            oppTeamMem.Opportunity_Program_Access__c = 'Read Only';
            oppTeamMem.Device_Access__c = 'Read Only';
            insert oppTeamMem;
            
            List<PTRF__c> ptrfList = new List<PTRF__c>();
            PTRF__c PTRFobj = new PTRF__c();
            PTRFobj.Name = 'PTRF 2';
            PTRFobj.Order_Type__c = 'Test Order Type';
            PTRFobj.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj.MaskSetTitle__c = objMST.Id;
            PTRFobj.tech_Geo_Value__c = '0.019UM';
            PTRFobj.Device__c = testDevice.Id;
             insert PTRFobj ;
          
         System.assertEquals('PTRF 2',PTRFobj.Name);
         PTRF__Share ptrfShareObject = new PTRF__Share(ParentId = PTRFobj.Id,RowCause ='Manual',UserOrGroupId = userSA.Id,AccessLevel ='Read');
         insert ptrfShareObject ;
         BatchAccTeamProxyDelete  batchTeamObject = new BatchAccTeamProxyDelete();
         ID batchprocessid = Database.executeBatch(batchTeamObject); 
         Test.stopTest();
          
        }
    }
    
}