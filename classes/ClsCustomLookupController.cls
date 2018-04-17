/*
Type Name: ClsCustomLookupController
Author: Cognizant 
Created Date: 25-Nov-2013
Reason: This class is used creating custom look up for external users.
Change History:
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
……..……..
……..
*/

public class ClsCustomLookupController{

public string searchText{get;set;}
public String FormTag {get;set;}
Public String UserTextBox {get;set;}
public List<clsuser> Totaluserlist{get;set;}

public with sharing class clsuser
{   
    public id UserID {get;set;} //need to pass id to the source page
    public string UserName{get;set;}
    public string UserRole{get;set;}
    public string UserProfile{get;set;}
    public string UserTitle{get;set;}
    public string UserManager{get;set;}
    public string HCMEmployee{get;set;}
}


User objuser=new User();

public ClsCustomLookupController(){
    FormTag = System.currentPageReference().getParameters().get('frm');
    UserTextBox = System.currentPageReference().getParameters().get('pids');
}


public pagereference search()
{
  Totaluserlist=new List<clsuser>();
  //system.debug('searchTextr$$$'+searchText);
  objuser=[Select Id,Name,Profile.Name,Contact.accountId from user where Id=:userinfo.getuserId()];
  Id useraccountId =objuser.Contact.accountId ;

 // system.debug('objuser$$$'+objuser);
  List<User> userlist =new List<User>();
    //userlist=Database.query('Select Id,name,UserRole.name,Title,Profile.Name,IsActive,AccountId,Manager.Name,View_HCM_Employee__c,HCM_Record_ID__c  from User where AccountId =:useraccountId and IsActive=true order by name');
     
     
      userlist=Database.query('Select Id,name,Contact_Created_In_Open_Text__c,UserRole.name,Title,Profile.Name,IsActive,AccountId,Manager.Name,View_HCM_Employee__c,HCM_Record_ID__c  from User where Name Like \'%'+searchText+'%\' and AccountId =:useraccountId and IsActive=true and Contact_Created_In_Open_Text__c=true order by name');//modified by cognizant  for the Case 00004324
     // system.debug('external userlist ****'+userlist);
          for(User user1:userlist)
          {
          clsuser u=new clsuser();
          u.UserId = user1.id;
          u.UserName =user1.name;
          u.UserRole =user1.UserRole.Name;
          u.UserProfile=user1.Profile.Name;
          u.UserTitle=user1.Title;
          u.UserManager=user1.Manager.name;
          
          Totaluserlist.add(u);
          }
     
    
   return null;
  }
  

}