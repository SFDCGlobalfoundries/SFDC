/*
Type Name: BatchScheduleSetLayerStatus  
Author: Cognizant
Created Date: 03-Feb-2015
Reason: Batch class for recalculating MRS Layer statuses
Change History:
Author:
Modified Date:
Reason:
Author: Cognizant Technology Solutions
Modified Date:
??..
??..
*/
global class BatchScheduleSetLayerStatus implements Database.Batchable < sObject > , Database.Stateful {
        
    global String bodyLayerNames;
    global boolean isFirstRun;
    global Set<Id> mrsId;
    global boolean byPassTimeFrame;
    
    /**
    * Initial for retrigger/email notifying
    */
    global BatchScheduleSetLayerStatus(boolean isFirstRun) {
        this.isFirstRun = isFirstRun;
        this.byPassTimeFrame = false;
    }
    
    global BatchScheduleSetLayerStatus(Set<Id> mrsId ) {
        this.mrsId = mrsId;
        this.isFirstRun = true;
        this.byPassTimeFrame = true;
    }
    
    /**
    * Initial for old job
    * Need to refactor other referenced
    */
    global BatchScheduleSetLayerStatus() {
        this.isFirstRun = false;
        this.byPassTimeFrame = false;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        bodyLayerNames = '';
        String query = 'SELECT ID,name FROM mrs_layer_association__c WHERE Layer_Status__c IN (\'In Progress\',\'Not Ready\')';
        if(null != mrsId) {
            query += ' AND MRS__c IN :mrsId'; 
        }
        Integer timeframe = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_LAYERCHIP_TIME_FRAME').Value__c );
        if( timeframe < 0 && !byPassTimeFrame ) {
            DateTime lastHours = DateTime.now().addHours(timeframe); // filter to include only last timeframe hours modified records
            query += ' AND SystemModStamp >= :lastHours';
        }
        return Database.getQueryLocator(query); 
    }


    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        
        set < string > setLayerIds = new set < string > ();

        for (sobject idLayer: scope) {
            setLayerIds.add(String.valueof(idLayer.id));
        }

        List < MRS_Layer_Association__c > lstMRSLayers = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > lstMRSLayersOld = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();
        // key: layer id, value: layer chip record
        Map < ID, MRS_Layer_Association__c > mapCalculatedLayer = new Map < ID, MRS_Layer_Association__c > ();
        Map < string, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips = new Map < string, List < MRS_Layer_Chip_Association__c >> ();
        lstMRSLayers.addAll(retrieveLayerDetails(setLayerIds));
        lstMRSLayersOld = lstMRSLayers.deepclone(true, false, false);
        
        mapLayerIdToLayerChips.putAll(MRSHandlerutility.retrieveLayerChipDetails(setLayerIds));
        if (lstMRSLayers != null && lstMRSLayers.size() > 0) {
            lstMRSLayersUpdated.addAll(MRSHandlerutility.calculateLayerStatus(lstMRSLayers, mapLayerIdToLayerChips));
        }

        // TASK-2481
        Set < Id > layerIdSet = new Set < Id > ();
        // stored layer which is to be triggered/updated
        Map < String, MRS_Layer_Chip_Association__c > reTriggerMap = new Map < String, MRS_Layer_Chip_Association__c > ();
        // TASK-2481 END
        if (lstMRSLayersUpdated.size() > 0) {
            for (MRS_Layer_Association__c objLayer: lstMRSLayersUpdated) {
                // TASK-2481
                layerIdSet.add(objLayer.Id);
                // TASK-2481 END
                mapCalculatedLayer.put(objLayer.id,objLayer);
            }
        }

        List < String > listFieldNames;
        listFieldNames = fetchFieldNames();
        string strFieldName = '';
        string strFieldDesc = '';
        string strOldStatus = '';
        string strNewStatus = '';
        string strLayerName = '';

        integer count = 0;
        MRS_Layer_Association__c newRecord = new MRS_Layer_Association__c();

        if (lstMRSLayersOld != null && mapCalculatedLayer != null) {
            for (MRS_Layer_Association__c currentObj: lstMRSLayersOld) {

                strLayerName = '';
                newRecord = mapCalculatedLayer.get(currentObj.id);

                if (newRecord != null) {
                    for (String objMergedFieldName: listFieldNames) {

                        strFieldName = objMergedFieldName.split(':')[0];
                        strFieldDesc = objMergedFieldName.split(':')[1];

                        strOldStatus = String.valueof(currentObj.get(strFieldName));
                        strNewStatus = String.valueof(newRecord.get(strFieldName));

                        if (currentObj != null && strOldStatus != strNewStatus) {
                            if (currentObj.ROM_Code__c != null && currentObj.ROM_Code__c != '' && currentObj.ROM_Code__c != '####') {
                                strLayerName = currentObj.name + currentObj.Mask_Layer_Rev__c + '(' + currentObj.ROM_Code__c + ')';
                            } else {
                                strLayerName = currentObj.name + currentObj.Mask_Layer_Rev__c;
                            }
                            bodyLayerNames += '<br /> Mask Set Title : ' + currentObj.Mask_Set_Title_Name__c + ' , Mask Layer : ' + strLayerName + ' =>  ' + strFieldDesc + ' from ' + strOldStatus + ' to ' + strNewStatus;
                            // TASK-2481
                            layerIdSet.add(currentObj.Id);
                            // TASK-2481 END
                        }
                    }
                }
                count = count + 1;
            }
            
            // TASK-2481
            if( isFirstRun ) {
                reTriggerCalculate(layerIdSet); // retrigger the roll-up calculation
            }
            // TASK-2481 END
        }
    }

    public List < String > fetchFieldNames() {
        
        List < String > listFieldNames;
        listFieldNames = new List < String > ();
        listFieldNames.add('Customer_GDSOUT_Review__c:Customer GDSOUT Review');
        listFieldNames.add('Foundry_GDSOUT_Review__c:Foundry GDSOUT Review');
        listFieldNames.add('Customer_Frame_Mockup__c:Customer Frame Mockup');
        listFieldNames.add('Foundry_Frame_Mockup__c:Foundry Frame Mockup');
        listFieldNames.add('Send_Prime_Data__c:Send Prime Data');
        listFieldNames.add('Send_Frame_Data__c:Send Frame Data');
        listFieldNames.add('Customer_Prime_Remote_Jobview_Setup__c:Customer Prime Remote Jobview');
        listFieldNames.add('Customer_Frame_Remote_Jobview_Setup__c:Customer Frame Remote Jobview');
        listFieldNames.add('Foundry_Prime_Remote_Jobview_Setup__c:Foundry Prime Remote Jobview');
        listFieldNames.add('Foundry_Frame_Remote_Jobview_Setup__c:Foundry Frame Remote Jobview');
        listFieldNames.add('ORC__c:ORC');
        listFieldNames.add('DRW__c:DRW');
        listFieldNames.add('Prime_MEBES_Received__c:Prime MEBES Received');
        listFieldNames.add('Frame_MEBES_Received__c:Frame MEBES Received');
        listFieldNames.add('Customer_MEBES_Jobview__c:Customer MEBES Jobview');
        listFieldNames.add('Foundry_MEBES_Jobview__c:Foundry MEBES Jobview');
        listFieldNames.add('Tapeout_Centre_MEBES_Jobview__c:Tapeout Centre MEBES Jobview');
        listFieldNames.add('Tapeout_Applications_MEBES_Jobview__c:Tapeout Applications MEBES Jobview');
        listFieldNames.add('GlobalShuttle_MEBES_Jobview__c:GlobalShuttle MEBES Jobview');
        listFieldNames.add('MDP_MEBES_Jobview__c:MDP MEBES Jobview');
        listFieldNames.add('TDTI_MPW_MEBES_Jobview__c:TDTI MPW MEBES Jobview');
        return listFieldNames;
    }


    global void finish(Database.BatchableContext BC) {
        // mrsId != null mean this run is manually trigger -> no more job or email send out
        if(null == mrsId) {
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] swiftAdmn;
            swiftAdmn = new String[] {};
            
            boolean isMismatchFound = true;
            if(bodyLayerNames == '') {
                isMismatchFound = false; // NO MISMATCH LAYER FOUND
                bodyLayerNames = 'No mismatches found.';
            }
            
            if ( isFirstRun ) {
                if (Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_EMAIL').Value__c == 'ON') {
                    // in next 30 minutes, run again just to check whether any layer still mismatch and send out an email
                    Datetime sysTime = System.now().addMinutes( 1 );
                    String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                    BatchScheduleSetLayerStatusSchedulable2 scheduledBatch = new BatchScheduleSetLayerStatusSchedulable2();
                    System.schedule( 'ReTriggerMRSLayer-NotifyMismatcheLayers ' + sysTime, chronExpression, scheduledBatch );   
                } else {
                    // schedule next job run over again by interval
                    Integer interval = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_INTERVAL').Value__c );
                    if(interval > 0) {
                        // run over again in next interval
                        Datetime sysTime = System.now().addMinutes( interval );
                        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                        BatchScheduleSetLayerChipSchedulable scheduledBatch = new BatchScheduleSetLayerChipSchedulable();
                        System.schedule( 'ReTriggerMRSLayerChip ' + sysTime, chronExpression, scheduledBatch );
                    }
                }
            } else {
                OrgWideEmailAddress orgWideAddr = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = 'GLOBALFOUNDRIES' LIMIT 1];
                if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
                    swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
                } else {
                    swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
                }
                mail.setToAddresses(swiftAdmn);
                String notifyStr = 'The following mismatches are found during computation of Layer Statuses and should be changed as follows: ';
                if(isMismatchFound) {
                    mail.setSubject('Layer Status Computed by Batch Process : Mismatches Found ');
                } else {
                    mail.setSubject('Layer Status Computed by Batch Process : No Mismatches Found ');
                }
                String body = '<br /><br />Dear Sir/Madam,  ';
                body += '<br /><br /> ' + notifyStr;
                body += '<br /><br /> ' + bodyLayerNames;
                body += '<br /><br />This is a system generated message, please do not reply. ';
                body += '<br />Best Regards. <br /><br /><br />';
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(orgWideAddr.Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                // schedule next job run over again by interval > change to trigger batch layer chip
                Integer interval = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_INTERVAL').Value__c );
                if(interval > 0) {
                    // run over again in next interval
                    Datetime sysTime = System.now().addMinutes( interval );
                    String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                    BatchScheduleSetLayerChipSchedulable scheduledBatch = new BatchScheduleSetLayerChipSchedulable();
                    System.schedule( 'ReTriggerMRSLayerChip ' + sysTime, chronExpression, scheduledBatch );
                }
            }
            
            // delete old jobs
            for(crontrigger ct :[ SELECT id,state FROM crontrigger WHERE CronJobDetailId in (SELECT id FROM cronjobdetail WHERE name like 'ReTriggerMRSLayer%') ]) {
                if(ct.state=='DELETED'){
                    system.abortjob(ct.id);
                }
            }
        }
    }


    public static List < MRS_Layer_Association__c > retrieveLayerDetails(set < String > setLayerIds) {
        
        List < MRS_Layer_Association__c > lstLayerDetails = new List < MRS_Layer_Association__c > ();
        for (MRS_Layer_Association__c obj: [
            SELECT Id, Layer_Status__c, layer_name__c, name, ROM_Code__c, Mask_Layer_Rev__c, Mask_Set_Title_Name__c, Customer_GDSOUT_Review__c, 
                Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c,
                Send_Prime_Data__c, Send_Frame_Data__c, DRW__c, ORC__c, Customer_Prime_Remote_Jobview_Setup__c, Hold_Layer_By_User__c,
                Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,
                Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c,
                MDP_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c
            FROM MRS_Layer_Association__c
            WHERE Id IN: setLayerIds]) 
        {
            lstLayerDetails.add(obj);

        }
        return lstLayerDetails;
    }

    /**
     * TASK-2481
     * When roll up calculation mismatch found
     * auto retrigger the calculation
     */
    public static Map < String, MRS_Layer_Chip_Association__c > reTriggerCalculate(Set < Id > layerIdSet) {
        
        Map < String, MRS_Layer_Chip_Association__c > reTriggerMap = new Map < String, MRS_Layer_Chip_Association__c > ();
        if ( null != layerIdSet && layerIdSet.size() > 0) {
            // select all mrs layer chip association related to layerIdSet(of MRS_Layer_Association__c)
            List < MRS_Layer_Chip_Association__c > reTriggerList = new List < MRS_Layer_Chip_Association__c > ();
            reTriggerList = [
                SELECT Id, Mask_Set_Title_Name__c, Layer__c, Rev__c,PTRF__r.Tech_Geo_Value__c
                FROM MRS_Layer_Chip_Association__c
                WHERE Layer__c IN: layerIdSet
            ];
            // build a map<String, MRS_Layer_Chip_Association__c> which key = mst + name + mask layer rev
            Double SETTING_TECH_GEO = Double.valueOf ( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_TECH_GEO').Value__c ); // tech geo cut off value
            Double layerChipTechGeo = 0.0;
            for (MRS_Layer_Chip_Association__c m: reTriggerList) {
                // if tech geo <= 22nm (0.022um) => do not re-trigger
                // due to workaround for maskshop email 
                // maskshop will manual send out release email if see roll-up not calculate correctly
                try {
                    layerChipTechGeo = Double.valueOf( m.PTRF__r.Tech_Geo_Value__c ); // tech geo of layer chip
                    if( layerChipTechGeo > SETTING_TECH_GEO ) {
                        reTriggerMap.put(m.Mask_Set_Title_Name__c + '-' + m.Layer__c + '-' + m.Rev__c, m); // unique key, only 1 layer chip under layer will be trigger
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
            // loop through that map, set cad_update to true -> save
            reTriggerList = new List < MRS_Layer_Chip_Association__c > ();
            reTriggerList = reTriggerMap.values(); // each layer will have 1 layer chip record in this list
            for (MRS_Layer_Chip_Association__c m: reTriggerList) {
                m.CAD_Update__c = true;
            }
            update reTriggerList;
        }
        return reTriggerMap;
    }
}