/*
    Author: Nikhil Bajaj
    Description: This class help to insert/update group(Respective IPElement) in IPCell sharing object.
                [where ever we create ipcell record respective ipelement group name  will be inserted in ipcell sharing object]
    Date-6-8-2016
*/
Public Class IPCellSharing_TriggerHelper {
    
    Public Map<String,Id> cellMap = new Map<String,Id>(); 
    Public Set<String> grpst = new Set<String>();
    Public Map<String, id> gNameandID = new Map<String, id>();
    Public Map<id,Set<String>> Id_gName = new Map<Id,Set<String>>();
    public List<Id> elId = new List<Id>();
    
    public void getGrpname_and_Grpid(){
          
        for(IP_Cell__c IPCell:(List<IP_Cell__c>)Trigger.new) {
            if(IPCell.IPElement__c !=null){
                elId.add(IPCell.IPElement__c);
            }
        }
        Map<Id,IP_Element__c> elmap = new Map<Id,IP_Element__c>();
        if(!elId.isEmpty()){
            elmap = new Map<Id,IP_Element__c> ([select GroupName__c from IP_Element__c where  id in :elId]);
        }
        for(IP_Cell__c IPCell:(List<IP_Cell__c>)Trigger.new){
                 
           if(IPCell.IPElement__c!=null){
                String grpString=  elmap.get(IPCell.IPElement__c).GroupName__c;
                if(grpString!=null){
                    List<String> grp=grpString.split(';');
                    for(String gname:grp){
                      grpst.add(gname);
                    }
                   Id_gName.put(IPCell.id,grpst);//map of element id and grpset
                }
            }
        }
        if(!grpst.isEmpty()){
            List<Group>  gname=[select id,name from group where name in :grpst];
            if(!gname.isEmpty()) {
                for(Group g:gname){
                    gNameandID.put(g.name,g.id);
                } 
             }    
         }
               
    }
          
       
    /*--------After Insert - Once IpCell record is created with ipelement(parent) we are inserting respective element group name in IpCell sharing object ---------------------------------------------*/  
    Public void insertGroupInSharing(){
        
        List<IP_Cell__Share> sharesToCreate = new List<IP_Cell__Share>();
        getGrpname_and_Grpid();
        //Assigning values to cell sharing object
        for(IP_Cell__c IPCell:(List<IP_Cell__c>)Trigger.new) {
            if(IPCell.IPElement__c !=null){
                Set<String> gnameSet= Id_gName.get(IPCell.id);
                if(gnameSet!=null){
                    for(String gname:gnameSet){
                        IP_Cell__Share IPCELL_Share = new IP_Cell__Share();
                        IPCELL_Share.AccessLevel = 'Edit';
                        IPCELL_Share.ParentID= IPCell.Id;
                        IPCELL_Share.UserOrGroupId =gNameandID.get(gname);
                        if(IPCell.IPElement__c != null){
                            sharesToCreate.add(IPCELL_Share);
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
                GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelper','insertGroupInSharing','','Exception while Inserting group in ipcellsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
             
        }
      
   }
    /*--------After Update -Once IpCell record is updated with new IPElement rec we are updating respective element group name in IpCell sharing object ---------------------------------------------*/
    Public void updateGroupInSharing(){
  
        getGrpname_and_Grpid();
        Map<Id, IP_Cell__c>   cellNew = ((Map<Id, IP_Cell__c>)Trigger.newMap);
        Map<Id, IP_Cell__c> cellOld = ((Map<Id, IP_Cell__c>)Trigger.oldMap);
        List<IP_Cell__Share> sharesToCreate = new List<IP_Cell__Share>();
        Set<String> shareIdsToDelete = new Set<String>();
        Map<Id,Id> shareIdsToDeleteMap = new Map<Id,Id>();
       
        //updating values in cell sharing object
        for(IP_Cell__c IPCell:(List<IP_Cell__c>)Trigger.new) {
        
            Id newEle =cellNew.get(IPCell.id).IPElement__c;
            
            Id oldEle = cellOld.get(IPCell.id).IPElement__c;
            
            if(cellOld.get(IPCell.id).IPElement__c!=cellNew.get(IPCell.id).IPElement__c && cellNew.get(IPCell.id).IPElement__c !=null ) {
                Set<String> gnameSet= Id_gName.get(IPCell.id);
                if(gnameSet!=null){
                    for(String gname:gnameSet){
                        shareIdsToDeleteMap = new Map<Id,Id>();
                        IP_Cell__Share IPCELL_Share = new IP_Cell__Share();
                        IPCELL_Share.AccessLevel = 'Edit';
                        IPCELL_Share.ParentID= IPCell.Id;
                        IPCELL_Share.UserOrGroupId =gNameandID.get(gname);
                        sharesToCreate.add(IPCELL_Share);
                    }
                }
                 
                if(oldEle!=null){
                    shareIdsToDeleteMap.put(IPCell.id,oldEle);
                }
            }
            else if(newEle ==null){
                shareIdsToDeleteMap.put(IPCell.id,oldEle);
            }
        }
        if(!shareIdsToDeleteMap.isEmpty()){
           
            List<Id> oldid = new List<Id>();
            Id oldgrpId;
            List<String>  gId = new List<String>();
            
            for(IP_Cell__c IPcell:(List<IP_Cell__c>)Trigger.old) {    
               oldgrpId =shareIdsToDeleteMap.get(IPcell.id);
               oldid.add(oldgrpId);
            } 
            
            Map<Id,IP_Element__c> elMap;
            //   creating map to get parent id and grp name
            if(!oldid.isEmpty()){
              elMap  = new Map<Id,IP_Element__c >([Select GroupName__c From IP_Element__c where id in :oldid]);  
            }
            Set<String> grpNameSet = new Set<String>();
            List<String>  grplist = new List<String>();
            List<Id> cellId = new List<Id>();
            
            for(IP_Cell__c IPcell:(List<IP_Cell__c>)Trigger.old) {   
                cellId.add(IPcell.id);     
                String oldgrpString =  elMap.get(IPcell.IPElement__c).GroupName__c;
                if(oldgrpString!=null) {
                    grplist =oldgrpString.Split(';');
                    for(String grp:grplist){
                        grpNameSet.add(grp);
                     }  
                }
            } 
            List<Group>  gnameId = new List<Group>();
            List<IP_Cell__Share> oldCellShareList = new List<IP_Cell__Share>();
              if(!grpNameSet.isEmpty()){
                   gnameId=[select id,name from group where name in :grpNameSet];
               }
              if(gnameId!=null && cellId!=null){
                    oldCellShareList =[select id from IP_Cell__Share where UserOrGroupId In:gnameId and ParentID in:cellId];
                }
            
            try{
                if(!oldCellShareList.isEmpty()){
                    Database.delete(oldCellShareList);
                }
            }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelper','updateGroupInSharing','','Exception while deleting old group in ipcellsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
        }
         
        if(!sharesToCreate.isEmpty()){
            try{
                Database.insert(sharesToCreate);
            }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelper','updateGroupInSharing','','Exception while updating group in ipcellsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
        }
    }
}