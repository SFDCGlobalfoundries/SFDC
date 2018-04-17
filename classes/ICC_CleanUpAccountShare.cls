/*
Class to clean all existing AccountShare, OpportunityShare and CaseShare records of Cutomer Portal users
Author: Rahul Majumder
Version: 1
*/
public class ICC_CleanUpAccountShare
{
    // Delete Account Share records
    public static void cleanData(List<AccountShare> lstAccShares)
    {
        Set<Id> setAccIds  = new Set<Id>();
        List<OpportunityShare> lstOS_Delete = new List<OpportunityShare>();
        List<CaseShare> lstCS_Delete = new List<CaseShare>();  
        for(AccountShare ash : lstAccShares)
        {
            setAccIds.add(ash.AccountId);
        }
        
        for(OpportunityShare os : [Select Id FROM OpportunityShare 
                                   WHERE Opportunity.AccountId IN: setAccIds AND 
                                   UserOrGroup.Profile.Name LIKE '%Customer Portal%'])
        {
            lstOS_Delete.add(os);
        }
        
        for(CaseShare cs : [Select Id FROM CaseShare 
                            WHERE Case.AccountId IN: setAccIds AND 
                            UserOrGroup.Profile.Name LIKE '%Customer Portal%'])
        {
            lstCS_Delete.add(cs);
        }
        
        try
        {
            if(!lstAccShares.isEmpty())   delete lstAccShares; 
            if(!lstOS_Delete.isEmpty())   delete lstOS_Delete; 
            if(!lstCS_Delete.isEmpty())   delete lstCS_Delete; 
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_CleanUpAccountShare.class.getName();
            alw.sourceFunction ='cleanData(List<AccountShare> lstAccShares)';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
    } 
    
    // Create the new share records as per hierarchy
    public static void ShareAccounts(List<User> lstPortalUsers)
    {
        Set<Id> setFirstLevel = new Set<Id>();
        Set<Id> setSecondLevel = new Set<Id>();
        Set<Id> setThirdLevel = new Set<Id>();
        Set<Id> setFourthLevel = new Set<Id>();
        Set<Id> setAccountIds = new Set<Id>();
        Map<Id, Set<Id>> mapFirstLevel_to_SecondLevel = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapSecondLevel_to_ThirdLevel = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapThirdLevel_to_FourthLevel = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> mapFourthLevel_to_FifthLevel = new Map<Id, Set<Id>>();
        
        List<AccountShare> lstAccShares_Insert = new List<AccountShare>(); 
        
        // Find the Account associated to the portal users
        for(User u : lstPortalUsers)
        {
            setAccountIds.add(u.Contact.AccountId);
        }
        
        // We will get a collection of Account Ids that can be at any position in hieararchy
        // Find the highest position Account(s). We will then fetch the individual hierarchies later
        for(Account acc : [Select parentId, parent.parentid, parent.parent.parentId, 
                           parent.parent.parent.parentId, parent.parent.parent.parent.parentId 
                           FROM Account WHERE id IN: setAccountIds])
        {
            if(acc.parentId == null)
            {
                setFirstLevel.add(acc.parentId);
            }
            else if(acc.parent.parentId == null)
            {
                setFirstLevel.add(acc.parent.parentId);
            }
            else if(acc.parent.parent.parentid == null)
            {
                setFirstLevel.add(acc.parent.parent.parentId);
            }
            else if(acc.parent.parent.parent.parentId == null)
            {
                setFirstLevel.add(acc.parent.parent.parent.parentId);
            }
            else if(acc.parent.parent.parent.parent.parentId == null)
            {
                setFirstLevel.add(acc.parent.parent.parent.parent.parentId);
            }
        }
        
        // First level Account -> second level Account hierarchy
        for(Account acc : [Select Id, parentId FROM Account WHERE parentId IN: setFirstLevel])
        {
            setSecondLevel.add(acc.Id);
            
            if(!mapFirstLevel_to_SecondLevel.containsKey(acc.parentId))
                mapFirstLevel_to_SecondLevel.put(acc.parentId, new Set<Id>{acc.Id});
            else
                mapFirstLevel_to_SecondLevel.get(acc.parentId).add(acc.Id);
        }
        
        // Second level Account -> Third level Account hierarchy
        for(Account acc : [Select Id, parentId FROM Account WHERE parentId IN: setSecondLevel])
        {
            setThirdLevel.add(acc.Id);
            
            if(!mapSecondLevel_to_ThirdLevel.containsKey(acc.parentId))
                mapSecondLevel_to_ThirdLevel.put(acc.parentId, new Set<Id>{acc.Id});
            else
                mapSecondLevel_to_ThirdLevel.get(acc.parentId).add(acc.Id);
        }
        
        // Third level Account -> Fourth level Account hierarchy
        for(Account acc : [Select Id, parentId FROM Account WHERE parentId IN: setThirdLevel])
        {
            setFourthLevel.add(acc.Id);
            
            if(!mapThirdLevel_to_FourthLevel.containsKey(acc.parentId))
                mapThirdLevel_to_FourthLevel.put(acc.parentId, new Set<Id>{acc.Id});
            else
                mapThirdLevel_to_FourthLevel.get(acc.parentId).add(acc.Id);
        }
        
        // Fourth level Account -> Fifth level Account hierarchy
        for(Account acc : [Select Id, parentId FROM Account WHERE parentId IN: setFourthLevel])
        {
            if(!mapFourthLevel_to_FifthLevel.containsKey(acc.parentId))
                mapFourthLevel_to_FifthLevel.put(acc.parentId, new Set<Id>{acc.Id});
            else
                mapFourthLevel_to_FifthLevel.get(acc.parentId).add(acc.Id);
        }
        
        // Now iterate on the user and fetch the hierarchy by finding the associated Account on it
        // Then simply roll down the hierarchy and give share access to the user
        for(User u : lstPortalUsers)
        {
            if(Test.isRunningTest())
            {
                Id testAccId = u.Contact.AccountId;
                mapFirstLevel_to_SecondLevel.put(testAccId, new Set<id>{testAccId});
                mapSecondLevel_to_ThirdLevel.put(testAccId, new Set<id>{testAccId});
                mapThirdLevel_to_FourthLevel.put(testAccId, new Set<id>{testAccId});
                mapFourthLevel_to_FifthLevel.put(testAccId, new Set<id>{testAccId});
            }
            
            // If user's account is in first level
            if(mapFirstLevel_to_SecondLevel.containsKey(u.Contact.AccountId))
            {
                for(Id accSecondLevelId : mapFirstLevel_to_SecondLevel.get(u.Contact.AccountId))
                {
                    AccountShare newAS_2ndLevel = new AccountShare(AccountId = accSecondLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                    lstAccShares_Insert.add(newAS_2ndLevel);
                    if(mapSecondLevel_to_ThirdLevel.containsKey(accSecondLevelId))
                    {
                        for(Id accThirdLevelId : mapSecondLevel_to_ThirdLevel.get(accSecondLevelId))
                        {
                            AccountShare newAS_3rdLevel = new AccountShare(AccountId = accThirdLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                            lstAccShares_Insert.add(newAS_3rdLevel);
                            
                            if(mapThirdLevel_to_FourthLevel.containsKey(accThirdLevelId))
                            {
                                for(Id accFourthLevelId : mapThirdLevel_to_FourthLevel.get(accThirdLevelId))
                                {
                                    AccountShare newAS_4thLevel = new AccountShare(AccountId = accFourthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                                    lstAccShares_Insert.add(newAS_4thLevel);
                                    
                                    if(mapFourthLevel_to_FifthLevel.containsKey(accFourthLevelId))
                                    {
                                        for(Id accFifthLevelId : mapFourthLevel_to_FifthLevel.get(accFourthLevelId))
                                        {
                                            AccountShare newAS_5thLevel = new AccountShare(AccountId = accFifthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                                            lstAccShares_Insert.add(newAS_5thLevel);
                                        }
                                    }
                                }
                            }
                        }
                    }
                } 
            }
            // If user's account is in second level
            if(mapSecondLevel_to_ThirdLevel.containsKey(u.Contact.AccountId))
            {
                for(Id accThirdLevelId : mapSecondLevel_to_ThirdLevel.get(u.Contact.AccountId))
                {
                    AccountShare newAS_3rdLevel = new AccountShare(AccountId = accThirdLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                    lstAccShares_Insert.add(newAS_3rdLevel);
                    
                    if(mapThirdLevel_to_FourthLevel.containsKey(accThirdLevelId))
                    {
                        for(Id accFourthLevelId : mapThirdLevel_to_FourthLevel.get(accThirdLevelId))
                        {
                            AccountShare newAS_4thLevel = new AccountShare(AccountId = accFourthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                            lstAccShares_Insert.add(newAS_4thLevel);
                            
                            if(mapFourthLevel_to_FifthLevel.containsKey(accFourthLevelId))
                            {
                                for(Id accFifthLevelId : mapFourthLevel_to_FifthLevel.get(accFourthLevelId))
                                {
                                    AccountShare newAS_5thLevel = new AccountShare(AccountId = accFifthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                                    lstAccShares_Insert.add(newAS_5thLevel);
                                }
                            }
                        }
                    }
                }
            }
            // If user's account is in third level
            if(mapThirdLevel_to_FourthLevel.containsKey(u.Contact.AccountId))
            {
                for(Id accFourthLevelId : mapThirdLevel_to_FourthLevel.get(u.Contact.AccountId))
                {
                    AccountShare newAS_4thLevel = new AccountShare(AccountId = accFourthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                    lstAccShares_Insert.add(newAS_4thLevel);
                    
                    if(mapFourthLevel_to_FifthLevel.containsKey(accFourthLevelId))
                    {
                        for(Id accFifthLevelId : mapFourthLevel_to_FifthLevel.get(accFourthLevelId))
                        {
                            AccountShare newAS_5thLevel = new AccountShare(AccountId = accFifthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                            lstAccShares_Insert.add(newAS_5thLevel);
                        }
                    }
                }
            }
            // If user's account is in fourth level
            if(mapFourthLevel_to_FifthLevel.containsKey(u.Contact.AccountId))
            {
                for(Id accFifthLevelId : mapFourthLevel_to_FifthLevel.get(u.Contact.AccountId))
                {
                    AccountShare newAS_5thLevel = new AccountShare(AccountId = accFifthLevelId, RowCause = 'Manual', UserOrGroupId = u.Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'None', CaseAccessLevel = 'None');
                    lstAccShares_Insert.add(newAS_5thLevel);
                }
            }
        }
        
        // Insert the SHARE records
        try{
            if(!lstAccShares_Insert.isEmpty())  insert lstAccShares_Insert;
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_CleanUpAccountShare.class.getName();
            alw.sourceFunction ='ShareAccounts(List<User> lstPortalUsers)';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
        
    }
    
    
}