/*
Type Name: ClsAccTriggerHandler 
Author: Cognizant
Created Date: 17-April-2013
Reason: This class is used for Inactivating the Portal users of any Inactive Account by calling the method userUpdate. This class also creates AccountShare object
        for creating Account Hierarchy.
Change History:
Author: Ariz Solito
Modified Date: 12/11/2013
Reason: Code optimization of updateManager method

Author: 
Modified Date: Modified on 5/22/2013
Reason: 
Modified Date: Modified on 01-Sept-2015
Reason:  Case # Case#44223 :Populate Account owner field on contact. 

Author: JKTechnosoft
Modified Date: Modified on 07/29/2016
Reason: Populate FAE field on contact
……..
……..
*/


global class ClsAccTriggerHandler {
 
        //Variable to stop the CreateSharingOnAccount Trigger to perform the functionality once 
        //Modified on 5/22/2013
        public static Boolean blnAccountShareRun =false;
        
            
    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used for deactivating the user record for accounts which has been deactivated.
        @method name: deactivateAccount
        @parameter:   List of Account Ids.
        @return :     none
    **/ 
    

    
    //Method for deactivating the user record for accounts which has been deactivated.
    @future
    static public void deactivateAccount(List<Id> accntId)
    {  
        if(accntId.size() > 0)
        {
            List<User> userList = [SELECT Id FROM User where AccountId IN :accntId];
            if(userList.size() > 0){
                for(User userObj : userList)
                {
                    userObj.IsActive = false;
                }
            }
            
            try
            {
                update userList;
            }
            catch(DMLException e)
            {
                System.debug(e) ;
            }
            catch(Exception e)
            {
                System.debug(e) ; 
            }
        }      
    } 
    
    /** Modified By Cognizant on 03052013 Start
     **/
    /**
        This method is used for deactivating the user record for contact which has been deactivated.
        @method name: deactivateContactUser
        @parameter:   List of contact Ids.
        @return :     none
    **/ 
    
    //Method for deactivating the user record for contact which has been deactivated.
    @future
    static public void deactivateContactUser(List<Id> contactIdList)
    {  
        if(contactIdList.size() > 0)
        {
            List<User> userList = [SELECT Id FROM User where ContactId IN :contactIdList];
            if(userList.size() > 0){
                for(User userObj : userList)
                {
                    userObj.IsActive = false;
                }
            }
            
            try
            {
                update userList;
            }
            catch(DMLException e)
            {
                System.debug(e) ;
            }
            catch(Exception e)
            {
                System.debug(e) ; 
            }
        }      
    } 
    
    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used for creating Account Share record for creating Account hierarchy.
        @method name: createSharingOnAccount
        @parameter:   List of Account Ids, map of Account Ids and its parent Account Ids, Map of Contact Ids and UserIds, Map of Account Ids and corresponding Child Account Ids List, Map of parent Account Id and parent parent Account Ids.
        @return :     none
    **/ 
    
   //Method for creating Account Share record for creating Account hierarchy.
   public static void createSharingOnAccount(Set<Id> accountidSet, Map<Id, ID> childParentMap, Map <Id, List<Id>> mapAccountContact, Map<Id, ID> userContactmap, Map<Id, List<id>> parentChildMap, Map<Id, ID> mapParentparentAccount){
    
        List<AccountShare> AccShareList = new List<AccountShare>();
        Map<id, List<Account>> userAccSharemap = new Map<Id, List<Account>>();
    
       // If AccountIdSet is not null or blank. 
       if(accountidSet!= null && !(accountidSet.isEmpty())) {
            
            for(Id accountId : accountidSet) {
            
                Id parentAccId = childParentMap.get(accountId);
                Id parentParentAccId = mapParentparentAccount.get(parentAccId);
                
                
                
                // Get the ContactList from AccountId.
                List<Id> conList = mapAccountContact.get(accountId);
                
                // Get the ChildList of Account Hierarchy for the desired Account and add the records in AccountShare object.
                List<Id> acclist = parentChildMap.get(accountId);
                
                // If conList is not null or blank. 
                if(conList != null && !(conList.isEmpty())) {
                  for(Id conId : conList){
                    
                    // Get the UserId from userContactmap.
                    String userId = userContactmap.get(conId);
                    
                        // If userId is not null.   
                        if(userId!=null){
                        
                            // Add the record for Account Id and UserId in AccountShare object.
                            if(accountId != null){
                            
                                // Create AccountShare Object and add it to AccShareList List.
                                AccountShare accShareObjOne= new AccountShare();
                                accShareObjOne.UserOrgroupId = userId;
                                accShareObjOne.AccountId = accountId;
                                accShareObjOne.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
                                accShareObjOne.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                accShareObjOne.CaseAccessLevel = System.Label.PortalCaseAccessLevel;           
                                
                                AccShareList.add(accShareObjOne);                
                            
                            }
                            
                            // Add the record for Parent Account Id and UserId in AccountShare object.
                            if(parentAccId != null){
                            
                                AccountShare accShareObjTwo = new AccountShare();
                                accShareObjTwo.UserOrgroupId = userId;
                                accShareObjTwo.AccountId = parentAccId;
                                accShareObjTwo.AccountAccessLevel = System.Label.PortalOtherAccountAccessLevel;
                                accShareObjTwo.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                accShareObjTwo.CaseAccessLevel = System.Label.PortalCaseAccessLevel;            
                                
                                AccShareList.add(accShareObjTwo);
                            
                            }
                            
                            // Add the record for Parent Parent Account Id and UserId in AccountShare object.
                            if(parentParentAccId!= null){
                            
                                AccountShare accShareObjThree = new AccountShare();
                                accShareObjThree.UserOrgroupId = userId;
                                accShareObjThree.AccountId = parentParentAccId;
                                accShareObjThree.AccountAccessLevel = System.Label.PortalOtherAccountAccessLevel;
                                accShareObjThree.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                accShareObjThree.CaseAccessLevel = System.Label.PortalCaseAccessLevel;             
                                
                                AccShareList.add(accShareObjThree);                
                            
                            }
                            
                            // Get the ChildList of Account Hierarchy for the desired Account and add the records in AccountShare object.
                            //List<Id> acclist = parentChildMap.get(accountId);
                            
                            //AccShareList = updateChildRecords(accountId,parentAccId,parentParentAccId, acclist,AccShareList);
                            //System.debug('*************************AccShareList****************************'+AccShareList);                            

                            System.debug('<<<<<<<<<<<<<<<<acclist>>>>>>>>>>>>>>>>>'+acclist);
                            
                            if(acclist != null && !(acclist.isEmpty())) {
                            
                                for(Id acc : acclist) {
                                
                                    AccountShare accShareObjFour = new AccountShare();
                                    accShareObjFour.UserOrgroupId = userId;
                                    accShareObjFour.AccountAccessLevel = System.Label.PortalOtherAccountAccessLevel;
                                    accShareObjFour.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                    accShareObjFour.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                                    accShareObjFour.AccountId = acc;
                                    
                                    AccShareList.add(accShareObjFour);
                                }   
                            }
                        
                       }  
                    //   AccShareList = updateChildRecords(accountId,parentAccId,parentParentAccId, acclist,AccShareList);
                    //  System.debug('*************************AccShareList****************************'+AccShareList);                            
                   }
                
                }
                
                List<Id> accountIdList = new List<Id>();
                List<Id> parentAccIdList = new List<Id>();
                List<Id> parentParentAccIdList = new List<Id>();
                
                accountIdList.add(accountId);
                parentAccIdList.add(parentAccId);
                parentParentAccIdList.add(parentParentAccId);               
                
                AccShareList = updateChildRecords(accountIdList,parentAccIdList,parentParentAccIdList, acclist,AccShareList);
                System.debug('*************************AccShareList 12234****************************'+AccShareList);                            

                AccShareList = updateReparentedRecords(parentAccIdList,parentParentAccIdList,acclist,AccShareList);
                System.debug('*************************AccShareList  5465645****************************'+AccShareList);                    
            }
        }
        
       // Finally get the list and insert it into AccountShare object.
       try{
           insert AccShareList;
       }catch(DMLException de){
            System.debug(de.getMessage());
       }
    
    }
    

    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used to assign AccountShare object to List based on parameters passed. Access Level of Account is READ ONLY. Cases and Opportunities do not have any access.
        @method name: createAccountSharelist
        @parameter:   Account Id, Id of User Id, List of AccountShare object.
        @return :     none
    **/     
    
    // This public method is used to assign AccountShare object to List based on parameters passed. Access Level of Account is READ ONLY. Cases and Opportunities do not have any access.
    public static List<AccountShare> updateChildRecords(List<Id> accountIdList,List<Id> parentAccIdList,List<Id> parentParentAccIdList,List<Id> acclist,List<AccountShare>accntShareListSub){

        Id accountId = accountIdList.get(0);
          
        if(parentAccIdList!= null && !(parentAccIdList.isEmpty())) {
            Id parentAccountId = parentAccIdList.get(0);
              
            if(parentParentAccIdList!= null && !(parentParentAccIdList.isEmpty())) {
                Id parentParentId = parentParentAccIdList.get(0);
                      
             
                    List<User> parentuserList = [SELECT Id FROM User where IsPortalEnabled = true and IsActive = true and ContactId in (SELECT Id FROM Contact where AccountId =:parentAccountId)];
                    List<User> parentparentuserList = [SELECT Id FROM User where IsPortalEnabled = true and IsActive = true and ContactId in (SELECT Id FROM Contact where AccountId =:parentParentId)];
                    AccountShare accntShareObj = new AccountShare();

                    if(parentuserList != null && !(parentuserList.isEmpty())){
                         for(User userObj : parentuserList){
                             System.debug('*************Part 1***********');
                
                             accntShareObj = new AccountShare();
                             accntShareObj.AccountId = accountId;
                             accntShareObj.UserOrGroupId = userObj.Id;
                             accntShareObj.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
                             accntShareObj.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                             accntShareObj.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                             accntShareListSub.add(accntShareObj);   
                             
                                if(acclist != null && !(acclist.isEmpty())) {
                                
                                    for(Id acc : acclist) {
                                        System.debug('*************Part 2***********');
                    
                                        AccountShare accShareObjFour = new AccountShare();
                                        accShareObjFour.UserOrgroupId = userObj.Id;
                                        accShareObjFour.AccountAccessLevel = System.Label.PortalOtherAccountAccessLevel;
                                        accShareObjFour.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                        accShareObjFour.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                                        accShareObjFour.AccountId = acc;
                                        
                                        accntShareListSub.add(accShareObjFour);
                                    }   
                                }            
                                        
                         }
                     }
                     if(parentparentuserList!= null && !(parentparentuserList.isEmpty())){
                         for(User userObj : parentparentuserList){
                             
                             System.debug('*************Part 3***********');
                
                             accntShareObj = new AccountShare();
                             accntShareObj.AccountId = accountId;
                             accntShareObj.UserOrGroupId = userObj.Id;
                             accntShareObj.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
                             accntShareObj.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                             accntShareObj.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                             accntShareListSub.add(accntShareObj);    
                             
                            if(acclist != null && !(acclist.isEmpty())) {
                            
                                for(Id acc : acclist) {
                                    System.debug('*************Part 4***********');
                
                                    AccountShare accShareObjFour = new AccountShare();
                                    accShareObjFour.UserOrgroupId = userObj.Id;
                                    accShareObjFour.AccountAccessLevel = System.Label.PortalOtherAccountAccessLevel;
                                    accShareObjFour.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                    accShareObjFour.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                                    accShareObjFour.AccountId = acc;
                                    
                                    accntShareListSub.add(accShareObjFour);
                                }   
                            }                   
                         }  
                     }
            } 
        } 
        System.debug('*************accntShareListSub from update method***********'+accntShareListSub);
                
         return accntShareListSub;
    }    


    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used to assign AccountShare object to List based on parameters passed. Access Level of Account is READ ONLY. Cases and Opportunities do not have any access.
        @method name: createAccountSharelist
        @parameter:   Account Id, Id of User Id, List of AccountShare object.
        @return :     none
    **/     
    
    // This public method is used to assign AccountShare object to List based on parameters passed. Access Level of Account is READ ONLY. Cases and Opportunities do not have any access.
    public static List<AccountShare> updateReparentedRecords(List<Id> parentAccIdList,List<Id> parentParentAccIdList,List<Id> acclist,List<AccountShare>accntShareListSub){
    
          if(parentAccIdList!= null && !(parentAccIdList.isEmpty())) {
            Id parentAccountId = parentAccIdList.get(0);
          
            if(parentParentAccIdList!= null && !(parentParentAccIdList.isEmpty())) {
                Id parentParentId = parentParentAccIdList.get(0);
                    
                 if(acclist!= null && !(acclist.isEmpty())){
                     List<User> childuserList = [SELECT Id FROM User where IsPortalEnabled = true and IsActive = true and ContactId in (SELECT Id FROM Contact where AccountId =:acclist)];

                     AccountShare accntShareObj = new AccountShare();

                     if(childuserList != null && !(childuserList.isEmpty())){
                         for(User userObj : childuserList){
                             System.debug('*************Part 1***********');
                            if(parentAccountId!=null){
                                 accntShareObj = new AccountShare();
                                 accntShareObj.AccountId = parentAccountId;
                                 accntShareObj.UserOrGroupId = userObj.Id;
                                 accntShareObj.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
                                 accntShareObj.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                 accntShareObj.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                                 accntShareListSub.add(accntShareObj);   
                            } 
                            if(parentParentId!=null){
                                 accntShareObj = new AccountShare();
                                 accntShareObj.AccountId = parentParentId;
                                 accntShareObj.UserOrGroupId = userObj.Id;
                                 accntShareObj.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
                                 accntShareObj.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
                                 accntShareObj.CaseAccessLevel = System.Label.PortalCaseAccessLevel;
                                 accntShareListSub.add(accntShareObj);              
                            }
                         }
                     }
                }
         
            }
        
        }
        System.debug('*************accntShareListSub from update method***********'+accntShareListSub);
        return accntShareListSub;
    }    

    
    
    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used for deleting Account Share records when the parent is changed / re-parented.
        @method name: deleteSharingOnAccount
        @parameter:   Set of Account Ids, Map of Account Ids and its parent Account Ids.
        @return :     none
    **/     
    
    // Method for deleting Account Share records when the parent is changed / re-parented.
    public static void deleteSharingOnAccount(Set<Id> accountidSet, Map<Id, Id> deleteParentChildMap) {
    
        List<AccountShare> accShrIdsDltComplteFullList = new List<AccountShare>(); 
        System.debug('**************deleteParentChildMap*******************'+deleteParentChildMap);

        if(deleteParentChildMap!= null) {
            System.debug('--------------------------11-----------------------------');
            //Fetching user linked with the Account which has been reparented - Modified on 5/22/2013
            List<User> userTempList=new List<User>();
            userTempList =[SELECT Id FROM User where IsPortalEnabled = true and IsActive = true and AccountId In: deleteParentChildMap.keySet()];
            List<ID> parentAccountIDList=new List<ID>();  
            Set<Id> baseChildAccountIds = new Set<Id>();
            
            System.debug('**************userTempList*******************'+userTempList);
            
            //Fetching the Parent account id of the Old Parent 
            for (Account accountObj:[SELECT ParentId FROM Account WHERE Id IN:deleteParentChildMap.values()]){
                System.debug('**************accountObj.ParentId*******************'+accountObj.ParentId);
                System.debug('--------------------------22-----------------------------');
                parentAccountIDList.add(accountObj.ParentId);
            }
            parentAccountIDList.addAll(deleteParentChildMap.values());
            System.debug('**************parentAccountIDList*******************'+parentAccountIDList);
            
            for (AccountShare objAccountShare:[SELECT ID, UserOrGroupId, AccountId FROM AccountShare WHERE AccountId IN:parentAccountIDList]) {
                System.debug('--------------------------33-----------------------------');
                System.debug('**************objAccountShare*******************'+objAccountShare);
                for (User objUser: userTempList){
                    System.debug('--------------------------44-----------------------------');
                    System.debug('**************objUser*******************'+objUser);
                    if (String.valueOf(objAccountShare.UserOrGroupId).equals(objUser.Id)){
                        System.debug('--------------------------55-----------------------------');
                        accShrIdsDltComplteFullList.add(objAccountShare);   
                    }
                }   
            }
            
            // Getting the child Accounts for the Base Account and adding it to Set.
            for(Account accObj : [Select Id from Account where ParentId in: deleteParentChildMap.keySet()]) {
                System.debug('--------------------------55-----------------------------');
                System.debug('**************accObj.Id*******************'+accObj.Id);
                baseChildAccountIds.add(accObj.Id);
            }
            if(baseChildAccountIds!=null && !(baseChildAccountIds.isEmpty())){
                System.debug('--------------------------66-----------------------------');
                System.debug('**************baseChildAccountIds*******************'+baseChildAccountIds);
                for(Account accObj : [Select Id from Account where ParentId in: baseChildAccountIds]) {         
                    System.debug('--------------------------77-----------------------------');
                    System.debug('************** 11111 accObj.Id*******************'+accObj.Id);
                    baseChildAccountIds.add(accObj.Id);
                }
            }
            
            
            baseChildAccountIds.addAll(deleteParentChildMap.keySet());
            
            System.debug('************** 11111 baseChildAccountIds*******************'+baseChildAccountIds);
            accShrIdsDltComplteFullList = deleteUserParentAccShare(accShrIdsDltComplteFullList,baseChildAccountIds,parentAccountIDList);

           
            try{
                // Delete the unparented records from AccountShare object.
                delete accShrIdsDltComplteFullList;
            }catch(DMLException de){
                System.debug(de.getMessage());
            }
        }
     
    } 
    
  /**
        This method is used for preparing the deletion List of AccountShare for Child Accounts of Base Account .
        @method name: deleteUserParentAccShare
        @parameter:   List of AccountShare object, Set of Base Account Ids, List of parent Account Ids.
        @return :     List of AccountShare object
  **/ 
    
    static private List<AccountShare> deleteUserParentAccShare(List<AccountShare> accShrIdsDltComplteFullList,Set<Id> baseAccountIds,List<ID> parentAccountIDList)
    {  
        List<User> userParentTempList=new List<User>();
        
        System.debug('--------------------------1-----------------------------');
        
        if(parentAccountIDList!=null && !(parentAccountIDList.isEmpty())){
            System.debug('--------------------------2-----------------------------');
            System.debug('************** 2222 parentAccountIDList*******************'+parentAccountIDList);
            userParentTempList =[SELECT Id FROM User where IsPortalEnabled = true and IsActive = true and AccountId In: parentAccountIDList];   
        }
        
        if(userParentTempList!=null && !(userParentTempList.isEmpty())){
        System.debug('--------------------------3-----------------------------');
            for (AccountShare objAccountShare:[SELECT ID, UserOrGroupId, AccountId FROM AccountShare WHERE AccountId IN:baseAccountIds and UserOrGroupId IN :userParentTempList]) {
                System.debug('--------------------------4-----------------------------');
                System.debug('************** 2222 objAccountShare*******************'+objAccountShare);
                accShrIdsDltComplteFullList.add(objAccountShare);   
            }           
        }
        System.debug('--------------------------1-----------------------------');
        System.debug('************** 2222 accShrIdsDltComplteFullList*******************'+accShrIdsDltComplteFullList);
        return accShrIdsDltComplteFullList;
        
    }   
    
    
 /*----------------------------------------------------------------*/     
  /**
        This method is used for updaing the Account manager and customer portal admin field in contact.
        @method name: updateManager
        @parameter:   List of account Id
        @return :     none
    **/ 
 public static void updateManager(List<Id> totalaccountId)

   {
    system.debug('@@@@@@ enter method'+totalaccountId);
    //Asolito 12092013 - code optimization
    //only 1 DML transaction for all roles
    /*List<Contact> updateManagerList=new List<Contact>();
    List<Contact> updateCustomerPortalAdminList=new List<Contact>();
    List<Contact> updatePrimaryCSRList=new List<Contact>();*/
    
    List<Contact> updateContacts = new List<Contact>();
    List<Account> accList=[Select   id,
                                    Name,
                                    Account_Manager__c,
                  ownerid,
                                    Primary_CSR__c,
                                    Primary_FAE__c,
                                    Customer_Portal_Admin__c
                                    from Account
                                    where Id in:totalaccountId];
     System.debug('@@@@@@@@@@@@@@@@@@accList'+accList.size());
                                    
     List<String> accnameList=new List<String>();
     for(Account accobj:accList)
     {
          if(accobj.name==System.Label.GlobalfoundryAccount)
          {
           accnameList.add(accobj.name);
          }
      }
  System.debug('@@@@@@@@@@@@@@@@@@accnameList'+accnameList);
     List<Contact> contList=[Select  id,
                                    Account_Manager__c,
                  Account_Owner__c,
                                    Customer_Portal_Admin__c,
                                    Primary_CSR__c,
                                    FAE__c
                                    from Contact
                                    where AccountId in:totalaccountId and Account.Name not in:accnameList];
      
                                 
   System.debug('@@@@@@@@@@@@@@@@@@contList'+contList.size());
     if(contList.size()>0)
   {
      for(Account accObj:accList)
             {
              system.debug('@@@@@@ enter Account ');
              for(Contact c:contList)
                                          
              {
               Contact contobj = c;
               Boolean addrec = false;
                system.debug('@@@@@@ enter Account ');
               if(accObj.Account_Manager__c !=null)
                         
                         {
                          system.debug('@@@@@@@'+accObj.Account_Manager__c);
                          contobj.Account_Manager__c =accObj.Account_Manager__c ;
                          //updateManagerList.add(contobj);
                          system.debug('@@@@@@@'+contobj.Account_Manager__c);
                          addRec = true;
                         }
            if(accObj.ownerid !=null)
                         
                         {
                          system.debug('@@@@@@@'+accObj.ownerid);
                          contobj.Account_Owner__c =accObj.ownerid ;
                          //updateManagerList.add(contobj);
                          system.debug('@@@@@@@'+contobj.Account_Owner__c);
                          addRec = true;
                         }
              if(accObj.Customer_Portal_Admin__c !=null)
                         
                         {
                          system.debug('@@@@@@@'+accObj.Customer_Portal_Admin__c);
                          contobj.Customer_Portal_Admin__c =accObj.Customer_Portal_Admin__c ;
                          //updateCustomerPortalAdminList.add(contobj);
                          system.debug('@@@@@@@'+contobj.Customer_Portal_Admin__c);
                          addRec = true;
                         }
                if(accObj.Primary_CSR__c!=null)
                         
                         {
                          system.debug('@@@@@@@'+accObj.Primary_CSR__c);
                          contobj.Primary_CSR__c =accObj.Primary_CSR__c ;
                          //updatePrimaryCSRList.add(contobj);
                          system.debug('@@@@@@@'+contobj.Primary_CSR__c );
                          addRec = true;
                         }
                if(accObj.Primary_FAE__c!=null)
                         
                         {
                          system.debug('@@@@@@@'+accObj.Primary_FAE__c);
                          contobj.FAE__c =accObj.Primary_FAE__c ;
                          //updatePrimaryCSRList.add(contobj);
                          system.debug('@@@@@@@'+contobj.FAE__c );
                          addRec = true;
                         }
                //Asolito 12092013 - code optimization
                //add the contact record if it falls into the conditions above                         
                if(addRec){
                    updateContacts.add(contobj);
                }                                
              }
      
         }
       }
    
         
         try
          { 
          //Asolito 12092013 - code optimization
          //commented out saving of 3 contact lists         
           /*if(updateManagerList.size()>0)
         {
          update updateManagerList;
          }
          if(updateCustomerPortalAdminList.size()>0)
           {
          update updateCustomerPortalAdminList;
          }
          if(updatePrimaryCSRList.size()>0)
           {
          update updatePrimaryCSRList;
           }*/
           
           update updateContacts;
          }
          catch(Exception e){
          system.debug('update list'+e);
          }
   }
/*---------------------------------------------------------------------------------*/    
  
}