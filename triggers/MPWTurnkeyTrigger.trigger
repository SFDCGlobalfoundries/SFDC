/*
    Author: Shyam Nair
    Description: This serves as the trigger for MPW Turnkey
    History: 
        SNair      08152015    - Code creation.
        Poulami      03182016    - updated code to trigger email once Shipment information is updated.
        Anil Kumar 00070566 : April 7, 2017 : MPW-PP126 : Commented the functionality for Forecast ship date notification
*/
trigger MPWTurnkeyTrigger on MPW_Turnkey__c (after insert, after update) {
    Set<Id> primedieids = new Set<Id>();
    List<String> baredieshipdatelist = new List<String>();
    List<MPW_Prime_Die__c> mpwpdList = new List<MPW_Prime_Die__c>();
    List<MPW_Turnkey__c> mpwTurnKeyUpdateList = new List<MPW_Turnkey__c>();
    List<MPW_Turnkey__c> lstTurnkey = new List<MPW_Turnkey__c>();
    List<MPW_Turnkey__c> mpwTurnKeyUpdateForecastShipDateList = new List<MPW_Turnkey__c>();
    
    MPWTurnKeyTriggerHandler handler = new MPWTurnKeyTriggerHandler();
    
    if (!IntegrationUserUtil.isSkipTrigger()) {
        if(trigger.isAfter && trigger.isInsert){
            for(MPW_Turnkey__c m: trigger.new){
                primedieids.add(m.MPW_Prime_Die__c);
                baredieshipdatelist.add(String.valueOf(m.Ship_Date__c));
                
                //MPW_Turnkey__c oldMPWTurn = trigger.oldMap.get(m.Id);
                if(m.Ship_Date__c != null && (m.Category__c == 'Customer' || m.Category__c == 'IP')){
                    handler.sendReminderForShipmentInformation(trigger.new);
                }
            }
            
            
        }
        //03182016 - Added by Poulami Starts.
        if(trigger.isUpdate && trigger.isAfter){
            for(MPW_Turnkey__c m: trigger.new){
                MPW_Turnkey__c oldMPWTurn = trigger.oldMap.get(m.Id);
                // Modified by Anil Kumar : 00070566 : April 7, 2017
                if((m.Category__c == 'Customer' || m.Category__c == 'IP') && (oldMPWTurn.Ship_Date__c != m.Ship_Date__c || oldMPWTurn.Wafer_Ship_Date__c != m.Wafer_Ship_Date__c || oldMPWTurn.AWB__c != m.AWB__c || oldMPWTurn.Expected_Wafer_Skeleton_Return_Date__c != m.Expected_Wafer_Skeleton_Return_Date__c || oldMPWTurn.Bare_Die_Forecast_Ship_Date__c != m.Bare_Die_Forecast_Ship_Date__c)){
                    mpwTurnKeyUpdateList.add(m);
                }
                //Added by Anil : Backlog - MPW-PP109: Actual Wafer Skeleton Return Date
                if((m.Category__c == 'Customer' || m.Category__c == 'IP') && oldMPWTurn.Actual_Wafer_Skeleton_Return_Date__c != m.Actual_Wafer_Skeleton_Return_Date__c ){
                    lstTurnkey.add(m);
                }
                /** Commented by Anil Kumar : 00070566 : April 7, 2017
                if((m.Category__c == 'Customer' || m.Category__c == 'IP') && oldMPWTurn.Bare_Die_Forecast_Ship_Date__c != m.Bare_Die_Forecast_Ship_Date__c){
                    mpwTurnKeyUpdateForecastShipDateList.add(m);
                }
                */
            }
            if(!mpwTurnKeyUpdateList.isEmpty()){
                handler.sendReminderForShipmentInformationUpdate(mpwTurnKeyUpdateList,false);
            }
            //Added by Anil : Backlog - MPW-PP109: Actual Wafer Skeleton Return Date
            if(!lstTurnkey.isEmpty()){
                handler.sendReminderForReturnDateUpdate(lstTurnkey);
            }
            /** Commented by Anil Kumar : 00070566 : April 7, 2017
            if(!mpwTurnKeyUpdateForecastShipDateList.isEmpty()){
                handler.sendReminderForShipmentInformationUpdate(mpwTurnKeyUpdateForecastShipDateList,true);
            }
            */
        }
        //03182016 - Added by Poulami Ends.
        
        if(!primedieids.isEmpty()){
            mpwpdList = [select BARE_DIE_SHIP_DATE_FLAG__c, Bare_Die_Ship_Date__c from MPW_Prime_Die__c where Id IN: primedieids];
            if(!mpwpdList.isEmpty()){
                List<MPW_Prime_Die__c> lstPDTemp = new List<MPW_Prime_Die__c>();
                for(MPW_Prime_Die__c m: mpwpdList){
                    if(m.BARE_DIE_SHIP_DATE_FLAG__c == 'N' && m.Bare_Die_Ship_Date__c != null){
                        m.BARE_DIE_SHIP_DATE_FLAG__c = 'Y';
                    }
                    String shipdate = '';
                    if(m.Bare_Die_Ship_Date__c != null){
                         shipdate = m.Bare_Die_Ship_Date__c + ',';
                    }
                    for(String s: baredieshipdatelist){
                        shipdate += s+',';
                    }
                    shipdate = shipdate.substring(0, shipdate.length()-1);
                    if(shipdate != ''){
                        
                        m.Bare_Die_Ship_Date__c = shipdate;
                    }
                    m.Operation_Type__c = 'Update';
                    lstPDTemp.add(m);
                }
                
                if(lstPDTemp.size() > 0) {
                    update lstPDTemp;
                }
            }
        }
    } 
}