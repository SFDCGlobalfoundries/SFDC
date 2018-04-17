public interface GFCalActivityProvider
{

   /**
   * Returns the activity types supported by this provider.
   **/
   List<GFCalActivityType> getActivityTypes();
   
   /**
   * Returns all the activities found by provider for the owning salesforce object.
   * @param id - the id of the owning salesforce object.
   **/
   List<GFCalActivity> findActivities(String id);


}