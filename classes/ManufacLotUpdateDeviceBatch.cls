/*
    Author: Thomas Lai
    Description: Batch class to extract Manufacturing lot records and update related Device records. 
    History: 
        TLai        17022014    - code creation.
        TLai        26032014    - Excluded GlobalShuttle MPW devcie
        TLai        27032014    - Added new fields of device
        Tlai    27052014  - Added logic to filter out device without PLM Device id
        Sunil   12082014  - Added filter to run batch again if Lot start date was not populated earlier
        Pradosh 17062016  - Added filter to device for Customer MPW tapeout type
*/
global class ManufacLotUpdateDeviceBatch implements Database.Batchable<sObject>{
    
    
    global datetime startTime = DateTime.now().addHours(Integer.valueOf(Environment_Variable__c.getInstance('MANUFACTURE_LOT_BATCH_INTERVAL').value__c));
    global datetime endTime = DateTime.now();
    global final String query = 'Select id, lot_type__c,Device_ID_R12__c,Device_ID_MES__c,Manufacturing_Lot_Id__c,Lot_Start_Date__c from Manufacturing_Lot__c where'+
                                        +' Device_ID_R12__c != null and '
                                        + 'Active_Flag__c = true and '
                                        +' lot_type__c in (\'QD\',\'QE\',\'QF\',\'QM\',\'QV\',\'QX\') and '
                                        +' LastModifiedDate >= ' +startTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'.000Z\'','GMT')+ ' and LastModifiedDate <= '+ endTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'.000Z\'','GMT') +
                                        +' Order by Device_ID_R12__c, createddate';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug(query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject>
                        scope){
        List<Manufacturing_Lot__c> mlList = (List<Manufacturing_Lot__c>)scope;
        boolean isError = false;
        Set<String> spDeviceSet = new Set<String>(); //Single Product and Customer MPW Device <-- QD Lot
        map<String,Manufacturing_Lot__c> spDevice2MlMap = new map<String,Manufacturing_Lot__c>();
        Set<String> nonSpDeviceSet = new Set<String>();// Non Single Product Device <-- QE,QF,QM,QV,QX Lots
        map<String,Manufacturing_Lot__c> nonSpDevice2MlMap = new map<String,Manufacturing_Lot__c>();
        
        Set<String> lotTypeSet = new Set<String>();
        if(Label.Lot_Type != null && Label.Lot_Type.split(',').size() > 0){
            for(String type : Label.Lot_Type.split(',')){
                lotTypeSet.add(type.trim());
            }
        }
        
        for(Integer i = 0; i < mlList.size(); i++){
            Manufacturing_Lot__c ml = mlList[i];
            if(ml.lot_type__c != null && lotTypeSet.contains(ml.lot_type__c)){ // lot_type__c QD stored in Custom label
                if(!spDeviceSet.contains(ml.Device_ID_R12__c)){//first created ML will apply to Device
                    spDeviceSet.add(ml.Device_ID_R12__c);
                    spDevice2MlMap.put(ml.Device_ID_R12__c, ml);
                }
            }else{
                if(!nonSpDeviceSet.contains(ml.Device_ID_R12__c)){
                    nonSpDeviceSet.add(ml.Device_ID_R12__c);
                    nonSpDevice2MlMap.put(ml.Device_ID_R12__c, ml);
                }
            }
        }
        system.debug('SP Device size: '+ spDeviceSet + ', Not SP Device size: ' + nonSpDeviceSet);
        
        //Tapeout Types are sstored in Custom label
        Set<String> tapeOutTypeSet = new Set<String>();
        if(Label.Tapeout_Type != null && Label.Tapeout_Type.split(',').size() > 0){
            for(String type : Label.Tapeout_Type.split(',')){
                tapeOutTypeSet.add(type.trim());
            }
        }
        list<Device__c> devList = new list<Device__c>();
        if(spDeviceSet.size() > 0 || nonSpDeviceSet.size() > 0){
            for(Device__c dev :[Select id,Tapeout_Type__c,ML_Sync_Id__c,Proto_Lot_ID_Lot_Type__c,Updated_By_ML_Logic__c, ML_Updated_By__c, PLM_Device_ID__c,MES_Device_Id__c,Proto_Lot_Start_ID__c,Proto_Lot_Start_Date__c, Stage__c 
                                from Device__c
                                where  ((Tapeout_Type__c IN : tapeOutTypeSet and PLM_Device_ID__c in : spDeviceSet)
                                   or (Tapeout_Type__c != 'Single Product' and Tapeout_Type__c != 'GlobalShuttle MPW' and PLM_Device_ID__c in : nonSpDeviceSet))
                                   and ((PLM_Device_ID__c != null and Proto_Lot_Start_ID__c = null and Proto_Lot_Start_Date__c = null) or (PLM_Device_ID__c != null and Proto_Lot_Start_Date__c = null)) //27052014 Tlai added condition -> PLM_Device_ID__c != null//18072014 codition added by Sunil for case # 27646 to run the batch again if lot start date is null
                                   
                            ]){
                if(dev.Tapeout_Type__c != null && tapeOutTypeSet.contains(dev.Tapeout_Type__c)){
                    if(spDevice2MlMap.containsKey(dev.PLM_Device_ID__c)){
                        Manufacturing_Lot__c ml = spDevice2MlMap.get(dev.PLM_Device_ID__c);
                        dev.MES_Device_Id__c = ml.Device_ID_MES__c;
                        dev.Proto_Lot_Start_ID__c = ml.Manufacturing_Lot_Id__c;
                        if(dev.Stage__c == 'Design In'){
                            dev.Stage__c ='Prototype';
                        } 
                        if( ml.Lot_Start_Date__c != null){
                            DateTime lotStart = ml.Lot_Start_Date__c;
                            dev.Proto_Lot_Start_Date__c = date.newInstance(lotStart.year(),lotStart.month(),lotStart.day());
                        }
                        
                        dev.Proto_Lot_ID_Lot_Type__c = ml.lot_type__c;//Added by TLai 27032014
                        dev.ML_Sync_Id__c  = endTime.format('yyyy-MM-dd');//Added by TLai 27032014
                        dev.ML_Updated_By__c = UserInfo.getName();//Added by TLai 27032014
                        dev.Updated_By_ML_Logic__c = true;
                         
                        devList.add(dev);
                    }
                }else{
                    if(nonSpDevice2MlMap.containsKey(dev.PLM_Device_ID__c)){
                        Manufacturing_Lot__c ml = nonSpDevice2MlMap.get(dev.PLM_Device_ID__c);
                        dev.MES_Device_Id__c = ml.Device_ID_MES__c;
                        dev.Proto_Lot_Start_ID__c = ml.Manufacturing_Lot_Id__c;
                        if(dev.Stage__c == 'Design In'){
                            dev.Stage__c ='Prototype';
                        }
                        if( ml.Lot_Start_Date__c != null){
                            DateTime lotStart = ml.Lot_Start_Date__c;
                            dev.Proto_Lot_Start_Date__c = date.newInstance(lotStart.year(),lotStart.month(),lotStart.day());
                        }
                        //dev.ML_Sync_Id__c = endTime.format('yyyy-MM-dd\'T\'HH:mm:ss.szzz','GMT');
                        dev.Proto_Lot_ID_Lot_Type__c = ml.lot_type__c;//Added by TLai 27032014
                        dev.ML_Sync_Id__c  = endTime.format('yyyy-MM-dd');//Added by TLai 27032014
                        dev.ML_Updated_By__c = UserInfo.getName();//Added by TLai 27032014
                        dev.Updated_By_ML_Logic__c = true;
                        devList.add(dev);
                    }
                }
                                  
            }
        }
        system.debug('DevList size: '+ devList);
        if(devList.size() > 0){
             List<Database.SaveResult> devUpd = Database.update(devList, false);
             for(Database.SaveResult sr : devUpd){
                if(!sr.isSuccess()){
                    system.debug('Device('+ sr.getId()+ ') updates failed caused by '+ sr.getErrors()[0].getMessage());
                }
            }           
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }
}