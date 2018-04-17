/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: Before Update Trigger on MRS Layer Association
History:
created     24/5/2014
Change History:
Cognizant            25112014     -      Code modified for Task-1818      
*/
trigger MRS_Layer_Association_SWIFT_BUPD on MRS_Layer_Association__c(before update) {
	//Task-2426 - Do not allow Layer Status changed from Shipped to Released
	MRSHandlerUtilityExtn.validateLayerStatusUpdate(Trigger.new, Trigger.oldMap);

	/** Code for functional development (outside !IntegrationUserUtil.isSkipTrigger()) Start**/
	map < String, MRS_Layer_Association__c > mapReleasedLayerIds = new map < String, MRS_Layer_Association__c > ();
	map < MRS_Layer_Association__c, Boolean > mapLayersToStatus = new map < MRS_Layer_Association__c, Boolean > ();
	set < String > setTECNNumbers = new set < String > ();
	//Populate Layer Name
	set < string > setmst = new set < string > ();
	set < string > setlyr = new set < string > ();

	MRSHandlerUtility.setTimeStampForLayers(trigger.new, trigger.oldMap);

	for (MRS_Layer_Association__c mrsLayerObject: trigger.new) {
		if (((mrsLayerObject.Layer_Status__c != Trigger.oldmap.get(mrsLayerObject.id).Layer_Status__c) && (mrsLayerObject.Layer_Status__c == 'Released') && (mrsLayerObject.Last_Sync_Request_Timestamp__c == Trigger.oldmap.get(mrsLayerObject.id).Last_Sync_Request_Timestamp__c) && (mrsLayerObject.LogicalOperationType__c == 'TECN') && (mrsLayerObject.LogicalOperation__c != null) && (mrsLayerObject.LogicalOperation__c != '')) || ((mrsLayerObject.Layer_Status__c == Trigger.oldmap.get(mrsLayerObject.id).Layer_Status__c) && (mrsLayerObject.Layer_Status__c == 'Pending Foundry Release') && (mrsLayerObject.Last_Sync_Request_Timestamp__c == Trigger.oldmap.get(mrsLayerObject.id).Last_Sync_Request_Timestamp__c) && (mrsLayerObject.LogicalOperationType__c == 'TECN') && (mrsLayerObject.LogicalOperation__c != Trigger.oldmap.get(mrsLayerObject.id).LogicalOperation__c))) { //TASK-1818            
			mapReleasedLayerIds.put(mrsLayerObject.Id, mrsLayerObject);
			if (mrsLayerObject.LogicalOperation__c.contains(';')) {
				setTECNNumbers.addAll(mrsLayerObject.LogicalOperation__c.split(';'));
			} else {
				setTECNNumbers.add(mrsLayerObject.LogicalOperation__c);
			}
		}
		//Populate Layer Name        
		if (mrsLayerObject.layer_name__c == null || mrsLayerObject.layer_name__c == '') {
			setmst.add(mrsLayerObject.Mask_Set_Title_Name__c);
			setlyr.add(mrsLayerObject.Name);
		}
		//TASK-1879
		/*if(mrsLayerObject.Layer_Unique_Identifier__c==null){
    		mrsLayerObject.Layer_Unique_Identifier__c = mrsLayerObject.MRS_Layer_Unique_Identifier__c;	
    	}*/
		//TASK-1879	    
	}

	if (mapReleasedLayerIds != null && mapReleasedLayerIds.size() > 0) {
		mapLayersToStatus.putAll(MRSHandlerUtility.verifyTECNForReleasedLayers(mapReleasedLayerIds, setTECNNumbers));

		for (String layerId: mapReleasedLayerIds.keySet()) {
			MRS_Layer_Association__c obj = mapReleasedLayerIds.get(layerId);
			if (mapLayersToStatus.get(obj)) {
				obj.Layer_Status__c = 'Released';
			} else {
				obj.Layer_Status__c = 'Pending Foundry Release';
				obj.Layer_Status_Text__c = 'Pending Foundry Release';
			}
		}
	}
	/** Code for functional development (outside !IntegrationUserUtil.isSkipTrigger()) End**/

	if (!IntegrationUserUtil.isSkipTrigger()) {
		//Populate Layer Name
		map < string, string > mapmstlyrName = new map < string, string > ();

		for (Mask_Layer__c ml: [select name, Mask_Layer_Number__c, Mask_Set_Title__r.Name from Mask_Layer__c where Mask_Set_Title__r.Name in : setmst and Mask_Layer_Number__c in : setlyr]) {
			mapmstlyrName.put(ml.Mask_Set_Title__r.Name + '|' + ml.Mask_Layer_Number__c, ml.Name);
		}
		for (MRS_Layer_Association__c lyr: Trigger.new) {
			if (lyr.layer_name__c == null && mapmstlyrName.keyset() != null && mapmstlyrName.containskey(lyr.Mask_Set_Title_Name__c + '|' + lyr.Name)) {
				lyr.Layer_Name__c = mapmstlyrName.get(lyr.Mask_Set_Title_Name__c + '|' + lyr.Name);
			}
		}
	}
}