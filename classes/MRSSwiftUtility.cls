/*
Type Name: MRSSwiftUtility
Author: Cognizant 
Created Date: 18-March-2014
Reason: This is a general utility class used for all generic functionalities across the scope of the project, 
        not pertaining to any specific module.
Change History:
Cognizant            18032014     -      Apex code created
Cognizant            29042014     -      Modified method checkChipUniqueness.
SWIFT 4-Oct-2016: add AND Synced_with_Oracle_DB__c = false across to soql queries in this class
*/
public class MRSSwiftUtility {

    /**
    This method checks whether MRS package objects are in sync or not.
    @method name: checkMRSpackageSync
    @parameter:   Set of MRS ID
    @return :     None.
    **/
    public static boolean bLayerStatus = TRUE;
    
    public static void checkMRSpackageSync(Set < String > MRSID) {

        map < id, list < MRS_Chip_Details__c >> mapChipDetails = new map < id, list < MRS_Chip_Details__c >> ();
        map < id, list < MRS_Layer_Association__c >> mapLayerAssoc = new map < id, list < MRS_Layer_Association__c >> ();
        map < id, list < MRS_Layer_Chip_Association__c >> mapLayerChipAssoc = new map < id, list < MRS_Layer_Chip_Association__c >> ();
        map < id, MRS__c > mapMRS = new map < id, MRS__c > ();
        string[] objRecName;

        try {
            if (MRSID != null && MRSID.size() > 0) {
                List < String > lstMRSIds = new List < String > ();
                lstMRSIds.addAll(MRSID);


                //Create a map of all DRT IDs with corresponding child object records  
                for (MRS__c mrs: [SELECT Synced_with_Oracle_DB__c FROM MRS__c WHERE Id IN: MRSID
                AND Synced_with_Oracle_DB__c = false]) {//swift added
                    mapMRS.put(mrs.Id, mrs);
                }
                
                // Fetch MRS Chip Details records     
                for (MRS_Chip_Details__c m: [SELECT Synced_with_Oracle_DB__c, MRS__c from MRS_Chip_Details__c 
                WHERE MRS__c IN: MRSID AND Synced_with_Oracle_DB__c = false]) {//swift added
                    //=====================================
                    if (mapChipDetails != null && mapChipDetails.keyset().size() > 0 && mapChipDetails.containskey(m.MRS__c)) {
                        list < MRS_Chip_Details__c > temp = new list < MRS_Chip_Details__c > ();
                        temp = mapChipDetails.get(m.MRS__c);
                        temp.add(m);
                        mapChipDetails.put(m.MRS__c, temp);
                    } else {
                        list < MRS_Chip_Details__c > temp = new list < MRS_Chip_Details__c > ();
                        temp.add(m);
                        mapChipDetails.put(m.MRS__c, temp);
                    }

                }
                
                // Fetch MRS Layer Association records
                for (MRS_Layer_Association__c m: [SELECT Synced_with_Oracle_DB__c, MRS__c from MRS_Layer_Association__c 
                WHERE MRS__c IN: MRSID AND Synced_with_Oracle_DB__c = false]) {//swift added
                    //=====================================
                    if (mapLayerAssoc != null && mapLayerAssoc.keyset().size() > 0 && mapLayerAssoc.containskey(m.MRS__c)) {
                        list < MRS_Layer_Association__c > temp = new list < MRS_Layer_Association__c > ();
                        temp = mapLayerAssoc.get(m.MRS__c);
                        temp.add(m);
                        mapLayerAssoc.put(m.MRS__c, temp);
                    } else {
                        list < MRS_Layer_Association__c > temp = new list < MRS_Layer_Association__c > ();
                        temp.add(m);
                        mapLayerAssoc.put(m.MRS__c, temp);
                    }
                }
                
                // Fetch MRS Layer Chip records      
                set < string > setMST = new set < string > ();
                for (MRS__c mrs: [select Mask_Set_Title__c from MRS__C where id in : MRSID]) {
                    if (mrs.Mask_Set_Title__c != null) {
                        setMST.add(string.valueOf(mrs.Mask_Set_Title__c).substring(0, 15));
                        setMST.add(string.valueOf(mrs.Mask_Set_Title__c));
                    }
                }
                
                //swift added AND Synced_with_Oracle_DB__c = false
                for (MRS_Layer_Chip_Association__c m: [SELECT Synced_with_Oracle_DB__c, Layer__r.MRS__c, Mask_Set_Title_Id__c from MRS_Layer_Chip_Association__c 
                WHERE Mask_Set_Title_Id__c in : setMST AND Synced_with_Oracle_DB__c = false]) {//swift added
                    //=====================================
                    if (mapLayerChipAssoc != null && mapLayerChipAssoc.keyset().size() > 0 && mapLayerChipAssoc.containskey(m.Layer__r.MRS__c)) {
                        list < MRS_Layer_Chip_Association__c > temp = new list < MRS_Layer_Chip_Association__c > ();
                        temp = mapLayerChipAssoc.get(m.Layer__r.MRS__c);
                        temp.add(m);
                        mapLayerChipAssoc.put(m.Layer__r.MRS__c, temp);
                    } else {
                        list < MRS_Layer_Chip_Association__c > temp = new list < MRS_Layer_Chip_Association__c > ();
                        temp.add(m);
                        mapLayerChipAssoc.put(m.Layer__r.MRS__c, temp);
                    }
                }
                
                set < ID > setMRSoutofSync = new set < ID > ();
                if (lstMRSIds != null && lstMRSIds.size() > 0) {
                    for (MRS__C obj: mapMRS.values()) {
                        if (obj.Synced_with_Oracle_DB__c == FALSE) {
                            setMRSoutofSync.add(obj.id);
                        }
                    }

                    for (ID mId: lstMRSIds) {

                        if (mapChipDetails != null && mapChipDetails.containskey(mId) && mapChipDetails.get(mId).size() > 0) {
                            for (MRS_Chip_Details__c obj: mapChipDetails.get(mId)) {
                                if (obj.Synced_with_Oracle_DB__c == FALSE)
                                    setMRSoutofSync.add(obj.MRS__c);
                            }
                        }
                        
                        if (mapLayerAssoc != null && mapLayerAssoc.containskey(mId) && mapLayerAssoc.get(mId).size() > 0) {
                            for (MRS_Layer_Association__c obj: mapLayerAssoc.get(mId)) {
                                if (obj.Synced_with_Oracle_DB__c == FALSE)
                                    setMRSoutofSync.add(obj.MRS__c);
                            }
                        }
                        
                        if (mapLayerChipAssoc != null && mapLayerChipAssoc.containskey(mId) && mapLayerChipAssoc.get(mId).size() > 0) {
                            for (MRS_Layer_Chip_Association__c obj: mapLayerChipAssoc.get(mId)) {
                                if (obj.Synced_with_Oracle_DB__c == FALSE)
                                    setMRSoutofSync.add(obj.Layer__r.MRS__c);
                            }
                        }
                    }
                }
                
                list < MRS__c > lstMRSupdate = new list < MRS__c > ();
                lstMRSupdate = [select id, Name from MRS__c where id in : MRSID and Id NOT in : setMRSoutofSync];
                
                if (lstMRSupdate != null && lstMRSupdate.size() > 0) {
                    objRecName = new string[lstMRSupdate.size()];
                    
                    for (MRS__c temp: lstMRSupdate) {
                        temp.MRS_Package_Sync__c = TRUE;
                        objRecName.add(temp.Name);
                    }
                    
                    update lstMRSupdate;
                }
            }
        } catch (Exception e) {
            DRTHandlerUtility.handleError(e, 'Exception on MRS Sync', objRecName);
        }
    }

