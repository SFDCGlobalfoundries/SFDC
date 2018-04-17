public class EmailConfigSettingsUtility {
    private static boolean run = true;
    
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public static boolean compareSet(set<String> largerSet,set<String> smallSet){
        for(String item1: largerSet){
            for(String item2 : smallSet){
                if(Decimal.valueOf(item1) == Decimal.valueOf(item2)){
                    return true;
                }
            }
        }
        return false;
    }

    public static set<String> splitStringTechGeoValues(String techGeoValue){
         set<string> setTechGeoValue = new set<string>();
         if(techGeoValue != null){
            if(techGeoValue.contains(';')){
                setTechGeoValue.addAll(techGeoValue.split(';')); 
            }else{
                setTechGeoValue.add(techGeoValue); 
             } 
          } 
    return setTechGeoValue;     
    }
    
    public static Id fetchRecordTypeId(String recordTypeName){
        Id genericRecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return genericRecordTypeId;
    }
    
    public static void recordTypePtrfValidationForInsert(List<Email_Config_Settings__c> newEmailConfigSettingList,List<Email_Config_Settings__c> oldEmailConfigSettingList){
        Id ptrfRecordTypeId = fetchRecordTypeId('PTRF');
        Id mstRecordTypeId = fetchRecordTypeId('MST');
        Id maskshopRecordTypeId = fetchRecordTypeId('Maskshop');
        Id mstNoMaskLayerRecordTypeId = fetchRecordTypeId('MST-No Mask Layers');
        for(Email_Config_Settings__c  newRec : newEmailConfigSettingList){
            for(Email_Config_Settings__c  oldRec : oldEmailConfigSettingList){
                 if(newRec.RecordTypeId == ptrfRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c && newRec.Gating_Jobview__c == oldRec.Gating_Jobview__c){
                            set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                            set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                            if(oldTechGeoValueSet.size() >= newTechGeoValueSet.size()){
                                if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                }
                            }else if(oldTechGeoValueSet.size() < newTechGeoValueSet.size()){
                                if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                }
                            }
                        }
                 }else if(newRec.RecordTypeId == mstRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                            set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                            if(oldTechGeoValueSet.size() >= newTechGeoValueSet.size()){
                                if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                }
                            }else if(oldTechGeoValueSet.size() < newTechGeoValueSet.size()){
                                if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                }
                            }
                        }
                 }else if(newRec.RecordTypeId == maskshopRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                            set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                            if(oldTechGeoValueSet.size() >= newTechGeoValueSet.size()){
                                if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                }
                            }else if(oldTechGeoValueSet.size() < newTechGeoValueSet.size()){
                                if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                }
                            }
                        }
                 }else if(newRec.RecordTypeId == mstNoMaskLayerRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                        }
                 }
            }
        }
    }
    
    public static void recordTypePtrfValidationforUpdate(List<Email_Config_Settings__c> newEmailConfigSettingList,List<Email_Config_Settings__c> oldEmailConfigSettingList){
        Id ptrfRecordTypeId = fetchRecordTypeId('PTRF');
        Id mstRecordTypeId = fetchRecordTypeId('MST');
        Id maskshopRecordTypeId = fetchRecordTypeId('Maskshop');
        Id mstNoMaskLayerRecordTypeId = fetchRecordTypeId('MST-No Mask Layers');
        for(Email_Config_Settings__c  newRec : newEmailConfigSettingList){
            for(Email_Config_Settings__c  oldRec : oldEmailConfigSettingList){
                if(newRec.Name != oldRec.Name){
                     if(newRec.RecordTypeId == ptrfRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                            if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c && newRec.Gating_Jobview__c == oldRec.Gating_Jobview__c){
                                set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                                set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                                if(oldTechGeoValueSet.size() > newTechGeoValueSet.size()){
                                    if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                        newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                    }
                                }else if(oldTechGeoValueSet.size() <= newTechGeoValueSet.size()){
                                    if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                        newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                    }
                                }
                            }
                     }else if(newRec.RecordTypeId == mstRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                            set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                            if(oldTechGeoValueSet.size() >= newTechGeoValueSet.size()){
                                if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                }
                            }else if(oldTechGeoValueSet.size() < newTechGeoValueSet.size()){
                                if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                }
                            }
                        }
                    }else if(newRec.RecordTypeId == maskshopRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            set<string> oldTechGeoValueSet = splitStringTechGeoValues(oldRec.Tech_Geo_Value__c);
                            set<string> newTechGeoValueSet = splitStringTechGeoValues(newRec.Tech_Geo_Value__c);
                            if(oldTechGeoValueSet.size() >= newTechGeoValueSet.size()){
                                if(compareSet(oldTechGeoValueSet,newTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                                }
                            }else if(oldTechGeoValueSet.size() < newTechGeoValueSet.size()){
                                if(compareSet(newTechGeoValueSet,oldTechGeoValueSet)){
                                    newRec.addError(system.Label.ECS_PartialTechGeoExists + oldRec.Name); 
                                }
                            }
                        }
                    }else if(newRec.RecordTypeId == mstNoMaskLayerRecordTypeId && newRec.RecordTypeId == oldRec.RecordTypeId && newRec.Email_Template_Name__c == oldRec.Email_Template_Name__c){
                        if(newRec.MPW_PTRF__c == oldRec.MPW_PTRF__c){
                            newRec.addError(system.Label.ECS_DuplicateTechGeoExists + oldRec.Name); 
                        }
                    }
                } 
            }
        }
    }
}