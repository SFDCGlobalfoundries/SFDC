/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Description: This class is used as test  class for BatchAccTeamProxyFaeShare and BatchAccTeamProxySchedule.
    History: Harsha:22/12/16
**/ 
@isTest(SeeAllData = True)
private class BatchAccTeamProxyFaeShareTest {

    static testMethod void BatchAccTeamProxyFaeShareMethod() {
 Test.startTest();
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
            and developername like '%GLOBALFOUNDRIES%' Limit 1
        ];
        Account acc = new Account(
            name = 'TEST rec',
            recordtypeid = rt.id,
            stage__c = 'Qualified',
            short_name__c = 'TESTrec',
            sub_type__c = 'Direct',
            Approval_Request__c='Account Details Change',
            Fab_9_10__c='Yes',
            //Preferred_Invoice_Delivery_Option__c='Email PDF Copy',
            Invoice_Delivery_Email__c='test@gmail.com',
            site_department__c = 'test dept',
            transaction_type__c = 'Transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
            Bill_To_Address_1__c = '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c = 'Lee',
            Corporate_Country__c = 'Japan',
            Bill_To_Country__c = 'Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c = '',
            Target_Account__c = 'Yes',
            siebel_account_id__c = '1111'
        );

        insert acc;
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
            AND isActive = true
        ].get(0);
        System.runAs(sysAdminUser) {
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];

            User userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
                emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
                localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');

            insert userSU;


            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSU.id, Account__c = acc.Id, Account_Access__c = 'Read/Write',
                Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Field Application Engineer', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;

           


            List < Wavier_Collaborator__c > waiverCollList = new List < Wavier_Collaborator__c > ();
            Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator(userSU.FederationIdentifier, userSU.FederationIdentifier, acc.Id);
            waiverCollList.add(waiverColl);


            BatchAccTeamProxyFaeShare batchObj = new BatchAccTeamProxyFaeShare();
            ID batchprocessid = Database.executeBatch(batchObj);
            System.abortJob(batchprocessid);

            batchObj.start(null);
            batchObj.execute(null, waiverCollList);
            batchObj.finish(null);

            Test.stopTest();
        
        }
    }
       
    
    static testMethod void myAutoSchMethod1() {

        String sch = '0 0 09 * * ?';

        Test.startTest();

        BatchAccTeamProxySchedule m = new BatchAccTeamProxySchedule();
        String jobID = system.schedule('Email Job1', sch, m);

        Test.stopTest();
    }
}