/***********************************************************************************************************************************
Trigger: PopulateAndUpdateFieldsOnParentProposal
------------------------------------------------------------------------------------------------------------------------------------
Author: Joydev Mondol (Cognizant - 153480)
Created Date: 31/10/2013
Reason: Populates the Devices in the Proposal record. It fetches the Line Items of the proposal, 
        filters them with Devices types and concatenates them to generate the Devices.
        Populates the IPs in the Proposal record. It fetches the Line Items of the proposal, 
        filters them with IPs types and concatenates them to generate the IPs.
        Populates the Mask Set in the Proposal record. It fetches the Line Items of the proposal, 
        filters them with mask layer types and concatenates them to generate the Mask Set.
Change History: 1. Prosenjit Saha 10th July,2014
                Reason: New packaging options have been added in the proposal header level.
                2. Prosenjit Saha 25th July,2014
                Reason: Poly Orientation Logic added
                3. Prosenjit Saha 5th Aug,2014
                Reason: Unique Mask layer for configuration Update
                4. Anirban Roy 20th Aug,2014 
                Reason: Populate the Process Technology lookup for reporting purpose. 
                5. Karna shiva 29th Mar 2016 - 00053241
                Reason: Populate the Device List and Model Name on Configurator
                6. Karna shiva 29th Mar 2016 - 00053241
                Reason: Mask_Set_Integration_Text__c replaced with Mask_Set_Integration__c to avoid AIA Integration failure
                7. Ravi Teja Boggala 10th Mar 2017 - 	00066387
                Reason: Mask_Set_Integration__c value is empty and mask information sending through out bound message is sending nothing.
				8. Ravi Teja Boggala 15th Mar 2017 - Case#00068494 & Case#00068406 (Missing Devices in Configuration XML)
				Reason: Duplicate check using string.contains method will remove devices Eg: In iterating if egncap comes first then ncap then ncap will not be added to device list as it contains in first iteration.
				9. Ravi TEja Boggala 06th Apr 2017 - Case#00061410
				Reason: As there is a possibility to come multiple devices in single line with comma seperated we need to show them 
				as multiple devices in XML, Line Number: 114,115
				10. Ravi Teja Boggala 14 Apr 2017 - Case#00061410 112,113,114,115
				Reason: Where the devices on config pdf is pulling from Description field but not from product code, to maintain the data same in both config pdf and config xml Description field is used in both the places.
				11. Ravi Teja Boggala 03 May 2017 - Line Numbers: 103,107,108, 111,114,115,124,129,135,136,142,143,149,150 - Case#00068406
				Reason: Missing Devices in validator and pdf as the Product Option field record value is getting deleted on technology update.
************************************************************************************************************************************/

