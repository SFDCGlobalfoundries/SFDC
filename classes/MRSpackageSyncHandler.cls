/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: sfdc - .net Integration Webservice
History:
created     29/5/2014     
*/
public class MRSpackageSyncHandler{

    //Method to invoke sync of MRS child objects
    public static void invokeMRSchldSync(set<id> mrsIds){
        list<MRS_Chip_Details__c> lstMRSChip =  new list<MRS_Chip_Details__c>([select id from MRS_Chip_Details__c where MRS__c in :mrsIds]);
        list<MRS_Layer_Association__c> lstMRSLayer =  new list<MRS_Layer_Association__c>([select id from MRS_Layer_Association__c where MRS__c in :mrsIds]);
        

        if(lstMRSChip.size()>0){
            for(MRS_Chip_Details__c rec :lstMRSChip){
                rec.First_Sync_with_Oracle__c=true;
            }
            update lstMRSChip;
        }

        if(lstMRSLayer.size()>0){
            for(MRS_Layer_Association__c rec :lstMRSLayer){
                rec.First_Sync_with_Oracle__c=true;
            }
            update lstMRSLayer;
        }
    }
    
    //Method to invoke sync of MRS Layer Chip object records
    public static void syncMRSLayerChip(set<string> mrsIds){
        list<MRS_Chip_Details__c> lstMRSChip = new list<MRS_Chip_Details__c>();
        list<MRS_Layer_Association__c> lstMRSlayer = new list<MRS_Layer_Association__c>(); 
        list<MRS_Layer_Chip_Association__c> lstlayerChip = new list<MRS_Layer_Chip_Association__c>();
        set<id> setMRSchip = new set<id>();
        set<id> setMRSlayer = new set<id>();
        set<id> setupdateMRS = new set<id>();
        lstMRSChip = [select MRS__c from MRS_Chip_Details__c where Created_at_Oracle_DB__c=false  and MRS__c in :mrsIds];
        lstMRSlayer = [select MRS__c from MRS_Layer_Association__c where Created_at_Oracle_DB__c=false  and MRS__c in :mrsIds];
        set<string> setMRSlayeroutofsync = new set<string>();
        //
        //
        
        if(lstMRSChip!=null && lstMRSChip.size()>0){
            for(MRS_Chip_Details__c chip:lstMRSChip){
                setMRSchip.add(chip.MRS__c);
                //
            }
        }
        
        if(lstMRSlayer!=null && lstMRSlayer.size()>0){
            for(MRS_Layer_Association__c layer :lstMRSlayer){
                setMRSlayer.add(layer.MRS__c);
                //
            }
        }
        list<string> lstIds = new list<string>(); 
        lstIds.addALl(mrsIds);
        for(id objID :lstIds){
            if(setMRSchip!=null && !setMRSchip.isEmpty()){
               if(setMRSchip.contains(objID))
                   setMRSlayeroutofsync.add(objID);
            } 
            if(setMRSlayer!=null && !setMRSlayer.isEmpty()){
               if(setMRSlayer.contains(objID)) 
                   setMRSlayeroutofsync.add(objID);
                }    
            if(setMRSlayeroutofsync.isEmpty() || (!setMRSlayeroutofsync.isEmpty() && !setMRSlayeroutofsync.contains(objID)))
                setupdateMRS.add(objID); 
                
        }
        //
        
        if(setupdateMRS!=null && !setupdateMRS.isEmpty()){
        set<string> setMST = new set<string>();
        set<string> setMSToutofSync = new set<string>();
                
        for(MRS__c mrs: [select Mask_Set_Title__c from MRS__C where id in :setupdateMRS]){
            if(mrs.Mask_Set_Title__c!=null){
            setMST.add(string.valueOf(mrs.Mask_Set_Title__c).substring(0,15));
            setMST.add(string.valueOf(mrs.Mask_Set_Title__c));
            }
        }
        for(MRS__c mrs: [select Mask_Set_Title__c from MRS__C where id in :setMRSlayeroutofsync]){
            if(mrs.Mask_Set_Title__c!=null){
                setMSToutofSync.add(string.valueOf(mrs.Mask_Set_Title__c).substring(0,15));
                setMSToutofSync.add(string.valueOf(mrs.Mask_Set_Title__c));
            }
        }
        
         lstlayerChip=[select id from MRS_Layer_Chip_Association__c where Mask_Set_Title_Id__c  in :setMST and Mask_Set_Title_Id__c  NOT in :setMSToutofSync];  
         //
         if(lstlayerChip!=null && lstlayerChip.size()>0){
             for(MRS_Layer_Chip_Association__c lc :lstlayerChip){
                 lc.First_Sync_with_Oracle__c = true;    
                 // 
             }
             //
             update lstlayerChip;
         }  
        }
        
    }
    
    //****
    //Method to invoke sync of MRS Note object records
    public static void syncMRSNotes(set<string> mrsIds){
        list<MRS_Layer_Chip_Association__c> lstlayerChip = new list<MRS_Layer_Chip_Association__c>();
        list<Notes__c> lstNotes = new list<Notes__c>();
        set<id> setMRSlayerChip = new set<id>();
        set<id> setupdateMRS = new set<id>();
        
        set<string> setMST = new set<string>();
        for(MRS__c mrs: [select Mask_Set_Title__c from MRS__C where id in :mrsIds]){
            if(mrs.Mask_Set_Title__c!=null){
              setMST.add(string.valueOf(mrs.Mask_Set_Title__c).substring(0,15));
              setMST.add(string.valueOf(mrs.Mask_Set_Title__c));
            }
        }
        lstlayerChip = [select MRS_ID__c from MRS_Layer_Chip_Association__c where Created_at_Oracle_DB__c=false  and Mask_Set_Title_Id__c  in :setMST];
        set<string> setMRSlayeroutofsync = new set<string>();
              
        if(lstlayerChip !=null && lstlayerChip.size()>0){
            for(MRS_Layer_Chip_Association__c layer :lstlayerChip){
                setMRSlayerChip.add(layer.MRS_ID__c);
                
            }
        }
        list<string> lstIds = new list<string>(); 
        lstIds.addALl(mrsIds);
        for(id objID :lstIds){
             
            if(setMRSlayerChip!=null && !setMRSlayerChip.isEmpty()){
               if(setMRSlayerChip.contains(objID)) 
                   setMRSlayeroutofsync.add(objID);
                }    
            if(setMRSlayeroutofsync.isEmpty() || (!setMRSlayeroutofsync.isEmpty() && !setMRSlayeroutofsync.contains(objID)))
                setupdateMRS.add(objID); 
                
        }
        //
        
        if(setupdateMRS!=null && !setupdateMRS.isEmpty()){
         lstNotes=[select id from Notes__c where MRS_ID__c in :setupdateMRS and MRS_ID__c NOT in :setMRSlayeroutofsync];  
         //
         if(lstNotes!=null && lstNotes.size()>0){
             for(Notes__c lc :lstNotes){
                 lc.First_Sync_with_Oracle__c = true;    
                 // 
             }
             //
             update lstlayerChip;
         }  
        }
        
    }
}