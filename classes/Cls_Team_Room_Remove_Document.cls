/*
Type Name: Cls_Team_Room_Remove_Document
Author: Cognizant
Created Date: 1-July-2013
Reason: This class is used for Removing Document to Team Room.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class Cls_Team_Room_Remove_Document{
    
    public List<String> itemList {get;set;}
    public boolean showList {get;set;}
    public List<wrappercls> wrapperItemList {get;set;}
    public String itemType {get;set;}
    public String previousItemType {get;set;}
    public id trid {get;set;}
    
    public List<Team_Room_Doc__c> teamRoomDocList {get;set;}
    public Map<Id, Boolean> checkBoxDesignMap {get;set;}
    public Map<Id, Boolean> checkBoxSubPDKMap {get;set;}
    public Map<Id, Boolean> checkBoxPackageMap {get;set;}  
    public Set<Id>teamroomdocIdSet = new Set<Id>(); 
    
    public class wrappercls{
        public boolean checkbox {get;set;}
        public String name {get;set;}
        public id itemID {get;set;}
        public Decimal openTextID {get;set;}
        public String releaseStatus {get;set;}
        public String technologyType {get;set;}
        public String techGeometry {get;set;}
        public Boolean syncWithOpenText {get;set;}
    }
    
    /**
        This is the Constructor of the class Cls_Team_Room_Remove_Document
        @parameter:   ApexPages.StandardController
        @return :     none
    **/     
    public Cls_Team_Room_Remove_Document (ApexPages.StandardController controller) {
        trid = ApexPages.currentPage().getParameters().get('id');
        wrapperItemList  = new List<wrappercls>();
        teamRoomDocList = new List<Team_Room_Doc__c>();
        checkBoxDesignMap = new Map<Id, Boolean>();
        checkBoxSubPDKMap = new Map<Id, Boolean>();
        checkBoxPackageMap = new Map<Id, Boolean>();
        showList = false;
        itemList  = new List<String>();
        itemList.add(System.Label.AddDocumentDesignSpec);
        
        itemList.add(System.Label.AddDocumentPackage);
    }
    
    public ApexPages.StandardSetController con1 {
        get{
            if(con1 == null) {
                itemType = ApexPages.currentPage().getParameters().get('itemType'); 
                if(itemType != NULL){
                    if(itemType == System.Label.AddDocumentDesignSpec){
                        con1 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,Design_Spec__r.name,Design_Spec__r.OpenText_ID__c,Design_Spec__r.Release_Status__c,Design_Spec__r.Technology_Type__c,
                                                                                             Design_Spec__r.Technology_Geometry__c,Design_Spec__r.Sync_With_OpenText__c 
                                                                                             FROM   Team_Room_Doc__c where Team_Room__c= :trid and Design_Spec__r.name<>NULL]));
                        
                    }
                    
                    // sets the number of records in each page set
                    if(con1 != null){
                        if(con1.getrecords().size()>0)
                            con1.setPageSize(Integer.valueof(System.Label.AddDocumentPageSize));
                    }    
                }
            }
            return con1;
        }
        set;
    }
    
   
    
    public ApexPages.StandardSetController con3 {
        get{
            if(con3 == null) {
                itemType = ApexPages.currentPage().getParameters().get('itemType');
                if(itemType != NULL){
                    if(itemType == System.Label.AddDocumentPackage){
                        con3 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,Design_Package__r.name,Design_Package__r.OpenText_Id__c,Design_Package__r.Package_Release_Status__c,
                                                                                             Design_Package__r.Technology_Type__c,Design_Package__r.Tech_Geometry__c,Design_Package__r.Sync_With_OpenText__c 
                                                                                             FROM   Team_Room_Doc__c where Team_Room__c= :trid and Design_Package__r.name<>NULL]));
                    }
                
                    if(con3.getrecords().size()>0)
                    con3.setPageSize(Integer.valueof(System.Label.AddDocumentPageSize));
                }
            }
            return con3;
         }
         set;
    }
    
    /**
        This method is used for returning the first page of records
        @method name: first
        @parameter:   none
        @return :     none
    **/     
    public void first() {
    
        if(itemType != null){
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }  
    

        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.first();               
                
                List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con1.getRecords(); 
                
                for(Team_Room_Doc__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                   for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    tempwrap.name = s.Design_Spec__r.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.Design_Spec__r.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Design_Spec__r.Release_Status__c;
                    tempwrap.technologyType = s.Design_Spec__r.Technology_Type__c; 
                    tempwrap.techGeometry = s.Design_Spec__r.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Design_Spec__r.Sync_With_OpenText__c;
                    wrapperItemList.add(tempwrap);       
                    
                }
         }else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.first();
             
            List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con3.getRecords(); 
                
            for(Team_Room_Doc__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                tempwrap.name = s.Design_Package__r.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Design_Package__r.OpenText_Id__c;
                tempwrap.releaseStatus = s.Design_Package__r.Package_Release_Status__c;
                tempwrap.technologyType = s.Design_Package__r.Technology_Type__c; 
                tempwrap.techGeometry = s.Design_Package__r.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Design_Package__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);       
            }             
         
         }
       } 
    }
 
    /**
        This method is used for returning the last page of records
        @method name: last
        @parameter:   none
        @return :     none
    **/     
    public void last() {
    
        if(itemType != null){
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }     
    
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.last();               
                
                List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con1.getRecords(); 
                
                for(Team_Room_Doc__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    tempwrap.name = s.Design_Spec__r.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.Design_Spec__r.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Design_Spec__r.Release_Status__c;
                    tempwrap.technologyType = s.Design_Spec__r.Technology_Type__c; 
                    tempwrap.techGeometry = s.Design_Spec__r.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Design_Spec__r.Sync_With_OpenText__c;
                    wrapperItemList.add(tempwrap);       
                    
                }
         } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.last();
             
            List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con3.getRecords(); 
                
            for(Team_Room_Doc__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.Design_Package__r.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Design_Package__r.OpenText_Id__c;
                tempwrap.releaseStatus = s.Design_Package__r.Package_Release_Status__c;
                tempwrap.technologyType = s.Design_Package__r.Technology_Type__c; 
                tempwrap.techGeometry = s.Design_Package__r.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Design_Package__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);       
            }             
         
         }
       }
    }
 
    /**
        This method is used for returning the previous page of records
        @method name: previous
        @parameter:   none
        @return :     none
    **/     
    public void previous() {

        if(itemType != null){
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }   
    
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.previous();               
                
                List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con1.getRecords(); 
                
                for(Team_Room_Doc__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }
                    
                    tempwrap.name = s.Design_Spec__r.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.Design_Spec__r.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Design_Spec__r.Release_Status__c;
                    tempwrap.technologyType = s.Design_Spec__r.Technology_Type__c; 
                    tempwrap.techGeometry = s.Design_Spec__r.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Design_Spec__r.Sync_With_OpenText__c;
                    wrapperItemList.add(tempwrap);       
                }
                
         }else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.previous();
             
            List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con3.getRecords(); 
                
            for(Team_Room_Doc__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                tempwrap.name = s.Design_Package__r.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Design_Package__r.OpenText_Id__c;
                tempwrap.releaseStatus = s.Design_Package__r.Package_Release_Status__c;
                tempwrap.technologyType = s.Design_Package__r.Technology_Type__c; 
                tempwrap.techGeometry = s.Design_Package__r.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Design_Package__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);       
            }             
         
          }
        }
    }
 
    /**
        This method is used for returning the next page of records
        @method name: next
        @parameter:   none
        @return :     none
    **/      
    public void next() {
    
        if(itemType != null){
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemId);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.next();               
                
                List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con1.getRecords(); 
                
                for(Team_Room_Doc__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    tempwrap.name = s.Design_Spec__r.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.Design_Spec__r.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Design_Spec__r.Release_Status__c;
                    tempwrap.technologyType = s.Design_Spec__r.Technology_Type__c; 
                    tempwrap.techGeometry = s.Design_Spec__r.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Design_Spec__r.Sync_With_OpenText__c;
                    wrapperItemList.add(tempwrap);       
                    
                }
                
               
                
                
                
         } else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.next();
             
            List<Team_Room_Doc__c> listcon1 = (List<Team_Room_Doc__c>)con3.getRecords(); 
                
            for(Team_Room_Doc__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                tempwrap.name = s.Design_Package__r.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Design_Package__r.OpenText_Id__c;
                tempwrap.releaseStatus = s.Design_Package__r.Package_Release_Status__c;
                tempwrap.technologyType = s.Design_Package__r.Technology_Type__c; 
                tempwrap.techGeometry = s.Design_Package__r.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Design_Package__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);       
            }             
         
         }
       }  
    }
 
    /**
        This method is used for Cancelling the action.
        @method name: cancel
        @parameter:   none
        @return :     none
    **/    
    public void cancel() {
        String str = ApexPages.currentPage().getParameters().get('itemType');
        if( str == System.Label.AddDocumentDesignSpec)
        con1.cancel();
              
        if( str == System.Label.AddDocumentPackage)
        con3.cancel();        
    }
 
    /**
        This method is used for initially generating the results based on Item Type selected.
        @method name: itemInfoGererate
        @parameter:   none
        @return :     none
    **/  
    public void itemInfoGererate(){
        itemType = ApexPages.currentPage().getParameters().get('itemType'); 
        this.showList = true;  
        
        if(previousItemType == null){
            previousItemType = itemType;
        } 
        
        if(previousItemType != null){
             if(previousItemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        teamroomdocIdSet.add(wp.itemID);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            }else if(previousItemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        teamroomdocIdSet.add(wp.itemID);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }           
        
        
        wrapperItemList.clear();
        
        if(itemType == System.Label.AddDocumentDesignSpec){
            previousItemType = itemType;
            for(Team_Room_Doc__c ds: (List<Team_Room_Doc__c>)con1.getrecords()){
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxDesignMap.keySet()) {
                    if(String.valueOf(checktest).equals(ds.id)){
                        tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                    }
                }               
                
                tempwrap.name = ds.Design_Spec__r.name;
                tempwrap.itemID = ds.id;
                tempwrap.openTextID = ds.Design_Spec__r.OpenText_ID__c;
                tempwrap.releaseStatus = ds.Design_Spec__r.Release_Status__c;
                tempwrap.technologyType = ds.Design_Spec__r.Technology_Type__c; 
                tempwrap.techGeometry = ds.Design_Spec__r.Technology_Geometry__c;
                tempwrap.syncWithOpenText = ds.Design_Spec__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);                          
            
            }
        }
       
        else if(itemType == System.Label.AddDocumentPackage){
            previousItemType = itemType;
            for(Team_Room_Doc__c p: (List<Team_Room_Doc__c>)con3.getrecords()){
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(p.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }                   
                
                tempwrap.name = p.Design_Package__r.name;
                tempwrap.itemID = p.id;
                tempwrap.openTextID = p.Design_Package__r.OpenText_Id__c;
                tempwrap.releaseStatus = p.Design_Package__r.Package_Release_Status__c;   
                tempwrap.technologyType = p.Design_Package__r.Technology_Type__c; 
                tempwrap.techGeometry = p.Design_Package__r.Tech_Geometry__c;
                tempwrap.syncWithOpenText = p.Design_Package__r.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);                          
            
            }    
        }
        
    }
    
    /**
        This method is used for processing.
        @method name: process
        @parameter:   none
        @return :     none
    **/     
    public PageReference process() {
        for (wrappercls cw : wrapperItemList) {
            if (cw.checkbox)
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.name ));
        }
        return null;
    }
    
    /**
        This method is used for returning to the previous page on clicking Cancel button.
        @method name: cancelAction
        @parameter:   none.
        @return :     PageReference object.
    **/ 
     public Pagereference cancelAction() {

          PageReference p = new PageReference('/'+trid);
          return p; 

    }       
    
    /**
        This method is used for deleting records from TeamRoomDoc object on clicking Remove Document.
        @method name: submitItem
        @parameter:   none
        @return :     PageReference object.
    **/      
    public pagereference submitItem(){
        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
        List<Team_Room_Doc__c > trdList = new List<Team_Room_Doc__c >();
        List<Id> trdidList = new List<Id>();
        trdidList.addall(teamroomdocIdSet);
        if(trdidList.size()>0)
        {
            for(Id trdId : trdidList)
            {
                tmd = new Team_Room_Doc__c();
                tmd.Id = trdId ;
                trdList.add(tmd);
            } 
        }
        
        if(wrapperItemList.size()> 0){
            for(wrappercls wp: wrapperItemList ){
                if(wp.checkbox == true){
                    tmd = new Team_Room_Doc__c();
                    if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                        tmd.Id = wp.itemID;
                    }
                   
                    else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
                         tmd.Id = wp.itemID;
                    }
                    
                    trdList.add(tmd);
                    }
                    
            }
            
            Set<Team_Room_Doc__c> teamRoomSet = new Set<Team_Room_Doc__c>(trdList);
            List<Team_Room_Doc__c > finaltrdList = new List<Team_Room_Doc__c>(teamRoomSet);
           
            
            try{            
                delete finaltrdList ;
            }catch(DMLException de){
                System.debug(de.getMessage());
            }   
        }
        return (new pagereference('/'+trid));
    }
    
}