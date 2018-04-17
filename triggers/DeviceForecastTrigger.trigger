/*
	Author: Nino Bustillos
	Description: Marks the related Opportunity for Computation during insert.
	History:
		Nbustillos	02202013	- code creation.
		Nbustillos	02272013	- added logic not to rerun async computation.
*/
trigger DeviceForecastTrigger on Device_Forecast__c (after insert) {
	if(!QtrlyRevenueComputeAdjustments.bAdjComputationRunning){
		set<id> opptyIDs = new set<id>();
		
		// get opportunity Id
		for(Device_Forecast__c oDeviceForecast : trigger.new){
			opptyIDs.add(oDeviceForecast.Opportunity__c);
		}
		
		// retrieve the related opportunity the device is tied to and mark for computation
		/*list<Opportunity> lstOpptyToMarkForComputation = new list<Opportunity>();
		for(Opportunity oOppty : [select Compute_Adjustments__c from Opportunity where id in :opptyIDs]){
			oOppty.Compute_Adjustments__c = true;
			lstOpptyToMarkForComputation.add(oOppty);
		}
		
		if(lstOpptyToMarkForComputation.size()>0){
			update lstOpptyToMarkForComputation;
		}*/
		
		if(opptyIDs.size()>0){
			QtrlyRevenueComputeAdjustments.computeAdjustments(opptyIDs);
		}
	}
}