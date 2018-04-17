/*
    Author:         Ankit Singhal
    Description:    Trigger created for deleting Raw CE Files Documents on corresponding
                    Team Room Meeting Minutes Deletion.
    History:

    Initials        Date                Description
-----------------------------------------------------------------------------------------
    ASinghal        19082013            - Created

*/
trigger TeamRoomMeetingMinutes on Team_Room_Meeting_Minutes__c (after delete) {

    /* Consturcting the name format of the files to be deleted */
    Decimal workweek;
    Date todaydate = date.today(); 
    public List<Document> deldocuments;    
    Integer currentyear = todaydate.year();

    for ( Team_Room_Meeting_Minutes__c temp : trigger.old ) {
        try {
            String matchstring  =   currentyear+'-'+temp.Work_Week__c+'-';
            String folderid     =   [Select Id from Folder where DeveloperName='Raw_CE_Files' limit 1].Id;
            deldocuments        =   [Select Id,DeveloperName from Document where folderid=:folderid and name like :(matchstring+'%')];
            if ( ! (deldocuments.isempty() ) ) {
                delete deldocuments;
            }
        }
        catch ( exception ex ) {
            temp.addError(ex);
        }
    }
}