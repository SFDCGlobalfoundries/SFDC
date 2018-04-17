/**
* @author       :   Sushumna Mulugu
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Test class for the TeamRoomMeetingMinutes Trigger.
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        SMulugu         23/08/2013          Created the Class
**/
@isTest(seeAllData = false)
private class teamRoomMeetingTriggerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void testTeamRoomMeetingTrigger() {
    //         try {
           Account accntObj1 = getAccount('Test Account 009');

           
           Team_Room__c troom = new Team_Room__c(Name = Label.CEWeekly_Team_Room,Team_Room_Description__c = 'TEAM ROOM TEST',Primary_Account__c=accntObj1.id);
            insert(troom);

            Team_Room__c insTeamRoom = [ SELECT Id FROM Team_Room__c WHERE Name = :Label.CEWeekly_Team_Room LIMIT 1 ];
            Team_Room_Meeting_Minutes__c tRoomMeetMins = new Team_Room_Meeting_Minutes__c();

            Date todaydate = date.today();
            Date todaydateinstance = date.newinstance(todaydate.year(), todaydate.month(), todaydate.day());
            Integer currentyear = todaydate.year();
            Integer currentmonth = todaydate.month();
            Integer currentday = todaydate.day();
            Date startDate = date.newinstance(currentyear, 01, 01);
            integer numberDaysDue = startDate.daysBetween(todaydateinstance);
            Integer numberOfWeek = Math.MOD(Integer.valueOf(math.FLOOR((numberDaysDue )/7)),52)+1;

            tRoomMeetMins.Team_Room__c = insTeamRoom.Id;
            tRoomMeetMins.Status__c = 'Open';
            tRoomMeetMins.Meeting_Type__c = 'Weekly';
            tRoomMeetMins.Meeting_Date__c = todaydate;

            insert tRoomMeetMins;

            Folder folder = [SELECT Id FROM Folder WHERE DeveloperName = 'Raw_CE_Files'];
            Document document;
            Blob body;
            body = Blob.valueOf('Missing Text');
            document = ManualDeviceHelper.createDocument(folder.Id, body);
            document.Name =currentyear+'-'+numberofweek+'-'+'CE Weekly Report Week:' + numberOfWeek + '.xls';

            insert document;
            delete(tRoomMeetmins);
     //   }
       // catch(DMLException e) {
        //    System.debug('Exception encountered in inserting Document is ' + e.getMessage());
        //} 
    } 
    
    private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }
}