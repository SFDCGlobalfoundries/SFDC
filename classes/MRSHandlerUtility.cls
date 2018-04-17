/**
Type Name: MRSHandlerUtility
Author: Cognizant 
Created Date: 31-March-2014
Reason: This is a general utility class used for all generic functionalities of MRS. 
Change History:
Cognizant  -  29042014  -  Method added is addingPTRFToMRS
Cognizant  -  01052014  -  Modified for adding condition for MEBES Jobviews
Cognizant  -  28082014  -  UAT Defect Fixing.
Cognizant  -  09092014  -  POST GO LIVE SANITY TESTING  DEFECT FIX (Customer MEBES mail is sent to FE along with  Customer)
Cognizant  -  11092014  -  TASK-1955 has been corrected.
Cognizant  -  15102014  -  TASK-2154 has been fixed.
Cognizant  -  20102014  -  Code modified for TASK-2132/TASK-2140. 
Cognizant  -  22102014  -  TASK-2141 has been fixed.
Cognizant  -  27102014  -  Code added/modified for TASK-2130
Cognizant  -  28102014  -  TASK-2176 has been fixed.
Cognizant  -  13112014  -  Code modified for Internal Sanity Testing Fix.  
Cognizant  -  18112014  -  Added method: executeUpdateMCLAFuture.
Cognizant  -  24112014  -  Code modified for Task-1818 
Cognizant  -  28112014  -  Code added/modified for TASK-2132/TASK-2140
Cognizant  -  01122014  -  Code added/modified for TASK-2207
Cognizant  -  08122014  -  Code added/modified for TASK-2314
Cognizant  -  23032015  -  Code changed for Email Configuration Phase 2
*/
public class MRSHandlerUtility {
   
    public static Map < String, EmailTemplate > mapEmailTemplateAndName;
    public static Map < Id, Set < Id >> groupIduserIdMap;
    public static List < User > userlist;
    public static Map < Id, Group > lstgroupMap;
    public static OrgWideEmailAddress orgWideAddr;
    public static set < String > setLayersInPTRFButNotInDRT;
    public static map < String, set < String >> mapDRTLayerToChipNames; //TASK-2132/TASK-2140
    public static set < String > setLayersToBeCancelled; //TASK-2132/TASK-2140
    public static Integer numberOfLayerChipRecords;
    public static List < MRS_Layer_Chip_Association__c > listNew;
    public static map < Id, MRS_Layer_Chip_Association__c > mapOldLayerChips;
    public static String mrsId;
    public static String ptrfWithReleasedLayers = ''; //TASK-2207
    public static set < String > setPtrfWithReleasedLayers; //Email Config   

    /**
        This set of future and real-time methods adds the PTRF to MRS when PTRF reaches status of Perform Tapeout Options. 
        @method name: addingPTRFToMRSFuture/addingPTRFToMRS
        @parameter:   set of PTRF Ids which have reached status of Perform Tapeout Options.
        @return :     None.
     **/

    @future
    public static void addingPTRFToMRSFuture(set < String > setPTRFIds) {
        addingPTRFToMRS(setPTRFIds);
    }
    // create a log string
    // string will contain steps
    // - ptrf id
    // - check mask layer
    // - check chip detail
    // - delete mask layer
    // - delete chip detail
    // - add ptrf layer chip
    // - add drt layer chip
    // finish addingPTRFToMRS     
    public static void addingPTRFToMRS(set < String > setPTRFIds) {
        
        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_MRS_CREATION');
        if(null != env && env.value__c != 'ON') 
        {
            throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
            return;//safe-guard
        }
        //=======================================================
        
        /** Variable Declarations **/
        map < String, PTRF__c > mapPTRF = new map < String, PTRF__c > ();
        map < String, String > mapPTRFIdToShortName = new map < String, String > ();
        map < String, String > mapTAMJCKeyToGating = new map < String, String > ();
        map < String, String > mapTAMJCKeyToExcluded = new map < String, String > ();
        map < String, String > mapTAMJCKeyToLogic = new map < String, String > ();
        map < String, Double > mapKeyToTechGeoLessThan = new map < String, Double > ();
        map < String, Double > mapKeyToTechGeoLessThanEqual = new map < String, Double > ();
        map < String, Double > mapKeyToTechGeoGreaterThan = new map < String, Double > ();
        map < String, Double > mapKeyToTechGeoEqual = new map < String, Double > ();
        map < String, String > mapPTRFToMRSIds = new map < String, String > ();
        map < String, String > mapMRSToPTRFIds = new map < String, String > ();
        map < String, String > mapMSTIdsToNames = new map < String, String > ();
        map < String, String > mapDeviceIdsToNames = new map < String, String > ();
        map < String, List < PTRF_JobViewer_Info__c >> mapPTRFToJobviewerDetails = new map < String, List < PTRF_JobViewer_Info__c >> ();
        map < String, List < Chip_Detail__c >> mapPTRFToChipDetails = new map < String, List < Chip_Detail__c >> ();
        map < String, List < Mask_Layer__c >> mapPTRFToMaskLayers = new map < String, List < Mask_Layer__c >> ();
        map < String, Mask_Layer__c > mapKeyToMaskLayers = new map < String, Mask_Layer__c > ();
        map < String, Mask_Layer__c > mapKeyForDRTToMaskLayers = new map < String, Mask_Layer__c > ();
        map < String, MRS_Layer_Association__c > mapKeyToMRSLAs = new map < String, MRS_Layer_Association__c > ();
        map < String, MRS_Layer_Association__c > mapReleasedMRSIdToMRSLA = new map < String, MRS_Layer_Association__c > ();
        //TASK-1957
        map < String, MRS_Chip_Details__c > mapExistingMRSChipDetails = new map < String, MRS_Chip_Details__c > ();
        map < String, Set < String >> mapKeyToChipDetails = new map < String, Set < String >> ();
        map < String, List < MRS_Chip_Details__c >> mapMRSIdToMRSCDId = new map < String, List < MRS_Chip_Details__c >> ();
        map < String, List < MRS_Layer_Association__c >> mapMRSIdToMRSLAId = new map < String, List < MRS_Layer_Association__c >> ();
        map < String, String > mapUniqueKeyToPTRFIds = new map < String, String > ();
        map < String, String > mapPTRFIdsToUniqueKey = new map < String, String > ();
        map < String, String > mapMRSToMST = new map < String, String > ();
        map < String, String > mapMSTIdtoMRSId = new map < String, String > (); //TASK-2154
        map < String, MRS__c > mapMRSIdToMRS = new map < String, MRS__c > ();
        map < String, set < String >> mapPTRFIdToDRTChips = new map < String, set < String >> ();
        map < String, Boolean > mapPTRFIdsToGDSOUTCustomer = new map < String, Boolean > ();
        map < String, Boolean > mapPTRFIdsToGDSOUTFoundry = new map < String, Boolean > ();
        map < String, Boolean > mapPTRFIdsToFrameMockupCustomer = new map < String, Boolean > ();
        map < String, Boolean > mapPTRFIdsToFrameMockupFoundry = new map < String, Boolean > ();
        map < String, Boolean > mapPTRFIdsToMEBESCustomer = new map < String, Boolean > ();
        map < String, Boolean > mapPTRFIdsToMEBESFoundry = new map < String, Boolean > ();
        Set < String > setPTRFWithNoMRSIds = new Set < String > ();
        Set < String > setMRSIds = new Set < String > ();
        Set < String > setMSTIds = new Set < String > ();
        Set < String > setDeviceIds = new Set < String > ();
        Set < String > setPTRFWithReleasedLayerIds = new Set < String > ();
        Set < String > setExistingLayersPTRFIds = new Set < String > ();
        Set < String > setKeyToPLTP = new Set < String > ();
        Set < String > setTotalKeyPTRF = new Set < String > ();
        Set < String > setExistingLayerChips = new Set < String > ();
        list < MRS__c > lstNewMRS = new list < MRS__c > ();
        list < MRS_Chip_Details__c > lstNewMRSCD = new list < MRS_Chip_Details__c > ();
        setPtrfWithReleasedLayers = new Set < String > (); //Email Config
        //TASK-1957
        list < MRS_Chip_Details__c > lstMRSChipsExisting = new list < MRS_Chip_Details__c > ();
        list < MRS_Layer_Association__c > lstNewMRSLA = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Association__c > lstMRSLAUpdate = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Chip_Association__c > lstNewMRSLCA = new list < MRS_Layer_Chip_Association__c > ();
        Set < String > set1Fabs = New Set < String > {
            'Fab2', 'Fab3', 'Fab3E', 'Fab5', 'Fab6', 'Fab7'
        };
        Set < String > set2Fabs = New Set < String > {
            'Fab1', 'Fab8'
        };
        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setPTLP = new Set < String > {
            'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production'
        };
        Set < String > setOrderType = new Set < String > {
            'New Prototype', 'Retrofit'
        };

        /** Generating Map of PTRF Information from the set of PTRF Ids passed as parameter to this method **/
        if (setPTRFIds != null && setPTRFIds.size() > 0) {
            for (PTRF__c obj: [SELECT Customer_jobview__c, Customer__c, Device_Id__c, Device__c, DRC_DRW_Status__c, DRC_Only__c, DRC_Rerun__c, Fab__c,
            Foundry_Jobview__c, Frame_DRT__c, Frame_GDSOUT_Review__c, Frame_Mockup__c, Frame_Status__c, Frame_Tapeout__c,
            Id, MaskSetTitle__c, Maskshop__c, Mask_Set_Title_Name__c, Mask_Set_Title__c,
            Mask_Title_for_ROM_code__c, Name, Order_Type__c, OwnerId, Prime_DRT__c, Prime_GDSOUT_Review__c,
            Prime_Status__c, Prime_Tapeout__c, Process_Technology_Lifecycle_Phase__c, PTRF_DRC_Option__c,
            RecordTypeId, Recticle_Type__c, Status__c, SystemModstamp, Customer__r.Short_Name__c,
            Tapeout_Applications_MEBES_Jobview__c, Tech_Geo_Value__c, Tech_Geo__c, Customer__r.RecordType.Name
            FROM PTRF__c
            where Id IN: setPTRFIds]) {
                mapPTRF.put(obj.Id, obj);
                mapPTRFIdToShortName.put(obj.Id, obj.Customer__r.Short_Name__c);
                setMSTIds.add(obj.MaskSetTitle__c);
                ptrfWithReleasedLayers = obj.Name; //TASK-2207
                setPtrfWithReleasedLayers.add(obj.Name); //Email Config    
            }
        }
        if (mapPTRF != null && mapPTRF.size() > 0) {
            if (Test.isRunningTest()) {
                list < Tapeout_Applications_MEBES_Jobview_Confi__c > listTAMJC = new list < Tapeout_Applications_MEBES_Jobview_Confi__c > ();
                Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC2 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf', Process_Technology_Lifecycle_Phase__c = 'M5', PTRF_Customer_MEBES_Jobview__c = 'Not gating mask release;Not required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release', PTRF_Order_Type__c = 'Retrofit', PTRF_Technology__c = '0.20UM-0.28UM', Tapeout_Application_Jobview__c = 'Non gating', Logic_For_Calculation__c = 'OR');
                Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = null, Process_Technology_Lifecycle_Phase__c = null, PTRF_Customer_MEBES_Jobview__c = 'Gating mask release', PTRF_Foundry_MEBES_Jobview__c = 'Not gating mask release;Not required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '<= 0.020UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'AND');
                /*Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC2 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release',PTRF_Order_Type__c = 'Retrofit',PTRF_Technology__c = '0.20UM-0.28UM',Tapeout_Application_Jobview__c = 'Non gating',Logic_For_Calculation__c = 'OR');*/
                Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC3 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf', Process_Technology_Lifecycle_Phase__c = 'M5', PTRF_Customer_MEBES_Jobview__c = 'Not gating mask release;Not required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '0.06UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'OR');
                listTAMJC.add(objTAMJC);
                listTAMJC.add(objTAMJC2);
                listTAMJC.add(objTAMJC3);
                insert listTAMJC;
            }
            /** Fetching values from Tapeout Applications MEBES Jobview Config **/
            for (Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC: [select Id, Process_Technology_Lifecycle_Phase__c,
            PTRF_Customer_MEBES_Jobview__c, PTRF_Foundry_MEBES_Jobview__c, PTRF_Order_Type__c, PTRF_Technology__c, Logic_For_Calculation__c,
            Tapeout_Application_Jobview__c, Excluded_Customer__c from Tapeout_Applications_MEBES_Jobview_Confi__c LIMIT 1000]) {
                String ptrfCustMEBESJobview = '';
                String ptrfFdryMEBESJobview = '';
                String key;
                if (objTAMJC.PTRF_Customer_MEBES_Jobview__c != null) {
                    if (objTAMJC.PTRF_Customer_MEBES_Jobview__c.contains(';')) {
                        Integer ctr = 0;
                        for (String splitValues: objTAMJC.PTRF_Customer_MEBES_Jobview__c.split(';')) {
                            if (ctr == 0) {
                                ptrfCustMEBESJobview = 'CMJ' + splitValues;
                            } else {
                                ptrfCustMEBESJobview = ptrfCustMEBESJobview + ';CMJ' + splitValues;
                            }
                            ctr = ctr + 1;
                        }
                    } else {
                        ptrfCustMEBESJobview = 'CMJ' + objTAMJC.PTRF_Customer_MEBES_Jobview__c;
                    }
                }
                if (objTAMJC.PTRF_Foundry_MEBES_Jobview__c != null) {
                    if (objTAMJC.PTRF_Foundry_MEBES_Jobview__c.contains(';')) {
                        Integer ctr = 0;
                        for (String splitValues: objTAMJC.PTRF_Foundry_MEBES_Jobview__c.split(';')) {
                            if (ctr == 0) {
                                ptrfFdryMEBESJobview = 'FMJ' + splitValues;
                            } else {
                                ptrfFdryMEBESJobview = ptrfFdryMEBESJobview + ';FMJ' + splitValues;
                            }
                            ctr = ctr + 1;
                        }
                    } else {
                        ptrfFdryMEBESJobview = 'FMJ' + objTAMJC.PTRF_Foundry_MEBES_Jobview__c;
                    }
                }
                Double lessThanEqualValue;
                Double lessThanValue;
                Double greaterThanValue;
                Double equalValue;
                string[] stringArr;
                if (objTAMJC.PTRF_Technology__c.contains('<=') || objTAMJC.PTRF_Technology__c.contains('>=')) {
                    lessThanEqualValue = Double.valueOf(objTAMJC.PTRF_Technology__c.substring(2, objTAMJC.PTRF_Technology__c.indexOf('UM')));
                } else if (objTAMJC.PTRF_Technology__c.contains('-')) {
                    stringArr = objTAMJC.PTRF_Technology__c.split('-', 2);
                    lessThanValue = Double.valueOf(stringArr[0].substring(0, stringArr[0].indexOf('UM')));
                    greaterThanValue = Double.valueOf(stringArr[1].substring(0, stringArr[1].indexOf('UM')));
                } else {
                    equalValue = Double.valueOf(objTAMJC.PTRF_Technology__c.substring(0, objTAMJC.PTRF_Technology__c.indexOf('UM')));
                }
                if (objTAMJC.Process_Technology_Lifecycle_Phase__c != null) {
                    key = objTAMJC.Process_Technology_Lifecycle_Phase__c + ';' + ptrfCustMEBESJobview + ';' + ptrfFdryMEBESJobview + ';' + objTAMJC.PTRF_Order_Type__c + ';' + objTAMJC.PTRF_Technology__c;
                } else {
                    key = ptrfCustMEBESJobview + ';' + ptrfFdryMEBESJobview + ';' + objTAMJC.PTRF_Order_Type__c + ';' + objTAMJC.PTRF_Technology__c;
                }
                mapTAMJCKeyToGating.put(key, objTAMJC.Tapeout_Application_Jobview__c);
                if (objTAMJC.Excluded_Customer__c != null) {
                    mapTAMJCKeyToExcluded.put(key, objTAMJC.Excluded_Customer__c);
                }
                if (lessThanEqualValue != null) {
                    mapKeyToTechGeoLessThanEqual.put(key, lessThanEqualValue);
                } else if (equalValue != null) {
                    mapKeyToTechGeoEqual.put(key, equalValue);
                } else {
                    mapKeyToTechGeoLessThan.put(key, lessThanValue);
                    mapKeyToTechGeoGreaterThan.put(key, greaterThanValue);
                }
                if (objTAMJC.Process_Technology_Lifecycle_Phase__c != null) {
                    setKeyToPLTP.add(key);
                }
                if (objTAMJC.Logic_For_Calculation__c != null) {
                    mapTAMJCKeyToLogic.put(key, objTAMJC.Logic_For_Calculation__c);
                }
            }
            /** Fetching values from PTRF Jobviewer Info **/
            for (PTRF_JobViewer_Info__c objPTRFJI: [select Id, Jobview__c, Jobview_Type__c, PTRF__c, User__c from PTRF_JobViewer_Info__c where PTRF__c IN: mapPTRF.keySet()
            AND Jobview__c != null AND Jobview_Type__c != null]) {
                list < PTRF_JobViewer_Info__c > tempList = new list < PTRF_JobViewer_Info__c > ();
                String ptrfId = objPTRFJI.PTRF__c;
                if (mapPTRFIdsToGDSOUTCustomer.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('Prime GDSOUT Review') && !mapPTRFIdsToGDSOUTCustomer.get(ptrfId)) {
                        mapPTRFIdsToGDSOUTCustomer.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('Prime GDSOUT Review')) {
                        mapPTRFIdsToGDSOUTCustomer.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToGDSOUTCustomer.put(ptrfId, false);
                    }
                }
                if (mapPTRFIdsToGDSOUTFoundry.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('Prime GDSOUT Review') && !mapPTRFIdsToGDSOUTFoundry.get(ptrfId)) {
                        mapPTRFIdsToGDSOUTFoundry.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('Prime GDSOUT Review')) {
                        mapPTRFIdsToGDSOUTFoundry.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToGDSOUTFoundry.put(ptrfId, false);
                    }
                }
                if (mapPTRFIdsToFrameMockupCustomer.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('Frame Mockup') && !mapPTRFIdsToFrameMockupCustomer.get(ptrfId)) {
                        mapPTRFIdsToFrameMockupCustomer.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('Frame Mockup')) {
                        mapPTRFIdsToFrameMockupCustomer.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToFrameMockupCustomer.put(ptrfId, false);
                    }
                }
                if (mapPTRFIdsToFrameMockupFoundry.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('Frame Mockup') && !mapPTRFIdsToFrameMockupFoundry.get(ptrfId)) {
                        mapPTRFIdsToFrameMockupFoundry.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('Frame Mockup')) {
                        mapPTRFIdsToFrameMockupFoundry.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToFrameMockupFoundry.put(ptrfId, false);
                    }
                }
                if (mapPTRFIdsToMEBESCustomer.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('MEBES Jobview') && !mapPTRFIdsToMEBESCustomer.get(ptrfId)) {
                        mapPTRFIdsToMEBESCustomer.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Customer') && objPTRFJI.Jobview_Type__c.contains('MEBES Jobview')) {
                        mapPTRFIdsToMEBESCustomer.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToMEBESCustomer.put(ptrfId, false);
                    }
                }
                if (mapPTRFIdsToMEBESFoundry.containsKey(ptrfId)) {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('MEBES Jobview') && !mapPTRFIdsToMEBESFoundry.get(ptrfId)) {
                        mapPTRFIdsToMEBESFoundry.put(ptrfId, true);
                    }
                } else {
                    if ((objPTRFJI.Jobview__c == 'Foundry') && objPTRFJI.Jobview_Type__c.contains('MEBES Jobview')) {
                        mapPTRFIdsToMEBESFoundry.put(ptrfId, true);
                    } else {
                        mapPTRFIdsToMEBESFoundry.put(ptrfId, false);
                    }
                }

            }

            /** Populating Map of MST Ids to MST Names **/
            if (setMSTIds != null && setMSTIds.size() > 0) {
                for (Mask_Set_Title__c obj: [select Id, Name from Mask_Set_Title__c where Id IN: setMSTIds]) {
                    mapMSTIdsToNames.put(obj.Id, obj.Name);
                }
                //TASK-2154              
                for (MRS__c objMRS: [SELECT Id, Mask_Set_Title__c FROM MRS__c where Mask_Set_Title__c IN: setMSTIds]) {
                    if (!mapMSTIdtoMRSId.containsKey(objMRS.Mask_Set_Title__c)) {
                        mapMSTIdtoMRSId.put(objMRS.Mask_Set_Title__c, objMRS.Id);
                    }
                }
                //TASK-2154                  
            }
            //TASK-1957
            /**Checking for existing MRS Chip Details records per PTRF**/
            for (MRS_Chip_Details__c obj: [select Id, Name, PTRF_Id__c, MRS__c, DRT_Chip__c, DRT_Id__c from MRS_Chip_Details__c where PTRF_Id__c IN: mapPTRF.keySet()]) {
                mapExistingMRSChipDetails.put(obj.Name + obj.PTRF_Id__c, obj);
            }
            //TASK-1957          
            /** Fetching corresponding selected Chip Detail records **/
            
            //swgp-1075: default drw to n.a. for scribeline dropin
            //any layer chip that has chip record type = Scribeline_Dropins will be default drw to n.a.
            map<id,recordType> recList = new map<id,recordType>([select id from RecordType where sobjecttype='chip_detail__c' and developername = 'Scribeline_Dropins']);
            set<id> recSet = recList.keySet();
            set<string> chipNameSet = new set<string>();//this set stores scribeline droin, default drw to n.a.
            //swgp-1075......
            
            for (Chip_Detail__c obj: [select Id, PTRF__c, Name, Tapeout__c,recordtypeId from Chip_Detail__c where Tapeout__c = true and PTRF__c IN: mapPTRF.keySet()]) {
                list < Chip_Detail__c > tempList = new list < Chip_Detail__c > ();
                String ptrfId = obj.PTRF__c;
                if (mapPTRFToChipDetails != null) {
                    if (mapPTRFToChipDetails.containsKey(ptrfId)) {
                        tempList.addAll(mapPTRFToChipDetails.get(ptrfId));
                    }
                    tempList.add(obj);
                    mapPTRFToChipDetails.put(ptrfId, tempList);
                }
                
                if(recSet.contains(obj.recordTypeId)) chipNameSet.add(obj.Name);//swgp-1075: default drw to n.a. for scribeline dropin
            }
            
            //swgp-899
            map<string, mask_layer__c> mapTopUpLayer = new map<string, mask_layer__c>();
            
            /** Fetching corresponding selected Mask Layer records **/
            for (Mask_Layer__c obj: [select Id, PTRF__c, Name, Tapeout__c, Mask_Layer_Rev__c, ROM_Code__c, Mask_Layer_Number__c, PTRF__r.MaskSetTitle__c, PTRF__r.Tech_Geo_Value__c, /*Tech_Geo_Value__c*/
            PTRF__r.Tech_Geo__c, LogicalOperation__c, LogicalOperationType__c ,
            
            mask_layer_type__c//swgp-899: defaul NA for topup layer>>> fetch mask layer type to know is this a topup layer?
            
            from Mask_Layer__c where Tapeout__c = true and PTRF__c IN: mapPTRF.keySet()            
            ]) {
                
                //swgp-899: extract topup mask layer
                if(obj.mask_layer_type__c == 'TOPUPMASKLAYER') {
                    String key = obj.rom_code__c == null 
                        ? obj.ptrf__c + obj.Mask_Layer_Number__c + obj.mask_layer_rev__c 
                        : obj.ptrf__c + obj.Mask_Layer_Number__c + obj.mask_layer_rev__c + obj.rom_code__c;
                    
                    mapTopUpLayer.put(key, obj);
                }
                
                String uniqueKey;
                String keyForDRTs;
                String totalKeyPTRF;
                if (obj.ROM_Code__c != null && obj.ROM_Code__c != '') {
                    uniqueKey = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.ROM_Code__c + obj.PTRF__r.Tech_Geo_Value__c;
                    keyForDRTs = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.ROM_Code__c;
                    totalKeyPTRF = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.ROM_Code__c + obj.PTRF__r.Tech_Geo_Value__c + ':' + obj.PTRF__c;
                } else {
                    uniqueKey = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.PTRF__r.Tech_Geo_Value__c;
                    keyForDRTs = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c;
                    totalKeyPTRF = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.PTRF__r.Tech_Geo_Value__c + ':' + obj.PTRF__c;
                }
                mapKeyToMaskLayers.put(uniqueKey, obj);
                mapKeyForDRTToMaskLayers.put(keyForDRTs, obj);
                setTotalKeyPTRF.add(totalKeyPTRF);
                
            }
            
            /** Fetching corresponding DRT Chip Records **/
            mapPTRFIdToDRTChips.putAll(addingDRTChipsToMRS(mapPTRF, mapKeyForDRTToMaskLayers));
            
            /** Checking For Existing MRS Layer Association Records having the same MRS Layer Unique Identifier **/
            if (mapKeyToMaskLayers != null && mapKeyToMaskLayers.size() > 0) {
                for (MRS_Layer_Association__c objMRSLA: [Select Id, Name, MRS_Layer_Unique_Identifier__c, Layer_Unique_Identifier__c, Mask_Layer_Rev__c, ROM_Code__c, MRS__c, Layer_Status__c, LogicalOperation__c, LogicalOperationType__c,
                MRS__r.Mask_Set_Title__c, Tech_Geo__c, MRS__r.Mask_Set_Title__r.Name, Mask_Set_Title_Name__c, tech_geo_int__c              
                
                from MRS_Layer_Association__c where Layer_Unique_Identifier__c IN: mapKeyToMaskLayers.keySet()]) { //TASK-1879//Email Config                                    
                    mapKeyToMRSLAs.put(objMRSLA.MRS_Layer_Unique_Identifier__c, objMRSLA);
                    mapMRSToMST.put(objMRSLA.MRS__c, objMRSLA.MRS__r.Mask_Set_Title__c);
                    /** Appending TECN as per TASK-1818 and TASK-1838 **/
                    Mask_Layer__c objMaskLayer = mapKeyToMaskLayers.get(objMRSLA.MRS_Layer_Unique_Identifier__c);
                    if (((objMRSLA.LogicalOperationType__c == null) || (objMRSLA.LogicalOperationType__c == 'TECN')) && objMaskLayer.LogicalOperationType__c == 'TECN' && objMaskLayer.LogicalOperation__c != null) { //Code modified for Internal Sanity Testing on 13/11/2014.
                        if (objMRSLA.LogicalOperationType__c == null) { //Code modified for Internal Sanity Testing on 13/11/2014.
                            objMRSLA.LogicalOperationType__c = 'TECN'; //Code modified for Internal Sanity Testing on 13/11/2014.      
                        } //Code modified for Internal Sanity Testing on 13/11/2014.
                        if (objMRSLA.LogicalOperation__c != null) {
                            if (!objMRSLA.LogicalOperation__c.contains(objMaskLayer.LogicalOperation__c)) {
                                objMRSLA.LogicalOperation__c = objMRSLA.LogicalOperation__c + ';' + objMaskLayer.LogicalOperation__c;
                            }
                        } else {
                            objMRSLA.LogicalOperation__c = objMaskLayer.LogicalOperation__c;
                        }
                        lstMRSLAUpdate.add(objMRSLA);
                    }
                }
                if (lstMRSLAUpdate != null && lstMRSLAUpdate.size() > 0) {
                    try {
                        update lstMRSLAUpdate;

                    } catch (Exception ex) {
                        
                        // TASK-2130  START
                        saveMRSExceptionErrorLog(ex, 'MRS Layer Chip Association', '', 'MRSHandlerUtility', 'addingPTRFToMRS');
                        sendMRSExceptionLogMail(ex, setPTRFIds);
                        // TASK-2130  END
                    }
                }
                /** In case of presence of matching MRS Layer records, no MRS or MRS Layer Association record needs to be created **/
                Set < String > setTemp = new Set < String > ();
                for (String uniqueKey: mapKeyToMaskLayers.keySet()) {
                    String ptrfId = mapKeyToMaskLayers.get(uniqueKey).PTRF__c;
                    if (mapKeyToMRSLAs != null && mapKeyToMRSLAs.containsKey(uniqueKey)) {
                        if ((mapKeyToMRSLAs.get(uniqueKey).Layer_Status__c == 'Released') || (mapKeyToMRSLAs.get(uniqueKey).Layer_Status__c == 'Shipped')) {
                            mapReleasedMRSIdToMRSLA.put(mapKeyToMRSLAs.get(uniqueKey).Id, mapKeyToMRSLAs.get(uniqueKey));
                            setPTRFWithReleasedLayerIds.add(ptrfId);
                        } else {
                            mapUniqueKeyToPTRFIds.put(uniqueKey, ptrfId);
                            mapPTRFIdsToUniqueKey.put(ptrfId, uniqueKey);
                            setExistingLayersPTRFIds.add(ptrfId);
                            mapPTRFToMRSIds.put(ptrfId, mapKeyToMRSLAs.get(uniqueKey).MRS__c);
                            mapMRSToPTRFIds.put(mapKeyToMRSLAs.get(uniqueKey).MRS__c, ptrfId);
                        }
                    } else {
                        list < Mask_Layer__c > tempList = new list < Mask_Layer__c > ();
                        if (mapPTRFToMaskLayers != null) {
                            if (mapPTRFToMaskLayers.containsKey(ptrfId)) {
                                tempList.addAll(mapPTRFToMaskLayers.get(ptrfId));
                            }
                            tempList.add(mapKeyToMaskLayers.get(uniqueKey));
                            mapPTRFToMaskLayers.put(ptrfId, tempList);
                            setTemp.add(ptrfId);
                        }
                    }
                }
                if (setTemp.size() > 0) {
                    //TASK-2154                   

                    if (mapMSTIdtoMRSId.size() > 0) {
                        for (String ptrfId: setTemp) {
                            String maskSetTitleId = mapPTRF.get(ptrfId).MaskSetTitle__c;
                            if (mapMSTIdtoMRSId.containsKey(maskSetTitleId)) {
                                String strMRSId = mapMSTIdtoMRSId.get(maskSetTitleId);
                                mapPTRFToMRSIds.put(ptrfId, strMRSId);
                                setMRSIds.add(strMRSId);
                            } else {
                                setPTRFWithNoMRSIds.add(ptrfId);
                            }
                        }
                    } else {
                        setPTRFWithNoMRSIds.addAll(setTemp);
                    }
                    //TASK-2154   
                }
            }

            /** Creating and inserting new MRS records **/
            if (setPTRFWithNoMRSIds != null && setPTRFWithNoMRSIds.size() > 0) {
                for (String ptrfId: setPTRFWithNoMRSIds) {
                    MRS__c objMRS = new MRS__c();
                    objMRS.Mask_Set_Title__c = mapPTRF.get(ptrfId).MaskSetTitle__c;
                    objMRS.Associated_PTRF__c = ptrfId;
                    lstNewMRS.add(objMRS);
                }
                if (lstNewMRS != null && lstNewMRS.size() > 0) {
                    try {
                        insert lstNewMRS;

                    } catch (Exception ex) {
                        //SWGP-278
                        //catch error here and retry
                        logValidationError(json.serialize(setPTRFIds), 'Duplicate MRS: \n' + ex.getMessage(), '', 'MRSHandlerUtility', 'addingPTRFToMRSFuture', 'ERROR', '-', true, false);
                        return;

                    }
                    for (MRS__c obj: lstNewMRS) {
                        mapPTRFToMRSIds.put(obj.Associated_PTRF__c, obj.Id);
                        setMRSIds.add(obj.Id);
                        mapMRSIdToMRS.put(obj.Id, obj);
                        mapMRSToMST.put(obj.Id, obj.Mask_Set_Title__c);
                        mrsId = obj.Id;
                    }
                }
            }
            for (String ptrfId: mapPTRF.keySet()) {
                /** Creating Layer records in MRS Layer Association **/
                list < Mask_Layer__c > tempMLList = new list < Mask_Layer__c > ();
                if (mapPTRFToMaskLayers != null && mapPTRFToMaskLayers.containsKey(ptrfId)) {
                    tempMLList.addAll(mapPTRFToMaskLayers.get(ptrfId));
                    if (tempMLList != null && tempMLList.size() > 0) {
                        for (Mask_Layer__c obj: tempMLList) {
                            String layerUniqueIdentifier;
                            if (obj.ROM_Code__c != null && obj.ROM_Code__c != '') {
                                layerUniqueIdentifier = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.ROM_Code__c + obj.PTRF__r.Tech_Geo_Value__c /*Tech_Geo_Value__c*/;
                            } else {
                                layerUniqueIdentifier = obj.PTRF__r.MaskSetTitle__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c + obj.PTRF__r.Tech_Geo_Value__c /*Tech_Geo_Value__c*/;
                            }
                            MRS_Layer_Association__c objMRSLA = new MRS_Layer_Association__c();
                            if (obj.Mask_Layer_Number__c != null) {
                                objMRSLA.Name = obj.Mask_Layer_Number__c;
                            } else {
                                objMRSLA.Name = obj.Name;
                            }
                            objMRSLA.Layer_Name__c = obj.Name;
                            objMRSLA.MRS__c = mapPTRFToMRSIds.get(ptrfId);
                            objMRSLA.Mask_Layer_Rev__c = obj.Mask_Layer_Rev__c;
                            objMRSLA.ROM_Code__c = obj.ROM_Code__c;
                            objMRSLA.Tech_Geo__c = mapPTRF.get(ptrfId).Tech_Geo_Value__c /*Tech_Geo_Value__c*/;
                            objMRSLA.Reticle_Type__c = mapPTRF.get(ptrfId).Recticle_Type__c;
                            objMRSLA.Layer_Unique_Identifier__c = layerUniqueIdentifier;
                            if (obj.LogicalOperationType__c == 'TECN') {
                                objMRSLA.LogicalOperation__c = obj.LogicalOperation__c;
                                objMRSLA.LogicalOperationType__c = obj.LogicalOperationType__c;
                            }
                            
                            /** Generated Mask Title generation starts **/
                            PTRF__c objPTRF = mapPTRF.get(ptrfId);
                            if (objPTRF.Recticle_Type__c != null && objPTRF.Recticle_Type__c == 'Single Layer Reticle (SLR)') {
                                if (objPTRF.Fab__c != null && objPTRF.Fab__c != '') {
                                    if (set1Fabs.contains(objPTRF.Fab__c.trim())) {
                                        if (objPTRF.Mask_Title_for_ROM_code__c != null && objPTRF.Mask_Title_for_ROM_code__c != '') {
                                            if (obj.ROM_Code__c != null && obj.ROM_Code__c != '' && obj.ROM_Code__c != '####' && obj.ROM_Code__c.toUpperCase() != 'NULL') {
                                                objMRSLA.Generated_Mask_Title__c = objPTRF.Mask_Title_for_ROM_code__c + obj.ROM_Code__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c;
                                            } else {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + '-' + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c;
                                            }
                                        } else {
                                            if (obj.ROM_Code__c != null && obj.ROM_Code__c != '' && obj.ROM_Code__c != '####' && obj.ROM_Code__c.toUpperCase() != 'NULL') {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + obj.ROM_Code__c + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c;
                                            } else {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + '-' + obj.Mask_Layer_Number__c + obj.Mask_Layer_Rev__c;
                                            }
                                        }
                                    } else if (set2Fabs.contains(objPTRF.Fab__c.trim())) {
                                        String masklayerNumber = obj.Mask_Layer_Number__c;
                                        if (masklayerNumber.length() == 2) {
                                            masklayerNumber = '0' + masklayerNumber;
                                        }
                                        if (objPTRF.Mask_Title_for_ROM_code__c != null && objPTRF.Mask_Title_for_ROM_code__c != '') {
                                            if (obj.ROM_Code__c != null && obj.ROM_Code__c != '' && obj.ROM_Code__c != '####' && obj.ROM_Code__c.toUpperCase() != 'NULL') {
                                                objMRSLA.Generated_Mask_Title__c = objPTRF.Mask_Title_for_ROM_code__c + obj.ROM_Code__c + masklayerNumber + obj.Mask_Layer_Rev__c;
                                            } else {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + masklayerNumber + obj.Mask_Layer_Rev__c;
                                            }
                                        } else {
                                            if (obj.ROM_Code__c != null && obj.ROM_Code__c != '' && obj.ROM_Code__c != '####' && obj.ROM_Code__c.toUpperCase() != 'NULL') {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + obj.ROM_Code__c + masklayerNumber + obj.Mask_Layer_Rev__c;
                                            } else {
                                                objMRSLA.Generated_Mask_Title__c = mapMSTIdsToNames.get(objPTRF.MaskSetTitle__c) + masklayerNumber + obj.Mask_Layer_Rev__c;
                                            }

                                        }
                                    }
                                }
                            }
                            /** Generated Mask Title generation ends **/
                            lstNewMRSLA.add(objMRSLA);
                        }
                    }
                }
                /** Creating Frame Chip records in MRS Chip Details **/
                if (mapPTRF.get(ptrfId).Frame_Tapeout__c && !setPTRFWithReleasedLayerIds.contains(ptrfId)) {
                    //TASK-1957
                    String chipUniqueIdentifier = 'Frame' + ptrfId;
                    if (mapExistingMRSChipDetails.size() > 0 && mapExistingMRSChipDetails.containsKey(chipUniqueIdentifier)) {
                        lstMRSChipsExisting.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier));
                        setMRSIds.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier).MRS__c); //TASK-2081       
                    } else {
                        //TASK-1957
                        MRS_Chip_Details__c objMRSCD = new MRS_Chip_Details__c();
                        objMRSCD.Name = 'Frame';
                        objMRSCD.PTRF_Id__c = ptrfId;
                        if (setExistingLayersPTRFIds.size() > 0 && setExistingLayersPTRFIds.contains(ptrfId)) {
                            objMRSCD.MRS__c = mapKeyToMRSLAs.get(mapPTRFIdsToUniqueKey.get(ptrfId)).MRS__c;
                        } else {
                            objMRSCD.MRS__c = mapPTRFToMRSIds.get(ptrfId);
                        }
                        if (mrsId != null && objMRSCD.MRS__c == null) {
                            objMRSCD.MRS__c = mrsId;
                        }
                        lstNewMRSCD.add(objMRSCD);
                    }
                }
                /** Creating Prime Chip records in MRS Chip Details **/
                if (mapPTRF.get(ptrfId).Prime_Tapeout__c && !setPTRFWithReleasedLayerIds.contains(ptrfId)) {
                    list < Chip_Detail__c > tempList = new list < Chip_Detail__c > ();
                    if (mapPTRFToChipDetails != null && mapPTRFToChipDetails.containsKey(ptrfId)) {
                        tempList.addAll(mapPTRFToChipDetails.get(ptrfId));
                        if (tempList != null && tempList.size() > 0) {
                            for (Chip_Detail__c obj: tempList) {
                                //TASK-1957
                                String chipUniqueIdentifier = obj.Name + ptrfId;
                                if (mapExistingMRSChipDetails.size() > 0 && mapExistingMRSChipDetails.containsKey(chipUniqueIdentifier)) {
                                    lstMRSChipsExisting.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier));
                                    setMRSIds.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier).MRS__c); //TASK-2081       
                                } else {
                                    //TASK-1957  
                                    MRS_Chip_Details__c objMRSCD = new MRS_Chip_Details__c();
                                    objMRSCD.Name = obj.Name;
                                    objMRSCD.PTRF_Id__c = ptrfId;
                                    if (setExistingLayersPTRFIds.size() > 0 && setExistingLayersPTRFIds.contains(ptrfId)) {
                                        objMRSCD.MRS__c = mapKeyToMRSLAs.get(mapPTRFIdsToUniqueKey.get(ptrfId)).MRS__c;
                                    } else {
                                        objMRSCD.MRS__c = mapPTRFToMRSIds.get(ptrfId);
                                    }
                                    if (objMRSCD.MRS__c == null) {
                                        objMRSCD.MRS__c = mrsId;
                                    }
                                    lstNewMRSCD.add(objMRSCD);
                                }
                            }
                        }
                    }

                }
                /** Creating DRT Chip records in MRS **/
                if (mapPTRFIdToDRTChips.size() > 0 && mapPTRFIdToDRTChips.containsKey(ptrfId)) {
                    set < String > lstDRTChips = new set < String > ();
                    lstDRTChips.addAll(mapPTRFIdToDRTChips.get(ptrfId));
                    if (lstDRTChips != null && lstDRTChips.size() > 0) {
                        for (String chipName: lstDRTChips) {
                            //TASK-1957
                            String chipUniqueIdentifier = chipName.substringBefore(':') + ptrfId;
                            if (mapExistingMRSChipDetails.size() > 0 && mapExistingMRSChipDetails.containsKey(chipUniqueIdentifier)) {
                                lstMRSChipsExisting.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier));
                                setMRSIds.add(mapExistingMRSChipDetails.get(chipUniqueIdentifier).MRS__c); //TASK-2081       
                            } else {
                                //TASK-1957                           
                                MRS_Chip_Details__c objMRSCD = new MRS_Chip_Details__c();
                                objMRSCD.Name = chipName.substringBefore(':');
                                objMRSCD.DRT_Chip__c = true;
                                objMRSCD.DRT_Id__c = chipName.substringAfter(':');
                                objMRSCD.PTRF_Id__c = ptrfId;
                                if (setExistingLayersPTRFIds.size() > 0 && setExistingLayersPTRFIds.contains(ptrfId)) {
                                    objMRSCD.MRS__c = mapKeyToMRSLAs.get(mapPTRFIdsToUniqueKey.get(ptrfId)).MRS__c;
                                } else {
                                    objMRSCD.MRS__c = mapPTRFToMRSIds.get(ptrfId);
                                }
                                if (mrsId != null && objMRSCD.MRS__c == null) {
                                    objMRSCD.MRS__c = mrsId;
                                }
                                lstNewMRSCD.add(objMRSCD);
                            }
                        }
                    }
                }

            }
            /** Inserting Layer records in MRS Layer Association **/
            if (lstNewMRSLA != null && lstNewMRSLA.size() > 0) {
                Database.SaveResult[] srList = Database.insert(lstNewMRSLA, false);
                list < MRS_Layer_Association__c > lstNewMRSLASuccess = new list < MRS_Layer_Association__c > ();
                list < MRS_Layer_Association__c > lstNewMRSLADupError = new list < MRS_Layer_Association__c > ();
                integer loopCounter = 0;
                for (Database.SaveResult sr: srList) {
                    if (sr.isSuccess()) {
                        lstNewMRSLASuccess.add(lstNewMRSLA.get(loopCounter));
                    } else {
                        for (Database.Error err: sr.getErrors()) {
                            if (err.getStatusCode() == StatusCode.DUPLICATE_VALUE) {
                                lstNewMRSLADupError.add(lstNewMRSLA.get(loopCounter));
                                break;
                            }
                        }
                    }
                    loopCounter++;
                }

                if (!lstNewMRSLADupError.isEmpty()) {
                    //save log for auto retry
                    logValidationError(json.serialize(setPTRFIds), 'Duplicate MRS Layer: \n' + json.serialize(lstNewMRSLADupError), '', 'MRSHandlerUtility', 'addingPTRFToMRSFuture', 'ERROR', '-', true, false);
                    return;//no need to proceed further, this request will be retried
                }
                //==============================

                for (MRS_Layer_Association__c obj: lstNewMRSLASuccess) {
                    list < MRS_Layer_Association__c > tempList = new list < MRS_Layer_Association__c > ();
                    String mrsIdCreated = obj.MRS__c;
                    if (mapMRSIdToMRSLAId != null) {
                        if (mapMRSIdToMRSLAId.containsKey(mrsIdCreated)) {
                            tempList.addAll(mapMRSIdToMRSLAId.get(mrsIdCreated));
                        }
                        tempList.add(obj);
                        mapMRSIdToMRSLAId.put(mrsIdCreated, tempList);
                    }
                }
            }
            /** Inserting Chip records in MRS Chip Details **/
            if (lstNewMRSCD != null && lstNewMRSCD.size() > 0) {
                try {
                    
                    for (MRS_Chip_Details__c obj: lstNewMRSCD) {
                        if (obj.MRS__c == null && mrsId != null) {
                            obj.MRS__c = mrsId;
                        }
                    }
                    
                    insert lstNewMRSCD;


                } catch (Exception ex) {

                    //save log for auto retry
                    logValidationError(json.serialize(setPTRFIds), 'Error when inserted MRS Chip Details due to EXCLUSIVE_ACCESS. Please look for integration payload for the ptrf id', '', 'MRSHandlerUtility', 'addingPTRFToMRSFuture', 'ERROR', '-', true, false);
                    return;//no need to proceed further, this request will be retried
                }
                for (MRS_Chip_Details__c obj: lstNewMRSCD) {
                    list < MRS_Chip_Details__c > tempList = new list < MRS_Chip_Details__c > ();
                    String mrsIdCreated = obj.MRS__c;
                    setMRSIds.add(obj.MRS__c);
                    if (mapMRSIdToMRSCDId != null) {
                        if (mapMRSIdToMRSCDId.containsKey(mrsIdCreated)) {
                            tempList.addAll(mapMRSIdToMRSCDId.get(mrsIdCreated));
                        }
                        tempList.add(obj);
                        mapMRSIdToMRSCDId.put(mrsIdCreated, tempList);
                    }
                }
            }

            if (setMRSIds != null && setMRSIds.size() > 0) {
                list < MRS_Chip_Details__c > lstMRSChips = new list < MRS_Chip_Details__c > ();
                list < MRS_Layer_Association__c > lstMRSLayers = new list < MRS_Layer_Association__c > ();
                for (String objMRS: setMRSIds) {
                    if (mapMRSIdToMRSCDId != null && mapMRSIdToMRSCDId.containsKey(objMRS)) {
                        lstMRSChips.addAll(mapMRSIdToMRSCDId.get(objMRS));
                    }
                    if (mapMRSIdToMRSLAId != null && mapMRSIdToMRSLAId.containsKey(objMRS)) {
                        lstMRSLayers.addAll(mapMRSIdToMRSLAId.get(objMRS));
                    }
                }
                
                if (mapKeyToMRSLAs != null && mapKeyToMRSLAs.size() > 0) {
                    lstMRSLayers.addAll(mapKeyToMRSLAs.values());
                }
                //TASK-1957
                if (lstMRSChipsExisting != null && lstMRSChipsExisting.size() > 0) {
                    lstMRSChips.addAll(lstMRSChipsExisting);
                }
                for (MRS_Layer_Chip_Association__c objMRSLCA: [select Id, PTRF__c, Chip__c, Layer__c from MRS_Layer_Chip_Association__c where PTRF__c IN: mapPTRF.keySet()]) {
                    String strChip = objMRSLCA.Chip__c;
                    String strLayer = objMRSLCA.Layer__c;
                    setExistingLayerChips.add(strChip + strLayer);
                }

                //TASK2132
                set < String > setLayerChipDRT = new set < String > ();
                String DRTChipUnique = '';
                for (MRS_Layer_Chip_Association__c objLayerChip: [Select Chip_Name__c, DRT__c, Mask_Layer__c, Rev__C, Rom_Code__c from MRS_Layer_Chip_Association__c where Layer__r.mrs__c in : setMRSIds and PTRF_Or_DRT__c = 'DRT'
                and Layer_Chip_Status__c != 'Cancel']) {
                    if (objLayerChip.Rom_Code__c != null && objLayerChip.Rom_Code__c != '') {
                        setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Rom_Code__c + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                    } else {
                        setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                    }

                }
                //TASK2132

                //TASK-1957                                
                /** Creating Layer Chip records in MRS Layer Chip Association **/
                if (lstMRSChips != null && lstMRSChips.size() > 0 && lstMRSLayers != null && lstMRSLayers.size() > 0) {
                    for (MRS_Chip_Details__c mrsChipId: lstMRSChips) {
                        for (MRS_Layer_Association__c mrsLayerId: lstMRSLayers) {
                            if (mrsChipId.MRS__c == mrsLayerId.MRS__c) {

                                //TASk2132
                                if (mrsChipId.DRT_Chip__c) {
                                    if (mrsLayerId.ROM_Code__c != null && mrsLayerId.ROM_Code__c != '') {
                                        DRTChipUnique = mrsLayerId.Name + mrsLayerId.Mask_Layer_Rev__c + mrsLayerId.ROM_Code__c + mrsChipId.Name + mrsChipId.DRT_Id__c;
                                    } else {
                                        DRTChipUnique = mrsLayerId.Name + mrsLayerId.Mask_Layer_Rev__c + mrsChipId.Name + mrsChipId.DRT_Id__c;
                                    }
                                    if (setLayerChipDRT.contains(DRTChipUnique)) {
                                        continue; //TASK-2132/TASK-2140
                                    }
                                }
                                //TASk2132

                                //TASK-1957
                                String strChip = mrsChipId.Id;
                                String strLayer = mrsLayerId.Id;
                                
                                if (!setExistingLayerChips.contains(strChip + strLayer)) {
                                    //TASK-1957                                
                                    String layerUniqueIdentifier;
                                    boolean customerGDSOutReview = false;
                                    boolean foundryGDSOutReview = false;
                                    boolean customerFrameMockupReview = false;
                                    boolean foundryFrameMockupReview = false;
                                    boolean customerMebesJobview = false;
                                    boolean foundryMebesJobview = false;
                                    MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
                                    /** Populating default values for Layer Chip records in MRS Layer Chip Association **/
                                    obj.Chip__c = mrsChipId.Id;
                                    obj.Layer__c = mrsLayerId.Id;
                                    if (mrsChipId.PTRF_Id__c != null) {
                                        obj.PTRF__c = mrsChipId.PTRF_Id__c;
                                    } else if (mapUniqueKeyToPTRFIds != null && mapUniqueKeyToPTRFIds.size() > 0 && mapUniqueKeyToPTRFIds.containsKey(mrsLayerId.MRS_Layer_Unique_Identifier__c)) {
                                        obj.PTRF__c = mapUniqueKeyToPTRFIds.get(mrsLayerId.MRS_Layer_Unique_Identifier__c);
                                    } else if (mapMRSToPTRFIds != null && mapMRSToPTRFIds.size() > 0 && mapMRSToPTRFIds.containsKey(mrsChipId.MRS__c)) {
                                        obj.PTRF__c = mapMRSToPTRFIds.get(mrsChipId.MRS__c);
                                    } else {
                                        obj.PTRF__c = mapMRSIdToMRS.get(mrsChipId.MRS__c).Associated_PTRF__c;
                                    }
                                    if (mapPTRF.get(obj.PTRF__c).MaskSetTitle__c != null) {
                                        obj.Mask_Set_Title_Id__c = mapPTRF.get(obj.PTRF__c).MaskSetTitle__c;
                                        obj.Mask_Set_Title_Id__c = obj.Mask_Set_Title_Id__c.substring(0, 15);
                                    }
                                    if (mrsChipId.DRT_Chip__c) {
                                        obj.PTRF_Or_DRT__c = 'DRT';
                                        if (mrsLayerId.ROM_Code__c != null && mrsLayerId.ROM_Code__c != '') {
                                            layerUniqueIdentifier = /*mapMRSToMST.get(mrsLayerId.MRS__c)*/
                                            mapPTRF.get(obj.PTRF__c).MaskSetTitle__c + mrsLayerId.Name + mrsLayerId.Mask_Layer_Rev__c + mrsLayerId.ROM_Code__c; //TASK-2132/TASK-2140
                                        } else {
                                            layerUniqueIdentifier = /*mapMRSToMST.get(mrsLayerId.MRS__c)*/
                                            mapPTRF.get(obj.PTRF__c).MaskSetTitle__c + mrsLayerId.Name + mrsLayerId.Mask_Layer_Rev__c; //TASK-2132/TASK-2140
                                        }
                                        if (mrsChipId.DRT_Id__c != null) {
                                            obj.DRT__c = mrsChipId.DRT_Id__c;
                                        }
                                    } else {
                                        obj.PTRF_Or_DRT__c = 'PTRF';
                                    }
                                    obj.Tech_Geo__c = mapPTRF.get(obj.PTRF__c).Tech_Geo_Value__c /*Tech_Geo_Value__c*/
                                    ;
                                    obj.Customer_Name__c = mapPTRF.get(obj.PTRF__c).Customer__c;
                                    if (mapPTRF != null && mapPTRF.keySet().contains(obj.PTRF__c)) {
                                        if (mapPTRF.get(obj.PTRF__c).Device_Id__c != null) {
                                            obj.Device_Id__c = mapPTRF.get(obj.PTRF__c).Device_Id__c;
                                        }
                                    }
                                    /** Setting Default Values for DRT Chips **/
                                    if (obj.PTRF_Or_DRT__c == 'DRT') {
                                        if (!setLayersInPTRFButNotInDRT.contains(layerUniqueIdentifier)) {
                                            if (mrsChipId.Name == 'Frame') {
                                                obj.Prime_MEBES_Received__c = 'N.A.';
                                                obj.Frame_MEBES_Received__c = 'Not Done';
                                            } else {
                                                obj.Prime_MEBES_Received__c = 'Not Done';
                                                obj.Frame_MEBES_Received__c = 'N.A.';
                                            }
                                            obj = setDRTLayerChipDefaultValues(obj);
                                        }
                                        /** Setting Default Values for DRT Chips **/
                                        /** Setting Default Values for PTRF Chips **/
                                    } else {
                                        if (mapPTRFIdsToGDSOUTCustomer.containsKey(obj.PTRF__c) && mapPTRFIdsToGDSOUTCustomer.get(obj.PTRF__c)) {
                                            customerGDSOutReview = true;
                                        }
                                        if (mapPTRFIdsToGDSOUTFoundry.containsKey(obj.PTRF__c) && mapPTRFIdsToGDSOUTFoundry.get(obj.PTRF__c)) {
                                            foundryGDSOutReview = true;
                                        }
                                        if (mapPTRFIdsToFrameMockupCustomer.containsKey(obj.PTRF__c) && mapPTRFIdsToFrameMockupCustomer.get(obj.PTRF__c)) {
                                            customerFrameMockupReview = true;
                                        }
                                        if (mapPTRFIdsToFrameMockupFoundry.containsKey(obj.PTRF__c) && mapPTRFIdsToFrameMockupFoundry.get(obj.PTRF__c)) {
                                            foundryFrameMockupReview = true;
                                        }
                                        if (mapPTRFIdsToMEBESCustomer.containsKey(obj.PTRF__c) && mapPTRFIdsToMEBESCustomer.get(obj.PTRF__c)) {
                                            customerMebesJobview = true;
                                        }
                                        if (mapPTRFIdsToMEBESFoundry.containsKey(obj.PTRF__c) && mapPTRFIdsToMEBESFoundry.get(obj.PTRF__c)) {
                                            foundryMebesJobview = true;
                                        }
                                        
                                        /** Setting default value for Customer GDSOUT Review. **/
                                        if (mrsChipId.Name == 'Frame') {
                                            obj.Customer_GDSOUT_Review__c = 'N.A.';
                                        } else {
                                            if (customerGDSOutReview && mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c && mapPTRF.get(obj.PTRF__c).Prime_GDSOUT_Review__c) {
                                                obj.Customer_GDSOUT_Review__c = 'Not Ready';
                                            } else {
                                                obj.Customer_GDSOUT_Review__c = 'N.A.';
                                            }
                                        }
                                        /** Setting default value for Foundry GDSOUT Review. **/
                                        if (mrsChipId.Name == 'Frame') {
                                            obj.Foundry_GDSOUT_Review__c = 'N.A.';
                                        } else {
                                            if (foundryGDSOutReview && mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c && mapPTRF.get(obj.PTRF__c).Prime_GDSOUT_Review__c) {
                                                obj.Foundry_GDSOUT_Review__c = 'Not Ready';
                                            } else {
                                                obj.Foundry_GDSOUT_Review__c = 'N.A.';
                                            }
                                        }
                                        /** Setting default value for Customer Frame Mockup Review. **/
                                        if (mrsChipId.Name != 'Frame') {
                                            obj.Customer_Frame_Mockup__c = 'N.A.';
                                        } else {
                                            if (customerFrameMockupReview && mapPTRF.get(obj.PTRF__c).Frame_Tapeout__c && mapPTRF.get(obj.PTRF__c).Frame_Mockup__c) {
                                                obj.Customer_Frame_Mockup__c = 'Not Ready';
                                            } else {
                                                obj.Customer_Frame_Mockup__c = 'N.A.';
                                            }
                                        }
                                        /** Setting default value for Foundry Frame Mockup Review. **/
                                        if (mrsChipId.Name != 'Frame') {
                                            obj.Foundry_Frame_Mockup__c = 'N.A.';
                                        } else {
                                            if (foundryFrameMockupReview && mapPTRF.get(obj.PTRF__c).Frame_Tapeout__c && mapPTRF.get(obj.PTRF__c).Frame_Mockup__c) {
                                                obj.Foundry_Frame_Mockup__c = 'Not Ready';
                                            } else {
                                                obj.Foundry_Frame_Mockup__c = 'N.A.';
                                            }
                                        }
                                        /** Setting default value for Customer MEBES Jobview. **/
                                        String key1 = mrsLayerId.rom_code__c == null
                                            ? obj.ptrf__c + mrsLayerId.name + mrsLayerId.mask_layer_rev__c
                                            : obj.ptrf__c + mrsLayerId.name + mrsLayerId.mask_layer_rev__c + mrsLayerId.rom_code__c;
                                            
                                        if 
                                        (
                                            customerMebesJobview 
                                            && 
                                            (
                                                mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c 
                                                || 
                                                mapPTRF.get(obj.PTRF__c).Frame_Tapeout__c
                                            ) 
                                            && 
                                            mapPTRF.get(obj.PTRF__c).Customer_jobview__c == 'Gating mask release'
                                            &&
                                            !mapTopUpLayer.containsKey(key1) 
                                            //mrsLayerId.mask_layer_type__c != 'TOPUPMASKLAYER'//swgp-899: IF topup mask layer >>> default customer mebes jobview to n.a.
                                        ) {
                                            obj.Customer_MEBES_Jobview__c = 'Not Ready';
                                        } else {
                                            obj.Customer_MEBES_Jobview__c = 'N.A.';
                                        }
                                        /** Setting default value for Foundry MEBES Jobview. **/
                                        if (foundryMebesJobview && (mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c || mapPTRF.get(obj.PTRF__c).Frame_Tapeout__c) && mapPTRF.get(obj.PTRF__c).Foundry_Jobview__c == 'Gating mask release') {
                                            obj.Foundry_MEBES_Jobview__c = 'Not Ready';
                                        } else {
                                            obj.Foundry_MEBES_Jobview__c = 'N.A.';
                                        }
                                        if (obj.Tech_Geo__c != null) {
                                            
                                            /*
                                            SWGP-585: Change in technology cut-off between GlobalShuttle/TDTI-MPW and MRS name/label change
                                            Cut-off value will be stored in a custom setting for config purpose
                        
                                            Old:
                                                GlobalShuttle MEBES Jobview: MST starts with "MPW" and Tech node >20nm
                                                TDTI-MPW MEBES Jobview: MST starts with "MPW" and Tech node <=20nm
                                            To Be:
                                                GlobalShuttle MEBES Jobview: MST starts with "MPW" and Tech node >22nm
                                                TDTI-MPW MEBES Jobview: MST starts with "MPW" and Tech node <=22nm
                                            */
                                            
                                            Environment_Variable__c gstdtitech = Environment_Variable__c.getInstance('Swift_GS_TDTI_Tech_Geo_Cut_Off');                        
                                            Double gs_tdti_cutoff_tech_geo = null != gstdtitech ? Double.valueOf(gstdtitech.value__c) : 0.022;
                                            
                                            Double techGeo = Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                                            
                                            //===============================================================================
                                            //===============================================================================
                                            //swgp-1076: removed tdti >>> set tdti to N.A.
                                            obj.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                                            /** Setting default values for TDTI/MPW,Globalshuttle MEBES Jobviews. **/
                                            
                                            if (techGeo > gs_tdti_cutoff_tech_geo) {
                                                obj.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                                                if (mapPTRF.get(obj.PTRF__c).Mask_Set_Title_Name__c.startsWith('MPW')) {
                                                    obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
                                                } else {
                                                    obj.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                                                }
                                            } else {
                                                obj.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                                                if (mapPTRF.get(obj.PTRF__c).Mask_Set_Title_Name__c.startsWith('MPW')) {
                                                    //obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
                                                } else {
                                                    obj.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                                                }
                                            }
                                            //===============================================================================
                                            //===============================================================================
                                            
                                            /** Setting default values for Tapeout Centre,MDP MEBES Jobviews. **/
                                            Double mdpTechGeoCutoff = Double.valueOf(MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off', '0.022'));
                                            
                                            //SWGP-1168: if fab9/10 tapeout >> default gating DRR and N.A. for TOC
                                            String fabValue = mapPTRF.get(obj.PTRF__c).Fab__c;
                                            
                                            String fabToStopRTMEmail = 'Fab9;Fab10';
                                            try { fabToStopRTMEmail = Environment_Variable__c.getInstance('SWIFT_FAB_VALUE_STOP_RTM_EMAIL').value__c; } catch(exception e) {fabToStopRTMEmail = 'Fab9;Fab10';}
                                            
                                            list<String> listFabToStop = fabToStopRTMEmail.split(';');
                                            set<String> setFabToStop = new set<String>();
                                            setFabToStop.addAll(listFabToStop);
                                            
                                            //if (techGeo > mdpTechGeoCutoff && !fabToStopRTMEmail.containsIgnoreCase(fabValue)) {
                                            if (techGeo > mdpTechGeoCutoff && !setFabToStop.contains(fabValue)) {
                                                obj.Tapeout_Centre_MEBES_Jobview__c = 'Not Ready';
                                                obj.MDP_MEBES_Jobview__c = 'N.A.';
                                            } else {
                                                //if <= 22 
                                                //OR
                                                //SWGP-1168: if fab9/10 tapeout >> default gating DRR and N.A. for TOC
                                                obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
                                                obj.MDP_MEBES_Jobview__c = 'Not Ready';
                                            }
                                            /** Setting default value for Tapeout Applications MEBES Jobview. **/
                                            if (mrsChipId.Name != 'Frame' && mapPTRF.get(obj.PTRF__c).Customer__r.RecordType.Name != 'GLOBALFOUNDRIES Internal' && !(mapPTRF.get(obj.PTRF__c).Mask_Set_Title__c != null && mapPTRF.get(obj.PTRF__c).Mask_Set_Title__c.startsWith('MPW') /*task-2384*/ )) {
                                                obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                                                PTRF__c objPTRF = mapPTRF.get(obj.PTRF__c);
                                                String shortName = objPTRF.Customer__r.Short_Name__c;
                                                String ptrfCJ = 'CMJ' + objPTRF.Customer_jobview__c;
                                                String ptrfFJ = 'FMJ' + objPTRF.Foundry_Jobview__c;
                                                String orderType = objPTRF.Order_Type__c;
                                                String processTLP = objPTRF.Process_Technology_Lifecycle_Phase__c;
                                                if (mapTAMJCKeyToGating.size() > 0) {
                                                    for (String key: mapTAMJCKeyToGating.keySet()) {
                                                        Boolean gatingTrue = false;
                                                        if (key.contains(orderType)) {
                                                            if ((key.contains(ptrfCJ) && key.contains(ptrfFJ) && mapTAMJCKeyToLogic.containsKey(key) && mapTAMJCKeyToLogic.get(key) == 'AND') || ((key.contains(ptrfCJ) || key.contains(ptrfFJ)) && mapTAMJCKeyToLogic.containsKey(key) && mapTAMJCKeyToLogic.get(key) == 'OR')) {
                                                                if (setKeyToPLTP.contains(key)) {
                                                                    if (processTLP != null && key.contains(processTLP)) {
                                                                        gatingTrue = true;
                                                                    } else {
                                                                        gatingTrue = false;
                                                                    }
                                                                } else {
                                                                    if (processTLP != null) {
                                                                        gatingTrue = false;
                                                                    } else {
                                                                        gatingTrue = true;
                                                                    }
                                                                }
                                                                if (gatingTrue) {
                                                                    if (mapKeyToTechGeoLessThanEqual.containsKey(key)) {
                                                                        if (techGeo <= mapKeyToTechGeoLessThanEqual.get(key)) {
                                                                            gatingTrue = true;
                                                                        } else {
                                                                            gatingTrue = false;
                                                                        }
                                                                    } else if (mapKeyToTechGeoEqual.containsKey(key)) {
                                                                        if (techGeo == mapKeyToTechGeoEqual.get(key)) {
                                                                            gatingTrue = true;
                                                                        } else {
                                                                            gatingTrue = false;
                                                                        }
                                                                    } else if (mapKeyToTechGeoLessThan.containsKey(key) && (mapKeyToTechGeoGreaterThan.containsKey(key))) {
                                                                        if ((techGeo >= mapKeyToTechGeoLessThan.get(key)) && (techGeo <= mapKeyToTechGeoGreaterThan.get(key))) {
                                                                            gatingTrue = true;
                                                                        } else {
                                                                            gatingTrue = false;
                                                                        }
                                                                    }
                                                                }
                                                                if (gatingTrue) {
                                                                    if (mapTAMJCKeyToGating.get(key) == 'Gating') {
                                                                        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
                                                                    } else {
                                                                        obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                                                                    }
                                                                    if (mapTAMJCKeyToExcluded.containsKey(key) && shortName != null & mapTAMJCKeyToExcluded.get(key).contains(shortName)) {
                                                                        obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                                            }
                                        } else {
                                            obj.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                                            obj.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                                            obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
                                            obj.MDP_MEBES_Jobview__c = 'N.A.';
                                            obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                                        }
                                        /** Setting default value for Send Prime Data. **/
                                        if (mrsChipId.Name == 'Frame') {
                                            obj.Send_Prime_Data__c = 'N.A.';
                                        } else {
                                            if (!mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c) {
                                                obj.Send_Prime_Data__c = 'N.A.';
                                            } else {
                                                obj.Send_Prime_Data__c = 'Not Done';
                                            }
                                        }
                                        /** Setting default value for Send Frame Data. **/
                                        if (mrsChipId.Name != 'Frame') {
                                            obj.Send_Frame_Data__c = 'N.A.';
                                        } else {
                                            if (!mapPTRF.get(obj.PTRF__c).Frame_Tapeout__c) {
                                                obj.Send_Frame_Data__c = 'N.A.';
                                            } else {
                                                obj.Send_Frame_Data__c = 'Not Done';
                                            }
                                        }
                                        /** Setting default value for ORC. **/
                                        obj.ORC__c = 'N.A.';
                                        /** Setting default value for Remote Jobview Setups. **/
                                        obj.Customer_Prime_Remote_Jobview_Setup__c = 'N.A.';
                                        obj.Customer_Frame_Remote_Jobview_Setup__c = 'N.A.';
                                        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'N.A.';
                                        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'N.A.';
                                        /** Setting default value for DRW. **/
                                        if (mrsChipId.Name == 'Frame') {
                                            obj.DRW__c = 'N.A.';
                                        } else {
                                            if (
                                            !chipNameSet.contains(mrsChipId.Name)//swgp-1075
                                            &&
                                            mapPTRF.get(obj.PTRF__c).Prime_Tapeout__c 
                                            && 
                                            mapPTRF.get(obj.PTRF__c).DRC_Only__c 
                                            && 
                                            mapPTRF.get(obj.PTRF__c).PTRF_DRC_Option__c != null 
                                            && 
                                            (mapPTRF.get(obj.PTRF__c).PTRF_DRC_Option__c == 'Foundry run and gating mask release' || mapPTRF.get(obj.PTRF__c).PTRF_DRC_Option__c == 'Customer run and gating mask release')
                                            ) {
                                                obj.DRW__c = 'Not Ready';
                                            } else {
                                                obj.DRW__c = 'N.A.';
                                            }
                                        }
                                        /** Setting default value for Prime,Frame MEBES Received. **/
                                        if (mrsChipId.Name == 'Frame') {
                                            obj.Prime_MEBES_Received__c = 'N.A.';
                                            obj.Frame_MEBES_Received__c = 'Not Done';
                                        } else {
                                            obj.Prime_MEBES_Received__c = 'Not Done';
                                            obj.Frame_MEBES_Received__c = 'N.A.';
                                        }
                                    }
                                    /** Setting Default Values for PTRF Chips **/
                                    if ((obj.PTRF_Or_DRT__c == 'PTRF') || ((obj.PTRF_Or_DRT__c == 'DRT') && !setLayersInPTRFButNotInDRT.contains(layerUniqueIdentifier) && mapDRTLayerToChipNames.containsKey(layerUniqueIdentifier) && mapDRTLayerToChipNames.get(layerUniqueIdentifier).contains(mrsChipId.Name))) { //TASK-2132/TASK-2140                               
                                        lstNewMRSLCA.add(obj);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            /** Inserting Layer Chip records in MRS Layer Chip Association **/
            if (lstNewMRSLCA != null && lstNewMRSLCA.size() > 0) {
                numberOfLayerChipRecords = lstNewMRSLCA.size();
                executeInsertMCLA(lstNewMRSLCA);
            }
        }
        if (mapReleasedMRSIdToMRSLA != null && mapReleasedMRSIdToMRSLA.size() > 0) {
            try {
                sendEmailOnAddingReleasedLayersToMRS(mapReleasedMRSIdToMRSLA);//send email of "layers have been released..."
            } catch (Exception e) { }
        }
    }



    /**
        This method is for adding DRT Chips to MRS when a DRT is associated with a PTRF which reaches Perform Tapeout Options. 
        @method name: addingDRTChipsToMRS
        @parameter:   1. Map of PTRF Id to PTRF records
                      2. Map of DRT Id to Mask Layer records.
        @return :     Map of PTRF Id to set of DRT Chips.
     **/

    public static map < String, set < String >> addingDRTChipsToMRS(map < String, PTRF__c > mapPTRF, map < String, Mask_Layer__c > mapKeyForDRTToMaskLayers) {
        
        map < String, set < String >> mapPTRFIdToDRTChipNames = new map < String, set < String >> ();
        map < String, String > mapDRTIdsToPTRFIds = new map < String, String > ();
        set < String > setPrimeDRTIds = new set < String > ();
        set < String > setFrameDRTIds = new set < String > ();
        set < String > setDRTUniqueLayers = new set < String > ();
        setLayersInPTRFButNotInDRT = new set < String > ();
        mapDRTLayerToChipNames = new map < String, set < String >> (); //TASK-2132/TASK-2140
        if (mapPTRF != null && mapPTRF.size() > 0) {
            for (DRT_PTRF_Association__c obj: [Select Id, DRT__c, PTRF__c, DRT__r.Type__c from DRT_PTRF_Association__c where PTRF__c IN: mapPTRF.keySet()]) {
                if (obj.DRT__r.Type__c == 'PRIME') {
                    setPrimeDRTIds.add(obj.DRT__c);
                } else {
                    setFrameDRTIds.add(obj.DRT__c);
                }
                mapDRTIdsToPTRFIds.put(obj.DRT__c, obj.PTRF__c);
            }
            /**  Code added for TASK2132/TASK2140  START**/
            set < String > setLayerChipDRT = new set < String > ();
            set < String > setLayerChipDRTFrame = new set < String > ();
            String DRTChipUnique;
            String DRTChipUniqueFrame;
            for (MRS_Layer_Chip_Association__c objLayerChip: [Select Chip_Name__c, DRT__c, Mask_Layer__c, Rev__C, Rom_Code__c from MRS_Layer_Chip_Association__c where DRT__c IN: setPrimeDRTIds and PTRF_Or_DRT__c = 'DRT'
            and Layer_Chip_Status__c != 'Cancel']) {
                if (objLayerChip.Rom_Code__c != null && objLayerChip.Rom_Code__c != '') {
                    setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Rom_Code__c + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                } else {
                    setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                }
            }
            for (MRS_Layer_Chip_Association__c objLayerChip: [Select Chip_Name__c, DRT__c, Mask_Layer__c, Rev__C, Rom_Code__c from MRS_Layer_Chip_Association__c where DRT__c IN: setFrameDRTIds and PTRF_Or_DRT__c = 'DRT'
            and Layer_Chip_Status__c != 'Cancel']) {
                if (objLayerChip.Rom_Code__c != null && objLayerChip.Rom_Code__c != '') {
                    setLayerChipDRTFrame.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Rom_Code__c + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                } else {
                    setLayerChipDRTFrame.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
                }
            }
            /**  Code added for TASK2132/TASK2140  END**/
            /** Adding Prime DRT Chips To MRS **/
            if (setPrimeDRTIds != null && setPrimeDRTIds.size() > 0) {
                for (PRIME_DRT_Chip_Layer_Summary__c objPDCLS: [Select Layer__r.DRT__c, Chip_Name__c, Mask_Layer_Rev__c, ROM_Code__c, Layer__r.Retrofit_Mask_Rev__c,
                Layer__r.Retrofit_ROM_Code__c, Layer__r.Name, Layer__r.Mask_Set_Title__c, DRT_ID__c,
                
                //swgp-600 : comparing based mst and retrofit mst
                chip__r.Mask_Set_Title__c,chip__r.DRT__r.Mask_Set_Title__c
                //swgp-600_END
                
                from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.IsSoftDeleted__c = False and Layer__r.IsSoftDeleted__c = False and Layer__r.DRT__c IN: setPrimeDRTIds]) {
                    String ptrfId;
                    String layerUnique;

                    if (mapDRTIdsToPTRFIds.keySet().contains(objPDCLS.Layer__r.DRT__c)) {
                        ptrfId = mapDRTIdsToPTRFIds.get(objPDCLS.Layer__r.DRT__c);
                    }
                    if (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != '') {
                        layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Layer__r.Retrofit_ROM_Code__c;
                    } else {
                        layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c;
                    }
                    setDRTUniqueLayers.add(layerUnique);
                    if (mapKeyForDRTToMaskLayers != null && mapKeyForDRTToMaskLayers.containsKey(layerUnique) && ptrfId == mapKeyForDRTToMaskLayers.get(layerUnique).PTRF__c) {
                        
                        /****************************************************************/
                        /****************************************************************/
                        /*SWGP-600 retro_rev = rev*/
                        if (objPDCLS.Mask_Layer_Rev__c != objPDCLS.Layer__r.Retrofit_Mask_Rev__c //this line to be modified for swgp-600
                            || 
                            (
                                (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c != objPDCLS.Layer__r.Retrofit_ROM_Code__c) 
                                || 
                                (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c == null) 
                                || 
                                (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c == null)
                            )
                            //SWGP-600: add in: based MST != retrofit MST then >>> ignore REV
                            ||
                            (
                                objPDCLS.chip__r.Mask_Set_Title__c != objPDCLS.chip__r.DRT__r.Mask_Set_Title__c
                            )
                        ) {
                        /****************************************************************/
                        /****************************************************************/
                            
                            set < String > tempSet = new set < String > ();
                            if (mapPTRFIdToDRTChipNames.containsKey(ptrfId)) {
                                tempSet.addAll(mapPTRFIdToDRTChipNames.get(ptrfId));
                            }
                            /**  Code added for TASK2132/TASK2140  START**/
                            if (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != '') {
                                DRTChipUnique = objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Layer__r.Retrofit_ROM_Code__c + objPDCLS.Chip_Name__c + objPDCLS.DRT_ID__c;
                            } else {
                                DRTChipUnique = objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Chip_Name__c + objPDCLS.DRT_ID__c;
                            }
                            /**  Code added for TASK2132/TASK2140  END**/
                            if (!setLayerChipDRT.contains(DRTChipUnique)) {
                                tempSet.add(objPDCLS.Chip_Name__c + ':' + objPDCLS.Layer__r.DRT__c);
                                mapPTRFIdToDRTChipNames.put(ptrfId, tempSet);
                            }
                            //TASK-2132/TASK-2140
                            set < String > tempSetPerLayerChips = new set < String > ();
                            if (mapDRTLayerToChipNames.containsKey(layerUnique)) {
                                tempSetPerLayerChips.addAll(mapDRTLayerToChipNames.get(layerUnique));
                            }
                            tempSetPerLayerChips.add(objPDCLS.Chip_Name__c);
                            mapDRTLayerToChipNames.put(layerUnique, tempSetPerLayerChips);
                            //TASK-2132/TASK-2140
                        }
                    }
                }
            }
            /** Adding Frame DRT Chips To MRS **/
            if (setFrameDRTIds != null && setFrameDRTIds.size() > 0) {
                //SWGP-600 - set the mst to compare when generate chip up to drt.mst instead of layer.mst due to drt can use layer from another device
                //fix bug 1.1: different mst, different rev but there are none layer chip
                //original code
                //for (Frame_DRT_Association__c objFDA: [Select Mask_Layer_No__c, Mask_Set_Title__c, DRT__c, Mask_Rev__c, ROM_Code__c, Retrofit_Mask_Rev__c,
                //Retrofit_ROM_Code__c from Frame_DRT_Association__c where DRT__c IN: setFrameDRTIds]) {
                    
                //new code
                for (Frame_DRT_Association__c objFDA: [Select Mask_Layer_No__c, 
                
                drt__r.Mask_Set_Title__c,//retrofit MST
                Mask_Set_Title__c, //based MST (could belong to another device)
                
                DRT__c, Mask_Rev__c, ROM_Code__c, Retrofit_Mask_Rev__c,
                Retrofit_ROM_Code__c from Frame_DRT_Association__c where DRT__c IN: setFrameDRTIds]) {

                    String ptrfId;
                    String layerUnique;
                    if (mapDRTIdsToPTRFIds.keySet().contains(objFDA.DRT__c)) {
                        ptrfId = mapDRTIdsToPTRFIds.get(objFDA.DRT__c);
                    }
                    if (objFDA.Retrofit_ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != '') {
                        //SWGP-600 - set the mst to compare when generate chip up to drt.mst instead of layer.mst due to drt can use layer from another device
                        //fix bug 1.1: different mst, different rev but there are none layer chip
                        //original code
                        //layerUnique = objFDA.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c;
                        
                        //new code
                        layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c;
                    } else {
                        //SWGP-600 - set the mst to compare when generate chip up to drt.mst instead of layer.mst due to drt can use layer from another device
                        //fix bug 1.1: different mst, different rev but there are none layer chip
                        //original code
                        //layerUnique = objFDA.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c;
                        
                        //new code
                        layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c;
                    }
                    setDRTUniqueLayers.add(layerUnique);
                    if (mapKeyForDRTToMaskLayers != null && mapKeyForDRTToMaskLayers.containsKey(layerUnique) && ptrfId == mapKeyForDRTToMaskLayers.get(layerUnique).PTRF__c) {
                        
                        /****************************************************************/
                        /****************************************************************/
                        /*SWGP-600 retro_rev = rev*/
                        if ((objFDA.Mask_Rev__c != objFDA.Retrofit_Mask_Rev__c) //this line to be modified for swgp-600
                            || 
                            (
                                (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c != objFDA.Retrofit_ROM_Code__c) 
                                || (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c == null) 
                                || (objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c == null)
                            )
                            //SWGP-600: add in: based MST != retrofit MST then >>> ignore REV
                            ||
                            (
                                objFDA.drt__r.Mask_Set_Title__c != objFDA.Mask_Set_Title__c
                            )
                        ) {
                        /****************************************************************/
                        /****************************************************************/
                            
                            set < String > tempSet = new set < String > ();
                            if (mapPTRFIdToDRTChipNames.containsKey(ptrfId)) {
                                tempSet.addAll(mapPTRFIdToDRTChipNames.get(ptrfId));
                            }

                            /**  Code added for TASK2132/TASK2140  START**/
                            if (objFDA.Retrofit_ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != '') {
                                DRTChipUniqueFrame = objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c + 'Frame' + objFDA.DRT__c;
                            } else {
                                DRTChipUniqueFrame = objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + 'Frame' + objFDA.DRT__c;
                            }
                            /**  Code added for TASK2132/TASK2140  END**/
                            if (!setLayerChipDRTFrame.contains(DRTChipUniqueFrame)) {
                                tempSet.add('Frame:' + objFDA.DRT__c);
                                mapPTRFIdToDRTChipNames.put(ptrfId, tempSet);
                            }
                            //TASK-2132/TASK-2140
                            set < String > tempSetPerLayerChips = new set < String > ();
                            if (mapDRTLayerToChipNames.containsKey(layerUnique)) {
                                tempSetPerLayerChips.addAll(mapDRTLayerToChipNames.get(layerUnique));
                            }
                            tempSetPerLayerChips.add('Frame');
                            mapDRTLayerToChipNames.put(layerUnique, tempSetPerLayerChips);
                            //TASK-2132/TASK-2140
                        }
                    }
                }
            }
            for (String uniqueLayerKey: mapKeyForDRTToMaskLayers.keySet()) {
                if (!setDRTUniqueLayers.contains(uniqueLayerKey)) {
                    setLayersInPTRFButNotInDRT.add(uniqueLayerKey);
                }
            }


        }
        return mapPTRFIdToDRTChipNames;
    }


    /**
        This method is for checking that whenever a chip status become cancelled then all the 
        related chips in chip layer status become cancelled in MRS .  
        @method name: deselectChipInPTRF
        @parameter:   1. Set of PTRF Ids.
                      2. Set of deselected Chip Names.
        @return :     None.
     **/

    public static void deselectChipInPTRF(Set < String > setPTRFIds, Set < String > setChipNames) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        for (MRS_Layer_Chip_Association__c objMCLA: [select Layer_Chip_Status__c, PTRF__c, Chip__r.Name From MRS_Layer_Chip_Association__c
        where PTRF__c IN: setPTRFIds AND Chip__r.Name IN: setChipNames]) {
            objMCLA.Layer_Chip_Status__c = 'Cancel';
            lstMCLA.add(objMCLA);
        }
        if (lstMCLA != null && lstMCLA.size() > 0) {
            executeUpdateMCLA(lstMCLA);
        }
    }

    /**
        This method is for checking that whenever a Mask Layer is deselected then all the 
        related chip layer status corresponding to this layer become cancelled in MRS .  
        @method name: deselectLayerInPTRF
        @parameter:   1. Set of PTRF Ids.
                      2. Set of deselected Layer Unique Identifiers.
        @return :     None.
     **/

    public static void deselectLayerInPTRF(Set < String > setPTRFIds, Set < String > setUniqueLayerIdentifier) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        map < String, PTRF__c > mapPTRFIdsToPTRF = new map < String, PTRF__c > ();
        for (PTRF__c objPTRF: [Select Id, Prime_Tapeout__c, Frame_Tapeout__c from PTRF__c where Id IN: setPTRFIds]) {
            mapPTRFIdsToPTRF.put(objPTRF.Id, objPTRF);
        }
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, Layer__r.MRS_Layer_Unique_Identifier__c, Layer_Chip_Status__c,
        Chip__r.Name from MRS_Layer_Chip_Association__c where Layer__r.MRS_Layer_Unique_Identifier__c IN: setUniqueLayerIdentifier
        AND PTRF__c IN: setPTRFIds]) {
            if ((mapPTRFIdsToPTRF.get(objMCLA.PTRF__c).Prime_Tapeout__c && objMCLA.Chip__r.Name != 'Frame') || (mapPTRFIdsToPTRF.get(objMCLA.PTRF__c).Frame_Tapeout__c && objMCLA.Chip__r.Name == 'Frame')) {
                objMCLA.Layer_Chip_Status__c = 'Cancel';
                lstMCLA.add(objMCLA);
            }
        }
        if (lstMCLA != null && lstMCLA.size() > 0) {
            executeUpdateMCLA(lstMCLA);
        }
    }

    /**
        This method is for checking that whenever a PTRF gets cancelled then all the 
        related chip layer status corresponding to this PTRF become cancelled in MRS .   
        @method name: cancelPTRFInMRS
        @parameter:   Map of cancelled PTRF Ids to PTRF records.
        @return :     None.
    **/
    public static void cancelPTRFInMRS(map < String, PTRF__c > mapCancelPTRF) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        set < String > setCancelledLayerIds = new set < String > (); //TASK-2132/TASK-2140
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, DRT__c, Layer_Chip_Status__c, Chip__r.Name, PTRF_Or_DRT__c, Layer__c from MRS_Layer_Chip_Association__c
        where PTRF__c IN: mapCancelPTRF.keySet() AND PTRF_Or_DRT__c = 'PTRF']) { //TASK-2132/TASK-2140
            if ((mapCancelPTRF.get(objMCLA.PTRF__c).Prime_Tapeout__c && objMCLA.Chip__r.Name != 'Frame') || (mapCancelPTRF.get(objMCLA.PTRF__c).Frame_Tapeout__c && objMCLA.Chip__r.Name == 'Frame')) {
                
                //swgp-950
                if(objMCLA.Layer_Chip_Status__c != 'Hold') {
                    objMCLA.Layer_Chip_Status__c = 'Cancel';
                } else {
                    objMCLA.Is_Cancel_After_Off_Hold__c = true;
                }//swgp-950-end
                //objMCLA.Layer_Chip_Status__c = 'Cancel';
                
                lstMCLA.add(objMCLA);
                setCancelledLayerIds.add(objMCLA.Layer__c); //TASK-2132/TASK-2140
            }
        }

        //TASK-2132/TASK-2140 - Start
        Set < String > setDRTIds = new Set < String > ();
        setDRTIds.addAll(retrieveDRTChipsInMRS(mapCancelPTRF.keySet(), setCancelledLayerIds, 'Cancel'));
        if (setDRTIds.size() > 0) {
            for (MRS_Layer_Chip_Association__c obj: [Select Id, DRT__c, PTRF__c, Layer__c, Layer_Chip_Status__c from MRS_Layer_Chip_Association__c where DRT__c IN: setDRTIds
            AND Layer__c IN: setLayersToBeCancelled]) { //TASK-2132/TASK-2140
                
                //swgp-950
                if(obj.Layer_Chip_Status__c != 'Hold') {
                    obj.Layer_Chip_Status__c = 'Cancel';
                } else {
                    obj.Is_Cancel_After_Off_Hold__c = true;
                }//swgp-950-end
                //obj.Layer_Chip_Status__c = 'Cancel';
                
                lstMCLA.add(obj);
            }
        }
        //TASK-2132/TASK-2140 - End
        
        linkDRTChipsToActivePTRF(lstMCLA, mapCancelPTRF.keySet(), new Set < String > ());
        /*Code modification for TASK-2129 start*/
        if (lstMCLA != null && lstMCLA.size() > 0) {
            
            MRSHandlerUtility.numberOfLayerChipRecords = lstMCLA.size();
            if (system.isFuture()) {
                executeUpdateMCLA(lstMCLA);
            } else {
                List < ID > recordIds = new List < ID > ();                
                for (MRS_Layer_Chip_Association__c obj: lstMCLA) {
                    recordIds.add(obj.Id);
                }
                executeUpdateMCLAFuture(recordIds);
            }
        }
        /*Code modification for TASK-2129 end*/
    }

    /**
        This method is for checking that whenever the Prime Tapeout flag of PTRF gets deselected then all the 
        related chip layer status corresponding to the Prime Chips of this PTRF become cancelled in MRS .   
        @method name: partialCancelPrimePTRFs
        @parameter:   Set of partially cancelled PTRF Ids.
        @return :     None.
     **/

    public static void partialCancelPrimePTRFs(Set < String > setPartialCancelPrimePTRFs) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        set < String > setCancelledLayerIds = new set < String > (); //TASK-2132/TASK-2140
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, Layer_Chip_Status__c, Chip__r.Name, PTRF_Or_DRT__c, Layer__c from MRS_Layer_Chip_Association__c
        where PTRF__c IN: setPartialCancelPrimePTRFs AND Chip__r.Name != 'Frame'
        AND PTRF_Or_DRT__c = 'PTRF']) { //TASK-2132/TASK-2140
            
            //swgp-950 check for hold layer chip status, set flag Is_Cancel_After_Off_Hold__c
            if(objMCLA.Layer_Chip_Status__c != 'Hold') {
                objMCLA.Layer_Chip_Status__c = 'Cancel';
            } else {
                objMCLA.Is_Cancel_After_Off_Hold__c = true;
            }//swgp-950-end
            //objMCLA.Layer_Chip_Status__c = 'Cancel';
            
            lstMCLA.add(objMCLA);
            setCancelledLayerIds.add(objMCLA.Layer__c); //TASK-2132/TASK-2140            
        }

        if (lstMCLA != null && lstMCLA.size() > 0) {
            executeUpdateMCLA(lstMCLA);
        }
    }

    /**
        This method is for checking that whenever the Frame Tapeout flag of PTRF gets deselected then all the 
        related chip layer status corresponding to the Frame Chips of this PTRF become cancelled in MRS . 
        @method name: partialCancelFramePTRFs
        @parameter:   Set of partially cancelled PTRF Ids.
        @return :     None.
     **/

    public static void partialCancelFramePTRFs(Set < String > setPartialCancelFramePTRFs) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        set < String > setCancelledLayerIds = new set < String > (); //TASK-2132/TASK-2140
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, Layer_Chip_Status__c, Chip__r.Name, Layer__c from MRS_Layer_Chip_Association__c
        where PTRF__c IN: setPartialCancelFramePTRFs AND Chip__r.Name = 'Frame'
        AND PTRF_Or_DRT__c = 'PTRF']) { //TASK-2132/TASK-2140       
            
            //swgp-950 check for hold layer chip status, set flag Is_Cancel_After_Off_Hold__c
            if(objMCLA.Layer_Chip_Status__c != 'Hold') {
                objMCLA.Layer_Chip_Status__c = 'Cancel';
            } else {
                objMCLA.Is_Cancel_After_Off_Hold__c = true;
            }//swgp-950-end
            //objMCLA.Layer_Chip_Status__c = 'Cancel';
            
            lstMCLA.add(objMCLA);
            setCancelledLayerIds.add(objMCLA.Layer__c); //TASK-2132/TASK-2140            
        }

        if (lstMCLA != null && lstMCLA.size() > 0) {
            executeUpdateMCLA(lstMCLA);
        }
    }

    //TASK-2132/TASK-2140 - Start
    public static Set < String > retrieveDRTChipsInMRS(Set < String > setPTRFIds, Set < String > setCancelledLayerIds, String scenario) {
        Set < String > setDRTIds = new Set < String > ();
        Set < String > setDRTIdsInMRS = new Set < String > ();
        Set < String > setDRTIdsNOTInMRS = new Set < String > ();
        Set < String > setPTRFIdsWithDRT = new Set < String > ();
        Set < String > setLayersFromOtherPTRFs = new Set < String > ();
        setLayersToBeCancelled = new Set < String > ();
        for (DRT_PTRF_Association__c obj: [select PTRF__c, PTRF__r.Status__c, DRT__c from DRT_PTRF_Association__c where PTRF__c in : setPTRFIds]) {
            setDRTIds.add(obj.DRT__c);
        }
        if (setDRTIds.size() > 0) {
            Set < String > setDRTIdsTemp = new Set < String > ();
            if (scenario == 'Cancel') {
                for (DRT_PTRF_Association__c obj: [select PTRF__c, PTRF__r.Status__c, DRT__c from DRT_PTRF_Association__c
                where PTRF__c not in : setPTRFIds and DRT__c in : setDRTIds and PTRF__r.Status__c = 'Perform Tapeout Options']) {
                    setDRTIdsTemp.add(obj.DRT__c);
                    setPTRFIdsWithDRT.add(obj.PTRF__c);
                }
            }
            if (setPTRFIdsWithDRT.size() > 0) {

                for (MRS_Layer_Chip_Association__c obj: [Select Id, PTRF__c, Layer__c from MRS_Layer_Chip_Association__c where PTRF__c IN: setPTRFIdsWithDRT
                AND PTRF_Or_DRT__c = 'PTRF']) {
                    setLayersFromOtherPTRFs.add(obj.Layer__c); //TASK-2132/TASK-2140 
                }
            }
            //TASK-2132/TASK-2140 - Start
            if (setLayersFromOtherPTRFs.size() > 0) {
                for (String cancelledLayer: setCancelledLayerIds) {
                    if (!setLayersFromOtherPTRFs.contains(cancelledLayer)) {
                        setLayersToBeCancelled.add(cancelledLayer);
                    }
                }
                if (setLayersToBeCancelled.size() == 0) {
                    setDRTIdsInMRS.addAll(setDRTIdsTemp);
                }
            } else {
                setLayersToBeCancelled.addAll(setCancelledLayerIds);
            }
            //TASK-2132/TASK-2140 - End
            if (setDRTIdsInMRS.size() > 0) {
                for (String drtId: setDRTIds) {
                    if (!setDRTIdsInMRS.contains(drtId)) {
                        setDRTIdsNOTInMRS.add(drtId);
                    }
                }
            } else {
                setDRTIdsNOTInMRS.addAll(setDRTIds);
            }
        }
        return setDRTIdsNOTInMRS;
    }
    //TASK-2132/TASK-2140 - End

    /**
        This method is for checking that whenever the DRC DRW Status of PTRF gets cancelled then all the 
        related DRW Status corresponding to the Chips of this PTRF become N.A. in MRS . 
        @method name: partialCancelDRCDRW
        @parameter:   Set of partially DRW cancelled PTRF Ids.
        @return :     None.
     **/

    public static void partialCancelDRCDRW(Set < String > setPartialCancelDRCDRW) {
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, DRW__c from MRS_Layer_Chip_Association__c
        where PTRF__c IN: setPartialCancelDRCDRW]) {
            objMCLA.DRW__c = 'N.A.';
            lstMCLA.add(objMCLA);
        }
        if (lstMCLA != null && lstMCLA.size() > 0) {
            executeUpdateMCLA(lstMCLA);
        }
    }

    /**
        This method is for adding DRT Chips To MRS when a DRT is linked to a PTRF after it has reached MRS .
        @method name: addDRTChipsInMRS
        @parameter:   1. Set of Prime DRT Ids.
                      2. Set of Frame DRT Ids.
                      3. Map of DRT to PTRF Ids.
                      4. Set of PTRF Ids.
        @return :     None.
     **/

    public static void addDRTChipsInMRS(set < String > setPrimeDRTIds, set < String > setFrameDRTIds, map < String, String > mapDRTToPTRFIds, set < String > setPTRFIds) {
        
        list < MRS_Chip_Details__c > lstMRSCDInsert = new list < MRS_Chip_Details__c > ();
        list < MRS_Layer_Chip_Association__c > lstMRSLCAUpdate = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Chip_Association__c > lstMRSLCAInsert = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Association__c > lstLayers = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Association__c > lstLayersUpdated = new list < MRS_Layer_Association__c > ();
        set < String > setDRTChips = new set < String > ();
        set < String > setLayerMRSIds = new set < String > ();
        set < String > setMRSLayerAssoIds = new set < String > ();
        set < String > setLayerUniqueIdentifiers = new set < String > ();
        set < String > setDRTUniqueLayers = new set < String > ();
        map < String, String > mapLayerTechGeos = new map < String, String > ();
        map < String, String > mapLayerCustomerIds = new map < String, String > ();
        map < String, String > mapLayerPTRFIds = new map < String, String > ();
        map < String, String > mapLayerDeviceIds = new map < String, String > ();
        map < String, String > mapPTRFIdsToMRSIds = new map < String, String > ();
        map < String, String > mapLayerIdToUniqueIdentifier = new map < String, String > ();
        mapDRTLayerToChipNames = new map < String, set < String >> (); //TASK-2132/TASK-2140
        //TASK2132/TASK2140  Start
        set < String > setLayerChipDRT = new set < String > ();
        set < String > setLayerChipDRTFrame = new set < String > ();
        String DRTChipUnique;
        String DRTChipUniqueFrame;
        //Task 2420
        for (MRS_Layer_Chip_Association__c objLayerChip: [Select Chip_Name__c, DRT__c, Mask_Layer__c, Rev__C, Rom_Code__c, Layer_Chip_Status__c from MRS_Layer_Chip_Association__c where DRT__c IN: setPrimeDRTIds and PTRF_Or_DRT__c = 'DRT'
        and Layer_Chip_Status__c != 'Cancel']) {
            if (objLayerChip.Rom_Code__c != null && objLayerChip.Rom_Code__c != '') {
                setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Rom_Code__c + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
            } else {
                setLayerChipDRT.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
            }
        }
        for (MRS_Layer_Chip_Association__c objLayerChip: [Select Chip_Name__c, DRT__c, Mask_Layer__c, Rev__C, Rom_Code__c, Layer_Chip_Status__c from MRS_Layer_Chip_Association__c where DRT__c IN: setFrameDRTIds and PTRF_Or_DRT__c = 'DRT'
        and Layer_Chip_Status__c != 'Cancel']) {
            if (objLayerChip.Rom_Code__c != null && objLayerChip.Rom_Code__c != '') {
                setLayerChipDRTFrame.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Rom_Code__c + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
            } else {
                setLayerChipDRTFrame.add(objLayerChip.Mask_Layer__c + objLayerChip.Rev__C + objLayerChip.Chip_Name__c + objLayerChip.DRT__c);
            }
        }
        //TASK2132/TASK2140  End
        map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToChips = new map < String, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c obj: [Select Id, DRT__c, Layer_Chip_Status__c, Layer__c, Tech_Geo__c, Layer__r.MRS__c, Customer_Name__c,
        Layer__r.Name, Layer__r.Mask_Layer_Rev__c, Layer__r.ROM_Code__c, Layer__r.MRS__r.Mask_Set_Title__c, Device_Id__c, PTRF__c from
        MRS_Layer_Chip_Association__c where PTRF__c IN: setPTRFIds]) {
            setLayerMRSIds.add(obj.Layer__c + ':' + obj.Layer__r.MRS__c);
            mapLayerTechGeos.put(obj.Layer__c, obj.Tech_Geo__c);
            mapLayerCustomerIds.put(obj.Layer__c, obj.Customer_Name__c);
            mapLayerDeviceIds.put(obj.Layer__c, obj.Device_Id__c);
            mapLayerPTRFIds.put(obj.Layer__c, obj.PTRF__c);
            mapPTRFIdsToMRSIds.put(obj.PTRF__c, obj.Layer__r.MRS__c);
            String layerUnique;
            if (obj.Layer__r.ROM_Code__c != null && obj.Layer__r.ROM_Code__c != '') {
                layerUnique = obj.Layer__r.MRS__r.Mask_Set_Title__c + obj.Layer__r.Name + obj.Layer__r.Mask_Layer_Rev__c + obj.Layer__r.ROM_Code__c;
            } else {
                layerUnique = obj.Layer__r.MRS__r.Mask_Set_Title__c + obj.Layer__r.Name + obj.Layer__r.Mask_Layer_Rev__c;
            }
            setLayerUniqueIdentifiers.add(layerUnique);
            mapLayerIdToUniqueIdentifier.put(obj.Layer__c, layerUnique);
        }
        /** Adding Prime DRT Chips To MRS **/
        if (setPrimeDRTIds != null && setPrimeDRTIds.size() > 0) {
            for (PRIME_DRT_Chip_Layer_Summary__c objPDCLS: [Select Layer__r.DRT__c, Chip_Name__c, Mask_Layer_Rev__c, ROM_Code__c, Layer__r.Retrofit_Mask_Rev__c, DRT_ID__c,
            Layer__r.Retrofit_ROM_Code__c, Layer__r.Name, Layer__r.Mask_Set_Title__c, 
            
            //swgp-600 : comparing based mst and retrofit mst
            chip__r.Mask_Set_Title__c,chip__r.DRT__r.Mask_Set_Title__c
            //swgp-600_END
            
            from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.IsSoftDeleted__c = False and Layer__r.IsSoftDeleted__c = False and Layer__r.DRT__c IN: setPrimeDRTIds]) { //TASK2132/TASK2140                
                
                String layerUnique;
                
                if (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != '') {
                    layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Layer__r.Retrofit_ROM_Code__c;
                } else {
                    layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c;
                }
                
                setDRTUniqueLayers.add(layerUnique);
                
                
                if (setLayerUniqueIdentifiers != null && setLayerUniqueIdentifiers.contains(layerUnique)) {
                
                    /****************************************************************/
                    //SWGP-600: retro_rev != rev
                    /****************************************************************/
                    if (objPDCLS.Mask_Layer_Rev__c != objPDCLS.Layer__r.Retrofit_Mask_Rev__c 
                        || 
                        (
                            (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c != objPDCLS.Layer__r.Retrofit_ROM_Code__c) 
                            || 
                            (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c == null) 
                            || 
                            (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c == null)
                        )
                        //SWGP-600: add in: based MST != retrofit MST then >>> ignore REV
                        ||
                        (
                            objPDCLS.chip__r.Mask_Set_Title__c != objPDCLS.chip__r.DRT__r.Mask_Set_Title__c //based mst != retrofit mst
                        )
                    ) {
                        //TASK2132/TASK2140  Start    
                        if (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != '') {
                            DRTChipUnique = objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Layer__r.Retrofit_ROM_Code__c + objPDCLS.Chip_Name__c + objPDCLS.DRT_ID__c;
                        } else {
                            DRTChipUnique = objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Chip_Name__c + objPDCLS.DRT_ID__c;
                        }
                        if (!setLayerChipDRT.contains(DRTChipUnique)) {
                            setDRTChips.add(objPDCLS.Chip_Name__c + ':' + objPDCLS.Layer__r.DRT__c);
                        }
                        set < String > tempSetPerLayerChips = new set < String > ();
                        if (mapDRTLayerToChipNames.containsKey(layerUnique)) {
                            tempSetPerLayerChips.addAll(mapDRTLayerToChipNames.get(layerUnique));
                        }
                        tempSetPerLayerChips.add(objPDCLS.Chip_Name__c);
                        mapDRTLayerToChipNames.put(layerUnique, tempSetPerLayerChips);
                        //TASK2132/TASK2140  End                                                              
                    }
                }
            }
        }
        
        /** Adding Frame DRT Chips To MRS **/
        if (setFrameDRTIds != null && setFrameDRTIds.size() > 0) {
            
            /*SWGP-600*/
            for (Frame_DRT_Association__c objFDA: [Select Mask_Layer_No__c, DRT__c, Mask_Rev__c, ROM_Code__c, Retrofit_Mask_Rev__c,
                Retrofit_ROM_Code__c, 
                
                //swgp-600 : comparing based mst and retrofit mst
                drt__r.Mask_Set_Title__c,//retrofit MST
                Mask_Set_Title__c //based MST (could belong to another device)
                //swgp-600_END
                
                from Frame_DRT_Association__c where DRT__c IN: setFrameDRTIds]) 
            { 
                //TASK2132/TASK2140
                String layerUnique;
                
                if (objFDA.Retrofit_ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != '') {
                    //swgp-600
                    layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c;
                } else {
                    //swgp-600
                    layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c;
                }
                
                setDRTUniqueLayers.add(layerUnique);
                
                if (setLayerUniqueIdentifiers != null && setLayerUniqueIdentifiers.contains(layerUnique)) {
                    
                    /****************************************************************/
                    //SWGP-600: retro_rev != rev
                    /****************************************************************/
                    if (
                        (objFDA.Mask_Rev__c != objFDA.Retrofit_Mask_Rev__c) 
                        || 
                        (
                            (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c != objFDA.Retrofit_ROM_Code__c) 
                            || 
                            (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c == null) 
                            || 
                            (objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c == null)
                        )
                        //SWGP-600: add in: based MST != retrofit MST then >>> ignore REV
                        ||
                        (
                            objFDA.drt__r.Mask_Set_Title__c != objFDA.Mask_Set_Title__c //based mst != retrofit mst >> ignore rev/retro_rev
                        )
                    ) {
                    
                        //TASK2132/TASK2140  Start      
                        if (objFDA.Retrofit_ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != '') {
                            DRTChipUniqueFrame = objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c + 'Frame' + objFDA.DRT__c;
                        } else {
                            DRTChipUniqueFrame = objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + 'Frame' + objFDA.DRT__c;
                        }
                        if (!setLayerChipDRTFrame.contains(DRTChipUniqueFrame)) {
                            setDRTChips.add('Frame:' + objFDA.DRT__c);
                        }
                        set < String > tempSetPerLayerChips = new set < String > ();
                        if (mapDRTLayerToChipNames.containsKey(layerUnique)) {
                            tempSetPerLayerChips.addAll(mapDRTLayerToChipNames.get(layerUnique));
                        }
                        tempSetPerLayerChips.add('Frame');
                        mapDRTLayerToChipNames.put(layerUnique, tempSetPerLayerChips);
                        //TASK2132/TASK2140  End                                                                                                                                        
                    }
                }
            }
        }
        
        if (setDRTChips.size() > 0) {
            for (String chipsDRT: setDRTChips) {
                MRS_Chip_Details__c objMCD = new MRS_Chip_Details__c();
                objMCD.Name = chipsDRT.subStringBefore(':');
                objMCD.DRT_Chip__c = true;
                objMCD.DRT_Id__c = chipsDRT.subStringAfter(':');
                objMCD.MRS__c = mapPTRFIdsToMRSIds.get(mapDRTToPTRFIds.get(objMCD.DRT_Id__c));
                objMCD.PTRF_Id__c = mapDRTToPTRFIds.get(objMCD.DRT_Id__c); //Internal Sanity Check
                lstMRSCDInsert.add(objMCD);
            }
        }
        
        if (lstMRSCDInsert.size() > 0) {
            executeInsertMCD(lstMRSCDInsert);
            for (MRS_Chip_Details__c objMCD: lstMRSCDInsert) {
                for (String layerId: setLayerMRSIds) {
                    String actualLayer = layerId.substringBefore(':');
                    String layerIdentifier = mapLayerIdToUniqueIdentifier.get(actualLayer); //TASK2132/TASK2140
                    if (mapLayerIdToUniqueIdentifier.containsKey(actualLayer) && setDRTUniqueLayers.contains(layerIdentifier) && mapDRTLayerToChipNames.containsKey(layerIdentifier) && mapDRTLayerToChipNames.get(layerIdentifier).contains(objMCD.Name)) { //TASK-2132/TASK-2140  
                        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
                        /** Populating values for DRT Chip records in MRS Layer Chip Association **/
                        obj.Chip__c = objMCD.Id;
                        obj.Layer__c = layerId.substringBefore(':');
                        obj.PTRF__c = mapLayerPTRFIds.get(obj.Layer__c);
                        obj.PTRF_Or_DRT__c = 'DRT';
                        obj.DRT__c = objMCD.DRT_Id__c;
                        obj.Tech_Geo__c = mapLayerTechGeos.get(obj.Layer__c);
                        obj.Customer_Name__c = mapLayerCustomerIds.get(obj.Layer__c);
                        obj.Device_Id__c = mapLayerDeviceIds.get(obj.Layer__c);
                        if (objMCD.Name == 'Frame') {
                            obj.Prime_MEBES_Received__c = 'N.A.';
                            obj.Frame_MEBES_Received__c = 'Not Done';
                        } else {
                            obj.Prime_MEBES_Received__c = 'Not Done';
                            obj.Frame_MEBES_Received__c = 'N.A.';
                        }
                        obj = setDRTLayerChipDefaultValues(obj);
                        lstMRSLCAInsert.add(obj);
                    }
                }
            }
            if (lstMRSLCAInsert.size() > 0) {
                executeInsertMCLA(lstMRSLCAInsert);
            }
        }
    }

    /**
        This method is for cancelling Layer and chips of DRT when a DRT is deleted from DRT PTRF Association table. 
        @method name: cancelDRTChipsInMRS
        @parameter:   1. Set of PTRF Ids.
                      2. Set of DRT Ids.
        @return :     None.
     **/

    public static void cancelDRTChipsInMRS(set < String > setPTRFIds, set < String > setDRTIds) {
        set < String > setDRTIdsInMRS = new set < String > ();
        set < String > setDRTIdsNOTInMRS = new set < String > ();
        set < String > setMRSLayerAssoIds = new set < String > ();
        list < MRS_Layer_Chip_Association__c > lstMRSLCA = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Association__c > lstLayers = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Association__c > lstLayersUpdated = new list < MRS_Layer_Association__c > ();
        map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToChips = new map < String, List < MRS_Layer_Chip_Association__c >> ();
        set < String > setCancelledLayerIds = new set < String > (); //TASK-2132/TASK-2140
        for (MRS_Layer_Chip_Association__c objMCLA: [select PTRF__c, DRT__c, Layer_Chip_Status__c, Chip__r.Name, PTRF_Or_DRT__c, Layer__c from MRS_Layer_Chip_Association__c
        where PTRF__c IN: setPTRFIds AND PTRF_Or_DRT__c = 'PTRF']) { //TASK-2132/TASK-2140                            
            setCancelledLayerIds.add(objMCLA.Layer__c); //TASK-2132/TASK-2140              
        }
        setDRTIdsNOTInMRS.addAll(retrieveDRTChipsInMRS(setPTRFIds, setCancelledLayerIds, 'Cancel')); //TASK-2132/TASK-2140
        if (setDRTIdsNOTInMRS.size() > 0) {
            for (MRS_Layer_Chip_Association__c obj: [Select Id, DRT__c, PTRF__c, Layer_Chip_Status__c, Layer__c from MRS_Layer_Chip_Association__c where DRT__c IN: setDRTIds
            AND Layer__c IN: setLayersToBeCancelled]) { //TASK-2132/TASK-2140
                obj.Layer_Chip_Status__c = 'Cancel';
                lstMRSLCA.add(obj);
            }
            if (lstMRSLCA.size() > 0) {
                executeUpdateMCLA(lstMRSLCA);
                for (MRS_Layer_Chip_Association__c obj: lstMRSLCA) {
                    setMRSLayerAssoIds.add(obj.Layer__c);
                }
                if (setMRSLayerAssoIds.size() > 0) {
                    lstLayers.addAll(retrieveLayerDetails(setMRSLayerAssoIds));
                    mapLayerIdsToChips.putAll(retrieveLayerChipDetails(setMRSLayerAssoIds));
                    if (lstLayers.size() > 0 && mapLayerIdsToChips.size() > 0) {
                        lstLayersUpdated.addAll(calculateLayerStatus(lstLayers, mapLayerIdsToChips));
                        if (lstLayersUpdated.size() > 0 && lstLayersUpdated.size() > 0) {
                            executeUpdateMLA(lstLayersUpdated);
                        }
                    }
                }
            }
        }
        linkDRTChipsToActivePTRF(lstMRSLCA, setPTRFIds, setDRTIds); //SWGP-194
    }

    /*
    * @description This method is called to relink DRT chips in case of PTRF cancellation or DRT deselection
            PTRF cancellation: drtIDs is an empty set
            DRT deselection: drtIDs is not empty (because when this method is called the DRT has been removed from the PTRF so we need to pass drtIDs as parameter)
    * @param 
    * @return 
    */
    public static void linkDRTChipsToActivePTRF(List < MRS_Layer_Chip_Association__c > cancelledChips, Set < String > ptrfIDs, Set < String > drtIDs) {
        try {
            if (ptrfIDs == null || ptrfIDs.isEmpty()) return;

            Set < ID > cancelledChipIDs = new Set < ID > ();
            for (MRS_Layer_Chip_Association__c c: cancelledChips) {
                cancelledChipIDs.add(c.ID);
            }

            Set < String > relatedDRTIDs = new Set < String > ();
            if (!drtIDs.isEmpty()) { //DRT deselection
                relatedDRTIDs.addAll(drtIDs);
            } else { //PTRF cancellation
                for (DRT_PTRF_Association__c assoc: [select PTRF__c, PTRF__r.Name, PTRF__r.Status__c, DRT__r.Name from DRT_PTRF_Association__c
                where PTRF__c IN: ptrfIDs]) {
                    relatedDRTIDs.add(assoc.DRT__c);
                }
            }

            List < MRS_Layer_Chip_Association__c > activeDRTChips = [Select ID, Mask_Layer__c, Rev__c, Rom_code__c, Mask_Set_Title_Name__c, DRT__r.Name
            from MRS_Layer_Chip_Association__c
            where PTRF__c IN: ptrfIDs and ID NOT IN: cancelledChipIDs
            and PTRF_Or_DRT__c = 'DRT'
            and Layer_Chip_Status__c != 'Cancel'];

            if (activeDRTChips.isEmpty()) return;

            //Map of key (MST + DRT name + Layer # + Layer Rev + Rom Code) - List of DRT chip 
            Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerToChips = new Map < String, List < MRS_Layer_Chip_Association__c >> ();

            String key;
            List < MRS_Layer_Chip_Association__c > tempChips;
            for (MRS_Layer_Chip_Association__c chip: activeDRTChips) {
                key = chip.DRT__r.Name + chip.Mask_Layer__c + chip.Rev__c + (chip.Rom_code__c == null ? '' : chip.Rom_code__c);
                if (!mapLayerToChips.containsKey(key)) {
                    mapLayerToChips.put(key, new List < MRS_Layer_Chip_Association__c > {
                        chip
                    });
                } else {
                    tempChips = mapLayerToChips.get(key);
                    tempChips.add(chip);
                    mapLayerToChips.put(key, tempChips);
                }
            }

            //Map of key (MST + DRT name + Layer # + Layer Rev + Rom Code) - List of PTRF in which layer is tapeout & DRT is associated 
            Map < String, List < PTRF__c >> mapLayerToPTRFs = new Map < String, List < PTRF__c >> ();
            Set < String > setActivePTRFIDs = new Set < String > ();
            List < PTRF__c > tempPTRFs;

            List < DRT_PTRF_Association__c > relatedDRTPTRFAssocs = [select PTRF__c, PTRF__r.Name, PTRF__r.Status__c, DRT__r.Name from DRT_PTRF_Association__c
            where PTRF__c not in : ptrfIDs and DRT__c in : relatedDRTIDs
            and PTRF__r.Status__c = 'Perform Tapeout Options'
            order by PTRF__r.createddate];
            for (DRT_PTRF_Association__c obj: relatedDRTPTRFAssocs) {
                setActivePTRFIDs.add(obj.PTRF__c);
            }

            List < PTRF__c > activePTRFs = [Select Id, Name, (Select Mask_Layer_Number__c, Mask_Layer_Rev__c, Rom_code__c from Mask_Layers__r where Tapeout__c = true)
            from PTRF__c where ID IN: setActivePTRFIDs order by createddate];
            for (DRT_PTRF_Association__c assoc: relatedDRTPTRFAssocs) {
                for (PTRF__c ptrf: activePTRFs) {
                    if (assoc.PTRF__r.Name == ptrf.Name) {
                        for (Mask_Layer__c layer: ptrf.Mask_Layers__r) {
                            key = assoc.DRT__r.Name + layer.Mask_Layer_Number__c + layer.Mask_Layer_Rev__c + (layer.Rom_code__c == null ? '' : layer.Rom_code__c);
                            if (!mapLayerToPTRFs.containsKey(key)) {
                                mapLayerToPTRFs.put(key, new List < PTRF__c > {
                                    ptrf
                                });
                            } else {
                                tempPTRFs = mapLayerToPTRFs.get(key);
                                tempPTRFs.add(ptrf);
                                mapLayerToPTRFs.put(key, tempPTRFs);
                            }
                        }
                    }
                }
            }
            //Link Active DRT Chips to first active PTRF
            List < MRS_Layer_Chip_Association__c > chipsToUpdate = new List < MRS_Layer_Chip_Association__c > ();
            for (String k: mapLayerToChips.keySet()) {
                if (mapLayerToPTRFs.containsKey(k)) {
                    for (MRS_Layer_Chip_Association__c chip: mapLayerToChips.get(k)) {
                        chip.PTRF__c = mapLayerToPTRFs.get(k).get(0).ID;
                        chipsToUpdate.add(chip);
                    }
                }
            }

            update chipsToUpdate;
        } catch (Exception ex) {
            MRSHandlerUtilityExtn.logException(ex, 'MRSHandlerUtilityExtn', 'linkDRTChipsToActivePTRF');
        }
    }

    /**
        This set of future and real-time methods is for cancelling chips of older revision of DRT from MRS and adding chips of newer revision of DRT to MRS,
        when a DRT goes uprev and the newer revision of DRT is made Active.
        @method name: uprevDRTChipsInMRSFuture/uprevDRTChipsInMRS
        @parameter:   1. Set of PTRF Ids.
                      2. Set of Prime DRT Ids.
                      3. Set of Frame DRT Ids.
                      4. Map of Old to New DRT Ids.                   
        @return :     None.
     **/

    @future
    public static void uprevDRTChipsInMRSFuture(set < String > setPTRFIds, set < String > setPrimeDRTIds, set < String > setFrameDRTIds, map < String, String > mapOldToNewDRTIds) {
        uprevDRTChipsInMRS(setPTRFIds, setPrimeDRTIds, setFrameDRTIds, mapOldToNewDRTIds);
    }

    public static void uprevDRTChipsInMRS(set < String > setPTRFIds, set < String > setPrimeDRTIds, set < String > setFrameDRTIds, map < String, String > mapOldToNewDRTIds) {
        /*
        SWGP-349
        - from layer chip cancel list
        - build a map of cancel layer chip which key = ptrf id + layer id + rom code (if have)
        - when construct a new list of drt chip to insert -> copy value of old chip
        =====
        18-Apr-2016
        SWGP-677: bug fix from SWGP-349: to remove PTRF from unique_KEY to cater for condition
            when new revised drt chip is not generated in the same ptrf but different
        */
        list < MRS_Chip_Details__c > lstMRSCDInsert = new list < MRS_Chip_Details__c > ();
        list < MRS_Layer_Chip_Association__c > lstMRSLCAUpdate = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Chip_Association__c > lstMRSLCAInsert = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Association__c > lstLayers = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Association__c > lstLayersUpdated = new list < MRS_Layer_Association__c > ();
        set < String > setDRTChips = new set < String > ();
        set < String > setLayerDRTIds = new set < String > ();
        set < String > setMRSLayerAssoIds = new set < String > ();
        set < String > setLayerUniqueIdentifiers = new set < String > ();
        set < String > setDRTUniqueLayers = new set < String > ();
        map < String, String > mapDRTToPTRFIds = new map < String, String > (); //Internal Sanity Check       
        map < String, String > mapLayerTechGeos = new map < String, String > ();
        map < String, String > mapLayerCustomerIds = new map < String, String > ();
        map < String, String > mapLayerPTRFIds = new map < String, String > ();
        map < String, String > mapLayerDeviceIds = new map < String, String > ();
        map < String, String > mapDRTIdsToMRSIds = new map < String, String > ();
        map < String, String > mapLayerIdToUniqueIdentifier = new map < String, String > ();
        map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToChips = new map < String, List < MRS_Layer_Chip_Association__c >> ();
        //SWGP-349
        map < String, MRS_Layer_Chip_Association__c > mapOldDRTLayerChip = new map < String, MRS_Layer_Chip_Association__c > ();
        //END-SWGP-349
        
        for (MRS_Layer_Chip_Association__c obj: [
            select Id, DRT__c, Layer_Chip_Status__c, Layer__c, Tech_Geo__c, Layer__r.MRS__c, Customer_Name__c, chip__r.name,
            Layer__r.Name, Layer__r.Mask_Layer_Rev__c, Layer__r.ROM_Code__c, Layer__r.MRS__r.Mask_Set_Title__c, Device_Id__c, PTRF__c,
            Prime_MEBES_Received__c, Frame_MEBES_Received__c, Last_Sync_Req_Timestamp_Receive_MEBES__c,
            Last_Sync_Req_Timestamp_Remote_JobCust__c, Last_Sync_Req_Timestamp_Remote_Jobview__c,
            Customer_Prime_Remote_Jobview_Setup__c, Customer_Frame_Remote_Jobview_Setup__c,
            Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c
            from MRS_Layer_Chip_Association__c
            where DRT__c IN: mapOldToNewDRTIds.keySet()]) 
        {
                obj.Layer_Chip_Status__c = 'Cancel';
                lstMRSLCAUpdate.add(obj);
                //SWGP-349
                String drtRomCode = String.isBlank(obj.layer__r.rom_code__c) ? '' : obj.layer__r.rom_code__c;
                mapOldDRTLayerChip.put(obj.Layer__c + '' + obj.chip__r.name + drtRomCode, obj);
                //END-SWGP-349
        }
        
        
        //SWGP-87
        Map < String, String > mapPTRFToMRSIds = new Map < String, String > ();
        for (PTRF__c ptrf: [Select MaskSetTitle__c from PTRF__c where ID IN: setPTRFIds]) {
            mapPTRFToMRSIds.put(ptrf.ID, ptrf.MaskSetTitle__c);
        }
        
        
        for (MRS__c mrs: [Select Id, Mask_Set_Title__c from MRS__c where Mask_Set_Title__c IN: mapPTRFToMRSIds.values()]) {
            for (String ptrfId: mapPTRFToMRSIds.keySet()) {
                if (mapPTRFToMRSIds.get(ptrfId) == mrs.Mask_Set_Title__c) {
                    mapPTRFToMRSIds.put(ptrfId, mrs.ID);
                }
            }
        }
        
        
        for (DRT_PTRF_Association__c assoc: [select Id, DRT__c, PTRF__c from DRT_PTRF_Association__c
        where PTRF__c IN: setPTRFIds]) {
            mapDRTToPTRFIds.put(mapOldToNewDRTIds.get(assoc.DRT__c), assoc.PTRF__c);
            mapDRTIdsToMRSIds.put(assoc.DRT__c, mapPTRFToMRSIds.get(assoc.PTRF__c));
        }
        
        
        //SWGP-87
        for (MRS_Layer_Chip_Association__c obj: [Select Id, DRT__c, Layer_Chip_Status__c, Layer__c, Tech_Geo__c, Layer__r.MRS__c, Customer_Name__c,
        Layer__r.Name, Layer__r.Mask_Layer_Rev__c, Layer__r.ROM_Code__c, Layer__r.MRS__r.Mask_Set_Title__c, Device_Id__c, PTRF__c from
        MRS_Layer_Chip_Association__c where PTRF__c IN: setPTRFIds]) {
            setLayerDRTIds.add(obj.Layer__c);
            mapLayerPTRFIds.put(obj.Layer__c, obj.PTRF__c);
            mapLayerTechGeos.put(obj.Layer__c, obj.Tech_Geo__c);
            mapLayerCustomerIds.put(obj.Layer__c, obj.Customer_Name__c);
            mapLayerDeviceIds.put(obj.Layer__c, obj.Device_Id__c);
            String layerUnique;
            if (obj.Layer__r.ROM_Code__c != null && obj.Layer__r.ROM_Code__c != '') {
                layerUnique = obj.Layer__r.MRS__r.Mask_Set_Title__c + obj.Layer__r.Name + obj.Layer__r.Mask_Layer_Rev__c + obj.Layer__r.ROM_Code__c;
            } else {
                layerUnique = obj.Layer__r.MRS__r.Mask_Set_Title__c + obj.Layer__r.Name + obj.Layer__r.Mask_Layer_Rev__c;
            }
            setLayerUniqueIdentifiers.add(layerUnique);
            mapLayerIdToUniqueIdentifier.put(obj.Layer__c, layerUnique);
        }
        
        
        if (lstMRSLCAUpdate.size() > 0) { executeUpdateMCLA(lstMRSLCAUpdate); }
        
        
        /** Adding Prime DRT Chips To MRS **/
        if (setPrimeDRTIds != null && setPrimeDRTIds.size() > 0) {
            for (PRIME_DRT_Chip_Layer_Summary__c objPDCLS: [Select Layer__r.DRT__c, Chip_Name__c, Mask_Layer_Rev__c, ROM_Code__c, Layer__r.Retrofit_Mask_Rev__c,
            Layer__r.Retrofit_ROM_Code__c, Layer__r.Name, Layer__r.Mask_Set_Title__c, 
            
            //swgp-600 : comparing based mst and retrofit mst
            chip__r.Mask_Set_Title__c,chip__r.DRT__r.Mask_Set_Title__c
            //swgp-600_END
            
            from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.IsSoftDeleted__c = False and Layer__r.IsSoftDeleted__c = False and Layer__r.DRT__c IN: setPrimeDRTIds]) {
                String layerUnique;
                if (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != '') {
                    layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c + objPDCLS.Layer__r.Retrofit_ROM_Code__c;
                } else {
                    layerUnique = objPDCLS.Layer__r.Mask_Set_Title__c + objPDCLS.Layer__r.Name + objPDCLS.Layer__r.Retrofit_Mask_Rev__c;
                }
                
                
                setDRTUniqueLayers.add(layerUnique);
                
                
                if (setLayerUniqueIdentifiers != null && setLayerUniqueIdentifiers.contains(layerUnique)) {
                    /****************************************************************/
                    /****************************************************************/ 
                    /*SWGP-600 retro_rev = rev*/                   
                    if (
                        (objPDCLS.Mask_Layer_Rev__c != objPDCLS.Layer__r.Retrofit_Mask_Rev__c) //this line to be modified for swgp-600, if based_mst != retro_mst => ignore rev check
                        || 
                        (
                            (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c != objPDCLS.Layer__r.Retrofit_ROM_Code__c) 
                            || 
                            (objPDCLS.ROM_Code__c != null && objPDCLS.Layer__r.Retrofit_ROM_Code__c == null) 
                            || 
                            (objPDCLS.Layer__r.Retrofit_ROM_Code__c != null && objPDCLS.ROM_Code__c == null)
                        )
                        //swgp-600: based mst != retrofit mst >> ignore rev
                        ||
                        (
                            objPDCLS.chip__r.Mask_Set_Title__c != objPDCLS.chip__r.DRT__r.Mask_Set_Title__c //based mst != retrofit mst >> ignore rev/retro_rev
                        )
                    ) { //=======
                        setDRTChips.add(objPDCLS.Chip_Name__c + ':' + objPDCLS.Layer__r.DRT__c);
                    } //=======
                    /****************************************************************/
                    /****************************************************************/
                }
            }
        }
        
        
        /** Adding Frame DRT Chips To MRS **/
        if (setFrameDRTIds != null && setFrameDRTIds.size() > 0) {
            //swgp-600 issue 2
            for (Frame_DRT_Association__c objFDA: [Select Mask_Layer_No__c,  DRT__c, Mask_Rev__c, ROM_Code__c, Retrofit_Mask_Rev__c,
            Retrofit_ROM_Code__c ,
            
            //swgp-600 : comparing based mst and retrofit mst
            drt__r.Mask_Set_Title__c,//retrofit MST
            Mask_Set_Title__c //based MST (could belong to another device)
            //swgp-600_END
            
            from Frame_DRT_Association__c where DRT__c IN: setFrameDRTIds]) {
                
                String layerUnique;
                if (objFDA.Retrofit_ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != '') {
                    layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c + objFDA.Retrofit_ROM_Code__c;
                } else {
                    layerUnique = objFDA.drt__r.Mask_Set_Title__c + objFDA.Mask_Layer_No__c + objFDA.Retrofit_Mask_Rev__c;
                }
                
                setDRTUniqueLayers.add(layerUnique);
                
                if (setLayerUniqueIdentifiers != null && setLayerUniqueIdentifiers.contains(layerUnique)) {
                    /****************************************************************/
                    /****************************************************************/ 
                    /*SWGP-600 retro_rev = rev*/
                    if (
                            (objFDA.Mask_Rev__c != objFDA.Retrofit_Mask_Rev__c) //this line to be modified for swgp-600, if based_mst != retro_mst => ignore rev check
                            || 
                            (
                                (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c != objFDA.Retrofit_ROM_Code__c) 
                                || 
                                (objFDA.ROM_Code__c != null && objFDA.Retrofit_ROM_Code__c == null) 
                                || 
                                (objFDA.Retrofit_ROM_Code__c != null && objFDA.ROM_Code__c == null)
                             )
                             //swgp-600: based mst != retrofit mst >>> ignore rev
                             ||
                             (                             
                                objFDA.drt__r.Mask_Set_Title__c != objFDA.Mask_Set_Title__c //based mst != retrofit mst >> ignore rev/retro_rev
                             )
                    ) { //=======
                        setDRTChips.add('Frame:' + objFDA.DRT__c);
                    } //=======
                    /****************************************************************/
                    /****************************************************************/
                }
            }
        }
        
        if (setDRTChips.size() > 0) {
            
            for (String chipsDRT: setDRTChips) {
                MRS_Chip_Details__c objMCD = new MRS_Chip_Details__c();
                objMCD.Name = chipsDRT.subStringBefore(':');
                objMCD.MRS__c = mapDRTIdsToMRSIds.get(chipsDRT.subStringAfter(':'));
                objMCD.DRT_Chip__c = true;
                objMCD.DRT_Id__c = chipsDRT.subStringAfter(':');
                objMCD.PTRF_Id__c = mapDRTToPTRFIds.get(objMCD.DRT_Id__c); //Internal Sanity Check
                lstMRSCDInsert.add(objMCD);
            }
        }
        
        if (lstMRSCDInsert.size() > 0) {
            
            executeInsertMCD(lstMRSCDInsert);
            
            for (MRS_Chip_Details__c objMCD: lstMRSCDInsert) {
                
                for (String layerId: setLayerDRTIds) {
                    
                    if (mapLayerIdToUniqueIdentifier.containsKey(layerId) && setDRTUniqueLayers.contains(mapLayerIdToUniqueIdentifier.get(layerId))) {

                        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
                        /** Populating values for DRT Chip records in MRS Layer Chip Association **/
                        obj.Chip__c = objMCD.Id;
                        obj.Layer__c = layerId;
                        obj.PTRF__c = mapLayerPTRFIds.get(obj.Layer__c);
                        obj.PTRF_Or_DRT__c = 'DRT';
                        obj.DRT__c = objMCD.DRT_Id__c;
                        obj.Tech_Geo__c = mapLayerTechGeos.get(obj.Layer__c);
                        obj.Customer_Name__c = mapLayerCustomerIds.get(obj.Layer__c);
                        obj.Device_Id__c = mapLayerDeviceIds.get(obj.Layer__c);
                        
                        if (objMCD.Name == 'Frame') {
                            obj.Prime_MEBES_Received__c = 'N.A.';
                            obj.Frame_MEBES_Received__c = 'Not Done';
                        } else {
                            obj.Prime_MEBES_Received__c = 'Not Done';
                            obj.Frame_MEBES_Received__c = 'N.A.';
                        }

                        obj = setDRTLayerChipDefaultValues(obj);

                        //SWGP-349: copy value from old chip to new chip in case ws call have been received
                        String drtRomCode = String.isBlank(obj.layer__r.rom_code__c) ? '' : obj.layer__r.rom_code__c;
                        String uniqueKey = /*obj.PTRF__c + '' + SWGP-677-to-remove-ptrf-from-key*/ obj.Layer__c + '' + objMCD.Name + drtRomCode;
                        
                        
                        if (mapOldDRTLayerChip.containsKey(uniqueKey)) {
                            
                            //copy mebes received
                            if (null != mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Receive_MEBES__c) {
                                obj.Last_Sync_Req_Timestamp_Receive_MEBES__c = mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Receive_MEBES__c;
                            }
                            
                            obj.Prime_MEBES_Received__c = mapOldDRTLayerChip.get(uniqueKey).Prime_MEBES_Received__c;
                            obj.Frame_MEBES_Received__c = mapOldDRTLayerChip.get(uniqueKey).Frame_MEBES_Received__c;

                            //copy rjv
                            if (null != mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Remote_JobCust__c) {
                                obj.Last_Sync_Req_Timestamp_Remote_JobCust__c = mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Remote_JobCust__c;
                            }
                            
                            if (null != mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Remote_Jobview__c) {
                                obj.Last_Sync_Req_Timestamp_Remote_Jobview__c = mapOldDRTLayerChip.get(uniqueKey).Last_Sync_Req_Timestamp_Remote_Jobview__c;
                            }
                            
                            obj.Customer_Prime_Remote_Jobview_Setup__c = mapOldDRTLayerChip.get(uniqueKey).Customer_Prime_Remote_Jobview_Setup__c;
                            obj.Customer_Frame_Remote_Jobview_Setup__c = mapOldDRTLayerChip.get(uniqueKey).Customer_Frame_Remote_Jobview_Setup__c;
                            obj.Foundry_Prime_Remote_Jobview_Setup__c = mapOldDRTLayerChip.get(uniqueKey).Foundry_Prime_Remote_Jobview_Setup__c;
                            obj.Foundry_Frame_Remote_Jobview_Setup__c = mapOldDRTLayerChip.get(uniqueKey).Foundry_Frame_Remote_Jobview_Setup__c;
                        }
                        //END-SWGP-349

                        lstMRSLCAInsert.add(obj);
                    }
                }
            }
            
            if (lstMRSLCAInsert.size() > 0) { executeInsertMCLA(lstMRSLCAInsert); }
        }
    }

    /**
        This method is for setting MRS Layer Chip Association values for DRT chips added in MRS. 
        @method name: setDRTLayerChipDefaultValues
        @parameter:   MRS Layer Chip Association record.
        @return :     MRS Layer Chip Association record.
     **/
    public static MRS_Layer_Chip_Association__c setDRTLayerChipDefaultValues(MRS_Layer_Chip_Association__c obj) {
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Customer_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Foundry_MEBES_Jobview__c = 'N.A.';
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
        obj.MDP_MEBES_Jobview__c = 'N.A.';
        obj.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
        obj.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
        obj.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
        obj.Send_Prime_Data__c = 'N.A.';
        obj.Send_Frame_Data__c = 'N.A.';
        obj.ORC__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'N.A.';
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'N.A.';
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'N.A.';
        obj.DRW__c = 'N.A.';
        return obj;
    }

    /**
        This method is for recalculating MRS Layer Association values in the first time the MRS Layer Association record is created. 
        @method name: setMRSLayerRecalculatedValuesOnLayerCreation
        @parameter:   Set of MRS Layer Association Ids.
        @return :     None.
     **/

    public static void setMRSLayerRecalculatedValuesOnLayerCreation(set < String > setLayerIds) {
        List < MRS_Layer_Association__c > lstMRSLayers = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        lstMRSLayers.addAll(retrieveLayerDetails(setLayerIds));
        mapLayerIdToLayerChips.putAll(retrieveLayerChipDetails(setLayerIds));
        if (lstMRSLayers != null && lstMRSLayers.size() > 0) {
            lstMRSLayersUpdated.addAll(calculateLayerStatus(lstMRSLayers, mapLayerIdToLayerChips));
            if (lstMRSLayersUpdated != null && lstMRSLayersUpdated.size() > 0) {
                executeUpdateMLA(lstMRSLayersUpdated);
            }
        }
    }

    /**
        This method is for recalculating MRS Layer Association values when the MRS Layer Association record is updated. 
        @method name: setMRSLayerRecalculatedValuesOnLayerUpdate
        @parameter:   1. Set of MRS Layer Association Ids.
                      2. Map of Layer Ids to List of Layer Chip Records.
                      3. Set of MRS Layer Chip Association Ids retrieved in Trigger.New
        @return :     None.
     **/

    public static void setMRSLayerRecalculatedValuesOnLayerUpdate(set < String > setLayerIds, Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips, set < String > setLayerChipIds) {
        List < MRS_Layer_Association__c > lstMRSLayers = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapTemp = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        lstMRSLayers.addAll(retrieveLayerDetails(setLayerIds));
        mapTemp.putAll(retrieveLayerChipDetailsForUpdate(setLayerIds, setLayerChipIds));
        if (mapTemp.size() > 0) {
            for (String layerId: mapTemp.keySet()) {
                List < MRS_Layer_Chip_Association__c > tempList = new List < MRS_Layer_Chip_Association__c > ();
                if (mapLayerIdToLayerChips.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdToLayerChips.get(layerId));
                }
                tempList.addAll(mapTemp.get(layerId));
                mapLayerIdToLayerChips.put(layerId, tempList);
            }
        }
        if (lstMRSLayers != null && lstMRSLayers.size() > 0) {
            lstMRSLayersUpdated.addAll(calculateLayerStatus(lstMRSLayers, mapLayerIdToLayerChips));
            if (lstMRSLayersUpdated != null && lstMRSLayersUpdated.size() > 0) {
                executeUpdateMLA(lstMRSLayersUpdated);
            }
        }
    }

    /**
        This method is for recalculating MRS Layer Association values when the MRS Layer Association record is updated with Layer Chip Status as Void or Cancel. 
        @method name: setMRSLayerRecalculatedValuesForVoidCancel
        @parameter:   1. Set of MRS Layer Association Ids.
                      2. Map of Layer Ids to List of Layer Chip Records.
                      3. Set of MRS Layer Chip Association Ids retrieved in Trigger.New
        @return :     None.
     **/

    public static void setMRSLayerRecalculatedValuesForVoidCancel(set < String > setLayerIdsVoidCancel, Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToChipsVoidCancel, set < String > setLayerChipIds) {
        List < MRS_Layer_Association__c > lstLayersVoidCancel = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapTemp = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        lstLayersVoidCancel.addAll(retrieveLayerDetails(setLayerIdsVoidCancel));
        mapTemp.putAll(retrieveLayerChipDetailsForVoidCancelStatus(setLayerIdsVoidCancel, setLayerChipIds));
        if (mapTemp.size() > 0) {
            for (String layerId: mapTemp.keySet()) {
                List < MRS_Layer_Chip_Association__c > tempList = new List < MRS_Layer_Chip_Association__c > ();
                if (mapLayerIdsToChipsVoidCancel.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdsToChipsVoidCancel.get(layerId));
                }
                tempList.addAll(mapTemp.get(layerId));
                mapLayerIdsToChipsVoidCancel.put(layerId, tempList);
            }
        }
        if (lstLayersVoidCancel.size() > 0 && mapLayerIdsToChipsVoidCancel.size() > 0) {
            lstMRSLayersUpdated.addAll(setLayerStatusForVoidCancelStatus(lstLayersVoidCancel, mapLayerIdsToChipsVoidCancel));
            if (lstMRSLayersUpdated.size() > 0) {
                executeUpdateMLA(lstMRSLayersUpdated);
            }
        }
    }

    /**
        This method is for retrieving MRS Layer Chip Association records corresponding to a combination of Customer and Mask Set Title in
        GDSOUT Review, Frame Mockup and MEBES Jobview screens. 

        @method name: 
        ChipLayerSummary
        @return :     List of retrieved MRS Layer Chip Association records.
     **/

    public static List < MRS_Layer_Chip_Association__c > getMrsChipLayerSummary(String customerId, String mstId, String layerId, String layerStatus, String deviceId, String layerOrChipStatus, String frameIdOrChipId, String ptrf, String page, Boolean isJobViewer /*,Boolean isFirstTime*/ ) {

        Boolean flag = true;
        String drt = null;
        String chipName = Label.SWIFT_Frame_Status;
        String Customer = 'Customer';
        String Foundry = 'Foundry';
        String frameMockUpReview = 'Frame Mockup';
        String customerGDSOUTReview = 'Prime GDSOUT Review';
        List < Id > ptrfIdlst = new List < Id > ();

        //swgp-602: lift Hold from NOT IN filter
        set < String > setOfLCStatus = new set < String > {'Cancel', 'Void'};
        
        set < String > setOfLCFrameStatus = new set < String > {'Not Ready', 'In Progress', 'Released', 'Pending Foundry Release', 'Shipped'};
        
        //swgp-602: lift Hold from NOT IN filter
        set < String > setOfStatus = new set < String > {'N.A.', 'Released', 'Shipped'};
        String PTRForDRT = 'DRT';

        Boolean performApproval = false;
        Id userId = UserInfo.getUserId();
        set < String > setLoggedInUserGroups = new set < String > ();
        setLoggedInUserGroups.addAll(fetchCurrentUserGroup(userId));
        String[] layerStatusArray;
        if (layerStatus != null) {
            if (layerStatus.contains(',')) {
                layerStatusArray = layerStatus.split(',');
            } else {
                layerStatusArray = new String[1];
                layerStatusArray[0] = layerStatus;
            }
        }

        Boolean isUserMEBES = false;
        Boolean isUserGlobalShuttle = false;
        Boolean isUserTDTIMPW = false;
        Boolean isUserMDP = false;
        Boolean isUserAdmin = false;
        Boolean isTapeOutCenter = false;
        Boolean isGroupUser = false;
        if (setLoggedInUserGroups.size() > 0) {
            for (String userGroup: setLoggedInUserGroups) {
                if (userGroup.equalsIgnoreCase('Swift_GlobalShuttle') || userGroup.equalsIgnoreCase('Swift_TDTI_MPW') || userGroup.equalsIgnoreCase('Swift_MDP') || userGroup.equalsIgnoreCase('Swift_Tapeout_Centre') || userGroup.equalsIgnoreCase('Swift_Tapeout_Application') || userGroup.equalsIgnoreCase('Swift_Tapeout_Operations') || userGroup.equalsIgnoreCase('SWIFT_Admin') || userGroup.equalsIgnoreCase('Swift_RMG') || userGroup.equalsIgnoreCase('SWIFT_Support')) {

                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_GT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserGlobalShuttle = true;
                        performApproval = true;
                        isGroupUser = true;
                    }
                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserTDTIMPW = true;
                        performApproval = true;
                        isGroupUser = true;
                    }
                    if (Environment_Variable__c.getInstance('TECH_GEO_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserMDP = true;
                        performApproval = true;
                        isGroupUser = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isUserAdmin = true;
                        performApproval = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_NO_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isTapeOutCenter = true;
                        performApproval = true;
                    }
                }
            }
        }
        Set < Id > ptrfIdSt = new Set < Id > ();
        List < String > teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        List < Account_Team_Proxy__c > accTeamProxy = [Select Id, Account__c, User__c, Team_Role__c FROM Account_Team_Proxy__c WHERE User__c = : UserInfo.getUserId() AND Account__c = : customerId AND Team_Role__c IN: teamRole AND User__r.IsActive = true];

        if (accTeamProxy != null && accTeamProxy.size() > 0 && (page != 'Foundry MEBES')) //TASK-2115
        {

            isUserAdmin = true;
            performApproval = true;
        } else if (isUserAdmin) {
            performApproval = true;
        } else if (isUserMEBES && (page.contains('MEBES'))) {
            performApproval = true;
        } else {
            String jobView = 'SELECT Jobview__c,Jobview_Type__c,PTRF__c,PTRF__r.Customer__c FROM PTRF_JobViewer_Info__c WHERE Jobview_Type__c';
            if (page == 'CustomerFrameMockup' || page == 'FoundryFrameMockup') {
                jobView = jobView + ' INCLUDES (\'Frame Mockup\')';
            }
            if (page == 'CustomerGDSOutReview' || page == 'FoundryGDSOutReview') {
                jobView = jobView + ' INCLUDES (\'Prime GDSOUT Review\')';
            }
            if (page.contains('MEBES')) {
                jobView = jobView + ' INCLUDES (\'MEBES Jobview\')';
                if (page.contains('Customer')) {
                    jobView = jobView + ' AND Jobview__c= :Customer';
                } else if (page.contains('Foundry')) {
                    jobView = jobView + ' AND Jobview__c= :Foundry';
                }

            }
            if (page == 'CustomerFrameMockup' || page == 'CustomerGDSOutReview') {
                jobView = jobView + ' AND Jobview__c= :Customer';
            } else if (page == 'FoundryFrameMockup' || page == 'FoundryGDSOutReview') {
                jobView = jobView + ' AND Jobview__c= :Foundry';
            }
            jobView = jobView + ' AND User__c= :userId';
            jobView = jobView + ' AND PTRF__r.Customer__c= :customerId';
            if (isJobViewer) {
                if (mstId != null && mstId.trim() != '') {
                    jobView = jobView + ' AND PTRF__r.MaskSetTitle__c= :mstId';
                }
            }
            
            List < PTRF_JobViewer_Info__c > ptrfJobView = Database.Query(jobView);
            if (ptrfJobView != null && ptrfJobView.size() > 0) {
                performApproval = true;

                for (PTRF_JobViewer_Info__c prtrd: ptrfJobView) {
                    ptrfIdlst.add(prtrd.PTRF__c);
                }
            }
        }
        String cancelledChip = 'Cancel';
        String frameStatus = 'Disapprove';

        //, 'Hold'//swgp-602
        set < String > setReleased = new set < String > {'N.A.', 'Released', 'Shipped'};

        String lstmrsLayerChipAsso = '';

        if (page == 'CustomerGDSOutReview' || page == 'FoundryGDSOutReview') {
            lstmrsLayerChipAsso = 'SELECT  Chip__c,Chip__r.Name,\n' +
                'Customer_GDSOUT_Review__c,\n' +
                'Customer_GDSOUT_Review_Date__c,\n' +
                'Foundry_GDSOUT_Review__c,\n' +
                'Foundry_GDSOUT_Review_Date__c,\n' +
                'PTRF__r.Device_Id__c,PTRF__r.Tech_Geo__c,PTRF__r.MaskSetTitle__r.Name,PTRF__r.MaskSetTitle__c,\n' +
                'PTRF__r.Name,Layer__c,ROM_Code__c,Layer__r.Mask_Layer_Rev__c,\n' +
                'Layer__r.Name,PTRF__c,Layer__r.Layer_Status__c,Device_Id__c,Tech_Geo__c,PTRF__r.Recticle_Type__c\n' +
                ' FROM  MRS_Layer_Chip_Association__c';

        } else if (page.contains('MEBES')) {
            lstmrsLayerChipAsso = 'SELECT  Chip__c,Chip__r.Name,\n' +
                'Customer_MEBES_Jobview__c,\n' +
                'Customer_MEBES_Jobview_Date__c,\n' +
                'Foundry_MEBES_Jobview__c,\n' +
                'Foundry_MEBES_Jobview_Date__c,\n' +
                'Tapeout_Centre_MEBES_Jobview__c,\n' +
                'Tapeout_Centre_MEBES_Jobview_Date__c,\n' +
                'Tapeout_Applications_MEBES_Jobview__c,\n' +
                'Tapeout_Applications_MEBES_Jobview_Date__c,\n' +
                'GlobalShuttle_MEBES_Jobview__c,\n' +
                'GlobalShuttle_MEBES_Jobview_Date__c,\n' +
                'MDP_MEBES_Jobview__c,\n' +
                'MDP_MEBES_Jobview_Date__c,\n' +
                'TDTI_MPW_MEBES_Jobview__c,\n' +
                'TDTI_MPW_MEBES_Date__c,PTRF__r.Tech_Geo__c,PTRF__r.MaskSetTitle__r.Name,PTRF__r.MaskSetTitle__c,\n' +
                'PTRF__r.Device__c,PTRF__r.Device__r.Name,PTRF__r.Device_Id__c,\n' +
                'PTRF__r.Name,Layer__c,ROM_Code__c,Layer__r.Mask_Layer_Rev__c,\n' +
                'Layer__r.Name,PTRF__c,Layer__r.Layer_Status__c,Device_Id__c,Tech_Geo__c,PTRF__r.Recticle_Type__c,LastModifiedById,Layer__r.ROM_Code__c \n' +
                ' FROM  MRS_Layer_Chip_Association__c';
        } else {

            lstmrsLayerChipAsso = 'SELECT  Chip__c,Chip__r.Name,Customer_Frame_Mockup__c,layer__r.MRS__r.Mask_Set_Title__c,layer__r.MRS__r.Mask_Set_Title__r.Name,\n' +
                'Foundry_Frame_Mockup__c,\n' +
                'Foundry_Frame_Mockup_Date__c,Customer_Frame_Mockup_Date__c ,\n' +
                'Frame_TapeOut__c,PTRF__r.Device__c,PTRF__r.Device__r.Name,PTRF__r.Device_Id__c,\n' +
                'PTRF__r.Name,Layer__c,ROM_Code__c,Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,\n' +
                'Layer__r.Name,PTRF__r.Tech_Geo__c,PTRF__r.Tech_Geo_Value__c,Layer_Chip_Status__c,Mask_Layer__c,PTRF__c,Layer__r.Layer_Status__c,Device_Id__c,PTRF__r.MaskSetTitle__r.Name,PTRF__r.MaskSetTitle__c,Tech_Geo__c,PTRF__r.Recticle_Type__c,PTRF__r.Frame_Tapeout__c,PTRF__r.Frame_Mockup__c,LastModifiedById, \n' +
                'Mask_Set_Title_Id__c,PTRF__r.MaskSetTitle__r.CreatedDate,PTRF__r.Status__c \n' +
                ' FROM  MRS_Layer_Chip_Association__c';
        }

        if (customerId != '' && customerId != null) {
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' WHERE Customer_Name__c =:customerId';
        }
        
        if (mstId != '' && mstId != null) mstId = mstId.substring(0, 15);

        lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Mask_Set_Title_Id__c =:mstId';
        if (layerId != '' && layerId != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND layer__r.Name =:layerId';
        if (layerStatus != '' && layerStatus != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer__r.Layer_Status__c IN:layerStatusArray';
        if (deviceId != '' && deviceId != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.Device_Id__c=:deviceId';
        if (frameIdOrChipId != '' && frameIdOrChipId != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND chip__r.Name=:frameIdOrChipId';
        if (ptrf != '' && ptrf != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.Name=:ptrf';
        if (layerOrChipStatus != '' && layerOrChipStatus != null && !(page == 'CustomerFrameMockup' || page == 'FoundryFrameMockup')) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer_Chip_Status__c=:layerOrChipStatus';
        if (layerOrChipStatus != '' && layerOrChipStatus != null && (page == 'CustomerFrameMockup')) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Customer_Frame_Mockup__c=:layerOrChipStatus';
        if (layerOrChipStatus != '' && layerOrChipStatus != null && (page == 'FoundryFrameMockup')) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Foundry_Frame_Mockup__c=:layerOrChipStatus';
        if (page == 'CustomerFrameMockup' || page == 'FoundryFrameMockup') {
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer__r.Layer_Status__c NOT IN :setOfStatus';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.Frame_Mockup__c=:flag ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Chip__r.Name=:chipName ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF_Or_DRT__c !=:PTRForDRT';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND ((Layer_Chip_Status__c IN:setOfLCFrameStatus  AND PTRF__r.Frame_Tapeout__c=:flag) ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' OR (Layer_Chip_Status__c =:cancelledChip  AND (Customer_Frame_Mockup__c =:frameStatus OR Foundry_Frame_Mockup__c =:frameStatus))) ';
        }
        if (page == 'CustomerGDSOutReview' || page == 'FoundryGDSOutReview') {

            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer__r.Layer_Status__c NOT IN :setOfStatus';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF_Or_DRT__c !=:PTRForDRT';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.Prime_Tapeout__c=:flag ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.Prime_GDSOUT_Review__c=:flag ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Chip__r.Name!=:chipName ';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer_Chip_Status__c NOT IN:setOfLCStatus';
        }
        if (page.contains('MEBES')) {

            String strDRT = 'DRT';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer__r.Layer_Status__c NOT IN:setReleased';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF_Or_DRT__c !=:strDRT';
            lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer_Chip_Status__c NOT IN:setOfLCStatus';

        }
        
        //=============================
        //swgp-839
        //hard coded check on Foundry Mebes Jobview page >>> other page >>> intact       
        if(page.contains('MEBES') && page.containsIgnoreCase('foundry')) {
            //swgp-939
            //allow TOC to view Foundry mebes jobview too: add isTapeOutCenter
            if (isUserGlobalShuttle || isUserTDTIMPW || isUserAdmin || isTapeOutCenter) {
                //DO-NOTHING
            } else {
                lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__c IN:ptrfIdlst';//load only ptrf that login user is defined as foundry jobviewer
            }
        } else {
            //original outside this if
            if (ptrfIdlst.size() > 0 && isJobViewer) {
                lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__c IN:ptrfIdlst';
            }
            //original outside this if    
        }
        //==============================
        
        lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__r.MaskSetTitle__r.Status__c = \'Active\'';
        lstmrsLayerChipAsso = lstmrsLayerChipAsso + '  ORDER BY PTRF__r.CreatedDate,PTRF__r.MaskSetTitle__r.CreatedDate DESC'; //08/03/2014

        List < MRS_Layer_Chip_Association__c > lstMRSDatabaseQuery = new List < MRS_Layer_Chip_Association__c > ();
        List < MRS_Layer_Chip_Association__c > mrslstLayerChip = new List < MRS_Layer_Chip_Association__c > ();
        
        if(performApproval) {
            lstMRSDatabaseQuery = Database.query(lstmrsLayerChipAsso);
        }
        
        Map < Id, List < MRS_Layer_Chip_Association__c >> ptrfIdLayerChipId = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();

        if (lstMRSDatabaseQuery.size() > 0) {
            Double mdpTechGeoCutoff = Double.valueOf(MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off', '0.022'));
            for (MRS_Layer_Chip_Association__c obj: lstMRSDatabaseQuery) {

                if (ptrfIdLayerChipId.containsKey(obj.PTRF__c)) {
                    ptrfIdLayerChipId.get(obj.PTRF__c).add(obj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChiplst.add(obj);
                    ptrfIdLayerChipId.put(obj.PTRF__c, mrsLayerChiplst);
                }
                if ((isUserGlobalShuttle || isUserMDP || isUserTDTIMPW) && !isUserAdmin && !isTapeOutCenter) {

                    if (isUserGlobalShuttle && (!isUserTDTIMPW && !isUserMDP)) {
                        if (obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02 && obj.PTRF__r.MaskSetTitle__r.Name != null && obj.PTRF__r.MaskSetTitle__r.Name.startsWith('MPW')) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);

                        }
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && (!isUserMDP)) {
                        if (obj.PTRF__r.MaskSetTitle__r.Name != null && obj.PTRF__r.MaskSetTitle__r.Name.startsWith('MPW')) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                    } else if (isUserGlobalShuttle && !isUserTDTIMPW && (isUserMDP)) {
                        if (isUserGlobalShuttle && obj.PTRF__r.MaskSetTitle__r.Name != null && obj.PTRF__r.MaskSetTitle__r.Name.startsWith('MPW') && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                        if (isUserMDP && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && isUserMDP) {
                        if (isUserGlobalShuttle && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02 && obj.PTRF__r.MaskSetTitle__r.Name != null && obj.PTRF__r.MaskSetTitle__r.Name.startsWith('MPW')) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                        if ((isUserTDTIMPW) && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                        if ((isUserMDP) && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrslstLayerChip.add(obj);
                            ptrfIdSt.add(obj.PTRF__c);
                        }
                    } else if (!isUserGlobalShuttle && (isUserTDTIMPW ) && (!isUserMDP ) && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                        mrslstLayerChip.add(obj);
                        ptrfIdSt.add(obj.PTRF__c);
                    }else if (!isUserGlobalShuttle && (!isUserTDTIMPW) && (isUserMDP) && obj.PTRF__r.Tech_Geo__c != null && obj.PTRF__r.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(obj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                        mrslstLayerChip.add(obj);
                        ptrfIdSt.add(obj.PTRF__c);
                    }

                } else {
                    mrslstLayerChip.add(obj);
                }
            }
        }

        List < MRS_Layer_Chip_Association__c > contractdictRecords;
        if (isGroupUser) {

            Boolean groupApproval = false;
            
            if (isGroupUser) for (Id ptrfId: ptrfIdlst) {
                if (ptrfIdSt != null && ptrfIdSt.size() > 0) {
                    if (!ptrfIdSt.contains(ptrfId)) {
                        if (ptrfIdLayerChipId.get(ptrfId) != null && ptrfIdLayerChipId.get(ptrfId).size() > 0) if (ptrfIdLayerChipId.containsKey(ptrfId)) {
                            mrslstLayerChip.addAll(ptrfIdLayerChipId.get(ptrfId));
                        }
                    }
                } else {
                    if (ptrfIdLayerChipId != null && ptrfIdLayerChipId.size() > 0) {
                        if (ptrfIdLayerChipId.containsKey(ptrfId)) {
                            mrslstLayerChip.addAll(ptrfIdLayerChipId.get(ptrfId));
                        }
                    }
                }
            }
        }
        
        return mrslstLayerChip;
    }

    /**
        This method is for fetching the User Groups to which the current logged in user is a Group Member.

        @method name: fetchCurrentUserGroup
        @return :     set of User Group Names of current logged in User.
     **/

    public static set < String > fetchCurrentUserGroup(Id loggedInUserId) {
        set < String > setCurrentUserGroup = new set < String > ();
        for (Group tempGroup: [select developername from Group where id in (select groupid from GroupMember where userorgroupid = : loggedInUserId)]) {
            setCurrentUserGroup.add(tempGroup.developername);
        }
        return setCurrentUserGroup;
    }

    /**
        This method is for fetching MRS Layer Summary Details to be displayed in the MRS Layer Summary Page. 

        @method name: fetchMRSLayerSummaryDetails
        @return :     List of retrieved MRS Layer Summary records.
     **/

    public static Map < Id, MRS_Layer_Association__c > fetchMRSLayerSummaryDetails() {
        List < MRS_Layer_Association__c > totalList = [SELECT Name, ROM_Code__c, Mask_Layer_Rev__c, Mask_Set_Title_Name__c, Layer_Status__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c, Send_Prime_Data__c, Send_Frame_Data__c, ORC__c, DRW__c, Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c, MDP_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, Customer_Prime_Remote_Jobview_Setup__c, Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c, Tech_geo__c from MRS_Layer_Association__c];
        Map < Id, MRS_Layer_Association__c > masterMap = new Map < Id, MRS_Layer_Association__c > (totalList);
        return masterMap;
    }

    /**
        This method is for fetching MRS Layer Chip Summary Details to be displayed in the MRS Layer Chip Summary Page. 

        @method name: fetchMRSLayerChipSummaryDetails
        @return :     List of retrieved MRS Layer Chip Summary records.
     **/

    public static List < MRS_Layer_Chip_Association__c > fetchMRSLayerChipSummaryDetails(String layerId) {
        List < MRS_Layer_Chip_Association__c > totalList = [SELECT ID, Name, device_id__c, ptrf__c, drt__c, ptrf__r.name, ptrf__r.Device_Id__c, drt__r.name, PTRF_Or_DRT__c, Tech_Geo__c, Layer_Chip_Status__c from MRS_Layer_Chip_Association__c where layer__c = : layerId];
        return totalList;
    }

    /**
        This method is for sending email to Jobviewers of PTRFs whenever the chips of that PTRF in MRS are approved on 
        GDSOUT Review or Frame Mockup screens and released on MEBES Jobview screens. (Email Templates: 9, 10, 10B, 17)

        @method name: sendEmailToReviewers
        @return :     none.
     **/

    public static void sendEmailToReviewers(Map < Id, List < MRS_Layer_Chip_Association__c >> techGeoAndId, String page, String selectedCustomer, Boolean approve, String disapprovaltxt, String disapprovalPerson) {
        
        /*ECP2 Start*/
        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (disapprovaltxt != null) {
            nameValuePair.put('DISAPPROVE_REASON', disapprovaltxt);
        }
        if (disapprovalPerson != null) {
            nameValuePair.put('DISAPPROVE_PERSON', disapprovalPerson);
        }
        /*ECP2 End*/

        List < MRS_Layer_Chip_Association__c > mrsLCAlist = new List < MRS_Layer_Chip_Association__c > ();
        //preparing list of MRS_Layer_Chip_Association__c records
        for (Id ptrfId: techGeoAndId.keySet()) {
            mrsLCAlist.addAll(techGeoAndId.get(ptrfId));
        }


        if (page.contains('Frame')) {
            if (approve) {

                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Frame_Mockup_is_Approved_Custom', nameValuePair, 'NA', null);
            } else {

                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Frame_Mockup_is_Disapproved_Custom', nameValuePair, 'NA', null);
            }
        } else if (page.contains('GDSOUTReview')) {

            emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Prime_GDSOUT_Review_is_Approved_Custom', nameValuePair, 'NA', null);
        }
        /** modified for MEBES Jobview **/
        else if (page.containsIgnoreCase('MEBES')) {

            if (page.containsIgnoreCase('Customer')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Customer_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('Foundry')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Foundry_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('TapeoutApplication')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Tapeout_Applications_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('GlobalShuttle')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_GlobalShuttle_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('TDTIMPW')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_TDTI_MPW_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('TapeoutCenter')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_Tapeout_Centre_MEBES_is_Released', nameValuePair, 'NA', null);
            } else if (page.containsIgnoreCase('MDP')) {
                emailObject.emailSubBodyPerPTRF(mrsLCAlist, 'Swift_Device_MDP_MEBES_is_Released', nameValuePair, 'NA', null);
            }
        }

    }

    public static MRS_Layer_Chip_Association__c retriveMRSLayerChip(String mrsLayerChipId) {
        MRS_Layer_Chip_Association__c mrsHandlerUtilty = [SELECT Id, Chip__r.Name, Layer__r.Name, PTRF__r.Name, Layer_Chip_Status__c, Layer__r.ROM_Code__c, Layer__r.Mask_Layer_Rev__c, PTRF__r.MaskSetTitle__r.Name, Customer_Name__r.Name, Void__c, Customer_Name__c, PTRF__r.Tech_Geo__c, PTRF__c, PTRF__r.Customer__c
        FROM MRS_Layer_Chip_Association__c
        WHERE Id = : mrsLayerChipId];
        return mrsHandlerUtilty;
    }

    public static List < MRS_Layer_Chip_Association__c > searchMrsChipLayerSummary(string layerId, String deviceId, String layerChipStatus, String ptrfDrtNum, string techGeo) {

        String strMST;

        List < MRS__c > listFilteredMRS = new List < MRS__c > ();
        listFilteredMRS = [SELECT Mask_Set_Title__c from MRS__c where id in (select MRS__c from MRS_Layer_Association__c where id = : layerId)];

        strMST = listFilteredMRS[0].Mask_Set_Title__c;

        List < String > listOfPTRFIDs = new List < String > ();
        for (PTRF__c PTRFObj: [SELECT ID from PTRF__c where(Prime_Tapeout__c = true or Frame_Tapeout__c = true) and MaskSetTitle__c = : strMST]) {
            listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
        }

        List < String > listOfDRTIDs = new List < String > ();
        for (DRT_PTRF_Association__c DRTObj: [SELECT DRT__c from DRT_PTRF_Association__c where PTRF__c in : listOfPTRFIDs]) {
            listOfDRTIDs.add(String.valueOf(DRTObj.DRT__c));
        }

        String lstmrsLayerChipAsso = 'SELECT  ID,Chip_Name__c,PTRF_Or_DRT__c,ptrf__c,drt__c,ptrf__r.name,drt__r.name,Layer_Chip_Status__c,Customer_GDSOUT_Review__c\n' +
            ',Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,ORC__c,DRW__c \n' +
            ',Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c \n' +
            ',Prime_MEBES_Received__c,Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c \n' +
            ',Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c \n' +
            ',Customer_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,Foundry_Frame_Mockup_Date__c,Send_Prime_Data_Date__c,Send_Frame_Data_Date__c,ORC_Date__c,DRW_Date__c \n' +
            ',Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c \n' +
            ',Prime_MEBES_Received_Date__c,Frame_MEBES_Received_Date__c,Customer_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c \n' +
            ',Tapeout_Applications_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,MDP_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Date__c,Layer_Chip_Status_Date__c \n' +
            ' FROM  MRS_Layer_Chip_Association__c';

        if (layerId != '' && layerId != null) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' WHERE Layer__c =:layerId';
        else return null;
        
        if (deviceId != '' && deviceId != null && deviceId != '0') lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Device_Id__c =:deviceId';
        if (layerChipStatus != '' && layerChipStatus != null && layerChipStatus != '0') lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Layer_Chip_Status__c =:layerChipStatus';
        if (ptrfDrtNum != '' && ptrfDrtNum != null && ptrfDrtNum != '0') lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND ( PTRF__r.name=:ptrfDrtNum OR DRT__r.name=:ptrfDrtNum)';
        if (techGeo != '' && techGeo != null && techGeo != '0') lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND Tech_Geo__c=:techGeo';

        if (listOfPTRFIDs != null && listOfPTRFIDs.size() > 0) lstmrsLayerChipAsso = lstmrsLayerChipAsso + ' AND PTRF__c in:listOfPTRFIDs ';

        List < MRS_Layer_Chip_Association__c > mrslstLayerChip = Database.Query(lstmrsLayerChipAsso);

        return mrslstLayerChip;
    }

    /**
        This method is for setting Layer Chip Status on MRS Layer Chip Association object. 
        @method name: setLayerChipStatus
        @parameter:   MRS Layer Chip Association record.
        @return :     MRS Layer Chip Association record.
     **/

    public static List < MRS_Layer_Chip_Association__c > setLayerChipStatus(List < MRS_Layer_Chip_Association__c > listMRSLCA) {

        Set < String > setLayerChipStatus1 = new Set < String > {
            'N.A.', 'Not Ready', 'Not Done'
        };
        Set < String > setLayerChipStatus3 = new Set < String > {
            'N.A.', 'Released', 'Done', 'Approve'
        };

        if (listMRSLCA != null && listMRSLCA.size() > 0) {
            for (MRS_Layer_Chip_Association__c obj: listMRSLCA) {

                if (obj.Layer_Chip_Status__c != 'Cancel' && obj.Layer_Chip_Status__c != 'Hold' && obj.Layer_Chip_Status__c != 'Void') {
                    if (setLayerChipStatus1.contains(obj.Customer_GDSOUT_Review__c) && setLayerChipStatus1.contains(obj.Foundry_GDSOUT_Review__c) && setLayerChipStatus1.contains(obj.Customer_Frame_Mockup__c) && setLayerChipStatus1.contains(obj.Foundry_Frame_Mockup__c) && setLayerChipStatus1.contains(obj.Send_Prime_Data__c) && setLayerChipStatus1.contains(obj.Send_Frame_Data__c) && setLayerChipStatus1.contains(obj.DRW__c) && setLayerChipStatus1.contains(obj.ORC__c) && setLayerChipStatus1.contains(obj.Prime_MEBES_Received__c) && setLayerChipStatus1.contains(obj.Frame_MEBES_Received__c) && setLayerChipStatus1.contains(obj.Customer_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.Foundry_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.GlobalShuttle_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.MDP_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.Tapeout_Applications_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.Tapeout_Centre_MEBES_Jobview__c) && setLayerChipStatus1.contains(obj.TDTI_MPW_MEBES_Jobview__c)) {
                        obj.Layer_Chip_Status__c = 'Not Ready';
                    } else if (setLayerChipStatus3.contains(obj.Customer_GDSOUT_Review__c) && setLayerChipStatus3.contains(obj.Foundry_GDSOUT_Review__c) && setLayerChipStatus3.contains(obj.Customer_Frame_Mockup__c) && setLayerChipStatus3.contains(obj.Foundry_Frame_Mockup__c) && setLayerChipStatus3.contains(obj.Send_Prime_Data__c) && setLayerChipStatus3.contains(obj.Send_Frame_Data__c) && setLayerChipStatus3.contains(obj.DRW__c) && setLayerChipStatus3.contains(obj.ORC__c) && setLayerChipStatus3.contains(obj.Prime_MEBES_Received__c) && setLayerChipStatus3.contains(obj.Frame_MEBES_Received__c) && setLayerChipStatus3.contains(obj.Customer_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.Foundry_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.GlobalShuttle_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.MDP_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.Tapeout_Applications_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.Tapeout_Centre_MEBES_Jobview__c) && setLayerChipStatus3.contains(obj.TDTI_MPW_MEBES_Jobview__c)) {
                        obj.Layer_Chip_Status__c = 'Released';
                    } else {
                        obj.Layer_Chip_Status__c = 'In Progress';
                    }
                }
            }
        }
        return listMRSLCA;
    }

    /**
        This method is for setting Timestamp for Layer Chips on MRS Layer Chip Association object. 
        @method name: setTimeStampForLayerChips
        @parameter:   1. Trigger.New List of MRS Layer Chip Association records.
                      2. Trigger.Old Map of MRS Layer Chip Association records.
        @return :     List of MRS Layer Chip Association records.
     **/

    public static List < MRS_Layer_Chip_Association__c > setTimeStampForLayerChips(List < MRS_Layer_Chip_Association__c > lstNew, map < Id, MRS_Layer_Chip_Association__c > mapOld) {
        List < MRS_Layer_Chip_Association__c > lstMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
        if (lstNew != null && lstNew.size() > 0) {
            DateTime currentDateTime = DateTime.now();
            if (mapOld != null) {
                for (MRS_Layer_Chip_Association__c mrsLayerChipObject: lstNew) {
                    if (mrsLayerChipObject.Send_Prime_Data__c != mapOld.get(mrsLayerChipObject.Id).Send_Prime_Data__c) {
                        mrsLayerChipObject.Send_Prime_Data_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Send_Frame_Data__c != mapOld.get(mrsLayerChipObject.Id).Send_Frame_Data__c) {
                        mrsLayerChipObject.Send_Frame_Data_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Customer_GDSOUT_Review__c != mapOld.get(mrsLayerChipObject.Id).Customer_GDSOUT_Review__c) {
                        mrsLayerChipObject.Customer_GDSOUT_Review_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Foundry_GDSOUT_Review__c != mapOld.get(mrsLayerChipObject.Id).Foundry_GDSOUT_Review__c) {
                        mrsLayerChipObject.Foundry_GDSOUT_Review_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Customer_Frame_Mockup__c != mapOld.get(mrsLayerChipObject.Id).Customer_Frame_Mockup__c) {
                        mrsLayerChipObject.Customer_Frame_Mockup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Foundry_Frame_Mockup__c != mapOld.get(mrsLayerChipObject.Id).Foundry_Frame_Mockup__c) {
                        mrsLayerChipObject.Foundry_Frame_Mockup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.DRW__c != mapOld.get(mrsLayerChipObject.Id).DRW__c) {
                        mrsLayerChipObject.DRW_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.ORC__c != mapOld.get(mrsLayerChipObject.Id).ORC__c) {
                        mrsLayerChipObject.ORC_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Customer_Prime_Remote_Jobview_Setup__c != mapOld.get(mrsLayerChipObject.Id).Customer_Prime_Remote_Jobview_Setup__c) {
                        mrsLayerChipObject.Customer_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Customer_Frame_Remote_Jobview_Setup__c != mapOld.get(mrsLayerChipObject.Id).Customer_Frame_Remote_Jobview_Setup__c) {
                        mrsLayerChipObject.Customer_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Foundry_Prime_Remote_Jobview_Setup__c != mapOld.get(mrsLayerChipObject.Id).Foundry_Prime_Remote_Jobview_Setup__c) {
                        mrsLayerChipObject.Foundry_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Foundry_Frame_Remote_Jobview_Setup__c != mapOld.get(mrsLayerChipObject.Id).Foundry_Frame_Remote_Jobview_Setup__c) {
                        mrsLayerChipObject.Foundry_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Prime_MEBES_Received__c != mapOld.get(mrsLayerChipObject.Id).Prime_MEBES_Received__c) {
                        mrsLayerChipObject.Prime_MEBES_Received_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Frame_MEBES_Received__c != mapOld.get(mrsLayerChipObject.Id).Frame_MEBES_Received__c) {
                        mrsLayerChipObject.Frame_MEBES_Received_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Customer_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).Customer_MEBES_Jobview__c) {
                        mrsLayerChipObject.Customer_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Foundry_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).Foundry_MEBES_Jobview__c) {
                        mrsLayerChipObject.Foundry_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Tapeout_Centre_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).Tapeout_Centre_MEBES_Jobview__c) {
                        mrsLayerChipObject.Tapeout_Centre_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.MDP_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).MDP_MEBES_Jobview__c) {
                        mrsLayerChipObject.MDP_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Tapeout_Applications_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).Tapeout_Applications_MEBES_Jobview__c) {
                        mrsLayerChipObject.Tapeout_Applications_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.GlobalShuttle_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).GlobalShuttle_MEBES_Jobview__c) {
                        mrsLayerChipObject.GlobalShuttle_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.TDTI_MPW_MEBES_Jobview__c != mapOld.get(mrsLayerChipObject.Id).TDTI_MPW_MEBES_Jobview__c) {
                        mrsLayerChipObject.TDTI_MPW_MEBES_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Layer_Chip_Status__c != mapOld.get(mrsLayerChipObject.Id).Layer_Chip_Status__c) {
                        mrsLayerChipObject.Layer_Chip_Status_Date__c = currentDateTime;
                    }
                    if (mrsLayerChipObject.Hold_Mask_Write__c != mapOld.get(mrsLayerChipObject.Id).Hold_Mask_Write__c) {
                        mrsLayerChipObject.Hold_Mask_Write_Date__c = currentDateTime;
                    }
                    lstMRSLCA.add(mrsLayerChipObject);
                }

            } else {
                for (MRS_Layer_Chip_Association__c mrsLayerChipObject: lstNew) {
                    mrsLayerChipObject.Send_Prime_Data_Date__c = currentDateTime;
                    mrsLayerChipObject.Send_Frame_Data_Date__c = currentDateTime;
                    mrsLayerChipObject.Customer_GDSOUT_Review_Date__c = currentDateTime;
                    mrsLayerChipObject.Foundry_GDSOUT_Review_Date__c = currentDateTime;
                    mrsLayerChipObject.Customer_Frame_Mockup_Date__c = currentDateTime;
                    mrsLayerChipObject.Foundry_Frame_Mockup_Date__c = currentDateTime;
                    mrsLayerChipObject.DRW_Date__c = currentDateTime;
                    mrsLayerChipObject.ORC_Date__c = currentDateTime;
                    mrsLayerChipObject.Customer_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerChipObject.Customer_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerChipObject.Foundry_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerChipObject.Foundry_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerChipObject.Prime_MEBES_Received_Date__c = currentDateTime;
                    mrsLayerChipObject.Frame_MEBES_Received_Date__c = currentDateTime;
                    mrsLayerChipObject.Customer_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.Foundry_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.Tapeout_Centre_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.MDP_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.Tapeout_Applications_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.GlobalShuttle_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerChipObject.TDTI_MPW_MEBES_Date__c = currentDateTime;
                    mrsLayerChipObject.Layer_Chip_Status_Date__c = currentDateTime;
                    mrsLayerChipObject.Hold_Mask_Write_Date__c = currentDateTime;
                    lstMRSLCA.add(mrsLayerChipObject);
                }
            }
        }

        return lstMRSLCA;
    }

    /**
        This method is for setting Timestamp for Layers on MRS Layer Chip Association object. 
        @method name: setTimeStampForLayers
        @parameter:   1. Trigger.New List of MRS Layer Association records.
                      2. Trigger.Old Map of MRS Layer Association records.
        @return :     List of MRS Layer Association records.
     **/

    public static List < MRS_Layer_Association__c > setTimeStampForLayers(List < MRS_Layer_Association__c > lstNew, map < Id, MRS_Layer_Association__c > mapOld) {
        List < MRS_Layer_Association__c > lstMRSLA = new List < MRS_Layer_Association__c > ();
        if (lstNew != null && lstNew.size() > 0) {
            DateTime currentDateTime = DateTime.now();
            if (mapOld != null) {
                for (MRS_Layer_Association__c mrsLayerObject: lstNew) {
                    if (mrsLayerObject.Send_Prime_Data__c != mapOld.get(mrsLayerObject.Id).Send_Prime_Data__c) {
                        mrsLayerObject.Send_Prime_Data_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Send_Frame_Data__c != mapOld.get(mrsLayerObject.Id).Send_Frame_Data__c) {
                        mrsLayerObject.Send_Frame_Data_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Customer_GDSOUT_Review__c != mapOld.get(mrsLayerObject.Id).Customer_GDSOUT_Review__c) {
                        mrsLayerObject.Customer_GDSOUT_Review_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Foundry_GDSOUT_Review__c != mapOld.get(mrsLayerObject.Id).Foundry_GDSOUT_Review__c) {
                        mrsLayerObject.Foundry_GDSOUT_Review_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Customer_Frame_Mockup__c != mapOld.get(mrsLayerObject.Id).Customer_Frame_Mockup__c) {
                        mrsLayerObject.Customer_Frame_Mockup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Foundry_Frame_Mockup__c != mapOld.get(mrsLayerObject.Id).Foundry_Frame_Mockup__c) {
                        mrsLayerObject.Foundry_Frame_Mockup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.DRW__c != mapOld.get(mrsLayerObject.Id).DRW__c) {
                        mrsLayerObject.DRW_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.ORC__c != mapOld.get(mrsLayerObject.Id).ORC__c) {
                        mrsLayerObject.ORC_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Customer_Prime_Remote_Jobview_Setup__c != mapOld.get(mrsLayerObject.Id).Customer_Prime_Remote_Jobview_Setup__c) {
                        mrsLayerObject.Customer_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Customer_Frame_Remote_Jobview_Setup__c != mapOld.get(mrsLayerObject.Id).Customer_Frame_Remote_Jobview_Setup__c) {
                        mrsLayerObject.Customer_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Foundry_Prime_Remote_Jobview_Setup__c != mapOld.get(mrsLayerObject.Id).Foundry_Prime_Remote_Jobview_Setup__c) {
                        mrsLayerObject.Foundry_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Foundry_Frame_Remote_Jobview_Setup__c != mapOld.get(mrsLayerObject.Id).Foundry_Frame_Remote_Jobview_Setup__c) {
                        mrsLayerObject.Foundry_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Prime_MEBES_Received__c != mapOld.get(mrsLayerObject.Id).Prime_MEBES_Received__c) {
                        mrsLayerObject.Prime_MEBES_Received_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Frame_MEBES_Received__c != mapOld.get(mrsLayerObject.Id).Frame_MEBES_Received__c) {
                        mrsLayerObject.Frame_MEBES_Received_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Customer_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).Customer_MEBES_Jobview__c) {
                        mrsLayerObject.Customer_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Foundry_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).Foundry_MEBES_Jobview__c) {
                        mrsLayerObject.Foundry_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Tapeout_Centre_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).Tapeout_Centre_MEBES_Jobview__c) {
                        mrsLayerObject.Tapeout_Centre_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.MDP_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).MDP_MEBES_Jobview__c) {
                        mrsLayerObject.MDP_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Tapeout_Applications_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).Tapeout_Applications_MEBES_Jobview__c) {
                        mrsLayerObject.Tapeout_Applications_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.GlobalShuttle_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).GlobalShuttle_MEBES_Jobview__c) {
                        mrsLayerObject.GlobalShuttle_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.TDTI_MPW_MEBES_Jobview__c != mapOld.get(mrsLayerObject.Id).TDTI_MPW_MEBES_Jobview__c) {
                        mrsLayerObject.TDTI_MPW_MEBES_Jobview_Date__c = currentDateTime;
                    }
                    if (mrsLayerObject.Layer_Status__c != mapOld.get(mrsLayerObject.Id).Layer_Status__c) {
                        mrsLayerObject.Layer_Status_Date__c = currentDateTime;
                    }
                    lstMRSLA.add(mrsLayerObject);
                }
            } else {
                for (MRS_Layer_Association__c mrsLayerObject: lstNew) {
                    mrsLayerObject.Send_Prime_Data_Date__c = currentDateTime;
                    mrsLayerObject.Send_Frame_Data_Date__c = currentDateTime;
                    mrsLayerObject.Customer_GDSOUT_Review_Date__c = currentDateTime;
                    mrsLayerObject.Foundry_GDSOUT_Review_Date__c = currentDateTime;
                    mrsLayerObject.Customer_Frame_Mockup_Date__c = currentDateTime;
                    mrsLayerObject.Foundry_Frame_Mockup_Date__c = currentDateTime;
                    mrsLayerObject.DRW_Date__c = currentDateTime;
                    mrsLayerObject.ORC_Date__c = currentDateTime;
                    mrsLayerObject.Customer_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerObject.Customer_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerObject.Foundry_Prime_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerObject.Foundry_Frame_Remote_Jobview_Setup_Date__c = currentDateTime;
                    mrsLayerObject.Prime_MEBES_Received_Date__c = currentDateTime;
                    mrsLayerObject.Frame_MEBES_Received_Date__c = currentDateTime;
                    mrsLayerObject.Customer_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.Foundry_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.Tapeout_Centre_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.MDP_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.Tapeout_Applications_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.GlobalShuttle_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.TDTI_MPW_MEBES_Jobview_Date__c = currentDateTime;
                    mrsLayerObject.Layer_Status_Date__c = currentDateTime;
                    lstMRSLA.add(mrsLayerObject);
                }
            }
        }
        return lstMRSLA;
    }

    /**
        This method is for retrieving MRS Layer Association records for rollup. 
        @method name: retrieveLayerDetails
        @parameter:   Set of MRS Layer Ids.
        @return :     list of MRS Layer Association records.
     **/

    public static List < MRS_Layer_Association__c > retrieveLayerDetails(set < String > setLayerIds) {

        List < MRS_Layer_Association__c > lstLayerDetails = new List < MRS_Layer_Association__c > ();

        for (MRS_Layer_Association__c obj: [SELECT Id, Layer_Status__c, layer_name__c, name, ROM_Code__c, Mask_Layer_Rev__c, Mask_Set_Title_Name__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c,
        Send_Prime_Data__c, Send_Frame_Data__c, DRW__c, ORC__c, Customer_Prime_Remote_Jobview_Setup__c, Hold_Layer_By_User__c,
        Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,
        Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c,
        MDP_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, Tech_Geo_Int__c
        FROM MRS_Layer_Association__c
        WHERE Id IN: setLayerIds]) {

            lstLayerDetails.add(obj);

        }
        return lstLayerDetails;
    }

    /**
        This method is for retrieving MRS Layer Chip Association records for calculating rollup status. 
        @method name: retrieveLayerChipDetails
        @parameter:   Set of MRS Layer Ids.
        @return :     Map of MRS Layer Chip Association records with MRS Layer Association Id as the key.
     **/

    public static Map < String, List < MRS_Layer_Chip_Association__c >> retrieveLayerChipDetails(set < String > setLayerIds) {

        Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToLayerChips = new Map < String, List < MRS_Layer_Chip_Association__c >> ();

        for (MRS_Layer_Chip_Association__c obj: [SELECT Id, Chip__c, Chip_Name__c, Layer_Chip_Status__c, Layer__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c,
        Send_Prime_Data__c, Send_Frame_Data__c, DRW__c, ORC__c, Customer_Prime_Remote_Jobview_Setup__c,
        Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,
        Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c,
        MDP_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c
        FROM MRS_Layer_Chip_Association__c WHERE Layer__c IN: setLayerIds AND Layer_Chip_Status__c != 'Void'
        AND
        Layer_Chip_Status__c != 'Cancel']) { //TASK-2000

            list < MRS_Layer_Chip_Association__c > tempList = new list < MRS_Layer_Chip_Association__c > ();
            String layerId = obj.Layer__c;

            if (mapLayerIdsToLayerChips != null) {
                if (mapLayerIdsToLayerChips.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdsToLayerChips.get(layerId));
                }
                tempList.add(obj);
                mapLayerIdsToLayerChips.put(layerId, tempList);
            }

        }

        return mapLayerIdsToLayerChips;
    }

    /**
        This method is for retrieving MRS Layer Chip Association records for calculating rollup status. 
        @method name: retrieveLayerChipDetailsForUpdate
        @parameter:   1. Set of MRS Layer Ids.
                      2. Set of MRS Layer Chip Ids in Trigger.New. 
        @return :     Map of MRS Layer Chip Association records with MRS Layer Association Id as the key.
     **/

    public static Map < String, List < MRS_Layer_Chip_Association__c >> retrieveLayerChipDetailsForUpdate(set < String > setLayerIds, set < String > setUpdatedLayerChipIds) {

        Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToLayerChips = new Map < String, List < MRS_Layer_Chip_Association__c >> ();

        for (MRS_Layer_Chip_Association__c obj: [SELECT Id, Chip__c, Chip_Name__c, Layer_Chip_Status__c, Layer__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c,
        Send_Prime_Data__c, Send_Frame_Data__c, DRW__c, ORC__c, Customer_Prime_Remote_Jobview_Setup__c,
        Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,
        Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c,
        MDP_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c
        FROM MRS_Layer_Chip_Association__c WHERE Layer__c IN: setLayerIds        
        AND Id NOT IN: setUpdatedLayerChipIds]) { //TASK-2000

            list < MRS_Layer_Chip_Association__c > tempList = new list < MRS_Layer_Chip_Association__c > ();
            String layerId = obj.Layer__c;

            if (mapLayerIdsToLayerChips != null) {
                if (mapLayerIdsToLayerChips.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdsToLayerChips.get(layerId));
                }
                tempList.add(obj);
                mapLayerIdsToLayerChips.put(layerId, tempList);
            }

        }

        return mapLayerIdsToLayerChips;
    }

    /**
        This method is for retrieving MRS Layer Chip Association records for calculating rollup status for Void/Cancel status. 
        @method name: retrieveLayerChipDetailsForVoidCancelStatus
        @parameter:   1. Set of MRS Layer Ids.
                      2. Set of MRS Layer Chip Ids in Trigger.New. 
        @return :     Map of MRS Layer Chip Association records with MRS Layer Association Id as the key.
     **/

    public static Map < String, List < MRS_Layer_Chip_Association__c >> retrieveLayerChipDetailsForVoidCancelStatus(set < String > setLayerIds, set < String > setUpdatedLayerChipIds) {

        Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdsToLayerChips = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c obj: [SELECT Id, Chip__c, Chip_Name__c, Layer_Chip_Status__c, Layer__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c,
        Send_Prime_Data__c, Send_Frame_Data__c, DRW__c, ORC__c, Customer_Prime_Remote_Jobview_Setup__c,
        Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,
        Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c,
        MDP_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c
        FROM MRS_Layer_Chip_Association__c WHERE Layer__c IN: setLayerIds AND Id NOT IN: setUpdatedLayerChipIds]) {
            list < MRS_Layer_Chip_Association__c > tempList = new list < MRS_Layer_Chip_Association__c > ();
            String layerId = obj.Layer__c;
            if (mapLayerIdsToLayerChips != null) {
                if (mapLayerIdsToLayerChips.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdsToLayerChips.get(layerId));
                }
                tempList.add(obj);
                mapLayerIdsToLayerChips.put(layerId, tempList);
            }
        }
        return mapLayerIdsToLayerChips;
    }

    /**
        This method is for calculating Layer Status when all the Layer Chip Status are either all Void or all Cancel 
        @method name: setLayerStatusForVoidCancelStatus
        @parameter:   1. List of MRS Layers.
                      2. Map of MRS Layer Chip Association records with MRS Layer Association Id as the key. 
        @return :     list of MRS Layer Association records to be updated with rollups.
     **/

    public static List < MRS_Layer_Association__c > setLayerStatusForVoidCancelStatus(List < MRS_Layer_Association__c > lstMRSLayers, Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips) {
        
        Boolean flgForVoid = false;
        Boolean flgForCancel = false;
        Boolean flgForOthers = false;
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();

        for (MRS_Layer_Association__c objLayer: lstMRSLayers) {
            if (mapLayerIdToLayerChips != null && mapLayerIdToLayerChips.containsKey(objLayer.Id)) {
                /** Resetting all the fields Start **/
                flgForVoid = false;
                flgForCancel = false;
                flgForOthers = false;
                /** Resetting all the fields End **/
                list < MRS_Layer_Chip_Association__c > lstMRSLayerChipIterator = new list < MRS_Layer_Chip_Association__c > ();
                lstMRSLayerChipIterator.addAll(mapLayerIdToLayerChips.get(objLayer.Id));
                
                //Rollup of Layer Status when all the Layer Chip Status are either all Void or all Cancel
                for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstMRSLayerChipIterator) {
                    if (mrsLayerChipObj.Layer_Chip_Status__c == 'Void') flgForVoid = true;
                    else if (mrsLayerChipObj.Layer_Chip_Status__c == 'Cancel') flgForCancel = true;
                    else flgForOthers = true;
                }

                if (flgForVoid && !flgForOthers && !objLayer.Hold_Layer_By_User__c) { // TASK-2141 added !objLayer.Hold_Layer_By_User__c
                    objLayer.Layer_Status__c = 'Void';
                    objLayer.Layer_Status_Date__c = Datetime.now();
                    lstMRSLayersUpdated.add(objLayer);
                } else if (!flgForVoid && flgForCancel && !flgForOthers && !objLayer.Hold_Layer_By_User__c) { // TASK-2141 added !objLayer.Hold_Layer_By_User__c
                    objLayer.Layer_Status__c = 'Cancel';
                    objLayer.Layer_Status_Date__c = Datetime.now();
                    lstMRSLayersUpdated.add(objLayer);
                }
            }
        }
        
        return lstMRSLayersUpdated;
    }

    /**
        This method is for calculating rollup status in MRS Layer Association objects. 
        @method name: calculateLayerStatus
        @parameter:   1. List of MRS Layers.
                      2. Map of MRS Layer Chip Association records with MRS Layer Association Id as the key.
        @return :     list of MRS Layer Association records to be updated with rollups.
     **/
    public static List < MRS_Layer_Association__c > calculateLayerStatus(List < MRS_Layer_Association__c > lstMRSLayers, Map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips) {

        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_ROLL_UP');
        if(null != env && env.value__c != 'ON') throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        //=======================================================

        set < Id > lstMRSLayersPendingResume = new set < Id > ();
        List < MRS_Layer_Association__c > lstMRSLayersUpdated = new List < MRS_Layer_Association__c > ();
        Set < String > setLayerStatus1 = new Set < String > {'N.A.', 'Not Ready', 'Not Done'};
        Set < String > setLayerStatus3 = new Set < String > {'N.A.', 'Released', 'Done', 'Approve'};

        for (MRS_Layer_Association__c objLayer: lstMRSLayers) {

            if (mapLayerIdToLayerChips != null && mapLayerIdToLayerChips.containsKey(objLayer.Id)) {
                //Customer GDSOUT Review
                Set < String > setCustomerGDSOUTReview = new Set < String > ();
                //Foundry GDSOUT Review
                Set < String > setFoundryGDSOUTReview = new Set < String > ();
                //Customer Frame Mockup Review
                Set < String > setCustomerFrameMockup = new Set < String > ();
                //Foundry Frame Mockup Review
                Set < String > setFoundryFrameMockup = new Set < String > ();
                //Send Prime Data
                Set < String > setSendPrimeData = new Set < String > ();
                //Send Frame Data
                Set < String > setSendFrameData = new Set < String > ();
                //DRW
                Set < String > setDRW = new Set < String > ();
                //ORC
                Set < String > setORC = new Set < String > ();
                //Customer Prime Remote Jobview
                Set < String > setCustomerPrimeRemote = new Set < String > ();
                //Customer Frame Remote Jobview
                Set < String > setCustomerFrameRemote = new Set < String > ();
                //Foundry Prime Remote Jobview
                Set < String > setFoundryPrimeRemote = new Set < String > ();
                //Foundry Frame Remote Jobview
                Set < String > setFoundryFrameRemote = new Set < String > ();
                //Prime MEBES Received
                Set < String > setPrimeMEBES = new Set < String > ();
                //Frame MEBES Received
                Set < String > setFrameMEBES = new Set < String > ();
                //Customer MEBES Jobview
                Set < String > setCustomerMEBES = new Set < String > ();
                //Foundry MEBES Jobview
                Set < String > setFoundryMEBES = new Set < String > ();
                //Globalshuttle MEBES Jobview
                Set < String > setGlobalshuttleMEBES = new Set < String > ();
                //MDP MEBES Jobview
                Set < String > setMDPMEBES = new Set < String > ();
                //Tapeout Applications MEBES Jobview
                Set < String > setTapeoutAppMEBES = new Set < String > ();
                //Tapeout Centre MEBES Jobview
                Set < String > setTapeoutCentreMEBES = new Set < String > ();
                //TDTI-MPW MEBES Jobview
                Set < String > setTDTIMPWMEBES = new Set < String > ();
                //Layer Chip Status
                Set < String > setLayerChipStatus = new Set < String > ();
                /** Resetting all the fields end **/
                
                list < MRS_Layer_Chip_Association__c > lstMRSLayerChipIterator = new list < MRS_Layer_Chip_Association__c > ();
                lstMRSLayerChipIterator.addAll(mapLayerIdToLayerChips.get(objLayer.Id));
                
                for (MRS_Layer_Chip_Association__c mrsLayerChipObj: mapLayerIdToLayerChips.get(objLayer.Id)) {
                    //Layer Chip Status
                    setLayerChipStatus.add(mrsLayerChipObj.Layer_Chip_Status__c);
                    //Do not calculate other statuses for Void & Cancel chips
                    if (mrsLayerChipObj.Layer_Chip_Status__c == 'Void' || mrsLayerChipObj.Layer_Chip_Status__c == 'Cancel' /*|| mrsLayerChipObj.Layer_Chip_Status__c == 'Hold'*/) continue;
                    //Customer GDSOUT Review
                    setCustomerGDSOUTReview.add(mrsLayerChipObj.Customer_GDSOUT_Review__c);
                    //Foundry GDSOUT Review
                    setFoundryGDSOUTReview.add(mrsLayerChipObj.Foundry_GDSOUT_Review__c);
                    //Customer Frame Mockup Review
                    setCustomerFrameMockup.add(mrsLayerChipObj.Customer_Frame_Mockup__c);
                    //Foundry Frame Mockup Review
                    setFoundryFrameMockup.add(mrsLayerChipObj.Foundry_Frame_Mockup__c);
                    //Send Prime Data              
                    setSendPrimeData.add(mrsLayerChipObj.Send_Prime_Data__c);
                    //Send Frame Data                
                    setSendFrameData.add(mrsLayerChipObj.Send_Frame_Data__c);
                    //DRW
                    setDRW.add(mrsLayerChipObj.DRW__c);
                    //ORC
                    setORC.add(mrsLayerChipObj.ORC__c);
                    //Customer Prime Remote Jobview Status
                    setCustomerPrimeRemote.add(mrsLayerChipObj.Customer_Prime_Remote_Jobview_Setup__c);
                    //Customer Frame Remote Jobview Status
                    setCustomerFrameRemote.add(mrsLayerChipObj.Customer_Frame_Remote_Jobview_Setup__c);
                    //Foundry Prime Remote Jobview Status
                    setFoundryPrimeRemote.add(mrsLayerChipObj.Foundry_Prime_Remote_Jobview_Setup__c);
                    //Foundry Frame Remote Jobview Status
                    setFoundryFrameRemote.add(mrsLayerChipObj.Foundry_Frame_Remote_Jobview_Setup__c);
                    //Prime MEBES Received                  
                    setPrimeMEBES.add(mrsLayerChipObj.Prime_MEBES_Received__c);
                    //Frame MEBES Received                  
                    setFrameMEBES.add(mrsLayerChipObj.Frame_MEBES_Received__c);
                    //Customer MEBES Jobview           
                    setCustomerMEBES.add(mrsLayerChipObj.Customer_MEBES_Jobview__c);
                    //Foundry MEBES Jobview                 
                    setFoundryMEBES.add(mrsLayerChipObj.Foundry_MEBES_Jobview__c);
                    //GlobalShuttle MEBES Jobview                   
                    setGlobalshuttleMEBES.add(mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c);
                    //MDP MEBES Jobview                 
                    setMDPMEBES.add(mrsLayerChipObj.MDP_MEBES_Jobview__c);
                    //Tapeout Application MEBES Jobview                
                    setTapeoutAppMEBES.add(mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c);
                    //Tapeout Centre MEBES Jobview                                          
                    setTapeoutCentreMEBES.add(mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c);
                    //TDTI-MPW MEBES Jobview                    
                    setTDTIMPWMEBES.add(mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c);
                }
                
                //Customer GDSOUT Review
                if (!setCustomerGDSOUTReview.isEmpty()) objLayer.Customer_GDSOUT_Review__c = calculateGDSOUTReview(setCustomerGDSOUTReview);

                //Foundry GDSOUT Review
                if (!setFoundryGDSOUTReview.isEmpty()) objLayer.Foundry_GDSOUT_Review__c = calculateGDSOUTReview(setFoundryGDSOUTReview);

                //Customer Frame Mockup Review
                if (!setCustomerFrameMockup.isEmpty()) objLayer.Customer_Frame_Mockup__c = calculateFrameMockup(setCustomerFrameMockup);

                //Foundry Frame Mockup Review
                if (!setFoundryFrameMockup.isEmpty()) objLayer.Foundry_Frame_Mockup__c = calculateFrameMockup(setFoundryFrameMockup);

                //Send Prime Data
                if (!setSendPrimeData.isEmpty()) objLayer.Send_Prime_Data__c = calculateSendData(setSendPrimeData);

                //Send Frame Data
                if (!setSendFrameData.isEmpty()) objLayer.Send_Frame_Data__c = calculateSendData(setSendFrameData);

                //DRW
                if (!setDRW.isEmpty()) objLayer.DRW__c = calculateDRW(setDRW);

                //ORC
                if (!setORC.isEmpty()) objLayer.ORC__c = calculateORC(setORC);

                //Customer Prime Remote Jobview Status
                if (!setCustomerPrimeRemote.isEmpty()) objLayer.Customer_Prime_Remote_Jobview_Setup__c = calculateRemoteSetup(setCustomerPrimeRemote);

                //Customer Frame Remote Jobview Status
                if (!setCustomerFrameRemote.isEmpty()) objLayer.Customer_Frame_Remote_Jobview_Setup__c = calculateRemoteSetup(setCustomerFrameRemote);

                //Foundry Prime Remote Jobview Status
                if (!setFoundryPrimeRemote.isEmpty()) objLayer.Foundry_Prime_Remote_Jobview_Setup__c = calculateRemoteSetup(setFoundryPrimeRemote);

                //Foundry Frame Remote Jobview Status
                if (!setFoundryFrameRemote.isEmpty()) objLayer.Foundry_Frame_Remote_Jobview_Setup__c = calculateRemoteSetup(setFoundryFrameRemote);

                //Prime MEBES Received
                if (!setPrimeMEBES.isEmpty()) objLayer.Prime_MEBES_Received__c = calculateMEBESReceived(setPrimeMEBES);

                //Frame MEBES Received
                if (!setFrameMEBES.isEmpty()) objLayer.Frame_MEBES_Received__c = calculateMEBESReceived(setFrameMEBES);

                //Customer MEBES Jobview
                if (!setCustomerMEBES.isEmpty()) objLayer.Customer_MEBES_Jobview__c = calculateMEBESJV(setCustomerMEBES);

                //Foundry MEBES Jobview
                if (!setFoundryMEBES.isEmpty()) objLayer.Foundry_MEBES_Jobview__c = calculateMEBESJV(setFoundryMEBES);

                //GlobalShuttle MEBES Jobview
                if (!setGlobalShuttleMEBES.isEmpty()) objLayer.GlobalShuttle_MEBES_Jobview__c = calculateMEBESJV(setGlobalShuttleMEBES);

                //MDP MEBES Jobview
                if (!setMDPMEBES.isEmpty()) objLayer.MDP_MEBES_Jobview__c = calculateMEBESJV(setMDPMEBES);

                //Tapeout Application MEBES Jobview
                if (!setTapeoutAppMEBES.isEmpty()) objLayer.Tapeout_Applications_MEBES_Jobview__c = calculateMEBESJV(setTapeoutAppMEBES);

                //Tapeout Centre MEBES Jobview
                if (!setTapeoutCentreMEBES.isEmpty()) objLayer.Tapeout_Centre_MEBES_Jobview__c = calculateMEBESJV(setTapeoutCentreMEBES);

                //TDTI-MPW MEBES Jobview
                if (!setTDTIMPWMEBES.isEmpty()) objLayer.TDTI_MPW_MEBES_Jobview__c = calculateMEBESJV(setTDTIMPWMEBES);

                //MAIN SHOW
                if (setLayerChipStatus.contains('Hold')) {
                    objLayer.Layer_Status__c = 'Hold';//this is hold by roll up calculation, user didn't go to layer and specific hold there fyi
                } else if (setLayerChipStatus.contains('Void') && (setLayerChipStatus.size() == 1 || (setLayerChipStatus.size() == 2 && setLayerChipStatus.contains('Cancel')))) {
                    objLayer.Hold_Layer_By_User__c = false;//SWGP-866: reset hold flag
                    objLayer.Hold_By__c = null;//swgp-919: reset hold by 
                    objLayer.Layer_Status__c = 'Void';
                } else if (setLayerChipStatus.contains('Cancel') && setLayerChipStatus.size() == 1) { 
                    objLayer.Hold_Layer_By_User__c = false;//SWGP-866: reset hold flag
                    objLayer.Hold_By__c = null;//swgp-919: reset hold by
                    objLayer.Layer_Status__c = 'Cancel';
                }
                //swgp-866: MRS Layer status should be auto-rolled up when a Foundry Jobviewer off-hold/resume any layer chip record at Layer Chip level
                //     ~~~~_________    Lift off this = allow layer roll up from Hold >>> In Progress/Released
                //                  V Hold_Layer_By_User__c
                //if layer is hold by user >>> any un-hold at chip level will no roll up back to layer level
                else if (!objLayer.Hold_Layer_By_User__c && objLayer.Layer_Status__c != 'Shipped' && lstMRSLayerChipIterator.size() > 0) { //TASK-1970//TASK-2314//SWGP-515
                //Hold_Layer_By_User__c: this flag is set/reset in MRSHoldResumeExtn class also
                //swgp-866=============================================================
                    
                    if (setLayerStatus1.contains(objLayer.Customer_GDSOUT_Review__c) && setLayerStatus1.contains(objLayer.Foundry_GDSOUT_Review__c) && setLayerStatus1.contains(objLayer.Customer_Frame_Mockup__c) && setLayerStatus1.contains(objLayer.Foundry_Frame_Mockup__c) && setLayerStatus1.contains(objLayer.Send_Prime_Data__c) && setLayerStatus1.contains(objLayer.Send_Frame_Data__c) && setLayerStatus1.contains(objLayer.DRW__c) && setLayerStatus1.contains(objLayer.ORC__c) && setLayerStatus1.contains(objLayer.Prime_MEBES_Received__c) && setLayerStatus1.contains(objLayer.Frame_MEBES_Received__c) && setLayerStatus1.contains(objLayer.Customer_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.Foundry_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.GlobalShuttle_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.MDP_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.Tapeout_Applications_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.Tapeout_Centre_MEBES_Jobview__c) && setLayerStatus1.contains(objLayer.TDTI_MPW_MEBES_Jobview__c)) {
                        objLayer.Layer_Status__c = 'Not Ready';
                    } else if (setLayerStatus3.contains(objLayer.Customer_GDSOUT_Review__c) && setLayerStatus3.contains(objLayer.Foundry_GDSOUT_Review__c) && setLayerStatus3.contains(objLayer.Customer_Frame_Mockup__c) && setLayerStatus3.contains(objLayer.Foundry_Frame_Mockup__c) && setLayerStatus3.contains(objLayer.Send_Prime_Data__c) && setLayerStatus3.contains(objLayer.Send_Frame_Data__c) && setLayerStatus3.contains(objLayer.DRW__c) && setLayerStatus3.contains(objLayer.ORC__c) && setLayerStatus3.contains(objLayer.Prime_MEBES_Received__c) && setLayerStatus3.contains(objLayer.Frame_MEBES_Received__c) && setLayerStatus3.contains(objLayer.Customer_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.Foundry_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.GlobalShuttle_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.MDP_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.Tapeout_Applications_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.Tapeout_Centre_MEBES_Jobview__c) && setLayerStatus3.contains(objLayer.TDTI_MPW_MEBES_Jobview__c)) {
                        //TASK-2261: When MRS Layer is going to change status to 'Release', system need to ensure there are at least one "Prime" 
                        //MRS Layer Chip and at least one "Frame" MRS Layer Chip under this MRS Layer. 
                        // If above conditions are not met, system will not change the MRS Layer to 'Release' status.
                        if (MRSHandlerUtilityExtn.hasFrameAndPrime(objLayer, lstMRSLayerChipIterator)) objLayer.Layer_Status__c = 'Released';
                        else if (objLayer.Layer_Status__c == 'Hold') objLayer.Layer_Status__c = 'In Progress';
                    } else {
                        objLayer.Layer_Status__c = 'In Progress';
                    }
                }

                lstMRSLayersUpdated.add(objLayer);
            }
        }

        return lstMRSLayersUpdated;
    }

    /*
     * Calculate roll up for GDSOUT Review
     */
    public static String calculateGDSOUTReview(Set < String > s) {
        String result = '';
        if (s.contains('Approve')) {
            if (s.contains('Not Ready') || s.contains('Ready')) {
                result = 'In Progress';
            } else {
                result = 'Approve';
            }
        } else {
            if (s.contains('Not Ready')) {
                result = 'Not Ready';
            } else if (s.contains('Ready')) {
                result = 'Ready';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /*
     * Calculate roll up for Frame Mockup
     */
    public static String calculateFrameMockup(Set < String > s) {
        String result = '';
        if (s.contains('Disapprove')) {
            result = 'In Progress';
        } else {
            result = calculateGDSOUTReview(s); //Same as GDSOUT Review
        }
        return result;
    }

    /*
     * Calculate roll up for ORC
     */
    public static String calculateORC(Set < String > s) {
        String result = '';
        if (s.contains('Done')) {
            if (s.contains('Not Done') || s.contains('In Progress')) {
                result = 'In Progress';
            } else {
                result = 'Done';
            }
        } else {
            if (s.contains('In Progress')) {
                result = 'In Progress';
            } else if (s.contains('Not Done')) {
                result = 'Not Done';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /*
     * Calculate roll up for DRW
     */
    public static String calculateDRW(Set < String > s) {
        String result = '';
        if (s.contains('Done')) {
            if (s.contains('Not Ready') || s.contains('In Progress')) {
                result = 'In Progress';
            } else {
                result = 'Done';
            }
        } else {
            if (s.contains('In Progress')) {
                result = 'In Progress';
            } else if (s.contains('Not Ready')) {
                result = 'Not Ready';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /*
     * Calculate roll up for Send Data
     */
    public static String calculateSendData(Set < String > s) {
        String result = '';
        if (s.contains('Done')) {
            if (s.contains('Not Done')) {
                result = 'In Progress';
            } else {
                result = 'Done';
            }
        } else {
            if (s.contains('Not Done')) {
                result = 'Not Done';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /*
     * Calculate roll up for Remote Jobview Setup
     */
    public static String calculateRemoteSetup(Set < String > s) {
        String result = '';
        if (s.contains('N.A.') && !s.contains('Done')) {
            result = 'N.A.';
        } else if (s.contains('Done')) {
            result = 'Done';
        }
        return result;
    }

    /*
     * Calculate roll up for MEBES Received
     */
    public static String calculateMEBESReceived(Set < String > s) {
        String result = '';
        if (s.contains('Done')) {
            if (s.contains('Not Done')) {
                result = 'In Progress';
            } else {
                result = 'Done';
            }
        } else {
            if (s.contains('Not Done')) {
                result = 'Not Done';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /*
     * Calculate roll up for MEBES Jobview
     */
    public static String calculateMEBESJV(Set < String > s) {
        String result = '';
        if (s.contains('Released')) {
            if (s.contains('Not Ready') || s.contains('Ready')) {
                result = 'In Progress';
            } else {
                result = 'Released';
            }
        } else {
            if (s.contains('Not Ready')) {
                result = 'Not Ready';
            } else if (s.contains('Ready')) {
                result = 'Ready';
            } else {
                result = 'N.A.';
            }
        }
        return result;
    }

    /**
        This method is used to send email only when the status of chips gets 'Ready'. 

        @method name: sendRedyMailToCustomerAndFoundry
        @return :     none.
     **/

    public static void sendRedyMailToCustomerAndFoundry(List < MRS_Layer_Chip_Association__c > lstTosendReadyEmails) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2 End*/

        String key;

        Map < Id, MRS_Layer_Chip_Association__c > customerFrameMockup = new Map < Id, MRS_Layer_Chip_Association__c > ();
        Map < Id, MRS_Layer_Chip_Association__c > foundryFrameMockup = new Map < Id, MRS_Layer_Chip_Association__c > ();
        List < String > strFFMU = new List < String > ();

        Map < String, List < MRS_Layer_Chip_Association__c >> mapCustomerFrameMockupStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapFoundryFrameMockupStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        List < MRS_Layer_Chip_Association__c > mrsLayerChipAsso;
        Set < Id > chipId = new Set < Id > ();
        Set < Id > maskLayerId = new Set < Id > ();
        Set < Id > ptrfIdlst = new Set < Id > ();
        Set < Id > customerId = new Set < Id > ();
        List < String > jobViewEmail = new List < String > ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstTosendReadyEmails) {
            chipId.add(mrsLayerChipObj.chip__c);
            maskLayerId.add(mrsLayerChipObj.Layer__c);
            ptrfIdlst.add(mrsLayerChipObj.PTRF__c);
        }
        OrgWideEmailAddress Orgid = [Select id, DisplayName From OrgWideEmailAddress where DisplayName = : 'GLOBALFOUNDRIES'
        LIMIT 1];
        Map < Id, MRS_Layer_Association__c > layerIdMap = new Map < Id, MRS_Layer_Association__c > ([SELECT Id, Name, Mask_Layer_Rev__c, ROM_Code__c, MRS__r.Mask_Set_Title__c FROM MRS_Layer_Association__c WHERE Id IN: maskLayerId]);
        Map < Id, PTRF__c > ptrfIdMap = new Map < Id, PTRF__c > ([SELECT Id, Name, Tech_Geo__c, MaskSetTitle__c FROM PTRF__c WHERE Id IN: ptrfIdlst]);
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstTosendReadyEmails) {

            if (mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready' && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c + ':' + ptrfIdMap.get(mrsLayerChipObj.PTRF__c).MaskSetTitle__c;
                if (mapFoundryFrameMockupStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapFoundryFrameMockupStringmrsLayerChip.put(key, mrsLayerChipAsso);
                } else {
                    mapFoundryFrameMockupStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }
            }
            if (mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready' && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c + ':' + ptrfIdMap.get(mrsLayerChipObj.PTRF__c).MaskSetTitle__c;
                if (mapCustomerFrameMockupStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapCustomerFrameMockupStringmrsLayerChip.put(key, mrsLayerChipAsso);
                } else {
                    mapCustomerFrameMockupStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }
            }
            customerId.add(mrsLayerChipObj.Customer_Name__c);

        }

        //-------------------------------cc Address------------------------------------------------------//

        Map < Id, Id > groupId_userIdMap = new Map < Id, Id > ();
        Map < Id, Group > lstgroupObj = new Map < Id, Group > ([SELECT Id, DeveloperName FROM Group WHERE DeveloperName in ('Swift_Tapeout_Centre', 'Swift_MDP')]);

        List < GroupMember > lstgroupMember;
        if (lstgroupObj != null) {
            lstgroupMember = [Select Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: lstgroupObj.keySet()];
        }

        if (lstgroupMember != null) {
            for (GroupMember groupMemberObj: lstgroupMember) {
                groupId_userIdMap.put(groupMemberObj.UserOrGroupId, groupMemberObj.GroupId);
            }
        }

        List < User > userlst;
        if (groupId_userIdMap != null && groupId_userIdMap.size() > 0) {
            userlst = [Select Email, Name, Portal_Email__c From User Where Id IN: groupId_userIdMap.keySet() AND IsActive = true];
        }
        List < String > mdplst = new List < String > ();
        List < String > ccAddresslst = new List < String > ();

        if (Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')) {
            ccAddresslst.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
        } else {
            ccAddresslst.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
        }
        if (Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.contains(';')) {
            mdplst.addAll(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.split(';'));
        } else {
            mdplst.add(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c);
        }

        //-------------------------To Address-----------------------------------------------------//
        List < PTRF_JobViewer_Info__c > ptrfJobCustomerFrameMockupReviewiew = [SELECT User__r.Email, Jobview_Type__c, PTRF__c, Jobview__c, User__r.Portal_Email__c, Email_Address__c, User__r.isActive
        FROM PTRF_JobViewer_Info__c
        WHERE PTRF__c IN: ptrfIdlst
        AND(Jobview_Type__c INCLUDES('Frame Mockup'))
        AND(Jobview__c = 'Customer')
        //AND User__r.IsActive =true
        ];
        List < PTRF_JobViewer_Info__c > ptrfJobFoundryFrameMockupReviewiew = [SELECT User__r.Email, Jobview_Type__c, PTRF__c, Jobview__c, User__r.Portal_Email__c, Email_Address__c, User__r.isActive
        FROM PTRF_JobViewer_Info__c
        WHERE PTRF__c IN: ptrfIdlst
        AND(Jobview_Type__c INCLUDES('Frame Mockup'))
        AND(Jobview__c = 'Foundry')
        // AND User__r.IsActive =true
        ];
        String[] ptrfJobViewCustomer = new String[] {};
        Integer ptrfCustomerFrameMockup = 0;
        List < String > frameMockupCustomer = new List < String > ();
        List < String > frameMockupFoundry = new List < String > ();
        if (Label.MRS_Send_Email_To_Customer.equalsIgnoreCase('Yes')) {
            if (ptrfJobCustomerFrameMockupReviewiew != null) {
                ptrfJobViewCustomer = new String[ptrfJobCustomerFrameMockupReviewiew.size()];
                for (PTRF_JobViewer_Info__c ptrfjobViewInfo: ptrfJobCustomerFrameMockupReviewiew) {
                    if (ptrfjobViewInfo.User__c != null && ptrfjobViewInfo.User__r.isActive) {
                        ptrfJobViewCustomer.add(ptrfjobViewInfo.User__r.Portal_Email__c);
                        frameMockupCustomer.add(ptrfjobViewInfo.User__r.Portal_Email__c);
                        ptrfCustomerFrameMockup++;
                    } else {
                        ptrfJobViewCustomer.add(ptrfjobViewInfo.Email_Address__c);
                        frameMockupCustomer.add(ptrfjobViewInfo.Email_Address__c);
                        ptrfCustomerFrameMockup++;
                    }
                }
            }
        }
        list < Account_Team_Proxy__c > lstAccountTeamProxy;
        List < String > teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        lstAccountTeamProxy = [SELECT Account__c, User__c, User_Email__c, Team_Role__c FROM Account_Team_Proxy__c WHERE Account__c IN: customerId AND Team_Role__c IN: teamRole AND User__r.IsActive = true];
        if (lstAccountTeamProxy != null && lstAccountTeamProxy.size() > 0) {
            for (Account_Team_Proxy__c accountProxy: lstAccountTeamProxy) {
                ptrfJobViewCustomer.add(accountProxy.User_Email__c);
            }
        }

        String[] ptrfJobViewFoundry;
        Integer ptrfFoundryJobView = 0;
        if (ptrfJobFoundryFrameMockupReviewiew != null) {
            ptrfJobViewFoundry = new String[ptrfJobFoundryFrameMockupReviewiew.size()];
            for (PTRF_JobViewer_Info__c ptrfjobViewInfo: ptrfJobFoundryFrameMockupReviewiew) {
                if (ptrfjobViewInfo.User__c != null && ptrfjobViewInfo.User__r.isActive) {
                    ptrfJobViewFoundry[ptrfFoundryJobView] = ptrfjobViewInfo.User__r.Portal_Email__c;
                    ptrfFoundryJobView++;
                    frameMockupFoundry.add(ptrfjobViewInfo.User__r.Portal_Email__c);
                } else {
                    ptrfJobViewFoundry[ptrfFoundryJobView] = ptrfjobViewInfo.Email_Address__c;
                    ptrfFoundryJobView++;
                    frameMockupFoundry.add(ptrfjobViewInfo.Email_Address__c);
                }
            }
        }

        //----------------------Start of bccAddress----------------------------------------------------//
        Integer counter = 0;
        String[] swiftAdmn;
        swiftAdmn = new String[] {};

        if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
            swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
        } else {
            swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
        }

        Map < Id, MRS_Chip_Details__c > mapChipId;
        if (chipId != null && chipId.size() > 0) {
            mapChipId = new Map < Id, MRS_Chip_Details__c > ([SELECT Id, Name FROM MRS_Chip_Details__c WHERE Id IN: chipId]);
        }

        Map < Id, MRS_Layer_Association__c > mapLayerId = new Map < Id, MRS_Layer_Association__c > ([SELECT Id, Name, Mask_Layer_Rev__c, ROM_Code__c FROM MRS_Layer_Association__c WHERE Id IN: maskLayerId]);
        //--------------------------End of bcc Address---------------------------------------------//

        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};

        for (String keyId: mapCustomerFrameMockupStringmrsLayerChip.keySet()) {

            /*ECP2 Start*/

            if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                mapLCACategory.put('CUSTOMER_GATING', mapCustomerFrameMockupStringmrsLayerChip.get(keyId));
            } else {
                mapLCACategory.get('CUSTOMER_GATING').addAll(mapCustomerFrameMockupStringmrsLayerChip.get(keyId));
            }

            /*ECP2 End*/
            for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mapCustomerFrameMockupStringmrsLayerChip.get(keyId)) {
                if (mrsLayerChipObject.PTRF__r.Tech_Geo__c != null) {
                    String techGeo = mrsLayerChipObject.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim();
                    if (techGeo == null) techGeo = mrsLayerChipObject.PTRF__r.Tech_Geo__c.substringBefore('UM').trim();
                    if (double.valueOf(techGeo) <= 0.02) {
                        ccAddresslst.addAll(mdplst);
                    }
                }
            }
        }

        for (String keyId: mapFoundryFrameMockupStringmrsLayerChip.keySet()) {

            /*ECP2 Start*/
            if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                mapLCACategory.put('FOUNDRY_GATING', mapFoundryFrameMockupStringmrsLayerChip.get(keyId));
            } else {
                mapLCACategory.get('FOUNDRY_GATING').addAll(mapFoundryFrameMockupStringmrsLayerChip.get(keyId));
            }
            /*ECP2 End*/
            
            for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mapFoundryFrameMockupStringmrsLayerChip.get(keyId)) {
                if (mrsLayerChipObject.PTRF__r.Tech_Geo__c != null) {

                    String techGeo = mrsLayerChipObject.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim();
                    if (techGeo == null) techGeo = mrsLayerChipObject.PTRF__r.Tech_Geo__c.substringBefore('UM').trim();
                    if (double.valueOf(techGeo) <= 0.02) {
                        ccAddresslst.addAll(mdplst);
                    }
                }
            }
        }

        /*ECP2 Start*/
        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'SWIFT_Customer_Frame_Mockup_Ready_Email', null, 'Y', 'Customer_Frame_Mockup__c');
            }
            if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'SWIFT_Foundry_Frame_Mockup_Ready_Email', null, 'Y', 'Foundry_Frame_Mockup__c');
            }
        }
        /*ECP2 End*/
    }

    public static void sendDataDoneMailToCustomerAndFoundry(List < MRS_Layer_Chip_Association__c > lstSendData) {
        Map < String, Map < String, String >> mapPTRFtoData = new Map < string, Map < String, String >> ();

        Map < String, String > tempMap;

        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2 End*/

        Map < Id, List < MRS_Layer_Chip_Association__c >> ptrfIdMRSLayerChipAssociation = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();

        Set < Id > accountIdSt = new Set < Id > ();
        Set < Id > ptrfIdSt = new Set < Id > ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstSendData) {
            if (mrsLayerChipObj.Send_Prime_Data__c == 'Done' || mrsLayerChipObj.Send_Frame_Data__c == 'Done') {
                tempMap = new Map < String, String > ();
                accountIdSt.add(mrsLayerChipObj.Customer_Name__c);
                ptrfIdSt.add(mrsLayerChipObj.PTRF__c);
                if (ptrfIdMRSLayerChipAssociation.containsKey(mrsLayerChipObj.PTRF__c)) {
                    ptrfIdMRSLayerChipAssociation.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChipLst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipLst.add(mrsLayerChipObj);
                    ptrfIdMRSLayerChipAssociation.put(mrsLayerChipObj.PTRF__c, mrsLayerChipLst);
                }
            }
        }

        for (Id ptrfId: ptrfIdMRSLayerChipAssociation.keySet()) {
            Set < String > chipNameSet = new Set < String > ();
            Set < String > layerNameSet = new Set < String > ();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = ptrfIdMRSLayerChipAssociation.get(ptrfId);

            /*ECP2 Start*/
            if (!mapLCACategory.containsKey('LayerChipRecord')) {
                mapLCACategory.put('LayerChipRecord', mrsLayerChiplst);
            } else {
                mapLCACategory.get('LayerChipRecord').addAll(mrsLayerChiplst);
            }
            /*ECP2 End*/
        }

        /*ECP2 Start*/
        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if (mapLCACategory.containsKey('LayerChipRecord')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('LayerChipRecord'), 'SWIFT_Send_Data_Done', null, 'NA', null);
        }
        /*ECP2 Start*/
    }

    /**
        This method is for performing DML Update Operation on the MRS Layer Chip Association object . 

        @method name: executeUpdateMCLA
        @return :     None.
     **/
    public static void executeUpdateMCLA(List < MRS_Layer_Chip_Association__c > lstMCLA) {
        if (lstMCLA != null && lstMCLA.size() > 0) {
            try {
                update lstMCLA;
            } catch (DMLException e) {
                saveMRSExceptionErrorLog(e, 'MRS Layer Chip Association', '', 'MRSHandlerUtility', 'executeUpdateMCLA');
                DRTHandlerUtility.handleErrorOnPTRF_AUPD(e, new set < string > {
                    lstMCLA.get(0).ptrf__r.name
                }, 'layer chip update', 'Exception on layer chip update');
            }
        }
    }

    /*
    This method is only USED FOR CANCEL LAYER CHIP WHEN PTRF IS CANCELLED!!!
    Reason why: don't know yet!!! Must be a mystery!!!
    */
    @future
    public static void executeUpdateMCLAFuture(List < ID > recordIds) {
        
        set<String> ptrfId = new set<String>();
        List < MRS_Layer_Chip_Association__c > lstMCLA = new List < MRS_Layer_Chip_Association__c > ();
        
        for (MRS_Layer_Chip_Association__c obj: [select Id, Layer_Chip_Status__c, ptrf__r.name from MRS_Layer_Chip_Association__c where Id in : recordIds]) {
            system.debug('hello_wolrd');
            //swgp-950
            if(obj.Layer_Chip_Status__c != 'Hold') {
                obj.Layer_Chip_Status__c = 'Cancel';
            } else { 
                obj.Is_Cancel_After_Off_Hold__c = true;
            }//swgp-950-end
            
            ptrfId.add(obj.ptrf__r.name);
            lstMCLA.add(obj);
        }
        
        try { update lstMCLA; } catch(DMLException e) { saveCancelExceptionSignal(e, ptrfId); }
    }
    
    /*
    This method only update parsed-in layer chip without try catch any exception as INTENDED...
    This method was introduced in SWGP-950.....................................................
    Create Date: 2-Nov-2016....................................................................
    */
    public static void updateLayerChip(list<MRS_Layer_Chip_Association__c> listUpdate) {
        update listUpdate;
    }
    
    /**
        This method is for performing DML Insert Operation on the MRS Layer Chip Association object . 

        @method name: executeInsertMCLA
        @return :     None.
     **/
    public static void executeInsertMCLA(List < MRS_Layer_Chip_Association__c > lstMCLA) {
        if (lstMCLA != null && lstMCLA.size() > 0) {
            try {
                insert lstMCLA;
            } catch (Exception e) {

                // TASK-2130  START
                set < string > setPTRFids = new set < string > ();
                if (lstMCLA != null) {
                    for (MRS_Layer_Chip_Association__c tempLayerChip: lstMCLA) {
                        if (tempLayerChip.PTRF__c != null) {
                            setPTRFids.add(tempLayerChip.PTRF__c);
                        }
                    }
                }

                sendMRSExceptionLogMail2(e, setPTRFIds);//send email to swift@
                // TASK-2130  END
            }
        }
    }

    /**
        This method is for performing DML Update Operation on the MRS Layer Association object . 

        @method name: executeUpdateMLA
        @return :     None.
     **/
    public static void executeUpdateMLA(List < MRS_Layer_Association__c > lstMLA) {
        if (lstMLA != null && lstMLA.size() > 0) {
            try {
                update lstMLA;
            } catch (DMLException e) {
                logException(e, lstMLA, 'Exception in updating MRS_Layer_Association', 'MRSHandlerUtility', 'executeInsertMCD');
            }
        }
    }

    /**
        This method is for performing DML Insert Operation on the MRS Layer Association object . 

        @method name: executeInsertMLA
        @return :     None.
     **/
    public static void executeInsertMLA(List < MRS_Layer_Association__c > lstMLA) {
        if (lstMLA != null && lstMLA.size() > 0) {
            try {
                insert lstMLA;
            } catch (DMLException e) {
                logException(e, lstMLA, 'Exception in creating MRS_Layer_Association', 'MRSHandlerUtility', 'executeInsertMCD');
            }
        }
    }

    /**
        This method is for performing DML Insert Operation on the MRS Chip Details object . 

        @method name: executeInsertMCD
        @return :     None.
     **/
    public static void executeInsertMCD(List < MRS_Chip_Details__c > lstMCD) {
        if (lstMCD != null && lstMCD.size() > 0) {
            try {
                insert lstMCD;
            } catch (DMLException e) {
                logException(e, lstMCD, 'Exception in creating MRS_Chip_Details', 'MRSHandlerUtility', 'executeInsertMCD');
            }
        }
    }

    /**
        This method is for logging errors caught in exception during Create MRS activity 
        @method name: logException
        @parameter:   1. Exception object.
                      2. List of objects to be created/updated.
                      3. MessageId of the log.
              4. Name of Component where exception occured
              5. Name of methid where exception occured.            
        @return :     Nothing
     **/
    public static void logException(Exception e, List < sObject > objects, String msgID, String clazz, String method) {

        String objJSON = JSON.serializePretty(objects);
        if (objJSON.length() > 32000) {
            objJSON = objJSON.subString(0, 32000);
        }
        saveMRSExceptionErrorLog(e, objJSON, msgID, clazz, method);
    }

    /**
        This method is for making the Order Status of a PTRF closed if all the MRS Layers associated with the PTRF is in Shipped Status . 
        @method name: closePTRFOnShippedLayers
        @parameter:   Set of MRS Layer ids.
        @return :     None.
     **/

    public static void closePTRFOnShippedLayers(set < String > setShippedLayerIds) {

        Set < string > setPTRF = new Set < string > ();
        Map < Id, set < String >> mapMLA = new Map < Id, set < String >> ();
        List < PTRF__c > lstPTRFToClosed = new List < PTRF__c > ();
        set < String > setPTRFIds = new set < String > ();

        if (setShippedLayerIds != null && !setShippedLayerIds.isEmpty()) {
            for (MRS_Layer_Chip_Association__c objMLCA: [select PTRF__c from MRS_Layer_Chip_Association__c where Layer__c in : setShippedLayerIds]) {
                setPTRF.add(objMLCA.PTRF__c);
            }
            if (setPTRF != null && !setPTRF.isEmpty()) {
                for (MRS_Layer_Chip_Association__c objMLCA: [select Layer__r.Layer_Status__c, PTRF__c from MRS_Layer_Chip_Association__c where PTRF__c in : setPTRF]) {
                    set < String > tempSet = new set < String > ();
                    if (mapMLA.containsKey(objMLCA.PTRF__c)) {
                        tempSet.addAll(mapMLA.get(objMLCA.PTRF__c));
                    }
                    tempSet.add(objMLCA.Layer__r.Layer_Status__c);
                    mapMLA.put(objMLCA.PTRF__c, tempSet);
                }
                if (mapMLA != null && !mapMLA.isEmpty()) {
                    for (String ptrfid: mapMLA.keyset()) {
                        Boolean isShipped = true;
                        set < String > setLayerStatus = new set < String > ();
                        setLayerStatus.addAll(mapMLA.get(ptrfId));
                        for (string Status: setLayerStatus) {
                            if (Status != 'Shipped') {
                                isShipped = false;
                            }
                        }

                        if (isShipped) {
                            setPTRFIds.add(ptrfId);
                        }
                    }
                    if (setPTRFIds != null && !setPTRFIds.isEmpty()) {
                        for (PTRF__c objPTRF: [select Status__c from PTRF__c where id in : setPTRFIds]) {
                            objPTRF.Status__c = 'Closed';
                            lstPTRFToClosed.add(objPTRF);
                        }
                        if (lstPTRFToClosed != null && lstPTRFToClosed.size() > 0) {
                            try {
                                update lstPTRFToClosed;
                            } catch (Exception ex) { }
                        }
                    }
                }
            }
        }
    }

    /**
        This method is for sending Emails to Field Engineers whenever a PTRF having Released Layers is added to MRS. (Email Template 7)
        @method name: sendEmailOnAddingReleasedLayersToMRS
        @parameter:   Map of MRS Layer Records.
        @return :     None.
     **/
    public static void sendEmailOnAddingReleasedLayersToMRS(map < String, MRS_Layer_Association__c > mapReleasedMLA) {
        list < MRS_Layer_Association__c > listLayers = new list < MRS_Layer_Association__c > ();
        if (mapReleasedMLA.size() > 0) {
            listLayers.addAll(mapReleasedMLA.values());
            if (listLayers.size() > 0) {
                EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Device_Layer_s_had_been_released_shipped', listLayers, null, setPtrfWithReleasedLayers, null);
            }
        }

    }
    
    public static void sendEmailOnReleasedLayers(map < String, MRS_Layer_Association__c > mapReleasedLayerIds, list < String > listLayerIds) {
        EmailTemplate et = [Select id, Subject, Body, HtmlValue, DeveloperName from EmailTemplate where DeveloperName = : 'SWIFT_Layer_is_Released_To_Maskshop'];
        list < MRS_Layer_Association__c > listLayers = new list < MRS_Layer_Association__c > ();
        list < MRS_Layer_Chip_Association__c > listLayerChips = new list < MRS_Layer_Chip_Association__c > ();
        map < Id, String > mapLayerAssoToStatus = new map < Id, String > ();

        Set < String > setEmailTemplates = new Set < String > ();
        setEmailTemplates.add('SWIFT_Layer_is_Released_To_Maskshop');
        Map < String, PerMaskshopHoldResumeLocals__c > mapChipLocalFields = PerMaskshopHoldResumeLocals__c.getAll();
        Set < String > setChipLocalFields = new Set < String > ();
        if (mapChipLocalFields != null && mapChipLocalFields.size() > 0) {
            setChipLocalFields.addAll(mapChipLocalFields.keySet());
        }
        Set < String > setChipGlobalFields = new Set < String > ();
        Map < string, set < string >> mapChipGlobalFields = EmailSubjectBodyPerMaskshop.createQueryString(setEmailTemplates);
        if (mapChipGlobalFields != null && mapChipGlobalFields.size() > 0) {
            setChipGlobalFields = mapChipGlobalFields.get('SWIFT_Layer_is_Released_To_Maskshop');
        }

        if (setChipGlobalFields.size() > 0) {
            setChipLocalFields.addAll(setChipGlobalFields);
        }

        List < String > lstChipAllFields = new List < String > ();
        lstChipAllFields.addAll(setChipLocalFields);
        String setFields = String.join(lstChipAllFields, ',');
        String Query = '';

        if (listLayerIds.size() > 0) {
            for (String layerId: listLayerIds) {
                listLayers.add(mapReleasedLayerIds.get(layerId));
                mapLayerAssoToStatus.put(mapReleasedLayerIds.get(layerId).Id, mapReleasedLayerIds.get(layerId).Layer_Status__c);
            }
            if (setFields != null && setFields != '') {
                
                //swgp-1168: stop release/maskwrite emails for fab9,10 ptrf
                
                String fabToStopRTMEmail = 'Fab9;Fab10';
                try { fabToStopRTMEmail = Environment_Variable__c.getInstance('SWIFT_FAB_VALUE_STOP_RTM_EMAIL').value__c; } catch(exception e) {fabToStopRTMEmail = 'Fab9;Fab10';}
                
                list<String> fabList = new list<String>();
                fabList = fabToStopRTMEmail.split(';');
                
                Query = 'SELECT ' + setFields 
                    + ' FROM MRS_Layer_Chip_Association__c  ' 
                    + ' where layer__c IN: listLayerIds AND PTRF__r.Status__c=\'Perform Tapeout Options\' ' 
                    + ' AND PTRF__r.Maskshop__c!=null AND Layer_Chip_Status__c != \'Cancel\' '
                    + ' AND PTRF__r.Fab__c not in :fabList';//swgp-1168
            }
            listLayerChips = Database.query(Query);
            
            EmailHandlerUtilityPerMaskshop.sendEmailPerMaskshop(et, listLayers, listLayerChips, null, mapLayerAssoToStatus, false);

        }

    }

    //Modified on 26/11 For Email Config 
    //TASK-2176                     

    /**
        This method is for sending Emails for Mask Write when a MRS Layer gets released. (Email Template: 1B) 
        @method name: sendEmailOnReleasedLayersToCustomerFoundryFE
        @parameter:   map of Released Layer Ids to MRS Layer Association records.
        @return :     None.
     **/

    public static void sendEmailOnReleasedLayersToCustomerFoundryFE(map < String, MRS_Layer_Association__c > mapReleasedLayerIds, list < MRS_Layer_Association__c > listLayers) {
        if (listLayers.size() > 0) {
            EmailHandlerUtilityPerMST.sendEmailPerMST('SWIFT_Layer_is_Released_For_Mask_Write', listLayers, null);
        }

    }

    /**
        This method is for sending Emails to TECN Reviewers when a TECN status is not in released status. (Email Template: 1C) 
        @method name: sendEmailToTECNReviewers
        @parameter:   set of MRS Layer Association Ids.
        @return :     None.
     **/

    public static void sendEmailToTECNReviewers(set < MRS_Layer_Association__c > mrsLayerAssolst) {
        list < MRS_Layer_Association__c > listLayers = new list < MRS_Layer_Association__c > ();
        if (mrsLayerAssolst.size() > 0) {
            listLayers.addAll(mrsLayerAssolst);
            if (listLayers.size() > 0) {
                EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Mask_Write_is_hold_due_to_unreleased_TECN', listLayers, null);
            }
        }

    }

    /**
        This method is for retrieving MRS Layer Chip Association records corresponding to a combination of Customer and Mask Set Title in
        GDSOUT Review, Frame Mockup and MEBES Jobview screens. 

        @method name: resetMebesStatus
        @return :     None.
     **/

    public static void resetMebesStatus(String resetFlag) {
        boolean isSendEmail = false;
    }
    
    /**
   When Prime Or Frame MEBES RECEIVEDGETS 'Done' this function send email to MDP Users
   @Method : sendEmailToGlobalshuttle
   Parameter: 
     **/
    public static void sendEmailToGlobalshuttle(List < MRS_Layer_Chip_Association__c > mrsLayerChiplst, String Jobdeck, String jobviewRemark) {
        /*ECP2*/
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValuePair.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValuePair.put('JOBVIEW_REMARK', jobviewRemark);
        }
        Map < String, List < MRS_Layer_Chip_Association__c >> layerChipToSendEmail = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2*/

        Map < Id, List < MRS_Layer_Chip_Association__c >> mapptrfIdandmrsLayerChip = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c mrsChipLayerObj: mrsLayerChiplst) {
            if ((mrsChipLayerObj.Layer_Chip_Status__c != 'Cancel' && mrsChipLayerObj.Layer_Chip_Status__c != 'Void') && (mrsChipLayerObj.GlobalShuttle_MEBES_Jobview__c == 'Ready' || mrsChipLayerObj.TDTI_MPW_MEBES_Jobview__c == 'Ready')) {

                if (mapptrfIdandmrsLayerChip.containsKey(mrsChipLayerObj.PTRF__c)) {
                    mapptrfIdandmrsLayerChip.get(mrsChipLayerObj.PTRF__c).add(mrsChipLayerObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChipAddlts = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAddlts.add(mrsChipLayerObj);
                    mapptrfIdandmrsLayerChip.put(mrsChipLayerObj.PTRF__c, mrsLayerChipAddlts);
                }
            }
        }

        for (Id ptrfIdIterator: mapptrfIdandmrsLayerChip.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsLayerChipObjectlst = mapptrfIdandmrsLayerChip.get(ptrfIdIterator);
            if (mrsLayerChipObjectlst != null && mrsLayerChipObjectlst.size() > 0) {

                Double techGeo;
                if (mrsLayerChipObjectlst.get(0).PTRF__r.Tech_Geo__c != null) {
                    try {
                        techGeo = Double.valueOf(mrsLayerChipObjectlst.get(0).PTRF__r.Tech_Geo__c);
                    } catch (Exception e) {
                        techGeo = Double.valueOf(mrsLayerChipObjectlst.get(0).PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM'));
                    }

                    if (techGeo > 0.02 && mrsLayerChipObjectlst.get(0).Layer__c != null && (mrsLayerChipObjectlst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObjectlst.get(0).Layer_Chip_Status__c != 'Void') && (mrsLayerChipObjectlst.get(0).GlobalShuttle_MEBES_Jobview__c == 'Ready')) {
                        if (layerChipToSendEmail.containsKey('GLOBALSHUTTLE')) {
                            layerChipToSendEmail.get('GLOBALSHUTTLE').addAll(mrsLayerChipObjectlst);
                        } else {
                            layerChipToSendEmail.put('GLOBALSHUTTLE', mrsLayerChipObjectlst);
                        }
                    }
                    if (techGeo <= 0.02 && mrsLayerChipObjectlst.get(0).Layer__c != null && (mrsLayerChipObjectlst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObjectlst.get(0).Layer_Chip_Status__c != 'Void') && (mrsLayerChipObjectlst.get(0).TDTI_MPW_MEBES_Jobview__c == 'Ready')) {
                        if (layerChipToSendEmail.containsKey('TDTI')) {
                            layerChipToSendEmail.get('TDTI').addAll(mrsLayerChipObjectlst);
                        } else {
                            layerChipToSendEmail.put('TDTI', mrsLayerChipObjectlst);
                        }
                    }
                }
            }
        }

        if (layerChipToSendEmail.size() > 0) {
            EmailSubjectBodyPerPTRF emailSubjBody = new EmailSubjectBodyPerPTRF();
            if (layerChipToSendEmail.containsKey('GLOBALSHUTTLE')) {
                emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('GLOBALSHUTTLE'), 'SWIFT_GlobalShuttle_Initial', nameValuePair, 'Y', 'GlobalShuttle_MEBES_Jobview__c');
            }

            if (layerChipToSendEmail.containsKey('TDTI')) {
                emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('TDTI'), 'SWIFT_TDTI_Initial', nameValuePair, 'Y', 'TDTI_MPW_MEBES_Jobview__c');
            }
        }

    }

    /**
        Send Ready Email when GDSOUT Review gets ready
        Method Name:sendRedyMailToGDSOUTReview
        Parameters: List of MRS_Layer_Chip_Association__c,emailContainFromCadSystem
            emailContainFromCadSystem (swgp-805)
     **/
    public static void sendRedyMailToGDSOUTReview(List < MRS_Layer_Chip_Association__c > lstTosendReadyEmails, String emailContainFromCadSystem, String emailContainFromCadSystem_customer) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValuePair = new Map < String, String > ();
        /*ECP2 End*/

        Map < Id, MRS_Layer_Chip_Association__c > customerGDSOUTReview = new Map < Id, MRS_Layer_Chip_Association__c > ();
        Map < Id, MRS_Layer_Chip_Association__c > foundryGDSOUTReview = new Map < Id, MRS_Layer_Chip_Association__c > ();
        String key;
        Map < String, List < MRS_Layer_Chip_Association__c >> mapCustomerGDSOUTStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapGDSOUTStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        List < MRS_Layer_Chip_Association__c > mrsLayerChipAsso;

        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstTosendReadyEmails) {

            if ((mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready') && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c;
                if (mapCustomerGDSOUTStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapCustomerGDSOUTStringmrsLayerChip.put(key, mrsLayerChipAsso);

                } else {
                    mapCustomerGDSOUTStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }

            }
            if ((mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready') && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c;
                if (mapGDSOUTStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapGDSOUTStringmrsLayerChip.put(key, mrsLayerChipAsso);
                } else {
                    mapGDSOUTStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }
            }
            
            customerGDSOUTReview.put(mrsLayerChipObj.PTRF__c, mrsLayerChipObj);
        }




        for (String keyId: mapCustomerGDSOUTStringmrsLayerChip.keySet()) {

            List < MRS_Layer_Chip_Association__c > lstmrsLayerChip = mapCustomerGDSOUTStringmrsLayerChip.get(keyId);
            /*ECP2 Start*/
            if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                mapLCACategory.put('CUSTOMER_GATING', lstmrsLayerChip);
            } else {
                mapLCACategory.get('CUSTOMER_GATING').addAll(lstmrsLayerChip);
            }
            /*ECP2 End*/

        }

        for (String keyId: mapGDSOUTStringmrsLayerChip.keySet()) {

            List < MRS_Layer_Chip_Association__c > lstmrsLayerChip = mapGDSOUTStringmrsLayerChip.get(keyId);
            /*ECP2 Start*/
            if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                mapLCACategory.put('FOUNDRY_GATING', lstmrsLayerChip);
            } else {
                mapLCACategory.get('FOUNDRY_GATING').addAll(lstmrsLayerChip);
            }
            /*ECP2 End*/
        }

        /*ECP2 Start*/
        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
            //swgp-805
            if (emailContainFromCadSystem_customer != null) nameValuePair.put('EMAIL_CONTENT_FROM_CAD', emailContainFromCadSystem_customer);
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'SWIFT_Customer_Gating_GDSOUTReview', nameValuePair, 'Y', 'Customer_GDSOUT_Review__c');
        }
        
        nameValuePair.remove('EMAIL_CONTENT_FROM_CAD');//swgp-805
        
        if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
            //swgp-805
            if (emailContainFromCadSystem != null) nameValuePair.put('EMAIL_CONTENT_FROM_CAD', emailContainFromCadSystem);
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'SWIFT_Foundry_Gating_GDSOUTReview', nameValuePair, 'Y', 'Foundry_GDSOUT_Review__c');
        }
        /*ECP2 Start*/
    }

    /**
         Send Email to Customer and Foundry Prime Or Frame Remote JobView 
         Method Name: sendDoneEmailtoRemoteJobView
         Parameters: List of MRS_Layer_Chip_Association__c,Jobdeck

     **/
    public static void sendDoneEmailtoRemoteJobView(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, Boolean customerOrFoundry, Boolean isFoundry, String jobViewRemark) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobViewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobViewRemark);
        }
        /*ECP2 End*/

        String key;

        if (jobViewRemark == null) {
            jobViewRemark = '';
        }
        Set < Id > lstgettingPTRF = new Set < Id > ();
        Set < Id > lstnongettingPTRF = new Set < Id > ();
        Set < Id > lstPTRFId = new Set < Id > ();
        Set < Id > lstLayerId = new Set < Id > ();
        Set < Id > mrsLayerChipId = new Set < Id > ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mapOfPTRFIdAndMRSLayerChip = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mapOfptrfIdAndListFoundry = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        Set < Id > customerSt = new Set < Id > ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {

            if (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') {
                if ((mrsLayerChipObj.Customer_Prime_Remote_Jobview_Setup__c == 'Done' || mrsLayerChipObj.Customer_Frame_Remote_Jobview_Setup__c == 'Done') && mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Customer_jobview__c == 'Gating mask release') {

                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mapOfPTRFIdAndMRSLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapOfPTRFIdAndMRSLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfPTRFIdAndMRSLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
                if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Customer_jobview__c == 'Not gating mask release') { //TASK-1955

                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mapOfPTRFIdAndMRSLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapOfPTRFIdAndMRSLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfPTRFIdAndMRSLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
                if ((mrsLayerChipObj.Foundry_Prime_Remote_Jobview_Setup__c == 'Done' || mrsLayerChipObj.Foundry_Frame_Remote_Jobview_Setup__c == 'Done') && mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Foundry_jobview__c == 'Gating mask release') {

                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mapOfptrfIdAndListFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapOfptrfIdAndListFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfptrfIdAndListFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
                if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Foundry_jobview__c == 'Not gating mask release') { //TASK-1955
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mapOfptrfIdAndListFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapOfptrfIdAndListFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfptrfIdAndListFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
                customerSt.add(mrsLayerChipObj.Customer_Name__c);
            }
        }

        //---- Go LIVE Sanity Test Defect Fixed---------------------------------------------------------------------//

        //------------------------End of Go LIVE DEFECT Fixing---------------------------------------------------------------------//
        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();

        Integer counter;


        for (Id ptrfId: mapOfPTRFIdAndMRSLayerChip.keySet()) {

            chipLayerMap.clear();
            String chipToDisplay = '';

            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mapOfPTRFIdAndMRSLayerChip.get(ptrfId);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if (mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Gating mask release' && customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                        mapLCACategory.put('CUSTOMER_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                } else if (mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Not gating mask release' && customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                        mapLCACategory.put('CUSTOMER_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }

                Set < String > layerNameSet = new Set < String > ();
                Set < String > chipNameSet = new Set < String > ();
                layerNameSet.clear();
                chipNameSet.clear();
                counter = 0;
                String layerNameToDisplay;

                if ( /*subject != null  && subject.trim() != '' && (*/ mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void' /*)*/ ) {
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {



                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerNameToDisplay = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')'; //layerNameSet.add(mrsLayerChipObject.Layer__r.Name+mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObject.Layer__r.ROM_Code__c +')');
                        } else {
                            layerNameToDisplay = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c; //layerNameSet.add(mrsLayerChipObject.Layer__r.Name+mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c);
                        }
                        layerNameSet.add(layerNameToDisplay);
                        chipNameSet.add(mrsLayerChipObject.Chip_Name__c);


                        if (chipLayerMap.get(mrsLayerChipObject.Chip__r.Name) != null) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerNameToDisplay);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerNameToDisplay);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }

                        counter++;


                    }

                    String chipName;
                    counter = 0;
                    if (chipNameSet.size() > 0) {
                        for (String chip: chipNameSet) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    String layerName;
                    counter = 0;
                    if (layerNameSet.size() > 0) {
                        for (String layer: layerNameSet) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    if (Jobdeck == null) {
                        Jobdeck = '';
                    }
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalcounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalcounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalcounter = internalcounter + 1;
                        }
                        chipToDisplay = chipToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipToDisplay = chipToDisplay + '<tr><td><br/></td></tr><tr><td> Jobdeck ' + Jobdeck + '</td></tr>';



                }
            }
        }

        chipLayerMap.clear();

        for (Id ptrfId: mapOfptrfIdAndListFoundry.keySet()) {
            chipLayerMap.clear();
            String chipToDisplay = '';

            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mapOfptrfIdAndListFoundry.get(ptrfId);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Gating mask release' && !customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                        mapLCACategory.put('FOUNDRY_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                } else if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Not gating mask release' && !customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                        mapLCACategory.put('FOUNDRY_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }

                Set < String > layerNameSet = new Set < String > ();
                Set < String > chipNameSet = new Set < String > ();

                counter = 0;
                String layerNameToDisplay;
                if (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void') {
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {

                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerNameToDisplay = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')'; //layerNameSet.add(mrsLayerChipObject.Layer__r.Name+mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObject.Layer__r.ROM_Code__c +')');
                        } else {
                            layerNameToDisplay = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c; //layerNameSet.add(mrsLayerChipObject.Layer__r.Name+mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c);
                        }
                        layerNameSet.add(layerNameToDisplay);
                        chipNameSet.add(mrsLayerChipObject.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }

                        if (chipLayerMap.get(mrsLayerChipObject.Chip__r.Name) != null) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerNameToDisplay);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerNameToDisplay);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }
                        
                        counter++;
                    }

                    String chipName;
                    counter = 0;
                    if (chipNameSet.size() > 0) {
                        for (String chip: chipNameSet) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    String layerName;
                    counter = 0;
                    if (layerNameSet.size() > 0) {
                        for (String layer: layerNameSet) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    if (Jobdeck == null) {
                        Jobdeck = '';
                    }
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalcounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalcounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalcounter = internalcounter + 1;
                        }
                        chipToDisplay = chipToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipToDisplay = chipToDisplay + '<tr><td><br/></td></tr><tr><td> Jobdeck ' + Jobdeck + '</td></tr>';
                }
            }

        }

        /*ECP2 Start*/
        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'SWIFT_Customer_Gating_Remote_Jobview_Initial', nameValue, 'Y', 'Customer_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_NOT_GATING'), 'SWIFT_Customer_Non_Gating_Remote_Jobview_Initial', nameValue, 'N', null);
            }
            if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'SWIFT_Foundry_Gating_Remote_Jobview_Initial', nameValue, 'Y', 'Foundry_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_NOT_GATING'), 'SWIFT_Foundry_Non_Gating_Remote_Jobview_Initial', nameValue, 'N', null);
            }
        }
        /*ECP2 End*/


    }

    /**
         Send Email when subsequently Customer or Foundry Prime OR Frame Remote JobView status  gets 'Done'
         Method Name: sendEmailForRemoteJobViewToReviewersSubsequently
         Parameters: List of MRS_Layer_Chip_Association__c,Jobdeck
     **/
    public static void sendEmailForRemoteJobViewToReviewersSubsequently(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String emailAddress, String jobviewRemark, Boolean customerOrFoundry, Boolean isFoundry) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValuePair.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValuePair.put('JOBVIEW_REMARK', jobviewRemark);
        }
        /*ECP2 End*/

        Set < Id > lstgettingPTRF = new Set < Id > ();
        Set < Id > lstnongettingPTRF = new Set < Id > ();

        Map < Id, List < MRS_Layer_Chip_Association__c >> mapptrfIdMRSLayerChip = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mapOfptrfIdAndMRSLayerChipFoundry = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();


        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            if (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') {
                if ((mrsLayerChipObj.Customer_Prime_Remote_Jobview_Setup__c == 'Done' || mrsLayerChipObj.Customer_Frame_Remote_Jobview_Setup__c == 'Done') && mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Gating mask release') {


                    if (mapptrfIdMRSLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapptrfIdMRSLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapptrfIdMRSLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Not gating mask release') { //task-1955


                    if (mapptrfIdMRSLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mapptrfIdMRSLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapptrfIdMRSLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
                if ((mrsLayerChipObj.Foundry_Prime_Remote_Jobview_Setup__c == 'Done' || mrsLayerChipObj.Foundry_Frame_Remote_Jobview_Setup__c == 'Done') && mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Gating mask release') {

                    if (mapOfptrfIdAndMRSLayerChipFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {

                        mapOfptrfIdAndMRSLayerChipFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {

                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfptrfIdAndMRSLayerChipFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Not gating mask release') { //task-1955
                    system.debug(mrsLayerChipObj.Foundry_Prime_Remote_Jobview_Setup__c + '$$$$two values$$$' + mrsLayerChipObj.Foundry_Frame_Remote_Jobview_Setup__c);

                    if (mapOfptrfIdAndMRSLayerChipFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {

                        mapOfptrfIdAndMRSLayerChipFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {

                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mapOfptrfIdAndMRSLayerChipFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }

            }
        }

        for (Id ptrfId: mapptrfIdMRSLayerChip.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mapptrfIdMRSLayerChip.get(ptrfId);

            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if (mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Gating mask release' && customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                        mapLCACategory.put('CUSTOMER_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/

                } else if (mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Not gating mask release' && customerOrFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                        mapLCACategory.put('CUSTOMER_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }

            }
        }

        for (Id ptrfId: mapOfptrfIdAndMRSLayerChipFoundry.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mapOfptrfIdAndMRSLayerChipFoundry.get(ptrfId);

            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Gating mask release' && isFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                        mapLCACategory.put('FOUNDRY_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/

                } else if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Not gating mask release' && isFoundry) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                        mapLCACategory.put('FOUNDRY_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
            }
        }

        /*ECP2 Start*/
        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'SWIFT_Customer_Gating_Remote_JobView_Subsequent', nameValuePair, 'Y', 'Customer_MEBES_Jobview__c');
        }
        if (mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_NOT_GATING'), 'SWIFT_Customer_Non_Gating_Remote_Jobview_Subsequent', nameValuePair, 'N', null);
        }
        if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'SWIFT_Foundry_Gating_Remote_JobView_Subsequent', nameValuePair, 'Y', 'Foundry_MEBES_Jobview__c');
        }
        if (mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_NOT_GATING'), 'SWIFT_Foundry_Non_Gating_Remote_Jobview_Subsequent', nameValuePair, 'N', null);
        }
        /*ECP2 Start*/
    }

    /**
      Send Email To Tapeout Application for PRIME or Frame received
      Method Name : sendEmailToTapeoutApplication
      Parameter : List of MRS_Layer_Chip_Association__c, emailContentFromCadSystem
     **/
    public static void sendEmailToTapeoutApplication(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String jobviewRemark) {
        /*ECP2*/
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValuePair.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValuePair.put('JOBVIEW_REMARK', jobviewRemark);
        }
        Map < String, List < MRS_Layer_Chip_Association__c >> layerChipToSendEmail = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2*/
        
        Map < Id, List < MRS_Layer_Chip_Association__c >> mapPTRFIdandlstmrsLayerChip = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();

        Map < Id, Boolean > gatingOrNongatingPTRF = gatingOrNongatingPTRF(sendDoneEmailtoJobView);
        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setPTLP = new Set < String > {
            'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production'
        };
        Set < String > setOrderType = new Set < String > {
            'New Prototype', 'Retrofit'
        };
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            Double techGeo;

            if (mrsLayerChipObj.PTRF__r.Tech_Geo__c != null) {
                techGeo = Double.valueOf(mrsLayerChipObj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
            }

            if (gatingOrNongatingPTRF != null && gatingOrNongatingPTRF.size() > 0) {
                if (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') {
                    if (mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready' && gatingOrNongatingPTRF.get(mrsLayerChipObj.PTRF__c) != null && gatingOrNongatingPTRF.get(mrsLayerChipObj.PTRF__c) && mrsLayerChipObj.Chip__r.Name != 'Frame') {

                        if (mapPTRFIdandlstmrsLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                            mapPTRFIdandlstmrsLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                        } else {
                            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                            mrsLayerChiplst.add(mrsLayerChipObj);
                            mapPTRFIdandlstmrsLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                        }
                    }
                    if (mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'N.A.' && gatingOrNongatingPTRF.get(mrsLayerChipObj.PTRF__c) != null && !gatingOrNongatingPTRF.get(mrsLayerChipObj.PTRF__c) && mrsLayerChipObj.Chip__r.Name != 'Frame') {

                        if (mapPTRFIdandlstmrsLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                            mapPTRFIdandlstmrsLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                        } else {
                            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                            mrsLayerChiplst.add(mrsLayerChipObj);
                            mapPTRFIdandlstmrsLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                        }
                    }
                }
            }
        }

        for (Id ptrfIdIterator: mapPTRFIdandlstmrsLayerChip.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mapPTRFIdandlstmrsLayerChip.get(ptrfIdIterator);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {

                if (gatingOrNongatingPTRF.get(mrsLayerChiplst.get(0).PTRF__c) != null && gatingOrNongatingPTRF.get(mrsLayerChiplst.get(0).PTRF__c) && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void') && mrsLayerChiplst.get(0).Tapeout_Applications_MEBES_Jobview__c == 'Ready') {
                    if (layerChipToSendEmail.containsKey('GATING')) {
                        layerChipToSendEmail.get('GATING').addAll(mrsLayerChiplst);
                    } else {
                        layerChipToSendEmail.put('GATING', mrsLayerChiplst);
                    }
                }
                
                if (gatingOrNongatingPTRF.get(mrsLayerChiplst.get(0).PTRF__c) != null && !gatingOrNongatingPTRF.get(mrsLayerChiplst.get(0).PTRF__c) && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void')) {
                    if (layerChipToSendEmail.containsKey('NOTGATING')) {
                        layerChipToSendEmail.get('NOTGATING').addAll(mrsLayerChiplst);
                    } else {
                        layerChipToSendEmail.put('NOTGATING', mrsLayerChiplst);
                    }

                }
            }
        }

        if (layerChipToSendEmail.size() > 0) {
            EmailSubjectBodyPerPTRF emailSubjBody = new EmailSubjectBodyPerPTRF();
            if (layerChipToSendEmail.containsKey('GATING')) {
                emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('GATING'), 'SWIFT_Gating_Tapeout_Application_Custom', nameValuePair, 'Y', 'Tapeout_Applications_MEBES_Jobview__c');
            }

            if (layerChipToSendEmail.containsKey('NOTGATING')) {
                emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('NOTGATING'), 'SWIFT_Non_Gating_Tapeout_Application_Custom', nameValuePair, 'N', null);
            }
        }

    }


    /**
   PRIME MEBES AND FRAME MEBES RECEIVED WHEN PRIME OR FRAME MEBES GETS 'Done' for first time
   Method Name:mebbesReceivedSendEmailToReviewers
   Parameters : List of MRS_Layer_Chip_Association__c,Jobdeck,emailContentFromCadSystem
     **/
    public static void mebbesReceivedSendEmailToReviewers(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String jobviewRemark, Boolean customerOrFoundry) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobviewRemark);
        }
        /*ECP2 End*/

        String key;

        Set < Id > lstgettingPTRF = new Set < Id > ();
        Set < Id > lstnongettingPTRF = new Set < Id > ();
        Set < Id > lstFoundrygatting = new Set < Id > ();
        Set < Id > lstFoundrynongatting = new Set < Id > ();
        Set < Id > lstPTRFId = new Set < Id > ();
        Set < Id > lstLayerId = new Set < Id > ();
        Set < Id > mrsLayerChipId = new Set < Id > ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mrsLayerChipIdandlst = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mrsLayerChipIdandlstFoundry = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            if (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') {
                if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Gating mask release') {
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsLayerChipIdandlst.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsLayerChipIdandlst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsLayerChipIdandlst.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Not gating mask release') { //TASK-1955
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsLayerChipIdandlst.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsLayerChipIdandlst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsLayerChipIdandlst.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }

                }
                if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Gating mask release') {
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsLayerChipIdandlstFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsLayerChipIdandlstFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsLayerChipIdandlstFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Not gating mask release') { //TASK-1955
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsLayerChipIdandlstFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsLayerChipIdandlstFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsLayerChipIdandlstFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
            }
        }


        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};

        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
        Integer counter;
        for (Id ptrfIdIterator: mrsLayerChipIdandlst.keySet()) {
            String subject;
            String htmlValue;
            chipLayerMap.clear();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mrsLayerChipIdandlst.get(ptrfIdIterator);

            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'Ready' && customerOrFoundry))

                {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                        mapLCACategory.put('CUSTOMER_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                } else if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Not gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'N.A.' && customerOrFoundry)) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                        mapLCACategory.put('CUSTOMER_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }

                if (subject != null && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void')) {


                    Set < String > layerNameSt = new Set < String > ();
                    Set < String > chipNameSt = new Set < String > ();
                    String chipNameToDisplay = '';

                    counter = 0;
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {

                        String layerName = '';
                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')';
                        } else {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c;
                        }
                        layerNameSt.add(layerName);
                        chipNameSt.add(mrsLayerChipObject.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }

                        if (chipLayerMap.containsKey(mrsLayerChipObject.Chip__r.Name)) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerName);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerName);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }
                        counter++;
                    }
                    counter = 0;
                    String layerName;
                    if (layerNameSt != null && layerNameSt.size() > 0) {
                        for (String layer: layerNameSt) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    counter = 0;
                    String chipName;
                    if (chipNameSt != null && chipNameSt.size() > 0) {
                        for (String chip: chipNameSt) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalcounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalcounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalcounter = internalcounter + 1;
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';

                    //if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'Ready')) {
                    //    if (customerOrFoundry) { }
                    //} else if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Not gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'N.A.')) { //TASK-1955
                    //    if (customerOrFoundry) { }
                    //}
                }
            }
        }        

        chipLayerMap.clear();
        for (Id ptrfIdIterator: mrsLayerChipIdandlstFoundry.keySet()) {

            String subject;
            String htmlValue;
            chipLayerMap.clear();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mrsLayerChipIdandlstFoundry.get(ptrfIdIterator);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                if ((mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'Ready'))

                {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                        mapLCACategory.put('FOUNDRY_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                } else if ((mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Not gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'N.A.')) {

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                        mapLCACategory.put('FOUNDRY_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }

                if (subject != null && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void')) {


                    Set < String > layerNameSt = new Set < String > ();
                    Set < String > chipNameSt = new Set < String > ();
                    String chipNameToDisplay = '';
                    counter = 0;
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {

                        String layerName = '';
                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')';
                        } else {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c;
                        }
                        layerNameSt.add(layerName);
                        chipNameSt.add(mrsLayerChipObject.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }

                        if (chipLayerMap.containsKey(mrsLayerChipObject.Chip__r.Name)) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerName);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerName);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }
                        counter++;
                    }
                    counter = 0;
                    String layerName;
                    if (layerNameSt != null && layerNameSt.size() > 0) {
                        for (String layer: layerNameSt) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    counter = 0;
                    String chipName;
                    if (chipNameSt != null && chipNameSt.size() > 0) {
                        for (String chip: chipNameSt) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    if (Jobdeck == null) {
                        Jobdeck = '';
                    }
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalcounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalcounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalcounter = internalcounter + 1;
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    
                    chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';
                }
            }
        }

        /*ECP2 Start*/
        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'Swift_Customer_Gating_MEBES_Recieved_Initial', nameValue, 'Y', 'Customer_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_NOT_GATING'), 'SWIFT_Customer_Non_Gating_MEBES_Recieved_Initial', nameValue, 'N', null);
            }
            if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'Swift_Foundry_Gating_MEBES_Recieved_Initial', nameValue, 'Y', 'Foundry_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_NOT_GATING'), 'SWIFT_Foundry_Non_Gating_MEBES_Recieved_Initial', nameValue, 'N', null);
            }
        }
        /*ECP2 End*/

    }

    /**
       SEND EMAIL WHEN FRAME OR PRIME MEBES RECEIVED LY GETS 'Done'
       Method Name:mebbesReceivedSunsequentlySendEmailToReviewers
       Parameters : List of MRS_Layer_Chip_Association__c,Jobdeck
     **/
    public static void mebbesReceivedSunsequentlySendEmailToReviewers(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, Boolean customerOrFoundry, String jobViewRemark) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobViewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobViewRemark);
        }
        /*ECP2 End*/
        Map < String, Map < String, String >> mapPTRFtoData = new Map < string, Map < String, String >> ();
        Map < String, String > tempMap = new Map < String, String > ();

        if (jobViewRemark == null) {
            jobViewRemark = '';
        }
        
        Set < Id > lstgettingPTRF = new Set < Id > ();
        Set < Id > lstnongettingPTRF = new Set < Id > ();
        Set < Id > lstFoundrygatting = new Set < Id > ();
        Set < Id > lstFoundrynongatting = new Set < Id > ();
        Set < Id > lstPTRFId = new Set < Id > ();
        Set < Id > lstLayerId = new Set < Id > ();
        Set < Id > mrsLayerChipId = new Set < Id > ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mrsPTRFIdandlstmrsLayerChip = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mrsPTRFIdandlstmrsLayerChipFoundry = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {

            if (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') {

                if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Gating mask release') {
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsPTRFIdandlstmrsLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsPTRFIdandlstmrsLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsPTRFIdandlstmrsLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Not gating mask release') { //TASK-1955
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsPTRFIdandlstmrsLayerChip.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsPTRFIdandlstmrsLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsPTRFIdandlstmrsLayerChip.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }

                if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Gating mask release') {

                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsPTRFIdandlstmrsLayerChipFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsPTRFIdandlstmrsLayerChipFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsPTRFIdandlstmrsLayerChipFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                } else if (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Not gating mask release') { //TASK-1955
                    lstPTRFId.add(mrsLayerChipObj.PTRF__c);
                    lstLayerId.add(mrsLayerChipObj.Layer__c);
                    mrsLayerChipId.add(mrsLayerChipObj.Id);
                    if (mrsPTRFIdandlstmrsLayerChipFoundry.containsKey(mrsLayerChipObj.PTRF__c)) {
                        mrsPTRFIdandlstmrsLayerChipFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                    } else {
                        List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                        mrsLayerChiplst.add(mrsLayerChipObj);
                        mrsPTRFIdandlstmrsLayerChipFoundry.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                    }
                }
            }
        }

        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
        String IsGating = '';
        for (Id ptrfIdIterator: mrsPTRFIdandlstmrsLayerChip.keySet()) {
            chipLayerMap.clear();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mrsPTRFIdandlstmrsLayerChip.get(ptrfIdIterator);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                String subject;
                String htmlValue;
                if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'Ready' && customerOrFoundry)) {

                    IsGating = 'Y';
                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_GATING')) {
                        mapLCACategory.put('CUSTOMER_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
                if ((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c == 'Not gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'N.A.' && customerOrFoundry)) {

                    IsGating = 'N';
                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                        mapLCACategory.put('CUSTOMER_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('CUSTOMER_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
                if (subject != null && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void')) {


                    Set < String > layerNameSt = new Set < String > ();
                    Set < String > chipNameSt = new Set < String > ();
                    String chipNameToDisplay = '';
                    integer counter = 0;
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {
                        String layerName;
                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')';
                        } else {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c;
                        }
                        layerNameSt.add(layerName);
                        chipNameSt.add(mrsLayerChipObject.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }

                        if (chipLayerMap.containsKey(mrsLayerChipObject.Chip__r.Name)) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerName);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerName);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }
                        counter++;
                    }
                    counter = 0;
                    String layerName;
                    if (layerNameSt != null && layerNameSt.size() > 0) {
                        for (String layer: layerNameSt) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    String chipName;
                    counter = 0;
                    if (chipNameSt != null && chipNameSt.size() > 0) {
                        for (String chip: chipNameSt) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }

                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalCounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalCounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalCounter = internalCounter + 1;
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';

                }
            }
        }

        IsGating = '';

        for (Id ptrfIdIterator: mrsPTRFIdandlstmrsLayerChipFoundry.keySet()) {
            chipLayerMap.clear();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mrsPTRFIdandlstmrsLayerChipFoundry.get(ptrfIdIterator);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                String subject;
                String htmlValue;
                if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'Ready') {

                    IsGating = 'Y';
                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_GATING')) {
                        mapLCACategory.put('FOUNDRY_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
                if (mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c == 'Not gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'N.A.')

                {

                    IsGating = 'N';
                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                        mapLCACategory.put('FOUNDRY_NOT_GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('FOUNDRY_NOT_GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
                if (subject != null && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void')) {


                    Set < String > layerNameSt = new Set < String > ();
                    Set < String > chipNameSt = new Set < String > ();
                    String chipNameToDisplay = '';
                    integer counter = 0;
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObject: mrsLayerChiplst) {
                        String layerName;
                        if (mrsLayerChipObject.Layer__r.ROM_Code__c != null && !mrsLayerChipObject.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObject.Layer__r.ROM_Code__c != '####') {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObject.Layer__r.ROM_Code__c + ')';
                        } else {
                            layerName = mrsLayerChipObject.Layer__r.Name + mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c;
                        }
                        layerNameSt.add(layerName);
                        chipNameSt.add(mrsLayerChipObject.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }
                        if (chipLayerMap.containsKey(mrsLayerChipObject.Chip__r.Name)) {
                            chipLayerMap.get(mrsLayerChipObject.Chip__r.Name).add(layerName);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerName);
                            chipLayerMap.put(mrsLayerChipObject.Chip__r.Name, layerList);
                        }
                        counter++;
                    }
                    counter = 0;
                    String layerName;
                    if (layerNameSt != null && layerNameSt.size() > 0) {
                        for (String layer: layerNameSt) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }
                    String chipName;
                    counter = 0;
                    if (chipNameSt != null && chipNameSt.size() > 0) {
                        for (String chip: chipNameSt) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalCounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalCounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalCounter = internalCounter + 1;
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';

                }

            }

        }
        /*ECP2 Start*/
        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('CUSTOMER_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_GATING'), 'SWIFT_Customer_Gating_MEBES_Received_Subsequent', nameValue, 'Y', 'Customer_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('CUSTOMER_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CUSTOMER_NOT_GATING'), 'SWIFT_Customer_Non_Gating_MEBES_Subsequent', nameValue, 'N', null);
            }
            if (mapLCACategory.containsKey('FOUNDRY_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_GATING'), 'SWIFT_Foundry_Gating_MEBES_Received_Subsequent', nameValue, 'Y', 'Foundry_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('FOUNDRY_NOT_GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FOUNDRY_NOT_GATING'), 'SWIFT_Foundry_Non_Gating_MEBES_Subsequent', nameValue, 'N', null);
            }
        }
        /*ECP2 End*/
    }

    /**
        This method verifies with the TECN Numbers and makes the status of the Layers Released or Pending Foundry Release. 
        @method name: verifyTECNForReleasedLayers
        @parameter:   1. Map of Released Layers
                      2. Set of TECN Numbers
        @return :     Map of MRS Layers to Boolean Flag indicating whether the TECNs are released or not.
     **/

    public static Map < MRS_Layer_Association__c, Boolean > verifyTECNForReleasedLayers(map < String, MRS_Layer_Association__c > mapReleasedLayerIds, set < String > setTECNNumbers) {

        map < String, Boolean > mapTECNNumberToStatus = new map < String, Boolean > ();
        map < MRS_Layer_Association__c, Boolean > mapMRSLAToStatus = new map < MRS_Layer_Association__c, Boolean > ();

        if (setTECNNumbers != null && setTECNNumbers.size() > 0) {
            String tecnStatusStr = ''; // SWGP-181
            for (TECN__c objTECN: [select TECN_No__c, TECN_Status__c, Related_TECN_No__c from TECN__c where Related_TECN_No__c IN: setTECNNumbers]) {
                tecnStatusStr = objTECN.TECN_Status__c;
                if (mapTECNNumberToStatus.containsKey(objTECN.Related_TECN_No__c)) {
                    if (!mapTECNNumberToStatus.get(objTECN.Related_TECN_No__c)) {

                        if ('Released;Expired'.containsIgnoreCase(tecnStatusStr)) { // SWGP-181
                            mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c, true);
                        }
                    }
                } else {

                    if ('Released;Expired'.containsIgnoreCase(tecnStatusStr)) { // SWGP-181
                        mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c, true);
                    } else {
                        mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c, false);
                    }
                }
            }
        }

        if (mapReleasedLayerIds != null && mapReleasedLayerIds.size() > 0) {
            for (String mrsLAId: mapReleasedLayerIds.keySet()) {
                set < String > setLogicalOperations = new set < String > ();
                MRS_Layer_Association__c objMRSLA = new MRS_Layer_Association__c();
                objMRSLA = mapReleasedLayerIds.get(mrsLAId);

                if (mapReleasedLayerIds.get(mrsLAId).LogicalOperation__c != null) {
                    if (mapReleasedLayerIds.get(mrsLAId).LogicalOperation__c.contains(';')) {
                        setLogicalOperations.addAll(mapReleasedLayerIds.get(mrsLAId).LogicalOperation__c.split(';'));
                    } else {
                        setLogicalOperations.add(mapReleasedLayerIds.get(mrsLAId).LogicalOperation__c);
                    }
                } else {
                    mapMRSLAToStatus.put(objMRSLA, true);
                }
                if (setLogicalOperations.size() > 0) {
                    for (String tecn: setLogicalOperations) {
                        if (mapTECNNumberToStatus.containsKey(tecn)) {
                            if (mapTECNNumberToStatus.get(tecn)) {
                                if (!mapMRSLAToStatus.containsKey(objMRSLA) || (mapMRSLAToStatus.containsKey(objMRSLA) && mapMRSLAToStatus.get(objMRSLA))) {
                                    mapMRSLAToStatus.put(objMRSLA, true);
                                }
                            } else {
                                mapMRSLAToStatus.put(objMRSLA, false);
                            }
                        } else {
                            // Changes Done for Task 1818 - START
                            mapMRSLAToStatus.put(objMRSLA, false);
                            // Changes Done for Task 1818 - END        
                        }
                    }
                }
            }
        }

        return mapMRSLAToStatus;
    }

    /**
      Send Email To MDP for PRIME or Frame received
      Method Name : sendEmailToTapeoutApplication
      Parameter : List of MRS_Layer_Chip_Association__c, emailContentFromCadSystem
     **/
    public static void sendEmailToMDPUser(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String jobviewRemark) {
        /*ECP2*/
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValuePair.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValuePair.put('JOBVIEW_REMARK', jobviewRemark);
        }
        List < MRS_Layer_Chip_Association__c > layerChipToSendEmail = new List < MRS_Layer_Chip_Association__c > ();
        /*ECP2*/

        Map < Id, List < MRS_Layer_Chip_Association__c >> mapptrfIdandmrsLayerChiplst = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            if ((mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') && mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready') {

                if (mapptrfIdandmrsLayerChiplst.containsKey(mrsLayerChipObj.PTRF__c)) {
                    mapptrfIdandmrsLayerChiplst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChiplst.add(mrsLayerChipObj);
                    mapptrfIdandmrsLayerChiplst.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                }
            }
        }


        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setPTLP = new Set < String > {
            'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production'
        };
        Set < String > setOrderType = new Set < String > {
            'New ProtoType', 'Retrofit'
        };
        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
        for (Id ptrfIdIterator: mapptrfIdandmrsLayerChiplst.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsChipLayerlst = mapptrfIdandmrsLayerChiplst.get(ptrfIdIterator);
            if (mrsChipLayerlst != null && mrsChipLayerlst.size() > 0) {
                Double techGeo;
                if (mrsChipLayerlst.get(0).PTRF__r.Tech_Geo__c != null) {
                    techGeo = Double.valueOf(mrsChipLayerlst.get(0).PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }
                if (techGeo <= mdpTechGeoCutoff && (mrsChipLayerlst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsChipLayerlst.get(0).Layer_Chip_Status__c != 'Void') && mrsChipLayerlst.get(0).MDP_MEBES_Jobview__c == 'Ready') {
                    layerChipToSendEmail.addAll(mrsChipLayerlst);

                }
            }

        }

        if (layerChipToSendEmail.size() > 0) {
            EmailSubjectBodyPerPTRF emailSubjBody = new EmailSubjectBodyPerPTRF();
            emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail, 'SWIFT_Gating_MDP_Initial', nameValuePair, 'Y', 'MDP_MEBES_Jobview__c');
        }

    }


    /**
      Send Email To MDP for PRIME or Frame received
      Method Name : sendEmailToSubsequentMDPUser
      Parameter : List of MRS_Layer_Chip_Association__c, emailContentFromCadSystem
     **/
    public static void sendEmailToSubsequentMDPUser(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String jobViewRemark) {

        String key;
        Set < Id > ptrfId = new Set < Id > ();
        Set < Id > maskLayerId = new Set < Id > ();
        Set < Id > mrsLayerChipId = new Set < Id > ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mrsLayerChiplstandPTRFIdMap = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobViewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobViewRemark);
        }
        /*ECP2 End*/
        if (jobViewRemark == null) {
            jobViewRemark = '';
        }
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            if ((mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void') && mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready') {
                ptrfId.add(mrsLayerChipObj.PTRF__c);
                maskLayerId.add(mrsLayerChipObj.Layer__c);
                mrsLayerChipId.add(mrsLayerChipObj.Id);
                if (mrsLayerChiplstandPTRFIdMap.containsKey(mrsLayerChipObj.PTRF__c)) {
                    mrsLayerChiplstandPTRFIdMap.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChiplst.add(mrsLayerChipObj);
                    mrsLayerChiplstandPTRFIdMap.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                }
            }
        }


        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setPTLP = new Set < String > {
            'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production'
        };
        Set < String > setOrderType = new Set < String > {
            'New ProtoType', 'Retrofit'
        };

        //----------------------End of CC Address-------------------------------------------------------------//
        //-------------------------Start of TOAddress--------------------------------------------------------//

        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
        //-------------------------End OF TO ADDRESS-----------------------------------------------------------//
        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
        for (Id ptrfIdIterator: mrsLayerChiplstandPTRFIdMap.keySet()) {
            chipLayerMap.clear();
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = mrsLayerChiplstandPTRFIdMap.get(ptrfIdIterator);
            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                Double techGeo;

                if (mrsLayerChiplst.get(0).PTRF__r.Tech_Geo__c != null) {
                    techGeo = Double.valueOf(mrsLayerChiplst.get(0).PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }
                if (techGeo <= mdpTechGeoCutoff && (mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsLayerChiplst.get(0).Layer_Chip_Status__c != 'Void') && mrsLayerChiplst.get(0).MDP_MEBES_Jobview__c == 'Ready') {

                    String[] ccAddressArray;
                    Integer ccCounter = 0;

                    Set < String > layerNameSt = new Set < String > ();
                    Set < String > chipNameSt = new Set < String > ();
                    String chipNameToDisplay;
                    Integer counter = 0;
                    for (MRS_Layer_Chip_Association__c mrsLayerChipObj: mrsLayerChiplst) {
                        String layerName;
                        if (mrsLayerChipObj.Layer__r.ROM_Code__c != null && !mrsLayerChipObj.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObj.Layer__r.ROM_Code__c != '####') {
                            layerName = mrsLayerChipObj.Layer__r.Name + mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObj.Layer__r.ROM_Code__c + ')';
                        } else {
                            layerName = mrsLayerChipObj.Layer__r.Name + mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c;
                        }
                        layerNameSt.add(layerName);
                        chipNameSt.add(mrsLayerChipObj.Chip_Name__c);

                        if (Jobdeck == null) {
                            Jobdeck = '';
                        }
                        if (chipLayerMap.containsKey(mrsLayerChipObj.Chip__r.Name)) {
                            chipLayerMap.get(mrsLayerChipObj.Chip__r.Name).add(layerName);
                        } else {
                            List < String > layerList = new List < String > ();
                            layerList.add(layerName);
                            chipLayerMap.put(mrsLayerChipObj.Chip__r.Name, layerList);
                        }
                        counter++;
                    }
                    counter = 0;
                    String layerName;
                    if (layerNameSt != null && layerNameSt.size() > 0) {
                        for (String layer: layerNameSt) {
                            if (counter == 0) {
                                layerName = layer;
                            } else {
                                layerName = layerName + ', ' + layer;
                            }
                            counter++;
                        }
                    }

                    counter = 0;
                    String chipName;
                    if (chipNameSt != null && chipNameSt.size() > 0) {
                        for (String chip: chipNameSt) {
                            if (counter == 0) {
                                chipName = chip;
                            } else {
                                chipName = chipName + ', ' + chip;
                            }
                            counter++;
                        }
                    }
                    chipNameToDisplay = '';
                    for (String chip: chipLayerMap.keySet()) {
                        Integer internalCounter = 0;
                        String singleChip = '';
                        for (String layer: chipLayerMap.get(chip)) {
                            if (internalCounter == 0) {
                                singleChip = singleChip + chip + ' layer(s) ' + layer;

                            } else {
                                singleChip = singleChip + ', ' + layer;

                            }
                            internalCounter = internalCounter + 1;
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                    }
                    chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';

                    /*ECP2 Start*/
                    if (!mapLCACategory.containsKey('GATING')) {
                        mapLCACategory.put('GATING', mrsLayerChiplst);
                    } else {
                        mapLCACategory.get('GATING').addAll(mrsLayerChiplst);
                    }
                    /*ECP2 End*/
                }
            }

        }

        /*ECP2 Start*/
        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('GATING'), 'SWIFT_Gating_MDP_Subsequent', nameValue, 'Y', 'MDP_MEBES_Jobview__c');
            }
        }
        /*ECP2 End*/
    }

    /**
       SEND EMAIL WHEN Manually Updated Layer Chip is Updated with wrong status 
       Method sendLayerChipManualUpdateErrorMail
       Parameters :LayerId,Map of Error field/value pair
     **/
    public static void sendLayerChipManualUpdateErrorMail(List < MRS_Layer_Chip_Association__c > lstLayerChip, List < String > lstFieldsToShow) {

        decimal dcmtechgeo = 0;
        decimal finaldcmtechgeo = 0;
        Set < string > setPTRF = new Set < string > ();
        Set < string > setLayer = new Set < string > ();
        Set < string > setFields = new Set < string > ();
        List < string > lstFields = new list < string > ();
        Set < string > setLayerforSort = new Set < string > ();
        Set < string > setChipforSort = new Set < string > ();
        string Layernames = '';
        Map < String, Map < String, String >> mapPTRFtoData = new Map < string, Map < String, String >> ();
        Map < String, String > tempMap;
        string strMST = '';
        string strMasklayer = '';
        string strTechgeo = '';
        BOOLEAN isMNR = false;
        string strLayerId;
        Set < String > setFieldsToShow = new Set < String > ();
        boolean isError = false;
        if (lstFieldsToShow != null && lstFieldsToShow.size() > 0) {
            setFieldsToShow.addAll(lstFieldsToShow);
        }

        map < String, String > mapStatusFieldValue = new map < String, String > ();
        if (lstLayerChip != null && lstLayerChip.size() > 0 && setFieldsToShow.size() > 0) {
            if (lstLayerChip[0].Layer__c != null) {
                strLayerId = lstLayerChip[0].Layer__c;
            }
            for (MRS_Layer_Chip_Association__c objLayerChip: lstLayerChip) {
                if (objLayerChip != null) {

                    setLayer.add(String.valueof(objLayerChip.layer__r.name) + String.valueof(objLayerChip.Rev__c) + ((objLayerChip.ROM_Code__c != '' && objLayerChip.ROM_Code__c != null && objLayerChip.ROM_Code__c != '####') ? '(' + objLayerChip.ROM_Code__c + ')' : ''));
                    setLayerforSort.add(objLayerChip.layer__r.name);
                    setChipforSort.add(objLayerChip.Chip_Name__c);

                    isError = false;
                    if (objLayerChip.Is_Customer_GDSOUT_Review_Updated__c == true && setFieldsToShow.contains('Customer_GDSOUT_Review__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'GDSOUT Review Customer', objLayerChip.Customer_GDSOUT_Review__c);
                        isError = true;
                        setFields.add('GDSOUT Review Customer');
                    }
                    if (objLayerChip.Is_Foundry_GDSOUT_Review_Updated__c == true && setFieldsToShow.contains('Foundry_GDSOUT_Review__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'GDSOUT Review Foundry', objLayerChip.Foundry_GDSOUT_Review__c);
                        isError = true;
                        setFields.add('GDSOUT Review Foundry');
                    }
                    if (objLayerChip.Is_Customer_Frame_Mockup_Updated__c == true && setFieldsToShow.contains('Customer_Frame_Mockup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Frame Mockup Review Customer', objLayerChip.Customer_Frame_Mockup__c);
                        isError = true;
                        setFields.add('Frame Mockup Review Customer');
                    }
                    if (objLayerChip.Is_Foundry_Frame_Mockup_Updated__c == true && setFieldsToShow.contains('Customer_Frame_Mockup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Frame Mockup Review Foundry', objLayerChip.Customer_Frame_Mockup__c);
                        isError = true;
                        setFields.add('Frame Mockup Review Foundry');
                    }
                    if (objLayerChip.Is_Send_Prime_Data_Updated__c == true && setFieldsToShow.contains('Send_Prime_Data__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Send Data Prime', objLayerChip.Send_Prime_Data__c);
                        isError = true;
                        setFields.add('Send Data Prime');
                    }
                    if (objLayerChip.Is_Send_Frame_Data_Updated__c == true && setFieldsToShow.contains('Send_Frame_Data__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Send Data Frame', objLayerChip.Send_Frame_Data__c);
                        isError = true;
                        setFields.add('Send Data Frame');
                    }
                    if (objLayerChip.Is_Customer_Prime_Remote_Jobview_Updated__c == true && setFieldsToShow.contains('Customer_Prime_Remote_Jobview_Setup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Customer Remote Jobview Prime', objLayerChip.Customer_Prime_Remote_Jobview_Setup__c);
                        isError = true;
                        setFields.add('Customer Remote Jobview Prime');
                    }
                    if (objLayerChip.Is_Customer_Frame_Remote_Jobview_Updated__c == true && setFieldsToShow.contains('Customer_Frame_Remote_Jobview_Setup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Customer Remote Jobview Frame', objLayerChip.Customer_Frame_Remote_Jobview_Setup__c);
                        isError = true;
                        setFields.add('Customer Remote Jobview Frame');
                    }
                    if (objLayerChip.Is_Foundry_Prime_Remote_Jobview_Updated__c == true && setFieldsToShow.contains('Foundry_Prime_Remote_Jobview_Setup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Foundry Remote Jobview Prime', objLayerChip.Foundry_Prime_Remote_Jobview_Setup__c);
                        isError = true;
                        setFields.add('Foundry Remote Jobview Prime');
                    }
                    if (objLayerChip.Is_Foundry_Frame_Remote_Jobview_Updated__c == true && setFieldsToShow.contains('Foundry_Frame_Remote_Jobview_Setup__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'Foundry Remote Jobview Frame', objLayerChip.Foundry_Frame_Remote_Jobview_Setup__c);
                        isError = true;
                        setFields.add('Foundry Remote Jobview Frame');
                    }
                    if (objLayerChip.Is_ORC_Updated__c == true && setFieldsToShow.contains('ORC__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'ORC', objLayerChip.ORC__c);
                        isError = true;
                        setFields.add('ORC');
                    }
                    if (objLayerChip.Is_DRW_Updated__c == true && setFieldsToShow.contains('DRW__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'DRW', objLayerChip.DRW__c);
                        isError = true;
                        setFields.add('DRW');
                    }
                    if (objLayerChip.Is_Prime_MEBES_Received_Updated__c == true && setFieldsToShow.contains('Prime_MEBES_Received__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Received Prime', objLayerChip.Prime_MEBES_Received__c);
                        isError = true;
                        setFields.add('MEBES Received Prime');
                    }
                    if (objLayerChip.Is_Frame_MEBES_Received_Updated__c == true && setFieldsToShow.contains('Frame_MEBES_Received__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Received Frame', objLayerChip.Frame_MEBES_Received__c);
                        isError = true;
                        setFields.add('MEBES Received Frame');
                    }
                    if (objLayerChip.Is_Customer_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('Customer_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview Customer', objLayerChip.Customer_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview Customer');
                    }
                    if (objLayerChip.Is_Foundry_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('Foundry_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview Foundry', objLayerChip.Foundry_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview Foundry');
                    }
                    if (objLayerChip.Is_Tapeout_Centre_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('Tapeout_Centre_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview Tapeout Centre', objLayerChip.Tapeout_Centre_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview Tapeout Centre');
                    }
                    if (objLayerChip.Is_Tapeout_Apps_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('Tapeout_Applications_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview Tapeout Applications', objLayerChip.Tapeout_Applications_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview Tapeout Applications');
                    }
                    if (objLayerChip.Is_GlobalShuttle_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('GlobalShuttle_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview GlobalShuttle', objLayerChip.GlobalShuttle_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview GlobalShuttle');
                    }
                    if (objLayerChip.Is_MDP_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('MDP_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview MDP', objLayerChip.MDP_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview MDP');
                    }

                    if (objLayerChip.Is_TDTI_MPW_MEBES_Jobview_Updated__c == true && setFieldsToShow.contains('TDTI_MPW_MEBES_Jobview__c')) {
                        mapStatusFieldValue.put(objLayerChip.layer__r.name + ':' + objLayerChip.Chip_Name__c + ':' + 'MEBES Jobview TDTI-MPW', objLayerChip.TDTI_MPW_MEBES_Jobview__c);
                        isError = true;
                        setFields.add('MEBES Jobview TDTI-MPW');
                    }
                    if (isError == true) {
                        setPTRF.add(objLayerChip.PTRF__c + ':' + objLayerChip.PTRF_number__c);
                    }
                }
            }
            if (setFields.size() > 0) {
                lstFields.addall(setFields);
            }
            if (strLayerId != null && strLayerId != '' && mapStatusFieldValue != null && mapStatusFieldValue.size() > 0) {
                EmailTemplate templateMain = [Select id, Subject, Body, HtmlValue, Developername from EmailTemplate where DeveloperName = 'SWIFT_Layer_Chip_Manual_Update_Error_Template'];
                MRS_Layer_Association__c objLayer = [SELECT Name, ROM_Code__c, Mask_Layer_Rev__c, Mask_Set_Title_Name__c, Layer_Status__c, tech_geo__c from MRS_Layer_Association__c where id = : strLayerId LIMIT 1];
                if (objLayer != null) {
                    strMST = objLayer.Mask_Set_Title_Name__c;
                    strMasklayer = String.valueof(objLayer.name) + String.valueof(objLayer.Mask_Layer_Rev__c) + ((objLayer.ROM_Code__c != '' && objLayer.ROM_Code__c != null && objLayer.ROM_Code__c != '####') ? '(' + objLayer.ROM_Code__c + ')' : '');

                    if (objLayer.tech_geo__c != null && objLayer.tech_geo__c != '') {
                        dcmtechgeo = Decimal.valueOf(objLayer.tech_geo__c.toUppercase().substringBefore('UM').trim());

                        strTechGeo = objLayer.Tech_Geo__c;
                        if (!strTechGeo.toUppercase().contains('UM')) {
                            strTechGeo += 'UM';
                        }
                        if (strTechGeo != null && strTechGeo != '' && !strTechGeo.toLowercase().contains('nm')) {

                            if (dcmtechgeo < 0.1) {
                                finaldcmtechgeo = dcmtechgeo * 1000;
                                strTechGeo = strTechGeo + ' (' + finaldcmtechgeo.round() + 'nm)';
                            }

                        }
                    }
                    List < MRS__c > listFilteredMRS = [SELECT Mask_Set_Title__c from MRS__c where id in (select MRS__c from MRS_Layer_Association__c where id = : strLayerId)];
                    if (listFilteredMRS != null && listFilteredMRS.size() > 0) {
 

                        List < PTRF__C > listPTRF = [select Id, Recticle_Type__c, tech_geo__c from PTRF__C where MaskSetTitle__c = : strMST AND Recticle_Type__c = 'Multi Node Reticle (MNR)'];
                        if (listPTRF != NULL && listPTRF.size() > 0) {
                            isMNR = true;
                        } else {
                            isMNR = false;
                        }
                    }
                    Set < String > Mainlst = new Set < String > ();
                    Set < String > ccAddresslst = new Set < String > ();

                    Map < Id, Id > groupId_userIdMap = new Map < Id, Id > ();
                    Map < Id, Group > lstgroupObj;

                    lstgroupObj = new Map < Id, Group > ([SELECT Id, DeveloperName FROM Group WHERE DeveloperName in ('SWIFT_CAD')]);

                    List < GroupMember > lstgroupMember;
                    if (lstgroupObj != null) {
                        lstgroupMember = [Select Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: lstgroupObj.keySet()];
                    }

                    if (lstgroupMember != null) {
                        for (GroupMember groupMemberObj: lstgroupMember) {
                            groupId_userIdMap.put(groupMemberObj.UserOrGroupId, groupMemberObj.GroupId);
                        }
                    }

                    List < User > userlst;
                    if (groupId_userIdMap != null && groupId_userIdMap.size() > 0) {
                        userlst = [Select Email, Name From User Where Id IN: groupId_userIdMap.keySet() AND IsActive = true];
                    }


                    if (userlst != null) {
                        for (User userObj: userlst) {
                            Id groupId = groupId_userIdMap.get(userObj.Id);
                            String groupName = lstgroupObj.get(groupId).DeveloperName;

                            if (groupName == 'SWIFT_CAD') {
                                if (userObj.Email != null) ccAddresslst.add(userObj.Email);
                            }

                        }
                    }

                    if (Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')) {
                        Mainlst.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
                    } else {
                        Mainlst.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
                    }

                    if (dcmtechgeo != null && dcmtechgeo <= Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') )) {
                        if (Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.contains(';')) {
                            Mainlst.addAll(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.split(';'));
                        } else {
                            Mainlst.add(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c);
                        }
                    }

                    if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
                        ccAddresslst.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
                    } else {
                        ccAddresslst.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
                    }


                    OrgWideEmailAddress Orgid = [Select id, DisplayName From OrgWideEmailAddress where DisplayName = : 'GLOBALFOUNDRIES'
                    LIMIT 1];
                    Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};

                    String subject;
                    String htmlValue;
                    string tempValue = '<table cellspacing=0 cellpadding=0>';

                    subject = templateMain.subject;
                    htmlValue = templateMain.htmlValue;

                    for (string tempLayer: setLayer) {
                        Layernames = Layernames + tempLayer + ',';
                    }
                    Layernames = Layernames.removeend(',');

                    subject = subject.replace('<MRS.Mask Set Title>', strMST);
                    htmlValue = htmlValue.replace('<MRS.Mask Set Title>', strMST);
                    htmlValue = htmlValue.replace('<MRS.Mask Layer>', Layernames);
                    if (isMNR == true) {
                        htmlValue = htmlValue.replace('<Tech.Geo>', (strTechGeo != null ? strTechGeo : ''));
                    } else {
                        htmlValue = htmlValue.replace('<Tech.Geo>', '');
                    }
                    String layerName;
                    String chipName;
                    String actualFieldName;
                    for (string tempField: lstFields) {
                        for (string tempLayerforSort: setLayerforSort) {
                            for (string tempChipforSort: setChipforSort) {
                                for (String fieldName: mapStatusFieldValue.keySet()) {
                                    if (tempField == fieldName.split(':')[2] && tempLayerforSort == fieldName.split(':')[0] && tempChipforSort == fieldName.split(':')[1]) {
                                        if (fieldName != null && fieldName != '') {
                                            layerName = fieldName.split(':')[0];
                                            chipName = fieldName.split(':')[1];
                                            actualFieldName = fieldName.split(':')[2];
                                            tempValue = tempValue + '<tr><td>' + actualFieldName + '(Layer : ' + layerName + ' Chip: ' + chipName + ') </td><td> :   ' + mapStatusFieldValue.get(fieldName) + ' </td></tr>';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    tempValue = tempValue + '</table>';
                    htmlValue = htmlValue.replace('<Status_Change>', tempValue);

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(new List < String > (Mainlst));
                    mail.setCcAddresses(new List < String > (ccAddresslst));
                    mail.setSubject(subject);
                    mail.setOrgWideEmailAddressId(Orgid.Id);
                    mail.setReplyTo(Label.SWIFT_ReplyTo_Address);
                    mail.setPlainTextBody(htmlValue);
                    massEmailMessage.addAll(new Messaging.SingleEmailMessage[] {
                        mail
                    });

                    List < MRS_Layer_Chip_Association__c > listToSendEmail = new List < MRS_Layer_Chip_Association__c > ();
                    Id idPTRF;
                    string strPTRFNumber;
                    if (setPTRF.size() > 0) {
                        for (String PtrfId: setPTRF) {
                            idPTRF = PtrfId.split(':')[0];
                            for (MRS_Layer_Chip_Association__c layerChipObj: lstLayerChip) {
                                if (layerChipObj.PTRF__c == idPTRF) {
                                    listToSendEmail.add(layerChipObj);
                                }
                            }


                        }
                    }
                    if (listToSendEmail.size() > 0) {
                        try {
                            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
                            emailObject.emailSubBodyPerPTRF(listToSendEmail, 'SWIFT_Layer_Chip_Manual_Update_Error_Template', null, 'NA', null);
                        } catch (Exception ex) {
                            system.debug(ex);
                        }
                    }
                }
            }
        }
    }


    /**

     **/
    public static void sendEmailToTapeoutCentre(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, String jobviewRemark) {

        String subject = '';
        String plainBody = '';
        Integer counter = 0;
        Boolean gatingType;
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobviewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobviewRemark);
        }
        /*ECP2 End*/
        map < string, map < string, string >> mapptrfid = new map < string, map < string, string >> ();
        map < string, string > map1 = null;

        Set < Id > ptrfId = new Set < Id > ();
        Set < Id > maskLayerId = new Set < Id > ();
        Map < Id, List < MRS_Layer_Chip_Association__c >> mapptrfIdandmrsLayerChiplst = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();

        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {

            if (mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready') {
                ptrfId.add(mrsLayerChipObj.PTRF__c);
                maskLayerId.add(mrsLayerChipObj.Layer__c);

                if (mapptrfIdandmrsLayerChiplst.containsKey(mrsLayerChipObj.PTRF__c)) {
                    mapptrfIdandmrsLayerChiplst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChiplst.add(mrsLayerChipObj);
                    mapptrfIdandmrsLayerChiplst.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                }
            }

        }


        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setPTLP = new Set < String > {
            'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production'
        };
        Set < String > setOrderType = new Set < String > {
            'New Prototype', 'Retrofit'
        };

        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
        for (Id ptrfIdIterator: mapptrfIdandmrsLayerChiplst.keySet()) {
            chipLayerMap.clear();
            map1 = new map < string, string > ();

            List < MRS_Layer_Chip_Association__c > mrsChipLayerlst = mapptrfIdandmrsLayerChiplst.get(ptrfIdIterator);

            if (mrsChipLayerlst != null && mrsChipLayerlst.size() > 0) {

                Double techGeo;

                if (mrsChipLayerlst.get(0).PTRF__r.Tech_Geo__c != null) {
                    techGeo = Double.valueOf(mrsChipLayerlst.get(0).PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }

                gatingType = true;
                Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
                if (techGeo > mdpTechGeoCutoff) {
                    if (gatingType && (mrsChipLayerlst.get(0).Layer_Chip_Status__c != 'Void' && mrsChipLayerlst.get(0).Layer_Chip_Status__c != 'Cancel' && mrsChipLayerlst.get(0).Tapeout_Centre_MEBES_Jobview__c == 'Ready')) {

                        Set < String > layerNameSt = new Set < String > ();
                        Set < String > chipNameSt = new Set < String > ();
                        String chipNameToDisplay;
                        counter = 0;
                        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: mrsChipLayerlst) {
                            String layerName;
                            if (mrsLayerChipObj.Layer__r.ROM_Code__c != null && !mrsLayerChipObj.Layer__r.ROM_Code__c.equalsIgnoreCase('NULL') && mrsLayerChipObj.Layer__r.ROM_Code__c != '####') {
                                layerName = mrsLayerChipObj.Layer__r.Name + mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c + '(' + mrsLayerChipObj.Layer__r.ROM_Code__c + ')';
                            } else {
                                layerName = mrsLayerChipObj.Layer__r.Name + mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c;
                            }
                            layerNameSt.add(layerName);
                            chipNameSt.add(mrsLayerChipObj.Chip_Name__c);
                            if (Jobdeck == null) {
                                Jobdeck = '';
                            }
                            counter++;
                            if (chipLayerMap.get(mrsLayerChipObj.Chip__r.Name) != null) {
                                chipLayerMap.get(mrsLayerChipObj.Chip__r.Name).add(layerName);
                            } else {
                                List < String > layerList = new List < String > ();
                                layerList.add(layerName);
                                chipLayerMap.put(mrsLayerChipObj.Chip__r.Name, layerList);
                            }

                        }

                        counter = 0;
                        String layerName;
                        if (layerNameSt != null && layerNameSt.size() > 0) {
                            for (String layer: layerNameSt) {
                                if (counter == 0) {
                                    layerName = layer;
                                } else {
                                    layerName = layerName + ', ' + layer;
                                }
                                counter++;
                            }
                        }

                        counter = 0;
                        String chipName;
                        if (chipNameSt != null && chipNameSt.size() > 0) {
                            for (String chip: chipNameSt) {
                                if (counter == 0) {
                                    chipName = chip;
                                } else {
                                    chipName = chipName + ', ' + chip;
                                }
                                counter++;
                            }
                        }
                        chipNameToDisplay = '';
                        for (String chip: chipLayerMap.keySet()) {
                            Integer internalCounter = 0;
                            String singleChip = '';
                            for (String layer: chipLayerMap.get(chip)) {
                                if (internalCounter == 0) {
                                    singleChip = singleChip + chip + ' layer(s) ' + layer;

                                } else {
                                    singleChip = singleChip + ', ' + layer;

                                }
                                internalCounter = internalCounter + 1;
                            }
                            chipNameToDisplay = chipNameToDisplay + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
                        }
                        chipNameToDisplay = chipNameToDisplay + '<tr><td><br/></td></tr>' + '<tr><td> Jobdeck ' + Jobdeck + '</td></tr>';


                        /*ECP2 Start*/
                        if (!mapLCACategory.containsKey('GATING')) {
                            mapLCACategory.put('GATING', mrsChipLayerlst);
                        } else {
                            mapLCACategory.get('GATING').addAll(mrsChipLayerlst);
                        }
                        /*ECP2 End*/
                    }
                }
            }
        }

        /*ECP2 Start*/

        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('GATING')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('GATING'), 'SWIFT_Gating_Tapeout_Center_Initial', nameValue, 'Y', 'Tapeout_Centre_MEBES_Jobview__c');
            }
        }
        /*ECP2 End*/
    }

    /**

     **/

    public static void mebbesReceivedSubsequentlySendEmailToTapeoutCenter(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView, String Jobdeck, string jobViewRemark) {

        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (jobViewRemark != null) {
            nameValue.put('JOBVIEW_REMARK', jobViewRemark);
        }

        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();

        Set < Id > ptrfId = new Set < Id > ();
        Set < Id > maskLayerId = new Set < Id > ();
        Set < Id > mrsLayerChipId = new Set < Id > ();

        Map < Id, List < MRS_Layer_Chip_Association__c >> mapptrfIdandmrsLayerChiplst = new Map < Id, List < MRS_Layer_Chip_Association__c >> ();


        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            if (mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready') {
                ptrfId.add(mrsLayerChipObj.PTRF__c);
                maskLayerId.add(mrsLayerChipObj.Layer__c);
                mrsLayerChipId.add(mrsLayerChipObj.Id);

                if (mapptrfIdandmrsLayerChiplst.containsKey(mrsLayerChipObj.PTRF__c)) {
                    mapptrfIdandmrsLayerChiplst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                } else {
                    List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChiplst.add(mrsLayerChipObj);
                    mapptrfIdandmrsLayerChiplst.put(mrsLayerChipObj.PTRF__c, mrsLayerChiplst);
                }
            }


        }
        for (Id ptrfIdIterator: mapptrfIdandmrsLayerChiplst.keySet()) {

            List < MRS_Layer_Chip_Association__c > mrsChipLayerlst = mapptrfIdandmrsLayerChiplst.get(ptrfIdIterator);

            if (mrsChipLayerlst != null && mrsChipLayerlst.size() > 0) {


                if (!mapLCACategory.containsKey('GATING')) {
                    mapLCACategory.put('GATING', mrsChipLayerlst);
                } else {
                    mapLCACategory.get('GATING').addAll(mrsChipLayerlst);
                }

            }

        }


        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if (mapLCACategory.containsKey('GATING')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('GATING'), 'SWIFT_Gating_Tapeout_Center_Subsequent', nameValue, 'Y', 'Tapeout_Centre_MEBES_Jobview__c');
        }


    }
    /**
     @ method: sendEmailToTapeoutApplicationSubsequent
     @param:
     @return:
    **/
    public static void sendEmailToTapeoutApplicationSubsequent(List < MRS_Layer_Chip_Association__c > mrsLayerChiplst, String Jobdeck, String remarks) {
        /*ECP2*/
        Map < String, String > nameValuePair = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValuePair.put('JOBDECK', Jobdeck);
        }
        if (remarks != null) {
            nameValuePair.put('JOBVIEW_REMARK', remarks);
        }
        Map < String, List < MRS_Layer_Chip_Association__c >> layerChipToSendEmail = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        /*ECP2*/



        Boolean flagForTechGeo;

        Set < String > setJobview = new Set < String > {
            'Not Required', 'Not gating mask release'
        };
        Set < String > setOrderType = new Set < String > {
            'New Prototype', 'Retrofit'
        };
        Map < Id, Boolean > mapPTRFIdAndIsGating = gatingOrNongatingPTRF(mrsLayerChiplst);
        Map < String, List < MRS_Layer_Chip_Association__c >> ptrfLayerChipMap = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        List < MRS_Layer_Chip_Association__c > listIterator;
        for (MRS_Layer_Chip_Association__c mrsLayerChip: mrsLayerChiplst) {
            if (mapPTRFIdAndIsGating != null && mapPTRFIdAndIsGating.size() > 0) {
                if (mrsLayerChip.Tapeout_Applications_MEBES_Jobview__c == 'Ready' && mrsLayerChip.Layer_Chip_Status__c != 'Void' && mrsLayerChip.Layer_Chip_Status__c != 'Cancel' && mapPTRFIdAndIsGating.get(mrsLayerChip.PTRF__c) != null && mapPTRFIdAndIsGating.get(mrsLayerChip.PTRF__c) && mrsLayerChip.Chip__r.Name != 'Frame') {
                    if (ptrfLayerChipMap.get(mrsLayerChip.PTRF__r.Name) != null) {
                        ptrfLayerChipMap.get(mrsLayerChip.PTRF__r.Name).add(mrsLayerChip);
                    } else {
                        listIterator = new List < MRS_Layer_Chip_Association__c > ();
                        listIterator.add(mrsLayerChip);
                        ptrfLayerChipMap.put(mrsLayerChip.PTRF__r.Name, listIterator);
                    }
                }
                if (mrsLayerChip.Tapeout_Applications_MEBES_Jobview__c == 'N.A.' && mrsLayerChip.Layer_Chip_Status__c != 'Void' && mrsLayerChip.Layer_Chip_Status__c != 'Cancel' && mapPTRFIdAndIsGating.get(mrsLayerChip.PTRF__c) != null && !mapPTRFIdAndIsGating.get(mrsLayerChip.PTRF__c) && mrsLayerChip.Chip__r.Name != 'Frame') {
                    if (ptrfLayerChipMap.get(mrsLayerChip.PTRF__r.Name) != null) {
                        ptrfLayerChipMap.get(mrsLayerChip.PTRF__r.Name).add(mrsLayerChip);
                    } else {
                        listIterator = new List < MRS_Layer_Chip_Association__c > ();
                        listIterator.add(mrsLayerChip);
                        ptrfLayerChipMap.put(mrsLayerChip.PTRF__r.Name, listIterator);
                    }
                }
            }
        }

        for (String ptrfName: ptrfLayerChipMap.keySet()) {

            if (mapPTRFIdAndIsGating.get(ptrfLayerChipMap.get(ptrfName).get(0).PTRF__c) != null && mapPTRFIdAndIsGating.get(ptrfLayerChipMap.get(ptrfName).get(0).PTRF__c) && ptrfLayerChipMap.get(ptrfName).get(0).Tapeout_Applications_MEBES_Jobview__c == 'Ready') {
                if (layerChipToSendEmail.containsKey('GATING')) {
                    layerChipToSendEmail.get('GATING').addAll(ptrfLayerChipMap.get(ptrfName));
                } else {
                    layerChipToSendEmail.put('GATING', ptrfLayerChipMap.get(ptrfName));
                }

            } else if (mapPTRFIdAndIsGating.get(ptrfLayerChipMap.get(ptrfName).get(0).PTRF__c) != null && !mapPTRFIdAndIsGating.get(ptrfLayerChipMap.get(ptrfName).get(0).PTRF__c) && ptrfLayerChipMap.get(ptrfName).get(0).Tapeout_Applications_MEBES_Jobview__c == 'N.A.') {
                if (layerChipToSendEmail.containsKey('NOTGATING')) {
                    layerChipToSendEmail.get('NOTGATING').addAll(ptrfLayerChipMap.get(ptrfName));
                } else {
                    layerChipToSendEmail.put('NOTGATING', ptrfLayerChipMap.get(ptrfName));
                }

            }
            if (layerChipToSendEmail.size() > 0) {
                EmailSubjectBodyPerPTRF emailSubjBody = new EmailSubjectBodyPerPTRF();
                if (layerChipToSendEmail.containsKey('GATING')) {
                    emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('GATING'), 'SWIFT_Send_Gating_Email_To_Tapeout_Applications_Subsequent', nameValuePair, 'Y', 'Tapeout_Applications_MEBES_Jobview__c');
                }

                if (layerChipToSendEmail.containsKey('NOTGATING')) {
                    emailSubjBody.emailSubBodyPerPTRF(layerChipToSendEmail.get('NOTGATING'), 'SWIFT_Send_Non_Gating_Email_To_Tapeout_Applications_Subsequent', nameValuePair, 'N', null);
                }
            }
        }

    }



    public static void sendEmailToGSandTDTIMPWSubsequent(List < MRS_Layer_Chip_Association__c > mrsLayerChiplst, String Jobdeck, String remarks) {
        /*ECP2 Start*/
        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, String > nameValue = new Map < String, String > ();
        if (Jobdeck != null) {
            nameValue.put('JOBDECK', Jobdeck);
        }
        if (remarks != null) {
            nameValue.put('JOBVIEW_REMARK', remarks);
        }
        /*ECP2 End*/

        String key;
        /*-----------------Email Template------------------*/


        String[] toAddress = new String[] {};

        String[] bccAddress = new String[] {};

        if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
            bccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
        } else {
            bccAddress.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
        }

        Set < String > bccAddressSet = new Set < String > ();
        bccAddressSet.addAll(bccAddress);
        bccAddress.clear();
        bccAddress.addAll(bccAddressSet);

        String[] ccAddress = new String[] {};

        Messaging.SingleEmailMessage[] allMail = new Messaging.SingleEmailMessage[] {};

        Map < String, List < MRS_Layer_Chip_Association__c >> ptrfLayerChipMap = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        List < MRS_Layer_Chip_Association__c > listIterator;
        for (MRS_Layer_Chip_Association__c mrsLayerChip: mrsLayerChiplst) {
            if (mrsLayerChip.TDTI_MPW_MEBES_Jobview__c == 'Ready' || mrsLayerChip.GlobalShuttle_MEBES_Jobview__c == 'Ready') {
                if (ptrfLayerChipMap.get(mrsLayerChip.PTRF__c) != null) {
                    ptrfLayerChipMap.get(mrsLayerChip.PTRF__c).add(mrsLayerChip);
                } else {
                    listIterator = new List < MRS_Layer_Chip_Association__c > ();
                    listIterator.add(mrsLayerChip);
                    ptrfLayerChipMap.put(mrsLayerChip.PTRF__c, listIterator);
                }
            }
        }

        Double techGeo;
        Set < String > layerNameSet = new Set < String > ();
        Set < String > chipNameSet = new Set < String > ();
        for (String ptrfName: ptrfLayerChipMap.keySet()) {

            ccAddress.clear();
            toAddress.clear();
            layerNameSet.clear();
            chipNameSet.clear();

            String htmlBody = '';
            String subject = '';
            Boolean gatingType;

            String layerName = '';
            String maskSetTitle = '';

            Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
            List < String > layerList;
            String chipAndLayerName = '';

            for (MRS_Layer_Chip_Association__c mrsLayerChipObj: ptrfLayerChipMap.get(ptrfName)) {
                layerName = '';

                if (mrsLayerChipObj.Layer_Chip_Status__c != 'Void' && mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && (mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready' || mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready')) {
                    if (mrsLayerChipObj.PTRF__r.Tech_Geo__c != null) {
                        techGeo = Double.valueOf(mrsLayerChipObj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                    }
                    maskSetTitle = mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name;

                    layerName = layerName + mrsLayerChipObj.Layer__r.Name + mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c;
                    if (mrsLayerChipObj.Layer__r.ROM_Code__c != null && mrsLayerChipObj.Layer__r.ROM_Code__c != '####' && mrsLayerChipObj.Layer__r.ROM_Code__c != 'NULL' && mrsLayerChipObj.Layer__r.ROM_Code__c != 'null') {
                        layerName = layerName + '(' + mrsLayerChipObj.Layer__r.ROM_Code__c + ')';
                    }
                    layerNameSet.add(layerName);
                    chipNameSet.add(mrsLayerChipObj.Chip__r.Name);


                    if (chipLayerMap.get(mrsLayerChipObj.Chip__r.Name) != null) {
                        chipLayerMap.get(mrsLayerChipObj.Chip__r.Name).add(layerName);
                    } else {
                        layerList = new List < String > ();
                        layerList.add(layerName);
                        chipLayerMap.put(mrsLayerChipObj.Chip__r.Name, layerList);
                    }

                    /*ECP2 Start */

                    if (mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready') {
                        if (!mapLCACategory.containsKey('TDTIMPW')) {
                            mapLCACategory.put('TDTIMPW', new List < MRS_Layer_Chip_Association__c > ());
                            mapLCACategory.get('TDTIMPW').add(mrsLayerChipObj);
                        } else {
                            mapLCACategory.get('TDTIMPW').add(mrsLayerChipObj);
                        }
                    }
                    if (mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready') {
                        if (!mapLCACategory.containsKey('GlobalShuttle')) {
                            mapLCACategory.put('GlobalShuttle', new List < MRS_Layer_Chip_Association__c > ());
                            mapLCACategory.get('GlobalShuttle').add(mrsLayerChipObj);
                        } else {
                            mapLCACategory.get('GlobalShuttle').add(mrsLayerChipObj);
                        }
                    }

                    /*ECP2 End */

                }
            }
            Integer counter = 0;
            String layerToDisplay = '';
            for (String layer: layerNameSet) {
                if (counter == 0) {
                    layerToDisplay = layerToDisplay + layer;
                } else {
                    layerToDisplay = layerToDisplay + ', ' + layer;
                }
                counter = counter + 1;
            }
            counter = 0;
            String chipToDisplay = '';
            for (String chip: chipNameSet) {
                if (counter == 0) {
                    chipToDisplay = chipToDisplay + chip;
                } else {
                    chipToDisplay = chipToDisplay + ', ' + chip;
                }
                counter = counter + 1;
            }

            String singleChip = '';

            for (String chip: chipLayerMap.keySet()) {
                counter = 0;
                singleChip = '';
                for (String layer: chipLayerMap.get(chip)) {
                    if (counter == 0) {
                        singleChip = singleChip + chip + ' layer(s) ' + layer;

                    } else {
                        singleChip = singleChip + ', ' + layer;

                    }
                    counter = counter + 1;
                }
                chipAndLayerName = chipAndLayerName + '<tr><td>Chip Name: ' + singleChip + '</tr></td>';
            }




            Set < String > toAddressSet = new Set < String > ();
            toAddressSet.addAll(toAddress);
            toAddress.clear();
            toAddress.addAll(toAddressSet);

            if (Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')) {
                ccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
            } else {
                ccAddress.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
            }

            if (techGeo <= Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') )) {
                if (Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.contains(';')) {
                    ccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.split(';'));
                } else {
                    ccAddress.add(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c);
                }

                if (Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.contains(';')) {
                    ccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.split(';'));
                } else {
                    ccAddress.add(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c);
                }
            }
            Set < String > ccAddressSet = new Set < String > ();
            ccAddressSet.addAll(ccAddress);
            ccAddress.clear();
            ccAddress.addAll(ccAddressSet);
        }

        /*ECP2 Start*/

        if (mapLCACategory.size() > 0) {

            EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
            if (mapLCACategory.containsKey('TDTIMPW')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('TDTIMPW'), 'SWIFT_Send_Email_To_TDTI_MPW_Subsequent', nameValue, 'Y', 'TDTI_MPW_MEBES_Jobview__c');
            }
            if (mapLCACategory.containsKey('GlobalShuttle')) {
                emailObject.emailSubBodyPerPTRF(mapLCACategory.get('GlobalShuttle'), 'SWIFT_Send_Email_To_GS_Subsequent', nameValue, 'Y', 'GlobalShuttle_MEBES_Jobview__c');
            }
        }
        /*ECP2 End*/


    }

    /**
  @method : partingToCCBccAddress 
  @param : toaddress,ccaddress,bccaddress
  @return: array
  @Description: This method will divide the to, cc and bcc string array so that governer limit will not exceed
  **/

    public static Messaging.SingleEmailMessage[] partingToCCBccAddress(String[] toAddressEmails, String[] ccAddressEmails, String[] bccAddressEmails, OrgWideEmailAddress orgId, Boolean isHtmlBody, String subject, String body) {
        
        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        try {
            Set < String > toAddressSt = new Set < String > ();
            Set < String > bccAddressSt = new Set < String > ();

            Integer toSize = 0;
            Integer bccSize = 0;

            if (toAddressEmails != null) {
                for (Integer counter = 0; counter < toAddressEmails.size(); counter++) {
                    if (toAddressEmails[counter] != null) {
                        toAddressSt.add(toAddressEmails[counter].toLowerCase().trim());
                    }
                }
            }

            if (bccAddressEmails != null) {
                for (Integer counter = 0; counter < bccAddressEmails.size(); counter++) {
                    if (bccAddressEmails[counter] != null) {
                        bccAddressSt.add(bccAddressEmails[counter].toLowerCase().trim());
                    }
                }
            }

            toAddressEmails.clear();
            bccAddressEmails.clear();

            toAddressEmails.addAll(toAddressSt);
            bccAddressEmails.addAll(bccAddressSt);

            if (toAddressSt != null) {
                toSize = toAddressSt.size();
            }
            if (bccAddressSt != null) {
                bccSize = bccAddressSt.size();
            }

            if (bccSize <= 25) {
                if (toSize <= (100 - bccSize)) {

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setUseSignature(false);
                    mail.setToAddresses(toAddressEmails);
                    mail.setBccAddresses(bccAddressEmails);
                    mail.setSubject(subject);
                    if (!isHtmlBody) {
                        mail.setPlainTextBody(body);
                    } else {
                        mail.setHTMLBody(body);
                    }
                    mail.setBccSender(true);
                    mail.setOrgWideEmailAddressId(orgId.Id);
                    mail.setReplyTo(Label.SWIFT_ReplyTo_Address);
                    massEmailMessage.add(mail);

                } else {

                    String[] toAddressList = new String[] {};
                    Integer counter;

                    for (counter = 0; counter < Math.mod(toSize, (100 - bccSize)); counter++) {
                        toAddressList.add(toAddressEmails[counter]);

                    }
                    if (toAddressList.size() > 0) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setUseSignature(false);
                        mail.setToAddresses(toAddressList);
                        mail.setBccAddresses(bccAddressEmails);
                        mail.setSubject(subject);
                        if (!isHtmlBody) {
                            mail.setPlainTextBody(body);
                        } else {
                            mail.setHTMLBody(body);
                        }
                        mail.setBccSender(true);
                        mail.setOrgWideEmailAddressId(orgId.Id);
                        mail.setReplyTo(Label.SWIFT_ReplyTo_Address);
                        massEmailMessage.add(mail);
                    }

                    for (Integer newCounter = 0; newCounter < toSize / (100 - bccSize); newCounter++) {
                        toAddressList.clear();
                        Integer emailNo;
                        for (emailNo = counter; emailNo < counter + (100 - bccSize); emailNo++) {
                            toAddressList.add(toAddressEmails[emailNo]);

                        }
                        counter = emailNo;
                        if (toAddressList.size() > 0) {

                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setUseSignature(false);
                            mail.setToAddresses(toAddressList);
                            mail.setBccAddresses(bccAddressEmails);
                            mail.setSubject(subject);
                            if (!isHtmlBody) {
                                mail.setPlainTextBody(body);
                            } else {
                                mail.setHTMLBody(body);
                            }
                            mail.setBccSender(true);
                            mail.setOrgWideEmailAddressId(orgId.Id);
                            mail.setReplyTo(Label.SWIFT_ReplyTo_Address);
                            massEmailMessage.add(mail);
                        }
                    }

                }
            } else {
                SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c();
                tempLog.Debug_Level__c = 'ERROR';
                tempLog.Apex_Component_Name__c = '';
                tempLog.Apex_Component_Id__c = '';
                tempLog.Error_Message__c = 'The number of Bcc Recipient List is more than 25. Hence email cannot be sent.';
                tempLog.Stack_Trace__c = '';
                tempLog.Message_ID__c = '';
                tempLog.Method__c = '';
                tempLog.Trigger_Exception_Email__c = true;

                insert tempLog;


            }
        } catch (Exception exp) {
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '', '', 'MRSHandlerUtility', 'partingToCCBccAddress');
        }
        return massEmailMessage;
    }

    /**
        This method is for sending mails to concerned users for Cusomer/Foundry GDSout review Ready status.
        @method name: sendRedyMailToGDSOUTReviewManualUpdate
        @parameter:   1. MRS_Layer_Chip_Association__c List
                      2. Email Content from CAD
                      3. Is Customer
       @return :      void 
  **/

    public static void sendRedyMailToGDSOUTReviewManualUpdate(List < MRS_Layer_Chip_Association__c > lstTosendReadyEmails, String emailContainFromCadSystem, boolean IsCustomer) {

        Map < String, List < MRS_Layer_Chip_Association__c >> mapLCACategory = new Map < String, List < MRS_Layer_Chip_Association__c >> ();

        Map < String, Map < String, String >> mapPTRFtoData = new Map < string, Map < String, String >> ();

        Map < String, String > tempMap;

        Map < String, String > nameValue = new Map < String, String > ();
        if (emailContainFromCadSystem != null) {
            nameValue.put('EMAIL_CONTENT_FROM_CAD', emailContainFromCadSystem);
        }


        if (emailContainFromCadSystem == null) {
            emailContainFromCadSystem = '';
        }
        List < String > strFFMU = new List < String > ();
        Map < Id, MRS_Layer_Chip_Association__c > customerGDSOUTReview = new Map < Id, MRS_Layer_Chip_Association__c > ();
        Map < Id, MRS_Layer_Chip_Association__c > foundryGDSOUTReview = new Map < Id, MRS_Layer_Chip_Association__c > ();
        String key;
        Map < String, List < MRS_Layer_Chip_Association__c >> mapCustomerGDSOUTStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        Map < String, List < MRS_Layer_Chip_Association__c >> mapGDSOUTStringmrsLayerChip = new Map < String, List < MRS_Layer_Chip_Association__c >> ();
        List < MRS_Layer_Chip_Association__c > mrsLayerChipAsso;
        Set < Id > chipId = new Set < Id > ();
        Set < Id > maskLayerId = new Set < Id > ();
        Set < Id > ptrfIdlst = new Set < Id > ();
        Set < Id > customerId = new Set < Id > ();
        List < String > jobViewEmail = new List < String > ();
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstTosendReadyEmails) {
            chipId.add(mrsLayerChipObj.chip__c);
            maskLayerId.add(mrsLayerChipObj.Layer__c);
            ptrfIdlst.add(mrsLayerChipObj.PTRF__c);
        }
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: lstTosendReadyEmails) {
            if (IsCustomer == true && (mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready') && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c;
                if (mapCustomerGDSOUTStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapCustomerGDSOUTStringmrsLayerChip.put(key, mrsLayerChipAsso);

                } else {
                    mapCustomerGDSOUTStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }
            }
            if (IsCustomer == false && (mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready') && (mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' && mrsLayerChipObj.Layer_Chip_Status__c != 'Void')) {
                key = mrsLayerChipObj.PTRF__c;
                if (mapGDSOUTStringmrsLayerChip.get(key) == null) {
                    mrsLayerChipAsso = new List < MRS_Layer_Chip_Association__c > ();
                    mrsLayerChipAsso.add(mrsLayerChipObj);
                    mapGDSOUTStringmrsLayerChip.put(key, mrsLayerChipAsso);
                } else {
                    mapGDSOUTStringmrsLayerChip.get(key).add(mrsLayerChipObj);
                }
            }



            customerGDSOUTReview.put(mrsLayerChipObj.PTRF__c, mrsLayerChipObj);
            customerId.add(mrsLayerChipObj.Customer_Name__c);

        }


        //---------------------------Sending email------------------------------------------------//

        EmailTemplate etGDSOUTReview;

        Messaging.SingleEmailMessage[] massEmailMessage = new Messaging.SingleEmailMessage[] {};
        Map < String, List < String >> chipLayerMap = new Map < String, List < String >> ();
        String chipMaskLayerPTRF = '';
        for (String keyId: mapCustomerGDSOUTStringmrsLayerChip.keySet()) {
            chipMaskLayerPTRF = '';

            List < MRS_Layer_Chip_Association__c > lstmrsLayerChip = mapCustomerGDSOUTStringmrsLayerChip.get(keyId);


            if (!mapLCACategory.containsKey('CustomerGating')) {
                mapLCACategory.put('CustomerGating', lstmrsLayerChip);
            } else {
                mapLCACategory.get('CustomerGating').addAll(lstmrsLayerChip);
            }



        }

        mapPTRFtoData.clear();
        if (tempMap != null) {
            tempMap.clear();
        }

        chipLayerMap.clear();
        for (String keyId: mapGDSOUTStringmrsLayerChip.keySet()) {
            chipLayerMap.clear();

            List < MRS_Layer_Chip_Association__c > lstmrsLayerChip = mapGDSOUTStringmrsLayerChip.get(keyId);


            if (!mapLCACategory.containsKey('FoundryGating')) {
                mapLCACategory.put('FoundryGating', lstmrsLayerChip);
            } else {
                mapLCACategory.get('FoundryGating').addAll(lstmrsLayerChip);
            }

        }


        EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if (mapLCACategory.containsKey('CustomerGating')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CustomerGating'), 'SWIFT_Customer_Gating_GDSOUTReview', nameValue, 'Y', 'Customer_GDSOUT_Review__c');
        }
        if (mapLCACategory.containsKey('FoundryGating')) {
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FoundryGating'), 'SWIFT_Foundry_Gating_GDSOUTReview', nameValue, 'Y', 'Foundry_GDSOUT_Review');
        }

    }


    /**
        This static block is used for querying on the Email Templates in one single time
     **/

    static {
        orgWideAddr = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = 'GLOBALFOUNDRIES' LIMIT 1];
    }

    /**
        This method is for fetching the Mask Set Titles for all pages. 
        @method name: fetchMaskSetTitleList
        @parameter:   1. Customer Id.
                      2. The page from where the call is made.
                      3. The flag whether the person is a jobviewer or not.
        @return :     Map of Mask Set Title records.
     **/

    public static Map < String, String > fetchMaskSetTitleList(Id customerId, String page, Boolean isJobViewer) {

        Id userId = UserInfo.getUserId();
        set < String > setLoggedInUserGroups = new set < String > ();
        setLoggedInUserGroups.addAll(fetchCurrentUserGroup(userId));
        Boolean isUserMEBES = false;
        Boolean isUserGlobalShuttle = false;
        Boolean isUserTDTIMPW = false;
        Boolean isUserMDP = false;
        Boolean isUserAdmin = false;
        Boolean isTapeOutCenter = false;
        Boolean flag = true;
        String chipName = Label.SWIFT_Frame_Status;
        String PTRForDRT = 'DRT';
        set < String > setReleased = new set < String > {
            'N.A.', 'Released', 'Hold', 'Shipped'
        };
        Boolean isUserGroup = false;
        Boolean isRecordFetched = false;
        if (setLoggedInUserGroups.size() > 0) {
            for (String userGroup: setLoggedInUserGroups) {
                if (userGroup.equalsIgnoreCase('Swift_GlobalShuttle') || userGroup.equalsIgnoreCase('Swift_TDTI_MPW') || userGroup.equalsIgnoreCase('Swift_MDP') || userGroup.equalsIgnoreCase('Swift_Tapeout_Centre') || userGroup.equalsIgnoreCase('Swift_Tapeout_Application') || userGroup.equalsIgnoreCase('Swift_Tapeout_Operations') || userGroup.equalsIgnoreCase('SWIFT_Admin') || userGroup.equalsIgnoreCase('Swift_RMG') || userGroup.equalsIgnoreCase('SWIFT_Support')) {
                    isUserMEBES = true;
                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_GT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserGlobalShuttle = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserTDTIMPW = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('TECH_GEO_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserMDP = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isUserAdmin = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_NO_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isTapeOutCenter = true;
                        isRecordFetched = true;
                    }
                }
            }
        }
        Set < Id > existingPtrfSt = new Set < Id > ();
        Set < Id > mrsLayerChipIdSt = new Set < Id > ();
        Set < Id > ptrfIdSt = new Set < Id > ();
        Map < Id, Id > ptrfAndChipId = new Map < Id, Id > ();
        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
        List < String > teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        List < Account_Team_Proxy__c > accTeamProxy = [Select Id, Account__c, User__c, Team_Role__c FROM Account_Team_Proxy__c WHERE User__c = : UserInfo.getUserId() AND Account__c = : customerId AND Team_Role__c IN: teamRole AND User__r.IsActive = true];

        if (accTeamProxy != null && accTeamProxy.size() > 0) {
            isUserAdmin = true;
        }
        List < PTRF__c > mrsLayerChiplst = [SELECT Id, MaskSetTitle__c, MaskSetTitle__r.Name, Tech_Geo__c, Frame_Mockup__c, Frame_Tapeout__c, Prime_Tapeout__c, Prime_GDSOUT_Review__c FROM PTRF__c WHERE Customer__c = : customerId];
        if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
            for (PTRF__c obj: mrsLayerChiplst) {

                if ((isUserMDP || isUserGlobalShuttle || isUserTDTIMPW) && !isUserAdmin && !isTapeOutCenter) {
                    String startsWithMPW = 'MPW%';
                    /** Globalshuttle can only view PTRFs with Tech Geo greater than 20nm **/

                    if (isUserGlobalShuttle && !isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW')) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (isUserGlobalShuttle && !isUserTDTIMPW && isUserMDP) {
                        if (isUserGlobalShuttle && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                        if (isUserMDP && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && isUserMDP) {
                        if (isUserGlobalShuttle && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }

                        if ((isUserTDTIMPW) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                        if ((isUserMDP) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                    } else if (!isUserGlobalShuttle && isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (!isUserGlobalShuttle && (isUserTDTIMPW || !isUserTDTIMPW) && (isUserMDP) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    }
                    /** MDP and TDTI-MPW can only view PTRFs with Tech Geo lesser than 20nm **/

                } else {
                    mrsLayerChipIdSt.add(obj.Id);

                }
            }
        }
        Boolean groupApproval = false;
        String jobView = 'SELECT Jobview__c,Jobview_Type__c,PTRF__c,PTRF__r.Customer__c FROM PTRF_JobViewer_Info__c WHERE Jobview_Type__c';
        if (page.contains('FrameMockup')) {
            jobView = jobView + ' INCLUDES (\'Frame Mockup\')';
        }
        if (page == 'CustomerGDSOutReview' || page == 'FoundryGDSOutReview') {
            jobView = jobView + ' INCLUDES (\'Prime GDSOUT Review\')';
        }
        if (page.contains('MEBES')) {
            jobView = jobView + ' INCLUDES (\'MEBES Jobview\')';
            if (page.contains('Customer')) {
                jobView = jobView + ' AND Jobview__c= \'Customer\'';
            } else if (page.contains('Foundry')) {
                jobView = jobView + ' AND Jobview__c= \'Foundry\'';
            }

        }
        if (page == 'CustomerFrameMockup' || page == 'CustomerGDSOutReview') {
            jobView = jobView + ' AND Jobview__c= \'Customer\'';
        } else if (page == 'FoundryFrameMockup' || page == 'FoundryGDSOutReview') {
            jobView = jobView + ' AND Jobview__c= \'Foundry\'';
        }
        jobView = jobView + ' AND User__c= :userId';
        jobView = jobView + ' AND PTRF__r.Customer__c= :customerId';

        List < PTRF_JobViewer_Info__c > ptrfJobView = Database.Query(jobView);
        if (ptrfJobView != null && ptrfJobView.size() > 0) {
            for (PTRF_JobViewer_Info__c ptrfJobViewObj: ptrfJobView) {
                ptrfIdSt.add(ptrfJobViewObj.PTRF__c);
            }
            groupApproval = true;
        }
        if (isUserGroup && groupApproval) {

            if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {

                for (Id ptrfId: ptrfIdSt) {
                    if (!existingPtrfSt.contains(ptrfId)) {

                        mrsLayerChipIdSt.add(ptrfId);

                    }
                }
            }
        }

        Boolean performApproval;
        if ((page.contains('MEBES') && isUserMEBES)) {
            performApproval = false;
            isRecordFetched = true;
        }
        /*else if((page.containsIgnoreCase('GDSOUT') && (isUserGlobalShuttle||isUserTDTIMPW))){
                performApproval = false;
            }*/
        else if (isUserAdmin) {
            performApproval = false;
            isRecordFetched = true;
        } else {
            performApproval = true;
            if (!isUserMDP && !isUserGlobalShuttle && !isUserTDTIMPW && !isTapeOutCenter && ptrfIdSt.size() > 0) {
                isRecordFetched = true;
            } else {
                isRecordFetched = false;
            }
        }
        
        //swgp-602: lift off Hold from the not in filter
        //below 2 variables can be removed???
        set < String > setOfLCStatus = new set < String > {'Cancel', 'Void'};
        set < String > setOfStatus = new set < String > {'N.A.', 'Released', 'Shipped'};
        //swgp-602: lift off Hold from the not in filter

        String mrsLayerChip;
        
        Map < String, String > IDMstNameMap = new Map < String, String > ();
        for (PTRF__c mrsLayeChipObject: mrsLayerChiplst) {
            if (mrsLayerChipIdSt.contains(mrsLayeChipObject.Id)) {
                if (page.contains('FrameMockup')) {
                    if (mrsLayeChipObject.Frame_Mockup__c && mrsLayeChipObject.Frame_Tapeout__c) {
                        if (performApproval && isJobViewer) {
                            if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                                IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                            }
                        } else {
                            IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                        }
                    }
                } else if (page.containsIgnoreCase('GDSOut')) {
                    if (mrsLayeChipObject.Prime_Tapeout__c && mrsLayeChipObject.Prime_GDSOUT_Review__c) {
                        if (performApproval && isJobViewer) {
                            if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                                IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                            }
                        } else {
                            IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                        }

                    }
                } else if (page.contains('MEBES')) {
                    
                    if (performApproval && isJobViewer) {
                        if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                            IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                        }
                    } else {
                        IDMstNameMap.put(String.valueOf(mrsLayeChipObject.MaskSetTitle__c), mrsLayeChipObject.MaskSetTitle__r.Name);
                    }
                }
            }

        }

        return IDMstNameMap;


    }

    /**
        This method is for determining whether the user is ajobviewer of any PTRF or not. 
        @method name: getJobViewer
        @parameter:   1. Set of PTRF Ids.
                      2. The page from where the call is made.
        @return :     List of PTRF Jobviewer Info records.
     **/

    public static List < PTRF_JobViewer_Info__c > getJobViewer(Set < Id > ptrfIdSt, String page) {
        Boolean isGroupUserJobViewer = false;
        List < PTRF_JobViewer_Info__c > ptrfJobViewlst;
        if (page.containsIgnoreCase('Customer')) {
            ptrfJobViewlst = [SELECT Id, Jobview__c, Jobview_Type__c, PTRF__c, User__r.isActive FROM PTRF_JobViewer_Info__c Where PTRF__c IN: ptrfIdSt AND Jobview__c = : 'Customer'
            AND User__c = : UserInfo.getUserId()];
        } else {
            ptrfJobViewlst = [SELECT Id, Jobview__c, Jobview_Type__c, PTRF__c, User__r.isActive FROM PTRF_JobViewer_Info__c Where PTRF__c IN: ptrfIdSt AND Jobview__c = : 'Foundry'
            AND User__c = : UserInfo.getUserId()];
        }
        if (ptrfJobViewlst != null && ptrfJobViewlst.size() > 0) {
            isGroupUserJobViewer = true;
        }
        return ptrfJobViewlst;
    }

    /**
        This method is used for fetching the List of Customers for all MRS Pages. 
        @method name: fetchCustomerName
        @parameter:   None.
        @return :     List of fetched Account records.
     **/

    public static list < Account > fetchCustomerName() {
        User loggedInUserInfo = [SELECT Id, AccountId, Name, ProfileId, Profile.Name FROM User WHERE Id = : UserInfo.getUserId() AND IsActive = true];
        list < Account > customerlist = new list < Account > ();
        set < id > setUniqueAccountId = new set < id > ();
        set < String > setAccRecordTypes = new set < string > {
            'GLOBALFOUNDRIES_Internal', 'Customer', 'Enablement_Partner', 'Reseller'
        };
        string recTypeGFInternal, recTypeCustomer, recTypeEnabPartner, recTypeReseller;
        for (RecordType objRT: [Select Id, Name, DeveloperName, SobjectType from RecordType where SobjectType = 'Account'
        and DeveloperName IN: setAccRecordTypes]) {
            if (objRT.DeveloperName == 'GLOBALFOUNDRIES_Internal') {
                recTypeGFInternal = objRT.Id;
            } else if (objRT.DeveloperName == 'Customer') {
                recTypeCustomer = objRT.Id;
            } else if (objRT.DeveloperName == 'Enablement_Partner') {
                recTypeEnabPartner = objRT.Id;
            } else if (objRT.DeveloperName == 'Reseller') {
                recTypeReseller = objRT.Id;
            }
        }
        if (loggedInUserInfo.AccountId != null) {
            customerlist = [SELECT Name, Id, Stage__c, Transaction_Type__c, recordTypeId, Short_Name__c FROM Account WHERE Id = : loggedInUserInfo.AccountId AND((recordTypeId = : recTypeGFInternal AND(Stage__c = 'Qualified'
            OR Stage__c = 'Authorized')) OR(recordTypeId = : recTypeCustomer AND Stage__c = 'Authorized'
            AND Transaction_Type__c = 'Transactional')
            OR(recordTypeId = : recTypeEnabPartner AND Stage__c = 'Authorized') OR(recordTypeId = : recTypeReseller AND Stage__c = 'Authorized'
            AND Transaction_Type__c = 'Transactional')) ORDER BY Name];
        } else {
            customerlist = [SELECT Name, Id, Stage__c, Transaction_Type__c, recordTypeId, Short_Name__c FROM Account WHERE((recordTypeId = : recTypeGFInternal AND(Stage__c = 'Qualified'
            OR Stage__c = 'Authorized')) OR(recordTypeId = : recTypeCustomer AND Stage__c = 'Authorized'
            AND Transaction_Type__c = 'Transactional')
            OR(recordTypeId = : recTypeEnabPartner AND Stage__c = 'Authorized') OR(recordTypeId = : recTypeReseller AND Stage__c = 'Authorized'
            AND Transaction_Type__c = 'Transactional')) ORDER BY Name];
        }
        // for FE users
        list < String > lstTeamRoles = new list < String > ();
        lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        Map < Id, Account > mapAcctIdName = new Map < Id, Account > ();
        for (Account a: customerlist) {
            mapAcctIdName.put(a.Id, a);
        }
        Boolean groupUser = false;
        set < String > setMRSGroup = new set < String > {
            'SWIFT_Admin', 'Swift_GlobalShuttle', 'Swift_TDTI_MPW', 'Swift_MDP', 'Swift_Tapeout_Operations', 'Swift_Tapeout_Centre', 'Swift_Tapeout_Application'
        };
        if (setMRSGroup != null && !setMRSGroup.isEmpty()) {
            list < groupmember > lstGrpMember = [select Id from groupmember where userorgroupid = : loggedInUserInfo.Id and group.DeveloperName IN: setMRSGroup LIMIT 1];
            if (lstGrpMember != null && (lstGrpMember.size() > 0)) {
                groupUser = true;
            }
        }
        list < Account > customerListFE = new list < Account > ();
        Boolean isFEUser = false;
        if ((loggedInUserInfo.Profile.Name != 'System Administrator') && (!groupUser)) {
            for (Account_Team_Proxy__c objATP: [Select Id, Account__c from Account_Team_Proxy__c where Team_Role__c IN: lstTeamRoles
            AND User__c = : loggedInUserInfo.Id]) {
                isFEUser = true;
                if (mapAcctIdName.containsKey(objATP.Account__c)) {
                    if (!setUniqueAccountId.contains(objATP.Account__c)) {
                        customerListFE.add(mapAcctIdName.get(objATP.Account__c));
                        setUniqueAccountId.add(objATP.Account__c);
                    }
                }
            }
            //Code added for TASK-1880, 2058, 2085
            //due to swgp-458 >>> no MORE FAE, below will be commented out
            /*             
            if (isFEUser) {
                List < AggregateResult > lstAgg = [select PTRF__r.Customer__c from PTRF_JobViewer_Info__c where
                User__c = : loggedInUserInfo.Id AND Jobview__c = 'Foundry'
                AND PTRF__r.Customer__c != null AND PTRF__r.Customer__r.Stage__c != 'Inactive'
                GROUP BY PTRF__r.Customer__c]; //TASK-2031/TASK-2032/TASK-2057
                if (lstAgg != null && lstAgg.size() > 0) {
                    for (AggregateResult objPJI: lstAgg) {
                        if (mapAcctIdName.containsKey(String.valueOf(objPJI.get('Customer__c'))) && mapAcctIdName.get(String.valueOf(objPJI.get('Customer__c'))) != null) { //TASK-2085
                            if (!setUniqueAccountId.contains(String.valueOf(objPJI.get('Customer__c')))) {
                                customerListFE.add(mapAcctIdName.get(String.valueOf(objPJI.get('Customer__c'))));
                            }
                        }
                    }MRSHandlerUtility
                }
            }
            //Code added for TASK-1880
            */
        }
        
        return customerlist;
    }
    public static Map < Id, Boolean > gatingOrNongatingPTRF(List < MRS_Layer_Chip_Association__c > sendDoneEmailtoJobView) {
        Map < Id, Boolean > ptrfIdAndIsGating = new Map < Id, Boolean > ();
        Boolean gating;
        Map < String, String > mapOfStringAndGatingOrNotGating = new Map < String, String > ();
        for (Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC: [select Id, Process_Technology_Lifecycle_Phase__c,
        PTRF_Customer_MEBES_Jobview__c, PTRF_Foundry_MEBES_Jobview__c, PTRF_Order_Type__c, PTRF_Technology__c, Logic_For_Calculation__c,
        Tapeout_Application_Jobview__c, Excluded_Customer__c from Tapeout_Applications_MEBES_Jobview_Confi__c LIMIT 1000]) {

            String key = 'ProcessTechnology' + objTAMJC.Process_Technology_Lifecycle_Phase__c + ';CJ' + objTAMJC.PTRF_Customer_MEBES_Jobview__c + 'CJ;FJ' + objTAMJC.PTRF_Foundry_MEBES_Jobview__c + 'FJ;' + objTAMJC.PTRF_Order_Type__c + ';Customer' + objTAMJC.Excluded_Customer__c + ';logic' + objTAMJC.Logic_For_Calculation__c + 'logic;TechGeo' + objTAMJC.PTRF_Technology__c;
            mapOfStringAndGatingOrNotGating.put(key, objTAMJC.Tapeout_Application_Jobview__c);
        }
        for (MRS_Layer_Chip_Association__c mrsLayerChipObj: sendDoneEmailtoJobView) {
            Double techGeo;

            if (mrsLayerChipObj.PTRF__r.Tech_Geo__c != null) {
                techGeo = Double.valueOf(mrsLayerChipObj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
            }
            for (String key: mapOfStringAndGatingOrNotGating.keySet()) {

                String customerJobView = '';
                String foundryJobView = '';
                customerJobView = key.substringBetween('CJ', 'CJ');
                foundryJobView = key.substringBetween('FJ', 'FJ');
                list < String > customerJobViewlst = new list < String > ();
                list < String > foundryJobviewlst = new list < String > ();
                Set < String > customerlst = new Set < String > ();
                Set < String > foundrylst = new Set < String > ();
                if (customerJobView.contains(';')) {
                    customerJobViewlst.addAll(customerJobView.trim().toUpperCase().split(';'));
                } else {
                    customerJobViewlst.add(customerJobView.trim().toUpperCase());
                }
                if (foundryJobView.contains(';')) {
                    foundryJobviewlst.addAll(foundryJobView.trim().toUpperCase().split(';'));
                } else {
                    foundryJobviewlst.add(foundryJobView.trim().toUpperCase());
                }
                customerlst.addAll(customerJobViewlst);
                foundrylst.addAll(foundryJobviewlst);

                String techGeoId = key.substringAfter('TechGeo');
                String logic = key.substringBetween('logic', 'logic');
                String processTechnology = key.substringBetween('ProcessTechnology', 'CJ');

                Boolean techGeoFlag = false;

                if (logic != null && logic.toUpperCase().equalsIgnoreCase('AND')) {
                    if (techGeoId != null) {
                        if (techGeoId.contains('<=')) {
                            techGeoId = techGeoId.substringAfter('<=').toUpperCase().substringBefore('UM');
                            if (techGeo <= Double.valueOf(techGeoId)) {
                                techGeoFlag = true;
                            }

                        } else if (techGeoId.contains('>=')) {
                            techGeoId = techGeoId.substringAfter('>=').toUpperCase().substringBefore('UM');
                            if (techGeo >= Double.valueOf(techGeoId)) {
                                techGeoFlag = true;

                            }



                        } else if (techGeoId.contains('>')) {
                            techGeoId = techGeoId.substringAfter('>').toUpperCase().substringBefore('UM');
                            if (techGeo > Double.valueOf(techGeoId)) {
                                techGeoFlag = true;

                            }

                        } else if (techGeoId.contains('<')) {
                            techGeoId = techGeoId.substringAfter('<').toUpperCase().substringBefore('UM');
                            if (techGeo < Double.valueOf(techGeoId)) {
                                techGeoFlag = true;

                            }
                        } else if (techGeoId.contains('-')) {
                            List < String > techGeoArray = techGeoId.split('-');
                            String techGeo1 = techGeoArray.get(0).trim().toUpperCase().substringBefore('UM');
                            String techGeo2 = techGeoArray.get(1).trim().toUpperCase().substringBefore('UM');
                            if (techGeo >= Double.valueOf(techGeo1) && techGeo <= Double.valueOf(techGeo2)) {
                                techGeoFlag = true;
                            }

                        } else {
                            techGeoId = techGeoId.toUpperCase().substringBefore('UM');

                            if (techGeo == Double.valueOf(techGeoId)) {
                                system.debug('techGeoFlag' + techGeoFlag);

                                techGeoFlag = true;

                            }
                        }
                    }

                    if (customerJobView != null && mrsLayerChipObj.PTRF__r.Customer_jobview__c != null && customerlst.contains(mrsLayerChipObj.PTRF__r.Customer_jobview__c.toUpperCase()) && foundryJobView != null && mrsLayerChipObj.PTRF__r.Foundry_jobview__c != null && foundrylst.contains(mrsLayerChipObj.PTRF__r.Foundry_jobview__c.toUpperCase()) && key.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Order_Type__c) && techGeoFlag != null && techGeoFlag) {
                        if (mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c != null && processTechnology.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c)) {

                            String customerShortName = key.substringBetween('Customer', ';');
                            if (customerShortName != null && customerShortName.trim() != '' && customerShortName.trim().toUpperCase() != 'NULL') {
                                if (customerShortName.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Customer_Short_Name__c)) {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    } else {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    }
                                } else {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                        gating = true;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    } else {
                                        gating = false;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    }
                                }
                            } else {
                                if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                    gating = true;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                } else {
                                    gating = false;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                }
                            }
                        } else if (mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c == null && processTechnology.toUpperCase().containsIgnoreCase('NULL')) {
                            String customerShortName = key.substringBetween('Customer', ';');
                            if (customerShortName != null && customerShortName.trim() != '' && customerShortName.trim().toUpperCase() != 'NULL') {
                                if (customerShortName.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Customer_Short_Name__c)) {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    } else {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    }
                                } else {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                        gating = true;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    } else {
                                        gating = false;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    }
                                }
                            } else {
                                if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                    gating = true;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                } else {
                                    gating = false;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                }
                            }
                        }
                    }

                } else if (logic != null && logic.toUpperCase().equalsIgnoreCase('OR')) {

                    if (techGeoId != null) {
                        if (techGeoId.contains('<=')) {
                            techGeoId = techGeoId.substringAfter('<=').toUpperCase().substringBefore('UM');

                            Double d = Double.valueOf(techGeoId.trim());

                            if (techGeo <= d) {

                                techGeoFlag = true;


                            }
                        } else if (techGeoId.contains('>=')) {
                            techGeoId = techGeoId.substringAfter('>=').toUpperCase().substringBefore('UM');
                            if (techGeo >= Double.valueOf(techGeoId)) {
                                techGeoFlag = true;
                            }

                        } else if (techGeoId.contains('>')) {
                            techGeoId = techGeoId.substringAfter('>').toUpperCase().substringBefore('UM');
                            if (techGeo > Double.valueOf(techGeoId)) {
                                techGeoFlag = true;

                            }

                        } else if (techGeoId.contains('<')) {
                            techGeoId = techGeoId.substringAfter('<').toUpperCase().substringBefore('UM');
                            if (techGeo < Double.valueOf(techGeoId)) {
                                techGeoFlag = true;
                            }

                        } else if (techGeoId.contains('-')) {
                            List < String > techGeoArray = techGeoId.split('-');
                            String techGeo1 = techGeoArray.get(0).trim().toUpperCase().substringBefore('UM');
                            String techGeo2 = techGeoArray.get(1).trim().toUpperCase().substringBefore('UM');
                            if (techGeo >= Double.valueOf(techGeo1) && techGeo <= Double.valueOf(techGeo2)) {
                                techGeoFlag = true;
                            }


                        } else {
                            techGeoId = techGeoId.toUpperCase().substringBefore('UM');

                            if (techGeo == Double.valueOf(techGeoId)) {
                                techGeoFlag = true;
                            }
                        }
                    }

                    if (((customerJobView != null && mrsLayerChipObj.PTRF__r.Customer_jobview__c != null && customerlst.contains(mrsLayerChipObj.PTRF__r.Customer_jobview__c.toUpperCase())) || (foundryJobView != null && mrsLayerChipObj.PTRF__r.Foundry_jobview__c != null && foundrylst.contains(mrsLayerChipObj.PTRF__r.Foundry_jobview__c.toUpperCase()))) && key.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Order_Type__c) && techGeoFlag != null && techGeoFlag) {
                        if (mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c != null && processTechnology.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c)) {
                            String customerShortName = key.substringBetween('Customer', ';');

                            if (customerShortName != null && customerShortName.trim() != '' && customerShortName.trim().toUpperCase() != 'NULL') {
                                if (customerShortName.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Customer_Short_Name__c)) {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    } else {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    }
                                } else {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                        gating = true;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    } else {
                                        gating = false;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    }
                                }
                            } else {

                                if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                    gating = true;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                } else {
                                    gating = false;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);

                                    break;
                                }
                            }
                        } else if (mrsLayerChipObj.PTRF__r.Process_Technology_Lifecycle_Phase__c == null && processTechnology.toUpperCase().containsIgnoreCase('NULL')) {
                            String customerShortName = key.substringBetween('Customer', ';');

                            if (customerShortName != null && customerShortName.trim() != '' && customerShortName.trim().toUpperCase() != 'NULL') {
                                if (customerShortName.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Customer_Short_Name__c)) {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    } else {

                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, null);
                                        break;
                                    }
                                } else {
                                    if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                        gating = true;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    } else {
                                        gating = false;
                                        ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                        break;
                                    }
                                }
                            } else {

                                if (mapOfStringAndGatingOrNotGating.get(key).equalsIgnoreCase('gating')) {
                                    gating = true;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);
                                    break;
                                } else {
                                    gating = false;
                                    ptrfIdAndIsGating.put(mrsLayerChipObj.PTRF__c, gating);

                                    break;
                                }
                            }
                        }
                    }

                }

            }
        }

        return ptrfIdAndIsGating;
    }

    //TASK-1983
    public static List < MRS_Layer_Association__c > sortMaskLayer(set < String > setPTRFIds, List < MRS_Layer_Association__c > LayerObj) {
        List < MRS_Layer_Association__c > WrapperList = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > tempWrapperList = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > tempAppenderList = new List < MRS_Layer_Association__c > ();
        Map < String, List < Mask_Layer__c >> firstFramePTRFMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < Mask_Layer__c >> firstPrimePTRFMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < Mask_Layer__c >> PTRFTrueMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < MRS_Layer_Association__c >> MapLayerObjToName = new Map < String, List < MRS_Layer_Association__c >> ();
        Map < String, List < MRS_Layer_Association__c >> WrapperMap = new Map < String, List < MRS_Layer_Association__c >> ();
        List < Mask_Layer__c > firstFramePTRF = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > firstPrimePTRF = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > TempMaskLayerList = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > PTRFTrueList = new List < Mask_Layer__c > ();
        List < AggregateResult > AggResult = new List < AggregateResult > ();
        Map < Id, List < Mask_Layer__c >> PTRFtoLayerMap = new Map < Id, List < Mask_Layer__c >> ();
        Boolean isFramePTRF = false;
        Boolean isPrimePTRF = false;
        String firstFrameId = NULL;
        String firstPrimeId = NULL;
        for (Mask_Layer__c newMaskLayer: [select Name, Mask_Layer_Number__c, PTRF__c, Tapeout__c, Sort_Order__c from Mask_Layer__c where PTRF__c in : setPTRFIds
        and Mask_Layer_Number__c not in ('NULL', 'null', '', null) ORDER BY Sort_Order__c ASC]) {
            if (PTRFtoLayerMap.containsKey(newMaskLayer.PTRF__c)) {
                List < Mask_Layer__c > LayerList = PTRFtoLayerMap.get(newMaskLayer.PTRF__c);
                LayerList.add(newMaskLayer);
                PTRFtoLayerMap.put(newMaskLayer.PTRF__c, LayerList);
            } else {
                PTRFtoLayerMap.put(newMaskLayer.PTRF__c, new List < Mask_Layer__c > {
                    newMaskLayer
                });
            }
        }
        for (MRS_Layer_Association__c newLayerObj: LayerObj) {
            if (MapLayerObjToName.containsKey(newLayerObj.Name)) {
                List < MRS_Layer_Association__c > LayerList = MapLayerObjToName.get(newLayerObj.Name);
                LayerList.add(newLayerObj);
                MapLayerObjToName.put(newLayerObj.Name, LayerList);
            } else {
                MapLayerObjToName.put(newLayerObj.Name, new List < MRS_Layer_Association__c > {
                    newLayerObj
                });
            }
        }
        tempAppenderList.clear();
        Map < String, String > TheMap = new Map < String, String > ();
        Set < String > PTRFSet = new Set < String > ();
        List < String > PTRFSortList = new List < String > ();
        List < String > PTRFSortListAfterPrimeFrameCheck = new List < String > ();
        
        AggResult = [select PTRF__c from MRS_Layer_Chip_Association__c where PTRF__c in : setPTRFIds group by PTRF__C ORDER BY min(CreatedDate) ASC];
        for (AggregateResult obj: AggResult) {
            PTRFSortList.add(String.valueOf(obj.get('PTRF__c')));
        }
        
        Map < Id, Boolean > CheckForFrameTapeout = new Map < Id, Boolean > ();
        List < PTRF__c > listPTRF = [select Id, Frame_Tapeout__c from PTRF__c where Id in : PTRFSortList];
        for (PTRF__c t: listPTRF) {
            CheckForFrameTapeout.put(t.Id, t.Frame_Tapeout__c);
        }
        for (String PTRFId: PTRFSortList) {
            Boolean isPresentFrame = CheckForFrameTapeout.get(PTRFId);
            TempMaskLayerList = PTRFtoLayerMap.get(PTRFId);
            if (TempMaskLayerList != NULL) {
                if (!isFramePTRF) {
                    if (isPresentFrame) {
                        isFramePTRF = true;
                        firstFrameId = PTRFId;
                    } else {
                        if (!isPrimePTRF) {
                            isPrimePTRF = true;
                            firstPrimeId = PTRFId;
                        }
                    }
                }
            }
        }
        if (isFramePTRF && firstFrameId != NULL) {
            firstFramePTRF = PTRFtoLayerMap.get(firstFrameId);
            PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstFrameId));
        } else {
            if (firstPrimeId != NULL && isPrimePTRF) {
                firstPrimePTRF = PTRFtoLayerMap.get(firstPrimeId);
                PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstPrimeId));
            }
        }
        List < Mask_Layer__c > currentPTRF = new List < Mask_Layer__c > ();
        for (String PTRFId: PTRFSortList) {
            currentPTRF.clear();
            if (isFramePTRF && firstFrameId != NULL) {
                if (PTRFId != firstFrameId) {
                    PTRFSortListAfterPrimeFrameCheck.add(PTRFId);
                }
            } else {
                if (firstPrimeId != NULL && isPrimePTRF) {
                    if (PTRFId != firstPrimeId) {
                        PTRFSortListAfterPrimeFrameCheck.add(PTRFId);
                    }
                }
            }
        }
        for (String strSortedPTRF: PTRFSortListAfterPrimeFrameCheck) {
            currentPTRF = PTRFtoLayerMap.get(strSortedPTRF);
            if (currentPTRF != NULL) {
                for (Mask_Layer__c currentMaskLayer: currentPTRF) {
                    List < MRS_Layer_Association__c > presentInList = MapLayerObjToName.get(currentMaskLayer.Mask_Layer_Number__c);
                    List < MRS_Layer_Association__c > ListDeltaCheck = WrapperMap.get(currentMaskLayer.Mask_Layer_Number__c);
                    if (presentInList != NULL) {
                        if (ListDeltaCheck == NULL) {
                            WrapperList.addAll(presentInList);
                            WrapperMap.clear();
                            for (MRS_Layer_Association__c newLayerObj: WrapperList) {
                                if (WrapperMap.containsKey(newLayerObj.Name)) {
                                    List < MRS_Layer_Association__c > LayerList = WrapperMap.get(newLayerObj.Name);
                                    LayerList.add(newLayerObj);
                                    WrapperMap.put(newLayerObj.Name, LayerList);
                                } else {
                                    WrapperMap.put(newLayerObj.Name, new List < MRS_Layer_Association__c > {
                                        newLayerObj
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
        return WrapperList;
    }
    //TASK-1983


    /**
        This method is for logging errors caught in exception during Create MRS activity 
        @method name: saveMRSExceptionErrorLog
        @parameter:   1. Exception object.
                      2. Name of Object which created the exception.
                      3. MessageId of the log.
              4. Name of Component where exception occured
              5. Name of methid where exception occured.            
        @return :     Nothing
     **/
    // Code added for TASK-2130 START
    public static void saveMRSExceptionErrorLog(Exception e, string objectName, string messageId, string componentName, string methodName) {
        list < SWIFTcustomLogUtility.customLogClass > lstlog = new list < SWIFTcustomLogUtility.customLogClass > ();
        SWIFTcustomLogUtility.customLogClass log = new SWIFTcustomLogUtility.customLogClass();
        log.debugLevel = 'ERROR';
        log.componentName = componentName;
        log.ComponentID = [select id from apexclass where name = : componentName].id;
        log.errorMessage = objectName + ':' + e.getmessage();
        log.stackTrace = e.getstacktracestring();
        log.messageID = messageId;
        log.method = methodName;
        lstLog.add(log);
        SWIFTcustomLogUtility.saveCustomLog(lstLog);
    }

    /**
        This method is for sending mail with errors caught in exception during Create MRS activity 
        @method name: sendMRSExceptionLogMail
        @parameter:   1. Exception object.
                      2. set of PTRF Ids.
        @return :     Nothing
     **/
    public static void sendMRSExceptionLogMail(Exception e, Set < string > PTRFIds) {

        String bodytext;
        String subject = '';
        String strPTRFids = '';
        Map < String, Map < String, String >> mapPTRFtoData = new Map < string, Map < String, String >> ();
        Map < String, String > tempMap;
        set < string > setFullPTRF = new set < string > ();

        try {

            if (PTRFIds != null) {
                for (ptrf__c tempPtrf: [select id, name from ptrf__c where id in : PTRFIds]) {
                    strPTRFids = strPTRFids + tempPtrf.name + ',';
                    setFullPTRF.add(tempPtrf.id + ':' + tempPtrf.name);
                }
            }
            if (strPTRFids.contains(',')) {
                strPTRFids = strPTRFids.Substring(0, strPTRFids.length() - 1);
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            EmailTemplate templateMain = [Select id, Subject, Body, HtmlValue, DeveloperName from EmailTemplate where DeveloperName = 'SWIFT_MRS_Exception_Log_Template'];
            bodytext = templateMain.HtmlValue;

            bodytext = bodytext.replace('<PTRF_num>', strPTRFids);
            bodytext = bodytext.replace('<Error_message>', e.getMessage());

            subject = templateMain.subject;
            subject = subject.replace('<Org_Name>', UserInfo.getOrganizationName());



            if (setFullPTRF.size() > 0) {
                Id idPTRF;
                string strPTRFNumber;
                for (String PtrfId: setFullPTRF) {
                    idPTRF = PtrfId.split(':')[0];
                    strPTRFNumber = PtrfId.split(':')[1];

                    tempMap = new Map < String, String > ();
                    bodytext = bodytext.replace('<PTRF>', strPTRFNumber);
                    tempMap.put(Label.EmailKeysetForTemplate, templateMain.DeveloperName);
                    tempMap.put(Label.EmailKeysetForGatingNotGating, 'NA');
                    tempMap.put(Label.EmailKeysetForBody, bodytext);
                    tempMap.put(Label.EmailKeysetForSubject, subject);

                    mapPTRFtoData.put(idPTRF, tempMap);
                }
            }

            if (mapPTRFtoData.size() > 0) {
                try {
                    EmailHandlerUtility.ptrfEmailMethod(mapPTRFtoData);
                } catch (Exception ex) {
                    system.debug(ex);
                }
            }

        } catch (exception exp) {}
    }
    // Code added for TASK-2130 END

    public static void logValidationError(String wsMsg, String errorMsg, String msgId, String className, String methodName, String debugLevel, String ptrfNumber, boolean isRetry,boolean sendEmail){
        // wsMsg is JSON format
        if(wsMsg.length() > 32000){ wsMsg   = wsMsg.subString(0,32000); }
        if(errorMsg.length() > 32000){ errorMsg   = errorMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = debugLevel     ,     Apex_Component_Name__c    = className     ,     Method__c          = methodName,    
            Integration_Payload__c    = wsMsg          ,     Stack_Trace__c          = errorMsg      ,     Error_Message__c     = '',
            Message_ID__c             = msgId + ' | ' + ptrfNumber      ,       Trigger_Exception_Email__c = sendEmail
        );
        if(isRetry) {
            log.Is_Auto_Retry__c = true;
            log.Retry_Status__c = 'New';  
        }
        insert log;
    }
    
    public static void saveCancelExceptionSignal(DMLException e, set < String > ptrfIdSets) {
        boolean sendEmail = false;
        boolean autoRetry = false;
        if(e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) { autoRetry = true; } 
        else { sendEmail = true; }
        //AUTO RETRY
        logValidationError(json.serialize(ptrfIdSets), 
            'Cancel PTRF Errors: ' + e.getMessage() + '\r\n' + e.getStackTraceString(), 
            'PTRF_Cancel', 'MRSHandlerUtility', 
            'executeUpdateMCLAFuture', 
            'ERROR', 
            '-', 
            autoRetry,
            sendEmail                
        );
    }
    
    /*this method is for workaround as there is in a hurry*/
    public static void sendMRSExceptionLogMail2(Exception e, Set < string > PTRFIds) {
        if(null == e || PTRFIds.isEmpty()) return; 
        List<PTRF__c> ptrfs = [SELECT Name FROM PTRF__c WHERE Id IN :PTRFIds];
        String ptrfsName = '';
        for(PTRF__c p: ptrfs) { ptrfsName += p.Name + '; '; }
        String mailBody = 'Hi SWIFT,\r\n\r\n';
        mailBody += 'There are errors when generate layer-chip for perform tapeout ptrfs cause layer-chip failed to generated. Please following up and re-generate if needed.\r\n\r\n';
        mailBody += 'Error message: ' + e.getMessage() + '\r\n' + e.getStackTraceString();
        mailBody += '\r\n\r\n';
        mailBody += 'Failure PTRFs: ' + ptrfsName;
        mailBody += '\r\n\r\n';//This is a system generated message, please do not reply.
        mailBody += 'This is a system generated message, please do not reply.\r\nHave a nice day.';//This is a system generated message, please do not reply.
        //=========================
        List<String> toAddesss = Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';');
        //=========================
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddesss);
        mail.setSubject('[MRS-ERROR] FAILED TO GENERATE LAYER-CHIP ' + ptrfsName);
        mail.setPlainTextBody(mailBody);
        try { Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); } catch(Exception ex) { }
        //=========================
    }
}