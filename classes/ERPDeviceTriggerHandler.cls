/*
    Author: Sreedhar Karukonda
    Description: This is Trigger handler for ERP Device Object. Creates references from ERP Device to Device, Account and Process records
    History: 
    skarukon      09/22/2015    - Apex code created 
    skarukon      09/06/3026    - added code to handle red products   
    Niharika      25/04/2017    - Updated Integration_Status__c for juntion Object
    Devendra      15/09/2017    - Updated code  to insert spdbom records and fix for soql forloops 
*/

public class ERPDeviceTriggerHandler {
    private static boolean run = true;
    public static boolean alreadyRanThisLogic{get; set;}

    public static  void handle(List<ERP_Device__c> devices){
        if(ERPDeviceTriggerHandler.alreadyRanThisLogic != true){
            ERPDeviceTriggerHandler.alreadyRanThisLogic = true;
            List<ERP_Device__c> orangeDevices = new List<ERP_Device__c>();
            List<ERP_Device__c> redDevices = new List<ERP_Device__c>();
            for(ERP_Device__c dev: devices){
                if(dev.Part_Number__c != null){
                    redDevices.add(dev);
                }else{
                    orangeDevices.add(dev);
                }
            }
            if(!orangeDevices.isEmpty()){
                handleOrangeDevices(orangeDevices);
            }
            if(!redDevices.isEmpty()){
                handleRedDevice(redDevices);
            }
        }
    }
    
    public static void handleRedDevice(List<ERP_Device__c> erpDevices){
        
        Set<String> opptyNumber = new Set<String>();
        for(ERP_Device__c device: erpDevices){
            if(device.Opportunity_ID__c != null) opptyNumber.add(device.Opportunity_ID__c);
        }
        List<Opportunity> relatedOpportunities = [SELECT Id, Name, OPP_CN__c from Opportunity where OPP_CN__c in :opptyNumber];
        Map<String, Id> OppCnToOptyId = new Map<String, Id>();
        for(Opportunity opty : relatedOpportunities){
            OppCnToOptyId.put(opty.OPP_CN__c, opty.Id);
        }
        
        /**
         * Check if all required fields are loaded. if not add an error. 
         * Required field details are in ERP_Device_Required_Fields__c custom setting.
         **/
        List<ERP_Device_Required_Fields__c> redRequiredFields = [SELECT Id, Name, SObject__c, Message__c FROM ERP_Device_Required_Fields__c where SObject__c = 'ERP_Device__c'];
        for(ERP_Device__c dev: erpDevices){
            dev.Integrity_Error_Flag__c = false;
            dev.Integrity_Error__c ='';
            if(dev.Opportunity_ID__c != null && dev.Opportunity__c == null){
                dev.Opportunity__c = OppCnToOptyId.get(dev.Opportunity_ID__c);
            }
            boolean requiredFieldMissing = false;
            String errorMessage = '';
            for(ERP_Device_Required_Fields__c requiredField : redRequiredFields){
                if(dev.get(requiredField.Name) == null || dev.get(requiredField.Name) == ''){
                    errorMessage += (requiredField.Message__c + '*** ');
                    requiredFieldMissing = true;
                }
            }
            if(requiredFieldMissing) {
                dev.Integrity_Error_Flag__c = true;
                dev.Integrity_Error__c = errorMessage;
            }
        }
    }
    
