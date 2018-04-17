/*
Type Name: Controller class for PDK_9_10_Outlook
Author: Ravikiran Nadella
Created Date: 12/28/2017
*/


public class  PDK_OutlookController {
    
    public Map<id,ContentVersion> cntMap{get; set;}
    public map<id,ContentDistribution> cdnMap{get; set;}
    public set<Id> cdnSet;
    
    
    public PDK_OutlookController(){
        
        cdnMap = new  map<id,ContentDistribution>();
        cntMap = new Map<id,ContentVersion>();
        cdnSet  = new set<Id>();
        Environment_Variable__c setting = Environment_Variable__c.getInstance('PDK release');
        if(setting<>null){
            Id WrkSpcId = [SELECT DeveloperName FROM ContentWorkspace where DeveloperName =:setting.value__c].id;
            for(ContentDocument cd :[select id from ContentDocument where ParentId=:WrkSpcId]){
                cdnSet.add(cd.id);
            }
        }
        for(contentVersion cn :[Select id,ContentUrl,title,Description,ContentModifiedDate,
                                FileType from contentVersion where ContentDocumentId in :cdnSet]) {
            cntMap.put(cn.id,cn);}
        
        ContentDVersions();
    }
    
    
    public void ContentDVersions() {
        
        for(ContentDistribution cd1 :[SELECT id,RelatedRecordId,ContentVersion.Title,
                                      ContentVersion.Description,ContentDocumentId,ContentVersionId,
                                      DistributionPublicUrl FROM ContentDistribution
                                      where ContentVersionId In:cntMap.keyset()]){   cdnMap.put(cd1.ContentVersionId,cd1);}
        
    }
    
}