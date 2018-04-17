/*
Type Name: SwiftUtility
Author: Cognizant 
Created Date: 18-March-2014
Reason: This is a general utility class used for all generic functionalities across the scope of the project, 
        not pertaining to any specific module.
Change History:
Cognizant            18032014     -      Apex code created
Cognizant            29042014     -      Modified method checkChipUniqueness.
 */

public class SwiftUtility {

    public static Map<String, Error_Codes__c> mapEC = Error_Codes__c.getAll();
    public static Map<String, SWIFT_User_Group__c> mapPublicGroups = SWIFT_User_Group__c.getAll();

    
   
    /**
        This method fetches the Field Engineer Users corresponding to Customer Ids associated with a MST, DRT or PTRF.

        @method name: fetchFEUsers
        @parameter:   Set of Customer Ids associated with a MST, DRT or PTRF.
        @return :     Map of Customer Ids to Set of Associated Field Engineer Ids.
     **/

    public static Map<String, Set<String>> fetchFEUsers(Set<String> setAccIds)
    {
        Map<String, Set<String>> mapFEUsers = new Map<String, Set<String>>();
        //Set<String> setTeamRoles = New Set<String>{'Primary Field Technical Support','Field Technical Support','Field Application Engineer'};
        list<String> lstTeamRoles = new list<String>();
        lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');

        for(Account_Team_Proxy__c objATP:[Select User__c, Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN:setAccIds AND Team_Role__c IN:lstTeamRoles
        /*AND User__r.Profile.Name = 'GF FAE/FTS'*/ AND User__r.IsActive = True])
        {
            Set<String> tempSet = new Set<String>();
            String accountId = objATP.Account__c;

            if(mapFEUsers!=null){ 
                if(mapFEUsers.containsKey(accountId)){
                    tempSet.addAll(mapFEUsers.get(accountId));
                }
                tempSet.add(objATP.User__c);
                mapFEUsers.put(accountId, tempSet);
            }                   
        }

        return mapFEUsers ;

    }

    /**
        This method fetches the Customer Users corresponding to Customer Ids associated with a MST, DRT or PTRF.

        @method name: fetchCustomerUsers
        @parameter:   Set of Customer Ids associated with a MST, DRT or PTRF.
        @return :     Map of Customer Ids to Set of Associated Customer User Ids.
     **/

    public static Map<String, Set<String>> fetchCustomerUsers(Set<String> setAccIds)
    {
        Map<String, Set<String>> mapCustUsers = new Map<String, Set<String>>();

        for(User objUser:[Select Id, Parent_Account_Id__c, IsActive from User where Parent_Account_Id__c IN:setAccIds AND IsActive=true])
        {
            Set<String> tempSet = new Set<String>();
            String accountId = objUser.Parent_Account_Id__c;

            if(mapCustUsers!=null){ 
                if(mapCustUsers.containsKey(accountId)){
                    tempSet.addAll(mapCustUsers.get(accountId));
                }
                tempSet.add(objUser.Id);
                mapCustUsers.put(accountId, tempSet);
            }                   
        }

        return mapCustUsers ;

    }

    public static void checkDRTpackageSyncFunc(Set<String> DRTID){
        if(system.isbatch() || system.isFuture()){
            checkDRTpackageSyncFuncnonfuture(DRTID);
        }
        else{
            checkDRTpackageSyncFuncfuture(DRTID);
        }    
    }
    @future
    public static void checkDRTpackageSyncFuncfuture(Set<String> DRTID){
        checkDRTpackageSync(DRTID);    
    }
    public static void checkDRTpackageSyncFuncnonfuture(Set<String> DRTID){
        checkDRTpackageSync(DRTID);    
    }
   
    /**********************For MRS pack- start********/
     public static void checkMRSpackageSyncFunc(Set<String> mrsID){
        if(system.isbatch() || system.isFuture()){
            checkMRSpackageSyncFuncnonfuture(mrsID);
        }
        else{
            checkMRSpackageSyncFuncfuture(mrsID);
        }    
    }
    @future
    public static void checkMRSpackageSyncFuncfuture(Set<String> mrsID){
        MRSSwiftUtility.checkMRSpackageSync(mrsID);    
    } 
    public static void checkMRSpackageSyncFuncnonfuture(Set<String> mrsID){
        MRSSwiftUtility.checkMRSpackageSync(mrsID);    
    } 
    /******************For MRS pack- end***********/
   
