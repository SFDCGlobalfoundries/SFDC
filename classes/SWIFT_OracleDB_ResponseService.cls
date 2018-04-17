/*
Author:Mahendra Singh,bhavana mohan
Company: Cognizant
Description: Response service for Oracle DB Integration
History:
created date: 24/Apr/2014     
*/


global with sharing class SWIFT_OracleDB_ResponseService {

global class OracleDBResponseProxy
{
webservice string SFDCID;
webservice datetime LastSyncTimestamp;
webservice string status;
webservice string errorMessage;
webservice string DRT_Name;
}

//Method to sync Oracle DB response, this method is common to all Oracle DB sync objects and is called for one type of object nly in a single call.
webservice static void syncOracleDBResponse(list<OracleDBResponseProxy> inboundlstResponseOracleDB)
{
    
    map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap = new map<Id,OracleDBResponseProxy>();
    list<sObject> ResponseDRT_UpdationList = new list<sObject>();
    Id firstElement ;
    String queryString;
    string objectName;
    string integrationPayload = '';
    //
    try{
    for(OracleDBResponseProxy responseDataIns : inboundlstResponseOracleDB)
    {
        sfdcIdResponseDataMap.put(responseDataIns.SFDCID,responseDataIns );
        integrationPayload = integrationPayload + 'SFDCID:"'+ responseDataIns.SFDCID + '"'+'LastSyncTimestamp:"' + responseDataIns.LastSyncTimestamp +'"'+ 'status:"'+ responseDataIns.status + '"' +'errorMessage:"' + responseDataIns.errorMessage +'"';      
    } 
  
    for (Id setElement : sfdcIdResponseDataMap.keySet()) 
    {
        firstElement = setElement;
        break;
    }
    if(firstElement.getSObjectType() == PRIME_DRT_Chip_Association__c.sObjectType)
    {
        objectName = 'PRIME DRT Chip Association';
        list<PRIME_DRT_Chip_Association__c> primeDrtChipList = new list<PRIME_DRT_Chip_Association__c>();
        for(PRIME_DRT_Chip_Association__c primeDrtChip : PRIME_DRT_Chip_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == primeDrtChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (primeDrtChip.Last_Sync_Request_Timestamp__c == null || primeDrtChip.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtChip.Synced_with_Oracle_DB__c = True;
                primeDrtChip.Created_at_Oracle_DB__c = True;
                primeDrtChip.Error_Message_Oracle_DB__c = ''; 
                primeDrtChip.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == primeDrtChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (primeDrtChip.Last_Sync_Request_Timestamp__c == null || primeDrtChip.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtChip.Synced_with_Oracle_DB__c = False;
                primeDrtChip.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                primeDrtChip.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            primeDrtChipList.add(primeDrtChip); 
        }
        try
        {
        update primeDrtChipList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    if(firstElement.getSObjectType() == PRIME_DRT_Chip_Layer_Summary__c.sObjectType)
    {
        objectName = 'PRIME DRT Chip Layer Summary';
        list<PRIME_DRT_Chip_Layer_Summary__c> primeDrtChipLayerList = new list<PRIME_DRT_Chip_Layer_Summary__c>();
        for(PRIME_DRT_Chip_Layer_Summary__c primeDrtChipLayer : PRIME_DRT_Chip_Layer_Summary_Query(sfdcIdResponseDataMap))
        {
            list<id> lstid = new list<id>();
            lstid.addall(sfdcIdResponseDataMap.keySet());
            for(string sfdcId : lstid)
            {
            if(sfdcId == primeDrtChipLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (primeDrtChipLayer.Last_Sync_Request_Timestamp__c == null || primeDrtChipLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtChipLayer.Synced_with_Oracle_DB__c = True;
                primeDrtChipLayer.Error_Message_Oracle_DB__c = ''; 
                primeDrtChipLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == primeDrtChipLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (primeDrtChipLayer.Last_Sync_Request_Timestamp__c == null || primeDrtChipLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtChipLayer.Synced_with_Oracle_DB__c = False;
                primeDrtChipLayer.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                primeDrtChipLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            primeDrtChipLayerList.add(primeDrtChipLayer);  
               
        }
        try
        {
        update primeDrtChipLayerList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    if(firstElement.getSObjectType() == PRIME_DRT_Layer_Association__c.sObjectType)
    {
        objectName = 'PRIME DRT Layer Association';
        list<PRIME_DRT_Layer_Association__c> primeDrtLayerList = new list<PRIME_DRT_Layer_Association__c>();
        for(PRIME_DRT_Layer_Association__c primeDrtLayer : PRIME_DRT_Layer_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == primeDrtLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (primeDrtLayer.Last_Sync_Request_Timestamp__c == null || primeDrtLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtLayer.Synced_with_Oracle_DB__c = True;
                primeDrtLayer.Created_at_Oracle_DB__c = TRUE;
                primeDrtLayer.Error_Message_Oracle_DB__c = '';
                primeDrtLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == primeDrtLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
              (primeDrtLayer.Last_Sync_Request_Timestamp__c == null || primeDrtLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                primeDrtLayer.Synced_with_Oracle_DB__c = False;
                primeDrtLayer.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                primeDrtLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            primeDrtLayerList.add(primeDrtLayer);
                 
        }
        try
        {
        update primeDrtLayerList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    if(firstElement.getSObjectType() == DRT__c.sObjectType)
    {
        objectName = 'DRT';
        list<DRT__c> drtList = new list<DRT__c>();
        for(DRT__c drt : DRT_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            { //
            if(sfdcId == drt.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' && 
                (drt.Last_Sync_Req_Timestamp__c == null || drt.Last_Sync_Req_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp || sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp==null))
                {
                //
                drt.Synced_with_Oracle_DB__c = True;
                drt.Error_Message_Oracle_DB__c = '';
                drt.Last_Sync_Req_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                //
                }
             else if(sfdcId == drt.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
              (drt.Last_Sync_Req_Timestamp__c == null || drt.Last_Sync_Req_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                //
                drt.Synced_with_Oracle_DB__c = False;
                drt.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                drt.Last_Sync_Req_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId ).LastSyncTimestamp;
            }
             
            
            }
            drtList.add(drt);//  
        }
        try
        {
        //
        update drtList;
        //
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    if(firstElement.getSObjectType() == DRT_PTRF_Association__c.sObjectType)
    {
        objectName = 'DRT PTRF Association';
        list<DRT_PTRF_Association__c> drtPTRFList = new list<DRT_PTRF_Association__c>();
        for(DRT_PTRF_Association__c drtPTRF : DRT_PTRF_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == drtPTRF.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (drtPTRF.Last_Sync_Request_Timestamp__c == null || drtPTRF.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                drtPTRF.Synced_with_Oracle_DB__c = True;
                drtPTRF.Error_Message_Oracle_DB__c = ''; 
                drtPTRF.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
             else if(sfdcId == drtPTRF.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (drtPTRF.Last_Sync_Request_Timestamp__c == null || drtPTRF.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                drtPTRF.Synced_with_Oracle_DB__c = False;
                drtPTRF.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                drtPTRF.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            drtPTRFList.add(drtPTRF);
            //    
        }
        try
        {
        update drtPTRFList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    if(firstElement.getSObjectType() == Frame_DRT_Association__c.sObjectType)
    {
        objectName = 'Frame DRT Association';
        list<Frame_DRT_Association__c> frameDrtList = new list<Frame_DRT_Association__c>();
        for(Frame_DRT_Association__c frameDrt : Frame_DRT_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == frameDrt.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (frameDrt.Last_Sync_Request_Timestamp__c == null || frameDrt.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                frameDrt.Synced_with_Oracle_DB__c = True;
                frameDrt.Error_Message_Oracle_DB__c = '';
                frameDrt.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == frameDrt.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
              (frameDrt.Last_Sync_Request_Timestamp__c == null || frameDrt.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                frameDrt.Synced_with_Oracle_DB__c = False;
                frameDrt.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                frameDrt.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            frameDrtList.add(frameDrt);
                
        }
        try
        {
        update frameDrtList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
       if(firstElement.getSObjectType() == Fab_Distribution_Table__c.sObjectType)
    {
        objectName = 'Fab Distribution Table';
        list<Fab_Distribution_Table__c> fabDistList = new list<Fab_Distribution_Table__c>();
        for(Fab_Distribution_Table__c fabDist : Fab_Distribution_Table_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == fabDist.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (fabDist.Last_Sync_Request_Timestamp__c == null || fabDist.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                fabDist.Synced_with_Oracle_DB__c = True;
                fabDist.Error_Message_Oracle_DB__c = '';
                fabDist.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == fabDist.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (fabDist.Last_Sync_Request_Timestamp__c == null || fabDist.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                fabDist.Synced_with_Oracle_DB__c = False;
                fabDist.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                fabDist.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            fabDistList.add(fabDist);   
        }
        try
        {
        update fabDistList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    
    if(firstElement.getSObjectType() == Tapeout_Applications_MEBES_Jobview_Confi__c.sObjectType)
    {
        objectName = 'Tapeout Applications MEBES Jobview Confi';
        list<Tapeout_Applications_MEBES_Jobview_Confi__c> tapeoutList = new list<Tapeout_Applications_MEBES_Jobview_Confi__c>();
        for(Tapeout_Applications_MEBES_Jobview_Confi__c tapeout : Tapeout_Applications_MEBES_Jobview_Confi_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == tapeout.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (tapeout.Last_Sync_Request_Timestamp__c == null || tapeout.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                tapeout.Synced_with_Oracle_DB__c = True;
                tapeout.Error_Message_Oracle_DB__c = ''; 
                tapeout.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == tapeout.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (tapeout.Last_Sync_Request_Timestamp__c == null || tapeout.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                tapeout.Synced_with_Oracle_DB__c = False;
                tapeout.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                tapeout.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            tapeoutList.add(tapeout);
               
        }
        try
        {
        update tapeoutList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    
    if(firstElement.getSObjectType() == MST_Config__c.sObjectType)
    {
        objectName = 'MST Config';
        list<MST_Config__c> mstConfigList = new list<MST_Config__c>();
        for(MST_Config__c mstConfig : MST_Config_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == mstConfig.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
               (mstConfig.Last_Sync_Request_Timestamp__c == null || mstConfig.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                 {
                mstConfig.Synced_with_Oracle_DB__c = True;
                mstConfig.Error_Message_Oracle_DB__c = ''; 
                mstConfig.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == mstConfig.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (mstConfig.Last_Sync_Request_Timestamp__c == null || mstConfig.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mstConfig.Synced_with_Oracle_DB__c = False;
                mstConfig.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                mstConfig.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            mstConfigList.add(mstConfig);   
        }
        try
        {
        update mstConfigList;
        }
        catch(Exception e)
        {
         saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
         sendMail(e);
        }
    }

    if(firstElement.getSObjectType() == MST_Chip_Association__c.sObjectType)
    {
        objectName = 'MST Chip Association';
        list<MST_Chip_Association__c> mrsChipAssList = new list<MST_Chip_Association__c>();
        for(MST_Chip_Association__c mrsChipAss : MST_Chip_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == mrsChipAss.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                 (mrsChipAss.Last_Sync_Request_Timestamp__c == null || mrsChipAss.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsChipAss.Synced_with_Oracle_DB__c = True;
                mrsChipAss.Error_Message_Oracle_DB__c = '';
                mrsChipAss.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == mrsChipAss.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
              (mrsChipAss.Last_Sync_Request_Timestamp__c == null ||mrsChipAss.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsChipAss.Synced_with_Oracle_DB__c = False;
                mrsChipAss.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                mrsChipAss.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            mrsChipAssList.add(mrsChipAss);
            
        }
        try
        {
        update mrsChipAssList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }

    if(firstElement.getSObjectType() == MRS_Layer_Chip_Association__c.sObjectType)
    {
        objectName = 'MRS Layer Chip Association';
        list<MRS_Layer_Chip_Association__c> mrsLayerChipList = new list<MRS_Layer_Chip_Association__c>();
        for(MRS_Layer_Chip_Association__c mrsLayerChip : MRS_Layer_Chip_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == mrsLayerChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (mrsLayerChip.Last_Sync_Req_Timestamp__c == null || mrsLayerChip.Last_Sync_Req_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsLayerChip.Synced_with_Oracle_DB__c = True;
                mrsLayerChip.Created_at_Oracle_DB__c = True;
                mrsLayerChip.Error_Message_Oracle_DB__c = ''; 
                mrsLayerChip.Last_Sync_Req_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == mrsLayerChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (mrsLayerChip.Last_Sync_Req_Timestamp__c == null || mrsLayerChip.Last_Sync_Req_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsLayerChip.Synced_with_Oracle_DB__c = False;
                mrsLayerChip.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                mrsLayerChip.Last_Sync_Req_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            mrsLayerChipList.add(mrsLayerChip);   
        }
        try
        {
        update mrsLayerChipList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }


    if(firstElement.getSObjectType() == MRS_Layer_Association__c.sObjectType)
    {
        objectName = 'MRS Layer Association';
        list<MRS_Layer_Association__c> mrsLayerList = new list<MRS_Layer_Association__c>();
        for(MRS_Layer_Association__c mrsLayer : MRS_Layer_Association_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == mrsLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (mrsLayer.Last_Sync_Request_Timestamp__c == null || mrsLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsLayer.Synced_with_Oracle_DB__c = True;
                mrsLayer.Created_at_Oracle_DB__c = True;
                mrsLayer.Error_Message_Oracle_DB__c = ''; 
                 mrsLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
                }
            else if(sfdcId == mrsLayer.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (mrsLayer.Last_Sync_Request_Timestamp__c == null || mrsLayer.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsLayer.Synced_with_Oracle_DB__c = False;
                mrsLayer.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                 mrsLayer.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
           
            }
            mrsLayerList.add(mrsLayer);   
        }
        try
        {
        update mrsLayerList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }


    
    if(firstElement.getSObjectType() == Mask_Set_Title__c.sObjectType)
    {
        objectName = 'Mask Set Title';
        list<Mask_Set_Title__c> mst_List = new list<Mask_Set_Title__c>();
        for(Mask_Set_Title__c maskSetTitle : Mask_Set_Title_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
             
            if(sfdcId == maskSetTitle.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                 (maskSetTitle.Last_Sync_Request_Timestamp__c == null || maskSetTitle.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                
                maskSetTitle.Synced_with_Oracle_DB__c = True;
                maskSetTitle.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                maskSetTitle.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == maskSetTitle.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (maskSetTitle.Last_Sync_Request_Timestamp__c == null || maskSetTitle.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {    


                maskSetTitle.Synced_with_Oracle_DB__c = False;
                maskSetTitle.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                maskSetTitle.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            mst_List.add(maskSetTitle); 
        }
        try
        {
        update mst_List;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
    
    if(firstElement.getSObjectType() == MRS_Chip_Details__c.sObjectType)
    {
        objectName = 'MRS Chip Details';
        list<MRS_Chip_Details__c> mrsChipList = new list<MRS_Chip_Details__c>();
        for(MRS_Chip_Details__c mrsChip : MRS_Chip_Details_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == mrsChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                 (mrsChip.Last_Sync_Request_Timestamp__c == null || mrsChip.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                 {
                mrsChip.Synced_with_Oracle_DB__c = True;
                mrsChip.Created_at_Oracle_DB__c = True;
                mrsChip.Error_Message_Oracle_DB__c = '';
                mrsChip.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == mrsChip.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
               (mrsChip.Last_Sync_Request_Timestamp__c == null || mrsChip.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mrsChip.Synced_with_Oracle_DB__c = False;
                mrsChip.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                mrsChip.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            mrsChipList.add(mrsChip);  
        }
        try
        {
        update mrsChipList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }


    if(firstElement.getSObjectType() == MRS__c.sObjectType)
    {
        objectName = 'MRS';
        list<MRS__c> mstList = new list<MRS__c>();
        for(MRS__c mst : mrs_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            { //
            
            if(sfdcId == mst.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                (mst.Last_Sync_Request_Timestamp__c == null || mst.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mst.Synced_with_Oracle_DB__c = True;
                mst.Error_Message_Oracle_DB__c = '';
                mst.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == mst.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (mst.Last_Sync_Request_Timestamp__c  == null || mst.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                mst.Synced_with_Oracle_DB__c = False;
                mst.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage;
                mst.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
            }
            
            }
            mstList.add(mst);    
        }
        try
        {
        update mstList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
     if(firstElement.getSObjectType() == Notes__c.sObjectType)
    {
        objectName = 'Notes';
        list<Notes__c> noteList = new list<Notes__c>();
        for(Notes__c note: Notes_Query(sfdcIdResponseDataMap))
        {
            for(string sfdcId : sfdcIdResponseDataMap.keySet())
            {
            if(sfdcId == note.id && sfdcIdResponseDataMap.get(sfdcId).status == 'SUCCESS' &&
                 (note.Last_Sync_Request_Timestamp__c == null || note.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
                {
                note.Synced_with_Oracle_DB__c = True;
                note.Error_Message_Oracle_DB__c = '';
                note.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp; 
                }
            else if(sfdcId == note.id && sfdcIdResponseDataMap.get(sfdcId).status == 'ERROR' &&
                (note.Last_Sync_Request_Timestamp__c == null || note.Last_Sync_Request_Timestamp__c <= sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp))
            {
                note.Synced_with_Oracle_DB__c = False;
                note.Error_Message_Oracle_DB__c = sfdcIdResponseDataMap.get(sfdcId).errorMessage; 
                note.Last_Sync_Request_Timestamp__c = sfdcIdResponseDataMap.get(sfdcId).LastSyncTimestamp;
            }
            
            }
            noteList.add(note);     
        }
        try
        {
        update noteList;
        }
        catch(Exception e)
        {
        saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
        sendMail(e);
        }
    }
   }
    catch(Exception e)
    {
    saveErrorLog(e, objectName,inboundlstResponseOracleDB[0].SFDCID ,integrationPayload);
    DRTHandlerUtility.handleErrorOnSyncOracleResponse(e,string.valueOf(firstElement),'Exception on Oracle DB Sync Response');
    }
  
  }
    public static list<PRIME_DRT_Chip_Layer_Summary__c> PRIME_DRT_Chip_Layer_Summary_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM PRIME_DRT_Chip_Layer_Summary__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<PRIME_DRT_Layer_Association__c> PRIME_DRT_Layer_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM PRIME_DRT_Layer_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<DRT__c> DRT_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Req_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id,Old_Rev_DRT__c FROM DRT__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<DRT_PTRF_Association__c> DRT_PTRF_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM DRT_PTRF_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<PRIME_DRT_Chip_Association__c> PRIME_DRT_Chip_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM PRIME_DRT_Chip_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<Frame_DRT_Association__c> Frame_DRT_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM Frame_DRT_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MRS__c> mrs_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MRS__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MRS_Chip_Details__c> MRS_Chip_Details_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MRS_Chip_Details__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MRS_Layer_Association__c> MRS_Layer_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MRS_Layer_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MRS_Layer_Chip_Association__c> MRS_Layer_Chip_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Req_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MRS_Layer_Chip_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MST_Chip_Association__c> MST_Chip_Association_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MST_Chip_Association__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<MST_Config__c> MST_Config_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM MST_Config__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    
    public static list<Tapeout_Applications_MEBES_Jobview_Confi__c> Tapeout_Applications_MEBES_Jobview_Confi_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM Tapeout_Applications_MEBES_Jobview_Confi__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<Fab_Distribution_Table__c> Fab_Distribution_Table_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM Fab_Distribution_Table__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
     public static list<Mask_Set_Title__c> Mask_Set_Title_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM Mask_Set_Title__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    public static list<Notes__c> Notes_Query(map<Id,OracleDBResponseProxy> sfdcIdResponseDataMap)
    {
    return [SELECT Last_Sync_Request_Timestamp__c,Error_Message_Oracle_DB__c,Synced_with_Oracle_DB__c,Id FROM Notes__c WHERE ID IN : sfdcIdResponseDataMap.keySet()];
    }
    
    public static void sendMail(Exception e)
    {
         try{
         Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
         
         String[] toAddresses = new String[] {};
         if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
           toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); 
         }else{
             toAddresses.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); 
         }
         mail.setToAddresses(toAddresses);
         mail.setSenderDisplayName('SWIFT Apex error message');
         mail.setSubject('SWIFT Oracle DB Sync Error from Org : ' + UserInfo.getOrganizationName());
         mail.setPlainTextBody(e.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         }catch(exception exp){}
    }
    public static void saveErrorLog(Exception e, string objectName, string messageId, string integrationPayload){
    list<SWIFTcustomLogUtility.customLogClass> lstlog = new list<SWIFTcustomLogUtility.customLogClass>();
    SWIFTcustomLogUtility.customLogClass log = new SWIFTcustomLogUtility.customLogClass();
    log.debugLevel = 'ERROR';
    log.componentName = 'SWIFT_OracleDB_ResponseService';
    log.ComponentID = [select id from apexclass where name='SWIFT_OracleDB_ResponseService'].id;
    log.errorMessage = objectName + ':' + e.getmessage();
    log.stackTrace = e.getstacktracestring();
    log.messageID = messageId;
    log.method = 'syncOracleDBResponse';
    log.integrationPayload = integrationPayload;
    lstLog.add(log);
    SWIFTcustomLogUtility.saveCustomLog(lstLog);
    }
    
}