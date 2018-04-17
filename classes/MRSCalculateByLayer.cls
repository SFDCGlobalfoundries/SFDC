public class MRSCalculateByLayer {

	public boolean isUpdated {get;set;}	
	public String infoMsgToParent {get;set;}
	
	public MRSCalculateByLayer() {
		isUpdated = false;
		infoMsgToParent = '';
	}
	
	public void calculateStatus() {
		MRS_Layer_Association__c oldLayerCaptured;
		String layerId = ApexPages.currentPage().getParameters().get('lid');
		// if( ApexPages.currentPage().getParameters().containsKey('lid') ) { layerId = ApexPages.currentPage().getParameters().get('lid'); }
		List<MRS_Layer_Association__c> oldLayerList = [
			SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,
				Customer_Frame_Mockup__c,Layer_Status__c,Foundry_Frame_Mockup__c,
				Send_Prime_Data__c,Send_Frame_Data__c,Customer_Prime_Remote_Jobview_Setup__c,
				Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,
				Foundry_Frame_Remote_Jobview_Setup__c,ORC__c,DRW__c,Prime_MEBES_Received__c,
				Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,
				Tapeout_Centre_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,
				GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c 
			FROM MRS_Layer_Association__c 
			WHERE Id = :layerId];
			
		if( !oldLayerList.isEmpty() ) {			
			oldLayerCaptured = oldLayerList.get(0);
			String selectedLayerId = oldLayerCaptured.Id;
			String query = 
				'SELECT id,Layer_Chip_Status__c,Customer_GDSOUT_Review__c,' 
				+ 	'Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,' 
				+ 	'Send_Prime_Data__c,Send_Frame_Data__c,DRW__c,ORC__c,Prime_MEBES_Received__c,' 
				+ 	'Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,' 
				+ 	'GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,' 
				+ 	'Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,PTRF__r.Tech_Geo_Value__c,Layer_Name__c,Rev__c,Chip_Name__c,PTRF_Number__c,Mask_Set_Title_Name__c ' 
				+ 'FROM MRS_Layer_Chip_Association__c '
				+ 'WHERE Layer__c= :selectedLayerId ';
	
			List<MRS_Layer_Chip_Association__c> layerChips = new List<MRS_Layer_Chip_Association__c>();
			layerChips = Database.query(query + ' AND Layer_Chip_Status__c IN (\'Not Ready\',\'In Progress\')');			
			if( layerChips.isEmpty() ) {				
				layerChips = new List<MRS_Layer_Chip_Association__c>();
				layerChips = Database.query(query + ' AND Layer_Chip_Status__c IN (\'Released\') limit 1');
				if( !layerChips.isEmpty() ) {
					try { infoMsgToParent = triggerLayer(layerChips.get(0), oldLayerCaptured); 
					} catch(Exception e) { logErrorCalc('Unexpected Calc Status error occurred by ', layerChips.get(0), e); }
				}
			} else {
				try { BatchScheduleSetLayerChipStatus.reTriggerLayerChip(layerChips); infoMsgToParent = triggerLayer(layerChips.get(0), oldLayerCaptured); 
				} catch(Exception e) { logErrorCalc('Unexpected Calc Status error occurred by ', layerChips.get(0), e); }
			}
		}
		
		//System.debug('$#$# infoMsgToParent: ' + infoMsgToParent);
		
		if( !String.isBlank(infoMsgToParent) ) {
			isUpdated = true;
		}
	}
	
	public String triggerLayer (MRS_Layer_Chip_Association__c temp, MRS_Layer_Association__c oldLayerCaptured) {
		String infoMessage = '';
		temp.CAD_Update__c = true;
		update temp; // DML HERE
		
		MRS_Layer_Association__c afterCalculatedLayerCaptured = [
			SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Layer_Status__c,Name,Mask_Layer_Rev__c,
				Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,Customer_Prime_Remote_Jobview_Setup__c,
				Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,
				Foundry_Frame_Remote_Jobview_Setup__c,ORC__c,DRW__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c,
				Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,
				Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c
			FROM MRS_Layer_Association__c 
			WHERE Id = :oldLayerCaptured.Id
		];
		
		String updateMessages = ''; // store detail on which fields has been update if any
		String layerName = afterCalculatedLayerCaptured.Name + afterCalculatedLayerCaptured.Mask_Layer_Rev__c; // sample value: RXAZ
		
		// overall status
		infoMessage += oldLayerCaptured.Layer_Status__c != afterCalculatedLayerCaptured.Layer_Status__c 
			? '<span class="bold-font">Layer Status</span> has been changed from "<span class="bold-font">' + oldLayerCaptured.Layer_Status__c + '</span>" to "<span class="bold-font">' + afterCalculatedLayerCaptured.Layer_Status__c + '</span>".<br />' 
			: '';
		
		for ( String thisField: fetchFieldNames() ) {
			String fieldApi = thisField.split(':')[0];
			String fieldLabel = thisField.split(':')[1];
			infoMessage += oldLayerCaptured.get(fieldApi) != afterCalculatedLayerCaptured.get(fieldApi) 
				? '+ <span class="bold-font">' +  fieldLabel + '</span> has been changed from "<span class="bold-font">' + oldLayerCaptured.get(fieldApi) + '</span>" to "<span class="bold-font">' + afterCalculatedLayerCaptured.get(fieldApi) + '</span>".<br />'
				: '';
		}
		
		if( String.isNotEmpty(infoMessage) ) { infoMessage = 'Messages for layer <span class="bold-font">' + afterCalculatedLayerCaptured.Name + afterCalculatedLayerCaptured.Mask_Layer_Rev__c + '</span>.<br />' + infoMessage; }
		return infoMessage;
	}
	
	public void logErrorCalc(String errorMessage, MRS_Layer_Chip_Association__c layerChip, Exception e) {
		String userStr = UserInfo.getUserName();
		String mstStr = 'MST: ' + layerChip.Mask_Set_Title_Name__c;
		String layerStr = 'Layer: ' + layerChip.Layer_Name__c;
		String layerChipStr = 'Layer Chip: ' + layerChip.Layer_Name__c + '('+ layerChip.Rev__c +') - ptrf: ' + layerChip.PTRF_Number__c;
		
		String errorMssPage = errorMessage + userStr + ' on ' + mstStr + ', ' + layerStr + ', ' + layerChipStr; // message shown on screen
		String errorMss = errorMessage + '\n' + userStr + '\n' + mstStr + '\n' + layerStr + '\n' + layerChipStr; // message log at Application Log level
		SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = 'ERROR',
            Apex_Component_Name__c    = 'MRSLayerSummaryExtn',
            Method__c                 = 'calculateStatus',
            Message_ID__c             = 'ReCalculate ' + System.now(),
            Error_Message__c          = errorMss,
            Stack_Trace__c            = e.getMessage() + '\n' + e.getStackTraceString()
        );
        insert log;
        
        //errorMssPage += '. ' + Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_ERROR_MESSAGE').Value__c;
        //this.errorMessage = errorMssPage;
       	//showPopup();
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
		listFieldNames.add('MDP_MEBES_Jobview__c:DRR');
		listFieldNames.add('TDTI_MPW_MEBES_Jobview__c:TDTI MPW MEBES Jobview');
		return listFieldNames;
	}
}