/*
Type Name: cls_Team_Room_Add_Document 
Author: Cognizant
Created Date: 1-July-2013
Reason: This class is used for Adding Document to Team Room.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class cls_Team_Room_Add_Document {
    
    public List<String> itemList {get;set;}
    public boolean showList {get;set;}
    public List<wrappercls> wrapperItemList {get;set;}
    public String itemType {get;set;}
    public String previousItemType {get;set;}
    public String searchParam {get;set;}
    public Boolean showsearchPanel{get;set;}
    public id trid {get;set;}
    public List<Team_Room_Doc__c> teamRoomDocList {get;set;}
    public Map<Id, Boolean> checkBoxDesignMap {get;set;}
    public Map<Id, Boolean> checkBoxSubPDKMap {get;set;}
    public Map<Id, Boolean> checkBoxPackageMap {get;set;}   
    public boolean[] selectedValue {get;set;} 
    public RecordType recordTypeobj;
    public boolean isLatestRevision{get; set;}
    public boolean showLatestRevision{get; set;}
    public class wrappercls{
        public boolean checkbox {get;set;}
        public String name {get;set;}
        public id itemID {get;set;}
        public Decimal openTextID {get;set;}
        public String releaseStatus {get;set;}
        public String technologyType {get;set;}
        public String techGeometry {get;set;}
        public Boolean syncWithOpenText {get;set;}
        public Boolean latestRevision{get;set;}
    }
    
    /**
        This is the Constructor of the class cls_Team_Room_Add_Document
        @parameter:   ApexPages.StandardController
        @return :     none
    **/     
    public cls_Team_Room_Add_Document(ApexPages.StandardController controller) {
        trid = ApexPages.currentPage().getParameters().get('id');
        wrapperItemList  = new List<wrappercls>();
        teamRoomDocList = new List<Team_Room_Doc__c>();
        checkBoxDesignMap = new Map<Id, Boolean>();
        checkBoxSubPDKMap = new Map<Id, Boolean>();
        checkBoxPackageMap = new Map<Id, Boolean>();
        showList = false;
        itemList  = new List<String>();
        
        itemList.add(System.Label.AddDocumentDesignSpec);
        //itemList.add(System.Label.AddDocumentSubPdk);//sunita added for case 38937
        itemList.add(System.Label.AddDocumentPackage);
        
    }
    
    public ApexPages.StandardSetController con1 {
        get{
            if(con1 == null) {
                itemType = ApexPages.currentPage().getParameters().get('itemType'); 
                if(itemType != NULL){
                    if(itemType == System.Label.AddDocumentDesignSpec){
                        List<Team_Room_Doc__c> trDocDesignSpecList = [SELECT Design_Spec__c FROM Team_Room_Doc__c 
                                                                        where Team_Room__c = :trid];
                        
                        List<Id> designDocId = new List<Id>();
                        for(Team_Room_Doc__c teamRoomDsnObj: trDocDesignSpecList){
                            designDocId.add(teamRoomDsnObj.Design_Spec__c);
                        }   

                        recordTypeobj = [Select Id From RecordType where Name = 'Design Specs'];
                        if(showLatestRevision){ 
                            con1 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,
                                                                                                       name,OpenText_ID__c,Release_Status__c,Technology_Type__c,
                                                                                                       Technology_Geometry__c,Sync_With_OpenText__c,Is_Latest_Revision__c 
                                                                                                       FROM   Design_Spec__c where Specification_Type__c NOT IN ('Stepper Tooling Forms','Reticle Grade Table') 
                                                                                                       AND Release_Status__c not in ('Internal Use Only','General Release')
                                                                                                       AND id NOT IN :designDocId AND RecordTypeId = :recordTypeobj.Id AND Is_Latest_Revision__c=true]));
                           
                        }else{
                            con1 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,
                                                                                                       name,OpenText_ID__c,Release_Status__c,Technology_Type__c,
                                                                                                       Technology_Geometry__c,Sync_With_OpenText__c,Is_Latest_Revision__c 
                                                                                                       FROM   Design_Spec__c where Specification_Type__c NOT IN ('Stepper Tooling Forms','Reticle Grade Table') 
                                                                                                       AND Release_Status__c not in ('Internal Use Only','General Release')
                                                                                                       AND id NOT IN :designDocId AND RecordTypeId = :recordTypeobj.Id]));
                        }
                        
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
    
   /* public ApexPages.StandardSetController con2 {
        get{
            if(con2 == null) {
                
                itemType = ApexPages.currentPage().getParameters().get('itemType');
                if(itemType != NULL){
                    if(itemType == System.Label.AddDocumentSubPdk){
                    
                        List<Team_Room_Doc__c> trDocSubPdkList = [SELECT Sub_PDK__c FROM Team_Room_Doc__c 
                                                                        where Team_Room__c = :trid];
                        
                        List<Id> subPdkId = new List<Id>();
                        for(Team_Room_Doc__c teamRoomDsnObj: trDocSubPdkList){
                            subPdkId.add(teamRoomDsnObj.Sub_PDK__c);
                        }   
                     if(showLatestRevision){ 
                         con2 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id, name,Sub_PDK_OpenText_Id__c,Release_Status__c,
                                                                                                             Technology__c,Tech_Geometry__c,Sync_With_OpenText__c,Is_Latest_Revision__c 
                                                                                                      FROM   Sub_PDK__c WHERE id NOT IN :subPdkId AND Is_Latest_Revision__c=true]));
                     }else{
                          con2 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id, name,Sub_PDK_OpenText_Id__c,Release_Status__c,
                                                                                                         Technology__c,Tech_Geometry__c,Sync_With_OpenText__c,Is_Latest_Revision__c 
                                                                                                  FROM   Sub_PDK__c WHERE id NOT IN :subPdkId]));
                     }                       
                    }
                
                    if(con2 != null){
                        if(con2.getrecords().size() >0)
                        con2.setPageSize(Integer.valueof(System.Label.AddDocumentPageSize));
                    }
                }
            }
            return con2;
         }
         set;
    }*/
    
    public ApexPages.StandardSetController con3 {
        get{
            if(con3 == null) {
                itemType = ApexPages.currentPage().getParameters().get('itemType');
                if(itemType != NULL){
                    if(itemType == System.Label.AddDocumentPackage){
                    
                        List<Team_Room_Doc__c> trDocPackageList = [SELECT Design_Package__c FROM Team_Room_Doc__c 
                                                                        where Team_Room__c = :trid];
                        
                        List<Id> packageId = new List<Id>();
                        for(Team_Room_Doc__c teamRoomDsnObj: trDocPackageList){
                            packageId.add(teamRoomDsnObj.Design_Package__c);
                        }                       
                    
                        con3 = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id,
                                                                                                     name,OpenText_Id__c,Package_Release_Status__c,
                                                                                                     Technology_Type__c,Tech_Geometry__c,Sync_With_OpenText__c 
                                                                                              FROM   Package__c WHERE id NOT IN :packageId]));
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
            system.debug('inside first item Type '+itemType);
            system.debug('inside first item previousItemType'+previousItemType);
            
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Spec__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Sub_PDK__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxSubPDKMap.put(wp.itemID,true);
                    }
                }        
            
            
            } */else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Package__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }  
    

        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.first();               
                
                List<Design_Spec__c> listcon1 = (List<Design_Spec__c>)con1.getRecords(); 
                
                for(Design_Spec__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    //tempwrap.checkbox = false;
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    tempwrap.name = s.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Release_Status__c;
                    tempwrap.technologyType = s.Technology_Type__c; 
                    tempwrap.techGeometry = s.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                    tempwrap.latestRevision= s.Is_Latest_Revision__c;                    
                    wrapperItemList.add(tempwrap);       
                    
                }
         }
         /* else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
         
            con2.first();
             
            List<Sub_PDK__c> listcon1 = (List<Sub_PDK__c>)con2.getRecords(); 
                
            for(Sub_PDK__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = s.Release_Status__c;
                tempwrap.technologyType = s.Technology__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                tempwrap.latestRevision= s.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);       
            }             
         }
         */ else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.first();
             
            List<Package__c> listcon1 = (List<Package__c>)con3.getRecords(); 
                
            for(Package__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.OpenText_Id__c;
                tempwrap.releaseStatus = s.Package_Release_Status__c;
                tempwrap.technologyType = s.Technology_Type__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
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
                        
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Spec__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Sub_PDK__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxSubPDKMap.put(wp.itemID,true);
                    }
                }           
            
            
            }*/ else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Package__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }     
    
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.last();               
                
                List<Design_Spec__c> listcon1 = (List<Design_Spec__c>)con1.getRecords(); 
                
                for(Design_Spec__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    //tempwrap.checkbox = false;
                    tempwrap.name = s.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Release_Status__c;
                    tempwrap.technologyType = s.Technology_Type__c; 
                    tempwrap.techGeometry = s.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                    tempwrap.latestRevision= s.Is_Latest_Revision__c;
                    wrapperItemList.add(tempwrap);       
                    
                }
         } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
         
            con2.last();
             
            List<Sub_PDK__c> listcon1 = (List<Sub_PDK__c>)con2.getRecords(); 
                
            for(Sub_PDK__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = s.Release_Status__c;
                tempwrap.technologyType = s.Technology__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                tempwrap.latestRevision= s.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);       
            }             
         }*/ else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.last();
             
            List<Package__c> listcon1 = (List<Package__c>)con3.getRecords(); 
                
            for(Package__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.OpenText_Id__c;
                tempwrap.releaseStatus = s.Package_Release_Status__c;
                tempwrap.technologyType = s.Technology_Type__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
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
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Spec__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Sub_PDK__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxSubPDKMap.put(wp.itemID,true);
                    }
                }           
            
            }*/ else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Package__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }   
    
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.previous();               
                
                List<Design_Spec__c> listcon1 = (List<Design_Spec__c>)con1.getRecords(); 
                
                for(Design_Spec__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }
                    
                    //tempwrap.checkbox = false;
                    tempwrap.name = s.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Release_Status__c;
                    tempwrap.technologyType = s.Technology_Type__c; 
                    tempwrap.techGeometry = s.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                    tempwrap.latestRevision= s.Is_Latest_Revision__c;
                    wrapperItemList.add(tempwrap);       
                }
                
         } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
         
            con2.previous();
             
            List<Sub_PDK__c> listcon1 = (List<Sub_PDK__c>)con2.getRecords(); 
                
            for(Sub_PDK__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = s.Release_Status__c;
                tempwrap.technologyType = s.Technology__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                tempwrap.latestRevision= s.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);       
            }             
         } */else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.previous();
             
            List<Package__c> listcon1 = (List<Package__c>)con3.getRecords(); 
                
            for(Package__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.OpenText_Id__c;
                tempwrap.releaseStatus = s.Package_Release_Status__c;
                tempwrap.technologyType = s.Technology_Type__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
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
            system.debug('inside next item Type '+itemType);
            system.debug('inside next selectedValue  '+selectedValue );
            system.debug('inside next item previousItemType'+previousItemType);
            
            
        if(itemType != null){
             if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Spec__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Sub_PDK__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxSubPDKMap.put(wp.itemID,true);
                    }
                }           
            
            
            } */else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
            
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Package__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }
        wrapperItemList.clear();
        if(itemType != null){
           if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                con1.next();               
                
                List<Design_Spec__c> listcon1 = (List<Design_Spec__c>)con1.getRecords(); 
                
                for(Design_Spec__c s : listcon1) {
                    wrappercls tempwrap = new wrappercls();
                    
                    for(Id checktest:checkBoxDesignMap.keySet()) {
                        if(String.valueOf(checktest).equals(s.id)){
                            tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                        }
                    }                   
                    
                    //tempwrap.checkbox = false;
                    tempwrap.name = s.name;
                    tempwrap.itemID = s.id;
                    tempwrap.openTextID = s.OpenText_ID__c;
                    tempwrap.releaseStatus = s.Release_Status__c;
                    tempwrap.technologyType = s.Technology_Type__c; 
                    tempwrap.techGeometry = s.Technology_Geometry__c;
                    tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                    tempwrap.latestRevision= s.Is_Latest_Revision__c;
                    wrapperItemList.add(tempwrap);       
                    
                }
                
               
                
                
                
         } /*else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
         
            con2.next();
             
            List<Sub_PDK__c> listcon1 = (List<Sub_PDK__c>)con2.getRecords(); 
                
            for(Sub_PDK__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = s.Release_Status__c;
                tempwrap.technologyType = s.Technology__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
                tempwrap.latestRevision= s.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);       
            }             
         }*/ else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
         
            con3.next();
             
            List<Package__c> listcon1 = (List<Package__c>)con3.getRecords(); 
                
            for(Package__c s : listcon1) {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(s.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = s.name;
                tempwrap.itemID = s.id;
                tempwrap.openTextID = s.OpenText_Id__c;
                tempwrap.releaseStatus = s.Package_Release_Status__c;
                tempwrap.technologyType = s.Technology_Type__c; 
                tempwrap.techGeometry = s.Tech_Geometry__c;
                tempwrap.syncWithOpenText = s.Sync_With_OpenText__c;
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
        //if( str == System.Label.AddDocumentSubPdk)
       // con2.cancel();           
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
        showsearchPanel = true;
        isLatestRevision=false;
        searchParam = null; 
        system.debug('item type from request '+itemType);
        if(previousItemType == null){
            previousItemType = itemType;
        } 
        system.debug('previous item type from request '+previousItemType );
        system.debug('selectedValue item type from request '+selectedValue);
        
        if(previousItemType != null){
             if(previousItemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                showLatestRevision=true;
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Spec__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxDesignMap.put(wp.itemID,true);
                    }
                }        
                
            }/* else if(previousItemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
                showLatestRevision=true;
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Sub_PDK__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxSubPDKMap.put(wp.itemID,true);
                    }
                }           
            
            
            }*/ else if(previousItemType.equalsIgnoreCase(System.Label.AddDocumentPackage)) {
                showLatestRevision=false;
                for(wrappercls wp: wrapperItemList ){
                    if(wp.checkbox == true){
                        Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                        tmd.Design_Package__c = wp.itemID ;
                        tmd.Team_Room__c = trid;
                        teamRoomDocList.add(tmd);
                        checkBoxPackageMap.put(wp.itemID,true);
                    }
                }               
            
            }
            
        }           
        
        
        wrapperItemList.clear();
        
        if(itemType == System.Label.AddDocumentDesignSpec){
            previousItemType = itemType;
            showLatestRevision=true;
            for(Design_Spec__c ds: (List<Design_Spec__c>)con1.getrecords()){
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxDesignMap.keySet()) {
                    if(String.valueOf(checktest).equals(ds.id)){
                        tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name = ds.name;
                tempwrap.itemID = ds.id;
                tempwrap.openTextID = ds.OpenText_ID__c;
                tempwrap.releaseStatus = ds.Release_Status__c;
                tempwrap.technologyType = ds.Technology_Type__c; 
                tempwrap.techGeometry = ds.Technology_Geometry__c;
                tempwrap.syncWithOpenText = ds.Sync_With_OpenText__c;
                tempwrap.latestRevision= ds.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);                          
            
            }
        }
       /* else if(itemType == System.Label.AddDocumentSubPdk){
            showLatestRevision=true;
            previousItemType = itemType;
            for(Sub_PDK__c sp: (List<Sub_PDK__c>)con2.getrecords()){
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(sp.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }                   
                
                //tempwrap.checkbox = false;
                tempwrap.name = sp.name;
                tempwrap.itemID = sp.id;
                tempwrap.openTextID = sp.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = sp.Release_Status__c;  
                tempwrap.technologyType = sp.Technology__c; 
                tempwrap.techGeometry = sp.Tech_Geometry__c;
                tempwrap.syncWithOpenText = sp.Sync_With_OpenText__c;
                tempwrap.latestRevision= sp.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);                          
            
            }    
        }*/
        
        else if(itemType == System.Label.AddDocumentPackage){
            previousItemType = itemType;
            showLatestRevision=false;
            for(Package__c p: (List<Package__c>)con3.getrecords()){
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(p.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }                   
                
                //tempwrap.checkbox = false;
                tempwrap.name = p.name;
                tempwrap.itemID = p.id;
                tempwrap.openTextID = p.OpenText_Id__c;
                tempwrap.releaseStatus = p.Package_Release_Status__c;   
                tempwrap.technologyType = p.Technology_Type__c; 
                tempwrap.techGeometry = p.Tech_Geometry__c;
                tempwrap.syncWithOpenText = p.Sync_With_OpenText__c;
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
        This method is used for initially generating the results based on Item Type selected.
        @method name: itemInfoGererate
        @parameter:   none
        @return :     none
    **/  
    public void search(){
    
        if(String.isBlank(searchParam))
        {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Search_Message)); 
        }
        else
        {
        String searchTextBox = searchParam;
        Boolean latestRevision=isLatestRevision;
        
        wrapperItemList.clear();
        
        if(itemType == System.Label.AddDocumentDesignSpec){
            
            List<Team_Room_Doc__c> trDocDesignSpecList = [SELECT Design_Spec__c FROM Team_Room_Doc__c 
                                                            where Team_Room__c = :trid];
            
            String designDocString = '';
            if(trDocDesignSpecList.size() > 0){
                designDocString = ' Id not in(';
            }
                
            for(Team_Room_Doc__c teamRoomDsnObj: trDocDesignSpecList){
                 if(teamRoomDsnObj.Design_Spec__c != null){
                        designDocString = designDocString + '\''+ teamRoomDsnObj.Design_Spec__c + '\',';
                    }else{
                        designDocString = designDocString + '\'\',';
                    }
            }  
            
            if(trDocDesignSpecList.size() > 0){
                    designDocString = designDocString.Substring(0,designDocString.length()-1);
                    designDocString = designDocString + ') AND ';           
            }
            
            System.debug('*********************designDocString***************************************'+designDocString);
            
            //String qryDesignSpec =  'FIND '+'\''+searchTextBox+'*\''+' IN ALL FIELDS RETURNING Design_Spec__c (id, name,OpenText_ID__c,Release_Status__c,Technology_Type__c,Technology_Geometry__c,Sync_With_OpenText__c where Release_Status__c not in ('Internal Use Only','General Release') AND RecordTypeId = :recordTypeobj.Id )';
            String qryDesignSpec;
            if(latestRevision){
                qryDesignSpec =  'FIND ' + '\'' + searchTextBox+ '*\'' + ' IN ALL FIELDS RETURNING Design_Spec__c (id, name,OpenText_ID__c,Release_Status__c,Technology_Type__c,Technology_Geometry__c,Is_Latest_Revision__c, Sync_With_OpenText__c where '+designDocString+' Release_Status__c not in (' + '\'Internal Use Only\',\'General Release\') AND Specification_Type__c NOT IN (' + '\'Stepper Tooling Forms\',\'Reticle Grade Table\') AND Is_Latest_Revision__c= ' + latestRevision + ' AND RecordTypeId = ' + '\''+recordTypeobj.Id+'\')';
            }else{
                qryDesignSpec =  'FIND ' + '\'' + searchTextBox+ '*\'' + ' IN ALL FIELDS RETURNING Design_Spec__c (id, name,OpenText_ID__c,Release_Status__c,Technology_Type__c,Technology_Geometry__c,Is_Latest_Revision__c, Sync_With_OpenText__c where '+designDocString+' Release_Status__c not in (' + '\'Internal Use Only\',\'General Release\') AND Specification_Type__c NOT IN (' + '\'Stepper Tooling Forms\',\'Reticle Grade Table\') AND RecordTypeId = ' + '\''+recordTypeobj.Id+'\')';
            }            
            System.debug('%%%%%%%%%%%%%%%%% qryDesignSpec :' + qryDesignSpec );
            try{
            List<List<Design_Spec__c>> fulldesignSpecListlist = search.query(qryDesignSpec); 
            Integer count = 0;     
            for(List<Design_Spec__c> ds: fulldesignSpecListlist)
            {    
                for(Design_Spec__c dspec : ds)
                {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxDesignMap.keySet()) {
                    if(String.valueOf(checktest).equals(dspec.Id)){
                        tempwrap.checkbox = checkBoxDesignMap.get(checktest);
                    }
                }               
                
                //tempwrap.checkbox = false;
                tempwrap.name =dspec.name;
                tempwrap.itemID =dspec.id;
                tempwrap.openTextID = dspec.OpenText_ID__c;
                tempwrap.releaseStatus = dspec.Release_Status__c;
                tempwrap.technologyType = dspec.Technology_Type__c; 
                tempwrap.techGeometry = dspec.Technology_Geometry__c;
                tempwrap.syncWithOpenText = dspec.Sync_With_OpenText__c;
                tempwrap.latestRevision= dspec.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);    
                count++;                      
            
            }
            }
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Your search term must have 2 or more characters.'));
          }
        }
        /*else if(itemType == System.Label.AddDocumentSubPdk){
            
            List<Team_Room_Doc__c> trDocSubPdkList = [SELECT Sub_PDK__c FROM Team_Room_Doc__c 
                                                                        where Team_Room__c = :trid];
            
            String subPDkString = '';
            if(trDocSubPdkList.size() > 0){
                subPDkString = ' where Id not in(';
            }           
                
            for(Team_Room_Doc__c teamRoomDsnObj: trDocSubPdkList){
                if(teamRoomDsnObj.Sub_PDK__c != null){
                    subPDkString = subPDkString + '\''+ teamRoomDsnObj.Sub_PDK__c + '\',';
                }else{
                    subPDkString = subPDkString + '\'\',';
                }                    
            }   
            
            if(trDocSubPdkList.size() > 0){
                    subPDkString = subPDkString.Substring(0,subPDkString.length()-1);
                    subPDkString = subPDkString + ')';  
            }           
            
            System.debug('************************************subPDkString**************************************'+subPDkString);
            String qrySubPdk;
             if(latestRevision){
                qrySubPdk = 'FIND '+'\''+searchTextBox+'*\''+' IN ALL FIELDS RETURNING Sub_PDK__c (id,name,Sub_PDK_OpenText_Id__c,Release_Status__c,Technology__c,Tech_Geometry__c,Is_Latest_Revision__c, Sync_With_OpenText__c '+subPDkString+' AND Is_Latest_Revision__c= ' + latestRevision + ')'; 
            }else{
                qrySubPdk = 'FIND '+'\''+searchTextBox+'*\''+' IN ALL FIELDS RETURNING Sub_PDK__c (id,name,Sub_PDK_OpenText_Id__c,Release_Status__c,Technology__c,Tech_Geometry__c,Is_Latest_Revision__c, Sync_With_OpenText__c '+subPDkString+')'; 
            }            
            try{
            List<List<Sub_PDK__c>> subPdkListlist = search.query(qrySubPdk);
            for(List<Sub_PDK__c> sp: subPdkListlist){
            
                for(Sub_PDK__c subpdkObj : sp)
                {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxSubPDKMap.keySet()) {
                    if(String.valueOf(checktest).equals(subpdkObj.id)){
                        tempwrap.checkbox = checkBoxSubPDKMap.get(checktest);
                    }
                }                   
                
                //tempwrap.checkbox = false;
                tempwrap.name = subpdkObj.name;
                tempwrap.itemID = subpdkObj.id;
                tempwrap.openTextID = subpdkObj.Sub_PDK_OpenText_Id__c;
                tempwrap.releaseStatus = subpdkObj.Release_Status__c;  
                tempwrap.technologyType = subpdkObj.Technology__c; 
                tempwrap.techGeometry = subpdkObj.Tech_Geometry__c;
                tempwrap.syncWithOpenText = subpdkObj.Sync_With_OpenText__c;
                tempwrap.latestRevision= subpdkObj.Is_Latest_Revision__c;
                wrapperItemList.add(tempwrap);                          
            
            }    
         }
            }
          catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Your search term must have 2 or more characters.'));
          }
        }*/
        else if(itemType == System.Label.AddDocumentPackage){
            
            List<Team_Room_Doc__c> trDocPackageList = [SELECT Design_Package__c FROM Team_Room_Doc__c 
                                                                        where Team_Room__c = :trid];
            
            String packageString = '';
            if(trDocPackageList.size() > 0){
                packageString = ' where Id not in(';
            }               
                
            for(Team_Room_Doc__c teamRoomDsnObj: trDocPackageList){
                if(teamRoomDsnObj.Design_Package__c != null)
                    packageString = packageString + '\''+ teamRoomDsnObj.Design_Package__c + '\',';
            }

            if(trDocPackageList.size() > 0){
                    packageString = packageString.Substring(0,packageString.length()-1);
                    packageString = packageString + ')';
            }
            
            String qryPackage = 'FIND '+'\''+searchTextBox+'*\''+' IN ALL FIELDS RETURNING Package__c (id,name,OpenText_Id__c,Package_Release_Status__c,Technology_Type__c,Tech_Geometry__c,Sync_With_OpenText__c '+packageString+')'; 
            try{
            List<List<Package__c>> packageListlist = search.query(qryPackage);
            for(List<Package__c> pkg: packageListlist){
            
                for(Package__c pkgObj : pkg)
                {
                wrappercls tempwrap = new wrappercls();
                
                for(Id checktest:checkBoxPackageMap.keySet()) {
                    if(String.valueOf(checktest).equals(pkgObj.id)){
                        tempwrap.checkbox = checkBoxPackageMap.get(checktest);
                    }
                }                   
                
                //tempwrap.checkbox = false;
                tempwrap.name = pkgObj.name;
                tempwrap.itemID = pkgObj.id;
                tempwrap.openTextID = pkgObj.OpenText_Id__c;
                tempwrap.releaseStatus = pkgObj.Package_Release_Status__c;   
                tempwrap.technologyType = pkgObj.Technology_Type__c; 
                tempwrap.techGeometry = pkgObj.Tech_Geometry__c;
                tempwrap.syncWithOpenText = pkgObj.Sync_With_OpenText__c;
                wrapperItemList.add(tempwrap);                          
            
            }  
            }
            } 
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Your search term must have 2 or more characters.'));
            } 
        }
       }
    }   
    
    public PageReference getSelected()
    {        
        return null;
    }
    
    
    /**
        This method is used for inserting records into TeamRoomDoc object on clicking Add Document.
        @method name: submitItem
        @parameter:   none
        @return :     PageReference object.
    **/      
    public pagereference submitItem(){
        List<Team_Room_Doc__c > trdList = new List<Team_Room_Doc__c >();
        trdList.addAll(teamRoomDocList);
        
        if(wrapperItemList.size()> 0){
            for(wrappercls wp: wrapperItemList ){
                if(wp.checkbox == true){
                    Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                    if(itemType.equalsIgnoreCase(System.Label.AddDocumentDesignSpec)){
                        tmd.Design_Spec__c = wp.itemID ;
                    }
                   /* else if(itemType.equalsIgnoreCase(System.Label.AddDocumentSubPdk)){
                        tmd.Sub_PDK__c = wp.itemID;
                    }*/
                    else if(itemType.equalsIgnoreCase(System.Label.AddDocumentPackage)){
                        tmd.Design_Package__c = wp.itemID;
                    }
                    tmd.Team_Room__c = trid;
                    trdList.add(tmd);
                    }
            }
            
            Set<Team_Room_Doc__c> teamRoomSet = new Set<Team_Room_Doc__c>(trdList);
            List<Team_Room_Doc__c> finaltrdList = new List<Team_Room_Doc__c>(teamRoomSet);
            
            List<Team_Room_Doc__c> finalTeamRoomList = new List<Team_Room_Doc__c>();
            
            List<Id> designSpecIdList = new List<Id>();
            List<Id> subPdkIdList = new List<Id>();
            List<Id> packageIdList = new List<Id>();
            
            List<Id> designSpecIdList1 = new List<Id>();
            List<Id> subPdkIdList1 = new List<Id>();
            List<Id> packageIdList1 = new List<Id>();
            
            for(Team_Room_Doc__c teamRoomDocObj: finaltrdList){
                if(teamRoomDocObj.Design_Spec__c != null){
                    designSpecIdList.add(teamRoomDocObj.Design_Spec__c);
                }
               /* if(teamRoomDocObj.Sub_PDK__c != null){
                    subPdkIdList.add(teamRoomDocObj.Sub_PDK__c);
                }*/
                if(teamRoomDocObj.Design_Package__c != null){
                    packageIdList.add(teamRoomDocObj.Design_Package__c);
                }               
            }
            
            List<Team_Room_Doc__c> trDocDesignSpecList = [SELECT Design_Spec__c FROM Team_Room_Doc__c 
                                                              where Design_Spec__c in :designSpecIdList and Team_Room__c = :trid];
            
           /* List<Team_Room_Doc__c> trDocSubPdkList = [SELECT Sub_PDK__c FROM Team_Room_Doc__c 
                                                              where Sub_PDK__c in :subPdkIdList and Team_Room__c = :trid];*/
                                                              
            List<Team_Room_Doc__c> trDocPackageList = [SELECT Design_Package__c FROM Team_Room_Doc__c 
                                                              where Design_Package__c in :packageIdList and Team_Room__c = :trid];                                                      
            
            Integer i=1;
            if(trDocDesignSpecList.size() == 0){
                designSpecIdList1.addAll(designSpecIdList);
            } else {
                for(Team_Room_Doc__c teamRoomDsnObj: trDocDesignSpecList){
                    if(i==2){
                        designSpecIdList.clear();
                        designSpecIdList.addAll(designSpecIdList1);
                        designSpecIdList1.clear();
                    }
                    for(Id desnSpcIdTotal: designSpecIdList){
                        if(desnSpcIdTotal != teamRoomDsnObj.Design_Spec__c){
                            designSpecIdList1.add(desnSpcIdTotal);
                        } 
                        i=2;
                    }
                }
            }
            
           /* Integer j=1;
            if(trDocSubPdkList.size() == 0){
                subPdkIdList1.addAll(subPdkIdList);
            } else {
                for(Team_Room_Doc__c teamRoomDsnObj: trDocSubPdkList){
                    if(j==2){
                        subPdkIdList.clear();
                        subPdkIdList.addAll(subPdkIdList1);
                        subPdkIdList1.clear();
                    }
                    for(Id subPdkIdTotal: subPdkIdList){
                        if(subPdkIdTotal != teamRoomDsnObj.Sub_PDK__c){
                            subPdkIdList1.add(subPdkIdTotal);
                        } 
                        j=2;
                    }
                }
            } */  

            Integer k=1;
            if(trDocPackageList.size() == 0){
                packageIdList1.addAll(packageIdList);
            } else {
                for(Team_Room_Doc__c teamRoomDsnObj: trDocPackageList){
                    if(k==2){
                        packageIdList.clear();
                        packageIdList.addAll(packageIdList1);
                        packageIdList1.clear();
                    }
                    for(Id subPdkIdTotal: packageIdList){
                        if(subPdkIdTotal != teamRoomDsnObj.Design_Package__c){
                            packageIdList1.add(subPdkIdTotal);
                        } 
                        k=2;
                    }
                }
            }           
            
            for(Id dsgnList: designSpecIdList1){
                Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                tmd.Design_Spec__c = dsgnList ;
                tmd.Team_Room__c = trid;
                finalTeamRoomList.add(tmd);
            }

           /* for(Id subpddkList: subPdkIdList1){
                Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                tmd.Sub_PDK__c = subpddkList ;
                tmd.Team_Room__c = trid;
                finalTeamRoomList.add(tmd);
            }*/
            
            for(Id packList: packageIdList1){
                Team_Room_Doc__c tmd = new Team_Room_Doc__c();
                tmd.Design_Package__c = packList ;
                tmd.Team_Room__c = trid;
                finalTeamRoomList.add(tmd);
            }   

            System.debug('*****************************finalTeamRoomList********************'+finalTeamRoomList);           
            
            try{            
                //insert finaltrdList;
                insert finalTeamRoomList;
            }catch(DMLException de){
                System.debug(de.getMessage());
            }   
        }
        return (new pagereference('/'+trid));
    }
}