 /**
        This method checks whether DRT package objects are in sync or not.

        @method name: checkDRTpackageSync
        @parameter:   Set of DRT ID
        @return :     None.
     **/

         public static void checkDRTpackageSync(Set<String> DRTID){
                   
            map<id,list<PRIME_DRT_Layer_Association__c>> mapdrtLayAss = new map<id,list<PRIME_DRT_Layer_Association__c>>();
            map<id,list<PRIME_DRT_Chip_Association__c>> mapdrtChipAss = new map<id,list<PRIME_DRT_Chip_Association__c>>();
            map<id,list<PRIME_DRT_Chip_Layer_Summary__c>> mapdrtChipLayAss = new map<id,list<PRIME_DRT_Chip_Layer_Summary__c>>();
            map<id,list<DRT_PTRF_Association__c>> mapdrtPTRFAss = new map<id,list<DRT_PTRF_Association__c>>();
            map<id,list<Frame_DRT_Association__c>> mapdrtFrameAss = new map<id,list<Frame_DRT_Association__c>>();
            map<id,drt__c> mapDRT = new map<id,drt__c>();
           
            if(DRTID != null && DRTID.size()>0)
            {                              
                list<string> lstDRTIds = new list<string>();
                lstDRTIds.addAll(DRTID);
                
                //Create a map of all DRT IDs with corresponding child object records
                for(drt__c iDRT : [select Synced_with_Oracle_DB__c from DRT__c where Id  in : DRTID])
                    {
                        mapDRT.put(iDRT.id,iDRt);
                    }
                
                
                for(PRIME_DRT_Layer_Association__c dLayer : [select Synced_with_Oracle_DB__c,drt__c from PRIME_DRT_Layer_Association__c where DRT__c in :DRTID and IsSoftDeleted__c = False])
                {                 
                    if(mapdrtLayAss!=null && mapdrtLayAss.keySet().size()>0 && mapdrtLayAss.containskey(dLayer.drt__c)){
                        list<PRIME_DRT_Layer_Association__c> temp = new list<PRIME_DRT_Layer_Association__c>();
                        temp = mapdrtLayAss.get(dLayer.drt__c);
                        temp.add(dLayer);
                        mapdrtLayAss.put(dLayer.drt__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Layer_Association__c> temp = new list<PRIME_DRT_Layer_Association__c>();
                        temp.add(dLayer);
                        mapdrtLayAss.put(dLayer.drt__c,temp);
                    }
                }
                
                
                for(PRIME_DRT_Chip_Association__c dChip :[select drt__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Association__c where drt__c in :DRTID and IsSoftDeleted__c = False])
                {                 
                    if(mapdrtChipAss!=null && mapdrtChipAss.keySet().size()>0 && mapdrtChipAss.containskey(dChip.drt__c)){
                        list<PRIME_DRT_Chip_Association__c> temp = new list<PRIME_DRT_Chip_Association__c>();
                        temp = mapdrtChipAss.get(dChip.drt__c);
                        temp.add(dChip);
                        mapdrtChipAss.put(dChip.drt__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Chip_Association__c> temp = new list<PRIME_DRT_Chip_Association__c>();
                        temp.add(dChip);
                        mapdrtChipAss.put(dChip.drt__c,temp);
                    }
                }
                      
                
                for(PRIME_DRT_Chip_Layer_Summary__c dChipLayer : [select drt_ID__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.DRT__c in :DRTID and Layer__r.IsSoftDeleted__c = False and Chip__r.IsSoftDeleted__c = False])
                {                 
                    if(mapdrtChipLayAss!=null && mapdrtChipLayAss.keySet().size()>0 && mapdrtChipLayAss.containskey(dChipLayer.drt_ID__c)){
                        list<PRIME_DRT_Chip_Layer_Summary__c> temp = new list<PRIME_DRT_Chip_Layer_Summary__c>();
                        temp = mapdrtChipLayAss.get(dChipLayer.drt_ID__c);
                        temp.add(dChipLayer);
                        mapdrtChipLayAss.put(dChipLayer.drt_ID__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Chip_Layer_Summary__c> temp = new list<PRIME_DRT_Chip_Layer_Summary__c>();
                        temp.add(dChipLayer);
                        mapdrtChipLayAss.put(dChipLayer.drt_ID__c,temp);
                    }
                }
                
                
                for(DRT_PTRF_Association__c dPTRF : [select drt__c,Synced_with_Oracle_DB__c from DRT_PTRF_Association__c where DRT__c in :DRTID])
                {                 
                    if(mapdrtPTRFAss!=null && mapdrtPTRFAss.keySet().size()>0 && mapdrtPTRFAss.containskey(dPTRF.drt__c)){
                        list<DRT_PTRF_Association__c> temp = new list<DRT_PTRF_Association__c>();
                        temp = mapdrtPTRFAss.get(dPTRF.drt__c);
                        temp.add(dPTRF);
                        mapdrtPTRFAss.put(dPTRF.drt__c,temp);
                    }
                    else{
                        list<DRT_PTRF_Association__c> temp = new list<DRT_PTRF_Association__c>();
                        temp.add(dPTRF);
                        mapdrtPTRFAss.put(dPTRF.drt__c,temp);
                    }
                }
                
                
                for(Frame_DRT_Association__c dFrame : [select drt__c,Synced_with_Oracle_DB__c from Frame_DRT_Association__c where DRT__c in :DRTID])
                {                 
                    if(mapdrtFrameAss!=null && mapdrtFrameAss.keySet().size()>0 && mapdrtFrameAss.containskey(dFrame.drt__c)){
                        list<Frame_DRT_Association__c> temp = new list<Frame_DRT_Association__c>();
                        temp = mapdrtFrameAss.get(dFrame.drt__c);
                        temp.add(dFrame);
                        mapdrtFrameAss.put(dFrame.drt__c,temp);
                    }
                    else{
                        list<Frame_DRT_Association__c> temp = new list<Frame_DRT_Association__c>();
                        temp.add(dFrame);
                        mapdrtFrameAss.put(dFrame.drt__c,temp);
                    }
                }
                set<ID> setDRToutofSync = new set<ID>();
                
            if(lstDRTIds!=null && lstDRTIds.size()>0){              

                for(DRT__C obj : mapDRT.values()){
                        if(obj.Synced_with_Oracle_DB__c == FALSE){
                            system.debug('***mapDRT:'+obj.Synced_with_Oracle_DB__c);
                            setDRToutofSync.add(obj.id);   
                        } 
                    }
                for(ID iDRTID :lstDRTIds){                   
                   if(mapdrtLayAss!=null && mapdrtLayAss.containskey(iDRTID) && mapdrtLayAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Layer_Association__c obj : mapdrtLayAss.get(iDRTID)){
                            system.debug('***mapdrtLayAss:'+obj.Synced_with_Oracle_DB__c);
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }                  
                    if(mapdrtChipAss!=null && mapdrtChipAss.containskey(iDRTID) && mapdrtChipAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Chip_Association__c obj : mapdrtChipAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }                   
                    if(mapdrtChipLayAss!=null && mapdrtChipLayAss.containskey(iDRTID) && mapdrtChipLayAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Chip_Layer_Summary__c obj : mapdrtChipLayAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt_ID__c);
                        }        
                    }
                    
                    if(mapdrtPTRFAss!=null && mapdrtPTRFAss.containskey(iDRTID) && mapdrtPTRFAss.get(iDRTID).size()>0){
                        for(DRT_PTRF_Association__c obj : mapdrtPTRFAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }
                    
                    if(mapdrtFrameAss!=null && mapdrtFrameAss.containskey(iDRTID) && mapdrtFrameAss.get(iDRTID).size()>0){
                        for(Frame_DRT_Association__c obj : mapdrtFrameAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }
                }
            }

            list<DRT__c> lstDRTupdate = new list<DRT__c>();
            lstDRTupdate = [select id from DRT__c where id in :DRTID and Id NOT in :setDRToutofSync];
            if(lstDRTupdate!=null && lstDRTupdate.size()>0){
                for(DRT__c temp:lstDRTupdate){

                    temp.DRT_Package_Sync__c = TRUE;                                  
                }
                try
                {
                update lstDRTupdate;
                }
                catch(Exception e)
                {
                system.debug('Exception during updation'+ e);
                }
            }
           }
            
   }

/**
        This method checks whether MRS package objects are in sync or not.

        @method name: checkMRSpackageSync
        @parameter:   Set of MRS ID
        @return :     None.
     **/

  /**  public static void checkMRSpackageSync(Set<String> MRSID){
    map<id,list<MRS_Chip_Details__c>> mapChipDetails = new map<id,list<MRS_Chip_Details__c>>();
    map<id,list<MRS_Layer_Association__c>> mapLayerAssoc = new map<id,list<MRS_Layer_Association__c>>();
    map<id,list<MRS_Layer_Chip_Association__c>> mapLayerChipAssoc = new map<id,list<MRS_Layer_Chip_Association__c>>();
    map<id,list<Notes__c>> mapNotes = new map<id,list<Notes__c>>(); //Notes_c    
    map<id,MRS__c> mapMRS = new map<id,MRS__c>();
    
    if(MRSID != null && MRSID.size()>0){
        List<String> lstMRSIds = new List<String>();
        lstMRSIds.addAll(MRSID);
        
    
     //Create a map of all MRS IDs with corresponding child object records  
     for(MRS__c mrs :[SELECT Synced_with_Oracle_DB__c from MRS__c WHERE Id IN :MRSID]){
         mapMRS.put(mrs.Id,mrs);
         } 
     // Fetch MRS Chip Details records     
     for(MRS_Chip_Details__c m :[SELECT Synced_with_Oracle_DB__c,MRS__c from MRS_Chip_Details__c WHERE MRS__c IN :MRSID]){
         if(mapChipDetails!= null && mapChipDetails.keyset().size()>0 && mapChipDetails.containskey(m.MRS__c)){
             list<MRS_Chip_Details__c> temp = new list<MRS_Chip_Details__c>();
             temp = mapChipDetails.get(m.MRS__c);
             temp.add(m);
             mapChipDetails.put(m.MRS__c,temp);
             } 
             else{
             list<MRS_Chip_Details__c> temp = new list<MRS_Chip_Details__c>();
             temp.add(m);
             mapChipDetails.put(m.MRS__c,temp);    
             }
             
         }
      // Fetch MRS Layer Association records
         for(MRS_Layer_Association__c m :[SELECT Synced_with_Oracle_DB__c,MRS__c from MRS_Layer_Association__c WHERE MRS__c IN :MRSID]){
         system.debug('MRS_Layer_Association__c***'+m);
         if(mapLayerAssoc!= null && mapLayerAssoc.keyset().size()>0 && mapLayerAssoc.containskey(m.MRS__c)){
             list<MRS_Layer_Association__c> temp = new list<MRS_Layer_Association__c>();
             temp = mapLayerAssoc.get(m.MRS__c);
             temp.add(m);
             mapLayerAssoc.put(m.MRS__c,temp);
             } 
             else{
             list<MRS_Layer_Association__c> temp = new list<MRS_Layer_Association__c>();
             temp.add(m);
             mapLayerAssoc.put(m.MRS__c,temp);
             system.debug('mapLayerAssoc***'+mapLayerAssoc);    
             }
             
         }
     // Fetch MRS Layer Chip records      
    for(MRS_Layer_Chip_Association__c m :[SELECT Synced_with_Oracle_DB__c,Layer__r.MRS__c from MRS_Layer_Chip_Association__c WHERE Layer__r.MRS__c IN :MRSID]){
         if(mapLayerChipAssoc!= null && mapLayerChipAssoc.keyset().size()>0 && mapLayerChipAssoc.containskey(m.Layer__r.MRS__c)){
             list<MRS_Layer_Chip_Association__c> temp = new list<MRS_Layer_Chip_Association__c>();
             temp = mapLayerChipAssoc.get(m.Layer__r.MRS__c);
             temp.add(m);
             mapLayerChipAssoc.put(m.Layer__r.MRS__c,temp);
             } 
             else{
             list<MRS_Layer_Chip_Association__c> temp = new list<MRS_Layer_Chip_Association__c>();
             temp.add(m);
             mapLayerChipAssoc.put(m.Layer__r.MRS__c,temp);    
             }
             
         } 
         
     // Fetch Notes records      
    for(Notes__c m :[SELECT Synced_with_Oracle_DB__c,MRS_ID__c from Notes__c WHERE MRS_ID__c IN :MRSID]){
         if(mapNotes!= null && mapNotes.keyset().size()>0 && mapNotes.containskey(m.MRS_ID__c)){
             list<Notes__c> temp = new list<Notes__c>();
             temp = mapNotes.get(m.MRS_ID__c);
             temp.add(m);
             mapNotes.put(m.MRS_ID__c,temp);
             } 
             else{
             list<Notes__c> temp = new list<Notes__c>();
             temp.add(m);
             mapNotes.put(m.MRS_ID__c,temp);    
             }
             
         }
     set<ID> setMRSoutofSync = new set<ID>();
     if(lstMRSIds!=null && lstMRSIds.size()>0){
         for(MRS__C obj : mapMRS.values()){
                        if(obj.Synced_with_Oracle_DB__c == FALSE){
                            setMRSoutofSync.add(obj.id);   
                        } 
                    }        
             
         for(ID mId :lstMRSIds){
                    
                   if(mapChipDetails!=null && mapChipDetails.containskey(mId) && mapChipDetails.get(mId).size()>0){
                        for(MRS_Chip_Details__c obj : mapChipDetails.get(mId)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setMRSoutofSync.add(obj.MRS__c);
                        }        
                    }
                    if(mapLayerAssoc!=null && mapLayerAssoc.containskey(mId) && mapLayerAssoc.get(mId).size()>0){
                        for(MRS_Layer_Association__c obj : mapLayerAssoc.get(mId)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setMRSoutofSync.add(obj.MRS__c);
                        }        
                    }
                    if(mapLayerChipAssoc!=null && mapLayerChipAssoc.containskey(mId) && mapLayerChipAssoc.get(mId).size()>0){
                        for(MRS_Layer_Chip_Association__c obj : mapLayerChipAssoc.get(mId)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setMRSoutofSync.add(obj.Layer__r.MRS__c);
                        }        
                    }
                    if(mapNotes!=null && mapNotes.containskey(mId) && mapNotes.get(mId).size()>0){
                        for(Notes__c obj : mapNotes.get(mId)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setMRSoutofSync.add(obj.MRS_ID__c);
                        }        
                    }
                }
            }  
            list<MRS__c> lstMRSupdate = new list<MRS__c>();
                      
            lstMRSupdate = [select id from MRS__c where id in :MRSID and Id NOT in :setMRSoutofSync];
            if(lstMRSupdate!=null && lstMRSupdate.size()>0){
                for(MRS__c temp:lstMRSupdate){
                    temp.MRS_Package_Sync__c = TRUE;
                }
                try
                {
                update lstMRSupdate;
                }
                catch(Exception e)
                {
                system.debug('Exception during updation'+ e);
                }
            }  
            
                  
        }
        
    } **/   
    //Method to trigger DRT Package Sync
    @future
    public static void drtPckgSyncTrigger(set<id> drtIds){
        list<drt__c> lstDRT = new list<drt__c>();
        lstDRT = [select id from DRT__c where id in :drtIds];
        if(lstDRT!=null && lstDRT.size()>0){
            for(drt__c drt :lstDRT){
                drt.Synced_with_Oracle_DB__c = false;
            }
            update lstDRT;
        }
    }
}