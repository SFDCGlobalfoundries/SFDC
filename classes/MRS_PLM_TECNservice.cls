/*
Author:Mahendra Singh
Company: Cognizant
Description: PLM TECN to MRS Integration Webservice
History:
created     03/Apr/2014     
*/


global with sharing class MRS_PLM_TECNservice {
global class TECNproxy{
webservice string messgaeID;
webservice string relatedTECNno;
webservice string TECNno;
webservice string docTypeECNInfo;
webservice string affectedDoc;
webservice string originator;
webservice string status;
webservice string maskSetTitle;
webservice string maskLayersNo;
webservice string primeDies;
webservice datetime updatetime;
}

webservice static void syncTECNWS(list<TECNproxy> inboundlstTECN){
list<TECN__c> lstinboundTECN = new list<TECN__c>();
map<string,set<string>> mapTECNdocInfo = new map<string,set<string>>();
list<string> techNoList = new List<string>();
list<string> relatedTechNoList = new List<string>();
try{
for(TECNproxy tp :inboundlstTECN){
    techNoList.add(tp.TECNno);
    relatedTechNoList.add(tp.relatedTECNno);
    if(inboundlstTECN!=null && inboundlstTECN.size()>0){
        if(tp.affectedDoc!=null){
            for(integer i=0; i<tp.affectedDoc.split(';').size(); i++){
                lstinboundTECN.add(new TECN__c(Name=tp.TECNno,Affected_Doc__c = tp.affectedDoc.split(';')[i], Doc_Type_ECN_Info__c = tp.docTypeECNInfo.split(';')[i], TECN_no__c = tp.TECNno, Related_TECN_no__c = tp.relatedTECNno, Originator__c = tp.originator,TECN_Mask_Layers_Number__c = tp.maskLayersNo, TECN_Mask_Set_Title__c = tp.maskSetTitle, TECN_Prime_Die_Name__c = tp.primeDies, TECN_Status__c = tp.status, Update_Time__c = tp.updatetime, TECN_Doc_Info__c = tp.TECNno+'|'+tp.affectedDoc.split(';')[i]));
                set<string> temp = new set<string>();
                if(!mapTECNdocInfo.keyset().isEmpty() && mapTECNdocInfo.containskey(tp.TECNno))
                    temp = mapTECNdocInfo.get(tp.TECNno);
                temp.add(tp.affectedDoc.split(';')[i]);
                mapTECNdocInfo.put(tp.TECNno,temp);
            }
        }
    }
    
}

list<TECN__c> lstTECNdel = new list<TECN__c>();
if(!mapTECNdocInfo.keyset().isEmpty()){
    for(TECN__c tecn :[select name,Affected_Doc__c from TECN__c where name in :mapTECNdocInfo.keyset()]){
        if(mapTECNdocInfo.containskey(tecn.Name) && !mapTECNdocInfo.get(tecn.Name).contains(tecn.Affected_Doc__c)){
            lstTECNdel.add(tecn);
        }
    }
    if(lstTECNdel.size()>0){
        delete lstTECNdel;
    }
}
    upsert lstinboundTECN TECN_Doc_Info__c;
}
catch(Exception e)
{
DRTHandlerUtility.handleErrorOnPLMTecnService(e,techNoList,relatedTechNoList,'EXCEPTION on PLM TECN Integration');
}
}
}