/*
    Author: Zymark Ambat
    Description: This Trigger manage the actions upon creating and updating PTRF records.
    History: 
        ZAmbat      06102013    - Code creation.
*/

trigger PTRFTrigger on PTRF__c (after insert, after update) {
	
	// Update Device/PTRF Info
	/*if (Trigger.isAfter && PTRFTriggerStopper.isExecuted == false) {
		Set<Id> deviceIds = new Set<Id>();
		Map<Id, PTRF__c> mapPTRF = new Map<Id, PTRF__c>(); 
		for (PTRF__c p : Trigger.New) {
			mapPTRF.put(p.Id, p);
			deviceIds.add(p.Device__c);
		}
		
		Map<Id, Device__c> mapDevice = new Map<Id, Device__c>([
			SELECT		Id
						, Name
						, Stage__c
						, Device_Mask_Set_Title__c
						, Device_Id__c
			FROM		Device__c
			WHERE		Id IN :deviceIds
		]); 
		
		List<Device__c> listUpdateDevice = new List<Device__c>();
		List<PTRF__c> listUpdatePTRF = new List<PTRF__c>();
		for (string key : mapPTRF.keySet()) {
			PTRF__c tempPTRF = mapPTRF.get(key);
			Device__c tempDevice = mapDevice.get(tempPTRF.Device__c);
			
			/*
				If PTRF Transaction Type is 'Device ID Only' and Existing Device Stage is in 'Design In' 
					i.		Only Device Id field in the Device record is updated if Mask Set Title does not start with 'MPW'.
					ii.		Mask Set Title will be updated in the Device record
					
				If PTRF Transaction Type is 'Life Cycle' and existing Device stage is 'Design in' and 'PTRF Prime Tape out' = 'Y'
					i.		Device stage will be updated to 'Tapeout'
					ii.		Mask Set Title will be updated
					iii.	Device Id will be updated only if Mask Set Title does not start with 'MPW'
					
				If PTRF Transaction Type is 'Life Cycle' and Existing Desvice stage is 'Design in' and 'PTRF Prime Tape out' = 'N' and (Frame Tapeout Or DRC Only, Prime GDSOUT Review Or Frame Mockup)='Y')
					i.		Device Id will be updated if Mask Set Title does not start with 'MPW'
					ii.		Mask Set Title will be updated in Salesforce.com
				
				If Transaction Type is 'Cancel'
					i.		Update PTRF status to Cancel
									
			
			
			if (tempPTRF.Transaction_Type__c.toUpperCase() == 'LIFECYCLE' && tempDevice.Stage__c == 'Design In' && tempPTRF.Prime_Tapeout__c == true) {
				// Update Mask Set Title and Device Stage
				tempDevice.Device_Mask_Set_Title__c = tempPTRF.Mask_Set_Title__c;
				tempDevice.Stage__c = 'Tapeout';
				if (tempPTRF.Mask_Set_Title__c.left(3).toUpperCase() != 'MPW') {
					// Update Device Id
					tempDevice.Name = tempPTRF.Name;
					tempDevice.Device_Id__c = tempPTRF.Name;
				}
				
				listUpdateDevice.add(tempDevice);
			} else if (tempPTRF.Transaction_Type__c.toUpperCase() == 'LIFECYCLE' && tempDevice.Stage__c == 'Design In' && tempPTRF.Prime_Tapeout__c == false
					   && ((tempPTRF.Frame_Tapeout__c == true || tempPTRF.DRC_Only__c == true) && (tempPTRF.Prime_GDSOUT_Review__c == true || tempPTRF.Frame_Mockup__c == true))) {
				// Update Mask Set Title
				tempDevice.Device_Mask_Set_Title__c = tempPTRF.Mask_Set_Title__c;
				if (tempPTRF.Mask_Set_Title__c.left(3).toUpperCase() != 'MPW') {
					// Update Device Id
					tempDevice.Name = tempPTRF.Name;
					tempDevice.Device_Id__c = tempPTRF.Name;
				}
				
				listUpdateDevice.add(tempDevice);
			} else if (tempPTRF.Transaction_Type__c == 'Cancel') {
				// Update PTRF Status
				tempPTRF.Status__c = 'Cancel';
				
				listUpdatePTRF.add(tempPTRF);
			}
		}
		
		// Update Device records
		if (listUpdateDevice.size() > 0) {
			update listUpdateDevice;
		}
		
		// Update PTRF records
		if (listUpdatePTRF.size() > 0) {
			// Set Trigger Stopper flag
			PTRFTriggerStopper.isExecuted = true;
			
			update listUpdatePTRF;
		}
	}*/
	
}