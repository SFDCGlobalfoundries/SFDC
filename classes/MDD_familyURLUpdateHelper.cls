/* 
Type Name: MDD_familyURLUpdateHelper
Author: JKTechnosoft
Created Date: 13-July-2016
Reason: Part_Family__c trigger helper classs for generation of url on the insert or update 
of records.

*/
public class MDD_familyURLUpdateHelper{
    public void getFolderLinks(List<Part_Family__c> lstFamily){
        Set<String> stNewFamily = new Set<String>();
        Map<String,Id> mapNewVal = new Map<String,Id>();
        List<Part__c> finalparts = new List<Part__c>();
        for(Part_Family__c f : lstFamily){
            stNewFamily.add(f.Name);
            mapNewVal.put(f.Name,f.Id);
        }
        List<Part__c> lstPart = [Select Id,Name,Folder_Link__c,Part_Number__c,Part_Family__c,Part_Type__c from Part__c where Part_Family__c IN: stNewFamily];
        for(Part__c p : lstPart){
            if(mapNewVal.get(p.Part_Family__c) != null){
                String str = URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapNewVal.get(p.Part_Family__c);
                p.Folder_Link__c = str;
            }
            finalparts.add(p);
        }
        try{
            if(finalparts.size() > 0)
            update finalparts;
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error','MDD_familyURLUpdateHelper','getFolderLinks','','Exception while updating URL Links',String.valueof(e.getMessage()),'','MDD Parts Search',e,0);
        }
        
    }
    public void getOldFolderLinks(List<Part_Family__c> lstFamily,List<Part_Family__c> lstOldFamily){
        Set<String> stNewFamily = new Set<String>();
        Set<String> stOldFamily = new Set<String>();
        Map<String,Id> mapNewVal = new Map<String,Id>();
        List<Part__c> finalparts = new List<Part__c>();
        List<Part__c> finalNewparts = new List<Part__c>();
        Map<String,List<Id>> mapAccId = new Map<String,List<Id>>();
        Map<Id,List<Contact>> mapContacts = new Map<Id,List<Contact>>();
        Map<Id,String> mapPart = new Map<Id,String>();
        List<Part_Family__Share> familyShrs = new List<Part_Family__Share>();
        Part_Family__Share familyToShare;
        Set<Id> partId = new Set<Id>();
        Set<Id> stAccIds = new Set<Id>();
        Set<Id> famIds = new Set<Id>();
        Set<String> family = new Set<String>();
        
        for(Part_Family__c f : lstFamily){
            stNewFamily.add(f.Name);
            mapNewVal.put(f.Name,f.Id);
        }
        for(Part_Family__c f : lstOldFamily){
            stOldFamily.add(f.Name);
        }
        List<Part__c> lstPart = [Select Id,Name,Folder_Link__c,Part_Number__c,Part_Family__c,Part_Type__c from Part__c where Part_Family__c IN: stOldFamily];
        for(Part__c p : lstPart){
            String str = '';
            p.Folder_Link__c = str;
            finalparts.add(p);
        }
        List<Part__c> lstPart1 = [Select Id,Name,Folder_Link__c,Part_Number__c,Part_Family__c,Part_Type__c from Part__c where Part_Family__c IN: stNewFamily];
        for(Part__c p : lstPart1){
            String str = URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapNewVal.get(p.Part_Family__c);
            p.Folder_Link__c = str;
            finalNewparts.add(p);
            partId.add(p.Id);
            mapPart.put(p.Id,p.Part_Family__c);
        }
        try{
            if(finalparts.size() > 0)
                update finalparts;
            if(finalNewparts.size() > 0)
                update finalNewparts;
        }
        catch(Exception e){
			GlobalUtility.logMessage('Error','MDD_familyURLUpdateHelper','getFolderLinks','','Exception while updating URL Links',String.valueof(e.getMessage()),'','MDD Parts Search',e,0);
    	}
    }
}