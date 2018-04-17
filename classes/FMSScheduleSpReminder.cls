/*
 @class: FMSScheduleSpReminder 
 @CreatedBy: Ram Rai
 @CreatedDate: 11 Jul, 2017
 @Description: Schedule class to be scheduled every day to send reminder emails to reviewers
*/
public class FMSScheduleSpReminder implements schedulable{
    public void execute(SchedulableContext sc){
        FMSSPReminder spRem= new FMSSPReminder();
        database.executebatch(spRem);        
    }
}