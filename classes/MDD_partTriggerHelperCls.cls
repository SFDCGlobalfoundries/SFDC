/* 
 Type Name: MDD_partTriggerHelperCls
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Trigger helper for giving and removing part family access to Users.
 
 */
public class MDD_partTriggerHelperCls {
    public void getFolderLinks(List<Part__c> lstPart){
        Set<String> family = new Set<String>();
        Map<String,Id> mapFamilyAttachments = new Map<String,Id>();
        Set<Id> partId = new Set<Id>();
        for(Part__c p : lstPart){
            family.add(p.Part_Family__c);
            partId.add(p.Id);
        }
        List<Part_Family__c> lstFamily = [Select Id, Name,(SELECT id,name FROM Attachments) from Part_Family__c where Name In :family ];
        for(Part_Family__c f : lstFamily){
            mapFamilyAttachments.put(f.Name, f.id);
        }
        for(Part__c p : lstPart){
            if(mapFamilyAttachments.get(p.Part_Family__c) != null){
                String str = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MDD_PartFamilyViewOverride?id='+mapFamilyAttachments.get(p.Part_Family__c);
                p.Folder_Link__c = str;
            }
            else{
                String str = '';
                p.Folder_Link__c = str;
            }
        }
    }
    public void removeShare(Map<Id,Part__c> oldPartMap,Map<Id,Part__c> partMap){
        Set<String> stoldFamily = new Set<String>();
        Set<Id> partIds = new Set<Id>();
        Map<Id,String> accessPartFamily = new Map<Id,String>();
        Set<String> family = new Set<String>();
        for(Part__c p : partMap.values()){
            stoldFamily.add(oldPartMap.get(p.Id).Part_Family__c);
            family.add(p.Part_Family__c);
        }
        for(Part__c p : [Select Name, Id, Part_Family__c from Part__c where Part_Family__c in: stoldFamily and Id not In: trigger.new]){
            partIds.add(p.Id);
        }
        for(Account_Part_Map__c a : [Select Id,Name,Account__c,Part__r.Part_Family__c from Account_Part_Map__c where Part__c IN: partIds]){
            accessPartFamily.put(a.Account__c,a.Part__r.Part_Family__c);
        }
        Map<Id,Id> conAccMap = new Map<Id,Id>();
        for(Contact con: [Select Id, AccountId from Contact where AccountId in: accessPartFamily.keySet()]){
            conAccMap.put(con.Id,con.AccountId);
        }
        Set<Id> userIds = new Set<Id>();
        for(User u: [Select Id, ContactId from User where ContactId in: conAccMap.KeySet()]){
            userIds.add(u.Id);
        }
        
        Set<Id> partId = new Set<Id>();
        Set<Id> famIds = new Set<Id>();
        
        Map<String,List<Part__c>> mapPart = new Map<String,List<Part__c>>();
        List<Part_Family__c> lstFam = [Select Id,Name from Part_Family__c where Name IN : stoldFamily and Name not IN: accessPartFamily.Values()];
        for(Part_Family__c f : lstFam){
            famIds.add(f.Id);
        }
        List<Part_Family__Share> oldFamilyShrs = [SELECT Id FROM Part_Family__Share WHERE ParentId IN :famIds AND RowCause = :Schema.Part_Family__Share.RowCause.Family_Access__c AND UserOrGroupId not in: userIds];
        if(oldFamilyShrs.size() > 0)
            delete oldFamilyShrs;
    }
    public void addShareForFamily(List<Part__c> lstPart){
        Set<String> family = new Set<String>();
        Set<Id> partId = new Set<Id>();
        Set<Id> stAccIds = new Set<Id>();
        Map<String,List<Id>> mapAccId = new Map<String,List<Id>>();
        Map<Id,List<Contact>> mapContacts = new Map<Id,List<Contact>>();
        Map<Id,String> mapPart = new Map<Id,String>();
        List<Part_Family__Share> familyShrs = new List<Part_Family__Share>();
        Part_Family__Share familyToShare;
        for(Part__c p : lstPart){
            family.add(p.Part_Family__c);
            partId.add(p.Id);
            mapPart.put(p.Id,p.Part_Family__c);
        }
        List<Account_Part_Map__c> mapAccPart = [Select Id, Name,Account__c,Part__c from Account_Part_Map__c where Part__c IN: partId];
        for(Account_Part_Map__c a : mapAccPart){
            List<Id> tempId = new List<Id>();
            if(mapAccId.containsKey(mapPart.get(a.Part__c))){
                tempId.addAll(mapAccId.get(mapPart.get(a.Part__c)));
                tempId.add(a.Account__c);
                mapAccId.put(mapPart.get(a.Part__c),tempId);
                stAccIds.AddAll(mapAccId.get(mapPart.get(a.Part__c)));
            }
            else{
                tempId.add(a.Account__c);
                mapAccId.put(mapPart.get(a.Part__c),tempId);
                stAccIds.AddAll(mapAccId.get(mapPart.get(a.Part__c)));
            }
        }
        List<Contact> lstContact = [Select Id,Name,AccountId from Contact where AccountId IN: stAccIds];
        Set<Id> conId = new Set<Id>();
        Map<Id,User> mapUser = new Map<Id,User>();
        for(Contact c : lstContact){
            conId.add(c.Id);
            List<Contact> con= new List<Contact>();
            if(mapContacts.containsKey(c.AccountId)){
                con.addAll(mapContacts.get(c.AccountId));
                con.add(c);
                mapContacts.put(c.AccountId,con);
            }
            else{
                con.add(c);
                mapContacts.put(c.AccountId,con);
            }
        }
        for(User u : [Select Id,Name,ContactId,IsActive from User where ContactId IN: conId and IsActive = true]){
            mapUser.put(u.ContactId,u);
        }
        List<Part_Family__c> prtFamily = [Select Id,Name from Part_Family__c where Name IN: family];
        for(Part_Family__c job : prtFamily){
            if(mapAccId.containsKey(job.Name)){
                for(Id AccId : mapAccId.get(job.Name)){
                    if(mapContacts.containsKey(AccId)){
                        for(Contact c : mapContacts.get(AccId)){
                            if(mapUser.containsKey(c.Id)){
                                familyToShare = new Part_Family__Share();
                                familyToShare.ParentId = job.Id;
                                familyToShare.UserOrGroupId = mapUser.get(c.Id).Id;
                                familyToShare.AccessLevel = 'read';
                                familyToShare.RowCause = Schema.Part_Family__Share.RowCause.Family_Access__c;
                                familyShrs.add(familyToShare);     
                            }
                        }
                    }
                }
            }
        }
        if(familyShrs.size() > 0)
        insert familyShrs;
    }
}