    // Method to send Layer Status update to dot NET System
    public static void sendLayerStatusUpdate(set < id > setLayerIds) {
        if (System.isFuture() || System.isBatch()) sendLayerStatusUpdateNonFuture(setLayerIds);
        else sendLayerStatusUpdateFuture(setLayerIds);
    }
    
    @future 
    public static void sendLayerStatusUpdateFuture(set < id > setLayerIds) {
        sendLayerStatusUpdateNonFuture(setLayerIds);
    }
    
    public static void sendLayerStatusUpdateNonFuture(set < id > setLayerIds) {
        
        map < string, MRS_Layer_Chip_Association__c > mapPTRFlayerChip = new map < string, MRS_Layer_Chip_Association__c > ();
        
        if (setLayerIds != null && !setLayerIds.isEmpty()) {
            //============================================================================
            //swgp-983
            map<string, list<mrs_layer_chip_association__c>> mapLayerChipPerPtrfLayer = new map<string, list<mrs_layer_chip_association__c>>();
            //add more fields into soql
            for (MRS_Layer_Chip_Association__c lc: [select id,PTRF__c,Layer__c,layer_chip_status__c,layer__r.layer_status__c from MRS_Layer_Chip_Association__c where Layer__c in : setLayerIds]) {

                String key = lc.PTRF__c + '' + lc.Layer__c;

                if(!mapLayerChipPerPtrfLayer.containsKey(key)) mapLayerChipPerPtrfLayer.put(key, new list<MRS_Layer_Chip_Association__c>());
                
                //each layer+ptrfNumber will hold a list of layer chip belong to the ptrf and layer
                list<mrs_layer_chip_association__c> tempList = (list<mrs_layer_chip_association__c>) mapLayerChipPerPtrfLayer.get(key);
                tempList.add(lc);
                mapLayerChipPerPtrfLayer.put(key, tempList);
            }

            list<mrs_layer_chip_association__c> sendLayerStatusList = new list<mrs_layer_chip_association__c>();
            
            for(String key: mapLayerChipPerPtrfLayer.keySet()) {

                for(MRS_Layer_Chip_Association__c m: mapLayerChipPerPtrfLayer.get(key)) {
                    
                    //swgp-1006: include cancel as well
                    //if(m.layer_chip_status__c != 'Void' || m.layer__r.layer_status__c == 'Void') { //<<< this line is swgp-983
                    if(!'Void;Cancel'.contains(m.layer_chip_status__c) || 'Void;Cancel'.contains(m.layer__r.layer_status__c)) {//<<< this line is swgp-983 and swgp-1006
                        //send >>> break inner loop
                        m.Trigger_Sync_Layer_Status__c = true;
                        sendLayerStatusList.add(m);
                        break;
                    }
                }
            }
            
            if(!sendLayerStatusList.isEmpty()) {
                try {
                    update sendLayerStatusList;
                } catch(Exception e) {
                    //put-in retry here - resend layer status to .net
                    MRSPLMDRWServiceHandler.logUnhandledException(
                        e,
                        json.serialize(setLayerIds), 
                        'SEND-LAYER-STATUS-' + String.valueOf(system.now()), 
                        'MRSSwiftUtility', 
                        'sendLayerStatusUpdate', 
                        ''
                    );
                }
            }
            //swgp-983-end
            //============================================================================
        }
    }
}