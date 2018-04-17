global class MRSReviewerNotificationSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      final Integer BATCH_SIZE = 2000;
      MRSReviewerNotifications reviewerNotification = new MRSReviewerNotifications(); 
      database.executebatch(reviewerNotification,BATCH_SIZE);
   }
}