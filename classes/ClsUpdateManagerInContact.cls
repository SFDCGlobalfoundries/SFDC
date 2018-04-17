/*
Type Name: ClsUpdateManagerInContact
Author: Cognizant
Created Date: 11-May-2013
Reason: This class is used for Account manager in Contact. 
Change History:
Author: Cognizant
Modified Date: 01-sep-2015
Reason: Case#44223 :Populate Account owner field on contact. 
……..
……..
*/


public class ClsUpdateManagerInContact
{


/*--------------------------------------------------------------------------------------*/    
    public static void updateManager(List<Account> accList)

   {
   
    List<Contact> updateManagerList=new List<Contact>();
    List<Contact> updateCustomerPortalAdminList=new List<Contact>();
    
      Set<Id> accId=new Set<Id>();
     for(Account  accobj:accList)
     {
        accId.add(accobj.Id);
     }
     
     List<Contact> contList=[Select   id,
                                    Account_Manager__c,
                                    Account_Owner__c,
                                    Customer_Portal_Admin__c
                                    from Contact
                                    where AccountId in:accId];
                                    
  
     
      for(Account accObj:accList)
             {
             
              for(Contact contobj:contList)
                                          
              {
               if(accObj.Account_Manager__c !=null)
                         
                         {
                          contobj.Account_Manager__c =accObj.Account_Manager__c ;
                          updateManagerList.add(contobj);
                         
                         }
               if(accObj.ownerid !=null)
                         
                         {
                          contobj.Account_Owner__c =accObj.ownerid ;
                          updateManagerList.add(contobj);
                         
                         }
              if(accObj.Customer_Portal_Admin__c !=null)
                         
                         {
                          contobj.Customer_Portal_Admin__c =accObj.Customer_Portal_Admin__c ;
                          updateCustomerPortalAdminList.add(contobj);
                         
                         }
              }
      
         }
         
         try
          {
          update updateManagerList;
          update updateCustomerPortalAdminList;
         
          }
          catch(Exception e){
          system.debug('update list'+e);
          }
   }
 /*----------------------------------------------------------------------------------------*/ 
 }