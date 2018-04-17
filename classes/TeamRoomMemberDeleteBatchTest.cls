@isTest(SeeAllData=true)
public class TeamRoomMemberDeleteBatchTest {

static testMethod void testTeamRoomMemberDeleteBatch() {
         test.startTest();
           // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account13';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct13';
        
        insert testAcct;
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 007',Team_Room_Description__c = 'Meeting Team Room',Primary_Account__c=testAcct.id);
        insert tmRm;
        
        User[] usrLst=[Select Id from User where IsActive=:false limit 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tmRm);
        TeamRoomMembersControllerExt tmRmMemCntrlrExt = new TeamRoomMembersControllerExt(sc);
        Team_Room__c tmRms = tmRmMemCntrlrExt.getTeamRoom();
        System.assert(tmRms!=null);
        
        Team_Room_Member__c tmRmMem1 = new Team_Room_Member__c();
        tmRmMem1.User__c = usrLst[0].Id;
        tmRmMem1.Group_Selected__c=false;
        tmRmMem1.Is_Group__c = false;
        tmRmMem1.Team_Room__c = tmRm.id; 
        tmRmMem1.Access__c = 'Read/Write';
        insert tmRmMem1;
        //Database.executeBatch(new TeamRoomMemberDeleteBatch(), 1);
                    
         TeamRoomMemberDeleteBatchScheduler scheduler = new TeamRoomMemberDeleteBatchScheduler();
            String sch = '0 0 23 * * ?'; 
            System.schedule('TeamRoomMemberDelete' + sch, sch, scheduler); 
        test.stopTest();
        
        
    }

}