/*
Name: BatchScheduleSetLayerChipStatus
Author: SWIFT Team
Created Date: 23-May-2015
Description: check layer chip status, retrigger calculation when incorrect found
*/
global class BatchScheduleSetLayerChipStatus implements Database.Batchable < sObject > { 
        
    global Set<Id> mrsId; // store list mrs under mst when manual retrigger
    global boolean byPassTimeFrame; // if manual retrigger -> by pass time frame filter, else: not
    
    global BatchScheduleSetLayerChipStatus( Set<Id> mrsId ) {
        this.byPassTimeFrame = true;
        this.mrsId = mrsId;
    }
    
    global BatchScheduleSetLayerChipStatus() { 
        this.byPassTimeFrame = false;
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id,Layer_Chip_Status__c,Customer_GDSOUT_Review__c,' 
            + 'Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,' 
            + 'Send_Prime_Data__c,Send_Frame_Data__c,DRW__c,ORC__c,Prime_MEBES_Received__c,' 
            + 'Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,' 
            + 'GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,' 
            + 'Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,PTRF__r.Tech_Geo_Value__c ' 
            + 'FROM MRS_Layer_Chip_Association__c WHERE Layer_Chip_Status__c IN (\'Not Ready\',\'In Progress\') ';
        // time frame store in environment variable, set to 0 or greater mean by pass filter
        Integer timeframe = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_LAYERCHIP_TIME_FRAME').Value__c );   
        if( timeframe < 0 && !byPassTimeFrame ) {
            DateTime lastHours = DateTime.now().addHours(timeframe); // filter to include only last timeframe hours modified records
            query += ' AND SystemModStamp >= :lastHours';
        }
        if(null != mrsId) {
            query += ' AND layer__r.mrs__c IN :mrsId';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List < MRS_Layer_Chip_Association__c > scope) {
        reTriggerLayerChip( scope );
    }
    
    global void finish(Database.BatchableContext BC) {
        // mrsId != null mean this run is manually trigger -> no more job or email send out
        if(null == mrsId) {     
            // invoke retrigger layer batch
            Datetime sysTime = System.now().addMinutes( 5 );
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            BatchScheduleSetLayerStatusSchedulable scheduledBatch = new BatchScheduleSetLayerStatusSchedulable();
            System.schedule( 'ReTriggerMRSLayer-UpdateMismatchesLayer ' + sysTime, chronExpression, scheduledBatch );
        }
    }

    public static void reTriggerLayerChip( List < MRS_Layer_Chip_Association__c > scope ) {
        
        Map<Id, String> oldMapLayerChipStatus = new Map<Id, String>(); // store old layer chip status       
        for(MRS_Layer_Chip_Association__c thisRecord: scope) {
            oldMapLayerChipStatus.put(thisRecord.id, thisRecord.Layer_Chip_Status__c);
        }
        List<MRS_Layer_Chip_Association__c> newListLayerChip = MRSHandlerUtility.setLayerChipStatus(scope); // execute calculate -> return new calculated list with correct status if have
        List<MRS_Layer_Chip_Association__c> incorrectList = new List<MRS_Layer_Chip_Association__c>(); // store incorrect record after comparing with old list value
        // look through calculated list > compare with old list > get incorrect status
        Double SETTING_TECH_GEO = Double.valueOf ( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_TECH_GEO').Value__c ); // tech geo cut off value
        Double layerChipTechGeo = 0.00;
        for(MRS_Layer_Chip_Association__c newRecord: newListLayerChip) {
            try {
                layerChipTechGeo = Double.valueOf( newRecord.PTRF__r.Tech_Geo_Value__c ); // tech geo of layer chip
                if( layerChipTechGeo > SETTING_TECH_GEO ) { // retrigger only tech geo > 22nm (as set in environment variable)
                    boolean isIncorrect = newRecord.Layer_Chip_Status__c != oldMapLayerChipStatus.get(newRecord.Id) ? true : false;
                    if( isIncorrect ) {
                        incorrectList.add( newRecord ); // retrigger only incorrect layer chips
                    }
                }
            } catch(System.NullPointerException ex) {
                // Tech_Geo_Value__c of PTRF could be null <- data issue
                // may need to add an application log in case tech geo null <-- need or not?
            } catch(System.TypeException ex) {
                // Tech_Geo_Value__c of PTRF__c could be in invalid format which is data issue <- as checked on PROD, this case does not exist, however, SIT does.
                // correct format: '0.022'
                // incorrect format: '0.022UM' or '.022' or '.022UM'
                // may need to add an application log in case tech geo null <-- need or not?
            } catch(Exception ex) {
                // to-do
            }
        }
        // update incorrect status list only, and date time stapm
        update incorrectList;
    }
}