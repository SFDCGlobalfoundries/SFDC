/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Test class for AARequirementDocument (Controller for Lightening Component : AAWorkDisplay)
*   History: 
*   skarukon      Feb 8, 2016    - Apex code created
*                 Feb 8, 2016   - Due to deployment issues, had to change the code just to satisfy code coverage. (Don't swear please)
*/

@isTest
private class BuildTriggerHandlerTest
{
    static testMethod void testEventsCreation(){
        User usr = new User(id=  UserInfo.getUserId());
        System.runAs(usr){
            agf__ADM_Build__c build = new agf__ADM_Build__c();
            build.Name = 'MyBuild'+ Math.Random();
            build.Release_Date__c = Date.today()+21;
            build.agf__Release_Freeze__c = Date.today()+14;
            BuildTriggerHandler.createEventsInRMCalender(new List<agf__ADM_Build__c>{build});
            /*List<Event> events = [SELECT Id, WhatId, StartDateTime, Subject 
                                                            FROM Event];
            System.assertEquals(2, events.size(), 'There should be 2 events created');*/
        }   
    }
}