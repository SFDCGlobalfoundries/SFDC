/*
Type Name: ClsApprovalChangeRequest
Author: Cognizant
Created Date: 19-April-2013
Reason: This class is used for updating the account with the change request values
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsApprovalChangeRequest{


  /**
        This method updates the Account recordwith the new values of the change request fields after the approval process by 
        checking the Is_change_request_update__c==true and
        if the change request fields are not eual to null
        @method name: checkIschangeRequestUpdate
        @parameter:   Map of account.
        @return :     none
    **/
    

  public static void checkIschangeRequestUpdate(Map<Id,Account> accountsMap)
  {
    List<Account> accountList = new List<Account>();   
    List<Account> updaccountList = new List<Account>();           
    accountList=accountsMap.values();
    System.debug('AcctList--------->'+accountList);
    for(Account objAccount:accountList)
    {
      
        
        
        //checking id the field  Is_change_request_update__c==true for updating the change request fields
        if(objAccount.Is_change_request_update__c==true)
        {
             //Updating the fields which have been requested for change in the change request
             if(objAccount.Founded_Change_Request__c != null){objAccount.Founded__c = objAccount.Founded_Change_Request__c;}
             if(objAccount.Publicly_Listed_Change_Request__c!= null){objAccount.Publicly_Listed__c = objAccount.Publicly_Listed_Change_Request__c;}
             if(objAccount.Stock_Ticker_Change_Request__c!= null){ objAccount.Stock_Ticker__c= objAccount.Stock_Ticker_Change_Request__c;}
             if(objAccount.Total_Employee_Change_Request__c!= null){ objAccount.Total_Employee__c = objAccount.Total_Employee_Change_Request__c;}
             if(objAccount.Bill_To_Address_1_Change_Request__c!= null){ objAccount.Bill_To_Address_1__c= objAccount.Bill_To_Address_1_Change_Request__c;}
             if(objAccount.Corporate_Address_1_Change_Request__c!= null){ objAccount.Corporate_Address_1__c = objAccount.Corporate_Address_1_Change_Request__c;}
             if(objAccount.Corporate_Address_2_Change_Request__c!= null){ objAccount.Corporate_Address_2__c = objAccount.Corporate_Address_2_Change_Request__c;}
             if(objAccount.Corporate_Address_3_Change_Request__c!= null){ objAccount.Corporate_Address_3__c = objAccount.Corporate_Address_3_Change_Request__c;}
             if(objAccount.Corporate_Address_4_Change_Request__c!= null){objAccount.Corporate_Address_4__c= objAccount.Corporate_Address_4_Change_Request__c;}
             if(objAccount.Corporate_City_Change_Request__c!= null){objAccount.Corporate_City__c = objAccount.Corporate_City_Change_Request__c;}
             if(objAccount.Corporate_Country_Change_Request__c!= null){ objAccount.Corporate_Country__c = objAccount.Corporate_Country_Change_Request__c;}
             if(objAccount.Corporate_Postal_Zip_Code_Request_Change__c!= null){objAccount.Corporate_Postal_Zip_Code__c = objAccount.Corporate_Postal_Zip_Code_Request_Change__c;}
             if(objAccount.Corporate_State_Change_Request__c!= null){ objAccount.Corporate_State__c = objAccount.Corporate_State_Change_Request__c;}
             if(objAccount.Bill_To_Address_2_Change_Request__c!= null){ objAccount.Bill_To_Address_2__c = objAccount.Bill_To_Address_2_Change_Request__c;}
             if(objAccount.Bill_To_Address_3_Change_Request__c!= null){ objAccount.Bill_To_Address_3__c = objAccount.Bill_To_Address_3_Change_Request__c;}
             if(objAccount.Bill_To_Address_4_Change_Request__c!= null){ objAccount.Bill_To_Address_4__c = objAccount.Bill_To_Address_4_Change_Request__c;}
             if(objAccount.Bill_To_City_Change_Request__c!= null){ objAccount.Bill_To_City__c = objAccount.Bill_To_City_Change_Request__c;}
             if(objAccount.Bill_To_Country_Change_Request__c!= null){ objAccount.Bill_To_Country__c = objAccount.Bill_To_Country_Change_Request__c;}
             if(objAccount.Bill_To_State_Change_Request__c!= null){ objAccount.Bill_To_State__c = objAccount.Bill_To_State_Change_Request__c;}
             if(objAccount.Bill_To_Postal_Code_Change_Request__c!= null){ objAccount.Bill_To_Postal_Zip_Code__c = objAccount.Bill_To_Postal_Code_Change_Request__c;}
             if(objAccount.Account_Alias_Change_Request__c!= null){ objAccount.Customer_Shipping_Label__c = objAccount.Account_Alias_Change_Request__c;}//Added By Mallika
              /*
               * Case# 1735
               * If condition added by Sunil Arora on 9th Jan, 2014 to populate value in "Transaction Type" field.
              */
             if(objAccount.Transaction_Type_Change__c!= null){
              objAccount.Transaction_Type__c = objAccount.Transaction_Type_Change__c;
              objAccount.Transaction_Type_Change__c=null;
             }
              
              objAccount.Is_change_request_update__c= false;
          }
             
             
        updaccountList.add (objAccount);   
    }   
    try{
        //performing the update functionality
        //database.update(updaccountList);
    }
    catch(Exception e)
    {
        system.debug('error'+e);
    }
        
           
        
  } 
  
  }