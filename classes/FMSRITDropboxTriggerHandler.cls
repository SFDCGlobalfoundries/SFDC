/*
  Author: Anirban Roy
  Description: This is the trigger handler on RIT Drop box object to populate the FMS history records.
  History:
    ARoy        06122017    - code creation.     
	ARoy		28062017    - Added Trigger Framework and removed system debugs         
*/
public class FMSRITDropboxTriggerHandler extends TriggerHandler {
    
    public final Id mainZipRectypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('Main Zip File').getRecordTypeId();
    public final Id fileNameRectypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('File Name').getRecordTypeId();
    public final Id topCellNmRectypeid = Schema.SObjectType.FMS_RIT_Drop_Box__c.getRecordTypeInfosByName().get('TopCell Name').getRecordTypeId();
    public Id formId;
    
     public override void afterInsert(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
            fmsRITDropboxAfterInsert((Map<Id,FMS_RIT_Drop_Box__c>)trigger.newMap);
        }       
    }
    
    public override void afterUpdate(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
            fmsRITDropboxAfterUpdate(trigger.new,(Map<Id,FMS_RIT_Drop_Box__c>)trigger.newMap,(Map<Id,FMS_RIT_Drop_Box__c>)trigger.oldMap);
        }
    }    
    
    public override void beforeDelete(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
            fmsRITDropboxBeforeDelete((Map<Id,FMS_RIT_Drop_Box__c>)trigger.newMap,(Map<Id,FMS_RIT_Drop_Box__c>)trigger.oldMap);
        }
    }
    
    // For records inserted in RIT Dropbox : Form System History records insertion
    public void fmsRITDropboxAfterInsert(Map<Id,FMS_RIT_Drop_Box__c> fmsRITDropboxNewRecordMap){

        List<FMS_RIT_Drop_Box__c> ritDrpbxNewRecordList = fmsRITDropboxNewRecordMap.values();
        Map<String,String> ritDropboxMap = new Map<String,String>();
        ritDropboxMap = fmsRITValues(ritDrpbxNewRecordList);
        List<String> ritList = new List<String>();
        ritList.addAll(ritDropboxMap.keySet());
        List<String> ritDropboxKeys = getRITDropboxKeys(ritList);
        List<Form_System_History__c> fmsSysHistoryList = new List<Form_System_History__c>();
        for(String key : ritDropboxKeys){
             if(key != 'LastModifiedBy' && key != 'LastModifiedDate'){
                 Form_System_History__c fsh = new Form_System_History__c();
                 fsh.Field_Name__c = key;
                 fsh.Last_Modified_By__c = ritDropboxMap.get('LastModifiedBy');
                 fsh.Last_Modified_Date__c = DateTime.valueOf(ritDropboxMap.get('LastModifiedDate'));
                 fsh.Main_Form__c = formId;
                 fsh.New_Value__c = ritDropboxMap.get(key);
                 fmsSysHistoryList.add(fsh);
             }
        }
        if(!fmsSysHistoryList.isEmpty()){
            try{
                insert fmsSysHistoryList;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandler.class.getName(), 'fmsRITDropboxAfterInsert(Map<Id,FMS_RIT_Drop_Box__c> fmsRITDropboxNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }    
    }
    
    // For records updated in RIT Dropbox : Form System History records updation
    public void fmsRITDropboxAfterUpdate(List<FMS_RIT_Drop_Box__c> fmsRITDropboxNewList, Map<id, FMS_RIT_Drop_Box__c> fmsRITDropboxNewRecordMap, Map<Id, FMS_RIT_Drop_Box__c> fmsRITDropboxOldRecordMap){

        Map<String,String> ritNewDropboxMap = new Map<String,String>();
        Map<String,String> ritOldDropboxMap = new Map<String,String>();
        ritNewDropboxMap = fmsRITValues(fmsRITDropboxNewList);
        ritOldDropboxMap = fmsRITValues(fmsRITDropboxOldRecordMap.values());
        Set<String> newRITDropbxSet = ritNewDropboxMap.keySet();
        Set<String> oldRITDropbxSet = ritOldDropboxMap.keySet();
        Set<String> allRITDropbxSet = new Set<String>();
        allRITDropbxSet.addAll(newRITDropbxSet);
        allRITDropbxSet.addAll(oldRITDropbxSet);
        List<String> ritList = new List<String>();
        ritList.addAll(allRITDropbxSet);
        List<String> ritDropboxKeys = getRITDropboxKeys(ritList);
        List<Form_System_History__c> fmsSysHistoryList = new List<Form_System_History__c>();
        for(String key : ritDropboxKeys){
             if(key != 'LastModifiedBy' && key != 'LastModifiedDate'){
                 Form_System_History__c fsh = new Form_System_History__c();
                 fsh.Field_Name__c = key;
                 fsh.Last_Modified_By__c = ritNewDropboxMap.get('LastModifiedBy');
                 fsh.Last_Modified_Date__c = DateTime.valueOf(ritNewDropboxMap.get('LastModifiedDate'));
                 fsh.Main_Form__c = formId;
                 fsh.Old_Value__c = (ritOldDropboxMap.containsKey(key))?ritOldDropboxMap.get(key):'';
                 fsh.New_Value__c = (ritNewDropboxMap.containsKey(key))?ritNewDropboxMap.get(key):'';
                 if(fsh.Old_Value__c != fsh.New_Value__c){
                     fmsSysHistoryList.add(fsh);
                 }
             }
        }
        if(!fmsSysHistoryList.isEmpty()){
            try{
                insert fmsSysHistoryList;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandler.class.getName(), 'fmsRITDropboxAfterUpdate(List<FMS_RIT_Drop_Box__c> fmsRITDropboxNewList, Map<id, FMS_RIT_Drop_Box__c> fmsRITDropboxNewRecordMap, Map<Id, FMS_RIT_Drop_Box__c> fmsRITDropboxOldRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    // For records deleted in RIT Dropbox : Form System History records updation
    public void fmsRITDropboxBeforeDelete(Map < id, FMS_RIT_Drop_Box__c > fmsRITDropboxNewRecordMap, Map < Id, FMS_RIT_Drop_Box__c > fmsRITDropboxOldRecordMap){    

        Map<String,String> ritDropboxMap = new Map<String,String>();
        ritDropboxMap = fmsRITValues(fmsRITDropboxOldRecordMap.values());
        List<String> ritList = new List<String>();
        ritList.addAll(ritDropboxMap.keySet());
        List<String> ritDropboxKeys = getRITDropboxKeys(ritList);
        List<Form_System_History__c> fmsSysHistoryList = new List<Form_System_History__c>();
        for(String key : ritDropboxKeys){
             if(key != 'LastModifiedBy' && key != 'LastModifiedDate'){
                 Form_System_History__c fsh = new Form_System_History__c();
                 fsh.Field_Name__c = key;
                 fsh.Last_Modified_By__c = ritDropboxMap.get('LastModifiedBy');
                 fsh.Last_Modified_Date__c = DateTime.valueOf(ritDropboxMap.get('LastModifiedDate'));
                 fsh.Main_Form__c = formId;
                 fsh.Old_Value__c = ritDropboxMap.get(key);
                 fmsSysHistoryList.add(fsh);
             }  
        }
        if(!fmsSysHistoryList.isEmpty()){
            try{
                insert fmsSysHistoryList;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSRITDropboxTriggerHandler.class.getName(), 'fmsRITDropboxBeforeDelete(Map < id, FMS_RIT_Drop_Box__c > fmsRITDropboxNewRecordMap, Map < Id, FMS_RIT_Drop_Box__c > fmsRITDropboxOldRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    // RIT Dropbox Data For Form System History object
    public Map<String,String> fmsRITValues(List<FMS_RIT_Drop_Box__c> ritDrpbxRecordList){
        Map<String,String> ritDropboxMap = new Map<String,String>();
        Map<String,List<String>> ritDesignFileMap = new Map<String,List<String>>();
        Map<String,List<String>> ritDesignFileTopCellMap = new Map<String,List<String>>();
        Map<String,List<String>> ritTarZipTopCellMap = new Map<String,List<String>>();
        String newPackages='';

        for(FMS_RIT_Drop_Box__c ritDrpbxRecordValue: ritDrpbxRecordList){
            if(mainZipRectypeid == ritDrpbxRecordValue.recordtypeid){
                newPackages+=(!newPackages.contains(ritDrpbxRecordValue.Package_Name__c+'('+ritDrpbxRecordValue.Package_Id__c+')'))?ritDrpbxRecordValue.Package_Name__c+'('+ritDrpbxRecordValue.Package_Id__c+'), ':'';
                if(ritDrpbxRecordValue.senderEmail__c!=null){
                    ritDropboxMap.put(ritDrpbxRecordValue.Package_Name__c+' - Sender Email',ritDrpbxRecordValue.senderEmail__c);
                }
                if(ritDrpbxRecordValue.SentDate__c!=null){
                    ritDropboxMap.put(ritDrpbxRecordValue.Package_Name__c+' - Sender Date',String.valueOf(ritDrpbxRecordValue.SentDate__c));
                }
                if(ritDrpbxRecordValue.Drop_Box_File_Name__c!=null){
                    ritDropboxMap.put(ritDrpbxRecordValue.Package_Name__c+'/Dropbox Files',ritDrpbxRecordValue.Drop_Box_File_Name__c);
                }
                if(ritDrpbxRecordValue.Drop_Box_File_Size__c!=null){
                    ritDropboxMap.put(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+' - Size',ritDrpbxRecordValue.Drop_Box_File_Size__c);
                }
                if(ritDrpbxRecordValue.File_Type__c!=null){
                    ritDropboxMap.put(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+' - FileType',ritDrpbxRecordValue.File_Type__c);
                }                               
            }
            if(fileNameRectypeid == ritDrpbxRecordValue.recordtypeid){                                              
                if(ritDesignFileMap.containsKey(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/DesignFiles')){
                    ritDesignFileMap.get(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/DesignFiles').add(ritDrpbxRecordValue.Design_File_Name__c);
                }else{
                    ritDesignFileMap.put(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/DesignFiles',new List<String>{ritDrpbxRecordValue.Design_File_Name__c});
                }                                   
            }
            if(topCellNmRectypeid == ritDrpbxRecordValue.recordtypeid){
                if(ritDrpbxRecordValue.File_Type__c == 'TAR / TGZ / ZIP / Other Archive'){
                    if(ritTarZipTopCellMap.containsKey(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/'+ritDrpbxRecordValue.Design_File_Name__c+'/topCell')){
                        ritTarZipTopCellMap.get(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/'+ritDrpbxRecordValue.Design_File_Name__c+'/topCell').add(ritDrpbxRecordValue.TopCellName__c);
                    }else{
                        ritTarZipTopCellMap.put(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/'+ritDrpbxRecordValue.Design_File_Name__c+'/topCell',new List<String>{ritDrpbxRecordValue.TopCellName__c});
                    }
                }else if(ritDrpbxRecordValue.File_Type__c == 'Design File'){
                    if(ritDesignFileTopCellMap.containsKey(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/topCell')){
                        ritDesignFileTopCellMap.get(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/topCell').add(ritDrpbxRecordValue.TopCellName__c);
                    }else{
                        ritDesignFileTopCellMap.put(ritDrpbxRecordValue.Package_Name__c+'/'+ritDrpbxRecordValue.Drop_Box_File_Name__c+'/topCell',new List<String>{ritDrpbxRecordValue.TopCellName__c});
                    }
                }
            }

            if(!ritDropboxMap.containsKey('LastModifiedDate')){
                ritDropboxMap.put('LastModifiedDate',String.valueOf(ritDrpbxRecordValue.lastmodifiedDate));
            }
            if(!ritDropboxMap.containsKey('LastModifiedBy')){
                ritDropboxMap.put('LastModifiedBy',UserInfo.getName());
            }

            if(formId == null){
                formId = ritDrpbxRecordValue.form_Id__c;
            }
        }
        newPackages=newPackages.removeEnd(', ');

        if(newPackages!=''){
            ritDropboxMap.put('Package Name(ID)',newPackages);
        }           
        
        for(String key : ritDesignFileMap.keySet()){
            String designFileName = ''; 
            for(String dfn : ritDesignFileMap.get(key) ){
                designFileName += dfn+', ';
            }
            designFileName = designFileName.removeEnd(', ');
            if(designFileName!=''){
                ritDropboxMap.put(key,designFileName);
            }
        }
        
        for(String key : ritTarZipTopCellMap.keySet()){
            String tarZipTopCellName = '';
            for(String tzipTopCell : ritTarZipTopCellMap.get(key) ){
                tarZipTopCellName += tzipTopCell+', ';
            }
            tarZipTopCellName = tarZipTopCellName.removeEnd(', ');
            if(tarZipTopCellName!=''){
                ritDropboxMap.put(key,tarZipTopCellName);
            }
        }
        
        for(String key : ritDesignFileTopCellMap.keySet()){
            String designTopCellName = '';
            for(String designTopCell : ritDesignFileTopCellMap.get(key) ){
                designTopCellName += designTopCell+', ';
            }
            designTopCellName = designTopCellName.removeEnd(', ');
            if(designTopCellName!=''){
                ritDropboxMap.put(key,designTopCellName);
            }
        }
        return ritDropboxMap;
    }
    
    //Get the RIT Dropbox keys in a sorted order
    private List<String> getRITDropboxKeys(List<String> ritDropBoxKeyList){
        if(ritDropBoxKeyList!=null && ritDropBoxKeyList.size()>0){
            Integer count=0;
            Boolean isCheck=false;
            for(String ritDropboxKey : ritDropBoxKeyList){
                if(ritDropboxKey == 'Package Name(ID)'){
                    isCheck=true;
                    break;
                }
                count++;
            }
            if(isCheck){
                ritDropBoxKeyList.remove(count);
                ritDropBoxKeyList.sort();
                ritDropBoxKeyList.add('Package Name(ID)');
            }
        }
        return ritDropBoxKeyList;
    }
}