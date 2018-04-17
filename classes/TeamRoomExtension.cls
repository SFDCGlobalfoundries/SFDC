/*
    Author: Art Contreras
    Description:
    History:
        ARoy    12022013    - Test method creation for TeamRoomExtension
*/
public with sharing class TeamRoomExtension 
{
    Team_Room__c teamRoom = null;
    
    public TeamRoomExtension(ApexPages.StandardController controller) 
    {
        this.teamRoom=(Team_Room__c)controller.getRecord();
      
    }
    
    @isTest(SeeAllData=true)
    public static void doTestStndCntrll(){
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
        TeamRoomExtension tmRmExt = new TeamRoomExtension (sc);
        System.assertEquals(tmRmExt.teamRoom, tmRm);
        test.stopTest();        
    }

}