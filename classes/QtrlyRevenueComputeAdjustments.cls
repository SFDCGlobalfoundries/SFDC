/*
    Author: Nino Bustillos
    Description: Computes for the adjustment of quarterly revenue
    History:
        Nbustillos  02222013    - code creation.
        Nbustillos  02262013    - added logic to still compute for adjusted volume even if there is no device forecast.
        Nbustillos  02272013    - added property to prevent calling the function in another async function.
        Nbustillos	02272013	- added logic to still compute for adjusted volume even if there is no device. 
*/
global class QtrlyRevenueComputeAdjustments {
    global static boolean bAdjComputationRunning = false;

    @future
    global static void computeAdjustments(set<id> opptyIDsToCompute){
        //set<id> opptyIDs = new set<id>();
        set<id> deviceIDs = new set<id>();
        
        QtrlyRevenueComputeAdjustments.bAdjComputationRunning = true;
        
        // collate device ids and opportunity ids
        for(Opportunity_Program__c oOpptyProg : [select id, Opportunity__c, (select id from Devices__r) from Opportunity_Program__c where 
                                        Opportunity__c in :opptyIDsToCompute]){
            //opptyIDs.add(oOpptyProg.Opportunity__c);
            for(Device__c oDevice : oOpptyProg.Devices__r){
                deviceIDs.add(oDevice.id);
            }
        }
        
        // retrieve and cache Quarterly Revenue records
        list<Opportunity> lstOpptyToResetFlag = new list<Opportunity>();
        map<id,map<string,Quarterly_Revenue_Object__c>> mOpptyQuarterlyRevenues = new map<id,map<string,Quarterly_Revenue_Object__c>>(); // map<oppty id, map<Yr-FiscalQtr,quarterly revenue>>
        for(Opportunity oOppty : [select id,  (select id, Volume__c, Probability__c, Adjusted_Volume__c, 
                                  Fiscal_Quarter__c from Quarterly_Revenues__r where Fiscal_Quarter__c != null) from Opportunity where id in :opptyIDsToCompute]){ //Compute_Adjustments__c,
            
            // reset flag
            //oOppty.Compute_Adjustments__c = false;
            //lstOpptyToResetFlag.add(oOppty);
            
            for(Quarterly_Revenue_Object__c oQtrlyRevenue : oOppty.Quarterly_Revenues__r){
                string sFiscalQtr = oQtrlyRevenue.Fiscal_Quarter__c;
                
                if(mOpptyQuarterlyRevenues.containsKey(oOppty.Id)){
                    // we are expecting only a single Yr-FiscalQtr combination of quarterly revenue for each Opportunity.
                    map<string,Quarterly_Revenue_Object__c> mQuarterlyRevenues = mOpptyQuarterlyRevenues.get(oOppty.Id);
                    mQuarterlyRevenues.put(sFiscalQtr,oQtrlyRevenue);
                    mOpptyQuarterlyRevenues.put(oOppty.id, mQuarterlyRevenues);
                }else{
                    mOpptyQuarterlyRevenues.put(oOppty.id, new map<string,Quarterly_Revenue_Object__c>{sFiscalQtr => oQtrlyRevenue});
                }
            }
            
        }
        
        // retrieve and cache Device Forecast records
        map<id,map<string,decimal>> mOpptyDeviceForecasts = new map<id,map<string,decimal>>(); // map<oppty id, map<Yr-FiscalQtr,integer>>
        for(Device__c oDevice : [select id, Opportunity__c, (select Quantity__c, Fiscal_Quarter__c from Device_Forecasts__r) from Device__c where id in :deviceIDs]){ //Date__c, 
            
            for(Device_Forecast__c oDeviceForecast : oDevice.Device_Forecasts__r){
                string sFiscalQtr = oDeviceForecast.Fiscal_Quarter__c;
                
                if(mOpptyDeviceForecasts.containsKey(oDevice.Opportunity__c)){
                    // summarize the quantity based on year and month
                    // we are expecting duplicate Yr-FiscalQtr for device forecast for each Opportunity if it has multiple devices.
                    map<string,decimal> mDeviceForecasts = mOpptyDeviceForecasts.get(oDevice.Opportunity__c);
                    
                    if(mDeviceForecasts.containsKey(sFiscalQtr)){
                        decimal iTotalVolume = mDeviceForecasts.get(sFiscalQtr);
                        iTotalVolume += oDeviceForecast.Quantity__c;
                        mDeviceForecasts.put(sFiscalQtr,iTotalVolume);
                    }else{
                        mDeviceForecasts.put(sFiscalQtr,oDeviceForecast.Quantity__c);
                    }
                    
                    mOpptyDeviceForecasts.put(oDevice.Opportunity__c, mDeviceForecasts);
                }else{
                    mOpptyDeviceForecasts.put(oDevice.Opportunity__c, new map<string,decimal>{sFiscalQtr => oDeviceForecast.Quantity__c});
                }
            }
            
        }
        
        // compute adjustment
        list<Quarterly_Revenue_Object__c> lstQuarterlyRevenueToUpdate = new list<Quarterly_Revenue_Object__c>();
        for(id opptyID : mOpptyQuarterlyRevenues.keySet()){
            
            map<string,Quarterly_Revenue_Object__c> mQuarterlyRevenues = mOpptyQuarterlyRevenues.get(opptyID);
            
            for(string sFiscalQtr : mQuarterlyRevenues.keySet()){
                // get the Quarterly Revenue based on Yr-FiscalQtr
                Quarterly_Revenue_Object__c oQuarterlyRevenue = mQuarterlyRevenues.get(sFiscalQtr);
                oQuarterlyRevenue.Adjusted_Volume__c = 0;
                
                // check if there is an equivalent sum for this Yr-FiscalQtr 
                if(mOpptyDeviceForecasts.containsKey(opptyID)){
                    map<string,decimal> mDeviceForecastTotals = mOpptyDeviceForecasts.get(opptyID);
                    if(mDeviceForecastTotals.containsKey(sFiscalQtr)){
                        decimal dTotalDeviceForecastQty = mDeviceForecastTotals.get(sFiscalQtr);
                        
                        // compute volume x probability - sum of device forecast volume
                        oQuarterlyRevenue.Adjusted_Volume__c = (oQuarterlyRevenue.Volume__c * (oQuarterlyRevenue.Probability__c/100)) - dTotalDeviceForecastQty;
                        
                        // if adjustment is negative, make it zero
                        if(oQuarterlyRevenue.Adjusted_Volume__c<0){
                            oQuarterlyRevenue.Adjusted_Volume__c = 0;
                        }
                            
                        lstQuarterlyRevenueToUpdate.add(oQuarterlyRevenue);
                    }else{
                        // compute adjustment for volume x probability only.
                        oQuarterlyRevenue.Adjusted_Volume__c = (oQuarterlyRevenue.Volume__c * (oQuarterlyRevenue.Probability__c/100));
                        lstQuarterlyRevenueToUpdate.add(oQuarterlyRevenue);
                    }
                }else{
                    // compute adjustment for volume x probability only.
                    oQuarterlyRevenue.Adjusted_Volume__c = (oQuarterlyRevenue.Volume__c * (oQuarterlyRevenue.Probability__c/100));
                    lstQuarterlyRevenueToUpdate.add(oQuarterlyRevenue);
                }
                
            }
            
        }
        
        // check if there are quarterly revenue records to update
        if(lstQuarterlyRevenueToUpdate.size()>0){
            update lstQuarterlyRevenueToUpdate;
        }
    }
}