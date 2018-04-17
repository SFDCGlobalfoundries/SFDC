/*
Type Name: ClsProvisioningHandler 
Author: Cognizant 
Created Date: 13-June-2013
Reason: This class is used for provisioning documents.
Change History:
Author: 
Modified Date: 6/13/2013
Reason: Document Provisioning
Author: Sunita
Modified Date: 3/20/2015
Reason: NDA changes for spec and package
��..
��..
*/


public without sharing class ClsProvisioningHandler {
    
    public Map<String, Tech_Geometry_with_Provisioning_Approval__c> mapTGWPA = Tech_Geometry_with_Provisioning_Approval__c.getAll();
    public Map<String, Provisioning_Profiles_with_Approval__c> mapPPWA = Provisioning_Profiles_with_Approval__c.getAll();
    set<id> userids = new set<id>(); //added
    map<id,id> mapDesignSpecToTeamRoom;
    map<id,id> mapPackageToTeamRoom;
    map<id,id> mapSubPDKToTeamRoom;
    
    public ClsProvisioningHandler(ApexPages.StandardController controller){
        
    } // end constructor
    public ClsProvisioningHandler(){}
    
    
    /* Cognizant Added for Case#00023420 on 19052014 Start */  
    public Set<Id> changeSpecIds = new Set<Id>() ;
    List<Document_Provisioning__c> lstExistingPDKProvRecs = new List<Document_Provisioning__c>() ;
    
    public void handleProvisioningForEditPDK(Map<Id,List<Id>> mapInputProvReq, String ProvType, Set<Id> SpecIds, List<Document_Provisioning__c> lstExistingPDKProvRecsTemp)
    {
        changeSpecIds = SpecIds ; 
        lstExistingPDKProvRecs = lstExistingPDKProvRecsTemp ; 
        doProvision(mapInputProvReq, ProvType) ;
    }
    /* Cognizant Added for Case#00023420 on 19052014 End */
    
    
    /**
        This method does the Provisioning.

        @method name: doProvision
        @parameter:   1. Map of Ids and List of Users.
                      2. String representing whether it's a Spec, Sub PDK or Package
        @return :     None.
     **/
    
    public void doProvision(Map<Id,List<Id>> mapInputProvReq, String ProvType) // 1.Spec 2.SubPDK 3.Package
    {
        Profile objProfile = [Select Id,Name from Profile where Id =: UserInfo.getProfileId()];
        Map<Id,User> mapUsersInfo = new Map<id,User>();
        List<Document_Provisioning__c> insertDocPr = new List<Document_Provisioning__c>();
        Map<id,Design_Spec__c > NameSpec = new Map<id,Design_Spec__c >();
        Design_Spec__c objDS = new Design_Spec__c();
        
        /** Modified to Fix Doc Prov Update Bug Start **/
        Map<String,Document_Provisioning__c> mapExistingDocProvs = new Map<String,Document_Provisioning__c>();
        /** Modified to Fix Doc Prov Update Bug End **/
                
        if(mapInputProvReq != NULL || mapInputProvReq.size()>0){
            
            for(id MapId: mapInputProvReq.keySet()){  
                userids.addall(mapInputProvReq.get(MapId)); 
            }
            
            if(userids != NULL || userids.size()>0){
                for(User objUser:[Select Id, Name, Parent_Account_Id__c, Parent_Account_Name__c, Parent_Account_Short_Name__c from User where Id IN:userids]){
                    mapUsersInfo.put(objUser.Id,objUser);       
                }   
            }
            
            if(ProvType == 'Spec'){             
                
                for(Design_Spec__c objDes:[Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, 

Location_Fab__c,Specification_Type__c, 
                Technology_Type__c,Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c, OwnerId from Design_Spec__c
                where Id IN: mapInputProvReq.keySet()]){
                    NameSpec.put(objDes.Id,objDes);     
                }
                
                /** Modified to Fix Doc Prov Update Bug Start **/
                mapExistingDocProvs.putAll(getExistingProvs(mapInputProvReq.keySet(),userids,'Spec'));
                /** Modified to Fix Doc Prov Update Bug End **/
                
                for(id MapId: mapInputProvReq.keySet()){ 
                                        
                    for(id user: mapInputProvReq.get(MapId)){
                        
                        /** Modified to Fix Doc Prov Update Bug Start **/
                        Document_Provisioning__c dpr;
                        String str = MapId+';'+user;
                        if(mapExistingDocProvs!=null && mapExistingDocProvs.containsKey(str)){
                            dpr = mapExistingDocProvs.get(str); 
                        }
                        else{
                            dpr = new Document_Provisioning__c();
                        }
                        /** Modified to Fix Doc Prov Update Bug End **/
                        
                        dpr.Design_Spec__c = MapId; 
                        dpr.User__c = user;  
                       if( NameSpec<>null && mapPPWA.get(objProfile.Name)<>null && mapTGWPA.keySet()<>null)
                       {                          
                        if((NameSpec.get(MapId).Release_Status__c=='Specific Account Release with Spec owner Approval')
                        ||((mapPPWA.get(objProfile.Name).needsApproval__c==true) && (mapTGWPA.keySet().contains(NameSpec.get(MapId).Technology_Geometry__c)))){
                            dpr.Status__c = 'Sent For Approval';
                            dpr.isSendForApproval__c=true;
                        }
                        else{
                            dpr.Status__c = 'Provisioned';
                        }
                        }
                        dpr.Spec_Owner__c = NameSpec.get(MapId).OwnerId;
                        dpr.Last_Provisioned_By__c = UserInfo.getUserId();
                        if(mapDesignSpecToTeamRoom!=null && mapDesignSpecToTeamRoom.containsKey(MapId)){
                            if(dpr.Team_Rooms_Provisioned_for__c == null){
                                dpr.Team_Rooms_Provisioned_for__c = mapDesignSpecToTeamRoom.get(MapId);
                            }
                            else if(!dpr.Team_Rooms_Provisioned_for__c.contains(mapDesignSpecToTeamRoom.get(MapId))){
                                dpr.Team_Rooms_Provisioned_for__c = dpr.Team_Rooms_Provisioned_for__c +';'+mapDesignSpecToTeamRoom.get(MapId);     
                            }
                        }
                        else{
                            dpr.Spec_Level_Provisioning__c = TRUE;
                        }
                        insertDocPr.add(dpr); 
                    }   
                               
                }
                
            }
            
            else if(ProvType == 'SubPDK'|| ProvType == 'EditSubPDK'){ // Cognizant Added for Case#00023420 on 19052014 
                List<id> tempDsgnSpc = new List<id>();
                Set<id> setDsgnSpcIds = new Set<id>();
                List<Document_Provisioning__c > dsgpro = new List<Document_Provisioning__c > ();               
                map<id,id> MapDesignSpec = new map<id,id>();
                map<id,Design_Spec__c> MapDesignSpecInfo = new map<id,Design_Spec__c>();
                Map<Id, Set<Id>> mapSpecToWL =  new Map<Id, Set<Id>>();
                Set<Id>dsgnspecwithoutwhiteList = new Set<Id>();
                  Map<id,Sub_PDK__c > NameSubPdk = new Map<id,Sub_PDK__c >();
                   
                   
                
                for(Sub_PDK__c SubPdk: [SELECT id,NAME,Release_Status__c,OwnerId FROM Sub_PDK__c WHERE ID IN:mapInputProvReq.keySet()]){                    
                    NameSubPdk.put(SubPdk.id,SubPdk); 
                }
                if(ProvType == 'SubPDK') //Cognizant Added for Case#00023420 on 19052014
                {
                    for(Sub_PDK_Spec__c  sps : [SELECT id,name,Sub_PDK__c,Design_Spec__c FROM Sub_PDK_Spec__c WHERE  Sub_PDK__c IN:mapInputProvReq.keyset()]){
                    
                        MapDesignSpec.put(sps.Design_Spec__c, sps.Sub_PDK__c);
                        tempDsgnSpc.add(sps.Design_Spec__c);                            
                    }
                }//Cognizant Added for Case#00023420 on 19052014
                
                /* Cognizant Added for Case#00023420 on 19052014 Start */
                else if(ProvType == 'EditSubPDK')
                {
                    for(Sub_PDK_Spec__c  sps : [SELECT id,name,Sub_PDK__c,Design_Spec__c FROM Sub_PDK_Spec__c WHERE  Sub_PDK__c IN:mapInputProvReq.keyset() and Design_Spec__c IN :changeSpecIds]){
                    
                        MapDesignSpec.put(sps.Design_Spec__c, sps.Sub_PDK__c);
                        tempDsgnSpc.add(sps.Design_Spec__c);                            
                    }
                }
                
                /* Cognizant Added for Case#00023420 on 19052014 End */
                
                for(Design_Spec__c objDes:[Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, 

Location_Fab__c,Specification_Type__c, 
                Technology_Type__c,Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c, OwnerId from Design_Spec__c
                where Id IN: tempDsgnSpc AND Release_Status__c!='General Release' AND Release_Status__c!='Internal Use Only'
                AND Specification_Type__c!='Stepper Tooling Forms' AND Specification_Type__c!='Reticle Grade Table' ]){
                    MapDesignSpecInfo.put(objDes.Id,objDes);
                    setDsgnSpcIds.add(objDes.Id);           
                }
                
        
        
                for(White_List__c wl:[Select Id,Design_Spec__c,Account__c From White_List__c where Design_Spec__c in:setDsgnSpcIds]){
                    Set<Id> tempSet = new Set<Id>();
        
                    if(mapSpecToWL!=null){ 
                        if(mapSpecToWL.containsKey(wl.Design_Spec__c)){
                            tempSet = mapSpecToWL.get(wl.Design_Spec__c) ;
                        }
                        tempSet.add(wl.Account__c);
                        mapSpecToWL.put(wl.Design_Spec__c , tempSet);
                    }                                   
                }
                               
                if(mapSpecToWL!=null && mapSpecToWL.size()>0){
                    for(Id designSpecId: setDsgnSpcIds){
                        if(!mapSpecToWL.keySet().contains(designSpecId)){
                            dsgnspecwithoutwhiteList.add(designSpecId);     
                        }                                                       
                    }
                }
                
                /** Modified to Fix Doc Prov Update Bug Start **/
                mapExistingDocProvs.putAll(getExistingProvs(mapInputProvReq.keySet(),userids,ProvType)); //Cognizant Modified for Case#00023420 on 19052014
                /** Modified to Fix Doc Prov Update Bug End **/
                
                for(id MapId: mapInputProvReq.keySet()){   
                    if(NameSubPdk.get(MapId).Release_Status__c!='General Release' && NameSubPdk.get(MapId).Release_Status__c!='Internal Use Only'){
                        for(id user: mapInputProvReq.get(MapId)){
                            
                            /** Modified to Fix Doc Prov Update Bug Start **/
                            Document_Provisioning__c dpr;
                            String str = MapId+';'+user;
                            if(mapExistingDocProvs!=null && mapExistingDocProvs.containsKey(str)){
                                dpr = mapExistingDocProvs.get(str); 
                            }
                            else{
                                dpr = new Document_Provisioning__c();
                            }
                            /** Modified to Fix Doc Prov Update Bug End **/
                            
                            dpr.Spec_Owner__c = NameSubPdk.get(MapId).OwnerId;
                            dpr.Last_Provisioned_By__c = UserInfo.getUserId();
                            dpr.Sub_PDK__c= MapId; 
                            dpr.User__c = user;
                            if((NameSubPdk.get(MapId).Release_Status__c=='Specific Account Release with Spec owner Approval')
                            ||((mapPPWA.get(objProfile.Name).needsApproval__c==true) && (mapTGWPA.keySet().contains(objDS.Technology_Geometry__c)))){
                                dpr.Status__c = 'Sent For Approval';
                                dpr.isSendForApproval__c=true;
                            }
                            else{
                                dpr.Status__c = 'Provisioned';
                            }
                            
                            if(mapSubPDKToTeamRoom!=null && mapSubPDKToTeamRoom.containsKey(MapId)){
                                if(dpr.Team_Rooms_Provisioned_for__c == null){
                                    dpr.Team_Rooms_Provisioned_for__c = mapSubPDKToTeamRoom.get(MapId);
                                }
                                else if(!dpr.Team_Rooms_Provisioned_for__c.contains(mapSubPDKToTeamRoom.get(MapId))){
                                    dpr.Team_Rooms_Provisioned_for__c = dpr.Team_Rooms_Provisioned_for__c +';'+mapSubPDKToTeamRoom.get(MapId);     
                                }   
                            }
                            insertDocPr.add(dpr);  
                        }   
                    }
                }
                
                if(setDsgnSpcIds!=null && setDsgnSpcIds.size()>0){
                    
                    /** Modified to Fix Doc Prov Update Bug Start **/
                    mapExistingDocProvs.putAll(getExistingProvs(setDsgnSpcIds,userids,'Spec'));
                    /** Modified to Fix Doc Prov Update Bug End **/
                    
                    for(Id dSpecId:setDsgnSpcIds){
                        for(id user: userids){
                            
                            /** Modified to Fix Doc Prov Update Bug Start **/
                            Document_Provisioning__c dpr;
                            String str = dSpecId+';'+user;
                            if(mapExistingDocProvs!=null && mapExistingDocProvs.containsKey(str)){
                                dpr = mapExistingDocProvs.get(str); 
                            }
                            else{
                                dpr = new Document_Provisioning__c();
                            }
                            /** Modified to Fix Doc Prov Update Bug End **/
                            
                            dpr.Design_Spec__c = dSpecId;                            
                            if((MapDesignSpecInfo.get(dSpecId).Release_Status__c=='Specific Account Release with Spec owner Approval')
                            ||((mapPPWA.get(objProfile.Name).needsApproval__c==true) && (mapTGWPA.keySet().contains(objDS.Technology_Geometry__c)))){
                                dpr.Status__c = 'Sent For Approval';
                                dpr.isSendForApproval__c=true;
                            }
                            else{
                                dpr.Status__c = 'Provisioned';
                            }
                            dpr.Spec_Owner__c = MapDesignSpecInfo.get(dSpecId).OwnerId;
                            dpr.Last_Provisioned_By__c = UserInfo.getUserId();                         
                            if(mapSpecToWL!=null && mapSpecToWL.keySet().contains(dSpecId)){
                                if(mapSpecToWL.get(dSpecId).contains(mapUsersInfo.get(user).Parent_Account_Id__c)){
                                    dpr.User__c = user;
                                }   
                            }
                            else{
                                dpr.User__c = user;                                                 
                            }
                            if(dpr.Sub_PDK_Provisioned_for__c == Null){
                                dpr.Sub_PDK_Provisioned_for__c = NameSubPdk.get(MapDesignSpec.get(dSpecId)).Id;
                            }
                            else if(!dpr.Sub_PDK_Provisioned_for__c.contains(NameSubPdk.get(MapDesignSpec.get(dSpecId)).Id)){
                                dpr.Sub_PDK_Provisioned_for__c = dpr.Sub_PDK_Provisioned_for__c +';'+NameSubPdk.get(MapDesignSpec.get(dSpecId)).Id;     
                            }
                            if(mapDesignSpecToTeamRoom!=null && mapDesignSpecToTeamRoom.containsKey(dSpecId)){
                                if(dpr.Team_Rooms_Provisioned_for__c == null){
                                    dpr.Team_Rooms_Provisioned_for__c = mapDesignSpecToTeamRoom.get(dSpecId);
                                }
                                else if(!dpr.Team_Rooms_Provisioned_for__c.contains(mapDesignSpecToTeamRoom.get(dSpecId))){
                                    dpr.Team_Rooms_Provisioned_for__c = dpr.Team_Rooms_Provisioned_for__c +';'+mapDesignSpecToTeamRoom.get(dSpecId);     
                                }   
                            }
                            if(dpr.User__c!=null){  
                                insertDocPr.add(dpr);
                            }   
                        }           
                    }
                }
              
        
            }
            
            else if(ProvType == 'Package'){
                List<id> tempDsgnSpc = new List<id>();
                Set<id> setDsgnSpcIds = new Set<id>();
                List<Document_Provisioning__c > dsgpro = new List<Document_Provisioning__c > ();               
                map<id,id> MapDesignSpec = new map<id,id>();
                map<id,Design_Spec__c> MapDesignSpecInfo = new map<id,Design_Spec__c>();
                Map<Id, Set<Id>> mapSpecToWL =  new Map<Id, Set<Id>>();
                Set<Id>dsgnspecwithoutwhiteList = new Set<Id>();
                Map<id,Package__c > NamePackage = new Map<id,Package__c >();
                
                for(Package__c Pck: [SELECT id,NAME,Package_Release_Status__c,OwnerId FROM Package__c WHERE ID IN:mapInputProvReq.keySet()]){                    
                    NamePackage.put(Pck.id,Pck); 
                }
                
                for(Package_Spec__c  sps : [SELECT id,name,Package__c,Design_Spec__c FROM Package_Spec__c WHERE  Package__c IN:mapInputProvReq.keyset()]){
                    
                    MapDesignSpec.put(sps.Design_Spec__c, sps.Package__c);
                    tempDsgnSpc.add(sps.Design_Spec__c);                            
                }
                
                for(Design_Spec__c objDes:[Select Id, Name, Document_Number__c, Revision__c, Revision_Release_Date__c, Lifecycle_Phase__c, 

Location_Fab__c,Specification_Type__c, 
                Technology_Type__c,Technology_Geometry__c, Source__c, Specification_sub_class__c, Release_Status__c, OwnerId from Design_Spec__c
                where Id IN: tempDsgnSpc AND Release_Status__c!='General Release' AND Release_Status__c!='Internal Use Only'
                AND Specification_Type__c!='Stepper Tooling Forms' AND Specification_Type__c!='Reticle Grade Tables' ]){
                    MapDesignSpecInfo.put(objDes.Id,objDes);
                    setDsgnSpcIds.add(objDes.Id);           
                }
                
                for(White_List__c wl:[Select Id,Design_Spec__c,Account__c From White_List__c where Design_Spec__c in:setDsgnSpcIds]){
                    Set<Id> tempSet = new Set<Id>();
        
                    if(mapSpecToWL!=null){ 
                        if(mapSpecToWL.containsKey(wl.Design_Spec__c)){
                            tempSet = mapSpecToWL.get(wl.Design_Spec__c) ;
                        }
                        tempSet.add(wl.Account__c);
                        mapSpecToWL.put(wl.Design_Spec__c , tempSet);
                    }                                   
                }
                
                if(mapSpecToWL!=null && mapSpecToWL.size()>0){
                    for(Id designSpecId: setDsgnSpcIds){
                        if(!mapSpecToWL.keySet().contains(designSpecId)){
                            dsgnspecwithoutwhiteList.add(designSpecId);     
                        }                                                       
                    }
                }
                
                /** Modified to Fix Doc Prov Update Bug Start **/
                Set<Id> pckgIds = new Set<Id>();
                for(id MapId: mapInputProvReq.keySet()){   
                    if(NamePackage.get(MapId).Package_Release_Status__c!='General Release'){
                        pckgIds.add(MapId);     
                    }
                }
                if(pckgIds!=null && pckgIds.size()>0){
                    mapExistingDocProvs.putAll(getExistingProvs(pckgIds,userids,'Package'));
                }
                /** Modified to Fix Doc Prov Update Bug End **/
                
                for(id MapId: mapInputProvReq.keySet()){   
                    if(NamePackage.get(MapId).Package_Release_Status__c!='General Release'){ 
                        for(id user: mapInputProvReq.get(MapId)){
                                            
                            /** Modified to Fix Doc Prov Update Bug Start **/
                            Document_Provisioning__c dpr;
                            String str = MapId+';'+user;
       
                            if(mapExistingDocProvs!=null && mapExistingDocProvs.containsKey(str)){
                                dpr = mapExistingDocProvs.get(str); 
                            }
                            else{
                                dpr = new Document_Provisioning__c();
                            }
                            /** Modified to Fix Doc Prov Update Bug End **/
                            
                            dpr.Spec_Owner__c = NamePackage.get(MapId).OwnerId; 
                            dpr.Last_Provisioned_By__c = UserInfo.getUserId();    
                            dpr.Design_Package__c= MapId; 
                            dpr.User__c = user;
                            if((NamePackage.get(MapId).Package_Release_Status__c=='Specific Account Release with Spec owner Approval')
                            ||((mapPPWA.get(objProfile.Name).needsApproval__c==true) && (mapTGWPA.keySet().contains(objDS.Technology_Geometry__c)))){
                                dpr.Status__c = 'Sent For Approval';
                                dpr.isSendForApproval__c=true;
                            }
                            else{
                                dpr.Status__c = 'Provisioned';
                            }
                            
                            if(mapPackageToTeamRoom!=null && mapPackageToTeamRoom.containsKey(MapId)){
                                if(dpr.Team_Rooms_Provisioned_for__c == null){
                                    dpr.Team_Rooms_Provisioned_for__c = mapPackageToTeamRoom.get(MapId);
                                }
                                else if(!dpr.Team_Rooms_Provisioned_for__c.contains(mapPackageToTeamRoom.get(MapId))){
                                    dpr.Team_Rooms_Provisioned_for__c = dpr.Team_Rooms_Provisioned_for__c +';'+mapPackageToTeamRoom.get(MapId);     
                                }   
                            }
                            insertDocPr.add(dpr);
                        }  
                    }   
                    
                }
                
                if(setDsgnSpcIds!=null && setDsgnSpcIds.size()>0){
                    
                    /** Modified to Fix Doc Prov Update Bug Start **/
                    mapExistingDocProvs.putAll(getExistingProvs(setDsgnSpcIds,userids,'Spec'));
                    /** Modified to Fix Doc Prov Update Bug End **/
                
                    for(Id dSpecId:setDsgnSpcIds){
                        for(id user: userids){
                            
                            /** Modified to Fix Doc Prov Update Bug Start **/
                            Document_Provisioning__c dpr;
                            String str = dSpecId+';'+user;
                           
                            if(mapExistingDocProvs!=null && mapExistingDocProvs.containsKey(str)){
                                dpr = mapExistingDocProvs.get(str); 
                            }
                            else{
                                dpr = new Document_Provisioning__c();
                            }
                            /** Modified to Fix Doc Prov Update Bug End **/
                            
                            dpr.Design_Spec__c = dSpecId;
                            dpr.Last_Provisioned_By__c = UserInfo.getUserId();                            
                            if((MapDesignSpecInfo.get(dSpecId).Release_Status__c=='Specific Account Release with Spec owner Approval')
                            ||((mapPPWA.get(objProfile.Name).needsApproval__c==true) && (mapTGWPA.keySet().contains(objDS.Technology_Geometry__c)))){
                                dpr.Status__c = 'Sent For Approval';
                                dpr.isSendForApproval__c=true;
                            }
                            else{
                                dpr.Status__c = 'Provisioned';
                            }
                            dpr.Spec_Owner__c = MapDesignSpecInfo.get(dSpecId).OwnerId;
                            if(mapSpecToWL!=null && mapSpecToWL.keySet().contains(dSpecId)){
                                if(mapSpecToWL.get(dSpecId).contains(mapUsersInfo.get(user).Parent_Account_Id__c)){
                                    dpr.User__c = user;
                                }   
                            }
                            else{
                                dpr.User__c = user;                                                 
                            }
                            System.debug('Value of Packages_Provisioned_for__c is ' + dpr.Packages_Provisioned_for__c);
                            if(dpr.Packages_Provisioned_for__c == Null){
                                dpr.Packages_Provisioned_for__c = NamePackage.get(MapDesignSpec.get(dSpecId)).Id;
                            }
                            else if(!dpr.Packages_Provisioned_for__c.contains(NamePackage.get(MapDesignSpec.get(dSpecId)).Id)){
                                dpr.Packages_Provisioned_for__c = dpr.Packages_Provisioned_for__c +';'+NamePackage.get(MapDesignSpec.get(dSpecId)).Id;     
                            }
                            if(mapDesignSpecToTeamRoom!=null && mapDesignSpecToTeamRoom.containsKey(dSpecId)){
                                if(dpr.Team_Rooms_Provisioned_for__c == null){
                                    dpr.Team_Rooms_Provisioned_for__c = mapDesignSpecToTeamRoom.get(dSpecId);
                                }
                                else if(!dpr.Team_Rooms_Provisioned_for__c.contains(mapDesignSpecToTeamRoom.get(dSpecId))){
                                    dpr.Team_Rooms_Provisioned_for__c = dpr.Team_Rooms_Provisioned_for__c +';'+mapDesignSpecToTeamRoom.get(dSpecId);     
                                }   
                            }
                            if(dpr.User__c!=null){      
                                insertDocPr.add(dpr);
                            }   
                        }           
                    }
                }
                  
            }
            
            else if(ProvType == 'TeamRoom'){
                mapDesignSpecToTeamRoom = new map<id,id>();
                mapPackageToTeamRoom = new map<id,id>();
                mapSubPDKToTeamRoom = new map<id,id>();                        
                map<Id,List<Id>> mapSpecIdsToUserIds = new map<Id,List<Id>>();
                map<Id,List<Id>> mapSubPDKIdsToUserIds = new map<Id,List<Id>>();
                map<Id,List<Id>> mapPackageIdsToUserIds = new map<Id,List<Id>>();
                set<Id> setTotalUsersToBeProvisioned = new set<Id>();
                map<Id,String> mapUserIdsToAccIds = new map<Id,String>();
                Map<Id, Set<String>> mapSpecToWhiteList =  new Map<Id, Set<String>>();
                Map<Id, Set<String>> mapSubPDKToWhiteList =  new Map<Id, Set<String>>();
                Map<Id, Set<String>> mapPackageToWhiteList =  new Map<Id, Set<String>>();
               
                for(Team_Room_Doc__c  trd : [SELECT id,name,Design_Package__c,Design_Spec__c,Sub_PDK__c,Team_Room__c FROM Team_Room_Doc__c WHERE  Team_Room__c 

IN:mapInputProvReq.keyset()]){                   
                    if(trd.Design_Spec__c!=null){
                        mapDesignSpecToTeamRoom.put(trd.Design_Spec__c, trd.Team_Room__c);
                    }
                    if(trd.Design_Package__c!=null){
                        mapPackageToTeamRoom.put(trd.Design_Package__c, trd.Team_Room__c);
                    }
                    if(trd.Sub_PDK__c!=null){
                        mapSubPDKToTeamRoom.put(trd.Sub_PDK__c, trd.Team_Room__c);
                    }                            
                }
                
                if(mapDesignSpecToTeamRoom!=null && mapDesignSpecToTeamRoom.size()>0){
                    for(Id recordId: mapDesignSpecToTeamRoom.keySet()){
                        setTotalUsersToBeProvisioned.addAll(mapInputProvReq.get(mapDesignSpecToTeamRoom.get(recordId)));
                    }   
                }
                if(mapPackageToTeamRoom!=null && mapPackageToTeamRoom.size()>0){
                    for(Id recordId: mapPackageToTeamRoom.keySet()){
                        setTotalUsersToBeProvisioned.addAll(mapInputProvReq.get(mapPackageToTeamRoom.get(recordId)));
                    }   
                }
                if(mapSubPDKToTeamRoom!=null && mapSubPDKToTeamRoom.size()>0){
                    for(Id recordId: mapSubPDKToTeamRoom.keySet()){
                        setTotalUsersToBeProvisioned.addAll(mapInputProvReq.get(mapSubPDKToTeamRoom.get(recordId)));
                    }   
                }
                
                /**Checking White List for Provisioning Starts**/
                if(setTotalUsersToBeProvisioned!=null && setTotalUsersToBeProvisioned.size()>0){
                    for(User obj:[Select Id, Name, Parent_Account_Id__c from User where Id IN:setTotalUsersToBeProvisioned]){
                        mapUserIdsToAccIds.put(obj.Id,obj.Parent_Account_Id__c);    
                    }   
                }
                
                /**Checking White List for Specs **/
                if(mapDesignSpecToTeamRoom!=null && mapDesignSpecToTeamRoom.size()>0){
                    for(White_List__c wl:[Select Id,Design_Spec__c,Account__c From White_List__c where Design_Spec__c in:mapDesignSpecToTeamRoom.keySet()]){
                        Set<String> tempSet = new Set<String>();
            
                        if(mapSpecToWhiteList!=null){ 
                            if(mapSpecToWhiteList.containsKey(wl.Design_Spec__c)){
                                tempSet = mapSpecToWhiteList.get(wl.Design_Spec__c) ;
                            }
                            tempSet.add(wl.Account__c);
                            mapSpecToWhiteList.put(wl.Design_Spec__c , tempSet);
                        }                                   
                    }
                    
                    for(Id recordId: mapDesignSpecToTeamRoom.keySet()){
                        if(mapSpecToWhiteList!=null && mapSpecToWhiteList.containsKey(recordId)){
                            List<Id> lstTempUsers = new List<Id>();
                            for(Id userId:mapInputProvReq.get(mapDesignSpecToTeamRoom.get(recordId))){
                                if(mapSpecToWhiteList.get(recordId).contains(mapUserIdsToAccIds.get(userId))){
                                    lstTempUsers.add(userId);       
                                }   
                            }
                            mapSpecIdsToUserIds.put(recordId , lstTempUsers);       
                        }
                        else{
                            mapSpecIdsToUserIds.put(recordId , mapInputProvReq.get(mapDesignSpecToTeamRoom.get(recordId))); 
                        }
                    }
                }
                
                /**Checking White List for Sub PDKs **/
                if(mapSubPDKToTeamRoom!=null && mapSubPDKToTeamRoom.size()>0){
                    for(White_List__c wl:[Select Id,Sub_PDK__c,Account__c From White_List__c where Sub_PDK__c in:mapSubPDKToTeamRoom.keySet()]){
                        Set<String> tempSet = new Set<String>();
            
                        if(mapSubPDKToWhiteList!=null){ 
                            if(mapSubPDKToWhiteList.containsKey(wl.Sub_PDK__c)){
                                tempSet = mapSubPDKToWhiteList.get(wl.Sub_PDK__c) ;
                            }
                            tempSet.add(wl.Account__c);
                            mapSubPDKToWhiteList.put(wl.Sub_PDK__c , tempSet);
                        }                                   
                    }
                    
                    for(Id recordId: mapSubPDKToTeamRoom.keySet()){
                        if(mapSubPDKToWhiteList!=null && mapSubPDKToWhiteList.containsKey(recordId)){
                            List<Id> lstTempUsers = new List<Id>();
                            for(Id userId:mapInputProvReq.get(mapSubPDKToTeamRoom.get(recordId))){
                                if(mapSubPDKToWhiteList.get(recordId).contains(mapUserIdsToAccIds.get(userId))){
                                    lstTempUsers.add(userId);       
                                }   
                            }
                            mapSubPDKIdsToUserIds.put(recordId , lstTempUsers);     
                        }
                        else{
                            mapSubPDKIdsToUserIds.put(recordId , mapInputProvReq.get(mapSubPDKToTeamRoom.get(recordId)));   
                        }
                    }
                }
                
                /**Checking White List for Packages **/
                if(mapPackageToTeamRoom!=null && mapPackageToTeamRoom.size()>0){
                    for(White_List__c wl:[Select Id,Package__c,Account__c From White_List__c where Package__c in:mapPackageToTeamRoom.keySet()]){
                        Set<String> tempSet = new Set<String>();
            
                        if(mapPackageToWhiteList!=null){ 
                            if(mapPackageToWhiteList.containsKey(wl.Package__c)){
                                tempSet = mapPackageToWhiteList.get(wl.Package__c) ;
                            }
                            tempSet.add(wl.Account__c);
                            mapPackageToWhiteList.put(wl.Package__c , tempSet);
                        }                                   
                    }
                    
                    for(Id recordId: mapPackageToTeamRoom.keySet()){
                        if(mapPackageToWhiteList!=null && mapPackageToWhiteList.containsKey(recordId)){
                            List<Id> lstTempUsers = new List<Id>();
                            for(Id userId:mapInputProvReq.get(mapPackageToTeamRoom.get(recordId))){
                                if(mapPackageToWhiteList.get(recordId).contains(mapUserIdsToAccIds.get(userId))){
                                    lstTempUsers.add(userId);       
                                }   
                            }
                            mapPackageIdsToUserIds.put(recordId , lstTempUsers);        
                        }
                        else{
                            mapPackageIdsToUserIds.put(recordId , mapInputProvReq.get(mapPackageToTeamRoom.get(recordId))); 
                        }
                    }
                }               
                /**Checking White List Ends**/
                               
                if(mapSpecIdsToUserIds!=null && mapSpecIdsToUserIds.size()>0){
                    doProvision(mapSpecIdsToUserIds, 'Spec');   
                }                
                if(mapPackageIdsToUserIds!=null && mapPackageIdsToUserIds.size()>0){
                    doProvision(mapPackageIdsToUserIds, 'Package'); 
                }
                if(mapSubPDKIdsToUserIds!=null && mapSubPDKIdsToUserIds.size()>0){
                    doProvision(mapSubPDKIdsToUserIds, 'SubPDK');   
                }
                  
            }
            
            
            /** Modified to Fix Doc Prov Update Bug Start **/
            try{
                upsert insertDocPr;
            }
            catch(Exception ex){
                
            }
            /** Modified to Fix Doc Prov Update Bug End **/
            
        }
        
    } // doProvision
    
    /** Modified to Fix Doc Prov Update Bug Start **/
    
    /**
        This method retrieves the existing provisionings from the Document Provisioning object .

        @method name: getExistingProvs
        @parameter:   1. Set of Item Ids to be provisioned. 
                      2. Set of User Ids to be provisioned.
                      3. String representing whether it's a Spec, Sub PDK or Package
        @return :     Map of Item Id concatenated with User Id as key and Document Provisioning record as value.
     **/
     
    public Map<String,Document_Provisioning__c> getExistingProvs(Set<Id> setItemIds, Set<Id> userIds, String ProvType) // 1.Spec 2.SubPDK 3.Package
    {
        Map<String,Document_Provisioning__c> mapProvs = new Map<String,Document_Provisioning__c>(); 
        
        if(ProvType=='Spec'){
            for(Document_Provisioning__c dp:[Select User__c, Team_Rooms_Provisioned_for__c, 
                                            Sub_PDK_Provisioned_for__c, Sub_PDK__c, Status__c, Spec_Level_Provisioning__c, 
                                            Packages_Provisioned_for__c, Package_OpenText_Id__c,  
                                            PDK_OpenText_Id__c, Name, 
                                            Id, Design_Spec__c,Last_Provisioned_By__c, 
                                            Design_Spec_OpenText_Id__c, Design_Package__c,  
                                            Contact__c, Account__c,is_De_Prov_From_UI__c //sunita 19th march
                                            from Document_Provisioning__c where 
                                            Design_Spec__c IN:setItemIds AND User__c IN:userids]){
                                                        
                    String str = dp.Design_Spec__c+';'+dp.User__c;
                    mapProvs.put(str,dp);                                           
            }
        }
        
        else if(ProvType=='SubPDK'){
            for(Document_Provisioning__c dp:[Select User__c, Team_Rooms_Provisioned_for__c, 
                                            Sub_PDK_Provisioned_for__c, Sub_PDK__c, Status__c, Spec_Level_Provisioning__c, 
                                            Packages_Provisioned_for__c, Package_OpenText_Id__c,  
                                            PDK_OpenText_Id__c, Name, 
                                            Id, Design_Spec__c,Last_Provisioned_By__c, 
                                            Design_Spec_OpenText_Id__c, Design_Package__c,  
                                            Contact__c, Account__c 
                                            from Document_Provisioning__c where 
                                            Sub_PDK__c IN:setItemIds AND User__c IN:userids]){
                                                        
                    String str = dp.Sub_PDK__c+';'+dp.User__c;
                    mapProvs.put(str,dp);                                           
            }
        }
        
        // Cognizant Added for Case#00023420 on 19052014 Start
        else if(ProvType=='EditSubPDK'){
            for(Document_Provisioning__c dp:lstExistingPDKProvRecs){
                                                        
                    String str = dp.Sub_PDK__c+';'+dp.User__c;
                    mapProvs.put(str,dp);                                           
            }
        } // Cognizant Added for Case#00023420 on 19052014 End
        
        else if(ProvType=='Package'){
            for(Document_Provisioning__c dp:[Select User__c, Team_Rooms_Provisioned_for__c, 
                                            Sub_PDK_Provisioned_for__c, Sub_PDK__c, Status__c, Spec_Level_Provisioning__c, 
                                            Packages_Provisioned_for__c, Package_OpenText_Id__c,  
                                            PDK_OpenText_Id__c, Name, 
                                            Id, Design_Spec__c,Last_Provisioned_By__c, 
                                            Design_Spec_OpenText_Id__c, Design_Package__c,  
                                            Contact__c, Account__c,is_De_Prov_From_UI__c //sunita 19th march
                                            from Document_Provisioning__c where 
                                            Design_Package__c IN:setItemIds AND User__c IN:userids]){
                                                        
                    String str = dp.Design_Package__c+';'+dp.User__c;
                    mapProvs.put(str,dp);                                           
            }
        }
        
        return mapProvs;
        
    }
    /** Modified to Fix Doc Prov Update Bug End **/
    
    /**
        This method does the Provisioning Updates.

        @method name: doProvisionUpdates
        @parameter:   1. Map of Ids and List of Users.
                      2. String representing whether it's a Spec, Sub PDK or Package
        @return :     None.
     **/
     
    public void doProvisionUpdates(Map<Id,List<Id>> mapInputProvReq, String ProvType) // 1.Spec 2.SubPDK 3.Package
    {
    
        List<Id> docProvIds = new List<Id>();
        
        for(Id recId: mapInputProvReq.keySet()){            
            docProvIds = mapInputProvReq.get(recId);        
        }
        
        if(mapInputProvReq != NULL || mapInputProvReq.size()>0){
            
            List<Document_Provisioning__c> LstDPSpec = new  List<Document_Provisioning__c>();
            Map<String, String> mapIdsToReleaseStatus = new Map<String, String>();
            
            if( ProvType == 'Spec'){
                for(Design_Spec__c ds:[Select Id, Release_Status__c from Design_Spec__c where Id IN:mapInputProvReq.keySet()]){
                    mapIdsToReleaseStatus.put(ds.Id, ds.Release_Status__c);     
                }
                                           
                LstDPSpec = [ SELECT id,name,is_De_Prov_From_UI__c,User__c,Design_Spec__c,Sub_PDK__c,Design_Package__c FROM Document_Provisioning__c WHERE  User__c IN:docProvIds AND 

Design_Spec__c IN:mapInputProvReq.keySet()];     //sunita 19th march          
            }
            if( ProvType == 'SubPDK'){
                for(Sub_PDK__c spdk:[Select Id, Release_Status__c from Sub_PDK__c where Id IN: mapInputProvReq.keySet()]){
                    mapIdsToReleaseStatus.put(spdk.Id, spdk.Release_Status__c);     
                }
                                        
                LstDPSpec = [ SELECT id,name,User__c,Design_Spec__c,Sub_PDK__c,Design_Package__c  FROM Document_Provisioning__c WHERE  User__c IN:docProvIds AND 

Sub_PDK__c IN:mapInputProvReq.keySet()];               
            }
            if( ProvType == 'Package'){                           
                LstDPSpec = [ SELECT id,name,User__c,is_De_Prov_From_UI__c,Design_Spec__c,Sub_PDK__c,Design_Package__c  FROM Document_Provisioning__c WHERE  User__c IN:docProvIds AND 

Design_Package__c IN:mapInputProvReq.keySet()];    //sunita 19th march            
            }
            
            for(Document_Provisioning__c   dp   : LstDPSpec){
                
                dp.Last_Provisioned_By__c = UserInfo.getUserId();                
                if(dp.Design_Spec__c!=null){                    
                    if(mapIdsToReleaseStatus!=null && mapIdsToReleaseStatus.containsKey(dp.Design_Spec__c)){                    
                        if(mapIdsToReleaseStatus.get(dp.Design_Spec__c)=='Specific Account Release with Spec owner Approval'){
                            dp.Status__c = 'Sent For Approval' ; 
                            dp.isSendForApproval__c=true;              
                        }
                        else{
                            dp.Status__c = 'Provisioned' ; 
                            dp.is_De_Prov_From_UI__c  =false; //sunita 19th march    
                        }
                        dp.Spec_Level_Provisioning__c = true;
                    }
                }
                
                else if(dp.Sub_PDK__c!=null){                   
                    if(mapIdsToReleaseStatus!=null && mapIdsToReleaseStatus.containsKey(dp.Sub_PDK__c)){                    
                        if(mapIdsToReleaseStatus.get(dp.Sub_PDK__c)=='Specific Account Release with Spec owner Approval'){
                            dp.Status__c = 'Sent For Approval' ;   
                            dp.isSendForApproval__c=true;            
                        }
                        else{
                            dp.Status__c = 'Provisioned' ;      
                        }
                    }
                }
                
            }
            
            try{
                update LstDPSpec;  
            }
            catch(Exception ex){
                
            }                  
                 
        }       
        
    } 
    
    /**
        This method does the DeProvisioning.

        @method name: deProvisioningMethod
        @parameter:   1. Map of Ids and List of Users.
                      2. String representing whether it's a Spec, Sub PDK or Package
        @return :     None.
     **/
     
     
    public void deProvisioningMethod (Map<Id,List<Id>> mapInputProvReq, String ProvType){ //1.Spec 2.SubPDK
                
        List<Id> docProvIds = new List<Id>();
        List<Document_Provisioning__c> LstDP = new List<Document_Provisioning__c>();
        for(Id recId: mapInputProvReq.keySet()){            
            docProvIds = mapInputProvReq.get(recId);        
        }
        
        System.debug('*** The incoming Map of Ids to User Ids is *** ' + mapInputProvReq);
        
        if( ProvType.contains('Spec')){
            
            map<String,String> mapSpecIdsToTeamRoomId = new map<String,String>();
            if(ProvType.contains('TeamRoom')){
                for(Team_Room_Doc__c trd:[Select Id, Design_Spec__c, Team_Room__c from Team_Room_Doc__c where Design_Spec__c IN:mapInputProvReq.keySet()]){
                    mapSpecIdsToTeamRoomId.put(trd.Design_Spec__c,trd.Team_Room__c);    
                }       
            }
            LstDP = [ SELECT id,name,User__c,Design_Spec__c, Team_Rooms_Provisioned_for__c, Sub_PDK_Provisioned_for__c, Packages_Provisioned_for__c,is_De_Prov_From_UI__c
                    FROM Document_Provisioning__c WHERE  User__c IN:docProvIds AND Design_Spec__c IN:mapInputProvReq.keySet()];
            
            for(Document_Provisioning__c   dp   : LstDP){
                dp.Status__c = 'De-Provisioned' ;
                if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){
                   dp.is_De_Prov_From_UI__c=true;   
                }
                if(ProvType.contains('TeamRoom')){
                    String str = null;
                    List<String> TeamRoomNameList = new List<String>();
                    List<String> TeamRoomNameListFinal = new List<String>(); 
                    if(dp.Team_Rooms_Provisioned_for__c.contains(';')){
                        TeamRoomNameList.addAll(dp.Team_Rooms_Provisioned_for__c.split(';'));
                    }
                    else{
                        TeamRoomNameList.add(dp.Team_Rooms_Provisioned_for__c);
                    }
                    if(TeamRoomNameList!=null && TeamRoomNameList.size()>0){
                        for(String s: TeamRoomNameList){
                            if(s!= mapSpecIdsToTeamRoomId.get(dp.Design_Spec__c)){
                                TeamRoomNameListFinal.add(s);
                            }
                        }
                        if(TeamRoomNameListFinal!=null && TeamRoomNameListFinal.size()>0){
                            str = TeamRoomNameListFinal[0];
                            if(TeamRoomNameListFinal.size()>1){
                                for(Integer i=1;i<TeamRoomNameListFinal.size();i++){
                                    str = str + ';' + TeamRoomNameListFinal[i];                                       
                                }
                            }
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                        else{
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                    }
                }
                else{
                     dp.Spec_Level_Provisioning__c = false;                  
                }
                if((dp.Team_Rooms_Provisioned_for__c!=null)||(dp.Sub_PDK_Provisioned_for__c!=null)||(dp.Packages_Provisioned_for__c!=null)||

(dp.Spec_Level_Provisioning__c==true)){
                    dp.Status__c = 'Provisioned' ;      
                } 
            }            
            
        }
        
        else if( ProvType.contains('SubPDK')){
            List<id> DspecListId = new List<id>();
            map<id,id> mapSpecSubPdk = new map <id,id>();
            map<id,Sub_PDK__c> mapNameSubPdk = new map<id,Sub_PDK__c >([SELECT id,name FROM Sub_PDK__c WHERE Id IN:mapInputProvReq.keySet()]);
            
            map<String,String> mapSubPDKIdsToTeamRoomId = new map<String,String>();
            if(ProvType.contains('TeamRoom')){
                for(Team_Room_Doc__c trd:[Select Id, Sub_PDK__c, Team_Room__c from Team_Room_Doc__c where Sub_PDK__c IN:mapInputProvReq.keySet()]){
                    mapSubPDKIdsToTeamRoomId.put(trd.Sub_PDK__c,trd.Team_Room__c);  
                }       
            }    
            for(Document_Provisioning__c dp: [SELECT id,name,Status__c,Team_Rooms_Provisioned_for__c,Sub_PDK__c FROM Document_Provisioning__c 
            WHERE  User__c IN:docProvIds AND Sub_PDK__c IN:mapInputProvReq.keySet()]){
                dp.Status__c = 'De-Provisioned' ;
                
                if(ProvType.contains('TeamRoom')){
                    String str = null;
                    List<String> TeamRoomNameList = new List<String>();
                    List<String> TeamRoomNameListFinal = new List<String>(); 
                    if(dp.Team_Rooms_Provisioned_for__c.contains(';')){
                        TeamRoomNameList.addAll(dp.Team_Rooms_Provisioned_for__c.split(';'));
                    }
                    else{
                        TeamRoomNameList.add(dp.Team_Rooms_Provisioned_for__c);
                    }
                   
                    if(TeamRoomNameList!=null && TeamRoomNameList.size()>0){
                        for(String s: TeamRoomNameList){                            
                            if(s!= mapSubPDKIdsToTeamRoomId.get(dp.Sub_PDK__c)){
                                TeamRoomNameListFinal.add(s);
                            }
                        }
                        if(TeamRoomNameListFinal!=null && TeamRoomNameListFinal.size()>0){
                            str = TeamRoomNameListFinal[0];
                            if(TeamRoomNameListFinal.size()>1){
                                for(Integer i=1;i<TeamRoomNameListFinal.size();i++){
                                    str = str + ';' + TeamRoomNameListFinal[i];                                       
                                }
                            }
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                        else{
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                    }
                }
                if(dp.Team_Rooms_Provisioned_for__c!=null){
                    dp.Status__c = 'Provisioned' ;      
                }
                LstDP.add(dp); 
            }
            
            for(Sub_PDK_Spec__c sps: [SELECT id,name,Design_Spec__c,Sub_PDK__c FROM Sub_PDK_Spec__c WHERE Sub_PDK__c IN:mapInputProvReq.keySet()]){
                DspecListId.add(sps.Design_Spec__c);
                mapSpecSubPdk.put(sps.Design_Spec__c, sps.Sub_PDK__c);
            }
              
            for(Document_Provisioning__c dpupdate :[SELECT id,name,Sub_PDK_Provisioned_for__c,Design_Spec__c,User__c,Spec_Level_Provisioning__c FROM 

Document_Provisioning__c WHERE User__c IN:docProvIds AND Design_Spec__c IN:DspecListId]){
                String str = '';
                List<String> SubPdkNameList = new List<String>();
                List<String> SubPdkNameListFinal = new List<String>();                  
                if(dpupdate.Sub_PDK_Provisioned_for__c!=null){
                    if(dpupdate.Sub_PDK_Provisioned_for__c.contains(';')){
                        SubPdkNameList.addAll(dpupdate.Sub_PDK_Provisioned_for__c.split(';'));
                    }
                    else{
                        SubPdkNameList.add(dpupdate.Sub_PDK_Provisioned_for__c);
                    }
                    if(SubPdkNameList!=null && SubPdkNameList.size()>0){
                        for(String s: SubPdkNameList){
                            if(s!= mapNameSubPdk.get(mapSpecSubPdk.get(dpupdate.Design_Spec__c)).Id ){
                                SubPdkNameListFinal.add(s);
                            }
                        }
                        if(SubPdkNameListFinal!=null && SubPdkNameListFinal.size()>0){
                            str = SubPdkNameListFinal[0];
                            if(SubPdkNameListFinal.size()>1){
                                for(Integer i=1;i<SubPdkNameListFinal.size();i++){
                                    str = str + ';' + SubPdkNameListFinal[i];                                       
                                }
                            }
                            dpupdate.Sub_PDK_Provisioned_for__c = str;          
                        }
                        else{
                            dpupdate.Status__c = 'De-Provisioned' ; 
                            dpupdate.Sub_PDK_Provisioned_for__c = str;          
                        }
                    }
                }
                if(dpupdate.Spec_Level_Provisioning__c){
                    dpupdate.Status__c = 'Provisioned' ;            
                }
                LstDP.add(dpupdate);                
            } 
       
        }
                
        else if( ProvType.contains('Package')){
            List<id> DspecListId = new List<id>();
            map<id,id> mapSpecPackage = new map <id,id>();
            map<id,Package__c> mapNamePackage = new map<id,Package__c >([SELECT id,name FROM Package__c WHERE Id IN:mapInputProvReq.keySet()]);
            
            map<String,String> mapPackageIdsToTeamRoomId = new map<String,String>();
            if(ProvType.contains('TeamRoom')){
                for(Team_Room_Doc__c trd:[Select Id, Design_Package__c, Team_Room__c from Team_Room_Doc__c where Design_Package__c IN:mapInputProvReq.keySet()]){
                    mapPackageIdsToTeamRoomId.put(trd.Design_Package__c,trd.Team_Room__c);  
                }       
            } 
            for(Document_Provisioning__c dp: [SELECT id,is_De_Prov_From_UI__c,name,Status__c,Team_Rooms_Provisioned_for__c,Design_Package__c FROM Document_Provisioning__c 
            WHERE User__c IN:docProvIds AND Design_Package__c IN:mapInputProvReq.keySet()]){
                dp.Status__c = 'De-Provisioned' ;
                system.debug('enter pac');
                if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){//sunita 19th march
                   dp.is_De_Prov_From_UI__c=true;//sunita 19th march
                   }
                if(ProvType.contains('TeamRoom')){
                    String str = null;
                    List<String> TeamRoomNameList = new List<String>();
                    List<String> TeamRoomNameListFinal = new List<String>(); 
                    if(dp.Team_Rooms_Provisioned_for__c.contains(';')){
                        TeamRoomNameList.addAll(dp.Team_Rooms_Provisioned_for__c.split(';'));
                    }
                    else{
                        TeamRoomNameList.add(dp.Team_Rooms_Provisioned_for__c);
                    }
                    if(TeamRoomNameList!=null && TeamRoomNameList.size()>0){
                        for(String s: TeamRoomNameList){
                            if(s!= mapPackageIdsToTeamRoomId.get(dp.Design_Package__c)){
                                TeamRoomNameListFinal.add(s);
                            }
                        }
                        if(TeamRoomNameListFinal!=null && TeamRoomNameListFinal.size()>0){
                            str = TeamRoomNameListFinal[0];
                            if(TeamRoomNameListFinal.size()>1){
                                for(Integer i=1;i<TeamRoomNameListFinal.size();i++){
                                    str = str + ';' + TeamRoomNameListFinal[i];                                       
                                }
                            }
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                        else{
                            dp.Team_Rooms_Provisioned_for__c = str;          
                        }
                    }
                }
                if(dp.Team_Rooms_Provisioned_for__c!=null){
                    dp.Status__c = 'Provisioned' ;      
                }                
                LstDP.add(dp); 
            }
            
            for(Package_Spec__c sps: [SELECT id,name,Design_Spec__c,Package__c FROM Package_Spec__c WHERE Package__c IN:mapInputProvReq.keySet()]){
                DspecListId.add(sps.Design_Spec__c);
                mapSpecPackage.put(sps.Design_Spec__c, sps.Package__c);
            }
              
            for(Document_Provisioning__c dpupdate :[SELECT id,name,Packages_Provisioned_for__c,Design_Spec__c,User__c,Spec_Level_Provisioning__c FROM 

Document_Provisioning__c WHERE User__c IN:docProvIds AND Design_Spec__c IN:DspecListId]){
                String str = '';
                List<String> PackageNameList = new List<String>();
                List<String> PackageNameListFinal = new List<String>();                  
                if(dpupdate.Packages_Provisioned_for__c!=null){
                    if(dpupdate.Packages_Provisioned_for__c.contains(';')){
                        PackageNameList.addAll(dpupdate.Packages_Provisioned_for__c.split(';'));
                    }
                    else{
                        PackageNameList.add(dpupdate.Packages_Provisioned_for__c);
                    }
                    if(PackageNameList!=null && PackageNameList.size()>0){
                        for(String s: PackageNameList){
                            if(s!= mapNamePackage.get(mapSpecPackage.get(dpupdate.Design_Spec__c)).Id ){
                                PackageNameListFinal.add(s);
                            }
                        }
                        if(PackageNameListFinal!=null && PackageNameListFinal.size()>0){
                            str = PackageNameListFinal[0];
                            if(PackageNameListFinal.size()>1){
                                for(Integer i=1;i<PackageNameListFinal.size();i++){
                                    str = str + ';' + PackageNameListFinal[i];                                       
                                }
                            }
                            dpupdate.Packages_Provisioned_for__c = str;         
                        }
                        else{
                            dpupdate.Status__c = 'De-Provisioned' ; 
                            dpupdate.Packages_Provisioned_for__c = str;         
                        }
                    }
                }
                if(dpupdate.Spec_Level_Provisioning__c){
                    dpupdate.Status__c = 'Provisioned' ;            
                }
                LstDP.add(dpupdate);                
            } 
           
        }
        
        try{
            update LstDP;  
        }
        catch(Exception ex){
            
        }
    }

}