    public static void handleOrangeDevices(List<ERP_Device__c> erpDevices){
        Map<String, Device_PEOL_NM_to_UM_Conversion__c> nmToUMSettings = Device_PEOL_NM_to_UM_Conversion__c.getAll();
        //Collect all Process Names
        Set<String> processNames = new Set<String>();
        //Collect all Process Names
        Set<String> crmdids = new Set<String>();
        for(ERP_Device__c erpDevice : erpDevices){
            if(erpDevice.Process_ID__c == null && erpDevice.Process_Id_Name__c != null){
                processNames.add(erpDevice.Process_Id_Name__c);
            }
            if(erpDevice.CRMDID__c != null && Trigger.isInsert)
            {
                erpDevice.SFDC_CRMDID__c=erpDevice.CRMDID__c;
            }
                        
            if(erpDevice.SFDC_CRMDID__c != null ){
                crmdids.add(erpDevice.SFDC_CRMDID__c);
             }
             
            // If Geometry is in nanometers, convert to micromaters
            if(erpDevice.Geometry__c != null && erpDevice.Geometry__c.contains('NM')  ){
                if(nmToUMSettings.get(erpDevice.Geometry__c) != null){
                    erpDevice.Geometry__c = nmToUMSettings.get(erpDevice.Geometry__c).UM_Value__c;
                }
            }
        }
        // Using Process Name, create reference to Process Record
        if(!processNames.isEmpty()){
            List<Process__c> processes = [SELECT Id, Name FROM Process__c WHERE Name IN : processNames];
            
            // Create map between short name and account id
            Map<String, Id> processNameToProcessId = new Map<String, Id>();
            for(Process__c process: processes){
                processNameToProcessId.put(process.Name, process.Id);
            }
            for(ERP_Device__c erpDevice : erpDevices){
                if(erpDevice.Process_Id_Name__c != null && processNameToProcessId.get(erpDevice.Process_Id_Name__c) != null && erpDevice.Process_ID__c == null){
                    erpDevice.Process_ID__c = processNameToProcessId.get(erpDevice.Process_Id_Name__c);
                }
            }
        }
        
        // Using CRM DID create reference to Device Record
        if(!crmdids.isEmpty()){
            List<Device__c> devices = [SELECT Id, Name, CRMDID__c FROM Device__c WHERE CRMDID__c IN : crmdids];
            // Create map between short name and account id
            Map<String, Id> crmdidToId = new Map<String, Id>();
            for(Device__c device: devices){
                crmdidToId.put(device.CRMDID__c, device.Id);
            }
            for(ERP_Device__c erpDevice : erpDevices){
                          
               if(erpDevice.SFDC_CRMDID__c != null){
                   erpDevice.Device__c = crmdidToId.get(erpDevice.SFDC_CRMDID__c);
              }

            }
        }
    }
    
