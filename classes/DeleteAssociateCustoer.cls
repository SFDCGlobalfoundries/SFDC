public with sharing class DeleteAssociateCustoer 
{
 public static void  CreateDeleteObject(Map<String,String> MapId,String source)
    {
        List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
        List<DeleteObjectFromOpenText__c> DeleteObjectInsertList = new List<DeleteObjectFromOpenText__c>();
        DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c = 'SUCCESS' limit 999];
        for(String id: MapId.keySet())
        {
            DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
            deleteobjectIns.OpenTextId__c = '';
            deleteobjectIns.SFDCId__c = id;
            deleteobjectIns.Source__c = source;
            deleteobjectIns.CustomerName__c = MapId.get(id);
            DeleteObjectInsertList.add(deleteobjectIns);
        }
    try
    {
    if(DeleteObjectList != null && DeleteObjectList.size() > 0)
    delete DeleteObjectList; 
    insert DeleteObjectInsertList;
    
    }
    catch(Exception e)
    {
    system.debug('Exception during deleteobject Insertion or deletion is'+e);
    }
    }
 }