@isTest
public class AccessSetupHistoryTrackerTest {
    public static testMethod void AccessSetupHistoryMethod(){
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        System.runAs(ur){
            List<Error_Codes__c> lstError = new List<Error_Codes__c>();
            Error_Codes__c e = new Error_Codes__c();
            e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
            e.Message__c = 'test message';
            lstError.add(e);
            Error_Codes__c e1 = new Error_Codes__c();
            e1.Name = 'ACCT_TM_DUP_USER_ROLE_ERROR';
            e1.Message__c = 'test message';
            lstError.add(e1);
            Error_Codes__c e2 = new Error_Codes__c();
            e2.Name = 'ATP_INTEGRATION_SEQUENCE_ERROR';
            e2.Message__c = 'test message';
            lstError.add(e2);
            Error_Codes__c e3 = new Error_Codes__c();
            e3.Name = 'ATP_FLAG_FOR_DELETE_UPDATE_ERROR';
            e3.Message__c = 'test message';
            lstError.add(e3);
            Error_Codes__c e4 = new Error_Codes__c();
            e4.Name = 'ATP_FLAG_FOR_DELETE_CREATION_ERROR';
            e4.Message__c = 'test message';
            lstError.add(e4);
            insert lstError;
            
            List<Environment_Variable__c> lstVar = new List<Environment_Variable__c>();
            Environment_Variable__c v = new Environment_Variable__c();
            v.Name = 'DEVICE_STATUS_ACTIVE';
            v.value__c = 'test message';
            lstVar.add(v);
            Environment_Variable__c v1 = new Environment_Variable__c();
            v1.Name = 'ACT_TM_PRXY_TM_RL_CE';
            v1.value__c = 'test message';
            lstVar.add(v1);
            Environment_Variable__c v2 = new Environment_Variable__c();
            v2.Name = 'ACCT_TM_PRXY_TM_RL_FP';
            v2.value__c = 'test message';
            lstVar.add(v2);
            Environment_Variable__c v3 = new Environment_Variable__c();
            v3.Name = 'ACCT_TM_PRXY_TM_RL_AM';
            v3.value__c = 'test message';
            lstVar.add(v3);
            Environment_Variable__c v4 = new Environment_Variable__c();
            v4.Name = 'ACCT_TM_PRXY_TM_RL_TS';
            v4.value__c = 'test message';
            lstVar.add(v4);
            Environment_Variable__c v5 = new Environment_Variable__c();
            v5.Name = 'ACCT_TM_PRXY_TM_RL_AE';
            v5.value__c = 'test message';
            lstVar.add(v5);
            Environment_Variable__c v6 = new Environment_Variable__c();
            v6.Name = 'ACCT_TM_PRXY_TM_RL_CSR';
            v6.value__c = 'test message';
            lstVar.add(v6);
            Environment_Variable__c v7 = new Environment_Variable__c();
            v7.Name = 'GF_INTEGRATION_PROFILE_ID';
            v7.value__c = 'test message';
            lstVar.add(v7);
            Environment_Variable__c v8 = new Environment_Variable__c();
            v8.Name = 'ACCT_TM_PRXY_TM_RL_PCSR';
            v8.value__c = 'test message';
            lstVar.add(v8);
            Environment_Variable__c v9 = new Environment_Variable__c();
            v9.Name = 'ACCT_TM_PRXY_TM_RL_PAM';
            v9.value__c = 'test message';
            lstVar.add(v9);
            Environment_Variable__c v10 = new Environment_Variable__c();
            v10.Name = 'ACCT_TM_PRXY_TM_RL_AA';
            v10.value__c = 'test message';
            lstVar.add(v10);
            Environment_Variable__c v11 = new Environment_Variable__c();
            v11.Name = 'ACCT_TM_PRXY_TM_RL_PFTS';
            v11.value__c = 'test message';
            lstVar.add(v11);
            Environment_Variable__c v12 = new Environment_Variable__c();
            v12.Name = 'ACCT_TM_PRXY_TM_RL_PFAE';
            v12.value__c = 'test message';
            lstVar.add(v12);
            
            insert lstVar;
            //Inserting custom setting data
            Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
            bl.Name='Update Bill To Address No';
            bl.Bill_To_Address_Number__c = 2072;
            insert bl;
                        
            Account acc = new Account(
                name = 'TEST rec1205',
                stage__c = 'Active',
                short_name__c = 'TESTrec1205',
                sub_type__c= 'Direct',
                site_department__c = 'test dept1205',
                transaction_type__c = 'transactional',
                Process_Tech_Interested__c = 'Mature (> 0.11um)',
                region__c = 'APJ',
                Copy_Address__c = true,
                Corporate_Address_1__c = '50 water st',
                Corporate_City__c = 'Lee',
                Corporate_State__c = 'San Jose',
                Corporate_Country__c = 'USA',
                Organization_Unit__c = 'GF Investment LLC OU',
                bill_to_location__c = 'YES',
                total_employee__c = 100,
                end_customer__c = 'people',
                Revenue_Potential__c = 'High Potential',
                Target_Account__c = 'Yes'
            );
            insert acc; 
                    
            Contact con = new Contact(
                LastName = 'WayneSSSAccess',
                FirstName = 'BruceD',
                AccountId = acc.Id,
                Email = 'accesssetuphistorytrackertest@testMethod.com',
                Department__c = 'Design'
            );
            insert con;
            
            List<Schema.FieldSetMember> trackedFields = SObjectType.Portal_Tab_Access__c.FieldSets.HistoryTracking.getFields();
            
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            system.debug('portalRole is ' + portalRole);
            
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Profile'];
            User portalAccountOwner1 = new User(ProfileId = profile1.Id );
            //portalAccountOwner1.UserRoleId = portalRole.Id;
            
            portalAccountOwner1.Username = 'accesssetuphistorytrackertest@test.com';
            portalAccountOwner1.Alias = 'batman';
            portalAccountOwner1.Email= 'accesssetuphistorytrackertest@testMethod.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='BruceD';
            portalAccountOwner1.Lastname='WayneSSSAccess';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            portalAccountOwner1.ContactId = con.Id;
            Database.insert(portalAccountOwner1);
            
            //Commented to fix the test class failure
            //Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c =acc.Id, User__c = portalAccountOwner1.Id, Contact__c = con.Id );
            Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c =acc.Id);
            insert pta; 
            pta.User__c = portalAccountOwner1.Id;
            pta.Contact__c = con.Id;
            update pta;
        }  
    }
}