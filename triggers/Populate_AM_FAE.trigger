/***********************************************************************************************************************************
Trigger: Populate_AM_FAE
------------------------------------------------------------------------------------------------------------------------------------
Author: Joydev Mondol (Cognizant - 153480)
Created Date: 18/09/2013
Reason: Populates the following to the new IP requests in the trigger scope:
        1) Account Manager related information
        2) FAE related information
************************************************************************************************************************************/

trigger Populate_AM_FAE on IP_Request__c (before Insert, before update) {
    
    //IP Requests to be updated
    List<IP_Request__c> LstIPRequests = new List<IP_Request__c>();
    
    for(IP_Request__c ipReq : Trigger.New){
        if(Trigger.isInsert){
            LstIPRequests.add(ipReq);
        } else if(Trigger.isUpdate){
            if(ipReq.Customer_Account_Name__c != Trigger.OldMap.get(ipReq.Id).Customer_Account_Name__c){
                LstIPRequests.add(ipReq);
            }
        }
    }
    
    //Account Team Proxy Roles
    Final String AM = 'Primary Account Manager';
    Final String FAE = 'Primary Field Application Engineer';

    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'LstIPRequests(In scope) >> ' + LstIPRequests);
    
    //Set of Account Ids assotiated with the Ip Requests
    Set<Id> setAccountIds = new Set<Id>();
    
    for(IP_Request__c ipReq : LstIPRequests){
        setAccountIds.add(ipReq.Customer_Account_Name__c);
    }
    
    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'setAccountIds >> ' + setAccountIds);
    
    //List of Team roles (AMs and FAEs)
    List<String> lstTeamRoles = new list<String>{AM, FAE};
    
    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'lstTeamRoles >> ' + lstTeamRoles);
    
    //Map of IP Request Account Ids with Account Managers (Account Team Proxies) associated to the IP Requests in scope
    Map<Id, Account_Team_Proxy__c> mapAccountManagers = new Map<Id, Account_Team_Proxy__c>();
    
    //Map of IP Request Account Ids with FAEs (Account Team Proxies) associated to the IP Requests in scope
    Map<Id, Account_Team_Proxy__c> mapFAEs = new Map<Id, Account_Team_Proxy__c>();
    
    //Loop through the account team memberst to seperate out AMs and FAes into two different maps
    for(Account_Team_Proxy__c accountTeam : [Select Id,
                                                    Name,
                                                    Account__c,
                                                    User__c,
                                                    User__r.Name,
                                                    User__r.Email,
                                                    User__r.Phone,
                                                    User__r.Extension,
                                                    User__r.MobilePhone,
                                                    Team_Role__c
                                               From Account_Team_Proxy__c
                                              Where Account__c IN: setAccountIds AND
                                                    Team_Role__c IN: lstTeamRoles]){
        if(accountTeam.Team_Role__c == AM){
            mapAccountManagers.put(accountTeam.Account__c, accountTeam);
        } else {
            mapFAEs.put(accountTeam.Account__c, accountTeam);
        }
    }
    
    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'mapAccountManagers >> ' + mapAccountManagers);
    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'mapFAEs >> ' + mapFAEs);
    
    //Populate the IP Request Am and FAE related fields
    for(IP_Request__c IpReq : LstIPRequests){
        //AM related info
        IpReq.Account_Manager_Name__c = (mapAccountManagers.containskey(IpReq.Customer_Account_Name__c) ? 
                                         mapAccountManagers.get(IpReq.Customer_Account_Name__c).User__r.Name :
                                         null);
        IpReq.Account_Manager_Email__c = (mapAccountManagers.containskey(IpReq.Customer_Account_Name__c) ? 
                                          mapAccountManagers.get(IpReq.Customer_Account_Name__c).User__r.Email :
                                          null);
        IpReq.Account_Manager_Phone__c = (mapAccountManagers.containskey(IpReq.Customer_Account_Name__c) ? 
                                          mapAccountManagers.get(IpReq.Customer_Account_Name__c).User__r.Phone :
                                          null);
                                         
        IpReq.Account_Manager_Office_Phone__c = (mapAccountManagers.containskey(IpReq.Customer_Account_Name__c) ? 
                                                 mapAccountManagers.get(IpReq.Customer_Account_Name__c).User__r.Extension :
                                                 null);
                                         
        IpReq.Account_Manager_Cell_Phone__c = (mapAccountManagers.containskey(IpReq.Customer_Account_Name__c) ? 
                                               mapAccountManagers.get(IpReq.Customer_Account_Name__c).User__r.MobilePhone :
                                               null);
        
        //FAE related info
        IpReq.FAE_Name__c = (mapFAEs.containskey(IpReq.Customer_Account_Name__c) ? 
                             mapFAEs.get(IpReq.Customer_Account_Name__c).User__r.Name :
                             null);
        IpReq.FAE_Email__c = (mapFAEs.containskey(IpReq.Customer_Account_Name__c) ? 
                              mapFAEs.get(IpReq.Customer_Account_Name__c).User__r.Email :
                              null);
        IpReq.FAE_Phone__c = (mapFAEs.containskey(IpReq.Customer_Account_Name__c) ? 
                              mapFAEs.get(IpReq.Customer_Account_Name__c).User__r.Phone :
                              null);
    }
    
    /*DEBUG*/System.Debug('DEBUG:CTS: ' + 'lstTriggeredIpReqs(To be updated) >> ' + LstIPRequests);
    
    //update the IP requests in scope if not recursive trigger
    //update LstIPRequests;
}