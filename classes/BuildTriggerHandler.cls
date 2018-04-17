/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Trigger handler for Build trigger BuildTrigger
*   History: 
*   skarukon      09/22/2015    - Apex code created    
*/

public with sharing class BuildTriggerHandler {
    private static final String FREEZE_SUBJECT_PHRASE = 'Release freeze';
    private static final String PRODUCTION_SUBJECT_PHRASE = 'Production release';

    @InvocableMethod
    public static void createEventsInRMCalender(List<agf__ADM_Build__c> builds){
        List<Group> RMTeams = [SELECT DeveloperName,Id FROM Group where DeveloperName = 'RM_Team'];
        //IF team exists then
        List<Id> whatIdsToDelete = new List<Id>();
        if(RMTeams.size() > 0 ){
            Group grp = RMTeams[0];
            List<GroupMember> rmTeamMembers = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: RMTeams[0].Id];
            //If group contains members
            if(rmTeamMembers.size() > 0){
                List<Event> events = new List<Event>();
                for(agf__ADM_Build__c build: builds){
                    Event evt= new Event();
                    evt.OwnerId=UserInfo.getUserId();
                    if(build.Id != null){ evt.WhatId = build.Id; whatIdsToDelete.add(build.Id); } 
                    evt.StartDateTime = build.agf__Release_Freeze__c;
                    evt.IsAllDayEvent = true;
                    evt.Subject = FREEZE_SUBJECT_PHRASE + ' '+build.Name;
                    evt.Description = Label.Release_Freeze_Message;
                    events.add(evt);

                    Event evtProdDeploy= new Event();
                    evtProdDeploy.OwnerId=UserInfo.getUserId();
                    if(build.Id != null){ evtProdDeploy.WhatId = build.Id;}
                    evtProdDeploy.StartDateTime = build.Release_Date__c;
                    evtProdDeploy.IsAllDayEvent = true;
                    evtProdDeploy.Subject = PRODUCTION_SUBJECT_PHRASE+' '+build.Name;
                    evtProdDeploy.Description = Label.Release_Production_Message;
                    events.add(evtProdDeploy);
                }

                //Query Events
                if( whatIdsToDelete.size() > 0) { List<Event> eventsRelatedToBuildsWhichChanges = [SELECT Id, WhatId, StartDateTime, Subject 
                                                        FROM Event WHERE WhatId in :whatIdsToDelete 
                                                        ORDER BY WhatId asc, Subject asc];
                    if(!eventsRelatedToBuildsWhichChanges.isEmpty()) delete eventsRelatedToBuildsWhichChanges;
                }

                insert events;
                List<EventRelation> eventsRelations = new List<EventRelation>();
                for(Event evt: events){
                    for(GroupMember member: rmTeamMembers){
                        if(member.UserOrGroupId != UserInfo.getUserId()){
                            eventsRelations.add(new EventRelation(EventId=evt.Id, RelationId=member.UserOrGroupId));
                        }
                    }
                }
                insert eventsRelations;
            }
        }
    }
}