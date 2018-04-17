/*
    Author: Abhita Bansal
    Description: This serves as handler for MPWChangeRequestTrigger trigger.
    History: 
        ABansal      27072015    - Code creation.
        Poulami      01042016    - added logic to update MPW Prime Die Wafer Corner Split fields value once the change request is approved(MPW-PP28)
        Anil Kumar    00070564  - 0.15um Sub-Device Extraction supportability : April 18, 2017
        Kanishk Singh W-000647: 16 June 2017  : Added Option_c2 calculation for Prime ExdraDie and Request_Type= 'Wafer Form Delivery'
        Kanishk Singh W-000647: 7 July 2017  :  ratio of '3' for 22nm, same as 28nm.Implemented formula for extra wafer and die.method name calculateExtraDieB
*/ 
public class MPWChangeRequestTriggerHandler {
    
    //variables
    public List<MPW_Prime_Die__c> mpwPrimeDieList;
    public List<MPW_Prime_Die__c> tempList;
    public map<Id, MPW_Prime_Die__c> mapIdToPrimeDie;
    public map<Id, List<MPW_Prime_Die__c>> mapFormIdToPrimeDie;
    public UtilClassToGetAllFields util;
    public List<Customer_Guideline_Factor__c> cglfList{get;set;}
    public List<Internal_Guideline_Factor__c> iglfList{get;set;}
    public Map<String, Customer_Guideline_Factor__c> cglfMap{get;set;}
    public Map<String, Internal_Guideline_Factor__c> iglfMap{get;set;} 
    public Map<String, MPW_Internal_Guideline_Factor__c> mapInternalGuidelineFactorCS;//Added by Kanishk: 7 July 2017
    public String queryFields = '';
    public String queryFields1 = '';
    public String soql = '';
    public Set<Id> primeDieIds;
    public Set<Id> formIds;
    public Set<Id> attachCornerIds;
    public Set<Id> attachTurnkeyIds;
    public Set<Id> attachSubDeviceIds;
    public Set<Id> attachChangeCornerIds;
    public Set<Id> attachChangeTurnkeyIds;
    public Set<Id> attachChangeSubDeviceIds;
    public map<Id, Id> mapattachChangeCornerIds;
    public map<Id, Id> mapattachChangeTurnkeyIds;
    public map<Id, Id> mapattachChangeSubDeviceIds;
    public Set<Id> ownerIds;
    public Integer shortLoop;
    
    public MPWChangeRequestTriggerHandler(){
        util = new UtilClassToGetAllFields();
        
        cglfList = new List<Customer_Guideline_Factor__c>();
        iglfList = new List<Internal_Guideline_Factor__c>();
        cglfMap = new Map<String, Customer_Guideline_Factor__c>();
        iglfMap = new Map<String, Internal_Guideline_Factor__c>();
        
        mapattachChangeCornerIds = new map<Id, Id>();
        mapattachChangeTurnkeyIds = new map<Id, Id>();
        mapattachChangeSubDeviceIds = new map<Id, Id>();
        mpwPrimeDieList = new List<MPW_Prime_Die__c>();
        mapIdToPrimeDie = new map<Id, MPW_Prime_Die__c>();
        mapFormIdToPrimeDie = new Map<Id, List<MPW_Prime_Die__c>>();
        attachCornerIds = new Set<Id>();
        attachTurnkeyIds = new Set<Id>();
        attachSubDeviceIds = new Set<Id>();
        attachChangeCornerIds = new Set<Id>();
        attachChangeTurnkeyIds = new Set<Id>();
        attachChangeSubDeviceIds = new Set<Id>();
        primeDieIds = new Set<Id>();
        ownerIds = new Set<Id>();
        formIds = new Set<Id>();
        
        queryFields = util.getAllFields('Customer_Guideline_Factor__c');
        soql = 'select '+queryFields+' from Customer_Guideline_Factor__c order by Name asc';
        cglfList = database.query(soql);
        if(!cglfList.isEmpty()){
            for(Customer_Guideline_Factor__c  c : cglfList){
                cglfMap.put(c.Tech_ID__c, c);
            }
        }
        
        queryFields = util.getAllFields('Internal_Guideline_Factor__c');
        soql = 'select '+queryFields+' from Internal_Guideline_Factor__c order by Name asc';
        iglfList = database.query(soql);
        if(!iglfList.isEmpty()){
            for(Internal_Guideline_Factor__c  i : iglfList){
                iglfMap.put(i.TechID__c, i);
            }
        }
        
        /*** Start : Added By Kanishk ***/
         mapInternalGuidelineFactorCS = new Map<String, MPW_Internal_Guideline_Factor__c>();
        for(MPW_Internal_Guideline_Factor__c cs: [SELECT Id, Name, Category__c, Geometry__c, NON_SPLIT_Corner_Factor__c, SPLIT_Corner_Factor__c
                                                    FROM MPW_Internal_Guideline_Factor__c]) {
            String strKey = cs.Category__c.trim().toLowerCase() + '-' + cs.Geometry__c.trim().toLowerCase();
            mapInternalGuidelineFactorCS.put(strKey, cs);
        }
        /*** End : Added By Kanishk ***/
        
        
    }
    
    // Added by Anil : MPW-PP103 
    public void onAfterInsert(List<MPW_Change_Request__c> lstChangeReqNew) {
        updatePrimeDieOnInsertUpdateDelete(lstChangeReqNew, null);
    }
    
