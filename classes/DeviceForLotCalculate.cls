/*
    Author: Anirban Roy
    Description: This class is called by DeviceUpdateTrigger to calculate the forecast lot start date. 
    History:
        ARoy        06052013    - code creation.        
        ZAmbat      07162014    - Updated code to populate Forecasted Lot Start Date also on Device insert/creation.
                                - Refer to 'Single Product' Lot Start Delay Maintenance record when Device Tapeout Type is 'Retrofit'.
        Vijay 		01282015	- updated the business logic to support the Internal Device functionality
*/

public class DeviceForLotCalculate {
        
    //Calculate the forecast lot start date
    public static void calculateForecastLotStartDate(List<Device__c> devList, Map<Id,Device__c> oldDeviceMap, string dmlTrans){
        
        // Declare the variables
        List<Id> mpwTrnMntList = new List<Id>();
        List<String> tapeOutTypList = new List<String>();
        List<String> geometryList = new List<String>();
        List<Integer> yrList = new List<Integer>();             
        List<Device__c> newDevList = new List<Device__c>();
        Map<Id, string> mapDeviceGeometry = new Map<Id, string>();
        
        if (dmlTrans == 'Insert') {
            // Get geometry    
            Set<Id> opptyProgramIds = new Set<Id>();
            for (Device__c d : devList) {
            	//for Customer Device
            	if(!DeviceTriggerHandler.isInternalDevice(d.RecordTypeId) && d.Opportunity_Program__c != null){
                	opptyProgramIds.add(d.Opportunity_Program__c);
            	}else{
            		//for Internal Device
            		geometryList.add(d.Internal_Device_Geometry__c);
            	}
            }
            
            if(opptyProgramIds != null && !opptyProgramIds.isEmpty()){
	            for (Opportunity_Program__c op : [SELECT    Id
	                                                        , Opportunity__r.Process_Geometry__c
	                                              FROM      Opportunity_Program__c
	                                              WHERE     Id IN :opptyProgramIds]) {
	                if (op.Opportunity__r.Process_Geometry__c != null) {
	                    mapDeviceGeometry.put(op.Id, op.Opportunity__r.Process_Geometry__c);
	                }
	            }
            }
        }
            
        for(Device__c device:devList){
            
            /*Device__c oldDevice = oldDeviceMap.get(device.Id);
            // Checking for the changes in the tapeout type, original forecasted tapeout date 
            // or current forecasted tapeout date
            if((oldDevice.Tapeout_Type__c != device.Tapeout_Type__c) ||
                        (oldDevice.Original_Forecasted_Tapeout_Date__c != device.Original_Forecasted_Tapeout_Date__c) ||
                                (oldDevice.Current_Forecast_Tapeout_Date__c != device.Current_Forecast_Tapeout_Date__c)){*/                                   
            boolean addToList = false;
            if (dmlTrans == 'Insert') {  
                if (device.Tapeout_Type__c != null
                    || device.Original_Forecasted_Tapeout_Date__c != null
                    || device.Current_Forecast_Tapeout_Date__c != null) {
                    addToList = true;
                }
            } else if (dmlTrans == 'Update') {  
                Device__c oldDevice = oldDeviceMap.get(device.Id);
                if (oldDevice.Tapeout_Type__c != device.Tapeout_Type__c 
                    || oldDevice.Original_Forecasted_Tapeout_Date__c != device.Original_Forecasted_Tapeout_Date__c
                    || oldDevice.Current_Forecast_Tapeout_Date__c != device.Current_Forecast_Tapeout_Date__c) {
                    addToList = true;
                }
            }
            
            if (addToList) {    
                if(device.MPW_Train_Number__c!=null){
                    mpwTrnMntList.add(device.MPW_Train_Number__c);
                }
                
                if(device.Tapeout_Type__c!=null){
                    //tapeOutTypList.add(device.Tapeout_Type__c);
                    if (device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c) {
                        tapeOutTypList.add(Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c);
                    } else {
                        tapeOutTypList.add(device.Tapeout_Type__c);
                    }
                }
                
                /*if(device.Geometry__c!=null){
                    geometryList.add(device.Geometry__c);
                }*/
                
                if (dmlTrans == 'Insert') {
                    if (mapDeviceGeometry != null && mapDeviceGeometry.containsKey(device.Opportunity_Program__c)) {
                        geometryList.add(mapDeviceGeometry.get(device.Opportunity_Program__c));
                    }
                } else if (dmlTrans == 'Update') {
                    if(device.Geometry__c != null){
                        geometryList.add(device.Geometry__c);
                    }
                }
                
                Date forecastLotDate;
                if(device.Current_Forecast_Tapeout_Date__c!=null){
                    forecastLotDate = device.Current_Forecast_Tapeout_Date__c;
                }else{
                    forecastLotDate = device.Original_Forecasted_Tapeout_Date__c;
                }
                if(forecastLotDate!=null){
                    Integer year = forecastLotDate.year();
                    yrList.add(year);
                }
                newDevList.add(device);
            }
        }
        system.debug('geometryList =================> ' + geometryList);
        // Calling of the functions for retrieval of Lot Start Quarter, Lot Start Delay Maintenance 
        // and MPW Train Number and putting into maps
        Map<String,Lot_Start_Quarter__c> lotStrQtrMap = new Map<String,Lot_Start_Quarter__c>();
        Map<String,Lot_Start_Delay_Maintenance__c> lotStrDlyMntMap = new Map<String,Lot_Start_Delay_Maintenance__c>();
        Map<String,MPW_Train_Maintenance__c> mpwTrnMntMap = new Map<String,MPW_Train_Maintenance__c>();
        
        if(yrList.size()>0){
            lotStrQtrMap = DeviceForLotCalculate.lotStartQtrMap(yrList);
        }
        
        if(geometryList.size()>0 || tapeOutTypList.size()>0 || yrList.size()>0){
            lotStrDlyMntMap = DeviceForLotCalculate.lotStartDlyMntMap(geometryList, tapeOutTypList, yrList);
        }
        
        if(mpwTrnMntList.size()>0){
            mpwTrnMntMap = DeviceForLotCalculate.mpwTrnMntMap(mpwTrnMntList);
        }       
        
        for(Device__c device:newDevList){                       
            Date forecastLotDate;
            if(device.Current_Forecast_Tapeout_Date__c!=null){
                forecastLotDate = device.Current_Forecast_Tapeout_Date__c;
            }else{
                forecastLotDate = device.Original_Forecasted_Tapeout_Date__c;
            }
            //Calculating the quarter for the which the forecastLotDate is applicable
            if(forecastLotDate!=null){
                Integer year = forecastLotDate.year();
                Integer month =  forecastLotDate.month();
                String yr = String.valueOf(year);
                String qtr='';
                Integer delay1 = 0;
                Integer delay2 = 0;
                if(lotStrQtrMap.containsKey(yr)){
                       Lot_Start_Quarter__c lotSrtQtr = lotStrQtrMap.get(yr);
                       Date dtQ1Stdt = lotSrtQtr.Quarter_1_Start_Date__c;
                       Date dtQ1Enddt = lotSrtQtr.Quarter_1_End_Date__c;
                       Date dtQ2Stdt = lotSrtQtr.Quarter_2_Start_Date__c;
                       Date dtQ2Enddt = lotSrtQtr.Quarter_2_End_Date__c;
                       Date dtQ3Stdt = lotSrtQtr.Quarter_3_Start_Date__c;
                       Date dtQ3Enddt = lotSrtQtr.Quarter_3_End_Date__c;
                       Date dtQ4Stdt = lotSrtQtr.Quarter_4_Start_Date__c;
                       Date dtQ4Enddt = lotSrtQtr.Quarter_4_End_Date__c;
                       if(forecastLotDate>=dtQ1Stdt && forecastLotDate<=dtQ1Enddt){
                           qtr='1';
                       }else if(forecastLotDate>=dtQ2Stdt && forecastLotDate<=dtQ2Enddt){
                           qtr='2';
                       }else if(forecastLotDate>=dtQ3Stdt && forecastLotDate<=dtQ3Enddt){
                           qtr='3';
                       }else if(forecastLotDate>=dtQ4Stdt && forecastLotDate<=dtQ4Enddt){
                           qtr='4';
                       }
                }
                
                //According to the quarter getting the delay in days from the Lot_Start_Delay_Maintenance__c records
                boolean retrieveDelay = false;
                string mapKey = '';
                if (dmlTrans == 'Insert') {
                	
                	//if block for Customer Device
                	if(!DeviceTriggerHandler.isInternalDevice(device.RecordTypeId)){
	                    if (device.Tapeout_Type__c != null && mapDeviceGeometry.containsKey(device.Opportunity_Program__c)) {
	                        retrieveDelay = true;
	                        if (device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c) {
	                            mapKey = yr + Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c + mapDeviceGeometry.get(device.Opportunity_Program__c);
	                        } else {
	                            mapKey = yr + device.Tapeout_Type__c + mapDeviceGeometry.get(device.Opportunity_Program__c);
	                        }
	                    }
                	}else{
                		//else block for Internal Device
                		if (device.Tapeout_Type__c != null) {
	                        retrieveDelay = true;
	                        if (device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c) {
	                            mapKey = yr + Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c + device.Internal_Device_Geometry__c;
	                        } else {
	                            mapKey = yr + device.Tapeout_Type__c + device.Internal_Device_Geometry__c;
	                        }
	                    }
                	}
                } else if (dmlTrans == 'Update') {
                	//below logic is applicable for Customer Device and Internal Device as Geometry__c is formula field and will populate the appropriate geometry 
                    if (device.Tapeout_Type__c != null && device.Geometry__c != null) {
                        retrieveDelay = true;
                        if (device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c) {
                            mapKey = yr + Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT').Value__c + device.Geometry__c;
                        } else {
                            mapKey = yr + device.Tapeout_Type__c + device.Geometry__c;
                        }
                    }
                }
                
                //if(device.Tapeout_Type__c!=null && device.Geometry__c!=null){
                if(retrieveDelay) {
                    /*if(lotStrDlyMntMap.containsKey(yr+device.Tapeout_Type__c+device.Geometry__c)){
                            Lot_Start_Delay_Maintenance__c lotSrtDlyMnt = lotStrDlyMntMap.get(yr+device.Tapeout_Type__c+device.Geometry__c);*/                     
                    if(lotStrDlyMntMap.containsKey(mapKey)){
                            Lot_Start_Delay_Maintenance__c lotSrtDlyMnt = lotStrDlyMntMap.get(mapKey);                             
                               if(lotSrtDlyMnt!=null){
                                   if(qtr=='1'){
                                       delay1 = (Integer)(lotSrtDlyMnt.Quarter_1_Delay__c!=null?lotSrtDlyMnt.Quarter_1_Delay__c:0);                             
                                   }
                                   if(qtr=='2'){
                                       delay1 = (Integer)(lotSrtDlyMnt.Quarter_2_Delay__c!=null?lotSrtDlyMnt.Quarter_2_Delay__c:0);                             
                                   }
                                   if(qtr=='3'){
                                       delay1 = (Integer)(lotSrtDlyMnt.Quarter_3_Delay__c!=null?lotSrtDlyMnt.Quarter_3_Delay__c:0);                             
                                   }
                                   if(qtr=='4'){
                                       delay1 = (Integer)(lotSrtDlyMnt.Quarter_4_Delay__c!=null?lotSrtDlyMnt.Quarter_4_Delay__c:0);                             
                                   }
                               }                        
                    }
                }                                               
                
                //If device tapeout type contains "MPW"
                if(device.Tapeout_Type__c!=null && device.Tapeout_Type__c.contains('MPW')){
                    //Getting the delay in days from MPW Train Maintenance
                    if(device.MPW_Train_Number__c!=null){
                        if(mpwTrnMntMap.containsKey(device.MPW_Train_Number__c)){
                                MPW_Train_Maintenance__c mpwTrainMnt = mpwTrnMntMap.get(device.MPW_Train_Number__c);
                                if(mpwTrainMnt!=null){
                                   delay2 = (Integer)((mpwTrainMnt.Delay__c==null)?0.0:mpwTrainMnt.Delay__c);
                                }
                        }
                    }
                    device.Forecasted_Lot_Start_Date__c = forecastLotDate.addDays(delay1+delay2);
                }else{
                    system.debug('forecastLotDate ================> ' + forecastLotDate);
                    system.debug('delay1 ================> ' + delay1);
                    device.Forecasted_Lot_Start_Date__c = forecastLotDate.addDays(delay1);
                }                   
                
            }
        }       
    }
    
