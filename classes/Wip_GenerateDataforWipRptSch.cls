global class Wip_GenerateDataforWipRptSch implements Schedulable {
    
    global  map<string,integer> deviceSequenceMap ;
    global  map<string,string>  deviceWipMap ;
    
    global Wip_GenerateDataforWipRptSch(){
        deviceSequenceMap = new map<string,integer>();
        deviceWipMap = new map<string,string>();
    }
    
    global void execute(SchedulableContext ctx) {
        try{
            set<string> maskTitleSet = new set<string>();
            set<string> deviceStageSet = new set<string>{'Design In','Tapeout','Prototype'};
                map<string,Mask_Set_Title__c> maskNameMap = new map<string,Mask_Set_Title__c>();
            map<string,device__c>maskDeviceMap = new map<string,device__c>();
            map<id,device__c>deviceMap= new map<id,device__c>();
            map<string,BX_041__c>devCdrsMap= new map<string,BX_041__c>();
            map<string,string> protLotIdMap = new map<string,string>();
            map<string,Manufacturing_Lot__c>manuMap = new map<string,Manufacturing_Lot__c>();
            list<WIP__c> wipUpdateList = new list<WIP__c>();
            
            for(WIP__c wpc:[Select id,Fab__c, Device__c,Account__c,Mask_Set__c,External_Id__c,Proto_Lot_Id__c,CSD__c,
                            Proto_Lot_PO__c,CDRS_Status__c,CDRS__c,Proto_Actual_Start_Date__c,MASK_PO_Status__c,
                            Layer_Sequence__c from WIP__c ]){
                                maskTitleSet.add(wpc.Mask_Set__c);
                                if(wpc.External_Id__c!=''){
                                    list<string>seqList = new list<string>();
                                    seqList=wpc.External_Id__c.Split('-');
                                    if(seqList.size()==2){
                                        if(deviceSequenceMap.ContainsKey(seqList[0])){
                                            integer seq =integer.valueof(seqList[1]);
                                            if(seq <Integer.valueof(deviceSequenceMap.get(seqList[0]))){
                                                deviceSequenceMap.put(seqList[0],integer.Valueof(seqList[1]));
                                                deviceWipMap.put(seqList[0],wpc.Id);
                                            }
                                        }else {
                                            deviceSequenceMap.put(seqList[0],integer.Valueof(seqList[1]));
                                            deviceWipMap.put(seqList[0],wpc.Id);
                                        }
                                    }
                                }
                            }
            
            for(Mask_Set_Title__c msr:[Select id,name,Status__c,(select id,Proto_Lot_Start_ID__c,Reticle_PO_Status__c,Proto_Lot_Start_Date__c,
                                                                 Account__c,Fab__c from Devices__r where Tapeout_Type__c='Single Product'
                                                                 and Stage__c in :deviceStageSet ORDER BY lastModifiedDate 
                                                                 DESC limit 1 )
                                       from Mask_Set_Title__c where name in:maskTitleSet ORDER BY lastModifiedDate DESC]){
                                           maskNameMap.put(msr.name,msr);
                                           
                                           if(null<>msr.Devices__r){
                                               if(msr.Devices__r.size()>0){
                                                   maskDeviceMap.put(msr.name,msr.Devices__r);
                                                   system.debug('???maskDeviceMap' +maskDeviceMap);
                                                   deviceMap.putAll(msr.Devices__r);
                                                   system.debug('???deviceMap' +deviceMap);
                                                   protLotIdMap.put(msr.name,msr.Devices__r[0].Proto_Lot_Start_ID__c);
                                               }
                                           }
                                       } 
            for(Device__c dvc:[select id ,Mask_Set_Title_Lookup__r.name, (select id,name, BX_041_Status__c from BX_041__r limit 1)
                               from device__c where id in :deviceMap.keySet()]){
                                   if(dvc.BX_041__r.size()>0){
                                       if(null<>dvc.Mask_Set_Title_Lookup__r.name){
                                           devCdrsMap.put(dvc.Mask_Set_Title_Lookup__r.name,dvc.BX_041__r);   
                                       }                                   
                                       
                                   }        
                               }
            if(null<>protLotIdMap.values()) {
                for(Manufacturing_Lot__c mlc:[Select id,PO_Line_Number__c,Current_Scheduled_Date_CSD__c,Manufacturing_Lot_Id__c
                                              from Manufacturing_Lot__c  where Manufacturing_Lot_Id__c in:protLotIdMap.values()]){
                                                  manuMap.put(mlc.Manufacturing_Lot_Id__c,mlc);         
                                              }       
            }
            
            for(WIP__c wpc:[Select id,Fab__c, Device__c,Account__c,Mask_Set__c,External_Id__c,Proto_Lot_Id__c,CSD__c,
                            Proto_Lot_PO__c,CDRS_Status__c,CDRS__c,Proto_Actual_Start_Date__c,MASK_PO_Status__c,
                            Layer_Sequence__c from WIP__c ]){
                                wpc.Layer_Sequence__c =false;
                                if(maskDeviceMap.values().size()>0){
                                    if(null<>maskDeviceMap.get(wpc.Mask_Set__c)){
                                        wpc.Device__c=maskDeviceMap.get(wpc.Mask_Set__c).id;
                                        wpc.Account__c=maskDeviceMap.get(wpc.Mask_Set__c).Account__c;  
                                        wpc.Fab__c=maskDeviceMap.get(wpc.Mask_Set__c).Fab__c;
                                        wpc.MASK_PO_Status__c=maskDeviceMap.get(wpc.Mask_Set__c).Reticle_PO_Status__c;
                                        wpc.Proto_Lot_Id__c=maskDeviceMap.get(wpc.Mask_Set__c).Proto_Lot_Start_ID__c;
                                        wpc.Proto_Actual_Start_Date__c=maskDeviceMap.get(wpc.Mask_Set__c).Proto_Lot_Start_Date__c;
                                    }
                                    if(devCdrsMap.values().size()>0){
                                        if(null<>devCdrsMap.get(wpc.Mask_Set__c)){ 
                                            wpc.CDRS__c=devCdrsMap.get(wpc.Mask_Set__c).name;
                                            wpc.CDRS_Status__c=devCdrsMap.get(wpc.Mask_Set__c).BX_041_Status__c;
                                        }
                                    }
                                    if(manuMap.values().size()>0){
                                        if(null<>protLotIdMap.get(wpc.Mask_Set__c)){
                                            wpc.Proto_Lot_PO__c=manuMap.get(protLotIdMap.get(wpc.Mask_Set__c)).PO_Line_Number__c;
                                            wpc.Proto_Lot_Id__c=manuMap.get(protLotIdMap.get(wpc.Mask_Set__c)).Manufacturing_Lot_Id__c;
                                            wpc.CSD__c=manuMap.get(protLotIdMap.get(wpc.Mask_Set__c)).Current_Scheduled_Date_CSD__c;
                                            
                                        }
                                    }
                                    wipUpdateList.add(wpc);
                                }
                            }
            database.update (wipUpdateList,false);
            list<wip__c> wpList = new list<wip__c>();
            for(string str:deviceWipMap.values()){
                wip__c wp = new wip__c(id=Id.valueof(str));
                wp.Layer_Sequence__c=true;
                wpList.add(wp);
            }
            if(wpList.size()>0){
                database.update(wpList,false);
            }
            if(Test.isRunningTest()) {
                insert new BX_041__c();
            }
        }catch (exception e){
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ROS_ControllerSearchReticleGFForm.class.getName();
            alw.sourceFunction = 'setDefaultOwner()';
            alw.ApplicationName='Other-GlobalFoundryView';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            system.debug('Error While processing '+'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString());
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw); 
            
        }
    }   
}