    // Added by Anil : MPW-PP103 
    public void onAfterUpdate(List<MPW_Change_Request__c> lstChangeReqNew, Map<Id, MPW_Change_Request__c> mapChangeReqOld) {
        updatePrimeDieOnInsertUpdateDelete(lstChangeReqNew, mapChangeReqOld);
    }
    
    // Added by Anil : MPW-PP103 
    public void onAfterDelete(List<MPW_Change_Request__c> lstChangeReqOld) {
        updatePrimeDieOnInsertUpdateDelete(lstChangeReqOld, null);
    }
    
    /*  Added by Anil : MPW-PP103
        Description : Final Reservation Change - If total number of MPW Change Request Type â€œDrawn Die Size Changeâ€ under the MPW Prime Die > 0, populate the latest â€œRequested Onâ€ date. Else leave this field as blank
    */
    private void updatePrimeDieOnInsertUpdateDelete(List<MPW_Change_Request__c> lstChangeReqNew, Map<Id, MPW_Change_Request__c> mapChangeReqOld) {
        List<MPW_Prime_Die__c> lstPrimeDiesToBeUpdate = new List<MPW_Prime_Die__c>();
        Set<Id> setPrimeDieIds = new Set<Id>();
        Set<Id> setPrimeDieIdsOnUpdate = new Set<Id>();
        String strEvent = mapChangeReqOld != null ? 'UPDATE' : 'INSERT';
        
        try {
            for(MPW_Change_Request__c cr : lstChangeReqNew) {
                if(strEvent == 'INSERT' && cr.Request_Type__c == 'Drawn Die Size Change') {
                    setPrimeDieIds.add(cr.MPW_Prime_Die__c);  
                }
                
                if(strEvent == 'UPDATE') {
                    if((cr.Request_Type__c == 'Drawn Die Size Change' && mapChangeReqOld.get(cr.Id).Request_Type__c != 'Drawn Die Size Change') ||
                        (cr.Requested_On__c != mapChangeReqOld.get(cr.Id).Requested_On__c)) {
                        setPrimeDieIdsOnUpdate.add(cr.MPW_Prime_Die__c);
                    }
                    if(cr.Request_Type__c != 'Drawn Die Size Change' && mapChangeReqOld.get(cr.Id).Request_Type__c == 'Drawn Die Size Change') {
                        setPrimeDieIds.add(cr.MPW_Prime_Die__c);
                    }
                }
            }
            
            Set<Id> setTempIds = new Set<Id>();
            
            for(MPW_Change_Request__c cr : [SELECT Id, Request_Type__c, Requested_On__c, MPW_Prime_Die__c 
                                            FROM MPW_Change_Request__c
                                            WHERE (MPW_Prime_Die__c IN : setPrimeDieIds OR MPW_Prime_Die__c IN : setPrimeDieIdsOnUpdate)
                                            AND Requested_On__c != NULL AND Request_Type__c = 'Drawn Die Size Change'
                                            ORDER BY Requested_On__c DESC ]) {
                if(!setTempIds.contains(cr.MPW_Prime_Die__c)) {
                    setTempIds.add(cr.MPW_Prime_Die__c);
                    MPW_Prime_Die__c oPD = new MPW_Prime_Die__c(Id = cr.MPW_Prime_Die__c);
                    oPD.Final_Reservation_Change__c = cr.Requested_On__c;
                    lstPrimeDiesToBeUpdate.add(oPD);
                }
            }
            
            for(Id oId : setPrimeDieIds) {
                if(!setTempIds.contains(oId)) {
                    MPW_Prime_Die__c oPD = new MPW_Prime_Die__c(Id = oId);
                    oPD.Final_Reservation_Change__c = null;
                    lstPrimeDiesToBeUpdate.add(oPD);
                }
            }
            
            if(lstPrimeDiesToBeUpdate.size() > 0) {
                update lstPrimeDiesToBeUpdate;
            }
        }
        catch(exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, MPWChangeRequestTriggerHandler.class.getName(), 'updatePrimeDieOnInsertUpdateDelete()', '', 'MPW Change Request Trigger Handler');
        }
    }
    
    public void updatePrimeDie(List<MPW_Change_Request__c> mpwChangeReqList){
        
        for(MPW_Change_Request__c ch : mpwChangeReqList) {
            primeDieIds.add(ch.MPW_Prime_Die__c);
        }
        
        queryFields = util.getAllFields('MPW_Prime_Die__c');
        soql = 'SELECT '+queryFields+' FROM MPW_Prime_Die__c WHERE ID IN :primeDieIds';  
        mpwPrimeDieList = database.query(soql);
        
        for(MPW_Prime_Die__c mpwPD : mpwPrimeDieList) {
            formIds.add(mpwPD.MPW_Form__c);
            mapIdToPrimeDie.put(mpwPD.Id, mpwPD);
        }
        
        String soql1 = 'SELECT '+queryFields+' FROM MPW_Prime_Die__c WHERE MPW_Form__c IN :formIds ORDER BY MPW_Form__c ASC'; 
        tempList = database.query(soql1);
             
        List<MPW_Prime_Die__c> temp = new List<MPW_Prime_Die__c>();
        String formPD = tempList[0].MPW_Form__c;
        for(MPW_Prime_Die__c mpwPD : tempList) {           
            if(mpwPD.MPW_Form__c == formPD) {
                temp.add(mpwPD);
                formPD = mpwPD.MPW_Form__c;
            } else {
                mapFormIdToPrimeDie.put(formPD, temp);
                formPD = mpwPD.MPW_Form__c;
                temp = new List<MPW_Prime_Die__c>();
                temp.add(mpwPD);
            }
        }
        
        if (temp.size() > 0) {
            mapFormIdToPrimeDie.put(formPD, temp);
        }
        
        
                
        for(MPW_Change_Request__c ch : mpwChangeReqList) {
           mpwPrimeDieList = new List<MPW_Prime_Die__c>();
           MPW_Prime_Die__c mpwpd = new MPW_Prime_Die__c();
           mpwpd = mapIdToPrimeDie.get(ch.MPW_Prime_Die__c);
           
           mpwpd.Operation_Type__c = 'Update';
           
           if(ch.Request_Type__c == 'Metal Stack Change') {
           	mpwpd.Metal_Stack__c=ch.Metal_Stack__c;
           }
           if(ch.Request_Type__c == 'Drawn Die Size Change') {
               mpwpd.Drawn_Die_Size_X_um__c = ch.Drawn_Die_Size_X_um__c;
               mpwpd.Drawn_Die_Size_Y_um__c = ch.Drawn_Die_Size_Y_um__c;
               Decimal diexsize = Decimal.valueOf(ch.Drawn_Die_Size_X_um__c) * 0.001;
               Decimal dieysize = Decimal.valueOf(ch.Drawn_Die_Size_Y_um__c) * 0.001;
               if(mpwpd.Category__c == 'Customer') {                   
                   if((diexsize * dieysize) <= 9){
                       mpwpd.RETICLE_SPACE_A__c =  cglfMap.get(mpwpd.Geometry__c).ReticleSpace_Min__c;
                   }
                   else{
                       mpwpd.RETICLE_SPACE_A__c = diexsize * dieysize *  cglfMap.get(mpwpd.Geometry__c).RecticalSpace_A1__c;
                   }  
               } else {
                   mpwpd.RETICLE_SPACE_A__c = diexsize * dieysize * iglfMap.get(mpwpd.Geometry__c).Reticle__c;
               }
           }
           if(ch.Request_Type__c == 'Wafer Form Delivery') {
               boolean hasWaferQuantity = false;
               if(ch.Category__c == 'TD' || ch.Category__c == 'FAB'){
                   mpwpd.Delivery_Qty_Wafer_Form__c = ch.Delivery_Qty_Wafer_Form__c;
               }
               else{
                   mpwpd.Delivery_Qty_Die_Form__c = ch.Delivery_Qty_Die_Form__c;
                   mpwpd.Delivery_Qty_Wafer_Form__c = ch.Delivery_Qty_Wafer_Form__c;
                   mpwpd.Address1_Quantity_Delivery_In_DIE_Form__c = ch.Address1_Quantity_Delivery_In_DIE_Form__c;
                   mpwpd.Address1_Quantity_Delivery_In_WAFER_Form__c = ch.Address1_Quantity_Delivery_In_WAFER_Form__c;
                   mpwpd.Address2_Quantity_Delivery_In_DIE_Form__c = ch.Address2_Quantity_Delivery_In_DIE_Form__c;
                   mpwpd.Address2_Quantity_Delivery_In_WAFER_Form__c = ch.Address2_Quantity_Delivery_In_WAFER_Form__c;
                   mpwpd.Address3_Quantity_Delivery_In_DIE_Form__c = ch.Address3_Quantity_Delivery_In_DIE_Form__c;
                   mpwpd.Address3_Quantity_Delivery_In_WAFER_Form__c= ch.Address3_Quantity_Delivery_In_WAFER_Form__c;
               }
               if(mpwpd.Category__c == 'Customer') {
                   integer count = 0;
                   for(MPW_Prime_Die__c mpwpd1 : mapFormIdToPrimeDie.get(ch.MPW_Form__c)) {
                         if(mpwpd1.Delivery_Qty_Wafer_Form__c != '0'){
                             hasWaferQuantity = true;
                             break;
                         }
                       else{
                           count++;
                       }
                   }
                   if(hasWaferQuantity){
                       mapFormIdToPrimeDie.get(ch.MPW_Form__c)[count].OPTION_C3__c = cglfMap.get(mapFormIdToPrimeDie.get(ch.MPW_Form__c)[count].Geometry__c).Wafer_Form_Delivery__c;
                   }
                   mpwpd.Extra_Die_B__c = ((Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50))-50)/50 * cglfMap.get(mpwpd.Geometry__c).ExtraDice_B__c;
                   mpwpd.Extra_Die_Qty__c = (Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50))-50;
                   mpwpd.Extra_Wafer_Qty__c = ((Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50))-50)/50;
                  
                //Added by Kanishk - June 16, 2017: Option C2 calculation for ExtraDie
                
                    Set<String> setSubDeviceExtractionGeometry = new Set<String>(); 
                    for(MPW_Sub_Device_Extraction_Geometry__c cs : [SELECT Name, Geometry__c FROM MPW_Sub_Device_Extraction_Geometry__c]) {
                        setSubDeviceExtractionGeometry.add(cs.Geometry__c.toLowerCase());
                    }
                    
                   if((mpwpd.Geometry__c != null && setSubDeviceExtractionGeometry.contains(mpwpd.Geometry__c.toLowerCase())) && Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) != 0){                 
                        mpwpd.OPTION_C2__c = (Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) - 1) * (cglfMap.get(mpwpd.Geometry__c).Sub_Devices_Extraction__c) * (Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c)/50);
                    }
                    else{
                        mpwpd.OPTION_C2__c = 0;
                    }
                //End OPTION_C2__c calculation
              
               }
               else{
                   List<String> dietowaferlist = iglfMap.get(mpwpd.Geometry__c).DieToWaferConv__c.split('/');
                  
                  //Added by Kanishk
                  // mpwpd.Extra_Die_B__c = ((Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50)) * iglfMap.get(mpwpd.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1]);
                   mpwpd.Extra_Die_B__c = calculateExtraDieB(mpwpd,this.mapInternalGuidelineFactorCS,false,null,null);
                   mpwpd.Extra_Die_Qty__c = Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50);
                   mpwpd.Extra_Wafer_Qty__c = (Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c) + (Integer.valueOf(mpwpd.Delivery_Qty_Wafer_Form__c)*50))/50;        
               }
           }
           if(ch.Request_Type__c == 'Corner Split Change') {
               
               if(mpwpd.CornerSplitAttachedId__c != null && mpwpd.CornerSplitAttachedId__c != ''){
                   attachCornerIds.add(mpwpd.CornerSplitAttachedId__c);
               }
           
               mpwpd.Corner_Split__c = ch.Corner_Split__c;
               mpwpd.POR__c = ch.POR__c;
               mpwpd.SF__c = ch.SF__c;
               mpwpd.SS__c = ch.SS__c;
               mpwpd.FF__c = ch.FF__c;
               mpwpd.FS__c = ch.FS__c;
               //01042016 - Added by Poulami Starts
               mpwpd.Wafer_POR__c = ch.Wafer_POR__c;
               mpwpd.Wafer_SF__c = ch.Wafer_SF__c;
               mpwpd.Wafer_SS__c = ch.Wafer_SS__c;
               mpwpd.Wafer_FF__c = ch.Wafer_FF__c;
               mpwpd.Wafer_FS__c = ch.Wafer_FS__c;
               //01042016 - Added by Poulami Ends
               mpwpd.CornerSplitAttached__c = ch.CornerSplitAttached__c;
               mpwpd.CornerSplitAttachedId__c = ch.CornerSplitAttachedId__c;
               
               if((ch.CornerSplitAttachedId__c != null || ch.CornerSplitAttachedId__c != '') && ch.Corner_Split__c == 'Yes'){
                   attachChangeCornerIds.add(ch.CornerSplitAttachedId__c);
                   mapattachChangeCornerIds.put(ch.Id, mpwpd.Id);
               } 
               
           }
           if(ch.Request_Type__c == 'Expedite Change') {
               mpwpd.Expedite_In_DIE_Form__c = ch.Expedite_In_DIE_Form__c;
               mpwpd.Expedite_In_WAFER_Form__c = ch.Expedite_In_WAFER_Form__c;
               List<String> dietowaferlist = iglfMap.get(mpwpd.Geometry__c).DieToWaferConv__c.split('/');
               if(mpwpd.Category__c == 'Customer') {
                    mpwpd.ADDER_D2__c = (Integer.valueOf(ch.Expedite_In_DIE_Form__c) + (Integer.valueOf(ch.Expedite_In_WAFER_Form__c)*50))/50 * cglfMap.get(mpwpd.Geometry__c).Expedite__c;
               }
           }
           if(ch.Request_Type__c == 'Turnkey Services Change') {
               
               if(mpwpd.TurnkeyAttachedId__c != null || mpwpd.TurnkeyAttachedId__c != '') {
                   attachTurnkeyIds.add(mpwpd.TurnkeyAttachedId__c);
               }
               
               mpwpd.Turnkey_Service__c = ch.Turnkey_Service__c;
               mpwpd.TurnkeyAttachedId__c = ch.TurnkeyAttachedId__c;
               mpwpd.TurnkeyAttached__c = ch.TurnkeyAttached__c;
               
               if((ch.TurnkeyAttachedId__c != null || ch.TurnkeyAttachedId__c != '') && ch.Turnkey_Service__c == 'Yes'){
                   attachChangeTurnkeyIds.add(ch.TurnkeyAttachedId__c);
                   mapattachChangeTurnkeyIds.put(ch.Id, mpwpd.Id);
               } 
               
           }
           if(ch.Request_Type__c == 'Short Loop Change') {
               if(ch.Address1_ShortLoop_Wafer__c != null) {
                   mpwpd.Address1_ShortLoop_Wafer__c = ch.Address1_ShortLoop_Wafer__c;
               }
               if(ch.Address2_ShortLoop_Wafer__c != null) {
                   mpwpd.Address2_ShortLoop_Wafer__c = ch.Address2_ShortLoop_Wafer__c;
               } 

               if(ch.Address3_ShortLoop_Wafer__c != null) {
                   mpwpd.Address3_ShortLoop_Wafer__c = ch.Address3_ShortLoop_Wafer__c;
               } 
               
               if(ch.Address2_ShortLoop_Wafer__c == null && ch.Address3_ShortLoop_Wafer__c == null && ch.Address1_ShortLoop_Wafer__c != null) {
                   shortLoop = Integer.valueOf(ch.Address1_ShortLoop_Wafer__c);
               }
               if(ch.Address2_ShortLoop_Wafer__c != null && ch.Address3_ShortLoop_Wafer__c == null && ch.Address1_ShortLoop_Wafer__c != null) {
                   shortLoop = Integer.valueOf(ch.Address1_ShortLoop_Wafer__c) + Integer.valueOf(ch.Address2_ShortLoop_Wafer__c);
               }
               if(ch.Address2_ShortLoop_Wafer__c != null && ch.Address3_ShortLoop_Wafer__c != null) {
                   shortLoop = Integer.valueOf(ch.Address1_ShortLoop_Wafer__c) + Integer.valueOf(ch.Address2_ShortLoop_Wafer__c)+ Integer.valueOf(ch.Address3_ShortLoop_Wafer__c);
               }
               mpwpd.ShortLoop_Wafer__c = String.valueOf(shortLoop);
               
               if(mpwpd.Category__c == 'Customer') {
                   mpwpd.ADDER_D3__c = shortLoop * cglfMap.get(mpwpd.Geometry__c).ShortLoop_Wafer__c;
               }
           }
           if(ch.Request_Type__c == 'Backgrind Change') {
               mpwpd.Backgrind__c = ch.Backgrind__c;
           }
           if(ch.Request_Type__c == 'Sub Devices Extraction') {
           
               if(mpwpd.SubDevicesExtractionAttachedId__c != null || mpwpd.SubDevicesExtractionAttachedId__c != '') {
                   attachSubDeviceIds.add(mpwpd.SubDevicesExtractionAttachedId__c);
               }
               
               mpwpd.Sub_Devices_Extraction__c = ch.Sub_Devices_Extraction__c;
               mpwpd.SubDevicesExtractionAttachedId__c = ch.SubDevicesExtractionAttachedId__c;
               mpwpd.SubDevicesExtractionAttached__c = ch.SubDevicesExtractionAttached__c;
               
               if((ch.SubDevicesExtractionAttachedId__c != null || ch.SubDevicesExtractionAttachedId__c != '') && ch.Sub_Devices_Extraction__c != '0'){
                   attachChangeSubDeviceIds.add(ch.SubDevicesExtractionAttachedId__c);
                   mapattachChangeSubDeviceIds.put(ch.Id, mpwpd.Id);
               } 
               
               //Added by Anil - April 18, 2017
                Set<String> setSubDeviceExtractionGeometry = new Set<String>(); 
                for(MPW_Sub_Device_Extraction_Geometry__c cs : [SELECT Name, Geometry__c FROM MPW_Sub_Device_Extraction_Geometry__c]) {
                    setSubDeviceExtractionGeometry.add(cs.Geometry__c.toLowerCase());
                }
                
               if(mpwpd.Category__c == 'Customer') {
                    //Modified by Anil : 00070564  - 0.15um Sub-Device Extraction supportability : April 18, 2017
                    if((mpwpd.Geometry__c != null && setSubDeviceExtractionGeometry.contains(mpwpd.Geometry__c.toLowerCase())) && Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) != 0){                 
                        mpwpd.OPTION_C2__c = (Integer.valueOf(ch.Sub_Devices_Extraction__c) - 1) * (cglfMap.get(mpwpd.Geometry__c).Sub_Devices_Extraction__c) * (Integer.valueOf(mpwpd.Delivery_Qty_Die_Form__c)/50);
                    }
                    else{
                        mpwpd.OPTION_C2__c = 0;
                    }
               }
           }
            mpwpd.Operation_Type__c = 'Update';
            mpwpd.isExtraDieRequest__c = false;
           mpwPrimeDieList.add(mpwpd);       
        }
        if(!mpwPrimeDieList.isEmpty()) {
            update mpwPrimeDieList;
        }
        
        List<Attachment> attachChangeCorner = new List<Attachment>();
        List<Attachment> attachChangeTurnkey = new List<Attachment>();
        List<Attachment> attachChangeSubDevice = new List<Attachment>();
        
        List<Attachment> attachCorner = [Select Id from Attachment where Id IN: attachCornerIds];
        List<Attachment> attachTurnkey = [Select Id from Attachment where Id IN: attachTurnkeyIds];
        List<Attachment> attachSubDevice = [Select Id from Attachment where Id IN: attachSubDeviceIds];
        
       /* if(!attachCorner.isEmpty()) {
           //delete attachCorner ; //Commented by Anil : Dec 1, 2016. Case #00062307
        }
        
        if(!attachTurnkey.isEmpty()) {
            //delete attachTurnkey; //Commented by Anil : Dec 1, 2016. Case #00062307
        }
        
        if(!attachSubDevice.isEmpty()) {
           // delete attachSubDevice; //Commented by Anil : Dec 1, 2016. Case #00062307
        }
        */
    }
    
    //Kanishk: Calculate extra die. it is based on custom setting MPW Ingernal Guideline factor
     private integer calculateExtraDieB(MPW_Prime_Die__c objPrimeDie, Map < String, MPW_Internal_Guideline_Factor__c > mapInternalGuidelineFactorCS,
                                         boolean isExtraDie, Integer extraQuantityDie, Integer extraQuantityWafer) {

       List < String > dietowaferlist = iglfMap.get(objPrimeDie.Geometry__c).DieToWaferConv__c.split('/');

       Integer intDQDF = 0;
       Integer intDQWF = 0;

       if (!isExtraDie) {
           intDQDF = Integer.valueOf(objPrimeDie.Delivery_Qty_Die_Form__c);
           intDQWF = Integer.valueOf(objPrimeDie.Delivery_Qty_Wafer_Form__c);
       } else {
           intDQDF = extraQuantityDie;
           intDQWF = extraQuantityWafer;
       }


       if (objPrimeDie.Corner_Split__c != null && objPrimeDie.Corner_Split__c.toLowerCase() == 'yes' && objPrimeDie.Category__c != null && objPrimeDie.Geometry__c != null) {
           String strKey = objPrimeDie.Category__c.trim().toLowerCase() + '-' + objPrimeDie.Geometry__c.trim().toLowerCase();
           Integer intSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).SPLIT_Corner_Factor__c) : 1;

           Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;

           Integer intPOR = objPrimeDie.POR__c == null ? 0 : Integer.valueOf(objPrimeDie.POR__c);
           Integer intFF = objPrimeDie.FF__c == null ? 0 : Integer.valueOf(objPrimeDie.FF__c);
           Integer intSS = objPrimeDie.SS__c == null ? 0 : Integer.valueOf(objPrimeDie.SS__c);
           Integer intSF = objPrimeDie.SF__c == null ? 0 : Integer.valueOf(objPrimeDie.SF__c);
           Integer intFS = objPrimeDie.FS__c == null ? 0 : Integer.valueOf(objPrimeDie.FS__c);
           intDQDF = (intDQDF - intPOR - intFF - intSS - intSF - intFS);
           intDQDF = intDQDF + (intPOR * intNonSplitFactor) + (intFF * intSplitFactor) + (intSS * intSplitFactor) + (intSF * intSplitFactor) + (intFS * intSplitFactor);

           Integer intWPOR = objPrimeDie.Wafer_POR__c == null ? 0 : Integer.valueOf(objPrimeDie.Wafer_POR__c);
           Integer intWFF = objPrimeDie.Wafer_FF__c == null ? 0 : Integer.valueOf(objPrimeDie.Wafer_FF__c);
           Integer intWSS = objPrimeDie.Wafer_SS__c == null ? 0 : Integer.valueOf(objPrimeDie.Wafer_SS__c);
           Integer intWSF = objPrimeDie.Wafer_SF__c == null ? 0 : Integer.valueOf(objPrimeDie.Wafer_SF__c);
           Integer intWFS = objPrimeDie.Wafer_FS__c == null ? 0 : Integer.valueOf(objPrimeDie.Wafer_FS__c);
           intDQWF = (intDQWF - intWPOR - intWFF - intWSS - intWSF - intWFS);
           intDQWF = intDQWF + (intWPOR * intNonSplitFactor) + (intWFF * intSplitFactor) + (intWSS * intSplitFactor) + (intWSF * intSplitFactor) + (intWFS * intSplitFactor);
       } else if ((objPrimeDie.Corner_Split__c != null && objPrimeDie.Corner_Split__c.toLowerCase() == 'no' && objPrimeDie.Category__c != null && objPrimeDie.Geometry__c != null)) {
           String strKey = objPrimeDie.Category__c.trim().toLowerCase() + '-' + objPrimeDie.Geometry__c.trim().toLowerCase();

           Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;

           intDQDF = intDQDF * intNonSplitFactor;
           intDQWF = intDQWF * intNonSplitFactor;
       }

       return Integer.valueOf((iglfMap.get(objPrimeDie.Geometry__c) != null ? ((((intDQDF + (intDQWF * 50)) * iglfMap.get(objPrimeDie.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1])).setScale(2, RoundingMode.HALF_UP)) : 0));

   }
  
    
    public void updateExtraDie(List<MPW_Change_Request__c> mpwChangeReqListExtraDies){
        
        Set<String> formNumber = new set<String>();
        Map<Id, String> mapIdToName = new map<Id, String>();
        Map<Id, String> mapIdToLoginID = new map<Id, String>();
        List<MPW_Extra_Die__c> mpwExtraDieList = new List<MPW_Extra_Die__c>();
        List<MPW_Extra_Die__c> tempList = new List<MPW_Extra_Die__c>();
        Map<String, List<MPW_Extra_Die__c>> mapNumberToExtraDie = new Map<String, List<MPW_Extra_Die__c>>();
                
        for(MPW_Change_Request__c ch : mpwChangeReqListExtraDies) {
            primeDieIds.add(ch.MPW_Prime_Die__c);
            ownerIds.add(ch.OwnerId);
            formNumber.add(ch.MPW_Form_Name__c);
        }
        
        queryFields1 = util.getAllFields('MPW_Extra_Die__c');
        String soql1 = 'SELECT '+queryFields1+' FROM MPW_Extra_Die__c WHERE MPW_Form_Number__c IN :formNumber ORDER BY CreatedDate DESC'; 
        tempList = database.query(soql1);
        
        if(!tempList.isEmpty()) {   
            List<MPW_Extra_Die__c> temp = new List<MPW_Extra_Die__c>();
            String formNum = tempList[0].MPW_Form_Number__c;
            for(MPW_Extra_Die__c mpwED : tempList) {           
                if(mpwED.MPW_Form_Number__c == formNum) {
                    temp.add(mpwED);
                    formNum = mpwED.MPW_Form_Number__c;
                } else {
                    mapNumberToExtraDie.put(formNum, temp);
                    formNum = mpwED.MPW_Form_Number__c;
                    temp = new List<MPW_Extra_Die__c>();
                    temp.add(mpwED);
                }
            }
            
            if (temp.size() > 0) {
                mapNumberToExtraDie.put(formNum, temp);
            }
        }
        
        List<User> userInfo = [Select Id, Name, HCM_Login_ID__c from User where Id IN: ownerIds];
        
        for(User uInfo: userInfo) {
            mapIdToName.put(uInfo.Id, uInfo.Name);
            mapIdToLoginID.put(uInfo.Id, uInfo.HCM_Login_ID__c);
        }
        
        queryFields = util.getAllFields('MPW_Prime_Die__c');
        soql = 'SELECT '+queryFields+' FROM MPW_Prime_Die__c WHERE ID IN :primeDieIds';  
        mpwPrimeDieList = database.query(soql);
        
        for(MPW_Prime_Die__c mpwPD : mpwPrimeDieList) {
            mapIdToPrimeDie.put(mpwPD.Id, mpwPD);
        }
        
        mpwPrimeDieList = new List<MPW_Prime_Die__c>();
        
        for(MPW_Change_Request__c ch : mpwChangeReqListExtraDies) {
            Integer extraQuantityDie = 0;
            Integer extraQuantityWafer = 0;
            MPW_Extra_Die__c mpwExtraDie = new MPW_Extra_Die__c();
            MPW_Prime_Die__c mpwpd = mapIdToPrimeDie.get(ch.MPW_Prime_Die__c);
            
            if(!tempList.isEmpty()) {  
                if(mapNumberToExtraDie.get(ch.MPW_Form_Name__c).size() == 0) {
                    mpwExtraDie.Extra_Wafer_Id__c = ch.MPW_Form_Name__c + '-' + '01';
                    mpwExtraDie.Extra_Die_Id__c = ch.MPW_Form_Name__c + '-' + '01';
                } else {
                    List<String> number1 = new List<String>();
                    number1 = mapNumberToExtraDie.get(ch.MPW_Form_Name__c)[0].Extra_Wafer_Id__c.split('-');
                    String num = number1[3].substring(Integer.valueOf(number1[3].length()-1), Integer.valueOf(number1[3].length()));
                    Integer counter = Integer.valueOf(num) + 1;
                    mpwExtraDie.Extra_Wafer_Id__c = ch.MPW_Form_Name__c + '-' + '0' + String.valueOf(counter);
                    mpwExtraDie.Extra_Die_Id__c = ch.MPW_Form_Name__c + '-' + '0' + String.valueOf(counter);
                }
            }
            else{
                mpwExtraDie.Extra_Wafer_Id__c = ch.MPW_Form_Name__c + '-' + '01';
                mpwExtraDie.Extra_Die_Id__c = ch.MPW_Form_Name__c + '-' + '01';
            }
            
            List<String> dietowaferlist = iglfMap.get(mpwpd.Geometry__c).DieToWaferConv__c.split('/');
            
            if(ch.Address2_Quantity_Delivery_In_DIE_Form__c == null && ch.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                extraQuantityDie = Integer.valueOf(ch.Address1_Quantity_Delivery_In_DIE_Form__c);
            }
            if(ch.Address2_Quantity_Delivery_In_DIE_Form__c != null && ch.Address3_Quantity_Delivery_In_DIE_Form__c == null) {
                extraQuantityDie = Integer.valueOf(ch.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(ch.Address2_Quantity_Delivery_In_DIE_Form__c);
            }  
            if(ch.Address2_Quantity_Delivery_In_DIE_Form__c != null && ch.Address3_Quantity_Delivery_In_DIE_Form__c != null) {
                extraQuantityDie = Integer.valueOf(ch.Address1_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(ch.Address2_Quantity_Delivery_In_DIE_Form__c) + Integer.valueOf(ch.Address3_Quantity_Delivery_In_DIE_Form__c);
            }               
            
            if(ch.Address2_Quantity_Delivery_In_WAFER_Form__c == null && ch.Address3_Quantity_Delivery_In_WAFER_Form__c == null) {
                extraQuantityWafer = Integer.valueOf(ch.Address1_Quantity_Delivery_In_WAFER_Form__c);
            }
            if(ch.Address2_Quantity_Delivery_In_WAFER_Form__c != null && ch.Address3_Quantity_Delivery_In_WAFER_Form__c == null) {
                extraQuantityWafer = Integer.valueOf(ch.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(ch.Address2_Quantity_Delivery_In_WAFER_Form__c);
            }  
            if(ch.Address2_Quantity_Delivery_In_WAFER_Form__c != null && ch.Address3_Quantity_Delivery_In_WAFER_Form__c != null) {
                extraQuantityWafer = Integer.valueOf(ch.Address1_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(ch.Address2_Quantity_Delivery_In_WAFER_Form__c) + Integer.valueOf(ch.Address3_Quantity_Delivery_In_WAFER_Form__c);
            }
            
            //mpwpd.Extra_Die_Qty__c = mpwpd.Extra_Die_Qty__c + extraQuantityDie;
            //mpwpd.Extra_Wafer_Qty__c = mpwpd.Extra_Wafer_Qty__c + extraQuantityWafer;           
            
            if(mpwpd.Category__c == 'Customer') {
                
                //Added by Kanishk - June 14, 2017: Option C2 calculation for ExtraDie
                Set<String> setSubDeviceExtractionGeometry = new Set<String>(); 
                for(MPW_Sub_Device_Extraction_Geometry__c cs : [SELECT Name, Geometry__c FROM MPW_Sub_Device_Extraction_Geometry__c]) {
                    setSubDeviceExtractionGeometry.add(cs.Geometry__c.toLowerCase());
                }
               
                 if((mpwpd.Geometry__c!= null && setSubDeviceExtractionGeometry.contains(mpwpd.Geometry__c.toLowerCase())) && Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) != 0){
                   //mpwExtraDie.OPTION_C2__c = (Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) - 1) * (cglfMap.get(mpwpd.Geometry__c).Sub_Devices_Extraction__c) * (Integer.valueOf(ch.Extra_Die_Quantity__c)/50);
                   mpwExtraDie.OPTION_C2__c = (Integer.valueOf(mpwpd.Sub_Devices_Extraction__c) - 1) * (cglfMap.get(mpwpd.Geometry__c).Sub_Devices_Extraction__c) * (extraQuantityDie/50);
                } 
                //End OPTION_C2__c calculation
                
                mpwExtraDie.Extra_Die_Qty__c = ch.Extra_Die_Quantity__c; //extraQuantityDie + (extraQuantityWafer * 50);
                mpwExtraDie.Extra_Wafer_Qty__c = ch.Extra_Wafer_Qty__c; //(extraQuantityDie + (extraQuantityWafer*50))/50;
                mpwExtraDie.Extra_Die_B__c = (extraQuantityDie + (extraQuantityWafer*50))/50 * cglfMap.get(mpwpd.Geometry__c).ExtraDice_B__c;
            } else {
                
              //  mpwExtraDie.Extra_Die_B__c = ((extraQuantityDie + (extraQuantityWafer*50)) * iglfMap.get(mpwpd.Geometry__c).Wafer__c)  / Integer.valueOf(dietowaferlist[1]);
                mpwExtraDie.Extra_Die_B__c=  calculateExtraDieB(mpwpd,this.mapInternalGuidelineFactorCS,true,extraQuantityDie,extraQuantityWafer);
              
                mpwExtraDie.Extra_Die_Qty__c = ch.Extra_Die_Quantity__c; //extraQuantityDie + (extraQuantityWafer*50);
                mpwExtraDie.Extra_Wafer_Qty__c = ch.Extra_Wafer_Qty__c; //(extraQuantityDie  + (extraQuantityWafer*50))/50; 
            }
            
            if(ch.Use_Inventory_Wafers__c) {
                mpwExtraDie.Extra_Die_Type__c = 'Use Inventory Wafers';
            } else if(ch.Start_New_Wafers__c) {
                mpwExtraDie.Extra_Die_Type__c = 'Start New Wafers';
            }            
            
            mpwExtraDie.Address1_Quantity_Delivery_In_DIE_Form__c = ch.Address1_Quantity_Delivery_In_DIE_Form__c;
            mpwExtraDie.Address1_Quantity_Delivery_In_WAFER_Form__c = ch.Address1_Quantity_Delivery_In_WAFER_Form__c;
            mpwExtraDie.Address1_ShortLoop_Wafer__c = ch.Address1_ShortLoop_Wafer__c;
            mpwExtraDie.Address2_Quantity_Delivery_In_DIE_Form__c = ch.Address2_Quantity_Delivery_In_DIE_Form__c;
            mpwExtraDie.Address2_Quantity_Delivery_In_WAFER_Form__c= ch.Address1_Quantity_Delivery_In_DIE_Form__c;
            mpwExtraDie.Address2_ShortLoop_Wafer__c = ch.Address2_ShortLoop_Wafer__c;
            mpwExtraDie.Address3_Quantity_Delivery_In_DIE_Form__c = ch.Address3_Quantity_Delivery_In_DIE_Form__c;
            mpwExtraDie.Address3_Quantity_Delivery_In_WAFER_Form__c= ch.Address3_Quantity_Delivery_In_WAFER_Form__c;
            mpwExtraDie.Address3_ShortLoop_Wafer__c= ch.Address3_ShortLoop_Wafer__c;
            mpwExtraDie.MPW_Prime_Die__c = ch.MPW_Prime_Die__c;
            mpwExtraDie.Remarks__c = ch.Remarks__c;
            mpwExtraDie.Requested_On__c = ch.CreatedDate;
            mpwExtraDie.Approved_On__c = ch.Approved_On__c;
            mpwExtraDie.Requested_By__c = mapIdToLoginID.get(ch.OwnerId);
            mpwExtraDie.Requestor_Name__c = mapIdToName.get(ch.OwnerId) + '(' + mapIdToLoginID.get(ch.OwnerId) + ')';
            
            mpwExtraDie.Operation_Type__c = 'Insert';
            mpwExtraDieList.add(mpwExtraDie);
            
            mpwpd.isExtraDieRequest__c = true;
            mpwpd.Operation_Type__c = '';
            if(mpwpd.Extra_Die_Qty_Cumulative__c == null) {
                mpwpd.Extra_Die_Qty_Cumulative__c = 0;
            }
            System.debug(mpwpd.Extra_Die_Qty_Cumulative__c);
            mpwpd.Extra_Die_Qty_Cumulative__c += ch.Extra_Die_Quantity__c;
            
             //Kanishk : Calculate Extra Die B as per MPW Internal Guideline factor
            
            mpwPrimeDieList.add(mpwpd); 
        }
        
        if(!mpwPrimeDieList.isEmpty()) {
            update mpwPrimeDieList;
        }
        
        if(!mpwExtraDieList.isEmpty()) {
            insert mpwExtraDieList;
        }
    }
}