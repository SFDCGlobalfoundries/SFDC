public class VoCScoreTriggerUtil{

    public static void manageTrends(List<VoC_Score__c> newRec, Map<Id,VoC_Score__c> oldRecMap, String event){
        Set<ID> contactId = new Set<ID>();
        List<VoC_Score__c> listToProcess = new List<VoC_Score__c>();
        Map<ID,Map<String,Decimal>> mapContactsVoCScore = new Map<ID,Map<String,Decimal>>();
        Map<ID,Map<String,Decimal>> mapContactsVoCCOunt = new Map<ID,Map<String,Decimal>>();        
        List<Contact> contactList = new List<Contact>();
        Map<String,VoCAreaTrend__c> vocTrend = VoCAreaTrend__c.getAll();        
        Map<Id,Contact> contactToUpdate = new Map<Id,Contact>();
        Set<Id> vcsId = new Set<Id>();  
         
        if(oldRecMap != null && !oldRecMap.isEmpty() && event == 'update'){        
            for(VoC_Score__c vcs : newRec){            
                if(vcs.Grade_5_best__c != oldRecMap.get(vcs.id).Grade_5_best__c){
                    contactId.add(vcs.contact_Id__c);                    
                    listToProcess.add(vcs); 
                    vcsId.add(vcs.id);                                    
                }                
            }            
        }
        else{
            for(VoC_Score__c vcs : newRec){
                contactId.add(vcs.contact_id__c);
                listToProcess.add(vcs);                                              
            }
        }                                   
        
        for(VoC_Score__c vcs : [SELECT id, Area__c, Comments__c, Grade_5_best__c, Score__c, VoC__c, contact_id__c, VoC__r.contact__c FROM voc_score__c where voc__r.contact__c in : contactId and id not in: vcsId]){                                    
                if(!mapContactsVoCScore.containsKey(vcs.contact_id__c)){
                    mapContactsVoCScore.put(vcs.contact_id__c,new map<String,Decimal>());                           
                }            
                if(!mapContactsVoCScore.get(vcs.contact_id__c).containsKey(vcs.Area__c)){
                        mapContactsVoCScore.get(vcs.contact_id__c).put(vcs.Area__c,0);                    
                }
                if(!mapContactsVoCCOunt.containsKey(vcs.contact_id__c)){
                    mapContactsVoCCOunt.put(vcs.contact_id__c,new map<String,Decimal>());                           
                }            
                if(!mapContactsVoCCOunt.get(vcs.contact_id__c).containsKey(vcs.Area__c)){
                        mapContactsVoCCOunt.get(vcs.contact_id__c).put(vcs.Area__c,0);                    
                }           
            mapContactsVoCScore.get(vcs.contact_id__c).put(vcs.Area__c,mapContactsVoCScore.get(vcs.contact_id__c).get(vcs.Area__c) + Integer.valueOf(vcs.Grade_5_best__c)); 
            mapContactsVoCCOunt.get(vcs.contact_id__c).put(vcs.Area__c,mapContactsVoCCOunt.get(vcs.contact_id__c).get(vcs.Area__c) + 1);           
        }
        
        for(VoC_Score__c vcs : listToProcess){
            Contact con;
            Decimal oldAvg;
            Decimal newAvg;
            
            if(!mapContactsVoCScore.isEmpty() && !mapContactsVoCCOunt.isEmpty() && mapContactsVoCScore.get(vcs.contact_id__c).get(vcs.Area__c) != null && mapContactsVoCCOunt.get(vcs.contact_id__c) != null){
                 if(event == 'insert' || event == 'update'){     
                     oldAvg = mapContactsVoCScore.get(vcs.contact_id__c).get(vcs.Area__c)/mapContactsVoCCOunt.get(vcs.contact_id__c).get(vcs.Area__c);
                     newAvg = (mapContactsVoCScore.get(vcs.contact_id__c).get(vcs.Area__c) + Integer.valueOf(vcs.Grade_5_best__c))/(mapContactsVoCCOunt.get(vcs.contact_id__c).get(vcs.Area__c) + 1);                
                 }
                 else{
                     if(mapContactsVoCCOunt.get(vcs.contact_id__c).get(vcs.Area__c) - 1 != 0){
                         newAvg = (mapContactsVoCScore.get(vcs.contact_id__c).get(vcs.Area__c) - Integer.valueOf(vcs.Grade_5_best__c))/(mapContactsVoCCOunt.get(vcs.contact_id__c).get(vcs.Area__c) - 1); 
                     }
                     else{
                         newAvg = 0;
                     }               
                 }
            }
            else{
                 if(event == 'insert' || event == 'update'){                 
                     oldAvg = 0;
                     newAvg = Integer.valueOf(vcs.Grade_5_best__c); 
                 }               
            }
            
            if(contactToUpdate != null && !contactToUpdate.containsKey(vcs.contact_id__c)){
                    contactToUpdate.put(vcs.contact_id__c,new Contact()); 
                    con = new Contact(id = vcs.contact_id__c);
                    con.put(vocTrend.get(vcs.Area__c).Api_Name__c,newAvg); 
                    contactToUpdate.put(vcs.contact_id__c,con);                     
            }
            else{
                contactToUpdate.get(vcs.contact_id__c).put(vocTrend.get(vcs.Area__c).Api_Name__c,newAvg);                
            }            
                        
            if(event == 'insert' || event == 'update'){ 
                vcs.score__c = Integer.valueOf(vcs.Grade_5_best__c); 
            }           
        }
        
        if(!contactToUpdate.isEmpty()){
            upsert contactToUpdate.values();
        }
    }
    
    public static void fetchVoCScoreListOnVoCDelete(List<VoC__c> delVoCList){
        Set<Id> vocId = new Set<Id>();
        
        for(VoC__C vc: delVoCList){
            vocId.add(vc.id);
        }
        
        List<VoC_Score__c> vocScoreList = [SELECT id, Area__c, Comments__c, Grade_5_best__c, Score__c, VoC__c, contact_id__c, VoC__r.contact__c FROM voc_score__c WHERE voc__c =: vocId];
        if(!vocScoreList.isEmpty()){
            manageTrends(vocScoreList,null,'delete');
        }
    }          
}