trigger PopulateAndUpdateFieldsOnParentProposal on 
                    Apttus_Proposal__Proposal_Line_Item__c (After Insert, After Update, before insert, before update) {
    
    if((trigger.isBefore) && (trigger.isInsert || trigger.isUpdate)){
        Set<Id> setOfProductIds = new Set<Id>();
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem: trigger.new){
            if(lineItem.Option_Name_Static__c == null && lineItem.Apttus_QPConfig__OptionId__c != null)
                setOfProductIds.add(lineItem.Apttus_QPConfig__OptionId__c);
        }
        if(setOfProductIds.size()>0){
            Map<Id, Product2> mapOptionProducts = new Map<Id, Product2>([Select id, Name, IP_Design_Kit_Name__c, IP_Device_List__c, Mask_Sets__c, Description, SRAM_Type__c, Family, Product_External_ID__c from Product2 where id IN : setOfProductIds]);
            for(Apttus_Proposal__Proposal_Line_Item__c lineItem: trigger.new){
                if(mapOptionProducts.containsKey(lineItem.Apttus_QPConfig__OptionId__c)){
                    Product2 optionProduct = mapOptionProducts.get(lineItem.Apttus_QPConfig__OptionId__c);
                    lineItem.Option_IP_DesignKit_Version_Static__c = optionProduct.IP_Design_Kit_Name__c;
                    lineItem.Option_IP_Device_List_Static__c = optionProduct.IP_Device_List__c;
                    lineItem.Option_Mask_Sets_Static__c = optionProduct.Mask_Sets__c;
                    lineItem.Option_Model_Name_Static__c = optionProduct.Description;
                    lineItem.Option_Sram_Type_Static__c = optionProduct.SRAM_Type__c;
                    lineItem.Option_Name_Static__c = optionProduct.Name;
                    lineItem.Option_Product_Family_Static__c = optionProduct.Family;
                    lineItem.Option_Product_ExternalId_Static__c = optionProduct.Product_External_ID__c;
                }
                lineItem.Option_Section_Name_Static__c = lineItem.Option_Product_Category_Hierarchy_Label__c;
            }
        }
    }
    
    if(trigger.isAfter){
		List<Apttus_Proposal__Proposal_Line_Item__c> listOfBundleProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(Apttus_Proposal__Proposal_Line_Item__c pli : Trigger.new){
			if(pli.Apttus_QPConfig__ItemSequence__c == 1)
				listOfBundleProposalLineItems.add(pli);
		}
		if(listOfBundleProposalLineItems.size()>0){
				//Map of Proposal with Device LineItems (List)
			Map<Id, List<String>> mapProposalWithDeviceLineItems = new Map<Id, List<String>>();

			//Map of Proposal with Metal Stacks		
			Map<Id, String> mapMetalStacksLineItems = new Map<Id, String>();

			//Map of Proposal with IP LineItems (List)
			Map<Id, List<String>> mapProposalWithIPLineItems = new Map<Id, List<String>>();

			//Map of Proposal with Mask Layer LineItems (List)
			Map<Id, List<String>> mapProposalWithMaskLineItems = new Map<Id, List<String>>();

			//Map of Proposal with Additional Questions (Field API Names) (List)
			Map<Id, List<String>> mapProposalWithAdditionalQuestions = new Map<Id, List<String>>();

			//Master map of Additional Questions with Field API Names
			Map<String, String> mapMasterAdditionalQuestions = new Map<String, String>();

			//Map for Packaging options. Key: Field API name, Value: field value
			Map<String, Apttus_Proposal__Proposal_Line_Item__c> mapMasterPackagingOptions = new Map<String, Apttus_Proposal__Proposal_Line_Item__c>();

			// 00053241 - added to store device description - start
			//Map of Proposal with Device Description (List)
			Map<Id, List<String>> mapStr = new Map<Id, List<String>>();
			Map<Id, List<String>> mapStrProdName = new Map<Id, List<String>>();
			// 00053241 - added to store device description - end                    
								
			//String delimiter
			String szDelimiter = '<:>';

			//generate the map of Additional Question String with the Feild API Name in Proposal object
			for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.Additional_Questions.getFields()) {
				mapMasterAdditionalQuestions.put(f.Label, f.getFieldPath());
			}
								

			//String for the Query
			String ProposalIds = '(';

			for(Apttus_Proposal__Proposal_Line_Item__c lineItem : listOfBundleProposalLineItems){
				ProposalIds = ProposalIds.contains(lineItem.Apttus_Proposal__Proposal__c)? ProposalIds : ProposalIds + '\'' + lineItem.Apttus_Proposal__Proposal__c + '\','; 
				mapProposalWithDeviceLineItems.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>()); 
				  
				mapProposalWithIPLineItems.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>());   
				mapProposalWithMaskLineItems.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>()); 
				mapProposalWithAdditionalQuestions.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>());  
				mapStr.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>()); 
				mapStrProdName.put(lineItem.Apttus_Proposal__Proposal__c, new List<String>()); 
				mapMetalStacksLineItems.put(lineItem.Apttus_Proposal__Proposal__c,'');
			}

			ProposalIds = (ProposalIds != '(' ? ProposalIds.substring(0, ProposalIds.length() - 1) + ')' : '');

			String PropLineItemQuery = 'Select '; 
				
			for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal_Line_Item__c.FieldSets.LineItemQuery.getFields()) {
				PropLineItemQuery += f.getFieldPath() + ', ';
			}
			PropLineItemQuery += 'Apttus_Proposal__Product__r.ProductCode,Apttus_QPConfig__OptionId__r.Name,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_QPConfig__OptionId__r.Description,Apttus_Proposal__Product__r.PT_Number__c FROM Apttus_Proposal__Proposal_Line_Item__c Where Apttus_Proposal__Proposal__c IN ' + ProposalIds ;

			//fetch the proposal line items in scope and prepare the maps    
			for(Apttus_Proposal__Proposal_Line_Item__c lineItem : Database.query(PropLineItemQuery)){

				if(lineItem.Apttus_QPConfig__OptionId__c == NULL && lineItem.Option_Name_Static__c == NULL){
						mapMasterPackagingOptions.put(lineItem.Apttus_Proposal__Proposal__c,lineItem);
				}
				
				if(lineItem.Option_Product_Family_Static__c == 'Metal Stacks'){ // Modified changed Product_Family__c to Option_Product_Family_Static__c by Ravi Teja.B 03052017 for Empty Devices when there is a technology update		
						mapMetalStacksLineItems.put(lineItem.Apttus_Proposal__Proposal__c,lineItem.Option_Name_Static__c);
				}

				if(lineItem.Option_Product_Family_Static__c == 'Devices'){ // Modified changed Product_Family__c to Option_Product_Family_Static__c by Ravi Teja.B 03052017 for Empty Devices when there is a technology update
					String szProductCode,szProdDescr,szProdName;
					//Modified by Ravi Teja.B on 14-04-2017 where the devices on config pdf is pulling from Description field but not from product code
					if(lineItem.Option_Model_Name_Static__c != null)
					szProductCode = lineItem.Option_Model_Name_Static__c.trim();
					//szProductCode = szProductCode.trim().replace(lineItem.Apttus_Proposal__Product__r.ProductCode, '');
					//szProductCode = szProductCode.subString(1,szProductCode.length());
					//Modified by Ravi Teja.B on 06/04/2017 as there is a possibility to come multiple devices in single line with comma seperated
					if(szProductCode != null) 
					mapProposalWithDeviceLineItems.get(lineItem.Apttus_Proposal__Proposal__c).addAll(szProductCode.split(',(?![^(]*[)])'));
			   
			  // 00053241 - added to store device description - start           

				szProdDescr = lineItem.Option_Name_Static__c;
					
				if(szProductCode <> null){
					szProdDescr= szProductCode + '=>'+ (String.isBlank(szProdDescr)? 'None' : szProdDescr);
					   mapStr.get(lineItem.Apttus_Proposal__Proposal__c).add(szProdDescr);
					   mapStrProdName.get(lineItem.Apttus_Proposal__Proposal__c).add(lineItem.Option_Name_Static__c);
				 }
			  
			  }
			  // 00053241 - added to store device description - end        

				if(lineItem.Option_Product_Family_Static__c == 'IPs'){// Modified changed Product_Family__c to Option_Product_Family_Static__c by Ravi Teja.B 03052017 for Empty Devices when there is a technology update
					String szProductCode = lineItem.Option_Product_ExternalId_Static__c;
					szProductCode = szProductCode.trim();
				
					mapProposalWithIPLineItems.get(lineItem.Apttus_Proposal__Proposal__c).add(szProductCode);
				}
				
				if(lineItem.Option_Product_Family_Static__c == 'Mask Layers'){ // Modified changed Product_Family__c to Option_Product_Family_Static__c by Ravi Teja.B 03052017 for Empty Devices when there is a technology update
					String szMask = lineItem.Option_Name_Static__c;
					szMask = szMask.trim();
				
					mapProposalWithMaskLineItems.get(lineItem.Apttus_Proposal__Proposal__c).add(szMask);
				}
				
				if(lineItem.Option_Product_Family_Static__c == 'Additional Questions'){ // Modified changed Product_Family__c to Option_Product_Family_Static__c by Ravi Teja.B 03052017 for Empty Devices when there is a technology update
					String szAddQues = lineItem.Option_Name_Static__c;
					szAddQues = szAddQues.trim();
				
					mapProposalWithAdditionalQuestions.get(lineItem.Apttus_Proposal__Proposal__c).add(szAddQues);
				}
			}

			String ConfigLineItemQuery = 'Select ';
				
			for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.ConfigurationQuery.getFields()) {
				ConfigLineItemQuery += f.getFieldPath() + ', ';
			}
			ConfigLineItemQuery += 'ID FROM Apttus_Proposal__Proposal__c Where ID IN ' + ProposalIds ;

			//fetch the proposals of the line items in scope
			List<Apttus_Proposal__Proposal__c> lstProposals = Database.query(ConfigLineItemQuery);

			// Added AR : 08202014 (For reporting purpose) - Start 
			Set<String> ptNumSet = new Set<String>(); 
			// End 
			//loop through the proposals fetched to populate the devices
			for(Apttus_Proposal__Proposal__c proposal : lstProposals){
				String szDevices = '';
				String szMaskSet = '';
				Set<String> szMaskSetActual = new Set<String>();
				String szIPs = '';
				String szDevicesProd = '',szDevicesProdName='',szDevicesProdName1='';
				String szDelimiterDev = '\n';
				String szDevices1  ='';
				//generate the devices by concatenating the device productcodes (in form of options.productcode in line item records)
				Set<String> dupCheck = new Set<String>(); // Added By Ravi Teja.B 15-03-17 Case#00068494 & Case#00068406
				for(String szDevice : mapProposalWithDeviceLineItems.get(proposal.Id)){
					//szDevices += (!szDevices.contains(szDevice.trim()) ? szDevice.trim() + szDelimiter : '');
					if(!dupCheck.contains(szDevice))
						szDevices += szDevice.trim() + szDelimiter;
					szDevice = szDevice.trim();
					dupCheck.add(szDevice);
				}
				
				proposal.APTPS_Metal_Options__c = mapMetalStacksLineItems.containsKey(proposal.id)?mapMetalStacksLineItems.get(proposal.id):'';
					  
				proposal.Devices__c = szDevices.right(szDelimiter.length()) == szDelimiter ? szDevices.Substring(0,szDevices.length()-szDelimiter.length()).trim() : szDevices.trim();
				
				// 00053241 - added to store device description - start
				//generate the devices by concatenating the device productcodes (in form of options.productcode in line item records)
				
				for(String szDevice : mapStr.get(proposal.Id)){

					szDevices1 +=  /*','*/ '\n' + szDevice;
				}
				for(String szDevice : mapStrProdName.get(proposal.Id)){
					szDevicesProd += (!szDevicesProdName.contains(szDevice.trim()) ? szDevice.trim() + szDelimiter : '');
					szDevicesProdName1 +=  /*','*/ '\n' + szDevice ;
					
				 }
			  
				proposal.Device_Description__c = szDevices1 ;
				proposal.Device_List__c = szDevicesProd.removeEnd('<:>');
				proposal.Device_List_for_Email__c = szDevicesProdName1;
				
				// 00053241 - added to store device description - end
						 
				//generate the Mask Set by concatenating the Mask Layers (in form of option name in line item records)
				for(String szMask : mapProposalWithMaskLineItems.get(proposal.Id)){
					szMaskSetActual.add(szMask.trim());           
				}
                List<String> sortedSzMaskSetActual = new List<String>();
                sortedSzMaskSetActual.addAll(szMaskSetActual);
                sortedSzMaskSetActual.sort();
				//PS 08052014: added for bug: to make string unique of the mask with same literal. 
                for(String masks : sortedSzMaskSetActual){
					szMaskSet += (szMaskSet == '')? masks : ' ' + masks.trim();
				}            
                //Case#00068899
                proposal.RS_Opening__c = szMaskSetActual.contains('RS') ? 'Yes' : 'No';
				//changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
				proposal.Mask_Set_Long__c = szMaskSet.trim();         
				if(proposal.Mask_Set_Long__c <> null && proposal.Mask_Set_Long__c.length() > 0){
					String reticleStr = PIDMatchesController.getReticleLayers(proposal.Mask_Set_Long__c);
					proposal.Reticle_Count__c = (reticleStr.length() - (reticleStr.deleteWhitespace()).length()) + 1; 
					proposal.Mask_Count_Number__c = (proposal.Mask_Set_Long__c.length() - (proposal.Mask_Set_Long__c.deleteWhitespace()).length()) + 1;
					// 00053241 - send mask set information to AIA - start 
					//proposal.Mask_Set_Integration_Text__c = proposal.Mask_Set_Long__c.replaceAll(' ','#');   
					//Added By Ravi Teja Case#00066387
					proposal.Mask_Set_Integration__c = proposal.Mask_Set_Long__c.replaceAll(' ','#');
					// 00053241 - send mask set information to AIA - end         
					proposal.Genrate_PDF_Helper__c = true;                                    
				}        
				else{
					proposal.Mask_Count_Number__c = 0;
					proposal.Genrate_PDF_Helper__c = false;  
				}
				
				//generate the IPs by concatenating the IP productcodes (in form of options.productcode in line item records)
				for(String szIP : mapProposalWithIPLineItems.get(proposal.Id)){
					if(szIP != null){
						szIP = szIP.trim();
						szIPs += (!szIPs.contains(szIP.trim()) ? szIP + szDelimiter : '');
					}
				}
				proposal.IPs__c =  szIPs.right(szDelimiter.length()) == szDelimiter ? szIPs.Substring(0,szIPs.length()-szDelimiter.length()).trim() : szIPs.trim();        
				
				//Added PS : 07102014     
				if(mapMasterPackagingOptions != null && mapMasterPackagingOptions.containsKey(proposal.ID)){  
					Proposal.Process_Technology__c = mapMasterPackagingOptions.get(proposal.ID).Apttus_Proposal__Product__r.PT_Number__c;
					// Added AR : 08202014 (For reporting purpose) - Start 
					ptNumSet.add(proposal.Process_Technology__c);             
					// End
					Proposal.Gate_Orientation_PFET__c = (mapMasterPackagingOptions.get(proposal.ID).Gate_Orientation_Horizontal_Vertical__c == TRUE)?
						'Horizontal & Vertical': Proposal.Gate_Orientation_PFET__c == 'Horizontal & Vertical' ? '':Proposal.Gate_Orientation_PFET__c;     
					for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal_Line_Item__c.fieldSets.Packaging_Options.getFields()) {
						if(mapMasterPackagingOptions != null && mapMasterPackagingOptions.containsKey(proposal.ID)){                   
							if(mapMasterPackagingOptions.get(proposal.ID).get(f.getFieldPath()) == NULL){
								proposal.put(f.getFieldPath(), 'Not Applicable');
							}
							else{
								proposal.put(f.getFieldPath(),mapMasterPackagingOptions.get(proposal.ID).get(f.getFieldPath())) ;
							}
						}
					}
				}
				//Proposal.get
				
				//fetch the Additional Questions field API names and populate the same with TRUE
				for(String szAQ : mapProposalWithAdditionalQuestions.get(proposal.Id)){
					proposal.put(mapMasterAdditionalQuestions.get(szAQ), True);

				}
				
			}

			// Added AR : 08202014 (For reporting purpose) - Start 
			Map<String,String> ptNumProcessTechMap = new Map<String,String>(); 
			for(Process_Technology__c pt : [select    Id 
													  , PT_Number__c                                               
											from      Process_Technology__c 
											where     PT_Number__c in :ptNumSet  
										   ]){ 
				ptNumProcessTechMap.put(pt.PT_Number__c, pt.id); 
			} 
				  
			for(Apttus_Proposal__Proposal__c proposal : lstProposals){ 
				if(!ptNumProcessTechMap.isEmpty() && ptNumProcessTechMap.containsKey(proposal.Process_Technology__c)){ 
					proposal.Process_Technology_Lookup__c = ptNumProcessTechMap.get(proposal.Process_Technology__c); 
				} 
			} 
			// End

			//update proposals with populated mask set
			if(lstProposals.size() > 0){
				update lstProposals;
			}
		}
    }
}