/*
    Author: Nikhil Bajaj
    Description: This class help to insert/update group in IPRevision sharing object.
                [where ever we create/update ipRevision record respective ipelement group name will be inserted/updated in ipRevision sharing object]
    Date-6-8-2016
*/
Public Class IPRevisionSharing_TriggerHelper {
    //global variable
    Public Map<String,Id> cellMap = new Map<String,Id>();
    Public Set<String> grpst = new Set<String>();
    Public Map<String, id> gNameandID = new Map<String, id>();
    Public Map<id,Set<String>> Id_gName = new Map<Id,Set<String>>();
    public List<Id> elId = new List<Id>();
 
    public void getGrpname_and_Grpid(){
       
        for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.new) { 
            if(IPRev.IP_Element__c!=null){
                elId.add(IPRev.IP_Element__c);
             }
        }
        Map<Id,IP_Element__c> elmap;
        if(!elId.isEmpty()){
            elmap = new Map<Id,IP_Element__c> ([select GroupName__c from IP_Element__c where  id in :elId]);
        }
        for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.new) {
       
           if(IPRev.IP_Element__c!=null){
               String grpstring=  elmap.get(IPRev.IP_Element__c).GroupName__c;
                if(grpstring!=null){
                    List<String> grpList=grpstring.split(';');
                        for(String grp:grpList){
                          grpst.add(grp);
                        }
                       Id_gName.put(IPRev.id,grpst);//map of element id and grpset
                 }   
            }
        }
        if(!grpst.isEmpty()){
            List<Group>  gname=[select id,name from group where name in :grpst];
            if(!gname.isEmpty()){ 
                for(Group g:gname){
                    gNameandID.put(g.name,g.id);
                }
             }    
         }
    }
       
    /*--------------------------------After Insert-Once IpRevision record is created we are inserting respective element group name in IpRevision sharing object  ---------------------------------------------*/  
    Public void insertGroupInSharing(){
        
        List<IP_Revision__Share> sharesToCreate = new List<IP_Revision__Share>();
        getGrpname_and_Grpid();
   
        for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.new) {
            if(IPRev.IP_Element__c !=null){
                Set<String> gnameSet= Id_gName.get(IPRev.id);
                if(gnameSet!=null){
                    for(String gname:gnameSet){
                        IP_Revision__Share  IPRev_Share = new IP_Revision__Share();
                        IPRev_Share.AccessLevel = 'Edit';
                        IPRev_Share.ParentID= IPRev.Id;
                        IPRev_Share.UserOrGroupId =gNameandID.get(gname);
                        if(IPRev.IP_Element__c != null){
                            sharesToCreate.add(IPRev_Share);
                        }
                    }
                }
            }
        }
          //inserting value in sharing object
        if(!sharesToCreate.isEmpty()){
            try{
                Database.insert(sharesToCreate);
            }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPRevSharing_TriggerHelper','insertGroupInSharing','','Exception while Inserting group in IPRevsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
             
        }
      
   } 
    /*--------------------------------After Update - Once IpRevision record is updated with new IPElement rec we are inserting respective element group name in IpRevision sharing object  ---------------------------------------------*/
    Public void updateGroupInSharing(){
  
        getGrpname_and_Grpid();
        Map<Id, IP_Revision__c>   cellNew = ((Map<Id, IP_Revision__c>)Trigger.newMap);
        Map<Id, IP_Revision__c> cellOld = ((Map<Id, IP_Revision__c>)Trigger.oldMap);
        List<IP_Revision__Share> sharesToCreate = new List<IP_Revision__Share>();
        Set<String> shareIdsToDelete = new Set<String>();
        Map<Id,Id> shareIdsToDeleteMap = new Map<Id,Id>();
       
        //updating values in cell sharing object
        for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.new) {
        
            Id newEle =cellNew.get(IPRev.id).IP_Element__c;
            Id oldEle = cellOld.get(IPRev.id).IP_Element__c;
            if(cellOld.get(IPRev.id).IP_Element__c !=cellNew.get(IPRev.id).IP_Element__c && cellNew.get(IPRev.id).IP_Element__c !=null ) {
                Set<String> gnameSet= Id_gName.get(IPRev.id);
                    if(gnameSet!=null){
                        for(String gname:gnameSet){
                            shareIdsToDeleteMap = new Map<Id,Id>();
                            IP_Revision__Share IPRev_Share = new IP_Revision__Share();
                            IPRev_Share.AccessLevel = 'Edit';
                            IPRev_Share.ParentID= IPRev.Id;
                            IPRev_Share.UserOrGroupId =gNameandID.get(gname);
                            sharesToCreate.add(IPRev_Share);

                        }
                    }
                if(oldEle!=null){
                    shareIdsToDeleteMap.put(IPRev.id,oldEle);
                }
                 
            }
            else if(newEle == null){
                shareIdsToDeleteMap.put(IPRev.id,oldEle);
            }
        }
       
       if(!shareIdsToDeleteMap.isEmpty()){
           
            List<Id> oldid = new List<Id>();
            Id oldgrpId;
            List<String>  gId = new List<String>();
            for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.old) {    
                oldgrpId =shareIdsToDeleteMap.get(IPRev.id);//get old ipelement rec id 
                oldid.add(oldgrpId);
              
            } 
            Map<Id,IP_Element__c> elMap2;
            if(!oldid.isEmpty()){
                elMap2= new Map<Id,IP_Element__c >([Select GroupName__c From IP_Element__c where id in :oldid]);  
            }
            Set<String> grpIdSet = new Set<String>();
            List<String>  gId1 = new List<String>();
            List<Id> revIdList = new List<Id>();
            
            for(IP_Revision__c IPRev:(List<IP_Revision__c>)Trigger.old) {   
                revIdList.add(IPRev.id);     
                String oldgrpString =  elMap2.get(IPRev.IP_Element__c).GroupName__c;
                if(oldgrpString!=null) {
                    gId1=oldgrpString.Split(';');
                    for(String s:gId1){
                        grpIdSet.add(s);
                    }
                }
            }
            
            List<Group>  gnameId = new List<Group>();
            List<IP_Revision__Share> oldrevShareList = new List<IP_Revision__Share>();
            
            if(!grpIdSet.isEmpty()) {
                  gnameId=[select id,name from group where name in :grpIdSet];
             }
            if(gnameId !=null && revIdList!=null){
                oldrevShareList =[select id from IP_Revision__Share  where UserOrGroupId In:gnameId and ParentID in:revIdList];
            }
            if(!oldrevShareList.isEmpty()){
                try{
                    Database.delete(oldrevShareList);
                }catch (Exception excp) {
                       GlobalUtility.logMessage('Error','IPRevSharing_TriggerHelper','updateGroupInSharing','','Exception while deleting old group in IPRevsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                } 
            
            }
       
        }
         
        if(!sharesToCreate.isEmpty()){
            try{
                Database.insert(sharesToCreate);
            }catch (Exception excp) {
                   GlobalUtility.logMessage('Error','IPRevSharing_TriggerHelper','updateGroupInSharing','','Exception while updating group in IPRevsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
        }
   }
}