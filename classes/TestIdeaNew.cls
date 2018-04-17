@IsTest
public class TestIdeaNew {
static testMethod void IdeaCreator(){
IdeaTheme iTheme=new IdeaTheme();
iTheme.Title='Title';
iTheme.Description='Description';
iTheme.CommunityId='09a90000000a6MNAAY';
insert iTheme;
Idea idee = new Idea();
idee.CommunityId='09a90000000a6MNAAY';
idee.IdeaThemeId=iTheme.Id;
idee.Categories='New Feature';
idee.Body='Description';
idee.Title = 'Dummy';
insert idee;
update idee;
}}