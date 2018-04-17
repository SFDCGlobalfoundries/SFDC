/*****************************************************************************
Class Name: IPE_PT_SelectionController
CaseNumber: Case#00071844
Author: Ravi Teja.B    
Description: IP Element Mapping with PT inline VF Page(IPE_PT_Selection) 
Controller.
Created Date:16-11-2017 {DD-MM-YYYY}
******************************************************************************/
public class IPE_PT_SelectionController {
    
    public List<IPE_Wrapper> PTWrapperList {get;set;}
    public List<Process_Technology__c> PTList {get; set;}
    IP_Element__c stdRec;
    List<Base_IP__c> ipRec;
    Map<String,IP_PT_Map__c> existedPts;
    
    public IPE_PT_SelectionController(ApexPages.StandardController std){
        PTWrapperList = new List<IPE_Wrapper>();
        stdRec = [Select Id, Name,Process_Technology__c from IP_Element__c where id=: std.getRecord().Id];
        ipRec = [Select Id, Name from Base_Ip__c where Name =: stdRec.Name.remove('-')];
        existedPts = new Map<String,IP_PT_Map__c>();
        system.debug('ipRec==>'+ipRec);
        if(ipRec.size() == 1){
            for(IP_PT_Map__c pt: [Select Id, Name, IPNumber__c,PT_Number__r.Name from IP_PT_Map__c where IPNumber__c =: ipRec[0].id]){
                existedPts.put(pt.PT_Number__r.Name,pt);
                system.debug('pt.Name==>'+pt.PT_Number__r.Name);
            }
            if(stdRec.Process_Technology__c != null)
                constructWrapper();
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please select Process Technology'));
            }
        }
    }
    public List<IPE_Wrapper> constructWrapper(){
        for(Process_Technology__c PT : [Select Id, Name,Tech_Geometry__c,Process_Family__c,Description__c, Title__c,PT_Number__c,
                                        Lifecycle__c, IP_Geometry_Technology__c,IP_Technology_Name__c,Tech_Type__c,Category__c,Customer_Release__c  from Process_Technology__c
                                        where IP_Technology_Name__c =: stdRec.Process_Technology__c]){
                                            
                                            IPE_Wrapper wrap = new IPE_Wrapper();
                                            if(existedPts.containsKey(PT.PT_Number__c)){
                                                wrap.isSelected = True;
                                                wrap.ipPt = existedPts.get(PT.PT_Number__c);
                                            }
                                            else{
                                                wrap.isSelected = False;
                                                wrap.ipPt = new IP_PT_Map__c();
                                            }
                                            wrap.pt = PT;
                                            PTWrapperList.add(wrap);
                                        }
        return PTWrapperList;
    }
    public PageReference add_IP_PTMap(){
        List<IP_PT_Map__c> ipPtList = new List<IP_PT_Map__c>();
        List<IP_PT_Map__c> ipPtDeleteList = new List<IP_PT_Map__c>();
        for(IPE_Wrapper ipw: PTWrapperList){
            system.debug('ipw.isSelected==>'+ipw.isSelected);
            if(ipw.isSelected && ipw.ipPt.Id == null){
                IP_PT_Map__c ippt = new IP_PT_Map__c();
                ippt.IPNumber__c = ipRec[0].Id;
                ippt.PT_Number__c = ipw.pt.id;
                
                ipPtList.add(ippt);
                ipw.ipPt = ippt;
            }
            else if(!ipw.isSelected && ipw.ipPt.Id != null){
                
                ipPtDeleteList.add(ipw.ipPt);
                ipw.ipPt = new IP_PT_Map__c();
            }
        }
        if(ipPtList.size() > 0)
            insert ipPtList;
        if(ipPtDeleteList.size() > 0)
            delete ipPtDeleteList;
        return null;
    }
    public class IPE_Wrapper{
        public boolean isSelected {get;set;}
        public Process_Technology__c pt {get;set;}
        public IP_PT_Map__c ipPt {get;set;}
        
        public IPE_Wrapper(){
            
        }
    }
}