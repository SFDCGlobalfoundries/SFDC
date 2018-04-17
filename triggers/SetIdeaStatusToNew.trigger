// trigger to set status to new since default setting is not doing that (Case to SFDC to be opened)
// Charles Derby, 2015-05-03
//
trigger SetIdeaStatusToNew on Idea (before insert)
 {
    for (Idea oIdea : trigger.new)
         {
         oIdea.Status = 'New';
         }
 }