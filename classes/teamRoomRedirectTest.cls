@isTest(SeeAllData=False)
private class teamRoomRedirectTest {

@testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
    
            AccountDataFactory.createAccount(fieldValueMap);
        }

    static testMethod void teamRoomRedirect() {

            Id preFVRecTypeId = [ SELECT Id FROM RecordType WHERE Name = 'Pre FV2 Teamroom'].id;
            Account accntObj1= getAccount('MYTEST ACCOUNT');
                              
          
            Team_Room__c teamRoom =  new Team_Room__c ( recordTypeId = preFVRecTypeId ,
                                                        Name='Test Team Room 1',
                                                        Team_Room_Description__c = 'Test Team Room 1',Primary_Account__c=accntObj1.id );
            insert(teamRoom);

            ApexPages.StandardController nonFV =  new ApexPages.StandardController(teamRoom);
            teamRoomRedirectController teamRoomVar =  new teamRoomRedirectController (nonFV);
            teamRoomVar.ToTeamRoom();

    }


    static testMethod void teamRoomRedirectFV() {
        Id FVRecTypeId    = [ SELECT Id FROM RecordType WHERE Name != 'Pre FV2 Teamroom' and sObjecttype = 'Team_Room__c' limit 1].id;
        Account accntObj1= getAccount('MYTEST ACCOUNT');
        
        Team_Room__c teamRoomFV =  new Team_Room__c ( recordTypeId = FVRecTypeId ,
                                                    Name='Test Team Room 2',
                                                    Team_Room_Description__c = 'Test Team Room 2' ,Primary_Account__c=accntObj1.id);
        insert(teamRoomFV);

        ApexPages.StandardController FV =  new ApexPages.StandardController(teamRoomFV);
        teamRoomRedirectController teamRoomVarFV =  new teamRoomRedirectController (FV);
        teamRoomVarFV.ToTeamRoom();

    }

    static testMethod void teamRoomRedirectNull() {
            Account accntObj1= getAccount('MYTEST ACCOUNT');
            
            Team_Room__c teamRoom =  new Team_Room__c ( Name='Test Team Room 1',
                                                        Team_Room_Description__c = 'Test Team Room 1',Primary_Account__c=accntObj1.id );
            insert(teamRoom);

            ApexPages.StandardController nonFV =  new ApexPages.StandardController(teamRoom);
            teamRoomRedirectController teamRoomVar =  new teamRoomRedirectController (nonFV);
            teamRoomVar.ToTeamRoom();

    }
    
     private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }

}