    //Getting information from Lot_Start_Quarter__c object based on Year
    private static Map<String,Lot_Start_Quarter__c> lotStartQtrMap(List<Integer> yrList){
        
        Map<String,Lot_Start_Quarter__c> lotStrQtrMap= new Map<String,Lot_Start_Quarter__c>();                 
        for(Lot_Start_Quarter__c lotStrQtr : [select Id,Quarter_1_End_Date__c,Quarter_1_Start_Date__c,
                                             Quarter_2_End_Date__c,Quarter_2_Start_Date__c,Quarter_3_End_Date__c,Quarter_3_Start_Date__c,
                                             Quarter_4_End_Date__c,Quarter_4_Start_Date__c,Year__c from Lot_Start_Quarter__c 
                                             where Year__c = :yrList]){
            lotStrQtrMap.put(String.valueOf(lotStrQtr.Year__c),lotStrQtr);
        }        
        return lotStrQtrMap;
    }
    
    //Getting information from Lot_Start_Delay_Maintenance__c Delay based on Year,Tapeout Type and Geometry
    private static Map<String,Lot_Start_Delay_Maintenance__c> lotStartDlyMntMap(List<String> geometryList, List<String> tapeOutTypList, List<Integer> yrList){
        
        Map<String,Lot_Start_Delay_Maintenance__c> lotStrDlyMntMap= new Map<String,Lot_Start_Delay_Maintenance__c>();            
        for(Lot_Start_Delay_Maintenance__c lotStrDlyMnt : [select Geometry__c,Id,Quarter_1_Delay__c,Quarter_2_Delay__c,
                                                          Quarter_3_Delay__c,Quarter_4_Delay__c,Tapeout_type__c,Year__c 
                                                          from Lot_Start_Delay_Maintenance__c where Geometry__c = :geometryList 
                                                          and Tapeout_type__c = :tapeOutTypList and Year__c = :yrList]){
            lotStrDlyMntMap.put(String.valueOf(lotStrDlyMnt.Year__c)+lotStrDlyMnt.Tapeout_Type__c+lotStrDlyMnt.Geometry__c,lotStrDlyMnt);                               
        }        
        return lotStrDlyMntMap;
    }
    
    //Getting information from MPW Train Maintenance Delay
    private static Map<String,MPW_Train_Maintenance__c> mpwTrnMntMap(List<Id> mpwTrnMntList){
        
        Map<String,MPW_Train_Maintenance__c> mpwTrnMntMap = new Map<String,MPW_Train_Maintenance__c>();
        
        for(MPW_Train_Maintenance__c mpwTrainMnt : [select Delay__c,Id,
                                    Name from MPW_Train_Maintenance__c where Id = :mpwTrnMntList]){
            mpwTrnMntMap.put(mpwTrainMnt.Id,mpwTrainMnt);                              
        }        
              
        return mpwTrnMntMap;
    }
    
    
    
}