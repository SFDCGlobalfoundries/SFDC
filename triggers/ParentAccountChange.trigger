/*****************************************************************************************************************
    Trigger:        ParentAccountChange
------------------------------------------------------------------------------------------------------------------
    
    Author:         COGNIZANT
    Created Date:   20/01/2014
    Description:    Apex trigger for Contacts (Portal Users) on change in Parent Account to provide ability
                    to change Document Provisioning, Teamroom membership, account and contact share.
------------------------------------------------------------------------------------------------------------------
    History:        1 
    COGNIZANT:      20/01/2014    -    Apex code created
------------------------------------------------------------------------------------------------------------------
    History:        2
    COGNIZANT:      13/02/2014    -    Apex code added to reparenting Portal_Tab_Access__c(Access Setup) record.  
******************************************************************************************************************/

trigger ParentAccountChange on Contact (after update) {
    
    List<Contact> portalContactList = new List<Contact>();
    System.debug('portalContactList PAC b : ' + portalContactList.size());
    for(Contact contactObj : trigger.new){
        
        if(contactObj.Is_Portal_User_Active__c){
            portalContactList.add(contactObj);
        }
    }
    
    if(portalContactList.size() < 1){
        return;
    }
    System.debug('portalContactList PAC a : ' + portalContactList.size());
    
    //if(!IntegrationUserUtil.isSkipTrigger()){
        
        //List of Contact Ids with account change
        List<Id> ContactIds = new List<Id>();
        
        //List of User Ids corresponding to Triggered Contacts
        List<Id> ContactUserIds = new List<Id>();
        
        //List of Document Provisionings to be updated
        List<Document_Provisioning__c> ContactDocProvs = new List<Document_Provisioning__c>();
        
        //List of Teamroom memberships to be deleted
        List<Team_Room_Member__c> ContactTeamroomMemberships = new List<Team_Room_Member__c>();
        
        //Loop through the contacts in trigger scope to look for changes in Parent Account
        for(Contact con : Trigger.NewMap.Values()){
            //Contact previous state
            Contact con_old = Trigger.OldMap.get(con.Id);
            
            //Check if the Account got changed for the contact (for portal users only)
            if(con.Is_Portal_User_Created__c &&
               con.AccountId != con_old.AccountId){
                //Store the filtered contact id
                ContactIds.add(con.Id);
            }
        }
        
        //Loop through the contact users (with account change) in trigger scope to fetch the contact user Ids
        for(User contactUser : [SELECT Id
                                  FROM User
                                 WHERE ContactId IN: ContactIds]){
            //Store the contact user Id 
            ContactUserIds.add(contactUser.Id);
           
        }
        /*---------(case#00052375)-----Jabee------------------*/
        list<Document_Provisioning__c> DocumentProvisionList=[SELECT Id,
                                                        Name,
                                                        User__r.Contact.AccountId,
                                                        User__r.Contact.Account.Has_Valid_NDA__c,
                                                        User__r.Contact.Account.Tech_Geo_Granted__c,
                                                        User__r.Contact.Account.Valid_Tech_Geos__c,
                                                        Design_Package__r.Tech_Geometry__c,
                                                        PDK__r.Tech_Geometry__c,
                                                        Design_Spec__r.Technology_Geometry__c,
                                                        Tech_Geo_Granted_to_Account__c,
                                                        NDA_Coverage__c
                                                   FROM Document_Provisioning__c
                                                  WHERE User__r.ContactId IN: ContactIds AND
                                                        Status__c = 'Provisioned'];
        /*-----------------------END---case--------------------------------------------------------*/
        //fetch and loop through the List of Document Provisionings for all the Contacts with change in Parent Account
        for(Document_Provisioning__c docProv :  DocumentProvisionList){
            
            //Current state of Tech Geo Granted To Account for the doc prov
            Boolean initialTechGeoGrantedToAccount = docProv.Tech_Geo_Granted_to_Account__c;
            
            //Current state of NDA Coverage for the doc prov
            Boolean initialNDACoverage = docProv.NDA_Coverage__c;
            
            /*Tech geo can be in either of the Design Package, PDK or Design Spec of the doc prov but mutually exclusive.
              So concatinating them all will eventually give one Tech Geo at a time*/
            String szTechGeo = (docProv.Design_Package__r.Tech_Geometry__c != Null ? docProv.Design_Package__r.Tech_Geometry__c : '') +
                               (docProv.PDK__r.Tech_Geometry__c != Null ? docProv.PDK__r.Tech_Geometry__c : '') +
                               (docProv.Design_Spec__r.Technology_Geometry__c != Null ? docProv.Design_Spec__r.Technology_Geometry__c : '');
                                       
            /*If no Tech Geo is defined in either of the three (above), default it to TRUE for 'Tech Geo Granted To Account'
              and update the 'NDA Coverage' with 'Has Valid NDA' of the Account of the doc prov*/
            if(szTechGeo == ''){
                docProv.Tech_Geo_Granted_to_Account__c = True;
                docProv.NDA_Coverage__c = docProv.User__r.Contact.Account.Has_Valid_NDA__c;
            /*Else check if the 'Tech Geo' of the doc prov (as derived above) is included in the account's 
              'Tech Geo Granted' and 'Valid Tech Geos' fields (Multi-select Picklists) for 'Tech Geo Granted to Account' 
              and 'NDA Coverage' of the doc prov respectively*/
            } else { 
                //Check for null string before searching for Tech Geo and flagging 'Tech Geo Granted to Account'
                docProv.Tech_Geo_Granted_to_Account__c = 
                    (docProv.User__r.Contact.Account.Tech_Geo_Granted__c != null &&
                     docProv.User__r.Contact.Account.Tech_Geo_Granted__c != '' &&
                     docProv.User__r.Contact.Account.Tech_Geo_Granted__c.contains(szTechGeo)? 
                     True: False);
                     
                //Check for null string before searching for Tech Geo and flagging 'NDA Coverage'
                docProv.NDA_Coverage__c = 
                    (docProv.User__r.Contact.Account.Valid_Tech_Geos__c != null &&
                     docProv.User__r.Contact.Account.Valid_Tech_Geos__c != '' &&
                     docProv.User__r.Contact.Account.Valid_Tech_Geos__c.contains(szTechGeo)? 
                     True: False); 
            } 
            
            /*Check if the doc prov needs to be updated based on change in 'Tech Geo Granted to Account' 
              and 'NDA Coverage' fields*/
            if(initialTechGeoGrantedToAccount != docProv.Tech_Geo_Granted_to_Account__c ||
               initialNDACoverage != docProv.NDA_Coverage__c){
                //Add to the list of doc provs to be updated
                ContactDocProvs.add(docProv);
            }                   
        }
        
        //fetch and loop through the List of Teamroom members for all the Contacts with change in Parent Account
        for(Team_Room_Member__c member : [SELECT Id,
                                                 Account__c,
                                                 User__r.ContactId
                                            FROM Team_Room_Member__c
                                           WHERE User__r.ContactId IN: ContactIds]){
            //Add to the list of memberships to be deleted
            ContactTeamroomMemberships.add(member);
        }
        
        //Try updating the Document Provisionings
        try{
            update ContactDocProvs;
        } 
        catch(DmlException e){
            System.Debug('[DEBUG :: COGNIZANT] >> Exception updating Doc Provs : ' + e);
        }
        
        //Try deleting the teamroom memberships
        try{
            delete ContactTeamroomMemberships;
        } 
        catch(DmlException e){
            System.Debug('[DEBUG :: COGNIZANT] >> Exception deleting Teamroom Member : ' + e);
        }
    //}
    
    /*
    //This below code is to ensure that the Portal_Tab_Access__c(Access Setup) record of the user 
    //is reparented to the new Account of the contact.
    
    //Portal_Tab_Access__c(Access Setup) Reparenting begins
        
    //List to fetch Portal_Tab_Access records whose contacts have new accounts 
    List<Portal_Tab_Access__c> portaltabAccessList = [SELECT Id, Account__c,User__c  FROM Portal_Tab_Access__c WHERE User__c IN :ContactUserIds LIMIT 50000] ;
    //Map to hold user and contact key-value pair
    Map<Id,Id> userContactMap=new Map<Id,Id>(); 
    
    //Loop through the contact users (with account change) in trigger scope to create a map of user Id and contact Id
        
        for(User contactUser : [SELECT Id,ContactId 
                                  FROM User
                                 WHERE ContactId IN: ContactIds]){

            userContactMap.put(contactUser.Id,contactUser.ContactId);
        }
        
    //Code to assign new account of contact to access setup record begins
    
    for(Portal_Tab_Access__c ptaRec : portaltabAccessList)
    ptaRec.Account__c = (userContactMap!=null && userContactMap.containsKey(ptaRec.User__c))?Trigger.NewMap.get(userContactMap.get(ptaRec.User__c)).AccountId : null ; 
    
    //Code to assign new account of contact to access setup record ends
    

    try{

        update portaltabAccessList;
    }
    catch(Exception ex){
    
        for(Portal_Tab_Access__c ptaRec : portaltabAccessList)
        ptaRec.addError('Exception While Modifying Portal Tab Access Record ---'+ex) ; 
    }
    
    
    //Portal_Tab_Access__c(Access Setup) Reparenting end
    
    */
}