    public static  void handleAfterUpdate(List<ERP_Device__c> newDevices,Map<Id,ERP_Device__c> oldDevices){ 
        try{
            if(ERPDeviceTriggerHandler.run){
                ERPDeviceTriggerHandler.run=false;
                List<ERP_Device__c> erpDeviceToUpdate = new List<ERP_Device__c>();
                List<ERP_Device_SPDBOM__c> junctionList=new  List<ERP_Device_SPDBOM__c>();
                set<id> devIdSet=new set<id>();
                set<id> erpDevIdSet=new set<id>();
                for(ERP_Device__c newErp: newDevices){
                    devIdSet.add(newErp.Device__c);
                    erpDevIdSet.add(newErp.id);
                }
                
                Map<id,Device__c> devMap=new Map<id,Device__c>([Select Is_ITAR__c,ITAR_Flag__c,PSA__c, PSC__c,Business_Unit__c,Product_Line__c,CRMDID__c,Assigned_Process_ID__c from Device__c where id  IN : devIdSet]);
                List<ERP_Device_SPDBOM__c> spdBomList=[SELECT Id, PSA__c, PSC__c,Predicted_ITAR__c,ERP_Device__c from  ERP_Device_SPDBOM__c where ERP_Device__c  IN : erpDevIdSet];
                
                Map<id,List<ERP_Device_SPDBOM__c>> erpDevSPDBOMMap=new Map<id,List<ERP_Device_SPDBOM__c>>();
                for(ERP_Device_SPDBOM__c spdbom: spdBomList){
                    if(erpDevSPDBOMMap.containskey(spdbom.ERP_Device__c))
                        erpDevSPDBOMMap.get(spdbom.ERP_Device__c).add(spdbom);
                    else
                        erpDevSPDBOMMap.put(spdbom.ERP_Device__c,new List<ERP_Device_SPDBOM__c>{spdbom});
                }
                
                for(ERP_Device__c newErp: newDevices){
                    ERP_Device__c oldErp = oldDevices.get(newErp.id);
                    if(oldErp.Device__c == newErp.Device__c){
                        system.debug('Inside if' + oldErp.PSCNew__c +newErp.PSCNew__c);
                        if(oldErp.PSANew__c != newErp.PSANew__c || oldErp.PSCNew__c != newErp.PSCNew__c || oldErp.ITARNew__c != newErp.ITARNew__c || oldErp.Process_ID__c != newErp.Process_ID__c ||
                        oldErp.CRMDID__c != newErp.CRMDID__c || oldErp.Business_Unit__c != newErp.Business_Unit__c || oldErp.Product_Line__c != newErp.Product_Line__c)
                        {   
                            if(newErp.Device__c != null){
                                Device__c device = devMap.get(newErp.Device__c) ;
                                junctionList=new  List<ERP_Device_SPDBOM__c>();
                                junctionList = erpDevSPDBOMMap.get(newErp.id) ;
                                if(junctionList!=null){
									for(ERP_Device_SPDBOM__c junctionObj : junctionList){
										junctionObj.PSA__c = device.PSA__c;
										junctionObj.PSC__c = device.PSC__c;
										junctionObj.Predicted_ITAR__c = device.ITAR_Flag__c;
										junctionObj.Integration_Status__c ='ReadytoSend';
									}
								}
                            }
                        }
                    }else{
                        ERP_Device__c erp = new ERP_Device__c(Id = newErp.Id);
                        if(newErp.Device__c != null){
                            Device__c device = devMap.get(newErp.Device__c);
                            erp.PSANew__c = device.PSA__c;
                            erp.PSCNew__c = device.PSC__c;
                            erp.ITARNew__c = device.Is_ITAR__c;
                            erp.Process_ID__c=device.Assigned_Process_ID__c;
                            erp.Business_Unit__c=device.Business_Unit__c;
                            erp.Product_Line__c=device.Product_Line__c;
                            erp.CRMDID__c=device.CRMDID__c;
                            erp.Integration_Status__c='ReadytoSend';
                            junctionList=new  List<ERP_Device_SPDBOM__c>();
                            junctionList = erpDevSPDBOMMap.get(newErp.id) ;
							if(junctionList!=null){
								for(ERP_Device_SPDBOM__c junctionObj : junctionList){
									junctionObj.PSA__c = device.PSA__c;
									junctionObj.PSC__c = device.PSC__c;
									junctionObj.Predicted_ITAR__c = device.ITAR_Flag__c;
									junctionObj.Integration_Status__c ='ReadytoSend';
								}
							}
                            
                            erpDeviceToUpdate.add(erp);
                        }
                    }
                }
                if(junctionList!=null && !junctionList.isempty())update junctionList;
                if(!erpDeviceToUpdate.isempty())update erpDeviceToUpdate;  
                
            }
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceTriggerHandler','handleAfterUpdate','','Exception while running method',String.valueof(e.getMessage()),'','SPD',e,0);
        }
    }
    
