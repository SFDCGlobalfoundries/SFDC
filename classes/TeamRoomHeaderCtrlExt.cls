/*
    Author: Art Contreras
    Description: 
    History:
        ARoy        12022013    - Test method creation for TeamRoomHeaderCtrlExt.
    */
public class TeamRoomHeaderCtrlExt
{
   ApexPages.StandardController std = null;
   public TeamRoomHeaderCtrlExt(ApexPages.StandardController std)
   {
       this.std = std;
   }

   public PageReference Follow()
   {   
       Team_Room__c tr = (Team_Room__c)std.getRecord();
       if(tr != null)
       {
           EntitySubscription follow = new EntitySubscription (
                                    parentId = tr.Id,
                                    subscriberid = UserInfo.getUserId()); 
           insert follow;
       }
       return null;
   }
   
    @isTest(SeeAllData=true)
    public static void doTestTeamRoomExtCntrlr(){
        test.startTest();
        Account accntObj1 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria', Short_Name__c = 'testplm2',
                              Has_Valid_NDA__c =true,Tech_Geo_Granted__c='0.11UM;0.13UM;', Valid_Tech_Geos__c='0.11UM; 0.13UM;'
                              );
                              
          insert accntObj1;
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 007',Team_Room_Description__c = 'Meeting Team Room',Primary_Account__c=accntObj1.id);
        insert tmRm;
        ApexPages.StandardController sc = new ApexPages.StandardController(tmRm); 
        TeamRoomHeaderCtrlExt tmRmExt = new TeamRoomHeaderCtrlExt(sc);
        PageReference pgRef =  tmRmExt.Follow();
        System.assert(pgRef == null);
        test.stopTest();       
    }


}