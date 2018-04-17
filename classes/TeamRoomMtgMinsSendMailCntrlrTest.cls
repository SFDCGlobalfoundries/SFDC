/*
    Author: Anirban Roy
    Description: Test class for TeamRoomMeetingMinutesSendMailController
    History:
        ARoy        12022013    - Code Creation.
        Nbustillos  12152013    - Added first name for contact creation.    
*/
@isTest(SeeAllData=false)
public class TeamRoomMtgMinsSendMailCntrlrTest
{

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
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Tech_Geo_Granted__c','0.11UM;0.13UM;');
        fieldValueMap.put('Valid_Tech_Geos__c','0.11UM; 0.13UM;');
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void doTestTmRmMtngMinSendMail(){
        test.startTest();
        Account accntObj1 = getAccount('Test Account 009');
        
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 008',
                                    Team_Room_Description__c = 'Meeting Team Room1',Primary_Account__c=accntObj1.id);
        insert tmRm;
        
        //Without Contact1__c Information
        Team_Room_Meeting_Minutes__c tmRmMtMnt = new Team_Room_Meeting_Minutes__c();       
        tmRmMtMnt.Team_Room__c = tmRm.id;
        tmRmMtMnt.Meeting_Date__c = Date.valueOf('2013-12-01');
        tmRmMtMnt.Meeting_Type__c = 'Weekly';
        insert tmRmMtMnt;
        
        Group grp = new Group(Name='GlobalFoundries Group', Type = 'Regular');
        insert grp;
        
        Team_Room_Member__c tmRmMem = new Team_Room_Member__c();
        tmRmMem.Group_Id__c = grp.id;
        tmRmMem.Group_Selected__c=true;
        tmRmMem.Is_Group__c = true;
        tmRmMem.Team_Room__c = tmRm.id; 
        tmRmMem.Access__c = 'Read/Write';
        insert tmRmMem;
        
        
        
        ApexPages.currentPage().getParameters().put('id',tmRmMtMnt.id);
        
        TeamRoomMeetingMinutesSendMailController tmRoomMetMinSendMail 
                                        = new TeamRoomMeetingMinutesSendMailController();
        EmailTemplate emailTemp = new EmailTemplate(Name='Testing Template for Meeting Minutes'); 
                
        //Calling the sendMail function
        //PageReference pgRef = tmRoomMetMinSendMail.sendMail();
        
        //With a contact1 information
        
        Contact cn = new Contact();
        cn.FirstName = 'FirstName';
        cn.LastName = 'LastName';
        cn.AccountId = accntObj1.id;
        cn.Email = 'test@test.com';
        cn.Department__c = 'TestDepartment';
        
        insert cn;
        
        Team_Room_Meeting_Minutes__c tmRmMtMnt1 = new Team_Room_Meeting_Minutes__c();       
        tmRmMtMnt1.Team_Room__c = tmRm.id;
        tmRmMtMnt1.Meeting_Date__c = Date.valueOf('2013-11-01');
        tmRmMtMnt1.Meeting_Type__c = 'Monthly';       
        tmRmMtMnt1.ToContact1__c = cn.id;
        insert tmRmMtMnt1;
        
        ApexPages.currentPage().getParameters().put('id',tmRmMtMnt1.id);
        
        PageReference pgRef = tmRoomMetMinSendMail.sendMail();
        test.stopTest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }
}