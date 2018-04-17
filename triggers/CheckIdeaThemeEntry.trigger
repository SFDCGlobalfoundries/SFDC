// trigger to give error if Idea Theme is empty before posting, since page layout required setting is not doing that (Case to SFDC to be opened)
// Charles Derby, 2015-05-12
// debugged by Sunil Arora 2015-05-13
// updated error text to be more complete, 2015-08-27 

trigger CheckIdeaThemeEntry on Idea (before insert, after update)
 {
    for (Idea oIdea : trigger.new)
         {
         if (oIdea.IdeaThemeId== null) {        
         oIdea.adderror('Idea Theme is required. Please type the word "Ideas" in the Idea Theme field and then click on the search icon to the right of that field to get a current list of Idea Themes to choose from. This will also populate the picklist on the form.');
         }
         }
  }