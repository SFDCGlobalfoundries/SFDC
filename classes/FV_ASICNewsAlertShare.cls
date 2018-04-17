/*------------------------------------------------------------  
Author:        Prajnith Karra
Company:       Global Foundries
Description:   A class which shares/delete permission to  all the ASIC Alert records to Account releated contacts
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/
public class FV_ASICNewsAlertShare
{


    public static void onAfterUpdate(Map<Id,Document_Provisioning__c> newMap, Map<Id,Document_Provisioning__c> oldMap)
    {                                      
            set<ID> dpIDs = new set<ID>();              
             for(Document_Provisioning__c dp: newMap.values()){            
                     if(dp.Sub_PDK__c != null && ( trigger.isInsert ||oldMap.get(dp.ID).Status__c != dp.Status__c)){   
                           if( (dp.Status__c == 'Provisioned' || dp.Status__c == 'IPLAProvision' || dp.Status__c == 'De-Provisioned' || dp.Status__c == 'Rejected' || dp.Status__c == 'IPLADeprovision')){
                                dpIDs.add(dp.ID);   
                           }                                  
                       }
             }
             if(!dpIDs.isEmpty())
                 EnableSharing(dpIDs,'FROMDP');
            
                                                
    }
    @future
    public static void EnableSharing(set<ID> DPids,string source){               
            map<ID,Document_Provisioning__c> DPMap = new map<ID,Document_Provisioning__c>([SELECT ID,
                                                                                                  Sub_PDK__r.PDK__C,
                                                                                                  AccountID__c,
                                                                                                  Sub_PDK__c,
                                                                                                  Status__c
                                                                                                  FROM Document_Provisioning__c 
                                                                                                  WHERE ID IN: DPids
                                                                                                  AND
                                                                                                  Sub_PDK__c != null
                                                                                                  AND
                                                                                                  Sub_PDK__r.PDK__r.Master_PDK_ASIC__c =: true
                                                                                          ]);                                                 
            if(DPMap.isEmpty()){
                return; 
            }
            
            set<ID> allAccIDs  = new set<ID>();                                                 
            map<ID,set<ID>> masterPDKMap = new map<ID,set<ID>>();
            map<ID,list<User>> accountPortalUsers = new map<ID,list<User>>();            
            map<ID,ID> allAccountIDsMap = new map<ID,ID>();    
            map<ID,Boolean> ProvSharingMap = new map<ID,Boolean>();
            map<ID,list<User>> MasterPDKUsers = new map<ID,list<User>>();
                    
             
            // check if status is changed.
            // get accountds ids                           
            for(Document_Provisioning__c dp: DPMap.values()){            
               if(dp.Sub_PDK__c != null ){                               
                     if( dp.Status__c == 'Provisioned' || dp.Status__c == 'IPLAProvision' ){
                         allAccIDs.add(dp.AccountID__c);
                         ProvSharingMap.put(DPMap.get(dp.ID).Sub_PDK__r.PDK__C,true);                         
                         if(masterPDKMap.containsKey(DPMap.get(dp.ID).Sub_PDK__r.PDK__C)){
                            masterPDKMap.get(DPMap.get(dp.ID).Sub_PDK__r.PDK__C).add(dp.AccountID__c);                                                           
                         }
                         else{
                             masterPDKMap.put(DPMap.get(dp.ID).Sub_PDK__r.PDK__C,new set<ID>());     
                             masterPDKMap.get(DPMap.get(dp.ID).Sub_PDK__r.PDK__C).add(dp.AccountID__c);                                                         
                         }                        
                     }
                                          
                     if(dp.Status__c == 'De-Provisioned' || dp.Status__c == 'Rejected' || dp.Status__c == 'IPLADeprovision'){
                         allAccIDs.add(dp.AccountID__c);
                         ProvSharingMap.put(DPMap.get(dp.ID).Sub_PDK__r.PDK__C,false);                       
                         if(masterPDKMap.containsKey(DPMap.get(dp.ID).Sub_PDK__r.PDK__C)){
                            masterPDKMap.get(DPMap.get(dp.ID).Sub_PDK__r.PDK__C).add(dp.AccountID__c);                                                           
                         }
                         else{
                             masterPDKMap.put(DPMap.get(dp.ID).Sub_PDK__r.PDK__C,new set<ID>());     
                             masterPDKMap.get(DPMap.get(dp.ID).Sub_PDK__r.PDK__C).add(dp.AccountID__c);                                                         
                         } 
                     }                                                                                     
               }
            }                                            
            // get all the portal user from accounts.       
            for(user oUser :[SELECT ID,Contact.AccountID,ContactID FROM User WHERE IsActive =: true AND ContactID != null AND Contact.AccountID IN: allAccIDs AND Contact.Is_Portal_User_Active__c=:true]){
                if(!accountPortalUsers.containsKey(oUser.Contact.AccountID)){            
                   accountPortalUsers.put(oUser.Contact.AccountID,new list<User>()); 
                   accountPortalUsers.get(oUser.Contact.AccountID).add(oUser );
                 }
                 else{
                   accountPortalUsers.get(oUser.Contact.AccountID).add(oUser );                                    
                 }                                
            }
            
            // map users and master PDK
            for(ID oMasterPDKID : masterPDKMap.keyset()){ // Master PDK ID
                    for(ID oAccountID : masterPDKMap.get(oMasterPDKID)){ // Account IDs
                          if(accountPortalUsers.containsKey(oAccountID))    
                          for(User oUser : accountPortalUsers.get(oAccountID )){ // users
                              if(!MasterPDKUsers.containskey(oMasterPDKID)){
                                  MasterPDKUsers.put(oMasterPDKID,new list<User>());
                                  MasterPDKUsers.get(oMasterPDKID).add(oUser);                                  
                               }
                               else{
                                   MasterPDKUsers.get(oMasterPDKID).add(oUser);                               
                               }
                          }
                    }
            }
            
            if(!MasterPDKUsers.isEmpty())    
                updateSharing(masterPDKMap,MasterPDKUsers,ProvSharingMap);
    }
    public static void updateSharing(map<ID,set<ID>> masterPDKMap,map<ID,list<User>> MasterPDKUsers,map<ID,Boolean> ProvSharingMap){
        map<ID,list<ASIC_News_Alert__Share>> newSharemap = new map<ID,list<ASIC_News_Alert__Share>>(); 
        map<ID,set<ID>> deleteShareRecords = new map<ID,set<ID>>();
            
        // get all news and Alert from Master PDK.                           
        for(ASIC_News_Alert__c oAlert : [SELECT ID,Master_PDK__c,Active__c FROM ASIC_News_Alert__c WHERE Master_PDK__c IN: masterPDKMap.keyset()]){
               if(masterPDKUsers.containsKey((oAlert.Master_PDK__c))){            
                  for(user oUser : masterPDKUsers.get(oAlert.Master_PDK__c)){
                       ASIC_News_Alert__Share tempShare = new ASIC_News_Alert__Share();  
                       tempShare.ParentId = oAlert.ID;
                       tempShare.UserOrGroupId =  oUser.ID;                      
                           if(ProvSharingMap.containsKey(oAlert.Master_PDK__c) && ProvSharingMap.get(oAlert.Master_PDK__c)){
                                tempShare.AccessLevel = 'Read';
                               if(!newSharemap.containsKey(tempShare.ParentId))
                                    newSharemap.put(tempShare.ParentId,new list<ASIC_News_Alert__Share>());                                                                                                   
                               newSharemap.get(tempShare.ParentID).add(tempShare);                                                                                                            
                           }
                           if(ProvSharingMap.containsKey(oAlert.Master_PDK__c) && !ProvSharingMap.get(oAlert.Master_PDK__c)){                                                                       
                                if(!deleteShareRecords.containsKey(tempShare.ParentId))
                                    deleteShareRecords.put(tempShare.ParentId,new set<ID>()); 
                                deleteShareRecords.get(tempShare.ParentID).add(tempShare.UserOrGroupId);                                                                                                                                      
                           }                                                                                                                                            
                  }
               }                                                 
        }                                  
        try{        
        if(!newSharemap.isEmpty()){
            list<ASIC_News_Alert__Share> allShares = new list<ASIC_News_Alert__Share>();
            for(list<ASIC_News_Alert__Share> oShareList : newSharemap.values()){
                allShares.addAll(oShareList );
            }
            insert allShares;                        
        }
        if(!deleteShareRecords.isEmpty()){
            set<ID> allDeleteShares = new set<ID>();
            for(set<ID> oShareset : deleteShareRecords.values()){
                allDeleteShares.addAll(oShareset);
            }           
            list<ASIC_News_Alert__Share> toDelete =  [SELECT ID FROM ASIC_News_Alert__Share WHERE ParentId IN:deleteShareRecords.keyset() AND userorGroupID IN: allDeleteShares AND RowCause = 'Manual'];
            if(!toDelete.isEmpty())
                delete toDelete;                                            
        }
        }
        catch(Exception e){
        GlobalUtility.logMessage('Error', 
                                     'FV_ASICNewsAlertShare', 
                                     'updateSharing', 
                                     '', 
                                     'ASIC', 
                                     'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),
                                     '',
                                     'PDK',
                                     e,
                                     2300);
        }
    }

}