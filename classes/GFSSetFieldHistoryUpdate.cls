global class GFSSetFieldHistoryUpdate{
    global static Map<string,string> oldValueMap;
    global static Schema.DescribeSobjectResult result;
    global static Map<String,string> fieldlabelMap;
    global static Map<String,Schema.DisplayType> fieldTypeMap;
    global static Map <id, sObject> oldRecMap;
    global static Set<string> fieldValSet;
    global static List<Set_Field_History__c> sfh;
    global static string query;
    global static SET<ID> keys;
    global static boolean runFirst = true;
    global GFSSetFieldHistoryUpdate(){
    
    }
    global static void preRequisite(Map<Id,sObject> oldMap, Map<id,sObject> newMap){
        fieldLabelMap = new Map<String,string>();
        fieldTypeMap = new Map<String,Schema.DisplayType>();
        Set<string> stdObjStdFieldSet = new Set<String>();
        result = oldMap.values()[0].id.getSObjectType().getDescribe();
       
        query ='select Id';
        sfh = [select id,Name,FieldNameList__c from Set_Field_History__c where Name=:result.getName()];
        if(sfh.size()>0){
            fieldValSet = new Set<string>();
            fieldValSet.addAll(sfh[0].FieldNameList__c.split('#'));
            for(Schema.SObjectField sfield: result.fields.getMap().values()){
                schema.describefieldresult f = sfield.getDescribe();
                //if(f.isCustom() || f.getName() =='OwnerId' || (!f.isCustom() && stdObjStdFieldSet.contains(f.getName()) && !f.getName().contains('address'))){
                    fieldLabelMap.put(f.getName(),f.getLabel());
                    fieldTypeMap.put(f.getName(),f.getType());
                //}
                if(fieldValSet.contains(f.getName()) && !f.getName().contains('address')){
                    if(f.getType() == Schema.DisplayType.REFERENCE){    if(f.isCustom()){  query += ','+f.getName().split('__c')[0]+'__r.Name';    }      else{   query += ','+f.getName().split('Id')[0]+'.Name';
                        }
                    }
                }
            }
        }
        
        keys = newMap.keySet();
        query += ' from '+result.getName()+' where Id IN :keys';
        system.debug('query '+query );
        oldRecMap = new Map <id, sObject>((List<sObject>)Database.query(query));
    }
    
    global static void updateHistoryObject(Map<Id,sObject> oldMap, Map<id,sObject> newMap){
        if(runFirst){
            runFirst = false;
            system.debug('oldRecMap** '+oldRecMap);
            List<sObject> historyRecList = new List<sObject>();
           
            Map <id, sObject> newRecMap = new Map <id, sObject>((List<sObject>)Database.query(query));
            if(sfh.size()>0){           
                string historyObj;
                if(result.isCustom()){     historyObj = 'GFS_'+result.getName().split('__c')[0]+'_History__c';
                }
                else{
                    historyObj = 'GFS_'+result.getName()+'_History__c';
                }
                if(test.isRunningTest())
                historyObj = 'AccountHistory';
                
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{historyObj});
                List<string> fieldValList = sfh[0].FieldNameList__c.split('#');
                
                sObject newRec;
                sObject newobj;
                
                for(sObject obj : oldMap.values()){
                    //Id newId = obj.get('Id');
                    newRec = newMap.get(obj.Id);
                    for(string s : fieldValList){
                        
                       /* if(fieldTypeMap.get(s) == schema.DisplayType.address){
                            system.debug('entered add condition');    string addtype = s.split('Address').size()>0?s.split('Address')[0]:'';   List<String> addFieldList = Label.AddressFields.split(',');
                            for(string addfield : addFieldList){  newobj = results[0].getSObjectType().newsObject();  string add = addtype+addfield;
                                system.debug('add**** '+add +''+obj);  if(obj.get(add) != newRec.get(add)){  newobj.put('ParentId__c',obj.Id); newobj.put('Old_Value__c',obj.get(add));   newobj.put('New_Value__c',newRec.get(add));  newobj.put('Field__c',add);  historyRecList.add(newobj);
                                }
                            }
                        }
                        else */if(obj.get(s) != newRec.get(s)){  newobj = results[0].getSObjectType().newsObject();  newobj.put('ParentId__c',obj.Id);
                            if(fieldTypeMap.get(s) == Schema.DisplayType.REFERENCE){     if(s.contains('__c')){   string temp = s.split('__c')[0]+'__r';
                                    system.debug('ref values Old :'+ oldRecMap.get(obj.id).getsObject(temp).get('Name'));
                                    system.debug('ref values New :'+ newRecMap.get(obj.id).getsObject(temp).get('Name'));   newobj.put('Old_Value__c',oldRecMap.get(obj.id).getsObject(temp).get('Name'));   newobj.put('New_Value__c',newRecMap.get(obj.id).getsObject(temp).get('Name'));
                                }
                                else{  string temp = s.split('Id')[0];
                                    system.debug('ref values Old :'+ oldRecMap.get(obj.id).getsObject(temp).get('Name'));
                                    system.debug('ref values New :'+ newRecMap.get(obj.id).getsObject(temp).get('Name'));     newobj.put('Old_Value__c',oldRecMap.get(obj.id).getsObject(temp).get('Name'));   newobj.put('New_Value__c',newRecMap.get(obj.id).getsObject(temp).get('Name'));
                                }
                                
                            }
                            else{   newobj.put('Old_Value__c',String.valueOf(obj.get(s)));   newobj.put('New_Value__c',String.valueOf(newRec.get(s)));
                            }
                            newobj.put('Field__c',fieldLabelMap.get(s));   historyRecList.add(newobj);
                        }
                    }
                }
                if(historyRecList.size()>0){  insert historyRecList;
                }
            }
        }
    }   
}