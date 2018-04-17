/**
* @author       :   Sushumna Mulugu
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to Redirect to appropriate Team Room
*                   page based on the Record Type on Team room.
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        SMulugu         19/08/2013          Created the Class
**/

public with sharing class teamRoomRedirectController {

    Team_Room__c teamRoomObj { get; set; }
    Id preFVRecTypeId;


    /***********************************************************
    * Name              : teamRoomRedirectController
    * Description       : Constructor
    * Input Parameters  : StandardController
    * Return            : None
    ************************************************************/
    public teamRoomRedirectController(ApexPages.StandardController stdcontroller) {
        teamRoomObj    =  new Team_Room__c();
        teamRoomObj    = (Team_Room__c)stdController.getRecord();  
    }


    /***********************************************************
    * Name              : ToTeamRoom
    * Description       : Redirects the View of the Team Room
    *                     to the appropriate VF View.
    * Input Parameters  : None
    * Return            : pageReference
    ************************************************************/
    public pageReference ToTeamRoom () {

        SObject obj;
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Team_Room__c');
        obj = targetType.newSObject();

        /* Making use of the SObject Describe call to get the Team Room Object Details */
        Schema.DescribeSObjectResult rtDesc = obj.getSObjectType().getDescribe(); 

        /* Retrieving the Record Type Info for the Team Room Object */
        Map<String,Schema.RecordTypeInfo> rtMapByName = rtDesc.getRecordTypeInfosByName();

        if ( rtMapByName.keySet().contains('Pre FV2 Teamroom') &&
            teamRoomObj.recordTypeId == rtMapByName.get('Pre FV2 Teamroom').getRecordTypeId() ) {
            return (new PageReference('/apex/TeamRoom?id='+teamRoomObj.id));
        }
        else {
            return (new PageReference('/apex/VFTeamRoomDetail?id='+teamRoomObj.id));
        }
    }

}