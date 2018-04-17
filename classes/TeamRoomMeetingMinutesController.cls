/*
    Author: Art Contreras
    Description: 
    History:
        ARoy     12022013    - Tes method creation for TeamRoomMeetingMinutesController
    */
public class TeamRoomMeetingMinutesController 
{
    Team_Room_Meeting_Minutes__c meetingMinutes = null;
    
    public Team_Room_Meeting_Minutes__c getMeetingMinutes()
    {
        if(meetingMinutes == null)
        {
           String id =  ApexPages.currentPage().getParameters().get('id');
           List<Team_Room_Meeting_Minutes__c> mmList = [SELECT Id, Name,CreatedBy.Name, LastModifiedBy.Name, Meeting_Date__c, Meeting_Type__c, Meeting_Notes__c, Meeting_Participants__c, Status__c,
            Team_Room__r.Id, Team_Room__r.Name from Team_Room_Meeting_Minutes__c where id = :id LIMIT 1];
           if(mmList.size() == 1)
           {
              meetingMinutes = mmList.get(0);
           }
        }
        
        return meetingMinutes;
    }
    
    @isTest(SeeAllData=true)
    public static void doTestTeamRoomMtgMinCntrlr(){
        test.startTest();
        Account accntObj1 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria', Short_Name__c = 'testplm2',
                              Has_Valid_NDA__c =true,Tech_Geo_Granted__c='0.11UM;0.13UM;', Valid_Tech_Geos__c='0.11UM; 0.13UM;'
                              );
                              
          insert accntObj1;
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 008',Team_Room_Description__c = 'Meeting Team Room1',Primary_Account__c=accntObj1.id);
        insert tmRm;
        Team_Room_Meeting_Minutes__c tmRmMtMnt = new Team_Room_Meeting_Minutes__c();       
        tmRmMtMnt.Team_Room__c = tmRm.id;
        tmRmMtMnt.Meeting_Date__c = Date.valueOf('2013-12-01');
        tmRmMtMnt.Meeting_Type__c = 'Weekly';
        insert tmRmMtMnt;
        TeamRoomMeetingMinutesController tmRmMetMinCntrlr = new TeamRoomMeetingMinutesController();
        ApexPages.currentPage().getParameters().put('id',tmRmMtMnt.id);
        Team_Room_Meeting_Minutes__c teamRoomMetMin = tmRmMetMinCntrlr.getMeetingMinutes();
        System.assert(teamRoomMetMin!=null); 
        test.stopTest();      
    }

}