/*
Author:Mahendra Singh
Company: Cognizant
Description: Response service for SWIFT .NET Integration
History:
created date: 15/Apr/2014     
*/


global with sharing class MRS_dotNET_ResponseService {
global class LayerResponseProxy{
webservice string PTRFnumber;
webservice string LayerStatus;
webservice string MaskLayerName;
webservice string MaskRev;
webservice string ROMcode;
webservice datetime TransactionTimestamp;
webservice string action;
webservice string status;
webservice string errorMessage;
}

global class MRSPrimeFrameSendDataResponseProxy{
webservice string PTRFnumber;
webservice string sendPrimeData;
webservice string sendFrameData;
webservice string Action;
webservice string TransactionTimestamp;
webservice string status;
webservice string errorMessage;
}

global class MRSrevisedDRTresponseProxy{
webservice string DRTnumber;
webservice string Action;
webservice string TransactionTimestamp;
webservice string status;
webservice string errorMessage;
}

global class MRSDisapprovalFrameMockupresponseProxy{
webservice string PTRFnumber;
webservice string Action;
webservice string TransactionTimestamp;
webservice string status;
webservice string errorMessage;
}

webservice static void syncLayerResponse(list<LayerResponseProxy> inboundlstResponseLayer){
List<MRS_Layer_Chip_Association__c> lstLayerChip = new list<MRS_Layer_Chip_Association__c>();
List<MRS_Layer_Chip_Association__c> lstupdateLayerChip = new list<MRS_Layer_Chip_Association__c>();
set<string> setPTRFIds = new set<string>();
map<string,LayerResponseProxy> mapLayerChipres = new map<string,LayerResponseProxy>();
try{
for(LayerResponseProxy res :inboundlstResponseLayer){
    if(res.PTRFnumber!=null && res.PTRFnumber!=''){
        setPTRFIds.add(res.PTRFnumber);
        mapLayerChipres.put(res.PTRFnumber,res);
    }
}

  //lstLayerChip= [select id,PTRF_Number__c from MRS_Layer_Chip_Association__c where PTRF_Number__c in :setPTRFIds ];
  lstLayerChip= [select id,PTRF_Number__c from MRS_Layer_Chip_Association__c where PTRF__c in :setPTRFIds ];
   if(lstLayerChip!=null && lstLayerChip.size()>0){
       for(MRS_Layer_Chip_Association__c lc :lstLayerChip){
        if(mapLayerChipres!=null && mapLayerChipres.containskey(lc.PTRF_Number__c) && mapLayerChipres.get(lc.PTRF_Number__c).status=='SUCCESS'){
                lc.Sync_Layer_Status__c = TRUE;
                lc.Error_Message_Sync_Layer_Status__c = '';
                lstupdateLayerChip.add(lc);
        }
        else if (mapLayerChipres!=null && mapLayerChipres.containskey(lc.PTRF_Number__c) && mapLayerChipres.get(lc.PTRF_Number__c).status =='ERROR'){
            lc.Sync_Layer_Status__c = FALSE; 
            lc.Error_Message_Sync_Layer_Status__c = mapLayerChipres.get(lc.PTRF_Number__c).errorMessage;
            lstupdateLayerChip.add(lc);
        }       
    }
      
  }
  if(lstupdateLayerChip!=null && lstupdateLayerChip.size()>0){
      try{
          update lstupdateLayerChip;
      }catch(exception e){
          //
      }
  }
  }
  catch(Exception e)
  {
  DRTHandlerUtility.handleErrorOnMRSCADResponseService(e,setPTRFIds,'Exception on Sync Layer Response');
  }

}

webservice static void syncMRSPrimeFrameResponse(list<MRSPrimeFrameSendDataResponseProxy> inboundlstResponsePF){
List<MRS_Layer_Chip_Association__c> lstLayerChip = new list<MRS_Layer_Chip_Association__c>();
List<MRS_Layer_Chip_Association__c> lstupdateLayerChip = new list<MRS_Layer_Chip_Association__c>();
set<string> setPTRFIds = new set<string>();
map<string,MRSPrimeFrameSendDataResponseProxy> mapLayerChipres = new map<string,MRSPrimeFrameSendDataResponseProxy>();
try{
for(MRSPrimeFrameSendDataResponseProxy res :inboundlstResponsePF){
    if(res.PTRFnumber!=null && res.PTRFnumber!=''){
        setPTRFIds.add(res.PTRFnumber);
        mapLayerChipres.put(res.PTRFnumber,res);
    }
}

  //lstLayerChip= [select id,PTRF_Number__c from MRS_Layer_Chip_Association__c where PTRF_Number__c in :setPTRFIds ];
  lstLayerChip= [select id,PTRF_Number__c from MRS_Layer_Chip_Association__c where PTRF__c in :setPTRFIds ];
   if(lstLayerChip!=null && lstLayerChip.size()>0){
       for(MRS_Layer_Chip_Association__c lc :lstLayerChip){
        if(mapLayerChipres!=null && mapLayerChipres.containskey(lc.PTRF_Number__c) && mapLayerChipres.get(lc.PTRF_Number__c).status=='SUCCESS'){
                lc.Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = TRUE;
                lc.Error_Message_PTRF_Layer_SendPrimeFrame__c = '';
                lstupdateLayerChip.add(lc);
        }
        else if (mapLayerChipres!=null && mapLayerChipres.containskey(lc.PTRF_Number__c) && mapLayerChipres.get(lc.PTRF_Number__c).status =='ERROR'){
            lc.Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = FALSE; 
            lc.Error_Message_PTRF_Layer_SendPrimeFrame__c = inboundlstResponsePF[0].errorMessage;
            lstupdateLayerChip.add(lc);
        }       
    }
      
  }
  if(lstupdateLayerChip!=null && lstupdateLayerChip.size()>0){
      try{
          update lstupdateLayerChip;
      }catch(exception e){
          //
      }
  }
  }
  catch(Exception e)
  {
  DRTHandlerUtility.handleErrorOnMRSCADResponseService(e,setPTRFIds,'Exception on MRS PRIME FRAME Response');
  }
}

webservice static void syncMRSrevisedDRTResponse(list<MRSrevisedDRTresponseProxy> inboundlstResponseDRT){
list<DRT__c> lstDRT = new list<DRT__c>();
list<DRT__c> lstupdateDRT = new list<DRT__c>();
set<string> setDRT = new set<string>();
map<string,MRSrevisedDRTresponseProxy> mapDRTres = new map<string,MRSrevisedDRTresponseProxy>();
try
{
for(MRSrevisedDRTresponseProxy res :inboundlstResponseDRT){
    setDRT.add(res.DRTnumber);
    mapDRTres.put(res.DRTnumber,res);
}

if(setDRT!=null && !setDRT.isEmpty()){
    lstDRT = [select name from DRT__c where name in :setDRT];
}
if(lstDRT!=null && lstDRT.size()>0){
 for(DRT__c drt :lstDRT){
     if(mapDRTres!=null && mapDRTres.containskey(drt.Name) && mapDRTres.get(drt.Name).status=='SUCCESS'){
         drt.Sync_DRT_Rev_dot_NET__c = TRUE;
         drt.Error_Message_Sync_Rev_Update__c = '';
         lstupdateDRT.add(drt);
     }
     else if (mapDRTres!=null && mapDRTres.containskey(drt.Name) && mapDRTres.get(drt.Name).status =='ERROR'){
         drt.Sync_DRT_Rev_dot_NET__c = FALSE;
         drt.Error_Message_Sync_Rev_Update__c = inboundlstResponseDRT[0].errorMessage; 
         lstupdateDRT.add(drt);   
     }
     
 }
}

if(lstupdateDRT!=null && lstupdateDRT.size()>0){
    try{
        update lstupdateDRT;
    }catch(Exception e){
       //
   }
}
}
catch(Exception e)
{
DRTHandlerUtility.handleErrorOnMRSCADResponseServiceDRT(e,setDRT,'Exception on MRS Revised DRT Response');
}
}


webservice static void syncMRSdisapprovalFrameMosckupResponse(list<MRSDisapprovalFrameMockupresponseProxy> inboundlstResponseFrmaeMockup){
List<Notes__c> MRSnotes = new list<notes__c>();
set<string> setPTRFIds = new set<string>();
map<string,MRSDisapprovalFrameMockupresponseProxy> mapPTRFres = new map<string,MRSDisapprovalFrameMockupresponseProxy>();
try{
for(MRSDisapprovalFrameMockupresponseProxy res :inboundlstResponseFrmaeMockup){
    if(res.PTRFnumber!=null && res.PTRFnumber!=''){
        setPTRFIds.add(res.PTRFnumber);
        mapPTRFres.put(res.PTRFnumber,res);
    }
}

if(setPTRFIds!=null && !setPTRFIds.isEmpty()){
    MRSnotes = [select id,ParentId__r.PTRF_Number__c from Notes__c where ParentId__r.PTRF_Number__c in :setPTRFIds and (category__c ='Customer Frame Mockup Disapproval' or category__c ='Foundry Frame Mockup Disapproval') and (parentid__r.Customer_Frame_Mockup__c='Disapprove' or parentid__r.Foundry_Frame_Mockup__c='Disapprove')];
}
list<Notes__c> lstupdate= new list<notes__c>();
if(MRSnotes!=null && MRSnotes.size()>0){
    for(Notes__c iNotes :MRSnotes){
        if(mapPTRFres!=null && iNotes.ParentId__r!=null && mapPTRFres.containskey(iNotes.ParentId__r.PTRF_Number__c) && mapPTRFres.get(iNotes.ParentId__r.PTRF_Number__c).status=='SUCCESS'){
            iNotes.Frame_Disapproval_Sync_with_dotNET__c = TRUE;
            iNotes.Frame_Disaproval_Sync_Error_Message__c = '';
            lstupdate.add(iNotes);
        }
        else if(mapPTRFres!=null && iNotes.ParentId__r!=null && mapPTRFres.containskey(iNotes.ParentId__r.PTRF_Number__c) && mapPTRFres.get(iNotes.ParentId__r.PTRF_Number__c).status=='ERROR'){
            iNotes.Frame_Disapproval_Sync_with_dotNET__c = FALSE; 
            iNotes.Frame_Disaproval_Sync_Error_Message__c = inboundlstResponseFrmaeMockup[0].errorMessage;
            lstupdate.add(iNotes);
        }
    }
}

if(lstupdate!=null && lstupdate.size()>0)
    update lstUpdate;

}

catch(Exception e)
{
DRTHandlerUtility.handleErrorOnMRSCADResponseService(e,setPTRFIds,'Exception on MRS Disapproval Frame MockUp Response');
}
}
}