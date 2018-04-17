/*
Type Name: clsCommunityTCAcceptedUpdateOnContact
Company Name: Cognizant 
Created Date: 15-Oct-2014
Reason: Case 35076 -This Class is created to resolve the soql limit issue while creating community terms and condition record
Change History:
Author: Sunita Char
Modified Date: 
Reason: 
……..
……..
*/

public class clsCommunityTCAcceptedUpdateOnContact
{ 
  @future
     public static void updateCheckbox(Set<Id> contactId)
      {
      
      List<Contact> contactList=[select id,Accepted_TC_Version__c,Is_Comm_TC_Accepted__c from Contact where id In:contactId];
      List<Contact> contactUpdateList = new List<Contact>();
      try
       {
           if(contactList!=null && !(contactList.isEmpty()))
           {
              for(Contact cont: contactList)
              {
               cont.Is_Comm_TC_Accepted__c =false;
               contactUpdateList.add(cont);
              }
            }  
              
                   if(contactUpdateList!=null && !(contactUpdateList.isEmpty()))
                  {
                  update contactUpdateList;
                  }
        }
          catch(Exception e)
          {
           System.debug('An exception occurred: ' + e.getMessage());
          }
      }

}