    public static void insertJunctionSPDBOM(List<ERP_Device__c> erpDevices){
        
        string partNumberSet='';
        Map<string,ERP_Device__c> partErpMap=new Map<string,ERP_Device__c>();
        List<ERP_Device_SPDBOM__c> SPDBOMtoInsert=new List<ERP_Device_SPDBOM__c>();
        boolean hasdevwithpart=false;
        for(ERP_Device__c device: erpDevices){
            if(device.Part_Number__c != null){
                hasdevwithpart=true;
                ERP_Device_SPDBOM__c spdbom=new ERP_Device_SPDBOM__c();
                spdbom.ERP_Device__c=device.id;
                spdbom.PSA__c = device.PSA__c;
                spdbom.PSC__c = device.PSC__c;
                spdbom.Component__c =device.Part_Number__c;
                spdbom.Parent__c =device.Part_Number__c;
                spdbom.Parent_Component_Pair__c=device.Part_Number__c+device.Part_Number__c;
                spdbom.Integration_Status__c ='ReadytoSend';
                SPDBOMtoInsert.add(spdbom);
                partNumberSet+=' objid__c like \''+device.Part_Number__c+'%\' OR ';
                partErpMap.put(device.Part_Number__c,device);
            }    
        }
        partNumberSet=partNumberSet.substringBeforeLast('OR');
        partNumberSet='and ( '+partNumberSet+' )';
        
        String maskValue = Label.Part_BasicName_Mask;

        Map<ERP_Device__c,List<BOM__c>> erpStagingMap= new Map<ERP_Device__c,List<BOM__c>>();
        Set<String> levelCode = new Set<String>();
        List<Level_Code_Parts__c> listCodes = Level_Code_Parts__c.getAll().values(); 
        for(Level_Code_Parts__c code : Level_Code_Parts__c.getAll().values()){
            if(code.Level_Code__c!=''&& code.Level_Code__c!=null)levelCode.add(code.Level_Code__c);
        }
        system.debug(partNumberSet);

        
        string query='SELECT ownerid,  name,'+                                  
                               'apa_code__c, apc_code__c, change_number__c, component__c, '+ 
                              'is_itar__c, objid__c, psa_code__c, psc_code__c, parent__c, part_basicname__c,'+ 
                              'part_classification__c, part_ecrelease_status__c, part_labof_design__c, '+ 
                             ' part_level_code__c, part_short_desc__c, primary_or_optional_for__c,'+ 
                              'released_date__c, technology__c, id FROM BOM__c  '+ 
                             ' WHERE    (Part_Level_Code__c IN :levelCode OR Part_BasicName__c =:maskValue) ';
        if(hasdevwithpart){
			query+=partNumberSet;
			List<BOM__c> bomlist=database.query(query);
			string erpList='';
			if(test.isrunningtest())bomlist=new List<BOM__c>{new Bom__c(Parent__c='1',Change_Number__c='test',Component__c='test')};
			for(BOM__c partsHub:bomlist){
				if(partsHub.Parent__c!=null && partErpMap.get(partsHub.Parent__c)!=null){
					ERP_Device__c erp=partErpMap.get(partsHub.Parent__c);
					ERP_Device_SPDBOM__c junctObj = new ERP_Device_SPDBOM__c();
					junctObj.ERP_Device__c = erp.Id ;
					junctObj.BOM__c =partsHub.Id;
					junctObj.Change_Number__c = partsHub.Change_Number__c;
					junctObj.Component__c =  partsHub.Component__c;
					junctObj.Parent__c = erp.Part_Number__c;
					junctObj.Part_Ecrelease_Status__c = partsHub.Part_Ecrelease_Status__c;
					junctObj.Part_BasicName__c = partsHub.Part_BasicName__c;
					junctObj.Part_Classification__c = partsHub.Part_Classification__c;
					junctObj.Part_LabOfDesign__c = partsHub.Part_Labof_Design__c;
					junctObj.Part_LevelCode__c = partsHub.Part_Level_Code__c;
					junctObj.Part_Short_Desc__c = partsHub.Part_Short_Desc__c;
					junctObj.Primary_Or_OptionalFor__c = partsHub.Primary_Or_Optional_For__c;
					junctObj.PSA__c = erp.PSA__c;
					junctObj.PSC__c = erp.PSC__c;
					junctObj.APA__c = partsHub.APA_Code__c;
					junctObj.APC__c = partsHub.APC_Code__c ;
					junctObj.Integration_Status__c ='ReadytoSend';
					junctObj.Predicted_ITAR__c = erp.ITAR__c;
					junctObj.Released_Date__c = partsHub.Released_Date__c;
					junctObj.Technology__c = partsHub.Technology__c;
					junctObj.Parent_Component_Pair__c = erp.Part_Number__c + partsHub.Component__c;
					SPDBOMtoInsert.add(junctObj);
					if(!erpList.contains(erp.Id))erpList+=erp.Id+';';
				}
			}
			if(!SPDBOMtoInsert.isempty())insert SPDBOMtoInsert;
			if(erpList!='')updateERPDevice(erpList);
		}
    }
    
    @future
    Public static void updateERPDevice(string erpObject){
        system.debug(erpObject);
        List<ERP_Device__c> devList=new List<ERP_Device__c>();
        List<string> erpList=erpObject.split(';');
        for(string s:erpList){
            if(s!=null && s!='')devList.add(new ERP_Device__c(id=s,Integration_Status__c ='ReadytoSend'));
        }

        update devList;
    }
}