/**
    Trigger Name:  ProcessTriggerUpdateBX041
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   1. Update BX041 status when process.Available_to_Sell__c is changed
                   2. Update process_information whose question is 'lifecycle' when process.Available_to_Sell__c is changed
    History: 
      PS           07032013    - Code creation.
      TL           07022013    - Code Modification.
      TL           07112013 SGT    - Code Modification :As baij requested, refresh the content of process info based on changes on PID(Available to Sell)
      PS           11222013    - Code Modification. Requirement change:
                                 
                                 if(ATTRIBUTE READINESS CALCULATED is changed from Suspended to any other value){
                                    if("available to sell" = Registered TBO)    then BX041status should set to Registered/TBO Assigned PID
                                    else if( "available to sell" = Available or Prototype Ready or MPW ready
                                            and GAP is closed)  then BX041status should set to Closed
                                    else if( "available to sell" = Available or Prototype Ready or MPW ready
                                            and GAP is NOT closed)  then BX041status should set to pending GAP Clouser
                                    }
                                 else{
                                     if ("available to sell" value changed from Registered TBO to (Available or Prototype Ready or MPW ready)){
                                         if(GAP is closed)   then BX041status should set to Closed
                                         else                BX041status should set to pending GAP Clouser
                                     }
                                 }
     VM             03312015    added the functionality to update the Non DE-IP Internal Device Tapeout Readiness whenever the Process 'Available to Sell' field value
                                is set to 'Available'/'MPW Redy'/'Prototype Ready'.
	Pradosh         04272017    Case-00070330, Changes for mapping Process Technology look up filed. 
**/
trigger ProcessTriggerUpdateBX041 on Process__c (after update, before insert, before update) {
    
    if(!IntegrationUserUtil.isSkipTrigger()){
    
		if(Trigger.isAfter && Trigger.isUpdate){
		  
			system.debug('Entering Trigger....');
			List<id> processIDs = new List<id>();
			Set<id> processIdSet = new Set<id>();// TL 07112013 SGT
			List<BX_041__c > bx041list = new List<BX_041__c >();
			Set<id> procIdSet4APID = new Set<id>();// TL 17012014 SGT process id set for updating assigned_process__c records 
			
			for(process__c process : trigger.new){
				
				//17/1/2104
				// when process.ATTRIBUTE_READINESS_CALCULATED__c is changed from Supended to other value or vice verse
				
				if(process.ATTRIBUTE_READINESS_CALCULATED__c != trigger.oldMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c){
					system.debug('ARC is changed....');
					if(process.ATTRIBUTE_READINESS_CALCULATED__c == 'Suspended' || trigger.oldMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c  == 'Suspended'){
						procIdSet4APID.add(process.id); 
						system.debug('ADD INTO SET...');
					}
				}else if(process.ATTRIBUTE_READINESS_CALCULATED__c != 'Suspended'){
					if(process.Available_to_Sell__c != trigger.oldmap.get(process.id).Available_to_Sell__c && isAvailbleChange(process.Available_to_Sell__c, trigger.oldmap.get(process.id).Available_to_Sell__c)){
						procIdSet4APID.add(process.id); 
					}
				}
				// TL 07112013 SGT  **start
				if(trigger.newmap.get(process.id).Available_to_Sell__c  != trigger.oldmap.get(process.id).Available_to_Sell__c ||
				   (trigger.oldMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c  == 'Suspended' && trigger.newMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c != 'Suspended')){
					processIdSet.add(process.id);
				}// TL 07112013 SGT  **end
				if((trigger.oldMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c  == 'Suspended' && trigger.newMap.get(process.id).ATTRIBUTE_READINESS_CALCULATED__c != 'Suspended')
				   || (trigger.oldMap.get(process.id).Available_to_Sell__c == 'Registered/TBO' && trigger.newMap.get(process.id).Available_to_Sell__c != 'Registered/TBO')){
					processIDs.add(process.id);    
				}  
			}
			//Prosenjit 11222013
			IF(!processIDs.isEmpty()){
				for(BX_041__c bx041: [SELECT    id,
												name,
												BX_041_Status__c,
												GAP_Closed__c ,
												Assigned_Process_ID__c
									  FROM      BX_041__c 
									  WHERE     Assigned_Process_ID__c 
									  IN        :processIDs
									  AND       (BX_041_Status__c = 'Registered/TBO PID Assigned' OR 
												 BX_041_Status__c = 'Suspended PID Assigned')]){
												  
					if( trigger.oldMap.get(bx041.Assigned_Process_ID__c).ATTRIBUTE_READINESS_CALCULATED__c  == 'Suspended' 
						&& trigger.newMap.get(bx041.Assigned_Process_ID__c).ATTRIBUTE_READINESS_CALCULATED__c != 'Suspended' ){
						if(trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Registered/TBO'){
							bx041.BX_041_Status__c = 'Registered/TBO PID Assigned';    
							bx041list.add(bx041);
						}  
						else{ 
							if( trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'MPW Ready'
								||trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Prototype Ready'
								||trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Available'){
									if(bx041.GAP_Closed__c == true){
										bx041.BX_041_Status__c = 'Closed'; 
									}
									else {
										bx041.BX_041_Status__c = 'Pending Gap Closure';   
									}   
								bx041list.add(bx041); 
							} 
						} 
					}
					else if(trigger.oldMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Registered/TBO' 
							&& (trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'MPW Ready'
								||trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Prototype Ready'
								||trigger.newMap.get(bx041.Assigned_Process_ID__c).Available_to_Sell__c == 'Available')){
									if(bx041.GAP_Closed__c == true){
										bx041.BX_041_Status__c = 'Closed'; 
									}
									else {
										bx041.BX_041_Status__c = 'Pending Gap Closure';   
									}   
									bx041list.add(bx041); 
					}
				}
				
				//added by Vijay 03312015:- for Non DE-IP Internal Device,  Process Id can be directly assigned on Device. So whenever the Process Id is updated to 
				//                          'Available'/'MPW Redy'/'Prototype Ready', the Device Tapeout Readiness should be updated.
				List<Device__c> deviceList =[SELECT     Id 
											 FROM       Device__c 
											 WHERE      Assigned_Process_ID__c =:processIDs AND (RecordType.DeveloperName = 'Internal_Device' OR 
														RecordType.DeveloperName ='Internal_Device_Read_Only') AND Account__r.Sub_Type__c != 'DE - IP'];
														
				
				try{
					if(bx041list.size()>0){
						update bx041list;
					}
					if(deviceList != null && !deviceList.isEmpty()){
						update deviceList;
					}
				}catch(exception e){
					System.debug(LoggingLevel.Error, e.getMessage());
				}
			}
			   
			// TL 07112013 SGT -- update 'lifecycle' for FE and PIYE column in Process Information Section of CDRS
			if(!processIdSet.isEmpty()){
				list<process_information__c> piList = new list<process_information__c>();
				for(process_information__c pi : [select id,
														FE_Requested_information__c,
														PIYE__c,
														BX_041__r.Assigned_Process_Id__c,
														BX_041__r.Requested_Process_Id__c
												  from Process_Information__c
												  Where question_metadata__r.Process_field_API_name__c = 'AVAILABLE_TO_SELL__c'
													and (BX_041__r.Assigned_Process_Id__c in :processIdSet or BX_041__r.Requested_Process_Id__c in :processIdSet) 
												]){
					if(processIdSet.contains(pi.BX_041__r.Assigned_Process_Id__c)){
						pi.PIYE__c = trigger.newmap.get(pi.BX_041__r.Assigned_Process_Id__c).Available_to_Sell__c;
					} 
					if(processIdSet.contains(pi.BX_041__r.Requested_Process_Id__c)){
						pi.FE_Requested_information__c = trigger.newmap.get(pi.BX_041__r.Requested_Process_Id__c).Available_to_Sell__c;
					} 
					piList.add(pi);                           
				} 
				system.debug('ProcessTriggerUpdateBX041...' + procIdSet4APID.size());
									 
				if(piList.size()>0){
					update piList; 
				}
				
			}
			
			if(procIdSet4APID.size()>0){
				UpdateAssigneProcessBatch processBatch = new UpdateAssigneProcessBatch();
				string queryString = 'SELECT Id FROM assigned_process__c WHERE process__c IN :XXX and Primary_Process__c = false and (device__r.Stage__c = \'Design In\' or device__r.Stage__c = \'Tapeout\')';  //CDRS query string for the batch class. 
				//set variables of the batch class.
				processBatch.query = queryString.replace('XXX', 'procIdSet') ; 
				processBatch.procIdSet = procIdSet4APID; 
				Database.executeBatch(processBatch);   //executing batch
			}
		}
        else if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
      
			Set<String> processTechnologySet = new Set<String>();
			List<Process_Technology__c> processTechnologyList = new List<Process_Technology__c>();
			Map<String, Process_Technology__c> processTechnologyMap = new Map<String, Process_Technology__c>();

			if(Trigger.isInsert){

				for(Process__c process : Trigger.new){
					if(process.Process_Technology__c != NULL){
						processTechnologySet.add(process.Process_Technology__c);
					}
				}

				processTechnologyList = [SELECT Id, Name, PT_Number__c FROM Process_Technology__c WHERE PT_Number__c IN :processTechnologySet];

				processTechnologyMap = new Map<String, Process_Technology__c>();

				for(Process_Technology__c processTechnology : processTechnologyList){
					processTechnologyMap.put(processTechnology.PT_Number__c, processTechnology);
				}

				for(Process__c process : Trigger.new){
					if(process.Process_Technology__c != NULL && processTechnologyMap.get(process.Process_Technology__c) != NULL){
						process.ProcessTechnology__c = processTechnologyMap.get(process.Process_Technology__c).Id;
					}
					else{
						process.ProcessTechnology__c = NULL;
					}
				}
			}
			else if(Trigger.isUpdate){

				for(Process__c process : Trigger.new){
					if(Trigger.oldMap.get(process.Id).Process_Technology__c != process.Process_Technology__c && process.Process_Technology__c != NULL){
						processTechnologySet.add(process.Process_Technology__c);
					}
				}

				processTechnologyList = [SELECT Id, Name, PT_Number__c FROM Process_Technology__c WHERE PT_Number__c IN :processTechnologySet];

				processTechnologyMap = new Map<String, Process_Technology__c>();

				for(Process_Technology__c processTechnology : processTechnologyList){
					processTechnologyMap.put(processTechnology.PT_Number__c, processTechnology);
				}

				for(Process__c process : Trigger.new){
					if(Trigger.oldMap.get(process.Id).Process_Technology__c != process.Process_Technology__c){
						if(process.Process_Technology__c == NULL){
							process.ProcessTechnology__c = NULL;
						}
						else if(processTechnologyMap.get(process.Process_Technology__c) != NULL){
							process.ProcessTechnology__c = processTechnologyMap.get(process.Process_Technology__c).Id;
						}
						else{
							process.ProcessTechnology__c = NULL;
						}
					}
				}
			}
		}
    }  
	
	private boolean isAvailbleChange(String newVal, String oldVal){// In the field assigned_process__c.PID_Status__c, it takes the following 4 values in process__c.Available_to_Sell__c as the same condition 'Available'
        if((newVal == 'Registered/TBO' || newVal == 'Available' || newVal == 'MPW Ready' || newVal == 'Prototype Ready')
            && 
            (oldVal == 'Registered/TBO' || oldVal == 'Available' || oldVal == 'MPW Ready' || oldVal == 'Prototype Ready')
        ){
            return false;
        }else {
            return true;
        }
    }
}